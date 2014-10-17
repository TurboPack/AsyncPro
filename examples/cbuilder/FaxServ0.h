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
/*                      FaxServ0.h                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef FaxServ0H
#define FaxServ0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include "AdFax.hpp"
#include "AdFStat.hpp"
#include "OoMisc.hpp"

#define Am_NotifyFaxAvailable  WM_USER + 0x301
#define Am_NotifyFaxSent       WM_USER + 0x302
#define Am_QueryPending        WM_USER + 0x303

//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label1;
  TLabel *lblState;
  TLabel *Label2;
  TEdit *edtPhoneNo;
  TButton *btnSend;
  TApdComPort *ApdComPort1;
  TApdSendFax *ApdSendFax1;
  TApdFaxStatus *ApdFaxStatus1;
  void __fastcall btnSendClick(TObject *Sender);
  void __fastcall ApdSendFax1FaxFinish(TObject *CP, int ErrorCode);
  
private:	// User declarations
  HWND ClientWnd;
  Word JobAtom;
  void __fastcall AmNotifyFaxAvailable(TMessage& Message);
public:		// User declarations
  __fastcall TForm1(TComponent* Owner);
  BEGIN_MESSAGE_MAP
    MESSAGE_HANDLER(Am_NotifyFaxAvailable, TMessage, AmNotifyFaxAvailable)
  END_MESSAGE_MAP(TForm)
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
