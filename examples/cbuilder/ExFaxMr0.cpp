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
/*                      ExFaxMr0.cpp                     */
/*********************************************************/
/*
  To use this example, a phone should be plugged into the 'phone' jack on the
  modem.  Have someone send a fax to you, then pick up the phone handset when
  it rings.  Once you hear the fax tones, click the 'Start Receive' button.
  The phone handset should disconnect, and the modem will receive the fax.
*/  

//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExFaxMr0.h"
//---------------------------------------------------------------------------
#pragma link "AdFax"
#pragma link "AdPort"
#pragma link "AdFStat"
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
  AdTerminal1->Active = false;
  ApdReceiveFax1->StartManualReceive(true);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdReceiveFax1FaxFinish(TObject *CP, int ErrorCode)
{
  AdTerminal1->Active = true;
}
//---------------------------------------------------------------------------
