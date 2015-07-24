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
{*                    ADVOIP.PAS 4.06                    *}
{*********************************************************}
{* TApdVoIP component, provides access to Voice over IP  *}
{*       (IP Telephony) via TAPI 3 and DirectShow        *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}


{ The TApdVoIP component does not have the complete functionality as described }
{ in the manual. Where possible, those items are annotated in the source with  }
{ "NOTE:" comments. These deficiencies will be addressed in future minor point }
{ releases.  The most obvious buglet is that we will use the default video-in  }
{ device, the local camera that captures video for transmission to the remote. }
{ TAPI 3.0 does not provide a robust mechanism for selecting a specific video  }
{ terminal, so we use whatever the default video device is. TAPI 3.1 (XP) does }
{ have the functionality built in to select the video-in device. TAPI 3.0 also }
{ did not have functional conferencing capabilities, so they are not included  }
{ here.  3.1 supposedly does have functional conferencing.                     }

{!!.01} { changes include cleanup of code }
unit AdVoIP;

interface

uses
  OleServer,
  SysUtils,
  ActiveX,
  Classes,
  Windows,
  Controls,
  ComObj,
  Messages,
  Forms,
  { APRO units }
  OOMisc,
  AdExcept,
  AdITapi3;  { TAPI 3 abbreviated type library }

type

  {TApdTerminal enumerations}
  TApdTerminalDeviceClass = (dcHandsetTerminal, dcHeadsetTerminal,
                             dcMediaStreamTerminal, dcMicrophoneTerminal,
                             dcSpeakerPhoneTerminal, dcSpeakersTerminal,
                             dcVideoInputTerminal, dcVideoWindowTerminal);
  TApdTerminalMediaType   = (mtAudio, mtVideo, mtDataModem, mtG3_Fax);
  TApdMediaDirection      = (mdCapture, mdRender, mdBiDirectional);
  TApdTerminalType        = (ttStatic, ttDynamic);
  TApdTerminalState       = (tsInUse, tsNotInUse);

  TApdDisconnectCode      = (dcNormal, dcNoAnswer, dcRejected);
  TApdQOSServiceLevel     = (qsBestEffort, qsIfAvailable, qsNeeded);
  TApdFinishMode          = (fmAsTransfer, fmAsConference);
  TApdCallState           = (csIdle, csInProgress, csConnected, csDisconnected,
                             csOffering, csHold, csQueued);
  TApdAddressType         = (atPhoneNumber, atSDP, atEmailName, atDomainName,
                             atIPAddress);

  TApdCallPriviledge      = (cpOwner, cpMonitor);

  TApdCallInfoLong = (cilMediaTypesAvailable, cilBearerMode,
                   cilCallerIDAddressType, cilCalledIDAddressType,
                   cilConnectedIDAddressType, cilRedirectionIDAddressType,
                   cilRedirectingIDAddresstype, cilOrigin, cilReason,
                   cilAppSpecific, cilCallParamsFlags, cilCallTreatment,
                   cilMinRate, cilMaxRate, cilCountryCode, cilCallID,
                   cilRelatedCallID, cilCompletionID, cilNumberOfOwners,
                   cilNumberOfMonitors, cilTrunk, cilRate);

  TApdCallInfoType = (cisCallerIDName, cisCallerIDNumber, cisCalledIDName,
                   cisCalledIDNumber, cisConnectedIDName,
                   cisConnectedIDNumber, cisRedirectionIDName,
                   cisRedirectionIDNumber, cisRedirectingIDName,
                   cisRedirectingIDNumber, cisCalledPartyFriendlyName,
                   cisComment, cisDisplayableAddress, cisCallingPartyID);

  TApdCallInfoBufferType = (cibUserUserInfo, cibDevSpecificBuffer,
                         cibCallDataBuffer, cibChargingInfoBuffer,
                         cibHighLevelCompatibilityBuffer,
                         cibLowLevelCompatibilityBuffer);

  TApdAddressState = (asInService, asOutOfService);
  TApdCallHubState = (chsActive, chsIdle);


  {forwards}
  TApdCustomVoIP = class;

  {event declarations}
  TApdVoIPNotifyEvent = procedure(VoIP: TApdCustomVoIP) of object;
  TApdVoIPFailEvent = procedure(VoIP : TApdCustomVoIP;
                                ErrorCode : Integer) of object;
  TApdVoIPIncomingCallEvent = procedure(VoIP : TApdCustomVoIP;
                                        CallerAddr: string;
                                        var Accept : Boolean) of object;
  TApdVoIPStatusEvent = procedure(VoIP : TApdCustomVoIP;
                                  TapiEvent, Status, SubStatus : Word) of object;

  { TApdCallInfo - used to hold common ITCallInfo data }
  TApdVoIPCallInfo = record
    InfoAvailable : Boolean;       { True if we get the info, False if the }
                                   { ITCallInfo interface isn't available  }
    { string type fields }
    CallerIDName,                  { the name of the caller }
    CallerIDNumber,                { the number of the caller }
    CalledIDName,                  { the name of the called location }
    CalledIDNumber,                { the number of the called location }
    ConnectedIDName,               { the name of the connected location }
    ConnectedIDNumber,             { the number of the connected location }
    CalledPartyFriendlyName,       { the called party friendly name }
    Comment,                       { a comment about the call provided by the originator }
    DisplayableAddress,            { a displayable version of the called or calling address }
    CallingPartyID : string;       { the identifier of the calling party }
    { DWORD types }
    MediaTypesAvailable,           { the media types available on the call (TAPIMEDIATYPE_*) }
    CallerIDAddressType,           { the address types (LINEADDRESSTYPE_*) }
    CalledIDAddressType,
    ConnectedIDAddressType,
    Origin,                        { the origin of the call (LINECALLORIGIN_*) }
    Reason,                        { the reason for the call (LINECALLREASON_*) }
    MinRate,                       { the minimun data rate in bps }
    MaxRate,                       { the maximum data rate in bps }
    Rate : DWORD;                  { the current rate of the call in bps }
  end;

  {TApdTerminals}
  TApdTerminals = class(TCollection)
  end;

  { TAPI3 event notification sink }
  TApdTapiEventSink = class(TObject, IUnknown, ITTAPIEventNotification)
  private
    FRefCount : Integer;
    FOwner    : TApdCustomVoIP;
    FAnswer   : Boolean;
  public
    constructor Create(AOwner : TApdCustomVoIP);

    {IUnknown}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    {ITTAPIEventNotification}
    function Event(TapiEvent: TAPI_EVENT; const pEvent: IDispatch): HResult; stdcall;
  end;

  {TApdVoIPTerminal}
  TApdVoIPTerminal = class(TCollectionItem)
  private
    FTerminalDeviceClass : TApdTerminalDeviceClass;
    FDeviceName          : string;
    FMediaDirection      : TApdMediaDirection;
    FMediaType           : TApdTerminalMediaType;
    FTerminalType        : TApdTerminalType;
    FTerminalState       : TApdTerminalState;
    function GetDeviceInUse: Boolean;
  published
    property DeviceClass : TApdTerminalDeviceClass
      read FTerminalDeviceClass;
    property DeviceInUse : Boolean
      read GetDeviceInUse;
    property DeviceName : string
      read FDeviceName;
    property MediaDirection : TApdMediaDirection
      read FMediaDirection;
    property MediaType : TApdTerminalMediaType
      read FMediaType;
    property TerminalType : TApdTerminalType
      read FTerminalType;
    property TerminalState : TApdTerminalState
      read FTerminalState;
  end;

  { Undocumented log class. Set LogName to the path\name where you want the  }
  { log to be written. VerboseLog determines whether only major events (such }
  { as when a call is connected or disconnected) happens, or whether more    }
  { detail is desired. Enabled toggles whether the log strings are added or  }
  { not. The log file is updated whenever AddLogString is called. ClearLog   }
  { will delete the log file without prompting }
  TApdVoIPLog = class(TPersistent)
  private
    FVerboseLog: Boolean;
    FEnabled: Boolean;
    FLogName: string;
    public
      procedure AddLogString(Verbose : Boolean; const S : ansistring);
      procedure ClearLog;
    published
      property LogName : string
        read FLogName write FLogName;
      property VerboseLog : Boolean
        read FVerboseLog write FVerboseLog;
      property Enabled : Boolean
        read FEnabled write FEnabled;
  end;

  TApdCustomVoIP = class(TApdBaseComponent)
  private
    FWaitingForCall: Boolean;
    FConnected: Boolean;
    FAudioInDevice: string;
    FVideoInDevice: string;
    FCallerIDName: string;
    FAudioOutDevice: string;
    FCallerIDNumber: string;
    FAvailableTerminalDevices: TApdTerminals;
    FOnFail: TApdVoIPFailEvent;
    FOnIncomingCall: TApdVoIPIncomingCallEvent;
    FOnDisconnect: TApdVoIPNotifyEvent;
    FOnConnect: TApdVoIPNotifyEvent;
    FOnStatus: TApdVoIPStatusEvent;
    FVideoOutWindow: TWinControl;
    FPreviewWindow: TWinControl;
    FEnablePreview: Boolean;
    FEnableVideo: Boolean;
    FVideoOutWindowAutoSize: Boolean;
    FPreviewWindowAutoSize: Boolean;
    FEventLog: TApdVoIPLog;
    FVoIPAvailable: Boolean;
    FCallerDisplayName: string;
    FCallComment: string;
    FCallDisplayableAddress: string;
    FCallCallingPartyID: string;
    FConnectTimeout: Integer;                                            {!!.04}

    { property access methods }
    function GetCallInfo: TApdVoIPCallInfo;
    procedure SetPreviewWindow(const Value: TWinControl);
    procedure SetVideoOutDevice(const Value: TWinControl);
    procedure SetEnablePreview(const Value: Boolean);
    procedure SetVideoInDevice(const Value: string);
    procedure SetAudioInDevice(const Value: string);
    procedure SetAudioOutDevice(const Value: string);
    procedure SetEnableVideo(const Value: Boolean);
    procedure SetVideoOutWindowAutoSize(const Value: Boolean);
    procedure SetPreviewWindowAutoSize(const Value: Boolean);
    function GetCallInfoInterface: ITCallInfo;
  protected
    { global interfaces }
    gpTapi : ITTapi;             { the TAPI interface }
    gpCall : ITBasicCallControl; { the call interface }
    gpAddress : ITAddress;       { the address interface (the H323 device) }
    gulAdvise : Integer;
    gpTAPIEventNotification : TApdTapiEventSink;
    NotifyRegister : Integer;    { handle to the notification callback }

    FHandle : HWND;              { handle to our wndproc }
    FErrorCode : Integer;        { the last error value }
    FTapiInitialized : Boolean;  { initialized or not }
    FConnectTimer : NativeUInt;  { Timer used to control connect wait }  {!!.04}

    { event generation methods }
    procedure DoConnectEvent;
    procedure DoDisconnectEvent;
    procedure DoFailEvent;
    procedure DoIncomingCallEvent;
    procedure DoStatusEvent(TapiEvent, Status, SubStatus : Word);

    { our message handler }
    procedure WndProc(var Message : TMessage);
    procedure ProcessTapiEvent(TapiEvent: TAPI_EVENT; pEvent: IDispatch);

    { control methods }
    function AddressSupportsMediaType(pAddress : ITAddress;
      lMediaType : TOleEnum) : Boolean;
      { determines if the address (H323 line) supports the media type }
    function AnswerTheCall : HRESULT;
      { answer the call, called after the OnIncomingCall event is generated }
    function DetermineAddressType(const Addr : string) : Cardinal;
      { figure out if the destination address is an IP or machine name }
    function DisconnectTheCall : HRESULT;
      { terminates a call, called from CancelCall }
    function EnablePreviewWindow(pAddress : ITAddress;
      pStream : ITStream) : HRESULT;
      { associates the outbound video stream with a local preview window }
    function FindTerminal(DevName : string; MediaType : TOleEnum;
      MediaDir : TOleEnum; var ppTerminal : ITTerminal) : HRESULT;
      { finds a terminal, used to select a specific audio device }
    function FindTheAddress : HRESULT;
      { finds the H323 line address }
    function GetTerminal(pAddress : ITAddress; pStream : ITStream;
      var ppTerminal : ITTerminal) : HRESULT;
      { gets a terminal associated with the given stream }
    function GetVideoRenderTerminal(pAddress : ITAddress;
      var ppTerminal : ITTerminal) : HRESULT;
      { associates the outbound video stream with the terminal }
    function GetVideoRenderTerminalFromStream(
      pCallMediaEvent : ITCallMediaEvent; var ppTerminal : ITTerminal;
      var pfRenderStream : Boolean) : HRESULT;
      { associates the stream with a terminal }
    procedure HostWindow(pVideoWindow : IVideoWindow; IsRenderStream : Boolean);
      { sets up the preview and video render windows }
    function InitializeTapi : HRESULT;
      { initializes TAPI3 }
    function IsAudioCaptureStream(pStream : ITStream) : Boolean;
      { determines if the stream is an audio capture (outbound from mic.) stream }
    function IsAudioRenderStream(pStream : ITStream) : Boolean;
      { determines if the stream is an audio render (inbound to speakers) stream }
    function IsVideoCaptureStream(pStream : ITStream) : Boolean;
      { determines if the stream is a video capture (send video from camera) stream }
    function IsVideoRenderStream(pStream : ITStream) : Boolean;
      { determines if the stream is a video capture (inbound from remote) stream }
    procedure LoadTerminals;
      { Enumerates terminals for the AvailableTerminaDevices collection }
    function MakeTheCall (dwAddressType : DWORD;
      szAddressToCall : WideString) : Boolean;
      { Makes an outbound call }
    function RegisterTapiEventInterface : HRESULT;
      { Create the TAPI3 event sink so we get TAPI messages }
    procedure ReleaseTheCall;
      { Cleans up the call interface }
    function SelectTerminalOnCall(pAddress : ITAddress;
      pCall : ITBasicCallControl) : HRESULT;
      { Find and select the terminals for the call }
    procedure ShutDownTapi;
      { Cleans up the call interface and the TAPI interface }

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Notification(AComponent : TComponent; Operation: TOperation); override;

    procedure CancelCall;
      { Terminates whatever we were doing }
    procedure Connect(DestAddr : string);
      { Establishes a connection by dialing or answering (if DestAddr is '') }
    function ShowMediaSelectionDialog : Boolean;
      { Display the media selection dialog to select terminals }

    { property to remain unpublished }
    property AvailableTerminalDevices : TApdTerminals
      read FAvailableTerminalDevices;

    { the following three properties are transmitted to the answering   }
    { station when placing a call. CallingParyID is used by PhoneDialer }
    { to indicate the originator of the call.                           }
    property CallComment : string            { comment for outbound calls }
      read FCallComment write FCallComment;
    property CallDisplayableAddress : string { displayable address for outbound calls }
      read FCallDisplayableAddress write FCallDisplayableAddress;
    property CallCallingPartyID : string     { CallingParyID for outbound calls }
      read FCallCallingPartyID write FCallCallingPartyID;

    property CallInfo : TApdVoIPCallInfo
      read GetCallInfo;
    property CallInfoInterface : ITCallInfo
      read GetCallInfoInterface;
    property CallerIDName : string
      read FCallerIDName;
    property CallerIDNumber : string
      read FCallerIDNumber;
    property CallerDisplayName : string
      read FCallerDisplayName;
    property Connected : Boolean
      read FConnected;
    property ErrorCode : Integer                                         {!!.01}
      read FErrorCode;                                                   {!!.01}
    property VoIPAvailable : Boolean
      read FVoIPAvailable;
    property WaitingForCall : Boolean
      read FWaitingForCall;

    { properties to publish in TApdVoIP component }
    property AudioInDevice : string
      read FAudioInDevice write SetAudioInDevice;
    property AudioOutDevice : string
      read FAudioOutDevice write SetAudioOutDevice;
    property ConnectTimeout : Integer                                    {!!.04}
      read FConnectTimeout write FConnectTimeout;                        {!!.04}
    property EnablePreview : Boolean
      read FEnablePreview write SetEnablePreview;
    property EnableVideo : Boolean
      read FEnableVideo write SetEnableVideo;
    property VideoInDevice : string
      read FVideoInDevice write SetVideoInDevice;
    property VideoOutWindow : TWinControl
      read FVideoOutWindow write SetVideoOutDevice;
    property VideoOutWindowAutoSize : Boolean
      read FVideoOutWindowAutoSize write SetVideoOutWindowAutoSize;
    property PreviewWindow : TWinControl
      read FPreviewWindow write SetPreviewWindow;
    property PreviewWindowAutoSize : Boolean
      read FPreviewWindowAutoSize write SetPreviewWindowAutoSize;
    property EventLog : TApdVoIPLog
      read FEventLog write FEventLog;

    {Events}
    property OnConnect : TApdVoIPNotifyEvent
      read FOnConnect write FOnConnect;
    property OnDisconnect : TApdVoIPNotifyEvent
      read FOnDisconnect write FOnDisconnect;
    property OnFail : TApdVoIPFailEvent
      read FOnFail write FOnFail;
    property OnIncomingCall : TApdVoIPIncomingCallEvent
      read FOnIncomingCall write FOnIncomingCall;
    property OnStatus : TApdVoIPStatusEvent
      read FOnStatus write FOnStatus;
  end;

  TApdVoIP = class(TApdCustomVoIP)
  published
    property AudioInDevice;
    property AudioOutDevice;
    property ConnectTimeout;                                             {!!.04}
    property EnablePreview;
    property EnableVideo;
    property EventLog;
    property PreviewWindow;
    property PreviewWindowAutoSize;
    property VideoInDevice;
    property VideoOutWindow;
    property VideoOutWindowAutoSize;

    property OnConnect;
    property OnDisconnect;
    property OnFail;
    property OnIncomingCall;
    property OnStatus;
  end;

implementation

uses
  AdVoIPEd;

const
  { consts used in the wParam of our message to indicate what the message does }
  etConnect      = 0; { generate OnConnect }
  etDisconnect   = 1; { generate OnDisconnect }
  etFail         = 2; { generate OnFail }
  etIncomingCall = 3; { generate OnIncomingCall }
  etStatus       = 4; { generate OnStatus }
  etAnswer       = 5; { answer the call }
  etDisconnected = 6; { we're disconnected }
  etCallState    = 7; { processing a callstate event }

{ TApdCustomVoIP }

function TApdCustomVoIP.AddressSupportsMediaType(pAddress: ITAddress;
  lMediaType: TOleEnum): Boolean;
  { see if this address supports the media type }
var
  pMediaSupport : ITMediaSupport;
begin
  Result := False;
  if (pAddress.QueryInterface(IID_ITMediaSupport, pMediaSupport) = S_OK) then
    Result := pMediaSupport.QueryMediaType(lMediaType);
end;

function TApdCustomVoIP.AnswerTheCall: HRESULT;
  { answer the call }
var
  pCallInfo : ITCallInfo;
  pAddress : ITAddress;
begin
  if gpCall = nil then begin
    Result := E_UNEXPECTED;
    Exit;
  end;

  { get the address object of this call }
  Result := gpCall.QueryInterface(IID_ITCallInfo, pCallInfo);
  if Result <> S_OK then begin
    gpCall := nil;
    Exit;
  end;

  pAddress := pCallInfo.get_Address;
  if pAddress = nil then begin
    gpCall := nil;
    Result := E_OUTOFMEMORY;
    Exit;
  end;

 { select the terminals, if any fail we'll just skip them }
 Result := SelectTerminalOnCall(pAddress, gpCall);

 { now, we'll answer the call }
 gpCall.Answer;
end;

procedure TApdCustomVoIP.CancelCall;
  { terminates the call, returns to normal }
begin
  DisconnectTheCall;
end;

procedure TApdCustomVoIP.Connect(DestAddr: string);
  { starts an outbound or inbound call }
begin
  if not FVoIPAvailable then
    raise EVoIPNotSupported.CreateUnknown(sVoIPNotAvailable, 0);

  FErrorCode := ecOK;

  if not (FTapiInitialized) then
    FTapiInitialized := InitializeTapi = S_OK;

  { remove leading/trailing spaces and embedded control chars }
  Trim(DestAddr);

  if DestAddr = '' then begin
    { wait for a call }
    FWaitingForCall := True;
  end else begin
    { place the call }
    FWaitingForCall := False;
    MakeTheCall(DetermineAddressType(DestAddr), DestAddr);
  end;
end;

constructor TApdCustomVoIP.Create(AOwner: TComponent);
  { create ourselves, set up the defaults }
begin
  inherited;
  FTapiInitialized := False;
  FWaitingForCall := False;
  FConnected := False;
  FConnectTimeout := 120; { seconds to wait for the remote to answer }   {!!.04}
  FConnectTimer := 1;
  FErrorCode := ecOK;
  FHandle := AllocateHWnd(WndProc);
  FEnableVideo := True;
  FEnablePreview := True;
  FVideoOutWindowAutoSize := True;
  FPreviewWindowAutoSize := True;
  FEventLog := TApdVoIPLog.Create;
  FEventLog.FLogName := 'VoIP.log';
  FAvailableTerminalDevices := TApdTerminals.Create(TApdVoIPTerminal);
end;

destructor TApdCustomVoIP.Destroy;
  { destroy ourselves }
begin
  ShutDownTapi;
  FAvailableTerminalDevices.Free;                                        {!!.04}
  gpTAPIEventNotification.Free;                                          {!!.04}
  KillTimer(FHandle, FConnectTimer);                                     {!!.04}
  if FHandle <> 0 then DeallocateHWnd(FHandle);
  FEventLog.Free;
  inherited;
end;

function TApdCustomVoIP.DetermineAddressType(const Addr: string): Cardinal;
  { determine whether this is an IP or machine name address }
var
  I, DotCnt : Integer;
begin
  { making some assumptions: an IP address will not have alpha chars, a }
  { fully qualified machine name will have alpha chars, a truncated machine }
  { name will not have 3 dots }
  DotCnt := 0;
  I := 1;
  Result := 0;
  while (Result = 0) and (I <= Length(Addr)) do begin
    if CharInSet(Addr[I], ['A'..'Z', 'a'..'z']) then
      Result := LINEADDRESSTYPE_DOMAINNAME;
    if Addr[I] = '.' then
      inc(DotCnt);
    inc(I);
  end;
  if I > Length(Addr) then
    if DotCnt = 3 then
      Result := LINEADDRESSTYPE_IPADDRESS;
end;

function TApdCustomVoIP.DisconnectTheCall: HRESULT;
  { terminate a call }
begin
  if gpCall = nil then begin
    Result := S_FALSE;
    Exit;
  end;
  gpCall.Disconnect(DC_NORMAL);
  Result := S_OK;
end;

procedure TApdCustomVoIP.DoConnectEvent;
  { generate the OnConnect event }
begin
  if FConnectTimer > 0 then begin                                        {!!.04}
    KillTimer(FHandle, FConnectTimer);                                   {!!.04}
    FConnectTimer := 0;                                                  {!!.04}
  end;                                                                   {!!.04}
  FEventLog.AddLogString(False, 'Connected');
  FConnected := True;
  if Assigned(FOnConnect) then begin
    FOnConnect(Self);
  end;
end;

procedure TApdCustomVoIP.DoDisconnectEvent;
  { generate the OnDisconnect event }
begin
  FEventLog.AddLogString(False, 'Disconnected');
  if NotifyRegister > 0 then
    gpTapi.UnregisterNotifications(NotifyRegister);
  NotifyRegister := 0;
  if FConnected and Assigned(FOnDisconnect) then begin
    FOnDisconnect(Self);
  end;
  FConnected := False;
end;

procedure TApdCustomVoIP.DoFailEvent;
  { generate the OnFail event }
begin
  if FConnectTimer > 0 then begin                                        {!!.04}
    KillTimer(FHandle, FConnectTimer);                                   {!!.04}
    FConnectTimer := 0;                                                  {!!.04}
  end;                                                                   {!!.04}
  FEventLog.AddLogString(False, AnsiString('Failed (' + IntToStr(FErrorCode) + ')'));
  if Assigned(FOnFail) then begin
    FOnFail(Self, FErrorCode);
  end;
end;

procedure TApdCustomVoIP.DoIncomingCallEvent;
  { generate the OnIncomingCall event, determine whether we answer or not }
var
  Accept : Boolean;
  Addr : string;
begin
  Accept := True;
  if FCallerDisplayName > '' then
    Addr := FCallerDisplayName
  else if FCallerIDName > '' then
    Addr := FCallerIDName
  else
    Addr := FCallerIDNumber;
  FEventLog.AddLogString(True, AnsiString('Incoming call, DisplayName: ' + FCallerDisplayName));
  FEventLog.AddLogString(True, AnsiString('Incoming call, CallerIDNumber: ' + FCallerIDNumber));
  FEventLog.AddLogString(True, AnsiString('Incoming call, CallerIDName: ' + FCallerIDName));
  if Assigned(FOnIncomingCall) then
    FOnIncomingCall(Self, Addr, Accept);
  if Accept then begin
    { accepting the call }
    FEventLog.AddLogString(False, 'Incoming call accepted');
    AnswerTheCall;
  end else begin
    { rejecting the call }
    FEventLog.AddLogString(False, 'Rejecting the call');
    DisconnectTheCall;
  end;
end;

procedure TApdCustomVoIP.DoStatusEvent(TapiEvent, Status, SubStatus : Word);
  { generate the OnStatus event }
begin
  FEventLog.AddLogString(True, AnsiString('DoStatusEvent (TapiEvent=' +
    IntToStr(TapiEvent) + ', Status=' + IntToStr(Status) +
    ', SubStatus=' + IntToStr(SubStatus) + ')'));
  if Assigned(FOnStatus) then begin
    FOnStatus(Self, TapiEvent, Status, SubStatus);
  end;
end;

function TApdCustomVoIP.EnablePreviewWindow(pAddress: ITAddress;
  pStream: ITStream): HRESULT;
  { hook up the preview dynamic terminal }
var
  pTerminal : ITTerminal;
begin
  Result := GetVideoRenderTerminal(pAddress, pTerminal);
  if Result = S_OK then
    pStream.SelectTerminal(pTerminal);
end;

function TApdCustomVoIP.FindTerminal(DevName: string;
  MediaType: TOleEnum; MediaDir: TOleEnum;
  var ppTerminal: ITTerminal): HRESULT;
  { searches the collection for the selected terminal }
var
  pTerminalSupport : ITTerminalSupport;
  pTerminal : ITTerminal;
  pTermEnum : IEnumTerminal;
  Fetched : DWORD;
begin
  Result := S_FALSE;

  pTerminalSupport := (gpAddress as ITTerminalSupport);

  pTermEnum := pTerminalSupport.EnumerateStaticTerminals;
  if pTermEnum <> nil then begin
    while pTermEnum.Next(1, pTerminal, Fetched) = S_OK do begin
      { got a terminal, see if it is the one that was selected }
      if (pTerminal.Name = DevName) and (pTerminal.Get_MediaType = Integer(MediaType))
        and (pTerminal.Get_Direction = MediaDir) then begin
          Result := S_OK;
          ppTerminal := pTerminal;
          Exit;
        end;
    end;
  end;
end;

function TApdCustomVoIP.FindTheAddress: HRESULT;
var
  pEnumAddress : IEnumAddress;
  pAddress : ITAddress;
  Fetched : DWORD;
  lMediaTypes : TOleEnum;
begin
  { enumerate the addresses }
  pEnumAddress := gpTapi.EnumerateAddresses;
  if pEnumAddress = nil then begin
    Result := E_INVALIDARG;
    Exit;
  end;
  Result := S_OK;
  {for each address found}
  while Result in [S_OK, S_FALSE] do begin
    Result := pEnumAddress.Next(1, pAddress, Fetched);

    if pAddress = nil then
      {at end of address enumerations}
      Break;

    { we only support H.323 }
    {if pAddress.AddressName = 'H323 Line' then begin}                   {!!.01}
    if UpperCase(pAddress.ServiceProviderName) = 'H323.TSP' then begin   {!!.01}
      gpAddress := pAddress;
      { register for event notifications }
      lMediaTypes := TAPIMEDIATYPE_AUDIO;
      if FEnableVideo and not((FVideoInDevice = '') or
        (FVideoInDevice = ApdNoTerminalName)) then
        if AddressSupportsMediaType(pAddress, TAPIMEDIATYPE_VIDEO) then
          lMediaTypes := lMediaTypes or TAPIMEDIATYPE_Video;
      NotifyRegister := gpTapi.RegisterCallNotifications(pAddress,
        True, True, lMediaTypes, gulAdvise);
      { found the address, we can exit now }
      Result := S_OK;                                                    {!!.01}
      Exit;                                                              {!!.01}
    end;
  end;
  { if we got here, we didn't find our address }
  Result := S_FALSE;                                                     {!!.01}
  {if Result = S_FALSE then}                                             {!!.01}
    {Result := S_OK;}                                                    {!!.01}
end;

function TApdCustomVoIP.GetCallInfo: TApdVoIPCallInfo;
  { return the ITCallInfo interface for the call }
var
  pCallInfo : ITCallInfo;
  Res : Integer;

  { using nested functions to trap exceptions if the requested info is }
  { not available }
  function CallInfoString(CallInfoString: CALLINFO_STRING) : WideString;
  begin
    Result := '';
    try
      Result := pCallInfo.Get_CallInfoString(CallInfoString);
    except
      { not available, just eat the exception and move on }
    end;
  end;

  function CallInfoLong(CallInfoLong: CALLINFO_LONG): Integer;
  begin
    Result := 0;
    try
      Result := pCallInfo.Get_CallInfoLong(CallInfoLong);
    except
      { not available, just eat the exception }
    end;
  end;
begin
  if not FVoIPAvailable then
    raise EVoIPNotSupported.CreateUnknown(sVoIPNotAvailable, 0);
  { NOTE: not all of these fields are available for all TAPI3 instances   }
  {       the docs are a bit unclear why, it may be security related      }
  {       if it's not available, an exception is raised, which we'll trap }
  Res := gpCall.QueryInterface(IID_ITCallInfo, pCallInfo);
  if Res = S_OK then begin
    Result.InfoAvailable := True;
    { string types }
    Result.CallerIDName := CallInfoString(CIS_CALLERIDNAME);
    Result.CallerIDNumber := CallInfoString(CIS_CALLERIDNUMBER);
    Result.CalledIDName := CallInfoString(CIS_CALLEDIDNAME);
    Result.CalledIDNumber := CallInfoString(CIS_CALLEDIDNUMBER);
    Result.ConnectedIDName := CallInfoString(CIS_CONNECTEDIDNAME);
    Result.ConnectedIDNumber := CallInfoString(CIS_CONNECTEDIDNUMBER);
    Result.CalledPartyFriendlyName := CallInfoString(CIS_CALLEDPARTYFRIENDLYNAME);
    Result.Comment := CallInfoString(CIS_COMMENT);
    Result.DisplayableAddress := CallInfoString(CIS_DISPLAYABLEADDRESS);
    Result.CallingPartyID := CallInfoString(CIS_CALLINGPARTYID);
    { DWORD types }
    Result.MediaTypesAvailable := CallInfoLong(CIL_MEDIATYPESAVAILABLE);
    Result.CallerIDAddressType := CallInfoLong(CIL_CALLERIDADDRESSTYPE);
    Result.CalledIDAddressType := CallInfoLong(CIL_CALLEDIDADDRESSTYPE);
    Result.ConnectedIDAddressType := CallInfoLong(CIL_CONNECTEDIDADDRESSTYPE);
    Result.Origin := CallInfoLong(CIL_ORIGIN);
    Result.Reason := CallInfoLong(CIL_REASON);
    Result.MinRate := CallInfoLong(CIL_MINRATE);
    Result.MaxRate := CallInfoLong(CIL_MAXRATE);
    Result.Rate := CallInfoLong(CIL_RATE);
  end else
    Result.InfoAvailable := False;
end;

function TApdCustomVoIP.GetCallInfoInterface: ITCallInfo;
  { ITCallInfo is described in the TAPI3 MSDN documentation, available at:   }
  { http://msdn.microsoft.com/library/default.asp?url=/library/en-us/tapi/int_itfo_8acv.asp }
  { this page seems to move around a lot, search for ITCallInfo from the     }
  { MSDN home page http://msdn.microsoft.com/default.asp for the latest info }
begin
  if not FVoIPAvailable then
    raise EVoIPNotSupported.CreateUnknown(sVoIPNotAvailable, 0);

  { if the interface is not available, the result will be nil }
  if gpCall = nil then
    Result := nil
  else
    gpCall.QueryInterface(IID_ITCallInfo, Result);
end;

function TApdCustomVoIP.GetTerminal(pAddress: ITAddress; pStream: ITStream;
  var ppTerminal: ITTerminal): HRESULT;
  { hook up the terminals for audio/video input/output }
var
  lMediaType : TOleEnum;
  dir : TOleEnum;
  pTerminalSupport : ITTerminalSupport;
begin
  lMediaType := pStream.get_MediaType;
  dir := pStream.get_Direction;

  { video render is handled differently (it's a dynamic terminal) }
  if FEnableVideo and IsVideoRenderStream(pStream) then begin
    Result := GetVideoRenderTerminal(pAddress, ppTerminal);
    Exit;
  end;

  { NOTE: we do not currently support selecting the specific static terminal }
  {   if the property is an empty string or '<none>' then we won't hook the  }
  {   terminal to the stream, otherwise we'll select the default terminal.   }

  { audio and video capture terminals are static }
  Result := pAddress.QueryInterface(IID_ITTerminalSupport, pTerminalSupport);
  if Result = S_OK then begin
    if IsAudioCaptureStream(pStream) then begin
      { select the audio capture terminal (microphone) }
      if (AudioInDevice = '') or (AudioInDevice = ApdNoTerminalName) then begin
        { don't select a terminal }
      end else if (AudioInDevice = ApdDefaultTerminalName) then begin
        { select the default terminal }
        ppTerminal := pTerminalSupport.GetDefaultStaticTerminal(lMediaType, dir)
      end else begin
        { try to find the selected terminal from the collection }
        FindTerminal(AudioInDevice, TAPIMEDIATYPE_AUDIO, TD_CAPTURE, ppTerminal);
      end;
    end else if IsAudioRenderStream(pStream) then begin
      { select the audio render terminal (speakers) }
      if (AudioOutDevice = '') or (AudioOutDevice = ApdNoTerminalName) then begin
        { don't select a terminal }
      end else if (AudioOutDevice = ApdDefaultTerminalName) then begin
        { select the default terminal }
        ppTerminal := pTerminalSupport.GetDefaultStaticTerminal(lMediaType, dir)
      end else begin
        { try to find the selected terminal from the collection }
        FindTerminal(AudioInDevice, TAPIMEDIATYPE_AUDIO, TD_RENDER, ppTerminal);
      end;
    end else if IsVideoCaptureStream(pStream) then begin
      { TAPI3 only allows the default video capture (local camera) to be selected }
      if (FVideoInDevice = '') or (FVideoInDevice = ApdNoTerminalName) then begin
        { don't select the terminal }
      end else begin
        ppTerminal := pTerminalSupport.GetDefaultStaticTerminal(lMediaType, dir);
      end;
    end;
  end;
end;

function TApdCustomVoIP.GetVideoRenderTerminal(pAddress: ITAddress;
  var ppTerminal: ITTerminal): HRESULT;
  { find the video render terminal (displays video locally) }
var
  pTerminalSupport : ITTerminalSupport;
begin
  Result := pAddress.QueryInterface(IID_ITTerminalSupport, pTerminalSupport);
  if Result = S_OK then
    ppTerminal := pTerminalSupport.CreateTerminal(
                                  GuidToString(CLSID_VideoWindowTerm),
                                  TAPIMEDIATYPE_VIDEO, TD_RENDER);
end;

function TApdCustomVoIP.GetVideoRenderTerminalFromStream(
  pCallMediaEvent: ITCallMediaEvent; var ppTerminal: ITTerminal;
  var pfRenderStream: Boolean): HRESULT;
  { hook the incoming video (or preview) stream to our window }
var
  pStream : ITStream;
  lMediaType : TOleEnum;
  pEnumTerminal : IEnumTerminal;
  Fetched : DWORD;
begin
  { get the stream for this event }
  pStream := pCallMediaEvent.get_Stream;
  if pStream = nil then begin
    Result := E_FAIL;
    Exit;
  end;

  { See if it's a video stream }
  lMediaType := pStream.get_MediaType;
  if lMediaType <> TAPIMEDIATYPE_VIDEO then begin
    Result := E_FAIL;
    Exit;
  end;

  { See if it's a render stream }
  pfRenderStream := pStream.get_Direction = TD_RENDER;

  { enumerate the terminals }
  pStream.EnumerateTerminals(pEnumTerminal);
  if pEnumTerminal = nil then begin
    Result := E_FAIL;
    Exit;
  end;

  { search for the first video render terminal }
  while pEnumTerminal.Next(1, ppTerminal, Fetched) = S_OK do begin
    if ppTerminal.Get_Direction = TD_RENDER then begin
      Result := S_OK;
      Exit;
    end;
  end;
  Result := E_FAIL;
end;

procedure TApdCustomVoIP.HostWindow(pVideoWindow: IVideoWindow;
  IsRenderStream: Boolean);
  { set up the preview/render terminals }
var
  Width, Height : Integer;
begin
  if IsRenderStream then begin
    if FEnableVideo and (FVideoOutWindow <> nil)then begin
      pVideoWindow.put_Owner(FVideoOutWindow.Handle);
      pVideoWindow.put_WindowStyle(WS_CHILDWINDOW or WS_BORDER);
      pVideoWindow.get_Width(Width);   { width of the incoming stream }
      pVideoWindow.get_Height(Height); { height of the incoming stream }
      if FVideoOutWindowAutoSize then begin
        pVideoWindow.SetWindowPosition(1, 1, Width, Height);
        FVideoOutWindow.Width := Width + 2;
        FVideoOutWindow.Height := Height + 2;
      end else
        pVideoWindow.SetWindowPosition(1, 1, FVideoOutWindow.Width - 2,
          FVideoOutWindow.Height - 2);

      pVideoWindow.put_Visible(True);
    end else if FEnableVideo then begin
      { create popup window }
      pVideoWindow.put_AutoShow(True);
      pVideoWindow.put_Visible(True);
    end;
  end else begin
    if FEnablePreview and (FPreviewWindow <> nil)then begin
      pVideoWindow.put_Owner(FPreviewWindow.Handle);
      pVideoWindow.put_WindowStyle(WS_CHILDWINDOW or WS_BORDER);
      pVideoWindow.get_Width(Width);   { width of the incoming stream }
      pVideoWindow.get_Height(Height); { height of the incoming stream }
      if FPreviewWindowAutoSize then begin
        pVideoWindow.SetWindowPosition(1, 1, Width, Height);
        FPreviewWindow.Width := Width + 2;
        FPreviewWindow.Height := Height + 2;
      end else
        pVideoWindow.SetWindowPosition(1, 1, FPreviewWindow.Width - 2,
          FPreviewWindow.Height - 2);

      pVideoWindow.put_Visible(True);
    end else if FEnablePreview then begin
      { create popup window }
      pVideoWindow.put_AutoShow(True);
      pVideoWindow.put_Visible(True);
    end;
  end;
end;

function TApdCustomVoIP.InitializeTapi: HRESULT;
  { get the interface to TAPI3 }
begin
  Result := CoCreateInstance(CLASS_TAPI, nil, CLSCTX_INPROC_SERVER,
    IID_ITTAPI, gpTapi);
  if Result <> S_OK then begin                                           {!!.01}
    FErrorCode := ecVoIPTapi3NotInstalled;                               {!!.01}
    DoFailEvent;                                                         {!!.01}
    Exit;
  end;                                                                   {!!.01}

  gpTapi.Initialize;

  { create the event notification object and register it }
  Result := RegisterTapiEventInterface;
  if Result <> S_OK then begin
    FErrorCode := ecVoIPTapi3EventFailure;                               {!!.01}
    DoFailEvent;                                                         {!!.01}       
    Exit;
  end;

  Result := FindTheAddress;

  if Result <> S_OK then begin
    { no address (H.323 line) found }
    FErrorCode := ecVoIPBadAddress;                                      {!!.01}
    DoFailEvent;                                                         {!!.01}
    gpTapi := nil;
  end;
end;

function TApdCustomVoIP.IsAudioCaptureStream(pStream: ITStream): Boolean;
  { see if this stream is the audio capture stream }
begin
  Result := (pStream.Get_Direction in [TD_CAPTURE, TD_BIDIRECTIONAL]) and
            (pStream.Get_MediaType = TAPIMEDIATYPE_AUDIO);
end;

function TApdCustomVoIP.IsAudioRenderStream(pStream: ITStream): Boolean;
  { see if this stream is the audio render stream }
begin
  Result := (pStream.Get_Direction in [TD_RENDER, TD_BIDIRECTIONAL]) and
            (pStream.Get_MediaType = TAPIMEDIATYPE_AUDIO);
end;

function TApdCustomVoIP.IsVideoCaptureStream(pStream: ITStream): Boolean;
  { see if this stream is the video capture stream }
begin
  Result := (pStream.Get_Direction in [TD_CAPTURE, TD_BIDIRECTIONAL]) and
            (pStream.Get_MediaType = TAPIMEDIATYPE_VIDEO);
end;

function TApdCustomVoIP.IsVideoRenderStream(pStream: ITStream): Boolean;
  { see if this stream is the video render stream }
begin
  Result := (pStream.Get_Direction in [TD_RENDER, TD_BIDIRECTIONAL]) and
            (pStream.Get_MediaType = TAPIMEDIATYPE_VIDEO);
end;

procedure TApdCustomVoIP.Loaded;
var
  Res : HRESULT;
begin
  inherited;
  FVoIPAvailable := False;
  { determine whether TAPI 3 is installed }
  Res := CoCreateInstance(CLASS_TAPI, nil, CLSCTX_INPROC_SERVER,
    IID_ITTAPI, gpTapi);
  if Res <> S_OK then begin                                              {!!.01}
    FErrorCode := ecVoIPTapi3NotInstalled;                               {!!.01}
    DoFailEvent;                                                         {!!.01}
    Exit;
  end;                                                                   {!!.01}
  try
    gpTapi.Initialize;

    { determine whether the H323 address is available }
    Res := FindTheAddress;
    if Res <> S_OK then begin
      {FVoIPAvailable := False;}                                         {!!.01}
      FErrorCode := ecVoIPH323NotFound;                                  {!!.01}
      DoFailEvent;                                                       {!!.01}
      gpTapi := nil;
      Exit;
    end;
    { figure out which terminals are available to us }
    LoadTerminals;
    FVoIPAvailable := True;
  finally
    { unregister our call notification }
    if NotifyRegister > 0 then
      gpTapi.UnregisterNotifications(NotifyRegister);
    NotifyRegister := 0;
    gpAddress := nil;
    gpCall := nil;
    gpTapi := nil;
    gpTAPIEventNotification := nil;
  end;
end;

procedure TApdCustomVoIP.LoadTerminals;
{- Enumerates available terminals (audio/video hardware devices) }
{  adding each to AvailableTerminalDevices collection            }
var
  pTerminal : ITTerminal;
  pTerminalSupport : ITTerminalSupport;
  RecordsFound : DWORD;
  Term : TApdVoIPTerminal;
  pTermEnum : IEnumTerminal;
  WS : WideString;
begin
  { clear the collection }
  FAvailableTerminalDevices.Clear;
  { get the terminal support interface from our address }
  pTerminalSupport := (gpAddress as ITTerminalSupport);
  { enumerate the terminals }
  pTermEnum := pTerminalSupport.EnumerateStaticTerminals;
  if pTermEnum <> nil then
    while pTermEnum.Next(1, pTerminal, RecordsFound) = S_OK do begin
      { found a terminal, extract the terminal properties }
      Term := (FAvailableTerminalDevices.Add as TApdVoIPTerminal);
      Term.FDeviceName := pTerminal.Name;
      case pTerminal.Get_MediaType of
         TAPIMEDIATYPE_AUDIO     : Term.FMediaType := mtAudio;
         TAPIMEDIATYPE_VIDEO     : Term.FMediaType := mtVideo;
         TAPIMEDIATYPE_DATAMODEM : Term.FMediaType := mtDataModem;
         TAPIMEDIATYPE_G3FAX     : Term.FMediaType := mtG3_Fax;
      end;
      case pTerminal.Get_Direction of
        TD_CAPTURE       : Term.FMediaDirection := mdCapture;
        TD_RENDER        : Term.FMediaDirection := mdRender;
        TD_BIDIRECTIONAL : Term.FMediaDirection := mdBidirectional;
      end;
      WS := pTerminal.Get_TerminalClass;
      if WS = CLSID_String_HandsetTerminal then
        Term.FTerminalDeviceClass := dcHandsetTerminal
      else if WS = CLSID_String_HeadsetTerminal then
        Term.FTerminalDeviceClass := dcHeadsetTerminal
      else if WS = CLSID_String_MediaStreamTerminal then
        Term.FTerminalDeviceClass := dcMediaStreamTerminal
      else if WS = CLSID_String_MicrophoneTerminal then
        Term.FTerminalDeviceClass := dcMicrophoneTerminal
      else if WS = CLSID_String_SpeakerphoneTerminal then
        Term.FTerminalDeviceClass := dcSpeakerPhoneTerminal
      else if WS = CLSID_String_SpeakersTerminal then
        Term.FTerminalDeviceClass := dcSpeakersTerminal
      else if WS = CLSID_String_VideoInputTerminal then
        Term.FTerminalDeviceClass := dcVideoInputTerminal
      else if WS = CLSID_String_VideoWindowTerm then
        Term.FTerminalDeviceClass := dcVideoWindowTerminal;

      case pTerminal.Get_TerminalType of
        TT_STATIC  : Term.FTerminalType := ttStatic;
        TT_DYNAMIC : Term.FTerminalType := ttDynamic;
      end;

      case pTerminal.Get_State of
        TS_INUSE    : Term.FTerminalState := tsInUse;
        TS_NOTINUSE : Term.FTerminalState := tsNotInUse;
      end;
    end;
end;

function TApdCustomVoIP.MakeTheCall(dwAddressType: DWORD;
  szAddressToCall: WideString): Boolean;
var
  lMediaTypes : TOleEnum;
  pCallInfo : ITCallInfo;
begin
  Result := False;
  lMediaTypes := 0;
  if (AddressSupportsMediaType (gpAddress, TAPIMEDIATYPE_AUDIO)) then
    lMediaTypes := TAPIMEDIATYPE_AUDIO;
  { only enable the video media mode if we want video }
  if (AddressSupportsMediaType (gpAddress, TAPIMEDIATYPE_VIDEO)) then
    lMediaTypes := lMediaTypes or TAPIMEDIATYPE_VIDEO;

  gpCall := gpAddress.CreateCall(szAddressToCall, dwAddressType, lMediaTypes);

  if not Assigned(gpCall) then
    Exit;

  if gpCall.QueryInterface(IID_ITCallInfo, pCallInfo) = S_OK then begin
    { these are the only parts of the pCallInfo that can be set }
    if Length(FCallComment) > 0 then                                     {!!.01}
      pCallInfo.Set_CallInfoString(CIS_COMMENT, FCallComment);
    if Length(FCallDisplayableAddress) > 0 then                          {!!.01}
      pCallInfo.Set_CallInfoString(CIS_DISPLAYABLEADDRESS,
        FCallDisplayableAddress);
    { PhoneDialer uses CallingPartyID for it's display }
    if Length(FCallCallingPartyID) > 0 then                              {!!.01}
      pCallInfo.Set_CallInfoString(CIS_CALLINGPARTYID, FCallCallingPartyID);
  end;

  if SelectTerminalOnCall(gpAddress, gpCall) <> S_OK then begin
    { couldn't select a terminal, just go without it }
  end;

  try
    { start the connection timer, FConnectTimeout is measured in seconds }
    if FConnectTimeout > 0 then                                          {!!.04}
      SetTimer(FHandle, FConnectTimer, (FConnectTimeout * 1000), nil);   {!!.04}
    gpCall.Connect(False);
    Result := True;
  except
    { call failed, the exception will be raised here (and trapped here) }
    { the OnFail event will be generated with the reason for the error  }
    { from the event sink }
  end;

end;

procedure TApdCustomVoIP.Notification(AComponent : TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then begin
    if (AComponent = FVideoOutWindow) then
      FVideoOutWindow := nil;
    if (AComponent = FPreviewWindow) then
      FPreviewWindow := nil;
  end;
end;

procedure TApdCustomVoIP.ProcessTapiEvent(TapiEvent: TAPI_EVENT;
  pEvent: IDispatch);
  { called as a result of receiving apw_VoIPEventMessage message from the sink }
var
  hr : HRESULT;
  pNotify : ITCallNotificationEvent;
  pCallInfo : ITCallInfo;
  pCallStateEvent : ITCallStateEvent;
  pCallMediaEvent : ITCallMediaEvent;
  pTerminal : ITTerminal;
  fRenderStream : Boolean;
  pVideoWindow : IVideoWindow;
begin
  case TapiEvent of
    TE_CALLNOTIFICATION : { we're being notified of a new call }
      begin
        hr := pEvent.QueryInterface(IID_ITCallNotificationEvent, pNotify);
        if hr <> S_OK then begin
          { DoMessage('Incoming call, but failed to get the interface'); }
        end else begin
          pCallInfo := pNotify.Get_Call;
          pNotify._Release;
          if pCallInfo <> nil then begin
            try
              FCallerIDName := pCallInfo.Get_CallInfoString(CIS_CALLERIDNAME);
            except
              FCallerIDName := 'Not available';
            end;
            try
              FCallerIDNumber := pCallInfo.Get_CallInfoString(CIS_CALLERIDNUMBER);
            except
              FCallerIDNumber := 'Not available';
            end;
            try
              FCallerDisplayName := pCallInfo.Get_CallInfoString(CIS_DISPLAYABLEADDRESS);
            except
              FCallerDisplayName := 'Not available';
            end;
            if pCallInfo.get_Privilege <> CP_OWNER then begin
              { not our call, just exit }
              Exit;
            end;
            { get the ITBasicCallControl interface }
            hr := pCallInfo.QueryInterface(IID_ITBasicCallControl, gpCall);
            if hr = S_OK then begin
              PostMessage(FHandle, apw_VoIPEventMessage, etIncomingCall, 0);
            end;
          end;
        end;
      end;
    TE_CALLSTATE : { call state event }
      begin
        hr := pEvent.QueryInterface(IID_ITCallStateEvent, pCallStateEvent);
        if hr = S_OK then begin
          { get the CallState event }
          case pCallStateEvent.get_State of
            CS_IDLE,
            CS_INPROGRESS :
              begin
                PostMessage(FHandle, apw_VoIPEventMessage, etCallState,
                  pCallStateEvent.get_State);
              end;
            CS_OFFERING :
              begin
                if FWaitingForCall then
                  PostMessage(FHandle, apw_VoIPEventMessage, etAnswer, 0);
              end;
            CS_DISCONNECTED :
              begin
                PostMessage(FHandle, apw_VoIPEventMessage, etDisconnected,
                  pCallStateEvent.Get_Cause);                            {!!.01}
              end;
            CS_CONNECTED :
              begin
                PostMessage(FHandle, apw_VoIPEventMessage, etConnect, 0);
              end;
          end;
          { get the CallState event cause }
          case pCallStateEvent.Get_Cause of
            CEC_NONE,
            CEC_DISCONNECT_NORMAL :
              begin
                { nothing to do, normal disconnect }
              end;
            CEC_DISCONNECT_BUSY,
            CEC_DISCONNECT_BADADDRESS,
            CEC_DISCONNECT_NOANSWER,
            CEC_DISCONNECT_CANCELLED,
            CEC_DISCONNECT_REJECTED,
            CEC_DISCONNECT_FAILED :
              begin
                PostMessage(FHandle, apw_VoIPEventMessage, etFail,
                  pCallStateEvent.Get_Cause);
              end;
          end;
        end;
      end;
    TE_CALLMEDIA :
      begin
        hr := pEvent.QueryInterface(IID_ITCallMediaEvent, pCallMediaEvent);
        if hr = S_OK then begin
          case pCallMediaEvent.get_Event of
            CME_STREAM_NOT_USED,
            CME_NEW_STREAM : { nothing to do } ;
            CME_STREAM_FAIL :
              begin
                { DoMessage('Call media event: stream failed'); }
              end;
            CME_STREAM_INACTIVE :
              begin
                { refresh our terminal collection }
                LoadTerminals;
              end;
            CME_TERMINAL_FAIL :
              begin
                { DoMessage('Call media event: terminal failed'); }
              end;
            CME_STREAM_ACTIVE :
              begin
                { see if this is a video render terminal }
                hr := GetVideoRenderTerminalFromStream(pCallMediaEvent,
                  pTerminal, fRenderStream);
                if hr = S_OK then begin
                  pVideoWindow := nil;
                  hr := pTerminal.QueryInterface(IID_IVideoWindow,
                    pVideoWindow);
                  if hr = S_OK then begin
                    HostWindow(pVideoWindow, fRenderStream);
                  end;
                end;
                { refresh our terminal collection }
                LoadTerminals;
              end;
          end;
        end;
      end;
  end;
end;

function TApdCustomVoIP.RegisterTapiEventInterface: HRESULT;
  { create the event sink and register it }
var
  pCPC : IConnectionPointContainer;
  pCP : IConnectionPoint;
begin
  {Create  event sink}
  gpTAPIEventNotification := TApdTapiEventSink.Create(self);

  {ensure valid}
  if gpTAPIEventNotification = nil then begin
    Result := E_FAIL;
    Exit;
  end;

  Result := gpTapi.QueryInterface(IID_IConnectionPointContainer, pCPC);
  if Result <> S_OK then Exit;

  Result := pCPC.FindConnectionPoint(IID_ITTAPIEventNotification, pCP);
  if Result <> S_OK then Exit;

  Result := pCP.Advise(gpTAPIEventNotification, gulAdvise);

  { set the event filter to only give us the events we want }
  gpTapi.Set_EventFilter(TE_CALLNOTIFICATION or TE_CALLSTATE or TE_CALLMEDIA);
end;

procedure TApdCustomVoIP.ReleaseTheCall;
  { um, release the call }
begin
  if gpCall <> nil then
    gpCall := nil;
end;

function TApdCustomVoIP.SelectTerminalOnCall(pAddress: ITAddress;
  pCall: ITBasicCallControl): HRESULT;
  { find and select the terminals for the call }
var
  pStreamControl : ITStreamControl;
  pEnumStreams : IEnumStream;
  pStream : ITStream;
  pTerminal : ITTerminal;
  Fetched : DWORD;
begin
  { get the ITStreamControl interface for this call }
  Result := pCall.QueryInterface(IID_ITStreamControl, pStreamControl);
  if Result = S_OK then begin
    { enumerate the streams }
    pStreamControl.EnumerateStreams(pEnumStreams);
    if pEnumStreams = nil then begin
      Result := E_OUTOFMEMORY;
      Exit;
    end;
    while pEnumStreams.Next(1, pStream, Fetched) = S_OK do begin
      { find the media type and direction of this stream and create }
      { the default terminal for this media type and direction      }
      Result := GetTerminal(pAddress, pStream, pTerminal);
      if Result = S_OK then begin
        { select the terminal on the stream }
        pStream.SelectTerminal(pTerminal);
        if IsVideoCaptureStream(pStream) and                                // SWB
         (FVideoInDevice <> '') and                                         // SWB
         (FVideoInDevice <> ApdNoTerminalName) and                          // SWB
         FEnablePreview then
          EnablePreviewWindow(pAddress, pStream);
      end;
    end;
  end;
end;

procedure TApdCustomVoIP.SetAudioInDevice(const Value: string);
  { AudioOutDevice write access method }
begin
  FAudioInDevice := Value;
  if UpperCase(FAudioInDevice) = UpperCase(ApdDefaultTerminalName) then
    FAudioInDevice := ApdDefaultTerminalName;
  if (UpperCase(FAudioInDevice) = UpperCase(ApdNoTerminalName)) or
    (FAudioInDevice = '') then
    FAudioInDevice := ApdNoTerminalName;
end;

procedure TApdCustomVoIP.SetAudioOutDevice(const Value: string);
  { AudioOutDevice write access method }
begin
  FAudioOutDevice := Value;
  if UpperCase(FAudioOutDevice) = UpperCase(ApdDefaultTerminalName) then
    FAudioOutDevice := ApdDefaultTerminalName;
  if (UpperCase(FAudioOutDevice) = UpperCase(ApdNoTerminalName)) or
     (FAudioOutDevice = '')  then
    FAudioOutDevice := ApdNoTerminalName;
end;

procedure TApdCustomVoIP.SetEnablePreview(const Value: Boolean);
  { EnablePreview write access method }
begin
  FEnablePreview := Value;
  if not FEnableVideo then
    { Preview is only available if we're transmitting video }
    FEnablePreview := False;
end;

procedure TApdCustomVoIP.SetEnableVideo(const Value: Boolean);
  { EnableVideo write access method }
begin
  FEnableVideo := Value;
  if not FEnableVideo then
    { Preview is only available if we're transmitting video }
    FEnablePreview := False;
end;

procedure TApdCustomVoIP.SetPreviewWindow(const Value: TWinControl);
  { PreviewWindow write access method }
begin
  FPreviewWindow := Value;
end;

procedure TApdCustomVoIP.SetPreviewWindowAutoSize(const Value: Boolean);
begin
  { NOTE: Setting this property while stream is being rendered not supported }
  FPreviewWindowAutoSize := Value;
end;

procedure TApdCustomVoIP.SetVideoInDevice(const Value: string);
  { VideoInDevice write access method }
begin
  { only default video in (local camera) terminal supported }
  { property is limited to '<none>' or '<default>'          }
  FVideoInDevice := Value;
  if (UpperCase(FVideoInDevice) = UpperCase(ApdNoTerminalName)) or
    (FVideoInDevice = '') then
    FVideoInDevice := ApdNoTerminalName
  else
    FVideoInDevice := ApdDefaultTerminalName;
end;

procedure TApdCustomVoIP.SetVideoOutDevice(const Value: TWinControl);
  { VideoOutWindow write access method }
begin
  FVideoOutWindow := Value;
end;

procedure TApdCustomVoIP.SetVideoOutWindowAutoSize(const Value: Boolean);
begin
  { NOTE: Setting this property while stream is being rendered not supported }
  FVideoOutWindowAutoSize := Value;
end;

function TApdCustomVoIP.ShowMediaSelectionDialog: Boolean;
  { display the media selection dialog to select the audio/video in/out devices }
begin
  if not FVoIPAvailable then
    raise EVoIPNotSupported.CreateUnknown(sVoIPNotAvailable, 0);

  Result := EditVoIPAudioVideo(Self, Name);
end;

procedure TApdCustomVoIP.ShutDownTapi;
  { deallocate our TAPI hooks }
begin
  if gpCall <> nil then begin
    gpCall := nil;
  end;

  if gpTapi <> nil then begin
    gpTapi.Shutdown;
  end;
end;

procedure TApdCustomVoIP.WndProc(var Message: TMessage);
  { message handler }
begin
  case Message.Msg of
    apw_VoIPNotifyMessage : {message sent by event sink }
      begin
        ProcessTapiEvent(TAPI_EVENT(Message.wParam), IDispatch(Message.lParam));
      end;
    apw_VoIPEventMessage  : { message sent to generate event asynchronously }
      begin
        if Message.wParam in [etDisconnected, etFail] then begin         {!!.01}
          case Message.lParam of                                         {!!.01}
            CEC_NONE                  : FErrorCode := ecOK;              {!!.01}
            CEC_DISCONNECT_BUSY       : FErrorCode := ecVoIPCallBusy;    {!!.01}
            CEC_DISCONNECT_BADADDRESS : FErrorCode := ecVoIPBadAddress;  {!!.01}
            CEC_DISCONNECT_NOANSWER   : FErrorCode := ecVoIPNoAnswer;    {!!.01}
            CEC_DISCONNECT_CANCELLED  : FErrorCode := ecVoIPCancelled;   {!!.01}
            CEC_DISCONNECT_REJECTED   : FErrorCode := ecVoIPRejected;    {!!.01}
            CEC_DISCONNECT_FAILED     : FErrorCode := ecVoIPFailed;      {!!.01}
          end;                                                           {!!.01}
        end;                                                             {!!.01}

        case Message.wParam of
          etConnect      : DoConnectEvent;
          etDisconnected : DoDisconnectEvent;
          etFail         : DoFailEvent;
          etIncomingCall : DoIncomingCallEvent;
          etStatus       : DoStatusEvent(0, 0, 0);
        end;
      end;
    WM_TIMER : { this is our ConnectTimeout timer }                      {!!.04}
      begin                                                              {!!.04}
        if Message.WParam = FConnectTimer then begin
          { ConnectTimeout seconds have elapsed, cancel the attempt }    {!!.04}
          KillTimer(FHandle, FConnectTimer);                             {!!.04}
          DisconnectTheCall;                                             {!!.04}
        end;                                                             {!!.04}                                                                    
      end;                                                               {!!.04}

    else begin               { default message processing }
      try
        Dispatch(Message);
        if Message.Msg = WM_QUERYENDSESSION then
          Message.Result := 1;
      except
        Application.HandleException(Self);
      end;

    end;
  end;
end;

{ TApdTapiEventSink }
{ the event sink is an interface that gets the TAPI events, we post a message }
{ to the TApdCustomVoIP component to handle the events asynchronously }

function TApdTapiEventSink._AddRef: Integer;
begin
  inc(FRefCount);
  Result := FRefCount;
end;

function TApdTapiEventSink._Release: Integer;
begin
  Dec(FRefCount);
  if FRefCount = 0 then begin
    Result := 0;
    Free;
  end else
    Result := FRefCount;
end;

constructor TApdTapiEventSink.Create(AOwner: TApdCustomVoIP);
begin
  FOwner := AOwner;
  FAnswer := False;
end;

function TApdTapiEventSink.Event(TapiEvent: TAPI_EVENT;
  const pEvent: IDispatch): HResult;
  { this is the event interface itself }
begin
  pEvent._AddRef;
  { post a message to our WndProc so the event sink can respond to the next }
  { event }
  PostMessage(FOwner.FHandle, apw_VoIPNotifyMessage,
    wParam(TapiEvent), lParam(pEvent));
  Result := S_OK;
end;

function TApdTapiEventSink.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if (IsEqualGUID(IID, IUnknown) or IsEqualGUID(IID, IID_ITTAPIEventNotification)) then begin
    inc(FRefCount);
    if GetInterface(IID, Obj) then
      Result := S_OK else Result := E_NOINTERFACE;
  end else
    Result := E_NOINTERFACE;
end;

{ TApdVoIPLog }

procedure TApdVoIPLog.AddLogString(Verbose : Boolean; const S: Ansistring);
var
  LogStream : TFileStream;
  TimeStamp : ansistring;
begin
  if FEnabled then
    if Verbose and FVerboseLog then begin
      if FileExists(FLogName) then
        LogStream := TFileStream.Create(FLogName, fmOpenReadWrite	or fmShareDenyNone)
      else
        LogStream := TFileStream.Create(FLogName, fmCreate or fmShareDenyNone);
      LogStream.Seek(0, soFromEnd);
      TimeStamp := AnsiString(FormatDateTime('dd/mm/yy : hh:mm:ss - ', Now) + string(S) + #13#10);
      LogStream.WriteBuffer(TimeStamp[1], Length(TimeStamp));
      LogStream.Free;
    end;
end;

procedure TApdVoIPLog.ClearLog;
begin
  SysUtils.DeleteFile(FLogName);
end;

{ TApdVoIPTerminal }

function TApdVoIPTerminal.GetDeviceInUse: Boolean;
begin
  Result := FTerminalState = tsInUse;
end;

end.
