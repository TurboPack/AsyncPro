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
/*                      TAGFRM.CPP                       */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "Tagfrm.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TTagForm *TagForm;

void TTagForm::Init(TTagArray* Data, Word* NumTags)
{
	//for (int i=0;i<5;i++)
  //	EditData[i] = Data[i];
  EditData = Data[0];
  EditNum = NumTags;

  // set initial values
  Tag1Edit->Text = EditData[0];
  Tag2Edit->Text = EditData[1];
  Tag3Edit->Text = EditData[2];
  Tag4Edit->Text = EditData[3];
  Tag5Edit->Text = EditData[4];
}

//---------------------------------------------------------------------------
__fastcall TTagForm::TTagForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TTagForm::OKBtnClick(TObject *Sender)
{
  Word OT;
  TTagArray Temp;

  // put strings in array
  EditData[0] = Tag1Edit->Text;
  EditData[1] = Tag2Edit->Text;
  EditData[2] = Tag3Edit->Text;
  EditData[3] = Tag4Edit->Text;
  EditData[4] = Tag5Edit->Text;

  // remove blank strings between tags
  memset(Temp, 0, sizeof(Temp));
  OT = 0;
  for (int i=0;i<MaxTags+1;i++) {
    if (String(EditData[i]) != "") {
      Temp[OT] = EditData[i];
      OT++;
   }
	}
  for (int i=0;i<5;i++)
  	EditData[i] = Temp[i];
  *EditNum = OT;
  ModalResult = mrOk;
}
//---------------------------------------------------------------------------
