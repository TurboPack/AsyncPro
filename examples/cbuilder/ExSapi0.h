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
#ifndef ExSapi0H
#define ExSapi0H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "AdSapiEn.hpp"
#include "cgauges.h"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------

typedef
  enum {ptHelp, ptQuiet, ptDate, ptTime, ptQuit,
        ptUnknown} TPhraseType;

class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TLabel *Label2;
    TButton *Button1;
    TMemo *Memo1;
    TApdSapiEngine *ApdSapiEngine1;
    TPhraseType __fastcall AnalyzePhrase (AnsiString Phrase);
    void __fastcall SaySomething (AnsiString Something);
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall ApdSapiEngine1PhraseFinish(TObject *Sender,
          const AnsiString Phrase);
    
    void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
