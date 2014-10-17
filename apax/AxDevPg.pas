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
{*                        AXDEVPG.PAS 1.13                        *}
{******************************************************************}
{* AxDevPg.PAS - Device configuration property page editor        *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxDevPg;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, StdCtrls,
  ExtCtrls, Forms, ComServ, ComObj, StdVcl, AxCtrls, Mask, Buttons, dialogs,
  ComCtrls;

type
  TApxDevicePage = class(TPropertyPage)
    Label3: TLabel;
    edtAnswerOnRing: TEdit;
    UpDown3: TUpDown;
    Label6: TLabel;
    edtTapiRetryWait: TEdit;
    UpDown2: TUpDown;
    Label1: TLabel;
    edtMaxAttempts: TEdit;
    UpDown1: TUpDown;
    btnConfigure: TButton;
    btnSelectedDevice: TButton;
    edtSelectedDevice: TEdit;
    Label2: TLabel;
    chkEnableVoice: TCheckBox;
    rbTapi: TRadioButton;
    pnlWinsock: TPanel;
    rbtnWsClient: TRadioButton;
    rbtnWsServer: TRadioButton;
    Label5: TLabel;
    edtWinsockPort: TEdit;
    edtWinsockAddress: TEdit;
    Label4: TLabel;
    rbWinsock: TRadioButton;
    btnLineSettings: TButton;
    Label10: TLabel;
    cbxComNumber: TComboBox;
    chkPromptForPort: TCheckBox;
    rbDirect: TRadioButton;
    Label7: TLabel;
    Bevel3: TBevel;
    Label8: TLabel;
    Bevel4: TBevel;
    Label9: TLabel;
    Bevel5: TBevel;
    chkFilterTapiDevices: TCheckBox;
    procedure btnLineSettingsClick(Sender: TObject);
    procedure btnSelectedDeviceClick(Sender: TObject);
    procedure edtWinsockAddressChange(Sender: TObject);
    procedure rbtnWsServerClick(Sender: TObject);
    procedure rbDirectClick(Sender: TObject);
    procedure chkFilterTapiDevicesClick(Sender: TObject);
  private
  public
    procedure UpdatePropertyPage; override;
    procedure UpdateObject; override;
  end;

const
  Class_ApxDevicePage : TGUID = '{FCA5D372-5F47-4CA3-8D02-C3F29A541B6B}';


implementation

uses                                
  AdPort, AxLineDg, AxTerm, AdSocket, AdSelCom;

{$R *.DFM}

(*var
  { direct - line settings }
  Baud               : Integer;
  DataBits           : Integer;
  ComNumber          : Integer;
  HWFlowUseDTR       : WordBool;
  HWFlowUseRTS       : WordBool;
  HWFlowRequireDSR   : WordBool;
  HWFlowRequireCTS   : WordBool;
  Parity             : TParity;
  PromptForPort      : WordBool;
  StopBits           : Integer;
  SWFlowOptions      : TSWFlowOptions;
  XOffChar           : Integer;
  XOnChar            : Integer;                       *)


{== TApxDevicePage =======================================================}
procedure TApxDevicePage.UpdatePropertyPage;
var
  I : Integer;
begin
  try
    for I := 1 to 50 do begin
      if IsPortAvailable(I) then
        cbxComNumber.Items.Add(IntToStr(I));
    end;

    { direct - line settings }
    chkPromptForPort.Checked   := OleObject.PromptForPort;
    cbxComNumber.Text          := IntToStr(OleObject.ComNumber);
{    Baud                       := OleObject.Baud;
    ComNumber                  := OleObject.ComNumber;
    DataBits                   := OleObject.Databits;
    StopBits                   := OleObject.StopBits;
    Parity                     := OleObject.Parity;
    PromptForPort              := OleObject.PromptForPort;
    HWFlowUseDTR               := OleObject.HWFlowUseDTR;
    HWFlowUseRTS               := OleObject.HWFlowUseRTS;
    HWFlowRequireDSR           := OleObject.HWFlowRequireDSR;
    HWFlowRequireCTS           := OleObject.HWFlowRequireCTS;
    SWFlowOptions              := OleObject.SWFlowOptions;
    XOnChar                    := OleObject.XOnChar;
    XOffChar                   := OleObject.XOffChar;}

    { winsock }
    edtWinsockAddress.Text     := OleObject.WinsockAddress;
    edtWinsockPort.Text        := OleObject.WinsockPort;
    rbtnWsClient.Checked       := OleObject.WinsockMode = wsClient;
    rbtnWsServer.Checked       := OleObject.WinsockMode = wsServer;

    { tapi }
    chkEnableVoice.Checked       := OleObject.EnableVoice;
    chkFilterTapiDevices.Checked := OleObject.FilterTapiDevices;
    edtSelectedDevice.Text       := OleObject.SelectedDevice;
    UpDown1.Position := OleObject.MaxAttempts;
    UpDown2.Position := OleObject.TapiRetryWait;
    UpDown3.Position := OleObject.AnswerOnRing;
{    edtMaxAttempts.Text        := OleObject.MaxAttempts;
    edtTapiRetryWait.Text      := OleObject.TapiRetryWait;
    edtAnswerOnRing.Text       := OleObject.AnswerOnRing;}
        case OleObject.DeviceType of
      ord(dtDirect)  : rbDirect.Checked := True;
      ord(dtWinsock) : rbWinsock.Checked := True;
      ord(dtTapi)    : rbTapi.Checked := True;
    end;
    for I := 0 to pred(ControlCount) do begin
      Controls[I].Enabled := Controls[I].Tag = Ord(TApxDeviceType(OleObject.DeviceType)) + 1;
    end;
    rbDirect.Enabled := True;
    rbWinsock.Enabled := True;
    rbTapi.Enabled := True;
    if (Ord(TApxDeviceType(OleObject.DeviceType)) + 1) <> 2 then begin
      rbtnWsClient.Font.Color := clInactiveCaption;
      rbtnWsServer.Font.Color := clInactiveCaption;
    end else begin
      rbtnWsClient.Font.Color := clWindowText;
      rbtnWsServer.Font.Color := clWindowText;
    end;

  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxDevicePage.UpdateObject;
begin
  try
    if rbDirect.Checked then
      OleObject.DeviceType := dtDirect
    else if rbWinsock.Checked then
      OleObject.DeviceType := dtWinsock
    else
      OleObject.DeviceType := dtTapi;
    { direct - line settings }
    OleObject.PromptForPort    := chkPromptForPort.Checked;
    OleObject.ComNumber        := StrToIntDef(cbxComNumber.Text, 0);
    (*OleObject.Baud             := Baud;
    OleObject.ComNumber        := ComNumber;
    OleObject.Databits         := DataBits;
    OleObject.StopBits         := StopBits;
    OleObject.Parity           := Parity;
    OleObject.PromptForPort    := PromptForPort;
    OleObject.HWFlowUseDTR     := HWFlowUseDTR ;
    OleObject.HWFlowUseRTS     := HWFlowUseRTS;
    OleObject.HWFlowRequireDSR := HWFlowRequireDSR;
    OleObject.HWFlowRequireCTS := HWFlowRequireCTS;
    OleObject.SWFlowOptions    := SWFlowOptions;
    OleObject.XOnChar          := XOnChar;
    OleObject.XOffChar         := XOffChar;*)

    { tapi }
    OleObject.EnableVoice       := chkEnableVoice.Checked;
    OleObject.FilterTapiDevices := chkFilterTapiDevices.Checked;
    OleObject.MaxAttempts       := StrToIntDef(edtMaxAttempts.Text, 3);
    OleObject.TapiRetryWait     := StrToIntDef(edtTapiRetryWait.Text, 60);
    OleObject.AnswerOnRing      := StrToIntDef(edtAnswerOnRing.Text, 2);
    OleObject.SelectedDevice    := edtSelectedDevice.Text;

    { winsock }
    if rbtnWsClient.Checked then
      OleObject.WinsockMode    := wsClient
    else
      OleObject.WinsockMode    := wsServer;
    OleObject.WinsockAddress   := edtWinsockAddress.Text;
    OleObject.WinsockPort      := edtWinsockPort.Text;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxDevicePage.btnLineSettingsClick(Sender: TObject);
var
  LineDlg : TApxLineDlg;
begin
  try
    LineDlg := TApxLineDlg.Create(Self);
    try
      LineDlg.Baud             := OleObject.Baud;
      LineDlg.ComNumber        := OleObject.ComNumber;
      LineDlg.Databits         := OleObject.DataBits;
      LineDlg.StopBits         := OleObject.StopBits;
      LineDlg.Parity           := OleObject.Parity;
      LineDlg.PromptForPort    := OleObject.PromptForPort;
      LineDlg.HWFlowUseDTR     := OleObject.HWFlowUseDTR ;
      LineDlg.HWFlowUseRTS     := OleObject.HWFlowUseRTS;
      LineDlg.HWFlowRequireDSR := OleObject.HWFlowRequireDSR;
      LineDlg.HWFlowRequireCTS := OleObject.HWFlowRequireCTS;
      LineDlg.SWFlowOptions    := OleObject.SWFlowOptions;
      LineDlg.XOnChar          := OleObject.XOnChar;
      LineDlg.XOffChar         := OleObject.XOffChar;
      if (LineDlg.ShowModal = mrOk) then begin
        OleObject.Baud             := LineDlg.Baud;
        OleObject.ComNumber        := LineDlg.ComNumber;
        OleObject.Databits         := LineDlg.DataBits;
        OleObject.StopBits         := LineDlg.StopBits;
        OleObject.Parity           := LineDlg.Parity;
        OleObject.PromptForPort    := LineDlg.PromptForPort;
        OleObject.HWFlowUseDTR     := LineDlg.HWFlowUseDTR ;
        OleObject.HWFlowUseRTS     := LineDlg.HWFlowUseRTS;
        OleObject.HWFlowRequireDSR := LineDlg.HWFlowRequireDSR;
        OleObject.HWFlowRequireCTS := LineDlg.HWFlowRequireCTS;
        OleObject.SWFlowOptions    := LineDlg.SWFlowOptions;
        OleObject.XOnChar          := LineDlg.XOnChar;
        OleObject.XOffChar         := LineDlg.XOffChar;
        Modified;
      end;
    finally
      LineDlg.Free;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxDevicePage.btnSelectedDeviceClick(Sender: TObject);
begin
  try
    if OleObject.TapiSelectDevice then begin
      edtSelectedDevice.Text := OleObject.SelectedDevice;
      btnConfigure.Enabled := True;
      Modified;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }

procedure TApxDevicePage.edtWinsockAddressChange(Sender: TObject);
begin
  Modified;
end;

procedure TApxDevicePage.rbtnWsServerClick(Sender: TObject);
begin
  Modified;
end;

procedure TApxDevicePage.rbDirectClick(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to pred(ControlCount) do begin
    Controls[I].Enabled := Controls[I].Tag = TRadioButton(Sender).Tag;
  end;
  rbDirect.Enabled := True;
  rbWinsock.Enabled := True;
  rbTapi.Enabled := True;
  if TRadioButton(Sender).Tag <> 2 then begin
    rbtnWsClient.Font.Color := clInactiveCaption;
    rbtnWsServer.Font.Color := clInactiveCaption;
  end else begin
    rbtnWsClient.Font.Color := clWindowText;
    rbtnWsServer.Font.Color := clWindowText;
  end;
  Modified;
end;

procedure TApxDevicePage.chkFilterTapiDevicesClick(Sender: TObject);
begin
  OleObject.FilterTapiDevices := chkFilterTapiDevices.Checked;
end;

initialization
  TActiveXPropertyPageFactory.Create(
    ComServer,
    TApxDevicePage,
    Class_ApxDevicePage);
end.
