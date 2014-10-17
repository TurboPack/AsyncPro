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

//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExAuto0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma link "AdPacket"
#pragma link "AdProtcl"
#pragma link "ADTrmEmu"
#pragma link "AdMdm"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnDialClick(TObject *Sender)
{
  MyState = msInit;
  IsClient = true;
  AdModem1->Dial(Edit1->Text);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnAnswerClick(TObject *Sender)
{
  MyState = msInit;
  IsClient = false;
  AdModem1->AutoAnswer();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnCancelClick(TObject *Sender)
{
  AdModem1->CancelCall();
  MyState = msNone;
  btnDial->Enabled = true;
  btnAnswer->Enabled = true;
  btnCancel->Enabled = false;
}
//---------------------------------------------------------------------------
void TForm1::WriteTerm(const String S)
{
  AdTerminal1->WriteString("\r\n" + S + "\r\n");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdComPort1TriggerAvail(TObject *CP, WORD Count)
{
  for (Word I=0;I<Count;I++) {
    Char C = ApdComPort1->GetChar();
    if (MyState==msLogon && !IsClient)
      if (C == 13)
        CheckPassword(ClientPassword);
      else
        ClientPassword = ClientPassword + C;
  }
}
//---------------------------------------------------------------------------
void TForm1::CheckPassword(const String S)
{
  if (S == Password) {
    ApdComPort1->Output = "Access authorized";
    MyState = msXFer1;
    WriteTerm("Starting receive");
    AdTerminal1->Active = false;
    ApdProtocol1->StartReceive();
  }
  else {
    ApdComPort1->Output = "Access denied";
    btnCancel->Click();
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdProtocol1ProtocolFinish(TObject *CP, int ErrorCode)
{
  if (MyState == msXFer2) {
    WriteTerm("Transfers complete: " + ErrorMsg((Word)ErrorCode));
    WriteTerm("Disconnecting...");
    AdTerminal1->Active = true;
    MyState = msQuit;
    btnCancel->Click();
    return;
  }
  MyState = msXFer2;
  WriteTerm("1st transfer complete: " + ErrorMsg((Word)ErrorCode));
  if (IsClient) {
    WriteTerm("Receiving file");
    ApdProtocol1->StartReceive();
  }
  else {
    WriteTerm("Pausing for sync...");
    DelayTicks(18, true);
    WriteTerm("Sending file");
    ApdProtocol1->StartTransmit();
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdProtocol1ProtocolStatus(TObject *CP, WORD Options)
{
  if (Options == apFirstCall)
    AdTerminal1->WriteString("\r\n");
  AdTerminal1->WriteChar('.');
  if (Options == apLastCall)
    AdTerminal1->WriteString("\r\n");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdDataPacket1Packet(TObject *Sender, Pointer Data,
	int Size)
{
  ApdComPort1->Output = Password + String((char)13);
  MyState = msXFer1;
  WriteTerm("Pausing for sync...");
  DelayTicks(18, true);
  WriteTerm("Sending file");
  AdTerminal1->Active = false;
  ApdProtocol1->StartTransmit();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdComPort1TriggerModemStatus(TObject *Sender)
{
  WriteTerm("Got modem status trigger");
  if (ApdComPort1->DCD == true)
    ApdComPort1->SetStatusTrigger(DCDTrig, msDCDDelta, true);
  else {
    MyState = msNone;
    ApdComPort1->SetStatusTrigger(DCDTrig, msDCDDelta, true);
    WriteTerm("Disconnected");
    btnDial->Enabled = true;
    btnAnswer->Enabled = true;
    btnCancel->Enabled = false;
  }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AdModem1ModemConnect(TAdCustomModem *Modem)
{
  DCDTrig = ApdComPort1->AddStatusTrigger(stLine);
  ApdComPort1->SetStatusTrigger(DCDTrig, msDCDDelta, true);

  MyState = msLogon;

  if (!IsClient) {
    ApdComPort1->Output = "Welcome to the ExAuto Host\r\n";
    ApdComPort1->Output = "Enter Password:";
  }
}
//---------------------------------------------------------------------------

