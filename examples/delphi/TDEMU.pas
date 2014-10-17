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
{*                    TDEMU.PAS 4.06                     *}
{*********************************************************}

unit Tdemu;

{$G+,X+,F+}

{Conditional defines that may affect this unit}
{$I AWDEFINE.INC}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls, AdTrmEmu;

type
  TEmuOptions = class(TForm)
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    KeyEmuListComboBox: TComboBox;
    FileNameButton: TButton;
    FileNameEdit: TEdit;
    EnabledCheckBox: TCheckBox;
    ProcessAllCheckBox: TCheckBox;
    ProcessExtCheckBox: TCheckBox;
    GroupBox2: TGroupBox;
    EmuListComboBox: TComboBox;
    Ok: TBitBtn;
    Cancel: TBitBtn;
    EditKeyMapButton: TButton;
    procedure OkClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure EnabledCheckBoxClick(Sender: TObject);
    procedure FileNameButtonClick(Sender: TObject);
    procedure EditKeyMapButtonClick(Sender: TObject);
  private
    { Private declarations }
    FKeyEmu : TApdKeyboardEmulator;
    FEmu    : TApdEmulator;
    Executed: Boolean;
  protected
    function GetKeyEmu : TApdKeyboardEmulator;
    function GetEmu : TApdEmulator;
    procedure SetKeyEmu(NewKeyEmu : TApdKeyboardEmulator);
    procedure SetEmu(NewEmu : TApdEmulator);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;

    property KeyEmulator : TApdKeyboardEmulator
      read GetKeyEmu write SetKeyEmu;
    property TermEmulator : TApdEmulator
      read GetEmu write SetEmu;
  end;

var
  EmuOptions: TEmuOptions;

implementation

{$R *.DFM}

constructor TEmuOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FEmu     := TApdEmulator.Create(Self);
  FKeyEmu  := TApdKeyboardEmulator.Create(Self);
  Executed := False;
end;

destructor TEmuOptions.Destroy;
begin
  FKeyEmu.Free;
  FEmu.Free;
  inherited Destroy;
end;

function TEmuOptions.Execute: Boolean;
begin
  {update dialog contents - keyboard emulator}
  EnabledCheckBox.Checked      := FKeyEmu.Enabled;
  ProcessAllCheckBox.Checked   := FKeyEmu.ProcessAllKeys;
  ProcessExtCheckBox.Checked   := FKeyEmu.ProcessExtended;
  KeyEmuListComboBox.Items     := FKeyEmu.KeyEmuTypeList;
  KeyEmuListComboBox.ItemIndex := FKeyEmu.KeyEmuTypeList.IndexOf(FKeyEmu.EmulatorType);
  FileNameEdit.Text            := FKeyEmu.MapFileName;

  {update dialog contents - terminal emulator}
  EmuListComboBox.ItemIndex := Ord(FEmu.EmulatorType);

  {show the dialog}
  ShowModal;
  Result := ModalResult = mrOK;
  Executed := Result;
end;

function TEmuOptions.GetKeyEmu : TApdKeyboardEmulator;
begin
  if Executed then begin
    {Update KeyEmu from dialog controls}
    with FKeyEmu do begin
      MapFileName    := FileNameEdit.Text;
      Enabled        := EnabledCheckBox.Checked;
      EmulatorType   := KeyEmuListComboBox.Items[KeyEmuListComboBox.ItemIndex];

      ProcessAllKeys := not ProcessAllCheckBox.Checked;
      ProcessExtended := not ProcessExtCheckBox.Checked;

      ProcessAllKeys := ProcessAllCheckBox.Checked;
      ProcessExtended := ProcessExtCheckBox.Checked;
    end;
  end;
  Result := FKeyEmu;
end;

function TEmuOptions.GetEmu : TApdEmulator;
begin
  if Executed then begin
    {Update the terminal emulator type}
    FEmu.EmulatorType := TEmulatorType(EmuListComboBox.ItemIndex);
  end;
  Result := FEmu;
end;

procedure TEmuOptions.SetKeyEmu(NewKeyEmu : TApdKeyboardEmulator);
begin
  if (NewKeyEmu <> FKeyEmu) then
    FKeyEmu := NewKeyEmu;
end;

procedure TEmuOptions.SetEmu(NewEmu : TApdEmulator);
begin
  if (NewEmu <> FEmu) then
    FEmu := NewEmu;
end;

procedure TEmuOptions.OkClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TEmuOptions.CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TEmuOptions.EnabledCheckBoxClick(Sender: TObject);
begin
  FKeyEmu.Enabled := EnabledCheckBox.Checked;
  KeyEmuListComboBox.Items := FKeyEmu.KeyEmuTypeList;
  if KeyEmuListComboBox.Items.Count > 0 then
    KeyEmuListComboBox.ItemIndex := 0;
end;

procedure TEmuOptions.FileNameButtonClick(Sender: TObject);
begin
  OpenDialog1.FileName := FileNameEdit.Text;
  if OpenDialog1.Execute then begin
    FileNameEdit.Text := OpenDialog1.FileName;
    FKeyEmu.MapFileName := FileNameEdit.Text;
    KeyEmuListComboBox.Items := FKeyEmu.KeyEmuTypeList;
    if KeyEmuListComboBox.Items.Count > 0 then
      KeyEmuListComboBox.ItemIndex := 0;
  end;
end;

procedure TEmuOptions.EditKeyMapButtonClick(Sender: TObject);
var
  Editor : TKMEditor;
begin
  {create Key Map Editor Form}
  Editor := TKMEditor.Create(Self);
  try
    {set the filename property}
    Editor.FileName := FKeyEmu.MapFileName;
    {show the form}
    if Editor.ShowModal = mrOK then
      FKeyEmu.MapFileName := Editor.FileName;
  finally
    {clean up}
    Editor.Free;
  end;
end;

end.
