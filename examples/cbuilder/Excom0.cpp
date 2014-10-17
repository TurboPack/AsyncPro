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
/*                      EXCOM0.CPP                       */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "Excom0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::TestClick(TObject *Sender)
{
  ApdComPort1->Output = "ATZ\r";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdComPort1TriggerAvail(TObject *CP, WORD Count)
{
  char C;
  String S;
  S = "";
  for (int I=1;I<Count+1;I++) {
    C = ApdComPort1->GetChar();
    if (C > 31)
    	S = S + C;
  }
  ShowMessage("Got an OnTriggerAvail event for: " + S);
}
//---------------------------------------------------------------------------
