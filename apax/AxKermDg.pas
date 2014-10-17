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
{*                       AXKERMDG.PAS 1.13                        *}
{******************************************************************}
{* AxKermDg.PAS - Kermit protocol properties editor dialog        *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxKermDg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, AdPort, AdProtCl;

type
  TApxKermitOptions = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    gbxPrefixes: TGroupBox;
    gbxPadding: TGroupBox;
    gbxPacket: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    rgBlockCheckMethod: TRadioGroup;
    edtKermitHighbitPrefix: TMaskEdit;
    edtKermitRepeatPrefix: TMaskEdit;
    edtKermitCtlPrefix: TMaskEdit;
    edtKermitPadCount: TMaskEdit;
    edtKermitPadCharacter: TMaskEdit;
    edtKermitMaxLen: TMaskEdit;
    edtKermitTerminator: TMaskEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    BlockCheckMethod    : TBlockCheckMethod;
    KermitHighbitPrefix : Integer;
    KermitRepeatPrefix  : Integer;
    KermitCtlPrefix     : Integer;
    KermitPadCount      : Integer;
    KermitPadCharacter  : Integer;
    KermitMaxLen        : Integer;
    KermitTerminator    : Integer;
  end;

var
  ApxKermitOptions: TApxKermitOptions;

implementation

{$R *.DFM}

{ ----------------------------------------------------------------------- }
procedure TApxKermitOptions.FormActivate(Sender: TObject);
begin
  try
    rgBlockCheckMethod.ItemIndex := Integer(BlockCheckMethod);
    edtKermitHighbitPrefix.Text  := IntToStr(KermitHighbitPrefix);
    edtKermitRepeatPrefix.Text   := IntToStr(KermitRepeatPrefix);
    edtKermitCtlPrefix.Text      := IntToStr(KermitCtlPrefix);
    edtKermitPadCount.Text       := IntToStr(KermitPadCount);
    edtKermitPadCharacter.Text   := IntToStr(KermitPadCharacter);
    edtKermitMaxLen.Text         := IntToStr(KermitMaxLen);
    edtKermitTerminator.Text     := IntToStr(KermitTerminator);
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxKermitOptions.btnOkClick(Sender: TObject);
begin
  try
    BlockCheckMethod    := TBlockCheckMethod(rgBlockCheckMethod.ItemIndex);
    KermitHighbitPrefix := StrToIntDef(edtKermitHighbitPrefix.Text, Ord('Y'));
    KermitRepeatPrefix  := StrToIntDef(edtKermitRepeatPrefix.Text, Ord('~'));
    KermitCtlPrefix     := StrToIntDef(edtKermitCtlPrefix.Text, Ord('#'));
    KermitPadCount      := StrToIntDef(edtKermitPadCount.Text, 0);
    KermitPadCharacter  := StrToIntDef(edtKermitPadCharacter.Text, 32);
    KermitMaxLen        := StrToIntDef(edtKermitMaxLen.Text, 80);
    KermitTerminator    := StrToIntDef(edtKermitTerminator.Text, 13);
    ModalResult := mrOk;
  except
    ModalResult := mrCancel;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxKermitOptions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
