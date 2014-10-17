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
#ifndef ExSapiB0H
#define ExSapiB0H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "AdPort.hpp"
#include "AdSapiEn.hpp"
#include "AdSapiPh.hpp"
#include "AdTapi.hpp"
#include "cgauges.h"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------

enum TPhraseType { pt_Help, pt_Date, pt_Time, pt_Quit, pt_Unknown };

class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TLabel *Label2;
    TButton *Button1;
    TMemo *Memo1;
    TApdSapiEngine *ApdSapiEngine1;
    TApdSapiPhone *ApdSapiPhone1;
    TApdComPort *ApdComPort1;
    TPhraseType __fastcall AnalyzePhrase (AnsiString Phrase);
    void __fastcall FindPhoneEngines (void);
    void __fastcall SetSSEngine (void);
    void __fastcall SetSREngine (void);
    void __fastcall SaySomething (AnsiString Something);
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall ApdSapiEngine1PhraseFinish(TObject *Sender,
          const AnsiString Phrase);
    void __fastcall ApdSapiPhone1TapiConnect(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
