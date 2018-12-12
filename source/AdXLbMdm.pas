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
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADXLBMDM.PAS 4.06                   *}
{*********************************************************}
{*  Contains TApdModemCapDetails, which manipulates the  *}
{*                modemcap detail files.                 *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdXLbMdm;

interface

uses
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  OOMisc,
  AdXBase,
  AdXParsr,
  AdExcept,
  AdLibMdm;

type
  TApdModemCapDetail = class(TApdBaseComponent)
  private
    DetailStream : TFileStream;
    function AtEOF : Boolean;
    function ExportDetailXML(Modem : TLmModem) : Integer;
    procedure FixupModemcap(var List : TStringList);
    function ReadLine : AnsiString;
    procedure WriteLine(const Str : ansistring); overload;
    procedure WriteLine(const Str : string); overload;
    procedure WriteXMLStr(const Str, sVal : string);

    function XMLize(const S : string) : string;
    function XMLizeInt(I : Integer) : string;
    function XMLizeBool(B : Boolean) : string;
    function UnXMLize(const S : AnsiString) : AnsiString;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    { create a new modem detail file with appropriate headers }
    function CreateNewDetailFile(const ModemDetailFile : string) : Integer;
    { adds a modem to the modem detail file }
    function AddModem(const ModemDetailFile : string; Modem : TLmModem) : Integer;
    { deletes a modem from the modem detail file }
    function DeleteModem(const ModemDetailFile, ModemName : string) : Integer;

    { these methods manage the modemcap index }
    { add a modem record to modemcap }
    function AddModemRecord(const ModemCapIndex : string;
      ModemRecord : TLmModemName) : Integer;
    { delete a modem record from modemcap }
    function DeleteModemRecord(const ModemCapIndex : string;
      ModemRecord : TLmModemName) : Integer;
  end;

implementation

uses
  AnsiStrings, AdAnsiStrings;

{ TApdModemCapDetail }

{
  General assumptions: All ModemDetailFile parameters point to a specific
    modemcap modem detail file. ModemDetailFile includes the full path and
    file name.
    All return values of the public functions are the ecXxx error codes
}

function TApdModemCapDetail.AddModem(const ModemDetailFile: string;
  Modem: TLmModem): Integer;
  { adds a modem to the modem detail file }
var
  C : AnsiChar;
  I : Integer;
  S : ansistring;
  Found : Boolean;
begin
  DetailStream := nil;
  try
    DetailStream := TFileStream.Create(ModemDetailFile, fmOpenReadWrite);
    { find the space between the last </Modem> and the final </ModemList> }
    I := DetailStream.Size;
    repeat
      dec(I);
      DetailStream.Position := I;
      DetailStream.ReadBuffer(C, 1);
      S := C + S;
      Found := Pos('</ModemList>', S) > 0;
    until Found or (I = 0);
    DetailStream.Position := I - 1;
    if not Found then
    begin
      Result := ecInvalidFile;
      Exit;
    end;

    { now that we've found where we want to insert the new modem... }
    ExportDetailXML(Modem);
    WriteLine(#13#10'</ModemList>');
    Result := ecOK;
  finally
    DetailStream.Free;
    DetailStream := nil;
  end;
end;

function TApdModemCapDetail.AddModemRecord(
  const ModemCapIndex : string; ModemRecord: TLmModemName): Integer;
  { add a modem record to the master index, for something like this }
  { it's faster to use a TStringList }
var
  List : TStringList;
  S : string;
  I : Integer;
begin
  Result := ecFileNotFound;
  if FileExists(ModemCapIndex) then begin
    Result := ecInvalidFile;
    List := nil;
    try
      List := TStringList.Create;
      List.LoadFromFile(ModemCapIndex);
      I := pred(List.Count);
      { find the last modem record }
      while (System.Pos('<ModemRecord ModemName = "', List[I]) = 0) and (I > 0) do begin
        List.Delete(I);
        dec(I);
      end;
      if I = 0 then
        { must not be modemcap }
        Exit;
      S := '  <ModemRecord ModemName = "' + ModemRecord.ModemName +
              '" Manufacturer = "' + ModemRecord.Manufacturer +
              '" Model = "' + ModemRecord.Model +
              '" ModemFile = "' + ModemRecord.ModemFile + '"/>';
      List.Add(S);
      FixupModemCap(List);
      List.SaveToFile(ModemCapIndex);
      Result := ecOK;
    finally
      List.Free;
    end;
  end;
end;

function TApdModemCapDetail.AtEOF: Boolean;
begin
  Result := DetailStream.Position >= DetailStream.Size;
end;

constructor TApdModemCapDetail.Create(AOwner: TComponent);
begin
  inherited;
  DetailStream := nil;
end;

function TApdModemCapDetail.CreateNewDetailFile(
  const ModemDetailFile: string): Integer;
var
  S : string;
begin
  try
    { create a new detail file }
    DetailStream := TFileStream.Create(ModemDetailFile, fmCreate);
    { add the appropriate headers }
    WriteLine('<?xml version="1.0" encoding="UTF-8"?>');
    WriteLine('<!DOCTYPE ModemList SYSTEM "modemdetails.dtd">');
    WriteLine('<ModemList');
    WriteLine('  Generator = "ApxLibModem"');
    WriteLine('  GeneratorVersion = "' + ApVersionStr + '"');
    S := FormatDateTime('YYYY.MM.DD', Date);
    WriteLine('  GeneratorDate = "' + S + '">');
    WriteLine('</ModemList>');
  finally
    DetailStream.Free;
    DetailStream := nil;
  end;
  Result := ecOK;
end;

function TApdModemCapDetail.DeleteModem(const ModemDetailFile,
  ModemName: string): Integer;
  { deletes a modem from the modem detail file }
var
  MemStream : TMemoryStream;
  S : string;
  Found : Boolean;
  ModemStart, ModemEnd : Integer;
begin
  DetailStream := nil;
  MemStream := nil;
  try
    ModemStart := 0;
    ModemEnd := 0;
    if not FileExists(ModemDetailFile) then begin
      Result := ecFileNotFound;
      Exit;
    end;
    { load the original detail file in a memory stream so we can write }
    { it out later }
    MemStream := TMemoryStream.Create;
    MemStream.LoadFromFile(ModemDetailFile);
    { search for the beginning of the modem element }
    repeat
      S := string(ReadLine);
      { save the beginning of the entity }
      if (Pos('<Modem', S) > 0) and (Pos('<ModemList', S) = 0) then
        ModemStart := MemStream.Position - Length(S);
      Found := (Pos('FriendlyName =', S) > 0) and
               (Pos(ModemName, UnXMLize(AnsiString(S))) > 0);
    until Found or (MemStream.Position >= MemStream.Size);
    if not Found then begin
      Result := ecModemNotFound;
      Exit;
    end;
    { now, search for the end of the modem element }
    repeat
      S := string(ReadLine);
      Found := Pos('</Modem>', S) > 0;
      if Found then
        ModemEnd := MemStream.Position;
    until Found or (MemStream.Position >= MemStream.Size);
    if not Found then begin
      Result := ecDiskRead;
      Exit;
    end;
    { now we can remove the block between ModemStart and ModemEnd }
    try
      { delete the original file }
      DeleteFile(ModemDetailFile);
      { create it }
      DetailStream := TFileStream.Create(ModemDetailFile, fmCreate);
      DetailStream.Position := 0;
      MemStream.Position := 0;
      { copy the first part }
      DetailStream.CopyFrom(MemStream, ModemStart);
      { copy the latter part }
      MemStream.Position := ModemEnd;
      DetailStream.CopyFrom(MemStream, MemStream.Size - ModemEnd);
    finally
      DetailStream.Free;
      DetailStream := nil;
    end;
    Result := ecOK;
  finally
    MemStream.Free;
  end;
end;

function TApdModemCapDetail.DeleteModemRecord(
  const ModemCapIndex : string; ModemRecord: TLmModemName): Integer;
  { delete a modem from the modemcap index }
  { again, it's faster to do it with a TStringList }
var
  List : TStringList;
  I : Integer;
  Found : Boolean;
  S : string;
begin
  Result := ecFileNotFound;
  if FileExists(ModemCapIndex) then begin
    List := nil;
    try
      List := TStringList.Create;
      List.LoadFromFile(ModemCapIndex);
      { find the modem }
      I := 0;
      Found := False;
      while not Found do begin
        S := 'ModemName = "' + ModemRecord.ModemName + '" Manufacturer = "' +
          ModemRecord.Manufacturer + '" Model = "' + ModemRecord.Model;
        Found := Pos(S, List[I]) > 0;
        if not Found then begin
          inc(I);
          if I >= List.Count then begin
            Result := ecModemNotFound;
            Exit;
          end;
        end;
      end;
      { found the modem, delete it }
      List.Delete(I);
      { find the last modem record }
      I := pred(List.Count);
      while (Pos('<ModemRecord ModemName = "', List[I]) = 0) and (I > 0) do begin
        List.Delete(I);
        dec(I);
      end;
      FixupModemcap(List);
      List.SaveToFile(ModemCapIndex);
      Result := ecOK;
    finally
      List.Free;
    end;
  end;
end;

destructor TApdModemCapDetail.Destroy;
begin
  if Assigned(DetailStream) then
    DetailStream.Free;
  inherited;
end;

function TApdModemCapDetail.ExportDetailXML(Modem: TLmModem): Integer;
var
  I : Integer;
begin
  try
    WriteLine('  <Modem');
    WriteLine('    FriendlyName = "' + XMLize(Modem.FriendlyName) + '"');
    WriteLine('    Manufacturer = "' + XMLize(Modem.Manufacturer) + '"');
    WriteLine('    Model = "' + XMLize(Modem.Model) + '"');
    WriteLine('    Reset = "' + XMLize(Modem.Reset) + '"');
    WriteLine('    ForwardDelay = "' + XMLizeInt(Modem.ForwardDelay) + '"');
    WriteLine('    VariableTerminator = "' + XMLize(Modem.VariableTerminator) + '"');
    WriteLine('    CallSetupFailTimeout = "' + XMLizeInt(Modem.CallSetupFailTimeout) + '"');
    WriteLine('    InactivityTimeout = "' + XMLizeInt(Modem.InactivityTimeout) + '"');
    WriteLine('    SupportsWaitForBongTone = "' + XMLizeBool(Modem.SupportsWaitForBongTone) + '"');
    WriteLine('    SupportsWaitForQuiet = "' + XMLizeBool(Modem.SupportsWaitForQuiet) + '"');
    WriteLine('    SupportsWaitForDialTone = "' + XMLizeBool(Modem.SupportsWaitForDialTone) + '"');
    WriteLine('    SupportsSpeakerVolumeLow = "' + XMLizeBool(Modem.SupportsSpeakerVolumeLow) + '"');
    WriteLine('    SupportsSpeakerVolumeMed = "' + XMLizeBool(Modem.SupportsSpeakerVolumeMed) + '"');
    WriteLine('    SupportsSpeakerVolumeHigh = "' + XMLizeBool(Modem.SupportsSpeakerVolumeHigh) + '"');
    WriteLine('    SupportsSpeakerModeOff = "' + XMLizeBool(Modem.SupportsSpeakerModeOff) + '"');
    WriteLine('    SupportsSpeakerModeDial = "' + XMLizeBool(Modem.SupportsSpeakerModeDial) + '"');
    WriteLine('    SupportsSpeakerModeOn = "' + XMLizeBool(Modem.SupportsSpeakerModeOn) + '"');
    WriteLine('    SupportsSpeakerModeSetup = "' + XMLizeBool(Modem.SupportsSpeakerModeSetup) + '"');
    WriteLine('    SupportsSetDataCompressionNegot = "' + XMLizeBool(Modem.SupportsSetDataCompressionNegot) + '"');
    WriteLine('    SupportsSetErrorControlProtNegot = "' + XMLizeBool(Modem.SupportsSetErrorControlProtNegot) + '"');
    WriteLine('    SupportsSetForcedErrorControl = "' + XMLizeBool(Modem.SupportsSetForcedErrorControl) + '"');
    WriteLine('    SupportsSetCellular = "' + XMLizeBool(Modem.SupportsSetCellular) + '"');
    WriteLine('    SupportsSetHardwareFlowControl = "' + XMLizeBool(Modem.SupportsSetHardwareFlowControl) + '"');
    WriteLine('    SupportsSetSoftwareFlowControl = "' + XMLizeBool(Modem.SupportsSetSoftwareFlowControl) + '"');
    WriteLine('    SupportsCCITTBellToggle = "' + XMLizeBool(Modem.SupportsCCITTBellToggle) + '"');
    WriteLine('    SupportsSetSpeedNegotiation = "' + XMLizeBool(Modem.SupportsSetSpeedNegotiation) + '"');
    WriteLine('    SupportsSetTonePulse = "' + XMLizeBool(Modem.SupportsSetTonePulse) + '"');
    WriteLine('    SupportsBlindDial = "' + XMLizeBool(Modem.SupportsBlindDial) + '"');
    WriteLine('    SupportsSetV21V23 = "' + XMLizeBool(Modem.SupportsSetV21V23) + '"');
    WriteLine('    SupportsModemDiagnostics = "' + XMLizeBool(Modem.SupportsModemDiagnostics) + '"');
    WriteLine('    MaxDTERate = "' + XMLizeInt(Modem.MaxDTERate) + '"');
    WriteLine('    MaxDCERate = "' + XMLizeInt(Modem.MaxDCERate) + '"');
    WriteLine('    PowerDelay = "' + XMLizeInt(Modem.PowerDelay) + '"');
    WriteLine('    ConfigDelay = "' + XMLizeInt(Modem.ConfigDelay) + '">');

    { responses }
    with Modem.Responses do begin
      WriteLine('    <Responses>');
      for I := 0 to pred(OK.Count) do
        WriteXMLStr('      <OKResponses>', PLmResponseData(OK[I]).Response);
      for I := 0 to pred(NegotiationProgress.Count) do
        WriteXMLStr('      <NegotiationProgressResponses>', PLmResponseData(NegotiationProgress[I]).Response);
      for I := 0 to pred(Connect.Count) do
        WriteXMLStr('      <ConnectResponses>', PLmResponseData(Connect[I]).Response);
      for I := 0 to pred(Error.Count) do
        WriteXMLStr('      <ErrorResponses>', PLmResponseData(Error[I]).Response);
      for I := 0 to pred(NoCarrier.Count) do
        WriteXMLStr('      <NoCarrierResponses>', PLmResponseData(NoCarrier[I]).Response);
      for I := 0 to pred(NoDialtone.Count) do
        WriteXMLStr('      <NoDialToneResponses>', PLmResponseData(NoDialTone[I]).Response);
      for I := 0 to pred(Busy.Count) do
        WriteXMLStr('      <BusyResponses>', PLmResponseData(Busy[I]).Response);
      for I := 0 to pred(NoAnswer.Count) do
        WriteXMLStr('      <NoAnswerResponses>', PLmResponseData(NoAnswer[I]).Response);
      for I := 0 to pred(Ring.Count) do
        WriteXMLStr('      <RingResponses>', PLmResponseData(Ring[I]).Response);
      for I := 0 to pred(VoiceView1.Count) do
        WriteXMLStr('      <VoiceView1Responses>', PLmResponseData(VoiceView1[I]).Response);
      for I := 0 to pred(VoiceView2.Count) do
        WriteXMLStr('      <VoiceView2Responses>', PLmResponseData(VoiceView2[I]).Response);
      for I := 0 to pred(VoiceView3.Count) do
        WriteXMLStr('      <VoiceView3Responses>', PLmResponseData(VoiceView3[I]).Response);
      for I := 0 to pred(VoiceView4.Count) do
        WriteXMLStr('      <VoiceView4Responses>', PLmResponseData(VoiceView4[I]).Response);
      for I := 0 to pred(VoiceView5.Count) do
        WriteXMLStr('      <VoiceView5Responses>', PLmResponseData(VoiceView5[I]).Response);
      for I := 0 to pred(VoiceView6.Count) do
        WriteXMLStr('      <VoiceView6Responses>', PLmResponseData(VoiceView6[I]).Response);
      for I := 0 to pred(VoiceView7.Count) do
        WriteXMLStr('      <VoiceView7Responses>', PLmResponseData(VoiceView7[I]).Response);
      for I := 0 to pred(VoiceView8.Count) do
        WriteXMLStr('      <VoiceView8Responses>', PLmResponseData(VoiceView8[I]).Response);
      for I := 0 to pred(RingDuration.Count) do
        WriteXMLStr('      <RingDurationResponses>', PLmResponseData(RingDuration[I]).Response);
      for I := 0 to pred(RingBreak.Count) do
        WriteXMLStr('      <RingBreakResponses>', PLmResponseData(RingBreak[I]).Response);
      for I := 0 to pred(Date.Count) do
        WriteXMLStr('      <DateResponses>', PLmResponseData(Date[I]).Response);
      for I := 0 to pred(Time.Count) do
        WriteXMLStr('      <TimeResponses>', PLmResponseData(Time[I]).Response);
      for I := 0 to pred(Number.Count) do
        WriteXMLStr('      <NumberResponses>', PLmResponseData(Number[I]).Response);
      for I := 0 to pred(Name.Count) do
        WriteXMLStr('      <NameResponses>', PLmResponseData(Name[I]).Response);
      for I := 0 to pred(Msg.Count) do
        WriteXMLStr('      <MsgResponses>', PLmResponseData(Msg[I]).Response);
      for I := 0 to pred(SingleRing.Count) do
        WriteXMLStr('      <SingleRingResponses>', PLmResponseData(SingleRing[I]).Response);
      for I := 0 to pred(DoubleRing.Count) do
        WriteXMLStr('      <DoubleRingResponses>', PLmResponseData(DoubleRing[I]).Response);
      for I := 0 to pred(TripleRing.Count) do
        WriteXMLStr('      <TripleRingResponses>', PLmResponseData(TripleRing[I]).Response);
      for I := 0 to pred(Voice.Count) do
        WriteXMLStr('      <VoiceResponses>', PLmResponseData(Voice[I]).Response);
      for I := 0 to pred(Fax.Count) do
        WriteXMLStr('      <FaxResponses>', PLmResponseData(Fax[I]).Response);
      for I := 0 to pred(Data.Count) do
        WriteXMLStr('      <DataResponses>', PLmResponseData(Data[I]).Response);
      for I := 0 to pred(Other.Count) do
        WriteXMLStr('      <OtherResponses>', PLmResponseData(Other[I]).Response);
      WriteLine('    </Responses>');
    end;

    for I := 0 to pred(Modem.Answer.Count) do
      WriteLine('    <Answer Sequence = "' + XMLizeInt(PLmModemCommand(Modem.Answer[I]).Sequence) +
        '">' + XMLize(PLmModemCommand(Modem.Answer[I]).Command) + '</Answer>');

    { fax stuff }
    with Modem.FaxDetails do begin
      WriteLine('    <FaxDetails');
      WriteLine('      ExitCommand = "' + XMLize(ExitCommand) + '"');
      WriteLine('      PreAnswerCommand = "' + XMLize(PreAnswerCommand) + '"');
      WriteLine('      PreDialCommand = "' + XMLize(PreDialCommand) + '"');
      WriteLine('      ResetCommand = "' + XMLize(ResetCommand) + '"');
      WriteLine('      SetupCommand = "' + XMLize(SetupCommand) + '"');
      WriteLine('      EnableV17Recv = "' + XMLize(EnableV17Recv) + '"');
      WriteLine('      EnableV17Send = "' + XMLize(EnableV17Send) + '"');
      WriteLine('      FixModemClass = "' + XMLize(FixModemClass) + '"');
      WriteLine('      FixSerialSpeed = "' + XMLize(FixSerialSpeed) + '"');
      WriteLine('      HighestSendSpeed = "' + XMLize(HighestSendSpeed) + '"');
      WriteLine('      LowestSendSpeed = "' + XMLize(LowestSendSpeed) + '"');
      WriteLine('      HardwareFlowControl = "' + XMLize(HardwareFlowControl) + '"');
      WriteLine('      SerialSpeedInit = "' + XMLize(SerialSpeedInit) + '"');
      WriteLine('      Cl1FCS = "' + XMLize(Cl1FCS) + '"');
      WriteLine('      Cl2DC2 = "' + XMLize(Cl2DC2) + '"');
      WriteLine('      Cl2lsEx = "' + XMLize(Cl2lsEx) + '"');
      WriteLine('      Cl2RecvBOR = "' + XMLize(Cl2RecvBOR) + '"');
      WriteLine('      Cl2SendBOR = "' + XMLize(Cl2SendBOR) + '"');
      WriteLine('      Cl2SkipCtrlQ = "' + XMLize(Cl2SkipCtrlQ) + '"');
      WriteLine('      Cl2SWBOR = "' + XMLize(Cl2SWBOR) + '"');
      WriteLine('      Class2FlowOff = "' + XMLize(Class2FlowOff) + '"');
      WriteLine('      Class2FlowHW = "' + XMLize(Class2FlowHW) + '"');
      WriteLine('      Class2FlowSW = "' + XMLize(Class2FlowSW) + '"');
      WriteLine('>');
      with FaxClass1 do begin
        WriteLine('      <Class1>');
        WriteLine('        ModemResponseFaxDetect = "' + XMLize(ModemResponseFaxDetect) + '"');
        WriteLine('        ModemResponseDataDetect = "' + XMLize(ModemResponseDataDetect) + '"');
        WriteLine('        SerialSpeedFaxDetect = "' + XMLize(SerialSpeedFaxDetect) + '"');
        WriteLine('        SerialSpeedDataDetect = "' + XMLize(SerialSpeedDataDetect) + '"');
        WriteLine('        HostCommandFaxDetect = "' + XMLize(HostCommandFaxDetect) + '"');
        WriteLine('        HostCommandDataDetect = "' + XMLize(HostCommandDataDetect) + '"');
        WriteLine('        ModemResponseFaxConnect = "' + XMLize(ModemResponseFaxConnect) + '"');
        WriteLine('        ModemResponseDataConnect = "' + XMLize(ModemResponseDataConnect) + '"');
        for I := 0 to pred(AnswerCommand.Count) do
          WriteLine('        <AnswerCommand Sequence = "' + XMLizeInt(PLmModemCommand(AnswerCommand[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(AnswerCommand[I]).Command) + '</AnswerCommand>');
        WriteLine('      </Class1>');
      end;
      with FaxClass2 do begin
        WriteLine('      <Class2>');
        WriteLine('        ModemResponseFaxDetect = "' + XMLize(ModemResponseFaxDetect) + '"');
        WriteLine('        ModemResponseDataDetect = "' + XMLize(ModemResponseDataDetect) + '"');
        WriteLine('        SerialSpeedFaxDetect = "' + XMLize(SerialSpeedFaxDetect) + '"');
        WriteLine('        SerialSpeedDataDetect = "' + XMLize(SerialSpeedDataDetect) + '"');
        WriteLine('        HostCommandFaxDetect = "' + XMLize(HostCommandFaxDetect) + '"');
        WriteLine('        HostCommandDataDetect = "' + XMLize(HostCommandDataDetect) + '"');
        WriteLine('        ModemResponseFaxConnect = "' + XMLize(ModemResponseFaxConnect) + '"');
        WriteLine('        ModemResponseDataConnect = "' + XMLize(ModemResponseDataConnect) + '"');
        for I := 0 to pred(AnswerCommand.Count) do
          WriteLine('    <AnswerCommand Sequence = "' + XMLizeInt(PLmModemCommand(AnswerCommand[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(AnswerCommand[I]).Command) + '</AnswerCommand>');
        WriteLine('      </Class2>');
      end;
      with FaxClass2_0 do begin
        WriteLine('      <Class2_0>');
        WriteLine('        ModemResponseFaxDetect = "' + XMLize(ModemResponseFaxDetect) + '"');
        WriteLine('        ModemResponseDataDetect = "' + XMLize(ModemResponseDataDetect) + '"');
        WriteLine('        SerialSpeedFaxDetect = "' + XMLize(SerialSpeedFaxDetect) + '"');
        WriteLine('        SerialSpeedDataDetect = "' + XMLize(SerialSpeedDataDetect) + '"');
        WriteLine('        HostCommandFaxDetect = "' + XMLize(HostCommandFaxDetect) + '"');
        WriteLine('        HostCommandDataDetect = "' + XMLize(HostCommandDataDetect) + '"');
        WriteLine('        ModemResponseFaxConnect = "' + XMLize(ModemResponseFaxConnect) + '"');
        WriteLine('        ModemResponseDataConnect = "' + XMLize(ModemResponseDataConnect) + '"');
        for I := 0 to pred(AnswerCommand.Count) do
          WriteLine('    <AnswerCommand Sequence = "' + XMLizeInt(PLmModemCommand(AnswerCommand[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(AnswerCommand[I]).Command) + '</AnswerCommand>');
        WriteLine('      </Class2_0>');
      end;
      WriteLine('    </FaxDetails>');
    end;

    with Modem.Voice do begin
      WriteLine('    <Voice');
      WriteLine('      VoiceProfile = "' + XMLize(VoiceProfile) + '"');
      WriteLine('      HandsetCloseDelay = "' + XMLizeInt(HandsetCloseDelay) + '"');
      WriteLine('      SpeakerPhoneSpecs = "' + XMLize(SpeakerPhoneSpecs) + '"');
      WriteLine('      AbortPlay = "' + XMLize(AbortPlay) + '"');
      WriteLine('      CallerIDOutSide = "' + XMLize(CallerIDOutSide) + '"');
      WriteLine('      CallerIDPrivate = "' + XMLize(CallerIDPrivate) + '"');
      WriteLine('      TerminatePlay = "' + XMLize(TerminatePlay) + '"');
      WriteLine('      TerminateRecord = "' + XMLize(TerminateRecord) + '"');
      WriteLine('      VoiceManufacturerID = "' + XMLize(VoiceManufacturerID) + '"');
      WriteLine('      VoiceProductIDWaveIn = "' + XMLize(VoiceProductIDWaveIn) + '"');
      WriteLine('      VoiceProductIDWaveOut = "' + XMLize(VoiceProductIDWaveOut) + '"');
      WriteLine('      VoiceSwitchFeatures = "' + XMLize(VoiceSwitchFeatures) + '"');
      WriteLine('      VoiceBaudRate = "' + XMLizeInt(VoiceBaudRate) + '"');
      WriteLine('      VoiceMixerMid = "' + XMLize(VoiceMixerMid) + '"');
      WriteLine('      VoiceMixerPid = "' + XMLize(VoiceMixerPid) + '"');
      WriteLine('      VoiceMixerLineID = "' + XMLize(VoiceMixerLineID) + '"');
      WriteLine('>');

      for I := 0 to pred(CloseHandset.Count) do
          WriteLine('    <CloseHandset Sequence = "' + XMLizeInt(PLmModemCommand(CloseHandset[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(CloseHandset[I]).Command) + '</CloseHandset>');
      for I := 0 to pred(EnableCallerID.Count) do
          WriteLine('    <EnableCallerID Sequence = "' + XMLizeInt(PLmModemCommand(EnableCallerID[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(EnableCallerID[I]).Command) + '</EnableCallerID>');
      for I := 0 to pred(EnableDistinctiveRing.Count) do
          WriteLine('    <EnableDistinctiveRing Sequence = "' + XMLizeInt(PLmModemCommand(EnableDistinctiveRing[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(EnableDistinctiveRing[I]).Command) + '</EnableDistinctiveRing>');
      for I := 0 to pred(GenerateDigit.Count) do
          WriteLine('    <GenerateDigit Sequence = "' + XMLizeInt(PLmModemCommand(GenerateDigit[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(GenerateDigit[I]).Command) + '</GenerateDigit>');
      for I := 0 to pred(HandsetPlayFormat.Count) do
          WriteLine('    <HandsetPlayFormat Sequence = "' + XMLizeInt(PLmModemCommand(HandsetPlayFormat[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(HandsetPlayFormat[I]).Command) + '</HandsetPlayFormat>');
      for I := 0 to pred(HandsetRecordFormat.Count) do
          WriteLine('    <HandsetRecordFormat Sequence = "' + XMLizeInt(PLmModemCommand(HandsetRecordFormat[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(HandsetRecordFormat[I]).Command) + '</HandsetRecordFormat>');
      for I := 0 to pred(LineSetPlayFormat.Count) do
          WriteLine('    <LineSetPlayFormat Sequence = "' + XMLizeInt(PLmModemCommand(LineSetPlayFormat[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(LineSetPlayFormat[I]).Command) + '</LineSetPlayFormat>');
      for I := 0 to pred(LineSetRecordFormat.Count) do
          WriteLine('    <LineSetRecordFormat Sequence = "' + XMLizeInt(PLmModemCommand(LineSetRecordFormat[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(LineSetRecordFormat[I]).Command) + '</LineSetRecordFormat>');
      for I := 0 to pred(OpenHandset.Count) do
          WriteLine('    <OpenHandset Sequence = "' + XMLizeInt(PLmModemCommand(OpenHandset[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(OpenHandset[I]).Command) + '</OpenHandset>');
      for I := 0 to pred(SpeakerPhoneDisable.Count) do
          WriteLine('    <SpeakerPhoneDisable Sequence = "' + XMLizeInt(PLmModemCommand(SpeakerPhoneDisable[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(SpeakerPhoneDisable[I]).Command) + '</SpeakerPhoneDisable>');
      for I := 0 to pred(SpeakerPhoneEnable.Count) do
          WriteLine('    <SpeakerPhoneEnable Sequence = "' + XMLizeInt(PLmModemCommand(SpeakerPhoneEnable[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(SpeakerPhoneEnable[I]).Command) + '</SpeakerPhoneEnable>');
      for I := 0 to pred(SpeakerPhoneMute.Count) do
          WriteLine('    <SpeakerPhoneMute Sequence = "' + XMLizeInt(PLmModemCommand(SpeakerPhoneMute[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(SpeakerPhoneMute[I]).Command) + '</SpeakerPhoneMute>');
      for I := 0 to pred(SpeakerPhoneSetVolumeGain.Count) do
          WriteLine('    <SpeakerPhoneSetVolumeGain Sequence = "' + XMLizeInt(PLmModemCommand(SpeakerPhoneSetVolumeGain[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(SpeakerPhoneSetVolumeGain[I]).Command) + '</SpeakerPhoneSetVolumeGain>');
      for I := 0 to pred(SpeakerPhoneUnMute.Count) do
          WriteLine('    <SpeakerPhoneUnMute Sequence = "' + XMLizeInt(PLmModemCommand(SpeakerPhoneUnMute[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(SpeakerPhoneUnMute[I]).Command) + '</SpeakerPhoneUnMute>');
      for I := 0 to pred(StartPlay.Count) do
          WriteLine('    <StartPlay Sequence = "' + XMLizeInt(PLmModemCommand(StartPlay[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(StartPlay[I]).Command) + '</StartPlay>');
      for I := 0 to pred(StartRecord.Count) do
          WriteLine('    <StartRecord Sequence = "' + XMLizeInt(PLmModemCommand(StartRecord[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(StartRecord[I]).Command) + '</StartRecord>');
      for I := 0 to pred(StopPlay.Count) do
          WriteLine('    <StopPlay Sequence = "' + XMLizeInt(PLmModemCommand(StopPlay[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(StopPlay[I]).Command) + '</StopPlay>');
      for I := 0 to pred(StopRecord.Count) do
          WriteLine('    <StopRecord Sequence = "' + XMLizeInt(PLmModemCommand(StopRecord[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(StopRecord[I]).Command) + '</StopRecord>');
      for I := 0 to pred(VoiceAnswer.Count) do
          WriteLine('    <VoiceAnswer Sequence = "' + XMLizeInt(PLmModemCommand(VoiceAnswer[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(VoiceAnswer[I]).Command) + '</VoiceAnswer>');
      for I := 0 to pred(VoiceDialNumberSetup.Count) do
          WriteLine('    <VoiceDialNumberSetup Sequence = "' + XMLizeInt(PLmModemCommand(VoiceDialNumberSetup[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(VoiceDialNumberSetup[I]).Command) + '</VoiceDialNumberSetup>');
      for I := 0 to pred(VoiceToDataAnswer.Count) do
          WriteLine('    <VoiceToDataAnswer Sequence = "' + XMLizeInt(PLmModemCommand(VoiceToDataAnswer[I]).Sequence) +
            '">' + XMLize(PLmModemCommand(VoiceToDataAnswer[I]).Command) + '</VoiceToDataAnswer>');

      with WaveDriver do begin
        WriteLine('      <WaveDriver>');
        WriteLine('        BaudRate = "' + XMLize(  BaudRate) + '"');
        WriteLine('        WaveHardwareID = "' + XMLize(WaveHardwareID) + '"');
        WriteLine('        WaveDevices = "' + XMLize(WaveDevices) + '"');
        WriteLine('        LowerMid = "' + XMLize(LowerMid) + '"');
        WriteLine('        LowerWaveInPid = "' + XMLize(LowerWaveInPid) + '"');
        WriteLine('        LowerWaveOutPid = "' + XMLize(LowerWaveOutPid) + '"');
        WriteLine('        WaveOutMixerDest = "' + XMLize(WaveOutMixerDest) + '"');
        WriteLine('        WaveOutMixerSource = "' + XMLize(WaveOutMixerSource) + '"');
        WriteLine('        WaveInMixerDest = "' + XMLize(WaveInMixerDest) + '"');
        WriteLine('        WaveInMixerSource = "' + XMLize(WaveInMixerSource) + '"');

        for I := 0 to pred(WaveFormat.Count) do
          WriteLine('        <WaveFormat ChipSet = "' + PLmWaveFormat(WaveFormat[I]).Chipset
            + '" Speed = "' + PLmWaveFormat(WaveFormat[I]).Speed
            + '" SampleSize = "' + PLmWaveFormat(WaveFormat[I]).SampleSize
            + '"/>');
        WriteLine('      </WaveDriver>');
      end;
      WriteLine('    </Voice>');
    end;

    for I := 0 to pred(Modem.Hangup.Count) do
      WriteLine('    <Hangup Sequence = "' + XMLizeInt(PLmModemCommand(Modem.Hangup[I]).Sequence) +
        '">' + XMLize(PLmModemCommand(Modem.Hangup[I]).Command) + '</Hangup>');

    for I := 0 to pred(Modem.Init.Count) do
      WriteLine('    <Init Sequence = "' + XMLizeInt(PLmModemCommand(Modem.Init[I]).Sequence) +
        '">' + XMLize(PLmModemCommand(Modem.Init[I]).Command) + '</Init>');

    for I := 0 to pred(Modem.Monitor.Count) do
      WriteLine('    <Monitor Sequence = "' + XMLizeInt(PLmModemCommand(Modem.Monitor[I]).Sequence) +
        '">' + XMLize(string(PLmModemCommand(Modem.Monitor[I]).Command)) + '</Monitor>');

    with Modem.Settings do begin
      WriteLine('    <Settings');
      WriteLine('      Prefix = "' + XMLize(Prefix) + '"');
      WriteLine('      Terminator = "' + XMLize(Terminator) + '"');
      WriteLine('      DialPrefix = "' + XMLize(DialPrefix) + '"');
      WriteLine('      DialSuffix = "' + XMLize(DialSuffix) + '"');
      WriteLine('      SpeakerVolume_High = "' + XMLize(SpeakerVolume_High) + '"');
      WriteLine('      SpeakerVolume_Low = "' + XMLize(SpeakerVolume_Low) + '"');
      WriteLine('      SpeakerVolume_Med = "' + XMLize(SpeakerVolume_Med) + '"');
      WriteLine('      SpeakerMode_Dial = "' + XMLize(SpeakerMode_Dial) + '"');
      WriteLine('      SpeakerMode_Off = "' + XMLize(SpeakerMode_Off) + '"');
      WriteLine('      SpeakerMode_On = "' + XMLize(SpeakerMode_On) + '"');
      WriteLine('      SpeakerMode_Setup = "' + XMLize(SpeakerMode_Setup) + '"');
      WriteLine('      FlowControl_Hard = "' + XMLize(FlowControl_Hard) + '"');
      WriteLine('      FlowControl_Off = "' + XMLize(FlowControl_Off) + '"');
      WriteLine('      FlowControl_Soft = "' + XMLize(FlowControl_Soft) + '"');
      WriteLine('      ErrorControl_Forced = "' + XMLize(ErrorControl_Forced) + '"');
      WriteLine('      ErrorControl_Off = "' + XMLize(ErrorControl_Off) + '"');
      WriteLine('      ErrorControl_On = "' + XMLize(ErrorControl_On) + '"');
      WriteLine('      ErrorControl_Cellular = "' + XMLize(ErrorControl_Cellular) + '"');
      WriteLine('      ErrorControl_Cellular_Forced = "' + XMLize(ErrorControl_Cellular_Forced) + '"');
      WriteLine('      Compression_Off = "' + XMLize(Compression_Off) + '"');
      WriteLine('      Compression_On = "' + XMLize(Compression_On) + '"');
      WriteLine('      Modulation_Bell = "' + XMLize(Modulation_Bell) + '"');
      WriteLine('      Modulation_CCITT = "' + XMLize(Modulation_CCITT) + '"');
      WriteLine('      Modulation_CCITT_V23 = "' + XMLize(Modulation_CCITT_V23) + '"');
      WriteLine('      SpeedNegotiation_On = "' + XMLize(SpeedNegotiation_On) + '"');
      WriteLine('      SpeedNegotiation_Off = "' + XMLize(SpeedNegotiation_Off) + '"');
      WriteLine('      Pulse = "' + XMLize(Pulse) + '"');
      WriteLine('      Tone = "' + XMLize(Tone) + '"');
      WriteLine('      Blind_Off = "' + XMLize(Blind_Off) + '"');
      WriteLine('      Blind_On = "' + XMLize(Blind_On) + '"');
      WriteLine('      CallSetupFailTimer = "' + XMLize(CallSetupFailTimer) + '"');
      WriteLine('      InactivityTimeout = "' + XMLize(InactivityTimeout) + '"');
      WriteLine('      CompatibilityFlags = "' + XMLize(CompatibilityFlags) + '"');
      WriteLine('      ConfigDelay = "' + XMLizeInt(ConfigDelay) + '"/>');
    end;

    with Modem.Hardware do begin
      WriteLine('    <Hardware>');
      WriteLine('      AutoConfigOverride = "' + XMLize(AutoConfigOverride) + '"');
      WriteLine('      ComPort = "' + XMLize(ComPort) + '"');
      WriteLine('      InvalidRDP = "' + XMLize(InvalidRDP) + '"');
      WriteLine('      IoBaseAddress = "' + XMLizeInt(IoBaseAddress) + '"');
      WriteLine('      InterruptNumber = "' + XMLizeInt(InterruptNumber) + '"');
      WriteLine('      PermitShare = "' + XMLizeBool(PermitShare) + '"');
      WriteLine('      RxFIFO = "' + XMLize(RxFIFO) + '"');
      WriteLine('      RxTxBufferSize = "' + XMLizeInt(RxTxBufferSize) + '"');
      WriteLine('      TxFIFO = "' + XMLize(TxFIFO) + '"');
      WriteLine('      Pcmcia = "' + XMLize(Pcmcia) + '"');
      WriteLine('      BusType = "' + XMLize(BusType) + '"');
      WriteLine('      PCCARDAttributeMemoryAddress = "' + XMLizeInt(PCCARDAttributeMemoryAddress) + '"');
      WriteLine('      PCCARDAttributeMemorySize = "' + XMLizeInt(PCCARDAttributeMemorySize) + '"');
      WriteLine('      PCCARDAttributeMemoryOffset = "' + XMLizeInt(PCCARDAttributeMemoryOffset) + '"');
      WriteLine('    </Hardware>');
    end;

    for I := 0 to pred(Modem.BaudRates.Count) do
      WriteXMLStr('    <BaudRates>', Modem.BaudRates[I]);

    for I := 0 to pred(Modem.Options.Count) do
      WriteXMLStr('    <Options>', Modem.Options[I]);


    WriteLine('  </Modem>');
    Result := ecOK;
  except
    Result := ecDeviceWrite;
  end;

end;

procedure TApdModemCapDetail.FixupModemcap(var List: TStringList);
  { calculate totals, sort and add modem detail file list }
const
  ModemFileStr = 'ModemFile = "';
var
  X, I : Integer;
  FileList : TStringList;
  S : string;
begin
  { count the modem records and file references... }
  X := pred(List.Count);
  I := X;
  FileList := nil;
  try
    FileList := TStringList.Create;
    FileList.Sorted := True;
    FileList.Duplicates := dupIgnore;
    while (System.Pos('<ModemRecord ModemName = "', List[X]) > 0) do begin
      S := System.Copy(List[X], ApxRPos(ModemFileStr, List[X]) + Length(ModemFileStr),
        Length(List[x]));
      S := System.Copy(S, 1, System.Pos('"', S) - 1);
      FileList.Add(S);
      dec(X);
    end;
    X := I - X;
    { ... and add the total line }
    S := '  <Totals Files = "' + SysUtils.IntToStr(FileList.Count) +
         '" Modems = "' + SysUtils.IntToStr(X) + '"/>';
    List.Add(S);
    { add the modem file list }
    List.Add('  <ModemFileList>');
    for I := 0 to pred(FileList.Count) do begin
      List.Add('    <ModemFile>' + FileList[I] + '</ModemFile>')
    end;
    List.Add('  </ModemFileList>');
    List.Add('</ModemCap>');
  finally
    FileList.Free;
  end;
end;

function TApdModemCapDetail.ReadLine : AnsiString;
  { a method to read a #13#10 terminated line from the stream }
var
  C : ansiChar;
begin
  Result := '';
  repeat
    DetailStream.ReadBuffer(C, 1);
    Result := Result + C;
  until (Pos(#13#10, Result) > 0) or (AtEOF);
end;

function TApdModemCapDetail.UnXMLize(const S: AnsiString): AnsiString;
  { a method to convert an XMLized string to a regular one }
var
  Psn : Integer;
begin
  { fix up the modemname with any XML stuff }
  Result := S;
  while Pos('&amp;', Result) > 0 do
    Delete(Result, Pos('&amp;', Result) + 1, 4);
  while Pos('&quot;', Result) > 0 do begin
    Psn := Pos('&quot;', Result);
    Delete(Result, Pos('&quot;', Result), 6);
    Insert('"', Result, Psn);
  end;
end;

procedure TApdModemCapDetail.WriteLine(const Str: ansistring);
  { a method to write a #13#10 terminated string to the stream }
  { no XML translations }
begin
  if Pos('""', Str) > 0 then
    { don't write entries without data }
    Exit;
  if Str = '>' then
    { it's a terminating '>', remove the preceding #13#10 }
    DetailStream.Position := DetailStream.Position - 2;
  DetailStream.WriteBuffer(Str[1], Length(Str));
  DetailStream.WriteBuffer(#13#10, 2);
end;

procedure TApdModemCapDetail.WriteLine(const Str: string);
begin
  WriteLine(AnsiString(Str));
end;

procedure TApdModemCapDetail.WriteXMLStr(const Str, sVal : string);
  { writes a string and another string, the first string is the }
  { start-end tag, the second is the value }
var
  S : string;
begin
  if sVal = '' then
    { nothing to add... }
    Exit;
  S := Str;
  while S[1] = ' ' do
    Delete(S, 1, 1);
  Assert(S[1] = '<', 'Need brackets ' + S);
  Insert('/', S, 2);
  WriteLine(Str + XMLize(sVal) + S);
end;

function TApdModemCapDetail.XMLize(const S: string): string;
  { a method to convert a regular string to an XML string }
var
  i : integer;
begin
  result := '';
  for i := 1 to Length (s) do
    case s[i] of
      '<' : result := result + '&lt;';
      '>' : result := result + '&gt;';
      {' ' : result := result + '&nbsp;';}
      '&' : result := result + '&amp;';
      '"' : result := result + '&quot;';
      else
        result := result + System.copy (s, i, 1);
    end;
end;

function TApdModemCapDetail.XMLizeInt(I: Integer): string;
  { numbers aren't escaped, just return the string }
begin
  Result := SysUtils.IntToStr(I);
end;

function TApdModemCapDetail.XMLizeBool(B: Boolean): string;
begin
  if B then
    Result := '1'
  else
    Result := '0';
end;

end.
