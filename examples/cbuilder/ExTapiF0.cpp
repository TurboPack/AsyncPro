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
/*                      EXTAPIF0.CPP                     */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "ExTapiF0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdFax"
#pragma link "AdFStat"
#pragma link "AdTapi"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TExTFax *ExTFax;
//---------------------------------------------------------------------------
__fastcall TExTFax::TExTFax(TComponent* Owner)
	: TForm(Owner)
{
	Sending = false;
}
//---------------------------------------------------------------------------
void __fastcall TExTFax::SendFaxClick(TObject *Sender)
{
  Sending = true;
  ApdTapiDevice1->ConfigAndOpen();
}
//---------------------------------------------------------------------------
void __fastcall TExTFax::RcvFaxClick(TObject *Sender)
{
  Sending = false;
  ApdTapiDevice1->ConfigAndOpen();
}
//---------------------------------------------------------------------------
void __fastcall TExTFax::ApdReceiveFax1FaxFinish(TObject *CP, int ErrorCode)
{
  ApdTapiDevice1->CancelCall();
  ShowMessage("Receive complete: " + ErrorMsg(ErrorCode));  
}
//---------------------------------------------------------------------------
void __fastcall TExTFax::ApdSendFax1FaxFinish(TObject *CP, int ErrorCode)
{
  ApdTapiDevice1->CancelCall();
  ShowMessage("Transmit complete: " + ErrorMsg(ErrorCode));
}
//---------------------------------------------------------------------------
void __fastcall TExTFax::ApdTapiDevice1TapiPortOpen(TObject *Sender)
{
  if (Sending) {
    ApdSendFax1->StatusDisplay = ApdFaxStatus1;
    ApdFaxStatus1->Fax = ApdSendFax1;
    ApdSendFax1->StartTransmit();
  } else {
    ApdReceiveFax1->StatusDisplay = ApdFaxStatus1;
    ApdFaxStatus1->Fax = ApdReceiveFax1;
    ApdReceiveFax1->StartReceive();

  }
}
//---------------------------------------------------------------------------
