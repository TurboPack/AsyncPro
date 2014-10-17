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
/*                      ExVoice0.cpp                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExVoice0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdTapi"
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
  CurrentState = 0;
  WaveFileDir = ExtractFilePath(ParamStr(0));
  WaveFileDir = WaveFileDir.SubString(1, WaveFileDir.Pos("EXAMPLES") + 8);
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
    ApdTapiDevice1->AutoAnswer();
  else
    MessageBox(Handle, "The Selected device does not"
      " support Voice Extensions.", "Error", MB_OK);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::CancelCallClick(TObject *Sender)
{
  ApdTapiDevice1->CancelCall();
  CallerID->Text = "";
  CallerIDName->Text = "";
  Timer1->Enabled = true;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiConnect(TObject *Sender)
{
  CancelCall->Enabled = true;
  CurrentState = StateGreeting;
  // Play Greeting
  Label4->Caption = "Playing Greeting";
  ApdTapiDevice1->PlayWaveFile(WaveFileDir+"greeting.wav");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiCallerID(TObject *CP, AnsiString ID,
  AnsiString IDName)
{
  CallerID->Text = ID;
  CallerIDName->Text = IDName;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
  try {
    ApdTapiDevice1->AutoAnswer();
    Timer1->Enabled = false;
  }
  catch (...) {}
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiDTMF(TObject *CP, char Digit, int ErrorCode)
{
  String S;
  LastDigit = Digit;
  if (Digit == 0 || Digit == ' ') return;
  if (Digit == '*')
    PadAsterisk->Down = true;
  else if (Digit == '#')
    PadPound->Down = true;
  else {
    TSpeedButton* btn =
      dynamic_cast<TSpeedButton*>(FindComponent("Pad" + Digit));
    if (btn) btn->Down = true;
  }

  // Simple DTMF State Machine
  switch (CurrentState) {
    case StateMenu : {
      switch (Digit) {
        case '0' :
        case '1' :
        case '2' :
        case '3' :
        case '4' :
        case '5' :
        case '6' :
        case '7' :
        case '8' :  S = WaveFileDir + "choice" + Digit + ".wav"; break;
        case '9' : {
          ApdTapiDevice1->InterruptWave = false;
          S = WaveFileDir + "choice9.wav";
          CurrentState = StateEndCall;
          break;
        }
        case '*' : {
          S = WaveFileDir + "Greeting.wav";
          CurrentState = StateGreeting;
          break;
        }
        case '#' : {
          ApdTapiDevice1->InterruptWave = false;
          S = WaveFileDir + "Goodbye.wav";
          CurrentState = StateEndCall;
          break;
        }
      }
      break;
    }
    case StateGreeting : {
      S = WaveFileDir + "menu.wav";
      CurrentState = StateMenu;
      break;
    }
  }
  if (S != "") {
    Label4->Caption = "Playing Wave File: " + S;
    ApdTapiDevice1->PlayWaveFile(S);
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiWaveNotify(TObject *CP,
  TWaveMessage Msg)
{
  if (Msg == waPlayDone)
    Label4->Caption = "Wave Device Idle...";
  if (CurrentState == StateEndCall)
    if (Msg == waPlayDone)
      CancelCallClick(this);
}
//---------------------------------------------------------------------------
