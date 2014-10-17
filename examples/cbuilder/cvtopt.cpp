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
/*                      cvtopt.cpp                       */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "cvtopt.h"
#include "cvtprog.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TCvtOptionsForm *CvtOptionsForm;
//---------------------------------------------------------------------------
__fastcall TCvtOptionsForm::TCvtOptionsForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TCvtOptionsForm::OkBtnClick(TObject *Sender)
{
  try {
    CvtProgressForm->FaxConverter->LinesPerPage = StrToInt(LinesPerPageEdit->Text);
  }
  catch (...) {
    MessageDlg("You must enter a number here.",
      mtError, TMsgDlgButtons() << mbOK, 0);
    LinesPerPageEdit->SetFocus();
    return;
  }
  CvtProgressForm->FaxConverter->Options << coDoubleWidth << coCenterImage << coYieldOften;
  switch (ScalingRadioGroup->ItemIndex) {
    case 0 : CvtProgressForm->FaxConverter->Options >> coDoubleWidth; break;
    case 2 : {
      CvtProgressForm->FaxConverter->Options << coHalfHeight;
      CvtProgressForm->FaxConverter->Options >> coDoubleWidth;
      break;
    }
  }
  if (PositionRadioGroup->ItemIndex == 1)
    CvtProgressForm->FaxConverter->Options << coCenterImage;
}
//---------------------------------------------------------------------------
void __fastcall TCvtOptionsForm::ResolutionRadioGroupClick(TObject *Sender)
{
  switch (ResolutionRadioGroup->ItemIndex) {
    case 0 : ScalingRadioGroup->Enabled = true; break;
    case 1 : ScalingRadioGroup->Enabled = false; break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TCvtOptionsForm::FormCreate(TObject *Sender)
{
  LinesPerPageEdit->Text = IntToStr(CvtProgressForm->FaxConverter->LinesPerPage);

  ResolutionRadioGroup->ItemIndex = CvtProgressForm->FaxConverter->Resolution;
  WidthRadioGroup->ItemIndex      = CvtProgressForm->FaxConverter->Width;
  FontRadioGroup->ItemIndex       = CvtProgressForm->FaxConverter->FontType;

  if (CvtProgressForm->FaxConverter->Options.Contains(coDoubleWidth))
    ScalingRadioGroup->ItemIndex = 1;
  else if (CvtProgressForm->FaxConverter->Options.Contains(coHalfHeight))
    ScalingRadioGroup->ItemIndex = 2;
  else
    ScalingRadioGroup->ItemIndex = 0;

  if (CvtProgressForm->FaxConverter->Options.Contains(coCenterImage))
    PositionRadioGroup->ItemIndex = 1;
  else
    PositionRadioGroup->ItemIndex = 0;
}
//---------------------------------------------------------------------------
void __fastcall TCvtOptionsForm::EnhTextBoxClick(TObject *Sender)
{
  FntButton->Enabled = EnhTextBox->Checked;
  FontRadioGroup->Enabled = !EnhTextBox->Checked;
  CvtProgressForm->UseEnhancedText = EnhTextBox->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TCvtOptionsForm::FntButtonClick(TObject *Sender)
{
  FontDialog1->Font = CvtProgressForm->FaxConverter->EnhFont;
  if (FontDialog1->Execute())
    CvtProgressForm->FaxConverter->EnhFont = FontDialog1->Font;
}
//---------------------------------------------------------------------------
