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
/*                      FAXSRVX0.H                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef FaxSrvx0H
#define FaxSrvx0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
#include "AdPort.hpp"
#include "AdFStat.hpp"
#include "AdFax.hpp"
#include "AdTapi.hpp"
#include "AdFaxCtl.hpp"
#include "AdFaxCtl.hpp"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
struct TAddEntry {
  String FaxName;
  String CoverName;
  String PhoneNumber;
  TAddEntry*  NextEntry;
};

class TfsMain : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label7;
  TButton *SendFax;
  TButton *fsAdd;
  TButton *fsExit;
  TPanel *Panel1;
  TLabel *Label1;
  TLabel *Label2;
  TLabel *Label3;
  TLabel *Label4;
  TLabel *Label5;
  TLabel *Label6;
  TRadioGroup *fsFaxClass;
  TEdit *fsModemInit;
  TEdit *fsHeader;
  TEdit *fsStationID;
  TEdit *fsDialPrefix;
  TEdit *fsDialAttempts;
  TEdit *fsRetryWait;
  TButton *fsModify;
  TButton *fsDelete;
  TListBox *fsFaxListBox;
  TButton *fsSelectComPort;
  TApdComPort *ApdComPort1;
  TApdFaxStatus *ApdFaxStatus1;
  TApdSendFax *ApdSendFax1;
  TApdFaxLog *ApdFaxLog1;
  TApdTapiDevice *ApdTapiDevice1;
  TApdFaxDriverInterface *ApdFaxDriverInterface1;
  void __fastcall SendFaxClick(TObject *Sender);
  void __fastcall fsAddClick(TObject *Sender);
  void __fastcall ApdSendFax1FaxNext(TObject *CP, TPassString &APhoneNumber,
  TPassString &AFaxFile, TPassString &ACoverFile);
  void __fastcall fsExitClick(TObject *Sender);
  void __fastcall fsModifyClick(TObject *Sender);
  void __fastcall fsDeleteClick(TObject *Sender);
  void __fastcall ApdSendFax1FaxLog(TObject *CP, TFaxLogCode LogCode);
  void __fastcall fsFaxClassClick(TObject *Sender);
  void __fastcall fsDialAttemptsChange(TObject *Sender);
  void __fastcall fsRetryWaitChange(TObject *Sender);
  void __fastcall fsStationIDChange(TObject *Sender);
  void __fastcall fsDialPrefixChange(TObject *Sender);
  void __fastcall fsModemInitChange(TObject *Sender);
  void __fastcall fsHeaderChange(TObject *Sender);
  void __fastcall fsSelectComPortClick(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiPortOpen(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiPortClose(TObject *Sender);
  void __fastcall ApdSendFax1FaxFinish(TObject *CP, int ErrorCode);
  void __fastcall ApdFaxDriverInterface1DocEnd(TObject *Sender);
  void __fastcall ApdFaxDriverInterface1DocStart(TObject *Sender);
  
    void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
  TStringList* FaxList;
  Word FaxIndex;
  bool InProgress;
  bool AddsInProgress;
  Word AddsPending;
  TAddEntry* AddList;

  String LimitS(String const S, Word Len);
  void fsAppendAddList(String FName, String CName, String PNumber);
  void fsGetAddListEntry(String& FName, String& CName, String PNumber);
  void fsAddPrim();
  void __fastcall AddPrim(TMessage& Message);

  __fastcall TfsMain(TComponent* Owner);
  __fastcall ~TfsMain();
  BEGIN_MESSAGE_MAP
 		MESSAGE_HANDLER(apw_AddPrim, TMessage, AddPrim);
 	END_MESSAGE_MAP(TForm)
};
//---------------------------------------------------------------------------
extern TfsMain *fsMain;
//---------------------------------------------------------------------------
#endif
