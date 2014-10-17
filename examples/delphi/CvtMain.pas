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
{*                      CVTMAIN.PAS                       *}
{**********************************************************}

{**********************Description************************}
{* Demonstrates how the fax converter component converts *}
{*       text, BMP, PCX, DCX, and TIFF files.            *}
{*********************************************************}

unit Cvtmain;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, FileCtrl, ooMisc, CvtOpt, CvtProg;

type
  TCvtMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    FileListBox: TFileListBox;
    DirectoryListBox: TDirectoryListBox;
    DriveComboBox: TDriveComboBox;
    FileNameEdit: TEdit;
    CancelBtn: TBitBtn;
    FilterComboBox: TFilterComboBox;
    Label6: TLabel;
    ConvertList: TListBox;
    OkBtn: TBitBtn;
    AddBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    OptionsBtn: TBitBtn;
    procedure OptionsBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure ConvertListClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FileListBoxDblClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }

    function FileInConvertList(const FName : String) : Boolean;
      {-Return TRUE is FName is in the convert file list}

  public
    { Public declarations }
  end;

var
  CvtMainForm: TCvtMainForm;

implementation

{$R *.DFM}

function ContainsWildCards(const S : String) : Boolean;
var
  I : Word;

begin
  Result := True;
  for I := 1 to Length(S) do
    if (S[I] = '*') or (S[I] = '?') then
      Exit;
  Result := False;
end;

function TCvtMainForm.FileInConvertList(const FName : String) : Boolean;
  {-Return TRUE if FName is in the convert file list}
begin
  Result := (ConvertList.Items.IndexOf(FName) <> -1);
end;

procedure TCvtMainForm.OptionsBtnClick(Sender: TObject);
begin
  CvtOptionsForm := TCvtOptionsForm.Create(Self);
  CvtOptionsForm.ShowModal;
  CvtOptionsForm.Free;
end;

procedure TCvtMainForm.AddBtnClick(Sender: TObject);
var
  I       : Word;
  N       : String;
  TempDir : String;

begin
  {if any files are selected, add them to the convert list}
  if (FileListBox.SelCount <> 0) {and
    not ContainsWildCards(FileNameEdit.Text)} then begin
    Cursor := crHourGlass;
    for I := 0 to Pred(FileListBox.Items.Count) do
      if FileListBox.Selected[I]
        and not FileInConvertList(LowerCase(FileListBox.FileName))then
        ConvertList.Items.Add(LowerCase(AddBackSlash(FileListBox.Directory)
          + FileListBox.Items[I]));
    OkBtn.Enabled := True;
    Cursor := crDefault;
  {no files are selected, but maybe user typed a file name}
  end else begin
    N := TrimRight(FileNameEdit.Text);
    {if nothing is entered, beep and let user try again}
    if N = '' then begin
      MessageBeep(0);
      FileNameEdit.SetFocus;
      Exit;
    end;

    {get the fully qualified name of the file}
    N := LowerCase(ExpandFileName(N));

    {extract the directory portion of the file name}
    TempDir := ExtractFilePath(N);

    {if the directory is not valid, beep and let user try again}
    if not DirectoryExists(TempDir) then begin
      MessageBeep(0);
      FileNameEdit.SetFocus;
      Exit;
    end;

    {if the name contains no wildcards, add the file to the convert list}
    if not ContainsWildCards(N) then begin

      {make sure the file exists}
      if not FileExists(N) then begin
        MessageBeep(0);
        FileNameEdit.SetFocus;

      {make sure the file isn't already in the list}
      end else if not FileInConvertList(N) then begin
        ConvertList.Items.Add(N);
        FileNameEdit.Text := '';
        OkBtn.Enabled := True;
      end;

    {the name contains wildcards, so reset the directory and mask and }
    {reload the listboxes}
    end else begin
      FileListBox.Mask := N;
      DirectoryListBox.Directory := TempDir;
      FileNameEdit.Text := '';
    end;
  end;
end;

procedure TCvtMainForm.ConvertListClick(Sender: TObject);
begin
  CvtMainForm.RemoveBtn.Enabled := True;
end;

procedure TCvtMainForm.RemoveBtnClick(Sender: TObject);
var
  I : Word;

begin
  if (ConvertList.Items.Count <= 0) then
    Exit;

  Cursor := crHourGlass;
  for I := Pred(ConvertList.Items.Count) downto 0 do
    if ConvertList.Selected[I] then
      ConvertList.Items.Delete(I);
  RemoveBtn.Enabled := False;
  OkBtn.Enabled := (ConvertList.Items.Count <>0);
  Cursor := crDefault;
end;

procedure TCvtMainForm.OkBtnClick(Sender: TObject);
var
  I : Word;

begin
  if (ConvertList.Items.Count <> 0) then
    for I := 0 to Pred(ConvertList.Items.Count) do
      CvtProgressForm.ConvertList.Items.Add(ConvertList.Items[I]);
  CvtProgressForm.ShowModal;
  CvtProgressForm.ConvertList.Items.Clear;
  ConvertList.Items.Clear;
  OkBtn.Enabled := False;
end;

procedure TCvtMainForm.FileListBoxDblClick(Sender: TObject);
var
  Path : String;

begin
  Path := LowerCase(FileListBox.FileName);
  if (Path = '') then
    Exit;

  if not FileInConvertList(Path) then begin
    ConvertList.Items.Add(Path);
    OkBtn.Enabled := True;
  end;
end;

procedure TCvtMainForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

end.
