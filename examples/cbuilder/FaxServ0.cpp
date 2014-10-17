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
/*                      FaxServ0.cpp                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "FaxServ0.h"
//---------------------------------------------------------------------------
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
void __fastcall TForm1::AmNotifyFaxAvailable(TMessage& Message)
{
  char Buffer[255];
  JobAtom = (Word)Message.LParam;
  GlobalGetAtomName(JobAtom, Buffer, sizeof(Buffer));
  String S = Buffer;
  int P = S.Pos(27);
  ApdSendFax1->FaxFile = S.SubString(P + 1, 255);
  lblState->Caption = "Sending " + S.SubString(1, P - 1);
  edtPhoneNo->Visible = true;
  edtPhoneNo->Enabled = true;
  btnSend->Enabled = true;
  Label2->Visible = true;
  ClientWnd = (HWND)Message.WParam;
}

void __fastcall TForm1::btnSendClick(TObject *Sender)
{
  ApdSendFax1->PhoneNumber = edtPhoneNo->Text;
  ApdSendFax1->StartTransmit();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSendFax1FaxFinish(TObject *CP, int ErrorCode)
{
  edtPhoneNo->Enabled = false;
  btnSend->Enabled = false;
  Label2->Visible = false;
  edtPhoneNo->Visible = false;
  lblState->Caption = "Idle";
  int Pending = SendMessage(ClientWnd, Am_QueryPending, 0, 0);
  PostMessage(ClientWnd, Am_NotifyFaxSent, 0, JobAtom);
  if (Pending <= 1)
    Close();
}
//---------------------------------------------------------------------------
