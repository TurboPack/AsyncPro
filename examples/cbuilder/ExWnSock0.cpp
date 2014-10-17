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
/*                      EXWS1.CPP                        */
/*********************************************************/
//---------------------------------------------------------------------------
//
// This example program dynamically creates an instance of a TApdSocket
// component and displays Winsock information using the properties
// and methods of TApdSocket.
//
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop
#include "ExWnSock0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  TApdSocket* socket = new TApdSocket(this);
  // Create a socket.
  socket->CreateSocket();
  // Get the Winsock version number and translate it into a readable string.
  Word ver = socket->WsVersion;
  String s = String(LOBYTE(ver)) + "." + String(HIBYTE(ver));
  Version->Caption = s;
  // Do the same for the HighVersion property.
  ver = socket->HighVersion;
  s = String(LOBYTE(ver)) + "." + String(HIBYTE(ver));
  HighVersion->Caption = s;
  // Get a description from the Winsock DLL.
  Description->Caption = socket->Description;
  // Display the system status. Under NT 4.0 system status really
  // does report "Running (duh)".
  Status->Caption = socket->SystemStatus;
  // Display the maximimum number of sockets supported.
  MaxSockets->Caption = socket->MaxSockets;
  // Display the local host and local address.
  LocalHost->Caption = socket->LocalHost;
  LocalAddr->Caption = socket->LocalAddress;
  delete socket;
}
//---------------------------------------------------------------------------
