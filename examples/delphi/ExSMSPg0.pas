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
{*                   EXSMSPG0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to use a GSM phone to send an SMS    *)
(* message                                               *}
{*********************************************************}

unit ExSMSPg0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdPort, OoMisc, AdGSM, AdPacket;

type
  TForm1 = class(TForm)
    btnSend: TButton;
    ApdGSMPhone1: TApdGSMPhone;
    ApdComPort1: TApdComPort;
    edtDestAddr: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    lblStatus: TLabel;
    memMessage: TMemo;
    Label3: TLabel;
    btnConnect: TButton;
    procedure btnSendClick(Sender: TObject);
    procedure ApdGSMPhone1GSMComplete(Pager: TApdCustomGSMPhone;
      State: TGSMStates; ErrorCode: Integer);
    procedure memMessageChange(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSendClick(Sender: TObject);
begin
  ApdGSMPhone1.SMSAddress := edtDestAddr.Text;
  ApdGSMPhone1.SMSMessage := memMessage.Text;
  ListBox1.Items.Add('Preparing to send message');
  ApdGSMPhone1.SendMessage;
end;

procedure TForm1.ApdGSMPhone1GSMComplete(Pager: TApdCustomGSMPhone;
  State: TGSMStates; ErrorCode: Integer);
begin
  if ErrorCode <> 0 then begin
    ListBox1.Items.Add('Error number ' + IntToStr(ErrorCode));
    exit;
  end;
  case State of
    gsConfig:  ListBox1.Items.Add('Configuration finished');
    gsSend:    ListBox1.Items.Add('Message was sent');
    gsListAll: ListBox1.Items.Add('List all messages finished');
  end;
end;

procedure TForm1.memMessageChange(Sender: TObject);
begin
  Label3.Caption := 'Character count: ' + IntToStr(Length(memMessage.Text));
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  ApdGSMPhone1.Connect;
end;

end.
