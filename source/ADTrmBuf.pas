(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADTRMBUF.PAS 4.06                   *}
{*********************************************************}
{*         Terminal: Screen buffer support class         *}
{*********************************************************}

unit ADTrmBuf;

interface

{Notes: The TadTerminalArray class defines a matrix (rows by columns)
        for storing a particular attribute of a terminal. The
        attributes consist of
          - the characters that should be shown on the screen
          - the charset ids
          - the colors for the characters
          - the colors for the background
          - a set of display flags (invisible, blink, etc)
        The array class doesn't 'know' about the values it stores, it
        just knows the size of the values (1, 2, or 4 bytes, default
        1), and knows how to properly resize to take account of
        changes in row or column count.

        This class only knows about item sizes of 1, 2 or 4. The class
        cannot be extended to other sizes that are not powers-of-two.

        All row and column numbers are assumed to be zero-based. This
        class is designed to be used internally by the terminal buffer
        class. Consequently NO RANGE CHECKING IS DONE, unless the
        unit is deliberately compiled with $R+.

        A lot of methods have a case statement on the item size.
        Although the code in each case switch block is duplicated, it
        has been written like this to make the execution more
        efficient. Multiplication by literal 2 or 4 is at least an
        order of magnitude faster than multiplying by an object field
        value.

     The TAdTerminalBuffer class defines a buffer for storing the
        data required to display a terminal display. Essentially, this
        consists of
          - the characters that should be shown on the screen
          - the charset ids (word values)
          - the color for the characters (TColor values)
          - the color for the background (TColor values)
          - a set of display flags (invisible, blink, etc) (bytes)
        To make things more complex, the characters themselves can be
        ANSI or wide/UNICODE.

        There are two views of the data: the "scrollback view" and the
        "display view". The scrollback view shows a history of
        characters/attributes/etc that have scrolled off the top of
        the display view. To make the access to the display view
        easier, there is a pointer to the start of the displayed view.
        There are typically more rows in the scrollback view than in
        the display view (otherwise there wouldn't be anything to
        scroll back through). The number of columns in both the
        scrollback and display views is the same.

        The methods implemented allow strings of characters to be
        written to the buffer, colors to be set, attributes to be
        defined. The class maintains a logical cursor and so also
        supports cursor movement, scrolling, editing, and the like.

        Notice that all row and column numbers external to this class
        are assumed to be one-based. Internally to this class they
        are zero-based for faster computation and are converted at the
        entry/exit of the relevant routines. Also, externally, it is
        only the display view that has positive row numbers. The
        scrollback view uses negative numbers. For example, by default
        there are 200 lines in the scrollback view and 24 lines in the
        display view. Externally these would be known as rows -175..0
        and 1..24, and internally as 0..175 and 176..199.

        External row and column numbers generally refer to the current
        scrolling region. If there is none, or it is inactive, the
        external row and column numbers are counted from the upper
        left corner (1, 1). If a scrolling region is in force,
        external row and column numbers are counted from the upper
        left corner of the scrolling region, not the whole display.
        The row and column numbers are said to be relative to the
        scrolling region, not absolute to the display as a whole.
        Generally, the application sending control sequences to the
        terminal will take account of this and there is nothing to
        worry about. However, to simplify the coding of the redrawing
        of the visual terminal, the methods that return an invalid
        rect provide *absolute* row and column numbers, not relative
        ones.

        UseAutoWrap and UseAutoWrapDelay: automatic wrapping means
        that characters being written to the screen automatically wrap
        at the final column. For example, on an 80-column display if
        we write 'abc' starting at column 79, then 'a' appears at
        column 79, 'b' at col 80, and 'c' at col 1 on the next line.
        If autowrap was off, the 'c' wouldn't appear or would
        overwrite the 'b'. UseAutoWrapDelay encodes the behavior where
        the text cursor doesn't move when you write a character at the
        last column, it will only move when you write the next char.
        So, if AutoWrap is on and UseAutoWrapDelay is off, writing
        'abc' at column 79 would proceed as follows:

        Write 'a' at 79, move cursor to 80
        Write 'b' at 80, move cursor to 1 on the next line
        Write 'c' at 1, move cursor to 2

        With UseAutoWrapDelay on the following occurs:

        Write 'a' at 79, move cursor to 80
        Write 'b' at 80, do not move cursor
        Move cursor to 1 on the next line, write 'c' at 1, move cursor
           to 2

        The important difference is that the cursor can move backwards
        in the second case prior to attempting to write the 'c',
        whereas in the first case it's too late. Note that
        UseAutoWrapDelay is only used if AutoWrap is on. The internal
        field used to store whether this case applies is the
        FBeyondMargin boolean.
}

{$I AWDEFINE.INC}

{$Z-}

{$IFOPT R+}
{$DEFINE UseRangeChecks}
{$ENDIF}

uses
  SysUtils,
  Windows,
  Classes,
  Graphics,
  OOMisc, AdExcept;

const
  {Buffer default property values}
  adc_TermBufForeColor = clSilver;
  adc_TermBufBackColor = clBlack;
  adc_TermBufColCount = 80;
  adc_TermBufRowCount = 24;
  adc_TermBufScrollRowCount = 200;
  adc_TermBufUseAbsAddress = true; {use absolute rows/col values}
  adc_TermBufUseAutoWrap = true; {chars wrap at end of line}
  adc_TermBufUseAutoWrapDelay = true; {..but delay slightly}
  adc_TermBufUseInsertMode = false; {no insert mode}
  adc_TermBufUseNewLineMode = false; {LF char is a pure linefeed}
  adc_TermBufUseScrollRegion = false; {no scroll region used}

type
  TadtWordArray = array [0..MaxInt div sizeof(word) - 1] of word;
  PadtWordArray = ^TadtWordArray;
  TadtLongArray = array [0..MaxInt div sizeof(Integer) - 1] of Integer;
  PadtLongArray = ^TadtLongArray;

  TAdTerminalCharAttr = (  {character attributes}
         tcaBold,          {..bold}
         tcaUnderline,     {..underlined}
         tcaStrikethrough, {..struck through as if deleted}
         tcaBlink,         {..blinking}
         tcaReverse,       {..back/foreground colors reversed}
         tcaInvisible,     {..invisible}
         tcaSelected);     {..selected}
  TAdTerminalCharAttrs = set of TAdTerminalCharAttr;

  TAdScrollRowsNotifyEvent =
     procedure (aSender : TObject;
                aCount, aTop, aBottom : integer) of object;

  TAdOnCursorMovedEvent =                                              
     procedure (ASender  : TObject;                                    
                Row, Col : integer) of object;                         

  TadTerminalArray = class
    private
      FActColCount : integer;
      FColCount    : integer;
      FDefaultItem : Integer;
      FItems       : PAnsiChar;
      FItemSize    : integer;
      FRowCount    : integer;
    protected
      procedure taSetColCount(aNewCount : integer);
      procedure taSetRowCount(aNewCount : integer);

      procedure taClearRows(aBuffer : PAnsiChar;
                            aActColCount : integer;
                            aStartRow, aEndRow : integer);
      procedure taGrowArray(aRowCount,
                            aColCount, aActColCount : integer);
    public
      constructor Create(aItemSize : integer);
      destructor Destroy; override;

      procedure Clear;
        {-clear the entire array, filling with DefaultItem}

      procedure ClearItems(aRow : integer;
                           aFromCol, aToCol : integer);
        {-clear the row in between the two inclusive columns, filling
          with DefaultItem (equivalent to 'erase')}

      procedure DeleteItems(aCount : integer;
                            aRow   : integer;
                            aCol   : integer);
        {-delete aCount default items at aRow , aCol; items currently
          beyond these positions are pulled left, and their original
          positions filled with default items; this action does not
          extend beyond the row}


      function GetItemPtr(aRow, aCol : integer) : pointer;
        {-return a pointer to the item at aRow, aCol; caller must
          properly dereference, and not memory overread}

      procedure InsertItems(aCount : integer;
                            aRow   : integer;
                            aCol   : integer);
        {-insert aCount default items at aRow , aCol; items currently
          in these positions are pushed right, but not beyond the row
          boundary}

      procedure ReplaceItems(aOldItem : pointer;           {new !!.02}
                             aNewItem : pointer);
        {-replace every incidence of aOldItem with aNewItem}

      procedure SetDefaultItem(aDefaultItem : pointer);
        {-define the default item to be used to fill new items, eg,
          during scrolling, clearing or resizing}

      procedure ScrollRows(aCount : integer;
                           aStartRow, aEndRow : integer);
        {-scroll the data by aCount rows, filling new rows with
          DefaultItem; scroll just between aStartRow and aEndRow
          inclusive; if aCount is +ve it means scroll upwards (ie, the
          usual sense), if -ve scroll downwards}

      procedure WriteItems(aItems : pointer;
                           aCount : integer;
                           aRow, aCol : integer);
        {-write aCount items to aRow, aCol, without wrapping at the
          end of the row}

      procedure WriteDupItems(aItem  : pointer;
                              aCount : integer;
                              aRow, aCol : integer);
        {-write aCount copies of aItem to aRow, aCol, without wrapping
          at the end of the row}

      property ColCount : integer read FColCount write taSetColCount;
      property ItemSize : integer read FItemSize;
      property RowCount : integer read FRowCount write taSetRowCount;
  end;

type
  TAdTerminalBuffer = class
    private
      FAttr         : TAdTerminalCharAttrs; {current attributes}
      FBackColor    : TColor;   {current background color}
      FBeyondMargin : boolean;  {true if cursor's beyond right margin}
      FCharSet      : byte;     {current charset}
      FColCount     : integer;  {count of columns in both views}
      FCursorCol    : integer;  {current internal cursor col position}
      FCursorMoved  : boolean;  {true if cursor has moved}
      FCursorRow    : integer;  {current internal cursor row position}
      FDefAnsiChar  : AnsiChar; {default ANSI character}
      FDefAttr      : TAdTerminalCharAttrs; {default attributes}
      FDefCharSet   : byte;     {default charset}
      FDefBackColor : TColor;   {default background color}
      FDefForeColor : TColor;   {default foreground color}
      FDefWideChar  : WideChar; {default wide character}
      FDisplayOriginCol : integer; {column origin of addressable area}
      FDisplayOriginRow : integer; {row origin of addressable area}
      FDisplayColCount  : integer; {column count in addressable area}
      FDisplayRowCount  : integer; {row count in addressable area}
      FForeColor    : TColor;   {current foreground color}
      FHorzTabStops : PByteArray; {bitset of horizontal tab stops}
      FInvRectList  : pointer;  {list of invalid rects}
      FOnScrollRows : TAdScrollRowsNotifyEvent;
      FRowCount     : integer;  {count of rows in display view}
      FSRStartRow   : integer;  {start row of scrolling region}
      FSREndRow     : integer;  {end row of scrolling region}
      FSVRowCount   : integer;  {count of rows in scrollback view}
      FUseAbsAddress: boolean; {true if absolute values for row/col}
      FUseAutoWrap  : boolean;  {true if chars wrap to next line}
      FUseAutoWrapDelay: boolean; {true if cursor stays at last col}
      FUseInsertMode   : boolean; {true if insert rather than replace}
      FUseNewLineMode  : boolean; {true if LF means CR+LF}
      FUseScrollRegion : boolean; {true if limit to scroll region}
      FUseWideChars : boolean;  {true if expecting UNICODE chars}
      FVertTabStops : PByteArray; {bitset of vertical tab stops}

      FCharMatrix   : TAdTerminalArray;    {matrix of chars}
      FCharSetMatrix: TAdTerminalArray;    {matrix of charsets}
      FAttrMatrix   : TAdTerminalArray;    {matrix of attrs}
      FForeColorMatrix : TAdTerminalArray; {matrix of forecolors}
      FBackColorMatrix : TAdTerminalArray; {matrix of backcolors}

      FOnCursorMoved : TAdOnCursorMovedEvent; {Cursor moved event}
      FTerminalHandle : THandle; {Handle of owning terminal}             {!!.05}     

    protected
      function tbGetCol : integer;
      function tbGetOriginCol : integer;
      function tbGetOriginRow : integer;
      function tbGetRow : integer;

      procedure tbSetBackColor(aValue : TColor);
      procedure tbSetCharSet(aValue : byte);
      procedure tbSetDefAnsiChar(aValue : AnsiChar);
      procedure tbSetDefBackColor(aValue : TColor);            
      procedure tbSetDefForeColor(aValue : TColor);            
      procedure tbSetForeColor(aValue : TColor);
      procedure tbSetSVRowCount(aNewCount : integer);
      procedure tbSetCol(aCol : integer);
      procedure tbSetColCount(aNewCount : integer);
      procedure tbSetRow(aRow : integer);
      procedure tbSetRowCount(aNewCount : integer);
      procedure tbSetUseScrollRegion(aValue : boolean);

      procedure tbInvalidateRect(aFromRow, aFromCol,
                                 aToRow, aToCol : integer);

      function tbCvtToInternalCol(aCol : integer;
                                  aAbsolute : boolean) : integer;
      function tbCvtToInternalRow(aRow : integer;
                                  aAbsolute : boolean) : integer;
      function tbCvtToExternalCol(aCol : integer;
                                  aAbsolute : boolean) : integer;
      function tbCvtToExternalRow(aRow : integer;
                                  aAbsolute : boolean) : integer;

      function tbAtLastColumn : boolean;
      procedure tbMoveCursorLeftRight(aDirection : integer;
                                      aWrap      : boolean;
                                      aScroll    : boolean);
      procedure tbMoveCursorUpDown(aDirection : integer;
                                   aScroll    : boolean);
      procedure tbReallocBuffers(aNewRowCount : integer;
                                 aNewColCount : integer);
      procedure tbScrollRows(aCount, aTop, aBottom : integer);
      procedure tbFireOnCursorMovedEvent;                              

    public
      constructor Create(aUseWideChars : boolean);
      destructor Destroy; override;

      {---METHODS---}
      {character attributes}
      procedure GetCharAttrs(var aValue : TAdTerminalCharAttrs);
      procedure GetDefCharAttrs(var aValue : TAdTerminalCharAttrs);
      procedure SetDefCharAttrs(const aValue : TAdTerminalCharAttrs);
      procedure SetCharAttrs(const aValue : TAdTerminalCharAttrs);

      {cursor movement}
      procedure MoveCursorDown(aScroll : boolean);
      procedure MoveCursorLeft(aWrap : boolean; aScroll : boolean);
      procedure MoveCursorRight(aWrap : boolean; aScroll : boolean);
      procedure MoveCursorUp(aScroll : boolean);
      procedure SetCursorPosition(aRow, aCol : integer);

      {insertion/deletion}
      procedure DeleteChars(aCount : integer);
      procedure DeleteLines(aCount : integer);
      procedure InsertChars(aCount : integer);
      procedure InsertLines(aCount : integer);

      {erasing}
      procedure EraseAll;
      procedure EraseChars(aCount : integer);
      procedure EraseFromBOW;
      procedure EraseFromBOL;
      procedure EraseLine;
      procedure EraseScreen;
      procedure EraseToEOL;
      procedure EraseToEOW;

      {horizontal tab stop control}
      procedure SetHorzTabStop;
      procedure ClearHorzTabStop;
      procedure ClearAllHorzTabStops;
      procedure DoHorzTab;
      procedure DoBackHorzTab;

      {vertical tab stop control}
      procedure SetVertTabStop;
      procedure ClearVertTabStop;
      procedure ClearAllVertTabStops;
      procedure DoVertTab;
      procedure DoBackVertTab;

      {scrolling regions}
      procedure SetScrollRegion(aTopRow, aBottomRow : integer);

      {write character/string}
      procedure WriteChar(aCh : AnsiChar);
      procedure WriteString(const aSt : string); overload;
      procedure WriteString(const aSt : AnsiString); overload;

      {miscellaneous special processing}
      procedure DoBackspace;
      procedure DoCarriageReturn;
      procedure DoLineFeed;
      procedure Reset;

      {get buffer information}
      function GetLineCharPtr(aRow : integer) : pointer;
      function GetLineAttrPtr(aRow : integer) : pointer;
      function GetLineForeColorPtr(aRow : integer) : pointer;
      function GetLineBackColorPtr(aRow : integer) : pointer;
      function GetLineCharSetPtr(aRow : integer) : pointer;

      {getting information about changes}
      function HasCursorMoved : boolean;
      function HasDisplayChanged : boolean;
      function GetInvalidRect(var aRect : TRect) : boolean;

      {Misc. Internal}
      procedure RegisterTerminalHandle (AHandle : THandle);              {!!.05}
      procedure DeregisterTerminalHandle;                                {!!.05}

      {---PROPERTIES---}
      {color, charsets}
      property BackColor : TColor read FBackColor write tbSetBackColor;
      property CharSet : byte read FCharSet write tbSetCharSet;
      property DefAnsiChar : AnsiChar read FDefAnsiChar write tbSetDefAnsiChar;
      property DefBackColor : TColor read FDefBackColor write tbSetDefBackColor;
      property DefCharSet : byte read FDefCharSet write FDefCharSet;
      property DefForeColor : TColor read FDefForeColor write tbSetDefForeColor;
      property ForeColor : TColor read FForeColor write tbSetForeColor;

      {scrollback view extent}
      property SVRowCount : integer read FSVRowCount write tbSetSVRowCount;

      {display view properties}
      property Col : integer read tbGetCol write tbSetCol;
      property ColCount : integer read FColCount write tbSetColCount;
      property OriginCol : integer read tbGetOriginCol;
      property OriginRow : integer read tbGetOriginRow;
      property Row : integer read tbGetRow write tbSetRow;
      property RowCount : integer read FRowCount write tbSetRowCount;

      property UseAbsAddress : boolean
                  read FUseAbsAddress write FUseAbsAddress;
      property UseAutoWrap : boolean
                  read FUseAutoWrap write FUseAutoWrap;
      property UseAutoWrapDelay : boolean
                  read FUseAutoWrapDelay write FUseAutoWrapDelay;
      property UseInsertMode : boolean
                  read FUseInsertMode write FUseInsertMode;
      property UseNewLineMode : boolean
                  read FUseNewLineMode write FUseNewLineMode;
      property UseScrollRegion : boolean
                  read FUseScrollRegion write tbSetUseScrollRegion;
      property UseWideChars : boolean read FUseWideChars;

      property OnScrollRows : TAdScrollRowsNotifyEvent
                  read FOnScrollRows write FOnScrollRows;

      { OnCursorMoved
        This property is used to notify the TAdTerminal component when
        the cursor moves.  It should not be used for your own purposes
        as that may cause unexpected behaviour in the terminal }       
        
      property OnCursorMoved : TAdOnCursorMovedEvent                   
                  read FOnCursorMoved write FOnCursorMoved;            
  end;

procedure RaiseTerminalException(aClass : EAdTerminalClass;
                                 aErrorCode : Integer;
                           const aStrParam1 : string;
                           const aStrParam2 : string;
                           const aStrParam3 : string;
                                 aIntParam1 : Integer;
                                 aIntParam2 : Integer;
                                 aIntParam3 : Integer);

implementation

type
  PByte = ^byte;
  PWord = ^word;
  PLongint = ^Integer;

{===Exceptions=======================================================}
procedure RaiseTerminalException(aClass : EAdTerminalClass;
                                 aErrorCode : Integer;
                           const aStrParam1 : string;
                           const aStrParam2 : string;
                           const aStrParam3 : string;
                                 aIntParam1 : Integer;
                                 aIntParam2 : Integer;
                                 aIntParam3 : Integer);
begin
  raise aClass.Create(aErrorCode, false);
end;
{====================================================================}



{===TadTerminalArray=================================================}
constructor TadTerminalArray.Create(aItemSize : integer);
begin
  inherited Create;
  {save a valid item size}
  case aItemSize of
    1, 2, 4 : FItemSize := aItemSize;
  else
    FItemSize := 1;
  end;{case}
  {set the actual column count to -1, which means 'uncalculated'}
  FActColCount := -1;
end;
{--------}
destructor TadTerminalArray.Destroy;
begin
  if (FItems <> nil) then begin
    FreeMem(FItems, RowCount * FActColCount * ItemSize);
  end;
  inherited Destroy;
end;
{--------}
procedure TadTerminalArray.Clear;
begin
  if (FItems <> nil) then
    taClearRows(FItems, FActColCount, 0, pred(RowCount));
end;
{--------}
procedure TadTerminalArray.ClearItems(aRow : integer;
                                      aFromCol, aToCol : integer);
var
  Walker    : PAnsiChar;
  Value     : Integer;
  i         : integer;
begin
  Walker := @FItems[((aRow * FActColCount) + aFromCol) * ItemSize];
  case ItemSize of
    1 : FillChar(Walker^, succ(aToCol - aFromCol), byte(FDefaultItem));
    2 : begin
          Value := word(FDefaultItem);
          for i := 0 to (aToCol - aFromCol) do begin
            PWord(Walker)^ := Value;
            inc(Walker, 2);
          end;
        end;
    4 : begin
          Value := FDefaultItem;
          for i := 0 to (aToCol - aFromCol) do begin
            PLongint(Walker)^ := Value;
            inc(Walker, 4);
          end;
        end;
  end;{case}
end;
{--------}
procedure TadTerminalArray.DeleteItems(aCount : integer;
                                       aRow   : integer;
                                       aCol   : integer);
var
  ItemCount : integer;
  Distance  : integer;
  FromPtr   : PAnsiChar;
  ToPtr     : PAnsiChar;
  Value     : Integer;
  i         : integer;
begin
  {$IFDEF UseRangeChecks}
  {Range check aRow and aCol}
  if (aRow < 0) or (aRow >= RowCount) or
     (aCol < 0) or (aCol >= ColCount) then
    raise Exception.Create(
             Format('TadTerminalArray.DeleteItems: either row %d or col %d is out of range',
                    [aRow, aCol]));
  {$ENDIF}
  Distance := ColCount - aCol;
  if (Distance > aCount) then
    Distance := aCount;
  ItemCount := ColCount - aCol - Distance;
  case ItemSize of
    1 : begin
          ToPtr := @FItems[(aRow * FActColCount) + aCol];
          if (ItemCount > 0) then begin
            FromPtr := ToPtr + Distance;
            Move(FromPtr^, ToPtr^, ItemCount);
          end;
          ToPtr := ToPtr + ItemCount;
          FillChar(ToPtr^, Distance, byte(FDefaultItem));
        end;
    2 : begin
          ToPtr := @FItems[((aRow * FActColCount) + aCol) * 2];
          if (ItemCount > 0) then begin
            FromPtr := ToPtr + (Distance * 2);
            Move(FromPtr^, ToPtr^, ItemCount * 2);
          end;
          ToPtr := ToPtr + (ItemCount * 2);
          Value := word(FDefaultItem);
          for i := 0 to pred(Distance) do begin
            PWord(ToPtr)^ := Value;
            inc(ToPtr, 2);
          end;
        end;
    4 : begin
          ToPtr := @FItems[((aRow * FActColCount) + aCol) * 4];
          if (ItemCount > 0) then begin
            FromPtr := ToPtr + (Distance * 4);
            Move(FromPtr^, ToPtr^, ItemCount * 4);
          end;
          ToPtr := ToPtr + (ItemCount * 4);
          Value := FDefaultItem;
          for i := 0 to pred(Distance) do begin
            PLongint(ToPtr)^ := Value;
            inc(ToPtr, 4);
          end;
        end;
  end;{case}
end;
{--------}
function TadTerminalArray.GetItemPtr(aRow, aCol : integer) : pointer;
begin
  {$IFDEF UseRangeChecks}
  {Range check aRow and aCol}
  if (aRow < 0) or (aRow >= RowCount) or
     (aCol < 0) or (aCol >= ColCount) then
    raise Exception.Create(
             Format('TadTerminalArray.GetItemPtr: either row %d or col %d is out of range',
                    [aRow, aCol]));
  {$ENDIF}
  if FItems = nil then
    Result := nil
  else begin
    case ItemSize of
      1 : Result := @FItems[(aRow * FActColCount) + aCol];
      2 : Result := @FItems[(aRow * FActColCount * 2) + (aCol * 2)];
      4 : Result := @FItems[(aRow * FActColCount * 4) + (aCol * 4)];
    else
      raise Exception.Create('TadTerminalArray.GetItemPtr: invalid item size');
//      Result := nil;
    end;{case}
  end;
end;
{--------}
procedure TadTerminalArray.InsertItems(aCount : integer;
                                       aRow   : integer;
                                       aCol   : integer);
var
  ItemCount : integer;
  Distance  : integer;
  FromPtr   : PAnsiChar;
  ToPtr     : PAnsiChar;
  Value     : Integer;
  i         : integer;
begin
  {$IFDEF UseRangeChecks}
  {Range check aRow and aCol}
  if (aRow < 0) or (aRow >= RowCount) or
     (aCol < 0) or (aCol >= ColCount) then
    raise Exception.Create(
             Format('TadTerminalArray.InsertItems: either row %d or col %d is out of range',
                    [aRow, aCol]));
  {$ENDIF}
  Distance := ColCount - aCol;
  if (Distance > aCount) then
    Distance := aCount;
  ItemCount := ColCount - aCol - Distance;
  case ItemSize of
    1 : begin
          FromPtr := @FItems[(aRow * FActColCount) + aCol];
          if (ItemCount > 0) then begin
            ToPtr := FromPtr + Distance;
            Move(FromPtr^, ToPtr^, ItemCount);
          end;
          FillChar(FromPtr^, Distance, byte(FDefaultItem));
        end;
    2 : begin
          FromPtr := @FItems[((aRow * FActColCount) + aCol) * 2];
          if (ItemCount > 0) then begin
            ToPtr := FromPtr + (Distance * 2);
            Move(FromPtr^, ToPtr^, ItemCount * 2);
          end;
          Value := word(FDefaultItem);
          for i := 0 to pred(Distance) do begin
            PWord(FromPtr)^ := Value;
            inc(FromPtr, 2);
          end;
        end;
    4 : begin
          FromPtr := @FItems[((aRow * FActColCount) + aCol) * 4];
          if (ItemCount > 0) then begin
            ToPtr := FromPtr + (Distance * 4);
            Move(ToPtr^, FromPtr^, ItemCount * 4);
          end;
          Value := FDefaultItem;
          for i := 0 to pred(Distance) do begin
            PLongint(FromPtr)^ := Value;
            inc(FromPtr, 4);
          end;
        end;
  end;{case}
end;
{--------}
procedure TadTerminalArray.ReplaceItems(aOldItem : pointer;
                                        aNewItem : pointer);
                                                           {new !!.02}
var
  Walker    : PAnsiChar;
  OldValue  : Integer;
  NewValue  : Integer;
  Row       : integer;
  i         : integer;
begin
  case ItemSize of
    1 : begin
          OldValue := PByte(aOldItem)^;
          NewValue := PByte(aNewItem)^;
        end;
    2 : begin
          OldValue := PWord(aOldItem)^;
          NewValue := PWord(aNewItem)^;
        end;
    4 : begin
          OldValue := PLongint(aOldItem)^;
          NewValue := PLongint(aNewItem)^;
        end;
  else
    {dummy statements that will never get executed, however they fool
     the warning analyzer in the compiler}
    OldValue := 0;
    NewValue := 0;
  end;{case}
  for Row := 0 to pred(RowCount) do begin
    Walker := @FItems[(Row * FActColCount) * ItemSize];
    case ItemSize of
      1 : for i := 0 to pred(ColCount) do begin
            if (PByte(Walker)^ = OldValue) then
               PByte(Walker)^ := NewValue;
            inc(Walker);
          end;
      2 : for i := 0 to pred(ColCount) do begin
            if (PWord(Walker)^ = OldValue) then
               PWord(Walker)^ := NewValue;
            inc(Walker, 2);
          end;
      4 : for i := 0 to pred(ColCount) do begin
            if (PLongint(Walker)^ = OldValue) then
               PLongint(Walker)^ := NewValue;
            inc(Walker, 4);
          end;
    end;{case}
  end;
end;
{--------}
procedure TadTerminalArray.ScrollRows(aCount : integer;
                                      aStartRow, aEndRow : integer);
var
  ThisRow : integer;
  FromPtr : PAnsiChar;
  ToPtr   : PAnsiChar;
  i       : integer;
begin
  {$IFDEF UseRangeChecks}
  {Range check aStartRow and aEndRow}
  if (aStartRow < 0) or (aStartRow >= RowCount) or
     (aEndRow < 0) or (aEndRow >= RowCount) then
    raise Exception.Create(
             Format('TadTerminalArray.ScrollRows: either start row %d or end row %d is out of range',
                    [aStartRow, aEndRow]));
  {$ENDIF}
  if (FItems <> nil) and (aCount <> 0) then begin
    {make sure the end row is larger than the start row}
    if (aEndRow < aStartRow) then begin
      ThisRow := aEndRow;
      aEndRow := aStartRow;
      aStartRow := ThisRow;
    end;
    {split the code depending on whether we are scrolling upwards,
     aCount is +ve, or downwards, aCount is -ve}
    if (aCount > 0) then {scroll upwards} begin
      {if the number of rows to scroll is greater than the difference
       between the start and end rows, all we need to do is blank out
       all the rows between start and end inclusive, otherwise we have
       some scrolling to do}
      ThisRow := aStartRow;
      if (aCount <= (aEndRow - aStartRow)) then begin
        ToPtr := @FItems[ThisRow * FActColCount * ItemSize];
        FromPtr := @FItems[(ThisRow + aCount) * FActColCount * ItemSize];
        for i := 0 to (aEndRow - aStartRow - aCount) do begin
          Move(FromPtr^, ToPtr^, ColCount * ItemSize);
          inc(FromPtr, FActColCount * ItemSize);
          inc(ToPtr, FActColCount * ItemSize);
          inc(ThisRow);
        end;
      end;
      {now blank out everything from ThisRow to aEndRow}
      taClearRows(FItems, FActColCount, ThisRow, aEndRow);
    end
    else {scroll downwards} begin
      {if the number of rows to scroll is greater than the difference
       between the start and end rows, all we need to do is blank out
       all the rows between start and end inclusive, otherwise we have
       some scrolling to do}
      aCount := -aCount;
      ThisRow := aEndRow;
      if (aCount <= (aEndRow - aStartRow)) then begin
        ToPtr := @FItems[ThisRow * FActColCount * ItemSize];
        FromPtr := @FItems[(ThisRow - aCount) * FActColCount * ItemSize];
        for i := 0 to (aEndRow - aStartRow - aCount) do begin
          Move(FromPtr^, ToPtr^, ColCount * ItemSize);
          dec(FromPtr, FActColCount * ItemSize);
          dec(ToPtr, FActColCount * ItemSize);
          dec(ThisRow);
        end;
      end;
      {now blank out everything from aStartRow to ThisRow}
      taClearRows(FItems, FActColCount, aStartRow, ThisRow);
    end;
  end;
end;
{--------}
procedure TadTerminalArray.SetDefaultItem(aDefaultItem : pointer);
begin
  case ItemSize of
    1 : FDefaultItem := PByte(aDefaultItem)^;
    2 : FDefaultItem := PWord(aDefaultItem)^;
    4 : FDefaultItem := PLongint(aDefaultItem)^;
  end;
end;
{--------}
procedure TadTerminalArray.taClearRows(aBuffer : PAnsiChar;
                                       aActColCount : integer;
                                       aStartRow, aEndRow : integer);
var
  Walker     : PAnsiChar;
  Value      : Integer;
  DWORDCount : integer;
  i          : integer;
begin
  Walker := @aBuffer[aStartRow * aActColCount * ItemSize];
  if (ItemSize = 1) then
    FillChar(Walker^,
             succ(aEndRow - aStartRow) * aActColCount,
             byte(FDefaultItem))
  else begin
    if (ItemSize = 2) then begin
      Value := (FDefaultItem shl 16) + word(FDefaultItem);
      DWORDCount := (succ(aEndRow - aStartRow) * aActColCount) div 2;
    end
    else begin
      Value := FDefaultItem;
      DWORDCount := succ(aEndRow - aStartRow) * aActColCount;
    end;
    for i := 0 to pred(DWORDCount) do begin
      PLongint(Walker)^ := Value;
      inc(Walker, 4);
    end;
  end;
end;
{--------}
procedure TadTerminalArray.taGrowArray(aRowCount,
                                       aColCount,
                                       aActColCount : integer);
var
  NewArray : PAnsiChar;
  RowSize  : integer;
  NumRows  : integer;
  FromPtr  : PAnsiChar;
  ToPtr    : PAnsiChar;
  i        : integer;
begin
  {make sure we have the new actual column count: this is the external
   column count rounded up so that the actual length of a row in bytes
   is a multiple of four--this makes fills and moves much faster}
  if (aActColCount = -1) then begin
    case ItemSize of
      1 : aActColCount := ((aColCount + 3) div 4) * 4;
      2 : aActColCount := ((aColCount + 1) div 2) * 2;
      4 : aActColCount := aColCount;
    end;{case}
  end;
  {nothing to do if either the row or actual column count is zero}
  if (aRowCount = 0) or (aActColCount = 0) then
    Exit;
  {equally obvious, nothing to do if neither the row and actual column
   count have changed}
  if (aRowCount = RowCount) and (aActColCount = FActColCount) then
    Exit;
  {$IFDEF UseRangeChecks}
  {$ENDIF}
  {at this point we must allocate another array}
  GetMem(NewArray, aRowCount * aActColCount * ItemSize);
  {blank it all out using the current default item}
  taClearRows(NewArray, aActColCount, 0, pred(aRowCount));
  {if the old array existed, transfer over the data, row by row,
   starting at the bottom}
  if (FItems <> nil) then begin
    {calculate the number of bytes to copy per row}
    if (ColCount < aColCount) then
      RowSize := ColCount * ItemSize
    else
      RowSize := aColCount * ItemSize;
    {calculate the number of rows to copy}
    if (RowCount < aRowCount) then
      NumRows := RowCount
    else
      NumRows := aRowCount;
    {copy the rows}
    FromPtr := @FItems[RowCount * FActColCount * ItemSize];
    ToPtr := @NewArray[aRowCount * aActColCount * ItemSize];
    for i := pred(RowCount) downto (RowCount - NumRows) do begin
      dec(FromPtr, FActColCount * ItemSize);
      dec(ToPtr, aActColCount * ItemSize);
      Move(FromPtr^, ToPtr^, RowSize);
    end;
    {dispose of the old array}
    FreeMem(FItems, RowCount * FActColCount * ItemSize);
  end;
  {save the new array}
  FItems := NewArray;
  FActColCount := aActColCount;
end;
{--------}
procedure TadTerminalArray.taSetColCount(aNewCount : integer);
begin
  {$IFDEF UseRangeChecks}
  {Range check aNewCount}
  if (aNewCount < 0) then
    raise Exception.Create(
             Format('TadTerminalArray.taSetColCount: new col count %d is less than zero',
                    [aNewCount]));
  {$ENDIF}
  if (aNewCount <> ColCount) then begin
    taGrowArray(RowCount, aNewCount, -1);
    FColCount := aNewCount;
  end;
end;
{--------}
procedure TadTerminalArray.taSetRowCount(aNewCount : integer);
begin
  {$IFDEF UseRangeChecks}
  {Range check aNewCount}
  if (aNewCount < 0) then
    raise Exception.Create(
             Format('TadTerminalArray.taSetColCount: new col count %d is less than zero',
                    [aNewCount]));
  {$ENDIF}
  if (aNewCount <> RowCount) then begin
    taGrowArray(aNewCount, ColCount, FActColCount);
    FRowCount := aNewCount;
  end;
end;
{--------}
procedure TadTerminalArray.WriteDupItems(aItem  : pointer;
                                         aCount : integer;
                                         aRow, aCol : integer);
var
  Walker    : PAnsiChar;
  Value     : Integer;
  i         : integer;
  ItemCount : integer;
begin
  {$IFDEF UseRangeChecks}
  {Range check aRow and aCol}
  if (aRow < 0) or (aRow >= RowCount) or
     (aCol < 0) or (aCol >= ColCount) then
    raise Exception.Create(
             Format('TadTerminalArray.WriteDupItems: either row %d or col %d is out of range',
                    [aRow, aCol]));
  {$ENDIF}
  if (FItems <> nil) then begin
    ItemCount := ColCount - aCol;
    if (ItemCount > aCount) then
      ItemCount := aCount;
    case ItemSize of
      1 : FillChar(FItems[(aRow * FActColCount) + aCol],
                   ItemCount, PByte(aItem)^);
      2 : begin
            Walker := @FItems[((aRow * FActColCount) + aCol) * 2];
            Value := PWord(aItem)^;
            for i := 0 to pred(ItemCount) do begin
              PWord(Walker)^ := Value;
              inc(Walker, 2);
            end;
          end;
      4 : begin
            Walker := @FItems[((aRow * FActColCount) + aCol) * 4];
            Value := PLongint(aItem)^;
            for i := 0 to pred(ItemCount) do begin
              PLongint(Walker)^ := Value;
              inc(Walker, 4);
            end;
          end;
    end;{case}
  end;
end;
{--------}
procedure TadTerminalArray.WriteItems(aItems : pointer;
                                      aCount : integer;
                                      aRow, aCol : integer);
var
  ItemCount : integer;
begin
  {$IFDEF UseRangeChecks}
  {Range check aRow and aCol}
  if (aRow < 0) or (aRow >= RowCount) or
     (aCol < 0) or (aCol >= ColCount) then
    raise Exception.Create(
             Format('TadTerminalArray.WriteItems: either row %d or col %d is out of range',
                    [aRow, aCol]));
  {$ENDIF}
  if (FItems <> nil) then begin
    ItemCount := ColCount - aCol;
    if (ItemCount > aCount) then
      ItemCount := aCount;
    case ItemSize of
      1 : Move(aItems^,
               FItems[(aRow * FActColCount) + aCol],
               ItemCount);
      2 : Move(aItems^,
               FItems[(aRow * FActColCount * 2) + (aCol * 2)],
               ItemCount * 2);
      4 : Move(aItems^,
               FItems[(aRow * FActColCount * 4) + (aCol * 4)],
               ItemCount * 4);
    end;{case}
  end;
end;
{====================================================================}


{===Bitset routines==================================================}
procedure ADTClearAllBits(aBitset : PByteArray; aBitCount : integer);
begin
  FillChar(aBitset^, (aBitCount+7) shr 3, 0);
end;
{--------}
procedure ADTClearBit(aBitset : PByteArray; aBit : integer);
var
  BS : PAnsiChar absolute aBitset;
  P  : PAnsiChar;
  M  : byte;
begin
  P := BS + (aBit shr 3);
  M := 1 shl (byte(aBit) and 7);
  P^ := Ansichar(byte(P^) and not M);
end;
{--------}
function ADTIsBitSet(aBitset : PByteArray; aBit : integer) : boolean;
var
  BS : PAnsiChar absolute aBitset;
  P  : PAnsiChar;
  M  : byte;
begin
  P := BS + (aBit shr 3);
  M := 1 shl (byte(aBit) and 7);
  Result := (byte(P^) and M) <> 0;
end;
{--------}
function ADTReallocBitset(aBitset      : PByteArray;
                          aOldBitCount : integer;
                          aNewBitCount : integer) : PByteArray;
var
  XferBitCount : integer;
begin
  if (aNewBitCount = 0) then
    Result := nil
  else begin
    Result := AllocMem(aNewBitCount);
    if (aBitset <> nil) then begin
      if (aOldBitCount < aNewBitCount) then
        XferBitCount := aOldBitCount
      else
        XferBitCount := aNewBitCount;
      Move(aBitset^, Result^, (XferBitCount+7) shr 3);
    end;
  end;
  FreeMem(aBitset, (aOldBitCount+7) shr 3);
end;
{--------}
(***** not used yet
procedure ADTSetAllBits(aBitset : PByteArray; aBitCount : integer);
begin
  FillChar(aBitset^, (aBitCount+7) shr 3, $FF);
end;
*****)
{--------}
procedure ADTSetBit(aBitset : PByteArray; aBit : integer);
var
  BS : PAnsiChar absolute aBitSet;
  P  : PAnsiChar;
  M  : byte;
begin
  P := BS + (aBit shr 3);
  M := 1 shl (byte(aBit) and 7);
  P^ := ansichar(byte(P^) or M);
end;
{====================================================================}


{===Invalid rectangle routines==========================================}
const
  RectsPerPage = 200;
type
  PInvRect = ^TInvRect;
  TInvRect = packed record
    irNext : PInvRect;
    irRect : TRect;
  end;
  PInvRectPage = ^TInvRectPage;
  TInvRectPage = packed record
    irpNext  : PInvRectPage;
    irpRects : array [0.. pred(RectsPerPage)] of TInvRect;
  end;
var
  InvRectFreeList : PInvRect;
  InvRectPageList : PInvRectPage;
{--------}
procedure ADTFreeInvRect(P : PInvRect);
begin
  {push rect onto free list}
  P^.irNext := InvRectFreeList;
  InvRectFreeList := P;
end;
{--------}
procedure ADTAllocInvRectPage;
var
  NewPage : PInvRectPage;
  i       : integer;
begin
  {alloc new page and add it to front of page list}
  New(NewPage);
  NewPage^.irpNext := InvRectPageList;
  InvRectPageList := NewPage;
  {add all rects on this page to free list}
  for i := 0 to pred(RectsPerPage) do
    ADTFreeInvRect(@NewPage^.irpRects[i]);
end;
{--------}
function ADTAllocInvRect : PInvRect;
begin
  {pop top rect from free list; if none, add a whole page's worth}
  if (InvRectFreeList = nil) then
    ADTAllocInvRectPage;
  Result := InvRectFreeList;
  InvRectFreeList := Result^.irNext;
end;
{--------}
procedure ADTFreeInvRectPages;
var
  Temp : PInvRectPage;
begin
  {dispose of all rect pages}
  while (InvRectPageList <> nil) do begin
    Temp := InvRectPageList;
    InvRectPageList := Temp^.irpNext;
    Dispose(Temp);
  end;
  {since all rects have now gone, force the rect free list to nil}
  InvRectFreeList := nil;
end;
{--------}
procedure ADTAddInvalidRect(var aInvRectList : PInvRect;
                       const aRect        : TRect);
var
  NewRect : PInvRect;
begin
  NewRect := ADTAllocInvRect;
  NewRect^.irNext := aInvRectList;
  aInvRectList := NewRect;
  NewRect^.irRect := aRect;
end;
{--------}
function ADTRemoveInvalidRect(var aInvRectList : PInvRect;
                           var aRect        : TRect) : boolean;
var
  TopRect : PInvRect;
begin
  if (aInvRectList = nil) then
    Result := false
  else begin
    Result := true;
    TopRect := aInvRectList;
    aInvRectList := TopRect^.irNext;
    aRect := TopRect^.irRect;
    ADTFreeInvRect(TopRect);
  end;
end;
{--------}
function ADTPeekInvalidRect(aInvRectList : PInvRect;
                     var aRect        : TRect) : boolean;
begin
  if (aInvRectList = nil) then
    Result := false
  else begin
    Result := true;
    aRect := aInvRectList^.irRect;
  end;
end;
{--------}
procedure ADTMergeInvalidRects(aInvRectList : PInvRect);
var
  Temp    : PInvRect;
  Walker  : PInvRect;
  MinRect : TRect;
begin
  if (aInvRectList = nil) then
    Exit;
  {performs a simple merge of all the invalid rects in the list by
   working out the rect that just covers them all; free the rects from
   the list after we read them--leaving the first for our use}
  MinRect := aInvRectList^.irRect;
  Walker := aInvRectList^.irNext;
  while (Walker <> nil) do begin
    with Walker^.irRect do begin
      if Left < MinRect.Left then
        MinRect.Left := Left;
      if Top < MinRect.Top then
        MinRect.Top := Top;
      if Right > MinRect.Right then
        MinRect.Right := Right;
      if Bottom > MinRect.Bottom then
        MinRect.Bottom := Bottom;
    end;
    Temp := Walker;
    Walker := Walker^.irNext;
    ADTFreeInvRect(Temp);
  end;
  {MinRect now contains the smallest rectangle that covers all invalid
   rects in the list; set this minimum invalid rect into the first
   (and only) item in the list}
  aInvRectList^.irNext := nil;
  aInvRectList^.irRect := MinRect;
end;
{====================================================================}


{===TAdTerminalBuffer================================================}
constructor TAdTerminalBuffer.Create(aUseWideChars : boolean);
var
  i : integer;
begin
  inherited Create;

  FTerminalHandle := 0;                                                  {!!.05}

  {set the values of the properties that define defaults}
  FDefBackColor := adc_TermBufBackColor;
  FDefForeColor := adc_TermBufForeColor;
  FDefAnsiChar := ' ';
  FDefWideChar := ' ';
  FDefCharSet := 0;
  FDefAttr := [];

  {set the 'power-up' values}
  FBackColor := adc_TermBufBackColor;
  FForeColor := adc_TermBufForeColor;
  UseAbsAddress := adc_TermBufUseAbsAddress;
  UseAutoWrap := adc_TermBufUseAutoWrap;
  UseAutoWrapDelay := adc_TermBufUseAutoWrapDelay;
  UseInsertMode := adc_TermBufUseInsertMode;
  UseNewLineMode := adc_TermBufUseNewLineMode;
  UseScrollRegion := adc_TermBufUseScrollRegion;

  {set up all the matrices to hold the displayed data}
  {..character matrix}
  if aUseWideChars then begin
    FCharMatrix := TAdTerminalArray.Create(sizeof(WideChar));
    FCharMatrix.SetDefaultItem(@FDefWideChar);
  end
  else
  begin
    FCharMatrix := TAdTerminalArray.Create(sizeof(AnsiChar));
    FCharMatrix.SetDefaultItem(@FDefAnsiChar);
  end;
  FCharMatrix.ColCount := adc_TermBufColCount;
  FCharMatrix.RowCount := adc_TermBufScrollRowCount;

  {..character set matrix}
  FCharSetMatrix := TAdTerminalArray.Create(sizeof(byte));
  FCharSetMatrix.SetDefaultItem(@FDefCharSet);
  FCharSetMatrix.ColCount := adc_TermBufColCount;
  FCharSetMatrix.RowCount := adc_TermBufScrollRowCount;

  {..character attributes matrix}
  FAttrMatrix := TAdTerminalArray.Create(sizeof(TAdTerminalCharAttrs));
  FAttrMatrix.SetDefaultItem(@FDefAttr);
  FAttrMatrix.ColCount := adc_TermBufColCount;
  FAttrMatrix.RowCount := adc_TermBufScrollRowCount;

  {..character foreground color matrix}
  FForeColorMatrix := TAdTerminalArray.Create(sizeof(TColor));
  FForeColorMatrix.SetDefaultItem(@FDefForeColor);
  FForeColorMatrix.ColCount := adc_TermBufColCount;
  FForeColorMatrix.RowCount := adc_TermBufScrollRowCount;

  {..character background color matrix}
  FBackColorMatrix := TAdTerminalArray.Create(sizeof(TColor));
  FBackColorMatrix.SetDefaultItem(@FDefBackColor);
  FBackColorMatrix.ColCount := adc_TermBufColCount;
  FBackColorMatrix.RowCount := adc_TermBufScrollRowCount;

  {initialize the terminal dimensions}
  FUseWideChars := aUseWideChars;
  SVRowCount := adc_TermBufScrollRowCount;
  ColCount := adc_TermBufColCount;
  RowCount := adc_TermBufRowCount;

  ClearAllHorzTabStops;
  ClearAllVertTabStops;
  i := Col;
  while (i < ColCount) do begin
    Col := i;
    SetHorzTabStop;
    inc(i, 8);
  end;
  Row := 1;
  Col := 1;

  {set up the current cursor position}
  FCursorRow := SVRowCount - RowCount;
  FDisplayOriginRow := FCursorRow;
  FCursorCol := 0;

  {add the whole screen as an invalid rect}
  FCursorMoved := true;
  tbInvalidateRect(FCursorRow, 0,
                   pred(SVRowCount), pred(ColCount));
  tbFireOnCursorMovedEvent;                                            
end;
{--------}
destructor TAdTerminalBuffer.Destroy;
var
  OurRect : TRect;
begin
  {remove all of the invalid rects and discard them}
  while ADTRemoveInvalidRect(PInvRect(FInvRectList), OurRect) do {nothing};
  {free the tab stops}                                        
  ADTReallocBitset(FVertTabStops, RowCount, 0);               
  ADTReallocBitset(FHorzTabStops, ColCount, 0);               
  {free all arrays}
  FBackColorMatrix.Free;
  FForeColorMatrix.Free;
  FAttrMatrix.Free;
  FCharSetMatrix.Free;
  FCharMatrix.Free;
  inherited Destroy;
end;
{--------}
procedure TAdTerminalBuffer.ClearAllHorzTabStops;
begin
  if (ColCount <> 0) then
    ADTClearAllBits(FHorzTabStops, ColCount);
end;
{--------}
procedure TAdTerminalBuffer.ClearAllVertTabStops;
begin
  if (RowCount <> 0) then
    ADTClearAllBits(FVertTabStops, RowCount);
end;
{--------}
procedure TAdTerminalBuffer.ClearHorzTabStop;
begin
  if (ColCount <> 0) then
    ADTClearBit(FHorzTabStops, FCursorCol);
end;
{--------}
procedure TAdTerminalBuffer.ClearVertTabStop;
begin
  if (RowCount <> 0) then
    ADTClearBit(FVertTabStops, FCursorRow);
end;
{--------}
procedure TAdTerminalBuffer.DeleteChars(aCount : integer);
var
  CharCount : integer;
begin
  FBeyondMargin := false;
  {$IFDEF UseRangeCheck}
  if (aCount <= 0) then
    raise Exception.Create('TAdTerminalBuffer.DeleteChars: count must be positive');
  {$ENDIF}
  {the actual number of characters to delete is constrained by the
   current display region}
  CharCount := FDisplayOriginCol + FDisplayColCount - FCursorCol;
  if (CharCount > aCount) then
    CharCount := aCount;
  if (CharCount > 0) then begin
    FCharMatrix.DeleteItems(CharCount, FCursorRow, FCursorCol);
    FCharSetMatrix.DeleteItems(CharCount, FCursorRow, FCursorCol);
    FAttrMatrix.DeleteItems(CharCount, FCursorRow, FCursorCol);
    FForeColorMatrix.DeleteItems(CharCount, FCursorRow, FCursorCol);
    FBackColorMatrix.DeleteItems(CharCount, FCursorRow, FCursorCol);
    {the cursor does not move}
    tbInvalidateRect (FCursorRow,                                        {!!.05}
                      FCursorCol,                                        {!!.05}
                      FCursorRow,                                        {!!.05}
                      pred (FDisplayOriginCol + FDisplayColCount));      {!!.05}
  end;
end;
{--------}
procedure TAdTerminalBuffer.DeleteLines(aCount : integer);
var
  MaxRow : integer;
begin
  FBeyondMargin := false;
  {deleting lines is equivalent to a scroll up to the current cursor
   position; we take account of any scroll region, of course}
  {$IFDEF UseRangeCheck}
  if (aCount <= 0) then
    raise Exception.Create('TAdTerminalBuffer.DeleteLines: count must be positive');
  {$ENDIF}
  MaxRow := FDisplayOriginRow + FDisplayRowCount - 1;
  tbScrollRows(aCount, FCursorRow, MaxRow);
  {the cursor does not move}
  tbInvalidateRect(FCursorRow, FDisplayOriginCol, 
                   MaxRow, FDisplayOriginCol+FDisplayColCount-1);
end;
{--------}
procedure TAdTerminalBuffer.DeregisterTerminalHandle;                    {!!.05}
begin                                                                    {!!.05}
  FTerminalHandle := 0;                                                  {!!.05}
end;                                                                     {!!.05}
{--------}
procedure TAdTerminalBuffer.DoBackHorzTab;
var
  NewCol : integer;
begin
  if (ColCount > 0) then begin
    NewCol := FCursorCol;
    while (NewCol > FDisplayOriginCol) do begin
      dec(NewCol);
      if ADTIsBitSet(FHorzTabStops, NewCol) then begin
        FCursorMoved := FCursorMoved or (FCursorCol <> NewCol);
        FCursorCol := NewCol;
        tbFireOnCursorMovedEvent;                                      
        Exit;
      end;
    end;
    FCursorMoved := FCursorMoved or (FCursorCol <> FDisplayOriginCol);
    FCursorCol := FDisplayOriginCol;
    tbFireOnCursorMovedEvent;                                          
  end;
end;
{--------}
procedure TAdTerminalBuffer.DoBackVertTab;
var
  NewRow : integer;
begin
  FBeyondMargin := false;
  if (RowCount > 0) then begin
    NewRow := FCursorRow;
    while (NewRow > FDisplayOriginRow) do begin
      dec(NewRow);
      if ADTIsBitSet(FVertTabStops, NewRow) then begin
        FCursorMoved := FCursorMoved or (FCursorRow <> NewRow);
        FCursorRow := NewRow;
        tbFireOnCursorMovedEvent;                                      
        Exit;
      end;
    end;
    FCursorMoved := FCursorMoved or (FCursorRow <> FDisplayOriginRow);
    FCursorRow := FDisplayOriginRow;
    tbFireOnCursorMovedEvent;                                          
  end;
end;
{--------}
procedure TAdTerminalBuffer.DoBackspace;
begin
  FBeyondMargin := false;
  if (FCursorCol > FDisplayOriginCol) then begin
    FCursorMoved := true;
    dec(FCursorCol);
    tbFireOnCursorMovedEvent;                                          
  end;
end;
{--------}
procedure TAdTerminalBuffer.DoCarriageReturn;
begin
  FBeyondMargin := false;
  FCursorMoved := FCursorMoved or (FCursorCol <> FDisplayOriginCol);
  FCursorCol := FDisplayOriginCol;
  tbFireOnCursorMovedEvent;                                            
end;
{--------}
procedure TAdTerminalBuffer.DoHorzTab;
var
  NewCol : integer;
  MaxCol : integer;
begin
  FBeyondMargin := false;
  if (ColCount > 0) then begin
    NewCol := FCursorCol;
    MaxCol := FDisplayOriginCol + FDisplayColCount - 1;
    while (NewCol < MaxCol) do begin
      inc(NewCol);
      if ADTIsBitSet(FHorzTabStops, NewCol) then begin
        FCursorMoved := FCursorMoved or (FCursorCol <> NewCol);
        FCursorCol := NewCol;
        tbFireOnCursorMovedEvent;                                      
        Exit;
      end;
    end;
    FCursorMoved := FCursorMoved or (FCursorCol <> MaxCol);
    FCursorCol := MaxCol;
    tbFireOnCursorMovedEvent;                                          
  end;
end;
{--------}
procedure TAdTerminalBuffer.DoLineFeed;
begin
  FBeyondMargin := false;
  if UseNewLineMode then
    DoCarriageReturn;
  MoveCursorDown(true);
end;
{--------}
procedure TAdTerminalBuffer.DoVertTab;
var
  NewRow : integer;
  MaxRow : integer;
begin
  FBeyondMargin := false;
  if (RowCount > 0) then begin
    NewRow := FCursorRow;
    MaxRow := FDisplayOriginRow + FDisplayRowCount - 1;
    while (NewRow < MaxRow) do begin
      inc(NewRow);
      if ADTIsBitSet(FVertTabStops, NewRow) then begin
        FCursorMoved := FCursorMoved or (FCursorRow <> NewRow);
        FCursorRow := NewRow;
        tbFireOnCursorMovedEvent;                                      
        Exit;
      end;
    end;
    FCursorMoved := FCursorMoved or (FCursorRow <> MaxRow);
    FCursorRow := MaxRow;
    tbFireOnCursorMovedEvent;                                          
  end;
end;
{--------}
procedure TAdTerminalBuffer.EraseAll;
begin
  {WARNING: this DOES NOT use the scroll region, if defined, it blanks
            out everything in the scrollback buffer}
  FBeyondMargin := false;
  FCharMatrix.Clear;
  FCharSetMatrix.Clear;
  FAttrMatrix.Clear;
  FForeColorMatrix.Clear;
  FBackColorMatrix.Clear;
  Row := 1;
  Col := 1;
  tbInvalidateRect(FCursorRow, 0,
                   pred(SVRowCount), pred(ColCount));
end;
{--------}
procedure TAdTerminalBuffer.EraseChars(aCount : integer);
var
  CharCount : integer;
  ToColNum  : integer;
  CurRow    : integer;
  CurCol    : integer;
  MaxCol    : integer;
  MaxRow    : integer;
begin
  {WARNING: this uses the scroll region, if defined}

  FBeyondMargin := false;
  {$IFDEF UseRangeChecks}
  if (aCount <= 0) then
    raise Exception.Create('TAdTerminalBuffer.EraseChars: Count must be +ve');
  {$ENDIF}
  {this is complicated by the need to erase chars on individual lines
   separately}
  CurRow := FCursorRow;
  CurCol := FCursorCol;
  MaxCol := FDisplayOriginCol + FDisplayColCount - 1;
  MaxRow := FDisplayOriginRow + FDisplayRowCount - 1;
  while (aCount > 0) and (CurRow <= MaxRow) do begin
    {calculate the number of characters to erase in this row}
    CharCount := MaxCol - CurCol + 1;
    if (CharCount > aCount) then
      CharCount := aCount;
    {calculate the final column number}
    ToColNum := CurCol + CharCount - 1;
    {erase}
    FCharMatrix.ClearItems(CurRow, CurCol, ToColNum);
    FCharSetMatrix.ClearItems(CurRow, CurCol, ToColNum);
    FAttrMatrix.ClearItems(CurRow, CurCol, ToColNum);
    FForeColorMatrix.ClearItems(CurRow, CurCol, ToColNum);
    FBackColorMatrix.ClearItems(CurRow, CurCol, ToColNum);
    tbInvalidateRect(CurRow, CurCol,
                     CurRow, ToColNum);
    {set up for the next loop}
    dec(aCount, CharCount);
    inc(CurRow);
    CurCol := FDisplayOriginCol;
  end;
end;
{--------}
procedure TAdTerminalBuffer.EraseFromBOL;
begin
  {WARNING: this uses the scroll region, if defined}

  FBeyondMargin := false;
  {set all characters from the beginning of the line, up to and
   including the cursor position, to blanks}
  FCharMatrix.ClearItems(FCursorRow, FDisplayOriginCol, FCursorCol);
  FCharSetMatrix.ClearItems(FCursorRow, FDisplayOriginCol, FCursorCol);
  FAttrMatrix.ClearItems(FCursorRow, FDisplayOriginCol, FCursorCol);
  FForeColorMatrix.ClearItems(FCursorRow, FDisplayOriginCol, FCursorCol);
  FBackColorMatrix.ClearItems(FCursorRow, FDisplayOriginCol, FCursorCol);
  tbInvalidateRect(FCursorRow, FDisplayOriginCol,
                   FCursorRow, FCursorCol);
end;
{--------}
procedure TAdTerminalBuffer.EraseFromBOW;
var
  DisplayStartRow : integer;
begin
  {WARNING: this DOES NOT use the scroll region, if defined, it blanks
            out everything on the window up to and including the
            cursor position}

  FBeyondMargin := false;
  {set all characters from the beginning of the line, up to and
   including the cursor position, to blanks}
  FCharMatrix.ClearItems(FCursorRow, 0, FCursorCol);
  FCharSetMatrix.ClearItems(FCursorRow, 0, FCursorCol);
  FAttrMatrix.ClearItems(FCursorRow, 0, FCursorCol);
  FForeColorMatrix.ClearItems(FCursorRow, 0, FCursorCol);
  FBackColorMatrix.ClearItems(FCursorRow, 0, FCursorCol);
  tbInvalidateRect(FCursorRow, 0,
                   FCursorRow, FCursorCol);
  {now erase all previous lines, by scrolling them out of existence}
  DisplayStartRow := SVRowCount - RowCount;
  if (FCursorRow > DisplayStartRow) then begin
    tbScrollRows(FCursorRow - DisplayStartRow,
                 DisplayStartRow, pred(FCursorRow));
    tbInvalidateRect(DisplayStartRow, 0,
                     pred(FCursorRow), pred(ColCount));
  end;
end;
{--------}
procedure TAdTerminalBuffer.EraseLine;
var
  MaxCol : integer;
begin
  {WARNING: this uses the scroll region, if defined}

  FBeyondMargin := false;
  {set all characters from the beginning to the end of the line to
   blanks}
  MaxCol := FDisplayOriginCol + FDisplayColCount - 1;
  FCharMatrix.ClearItems(FCursorRow, FDisplayOriginCol, MaxCol);
  FCharSetMatrix.ClearItems(FCursorRow, FDisplayOriginCol, MaxCol);
  FAttrMatrix.ClearItems(FCursorRow, FDisplayOriginCol, MaxCol);
  FForeColorMatrix.ClearItems(FCursorRow, FDisplayOriginCol, MaxCol);
  FBackColorMatrix.ClearItems(FCursorRow, FDisplayOriginCol, MaxCol);
  tbInvalidateRect(FCursorRow, FDisplayOriginCol,
                   FCursorRow, MaxCol);
end;
{--------}
procedure TAdTerminalBuffer.EraseScreen;
begin
  {WARNING: this DOES NOT use the scroll region, if defined, it blanks
            out everything on the window}

  FBeyondMargin := false;
  {scroll the entire scrollback view by RowCount lines: this will have
   the effect of clearing the display view and of setting up the
   scrollback buffer with the previous screen}
  tbScrollRows(RowCount, 0, pred(SVRowCount));
  tbInvalidateRect(SVRowCount - RowCount, 0,
                   pred(SVRowCount), pred(ColCount));
end;
{--------}
procedure TAdTerminalBuffer.EraseToEOL;
var
  MaxCol : integer;
begin
  {WARNING: this uses the scroll region, if defined}

  FBeyondMargin := false;
  {set all characters from and including the cursor position to the
   end of the line to blanks}
  MaxCol := FDisplayOriginCol + FDisplayColCount - 1;
  FCharMatrix.ClearItems(FCursorRow, FCursorCol, MaxCol);
  FCharSetMatrix.ClearItems(FCursorRow, FCursorCol, MaxCol);
  FAttrMatrix.ClearItems(FCursorRow, FCursorCol, MaxCol);
  FForeColorMatrix.ClearItems(FCursorRow, FCursorCol, MaxCol);
  FBackColorMatrix.ClearItems(FCursorRow, FCursorCol, MaxCol);
  tbInvalidateRect(FCursorRow, FCursorCol,
                   FCursorRow, MaxCol);
end;
{--------}
procedure TAdTerminalBuffer.EraseToEOW;
begin
  {WARNING: this DOES NOT use the scroll region, if defined, it blanks
            out everything from and including the cursor position up
            to the end of the screen}

  FBeyondMargin := false;
  {set all characters from and including the cursor position to the
   end of the line to blanks}
  FCharMatrix.ClearItems(FCursorRow, FCursorCol, pred(ColCount));
  FCharSetMatrix.ClearItems(FCursorRow, FCursorCol, pred(ColCount));
  FAttrMatrix.ClearItems(FCursorRow, FCursorCol, pred(ColCount));
  FForeColorMatrix.ClearItems(FCursorRow, FCursorCol, pred(ColCount));
  FBackColorMatrix.ClearItems(FCursorRow, FCursorCol, pred(ColCount));
  tbInvalidateRect(FCursorRow, FCursorCol,
                   FCursorRow, pred(ColCount));
  {now erase all succeeding lines, by scrolling them out of existence}
  if (FCursorRow < pred(SVRowCount)) then begin
    tbScrollRows(pred(SVRowCount) - FCursorRow,
                 succ(FCursorRow), pred(SVRowCount));
    tbInvalidateRect(succ(FCursorRow), 0,
                     pred(SVRowCount), pred(ColCount));
  end;
end;
{--------}
procedure TAdTerminalBuffer.GetCharAttrs(var aValue : TAdTerminalCharAttrs);
begin
  aValue := FAttr;
end;
{--------}
procedure TAdTerminalBuffer.GetDefCharAttrs(var aValue : TAdTerminalCharAttrs);
begin
  aValue := FDefAttr;
end;
{--------}
function TAdTerminalBuffer.GetInvalidRect(var aRect : TRect) : boolean;
begin
  if (FInvRectList = nil) then
    Result := false
  else begin
    {if there is more than one invalid rect, merge them all into one}
    if (PInvRect(FInvRectList)^.irNext <> nil) then
      ADTMergeInvalidRects(FInvRectList);
    {return the first invalid rect}
    Result := ADTRemoveInvalidRect(PInvRect(FInvRectList), aRect);
  end;
end;
{--------}
function TAdTerminalBuffer.GetLineAttrPtr(aRow : integer) : pointer;
var
  OurRow : integer;
begin
  {normalize the row number to our internal system}
  OurRow := tbCvtToInternalRow(aRow, true);
  {$IFDEF UseRangeChecks}
  if (OurRow < 0) or
     (OurRow >= FSVRowCount) then
    raise Exception.Create('TAdTerminalBuffer.GetLineAttrPtr: row number is out of range');
  {$ENDIF}
  {return the pointer into the matrix}
  Result := FAttrMatrix.GetItemPtr(OurRow, FDisplayOriginCol);
end;
{--------}
function TAdTerminalBuffer.GetLineBackColorPtr(aRow : integer) : pointer;
var
  OurRow : integer;
begin
  {normalize the row number to our internal system}
  OurRow := tbCvtToInternalRow(aRow, true);
  {$IFDEF UseRangeChecks}
  if (OurRow < 0) or
     (OurRow >= FSVRowCount) then
    raise Exception.Create('TAdTerminalBuffer.GetLineBackColorPtr: row number is out of range');
  {$ENDIF}
  {return the pointer into the matrix}
  Result := FBackColorMatrix.GetItemPtr(OurRow, FDisplayOriginCol);
end;
{--------}
function TAdTerminalBuffer.GetLineCharPtr(aRow : integer) : pointer;
var
  OurRow : integer;
begin
  {normalize the row number to our internal system}
  OurRow := tbCvtToInternalRow(aRow, true);
  {$IFDEF UseRangeChecks}
  if (OurRow < 0) or
     (OurRow >= FSVRowCount) then
    raise Exception.Create('TAdTerminalBuffer.GetLineCharPtr: row number is out of range');
  {$ENDIF}
  {return the pointer into the matrix}
  Result := FCharMatrix.GetItemPtr(OurRow, FDisplayOriginCol)
end;
{--------}
function TAdTerminalBuffer.GetLineCharSetPtr(aRow : integer) : pointer;
var
  OurRow : integer;
begin
  {normalize the row number to our internal system}
  OurRow := tbCvtToInternalRow(aRow, true);
  {$IFDEF UseRangeChecks}
  if (OurRow < 0) or
     (OurRow >= FSVRowCount) then
    raise Exception.Create('TAdTerminalBuffer.GetLineCharSetPtr: row number is out of range');
  {$ENDIF}
  {return the pointer into the matrix}
  Result := FCharSetMatrix.GetItemPtr(OurRow, FDisplayOriginCol)
end;
{--------}
function TAdTerminalBuffer.GetLineForeColorPtr(aRow : integer) : pointer;
var
  OurRow : integer;
begin
  {normalize the row number to our internal system}
  OurRow := tbCvtToInternalRow(aRow, true);
  {$IFDEF UseRangeChecks}
  if (OurRow < 0) or
     (OurRow >= FSVRowCount) then
    raise Exception.Create('TAdTerminalBuffer.GetLineForeColorPtr: row number is out of range');
  {$ENDIF}
  {return the pointer into the matrix}
  Result := FForeColorMatrix.GetItemPtr(OurRow, FDisplayOriginCol)
end;
{--------}
function TAdTerminalBuffer.HasCursorMoved : boolean;
begin
  {return whether the cursor has moved since the last time this
   function was called; reset the internal variable}
  Result := FCursorMoved;
  FCursorMoved := false;
end;
{--------}
function TAdTerminalBuffer.HasDisplayChanged : boolean;
var
  DummyRect : TRect;
begin
  Result := ADTPeekInvalidRect(PInvRect(FInvRectList), DummyRect);
end;
{--------}
procedure TAdTerminalBuffer.InsertChars(aCount : integer);
var
  CharCount : integer;
begin
  FBeyondMargin := false;
  {$IFDEF UseRangeCheck}
  if (aCount <= 0) then
    raise Exception.Create('TAdTerminalBuffer.InsertChars: count must be positive');
  {$ENDIF}
  {the actual number of characters to delete is constrained by the
   current display region}
  CharCount := FDisplayOriginCol + FDisplayColCount - FCursorCol;
  if (CharCount > aCount) then
    CharCount := aCount;
  if (CharCount > 0) then begin
    FCharMatrix.InsertItems(CharCount, FCursorRow, FCursorCol);
    FCharSetMatrix.InsertItems(CharCount, FCursorRow, FCursorCol);
    FAttrMatrix.InsertItems(CharCount, FCursorRow, FCursorCol);
    FForeColorMatrix.InsertItems(CharCount, FCursorRow, FCursorCol);
    FBackColorMatrix.InsertItems(CharCount, FCursorRow, FCursorCol);
    tbInvalidateRect (FCursorRow,                                        {!!.05}
                      FCursorCol,                                        {!!.05}
                      FCursorRow,                                        {!!.05}
                      pred (FDisplayOriginCol + FDisplayColCount));      {!!.05}
  end;
end;
{--------}
procedure TAdTerminalBuffer.InsertLines(aCount : integer);
var
  MaxRow : integer;
begin
  FBeyondMargin := false;
  {inserting lines is equivalent to a scroll down from the current
   cursor position; we take account of any scroll region, of course}
  {$IFDEF UseRangeCheck}
  if (aCount <= 0) then
    raise Exception.Create('TAdTerminalBuffer.InsertLines: count must be positive');
  {$ENDIF}
  MaxRow := FDisplayOriginRow + FDisplayRowCount - 1;
  tbScrollRows(-aCount, FCursorRow, MaxRow);
  {the cursor position doesn't change as a result of inserting rows}
  tbInvalidateRect(FCursorRow, FDisplayOriginCol,
                   MaxRow, pred(FDisplayOriginCol + FDisplayColCount));
end;
{--------}
procedure TAdTerminalBuffer.MoveCursorDown(aScroll : boolean);
begin
  FBeyondMargin := false;
  tbMoveCursorUpDown(1, aScroll);
end;
{--------}
procedure TAdTerminalBuffer.MoveCursorLeft(aWrap   : boolean;
                                           aScroll : boolean);
begin
  FBeyondMargin := false;
  tbMoveCursorLeftRight(-1, aWrap, aScroll);
end;
{--------}
procedure TAdTerminalBuffer.MoveCursorRight(aWrap   : boolean;
                                            aScroll : boolean);
begin
  FBeyondMargin := false;
  tbMoveCursorLeftRight(1, aWrap, aScroll);
end;
{--------}
procedure TAdTerminalBuffer.MoveCursorUp(aScroll : boolean);
begin
  FBeyondMargin := false;
  tbMoveCursorUpDown(-1, aScroll);
end;
{--------}
procedure TAdTerminalBuffer.RegisterTerminalHandle (AHandle : THandle);  {!!.05}
begin                                                                    {!!.05}
  FTerminalHandle := AHandle;                                            {!!.05}
end;                                                                     {!!.05}
{--------}
procedure TAdTerminalBuffer.Reset;
var
  i : integer;
begin
  {set the attributes, the colors, and the charset}
  FAttr := FDefAttr;
  FForeColor := FDefForeColor;
  FBackColor := FDefBackColor;
  FCharSet := FDefCharSet;

  {set the various matrices to their 'power-up' values}
  if UseWideChars then begin
    FCharMatrix.SetDefaultItem(@FDefWideChar);
  end
  else
  begin
    FCharMatrix.SetDefaultItem(@FDefAnsiChar);
  end;
  FCharSetMatrix.SetDefaultItem(@FDefCharSet);
  FAttrMatrix.SetDefaultItem(@FDefAttr);
  FForeColorMatrix.SetDefaultItem(@FDefForeColor);
  FBackColorMatrix.SetDefaultItem(@FDefBackColor);

  {clear the matrices}
  FCharMatrix.Clear;
  FCharSetMatrix.Clear;
  FAttrMatrix.Clear;
  FForeColorMatrix.Clear;
  FBackColorMatrix.Clear;

  {clear all tab stops, set horizontal ones to every 8 chars}
  ClearAllHorzTabStops;
  ClearAllVertTabStops;
  i := 1;
  while (i < ColCount) do begin
    Col := i;
    SetHorzTabStop;
    inc(i, 8);
  end;

  {set the buffer modes}
  UseAbsAddress := adc_TermBufUseAbsAddress;
  UseAutoWrap := adc_TermBufUseAutoWrap;
  UseAutoWrapDelay := adc_TermBufUseAutoWrapDelay;
  UseInsertMode := adc_TermBufUseInsertMode;
  UseNewLineMode := adc_TermBufUseNewLineMode;
  UseScrollRegion := adc_TermBufUseScrollRegion;

  {reset the cursor position}
  FBeyondMargin := false;
  Row := 1;
  Col := 1;
end;
{--------}
procedure TAdTerminalBuffer.SetCharAttrs(const aValue : TAdTerminalCharAttrs);
begin
  FAttr := aValue;
  FAttrMatrix.SetDefaultItem(@FAttr);
end;
{--------}
procedure TAdTerminalBuffer.SetDefCharAttrs(const aValue : TAdTerminalCharAttrs);
begin
  FDefAttr := aValue;
end;
{--------}
procedure TAdTerminalBuffer.SetCursorPosition(aRow, aCol : integer);
begin
  FBeyondMargin := false;
  Row := aRow;
  Col := aCol;
end;
{--------}
procedure TAdTerminalBuffer.SetScrollRegion(aTopRow, aBottomRow : integer);
var
  Temp : integer;
begin
  FBeyondMargin := false;
  {if the top row is greater than the bottom row, they're out of
   order, so switch 'em round}
  if (aTopRow > aBottomRow) then begin
    Temp := aTopRow;
    aTopRow := aBottomRow;
    aBottomRow := Temp;
  end;
  {$IFDEF UseRangeChecks}
  if ((aBottomRow - aTopRow) < 1) or
     (aTopRow < 1) or (aTopRow > RowCount) or
     (aBottomRow < 1) or (aBottomRow > RowCount) then
    raise Exception.Create('TAdTerminalBuffer.SetScrollRegion: invalid row number(s)');
  {$ELSE}                                                                {!!.06}
  if ((aBottomRow - aTopRow) < 1) then                                   {!!.06}
    Exit;                                                                {!!.06}
  if (aTopRow < 1) then                                                  {!!.06}
    aTopRow := 1;                                                        {!!.06}
  if (aTopRow > RowCount) then                                           {!!.06}
    aTopRow := RowCount;                                                 {!!.06}
  if (aBottomRow < 1) then                                               {!!.06}
    aBottomRow := 1;                                                     {!!.06}
  if (aBottomRow > RowCount) then                                        {!!.06}
    aBottomRow := RowCount;                                              {!!.06}
  {$ENDIF}
  FSRStartRow := tbCvtToInternalRow(aTopRow, true);
  FSREndRow := tbCvtToInternalRow(aBottomRow, true);
  {force the scroll region to be used}
  if UseScrollRegion then
    UseScrollRegion := false;
  if (aTopRow <> 1) or (aBottomRow <> RowCount) then
    UseScrollRegion := true;
end;
{--------}
procedure TAdTerminalBuffer.SetHorzTabStop;
begin
  if (ColCount <> 0) then
    ADTSetBit(FHorzTabStops, FCursorCol);
end;
{--------}
procedure TAdTerminalBuffer.SetVertTabStop;
begin
  if (RowCount <> 0) then
    ADTSetBit(FVertTabStops, FCursorRow);
end;
{--------}
function TAdTerminalBuffer.tbAtLastColumn : boolean;
var
  MaxCol : integer;
begin
  MaxCol := FDisplayOriginCol + FDisplayColCount - 1;
  Result := FCursorCol = MaxCol;
end;
{--------}
function TAdTerminalBuffer.tbCvtToExternalCol(aCol : integer;
                                              aAbsolute : boolean) : integer;
begin
  {aCol is an internal reference (ie. zero-based and absolute), we
   need the external value (ie, one-based and relative to the start of
   the addressable area)}
  if aAbsolute then
    Result := aCol + 1
  else
    Result := aCol - FDisplayOriginCol + 1;
end;
{--------}
function TAdTerminalBuffer.tbCvtToExternalRow(aRow : integer;
                                              aAbsolute : boolean) : integer;
begin
  {aRow is an internal reference (ie. zero-based and absolute), we
   need the external value (ie, one-based and relative to the start of
   the addressable area)}
  if aAbsolute then
    Result := aRow - (SVRowCount - RowCount) + 1
  else
    Result := aRow - FDisplayOriginRow + 1;
end;
{--------}
function TAdTerminalBuffer.tbCvtToInternalCol(aCol : integer;
                                              aAbsolute : boolean) : integer;
begin
  {aCol is an external reference (ie, one-based and relative to the
   start of the addressable area), we need the internal value (ie.
   zero-based and absolute)}
  if aAbsolute then
    Result := aCol - 1
  else
    Result := aCol - 1 + FDisplayOriginCol;
end;
{--------}
function TAdTerminalBuffer.tbCvtToInternalRow(aRow : integer;
                                              aAbsolute : boolean) : integer;
begin
  {aRow is an external reference (ie, one-based and relative to the
   start of the addressable area), we need the internal value (ie.
   zero-based and absolute)}
  if aAbsolute then
    Result := aRow - 1 + (SVRowCount - RowCount)
  else
    Result := aRow - 1 + FDisplayOriginRow;
end;
{--------}                                                             
procedure TAdTerminalBuffer.tbFireOnCursorMovedEvent;                  
begin                                                                  
  if (assigned (FOnCursorMoved)) and (FCursorMoved) then               
    FOnCursorMoved (Self, Row, Col);                                   
end;                                                                   
{--------}
function TAdTerminalBuffer.tbGetCol : integer;
begin
  Result := tbCvtToExternalCol(FCursorCol, UseAbsAddress);
end;
{--------}
function TAdTerminalBuffer.tbGetOriginCol : integer;
begin
  Result := tbCvtToExternalCol(FDisplayOriginCol, true);
end;
{--------}
function TAdTerminalBuffer.tbGetOriginRow : integer;
begin
  Result := tbCvtToExternalRow(FDisplayOriginRow, true);
end;
{--------}
function TAdTerminalBuffer.tbGetRow : integer;
begin
  Result := tbCvtToExternalRow(FCursorRow, UseAbsAddress);
end;
{--------}
procedure TAdTerminalBuffer.tbInvalidateRect(aFromRow, aFromCol,
                                             aToRow, aToCol : integer);
var
  OurRect : TRect;
begin
  {convert the row and column values to external values}
  OurRect.Left := aFromCol + 1;
  OurRect.Top := aFromRow + RowCount - SVRowCount + 1;
  OurRect.Right := aToCol + 1;
  OurRect.Bottom := aToRow + RowCount - SVRowCount + 1;
  ADTAddInvalidRect(PInvRect(FInvRectList), OurRect);
  if (FTerminalHandle <> 0) then                                         {!!.05}
    PostMessage (FTerminalHandle, apw_TermNeedsUpdate, 0, 0);            {!!.05}
end;
{--------}
procedure TAdTerminalBuffer.tbMoveCursorLeftRight(aDirection : integer;
                                                  aWrap      : boolean;
                                                  aScroll    : boolean);
var
  MaxCol   : integer;
  MaxRow   : integer;
  StartRow : integer;
begin
  {if wrap is off, we just advance or retard the cursor position by
   one without extending beyond the left or right margin; scrolling is
   not possible in this case}
  MaxCol := FDisplayOriginCol + FDisplayColCount - 1;
  if not aWrap then begin
    if (aDirection < 0) then begin
      if (FCursorCol > FDisplayOriginCol) then begin
        FCursorMoved := true;
        dec(FCursorCol);
        tbFireOnCursorMovedEvent;                                      
      end;
    end
    else begin
      if (FCursorCol < MaxCol) then begin
        FCursorMoved := true;
        inc(FCursorCol);
        tbFireOnCursorMovedEvent;
      end;
    end;
    Exit;
  end;
  MaxRow := FDisplayOriginRow + FDisplayRowCount - 1;
  {otherwise it's a wrap, as it were}
  {there are several cases here
     1. if the new cursor position is within the same line, just move
        it as above
     2. if the current cursor position is 0 and we're moving left...
        a. if we're not on the top display row, move the cursor to
           the last column of the previous row
        b. if aScroll is false and we're on the top row, leave
           the cursor where it is
        c. if aScroll is true and we're on the top row, scroll the
           display down and move the cursor to the last column of the
           new top row
     3. if the current cursor position is on the last column and we're
        moving right...
        a. if we're not on the bottom display row, move the cursor to
           the first column of the next row
        b. if aScroll is false and we're on the bottom row, leave the
           cursor where it is
        c. if aScroll is true and we're on the bottom, scroll the
           display up and move the cursor to the first column of the
           new bottom row}
  if (aDirection < 0) then begin {moving left}
    if (FCursorCol > FDisplayOriginCol) then begin
      FCursorMoved := true;
      dec(FCursorCol);
      tbFireOnCursorMovedEvent;                                        
    end
    else if (FCursorRow > FDisplayOriginRow) then begin
      FCursorMoved := true;
      FCursorCol := MaxCol;
      dec(FCursorRow);
      tbFireOnCursorMovedEvent;                                        
    end
    else if aScroll then begin
      tbScrollRows(-1, FDisplayOriginRow, MaxRow);
      tbInvalidateRect(FDisplayOriginRow, 0, MaxRow, pred(ColCount));
      FCursorMoved := true;
      FCursorCol := MaxCol;
      tbFireOnCursorMovedEvent;                                        
    end;
  end
  else {Direction > 0} begin {moving right}
    if (FCursorCol < MaxCol) then begin
      FCursorMoved := true;
      inc(FCursorCol);
      tbFireOnCursorMovedEvent;                                        
    end
    else if (FCursorRow < MaxRow) then begin
      FCursorMoved := true;
      FCursorCol := FDisplayOriginCol;
      inc(FCursorRow);
      tbFireOnCursorMovedEvent;                                        
    end
    else if aScroll then begin
      if UseScrollRegion then
        StartRow := FDisplayOriginRow
      else
        StartRow := 0;
      tbScrollRows(1, StartRow, MaxRow);
      tbInvalidateRect(FDisplayOriginRow, 0, MaxRow, pred(ColCount));
      FCursorMoved := true;
      FCursorCol := FDisplayOriginCol;
      tbFireOnCursorMovedEvent;                                        
    end;
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbMoveCursorUpDown(aDirection : integer;
                                               aScroll    : boolean);
var
  MaxRow   : integer;
  StartRow : integer;
begin
  MaxRow := FDisplayOriginRow + FDisplayRowCount - 1;
  if (aDirection < 0) then begin
    if (FCursorRow > FDisplayOriginRow) then begin
      FCursorMoved := true;
      dec(FCursorRow);
      tbFireOnCursorMovedEvent;                                        
    end
    else if aScroll then begin
      tbScrollRows(-1, FDisplayOriginRow, MaxRow);
      tbInvalidateRect(FDisplayOriginRow, 0, MaxRow, pred(ColCount));
    end;
  end
  else {Direction > 0} begin
    if (FCursorRow < MaxRow) then begin
      FCursorMoved := true;
      inc(FCursorRow);
      tbFireOnCursorMovedEvent;                                        
    end
    else if aScroll then begin
      if UseScrollRegion then
        StartRow := FDisplayOriginRow
      else
        StartRow := 0;
      tbScrollRows(1, StartRow, MaxRow);
      tbInvalidateRect(FDisplayOriginRow, 0, MaxRow, pred(ColCount));
    end;
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbReallocBuffers(aNewRowCount : integer;
                                             aNewColCount : integer);
begin
  {check for changes in row count}
  if (aNewRowCount <> SVRowCount) then begin
    FCharMatrix.RowCount := aNewRowCount;
    FCharSetMatrix.RowCount := aNewRowCount;
    FAttrMatrix.RowCount := aNewRowCount;
    FForeColorMatrix.RowCount := aNewRowCount;
    FBackColorMatrix.RowCount := aNewRowCount;
    FSVRowCount := aNewRowCount;
  end
  {otherwise it's a change in column count}
  else begin
    FCharMatrix.ColCount := aNewColCount;
    FCharSetMatrix.ColCount := aNewColCount;
    FAttrMatrix.ColCount := aNewColCount;
    FForeColorMatrix.ColCount := aNewColCount;
    FBackColorMatrix.ColCount := aNewColCount;
    FColCount := aNewColCount;
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbScrollRows(aCount, aTop, aBottom : integer);
begin
  FCharMatrix.ScrollRows(aCount, aTop, aBottom);
  FCharSetMatrix.ScrollRows(aCount, aTop, aBottom);
  FAttrMatrix.ScrollRows(aCount, aTop, aBottom);
  FForeColorMatrix.ScrollRows(aCount, aTop, aBottom);
  FBackColorMatrix.ScrollRows(aCount, aTop, aBottom);
  if Assigned(FOnScrollRows) then
    FOnScrollRows(Self, aCount,
                  aTop + 1 - (SVRowCount - RowCount),
                  aBottom + 1 - (SVRowCount - RowCount));
end;
{--------}
procedure TAdTerminalBuffer.tbSetBackColor(aValue : TColor);
begin
  if (aValue <> BackColor) then begin
    FBackColor := aValue;
    FBackColorMatrix.SetDefaultItem(@FBackColor);
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetCharSet(aValue : byte);
begin
  if (aValue <> CharSet) then begin
    FCharSet := aValue;
    FCharSetMatrix.SetDefaultItem(@FCharSet);
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetCol(aCol : integer);
var
  OurCol : integer;
begin
  FBeyondMargin := false;
  if (aCol <> Col) then begin
    OurCol := tbCvtToInternalCol(aCol, UseAbsAddress);
    if (OurCol < 0) then                                                 
      OurCol := 0                                                        
    else if (OurCol >= ColCount) then                                    
      OurCol := pred(ColCount);
    FCursorMoved := true;
    FCursorCol := OurCol;
    tbFireOnCursorMovedEvent;                                          
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetColCount(aNewCount : integer);
begin
  {only do something if the value changes}
  if (aNewCount <> ColCount) then begin
    {check the new value is sensible}
    if (aNewCount < 2) then
      raise Exception.Create('TAdTerminalBuffer.tbSetColCount: new count too small');
    {reallocate the tab positions bitset}
    FHorzTabStops :=
       ADTReallocBitset(FHorzTabStops, ColCount, aNewCount);
    {if the number of scrollback rows is zero, just make a note of the
     new value: there won't have been any allocations yet}
    if (SVRowCount = 0) then begin
      FColCount := aNewCount;
      FDisplayColCount  := aNewCount;
    end
    {otherwise we can allocate new buffers and transfer over the old}
    else begin
      tbReallocBuffers(SVRowCount, aNewCount);
      tbInvalidateRect(SVRowCount - RowCount, 0,
                       pred(SVRowCount), pred(aNewCount));
      if UseScrollRegion then
        UseScrollRegion := false
      else begin
        FCursorRow := SVRowCount - RowCount;
        FCursorCol := 0;
        FDisplayColCount  := aNewCount;
      end;
    end;
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetDefAnsiChar(aValue : AnsiChar);
begin
  if (aValue <> DefAnsiChar) then begin
    FDefAnsiChar := aValue;
    FCharMatrix.SetDefaultItem(@FDefAnsiChar);
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetDefBackColor(aValue : TColor);
                                                           {new !!.02}
begin
  if (FDefBackColor <> aValue) then begin
    FBackColorMatrix.ReplaceItems(@FDefBackColor, @aValue);
    FDefBackColor := aValue;
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetDefForeColor(aValue : TColor);
                                                           {new !!.02}
begin
  if (FDefForeColor <> aValue) then begin
    FForeColorMatrix.ReplaceItems(@FDefForeColor, @aValue);
    FDefForeColor := aValue;
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetForeColor(aValue : TColor);
begin
  if (aValue <> ForeColor) then begin
    FForeColor := aValue;
    FForeColorMatrix.SetDefaultItem(@FForeColor);
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetRow(aRow : integer);
var
  OurRow : integer;
begin
  FBeyondMargin := false;
  if (aRow <> Row) then begin
    OurRow := tbCvtToInternalRow(aRow, UseAbsAddress);
    if (OurRow < 0) then                                                 
      OurRow := 0                                                        
    else if (OurRow >= SVRowCount) then                                  
      OurRow := pred(SVRowCount);                                        
    FCursorMoved := true;
    FCursorRow := OurRow;
      tbFireOnCursorMovedEvent;                                        
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetRowCount(aNewCount : integer);
begin
  {only do something if the value changes, and changes to something
   not greater than the scrollback view count}
  if (aNewCount <> RowCount) and
     (aNewCount <= SVRowCount) then begin
    {check the new value is sensible}
    if (aNewCount < 2) then
      raise Exception.Create('TAdTerminalBuffer.tbSetRowCount: new count too small');
    {changing the row count resets the scroll region}
    if UseScrollRegion then
      UseScrollRegion := false;
    {reallocate the tab positions bitset}
    FVertTabStops :=
       ADTReallocBitset(FVertTabStops, RowCount, aNewCount);
    {set the display origin and the cursor position}          
    FDisplayOriginRow := FSVRowCount - aNewCount;             
    if (FCursorRow < FDisplayOriginRow) then                  
      FCursorRow := FDisplayOriginRow;                        
    {save the new value}
    FRowCount := aNewCount;
    FDisplayRowCount := aNewCount;
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetSVRowCount(aNewCount : integer);
begin
  {only do something if the value changes}
  if (aNewCount <> SVRowCount) then begin
    {check the new value is sensible}
    if (aNewCount < 2) then
      raise Exception.Create('TAdTerminalBuffer.tbSetSVRowCount: new count too small');
    {if the new scrollback view count is less than the display view
     count, reduce the display view count to match}
    if (aNewCount < RowCount) then begin
      FRowCount := aNewCount;
      FDisplayRowCount := aNewCount;
    end;
    {set the display origin and the cursor position}          
    FDisplayOriginRow := aNewCount - RowCount;                
    FCursorRow := FCursorRow - SVRowCount + aNewCount;        
    {if the number of columns is zero, just make a note of the new
     value: there won't have been any allocations yet}
    if (ColCount = 0) then
      FSVRowCount := aNewCount
    {otherwise we can allocate new buffers and transfer over the old}
    else begin
      tbReallocBuffers(aNewCount, ColCount);
      tbInvalidateRect(SVRowCount - RowCount, 0,
                       pred(SVRowCount), pred(aNewCount));
    end;
  end;
end;
{--------}
procedure TAdTerminalBuffer.tbSetUseScrollRegion(aValue : boolean);
begin
  if (aValue <> UseScrollRegion) then begin
    {calculate the limits beyond which the cursor cannot move}
    if aValue {limit to scroll region} then begin
      FDisplayOriginCol := 0;
      FDisplayOriginRow := FSRStartRow;
      FDisplayColCount  := ColCount;
      FDisplayRowCount  := FSREndRow - FSRStartRow + 1;
    end
    else {limit to full display area} begin
      FDisplayOriginCol := 0;
      FDisplayOriginRow := SVRowCount - RowCount;
      FDisplayColCount  := ColCount;
      FDisplayRowCount  := RowCount;
    end;
    {rest the cursor to the top left corner of the allowed region}
    FCursorMoved := true;
    FCursorCol := FDisplayOriginCol;
    FCursorRow := FDisplayOriginRow;
      tbFireOnCursorMovedEvent;                                        
    {save the property value}
    FUseScrollRegion := aValue;
  end;
end;
{--------}
procedure TAdTerminalBuffer.WriteChar(aCh : AnsiChar);
begin
  {this is performed as
    - write the character to the current cursor
    - write the current attributes, colors and charset to the current
      cursor
    - advance the cursor
   the latter operation may not do anything if UseAutoWrap is off and
   the cursor is at the end of the line, otherwise, if it's on, a
   scroll will occur}
  if FBeyondMargin then begin
    MoveCursorRight(UseAutoWrap, True);                                
    FBeyondMargin := false;
  end;
  if UseInsertMode then begin
    FCharMatrix.InsertItems(1, FCursorRow, FCursorCol);
    FCharSetMatrix.InsertItems(1, FCursorRow, FCursorCol);
    FAttrMatrix.InsertItems(1, FCursorRow, FCursorCol);
    FForeColorMatrix.InsertItems(1, FCursorRow, FCursorCol);
    FBackColorMatrix.InsertItems(1, FCursorRow, FCursorCol);
  end;
  FCharMatrix.WriteItems(@aCh, 1, FCursorRow, FCursorCol);
  FCharSetMatrix.WriteItems(@FCharSet, 1, FCursorRow, FCursorCol);
  FAttrMatrix.WriteItems(@FAttr, 1, FCursorRow, FCursorCol);
  FForeColorMatrix.WriteItems(@FForeColor, 1, FCursorRow, FCursorCol);
  FBackColorMatrix.WriteItems(@FBackColor, 1, FCursorRow, FCursorCol);
  tbInvalidateRect(FCursorRow, FCursorCol,
                   FCursorRow, FCursorCol);
  if (not UseAutoWrapDelay) or (not tbAtLastColumn) then
    MoveCursorRight(UseAutoWrap, True)                                 
  else
    FBeyondMargin := true;
end;
{--------}
procedure TAdTerminalBuffer.WriteString(const aSt : string);
begin
  WriteString(AnsiString(ASt));
end;
{--------}
procedure TAdTerminalBuffer.WriteString(const aSt : AnsiString);
var
  i : integer;
begin
  for i := 1 to length(aSt) do begin
    WriteChar(aSt[i]);
  end;
end;
{====================================================================}


{===Initialization/finalization======================================}
procedure ADTrmBufDone; far;
begin
  ADTFreeInvRectPages;
end;
{--------}
initialization
  InvRectFreeList := nil;
  InvRectPageList := nil;
{--------}
finalization
  ADTrmBufDone;
{--------}
end.
