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
#include <vcl.h>
#pragma hdrstop

#include "ExSapiD0.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdSapiEn"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSSAboutClick(TObject *Sender)
{
  ApdSapiEngine1->ShowSSAboutDlg ("SS About");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSSGeneralClick(TObject *Sender)
{
  ApdSapiEngine1->ShowSSGeneralDlg ("SS General");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSSLexiconClick(TObject *Sender)
{
  ApdSapiEngine1->ShowSSLexiconDlg ("SS Lexicon");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSSTranslateClick(TObject *Sender)
{
  ApdSapiEngine1->ShowTranslateDlg ("SS Translate");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSRAboutClick(TObject *Sender)
{
  ApdSapiEngine1->ShowSRAboutDlg ("SR About");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSRGeneralClick(TObject *Sender)
{
  ApdSapiEngine1->ShowSRGeneralDlg ("SR General");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSRTrainGeneralClick(TObject *Sender)
{
  ApdSapiEngine1->ShowTrainGeneralDlg ("SR General Training");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSRLexiconClick(TObject *Sender)
{
  ApdSapiEngine1->ShowSRLexiconDlg ("SR Lexicon");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::btnSRTrainMicClick(TObject *Sender)
{
  ApdSapiEngine1->ShowTrainMicDlg ("SR Microphone Training");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  if (ApdSapiEngine1->IsSapi4Installed() == false)
  {
    ShowMessage ("SAPI 4 is not installed. This example will now exit.");
    Application->Terminate();
  }    
}
//---------------------------------------------------------------------------

