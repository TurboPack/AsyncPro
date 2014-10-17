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
{*                   EXSAPIB0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to create a simple voice telephony   *}
{* application using SAPI                                *}
{*********************************************************}

unit ExSapiB0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OoMisc, AdSapiEn, StdCtrls, Gauges, AdPort, AdTapi, AdSapiPh;

type
  TPhraseType = (ptHelp, ptDate, ptTime, ptQuit, ptUnknown);

  TForm1 = class(TForm)
    Gauge1: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    ApdSapiEngine1: TApdSapiEngine;
    ApdSapiPhone1: TApdSapiPhone;
    ApdComPort1: TApdComPort;
    function AnalyzePhrase (Phrase : string) : TPhraseType;
    procedure SaySomething (Something : string);
    procedure FindPhoneEngines;
    procedure Button1Click(Sender: TObject);
    procedure ApdSapiEngine1VUMeter(Sender: TObject; Level: Integer);
    procedure ApdSapiPhone1TapiConnect(Sender: TObject);
    procedure ApdSapiEngine1PhraseFinish(Sender: TObject;
      const Phrase: String);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function TForm1.AnalyzePhrase (Phrase : string) : TPhraseType;
begin
  Result := ptUnknown;
  if Phrase = 'help' then
    Result := ptHelp
  else if (Phrase = 'close') or (Phrase = 'exit') or
          (Phrase = 'goodbye') or (Phrase = 'end') or
          (Phrase = 'bye') then
    Result := ptQuit
  else if (Phrase = 'what time is it') or (Phrase = 'time') then
    Result := ptTime
  else if (Phrase = 'what day is it') or (Phrase = 'day') then
    Result := ptDate;
end;

procedure TForm1.SaySomething (Something : string);
begin
  Memo1.Lines.Add ('--> ' + Something);
  ApdSapiEngine1.Speak (Something);
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  with ApdSapiEngine1.WordList do begin
    Clear;
    Add ('close');
    Add ('exit');
    Add ('goodbye');
    Add ('end');
    Add ('bye');

    Add ('what time is it');
    Add ('time');

    Add ('what day is it');
    Add ('day');

    Add ('help');
  end;

  FindPhoneEngines;
  ApdSapiPhone1.AutoAnswer;
end;

procedure TForm1.ApdSapiEngine1VUMeter(Sender: TObject; Level: Integer);
begin
  Gauge1.Progress := Level;
end;

procedure TForm1.ApdSapiPhone1TapiConnect(Sender: TObject);
begin
  SaySomething ('Welcome to the speech recognition demo.');
  SaySomething ('Say "Help" to get help');
  ApdSapiEngine1.Listen;
end;

procedure TForm1.ApdSapiEngine1PhraseFinish(Sender: TObject;
  const Phrase: String);
begin
  Memo1.Lines.Add ('<-- ' + Phrase);
  case AnalyzePhrase (Phrase) of
    ptHelp :
      begin
        SaySomething ('You can say several things to this demo.');
        SaySomething ('"Help" will give you help.');
        SaySomething ('"What time is it?" will tell the current time.');
        SaySomething ('"What day is it?" will tell the current day.');
        SaySomething ('"Goodbye" will end this demo.');
      end;
    ptQuit :
      begin
        SaySomething ('Goodbye');
        ApdSapiEngine1.WaitUntilDoneSpeaking;
        ApdSapiPhone1.CancelCall;
        ApdSapiPhone1.AutoAnswer;
      end;
    ptDate :
      begin
        SaySomething ('It is ' + FormatDateTime ('mmmm d, yyyy', Now) + '.');
      end;
    ptTime :
      begin
        SaySomething ('It is ' + FormatDateTime ('h:nam/pm', Now) + '.');
      end;
    ptUnknown :
      begin
        SaySomething ('I didn''t understand you.');
      end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if (not ApdSapiEngine1.IsSapi4Installed) then begin
    ShowMessage ('SAPI 4 is not installed. AV will occur when answering');
  end;
end;

end.
