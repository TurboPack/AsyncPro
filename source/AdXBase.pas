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
{*                   ADXBASE.PAS 4.06                    *}
{*********************************************************}
{*     XML parser Base types and conversion routines     *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdXBase;

interface

uses
  classes,
  OOMisc;


{===System functions=================================================}

type
  TApdUcs4Char = Longint;
  TApdUtf8Char = string[6];
  DOMChar = WideChar;
  PDOMChar = PWideChar;

  { Character encoding types}
  TApdCharEncoding = (ceUnknown, ceUTF8);

  {The TApdMemoryStream class is used to expose TMemoryStream's SetPointer
   method.}
  TApdMemoryStream = class(TMemoryStream)
  public
    procedure SetPointer(Ptr: Pointer; const Size: NativeInt);
  end;

  TApdFileStream = class(TFileStream)
    FFileName : string;
  public
    constructor CreateEx(Mode : Word; const FileName : string);

    property Filename : string read FFileName;
  end;

{ Utility methods }
function ApxPos(const aSubStr, aString : DOMString) : Integer;
function ApxRPos(const sSubStr, sTerm : DOMString) : Integer;
{ character conversion routines }
function ApxIso88591ToUcs4(aInCh  : AnsiChar;
                      var aOutCh : TApdUcs4Char) : Boolean;
function ApxUcs4ToIso88591(aInCh  : TApdUcs4Char;
                      var aOutCh : AnsiChar) : Boolean;
function ApxUcs4ToWideChar(const aInChar : TApdUcs4Char;
                            var aOutWS  : DOMChar) : Boolean;
function ApxUtf16ToUcs4(aInChI,
                       aInChII   : DOMChar;
                   var aOutCh    : TApdUcs4Char;
                   var aBothUsed : Boolean) : Boolean;
function ApxUcs4ToUtf8(aInCh  : TApdUcs4Char;
                  var aOutCh : TApdUtf8Char) : Boolean;
function ApxUtf8ToUcs4(const aInCh  : TApdUtf8Char;
                            aBytes : Integer;
                        var aOutCh : TApdUcs4Char) : Boolean;

{ UTF specials }
function ApxGetLengthUtf8(const aCh : AnsiChar) : byte;

{ character classes }
function ApxIsBaseChar(aCh : TApdUcs4Char) : Boolean;
function ApxIsChar(const aCh : TApdUcs4Char) : Boolean;
function ApxIsCombiningChar(aCh : TApdUcs4Char) : Boolean;
function ApxIsDigit(aCh : TApdUcs4Char) : Boolean;
function ApxIsExtender(aCh : TApdUcs4Char) : Boolean;
function ApxIsIdeographic(aCh : TApdUcs4Char) : Boolean;
function ApxIsLetter(aCh : TApdUcs4Char) : Boolean;
function ApxIsNameChar(aCh : TApdUcs4Char) : Boolean;
function ApxIsNameCharFirst(aCh : TApdUcs4Char) : Boolean;
function ApxIsPubidChar(aCh : TApdUcs4Char) : Boolean;
function ApxIsSpace(aCh : TApdUcs4Char) : Boolean;

implementation

uses
  sysutils;

{== Utility methods ==================================================}
function ApxPos(const aSubStr, aString : DOMString) : Integer;
begin
  Result := AnsiPos(aSubStr, aString);
end;
{--------}
function ApxRPos(const sSubStr, sTerm : DOMString) : Integer;
var
  cLast : DOMChar;
  i, j  : Integer;
begin
  j := Length(sSubStr);
  cLast := sSubStr[j];
  for i := Length(sTerm) downto j do begin
    if (sTerm[i] = cLast) and
       (Copy(sTerm, i - j + 1, j) = sSubStr) then begin
      Result := i - j + 1;
      Exit;
    end;
  end;
  Result := 0;
end;
{===character conversion routines====================================}
function ApxIso88591ToUcs4(aInCh  : AnsiChar;
                      var aOutCh : TApdUcs4Char) : boolean;
begin
  {Note: the conversion from ISO-8859-1 to UCS-4 is very simple: the
         result is the original character}
  aOutCh := ord(aInCh);
  Result := true; {cannot fail}
end;
{--------}
function ApxUcs4ToIso88591(aInCh  : TApdUcs4Char;
                      var aOutCh : AnsiChar) : Boolean;
begin
  {Note: the conversion from UCS-4 to ISO-8859-1 is very simple: if
         the character is contained in a byte, the result is the
         original character; otherwise the conversion cannot be done}
  aInCh := abs(aInCh);
  if (($00 <= aInCh) and (aInCh <= $FF)) then begin
    aOutCh := AnsiChar(aInCh and $FF);
    Result := true;
  end
  else begin
    Result := false;
    aOutCh := #0;
  end;
end;
{--------}
function ApxUcs4ToWideChar(const aInChar : TApdUcs4Char;
                            var aOutWS  : DOMChar) : Boolean;
var
  Temp : Longint;
begin
  Temp := abs(aInChar);
  if (Temp < $10000) then begin
    aOutWS := DOMChar(Temp);
    Result := True;
  end else if (Temp <= $10FFFF) then begin
    dec(Temp, $10000);
    Temp := $DC00 or (Temp and $3FF);
    Temp := $D800 or (Temp shr 10);
    aOutWS := DOMChar(Temp);
    Result := True;
  end else begin
    aOutWS := #0;
    Result := False;
  end;
end;
{--------}
function ApxUtf16ToUcs4(aInChI,
                       aInChII   : DOMChar;
                   var aOutCh    : TApdUcs4Char;
                   var aBothUsed : Boolean) : Boolean;
begin
  aBothUsed := False;
  if (aInChI < #$D800) or (aInChI > #$DFFF) then begin
    aOutCh := Integer(aInChI);
    Result := True;
  end
  else if (aInChI < #$DC00) and
          ((#$DC00 <= aInChII) and (aInChII <= #$DFFF)) then begin
    aOutCh := ((integer(aInChI) and $3FF) shl 10) or
              (integer(aInChII) and $3FF);
    aBothUsed := True;
    Result := True;
  end
  else begin
    Result := False;
    aOUtCh := 0;
  end;
end;
{--------}
function ApxUcs4ToUtf8(aInCh  : TApdUcs4Char;
                  var aOutCh : TApdUtf8Char) : Boolean;
begin
  aInCh := abs(aInCh);
  {if the UCS-4 value is $00 to $7f, no conversion is required}
  if (aInCh < $80) then begin
    aOutCh[0] := #1;
    aOutCh[1] := AnsiChar(aInCh);
  end
  {if the UCS-4 value is $80 to $7ff, a two character string is
   produced}
  else if (aInCh < $800) then begin
    aOutCh[0] := #2;
    aOutCh[1] := AnsiChar($C0 or (aInCh shr 6));
    aOutCh[2] := AnsiChar($80 or (aInCh and $3F));
  end
  {if the UCS-4 value is $800 to $ffff, a three character string is
   produced}
  else if (aInCh < $10000) then begin
    aOutCh[0] := #3;
    aOutCh[1] := AnsiChar($E0 or (aInCh shr 12));
    aOutCh[2] := AnsiChar($80 or ((aInCh shr 6) and $3F));
    aOutCh[3] := AnsiChar($80 or (aInCh and $3F));
  end
  {NOTE: the following if clauses will be very rarely used since the
         majority of characters will be unicode characters: $0000 to
         $FFFF}
  {if the UCS-4 value is $10000 to $1fffff, a four character string
   is produced}
  else if (aInCh < $200000) then begin
    aOutCh[0] := #4;
    aOutCh[1] := AnsiChar($F0 or (aInCh shr 18));
    aOutCh[2] := AnsiChar($80 or ((aInCh shr 12) and $3F));
    aOutCh[3] := AnsiChar($80 or ((aInCh shr 6) and $3F));
    aOutCh[4] := AnsiChar($80 or (aInCh and $3F));
  end
  {if the UCS-4 value is $200000 to $3ffffff, a five character
   string is produced}
  else if (aInCh < $4000000) then begin
    aOutCh[0] := #5;
    aOutCh[1] := AnsiChar($F8 or (aInCh shr 24));
    aOutCh[2] := AnsiChar($80 or ((aInCh shr 18) and $3F));
    aOutCh[3] := AnsiChar($80 or ((aInCh shr 12) and $3F));
    aOutCh[4] := AnsiChar($80 or ((aInCh shr 6) and $3F));
    aOutCh[5] := AnsiChar($80 or (aInCh and $3F));
  end
  {for all other UCS-4 values, a six character string is produced}
  else begin
    aOutCh[0] := #6;
    aOutCh[1] := AnsiChar($FC or (aInCh shr 30));
    aOutCh[2] := AnsiChar($80 or ((aInCh shr 24) and $3F));
    aOutCh[3] := AnsiChar($80 or ((aInCh shr 18) and $3F));
    aOutCh[4] := AnsiChar($80 or ((aInCh shr 12) and $3F));
    aOutCh[5] := AnsiChar($80 or ((aInCh shr 6) and $3F));
    aOutCh[6] := AnsiChar($80 or (aInCh and $3F));
  end;
  Result := True; {cannot fail}
end;
{--------}
function ApxUtf8ToUcs4(const aInCh  : TApdUtf8Char;
                            aBytes : Integer;
                        var aOutCh : TApdUcs4Char) : Boolean;
var
  InFirstByte : AnsiChar;
  InCharLen   : Integer;
  i           : Integer;
begin
  InFirstByte := aInCh[1];
  InCharLen := Length(aInCh);
  {the length of the UTF-8 character cannot be zero and must match
   that of the first ASCII character in the string}
  if ((InCharLen = 0) or
      (InCharLen <> aBytes)) then begin
    Result := False;
    aOutCh := 0;
    Exit;
  end;
  {all subsequent characters must have the most significant bit set
   and the next to most significant digit clear; we'll test for this
   as we go along}
  {get the bits from the first ASCII character}
  if (InFirstByte <= #$7F) then
    aOutCh := Ord(InFirstByte)
  else if (InFirstByte <= #$DF) then
    aOutCh := Ord(InFirstByte) and $1F
  else if (InFirstByte <= #$EF) then
    aOutCh := Ord(InFirstByte) and $0F
  else if (InFirstByte <= #$F7) then
    aOutCh := Ord(InFirstByte) and $07
  else if (InFirstByte <= #$FB) then
    aOutCh := Ord(InFirstByte) and $03
  else
    aOutCh := Ord(InFirstByte) and $01;
  {get the bits from the remaining ASCII characters}
  for i := 2 to InCharLen do begin
    if ((Byte(aInCh[i]) and $C0) <> $80) then begin
      Result := False;
      aOutCh := 0;
      Exit;
    end;
    aOutCh := (aOutCh shl 6) or (Byte(aInCh[i]) and $3F);
  end;
  {success}
  Result := True;
end;
{====================================================================}


{===UTF specials=====================================================}
function ApxGetLengthUtf8(const aCh : AnsiChar) : Byte;
begin
  if (aCh <= #$7F) then
    Result := 1
  else if (aCh <= #$BF) then
    Result := 0              { $80--$BF is an error }
  else if (aCh <= #$DF) then
    Result := 2
  else if (aCh <= #$EF) then
    Result := 3
  else if (aCh <= #$F7) then
    Result := 4
  else if (aCh <= #$FB) then
    Result := 5
  else if (aCh <= #$FD) then
    Result := 6
  else
    Result := 0;             { $FE, $FF is an error }
end;
{====================================================================}


{===character classes================================================}
function ApxIsBaseChar(aCh : TApdUcs4Char) : boolean;
begin
  Result := (($0041 <= aCh) and (aCh <= $005A)) or
            (($0061 <= aCh) and (aCh <= $007A)) or
            (($00C0 <= aCh) and (aCh <= $00D6)) or
            (($00D8 <= aCh) and (aCh <= $00F6)) or
            (($00F8 <= aCh) and (aCh <= $00FF)) or
            (($0100 <= aCh) and (aCh <= $0131)) or
            (($0134 <= aCh) and (aCh <= $013E)) or
            (($0141 <= aCh) and (aCh <= $0148)) or
            (($014A <= aCh) and (aCh <= $017E)) or
            (($0180 <= aCh) and (aCh <= $01C3)) or
            (($01CD <= aCh) and (aCh <= $01F0)) or
            (($01F4 <= aCh) and (aCh <= $01F5)) or
            (($01FA <= aCh) and (aCh <= $0217)) or
            (($0250 <= aCh) and (aCh <= $02A8)) or
            (($02BB <= aCh) and (aCh <= $02C1)) or (aCh = $0386) or
            (($0388 <= aCh) and (aCh <= $038A)) or (aCh = $038C) or
            (($038E <= aCh) and (aCh <= $03A1)) or
            (($03A3 <= aCh) and (aCh <= $03CE)) or
            (($03D0 <= aCh) and (aCh <= $03D6)) or
            (aCh = $03DA) or (aCh = $03DC) or
            (aCh = $03DE) or (aCh = $03E0) or
            (($03E2 <= aCh) and (aCh <= $03F3)) or
            (($0401 <= aCh) and (aCh <= $040C)) or
            (($040E <= aCh) and (aCh <= $044F)) or
            (($0451 <= aCh) and (aCh <= $045C)) or
            (($045E <= aCh) and (aCh <= $0481)) or
            (($0490 <= aCh) and (aCh <= $04C4)) or
            (($04C7 <= aCh) and (aCh <= $04C8)) or
            (($04CB <= aCh) and (aCh <= $04CC)) or
            (($04D0 <= aCh) and (aCh <= $04EB)) or
            (($04EE <= aCh) and (aCh <= $04F5)) or
            (($04F8 <= aCh) and (aCh <= $04F9)) or
            (($0531 <= aCh) and (aCh <= $0556)) or (aCh = $0559) or
            (($0561 <= aCh) and (aCh <= $0586)) or
            (($05D0 <= aCh) and (aCh <= $05EA)) or
            (($05F0 <= aCh) and (aCh <= $05F2)) or
            (($0621 <= aCh) and (aCh <= $063A)) or
            (($0641 <= aCh) and (aCh <= $064A)) or
            (($0671 <= aCh) and (aCh <= $06B7)) or
            (($06BA <= aCh) and (aCh <= $06BE)) or
            (($06C0 <= aCh) and (aCh <= $06CE)) or
            (($06D0 <= aCh) and (aCh <= $06D3)) or (aCh = $06D5) or
            (($06E5 <= aCh) and (aCh <= $06E6)) or
            (($0905 <= aCh) and (aCh <= $0939)) or (aCh = $093D) or
            (($0958 <= aCh) and (aCh <= $0961)) or
            (($0985 <= aCh) and (aCh <= $098C)) or
            (($098F <= aCh) and (aCh <= $0990)) or
            (($0993 <= aCh) and (aCh <= $09A8)) or
            (($09AA <= aCh) and (aCh <= $09B0)) or (aCh = $09B2) or
            (($09B6 <= aCh) and (aCh <= $09B9)) or
            (($09DC <= aCh) and (aCh <= $09DD)) or
            (($09DF <= aCh) and (aCh <= $09E1)) or
            (($09F0 <= aCh) and (aCh <= $09F1)) or
            (($0A05 <= aCh) and (aCh <= $0A0A)) or
            (($0A0F <= aCh) and (aCh <= $0A10)) or
            (($0A13 <= aCh) and (aCh <= $0A28)) or
            (($0A2A <= aCh) and (aCh <= $0A30)) or
            (($0A32 <= aCh) and (aCh <= $0A33)) or
            (($0A35 <= aCh) and (aCh <= $0A36)) or
            (($0A38 <= aCh) and (aCh <= $0A39)) or
            (($0A59 <= aCh) and (aCh <= $0A5C)) or (aCh = $0A5E) or
            (($0A72 <= aCh) and (aCh <= $0A74)) or
            (($0A85 <= aCh) and (aCh <= $0A8B)) or (aCh = $0A8D) or
            (($0A8F <= aCh) and (aCh <= $0A91)) or
            (($0A93 <= aCh) and (aCh <= $0AA8)) or
            (($0AAA <= aCh) and (aCh <= $0AB0)) or
            (($0AB2 <= aCh) and (aCh <= $0AB3)) or
            (($0AB5 <= aCh) and (aCh <= $0AB9)) or
            (aCh = $0ABD) or (aCh = $0AE0) or
            (($0B05 <= aCh) and (aCh <= $0B0C)) or
            (($0B0F <= aCh) and (aCh <= $0B10)) or
            (($0B13 <= aCh) and (aCh <= $0B28)) or
            (($0B2A <= aCh) and (aCh <= $0B30)) or
            (($0B32 <= aCh) and (aCh <= $0B33)) or
            (($0B36 <= aCh) and (aCh <= $0B39)) or (aCh = $0B3D) or
            (($0B5C <= aCh) and (aCh <= $0B5D)) or
            (($0B5F <= aCh) and (aCh <= $0B61)) or
            (($0B85 <= aCh) and (aCh <= $0B8A)) or
            (($0B8E <= aCh) and (aCh <= $0B90)) or
            (($0B92 <= aCh) and (aCh <= $0B95)) or
            (($0B99 <= aCh) and (aCh <= $0B9A)) or (aCh = $0B9C) or
            (($0B9E <= aCh) and (aCh <= $0B9F)) or
            (($0BA3 <= aCh) and (aCh <= $0BA4)) or
            (($0BA8 <= aCh) and (aCh <= $0BAA)) or
            (($0BAE <= aCh) and (aCh <= $0BB5)) or
            (($0BB7 <= aCh) and (aCh <= $0BB9)) or
            (($0C05 <= aCh) and (aCh <= $0C0C)) or
            (($0C0E <= aCh) and (aCh <= $0C10)) or
            (($0C12 <= aCh) and (aCh <= $0C28)) or
            (($0C2A <= aCh) and (aCh <= $0C33)) or
            (($0C35 <= aCh) and (aCh <= $0C39)) or
            (($0C60 <= aCh) and (aCh <= $0C61)) or
            (($0C85 <= aCh) and (aCh <= $0C8C)) or
            (($0C8E <= aCh) and (aCh <= $0C90)) or
            (($0C92 <= aCh) and (aCh <= $0CA8)) or
            (($0CAA <= aCh) and (aCh <= $0CB3)) or
            (($0CB5 <= aCh) and (aCh <= $0CB9)) or (aCh = $0CDE) or
            (($0CE0 <= aCh) and (aCh <= $0CE1)) or
            (($0D05 <= aCh) and (aCh <= $0D0C)) or
            (($0D0E <= aCh) and (aCh <= $0D10)) or
            (($0D12 <= aCh) and (aCh <= $0D28)) or
            (($0D2A <= aCh) and (aCh <= $0D39)) or
            (($0D60 <= aCh) and (aCh <= $0D61)) or
            (($0E01 <= aCh) and (aCh <= $0E2E)) or (aCh = $0E30) or
            (($0E32 <= aCh) and (aCh <= $0E33)) or
            (($0E40 <= aCh) and (aCh <= $0E45)) or
            (($0E81 <= aCh) and (aCh <= $0E82)) or (aCh = $0E84) or
            (($0E87 <= aCh) and (aCh <= $0E88)) or
            (aCh = $0E8A) or (aCh = $0E8D) or
            (($0E94 <= aCh) and (aCh <= $0E97)) or
            (($0E99 <= aCh) and (aCh <= $0E9F)) or
            (($0EA1 <= aCh) and (aCh <= $0EA3)) or
            (aCh = $0EA5) or (aCh = $0EA7) or
            (($0EAA <= aCh) and (aCh <= $0EAB)) or
            (($0EAD <= aCh) and (aCh <= $0EAE)) or (aCh = $0EB0) or
            (($0EB2 <= aCh) and (aCh <= $0EB3)) or (aCh = $0EBD) or
            (($0EC0 <= aCh) and (aCh <= $0EC4)) or
            (($0F40 <= aCh) and (aCh <= $0F47)) or
            (($0F49 <= aCh) and (aCh <= $0F69)) or
            (($10A0 <= aCh) and (aCh <= $10C5)) or
            (($10D0 <= aCh) and (aCh <= $10F6)) or (aCh = $1100) or
            (($1102 <= aCh) and (aCh <= $1103)) or
            (($1105 <= aCh) and (aCh <= $1107)) or (aCh = $1109) or
            (($110B <= aCh) and (aCh <= $110C)) or
            (($110E <= aCh) and (aCh <= $1112)) or
            (aCh = $113C) or (aCh = $113E) or (aCh = $1140) or
            (aCh = $114C) or (aCh = $114E) or (aCh = $1150) or
            (($1154 <= aCh) and (aCh <= $1155)) or (aCh = $1159) or
            (($115F <= aCh) and (aCh <= $1161)) or
            (aCh = $1163) or (aCh = $1165) or
            (aCh = $1167) or (aCh = $1169) or
            (($116D <= aCh) and (aCh <= $116E)) or
            (($1172 <= aCh) and (aCh <= $1173)) or
            (aCh = $1175) or (aCh = $119E) or
            (aCh = $11A8) or (aCh = $11AB) or
            (($11AE <= aCh) and (aCh <= $11AF)) or
            (($11B7 <= aCh) and (aCh <= $11B8)) or (aCh = $11BA) or
            (($11BC <= aCh) and (aCh <= $11C2)) or
            (aCh = $11EB) or (aCh = $11F0) or (aCh = $11F9) or
            (($1E00 <= aCh) and (aCh <= $1E9B)) or
            (($1EA0 <= aCh) and (aCh <= $1EF9)) or
            (($1F00 <= aCh) and (aCh <= $1F15)) or
            (($1F18 <= aCh) and (aCh <= $1F1D)) or
            (($1F20 <= aCh) and (aCh <= $1F45)) or
            (($1F48 <= aCh) and (aCh <= $1F4D)) or
            (($1F50 <= aCh) and (aCh <= $1F57)) or
            (aCh = $1F59) or (aCh = $1F5B) or (aCh = $1F5D) or
            (($1F5F <= aCh) and (aCh <= $1F7D)) or
            (($1F80 <= aCh) and (aCh <= $1FB4)) or
            (($1FB6 <= aCh) and (aCh <= $1FBC)) or (aCh = $1FBE) or
            (($1FC2 <= aCh) and (aCh <= $1FC4)) or
            (($1FC6 <= aCh) and (aCh <= $1FCC)) or
            (($1FD0 <= aCh) and (aCh <= $1FD3)) or
            (($1FD6 <= aCh) and (aCh <= $1FDB)) or
            (($1FE0 <= aCh) and (aCh <= $1FEC)) or
            (($1FF2 <= aCh) and (aCh <= $1FF4)) or
            (($1FF6 <= aCh) and (aCh <= $1FFC)) or (aCh = $2126) or
            (($212A <= aCh) and (aCh <= $212B)) or (aCh = $212E) or
            (($2180 <= aCh) and (aCh <= $2182)) or
            (($3041 <= aCh) and (aCh <= $3094)) or
            (($30A1 <= aCh) and (aCh <= $30FA)) or
            (($3105 <= aCh) and (aCh <= $312C)) or
            (($AC00 <= aCh) and (aCh <= $D7A3));
end;
{--------}
function ApxIsChar(const aCh : TApdUcs4Char) : boolean;
begin
  Result := (aCh = 9) or (aCh = 10) or (aCh = 13) or
            (($20 <= aCh) and (aCh <= $D7FF)) or
            (($E000 <= aCh) and (aCh <= $FFFD)) or
            (($10000 <= aCh) and (aCh <= $10FFFF));
end;
{--------}
function ApxIsCombiningChar(aCh : TApdUcs4Char) : boolean;
begin
  Result := (($0300 <= aCh) and (aCh <= $0345)) or
            (($0360 <= aCh) and (aCh <= $0361)) or
            (($0483 <= aCh) and (aCh <= $0486)) or
            (($0591 <= aCh) and (aCh <= $05A1)) or
            (($05A3 <= aCh) and (aCh <= $05B9)) or
            (($05BB <= aCh) and (aCh <= $05BD)) or (aCh = $05BF) or
            (($05C1 <= aCh) and (aCh <= $05C2)) or (aCh = $05C4) or
            (($064B <= aCh) and (aCh <= $0652)) or (aCh = $0670) or
            (($06D6 <= aCh) and (aCh <= $06DC)) or
            (($06DD <= aCh) and (aCh <= $06DF)) or
            (($06E0 <= aCh) and (aCh <= $06E4)) or
            (($06E7 <= aCh) and (aCh <= $06E8)) or
            (($06EA <= aCh) and (aCh <= $06ED)) or
            (($0901 <= aCh) and (aCh <= $0903)) or (aCh = $093C) or
            (($093E <= aCh) and (aCh <= $094C)) or (aCh = $094D) or
            (($0951 <= aCh) and (aCh <= $0954)) or
            (($0962 <= aCh) and (aCh <= $0963)) or
            (($0981 <= aCh) and (aCh <= $0983)) or
            (aCh = $09BC) or (aCh = $09BE) or (aCh = $09BF) or
            (($09C0 <= aCh) and (aCh <= $09C4)) or
            (($09C7 <= aCh) and (aCh <= $09C8)) or
            (($09CB <= aCh) and (aCh <= $09CD)) or (aCh = $09D7) or
            (($09E2 <= aCh) and (aCh <= $09E3)) or
            (aCh = $0A02) or (aCh = $0A3C) or
            (aCh = $0A3E) or (aCh = $0A3F) or
            (($0A40 <= aCh) and (aCh <= $0A42)) or
            (($0A47 <= aCh) and (aCh <= $0A48)) or
            (($0A4B <= aCh) and (aCh <= $0A4D)) or
            (($0A70 <= aCh) and (aCh <= $0A71)) or
            (($0A81 <= aCh) and (aCh <= $0A83)) or
            (aCh = $0ABC) or (($0ABE <= aCh) and (aCh <= $0AC5)) or
            (($0AC7 <= aCh) and (aCh <= $0AC9)) or
            (($0ACB <= aCh) and (aCh <= $0ACD)) or
            (($0B01 <= aCh) and (aCh <= $0B03)) or (aCh = $0B3C) or
            (($0B3E <= aCh) and (aCh <= $0B43)) or
            (($0B47 <= aCh) and (aCh <= $0B48)) or
            (($0B4B <= aCh) and (aCh <= $0B4D)) or
            (($0B56 <= aCh) and (aCh <= $0B57)) or
            (($0B82 <= aCh) and (aCh <= $0B83)) or
            (($0BBE <= aCh) and (aCh <= $0BC2)) or
            (($0BC6 <= aCh) and (aCh <= $0BC8)) or
            (($0BCA <= aCh) and (aCh <= $0BCD)) or (aCh = $0BD7) or
            (($0C01 <= aCh) and (aCh <= $0C03)) or
            (($0C3E <= aCh) and (aCh <= $0C44)) or
            (($0C46 <= aCh) and (aCh <= $0C48)) or
            (($0C4A <= aCh) and (aCh <= $0C4D)) or
            (($0C55 <= aCh) and (aCh <= $0C56)) or
            (($0C82 <= aCh) and (aCh <= $0C83)) or
            (($0CBE <= aCh) and (aCh <= $0CC4)) or
            (($0CC6 <= aCh) and (aCh <= $0CC8)) or
            (($0CCA <= aCh) and (aCh <= $0CCD)) or
            (($0CD5 <= aCh) and (aCh <= $0CD6)) or
            (($0D02 <= aCh) and (aCh <= $0D03)) or
            (($0D3E <= aCh) and (aCh <= $0D43)) or
            (($0D46 <= aCh) and (aCh <= $0D48)) or
            (($0D4A <= aCh) and (aCh <= $0D4D)) or
            (aCh = $0D57) or (aCh = $0E31) or
            (($0E34 <= aCh) and (aCh <= $0E3A)) or
            (($0E47 <= aCh) and (aCh <= $0E4E)) or (aCh = $0EB1) or
            (($0EB4 <= aCh) and (aCh <= $0EB9)) or
            (($0EBB <= aCh) and (aCh <= $0EBC)) or
            (($0EC8 <= aCh) and (aCh <= $0ECD)) or
            (($0F18 <= aCh) and (aCh <= $0F19)) or
            (aCh = $0F35) or (aCh = $0F37) or (aCh = $0F39) or
            (aCh = $0F3E) or (aCh = $0F3F) or
            (($0F71 <= aCh) and (aCh <= $0F84)) or
            (($0F86 <= aCh) and (aCh <= $0F8B)) or
            (($0F90 <= aCh) and (aCh <= $0F95)) or (aCh = $0F97) or
            (($0F99 <= aCh) and (aCh <= $0FAD)) or
            (($0FB1 <= aCh) and (aCh <= $0FB7)) or (aCh = $0FB9) or
            (($20D0 <= aCh) and (aCh <= $20DC)) or (aCh = $20E1) or
            (($302A <= aCh) and (aCh <= $302F)) or
            (aCh = $3099) or (aCh = $309A);
end;
{--------}
function ApxIsDigit(aCh : TApdUcs4Char) : boolean;
begin
  Result :=  (($30 <= aCh) and (aCh <= $39)) or
             (($660 <= aCh) and (aCh <= $669)) or
             (($6F0 <= aCh) and (aCh <= $6F9)) or
             (($966 <= aCh) and (aCh <= $96F)) or
             (($9E6 <= aCh) and (aCh <= $9EF)) or
             (($A66 <= aCh) and (aCh <= $A6F)) or
             (($AE6 <= aCh) and (aCh <= $AEF)) or
             (($B66 <= aCh) and (aCh <= $B6F)) or
             (($BE7 <= aCh) and (aCh <= $BEF)) or
             (($C66 <= aCh) and (aCh <= $C6F)) or
             (($CE6 <= aCh) and (aCh <= $CEF)) or
             (($D66 <= aCh) and (aCh <= $D6F)) or
             (($E50 <= aCh) and (aCh <= $E59)) or
             (($ED0 <= aCh) and (aCh <= $ED9)) or
             (($F20 <= aCh) and (aCh <= $F29));
end;
{--------}
function ApxIsExtender(aCh : TApdUcs4Char) : boolean;
begin
  Result := (aCh = $00B7) or (aCh = $02D0) or
            (aCh = $02D1) or (aCh = $0387) or
            (aCh = $0640) or (aCh = $0E46) or
            (aCh = $0EC6) or (aCh = $3005) or
            (($3031 <= aCh) and (aCh <= $3035)) or
            (($309D <= aCh) and (aCh <= $309E)) or
            (($30FC <= aCh) and (aCh <= $30FE));
end;
{--------}
function ApxIsIdeographic(aCh : TApdUcs4Char) : boolean;
begin
  Result := (($4E00 <= aCh) and (aCh <= $9FA5)) or
            (aCh = $3007) or
            (($3021 <= aCh) and (aCh <= $3029));
end;
{--------}
function ApxIsLetter(aCh : TApdUcs4Char) : boolean;
begin
  Result := ApxIsBaseChar(aCh) or ApxIsIdeographic(aCh);
end;
{--------}
function ApxIsNameChar(aCh : TApdUcs4Char) : boolean;
begin
  Result := ApxIsLetter(aCh) or ApxIsDigit(aCh) or
            (aCh = ord('.')) or (aCh = ord('-')) or
            (aCh = ord('_')) or (aCh = ord(':')) or
            ApxIsCombiningChar(aCh) or ApxIsExtender(aCh);
end;
{--------}
function ApxIsNameCharFirst(aCh : TApdUcs4Char) : boolean;
begin
  Result := ApxIsLetter(aCh) or (aCh = ord('_')) or (aCh = ord(':'));
end;
{--------}
function ApxIsPubidChar(aCh : TApdUcs4Char) : boolean;
begin
  Result := (aCh = $20) or (aCh = 13) or (aCh = 10) or
            ((ord('a') <= aCh) and (aCh <= ord('z'))) or
            ((ord('A') <= aCh) and (aCh <= ord('Z'))) or
            ((ord('0') <= aCh) and (aCh <= ord('9'))) or
            (aCh = ord('-')) or (aCh = ord('''')) or
            (aCh = ord('(')) or (aCh = ord(')')) or
            (aCh = ord('+')) or (aCh = ord(',')) or
            (aCh = ord('.')) or (aCh = ord('/')) or
            (aCh = ord(':')) or (aCh = ord('=')) or
            (aCh = ord('?')) or (aCh = ord(';')) or
            (aCh = ord('!')) or (aCh = ord('*')) or
            (aCh = ord('#')) or (aCh = ord('@')) or
            (aCh = ord('$')) or (aCh = ord('_')) or
            (aCh = ord('%'));
end;
{--------}
function ApxIsSpace(aCh : TApdUcs4Char) : Boolean;
begin
  Result := (aCh <= $20) and (AnsiChar(aCh) in [' ', #9, #13, #10]);
end;

{==TApdMemoryStream===================================================}
procedure TApdMemoryStream.SetPointer(Ptr: Pointer; const Size: NativeInt);
begin
  Assert(not Assigned(Memory));
  inherited;
end;

{===TApdFileStream====================================================}
constructor TApdFileStream.CreateEx(Mode : Word; const FileName : string);
begin
  inherited Create(FileName, Mode);
  FFileName := FileName;
end;

end.
