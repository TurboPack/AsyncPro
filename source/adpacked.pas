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
{*                   ADPACKED.PAS 4.06                   *}
{*********************************************************}
{* Property editor dialog for the TApdDataPacket         *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdPackEd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  AdPacket;

type
  TPacketEditor = class(TForm)
    GroupBox1: TGroupBox;
    ChkCharCount: TCheckBox;
    Label1: TLabel;
    ChkEndString: TCheckBox;
    EdtEndString: TEdit;
    GroupBox2: TGroupBox;
    rbAnyChar: TRadioButton;
    rbString: TRadioButton;
    EdtStartString: TEdit;
    GroupBox3: TGroupBox;
    ChkIgnoreCase: TCheckBox;
    ChkAutoEnable: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    ChkIncludeStrings: TCheckBox;
    ChkEnabled: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EdtCharCount: TEdit;
    EdtTimeout: TEdit;
  end;

function EditPacket(Packet:TApdDataPacket; const Name : string):Boolean;

function StrToCtrlStr(const S : string) : string;
function CtrlStrToStr(const S : string) : string;

implementation

{$R *.DFM}

function CtrlStrToStr(const S : string) : string;
var
  i,N : Integer;
  NumStr : string;
begin
  Result := '';
  i := 1;
  while i <= length(S) do
    case S[i] of
    '''' :
      begin
        inc(i);
        while (i <= length(S)) and (S[i] <> '''') do begin
          Result := Result + S[i];
          inc(i);
        end;
        if S[i] <> '''' then
          raise Exception.Create('Mismatched '' in string');
        inc(i);
      end;
    '#' :
      begin
        inc(i);
        NumStr := '';
        while (i <= length(S)) and CharInSet(S[i], ['$','0'..'9']) do begin
          NumStr := NumStr + S[i];
          inc(i);
        end;
        if (NumStr = '') then
          raise Exception.Create('Numeric constant expected after #');
        N := StrToInt(NumStr);
        if (N < 0) or (N > 255) then
          raise Exception.Create('Numeric constant in string is out of range');
        if N = 0 then
          raise Exception.Create('#0 cannot be stored in a Delphi string');
        Result := Result + chr(N);
      end;
    '^' :
      begin
        inc(i);
        if not CharInSet(S[i], ['A'..'Z','a'..'z']) then
          raise Exception.Create('Alpha character excepted after ^');
        Result := Result + chr(ord(UpCase(S[i])) - ord('A') + 1);
        inc(i);
      end;
    else
      Result := Result + S[i];
      inc(i);
    end;
end;

{$HIGHCHARUNICODE ON}
function StrToCtrlStr(const S : string) : string;
var
  i : Integer;
  Ctrl, InQuotes : Boolean;
begin
  Ctrl := False;
  for i := 1 to length(S) do
    if (S[i] = '#') or (S[i] = '^') or (S[i] < ' ') or (S[i] > #127) then begin
      Ctrl := True;
      break;
    end;
  if Ctrl then
    begin
      Result := '';
      InQuotes := False;
      for i := 1 to length(S) do
        case S[i] of
        #1..#31 :
          begin
            if InQuotes then begin
              Result := Result + '''';
              InQuotes := False;
            end;
            Result := Result + '^' + chr(ord(S[i]) + ord('A') - 1);
          end;
        #32..#127 :
          begin
            if not InQuotes then begin
              Result := Result + '''';
              InQuotes := True;
            end;
            Result := Result + S[i];
          end;
        #128..#255 :
          begin
            if InQuotes then begin
              Result := Result + '''';
              InQuotes := False;
            end;
            Result := Result + '#' + IntToStr(ord(S[i]));
          end;
        end;
      if InQuotes then
        Result := Result + '''';
    end
  else
    Result := S;
end;
{$HIGHCHARUNICODE OFF}

function EditPacket(Packet:TApdDataPacket; const Name : string):Boolean;
var
  PacketEditor : TPacketEditor;
  Ok : Boolean;
begin
  Result := False;
  PacketEditor := TPacketEditor.Create(Application);
  with PacketEditor do
    try
      Caption := 'Properties for '+Packet.Name;
      rbAnyChar.Checked := Packet.StartCond = scAnyData;
      rbString.Checked := Packet.StartCond = scString;
      ChkEndString.Checked := ecString in Packet.EndCond;
      ChkCharCount.Checked :=  ecPacketSize in Packet.EndCond;
      EdtStartString.Text := StrToCtrlStr(string(Packet.StartString));
      EdtEndString.Text := StrToCtrlStr(string(Packet.EndString));
      EdtCharCount.Text := IntToStr(Packet.PacketSize);
      ChkIgnoreCase.Checked := Packet.IgnoreCase;
      ChkAutoEnable.Checked := Packet.AutoEnable;
      EdtTimeout.Text := IntToStr(Packet.TimeOut);
      ChkIncludeStrings.Checked := Packet.IncludeStrings;
      ChkEnabled.Checked := Packet.Enabled;
      repeat
        Ok := True;
        if ShowModal = mrOk then
          try
            if rbString.Checked then
              begin
                Packet.StartCond := scString;
                Packet.StartString := AnsiString(CtrlStrToStr(EdtStartString.Text));
              end
            else
              begin
                Packet.StartCond := scAnyData;
                Packet.StartString := '';
              end;
            Packet.EndCond := [];
            if ChkCharCount.Checked then
              Packet.EndCond := Packet.EndCond + [ecPacketSize];
            if ChkEndString.Checked then
              begin
                Packet.EndCond := Packet.EndCond + [ecString];
                Packet.EndString := AnsiString(CtrlStrToStr(EdtEndString.Text));
              end
            else
              Packet.EndString := '';
            Packet.PacketSize := StrToInt(EdtCharCount.Text);
            Packet.IgnoreCase := ChkIgnoreCase.Checked;
            Packet.AutoEnable := ChkAutoEnable.Checked;
            Packet.TimeOut := StrToInt(EdtTimeout.Text);
            Packet.IncludeStrings := ChkIncludeStrings.Checked;
            Packet.Enabled := ChkEnabled.Checked;
            Result := True;
          except
            Application.HandleException(Packet);
            Ok := False;
          end;
      until Ok;
    finally
      Free;
    end;
end;

end.
