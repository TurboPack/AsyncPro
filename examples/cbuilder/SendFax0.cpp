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
/*                      SendFax0.cpp                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include <stdio.h>

#include "SendFax0.h"
#include "SendFax1.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdFStat"
#pragma link "AdFax"
#pragma link "AdTapi"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TsfMain *sfMain;
//---------------------------------------------------------------------------
__fastcall TsfMain::TsfMain(TComponent* Owner)
  : TForm(Owner)
{
  FaxList     = new TStringList;
  InProgress  = false;
  AddList     = 0;
  AddsPending = 0;
  AddsInProgress = false;
  ProcessedCmdLine = false;
}
//---------------------------------------------------------------------------
__fastcall TsfMain::~TsfMain()
{
  delete FaxList;
}

String TsfMain::LimitS(String const S, Word Len)
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

void __fastcall TsfMain::FormShow(TObject *Sender)
{
  if (!ProcessedCmdLine) {
    sfAddFromCmdLine();
    ProcessedCmdLine = true;
  }
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::SendFaxClick(TObject *Sender)
{
  if (!InProgress) {
    InProgress = true;

    // Get user"s values
    FaxIndex = 0;
    ApdSendFax1->FaxClass = (TFaxClass)(sfFaxClass->ItemIndex + 1);
    try {
      ApdSendFax1->DialAttempts  = (Word)sfDialAttempts->Text.ToInt();
      ApdSendFax1->DialRetryWait = (Word)sfRetryWait->Text.ToInt();
    }
    catch (...) {}
    ApdSendFax1->EnhTextEnabled = EnhText->Checked;                 // !!.50
    ApdSendFax1->StationID = sfStationID->Text;
    ApdSendFax1->DialPrefix = sfDialPrefix->Text;
    ApdSendFax1->ModemInit = sfModemInit->Text;
    ApdSendFax1->HeaderLine = sfHeader->Text;

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
void TsfMain::sfAppendAddList(String FName, String CName, String PNumber)
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

void TsfMain::sfGetAddListEntry(String& FName, String& CName, String PNumber)
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

void TsfMain::sfAddPrim()
{
  // Display the Add dialog for all Add requests queued
  String S;
  String FName;
  String CName;
  String PNumber;

  // prevent multiple occurances of dialog from being displayed
  AddsInProgress = true;

  // set the button text
  sfFaxList->flAction->Caption = "&Add";

  while (AddsPending > 0) {
    // set the data
    sfGetAddListEntry(FName, CName, PNumber);
    sfFaxList->FaxName = FName;
    sfFaxList->CoverName = CName;
    sfFaxList->PhoneNumber = PNumber;

    // show the dialog
    if (sfFaxList->ShowModal() == mrOk &&
       (sfFaxList->PhoneNumber != "") &&
       sfFaxList->FaxName != "") {
      // add this fax entry to the list
      S = sfFaxList->PhoneNumber + "^" + sfFaxList->FaxName;
      if (sfFaxList->CoverName != "")
        S = S + "^" + sfFaxList->CoverName;
      FaxList->Add(S);

      // add this fax entry to the list box
      char buff[100];
      sprintf(buff, "%-20s %-20s %-20s",
        LimitS(sfFaxList->PhoneNumber, 20).c_str(),
        LimitS(sfFaxList->FaxName, 20).c_str(),
        LimitS(sfFaxList->CoverName, 20).c_str());
      S = buff;
      sfFaxListBox->Items->Add(S);
    }
  }

  AddsInProgress = false;
}


void __fastcall TsfMain::sfAddClick(TObject *Sender)
{
  sfAppendAddList("", "", "");
  sfAddPrim();
}
//---------------------------------------------------------------------------

void __fastcall TsfMain::sfAddFromPrinterDriver(TMessage& Message)
{
  Word JobID;
  char KeyBuf[8];
  char zFName[255];

  /* The message received from the printer driver has a job identifier
     in the wParam field.  This job identifier points to an entry in the
     SendFax.Ini file which the printer driver has added.  As SendFax
     handles each message, it should delete that job entry from the Ini
     file and queue the job for display in the Add dialog. */
  JobID = (Word)Message.WParam;
  sprintf(KeyBuf, "Job %d", LOBYTE(JobID));
  GetPrivateProfileString("FaxJobs",
    KeyBuf, "", zFName, sizeof(zFName), "SENDFAX.INI");
  // now delete the entry so the ID can be re-used by the printer driver
  WritePrivateProfileString("FaxJobs", KeyBuf, NULL, "SENDFAX.INI");

  sfAppendAddList(String(zFName), "", "");

  if (!AddsInProgress)
    sfAddPrim();
}

void TsfMain::sfAddFromCmdLine()
{
  if (ParamStr(1) == "/F") {
    sfAppendAddList(ParamStr(2), "", "");
    if (!AddsInProgress)
      sfAddPrim();
  }
}

void __fastcall TsfMain::sfExitClick(TObject *Sender)
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
void __fastcall TsfMain::sfModifyClick(TObject *Sender)
{
  int SaveIndex, CPos;
  String S;

  if (InProgress) {
    MessageBeep(-1);
    return;
  }

  // Exit if nothing selected
  if (sfFaxListBox->ItemIndex == -1)
    return;

  // Set the button text
  sfFaxList->flAction->Caption = "&Modify";

  // Note the listbox index, use it get data from FileList
  SaveIndex = sfFaxListBox->ItemIndex;
  S = FaxList->Strings[SaveIndex];
  CPos = S.Pos("^");
  sfFaxList->PhoneNumber = S.SubString(1, CPos - 1);
  S = S.SubString(CPos + 1, 255);
  CPos = S.Pos("^");
  if (CPos == 0)
    sfFaxList->FaxName = S;
  else {
    sfFaxList->FaxName = S.SubString(1, CPos - 1);
    sfFaxList->CoverName = S.SubString(CPos + 1, 255);
  }

  // Show the dialog
  if (sfFaxList->ShowModal() == mrOk) {
    // Modify the FaxList entry
    S = sfFaxList->PhoneNumber + "^" + sfFaxList->FaxName;
    if (sfFaxList->CoverName != "")
      S = S + "^" + sfFaxList->CoverName;
    FaxList->Strings[SaveIndex] = S;

    // Add this fax entry to the list box
    char buff[50];
    sprintf(buff, "%-20s %-20s %-20s",
      LimitS(sfFaxList->PhoneNumber, 20).c_str(),
      LimitS(sfFaxList->FaxName, 20).c_str(),
      LimitS(sfFaxList->CoverName, 20).c_str());
    sfFaxListBox->Items->Strings[SaveIndex] = buff;
  }
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfDeleteClick(TObject *Sender)
{
  int Index;
  
  if (InProgress) {
    MessageBeep(-1);
    return;
  }

  if (sfFaxListBox->ItemIndex != -1) {
    Index = sfFaxListBox->ItemIndex;
    sfFaxListBox->Items->Delete(Index);
    FaxList->Delete(Index);
  }
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::ApdSendFax1FaxLog(TObject *CP, TFaxLogCode LogCode)
{
  if (LogCode == lfaxTransmitOk) {
    FaxIndex--;
    sfFaxListBox->Items->Delete(FaxIndex);
    FaxList->Delete(FaxIndex);
  }
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfFaxClassClick(TObject *Sender)
{
  ApdSendFax1->FaxClass = (TFaxClass)(sfFaxClass->ItemIndex + 1);
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfDialAttemptsChange(TObject *Sender)
{
  try {
    ApdSendFax1->DialAttempts = (Word)sfDialAttempts->Text.ToInt();
  }
  catch (...) {
    if (sfDialAttempts->Text != "") throw;
  }
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfRetryWaitChange(TObject *Sender)
{
  try {
    ApdSendFax1->DialRetryWait = (Word)sfRetryWait->Text.ToInt();
  }
  catch (...) {
    if (sfRetryWait->Text != "") throw;
  }
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfStationIDChange(TObject *Sender)
{
  ApdSendFax1->StationID = sfStationID->Text;
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfDialPrefixChange(TObject *Sender)
{
  ApdSendFax1->DialPrefix = sfDialPrefix->Text;
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfModemInitChange(TObject *Sender)
{
  ApdSendFax1->ModemInit = sfModemInit->Text;
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfHeaderChange(TObject *Sender)
{
  ApdSendFax1->HeaderLine = sfHeader->Text;
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::sfSelectComPortClick(TObject *Sender)
{
  ApdTapiDevice1->SelectDevice();
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::ApdTapiDevice1TapiPortOpen(TObject *Sender)
{
  // TAPI port is configured and open, star the fax session
  ApdSendFax1->StartTransmit();
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::ApdTapiDevice1TapiPortClose(TObject *Sender)
{
  InProgress = False;
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::ApdSendFax1FaxFinish(TObject *CP, int ErrorCode)
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
void __fastcall TsfMain::HdrFontBtnClick(TObject *Sender)
{
  FontDialog1->Font = ApdSendFax1->EnhHeaderFont;
  if (FontDialog1->Execute())
    ApdSendFax1->EnhHeaderFont = FontDialog1->Font;
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::CvrFontBtnClick(TObject *Sender)
{
  FontDialog1->Font = ApdSendFax1->EnhFont;
  if (FontDialog1->Execute())
    ApdSendFax1->EnhFont = FontDialog1->Font;
}
//---------------------------------------------------------------------------
void __fastcall TsfMain::FormCreate(TObject *Sender)
{
  if(sfHeader->Text == "Default header")
    sfHeader->Text = "Fax sent by $I using APro " + ApdSendFax1->Version + "   $D $T";
}
//---------------------------------------------------------------------------


void __fastcall TsfMain::ApdSendFax1FaxNext(TObject *CP,
      TPassString &APhoneNumber, TPassString &AFaxFile,
      TPassString &ACoverFile)
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

