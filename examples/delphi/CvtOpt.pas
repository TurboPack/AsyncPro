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
{*                    CVTOPT.PAS 4.06                    *}
{*********************************************************}

unit Cvtopt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, AdFaxCvt, Cvtprog, Mask,
  AdFax;

type
  TCvtOptionsForm = class(TForm)
    ResolutionRadioGroup: TRadioGroup;
    WidthRadioGroup: TRadioGroup;
    GraphicsGroupBox: TGroupBox;
    PositionRadioGroup: TRadioGroup;
    AsciiGroupBox: TGroupBox;
    Label1: TLabel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FontRadioGroup: TRadioGroup;
    LinesPerPageEdit: TMaskEdit;
    ScalingRadioGroup: TRadioGroup;
    EnhTextBox: TCheckBox;
    FntButton: TButton;
    FontDialog1: TFontDialog;
    procedure OkBtnClick(Sender: TObject);
    procedure ResolutionRadioGroupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EnhTextBoxClick(Sender: TObject);
    procedure FntButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CvtOptionsForm: TCvtOptionsForm;

implementation

{$R *.DFM}

procedure TCvtOptionsForm.OkBtnClick(Sender: TObject);
begin
  try
    CvtProgressForm.FaxConverter.LinesPerPage := StrToInt(LinesPerPageEdit.Text);
  except
    MessageDlg('You must enter a number here.', mtError, [mbOK], 0);
    LinesPerPageEdit.SetFocus;
    Exit;
  end;

  CvtProgressForm.FaxConverter.Resolution := TFaxResolution(ResolutionRadioGroup.ItemIndex);
  CvtProgressForm.FaxConverter.Width := TFaxWidth(WidthRadioGroup.ItemIndex);
  CvtProgressForm.FaxConverter.FontType := TFaxFont(FontRadioGroup.ItemIndex);

  CvtProgressForm.FaxConverter.Options := [coDoubleWidth, coCenterImage, coYieldOften];
  case ScalingRadioGroup.ItemIndex of
    0: CvtProgressForm.FaxConverter.Options := CvtProgressForm.FaxConverter.Options - [coDoubleWidth];
    2: CvtProgressForm.FaxConverter.Options := CvtProgressForm.FaxConverter.Options + [coHalfHeight] - [coDoubleWidth];
  end;
  if PositionRadioGroup.ItemIndex = 1 then
    CvtProgressForm.FaxConverter.Options := CvtProgressForm.FaxConverter.Options - [coCenterImage];
end;

procedure TCvtOptionsForm.ResolutionRadioGroupClick(Sender: TObject);
begin
  case ResolutionRadioGroup.ItemIndex of
    0: ScalingRadioGroup.Enabled := True;
    1: ScalingRadioGroup.Enabled := False;
  end;
end;

procedure TCvtOptionsForm.FormCreate(Sender: TObject);
begin
  LinesPerPageEdit.Text := IntToStr(CvtProgressForm.FaxConverter.LinesPerPage);

  ResolutionRadioGroup.ItemIndex := Ord(CvtProgressForm.FaxConverter.Resolution);
  WidthRadioGroup.ItemIndex      := Ord(CvtProgressForm.FaxConverter.Width);
  FontRadioGroup.ItemIndex       := Ord(CvtProgressForm.FaxConverter.FontType);

  if (coDoubleWidth in CvtProgressForm.FaxConverter.Options) then
    ScalingRadioGroup.ItemIndex := 1
  else if (coHalfHeight in CvtProgressForm.FaxConverter.Options) then
    ScalingRadioGroup.ItemIndex := 2
  else
    ScalingRadioGroup.ItemIndex := 0;

  if (coCenterImage in CvtProgressForm.FaxConverter.Options) then
    PositionRadioGroup.ItemIndex := 1
  else
    PositionRadioGroup.ItemIndex := 0;
end;

procedure TCvtOptionsForm.EnhTextBoxClick(Sender: TObject);
begin
  FntButton.Enabled := EnhTextBox.Checked;
  FontRadioGroup.Enabled := not(EnhTextBox.Checked);
  CvtProgressForm.UseEnhancedText := EnhTextBox.Checked;
end;

procedure TCvtOptionsForm.FntButtonClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(CvtProgressForm.FaxConverter.EnhFont);
  if FontDialog1.Execute then
    CvtProgressForm.FaxConverter.EnhFont.Assign(FontDialog1.Font);
end;

end.
