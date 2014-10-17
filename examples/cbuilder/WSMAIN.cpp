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
/*                      WSMAIN.CPP                       */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "WsMain.h"
//---------------------------------------------------------------------------
#pragma link "AdTerm"
#pragma link "AdWnPort"
#pragma link "AdPort"
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
  StatusBar->SimpleText = "Attempting Connection...";
  ApdTerminal->SetFocus();
  WsPort->WsAddress = HostNameEdit->Text;
  WsPort->Open = true;
  //NameTrigger = WsPort->AddDataTrigger("first name", true);
  //PasswordTrigger = WsPort->AddDataTrigger("password", true);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WsPortWsConnect(TObject *Sender)
{
  StatusBar->SimpleText = "Connected!";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WsPortWsDisconnect(TObject *Sender)
{
  StatusBar->SimpleText = "Not Connected";
  ApdTerminal->ClearBuffer();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  StatusBar->SimpleText = "Disconnecting...";
  WsPort->Open = false;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::WsPortTriggerData(TObject *CP, WORD TriggerHandle)
{
  if (TriggerHandle == NameTrigger) {
    WsPort->PutString("joe blow\r\n");
    WsPort->RemoveTrigger(NameTrigger);
  }
  if (TriggerHandle == PasswordTrigger) {
    WsPort->PutString("123\r\n");
    WsPort->RemoveTrigger(PasswordTrigger);
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  StatusBar->SimpleText = "Not Connected";
  HostNameEdit->Text = WsPort->WsAddress;
}
//---------------------------------------------------------------------------
