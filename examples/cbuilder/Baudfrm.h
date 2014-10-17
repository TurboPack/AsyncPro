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
/*                      BAUDFRM.H                        */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef BaudfrmH
#define BaudfrmH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Buttons.hpp>
#include "admoddb.hpp"
//---------------------------------------------------------------------------
class TBaudForm : public TForm
{
__published:	// IDE-managed Components
	TBitBtn *OKBtn;
	TBitBtn *CancelBtn;
	TBitBtn *HelpBtn;
	TGroupBox *GroupBox1;
	TLabel *Label1;
	TEdit *BPSEdit;
	TCheckBox *LockDTECheck;
	void __fastcall OKBtnClick(TObject *Sender);
private:	// User declarations
	TModemInfo* EditData;
public:		// User declarations
	virtual __fastcall TBaudForm(TComponent* Owner);
  void Init(TModemInfo* Data);
};
//---------------------------------------------------------------------------
extern TBaudForm *BaudForm;
//---------------------------------------------------------------------------
#endif
