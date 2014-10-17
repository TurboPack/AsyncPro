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
/*                      Cvtmain.cpp                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "Cvtmain.h"
#include "cvtopt.h"
#include "oomisc.hpp"
#include "cvtprog.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TCvtMainForm *CvtMainForm;
//---------------------------------------------------------------------------
__fastcall TCvtMainForm::TCvtMainForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
bool TCvtMainForm::ContainsWildCards(String S)
{
  for (int i=1;i<S.Length()+1;i++) {
    String temp = S[i];
    if (temp == String("*") || temp == String("?")) {
      return true;
    }
  }
  return false;
}

bool TCvtMainForm::FileInConvertList(const String FName)
{
  // Return TRUE if FName is in the convert file list
  return ConvertList->Items->IndexOf(FName) != -1;
}

void __fastcall TCvtMainForm::OptionsBtnClick(TObject *Sender)
{
  CvtOptionsForm = new TCvtOptionsForm(this);
  CvtOptionsForm->ShowModal();
  delete CvtOptionsForm;
}
//---------------------------------------------------------------------------
void __fastcall TCvtMainForm::AddBtnClick(TObject *Sender)
{
  int I;
  String N;
  String TempDir;
  //if any files are selected, add them to the convert list
  if (FileListBox->SelCount != 0 && !ContainsWildCards(FileNameEdit->Text)) {
    Cursor = crHourGlass;
    for (I=0;I<FileListBox->Items->Count;I++)
      if (FileListBox->Selected[I]
        && !FileInConvertList(LowerCase(FileListBox->FileName))) {
        String s = AddBackSlash(FileListBox->Directory);
        s += FileListBox->Items->Strings[I];
        s = s.LowerCase();
        ConvertList->Items->Add(s);
      }
    OkBtn->Enabled = true;
    Cursor = crDefault;
  //no files are selected, but maybe user typed a file name
  }
  else {
    N = FileNameEdit->Text.Trim();
    //if nothing is entered, beep and let user try again
    if (N == "") {
      MessageBeep(0);
      FileNameEdit->SetFocus();
      return;
    }

    //get the fully qualified name of the file
    N = ExpandFileName(N);
    N.LowerCase();

    //extract the directory portion of the file name
    TempDir = ExtractFilePath(N);

    //if the directory is not valid, beep and let user try again
    if (!DirectoryExists(TempDir.c_str())) {
      MessageBeep(0);
      FileNameEdit->SetFocus();
      return;
    }

    //if the name contains no wildcards, add the file to the convert list
    if (!ContainsWildCards(N)) {

      //make sure the file exists
      if (!FileExists(N)) {
        MessageBeep(0);
        FileNameEdit->SetFocus();
      }
      //make sure the file isn't already in the list
      else if (!FileInConvertList(N)) {
        ConvertList->Items->Add(N);
        FileNameEdit->Text = "";
        OkBtn->Enabled = true;
      }
    }
    //the name contains wildcards, so reset the directory and mask and
    //reload the listboxes
    else {
      FileListBox->Mask = N;
      DirectoryListBox->Directory = TempDir;
      FileNameEdit->Text = "";
    }
  }
}
//---------------------------------------------------------------------------
void __fastcall TCvtMainForm::ConvertListClick(TObject *Sender)
{
  CvtMainForm->RemoveBtn->Enabled = true;
}
//---------------------------------------------------------------------------
void __fastcall TCvtMainForm::RemoveBtnClick(TObject *Sender)
{
  int I;
  if (ConvertList->Items->Count <= 0) return;

  Cursor = crHourGlass;
  for (I=ConvertList->Items->Count-1;I>-1;I--)
    if (ConvertList->Selected[I])
      ConvertList->Items->Delete(I);
  RemoveBtn->Enabled = false;
  OkBtn->Enabled = (ConvertList->Items->Count != 0);
  Cursor = crDefault;
}
//---------------------------------------------------------------------------
void __fastcall TCvtMainForm::OkBtnClick(TObject *Sender)
{
  int I;
  if (ConvertList->Items->Count != 0)
    for (I=0;I<ConvertList->Items->Count;I++)
      CvtProgressForm->ConvertList->Items->Add(ConvertList->Items->Strings[I]);
  CvtProgressForm->ShowModal();
  CvtProgressForm->ConvertList->Items->Clear();
  ConvertList->Items->Clear();
  OkBtn->Enabled = false;
}
//---------------------------------------------------------------------------
void __fastcall TCvtMainForm::CancelBtnClick(TObject *Sender)
{
  Close();  
}
//---------------------------------------------------------------------------
void __fastcall TCvtMainForm::FileListBoxDblClick(TObject *Sender)
{
  String Path = FileListBox->FileName;
  Path = Path.LowerCase();
  if (Path == "") return;
  if (!FileInConvertList(Path)) {
    ConvertList->Items->Add(Path);
    OkBtn->Enabled = true;
  }
}
//---------------------------------------------------------------------------
