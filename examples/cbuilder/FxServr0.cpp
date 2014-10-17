// ***** BEGIN LICENSE BLOCK *****
// * Version: MPL 1.1
// *
// * The contents of this file are subject to the Mozilla Public License Version
// * 1.1 (the "License"); you may not use this file except in compliance with
// * the License. You may obtain a copy of the License at
// * http://www.mozilla.org/MPL/
// *
// * Software distributed under the License is distributed on an "AS IS" basis,
// * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// * for the specific language governing rights and limitations under the
// * License.
// *
// * The Original Code is TurboPower Async Professional
// *
// * The Initial Developer of the Original Code is
// * TurboPower Software
// *
// * Portions created by the Initial Developer are Copyright (C) 1991-2002
// * the Initial Developer. All Rights Reserved.
// *
// * Contributor(s):
// *
// * ***** END LICENSE BLOCK *****

//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "FxServr0.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "AdFaxSrv"
#pragma link "AdFax"    
#pragma link "OoMisc"
#pragma link "AdFStat"
#pragma link "AdTapi"
#pragma link "AdFaxPrn"
#pragma link "AdFPStat"
#pragma resource "*.dfm"
TfrmFxSrv0 *frmFxSrv0;
//---------------------------------------------------------------------------
__fastcall TfrmFxSrv0::TfrmFxSrv0(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void TfrmFxSrv0::Add(String S)
{
  if (lbStatus != 0) {
    lbStatus->Items->Add(S);
    if (lbStatus->Items->Count > 0)
      lbStatus->ItemIndex = lbStatus->Items->Count - 1;
  }
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::edtStationIDExit(TObject *Sender)
{
  ApdFaxServer1->StationID = edtStationID->Text;	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::edtModemInitExit(TObject *Sender)
{
  ApdFaxServer1->ModemInit = edtModemInit->Text;	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::edtDialPrefixExit(TObject *Sender)
{
  ApdFaxServer1->DialPrefix = edtDialPrefix->Text;	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::edtDestinationDirExit(TObject *Sender)
{
  ApdFaxServer1->DestinationDir = edtDestinationDir->Text;	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::edtQueryIntervalExit(TObject *Sender)
{
  ApdFaxServer1->SendQueryInterval = StrToIntDef(edtQueryInterval->Text,
    ApdFaxServer1->SendQueryInterval);
  edtQueryInterval->Text = IntToStr(ApdFaxServer1->SendQueryInterval);
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::rgpFaxClassClick(TObject *Sender)
{
  ApdFaxServer1->FaxClass = (TFaxClass)(rgpFaxClass->ItemIndex+1);	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::cbxEnhFontsClick(TObject *Sender)
{
  ApdFaxServer1->EnhTextEnabled = cbxEnhFonts->Checked;	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::cbxMonitorClick(TObject *Sender)
{
  ApdFaxServer1->Monitoring = cbxMonitor->Checked;	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::cbxPrintOnReceiveClick(TObject *Sender)
{
  ApdFaxServer1->PrintOnReceive = cbxPrintOnReceive->Checked;	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::btnHeaderFontClick(TObject *Sender)
{
  FontDialog1->Font = ApdFaxServer1->EnhHeaderFont;
  if (FontDialog1->Execute())
    ApdFaxServer1->EnhHeaderFont = FontDialog1->Font;
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::btnCoverFontClick(TObject *Sender)
{
FontDialog1->Font = ApdFaxServer1->EnhFont;
if (FontDialog1->Execute())
  ApdFaxServer1->EnhFont = FontDialog1->Font;
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::btnPrintSetupClick(TObject *Sender)
{
  ApdFaxPrinter1->PrintSetup();
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::edtMonitorDirExit(TObject *Sender)
{
  ApdFaxServerManager1->MonitorDir = edtMonitorDir->Text;	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::cbxPausedClick(TObject *Sender)
{
  ApdFaxServerManager1->Paused = cbxPaused->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::btnSelectDeviceClick(TObject *Sender)
{
  TDeviceSelectionForm* DeviceSelect = new TDeviceSelectionForm(this);

  DeviceSelect->ShowTapiDevices = true;
  DeviceSelect->ShowPorts = true;
  DeviceSelect->EnumAllPorts();
  if (DeviceSelect->ShowModal()){
    if (DeviceSelect->TapiMode == tmOff){
      ApdComPort1->TapiMode = tmOff;
      ApdComPort1->ComNumber = DeviceSelect->ComNumber;
    } else {
      ApdTapiDevice1->SelectedDevice = DeviceSelect->DeviceName;
      ApdComPort1->TapiMode = tmOn;
    }
  }
  delete DeviceSelect;

  if (ApdComPort1->TapiMode == tmOn){
    if (ApdTapiDevice1->SelectedDevice != ""){
      lblDeviceName->Caption = "Using TAPI device: " + ApdTapiDevice1->SelectedDevice;
    } else {
      lblDeviceName->Caption = "Using TAPI device: <no device selected>";
    }
  } else {
    lblDeviceName->Caption = "Using modem on " + ComName(ApdComPort1->ComNumber);
  }

}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::btnCloseClick(TObject *Sender)
{
  Close();	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::ApdFaxServer1FaxServerAccept(TObject *CP, bool &Accept)
{
  Add("Accepting fax from: " + ApdFaxServer1->RemoteID);	
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::ApdFaxServer1FaxServerFatalError(TObject *CP,
	TFaxServerMode FaxMode, int ErrorCode, int HangupCode)
{
  String S;
  if (FaxMode == fsmSend)
    S = "sending";
  else
    S = "receiving";
  Add("Fatal error occured while " + S);
  Add("      ErrorCode = (" + IntToStr(ErrorCode) + ") " + ErrorMsg(ErrorCode));
  Add("      HangupCode= " + IntToStr(HangupCode));
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::ApdFaxServer1FaxServerFinish(TObject *CP,
	TFaxServerMode FaxMode, int ErrorCode)
{
  String S;
  if (FaxMode == fsmSend)
    S = "sent";
  else
    S = "received";

  if (ErrorCode == ecOK)
    S = S + " successfully";
  else
    S = S + " with an error code of (" + IntToStr(ErrorCode) + ") " +
      ErrorMsg(ErrorCode);
  Add("Fax " + S);
  if ((FaxMode == fsmReceive) & (ErrorCode == ecOK))
    Add("Fax saved to " + ApdFaxServer1->FaxFile);

}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::ApdFaxServer1FaxServerLog(TObject *CP,
	TFaxLogCode LogCode, TFaxServerLogCode ServerCode)
{
  String S = "";
  if (LogCode == lfaxNone){
    switch (ServerCode) {
      case fslPollingEnabled     : S = "Polling enabled every " +
        IntToStr(ApdFaxServer1->SendQueryInterval) + " seconds";
        break;
      case fslPollingDisabled    : S = "Polling disabled";
        break;
      case fslMonitoringEnabled  : S = "Monitoring for incoming faxes";
        break;
      case fslMonitoringDisabled : S = "Monitoring disabled";
        break;
      default: S = "";
    }
  } else {
    switch (LogCode){
      case lfaxTransmitStart : S = "Transmit start";
        break;
      case lfaxTransmitOk    : S = "Transmit OK";
        break;
      case lfaxTransmitFail  : S = "Transmit failed";
        break;
      case lfaxReceiveStart  : S = "Receive start";
        break;
      case lfaxReceiveOk     : S = "Receive OK";
        break;
      case lfaxReceiveSkip   : S = "Receive skipped";
        break;
      case lfaxReceiveFail   : S = "Receive failed";
        break;
      default: S = "";
    }
  }
  Add("Fax log: " + S);
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::ApdFaxServer1FaxServerPortOpenClose(TObject *CP,
	bool Opening)
{
  if(Opening)
    Add("Port is opened");
  else
    Add("Port is closed");
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::ApdFaxServer1FaxServerStatus(TObject *CP,
	TFaxServerMode FaxMode, bool First, bool Last, WORD Status)
{
  String S;
  if (FaxMode == fsmSend)
    S = "send";
  else
    S = "receive";
  Add("Fax status (" + S + "): " + ApdFaxServer1->StatusMsg(Status));
}
//---------------------------------------------------------------------------
void __fastcall TfrmFxSrv0::FormCreate(TObject *Sender)
{
  edtMonitorDir->Text = ApdFaxServerManager1->MonitorDir;
  cbxPaused->Checked = ApdFaxServerManager1->Paused;

  edtStationID->Text = ApdFaxServer1->StationID;
  if (ApdFaxServer1->FaxClass == fcUnknown)
    ApdFaxServer1->FaxClass = fcDetect;
  rgpFaxClass->ItemIndex = ApdFaxServer1->FaxClass - 1;
  edtModemInit->Text = ApdFaxServer1->ModemInit;
  edtDialPrefix->Text = ApdFaxServer1->DialPrefix;
  edtDestinationDir->Text = ApdFaxServer1->DestinationDir;
  cbxEnhFonts->Checked = ApdFaxServer1->EnhTextEnabled;
  cbxMonitor->Checked = ApdFaxServer1->Monitoring;
  cbxPrintOnReceive->Checked = ApdFaxServer1->PrintOnReceive;
  edtQueryInterval->Text = IntToStr(ApdFaxServer1->SendQueryInterval);

  if (ApdComPort1->TapiMode == tmOn) {
    if (ApdTapiDevice1->SelectedDevice != "")
      lblDeviceName->Caption = "Using TAPI device: " + ApdTapiDevice1->SelectedDevice;
    else
      lblDeviceName->Caption = "Using TAPI device: <no device selected>";
  } else
    lblDeviceName->Caption = "Using modem on " + ComName(ApdComPort1->ComNumber);
}
//---------------------------------------------------------------------------
