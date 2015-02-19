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
 *   Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADXPORT.PAS 4.06                    *}
{*********************************************************}
{* Port configuration dialog                             *}
{*********************************************************}

{
  See the TermDemo example for how to use this dialog.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdXPort;

interface

uses
  Windows,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  AdPort,
  AdTapi,
  AdTSel;

type
  TComPortOptions = class(TForm)
    FlowControlBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    DTRRTS: TCheckBox;
    RTSCTS: TCheckBox;
    SoftwareXmit: TCheckBox;
    SoftwareRcv: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Bauds: TRadioGroup;
    Paritys: TRadioGroup;
    Databits: TRadioGroup;
    Stopbits: TRadioGroup;
    Comports: TGroupBox;
    OK: TButton;
    Cancel: TButton;
    PortComboBox: TComboBox;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure PortComboBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    FShowTapiDevices : Boolean;
    FShowPorts       : Boolean;                                   
    FComPort   : TApdComPort;
    FTapiDevice: string;
    Executed   : Boolean;

  protected
    function GetComPort : TApdComPort;
    procedure SetComPort(NewPort : TApdComPort);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;

    property ComPort : TApdComPort
      read GetComPort write SetComPort;
    property TapiDevice : string
      read FTapiDevice write FTapiDevice;
    property ShowTapiDevices : Boolean
      read FShowTapiDevices write FShowTapiDevices;
    property ShowPorts : Boolean
      read FShowPorts write FShowPorts;                          
  end;

var
  ComPortOptions: TComPortOptions;

implementation

{$R *.DFM}

const
  BaudValues : array[0..9] of Word =
    (30, 60, 120, 240, 480, 960, 1920, 3840, 5760, 11520);

constructor TComPortOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComPort := TApdComPort.Create(Self);
  Executed := False;
  FShowTapiDevices := False;
  FShowPorts       := True;
end;

destructor TComPortOptions.Destroy;
begin
  FComPort.Free;
  inherited Destroy;
end;

function TComPortOptions.Execute: Boolean;
var
  I : Word;
  CheckBaud : Word;
  E : TDeviceSelectionForm;
begin
  {Update dialog controls}
  Bauds.ItemIndex := 6;
  CheckBaud := FComPort.Baud div 10;
  for I := 0 to 9 do
    if CheckBaud = BaudValues[I] then begin
      Bauds.ItemIndex := I;
      break;
    end;
  Paritys.ItemIndex := Ord(FComPort.Parity);
  Databits.ItemIndex := 8-FComPort.Databits;
  Stopbits.ItemIndex := Pred(FComPort.Stopbits);

  {Hardware flow}
  DTRRTS.Checked := hwfUseDTR in FComPort.HWFlowOptions;
  RTSCTS.Checked := hwfUseRTS in FComPort.HWFlowOptions;

  {Software flow}
  SoftwareXmit.Checked := (FComPort.SWFlowOptions = swfBoth) or
                          (FComPort.SWFlowOptions = swfTransmit);
  SoftwareRcv.Checked := (FComPort.SWFlowOptions = swfBoth) or
                         (FComPort.SWFlowOptions  = swfReceive);
  Edit1.Text := IntToStr(Ord(FComPort.XOnChar));
  Edit2.Text := IntToStr(Ord(FComPort.XOffChar));

  {Gather all tapi devices and ports}
  E := TDeviceSelectionForm.Create(Self);
  try
		E.ShowTapiDevices := ShowTapiDevices;
    E.ShowPorts       := ShowPorts;
    E.EnumAllPorts;
    PortComboBox.Items := E.PortItemList;
  finally;
    E.Free;
  end;

  ShowModal;
  Result := ModalResult = mrOK;
  Executed := Result;
end;

function TComPortOptions.GetComPort : TApdComPort;
var
  HWOpts : THWFlowOptionSet;
  SWOpts : TSWFlowOptions;
  Temp   : Integer;
  Code   : Integer;
begin
  if Executed then begin
    {Update ComPort from dialog controls}
    FComPort.Baud := Integer(BaudValues[Bauds.ItemIndex]) * 10;
    FComPort.Parity := TParity(Paritys.ItemIndex);
    FComPort.Databits := 8-Databits.ItemIndex;
    FComPort.Stopbits := Succ(Stopbits.ItemIndex);

    {Update HW flow}
    HWOpts := [];
    if DTRRTS.Checked then
      HWOpts := [hwfUseDTR, hwfRequireDSR];
    if RTSCTS.Checked then begin
      Include(HWOpts, hwfUseRTS);
      Include(HWOpts, hwfRequireCTS);
    end;
    FComPort.HWFlowOptions := HWOpts;

    {Update SW flow}
    if SoftwareXmit.Checked then
      if SoftwareRcv.Checked then
        SWOpts := swfBoth
      else
        SWOpts := swfTransmit
    else if SoftwareRcv.Checked then
      SWOpts := swfReceive
    else
      SWOpts := swfNone;
    FComPort.SWFlowOptions := SWOpts;

    Val(Edit1.Text, Temp, Code);
    if Code = 0 then
      FComPort.XOnChar := AnsiChar(Temp);
    Val(Edit2.Text, Temp, Code);
    if Code = 0 then
      FComPort.XOffChar := AnsiChar(Temp);
  end;
  Result := FComPort;
end;

procedure TComPortOptions.SetComPort(NewPort : TApdComPort);
begin
  if (NewPort <> FComPort) then
    FComPort.Assign(NewPort);
end;

procedure TComPortOptions.OKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TComPortOptions.CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TComPortOptions.PortComboBoxChange(Sender: TObject);
var
  DeviceName : string;
begin
  DeviceName := PortComboBox.Items[PortComboBox.ItemIndex];
  if Pos(DirectTo, DeviceName) > 0 then begin
    ComPort.TapiMode := tmOff;
    ComPort.ComNumber := StrToInt(Copy(DeviceName, Length(DirectTo)+1, Length(DeviceName)));
  end else begin
    ComPort.TapiMode := tmAuto;
    ComPort.ComNumber := 0;
    TapiDevice := DeviceName;
  end;
end;

procedure TComPortOptions.FormShow(Sender: TObject);
begin
 { Highlite the active device in the list }
  with PortComboBox do
    if Assigned(FComPort) and (ComPort.TapiMode = tmOff) then begin
      ItemIndex := Items.IndexOf(DirectTo+IntToStr(ComPort.ComNumber));
    end else begin
      ItemIndex := Items.IndexOf(TapiDevice);
    end;
end;

end.
