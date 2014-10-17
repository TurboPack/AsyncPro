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
/*                      FaxMon0.cpp                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "FaxMon0.h"
//---------------------------------------------------------------------------
#pragma link "AdFaxCtl"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TfFaxMon0 *fFaxMon0;

String __fastcall TPrintJob::GetJobString()
{
  return DocName + "(" + StateString[State] + ")";
}
//---------------------------------------------------------------------------
__fastcall TfFaxMon0::TfFaxMon0(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfFaxMon0::FormCreate(TObject *Sender)
{
  StateString[0] = "Printing";
  StateString[1] = "Generated";
  StateString[2] = "Queued";
  StateString[3] = "Sent";
  Application->OnMinimize = MainFormMinimize;
  Application->OnRestore = MainFormRestore;
}
//--------------------------------------------------------------------------


void __fastcall TfFaxMon0::DriverDocStart(TObject *Sender)
{
  TPrintJob* NewJob = new TPrintJob;
  NewJob->DocName = Driver->DocName;
  Driver->FileName = "C:\FMTEMP" + IntToStr(FileCount) + ".APF";
  FileCount++;
  NewJob->FileName = Driver->FileName;
  NewJob->State = Printing;
  ListBox1->Items->AddObject(NewJob->JobString, NewJob);
}
//---------------------------------------------------------------------------
void __fastcall TfFaxMon0::DriverDocEnd(TObject *Sender)
{
  for (int i=0;i<ListBox1->Items->Count;i++) {
    TPrintJob* job =
      dynamic_cast<TPrintJob*>(ListBox1->Items->Objects[i]);
    if (job->State == Printing && job->DocName == Driver->DocName) {
      job->State = Generated;
      ListBox1->Items->Strings[i] = job->JobString;
      break;
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TfFaxMon0::AmNotifyFaxSent(TMessage& Message)
{
  for (int i=0;i<ListBox1->Items->Count;i++) {
    TPrintJob* job =
      dynamic_cast<TPrintJob*>(ListBox1->Items->Objects[i]);
    if (job->JobAtom == Message.LParam) {
      job->State = Sent;
      ListBox1->Items->Strings[Message.WParam] = job->JobString;
      DeleteAtom(job->JobAtom);
      break;
    }
  }
}

void __fastcall TfFaxMon0::AmQueryPending(TMessage& Message)
{
  int Pending = 0;
  for (int i=0;i<ListBox1->Items->Count;i++) {
    TPrintJob* job =
      dynamic_cast<TPrintJob*>(ListBox1->Items->Objects[i]);
    if (job->State != Sent)
      Pending++;
  }
  Message.Result = Pending;
}

void __fastcall TfFaxMon0::btnSelectClick(TObject *Sender)
{
  if (OpenDialog1->Execute())
    edtServerPath->Text = OpenDialog1->FileName;
}
//---------------------------------------------------------------------------
void __fastcall TfFaxMon0::FormActivate(TObject *Sender)
{
  TOSVersionInfo OSVerInfo;
  tiPresent = false;
  OSVerInfo.dwOSVersionInfoSize = sizeof(OSVerInfo);
  if (GetVersionEx(&OSVerInfo)) {
    // Note: Windows95 returns version major:minor == 4:0
    if ((OSVerInfo.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS) || //Windows95
       (OSVerInfo.dwPlatformId == VER_PLATFORM_WIN32_NT))         //WindowsNT
      tiPresent = OSVerInfo.dwMajorVersion > 3;
  }
}
//---------------------------------------------------------------------------
void __fastcall TfFaxMon0::FormClose(TObject *Sender, TCloseAction &Action)
{
  tiDelete();
}
//---------------------------------------------------------------------------
void __fastcall TfFaxMon0::MainFormMinimize(TObject* Sender)
{
  if (tiPresent) {
    tiAdd();
    Hide();
  }
}

void __fastcall TfFaxMon0::MainFormRestore(TObject* Sender)
{
  if (tiPresent) {
    tiDelete();
    Show();
    SetForegroundWindow(Handle);
  }
}

void TfFaxMon0::tiAdd()
{
  if (tiPresent && !tiActive) {
    tiInitNotifyData();
    tiActive = Shell_NotifyIcon(NIM_ADD, &tiNotifyData);
  }
}

void __fastcall TfFaxMon0::tiCallBack(TMessage& Message)
{
  TPoint P;
  switch (Message.LParam) {
    case WM_RBUTTONDOWN : {
      GetCursorPos(&P);
      SetForegroundWindow(Application->Handle);
      Application->ProcessMessages();
      PopupMenu->Popup(P.x, P.y);
      break;
    }
    case WM_LBUTTONDBLCLK : {
      Application->Restore();
      break;
    }
  }
}

void TfFaxMon0::tiDelete()
{
  if (tiPresent && tiActive) {
    tiActive = !Shell_NotifyIcon(NIM_DELETE, &tiNotifyData);
  }
}

HICON TfFaxMon0::tiGetIconHandle()
{
  HICON Result = Application->Icon->Handle;
  if (Result == 0)
    Result = LoadIcon(0, IDI_APPLICATION);
  return Result;
}

void TfFaxMon0::tiInitNotifyData()
{
  if (tiPresent) {
    memset(&tiNotifyData, 0, sizeof(tiNotifyData));
    tiNotifyData.cbSize = sizeof(tiNotifyData);
    tiNotifyData.hWnd   = Handle;
    tiNotifyData.uID    = 1;
    tiNotifyData.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
    strcpy(tiNotifyData.szTip, "Fax Monitor");
    tiNotifyData.uCallbackMessage = Am_TiCallBack;
    tiNotifyData.hIcon = tiGetIconHandle();
  }
}

void __fastcall TfFaxMon0::mnCloseClick(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TfFaxMon0::Timer1Timer(TObject *Sender)
{
  String AtomString;
  bool Done;

  if (ListBox1->Items->Count != 0) {
    Timer1->Enabled = false;
    try {
      do {
        Done = true;
        TPrintJob* Job =
          dynamic_cast<TPrintJob*>(ListBox1->Items->Objects[0]);
        switch (Job->State) {
          case Printing :
          case Generated : {
            if (AppHandle == 0 || !IsWindow(AppHandle)) {
              ShellExecute(0, 0, edtServerPath->Text.c_str(), 0, "", SW_SHOWNORMAL);
              AtomString = edtServerPath->Text;
              ShellExecute(0, 0, AtomString.c_str(), 0, "", SW_SHOWNORMAL);
              do {
                AppHandle = FindWindow("TForm1", "Fax server");
                Application->ProcessMessages();
              } while (AppHandle == 0);
            }
              if (AppHandle != 0) {
              AtomString = Job->DocName + char(27) + Job->FileName;
              Job->JobAtom = GlobalAddAtom(AtomString.c_str());
              Job->JobAtom = GlobalAddAtom(&AtomString[1]);
              PostMessage(AppHandle,
                Am_NotifyFaxAvailable, (WPARAM)Handle, Job->JobAtom);
              Job->State = Queued;
              ListBox1->Items->Strings[0] = Job->JobString;
            }
          }
          case Queued :
          case Sent :   {
            TPrintJob* job =
              dynamic_cast<TPrintJob*>(ListBox1->Items->Objects[0]);
            delete job;
            ListBox1->Items->Delete(0);
            Done = false;
          }
        }
      } while (!Done && ListBox1->Items->Count != 0);
    }
    catch (...) {
      Timer1->Enabled = true;
      return;
    }
  }
  Timer1->Enabled = true;
}
//---------------------------------------------------------------------------
