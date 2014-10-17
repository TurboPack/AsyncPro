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
/*                      EXTMAIN0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "extmain0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma link "ADTrmEmu"
#pragma resource "*.dfm"
TExtMainForm *ExtMainForm;
//---------------------------------------------------------------------------
__fastcall TExtMainForm::TExtMainForm(TComponent* Owner)
	: TForm(Owner)
{
}

void __fastcall TExtMainForm::WMGetMinMaxInfo(TWMGetMinMaxInfo& Msg)
{
  if(ComponentState.Contains(csLoading)) return;
  int FrameWidth, FrameHeight, NewWidth, NewHeight, ScWidth, ScHeight;
  FrameWidth = Width - ClientWidth;
  FrameHeight = Height - ClientHeight;
  ScWidth = (ClientWidth - AdTerminal1->ClientWidth);
  ScHeight = (ClientHeight - AdTerminal1->ClientHeight);
  NewWidth = (AdTerminal1->CharWidth * AdTerminal1->Columns)
              + FrameWidth + ScWidth;
  NewHeight = (AdTerminal1->CharHeight * AdTerminal1->Rows)
               + FrameHeight + ScHeight;

  Msg.MinMaxInfo->ptMaxSize.y = NewHeight;
  Msg.MinMaxInfo->ptMaxSize.x = NewWidth;
  Msg.MinMaxInfo->ptMaxTrackSize.y = NewHeight;
  Msg.MinMaxInfo->ptMaxTrackSize.x = NewWidth;
}
//---------------------------------------------------------------------------
void __fastcall TExtMainForm::AdTerminal1KeyDown(TObject *Sender, WORD &Key,
	TShiftState Shift)
{
  if (Key == VK_INSERT)
    AdTerminal1->Scrollback = !AdTerminal1->Scrollback;
}
//---------------------------------------------------------------------------
