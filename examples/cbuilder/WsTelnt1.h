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
/*                      WSTELNT1.H                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef WsTelnt1H
#define WsTelnt1H
//---------------------------------------------------------------------------
//
// For the time being you must #define _WINSOCKAPI_ and move ComCtrls.hpp
// to the top of the #include list if you are using any of the Win32
// controls.
//
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdWnPort.hpp"
#include "AdPort.hpp"
#include <vcl\ComCtrls.hpp>
#include <vcl\ExtCtrls.hpp>
#include "OoMisc.hpp"
#include "ADTrmEmu.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TBevel *Bevel1;
  TPanel *Panel1;
  TLabel *Label1;
  TButton *Button1;
  TButton *Button2;
  TEdit *HostNameEdit;
  TApdWinsockPort *WsPort;
  TStatusBar *StatusBar;
    TAdTerminal *AdTerminal;
    TAdVT100Emulator *AdVT100Emulator1;
  void __fastcall Button1Click(TObject *Sender);
  
  void __fastcall WsPortWsConnect(TObject *Sender);
  void __fastcall WsPortWsDisconnect(TObject *Sender);
  void __fastcall Button2Click(TObject *Sender);
  void __fastcall WsPortTriggerData(TObject *CP, WORD TriggerHandle);
  void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
  Word NameTrigger;
  Word PasswordTrigger;
public:		// User declarations
  __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
