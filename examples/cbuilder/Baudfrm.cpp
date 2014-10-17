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
/*                      BAUDFRM.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "Baudfrm.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TBaudForm *BaudForm;

void TBaudForm::Init(TModemInfo* Data)
{
  EditData = Data;

  // set initial edit values
  if (EditData->DefBaud != 0)
    BPSEdit->Text = (int)EditData->DefBaud;
  LockDTECheck->Checked = EditData->LockDTE;
}

//---------------------------------------------------------------------------
__fastcall TBaudForm::TBaudForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TBaudForm::OKBtnClick(TObject *Sender)
{
  int L;

  // make sure that a baud rate was entered
  if (BPSEdit->Text == "") {
    BPSEdit->SetFocus();
    ModalResult = mrNone;
    throw(Exception("Please enter a BPS rate"));
  }

  // make sure that the baud rate entered was, in fact, a number
  L = BPSEdit->Text.ToInt();
  if (!L) {
    BPSEdit->SetFocus();
    ModalResult = mrNone;
    throw (Exception("Invalid BPS rate"));
  }

  // make sure that the baud rate entered was in range
  if (L < 300 || L > 57600) {
    BPSEdit->SetFocus();
    ModalResult = mrNone;
    throw(Exception("Valid values are between 300 and 57600"));
  }

  EditData->DefBaud = L;
  EditData->LockDTE = LockDTECheck->Checked;
  ModalResult = mrOk;
}
//---------------------------------------------------------------------------
