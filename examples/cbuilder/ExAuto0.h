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
#ifndef ExAuto0H
#define ExAuto0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include "OoMisc.hpp"
#include "AdPacket.hpp"
#include "AdProtcl.hpp"
#include "ADTrmEmu.hpp"
#include "AdMdm.hpp"


enum TMyState { msNone, msInit, msConnect, msLogon, msXFer1, msXFer2, msQuit };
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TApdComPort *ApdComPort1;
	TApdDataPacket *ApdDataPacket1;
	TApdProtocol *ApdProtocol1;
	TEdit *Edit1;
	TButton *btnDial;
	TButton *btnAnswer;
	TButton *btnCancel;
    TAdTerminal *AdTerminal1;
    TAdModem *AdModem1;
	void __fastcall btnDialClick(TObject *Sender);
	void __fastcall btnAnswerClick(TObject *Sender);
	void __fastcall btnCancelClick(TObject *Sender);
	void __fastcall ApdComPort1TriggerAvail(TObject *CP, WORD Count);
	void __fastcall ApdProtocol1ProtocolFinish(TObject *CP, int ErrorCode);
	void __fastcall ApdProtocol1ProtocolStatus(TObject *CP, WORD Options);
	void __fastcall ApdDataPacket1Packet(TObject *Sender, Pointer Data, int Size);
	void __fastcall ApdComPort1TriggerModemStatus(TObject *Sender);
    void __fastcall AdModem1ModemConnect(TAdCustomModem *Modem);
private:	// User declarations
	TMyState MyState;
    bool IsClient;
    String ClientPassword;
    Word DCDTrig;
    void WriteTerm(const String S);
    void CheckPassword(const String S);
public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
static String Password = "asyncprofessional";
//---------------------------------------------------------------------------
#endif
 
