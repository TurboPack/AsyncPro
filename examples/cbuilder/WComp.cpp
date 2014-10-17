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
/*                      WCOMP.CPP                        */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "WComp.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TWhitespaceCompForm *WhitespaceCompForm;
//---------------------------------------------------------------------------
__fastcall TWhitespaceCompForm::TWhitespaceCompForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TWhitespaceCompForm::CompEnabledBoxClick(TObject *Sender)
{
  FromEdit->Enabled = CompEnabledBox->Checked;
  ToEdit->Enabled   = CompEnabledBox->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TWhitespaceCompForm::OkBtnClick(TObject *Sender)
{
  ModalResult = mrNone;

  if (CompEnabledBox->Checked) {
    try {
      FromEdit->Text.ToInt() != 0;
    }
    catch (EConvertError&) {
      MessageDlg("You must enter a number here.",
        mtError, TMsgDlgButtons() << mbOK, 0);
      FromEdit->SetFocus();
      return;
    }

    try {
      ToEdit->Text.ToInt();
    }
    catch (EConvertError&) {
      MessageDlg("You must enter a number here.",
        mtError, TMsgDlgButtons() << mbOK, 0);
      FromEdit->SetFocus();
      return;
    }
  }

  ModalResult = mrOk;
}
//---------------------------------------------------------------------------
