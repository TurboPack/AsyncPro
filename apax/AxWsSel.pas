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

{******************************************************************}
{*                        AXWSSEL.PAS 1.13                        *}
{******************************************************************}
{* AxWsSel.PAS - Winsock address, port, mode dialog               *}
{******************************************************************}

unit AxWsSel;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, AdSocket;

type
  TWinsockSelectForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    gbxWinsock: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    edtAddress: TEdit;
    edtPort: TEdit;
  private
    function GetAddress : string;
    procedure SetAddress(const Value : string);
    function GetPort : string;
    procedure SetPort(const Value : string);
  public
    property Address : string read GetAddress write SetAddress;
    property Port : string read GetPort write SetPort;
  end;

var
  WinsockSelectForm: TWinsockSelectForm;

implementation

{$R *.DFM}

{ ----------------------------------------------------------------------- }
function TWinsockSelectForm.GetAddress : string;
begin
  Result := edtAddress.Text;
end;
{ ----------------------------------------------------------------------- }
procedure TWinsockSelectForm.SetAddress(const Value : string);
begin
  edtAddress.Text := Value;
end;
{ ----------------------------------------------------------------------- }
function TWinsockSelectForm.GetPort : string;
begin
  Result := edtPort.Text;
end;
{ ----------------------------------------------------------------------- }
procedure TWinsockSelectForm.SetPort(const Value : string);
begin
  edtPort.Text := Value;
end;

end.
