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
/*                      EXZRECV0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "exzrecv0.h"
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
  ZModemHandle = ApdComPort1->AddDataTrigger("rz\r",false);
  AdTerminal1->Active = true;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdComPort1TriggerData(TObject *CP, WORD TriggerHandle)
{
  if (TriggerHandle == ZModemHandle) {
    ApdComPort1->RemoveTrigger(ZModemHandle);
    AdTerminal1->Active = false;
    ApdProtocol1->StartReceive();
  }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button1Click(TObject *Sender)
{
  ApdTapiDevice1->AutoAnswer();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdTapiDevice1TapiPortOpen(TObject *Sender)
{
  ZModemHandle = ApdComPort1->AddDataTrigger("rz\r",false);        
}
//---------------------------------------------------------------------------

