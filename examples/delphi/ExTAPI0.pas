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
{*                   EXTAPI0.PAS 4.06                    *}
{*********************************************************}


{**********************Description************************}
{* TAPI example that can answer calls and dial calls.    *}
{*********************************************************}

unit EXTAPI0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, AdTapi, AdTStat, OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    Dial: TButton;
    ApdTapiDevice1: TApdTapiDevice;
    ApdComPort1: TApdComPort;
    ApdTapiStatus1: TApdTapiStatus;
    Config: TButton;
    Answer: TButton;
    Cancel: TButton;
    ApdTapiLog1: TApdTapiLog;
    AdTerminal1: TAdTerminal;
    procedure DialClick(Sender: TObject);
    procedure ConfigClick(Sender: TObject);
    procedure AnswerClick(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(CP: TObject);
    procedure ApdTapiDevice1TapiPortClose(CP: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ApdTapiDevice1TapiConnect(Sender: TObject);
    procedure ApdTapiDevice1TapiFail(Sender: TObject);
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
  ApdTapiDevice1.Dial('522-1049');
end;

procedure TForm1.AnswerClick(Sender: TObject);
begin
  AdTerminal1.WriteString(' ** Waiting for incoming call...');
  ApdTapiDevice1.AutoAnswer;
end;

procedure TForm1.ConfigClick(Sender: TObject);
begin
  ApdTapiDevice1.ShowConfigDialog;
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(CP: TObject);
begin
  AdTerminal1.WriteString(#13#10#13#10' ** TAPI port opened'#13#10);
  AdTerminal1.SetFocus;
end;

procedure TForm1.ApdTapiDevice1TapiPortClose(CP: TObject);
begin
  if csDesigning in ComponentState then Exit;
  AdTerminal1.WriteString(#13#10#13#10' ** TAPI port closed'#13#10);
end;

procedure TForm1.CancelClick(Sender: TObject);
begin
  ApdTapiDevice1.CancelCall;
end;

procedure TForm1.ApdTapiDevice1TapiConnect(Sender: TObject);
begin
  AdTerminal1.WriteString(#13#10#13#10' ** TAPI connect'#13#10);
end;

procedure TForm1.ApdTapiDevice1TapiFail(Sender: TObject);
begin
  if csDesigning in ComponentState then Exit;
  AdTerminal1.WriteString(#13#10#13#10' ** TAPI fail'#13#10);
end;

end.
