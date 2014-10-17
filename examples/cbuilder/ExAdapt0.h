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
/*                      EXADAPT0.H                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ExAdapt0H
#define ExAdapt0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include "AdFax.hpp"
#include "AdFStat.hpp"
#include "OoMisc.hpp"
#include "ADTrmEmu.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TApdComPort *ApdComPort1;
	TApdReceiveFax *ApdReceiveFax1;
	TApdFaxStatus *ApdFaxStatus1;
	TApdFaxLog *ApdFaxLog1;
	TButton *Button1;
	TButton *Button2;
    TAdTerminal *AdTerminal1;
	void __fastcall ApdComPort1TriggerData(TObject *CP, WORD TriggerHandle);
	void __fastcall Button1Click(TObject *Sender);
	void __fastcall ApdComPort1TriggerTimer(TObject *CP, WORD TriggerHandle);
	void __fastcall Button2Click(TObject *Sender);
	void __fastcall ApdReceiveFax1FaxFinish(TObject *CP, int ErrorCode);
private:	// User declarations
    int dthRing;  // data trigger handle for 'RING'
    int dthConnect;  // data trigger handle for 'CONNECT'
    int dthVoice;  // data trigger handle for 'VOICE'
    int dthFax ;  // data trigger handle for 'FAX'
    int dthCED ;  // data trigger handle for 'CED' (fax)
    int dthPlusFCON;  // data trigger handle for '+FCON' (fax)
    int ttTimeout;  // timer trigger for connect timeout
		const bool CaseInsensitive;

    void RemoveMyTrigger(int& th);
    void RemoveAllMyTriggers();
public:		// User declarations
	virtual __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
