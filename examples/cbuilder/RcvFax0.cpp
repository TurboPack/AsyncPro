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
/*                      RCVFAX0.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include <stdio.h>

#include "RcvFax0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdFStat"
#pragma link "AdFax"
#pragma link "AdTapi"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
  rfDirectory->Text = ApdReceiveFax1->DestinationDir;
  rfModemInit->Text = ApdReceiveFax1->ModemInit;
  InProgress = false;
}
//---------------------------------------------------------------------------
String TForm1::LimitS(String const S, Word Len)
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
void __fastcall TForm1::ApdReceiveFax1FaxError(TObject *CP, int ErrorCode)
{
  ShowMessage("Fax error: " + String(ErrorMsg((Word)ErrorCode)));
}
//---------------------------------------------------------------------------
void __fastcall TForm1::rfExitClick(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::rfDirectoryChange(TObject *Sender)
{
  ApdReceiveFax1->DestinationDir = rfDirectory->Text;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::rfModemInitChange(TObject *Sender)
{
  ApdReceiveFax1->ModemInit = rfModemInit->Text;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::rfFaxClassClick(TObject *Sender)
{
  ApdReceiveFax1->FaxClass = TFaxClass(rfFaxClass->ItemIndex + 1);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::rfNameStyleClick(TObject *Sender)
{
  ApdReceiveFax1->FaxNameMode = TFaxNameMode(rfNameStyle->ItemIndex + 1);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::rfReceiveFaxesClick(TObject *Sender)
{
  if (!InProgress) {
    InProgress = true;
    ApdReceiveFax1->FaxClass = (TFaxClass)(rfFaxClass->ItemIndex + 1);
    ApdReceiveFax1->DestinationDir = rfDirectory->Text;
    ApdReceiveFax1->ModemInit = rfModemInit->Text;

    if (ApdComPort1->TapiMode == tmOn ||
       ((ApdComPort1->TapiMode == Adport::tmAuto) &&
        ApdTapiDevice1->SelectedDevice != "")) {
      // Tell TAPI to configure and open the port
      ApdTapiDevice1->ConfigAndOpen();
    }
    else {
      // Open the port and start receiving
      ApdComPort1->Open = true;
      ApdReceiveFax1->StartReceive();
    }
  }
  else
    MessageBeep(-1);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdReceiveFax1FaxLog(TObject *CP, TFaxLogCode LogCode)
{
  int FSize;
  String S;

  if (LogCode == lfaxReceiveOk) {
    // Get the file size
    WIN32_FIND_DATA data;
    FindFirstFile(String(ApdReceiveFax1->FaxFile).c_str(), &data);
    FSize = data.nFileSizeLow;

    // Add an entry to the displayed list box of received files
    char buff[256];
    String s = ExtractFileName(ApdReceiveFax1->FaxFile);
    s = LimitS(s, 20);
    sprintf(buff, "%-25s %-20s %-20s",
      LimitS(ExtractFileName(ApdReceiveFax1->FaxFile), 20).c_str(),
      String(FSize).c_str(), Now().DateString().c_str());
    rfReceiveList->Items->Add(buff);
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdReceiveFax1FaxFinish(TObject *CP, int ErrorCode)
{
  if (ApdComPort1->TapiMode == tmOn)
    if (ApdTapiDevice1->CancelCall())
      // Call cancelled immediately, clear InProgress flag
      InProgress = false;
    else ;
      // CancelCall proceeding in background, waiting for OnTapiPortClose
  else {
    // Not using TAPI, just close the port and clear the InProgress flag
    ApdComPort1->Open = false;
    InProgress = false;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::rfSelectPortClick(TObject *Sender)
{
  ApdTapiDevice1->SelectDevice();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiPortOpen(TObject *Sender)
{
  // TAPI port is configured and open, star the fax session
  ApdReceiveFax1->StartReceive();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdTapiDevice1TapiPortClose(TObject *Sender)
{
  InProgress = false;
}
//---------------------------------------------------------------------------
