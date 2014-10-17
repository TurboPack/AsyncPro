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
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                  ADXCHRFLT.PAS 4.06                   *}
{*********************************************************}
{*        XML Character streams, input and output        *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdXChrFlt;

interface

uses
  SysUtils,
  Classes,
  OOMisc,
  AdXBase,
  AdExcept;

const
  ApxEndOfStream = #1;
  ApxEndOfReplaceText = #2;
  ApxNullChar = #3;

type
  TApdStreamFormat = {character formats of stream...}
     (sfUTF8,       {..UTF8 -- the default}
      sfUTF16LE,    {..UTF16, little endian (eg, Intel)}
      sfUTF16BE,    {..UTF16, big endian}
      sfISO88591);  {..ISO-8859-1, or Latin 1}

  TApdBaseCharFilter = class(TObject)
    protected
      FBufSize : Longint;
      FBuffer  : PAnsiChar;
      FBufPos  : Longint;
      FFormat  : TApdStreamFormat; {The format of the incoming stream}
      FFreeStream : Boolean;
      FStream  : TStream;
      FStreamPos : Longint;
      FStreamSize : Longint;
    protected
      function csGetSize : Longint; virtual;
      procedure csSetFormat(const aValue : TApdStreamFormat); virtual; abstract;
    public
      constructor Create(aStream : TStream; const aBufSize : Longint); virtual;
      destructor Destroy; override;

      property BufSize : Longint
         read FBufSize;

      property FreeStream : Boolean
         read FFreeStream write FFreeStream;

      property Stream : TStream
         read FStream;

    end;

  TApdInCharFilter = class(TApdBaseCharFilter)
    private
      FBufEnd    : Longint;
      FUCS4Char  : TApdUcs4Char;
      FLine      : Longint;
      FLinePos   : Longint;
      FLastChar  : DOMChar;
      FEOF       : Boolean;
      FBufDMZ    : Longint;
      FInTryRead : Boolean;
    protected
      procedure csAdvanceLine;
      procedure csAdvanceLinePos;
      procedure csGetCharPrim(var aCh : TApdUcs4Char;
                              var aIsLiteral : Boolean);
      function csGetNextBuffer : Boolean;
      function csGetTwoAnsiChars(var Buffer) : Boolean;
      function csGetUtf8Char : TApdUcs4Char;
      procedure csIdentifyFormat;
      procedure csPushCharPrim(aCh : TApdUcs4Char);
      procedure csSetFormat(const aValue : TApdStreamFormat); override;

      procedure csGetChar(var aCh : TApdUcs4Char;
                          var aIsLiteral : Boolean);

    public
      constructor Create(aStream : TStream; const aBufSize : Longint); override;

      property Format : TApdStreamFormat
         read FFormat
         write csSetFormat;
      property EOF : Boolean
         read FEOF;
    public
      procedure SkipChar;
      function TryRead(const S : array of Longint) : Boolean;
      function ReadChar : DOMChar;
      function ReadAndSkipChar : DOMChar;
      property Line : LongInt
         read FLine;
      property LinePos : LongInt
         read FLinePos;
  end;

  TApdOutCharFilter = class(TApdBaseCharFilter)
    protected
      FFormat : TApdStreamFormat;
      FSetUTF8Sig : Boolean;
    protected
      function csGetSize : LongInt; override;
      procedure csPutUtf8Char(const aCh : TApdUcs4Char);
      procedure csSetFormat(const aValue : TApdStreamFormat); override;
      procedure csWriteBuffer;
    public
      constructor Create(aStream : TStream; const aBufSize : Longint); override;
      destructor Destroy; override;

      procedure PutUCS4Char(aCh : TApdUcs4Char);
      function  PutChar(aCh1, aCh2 : DOMChar;
                    var aBothUsed  : Boolean) : Boolean;
      function  PutString(const aText : DOMString) : Boolean;
      function Position : integer;

      property Format : TApdStreamFormat
         read FFormat
         write csSetFormat;
      property WriteUTF8Signature : Boolean
         read FSetUTF8Sig
         write FSetUTF8Sig;
      property Size : LongInt
         read csGetSize;

  end;


implementation

const
  CR      = 13; {Carriage return}
  LF      = 10; {Line feed}

{====================================================================}
constructor TApdBaseCharFilter.Create(aStream  : TStream;
                               const aBufSize : Longint);
begin
  inherited Create;
  Assert(Assigned(aStream));
  FBufSize := aBufSize;
  FBufPos := 0;
  FFormat := sfUTF8;
  FFreeStream := False;
  FStream := aStream;
  FStreamPos := aStream.Position;
  FStreamSize := aStream.Size;
  GetMem(FBuffer, FBufSize);
end;
{--------}
destructor TApdBaseCharFilter.Destroy;
begin
  if Assigned(FBuffer) then begin
    FreeMem(FBuffer, FBufSize);
    FBuffer := nil;
  end;

  if FFreeStream then
    FStream.Free;

  inherited Destroy;
end;
{--------}
function TApdBaseCharFilter.csGetSize : LongInt;
begin
  Result := FStreamSize;
end;
{====================================================================}
constructor TApdInCharFilter.Create(aStream  : TStream;
                             const aBufSize : Longint);
begin
  inherited Create(aStream, aBufSize);
  if FStreamSize <= aBufSize then
    FBufDMZ := 0
  else
    FBufDMZ := 64;
  FBufEnd := 0;
  FLine := 1;
  FLinePos := 1;
  csIdentifyFormat;
  if aStream.Size > 0 then
    FEOF := False
  else
    FEOF := True;
  FUCS4Char := TApdUCS4Char(ApxNullChar);
  FInTryRead := False;
end;
{--------}
procedure TApdInCharFilter.csAdvanceLine;
begin
  Inc(FLine);
  FLinePos := 1;
end;
{--------}
procedure TApdInCharFilter.csAdvanceLinePos;
begin
  Inc(FLinePos);
end;
{--------}
procedure TApdInCharFilter.csGetCharPrim(var aCh : TApdUcs4Char;
                                        var aIsLiteral : Boolean);
begin
  {Note: as described in the XML spec (2.11) all end-of-lines are
         passed as LF characters no matter what the original document
         had. This routine converts a CR/LF pair to a single LF, a
         single CR to an LF, and passes LFs as they are.}

  {get the first (test) character}
  {first check the UCS4Char buffer to see if we have a character there;
   if so get it}
 if (FUCS4Char <> TApdUCS4Char(ApxNullChar)) then begin
    aCh := FUCS4Char;
    FUCS4Char := TApdUCS4Char(ApxNullChar);
  end
  {otherwise get a character from the buffer; this depends on the
   format of the stream of course}
  else begin
    case Format of
      sfUTF8     : aCh := csGetUtf8Char;
    else
      {it is next to impossible that this else clause is reached; if
       it is we're in deep doggy doo-doo, so pretending that it's the
       end of the stream is the least of our worries}
      aCh := TApdUCS4Char(ApxEndOfStream);
    end;
  end;

  {if we got a CR, then we need to see what the next character is; if
   it is an LF, return LF; otherwise put the second character  back
   and still return an LF}
  if (aCh = CR) then begin
    if (FUCS4Char <> TApdUCS4Char(ApxNullChar)) then begin
      aCh := FUCS4Char;
      FUCS4Char := TApdUCS4Char(ApxNullChar);
    end
    else begin
      case Format of
        sfUTF8     : aCh := csGetUtf8Char;
      else
        aCh := TApdUCS4Char(ApxEndOfStream);
      end;
    end;
    if (aCh <> LF) then
      csPushCharPrim(aCh);
    aCh := LF;
  end;

  {check to see that the character is valid according to XML}
  if (aCh <> TApdUCS4Char(ApxEndOfStream)) and (not ApxIsChar(aCh)) then
    raise EAdFilterError.CreateError(FStream.Position,
                                     Line,
                                     LinePos,
                                     sInvalidXMLChar);
end;
{--------}
function TApdInCharFilter.csGetNextBuffer : Boolean;
begin
  if FStream.Position > FBufDMZ then
    {Account for necessary buffer overlap}
    FStream.Position := FStream.Position - (FBufEnd - FBufPos);
  FBufEnd := FStream.Read(FBuffer^, FBufSize);
  FStreamPos := FStream.Position;
  FBufPos := 0;
  Result := FBufEnd <> 0;
end;
{--------}
function TApdInCharFilter.csGetTwoAnsiChars(var Buffer) : Boolean;
type
  TTwoChars = array [0..1] of AnsiChar;
var
  i : integer;
begin
  {get two byte characters from the stream}
  for i := 0 to 1 do begin
    {if the buffer is empty, fill it}
    if (FBufPos >= FBufEnd - FBufDMZ) and
       (not FInTryRead) then begin
      {if we exhaust the stream, we couldn't satisfy the request}
      if not csGetNextBuffer then begin
        Result := false;
        Exit;
      end;
    end;
    {get the first byte character from the buffer}
    TTwoChars(Buffer)[i] := FBuffer[FBufPos];
    inc(FBufPos);
  end;
  Result := true;
end;
{--------}
function TApdInCharFilter.csGetUtf8Char : TApdUcs4Char;
var
  Utf8Char : TApdUtf8Char;
  {Ch       : AnsiChar;}
  Len      : Integer;
  i        : Integer;
begin
  {if the buffer is empty, fill it}
  if (not FInTryRead) and
     (FBufPos >= FBufEnd - FBufDMZ) then begin
    {if we exhaust the stream, there are no more characters}
    if not csGetNextBuffer then begin
      Result := TApdUCS4Char(ApxEndOfStream);
      Exit;
    end;
  end;
  {get the first byte character from the buffer}
  Utf8Char[1] := FBuffer[FBufPos];
  FBufPos := FBufPos + 1;
  {determine the length of the Utf8 character from this}
  Len := ApxGetLengthUtf8(Utf8Char[1]);
  if (Len < 1) then
    raise EAdFilterError.CreateError(FStream.Position,
                                     Line,
                                     LinePos,
                                     sBadUTF8Char);
  Move(Len, Utf8Char[0], 1);
  {get the remaining characters from the stream}
  for i := 2 to Len do begin
    {if the buffer is empty, fill it}
    if (FBufPos >= FBufEnd - FBufDMZ) and
       (not FInTryRead) then begin
      {if we exhaust the stream now, it's a badly formed UTF8
       character--true--but we'll just pretend that the last character
       does not exist}
      if not csGetNextBuffer then begin
        Result := TApdUCS4Char(ApxEndOfStream);
        Exit;
      end;
    end;
    {get the next byte character from the buffer}
    Utf8Char[i] := FBuffer[FBufPos];
    FBufPos := FBufPos + 1;
  end;
  {convert the UTF8 character into a UCS4 character}
  if (not ApxUtf8ToUcs4(Utf8Char, Len, Result)) then
    raise EAdFilterError.CreateError(FStream.Position,
                                     Line,
                                     LinePos,
                                     sBadUTF8Char);
end;
{--------}
procedure TApdInCharFilter.csIdentifyFormat;
begin
  {Note: a stream in either of the UTF16 formats will start with a
         byte-order-mark (BOM). This is the unicode value $FEFF. Hence
         if the first two bytes of the stream are read as ($FE, $FF),
         we have a UTF16BE stream. If they are read as ($FF, $FE), we
         have a UTF16LE stream. Otherwise we assume a UTF8 stream (at
         least for now, it can be changed later).}
  csGetNextBuffer;
  if FBufSize > 2 then
    if (FBuffer[0] = #$FE) and (FBuffer[1] = #$FF) then begin
      FFormat := sfUTF16BE;
      FBufPos := 2;
    end else if (FBuffer[0] = #$FF) and (FBuffer[1] = #$FE) then begin
      FFormat := sfUTF16LE;
      FBufPos := 2;
    end else if (FBuffer[0] = #$EF) and
                (FBuffer[1] = #$BB) and
                (FBuffer[2] = #$BF) then begin
      FFormat := sfUTF8;
      FBufPos := 3;
    end else
      FFormat := sfUTF8
  else
    FFormat := sfUTF8;
end;
{--------}
procedure TApdInCharFilter.csPushCharPrim(aCh : TApdUcs4Char);
begin
  Assert(FUCS4Char = TApdUCS4Char(ApxNullChar));
  {put the char into the buffer}
  FUCS4Char := aCh;
end;
{--------}
procedure TApdInCharFilter.csSetFormat(const aValue : TApdStreamFormat);
begin
  {we do not allow the UTF16 formats to be changed since they were
   well defined by the BOM at the start of the stream but all other
   changes are allowed (caveat user); this means that an input stream
   that defaulted to UTF8 can be changed at a later stage to
   ISO-8859-1 or whatever if required}
  if (Format <> sfUTF16LE) and (Format <> sfUTF16BE) then
    FFormat := aValue;
end;
{--------}
procedure TApdInCharFilter.csGetChar(var aCh        : TApdUcs4Char;
                                    var aIsLiteral : Boolean);
begin
  {get the next character; for an EOF raise an exception}
  csGetCharPrim(aCh, aIsLiteral);
  if (aCh = TApdUCS4Char(ApxEndOfStream)) then
    FEOF := True
  else
    {maintain the line/character counts}
    if (aCh = LF) then
      csAdvanceLine
    else
      csAdvanceLinePos;
end;
{--------}
function TApdInCharFilter.TryRead(const S : array of Longint) : Boolean;
var
  Idx         : Longint;
  Ch          : TApdUcs4Char;
  IL          : Boolean;
  OldBufPos   : Longint;
  OldChar     : DOMChar;
  OldUCS4Char : TApdUcs4Char;
  OldLinePos  : Longint;
  OldLine     : Longint;
begin
  OldBufPos := FBufPos;
  OldChar := FLastChar;
  OldUCS4Char := FUCS4Char;
  OldLinePos := LinePos;
  OldLine := Line;
  Result := True;
  FInTryRead := True;
  try
    for Idx := Low(s) to High(S) do begin
      csGetChar(Ch, IL);
      if Ch <> TApdUcs4Char(S[Idx]) then begin
        Result := False;
        Break;
      end;
    end;
  finally
    if not Result then begin
      FBufPos := OldBufPos;
      FLastChar := OldChar;
      FUCS4Char := OldUCS4Char;
      FLinePos := OldLinePos;
      FLine := OldLine;
    end else begin
      FLastChar := #0;
      FUCS4Char := TApdUCS4Char(ApxNullChar);
      if (FStreamSize = FStreamPos) and
         (FBufPos = FBufEnd) then
        FEOF := True;
    end;
    FInTryRead := False;
  end;
end;
{--------}
procedure TApdInCharFilter.SkipChar;
begin
  FLastChar := #0;
  FUCS4Char := TApdUCS4Char(ApxNullChar);
  Inc(FLinePos);
end;
{--------}
function TApdInCharFilter.ReadandSkipChar : DOMChar;
var
  Ch     : TApdUCS4Char;
  IL     : Boolean;
begin
  if FLastChar = '' then begin
    csGetChar(Ch, IL);
    ApxUcs4ToWideChar(Ch, Result);
  end else begin
    Result := FLastChar;
    Inc(FLinePos);
  end;
  FLastChar := #0;
  FUCS4Char := TApdUCS4Char(ApxNullChar);
  if (FStreamSize = FStreamPos) and
     (FBufPos = FBufEnd) then
    FEOF := True;
end;
{--------}
function TApdInCharFilter.ReadChar : DOMChar;
var
  Ch     : TApdUCS4Char;
  IL     : Boolean;
begin
  if ((FLastChar = '') or (FLastChar = #0)) then begin                      // SWB
    csGetChar(Ch, IL);
    ApxUcs4ToWideChar(Ch, Result);
    Dec(FLinePos);
    FLastChar := Result;
    if (FUCS4Char <> TApdUCS4Char(ApxNullChar)) then
      if (Format = sfUTF16LE) or
         (Format = sfUTF16BE) then
        Dec(FBufPos, 2)
      else if FBufPos > 0 then
        Dec(FBufPos, 1);
    FUCS4Char := Ch;
  end else
    Result := FLastChar;
end;

{===TApdOutCharFilter=================================================}
constructor TApdOutCharFilter.Create(aStream : TStream; const aBufSize : Longint);
begin
  inherited Create(aStream, aBufSize);
  FSetUTF8Sig := True;
end;
{--------}
destructor TApdOutCharFilter.Destroy;
begin
  if Assigned(FBuffer) then
    if (FBufPos > 0) then
      csWriteBuffer;

  inherited Destroy;
end;
{--------}
function TApdOutCharFilter.csGetSize : LongInt;
begin
  Result := FStream.Size + FBufPos;
end;
{--------}
procedure TApdOutCharFilter.csPutUtf8Char(const aCh : TApdUcs4Char);
var
  UTF8 : TApdUtf8Char;
  i    : integer;
begin
  if not ApxUcs4ToUtf8(aCh, UTF8) then
    raise EAdStreamError.CreateError(FStream.Position, sUCS_U8ConverErr);
  for i := 1 to length(UTF8) do begin
    if (FBufPos = FBufSize) then
      csWriteBuffer;
    FBuffer[FBufPos] := UTF8[i];
    inc(FBufPos);
  end;
end;
{--------}
procedure TApdOutCharFilter.csSetFormat(const aValue : TApdStreamFormat);
var
  TooLate : Boolean;
begin
    case Format of
      sfUTF8     : TooLate := (FSetUTF8Sig and (Position > 3)) or
                              ((not FSetUTF8Sig) and (Position > 0));
      sfUTF16LE  : TooLate := (Position > 2);
      sfUTF16BE  : TooLate := (Position > 2);
      sfISO88591 : TooLate := (Position > 0);
    else
      TooLate := true;
    end;
    if not TooLate then begin
      FBufPos := 0;
      FFormat := aValue;
      case Format of
        sfUTF8:
          if FSetUTF8Sig then begin
            FBuffer[0] := #$EF;
            FBuffer[1] := #$BB;
            FBuffer[2] := #$BF;
            FBufPos := 3;
          end;
        sfUTF16LE : begin
                      FBuffer[0] := #$FF;
                      FBuffer[1] := #$FE;
                      FBufPos := 2;
                    end;
        sfUTF16BE : begin
                      FBuffer[0] := #$FE;
                      FBuffer[1] := #$FF;
                      FBufPos := 2;
                    end;
      else
        FBufPos := 0;
      end;
    end;
end;
{--------}
procedure TApdOutCharFilter.csWriteBuffer;
begin
  FStream.WriteBuffer(FBuffer^, FBufPos);
  FBufPos := 0;
end;
{--------}
procedure TApdOutCharFilter.PutUCS4Char(aCh : TApdUcs4Char);
begin
  case Format of
    sfUTF8     : csPutUTF8Char(aCh);
  end;
end;
{--------}
function TApdOutCharFilter.PutChar(aCh1, aCh2 : DOMChar;
                              var aBothUsed  : Boolean) : Boolean;
var
  OutCh : TApdUCS4Char;
begin
  Result := ApxUTF16toUCS4(aCh1, aCh2, OutCh, aBothUsed);
  if Result then
    PutUCS4Char(OutCh);
end;
{--------}
function TApdOutCharFilter.PutString(const aText : DOMString) : Boolean;
var
  aBothUsed : Boolean;
  aLen, aPos : Integer;
begin
  aLen := Length(aText);
  aPos := 1;
  Result := True;
  while Result and (aPos <= aLen) do begin
    if aPos = aLen then
      Result := PutChar(aText[aPos], aText[aPos], aBothUsed)
    else
      Result := PutChar(aText[aPos], aText[aPos + 1], aBothUsed);
    if Result then
      if aBothUsed then
        inc(aPos, 2)
      else
        inc(aPos, 1);
  end;
end;
{--------}
function TApdOutCharFilter.Position : integer;
begin
  Result := FStreamPos + FBufPos;
end;

end.

