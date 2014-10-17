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
{*                   EXTAPID0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* TAPI example that can dial calls.                     *}
{*********************************************************}

unit extapid0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, AdTapi, AdTStat, ExtCtrls,
  OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    ApdTapiDevice1: TApdTapiDevice;
    ApdTapiStatus1: TApdTapiStatus;
    ApdTapiLog1: TApdTapiLog;
    Dial: TButton;
    Hangup: TButton;
    ApdComPort1: TApdComPort;
    Label1: TLabel;
    edtPhoneNumber: TEdit;
    AdTerminal1: TAdTerminal;
    procedure DialClick(Sender: TObject);
    procedure HangupClick(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DialClick(Sender: TObject);
begin
  ApdTapiDevice1.Dial(edtPhoneNumber.Text);
end;

procedure TForm1.HangupClick(Sender: TObject);
begin
  ApdTapiDevice1.CancelCall;
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  AdTerminal1.SetFocus;
end;

end.
