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
{*                   EXSAPIP0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates using the TApdSapiPhone component in a   *}
{* more complex voice telephony application.             *}
{*********************************************************}
unit ExSapiP0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdTapi, AdSapiPh, OoMisc, AdSapiEn, Grids, StdCtrls, AdPort, Gauges;

type
  TConversationState = (csPhone, csPhoneVerify, csDate, csTime,
                        csDateTimeVerify);
  
  TForm1 = class(TForm)
    ApdSapiEngine1: TApdSapiEngine;
    ApdSapiPhone1: TApdSapiPhone;
    Label1: TLabel;     
    ApdComPort1: TApdComPort;
    btnAnswer: TButton;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    Memo1: TMemo;
    Gauge1: TGauge;
    Log: TLabel;
    procedure btnAnswerClick(Sender: TObject);
    procedure ApdSapiPhone1TapiConnect(Sender: TObject);
    procedure Hangup;
    procedure Conversation;
    procedure FindPhoneEngines;
    procedure ApdSapiPhone1AskForPhoneNumberFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data, SpokenData: String);
    procedure ApdSapiPhone1AskForYesNoFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data: Boolean; SpokenData: String);
    procedure ApdSapiPhone1AskForDateFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data: TDateTime; SpokenData: String);
    procedure ApdSapiPhone1AskForTimeFinish(Sender: TObject;
      Reply: TApdSapiPhoneReply; Data: TDateTime; SpokenData: String);
    procedure ApdSapiEngine1Interference(Sender: TObject;
      InterferenceType: TApdSRInterferenceType);
    procedure ApdSapiEngine1PhraseFinish(Sender: TObject;
      const Phrase: String);
    procedure ApdSapiEngine1VUMeter(Sender: TObject; Level: Integer);
    procedure ApdSapiPhone1TapiDisconnect(Sender: TObject);
    procedure ApdSapiEngine1SRError(Sender: TObject; Error: Cardinal;
      const Details, Message: String);
    procedure ApdSapiEngine1SRWarning(Sender: TObject; Error: Cardinal;
      const Details, Message: String);
    procedure ApdSapiEngine1SSError(Sender: TObject; Error: Cardinal;
      const Details, Message: String);
    procedure ApdSapiEngine1SSWarning(Sender: TObject; Error: Cardinal;
      const Details, Message: String);
    procedure FormCreate(Sender: TObject);
  private
    ConvState : TConversationState;
    PhoneNumber : string;
    TheDate : TDateTime;
    TheTime : TDateTime;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Hangup;
begin
  ApdSapiEngine1.Speak ('Goodbye');
  ApdSapiEngine1.WaitUntilDoneSpeaking;
  ApdSapiPhone1.CancelCall;
  ApdSapiPhone1.AutoAnswer;
end;

procedure TForm1.FindPhoneEngines;

  procedure SetSSEngine;
  var
    i : Integer;
  begin
    for i := 0 to ApdSapiEngine1.SSVoices.Count - 1 do
      if tfPhoneOptimized in ApdSapiEngine1.SSVoices.Features[i] then begin
        ApdSapiEngine1.SSVoices.CurrentVoice := i;
        Exit;
      end;
    raise Exception.Create ('No phone enabled speech synthesis engine was found');
  end;

  procedure SetSREngine;
  var
    i : Integer;
  begin
    for i := 0 to ApdSapiEngine1.SREngines.Count - 1 do
      if sfPhoneOptimized in ApdSapiEngine1.SREngines.Features[i] then begin
        ApdSapiEngine1.SREngines.CurrentEngine := i;
        Exit;
      end;
    raise Exception.Create ('No phone enabled speech recognition engine was found');
  end;

begin
  SetSSEngine;
  SetSREngine;
end;

procedure TForm1.Conversation;

  function SplitPhoneNumber (PhoneNum : string) : string;
  var
    i : Integer;

  begin
    Result := '';
    for i := 1 to Length (PhoneNum) do
      if (PhoneNum[i] >= '0') and (PhoneNum[i] <= '9') then
        Result := Result + PhoneNum[i] + ' ';
  end;

begin
  case ConvState of
    csPhone :
      begin
        Memo1.Lines.Add ('Asking for phone number');
        ApdSapiPhone1.AskForPhoneNumber ('Please tell me your phone number');
      end;
    csPhoneVerify :
      begin
        Memo1.Lines.Add ('Confirming phone number');
        ApdSapiPhone1.AskForYesNo ('I heard ' + SplitPhoneNumber (PhoneNumber) +
                                   '.  Is this correct?');
      end;
    csDate :
      begin
        Memo1.Lines.Add ('Asking for date');
        ApdSapiPhone1.AskForDate ('What date would you like?');
      end;
    csTime :
      begin
        Memo1.Lines.Add ('Asking for time');
        ApdSapiPhone1.AskForTime ('What time would you like?');
      end;
    csDateTimeVerify :
      begin
        Memo1.Lines.Add ('Confirming Date and Time');
        ApdSapiPhone1.AskForYesNo ('I heard ' +
                                   FormatDateTime ('ddddd', TheDate) +
                                   ' at ' +
                                   FormatDateTime ('t', TheTime) +
                                   '.  Is this correct?');
      end;
  end;
end;

procedure TForm1.btnAnswerClick(Sender: TObject);
begin
  { Make sure that phone enabled SAPI engines are being used }
  FindPhoneEngines;
  { Wait for a call }
  ApdSapiPhone1.AutoAnswer;
end;

procedure TForm1.ApdSapiPhone1TapiConnect(Sender: TObject);
begin
  Memo1.Lines.Add ('Call received at ' + FormatDateTime ('ddddd t', Now));
  ApdSapiEngine1.Speak ('Welcome to the Sapi phone demonstration');
  ApdSapiEngine1.WaitUntilDoneSpeaking;
  ConvState := csPhone;
  Conversation;
end;

procedure TForm1.ApdSapiPhone1AskForPhoneNumberFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data, SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        PhoneNumber := Data;
        StringGrid1.RowCount := StringGrid1.RowCount + 1;
        if StringGrid1.RowCount < 2 then begin
          StringGrid1.RowCount := StringGrid1.RowCount + 1;
        end;
        StringGrid1.Cells [0, 0] := 'Phone Number';
        StringGrid1.Cells [1, 0] := 'Date';
        StringGrid1.Cells [2, 0] := 'Time';
        StringGrid1.Cells [3, 0] := 'OK';
        StringGrid1.FixedRows := 1;
        StringGrid1.Cells [0, StringGrid1.RowCount - 1] := PhoneNumber;
        StringGrid1.Cells [3, StringGrid1.RowCount - 1] := 'No';
        ConvState := csPhoneVerify;
        Conversation;
      end;
    prCheck :
      begin
        PhoneNumber := Data;
        ConvState := csPhoneVerify;
        StringGrid1.Cells [0, 0] := 'Phone Number';
        StringGrid1.Cells [1, 0] := 'Date';
        StringGrid1.Cells [2, 0] := 'Time';
        StringGrid1.FixedRows := 1;
        StringGrid1.Cells [0, StringGrid1.RowCount - 1] := PhoneNumber;
        StringGrid1.Cells [3, StringGrid1.RowCount - 1] := 'No';
        Conversation;
      end;
    prHangup :
      Hangup;
    prBack :
      begin
        ConvState := csPhone;
        Conversation;
      end;
  end;
end;

procedure TForm1.ApdSapiPhone1AskForYesNoFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data: Boolean; SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        if Data then
          case ConvState of
            csPhoneVerify :
              ConvState := csDate;
            csDateTimeVerify :
              begin
                ApdSapiEngine1.Speak ('thank you');
                StringGrid1.Cells [3, StringGrid1.RowCount - 1] := 'Yes';
                Hangup;
                Exit;
              end;
          end
        else
          case ConvState of
            csPhoneVerify :
              ConvState := csPhone;
            csDateTimeVerify :
              ConvState := csDate;  
          end;
        Conversation;
      end;
    prHangup :
      Hangup;
    prBack :
      begin
        case ConvState of
          csPhoneVerify :
            ConvState := csPhone;
          csDateTimeVerify :
            ConvState := csTime;
        end;
        Conversation
      end;
  end;
end;

procedure TForm1.ApdSapiPhone1AskForDateFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data: TDateTime; SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        TheDate := Data;
        ConvState := csTime;
        StringGrid1.Cells [1, StringGrid1.RowCount - 1] :=
            FormatDateTime ('ddddd', TheDate);
        Conversation;
      end;
    prCheck :
      begin
        TheDate := Data;
        ConvState := csTime;
        StringGrid1.Cells [1, StringGrid1.RowCount - 1] :=
            FormatDateTime ('ddddd', TheDate);
        Conversation;
      end;
    prHangup :
      Hangup;
    prBack :
      begin
        ConvState := csPhone;
        Conversation;
      end;
  end;
end;

procedure TForm1.ApdSapiPhone1AskForTimeFinish(Sender: TObject;
  Reply: TApdSapiPhoneReply; Data: TDateTime; SpokenData: String);
begin
  case Reply of
    prOk :
      begin
        TheTime := Data;
        ConvState := csDateTimeVerify;
        StringGrid1.Cells [2, StringGrid1.RowCount - 1] :=
            FormatDateTime ('t', TheTime);
        Conversation;
      end;
    prCheck :
      begin
        TheTime := Data;
        ConvState := csDateTimeVerify;
        StringGrid1.Cells [2, StringGrid1.RowCount - 1] :=
            FormatDateTime ('t', TheTime);
        Conversation;
      end;
    prHangup :
      Hangup;
    prBack :
      begin
        ConvState := csDate;
        Conversation;
      end;
  end;
end;

procedure TForm1.ApdSapiEngine1Interference(Sender: TObject;
  InterferenceType: TApdSRInterferenceType);
begin
  case InterferenceType of
    itAudioStarted :
      Memo1.Lines.Add ('Audio Started');
    itAudioStopped :
      Memo1.Lines.Add ('Audio Stopped');
    itDeviceOpened :
      Memo1.Lines.Add ('Device Opened');
    itDeviceClosed :
      Memo1.Lines.Add ('Device Closed');
    itNoise :
      Memo1.Lines.Add ('Interference: Noise');
    itTooLoud :
      Memo1.Lines.Add ('Interference: Too Loud');
    itTooQuiet :
      Memo1.Lines.Add ('Interference: Too Quiet');
    itUnknown :
      Memo1.Lines.Add ('Interference: Unknown');
  end;
end;

procedure TForm1.ApdSapiEngine1PhraseFinish(Sender: TObject;
  const Phrase: String);
begin
  Memo1.Lines.Add ('The user said ' + Phrase);
end;

procedure TForm1.ApdSapiEngine1VUMeter(Sender: TObject; Level: Integer);
begin
  Gauge1.Progress := Level;
end;

procedure TForm1.ApdSapiPhone1TapiDisconnect(Sender: TObject);
begin
  Memo1.Lines.Add ('Call disconnected at ' + FormatDateTime ('ddddd t', Now));
end;

procedure TForm1.ApdSapiEngine1SRError(Sender: TObject; Error: Cardinal;
  const Details, Message: String);
begin
  Memo1.Lines.Add ('Speech Recognition Error: ' + Message);
end;

procedure TForm1.ApdSapiEngine1SRWarning(Sender: TObject; Error: Cardinal;
  const Details, Message: String);
begin
  Memo1.Lines.Add ('Speech Recognition Warning: ' + Message);
end;

procedure TForm1.ApdSapiEngine1SSError(Sender: TObject; Error: Cardinal;
  const Details, Message: String);
begin
  Memo1.Lines.Add ('Speech Synthesis Error: ' + Message);
end;

procedure TForm1.ApdSapiEngine1SSWarning(Sender: TObject; Error: Cardinal;
  const Details, Message: String);
begin
  Memo1.Lines.Add ('Speech Synthesis Warning: ' + Message);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if (not ApdSapiEngine1.IsSapi4Installed) then begin
    ShowMessage ('SAPI 4 is not installed. AV will occur.');
  end;
end;

end.
