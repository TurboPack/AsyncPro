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
/*                      EXTHAN0.H                        */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef exthan0H
#define exthan0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include "OoMisc.hpp"
#include "ADTrmEmu.hpp"
//---------------------------------------------------------------------------
TApdComPort* GlobalPort;

class TMyListBox : public TListBox
{
 	public:
  	__fastcall virtual TMyListBox(TComponent* Owner) : TListBox(Owner) {}
	  void __fastcall TriggerAvail(TMessage& Msg);
    
  BEGIN_MESSAGE_MAP
 		MESSAGE_HANDLER(apw_TriggerAvail, TMessage, TriggerAvail);
 	END_MESSAGE_MAP(TListBox)
};

class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TApdComPort *ApdComPort1;
	TButton *Register;
    TAdTerminal *AdTerminal1;
	void __fastcall RegisterClick(TObject *Sender);
private:	// User declarations
	TMyListBox* ListBox1;
public:		// User declarations
	virtual __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
