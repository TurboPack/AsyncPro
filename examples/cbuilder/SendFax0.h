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
/*                      SendFax0.h                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef SendFax0H
#define SendFax0H
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
#include <vcl\Dialogs.hpp>
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
struct TAddEntry {
  String FaxName;
  String CoverName;
  String PhoneNumber;
  TAddEntry*  NextEntry;
};

class TsfMain : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label7;
  TButton *SendFax;
  TButton *sfAdd;
  TButton *sfExit;
  TPanel *Panel1;
  TLabel *Label1;
  TLabel *Label2;
  TLabel *Label3;
  TLabel *Label4;
  TLabel *Label5;
  TLabel *Label6;
  TRadioGroup *sfFaxClass;
  TEdit *sfModemInit;
  TEdit *sfHeader;
  TEdit *sfStationID;
  TEdit *sfDialPrefix;
  TEdit *sfDialAttempts;
  TEdit *sfRetryWait;
  TButton *sfModify;
  TButton *sfDelete;
  TListBox *sfFaxListBox;
  TButton *sfSelectComPort;
  TApdComPort *ApdComPort1;
  TApdFaxStatus *ApdFaxStatus1;
  TApdSendFax *ApdSendFax1;
  TApdFaxLog *ApdFaxLog1;
  TApdTapiDevice *ApdTapiDevice1;
  TCheckBox *EnhText;
  TButton *HdrFontBtn;
  TButton *CvrFontBtn;
  TFontDialog *FontDialog1;
  void __fastcall FormShow(TObject *Sender);
  void __fastcall SendFaxClick(TObject *Sender);
  void __fastcall sfAddClick(TObject *Sender);
  void __fastcall sfExitClick(TObject *Sender);
  void __fastcall sfModifyClick(TObject *Sender);
  void __fastcall sfDeleteClick(TObject *Sender);
  void __fastcall ApdSendFax1FaxLog(TObject *CP, TFaxLogCode LogCode);
  void __fastcall sfFaxClassClick(TObject *Sender);
  void __fastcall sfDialAttemptsChange(TObject *Sender);
  void __fastcall sfRetryWaitChange(TObject *Sender);
  void __fastcall sfStationIDChange(TObject *Sender);
  void __fastcall sfDialPrefixChange(TObject *Sender);
  void __fastcall sfModemInitChange(TObject *Sender);
  void __fastcall sfHeaderChange(TObject *Sender);
  void __fastcall sfSelectComPortClick(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiPortOpen(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiPortClose(TObject *Sender);
  void __fastcall ApdSendFax1FaxFinish(TObject *CP, int ErrorCode);
  
  void __fastcall HdrFontBtnClick(TObject *Sender);
  void __fastcall CvrFontBtnClick(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
        
    void __fastcall ApdSendFax1FaxNext(TObject *CP,
          TPassString &APhoneNumber, TPassString &AFaxFile,
          TPassString &ACoverFile);
private:	// User declarations
  TStringList* FaxList;
  Word FaxIndex;
  bool InProgress;
  bool AddsInProgress;
  Word AddsPending;
  TAddEntry* AddList;
  bool ProcessedCmdLine;

  String LimitS(String const S, Word Len);
  void sfAppendAddList(String FName, String CName, String PNumber);
  void sfGetAddListEntry(String& FName, String& CName, String PNumber);
  void sfAddPrim();
  void __fastcall sfAddFromPrinterDriver(TMessage& Message);
  void sfAddFromCmdLine();
public:		// User declarations
  __fastcall TsfMain(TComponent* Owner);
  __fastcall ~TsfMain();
  BEGIN_MESSAGE_MAP
 		MESSAGE_HANDLER(apw_PrintDriverJobCreated, TMessage, sfAddFromPrinterDriver);
 	END_MESSAGE_MAP(TForm)
};
//---------------------------------------------------------------------------
extern TsfMain *sfMain;
//---------------------------------------------------------------------------
#endif
