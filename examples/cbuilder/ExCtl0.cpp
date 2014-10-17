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
/*                      EXCTL0.CPP                       */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExCtl0.h"
//---------------------------------------------------------------------------
#pragma link "AdFaxCtl"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FaxConvController1DocStart(TObject *Sender)
{
  Memo1->Lines->Add("About to print:" + FaxConvController1->DocName);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FaxConvController1DocEnd(TObject *Sender)
{
  Memo1->Lines->Add("Done printing:" + FaxConvController1->DocName);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  TRegistry* Reg = new TRegistry;
  try {
    Reg->RootKey = HKEY_LOCAL_MACHINE;
    Reg->OpenKey(ApdRegKey, true);
    Reg->WriteString(ApdIniKey, ParamStr(0));
  }
  catch (...) {
    delete Reg;
  }
  delete Reg;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  Close();  
}
//---------------------------------------------------------------------------
