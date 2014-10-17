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
/*                      FaxMon0.h                        */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef FaxMon0H
#define FaxMon0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdFaxCtl.hpp"
#include <vcl\Dialogs.hpp>
#include <vcl\Menus.hpp>
#include <vcl\ExtCtrls.hpp>
#include <vcl\ShellAPI.hpp>
#include "OoMisc.hpp"

#define Am_TiCallBack          WM_USER + 0x300
#define Am_NotifyFaxAvailable  WM_USER + 0x301
#define Am_NotifyFaxSent       WM_USER + 0x302
#define Am_QueryPending        WM_USER + 0x303

enum TState { Printing, Generated, Queued, Sent };
String StateString[4];

//---------------------------------------------------------------------------
class TPrintJob : public TObject {
  private:
    String FDocName;
    String FFileName;
    TState FState;
    String __fastcall GetJobString();
  public:
    __fastcall TPrintJob() : TObject() {};
    Word JobAtom;
    __property String DocName = {read = FDocName, write = FDocName};
    __property String FileName = {read = FFileName, write = FFileName};
    __property TState State = {read = FState, write = FState};
    __property String JobString = {read = GetJobString};
};

class TfFaxMon0 : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label1;
  TLabel *Label2;
  TEdit *edtServerPath;
  TButton *btnSelect;
  TListBox *ListBox1;
  TApdFaxDriverInterface *Driver;
  TOpenDialog *OpenDialog1;
  TPopupMenu *PopupMenu1;
  TMenuItem *mnClose;
  TTimer *Timer1;
  void __fastcall FormCreate(TObject *Sender);
  void __fastcall DriverDocStart(TObject *Sender);
  void __fastcall DriverDocEnd(TObject *Sender);
  void __fastcall btnSelectClick(TObject *Sender);
  void __fastcall FormActivate(TObject *Sender);
  void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
  void __fastcall mnCloseClick(TObject *Sender);
  void __fastcall Timer1Timer(TObject *Sender);
private:	// User declarations
  HWND AppHandle;
  int FileCount;
  bool tiActive;
  TNotifyIconData tiNotifyData;
  bool tiPresent;
  void tiAdd();
  void __fastcall tiCallBack(TMessage& Message);
  void tiDelete();
  HICON tiGetIconHandle();
  void tiInitNotifyData();
  void __fastcall MainFormMinimize(TObject* Sender);
  void __fastcall MainFormRestore(TObject* Sender);
public:		// User declarations
  __fastcall TfFaxMon0(TComponent* Owner);
  void __fastcall AmNotifyFaxSent(TMessage& Msg);
  void __fastcall AmQueryPending(TMessage& Msg);

  BEGIN_MESSAGE_MAP
    MESSAGE_HANDLER(Am_TiCallBack, TMessage, tiCallBack)
    MESSAGE_HANDLER(Am_NotifyFaxSent, TMessage, AmNotifyFaxSent)
    MESSAGE_HANDLER(Am_QueryPending, TMessage, AmQueryPending)
  END_MESSAGE_MAP(TForm)
};
//---------------------------------------------------------------------------
extern TfFaxMon0 *fFaxMon0;
//---------------------------------------------------------------------------
#endif
