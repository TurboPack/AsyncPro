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
{*                   ADMDMCFG.PAS 5.00                   *}
{*********************************************************}
{* Modem config dialog for the TAdModem component        *}
{*********************************************************}  

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdMdmCfg;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  AdLibMdm,
  AdMdm,
  AdPort;


type
  TApdModemConfigDialog = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lblModemName: TLabel;
    lblModemModel: TLabel;
    lblModemManufacturer: TLabel;
    lblAttachedTo: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    rgpDataBits: TRadioGroup;
    rgpParity: TRadioGroup;
    rgpStopBits: TRadioGroup;
    cbxNotBlindDial: TCheckBox;
    cbxEnableCallFailTimer: TCheckBox;
    edtCallSetupFailTimer: TEdit;
    Label5: TLabel;
    cbxEnableIdleTimeout: TCheckBox;
    Label7: TLabel;
    GroupBox3: TGroupBox;
    rbFlowNone: TRadioButton;
    rbFlowHard: TRadioButton;
    rbFlowSoft: TRadioButton;
    rgpErrorCorrection: TGroupBox;
    cbxDataCompress: TCheckBox;
    GroupBox5: TGroupBox;
    rbModCCITT: TRadioButton;
    cbxCellular: TCheckBox;
    rbModCCITTV23: TRadioButton;
    rbModBell: TRadioButton;
    edtExtraSettings: TEdit;
    Label4: TLabel;
    cbxUseErrorCorrection: TCheckBox;
    cbxRequireCorrection: TCheckBox;
    edtInactivityTimer: TEdit;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    tbSpeakerVolume: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    rbSpeakerConnect: TRadioButton;
    rbSpeakerOn: TRadioButton;
    rbSpeakerOff: TRadioButton;
  private
    FLmModem: TLmModem;
    function GetModemConfig: TApdModemConfig;
    procedure SetLmModem(const Value: TLmModem);
    procedure SetModemConfig(const Value: TApdModemConfig);
    { Private declarations }
  public
    { Public declarations }
    property LmModem : TLmModem
      read FLmModem write SetLmModem;
    property ModemConfig : TApdModemConfig
      read GetModemConfig write SetModemConfig;
  end;

implementation

{$R *.dfm}

{ TApxModemConfigDialog }

function TApdModemConfigDialog.GetModemConfig: TApdModemConfig;
begin
  { General tab }
  if tbSpeakerVolume.Position = 0 then
    Result.SpeakerMode := smOff;
  Result.SpeakerVolume := TApdModemSpeakerVolume(tbSpeakerVolume.Position);

  { Connection tab }
  Result.DataBits := rgpDataBits.ItemIndex;
  Result.Parity := TParity(rgpParity.ItemIndex);
  Result.StopBits := rgpStopBits.ItemIndex;

  Result.BlindDial := not(cbxNotBlindDial.Checked);
  if cbxEnableCallFailTimer.Checked then
    Result.CallSetupFailTimeout := StrToInt(edtCallSetupFailTimer.Text)
  else
    Result.CallSetupFailTimeout := 0;
  if cbxEnableIdleTimeout.Checked then
    Result.InactivityTimeout := StrToInt(edtInactivityTimer.Text);

  { Advanced tab }

  Result.ErrorControl := [];
  if cbxUseErrorCorrection.Checked then
    Result.ErrorControl := Result.ErrorControl + [ecOn];
  if cbxRequireCorrection.Checked then
    Result.ErrorControl := Result.ErrorControl + [ecForced];
  if cbxCellular.Checked then
    Result.ErrorControl := Result.ErrorControl + [ecCellular];
  Result.Compression := cbxDataCompress.Checked;

  if rbModBell.Checked then
    Result.Modulation := smBell
  else if rbModCCITTV23.Checked then
    Result.Modulation := smCCITT_V23
  else
    Result.Modulation := smCCITT;

  Result.ExtraSettings := ShortString(edtExtraSettings.Text);
end;

procedure TApdModemConfigDialog.SetLmModem(const Value: TLmModem);
  { enable/disable controls based on .SupportsXxx fields }
begin

  with Value do begin
    Caption := LmModem.FriendlyName;
    {SupportsWaitForBongTone -- huh?}
    {SupportsWaitForQuiet -- again, huh? }

    cbxNotBlindDial.Enabled := SupportsWaitForDialTone;
    { not quite sure what how to disble the track bar intuitively
    SupportsSpeakerVolumeLow
    SupportsSpeakerVolumeMed
    SupportsSpeakerVolumeHigh
    SupportsSpeakerModeOff
    SupportsSpeakerModeOn
    SupportsSpeakerModeSetup}
    cbxDataCompress.Enabled := SupportsSetDataCompressionNegot;
    rgpErrorCorrection.Enabled := SupportsSetErrorControlProtNegot;
    cbxRequireCorrection.Enabled := SupportsSetForcedErrorControl;
    cbxCellular.Enabled := SupportsSetCellular;
    rbFlowHard.Enabled := SupportsSetHardwareFlowControl;
    rbFlowSoft.Enabled := SupportsSetSoftwareFlowControl;
    rbModBell.Enabled := SupportsCCITTBellToggle;
    {SupportsSetSpeedNegotiation; -- not supported }
    {SupportsSetTonePulse; -- shouldn't this be in the dialing properties? }
    {SupportsBlindDial; -- seems to be a duplicate of SupportsWaitForDialtone}
    rbModCCITTV23.Enabled := SupportsSetV21V23;
  end;
end;

procedure TApdModemConfigDialog.SetModemConfig(
  const Value: TApdModemConfig);
begin
  Caption := string(Value.ModemName);
  { General tab }
  lblModemName.Caption := 'Modem name: ' + string(Value.ModemName);
  lblModemModel.Caption := 'Modem model: ' + string(Value.ModemModel);
  lblModemManufacturer.Caption := 'Manufacturer: ' + string(Value.Manufacturer);
  lblAttachedTo.Caption := 'Attached to: ' + string(Value.AttachedTo);

  case Value.SpeakerMode of
    smOff  : rbSpeakerOff.Checked := True;
    smOn   : rbSpeakerOn.Checked := True;
    smDial : rbSpeakerConnect.Checked := True;
  end;

  tbSpeakerVolume.Position := ord(Value.SpeakerVolume);

  { Connection tab }
  rgpDataBits.ItemIndex := ord(Value.DataBits);
  rgpParity.ItemIndex := ord(Value.Parity);
  rgpStopBits.ItemIndex := ord(Value.StopBits);

  cbxNotBlindDial.Checked := not(Value.BlindDial);
  cbxEnableCallFailTimer.Checked := Value.CallSetupFailTimeout > 0;
  edtCallSetupFailTimer.Text := IntToStr(Value.CallSetupFailTimeout);
  cbxEnableIdleTimeout.Checked := Value.InactivityTimeout > 0;
  edtInactivityTimer.Text := IntToStr(Value.InactivityTimeout);

  { Advanced tab }
  
  cbxUseErrorCorrection.Checked := ecOn in Value.ErrorControl;
  cbxRequireCorrection.Checked := ecForced in Value.ErrorControl;
  cbxCellular.Checked := ecCellular in Value.ErrorControl;
  cbxDataCompress.Checked := Value.Compression;

  case Value.Modulation of
    smBell      : rbModBell.Checked := True;
    smCCITT     : rbModCCITT.Checked := True;
    smCCITT_V23 : rbModCCITTV23.Checked := True;
  end;

  edtExtraSettings.Text := string(Value.ExtraSettings);
end;

end.
