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
{*                    EXLOG0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{*     Shows all TApdComPort logging options.            *}
{*********************************************************}

unit Exlog0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, AdPort, OoMisc, ADTrmEmu;

type
  TExampleLog = class(TForm)
    LogOps: TRadioGroup;
    Quit: TButton;
    ApdComPort1: TApdComPort;
    AdTerminal1: TAdTerminal;
    procedure QuitClick(Sender: TObject);
    procedure LogOpsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExampleLog: TExampleLog;

implementation

{$R *.DFM}

procedure TExampleLog.QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TExampleLog.LogOpsClick(Sender: TObject);
const
  InClick : Boolean = False;
begin
  if not InClick then begin
    InClick := True;
    ApdComPort1.Logging := TTraceLogState(LogOps.ItemIndex);
    LogOps.ItemIndex := Ord(ApdComPort1.Logging);
    AdTerminal1.SetFocus;
    InClick := False;
  end;
end;

end.
