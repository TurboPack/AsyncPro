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
/*                      EXSTAT0.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExStat0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdProtcl"
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
void __fastcall TForm1::ApdProtocol1ProtocolStatus(TObject *CP, WORD Options)
{
  switch (Options) {
    case apFirstCall : /*do setup stuff*/ break;
    case apLastCall  : /*do cleanup stuff*/ break;
    default : {          // show status
      FN->Caption = ApdProtocol1->FileName;
      BT->Caption = String((int)ApdProtocol1->BytesTransferred);
      BR->Caption = String((int)ApdProtocol1->BytesRemaining);
      MS->Caption = ApdProtocol1->StatusMsg(ApdProtocol1->ProtocolStatus);
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::StartTransmitClick(TObject *Sender)
{
  AdTerminal1->Active = false;
  ApdProtocol1->StartTransmit();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::CancelClick(TObject *Sender)
{
  ApdProtocol1->CancelProtocol();
  AdTerminal1->SetFocus();
}
//---------------------------------------------------------------------------
