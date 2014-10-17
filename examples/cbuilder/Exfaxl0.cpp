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
/*                      EXFAXL0.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "Exfaxl0.h"
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
  FaxList = new TStringList;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::AddFilesClick(TObject *Sender)
{
  FaxList->Add("471-9091^..\\APROLOGO.APF");
  FaxList->Add("471-9091^..\\APROLOGO.APF");
  FaxIndex = 0;
  ShowMessage("Fax files added!");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::SendFaxClick(TObject *Sender)
{
  ApdSendFax1->StartTransmit();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSendFax1FaxNext(TObject *CP,
      AnsiString &APhoneNumber, AnsiString &AFaxFile,
      AnsiString &ACoverFile)
{
  String S;
  int CaretPos;
  try {
    S = FaxList->Strings[FaxIndex];
    CaretPos = S.Pos("^");
    APhoneNumber = S.SubString(1, CaretPos-1);
    AFaxFile = S.SubString(CaretPos+1, 255);
    ACoverFile = "";
    FaxIndex++;
  }
  catch (...) {
    APhoneNumber = "";
    AFaxFile = "";
    ACoverFile = "";
  }        
}
//---------------------------------------------------------------------------

