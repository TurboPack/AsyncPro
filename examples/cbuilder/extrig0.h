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
/*                      EXTRIG0.H                        */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef extrig0H
#define extrig0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include <iostream.h>
#include "OoMisc.hpp"

void WriteIt(char C);

//---------------------------------------------------------------------------
class TExTrigTest : public TForm
{
__published:	// IDE-managed Components
	TButton *StartTest;
	TLabel *Label1;
	TApdComPort *ApdComPort1;
	void __fastcall ApdComPort1TriggerAvail(TObject *CP, WORD Count);
	void __fastcall ApdComPort1TriggerData(TObject *CP, WORD TriggerHandle);
	void __fastcall ApdComPort1TriggerTimer(TObject *CP, WORD TriggerHandle);
	void __fastcall StartTestClick(TObject *Sender);
  
private:	// User declarations
  Word TimerHandle;
  Word Data1Handle;
  Word Data2Handle;
  Word Data3Handle;
public:		// User declarations
	virtual __fastcall TExTrigTest(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TExTrigTest *ExTrigTest;
//---------------------------------------------------------------------------
#endif
