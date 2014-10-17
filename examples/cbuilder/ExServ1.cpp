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
/*                      EXSERV1.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExServ1.h"
//---------------------------------------------------------------------------
#pragma link "AdWnPort"
#pragma link "AdPort"
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
  ApdWinsockPort1->Open = true;
  Label1->Caption = "Listening";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdWinsockPort1TriggerAvail(TObject *CP, WORD Count)
{
  for (int i=0;i<Count;i++)
    Label2->Caption = Label2->Caption + String(ApdWinsockPort1->GetChar());
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdWinsockPort1WsError(TObject *Sender, int ErrCode)
{
  Label1->Caption = "Error...";
  Label3->Caption = "Code: " + String(ErrCode);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdWinsockPort1WsAccept(TObject *Sender,
      TInAddr Addr, bool &Accept)
{
  Label1->Caption = "Connected";
  ApdWinsockPort1->Output = "Hello from Server";        
}
//---------------------------------------------------------------------------

