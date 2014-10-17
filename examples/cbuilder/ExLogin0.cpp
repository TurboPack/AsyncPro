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
/*                      EXLOGIN0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExLogin0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma link "ADTrmEmu"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  // Start the login process, dial...
  ApdComPort1->Output = "atm0dt264-1179\r";
  LoginState = lName;

  // Setup next data trigger
  DataTrig = ApdComPort1->AddDataTrigger("name?", true);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdComPort1TriggerData(TObject *CP, WORD TriggerHandle)
{
  // Got latest data trigger, send next
  ApdComPort1->RemoveTrigger(DataTrig);
  switch (LoginState) {
    case lName : {
      ApdComPort1->Output = "joe blow\r";
      DataTrig = ApdComPort1->AddDataTrigger("password?", true);
      LoginState = lPassword;
      break;
    }
    case lPassword : {
      ApdComPort1->Output = "123\r";
      DataTrig = ApdComPort1->AddDataTrigger("?", true);
      LoginState = lOther;
      break;
    }
    case lOther : {
      ShowMessage("done");
      break;
    }
  }
}
//---------------------------------------------------------------------------
