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
{*                   EXPROT0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{*Shows protocol transfer combined with ApdProtocolStatus*}
{*   and ApdProtocolLog components.                      *}
{*********************************************************}

unit Exprot0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdProtcl, AdPStat, AdPort, AdExcept,
  ADTrmEmu, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    Upload: TButton;
    Download: TButton;
    ApdProtocolLog1: TApdProtocolLog;
    AdTerminal1: TAdTerminal;
    AdVT100Emulator1: TAdVT100Emulator;
    OpenDialog1: TOpenDialog;
    procedure UploadClick(Sender: TObject);
    procedure DownloadClick(Sender: TObject);
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure ApdProtocol1ProtocolError(CP: TObject; ErrorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.UploadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    AdTerminal1.Active := False;
    ApdProtocol1.StartTransmit;
  end;
end;

procedure TForm1.DownloadClick(Sender: TObject);
begin
  AdTerminal1.Active := False;
  ApdProtocol1.StartReceive;
end;

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  ShowMessage('Protocol finished: '+ErrorMsg(ErrorCode));
  AdTerminal1.Active := True;
end;

procedure TForm1.ApdProtocol1ProtocolError(CP: TObject;
  ErrorCode: Integer);
begin
  ShowMessage('Protocol finished: '+ErrorMsg(ErrorCode));
end;

end.
