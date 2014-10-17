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
{*                       AXTERMPG.PAS 1.13                        *}
{******************************************************************}
{* AxTermPg.PAS - Terminal property page editor                   *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxTermPg;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, StdCtrls,
  ExtCtrls, Forms, ComServ, ComObj, StdVcl, AxCtrls, Dialogs, Buttons, Mask,
  ComCtrls;

type
  TApxTerminalPage = class(TPropertyPage)
    ColorDialog1: TColorDialog;
    Label4: TLabel;
    edtScrollbackRows: TMaskEdit;
    UpDown5: TUpDown;
    chkScrollBackEnabled: TCheckBox;
    Label6: TLabel;
    edtTerminalLazyTimeDelay: TMaskEdit;
    UpDown4: TUpDown;
    Label5: TLabel;
    edtTerminalLazyByteDelay: TMaskEdit;
    UpDown3: TUpDown;
    chkTerminalUseLazyDisplay: TCheckBox;
    Label8: TLabel;
    edtCaptureFile: TEdit;
    Label7: TLabel;
    cbxCaptureMode: TComboBox;
    pnlColor: TPanel;
    btnColor: TButton;
    Label1: TLabel;
    cbxEmulation: TComboBox;
    Label10: TLabel;
    edtColumns: TMaskEdit;
    UpDown2: TUpDown;
    Label9: TLabel;
    edtRows: TMaskEdit;
    UpDown1: TUpDown;
    chkTerminalWantAllKeys: TCheckBox;
    chkTerminalHalfDuplex: TCheckBox;
    chkTerminalActive: TCheckBox;
    chkVisible: TCheckBox;
    Bevel1: TBevel;
    Label2: TLabel;
    Bevel2: TBevel;
    Label3: TLabel;
    Bevel3: TBevel;
    Label11: TLabel;
    Bevel4: TBevel;
    Label12: TLabel;
    procedure btnColorClick(Sender: TObject);
    procedure chkVisibleClick(Sender: TObject);
    procedure edtRowsChange(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure UpdatePropertyPage; override;
    procedure UpdateObject; override;
  end;

const
  Class_ApxTerminalPage: TGUID = '{82883C4A-1ACC-4B0A-812A-F66E69546D6F}';

implementation

uses
  AdTrmEmu, AxTerm;

{$R *.DFM}

procedure TApxTerminalPage.UpdatePropertyPage;
begin
  try
    chkVisible.Checked                := OleObject.Visible;
    chkTerminalActive.Checked         := OleObject.TerminalActive;
    pnlColor.Color                    := OleObject.Color;
    cbxCaptureMode.ItemIndex          := OleObject.CaptureMode;
    edtCaptureFile.Text               := OleObject.CaptureFile;
    cbxEmulation.ItemIndex            := OleObject.Emulation;
    chkScrollBackEnabled.Checked      := OleObject.ScrollBackEnabled;
    UpDown5.Position := OleObject.ScrollbackRows;
    {edtScrollbackRows.Text            := IntToStr(OleObject.ScrollbackRows);}
    chkTerminalUseLazyDisplay.Checked := OleObject.TerminalUseLazyDisplay;
    UpDown3.Position := OleObject.TerminalLazyByteDelay;
    {edtTerminalLazyByteDelay.Text     := IntToStr(OleObject.TerminalLazyByteDelay);}
    UpDown4.Position := OleObject.TerminalLazyTimeDelay;
    edtTerminalLazyTimeDelay.Text     := IntToStr(OleObject.TerminalLazyTimeDelay);
    chkTerminalHalfDuplex.Checked     := OleObject.TerminalHalfDuplex;
    chkTerminalWantAllKeys.Checked    := OleObject.TerminalWantAllKeys;
    UpDown1.Position := OleObject.Rows;
    {edtRows.Text                      := IntToStr(OleObject.Rows);}
    UpDown2.Position := OleObject.Columns;
    {edtColumns.Text                   := IntToStr(OleObject.Columns);}
  except
  end;
end;

procedure TApxTerminalPage.UpdateObject;
begin
  try
    OleObject.Visible                := chkVisible.Checked;
    OleObject.TerminalActive         := chkTerminalActive.Checked;
    OleObject.Color                  := pnlColor.Color;
    OleObject.CaptureMode            := cbxCaptureMode.ItemIndex;
    OleObject.CaptureFile            := edtCaptureFile.Text;
    OleObject.Emulation              := cbxEmulation.ItemIndex;
    OleObject.ScrollBackEnabled      := chkScrollBackEnabled.Checked;
    OleObject.ScrollbackRows         := StrToIntDef(edtScrollbackRows.Text, 200);
    OleObject.TerminalUseLazyDisplay := chkTerminalUseLazyDisplay.Checked;
    OleObject.TerminalLazyByteDelay  := StrToIntDef(edtTerminalLazyByteDelay.Text, 128);
    OleObject.TerminalLazyTimeDelay  := StrToIntDef(edtTerminalLazyTimeDelay.Text, 250);
    OleObject.TerminalHalfDuplex     := chkTerminalHalfDuplex.Checked;
    OleObject.TerminalWantAllKeys    := chkTerminalWantAllKeys.Checked;
    OleObject.Rows                   := StrToIntDef(edtRows.Text, 24);
    OleObject.Columns                := StrToIntDef(edtColumns.Text, 80);
  except
  end;
end;

procedure TApxTerminalPage.btnColorClick(Sender: TObject);
begin
  try
    ColorDialog1.Color := pnlColor.Color;
    if ColorDialog1.Execute then begin
      pnlColor.Color := ColorDialog1.Color;
      Modified;
    end;
  except
  end;
end;

procedure TApxTerminalPage.chkVisibleClick(Sender: TObject);
begin
  Modified;
end;

procedure TApxTerminalPage.edtRowsChange(Sender: TObject);
begin
  Modified;
end;

initialization
  TActiveXPropertyPageFactory.Create(
    ComServer,
    TApxTerminalPage,
    Class_ApxTerminalPage);
end.
