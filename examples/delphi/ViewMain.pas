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

{**********************************************************}
{*                     VIEWMAIN.PAS                       *}
{**********************************************************}

{**********************Description************************}
{* A fax viewer that allows you to view APF files.       *}
{*********************************************************}

unit ViewMain;

interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Menus,
  ExtCtrls,
  Buttons,
  StdCtrls,
  ooMisc,
  AdFView,
  AdFaxPrn,
  AdFPStat,
  WComp,
  Percent;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FaxViewer: TApdFaxViewer;
    FileItem: TMenuItem;
    OpenItem: TMenuItem;
    N1: TMenuItem;
    PrintSetupItem: TMenuItem;
    PrintItem: TMenuItem;
    N2: TMenuItem;
    ExitItem: TMenuItem;
    EditItem: TMenuItem;
    SelectAllItem: TMenuItem;
    CopyItem: TMenuItem;
    ViewItem: TMenuItem;
    N25PercentItem: TMenuItem;
    N50PercentItem: TMenuItem;
    N75PercentItem: TMenuItem;
    N100PercentItem: TMenuItem;
    N200PercentItem: TMenuItem;
    N400PercentItem: TMenuItem;
    N3: TMenuItem;
    OtherSizeItem: TMenuItem;
    WhitespaceCompOption: TMenuItem;
    ZoomInItem: TMenuItem;
    ZoomOutItem: TMenuItem;
    N4: TMenuItem;
    OpenDialog: TOpenDialog;
    FaxPrinter: TApdFaxPrinter;
    PrinterStatus: TApdFaxPrinterStatus;
    N5: TMenuItem;
    Rotate90Item: TMenuItem;
    Rotate180Item: TMenuItem;
    Rotate270Item: TMenuItem;
    NoRotateItem: TMenuItem;
    StatusPanel: TPanel;
    CloseItem: TMenuItem;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure OpenItemClick(Sender: TObject);
    procedure PrintSetupItemClick(Sender: TObject);
    procedure PrintItemClick(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure SelectAllItemClick(Sender: TObject);
    procedure CopyItemClick(Sender: TObject);
    procedure ZoomInItemClick(Sender: TObject);
    procedure ZoomOutItemClick(Sender: TObject);
    procedure N25PercentItemClick(Sender: TObject);
    procedure N50PercentItemClick(Sender: TObject);
    procedure N75PercentItemClick(Sender: TObject);
    procedure N100PercentItemClick(Sender: TObject);
    procedure N200PercentItemClick(Sender: TObject);
    procedure N400PercentItemClick(Sender: TObject);
    procedure OtherSizeItemClick(Sender: TObject);
    procedure WhitespaceCompOptionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NoRotateItemClick(Sender: TObject);
    procedure Rotate90ItemClick(Sender: TObject);
    procedure Rotate180ItemClick(Sender: TObject);
    procedure Rotate270ItemClick(Sender: TObject);
    procedure FaxViewerPageChange(Sender: TObject);
    procedure FaxViewerViewerError(Sender: TObject; ErrorCode: Integer);
    procedure CloseItemClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure PrevClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FaxViewerDropFile(Sender: TObject; FileName: String);
  private
    { Private declarations }
  public
    ViewPercent : Integer;

    procedure UpdateViewPercent(const NewPercent : Integer);
    procedure EnableZoomChoices;
    procedure DisableZoomChoices;
    procedure UncheckZoomChoices;
    procedure EnableRotationChoices;
    procedure DisableRotationChoices;
    procedure UncheckRotationChoices;
    procedure OpenFile(const FileName : string);
    procedure CloseFile;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.CloseFile;
begin
  FaxViewer.FileName := '';
  DisableZoomChoices;
  DisableRotationChoices;
  SelectAllItem.Enabled := False;
  CopyItem.Enabled      := False;
  StatusPanel.Caption   := '  No file loaded';
  FaxViewer.Invalidate;
end;

procedure TMainForm.OpenFile(const FileName : string);
begin
  FaxViewer.BeginUpdate;
  FaxViewer.Scaling   := False;
  FaxViewer.HorizMult := 1;
  FaxViewer.HorizDiv  := 1;
  FaxViewer.VertMult  := 1;
  FaxViewer.VertDiv   := 1;
  FaxViewer.EndUpdate;
  UncheckZoomChoices;
  UncheckRotationChoices;
  try
    FaxViewer.FileName := FileName;
    EnableZoomChoices;
    EnableRotationChoices;
    SelectAllItem.Enabled   := True;
    CopyItem.Enabled        := True;
    N100PercentItem.Checked := True;
    NoRotateItem.Checked    := True;
    ViewPercent             := 100;
    StatusPanel.Caption     := Format('  Viewing page 1 of %d in %s', [FaxViewer.NumPages, FaxViewer.FileName]);
  except
    CloseFile;
    MessageDlg('Error opening fax file '+FileName, mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.OpenItemClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    OpenFile(OpenDialog.FileName);
end;

procedure TMainForm.CloseItemClick(Sender: TObject);
begin
  CloseFile;
end;

procedure TMainForm.PrintSetupItemClick(Sender: TObject);
begin
  FaxPrinter.PrintSetup;
end;

procedure TMainForm.PrintItemClick(Sender: TObject);
begin
  if (FaxViewer.FileName <> '') then begin
    FaxPrinter.FileName := FaxViewer.FileName;
    FaxPrinter.PrintFax;
  end;
end;

procedure TMainForm.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.SelectAllItemClick(Sender: TObject);
begin
  FaxViewer.SelectImage;
end;

procedure TMainForm.CopyItemClick(Sender: TObject);
begin
  FaxViewer.CopyToClipBoard;
end;

procedure TMainForm.ZoomInItemClick(Sender: TObject);
var
  TempPercent : Integer;

begin
  if ((ViewPercent mod 25) = 0) then
    TempPercent := ViewPercent + 25
  else
    TempPercent := ViewPercent + (25 - (ViewPercent mod 25));
  if (TempPercent > 400) then begin
    MessageBeep(0);
    Exit;
  end;
  UpdateViewPercent(TempPercent);
end;

procedure TMainForm.ZoomOutItemClick(Sender: TObject);
var
  TempPercent : Integer;

begin
  if ((ViewPercent mod 25) = 0) then
    TempPercent := ViewPercent - 25
  else
    TempPercent := ViewPercent - (25 - (ViewPercent mod 25));

  if (TempPercent < 25) then begin
    MessageBeep(0);
    Exit;
  end;
  UpdateViewPercent(TempPercent);
end;

procedure TMainForm.N25PercentItemClick(Sender: TObject);
begin
  UpdateViewPercent(25);
end;

procedure TMainForm.N50PercentItemClick(Sender: TObject);
begin
  UpdateViewPercent(50);
end;

procedure TMainForm.N75PercentItemClick(Sender: TObject);
begin
  UpdateViewPercent(75);
end;

procedure TMainForm.N100PercentItemClick(Sender: TObject);
begin
  UpdateViewPercent(100);
end;

procedure TMainForm.N200PercentItemClick(Sender: TObject);
begin
  UpdateViewPercent(200);
end;

procedure TMainForm.N400PercentItemClick(Sender: TObject);
begin
  UpdateViewPercent(400);
end;

procedure TMainForm.OtherSizeItemClick(Sender: TObject);
var
  Frm         : TPercentForm;
  TempPercent : Integer;

begin
  Frm := TPercentForm.Create(Self);
  Frm.ShowModal;
  if (Frm.ModalResult = mrOK) then
    TempPercent := StrToInt(Frm.PercentEdit.Text)
  else
    TempPercent := -1;
  Frm.Free;

  if (TempPercent <> -1) then
    UpdateViewPercent(TempPercent);
end;

procedure TMainForm.WhitespaceCompOptionClick(Sender: TObject);
var
  Frm : TWhitespaceCompForm;
  Tmp : Integer;

begin
  Frm := TWhitespaceCompForm.Create(Self);
  Frm.CompEnabledBox.Checked := FaxViewer.WhitespaceCompression;
  if FaxViewer.WhitespaceCompression then begin
    Frm.FromEdit.Text := IntToStr(FaxViewer.WhitespaceFrom);
    Frm.ToEdit.Text   := IntToStr(FaxViewer.WhitespaceTo);
  end;

  if (Frm.ShowModal = mrOK) then begin
    FaxViewer.WhitespaceCompression := Frm.CompEnabledBox.Checked;
    if FaxViewer.WhitespaceCompression then begin
      Tmp := StrToInt(Frm.FromEdit.Text);
      FaxViewer.WhitespaceFrom := Tmp;
      Tmp := StrToInt(Frm.ToEdit.Text);
      FaxViewer.WhitespaceTo := Tmp;
    end;
  end;

  Frm.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ViewPercent := 100;
  DisableZoomChoices;
  SelectAllItem.Enabled := False;
  CopyItem.Enabled      := False;
end;

procedure TMainForm.UpdateViewPercent(const NewPercent : Integer);
begin
  if (NewPercent = ViewPercent) then
    Exit;

  ViewPercent := NewPercent;

  if (NewPercent = 100) then
    FaxViewer.Scaling := False
  else begin
    FaxViewer.BeginUpdate;
    FaxViewer.Scaling   := True;
    FaxViewer.HorizMult := NewPercent;
    FaxViewer.HorizDiv  := 100;
    FaxViewer.VertMult  := NewPercent;
    FaxViewer.VertDiv   := 100;
    FaxViewer.EndUpdate;
  end;

  UncheckZoomChoices;
  case ViewPercent of
    25 : N25PercentItem.Checked  := True;
    50 : N50PercentItem.Checked  := True;
    75 : N75PercentItem.Checked  := True;
    100: N100PercentItem.Checked := True;
    200: N200PercentItem.Checked := True;
    400: N400PercentItem.Checked := True;
    else
      OtherSizeItem.Checked := True;
  end;
end;

procedure TMainForm.EnableZoomChoices;
begin
  N25PercentItem.Enabled  := True;
  N50PercentItem.Enabled  := True;
  N75PercentItem.Enabled  := True;
  N100PercentItem.Enabled := True;
  N200PercentItem.Enabled := True;
  N400PercentItem.Enabled := True;
  OtherSizeItem.Enabled   := True;
  ZoomInItem.Enabled      := True;
  ZoomOutItem.Enabled     := True;
end;

procedure TMainForm.DisableZoomChoices;
begin
  N25PercentItem.Enabled  := False;
  N50PercentItem.Enabled  := False;
  N75PercentItem.Enabled  := False;
  N100PercentItem.Enabled := False;
  N200PercentItem.Enabled := False;
  N400PercentItem.Enabled := False;
  OtherSizeItem.Enabled   := False;
  ZoomInItem.Enabled      := False;
  ZoomOutItem.Enabled     := False;
end;

procedure TMainForm.UncheckZoomChoices;
begin
  N25PercentItem.Checked  := False;
  N50PercentItem.Checked  := False;
  N75PercentItem.Checked  := False;
  N100PercentItem.Checked := False;
  N200PercentItem.Checked := False;
  N400PercentItem.Checked := False;
  OtherSizeItem.Checked   := False;
end;

procedure TMainForm.EnableRotationChoices;
begin
  NoRotateItem.Enabled  := True;
  Rotate90Item.Enabled  := True;
  Rotate180Item.Enabled := True;
  Rotate270Item.Enabled := True;
end;

procedure TMainForm.DisableRotationChoices;
begin
  NoRotateItem.Enabled  := False;
  Rotate90Item.Enabled  := False;
  Rotate180Item.Enabled := False;
  Rotate270Item.Enabled := False;
end;

procedure TMainForm.UncheckRotationChoices;
begin
  NoRotateItem.Checked  := False;
  Rotate90Item.Checked  := False;
  Rotate180Item.Checked := False;
  Rotate270Item.Checked := False;
end;

procedure TMainForm.NoRotateItemClick(Sender: TObject);
begin
  FaxViewer.Rotation := vr0;
  UncheckRotationChoices;
  NoRotateItem.Checked := True;
end;

procedure TMainForm.Rotate90ItemClick(Sender: TObject);
begin
  FaxViewer.Rotation := vr90;
  UncheckRotationChoices;
  Rotate90Item.Checked := True;
end;

procedure TMainForm.Rotate180ItemClick(Sender: TObject);
begin
  FaxViewer.Rotation := vr180;
  UncheckRotationChoices;
  Rotate180Item.Checked := True;
end;

procedure TMainForm.Rotate270ItemClick(Sender: TObject);
begin
  FaxViewer.Rotation := vr270;
  UncheckRotationChoices;
  Rotate270Item.Checked := True;
end;

procedure TMainForm.FaxViewerPageChange(Sender: TObject);
var
  W : Word;
begin
  if (FaxViewer.FileName <> '') then
    begin
      StatusPanel.Caption := Format('  Viewing page %d of %d in %s', [FaxViewer.ActivePage,
        FaxViewer.NumPages, FaxViewer.FileName]);
      W := FaxViewer.PageFlags;
      CheckBox1.Checked := W and ffHighRes <> 0;
      CheckBox2.Checked := W and ffHighWidth <> 0;
      CheckBox3.Checked := W and ffLengthWords <> 0;
    end
  else
    begin
      StatusPanel.Caption := '  No file loaded';
      Panel1.Caption := '';
    end;
end;

procedure TMainForm.FaxViewerViewerError(Sender: TObject;
  ErrorCode: Integer);
begin
  MessageDlg(Format('Viewer error %d', [ErrorCode]), mtError, [mbOK], 0);
end;

procedure TMainForm.NextClick(Sender: TObject);
begin
  if FaxViewer.ActivePage < FaxViewer.NumPages then
    FaxViewer.ActivePage := FaxViewer.ActivePage + 1;
end;

procedure TMainForm.PrevClick(Sender: TObject);
begin
  if FaxViewer.ActivePage > 1 then
    FaxViewer.ActivePage := FaxViewer.ActivePage - 1;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if ParamCount > 0 then
    OpenFile(ParamStr(1));
end;

procedure TMainForm.FaxViewerDropFile(Sender: TObject; FileName: String);
begin
  EnableZoomChoices;
  EnableRotationChoices;
  SelectAllItem.Enabled   := True;
  CopyItem.Enabled        := True;
  N100PercentItem.Checked := True;
  NoRotateItem.Checked    := True;
  ViewPercent             := 100;
  StatusPanel.Caption     := Format('  Viewing page 1 of %d in %s', [FaxViewer.NumPages, FaxViewer.FileName]);
end;

end.
