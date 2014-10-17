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
{*                   EXZRECV0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Shows how to set up a data trigger to listen for a    *}
{*      Zmodem file receive and start the protocol       *}
{*      automatically. Works together with ExZSend.      *}
{*********************************************************}

unit Exzrecv0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdProtcl, AdPStat, AdPort, OoMisc,
  ADTrmEmu, AdTapi;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    AdTerminal1: TAdTerminal;
    ApdTapiDevice1: TApdTapiDevice;
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure Button1Click(Sender: TObject);
    procedure ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

var
  ZModemHandle : Word;

{$R *.DFM}

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  ZModemHandle := ApdComPort1.AddDataTrigger('rz'#13,False);
  AdTerminal1.Active := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ApdTapiDevice1.AutoAnswer;
end;

procedure TForm1.ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
begin
  if TriggerHandle = ZModemHandle then begin
    ApdComPort1.RemoveTrigger(ZModemHandle);
    AdTerminal1.Active := False;
    ApdProtocol1.StartReceive;
  end;
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  ZModemHandle := ApdComPort1.AddDataTrigger('rz'#13,False);
end;

end.
