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
/*                      QryMdm0.h                        */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef QryMdm0H
#define QryMdm0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "Grids.hpp"
#include "AdPort.hpp"
#include "AdPacket.hpp"
#include <vcl\ExtCtrls.hpp>
#include "OoMisc.hpp"

const int InfoCount = 5;
String InfoList[InfoCount];
String InfoTitle[InfoCount];

//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
  TButton *Button1;
  TStringGrid *StringGrid1;
  TApdComPort *ApdComPort1;
  TApdDataPacket *QueryPacket;
  TApdDataPacket *ErrorPacket;
  TTimer *Timer1;
  void __fastcall ErrorPacketPacket(TObject *Sender, Pointer Data, int Size);
  void __fastcall Button1Click(TObject *Sender);
  void __fastcall QueryPacketStringPacket(TObject *Sender, AnsiString Data);
  void __fastcall Timer1Timer(TObject *Sender);
private:	// User declarations
  String Escape(String S);
  int InfoIndex;
  void Next();
  void Stop();
public:		// User declarations
  __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
