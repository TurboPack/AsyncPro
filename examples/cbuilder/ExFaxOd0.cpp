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
/*                      ExFaxOd0.cpp                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExFaxOd0.h"
//---------------------------------------------------------------------------
#pragma link "AdTapi"
#pragma link "AdFax"
#pragma link "AdFStat"
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
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  ApdTapiDevice1->SelectDevice();
  ApdTapiDevice1->EnableVoice = true;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::AnswerButtonClick(TObject *Sender)
{
  if (ApdTapiDevice1->EnableVoice)
    ApdTapiDevice1->EnableVoice = true;
  else
    MessageDlg("The Selected device does not support Voice Extensions.",
      mtInformation, TMsgDlgButtons() << mbOK, 0);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  SendTheFax = false;
  WaveFileDir = ExtractFilePath(ParamStr(0));
  WaveFileDir = ExtractFilePath(ParamStr(0));
  WaveFileDir = WaveFileDir.UpperCase();
  WaveFileDir = WaveFileDir.SubString(1, WaveFileDir.Pos("EXAMPLES") + 8);
  ApdSendFax1->FaxFile = WaveFileDir + "aprologo.apf";
  if ((FileGetAttr(ApdSendFax1->FaxFile) & faReadOnly) != 0) {
    MessageDlg("The AProLogo.APF fax file is designated Read-Only"
      " and may not be used in this example until this attribute"
      " is changed to Read/Write.",
      mtInformation, TMsgDlgButtons() << mbOK, 0);
    Application->Terminate();
  }
  ApdTapiDevice1->InterruptWave = false;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiDTMF(TObject *CP, char Digit, int ErrorCode)
{
  String S;
  switch (CurrentState) {
    case StateIdle : {
      Edit1->Text = "StateIdle";
      break;
    }
    case StateGreeting : {
      Edit1->Text = "StateGreeting";
        switch (Digit) {
          case '5' : {
            CurrentState = StateGettingNumber;
            ApdTapiDevice1->PlayWaveFile(WaveFileDir + "enter.wav");
            break;
          }
          case '*' : {
            CurrentState = StateEndCall;
            ApdTapiDevice1->PlayWaveFile(WaveFileDir + "goodbye.wav");
            break;
          }
          default : {
            ApdTapiDevice1->PlayWaveFile(WaveFileDir + "Play" + Digit + ".wav");
            while (ApdTapiDevice1->WaveState == wsPlaying)
              Application->ProcessMessages();
            ApdTapiDevice1->PlayWaveFile(WaveFileDir + "invalid.wav");
          }
        }
      break;
    }
    case StateEndCall : break;
    case StateGettingNumber : {
        Edit1->Text = "StateGettingNumber";
        switch (Digit) {
          case '*' : {
            Edit3->Text = "";
            ApdTapiDevice1TapiConnect(this);
            break;
          }
          case '#' : {
            if (Edit3->Text == "" )
              ApdTapiDevice1TapiConnect(this);
            else {
              CurrentState = StatePlayBack;
              ApdTapiDevice1->PlayWaveFile(WaveFileDir + "uentered.wav");
              for (int i=0;i<Edit3->Text.Length();i++) {
                while (ApdTapiDevice1->WaveState == wsPlaying)
                  Application->ProcessMessages();
                ApdTapiDevice1->PlayWaveFile(
                 WaveFileDir + "play" + Edit3->Text.SubString(i, 1) + ".wav");
              }
              while (ApdTapiDevice1->WaveState == wsPlaying)
                Application->ProcessMessages();
              CurrentState = StateWaitReply;
              ApdTapiDevice1->PlayWaveFile(WaveFileDir + "correct.wav");
            }
          }
        default : {
          Edit3->Text = Edit3->Text + Digit;
        }
      }
      break;
    }
    case StateWaitReply : {
      Edit1->Text = "StateWaitReply";
      switch (Digit) {
        case '*' : {
          Edit3->Text = "";
          CurrentState = StateGettingNumber;
          ApdTapiDevice1->PlayWaveFile(WaveFileDir + "enter.wav");
          break;
        }
        case '#' : {
          // wait for previous message to conclude then play final message
          while (ApdTapiDevice1->WaveState == wsPlaying)
            Application->ProcessMessages();
          SendTheFax = true;
          ApdTapiDevice1->InterruptWave = false;
          ApdTapiDevice1->PlayWaveFile(WaveFileDir + "hangup.wav");
          CurrentState = StateEndCall;
        }
      }
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiConnect(TObject *Sender)
{
  // Play Greeting
  if (ApdTapiDevice1->EnableVoice) {
    CurrentState = StateGreeting;
    ApdTapiDevice1->PlayWaveFile(WaveFileDir + "welcome.wav");
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
  Timer1->Enabled = false;
  // Send the Fax
  ApdTapiDevice1->EnableVoice = false;
  ApdSendFax1->PhoneNumber = Edit3->Text;
  ApdTapiDevice1->ConfigAndOpen();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdTapiDevice1TapiPortOpen(TObject *Sender)
{
  if (SendTheFax && !ApdTapiDevice1->EnableVoice)
    ApdSendFax1->StartTransmit();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiWaveNotify(TObject *CP,
  TWaveMessage Msg)
{
  if (Msg == waPlayOpen)
    Edit2->Text = "Playing Wave: " +
      ExtractFileName(ApdTapiDevice1->WaveFileName);
  else
    if (Msg == waPlayDone)
      Edit2->Text = "Wave Device Idle...";
  switch (CurrentState) {
    case StateEndCall : {
        Edit1->Text = "StateEndCall";
        if (Msg == waPlayDone) {
          ApdTapiDevice1->CancelCall();
          Timer1->Enabled = true;
        }
      }
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSendFax1FaxFinish(TObject *CP, int ErrorCode)
{
  if (ErrorCode == 0)
    ShowMessage("Fax sent successfully");
  CurrentState = StateIdle;
}
//---------------------------------------------------------------------------
