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
{*                   AWFVIEW.PAS 4.06                    *}
{*********************************************************}
{* Low-level fax viewer                                  *}
{*********************************************************}

{
  Used by the TApdFaxViewer (AdFView.pas). This unit could use
  some updating, originally ported from the DOS code to Windows (BP7),
  then Delphi.  Uses messages to interface with TApdFaxViewer,
  renders on a custom window.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$S-,R-,V-,I-,B-,X+,Q-,J+}

unit AwFView;
  {-Fax viewing}

interface

uses
  Windows,
  ShellApi,
  Messages,
  SysUtils,
  OoMisc,
  AwFaxCvt;

const
  MaxFaxPages = $FFF0 div SizeOf(TMemoryBitmapDesc);

type
  PFax = ^TFax;
  TFax = array[1..MaxFaxPages] of TMemoryBitmapDesc;

  TViewerWndProc = function(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

  {Windows message record}
  wMsg = record
    hWindow : hWnd;
    Message : UINT;
    case Integer of
      0: (wParam : WPARAM; lParam : LPARAM);
      1: (wParamLo, wParamHi : Word; lParamLo, lParamHi : Word);
  end;
  {fax bitmap viewer}
  TViewer = class
      vWnd          : HWnd;             {Window handle}

      {for unpacking}
      vUnpacker     : PUnpackFax;       {For unpacking the fax image}
      vImage        : PFax;             {Unpacked fax image}
      vUnpPage      : Cardinal;         {The page being unpacked}
      vLoadWholeFax : Bool;             {TRUE if whole fax should be loaded}
      vBusyCursor   : HCursor;          {Cursor shown while doing lengthy ops}

      {features}
      vDragDrop     : Bool;             {TRUE if the window supports Drag&Drop}

      {display data}
      vFGColor      : Integer;          {foreground color}
      vBGCOlor      : Integer;          {background color}
      vScaledWidth  : Cardinal;         {scaled width of the image on the page}
      vScaledHeight : Cardinal;         {scaled height of the image on the page}
      vVScrollInc   : Integer;          {vertical scroll increment}
      vHScrollInc   : Integer;          {horizontal scroll increment}
      vSizing       : Bool;             {TRUE if window is being sized}
      vVScrolling   : Bool;             {TRUE if scrolling vertically}
      vHScrolling   : Bool;             {TRUE if scrolling horizontally}

      {position data}
      vNumPages     : Cardinal;         {Number of pages in fax}
      vOnPage       : Cardinal;         {Current page in viewer}
      vTopRow       : Cardinal;         {Row at top of display}
      vLeftOfs      : Cardinal;         {Left offset}
      vMaxVScroll   : Cardinal;         {Maximum top row}
      vMaxHScroll   : Cardinal;         {Maximum left offset}

      {scaling}
      vHMult        : Cardinal;         {multiplier for width of destination}
      vHDiv         : Cardinal;         {divisor for width of destination}
      vVMult        : Cardinal;         {multipler for height of destination}
      vVDiv         : Cardinal;         {divisor for height of destination}

      {rotation data}
      vRotateDir    : Cardinal;         {Direction of rotation}

      {block marking}
      vMarked       : Bool;             {TRUE if a block is marked}
      vCaptured     : Bool;             {TRUE if mouse captured}
      vAnchorCorner : Cardinal;         {anchored corner of marked rectangle}
      vOutsideEdge  : Bool;             {TRUE if mouse outside client area}
      vMarkTimer    : Cardinal;         {timer for automatic scrolling}
      vMarkRect     : TRect;            {marked rectangle}

      {keyboard data}
      vCtrlDown     : Bool;             {TRUE if control key down}

      vDefWndProc   : TViewerWndProc;   {The default window proc}
      vFileName     : string; //array[0..fsPathName] of AnsiChar;
      vComponentName: string; //array[0..255] of AnsiChar;
      vUpdating     : Boolean;
      vDesigning    : Boolean;

      {constructors/destructors}
      constructor Create(AWnd : TApdHwnd);
      destructor Destroy; override;

      {image creation/destruction}
      procedure vAllocFax(NumPages : Cardinal);
        {-Allocate memory for the fax}
      procedure vDisposeFax;
        {-Dispose of the current fax}

      {scrollbars}
      procedure vInitScrollbars;
        {-Set scrollbar ranges and initial positions}
      procedure vUpdateScrollThumb(Vert : Bool);
        {-Update the thumb position on the vertical or horizontal scrollbar}
      procedure vCalcMaxScrollPos;
        {-Calculate the maximum horizontal and vertical scrollbar positions}

      {scrolling}
      procedure vScrollUpPrim(Delta : Cardinal);
        {-Scroll the display up Delta rows}
      procedure vScrollDownPrim(Delta : Cardinal);
        {-Scroll the display down Delta rows}
      procedure vScrollLeftPrim(Delta : Cardinal);
        {-Scroll the display left Delta columns}
      procedure vScrollRightPrim(Delta : Cardinal);
        {-Scroll the display right Delta columns}
      procedure vScrollUp;
        {-Scroll the display up vVScrollInc lines}
      procedure vScrollDown;
        {-Scroll the display down vVScrollInc lines}
      procedure vScrollLeft;
        {-Scroll the display left vHScrollInc columns}
      procedure vScrollRight;
        {-Scroll the display left vHScrollInc columns}
      procedure vJumpUp;
        {-Scroll the display up vVScrollInc * 10 lines}
      procedure vJumpDown;
        {-Scroll the display down vVScrollInc * 10 lines}
      procedure vJumpLeft;
        {-Scroll the display left vHScrollInc * 10 columns}
      procedure vJumpRight;
        {-Scroll the display left vHScrollInc * 10 columns}
      procedure vHomeVertical;
        {-Home the vertical display}
      procedure vEndVertical;
        {-Scroll the vertical display to the end}
      procedure vHomeHorizontal;
        {-Home the horizontal display}
      procedure vEndHorizontal;
        {-Scroll the horizontal display to the end}

      {paging}
      procedure vInitPage;
        {-Initialize a new page for viewing}
      procedure vPageUp;
        {-Go to the previous page}
      procedure vPageDown;
        {-Go to the next page}
      procedure vFirstPage;
        {-Go to the first page}
      procedure vLastPage;
        {-Go to the last page}
      function vRotatePage(const PageNum, Direction : Cardinal) : Integer;
        {-Rotate a page}

      {marking}
      procedure vUpdateMarkRect(Client : TRect; X, Y : Integer);
        {-Update the mark rectangle}
      procedure vCopyToClipboard;
        {-Copy the marked bitmap to the clipboard}

      {painting}
      procedure vInvalidateAll;
        {-Invalidate the entire viewer window}
      procedure vPaint(PaintDC : HDC; var PaintInfo : TPaintStruct);
        {-Paint the window}
      procedure vGetMarkClientIntersection(var R : TRect; Mark : TRect);
        {-Find the intersection of the client rect and the marked rect}

      {drag and drop}
      procedure vInitDragDrop(Enabled : Bool);
        {-Initialize drag and drop features}

      {message response}
      function apwViewSetFile(FName : string) : Integer;
        {-Set the file name of the file to view}
      procedure apwViewSetFG(Color : Integer);
        {-Set the foreground color}
      procedure apwViewSetBG(Color : Integer);
        {-Set the background color}
      procedure apwViewSetScale(Settings : PScaleSettings);
        {-Set scaling factors}
      function apwViewSetWhitespace(FromLines, ToLines : Cardinal) : Integer;
        {-Set whitespace compression factors}
      procedure apwViewSetScroll(HScroll, VScroll : Cardinal);
        {-Set the vertical and horizontal scroll increments}
      function apwViewSelectAll : Integer;
        {-Select entire image}
      function apwViewSelect(R : PRect) : Integer;
        {-Select a portion of fax image}
      function apwViewCopy : Integer;
        {-Copy image data to clipboard}
      function apwViewGetBitmap(Page : Cardinal; Point : PPoint) : HBitmap;
        {-Retrieve the bitmap for page number Page}
      function apwViewGetNumPages : Cardinal;
        {-Retrieve the number of pages in the fax}
      procedure apwViewStartUpdate;
        {-Begin update of scaling parameters}
      procedure apwViewEndUpdate;
        {-End update of scaling parameters}
      procedure apwViewSetWndProc(var Msg : wMsg);
        {-Set the viewer's window procedure}
      function apwViewGotoPage(Page : Cardinal) : Integer;
        {-Set the currently viewed page}
      function apwViewGetCurPage : Integer;
        {-Get the number of the currently viewed page}
      procedure apwViewSetDesignMode(Name : PChar);
        {-Tell the viewer we're in component design mode}
      function apwViewSetRotation(Direction : Cardinal) : Integer;
        {-Rotate the fax bitmaps}
      procedure apwViewSetAutoScale(Kind : Word);
        {-Set the auto scaling mode for the underlying unpacker}
      procedure apwViewGetPageDim(R : PRect);
        {-Get dimensions of current page}
      function apwViewGetPageFlags : Word;                         
        {-Get flags for current page}
      function apwViewSetLoadWholeFax(LoadWhole : Bool) : Integer;
        {-Determine whether whole faxes are loaded into memory or not}
      procedure apwViewSetBusyCursor(NewCursor : HCursor);
        {-Set the cursor that is shown during length operations}
      procedure wmPaint(var Msg : wMsg);
        {-paint the window}
      function wmSize(var Msg : wMsg) : Integer;
        {-size the window}
      function wmGetDlgCode(var Msg : wMsg) : Integer;
        {-respond to query about what input we want}
      function wmKeyDown(var Msg : wMsg) : Integer;
        {-respond to key presses}
      function wmKeyUp(var Msg : wMsg) : Integer;
        {-respond to key releases}
      procedure wmLButtonDown(var Msg : wMsg);
        {-respond to left button clicks}
      procedure wmLButtonUp(var Msg : wMsg);
        {-respond to left button releases}
      procedure wmMouseMove(var Msg : wMsg);
        {-respond to mouse movements}
      procedure wmTimer(var Msg : wMsg);
        {-respond to automatic scroll timer}
      procedure wmVScroll(var Msg : wMsg);
        {-scroll vertically}
      procedure wmHScroll(var Msg : wMsg);
        {-scroll horizontally}

      procedure wmDropFiles(var Msg : wMsg);
        {-get a dropped file}
     end;

  procedure RegisterFaxViewerClass(Designing : Boolean);

implementation

{Miscellaneous functions}

  function GetViewerPtr(HW : TApdHwnd) : TViewer;
    {-Extract the fax viewer pointer from the window long}
  begin
    GetViewerPtr := TViewer(GetWindowLong(HW, gwl_Viewer));
  end;

  procedure ExchangeInts(var I, J : Integer); assembler; register;
  {$ifndef CPUX64}
  asm
    push  ebx
    mov   ebx,[eax]
    mov   ecx,[edx]
    mov   [edx],ebx
    mov   [eax],ecx
    pop   ebx
  end;
  {$else}
  asm
    mov   r8d,[rcx]
    mov   eax,[rdx]
    mov   [rdx],r8d
    mov   [rcx],eax
  end;
  {$endif}

{******************************************************************************}

{TViewer}

  constructor TViewer.Create(AWnd : TApdHwnd);
  begin
    if (upInitFaxUnpacker(vUnpacker, nil, nil) < ecOK) then
      raise Exception.Create('TViewer.Create: upInitFaxUnpacker failed'); // Fail;

    vWnd          := AWnd;

    vImage        := nil;
    vLoadWholeFax := False;
    vBusyCursor   := LoadCursor(0, idc_Arrow);

    vDragDrop     := False;

    vFGColor      := DefViewerFG;
    vBGColor      := DefViewerBG;
    vScaledWidth  := 0;
    vScaledHeight := 0;
    vVScrollInc   := DefVScrollInc;
    vHScrollInc   := DefHScrollInc;
    vSizing       := False;
    vVScrolling   := False;
    vHScrolling   := False;

    vNumPages     := 0;
    vOnPage       := 0;
    vTopRow       := 0;
    vLeftOfs      := 0;
    vMaxVScroll   := 0;
    vMaxHScroll   := 0;

    vHMult        := 1;
    vHDiv         := 1;
    vVMult        := 1;
    vVDiv         := 1;

    vRotateDir    := 0;

    vMarked       := False;
    vCaptured     := False;
    vOutsideEdge  := False;

    vCtrlDown     := False;

    vDefWndProc   := DefWindowProc;

    vUpdating     := False;
    vDesigning    := False;
  end;

  destructor TViewer.Destroy;
  begin
    if vCaptured then begin
      ReleaseCapture;
      if vOutsideEdge then
        KillTimer(vWnd, 1);
    end;

    if vDragDrop then
      DragAcceptFiles(vWnd, False);
    upDoneFaxUnpacker(vUnpacker);
    vDisposeFax;
    inherited Destroy;
  end;

  procedure TViewer.vAllocFax(NumPages : Cardinal);
    {-Allocate memory for the fax}
  begin
    {reset fax variables}
    vNumPages := NumPages;
    vOnPage   := 0;
    vTopRow   := 0;
    vLeftOfs  := 0;

    {allocate memory for images}
    vImage := AllocMem(SizeOf(TMemoryBitmapDesc) * vNumPages);
  end;

  procedure TViewer.vDisposeFax;
    {-Dispose of the current fax}
  var
    I : Word;

  begin
    if (vImage = nil) or (vNumPages = 0) then
      Exit;

    {deallocate pages and free bitmaps}
    for I := 1 to vNumPages do
      if (vImage^[I].Bitmap <> 0) then
        DeleteObject(vImage^[I].Bitmap);
    FreeMem(vImage, SizeOf(TMemoryBitmapDesc) * vNumPages);

    {reset fax variables}
    vImage       := nil;
    vNumPages    := 0;
    vOnPage      := 0;
    vTopRow      := 0;
    vLeftOfs     := 0;
    vFileName    := '';
  end;

  procedure TViewer.vInitScrollbars;
    {-Set scrollbar ranges and initial positions}
  begin
    {calculate the maximum position of scroll thumbs}
    vCalcMaxScrollPos;

    {update the scrollbars with their [possibly] new ranges}
    SetScrollRange(vWnd, sb_Vert, 0, vMaxVScroll, False);
    SetScrollRange(vWnd, sb_Horz, 0, vMaxHScroll, False);

    {move scroll thumbs}
    vUpdateScrollThumb(True);
    vUpdateScrollThumb(False);
  end;

  procedure TViewer.vUpdateScrollThumb(Vert : Bool);
    {-Update the thumb position on the vertical or horizontal scrollbar}
  begin
    if Vert then
      SetScrollPos(vWnd, sb_Vert, vTopRow, True)
    else
      SetScrollPos(vWnd, sb_Horz, vLeftOfs, True);
  end;

  procedure TViewer.vCalcMaxScrollPos;
    {-Calculate the maximum horizontal and vertical scrollbar positions}
  var
    R : TRect;
    W : Word;
    H : Word;

  begin
    {if there's no image, no scrollbars}
    if (vImage = nil) then begin
      vMaxVScroll := 0;
      vMaxHScroll := 0;

    end else begin
      GetClientRect(vWnd, R);

      {get width and height of client area}
      W := Succ(R.Right - R.Left);
      H := Succ(R.Bottom - R.Top);

      {calculate the maximum scrollbar position that will show}
      {the right edge of the image flush against the right}
      {edge of the window}
      if (vScaledWidth > W) then
        vMaxHScroll := vScaledWidth - W
      else if (vLeftOfs = 0) then
        vMaxHScroll := 0
      else
        vMaxHScroll := vLeftOfs;

      {calculate the maximum scrollbar position that will show}
      {the bottom edge of the image flush against the bottom}
      {edge of the window}
      if (vScaledHeight > H) then
        vMaxVScroll := vScaledHeight - H
      else if (vTopRow = 0) then
        vMaxVScroll := 0
      else
        vMaxVScroll := vTopRow;
    end;
  end;

  procedure TViewer.vScrollUpPrim(Delta : Cardinal);
    {-Scroll the display up Delta rows}
  var
    R : TRect;

  begin
    if (vImage = nil) then
      Exit;
    if (Integer(vTopRow - Delta) < 0) then
      Delta := vTopRow;
    if (Delta = 0) then
      Exit;

    {change the top row}
    Dec(vTopRow, Delta);

    {create a rectangle describing the new, invalid region}
    GetClientRect(vWnd, R);
    R.Bottom := R.Top + Integer(Delta) - 1;                        

    {scroll the window up}
    ScrollWindow(vWnd, 0, Delta, nil, nil);

    {invalidate and update the changed area}
    InvalidateRect(vWnd, @R, False);
    UpdateWindow(vWnd);

    {if not already scrolling by scrollbar, and the scroll}
    {thumb has been homed, reinitialize the scrollbars}
    if not vVScrolling and (vTopRow = 0) then
      vInitScrollbars
    else
      {update the scrollbar}
      vUpdateScrollThumb(True);
  end;

  procedure TViewer.vScrollDownPrim(Delta : Cardinal);
    {-Scroll the display down Delta rows}
  var
    R : TRect;

  begin
    if (vImage = nil) then
      Exit;
    if ((vTopRow + Delta) > vMaxVScroll) then
      Delta := vMaxVScroll - vTopRow;
    if (Delta = 0) then
      Exit;

    {change the top row}
    Inc(vTopRow, Delta);

    {create a rectangle describing the new, invalid region}
    GetClientRect(vWnd, R);
    R.Top := R.Bottom - Integer(Delta) + 1;                         

    {scroll the window up}
    ScrollWindow(vWnd, 0, -Delta, nil, nil);

    {invalidate and update the changed area}
    InvalidateRect(vWnd, @R, False);
    UpdateWindow(vWnd);

    {update the scrollbar}
    vUpdateScrollThumb(True);
  end;

  procedure TViewer.vScrollLeftPrim(Delta : Cardinal);
    {-Scroll the display left Delta columns}
  var
    R : TRect;
    W : Word;

  begin
    if (vImage = nil) then
      Exit;
    if (Integer(vLeftOfs - Delta) < 0) then
      Delta := vLeftOfs;
    if (Delta = 0) then
      Exit;

    {get the width of the client area}
    GetClientRect(vWnd, R);
    W := Succ(R.Right - R.Left);

    {change the left offset}
    Dec(vLeftOfs, Delta);

    {if the amount to scroll is greater than the display width,}
    {then invalidate everything}
    if (Delta > W) then
      vInvalidateAll
    else begin
      {create a rectangle describing the new, invalid region}
      R.Left := R.Right - Integer(Delta) + 1;

      {scroll the window left}
      ScrollWindow(vWnd, Delta, 0, nil, nil);

      {invalidate and update the changed area}
      InvalidateRect(vWnd, @R, False);
    end;

    {make the changes show}
    UpdateWindow(vWnd);

    {if not already scrolling by scrollbar, and the scroll}
    {thumb has been homed, reinitialize the scrollbars}
    if not vHScrolling and (vLeftOfs = 0) then
      vInitScrollbars
    else
      {update the scrollbar}
      vUpdateScrollThumb(False);
  end;

  procedure TViewer.vScrollRightPrim(Delta : Cardinal);
    {-Scroll the display right Delta columns}
  var
    R : TRect;
    W : Word;

  begin
    if (vImage = nil) then
      Exit;
    if ((vLeftOfs + Delta) > vMaxHScroll) then
      Delta := vMaxHScroll - vLeftOfs;
    if (Delta = 0) then
      Exit;

    {get the width of the client area}
    GetClientRect(vWnd, R);
    W := Succ(R.Right - R.Left);

    {change the left offset}
    Inc(vLeftOfs, Delta);

    {if the amount to scroll is greater than the display width,}
    {then invalidate everything}
    if (Delta > W) then
      vInvalidateAll
    else begin
      {create a rectangle describing the new, invalid region}
      R.Right := R.Left + Integer(Delta) - 1;                      

      {scroll the window left}
      ScrollWindow(vWnd, -Delta, 0, nil, nil);

      {invalidate and update the changed area}
      InvalidateRect(vWnd, @R, False);
    end;

    {make the changes show}
    UpdateWindow(vWnd);

    {update the scrollbar}
    vUpdateScrollThumb(False);
  end;

  procedure TViewer.vScrollUp;
    {-Scroll the display up vVScrollInc lines}
  begin
    vScrollUpPrim(vVScrollInc);
  end;

  procedure TViewer.vScrollDown;
    {-Scroll the display down vVScrollInc lines}
  begin
    vScrollDownPrim(vVScrollInc);
  end;

  procedure TViewer.vScrollLeft;
    {-Scroll the display left vHScrollInc columns}
  begin
    vScrollLeftPrim(vHScrollInc);
  end;

  procedure TViewer.vScrollRight;
    {-Scroll the display left vHScrollInc columns}
  begin
    vScrollRightPrim(vHScrollInc);
  end;

  procedure TViewer.vJumpUp;
    {-Scroll the display up vVScrollInc * 10 lines}
  begin
    vScrollUpPrim(vVScrollInc * 10);
  end;

  procedure TViewer.vJumpDown;
    {-Scroll the display down vVScrollInc * 10 lines}
  begin
    vScrollDownPrim(vVScrollInc * 10);
  end;

  procedure TViewer.vJumpLeft;
    {-Scroll the display left vHScrollInc * 10 columns}
  begin
    vScrollLeftPrim(vHScrollInc * 10);
  end;

  procedure TViewer.vJumpRight;
    {-Scroll the display left vHScrollInc * 10 columns}
  begin
    vScrollRightPrim(vHScrollInc * 10);
  end;

  procedure TViewer.vHomeVertical;
    {-Home the vertical display}
  begin
    if (vTopRow <> 0) then
      vScrollUpPrim(vTopRow);
  end;

  procedure TViewer.vEndVertical;
    {-Scroll the vertical display to the end}
  var
    H : Word;
    R : TRect;

  begin
    if (vImage = nil) then
      Exit;

    {get the width of the client area}
    GetClientRect(vWnd, R);
    H := Succ(R.Bottom - R.Top);

    {if the height of the client area is greater than the height of the}
    {bitmap, then this is the same as moving home}
    if (H > vScaledHeight) then
      vHomeVertical

    {otherwise, scroll so that the bottom edge of the bitmap is touching}
    {the bottom edge of the client area}
    else if (vTopRow <> vMaxVScroll) then
      vScrollDownPrim(vMaxVScroll - vTopRow);
  end;

  procedure TViewer.vHomeHorizontal;
    {-Home the horizontal display}
  begin
    if (vImage = nil) then
      Exit;

    if (vLeftOfs <> 0) then
      vScrollLeftPrim(vLeftOfs);
  end;

  procedure TViewer.vEndHorizontal;
    {-Scroll the horizontal display to the end}
  var
    W : Word;
    R : TRect;

  begin
    if (vImage = nil) then
      Exit;

    {get the width of the client area}
    GetClientRect(vWnd, R);
    W := Succ(R.Right - R.Left);

    {if the width of the client area is greater than the width of the bitmap,}
    {then this is the same as moving home}
    if (W > vScaledWidth) then
      vHomeHorizontal

    {otherwise, scroll so that the right edge of the bitmap is touching}
    {the right edge of the client area}
    else if (vLeftOfs <> vMaxHScroll) then
      vScrollRightPrim(vMaxHScroll - vLeftOfs);
  end;

  const
    InVInitPage : Boolean = False; {Re-entrancy flag} 

  procedure TViewer.vInitPage;
    {-Initialize a new page for viewing}
  var
    Code      : Integer;
    I         : Integer;
    OldCursor : HCursor;

  begin
    if (vImage = nil) then
      Exit;

    if not InVInitPage then
      try
        InVInitPage := True;  

        if not vLoadWholeFax and (vImage^[vOnPage].Bitmap = 0) then begin
          {dispose of old bitmap(s)}
          for I := 1 to vNumPages do
            if (vImage^[I].Bitmap <> 0) then begin
              DeleteObject(vImage^[I].Bitmap);
              vImage^[I].Bitmap := 0;
            end;

          OldCursor := SetCursor(vBusyCursor);
          Code := upUnpackPageToBitmap(vUnpacker, vFileName, vOnPage, vImage^[vOnPage], True);
          SetCursor(OldCursor);
          if (Code < ecOK) then begin
            SendMessage(vWnd, apw_ViewerError, Code, 0);
            vDisposeFax;
            Exit;
          end;

          if (vRotateDir <> 0) then
            if (vRotatePage(vOnPage, vRotateDir) <> ecOK) then begin
              SendMessage(vWnd, apw_ViewerError, Word(ecOutOfMemory), 0);
              vDisposeFax;
              Exit;
            end;
        end;

        {reset page variables and calculate page specific stuff}
        vTopRow       := 0;
        vLeftOfs      := 0;
        vScaledWidth  := DWORD(vImage^[vOnPage].Width)  * vHMult div vHDiv;
        vScaledHeight := DWORD(vImage^[vOnPage].Height) * vVMult div vVDiv; 
        vMarked       := False;
        if vCaptured then
          ReleaseCapture;

        {initialize scrollbars and redraw}
        vInitScrollbars;
        vInvalidateAll;

        SendMessage(vWnd, apw_ViewNotifyPage, 0, vOnPage);

      finally
        InVInitPage := False;
      end;                     
  end;

  procedure TViewer.vPageUp;
    {-Go to the previous page}
  begin
    if (vImage = nil) then
      Exit;
    if InVInitPage then
      Exit;
    if (vOnPage > 1) then begin
      Dec(vOnPage);
      vInitPage;
    end;
  end;

  procedure TViewer.vPageDown;
    {-Go to the next page}
  begin
    if (vImage = nil) then
      Exit;
    if InVInitPage then 
      Exit;
    if (vOnPage < vNumPages) then begin
      Inc(vOnPage);
      vInitPage;
    end;
  end;

  procedure TViewer.vFirstPage;
    {-Go to the first page}
  begin
    if (vImage = nil) then
      Exit;
    if InVInitPage then  
      Exit;
    if (vOnPage = 1) then begin
      vHomeVertical;
      vHomeHorizontal;
    end else begin
      vOnPage := 1;
      vInitPage;
    end;
  end;

  procedure TViewer.vLastPage;
    {-Go to the last page}
  begin
    if (vImage = nil) then
      Exit;
    if InVInitPage then
      Exit;
    if (vNumPages = 1) or (vOnPage = vNumPages) then begin
      vHomeVertical;
      vHomeHorizontal;
    end else begin
      vOnPage := vNumPages;
      vInitPage;
    end;
  end;

  procedure ReverseBits(Dest, Src : Pointer; L : Cardinal); register; assembler;
  {$ifndef CPUX64}
  asm
    push  esi
    push  edi
    push  ebx

    mov   esi,edx         {ESI->Src}
    mov   edi,eax         {ESI->Dest}
    add   edi,ecx         {point EDI to end of destination}
    dec   edi
    dec   edi
    shr   ecx,1           {count words, not bytes}

@1: mov   ax,[esi]
    inc   esi
    inc   esi
    mov   edx,eax
    mov   ah,al
    mov   al,dh

@2:
    {put reverse of AL in AH}
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1

    mov   eax,ebx
    mov   edx,eax
    mov   ah,al
    mov   al,dh
    mov   [edi],ax
    dec   edi
    dec   edi
    dec   ecx
    jnz   @1

    pop   ebx
    pop   edi
    pop   esi
  end;
  {$else}
  asm
    push  rsi
    push  rdi
    push  rbx
    mov   rcx,rax
    mov   rcx,r8

    mov   rsi,rdx         {ESI->Src}
    mov   rdi,rax         {ESI->Dest}
    add   rdi,rcx         {point EDI to end of destination}
    dec   rdi
    dec   rdi
    shr   ecx,1           {count words, not bytes}

@1: mov   ax,[rsi]
    inc   rsi
    inc   rsi
    mov   edx,eax
    mov   ah,al
    mov   al,dh

@2:
    {put reverse of AL in AH}
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1
    shr   ax,1
    rcl   bx,1

    mov   eax,ebx
    mov   edx,eax
    mov   ah,al
    mov   al,dh
    mov   [rdi],ax
    dec   rdi
    dec   rdi
    dec   ecx
    jnz   @1

    pop   rbx
    pop   rdi
    pop   rsi
  end;
  {$endif}

  procedure BitBltRot90(Dest, Src : Pointer; Bit, BytesPerRow, Len : Cardinal); assembler; register;
  {$ifndef CPUX64}
  asm
    push  ebx
    push  esi
    push  edi

    inc   ecx             {increment bit offset}
    mov   esi,eax         {ESI->Dest}
    mov   edi,edx         {EDI->Src}
    mov   ebx,Len         {EBX = loop counter}
    shr   ebx,1

@1: mov   ax,[edi]        {data in AX}
    inc   edi
    inc   edi

    push  ebx             {do this in lieu of xchg, because this is faster}
    mov   bx,ax
    mov   ah,al
    mov   al,bh
    pop   ebx

    xor   dl,dl           {clear DL}
    shl   ax,1            {get the next bit out of AX}
    rcr   dl,cl           {rotate the next bit into position in DL for ORing}
    or    [esi],dl        {or the new data into the destination}
    add   esi,BytesPerRow {find the next line}

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    add   esi,BytesPerRow

    dec   ebx             {decrement counter}
    jnz   @1              {any data left? jump if so}

    pop   edi
    pop   esi
    pop   ebx
  end;
  {$else}
  asm
    push  rbx
    push  rsi
    push  rdi
    mov   rax,rcx
    mov   rcx,r8

    inc   ecx             {increment bit offset}
    mov   rsi,rax         {ESI->Dest}
    mov   rdi,rdx         {EDI->Src}
    mov   ebx,Len         {EBX = loop counter}
    shr   ebx,1

@1: mov   ax,[rdi]        {data in AX}
    inc   rdi
    inc   rdi

    push  rbx             {do this in lieu of xchg, because this is faster}
    mov   bx,ax
    mov   ah,al
    mov   al,bh
    pop   rbx

    xor   dl,dl           {clear DL}
    shl   ax,1            {get the next bit out of AX}
    rcr   dl,cl           {rotate the next bit into position in DL for ORing}
    or    [rsi],dl        {or the new data into the destination}
    mov   r10d, BytesPerRow
    add   rsi,r10 {find the next line}

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   R10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   R10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   R10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    add   rsi,r10

    dec   ebx             {decrement counter}
    jnz   @1              {any data left? jump if so}

    pop   rdi
    pop   rsi
    pop   rbx
  end;
  {$endif}


  procedure BitBltRot270(Dest, Src : Pointer; Bit, BytesPerRow, Len : Cardinal); assembler; register;
  {$ifndef CPUX64}
  asm
    push  ebx
    push  esi
    push  edi

    inc   ecx             {increment bit offset}
    mov   esi,eax         {ESI->Dest}
    mov   edi,edx         {EDI->Src}
    mov   ebx,Len         {EBX = loop counter}
    shr   ebx,1

@1: mov   ax,[edi]        {data in AX}
    inc   edi
    inc   edi

    push  ebx             {do this in lieu of xchg, because this is faster}
    mov   bx,ax
    mov   ah,al
    mov   al,bh
    pop   ebx

    xor   dl,dl           {clear DL}
    shl   ax,1            {get the next bit out of AX}
    rcr   dl,cl           {rotate the next bit into position in DL for ORing}
    or    [esi],dl        {or the new data into the destination}
    sub   esi,BytesPerRow {find the next line}

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [esi],dl
    sub   esi,BytesPerRow

    dec   ebx             {decrement counter}
    jnz   @1              {any data left? jump if so}

    pop   edi
    pop   esi
    pop   ebx
  end;
  {$else}
  asm
    push  rbx
    push  rsi
    push  rdi
    mov   rax,rcx
    mov   rcx,r8

    inc   ecx             {increment bit offset}
    mov   rsi,rax         {ESI->Dest}
    mov   rdi,rdx         {EDI->Src}
    mov   ebx,Len         {EBX = loop counter}
    shr   ebx,1

@1: mov   ax,[rdi]        {data in AX}
    inc   rdi
    inc   rdi

    push  rbx             {do this in lieu of xchg, because this is faster}
    mov   bx,ax
    mov   ah,al
    mov   al,bh
    pop   rbx

    xor   dl,dl           {clear DL}
    shl   ax,1            {get the next bit out of AX}
    rcr   dl,cl           {rotate the next bit into position in DL for ORing}
    or    [rsi],dl        {or the new data into the destination}
    mov   r10d, BytesPerRow
    sub   rsi,r10 {find the next line}

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    xor   dl,dl
    shl   ax,1
    rcr   dl,cl
    or    [rsi],dl
    mov   r10d, BytesPerRow
    sub   rsi,r10

    dec   ebx             {decrement counter}
    jnz   @1              {any data left? jump if so}

    pop   rdi
    pop   rsi
    pop   rbx
  end;
  {$endif}

  function TViewer.vRotatePage(const PageNum, Direction : Cardinal) : Integer;
    {-Rotate a page}
  var
    NewWidth        : Cardinal;
    NewHeight       : Cardinal;
    NewBitmap       : HBitmap;
    BytesPerLine    : Cardinal;
    NewBytesPerLine : Cardinal;
    BmpHandle       : THandle;
    BmpPtr          : Pointer;
    NewHandle       : THandle;
    NewPtr          : Pointer;
    SrcBuf          : Pointer;
    DestBuf         : Pointer;

    function AllocTemporary(var B : TMemoryBitmapDesc) : Boolean;
    var
      Sz      : Integer;
      BmpInfo : TBitmap;

    begin
      AllocTemporary := False;

      with B do begin
        {get information about this bitmap}
        GetObject(B.Bitmap, SizeOf(TBitmap), @BmpInfo);
        BytesPerLine := BmpInfo.bmWidthBytes;
        Sz           := Integer(BytesPerLine) * Integer(Height);

        {allocate a buffer to hold the bitmap bits}
        BmpHandle := GlobalAlloc(gmem_Moveable or gmem_ZeroInit, Sz);
        if (BmpHandle = 0) then
          Exit;
        BmpPtr := GlobalLock(BmpHandle);
        if (BmpPtr = nil) then begin
          GlobalFree(BmpHandle);
          Exit;
        end;

        if (Direction = 2) then begin
          {allocate two temporary buffers for reversing bit patterns}
          SrcBuf := AllocMem(BytesPerLine);
          DestBuf := AllocMem(BytesPerLine);
        end else begin
          NewHeight := BytesPerLine * 8;
          NewWidth  := Height;

          NewBitmap := CreateBitmap(NewWidth, NewHeight, 1, 1, nil);
          GetObject(NewBitmap, SizeOf(TBitmap), @BmpInfo);
          NewBytesPerLine := BmpInfo.bmWidthBytes;

          {allocate temporary buffer to hold new bitmap}
          Sz := Integer(NewBytesPerLine) * Integer(NewHeight);
          NewHandle := GlobalAlloc(gmem_Moveable or gmem_ZeroInit, Sz);
          if (NewHandle = 0) then begin
            GlobalUnlock(BmpHandle);
            GlobalFree(BmpHandle);
            Exit;
          end;
          NewPtr := GlobalLock(NewHandle);
          if (NewPtr = nil) then begin
            GlobalFree(NewHandle);
            GlobalUnlock(BmpHandle);
            GlobalFree(BmpHandle);
            Exit;
          end;
        end;

        GetBitmapBits(Bitmap, Sz, BmpPtr);
      end;

      AllocTemporary := True;
    end;

    procedure FreeTemporary;
    begin
      GlobalUnlock(BmpHandle);
      GlobalFree(BmpHandle);
      if (Direction = 2) then begin
        FreeMem(SrcBuf, BytesPerLine);
        FreeMem(DestBuf, BytesPerLine);
      end else begin
        GlobalUnlock(NewHandle);
        GlobalFree(NewHandle);
      end;
    end;

    procedure HugeFill(Dest : Pointer; Len : Integer; Value : Byte);
    begin
      FillChar(Dest^, Len, Value);
    end;

    procedure Rotate90(var B : TMemoryBitmapDesc);
    var
      I        : Integer;
      Col      : Cardinal;
      Bit      : Cardinal;
      ActBytes : Cardinal;
      DestCol  : Pointer;

    begin
      Col      := (NewWidth - 1) div 8;
      Bit      := (NewWidth - 1) mod 8;  
      DestCol  := GetPtr(NewPtr, Col);
      ActBytes := (B.Width div 8) + Cardinal(Ord((B.Width mod 8) <> 0)); 

      {$IFOPT Q+}
      {$DEFINE QOn}
      {$ENDIF}
      {$Q-}
      for I := 0 to Pred(NewWidth) do begin 
        BitBltRot90(DestCol, GetPtr(BmpPtr, Integer(BytesPerLine) * I), Bit, NewBytesPerLine, ActBytes);
        if (Bit = 0) then begin
          Bit := 7;
          Dec(Col);
          DestCol := GetPtr(NewPtr, Col);
        end else
          Dec(Bit);
      end;
      for I := (B.Width - (B.Width mod 8)) to Pred(NewHeight) do
        HugeFill(GetPtr(NewPtr, Integer(NewBytesPerLine) * I), NewBytesPerLine, $FF);
      {$IFDEF QOn}
      {$Q+}
      {$ENDIF}

      B.Width  := NewWidth;
      B.Height := NewHeight;
      DeleteObject(B.Bitmap);
      B.Bitmap := NewBitmap;
      SetBitmapBits(B.Bitmap,
        Integer(NewBytesPerLine) * Integer(NewHeight), NewPtr);
    end;

    procedure Rotate180(var B : TMemoryBitmapDesc);
    var
      I         : Integer;
      J         : Integer;
      ActBytes  : Cardinal;
      Ofs       : Integer;
      IOfs      : Integer;
      JOfs      : Integer;
      Remaining : Byte;
      Mask      : Byte;

    begin
      Remaining := (B.Width mod 8);
      ActBytes  := (B.Width div 8) + Cardinal(Ord(Remaining <> 0));
      I         := 0;
      J         := Pred(B.Height);

      if (Remaining <> 0) then
        Mask := ($FF shr Remaining)
      else
        Mask := 0;                                                  

      while (I < J) do begin
        IOfs := Integer(BytesPerLine) * I;
        JOfs := Integer(BytesPerLine) * J;

        Move(GetPtr(BmpPtr, IOfs)^, SrcBuf^, ActBytes);
        if (Remaining <> 0) then
          PByteArray(SrcBuf)^[ActBytes-1] := PByteArray(SrcBuf)^[ActBytes-1] or Mask;
        if (ActBytes <> BytesPerLine) then
          FillChar(GetPtr(SrcBuf, ActBytes)^, BytesPerLine - ActBytes, $FF);
        ReverseBits(DestBuf, SrcBuf, BytesPerLine);
        Move(GetPtr(BmpPtr, JOfs)^, SrcBuf^, ActBytes);
        if (Remaining <> 0) then
          PByteArray(SrcBuf)^[ActBytes-1] := PByteArray(SrcBuf)^[ActBytes-1] or Mask;
        if (ActBytes <> BytesPerLine) then
          FillChar(GetPtr(SrcBuf, ActBytes)^, BytesPerLine - ActBytes, $FF);
        Move(DestBuf^, GetPtr(BmpPtr, JOfs)^, BytesPerLine);
        ReverseBits(DestBuf, SrcBuf, BytesPerLine);
        Move(DestBuf^, GetPtr(BmpPtr, IOfs)^, BytesPerLine);

        Inc(I);
        Dec(J);
      end;

      {if there's a stray line, reverse it}
      if Odd(B.Height) then begin
        Ofs := Integer(BytesPerLine) * Integer(B.Height div 2);

        Move(GetPtr(BmpPtr, Ofs)^, SrcBuf^, BytesPerLine);
        if (Remaining <> 0) then
          PByteArray(SrcBuf)^[ActBytes-1] := PByteArray(SrcBuf)^[ActBytes-1] or Mask;
        if (ActBytes <> BytesPerLine) then
          FillChar(GetPtr(SrcBuf, ActBytes)^, BytesPerLine - ActBytes, $FF);
        ReverseBits(DestBuf, SrcBuf, BytesPerLine);
        Move(DestBuf^, GetPtr(BmpPtr, Ofs)^, BytesPerLine);
      end;

      SetBitmapBits(B.Bitmap, Integer(BytesPerLine) * Integer(B.Height), BmpPtr);
    end;

    procedure Rotate270(var B : TMemoryBitmapDesc);
    var
      I        : Integer;
      Col      : Cardinal;
      Bit      : Cardinal;
      ActBytes : Cardinal;
      DestCol  : Pointer;

    begin
      Col      := 0;
      Bit      := 0;
      DestCol  := GetPtr(NewPtr, DWORD(NewBytesPerLine) * Pred(NewHeight));
      ActBytes := (B.Width div 8) + Cardinal(Ord((B.Width mod 8) <> 0));   

      {$IFOPT Q+}
      {$DEFINE QOn}
      {$ENDIF}
      {$Q-}
      for I := 0 to Pred(NewWidth) do begin
        BitBltRot270(DestCol, GetPtr(BmpPtr, Integer(BytesPerLine) * I), Bit, NewBytesPerLine, ActBytes);
        if (Bit = 7) then begin
          Bit := 0;
          Inc(Col);
          DestCol := GetPtr(NewPtr, (DWORD(NewBytesPerLine) * Pred(NewHeight)) + Col);
        end else
          Inc(Bit);
      end;
      if (NewHeight > (B.Width - (B.Width mod 8))) then
        for I := 0 to (NewHeight - (B.Width - (B.Width mod 8))) do
          HugeFill(GetPtr(NewPtr, Integer(NewBytesPerLine) * I), NewBytesPerLine, $FF);
      {$IFDEF QOn}
      {$Q+}
      {$ENDIF}

      B.Width  := NewWidth;
      B.Height := NewHeight;
      DeleteObject(B.Bitmap);
      B.Bitmap := NewBitmap;
      SetBitmapBits(B.Bitmap, Integer(NewBytesPerLine) * Integer(NewHeight), NewPtr);
    end;

  begin
    if not AllocTemporary(vImage^[PageNum]) then begin
      vRotatePage := ecOutOfMemory;
      Exit;
    end;

    vRotatePage := ecOK;

    case Direction of
      1: Rotate90(vImage^[PageNum]);
      2: Rotate180(vImage^[PageNum]);
      3: Rotate270(vImage^[PageNum]);
    end;

    FreeTemporary;
  end;

  procedure TViewer.vUpdateMarkRect(Client : TRect; X, Y : Integer);
    {-Update the mark rectangle}
  var
    NewMark : TRect;
    Total   : TRect;
    Dest    : TRect;

  begin
    if (vImage = nil) then
      Exit;
    NewMark := vMarkRect;

    {change the anchor corner's coordinate}
    case vAnchorCorner of
      1: begin NewMark.Right := X; NewMark.Bottom := Y; end;
      2: begin NewMark.Left  := X; NewMark.Bottom := Y; end;
      3: begin NewMark.Left  := X; NewMark.Top    := Y; end;
      4: begin NewMark.Right := X; NewMark.Top    := Y; end;
    end;

    {fix the rectangle}
    if (NewMark.Right < NewMark.Left) then
      ExchangeInts(NewMark.Right, NewMark.Left);
    if (NewMark.Bottom < NewMark.Top) then
      ExchangeInts(NewMark.Bottom, NewMark.Top);

    {find the new anchor corner}
    if (X = NewMark.Right) and (Y = NewMark.Bottom) then
      vAnchorCorner := 1
    else if (X = NewMark.Right) and (Y = NewMark.Top) then
      vAnchorCorner := 4
    else if (X = NewMark.Left) and (Y = NewMark.Bottom) then
      vAnchorCorner := 2
    else if (X = NewMark.Left) and (Y = NewMark.Top) then
      vAnchorCorner := 3;

    {adjust the new marked rectangle so it doesn't exceed the image maximums}
    if (NewMark.Right >= Integer(vScaledWidth)) then
      NewMark.Right := Pred(vScaledWidth);
    if (NewMark.Bottom >= Integer(vScaledHeight)) then               
      NewMark.Bottom := Pred(vScaledHeight);
    if (NewMark.Left < 0) then
      NewMark.Left := 0;
    if (NewMark.Top < 0) then
      NewMark.Top := 0;

    {find the area that needs updating}
    UnionRect(Total, NewMark, vMarkRect);
    vMarkRect := NewMark;

    vGetMarkClientIntersection(Dest, Total);
    if (Dest.Left <> Dest.Right) and (Dest.Top <> Dest.Bottom) then begin
      InvalidateRect(vWnd, @Dest, False);
      UpdateWindow(vWnd);
    end;
  end;

  procedure TViewer.vCopyToClipboard;
    {-Copy the marked bitmap to the clipboard}
  var
    W      : Word;
    H      : Word;
    B      : HBitmap;
    TempDC : HDC;
    DC1    : HDC;
    DC2    : HDC;

  begin
    if (vImage = nil) or not vMarked then
      Exit;

    {calculate width and height of clipbitmap}
    W := Succ(vMarkRect.Right - vMarkRect.Left);
    H := Succ(vMarkRect.Bottom - vMarkRect.Top);

    {create the destination monochrome bitmap}
    B := CreateBitmap(W, H, 1, 1, nil);

    {create a temporary DC compatible with the diplay}
    TempDC := GetDC(vWnd);

    {create two memory DCs for the copy of the bitmap}
    DC1 := CreateCompatibleDC(TempDC);
    ReleaseDC(vWnd, TempDC);
    DC2 := CreateCompatibleDC(DC1);

    {select the source bitmap into the source context}
    SelectObject(DC1, vImage^[vOnPage].Bitmap);

    {select the destination bitmap into the destination context}
    SelectObject(DC2, B);

    SafeYield;                                                         

    {copy the bitmap}
    if (vVMult = 1) and (vHMult = 1) and (vVDiv = 1) and (vHMult = 1) then
      BitBlt(DC2, 0, 0, W, H, DC1, vMarkRect.Left, vMarkRect.Top, SrcCopy)
    else
      StretchBlt(DC2, 0, 0, W, H, DC1,
                 (DWORD(vMarkRect.Left) * vHDiv) div vHMult,
                 (DWORD(vMarkRect.Top)  * vVDiv) div vVMult,
                 (DWORD(W) * vHDiv) div vHMult,
                 (DWORD(H) * vVDiv) div vVMult,
                 SrcCopy);

    SafeYield;                                                         

    {free resources}
    DeleteDC(DC1);
    DeleteDC(DC2);

    {put the data in the clipboard}
    if not OpenClipboard(vWnd) then exit;
    SetClipboardData(cf_Bitmap, B);
    CloseClipboard;
  end;

  procedure TViewer.vInvalidateAll;
    {-Invalidate the entire viewer window}
  begin
    InvalidateRect(vWnd, nil, True);
  end;

  procedure TViewer.vPaint(PaintDC : HDC; var PaintInfo : TPaintStruct);
    {-Paint a rectangle of image}
  var
    Width       : Integer;
    Height      : Integer;
    CWidth      : Integer;
    CHeight     : Integer;
    BackBrush   : HBrush;
    OldBmp      : HBitmap;
    ScaleOldBmp : HBitmap;
    MemDC       : HDC;
    BmpDC       : HDC;
    ScaleBmp    : HBitmap;
    PR          : TRect;
    VFill       : TRect;
    HFill       : TRect;
    ISect       : TRect;
    Client      : TRect;

    procedure FillBackground;
    var
      FillR : TRect;

    begin
      {fill the background}
      FillR := PaintInfo.rcPaint;
      Inc(FillR.Right);
      Inc(FillR.Bottom);

      FillRect(PaintDC, FillR, BackBrush);
      DeleteObject(BackBrush);
    end;

    function ScaledCoordH(PT : Integer) : Integer;
    var
      M : Integer;
      S : Integer;

    begin
      M := PT * Integer(vHDiv);
      S := M div Integer(vHMult);
      if ((M mod Integer(vHMult)) <> 0) then
        Inc(S);
      ScaledCoordH := S;
    end;

    function ScaledCoordV(PT : Integer) : Integer;
    var
      M : Integer;
      S : Integer;

    begin
      M := Integer(PT) * Integer(vVDiv);
      S := M div Integer(vVMult);
      if ((M mod Integer(vVMult)) <> 0) then
        Inc(S);
      ScaledCoordV := S;
    end;

  begin
    PR := PaintInfo.rcPaint;

    {if the rectangle is invalid, exit}
    if (PR.Left = PR.Right) or (PR.Top = PR.Bottom) then
      Exit;

    {make a brush for filling the background}
    BackBrush := CreateSolidBrush(vBGColor);

    {if we're in design mode, then just fill our background}
    if vDesigning then begin
      FillBackground;
      TextOut(PaintDC, 3, 3, PChar(vComponentName), Length(vComponentName));
      Exit;
    end;

    {if there's no fax loaded, or the current page is greater than}
    {the total number of pages, there's nothing to paint          }
    if (vOnPage = 0) or (vOnPage > vNumPages) or (vImage = nil) then begin
      FillBackground;
      Exit;
    end;

    {set the foreground and background colors}
    SetTextColor(PaintDC, vFGColor);
    SetBkColor(PaintDC, vBGColor);

    {create a memory DC for painting}
    MemDC  := CreateCompatibleDC(PaintDC);
    OldBmp := SelectObject(MemDC, vImage^[vOnPage].Bitmap);

    VFill := PR;
    {calculate the width of the destination rectangle}
    Width := Succ(PR.Right - PR.Left);
    if ((Integer(vLeftOfs) + PR.Left + Width) > Integer(vScaledWidth)) then begin
      {fill in everything outside}
      VFill.Left := vScaledWidth - vLeftOfs;
      Inc(VFill.Right);
      Inc(VFill.Bottom);
      FillRect(PaintDC, VFill, BackBrush);

      {adjust the width}
      Dec(Width, (Integer(vLeftOfs) + PR.Left + Width) - Integer(vScaledWidth));
    end;

    {calculate the height of the destination rectangle}
    Height := Succ(PR.Bottom - PR.Top);
    if ((Integer(vTopRow) + PR.Top + Height) > Integer(vScaledHeight)) then begin
      HFill := PR;
      {fill in everything outside}
      HFill.Top := vScaledHeight - vTopRow;
      Inc(HFill.Right);
      Inc(HFill.Bottom);

      {if the horizontal fill rectangle intersects with the}
      {vertical fill rectangle, adjust the horizontal rect}
      {accordingly}
      if not IntersectRect(ISect, HFill, VFill) then
        {if the intersection is equal to the horizontal rect}
        {then the full rectangle should be filled, otherwise}
        {it is adjusted}
        if not EqualRect(ISect, HFill) then
          HFill.Right := Pred(VFill.Left);

      FillRect(PaintDC, HFill, BackBrush);

      {adjust the height}
      Dec(Height, (Integer(vTopRow) + PR.Top + Height) - Integer(vScaledHeight));
    end;

    SafeYield;                                                         
    if (vHMult = 1) and (vHDiv = 1) and (vVMult = 1) and (vVDiv = 1) then begin
      if vMarked then
        InvertRect(MemDC, vMarkRect);

      {paint the bitmap}
      BitBlt(PaintDC, PR.Left, PR.Top, Width, Height, MemDC,
        Integer(vLeftOfs) + PR.Left, Integer(vTopRow) + PR.Top, SrcCopy);

      if vMarked then
        InvertRect(MemDC, vMarkRect);

    end else if not vMarked then
      {scale and paint the bitmap}
      StretchBlt(PaintDC, PR.Left, PR.Top, Width, Height, MemDC,
        (Integer(vLeftOfs) + PR.Left) * Integer(vHDiv) div Integer(vHMult),
        (Integer(vTopRow) + PR.Top) * Integer(vVDiv) div Integer(vVMult),
        Integer(Width) * Integer(vHDiv) div Integer(vHMult),
        Integer(Height) * Integer(vVDiv) div Integer(vVMult), SrcCopy)
    else begin
      GetClientRect(vWnd, Client);

      {calculate the width and height of the client rectangle, adjusting}
      {for the size of the scaled bitmap}
      CWidth := Client.Right - Client.Left + 1;
      if (CWidth > Integer(vScaledWidth - vLeftOfs)) then
        CWidth := (vScaledWidth - vLeftOfs);
      CHeight := Client.Bottom - Client.Top + 1;
      if (CHeight > Integer(vScaledHeight - vTopRow)) then
        CHeight := (vScaledHeight - vTopRow);

      BmpDC       := CreateCompatibleDC(PaintDC);
      ScaleBmp    := CreateCompatibleBitmap(PaintDC, CWidth, CHeight);
      ScaleOldBmp := SelectObject(BmpDC, ScaleBmp);

      SafeYield;                                                       

      {scale the bitmap}
      StretchBlt(BmpDC, 0, 0, CWidth, CHeight,
                 MemDC,
                 ScaledCoordH(vLeftOfs),
                 ScaledCoordV(vTopRow),
                 ScaledCoordH(CWidth),
                 ScaledCoordV(CHeight),
                 SrcCopy);

      {invert the marked rectangle, if necessary}
      if vMarked then
        InvertRect(BmpDC, vMarkRect);

      SafeYield;                                                       

      BitBlt(PaintDC, PR.Left, PR.Top, Width, Height, BmpDC, PR.Left,
             PR.Top, SrcCopy);

      if vMarked then
        InvertRect(BmpDC, vMarkRect);

      SelectObject(BmpDC, ScaleOldBmp);
      DeleteObject(ScaleBmp);
      DeleteDC(BmpDC);
    end;

    SafeYield;                                                         
    {clean up}
    DeleteObject(BackBrush);
    SelectObject(MemDC, OldBmp);
    DeleteDC(MemDC);
  end;

  procedure TViewer.vGetMarkClientIntersection(var R : TRect; Mark : TRect);
    {-Find the intersection of the client rect and the marked rect}
  var
    Client : TRect;

  begin
    GetClientRect(vWnd, Client);

    Inc(Client.Top, vTopRow);
    Inc(Client.Bottom, vTopRow);
    Inc(Client.Left, vLeftOfs);
    Inc(Client.Right, vLeftOfs);

    if IntersectRect(R, Mark, Client) then begin
      Dec(R.Top, vTopRow);
      Dec(R.Bottom, vTopRow);
      Dec(R.Left, vLeftOfs);
      Dec(R.Right, vLeftOfs);
    end else
      FillChar(R, SizeOf(TRect), 0);
  end;

  procedure TViewer.vInitDragDrop(Enabled : Bool);
    {-Initialize drag and drop features}
  begin
    vDragDrop := Enabled;
    if Enabled then
      DragAcceptFiles(vWnd, True);
  end;

  function TViewer.apwViewSetFile(FName : string) : Integer;
    {-Set the file name of the file to view}
  var
    I         : Word;
    Code      : Integer;
    OldCursor : HCursor;
    FH        : TFaxHeaderRec;

  begin
    apwViewSetFile := ecOK;

    if FName = '' then
    begin
      vFileName := '';
      vDisposeFax;
      Exit;
    end;

    {make sure the file is an APF file}
    if not ExistFileZ(PChar(FName)) then begin
      apwViewSetFile := ecFileNotFound;
      Exit;
    end;

    if not awIsAnAPFFile(FName) then begin
      apwViewSetFile := ecFaxBadFormat;
      Exit;
    end;

    vDisposeFax;
    vFileName := FName;
    vInvalidateAll;
    UpdateWindow(vWnd);

    {get the number of pages}
    Code := upGetFaxHeader(vUnpacker, FName, FH);
    if (Code < ecOK) then begin
      apwViewSetFile := Code;
      Exit;
    end;

    {allocate the image}
    vAllocFax(FH.PageCount);

    {load each page into the bitmap}
    if vLoadWholeFax then begin
      OldCursor := SetCursor(vBusyCursor);
      for I := 1 to FH.PageCount do begin
        Code := upUnpackPageToBitmap(vUnpacker, FName, I, vImage^[I], True);
        if (Code < ecOK) then begin
          SetCursor(OldCursor);
          apwViewSetFile := Code;
          Exit;
        end;
      end;
      SetCursor(OldCursor);
    end else begin
      OldCursor := Setcursor(vBusyCursor);
      Code := upUnpackPageToBitmap(vUnpacker, FName, 1, vImage^[1], True);
      if (Code < ecOK) then begin
        SetCursor(OldCursor);
        apwViewSetFile := Code;
        Exit;
      end;
      SetCursor(OldCursor);
    end;

    vOnPage    := 1;
    vRotateDir := 0;
    vHMult     := 1;
    vHDiv      := 1;
    vVMult     := 1;
    vVDiv      := 1;
    vInitPage;

    apwViewSetFile := ecOK;
  end;

  procedure TViewer.apwViewSetFG(Color : Integer);
    {-Set the foreground color}
  begin
    vFGColor := Color;
  end;

  procedure TViewer.apwViewSetBG(Color : Integer);
    {-Set the background color}
  begin
    vBGColor := Color;
  end;

  procedure TViewer.apwViewSetScale(Settings : PScaleSettings);
    {-Set scaling factors}
  var
    OldHMult : Word;
    OldHDiv  : Word;
    OldVMult : Word;
    OldVDiv  : Word;

  begin
    if (Settings = nil) then
      Exit;

    OldHMult := vHMult;
    OldHDiv  := vHDiv;
    OldVMult := vVMult;
    OldVDiv  := vVDiv;

    with Settings^ do begin
      vHMult := HMult;
      vHDiv  := HDiv;
      if (vHMult = vHDiv) then begin
        vHMult := 1;
        vHDiv  := 1;
      end;

      vVMult := VMult;
      vVDiv  := VDiv;
      if (vVMult = vVDiv) then begin
        vVMult := 1;
        vVDiv  := 1;
      end;
    end;

    {only update screen if image loaded settings have changed}
    if (vImage = nil) or
       ((OldHMult = vHMult) and (OldHDiv = vHDiv) and
        (OldVMult = vVMult) and (OldVDiv = vVDiv)) then
      Exit;

    {scale the current offsets, scrollbar positions, etc.}
    if not vUpdating then
      vInitPage;
  end;

  function TViewer.apwViewSetWhitespace(FromLines, ToLines : Cardinal) : Integer;
    {-Set whitespace compression factors}
  begin
    apwViewSetWhitespace := upSetWhitespaceCompression(vUnpacker, FromLines, ToLines);
  end;

  procedure TViewer.apwViewSetScroll(HScroll, VScroll : Cardinal);
    {-Set the vertical and horizontal scroll increments}
  begin
    if (HScroll <> 0) then
      vHScrollInc := HScroll;
    if (VScroll <> 0) then
      vVScrollInc := VScroll;
  end;

  function TViewer.apwViewSelectAll : Integer;
    {-Select entire image}
  begin
    if (vImage = nil) then
      apwViewSelectAll := ecNoImageLoaded
    else begin
      if vCaptured then begin
        ReleaseCapture;
        if vOutsideEdge then
          KillTimer(vWnd, 1);
        vCaptured := False;
      end;

      apwViewSelectAll := ecOK;

      vMarked := True;
      vMarkRect.Left   := 0;
      vMarkRect.Top    := 0;
      vMarkRect.Right  := Pred(vScaledWidth);
      vMarkRect.Bottom := Pred(vScaledHeight);
      vInvalidateAll;
      UpdateWindow(vWnd);
    end;
  end;

  function MaxCard(C1, C2 : Cardinal) : Cardinal; assembler;
  {$ifndef CPUX64}
  asm
    cmp   eax,edx
    jae   @1
    mov   eax,edx
@1:
  end;
  {$else}
  asm
    sub   ecx,edx
    sbb   eax,eax
    not   eax
    and   eax,ecx
    add   eax,edx
  end;
  {$endif}

  function MinCard(C1, C2 : Cardinal) : Cardinal; assembler;
  {$ifndef CPUX64}
  asm
    cmp   eax,edx
    jbe   @1
    mov   eax,edx
@1:
  end;
  {$else}
  asm
    sub   ecx,edx
    sbb   eax,eax
    and   eax,ecx
    add   eax,edx
  end;
  {$endif}

  function TViewer.apwViewSelect(R : PRect) : Integer;
    {-Select a portion of fax image}
  begin
    if (vImage = nil) then
      apwViewSelect := ecNoImageLoaded
    else begin
      apwViewSelect := ecOK;
      if (R = nil) then
        Exit;

      if vCaptured then begin
        ReleaseCapture;
        vCaptured := False;
      end;

      vMarked := True;

      vMarkRect        := R^;
      vMarkRect.Left   := MaxCard(0, vMarkRect.Left);
      vMarkRect.Top    := MaxCard(0, vMarkRect.Top);
      vMarkRect.Right  := MinCard(Pred(vScaledWidth), vMarkRect.Right);
      vMarkRect.Bottom := MinCard(Pred(vScaledHeight), vMarkRect.Bottom);

      vInvalidateAll;
      UpdateWindow(vWnd);
    end;
  end;

  function TViewer.apwViewCopy : Integer;
    {-Copy image data to clipboard}
  begin
    if (vImage = nil) then
      apwViewCopy := ecNoImageLoaded
    else if not vMarked then
      apwViewCopy := ecNoImageBlockMarked
    else begin
      apwViewCopy := ecOK;
      vCopyToClipboard;
    end;
  end;

  function TViewer.apwViewGetBitmap(Page : Cardinal; Point : PPoint) : HBitmap;
    {-Retrieve the bitmap for page number Page}
  var
    Code      : Integer;
    Desc      : TMemoryBitmapDesc;
    OldCursor : HCursor;

  begin
    if (Page > vNumPages) then
      apwViewGetBitmap := 0
    else begin
      if vLoadWholeFax then begin
        apwViewGetBitmap := vImage^[Page].Bitmap;
        Point^.X := vImage^[Page].Width;
        Point^.Y := vImage^[Page].Height;
      end else
        if (vImage^[Page].Bitmap <> 0) then begin
          apwViewGetBitmap := vImage^[Page].Bitmap;
          Point^.X := vImage^[Page].Width;
          Point^.Y := vImage^[Page].Height;
        end else begin
          OldCursor := SetCursor(vBusyCursor);
          Code := upUnpackPageToBitmap(vUnpacker, vFileName, Page, Desc, True);
          SetCursor(OldCursor);
          if (Code < ecOK) then begin
            SendMessage(vWnd, apw_ViewerError, Code, 0);
            apwViewGetBitmap := 0
          end else begin
            apwViewGetBitmap := Desc.Bitmap;
            Point^.X := Desc.Width;
            Point^.Y := Desc.Height;
          end;
        end;
    end;
  end;

  function TViewer.apwViewGetNumPages : Cardinal;
    {-Retrieve the number of pages in the fax}
  begin
    apwViewGetNumPages := vNumPages;
  end;

  procedure TViewer.apwViewStartUpdate;
    {-Begin update of scaling parameters}
  begin
    vUpdating := True;
  end;

  procedure TViewer.apwViewEndUpdate;
    {-End update of scaling parameters}
  begin
    vUpdating := False;
    vInitPage;
  end;

  procedure TViewer.apwViewSetWndProc(var Msg : wMsg);
    {-Set the viewer's window procedure}
  begin
    if Pointer(Msg.lParam) <> nil then
      vDefWndProc := TViewerWndProc(Msg.lParam)
    else if Msg.wParam = 1 then
      vDefWndProc := DefMDIChildProc
    else
      vDefWndProc := DefWindowProc;
  end;

  function TViewer.apwViewGotoPage(Page : Cardinal) : Integer;
    {-Set the currently viewed page}
  begin
    apwViewGotoPage := ecOK;
    if InVInitPage then     
      Exit;
    if (Page = 0) or (Page > vNumPages) then
      apwViewGotoPage := ecBadArgument
    else begin
      vOnPage := Page;
      vInitPage;
      apwViewGotoPage := ecOK;
    end;
  end;

  function TViewer.apwViewGetCurPage : Integer;
    {-Get the number of the currently viewed page}
  begin
    if (vFileName = '') then
      apwViewGetCurPage := 0
    else
      apwViewGetCurPage := vOnPage;
  end;

  procedure TViewer.apwViewSetDesignMode(Name : PChar);
    {-Tell the viewer we're in component design mode}
  begin
    vDesigning := True;
    vComponentName := Name; //StrCopy(vComponentName, Name);
    vInvalidateAll;
  end;

  function TViewer.apwViewSetRotation(Direction : Cardinal) : Integer;
    {-Rotate the fax bitmaps}
  var
    NewDir          : Cardinal;
    OnPage          : Cardinal;

    procedure FindActualRotateDirection;
    begin
      case Direction of
        0:
          case vRotateDir of
            1: NewDir := 3;
            2: NewDir := 2;
            3: NewDir := 1;
          end;

        1:
          case vRotateDir of
            0: NewDir := 1;
            2: NewDir := 3;
            3: NewDir := 2;
          end;

        2:
          case vRotateDir of
            0: NewDir := 2;
            1: NewDir := 1;
            3: NewDir := 3;
          end;

        3:
          case vRotateDir of
            0: NewDir := 3;
            1: NewDir := 2;
            2: NewDir := 1;
          end;
      end;
    end;

  begin
    apwViewSetRotation := ecOK;
    if (vImage = nil) or (vRotateDir = Direction) then
      Exit;

    {find the direction in which the fax is to be rotated}
    {direction = 0 = 000 degrees}
    {direction = 1 = 090 degrees}
    {direction = 2 = 180 degrees}
    {direction = 3 = 270 degrees}
    FindActualRotateDirection;

    if vLoadWholeFax then begin
      for OnPage := 1 to vNumPages do
        if (vRotatePage(OnPage, NewDir) <> ecOK) then begin
          apwViewSetRotation := ecOutOfMemory;
          Exit;
        end;
    end else
      if (vRotatePage(vOnPage, NewDir) <> ecOK) then begin
        apwVIewSetRotation := ecOutOfMemory;
        Exit;
      end;

    vRotateDir := Direction;
    vInitPage;
    apwViewSetRotation := ecOK;
  end;

  procedure TViewer.apwViewSetAutoScale(Kind : Word);
    {-Set the auto scaling mode for the underlying unpacker}
  begin
    upOptionsOff(vUnpacker, ufAutoDoubleHeight or ufAutoHalfWidth);
    upOptionsOn(vUnpacker, Kind);
  end;

  procedure TViewer.apwViewGetPageDim(R : PRect);
    {-Get dimensions of current page}
  begin
    if (vFileName= '') then
      FillChar(R^, SizeOf(TRect), 0)
    else begin
      R^.Left   := 0;
      R^.Top    := 0;
      R^.Right  := Pred(vImage^[vOnPage].Width);
      R^.Bottom := Pred(vImage^[vOnPage].Height);
    end;
  end;

  function TViewer.apwViewGetPageFlags : Word;  
    {-Get flags for current page}
  begin
    Result := vUnPacker^.PageHeader.ImgFlags;
  end;

  function TViewer.apwViewSetLoadWholeFax(LoadWhole : Bool) : Integer;
    {-Determine whether whole faxes are loaded into memory or not}
  var
    OldWhole  : Bool;
    I         : Integer;
    Code      : Integer;
    OldCursor : HCursor;

  begin
    OldWhole               := vLoadWholeFax;
    vLoadWholeFax          := LoadWhole;
    apwViewSetLoadWholeFax := ecOK;

    if not OldWhole and vLoadWholeFax and (vFileName <> '') then begin
      OldCursor := SetCursor(vBusyCursor);
      for I := 1 to vNumPages do begin
        if (vImage^[I].Bitmap = 0) then begin
          Code := upUnpackPageToBitmap(vUnpacker, vFileName, I, vImage^[I], True);
          if (Code < ecOK) then begin
            apwViewSetLoadWholeFax := Code;
            vDisposeFax;
            SetCursor(OldCursor);
            Exit;
          end;
        end;
      end;
      SetCursor(OldCursor);
    end else if OldWhole and not vLoadWholeFax and (vFileName <> '') then
      for I := 1 to vNumPages do
        if (vImage^[I].Bitmap <> 0) and (I <> Integer(vOnPage)) then begin
          DeleteObject(vImage^[I].Bitmap);
          vImage^[I].Bitmap := 0;
        end;
  end;

  procedure TViewer.apwViewSetBusyCursor(NewCursor : HCursor);
    {-Set the cursor that is shown during length operations}
  begin
    vBusyCursor := NewCursor;
  end;

  procedure TViewer.wmPaint(var Msg : wMsg);
    {-paint the window}
  var
    PS : TPaintStruct;

  begin
    BeginPaint(vWnd, PS);
    vPaint(PS.hDC, PS);
    EndPaint(vWnd, PS);
  end;

  function TViewer.wmSize(var Msg : wMsg) : Integer;
    {-size the window}
  begin
    wmSize := vDefWndProc(vWnd, Msg.Message, Msg.wParam, Msg.lParam);
    if not vSizing then begin
      vSizing := True;
      vInitScrollbars;
      vSizing := False;
    end else
      PostMessage(vWnd, wm_Size, Msg.wParam, Msg.lParam);
  end;

  function TViewer.wmGetDlgCode(var Msg : wMsg) : Integer;
    {-respond to query about what input we want}
  var
    Res : Integer;

  begin
    Res := vDefWndProc(vWnd, Msg.Message, Msg.wParam, Msg.lParam);
    wmGetDlgCode := Res or dlgc_WantArrows;
  end;

  function TViewer.wmKeyDown(var Msg : wMsg) : Integer;
    {-respond to key presses}
  begin
    wmKeyDown := 0;

    if vCaptured then
      Exit;

    case Msg.wParam of
      vk_Control: vCtrlDown := True;

      vk_Up     :
        if vCtrlDown then
          vJumpUp
        else
          vScrollUp;

      vk_Down   :
        if vCtrlDown then
          vJumpDown
        else
          vScrollDown;

      vk_Left   :
        if vCtrlDown then
          vJumpLeft
        else
          vScrollLeft;

      vk_Right  :
        if vCtrlDown then
          vJumpRight
        else
          vScrollRight;

      vk_Home   :
        if vCtrlDown then
          vFirstPage
        else
          vHomeHorizontal;

      vk_End    :
        if vCtrlDown then
          vLastPage
        else
          vEndHorizontal;

      vk_Prior  :
        if vCtrlDown then
          vHomeVertical
        else
          vPageUp;

      vk_Next   :
        if vCtrlDown then
          vEndVertical
        else
          vPageDown;

      else
        wmKeyDown := vDefWndProc(vWnd, Msg.Message, Msg.wParam, Msg.lParam);
    end;
  end;

  function TViewer.wmKeyUp(var Msg : wMsg) : Integer;
    {-respond to key releases}
  begin
    wmKeyUp := 0;
    if (Msg.wParam = vk_Control) then
      vCtrlDown := False
    else
      wmKeyUp := vDefWndProc(vWnd, Msg.Message, Msg.wParam, Msg.lParam);
  end;

  procedure TViewer.wmLButtonDown(var Msg : wMsg);
    {-respond to left button clicks}
  var
    Dest : TRect;

  begin
    if vCaptured or (vImage = nil) then
      Exit;

    {if there's already a mark remove it and update the screen}
    if vMarked then begin
      vGetMarkClientIntersection(Dest, vMarkRect);
      vMarked := False;

      if (Dest.Left <> Dest.Right) and (Dest.Top <> Dest.Bottom) then begin
        InvalidateRect(vWnd, @Dest, False);
        UpdateWindow(vWnd);
      end;
    end;

    {cursor is not yet outside of client area}
    vOutsideEdge := False;

    {lower right corner is anchored corner}
    vAnchorCorner := 1;

    {create marked rectangle}
    vMarkRect.Left   := Msg.lParamLo + vLeftOfs;
    vMarkRect.Right  := vMarkRect.Left;
    vMarkRect.Top    := Msg.lParamHi + vTopRow;
    vMarkRect.Bottom := vMarkRect.Top;

    {capture the mouse}
    SetCapture(vWnd);

    {set flags}
    vMarked   := True;
    vCaptured := True;

    {invalidate the rectangle}
    vGetMarkClientIntersection(Dest, vMarkRect);
    if (Dest.Left <> Dest.Right) and (Dest.Top <> Dest.Bottom) then begin
      InvalidateRect(vWnd, @Dest, False);
      UpdateWindow(vWnd);
    end;
  end;

  procedure TViewer.wmLButtonUp(var Msg : wMsg);
    {-respond to left button releases}
  begin
    if not vCaptured or (vImage = nil) then
      Exit;

    {release the mouse capture}
    ReleaseCapture;
    vCaptured := False;

    {release the timer, if applicable}
    if vOutsideEdge then
      KillTimer(vWnd, 1);

    {turn off the mark if it's not big enough}
    if (vMarkRect.Left = vMarkRect.Right) and (vMarkRect.Top = vMarkRect.Bottom) then begin
      vMarked := False;
      InvalidateRect(vWnd, @vMarkRect, False);
      UpdateWindow(vWnd);
    end;
  end;

  procedure TViewer.wmMouseMove(var Msg : wMsg);
    {-respond to mouse movements}
  var
    Client     : TRect;
    NewOutside : Bool;

  begin
    if not vCaptured or (vImage = nil) then
      Exit;

    GetClientRect(vWnd, Client);

    {find out if the new mouse cursor position is outside the client area}
    NewOutside := (Integer(Msg.lParamLo) < 0) or (Integer(Msg.lParamHi) < 0) or
                  (Msg.lParamLo > Client.Right) or (Msg.lParamHi > Client.Bottom);

    {if the cursor was outside the client area, but isn't now, kill the timer}
    if vOutsideEdge and not NewOutside then
      KillTimer(vWnd, 1);

    {set a timer if necessary}
    if not vOutsideEdge and NewOutside then begin
      wmTimer(Msg);
      SetTimer(vWnd, 1, 50, nil);
      vOutsideEdge := NewOutSide;
    end else begin
      vOutsideEdge := NewOutside;
      vUpdateMarkRect(Client, Msg.lParamLo + vLeftOfs, Msg.lParamHi + vTopRow);
    end;
  end;

  procedure TViewer.wmTimer(var Msg : wMsg);
    {-respond to automatic scroll timer}
  var
    X      : Integer;
    Y      : Integer;
    CPos   : TPoint;
    Client : TRect;

  begin
    GetCursorPos(CPos);
    GetClientRect(vWnd, Client);
    ScreenToClient(vWnd, CPos);

    X := CPos.X;
    Y := CPos.Y;

    if (CPos.X < 0) then begin
      if (CPos.X < -20) then
        vScrollLeftPrim(vHScrollInc * 2)
      else
        vScrollLeftPrim(vHScrollInc);
      X := 0;
    end else if (CPos.X > Client.Right) then begin
      if (CPos.X > (Client.Right + 20)) then
        vScrollRightPrim(vHScrollInc * 2)
      else
        vScrollRightPrim(vHScrollInc);
      X := Client.Right;
    end;

    if (CPos.Y < 0) then begin
      if (CPos.Y < -20) then
        vScrollUpPrim(vVScrollInc * 2)
      else
        vScrollUpPrim(vVScrollInc);
      Y := 0;
    end else if (CPos.Y > Client.Bottom) then begin
      if (CPos.Y > (Client.Bottom + 20)) then
        vScrollDownPrim(vVScrollInc * 2)
      else
        vScrollDownPrim(vVScrollInc);
      Y := Client.Bottom;
    end;

    vUpdateMarkRect(Client, Integer(vLeftOfs) + X, Integer(vTopRow) + Y);
  end;

  procedure TViewer.wmVScroll(var Msg : wMsg);
    {-scroll vertically}
  var
    Delta  : Integer;
    Height : Word;
    R      : TRect;

  begin
    if (vImage = nil) then
      Exit;

    if (Msg.wParam <> sb_EndScroll) then
      vVScrolling := True;

    case Msg.wParamLo of
      sb_Top          : vHomeVertical;
      sb_Bottom       : vEndVertical;
      sb_LineDown     : vScrollDown;
      sb_LineUp       : vScrollUp;
      sb_PageDown     : vJumpDown;
      sb_PageUp       : vJumpUp;

      sb_ThumbTrack,
      sb_ThumbPosition:
        begin
          GetClientRect(vWnd, R);
          Height := Succ(R.Bottom - R.Top + 1);
          Delta := Msg.wParamHi - vTopRow;

          {if the amount of change in position is more than}
          {a screenful, reset the top row and redraw the}
          {entire screen}
          if (Abs(Delta) > Height) then begin
            vTopRow := Msg.lParamLo;
            vInvalidateAll;
            UpdateWindow(vWnd);
            vUpdateScrollThumb(True);

          {otherwise, scroll in the direction indicated}
          end else if (Delta < 0) then
            vScrollUpPrim(Abs(Delta))
          else
            vScrollDownPrim(Delta);
        end;

      sb_EndScroll:
        begin
          vVScrolling := False;
          if (vTopRow = 0) then
            vInitScrollbars;
        end;
    end;
  end;

  procedure TViewer.wmHScroll(var Msg : wMsg);
    {-scroll horizontally}
  var
    Delta : Integer;
    Width : Word;
    R     : TRect;

  begin
    if (vImage = nil) then
      Exit;

    if (Msg.wParam <> sb_EndScroll) then
      vHScrolling := True;

    case Msg.wParamLo of
      sb_Top          : vHomeHorizontal;
      sb_Bottom       : vEndHorizontal;
      sb_LineDown     : vScrollRight;
      sb_LineUp       : vScrollLeft;
      sb_PageDown     : vJumpRight;
      sb_PageUp       : vJumpLeft;

      sb_ThumbTrack,
      sb_ThumbPosition:
        begin
          GetClientRect(vWnd, R);
          Width := Succ(R.Right - R.Left + 1);
          Delta := Msg.wParamHi - vLeftOfs;

          {if the amount of change in position is more than}
          {a screenful, reset the top row and redraw the}
          {entire screen}
          if (Abs(Delta) > Width ) then begin
            vLeftOfs := Msg.lParamLo;
            vInvalidateAll;
            UpdateWindow(vWnd);
            vUpdateScrollThumb(False);

          {otherwise, scroll in the direction indicated}
          end else if (Delta < 0) then
            vScrollLeftPrim(Abs(Delta))
          else
            vScrollRightPrim(Delta);
        end;

      sb_EndScroll:
        begin
          vHScrolling := False;
          if (vLeftOfs = 0) then
            vInitScrollbars;
        end;
    end;
  end;

  procedure TViewer.wmDropFiles(var Msg : wMsg);
    {-get a dropped file}
  var
    NumFiles : Word;
    FName    : array[0..fsPathName] of Char;

  begin
    {get the number of files being dropped}
    NumFiles := DragQueryFile(Msg.wParam, Cardinal(-1), nil, 0);  
    if (NumFiles = 0) then
      Exit;

    {load only the first file}
    DragQueryFile(Msg.wParam, 0, FName, SizeOf(FName));
    apwViewSetFile(FName);
  end;

{******************************************************************************}

{Class routines}

  function vFaxViewerWndFunc(HWindow : TApdHwnd; Msg : UINT;
                             wParam : WPARAM;
                             lParam : LPARAM) : LRESULT; stdcall export;
  var
    PCreate : PCreateStruct absolute lParam;
    FV      : TViewer;
    WM      : wMsg;

    function DefWndFunc : Integer;
    begin
      DefWndFunc := FV.vDefWndProc(HWindow, Msg, wParam, lParam);
    end;

  begin
    vFaxViewerWndFunc := 0;

    {Get a pointer to our object}
    if (Msg <> wm_Create) then begin
      FV := GetViewerPtr(HWindow);
      if (FV = nil) then begin
        vFaxViewerWndFunc := DefWindowProc(HWindow, Msg, wParam, lParam);
        Exit;
      end;
    end;

    {set up wMsg variable}
    WM.HWindow := HWindow;
    WM.Message := Msg;
    WM.wParam  := wParam;
    WM.lParam  := lParam;

    case Msg of
      {APW messages}
      apw_ViewSetFile        : vFaxViewerWndFunc := FV.apwViewSetFile(PChar(lParam));
      apw_ViewSetFG          : FV.apwViewSetFG(lParam);
      apw_ViewSetBG          : FV.apwViewSetBG(lParam);
      apw_ViewSetScale       : FV.apwViewSetScale(PScaleSettings(lParam));
      apw_ViewSetWhitespace  : FV.apwViewSetWhitespace(wParam, WM.lParamLo);
      apw_ViewSetScroll      : FV.apwViewSetScroll(wParam, lParam);
      apw_ViewSelectAll      : vFaxViewerWndFunc := FV.apwViewSelectAll;
      apw_ViewSelect         : vFaxViewerWndFunc := FV.apwViewSelect(PRect(lParam));
      apw_ViewCopy           : vFaxViewerWndFunc := FV.apwViewCopy;
      apw_ViewGetBitmap      : vFaxViewerWndFunc := FV.apwViewGetBitmap(wParam, PPoint(lParam));
      apw_ViewGetNumPages    : vFaxViewerWndFunc := FV.apwViewGetNumPages;
      apw_ViewStartUpdate    : FV.apwViewStartUpdate;
      apw_ViewEndUpdate      : FV.apwViewEndUpdate;
      apw_ViewGotoPage       : vFaxViewerWndFunc := FV.apwViewGotoPage(wParam);
      apw_ViewGetCurPage     : vFaxViewerWndFunc := FV.apwViewGetCurPage;
      apw_ViewSetWndProc     : FV.apwViewSetWndProc(WM);
      apw_ViewSetDesignMode  : FV.apwViewSetDesignMode(PChar(lParam));
      apw_ViewSetRotation    : vFaxViewerWndFunc := FV.apwViewSetRotation(wParam);
      apw_ViewSetAutoScale   : FV.apwViewSetAutoScale(wParam);
      apw_ViewGetPageDim     : FV.apwViewGetPageDim(PRect(lParam));
      apw_ViewSetLoadWholeFax: FV.apwViewSetLoadWholeFax(Bool(wParam));
      apw_ViewSetBusyCursor  : FV.apwViewSetBusyCursor(HCursor(wParam));
      apw_ViewGetPageFlags   : Result := FV.apwViewGetPageFlags;
      apw_ViewGetFileName    : Result := Integer(@FV.vFileName);

      {Windows messages}
      wm_Create:
        with PCreate^ do begin
          SetWindowLong(HWindow, gwl_Viewer, 0);
          FV := TViewer.Create(HWindow);
          SetWindowLong(HWindow, gwl_Viewer, Integer(FV));
          if (FV <> nil) then
            FV.vInitDragDrop(((GetWindowLong(HWindow, gwl_Style) and vws_DragDrop) <> 0));
        end;

      wm_NCDestroy:
        begin
          FV.Free;
          SetWindowLong(HWindow, gwl_Viewer, Integer(nil));
        end;

      wm_EraseBkgnd : vFaxViewerWndFunc := 1;
      wm_Size       : vFaxViewerWndFunc := FV.wmSize(WM);
      wm_Paint      :
        begin
          FV.wmPaint(WM);
        end;
      wm_GetDlgCode : vFaxViewerWndFunc := FV.wmGetDlgCode(WM);
      wm_KeyDown    : vFaxViewerWndFunc := FV.wmKeyDown(WM);
      wm_KeyUp      : vFaxViewerWndFunc := FV.wmKeyUp(WM);
      wm_LButtonDown: FV.wmLButtonDown(WM);
      wm_LButtonUp  : FV.wmLButtonUp(WM);
      wm_MouseMove  : FV.wmMouseMove(WM);
      wm_Timer      : FV.wmTimer(WM);
      wm_VScroll    : FV.wmVScroll(WM);
      wm_HScroll    : FV.wmHScroll(WM);
      wm_DropFiles  : FV.wmDropFiles(WM);

      else
        vFaxViewerWndFunc := DefWndFunc;
    end;
  end;

  procedure RegisterFaxViewerClass(Designing : Boolean);
  const
    Registered : array[Boolean] of Bool = (False, False);       

  var
    XClass : TWndClass;

  begin
    if Registered[Designing] then
      Exit;
    Registered[Designing] := True;

    with XClass do begin
      Style         := cs_DblClks or cs_GlobalClass;
      lpfnWndProc   := @vFaxViewerWndFunc;
      cbClsExtra    := 0;
      cbWndExtra    := SizeOf(Pointer);
      hInstance     := System.MainInstance;
      hIcon         := LoadIcon(System.MainInstance, 'DEFICON');
      hCursor       := LoadCursor(0, idc_Arrow);
      hbrBackground := GetStockObject(White_Brush);
      lpszMenuName  := nil;

      if Designing then
        lpszClassName := FaxViewerClassNameDesign
      else
        lpszClassName := FaxViewerClassName;
    end;

    RegisterClass(XClass);
  end;

end.
