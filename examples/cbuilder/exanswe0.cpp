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
/*                      EXANSWE0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "exanswe0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdMdm"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;

void TForm1::AddStatus(const String Msg)
{
  ListBox1->Items->Add(Msg);
  ListBox1->ItemIndex = ListBox1->Items->Count - 1;
}

//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::BitBtn1Click(TObject *Sender)
{
  AdModem1->AnswerOnRing = 2;
  AdModem1->AutoAnswer();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdModem1GotLineSpeed(TObject *M, int Speed)
{
  AddStatus("Connected at " + IntToStr(Speed) + " baud");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormCreate(TObject *Sender)
{
  ApdComPort1->Open = true;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AdModem1ModemCallerID(TAdCustomModem *Modem,
      TApdCallerIDInfo &CallerID)
{
  AddStatus("CallerID Name: " + CallerID.Name);
  AddStatus("CallerID Number: " + CallerID.Number);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AdModem1ModemConnect(TAdCustomModem *Modem)
{
  AddStatus("Connected");    
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AdModem1ModemDisconnect(TAdCustomModem *Modem)
{
  AddStatus("Disconnected");    
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AdModem1ModemLog(TAdCustomModem *Modem,
      TApdModemLogCode LogCode)
{
  AddStatus("Log event: " + Modem->ModemLogToString(LogCode));    
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AdModem1ModemStatus(TAdCustomModem *Modem,
      TApdModemState ModemState)
{
  AddStatus("Status event: " + Modem->ModemStatusMsg(ModemState));    
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AdModem1ModemFail(TAdCustomModem *Modem,
      int FailCode)
{
  AddStatus("Failed: " + Modem->FailureCodeMsg(FailCode));      
}
//---------------------------------------------------------------------------

