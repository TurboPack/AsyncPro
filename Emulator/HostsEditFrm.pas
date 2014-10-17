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
unit HostsEditFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AdSelCom;

type
  THostsEditForm = class(TForm)
    HostNameLbl: TLabel;
    HostNameEdit: TEdit;
    IPAddressLbl: TLabel;
    IPAddressEdit: TEdit;
    TCPPortEdit: TEdit;
    SerialDevLbl: TLabel;
    TCPPortLbl: TLabel;
    SerialDevCombo: TComboBox;
    ConnectTypeBtn: TRadioGroup;
    SaveBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    BaudLbl: TLabel;
    BaudCombo: TComboBox;
    DataBitsLbl: TLabel;
    DataBitsCombo: TComboBox;
    ParityLbl: TLabel;
    ParityCombo: TComboBox;
    StopBitsLbl: TLabel;
    StopBitsCombo: TComboBox;
    PhoneLbl: TLabel;
    PhoneEdit: TEdit;
    procedure FormShow(Sender: TObject);
    procedure ConnectTypeBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    FAcdFlag     : Char;
    FHostName    : String;
    FIPAddress   : String;
    FTCPPort     : Integer;
    FSerialDevice: String;
    FBaud        : Integer;
    FDataBits    : Integer;
    FParity      : String;
    FStopBits    : Integer;
    FConnectType : Char;
    FPhone       : String;
  public
    property AcdFlag  : Char read FAcdFlag write FAcdFlag;
    property HostName : String read FHostName write FHostName;
    property IPAddress : String read FIPAddress write FIPAddress;
    property TCPPort : Integer read FTCPPort write FTCPPort;
    property SerialDevice : String read FSerialDevice write FSerialDevice;
    property ConnectType : Char read FConnectType write FConnectType;
    property Baud : Integer read FBaud write FBaud;
    property DataBits : Integer read FDataBits write FDataBits;
    property StopBits : Integer read FStopBits write FStopBits;
    property Parity : String read FParity write FParity;
    property Phone : String read FPhone write FPhone;
  end;

var
  HostsEditForm: THostsEditForm;

implementation

uses EmulatorFrm;

{$R *.DFM}

const
    MaxComPorts       = 8;
    DirectTo          = 'Direct to Com';

procedure THostsEditForm.FormShow(Sender: TObject);
var
    i       : Integer;

begin
    SerialDevCombo.Items.Clear;
    for i:=0 to (EmulatorForm.TapiDev.TapiDevices.Count-1) do
        SerialDevCombo.Items.Add(EmulatorForm.TapiDev.TapiDevices.Strings[i]);
    for i:=1 to MaxComPorts do
    begin
        if (IsPortAvailable(i)) then
            SerialDevCombo.Items.Add(DirectTo + IntToStr(i));
    end;

    case FAcdFlag of
      'A':
      begin
        Caption := 'New Host';
        HostNameEdit.Enabled := True;
        HostNameLbl.Enabled := True;
      end;
      'C':
      begin
        Caption := 'Edit Host';
        HostNameEdit.Enabled := False;
        HostNameLbl.Enabled := False;
      end;
    end;
    HostNameEdit.Text := FHostName;
    IPAddressEdit.Text := FIPAddress;
    TCPPortEdit.Text := IntToStr(FTCPPort);
    SerialDevCombo.ItemIndex := SerialDevCombo.Items.IndexOf(FSerialDevice);
    BaudCombo.ItemIndex := BaudCombo.Items.IndexOf(IntToStr(FBaud));
    DataBitsCombo.ItemIndex := DataBitsCombo.Items.IndexOf(IntToStr(FDataBits));
    ParityCombo.ItemIndex := ParityCombo.Items.IndexOf(FParity);
    StopBitsCombo.ItemIndex := StopBitsCombo.Items.IndexOf(IntToStr(FStopBits));
    case FConnectType of
      'T':    ConnectTypeBtn.ItemIndex := 0;
      'S':    ConnectTypeBtn.ItemIndex := 1;
      else    ConnectTypeBtn.ItemIndex := -1;
    end;
    PhoneEdit.Text := FPhone;
    ConnectTypeBtnClick(ConnectTypeBtn);
    if (HostNameEdit.Enabled) then
    begin
        ActiveControl := HostNameEdit;
    end else
    begin
        if (IPAddressEdit.Enabled) then
            ActiveControl := IPAddressEdit
        else
            ActiveControl := SerialDevCombo;
    end;
end;

procedure THostsEditForm.ConnectTypeBtnClick(Sender: TObject);
begin
    if (ConnectTypeBtn.ItemIndex = 0) then
    begin
        IPAddressEdit.Enabled := True;
        TCPPortEdit.Enabled := True;
        SerialDevCombo.Enabled := False;
        BaudCombo.Enabled := False;
        DataBitsCombo.Enabled := False;
        ParityCombo.Enabled := False;
        StopBitsCombo.Enabled := False;
        PhoneEdit.Enabled := False;
        IPAddressLbl.Enabled := True;
        TCPPortLbl.Enabled := True;
        SerialDevLbl.Enabled := False;
        BaudLbl.Enabled := False;
        DataBitsLbl.Enabled := False;
        ParityLbl.Enabled := False;
        StopBitsLbl.Enabled := False;
        PhoneLbl.Enabled := False;
        if ((TrimLeft(TrimRight(TCPPortEdit.Text)) = '') or
            (TrimLeft(TrimRight(TCPPortEdit.Text)) = '23')) then
                TCPPortEdit.Text := '23';
    end else
    begin
        IPAddressEdit.Enabled := False;
        TCPPortEdit.Enabled := False;
        SerialDevCombo.Enabled := True;
        BaudCombo.Enabled := True;
        DataBitsCombo.Enabled := True;
        ParityCombo.Enabled := True;
        StopBitsCombo.Enabled := True;
        PhoneEdit.Enabled := True;
        IPAddressLbl.Enabled := False;
        TCPPortLbl.Enabled := False;
        SerialDevLbl.Enabled := True;
        BaudLbl.Enabled := True;
        DataBitsLbl.Enabled := True;
        ParityLbl.Enabled := True;
        StopBitsLbl.Enabled := True;
        PhoneLbl.Enabled := True;
        TCPPortEdit.Text := '';
    end;
end;

procedure THostsEditForm.SaveBtnClick(Sender: TObject);
var
    stemp    : String;

begin
    FHostName := TrimLeft(TrimRight(HostNameEdit.Text));
    if (FHostName = '') then
    begin
        HostNameEdit.SetFocus;
        raise Exception.Create('This field must have a value.');
    end;
    if (ConnectTypeBtn.ItemIndex < 0) then
    begin
        ConnectTypeBtn.SetFocus;
        raise Exception.Create('You must select either Telnet or Serial as ' +
                               'the connection type.');
    end;
    if (ConnectTypeBtn.ItemIndex = 0) then
    begin
        ConnectType := 'T';
        FIPAddress := TrimLeft(TrimRight(IPAddressEdit.Text));
        if (FIPAddress = '') then
        begin
            IPAddressEdit.SetFocus;
            raise Exception.Create('This field must have a value.');
        end;
        stemp := TrimLeft(TrimRight(TCPPortEdit.Text));
        if (stemp = '') then
            FTCPPort := 0
        else
        begin
            try
                FTCPPort := StrToInt(stemp);
            except
                TCPPortEdit.SetFocus;
                raise Exception.Create('This field must be a valid integer.');
            end;
        end;
        FSerialDevice := '';
        FBaud := 0;
        FDataBits := 0;
        FParity := '';
        FStopBits := 0;
        FPhone := '';
    end else
    begin
        ConnectType := 'S';
        FIPAddress := '';
        FTCPPort := 0;
        FSerialDevice := TrimLeft(TrimRight(SerialDevCombo.Text));
        if (FSerialDevice = '') then
        begin
            SerialDevCombo.SetFocus;
            raise Exception.Create('This field must have a value.');
        end;
        case BaudCombo.ItemIndex of
          0:
            FBaud := 300;
          1:
            FBaud := 1200;
          2:
            FBaud := 2400;
          3:
            FBaud := 4800;
          4:
            FBaud := 9600;
          5:
            FBaud := 19200;
          6:
            FBaud := 38400;
          7:
            FBaud := 57600;
          8:
            FBaud := 115200;
          else
            BaudCombo.SetFocus;
            raise Exception.Create('This field must have a value.');
        end;
        case DataBitsCombo.ItemIndex of
          0:
            FDataBits := 7;
          1:
            FDataBits := 8;
          else
            DataBitsCombo.SetFocus;
            raise Exception.Create('This field must have a value.');
        end;
        case ParityCombo.ItemIndex of
          0:
            FParity := 'None';
          1:
            FParity := 'Odd';
          2:
            FParity := 'Even';
          3:
            FParity := 'Mark';
          4:
            FParity := 'Space';
          else
            ParityCombo.SetFocus;
            raise Exception.Create('This field must have a value.');
        end;
        case StopBitsCombo.ItemIndex of
          0:
            FStopBits := 1;
          1:
            FStopBits := 2;
          else
            StopBitsCombo.SetFocus;
            raise Exception.Create('This field must have a value.');
        end;
        FPhone := TrimLeft(TrimRight(PhoneEdit.Text));
    end;
    ModalResult := mrOk;
end;

procedure THostsEditForm.HelpBtnClick(Sender: TObject);
begin
    case FAcdFlag of
      'A':    Application.HelpContext(51);
      'C':    Application.HelpContext(52);
    end;
end;

end.
