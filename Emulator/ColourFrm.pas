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
 * The Original Code is LNS Software Systems
 *
 * The Initial Developer of the Original Code is LNS Software Systems
 *
 * Portions created by the Initial Developer are Copyright (C) 1998-2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)
unit ColourFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TColourForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    FgndCombo: TComboBox;
    BgndCombo: TComboBox;
    Sample: TPanel;
    SaveBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure FgndComboChange(Sender: TObject);
    procedure BgndComboChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  private
    FForeground   : String;
    FBackground   : String;
    FForeItem     : Integer;
    FBackItem     : Integer;
  public
    function  GetRGB(colour : Integer) : TColor;
    function  GetRGBString(colour : String) : TColor;
    property  Foreground : String read FForeground write FForeground;
    property  Background : String read FBackground write FBackground;
    property  ForeItem : Integer read FForeItem write FForeItem;
    property  BackItem : Integer read FBackItem write FBackItem;
  end;

var
  ColourForm: TColourForm;

implementation

{$R *.DFM}

function  TColourForm.GetRGB(colour : Integer) : TColor;
begin
    case colour of
      0:    Result := clBlack;
      1:    Result := clMaroon;
      2:    Result := clGreen;
      3:    Result := clOlive;
      4:    Result := clNavy;
      5:    Result := clPurple;
      6:    Result := clTeal;
      7:    Result := clGray;
      8:    Result := clSilver;
      9:    Result := clRed;
      10:   Result := clLime;
      11:   Result := clYellow;
      12:   Result := clBlue;
      13:   Result := clFuchsia;
      14:   Result := clAqua;
      15:   Result := clWhite;
      else  Result := clNone;
    end;
end;

function  TColourForm.GetRGBString(colour : String) : TColor;
var
   col    : Integer;

begin
    col := FgndCombo.Items.IndexOf(colour);
    Result := GetRGB(col);
end;

procedure TColourForm.FormShow(Sender: TObject);
begin
    FgndCombo.ItemIndex := FForeItem;
    BgndCombo.ItemIndex := FBackItem;
    if (FForeground <> '') then
        FgndCombo.ItemIndex := FgndCombo.Items.IndexOf(FForeground);
    if (FBackground <> '') then
        BgndCombo.ItemIndex := BgndCombo.Items.IndexOf(FBackground);
    if (FgndCombo.ItemIndex <> -1) then
        Sample.Font.Color := GetRGB(FgndCombo.ItemIndex);
    if (BgndCombo.ItemIndex <> -1) then
        Sample.Color := GetRGB(BgndCombo.ItemIndex);
end;

procedure TColourForm.FgndComboChange(Sender: TObject);
begin
    Sample.Font.Color := GetRGB(FgndCombo.ItemIndex);
end;

procedure TColourForm.BgndComboChange(Sender: TObject);
begin
    Sample.Color := GetRGB(BgndCombo.ItemIndex);
end;

procedure TColourForm.SaveBtnClick(Sender: TObject);
begin
    if (FgndCombo.ItemIndex = -1) then
        raise Exception.Create('This field must have a value.');
    FForeground := FgndCombo.Text;
    FForeItem := FgndCombo.ItemIndex;
    if (BgndCombo.ItemIndex = -1) then
        raise Exception.Create('This field must have a value.');
    FBackground := BgndCombo.Text;
    FBackItem := BgndCombo.ItemIndex;
    ModalResult := mrOk;
end;

end.
