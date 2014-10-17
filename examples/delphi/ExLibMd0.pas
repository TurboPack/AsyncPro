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

unit ExLibMd0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus,
  AdLibMdm, OOMisc;

type
  TForm1 = class(TForm)
    popModemList: TPopupMenu;
    Deletemodem1: TMenuItem;
    popDetailFiles: TPopupMenu;
    Deletefile1: TMenuItem;
    Newfile1: TMenuItem;
    lbxModemList: TListBox;
    lbxDetailFiles: TListBox;
    lblModemListCount: TLabel;
    lblDetailLoadTime: TLabel;
    lblDetailFileCount: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    edtModemCapFolder: TEdit;
    tvDetails: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure lbxDetailFilesClick(Sender: TObject);
    procedure lbxModemListDblClick(Sender: TObject);
    procedure Deletemodem1Click(Sender: TObject);
    procedure Deletefile1Click(Sender: TObject);
    procedure Newfile1Click(Sender: TObject);
    procedure lbxDetailFilesDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure lbxDetailFilesDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure lbxModemListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    StartTime : DWORD;
    procedure RefreshDetailList;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
//  edtModemCapFolder.Text := GetEnvironmentVariable('MODEMCAP');
  if edtModemCapFolder.Text = '' then
    edtModemCapFolder.Text := 'e:\modemcap'; 
  RefreshDetailList;
end;

procedure TForm1.RefreshDetailList;
var
  sr: TSearchRec;
begin
  lbxDetailFiles.Items.Clear;
  if FindFirst(edtModemCapFolder.Text + '/*.xml', faAnyFile, sr) = 0 then begin
    lbxDetailFiles.Items.Add(sr.Name);
    while FindNext(sr) = 0 do
      lbxDetailFiles.Items.Add(sr.Name);
  end else
    ShowMessage('Modemcap detail files not found');
  FindClose(sr);
  lblDetailFileCount.Caption := IntToStr(lbxDetailFiles.Items.Count) + ' files';
end;

procedure TForm1.lbxDetailFilesClick(Sender: TObject);
var
  LibModem : TApdLibModem;
  ModemList : TStringList;
  I : Integer;
begin
  if lbxDetailFiles.ItemIndex > -1 then begin
    LibModem := nil;
    ModemList := TStringList.Create;
    Screen.Cursor := crHourglass;
    try
      lbxModemList.Clear;
      LibModem := TApdLibModem.Create(Self);
      LibModem.LibModemPath := edtModemCapFolder.Text;
      StartTime := AdTimeGetTime;
      ModemList.Assign(LibModem.GetModems(lbxDetailFiles.Items[lbxDetailFiles.ItemIndex]));
      for I := 0 to pred(ModemList.Count) do
        lbxModemList.Items.Add(ModemList[I]);
      lblModemListCount.Caption := IntToStr(lbxModemList.Items.Count) + ' modems' + #13#10 +
        Format('%f3 seconds', [(AdTimeGetTime - StartTime) / 1000]);
      tvDetails.Items.Clear;
    finally
      LibModem.Free;
      ModemList.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;


procedure TForm1.lbxModemListDblClick(Sender: TObject);
var
  LibModem : TApdLibModem;
  LmModem : TLmModem;
  i : Integer;
  j : Integer;
  CurModem : TTreeNode;
  TempNode1 : TTreeNode;
  TempNode2 : TTreeNode;
  TempNode3 : TTreeNode;
begin
  if lbxModemList.ItemIndex = -1 then exit;
  LibModem := nil;
  Screen.Cursor := crHourglass;
  try
    LibModem := TApdLibModem.Create(self);
    LibModem.LibModemPath := edtModemCapFolder.Text;
    StartTime := AdTimeGetTime;
    i :=Libmodem.GetModem(lbxDetailFiles.Items[lbxDetailFiles.ItemIndex],
      lbxModemList.Items[lbxModemList.ItemIndex], LmModem);
    lblDetailLoadTime.Caption := Format('%f3 seconds', [(AdTimeGetTime - StartTime) / 1000]);
    tvDetails.Items.Clear;
    if i <> ecOK then begin
      ShowMessage('Modem not found, i = ' + IntToStr(i));
      Exit;
    end;

    with LmModem do begin
      CurModem := tvDetails.Items.Add (nil, FriendlyName);
      tvDetails.Items.AddChild (CurModem, 'Manufacturer = ' + Manufacturer);
      tvDetails.Items.AddChild (CurModem, 'Model = ' + Model);
      tvDetails.Items.AddChild (CurModem, 'Modem ID = ' + ModemID);
      tvDetails.Items.AddChild (CurModem, 'Provider Name = ' + ProviderName);
      tvDetails.Items.AddChild (CurModem, 'Inheritance = ' + Inheritance);
      tvDetails.Items.AddChild (CurModem, 'Attached To = ' + AttachedTo);
      tvDetails.Items.AddChild (CurModem, 'Inactivity Format = ' + InactivityFormat);
      tvDetails.Items.AddChild (CurModem, 'Reset = ' + Reset);
      tvDetails.Items.AddChild (CurModem, 'DCB = ' + DCB);
      tvDetails.Items.AddChild (CurModem, 'Properties = ' + Properties);
      tvDetails.Items.AddChild (CurModem, 'Forwared Delay = ' + IntToStr (ForwardDelay));
      tvDetails.Items.AddChild (CurModem, 'Variable Terminator = ' + VariableTerminator);
      tvDetails.Items.AddChild (CurModem, 'Inf Path = ' + InfPath);
      tvDetails.Items.AddChild (CurModem, 'Inf Section = ' + InfSection);
      tvDetails.Items.AddChild (CurModem, 'Driver Description = ' + DriverDesc);
      tvDetails.Items.AddChild (CurModem, 'Responses Key Name = ' + ResponsesKeyName);
      tvDetails.Items.AddChild (CurModem, 'Default = ' + Default);
      tvDetails.Items.AddChild (CurModem, 'Call Setup Fail Timeout = ' + IntToStr (CallSetupFailTimeout));
      tvDetails.Items.AddChild (CurModem, 'Inactivity Timeout = ' + IntToStr (InactivityTimeout));
      if SupportsWaitForBongTone then
        tvDetails.Items.AddChild (CurModem, 'Supports Bong Tone = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Bong Tone = False');
      if SupportsWaitForQuiet then
        tvDetails.Items.AddChild (CurModem, 'Supports Wait forQuiet = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Wait for Quiet = False');
      if SupportsWaitForDialTone then
        tvDetails.Items.AddChild (CurModem, 'Supports Wait for Dial Tone = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Wait for Dial Tone = False');
      if SupportsSpeakerVolumeLow then
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Volume Low = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Volume Low = False');
      if SupportsSpeakerVolumeMed then
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Volume Med = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Volume Med = False');
      if SupportsSpeakerVolumeHigh then
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Volume High = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Volume High = False');
      if SupportsSpeakerModeOff then
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Mode Off = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Mode Off = False');
      if SupportsSpeakerModeOn then
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Mode On = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Mode On = False');
      if SupportsSpeakerModeSetup then
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Mode Setup = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Speaker Mode Setup = False');
      if SupportsSetDataCompressionNegot then
        tvDetails.Items.AddChild (CurModem, 'Supports Set Data Compression Negotiation = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set Data Compresssion Negotiation = False');
      if SupportsSetErrorControlProtNegot then
        tvDetails.Items.AddChild (CurModem, 'Supports Set Error Control Protocol Negotiation = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set Error Control Protocol Negotiation = False');
      if SupportsSetForcedErrorControl then
        tvDetails.Items.AddChild (CurModem, 'Supports Set Forced Error Control = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set Forced Error Control = False');
      if SupportsSetCellular then
        tvDetails.Items.AddChild (CurModem, 'Supports Set Cellular = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set Cellular = False');
      if SupportsSetHardwareFlowControl then
        tvDetails.Items.AddChild (CurModem, 'Supports Set Hardware Flow Control = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set Hardware Flow Control = False');
      if SupportsSetSoftwareFlowControl then
        tvDetails.Items.AddChild (CurModem, 'Supports Set Software Flow Control = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set Software Flow Control = False');
      if SupportsCCITTBellToggle then
        tvDetails.Items.AddChild (CurModem, 'Supports Set CCITT Bell Toggle = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set CCITT Bell Toggle = False');
      if SupportsSetSpeedNegotiation then
        tvDetails.Items.AddChild (CurModem, 'Supports Set Speed Negotiation = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set Speed Negotiation = False');
      if SupportsSetTonePulse then
        tvDetails.Items.AddChild (CurModem, 'Supports Set Tone Pulse = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Set Tone Pulse = False');
      if SupportsBlindDial then
        tvDetails.Items.AddChild (CurModem, 'Supports Blind Dial = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Blind Dial = False');
      if SupportsSetV21V23 then
        tvDetails.Items.AddChild (CurModem, 'Supports V21 V23 = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports V21 V23 = False');
      if SupportsModemDiagnostics then
        tvDetails.Items.AddChild (CurModem, 'Supports Modem Diagnostics = True')
      else
        tvDetails.Items.AddChild (CurModem, 'Supports Modem Diagnostics = False');
      tvDetails.Items.AddChild (CurModem, 'Max DTE Rate = ' + IntToStr (MaxDTERate));
      tvDetails.Items.AddChild (CurModem, 'Max DCE Rate = ' + IntToStr (MaxDCERate));
      tvDetails.Items.AddChild (CurModem, 'Current Country = ' + CurrentCountry);
      tvDetails.Items.AddChild (CurModem, 'Maximum Port Speed = ' + IntToStr (MaximumPortSpeed));
      tvDetails.Items.AddChild (CurModem, 'Power Delay = ' + IntToStr (PowerDelay));
      tvDetails.Items.AddChild (CurModem, 'Config Delay = ' + IntToStr (ConfigDelay));
      tvDetails.Items.AddChild (CurModem, 'Baud Rate = ' + IntToStr (BaudRate));

      // Get Responses
      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Responses');

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'OK');
      for j := 0 to Responses.OK.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.OK[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'NegotiationProgress');
      for j := 0 to Responses.NegotiationProgress.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.NegotiationProgress[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Connect');
      for j := 0 to Responses.Connect.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Connect[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Error');
      for j := 0 to Responses.Error.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Error[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'No Carrier');
      for j := 0 to Responses.NoCarrier.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.NoCarrier[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'No Dial Tone');
      for j := 0 to Responses.NoDialTone.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.NoDialTone[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Busy');
      for j := 0 to Responses.Busy.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Busy[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'No Answer');
      for j := 0 to Responses.NoAnswer.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.NoAnswer[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Ring');
      for j := 0 to Responses.Ring.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Ring[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice View 1');
      for j := 0 to Responses.VoiceView1.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.VoiceView1[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice View 2');
      for j := 0 to Responses.VoiceView2.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.VoiceView2[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice View 3');
      for j := 0 to Responses.VoiceView3.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.VoiceView3[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice View 4');
      for j := 0 to Responses.VoiceView4.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.VoiceView4[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice View 5');
      for j := 0 to Responses.VoiceView5.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.VoiceView5[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice View 6');
      for j := 0 to Responses.VoiceView6.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.VoiceView6[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice View 7');
      for j := 0 to Responses.VoiceView7.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.VoiceView7[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice View 8');
      for j := 0 to Responses.VoiceView8.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.VoiceView8[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Ring Duration');
      for j := 0 to Responses.RingDuration.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.RingDuration[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Ring Break');
      for j := 0 to Responses.RingBreak.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.RingBreak[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Date');
      for j := 0 to Responses.Date.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Date[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Time');
      for j := 0 to Responses.Time.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Time[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Number');
      for j := 0 to Responses.Number.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Number[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Name');
      for j := 0 to Responses.Name.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Name[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Message');
      for j := 0 to Responses.Msg.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Msg[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Single Ring');
      for j := 0 to Responses.SingleRing.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.SingleRing[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Double Ring');
      for j := 0 to Responses.DoubleRing.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.DoubleRing[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Triple Ring');
      for j := 0 to Responses.TripleRing.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.TripleRing[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice');
      for j := 0 to Responses.Voice.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Voice[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Fax');
      for j := 0 to Responses.Fax.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Fax[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Data');
      for j := 0 to Responses.Data.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Data[j]).Response);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Other');
      for j := 0 to Responses.Other.Count - 1 do
        tvDetails.Items.AddChild (TempNode2, PLmResponseData (Responses.Other[j]).Response);

      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Answer');
      for j := 0 to Answer.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode1, 'Command = ' + PLmModemCommand (Answer[j]).Command);
        tvDetails.Items.AddChild (TempNode1, 'Sequence = ' + IntToStr (PLmModemCommand (Answer[j]).Sequence));
      end;

      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Fax');
      for j := 0 to Fax.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode1, 'Command = ' + PLmModemCommand (Fax[j]).Command);
        tvDetails.Items.AddChild (TempNode1, 'Sequence = ' + IntToStr (PLmModemCommand (Fax[j]).Sequence));
      end;

      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Hangup');
      for j := 0 to Hangup.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode1, 'Command = ' + PLmModemCommand (Hangup[j]).Command);
        tvDetails.Items.AddChild (TempNode1, 'Sequence = ' + IntToStr (PLmModemCommand (Hangup[j]).Sequence));
      end;

      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Init');
      for j := 0 to Init.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode1, 'Command = ' + PLmModemCommand (Init[j]).Command);
        tvDetails.Items.AddChild (TempNode1, 'Sequence = ' + IntToStr (PLmModemCommand (Init[j]).Sequence));
      end;

      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Monitor');
      for j := 0 to Monitor.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode1, 'Command = ' + PLmModemCommand (Monitor[j]).Command);
        tvDetails.Items.AddChild (TempNode1, 'Sequence = ' + IntToStr (PLmModemCommand (Monitor[j]).Sequence));
      end;

      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Settings');
      tvDetails.Items.AddChild (TempNode1, 'Prefix = ' + Settings.Prefix);
      tvDetails.Items.AddChild (TempNode1, 'Terminator = ' + Settings.Terminator);
      tvDetails.Items.AddChild (TempNode1, 'Dial Prefix = ' + Settings.DialPrefix);
      tvDetails.Items.AddChild (TempNode1, 'Dial Suffix = ' + Settings.DialSuffix);
      tvDetails.Items.AddChild (TempNode1, 'Speaker Volume High = ' + Settings.SpeakerVolume_High);
      tvDetails.Items.AddChild (TempNode1, 'Speaker Volume Low = ' + Settings.SpeakerVolume_Low);
      tvDetails.Items.AddChild (TempNode1, 'Speaker Volume Medium = ' + Settings.SpeakerVolume_Med);
      tvDetails.Items.AddChild (TempNode1, 'Speaker Mode Dial = ' + Settings.SpeakerMode_Dial);
      tvDetails.Items.AddChild (TempNode1, 'Speaker Mode Off = ' + Settings.SpeakerMode_Off);
      tvDetails.Items.AddChild (TempNode1, 'Speaker Mode On = ' + Settings.SpeakerMode_On);
      tvDetails.Items.AddChild (TempNode1, 'Speaker Mode Setup = ' + Settings.SpeakerMode_Setup);
      tvDetails.Items.AddChild (TempNode1, 'Flow Control Hard = ' + Settings.FlowControl_Hard);
      tvDetails.Items.AddChild (TempNode1, 'Flow Control Off = ' + Settings.FlowControl_Off);
      tvDetails.Items.AddChild (TempNode1, 'Flow Control Soft = ' + Settings.FlowControl_Soft);
      tvDetails.Items.AddChild (TempNode1, 'Error Control Forced = ' + Settings.ErrorControl_Forced);
      tvDetails.Items.AddChild (TempNode1, 'Error Control Off = ' + Settings.ErrorControl_Off);
      tvDetails.Items.AddChild (TempNode1, 'Error Control On = ' + Settings.ErrorControl_On);
      tvDetails.Items.AddChild (TempNode1, 'Error Control Cellular = ' + Settings.ErrorControl_Cellular);
      tvDetails.Items.AddChild (TempNode1, 'Error Control Cellular Forced = ' + Settings.ErrorControl_Cellular_Forced);
      tvDetails.Items.AddChild (TempNode1, 'Compression Off = ' + Settings.Compression_Off);
      tvDetails.Items.AddChild (TempNode1, 'Compression On = ' + Settings.Compression_On);
      tvDetails.Items.AddChild (TempNode1, 'Modulation Bell = ' + Settings.Modulation_Bell);
      tvDetails.Items.AddChild (TempNode1, 'Modulation CCITT = ' + Settings.Modulation_CCITT);
      tvDetails.Items.AddChild (TempNode1, 'Modulation CCITT V23 = ' + Settings.Modulation_CCITT_V23);
      tvDetails.Items.AddChild (TempNode1, 'Speed Negotiation On = ' + Settings.SpeedNegotiation_On);
      tvDetails.Items.AddChild (TempNode1, 'Speed Negotiation Off = ' + Settings.SpeedNegotiation_Off);
      tvDetails.Items.AddChild (TempNode1, 'Pulse = ' + Settings.Pulse);
      tvDetails.Items.AddChild (TempNode1, 'Tone = ' + Settings.Tone);
      tvDetails.Items.AddChild (TempNode1, 'Blind Off = ' + Settings.Blind_Off);
      tvDetails.Items.AddChild (TempNode1, 'Blind On = ' + Settings.Blind_On);
      tvDetails.Items.AddChild (TempNode1, 'Call Setup Fail Timer = ' + Settings.CallSetupFailTimer);
      tvDetails.Items.AddChild (TempNode1, 'Inactivity Timeout = ' + Settings.InactivityTimeout);
      tvDetails.Items.AddChild (TempNode1, 'Compatibility Flags = ' + Settings.CompatibilityFlags);
      tvDetails.Items.AddChild (TempNode1, 'Config Delay = ' + IntToStr (Settings.ConfigDelay));

      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Voice');
      tvDetails.Items.AddChild (TempNode1, 'Voice Profile = ' + Voice.VoiceProfile);
      tvDetails.Items.AddChild (TempNode1, 'Handset Close Delay = ' + IntToStr (Voice.HandsetCloseDelay));
      tvDetails.Items.AddChild (TempNode1, 'Speaker Phone Specs = ' + Voice.SpeakerPhoneSpecs);
      tvDetails.Items.AddChild (TempNode1, 'Abort Play = ' + Voice.AbortPlay);
      tvDetails.Items.AddChild (TempNode1, 'Caller ID OutSide = ' + Voice.CallerIDOutSide);
      tvDetails.Items.AddChild (TempNode1, 'Caller ID Private = ' + Voice.CallerIDPrivate);
      tvDetails.Items.AddChild (TempNode1, 'Terminate Play = ' + Voice.TerminatePlay);
      tvDetails.Items.AddChild (TempNode1, 'Terminate Record = ' + Voice.TerminateRecord);
      tvDetails.Items.AddChild (TempNode1, 'Voice Manufacturer ID = ' + Voice.VoiceManufacturerID);
      tvDetails.Items.AddChild (TempNode1, 'Voice Product ID Wave In = ' + Voice.VoiceProductIDWaveIn);
      tvDetails.Items.AddChild (TempNode1, 'Voice Product ID Wave Out = ' + Voice.VoiceProductIDWaveOut);
      tvDetails.Items.AddChild (TempNode1, 'Voice Switch Features = ' + Voice.VoiceSwitchFeatures);
      tvDetails.Items.AddChild (TempNode1, 'Voice Baud Rate = ' + IntToStr (Voice.VoiceBaudRate));
      tvDetails.Items.AddChild (TempNode1, 'Voice Mixer Mid = ' + Voice.VoiceMixerMid);
      tvDetails.Items.AddChild (TempNode1, 'Voice Mixer Pid = ' + Voice.VoiceMixerPid);
      tvDetails.Items.AddChild (TempNode1, 'Voice Mixer Line ID = ' + Voice.VoiceMixerLineID);

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Close Handset');
      for j := 0 to Voice.CloseHandset.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.CloseHandset[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.CloseHandset[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Enable Caller ID');
      for j := 0 to Voice.EnableCallerID.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.EnableCallerID[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.EnableCallerID[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Enable Distinctive Ring');
      for j := 0 to Voice.EnableDistinctiveRing.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.EnableDistinctiveRing[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.EnableDistinctiveRing[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Generate Digit');
      for j := 0 to Voice.GenerateDigit.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.GenerateDigit[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.GenerateDigit[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Handset Play Format');
      for j := 0 to Voice.HandsetPlayFormat.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.HandsetPlayFormat[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.HandsetPlayFormat[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Handset Record Format');
      for j := 0 to Voice.HandsetRecordFormat.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.HandsetRecordFormat[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.HandsetRecordFormat[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Line Set Play Format');
      for j := 0 to Voice.LineSetPlayFormat.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.LineSetPlayFormat[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.LineSetPlayFormat[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Line Set Record Format');
      for j := 0 to Voice.LineSetRecordFormat.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.LineSetRecordFormat[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.LineSetRecordFormat[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Open Handset');
      for j := 0 to Voice.OpenHandset.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.OpenHandset[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.OpenHandset[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Speaker Phone Disable');
      for j := 0 to Voice.SpeakerPhoneDisable.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.SpeakerPhoneDisable[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.SpeakerPhoneDisable[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Speaker Phone Enable');
      for j := 0 to Voice.SpeakerPhoneEnable.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.SpeakerPhoneEnable[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.SpeakerPhoneEnable[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Speaker Phone Mute');
      for j := 0 to Voice.SpeakerPhoneMute.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.SpeakerPhoneMute[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.SpeakerPhoneMute[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Speaker Phone Set Volume Gain');
      for j := 0 to Voice.SpeakerPhoneSetVolumeGain.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.SpeakerPhoneSetVolumeGain[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.SpeakerPhoneSetVolumeGain[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Speaker Phone UnMute');
      for j := 0 to Voice.SpeakerPhoneUnMute.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.SpeakerPhoneUnMute[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.SpeakerPhoneUnMute[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'StartPlay');
      for j := 0 to Voice.StartPlay.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.StartPlay[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.StartPlay[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Start Record');
      for j := 0 to Voice.StartRecord.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.StartRecord[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.StartRecord[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Stop Play');
      for j := 0 to Voice.StopPlay.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.StopPlay[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.StopPlay[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Stop Record');
      for j := 0 to Voice.StopRecord.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.StopRecord[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.StopRecord[j]).Sequence));
      end;


      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice Answer');
      for j := 0 to Voice.VoiceAnswer.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.VoiceAnswer[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.VoiceAnswer[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice Dial Number Setup');
      for j := 0 to Voice.VoiceDialNumberSetup.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.VoiceDialNumberSetup[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.VoiceDialNumberSetup[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Voice To Data Answer');
      for j := 0 to Voice.VoiceToDataAnswer.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode2, 'Command = ' + PLmModemCommand (Voice.VoiceToDataAnswer[j]).Command);
        tvDetails.Items.AddChild (TempNode2, 'Sequence = ' + IntToStr (PLmModemCommand (Voice.VoiceToDataAnswer[j]).Sequence));
      end;

      TempNode2 := tvDetails.Items.AddChild (TempNode1, 'Wave Driver');
      tvDetails.Items.AddChild (TempNode2, 'Baud Rate = '  + Voice.WaveDriver.BaudRate);
      tvDetails.Items.AddChild (TempNode2, 'Wave Hardware ID = '  + Voice.WaveDriver.WaveHardwareID);
      tvDetails.Items.AddChild (TempNode2, 'Wave Devices = '  + Voice.WaveDriver.WaveDevices);
      tvDetails.Items.AddChild (TempNode2, 'Lower Mid = '  + Voice.WaveDriver.LowerMid);
      tvDetails.Items.AddChild (TempNode2, 'Lower Wave In Pid = '  + Voice.WaveDriver.LowerWaveInPid);
      tvDetails.Items.AddChild (TempNode2, 'Lower Wave Out Pid = '  + Voice.WaveDriver.LowerWaveOutPid);
      tvDetails.Items.AddChild (TempNode2, 'Wave Out Mixer Dest = '  + Voice.WaveDriver.WaveOutMixerDest);
      tvDetails.Items.AddChild (TempNode2, 'Wave Out Mixer Source = '  + Voice.WaveDriver.WaveOutMixerSource);
      tvDetails.Items.AddChild (TempNode2, 'Wave In Mixer Dest = '  + Voice.WaveDriver.WaveInMixerDest);
      tvDetails.Items.AddChild (TempNode2, 'Wave In Mixer Source = '  + Voice.WaveDriver.WaveInMixerSource);

      TempNode3 := tvDetails.Items.AddChild (TempNode2, 'Wave Format');
      for j := 0 to Voice.WaveDriver.WaveFormat.Count - 1 do begin
        tvDetails.Items.AddChild (TempNode3, 'Speed ' + IntToStr (j + 1) + ' = ' + PLmWaveFormat (Voice.WaveDriver.WaveFormat[j]).Speed);
        tvDetails.Items.AddChild (TempNode3, 'ChipSet ' + IntToStr (j + 1) + ' = ' + PLmWaveFormat (Voice.WaveDriver.WaveFormat[j]).ChipSet);
        tvDetails.Items.AddChild (TempNode3, 'Sample Size ' + IntToStr (j + 1) + ' = ' + PLmWaveFormat (Voice.WaveDriver.WaveFormat[j]).SampleSize);
      end;

      TempNode1 := tvDetails.Items.AddChild (CurModem, 'Hardware');
      tvDetails.Items.AddChild (TempNode1, 'Autoconfig Override = '  + Hardware.AutoConfigOverride);
      tvDetails.Items.AddChild (TempNode1, 'ComPort = '  + Hardware.ComPort);
      tvDetails.Items.AddChild (TempNode1, 'Invalid RDP = '  + Hardware.InvalidRDP);
      tvDetails.Items.AddChild (TempNode1, 'I/O Base Address = '  + IntToStr (Hardware.IoBaseAddress));
      tvDetails.Items.AddChild (TempNode1, 'Interrupt Number = '  + IntToStr (Hardware.InterruptNumber));
      if Hardware.PermitShare then
        tvDetails.Items.AddChild (TempNode1, 'Permit Share = True')
      else
        tvDetails.Items.AddChild (TempNode1, 'Permit Share = False');
      tvDetails.Items.AddChild (TempNode1, 'RxFIFO = '  + Hardware.RxFIFO);
      tvDetails.Items.AddChild (TempNode1, 'Rx/TX Buffer Size = '  + IntToStr (Hardware.RxTxBufferSize));
      tvDetails.Items.AddChild (TempNode1, 'Tx FIFO = '  + Hardware.TxFIFO);
      tvDetails.Items.AddChild (TempNode1, 'PCMCIA  = '  + Hardware.Pcmcia);
      tvDetails.Items.AddChild (TempNode1, 'Bus Type = '  + Hardware.BusType);
      tvDetails.Items.AddChild (TempNode1, 'PCCARD Attribute Memory Address = '  + IntToStr (Hardware.PCCARDAttributeMemoryAddress));
      tvDetails.Items.AddChild (TempNode1, 'PCCARD Attribute Memory Size = '  + IntToStr (Hardware.PCCARDAttributeMemorySize));
      tvDetails.Items.AddChild (TempNode1, 'PCCARD Attribute Memory Offset = '  + IntToStr (Hardware.PCCARDAttributeMemoryOffset));
    end;
  finally
    LibModem.Free;
    Screen.Cursor := crDefault;
  end;
  lbxModemList.DragMode := dmAutomatic;
  caption := 'automatic';
end;

procedure TForm1.Deletemodem1Click(Sender: TObject);
var
  DetailFile, ModemName : string;
  LibModem : TApdLibModem;
begin
  if lbxModemList.ItemIndex = -1 then exit;
  ModemName := lbxModemList.Items[lbxModemList.ItemIndex];
  LibModem := nil;
  Screen.Cursor := crHourglass;
  try
    DetailFile := lbxDetailFiles.Items[lbxDetailFiles.ItemIndex];
    LibModem := TApdLibModem.Create(self);
    LibModem.LibModemPath := edtModemCapFolder.Text;

    LibModem.DeleteModem(DetailFile, ModemName);
    Caption := Format('%f3 seconds', [(AdTimeGetTime - StartTime) / 1000]);
    { force everything to repaint }
    lbxDetailFilesClick(nil);
  finally
    LibModem.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.Deletefile1Click(Sender: TObject);
var
  DetailFile : string;
begin
  if lbxDetailFiles.ItemIndex = -1 then exit;
  DetailFile := lbxDetailFiles.Items[lbxDetailFiles.ItemIndex];
  if MessageDlg('Delete ' + DetailFile + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    DeleteFile(AddBackslash(edtModemCapFolder.Text) + DetailFile);
    RefreshDetailList;
  end;
end;

procedure TForm1.Newfile1Click(Sender: TObject);
var
  NewName : string;
  LibModem : TApdLibModem;
begin
  NewName := 'MyModems.xml';
  if InputQuery('New modem detail file', 'Enter new name '#13#10 +
    '(.xml auto-added, path is modemcap folder)', NewName) then begin
    LibModem := nil;
    try
      LibModem := TApdLibModem.Create(self);
      LibModem.LibModemPath := edtModemCapFolder.Text;
      LibModem.CreateNewDetailFile(NewName);
    finally
      LibModem.Free;
    end;
    RefreshDetailList;
  end;
end;

procedure TForm1.lbxDetailFilesDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source = lbxModemList;
end;

procedure TForm1.lbxDetailFilesDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  DropFileIndex : Integer;
  DragToFileName,
  DragFromFileName,
  DraggedModemName : string;
  LibModem : TApdLibModem;
  Modem : TLmModem;
begin
  if Source = lbxModemList then begin
    DraggedModemName := lbxModemList.Items[lbxModemList.ItemIndex];
    DragFromFileName := lbxDetailFiles.Items[lbxDetailFiles.ItemIndex];
    DropFileIndex := lbxDetailFiles.ItemAtPos(Point(X, Y), False);
    DragToFileName := lbxDetailFiles.Items[DropFileIndex];
    LibModem := nil;
    try
      LibModem := TApdLibModem.Create(self);
      LibModem.LibModemPath := edtModemCapFolder.Text;
      StartTime := AdTimeGetTime;
      if LibModem.GetModem(DragFromFileName, DraggedModemName, Modem) = ecOK then
        LibModem.AddModem(DragToFileName, Modem);
      Caption := Format('%f3 seconds', [(AdTimeGetTime - StartTime) / 1000]);
    finally
      LibModem.Free;
    end;
  end;
end;


procedure TForm1.lbxModemListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Shift = [ssDouble] then begin
    lbxModemList.DragMode := dmManual;
    Caption := 'manual';
  end;
end;

end.
