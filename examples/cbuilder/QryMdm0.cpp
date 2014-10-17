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
/*                      QryMdm0.cpp                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "QryMdm0.h"
//---------------------------------------------------------------------------
#pragma link "Grids"
#pragma link "AdPort"
#pragma link "AdPacket"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
  InfoList[0] = "I0";
  InfoList[1] = "I1";
  InfoList[2] = "I3";
  InfoList[3] = "+FMFR?";
  InfoList[4] = "+FCLASS=?";
  InfoTitle[0] = "Product code";
  InfoTitle[1] = "Firmware version #";
  InfoTitle[2] = "Device set name";
  InfoTitle[3] = "Manufacturer";
  InfoTitle[4] = "Fax classes";
}
//---------------------------------------------------------------------------

String TForm1::Escape(String S)
{
  String Res = S;
  for (int i=S.Length();i>0;i--)
    switch (S[i]) {
      case '?' :
      case '\\' :
       Res.Insert('\\', i);
    }
  return Res;
}

void TForm1::Next()
{
  String Command;
  if (InfoIndex >= InfoCount)
    Stop();
  else {
    InfoIndex++;
    Command = "AT" + InfoList[InfoIndex - 1] + "\r\n";
    QueryPacket->StartString = "AT" + InfoList[InfoIndex - 1];//Escape(Command);
    QueryPacket->Enabled = true;
    Application->ProcessMessages();
    ApdComPort1->PutString(Command);
  }
}

void TForm1::Stop()
{
  Timer1->Enabled = false;
  StringGrid1->Cells[0][0] = "Information";
  StringGrid1->Cells[1][0] = "Response";
  if (StringGrid1->RowCount > 2)
    StringGrid1->FixedRows = 1;
  Caption = "Done";
  QueryPacket->Enabled = false;
  ApdComPort1->Open = false;
  Button1->Enabled = true;
  Screen->Cursor = crDefault;
}

void __fastcall TForm1::ErrorPacketPacket(TObject *Sender, Pointer Data,
  int Size)
{
  Next();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  InfoIndex = 0;
  StringGrid1->RowCount = 1;
  Screen->Cursor = crHourGlass;
  QueryPacket->Enabled = false;
  ApdComPort1->Open = true;
  Timer1->Enabled = true;
  Caption = "Talking to the modem";
  Application->ProcessMessages();
  Button1->Enabled = false;
  Next();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::QueryPacketStringPacket(TObject *Sender,
  AnsiString Data)
{
  String S = Data;
  for (int i=Data.Length();i>0;i--)
    if (S[i] < ' ')
      S.Delete(i, 1);
  if (S != "")  {
    StringGrid1->RowCount = StringGrid1->RowCount + 1;
    StringGrid1->Cells[0][StringGrid1->RowCount-1] = InfoTitle[InfoIndex - 1];
    StringGrid1->Cells[1][StringGrid1->RowCount-1] = S;
  }
  Next();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
  Stop();
  ShowMessage("Modem did not respond");
}
//---------------------------------------------------------------------------
