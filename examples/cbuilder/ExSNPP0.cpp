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

#include "ExSNPP0.h"
//---------------------------------------------------------------------------
#pragma link "AdWnPort"
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma link "AdPager"
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
  Button1->Caption = "Wait";
  Button1->Enabled = FALSE;


  /* extract WinSock address && port# */
  int P = Edit1->Text.Pos(":");
  String WsAddr   = Edit1->Text.SubString(1, P - 1);
  String WsPortID = Edit1->Text.SubString(P + 1, Edit1->Text.Length() - P);
  ApdWinsockPort1->WsAddress = WsAddr;
  ApdWinsockPort1->WsPort    = WsPortID;

  ApdSNPPPager1->PagerID     = Edit2->Text;
  ApdSNPPPager1->Message     = Memo1->Lines;
  ApdSNPPPager1->Send();        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormClose(TObject *Sender, TCloseAction &Action)
{
  ApdSNPPPager1->Quit();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSNPPPager1Logout(TObject *Sender)
{
  Button1->Enabled = TRUE;
  Button1->Caption = "Send";
}
//--------------------------------------------------------------------------- 
