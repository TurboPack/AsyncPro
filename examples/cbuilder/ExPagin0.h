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
#ifndef ExPagin0H
#define ExPagin0H
//---------------------------------------------------------------------------
#include <vcl\SysUtils.hpp>
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
#include <vcl\IniFiles.hpp>
#include "AdPort.hpp"
#include "OoMisc.hpp"
#include "AdPager.hpp"
#include "AdWnPort.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label1;
  TLabel *Label4;
  TLabel *Label3;
  TLabel *Label6;
  TButton *btnSend;
  TMemo *mmoMsg;
  TPanel *pnlStatus;
  TBevel *bvlStatus1;
  TLabel *Label7;
  TButton *btnExit;
  TButton *btnDisconnect;
  TEdit *edPagerAddr;
  TEdit *edPagerID;
  TMemo *mmoPageStatus;
  TGroupBox *GroupBox1;
  TCheckBox *cbLogging;
  TButton *btnViewLog;
  TButton *btnClearLog;
  TGroupBox *GroupBox2;
  TListBox *lbUsers;
  TButton *btnAdd;
  TButton *btnEdit;
  TButton *btnRemove;
  TApdComPort *ComPort;
  TApdTAPPager *TAPPager;
  TApdWinsockPort *WinsockPort;
  TApdSNPPPager *SNPPPager;
  TApdPagerLog *TAPLog;
  TApdPagerLog *SNPPLog;
  void __fastcall mmoMsgChange(TObject *Sender);
  void __fastcall lbUsersClick(TObject *Sender);
  void __fastcall btnSendClick(TObject *Sender);
  void __fastcall btnDisconnectClick(TObject *Sender);
  void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
  void __fastcall FormCreate(TObject *Sender);
  void __fastcall FormDestroy(TObject *Sender);
  void __fastcall FormShow(TObject *Sender);
  void __fastcall ComPortTriggerAvail(TObject *CP, WORD Count);
  void __fastcall SNPPPagerSNPPEvent(TObject *Sender, int Code, AnsiString Msg);
  void __fastcall btnEditClick(TObject *Sender);
  void __fastcall btnAddClick(TObject *Sender);
  void __fastcall btnRemoveClick(TObject *Sender);
  void __fastcall cbLoggingClick(TObject *Sender);
  void __fastcall btnViewLogClick(TObject *Sender);
  void __fastcall btnClearLogClick(TObject *Sender);
  void __fastcall btnExitClick(TObject *Sender);
        void __fastcall TAPPagerTAPStatus(TObject *Sender,
          TTapStatus Event);
private:	// User declarations
public:		// User declarations
  int PacketCt, AckCt;

  String CurUser, CurPagerID, CurPagerAddress, CurWSPort, PageType, LineBuff, LogName;
  TIniFile *PagerList, *PagerINI;
  Boolean Cancelled;

  __property Boolean Logging = {read=GetLogging, write=SetLogging};

  __fastcall TForm1(TComponent* Owner);
  void __fastcall UpdateMessage();
  String __fastcall GetCurUser();
  void __fastcall GetUserInfo(String User);
  AnsiString  __fastcall GetEntry(String User);
  void __fastcall ClearCurVars();
  void __fastcall GetUsers();
  void __fastcall ClearEds();
  void __fastcall SendByTAP();
  void __fastcall SendBySNPP();
  void __fastcall TAPQuit();
  void __fastcall SNPPQuit();
  void __fastcall SetStatus(String StatusMsg);
  void __fastcall AddEntry(String Name, String Protocol, String Addr, String PagerID);
  void __fastcall ViewLog();
  void __fastcall InitLogFile();
  void __fastcall ClearLog();
  Boolean __fastcall GetLogging();
  void __fastcall SetLogging(Boolean AreLogging);
  void __fastcall SetLogFiles();
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif

#define  PAGER_FILE "PAGERS.LST"
#define  PAGER_INIT "PAGING.INI"

String EntryType[] = {"TAP", "SNPP"};
