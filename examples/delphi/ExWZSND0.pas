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
{*                   EXWZSND0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* This is a Winsock version of ExZSend.                 *}
{*********************************************************}

unit EXWZSND0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdProtcl, AdPStat, AdPort, StdCtrls, AdWnPort,
  OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    ApdWinsockPort1: TApdWinsockPort;
    AdTerminal1: TAdTerminal;
    AdVT100Emulator1: TAdVT100Emulator;
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure Button1Click(Sender: TObject);
    procedure ApdWinsockPort1WsConnect(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ApdWinsockPort1WsDisconnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  AdTerminal1.Active := True;
  AdTerminal1.SetFocus;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not ApdWinsockPort1.Open then
    ApdWinsockPort1.WsAddress := Edit1.Text;
  ApdWinsockPort1.Open := not(ApdWinsockPort1.Open);
end;

procedure TForm1.ApdWinsockPort1WsConnect(Sender: TObject);
begin
  ApdProtocol1ProtocolFinish(Self, 0);
  Button2.Enabled := True;
  Button1.Caption := 'Disconnect';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  AdTerminal1.Active := False;
  ApdProtocol1.StartTransmit;
end;

procedure TForm1.ApdWinsockPort1WsDisconnect(Sender: TObject);
begin
  Button1.Caption := 'Connect';
end;

end.
