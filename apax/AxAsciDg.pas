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
{*                       AXASCIDG.PAS 1.13                        *}
{******************************************************************}
{* AxAsciDg.PAS - Ascii protocol properties editor dialog         *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxAsciDg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, AdPort, AdProtcl;

type
  TApxAsciiOptions = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    gbxDelays: TGroupBox;
    gbxTerminators1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtAsciiCharDelay: TMaskEdit;
    edtAsciiLineDelay: TMaskEdit;
    edtAsciiEOFTimeout: TMaskEdit;
    edtAsciiEOLChar: TMaskEdit;
    rgAsciiCRTranslation: TRadioGroup;
    rgAsciiLFTranslation: TRadioGroup;
    chkAsciiSuppressCtrlZ: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    AsciiCharDelay     : Integer;
    AsciiLineDelay     : Integer;
    AsciiSuppressCtrlZ : WordBool;
    AsciiEOFTimeout    : Integer;
    AsciiEOLChar       : Integer;
    AsciiCRTranslation : TAsciiEOLTranslation;
    AsciiLFTranslation : TAsciiEOLTranslation;
  end;

var
  ApxAsciiOptions: TApxAsciiOptions;

implementation

{$R *.DFM}



{ ----------------------------------------------------------------------- }
procedure TApxAsciiOptions.FormActivate(Sender: TObject);
begin
  try
    chkAsciiSuppressCtrlZ.Checked   := AsciiSuppressCtrlZ;
    edtAsciiCharDelay.Text          := IntToStr(AsciiCharDelay);
    edtAsciiEOFTimeout.Text         := IntToStr(AsciiEOFTimeout);
    edtAsciiEOLChar.Text            := IntToStr(AsciiEOLChar);
    edtAsciiLineDelay.Text          := IntToStr(AsciiLineDelay);
    case AsciiCRTranslation of
      aetNone        : rgAsciiCRTranslation.ItemIndex := 0;
      aetStrip       : rgAsciiCRTranslation.ItemIndex := 1;
      aetAddCRBefore : rgAsciiCRTranslation.ItemIndex := 2;
      aetAddLFAfter  : rgAsciiCRTranslation.ItemIndex := 2;
    end;
    case AsciiLFTranslation of
      aetNone        : rgAsciiLFTranslation.ItemIndex := 0;
      aetStrip       : rgAsciiLFTranslation.ItemIndex := 1;
      aetAddCRBefore : rgAsciiLFTranslation.ItemIndex := 2;
      aetAddLFAfter  : rgAsciiLFTranslation.ItemIndex := 2;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxAsciiOptions.btnOkClick(Sender: TObject);
begin
  try
    AsciiSuppressCtrlZ := chkAsciiSuppressCtrlZ.Checked;
    AsciiCharDelay := StrToIntDef(edtAsciiCharDelay.Text, 0);
    AsciiEOFTimeout := StrToIntDef(edtAsciiEOFTimeout.Text, 364);
    AsciiEOLChar := StrToIntDef(edtAsciiEOLChar.Text, 13);
    AsciiLineDelay := StrToIntDef(edtAsciiLineDelay.Text, 0);
    case rgAsciiCRTranslation.ItemIndex of
      0 : AsciiCRTranslation := aetNone;
      1 : AsciiCRTranslation := aetStrip;
      2 : AsciiCRTranslation := aetAddLFAfter;
    end;
    case rgAsciiLFTranslation.ItemIndex of
      0 : AsciiLFTranslation := aetNone;
      1 : AsciiLFTranslation := aetStrip;
      2 : AsciiLFTranslation := aetAddCRBefore;
    end;
    ModalResult := mrOk;
  except
    ModalResult := mrCancel;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxAsciiOptions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
