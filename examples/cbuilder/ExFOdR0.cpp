// ***** BEGIN LICENSE BLOCK *****
// * Version: MPL 1.1
// *
// * The contents of this file are subject to the Mozilla Public License Version
// * 1.1 (the "License"); you may not use this file except in compliance with
// * the License. You may obtain a copy of the License at
// * http://www.mozilla.org/MPL/
// *
// * Software distributed under the License is distributed on an "AS IS" basis,
// * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// * for the specific language governing rights and limitations under the
// * License.
// *
// * The Original Code is TurboPower Async Professional
// *
// * The Initial Developer of the Original Code is
// * TurboPower Software
// *
// * Portions created by the Initial Developer are Copyright (C) 1991-2002
// * the Initial Developer. All Rights Reserved.
// *
// * Contributor(s):
// *
// * ***** END LICENSE BLOCK *****

/*********************************************************/
/*                      ExFOdR0.cpp                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExFOdR0.h"
//---------------------------------------------------------------------------
#pragma link "AdTapi"
#pragma link "AdFStat"
#pragma link "AdFax"
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  WaveFileDir = ExtractFilePath(ParamStr(0));
  WaveFileDir = WaveFileDir.UpperCase();
  WaveFileDir = WaveFileDir.SubString(1, WaveFileDir.Pos("EXAMPLES") + 8);
  Caption = WaveFileDir;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiConnect(TObject *Sender)
{
  // Play Greeting
  CurrentState = StateGreeting;
  Caption = WaveFileDir;// + "fsndwelc.wav";
  ApdTapiDevice1->PlayWaveFile("..\\fsndwelc.wav");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiDTMF(TObject *CP, char Digit, int ErrorCode)
{
  String S;
  switch (CurrentState) {
    case StateGreeting : {
        switch (Digit) {
          case '*': {
            ApdTapiDevice1->InterruptWave = false;
            ApdTapiDevice1->PlayWaveFile(WaveFileDir + "goodbye.wav");
            CurrentState = StateEndCall;
            break;
          }
          case '#': {
            CurrentState = StateReceiveFax;
            ApdTapiDevice1->PlayWaveFile(WaveFileDir + "fsndprmt.wav");
            while (ApdTapiDevice1->WaveState == wsPlaying)
              Application->ProcessMessages();
            ApdTapiDevice1->AutomatedVoicetoComms();
            ApdFaxStatus1->Fax = ApdReceiveFax1;
            ApdReceiveFax1->StartManualReceive(true);
            break;
          }
          case '0': {
            ApdTapiDevice1->PlayWaveFile(WaveFileDir + "faxhlp.wav");
            break;
            }
        }
      break;
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiWaveNotify(TObject *CP,
  TWaveMessage Msg)
{
  switch (CurrentState) {
    case StateIdle        : Edit1->Text = "StateIdle"; break;
    case StateGreeting    : Edit1->Text = "StateGreeting"; break;
    case StateReceiveFax  : Edit1->Text = "StateReceiveFax"; break;
    case StateEndCall     : Edit1->Text = "StateEndCall"; break;
  }

  if (Msg == waPlayOpen)
    Edit2->Text = "Playing Wave: " +
      ExtractFileName(ApdTapiDevice1->WaveFileName);
  else if (Msg == waPlayDone)
    Edit2->Text = "Wave Device Idle...";

  switch (CurrentState) {
    case StateEndCall: {
      Edit1->Text = "StateEndCall";
      if (Msg == waPlayDone )
        ApdTapiDevice1->CancelCall();
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  ApdTapiDevice1->SelectDevice();
  ApdTapiDevice1->EnableVoice = true;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::AnswerButtonClick(TObject *Sender)
{
  if (!ApdTapiDevice1->EnableVoice)
    ApdTapiDevice1->EnableVoice = true;
  if (ApdTapiDevice1->EnableVoice)
    ApdTapiDevice1->AutoAnswer();
  else
    MessageDlg("The Selected device does not support Voice Extensions.",
      mtInformation, TMsgDlgButtons() << mbOK, 0);
}
//---------------------------------------------------------------------------

