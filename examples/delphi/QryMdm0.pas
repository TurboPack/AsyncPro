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
{*                   QRYMDM0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to use a DataPacket to query modem.  *}
{*********************************************************}

unit QryMdm0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, AdPacket, StdCtrls, AdPort, Grids, ExtCtrls, Buttons, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Button1: TButton;
    QueryPacket: TApdDataPacket;
    ErrorPacket: TApdDataPacket;
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure QueryPacketStringPacket(Sender: TObject; Data: String);
    procedure Timer1Timer(Sender: TObject);
    procedure ErrorPacketPacket(Sender: TObject; Data: Pointer;
      Size: Integer);
  private
    { Private declarations }
    InfoIndex : Integer;
  public
    { Public declarations }
    procedure Next;
    procedure Stop;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  InfoCount = 5;
  InfoList : array[1..InfoCount] of string[9] = (
    'I0','I1','I3','+FMFR?','+FCLASS=?');
  InfoTitle : array[1..InfoCount] of string[18] = (
    'Product code','Firmware version #','Device set name',
    'Manufacturer','Fax classes');

procedure TForm1.Stop;
begin
  Timer1.Enabled := False;
  StringGrid1.Cells[0,0] := 'Information';
  StringGrid1.Cells[1,0] := 'Response';
  if StringGrid1.RowCount > 2 then
    StringGrid1.FixedRows := 1;
  Caption := 'Done';
  QueryPacket.Enabled := False;
  ApdComPort1.Open := False;
  Button1.Enabled := True;
  Screen.Cursor := crDefault;
end;

function Escape(s : string) : string;
var
  i : Integer;
begin
  Result := s;
  for i := length(s) downto 1 do
    case s[i] of
    '?','\' :
      insert('\',Result,i);
    end;
end;

procedure TForm1.Next;
var
  Command : string;
begin
  if InfoIndex >= InfoCount then
    Stop
  else begin
    inc(InfoIndex);
    Command := 'AT'+InfoList[InfoIndex]+#13#10;
    QueryPacket.StartString := Escape('AT'+InfoList[InfoIndex]);
    QueryPacket.Enabled := True;
    Application.ProcessMessages;
    ApdComPort1.PutString(Command);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  InfoIndex := 0;
  StringGrid1.RowCount := 1;
  QueryPacket.Enabled := False;
  ApdComPort1.Open := True;
  Screen.Cursor := crHourGlass;
  Timer1.Enabled := True;
  Caption := 'Talking to the modem';
  Application.ProcessMessages;
  Button1.Enabled := False;
  Next;
end;

procedure TForm1.QueryPacketStringPacket(Sender: TObject; Data: String);
var
  i : Integer;
begin
  for i := length(Data) downto 1 do
    if Data[i] < ' ' then
      Delete(Data,i,1);
  if Data <> '' then begin
    StringGrid1.RowCount := StringGrid1.RowCount + 1;
    StringGrid1.Cells[0,StringGrid1.RowCount-1] := InfoTitle[InfoIndex];
    StringGrid1.Cells[1,StringGrid1.RowCount-1] := Data;
  end;
  Next;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Stop;
  ShowMessage('Modem did not respond');
end;

procedure TForm1.ErrorPacketPacket(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  Next;
end;

end.
