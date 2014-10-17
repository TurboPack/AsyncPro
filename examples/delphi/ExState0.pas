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
{*                   EXSTATE0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to use the TApdStateMachine and the  *)
(*   TApdState components.  This state machine will      *)
(*   initialize the modem, enable CallerID detection,    *)
(*   then wait for incoming calls.  If the modem detects *)
(*   the Caller ID tags, those will be picked up also.   *)
{*********************************************************}

unit ExState0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, OoMisc, AdStMach, AdPort, StdCtrls;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdStateMachine1: TApdStateMachine;
    ApdState1: TApdState;
    ApdState3: TApdState;
    ApdState4: TApdState;
    Button1: TButton;
    ApdState2: TApdState;
    procedure ApdState3StateFinish(State: TApdCustomState;
      Condition: TApdStateCondition; var NextState: TApdCustomState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CIDDate : string;
    CIDNumber : string;
    CIDName : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ApdState3StateFinish(State: TApdCustomState;
  Condition: TApdStateCondition; var NextState: TApdCustomState);
begin
  { decide what to do when we receive "RING"s }
  if Condition.StartString = 'RING' then begin
  { it's our RING condition }
    State.Tag := State.Tag + 1;
  if State.Tag > 1 then
    { we've seen at least 2 rings, progress to the next state }
    NextState := ApdState4
  else
    { we've seen less than 2 rings, wait for more }
    NextState := ApdState3;
  end else if Condition.StartString = 'DATE:' then
    { it's our Date CID tag }
    CIDDate := ApdStateMachine1.DataString
  else if Condition.StartString = 'NMBR:' then
    { it's our Number CID tag }
    CIDNumber := ApdStateMachine1.DataString
  else if Condition.StartString = 'NAME:' then
    { it's our Name CID tag }
    CIDName := ApdStateMachine1.DataString;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ApdStateMachine1.Start;
end;

end.
