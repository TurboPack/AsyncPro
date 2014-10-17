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
{*                    EXTAP0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates the use of how to send a TAP Page via    *}
{*       the ApdTAPPager component.                      *}
{*********************************************************}

unit ExTap0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OoMisc, AdPort, AdPager;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    ApdTAPPager1: TApdTAPPager;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    Label3: TLabel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure ApdTAPPager1TAPFinish(Sender: TObject);
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
  ApdTAPPager1.CancelCall;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Caption := 'Please Wait';
  Button1.Enabled := FALSE;
  ApdTAPPager1.PhoneNumber := Edit1.Text;
  ApdTAPPager1.PagerID     := Edit2.Text;
  ApdTAPPager1.Message     := Memo1.Lines;
  ApdTAPPager1.Send;
end;

procedure TForm1.ApdTAPPager1TAPFinish(Sender: TObject);
begin
  Button1.Caption := 'Send';
  Button1.Enabled := TRUE;
end;

end.
