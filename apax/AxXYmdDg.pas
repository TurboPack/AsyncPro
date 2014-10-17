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
{*                       AXXYMDDG.PAS 1.13                        *}
{******************************************************************}
{* AxXYmdDg.PAS - X and Y modem protocol properties editor dialog *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxXYmdDg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, AdPort;

type
  TApxXYModemOptions = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtXYModemBlockWait: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    XYModemBlockWait    : Integer;
  end;

var
  ApxXYModemOptions: TApxXYModemOptions;

implementation

{$R *.DFM}

{ ----------------------------------------------------------------------- }
procedure TApxXYModemOptions.FormActivate(Sender: TObject);
begin
  try
    edtXYModemBlockWait.Text  := IntToStr(XYModemBlockWait);
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxXYModemOptions.btnOkClick(Sender: TObject);
begin
  try
    XYModemBlockWait := StrToIntDef(edtXYModemBlockWait.Text, 91);
    ModalResult := mrOk;
  except
    ModalResult := mrCancel;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxXYModemOptions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
