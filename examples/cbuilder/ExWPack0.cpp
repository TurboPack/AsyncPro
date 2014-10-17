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
/*                      ExWPack0.cpp                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExWPack0.h"
//---------------------------------------------------------------------------
#pragma link "AdProtcl"
#pragma link "AdPStat"
#pragma link "AdWnPort"
#pragma link "AdPort"
#pragma link "AdPacket"
#pragma link "OoMisc"
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
  if (!ApdWinsockPort1->Open) {
    ApdWinsockPort1->WsAddress = Edit1->Text;
  }
  ApdWinsockPort1->Open = !ApdWinsockPort1->Open;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdWinsockPort1WsConnect(TObject *Sender)
{
  Button1->Caption = "Disconnect";
  Memo1->Lines->Add("Connected. Waiting for name prompt...");
  WaitName->Enabled = true;
  Cursor = crHourGlass;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdWinsockPort1WsDisconnect(TObject *Sender)
{
  Button1->Caption = "Connect";
  Cursor = crDefault;
  Memo1->Lines->Add("Idle");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WaitNameTimeout(TObject *Sender)
{
  ApdWinsockPort1->Open = false;
  ShowMessage("Operation timed out. Port closed.");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WaitNamePacket(TObject *Sender, Pointer Data, int Size)
{
  WaitPassword->Enabled = true;
  ApdWinsockPort1->PutString(edtName->Text + "\r");
  Memo1->Lines->Add("Name sent. Waiting for password prompt...");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WaitPasswordPacket(TObject *Sender, Pointer Data,
  int Size)
{
  WaitCommand->Enabled = true;
  CommandState = 0;
  ApdWinsockPort1->PutString(edtPassword->Text + "\r\r\r\r\r\r");
  Memo1->Lines->Add("Password sent. Waiting for command prompt...");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WaitZStartPacket(TObject *Sender, Pointer Data,
  int Size)
{
  ApdProtocol1->StartReceive();
  Memo1->Lines->Add("Downloading...");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WaitContinuePacket(TObject *Sender, Pointer Data,
  int Size)
{
  WaitCommand->Enabled = true;
  ApdWinsockPort1->PutString("\r");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WaitCommandPacket(TObject *Sender, Pointer Data,
  int Size)
{
  switch (CommandState) {
  case 0 :
    {
      ApdWinsockPort1->PutString("f\r");
      Memo1->Lines->Add("Navigating to file menu...");
      break;
    }
  case 1 :
    {
      ApdWinsockPort1->PutString("d\r");
      WaitCommand->Enabled = false;
      WaitFileName->Enabled = true;
      Memo1->Lines->Add("Requesting file download...");
      break;
    }
  }
  CommandState++;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WaitFileNamePacket(TObject *Sender, Pointer Data,
  int Size)
{
  WaitContinue2->Enabled = true;
  WaitZStart->Enabled = true;
  ApdWinsockPort1->PutString(edtFileName->Text + "\r\r\rZ\r");
  Memo1->Lines->Add("Sending name of file to download...");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WaitContinue2Packet(TObject *Sender, Pointer Data,
  int Size)
{
  ApdWinsockPort1->PutString("\r\rG\r\r");
  Memo1->Lines->Add("Logging off...");
}
//---------------------------------------------------------------------------
