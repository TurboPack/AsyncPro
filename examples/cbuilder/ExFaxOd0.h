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
/*                      ExFaxOd0.h                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ExFaxOd0H
#define ExFaxOd0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdTapi.hpp"
#include "AdFax.hpp"
#include "AdFStat.hpp"
#include "AdPort.hpp"
#include <vcl\ExtCtrls.hpp>
#include "OoMisc.hpp"

const int StateIdle             = 0;
const int StateGreeting         = 1;
const int StateEndCall          = 2;
const int StateGettingNumber    = 3;
const int StatePlayBack         = 4;
const int StateWaitReply        = 5;

//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TButton *Button1;
  TButton *AnswerButton;
  TGroupBox *GroupBox1;
  TLabel *Label1;
  TLabel *Label2;
  TLabel *Label3;
  TEdit *Edit1;
  TEdit *Edit2;
  TEdit *Edit3;
  TApdTapiDevice *ApdTapiDevice1;
  TApdSendFax *ApdSendFax1;
  TApdFaxStatus *ApdFaxStatus1;
  TApdComPort *ApdComPort1;
  TTimer *Timer1;
  void __fastcall Button1Click(TObject *Sender);
  void __fastcall AnswerButtonClick(TObject *Sender);
  void __fastcall FormCreate(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiDTMF(TObject *CP, char Digit, int ErrorCode);
  void __fastcall ApdTapiDevice1TapiConnect(TObject *Sender);
  
  void __fastcall Timer1Timer(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiPortOpen(TObject *Sender);
  
  void __fastcall ApdTapiDevice1TapiWaveNotify(TObject *CP, TWaveMessage Msg);
  void __fastcall ApdSendFax1FaxFinish(TObject *CP, int ErrorCode);
private:	// User declarations
  int CurrentState;
  String WaveFileDir;
  bool SendTheFax;
public:		// User declarations
  __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
