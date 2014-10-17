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
/*                      EXZSEND0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "exzsend0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdProtcl"
#pragma link "AdPStat"
#pragma link "OoMisc"
#pragma link "ADTrmEmu"
#pragma link "AdTapi"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdProtocol1ProtocolFinish(TObject *CP, int ErrorCode)
{
  AdTerminal1->Active = true;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  // dial to create the data connection
  ApdTapiDevice1->Dial(Edit1->Text);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiPortOpen(TObject *Sender)
{
  // a data connection was established, start the transfer
  // note that you usually want to authenticate before transmitting
  ApdProtocol1->StartTransmit();
  AdTerminal1->Active = false;        
}
//---------------------------------------------------------------------------

