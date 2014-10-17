(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   EXWNSOC0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Shows Winsock information.                            *}
{*********************************************************}

unit Exwnsoc0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AdSocket, AdPort, AdWnPort;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblVersion: TLabel;
    lblHighVersion: TLabel;
    lblDescription: TLabel;
    lblStatus: TLabel;
    lblMaxSockets: TLabel;
    lblLocalHost: TLabel;
    lblLocalAddress: TLabel;
    ListBox1: TListBox;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);

begin
  { this information is available from the TApdSocket class }
  With TApdSocket.Create(Self) do try
    { Get the Winsock version number and translate it into a readable string }
    lblVersion.Caption := IntToStr(LOBYTE(WsVersion)) + '.' + IntToStr(HIBYTE(WsVersion));

    { Do the same for the HighVersion property }
    lblHighVersion.Caption := IntToStr(LOBYTE(HighVersion)) + '.' + IntToStr(HIBYTE(HighVersion));

    { Get a description from the Winsock DLL }
    lblDescription.Caption := Description;

    { Display the system status }
    lblStatus.Caption := SystemStatus;

    { Display the maximum number of suckets supported }
    lblMaxSockets.Caption := IntToStr(MaxSockets);

    { Display the local host and local address }
    lblLocalHost.Caption := LocalHost;
    lblLocalAddress.Caption := LocalAddress;

  finally
    Free;
  end;

  { local network addresses are accessible from the TApdWinsockPort }
  with TApdWinsockPort.Create(Self) do try
     ListBox1.Items.AddStrings(WsLocalAddresses);
  finally
    Free;
  end;
end;

end.
