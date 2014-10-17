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
{*                   EXTRIG0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{* TApdComPort with all OnTriggerXxx event handlers.     *}
{*********************************************************}

{$APPTYPE CONSOLE}
unit Extrig0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, AdPort, OoMisc;

type
  TExTrigTest = class(TForm)
    ApdComPort1: TApdComPort;
    StartTest: TButton;
    Label1: TLabel;
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure ApdComPort1TriggerData(CP: TObject; TriggerHandle : Word);
    procedure ApdComPort1TriggerTimer(CP: TObject; TriggerHandle: Word);
    procedure StartTestClick(Sender: TObject);
  private
    { Private declarations }
    TimerHandle : Word;
    Data1Handle  : Word;
    Data2Handle  : Word;
    Data3Handle  : Word;
  public
    { Public declarations }
  end;

var
  ExTrigTest: TExTrigTest;

implementation

{$R *.DFM}

procedure WriteIt(C : Char);
begin
  if Ord(C) > 32 then
    Write(C)
  else
    Write('[', Ord(C), ']');
end;

procedure TExTrigTest.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
var
  I : Word;
  C : Char;
begin
  WriteLn('OnTriggerAvail event: ', Count, ' bytes received');
  for I := 1 to Count do begin
    C := ApdComPort1.GetChar;
    WriteIt(C);
  end;
  WriteLn;
  WriteLn('--------');
end;

procedure TExTrigTest.ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
begin
  WriteLn('OnTriggerData event: ', TriggerHandle);
end;

procedure TExTrigTest.ApdComPort1TriggerTimer(CP: TObject;
  TriggerHandle: Word);
begin
  WriteLn('OnTriggerTimer event: ', TriggerHandle);
end;

procedure TExTrigTest.StartTestClick(Sender: TObject);
begin
  TimerHandle := ApdComPort1.AddTimerTrigger;
  ApdComPort1.SetTimerTrigger(TimerHandle, 91, True);
  Data1Handle := ApdComPort1.AddDataTrigger('TI', True);
  Data2handle := ApdComPort1.AddDataTrigger('OK', True);
  Data3handle := ApdComPort1.AddDataTrigger('288', True);

  {Send a string to a modem that will hit all triggers}
  ApdComPort1.PutString('ATI'^M);
end;

end.
