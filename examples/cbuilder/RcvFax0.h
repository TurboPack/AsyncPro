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
/*                      RCVFAX0.H                        */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef RcvFax0H
#define RcvFax0H
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
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TPanel *Panel1;
  TLabel *Label1;
  TLabel *Label2;
  TRadioGroup *rfFaxClass;
  TRadioGroup *rfNameStyle;
  TEdit *rfDirectory;
  TEdit *rfModemInit;
  TPanel *Panel2;
  TLabel *Label3;
  TListBox *rfReceiveList;
  TButton *rfReceiveFaxes;
  TButton *rfExit;
  TButton *rfSelectPort;
  TApdComPort *ApdComPort1;
  TApdFaxStatus *ApdFaxStatus1;
  TApdFaxLog *ApdFaxLog1;
  TApdReceiveFax *ApdReceiveFax1;
  TApdTapiDevice *ApdTapiDevice1;
  void __fastcall ApdReceiveFax1FaxError(TObject *CP, int ErrorCode);
  void __fastcall rfExitClick(TObject *Sender);
  void __fastcall rfDirectoryChange(TObject *Sender);
  void __fastcall rfModemInitChange(TObject *Sender);
  void __fastcall rfFaxClassClick(TObject *Sender);
  void __fastcall rfNameStyleClick(TObject *Sender);
  void __fastcall rfReceiveFaxesClick(TObject *Sender);
  void __fastcall ApdReceiveFax1FaxLog(TObject *CP, TFaxLogCode LogCode);
  void __fastcall ApdReceiveFax1FaxFinish(TObject *CP, int ErrorCode);
  void __fastcall rfSelectPortClick(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiPortOpen(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiPortClose(TObject *Sender);
private:	// User declarations
  bool InProgress;
  String LimitS(String const S, Word Len);
public:		// User declarations
  __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
