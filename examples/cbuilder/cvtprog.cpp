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
/*                      cvtprog.cpp                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "cvtprog.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdFaxCvt"
#pragma link "AdMeter"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TCvtProgressForm *CvtProgressForm;

void __fastcall TCvtProgressForm::ConvertFiles(TMessage& Msg)
{
  int I;
  String Ext;
  CancelClicked = false;
  for (I=0;I<ConvertList->Items->Count;I++) {
    ConvertList->ItemIndex = I;
    Ext = ExtractFileExt(ConvertList->Items->Strings[I]);
    if (Ext == ".bmp")
      FaxConverter->InputDocumentType = idBmp;
    else if (Ext == ".dcx")
      FaxConverter->InputDocumentType = idDcx;
    else if (Ext == ".pcx")
      FaxConverter->InputDocumentType = idPcx;
    else if (Ext == ".txt") {
      if (UseEnhancedText)
        FaxConverter->InputDocumentType = idTextEx;
      else
        FaxConverter->InputDocumentType = idText;
    }
    else if (Ext == ".tif")
      FaxConverter->InputDocumentType = idTiff;
    else
      continue;
    FaxConverter->DocumentFile = ConvertList->Items->Strings[I];

    try {
      FaxConverter->ConvertToFile();
    }
    catch (EConvertAbort&) { }
    catch (Exception& E) {
      MessageDlg("Error: " + E.Message,
        mtError, TMsgDlgButtons() << mbOK, 0);
    }
    if (CancelClicked) {
      break;
    }
  }
  if (!CancelClicked)
    ModalResult = mrOk;
}

//---------------------------------------------------------------------------
__fastcall TCvtProgressForm::TCvtProgressForm(TComponent* Owner)
  : TForm(Owner)
{
  CvtGauge = new TApdMeter(this);
  CvtGauge->Parent = this;
  CvtGauge->Left = 16;
  CvtGauge->Top = 272;
  CvtGauge->Width = 273;
  CvtGauge->Height = 20;
}
//---------------------------------------------------------------------------
void __fastcall TCvtProgressForm::FormShow(TObject *Sender)
{
  if (!Shown) {
    Shown = true;
    PostMessage(Handle, WM_USERMSG, 0, 0);
  }
}
//---------------------------------------------------------------------------
void __fastcall TCvtProgressForm::CancelBtnClick(TObject *Sender)
{
  CancelClicked = true;
}
//---------------------------------------------------------------------------
void __fastcall TCvtProgressForm::FormClose(TObject *Sender,
  TCloseAction &Action)
{
  Shown = false;
}
//---------------------------------------------------------------------------



void __fastcall TCvtProgressForm::FaxConverterStatus(TObject *F,
      bool Starting, bool Ending, int PagesConverted, int LinesConverted,
      int BytesConverted, int BytesToConvert, bool &Abort)
{
  Abort = CancelClicked;
  if (Abort)
    ModalResult = mrCancel;
  if (BytesToConvert != 0)
    CvtGauge->Position = (BytesConverted * 100)/BytesToConvert;
}
//---------------------------------------------------------------------------

