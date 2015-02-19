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
{*                   ADTRMPSR.PAS 4.06                   *}
{*********************************************************}
{*             Terminal: Data stream parser              *}
{*********************************************************}

unit ADTrmPsr;

interface

{Notes: The purpose of the data stream parser is to identify terminal
        escape sequences in the stream of data coming into the
        terminal. The parser is the class that embodies the knowledge
        of the terminal's escape sequences, if another emulator is to
        be written then a new parser descendant must be written to
        encapsulate the knowledge about the terminal to be supported.

        Consequently, there is an ancestor parser class. Operations
        supported by this class are:
        - process a single character (virtual method)
        - clear the parser (virtual method)
        - get the command (property)
        - get the arguments (property)
        - get the sequence (property)

        Taking these operations in order, let's describe them.

        Processing a single character will return one of four states:
        the parser did not understand the character and so it was
        ignored; the character is a displayable character; the
        character started or continued an escape sequence, however
        that sequence is as yet incomplete; the character completed
        an escape seqence and the relevant command must be obeyed.
        Internally it is up to the overridden method to determine how
        sequences are built up, etc.

        The clear operation should reset the parser into a state such
        that no sequence is being built up, and hence no knowledge of
        previous characters is maintained.

        The command property will return the current unprocessed
        command. This propoerty is reset to a null command if a
        sequence is being built up; no exception is raised.

        The arguments property is an array property returning the
        arguments for the current command. If there is no current
        command, the values are all zero; no exception is raised.

        The sequence property returns the actual escape sequence that
        has just been parsed. If the current command is null, this
        property returns the empty string.

        The VT100 parser has two modes to reflect the behavior of the
        standard VT100 terminal. The two modes are known as ANSI mode
        and VT52 mode. When in VT52 mode, the parser only accepts VT52
        sequences, together with the ESC< sequence (to switch back to
        ANSI mode). In ANSI mode the VT52 sequences are ignored. The
        command to switch from one to the other is obeyed immediately
        within the ProcessChar method as well being returned by it.

        ANSI control sequences (in both the VT100 and ANSI parsers)
        are always of the following form:

            ESC[P...PI...IF

        where ESC is the escape character, #27, [ is the left bracket,
        the Ps are characters in the range #$30..#$3F, the Is are in
        the range #$20..#$2F, and F is in the range #$40..#$7E. This
        way if the parser does not recognize a particular command it
        can discard it easily since it knows when the command
        finishes.

        With the VT100 parser in ANSI mode, escape sequences either
        start with ESC[, ESC#, ESC(, or ESC), or form a two character
        escape sequence ESCx where x is the command identifier. The
        ESC[ sequences follow the standard ANSI format. The other
        three sequence types are all three character sequences with
        the final character identifying the command. Hence the parser
        can know when unknown sequences terminate.

        With the VT100 parser in VT52 mode, all sequences are two
        character sequences of the form ESCx with the x being the
        command identifier. The only exception is ESCY where the
        following two characters *also* form part of the sequence
        (ESCY is "cursor position" and the two following characters
        are the row and column numbers respecitively). Hence the
        parser can know when unknown sequences terminate.

        With the ANSI parser, escape sequences either follow the ANSI
        format or are two character sequences of the form ESCx. Hence
        the parser can know when unknown sequences terminate.
}

{$I AWDEFINE.INC}

{$IFOPT R+}
{$DEFINE UseRangeChecks}
{$ENDIF}

uses
  SysUtils,
  Windows,
  Classes,
  Graphics,
  OOMisc;

type
  TAdParserCmdType = ( {Parser return command types...}
    pctNone,           {..no command, unknown command or char ignored}
    pctChar,           {..single displayable character}
    pct8bitChar,       {..single character with bit 7 set}
    pctPending,        {..command being built up}
    pctComplete);      {..a complete command is ready}

  TAdVTParserState = (   {VT Parser states...}
    psIdle,              {..nothing happening}
    psGotEscape,         {..received escape char}
    psParsingANSI,       {..parsing an ESC[ sequence}
    psParsingHash,       {..parsing an ESC# sequence}
    psParsingLeftParen,  {..parsing an ESC( sequence}
    psParsingRightParen, {..parsing an ESC) sequence}
    psParsingCharSet,    {..parsing ESC *, +, -, ., / sequence}
    psGotCommand,        {..received complete command}
    psGotInterCommand,   {..received complete intermediary command}
    psParsingCUP52);     {..received VT52 position cursor command}

type
  PAdIntegerArray = ^TAdIntegerArray;
  TAdIntegerArray = array [0..pred(MaxInt div sizeof(integer))] of integer;

type
  TAdTerminalParser = class
    {the ancestor parser class}
    private
      FArgCount    : integer;
      FCommand     : byte;
      FUseWideChar : boolean;
    protected
      function tpGetArgument(aInx : integer) : integer; virtual;
      function tpGetSequence : AnsiString; virtual;
    public
      constructor Create(aUseWideChar : boolean);
      destructor Destroy; override;

      function ProcessChar(aCh : AnsiChar) : TAdParserCmdType; virtual;
      function ProcessWideChar(aCh : WideChar) :TAdParserCmdType; virtual;

      procedure Clear; virtual;
      procedure ForceCommand (Command : Integer);                        {!!.03}

      property Argument [aInx : integer] : integer
         read tpGetArgument;
      property ArgumentCount : integer read FArgCount;
      property Command : byte read FCommand;
      property Sequence : ansistring read tpGetSequence;
  end;

  TAdVT100Parser = class(TAdTerminalParser)
    {the VT100 terminal parser}
    private
      FArgCountMax : integer;
      FArgs        : PAdIntegerArray;
      FInVT52Mode  : boolean;
      FSavedSeq    : pointer;
      FSavedState  : TAdVTParserState;
      FSequence    : pointer;
      FState       : TAdVTParserState;
    protected
      function tpGetArgument(aInx : integer) : integer; override;
      function tpGetSequence : Ansistring; override;

      function vtpGetArguments : boolean;
      function vtpParseANSISeq(aCh : Ansichar) : TAdParserCmdType;
      function vtpProcessVT52(aCh : Ansichar) : TAdParserCmdType;
      function vtpValidateArgsPrim(aMinArgs : integer;
                                   aMaxArgs : integer;
                                   aDefault : integer) : boolean;

      procedure vtpGrowArgs;
    public
      constructor Create(aUseWideChar : boolean);
      destructor Destroy; override;

      function ProcessChar(aCh : AnsiChar) : TAdParserCmdType; override;
      function ProcessWideChar(aCh : WideChar) :TAdParserCmdType; override;

      procedure Clear; override;

      property InVT52Mode : boolean read FInVT52Mode;
  end;


implementation

uses
  AnsiStrings;

{===TAdTerminalParser================================================}
constructor TAdTerminalParser.Create(aUseWideChar : boolean);
begin
  inherited Create;
  FUseWideChar := aUseWideChar;
  FCommand := eNone;
end;
{--------}
destructor TAdTerminalParser.Destroy;
begin
  inherited Destroy;
end;
{--------}
procedure TAdTerminalParser.Clear;
begin
  {do nothing at this level}
end;
{--------}
procedure TAdTerminalParser.ForceCommand (Command : Integer);            {!!.03}
begin                                                                    {!!.03}
  Clear;                                                                 {!!.03}
  FCommand := Command;                                                   {!!.03}
end;                                                                     {!!.03}
{--------}
function TAdTerminalParser.ProcessChar(aCh : AnsiChar) : TAdParserCmdType;
begin
  Result := pctNone;
end;
{--------}
function TAdTerminalParser.ProcessWideChar(aCh : WideChar) : TAdParserCmdType;
begin
  Result := pctNone;
end;
{--------}
function TAdTerminalParser.tpGetArgument(aInx : integer) : integer;
begin
  Result := 0;
end;
{--------}
function TAdTerminalParser.tpGetSequence : AnsiString;
begin
  Result := '';
end;
{====================================================================}


{====================================================================}
type
  PSeq = ^TSeq;
  TSeq = packed record
    sSize : Integer;
    sLen  : Integer;
    sText : array [1..10000] of AnsiChar;
  end;
{--------}
function ReAllocSeq(aSeq : PSeq; aSize : Integer) : PSeq;
var
  NewSeq : PSeq;
begin
  if (aSize = 0) then
    NewSeq := nil
  else begin
    GetMem(NewSeq, 2*sizeof(Integer) + aSize);
    NewSeq^.sSize := aSize;
    NewSeq^.sLen := 0;
    if (aSeq <> nil) then begin
      Move(aSeq^.sText, NewSeq^.sText, aSeq^.sLen);
      NewSeq^.sLen := aSeq^.sLen;
    end;
  end;
  if (aSeq <> nil) then
    FreeMem(aSeq, 2*sizeof(Integer) + aSeq^.sSize);
  Result := NewSeq;
end;
{--------}
procedure AddCharToSeq(var aSeq : PSeq; aCh : AnsiChar);
begin
  if (aSeq = nil) then
    aSeq := ReAllocSeq(aSeq, 64)
  else if (aSeq^.sSize = aSeq^.sLen) then
    aSeq := ReAllocSeq(aSeq, aSeq^.sSize + 64);
  inc(aSeq^.sLen);
  aSeq^.sText[aSeq^.sLen] := aCh;
end;
{--------}
procedure AssignSeqToChar(var aSeq : PSeq; aCh : AnsiChar);
begin
  if (aSeq <> nil) then
    aSeq^.sLen := 0;
  AddCharToSeq(aSeq, aCh);
end;
{--------}
procedure CopySeq(aFromSeq : PSeq; var aToSeq : PSeq);
begin
  if (aFromSeq = nil) then begin
    if (aToSeq <> nil) then
      aToSeq^.sLen := 0;
  end
  else begin
    if (aToSeq = nil) or
       (aToSeq^.sSize < aFromSeq^.sLen) then
      aToSeq := ReAllocSeq(aToSeq, aFromSeq^.sLen);
    if (aToSeq <> nil) then begin
      aToSeq^.sLen := aFromSeq^.sLen;
      Move(aFromSeq^.sText, aToSeq^.sText, aFromSeq^.sLen);
    end;
  end;
end;
{--------}
procedure DelCharFromSeq(aSeq : PSeq);
begin
  if (aSeq <> nil) and (aSeq^.sLen > 0) then
    dec(aSeq^.sLen);
end;
{--------}
procedure ClearSeq(aSeq : PSeq);
begin
  if (aSeq <> nil) then
    aSeq^.sLen := 0;
end;
{--------}
function GetSeqLength(aSeq : PSeq) : integer;
begin
  Result := aSeq^.sLen;
end;
{--------}
function GetStringFromSeq(aSeq : PSeq) : Ansistring;
begin
  Result := '';
  if (aSeq <> nil) and (aSeq^.sLen > 0) then begin
    SetLength(Result, aSeq^.sLen);
    Move(aSeq^.sText, Result[1], aSeq^.sLen);
  end;
end;
{====================================================================}

const
  DECSCLseq : string[6] = ^['[61"p';

{===TAdVT100Parser===================================================}
constructor TAdVT100Parser.Create(aUseWideChar : boolean);
begin
  inherited Create(aUseWideChar);
  FArgCount := 0;
  vtpGrowArgs;
  FInVT52Mode := false;
end;
{--------}
destructor TAdVT100Parser.Destroy;
begin
  FSequence := ReAllocSeq(FSequence, 0);
  FSavedSeq := ReAllocSeq(FSavedSeq, 0);
  if (FArgs <> nil) then begin
    FreeMem(FArgs, sizeof(integer) * FArgCountMax);
    FArgs := nil;
    FArgCountMax := 0;
  end;
  inherited Destroy;
end;
{--------}
procedure TAdVT100Parser.Clear;
begin
  ClearSeq(FSequence);
  FCommand := eNone;
  if (FArgCount <> 0) then begin
    FillChar(FArgs^, sizeof(integer) * FArgCount, 0);
    FArgCount := 0;
  end;
end;
{--------}
function TAdVT100Parser.ProcessChar(aCh : AnsiChar) : TAdParserCmdType;
begin
  {if the current state is psGotCommand, the previous character
   managed to complete a command. Before comtinuing we should clear
   all traces of the previous command and sequence}
  if (FState = psGotCommand) then begin
    FArgCount := 0;
    ClearSeq(FSequence);
    FCommand := eNone;
    FState := psIdle;
  end;

  {if the current state is psGotInterCommand, the previous character
   was non-displayable and a command; restore the previously saved
   state}
  if (FState = psGotInterCommand) then begin
    FArgCount := 0;
    FCommand := eNone;
    CopySeq(FSavedSeq, PSeq(FSequence));
    FState := FSavedState;
  end;

  {assume that the result is going to be that we are building up a
   command escape sequence}
  Result := pctPending;

  {add the character to the sequence string we're building up,
   although we may delete it later}
  AddCharToSeq(PSeq(FSequence), aCh);

  {if the character is non-displayable, process it immediately, even
   if we're in the middle of parsing some other command}
  if (aCh < ' ') then begin
    FSavedState := FState;
    DelCharFromSeq(FSequence);
    CopySeq(FSequence, PSeq(FSavedSeq));
    FState := psGotInterCommand;
    Result := pctComplete;
    case aCh of
      cENQ : begin {enquiry request}
               AssignSeqToChar(PSeq(FSequence), cENQ);
               FCommand := eENQ;
             end;
      cBel : begin {sound bell}
               AssignSeqToChar(PSeq(FSequence), cBel);
               FCommand := eBel;
             end;
      cBS  : begin {backspace}
               AssignSeqToChar(PSeq(FSequence), cBS);
               FCommand := eBS;
             end;
      cTab : begin {horizontal tab}
               AssignSeqToChar(PSeq(FSequence), cTab);
               FCommand := eCHT;
               FArgCount := 1;
               FArgs^[0] := 1; {ie a single tab}
             end;
      cLF  : begin
               AssignSeqToChar(PSeq(FSequence), cLF);
               FCommand := eLF;
             end;
      cVT  : begin
               AssignSeqToChar(PSeq(FSequence), cVT);
               FCommand := eCVT;
               FArgCount := 1;
               FArgs^[0] := 1; {ie a single tab}
             end;
      cFF  : begin {formfeed, equals clear screen}
               AssignSeqToChar(PSeq(FSequence), cFF);
               FCommand := eED;
               FArgCount := 1;
               FArgs^[0] := 2; {ie <esc>[2J}
             end;
      cCR  : begin {carriage return}
               AssignSeqToChar(PSeq(FSequence), cCR);
               FCommand := eCR;
             end;
      cSO  : begin {shift out character set, ie use G0}
               AssignSeqToChar(PSeq(FSequence), cSO);
               FCommand := eSO;
             end;
      cSI  : begin {shift in character set, ie use G1}
               AssignSeqToChar(PSeq(FSequence), cSI);
               FCommand := eSI;
             end;
      cCan,
      cSub : begin {abandon current escape sequence}
               Result := pctNone;
             end;
      cEsc : begin {start a new escape sequence}
               {abandon whatever escape sequence we're in}
               AssignSeqToChar(PSeq(FSequence), cEsc);
               FArgCount := 0;
               FState := psGotEscape;
               Result := pctPending;
             end;
    else
      {otherwise ignore the non-displayable char}
      DelCharFromSeq(FSequence);
      Result := pctNone;
    end;{case}
  end
  {otherwise parse the character}
  else begin
    case FState of
      psIdle :
        begin
          if (aCh < #127) then begin
            FState := psGotCommand;
            FCommand := eChar;
            Result := pctChar;
          end
          else {full 8-bit char} begin
            FState := psGotCommand;
            FCommand := eChar;
            Result := pct8bitChar;
          end;
        end;
      psGotEscape :
        if InVT52Mode then begin
          Result := vtpProcessVT52(aCh);
        end
        else {in VT100 mode} begin
          case aCh of
            '[' : FState := psParsingANSI;
            '(' : FState := psParsingLeftParen;
            ')' : FState := psParsingRightParen;
            '#' : FState := psParsingHash;
            '*', '+', '-', '.', '/' : FState := psParsingCharSet;
          else {it's a two character esc. seq.}
            FState := psGotCommand;
            Result := pctComplete;
            case aCh of
              '1' : begin {set graphics processor option on}
                      { NOT SUPPORTED }
                      FCommand := eNone;
                    end;
              '2' : begin {set graphics processor option off}
                      { NOT SUPPORTED }
                      FCommand := eNone;
                    end;
              '7' : begin {save cursor pos}
                      FCommand := eSaveCursorPos;
                    end;
              '8' : begin {restore cursor pos}
                      FCommand := eRestoreCursorPos;
                    end;
              '<' : begin {switch to ANSI--ie, do nothing}
                      FCommand := eNone;
                      Result := pctNone;
                    end;
              '=' : begin {set application keypad mode}
                      FCommand := eSM;
                      FArgCount := 2;
                      FArgs^[0] := -2;
                      FArgs^[1] := 999; {special APRO code!}
                    end;
              '>' : begin {set numeric keypad mode}
                      FCommand := eRM;
                      FArgCount := 2;
                      FArgs^[0] := -2;
                      FArgs^[1] := 999; {special APRO code!}
                    end;
              'D' : begin {index = cursor down + scroll}
                      FCommand := eIND2;
                    end;
              'E' : begin {next line}
                      FCommand := eNEL;
                    end;
              'H' : begin {set horx tab stop}
                      FCommand := eHTS;
                    end;
              'M' : begin {reverse index = cursor up + scroll}
                      FCommand := eRI;
                    end;

              'Z' : begin {device attributes}
                      FCommand := eDA;
                      FArgCount := 1;
                      FArgs^[0] := 0; {stands for VT100}
                    end;
              'c' : begin
                      FCommand := eRIS;
                    end;
            else
              {ignore the char & seq.--it's not one we know}
              Result := pctNone;
            end;{case}
          end;{case}
        end;
      psParsingANSI :
        begin
          if (#$40 <= aCh) and (aCh < #$7F) then begin
            {the command is now complete-see if we know about it}
            FState := psGotCommand;
            Result := vtpParseANSISeq(aCh);
          end;
          {otherwise, the next character has already been added to
           the sequence string, so there's nothing extra to do}
        end;
      psParsingLeftParen :
        begin
          if ('0' <= aCh) and (aCh <= '~') then begin
            {the command is complete}
            if (GetSeqLength(FSequence) = 3) then begin
              FState := psGotCommand;
              Result := pctComplete;
              FCommand := eDECSCS;
              FArgCount := 2;
              FArgs^[0] := 0; {0 = set G0 charset}
              case aCh of
                'A' : FArgs^[1] := ord('A');
                'B' : FArgs^[1] := ord('B');
                '0' : FArgs^[1] := 0;
                '1' : FArgs^[1] := 1;
                '2' : FArgs^[1] := 2;
              else
                {ignore the char & seq.--it's not one we know}
                FState := psGotCommand;
                Result := pctNone;
                FCommand := eNone;
                FArgCount := 0;
              end;{case}
            end
            else {sequence is too long} begin
              FState := psGotCommand;
              Result := pctNone;
              FCommand := eNone;
              FArgCount := 0;
            end;
          end;
        end;
      psParsingRightParen :
        begin
          if ('0' <= aCh) and (aCh <= '~') then begin
            {the command is complete}
            if (GetSeqLength(FSequence) = 3) then begin
              FState := psGotCommand;
              Result := pctComplete;
              FCommand := eDECSCS;
              FArgCount := 2;
              FArgs^[0] := 1; {0 = set G1 charset}
              case aCh of
                'A' : FArgs^[1] := ord('A');
                'B' : FArgs^[1] := ord('B');
                '0' : FArgs^[1] := 0;
                '1' : FArgs^[1] := 1;
                '2' : FArgs^[1] := 2;
              else
                {ignore the char & seq.--it's not one we know}
                FState := psGotCommand;
                Result := pctNone;
                FCommand := eNone;
                FArgCount := 0;
              end;{case}
            end
            else {sequence is too long} begin
              FState := psGotCommand;
              Result := pctNone;
              FCommand := eNone;
              FArgCount := 0;
            end;
          end;
        end;
      psParsingCharSet :
        begin
          {these are the VT200+ "switch charset" sequences: we ignore
           them after finding the first char in range $30..$7E}
          if ('0' <= aCh) and (aCh <= '~') then begin
            FState := psGotCommand;
            Result := pctNone;
            FCommand := eNone;
            FArgCount := 0;
          end;
        end;
      psParsingHash :
        begin
          FState := psGotCommand;
          Result := pctComplete;
          case aCh of
            '3' : begin
                    FCommand := eDECDHL;
                    FArgCount := 1;
                    FArgs^[0] := 0; {0 = top half}
                  end;
            '4' : begin
                    FCommand := eDECDHL;
                    FArgCount := 1;
                    FArgs^[0] := 1; {1 = bottom half}
                  end;
            '5' : begin
                    FCommand := eDECSWL;
                  end;
            '6' : begin
                    FCommand := eDECDWL;
                  end;
            '8' : begin
                    FCommand := eDECALN;
                  end;
          else
            {ignore the char & seq.--it's not one we know}
            FState := psGotCommand;
            Result := pctNone;
          end;{case}
        end;
      psParsingCUP52 :
        begin
          if (FArgCount = 0) then begin
            FArgs^[0] := ord(aCh) - $1F;
            inc(FArgCount);
          end
          else begin
            FState := psGotCommand;
            FCommand := eCUP;
            FArgs^[1] := ord(aCh) - $1F;
            inc(FArgCount);
            Result := pctComplete;
          end;
        end;
    else
      {invalid state?}
    end;{case}
  end;
end;
{--------}
function TAdVT100Parser.ProcessWideChar(aCh : WideChar) :TAdParserCmdType;
begin
  Result := pctNone;
end;
{--------}
function TAdVT100Parser.tpGetArgument(aInx : integer) : integer;
begin
  if (aInx < 0) or (aInx >= FArgCount) then
    Result := 0
  else
    Result := FArgs^[aInx];
end;
{--------}
function TAdVT100Parser.tpGetSequence : ansistring;
begin
  if (FCommand <> eNone) then
    Result := GetStringFromSeq(FSequence)
  else
    Result := '';
end;
{--------}
function TAdVT100Parser.vtpGetArguments : boolean;
var
  ChInx   : integer;
  StartInx: integer;
  Ch      : AnsiChar;
  ec      : integer;
  TempStr : string[255];
begin
  {for this parser, we assume
     1. arguments consist of numeric digits only
     2. arguments are separated by ';'
     3. the first argument can be ? (DEC VT100 special)
     4. argument parsing stops at the first character #$20 - #$2F, or
        #$40 - #$7E}

  {assume the sequence is badly formed}
  Result := false;

  {first check for the third character being ?}
  if (PSeq(FSequence)^.sText[3] = '?') then begin
    FArgCount := 1;
    FArgs^[0] := -2;
    StartInx := 4;
  end
  else
    StartInx := 3;

  {scan the rest of the characters until we reach a char in the range
   $20-$2F, or $40-$7E; look out for numeric digits and semi-colons}
  TempStr := '';
  for ChInx := StartInx to PSeq(FSequence)^.sLen do begin
    Ch := PSeq(FSequence)^.sText[ChInx];
    if ((#$20 <= Ch) and (Ch <= #$2F)) or
       ((#$40 <= Ch) and (Ch <= #$7E)) then
      Break;
    if (Ch = ';') then begin
      if (FArgCountMax = FArgCount) then
        vtpGrowArgs;
      if (TempStr = '') then begin
        FArgs^[FArgCount] := -1;
        inc(FArgCount);
      end
      else begin
        Val(string(TempStr), FArgs^[FArgCount], ec);
        if (ec <> 0) then
          Exit;
        inc(FArgCount);
        TempStr := '';
      end;
    end
    else if ('0' <= Ch) and (Ch <= '9') then begin
      TempStr := TempStr + Ch;
    end
    else {bad character}
      Exit;
  end;

  {convert the final argument}
  if (FArgCountMax = FArgCount) then
    vtpGrowArgs;
  if (TempStr = '') then begin
    FArgs^[FArgCount] := -1;
    inc(FArgCount);
  end
  else begin
    Val(string(TempStr), FArgs^[FArgCount], ec);
    if (ec <> 0) then
      Exit;
    inc(FArgCount);
  end;

  {if we got here, everything was all right}
  Result := true;
end;
{--------}
procedure TAdVT100Parser.vtpGrowArgs;
var
  NewMax   : integer;
  NewArray : PAdIntegerArray;
begin
  {use a simple increase-by-half algorithm}
  if (FArgCountMax = 0) then
    NewMax := 16
  else
    NewMax := (FArgCountMax * 3) div 2;
  {alloc the new array, zeroed}
  NewArray := AllocMem(sizeof(integer) * NewMax);
  {if there's any data in the old array copy it over, delete it}
  if (FArgs <> nil) then begin
    Move(FArgs^, NewArray^, sizeof(integer) * FArgCount);
    FreeMem(FArgs, sizeof(integer) * FArgCountMax);
  end;
  {remember the new details}
  FArgs := NewArray;
  FArgCountMax := NewMax;
end;
{--------}
function TAdVT100Parser.vtpParseANSISeq(aCh : Ansichar) : TAdParserCmdType;
begin
  {when this method is called FSequence has the full escape sequence,
   and FArgCount, FArgs, FCommand have to be set; for convenience aCh
   is the final character in FSequence--the command identifier--and
   FSequence must have at least three characters in it}

  {assume the sequence is invalid}
  Result := pctNone;

  {special case: DECSCL}
  if (GetStringFromSeq(FSequence) = DECSCLseq) then begin
    FCommand := eRIS;
    Result := pctComplete;
  end;

  {split out the arguments in the sequence, build up the FArgs array;
   note that an arg of -1 means 'default', and -2 means ? (a special
   DEConly parameter)}
  if not vtpGetArguments then
    Exit;

  {identify the command character}
  case aCh of
    '@' : begin {insert character--VT102}
            FCommand := eICH;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'A' : begin {Cursor up}
            FCommand := eCUU;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'B' : begin {Cursor down}
            FCommand := eCUD;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'C' : begin {Cursor right}
            FCommand := eCUF;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'D' : begin {cursor left}
            FCommand := eCUB;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'H' : begin {cursor position}
            FCommand := eCUP;
            {should have two parameters, both default of 1}
            if not vtpValidateArgsPrim(2, 2, 1) then Exit;
          end;
    'J' : begin {Erase in display}
            FCommand := eED;
            {should only have one parameter, default of 0}
            if not vtpValidateArgsPrim(1, 1, 0) then Exit;
          end;
    'K' : begin {Erase in line}
            FCommand := eEL;
            {should only have one parameter, default of 0}
            if not vtpValidateArgsPrim(1, 1, 0) then Exit;
          end;
    'L' : begin {Insert line--VT102}
            FCommand := eIL;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'M' : begin {Delete line--VT102}
            FCommand := eDL;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'P' : begin {delete character--VT102}
            FCommand := eDCH;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'X' : begin {erase character--VT102}
            FCommand := eECH;
            {should only have one parameter, default of 1}
            if not vtpValidateArgsPrim(1, 1, 1) then Exit;
          end;
    'c' : begin {Device attributes}
            FCommand := eDA;
            {should only have one parameter, default of 0}
            if not vtpValidateArgsPrim(1, 1, 0) then Exit;
          end;
    'f' : begin {cursor position}
            FCommand := eCUP;
            {should have two parameters, both default of 1}
            if not vtpValidateArgsPrim(2, 2, 1) then Exit;
          end;
    'g' : begin {clear horizontal tabs}
            FCommand := eTBC;
            {should only have one parameter, default of 0}
            if not vtpValidateArgsPrim(1, 1, 0) then Exit;
          end;
    'h' : begin {set mode}
            FCommand := eSM;
            {should have one parameter, or 2 if the first is ?, no
             defaults}
           end;
    'l' : begin {reset mode}
            FCommand := eRM;
            {should have one parameter, or 2 if the first is ?, no
             defaults}
            {we have to try and spot one command in particular: the
             switch to VT52 mode}
            if (FArgCount = 2) and
               (FArgs^[0] = -2) and (FArgs^[1] = 2) then
              FInVT52Mode := true;
          end;
    'm' : begin
            FCommand := eSGR;
            {should have at least one parameter, default of 0 for all
             parameters}
            if not vtpValidateArgsPrim(1, 30000, 0) then Exit;
          end;
    'n' : begin {Device status report}
            FCommand := eDSR;
            {should only have one parameter, no default}
            if not vtpValidateArgsPrim(1, 1, -1) then Exit;
          end;
    'q' : begin {DEC PRIVATE-set/clear LEDs}
            FCommand := eDECLL;
            {should have at least one parameter, default of 0 for all
             parameters}
            if not vtpValidateArgsPrim(1, 30000, 0) then Exit;
          end;
    'r' : begin {DEC PRIVATE-set top/bottom margins}
            FCommand := eDECSTBM;
            {should have two parameters, first default of 1, second
             default unknowable by this class}
          end;
    's' : begin {save cursor pos - ANSI.SYS escape sequence}
            FCommand := eSaveCursorPos;
          end;
    'u' : begin {restore cursor pos - ANSI.SYS escape sequence}
            FCommand := eRestoreCursorPos;
          end;
    'x' : begin {DEC PRIVATE-request terminal parameters}
            FCommand := eDECREQTPARM;
            {should only have one parameter, no default}
            if not vtpValidateArgsPrim(1, 1, -1) then Exit;
          end;
    'y' : begin {DEC PRIVATE-invoke confidence test}
            FCommand := eDECTST;
            {should have two parameters, no default for first, second
             default to 0}
          end;
  else {the command letter is unknown}
    Exit;
  end;{case}

  {if we get here the sequence is valid and we've patched up the
   arguments list and count}
  Result := pctComplete;
end;
{--------}
function TAdVT100Parser.vtpProcessVT52(aCh : Ansichar) : TAdParserCmdType;
begin
  FState := psGotCommand;
  Result := pctComplete;
  case aCh of
    '<' : begin {switch to ANSI mode}
            FCommand := eSM;
            FArgCount := 2;  {pretend it's Esc[?2h}
            FArgs^[0] := -2;
            FArgs^[1] := 2;
            FInVT52Mode := false;
          end;
    '=' : begin {enter alternate keypad mode}
            FCommand := eSM;
            FArgCount := 2;
            FArgs^[0] := -2;
            FArgs^[1] := 999; {special APRO code!}
          end;
    '>' : begin {leave alternate keypad mode}
            FCommand := eRM;
            FArgCount := 2;
            FArgs^[0] := -2;
            FArgs^[1] := 999; {special APRO code!}
          end;
    'A' : begin {cursor up}
            FCommand := eCUU;
            FArgCount := 1;
            FArgs^[0] := 1;
          end;
    'B' : begin {cursor down}
            FCommand := eCUD;
            FArgCount := 1;
            FArgs^[0] := 1;
          end;
    'C' : begin {cursor right}
            FCommand := eCUF;
            FArgCount := 1;
            FArgs^[0] := 1;
          end;
    'D' : begin {cursor left}
            FCommand := eCUB;
            FArgCount := 1;
            FArgs^[0] := 1;
          end;
    'F' : begin {switch to graphics characters}
            FCommand := eSO;
          end;
    'G' : begin {switch to ASCII characters}
            FCommand := eSI;
          end;
    'H' : begin {move cursor home}
            FCommand := eCUP;
            FArgCount := 2;
            FArgs^[0] := 1;
            FArgs^[1] := 1;
          end;
    'I' : begin {reverse index = cursor up + scroll}
            FCommand := eRI;
          end;
    'J' : begin {erase to end of screen}
            FCommand := eED;
            FArgCount := 1;
            FArgs^[0] := 0; {ie <esc>[0J}
          end;
    'K' : begin {erase to end of line}
            FCommand := eEL;
            FArgCount := 1;
            FArgs^[0] := 0; {ie <esc>[0K}
          end;
    'Y' : begin {position cursor}
            FState := psParsingCUP52;
            FCommand := eCUP;
            Result := pctPending;
          end;
    'Z' : begin {device attributes, identify}
            FCommand := eDA;
            FArgCount := 1;
            FArgs^[0] := 52; {ie VT52 emulation}
          end;
  else
    Result := pctNone;
  end;{case}
end;
{--------}
function TAdVT100Parser.vtpValidateArgsPrim(aMinArgs : integer;
                                            aMaxArgs : integer;
                                            aDefault : integer) : boolean;
var
  i : integer;
begin
  Result := false;
  {if we have too many arguments, something's obviously wrong}
  if (FArgCount > aMaxArgs) then
    Exit;
  {if we have too few, make the missing ones the default}
  while (FArgCount < aMinArgs) do begin
    if (FArgCountMax = FArgCount) then
      vtpGrowArgs;
    FArgs^[FArgCount] := aDefault;
    inc(FArgCount);
  end;
  {convert any -1 arguments to the default}
  for i := 0 to pred(FArgCount) do
    if (FArgs^[i] = -1) then
      FArgs^[i] := aDefault;
  {and we're done}
  Result := true;
end;
{====================================================================}


{===Initialization/finalization======================================}
procedure ADTrmPsrDone; far;
begin
  { }
end;
{--------}
initialization

finalization
  ADTrmPsrDone;
{--------}
end.
