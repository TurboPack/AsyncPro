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
/*                      ExRecrd0.cpp                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include <stdio.h>

#include "ExRecrd0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdTapi"
#pragma link "AdProtcl"
#pragma link "OoMisc"
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
  CallCount = 0;
  ApdTapiDevice1->MonitorRecording = Monitor->Checked;
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
    MessageDlg("The Selected device does not support Voice Extensions->",
      mtInformation, TMsgDlgButtons() << mbOK, 0);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::CancelCallClick(TObject *Sender)
{
  ApdTapiDevice1->CancelCall();
  CallerID->Text = "";
  CallerIDName->Text = "";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiConnect(TObject *Sender)
{
  CancelCall->Enabled = true;
  CurrentState = StateGreeting;
  Label4->Caption = "Playing Greeting";
  ApdTapiDevice1->PlayWaveFile("..\\RecGreet.wav");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiWaveNotify(TObject *CP,
  TWaveMessage Msg)
{
  char S[100];
  char FileName[256];
  char TempDir[256];
  switch (Msg) {
    case waDataReady : {
      CallCount++;
      GetTempPath(sizeof(TempDir), TempDir);
      sprintf(FileName, "%sCall%d.wav", TempDir, CallCount);
      ApdTapiDevice1->SaveWaveFile(FileName, true);
      break;
    }
    case waRecordClose : {
      sprintf(S, "%d. From: %s (%s) at %s", CallCount,
        CallerIDName->Text.c_str(),
        CallerID->Text.c_str(), Now().DateTimeString().c_str());
      CallsListBox->Items->AddObject(S, (TObject*)CallCount);
      int width = CallsListBox->Canvas->TextWidth(S);
      if (width > CallsListBox->Width)
        PostMessage(CallsListBox->Handle,
          LB_SETHORIZONTALEXTENT, (WPARAM)width, 0);
      ApdTapiDevice1->CancelCall();
      while (ApdTapiDevice1->TapiState != tsIdle)
        Application->ProcessMessages();
      ApdTapiDevice1->AutoAnswer();
      CurrentState = StateIdle;
      Label4->Caption = "Waiting for Call";
      break;
    }
    case waPlayClose :
      switch (CurrentState) {
        case StateGreeting : {
          CurrentState = StateBeeping;
          ApdTapiDevice1->PlayWaveFile("..\\beep.wav");
          return;
        }
        case StateBeeping : {
          CurrentState = StateRecording;
          ApdTapiDevice1->MaxMessageLength = MaxLengthEdit->Text.ToInt();
          ApdTapiDevice1->StartWaveRecord();
          Label4->Caption = "Recording Incoming Message";
          break;
        }
        case StatePlayback : {
          CurrentState = StateIdle;
          ApdTapiDevice1->UseSoundCard = false;
          Screen->Cursor = crDefault;
          Label4->Caption = "Waiting For Call";
        }
      }
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::CallsListBoxDblClick(TObject *Sender)
{
  PlayBackMessage();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiCallerID(TObject *CP, AnsiString ID,
  AnsiString IDName)
{
  CallerID->Text = ID;
  CallerIDName->Text = IDName;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::MaxLengthEditExit(TObject *Sender)
{
  try {
    ApdTapiDevice1->MaxMessageLength = MaxLengthEdit->Text.ToInt();
  }
  catch (EConvertError& E) {
      Application->ShowException(&E);
      MaxLengthEdit->SetFocus();
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::CallsListBoxKeyDown(TObject *Sender, WORD &Key,
  TShiftState Shift)
{
  switch (Key) {
    case VK_DELETE : {
      CallsListBox->Items->Delete(CallsListBox->ItemIndex);
      break;
    }
    case VK_RETURN :
      PlayBackMessage();
  }
}
//---------------------------------------------------------------------------
void TForm1::PlayBackMessage()
{
  char FileName[256];
  char TempDir[256];
  Label4->Caption = "Playing Message";
  int CallNum = (int)CallsListBox->Items->Objects[CallsListBox->ItemIndex];
  GetTempPath(sizeof(TempDir), TempDir);
  sprintf(FileName, "%sCall%d.wav", TempDir, CallNum);
  ApdTapiDevice1->UseSoundCard = true;
  ApdTapiDevice1->PlayWaveFile(FileName);
  Screen->Cursor = crHourGlass;
  CurrentState = StatePlayback;
}

void __fastcall TForm1::Delete1Click(TObject *Sender)
{
  CallsListBox->Items->Delete(CallsListBox->ItemIndex);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::PopupMenu1Popup(TObject *Sender)
{
  Play1->Enabled = (CallsListBox->Items->Count > 0) &&
                   (CallsListBox->ItemIndex != -1);
  Delete1->Enabled = Play1->Enabled;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::MonitorClick(TObject *Sender)
{
  ApdTapiDevice1->MonitorRecording = Monitor->Checked;
}
//---------------------------------------------------------------------------
