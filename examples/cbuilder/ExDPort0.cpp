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
/*                      EXDPORT0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExDPort0.h"
//---------------------------------------------------------------------------
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
  // add a data trigger for "OK"
  MyCP->AddDataTrigger("OK", false);
  MyCP->Output = "ATZ\r\n";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  // create an instance of TApdComPort
  MyCP = new TApdComPort(0);
  // assign to COM1 (your mileage may vary)
  MyCP->ComNumber = 1;
  // assign the event handler
  MyCP->OnTriggerData = &MyTriggerData;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::MyTriggerData(TObject* CP, Word TriggerHandle)
{
  // remove trigger
  MyCP->RemoveAllTriggers();
  // We're here!!
  ShowMessage("Got a data trigger");
}

void __fastcall TForm1::FormDestroy(TObject *Sender)
{
  // delete the com port object
  delete MyCP;
}
//---------------------------------------------------------------------------
