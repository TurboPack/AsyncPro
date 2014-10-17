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
{*                   EXRECRD0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to record incoming calls using Tapi. *}
{*********************************************************}

unit ExRecrd0;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Menus,
  AdTapi,
  AdPort, OoMisc;

const
  CurrentState : Integer = 0;
  StateGreeting          = 0;
  StateRecording         = 1;
  StateIdle              = 2;
  StateBeeping           = 3;
  StatePlayback          = 4;
type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    CallerID: TEdit;
    CallerIDName: TEdit;
    Button1: TButton;
    AnswerButton: TButton;
    CancelCall: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    ApdComPort1: TApdComPort;
    ApdTapiDevice1: TApdTapiDevice;
    Label5: TLabel;
    MaxLengthEdit: TEdit;
    Label3: TLabel;
    CallsListBox: TListBox;
    PopupMenu1: TPopupMenu;
    Play1: TMenuItem;
    Delete1: TMenuItem;
    Monitor: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AnswerButtonClick(Sender: TObject);
    procedure CancelCallClick(Sender: TObject);
    procedure ApdTapiDevice1TapiConnect(Sender: TObject);
    procedure ApdTapiDevice1TapiWaveNotify(CP: TObject; Msg: TWaveMessage);
    procedure CallsListBoxDblClick(Sender: TObject);
    procedure ApdTapiDevice1TapiCallerID(CP: TObject; ID, IDName: String);
    procedure MaxLengthEditExit(Sender: TObject);
    procedure CallsListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Delete1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure MonitorClick(Sender: TObject);
  private
    { Private declarations }
    WaveFileDir : String;
    CallCount   : Integer;
    procedure PlayBackMessage;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  WaveFileDir := ExtractFilePath(ParamStr(0));
  WaveFileDir := Copy(WaveFileDir, 1, Pos('EXAMPLES',UpperCase(WaveFileDir))+8);
  CallCount   := 0;
  ApdTapiDevice1.MonitorRecording := Monitor.Checked;
end;

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
end;

procedure TForm1.ApdTapiDevice1TapiConnect(Sender: TObject);
begin
  CancelCall.Enabled := True;
  CurrentState := StateGreeting;
  {Play Greeting}
  Label4.Caption := 'Playing Greeting';
  ApdTapiDevice1.PlayWaveFile(WaveFileDir+'RecGreet.wav');
end;

procedure TForm1.ApdTapiDevice1TapiWaveNotify(CP: TObject;
  Msg: TWaveMessage);
var
  FileName : String;
  S        : String;
  Size     : TSize;
  Temp     : array[0..255] of Char;
begin
  case Msg of
    waDataReady :
      begin
        Inc(CallCount);
        FileName := Format('%sCall%d.wav', [WaveFileDir, CallCount]);
        ApdTapiDevice1.SaveWaveFile(FileName, True);
      end;
    waRecordClose :
      begin
        S := Format('%d. From: %s (%s) at %s', [CallCount,
          CallerIdName.Text, CallerId.Text, DateTimeToStr(Now)]);
        CallsListBox.Items.AddObject(S, TObject(CallCount));
        GetTextExtentPoint(
          CallsListBox.Handle, StrPCopy(Temp, S), Length(S), Size);
        if (Size.cx > CallsListBox.Width) then
          PostMessage(CallsListBox.Handle,
            LB_SETHORIZONTALEXTENT, Size.cx, 0);
        ApdTapiDevice1.CancelCall;
        while ApdTapiDevice1.TapiState <> tsIdle do
          Application.ProcessMessages;
        ApdTapiDevice1.AutoAnswer;
        CurrentState := StateIdle;
        Label4.Caption := 'Waiting for Call';
      end;
    waPlayClose :
      case CurrentState of
        StateGreeting :
          begin
            CurrentState := StateBeeping;
            ApdTapiDevice1.PlayWaveFile(WaveFileDir+'beep.wav');
            Exit;
          end;
        StateBeeping :
          begin
            CurrentState := StateRecording;
            ApdTapiDevice1.MaxMessageLength :=
              StrToInt(MaxLengthEdit.Text);
            Label4.Caption := 'Recording Incoming Message';
            ApdTapiDevice1.StartWaveRecord;
            Exit;
          end;
        StatePlayback :
          begin
            CurrentState := StateIdle;
            ApdTapiDevice1.UseSoundCard := False;
            Screen.Cursor := crDefault;
            Label4.Caption := 'Waiting For Call';
          end;
      end;
  end;
end;

procedure TForm1.CallsListBoxDblClick(Sender: TObject);
begin
  PlayBackMessage;
end;

procedure TForm1.ApdTapiDevice1TapiCallerID(CP: TObject; ID,
  IDName: String);
begin
  CallerId.Text := ID;
  CallerIdName.Text := IDName;
end;

procedure TForm1.MaxLengthEditExit(Sender: TObject);
begin
  try
    ApdTapiDevice1.MaxMessageLength :=
      StrToInt(MaxLengthEdit.Text);
  except
    on E : EConvertError do begin
      Application.ShowException(E);
      MaxLengthEdit.SetFocus;
    end;
  end;
end;

procedure TForm1.CallsListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE :
      CallsListBox.Items.Delete(CallsListBox.ItemIndex);
    VK_RETURN :
      PlayBackMessage;
  end;
end;

procedure TForm1.PlayBackMessage;
var
  CallNum  : Integer;
  FileName : String;
begin
  Label4.Caption := 'Playing Message';
  CallNum := Integer(CallsListBox.Items.Objects[CallsListBox.ItemIndex]);
  FileName := Format('%sCall%d.wav', [WaveFileDir, CallNum]);
  ApdTapiDevice1.UseSoundCard := True;
  ApdTapiDevice1.PlayWaveFile(FileName);
  Screen.Cursor := crHourGlass;
  CurrentState := StatePlayback;
end;

procedure TForm1.Delete1Click(Sender: TObject);
begin
  CallsListBox.Items.Delete(CallsListBox.ItemIndex);
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  Play1.Enabled := (CallsListBox.Items.Count > 0) and
                   (CallsListBox.ItemIndex <> -1);
  Delete1.Enabled := Play1.Enabled;
end;

procedure TForm1.MonitorClick(Sender: TObject);
begin
  ApdTapiDevice1.MonitorRecording := Monitor.Checked;
end;

end.
