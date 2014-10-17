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

{**********************************************************}
{*                      EXAUTO0.PAS                       *}
{**********************************************************}

{**********************Description*************************}
{*  Dials another computer that is also running ExAuto    *}
{*     and can transmit or receive a file.                *}
{**********************************************************}

unit Exauto0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, OoMisc, AdPort, StdCtrls, AdPacket, AdProtcl,
  AdExcept, ADTrmEmu, AdMdm;

type
  TMyState = (msIdle, msInit, msConnect, msLogon, msXFer1, msXFer2, msQuit);
  TForm1 = class(TForm)
    btnDial: TButton;
    btnAnswer: TButton;
    Edit1: TEdit;
    btnCancel: TButton;
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    ApdDataPacket1: TApdDataPacket;
    AdTerminal1: TAdTerminal;
    AdModem1: TAdModem;
    procedure btnDialClick(Sender: TObject);
    procedure btnAnswerClick(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure btnCancelClick(Sender: TObject);
    procedure ApdProtocol1ProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure ApdProtocol1ProtocolStatus(CP: TObject; Options: Word);
    procedure ApdDataPacket1Packet(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure ApdComPort1TriggerModemStatus(Sender: TObject);
    procedure AdModem1ModemConnect(Modem: TAdCustomModem);
  private
    { Private declarations }
  public
    { Public declarations }
    MyState : TMyState;
    IsClient : Boolean;
    DCDTrig : Word;
    ClientPassword : String;
    procedure CheckModem;
    procedure WriteTerm(S : String);
    procedure CheckPassword;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  Password = 'asyncprofessional';

(*
 This example will automatically logon and send/receive a file. If the Dial
 button was pressed, this will be the Client. If the Answer button was pressed
 this will be the Host. The Client logs in using the Password constant and the
 Host verifies the password. if everything checks out, the Client sends the
 file first, once that transfer is complete, the Host sends its file.

 The transfers are kept in sync by having the sender delay 1 second before
 sending, which gives the receiver enough time to prepare to receive.

 Host specific statements are preceded by { HOST }
 Client specific statements are preceded by { CLIENT }
*)

procedure TForm1.CheckModem;
begin
  if not AdModem1.DeviceSelected then begin
    { since we're running in the apro\examples\delphi folder, modemcap should
      be in the apro\modemcap folder }
    AdModem1.ModemCapFolder := '..\..\modemcap';
    AdModem1.SelectDevice;
  end;
end;

procedure TForm1.btnDialClick(Sender: TObject);
begin
  { CLIENT }
  { Set states and dial the modem }
  CheckModem;
  MyState := msInit;
  IsClient := True;
  btnDial.Enabled := False;
  btnAnswer.Enabled := False;
  btnCancel.Enabled := True;
  AdModem1.Dial(Edit1.Text);
end;

procedure TForm1.btnAnswerClick(Sender: TObject);
begin
  { HOST }
  { Set states and wait for the call }
  CheckModem;
  MyState := msInit;
  IsClient := False;
  btnDial.Enabled := False;
  btnAnswer.Enabled := False;
  btnCancel.Enabled := True;
  AdModem1.AutoAnswer;
end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
  { Cancel/Hangup }
  AdModem1.CancelCall;
  MyState := msIdle;
  btnDial.Enabled := True;
  btnAnswer.Enabled := True;
  btnCancel.Enabled := False;
end;

procedure TForm1.WriteTerm(S : String);
begin
  { Adds CR/LF to beginning and end of status messages sent to the terminal }
  AdTerminal1.WriteString(#13#10 + S + #13#10);
end;

procedure TForm1.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
var
  I : Word;
  C : AnsiChar;
begin
  For I := 1 to Count do begin
    C := ApdComPort1.GetChar;
    { build password if we are the host }
    if (MyState = msLogon) and not(IsClient) then
      { HOST }
      if C = #13 then
        { Got #13, so this is the end of the password }
        CheckPassword
      else
        ClientPassword := ClientPassword + C;
  end;
end;

procedure TForm1.CheckPassword;
begin
  { HOST }
  if ClientPassword = Password then begin
    { Valid password, set state and start receiving the transfer }
    ApdComPort1.Output := 'Access Authorized';
    MyState := msXFer1;
    WriteTerm('Starting receive');
    AdTerminal1.Active := False;
    ApdProtocol1.StartReceive;
  end else begin
    { Invalid password, show message and disconnect }
    ApdComPort1.Output := 'Access Denied';
    { click the button asynchronously }
    PostMessage(btnCancel.Handle, BM_CLICK, 0, 0);
  end;
end;

procedure TForm1.ApdProtocol1ProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
  if MyState = msXFer2 then begin
    { The 2nd transfer completed, show message, set state and disconnect }
    WriteTerm('Transfers complete: ' + ErrorMsg(ErrorCode));
    WriteTerm('Disconnecting...');
    AdTerminal1.Active := True;
    MyState := msQuit;
    { click the button asynchronously }
    PostMessage(btnCancel.Handle, BM_CLICK, 0, 0);
    Exit;
  end;
  { Set state, show transfer completion status }
  MyState := msXFer2;
  WriteTerm('Transfer complete: ' + ErrorMsg(ErrorCode));
  { Flip-flop the transfer, if we were just sending, now we are receiving }
  if IsClient then begin
    WriteTerm('Receiving file');
    ApdProtocol1.StartReceive;
  end else begin
    WriteTerm('Pausing for sync');
    DelayTicks(18, True);
    WriteTerm('Sending file');
    ApdProtocol1.StartTransmit;
  end;
end;

procedure TForm1.ApdProtocol1ProtocolStatus(CP: TObject; Options: Word);
begin
  { Displays a '.' whenever event fires to let user know something is happening }
  if Options = apFirstCall then
    AdTerminal1.WriteString(#13#10);
  AdTerminal1.WriteChar('.');
  if Options = apLastCall then
    { if the transfer is complete, insert a CR/LF }
    AdTerminal1.WriteString(#13#10);
end;

procedure TForm1.ApdDataPacket1Packet(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  { CLIENT }
  { The password prompt was received, send the password followed by a CR }
  ApdComPort1.Output := Password + #13;
  { Set the proper state and send the file }
  MyState := msXFer1;
  WriteTerm('Pausing for sync');
  DelayTicks(18, True);
  WriteTerm('Sending file');
  AdTerminal1.Active := False;
  ApdProtocol1.StartTransmit;
end;

procedure TForm1.ApdComPort1TriggerModemStatus(Sender: TObject);
begin
  { The DCDTrig fired for a change in DCD }
  if ApdComPort1.DCD then begin
    {if we are still connected, re-set the trigger and exit }
    ApdComPort1.SetStatusTrigger(DCDTrig, msDCDDelta, True);
  end else begin
    { We have lost DCD, reset buttons }
    MyState := msIdle;
    ApdComPort1.SetStatusTrigger(DCDTrig, msDCDDelta, True);
    WriteTerm('Disconnected');
    btnDial.Enabled := True;
    btnAnswer.Enabled := True;
    btnCancel.Enabled := False;
  end;
end;

procedure TForm1.AdModem1ModemConnect(Modem: TAdCustomModem);
begin
  { Set up Status Trigger for carrier loss }
  DCDTrig := ApdComPort1.AddStatusTrigger(stModem);
  ApdComPort1.SetStatusTrigger(DCDTrig, msDCDDelta, True);

  { Set state, show welcome and password prompt if this is the host }
  MyState := msLogon;
  if not(IsClient) then begin
    { HOST }
    ClientPassword := '';
    ApdComPort1.Output := 'Welcome to the ExAuto Host'+#13#10;
    ApdComPort1.Output := 'Enter Password:';
  end;
end;

end.
