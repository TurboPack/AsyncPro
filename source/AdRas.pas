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
{*                    ADRAS.PAS 4.06                     *}
{*********************************************************}
{* TApdRasDialer and status components                   *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+,J+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdRas;
  {-Delphi remote access (RAS) dialer component}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  ExtCtrls,
  Dialogs,
  AdRasUtl,
  OoMisc,
  AdExcept;

type {Enumerated type definitions}
  TApdRasDialMode        = (dmSync, dmAsync);
  TApdRasSpeakerMode     = (smDefault, smSpeakerOn, smSpeakerOff);
  TApdRasCompressionMode = (cmDefault, cmCompressionOn, cmCompressionOff);
  TApdRasDialOption      = (doPrefixSuffix, doPausedStates,
                            doDisableConnectedUI, doDisableReconnectUI,
                            doNoUser, doPauseOnScript);
  TApdRasDialOptions     = set of TApdRasDialOption;


type {Event handler prototypes}
  TApdRasStatusEvent    = procedure(Sender : TObject;
                                    Status : Integer) of object;
  TApdRasErrorEvent     = procedure(Sender : TObject;
                                    Error : Integer) of object;

type
  {Forwards}
  TApdAbstractRasStatus = class;

  {Custom RAS dialer component}
  TApdCustomRasDialer = class(TApdBaseComponent)
  protected {private}
    {internal variables}
    DialEventHandle  : HWND;
    DialEventMsg     : Word;
    DialExtensions   : TRasDialExtensions;
    EntryDialParams  : TRasDialParams;
    DialDlgInfo      : TRasDialDlgInfo;
    MonitorDlgInfo   : TRasMonitorDlgInfo;
    PhonebookDlgInfo : TRasPhonebookDlgInfo;
    DisconnectTimer  : TTimer;

    {property variables}
    FDialOptions     : TApdRasDialOptions;
    FDialMode        : TApdRasDialMode;
    FSpeakerMode     : TApdRasSpeakerMode;
    FCompressionMode : TApdRasCompressionMode;
    FPhonebook       : string;
    FEntryName       : string;
    FHangupOnDestroy : Boolean;
    FPhoneNumber     : string;
    FCallBackNumber  : string;
    FUserName        : string;
    FPassword        : string;
    FDomain          : string;
    FConnection      : THandle;
    FStatusDisplay   : TApdAbstractRasStatus;
    FPlatformID      : DWord;

    {event variables}
    FOnConnected     : TNotifyEvent;
    FOnDialStatus    : TApdRasStatusEvent;
    FOnDialError     : TApdRasErrorEvent;
    FOnDisconnected  : TNotifyEvent;

    {internal methods}
    function  AssembleDialExtensions : PRasDialExtensions;
    function  AssembleDialParams : PRasDialParams;
    procedure DialEventWindowProc(var Msg: TMessage);
    procedure DoOnDialError(Error : Integer);
    procedure DoOnDialStatus(Status : Integer);
    procedure DoOnConnected;
    procedure DoOnDisconnected;
    procedure DoDisconnectTimer(Sender : TObject);
    function  GetConnection : THandle;
    function  GetConnectState : Integer;
    function  GetDeviceName : string;
    function  GetDeviceType : string;
    function  GetFullConnectStatus(PRCS : PRasConnStatus) : Integer;
    function GetIsRasAvailable: Boolean;                                 {!!.01}
    procedure Notification(AComponent : TComponent;
                           Operation : TOperation); override;
    procedure SetEntryName(Value : string);

  protected {properties}
    property CallBackNumber : string
               read FCallBackNumber write FCallBackNumber;
    property CompressionMode : TApdRasCompressionMode
               read FCompressionMode write FCompressionMode;
    property DialMode : TApdRasDialMode
               read FDialMode write FDialMode;
    property DialOptions : TApdRasDialOptions
               read FDialOptions write FDialOptions;
    property Domain : string
               read FDomain write FDomain;
    property EntryName : string
               read FEntryName write SetEntryName;
    property HangupOnDestroy : Boolean
               read FHangupOnDestroy write FHangupOnDestroy;
    property Password : string
               read FPassword write FPassword;
    property Phonebook : string
               read FPhonebook write FPhonebook;
    property PhoneNumber : string
               read FPhoneNumber write FPhoneNumber;
    property SpeakerMode : TApdRasSpeakerMode
               read FSpeakerMode write FSpeakerMode;
    property StatusDisplay : TApdAbstractRasStatus
               read FStatusDisplay write FStatusDisplay;
    property UserName : string
               read FUserName write FUserName;

  protected {events}
    property OnConnected : TNotifyEvent
               read FOnConnected write FOnConnected;
    property OnDialStatus : TApdRasStatusEvent
               read FOnDialStatus write FOnDialStatus;
    property OnDialError : TApdRasErrorEvent
               read FOnDialError write FOnDialError;
    property OnDisconnected : TNotifyEvent
               read FOnDisconnected write FOnDisconnected;

  public {run-time properties}
    property Connection : THandle
               read GetConnection;
    property ConnectState : Integer
               read GetConnectState;
    property DeviceName : string
               read GetDeviceName;
    property DeviceType : string
               read GetDeviceType;
    property PlatformID : DWord
               read FPlatformID;
    property IsRasAvailable : Boolean                                    {!!.01}
               read GetIsRasAvailable;                                   {!!.01}

  public {methods}
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    function  AddPhonebookEntry(PBEntryName : string;                    {!!.06}
                                RasEntry : TRasEntry;                    {!!.06}
                                TapiConfigRec : TTapiConfigRec): Integer;{!!.06}
    function  CreatePhonebookEntry : Integer;
    function  DeletePhonebookEntry : Integer;
    function  Dial : Integer;
    function  DialDlg : Integer;
    function  EditPhonebookEntry : Integer;
    function  ClearConnectionStatistics : Integer;                       {!!.06}
    function  GetConnectionStatistics(                                   {!!.06}
      var Statistics : TRasStatistics) : Integer;                        {!!.06}
    function  GetErrorText(Error : Integer) : string;
    function  GetPhonebookEntry(PBEntryName : string;                    {!!.06}
                                var RasEntry : TRasEntry;                {!!.06}
                                var TapiConfigRec : TTapiConfigRec): Integer;{!!.06}
    function  GetStatusText(Status : Integer) : string;
    procedure Hangup;
    function  ListConnections(List : TStrings) : Integer;
    function  ListEntries(List : TStrings) : Integer;
    function  MonitorDlg : Integer;
    function  PhonebookDlg : Integer;
    function  GetDialParameters : Integer;
    function  SetDialParameters : Integer;
    function  ValidateEntryName(EntryName : string) : Integer;           {!!.06}           
  end;

  {Abstract RAS status class}
  TApdAbstractRasStatus = class(TApdBaseComponent)
  protected {private}
    FCtl3D     : Boolean;
    FDisplay   : TForm;
    FPosition  : TPosition;
    FRasDialer : TApdCustomRasDialer;

  protected {methods}
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetCtl3D(Value : Boolean);
    procedure SetPosition(Value : TPosition);

  public {properties}
    property Display : TForm
      read FDisplay write FDisplay;

  public {methods}
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    procedure CreateDisplay(const EntryName : string); dynamic; abstract;
    procedure DestroyDisplay; dynamic; abstract;
    procedure UpdateDisplay(const StatusMsg : string); virtual; abstract;

  published {properties}
    property Ctl3D : Boolean
      read FCtl3D write SetCtl3D;
    property Position : TPosition
      read FPosition write SetPosition;
    property RasDialer : TApdCustomRasDialer
      read FRasDialer write FRasDialer;
  end;


type {Ras dialer component}
  TApdRasDialer = class(TApdCustomRasDialer)
  published {properties}
    property CallBackNumber;
    property CompressionMode;
    property DialMode;
    property DialOptions;
    property Domain;
    property EntryName;
    property HangupOnDestroy;
    property OnConnected;
    property OnDialStatus;
    property OnDialError;
    property OnDisconnected;
    property Password;
    property Phonebook;
    property PhoneNumber;
    property SpeakerMode;
    property StatusDisplay;
    property UserName;
  end;

implementation

const
  RasBaseStatusString = 4500;


{ TApdCustomRasDialer }
constructor TApdCustomRasDialer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDialMode := dmAsync;
  FConnection := 0;
  FEntryName := '';
  FHangupOnDestroy := True;
  DialEventMsg := RegisterWindowMessage(AdRasDialEvent);
  if (DialEventMsg = 0) then
    DialEventMsg := WM_RASDIALEVENT;
  DialEventHandle := AllocateHWnd(DialEventWindowProc);
  FPlatFormID := AdRasPlatformID;
  DisconnectTimer := TTimer.Create(Self);
  with DisconnectTimer do begin
    Name := 'ApdRasDiscTimer';
    Enabled := False;
    Interval := 1000;
    OnTimer := DoDisconnectTimer;
  end;
end;

destructor TApdCustomRasDialer.Destroy;
begin
  if Assigned(DisconnectTimer) then
    DisconnectTimer.Free;
  if not (csDesigning in ComponentState) then
    if HangupOnDestroy then
      try
        Hangup;
      except  { swallow any hangup errors }
      end;
  if (DialEventHandle <> 0) then
    DeallocateHWnd(DialEventHandle);
  inherited Destroy;
end;

function TApdCustomRasDialer.AddPhonebookEntry(PBEntryName : string;     {!!.06}
  RasEntry : TRasEntry; TapiConfigRec : TTapiConfigRec): Integer;
{ add a new phonebook entry }
var
  EntrySize : DWORD;
  DevInfoSize : DWORD;
  TempPhoneBook : string;
begin
  { make sure the entry name is valid }
  Result := AdRasValidateEntryName(FPhoneBook, PBEntryName);
  if Result = 0 then begin
    EntrySize := SizeOf(TRasEntry);
    if IsWinNT then begin
      TempPhoneBook := FPhoneBook;
      DevInfoSize := 0;
    end else begin
      { Win9x/ME doesn't use phone book or TAPI config params }
      TempPhoneBook := '';
      DevInfoSize := SizeOf(TTapiConfigRec);
    end;
    { Required items for RasEntry are szPLocalPhoneNumber, szDeviceName, }
    { szDeviceType, dwFramingProtocol and dwfOptions. See help for       }
    { RasSetEntryProperties for details }
    Result := AdRasSetEntryProperties(TempPhonebook,
                                      PBEntryName,
                                      @RasEntry,
                                      EntrySize,
                                      @TapiConfigRec,
                                      DevInfoSize)
  end;
end;

function TApdCustomRasDialer.AssembleDialExtensions : PRasDialExtensions;
begin
  FillChar(DialExtensions, SizeOf(DialExtensions), #0);
  DialExtensions.dwSize := SizeOf(DialExtensions);
  with DialExtensions do begin
    if (doPrefixSuffix in FDialOptions) then
      dwfOptions := dwfOptions or deUsePrefixSuffix;
    if (doPausedStates in FDialOptions) then
      dwfOptions := dwfOptions or dePausedStates;
    if (doDisableConnectedUI in FDialOptions) then
      dwfOptions := dwfOptions or deDisableConnectedUI;
    if (doDisableReConnectUI in FDialOptions) then
      dwfOptions := dwfOptions or deDisableReconnectUI;
    if (doNoUser in FDialOptions) then
      dwfOptions := dwfOptions or deNoUser;
    if (doPauseOnScript in FDialOptions) then
      dwfOptions := dwfOptions or dePauseOnScript;

    if (FSpeakerMode <> smDefault) then begin
      dwfOptions := dwfOptions or deIgnoreModemSpeaker;
      if (FSpeakerMode = smSpeakerOn) then
        dwfOptions := dwfOptions or deSetModemSpeaker;
      {otherwise speaker is already off}
    end;

    if (FCompressionMode <> cmDefault) then begin
      dwfOptions := dwfOptions or deIgnoreSoftwareCompression;
      if (FCompressionMode = cmCompressionOn) then
        dwfOptions := dwfOptions or deSetSoftwareCompression;
      {otherwise SW compression is already off}
    end;
  end;
  Result := @DialExtensions;
end;

function TApdCustomRasDialer.AssembleDialParams : PRasDialParams;
begin
  FillChar(EntryDialParams, SizeOf(EntryDialParams), #0);
  with EntryDialParams do begin
    dwSize := SizeOf(EntryDialParams);
    StrPCopy(szEntryName, FEntryName);
    StrPCopy(szPhoneNumber, FPhoneNumber);
    StrPCopy(szCallbackNumber, FCallBackNumber);
    StrPCopy(szUserName, FUserName);
    StrPCopy(szPassword, FPassword);
    StrPCopy(szDomain, FDomain);
  end;
  Result := @EntryDialParams;
end;

function TApdCustomRasDialer.CreatePhonebookEntry : Integer;
begin
  Result := AdRasCreatePhonebookEntry(0, FPhonebook);
end;

function TApdCustomRasDialer.DeletePhonebookEntry : Integer;
begin
  Result := ecRasCannotFindPhonebookEntry;
  if (FEntryName <> '') then
    Result := AdRasDeleteEntry(FPhonebook, FEntryName);
end;

function TApdCustomRasDialer.Dial : Integer;
var
  hDialEvent : HWnd;
begin
  Hangup;
  if (FDialMode = dmAsync) then begin                                
    hDialEvent := DialEventHandle;
    if Assigned(FStatusDisplay) then                                 
      FStatusDisplay.CreateDisplay(FEntryName);                      
  end else
    hDialEvent := 0;
  FConnection := 0;
  Result := AdRasDial(AssembleDialExtensions, FPhonebook, AssembleDialParams,
    ntNotifyWindow, hDialEvent, FConnection);
  if (Result <> ecOK) then
    Hangup
  else
    DisconnectTimer.Enabled := True;
end;

function TApdCustomRasDialer.DialDlg : Integer;
begin
  FillChar(DialDlgInfo, SizeOf(DialDlgInfo), #0);
  DialDlgInfo.dwSize := SizeOf(DialDlgInfo);
  Result := AdRasDialDlg(FPhonebook, FEntryName, FPhoneNumber, @DialDlgInfo);
  if (Result = ecOk) then
    DisconnectTimer.Enabled := True;
end;

procedure TApdCustomRasDialer.DialEventWindowProc(var Msg : TMessage);
begin
  try                                                                  
    Dispatch(Msg);
    if (Msg.Msg = DialEventMsg) then begin
      if (Msg.lParam <> ecOK) then
        DoOnDialError(Msg.lParam)
      else
        DoOnDialStatus(Msg.wParam);
    end else if Msg.Msg = WM_QUERYENDSESSION then                      
      Msg.Result := 1;                                                 
  except                                                               
    Application.HandleException(Self);                                 
  end;                                                                 
end;

procedure TApdCustomRasDialer.DoDisconnectTimer(Sender : TObject);
begin
  if (ConnectState = csRasDisconnected) then
    Hangup
  else
  DisconnectTimer.Enabled := True;
end;

procedure TApdCustomRasDialer.DoOnDialError(Error : Integer);
begin
  if Assigned(FStatusDisplay) then
    FStatusDisplay.UpdateDisplay(GetErrorText(Error));
  if Assigned(FOnDialError) then
      FOnDialError(Self, Error);
  Hangup;
end;

procedure TApdCustomRasDialer.DoOnDialStatus(Status : Integer);
begin
  if (Status = csRasConnected) then
      DoOnConnected
  else if (Status = csRasDisconnected) then
    DoOnDisconnected
  else begin
    if Assigned(FStatusDisplay) then begin
      if (Status = csConnectDevice) then
        FStatusDisplay.UpdateDisplay('Dialing ' + FPhoneNumber)
      else
        FStatusDisplay.UpdateDisplay(GetStatusText(Status));
    end;
    if Assigned(FOnDialStatus) then
      FOnDialStatus(Self, Status);
  end;
end;

procedure TApdCustomRasDialer.DoOnConnected;
begin
  if Assigned(FStatusDisplay) then
    FStatusDisplay.DestroyDisplay;
  if Assigned(FOnConnected) then
    FOnConnected(Self);
end;

procedure TApdCustomRasDialer.DoOnDisconnected;
begin
  DisconnectTimer.Enabled := False;
  if Assigned(FStatusDisplay) then
    FStatusDisplay.DestroyDisplay;
  if Assigned(FOnDisconnected) then
    FOnDisconnected(Self);
end;

function TApdCustomRasDialer.EditPhonebookEntry : Integer;
begin
  Result := ecRasCannotFindPhonebookEntry;
  if (FEntryName <> '') then
    Result := AdRasEditPhonebookEntry(0, FPhonebook, FEntryName);
end;

function TApdCustomRasDialer.ClearConnectionStatistics : Integer;        {!!.06}
begin                                                                    {!!.06}
  Result := AdRasClearConnectionStatistics(Connection);                  {!!.06}
end;                                                                     {!!.06}

function  TApdCustomRasDialer.GetConnectionStatistics(                   {!!.06}
  var Statistics : TRasStatistics) : Integer;                            {!!.06}
begin                                                                    {!!.06}
  FillChar(Statistics, SizeOf(TRasStatistics), 0);                       {!!.06}
  Statistics.dwSize := SizeOf(TRasStatistics);                           {!!.06}
  Result := AdRasGetConnectionStatistics(Connection, @Statistics);       {!!.06}
end;                                                                     {!!.06}

function TApdCustomRasDialer.GetErrorText(Error : Integer) : string;
begin
  Result := AdRasGetErrorstring(Error);
end;

function TApdCustomRasDialer.GetPhonebookEntry(PBEntryName: string;
  var RasEntry: TRasEntry; var TapiConfigRec: TTapiConfigRec): Integer;
var
  RasEntrySize : DWORD;
  DevInfoSize : DWORD;
begin
  RasEntrySize := SizeOf(TRasEntry);
  FillChar(RasEntry, RasEntrySize, 0);
  RasEntry.dwSize := RasEntrySize;
  DevInfoSize := SizeOf(DevInfoSize);
  FillChar(TapiConfigRec, DevInfoSize, 0);
  Result := AdRasGetEntryProperties(FPhoneBook,
                                    PBEntryName,
                                    @RasEntry,
                                    RasEntrySize,
                                    @TapiConfigRec,
                                    DevInfoSize);    
end;

function TApdCustomRasDialer.GetFullConnectStatus(
  PRCS : PRasConnStatus) : Integer;
begin
  FillChar(PRCS^, SizeOf(TRasConnStatus), #0);
  PRCS^.dwSize := SizeOf(TRasConnStatus);
  Result := AdRasGetConnectStatus(Connection, PRCS);
end;

function TApdCustomRasDialer.GetConnectState : Integer;
var
  RCS : TRasConnStatus;
begin
  Result := csOpenPort;
  if (GetFullConnectStatus(@RCS) = ecOK) then
    Result := RCS.RasConnState;
end;

function TApdCustomRasDialer.GetDeviceType : string;
var
  RCS : TRasConnStatus;
begin
  Result := '';
  if (GetFullConnectStatus(@RCS) = ecOK) then
    Result := StrPas(RCS.szDeviceType);
end;

function TApdCustomRasDialer.GetDeviceName : string;
var
  RCS : TRasConnStatus;
begin
  Result := '';
  if (GetFullConnectStatus(@RCS) = ecOK) then
    Result := StrPas(RCS.szDeviceName);
end;

function TApdCustomRasDialer.GetStatusText(Status : Integer) : string;
begin
  Result := 'Unknown status';
  if ((Status >= csRasBase) and (Status <= csRasBaseEnd)) or
     ((Status >= csRasPaused) and (Status <= csRasPausedEnd)) or
     (Status = csRasConnected) or (Status = csRasDisconnected) then
    Result := AproLoadStr(RasBaseStatusString + Status)
  else
    Result := '';
end;

procedure TApdCustomRasDialer.Hangup;
var                                                                      {!!.02}
  RCS : TRasConnStatus;                                                  {!!.02}
begin
  AdRasHangup(Connection);
  {FConnection := 0;}                                                    {!!.02}
  while (Connection <> 0) and                                            {!!.04}
    (GetFullConnectStatus(@RCS) <> ERROR_INVALID_HANDLE) do              {!!.04}
    Sleep(0);
  FConnection := 0;                                                      {!!.02}
  if Assigned(FStatusDisplay) then
    FStatusDisplay.DestroyDisplay;
  if not (csDestroying in ComponentState) then
    DoOnDisconnected;
end;

function TApdCustomRasDialer.GetConnection : THandle;
var
  PRCA : PRasConnArray;
  BuffSize : DWord;
  NumConns : DWord;
  i : Word;
  RasResult : Integer;
begin
  Result := FConnection;
  if (Result <> 0) then
    Exit;

  BuffSize := SizeOf(TRasConnArray);
  PRCA := AllocMem(BuffSize);
  try
    PRCA^[0].dwSize := SizeOf(TRasConn);
    RasResult := AdRasEnumConnections(PRasConn(PRCA), BuffSize, NumConns);
    if (RasResult = ecOK) and (NumConns > 0) then begin
      if (FEntryName = '') then  {return first connection found}
        Result := PRCA^[0].rasConn
      else
        for i := 0 to Pred(NumConns) do
          if (StrPas(PRCA^[I].szEntryName) = FEntryName) then begin
            Result := PRCA^[I].rasConn;
            Break;
          end;
    end;
  finally
    FreeMem(PRCA, BuffSize);
  end;
end;

function TApdCustomRasDialer.GetDialParameters : Integer;
var
  PW : Boolean;
begin
  Result := ecRasCannotFindPhonebookEntry;
  if (FEntryName = '') then
    Exit;

  FillChar(EntryDialParams, SizeOf(EntryDialParams), #0);
  EntryDialParams.dwSize := SizeOf(EntryDialParams);
  StrPCopy(EntryDialParams.szEntryName, FEntryName);
  Result := AdRasGetEntryDialParams(FPhonebook, @EntryDialParams, PW);
  if (Result = ecOK) then
    with EntryDialParams do begin
      FPhoneNumber := StrPas(szPhoneNumber);
      FCallBackNumber := StrPas(szCallbackNumber);
      FUserName := StrPas(szUserName);
      FDomain := StrPas(szDomain);
      if PW then
        FPassword := StrPas(szPassword)
      else
        FPassword := '';
    end;
end;

function TApdCustomRasDialer.ListConnections(List : TStrings) : Integer;
var
  PRCA : PRasConnArray;
  BuffSize : DWord;
  NumConns : DWord;
  i : Word;
begin
  if not Assigned(List) then
    CheckException(Self, ecBadArgument);

  List.Clear;
  BuffSize := SizeOf(TRasConnArray);
  PRCA := AllocMem(BuffSize);
  try
    PRCA^[0].dwSize := SizeOf(TRasConn);
    Result := AdRasEnumConnections(PRasConn(PRCA), BuffSize, NumConns);
    if (Result = ecOK) and (NumConns > 0) then
      for i := 0 to Pred(NumConns) do
        List.Add(StrPas(PRCA^[i].szEntryName));
  finally
    FreeMem(PRCA, BuffSize);
  end;
end;

function TApdCustomRasDialer.ListEntries(List : TStrings) : Integer;
var
  PREA : PRasEntryNameArray;
  BuffSize : DWord;
  NumEntries : DWord;
  i : Integer;
begin
  if not Assigned(List) then
    CheckException(Self, ecBadArgument);

  List.Clear;
  BuffSize := SizeOf(TRasEntryNameArray);
  PREA := AllocMem(BuffSize);
  PREA^[0].dwSize := SizeOf(TRasEntryName);
  try
    Result := AdRasEnumEntries(Phonebook, PRasEntryName(PREA),
      BuffSize, NumEntries);
    if (Result = ecOK) and (NumEntries > 0) then
      for i := 0 to Pred(NumEntries) do
        List.Add(StrPas(PREA^[I].szEntryName));
  finally
    FreeMem(PREA, SizeOf(TRasEntryNameArray));
  end;
end;

function TApdCustomRasDialer.MonitorDlg : Integer;
begin
  FillChar(MonitorDlgInfo, SizeOf(MonitorDlgInfo), #0);
  MonitorDlgInfo.dwSize := SizeOf(MonitorDlgInfo);
  Result := AdRasMonitorDlg(DeviceName, @MonitorDlgInfo);
end;

procedure TApdCustomRasDialer.Notification(AComponent: TComponent;
                                           Operation: TOperation);
  {new/deleted RAS status component}
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) then begin
    if (AComponent = FStatusDisplay) then
        StatusDisplay := nil;
  end else if (Operation = opInsert) then
    if (AComponent is TApdAbstractRasStatus) then
      if not Assigned(FStatusDisplay) then
        if not Assigned(TApdAbstractRasStatus(AComponent).FRasDialer) then begin
          StatusDisplay := TApdAbstractRasStatus(AComponent);
          StatusDisplay.RasDialer := Self;
        end;
end;

function TApdCustomRasDialer.PhonebookDlg : Integer;
begin
  FillChar(PhonebookDlgInfo, SizeOf(PhonebookDlgInfo), #0);
  PhonebookDlgInfo.dwSize := SizeOf(PhonebookDlgInfo);
  Result := AdRasPhonebookDlg(FPhonebook, FEntryName, @PhonebookDlgInfo);
end;

function TApdCustomRasDialer.SetDialParameters : Integer;
begin
  Result := ecRasCannotFindPhonebookEntry;
  if (FEntryName <> '') then
    Result := AdRasSetEntryDialParams(FPhonebook, AssembleDialParams, False);
end;

procedure TApdCustomRasDialer.SetEntryName(Value : string);
begin
  FEntryName := Value;
  if not (csDesigning in ComponentState) then                        
    GetDialParameters;
end;


function TApdCustomRasDialer.GetIsRasAvailable: Boolean;                 {!!.01}
var
  SysDir : array[0..255] of Char;
begin
  Result := False;
  if (GetSystemDirectory(SysDir, sizeof(SysDir)) > 0) then
    Result := FileExists(AddBackSlash(SysDir) + RASDLL + '.DLL');
end;

function TApdCustomRasDialer.ValidateEntryName(EntryName: string): Integer;{!!.06}
  {Validates an entry name}
begin
  { Returns 0 if successful, or
  ERROR_ALREADY_EXISTS: The entry name already exists in the specified phonebook
  ERROR_CANNOT_FIND_PHONEBOOK: The specified phonebook doesn't exist
  ERROR_INVALID_NAME: The format of the specified entry name is invalid}
  Result := AdRasValidateEntryName(FPhoneBook, EntryName);
end;

{ TApdAbstractRasStatus }
constructor TApdAbstractRasStatus.Create(AOwner : TComponent);
  {create the status form}
begin
  inherited Create(AOwner);
  FCtl3D := True;
  FPosition := poScreenCenter;
end;

destructor TApdAbstractRasStatus.Destroy;
  {get rid of the status form}
begin
  DestroyDisplay;
  if Assigned(FRasDialer) then
    FRasDialer.StatusDisplay := nil;
  inherited Destroy;
end;

procedure TApdAbstractRasStatus.Notification(AComponent : TComponent;
                                             Operation: TOperation);
  {dialer component added/deleted}
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) then begin
    if (AComponent = FRasDialer) then
      FRasDialer := nil;
  end else if (Operation = opInsert) then begin
    if (AComponent is TApdRasDialer) then
      if not Assigned(FRasDialer) then
        if not Assigned(TApdRasDialer(AComponent).FStatusDisplay) then begin
          RasDialer := TApdRasDialer(AComponent);
          RasDialer.StatusDisplay := Self;
        end;
  end;
end;

procedure TApdAbstractRasStatus.SetCtl3D(Value : Boolean);
  {set Ctl3D property and pass to status form}
begin
  if (Value <> FCtl3D) then begin
    FCtl3D := Value;
    if Assigned(FDisplay) then
      FDisplay.Ctl3D := Value;
  end;
end;

procedure TApdAbstractRasStatus.SetPosition(Value : TPosition);
  {set Position property and pass to status form}
begin
  if (Value <> FPosition) then begin
    FPosition := Value;
    if Assigned(FDisplay) then
      FDisplay.Position := Value;
  end;
end;

end.
