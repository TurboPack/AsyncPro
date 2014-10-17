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
{*                   EXSNPP0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates the use a Simple Network Paging Protocol *}
{*      (SNPP) for transmitting alphanumeric page        *}
{*      requests over TCP/IP networks (e.g. Internet).   *}
{*********************************************************}

{ note: A paging service must provide an SNPP server as a
        facility before a pager may be contacted via SNPP.}

unit ExSNPP0;

interface

uses
{$ifndef WIN32 }
  WinTypes, WinProcs,
{$else }
  Windows,
{$endif }
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OoMisc, AdPort, AdWnPort, AdPager;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    Label3: TLabel;
    ApdWinsockPort1: TApdWinsockPort;
    Button1: TButton;
    ApdSNPPPager1: TApdSNPPPager;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure ApdSNPPPager1Logout(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ApdSNPPPager1.Quit;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  WsAddr, WsPortID: string;
  P: Integer;
begin
  Button1.Caption := 'Please Wait';
  Button1.Enabled := FALSE;

  { extract WinSock address and port# }
  P := Pos(':', Edit1.Text);
  WsAddr   := Copy(Edit1.Text, 1, P - 1);
  WsPortID := Copy(Edit1.Text, P + 1, Length(Edit1.Text) - P);
  ApdWinsockPort1.WsAddress := WsAddr;
  ApdWinsockPort1.WsPort    := WsPortID;

  ApdSNPPPager1.PagerID      := Edit2.Text;
  ApdSNPPPager1.Message      := Memo1.Lines;
  ApdSNPPPager1.Send;
end;

procedure TForm1.ApdSNPPPager1Logout(Sender: TObject);
begin
  Button1.Caption := 'Send';
  Button1.Enabled := TRUE;
end;

end.
  
