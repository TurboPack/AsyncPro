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
{*                   EXADAPT0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to perform adaptive answering.       *}
{*       Distinguishing an incoming data call            *}
{*         from an incoming fax call.                    *}
{*********************************************************}

unit Exadapt0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdPort, AdFax, StdCtrls, AdFStat, OoMisc, ADTrmEmu;

type
  TForm1 = class(TForm)
    ApdReceiveFax1: TApdReceiveFax;
    ApdComPort1: TApdComPort;
    Button1: TButton;
    Button2: TButton;
    ApdFaxStatus1: TApdFaxStatus;
    ApdFaxLog1: TApdFaxLog;
    AdTerminal1: TAdTerminal;
    procedure ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
    procedure Button1Click(Sender: TObject);
    procedure ApdComPort1TriggerTimer(CP: TObject; TriggerHandle: Word);
    procedure Button2Click(Sender: TObject);
    procedure ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
  private
    { Private declarations }
    dthRing      : Word;  {data trigger handle for 'RING'}
    dthConnect   : Word;  {data trigger handle for 'CONNECT'}
    dthVoice     : Word;  {data trigger handle for 'VOICE'}
    dthFax       : Word;  {data trigger handle for 'FAX'}
    dthCED       : Word;  {data trigger handle for 'CED' (fax)}
    dthPlusFCON  : Word;  {data trigger handle for '+FCON' (fax)}
    ttTimeout    : Word;  {timer trigger for connect timeout}

    procedure RemoveMyTrigger(var th : Word);
    procedure RemoveAllMyTriggers;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  CaseInsensitive         = True;

procedure TForm1.RemoveMyTrigger(var th : Word);
  {Remove trigger if <> 0 and set th to 0}
begin
  if th <> 0 then begin
    ApdComPort1.RemoveTrigger(th);
    th := 0;
  end;
end;

procedure TForm1.RemoveAllMyTriggers;
  {Remove any of my triggers and set handles to 0}
begin
  RemoveMyTrigger(dthRing);
  RemoveMyTrigger(dthConnect);
  RemoveMyTrigger(dthVoice);
  RemoveMyTrigger(dthFax);
  RemoveMyTrigger(dthCED);
  RemoveMyTrigger(dthPlusFCON);
  RemoveMyTrigger(ttTimeout);
end;

procedure TForm1.ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
begin
  if (TriggerHandle = dthRing) then begin
    {Remove the 'RING' trigger}
    RemoveMyTrigger(dthRing);
    dthRing := 0;
    {Answer call}
    ApdComPort1.PutString('ATA'#13);
    {Add triggers for possible connect messages}
    dthConnect := ApdComPort1.AddDataTrigger('CONNECT', CaseInsensitive);
    dthVoice   := ApdComPort1.AddDataTrigger('VOICE', CaseInsensitive);
    dthFax     := ApdComPort1.AddDataTrigger('FAX', CaseInsensitive);
    dthCED     := ApdComPort1.AddDataTrigger('CED', CaseInsensitive);
    dthPlusFCON:= ApdComPort1.AddDataTrigger('+FCO', CaseInsensitive);
    {Add a timer trigger to wait for connect messages}
    ttTimeout := ApdComPort1.AddTimerTrigger;
    ApdComPort1.SetTimerTrigger(ttTimeout, 19*60 {60 seconds}, True);
  end else if (TriggerHandle = dthConnect) then begin
    RemoveAllMyTriggers;
    AdTerminal1.WriteString(#10#13'<< Answered data call >>'#10#13);
  end else if (TriggerHandle = dthVoice) then begin
    RemoveAllMyTriggers;
    MessageDlg('Answered voice call', mtInformation, [mbOK], 0);
  end else if (TriggerHandle = dthFax) or
              (TriggerHandle = dthCED) or
              (TriggerHandle = dthPlusFCON) then begin
    RemoveAllMyTriggers;
    AdTerminal1.WriteString(#10#13'<< Receiving fax... >>'#13);
    AdTerminal1.Active := False;
    ApdReceiveFax1.PrepareConnectInProgress;
    ApdReceiveFax1.StartReceive;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
  {Wait For Connect}
begin
  Button1.Enabled := False;
  {Remove triggers from any previous attempts}
  RemoveAllMyTriggers;
  {Pre-initialize for fax receive}
  ApdReceiveFax1.InitModemForFaxReceive;
  {Add a data trigger for 'RING'}
  dthRing := ApdComPort1.AddDataTrigger('RING', CaseInsensitive);
  AdTerminal1.WriteString(#10#13'<< Waiting for call >>'#10#13);
end;

procedure TForm1.ApdComPort1TriggerTimer(CP: TObject; TriggerHandle: Word);
   {Event handler when timer expires}
begin
  if (TriggerHandle = ttTimeout) then begin
    RemoveAllMyTriggers;
    MessageDlg('Timeout waiting for connect string', mtWarning, [mbOK], 0);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
  {Exit Program}
begin
  ApdComPort1.DTR := False;
  Form1.Close;
end;

procedure TForm1.ApdReceiveFax1FaxFinish(CP: TObject; ErrorCode: Integer);
  {Event OnFaxFinish from ApdReceiveFax1 device}
begin
  Button1.Enabled := True;
  AdTerminal1.Active := True;
  AdTerminal1.WriteString('                               '#10#13);
end;

end.
