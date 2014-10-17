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
#ifndef ExSapiD0H
#define ExSapiD0H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "AdSapiEn.hpp"
#include "OoMisc.hpp"
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TBevel *Bevel1;
    TBevel *Bevel2;
    TLabel *Label1;
    TLabel *Label2;
    TLabel *Label3;
    TButton *btnSSAbout;
    TButton *btnSSGeneral;
    TButton *btnSSLexicon;
    TButton *btnSSTranslate;
    TButton *btnSRAbout;
    TButton *btnSRGeneral;
    TButton *btnSRLexicon;
    TButton *btnSRTrainGeneral;
    TButton *btnSRTrainMic;
    TApdSapiEngine *ApdSapiEngine1;
    void __fastcall btnSSAboutClick(TObject *Sender);
    void __fastcall btnSSGeneralClick(TObject *Sender);
    void __fastcall btnSSLexiconClick(TObject *Sender);
    void __fastcall btnSSTranslateClick(TObject *Sender);
    void __fastcall btnSRAboutClick(TObject *Sender);
    void __fastcall btnSRGeneralClick(TObject *Sender);
    void __fastcall btnSRTrainGeneralClick(TObject *Sender);
    void __fastcall btnSRLexiconClick(TObject *Sender);
    void __fastcall btnSRTrainMicClick(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
