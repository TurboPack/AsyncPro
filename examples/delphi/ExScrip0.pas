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
{*                   EXSCRIP0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates the use of ApdScript with ApdProtocol    *}
{*      and ApdProtocolStatus displayed on an AdTerminal.*}
{*********************************************************}  

unit ExScrip0;

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdScript, AdPort, AdProtcl, AdPStat,
  OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Start: TButton;
    ApdScript1: TApdScript;
    Quit: TButton;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    AdTerminal1: TAdTerminal;
    procedure StartClick(Sender: TObject);
    procedure ApdScript1ScriptFinish(CP: TObject; Condition: Integer);
    procedure QuitClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.StartClick(Sender: TObject);
begin
  ApdScript1.StartScript;
end;

procedure TForm1.ApdScript1ScriptFinish(CP: TObject; Condition: Integer);
begin
  ShowMessage('Script finished!');
end;

procedure TForm1.QuitClick(Sender: TObject);
begin
  Close;
end;

end.
