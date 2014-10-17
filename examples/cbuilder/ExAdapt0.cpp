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
/*                      EXADAPT0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExAdapt0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdFax"
#pragma link "AdFStat"
#pragma link "OoMisc"
#pragma link "ADTrmEmu"
#pragma resource "*.dfm"
TForm1 *Form1;

void TForm1::RemoveMyTrigger(int& th)
{
  if (!(th==0)) {
    ApdComPort1->RemoveTrigger((Byte)th);
    th = 0;
  }
}

void TForm1::RemoveAllMyTriggers()
{
  RemoveMyTrigger(dthRing);
  RemoveMyTrigger(dthConnect);
  RemoveMyTrigger(dthVoice);
  RemoveMyTrigger(dthFax);
  RemoveMyTrigger(dthCED);
  RemoveMyTrigger(dthPlusFCON);
  RemoveMyTrigger(ttTimeout);
}

//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner),
  CaseInsensitive(true)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdComPort1TriggerData(TObject *CP, WORD TriggerHandle)
{
  if (TriggerHandle == dthRing) {
    // Remove the "RING" trigger
    RemoveMyTrigger(dthRing);
    dthRing = 0;
    // Answer call
    ApdComPort1->PutString("ATA\r");
    // Add triggers for possible connect messages
    dthConnect = ApdComPort1->AddDataTrigger("CONNECT", CaseInsensitive);
    dthVoice   = ApdComPort1->AddDataTrigger("VOICE", CaseInsensitive);
    dthFax     = ApdComPort1->AddDataTrigger("FAX", CaseInsensitive);
    dthCED     = ApdComPort1->AddDataTrigger("CED", CaseInsensitive);
    dthPlusFCON= ApdComPort1->AddDataTrigger("+FCO", CaseInsensitive);
    // Add a timer trigger to wait for connect messages
    ttTimeout = ApdComPort1->AddTimerTrigger();
    ApdComPort1->SetTimerTrigger((Word)ttTimeout, 19*60 /*60 seconds*/, true);
  }
  else if (TriggerHandle == dthConnect) {
    RemoveAllMyTriggers();
    AdTerminal1->WriteString("\n\r<< Answered data call >>\n\r");
  }
  else if (TriggerHandle == dthVoice) {
    RemoveAllMyTriggers();
    MessageDlg("Answered voice call",
      mtInformation, TMsgDlgButtons() << mbOK, 0);
  }
  else if (TriggerHandle == dthFax ||
              TriggerHandle == dthCED ||
              TriggerHandle == dthPlusFCON) {
    RemoveAllMyTriggers();
    AdTerminal1->WriteString("\n\r<< Receiving fax... >>\n\r");
    AdTerminal1->Active = false;
    ApdReceiveFax1->PrepareConnectInProgress();
    ApdReceiveFax1->StartReceive();
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  Button1->Enabled = false;
  // Remove triggers from any previous attempts
  RemoveAllMyTriggers();
  // Pre-initialize for fax receive
  ApdReceiveFax1->InitModemForFaxReceive();
  // Add a data trigger for "RING"
  dthRing = ApdComPort1->AddDataTrigger("RING", CaseInsensitive);
  AdTerminal1->WriteString("\n\r<< Waiting for call >>\n\r");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdComPort1TriggerTimer(TObject *CP, WORD TriggerHandle)
{
  if (TriggerHandle == ttTimeout) {
    RemoveAllMyTriggers();
    MessageDlg("Timeout waiting for connect string",
      mtWarning, TMsgDlgButtons() << mbOK, 0);
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  ApdComPort1->DTR = false;
  Form1->Close();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdReceiveFax1FaxFinish(TObject *CP, int ErrorCode)
{
  Button1->Enabled = true;
  AdTerminal1->Active = true;
  AdTerminal1->WriteString("                               \r\n");
}
//---------------------------------------------------------------------------
