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
/*                      ExRecrd0.h                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ExRecrd0H
#define ExRecrd0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include "AdTapi.hpp"
#include <vcl\Menus.hpp>
#include "AdProtcl.hpp"
#include "OoMisc.hpp"

const int StateGreeting          = 0;
const int StateRecording         = 1;
const int StateIdle              = 2;
const int StateBeeping           = 3;
const int StatePlayback          = 4;

//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label1;
  TLabel *Label2;
  TLabel *Label5;
  TLabel *Label3;
  TEdit *CallerID;
  TEdit *CallerIDName;
  TButton *Button1;
  TButton *AnswerButton;
  TButton *CancelCall;
  TGroupBox *GroupBox1;
  TLabel *Label4;
  TEdit *MaxLengthEdit;
  TListBox *CallsListBox;
  TApdComPort *ApdComPort1;
  TApdTapiDevice *ApdTapiDevice1;
  TPopupMenu *PopupMenu1;
  TMenuItem *Play1;
  TMenuItem *Delete1;
  TCheckBox *Monitor;
  void __fastcall FormCreate(TObject *Sender);
  void __fastcall Button1Click(TObject *Sender);
  void __fastcall AnswerButtonClick(TObject *Sender);
  void __fastcall CancelCallClick(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiConnect(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiWaveNotify(TObject *CP, TWaveMessage Msg);
  void __fastcall CallsListBoxDblClick(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiCallerID(TObject *CP, AnsiString ID,
  AnsiString IDName);
  void __fastcall MaxLengthEditExit(TObject *Sender);
  void __fastcall CallsListBoxKeyDown(TObject *Sender, WORD &Key,
  TShiftState Shift);
  void __fastcall Delete1Click(TObject *Sender);
  
  void __fastcall PopupMenu1Popup(TObject *Sender);
  void __fastcall MonitorClick(TObject *Sender);
private:	// User declarations
  int CurrentState;
  int CallCount;
  void PlayBackMessage();
public:		// User declarations
  __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
