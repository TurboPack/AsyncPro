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

/***************************************************************************/
/*                             ExSMSMess0.cpp                              */
/***************************************************************************/

/* This is a simple example that demonstrates how to connect to a GSM phone
   using Async Professional.  This application uses the TApdGSMPhone and the
   TApdComport components.  Then you can add a SMS message to the phones
   message store and be able to send a message from the message store passing
   the index of that message.
*/

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "ExSMSMs0.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdGSM"
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma link "ADTrmEmu"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnConnectClick(TObject *Sender)
{
  ApdGSMPhone1->Connect ();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnAddMessageClick(TObject *Sender)
{
  // Add message to memory
  ApdGSMPhone1->WriteToMemory (Edit1->Text, Memo1->Text);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdGSMPhone1GSMComplete(TApdCustomGSMPhone *Pager,
      TGSMStates State, int ErrorCode)
{
  if (ErrorCode != 0)
    ShowMessage("Error " + IntToStr(ErrorCode));
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Send1Click(TObject *Sender)
{
  int StoreIndex = TreeView1->Selected->AbsoluteIndex;
  int PhoneIndex =
          ApdGSMPhone1->MessageStore->Messages[StoreIndex]->MessageIndex;
  if (PhoneIndex > -1)
    ApdGSMPhone1->SendFromMemory (PhoneIndex);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Delete1Click(TObject *Sender)
{
  int StoreIndex = TreeView1->Selected->AbsoluteIndex;
  int PhoneIndex =
           ApdGSMPhone1->MessageStore->Messages[StoreIndex]->MessageIndex;
  if (PhoneIndex > -1)
    ApdGSMPhone1->MessageStore->Delete(PhoneIndex);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdGSMPhone1MessageList(TObject *Sender)
{
  TTreeNode *Node1;
  TreeView1->Items->Clear ();
  for (int i = 0; i < ApdGSMPhone1->MessageStore->Count; i++) {
    if (ApdGSMPhone1->MessageStore->Messages[i]->TimeStampStr == "")
      ApdGSMPhone1->MessageStore->Messages[i]->TimeStampStr =
        "< No Timestamp Index = >" + IntToStr(i);
    Node1 = TreeView1->Items->Add (NULL,
        ApdGSMPhone1->MessageStore->Messages[i]->TimeStampStr);
    TreeView1->Items->AddChild (Node1,
        "Index " +
        IntToStr(ApdGSMPhone1->MessageStore->Messages[i]->MessageIndex));
    TreeView1->Items->AddChild (Node1,
        ApdGSMPhone1->MessageStore->Messages[i]->Address);
    TreeView1->Items->AddChild (Node1,
        ApdGSMPhone1->MessageStore->Messages[i]->Message);
    TreeView1->Items->AddChild (Node1,
        ApdGSMPhone1->MessageStore->Messages[i]->Name);
    TreeView1->Items->AddChild (Node1,
        ApdGSMPhone1->StatusToStr(
            ApdGSMPhone1->MessageStore->Messages[i]->Status));
  }
}
//---------------------------------------------------------------------------


void __fastcall TForm1::TreeView1DblClick(TObject *Sender)
{
  TApdSMSMessage *Msg;
  int i = TreeView1->Selected->AbsoluteIndex;
  Msg = ApdGSMPhone1->MessageStore->Messages[i];
  Edit1->Text = Msg->Address;
  Edit2->Text = Msg->TimeStampStr;
  Edit3->Text = ApdGSMPhone1->StatusToStr (Msg->Status);
  edtIndex->Text = IntToStr (Msg->MessageIndex);
  Memo1->Lines->Text = Msg->Message;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::TreeView1KeyDown(TObject *Sender, WORD &Key,
      TShiftState Shift)
{
  if (Key == VK_DELETE)
    if (TreeView1->Selected->AbsoluteIndex > -1)
      ApdGSMPhone1->MessageStore->Delete (TreeView1->Selected->AbsoluteIndex);
}
//---------------------------------------------------------------------------



