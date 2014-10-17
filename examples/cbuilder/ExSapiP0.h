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
#ifndef ExSapiP0H
#define ExSapiP0H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "AdPort.hpp"
#include "AdSapiEn.hpp"
#include "AdSapiPh.hpp"
#include "AdTapi.hpp"
#include "OoMisc.hpp"
#include <Grids.hpp>
//---------------------------------------------------------------------------
enum TConversationState { csPhone, csPhoneVerify, csDate, csTime,
                          csDateTimeVerify };
                        
class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TButton *btnAnswer;
    TStringGrid *StringGrid1;
    TApdSapiEngine *ApdSapiEngine1;
    TApdSapiPhone *ApdSapiPhone1;
    TApdComPort *ApdComPort1;
    TLabel *Label1;
    TLabel *Label2;
    TLabel *Log;
    TMemo *Memo1;
    void __fastcall Hangup (void);
    void __fastcall SetSSEngine (void);
    void __fastcall SetSREngine (void);
    void __fastcall FindPhoneEngines (void);
    void __fastcall Conversation (void);
    AnsiString __fastcall SplitPhoneNumber (AnsiString PhoneNum);
    void __fastcall btnAnswerClick(TObject *Sender);
    void __fastcall ApdSapiPhone1AskForDateFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, TDateTime Data, AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForPhoneNumberFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, AnsiString Data,
          AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForTimeFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, TDateTime Data, AnsiString SpokenData);
    void __fastcall ApdSapiPhone1AskForYesNoFinish(TObject *Sender,
          TApdSapiPhoneReply Reply, bool Data, AnsiString SpokenData);
    void __fastcall ApdSapiPhone1TapiConnect(TObject *Sender);
    void __fastcall ApdSapiPhone1TapiDisconnect(TObject *Sender);
    void __fastcall ApdSapiEngine1Interference(TObject *Sender,
          TApdSRInterferenceType InterferenceType);
    void __fastcall ApdSapiEngine1PhraseFinish(TObject *Sender,
          const AnsiString Phrase);
    void __fastcall ApdSapiEngine1SRWarning(TObject *Sender, DWORD Error,
          const AnsiString Details, const AnsiString Message);
    void __fastcall ApdSapiEngine1SSError(TObject *Sender, DWORD Error,
          const AnsiString Details, const AnsiString Message);
    void __fastcall ApdSapiEngine1SSWarning(TObject *Sender, DWORD Error,
          const AnsiString Details, const AnsiString Message);
        void __fastcall ApdSapiEngine1SRError(TObject *Sender, DWORD Error,
          const AnsiString Details, const AnsiString Message);
    void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
    TConversationState ConvState;
    AnsiString PhoneNumber;
    TDateTime TheDate;
    TDateTime TheTime;
public:		// User declarations
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
