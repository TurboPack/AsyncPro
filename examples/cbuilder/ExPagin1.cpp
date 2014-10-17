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

#include "ExPagin1.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TForm2 *Form2;
//---------------------------------------------------------------------------
__fastcall TForm2::TForm2(TComponent* Owner)
        : TForm(Owner)
{
}

//---------------------------------------------------------------------------
void __fastcall TForm2::ClearEds()
{
  edName->Text = "";
  edPagerAddr->Text = "";
  edPagerID->Text = "";
}
//---------------------------------------------------------------------------
void __fastcall TForm2::FormCreate(TObject *Sender)
{
  SetAddrCaption();
}
//---------------------------------------------------------------------------

void __fastcall TForm2::SetAddrCaption()
{
  Label3->Visible = FALSE;
  Label4->Visible = FALSE;

  switch (RadioGroup1->ItemIndex) {
    case 0: {
      Label3->Visible = TRUE;
      break;
    }

    case 1: {
      Label4->Visible = TRUE;
      break;
    }
  };
}

//---------------------------------------------------------------------------
void __fastcall TForm2::RadioGroup1Click(TObject *Sender)
{
  SetAddrCaption();
}
//---------------------------------------------------------------------------

