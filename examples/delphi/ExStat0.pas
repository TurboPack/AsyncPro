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
{*                   EXSTAT0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{* Shows protocol transfer using an OnProtocolStatus     *}
{*      event handler.                                   *}
{*********************************************************}

unit Exstat0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, AdProtcl, AdPort, OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    Panel1: TPanel;
    BytesTransferred: TLabel;
    FileName: TLabel;
    BytesRemaining: TLabel;
    FN: TLabel;
    BT: TLabel;
    BR: TLabel;
    StartTransmit: TButton;
    Cancel: TButton;
    Msg: TLabel;
    MS: TLabel;
    AdTerminal1: TAdTerminal;
    procedure ApdProtocol1ProtocolStatus(CP: TObject; Options: Word);
    procedure StartTransmitClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ApdProtocol1ProtocolStatus(CP: TObject; Options: Word);
begin
  case Options of
    apFirstCall : {do setup stuff} ;
    apLastCall  : {do cleanup stuff} ;
    else begin    {show status}
      FN.Caption := ApdProtocol1.FileName;
      BT.Caption := IntToStr(ApdProtocol1.BytesTransferred);
      BR.Caption := IntToStr(ApdProtocol1.BytesRemaining);
      MS.Caption := ApdProtocol1.StatusMsg(ApdProtocol1.ProtocolStatus);
    end;
  end;
end;

procedure TForm1.StartTransmitClick(Sender: TObject);
begin
  AdTerminal1.Active := False;
  ApdProtocol1.StartTransmit;
end;

procedure TForm1.CancelClick(Sender: TObject);
begin
  ApdProtocol1.CancelProtocol;
  AdTerminal1.SetFocus;
end;

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  AdTerminal1.Active := True;
  AdTerminal1.SetFocus;
end;

end.
