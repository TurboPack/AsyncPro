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
{*                   EXFAXMR0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{*Shows how to use the ApdReceiveFax1.StartManualReceive *}
{*********************************************************}

{
  To use this example, a phone should be plugged into the 'phone' jack on the
  modem.  Have someone send a fax to you, then pick up the phone handset when
  it rings.  Once you hear the fax tones, click the 'Start Receive' button.
  The phone handset should disconnect, and the modem will receive the fax.
}

unit exfaxmr0;

interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ADTrmEmu,
  AdFax,
  AdFStat,
  AdPort, OoMisc;

type
  TForm1 = class(TForm)
    ApdReceiveFax1: TApdReceiveFax;
    ApdComPort1: TApdComPort;
    ApdFaxStatus1: TApdFaxStatus;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    AdTerminal1: TAdTerminal;
    procedure Button1Click(Sender: TObject);
    procedure ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  AdTerminal1.Active := False;
  ApdReceiveFax1.StartManualReceive(True);
end;

procedure TForm1.ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
begin
  AdTerminal1.Active := True;
end;

end.
