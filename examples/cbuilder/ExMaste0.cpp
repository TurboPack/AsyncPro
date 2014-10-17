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
/*                      ExMaste0.cpp                     */
/*********************************************************/
// This example - along with the ExSlave DLL - demonstrates how to
// create a custom dispatcher for using an already open communications
// handle with Async Professional. This example assumes that a modem
// is installed using COM1.
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

void __declspec(dllimport) ShowTerminal(HANDLE PortHandle);

#include "ExMaste0.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnOpenClick(TObject *Sender)
{
  if (ComPortOpen) {
    btnOpen->Caption = "Open COM1";
    btnSlave->Enabled = false;
    CloseHandle(ComHandle);
    ComPortOpen = false;
  }
  else {
    // Open handle to COM1
    ComHandle = CreateFile("\\\\.\\COM1",
                         GENERIC_READ | GENERIC_WRITE,  // access attributes
                         0,                             // no sharing
                         0,                             // no security
                         OPEN_EXISTING,                 // creation action
                         FILE_ATTRIBUTE_NORMAL |
                         FILE_FLAG_OVERLAPPED,          // attributes
                         0);                            // no template
    if (ComHandle != INVALID_HANDLE_VALUE) {
      ComPortOpen = true;
      btnOpen->Caption = "Close COM1";
      btnSlave->Enabled = true;
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnSlaveClick(TObject *Sender)
{
  // Call ExSlave.dll, passing the open handle to COM1
  ShowTerminal(ComHandle);
}
//---------------------------------------------------------------------------
