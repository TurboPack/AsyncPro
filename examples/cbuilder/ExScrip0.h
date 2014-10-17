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
#ifndef ExScrip0H
#define ExScrip0H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "AdPort.hpp"
#include "AdProtcl.hpp"
#include "AdPStat.hpp"
#include "AdScript.hpp"
#include "ADTrmEmu.hpp"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TAdTerminal *AdTerminal1;
    TButton *Start;
    TButton *Quit;
    TApdComPort *ApdComPort1;
    TApdScript *ApdScript1;
    TApdProtocol *ApdProtocol1;
    TApdProtocolStatus *ApdProtocolStatus1;
    void __fastcall StartClick(TObject *Sender);
    void __fastcall ApdScript1ScriptFinish(TObject *CP, int Condition);
    void __fastcall QuitClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
