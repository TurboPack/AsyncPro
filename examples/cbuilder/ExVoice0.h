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
/*                      ExVoice0.h                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ExVoice0H
#define ExVoice0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
#include <vcl\Buttons.hpp>
#include "AdPort.hpp"
#include "AdTapi.hpp"
#include "OoMisc.hpp"

const int StateGreeting   = 0;
const int StateMenu       = 1;
const int StatePlayingWav = 2;
const int StateEndCall    = 3;

//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label1;
  TLabel *Label2;
  TEdit *CallerID;
  TEdit *CallerIDName;
  TButton *Button1;
  TPanel *Panel1;
  TLabel *Label3;
  TSpeedButton *Pad1;
  TSpeedButton *Pad2;
  TSpeedButton *Pad3;
  TSpeedButton *Pad4;
  TSpeedButton *Pad5;
  TSpeedButton *Pad6;
  TSpeedButton *PadAsterisk;
  TSpeedButton *Pad0;
  TSpeedButton *PadPound;
  TSpeedButton *Pad7;
  TSpeedButton *Pad8;
  TSpeedButton *Pad9;
  TButton *AnswerButton;
  TButton *CancelCall;
  TGroupBox *GroupBox1;
  TLabel *Label4;
  TApdComPort *ApdComPort1;
  TApdTapiDevice *ApdTapiDevice1;
  TTimer *Timer1;
  void __fastcall FormCreate(TObject *Sender);
  void __fastcall Button1Click(TObject *Sender);
  void __fastcall AnswerButtonClick(TObject *Sender);
  void __fastcall CancelCallClick(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiConnect(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiCallerID(TObject *CP, AnsiString ID,
  AnsiString IDName);
  void __fastcall Timer1Timer(TObject *Sender);
  void __fastcall ApdTapiDevice1TapiDTMF(TObject *CP, char Digit, int ErrorCode);
  
  
  void __fastcall ApdTapiDevice1TapiWaveNotify(TObject *CP, TWaveMessage Msg);
private:	// User declarations
  int CurrentState;
  char LastDigit;
  String WaveFileDir;
public:		// User declarations
  __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
