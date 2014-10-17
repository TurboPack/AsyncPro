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
{*                   FAXSERV0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* An example fax server.                                *}
{*********************************************************}

unit FaxServ0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdFax, AdFStat, AdPort, StdCtrls, OoMisc;

const
  Am_NotifyFaxAvailable  = WM_USER + $301;
  Am_NotifyFaxSent       = WM_USER + $302;
  Am_QueryPending        = WM_USER + $303;
type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdSendFax1: TApdSendFax;
    ApdFaxStatus1: TApdFaxStatus;
    Label1: TLabel;
    lblState: TLabel;
    Label2: TLabel;
    edtPhoneNo: TEdit;
    btnSend: TButton;
    procedure SendClick(Sender: TObject);
    procedure ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
  private
    ClientWnd : hWnd;
    JobAtom : Word;
    procedure AmNotifyFaxAvailable(var Message : TMessage); message Am_NotifyFaxAvailable;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.AmNotifyFaxAvailable(var Message : TMessage);
var
  Buffer : array[0..255] of char;
  S : string;
  P : Integer;
begin
  JobAtom := Message.lParam;
  GlobalGetAtomName(JobAtom,Buffer,sizeof(Buffer));
  S := StrPas(Buffer);
  P := pos(#27,S);
  ApdSendFax1.FaxFile := copy(S,P+1,255);
  lblState.Caption := 'Sending ' + copy(S,1,P-1);
  edtPhoneNo.Visible := True;
  edtPhoneNo.Enabled := True;
  btnSend.Enabled := True;
  Label2.Visible := True;
  ClientWnd := Message.wParam;
end;

procedure TForm1.SendClick(Sender: TObject);
begin
  ApdSendFax1.PhoneNumber := edtPhoneNo.Text;
  ApdSendFax1.StartTransmit;
end;

procedure TForm1.ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
var
  Pending : Integer;
begin
  edtPhoneNo.Enabled := False;
  btnSend.Enabled := False;
  Label2.Visible := False;
  edtPhoneNo.Visible := False;
  lblState.Caption := 'Idle';
  Pending := SendMessage(ClientWnd,Am_QueryPending,0,0);
  PostMessage(ClientWnd,Am_NotifyFaxSent,0,JobAtom);
  if Pending <= 1 then
    Close;
end;

end.
