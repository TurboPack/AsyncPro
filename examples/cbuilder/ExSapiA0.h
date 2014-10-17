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
#ifndef ExSapiA0H
#define ExSapiA0H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "AdSapiEn.hpp"
#include "AdSapiPh.hpp"
#include "AdTapi.hpp"
#include "OoMisc.hpp"
#include <ExtCtrls.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------

enum TListRequest { lrColor, lrPlanet };

class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TLabel *Label1;
    TLabel *lblDate;
    TLabel *lblExtension;
    TLabel *lblPlanet;
    TLabel *lblColor;
    TLabel *lblPhoneNumber;
    TLabel *lblSpelling;
    TLabel *lblTime;
    TLabel *lblYesNo;
    TLabel *Label2;
    TLabel *Label3;
    TLabel *Label4;
    TLabel *Label5;
    TLabel *Label6;
    TLabel *Label7;
    TLabel *Label8;
    TLabel *Label9;
    TLabel *Label10;
    TShape *Shape1;
    TButton *btnDate;
    TButton *btnExtension;
    TButton *btnPlanet;
    TButton *btnColor;
    TButton *btnPhoneNumber;
    TButton *btnSpelling;
    TButton *btnTime;
    TButton *btnYesNo;
    TMemo *Memo1;
    TApdSapiEngine *ApdSapiEngine1;
    TApdSapiPhone *ApdSapiPhone1;
        TProgressBar *ProgressBar1;
        TButton *Button1;
        TButton *Button2;
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall FormDestroy(TObject *Sender);
    void __fastcall ApdSapiEngine1Interference(TObject *Sender,
          TApdSRInterferenceType InterferenceType);
    void __fastcall ApdSapiEngine1PhraseFinish(TObject *Sender,
          const AnsiString Phrase);
    void __fastcall ApdSapiPhone1AskForDateFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, TDateTime Data, AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForExtensionFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, AnsiString Data,
          AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForListFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, int Data, AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForPhoneNumberFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, AnsiString Data,
          AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForSpellingFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, AnsiString Data,
          AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForTimeFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, TDateTime Data, AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForYesNoFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, bool Data, AnsiString SpokenData);
    void __fastcall btnDateClick(TObject *Sender);
    void __fastcall btnExtensionClick(TObject *Sender);
    void __fastcall btnPlanetClick(TObject *Sender);
    void __fastcall btnColorClick(TObject *Sender);
    void __fastcall btnPhoneNumberClick(TObject *Sender);
    void __fastcall btnSpellingClick(TObject *Sender);
    void __fastcall btnTimeClick(TObject *Sender);
    void __fastcall btnYesNoClick(TObject *Sender);
        void __fastcall ApdSapiEngine1SRError(TObject *Sender, DWORD Error,
          const AnsiString Details, const AnsiString Message);
        void __fastcall ApdSapiEngine1SRWarning(TObject *Sender,
          DWORD Error, const AnsiString Details, const AnsiString Message);
        void __fastcall ApdSapiEngine1SSWarning(TObject *Sender,
          DWORD Error, const AnsiString Details, const AnsiString Message);
        void __fastcall ApdSapiEngine1SSError(TObject *Sender, DWORD Error,
          const AnsiString Details, const AnsiString Message);
        void __fastcall ApdSapiEngine1VUMeter(TObject *Sender, int Level);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall Button2Click(TObject *Sender);
private:	// User declarations
    TStringList *ColorList;
    TStringList *PlanetList;
    TListRequest ListRequest; 
public:		// User declarations
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
