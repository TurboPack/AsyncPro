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

#include "FtpDemo0.h"
//---------------------------------------------------------------------------
#pragma link "AdFtp"
#pragma link "OoMisc"
#pragma link "AdWnPort"
#pragma link "AdPort"
#pragma resource "*.dfm"
TForm1 *Form1;


char DefCaption[] = "FtpDemo: Ftp Client";
//---------------------------------------------------------------------------
bool __fastcall GetFileName(String Caption, String &FN)
{
  FN = "";
  return(InputQuery("FtpDemo", Caption, FN));
}
//---------------------------------------------------------------------------
bool __fastcall GetRemoteDirName(String &R)
{
  return(GetFileName("Remote Directory", R));
}
//---------------------------------------------------------------------------
bool __fastcall GetRemoteFileName(String &R)
{
  return(GetFileName("Remote file name", R));
}
//---------------------------------------------------------------------------
bool __fastcall GetRLNames(String &R, String &L)
{
  bool Result = false;
  if (GetFileName("Remote file name", R))
    Result = GetFileName("Local file name", L);
  return(Result);
}
//---------------------------------------------------------------------------
bool __fastcall GetRNNames(String &R, String &N)
{
  bool Result = false;
  if (GetFileName("Remote file name", R))
    Result = GetFileName("New file name", N);
  return(Result);
}
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::GetProperties()
{
  UserNameEdit->Text = ApdFtpClient1->UserName;
  PasswordEdit->Text = ApdFtpClient1->Password;
  ServerEdit->Text = ApdFtpClient1->ServerAddress;
  TimeoutEdit->Text = IntToStr(ApdFtpClient1->TransferTimeout);
  RestartEdit->Text = IntToStr(ApdFtpClient1->RestartAt);
  FileType1->ItemIndex = (int)ApdFtpClient1->FileType;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::SetProperties()
{
  ApdFtpClient1->UserName = UserNameEdit->Text;
  ApdFtpClient1->Password = PasswordEdit->Text;
  ApdFtpClient1->ServerAddress = ServerEdit->Text;
  ApdFtpClient1->TransferTimeout = StrToIntDef(TimeoutEdit->Text, 1092);
  ApdFtpClient1->RestartAt = StrToIntDef(RestartEdit->Text, 0);
  ApdFtpClient1->FileType = (TFtpFileType)FileType1->ItemIndex;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormActivate(TObject *Sender)
{
  GetProperties();	
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Exit1Click(TObject *Sender)
{
  Logout1Click(Sender);
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Login1Click(TObject *Sender)
{
  SetProperties();
  ApdFtpClient1->Login();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Logout1Click(TObject *Sender)
{
  ApdFtpClient1->Logout();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Change1Click(TObject *Sender)
{
  String R;
  if (GetRemoteDirName(R))
    ApdFtpClient1->ChangeDir(R);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::NamesList1Click(TObject *Sender)
{
  String R;
  if (GetFileName("Remote directory or null string", R))
    ApdFtpClient1->ListDir(R, false);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FullList1Click(TObject *Sender)
{
  String R;
  if (GetFileName("Remote directory or null string", R))
    ApdFtpClient1->ListDir(R, true);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Help1Click(TObject *Sender)
{
  String C;
  C = "";
  if (InputQuery("ExApdFtpClient1 - Help", "FTP command", C))
    ApdFtpClient1->Help(C);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Send1Click(TObject *Sender)
{
  String R, L;
  if (GetRLNames(R, L))
  {
    SetProperties();
    ApdFtpClient1->Store(R, L, (TFtpStoreMode)SendMode1->ItemIndex);
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Receive1Click(TObject *Sender)
{
  String R, L;
  if (GetRLNames(R, L))
  {
    SetProperties();
    ApdFtpClient1->Retrieve(R, L, (TFtpRetrieveMode)ReceiveMode1->ItemIndex);
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::CreateDir1Click(TObject *Sender)
{
  String R;
  if (GetRemoteDirName(R))
    ApdFtpClient1->MakeDir(R);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Delete1Click(TObject *Sender)
{
  String R;
  if (GetRemoteFileName(R))
    ApdFtpClient1->Delete(R);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::SendFtp1Click(TObject *Sender)
{
  String C;
  C = "";
  if (InputQuery(DefCaption, "Ftp command", C))
    ApdFtpClient1->SendFtpCommand(C);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Status1Click(TObject *Sender)
{
  String R;
  if (GetRemoteDirName(R))
    ApdFtpClient1->Status(R);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Log1Click(TObject *Sender)
{
  Log1->Checked = !Log1->Checked;
  ApdFtpLog1->Enabled = Log1->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Rename1Click(TObject *Sender)
{
  String R, N;
  if (GetRNNames(R, N))
    ApdFtpClient1->Rename(R, N);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::AbortBtnClick(TObject *Sender)
{
  ApdFtpClient1->Abort();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Clear1Click(TObject *Sender)
{
  InfoMemo->Clear();
  ReplyMemo->Clear();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdFtpClient1FtpStatus(TObject *Sender,
	TFtpStatusCode StatusCode, PChar Info)
{
  switch (StatusCode)
  {
    case scClose : Caption = DefCaption;
      break;
    case scOpen :  Caption = " Connected to " + ApdFtpClient1->ServerAddress;
      break;
    case scComplete : InfoMemo->Lines->Add("operation complete");
      break;
    case scDataAvail : InfoMemo->Lines->SetText(Info);
      break;
    case scLogin : Caption = ApdFtpClient1->UserName + " Logged in to " +
                             ApdFtpClient1->ServerAddress;
      break;
    case scLogout : Caption = ApdFtpClient1->UserName + " Logged out";
      break;
    case scProgress : Caption = IntToStr(ApdFtpClient1->BytesTransferred) +
                                " bytes Transferred";
      break;
    case scTransferOK : Caption = Caption + " - transfer complete";
      break;
    case scTimeout : ShowMessage("Transfer timed out");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdFtpClient1FtpReply(TObject *Sender, int ReplyCode,
	PChar Reply)
{
  ReplyMemo->Lines->Add(Reply);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdFtpClient1FtpError(TObject *Sender, int ErrorCode,
	PChar ErrorText)
{
  char MBCaption[25];
  strcpy(MBCaption, "FTP Error: " + ErrorCode);
  MessageBox(Handle, ErrorText, MBCaption, MB_ICONEXCLAMATION | MB_OK);
}
//---------------------------------------------------------------------------
