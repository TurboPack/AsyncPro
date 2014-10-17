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
/*                      ExFOdS0.cpp                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExFOdS0.h"
//---------------------------------------------------------------------------
#pragma link "AdTapi"
#pragma link "AdPort"
#pragma link "AdFax"
#pragma link "AdFStat"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiConnect(TObject *Sender)
{
  // Play Greeting
  CurrentState = StateGreeting;
  ApdTapiDevice1->PlayWaveFile("..\\frcvwelc.wav");
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
            ApdTapiDevice1->PlayWaveFile("..\\goodbye.wav");
            CurrentState = StateEndCall;
            break;
          }
          case '#': {
            CurrentState = StateSendFax;
            ApdTapiDevice1->PlayWaveFile("..\\frcvprmt.wav");
            while (ApdTapiDevice1->WaveState == wsPlaying)
              Application->ProcessMessages();
            ApdTapiDevice1->AutomatedVoicetoComms();
            ApdSendFax1->StartManualTransmit();
            break;
          }
          case '0': {
            ApdTapiDevice1->PlayWaveFile("..\\faxhlp.wav");
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
    case StateSendFax     : Edit1->Text = "StateSendFax"; break;
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
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  ApdSendFax1->FaxFile = "..\\aprologo.apf";
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
