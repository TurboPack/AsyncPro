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
{*                    ADTAPI.PAS 4.06                    *}
{*********************************************************}
{* TApdTapiDevice, status and log components             *}
{*********************************************************}

{
  The TApdTapiDevice negotiates for TAPI 1.4, which is pre-installed
  in all 32-bit Windows versions (Win9x through XP).  Voice extensions
  are available for Win95OSR2/Win98/ME/2K/XP through the default Windows
  installation (Unimodem/V and Unimodem/5).
  By far, the biggest problem with TAPI is the TAPI device itself. Always
  check the modem drivers first, and strongly suggest to your users that
  they periodically update their modem drivers.
  Known problem areas: TAPI handles answering differently when doing data or
  voice, we aren't doing any special processing to get common/consistent
  events.  The notification we receive varies a bit between TAPI versions
  also, so check to see which events fire. The TapiTest example from
  ftp://ftp.turbopower.com/pub/apro/demos/_Index.htm lets you see everything
  that happens, use that to see how your modem/environment will react.
  TAPI voice using regular modems (Unimodem/V or Unimodem/5) was not designed
  for outbound/dialed automated voice calls.  You will get an OnTapiConnect
  event shortly after dialing, regardless of whether the line was busy, and
  completely independent upon when the remote side actually answers.  The
  APROFAQ.HLP file has some tips to get around this. Of course, the TAPI
  Service Providers (TSP) that ship with dedicated voice boards usually handle
  this correctly, and you get much higher quality of voice play/record, so
  get one of those boards (Dialogic, MediaPhonics, etc) if you need to do
  outbound/dialed automated voice calls.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+,B-,J+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdTapi;
  {-Delphi TAPI interface component}

interface

uses
  Windows,
  Registry,
  Classes,
  Messages,
  Controls,
  Forms,
  Variants,
  ExtCtrls,
  Dialogs,
  MMSystem,
  SysUtils,
  AdTUtil,
  OoMisc,
  AwUser,
  AdExcept,
  AdTSel,
  AdPort;

type
  {TAPI states}
  TTapiState = (tsIdle, tsOffering, tsAccepted, tsDialTone, tsDialing,
                tsRingback, tsBusy, tsSpecialInfo, tsConnected,
                tsProceeding, tsOnHold, tsConferenced, tsOnHoldPendConf,
                tsOnHoldPendTransfer, tsDisconnected, tsUnknown);

  {TTapiConfigRec definition moved to OOMisc to support RAS}             {!!.06}

  {Wave device states}
  TWaveState  = (wsIdle, wsPlaying, wsRecording, wsData);
  TWaveMessage = (waPlayOpen, waPlayDone, waPlayClose,
                 waRecordOpen, waDataReady, waRecordClose);

  {TAPI logging codes}
  TTapiLogCode = (
    ltapiNone,              { None }
    ltapiCallStart,         { Call started }
    ltapiCallFinish,        { Call finished }
    ltapiDial,              { Dialing }
    ltapiAccept,            { Accepting an incoming call }
    ltapiAnswer,            { Answering an incoming call }
    ltapiConnect,           { Connected }
    ltapiCancel,            { Call cancelled }
    ltapiDrop,              { Call drop }
    ltapiBusy,              { Called number was busy }
    ltapiDialFail,          { Dial failed }
    ltapiReceivedDigit);    { Received a DTMF tone }

  {TAPI status event}
  TTapiStatusEvent = procedure(CP : TObject;
                               First, Last : Boolean;
                               Device, Message,
                               Param1, Param2, Param3 : Integer) of object;

  {TAPI log event}
  TTapiLogEvent = procedure(CP : TObject; Log : TTapiLogCode) of object;

  {TAPI DTMF event}
  TTapiDTMFEvent = procedure(CP : TObject; Digit : Char;
    ErrorCode: Integer) of object;

  {TAPI Caller ID event}
  TTapiCallerIDEvent =
    procedure(CP : TObject; ID, IDName: string) of object;

  {TAPI wave notify event}
  TTapiWaveNotify = procedure(CP : TObject;
                              Msg : TWaveMessage) of object;

  {TAPI wave silence event}
  TTapiWaveSilence = procedure(CP : TObject;
                               var StopRecording : Boolean;
                               var Hangup : Boolean) of object;

const
  Success = 0;
  WaitErr_WaitAborted  = 1;
  WaitErr_WaitTimedOut = 2;

  LineCallState_Any = 0;

  WaitTimeout = 30000;

  { Base of error strings in the resource }
  TapiErrorBase            = 13800;

  { Base of status strings in the resource }
  TapiStatusBase           = 13500;

  { Offsets from TapiStatusBase for the separate TAPI message classes }
  lcsBase                  = 0;            { Line Call State }
  ldsBase                  = 32;           { Line Device State }
  lrBase                   = 64;           { Line Reply }
  asBase                   = 96;           { Apro-specific }
  lcsdBase                 = 150;          { Line Call State -- Disconnect }

  {Defaults for TApdTapiLog properties}
  DefTapiHistoryName = 'APROTAPI.HIS';

  {Property inits}
  DefMaxAttempts      = 3;
  DefAnsRings         = 2;
  DefRetryWait        = 60;            { seconds }
  DefShowTapiDevices  = True;
  DefShowPorts        = True;
  DefMaxMessageLength = 60;            { 1 minute }
  DefWaveState        = wsIdle;
  DefUseSoundCard     = False;
  DefTrimSeconds      = 2;
  DefSilenceThreshold = 50;
  DefChannels         = 1;
  DefBitsPerSample    = 16;
  DefSamplesPerSecond = 8000;
  DefMonitorRecording = False;

  {Wave Error Types}
  WaveInError   = 1;
  WaveOutError  = 2;
  MMioError     = 3;

  BufferSeconds = 1;
  WaveOutBufferSeconds = 3;

type
  {Forwards}
  TApdAbstractTapiStatus = class;
  TApdTapiLog = class;

  {Custom TAPI component}
  TApdCustomTapiDevice = class(TApdBaseComponent)
  protected
    {private data}
    LineApp            : TLineApp;         {TAPI handle for this application}
    LineExt            : TLineExtensionID; {Line extension data}
    LineHandle         : TLine;            {Handle of the opened line device}
    CallHandle         : TCall;            {Handle of the current call}
    SelectedLine       : Integer;          {Device ID of selected line}
    VS                 : TVarString;       {Used to return Cid}
    DialTimer          : TTimer;           {Timer component}
    RequestedId        : Integer;          {ID being waited for}
    AsyncReply         : Integer;          {Requested reply}
    CallState          : Integer;          {Received CallState}
    ReplyReceived      : Boolean;          {True if Line Reply received}
    CallStateReceived  : Boolean;          {True if CallState received}
    TapiInUse          : Boolean;          {True means a call is active}
    TapiHasOpened      : Boolean;          {True means TAPI has been opened}
    Initializing       : Boolean;          {True during StartTapi}
    Connected          : Boolean;          {True when connected}
    StoppingCall       : Boolean;          {True during HangupCall}
    ShuttingDown       : Boolean;          {True during StopTapi}
    RetryPending       : Boolean;          {True if a retry is pending}
    TapiFailFired      : Boolean;          {True if OnTapiFailed fired}
    ReplyWait          : Boolean;          {True if waiting for reply}
    StateWait          : Boolean;          {True if waiting for call state}
    PassThruMode       : Boolean;          {True if in passthrough mode}
    WaveOutHeader      : PWaveHdr;         {Wave header for playing}
    WaveInHeader       : PWaveHdr;         {Wave header for recording}
    WaveOutHandle      : HWaveOut;         {Handle of the wave out device}
    WaveInHandle       : HWaveIn;          {Handle of the wave in  device}
    BytesRecorded      : Integer;          {Bytes recorded for this buffer}
    TotalBytesRecorded : Integer;          {Bytes recorded overall }
    WaveInBuffer1      : Pointer;          {Buffer for wave recording}
    WaveInBuffer2      : Pointer;          {Buffer for wave recording}
    WaveOutBuffer1     : Pointer;          {Buffer for wave playing  }
    WaveOutBuffer2     : Pointer;          {Buffer for wave playing  }
    ActiveBuffer       : Byte;             {The active wave in buffer}
    MmioInHandle       : Integer;          {File handle for recording}
    MmioOutHandle      : Integer;          {File handle for recording}
    RootChunk          : TMMCkInfo;        {Root chunk for wave file}
    DataChunk          : TMMCkInfo;        {Data chunk for wave file}
    TempFileName       : TFileName;        {Temporary file for recording}
    Channels           : Byte;             {# of channels for recording}
    BitsPerSample      : Byte;             {Bits per sample for recording}
    SamplesPerSecond   : Integer;          {Samples per sec for recording}
    WaveInBufferSize   : Integer;          {# of bytes in a wave in buffer}
    BytesToPlay        : Integer;          {# of bytes in the wave file}
    BytesPlayed        : Integer;          {# of bytes already played}
    BytesInBuffer      : Integer;          {# of bytes in current buffer}
    ActiveWaveOutBuffer: Byte;             {The active wave out buffer}
    WaveOutBufferSize  : Integer;          {# of bytes in wave out buffer}

    {private data stores}
    FAvgWaveInAmplitude: Integer;         {Average amplitude for recording}
    FCancelled      : Boolean;            {True if call was cancelled}
    FDialing        : Boolean;            {True when dialing, False not}
    FDialTime       : Integer;            {Elapsed dial time}
    FTapiDevices    : TStrings;           {List of tapi device names}
    FSelectedDevice : string;             {Name of selected device}
    FApiVersion     : Integer;            {Negotiated version}
    FDeviceCount    : DWORD;              {Number of supported TAPI devices}
    FTrueDeviceCount: DWORD;              {Total number of TAPI devices}
    FOpen           : Boolean;            {True to open a line device}
    FCallInfo       : PCallInfo;          {Holds current call info}
    FComPort        : TApdCustomComPort;  {Attached comport}
    FStatusDisplay  : TApdAbstractTapiStatus; {Built-in status display}
    FTapiLog        : TApdTapiLog;        {Built-in logging component}
    FNumber         : string;             {Last dialed number}
    FMaxAttempts    : Word;               {Max number of dial attempts}
    FAttempt        : Word;               {Dialing attempt number}
    FRetryWait      : Word;               {Seconds between dialing attempts}
    FAnsRings       : Byte;               {Rings to allow before answer}
    FParentHWnd     : HWnd;               {Window handle of parent}
    FShowTapiDevices: Boolean;            {Show TAPI devices}
    FShowPorts      : Boolean;            {Show ports}
    FEnableVoice    : Boolean;            {Monitor DTMF Tones if capable}
    FMaxMessageLength : Integer;          {Max message length for wave recording}
    FWaveFileName   : TFileName;          {Wave file name}
    FInterruptWave  : Boolean;            {Stops playing wave file on DTMF tone}
    FHandle         : HWnd;               {Window handle for hidden window}
    FWaveState      : TWaveState;         {Current wave device state}
    FUseSoundCard   : Boolean;            {Play the sound through the sound card}
    FSilence        : TLineMonitorTone;
    FTrimSeconds    : Byte;               {Trim silence after x seconds}
    FSilenceThreshold : Integer;          {Silence threshold for trimming}
    FMonitorRecording : Boolean;          {Echo wave recording to sound card}
    FFailCode         : Integer;          {Failure code}
    FFilterUnsupportedDevices: Boolean;   {Display only supported devices}
    FWaitingForCall: Boolean;             {True if in AutoAnswer mode}   {!!.04}

    {Events}
    FOnTapiCallerID    : TTapiCallerIDEvent;
    FOnTapiConnect     : TNotifyEvent;
    FOnTapiDTMF        : TTapiDTMFEvent;
    FOnTapiFail        : TNotifyEvent;
    FOnTapiLog         : TTapiLogEvent;
    FOnTapiPortClose   : TNotifyEvent;
    FOnTapiPortOpen    : TNotifyEvent;
    FOnTapiStatus      : TTapiStatusEvent;
    FOnTapiWaveNotify  : TTapiWaveNotify;
    FOnTapiWaveSilence : TTapiWaveSilence;

    {Callback virtual methods}
    procedure DoLineCallInfo(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineCallState(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineClose(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineCreate(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineDevState(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineGenerate(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineMonitorDigits(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineMonitorMedia(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineMonitorTone(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineReply(Device, P1, P2, P3 : Integer); virtual;
    procedure DoLineRequest(Device, P1, P2, P3 : Integer); virtual;

    function HandleLineErr(LineErr : Integer): Boolean;
    function HangupCall(AbortRetries : Boolean) : Boolean;
    procedure UpdateCallInfo(Device : Integer);
    function WaitForCallState(DesiredCallState : Integer) : Integer;
    function WaitForReply(ID : Integer) : Integer;

    {Property access methods}
    procedure SetOpen(NewOpen : Boolean);

    {Private methods}
    procedure AssureTapiReady;
    function  CidFromTapiDevice : Integer;
    procedure CheckVoiceCapable;
    procedure CheckWaveException(ErrorCode : Integer; Mode : Integer);
    procedure CheckWaveInSilence;
    function  CloseTapiPort : Boolean;
    procedure CloseWaveFile;
    procedure CreateDialTimer;
    function  DeviceIDFromName(const Name : string) : Integer;
    procedure DialPrim(PassThru : Boolean);
    procedure EnumLineDevices;
    procedure FreeWaveInBuffers;
    procedure FreeWaveOutBuffer;
    function  GetSelectedLine : Integer;
    function  GetWaveDeviceId(const Play : Boolean) : DWORD;
    procedure LoadWaveOutBuffer;
    procedure MonitorDTMF(var CallHandle: Integer;
      const DTMFMode: Integer);
    procedure OpenTapiPort;
    procedure OpenWaveFile;
    procedure PlayWaveOutBuffer;
    procedure PrepareWaveInHeader;
    function  StartTapi : Boolean;
    function  StopTapi : Boolean;
    procedure TapiDialTimer(Sender : TObject);
    procedure WndProc(var Message : TMessage);
    procedure WriteWaveBuffer;

    {Property access methods}
    function GetBPSRate : DWORD;
    function GetCalledID: string;
    function GetCalledIDName: AnsiString;
    function GetCallerID : Ansistring;
    function GetCallerIDName : Ansistring;
    function GetComNumber : Integer;
    function GetParentHWnd : HWnd;
    function GetTapiState : TTapiState;
    procedure SetStatusDisplay(const NewDisplay : TApdAbstractTapiStatus);
    procedure SetTapiLog(const NewLog : TApdTapiLog);
    procedure SetTapiDevices(const Values : TStrings);
    procedure SetSelectedDevice(const NewDevice : string);
    procedure SetEnableVoice(Value: Boolean);
    procedure SetMonitorRecording(const Value : Boolean);
    procedure SetFilterUnsupportedDevices(const Value: Boolean);

    {Private properties}
    property Open : Boolean
      read FOpen write SetOpen;

    {Event methods}
    procedure TapiStatus(First, Last : Boolean; Device, Message,
      Param1, Param2, Param3 : DWORD);
    procedure TapiLogging(Log : TTapiLogCode);
    procedure TapiPortOpen;
    procedure TapiPortClose;
    procedure TapiConnect;
    procedure TapiFail;
    procedure TapiDTMF(Digit : Char; ErrorCode: Integer);
    procedure TapiCallerID(ID, IDName: string);
    procedure TapiWave(Msg : TWaveMessage);

    {Overridden protected methods}
    procedure Notification(AComponent : TComponent; Operation: TOperation);
      override;
    procedure Loaded; override;
  public

    {Creation/destruction}
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdTapiDevice component}
    destructor Destroy; override;
      {-Destroy a TApdTapiDevice component}
    procedure Assign(Source: TPersistent); override;
      {-Assign fields from TApdTapiDevice object specified by Source}

    {Public methods}
    procedure Dial(ANumber : string);
      {-Dial ANumber}
    procedure AutoAnswer;
      {-Wait for and answer incoming calls}
    procedure ConfigAndOpen;
      {-Open the TAPI port in passthru mode}
    function CancelCall : Boolean;
      {-Cancel the current call, always returns True}
    procedure CopyCallInfo(var CallInfo : PCallInfo);
      {-Allocate and return a CallInfo structure with current callinfo}
    function GetDevConfig : TTapiConfigRec;
      {-Gets configuration string that can be used with SetDevConfig}
    function MontorTones(const Tones : array of TLineMonitorTones) : Integer;
      {-Monitor for specific tones }
    procedure SetDevConfig(const Config : TTapiConfigRec);
      {-Sets config, requires string from GetDevConfig or ShowConfigDialogEdit }
    procedure PlayWaveFile(FileName : string);
      {-Play a wave file over the TAPI wave out device }
    procedure StopWaveFile;
      {-Stop the wave file from playing }
    procedure StartWaveRecord;
      {-Start recording a wave data }
    procedure StopWaveRecord;
      {-Stop recording a wave data }
    procedure SaveWaveFile(FileName : string; Overwrite : Boolean);
      {-Save the recorded wave data to a file }
    procedure SetRecordingParams(NumChannels : Byte;
                                 NumSamplesPerSecond : Integer;
                                 NumBitsPerSample : Byte);
      {-Set the parameters used for wave recording. }
    procedure ShowConfigDialog;
      {-Show the TAPI device configuration dialog}
    function ShowConfigDialogEdit
      (const Init : TTapiConfigRec) : TTapiConfigRec;
      {-Show config dlg, returns Get/SetDevConfig compatible string}
    function SelectDevice : TModalResult;
      {-Send a DTMF tone}
    procedure SendTone(Digits : string; Duration: Integer = 0);             // SWB

    { following methods added in .06, note that we do not have compatible }
    { test equipment, so there is a chance that this won't work }
    procedure Transfer(aNumber : string);                                {!!.06}
    procedure HoldCall;                                                  {!!.06}
    procedure UnHoldCall;                                                {!!.06}

    procedure AutomatedVoicetoComms;
    function  TapiStatusMsg(const Message, State, Reason : DWORD) : string;
    function  FailureCodeMsg(const FailureCode : Integer) : string;
    function  TranslateAddress(CanonicalAddr : AnsiString) : AnsiString;
    function  TranslateAddressEx(CanonicalAddr : Ansistring;
                                 Flags : Integer;
                                 var DialableStr : Ansistring;
                                 var DisplayableStr : Ansistring;
                                 var CurrentCountry : Integer;
                                 var DestCountry : Integer;
                                 var TranslateResults : Integer) : Integer;
    function  TranslateDialog(CanonicalAddr : string) : Boolean;
    function  TapiLogToString(const LogCode: TTapiLogCode) : string;

    {read-only properties}
    property ApiVersion : Integer
      read FApiVersion;
    property Attempt : Word
      read FAttempt;
    property BPSRate : DWORD
      read GetBPSRate;
    property CalledID : string                                           {!!.04}
      read GetCalledID;                                                  {!!.04}
    property CalledIDName : Ansistring                                       {!!.04}
      read GetCalledIDName;                                              {!!.04}
    property CallerID : Ansistring
      read GetCallerID;
    property CallerIDName : Ansistring
      read GetCallerIDName;
    property Cancelled : Boolean
      read FCancelled;
    property ComNumber: Integer
      read GetComNumber;
    property Dialing : Boolean
      read FDialing;
    property FailureCode : Integer
      read FFailCode;
    property WaitingForCall : Boolean                                    {!!.04}
      read FWaitingForCall;                                              {!!.04}

  public
    property TapiDevices : TStrings
      read FTapiDevices write SetTapiDevices;
    property SelectedDevice : string
      read FSelectedDevice write SetSelectedDevice;
    property ComPort : TApdCustomComPort
      read FComPort write FComPort;
    property StatusDisplay : TApdAbstractTapiStatus
      read FStatusDisplay write SetStatusDisplay;
    property TapiLog : TApdTapiLog
      read FTapiLog write SetTapiLog;
    property AnswerOnRing : Byte
      read FAnsRings write FAnsRings default DefAnsRings;
    property MaxAttempts : Word
      read FMaxAttempts write FMaxAttempts default DefMaxAttempts;
    property RetryWait : Word
      read FRetryWait write FRetryWait default DefRetryWait;
    property ShowTapiDevices : Boolean
      read FShowTapiDevices write FShowTapiDevices;
    property ShowPorts : Boolean
      read FShowPorts write FShowPorts;
    property EnableVoice : Boolean
      read FEnableVoice write SetEnableVoice;
    property InterruptWave : Boolean
      read FInterruptWave write FInterruptWave;
    property UseSoundCard : Boolean
      read FUseSoundCard write FUseSoundCard;
    property TrimSeconds : Byte
      read FTrimSeconds write FTrimSeconds;
    property SilenceThreshold : Integer
      read FSilenceThreshold write FSilenceThreshold;
    property MonitorRecording : Boolean
      read FMonitorRecording write SetMonitorRecording;
    property ParentHWnd : HWnd
      read GetParentHWnd write FParentHWnd;
    property FilterUnsupportedDevices : Boolean
      read FFilterUnsupportedDevices write SetFilterUnsupportedDevices
      default True;

    {Read-only properties}
    property Number : string
      read FNumber;
    property DeviceCount : DWORD
      read FDeviceCount;
    property TapiState : TTapiState
      read GetTapiState;
    property WaveFileName : TFileName
      read FWaveFileName;
    property MaxMessageLength : Integer
      read FMaxMessageLength write FMaxMessageLength
      default DefMaxMessageLength;
    property WaveState : TWaveState
      read FWaveState;
    property AvgWaveInAmplitude : Integer
      read FAvgWaveInAmplitude;

    {events}
    property OnTapiStatus : TTapiStatusEvent
      read FOnTapiStatus write FOnTapiStatus;
    property OnTapiLog : TTapiLogEvent
      read FOnTapiLog write FOnTapiLog;
    property OnTapiPortOpen : TNotifyEvent
      read FOnTapiPortOpen write FOnTapiPortOpen;
    property OnTapiPortClose : TNotifyEvent
      read FOnTapiPortClose write FOnTapiPortClose;
    property OnTapiConnect : TNotifyEvent
      read FOnTapiConnect write FOnTapiConnect;
    property OnTapiFail : TNotifyEvent
      read FOnTapiFail write FOnTapiFail;
    property OnTapiDTMF : TTapiDTMFEvent
      read FOnTapiDTMF write FOnTapiDTMF;
    property OnTapiCallerID : TTapiCallerIDEvent
      read FOnTapiCallerID write FOnTapiCallerID;
    property OnTapiWaveNotify : TTapiWaveNotify
      read FOnTapiWaveNotify write FOnTapiWaveNotify;
    property OnTapiWaveSilence : TTapiWaveSilence
      read FOnTapiWaveSilence write FOnTapiWaveSilence;
  end;

  {Builtin log procedure}
  TApdTapiLog = class(TApdBaseComponent)
  protected {private}
    {.Z+}
    FTapiHistoryName : string;
    FTapiDevice      : TApdCustomTapiDevice;

    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
      {-Create a TApdTapiLog component}
    {.Z-}
    procedure UpdateLog(const Log : TTapiLogCode); virtual;
      {-Add a log entry}

  published
    property TapiHistoryName : string
      read FTapiHistoryName write FTapiHistoryName;
    property TapiDevice : TApdCustomTapiDevice
      read FTapiDevice write FTapiDevice;
  end;

  {Abstract protocol status class}
  TApdAbstractTapiStatus = class(TApdBaseComponent)
  protected {private}
    {.Z+}
    FAnswering       : Boolean;
    FCaption         : TCaption;
    FCtl3D           : Boolean;
    FDisplay         : TForm;
    FPosition        : TPosition;
    FVisible         : Boolean;

    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

  protected
    FTapiDevice      : TApdCustomTapiDevice;

    procedure SetPosition(const NewPosition : TPosition);
    procedure SetCtl3D(const NewCtl3D : Boolean);
    procedure SetVisible(const NewVisible : Boolean);
    procedure SetCaption(const NewCaption : TCaption);
    procedure GetProperties;
    procedure Show;

  public
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdAbstractTapiStatus component}
    destructor Destroy; override;
      {-Destroy a TApdAbstractTapiStatus component}
    {.Z-}
    procedure UpdateDisplay(First, Last : Boolean; Device, Message,
      Param1, Param2, Param3 : DWORD); virtual; abstract;
      {-Update the status display with current data}
    procedure CreateDisplay; dynamic; abstract;
      {-Create the status display}
    procedure DestroyDisplay; dynamic; abstract;
      {-Destroy the status display}

    property Answering : Boolean
      read FAnswering write FAnswering;
    property Display : TForm
      read FDisplay write FDisplay;
  published
    property Position : TPosition
      read FPosition write SetPosition;
    property Ctl3D : Boolean
      read FCtl3D write SetCtl3D;
    property Visible : Boolean
      read FVisible write SetVisible;
    property TapiDevice : TApdCustomTapiDevice
      read FTapiDevice write FTapiDevice;
    property Caption : TCaption
      read FCaption write SetCaption;
  end;

  {TAPI component}
  TApdTapiDevice = class(TApdCustomTapiDevice)
  published
    {properties}
    property SelectedDevice;
    property ComPort;
    property StatusDisplay;
    property TapiLog;
    property AnswerOnRing;
    property RetryWait;
    property MaxAttempts;
    property ShowTapiDevices;
    property ShowPorts;
    property EnableVoice;
    property FilterUnsupportedDevices;

    {events}
    property OnTapiStatus;
    property OnTapiLog;
    property OnTapiPortOpen;
    property OnTapiPortClose;
    property OnTapiConnect;
    property OnTapiFail;
    property OnTapiDTMF;
    property OnTapiCallerID;
    property OnTapiWaveNotify;
    property OnTapiWaveSilence;
  end;

implementation

uses
  AnsiStrings;

const
  {event types}
  etTapiConnect    = 0;
  etTapiPortOpen   = 1;
  etTapiPortClose  = 2;
  etTapiFail       = 3;
  etTapiLineCreate = 4;


var
  OldCursor : HCursor;

{General purpose routines}

  function TapiErrorCode(ErrorCode : Integer) : Integer;
    {-Return an APW error code from a TAPI error code}
  begin
    if ErrorCode = 0  then
      Result := 0
    else
      Result := (ErrorCode and $7FFFFFFF) + TapiErrorBase;
  end;

  procedure TapiException(const Ctl : TComponent;
                          const Res : Integer);
    {-Decode the TAPI result and call CheckException}
  begin
    CheckException(Ctl, -TapiErrorCode(Res));
  end;

  procedure WaitCursor;
    {-Set hourglass cursor}
  begin
    OldCursor := SetCursor(LoadCursor(0, idc_Wait));
  end;

  procedure RestoreCursor;
    {-Remove hourglass cursor and restore old}
  begin
    SetCursor(OldCursor);
  end;

{TApdTapiLog}

  procedure TApdTapiLog.Notification(AComponent : TComponent;
                                     Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      {Owned components going away}
      if AComponent = FTapiDevice then
        FTapiDevice := nil;
    end;
  end;

  constructor TApdTapiLog.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);

    {Inits}
    TapiHistoryName := DefTapiHistoryName;
  end;

  destructor TApdTapiLog.Destroy;
  begin
    if Assigned(FTapiDevice) then
      FTapiDevice.TapiLog := nil;
    inherited Destroy;
  end;

  procedure TApdTapiLog.UpdateLog(const Log : TTapiLogCode);
    {-Update the standard log}
  var
    HisFile : TextFile;

  begin
    {Exit if no name specified}
    if FTapiHistoryName = '' then
      Exit;

    { modified for .04 to check for existence of the file first }
    AssignFile(HisFile, FTapiHistoryName);
    if FileExists(FTapiHistoryName) then                               {!!.04}
      Append(HisFile)
    else                                                               {!!.04}
      Rewrite(HisFile);                                                {!!.04}

    {Write the log entry}
    with TapiDevice do begin
      case Log of
        ltapiNone : ;
        ltapiCallStart :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  'call started');
        ltapiCallFinish :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  'call finished'^M^J);
        ltapiDial :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  dialing ', Number);
        ltapiAccept :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  accepting');
        ltapiAnswer :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  answering');
        ltapiConnect :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  connected');
        ltapiCancel :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  cancelled');
        ltapiDrop :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  dropped');
        ltapiBusy:
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  busy');
        ltapiDialFail :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  dial failed');
        ltapiReceivedDigit :
          WriteLn(HisFile, DateTimeToStr(Now), ' : ',  '  received digit');
      end;
    end;

    Close(HisFile);
    if IOResult <> 0 then ;
  end;

{TApdAbstractTapiStatus}

  procedure TApdAbstractTapiStatus.Notification(AComponent : TComponent;
                                                Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      if AComponent = FTapiDevice then
        FTapiDevice := nil;
    end;
  end;

  procedure TApdAbstractTapiStatus.SetPosition(const NewPosition : TPosition);
    {-Pass through position requests}
  begin
    if NewPosition <> FPosition then begin
      FPosition := NewPosition;
      if Assigned(FDisplay) then
        FDisplay.Position := NewPosition;
    end;
  end;

  procedure TApdAbstractTapiStatus.SetCtl3D(const NewCtl3D : Boolean);
    {-Pass through CTL3D property}
  begin
    if NewCtl3D <> FCtl3D then begin
      FCtl3D := NewCtl3D;
      if Assigned(FDisplay) then
        FDisplay.Ctl3D := NewCtl3D;
    end;
  end;

  procedure TApdAbstractTapiStatus.SetVisible(const NewVisible : Boolean);
    {-Pass through the Visible property}
  begin
    if NewVisible <> FVisible then begin
      FVisible := NewVisible;
      if Assigned(FDisplay) then
        FDisplay.Visible := NewVisible;
    end;
  end;

  procedure TApdAbstractTapiStatus.SetCaption(const NewCaption : TCaption);
    {-Pass through the Caption property}
  begin
    if NewCaption <> FCaption then begin
      FCaption := NewCaption;
      if Assigned(FDisplay) then
        FDisplay.Caption := NewCaption;
    end;
  end;

  procedure TApdAbstractTapiStatus.GetProperties;
    {-Get the properties from the status form}
  begin
    if Assigned(FDisplay) then begin
      Position := FDisplay.Position;
      Ctl3D    := FDisplay.Ctl3D;
      Visible  := FDisplay.Visible;
      Caption  := FDisplay.Caption;
    end;
  end;

  constructor TApdAbstractTapiStatus.Create(AOwner : TComponent);
    {-Create the status form}
  begin
    inherited Create(AOwner);
    Caption := 'Call Progress';
    CreateDisplay;
    GetProperties;
  end;

  destructor TApdAbstractTapiStatus.Destroy;
    {-Get rid of the status form}
  begin
    DestroyDisplay;
    if Assigned(FTapiDevice) then
      FTapiDevice.StatusDisplay := nil;
    inherited Destroy;
  end;

  procedure TApdAbstractTapiStatus.Show;
    {-Show the status form}
  begin
    if Assigned(FDisplay) then
      FDisplay.Show;
  end;

{TAPI callback}

{$IFDEF TapiDebug}
const
  Digits : array[0..$F] of AnsiChar = '0123456789ABCDEF';
type
  Long =
    record
      LowWord, HighWord : Word;
    end;

  function HexW(W : Word) : ShortString;
    {-Return hex string for word}
  begin
    HexW[0] := #4;
    HexW[1] := Digits[hi(W) shr 4];
    HexW[2] := Digits[hi(W) and $F];
    HexW[3] := Digits[lo(W) shr 4];
    HexW[4] := Digits[lo(W) and $F];
  end;

  function HexL(L : Integer) : ShortString;
    {-Return hex string for Integer}
  begin
    with Long(L) do
      HexL := HexW(HighWord)+HexW(LowWord);
  end;
{$ENDIF}

  procedure GenCallback(Device, Message, Instance, Param1, Param2, Param3 : Integer);
    stdcall;
  var
    TP : TApdTapiDevice absolute Instance;
  begin
    {$IFDEF TapiDebug}
    WriteLn(Dbg, 'Callback. Device: ', HexL(Device), '  Message: ', HexL(Message),
      ' P1,P2,P3: ', HexL(Param1), ' ', HexL(Param2), ' ', HexL(Param3));
    case Message of
      Line_AddressState       : WriteLn(Dbg,'  Line_AddressState message');
      Line_CallInfo           : WriteLn(Dbg,'  Line_CallInfo message');
      Line_Callstate          : WriteLn(Dbg,'  Line_Callstate message');
      Line_Close              : WriteLn(Dbg,'  Line_Close message');
      Line_DevSpecific        : WriteLn(Dbg,'  Line_DevSpecific message');
      Line_DevSpecificFeature : WriteLn(Dbg,'  Line_DevSpecificFeature message');
      Line_GatherDigits       : WriteLn(Dbg,'  Line_GatherDigits message');
      Line_Generate           : WriteLn(Dbg,'  Line_Generate message');
      Line_LineDevState       : WriteLn(Dbg,'  Line_LineDevState message');
      Line_MonitorDigits      : WriteLn(Dbg,'  Line_MonitorDigits message');
      Line_MonitorMedia       : WriteLn(Dbg,'  Line_MonitorMedia message');
      Line_MonitorTone        : WriteLn(Dbg,'  Line_MonitorTone message');
      Line_Reply              : WriteLn(Dbg,'  Line_Reply message');
      Line_Request            : WriteLn(Dbg,'  Line_Request message');
      Phone_Button            : WriteLn(Dbg,'  Phone_Button message');
      Phone_Close             : WriteLn(Dbg,'  Phone_Close message');
      Phone_DevSpecific       : WriteLn(Dbg,'  Phone_DevSpecific message');
      Phone_Reply             : WriteLn(Dbg,'  Phone_Reply message');
      Phone_State             : WriteLn(Dbg,'  Phone_State message');
      Line_Create             : WriteLn(Dbg,'  Line_Create message');
      Line_Remove             : WriteLn(Dbg,'  Line_Remove message');    {!!.02}
      Phone_Create            : WriteLn(Dbg,'  Phone_Create message');
    end;
    WriteLn(Dbg, '--TapiStatusMsg=', TP.TapiStatusMsg(
      Message, Param1, Param2));
    {$ENDIF}

    if Message = Line_Create then
      PostMessage(HWND_BROADCAST, apw_TapiEventMessage, etTapiLineCreate, Param1);

    if TP = nil then
      Exit;

    with TP do try
      case Message of
        Line_Reply         : DoLineReply(Device, Param1, Param2, Param3);
        Line_CallInfo      : DoLineCallInfo(Device, Param1, Param2, Param3);
        Line_CallState     : DoLineCallState(Device, Param1, Param2, Param3);
        Line_Close         : DoLineClose(Device, Param1, Param2, Param3);
        Line_LineDevState  : DoLineDevState(Device, Param1, Param2, Param3);
        Line_Create        : DoLineCreate(Device, Param1, Param2, Param3);
        Line_MonitorDigits : DoLineMonitorDigits(Device, Param1, Param2, Param3);
        Line_Generate      : DoLineGenerate(Device, Param1, Param2, Param3);
        Line_MonitorMedia  : DoLineMonitorMedia(Device, Param1, Param2, Param3);
        Line_MonitorTone   : DoLineMonitorTone(Device, Param1, Param2, Param3);
        Line_Request       : DoLineRequest(Device, Param1, Param2, Param3);
      end;
    except
      Application.HandleException(nil);
    end;
  end;

{TApdCustomTapiDevice}

  function SearchStatusDisplay(const C : TComponent) : TApdAbstractTapiStatus;
    {-Search for a status display in the same form as TComponent}

    function FindStatusDisplay(const C : TComponent) : TApdAbstractTapiStatus;
    var
      I  : Integer;
    begin
      Result := nil;
      if not Assigned(C) then
        Exit;

      {Look through all of the owned components}
      for I := 0 to C.ComponentCount-1 do begin
        if C.Components[I] is TApdAbstractTapiStatus then begin
          {...and it's not assigned}
          if not Assigned(
            TApdAbstractTapiStatus(C.Components[I]).FTapiDevice) then begin
            Result := TApdAbstractTapiStatus(C.Components[I]);
            Exit;
          end;
        end;

        {If this isn't one, see if it owns other components}
        Result := FindStatusDisplay(C.Components[I]);
      end;
    end;

  begin
    {Search the entire form}
    Result := FindStatusDisplay(C);
  end;

  function SearchTapiLog(const C : TComponent) : TApdTapiLog;
    {-Search for a tapi log component on the same form as TComponent}

    function FindTapiLog(const C : TComponent) : TApdTapiLog;
    var
      I  : Integer;
    begin
      Result := nil;
      if not Assigned(C) then
        Exit;

      {Look through all of the owned components}
      for I := 0 to C.ComponentCount-1 do begin
        if C.Components[I] is TApdTapiLog then begin
          {...and it's not assigned}
          if not Assigned(TApdTapiLog(C.Components[I]).FTapiDevice) then begin
            Result := TApdTapiLog(C.Components[I]);
            Exit;
          end;
        end;

        {If this isn't one, see if it owns other components}
        Result := FindTapiLog(C.Components[I]);
      end;
    end;

  begin
    {Search the entire form}
    Result := FindTapiLog(C);
  end;

  procedure TApdCustomTapiDevice.DoLineReply(Device, P1, P2, P3 : Integer);
  begin
    if (RequestedId = P1) then begin
      ReplyReceived := True;
      AsyncReply := P2;
    end;
  end;

  procedure TApdCustomTapiDevice.DoLineCallInfo(Device, P1, P2, P3 : Integer);
  begin
    { Update the CallInfo record }
    UpdateCallInfo(Device);

    if ((P1 and LineCallInfoState_CallerID) <> 0) then begin
      {Generate Caller ID event}
      TapiCallerID(string(Trim(CallerID)), string(Trim(CallerIDName)));
    end;

    { generate the OnTapiStatus event }
    TapiStatus(False, False, Device, Line_CallInfo, P1, P2, P3);         {!!.04}
  end;

  procedure TApdCustomTapiDevice.DoLineCallState(Device, P1, P2, P3 : Integer);
  const
    OurMediaModes : array[Boolean] of DWORD = ((LINEMEDIAMODE_UNKNOWN or
      LINEMEDIAMODE_DATAMODEM or LINEMEDIAMODE_G3FAX),
      (LINEMEDIAMODE_UNKNOWN or LINEMEDIAMODE_DATAMODEM or
      LINEMEDIAMODE_AUTOMATEDVOICE or LINEMEDIAMODE_G3FAX));
  begin
    {$IFDEF TapiDebug}
    if (Device <> CallHandle) and (P1 <> LineCallState_Idle) then
      WriteLn(Dbg, 'Line_CallState: Unknown Device ID ', HexL(Device));
    {$ENDIF}

    CallState := P1;
    CallStateReceived := True;

    case P1 of
      LineCallState_Dialtone :
        begin
          TapiStatus(True, False, Device, Line_CallState, P1, P2, P3);
        end;

      LineCallState_Dialing :
        begin
          TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);
        end;

      LineCallState_Proceeding :
        begin
          TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);
        end;

      LineCallState_Ringback :
        begin
          TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);
        end;

      LineCallState_Busy :
        begin
          TapiLogging(ltapiBusy);
          TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);
          HangupCall(False);
        end;

      LineCallState_Idle :
        begin
          TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);
          HangupCall(False);
        end;

      LineCallState_SpecialInfo :
        begin
          TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);
          HangupCall(False);
        end;

      LineCallState_Disconnected :
        begin
          FFailCode := P2;
          TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);
          if P2 = LineDisconnectMode_Busy then
            TapiLogging(ltapiBusy);
          HangupCall(False);
        end;

      LineCallState_Offering :
        begin
          { Update the CallInfo record }
          UpdateCallInfo(Device);

          if not Assigned(FCallInfo) then
            raise ETapiUnexpected.Create(ecTapiUnexpected, True);

          {$IFDEF TapiDebug}
          WriteLn(Dbg, 'Offering MediaModes: ', HexL(FCallInfo^.MediaMode));
          {$ENDIF}

          {Got an incoming call, check line media, exit if not ours}
          if (FCallInfo^.MediaMode and OurMediaModes[FEnableVoice]) = 0 then
            Exit;

          {Note the call handle}
          CallHandle := Device;

          {Start showing status}
          TapiStatus(True, False, Device, Line_CallState, P1, P2, P3);

          {Accept the call}
          WaitForReply(tuLineAccept(CallHandle, nil, 0));
          TapiLogging(ltapiAccept);
        end;

      LineCallState_Accepted :
        begin
          TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);
        end;

      LineCallState_Connected :
        begin
          { Duplicate connect message }
          if Connected then Exit;

          { Update the CallInfo record }
          UpdateCallInfo(Device);

          { Say we're connected }
          Connected := True;

          { We don't need retries anymore }
          if Assigned(DialTimer) then begin
            DialTimer.Free;
            DialTimer := nil;
          end;
          RetryPending := False;

          if FEnableVoice then
            {Start monitoring for DTMF tones if in voice mode}
            MonitorDTMF(CallHandle, LINEDIGITMODE_DTMF)
          else
            {Port was just opened, grab the Cid and pass to comport}
            OpenTapiPort;


          {Show last status}
          TapiStatus(False, True, Device, Line_CallState, P1, P2, P3);

          {Generate the TAPI connect event}
          {TapiConnect;}
          PostMessage(FHandle, apw_TapiEventMessage, etTapiConnect, 0);
          TapiLogging(ltapiConnect);
        end;

        LineCallState_OnHold :                                           {!!.06}
          begin                                                          {!!.06}
            TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);{!!.06}
          end;                                                           {!!.06}
      else
        { it's a LINE_CALLSTATE message that we don't handle, pass it along }
        TapiStatus(False, False, Device, Line_CallState, P1, P2, P3);    {!!.04}
    end;
  end;

  procedure TApdCustomTapiDevice.DoLineClose(Device, P1, P2, P3 : Integer);
  begin
    LineHandle := 0;
    CallHandle := 0;

    {$IFDEF TapiDebug}
    WriteLn(Dbg, 'Line forcibly closed by Tapi');
    {$ENDIF}

    HangupCall(True);
  end;

  procedure TApdCustomTapiDevice.DoLineDevState(Device, P1, P2, P3 : Integer);
  begin
    case P1 of
      LineDevState_Ringing : begin
          {Show status}
          TapiStatus(False, False, Device, Line_LineDevState, P1, P2, P3);
          if (P3 >= FAnsRings) then begin
            {Answer the call}
            WaitForReply(tuLineAnswer(CallHandle, nil, 0));
            TapiLogging(ltapiAnswer);
          end;
        end;

      LineDevState_OutOfService :
        begin
          HangupCall(True);
          {$IFDEF TapiDebug}
          WriteLn(Dbg, 'Selected Line Out of Service');
          {$ENDIF}
        end;

      LineDevState_Disconnected :
        begin
          HangupCall(True);
          {$IFDEF TapiDebug}
          WriteLn(Dbg, 'Line Disconnected');
          {$ENDIF}
        end;

      LineDevState_Maintenance :
        begin
          HangupCall(True);
          {$IFDEF TapiDebug}
          WriteLn(Dbg, 'Line down for maintenance');
          {$ENDIF}
        end;

      else if (P1 = LineDevState_Reinit) then begin
        case P2 of
          { Hard reinit -- must shutdown }
          0 :
            begin
              {$IFDEF TapiDebug}
              WriteLn(Dbg, 'Hard Reinit: shutting down Tapi');
              {$ENDIF}
              StopTapi;
            end;

          { Soft reinit -- shutdown not required }
          Line_Create :
            begin
              {$IFDEF TapiDebug}
              WriteLn(Dbg, 'Soft Reinit: Line_Create');
              {$ENDIF}
              DoLineCreate(Device, P3, 0, 0);
            end;

          { Soft reinit -- shutdown not required }
          Line_LineDevState :
            begin
              {$IFDEF TapiDebug}
              WriteLn(Dbg, 'Soft Reinit: Line_LineDevState');
              {$ENDIF}
              DoLineDevState(Device, P3, 0, 0);
            end;

          { Soft reinit -- shutdown not required }
          else begin
            {$IFDEF TapiDebug}
            WriteLn(Dbg, 'Soft Reinit: Unknown, ignored: ', P2);
            {$ENDIF}
          end;
        end;
      end else begin
        {$IFDEF TapiDebug}
        WriteLn(Dbg, 'Unhandled LineDevState: ', P1, ' ', P2, ' ', P3);
        {$ENDIF}
      end;
    end;
  end;

  procedure TApdCustomTapiDevice.DoLineCreate(Device, P1, P2, P3 : Integer);
  begin
    if (FDeviceCount <= DWORD(P1)) then
      FDeviceCount := P1 + 1;
    EnumLineDevices;
    {$IFDEF TapiDebug}
    WriteLn(Dbg, 'Line_Create');
    {$ENDIF}
  end;

  procedure TApdCustomTapiDevice.DoLineMonitorDigits(Device, P1, P2, P3 : Integer);
  begin
    { A digit is detected and is available as an ASCII value in the low }
    { order byte of P1. Convert ASCII to character for OnTapiDTMF event }
    TapiDTMF(Char(Lo(P1)), 0);
    TapiLogging(ltapiReceivedDigit);
  end;

  procedure TApdCustomTapiDevice.DoLineGenerate(Device, P1, P2, P3 : Integer);
  begin
    { Do nothing, this event indicates the end of digit generation }
  end;

  procedure TApdCustomTapiDevice.DoLineMonitorMedia(Device, P1, P2, P3 : Integer);
  begin
    { Generate the OnTapiStatus event }
    TapiStatus(False, False, Device, Line_MonitorMedia, P1, P2, P3);
  end;

  procedure TApdCustomTapiDevice.DoLineMonitorTone(Device, P1, P2, P3 : Integer);
  begin
    { Generate the OnTapiStatus event }
    TapiStatus(False, False, Device, Line_MonitorTone, P1, P2, P3);
  end;

  procedure TApdCustomTapiDevice.DoLineRequest(Device, P1, P2, P3 : Integer);
  begin
    { Generate the OnTapiStatus event }
    TapiStatus(False, False, Device, Line_Request, P1, P2, P3);
  end;

  function TApdCustomTapiDevice.HandleLineErr(LineErr : Integer): Boolean;
  { This is a stub in case someone wants to handle line errors }
  begin
    Result := False;

    { Async reply, return False }
    if (LineErr > Success) then begin
      Exit;
    end;

    { No error, return True }
    if (LineErr = Success) then begin
      Result := True;
      Exit;
    end;

    { Unhandled error, return False }
    { This part might be expanded on in the future }
    if (LineErr < Success) then begin
      Exit;
    end;

  end;

  function TApdCustomTapiDevice.HangupCall(AbortRetries : Boolean) : Boolean;
  var
    lReturn : Integer;
    CloseEventPending : Boolean;
    FinalRetry : Boolean;
    Failure : Boolean;
  begin
    Result := True;
    Failure := not(Connected);

    if StoppingCall then begin
      Exit;
    end;

    if TapiInUse then begin

      {$IFDEF TapiDebug}
      WriteLn(Dbg, 'Hangup Start: ', GetTickCount);
      {$ENDIF}

      StoppingCall := True;
      try
        CloseEventPending := CloseTapiPort;

        if CallHandle <> 0 then begin

          { Only drop the call when the line is not idle }
          if TapiState <> tsIdle then begin
            repeat
              lReturn := WaitForReply(tuLineDrop(CallHandle, nil, 0));

              if (lReturn = WaitErr_WaitTimedOut) then begin
                {$IFDEF TapiDebug}
                WriteLn(Dbg, 'Wait for lineDrop timed out');
                {$ENDIF}
                Break;
              end;

              if (lReturn = WaitErr_WaitAborted) then begin
                {$IFDEF TapiDebug}
                WriteLn(Dbg, 'Wait for lineDrop aborted');
                {$ENDIF}
                Break;
              end;

              if (lReturn = LineErr_InvalCallState) then
                Break;

              if HandleLineErr(lReturn) then
                Continue
              else begin
                {$IFDEF TapiDebug}
                WriteLn(Dbg, 'Unhandled error waiting for lineDrop');
                {$ENDIF}
                Break;
              end;
            until lReturn = Success;

            lReturn := WaitForCallState(LineCallState_Idle);

            if (lReturn = WaitErr_WaitTimedOut) then begin
              {$IFDEF TapiDebug}
              WriteLn(Dbg, 'Wait for LineCallState_Idle timed out');
              {$ENDIF}
            end;

            if lReturn = WaitErr_WaitAborted then begin
              {$IFDEF TapiDebug}
              WriteLn(Dbg, 'Wait for LineCallState_Idle aborted');
              {$ENDIF}
            end;
          end;

          { The call is now idle -- deallocate it }
          repeat
            lReturn := tuLineDeallocateCall(CallHandle);
            if not HandleLineErr(lReturn) then begin
              {$IFDEF TapiDebug}
              WriteLn(Dbg, 'Error from lineDeallocateCall');
              {$ENDIF}
              Break;
            end;
          until lReturn = Success;
        end;

        { If we have a line open, close it }
        if LineHandle <> 0 then begin
          repeat
            lReturn := tuLineClose(LineHandle);
            if not HandleLineErr(lReturn) then begin
              {$IFDEF TapiDebug}
              WriteLn(Dbg, 'Error from lineClose');
              {$ENDIF}
              Break;
            end;
          until lReturn = Success;
        end;

        CallHandle := 0;
        LineHandle := 0;
        FOpen := False;
        Connected := False;
        TapiInUse := False;

        { Fire port close event if appropriate }
        if CloseEventPending then
          {TapiPortClose;}
          PostMessage(FHandle, apw_TapiEventMessage, etTapiPortClose, 0);

        TapiLogging(ltapiDrop);

        {$IFDEF TapiDebug}
        WriteLn(Dbg, 'Hangup Completed: ', GetTickCount);
        {$ENDIF}

      finally
        { Finalize call, or set up for redial }
        FinalRetry := True;

        if AbortRetries then
          RetryPending := False;
        if RetryPending then begin
          if (FAttempt < FMaxAttempts) then begin
            CreateDialTimer;
            FinalRetry := False;
          end else begin
            RetryPending := False;
          end;
        end;

        if FinalRetry and not PassThruMode then begin
          { Get rid of status display }
          TapiStatus(False, True, 0, 0, 0, 0, 0);
          TapiLogging(ltapiCallFinish);
          { Log failure and fire OnTapiFail if applicable }
          if Failure then begin
            TapiLogging(ltapiDialFail);
            PostMessage(FHandle, apw_TapiEventMessage, etTapiFail, 0);
          end;
        end;
        StoppingCall := False;
        TapiInUse := False;
      end;
    end else begin
      { Finalize call, or set up for redial }
      FinalRetry := True;

      if AbortRetries then
        RetryPending := False;

      if RetryPending then begin
        if (FAttempt < FMaxAttempts) then begin
          CreateDialTimer;
          FinalRetry := False;
        end else begin
          RetryPending := False;
        end;
      end;

      if TapiHasOpened then
        if FinalRetry and not PassThruMode then begin
          { Get rid of status display }
          TapiStatus(False, True, 0, 0, 0, 0, 0);
          TapiLogging(ltapiCallFinish);
          { Log failure and fire OnTapiFail if applicable }
          if Failure then begin
            TapiLogging(ltapiDialFail);
            PostMessage(FHandle, apw_TapiEventMessage, etTapiFail, 0);
          end;
        end;

      StoppingCall := False;
      TapiInUse := False;

      CallHandle := 0;
      LineHandle := 0;
      FOpen := False;
      Connected := False;
      TapiFailFired := False;
    end;
  end;

  procedure TApdCustomTapiDevice.UpdateCallInfo(Device : Integer);
  begin
    {We can update callstate properties, first get rid of old...}
    if Assigned(FCallInfo) then begin
      FreeMem(FCallInfo, FCallInfo^.TotalSize);
      FCallInfo := nil;
    end;
    {...then get the new call information}
    tuLineGetCallInfoDyn(Device, FCallInfo);
  end;

  function TApdCustomTapiDevice.WaitForCallState(DesiredCallState : Integer) : Integer;
  var
    TimeStart : DWORD;
  begin
    if StateWait then begin
      Result := WaitErr_WaitAborted;
      Exit;
    end;
    CallStateReceived := False;
    TimeStart := GetTickCount;
    StateWait := True;
    try
      while (DesiredCallState = LineCallState_Any) or
            (CallState <> DesiredCallState) do begin
        Application.ProcessMessages;
        if (DesiredCallState = LineCallState_Any) and CallStateReceived then
          Break;
        if not TapiInUse then begin
          Result := WaitErr_WaitAborted;
          Exit;
        end;
        if (GetTickCount - TimeStart) > WaitTimeout then begin
          Result := WaitErr_WaitTimedout;
          Exit;
        end;
      end;
    finally
      StateWait := False;
    end;
    Result := Success;
  end;

  function TApdCustomTapiDevice.WaitForReply(ID : Integer) : Integer;
  var
    TimeStart : DWORD;
  begin
    if ReplyWait then begin
      Result := WaitErr_WaitAborted;
      Exit;
    end;
    TimeStart := GetTickCount;
    ReplyWait := True;
    try
      if (ID > Success) then begin
        ReplyReceived := False;
        RequestedID := ID;
        AsyncReply := LineErr_OperationFailed;
        while not ReplyReceived do begin
          Application.ProcessMessages;
          if (not TapiInUse) then begin
            Result := WaitErr_WaitAborted;
            Exit;
          end;
          if (GetTickCount - TimeStart) > WaitTimeout then begin
            Result := WaitErr_WaitTimedout;
            Exit;
          end;
        end;
        Result := AsyncReply;
        Exit;
      end;
    finally
      ReplyWait := False;
    end;
    Result := ID;
  end;

  procedure TApdCustomTapiDevice.TapiDialTimer(Sender : TObject);
    {-Simulate Tapi status calls for dial timing}

    procedure KillDialTimer;
    begin
      if Assigned(DialTimer) then begin
        DialTimer.Free;
        DialTimer := nil;
      end;
    end;

  begin
    {Assume one second went by...}
    Dec(FDialTime);

    {Generate an appropriate status event}
    case TapiState of
      tsIdle :
        if FDialTime <= 0 then begin
          {Redial...}
          KillDialTimer;
          Inc(FAttempt);
          DialPrim(False);
        end else
          {Show countdown}
          if RetryPending then
            TapiStatus(False, False, 0, Line_APDSpecific,
              APDSpecific_RetryWait, 0, 0)
          else
            KillDialTimer;
      else
        KillDialTimer;
    end;
  end;

  procedure TApdCustomTapiDevice.SetEnableVoice(Value: Boolean);
  begin
    FEnableVoice := Value;
    if FEnableVoice and (SelectedDevice <> '') then
        CheckVoiceCapable;
  end;

  procedure TApdCustomTapiDevice.CheckVoiceCapable;
  var
    Count      : DWord;
    LineApp    : TLineApp;
    LineExt    : TLineExtensionID;
    ApiVersion : Integer;
    LineCaps   : PLineDevCaps;
  begin
    {Does the device support AutomatedVoice?}
    try
      {Initialize a TAPI line}
      CheckException(Self, tuLineInitialize(LineApp,
                                    hInstance,
                                    GenCallback,
                                    '',
                                    Count));

      {Negotiate the API version to use for this device}
      if tuLineNegotiateApiVersion(LineApp, GetSelectedLine,
        TapiHighVer, TapiHighVer, ApiVersion, LineExt) = 0 then begin

        {Get the device capabilities}
        CheckException(Self, tuLineGetDevCapsDyn(LineApp,
          GetSelectedLine, ApiVersion, 0, LineCaps));
        try
          if (LineCaps^.MediaModes and LINEMEDIAMODE_AUTOMATEDVOICE) = 0 then begin
            FEnableVoice := False;
            {raise exception}
            raise ETapiVoiceNotSupported.Create(ecTapiVoiceNotSupported, True);
          end else
            FEnableVoice := True;
        finally
          {Free the buffer allocated by LineGetDevCapsDyn}
          FreeMem(LineCaps, LineCaps^.TotalSize);
        end;
      end;
    except
      FEnableVoice := False;
      raise ETapiVoiceNotSupported.Create(ecTapiVoiceNotSupported, True);
    end;
     {Shutdown this line}
    tuLineShutdown(LineApp);
  end;

  procedure TApdCustomTapiDevice.Notification(AComponent : TComponent;
                                              Operation : TOperation);
    {-Handle new/deleted components}
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      {Owned components going away}
      if AComponent = FComPort then
        ComPort := nil;
      if AComponent = FStatusDisplay then
        StatusDisplay := nil;
      if AComponent = FTapiLog then
        TapiLog := nil;
    end else if Operation = opInsert then begin
      {Check for new comport}
      if AComponent is TApdCustomComPort then begin
        if not Assigned(FComPort) then
          ComPort := TApdCustomComPort(AComponent);

        {Force its TapiMode to True, AutoOpen and Open to False}
        if ComPort.TapiMode = tmAuto then begin
          ComPort.TapiMode := tmOn;
          ComPort.AutoOpen := False;
          ComPort.Open := False;
        end;
      end;

      {Check for new status component}
      if AComponent is TApdAbstractTapiStatus then begin
        if not Assigned(FStatusDisplay) then
          if not Assigned(TApdAbstractTapiStatus(AComponent).FTapiDevice) then
            StatusDisplay := TApdAbstractTapiStatus(AComponent);
      end;

      {Check for new log component}
      if AComponent is TApdTapiLog then begin
        if not Assigned(FTapiLog) then
          if not Assigned(TApdTapiLog(AComponent).FTapiDevice) then
            TapiLog := TApdTapiLog(AComponent);
      end;
    end;
  end;

  procedure TApdCustomTapiDevice.Loaded;                                 {!!.02}
  begin
    inherited;
    if not Assigned(FComPort) then begin
      FComPort := SearchComPort(Owner);
      if Assigned(FComPort) and (ComPort.TapiMode = tmAuto) then begin
        ComPort.TapiMode := tmOn;
        ComPort.AutoOpen := False;
        ComPort.Open := False;
      end;
    end;
  end;

  constructor TApdCustomTapiDevice.Create(AOwner : TComponent);
    {-Create the object instance}
  begin
    {This causes notification events for all other components}
    inherited Create(AOwner);
    {Create the TAPI name string list}
    FTapiDevices := TStringList.Create;

    FSilence.AppSpecific := 5;
    FSilence.Duration := 5000;
    FSilence.Frequency1 := 0;
    FSilence.Frequency2 := 0;
    FSilence.Frequency3 := 0;

    {Private inits}
    LineApp         := 0;
    LineHandle      := 0;
    CallHandle      := 0;
    SelectedLine    := -1;
    RetryPending    := False;
    FillChar(LineExt, SizeOf(LineExt), 0);
    FDialTime       := 0;
    PassThruMode    := False;

    {Property inits}
    FDialing         := False;
    FSelectedDevice  := '';
    FDeviceCount     := 0;
    FOpen            := False;
    FCallInfo        := nil;
    FAnsRings        := DefAnsRings;
    FMaxAttempts     := DefMaxAttempts;
    FAttempt         := 0;
    FRetryWait       := DefRetryWait;
    FShowTapiDevices := DefShowTapiDevices;
    FShowPorts       := DefShowPorts;
    FWaveState       := wsIdle;
    FInterruptWave   := True;
    FMaxMessageLength:= DefMaxMessageLength;
    FWaveState       := DefWaveState;
    FUseSoundCard    := DefUseSoundCard;
    FTrimSeconds     := DefTrimSeconds;
    FSilenceThreshold:= DefSilenceThreshold;
    Channels         := DefChannels;
    SamplesPerSecond := DefSamplesPerSecond;
    BitsPerSample    := DefBitsPerSample;
    FMonitorRecording:= DefMonitorRecording;
    FFilterUnsupportedDevices := True;
    FWaitingForCall  := False;                                           {!!.04}

    {Search for a comport - do this in .Loaded }
    {FComPort := SearchComPort(Owner);}                                  {!!.02}
    {if Assigned(FComPort) and (ComPort.TapiMode = tmAuto) then begin}   {!!.02}
      {ComPort.TapiMode := tmOn;}                                        {!!.02}
      {ComPort.AutoOpen := False;}                                       {!!.02}
      {ComPort.Open := False;}                                           {!!.02}
    {end;}                                                               {!!.02}

    {Search for a status display}
    StatusDisplay := SearchStatusDisplay(Owner);

    {Search for a tapi log}
    TapiLog := SearchTapiLog(Owner);

    if not (csDesigning in ComponentState) then begin
      {Init TAPI}
      StartTapi;

      {Get the list of TAPI line devices}
      EnumLineDevices;
    end;
    FHandle := AllocateHWnd(WndProc);
  end;

  destructor TApdCustomTapiDevice.Destroy;
    {-Destroy the object instance}
  begin
    {Make sure the line is closed}
    Open := False;

    {Stop TAPI}
    StopTapi;

    {Get rid of the string list}
    FTapiDevices.Free;

    {Deallocate FCallInfo}
    if Assigned(FCallInfo) then begin
      FreeMem(FCallInfo, FCallInfo^.TotalSize);
      FCallInfo := nil;
    end;

    { Might need to free the wave buffers. }
    FreeWaveOutBuffer;

    if FHandle <> 0 then DeallocateHWnd(FHandle);
    inherited Destroy;
  end;

  procedure TApdCustomTapiDevice.Assign(Source: TPersistent);
    {-Assign values of Source to self}
  var
    SourceTapi : TApdCustomTapiDevice absolute Source;
  begin
    if Source is TApdCustomTapiDevice then begin
      {Get rid of existing names...}
      FTapiDevices.Clear;

      {Property inits}
      FDialing         := SourceTapi.FDialing;
      FSelectedDevice  := SourceTapi.FSelectedDevice;
      FDeviceCount     := SourceTapi.FDeviceCount;
      FOpen            := SourceTapi.FOpen;
      FMaxAttempts     := SourceTapi.FMaxAttempts;
      FAnsRings        := SourceTapi.FAnsRings;
      FAttempt         := SourceTapi.FAttempt;
      FRetryWait       := SourceTapi.FRetryWait;
      FShowTapiDevices := SourceTapi.FShowTapiDevices;
      FComPort         := SourceTapi.FComPort;
      FStatusDisplay   := SourceTapi.FStatusDisplay;
      FTapiLog         := SourceTapi.FTapiLog;

      {Handle FCallInfo}
      if Assigned(FCallInfo) then begin
        FreeMem(FCallInfo, FCallInfo^.TotalSize);
        FCallInfo := nil;
      end;
      SourceTapi.CopyCallInfo(FCallInfo);
    end;
  end;

  procedure TApdCustomTapiDevice.SetOpen(NewOpen : Boolean);
    {-Open or close the selected TAPI line device}
  const
    CallPrivilege : array[Boolean] of Integer =
      (LINECALLPRIVILEGE_OWNER, LINECALLPRIVILEGE_NONE);
  var
    InitMediaModes : Integer;
  begin
    StartTapi;

    if FEnableVoice then
      InitMediaModes := LINEMEDIAMODE_AUTOMATEDVOICE
    else
      InitMediaModes := LINEMEDIAMODE_DATAMODEM;

    {Refresh the device ID from the selected string}
    if NewOpen then
      SelectedLine := GetSelectedLine;

    if NewOpen <> FOpen then begin
      if NewOpen then begin
        TapiFailFired := False;

        TapiException(Self, tuLineOpen(LineApp, SelectedLine,
          LineHandle, ApiVersion, 0, Integer(Self),
          CallPrivilege[Dialing], InitMediaModes, 0));

        TapiInUse := True;
        TapiHasOpened := True;

        {Request all status messages for this line}
        TapiException(Self, tuLineSetStatusMessages(LineHandle,
          AllLineDeviceStates, AllAddressStates));

        {Set the new state}
        FOpen := True;

        {Log the call as open}
        if (Attempt = 1) or (not Dialing) then
          TapiLogging(ltapiCallStart);

      end else begin
        HangupCall(False);
      end;
    end;
  end;

  procedure TApdCustomTapiDevice.EnumLineDevices;
    {-Enumerate all line devices and save their names in TapiDevices}
  var
    I        : Integer;
    LineCaps : PLineDevCaps;
    S        : string;
  begin
    StartTapi;

    {Get rid of old list}
    FTapiDevices.Clear;

    {Enumerate all line devices and build a list of names}
    for I := 1 to FTrueDeviceCount do begin
      {Negotiate the API version to use for this device}
      if tuLineNegotiateApiVersion(LineApp, I-1, TapiLowVer,
        TapiHighVer, FApiVersion, LineExt) = 0 then begin

        {Get the device capabilities}
        LineCaps := nil;
        try
          if tuLineGetDevCapsDyn(LineApp, I-1, ApiVersion,
            0, LineCaps) <> 0 then Exit;

          {Check for nil - bail if so}
          if not Assigned(LineCaps) then Exit;

          {Extract the device name}
          with LineCaps^ do begin
            {$IFOPT H+}
            SetLength(S, LineNameSize);
            Move(LineCaps^.Data[LineNameOffset], PChar(S)^, LineNameSize);
            {$ELSE}
            Move(LineCaps^.Data[LineNameOffset], S[1], LineNameSize);
            S[0] := Char(LineNameSize);
            {$ENDIF}
          end;
          {added this section}                                         
          if FFilterUnsupportedDevices then begin
            { check to see if it's capable of data }
            if ((LineCaps^.MediaModes and LINEMEDIAMODE_DATAMODEM) = 0) then
              { it can't make a data connection }
              if ((LineCaps^.MediaModes and LINEMEDIAMODE_AUTOMATEDVOICE) = 0) then
                { it can't make an automated voice call either}
                S := ''
              else begin
                { it can make a data and Automated voice call, does it support wave? }
                { see if it supports the Wave/in and wave/out device classes }
                FillChar(VS, SizeOf(TVarString), 0);                   
                if (tuLineGetID(LineApp, 0, 0, LINECALLSELECT_LINE, VS, 'wave/in') <> 0) and
                   (tuLineGetID(LineApp, 0, 0, LINECALLSELECT_LINE, VS, 'wave/out') <> 0) then
                  S := '';
              end;
            if ((LineCaps^.LineFeatures and LINEFEATURE_MAKECALL) = 0) then
              { it can't make a call }
              S := '';
          end;
          {end of added section}                                       


        finally
          {Free the buffer allocated by LineGetDevCapsDyn}
          if Assigned(LineCaps) then
            FreeMem(LineCaps, LineCaps^.TotalSize);
        end;

        {Add the name our list}
        if S <> '' then
          TapiDevices.Add(Copy(S, 1, Length(S)-1));
      end;
      FDeviceCount := TapiDevices.Count;                               
    end;
  end;

  function TApdCustomTapiDevice.StartTapi : Boolean;
    {-Initialize TAPI}
  var
    lResult : Integer;
    AppName : array[0..255] of AnsiChar;
    TimeStart : DWORD;
    TryReInit : Boolean;
    TmpRegistry : TRegIniFile;
    TapiProcesses : TStringList;
    I : Integer;
  begin
    TryReInit := True;
    Result := False;

    if LineApp <> 0 then begin
      Result := True;           { Already initialized }
      Exit;
    end;

    if Initializing then begin
      Exit;                     { Init in progress, not done yet }
    end;

    { Protect against reentry }
    Initializing := True;
    try
      try
        { Check for old processes }
        TmpRegistry := TRegIniFile.Create('SOFTWARE\TurboPower\APRO\TAPI');
        try
          { Check all LineApp handles in Registry if previous crash }
          TapiProcesses := TStringList.Create;
          try
            TmpRegistry.ReadSection('',TapiProcesses);
            for I := 0 to TapiProcesses.Count-1 do begin
              try
                if OpenProcess(STANDARD_RIGHTS_REQUIRED, False,
                  StrToInt(TapiProcesses[I])) = Null then begin
                  { If process doesn't exist, shut down old LineApp }
                  tuLineShutdown(TmpRegistry.ReadInteger('TAPI', TapiProcesses[I], 0));
                end;
              except
                { Eat exception, delete key blindly since it }
                { must not be an integer as expected }
              end;
              TmpRegistry.DeleteKey('', TapiProcesses[I]);
            end;
          finally
            TapiProcesses.Free;
          end;

          AnsiStrings.StrPCopy(AppName, AnsiString(ChangeFileExt(Application.ExeName, '')));

          { Start TAPI and get the number of line devices }
          repeat
            lResult := tuLineInitialize(LineApp, hInstance, GenCallBack,
              AppName, FTrueDeviceCount);                              
            if FDeviceCount = 0 then                                   
              FDeviceCount := FTrueDeviceCount;                        
            if lResult = LineErr_ReInit then begin
              if TryReinit then begin
                TimeStart := GetTickCount;
                { Wait 5 seconds and try again }
                while (GetTickCount - TimeStart) < 5000 do
                  Application.ProcessMessages;
                TryReinit := False;
              end else TapiException(Self, LineErr_ReInit);
            end else if (lResult = LineErr_LineMapperFailed) or
              (lResult = LineErr_NoDevice) or (lResult = LineErr_NoDriver)
              or (lResult = LineErr_NoMem) or (lResult = LineErr_NotOwner)
              or (lResult = LineErr_OperationFailed) then
                TapiException(Self, lResult);

            if (lResult = LineErr_NoDevice) then
              TapiException(Self, LineErr_NoDevice);
          until lResult = Success;

          { Save LineApp to Registry in case of crash }
          TmpRegistry.WriteInteger('', '$' + IntToHex(GetCurrentProcessId, 8), LineApp);
        finally
          TmpRegistry.Free;
        end;

        LineHandle := 0;
        CallHandle := 0;

      {$IFDEF TapiDebug}
      WriteLn(Dbg, 'Tapi Initialized. LineApp : ', IntToHex(LineApp, 8));
      {$ENDIF}

      finally
        Initializing := False;
      end;
      Result := True;

    except
      on E: Exception do begin
        {$IFDEF TapiDebug}
        WriteLn(Dbg,
                'Tapi Initialization Failure:' + E.ClassName + ': ' +
                E.Message + ', LineApp : ', IntToHex(LineApp, 8));     
        {$ENDIF}
        Result := False;
      end;
    end;
  end;

  function TApdCustomTapiDevice.StopTapi : Boolean;
    {-Shut down TAPI}
  begin
    Result := False;
    if LineApp = 0 then begin
      Result := True;             { Not initialized, no need to shut down }
      Exit;
    end;

    if ShuttingDown then
      Exit;                       { Shutdown in progress, not finished yet }

    ShuttingDown := True;
    HangupCall(True);

    TapiException(Self, tuLineShutdown(LineApp));
    {Remove LineApp from Registry for this process}
    with TRegIniFile.Create('SOFTWARE\TurboPower\APRO\TAPI') do try
      DeleteKey('', '$' + IntToHex(GetCurrentProcessId, 8));
    finally
      Free;
    end;
  end;

  procedure TApdCustomTapiDevice.OpenTapiPort;
    {-Open the comport associated with this TAPI device}
  begin
    if Assigned(FComPort) then with FComPort do begin
      Open := False;
      TapiCid := CidFromTapiDevice;
      try                                                                {!!.04}
        Open := True;

        { purge the input buffer, TAPI occasionally leaves config replies }
        FlushInBuffer;
        FlushOutBuffer;

        Dispatcher.DeviceName := FSelectedDevice;
        FWaitingForCall := False;                                        {!!.04}           

        {Generate the OnTapiPortOpen event}
        PostMessage(FHandle, apw_TapiEventMessage, etTapiPortOpen, 0);
      except                                                             {!!.04}
        { an exception was raised }
        PostMessage(FHandle, apw_TapiEventMessage, etTapiFail, 0);       {!!.04}
      end;                                                               {!!.04}
    end;
  end;

  function TApdCustomTapiDevice.CloseTapiPort : Boolean;
    {-Close the comport associated with this TAPI device}
  begin
    if Assigned(FComPort) then with FComPort do begin
      Result := Open;
      {Close the port}
      Open := False;
      TapiCid := 0;
    end else begin
      Result := False;
    end;
  end;

  function TApdCustomTapiDevice.DeviceIDFromName(const Name : string) : Integer;
    {-Return a line ID from a device name}
  var
    I         : Integer;
    LineCaps  : PLineDevCaps;
    S         : AnsiString;
  begin
    StartTapi;
    
    if Name = '' then begin
      Result := -1;
      Exit;
    end;

    {Enumerate all line devices and build a list of names}
    for I := 1 to FTrueDeviceCount do begin                            
      try
        LineCaps := nil;

        {Negotiate the API version to use for this device}
        if tuLineNegotiateApiVersion(LineApp, I-1, TapiLowVer,
          TapiHighVer, FApiVersion, LineExt) = 0 then begin

          {Get the device capabilities, really, the name is all we care about}
          TapiException(Self, tuLineGetDevCapsDyn(LineApp, I-1,
            ApiVersion, 0, LineCaps));

          {Check for nil - bail if so}
          if not Assigned(LineCaps) then begin
            Result := -1;
            Exit;
          end;

          {Extract the device name}
          with LineCaps^ do begin
            {$IFOPT H+}
            SetLength(S, LineNameSize-1);
            Move(LineCaps^.Data[LineNameOffset], PAnsiChar(S)^, LineNameSize);
            {$ELSE}
            Move(LineCaps^.Data[LineNameOffset], S[1], LineNameSize);
            S[0] := Char(LineNameSize-1);
            {$ENDIF}

            {Compare to the selected device}
            if Name = string(S) then begin
              Result := I-1;
              Exit;
            end;
          end;
        end;
      finally
        {Free the buffer allocated by LineGetDevCapsDyn}
        if Assigned(LineCaps) then
          FreeMem(LineCaps, LineCaps^.TotalSize);
      end;
    end;

    {No match if we get here}
    Result := -1;
  end;

  function TApdCustomTapiDevice.CidFromTapiDevice : Integer;
    {-Return the CID from the current TAPI session}
  begin
    {Get a handle to the comm port}
    FillChar(VS, SizeOf(TVarString), 0);
    VS.TotalSize := SizeOf(TVarString);
    if tuLineGetID(LineHandle, 0, CallHandle, LINECALLSELECT_CALL,
      VS, 'comm/datamodem') = 0 then with VS do
      Move(StringData[StringOffset], Result, SizeOf(Result))
    else
      Result := -1;
  end;

  function TApdCustomTapiDevice.GetBPSRate : DWORD;
    {-Return the BPS rate of the current call}
  begin
    if Assigned(FCallInfo) and Connected then                      
      Result := FCallInfo^.Rate
    else
      Result := 0;
  end;

  procedure TApdCustomTapiDevice.SetStatusDisplay(
    const NewDisplay : TApdAbstractTapiStatus);
    {-Set a new status display}
  begin
    if NewDisplay <> FStatusDisplay then begin
      FStatusDisplay := NewDisplay;
      if Assigned(FStatusDisplay) then
        FStatusDisplay.FTapiDevice := Self;
    end;
  end;

  procedure TApdCustomTapiDevice.SetTapiLog(const NewLog : TApdTapiLog);
    {-Set a new tapi log component}
  begin
    if NewLog <> FTapiLog then begin
      FTapiLog := NewLog;
      if Assigned(FTapiLog) then begin
        FTapiLog.FTapiDevice := Self;
      end;
    end;
  end;

  procedure TApdCustomTapiDevice.SetTapiDevices(const Values : TStrings);
    {-Set new strings}
  begin
    FTapiDevices.Assign(Values);
  end;

  procedure TApdCustomTapiDevice.SetSelectedDevice(const NewDevice : string);
    {-Set the selected TAPI device, exception if in 16bit but not enabled}
  begin
    FSelectedDevice := NewDevice;

    {Check for DTMF Capability}
    if FEnableVoice then
      CheckVoiceCapable;
  end;

  function TApdCustomTapiDevice.GetCalledID: string;
  begin
    if Assigned(FCallInfo) then begin
      with FCallInfo^ do begin
        if ((CalledIDFlags and LINECALLPARTYID_ADDRESS) = 0) then begin
          if ((CalledIDFlags and LINECALLPARTYID_BLOCKED) <> 0) then begin
            Result := AproLoadStr(ecTapiCIDBlocked);
            Exit;
          end;
          if ((CalledIDFlags and LINECALLPARTYID_OUTOFAREA) <> 0) then begin
            Result := AproLoadStr(ecTapiCIDOutOfArea);
            Exit;
          end;
          if ((CalledIDFlags and LINECALLPARTYID_UNKNOWN) <> 0) then begin
            Result := 'Unknown';
            Exit;
          end;
          if ((CalledIDFlags and LINECALLPARTYID_UNAVAIL) <> 0) then begin
            Result := 'Unavailable';
            Exit;
          end;
        end;
        if CalledIDSize > 0 then begin
          SetLength(Result, CalledIDSize-1);
          Move(Data[CalledIDOffset], Result[1], CalledIDSize-1);
        end else
          Result := '';
      end;
    end else
      Result := '';
  end;

  function TApdCustomTapiDevice.GetCalledIDName: AnsiString;
  begin
    if Assigned(FCallInfo) then begin
      with FCallInfo^ do begin
        if (CalledIDFlags and LINECALLPARTYID_BLOCKED <> 0) then begin
          Result := AproLoadAnsiStr(ecTapiCIDBlocked);
          Exit;
        end;
        if (CalledIDFlags and LINECALLPARTYID_OUTOFAREA <> 0) then begin
          Result := AproLoadAnsiStr(ecTapiCIDOutOfArea);
          Exit;
        end;
        if (CalledIDFlags and LINECALLPARTYID_UNKNOWN <> 0) then begin
          Result := 'Unknown';
          Exit;
        end;
        if (CalledIDFlags and LINECALLPARTYID_UNAVAIL <> 0) then begin
          Result := 'Unavailable';
          Exit;
        end;
        if CalledIDNameSize > 0 then begin
          SetLength(Result, CalledIDNameSize-1);
          Move(Data[CalledIDNameOffset], Result[1], CalledIDNameSize-1);
        end else
          Result := '';
      end;
    end else
      Result := '';

  end;

  function TApdCustomTapiDevice.GetCallerID : AnsiString;
    {-Return the caller ID of the current call}
  begin
    if Assigned(FCallInfo) then begin
      with FCallInfo^ do begin
        if ((CallerIDFlags and LINECALLPARTYID_ADDRESS) = 0) then begin
          if ((CallerIDFlags and LINECALLPARTYID_BLOCKED) <> 0) then begin
            Result := AproLoadAnsiStr(ecTapiCIDBlocked);
            Exit;
          end;
          if ((CallerIDFlags and LINECALLPARTYID_OUTOFAREA) <> 0) then begin
            Result := AproLoadAnsiStr(ecTapiCIDOutOfArea);
            Exit;
          end;
          if ((CallerIDFlags and LINECALLPARTYID_UNKNOWN) <> 0) then begin
            Result := 'Unknown';
            Exit;
          end;
          if ((CallerIDFlags and LINECALLPARTYID_UNAVAIL) <> 0) then begin
            Result := 'Unavailable';
            Exit;
          end;
        end;
        if CallerIDSize > 0 then begin
          SetLength(Result, CallerIDSize-1);
          Move(Data[CallerIDOffset], Result[1], CallerIDSize-1);
        end else
          Result := '';
      end;
    end else
      Result := '';
  end;

  function TApdCustomTapiDevice.GetCallerIDName : Ansistring;
    {-Return the caller ID name of the current call}
  begin
    if Assigned(FCallInfo) then begin
      with FCallInfo^ do begin
        if (CallerIDFlags and LINECALLPARTYID_BLOCKED <> 0) then begin
          Result := AproLoadAnsiStr(ecTapiCIDBlocked);
          Exit;
        end;
        if (CallerIDFlags and LINECALLPARTYID_OUTOFAREA <> 0) then begin
          Result := AproLoadAnsiStr(ecTapiCIDOutOfArea);
          Exit;
        end;
        if (CallerIDFlags and LINECALLPARTYID_UNKNOWN <> 0) then begin
          Result := 'Unknown';
          Exit;
        end;
        if (CallerIDFlags and LINECALLPARTYID_UNAVAIL <> 0) then begin
          Result := 'Unavailable';
          Exit;
        end;
        if CallerIDNameSize > 0 then begin
          SetLength(Result, CallerIDNameSize-1);
          Move(Data[CallerIDNameOffset], Result[1], CallerIDNameSize-1);
        end else
          Result := '';
      end;
    end else
      Result := '';
  end;

  procedure TApdCustomTapiDevice.TapiStatus(First, Last : Boolean;
    Device, Message, Param1, Param2, Param3 : DWORD);
    {-Handle the TAPI status callback}
  begin
    {Exit immediately if in passthrough mode}
    if PassThruMode then
      Exit;

    {Automatically hand off to status display, if one is attached}
    if Assigned(FStatusDisplay) {and (Connected or not Last)} then       {!!.02}
      StatusDisplay.UpdateDisplay(First, Last, Device, Message,
        Param1, Param2, Param3);

    {Call the user's event handler}
    if Assigned(FOnTapiStatus) and not((Message = 0) and (Param1 = 0)
      and (Param2 = 0) and (Param3 = 0)) then
        FOnTapiStatus(Self, First, Last, Device, Message, Param1, Param2, Param3);
  end;

  procedure TApdCustomTapiDevice.TapiLogging(Log : TTapiLogCode);
    {-Handle the TAPI log event}
  begin
    {If OnTapiLog is assigned then call it}
    if Assigned(FTapiLog) then
      FTapiLog.UpdateLog(Log);

    {If event handler is assigned then call it}
    if Assigned(FOnTapiLog) then
      FOnTapiLog(Self, Log);
  end;

  procedure TApdCustomTapiDevice.ShowConfigDialog;
    {-Show the TAPI device configuration dialog of the selected device}
  var
    SaveOpen : Boolean;
  begin
    StartTapi;
    SaveOpen := Open;
    Open := True;

    TapiException(Self, tuLineConfigDialog(GetSelectedLine,
      ParentHWnd, 'comm/datamodem'));

    Open := SaveOpen;
  end;

  function TApdCustomTapiDevice.ShowConfigDialogEdit
    (const Init : TTapiConfigRec) : TTapiConfigRec;
    {-Show config dlg, returns Get/SetDevConfig compatible string}
  begin
    FillChar(VS, SizeOf(TVarString), 0);
    VS.TotalSize := SizeOf(TVarString);
    TapiException(Self, tuLineConfigDialogEdit(GetSelectedLine,
      ParentHWnd, 'comm/datamodem', Init.Data, Init.DataSize, VS));  
    Result.DataSize := VS.StringSize;
    Move(VS.StringData[VS.StringOffset], Result.Data, VS.StringSize);
  end;

  function TApdCustomTapiDevice.SelectDevice : TModalResult;
    {-Show the TAPI device selection dialog}
  var
    E : TDeviceSelectionForm;
  begin
    E := TDeviceSelectionForm.Create(Application);
    E.ShowTapiDevices := ShowTapiDevices;
    E.ShowOnlySupported := FilterUnsupportedDevices;                   
    E.ShowPorts := FShowPorts;
    E.EnableVoice := FEnableVoice;
    E.TapiMode := tmAuto;
    if (FComPort <> nil) then
      E.TapiMode := FComPort.TapiMode;

    if E.TapiMode = tmOff then begin
      E.ComNumber := FComPort.ComNumber;
    end else begin
      E.DeviceName := FSelectedDevice;
    end;

    try
      if E.ShowModal = mrOK then begin
        if (FComPort <> nil) and (E.TapiMode = tmOff) then begin
          FComPort.TapiMode := E.TapiMode;
          FComPort.ComNumber := E.ComNumber;
        end else if (E.TapiMode <> tmOff) then begin
          if (FComPort <> nil) then
            FComPort.TapiMode := E.TapiMode;

          {Set the selected TAPI device}
          FSelectedDevice := E.DeviceName;

          {Check for DTMF Compatibility if enabled}
          SetEnableVoice(FEnableVoice);
        end;
        Result := mrOK;
      end else
        Result := mrCancel;
    finally
      E.Free;
    end;
  end;

  procedure TApdCustomTapiDevice.SendTone(Digits : string;                  // SWB
                                          Duration: Integer);               // SWB
  begin
    if FEnableVoice then
      TapiException(Self, tulineGenerateDigits(CallHandle,
        LINEDIGITMODE_DTMF, @Digits[1], Duration));                         // SWB
  end;

  procedure TApdCustomTapiDevice.TapiPortOpen;
    {-Generate the TapiPortOpen event}
  begin
    {Call the user's event handler}
    if Assigned(FOnTapiPortOpen) then
      FOnTapiPortOpen(Self);
  end;

  procedure TApdCustomTapiDevice.TapiPortClose;
    {-Generate the TapiPortClose event}
  begin
    {Call the user's event handler}
    if Assigned(FOnTapiPortClose) then
      FOnTapiPortClose(Self);
  end;

  procedure TApdCustomTapiDevice.TapiConnect;
    {-Generate the TapiConnect event}
  begin
    {Call the user's event handler}
    if Assigned(FOnTapiConnect) then
      FOnTapiConnect(Self);
  end;

  procedure TApdCustomTapiDevice.TapiFail;
    {-Generate the TapiFail event}
  begin
    {Call the user's event handler}
    if not TapiFailFired then begin
      TapiFailFired := True;                                             {!!.06}
      if Assigned(FOnTapiFail) then
        FOnTapiFail(Self);
      //TapiFailFired := True;  moved up above                           {!!.06}
      if not Open then                                                   {!!.04}
        { if we're open, then we were either already waiting for a call }
        { or have a call already } 
        FWaitingForCall := False;                                        {!!.04}
    end                                                                
  end;

  procedure TApdCustomTapiDevice.TapiDTMF(Digit : Char;                
                                          ErrorCode: Integer);
    {-Generate the TapiDTMF event}
  begin
    {Call the user's event handler}
    if (Digit = '') or (Digit = ' ') then Exit;
    if FInterruptWave then begin
      StopWaveFile;
      if Assigned(FOnTapiDTMF) then
        FOnTapiDTMF(Self, Digit, ErrorCode);
    end else begin
      if Assigned(FOnTapiDTMF) and (FWaveState <> wsPlaying) then
        FOnTapiDTMF(Self, Digit, ErrorCode);
      Exit;
    end;
  end;

  procedure TApdCustomTapiDevice.TapiCallerID(ID, IDName: string);     
    {-Generate the TapiCallerID event}
  begin
    {Call the user's event handler}
    if Assigned(FOnTapiCallerID) then
      FOnTapiCallerID(Self, ID, IDName);
  end;

  procedure TApdCustomTapiDevice.TapiWave(Msg : TWaveMessage);         
    {-Generate the TapiWaveNotify event}
  begin
    {Call the user's event handler}
    if Assigned(FOnTapiWaveNotify) then
      FOnTapiWaveNotify(Self, Msg);
  end;

  procedure TApdCustomTapiDevice.CreateDialTimer;
    {-Create and start a Delphi timer}
  begin
    if Assigned(DialTimer) then
      DialTimer.Free;
    try
      DialTimer := TTimer.Create(Self);
      DialTimer.Interval := 1000;
      DialTimer.Enabled := True;
      DialTimer.OnTimer := TapiDialTimer;
      FDialTime := FRetryWait;                                      
    except
      {Ignore errors, but assure DialTimer is nil}
      DialTimer := nil;
    end;
  end;

  procedure TApdCustomTapiDevice.AssureTapiReady;
    {-Check that TAPI is set to go, raise exception if not}
  begin
    {Error if no comport assigned}
    if not Assigned(FComPort) then
      raise EPortNotAssigned.Create(ecPortNotAssigned, False);

    {Set TapiMode if it's auto...}
    if ComPort.TapiMode = tmAuto then
      ComPort.TapiMode := tmOn;

    {Error if not in TAPI mode}
    if ComPort.TapiMode <> tmOn then
      raise ETapiNotSet.Create(ecTapiNotSet, True);

    {Error if the TAPI device is busy}
    if (TapiState > tsIdle) then
      raise ETapiBusy.Create(ecTapiBusy, True);
  end;

  procedure TApdCustomTapiDevice.DialPrim(PassThru : Boolean);
    {-Dial ANumber}
  const
    BearerChoice : array[Boolean] of DWORD =
      (LINEBEARERMODE_VOICE, LINEBEARERMODE_PASSTHROUGH);
  var
    CallParams : TLineCallParams;
    NumZ       : array[0..255] of AnsiChar;
    ReplyResult: Integer;
  begin
    { Call already in progress, exit to avoid reentry }
    if TapiInUse then
      Exit;
    {$IFDEF TapiDebug}
    WriteLn(Dbg, Self.Name + '.DialPrim');
    {$ENDIF}

    StartTapi;

    { Open the line device }
    FCancelled := False;
    FDialing := True;
    Open := True;

    {Init the call parameters for outbound dialing}
    FillChar(CallParams, SizeOf(CallParams), 0);
    with CallParams do begin
      TotalSize := SizeOf(CallParams);
      BearerMode := BearerChoice[PassThru];
      if FEnableVoice then
        MediaMode := LINEMEDIAMODE_AUTOMATEDVOICE
      else
        MediaMode   := LINEMEDIAMODE_DATAMODEM;
      CallParamFlags := LINECALLPARAMFLAGS_IDLE;
      AddressMode := LINEADDRESSMODE_ADDRESSID;
      AddressID := 0;
    end;

    {Make the call}
    TapiFailFired := False;
    TapiLogging(ltapiDial);
    ReplyResult := WaitForReply(tuLineMakeCall(LineHandle, CallHandle,
      AnsiStrings.StrPCopy(NumZ, AnsiString(Number)), 0, @CallParams));
    if ReplyResult < 0 then begin
      {Line is not available. Log failure and clean up...}
      FFailCode := ReplyResult;
      TapiLogging(ltapiDialFail);
      RetryPending := False;
      HangupCall(True);
      FWaitingForCall := False;                                          {!!.04}
      {Let user know of failure if event handler is assigned}
      {otherwise raise exception}
      if not Assigned(FOnTapiFail) then
        raise ETapiCallUnavail.Create(ecCallUnavail, True)
      else
        {TapiFail;}
        PostMessage(FHandle, apw_TapiEventMessage, etTapiFail, 0);
    end;
  end;

  procedure TApdCustomTapiDevice.Dial(ANumber : string);
    {-Dial ANumber}
  begin
    {$IFDEF TapiDebug}
    WriteLn(Dbg, Self.Name + '.Dial');
    {$ENDIF}

    {Raise exception if not ready}
    AssureTapiReady;

    {Inits}
    FAttempt := 1;
    RetryPending := True;
    FNumber := ANumber;
    PassThruMode := False;
    if Assigned(FStatusDisplay) then
      FStatusDisplay.Answering := False;

    {Dial the number}
    DialPrim(False);
  end;

  procedure TApdCustomTapiDevice.AutoAnswer;
    {-Wait for and answer incoming calls}
  begin
    {$IFDEF TapiDebug}
    WriteLn(Dbg, Self.Name + '.AutoAnswer');
    {$ENDIF}

    {Raise exception if not ready}
    AssureTapiReady;

    {Setup for answering...}
    StartTapi;
    FCancelled := False;
    FDialing := False;
    PassThruMode := False;
    Open := False;
    Open := True;
    FWaitingForCall := True;                                             {!!.04}

    if Assigned(FStatusDisplay) then
      FStatusDisplay.Answering := True;
  end;

  procedure TApdCustomTapiDevice.ConfigAndOpen;
    {-Open the TAPI port in passthru mode}
  begin
    {$IFDEF TapiDebug}
    WriteLn(Dbg, Self.Name + '.ConfigAndOpen');
    {$ENDIF}

    {Raise exception if not ready}
    AssureTapiReady;

    {Setup for answering to force TAPI to send the init commands}
    StartTapi;
    FDialing := False;
    PassThruMode := True;
    Open := False;

    {Open the line, which causes the commands to be sent}
    WaitCursor;
    Open := True;
    RestoreCursor;

    {Now reopen it in passthrough mode}
    Open := False;
    DialPrim(True);
  end;

  function TApdCustomTapiDevice.CancelCall : Boolean;
    {-Cancel the current call, always returns True}
  begin
    {$IFDEF TapiDebug}
    WriteLn(Dbg, Self.Name + '.CancelCall');
    {$ENDIF}
    { Kill wave device if playing }
    if FWaveState = wsPlaying then
      StopWaveFile;
    FCancelled := True;
    TapiLogging(ltapiCancel);
    Result := HangupCall(True);
    FWaitingForCall := False;                                            {!!.04}
  end;

  procedure TApdCustomTapiDevice.CopyCallInfo(var CallInfo : PCallInfo);
    {Allocate and return a CallInfo structure with current callinfo}
  begin
    if Assigned(FCallInfo) then begin
      {Allocate a new buffer}
      CallInfo := AllocMem(FCallInfo^.TotalSize);
      Move(FCallInfo^, CallInfo^, FCallInfo^.TotalSize);
    end else
      CallInfo := nil;
  end;

  function TApdCustomTapiDevice.GetDevConfig : TTapiConfigRec;
    {-Gets configuration data that can be used with SetDevConfig}
  begin
    FillChar(VS, SizeOf(TVarString), 0);
    VS.TotalSize := SizeOf(TVarString);
    TapiException(Self,
      tuLineGetDevConfig(GetSelectedLine, VS, 'comm/datamodem'));
    Result.DataSize := VS.StringSize;
    Move(VS.StringData[VS.StringOffset], Result.Data, VS.StringSize);
  end;

  procedure TApdCustomTapiDevice.SetDevConfig(const Config : TTapiConfigRec);
    {-Sets config, requires data from GetDevConfig or ShowConfigDialogEdit }
  begin
    TapiException(Self, tuLineSetDevConfig(GetSelectedLine,
      Config.Data, Config.DataSize, 'comm/datamodem'));
  end;

  function TApdCustomTapiDevice.TapiStatusMsg(const Message,
    State, Reason : DWORD) : string;
    {-Return a status message for the TAPI message and state}
  var
    ID : Word;

    function Bits2Ord(Bits : DWORD) : Word;
    {Convert bit in State to an ordinal value}
    {e.g., $01->1, $02->2, $04->3, $08->4, and so on}
    begin
      for Result := 1 to 32 do begin
        if (Bits and 1) = 1 then
          Break;
        Bits := Bits shr 1;
      end;
    end;

  begin
    ID := Bits2Ord(State);

    {Build a string ID, then load it}
    case Message of
      Line_CallState    : Inc(ID, TapiStatusBase + lcsBase);
      Line_LineDevState : Inc(ID, TapiStatusBase + ldsBase);
      Line_ApdSpecific  : Inc(ID, TapiStatusBase + asBase);
      Line_Reply        : Inc(ID, TapiStatusBase + lrBase);
      else                Inc(ID, TapiStatusBase + asBase);
    end;

    if (Message = Line_ApdSpecific) and (State = ApdSpecific_RetryWait) then
      Result := Format(AproLoadStr(ID), [FDialTime])
    else if (State = LineCallState_Disconnected) then
      Result := Format(AproLoadStr(ID),
        [AproLoadStr(TapiStatusBase + lcsdBase + Bits2Ord(Reason))])
    else
      Result := AproLoadStr(ID);
  end;

  function TApdCustomTapiDevice.FailureCodeMsg(const FailureCode: Integer): string;
  begin
    if FailureCode < Success then
      Result := AproLoadStr((TapiErrorBase + FailureCode))
    else
      Result := TapiStatusMsg(Line_CallState, LineCallState_Disconnected,
        FailureCode);
  end;

  function TApdCustomTapiDevice.TapiLogToString(const LogCode : TTapiLogCode) : string;
  begin
    case LogCode of
      ltapiNone          : Result := 'None';
      ltapiCallStart     : Result := 'Call started';
      ltapiCallFinish    : Result := 'Call finished';
      ltapiDial          : Result := 'Dialing';
      ltapiAccept        : Result := 'Accepting an incoming call';
      ltapiAnswer        : Result := 'Answering an incoming call';
      ltapiConnect       : Result := 'Connected';
      ltapiCancel        : Result := 'Call cancelled';
      ltapiDrop          : Result := 'Call drop';
      ltapiBusy          : Result := 'Called number was busy';
      ltapiDialFail      : Result := 'Dial failed';
      ltapiReceivedDigit : Result := 'Received a DTMF tone';
    end;
  end;

  procedure TApdCustomTapiDevice.MonitorDTMF(var CallHandle : Integer;
    const DTMFMode : Integer);
  var
    DTMFError: Integer;
  begin
    if FEnableVoice then begin
      DTMFError := tulineMonitorDigits(CallHandle, DTMFMode);
      if (DTMFError <> 0) then
        if Assigned(FOnTapiDTMF) then
          TapiDTMF(' ', DTMFError)
        else
          raise ETapiVoiceNotSupported.Create(ecTapiVoiceNotSupported, True);
    end;
  end;

  function TApdCustomTapiDevice.MontorTones(
    const Tones: array of TLineMonitorTones) : Integer;
    { monitors for specific tones, see the TAPI.HLP file for details}
    { returns 0 if successful }
  begin
    if FEnableVoice then
      Result := tuLineMonitorTones(CallHandle, Tones, high(Tones))
    else
      Result := ecTapiVoiceNotSupported;
  end;


  function TApdCustomTapiDevice.GetComNumber : Integer;
    {-Return the Com Number from the current TAPI device}
  var
    S: string[10];
    X : Integer;
    SaveOpen: Boolean;
  begin
    { need a valid line handle before this will work, so open the line}
    StartTapi;
    SaveOpen := Open;
    Open := True;

    {Requires Tapi 2+}
    FillChar(VS, SizeOf(TVarString), 0);
    VS.TotalSize := SizeOf(TVarString);
    X := tuLineGetID(LineHandle, 0, 0, LINECALLSELECT_LINE,
                     VS, 'comm/datamodem/portname');
    if X = 0 then with VS do begin
      if StringSize > 10 then
        StringSize := 10;
      S[0] := AnsiChar(StringSize);
      Move(StringData[StringOffset], S[1], StringSize);
      Delete(S, 1, 3);
      Val(string(S), Result, X);
      if X <> 0 then
        Result := 0;
    end else
      Result := 0;
    Open := SaveOpen;
  end;

  function TApdCustomTapiDevice.GetParentHWnd : HWnd;
  begin
    if not IsWindow(FParentHWnd) then begin
      if (Owner is TWinControl) then
        FParentHWnd := TWinControl(Owner).Handle
      else
        FParentHWnd := GetActiveWindow;
    end;
    Result := FParentHWnd;
  end;

  function TApdCustomTapiDevice.GetTapiState : TTapiState;
  var
    CurrentCallStatus : PCallStatus;
  begin
    if CallHandle <> 0 then begin
      tuLineGetCallStatusDyn(CallHandle, CurrentCallStatus);
      try
        case CurrentCallStatus^.CallState of
          LineCallState_Idle : Result := tsIdle;
          LineCallState_Offering : Result := tsOffering;
          LineCallState_Accepted : Result := tsAccepted;
          LineCallState_Dialtone : Result := tsDialTone;
          LineCallState_Dialing : Result := tsDialing;
          LineCallState_Ringback : Result := tsRingBack;
          LineCallState_Busy : Result := tsBusy;
          LineCallState_SpecialInfo : Result := tsSpecialInfo;
          LineCallState_Connected : Result := tsConnected;
          LineCallState_Proceeding : Result := tsProceeding;
          LineCallState_OnHold : Result := tsOnHold;
          LineCallState_Conferenced : Result := tsConferenced;
          LineCallState_OnHoldPendConf : Result := tsOnHoldPendConf;
          LineCallState_OnHoldPendTransfer : Result := tsOnHoldPendTransfer;
          LineCallState_Disconnected : Result := tsDisconnected;
          else Result := tsUnknown;
        end;
      finally
        FreeMem(CurrentCallStatus, CurrentCallStatus^.TotalSize);
      end;
    end else
      Result := tsIdle;
  end;

  procedure TApdCustomTapiDevice.AutomatedVoicetoComms;
  begin
    if not FEnableVoice then Exit;
    if (FCallInfo^.MediaMode and LINEMEDIAMODE_AUTOMATEDVOICE) <> 0 then begin
      WaitForReply(tuLineSetCallParams(CallHandle,
        LINEBEARERMODE_PASSTHROUGH, 1200, 115200, nil));
      { we don't need to set the MediaMode, we already have a valid mode set }
      {if tuLineSetMediaMode(CallHandle, (LINEMEDIAMODE_UNKNOWN +}       {!!.02}
        {LINEMEDIAMODE_DATAMODEM + LINEMEDIAMODE_G3FAX)) <> 0 then}
        {raise ETapiVoiceNotSupported.Create(ecTapiVoiceNotSupported, True)}
      {else begin}
        OpenTapiPort;
      {end;}
    end;
  end;

  procedure TApdCustomTapiDevice.PlayWaveFile(FileName : string);
    { Play a wave file through the TAPI device or through the sound card. }
  var
    MmCkInfoParent   : TMMCkInfo;
    MmCkInfoSubchunk : TMMCkInfo;
    FormatSize       : DWORD;
    WaveFormat       : PWaveFormatEx;
    Res              : Integer;
    WaveOutDevCaps   : TWaveOutCaps;
    DeviceId         : DWORD;
    Flags            : Integer;
  begin
    if FWaveState = wsRecording then
      raise ETapiWaveFail.Create(ecTapiWaveDeviceInUse, True);

    { If a wave file is playing then stop it. }
    if FWaveState = wsPlaying then
      if FInterruptWave then begin
        StopWaveFile;
        while (WaveOutHandle <> 0) do
          Application.ProcessMessages;
      end
      else
        Exit;

    FWaveFileName := FileName;
    { Check for the existence of the wave file first. }
    if (not FileExists(FileName)) then
      raise ETapiWaveFail.Create(ecFileNotFound, True);

    if FUseSoundCard then
      DeviceId := WAVE_MAPPER
    else
      DeviceId := GetWaveDeviceId(True);

    { Open the wave file }
    MmioOutHandle := mmioOpen(PChar(FileName),
      nil, MMIO_READ or MMIO_ALLOCBUF);

    { Look for the 'WAVE' chunk to be sure it's a .WAV file.}
    MmCkInfoParent.fccType := mmioStringToFOURCC('WAVE', 0);

    Res := MmioDescend(MmioOutHandle,
      @MmCkInfoParent, nil, MMIO_FINDRIFF);
    CheckWaveException(Res, MMioError);

    { Locate the format chunk. }
    MmCkInfoSubchunk.ckid := mmioStringToFOURCC('fmt ', 0);

    Res := mmioDescend(MmioOutHandle, @MmCkinfoSubchunk, @MmCkinfoParent, MMIO_FINDCHUNK);
    CheckWaveException(Res, MMioError);

    if (WaveOutHeader <> nil) then
      FreeWaveOutBuffer;

    { Get the size of the format chunk and allocate some memory for it. }
    FormatSize := MmCkinfoSubchunk.cksize;
    GetMem(WaveFormat, FormatSize);

    { Read the format chunk. }
    Res := mmioRead(MmioOutHandle, PAnsiChar(WaveFormat), FormatSize);
    if Res = -1 then
       raise ETapiWaveFail.Create(ecTapiWaveReadError, True);

    {Set the buffer size based on the format}
    WaveOutBufferSize := (SamplesPerSecond *
      (BitsPerSample div 8) * WaveOutBufferSeconds);

    { Make sure the TAPI wave out device supports the   }
    { wave file format. The WAVE_FORMAT_QUERY flag will }
    { query the device without actually opening it.     }
    waveOutGetDevCaps(deviceId,
      @WaveOutDevCaps, SizeOf(WaveOutDevCaps));
    Flags := WAVE_FORMAT_QUERY;
    if not FUseSoundCard then
      Flags := Flags or WAVE_MAPPED;
    Res := waveOutOpen(@WaveOutHandle,
        DeviceId, WaveFormat, 0, 0, Flags);
    CheckWaveException(Res, WaveOutError);

    { Find the data subchunk. }
    mmioAscend(MmioOutHandle, @MmCkinfoSubchunk, 0);
    MmCkinfoSubchunk.ckid := mmioStringToFOURCC('data', 0);
    Res := mmioDescend(MmioOutHandle, @MmCkinfoSubchunk, @MmCkinfoParent, MMIO_FINDCHUNK);
    CheckWaveException(Res, MMioError);

    { Get the size of the data. }
    BytesToPlay := MmCkinfoSubchunk.cksize;
    BytesPlayed := 0;

    { Open the TAPI wave out device. }
    Flags := CALLBACK_WINDOW;
    if not FUseSoundCard then
      Flags := Flags or WAVE_MAPPED;
    Res := waveOutOpen(@WaveOutHandle, Integer(DeviceId),
      WaveFormat, MakeLong(FHandle, 0), DWORD(Self), Flags);
    if (Res <> 0) then begin
       if (Res = MMSYSERR_NOTENABLED) then begin
         FreeMem(WaveFormat, SizeOf(FormatSize));
         WaveOutHandle := 0;
         Exit;
       end
       else
         CheckWaveException(Res, WaveOutError);
    end;
    { Free the memory allocated for the format header. }
    FreeMem(WaveFormat, SizeOf(FormatSize));

    { Set up WaveOutHeader record. }
    GetMem(WaveOutHeader, SizeOf(TWaveHdr));
    WaveOutHeader^.dwFlags        := 0;
    WaveOutHeader^.dwLoops        := 0;
    WaveOutHeader^.dwUser         := 0;

    { Allocate memory for the data. This memory will be }
    { freed when the wave file finishes playing. }
    GetMem(WaveOutBuffer1, WaveOutBufferSize);
    GetMem(WaveOutBuffer2, WaveOutBufferSize);
    ActiveWaveOutBuffer := 0;

    { Start playing. }
    LoadWaveOutBuffer;
    PlayWaveOutBuffer;
    FWaveState := wsPlaying;
  end;

  procedure TApdCustomTapiDevice.LoadWaveOutBuffer;
  var
    Res   : Integer;
  begin
    { Determine how many bytes to read from the file }
    if (BytesPlayed + WaveOutBufferSize) <= BytesToPlay then
      BytesInBuffer := WaveOutBufferSize
    else
      BytesInBuffer := BytesToPlay - BytesPlayed;

    { Read the waveform data into the idle buffer. }
    if ActiveWaveOutBuffer = 2 then
      Res := mmioRead(MmioOutHandle,
        PAnsiChar(WaveOutBuffer2), BytesInBuffer)
    else
      Res := mmioRead(MmioOutHandle,
        PAnsiChar(WaveOutBuffer1), BytesInBuffer);
    if ActiveWaveOutBuffer = 0 then
      ActiveWaveOutBuffer := 1;
    if Res = -1 then
       raise ETapiWaveFail.Create(ecTapiWaveReadError, True);
  end;

  procedure TApdCustomTapiDevice.PlayWaveOutBuffer;
  var
    Res   : Integer;
  begin
    if ActiveWaveOutBuffer = 1 then begin
      WaveOutHeader^.lpData := PAnsiChar(WaveOutBuffer1);
      ActiveWaveOutBuffer := 2;
    end else begin
      WaveOutHeader^.lpData := PAnsiChar(WaveOutBuffer2);
      ActiveWaveOutBuffer := 1;
    end;
    WaveOutHeader^.dwBufferLength := BytesInBuffer;
    waveOutPrepareHeader(
      WaveOutHandle, WaveOutHeader, SizeOf(TWaveHdr));

    { Write the data to the wave out device. }
    Res := waveOutWrite(
      WaveOutHandle, WaveOutHeader, SizeOf(TWaveHdr));
    if (Res <> 0) then begin
      waveOutUnprepareHeader(
        WaveOutHandle, WaveOutHeader, SizeOf(TWaveHdr));
      FreeWaveOutBuffer;
      Exit;
    end;

    BytesPlayed := BytesPlayed + BytesInBuffer;

    { If the entire file has been loaded then set BytesPlayed}
    { to -1 so we know we are on the last buffer.}
    if (BytesPlayed >= BytesToPlay) then
      BytesPlayed := -1;

    { Load the next buffer. }
    if (BytesPlayed <> -1) then
      LoadWaveOutBuffer;
  end;

  function TApdCustomTapiDevice.GetSelectedLine : Integer;
  begin
    SelectedLine := DeviceIDFromName(SelectedDevice);

    if (SelectedLine = -1) then begin
      { Simple case -- one Tapi device, so select it}
      if (FDeviceCount = 1) and (SelectedDevice = '') then begin
        SelectedLine := 0;
        SelectedDevice := TapiDevices[0];
      end else begin
        { If both ShowPorts and ShowTapiDevices are False then }
        { assume the user doesn't want to show the TAPI device }
        { selection dialog and throw an exception. }
        if (ShowPorts = False) and (ShowTapiDevices = False) then
          raise ETapiNoSelect.Create(ecTapiNoSelect, True);

        with TDeviceSelectionForm.Create(Application) do try
          ShowPorts := False;
          ShowTapiDevices := True;
          if (ShowModal = mrOk) then begin
            FSelectedDevice := DeviceName;
            SelectedLine := DeviceIDFromName(FSelectedDevice);
          end else
            raise ETapiNoSelect.Create(ecTapiNoSelect, True);
        finally
          Free;
        end;
      end;
    end;

    Result := SelectedLine;
  end;

  function TApdCustomTapiDevice.GetWaveDeviceId(const Play : Boolean) : DWORD;
    { Gets the device ID for the TAPI wave device. }
  var
    LineDevCaps      : PLineDevCaps;
    Res              : DWORD;
  begin
    { Get the device caps to be sure this TAPI device supports voice. }
    Res := tuLineGetDevCapsDyn(
      LineApp, GetSelectedLine, ApiVersion, 0, LineDevCaps);
    if Res <> 0 then begin
      FreeMem(LineDevCaps, SizeOf(TLineDevCaps));
      raise ETapiWaveFail.Create(ecTapiWaveFail, True);
    end;

    if (LineDevCaps^.MediaModes and LINEMEDIAMODE_AUTOMATEDVOICE) = 0 then begin
      FreeMem(LineDevCaps, SizeOf(TLineDevCaps));
      raise ETapiVoiceNotSupported.Create(ecTapiVoiceNotSupported, True);
    end;
    FreeMem(LineDevCaps, SizeOf(TLineDevCaps));

    Result := 0;
    FillChar(VS, SizeOf(TVarString), 0);
    VS.TotalSize := SizeOf(TVarString);
    if Play then
      Res := tuLineGetID(LineHandle, 0, CallHandle,
                   LINECALLSELECT_CALL,
                   VS, 'wave/out')
    else
      Res := tuLineGetID(LineHandle, 0, CallHandle,
                   LINECALLSELECT_CALL,
                   VS, 'wave/in');
    if Res <> 0 then
      raise ETapiWaveFail.Create(ecTapiWaveFail, True)
    else with VS do
      Move(StringData[StringOffset], Result, SizeOf(DWORD));
  end;

  procedure TApdCustomTapiDevice.StopWaveFile;
    { Stop the wave file from playing. }
  begin
    {if (FWaveState <> wsPlaying) then Exit;}                          
    if WaveOutHandle = 0 then exit;                                    
    BytesPlayed := -1;
    waveOutReset(WaveOutHandle);
  end;

  procedure TApdCustomTapiDevice.SetMonitorRecording(const Value: Boolean); 
  var
    WaveFormat       : TWaveFormatEx;
    Res              : Integer;
  begin
    if (FWaveState = wsRecording) then begin
      { If we are recording and are already monitoring }
      { then we need to clean up the wave out device. }
      if FMonitorRecording then begin
        WaveOutReset(WaveOutHandle);
        WaveOutClose(WaveOutHandle);
        if (WaveOutHeader <> nil) then begin
          { Don't free the memory for the wave out buffer }
          { since we are just borrowing the wave in buffer. }
          WaveOutHeader^.lpData := nil;
          { Free the memory for the wave header. }
          FreeMem(WaveOutHeader, SizeOf(TWaveHdr));
          WaveOutHeader := nil;
          WaveOutHandle := 0;
        end;
        FMonitorRecording := Value;
      end else begin
        { If we are recording and not currently monitoring }
        { then we need to open the wave out device. }
        with WaveFormat do begin
          wFormatTag      := WAVE_FORMAT_PCM;
          nChannels       := Channels;
          nSamplesPerSec  := SamplesPerSecond;
          nAvgBytesPerSec := SamplesPerSecond * (BitsPerSample div 8);
          nBlockAlign     := (Channels * BitsPerSample) div 8;
          wBitsPerSample  := BitsPerSample;
          cbSize          := 0;
        end;
        Res := waveOutOpen(@WaveOutHandle, WAVE_MAPPER,
          @WaveFormat, 0, 0, CALLBACK_NULL);
        CheckWaveException(Res, WaveOutError);
        FMonitorRecording := Value;
      end;
    end else
      { Not recording, so just set the value. }
      FMonitorRecording := Value;
  end;

  procedure TApdCustomTapiDevice.StartWaveRecord;                      
    { Start recording wave data. }
  var
    WaveFormat       : TWaveFormatEx;
    Res              : Integer;
    DeviceId         : DWORD;
    Flags            : Integer;
  begin
    if (TapiState = tsIdle) then                                     
       SetOpen(True);

    if (FWaveState = wsRecording) or (FWaveState = wsPlaying) then
      raise ETapiWaveFail.Create(ecTapiWaveDeviceInUse, True);

    DeviceId := GetWaveDeviceId(False);                                

    { Set up the wave format. }
    with WaveFormat do begin
      wFormatTag      := WAVE_FORMAT_PCM;
      nChannels       := Channels;
      nSamplesPerSec  := SamplesPerSecond;
      nAvgBytesPerSec := SamplesPerSecond * (BitsPerSample div 8);
      nBlockAlign     := (Channels * BitsPerSample) div 8;
      wBitsPerSample  := BitsPerSample;
      cbSize          := 0;
    end;

     { Open the TAPI wave in device. }
    Flags := CALLBACK_WINDOW;
    Flags := Flags or WAVE_MAPPED;
    WaveInHandle := 0;
    Res := waveInOpen(@WaveInHandle, Integer(DeviceId),
      @WaveFormat, MakeLong(FHandle, 0), DWORD(Self), Flags);
    CheckWaveException(Res, WaveInError);

    if (FMonitorRecording) then begin
      Res := waveOutOpen(@WaveOutHandle, WAVE_MAPPER,
        @WaveFormat, 0, 0, CALLBACK_NULL);
      CheckWaveException(Res, WaveOutError);
    end;
    { Create two buffers for the wave data. By default the buffers }
    { are each one second's data in length (16,000 bytes). }
    WaveInBufferSize := (SamplesPerSecond *
      (BitsPerSample div 8) * BufferSeconds);
    GetMem(WaveInBuffer1, WaveInBufferSize);
    GetMem(WaveInBuffer2, WaveInBufferSize);

    { Just for insurance. }
    if (WaveInHeader <> nil) then
      FreeWaveInBuffers;

    { Set up WaveInHeader record. }
    GetMem(WaveInHeader, SizeOf(TWaveHdr));
    WaveInHeader^.dwBufferLength := WaveInBufferSize;
    WaveInHeader^.dwFlags        := 0;
    WaveInHeader^.dwLoops        := 0;
    WaveInHeader^.dwUser         := 0;

    { Set up for recording the first buffer. }
    ActiveBuffer := 1;
    TotalBytesRecorded := 0;
    PrepareWaveInHeader;
    OpenWaveFile;

    { Start recording. }
    Res := waveInStart(WaveInHandle);
    CheckWaveException(Res, WaveInError);
    FWaveState := wsRecording;
  end;

  procedure TApdCustomTapiDevice.StopWaveRecord;                       
    { Stop recording wave data. }
  var
    Res : DWORD;
  begin
    if FWaveState <> wsRecording then
      Exit;
    Res := waveInStop(WaveInHandle);
    CheckWaveException(Res, WaveInError);
    Res := waveInReset(WaveInHandle);
    CheckWaveException(Res, WaveInError);
  end;

  procedure TApdCustomTapiDevice.SaveWaveFile(FileName : string; Overwrite : Boolean);   
    { Copy the recorded wave data from the temp file to the user's file. }
  var
    Temp1 : TPathCharArray;
    Temp2 : TPathCharArray;
  begin
    if FWaveState = wsRecording then
      raise ETapiWaveFail.Create(ecTapiWaveDeviceInUse, True);

    if FWaveState <> wsData then
      raise ETapiWaveFail.Create(ecTapiWaveNoData, True);

    { Check for the existence of the wave file first. }
    if not Overwrite then
      if (FileExists(FileName)) then
        raise ETapiWaveFail.Create(ecTapiWaveFileExists, True);

    FWaveFileName := FileName;
    CopyFile(StrPCopy(Temp1, TempFileName),
      StrPCopy(Temp2, FileName), False);
    DeleteFile(TempFileName);
    FWaveState := wsIdle;
  end;

  procedure TApdCustomTapiDevice.SetRecordingParams(                   
                                   NumChannels : Byte;
                                   NumSamplesPerSecond : Integer;
                                   NumBitsPerSample : Byte);
    { Set the parameters that will be used for recording. }
  begin
    Channels := NumChannels;
    SamplesPerSecond := NumSamplesPerSecond;
    BitsPerSample := NumBitsPerSample;
  end;

  procedure TApdCustomTapiDevice.PrepareWaveInHeader;
  { Prepare the next buffer for recording. }
  var
    Res : Integer;
  begin
    if (ActiveBuffer = 1) then
      WaveInHeader^.lpData := PAnsiChar(WaveInBuffer1)
    else
      WaveInHeader^.lpData := PAnsiChar(WaveInBuffer2);

    Res := waveInPrepareHeader(
      WaveInHandle, WaveInHeader, SizeOf(TWaveHdr));

    CheckWaveException(Res, WaveInError);

    Res := waveInAddBuffer(
      WaveInHandle, WaveInHeader, SizeOf(TWaveHdr));

    if (Res <> 0) then begin
      waveInUnprepareHeader(
        WaveInHandle, WaveInHeader, SizeOf(TWaveHdr));
      FreeWaveInBuffers;
      CheckWaveException(Res, WaveInError);
    end;
  end;

  procedure TApdCustomTapiDevice.OpenWaveFile;
    { Open the temp wave file in preparation for recording. }
  var
    SubChunk   : TMMCkInfo;
    Res        : Integer;
    WaveFormat : TWaveFormatEx;
    Temp       : TPathCharArray;
    TempDir    : TPathCharArray;
  begin
    { Create a temp file in the temp directory. }
    GetTempPath(SizeOf(TempDir) div SizeOf(Char), TempDir);
    GetTempFileName(TempDir, '~AP', 0, Temp);
    TempFileName := StrPas(Temp);

    { Open the file. }
    MmioInHandle := mmioOpen(StrPCopy(Temp, TempFileName),
      nil, MMIO_CREATE or MMIO_WRITE);
    if (MmioInHandle = 0) then
      raise ETapiWaveFail.Create(ecTapiWaveFail, True);

    { Create the initial chunk. }
    RootChunk.fccType := mmioStringToFOURCC('WAVE', 0);
    Res := mmioCreateChunk(MmioInHandle, @RootChunk, MMIO_CREATERIFF);
    CheckWaveException(Res, MMioError);
    SubChunk.ckid := mmioStringToFOURCC('fmt ', 0);
    SubChunk.cksize := SizeOf(WaveFormat);
    Res := mmioCreateChunk(MmioInHandle, @SubChunk, 0);
    CheckWaveException(Res, MMioError);

    { Create the format chunk. }
    with WaveFormat do begin
      wFormatTag      := WAVE_FORMAT_PCM;
      nChannels       := Channels;
      nSamplesPerSec  := SamplesPerSecond;
      nAvgBytesPerSec := SamplesPerSecond * (BitsPerSample div 8);
      nBlockAlign     := (Channels * BitsPerSample) div 8;
      wBitsPerSample  := BitsPerSample;
      cbSize          := 0;
    end;
    Res := mmioWrite(MmioInHandle, PAnsiChar(@WaveFormat), SizeOf(WaveFormat));
    if (Res = -1) then begin
      raise ETapiWaveFail.CreateUnknown('MMIO Write Error', 0);
    end;

    { Create the data chunk. }
    Res := mmioAscend(MmioInHandle, @SubChunk, 0);
    CheckWaveException(Res, MMioError);
    DataChunk.ckid := mmioStringToFOURCC('data', 0);
    {Initial data chunk size of one buffer. Will be adjusted by mmioWrite.}
    DataChunk.cksize := WaveInBufferSize;
    Res := mmioCreateChunk(MmioInHandle, @DataChunk, 0);
    CheckWaveException(Res, MMioError);
  end;

  procedure TApdCustomTapiDevice.WriteWaveBuffer;
    { Write a wave buffer to the temp file. }
  var
    Res : Integer;
  begin
    { If monitoring recording then play the buffer }
    { through the sound card.}
    if (FMonitorRecording) then begin
      { Set up WaveOutHeader record. }
      GetMem(WaveOutHeader, SizeOf(TWaveHdr));
      WaveOutHeader^.lpData         := WaveInHeader^.lpData;
      WaveOutHeader^.dwBufferLength := WaveInHeader^.dwBufferLength;
      WaveOutHeader^.dwFlags        := 0;
      WaveOutHeader^.dwLoops        := 0;
      WaveOutHeader^.dwUser         := 0;
      waveOutPrepareHeader(
        WaveOutHandle, WaveOutHeader, SizeOf(TWaveHdr));
      { Write the data to the wave out device. }
      Res := waveOutWrite(
        WaveOutHandle, WaveOutHeader, SizeOf(TWaveHdr));
      if (Res <> 0) then begin
        waveOutUnprepareHeader(
          WaveOutHandle, WaveOutHeader, SizeOf(TWaveHdr));
        CheckWaveException(Res, WaveOutError);
      end;
    end;

    Res := mmioWrite(MmioInHandle, PAnsiChar(WaveInHeader^.lpData), BytesRecorded);
    if (Res = -1) then begin
      raise ETapiWaveFail.CreateUnknown('MMIO Write Error', 0);
    end;
  end;

  procedure TApdCustomTapiDevice.CloseWaveFile;
    { Close the temp wave file after recording. }
  var
    Res : Integer;
  begin
    mmioAscend(MmioInHandle, @DataChunk, 0);
    { Ascend out of the root chunk so the chunk info gets updated. }
    mmioAscend(MmioInHandle, @RootChunk, 0);
    Res := mmioClose(MmioInHandle, 0);
    CheckWaveException(Res, MMioError);
  end;

  procedure TApdCustomTapiDevice.FreeWaveOutBuffer;
    { Free the memory for the wave out buffer and WaveOutHeader. }
  begin
    WaveOutHandle := 0;
    if (WaveOutHeader <> nil) then begin
      { Free the memory for the wave out buffers. }
      WaveOutHeader^.lpData := nil;
      FreeMem(WaveOutBuffer1, WaveOutBufferSize);
      FreeMem(WaveOutBuffer2, WaveOutBufferSize);
      { Free the memory for the wave header. }
      FreeMem(WaveOutHeader, SizeOf(TWaveHdr));
      WaveOutHeader := nil;
    end;
  end;

  procedure TApdCustomTapiDevice.FreeWaveInBuffers;
    { Free the memory for the wave in buffers. }
  begin
    WaveInHandle := 0;
    if (WaveInHeader <> nil) then begin
      WaveInHeader^.lpData := nil;
      { Free the memory for the wave buffers. }
      FreeMem(WaveInBuffer1, WaveInBufferSize);
      FreeMem(WaveInBuffer2, WaveInBufferSize);
      { Free the memory for the wave header. }
      FreeMem(WaveInHeader, SizeOf(TWaveHdr));
      WaveInHeader := nil;
    end;
    if (FMonitorRecording) then begin
      WaveOutReset(WaveOutHandle);
      WaveOutClose(WaveOutHandle);
      if (WaveOutHeader <> nil) then begin
        { Don't free the memory for the wave out buffer }
        { since we are just borrowing the wave in buffer. }
        WaveOutHeader^.lpData := nil;
        { Free the memory for the wave header. }
        FreeMem(WaveOutHeader, SizeOf(TWaveHdr));
        WaveOutHeader := nil;
        WaveOutHandle := 0;
      end;
    end;
  end;

  procedure TApdCustomTapiDevice.CheckWaveException(ErrorCode : Integer;
                                                    Mode : Integer);
    { Checks to see if a wave or mmio exception was raised. }
  var
    ErrorText : array [0..MAXERRORLENGTH] of Char;
    ErrorString : string;
  begin
    if (ErrorCode = 0) then Exit;
    case Mode of
      WaveInError  :
        begin
          waveInGetErrorText(ErrorCode, ErrorText, SizeOf(ErrorText));
          ErrorString := StrPas(ErrorText);
        end;
      WaveOutError :
        begin
          waveOutGetErrorText(ErrorCode, ErrorText, SizeOf(ErrorText));
          ErrorString := StrPas(ErrorText);
        end;
      MMioError    :
        ErrorString := AproLoadStr(ecTapiWaveFail);
    end;
    if (WaveState = wsData) then begin
      FreeWaveInBuffers;
      FWaveState := wsIdle;
    end;
    raise ETapiWaveFail.CreateUnknown(ErrorString, 0);
  end;

  procedure TApdCustomTapiDevice.WndProc(var Message: TMessage);
    { WndProc to handle wave messages. }
  var
    WaveMsg : Integer;
  begin
    WaveMsg := -1;
    case Message.Msg of
      MM_WIM_OPEN  :
        { Wave input device was opened (for recording). }
        WaveMsg := Integer(waRecordOpen);
      MM_WIM_CLOSE :
        { Wave input device was closed (for recording). }
        WaveMsg := Integer(waRecordClose);
      MM_WIM_DATA  :
        begin
          { Wave data available for writing to file. This message is sent }
          { whenever a wave input buffer fills up or when the recording   }
          { is stopped manually. }

          { Record the number of bytes written to this buffer. }
          BytesRecorded := WaveInHeader^.dwBytesRecorded;
          { Add it to the total. }
          TotalBytesRecorded := TotalBytesRecorded + BytesRecorded;

          { If we have reached the max message length then close everything }
          { up. Also, if this buffer is not full then we must have stopped  }
          { recording for some reason (silence detected or recording was    }
          { manually stopped. }
          if (TotalBytesRecorded >=
             (FMaxMessageLength * (SamplesPerSecond * (BitsPerSample div 8))))
             or (BytesRecorded < WaveInBufferSize - 7) then begin
            { Write the buffer to disk. }
            WriteWaveBuffer;
            { Close the wave device and clean up the memory. }
            waveInClose(WaveInHandle);
            waveInUnprepareHeader(
              WaveInHandle, WaveInHeader, SizeOf(TWaveHdr));
            { Close the wave file and free the memory for the wave buffers. }
            CloseWaveFile;
            FWaveState := wsData;
            WaveMsg := Integer(waDataReady);
            FreeWaveInBuffers;
          end else begin

            { A buffer filled up but we aren't done recording yet. Write the }
            { current buffer to disk and start filling the next buffer. }
            WriteWaveBuffer;
            if ActiveBuffer = 1 then
              ActiveBuffer := 2
            else
              ActiveBuffer := 1;
            waveInUnprepareHeader(
              WaveInHandle, WaveInHeader, SizeOf(TWaveHdr));
            PrepareWaveInHeader;

            { If TrimSeconds is non-zero then check for silence in the }
            { buffer just filled. }
            if FTrimSeconds > 0 then
              CheckWaveInSilence;
          end;
        end;
      MM_WOM_OPEN :
        { The wave device was opened for output (playing). }
        WaveMsg := Integer(waPlayOpen);
      MM_WOM_CLOSE :
        { The wave output device was closed. }
        begin
          WaveMsg := Integer(waPlayClose);
          FWaveState := wsIdle;
        end;
      MM_WOM_DONE :
        { Done playing a wave buffer. }
        begin
          with Message do begin
            { Unprepare the header. }
            waveOutUnprepareHeader(
              hWaveOut(wParam), WaveOutHeader, SizeOf(TWaveHdr));
            { All done? }
            if BytesPlayed = -1 then begin
              if WaveOutHandle <> 0 then begin
                waveOutClose(WaveOutHandle);
                mmioClose(mmioOutHandle, 0);
                FWaveState := wsIdle;
                FreeWaveOutBuffer;
              end;
              WaveMsg := Integer(waPlayDone);
            { Not done, play another buffer. }
            end else
              PlayWaveOutBuffer;
          end;
        end;
      apw_TapiEventMessage :
        try
          case Message.WParam of
            etTapiConnect    : TapiConnect;
            etTapiPortOpen   : TapiPortOpen;
            etTapiPortClose  : TapiPortClose;
            etTapiFail       : TapiFail;
            etTapiLineCreate : DoLineCreate(0, Message.LParam, 0, 0);
          end;
        except
          Application.HandleException(nil);
        end;
    end;

    { Fire OnTapiWave event if necessary. }
    if (WaveMsg <> -1) then
      TapiWave(TWaveMessage(WaveMsg));
    try
      Dispatch(Message);
      if Message.Msg = WM_QUERYENDSESSION then
        Message.Result := 1;
    except
      Application.HandleException(Self);
    end;
  end;

  procedure TApdCustomTapiDevice.CheckWaveInSilence;
  { Check for silence in the last buffer recorded. }
  type
    TSmallIntArray = array[0..2] of SmallInt;
    PSmallIntArray = ^TSmallIntArray;
  var
    Buffer        : PSmallIntArray;
    I             : Integer;
    J             : Integer;
    Total         : Integer;
    StopRecording : Boolean;
    Hangup        : Boolean;
  const
    Count       : Integer = 0;
  begin
    { Check the buffer just read, not the active buffer. Cast it to an }
    { array of words since we are recording 16-bits of data per sample. }
    if ActiveBuffer = 2 then
      Buffer := PSmallIntArray(WaveInBuffer1)
    else
      Buffer := PSmallIntArray(WaveInBuffer2);
    I := 0;
    while I < (BufferSeconds * SamplesPerSecond) do begin
      Total := 0;
      { Average the data for the buffer. }
      for J := 0 to Pred(SamplesPerSecond) do
        Total := Total + Abs(Buffer^[I + J]);
      FAvgWaveInAmplitude := Total div SamplesPerSecond;

      { If the average is under the silence threshold then add one to the count. }
      if FAvgWaveInAmplitude < FSilenceThreshold then begin
        Inc(Count);

        { If the count has exceeded TrimSeconds then fire the OnTapiWaveSilence }
        { event, if one has been assigned. The default is to stop recording }
        { and hang up when silence is detected. }
        if Count >= FTrimSeconds - 1 then begin
          StopRecording := True;
          Hangup        := True;
          if (Assigned(FOnTapiWaveSilence)) then begin
            FOnTapiWaveSilence(Self, StopRecording, Hangup);
          end;
          if (StopRecording) then
            StopWaveRecord;
          if (Hangup) then
            CancelCall;
          Exit;
        end;
      end else
        { No silence? Then restart the counter. }
        Count := 0;
      Inc(I, SamplesPerSecond);
    end;
  end;

  function TApdCustomTapiDevice.TranslateAddress(CanonicalAddr : Ansistring) : Ansistring;
  var
    Res : Integer;
    TranslateOutput : PLineTranslateOutput;
  begin
    Res := tuLineTranslateAddressDyn(LineApp, GetSelectedLine,
      ApiVersion, string(CanonicalAddr), 0, LineTranslateOption_CancelCallWaiting,
      TranslateOutput);
    if (Res <> 0) then
      raise ETapiTranslateFail.Create(ecTapiTranslateFail, True);
    with TranslateOutput^ do begin
      {$IFOPT H+}
      SetLength(Result, pred(DialableStringSize));                       {!!.02}
      Move(Data[DialableStringOffset], PAnsiChar(Result)^, DialableStringSize);
      {$ELSE}
      Move(Data[DialableStringOffset], Result[1], DialableStringSize);
      Result[0] := Char(pred(DialableStringSize));                       {!!.02}
      {$ENDIF}
    end;
    FreeMem(TranslateOutput, TranslateOutput^.TotalSize);
  end;

  function TApdCustomTapiDevice.TranslateAddressEx(CanonicalAddr : Ansistring;
    Flags : Integer; var DialableStr, DisplayableStr : Ansistring;
    var CurrentCountry, DestCountry, TranslateResults : Integer) : Integer;
  var
    TranslateOutput : PLineTranslateOutput;
  begin
    Result := tuLineTranslateAddressDyn(LineApp, GetSelectedLine,
      ApiVersion, string(CanonicalAddr), 0, Flags, TranslateOutput);
    if (Result <> 0) then
      FreeMem(TranslateOutput, TranslateOutput^.TotalSize)
    else begin
      with TranslateOutput^ do begin
        {$IFOPT H+}
        SetLength(DialableStr, DialableStringSize);
        Move(Data[DialableStringOffset], PAnsiChar(DialableStr)^, DialableStringSize);
        SetLength(DisplayableStr, DisplayableStringSize);
        Move(Data[DisplayableStringOffset], PAnsiChar(DisplayableStr)^, DisplayableStringSize);
        {$ELSE}
        Move(Data[DialableStringOffset], DialableStr[1], DialableStringSize);
        DialableStr[0] := AnsiChar(DialableStringSize);
        Move(Data[DisplayableStringOffset], DisplayableStr[1], DisplayableStringSize);
        DisplayableStr[0] := Char(DisplayableStringSize);
        {$ENDIF}
      end;
      CurrentCountry   := TranslateOutput^.CurrentCountry;
      DestCountry      := TranslateOutput^.DestCountry;
      TranslateResults := TranslateOutput^.TranslateResults;
      FreeMem(TranslateOutput, TranslateOutput^.TotalSize);
    end;
  end;

  function TApdCustomTapiDevice.TranslateDialog(CanonicalAddr : string) : Boolean;
  begin
    Result := (tuLineTranslateDialog(LineApp, GetSelectedLine, ApiVersion,
      ParentHWnd, CanonicalAddr) = 0);
  end;


  procedure TApdCustomTapiDevice.SetFilterUnsupportedDevices(
    const Value: Boolean);
  begin
    if Value <> FFilterUnsupportedDevices then begin
      FFilterUnsupportedDevices := Value;
      EnumLineDevices;
    end;
  end;

  {begin .06 addition}                                                   {!!.06}
  procedure TApdCustomTapiDevice.Transfer(aNumber: string);
    {- Transfer a call to another line}
  var
    ReplyResult : Integer;
  begin
    { can only transfer if we're connected }
     if TapiState<>tsConnected then
       Exit;
     ReplyResult := WaitForReply(tuLineTransfer(Callhandle, @ANumber[1], 0));
     if ReplyResult < 0 then begin
      FFailCode := ReplyResult;
      if Assigned(FOnTapiFail) then
        PostMessage(FHandle, apw_TapiEventMessage, etTapiFail, 0)
      else
        TapiException(Self, ReplyResult);
    end;
  end;

  procedure TApdCustomTapiDevice.HoldCall;
    {-Place a call on hold}
  var
    ReplyResult : Integer;
  begin
    if TapiState<>tsConnected then
      Exit;
    ReplyResult := WaitForReply(tuLineHold(CallHandle));
     if ReplyResult < 0 then begin
      FFailCode := ReplyResult;
      if Assigned(FOnTapiFail) then
        PostMessage(FHandle, apw_TapiEventMessage, etTapiFail, 0)
      else
        TapiException(Self, ReplyResult);
    end;
  end;

  procedure TApdCustomTapiDevice.UnHoldCall;
  var
    ReplyResult : Integer;
  begin
    if TapiState<>tsConnected then
      Exit;
    ReplyResult := WaitForReply(tuLineUnHold(CallHandle));
     if ReplyResult < 0 then begin
      FFailCode := ReplyResult;
      if Assigned(FOnTapiFail) then
        PostMessage(FHandle, apw_TapiEventMessage, etTapiFail, 0)
      else
        TapiException(Self, ReplyResult);
    end;
  end;
  {end .06 addition}                                                     {!!.06}

end.


