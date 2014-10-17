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

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "ExSapiP0.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdPort"
#pragma link "AdSapiEn"
#pragma link "AdSapiPh"
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
void __fastcall TForm1::Hangup (void)
{
  ApdSapiEngine1->Speak ("Goodbye");
  ApdSapiEngine1->WaitUntilDoneSpeaking ();
  ApdSapiPhone1->CancelCall ();
  ApdSapiPhone1->AutoAnswer ();
}

//---------------------------------------------------------------------------
void __fastcall TForm1::SetSSEngine (void)
{
  for (int i = 0; i < ApdSapiEngine1->SSVoices->Count; i++)
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfPhoneOptimized)) {
      ApdSapiEngine1->SSVoices->CurrentVoice = i;
      return;
    }
  throw new Exception ("No phone enabled speech synthesis engine was found");
}

//---------------------------------------------------------------------------
void __fastcall TForm1::SetSREngine (void)
{
  for (int i = 0; i < ApdSapiEngine1->SREngines->Count; i++)
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfPhoneOptimized)) {
      ApdSapiEngine1->SREngines->CurrentEngine = i;
      return;
    }
  throw new Exception ("No phone enabled speech recognition engine was found");
}

//---------------------------------------------------------------------------
void __fastcall TForm1::FindPhoneEngines (void)
{
  SetSSEngine ();
  SetSREngine ();
}

//---------------------------------------------------------------------------
AnsiString __fastcall TForm1::SplitPhoneNumber (AnsiString PhoneNum)
{
  AnsiString ReturnString = "";
  int i;

  for (i = 1; i <= PhoneNum.Length (); i++)
    if ((PhoneNum[i] >= '0') && (PhoneNum[i] <= '9'))
        ReturnString = ReturnString + PhoneNum[i] + " ";
  return ReturnString;
}

//---------------------------------------------------------------------------
void __fastcall TForm1::Conversation (void)
{
  switch (ConvState) {
    case csPhone :
      Memo1->Lines->Add ("Asking for phone number");
      ApdSapiPhone1->AskForPhoneNumber ("Please tell me your phone number");
      break;
    case csPhoneVerify :
      Memo1->Lines->Add ("Confirming phone number");
      ApdSapiPhone1->AskForYesNo ("I heard " + SplitPhoneNumber (PhoneNumber) +
                                 ".  Is this correct?");
      break;
    case csDate :
      Memo1->Lines->Add ("Asking for date");
      ApdSapiPhone1->AskForDate ("What date would you like?");
      break;
    case csTime :
      Memo1->Lines->Add ("Asking for time");
      ApdSapiPhone1->AskForTime ("What time would you like?");
      break;
    case csDateTimeVerify :
      Memo1->Lines->Add ("Confirming Date and Time");
      ApdSapiPhone1->AskForYesNo ("I heard " +
                                  FormatDateTime ("ddddd", TheDate) +
                                  " at " +
                                  FormatDateTime ("t", TheTime) +
                                  ".  Is this correct?");
      break;
  }
}

//---------------------------------------------------------------------------
void __fastcall TForm1::btnAnswerClick(TObject *Sender)
{
  // Make sure that phone enabled SAPI engines are being used 
  FindPhoneEngines ();
  // Wait for a call
  ApdSapiPhone1->AutoAnswer ();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiPhone1AskForDateFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, TDateTime Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      TheDate = Data;
      ConvState = csTime;
      StringGrid1->Cells[1][StringGrid1->RowCount - 1] =
          FormatDateTime ("ddddd", TheDate);
      Conversation ();
      break;
    case prCheck :
      TheDate = Data;
      ConvState = csTime;
      StringGrid1->Cells [1][StringGrid1->RowCount - 1] =
          FormatDateTime ("ddddd", TheDate);
      Conversation ();
      break;
    case prHangUp :
      Hangup ();
      break;
    case prBack :
      ConvState = csPhone;
      Conversation ();
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForPhoneNumberFinish(
      TObject *Sender, TApdSapiPhoneReply Reply, AnsiString Data,
      AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      PhoneNumber = Data;
      StringGrid1->RowCount = StringGrid1->RowCount + 1;
      if (StringGrid1->RowCount < 2)
        StringGrid1->RowCount = StringGrid1->RowCount + 1;
      StringGrid1->Cells [0][0] = "Phone Number";
      StringGrid1->Cells [1][0] = "Date";
      StringGrid1->Cells [2][0] = "Time";
      StringGrid1->Cells [3][0] = "OK";
      StringGrid1->FixedRows = 1;
      StringGrid1->Cells [0][StringGrid1->RowCount - 1] = PhoneNumber;
      StringGrid1->Cells [3][StringGrid1->RowCount - 1] = "No";
      ConvState = csPhoneVerify;
      Conversation ();
      break;
    case prCheck :
      PhoneNumber = Data;
      StringGrid1->RowCount = StringGrid1->RowCount + 1;
      if (StringGrid1->RowCount < 2)
        StringGrid1->RowCount = StringGrid1->RowCount + 1;
      StringGrid1->Cells [0][0] = "Phone Number";
      StringGrid1->Cells [1][0] = "Date";
      StringGrid1->Cells [2][0] = "Time";
      StringGrid1->FixedRows = 1;
      StringGrid1->Cells [0][StringGrid1->RowCount - 1] = PhoneNumber;
      StringGrid1->Cells [3][StringGrid1->RowCount - 1] = "No";
      ConvState = csPhoneVerify;
      Conversation ();
      break;
    case prHangUp :
      Hangup ();
      break;
    case prBack :
      ConvState = csPhone;
      Conversation ();
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForTimeFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, TDateTime Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      TheTime = Data;
      ConvState = csDateTimeVerify;
      StringGrid1->Cells [2][StringGrid1->RowCount - 1] =
          FormatDateTime ("t", TheTime);
      Conversation ();
      break;
    case prCheck :
      TheTime = Data;
      ConvState = csDateTimeVerify;
      StringGrid1->Cells [2][StringGrid1->RowCount - 1] =
          FormatDateTime ("t", TheTime);
      Conversation ();
      break;
    case prHangUp :
      Hangup ();
      break;
    case prBack :
      ConvState = csDate;
      Conversation ();
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForYesNoFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, bool Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      if (Data)
        switch (ConvState) {
          case csPhoneVerify :
            ConvState = csDate;
            break;
          case csDateTimeVerify :
            StringGrid1->Cells [3][StringGrid1->RowCount - 1] = "Yes";
            ApdSapiEngine1->Speak ("thank you");
            Hangup ();
            return;
        }
      else
        switch (ConvState) {
          case csPhoneVerify :
            ConvState = csPhone;
            break;
          case csDateTimeVerify :
            ConvState = csDate;
            break;
        }
      Conversation ();
      break;
    case prHangUp :
      Hangup ();
      break;
    case prBack :
      switch (ConvState) {
        case csPhoneVerify :
          ConvState = csPhone;
          break;
        case csDateTimeVerify :
          ConvState = csTime;
          break;
      }
      Conversation ();
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1TapiConnect(TObject *Sender)
{
  Memo1->Lines->Add ("Call received at " + FormatDateTime ("ddddd t", Now ()));
  ApdSapiEngine1->Speak ("Welcome to the Sapi phone demonstration");
  ApdSapiEngine1->WaitUntilDoneSpeaking ();
  ConvState = csPhone;
  Conversation ();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1TapiDisconnect(TObject *Sender)
{
  Memo1->Lines->Add ("Call disconnected at " +
                     FormatDateTime ("ddddd t", Now ()));
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1Interference(TObject *Sender,
      TApdSRInterferenceType InterferenceType)
{
  switch (InterferenceType) {
    case itAudioStarted :
      Memo1->Lines->Add ("Audio Started");
      break;
    case itAudioStopped :
      Memo1->Lines->Add ("Audio Stopped");
      break;
    case itDeviceOpened :
      Memo1->Lines->Add ("Device Opened");
      break;
    case itDeviceClosed :
      Memo1->Lines->Add ("Device Closed");
      break;
    case itNoise :
      Memo1->Lines->Add ("Interference: Noise");
      break;
    case itTooLoud :
      Memo1->Lines->Add ("Interference: Too Loud");
      break;
    case itTooQuiet :
      Memo1->Lines->Add ("Interference: Too Quiet");
      break;
    case itUnknown :
      Memo1->Lines->Add ("Interference: Unknown");
      break;
  }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1PhraseFinish(TObject *Sender,
      const AnsiString Phrase)
{
  Memo1->Lines->Add ("The user said " + Phrase);
}
//---------------------------------------------------------------------------


void __fastcall TForm1::ApdSapiEngine1SRWarning(TObject *Sender, DWORD Error,
      const AnsiString Details, const AnsiString Message)
{
  Memo1->Lines->Add ("Speech Recognition Warning: " + Message);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1SSError(TObject *Sender, DWORD Error,
      const AnsiString Details, const AnsiString Message)
{
  Memo1->Lines->Add ("Speech Synthesis Error: " + Message);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1SSWarning(TObject *Sender, DWORD Error,
      const AnsiString Details, const AnsiString Message)
{
  Memo1->Lines->Add ("Speech Synthesis Warning: " + Message);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1SRError(TObject *Sender, DWORD Error,
      const AnsiString Details, const AnsiString Message)
{
  Memo1->Lines->Add ("Speech Recognition Error: " + Message);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormCreate(TObject *Sender)
{
  if (ApdSapiEngine1->IsSapi4Installed() == false)
  {
    ShowMessage ("SAPI 4 is not installed. This example will now exit.");
    Application->Terminate();
  }    
}
//---------------------------------------------------------------------------

