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
/*                      PERCENT.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "Percent.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TPercentForm *PercentForm;
//---------------------------------------------------------------------------
__fastcall TPercentForm::TPercentForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TPercentForm::OkBtnClick(TObject *Sender)
{
	int Tmp;

  ModalResult = mrNone;
	try {
    Tmp = PercentEdit->Text.ToInt();
    if ((Tmp < 25) || (Tmp > 400)) {
      MessageDlg("You must enter a percentage between 25 and 400.",
        mtError, TMsgDlgButtons() << mbOK, 0);
      PercentEdit->SetFocus();
      return;
    }
  }
  catch (EConvertError&) {
    MessageDlg("You must enter a number here.",
      mtError, TMsgDlgButtons() << mbOK, 0);
    PercentEdit->SetFocus();
    return;
  }

  ModalResult = mrOk;
}
//---------------------------------------------------------------------------
