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
/*                      EXTAPIA0.H                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ExTapiA0H
#define ExTapiA0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include "AdTapi.hpp"
#include "AdTStat.hpp"
#include "OoMisc.hpp"
#include "ADTrmEmu.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TApdComPort *ApdComPort1;
	TApdTapiDevice *ApdTapiDevice1;
	TApdTapiStatus *ApdTapiStatus1;
	TApdTapiLog *ApdTapiLog1;
	TButton *Answer;
	TButton *Hangup;
    TAdTerminal *AdTerminal1;
    TAdVT100Emulator *AdVT100Emulator1;
	void __fastcall AnswerClick(TObject *Sender);
	void __fastcall HangupClick(TObject *Sender);
	void __fastcall ApdTapiDevice1TapiPortOpen(TObject *Sender);
private:	// User declarations
public:		// User declarations
	virtual __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
