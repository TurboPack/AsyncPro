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

#include "ExVoIP0.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdVoIP"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TfrmExVoIP *frmExVoIP;
//---------------------------------------------------------------------------
__fastcall TfrmExVoIP::TfrmExVoIP(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void TfrmExVoIP::Add(String S)
{
  ListBox1->Items->Add(S);
  StatusBar1->SimpleText = S;
}
//---------------------------------------------------------------------------
void TfrmExVoIP::RefreshDeviceLabels()
{
  cbxEnablePreview->Checked = ApdVoIP1->EnablePreview;
  cbxEnableVideo->Checked = ApdVoIP1->EnableVideo;
  Label5->Caption = ApdVoIP1->AudioInDevice;
  Label6->Caption = ApdVoIP1->AudioOutDevice;
  Label7->Caption = ApdVoIP1->VideoInDevice;
}

void __fastcall TfrmExVoIP::FormShow(TObject *Sender)
{
  btnConnect->Enabled = false;
  btnDisconnect->Enabled = false;
  RefreshDeviceLabels();
  Add("Ready...");
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::btnConnectClick(TObject *Sender)
{
  btnConnect->Enabled = False;
  cbxEnablePreview->Enabled = False;
  cbxEnableVideo->Enabled = False;
  Add("Connecting...");
  ApdVoIP1->Connect(edtAddress->Text);
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::btnAnswerClick(TObject *Sender)
{
  btnAnswer->Enabled = false;
  btnConnect->Enabled = false;
  btnDisconnect->Enabled = true;
  cbxEnablePreview->Enabled = false;
  cbxEnableVideo->Enabled = false;
  Add("Waiting for call...");
  ApdVoIP1->Connect("");
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::btnDisconnectClick(TObject *Sender)
{
  Add("Disconnecting...");
  ApdVoIP1->CancelCall();
  cbxEnablePreview->Enabled = true;
  cbxEnableVideo->Enabled = true;
  btnAnswer->Enabled = true;
  btnConnect->Enabled = edtAddress->Text != "";
  btnDisconnect->Enabled = false;
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::cbxEnablePreviewClick(TObject *Sender)
{
  ApdVoIP1->EnablePreview = cbxEnablePreview->Checked;
  cbxEnableVideo->Checked = ApdVoIP1->EnableVideo;
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::cbxEnableVideoClick(TObject *Sender)
{
  ApdVoIP1->EnableVideo = cbxEnableVideo->Checked;
  // can only preview if video is enabled 
  cbxEnablePreview->Checked = ApdVoIP1->EnablePreview;
  cbxEnablePreview->Enabled = ApdVoIP1->EnableVideo;
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::btnSelectMediaDevicesClick(TObject *Sender)
{
  if (ApdVoIP1->ShowMediaSelectionDialog())
    RefreshDeviceLabels();
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::btnListTerminalsClick(TObject *Sender)
{
  String S;
  TTreeNode *Node1;
  TApdVoIPTerminal *Term;

  TreeView1->Items->Clear();
  for (int I=0;I<ApdVoIP1->AvailableTerminalDevices->Count; I++){
    Term = dynamic_cast<TApdVoIPTerminal*>(ApdVoIP1->AvailableTerminalDevices->Items[I]);
    Node1 = TreeView1->Items->Add(0, Term->DeviceName);

    switch (Term->DeviceClass){
      case dcHandsetTerminal      : S = "Handset";
      case dcHeadsetTerminal      : S = "Headset";
      case dcMediaStreamTerminal  : S = "MediaStream";
      case dcMicrophoneTerminal   : S = "Microphone";
      case dcSpeakerPhoneTerminal : S = "SpeakerPhone";
      case dcSpeakersTerminal     : S = "Speakers";
      case dcVideoInputTerminal   : S = "VideoInput";
      case dcVideoWindowTerminal  : S = "VideoWindow";
    }
    TreeView1->Items->AddChild(Node1, "DeviceClass: " + S);

    switch (Term->MediaDirection){
      case mdCapture : S = "Capture";
      case mdRender  : S = "Render";
      case mdBiDirectional : S = "Bidirectional";
    }
    TreeView1->Items->AddChild(Node1, "MediaDirection: " + S);

    switch (Term->MediaType){
      case mtAudio : S = "Audio";
      case mtVideo : S = "Video";
    }
    TreeView1->Items->AddChild(Node1, "MediaType: " + S);

    switch (Term->TerminalType){
      case ttStatic  : S = "Static";
      case ttDynamic : S = "Dynamic";
    }
    TreeView1->Items->AddChild(Node1, "TerminalType: " + S);

    switch (Term->TerminalState){
      case tsInUse    : S = "In use";
      case tsNotInUse : S = "Not in use";
    }
    TreeView1->Items->AddChild(Node1, "TerminalState: " + S);
  }
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::edtAddressChange(TObject *Sender)
{
  btnConnect->Enabled = (edtAddress->Text != "");
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::edtAddressKeyPress(TObject *Sender, char &Key)
{
  if (Key == '\r')
    PostMessage(btnConnect->Handle, BM_CLICK, 0, 0);
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::ApdVoIP1Connect(TApdCustomVoIP *VoIP)
{
  Add("Connected");
  btnConnect->Enabled = false;
  edtAddress->Enabled = false;
  btnAnswer->Enabled = false;
  btnDisconnect->Enabled = true;
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::ApdVoIP1Disconnect(TApdCustomVoIP *VoIP)
{
  Add("Disconnected");
  Add("Ready...");
  edtAddress->Enabled = true;
  btnConnect->Enabled = (edtAddress->Text != "");
  btnDisconnect->Enabled = false;
  btnAnswer->Enabled = true;
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::ApdVoIP1Fail(TApdCustomVoIP *VoIP,
      int ErrorCode)
{
  Add("Fail : " + IntToStr(ErrorCode));
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::ApdVoIP1IncomingCall(TApdCustomVoIP *VoIP,
      AnsiString CallerAddr, bool &Accept)
{
  Add("Incoming call from : " + CallerAddr);
  Accept = (MessageDlg("'You have an incoming call from " + CallerAddr +
    "\r\nWould you like to accept the call?", mtConfirmation,
    TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes);
  if (Accept)
    Add("Answering Call...");
  else
    Add("Ready...");
}
//---------------------------------------------------------------------------

void __fastcall TfrmExVoIP::ApdVoIP1Status(TApdCustomVoIP *VoIP,
      WORD TapiEvent, WORD Status, WORD SubStatus)
{
  Add("OnStatus");
}
//---------------------------------------------------------------------------

