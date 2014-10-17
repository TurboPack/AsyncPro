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

#include "FtpAuto1.h"
//---------------------------------------------------------------------------
#pragma link "AdFtp"
#pragma link "AdWnPort"
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;

TStringList *DownloadList; // list files to be transfered
AnsiString CurrentFile;    // file currently being transfered
AnsiString  SelectedDir;   // current working directory

//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  edtURL->Text      = ApdFtpClient1->ServerAddress;
  edtUsername->Text = ApdFtpClient1->UserName;
  edtPassword->Text = ApdFtpClient1->Password;
  DownloadList      = new TStringList;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnLoginClick(TObject *Sender)
{
  ApdFtpClient1->ServerAddress = edtURL->Text;
  ApdFtpClient1->UserName      = edtUsername->Text;
  ApdFtpClient1->Password      = edtPassword->Text;
  ApdFtpClient1->Login();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnLogoutClick(TObject *Sender)
{
  ApdFtpClient1->Logout();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdFtpClient1FtpStatus(TObject *Sender,
	TFtpStatusCode StatusCode, PChar InfoText)
{
  switch (StatusCode) {
    case scLogout :     // cleanup lists
      Caption = "Logged out";
      lbxFiles->Clear();
      DownloadList->Clear();
      break;
    case scLogin :      // request name of CWD
      Caption = "Logged in";
      ApdFtpClient1->CurrentDir();
      break;
    case scCurrentDir : // request a list of files in CWD
      ApdFtpClient1->ListDir("", False);
      break;
    case scComplete :   // CWD changed, request its name
      ApdFtpClient1->CurrentDir();
      break;
    case scDataAvail :  // file list data, download 1st in the list
      lbxFiles->Items->Text = StrPas(InfoText);
      DownloadList->Assign(lbxFiles->Items);
      lbxFiles->Items->Insert(0, "..");
      lbxFiles->Items->Insert(0, ".");
      RetrieveNext();
      break;
    case scProgress :   // display download progress
      Caption = CurrentFile + "  " + IntToStr(ApdFtpClient1->BytesTransferred);
      break;
    case scTransferOK : // file downloaded, download the next in list
      if (DownloadList->Count > 0)
        DownloadList->Delete(0);
      RetrieveNext();
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::RetrieveNext(void)
{
  if (DownloadList->Count > 0) {
    CurrentFile = DownloadList->Strings[0];
    Caption = DownloadList->Strings[0];
    ApdFtpClient1->Retrieve(DownloadList->Strings[0],
      edtLocalDir->Text + "\\" + DownloadList->Strings[0],rmReplace);
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdFtpClient1FtpError(TObject *Sender, int ErrorCode,
	PChar ErrorText)
{
  if (DownloadList->Count > 0)
    DownloadList->Delete(0);
  RetrieveNext();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormDestroy(TObject *Sender)
{
  delete(DownloadList);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::lbxFilesMouseDown(TObject *Sender, TMouseButton Button,
	TShiftState Shift, int X, int Y)
{
  int i = lbxFiles->ItemAtPos(Point(X, Y), true);
  if (i > -1)
    SelectedDir = lbxFiles->Items->Strings[i];
}
//---------------------------------------------------------------------------
void __fastcall TForm1::lbxFilesDblClick(TObject *Sender)
{
  ApdFtpClient1->ChangeDir(SelectedDir);
}
//--------------------------------------------------------------------------- 
