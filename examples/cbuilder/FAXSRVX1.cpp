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
/*                      FAXSRVX1.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "FaxSrvx1.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TfsFaxList *fsFaxList;
//---------------------------------------------------------------------------
__fastcall TfsFaxList::TfsFaxList(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
String TfsFaxList::GetFaxName()
{
  return flFileName->Text;
}

void TfsFaxList::SetFaxName(const String NewName)
{
  flFileName->Text = NewName;
}

String TfsFaxList::GetCoverName()
{
  return flCover->Text;
}

void TfsFaxList::SetCoverName(const String NewName)
{
  flCover->Text = NewName;
}

String TfsFaxList::GetPhoneNumber()
{
  return flPhoneNumber->Text;
}

void TfsFaxList::SetPhoneNumber(const String NewNumber)
{
  flPhoneNumber->Text = NewNumber;
}

void __fastcall TfsFaxList::flActionClick(TObject *Sender)
{
  ModalResult = mrOk;
}
//---------------------------------------------------------------------------
void __fastcall TfsFaxList::flCancelClick(TObject *Sender)
{
  ModalResult = mrCancel;
}
//---------------------------------------------------------------------------
void __fastcall TfsFaxList::FormActivate(TObject *Sender)
{
  flPhoneNumber->SetFocus();
}
//---------------------------------------------------------------------------
