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
#include <vcl\vcl.h>
#pragma hdrstop

#include "FxClnt0.h"
#include "Fxjobdlg.hpp"
//---------------------------------------------------------------------------
#pragma link "AdFaxSrv"
#pragma link "OoMisc"
#pragma link "AdFaxCtl"
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
  ClearControls();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ClearControls()
{
  edtCoverFileName->Text = "";
  edtFaxFileName->Text = "";
  edtHeaderLine->Text = "";
  edtHeaderRecipient->Text = "";
  edtHeaderTitle->Text = "";
  edtJobName->Text = "";
  edtPhoneNumber->Text = "";
  edtScheduledDT->Text = "";
  edtSender->Text = "";     
  edtJobFileName->Enabled = true;
  edtJobFileName->Text = "";
}
void __fastcall TForm1::ApdFaxDriverInterface1DocEnd(TObject *Sender)
{
  edtFaxFileName->Text = ApdFaxDriverInterface1->FileName;
  edtHeaderTitle->Text = ApdFaxDriverInterface1->DocName;
  edtJobName->Text = ApdFaxDriverInterface1->DocName;
  edtFaxFileName->Enabled = false;
  edtScheduledDT->Text = DateTimeToStr(Now());
  Show();
  Application->Restore();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnMakeJobClick(TObject *Sender)
{
  ApdFaxClient1->CoverFileName = edtCoverFileName->Text;
  ApdFaxClient1->FaxFileName = edtFaxFileName->Text;
  ApdFaxClient1->HeaderLine = edtFaxFileName->Text;
  ApdFaxClient1->HeaderRecipient = edtHeaderRecipient->Text;
  ApdFaxClient1->HeaderTitle = edtHeaderTitle->Text;
  ApdFaxClient1->JobName = edtJobName->Text;
  ApdFaxClient1->PhoneNumber = edtPhoneNumber->Text;
  ApdFaxClient1->Sender = edtSender->Text;
  ApdFaxClient1->JobFileName = edtJobFileName->Text;
  ApdFaxClient1->MakeFaxJob();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnAddRecipientClick(TObject *Sender)
{
  ApdFaxClient1->CoverFileName = edtCoverFileName->Text;
  ApdFaxClient1->FaxFileName = edtFaxFileName->Text;
  ApdFaxClient1->HeaderLine = edtFaxFileName->Text;
  ApdFaxClient1->HeaderRecipient = edtHeaderRecipient->Text;
  ApdFaxClient1->HeaderTitle = edtHeaderTitle->Text;
  ApdFaxClient1->JobName = edtJobName->Text;
  ApdFaxClient1->PhoneNumber = edtPhoneNumber->Text;
  ApdFaxClient1->Sender = edtSender->Text;
  ApdFaxClient1->JobFileName = edtJobFileName->Text;
  // the ApdFaxClient->AddFaxRecipient isn't implemented yet, using the AddRecipient
  //  method inherited from TApdFaxJobHandler
  ApdFaxClient1->AddRecipient(edtJobFileName->Text, ApdFaxClient1->Recipient);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnJobInfoDialogClick(TObject *Sender)
{
  ApdFaxClient1->ShowFaxJobInfoDialog(edtJobFileName->Text, edtJobName->Text);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnJobDesignerClick(TObject *Sender)
{
  TFaxJobDesigner* JobDesigner = new TFaxJobDesigner(this);
  JobDesigner->ShowModal();
  delete JobDesigner;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnClearClick(TObject *Sender)
{
  ClearControls();	
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnExitClick(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
