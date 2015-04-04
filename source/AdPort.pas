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
 *  Stephen W Boyd          - Introduced a new log/trace state, tlAppendAndContinue
 *  September 2005            which appends the current contents of the trace /
 *                            log buffer to the given file and leaves the log /
 *                            trace in the state which it was in before setting
 *                            the state to tlAppendAndContinue.  This allows
 *                            you to flush the buffer to disk without having
 *                            to issue a Logging := tlAppend followed by
 *                            Logging := tlOn.  This also closes a timing window
 *                            where log entries could be lost between setting
 *                            Logging to tlAppend and then tlOn.
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                    ADPORT.PAS 5.00                    *}
{*********************************************************}
{* TApdComPort component                                 *}
{*********************************************************}

{
  This unit defines the TApdCustomComPort and TApdComPort components. Both
  of these are interfaces to the dispatcher, which is what does the actual
  port communication. The base dispatcher is defined in AwUser.pas, serial
  port dispatcher (Win32) is in AwWin32.pas, Winsock dispatcher is in
  AwWnSock.pas  The term dispatcher is used for the code that interfaces with
  the device.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+. $J+}

{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

{!!.02} { removed Win16 references }
unit AdPort;
  {-Delphi serial port component}

interface

uses
  Windows,
  SysUtils,
  Classes,
  Messages,
  Controls,
  Forms,
  OoMisc,
  AwUser,
{$IFNDEF UseAwWin32}
  LnsWin32,
{$ELSE}
  AwWin32,
{$ENDIF}
  AdExcept,
  AdSelCom;

type
  {Parity type}
  TParity = (pNone, pOdd, pEven, pMark, pSpace);

  {Activation procedure type}
  TActivationProcedure = function(Owner : TObject) : TApdBaseDispatcher;

  {Device layer types}
  TDeviceLayer = (dlWin32, dlWinsock);

  TDeviceLayers = set of TDeviceLayer;

  {Baud type}
  TBaudRate = Integer;

  {Tapi modes}
  TTapiMode = (tmNone, tmAuto, tmOn, tmOff);

  {Port state}
  TPortState = (psClosed, psShuttingDown, psOpen);

  {Hardware flow control types}
  THWFlowOptions = (
    hwfUseDTR,         {Use DTR for receive flow control}
    hwfUseRTS,         {Use RTS for receive flow control}
    hwfRequireDSR,     {Require DSR before transmitting}
    hwfRequireCTS);    {Require CTS before transmitting}

  THWFlowOptionSet = set of THWFlowOptions;

  {Software flow control types}
  TSWFlowOptions = (swfNone, swfReceive, swfTransmit, swfBoth);

  {For reporting flow states, note: no rcv hardware flow status is provided}
  TFlowControlState = (fcOff,        {No flow control is in use}
                       fcOn,         {Transmit blocked}
                       fcDsrHold,    {Transmit blocked by low DSR}
                       fcCtsHold,    {Transmit blocked by low CTS}
                       fcDcdHold,    {Transmit blocked by low DCD}
                       fcXOutHold,   {Transmit blocked by Xoff}
                       fcXInHold,    {Receive blocked by Xoff}
                       fcXBothHold); {Both are blocked by Xoff}

  {Tracing/logging states}
  TTraceLogState = (tlOff, tlOn, tlDump, tlAppend, tlClear, tlPause,        // SWB
                    tlAppendAndContinue);                                   // SWB

  {General trigger event handler}
  TTriggerEvent = procedure(CP : TObject;
                            Msg, TriggerHandle, Data : Word) of object;

  {Specific trigger event handlers}
  TTriggerAvailEvent = procedure(CP : TObject; Count : Word) of object;
  TTriggerDataEvent = procedure(CP : TObject; TriggerHandle : Word) of object;
  TTriggerStatusEvent = procedure(CP : TObject;
                                  TriggerHandle : Word) of object;
  TTriggerTimerEvent = procedure(CP : TObject; TriggerHandle : Word) of object;

  {Status event handlers}
  TTriggerLineErrorEvent   = procedure(CP : TObject;
                                       Error : Word;
                                       LineBreak : Boolean) of object;

  {WaitChar event handler}
  TWaitCharEvent = procedure(CP : TObject; C : AnsiChar) of object;


  {Port open/close callbacks}
  TPortCallback = procedure(CP : TObject; Opening : Boolean) of object;

  {Extended port open/closing/close callbacks}                           {!!.03}
  TApdCallbackType = (ctOpen, ctClosing, ctClosed);
  TPortCallbackEx = procedure(CP : TObject; CallbackType : TApdCallbackType) of object;

  {For keeping track of port users}
  PUserListEntry = ^TUserListEntry;
  TUserListEntry = record
    Handle     : THandle;
    OpenClose  : TPortCallback;
    OpenCloseEx: TPortCallbackEx;                                        {!!.03}
    IsEx       : Boolean;                                                {!!.03}
  end;

  TApThreadBoost = (tbNone, tbPlusOne, tbPlusTwo);

const
  {Parity strings}
  ParityName : array[TParity] of string[5] =
    ('None', 'Odd', 'Even', 'Mark', 'Space');

  {Property defaults}
  adpoDefDeviceLayer = dlWin32;
  adpoDefPromptForPort = True;
  adpoDefComNumber = 0;
  adpoDefBaudRt    = 19200;
  adpoDefParity    = pNone;
  adpoDefDatabits  = 8;
  adpoDefStopbits  = 1;
  adpoDefInSize    = 4096;
  adpoDefOutSize   = 4096;
  adpoDefOpen      = False;
  adpoDefAutoOpen  = True;
  adpoDefBaseAddress = 0;
  adpoDefTapiMode  = tmAuto;
  adpoDefDTR       = True;
  adpoDefRTS       = True;
  adpoDefTracing   = tlOff;
  adpoDefTraceSize = 10000;
  adpoDefTraceName = 'APRO.TRC';
  adpoDefTraceHex  = True;
  adpoDefTraceAllHex  = False;
  adpoDefLogging   = tlOff;
  adpoDefLogSize   = 10000;
  adpoDefLogName   = 'APRO.LOG';
  adpoDefLogHex    = True;
  adpoDefLogAllHex = False;
  adpoDefUseMSRShadow = True;
  adpoDefUseEventWord = True;
  adpoDefSWFlowOptions = swfNone;
  adpoDefXonChar   = #17;
  adpoDefXoffChar  = #19;
  adpoDefBufferFull = 0;
  adpoDefBufferResume = 0;
  adpoDefTriggerLength = 1;
  adpoDefCommNotificationLevel = 10;
  adpoDefRS485Mode = False;

type
  {Port component}
  TApdCustomComPort = class(TApdBaseComponent)
  private
    function GetLastWinError: Integer;                                      // SWB
  protected {private}
    {.Z+}
    {Internal stuff}
    Force            : Boolean;             {True to force property setting}
    PortState        : TPortState;          {State of the physical port/dispatcher}
    OpenPending      : Boolean;             {True if Open := True while shutting down}
    ForceOpen        : Boolean;             {Force open after loading}
    UserList         : TList;               {List of comport users}
    CopyTriggers     : Boolean;             {Copy triggers on open}
    SaveTriggerBuffer: TTriggerSave;        {Triggers to copy}
    BusyBeforeWait   : Boolean;             {True if EventBusy before Wait}
    WaitPrepped      : Boolean;             {True if PrepareWait called}
    fComWindow       : THandle;             {Hidden window handle}
    fCustomDispatcher: TActivationProcedure;{Custom device layer activation}
    FMasterTerminal  : TWinControl;         {The terminal that replies to requests}

    {Port info}
    FDeviceLayer     : TDeviceLayer;        {Device layer for this port}
    FDeviceLayers    : TDeviceLayers;
    FDispatcher      : TApdBaseDispatcher;  {Handle to comm object}
    FComNumber       : Word;                {Com1 - ComWhatever}
    FBaud            : Integer;             {Baud rate}
    FParity          : TParity;             {Parity}
    FDatabits        : Word;                {Data bits}
    FStopbits        : Word;                {Stop bits}
    FInSize          : Word;                {Input buffer size}
    FOutSize         : Word;                {Output buffer size}
    FOpen            : Boolean;             {True if the port is open}
    FPromptForPort   : Boolean;
			{True to display the com port selection dialog if no port is selected}
    FAutoOpen        : Boolean;             {True to do implicit opens}
    FCommNotificationLevel : Word;          {Comm notify level}
    FTapiCid         : Word;                {Cid from TAPI}
    FTapiMode        : TTapiMode;           {True if using TAPI}
    FRS485Mode       : Boolean;             {True if in RS485 mode}
    FThreadBoost     : TApThreadBoost;      {Boost for dispatcher threads}

    {Modem control/status}
    FDTR             : Boolean;             {DTR control state}
    FRTS             : Boolean;             {RTS control state}

    {Flow control}
    FBufferFull      : Word;                {Flow control cutoff}
    FBufferResume    : Word;                {Flow control resume}
    FHWFlowOptions   : THWFlowOptionSet;    {Hardware flow control}
    FSWFlowOptions   : TSWFlowOptions;      {Software flow control}
    FXOnChar         : AnsiChar;                {Xon character}
    FXOffChar        : AnsiChar;                {Xoff character}

    {Debugging}
    FTracing         : TTraceLogState;      {Controls Tracing state}
    FTraceSize       : Cardinal;            {Number of tracing entries}
    FTraceName       : string;              {Name of trace file}
    FTraceHex        : Boolean;             {True to dump trace non-printables in hex}
    FTraceAllHex     : Boolean;             {True to dump all trace chars in hex}
    FLogging         : TTraceLogState;      {Controls DispatchLogging state}
    FLogSize         : Cardinal;            {Size, in bytes, of log buffer}
    FLogName         : string;              {Name of log file}
    FLogHex          : Boolean;             {True to dump log non-printables in hex}
    FLogAllHex       : Boolean;             {True to dump all log chars in hex}

    {Options}
    FUseMSRShadow    : Boolean;             {True to use MSR shadow reg}
    FUseEventWord    : Boolean;             {True to use the EventWord}

    {Triggers}
    FTriggerLength   : Word;                {Number of bytes for avail trigger}

    FOnTrigger       : TTriggerEvent;       {All-encompassing event handler}
    FOnTriggerAvail  : TTriggerAvailEvent;  {APW_TRIGGERAVAIL events}
    FOnTriggerData   : TTriggerDataEvent;   {APW_TRIGGERDATA events}
    FOnTriggerStatus : TTriggerStatusEvent; {APW_TRIGGERSTATUS events}
    FOnTriggerTimer  : TTriggerTimerEvent;  {APW_TRIGGERTIMER events}
    FOnTriggerLineError   : TTriggerLineErrorEvent;  {Got line error}
    FOnTriggerModemStatus : TNotifyEvent;   {Got modem status change}
    FOnTriggerOutbuffFree : TNotifyEvent;   {Outbuff free above mark}
    FOnTriggerOutbuffUsed : TNotifyEvent;   {Outbuff used above mark}
    FOnTriggerOutSent     : TNotifyEvent;   {Data was transmitted}

    FOnPortOpen      : TNotifyEvent;        {Port just opened}
    FOnPortClose     : TNotifyEvent;        {Port just closed}
    FOnWaitChar      : TWaitCharEvent;      {Received char during wait}

    {Property read/write methods}
    procedure SetDeviceLayer(const NewDevice : TDeviceLayer);
    procedure SetComNumber(const NewNumber : Word);
    procedure SetBaud(const NewBaud : Integer);
    procedure SetParity(const NewParity : TParity);
    procedure SetDatabits(const NewBits : Word);
    procedure SetStopbits(const NewBits : Word);
    procedure SetInSize(const NewSize : Word);
    procedure SetOutSize(const NewSize : Word);
    procedure SetTracing(const NewState : TTraceLogState);
    procedure SetTraceSize(const NewSize : Cardinal);
    procedure SetLogging(const NewState : TTraceLogState);
    procedure SetLogSize(const NewSize : Cardinal);
    procedure SetOpen(const Enable : Boolean);
    procedure SetHWFlowOptions(const NewOpts : THWFlowOptionSet);
    function GetFlowState : TFlowControlState;
    procedure SetSWFlowOptions(const NewOpts : TSWFlowOptions);
    procedure SetXonChar(const NewChar : AnsiChar);
    procedure SetXoffChar(const NewChar : AnsiChar);
    procedure SetBufferFull(const NewFull : Word);
    procedure SetBufferResume(const NewResume : Word);
    procedure SetTriggerLength(const NewLength : Word);
    procedure SetDTR(const NewDTR : Boolean);
    procedure SetRTS(const NewRTS : Boolean);

    {Trigger write methods}
    procedure SetOnTrigger(const Value : TTriggerEvent);
    procedure SetOnTriggerAvail(const Value : TTriggerAvailEvent);
    procedure SetOnTriggerData(const Value : TTriggerDataEvent);
    procedure SetOnTriggerStatus(const Value : TTriggerStatusEvent);
    procedure SetOnTriggerTimer(const Value : TTriggerTimerEvent);
    procedure SetOnTriggerLineError(const Value : TTriggerLineErrorEvent);
    procedure SetOnTriggerModemStatus(const Value : TNotifyEvent);
    procedure SetOnTriggerOutbuffFree(const Value : TNotifyEvent);
    procedure SetOnTriggerOutbuffUsed(const Value : TNotifyEvent);
    procedure SetOnTriggerOutSent(const Value : TNotifyEvent);

    function GetBaseAddress : Word;
    function GetDispatcher : TApdBaseDispatcher;
    function GetModemStatus : Byte;
    function GetDSR : Boolean;
    function GetCTS : Boolean;
    function GetRI : Boolean;
    function GetDCD : Boolean;
    function GetDeltaDSR : Boolean;
    function GetDeltaCTS : Boolean;
    function GetDeltaRI : Boolean;
    function GetDeltaDCD : Boolean;
    function GetLineError : Word;
    function GetLineBreak : Boolean;
    function GetInBuffUsed : Word;
    function GetInBuffFree : Word;
    function GetOutBuffUsed : Word;
    function GetOutBuffFree : Word;
    procedure SetUseEventWord(NewUse : Boolean);
    procedure SetCommNotificationLevel(NewLevel : Word);
    procedure SetRS485Mode(NewMode : Boolean);
    procedure SetBaseAddress(NewBaseAddress : Word);
    procedure SetThreadBoost(NewBoost : TApThreadBoost);

  protected
    {Misc}
    function ActivateDeviceLayer : TApdBaseDispatcher; virtual;
    procedure DeviceLayerChanged; virtual;
    function InitializePort : integer; virtual;
    procedure Loaded; override;
    procedure RegisterComPort(Enabling : Boolean); virtual;
    procedure ValidateComport; virtual;
    procedure SetUseMSRShadow(NewUse : Boolean); virtual;

    {Trigger event methods}
    procedure Trigger(Msg, TriggerHandle, Data : Word); virtual;
    procedure TriggerAvail(Count : Word); virtual;
    procedure TriggerData(TriggerHandle : Word); virtual;
    procedure TriggerStatus(TriggerHandle : Word); virtual;
    procedure TriggerTimer(TriggerHandle : Word); virtual;
    procedure UpdateHandlerFlag; virtual;

    {Port open/close/change event methods}
    procedure PortOpen; dynamic;
    procedure PortClose; dynamic;
    procedure PortClosing; dynamic;                                      {!!.03}

    {Status trigger methods}
    procedure TriggerLineError(const Error : Word;
                               const LineBreak : Boolean); virtual;
    procedure TriggerModemStatus; virtual;
    procedure TriggerOutbuffFree; virtual;
    procedure TriggerOutbuffUsed; virtual;
    procedure TriggerOutSent; virtual;

    {Wait trigger method}
    procedure WaitChar(C : AnsiChar); virtual;

    {Tracing}
    procedure InitTracing(const NumEntries : Cardinal);
    procedure DumpTrace(const FName : String; const InHex : Boolean);
    procedure AppendTrace(const FName : String;                        // SWB
                          const InHex : Boolean;                            // SWB
                          const NewState : TTraceLogState);                 // SWB
    procedure ClearTracing;
    procedure AbortTracing;
    procedure StartTracing;
    procedure StopTracing;

    {DispatchLogging}
    procedure InitLogging(const Size : Cardinal);
    procedure DumpLog(const FName : string; const InHex : Boolean);// --sm check shortstring to sting
    procedure AppendLog(const FName : string;  // --sm check shortstring to sting                        // SWB
                        const InHex : Boolean;                              // SWB
                        const NewState : TTraceLogState);                   // SWB
    procedure ClearLogging;
    procedure AbortLogging;
    procedure StartLogging;
    procedure StopLogging;

  public
    OverrideLine     : Boolean;     {True to override line parms}
    {Creation/destruction}
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdComPort component}
    destructor Destroy; override;
      {-Destroy a TApdComPort component}

    {General}
    procedure InitPort; dynamic;
      {-Physically open the serial port}
    procedure DonePort; virtual;
      {-Physically close the serial port}
    procedure Assign(Source: TPersistent); override;
      {-Assign fields from TApdComPort object specified by Source}
    procedure ForcePortOpen;
      {-Force the port open after it is loaded}
    procedure SendBreak(Ticks : Word; Yield : Boolean);
      {-Send a line break of ticks duration}
    procedure SetBreak(BreakOn : Boolean);
      {-Sets or clears line break condition}

    {.Z-}
    procedure RegisterUser(const H : THandle);
      {-Register a TApdComPort user to receive PortOpen/PortClose events}
    procedure RegisterUserEx(const H : THandle);                         {!!.03}
      {-Register a TApdComPort user to receive open/closing/close events}
    procedure RegisterUserCallback(CallBack : TPortCallback);
      {-Register a TApdComPort user to receive callbacks}
    procedure RegisterUserCallbackEx(CallBackEx : TPortCallbackEx);      {!!.03}
      {-Register a TApdComPort user to receive extended callbacks}
    procedure DeregisterUser(const H : THandle);
      {-Deregister a TApdComPort user from receiving PortOpen/PortClose events}
    procedure DeregisterUserCallback(CallBack : TPortCallback);
      {-Deregister a TApdComPort user callback}
    procedure DeregisterUserCallbackEx(CallBackEx : TPortCallbackEx);    {!!.03}
      {-Deregister a TApdComPort user callback}

    procedure ProcessCommunications; virtual;
      {-Call the internal dispatcher}
    procedure FlushInBuffer;
      {-Discard the contents of the input buffer}
    procedure FlushOutBuffer;
      {-Discard the contents of the output buffer}

    {Trigger managment}
    function AddDataTrigger(const Data : ShortString;
                            const IgnoreCase : Boolean) : Word;
      {-Add a data trigger}
    function AddTimerTrigger : Word;
      {-Add a timer trigger}
    function AddStatusTrigger(const SType : Word) : Word;
      {-Add a status trigger}
    procedure RemoveTrigger(const Handle : Word);
      {-Remove a trigger}
    procedure RemoveAllTriggers;
      {-Remove all triggers}
    procedure SetTimerTrigger(const Handle : Word; const Ticks : Integer;
                              const Activate : Boolean);
      {-Activate or deactivate a timer trigger}
    procedure SetStatusTrigger(const Handle : Word; const Value : Word;
                               const Activate : Boolean);
      {-Activate or deactivate a status trigger}

    {I/O}
    function CharReady : Boolean;
      {-Return True if at least one character is in the input buffer}
    function PeekChar(const Count : Word) : AnsiChar;
      {-Return a received character other than the next one}
    function GetChar : AnsiChar;
      {-Return the next received character}
    procedure PeekBlock(var Block; const Len : Word);
      {-Return a block of data other than the next block}

    procedure GetBlock(var Block; const Len : Word);
      {-Return the next block of data}
    procedure PutChar(const C : AnsiChar);
      {-Add C to the output buffer}
    procedure PutString(const S : string); overload;
    procedure PutString(const S : AnsiString); overload;
      {-Add S to the output buffer}
    function PutBlock(const Block; const Len : Word) : Integer;
      {-Add Block to the output buffer}

    {Waits}
    function CheckForString(var Index : Byte; C : AnsiChar;
                            const S : AnsiString;
                            IgnoreCase : Boolean) : Boolean;
      {-Compare C against a sequence of chars, looking for S}
    function WaitForString(const S : AnsiString;
                           const Timeout : Integer;
                           const Yield, IgnoreCase : Boolean) : Boolean;
      {-Wait for S}
    function WaitForMultiString(const S : AnsiString; const Timeout : Integer;
                                const Yield, IgnoreCase : Boolean;
                                const SepChar : AnsiChar) : Integer;
      {-Wait for S, which contains several substrings separated by ^}
    procedure PrepareWait;
      {-Set EventBusy true to prevent triggers}

    property ComNumber : Word
      read FComNumber write SetComNumber default adpoDefComNumber;
    property CustomDispatcher : TActivationProcedure
      read fCustomDispatcher write fCustomDispatcher;
    property DeviceLayer : TDeviceLayer
      read FDeviceLayer write SetDeviceLayer default adpoDefDeviceLayer;
    property ComWindow : THandle
      read fComWindow;
    property Baud : Integer
      read FBaud write SetBaud default adpoDefBaudRt;
    property Parity : TParity
      read FParity write SetParity default adpoDefParity;
    property PromptForPort : Boolean
      read FPromptForPort write FPromptForPort
      default adpoDefPromptForPort;
    property DataBits : Word
      read FDatabits write SetDatabits default adpoDefDatabits;
    property StopBits : Word
      read FStopbits write SetStopbits default adpoDefStopbits;

    {Miscellaneous port properties}
    property InSize : Word
      read FInSize write SetInSize default adpoDefInSize;
    property OutSize : Word
      read FOutSize write SetOutSize default adpoDefOutSize;
    property Open : Boolean
      read FOpen write SetOpen default adpoDefOpen;
    property AutoOpen : Boolean
      read FAutoOpen write FAutoOpen default adpoDefAutoOpen;
    property CommNotificationLevel : Word
      read FCommNotificationLevel write SetCommNotificationLevel
      default adpoDefCommNotificationLevel;
    property TapiMode : TTapiMode
      read FTapiMode write FTapiMode default adpoDefTapiMode;
    property TapiCid : Word
      read FTapiCid write FTapiCid;
    property RS485Mode : Boolean
      read FRS485Mode write SetRS485Mode default adpoDefRS485Mode;
    property BaseAddress : Word
      read GetBaseAddress write SetBaseAddress
      default adpoDefBaseAddress;
    property ThreadBoost : TApThreadBoost
      read FThreadBoost write SetThreadBoost;
    property MasterTerminal : TWinControl
      read FMasterTerminal write FMasterTerminal;

    {Modem control/status}
    property DTR : Boolean
      read FDTR write SetDTR default adpoDefDTR;
    property RTS : Boolean
      read FRTS write SetRTS default adpoDefRTS;

    {Flow control properties}
    property HWFlowOptions : THWFlowOptionSet
      read FHWFlowOptions write SetHWFlowOptions default [];
    property FlowState : TFlowControlState
      read GetFlowState;
    property SWFlowOptions : TSWFlowOptions
      read FSWFlowOptions write SetSWFlowOptions default adpoDefSWFlowOptions;
    property XOnChar : AnsiChar
      read FXonChar write SetXonChar default adpoDefXOnChar;
    property XOffChar : AnsiChar
      read FXOffChar write SetXoffChar default adpoDefXOffChar;
    property BufferFull : Word
      read FBufferFull write SetBufferFull default adpoDefBufferFull;
    property BufferResume : Word
      read FBufferResume write SetBufferResume default adpoDefBufferResume;

    {Debugging}
    property Tracing : TTraceLogState
      read FTracing write SetTracing default adpoDefTracing;
    property TraceSize : Cardinal
      read FTraceSize write SetTraceSize default adpoDefTraceSize;
    property TraceName : string
      read FTraceName write FTraceName;
    property TraceHex : Boolean
      read FTraceHex write FTraceHex default adpoDefTraceHex;
    property TraceAllHex : Boolean
      read FTraceAllHex write FTraceAllHex default adpoDefTraceAllHex;

    property Logging : TTraceLogState
      read FLogging write SetLogging default adpoDefLogging;
    property LogSize : Cardinal
      read FLogSize write SetLogSize default adpoDefLogSize;
    property LogName : string
      read FLogName write FLogName;
    property LogHex : Boolean
      read FLogHex write FLogHex default adpoDefLogHex;
    property LogAllHex : Boolean
      read FLogAllHex write FLogAllHex default adpoDefLogAllHex;

    {Options}
    property UseMSRShadow : Boolean
      read FUseMSRShadow write SetUseMSRShadow default adpoDefUseMSRShadow;
    property UseEventWord : Boolean
      read FUseEventWord write SetUseEventWord default adpoDefUseEventWord;

    {Tracing}
    procedure AddTraceEntry(const CurEntry, CurCh : AnsiChar);
      {-Add an entry to the trace buffer}
    procedure AddStringToLog(S : Ansistring);
      {-Add a string to the current LOG file}

    {Trigger events}
    property TriggerLength : Word
      read FTriggerLength write SetTriggerLength default adpoDefTriggerLength;
    property OnTrigger : TTriggerEvent
      read FOnTrigger write SetOnTrigger;
    property OnTriggerAvail : TTriggerAvailEvent
      read FOnTriggerAvail write SetOnTriggerAvail;
    property OnTriggerData : TTriggerDataEvent
      read FOnTriggerData write SetOnTriggerData;
    property OnTriggerStatus : TTriggerStatusEvent
      read FOnTriggerStatus write SetOnTriggerStatus;
    property OnTriggerTimer : TTriggerTimerEvent
      read FOnTriggerTimer write SetOnTriggerTimer;

    {Port open/close/change events}
    property OnPortOpen : TNotifyEvent
      read FOnPortOpen write FOnPortOpen;
    property OnPortClose : TNotifyEvent
      read FOnPortClose write FOnPortClose;

    {Status events}
    property OnTriggerLineError : TTriggerLineErrorEvent
      read FOnTriggerLineError write SetOnTriggerLineError;
    property OnTriggerModemStatus : TNotifyEvent
      read FOnTriggerModemStatus write SetOnTriggerModemStatus;
    property OnTriggerOutbuffFree : TNotifyEvent
      read FOnTriggerOutbuffFree write SetOnTriggerOutbuffFree;
    property OnTriggerOutbuffUsed : TNotifyEvent
      read FOnTriggerOutbuffUsed write SetOnTriggerOutbuffUsed;
    property OnTriggerOutSent : TNotifyEvent
      read FOnTriggerOutSent write SetOnTriggerOutSent;

    {WaitChar event}
    property OnWaitChar : TWaitCharEvent
      read FOnWaitchar write FOnWaitChar;

    {I/O properties}
    property Output : AnsiString
      write PutString;
    property OutputUni : string write PutString;

    {TComHandle, read only}
    property Dispatcher : TApdBaseDispatcher
      read GetDispatcher;
    function ValidDispatcher : TApdBaseDispatcher;

    {Modem status, read only}
    property ModemStatus : Byte
      read GetModemStatus;
    property DSR : Boolean
      read GetDSR;
    property CTS : Boolean
      read GetCTS;
    property RI : Boolean
      read GetRI;
    property DCD : Boolean
      read GetDCD;
    property DeltaDSR : Boolean
      read GetDeltaDSR;
    property DeltaCTS : Boolean
      read GetDeltaCTS;
    property DeltaRI : Boolean
      read GetDeltaRI;
    property DeltaDCD : Boolean
      read GetDeltaDCD;

    {Line errors}
    property LineError : Word
      read GetLineError;
    property LineBreak : Boolean
      read GetLineBreak;

    {Buffer info, readonly}
    property InBuffUsed : Word
      read GetInBuffUsed;
    property InBuffFree : Word
      read GetInBuffFree;
    property OutBuffUsed : Word
      read GetOutBuffUsed;
    property OutBuffFree : Word
      read GetOutBuffFree;

    property LastWinError: Integer read GetLastWinError;                    // SWB
  end;

  {Port component}
  TApdComPort = class(TApdCustomComPort)
  published
    property DeviceLayer;
    property ComNumber;
    property Baud;
    property PromptForPort;
    property Parity;
    property DataBits;
    property StopBits;
    property InSize;
    property OutSize;
    property AutoOpen;
    property Open;
    property DTR;
    property RTS;
    property HWFlowOptions;
    property SWFlowOptions;
    property XOnChar;
    property XOffChar;
    property BufferFull;
    property BufferResume;
    property Tracing;
    property TraceSize;
    property TraceName;
    property TraceHex;
    property TraceAllHex;
    property Logging;
    property LogSize;
    property LogName;
    property LogHex;
    property LogAllHex;
    property UseMSRShadow;
    property UseEventWord;
    property CommNotificationLevel;
    property TapiMode;
    property RS485Mode;
    property OnPortClose;
    property OnPortOpen;
    property OnTrigger;
    property OnTriggerAvail;
    property OnTriggerData;
    property OnTriggerStatus;
    property OnTriggerTimer;
    property OnTriggerLineError;
    property OnTriggerModemStatus;
    property OnTriggerOutbuffFree;
    property OnTriggerOutbuffUsed;
    property OnTriggerOutSent;
    property Tag;
  end;

  function ComName(const ComNumber : Word) : string;
  function SearchComPort(const C : TComponent) : TApdCustomComPort;

implementation

uses
  Types, AnsiStrings;

const
  ComWindowClass = 'awComWindow';

  {Main trigger handler}

  function ComWindowProc(hWindow : TApdHwnd; Msg, wParam : Word;
                         lParam : Integer) : Integer;
                         stdcall; export;
    {-Receives all triggers, dispatches to event handlers}
  type
    lParamCast = record
      Data       : Word;
      Dispatcher : Word;
    end;
  var
    LP         : lParamCast absolute lParam;
    TrigHandle : Word absolute wParam;
    Count      : Word absolute wParam;
    CP         : TApdCustomComPort;
    D          : Pointer;
  begin
    case Msg of
    APW_CLOSEPENDING, APW_TRIGGERAVAIL, APW_TRIGGERDATA,
    APW_TRIGGERSTATUS, APW_TRIGGERTIMER : ;
    else
      ComWindowProc := DefWindowProc(hWindow, Msg, wParam, lParam);
      exit;
    end;
    LockPortList;
    try
      ComWindowProc := ecOK;
      if (PortList <> nil) and (LP.Dispatcher < PortList.Count) then begin
        D := PortList[LP.Dispatcher];
        if D <> nil then
          CP := TApdCustomComPort(TApdBaseDispatcher(D).Owner)
        else
          CP := nil;
        if Assigned(CP) then with CP do begin
          try
            if Msg = APW_TRIGGERAVAIL then
              Trigger(Msg, TrigHandle, Count)
            else
              Trigger(Msg, TrigHandle, LP.Data);
            case Msg of
              APW_CLOSEPENDING :
                begin
                  if FDispatcher.Active then begin
                    PostMessage(FComWindow,APW_CLOSEPENDING,0,lparam);
                  end else begin
                    {Get rid of the trigger handler}
                    RegisterComPort(False);
                    FDispatcher.Free;
                    FDispatcher := nil;
                    PortState := psClosed;
                    FOpen := False;                                      {!!.02}
                    if OpenPending then begin
                      InitPort;
                      OpenPending := False;
                    end;
                  end;
                end;
              APW_TRIGGERAVAIL :
                TriggerAvail(Count);
              APW_TRIGGERDATA :
                TriggerData(TrigHandle);
              APW_TRIGGERSTATUS :
                begin
                  TriggerStatus(TrigHandle);
                  case Dispatcher.ClassifyStatusTrigger(TrigHandle) of
                    stModem       : TriggerModemStatus;
                    stLine        : TriggerLineError(LineError, LineBreak);
                    stOutBuffFree : TriggerOutbuffFree;
                    stOutBuffUsed : TriggerOutbuffUsed;
                    stOutSent     : TriggerOutSent;
                  end;
                end;
              APW_TRIGGERTIMER :
                TriggerTimer(TrigHandle);
            end;
          except
            if GetCurrentThreadID = MainThreadID then
              Application.HandleException(nil);
          end;
        end;
      end;
    finally
      UnlockPortList;
    end;
  end;

{Misc}

var
  Registered : Boolean = False;

  procedure RegisterComWindow;
    {-Make sure the comwindow class is registered}
  var
    XClass: TWndClass;
  begin
    if Registered then
      Exit;
    Registered := True;

    with XClass do begin
      Style         := 0;
      lpfnWndProc   := @ComWindowProc;
      cbClsExtra    := 0;
      cbWndExtra    := SizeOf(Pointer);
      if ModuleIsLib and not ModuleIsPackage then
        { we're in a DLL, not a package }
        hInstance   := SysInit.hInstance
      else
        { we're a package or exe }
        hInstance   := System.MainInstance;
      hIcon         := 0;
      hCursor       := 0;
      hbrBackground := 0;
      lpszMenuName  := nil;
      lpszClassName := ComWindowClass;
    end;
    Windows.RegisterClass(XClass);
  end;

  function TApdCustomComPort.ValidDispatcher : TApdBaseDispatcher;
    {- return the current dispatcher object. Raise an exception if NIL }
  begin
    if Dispatcher = nil then
      CheckException(Self,ecCommNotOpen);
    Result := Dispatcher;
  end;

  procedure TApdCustomComPort.SetDeviceLayer(const NewDevice : TDeviceLayer);
    {-Set a new device layer, ignore if port is open}
  begin
    if (NewDevice <> FDeviceLayer) and (PortState = psClosed) then
      if NewDevice in FDeviceLayers then begin
        FDeviceLayer := NewDevice;
        DeviceLayerChanged;
      end;
  end;

  procedure TApdCustomComPort.SetComNumber(const NewNumber : Word);
    {-Set a new comnumber, close the old port if open}
  var
    WasOpen : Boolean;
    OldTracing : TTraceLogState;
    OldLogging : TTraceLogState;
  begin
    if FComNumber <> NewNumber then begin
      WasOpen := (PortState = psOpen);
      OldTracing := tlOff;
      OldLogging := tlOff;
      if (PortState = psOpen) then begin
        Dispatcher.SaveTriggers(SaveTriggerBuffer);
        OldTracing := Tracing;
        OldLogging := Logging;
        Open := False;
      end;
      FComNumber := NewNumber;
      if WasOpen then begin
        Tracing := OldTracing;
        Logging := OldLogging;
        Open := True;
        Dispatcher.RestoreTriggers(SaveTriggerBuffer);
      end;
    end;
  end;

  procedure TApdCustomComPort.SetBaud(const NewBaud : Integer);
    {-Set a new baud rate}
  begin
    if NewBaud <> FBaud then begin
      FBaud := NewBaud;
      if (PortState = psOpen) then
        CheckException(Self,
          Dispatcher.SetLine(NewBaud, Ord(Parity), Databits, Stopbits));
    end;
  end;

  procedure TApdCustomComPort.SetParity(const NewParity : TParity);
    {-Set new parity}
  begin
    if NewParity <> FParity then begin
      FParity := NewParity;
      if (PortState = psOpen) then
        CheckException(Self,
          Dispatcher.SetLine(Baud, Ord(FParity), Databits, Stopbits));
    end;
  end;

  procedure TApdCustomComPort.SetDatabits(const NewBits : Word);
    {-Set new databits}
  begin
    if NewBits <> FDatabits then begin
      FDatabits := NewBits;
      if (PortState = psOpen) then
        CheckException(Self,
          Dispatcher.SetLine(Baud, Ord(Parity), FDatabits, Stopbits));
    end;
  end;

  procedure TApdCustomComPort.SetStopbits(const NewBits : Word);
    {-Set new stop bits}
  begin
    if NewBits <> FStopbits then begin
      FStopbits := NewBits;
      if (PortState = psOpen) then
        CheckException(Self,
          Dispatcher.SetLine(Baud, Ord(Parity), Databits, FStopbits));
    end;
  end;

  procedure TApdCustomComPort.SetInSize(const NewSize : Word);
    {-Set new insize, requires re-opening port if port was open}
  begin
    if NewSize <> FInSize then begin
      FInSize := NewSize;
      if (PortState = psOpen) then
        Dispatcher.SetCommBuffers(NewSize, OutSize);
    end;
  end;

  procedure TApdCustomComPort.SetOutSize(const NewSize : Word);
    {-Set new outsize, requires re-opening port if port was open}
  begin
    if NewSize <> FOutSize then begin
      FOutSize := NewSize;
      if (PortState = psOpen) then
        Dispatcher.SetCommBuffers(InSize, NewSize);
    end;
  end;

  procedure TApdCustomComPort.SetTracing(const NewState : TTraceLogState);
    {-Set Tracing state, FTracing is modified by called methods}
  begin
    if (FTracing <> NewState) or Force then begin
      if (PortState = psOpen) then begin
        {Port is open -- do it}
        case NewState of
          tlOff    : if (FTracing = tlOn) or (FTracing = tlPause) then
                       AbortTracing;
          tlOn     : if FTracing = tlPause then
                       StartTracing
                     else
                       InitTracing(FTraceSize);
          tlDump   : if (FTracing = tlOn) or (FTracing = tlPause) then begin
                       StartTracing;
                       DumpTrace(FTraceName, FTraceHex);
                     end;
          tlAppend : if (FTracing = tlOn) or (FTracing = tlPause) then begin
                       StartTracing;
                       AppendTrace(FTraceName, FTraceHex, tlOff);           // SWB
                     end;
          tlAppendAndContinue :                                             // SWB
                     if (FTracing = tlOn) or (FTracing = tlPause) then begin// SWB
                       StartTracing;                                        // SWB
                       AppendTrace(FTraceName, FTraceHex, FTracing);        // SWB
                     end;                                                   // SWB
          tlPause  : if (FTracing = tlOn) then
                       StopTracing;
          tlClear  : if (FTracing = tlOn) or (FTracing = tlPause) then
                       ClearTracing;
        end;
      end else begin
        {Port is closed, only acceptable values are tlOff and tlOn}
        case NewState of
          tlOff, tlOn : FTracing := NewState;
          else          FTracing := tlOff;
        end;
      end;
    end;
  end;

  procedure TApdCustomComPort.SetTraceSize(const NewSize : Cardinal);
    {-Set trace size}
  var
    OldState : TTraceLogState;
  begin
    if NewSize <> FTraceSize then begin
      if NewSize > HighestTrace then
        FTraceSize := HighestTrace
      else
        FTraceSize := NewSize;
      if (PortState = psOpen) and ((FTracing = tlOn) or (FTracing = tlPause)) then begin
        {Trace file is open: abort, then restart to get new size}
        OldState := Tracing;
        AbortTracing;
        Tracing := OldState;
      end;
    end;
  end;

  procedure TApdCustomComPort.SetLogging(const NewState : TTraceLogState);
    {-Set Logging state, FLogging is modified by called methods}
  begin
    if (FLogging <> NewState) or Force then begin
      if (PortState = psOpen) then begin
        case NewState of
          tlOff    : if (FLogging = tlOn) or (FLogging = tlPause) then
                       AbortLogging;
          tlOn     : if FLogging = tlPause then
                       StartLogging
                     else
                       InitLogging(FLogSize);
          tlDump   : if (FLogging = tlOn) or (FLogging = tlPause) then begin
                       StartLogging;
                       DumpLog(FLogName, FLogHex);
                     end;
          tlAppend : if (FLogging = tlOn) or (FLogging = tlPause) then begin
                       StartLogging;
                       AppendLog(FLogName, FLogHex, tlOff);                 // SWB
                     end;
          tlAppendAndContinue :                                             // SWB
                     if (FLogging = tlOn) or (FLogging = tlPause) then begin// SWB
                       StartLogging;                                        // SWB
                       AppendLog(FLogName, FLogHex, FLogging);              // SWB
                     end;                                                   // SWB
          tlPause  : if (FLogging = tlOn) then
                       StopLogging;
          tlClear  : if (FLogging = tlOn) or (FLogging = tlPause) then
                       ClearLogging;
        end;
      end else begin
        {Port is closed, only acceptable values are tlOff and tlOn}
        case NewState of
          tlOff, tlOn : FLogging := NewState;
          else          FLogging := tlOff;
        end;
      end;
    end;
  end;

  procedure TApdCustomComPort.SetLogSize(const NewSize : Cardinal);
    {-Set log size}
  var
    OldState : TTraceLogState;
  begin
    if NewSize <> FLogSize then begin
      if NewSize > MaxDLogQueueSize then
        FLogSize := MaxDLogQueueSize
      else
        FLogSize := NewSize;
      if (PortState = psOpen) and ((FLogging = tlOn) or (FLogging = tlPause)) then begin
        {Log file is open: abort, then restart to get new size}
        OldState := FLogging;
        AbortLogging;
        Logging := OldState;
      end;
    end;
  end;

  procedure TApdCustomComPort.SetOpen(const Enable : Boolean);
    {-Open/close the port}
  begin
    if FOpen <> Enable then begin
      if not (csDesigning in ComponentState) and
         not (csLoading in ComponentState) then begin
        if Enable then begin
          if (PortState = psClosed) then
            { open the port }
            InitPort
          else
            { wait until we're closed }
            OpenPending := True;
        end else
          { close the port }
          DonePort;
      end else begin
        { we're loading or designing, just set a flag }
        FOpen := Enable;
        if Enable then
          ForceOpen := True;
      end;
    end;
  end;

  procedure TApdCustomComPort.SetHWFlowOptions(const NewOpts : THWFlowOptionSet);
    {-Set hardware flow options}
  const
    UseDTR : array[Boolean] of Word = (0, hfUseDTR);
    UseRTS : array[Boolean] of Word = (0, hfUseRTS);
    RequireDSR : array[Boolean] of Word = (0, hfRequireDSR);
    RequireCTS : array[Boolean] of Word = (0, hfRequireCTS);
  var
    Opts : Word;
  begin
    if (FHWFlowOptions <> NewOpts) or Force then begin
      Opts := UseDTR[hwfUseDTR in NewOpts] +
              UseRTS[hwfUseRTS in NewOpts] +
              RequireDSR[hwfRequireDSR in NewOpts] +
              RequireCTS[hwfRequireCTS in NewOpts];

      {Validate bufferfull and bufferresume if opts not zero}
      if Opts <> 0 then begin
        if (BufferFull = 0) or (BufferFull > InSize) then
          FBufferFull := Trunc(InSize * 0.9);
        if (BufferResume = 0) or (BufferResume > BufferFull) then
          FBufferResume := Trunc(InSize * 0.1);
      end;

      if (PortState = psOpen) then begin
        CheckException(Self, Dispatcher.HWFlowOptions(FBufferFull, FBufferResume, Opts))
      end;
      FHWFlowOptions := NewOpts;
      {Force RS485 mode off if using RTS/CTS flow control}
      if (hwfUseRTS in NewOpts) or
         (hwfRequireCTS in NewOpts) then
        RS485Mode := False;
    end;
  end;

  function TApdCustomComPort.GetFlowState : TFlowControlState;
    {-Return the current state of flow control}
  begin
    if (PortState <> psShuttingDown) then begin
      Result := TFlowControlState(Pred(CheckException(Self,
        ValidDispatcher.HWFlowState)));
      if Result = fcOff then
        Result := TFlowControlState(Pred(CheckException(Self,
          Dispatcher.SWFlowState)));
    end else begin
      Result := fcOff;
    end;
  end;

  procedure TApdCustomComPort.SetSWFlowOptions(const NewOpts : TSWFlowOptions);
  var
    Opts : Word;
  begin
    if (FSWFlowOptions <> NewOpts) or Force then begin
      if NewOpts = swfBoth then
        Opts := sfTransmitFlow + sfReceiveFlow
      else if NewOpts = swfTransmit then
        Opts := sfTransmitFlow
      else if NewOpts = swfReceive then
        Opts := sfReceiveFlow
      else
        Opts := 0;

      {Validate bufferfull and bufferresume if opts not zero}
      if Opts <> 0 then begin
        if (BufferFull = 0) or (BufferFull > InSize) then
          FBufferFull := Trunc(InSize * 0.75);
        if (BufferResume = 0) or (BufferResume > BufferFull) then
          FBufferResume := Trunc(InSize * 0.25);
      end;

      if (PortState = psOpen) then begin
        if Opts <> 0 then
          CheckException(Self,
            Dispatcher.SWFlowEnable(FBufferFull, FBufferResume, Opts))
        else
          CheckException(Self, Dispatcher.SWFlowDisable);
      end;
      FSWFlowOptions := NewOpts;
    end;
  end;

  procedure TApdCustomComPort.SetXonChar(const NewChar : AnsiChar);
    {-Set new xon character}
  begin
    if (NewChar <> FXOnChar) or Force then begin
      FXOnChar := NewChar;
      if (PortState = psOpen) then
        CheckException(Self, Dispatcher.SWFlowChars(FXOnChar, FXOffChar));
    end;
  end;

  procedure TApdCustomComPort.SetXoffChar(const NewChar : AnsiChar);
    {-Set new xoff character}
  begin
    if (NewChar <> FXOffChar) or Force then begin
      FXOffChar := NewChar;
      if (PortState = psOpen) then
        CheckException(Self, Dispatcher.SWFlowChars(FXOnChar, FXOffChar));
    end;
  end;

  procedure TApdCustomComPort.SetBufferFull(const NewFull : Word);
    {-Set buffer full mark}
  var
    SaveForce : Boolean;
  begin
    if (NewFull <> FBufferFull) or Force then begin
      if NewFull <= InSize then
        FBufferFull := NewFull
      else
        FBufferFull := Trunc(NewFull * 0.9);
      SaveForce := Force;
      Force := True;
      SetHWFlowOptions(HWFlowOptions);
      SetSWFlowOptions(SWFlowOptions);
      Force := SaveForce;
    end;
  end;

  procedure TApdCustomComPort.SetBufferResume(const NewResume : Word);
    {-Set buffer resume mark}
  var
    SaveForce : Boolean;
  begin
    if (NewResume <> FBufferResume) or Force then begin
      if NewResume > FBufferFull then
        FBufferResume := Trunc(FBufferFull * 0.1)
      else
        FBufferResume := NewResume;
      SaveForce := Force;
      Force := True;
      SetHWFlowOptions(HWFlowOptions);
      SetSWFlowOptions(SWFlowOptions);
      Force := SaveForce;
    end;
  end;

  procedure TApdCustomComPort.SetDTR(const NewDTR : Boolean);
    {-Set a new DTR value}
  begin
    if (NewDTR <> FDTR) or Force then begin
      if (PortState = psOpen) then begin
        if CheckException(Self, Dispatcher.SetDTR(NewDTR)) = ecOK then
          FDTR := NewDTR;
      end else begin
        FDTR := NewDTR;
      end;
    end;
  end;

  procedure TApdCustomComPort.SetRTS(const NewRTS : Boolean);
    {-Set new RTS value}
  begin
    if (NewRTS <> FRTS) or Force then begin
      if (PortState = psOpen) then begin
        if CheckException(Self, Dispatcher.SetRTS(NewRTS)) = ecOK then
          FRTS := NewRTS;
      end else begin
        FRTS := NewRTS;
      end;
    end;
  end;

  procedure TApdCustomComPort.SetOnTrigger(const Value : TTriggerEvent);
  begin
    FOnTrigger := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerAvail(const Value : TTriggerAvailEvent);
  begin
    FOnTriggerAvail := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerData(const Value : TTriggerDataEvent);
  begin
    FOnTriggerData := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerStatus(const Value : TTriggerStatusEvent);
  begin
    FOnTriggerStatus := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerTimer(const Value : TTriggerTimerEvent);
  begin
    FOnTriggerTimer := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerLineError(const Value : TTriggerLineErrorEvent);
  begin
    FOnTriggerLineError := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerModemStatus(const Value : TNotifyEvent);
  begin
    FOnTriggerModemStatus := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerOutbuffFree(const Value : TNotifyEvent);
  begin
    FOnTriggerOutbuffFree := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerOutbuffUsed(const Value : TNotifyEvent);
  begin
    FOnTriggerOutbuffUsed := Value;
    UpdateHandlerFlag;
  end;

  procedure TApdCustomComPort.SetOnTriggerOutSent(const Value : TNotifyEvent);
  begin
    FOnTriggerOutSent := Value;
    UpdateHandlerFlag;
  end;

  function TApdCustomComPort.GetDispatcher : TApdBaseDispatcher;
    {-Return the current Dispatcher, opening the port if necessary}
  begin
    if FDispatcher = nil then
      if not (csDesigning in ComponentState) then begin
        if (PortState <> psOpen) and
            (not (csLoading in ComponentState)) and
            AutoOpen then
          Open := True;
      end;
    Result := FDispatcher;
  end;

  function TApdCustomComPort.GetModemStatus : Byte;
    {-Return the current modem status register value}
  begin
    if (PortState = psShuttingDown) then
      Result := 0
    else
      Result := ValidDispatcher.GetModemStatus;
  end;

  function TApdCustomComPort.GetDSR : Boolean;
    {-Return the DSR bit state}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckDSR
    else
      Result := False;
  end;

  function TApdCustomComPort.GetCTS : Boolean;
    {-Return CTS bit state}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckCTS
    else
      Result := False;
  end;

  function TApdCustomComPort.GetRI : Boolean;
    {-Return RI bit state}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckRI
    else
      Result := False;
  end;

  function TApdCustomComPort.GetDCD : Boolean;
    {-Return DCD bit state}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckDCD
    else
      Result := False;
  end;

  function TApdCustomComPort.GetDeltaDSR : Boolean;
    {-Return delta DSR bit state}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckDeltaDSR
    else
      Result := False;
  end;

  function TApdCustomComPort.GetDeltaCTS : Boolean;
    {-Return delta CTS bit state}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckDeltaCTS
    else
      Result := False;
  end;

  function TApdCustomComPort.GetDeltaRI : Boolean;
    {-Return delta RI bit state}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckDeltaRI
    else
      Result := False;
  end;

  function TApdCustomComPort.GetDeltaDCD : Boolean;
    {-Return delta DCD bit state}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckDeltaDCD
    else
      Result := False;
  end;

  function TApdCustomComPort.GetLineError : Word;
    {-Return most severe current line error}
  begin
    if (PortState = psOpen) then
      Result := Word(CheckException(Self, Word(Dispatcher.GetLineError)))
    else
      Result := leNoError;
  end;

  function TApdCustomComPort.GetLineBreak : Boolean;
    {-Return True if break received}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.CheckLineBreak
    else
      Result := False;
  end;

  procedure TApdCustomComPort.SetTriggerLength(const NewLength : Word);
    {-Change the length trigger}
  begin
    if (FTriggerLength <> NewLength) or Force then begin
      FTriggerLength := NewLength;
      if (PortState = psOpen) then
        Dispatcher.ChangeLengthTrigger(NewLength);
    end;
  end;

  function TApdCustomComPort.GetInBuffUsed : Word;
    {-Return the number of used bytes in the input buffer}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.InBuffUsed
    else
      Result := 0;
  end;

  function TApdCustomComPort.GetInBuffFree : Word;
    {-Return amount of freespace in inbuf}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.InBuffFree
    else
      Result := DispatchBufferSize;
  end;

  function TApdCustomComPort.GetOutBuffUsed : Word;
    {-Return number of used bytes in output buffer}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.OutBuffUsed
    else
      Result := 0;
  end;

  function TApdCustomComPort.GetOutBuffFree : Word;
    {-Return amount of free space in outbuff}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.OutBuffFree
    else
      Result := FOutSize;
  end;

  procedure TApdCustomComPort.SetUseMSRShadow(NewUse : Boolean);
    {-Set the MSR shadow option}
  begin
    { UseMSRShadow is only applicable to 16-bit, ignore it }
  end;

  procedure TApdCustomComPort.SetUseEventWord(NewUse : Boolean);
    {-Set the UseEventWord option}
  begin
    if (FUseEventWord <> NewUse) or Force then begin
      FUseEventWord := NewUse;
      if (PortState = psOpen) then
        if FUseEventWord then
          Dispatcher.OptionsOn(poUseEventWord)
        else
          Dispatcher.OptionsOff(poUseEventWord);
    end;
  end;

  procedure TApdCustomComPort.SetCommNotificationLevel(NewLevel : Word);
    {-Set the comm notification level}
  begin
    { 16-bit }
    if (FCommNotificationLevel <> NewLevel) or Force then begin
      FCommNotificationLevel := NewLevel;
    end;
  end;

  procedure TApdCustomComPort.SetRS485Mode(NewMode : Boolean);
    {-Set the RS485 mode}
  var
    NewFlowOpts : THWFlowOptionSet;
  begin
    if (FRS485Mode <> NewMode) or Force then begin
      FRS485Mode := NewMode;
      if (PortState = psOpen) then
        Dispatcher.SetRS485Mode(NewMode);

      if NewMode then begin
        {Force rts/cts flow control off}
        NewFlowOpts := FHWFlowOptions;
        Exclude(NewFlowOpts, hwfUseRTS);
        Exclude(NewFlowOpts, hwfRequireCTS);
        SetHWFlowOptions(NewFlowOpts);

        {Force RTS off}
        RTS := False;
      end;
    end;
  end;

  procedure TApdCustomComPort.SetBaseAddress(NewBaseAddress : Word);
    {-Set the base address}
  begin
    if (BaseAddress <> NewBaseAddress) or Force then begin
      if (PortState = psOpen) then
        Dispatcher.SetBaseAddress(NewBaseAddress);
    end;
  end;

  procedure TApdCustomComPort.SetThreadBoost(NewBoost : TApThreadBoost);
  begin
    if (FThreadBoost <> NewBoost) or Force then begin
      FThreadBoost := NewBoost;
      if (PortState = psOpen) then
        Dispatcher.SetThreadBoost(Ord(NewBoost));
    end;
  end;

  function TApdCustomComPort.GetBaseAddress : Word;
    {-Get the base address}
  begin
    if (PortState = psOpen) then
      Result := Dispatcher.GetBaseAddress
    else
      Result := 0;
  end;

{TApdComPort protected}

  function TApdCustomComPort.ActivateDeviceLayer : TApdBaseDispatcher;
  begin
    if Assigned(fCustomDispatcher) then
      Result := CustomDispatcher(Self)
    else case DeviceLayer of
    dlWin32  :
      if TapiMode = tmOn then
        Result := TApdTAPI32Dispatcher.Create(Self,FTapiCID)
      else
        Result := TApdWin32Dispatcher.Create(Self);
    else
      raise ENullAPI.Create(ecNullAPI, False);
    end;
  end;

  procedure TApdCustomComPort.DeviceLayerChanged;
    {-Notification that device layer has changed}
  begin
    { Do nothing at this level }
  end;

  function TApdCustomComPort.InitializePort : Integer;
  var
    Temp : array[0..12] of Char;
    FlowFlags : DWORD;

    function MakeComName(const ComNum : Word) : PChar;
      {-Return a string like 'COMXX'}
    begin
      if TapiMode <> tmOn then begin
        StrFmt(Temp, '\\.\COM%d', [ComNum]);
        Result := Temp;
      end else
        Result := nil;
    end;

  begin
    { Set up initial flow control info }
    FlowFlags := 0;

    { Manual settings }
    if FDTR then FlowFlags := (FlowFlags or ipAssertDTR);
    if FRTS then FlowFlags := (FlowFlags or ipAssertRTS);

    if (hwfUseDTR in FHWFlowOptions) then
      FlowFlags := (FlowFlags or ipAutoDTR);

    if (hwfUseRTS in FHWFlowOptions) then
      FlowFlags := (FlowFlags or ipAutoRTS);

    Result := Dispatcher.InitPort(MakeComName(FComNumber), FBaud,
      Ord(FParity), FDatabits, FStopbits, FInSize, FOutSize, FlowFlags);
  end;

  procedure TApdCustomComPort.Loaded;
    {-Physically open the port if FOpen is True}
  begin
    inherited Loaded;

    if not (csDesigning in ComponentState) then begin
      if ForceOpen then
        FOpen := True;
      if FOpen then begin
        ForceOpen := False;
        try
          InitPort;
        except
          FOpen := False;
          Application.HandleException(nil);
        end;
      end;
    end;
  end;

  procedure TApdCustomComPort.Trigger(Msg, TriggerHandle, Data : Word);
    {-For internal processing of all triggers}
  begin
    if Assigned(FOnTrigger) then
      FOnTrigger(Self, Msg, TriggerHandle, Data);
  end;

  procedure TApdCustomComPort.TriggerAvail(Count : Word);
    {-For internal triggeravail processing}
  begin
    if Assigned(FOnTriggerAvail) then
      FOnTriggerAvail(Self, Count);
  end;

  procedure TApdCustomComPort.TriggerData(TriggerHandle : Word);
    {-For internal triggerdata processing}
  begin
    if Assigned(FOnTriggerData) then
      FOnTriggerData(Self, TriggerHandle);
  end;

  procedure TApdCustomComPort.TriggerStatus(TriggerHandle : Word);
    {-For internal triggerstatus processing}
  begin
    if Assigned(FOnTriggerStatus) then
      FOnTriggerStatus(Self, TriggerHandle);
  end;

  procedure TApdCustomComPort.TriggerTimer(TriggerHandle : Word);
    {-For internal triggertimer processing}
  begin
    if Assigned(FOnTriggerTimer) then
      FOnTriggerTimer(Self, TriggerHandle);
  end;

  procedure TApdCustomComPort.UpdateHandlerFlag;
  begin
    if (PortState <> psOpen) then Exit;
    if Assigned(FOnTrigger) or Assigned(FOnTriggerAvail) or
      Assigned(FOnTriggerData) or Assigned(FOnTriggerStatus) or
      Assigned(FOnTriggerTimer) or Assigned(FOnTriggerLineError) or
      Assigned(FOnTriggerModemStatus) or Assigned(FOnTriggerOutbuffFree) or
      Assigned(FOnTriggerOutbuffUsed) or Assigned(FOnTriggerOutSent) then
      FDispatcher.UpdateHandlerFlags(fuEnablePort)
    else
      FDispatcher.UpdateHandlerFlags(fuDisablePort);
  end;

  procedure TApdCustomComPort.PortOpen;
    {-Port open processing}
  var
    I : Word;
    UL : PUserListEntry;
  begin
    {Tell all comport users that the port is now open}
    if UserList.Count > 0 then begin
      for I := UserList.Count-1 downto 0 do begin
        UL := UserList.Items[I];
        with UL^ do begin
          if Handle <> 0 then
            SendMessage(Handle, APW_PORTOPEN, 0, 0)
          else begin                                                     {!!.03}
            if IsEx then                                                 {!!.03}
              UL^.OpenCloseEx(Self, ctOpen)                              {!!.03}
            else                                                         {!!.03}
              UL^.OpenClose(Self, True);
          end;                                                           {!!.03}
        end;
      end;
    end;

    if Assigned(FOnPortOpen) then
      FOnPortOpen(Self);
  end;

  procedure TApdCustomComPort.PortClose;
    {-Port close processing}
  var
    I : Word;
    UL : PUserListEntry;
  begin
    {Tell all comport users that the port is now closed}
    if UserList.Count > 0 then begin
      for I := UserList.Count-1 downto 0 do begin
        UL := UserList.Items[I];
        with UL^ do begin
          if Handle <> 0 then
            SendMessage(Handle, APW_PORTCLOSE, 0, 0)
          else begin                                                     {!!.03}
            if IsEx then                                                 {!!.03}
              UL^.OpenCloseEx(Self, ctClosed)                            {!!.03}
            else                                                         {!!.03}
              UL^.OpenClose(Self, False);
          end;                                                           {!!.03}
        end;
      end;
    end;

    if Assigned(FOnPortClose) then
      FOnPortClose(Self);
  end;

  procedure TApdCustomComPort.PortClosing;                               {!!.03}
    {-Port closing processing, sent to other controls to notify that the port }
    { is starting to close for cleanup }
  var
    I : Word;
    UL : PUserListEntry;
  begin
    { tell all users that the port is now being closed }
    if UserList.Count > 0 then begin
      for I := pred(UserList.Count) downto 0 do begin
        UL := UserList.Items[I];
        { only notify if they are registered as extended }
        if UL^.IsEx then
          with UL^ do begin
            if Handle <> 0 then
              SendMessage(Handle, APW_CLOSEPENDING, 0, 0)
            else
              UL^.OpenCloseEx(Self, ctClosing);
          end;
      end;
    end;
  end;

  procedure TApdCustomComPort.TriggerLineError(const Error : Word;
                                            const LineBreak : Boolean);
    {-Received a line error}
  begin
    if Assigned(FOnTriggerLineError) then
      FOnTriggerLineError(Self, Error, LineBreak);
  end;

  procedure TApdCustomComPort.TriggerModemStatus;
    {-Received a modem status change}
  begin
    if Assigned(FOnTriggerModemStatus) then
      FOnTriggerModemStatus(Self);
  end;

  procedure TApdCustomComPort.TriggerOutbuffFree;
    {-Received and outbuff free trigger}
  begin
    if Assigned(FOnTriggerOutbuffFree) then
      FOnTriggerOutbuffFree(Self);
  end;

  procedure TApdCustomComPort.TriggerOutbuffUsed;
    {-Received and outbuff used trigger}
  begin
    if Assigned(FOnTriggerOutbuffUsed) then
      FOnTriggerOutbuffUsed(Self);
  end;

  procedure TApdCustomComPort.TriggerOutSent;
    {-Received an outsent trigger}
  begin
    if Assigned(FOnTriggerOutSent) then
      FOnTriggerOutSent(Self);
  end;

  procedure TApdCustomComPort.WaitChar(C : AnsiChar);
    {-Received a character in WaitForString or WaitForMultiString}
  begin
    if Assigned(FOnWaitChar) then
      FOnWaitChar(Self, C);
  end;

  procedure TApdCustomComPort.RegisterComPort(Enabling : Boolean);
    {-Use a hidden window to get triggers}
  var
    Instance : THandle;
  begin
    if Enabling then begin
      {Make sure the window is registered}
      RegisterComWindow;

      if ModuleIsLib and not ModuleIsPackage then
        { we're a DLL, not a package }
        Instance   := SysInit.hInstance
      else
        {we're an exe or package }
        Instance   := System.MainInstance;

      {Create a window}
      fComWindow := CreateWindow(ComWindowClass,        {class name}
                                '',                     {caption}
                                ws_Overlapped,          {window style}
                                0,                      {X}
                                0,                      {Y}
                                0,                      {width}
                                0,                      {height}
                                0,                      {parent}
                                0,                      {menu}
                                Instance,               {instance}
                                nil);                   {parameter}

      {Register it}
      FDispatcher.RegisterWndTriggerHandler(ComWindow);
    end else begin
      {Deregister it}
      FDispatcher.DeregisterWndTriggerHandler(ComWindow);
      DestroyWindow(ComWindow);
    end;
  end;

  procedure TApdCustomComPort.ValidateComport;
  var
    ComSelDlg : TComSelectForm;
  begin
    if (FComNumber = 0) then
      if (not FPromptForPort) then
        raise ENoPortSelected.Create(ecNoPortSelected, False)
      else begin
        ComSelDlg := TComSelectForm.Create(Application);
        try
          if (ComSelDlg.ShowModal = mrOk) then
            ComNumber := ComSelDlg.SelectedComNum
          else
            raise ENoPortSelected.Create(ecNoPortSelected, False);
        finally
          ComSelDlg.Free;
        end;
      end;
  end;

  constructor TApdCustomComPort.Create(AOwner : TComponent);
    {-Create the object instance}
  begin

    {Create the registration list before notification events are sent}
    UserList := TList.Create;

    {No override by default}
    OverrideLine := False;

    {This causes notification events for all other components}
    inherited Create(AOwner);

    {Private inits}
    Force := False;
    PortState := psClosed;
    ForceOpen := False;
    CopyTriggers := False;
    BusyBeforeWait := False;
    WaitPrepped := False;
    fComWindow := 0;

    {Data inits}
    FDeviceLayers := [dlWin32];
    FPromptForPort := adpoDefPromptForPort;
    FDeviceLayer := adpoDefDeviceLayer;
    FDispatcher := nil;
    FComNumber := adpoDefComNumber;
    FOpen      := adpoDefOpen;
    FAutoOpen  := adpoDefAutoOpen;
    FDTR       := adpoDefDTR;
    FRTS       := adpoDefRTS;
    FSWFlowOptions := adpoDefSWFlowOptions;
    FXonChar   := adpoDefXOnChar;
    FXOffChar  := adpoDefXOffChar;
    FBufferFull := adpoDefBufferFull;
    FBufferResume := adpoDefBufferResume;
    FTriggerLength := adpoDefTriggerLength;
    FTracing   := adpoDefTracing;
    FTraceSize := adpoDefTraceSize;
    FTraceName := adpoDefTraceName;
    FTraceHex  := adpoDefTraceHex;
    TraceAllHex:= adpoDefTraceAllHex;
    FLogging   := adpoDefLogging;
    FLogSize   := adpoDefLogSize;
    FLogName   := adpoDefLogName;
    FLogHex    := adpoDefLogHex;
    LogAllHex  := adpoDefLogAllHex;
    FUseMSRShadow := adpoDefUseMSRShadow;
    FUseEventWord := adpoDefUseEventWord;
    FCommNotificationLevel := adpoDefCommNotificationLevel;
    FTapiMode  := adpoDefTapiMode;


    if not OverrideLine then begin
      FBaud      := adpoDefBaudRt;
      FParity    := adpoDefParity;
      FDatabits  := adpoDefDatabits;
      FStopbits  := adpoDefStopbits;
      FInSize    := adpoDefInSize;
      FOutSize   := adpoDefOutSize;
      FHWFlowOptions := [];
    end;

    {Event inits}
    FOnTrigger := nil;
    FOnTriggerAvail := nil;
    FOnTriggerData := nil;
    FOnTriggerStatus := nil;
    FOnTriggerTimer := nil;
    FOnTriggerLineError := nil;
    FOnTriggerModemStatus := nil;
    FOnTriggerOutbuffFree := nil;
    FOnTriggerOutbuffUsed := nil;
    FOnTriggerOutSent := nil;
    FOnPortOpen := nil;
    FOnPortClose := nil;
    FOnWaitChar := nil;

  end;

  destructor TApdCustomComPort.Destroy;
    {-Destroy the object instance}
  var
    I : Word;
    UL : PUserListEntry;
  begin

    {Close the port}
    if (PortState = psOpen) then begin
      DonePort;
    end;

    {Get rid of the user list}
    if Assigned(UserList) and (UserList.Count > 0) then begin            {!!.02}
      for I := UserList.Count-1 downto 0 do begin
        UL := UserList.Items[I];
        UserList.Remove(UL);
        Dispose(UL);
      end;
    end;
    UserList.Free;

    TApdBaseDispatcher.ClearSaveBuffers(SaveTriggerBuffer);
    inherited Destroy;
  end;

  procedure TApdCustomComPort.InitPort;
    {-Physically open the comport}
  var
    Res : Integer;
    nBaud     : Integer;
    nParity   : Word;
    nDataBits : TDatabits;
    nStopBits : TStopbits;
    nHWOpts, nSWOpts, nBufferFull, nBufferResume : Cardinal;
    nOnChar, nOffChar : AnsiChar;
  begin
    { Validate the comport -- not needed for Tapi }
    if TapiMode <> tmOn then
      ValidateComport;

    { Activate the specified device layer }
    FDispatcher := ActivateDeviceLayer;
    FDispatcher.DeviceName := Format('\\.\COM%d', [ComNumber]);             // SWB
    try
      { Get line parameters that Tapi set }
      if TapiMode = tmOn then begin
        if ValidDispatcher.ComHandle = 0 then
          CheckException(Self, ecNotOpenedByTapi);
        FDispatcher.GetLine(nBaud, nParity, nDataBits, nStopBits);
        FDispatcher.GetFlowOptions(nHWOpts, nSWOpts, nBufferFull,
          nBufferResume, nOnChar, nOffChar);

        { Sync our properties with those set by Tapi }
        FBaud := nBaud;
        FParity := TParity(nParity);
        FDataBits := Ord(nDataBits);
        FStopBits := Ord(nStopBits);

        FHWFlowOptions := [];
        if (nHWOpts and hfUseDTR) <> 0 then
          Include(FHWFlowOptions, hwfUseDTR);
        if (nHWOpts and hfUseRTS) <> 0 then
          Include(FHWFlowOptions, hwfUseRTS);
        if (nHWOpts and hfRequireDSR) <> 0 then
          Include(FHWFlowOptions, hwfRequireDSR);
        if (nHWOpts and hfRequireCTS) <> 0 then
          Include(FHWFlowOptions, hwfRequireCTS);

        FSWFlowOptions := TSWFlowOptions(nSWOpts);
        FXOnChar := nOnChar;
        FXOffChar := nOffChar;
      end;

      Res := InitializePort;

      {Remap access denied and file not found errors}
      if Res = ecAccessDenied then
        Res := ecAlreadyOpen
      else if (Res = ecFileNotFound) or (Res = ecPathNotFound) then
        Res := ecBadId;

      if (Res = ecOk) then begin
        {Handle preset properties}
        PortState := psOpen;
        UpdateHandlerFlag;
        Force := True;
        SetTracing(Tracing);
        SetLogging(Logging);
        SetHWFlowOptions(HWFlowOptions);
        SetSWFlowOptions(SWFlowOptions);
        SetXOnChar(FXonChar);
        SetXOffChar(FXoffChar);
        SetTriggerLength(FTriggerLength);
        SetDTR(FDTR);
        SetRTS(FRTS);
        {SetUseMSRShadow(FUseMSRShadow);} {16-bit}                       {!!.02}
        SetUseEventWord(FUseEventWord);
        {SetCommNotificationLevel(FCommNotificationLevel);} {16-bit}     {!!.02}
        SetRS485Mode(FRS485Mode);
        SetThreadBoost(FThreadBoost);
        Force := False;
        FOpen := True;

        {Prepare for triggers}
        RegisterComPort(True);

        {Add pending triggers}
        if CopyTriggers then begin
          CopyTriggers := False;
          FDispatcher.RestoreTriggers(SaveTriggerBuffer);
        end;

        {Send OnPortEvent}
        PortOpen;
      end else
        CheckException(Self, Res);
    except
      FOpen := False;
      PortState := psClosed;
      FDispatcher.Free;
      FDispatcher := nil;
      raise;
    end;
  end;

  procedure TApdCustomComPort.DonePort;
    {-Physically close the comport}
  begin
    {FOpen := False;}                                                    {!!.02}
    if (PortState = psOpen) then begin

      { Force trace/log dumps if they were on }
      Tracing := tlDump;
      Logging := tlDump;

      { Port is shutting down }
      PortState := psShuttingDown;

      { Send OnPortClose event }
      {PortClose;}                                                       {!!.02}
      PortClosing;                                                       {!!.03}

      { Save triggers in case this port is reopened }
      Dispatcher.SaveTriggers(SaveTriggerBuffer);
      CopyTriggers := True;

      { Close the port and clear ComTable }
      Dispatcher.DonePort;
      if Dispatcher.EventBusy then begin
        PostMessage(fComWindow, apw_ClosePending, 0,
          Dispatcher.Handle shl 16);
        SafeYield;
      end else begin
        { Get rid of the trigger handler }
        RegisterComPort(False);
        FDispatcher.Free;
        FDispatcher := nil;
        PortState := psClosed;
        FOpen := False;                                                  {!!.02}
      end;
      { Send OnPortClose event }
      PortClose;                                                         {!!.02}
    end;
  end;

  procedure TApdCustomComPort.Assign(Source: TPersistent);
    {-Assign values of Source to self}
  var
    SourcePort : TApdCustomComPort absolute Source;
    I : Word;
    UL : PUserListEntry;
  begin
    if Source is TApdCustomComPort then begin
      {Discard existing userlist}
      if UserList.Count > 0 then
        for I := UserList.Count-1 downto 0 do begin
          UL := UserList.Items[I];
          UserList.Remove(UL);
          Dispose(UL);
        end;
      UserList.Free;

      {Copy Source's userlist}
      UserList := TList.Create;
      if SourcePort.UserList.Count > 0 then
        for I := 0 to SourcePort.UserList.Count-1 do begin
          New(UL);
          Move(SourcePort.UserList.Items[I]^, UL^,
               SizeOf(TUserListEntry));
          UserList.Add(UL);
        end;

      {Copy triggers from Source}
      if (SourcePort.PortState = psOpen) then begin
        SourcePort.Dispatcher.SaveTriggers(SaveTriggerBuffer);
        CopyTriggers := True;
      end;

      {Copy all other fields}
      Force            := SourcePort.Force;
      FDeviceLayer     := SourcePort.FDeviceLayer;
      FComNumber       := SourcePort.FComNumber;
      FBaud            := SourcePort.FBaud;
      FParity          := SourcePort.FParity;
      FDatabits        := SourcePort.FDatabits;
      FStopbits        := SourcePort.FStopbits;
      FInSize          := SourcePort.FInSize;
      FOutSize         := SourcePort.FOutSize;
      FOpen            := False;
      FAutoOpen        := SourcePort.FAutoOpen;
      FPromptForPort   := SourcePort.FPromptForPort;
      FRS485Mode       := SourcePort.FRS485Mode;
      FThreadBoost     := SourcePort.FThreadBoost;
      FDTR             := SourcePort.FDTR;
      FRTS             := SourcePort.FRTS;
      FBufferFull      := SourcePort.FBufferFull;
      FBufferResume    := SourcePort.FBufferResume;
      FHWFlowOptions   := SourcePort.FHWFlowOptions;
      FSWFlowOptions   := SourcePort.FSWFlowOptions;
      FXOnChar         := SourcePort.FXOnChar;
      FXOffChar        := SourcePort.FXOffChar;
      FTracing         := SourcePort.FTracing;
      FTraceSize       := SourcePort.FTraceSize;
      FTraceName       := SourcePort.FTraceName;
      FTraceHex        := SourcePort.FTraceHex;
      FTraceAllHex     := SourcePort.FTraceAllHex;
      FLogging         := SourcePort.FLogging;
      FLogSize         := SourcePort.FLogSize;
      FLogName         := SourcePort.FLogName;
      FLogHex          := SourcePort.FLogHex;
      FLogAllHex       := SourcePort.FLogAllHex;
      FTriggerLength   := SourcePort.FTriggerLength;
      {Must go through write method to ensure flag gets updated}
      OnTrigger        := SourcePort.FOnTrigger;
      OnTriggerAvail   := SourcePort.FOnTriggerAvail;
      OnTriggerData    := SourcePort.FOnTriggerData;
      OnTriggerStatus  := SourcePort.FOnTriggerStatus;
      OnTriggerTimer   := SourcePort.FOnTriggerTimer;
      FOnPortOpen      := SourcePort.FOnPortOpen;
      FOnPortClose     := SourcePort.FOnPortClose;
      FTapiMode        := SourcePort.FTapiMode;
    end;
  end;

  procedure TApdCustomComPort.RegisterUser(const H : THandle);
    {-Register a user of this comport}
  var
    UL : PUserListEntry;
  begin
    New(UL);
    with UL^ do begin
      Handle := H;
      OpenClose := nil;
      OpenCloseEx := nil;                                                {!!.03}
      IsEx := False;                                                     {!!.03}
    end;
    UserList.Add(UL);
  end;

  procedure TApdCustomComPort.RegisterUserEx(const H : THandle);{!!.03}
      {-Register a TApdComPort user to receive open/closing/close events}
  var
    UL : PUserListEntry;
  begin
    New(UL);
    with UL^ do begin
      Handle := H;
      OpenClose := nil;
      OpenCloseEx := nil;
      IsEx := True;
    end;
    UserList.Add(UL);
  end;

  procedure TApdCustomComPort.RegisterUserCallback(CallBack : TPortCallback);
    {-Register a user of this comport}
  var
    UL : PUserListEntry;
  begin
    New(UL);
    with UL^ do begin
      Handle := 0;
      OpenClose := Callback;
      OpenCloseEx := nil;                                                {!!.03}
      IsEx := False;                                                     {!!.03}
    end;
    UserList.Add(UL);
  end;

  procedure TApdCustomComPort.RegisterUserCallbackEx(                    {!!.03}
    CallBackEx : TPortCallbackEx);
  {-Register a TApdComPort user to receive extended callbacks}
  var
    UL : PUserListEntry;
  begin
    New(UL);
    with UL^ do begin
      Handle := 0;
      OpenClose := nil;
      OpenCloseEx := CallbackEx;
      IsEx := True;
    end;
    UserList.Add(UL);
  end;

  procedure TApdCustomComPort.DeregisterUser(const H : THandle);
    {-Deregister a user of this comport}
  var
    UL : PUserListEntry;
    I : Word;
  begin
    if csDestroying in ComponentState then Exit;                         {!!.05}
    if Assigned(UserList) and (UserList.Count > 0) then begin            {!!.02}
      for I := UserList.Count-1 downto 0 do begin
        UL := UserList.Items[I];
        with UL^ do begin
          if Handle = H then begin
            UserList.Remove(UL);
            Dispose(UL);
          end;
        end;
      end;
    end;
  end;

  procedure TApdCustomComPort.DeregisterUserCallback(CallBack : TPortCallback);
    {-Deregister a user of this comport}
  var
    UL : PUserListEntry;
    I : Word;
  begin
    if csDestroying in ComponentState then Exit;                         {!!.05}
    if Assigned(UserList) and (UserList.Count > 0) then begin            {!!.02}
      for I := UserList.Count-1 downto 0 do begin
        UL := UserList.Items[I];
        with UL^ do begin
          if @CallBack = @OpenClose then begin
            UserList.Remove(UL);
            Dispose(UL);
          end;
        end;
      end;
    end;
  end;

  procedure TApdCustomComPort.DeregisterUserCallbackEx(                  {!!.03}
    CallBackEx : TPortCallbackEx);
    {-Deregister a TApdComPort user callback}
  var
    UL : PUserListEntry;
    I : Word;
  begin
    if csDestroying in ComponentState then Exit;                         {!!.05}
    if Assigned(UserList) and (UserList.Count > 0) then begin
      for I := UserList.Count-1 downto 0 do begin
        UL := UserList.Items[I];
        with UL^ do begin
          if @CallBackEx = @OpenCloseEx then begin
            UserList.Remove(UL);
            Dispose(UL);
          end;
        end;
      end;
    end;
  end;

  procedure TApdCustomComPort.ProcessCommunications;
    {-Process communications receive events, but not triggers}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, ValidDispatcher.ProcessCommunications);
  end;

  procedure TApdCustomComPort.FlushInBuffer;
    {-Flush the input buffer}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, ValidDispatcher.FlushInBuffer);
  end;

  procedure TApdCustomComPort.FlushOutBuffer;
    {-Flush the output buffer}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, ValidDispatcher.FlushOutBuffer);
  end;

  procedure TApdCustomComPort.InitTracing(const NumEntries : Cardinal);
    {-Start tracing}
  begin
    if (PortState = psShuttingDown) then Exit;
    if NumEntries <> 0 then
      FTraceSize := NumEntries;
    CheckException(Self, Dispatcher.InitTracing(NumEntries));
    FTracing := tlOn;
  end;

  procedure TApdCustomComPort.DumpTrace(const FName : String;
                                        const InHex : Boolean);
    {-Dump the trace file}
  var
    Dest : array[0..255] of Char;
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, Dispatcher.DumpTrace(StrPCopy(Dest, FName),
      InHex, TraceAllHex));
    FTracing := tlOff;
  end;

  procedure TApdCustomComPort.AppendTrace(const FName : string;
                                          const InHex : Boolean;
                                          const NewState : TTraceLogState); // SWB
    {-Append the trace file}
  var
    Dest : array[0..255] of Char;
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self,
      Dispatcher.AppendTrace(StrPCopy(Dest, FName), InHex, TraceAllHex));
    FTracing := NewState;                                                   // SWB
  end;

  procedure TApdCustomComPort.ClearTracing;
    {-Clear the trace buffer but keep tracing}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, Dispatcher.ClearTracing);
  end;

  procedure TApdCustomComPort.AbortTracing;
    {-Abort tracing without dumping the trace file}
  begin
    if (PortState = psShuttingDown) then Exit;
    Dispatcher.AbortTracing;
    FTracing := tlOff;
  end;

  procedure TApdCustomComPort.AddTraceEntry(const CurEntry, CurCh : AnsiChar);
    {-Add a trace entry}
  begin
    if (PortState = psShuttingDown) then Exit;
    Dispatcher.AddTraceEntry(CurEntry, CurCh);
  end;

  procedure TApdCustomComPort.AddStringToLog(S : AnsiString);
  begin
    if (PortState = psShuttingDown) then Exit;
    ValidDispatcher.AddStringToLog(S);
  end;

  procedure TApdCustomComPort.StartTracing;
    {-Resume tracing after StopTracing}
  begin
    if (PortState = psShuttingDown) then Exit;
    Dispatcher.StartTracing;
    FTracing := tlOn;
  end;

  procedure TApdCustomComPort.StopTracing;
    {-Temporarily stop tracing}
  begin
    if (PortState = psShuttingDown) then Exit;
    Dispatcher.StopTracing;
    FTracing := tlPause;
  end;

  procedure TApdCustomComPort.ForcePortOpen;
    {-Ensure port is opened after loading}
  begin
    if AutoOpen then
      ForceOpen := True;
  end;

  procedure TApdCustomComPort.SendBreak(Ticks : Word; Yield : Boolean);
    {-Send a line break of ticks duration}
  begin
    if (PortState = psShuttingDown) then Exit;
    ValidDispatcher.SendBreak(Ticks, Yield);
  end;

  procedure TApdCustomComPort.SetBreak(BreakOn: Boolean);
    {-Sets or clears line break condition}
  begin
    if (PortState = psShuttingDown) then Exit;
    ValidDispatcher.SetBreak(BreakOn);
  end;

  procedure TApdCustomComPort.InitLogging(const Size : Cardinal);
    {-Start dispatch logging}
  begin
    if (PortState = psShuttingDown) then Exit;
    if Size <> 0 then
      FLogSize := Size;
    Dispatcher.InitDispatchLogging(FLogSize);
    FLogging := tlOn;
  end;

  procedure TApdCustomComPort.DumpLog(const FName : string;
                                      const InHex : Boolean);
    {-Dump the dispatch log}
  var
    Dest : array[0..255] of Char;
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self,
      Dispatcher.DumpDispatchLog(StrPCopy(Dest, FName), InHex, LogAllHex));
    FLogging := tlOff;
  end;

  procedure TApdCustomComPort.AppendLog(const FName : string;
                                        const InHex : Boolean;
                                        const NewState : TTraceLogState);   // SWB
    {-Dump the dispatch log}
  var
    Dest : array[0..255] of Char;
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self,
      Dispatcher.AppendDispatchLog(StrPCopy(Dest, FName), InHex, LogAllHex));
    FLogging := NewState;                                                   // SWB
  end;

  procedure TApdCustomComPort.ClearLogging;
    {-Clear the log but keep logging}
  begin
    if (PortState = psShuttingDown) then Exit;
    Dispatcher.ClearDispatchLogging;
  end;

  procedure TApdCustomComPort.AbortLogging;
    {-Abort logging without dumping the log}
  begin
    if (PortState = psShuttingDown) then Exit;
    Dispatcher.AbortDispatchLogging;
    FLogging := tlOff;
  end;

  procedure TApdCustomComPort.StartLogging;
    {-Resume logging after stopping}
  begin
    if (PortState = psShuttingDown) then Exit;
    Dispatcher.StartDispatchLogging;
    FLogging := tlOn;
  end;

  procedure TApdCustomComPort.StopLogging;
    {-Temporarily stop logging}
  begin
    if (PortState = psShuttingDown) then Exit;
    Dispatcher.StopDispatchLogging;
    FLogging := tlPause;
  end;

  function TApdCustomComPort.AddDataTrigger(const Data : ShortString;
                                            const IgnoreCase : Boolean) : Word;
    {-Add a ShortString data trigger}
  var
    Len : Word;
    P : array[0..255] of AnsiChar;
  begin
    if (PortState = psShuttingDown) then begin
      Result := 0;
      Exit;
    end;
    Len:=Length(data);
    AnsiStrings.StrPLCopy(P, Data, Length(P) - 1);
    Result := Word(CheckException(Self,
        ValidDispatcher.AddDataTriggerLen(P, IgnoreCase, Len)));
  end;

  function TApdCustomComPort.AddTimerTrigger : Word;
    {-Add a timer trigger}
  begin
    if (PortState = psShuttingDown) then
      Result := 0
    else
      Result := Word(CheckException(Self, ValidDispatcher.AddTimerTrigger));
  end;

  function TApdCustomComPort.AddStatusTrigger(const SType : Word) : Word;
    {-Add a status trigger of type SType}
  begin
    if (PortState = psShuttingDown) then
      Result := 0
    else
      Result := Word(CheckException(Self,
        ValidDispatcher.AddStatusTrigger(SType)));
  end;

  procedure TApdCustomComPort.RemoveTrigger(const Handle : Word);
    {-Remove trigger with index Index}
  begin
    if (PortState = psOpen) then
      CheckException(Self, Dispatcher.RemoveTrigger(Handle));
  end;

  procedure TApdCustomComPort.RemoveAllTriggers;
    {-Remove all triggers}
  begin
    if (PortState = psOpen) then begin
      Dispatcher.RemoveAllTriggers;
      FTriggerLength := 0;
    end;
  end;

  procedure TApdCustomComPort.SetTimerTrigger(const Handle : Word;
                                              const Ticks : Integer;
                                              const Activate : Boolean);
    {-Set the timer for trigger Index}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, ValidDispatcher.SetTimerTrigger(Handle, Ticks, Activate));
  end;

  procedure TApdCustomComPort.SetStatusTrigger(const Handle : Word;
                                               const Value : Word;
                                               const Activate : Boolean);
    {-Set status trigger}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self,
      ValidDispatcher.SetStatusTrigger(Handle, Value, Activate));
  end;

{I/O}

  function TApdCustomComPort.CharReady : Boolean;
    {-Return the next character in the receive buffer}
  begin
    if (PortState = psShuttingDown) then
      Result := False
    else
      Result := ValidDispatcher.CharReady;
  end;

  function TApdCustomComPort.PeekChar(const Count : Word) : AnsiChar;
    {-Peek at the Count'th character in the buffer (1=next)}
  var
    Res : Integer;
    C   : AnsiChar;
  begin
    if (PortState = psShuttingDown) then begin
      Res := ecOk;
      C := #0;
    end else
      Res := ValidDispatcher.PeekChar(C, Count);
    if Res = ecOK then
      Result := C
    else begin
      CheckException(Self, Res);
      Result := #0;
    end;
  end;

  function TApdCustomComPort.GetChar : AnsiChar;
    {-Retrieve the next character from the input queue}
  var
    Res : Integer;
    C   : AnsiChar;
  begin
    if (PortState = psShuttingDown) then begin
      Res := ecOk;
      C := #0;
    end else
      Res := ValidDispatcher.GetChar(C);
    if Res = ecOK then
      Result := C
    else begin
      CheckException(Self, Res);
      Result := #0;
    end;
  end;

  procedure TApdCustomComPort.PeekBlock(var Block; const Len : Word);
    {-Peek at the next Len characters, but don't remove from buffer}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, ValidDispatcher.PeekBlock(PAnsiChar(@Block), Len));
  end;

  procedure TApdCustomComPort.GetBlock(var Block; const Len : Word);
    {-Return the next Len characters from the buffer}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, ValidDispatcher.GetBlock(PAnsiChar(@Block), Len));
  end;

  procedure TApdCustomComPort.PutChar(const C : AnsiChar);
    {-Add C to the output buffer}
  begin
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, ValidDispatcher.PutChar(C));
  end;

  procedure TApdCustomComPort.PutString(const S : string);
  begin
    PutString(AnsiString(S));
  end;

  procedure TApdCustomComPort.PutString(const S : AnsiString);
    {-Add S to the output buffer}
  begin
    if (PortState = psShuttingDown) then Exit;
   {$IFOPT H+}
    CheckException(Self, ValidDispatcher.PutBlock(Pointer(S)^, Length(S)));
   {$ELSE}
    CheckException(Self, ValidDispatcher.PutString(S));
   {$ENDIF}
  end;

  function TApdCustomComPort.PutBlock(const Block; const Len : Word) : Integer;
    {-Add Block to the output buffer}
  begin
    PutBlock := 0;
    if (PortState = psShuttingDown) then Exit;
    CheckException(Self, ValidDispatcher.PutBlock(PByte(Block), Len));
  end;

{Waits}

  function TApdCustomComPort.CheckForString(var Index : Byte; C : AnsiChar;
                                            const S : AnsiString;
                                            IgnoreCase : Boolean) : Boolean;
    {-Compare C against a sequence of chars, looking for S}
  var
    CurChar : AnsiChar;
  begin
    CheckForString := False;
    if (PortState = psShuttingDown) then Exit;
    Inc(Index);

    {Upcase both data if ignoring case}
    if IgnoreCase then begin
      C := Upcase(C);
      CurChar := Upcase(S[Index]);
    end else
      CurChar := S[Index];

    {Compare...}
    if C = CurChar then
      {Got match, was it complete?}
      if Index = Length(S) then begin
        Index := 0;
        CheckForString := True;
      end else
    else
      {No match, reset Index}
      if (IgnoreCase and (C = Upcase(S[1]))) or
         (C = S[1]) then
        Index := 1
      else
        Index := 0;
  end;

  function TApdCustomComPort.WaitForString(const S : AnsiString;
                                           const Timeout : Integer;
                                           const Yield, IgnoreCase : Boolean)
                                           : Boolean;
    {-Wait for data, generate ETimeout exception if not found}
  var
    ET        : EventTimer;
    C         : AnsiChar;
    CurChar   : AnsiChar;
    StartChar : AnsiChar;
    Index     : Byte;
    Finished  : Boolean;
    WasBusy   : Boolean;
    Len       : Word;
  begin
    Result := True;

    {Exit immediately if nothing to do}
    if (S = '') or (PortState = psShuttingDown) then
      Exit;

    {Set busy flag}
    ValidDispatcher.SetEventBusy(WasBusy, True);

    {Note the length of the string}
    Len := Length(S);

    {Prepare...}
    NewTimer(ET, Timeout);
    Index := 0;
    Finished := False;
    StartChar := S[1];
    if IgnoreCase then
      StartChar := Upcase(StartChar);

    {Wait for data...}
    repeat
      if CharReady then begin
        {Char is ready, go get it}
        try                                                                 // SWB
            C := GetChar;
            Inc(Index);
            CurChar := S[Index];

            {Report the character}
            WaitChar(C);

            {If ignoring case then upcase both}
            if IgnoreCase then begin
              C := Upcase(C);
              CurChar := Upcase(CurChar);
            end;

            {Compare current character}
            if C = CurChar then begin
              if Index = Len then
                Finished := True;
            end else begin
              {No match, reset...}
              if C = StartChar then
                Index := 1
              else
                Index := 0;
            end;
        except                                                              // SWB
          // There is a timing window between CharReady and GetChar where   // SWB
          // a call to FlushCom can cause 'buffer is empty' exceptions.  So // SWB
          // just ignore them.                                              // SWB
          on EBufferIsEmpty do                                              // SWB
            ;                                                               // SWB
          else                                                              // SWB
            raise;                                                          // SWB
        end;                                                                // SWB
      end;

      {Check for timeout if we're not otherwise finished}
      if not Finished then begin
        Finished := TimerExpired(ET);

        {Yield}
        if Yield then
          Application.ProcessMessages;
      end;
    until Finished or Application.Terminated;

    {Indicate timeout if we timed out}
    if not Application.Terminated then
      Result := not TimerExpired(ET);

    {Restore busy flag}
    if WaitPrepped and not BusyBeforeWait then
      Dispatcher.SetEventBusy(WasBusy, False)
    else if not WasBusy then
      Dispatcher.SetEventBusy(WasBusy, False);
    WaitPrepped := False;
    BusyBeforeWait := False;
  end;

  function TApdCustomComPort.WaitForMultiString(const S : AnsiString;
                                                const Timeout : Integer;
                                                const Yield : Boolean;
                                                const IgnoreCase : Boolean;
                                                const SepChar : AnsiChar) : Integer;
    {-Wait for S, which contains several substrings separated by ^}
  const
    MaxSubs = 127;
  var
    ET         : EventTimer;
    I, Total   : Word;
    C          : AnsiChar;
    CurChar    : AnsiChar;
    Finished   : Boolean;
    WasBusy    : Boolean;
    StartChar  : array[1..MaxSubs] of AnsiChar;
    StartIndex : array[1..MaxSubs] of Byte;
    EndIndex   : array[1..MaxSubs] of Byte;
    Index      : array[1..MaxSubs] of Byte;
    Len        : Word;
  begin
    Result := 0;

    {Exit immediately if nothing to do}
    if (S = '') or (PortState = psShuttingDown) then
      Exit;

    {Note the length of the string}
    Len := Length(S);

    {Set busy flag}
    ValidDispatcher.SetEventBusy(WasBusy, True);

    {Prepare to parse for substrings}
    Total := 1;
    I := 1;
    StartIndex[Total] := I;
    Index[Total] := I;
    StartChar[Total] := S[I];
    if IgnoreCase then
      StartChar[Total] := Upcase(StartChar[Total]);

    {Loop through S, noting start positions of each substring}
    while (I <= Len) and (Total < MaxSubs) do begin
      if S[I] = SepChar then begin
        EndIndex[Total] := I-1;
        Inc(I);
        Inc(Total);
        StartIndex[Total] := I;
        Index[Total] := I;
        StartChar[Total] := S[I];
        If IgnoreCase then
          StartChar[Total] := Upcase(StartChar[Total]);
      end else
        Inc(I);
    end;

    {Handle last string}
    if S[Len] <> SepChar then
      EndIndex[Total] := Len
    else
      Dec(Total);

    {Prepare to wait}
    NewTimer(ET, Timeout);
    Finished := False;

    {Wait for data...}
    repeat

      if CharReady then begin
        {Char is ready, go get it}
        try                                                                 // SWB
            C := GetChar;
            {Report the character}
            WaitChar(C);

            {Handle case}
            if IgnoreCase then
              C := Upcase(C);

            {Compare against all substrings}
            for I := 1 to Total do begin
              CurChar := S[Index[I]];
              if IgnoreCase then
                CurChar := Upcase(CurChar);

              {Compare current character}
              if C = CurChar then begin
                if Index[I] = EndIndex[I] then begin
                  Result := I;
                  Finished := True;
                  break;
                end;
                Inc(Index[I]);
              end else begin
                {No match, reset...}
                if C = StartChar[I] then
                  Index[I] := StartIndex[I]+1
                else
                  Index[I] := StartIndex[I];
              end;
            end;
        except                                                              // SWB
          // There is a timing window between CharReady and GetChar where   // SWB
          // a call to FlushCom can cause 'buffer is empty' exceptions.  So // SWB
          // just ignore them.                                              // SWB
          on EBufferIsEmpty do                                              // SWB
            ;                                                               // SWB
          else                                                              // SWB
            raise;                                                          // SWB
        end;                                                                // SWB
      end;

      {Check for timeout if we're not otherwise finished}
      if not Finished then begin
        Finished := TimerExpired(ET);

        {Yield}
        if Yield then
          Application.ProcessMessages;
      end;
    until Finished or Application.Terminated;

    {Restore busy flag}
    if WaitPrepped and not BusyBeforeWait then
      Dispatcher.SetEventBusy(WasBusy, False)
    else if not WasBusy then
      Dispatcher.SetEventBusy(WasBusy, False);
    WaitPrepped := False;
    BusyBeforeWait := False;
  end;

  procedure TApdCustomComPort.PrepareWait;
    {-Set EventBusy true to prevent triggers}
  begin
    if (PortState = psShuttingDown) then Exit;
    WaitPrepped := True;
    ValidDispatcher.SetEventBusy(BusyBeforeWait, True);
  end;

{Miscellaneous procedures}

  function SearchComPort(const C : TComponent) : TApdCustomComPort;
    {-Search for a comport in the same form as TComponent}

    function FindComPort(const C : TComponent) : TApdCustomComPort;
    var
      I  : Integer;
    begin
      Result := nil;
      if not Assigned(C) then
        Exit;

      {Look through all of the owned components}
      for I := 0 to C.ComponentCount-1 do begin
        if C.Components[I] is TApdCustomComPort then begin
          Result := TApdCustomComPort(C.Components[I]);
          Exit;
        end;

        {If this isn't one, see if it owns other components}
        Result := FindComPort(C.Components[I]);
      end;
    end;

  begin
    {Search the entire form}
    Result := FindComPort(C);
  end;

  function ComName(const ComNumber : Word) : string;
    {-Return a comname ShortString for ComNumber}
  begin
    Result := 'COM' + IntToStr(ComNumber);
  end;

function TApdCustomComPort.GetLastWinError: Integer;                        // SWB
begin                                                                       // SWB
    Result := Dispatcher.LastWinError;                                      // SWB
end;                                                                        // SWB

end.
