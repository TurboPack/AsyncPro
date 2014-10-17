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
/*                      EXTRIG0.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "extrig0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdSrMgr"
#pragma link "OoMisc"
#pragma resource "*.dfm"

TExTrigTest *ExTrigTest;

void WriteIt(char C)
{
  if (C > 32)
    cout << C;
  else
    cout << "[" << (int)C << "]" << endl;
}
//---------------------------------------------------------------------------
__fastcall TExTrigTest::TExTrigTest(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TExTrigTest::ApdComPort1TriggerAvail(TObject *CP, WORD Count)
{
  char C;
  cout << "OnTriggerAvail event: " << Count << " bytes received" << endl;
  for (int i=1;i<Count+1;i++) {
    C = ApdComPort1->GetChar();
    WriteIt(C);
  }
  cout << endl << "--------" << endl;
}
//---------------------------------------------------------------------------
void __fastcall TExTrigTest::ApdComPort1TriggerData(TObject *CP,
	WORD TriggerHandle)
{
  cout << "OnTriggerData event: " << TriggerHandle << endl;
}
//---------------------------------------------------------------------------
void __fastcall TExTrigTest::ApdComPort1TriggerTimer(TObject *CP,
	WORD TriggerHandle)
{
  cout << "OnTriggerTimer event: " << TriggerHandle << endl;
}
//---------------------------------------------------------------------------
void __fastcall TExTrigTest::StartTestClick(TObject *Sender)
{
  ApdComPort1->TriggerLength = 1;
  TimerHandle = ApdComPort1->AddTimerTrigger();
  ApdComPort1->SetTimerTrigger(TimerHandle, 91, true);
  Data1Handle = ApdComPort1->AddDataTrigger("TI", true);
  Data2Handle = ApdComPort1->AddDataTrigger("OK", true);
  Data3Handle = ApdComPort1->AddDataTrigger("288", true);

  // Send a string to a modem that will hit all triggers
  ApdComPort1->PutString("ATI\r");
}
//---------------------------------------------------------------------------
