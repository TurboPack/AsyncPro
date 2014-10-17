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
/*                      EXWZSND0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExWZSnd0.h"
//---------------------------------------------------------------------------
#pragma link "AdProtcl"
#pragma link "AdPStat"
#pragma link "AdWnPort"
#pragma link "AdPort"
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
void __fastcall TForm1::ApdProtocol1ProtocolFinish(TObject *CP, int ErrorCode)
{
  AdTerminal1->Active = true;
  AdTerminal1->SetFocus();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  if (!ApdWinsockPort1->Open)
    ApdWinsockPort1->WsAddress = Edit1->Text;
  ApdWinsockPort1->Open = !ApdWinsockPort1->Open;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdWinsockPort1WsConnect(TObject *Sender)
{
  ApdProtocol1ProtocolFinish(this, 0);
  Button2->Enabled = true;
  Button1->Caption = "Disconnect";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  AdTerminal1->Active = false;
  ApdProtocol1->StartTransmit();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdWinsockPort1WsDisconnect(TObject *Sender)
{
  Button1->Caption = "Connect";
}
//---------------------------------------------------------------------------
