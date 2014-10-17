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
{*                   EXFAXOD0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{*       Shows how to use the Fax On Demand.             *}
{*********************************************************}

unit ExFaxOD0;

interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  AdFax,
  AdFStat,
  AdTapi,
  AdPort,
  AdTUtil,
  ExtCtrls,
  OoMisc;

type
  TForm1 = class(TForm)
    ApdTapiDevice1: TApdTapiDevice;
    ApdSendFax1: TApdSendFax;
    ApdFaxStatus1: TApdFaxStatus;
    ApdComPort1: TApdComPort;
    Button1: TButton;
    AnswerButton: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure AnswerButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApdTapiDevice1TapiDTMF(CP: TObject; Digit: Char;
      ErrorCode: Longint);
    procedure ApdTapiDevice1TapiConnect(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
    procedure ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
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
  StateEndCall          = 2;
  StateGettingNumber    = 3;
  StatePlayBack         = 4;
  StateWaitReply        = 5;

var
  Form1: TForm1;
  WaveFileDir: String;
  SendTheFax: Boolean;

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
  SendTheFax := False;
  WaveFileDir := ExtractFilePath(ParamStr(0));
  WaveFileDir := Copy(WaveFileDir, 1, Pos('EXAMPLES',UpperCase(WaveFileDir))+8);
  ApdSendFax1.FaxFile := WaveFileDir+'aprologo.apf';
  if (FileGetAttr(ApdSendFax1.FaxFile) and faReadOnly) > 0 then begin
    MessageDlg('The AProLogo.APF fax file is designated Read-Only and may not be used in this ' +
      ' example until this attribute is changed to Read/Write.', mtInformation, [mbOK], 0);
    Halt;
  end;
end;

procedure TForm1.ApdTapiDevice1TapiDTMF(CP: TObject; Digit: Char;
  ErrorCode: Longint);
var
  i: Integer;
begin
  case CurrentState of
    StateIdle :
      begin
        Edit1.Text := 'StateIdle';
      end;
    StateGreeting :
      begin
      Edit1.Text := 'StateGreeting';
        case Digit of
          '5':
            begin
              CurrentState := StateGettingNumber;
              ApdTapiDevice1.PlayWaveFile(WaveFileDir+'enter.wav');
            end;
          '*':
            begin
              CurrentState := StateEndCall;
              ApdTapiDevice1.InterruptWave := False;
              ApdTapiDevice1.PlayWaveFile(WaveFileDir+'goodbye.wav');
            end;
        else
          begin
            ApdTapiDevice1.PlayWaveFile(WaveFileDir+'Play'+Digit+'.wav');
            while ApdTapiDevice1.WaveState = wsPlaying do
              Application.ProcessMessages;
            ApdTapiDevice1.PlayWaveFile(WaveFileDir+'invalid.wav');
          end;
        end;
      end;
    StateEndCall :
      begin
        {nothing to do here...}
      end;
    StateGettingNumber :
      begin
        Edit1.Text := 'StateGettingNumber';
        case Digit of
          '*':
            begin
              Edit3.Text := '';
              ApdTapiDevice1TapiConnect(Self);
            end;
          '#':
            begin
              if Edit3.Text = '' then
                ApdTapiDevice1TapiConnect(Self)
              else begin
                CurrentState := StatePlayBack;
                ApdTapiDevice1.PlayWaveFile(WaveFileDir+'uentered.wav');
                for i := 1 to Length(Edit3.Text) do begin
                  while ApdTapiDevice1.WaveState = wsPlaying do
                    Application.ProcessMessages;
                  ApdTapiDevice1.PlayWaveFile(WaveFileDir+'play'+Copy(Edit3.Text, i, 1)+'.wav');
                end;
                while ApdTapiDevice1.WaveState = wsPlaying do
                  Application.ProcessMessages;
                CurrentState := StateWaitReply;
                ApdTapiDevice1.PlayWaveFile(WaveFileDir+'correct.wav');
              end;
            end;
        else
          begin
            Edit3.Text := Edit3.Text+Digit;
          end;
        end;
      end;
    StateWaitReply :
      begin
        Edit1.Text := 'StateWaitReply';
        case Digit of
          '*':
            begin
              Edit3.Text := '';
              CurrentState := StateGettingNumber;
              ApdTapiDevice1.PlayWaveFile(WaveFileDir+'enter.wav');
            end;
          '#':
            begin
              {wait for previous message to conclude
               then play final message}
              while ApdTapiDevice1.WaveState = wsPlaying do
                Application.ProcessMessages;
              SendTheFax := True;
              ApdTapiDevice1.InterruptWave := False;
              ApdTapiDevice1.PlayWaveFile(WaveFileDir+'hangup.wav');
              CurrentState := StateEndCall;
            end;
        end;
      end;
  end;
end;

procedure TForm1.ApdTapiDevice1TapiConnect(Sender: TObject);
begin
  {Play Greeting}
  if ApdTapiDevice1.EnableVoice then begin
    CurrentState := StateGreeting;
    ApdTapiDevice1.PlayWaveFile(WaveFileDir+'welcome.wav');
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  {Send the Fax}
  ApdTapiDevice1.EnableVoice := False;
  ApdSendFax1.PhoneNumber := Edit3.Text;
  ApdTapiDevice1.ConfigAndOpen;
end;

procedure TForm1.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  if (SendTheFax) and (not ApdTapiDevice1.EnableVoice) then
    ApdSendFax1.StartTransmit;
end;

procedure TForm1.ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
begin
  if ErrorCode = 0 then
    ShowMessage('Fax sent successfully');
  CurrentState := StateIdle;
end;

procedure TForm1.ApdTapiDevice1TapiWaveNotify(CP: TObject;
  Msg: TWaveMessage);
begin
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
          if SendTheFax then
            Timer1.Enabled := True;
        end;
      end;
  end;
end;

end.
