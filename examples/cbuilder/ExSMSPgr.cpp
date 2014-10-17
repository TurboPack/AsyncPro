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
/*                      ExSMSPgr.cpp                     */
/*********************************************************/

/* This is a simple example that demonstrates how to
   use the TApdGSMComponent and your GSM compatable phone
   to send an SMS message from your PC through a cable
   adapter.
*/

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "ExSMSPgr.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdGSM"
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma link "adgsm"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnSendClick(TObject *Sender)
{
  ApdGSMPhone1->SMSAddress = edtDestAddr->Text;
  ApdGSMPhone1->SMSMessage = memMessage->Text;
  ListBox1->Items->Add("Preparing to send message");
  ApdGSMPhone1->SendSMSMessage();
  ListBox1->Items->Add("Message was sent");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdGSMPhone1GSMComplete(TApdCustomGSMPhone *Pager,
      TGSMStates State, int ErrorCode)
{
 if (State == gsNone)
 {
   ApdComPort1->AddStringToLog("Successful Command");
   ListBox1->Items->Add("Successful Command");
 }
 else
 {
    ApdComPort1->AddStringToLog("Command Failure");
    ListBox1->Items->Add("Command Failure");
 }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::memMessageChange(TObject *Sender)
{
  int I = memMessage->Text.Length();
   Label4->Caption = "Character count: " + IntToStr(I);
}
//---------------------------------------------------------------------------
