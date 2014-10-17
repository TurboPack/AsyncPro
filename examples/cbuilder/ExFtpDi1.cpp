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

#include "ExFtpDi1.h"
//---------------------------------------------------------------------------
#pragma link "AdFtp"
#pragma link "AdWnPort"
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;

AnsiString SelectedDir;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  edtServer->Text   = ApdFtpClient1->ServerAddress;
  edtUser->Text     = ApdFtpClient1->UserName;
  edtPassword->Text = ApdFtpClient1->Password;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnLoginClick(TObject *Sender)
{
  ApdFtpClient1->ServerAddress = edtServer->Text;
  ApdFtpClient1->UserName      = edtUser->Text;
  ApdFtpClient1->Password      = edtPassword->Text;
  ApdFtpClient1->Login();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnLogoutClick(TObject *Sender)
{
  ApdFtpClient1->Logout();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::lbxCurrentDirMouseDown(TObject *Sender,
	TMouseButton Button, TShiftState Shift, int X, int Y)
{
  int i = lbxCurrentDir->ItemAtPos(Point(X, Y), true);
  if (i > -1)
    SelectedDir = lbxCurrentDir->Items->Strings[i];
}
//---------------------------------------------------------------------------
void __fastcall TForm1::lbxCurrentDirDblClick(TObject *Sender)
{
  ApdFtpClient1->ChangeDir(SelectedDir);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdFtpClient1FtpStatus(TObject *Sender,
	TFtpStatusCode StatusCode, PChar InfoText)
{
  switch (StatusCode) {
    case scLogin      : ApdFtpClient1->CurrentDir();
                        break;
    case scLogout     : lbxCurrentDir->Clear();
                        Caption = "ExFtpDir";
                        break;
    case scComplete   : ApdFtpClient1->CurrentDir();
                        break;
    case scCurrentDir : Caption = InfoText;
                        ApdFtpClient1->ListDir("", false);
                        break;
    case scDataAvail  : lbxCurrentDir->Items->Text = InfoText;
                        lbxCurrentDir->Items->Insert(0, "..");
                        lbxCurrentDir->Items->Insert(0, ".");
                        break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdFtpClient1FtpError(TObject *Sender, int ErrorCode,
	PChar ErrorText)
{
  Caption = ErrorText;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnCloseClick(TObject *Sender)
{
  ApdFtpClient1->Logout();
  Close();
}
//--------------------------------------------------------------------------- 
