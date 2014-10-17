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
{*                   EXANSWE0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* TAdModem waits for the phone to ring twice            *}
{*     and answers the modem.                            *}
{*********************************************************}

unit Exanswe0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdPort, StdCtrls, Buttons, OoMisc, AdMdm;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    ApdComPort1: TApdComPort;
    AdModem1: TAdModem;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure AdModem1ModemCallerID(Modem: TAdCustomModem;
      CallerID: TApdCallerIDInfo);
    procedure AdModem1ModemConnect(Modem: TAdCustomModem);
    procedure AdModem1ModemDisconnect(Modem: TAdCustomModem);
    procedure AdModem1ModemFail(Modem: TAdCustomModem; FailCode: Integer);
    procedure AdModem1ModemLog(Modem: TAdCustomModem;
      LogCode: TApdModemLogCode);
    procedure AdModem1ModemStatus(Modem: TAdCustomModem;
      ModemState: TApdModemState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddStatus(const Msg : String);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.AddStatus(const Msg : String);
begin
  Listbox1.Items.Add(Msg);
  Listbox1.ItemIndex := Pred(Listbox1.Items.Count);
end;

procedure TForm1.FormCreate(Sender: TObject);
  {Event OnCreate from TForm1}
begin
  ApdComPort1.Open := True;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
  {Begin answering in two rings}
begin
  AdModem1.AnswerOnRing := 2;
  AdModem1.AutoAnswer;
end;

procedure TForm1.AdModem1ModemCallerID(Modem: TAdCustomModem;
  CallerID: TApdCallerIDInfo);
  { we received caller id information }
begin
  AddStatus('CallerID Name: ' + CallerID.Name);
  AddStatus('CallerID Number: ' + CallerID.Number);
end;

procedure TForm1.AdModem1ModemConnect(Modem: TAdCustomModem);
  { we are connected }
begin
  AddStatus('Connected!');
end;

procedure TForm1.AdModem1ModemDisconnect(Modem: TAdCustomModem);
  { we have been disconnected }
begin
  AddStatus('Disconnected');
end;

procedure TForm1.AdModem1ModemFail(Modem: TAdCustomModem;
  FailCode: Integer);
begin
  AddStatus('Failed: ' + Modem.FailureCodeMsg(FailCode));
end;

procedure TForm1.AdModem1ModemLog(Modem: TAdCustomModem;
  LogCode: TApdModemLogCode);
begin
  AddStatus('Log event: ' + Modem.ModemLogToString(LogCode));
end;

procedure TForm1.AdModem1ModemStatus(Modem: TAdCustomModem;
  ModemState: TApdModemState);
begin
  AddStatus('Status event: ' + Modem.ModemStatusMsg(ModemState));
end;

end.

