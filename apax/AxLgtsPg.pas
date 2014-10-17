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
{*                       AXLGTSPG.PAS 1.13                        *}
{******************************************************************}
{* AxlgtsPg.PAS - Status lights property page editor              *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxLgtsPg;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, StdCtrls,
  ExtCtrls, Forms, ComServ, ComObj, StdVcl, AxCtrls, Mask, Buttons, Dialogs,
  ComCtrls;

type
  TApxLightsPage = class(TPropertyPage)
    ColorDialog1: TColorDialog;
    chkShowTerminalButtons: TCheckBox;
    chkShowDeviceSelButton: TCheckBox;
    chkShowConnectButtons: TCheckBox;
    chkShowProtocolButtons: TCheckBox;
    chkShowToolBar: TCheckBox;
    btnNotLitColor: TSpeedButton;
    pnlLightsNotLitColor: TPanel;
    btnLitColor: TSpeedButton;
    pnlLightsLitColor: TPanel;
    Label5: TLabel;
    edtLightWidth: TMaskEdit;
    UpDown2: TUpDown;
    chkShowLightCaptions: TCheckBox;
    chkShowLights: TCheckBox;
    Label1: TLabel;
    edtCaption: TEdit;
    cbxCaptionAlignment: TComboBox;
    Label2: TLabel;
    Label4: TLabel;
    edtCaptionWidth: TMaskEdit;
    UpDown1: TUpDown;
    chkShowStatusBar: TCheckBox;
    Bevel1: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label8: TLabel;
    procedure btnLitColorClick(Sender: TObject);
    procedure btnNotLitColorClick(Sender: TObject);
    procedure chkShowStatusBarClick(Sender: TObject);
    procedure chkShowToolBarClick(Sender: TObject);
    procedure chkShowLightsClick(Sender: TObject);
    procedure chkShowProtocolButtonsClick(Sender: TObject);
    procedure edtCaptionChange(Sender: TObject);
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
  Class_ApxLightsPage: TGUID = '{80BC8536-0918-4E82-BD47-9785D2870C4F}';


implementation

{$R *.DFM}

{== TApxLightsPage =======================================================}
procedure TApxLightsPage.UpdatePropertyPage;
var
  I : Integer;
begin
  try
    { status bar }
    edtCaption.Text               := OleObject.Caption;
    cbxCaptionAlignment.ItemIndex := OleObject.CaptionAlignment;
    UpDown1.Position := OleObject.CaptionWidth;
    {edtCaptionWidth.Text          := IntToStr(OleObject.CaptionWidth);}

    UpDown2.Position := OleObject.LightWidth;
    edtLightWidth.Text            := IntToStr(OleObject.LightWidth);
    pnlLightsLitColor.Color       := OleObject.LightsLitColor;
    pnlLightsNotLitColor.Color    := OleObject.LightsNotLitColor;
    chkShowLightCaptions.Checked  := OleObject.ShowLightCaptions;
    chkShowLights.Checked         := OleObject.ShowLights;
    chkShowStatusBar.Checked      := OleObject.ShowStatusBar;

    { tool bar }
    chkShowToolBar.Checked         := OleObject.ShowToolBar;
    chkShowDeviceSelButton.Checked := OleObject.ShowDeviceSelButton;
    chkShowConnectButtons.Checked  := OleObject.ShowConnectButtons;
    chkShowProtocolButtons.Checked := OleObject.ShowProtocolButtons;
    chkShowTerminalButtons.Checked := OleObject.ShowTerminalButtons;

    { enable/disable edit controls }
    for I := 0 to pred(ControlCount) do begin
      case Controls[I].Tag of
        1 : Controls[I].Enabled := chkShowStatusBar.Checked;
        2 : Controls[I].Enabled := chkShowLights.Checked;
        3 : Controls[I].Enabled := chkShowToolBar.Checked;
      end;
    end;
    chkShowStatusBar.Enabled := True;
    chkShowLights.Enabled := True;
    chkShowToolBar.Enabled := True;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxLightsPage.UpdateObject;
begin
  try
    { status bar }
    OleObject.Caption           := edtCaption.Text;
    OleObject.CaptionAlignment  := cbxCaptionAlignment.ItemIndex;
    OleObject.CaptionWidth      := StrToIntDef(edtCaptionWidth.Text, 100);
    OleObject.LightWidth        := StrToIntDef(edtLightWidth.Text, 40);
    OleObject.LightsLitColor    := pnlLightsLitColor.Color;
    OleObject.LightsNotLitColor := pnlLightsNotLitColor.Color;
    OleObject.ShowLightCaptions := chkShowLightCaptions.Checked;
    OleObject.ShowLights        := chkShowLights.Checked;
    OleObject.ShowStatusBar     := chkShowStatusBar.Checked;

    { tool bar }
    OleObject.ShowToolBar         := chkShowToolBar.Checked;
    OleObject.ShowDeviceSelButton := chkShowDeviceSelButton.Checked;
    OleObject.ShowConnectButtons  := chkShowConnectButtons.Checked;
    OleObject.ShowProtocolButtons := chkShowProtocolButtons.Checked;
    OleObject.ShowTerminalButtons := chkShowTerminalButtons.Checked;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxLightsPage.btnLitColorClick(Sender: TObject);
begin
  try
    ColorDialog1.Color := pnlLightsLitColor.Color;
    if ColorDialog1.Execute then begin
      pnlLightsLitColor.Color := ColorDialog1.Color;
      Modified;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxLightsPage.btnNotLitColorClick(Sender: TObject);
begin
  try
    ColorDialog1.Color := pnlLightsNotLitColor.Color;
    if ColorDialog1.Execute then begin
      pnlLightsNotLitColor.Color := ColorDialog1.Color;
      Modified;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }

procedure TApxLightsPage.chkShowStatusBarClick(Sender: TObject);
begin
  Modified;
end;

procedure TApxLightsPage.chkShowToolBarClick(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to pred(ControlCount) do begin
   if Controls[I].Tag = TCheckBox(Sender).Tag then
    Controls[I].Enabled := TCheckBox(Sender).Checked;
  end;
  chkShowStatusBar.Enabled := True;
  chkShowLights.Enabled := True;
  chkShowToolBar.Enabled := True;
  Modified;
end;

procedure TApxLightsPage.chkShowLightsClick(Sender: TObject);
begin
  Modified;
end;

procedure TApxLightsPage.chkShowProtocolButtonsClick(Sender: TObject);
begin
  Modified;
end;

procedure TApxLightsPage.edtCaptionChange(Sender: TObject);
begin
  Modified;
end;

initialization
  TActiveXPropertyPageFactory.Create(
    ComServer,
    TApxLightsPage,
    Class_ApxLightsPage);
end.
