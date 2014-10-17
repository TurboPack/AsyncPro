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

unit Thread0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdPort, StdCtrls, OoMisc, ExtCtrls;

type
  TForm1 = class(TForm)
    btnToggle1: TButton;
    btnToggle2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    btnOpen1: TButton;
    btnOpen2: TButton;
    btnClose1: TButton;
    btnClose2: TButton;
    btnWasteTime: TButton;
    Label3: TLabel;
    Label4: TLabel;
    ApdComPort1: TApdComPort;
    ApdComPort2: TApdComPort;
    Label5: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    Memo1: TMemo;
    edtLoopCounter: TEdit;
    Label7: TLabel;
    procedure btnToggle1Click(Sender: TObject);
    procedure btnToggle2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnOpen1Click(Sender: TObject);
    procedure btnOpen2Click(Sender: TObject);
    procedure btnClose1Click(Sender: TObject);
    procedure btnClose2Click(Sender: TObject);
    procedure btnWasteTimeClick(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure ApdComPort2TriggerAvail(CP: TObject; Count: Word);
    procedure ApdComPort1TriggerOutbuffFree(Sender: TObject);
    procedure ApdComPort2TriggerOutbuffFree(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OpenPort1;
    procedure ClosePort1;
    procedure OpenPort2;
    procedure ClosePort2;
  end;

var
  Form1: TForm1;
  Sending1,Sending2 : Boolean;
  StartTime1,StartTime2 : Integer;
  Read1,Read2 : Integer;
  FreeTrig1,FreeTrig2 : Integer;

type
  TComThread1 = class(TThread)
    procedure Execute; override;
  end;
  TComThread2 = class(TThread)
    procedure Execute; override;
  end;

implementation

{$R *.DFM}

const
  am_stop = wm_user+1;


// Don't do anything that uses visual components from within these four routines.
// Even disabling a button can cause the VCL to hang.

procedure TForm1.OpenPort1;
begin
  ApdComPort1.Open := True;
  FreeTrig1 := ApdComPort1.AddStatusTrigger(stOutBuffFree);
  ApdComPort1.SetStatusTrigger(FreeTrig1,256,True);
  Sending1 := False;
  Read1 := 0;
end;

procedure TForm1.ClosePort1;
begin
  ApdComPort1.RemoveTrigger(FreeTrig1);
  ApdComPort1.Open := False;
end;

procedure TForm1.OpenPort2;
begin
  ApdComPort2.Open := True;
  FreeTrig2 := ApdComPort2.AddStatusTrigger(stOutBuffFree);
  ApdComPort2.SetStatusTrigger(FreeTrig2,256,True);
  Sending2 := False;
  Read2 := 0;
end;

procedure TForm1.ClosePort2;
begin
  ApdComPort2.RemoveTrigger(FreeTrig2);
  ApdComPort2.Open := False;
end;

// --

procedure TForm1.btnToggle1Click(Sender: TObject);
begin
  if not Sending1 then begin
    StartTime1 := GetTickCount;
    Sending1 := True;
  end else
    Sending1 := False;
  if Sending1 then
    btnToggle1.Caption := 'Stop sending'
  else
    btnToggle1.Caption := 'Start sending';
end;

procedure TForm1.btnToggle2Click(Sender: TObject);
begin
  if not Sending2 then begin
    StartTime2 := GetTickCount;
    Sending2 := True;
  end else
    Sending2 := False;
  if Sending2 then
    btnToggle2.Caption := 'Stop sending'
  else
    btnToggle2.Caption := 'Start sending';
end;

var
  Block1 : array[0..8191] of byte;
  Block2 : array[0..8191] of byte;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Label1.Caption := 'Bytes read:'+IntToStr(Read1);
  if Sending1 then
    Label3.Caption := 'Cps:'+FloatToStr(1000.0 * Read1 / (GetTickCount - StartTime1))
  else
    Label3.Caption := '';
  Label2.Caption := 'Bytes read:'+IntToStr(Read2);
  if Sending2 then
    Label4.Caption := 'Cps:'+FloatToStr(1000.0 * Read2 / (GetTickCount - StartTime2))
  else
    Label4.Caption := '';
end;

procedure TComThread1.Execute;
var
  Msg : TMsg;
begin
  Form1.OpenPort1;
  while not Terminated and GetMessage(Msg,0,0,0) and (Msg.Message <> am_Stop) do
    DispatchMessage(Msg);
  Form1.ClosePort1;
end;

procedure TComThread2.Execute;
var
  Msg : TMsg;
begin
  Form1.OpenPort2;
  while not Terminated and GetMessage(Msg,0,0,0) and (Msg.Message <> am_Stop) do
    DispatchMessage(Msg);
  Form1.ClosePort2;
end;

var
  Th1 : TComThread1;
  Th2 : TComThread2;

procedure TForm1.btnOpen1Click(Sender: TObject);
begin
  btnOpen1.Enabled := False;
  Th1 := TComThread1.Create(False);
  btnToggle1.Enabled := True;
  btnClose1.Enabled := True;
end;

procedure TForm1.btnOpen2Click(Sender: TObject);
begin
  btnOpen2.Enabled := False;
  Th2 := TComThread2.Create(False);
  btnToggle2.Enabled := True;
  btnClose2.Enabled := True;
end;

procedure TForm1.btnClose1Click(Sender: TObject);
begin
  btnClose1.Enabled := False;
  if Sending1 then
    btnToggle1Click(nil);
  PostMessage(ApdComPort1.ComWindow,am_stop,0,0);
  Th1.Terminate;
  Th1.Waitfor;
  Th1.Free;
  btnToggle1.Enabled := False;
  btnOpen1.Enabled := True;
end;

procedure TForm1.btnClose2Click(Sender: TObject);
begin
  btnClose2.Enabled := False;
  if Sending2 then
    btnToggle2Click(nil);
  PostMessage(ApdComPort2.ComWindow,am_stop,0,0);
  Th2.Terminate;
  Th2.Waitfor;
  Th2.Free;
  btnToggle2.Enabled := False;
  btnOpen2.Enabled := True;
end;

procedure TForm1.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
begin
  inc(Read1,Count);
  ApdComPort1.GetBlock(Block1,Count);
end;

procedure TForm1.ApdComPort2TriggerAvail(CP: TObject; Count: Word);
begin
  inc(Read2,Count);
  ApdComPort2.GetBlock(Block2,Count);
end;

procedure TForm1.ApdComPort1TriggerOutbuffFree(Sender: TObject);
var
  s : string[255];
  i : Integer;
begin
  if Sending1 then begin
    Setlength(S,255);
    for i := 1 to 255 do
      s[i] := chr(i mod 32 + 33);
    ApdComPort1.Output := s;
  end;
  ApdComPort1.SetStatusTrigger(FreeTrig1,256,True);
end;

procedure TForm1.ApdComPort2TriggerOutbuffFree(Sender: TObject);
var
  s : string[255];
  i : Integer;
begin
  if Sending2 then begin
    Setlength(S,255);
    for i := 1 to 255 do
      s[i] := chr(i mod 32 + 33);
    ApdComPort2.Output := s;
  end;
  ApdComPort2.SetStatusTrigger(FreeTrig2,256,True);
end;

var
 a,b : integer;

procedure TForm1.btnWasteTimeClick(Sender: TObject);
var
  i : integer;
begin
  btnWasteTime.Enabled := False;
  btnWasteTime.Update;
  for i := 1 to StrToInt(edtLoopCounter.Text) do
    a := b;
  btnWasteTime.Enabled := True;
end;

end.
