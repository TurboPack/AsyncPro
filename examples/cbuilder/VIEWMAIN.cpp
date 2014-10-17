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
/*                      VIEWMAIN.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include <stdio.h>

#include "ViewMain.h"
#include "Percent.h"
#include "WComp.h"
//---------------------------------------------------------------------------
#pragma link "AdFView"
#pragma link "AdFaxPrn"
#pragma link "AdFPStat"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TMainForm *MainForm;
//---------------------------------------------------------------------------
__fastcall TMainForm::TMainForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void TMainForm::UpdateViewPercent(const int NewPercent)
{
  if (NewPercent == ViewPercent)
    return;

  ViewPercent = NewPercent;

  if (NewPercent == 100)
    FaxViewer->Scaling = false;
  else {
    FaxViewer->BeginUpdate();
    FaxViewer->Scaling   = true;
    FaxViewer->HorizMult = NewPercent;
    FaxViewer->HorizDiv  = 100;
    FaxViewer->VertMult  = NewPercent;
    FaxViewer->VertDiv   = 100;
    FaxViewer->EndUpdate();
  }

  UncheckZoomChoices();
  switch (ViewPercent) {
    case 25 : N25PercentItem->Checked  = true; break;
    case 50 : N50PercentItem->Checked  = true; break;
    case 75 : N75PercentItem->Checked  = true; break;
    case 100: N100PercentItem->Checked = true; break;
    case 200: N200PercentItem->Checked = true; break;
    case 400: N400PercentItem->Checked = true; break;
    default :
      OtherSizeItem->Checked = true;
  }
}

void TMainForm::EnableZoomChoices()
{
  N25PercentItem->Enabled  = true;
  N50PercentItem->Enabled  = true;
  N75PercentItem->Enabled  = true;
  N100PercentItem->Enabled = true;
  N200PercentItem->Enabled = true;
  N400PercentItem->Enabled = true;
  OtherSizeItem->Enabled   = true;
  ZoomInItem->Enabled      = true;
  ZoomOutItem->Enabled     = true;
}

void TMainForm::DisableZoomChoices()
{
  N25PercentItem->Enabled  = false;
  N50PercentItem->Enabled  = false;
  N75PercentItem->Enabled  = false;
  N100PercentItem->Enabled = false;
  N200PercentItem->Enabled = false;
  N400PercentItem->Enabled = false;
  OtherSizeItem->Enabled   = false;
  ZoomInItem->Enabled      = false;
  ZoomOutItem->Enabled     = false;
}

void TMainForm::UncheckZoomChoices()
{
  N25PercentItem->Checked  = false;
  N50PercentItem->Checked  = false;
  N75PercentItem->Checked  = false;
  N100PercentItem->Checked = false;
  N200PercentItem->Checked = false;
  N400PercentItem->Checked = false;
  OtherSizeItem->Checked   = false;
}

void TMainForm::EnableRotationChoices()
{
  NoRotateItem->Enabled  = true;
  Rotate90Item->Enabled  = true;
  Rotate180Item->Enabled = true;
  Rotate270Item->Enabled = true;
}

void TMainForm::DisableRotationChoices()
{
  NoRotateItem->Enabled  = false;
  Rotate90Item->Enabled  = false;
  Rotate180Item->Enabled = false;
  Rotate270Item->Enabled = false;
}

void TMainForm::UncheckRotationChoices()
{
  NoRotateItem->Checked  = false;
  Rotate90Item->Checked  = false;
  Rotate180Item->Checked = false;
  Rotate270Item->Checked = false;
}

void __fastcall TMainForm::OpenItemClick(TObject *Sender)
{
  if (OpenDialog->Execute()) {
    OpenFile(OpenDialog->FileName);
  }
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::PrintSetupItemClick(TObject *Sender)
{
  FaxPrinter->PrintSetup();
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::PrintItemClick(TObject *Sender)
{
  if (FaxViewer->FileName != "") {
    FaxPrinter->FileName = FaxViewer->FileName;
    FaxPrinter->PrintFax();
  }
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ExitItemClick(TObject *Sender)
{
	Close();
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ZoomInItemClick(TObject *Sender)
{
  int TempPercent;

  if ((ViewPercent % 25) == 0)
    TempPercent = ViewPercent + 25;
  else
    TempPercent = ViewPercent + (25 - (ViewPercent % 25));
  if (TempPercent > 400) {
    MessageBeep(0);
    return;
  }
  UpdateViewPercent(TempPercent);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ZoomOutItemClick(TObject *Sender)
{
  int TempPercent;

  if ((ViewPercent % 25) == 0)
    TempPercent = ViewPercent - 25;
  else
    TempPercent = ViewPercent - (25 - (ViewPercent % 25));

  if (TempPercent < 25) {
    MessageBeep(0);
    return;
  }
  UpdateViewPercent(TempPercent);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::N25PercentItemClick(TObject *Sender)
{
  UpdateViewPercent(25);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::N50PercentItemClick(TObject *Sender)
{
  UpdateViewPercent(50);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::N75PercentItemClick(TObject *Sender)
{
  UpdateViewPercent(75);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::N100PercentItemClick(TObject *Sender)
{
  UpdateViewPercent(100);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::N200PercentItemClick(TObject *Sender)
{
  UpdateViewPercent(200);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::N400PercentItemClick(TObject *Sender)
{
  UpdateViewPercent(400);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::OtherSizeItemClick(TObject *Sender)
{
  TPercentForm* Frm = new TPercentForm(this);
  int TempPercent;

  Frm->ShowModal();
  if (Frm->ModalResult == mrOk)
    TempPercent = Frm->PercentEdit->Text.ToInt();
  else
    TempPercent = -1;
  delete Frm;

  if (TempPercent != -1) 
    UpdateViewPercent(TempPercent);
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::WhitespaceCompOptionClick(TObject *Sender)
{
  TWhitespaceCompForm* Frm = new TWhitespaceCompForm(this);
  int Tmp;

  Frm->CompEnabledBox->Checked = FaxViewer->WhitespaceCompression;
  if (FaxViewer->WhitespaceCompression) {
    Frm->FromEdit->Text = String((int)FaxViewer->WhitespaceFrom);
    Frm->ToEdit->Text   = String((int)FaxViewer->WhitespaceTo);
  }

  if (Frm->ShowModal() == mrOk) {
    FaxViewer->WhitespaceCompression = Frm->CompEnabledBox->Checked;
    if (FaxViewer->WhitespaceCompression) {
      Tmp = Frm->FromEdit->Text.ToInt();
      FaxViewer->WhitespaceFrom = Tmp;
      Tmp = Frm->ToEdit->Text.ToInt();
      FaxViewer->WhitespaceTo = Tmp;
    }
  }
  delete Frm;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::SelectAllItemClick(TObject *Sender)
{
  FaxViewer->SelectImage();
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::CopyItemClick(TObject *Sender)
{
  FaxViewer->CopyToClipBoard();
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::NoRotateItemClick(TObject *Sender)
{
  FaxViewer->Rotation = vr0;
  UncheckRotationChoices();
  NoRotateItem->Checked = true;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::Rotate90ItemClick(TObject *Sender)
{
  FaxViewer->Rotation = vr90;
  UncheckRotationChoices();
  Rotate90Item->Checked = true;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::Rotate180ItemClick(TObject *Sender)
{
  FaxViewer->Rotation = vr180;
  UncheckRotationChoices();
  Rotate180Item->Checked = true;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::Rotate270ItemClick(TObject *Sender)
{
  FaxViewer->Rotation = vr270;
  UncheckRotationChoices();
  Rotate270Item->Checked = true;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::FormCreate(TObject *Sender)
{
  NextPage->Enabled = false;
  PrevPage->Enabled = false;
  ViewPercent = 100;
  DisableZoomChoices();
  SelectAllItem->Enabled = false;
  CopyItem->Enabled = false;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::FaxViewerPageChange(TObject *Sender)
{
  if (FaxViewer->FileName != "") {
    char buff[MAX_PATH + 30];
    sprintf(buff, "  Viewing page %d of %d in %s",
      FaxViewer->ActivePage, FaxViewer->NumPages, FaxViewer->FileName.c_str());
    StatusBar->SimpleText    = buff;
  }
  else
    StatusBar->SimpleText = "  No file loaded";
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::FaxViewerViewerError(TObject *Sender, int ErrorCode)
{
  MessageDlg("Viewer Error", mtError, TMsgDlgButtons() << mbOK, 0);
}
//---------------------------------------------------------------------------
void TMainForm::OpenFile(String FileName)
{
  FaxViewer->BeginUpdate();
  FaxViewer->Scaling   = false;
  FaxViewer->HorizMult = 1;
  FaxViewer->HorizDiv  = 1;
  FaxViewer->VertMult  = 1;
  FaxViewer->VertDiv   = 1;
  FaxViewer->EndUpdate();
  UncheckZoomChoices();
  UncheckRotationChoices();
  try {
    FaxViewer->FileName = OpenDialog->FileName;
    EnableZoomChoices();
    EnableRotationChoices();
    SelectAllItem->Enabled   = true;
    CopyItem->Enabled        = true;
    N100PercentItem->Checked = true;
    NoRotateItem->Checked    = true;
    ViewPercent              = 100;
    char buff[MAX_PATH + 30];
    sprintf(buff, "  Viewing page 1 of %d in %s",
      FaxViewer->NumPages, FaxViewer->FileName.c_str());
    StatusBar->SimpleText    = buff;
    NextPage->Enabled = true;
    PrevPage->Enabled = true;
  }
  catch (...) {
    CloseFile();
    MessageDlg("Error opening fax file",
      mtError, TMsgDlgButtons() << mbOK, 0);
  }
}

void TMainForm::CloseFile()
{
  FaxViewer->FileName = "";
  DisableZoomChoices();
  DisableRotationChoices();
  SelectAllItem->Enabled = false;
  CopyItem->Enabled      = false;
  StatusBar->SimpleText = "  No file loaded";
  FaxViewer->Invalidate();
  NextPage->Enabled = false;
  PrevPage->Enabled = false;
}

void __fastcall TMainForm::CloseItemClick(TObject *Sender)
{
  CloseFile();
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::NextPageClick(TObject *Sender)
{
  if (FaxViewer->ActivePage < FaxViewer->NumPages)
    FaxViewer->ActivePage++;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::PrevPageClick(TObject *Sender)
{
  if (FaxViewer->ActivePage > 1)
    FaxViewer->ActivePage--;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::FaxViewerDropFile(TObject *Sender,
  AnsiString FileName)
{
  EnableZoomChoices();
  EnableRotationChoices();
  SelectAllItem->Enabled   = true;
  CopyItem->Enabled        = true;
  N100PercentItem->Checked = true;
  NoRotateItem->Checked    = true;
  ViewPercent              = 100;
  char buff[MAX_PATH + 30];
  sprintf(buff, "  Viewing page 1 of %d in %s",
    FaxViewer->NumPages, FaxViewer->FileName.c_str());
  StatusBar->SimpleText    = buff;
  NextPage->Enabled = true;
  PrevPage->Enabled = true;
}
//---------------------------------------------------------------------------
