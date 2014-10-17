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

unit ExMdmCa0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdLibMdm, Buttons;

type
  TForm1 = class(TForm)
    lbxManufacturers: TListBox;
    Label1: TLabel;
    Edit1: TEdit;
    btnLoadModemcap: TButton;
    Label2: TLabel;
    Label3: TLabel;
    lbxModels: TListBox;
    lbxModemFile: TListBox;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    btnLoadModemFile: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnSaveModemFile: TButton;
    procedure btnLoadModemcapClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbxManufacturersClick(Sender: TObject);
    procedure btnLoadModemFileClick(Sender: TObject);
    procedure btnSaveModemFileClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure lbxModelsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ModemColl : TApdLmModemCollection;
    LibModem : TApdLibModem;
    MyModems : TApdLibModem;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  LibModem := TApdLibModem.Create(Self);
  MyModems := TApdLibModem.Create(Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  LibModem.Free;
  MyModems.Free;
end;

procedure TForm1.btnLoadModemcapClick(Sender: TObject);
var
  I : Integer;
begin
  Screen.Cursor := crHourglass;
  LibModem.LibModemPath := Edit1.Text;
  ModemColl := LibModem.GetModemRecords;
  lbxManufacturers.Items.Clear;
  for I := 0 to pred(ModemColl.Count) do begin
    if lbxManufacturers.Items.IndexOf(ModemColl[I].Manufacturer) = -1 then
      lbxManufacturers.Items.Add(ModemColl[I].Manufacturer);
  end;
  Screen.Cursor := crDefault;
end;

procedure TForm1.btnLoadModemFileClick(Sender: TObject);
begin
  lbxModemFile.Items.Clear;
  MyModems.LibModemPath := ExtractFilePath(Edit2.Text);
  lbxModemFile.Items.Assign(MyModems.GetModems(ExtractFileName(Edit2.Text)));
end;

procedure TForm1.btnSaveModemFileClick(Sender: TObject);
begin
  MyModems.LibModemPath := ExtractFilePath(Edit2.Text);
  MyModems.CreateNewDetailFile(ExtractFileName(Edit2.Text));
end;

procedure TForm1.lbxManufacturersClick(Sender: TObject);
  { displays all modems from the selected manufacturer }
var
  I : Integer;
begin
  if lbxManufacturers.ItemIndex > -1 then begin
    lbxModels.Items.Clear;
    for I := 0 to pred(ModemColl.Count) do
      if ModemColl[I].Manufacturer = lbxManufacturers.Items[lbxManufacturers.ItemIndex] then
        lbxModels.Items.Add(ModemColl[I].ModemName);
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
 { moves a modem into our custom modem file }
var
  SourceDetailFile : string;
  ModemName : string;
  I : Integer;
  LmModem : TLmModem;
begin
  MyModems.LibModemPath := ExtractFilePath(Edit2.Text);
  if lbxModels.ItemIndex > -1 then begin
    I := 0;
    ModemName := lbxModels.Items[lbxModels.ItemIndex];
    while (ModemColl[I].ModemName <> ModemName) and (I < ModemColl.Count) do
      inc(I);
    if I >= ModemColl.Count then begin
      ShowMessage(ModemName + ' not found');
      Exit;
    end;
    SourceDetailFile := ModemColl[I].ModemFile;
    LibModem.GetModem(SourceDetailFile, ModemName, LmModem);
    MyModems.AddModem(ExtractFileName(Edit2.Text), LmModem);
    btnLoadModemFileClick(nil);
  end;
end;

procedure TForm1.lbxModelsDblClick(Sender: TObject);
var
  LmModem : TLmModem;
  ModemName : string;
  SourceDetailFile : string;
  I : Integer;
begin
  if lbxModels.ItemIndex > -1 then begin
    ModemName := lbxModels.Items[lbxModels.ItemIndex];
    for I := 0 to pred(ModemColl.Count) do
      if ModemColl[I].ModemName = ModemName then begin
        SourceDetailFile := ModemColl[I].ModemFile;
        Break;
      end;
    LibModem.GetModem(SourceDetailFile, ModemName, LmModem);
    LibModem.AddModem('mymodems.xml', LmModem);
  end;
end;

end.
