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
/*                      ExWPack0.h                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ExWPack0H
#define ExWPack0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdProtcl.hpp"
#include "AdPStat.hpp"
#include "AdWnPort.hpp"
#include "AdPort.hpp"
#include "AdPacket.hpp"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label1;
  TLabel *Label2;
  TLabel *Label3;
  TButton *Button1;
  TEdit *Edit1;
  TEdit *edtName;
  TEdit *edtPassword;
  TEdit *edtFileName;
  TMemo *Memo1;
  TApdProtocol *ApdProtocol1;
  TApdProtocolStatus *ApdProtocolStatus1;
  TApdWinsockPort *ApdWinsockPort1;
  TApdDataPacket *WaitName;
  TApdDataPacket *WaitPassword;
  TApdDataPacket *WaitContinue;
  TApdDataPacket *WaitCommand;
  TApdDataPacket *WaitFileName;
  TApdDataPacket *WaitContinue2;
  TApdDataPacket *WaitZStart;
  TLabel *Label4;
  void __fastcall Button1Click(TObject *Sender);
  void __fastcall ApdWinsockPort1WsConnect(TObject *Sender);
  void __fastcall ApdWinsockPort1WsDisconnect(TObject *Sender);
  
  
  void __fastcall WaitNameTimeout(TObject *Sender);
  
  
  
  
  
  void __fastcall WaitNamePacket(TObject *Sender, Pointer Data, int Size);
  void __fastcall WaitPasswordPacket(TObject *Sender, Pointer Data, int Size);
  void __fastcall WaitZStartPacket(TObject *Sender, Pointer Data, int Size);
  void __fastcall WaitContinuePacket(TObject *Sender, Pointer Data, int Size);
  void __fastcall WaitCommandPacket(TObject *Sender, Pointer Data, int Size);
  void __fastcall WaitFileNamePacket(TObject *Sender, Pointer Data, int Size);
  void __fastcall WaitContinue2Packet(TObject *Sender, Pointer Data, int Size);
private:	// User declarations
  int CommandState;
public:		// User declarations
  __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
