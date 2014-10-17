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
{*                       AXZMDMDG.PAS 1.13                        *}
{******************************************************************}
{*                                                                *}
{******************************************************************}

unit AxZmdmDg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, AdPort, AdProtCl;

type
  TApxZModemOptions = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    chkZModem8K: TCheckBox;
    cbxZModemFileOptions: TComboBox;
    edtZModemFinishRetry: TEdit;
    chkZModemOptionOverride: TCheckBox;
    chkZModemRecover: TCheckBox;
    chkZModemSkipNoFile: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    ZModem8K             : WordBool;
    ZModemFileOptions    : TZModemFileOptions;
    ZModemFinishRetry    : Integer;
    ZModemOptionOverride : WordBool;
    ZModemRecover        : WordBool;
    ZModemSkipNoFile     : WordBool;
  end;

var
  ApxZModemOptions: TApxZModemOptions;

implementation

{$R *.DFM}

{ ----------------------------------------------------------------------- }
procedure TApxZModemOptions.FormActivate(Sender: TObject);
begin
  try
    chkZModem8K.Checked             := ZModem8K;
    cbxZModemFileOptions.ItemIndex  := Integer(ZModemFileOptions);
    edtZModemFinishRetry.Text       := IntToStr(ZModemFinishRetry);
    chkZModemOptionOverride.Checked := ZModemOptionOverride;
    chkZModemRecover.Checked        := ZModemRecover;
    chkZModemSkipNoFile.Checked     := ZModemSkipNoFile;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxZModemOptions.btnOkClick(Sender: TObject);
begin
  try
    ZModem8K             := chkZModem8K.Checked;
    ZModemFileOptions    := TZModemFileOptions(cbxZModemFileOptions.ItemIndex);
    ZModemFinishRetry    := StrToIntDef(edtZModemFinishRetry.Text, 0);
    ZModemOptionOverride := chkZModemOptionOverride.Checked;
    ZModemRecover        := chkZModemRecover.Checked;
    ZModemSkipNoFile     := chkZModemSkipNoFile.Checked ;   
    ModalResult := mrOk;
  except
    ModalResult := mrCancel;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxZModemOptions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
