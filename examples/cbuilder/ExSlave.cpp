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
/*                      ExSlave.cpp                      */
/*********************************************************/

// This example DLL works in conjunction with ExMaster.exe, using a
// handle to an already opened port with Async Professional.
// NOTE: If you recompile this DLL you may have to run IMPLIB on
// the DLL to create a new import library. From a command prompt type:
//
//    implib exslave.lib exslave.dll


//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "AwUser.hpp"
#include "AwWin32.hpp"
#include "ooMisc.hpp"
HANDLE ComHandle;

//---------------------------------------------------------------------------
USEFORM("ExSlave0.cpp", Form1);
//---------------------------------------------------------------------------

#include "ExSlave0.h"


int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
  return 1;
}
//---------------------------------------------------------------------------
class TApdSlaveDispatcher : public TApdWin32Dispatcher
{
  public:
    __fastcall TApdSlaveDispatcher(TObject* Owner) :
      TApdWin32Dispatcher(Owner) {}
    int __fastcall CloseCom();
    int __fastcall OpenCom(char* ComName, Cardinal InQueue, Cardinal OutQueue);
};

// "Open" the comport by returning the global handle
// and doing some housekeeping.
int __fastcall TApdSlaveDispatcher::OpenCom(char* ComName, Cardinal InQueue, Cardinal OutQueue)
{
  int Result = (int)ComHandle;
  CidEx = Result;
  // Create port data structure
  ReadOL.hEvent = CreateEvent(NULL, true, false, NULL);
  WriteOL.hEvent = CreateEvent(NULL, true, false, NULL);
  if ((ReadOL.hEvent == 0) || (WriteOL.hEvent == 0)) {
    // Failed to create events, get rid of everything
    CloseHandle(ReadOL.hEvent);
    CloseHandle(WriteOL.hEvent);
    Result = ecOutOfMemory;
  }
  return Result;
}

// "Close" the comport and clean up
int __fastcall TApdSlaveDispatcher::CloseCom()
{
  // Release the events
  if (ReadOL.hEvent != 0)
    CloseHandle(ReadOL.hEvent);
  if (WriteOL.hEvent != 0)
    CloseHandle(WriteOL.hEvent);

  KillThreads = true;

  // Force the comm thread to wake...
  SetCommMask((void*)CidEx, 0);
  SetEvent((void*)ReadyEvent);
  // ... and wait for it to die
  ResetEvent((void*)GeneralEvent);
  if (WaitForSingleObject((void*)GeneralEvent, 200) == WAIT_TIMEOUT)
    ComThread->Terminate();

  return 0;
}

// Function to create our custom dispatcher. Assigned to ApdComport's
// CustomDispatcher property.
TApdBaseDispatcher* __fastcall CreateCustomDispatcher(TObject* Owner)
{
  return new TApdSlaveDispatcher(Owner);
}

void __declspec(dllexport) ShowTerminal(HANDLE PortHandle)
{
  TForm1* form = new TForm1(Application);
  // Save handle in global variable so the dispatcher can get at it
  ComHandle = PortHandle;
  // Tell the ApdComPort to use our custom dispatcher
  form->ApdComPort1->CustomDispatcher = CreateCustomDispatcher;
  // Show terminal window
  form->ShowModal();
  delete form;
}

