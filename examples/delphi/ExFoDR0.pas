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

{***********************************************************}
{*                     EXFODR0.PAS                         *}
{***********************************************************}

{**********************Description**************************}
{*Shows an example of receiving fax on demand changing from*}
{*      voice to data modem using                          *}
{*      ApdTapiDevice1.AutomatedVoiceToComms.              *}
{*Note: Does not work for Windows 2000 because you can not *}
{*      switch media modes on an active call.              *}
{***********************************************************}

unit ExFoDR0;

interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  ExtCtrls,
  Forms,
  Dialogs,
  AdFax,
  AdFStat,
  AdTapi,
  AdPort,
  AdTUtil,
  OOMisc;

type
  TForm1 = class(TForm)
    ApdTapiDevice1: TApdTapiDevice;
    ApdFaxStatus1: TApdFaxStatus;
    ApdComPort1: TApdComPort;
    Button1: TButton;
    AnswerButton: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    ApdReceiveFax1: TApdReceiveFax;
    procedure Button1Click(Sender: TObject);
    procedure AnswerButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApdTapiDevice1TapiDTMF(CP: TObject; Digit: Char;
      ErrorCode: Longint);
    procedure ApdTapiDevice1TapiConnect(Sender: TObject);
    procedure ApdTapiDevice1TapiWaveNotify(CP: TObject; Msg: TWaveMessage);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  CurrentState: Integer = 0;
  StateIdle             = 0;
  StateGreeting         = 1;
  StateReceiveFax       = 2;
  StateEndCall          = 3;

var
  Form1: TForm1;
  WaveFileDir: String;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ApdTapiDevice1.SelectDevice;
  ApdTapiDevice1.EnableVoice := True;
end;

procedure TForm1.AnswerButtonClick(Sender: TObject);
begin
  if not ApdTapiDevice1.EnableVoice then
    ApdTapiDevice1.EnableVoice := True;
  if ApdTapiDevice1.EnableVoice then begin
    ApdTapiDevice1.AutoAnswer;
  end else
    MessageDlg('The Selected device does not support Voice Extensions.', mtInformation, [mbOk], 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  WaveFileDir := ExtractFilePath(ParamStr(0));
  WaveFileDir := Copy(WaveFileDir, 1, Pos('EXAMPLES',UpperCase(WaveFileDir))+8);
end;

procedure TForm1.ApdTapiDevice1TapiDTMF(CP: TObject; Digit: Char;
  ErrorCode: Longint);
begin
  case CurrentState of
    StateGreeting :
      begin
        case Digit of
          '*':
            begin
              ApdTapiDevice1.InterruptWave := False;
              ApdTapiDevice1.PlayWaveFile(WaveFileDir+'goodbye.wav');
              CurrentState := StateEndCall;
            end;
          '#':
            begin
              CurrentState := StateReceiveFax;
              ApdTapiDevice1.PlayWaveFile(WaveFileDir+'fsndprmt.wav');
              while ApdTapiDevice1.WaveState = wsPlaying do
                Application.ProcessMessages;
              ApdTapiDevice1.AutomatedVoiceToComms;
              ApdReceiveFax1.StartManualReceive(True);
            end;
          '0':
            begin
              ApdTapiDevice1.PlayWaveFile(WaveFileDir+'fsndwelc.wav');
            end;
        end;
      end;
  end;
end;

procedure TForm1.ApdTapiDevice1TapiConnect(Sender: TObject);
begin
  {Play Greeting}
  CurrentState := StateGreeting;
  ApdTapiDevice1.PlayWaveFile(WaveFileDir+'fsndwelc.wav');
end;

procedure TForm1.ApdTapiDevice1TapiWaveNotify(CP: TObject;
  Msg: TWaveMessage);
begin
  case CurrentState of
    StateIdle        : Edit1.Text := 'StateIdle';
    StateGreeting    : Edit1.Text := 'StateGreeting';
    StateReceiveFax  : Edit1.Text := 'StateReceiveFax';
    StateEndCall     : Edit1.Text := 'StateEndCall';
  end;

  if Msg = waPlayOpen then
    Edit2.Text := 'Playing Wave: '+ExtractFileName(ApdTapiDevice1.WaveFileName)
  else if Msg = waPlayDone then
    Edit2.Text := 'Wave Device Idle...';

  case CurrentState of
    StateEndCall:
      begin
        Edit1.Text := 'StateEndCall';
        if Msg = waPlayDone then begin
          ApdTapiDevice1.CancelCall;
        end;
      end;
  end;
end;

end.
