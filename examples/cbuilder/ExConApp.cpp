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
/*                      ExConApp.cpp                     */
/*********************************************************/
/* This is a simple example that demonstrates how to make a 32-bit console
  application which uses Async Professional.
  The example implements a winsock telnet application using a Win32 console
  as the terminal window.
  Note that this is just a demonstration. A real application would need to be
  optimized with respect to user I/O.
*/
//---------------------------------------------------------------------------
#include <condefs.h>
#include <conio.h>
#include <iostream.h>
#pragma hdrstop

#include "AdPort.hpp"
#include "AdWnPort.hpp"

TApdWinsockPort* ApdWinsockPort1;
HANDLE IH;
TInputRecord IR;
unsigned long NumberRead;

//---------------------------------------------------------------------------
USERES("ExIcon.res");
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdWnPort"
#pragma link "Adsrmgr"
//---------------------------------------------------------------------------

void __fastcall TriggerHandler(unsigned int Msg, unsigned int wParam, int lParam);

int main(int argc, char **argv)
{
  if (ParamCount() != 1 ) {
    cout << "Use: ExConApp <host name> (eg: ExConApp bbs.turbopower.com)" << endl;
    cout << "Press <CR>";
    getch();
    return 0;
  }

  SetConsoleTitle("ExConApp. Attempting to connect... Press Ctrl-Break to quit.");
  IH = GetStdHandle(STD_INPUT_HANDLE);
  ApdWinsockPort1 = new TApdWinsockPort(0);
  try {
    ApdWinsockPort1->WsAddress = ParamStr(1);
    ApdWinsockPort1->WsPort = "telnet";
    ApdWinsockPort1->DeviceLayer = dlWinsock;
    ApdWinsockPort1->Open = true;

    SetConsoleTitle("ExConApp Connected. Press Ctrl-Break to quit.");
    if (ApdWinsockPort1->Open) {
      ApdWinsockPort1->Dispatcher->RegisterProcTriggerHandler(TriggerHandler);
      //#ifdef UseANSI
      ApdWinsockPort1->PutString("\x01B[3;1R\n"); // Enable ANSI emulation from the host
      //#endif
      do {
        PeekConsoleInput(IH,&IR,1,&NumberRead);
        if (NumberRead == 0)
          SafeYield();
        else {
          ReadConsoleInput(IH,&IR,1,&NumberRead);
          //KEY_EVENT_RECORD rec = IR.Event;
          if (IR.EventType == KEY_EVENT && IR.Event.KeyEvent.bKeyDown)
            ApdWinsockPort1->PutChar(IR.Event.KeyEvent.uChar.AsciiChar);
        }
      } while(ApdWinsockPort1->Open);
    }
  }
  catch (...) {
    delete ApdWinsockPort1;
    ApdWinsockPort1 = 0;
  }
  delete ApdWinsockPort1;
  return 0;
}
//---------------------------------------------------------------------------
void __fastcall TriggerHandler(unsigned int Msg, unsigned int wParam, int lParam)
{
  if (Msg == apw_TriggerAvail)
    while (wParam > 0) {
      cout << ApdWinsockPort1->GetChar();
      wParam--;
    }
}
