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
/*                      EXTCAP0.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "extcap0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma link "ADTrmEmu"
#pragma resource "*.dfm"
TExtCapExample *ExtCapExample;
//---------------------------------------------------------------------------
__fastcall TExtCapExample::TExtCapExample(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TExtCapExample::AdTerminal1KeyDown(TObject *Sender, WORD &Key,
	TShiftState Shift)
{
  switch (Key) {
    case VK_INSERT : {
      AdTerminal1->Scrollback = !AdTerminal1->Scrollback;
      break;
    }
  	case VK_F8 : {
      try {
        AdTerminal1->Capture = cmOn;
      }
      catch (...) {
      	ShowMessage("Failed to start capture");
      }
      break;
    }
    case VK_F9 : {
      try {
        AdTerminal1->Capture = cmOff;
      }
      catch (...) {
        ShowMessage("Failed to close capture file");
      }
      break;
    }
  }
}
//---------------------------------------------------------------------------
