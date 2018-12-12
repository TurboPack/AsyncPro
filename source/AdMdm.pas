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
{*                    ADMDM.PAS 4.06                     *}
{*********************************************************}
{* TAdModem component                                    *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdMdm;

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
  OOMisc,
  AdPort,
  AdPacket,
  AdLibMdm,
  AdExcept,
  FileCtrl;

const
  ApxDefModemCapFolder = '';                                             {!!.04}
  ApxDefModemStatusCaption = 'Modem status';
  ApxDefOKResponse = 'OK'#13#10;
  ApxDefErrorResponse = 'ERROR'#13#10;
  ApxDefBusyResponse = 'BUSY'#13#10;
  ApxDefConnectResponse = 'CONNECT';
  ApxDefRingResponse = 'RING'#13#10;
  ApxDefModemEscape = '+++';
  ApxDefAnswerCommand = 'ATA'#13;
  ApxDefHangupCmd = 'ATH0'#13;
  ApxDefCommandTimeout = 30000;  { 30 second timeout waiting for modem to respond }
  ApxDefConnectTimeout = 60000;  { 60 second timeout waiting for modems to negotiate }
  ApxDefDTRTimeout = 1000;       { 1 second timeout for the modem to hangup after dropping DTR }
  ApxModemConfigVersion = '1.00';

type
  { predefine our class }
  TAdCustomModem = class;
  TAdAbstractModemStatus = class;

  TApdModemState = (
    msUnknown,               { Hasn't been initialized }
    msIdle,                  { Idle and ready }
    msInitializing,          { Starting initialization process }
    msAutoAnswerBackground,  { AutoAnswer, no rings received }
    msAutoAnswerWait,        { AutoAnswer, waiting for Nth ring }
    msAnswerWait,            { Answering call, waiting for connect }
    msDial,                  { Sending Dial command }
    msConnectWait,           { Sent the Dial command, wait for connect }
    msConnected,             { Done with connection process }
    msHangup,                { Starting hangup process }
    msCancel                 { Starting cancel process }
  );

  TApdModemLogCode = (
    mlNone,                  { None, nothing to log }
    mlDial,                  { Dialing }
    mlAutoAnswer,            { Initiated AutoAnswer }
    mlAnswer,                { Answering an incoming call }
    mlConnect,               { Connected }
    mlCancel,                { Call cancelled }
    mlBusy,                  { Called number was busy }
    mlConnectFail            { Connection attempt failed }
  );

  { used for the UpdateStatus method }
  TApdModemStatusAction = (
    msaStart,                { first time status display (clears everything) }
    msaClose,                { last time, cleans up }
    msaUpdate,               { normal updating }
    msaDetailReplace,        { replaces last line of details }
    msaClear                 { clears all details and adds DetailStr }
  );

  TApdModemSpeakerVolume = (svLow, svMed, svHigh);
  TApdModemSpeakerMode = (smOff, smOn, smDial);
  TApdModemFlowControl = (fcOff, fcHard, fcSoft);
  TApdModemErrorControl = (ecOff, ecOn, ecForced, ecCellular);
  TApdModemModulation = (smBell, smCCITT, smCCITT_V23);

  TApdModemConfig = record
    ConfigVersion : string[8];       { version tag to support future features }
    { port settings }
    AttachedTo : string[20];
    Manufacturer : string[100];
    ModemName : string[100];
    ModemModel : string[100];
    DataBits : Word;
    Parity : TParity;
    StopBits : Word;
    { speaker options }
    SpeakerVolume :  TApdModemSpeakerVolume;
    SpeakerMode : TApdModemSpeakerMode;
    { connection control }
    FlowControl : TApdModemFlowControl;
    ErrorControl : set of TApdModemErrorControl;
    Compression : Boolean;
    Modulation : TApdModemModulation;
    ToneDial : Boolean;
    BlindDial : Boolean;
    CallSetupFailTimeout : Integer;
    InactivityTimeout : Integer;
    { extra commands }
    ExtraSettings : string[50];
    Padding : Array[81..128] of Byte;  { Expansion room }
  end;

  TApdModemNameProp = class(TPersistent)
  private
    FManufacturer: string;
    FName: string;
    FModemFile: string;
    procedure SetManufacturer(const Value: string);
    procedure SetName(const Value: string);
    procedure SetModemFile(const Value: string);
  public
    procedure Assign(Source: TPersistent); override;                     {!!.02}
    procedure Clear;                                                     {!!.02}

  published
    property Manufacturer : string
      read FManufacturer write SetManufacturer;
    property Name : string
      read FName write SetName;
    property ModemFile : string
      read FModemFile write SetModemFile;
  end;

  TApdCallerIDInfo = record
    HasData : Boolean;
    Date   : string;
    Time   : string;
    Number : string;
    Name   : string;
    Msg    : string;
  end;

  { event types }
  TModemCallerIDEvent = procedure(Modem : TAdCustomModem;
    CallerID : TApdCallerIDInfo) of object;
  TModemNotifyEvent = procedure(Modem : TAdCustomModem) of object;
  TModemFailEvent = procedure(Modem : TAdCustomModem; FailCode : Integer) of object;
  TModemLogEvent = procedure(Modem : TAdCustomModem;
    LogCode : TApdModemLogCode) of object;
  TModemStatusEvent = procedure(Modem : TAdCustomModem;
    ModemState : TApdModemState) of object;

  TAdCustomModem = class(TApdBaseComponent)
  private
    FAnswerOnRing: Integer;
    FBPSRate: DWORD;
    FComPort: TApdCustomComPort;
    FDialTimeout: Integer;
    FFailCode: Integer;
    FModemCapFolder: string;
    FRingWaitTimeout: DWORD;
    FRingCount: Integer;
    FStatusDisplay: TAdAbstractModemStatus;
    FSelectedDevice: TApdModemNameProp;
    FModemState: TApdModemState;
    FNegotiationResponses : TStringList;
    FOnModemCallerID: TModemCallerIDEvent;
    FOnModemLog: TModemLogEvent;
    FOnModemDisconnect: TModemNotifyEvent;
    FOnModemConnect: TModemNotifyEvent;
    FOnModemFail: TModemFailEvent;
    FOnModemStatus: TModemStatusEvent;
    FConnected: Boolean;
    FPhoneNumber: string;
    FStartTime : DWORD;
    FDeviceSelected: Boolean;                                     {!!.04}{!!.05}
    FModemConfig : TApdModemConfig;
    FCallerIDInfo : TApdCallerIDInfo;
    FHandle : THandle;
    { flag to indicate the state of the port, 0=not set, 1=closed, 2=open }
    FPortWasOpen : byte;                                                 {!!.05}
    FSavedOnTrigger : TTriggerEvent;                                     {!!.06}
    function GetElapsedTime : DWORD;
    function GetNegotiationResponses: TStringList;

    procedure SetAnswerOnRing(const Value: Integer);
    procedure SetComPort(const Value: TApdCustomComPort);
    procedure SetDialTimeout(const Value: Integer);
    procedure SetModemCapFolder(const Value: string);
    procedure SetRingWaitTimeout(const Value: DWORD);
    procedure SetSelectedDevice(const Value: TApdModemNameProp);
    procedure SetStatusDisplay(const Value: TAdAbstractModemStatus);
    function GetDeviceSelected: Boolean;                                 {!!.04}
    procedure PortOpenCloseEx(CP: TObject; CallbackType: TApdCallbackType);{!!.05}
     {- Extended event handler for the port open/close event}

  protected
    { Protected declarations }
    ResponsePacket : TApdDataPacket;
    Initialized : Boolean;
    PassthroughMode : Boolean;
    WaitingForResponse : Boolean;
    OKResponse : Boolean;
    ErrorResponse : Boolean;
    ConnectResponse : Boolean;
    TimedOut : Boolean;
    LastCommand : string;
    DcdTrigger : Word;
    StatusTimerTrigger : Word;
    FCallerIDProvided : Boolean;

    { opens port and ensures we are ready }
    procedure CheckReady;
    { generate the OnModemCallerID event }
    procedure DoCallerID;
    { generate the OnModemConnect event }
    procedure DoConnect;
    { generate the OnModemDisconnect event }
    procedure DoDisconnect;
    { generate the OnModemFail event }
    procedure DoFail(Failure : Integer);
    { generate the OnModemLog event }
    procedure DoLog(LogCode: TApdModemLogCode);
    { generate the OnModemStatus event }
    procedure DoStatus(NewModemState: TApdModemState);

    { initialize/configure the modem }
    procedure Initialize;

    { do stuff when other components are added to the form }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    { the AxModem message handler }
    procedure ModemMessage(var Message : TMessage);
    { add triggers to detect connection state }
    procedure PrepForConnect(EnableTriggers : Boolean);
    { detect modem responses }
    procedure ResponseStringPacket(Sender: TObject; Data: AnsiString);
    { detect timeouts }
    procedure ResponseTimeout(Sender : TObject);
    { status trigger notification event }
    {procedure TriggerEvent(CP: TObject; TriggerHandle: Word);}          {!!.06}
    procedure TriggerEvent(CP : TObject; Msg, TriggerHandle, Data: Word);{!!.06}
    { send all commands in the list }
    function SendCommands(Commands : TList) : Boolean;
    { check the responses for the response }
    function CheckResponses(const Response, DefResponse : string;
      Responses : TList) : Boolean;
    { check the response for any errors }
    function CheckErrors(const Response : string) : Integer;
    { check for the CallerID tags }
    procedure CheckCallerID(const Response  : string);
    { check <StandardConnect> response for extra info }
    function ParseStandardConnect(const Response : string): Boolean;      {!!.05}

    procedure ChangeResponseTimeout(aTimeout, aEnableTimeout: integer);   {!!.KINO}
  public
    { Public declarations }
    LmModem : TLmModem;
    LibModem : TApdLibModem;

    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    property AnswerOnRing : Integer
      read FAnswerOnRing write SetAnswerOnRing
      default 2;
    property BPSRate : DWORD
      read FBPSRate;
    property CallerIDInfo : TApdCallerIDInfo
      read FCallerIDInfo write FCallerIDInfo;
    property ComPort : TApdCustomComPort
      read FComPort write SetComPort;
    property Connected : Boolean
      read FConnected;
    property DeviceSelected : Boolean
      read GetDeviceSelected;                                            {!!.04}
    property DialTimeout : Integer
      read FDialTimeout write SetDialTimeout
      default 60;
    property ElapsedTime : DWORD
      read GetElapsedTime;
    property FailureCode : Integer
      read FFailCode;
    property Handle : THandle
      read FHandle;
    property ModemCapFolder : string
      read FModemCapFolder write SetModemCapFolder;
    property ModemState : TApdModemState
      read FModemState;
    property NegotiationResponses : TStringList
      read GetNegotiationResponses;
    property PhoneNumber : string
      read FPhoneNumber;
    property RingCount : Integer
      read FRingCount;
    property RingWaitTimeout : DWORD
      read FRingWaitTimeout write SetRingWaitTimeout
      default 1200;
    property SelectedDevice : TApdModemNameProp
      read FSelectedDevice write SetSelectedDevice;
    property StatusDisplay : TAdAbstractModemStatus
      read FStatusDisplay write SetStatusDisplay;

    procedure AutoAnswer;
    procedure CancelCall;
    procedure ConfigAndOpen;
    function DefaultDeviceConfig : TApdModemConfig;
    procedure Dial(const ANumber : string);
    function FailureCodeMsg(const FailureCode : Integer) : string;
    function GetDevConfig : TApdModemConfig;
    function ModemLogToString(LogCode : TApdModemLogCode) : string;
    function ModemStatusMsg(Status : TApdModemState) : string;
    function SelectDevice : Boolean;
    function SendCommand(const Command : string) : Boolean;
    procedure SetDevConfig(const Config : TApdModemConfig);
    function ShowConfigDialog : Boolean;

    { undocumented }
    function ConvertXML(const S : string) : string;
    function StripXML(const S : string) : string;                        {!!.04}

    property OnModemCallerID : TModemCallerIDEvent
      read FOnModemCallerID write FOnModemCallerID;
    property OnModemConnect : TModemNotifyEvent
      read FOnModemConnect write FOnModemConnect;
    property OnModemDisconnect : TModemNotifyEvent
      read FOnModemDisconnect write FOnModemDisconnect;
    property OnModemFail : TModemFailEvent
      read FOnModemFail write FOnModemFail;
    property OnModemLog : TModemLogEvent
      read FOnModemLog write FOnModemLog;
    property OnModemStatus : TModemStatusEvent
      read FOnModemStatus write FOnModemStatus;
  end;

  TAdModem = class(TAdCustomModem)
  published
    property AnswerOnRing;
    property ComPort;
    property DialTimeout;
    property ModemCapFolder;
    property RingWaitTimeout;
    property SelectedDevice;
    property StatusDisplay;

    property OnModemCallerID;
    property OnModemConnect;
    property OnModemDisconnect;
    property OnModemFail;
    property OnModemLog;
    property OnModemStatus;
  end;

  TAdAbstractModemStatus = class(TApdBaseComponent)
  private
    FStatusDialog: TForm;
    FCaption: string;
    FStarted: Boolean;
    FModem: TAdCustomModem;
    procedure SetCaption(const Value: string);
    procedure SetStarted(Start : Boolean);
    procedure SetModem(const Value: TAdCustomModem);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property StatusDialog : TForm
      read FStatusDialog write FStatusDialog;
    property Caption : string
      read FCaption write SetCaption;
    property Modem : TAdCustomModem
      read FModem write SetModem;
    property Started : Boolean
      read FStarted;
    procedure UpdateDisplay(Modem : TAdCustomModem;
      const StatusStr, TimeStr, DetailStr : string;
      Action : TApdModemStatusAction);
  end;

  TAdModemStatus = class(TAdAbstractModemStatus)
  published
    property Caption;
    property Modem;
  end;


implementation

uses
  AnsiStrings, AdAnsiStrings, AdMdmCfg, AdMdmDlg;

{ TApdModemNameProp }

procedure TApdModemNameProp.Assign(Source: TPersistent);                {!!.02}   
begin
  if Source is TApdModemNameProp then begin
    Clear;                                             
    {Property inits}
    FManufacturer := TApdModemNameProp(Source).FManufacturer;
    FName := TApdModemNameProp(Source).FName;
    FModemFile := TApdModemNameProp(Source).FModemFile;
  end;
end;

procedure TApdModemNameProp.Clear;                                       {!!.02}
  { clear the values }
begin
  FManufacturer := '';
  FModemFile := '';
  FName := '';
end;

procedure TApdModemNameProp.SetManufacturer(const Value: string);
  { write access method for Manufacturer property }
begin
  if FManufacturer <> Value then begin
    FManufacturer := Value;
  end;
end;

procedure TApdModemNameProp.SetModemFile(const Value: string);
begin
  FModemFile := Value;
end;

procedure TApdModemNameProp.SetName(const Value: string);
  { write access method for Name property }
begin
  FName := Value;
end;

{ TAdCustomModem }

procedure TAdCustomModem.ModemMessage(var Message: TMessage);
begin
  case Message.Msg of
    apw_AutoAnswer :
      begin
        { got the message to answer the call... }
        PrepForConnect(True);
        {$IFDEF AdModemDebug}
        FComPort.AddStringToLog('Answering');
        {$ENDIF}
        if not SendCommands(LmModem.Answer) then
          DoFail(ecModemRejectedCommand);
      end;
    apw_CancelCall :
      begin
        CancelCall;
      end;
    apw_StartDial :
      begin
        ResponsePacket.Enabled := True;
        if FModemConfig.ToneDial then                                    {!!.06}
          FComPort.OutputUni := ConvertXML(LmModem.Settings.Prefix +
                                        LMModem.Settings.DialPrefix +
                                        LmModem.Settings.Tone +          {!!.06}
                                        FPhoneNumber +
                                        LmModem.Settings.Terminator)
        else
          FComPort.OutputUni := ConvertXML(LmModem.Settings.Prefix +
                                        LMModem.Settings.DialPrefix +
                                        LmModem.Settings.Pulse +         {!!.06}
                                        FPhoneNumber +
                                        LmModem.Settings.Terminator);
        DoStatus(msConnectWait);
      end;
    else                                                                 {!!.02}
      try                                                                {!!.02}
        Dispatch(Message);                                               {!!.02}
        if Message.Msg = WM_QUERYENDSESSION then                         {!!.02}
          Message.Result := 1;                                           {!!.02}
      except                                                             {!!.02}
        Application.HandleException(Self);                               {!!.02}
      end;                                                               {!!.02}
  end;
end;

procedure TAdCustomModem.AutoAnswer;
  { initiate auto answer mode }
begin
  CheckReady;
  FCallerIDProvided := False;
  if not Initialized then
    Initialize;
  {$IFDEF AdModemDebug}
  FComPort.AddStringToLog('autoanswer for ' + IntToStr(FAnswerOnRing));
  {$ENDIF}
  { turn on the CallerID detection }
  SendCommands(LmModem.Voice.EnableCallerID);

  DoStatus(msAutoAnswerBackground);
  ChangeResponseTimeOut(0, 0);                                           {!!.KINO}
  //ResponsePacket.Timeout := 0;
  //ResponsePacket.EnableTimeout := 0;                                     {!!.04}
  ResponsePacket.Enabled := True;
end;

procedure TAdCustomModem.CancelCall;
  { cancel whatever we're doing, we'll keep the port open }
{var
  ET : EventTimer;}                                                      {!!.05}
var
  vLastState: TApdModemState;                                            {!!.KINO}
begin
  if not Assigned(FComPort) then                                         {!!.01}
    Exit;                                                                {!!.01}
  FCallerIDProvided := False;
  { save currente modem state }                                          {!!.KINO}
  vLastState := FModemState;                                             {!!.KINO}
  DoStatus(msCancel);
  {$IFDEF AdModemDebug}
  if Assigned(FComPort) then
    FComPort.AddStringToLog('cancel call');
  {$ENDIF}

  if Connected then begin
    DoStatus(msHangup);
    { try lowering DTR first }
    { section rewritten to use SendCommand }                             {!!.05}
    //if not SendCommand('<DTR>') then begin                             {!!.05}
      SendCommand(apxDefModemEscape);
      SendCommands(LmModem.Hangup);
    //end;                                                               {!!.05}
    { end rewrite }                                                      {!!.05}
  end else begin                                                         {!!.KINO}
    { Disable response waiting }                                         {!!.KINO}
    if vLastState in [msAutoAnswerWait, msAnswerWait, msConnectWait] then{!!.KINO}
       WaitingForResponse := False;                                      {!!.KINO}
    if vLastState in [msAnswerWait, msConnectWait] then                  {!!.KINO}
    { we've started answering/dialing, send a #13 to terminate that }
    SendCommand('');
  end;                                                                   {!!.KINO}
  PrepForConnect(False);
  DoDisconnect;

  { close the port if it was closed when we started }
  if FPortWasOpen = 1 then                                               {!!.05}
    FComPort.Open := False;                                              {!!.05}
  FPortWasOpen := 0;                                                     {!!.05}
  FConnected := False;
  LastCommand := '';                                                     {!!.05}
  if Initialized then
    DoStatus(msIdle)
  else
    DoStatus(msUnknown);
end;

procedure TAdCustomModem.CheckCallerID(const Response: string);
  { check for the CallerID tags }
var
  I,
  Psn : Integer;
  S : string;

  function CheckIt : Boolean;
  begin
    Psn := System.Pos(S, Response);
    if Psn > 0 then begin
      Result := True;
      S := System.Copy(Response, Psn + Length(S) + 1, Length(Response));
      S := System.Copy(S, 1, Length(S) - 2);
    end else
      Result := False;
  end;

begin
  if LmModem.Responses.Date.Count > 0 then
    for I := 0 to pred(LmModem.Responses.Date.Count) do begin
      S := ConvertXML(PLmResponseData(LmModem.Responses.Date[I]).Response);
      if CheckIt then begin
        FCallerIDInfo.HasData := True;
        FCallerIDInfo.Date := S;
      end;
    end;

  if LmModem.Responses.Time.Count > 0 then
    for I := 0 to pred(LmModem.Responses.Time.Count) do begin
      S := ConvertXML(PLmResponseData(LmModem.Responses.Time[I]).Response);
      if CheckIt then begin
        FCallerIDInfo.HasData := True;
        FCallerIDInfo.Time := S;
      end;
    end;

  if LmModem.Responses.Number.Count > 0 then
    for I := 0 to pred(LmModem.Responses.Number.Count) do begin
      S := ConvertXML(PLmResponseData(LmModem.Responses.Number[I]).Response);
      if CheckIt then begin
        FCallerIDInfo.HasData := True;
        FCallerIDInfo.Number := S;
      end;
    end;

  if LmModem.Responses.Name.Count > 0 then
    for I := 0 to pred(LmModem.Responses.Name.Count) do begin
      S := ConvertXML(PLmResponseData(LmModem.Responses.Name[I]).Response);
      if CheckIt then begin
        FCallerIDInfo.HasData := True;
        FCallerIDInfo.Name := S;
      end;
    end;

  if LmModem.Responses.Msg.Count > 0 then
    for I := 0 to pred(LmModem.Responses.Msg.Count) do begin
      S := ConvertXML(PLmResponseData(LmModem.Responses.Msg[I]).Response);
      if CheckIt then begin
        FCallerIDInfo.HasData := True;
        FCallerIDInfo.Msg := S;
      end;
    end;

end;

function TAdCustomModem.CheckErrors(const Response: string): Integer;
begin
  if CheckResponses(Response, ApxDefErrorResponse, LmModem.Responses.Error) then
    Result := ecModemRejectedCommand
  else if CheckResponses(Response, ApxDefErrorResponse, LmModem.Responses.NoCarrier) then
    Result := ecModemNoCarrier
  else if CheckResponses(Response, ApxDefErrorResponse, LmModem.Responses.NoDialTone) then
    Result := ecModemNoDialTone
  else if CheckResponses(Response, ApxDefErrorResponse, LmModem.Responses.Busy) then
    Result := ecModemDetectedBusy
  else if CheckResponses(Response, ApxDefErrorResponse, LmModem.Responses.NoAnswer) then
    Result := ecModemNoAnswer
  else
    Result := ecOK;
end;

procedure TAdCustomModem.CheckReady;
begin
  if not Assigned(FComPort) then
    raise EPortNotAssigned.Create(ecPortNotAssigned, False);

  { save the state of the port, we'll close it from CancelCall if it }
  { is closed here.  0=not set, 1=closed, 2=open }
  if FPortWasOpen = 0 then                                               {!!.05}
    if FComPort.Open then                                                {!!.05}
      FPortWasOpen := 2                                                  {!!.05}
    else                                                                 {!!.05}
      FPortWasOpen := 1;                                                 {!!.05}

  {FComPort.OnTriggerStatus := TriggerEvent;}                            {!!.06}
  {FComPort.OnTriggerTimer := TriggerEvent;}                             {!!.06}
  // This check is necessary since CheckReady can be called multiple        // SWB
  // times to process a single user request.  If we don't do this check     // SWB
  // we can end up with FSavedOnTrigger event pointing to TriggerEvent      // SWB
  // which causes infinite recursion in TriggerEvent.                       // SWB
  if (@FComPort.OnTrigger <> @TAdCustomModem.TriggerEvent) then             // SWB
  begin                                                                     // SWB
     FSavedOnTrigger := FComPort.OnTrigger;                                 {!!.06}
     FComPort.OnTrigger := TriggerEvent;                                    {!!.06}
  end;                                                                      // SWB

  if not Assigned(ResponsePacket) then begin
    ResponsePacket := TApdDataPacket.Create(Self);
    ResponsePacket.Name := Name + '_ResponsePacket';
    ResponsePacket.Enabled := False;
    ResponsePacket.AutoEnable := False;
    ResponsePacket.Timeout := MSecs2Ticks(ApxDefCommandTimeout);         {!!.KINO}
    ResponsePacket.EnableTimeout := MSecs2Ticks(ApxDefCommandTimeout);   {!!.KINO}
    //ResponsePacket.EnableTimeout := ApxDefCommandTimeout;                {!!.04}
    ResponsePacket.OnStringPacket := ResponseStringPacket;
    ResponsePacket.OnTimeout := ResponseTimeout;
    ResponsePacket.ComPort := FComPort;
    ResponsePacket.StartCond := scAnyData;
    ResponsePacket.EndCond := [ecString];
    ResponsePacket.EndString := '?'#13#10;
    ResponsePacket.Enabled := True;
  end;
  if not FComPort.Open then
    FComPort.Open := True;
end;

function TAdCustomModem.CheckResponses(const Response, DefResponse: string;
  Responses: TList): Boolean;
  function StripCtrl(const S : string) : string;
    { strip out the CR/LF prefix and suffix }
  begin
    Result := S;
    while System.Pos(#13, Result) > 0 do
      Delete(Result, System.Pos(#13, Result), 1);
    while System.Pos(#10, Result) > 0 do
      Delete(Result, System.Pos(#10, Result), 1);
  end;
var
  I : Integer;
  S : string;
begin
  { assume it's not a response that we're looking for }
  Result := False;
  if Responses.Count > 0 then begin
    for I := 0 to pred(Responses.Count) do begin
      S := ConvertXML(PLmResponseData(Responses[I]).Response);
      if StripCtrl(S) = StripCtrl(Response) then begin
        Result := True;
        {Break;}                                                         {!!.05}
      end;
      if S = '<StandardConnect>' then                                    {!!.05}
        Result := ParseStandardConnect(Response);                        {!!.05}
      if Result then Break;                                              {!!.05}
    end;
    if not Result then
      Result := System.Pos(DefResponse, Response) > 0;
  end else
    { see if the default response is at the beginning of the response }
    Result := System.Pos(DefResponse, Response) > 0;                            {!!.04}
end;

procedure TAdCustomModem.ConfigAndOpen;
  { open the port and configure the modem }
begin
  FCallerIDProvided := False;
  CheckReady;       
  {$IFDEF AdModemDebug}
  FComPort.AddStringToLog('ConfigAndOpen');
  {$ENDIF}
  PassthroughMode := True;
  Initialize;
  DoStatus(msIdle);
  DoConnect;
end;

function TAdCustomModem.ConvertXML(const S: string): string;
  { converts the '<CR>' and '<LF>' from LibModem into #13 and #10 }
var
  Psn : Integer;
begin
  Result := S;
  while System.Pos('<CR>', AnsiUpperCase(Result)) > 0 do begin
    Psn := System.Pos('<CR>', AnsiUpperCase(Result));
    Delete(Result, Psn, Length('<CR>'));
    Insert(#13, Result, Psn);
  end;
  while System.Pos('<LF>', AnsiUpperCase(Result)) > 0 do begin
    Psn := System.Pos('<LF>', AnsiUpperCase(Result));
    Delete(Result, Psn, Length('<LF>'));
    Insert(#10, Result, Psn);
  end;
  { XML also doubles any '%' char, strip that }
  while System.Pos('%%', Result) > 0 do
    Delete(Result, System.Pos('%%', Result), 1);
end;

constructor TAdCustomModem.Create(AOwner: TComponent);
var
  tmp: TApdCallerIDInfo;
  { we're being created }
begin
  FSelectedDevice := TApdModemNameProp.Create;
  FStatusDisplay := nil;
  inherited;
  Initialized := False;
  PassthroughMode := False;
  ResponsePacket := nil;

  { property inits }
  FAnswerOnRing := 2;
  FBPSRate := 0;
  FConnected := False;
  FDialTimeout := 60;
  FFailCode := 0;
  FModemCapFolder := ApxDefModemCapFolder;
  FModemState := msUnknown;
  FNegotiationResponses := TStringList.Create;
  FRingCount := 0;
  FRingWaitTimeout := 1200;
  FSelectedDevice.Manufacturer := '';
  FSelectedDevice.Name := '';
  FStartTime := 0;
  LmModem.Manufacturer := 'Generic Hayes compatible';
  LmModem.Model := 'Generic modem';
  LmModem.FriendlyName := 'Generic modem';
  LibModem := TApdLibModem.Create(Self);
  FModemConfig := DefaultDeviceConfig;
  FCallerIDProvided := False;
  tmp := CallerIDInfo;
  with tmp do begin
    HasData := False;
    Date   := '';
    Time   := '';
    Number := '';
    Name   := '';
    Msg    := '';
  end;
  CallerIDInfo := tmp;
  FHandle := AllocateHWnd(ModemMessage);
  FComPort := SearchComPort(Owner);
end;

{procedure TAdCustomModem.TriggerEvent(CP: TObject;}                     {!!.06}
  {TriggerHandle: Word);}                                                {!!.06}
procedure TAdCustomModem.TriggerEvent(CP : TObject;                      {!!.06}
  Msg, TriggerHandle, Data: Word);                                       {!!.06}
  { handle our DCD and timer triggers }
begin
  if TriggerHandle = DCDTrigger then begin
    if FComPort.DCD then
      DoConnect
    else
      DoDisconnect;
  end else if TriggerHandle = StatusTimerTrigger then begin
    DoStatus(FModemState);
    FComPort.SetTimerTrigger(StatusTimerTrigger, 1000, True);
    if (FModemState = msConnectWait) and
       (Integer(ElapsedTime div 1000) >= FDialTimeout) then begin
       { > DialTimeout elapsed, cancel }
      PostMessage(Handle, apw_CancelCall, 0, 0);
      DoFail(ecModemNoAnswer);                                           {!!.04}
    end;
  end;
  if Assigned(FSavedOnTrigger) then                                      {!!.06}
    FSavedOnTrigger(CP, Msg, TriggerHandle, Data);                       {!!.06}
end;

function TAdCustomModem.DefaultDeviceConfig: TApdModemConfig;
begin
  with Result do begin
    ConfigVersion := ApxModemConfigVersion;
    { port settings }
    DataBits := 8;
    Parity := pNone;
    StopBits := 1;
    if Assigned(FComPort) then
      AttachedTo := ShortString(FComPort.Dispatcher.DeviceName)
    else
      AttachedTo := 'unknown';

    Manufacturer := ShortString(LmModem.Manufacturer);
    ModemName := ShortString(LmModem.FriendlyName);
    ModemModel := ShortString(LmModem.Model);
    { speaker options }
    SpeakerVolume :=  svMed;
    SpeakerMode := smDial;
    { connection control }
    FlowControl := fcHard;
    ErrorControl := [ecOn];
    Compression := True;;
    Modulation := smCCITT;;
    ToneDial := True;
    BlindDial := False;
    CallSetupFailTimeout := 60;
    InactivityTimeout := 0;
    { extra commands }
    ExtraSettings := '';
    FillChar(Padding, SizeOf(Padding), #0);
  end;
end;

destructor TAdCustomModem.Destroy;
  { we're being destroyed }
begin
  DeallocateHWnd(FHandle);                                               {!!.02}
  ResponsePacket.Free;
  FNegotiationResponses.Free;
  FSelectedDevice.Free;
  LibModem.Free;
  if Assigned(FComPort) then                                             {!!.06}
    FComPort.DeregisterUserCallbackEx(PortOpenCloseEx);                  {!!.05}  
  inherited Destroy;
end;

procedure TAdCustomModem.Dial(const ANumber: string);
  { initiate the dialing sequence }
begin
  FCallerIDProvided := False;
  CheckReady;
  {$IFDEF AdModemDebug}
  FComPort.AddStringToLog('dial');
  {$ENDIF}
  PrepForConnect(True);
  FPhoneNumber := ANumber;
  PassthroughMode := False;
  if not Initialized then
    Initialize;
  FStartTime := AdTimeGetTime;
  DoStatus(msDial);
  Postmessage(Handle, apw_StartDial, 0, 0);
end;

procedure TAdCustomModem.DoCallerID;
  { Generate the OnModemCallerID event }
begin
  FCallerIDProvided := True;
  {$IFDEF AdModemDebug}
  FComPort.AddStringToLog('CallerID');
  {$ENDIF}
  if Assigned(FOnModemCallerID) then
    FOnModemCallerID(Self, FCallerIDInfo);
end;

procedure TAdCustomModem.DoConnect;
  { Generate the OnModemConnect event }
begin
  PrepForConnect(False);
  if not PassthroughMode then begin
    if DCDTrigger = 0 then
      DCDTrigger := FComPort.AddStatusTrigger(stModem);
    FComPort.SetStatusTrigger(DCDTrigger, msDCDDelta, True);
  end;

  if FModemState <> msConnected then                                     {!!.KINO}
     DoStatus(msConnected);                                              {!!.KINO}
  if Assigned(FOnModemConnect) and not(FConnected) then                  {!!.05}
    FOnModemConnect(Self);
  FConnected := True;                                                    {!!.05}
end;

procedure TAdCustomModem.DoDisconnect;
  { Generate the OnModemDisconnect event }
begin
  PrepForConnect(False);
  if Assigned(FOnModemDisconnect) and FConnected then                    {!!.05}
    FOnModemDisconnect(Self);
  FConnected := False;                                                   {!!.05}
  { fix the status }
  if Initialized then                                                    {!!.KINO}
    DoStatus(msIdle)                                                     {!!.KINO}
  else                                                                   {!!.KINO}
    DoStatus(msUnknown);                                                 {!!.KINO}
end;

procedure TAdCustomModem.DoFail(Failure : Integer);
  { Generate the OnModemFail event }
begin
  FFailCode := Failure;
  {$IFDEF AdModemDebug}
  FComPort.AddStringToLog('Fail: ' + IntToStr(FFailCode));
  {$ENDIF}
  if Assigned(FOnModemFail) then
    FOnModemFail(Self, Failure)
  else
    case FFailCode of
      { literal strings converted to string consts }                     {!!.06}
      ecModemRejectedCommand :
        raise EModemRejectedCommand.CreateUnknown(
          Format(secModemRejectedCommand + #13#10'%s',[LastCommand]), 0);
      ecModemBusy :
        raise EModemBusy.CreateUnknown(secModemBusy, 0);
      ecDeviceNotSelected :
        raise EDeviceNotSelected.CreateUnknown(secDeviceNotSelected, 0);
      ecModemNotResponding :
        raise EModemNotResponding.CreateUnknown(secModemNotResponding, 0);
      ecModemDetectedBusy :
        raise EModemDetectedBusy.CreateUnknown(secModemDetectedBusy, 0);
      ecModemNoDialTone :
        raise ENoDialTone.CreateUnknown(secModemNoDialtone, 0);
      ecModemNoCarrier :
        raise ENoCarrier.CreateUnknown(secModemNoCarrier, 0);
      ecModemNoAnswer :
        raise ENoAnswer.CreateUnknown(secModemNoAnswer, 0);
    end;
  FComPort.OnTrigger := FSavedOnTrigger;                                 {!!.06}
  FSavedOnTrigger := nil;                                                   // SWB
end;

procedure TAdCustomModem.DoLog(LogCode: TApdModemLogCode);
  { generate the OnModemLog event }
begin
  if Assigned(FOnModemLog) then
    FOnModemLog(Self, LogCode);
end;

procedure TAdCustomModem.DoStatus(NewModemState: TApdModemState);
  { change FModemState and generate the event }
var
  S : string;
  Action : TApdModemStatusAction;
  FirstState : Boolean;
begin
  if FModemState <> NewModemState then begin
    FirstState := True;
    { state changed, is it log-worthy? }
    case NewModemState of
      msIdle                  : if FModemState in [msAutoAnswerWait..msConnectWait] then
                                  DoLog(mlConnectFail)
                                else
                                  DoLog(mlNone);
      msAutoAnswerBackground  : DoLog(mlAutoAnswer);
      msAnswerWait            : DoLog(mlAnswer);
      msDial                  : DoLog(mlDial);
      msConnected             : DoLog(mlConnect);
      msHangup                : DoLog(mlCancel);
      msCancel                : DoLog(mlCancel);
    end;
  end else
    FirstState := False;

  FModemState := NewModemState;
  if Assigned(FOnModemStatus) then
    FOnModemStatus(Self, ModemState);

  if Assigned(FStatusDisplay) then begin
    { update the status display }
    if FStatusDisplay.Started then
      S := ModemStatusMsg(FModemState)
    else
      S := '';
    case FModemState of
      msConnectWait, msAutoAnswerWait  :
        if FirstState then
          Action := msaUpdate
        else
          Action := msaDetailReplace;
      msIdle, msConnected : Action := msaClose;
      else
        Action := msaUpdate;
    end;

    FStatusDisplay.UpdateDisplay(Self,
      ModemStatusMsg(FModemState),     { the status line }
      IntToStr(ElapsedTime div 1000),
      S,                               { for the detail list }
      Action);
  end;
end;

function TAdCustomModem.FailureCodeMsg(
  const FailureCode: Integer): string;
  { convert a FailureCode into a string }
begin
  Result := ErrorMsg(FailureCode);                                       {!!.04}
  (*case FailureCode of
    ecDeviceNotSelected      : Result := 'Device not selected';
    ecModemRejectedCommand   : Result := 'Modem rejected command';
    ecModemBusy              : Result := 'Modem is doing something else';
    ecModemNotResponding     : Result := 'Modem not responding';
    ecModemDetectedBusy      : Result := 'Called number is busy';
    ecModemNoDialtone        : Result := 'No dialtone';
    ecModemNoCarrier         : Result := 'No carrier';
    ecModemNoAnswer          : Result := 'No answer';
  end;*)
end;

function TAdCustomModem.GetDevConfig: TApdModemConfig;
  { return the TApdModemConfig structure defining the selected modem }
begin
  Result := FModemConfig;
end;

function TAdCustomModem.GetElapsedTime: DWORD;
begin
  if FStartTime = 0 then
    Result := 0 { not timing }
  else
    Result := AdTimeGetTime - FStartTime;
end;

function TAdCustomModem.GetNegotiationResponses: TStringList;
  { return the negotiation responses for this connection }
begin
  Result := FNegotiationResponses;
end;

procedure TAdCustomModem.Initialize;
  { initialize the modem }
  function PoundReplace(const str : string; Value : Integer) : string;
  { some modem init strings have variable params, replace them here }
  var
    I : Integer;
  begin
    Result := str;
    I := System.Pos('<#>', Result);
    if (I <> 0) then                                                        // SWB
    begin                                                                   // SWB
        { remove the '<#>' }
        Delete(Result, I, 3);
        { add the value }
        Insert(SysUtils.IntToStr(Value), Result, I);
    end;                                                                    // SWB
  end;
var
  ConfigInit : string;
begin
  { set the msInitializing state }
  DoStatus(msInitializing);
  {$IFDEF AdModemDebug}
  FComPort.AddStringToLog('Initialize');
  {$ENDIF}
  if not DeviceSelected then                                             {!!.04}
    raise EDeviceNotSelected.Create(ecDeviceNotSelected, False);
  if not SendCommands(LmModem.Init) then begin
    { fake it, using generic reset }
    SendCommand(LmModem.Reset);
  end;
  ConfigInit := LmModem.Settings.Prefix + ' ';
  with FModemConfig do begin
    { port settings }
    FComPort.DataBits := DataBits;
    FComPort.Parity := Parity;
    FComPort.StopBits := StopBits;
    { speaker options }
    case SpeakerVolume of
      svLow  : ConfigInit := ConfigInit + LmModem.Settings.SpeakerVolume_Low + ' ';
      svMed  : ConfigInit := ConfigInit + LmModem.Settings.SpeakerVolume_Med + ' ';
      svHigh : ConfigInit := ConfigInit + LmModem.Settings.SpeakerVolume_High + ' ';
    end;
    case SpeakerMode of
      smOff   : ConfigInit := ConfigInit + LmModem.Settings.SpeakerMode_Off + ' ';
      smOn    : ConfigInit := ConfigInit + LmModem.Settings.SpeakerMode_On + ' ';
      smDial  : ConfigInit := ConfigInit + LmModem.Settings.SpeakerMode_Dial + ' ';
    end;
    { connection control }
    case FlowControl of
      fcOff  : ConfigInit := ConfigInit + LmModem.Settings.FlowControl_Off + ' ';
      fcHard : ConfigInit := ConfigInit + LmModem.Settings.FlowControl_Hard + ' ';
      fcSoft : ConfigInit := ConfigInit + LmModem.Settings.FlowControl_Soft + ' ';
    end;
    if ecOff in ErrorControl then
      ConfigInit := ConfigInit + LmModem.Settings.ErrorControl_Off + ' '
    else begin
      ConfigInit := ConfigInit + LmModem.Settings.ErrorControl_On + ' ';
      if ecForced in ErrorControl then
       ConfigInit := ConfigInit + LmModem.Settings.ErrorControl_Forced + ' ';
      if ecCellular in ErrorControl then
        ConfigInit := ConfigInit + LmModem.Settings.ErrorControl_Cellular + ' ';
    end;
    if Compression then
      ConfigInit := ConfigInit + LmModem.Settings.Compression_On + ' '
    else
      ConfigInit := ConfigInit + LmModem.Settings.Compression_Off + ' ';
    case Modulation of
      smBell      : ConfigInit := ConfigInit + LmModem.Settings.Modulation_Bell + ' ';
      smCCITT     : ConfigInit := ConfigInit + LmModem.Settings.Modulation_CCITT + ' ';
      smCCITT_V23 : ConfigInit := ConfigInit + LmModem.Settings.Modulation_CCITT_V23 + ' ';
    end;
    if BlindDial then
      ConfigInit := ConfigInit + LmModem.Settings.Blind_On
    else
      ConfigInit := ConfigInit + LmModem.Settings.Blind_Off;
    ConfigInit := ConfigInit +
      PoundReplace(LmModem.Settings.CallSetupFailTimer, CallSetupFailTimeout) + ' ';
    ConfigInit := ConfigInit +
      PoundReplace(LmModem.Settings.InactivityTimeout, InactivityTimeout) + ' ';
    ConfigInit := ConfigInit + LmModem.Settings.Terminator;

    {$IFDEF AdModemDebug}
    FComPort.AddStringToLog('Init 1');
    {$ENDIF}
    SendCommand(ConvertXML(ConfigInit));

    if ExtraSettings <> '' then begin
      {$IFDEF AdModemDebug}
      FComPort.AddStringToLog('Init 2');
      {$ENDIF}
      SendCommand(ConvertXML(string(ExtraSettings) + #13));
    end;
  end;
  Initialized := True;
end;

function TAdCustomModem.ModemLogToString(
  LogCode: TApdModemLogCode): string;
  { convert a LogCode into a string }
begin
  case LogCode of
    mlNone         : Result := 'None, nothing to log';
    mlDial         : Result := 'Dialing';
    mlAutoAnswer   : Result := 'Initiated AutoAnswer';
    mlAnswer       : Result := 'Answering an incoming call';
    mlConnect      : Result := 'Connected';
    mlCancel       : Result := 'Call cancelled';
    mlBusy         : Result := 'Called number was busy';
    mlConnectFail  : Result := 'Connection attempt failed';
    else             Result := 'Undefined modem log code';
  end;
end;

function TAdCustomModem.ModemStatusMsg(Status: TApdModemState): string;
  { convert a status code into a string }
var
  Plural : char;
begin
  case Status of
    msUnknown :
      Result := 'Hasn''t been initialized';
    msIdle :
      Result := 'Idle and ready';
    msInitializing :
      Result := 'Starting initialization process';
    msAutoAnswerBackground :
      Result := 'AutoAnswer no rings received';
    msAutoAnswerWait :
      begin
        if (FAnswerOnRing - FRingCount) > 1 then
          Plural := 's'
        else
          Plural := ' ';
        Result := Format('AutoAnswer waiting for %d more ring%s',
          [FAnswerOnRing - FRingCount, Plural]);
      end;
    msAnswerWait :
      Result := 'Answering call waiting for connect';
    msDial :
      Result := Format('Dialing %s', [FPhoneNumber]);
    msConnectWait :
      Result := 'Waiting for remote to answer';
    msConnected :
      Result := 'Connected';
    msHangup :
      Result := 'Starting hangup process';
    msCancel :
      Result := 'Starting cancel process';
    else
      Result := 'Undefined modem state';
  end;
end;

procedure TAdCustomModem.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if not (csDesigning in ComponentState) then
    exit;
  if (Operation = opRemove) then begin
    { see if our com port is going away }
    if (AComponent = FComPort) then
      ComPort := nil;
    { see if our status dialog is going away }
    if (AComponent = FStatusDisplay) then
      StatusDisplay := nil;
  end else if (Operation = opInsert) then begin
    {Check for a com port being installed}
    if not Assigned(FComPort) and (AComponent is TApdCustomComPort) then
      ComPort := TApdCustomComPort(AComponent);
    if not Assigned(FStatusDisplay) and (AComponent is TAdAbstractModemStatus) then
      StatusDisplay := TAdAbstractModemStatus(AComponent);
  end;
end;

procedure TAdCustomModem.PrepForConnect(EnableTriggers: Boolean);
begin
  if EnableTriggers then begin
    { somebody set us up the trigger }
    if DCDTrigger > 0 then
      FComPort.RemoveTrigger(DCDTrigger);
    DCDTrigger := FComPort.AddStatusTrigger(stModem);
    FComPort.SetStatusTrigger(DCDTrigger, msDCDDelta, True);
    if StatusTimerTrigger > 0 then
      FComPort.RemoveTrigger(StatusTimerTrigger);
    StatusTimerTrigger := FComPort.AddTimerTrigger;
    FComPort.SetTimerTrigger(StatusTimerTrigger, 1000, True);
  end else begin
    if DCDTrigger > 0 then begin
      FComPort.RemoveTrigger(DCDTrigger);
      DCDTrigger := 0;
    end;
    if StatusTimerTrigger > 0 then begin
      FComPort.RemoveTrigger(StatusTimerTrigger);
      StatusTimerTrigger := 0;
    end;
  end;
  FNegotiationResponses.Clear;
end;

procedure TAdCustomModem.ResponseStringPacket(Sender: TObject;
  Data: AnsiString);
var
  Res : Integer;
begin
  { we've detected a string ending with #13#10, see if it is }
  { something we are looking for }
  { assume it's not }
  OKResponse := False;
  ErrorResponse := False;
  ConnectResponse := False;
  WaitingForResponse := True;

  { if we're waiting for the connection, add the response to the list }
  if FModemState in [msConnectWait, msAnswerWait] then begin
    if Data <> #13#10 then begin
      {$IFDEF AdModemDebug}
      FComPort.AddStringToLog('Informative response');
      {$ENDIF}
      FNegotiationResponses.Add(string(Data));
    end;
  end;

  Res := CheckErrors(string(Data));
  if Res <> ecOK then begin
    ErrorResponse := True;
    WaitingForResponse := False;
    if (FModemState = msHangup) and (Res = ecModemNoCarrier) then
      { we've disconnected }
    else begin
      DoFail(Res);
      Exit;
    end;
  end;

  { check for caller ID tags }
  if FModemState in [msAutoAnswerBackground, msAutoAnswerWait, msAnswerWait] then begin
    CheckCallerID(string(Data));
    ResponsePacket.Enabled := True;
  end;

  { interpret the response based on what state we're in }
   case FModemState of
    msUnknown,
    msIdle,
    msConnected : { anything here means that the packet wasn't disabled }
      begin
        ResponsePacket.Enabled := False;
        WaitingForResponse := False;
      end;
    msInitializing : { anything here should be a OK or ERROR response }
      begin
        if CheckResponses(string(Data), ApxDefOKResponse, LmModem.Responses.OK) then begin
          { it's an OK }
          {$IFDEF AdModemDebug}
          FComPort.AddStringToLog('OKResponse');
          {$ENDIF}
          OKResponse := True;
          WaitingForResponse := False;
        end else
          if System.Pos(LastCommand, string(Data)) > 0 then begin
            {$IFDEF AdModemDebug}
            FComPort.AddStringToLog('EchoResponse');
            {$ENDIF}
            ResponsePacket.Enabled := True;
          end else begin
            {$IFDEF AdModemDebug}
            FComPort.AddStringToLog('Unknown response');
            {$ENDIF}
            DoFail(ecModemRejectedCommand);
            WaitingForResponse := False;
          end;
      end;
    msAutoAnswerBackground :
      begin
        if CheckResponses(string(Data), ApxDefRingResponse, LmModem.Responses.Ring) then begin
          { it's the first RING }
          if not FCallerIDProvided and CallerIDInfo.HasData then begin
            DoCallerID;
          end;
          FRingCount := 1;
          {$IFDEF AdModemDebug}
          FComPort.AddStringToLog('Ring' + IntToStr(FRingCount));
          {$ENDIF}
          DoStatus(msAutoAnswerWait);
          ChangeResponseTimeout(MSecs2Ticks(FRingWaitTimeout),           {!!.KINO}
                                MSecs2Ticks(FRingWaitTimeout));          {!!.KINO}
          //ResponsePacket.TimeOut := FRingWaitTimeout;
          //ResponsePacket.EnableTimeOut := FRingWaitTimeout;              {!!.04}
          ResponsePacket.Enabled := True;
        end;
      end;
    msAutoAnswerWait : { looking for more RINGs }
      begin
        if CheckResponses(string(Data), ApxDefRingResponse, LmModem.Responses.Ring) then begin
          { it's another RING }
          inc(FRingCount);
          if not FCallerIDProvided and CallerIDInfo.HasData then begin
            DoCallerID;
          end;
          { see if we need to answer it now }
          if FRingCount >= FAnswerOnRing then begin
            DoStatus(msAnswerWait);
            WaitingForResponse := False;
            { send the ATA }
            {$IFDEF AdModemDebug}
            FComPort.AddStringToLog('AutoAnswer post');
            {$ENDIF}
            Postmessage(Handle, apw_AutoAnswer, 0, 0);
          end else begin
            { not enough rings }
            {$IFDEF AdModemDebug}
            FComPort.AddStringToLog('Ring' + IntToStr(FRingCount));
            {$ENDIF}
            DoStatus(msAutoAnswerWait);
            ChangeResponseTimeout(MSecs2Ticks(FRingWaitTimeout),         {!!.KINO}
                                  MSecs2Ticks(FRingWaitTimeout));        {!!.KINO}
            //ResponsePacket.TimeOut := FRingWaitTimeout;
            //ResponsePacket.EnableTimeOut := FRingWaitTimeout;            {!!.04}
            ResponsePacket.Enabled := True;
          end;
        end;
      end;

    msAnswerWait,
    msDial,
    msConnectWait : { waiting for connect or error }
      begin
        if CheckResponses(string(Data), ApxDefConnectResponse, LmModem.Responses.Connect) then begin
          { it's a CONNECT }
          ConnectResponse := True;
          OKResponse := True;
          WaitingForResponse := False;
          {$IFDEF AdModemDebug}
          FComPort.AddStringToLog('Connect response');
          {$ENDIF}
          if not FConnected then begin
            DoStatus(msConnected);
            DoConnect;
          end;
        end else
          ResponsePacket.Enabled := True;
      end;
    msHangup,
    msCancel : { starting hangup }
      begin
        WaitingForResponse := False;
      end;
  end;
end;

procedure TAdCustomModem.ResponseTimeout(Sender: TObject);
begin
  { data packet timed out }
  TimedOut := True;
  if FModemState = msAutoAnswerWait then begin
    FRingCount := 0;
    DoStatus(msAutoAnswerBackground);
    ChangeResponseTimeout(0, 0);                                      {!!.KINO}
    //ResponsePacket.Timeout := 0;
    ResponsePacket.Enabled := True;
    WaitingForResponse := False;                                      {!!.KINO}
  end;
end;

function TAdCustomModem.SelectDevice: Boolean;
  { display the modem selection dialog }
begin
  try
    if not SysUtils.DirectoryExists(FModemCapFolder) then                         {!!.06}
      raise EInOutError.CreateFmt(                                       {!!.06}
        'Modemcap folder not found'#13#10'(%s)', [FModemCapFolder]);     {!!.06}
        
    {$IFDEF AdModemDebug}
    if Assigned(FComPort) then
      FComPort.AddStringToLog('Selecting');
    {$ENDIF}
    LibModem.LibModemPath := FModemCapFolder;
    Result := LibModem.SelectModem(
      FSelectedDevice.FModemFile,
      FSelectedDevice.FManufacturer,
      FSelectedDevice.FName, LmModem);
    FDeviceSelected := Result;                                    {!!.04}{!!.05}
    {$IFDEF AdModemDebug}
    if Result and Assigned(FComPort) then begin
       FComPort.AddStringToLog('Selected from ' + FSelectedDevice.FModemFile);
       FComPort.AddStringToLog('Selected manufacturer: ' + FSelectedDevice.FManufacturer);
       FComPort.AddStringToLog('Selected device: ' + FSelectedDevice.FName);
    end;
    {$ENDIF}
  finally
    { eat the exeption here }
  end;
end;

function TAdCustomModem.SendCommand(const Command: string): Boolean;
  { send a command to the modem, returns when the response is received }
  { or on a timeout }
var
  ET : EventTimer;                                                       {!!.04}
  Res : Word;                                                            {!!.04}
begin
  if WaitingForResponse then begin
    Result := False;
    DoFail(ecModemBusy);
    Exit;
  end;
  CheckReady;
  LastCommand := StripXML(Command);                                      {!!.04}

  Result := True;
  WaitingForResponse := True;
  OKResponse := False;
  ErrorResponse := False;
  ConnectResponse := False;
  TimedOut := False;

  //ResponsePacket.Timeout := 0;{ApxDefCommandTimeout;}                    {!!.05}
  ChangeResponseTimeout(0,0);                                            {!!.KINO}
  ResponsePacket.Enabled := True;
  if Command = '<DTR>' then                                              {!!.05}
    FComPort.DTR := False                                                {!!.05}
  else                                                                   {!!.05}
    FComPort.OutputUni := ConvertXML(Command);                              {!!.04}

  { wait for the response }
  //if ModemState = msHangup then                                          {!!.05}
  if ModemState in [msCancel, msHangup] then                             {!!.KINO}
    { if we're hanging up or cancel call, only wait 6 seconds for the response }
    NewTimer(ET, Secs2Ticks(6))                                          {!!.05}
  else                                                                   {!!.05}
    NewTimer(ET, Secs2Ticks(30));                                        {!!.05}
  repeat
    {Application.HandleMessage;}                                         {!!.02}
    //Res := SafeYield;                                          {!!.04} {!!.05}
    Res := DelayTicks(2,True);                                           {!!.05}       
    if (csDestroying in ComponentState) or (Res = WM_QUIT) then Exit;    {!!.04}
    TimedOut := TimerExpired(ET);                                        {!!.04}
  until not(WaitingForResponse) or TimedOut;                             {!!.04}

  ResponsePacket.Enabled := False;
  if TimedOut or TimerExpired(ET) then                                   {!!.04}
    DoFail(ecModemNotResponding)
  else if ErrorResponse then
    DoFail(ecModemRejectedCommand);
  Result := not(TimedOut) and not(ErrorResponse);
  WaitingForResponse := False;                                           {!!.04}
end;

function TAdCustomModem.SendCommands(Commands: TList) : Boolean;
  { internal method to send all commands in the TLmCommands list }
var
  I : Integer;
begin
  Result := False;
  if Commands.Count > 0 then begin
    for I := 0 to pred(Commands.Count) do begin
      Result := SendCommand(ConvertXML(PLmModemCommand(Commands[I]).Command));
      if not Result then
        Break;
    end;
  end else
    { return False if no commands were available }
    Result := False;
end;

procedure TAdCustomModem.SetAnswerOnRing(const Value: Integer);
  { write access method for AnswerOnRing property }
begin
  FAnswerOnRing := Value;
end;

procedure TAdCustomModem.SetComPort(const Value: TApdCustomComPort);
  { write access method for ComPort property }
begin
  if FComPort <> Value then begin                                        {!!.05}
    if FComPort <> nil then                                              {!!.05}
      { deregister our callback with the old port }
      FComPort.DeregisterUserCallbackEx(PortOpenCloseEx);                {!!.05}

    FComPort := Value;                                                   {!!.05}
    if FComPort <> nil then                                              {!!.05}
      { register our callback with the new port }
      FComPort.RegisterUserCallbackEx(PortOpenCloseEx);                  {!!.05}
  end;                                                                   {!!.05}
end;

procedure TAdCustomModem.SetDevConfig(const Config: TApdModemConfig);
  { forces new configuration }
begin
  {$IFDEF AdModemDebug}
  if Assigned(FComPort) then
    FComPort.AddStringToLog('ConfigChange');
  {$ENDIF}
  if CompareMem(@FModemConfig, @Config, SizeOf(TApdModemConfig)) then    {!!.06}
    Initialized := False;                                                {!!.06}
  FModemConfig := Config;
end;

procedure TAdCustomModem.SetDialTimeout(const Value: Integer);
  { write access method for DialTimeout property }
begin
  FDialTimeout := Value;
end;

procedure TAdCustomModem.SetModemCapFolder(const Value: string);
  { write access method for ModemCapFolder property }
begin
  FModemCapFolder := Value;
  LibModem.LibModemPath := ModemCapFolder;                               {!!.02}
end;

procedure TAdCustomModem.SetRingWaitTimeout(const Value: DWORD);
  { write access method for RingWaitTimeout property }
begin
  FRingWaitTimeout := Value;
end;

procedure TAdCustomModem.SetSelectedDevice(                              {!!.02}
  const Value: TApdModemNameProp);
  { write access method for SelectedDevice property }
var
  Res : Integer;
begin
  { try to select a specific modem from a specific detail file }
  FDeviceSelected := False;                                              {!!.05}
  if (Value.ModemFile <> '') and (Value.Name <> '') then begin
    Res := LibModem.GetModem(Value.ModemFile, Value.Name, LmModem);
    case Res of
      ecOK            : { we found the modem, accept the value }
        begin
          FSelectedDevice.Assign(Value);
          FDeviceSelected := True;                                {!!.04}{!!.05}
        end;
      { these are error conditions, can't raise an exception at design-time }
      { so we'll just ignore the .set }
      ecFileNotFound  : { couldn't find the ModemFile }
        begin
          if not(csDesigning in ComponentState) then
            raise EInOutError.CreateFmt('Modem file not found(%s)',
              [Value.ModemFile]);
        end;
      ecModemNotFound : { couldn't find the modem in ModemFile }
        begin
          if not(csDesigning in ComponentState) then
            raise EModem.Create(ecModemNotFound, False);
        end;
    end;
  end;
  {$IFDEF AdMdmDebug}
  if Assigned(FComPort) then                                             {!!.01}
    FComPort.AddStringToLog('.SetSelectedDevice');
  {$ENDIF}
end;

procedure TAdCustomModem.SetStatusDisplay(
  const Value: TAdAbstractModemStatus);
  { write access method for StatusDisplay property }
begin
  FStatusDisplay := Value;
end;

function TAdCustomModem.StripXML(const S: string): string;               {!!.04}
  { strip the XML tags out of the string }
var
  Psn : Integer;
begin
  Result := S;
  while System.Pos('<CR>', AnsiUpperCase(Result)) > 0 do begin
    Psn := System.Pos('<CR>', AnsiUpperCase(Result));
    Delete(Result, Psn, Length('<CR>'));
  end;
  while System.Pos('<LF>', AnsiUpperCase(Result)) > 0 do begin
    Psn := System.Pos('<LF>', AnsiUpperCase(Result));
    Delete(Result, Psn, Length('<LF>'));
  end;
  { XML also doubles any '%' char, strip that }
  while System.Pos('%%', Result) > 0 do
    Delete(Result, System.Pos('%%', Result), 1);
end;

function TAdCustomModem.GetDeviceSelected: Boolean;                      {!!.04}
begin                                                                    {!!.04}
  Result := FDeviceSelected;                                             {!!.05}
  {Result := LibModem.IsModemValid(FSelectedDevice.FModemFile,}   {!!.04}{!!.05}
    {FSelectedDevice.FName);}                                     {!!.04}{!!.05}
end;                                                              {!!.04}{!!.05}

procedure TAdCustomModem.PortOpenCloseEx(CP: TObject;                    {!!.05}
  CallbackType: TApdCallbackType);                                       {!!.05}
  {- Extended event handler for the port open/close event}
begin                                                                    {!!.05}
  if (CallbackType in [ctClosing, ctClosed]) and FConnected then         {!!.05}
    DoDisconnect;                                                        {!!.05}
end;                                                                     {!!.05}

function TAdCustomModem.ParseStandardConnect(const Response: string) : Boolean;{!!.05}
var
  Position      : Integer;
  Len           : Integer;
  SavedPosition : Integer;
  S : string;

  procedure SkipWhitespace;
  begin
    while (Position <= Len) and (Response[Position] = ' ') do
      Inc (Position);

    while (Position <= Len) and
          ((System.Copy (Response, Position, 4) = '<cr>') or
           (System.Copy (Response, Position, 4) = '<lf>')) do
      inc(Position, 4);

    while (Position <= Len) and (Response[Position] = ' ') do
      inc(Position);
  end;

begin
  // A standard Connect response is in the form of
  // (<cr>|<lf>)*[[:space:]]*CONNECT[[:space:]]*[[:digit:]]*(/tag)*(<cr>)*
  // a custom regex parser is used below
  Result := False;
  Position := 1;
  Len := Length (Response);

  SkipWhitespace;

  // Look for the all important CONNECT keyword.

  if System.Copy (Response, Position, 7) <> 'CONNECT' then
    Exit;

  // Assume now that this WILL be a Connection

  Result := True;
  Position := Position + 7;

  SkipWhitespace;

  // extract the baud rate

  SavedPosition := Position;
  while (Position <= Len) and CharInSet(Response[Position], ['0'..'9']) do
    Inc (Position);
  if SavedPosition <> Position then begin
    S := System.Copy (Response, SavedPosition, Position - SavedPosition);
    FBPSRate := StrToIntDef(S, FBPSRate);
  end;
end;

{ TAdAbstractModemStatus }

constructor TAdAbstractModemStatus.Create(AOwner: TComponent);
begin
  inherited;
  Caption := ApxDefModemStatusCaption;
  FStarted := False;
  FModem := nil;
  FStatusDialog := nil;
end;

destructor TAdAbstractModemStatus.Destroy;
begin
  FStatusDialog.Free;
  inherited;
end;

procedure TAdAbstractModemStatus.SetCaption(const Value: string);
begin
  if FCaption <> Value then begin
    FCaption := Value;
    if Assigned(FStatusDialog) then
      FStatusDialog.Caption := Value;
  end;
end;

procedure TAdAbstractModemStatus.SetModem(const Value: TAdCustomModem);
begin
  FModem := Value;
  if FStarted then begin
    SetStarted(False);
    SetStarted(True);
  end;
end;

procedure TAdAbstractModemStatus.SetStarted(Start: Boolean);
begin
  if Start = FStarted then exit;
  if Start then begin
    FStatusDialog := TApdModemStatusDialog.Create(self);
    FStatusDialog.Caption := Caption;
    TApdModemStatusDialog(FStatusDialog).Modem := FModem;
    TApdModemStatusDialog(FStatusDialog).UpdateDisplay('', '', '', msaStart);{!!.04}
    {FStatusDialog.Show;}                                                {!!.04}
  end else begin
    FStatusDialog.Free;
    FStatusDialog := nil;
  end;
  FStarted := Start;
end;

procedure TAdAbstractModemStatus.UpdateDisplay(Modem: TAdCustomModem;
  const StatusStr, TimeStr, DetailStr : string;
  Action : TApdModemStatusAction);
begin
  if Action = msaClose then begin
    SetStarted(False);
    Exit;
  end;
  if (not Started) then
    { create the dialog }
    SetStarted(True);

  TApdModemStatusDialog(FStatusDialog).UpdateDisplay(
    StatusStr,  { the status line }
    TimeStr,    { the 'Elapsed time' line }
    DetailStr,  { detail list }
    Action);    { how we're going to display it }

  if FModem.FModemState in [msUnknown, msIdle, msConnected] then
    SetStarted(False);
end;

function TAdCustomModem.ShowConfigDialog : Boolean;
var
  MdmCfgDlg : TApdModemConfigDialog;
begin
  MdmCfgDlg := nil;
  try
    MdmCfgDlg := TApdModemConfigDialog.Create(nil);
    MdmCfgDlg.LmModem := LmModem;
    if FModemConfig.AttachedTo = '' then
      FModemConfig.AttachedTo := ShortString(FComPort.Dispatcher.DeviceName);
    MdmCfgDlg.ModemConfig := GetDevConfig;                             {!!.02}
    Result := MdmCfgDlg.ShowModal = mrOK;
    if Result then begin
      FModemConfig := MdmCfgDlg.ModemConfig;
    end;
  finally
    MdmCfgDlg.Free;
  end;
end;

{!!.KINO BEGIN
 Fix timeout changing on already enabled TimerTrigger
}
procedure TAdCustomModem.ChangeResponseTimeout(aTimeout, aEnableTimeout: integer);
var
  vEnabled: boolean;
begin
  vEnabled := ResponsePacket.Enabled;
  if (ResponsePacket.TimeOut <> aTimeout) or
     (ResponsePacket.EnableTimeOut <> aEnableTimeout)
  then begin
     if vEnabled then
        ResponsePacket.Enabled := False;
     ResponsePacket.TimeOut := aTimeout;
     ResponsePacket.EnableTimeOut := aEnableTimeout;
     if vEnabled then
        ResponsePacket.Enabled := True;
  end;
end;
{!!.KINO END}

end.
