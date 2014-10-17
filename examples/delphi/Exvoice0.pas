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
{*                   EXVOICE0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{*Demonstrates receiving and interpreting DTMF tones     *}
{*    using TAPI.                                        *}
{*********************************************************}

unit ExVoice0;

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
  ExtCtrls,
  StdCtrls,
  Buttons,
  AdPort,
  AdTapi,
  AdTStat,
  AdTUtil, OoMisc;

type
  TForm1 = class(TForm)
    CallerID: TEdit;
    Label1: TLabel;
    CallerIDName: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Panel1: TPanel;
    Label3: TLabel;
    ApdComPort1: TApdComPort;
    AnswerButton: TButton;
    CancelCall: TButton;
    Pad1: TSpeedButton;
    Pad2: TSpeedButton;
    Pad3: TSpeedButton;
    Pad4: TSpeedButton;
    Pad5: TSpeedButton;
    Pad6: TSpeedButton;
    PadAsterisk: TSpeedButton;
    Pad0: TSpeedButton;
    PadPound: TSpeedButton;
    Pad7: TSpeedButton;
    Pad8: TSpeedButton;
    Pad9: TSpeedButton;
    ApdTapiDevice1: TApdTapiDevice;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure AnswerButtonClick(Sender: TObject);
    procedure CancelCallClick(Sender: TObject);
    procedure ApdTapiDevice1TapiConnect(Sender: TObject);
    procedure ApdTapiDevice1TapiCallerID(CP: TObject; ID, IDName: string);
    procedure Timer1Timer(Sender: TObject);
    procedure ApdTapiDevice1TapiDTMF(CP: TObject; Digit: Char;
      ErrorCode: Longint);
    procedure FormCreate(Sender: TObject);
    procedure ApdTapiDevice1TapiWaveNotify(CP: TObject; Msg: TWaveMessage);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  CurrentState : Integer = 0;
  StateGreeting          = 0;
  StateMenu              = 1;
  StatePlayingWav        = 2;
  StateEndCall           = 3;

var
  Form1: TForm1;
  LastDigit: Char;
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
  if ApdTapiDevice1.EnableVoice then
    ApdTapiDevice1.AutoAnswer
  else
    MessageDlg('The Selected device does not support Voice Extensions.', mtInformation, [mbOk], 0);
end;

procedure TForm1.CancelCallClick(Sender: TObject);
begin
  ApdTapiDevice1.CancelCall;
  CallerId.Text := '';
  CallerIdName.Text := '';
  Timer1.Enabled := True;
end;

procedure TForm1.ApdTapiDevice1TapiConnect(Sender: TObject);
begin
  CancelCall.Enabled := True;
  CurrentState := StateGreeting;
  {Play Greeting}
  Label4.Caption := 'Playing Greeting';
  ApdTapiDevice1.PlayWaveFile(WaveFileDir+'greeting.wav');
end;

procedure TForm1.ApdTapiDevice1TapiCallerID(CP: TObject; ID,
  IDName: string);
begin
  CallerId.Text := ID;
  CallerIdName.Text := IDName;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Pad9.Down := False;
  PadPound.Down := False;
  try
    ApdTapiDevice1.AutoAnswer;
    Timer1.Enabled := False;
  except

  end;
end;

procedure TForm1.ApdTapiDevice1TapiDTMF(CP: TObject; Digit: Char;
  ErrorCode: Longint);
var
  S: String;
begin
  LastDigit := Digit;
  if (Digit = '') or (Digit = ' ') then Exit;
  if Digit = '*' then
    PadAsterisk.Down := True
  else if Digit = '#' then
    PadPound.Down := True
  else
    TSpeedButton(FindComponent('Pad'+Digit)).Down := True;

  {Simple DTMF State Machine}
  case CurrentState of
    StateMenu:
      begin
        case Digit of
          '0'..'8': S := WaveFileDir+'choice'+Digit+'.wav';
          '9':
            begin
              ApdTapiDevice1.InterruptWave := False;
              S := WaveFileDir+'choice9.wav';
              CurrentState := StateEndCall;
            end;
          '*':
            begin
              S := WaveFileDir+'Greeting.wav';
              CurrentState := StateGreeting;
            end;
          '#':
            begin
              ApdTapiDevice1.InterruptWave := False;
              S := WaveFileDir+'Goodbye.wav';
              CurrentState := StateEndCall;
            end;
        end;
      end;
    StateGreeting: begin
      S := WaveFileDir+'menu.wav';
      CurrentState := StateMenu;
    end;
  end;
  if S <> '' then begin
    Label4.Caption := 'Playing Wave File: '+ S;
    ApdTapiDevice1.PlayWaveFile(S);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  WaveFileDir := ExtractFilePath(ParamStr(0));
  WaveFileDir := Copy(WaveFileDir, 1, Pos('EXAMPLES',UpperCase(WaveFileDir))+8);
end;

procedure TForm1.ApdTapiDevice1TapiWaveNotify(CP: TObject;
  Msg: TWaveMessage);
begin
  if Msg = waPlayDone then
    Label4.Caption := 'Wave Device Idle...';
  if CurrentState = StateEndCall then
    if (Msg = waPlayDone) then
      CancelCallClick(Self);
end;

end.
