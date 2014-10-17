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
/*                      FAXSRVX0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include <stdio.h>

#include "FaxSrvx0.h"
#include "FaxSrvx1.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdFStat"
#pragma link "AdFax"
#pragma link "AdTapi"
#pragma link "AdFaxCtl"
#pragma link "AdFaxCtl"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TfsMain *fsMain;
//---------------------------------------------------------------------------
__fastcall TfsMain::TfsMain(TComponent* Owner)
  : TForm(Owner)
{
  FaxList     = new TStringList;
  InProgress  = false;
  AddList     = 0;
  AddsPending = 0;
  AddsInProgress = false;
}
//---------------------------------------------------------------------------
__fastcall TfsMain::~TfsMain()
{
  delete FaxList;
}

String TfsMain::LimitS(String const S, Word Len)
{
  String Result;
  if (S.Length() > Len) {
    Result = S;
    Result[Len] + "...";
  }
  else
    Result = S;
  return Result;
}

//---------------------------------------------------------------------------
void __fastcall TfsMain::SendFaxClick(TObject *Sender)
{
  if (!InProgress) {
    InProgress = true;

    // Get user"s values
    FaxIndex = 0;
    ApdSendFax1->FaxClass = (TFaxClass)(fsFaxClass->ItemIndex + 1);
    try {
      ApdSendFax1->DialAttempts  = (Word)fsDialAttempts->Text.ToInt();
      ApdSendFax1->DialRetryWait = (Word)fsRetryWait->Text.ToInt();
    }
    catch (...) {}
    ApdSendFax1->StationID = fsStationID->Text;
    ApdSendFax1->DialPrefix = fsDialPrefix->Text;
    ApdSendFax1->ModemInit = fsModemInit->Text;
    ApdSendFax1->HeaderLine = fsHeader->Text;

    if (ApdComPort1->TapiMode == tmOn ||
       (ApdComPort1->TapiMode == Adport::tmAuto &&
        ApdTapiDevice1->SelectedDevice != "")) {
      // Tell TAPI to configure and open the port
      ApdTapiDevice1->ConfigAndOpen();
    }
    else {
      // Open the port and start sending
      try {
        ApdComPort1->Open = true;
      }
      catch (...) {
        InProgress = false;
        throw;
      }
      ApdSendFax1->StartTransmit();
    }
  }
  else
    MessageBeep(-1);
}
//---------------------------------------------------------------------------
void TfsMain::fsAppendAddList(String FName, String CName, String PNumber)
{
  TAddEntry* NewEntry;
  if (AddList == 0) {
    // empty list
    AddList = new TAddEntry;
    NewEntry = AddList;
  }
  else {
    // find end of list
    NewEntry = AddList;
    while (NewEntry->NextEntry != NULL) {
      NewEntry = NewEntry->NextEntry;
    }
    NewEntry->NextEntry = new TAddEntry;
    NewEntry = NewEntry->NextEntry;
  }
  memset(NewEntry, 0, sizeof(TAddEntry));

  NewEntry->FaxName = FName;
  NewEntry->CoverName = CName;
  NewEntry->PhoneNumber = PNumber;
  NewEntry->NextEntry = 0;

  AddsPending++;
}

void TfsMain::fsGetAddListEntry(String& FName, String& CName, String PNumber)
{
  TAddEntry* TempEntry;

  if (!AddList) return;

  TempEntry = AddList;
  AddList = AddList->NextEntry;
  FName = TempEntry->FaxName;
  CName = TempEntry->CoverName;
  PNumber = TempEntry->PhoneNumber;
  delete TempEntry;
  AddsPending--;
}

void TfsMain::fsAddPrim()
{
  // Display the Add dialog for all Add requests queued
  String S;
  String FName;
  String CName;
  String PNumber;

  // prevent multiple occurances of dialog from being displayed
  AddsInProgress = true;

  // set the button text
  fsFaxList->flAction->Caption = "&Add";

  while (AddsPending > 0) {
    // set the data
    fsGetAddListEntry(FName, CName, PNumber);
    fsFaxList->FaxName = FName;
    fsFaxList->CoverName = CName;
    fsFaxList->PhoneNumber = PNumber;

    // show the dialog
    if (fsFaxList->ShowModal() == mrOk &&
       (fsFaxList->PhoneNumber != "") &&
       fsFaxList->FaxName != "") {
      // add this fax entry to the list
      S = fsFaxList->PhoneNumber + "^" + fsFaxList->FaxName;
      if (fsFaxList->CoverName != "")
        S = S + "^" + fsFaxList->CoverName;
      FaxList->Add(S);

      // add this fax entry to the list box
      char buff[100];
      sprintf(buff, "%-20s %-20s %-20s",
        LimitS(fsFaxList->PhoneNumber, 20).c_str(),
        LimitS(fsFaxList->FaxName, 20).c_str(),
        LimitS(fsFaxList->CoverName, 20).c_str());
      S = buff;
      fsFaxListBox->Items->Add(S);
    }
  }

  AddsInProgress = false;
}


void __fastcall TfsMain::fsAddClick(TObject *Sender)
{
  fsAppendAddList("", "", "");
  fsAddPrim();
}
//---------------------------------------------------------------------------

void __fastcall TfsMain::AddPrim(TMessage& Message)
{
  fsAddPrim();
}

void __fastcall TfsMain::ApdSendFax1FaxNext(TObject *CP,
  TPassString &APhoneNumber, TPassString &AFaxFile, TPassString &ACoverFile)
{
  int CaretPos;

  try {
    String S = FaxList->Strings[FaxIndex];
    CaretPos = S.Pos("^");
    APhoneNumber = S.SubString(1, CaretPos - 1);
    S = S.SubString(CaretPos + 1, 255);
    CaretPos = S.Pos("^");
    if (CaretPos == 0) {
      AFaxFile = S;
      ACoverFile = "";
    }
    else {
      AFaxFile = S.SubString(1, CaretPos - 1);
      ACoverFile = S.SubString(255, CaretPos + 1);
    }
    FaxIndex++;
  }
  catch (...) {
    APhoneNumber = "";
    AFaxFile = "";
    ACoverFile = "";
  }
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsExitClick(TObject *Sender)
{
  TAddEntry* TempEntry;
  while (AddList) {
    TempEntry = AddList;
    AddList = AddList->NextEntry;
    delete TempEntry;
  }
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsModifyClick(TObject *Sender)
{
  int SaveIndex, CPos;
  String S;

  if (InProgress) {
    MessageBeep(-1);
    return;
  }

  // Exit if nothing selected
  if (fsFaxListBox->ItemIndex == -1)
    return;

  // Set the button text
  fsFaxList->flAction->Caption = "&Modify";

  // Note the listbox index, use it get data from FileList
  SaveIndex = fsFaxListBox->ItemIndex;
  S = FaxList->Strings[SaveIndex];
  CPos = S.Pos("^");
  fsFaxList->PhoneNumber = S.SubString(1, CPos - 1);
  S = S.SubString(CPos + 1, 255);
  CPos = S.Pos("^");
  if (CPos == 0)
    fsFaxList->FaxName = S;
  else {
    fsFaxList->FaxName = S.SubString(1, CPos - 1);
    fsFaxList->CoverName = S.SubString(CPos + 1, 255);
  }

  // Show the dialog
  if (fsFaxList->ShowModal() == mrOk) {
    // Modify the FaxList entry
    S = fsFaxList->PhoneNumber + "^" + fsFaxList->FaxName;
    if (fsFaxList->CoverName != "")
      S = S + "^" + fsFaxList->CoverName;
    FaxList->Strings[SaveIndex] = S;

    // Add this fax entry to the list box
    char buff[50];
    sprintf(buff, "%-20s %-20s %-20s",
      LimitS(fsFaxList->PhoneNumber, 20).c_str(),
      LimitS(fsFaxList->FaxName, 20).c_str(),
      LimitS(fsFaxList->CoverName, 20).c_str());
    fsFaxListBox->Items->Strings[SaveIndex] = buff;
  }
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsDeleteClick(TObject *Sender)
{
  int Index;
  
  if (InProgress) {
    MessageBeep(-1);
    return;
  }

  if (fsFaxListBox->ItemIndex != -1) {
    Index = fsFaxListBox->ItemIndex;
    fsFaxListBox->Items->Delete(Index);
    FaxList->Delete(Index);
  }
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::ApdSendFax1FaxLog(TObject *CP, TFaxLogCode LogCode)
{
  if (LogCode == lfaxTransmitOk) {
    DeleteFile(String(ApdSendFax1->FaxFile).c_str());
    FaxIndex--;
    fsFaxListBox->Items->Delete(FaxIndex);
    FaxList->Delete(FaxIndex);
  }
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsFaxClassClick(TObject *Sender)
{
  ApdSendFax1->FaxClass = (TFaxClass)(fsFaxClass->ItemIndex + 1);
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsDialAttemptsChange(TObject *Sender)
{
  ApdSendFax1->DialAttempts = (Word)fsDialAttempts->Text.ToInt();
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsRetryWaitChange(TObject *Sender)
{
  ApdSendFax1->DialRetryWait = (Word)fsRetryWait->Text.ToInt();
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsStationIDChange(TObject *Sender)
{
  ApdSendFax1->StationID = fsStationID->Text;
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsDialPrefixChange(TObject *Sender)
{
  ApdSendFax1->DialPrefix = fsDialPrefix->Text;
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsModemInitChange(TObject *Sender)
{
  ApdSendFax1->ModemInit = fsModemInit->Text;
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsHeaderChange(TObject *Sender)
{
  ApdSendFax1->HeaderLine = fsHeader->Text;
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::fsSelectComPortClick(TObject *Sender)
{
  ApdTapiDevice1->SelectDevice();
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::ApdTapiDevice1TapiPortOpen(TObject *Sender)
{
  // TAPI port is configured and open, star the fax session
  ApdSendFax1->StartTransmit();
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::ApdTapiDevice1TapiPortClose(TObject *Sender)
{
  InProgress = False;
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::ApdSendFax1FaxFinish(TObject *CP, int ErrorCode)
{
  ShowMessage("Finished: " + ErrorMsg((short)ErrorCode));
  if (ApdComPort1->TapiMode == tmOn)
    if (ApdTapiDevice1->CancelCall())
      // Call cancelled immediately, clear InProgress flag
      InProgress = false;
    //else
      // CancelCall proceeding in background, waiting for OnTapiPortClose
  else {
    // Not using TAPI, just close the port and clear the InProgress flag
    ApdComPort1->Open = false;
    InProgress = false;
  }
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::ApdFaxDriverInterface1DocEnd(TObject *Sender)
{
  // Queue the job for display in the Add dialog.
  fsAppendAddList(ApdFaxDriverInterface1->FileName, "", "");

  if (!AddsInProgress)
    // we're called in the context of the driver here,
    // so we can't do UI stuff directly
    PostMessage(Handle, apw_AddPrim, 0, 0);
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::ApdFaxDriverInterface1DocStart(TObject *Sender)
{
  char FaxFile[255];
  // Generate a unique filename
  GetTempFileName(".", "~AP", 0, FaxFile);
  ApdFaxDriverInterface1->FileName = ExpandFileName(FaxFile);
}
//---------------------------------------------------------------------------
void __fastcall TfsMain::FormCreate(TObject *Sender)
{
  if(fsHeader->Text == "Default header")
    fsHeader->Text = "Fax sent by $I using APro " + ApdSendFax1->Version + "   $D $T";
}
//---------------------------------------------------------------------------

