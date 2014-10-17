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
{*                   FXSRVR0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}

{
  FxSrvr is an example project for the TApdFaxServer and TApdFaxServerManager
  components. The controls on the form are separated in different GroupBoxes so
  the components properties are kept together. The controls are described below:
  Status ListBox:
    Contains status information and notification tags.

  TApdFaxServerManger:
    Directory to monitor: The directory name where the TApdFaxServerManager will
      look for outbound fax jobs
    Paused: If checked, the TApdFaxServerManager will not provide a fax job when
      the TApdFaxServer queries for fax jobs

  TApdFaxServer:
    StationID: Contains the StationID property value
    FaxClass: determines which FaxClass to use
    Modem init string: contains any special init commands required by your modem
    Dial prefix: contains any prefix required for dialing from this modem
    Destination directory: the directory where received faxes will be saved
    Enhanced fonts: outbound faxe headers and text cover pages will use these fonts
    Monitor for incoming faxes: if checked, ApdFaxServer will automatically receive
      incoming faxes
    Print on receive: if checked, received faxes will be printed using the
      attached TApdFaxPrinter
    Query every XXX seconds: enter 0 to disable querying the TApdFaxServerManager
      for new outbound fax jobs.  Enter non-0 number and the TApdFaxServerManager
      will be queried for new jobs on the given interval.

    Device selection:
      The label will show which device is being used to fax
      The Select Device button enabled you to select which device to use.  Select
        the device by name to use TAPI, or by COMx to go direct to the port.
        
    Hint properties of all editable controls contains the component and property
    that the control relates to.

    To use, select the device to be used (with the 'Select device' button), enter
    the appropriate ApdFaxServer properties and 'Check' the Monitor for incoming
    faxes checkbox. You will get OnFaxServerStatus entries in the list box while
    waiting for faxes.  When faxes are received, they will be saved in the
    directory entered in the Destination directory control. To schedule and send
    faxes, use the FaxClient example project to create fax jobs and submit them
    for queing. 
}

{**********************************************************}

unit FxSrvr0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, AdFaxSrv, AdFax, AdTapi, OoMisc, AdPort, AdFaxPrn,
  AdFPStat, AdFStat, AdExcept, AdSelCom, AdTSel;

type
  TfrmFxSrv0 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtMonitorDir: TEdit;
    cbxPaused: TCheckBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    edtStationID: TEdit;
    rgpFaxClass: TRadioGroup;
    Label3: TLabel;
    edtDialPrefix: TEdit;
    Label4: TLabel;
    edtModemInit: TEdit;
    Label5: TLabel;
    edtQueryInterval: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edtDestinationDir: TEdit;
    cbxEnhFonts: TCheckBox;
    btnHeaderFont: TButton;
    btnCoverFont: TButton;
    cbxMonitor: TCheckBox;
    lbxStatus: TListBox;
    Label8: TLabel;
    cbxPrintOnReceive: TCheckBox;
    btnPrintSetup: TButton;
    GroupBox3: TGroupBox;
    lblDeviceName: TLabel;
    btnSelectDevice: TButton;
    GroupBox4: TGroupBox;
    btnClose: TButton;
    ApdComPort1: TApdComPort;
    FontDialog1: TFontDialog;
    ApdFaxServer1: TApdFaxServer;
    ApdFaxStatus1: TApdFaxStatus;
    ApdFaxLog1: TApdFaxLog;
    ApdFaxServerManager1: TApdFaxServerManager;
    ApdFaxPrinter1: TApdFaxPrinter;
    ApdFaxPrinterStatus1: TApdFaxPrinterStatus;
    ApdTapiDevice1: TApdTapiDevice;
    procedure rgpFaxClassClick(Sender: TObject);
    procedure edtStationIDExit(Sender: TObject);
    procedure edtDialPrefixExit(Sender: TObject);
    procedure edtModemInitExit(Sender: TObject);
    procedure edtQueryIntervalExit(Sender: TObject);
    procedure edtDestinationDirExit(Sender: TObject);
    procedure btnHeaderFontClick(Sender: TObject);
    procedure btnCoverFontClick(Sender: TObject);
    procedure cbxEnhFontsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApdFaxServer1FaxServerAccept(CP: TObject;
      var Accept: Boolean);
    procedure ApdFaxServer1FaxServerFatalError(CP: TObject;
      FaxMode: TFaxServerMode; ErrorCode, HangupCode: Integer);
    procedure ApdFaxServer1FaxServerFinish(CP: TObject;
      FaxMode: TFaxServerMode; ErrorCode: Integer);
    procedure ApdFaxServer1FaxServerLog(CP: TObject; LogCode: TFaxLogCode;
      ServerCode: TFaxServerLogCode);
    procedure ApdFaxServer1FaxServerPortOpenClose(CP: TObject;
      Opening: Boolean);
    procedure ApdFaxServer1FaxServerStatus(CP: TObject;
      FaxMode: TFaxServerMode; First, Last: Boolean; Status: Word);
    procedure btnPrintSetupClick(Sender: TObject);
    procedure cbxPrintOnReceiveClick(Sender: TObject);
    procedure btnSelectDeviceClick(Sender: TObject);
    procedure cbxMonitorClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cbxPausedClick(Sender: TObject);
    procedure edtMonitorDirExit(Sender: TObject);
    procedure ApdFaxServerManager1Queried(Mgr: TApdFaxServerManager;
      QueryFrom: TApdCustomFaxServer; const JobToSend: String);
  private
    { Private declarations }
    procedure Add(const S: String);
  public
    { Public declarations }
  end;

var
  frmFxSrv0: TfrmFxSrv0;

implementation

{$R *.DFM}

procedure TfrmFxSrv0.rgpFaxClassClick(Sender: TObject);
begin
  ApdFaxServer1.FaxClass := TFaxClass(rgpFaxClass.ItemIndex+1);
end;

procedure TfrmFxSrv0.edtStationIDExit(Sender: TObject);
begin
  ApdFaxServer1.StationID := edtStationID.Text;
end;

procedure TfrmFxSrv0.edtDialPrefixExit(Sender: TObject);
begin
  ApdFaxServer1.DialPrefix := edtDialPrefix.Text;
end;

procedure TfrmFxSrv0.edtModemInitExit(Sender: TObject);
begin
  ApdFaxServer1.ModemInit := edtModemInit.Text;
end;

procedure TfrmFxSrv0.edtQueryIntervalExit(Sender: TObject);
begin
  ApdFaxServer1.SendQueryInterval := StrToIntDef(edtQueryInterval.Text,
    ApdFaxServer1.SendQueryInterval);
  edtQueryInterval.Text := IntToStr(ApdFaxServer1.SendQueryInterval);
end;

procedure TfrmFxSrv0.edtDestinationDirExit(Sender: TObject);
begin
  ApdFaxServer1.DestinationDir := edtDestinationDir.Text;
  edtDestinationDir.Text := ApdFaxServer1.DestinationDir;
end;

procedure TfrmFxSrv0.btnHeaderFontClick(Sender: TObject);
begin
  FontDialog1.Font := ApdFaxServer1.EnhHeaderFont;
  if FontDialog1.Execute then
    ApdFaxServer1.EnhHeaderFont := FontDialog1.Font;
end;

procedure TfrmFxSrv0.btnCoverFontClick(Sender: TObject);
begin
  FontDialog1.Font := ApdFaxServer1.EnhFont;
  if FontDialog1.Execute then
    ApdFaxServer1.EnhFont := FontDialog1.Font;
end;

procedure TfrmFxSrv0.cbxEnhFontsClick(Sender: TObject);
begin
  ApdFaxServer1.EnhTextEnabled := cbxEnhFonts.Checked;
end;

procedure TfrmFxSrv0.FormCreate(Sender: TObject);
begin
  { set up initial values in controls }
  edtMonitorDir.Text := ApdFaxServerManager1.MonitorDir;
  cbxPaused.Checked := ApdFaxServerManager1.Paused;

  edtStationID.Text := ApdFaxServer1.StationID;
  if ApdFaxServer1.FaxClass = fcUnknown then
    ApdFaxServer1.FaxClass := fcDetect;
  rgpFaxClass.ItemIndex := Ord(ApdFaxServer1.FaxClass) - 1;
  edtModemInit.Text := ApdFaxServer1.ModemInit;
  edtDialPrefix.Text := ApdFaxServer1.DialPrefix;
  edtDestinationDir.Text := ApdFaxServer1.DestinationDir;
  cbxEnhFonts.Checked := ApdFaxServer1.EnhTextEnabled;
  cbxMonitor.Checked := ApdFaxServer1.Monitoring;
  cbxPrintOnReceive.Checked := ApdFaxServer1.PrintOnReceive;
  edtQueryInterval.Text := IntToStr(ApdFaxServer1.SendQueryInterval);

  if ApdComPort1.TapiMode = tmOn then begin
    if ApdTapiDevice1.SelectedDevice <> '' then
      lblDeviceName.Caption := 'Using TAPI device: ' + ApdTapiDevice1.SelectedDevice
    else
      lblDeviceName.Caption := 'Using TAPI device: <no device selected>';
  end else
    lblDeviceName.Caption := 'Using modem on ' + ComName(ApdComPort1.ComNumber);
end;

procedure TfrmFxSrv0.Add(const S: String);
begin
  if Assigned(lbxStatus) then begin
    lbxStatus.Items.Add(IntToStr(GetTickCount) + ': ' + S);
    if lbxStatus.Items.Count > 1 then
      lbxStatus.ItemIndex := lbxStatus.Items.Count - 1;
  end;
end;

procedure TfrmFxSrv0.ApdFaxServer1FaxServerAccept(CP: TObject;
  var Accept: Boolean);
begin
  Add('Accepting fax from: ' + ApdFaxServer1.RemoteID);
end;

procedure TfrmFxSrv0.ApdFaxServer1FaxServerFatalError(CP: TObject;
  FaxMode: TFaxServerMode; ErrorCode, HangupCode: Integer);
var
  S: String;
begin
  if FaxMode = fsmSend then
    S := 'sending'
  else
    S := 'receiving';
  Add('Fatal error occured while ' + S);
  Add('      ErrorCode = (' + IntToStr(ErrorCode) + ') ' + ErrorMsg(ErrorCode));
  Add('      HangupCode= ' + IntToStr(HangupCode));
end;

procedure TfrmFxSrv0.ApdFaxServer1FaxServerFinish(CP: TObject;
  FaxMode: TFaxServerMode; ErrorCode: Integer);
var
  S: String;
begin
  if FaxMode = fsmSend then
    S := 'sent'
  else
    S := 'received';
  if ErrorCode = ecOK then
    S := S + ' successfully'
  else
    S := S + ' with an error code of (' + IntToStr(ErrorCode) + ') ' +
      ErrorMsg(ErrorCode);
  Add('Fax ' + S);
  if (FaxMode = fsmReceive) and (ErrorCode = ecOK) then
    Add('Fax saved to ' + ApdFaxServer1.FaxFile);
end;

procedure TfrmFxSrv0.ApdFaxServer1FaxServerLog(CP: TObject;
  LogCode: TFaxLogCode; ServerCode: TFaxServerLogCode);
var
  S: String;
begin
  if TLogFaxCode(LogCode) = lfaxNone then
    case ServerCode of
      fslPollingEnabled     : S := 'Polling enabled every ' +
        IntToStr(ApdFaxServer1.SendQueryInterval) + ' seconds';
      fslPollingDisabled    : S := 'Polling disabled';
      fslMonitoringEnabled  : S := 'Monitoring for incoming faxes';
      fslMonitoringDisabled : S := 'Monitoring disabled';
      else S := '';
    end
  else
    case TLogFaxCode(LogCode) of
      lfaxTransmitStart : S := 'Transmit start';
      lfaxTransmitOk    : S := 'Transmit OK';
      lfaxTransmitFail  : S := 'Transmit failed';
      lfaxReceiveStart  : S := 'Receive start';
      lfaxReceiveOk     : S := 'Receive OK';
      lfaxReceiveSkip   : S := 'Receive skipped';
      lfaxReceiveFail   : S := 'Receive failed';
      else S := '';
    end;
  Add('Fax log: ' + S);      
end;

procedure TfrmFxSrv0.ApdFaxServer1FaxServerPortOpenClose(CP: TObject;
  Opening: Boolean);
begin
  if Opening then
    Add('Port is opened')
  else
    Add('Port is closed');
end;

procedure TfrmFxSrv0.ApdFaxServer1FaxServerStatus(CP: TObject;
  FaxMode: TFaxServerMode; First, Last: Boolean; Status: Word);
var
  S: String;
begin
  if FaxMode = fsmSend then
    S := 'Send'
  else
    S := 'Receive';
  Add('Fax status (' + S + '): ' + ApdFaxServer1.StatusMsg(Status));
end;

procedure TfrmFxSrv0.btnPrintSetupClick(Sender: TObject);
begin
  ApdFaxPrinter1.PrintSetup;
end;

procedure TfrmFxSrv0.cbxPrintOnReceiveClick(Sender: TObject);
begin
  ApdFaxServer1.PrintOnReceive := cbxPrintOnReceive.Checked;
end;

procedure TfrmFxSrv0.btnSelectDeviceClick(Sender: TObject);
begin
  {$IFDEF Win32}
  with TDeviceSelectionForm.Create(Self) do begin
    try
      ShowTapiDevices := True;
      ShowPorts := True;
      EnumAllPorts;
      if ShowModal = mrOK then begin
        if Copy(DeviceName, 1, 13) = 'Direct to COM' then begin
          ApdComPort1.TapiMode := tmOff;
          ApdComPort1.ComNumber := ComNumber;
        end else begin
          ApdTapiDevice1.SelectedDevice := DeviceName;
          ApdComPort1.TapiMode := tmOn;
        end;
      end;
    finally
      Free;
    end;
  end;
  {$ELSE}
  with TComSelectForm.Create(Self) do begin
    try
      ShowModal;
      ApdComPort1.TapiMode := tmOff;
      ApdComPort1.ComNumber := SelectedComNum;
    finally
      Free;
    end;
  end;
  {$ENDIF}
  if ApdComPort1.TapiMode = tmOn then begin
    if ApdTapiDevice1.SelectedDevice <> '' then
      lblDeviceName.Caption := 'Using TAPI device: ' + ApdTapiDevice1.SelectedDevice
    else
      lblDeviceName.Caption := 'Using TAPI device: <no device selected>';
  end else
    lblDeviceName.Caption := 'Using modem on ' + ComName(ApdComPort1.ComNumber);  
end;

procedure TfrmFxSrv0.cbxMonitorClick(Sender: TObject);
begin
  ApdFaxServer1.Monitoring := cbxMonitor.Checked;
end;

procedure TfrmFxSrv0.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFxSrv0.cbxPausedClick(Sender: TObject);
begin
  ApdFaxServerManager1.Paused := cbxPaused.Checked;
end;

procedure TfrmFxSrv0.edtMonitorDirExit(Sender: TObject);
begin
  ApdFaxServerManager1.MonitorDir := edtMonitorDir.Text;
end;

procedure TfrmFxSrv0.ApdFaxServerManager1Queried(Mgr: TApdFaxServerManager;
  QueryFrom: TApdCustomFaxServer; const JobToSend: String);
begin
  Add('Queried by : ' + QueryFrom.Name + ': ' + JobToSend);
end;

end.
