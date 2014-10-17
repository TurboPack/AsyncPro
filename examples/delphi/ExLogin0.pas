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
{*                   EXLOGIN0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{*     Shows a login process using data triggers.        *}
{*********************************************************}

unit Exlogin0;

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, OoMisc, ADTrmEmu;

type
  TLoginState = (lName, lPassword, lOther);

  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Button1: TButton;
    Label1: TLabel;
    edtPhoneNumber: TEdit;
    AdTerminal1: TAdTerminal;
    procedure Button1Click(Sender: TObject);
    procedure ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
  private
    { Private declarations }
    DataTrig : Word;
    LoginState : TLoginState;

  public
    { Public declarations }
  end;


var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  {Start the login process, dial...}
  ApdComPort1.Output := 'atm0dt' + edtPhoneNumber.Text + #13;
  LoginState := lName;

  {Setup next data trigger}
  DataTrig := ApdComPort1.AddDataTrigger('name?', true);
end;

procedure TForm1.ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
begin
  {Got latest data trigger, send next}
  ApdComPort1.RemoveTrigger(DataTrig);
  case LoginState of
    lName :
      begin
        ApdComPort1.Output := 'joe blow'^M;
        DataTrig := ApdComPort1.AddDataTrigger('password?', true);
        LoginState := lPassword;
      end;

    lPassword :
      begin
        ApdComPort1.Output := '123'^M;
        DataTrig := ApdComPort1.AddDataTrigger('?', true);
        LoginState := lOther;
      end;

    lOther :
      ShowMessage('done');
  end;
end;

end.
