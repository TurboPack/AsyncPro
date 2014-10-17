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
/*                      EXTAPI0.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "Extapi0.h"
//---------------------------------------------------------------------------
#pragma link "AdTapi"
#pragma link "AdTStat"
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
void __fastcall TForm1::DialClick(TObject *Sender)
{
  ApdTapiDevice1->Dial("555-1212");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::AnswerClick(TObject *Sender)
{
  AdTerminal1->WriteString(" ** Waiting for incoming call...");
  ApdTapiDevice1->AutoAnswer();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ConfigClick(TObject *Sender)
{
  ApdTapiDevice1->ShowConfigDialog();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiPortOpen(TObject *Sender)
{
  AdTerminal1->WriteString("\r\n\r\n ** TAPI port opened\r\n");
  AdTerminal1->SetFocus();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiPortClose(TObject *Sender)
{
  AdTerminal1->WriteString("\r\n\r\n ** TAPI port closed\r\n");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::CancelClick(TObject *Sender)
{
  ApdTapiDevice1->CancelCall();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiConnect(TObject *Sender)
{
  AdTerminal1->WriteString("\r\n\r\n ** TAPI connect\r\n");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiFail(TObject *Sender)
{
  AdTerminal1->WriteString("\r\n\r\n ** TAPI fail\r\n");
}
//---------------------------------------------------------------------------
