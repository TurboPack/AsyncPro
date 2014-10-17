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
{*                   EXTAPIF0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Shows how to use a TAPI device when sending a fax.    *}
{*********************************************************}

unit extapif0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdTapi, AdFax, AdFStat, AdPort, OoMisc;

type
  TExTFax = class(TForm)
    ApdComPort1: TApdComPort;
    ApdReceiveFax1: TApdReceiveFax;
    ApdSendFax1: TApdSendFax;
    ApdFaxStatus1: TApdFaxStatus;
    ApdFaxLog1: TApdFaxLog;
    ApdTapiDevice1: TApdTapiDevice;
    SendFax: TButton;
    RcvFax: TButton;
    procedure SendFaxClick(Sender: TObject);
    procedure RcvFaxClick(Sender: TObject);
    procedure ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
    procedure ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
  private
    { Private declarations }
    Sending : Boolean;
  public
    { Public declarations }
  end;

var
  ExTFax: TExTFax;

implementation

{$R *.DFM}

procedure TExTFax.SendFaxClick(Sender: TObject);
begin
  ApdTapiDevice1.ConfigAndOpen;
  Sending := True;
end;

procedure TExTFax.RcvFaxClick(Sender: TObject);
begin
  ApdTapiDevice1.ConfigAndOpen;
  Sending := False;
end;

procedure TExTFax.ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
begin
  ApdTapiDevice1.CancelCall;
end;

procedure TExTFax.ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
begin
  ApdTapiDevice1.CancelCall;
end;

procedure TExTFax.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  if Sending then begin
    ApdFaxStatus1.Fax := ApdSendFax1;
    ApdSendFax1.StartTransmit
  end else begin
    ApdFaxStatus1.Fax := ApdReceiveFax1;
    ApdReceiveFax1.StartReceive;
  end;
end;

end.
