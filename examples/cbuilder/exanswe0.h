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
/*                      EXANSWE0.H                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef exanswe0H
#define exanswe0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Buttons.hpp>
#include "AdPort.hpp"
#include "AdMdm.hpp"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TListBox *ListBox1;
	TApdComPort *ApdComPort1;
	TBitBtn *BitBtn1;
    TAdModem *AdModem1;void __fastcall BitBtn1Click(TObject *Sender);
  void __fastcall ApdModem1GotLineSpeed(TObject *M, int Speed);
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall AdModem1ModemCallerID(TAdCustomModem *Modem,
          TApdCallerIDInfo &CallerID);
    void __fastcall AdModem1ModemConnect(TAdCustomModem *Modem);
    void __fastcall AdModem1ModemDisconnect(TAdCustomModem *Modem);
    void __fastcall AdModem1ModemLog(TAdCustomModem *Modem,
          TApdModemLogCode LogCode);
    void __fastcall AdModem1ModemStatus(TAdCustomModem *Modem,
          TApdModemState ModemState);
    void __fastcall AdModem1ModemFail(TAdCustomModem *Modem, int FailCode);
private:	// User declarations
	void AddStatus(const String Msg);
public:		// User declarations
	virtual __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
