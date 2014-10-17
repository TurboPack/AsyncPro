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

#include "RasDemo0.h"
//---------------------------------------------------------------------------
#pragma link "AdRas"
#pragma link "OoMisc"
#pragma link "AdRStat"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  if (ApdRasDialer->PlatformID != VER_PLATFORM_WIN32_NT)
    PhonebookDlg1->Enabled = false;
  RefreshEntryListClick(0);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::RefreshEntryListClick(TObject *Sender)
{
  int Error = ApdRasDialer->ListEntries(EntrySelect->Items);
  if (Error == ecOK)
  {
    if (EntrySelect->Items->Count > 0)
    {
      EntrySelect->ItemIndex = 0;
      ApdRasDialer->EntryName = EntrySelect->Text;
      StatusBar1->Panels->Items[0]->Text = ApdRasDialer->EntryName;
      DisplayDialParameters();
    }
  }
  else
    StatusBar1->Panels->Items[0]->Text = ApdRasDialer->GetErrorText(Error);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Dial1Click(TObject *Sender)
{
  SetDialParameters();
  SetDialOptions();
  int Error = ApdRasDialer->Dial();
  if (Error != ecRasOK)
    StatusBar1->Panels->Items[0]->Text = ApdRasDialer->GetErrorText(Error);
	
}
//---------------------------------------------------------------------------
void __fastcall TForm1::PhonebookDlg1Click(TObject *Sender)
{
  int Error = ApdRasDialer->PhonebookDlg();
  if (Error != ecRasOK)
    StatusBar1->Panels->Items[0]->Text = ApdRasDialer->GetErrorText(Error);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Hangup1Click(TObject *Sender)
{
  ApdRasDialer->Hangup();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::DisplayDialParameters()
{
  UserNameEdit->Text        = ApdRasDialer->UserName;
  DomainEdit->Text          = ApdRasDialer->Domain;
  PhoneNumberEdit->Text     = ApdRasDialer->PhoneNumber;
  DialModeSelect->ItemIndex = (int)ApdRasDialer->DialMode;
  PasswordEdit->Text        = ApdRasDialer->Password;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::SetDialParameters()
{
  ApdRasDialer->EntryName   = EntrySelect->Text;
  ApdRasDialer->Password    = PasswordEdit->Text;
  ApdRasDialer->UserName    = UserNameEdit->Text;
  ApdRasDialer->Domain      = DomainEdit->Text;
  ApdRasDialer->PhoneNumber = PhoneNumberEdit->Text;
  ApdRasDialer->DialMode    = (TApdRasDialMode)DialModeSelect->ItemIndex;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::DisplayDialOptions()
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::SetDialOptions()
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::DisableDialOptions()
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::NewPhonebookEntryClick(TObject *Sender)
{
  int Error = ApdRasDialer->CreatePhonebookEntry();
  if (Error == ecRasOK)
    RefreshEntryListClick(0);
  else
    StatusBar1->Panels->Items[0]->Text = ApdRasDialer->GetErrorText(Error);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::EditPhonebookEntryClick(TObject *Sender)
{
  int Error = ApdRasDialer->EditPhonebookEntry();
  if (Error == ecRasOK)
    DisplayDialParameters();
  else
    StatusBar1->Panels->Items[0]->Text = ApdRasDialer->GetErrorText(Error);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Deleteentry1Click(TObject *Sender)
{
  int Error = ApdRasDialer->DeletePhonebookEntry();
  if (Error == ecRasOK)
  {
    RefreshEntryListClick(0);
    DisplayDialParameters();
  }
  else
    StatusBar1->Panels->Items[0]->Text = ApdRasDialer->GetErrorText(Error);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdRasDialerDialStatus(TObject *Sender, int Status)
{
  StatusBar1->Panels->Items[0]->Text = ApdRasDialer->GetStatusText(Status);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::PhonebookBtnClick(TObject *Sender)
{
  OpenDialog->FileName = "*.pbk";
  if (OpenDialog->Execute())
    PhonebookEdit->Text = OpenDialog->FileName;
  else
    PhonebookEdit->Text = "Default";
  ApdRasDialer->Phonebook = PhonebookEdit->Text;
  RefreshEntryListClick(0);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Exit1Click(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdRasDialerConnected(TObject *Sender)
{
  StatusBar1->Panels->Items[0]->Text = "Connected";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdRasDialerDialError(TObject *Sender, int Error)
{
  StatusBar1->Panels->Items[0]->Text = ApdRasDialer->GetErrorText(Error);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::EntrySelectChange(TObject *Sender)
{
  ApdRasDialer->EntryName = EntrySelect->Text;
  DisplayDialParameters();
  StatusBar1->Panels->Items[0]->Text = ApdRasDialer->EntryName;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdRasDialerDisconnected(TObject *Sender)
{
  StatusBar1->Panels->Items[0]->Text = "Disconnected";
}
//---------------------------------------------------------------------------

