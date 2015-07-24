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
 *  Stephen W. Boyd     - Rewrote the Win32 dispatcher to reduce vulnerability
 *  August 2005           to badly behaved event handlers.  Rather than having
 *                        the read thread block until all events have been processed
 *                        the read thread now places input onto an 'endless'
 *                        queue.  The dispatch thread reads this queue and
 *                        calls the event handlers.  This allows input the be
 *                        continuously read from the input device while the
 *                        event handlers are executing.  Should cut down on
 *                        input overruns.  To use the old Win32 dispatcher rather
 *                        then mine define the conditional UseAwWin32 and rebuild
 *                        the library.
 *  Kevin G. McCoy
 *  1 Feb 2008          - Found and fixed the status buffer memory leak. Buffers
 *                        were being popped off the queue but not freed; Added
 *                        D2006 / D2007 compiler strings
 *
 *  Sulaiman Mah
 *  Sean B. Durkin
 *  Sebastian Zierer
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                    AWUSER.PAS 5.00                    *}
{*********************************************************}
{* Low-level dispatcher                                  *}
{*********************************************************}
{*      Thanks to David Hudder for his substantial       *}
{*  contributions to improve efficiency and reliability  *}
{*********************************************************}

{
  This unit defines the dispatcher, com and output threads. When
  a serial port is opened (Winsock does not use a multi-threaded
  architecture), these three threads are created. The dispatcher
  thread is the interface between your application and the port.
  The dispatcher thread synchronizes with the thread that opened
  the port via SendMessageTimeout, in case of timeout (usually 3
  seconds), we will discard whatever we were trying to notify you
  about and resume the thread.  For this reason, the thread that
  opened the port should not be blocked for more than a few ticks,
  and the event handler should get the data and return as quickly
  as possible. Do not do any DB or file access inside an OnTriggerXxx
  event, those actions can take too long. Instead, collect the data
  and process it later. A good approach is to collect the data,
  post a message to yourself, and process the data from the message
  handler.
  The dispatcher thread is the interface between the application
  layer and the port. The dispatcher thread runs in the context of
  the thread that opened the port. The com thread is tied to the
  serial port drivers to receive notification when things change.
  The com thread wakes the dispatcher thread, the dispatcher thread
  then generates the events. The output thread is there to process
  the internal output buffer.
  Be extrememly cautious when making changes here. The multi-threaded
  nature, and very strict timing requirements, can lead to very
  unpredictable results. Things as simple as doing a writeln to a
  console window can dramatically change the results.
}
{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$X+,B-,I-,T-,J+}

{.$DEFINE DebugThreads}

{$IFDEF CONSOLE}
{.$DEFINE DebugThreadConsole}
{$ENDIF}

{!!.02} { removed Win16 references }
unit AwUser;
  {-Basic API provided by APRO}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  MMSystem,
  OoMisc,
  AdExcept,
  LNSQueue;                                                                 // SWB

const
  FirstTriggerCounter = 1;
  MaxTriggerHandle = 65536 shr 4;{Highest trigger handle number (4096)}
  StatusTypeMask = $0007;
  ThreadStartWait = 3000;      {Milliseconds to wait for sub-threads to start}
  ModemEvent = EV_CTS or EV_DSR or EV_RLSD or EV_RING or EV_RINGTE;         // SWB
  LineEvent = EV_ERR or EV_BREAK;                                           // SWB
  {Use these event bits for fast checking of serial events}                 // SWB
  DefEventMask = ev_CTS + ev_DSR + ev_RLSD + ev_Ring + ev_RingTe +          // SWB
                 ev_RxChar + ev_Err + ev_Break;                             // SWB


type
  TApHandlerFlagUpdate = (fuKeepPort, fuEnablePort, fuDisablePort);

  TApdBaseDispatcher = class;
  TApdDispatcherThread = class(TThread)
    private
      pMsg, pTrigger : Cardinal;
      plParam : Integer;
      pTriggerEvent : TApdNotifyEvent;
      procedure SyncEvent;
    protected
      H : TApdBaseDispatcher;                                               // SWB
    public
      constructor Create(Disp : TApdBaseDispatcher);
      procedure SyncNotify(Msg, Trigger : Cardinal; lParam : Integer; Event : TApdNotifyEvent);
      procedure Sync(Method: TThreadMethod);
      property ReturnValue;                                                 // SWB
  end;

  TOutThread = class(TApdDispatcherThread)
    procedure Execute; override;
  end;

  TComThread = class(TApdDispatcherThread)
    procedure Execute; override;
  end;

  TDispThread = class(TApdDispatcherThread)
    procedure Execute; override;
  end;

  {Standard comm port record}
  TApdDispatcherClass = class of TApdBaseDispatcher;
  TApdBaseDispatcher = class
    protected
      fOwner            : TObject;
      fHandle           : Integer;    {Handle for this comm port}
      OpenHandle        : Boolean;
      CidEx             : Integer;    {Comm or other device ID}
      LastError         : Integer;    {Last error from COM API}
      InQue             : Cardinal;   {Size of device input buffer}
      OutQue            : Cardinal;   {Size of device output buffer}
      ModemStatus       : Cardinal;   {Modem status register}
      ComStatus         : TComStat;   {Results of last call for com status}
      DCB               : TDCB;       {Results of last call for DCB}
      LastBaud          : Integer;    {Last baud set}
      Flags             : Cardinal;   {Option flags}
      DTRState          : Boolean;    {Last set DTR state}
      DTRAuto           : Boolean;    {True if in handshake mode}
      RTSState          : Boolean;    {Last set RTS state}
      RTSAuto           : Boolean;    {True if in handshake mode}
      fDispatcherWindow : Cardinal;   {Handle to dispatcher window}
      LastModemStatus   : Cardinal;   {Last modem status read}
      LastLineErr       : Cardinal;   {Last line error read}
      RS485Mode         : Boolean;    {True if in RS485 mode}
      BaseAddress       : Word;       {Base address of port}

      {Trigger stuff}
      PortHandlerInstalled : Boolean; {True if any of the comport's trigger handlers <> nil}
      HandlerServiceNeeded : Boolean; {True if handlers need to be serviced}
      WndTriggerHandlers   : TList;
      ProcTriggerHandlers  : TList;
      EventTriggerHandlers : TList;
      TimerTriggers  : TList;         {Timer triggers}
      DataTriggers   : TList;         {Data triggers}
      StatusTriggers : TList;         {Status triggers}
      LastTailData   : Cardinal;      {Tail of last data checked for data}
      LastTailLen    : Cardinal;      {Tail of last data sent in len msg}
      LenTrigger     : Cardinal;      {Number of bytes before length trigger}
      GlobalStatHit  : Boolean;       {True if at least one status trigger hit}
      InAvailMessage : Boolean;       {True when within Avail msg}
      GetCount       : Cardinal;      {Chars looked at in Avail msg}
      MaxGetCount    : Cardinal;      {Max chars looked at in Avail}
      DispatchFull   : Boolean;       {True when dispatch buffer full}
      NotifyTail     : Cardinal;      {Position of last character notified}

      {Thread stuff}
      KillThreads    : Boolean;           {True to kill threads}
      ComThread      : TApdDispatcherThread;                                // SWB
      fDispThread    : TDispThread;
      OutThread      : TApdDispatcherThread;                                // SWB
      StatusThread   : TapdDispatcherThread;                                // SWB
      ThreadBoost    : Byte;
      DataSection    : TRTLCriticalSection;    {For all routines}
      OutputSection  : TRTLCriticalSection;    {For output buffer and related data}
      DispSection    : TRTLCriticalSection;    {For dispatcher buffer and related data}
      ComEvent       : THandle;                {Signals com thread is ready}
      ReadyEvent     : THandle;                {Signals completion of com thread}
      GeneralEvent   : THandle;                {For general misc signalling}
      OutputEvent    : THandle;                {Signals output buf has data to send}
      SentEvent      : THandle;                {Signals completion of overlapped write}
      OutFlushEvent  : THandle;                {Signals request to flush output buffer}
      OutWaitObjects1: array[0..1] of THandle; {Output thread wait objects}
      OutWaitObjects2: array[0..1] of THandle; {More output thread wait objects}
      CurrentEvent   : DWORD;                  {Current communications event}
      RingFlag       : Boolean;                {True when ringte event received}
      FQueue         : TIOQueue;               {Input queue}                // SWB

      { Output buffer -- protected by OutputSection }
      OBuffer       : POBuffer;          {Output buffer}
      OBufHead      : Cardinal;          {Head offset in OBuffer}
      OBufTail      : Cardinal;          {Tail offset in OBuffer}
      OBufFull      : Boolean;           {True when output buffer full}

      { Dispatcher stuff -- protected by DispSection }
      DBuffer       : PDBuffer;          {Dispatcher buffer}
      DBufHead      : Cardinal;          {Head offset in DBuffer}
      DBufTail      : Cardinal;          {Tail offset in DBuffer}
      fEventBusy    : Boolean;           {True if we're processing a COM event}
      DeletePending : Boolean;           {True if an event handler was deleted during a busy state}
      ClosePending  : Boolean;           {True if close pending}
      OutSentPending: Boolean;           {True if stOutSent trigger pending}

      {Tracing stuff}
      TracingOn     : Boolean;           {True if tracing is on}
      TraceQueue    : PTraceQueue;       {Circular trace buffer}
      TraceIndex    : Cardinal;          {Head of trace queue}
      TraceMax      : Cardinal;          {Number of trace entries}
      TraceWrapped  : Boolean;           {True if trace wrapped}

      {DispatchLogging stuff}
      DLoggingOn    : Boolean;           {True if dispatch logging is on}
      DLoggingQueue : TIOQueue;          { 'endless' dispatching buffer }   // SWB
      DLoggingMax   : Cardinal;          {Number of bytes in logging buffer}
      TimeBase      : DWORD;             {Time dispatching was turned on}

      {DispatcherMode : Cardinal;}
      TimerID        : Cardinal;
      TriggerCounter : Cardinal; {Last allocated trigger handle}
      DispActive     : Boolean;
      {Protected virtual dispatcher functions:}

      DoDonePortPrim : Boolean;
      ActiveThreads : Integer;
      CloseComActive : Boolean;                                             // SWB

      function EscapeComFunction(Func : Integer) : Integer; virtual; abstract;
      function FlushCom(Queue : Integer) : Integer; virtual; abstract;
      function GetComError(var Stat : TComStat) : Integer; virtual; abstract;
      function GetComEventMask(EvtMask : Integer) : Cardinal; virtual; abstract;
      function GetComState(var DCB: TDCB): Integer; virtual; abstract;
      function ReadCom(Buf : PAnsiChar; Size: Integer) : Integer; virtual; abstract;
      function SetComState(var DCB : TDCB) : Integer; virtual; abstract;
      function WriteCom(Buf : PAnsiChar; Size: Integer) : Integer; virtual; abstract;
      function WaitComEvent(var EvtMask : DWORD;
        lpOverlapped : POverlapped) : Boolean; virtual; abstract;
      function SetupCom(InSize, OutSize : Integer) : Boolean; virtual; abstract;

      function CheckReceiveTriggers : Boolean;
      function CheckStatusTriggers : Boolean;
      function CheckTimerTriggers : Boolean;
      function CheckTriggers : Boolean;
      procedure CreateDispatcherWindow;
      procedure DonePortPrim; virtual;
      function DumpDispatchLogPrim(
                                  FName : string;
                                  AppendFile, InHex, AllHex : Boolean) : Integer;
      function DumpTracePrim(FName : string;
                          AppendFile, InHex, AllHex : Boolean) : Integer;
      function ExtractData : Boolean;
      function FindTriggerFromHandle(TriggerHandle : Cardinal; Delete : Boolean;
                                     var T : TTriggerType; var Trigger : Pointer) : Integer;
      function GetDispatchTime : DWORD;
      function GetModemStatusPrim(ClearMask : Byte) : Byte;
      function GetTriggerHandle : Cardinal;

      procedure MapEventsToMS(Events : Integer);
      function PeekBlockPrim(
                            Block : PAnsiChar;
                            Offset : Cardinal;
                            Len : Cardinal;
                            var NewTail : Cardinal) : Integer;
      function PeekCharPrim(var C : AnsiChar; Count : Cardinal) : Integer;
      procedure RefreshStatus;
      procedure ResetStatusHits;
      procedure ResetDataTriggers;
      function SendNotify(Msg, Trigger, Data: Cardinal) : Boolean;
      function SetCommStateFix(var DCB : TDCB) : Integer;
      procedure StartDispatcher; virtual; abstract;
      procedure StopDispatcher;  virtual; abstract;
      procedure ThreadGone(Sender: TObject);                                // SWB
      procedure ThreadStart(Sender : TObject);                              // SWB
      procedure WaitTxSent;
      function OutBufUsed: Cardinal; virtual; abstract;                     // SWB
      function InQueueUsed : Cardinal; virtual;                             // SWB
    public
      DataPointers  : TDataPointerArray; {Array of data pointers}
      DeviceName    : string; {Name of device being used, for log }
      LastWinError  : Integer;                                              // SWB

      property Active : Boolean read DispActive;
      property Logging : Boolean read DLoggingOn;
      procedure AddDispatchEntry(
                                 DT : TDispatchType;
                                 DST : TDispatchSubType;
                                 Data : Cardinal;
                                 Buffer : Pointer;
                                 BufferLen : Cardinal);
      procedure AddStringToLog(S : Ansistring);
      property ComHandle : Integer read CidEx;
      {Public virtual dispatcher functions:}
      function OpenCom(ComName: PChar; InQueue,
        OutQueue : Cardinal) : Integer; virtual; abstract;
      function CloseCom : Integer; virtual; abstract;
      function CheckPort(ComName: PChar): Boolean; virtual; abstract;  //SZ

      property DispatcherWindow : Cardinal read fDispatcherWindow;
      property DispThread : TDispThread read fDispThread;
      property EventBusy : boolean read fEventBusy write fEventBusy;
      property Handle : Integer read fHandle;
      property Owner : TObject read fOwner;

      constructor Create(Owner : TObject);
      destructor Destroy; override;

      procedure AbortDispatchLogging;
      procedure AbortTracing;
      function AddDataTrigger(Data : PAnsiChar; // --sm PansiChar
                               IgnoreCase : Boolean) : Integer;
      function AddDataTriggerLen(Data : PAnsiChar;  // --sm Pansichar
                              IgnoreCase : Boolean;
                              Len : Cardinal) : Integer;
      function AddStatusTrigger(SType : Cardinal) : Integer;
      function AddTimerTrigger : Integer;
      procedure AddTraceEntry(CurEntry : AnsiChar; CurCh : AnsiChar);
      function AppendDispatchLog(FName : string;
                                  InHex, AllHex : Boolean) : Integer;
      function AppendTrace(FName : string;
                            InHex, AllHEx : Boolean) : Integer;
      procedure BufferSizes(var InSize, OutSize : Cardinal);
      function ChangeBaud(NewBaud : Integer) : Integer;
      procedure ChangeLengthTrigger(Length : Cardinal);
      function CheckCTS : Boolean;
      function CheckDCD : Boolean;
      function CheckDeltaCTS : Boolean;
      function CheckDeltaDSR : Boolean;
      function CheckDeltaRI : Boolean;
      function CheckDeltaDCD : Boolean;
      function CheckDSR : Boolean;
      function CheckLineBreak : Boolean;
      function CheckRI : Boolean;
      function ClassifyStatusTrigger(TriggerHandle : Cardinal) : Cardinal;
      procedure ClearDispatchLogging;
      class procedure ClearSaveBuffers(var Save : TTriggerSave);
      function ClearTracing : Integer;
      procedure DeregisterWndTriggerHandler(HW : TApdHwnd);
      procedure DeregisterProcTriggerHandler(NP : TApdNotifyProc);
      procedure DeregisterEventTriggerHandler(NP : TApdNotifyEvent);
      procedure DonePort;
      function DumpDispatchLog(FName : string; InHex, AllHex : Boolean) : Integer;
      function DumpTrace(FName : string; InHex, AllHex : Boolean) : Integer;
      function ExtendTimer(TriggerHandle : Cardinal;
        Ticks : Integer) : Integer;
      function FlushInBuffer : Integer;
      function FlushOutBuffer : Integer;
      function CharReady : Boolean;
      function GetBaseAddress : Word;
      function GetBlock(Block : PAnsiChar; Len : Cardinal) : Integer;
      function GetChar(var C : AnsiChar) : Integer;
      function GetDataPointer(var P : Pointer; Index : Cardinal) : Integer;
      function GetFlowOptions(var HWOpts, SWOpts, BufferFull,
        BufferResume : Cardinal; var OnChar, OffChar : AnsiChar): Integer;
      procedure GetLine(var Baud : Integer; var Parity : Word;
        var DataBits : TDatabits; var StopBits : TStopbits);
      function GetLineError : Integer;
      function GetModemStatus : Byte;
      function HWFlowOptions(BufferFull, BufferResume : Cardinal;
        Options : Cardinal) : Integer;
      function HWFlowState : Integer;
      function InBuffUsed : Cardinal;
      function InBuffFree : Cardinal;
      procedure InitDispatchLogging(QueueSize : Cardinal);
      function InitPort(AComName : PChar; Baud : Integer;
        Parity : Cardinal; DataBits : TDatabits; StopBits : TStopbits;
        InSize, OutSize : Cardinal; FlowOpts : DWORD) : Integer;
      function InitSocket(InSize, OutSize : Cardinal) : Integer;
      function InitTracing(NumEntries : Cardinal) : Integer;
      function OptionsAreOn(Options : Cardinal) : Boolean;
      procedure OptionsOn(Options : Cardinal);
      procedure OptionsOff(Options : Cardinal);
      function OutBuffUsed : Cardinal;
      function OutBuffFree : Cardinal;
      function PeekBlock(Block : PAnsiChar; Len : Cardinal) : Integer;
      function PeekChar(var C : AnsiChar; Count : Cardinal) : Integer;
      function ProcessCommunications : Integer; virtual; abstract;
      function PutBlock(const Block; Len : Cardinal) : Integer;
      function PutChar(C : AnsiChar) : Integer; // --sm ansi
      function PutString(S : AnsiString) : Integer;
      procedure RegisterWndTriggerHandler(HW : TApdHwnd);
      procedure RegisterProcTriggerHandler(NP : TApdNotifyProc);
      procedure RegisterSyncEventTriggerHandler(NP : TApdNotifyEvent);
      procedure RegisterEventTriggerHandler(NP : TApdNotifyEvent);
      procedure RemoveAllTriggers;
      function RemoveTrigger(TriggerHandle : Cardinal) : Integer;
      procedure RestoreTriggers( var Save : TTriggerSave);
      procedure SaveTriggers( var Save : TTriggerSave);
      procedure SetBaseAddress(NewBaseAddress : Word);
      procedure SendBreak(Ticks : Cardinal; Yield : Boolean);
      procedure SetBreak(BreakOn : Boolean);
      procedure SetThreadBoost(Boost : Byte); virtual;
      function SetDataPointer( P : Pointer; Index : Cardinal) : Integer;
      function SetDtr(OnOff : Boolean) : Integer;
      procedure SetEventBusy(var WasOn : Boolean; SetOn : Boolean);
      procedure SetRS485Mode(OnOff : Boolean);
      function SetRts(OnOff : Boolean) : Integer;
      function SetLine(Baud : Integer; Parity : Cardinal;
        DataBits : TDatabits; StopBits : TStopbits) : Integer;
      function SetModem(DTR, RTS : Boolean) : Integer;
      function SetStatusTrigger(TriggerHandle : Cardinal;
        Value : Cardinal; Activate : Boolean) : Integer;
      function SetTimerTrigger(TriggerHandle : Cardinal;
        Ticks : Integer; Activate : Boolean) : Integer;
      function SetCommBuffers(InSize, OutSize : Integer) : Integer;
      procedure StartDispatchLogging;
      procedure StartTracing;
      procedure StopDispatchLogging;
      procedure StopTracing;
      function SWFlowChars( OnChar, OffChar : AnsiChar) : Integer;
      function SWFlowDisable : Integer;
      function SWFlowEnable(BufferFull, BufferResume : Cardinal;
        Options : Cardinal) : Integer;
      function SWFlowState : Integer;
      function TimerTicksRemaining(TriggerHandle : Cardinal;
        var TicksRemaining : Integer) : Integer;
      procedure UpdateHandlerFlags(FlagUpdate : TApHandlerFlagUpdate); virtual;
  end;

function GetTComRecPtr(Cid : Integer; DeviceLayerClass : TApdDispatcherClass) : Pointer;

var
  PortList : TList;

procedure LockPortList;
procedure UnlockPortList;
function PortIn(Address: Word): Byte;                                       // SWB

implementation

uses
  AnsiStrings;

var
  PortListSection : TRTLCriticalSection;

const
  { This should be the same in ADSOCKET.PAS }
  CM_APDSOCKETMESSAGE = WM_USER + $0711;

  {For setting stop bits}
  StopBitArray : array[TStopbits] of Byte = (OneStopbit, TwoStopbits, 0);

  {For quick checking and disabling of all flow control options}
  InHdwFlow  = dcb_DTRBit2 + dcb_RTSBit2;
  OutHdwFlow = dcb_OutxDSRFlow + dcb_OutxCTSFlow;
  AllHdwFlow = InHdwFlow + OutHdwFlow;
  AllSfwFlow = dcb_InX + dcb_OutX;

  {Mask of errors we care about}
  ValidErrorMask =
    ce_RXOver   +  {receive queue overflow}
    ce_Overrun  +  {receive overrun error}
    ce_RXParity +  {receive parity error}
    ce_Frame    +  {receive framing error}
    ce_Break;      {break detected}

  {For clearing modem status}
  ClearDelta    = $F0;
  ClearNone     = $FF;
  ClearDeltaCTS = Byte(not DeltaCTSMask);
  ClearDeltaDSR = Byte(not DeltaDSRMask);
  ClearDeltaRI  = Byte(not DeltaRIMask);
  ClearDeltaDCD = Byte(not DeltaDCDMask);

{General purpose routines}

const
  LastCID : Integer = -1;
  LastDispatcher : TApdBaseDispatcher = nil;

//SZ: this was removed, but it is needed by AWWNSOCK.pas
function GetTComRecPtr(Cid : Integer; DeviceLayerClass : TApdDispatcherClass) : Pointer;
  {-Find the entry into the port array which has the specified Cid}
var
  i : Integer;
begin
  LockPortList;
  try
    {find the correct com port record}
    if (LastCID = Cid) and (LastDispatcher <> nil) then
      Result := LastDispatcher
    else begin
      for i := 0 to pred(PortList.Count) do
        if PortList[i] <> nil then
          with TApdBaseDispatcher(PortList[i]) do
            if (CidEx = Cid) and (TObject(PortList[i]) is DeviceLayerClass) then begin
              Result := TApdBaseDispatcher(PortList[i]);
              LastCID := Cid;
              LastDispatcher := Result;
              exit;
            end;
      Result := nil;
    end;
  finally
    UnlockPortList;
  end;
end;

{$IFDEF DebugThreadConsole}
  type
    TThreadStatus = (ComStart, ComWake, ComSleep, ComKill,
                     DispStart, DispWake, DispSleep, DispKill,
                     OutStart, OutWake, OutSleep, OutKill);
  var
    C, D, O : Char;                                                      {!!.02}
  function ThreadStatus(Stat : TThreadStatus) : string;
  begin
    C := '.';                                                            {!!.02}
    D := '.';                                                            {!!.02}
    O := '.';                                                            {!!.02}
    case Stat of
      ComStart,
      ComWake    : C := 'C';
      ComSleep   : C := 'c';
      ComKill    : C := 'x';
      DispStart,
      DispWake   : D := 'D';
      DispSleep  : D := 'd';
      DispKill   : D := 'x';
      OutStart,
      OutWake    : O := 'O';
      OutSleep   : O := 'o';
      OutKill    : O := 'x';
    end;
    Result := C + D + O + ' ' + IntToStr(AdTimeGetTime);
  end;
{$ENDIF}

  function BuffCount(Head, Tail: Cardinal; Full : Boolean) : Cardinal;
    {-Return number of chars between Tail and Head}
  begin
    if Head = Tail then
      if Full then
        BuffCount := DispatchBufferSize
      else
        BuffCount := 0
    else if Head > Tail then
      BuffCount := Head-Tail
    else
      BuffCount := (Head+DispatchBufferSize)-Tail;
  end;

  function TApdBaseDispatcher.InQueueUsed : Cardinal;                       // SWB
  begin                                                                     // SWB
    Result := 0;                                                            // SWB
  end;                                                                      // SWB

  procedure TApdBaseDispatcher.ThreadGone(Sender: TObject);
  begin
    try                                                                     // SWB
        CheckException(TComponent(Owner),                                   // SWB
                       TApdDispatcherThread(Sender).ReturnValue);           // SWB
    except                                                                  // SWB
      on E : Exception do                                                   // SWB
      begin                                                                 // SWB
        ShowException(E, ExceptAddr);                                       // SWB
      end;                                                                  // SWB
    end;                                                                    // SWB

    if Sender = ComThread then
      ComThread := nil;

    if Sender = OutThread then
      OutThread := nil;

    if Sender = fDispThread then begin
      fDispThread := nil;
      if DoDonePortPrim then begin
        DonePortPrim;
        DoDonePortPrim := False;
      end;
    end;

    if Sender = StatusThread then                                           // SWB
        StatusThread := nil;                                                // SWB

    if (InterLockedDecrement(ActiveThreads) = 0) then begin
      DispActive := False;
    end;
  end;

  procedure TApdBaseDispatcher.ThreadStart(Sender : TObject);               // SWB
  begin                                                                     // SWB
    InterLockedIncrement(ActiveThreads);                                    // SWB
    SetEvent(GeneralEvent);                                                 // SWB
  end;                                                                      // SWB

  procedure TApdBaseDispatcher.SetThreadBoost(Boost : Byte);
  begin
    if Boost <> ThreadBoost then begin
      ThreadBoost := Boost;

      if Assigned(ComThread) then
        ComThread.Priority := TThreadPriority(Ord(tpNormal) + Boost);

      if Assigned(fDispThread) then
        fDispThread.Priority := TThreadPriority(Ord(tpNormal) + Boost);

      if Assigned(fDispThread) then
        if RS485Mode then
          OutThread.Priority := TThreadPriority(Ord(tpHigher) + Boost)
        else
          OutThread.Priority := TThreadPriority(Ord(tpNormal) + Boost);

      if Assigned(StatusThread) then                                        // SWB
        StatusThread.Priority := TThreadPriority(Ord(tpNormal) + Boost);    // SWB
    end;
  end;

  constructor TApdBaseDispatcher.Create(Owner : TObject);
  var
    i : Integer;
  begin
    inherited Create;
    fOwner := Owner;
    ComEvent := INVALID_HANDLE_VALUE;
    ReadyEvent := INVALID_HANDLE_VALUE;
    GeneralEvent := INVALID_HANDLE_VALUE;
    OutputEvent := INVALID_HANDLE_VALUE;
    SentEvent := INVALID_HANDLE_VALUE;
    OutFlushEvent := INVALID_HANDLE_VALUE;

    LockPortList;
    try
    {Find a free slot in PortListX or append if none found (see Destroy) }
      fHandle := -1;
      for i := 0 to pred(PortList.Count) do
        if PortList[i] = nil then begin
          PortList[i] := Self;
          fHandle := i;
          break;
        end;
      if fHandle = -1 then
        fHandle := PortList.Add(Self);
    finally
      UnlockPortList;
    end;
    {Allocate critical section objects}
    FillChar(DataSection, SizeOf(DataSection), 0);
    InitializeCriticalSection(DataSection);

    FillChar(OutputSection, SizeOf(OutputSection), 0);
    InitializeCriticalSection(OutputSection);

    FillChar(DispSection, SizeOf(DispSection), 0);
    InitializeCriticalSection(DispSection);
    WndTriggerHandlers := TList.Create;
    ProcTriggerHandlers := TList.Create;
    EventTriggerHandlers := TList.Create;
    TimerTriggers := TList.Create;
    DataTriggers  := TList.Create;
    StatusTriggers:= TList.Create;
    TriggerCounter := FirstTriggerCounter;
    FQueue := TIOQueue.Create;                                              // SWB
    DLoggingQueue := TIOQueue.Create;                                       // SWB
  end;

  destructor TApdBaseDispatcher.Destroy;
  var
    i : Integer;
  begin
    if ClosePending then begin
      DonePortPrim
    end else
      DonePort;

    { it's possible for the main VCL thread (or whichever thread opened }
    { the port) to destroy the dispatcher while we're still waiting for }
    { our Com, Output and Dispatcher threads to terminate, we'll spin   }
    { here waiting for the threads to terminate.                        }
    while ActiveThreads > 0 do                                           {!!.02}
      SafeYield;                                                         {!!.02}

    LockPortList;
    try
      { We can't just call Remove since there may be other ports open where }
      { we use the index into the PortListX array as a handle }
      PortList[PortList.IndexOf(Self)] := nil;
      for i := PortList.Count - 1 downto 0 do
        if PortList[i] = nil then
          PortList.Delete(i)
        else
          break;
      if LastDispatcher = Self then begin
        LastDispatcher := nil;
        LastCID := -1;
      end;
    finally
      UnlockPortList;
    end;

    while TimerTriggers.Count > 0 do begin
      Dispose(PTimerTrigger(TimerTriggers[0]));
      TimerTriggers.Delete(0);
    end;
    TimerTriggers.Free;

    while DataTriggers.Count > 0 do begin
      Dispose(PDataTrigger(DataTriggers[0]));
      DataTriggers.Delete(0);
    end;
    DataTriggers.Free;

    while StatusTriggers.Count > 0 do begin
      Dispose(PStatusTrigger(StatusTriggers[0]));
      StatusTriggers.Delete(0);
    end;
    StatusTriggers.Free;

    while WndTriggerHandlers.Count > 0 do begin
      Dispose(PWndTriggerHandler(WndTriggerHandlers[0]));
      WndTriggerHandlers.Delete(0);
    end;
    WndTriggerHandlers.Free;

    while ProcTriggerHandlers.Count > 0 do begin
      Dispose(PProcTriggerHandler(ProcTriggerHandlers[0]));
      ProcTriggerHandlers.Delete(0);
    end;
    ProcTriggerHandlers.Free;

    while EventTriggerHandlers.Count > 0 do begin
      Dispose(PEventTriggerHandler(EventTriggerHandlers[0]));
      EventTriggerHandlers.Delete(0);
    end;
    EventTriggerHandlers.Free;

    {Free the critical sections}
    DeleteCriticalSection(DataSection);
    DeleteCriticalSection(OutputSection);
    DeleteCriticalSection(DispSection);

    if (Assigned(FQueue)) then                                              // SWB
        FQueue.Free;                                                        // SWB
    if (Assigned(DLoggingQueue)) then                                       // SWB
        DLoggingQueue.Free;                                                 // SWB

    inherited Destroy;
  end;

  procedure TApdBaseDispatcher.RefreshStatus;
    {-Get current ComStatus}
  var
    NewError : Integer;
  begin
    {Get latest ComStatus and LastError}
    NewError := GetComError(ComStatus);

    {Mask off those bits we don't care about}
    LastError := LastError or (NewError and ValidErrorMask);
  end;

  procedure TApdBaseDispatcher.MapEventsToMS(Events : Integer);
    {-Set bits in ModemStatus according to flags in Events}
  var
    OldMS : Byte;
    Delta : Byte;
  begin
    {Note old, get new}
    OldMS := ModemStatus;
    GetModemStatusPrim($FF);

    {Set delta bits}
    Delta := (OldMS xor ModemStatus) and $F0;
    ModemStatus := ModemStatus or (Delta shr 4);
  end;

{Routines used by constructor}

  procedure TApdBaseDispatcher.RemoveAllTriggers;
    {-Remove all triggers}
  begin
    EnterCriticalSection(DataSection);
    try
      LenTrigger := 0;
      while TimerTriggers.Count > 0 do begin
        Dispose(PTimerTrigger(TimerTriggers[0]));
        TimerTriggers.Delete(0);
      end;
      while DataTriggers.Count > 0 do begin
        Dispose(PDataTrigger(DataTriggers[0]));
        DataTriggers.Delete(0);
      end;
      while StatusTriggers.Count > 0 do begin
        Dispose(PStatusTrigger(StatusTriggers[0]));
        StatusTriggers.Delete(0);
      end;

      TriggerCounter := FirstTriggerCounter;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.SetCommStateFix(var DCB : TDCB) : Integer;
    {-Preserve DTR and RTS states}
  begin
    if not DTRAuto then begin
      DCB.Flags := DCB.Flags and not (dcb_DTRBit1 or dcb_DTRBit2);
      if DTRState then begin
        { Assert DTR }
        DCB.Flags := DCB.Flags or dcb_DTR_CONTROL_ENABLE;
      end;
    end;
    if not RTSAuto then begin
      DCB.Flags := DCB.Flags and not (dcb_RTSBit1 or dcb_RTSBit2);
      if RTSState then begin
        { Assert RTS }
        DCB.Flags := DCB.Flags or dcb_RTS_CONTROL_ENABLE;
      end;
    end;
    Result := SetComState(DCB);
    LastBaud := DCB.BaudRate;
    SetDtr(DtrState);
    if not RS485Mode then
      SetRts(RtsState);
  end;

  procedure TApdBaseDispatcher.ResetStatusHits;
  var
    i : Integer;
  begin
    for i := pred(StatusTriggers.Count) downto 0 do
      PStatusTrigger(StatusTriggers[i])^.StatusHit := False;
    GlobalStatHit := False;
  end;

  procedure TApdBaseDispatcher.ResetDataTriggers;
  var
    i : Integer;
  begin
    for i := pred(DataTriggers.Count) downto 0 do
      with PDataTrigger(DataTriggers[i])^ do
        FillChar(tChkIndex, SizeOf(TCheckIndex), 0);
  end;

  function TApdBaseDispatcher.InitPort(
                         AComName : PChar;
                         Baud : Integer;
                         Parity : Cardinal;
                         DataBits : TDatabits;
                         StopBits : TStopbits;
                         InSize, OutSize : Cardinal;
                         FlowOpts : DWORD) : Integer;
  type
    OS = record
      O : Cardinal;
      S : Cardinal;
    end;
  var
    Error : Integer;
  begin
    RingFlag := False;

    {Required inits in case DonePort is called}
    DBuffer := nil;
    OBuffer := nil;
    fEventBusy := False;
    DeletePending := False;

    {Create event objects}
    ComEvent := CreateEvent(nil, False, False, nil);
    ReadyEvent := CreateEvent(nil, False, False, nil);
    GeneralEvent := CreateEvent(nil, False, False, nil);
    OutputEvent := CreateEvent(nil, False, False, nil);
    SentEvent := CreateEvent(nil, True, False, nil);
    OutFlushEvent := CreateEvent(nil, False, False, nil);
    {wake up xmit thread when it's waiting for data}
    OutWaitObjects1[0] := OutputEvent;
    OutWaitObjects1[1] := OutFlushEvent;
    {wake up xmit thread when it's waiting for i/o completion}
    OutWaitObjects2[0] := SentEvent;
    OutWaitObjects2[1] := OutFlushEvent;

    {Ask Windows to open the comm port}
    CidEx := OpenCom(AComName, InSize, OutSize);
    if CidEx < 0 then begin
      if CidEx = ecOutOfMemory then
        Result := ecOutOfMemory
      else
        Result := -Integer(GetLastError);
      DonePort;
      Exit;
    end;

    {set the buffer sizes}
    Result := SetCommBuffers(InSize, OutSize);
    if Result <> 0 then begin
      DonePort;
      Exit;
    end;

    {Allocate dispatch buffer}
    DBuffer := AllocMem(DispatchBufferSize);

    {Allocate output buffer}
    OBuffer := AllocMem(OutSize);
    OBufHead := 0;
    OBufTail := 0;
    OBufFull := False;

    {Initialize fields}
    InQue := InSize;
    OutQue := OutSize;
    LastError := 0;
    OutSentPending := False;
    ClosePending := False;
    fDispatcherWindow := 0;
    DispatchFull := False;
    GetCount := 0;
    LastLineErr := 0;
    LastModemStatus := 0;
    RS485Mode := False;
    BaseAddress := 0;

    {Assure DCB is up to date in all cases}
    GetComState(DCB);

    { Set initial flow control options }
    if (FlowOpts and ipAutoDTR) <> 0 then begin
      DTRAuto := True;
    end else begin
      DTRAuto := False;
      SetDTR((FlowOpts and ipAssertDTR) <> 0);
    end;

    if (FlowOpts and ipAutoRTS) <> 0 then begin
      RTSAuto := True;
    end else begin
      RTSAuto := False;
      SetRTS((FlowOpts and ipAssertRTS) <> 0);
    end;

    {Trigger inits}
    LastTailData := 0;
    LastTailLen := 1;
    RemoveAllTriggers;
    DBufHead := 0;
    DBufTail := 0;
    NotifyTail := 0;
    ResetStatusHits;

    InAvailMessage := False;

    ModemStatus := 0;
    GetModemStatusPrim($F0);

    {Set the requested line parameters}
    LastBaud := 115200;

    Error := SetLine(Baud, Parity, DataBits, StopBits);
    if Error <> ecOk then begin
      Result := Error;
      DonePort;
      Exit;
    end;

    {Get initial status}
    RefreshStatus;

    TracingOn := False;
    TraceQueue := nil;
    TraceIndex := 0;
    TraceMax := 0;
    TraceWrapped := False;

    TimeBase := AdTimeGetTime;
    DLoggingOn := False;
    DLoggingMax := 0;

    {Start the dispatcher}
    StartDispatcher;
  end;

  function TApdBaseDispatcher.InitSocket(Insize, OutSize : Cardinal) : Integer;
  begin
    Result := ecOK;

    {Create a socket}
    CidEx := OpenCom(nil, InSize, OutSize);
    if CidEx < 0 then begin
      Result := -CidEx;
      DonePort;
      Exit;
    end;

    {Connect or bind socket}
    if not SetupCom(0, 0) then begin
      Result := -GetComError(ComStatus);
      DonePort;
      Exit;
    end;

    {Allocate dispatch buffer}
    DBuffer := AllocMem(DispatchBufferSize);

    {Initialize fields}
    InQue := InSize;
    OutQue := OutSize;

    {Trigger inits}
    LastTailLen := 1;

    {Set default options}
    ModemStatus := 0;

    {Get initial status}
    RefreshStatus;

    TimeBase := AdTimeGetTime;

    {Start the dispatcher}
    StartDispatcher;
  end;

  function TApdBaseDispatcher.SetCommBuffers(InSize, OutSize : Integer) : Integer;
    {-Set the new buffer sizes, win32 only}
  begin
    if SetupCom(InSize, OutSize) then
      Result := ecOK
    else
      Result := -Integer(GetLastError);
  end;

  procedure TApdBaseDispatcher.DonePortPrim;
    {-Close the port and free the handle}
  begin
    {Stop dispatcher}
      DoDonePortPrim := False;                                           {!!.02}
      if DispActive then
        StopDispatcher;
      { Free memory for the output buffer }
      EnterCriticalSection(DataSection);
      try
          if OBuffer <> nil then begin
            FreeMem(OBuffer);
            OBuffer := nil;
          end;

          { Free memory for the dispatcher buffer }
          if DBuffer <> nil then begin
            FreeMem(DBuffer, DispatchBufferSize);
            DBuffer := nil;
          end;
      finally
        LeaveCriticalSection(DataSection);
      end;
  end;

  procedure TApdBaseDispatcher.DonePort;
    {-Close the port and free the handle}
  begin
    {Always close the physical port...}
    if CidEx >= 0 then begin
      {Flush the output queue}
      FlushOutBuffer;
      FlushInBuffer;

      CloseCom;
    end;

    {...but destroy our object only if not within a notify}
    if fEventBusy then begin
      ClosePending := True;
    end else
      DonePortPrim;
  end;

  function ActualBaud(BaudCode : Integer) : Integer;
  const
    BaudTable : array[0..23] of Integer =
      (110,    300,    600,    1200,    2400,    4800,    9600,    14400,
       19200,  0,      0,      38400,   0,       0,       0,       56000,
       0,      0,      0,      128000,  0,       0,       0,       256000);
  var
    Index : Cardinal;
    Baud : Integer;
  begin
    if BaudCode = $FEFF then
      {COMM.DRV's 115200 hack}
      Result := 115200
    else if BaudCode < $FF10 then
      {Must be a baud rate, return it}
      Result := BaudCode
    else begin
      {It's a code, look it up}
      Index := BaudCode - $FF10;
      if Index > 23 then
        {Unknown code, just return it}
        Result := BaudCode
      else begin
        Baud := BaudTable[Index];
        if Baud = 0 then
          {Unknown code, just return it}
          Result := BaudCode
        else
          Result := Baud;
      end;
    end;
  end;

  { Wait till pending Tx Data is sent for H -- used for line parameter }
  { changes -- so the data in the buffer at the time the change is made }
  { goes out under the "old" line parameters. }
  procedure TApdBaseDispatcher.WaitTxSent;
  var
    BitsPerChar     : DWORD;
    BPS             : Integer;
    MicroSecsPerBit : DWORD;
    MicroSecs       : DWORD;
    MilliSecs       : DWORD;
    TxWaitCount     : Integer;
  begin
    { Wait till our Output Buffer becomes free. }
    { If output hasn't drained in 10 seconds, punt. }
    TxWaitCount := 0;
    while((OutBuffUsed > 0) and (TxWaitCount < 5000)) do begin
      Sleep(2);
      Inc(TxWaitCount);
    end;

    { Delay based upon a 16-character TX FIFO + 1 character for TX output }
    { register + 1 extra character for slop (= 18).  Delay is based upon }
    { 1/bps * (start bit + data bits + parity bit + stop bits). }

    GetComState(DCB);
    BitsPerChar := DCB.ByteSize + 2;   { Bits per Char + 1 start + 1 stop }
    if (DCB.Parity <> 0) then
      Inc(BitsPerChar);
    if (DCB.StopBits <> 0) then
      Inc(BitsPerChar);
    BPS := ActualBaud(LastBaud);
    MicroSecsPerBit := 10000000 div BPS;
    MicroSecs := MicroSecsPerBit * BitsPerChar * 18;
    if (MicroSecs < 10000) then
      MicroSecs := MicroSecs + MicroSecs;
    MilliSecs := Microsecs div 10000;
    if ((Microsecs mod 10000) <> 0) then
      Inc(MilliSecs);
    Sleep(MilliSecs);
  end;

  function TApdBaseDispatcher.SetLine(
                    Baud : Integer;
                    Parity : Cardinal;
                    DataBits : TDatabits;
                    StopBits : TStopbits) : Integer;
  var
    NewBaudRate  : DWORD;
    NewParity    : Cardinal;
    NewByteSize  : TDatabits;
    NewStopBits  : Byte;
    NewFlags     : Integer;                                                 // SWB
    {-Set or change the line parameters}
  begin
    Result := ecOK;
    EnterCriticalSection(DataSection);
    try
      {Get current DCB parameters}
      GetComState(DCB);

      {Set critical default DCB options}
      NewFlags := DCB.Flags;                                                // SWB
      NewFlags := NewFlags or dcb_Binary;                                   // SWB
      NewFlags := NewFlags and not dcb_Parity;                              // SWB
      NewFlags := NewFlags and not dcb_DsrSensitivity;                      // SWB
      NewFlags := NewFlags or dcb_TxContinueOnXoff;                         // SWB
      NewFlags := NewFlags and not dcb_Null;                                // SWB
      NewFlags := NewFlags and not dcb_Null;                                // SWB

      {Validate stopbit range}
      if StopBits <> DontChangeStopBits then
        if StopBits < 1 then
          StopBits := 1
        else if StopBits > 2 then
          StopBits := 2;

      {Determine new line parameters}
      if Baud <> DontChangeBaud then begin
        NewBaudRate := Baud;
      end else
        NewBaudRate := DCB.BaudRate;

      if Parity <> DontChangeParity then
        NewParity := Parity
      else
        NewParity := DCB.Parity;

      NewStopBits := DCB.StopBits;

      if DataBits <> DontChangeDataBits then
      begin
        NewByteSize := DataBits;
        if (DataBits = 5) then
          NewStopBits := One5StopBits;
      end else
        NewByteSize := DCB.ByteSize;

      if StopBits <> DontChangeStopBits then begin
        NewStopBits := StopBitArray[StopBits];
        if (NewByteSize = 5) then
          NewStopBits := One5StopBits;
      end;
    finally
      LeaveCriticalSection(DataSection);
    end;

    if ((DCB.BaudRate = NewBaudRate) and
        (DCB.Parity = NewParity) and
        (DCB.ByteSize = NewByteSize) and
        (DCB.StopBits = NewStopBits) and                                    // SWB
        (DCB.Flags = NewFlags)) then                                        // SWB
      Exit;

    { wait for the chars to be transmitted, don't want to change line }
    { settings while chars are pending }
    WaitTxSent;

    EnterCriticalSection(DataSection);
    try
      {Get current DCB parameters}
      GetComState(DCB);

      {Change the parameters}
      DCB.BaudRate := NewBaudRate;
      DCB.Parity   := NewParity;
      DCB.ByteSize := NewByteSize;
      DCB.StopBits := NewStopBits;
      DCB.Flags := NewFlags;                                                // SWB

      {Set line parameters}
      Result := SetCommStateFix(DCB);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.GetLine(
                    var Baud : Integer;
                    var Parity : Word;
                    var DataBits : TDatabits;
                    var StopBits : TStopbits);
    {-Return line parameters}
  begin
    EnterCriticalSection(DataSection);
    try
      {Get current DCB parameters}
      GetComState(DCB);

      {Return the line parameters}
      Baud := ActualBaud(DCB.Baudrate);

      Parity := DCB.Parity;
      DataBits := DCB.ByteSize;
      if DCB.StopBits = OneStopBit then
        StopBits := 1
      else
        StopBits := 2;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.SetModem(Dtr, Rts : Boolean) : Integer;
    {-Set modem control lines, Dtr and Rts}
  begin
    Result := SetDtr(Dtr);
    if Result = ecOK then
      Result := SetRts(Rts);                                             {!!.02}
  end;

  function TApdBaseDispatcher.SetDtr(OnOff : Boolean) : Integer;
    {-Set DTR modem control line}
  begin
    if DtrAuto then begin
      { We can't change DTR if we're controlling it automatically }
      Result := 1;
      Exit;
    end;

    if (OnOff = True) then
      Result := EscapeComFunction(Windows.SETDTR)
    else
      Result := EscapeComFunction(Windows.CLRDTR);

    if (Result < ecOK) then
      Result := ecBadArgument;
    DTRState := OnOff;
  end;

  function TApdBaseDispatcher.SetRts(OnOff : Boolean) : Integer;
    {-Set RTS modem control line}
  begin
    if RtsAuto then begin
      { We can't change RTS if we're controlling it automatically }
      Result := 1;
      Exit;
    end;

    if (OnOff = True) then
      Result := EscapeComFunction(Windows.SETRTS)
    else
      Result := EscapeComFunction(Windows.CLRRTS);

    if (Result < ecOK) then
      Result := ecBadArgument;
    RTSState := OnOff;
  end;

  function TApdBaseDispatcher.GetModemStatusPrim(ClearMask : Byte) : Byte;
    {-Primitive to return the modem status and clear mask}
  var
    Data : DWORD;
  begin
    {Get the new absolute values}
    // There is no reason for this to be inside the critical section        // SWB
    // and since this can be a very slow function when using mapped         // SWB
    // comm ports under Citrix or W2K3 I moved it out here.                 // SWB
    GetCommModemStatus(CidEx, Data);                                        // SWB
    EnterCriticalSection(DataSection);
    try
      ModemStatus := (ModemStatus and $0F) or Byte(Data);

      {Special case, transfer RI bit to TERI bit}
      if RingFlag then begin
        RingFlag := False;
        ModemStatus := ModemStatus or $04;
      end;

      {Return the current ModemStatus value}
      Result := Lo(ModemStatus);

      {Clear specified delta bits}
      ModemStatus := ModemStatus and Clearmask;

    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.GetModemStatus : Byte;
    {-Return the modem status byte and clear the delta bits}
  begin
    Result := GetModemStatusPrim(ClearDelta);
  end;

  function TApdBaseDispatcher.CheckCTS : Boolean;
    {-Returns True if CTS is high}
  begin
    Result := GetModemStatusPrim(ClearDeltaCTS) and CTSMask = CTSMask;
  end;

  function TApdBaseDispatcher.CheckDSR : Boolean;
    {-Returns True if DSR is high}
  begin
    Result := GetModemStatusPrim(ClearDeltaDSR) and DSRMask = DSRMask;
  end;

  function TApdBaseDispatcher.CheckRI : Boolean;
    {-Returns True if RI is high}
  begin
    Result := GetModemStatusPrim(ClearDeltaRI) and RIMask = RIMask;
  end;

  function TApdBaseDispatcher.CheckDCD : Boolean;
    {-Returns True if DCD is high}
  begin
    Result := GetModemStatusPrim(ClearDeltaDCD) and DCDMask = DCDMask;
  end;

  function TApdBaseDispatcher.CheckDeltaCTS : Boolean;
    {-Returns True if DeltaCTS is high}
  begin
    Result := GetModemStatusPrim(ClearDeltaCTS) and DeltaCTSMask = DeltaCTSMask;
  end;

  function TApdBaseDispatcher.CheckDeltaDSR : Boolean;
    {-Returns True if DeltaDSR is high}
  begin
    Result := GetModemStatusPrim(ClearDeltaDSR) and DeltaDSRMask = DeltaDSRMask;
  end;

  function TApdBaseDispatcher.CheckDeltaRI : Boolean;
    {-Returns True if DeltaRI is high}
  begin
    Result := GetModemStatusPrim(ClearDeltaRI) and DeltaRIMask = DeltaRIMask;
  end;

  function TApdBaseDispatcher.CheckDeltaDCD : Boolean;
    {-Returns True if DeltaDCD is high}
  begin
    Result := GetModemStatusPrim(ClearDeltaDCD) and DeltaDCDMask = DeltaDCDMask;
  end;

  function TApdBaseDispatcher.GetLineError : Integer;
    {-Return current line errors}
  const
    AllErrorMask = ce_RxOver +
                   ce_Overrun + ce_RxParity + ce_Frame;
  var
    GotError : Boolean;
  begin
    EnterCriticalSection(DataSection);
    try
      GotError := True;
      if FlagIsSet(LastError, ce_RxOver) then
        Result := leBuffer
      else if FlagIsSet(LastError, ce_Overrun) then
        Result := leOverrun
      else if FlagIsSet(LastError, ce_RxParity) then
        Result := leParity
      else if FlagIsSet(LastError, ce_Frame) then
        Result := leFraming
      else if FlagIsSet(LastError, ce_Break) then
        Result := leBreak
      else begin
        GotError := False;
        Result := leNoError;
      end;

      {Clear all error flags}
      if GotError then
        LastError := LastError and not AllErrorMask;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.CheckLineBreak : Boolean;
  begin
    EnterCriticalSection(DataSection);
    try
      Result := FlagIsSet(LastError, ce_Break);
      LastError := LastError and not ce_Break;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.SendBreak(Ticks : Cardinal; Yield : Boolean);
    {Send a line break of Ticks ticks, with yields}
  begin
    { raise RTS for RS485 mode }
    if RS485Mode then                                                    {!!.01}
      SetRTS(True);                                                      {!!.01}
    SetCommBreak(CidEx);
    DelayTicks(Ticks, Yield);
    ClearCommBreak(CidEx);
    { lower RTS only if the output buffer is empty }
    if RS485Mode and (OutBuffUsed = 0) then                              {!!.01}
      SetRTS(False);                                                     {!!.01}
  end;

  procedure TApdBaseDispatcher.SetBreak(BreakOn: Boolean);
    {Sets or clears line break condition}
  begin
    if BreakOn then begin                                                {!!.01}
      if RS485Mode then                                                  {!!.01}
        SetRTS(True);                                                    {!!.01}
      SetCommBreak(CidEx)
    end else begin                                                       {!!.01}
      ClearCommBreak(CidEx);
      if RS485Mode and (OutBuffUsed = 0) then                            {!!.01}
        SetRTS(False);                                                   {!!.01}
    end;                                                                 {!!.01}
  end;

  function TApdBaseDispatcher.CharReady : Boolean;
    {-Return True if at least one character is ready at the device driver}
  var
    NewTail : Cardinal;
  begin
    EnterCriticalSection(DispSection);
    try
      if InAvailMessage then begin
        NewTail := DBufTail + GetCount;
        if NewTail >= DispatchBufferSize then
          Dec(NewTail, DispatchBufferSize);
        Result := (DBufHead <> NewTail)
          or (DispatchFull and (GetCount < DispatchBufferSize));
      end else
        Result := (DBufHead <> DBufTail) or DispatchFull;
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.PeekCharPrim(var C : AnsiChar; Count : Cardinal) : Integer;
    {-Return the Count'th character but don't remove it from the buffer}
  var
    NewTail : Cardinal;
    InCount : Cardinal;
  begin
    Result := ecOK;
    EnterCriticalSection(DispSection);
    try
      if DBufHead > DBufTail then
        InCount := DBufHead-DBufTail
      else if DBufHead <> DBufTail then
        InCount := ((DBufHead+DispatchBufferSize)-DBufTail)
      else if DispatchFull then
        InCount := DispatchBufferSize
      else
        InCount := 0;

      if InCount >= Count then begin
        {Calculate index of requested character}
        NewTail := DBufTail + (Count - 1);
        if NewTail >= DispatchBufferSize then
          NewTail := (NewTail - DispatchBufferSize);
        C := DBuffer^[NewTail];
      end else
        Result := ecBufferIsEmpty;
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.PeekChar(var C : AnsiChar; Count : Cardinal) : Integer;
    {-Return the Count'th character but don't remove it from the buffer}
    {-Account for GetCount}
  begin
    EnterCriticalSection(DispSection);
    try
      if InAvailMessage then
        Inc(Count, GetCount);
      Result := PeekCharPrim(C, Count);
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.GetChar(var C : AnsiChar) : Integer;
    {-Return next char and remove it from buffer}
  begin
    EnterCriticalSection(DispSection);
    try
      {If within an apw_TriggerAvail message then do not physically      }
      {extract the character. It will be removed by the dispatcher after }
      {all trigger handlers have seen it. If not within an               }
      {apw_TriggerAvail message then physically extract the character    }

      if InAvailMessage then begin
        Inc(GetCount);
        Result := PeekCharPrim(C, GetCount);
        if Result < ecOK then begin
          Dec(GetCount);
          Exit;
        end;
      end else begin
        Result := PeekCharPrim(C, 1);
        if Result >= ecOK then begin
          {Increment the tail index}
          Inc(DBufTail);
          if DBufTail = DispatchBufferSize then
            DBufTail := 0;
          DispatchFull := False;
        end;
      end;

      if TracingOn
      and (Result >= ecOK) then
        AddTraceEntry('R', C);
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.PeekBlockPrim(Block : PAnsiChar;
    Offset : Cardinal; Len : Cardinal; var NewTail : Cardinal) : Integer;
    {-Return Block from ComPort, return new tail value}
  var
    Count : Cardinal;
    EndCount : Cardinal;
    BeginCount : Cardinal;
  begin
    EnterCriticalSection(DispSection);
    try
      {Get count}
      Count := BuffCount(DBufHead, DBufTail, DispatchFull);

      {Set new tail value}
      NewTail := DBufTail + Offset;
      if NewTail >= DispatchBufferSize then
        Dec(NewTail, DispatchBufferSize);

      if Count >= Len then begin
        {Set begin/end buffer counts}
        if NewTail+Len < DispatchBufferSize then begin
          EndCount := Len;
          BeginCount := 0;
        end else begin
          EndCount := (DispatchBufferSize-NewTail);
          BeginCount := Len-EndCount;
        end;

        if EndCount <> 0 then begin
          {Move data from end of dispatch buffer}
          Move(DBuffer^[NewTail], Pointer(Block)^, EndCount);
          Inc(NewTail, EndCount);
        end;

        if BeginCount <> 0 then begin
          {Move data from beginning of dispatch buffer}
          Move(DBuffer^[0],
               PByteBuffer(Block)^[EndCount+1],
               BeginCount);
          NewTail := BeginCount;
        end;

        {Wrap newtail}
        if NewTail = DispatchBufferSize then
          NewTail := 0;

        Result := Len;
      end else
        Result := ecBufferIsEmpty;
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.PeekBlock(Block : PAnsiChar; Len : Cardinal) : Integer;
    {-Return Block from ComPort but don't set new tail value}
  var
    Tail : Cardinal;
    Offset : Cardinal;
  begin
    EnterCriticalSection(DispSection);
    try
      {Get block}
      if InAvailMessage then
        Offset := GetCount
      else
        Offset := 0;
      Result := PeekBlockPrim(Block, Offset, Len, Tail);
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.GetBlock(Block : PAnsiChar; Len : Cardinal) : Integer;
    {-Get Block from ComPort and set new tail}
  var
    Tail : Cardinal;
    I : Cardinal;
  begin
    EnterCriticalSection(DispSection);
    try
      { If within an apw_TriggerAvail message then do not physically }
      { extract the data. It will be removed by the dispatcher after }
      { all trigger handlers have seen it. If not within an          }
      { apw_TriggerAvail message, then physically extract the data   }

      if InAvailMessage then begin
        Result := PeekBlockPrim(Block, GetCount, Len, Tail);
        if Result > 0 then
          Inc(GetCount, Result);
      end else begin
        Result := PeekBlockPrim(Block, 0, Len, Tail);
        if Result > 0 then begin
          DBufTail := Tail;
          DispatchFull := False;
        end;
      end;
    finally
      LeaveCriticalSection(DispSection);
    end;

    EnterCriticalSection(DataSection);
    try
      if TracingOn and (Result > 0) then
        for I := 0 to Result-1 do
          AddTraceEntry('R', Block[I]);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.PutChar(C : AnsiChar) : Integer;
    {-Route through PutBlock to transmit a single character}
  begin
    Result := PutBlock(C, 1);
  end;

  function TApdBaseDispatcher.PutString(S : AnsiString) : Integer;
    {-Send as a block}
  begin
    Result := PutBlock(S[1], Length(S));
  end;

  procedure TApdBaseDispatcher.AddStringToLog(S : Ansistring);
  begin
    if DLoggingOn then
      AddDispatchEntry(dtUser, dstNone, 0, @S[1], length(S) * SizeOf(AnsiChar))
  end;

  function TApdBaseDispatcher.PutBlock(const Block; Len : Cardinal) : Integer;
    {-Send Block to CommPort}
  var
    Avail    : Cardinal;
    I        : Cardinal;
    CharsOut : Integer;           {Chars transmitted from last block}
  begin
    {Exit immediately if nothing to do}
    Result := ecOK;
    if Len = 0 then
      Exit;

    EnterCriticalSection(OutputSection);
    try
      { Is there enough free space in the outbuffer? }
      {LastError := GetComError(ComStatus);                                 // SWB
       Avail := OutQue - ComStatus.cbOutQue;}                               // SWB
      // The old method of determining available space in the output buffer // SWB
      // was agonizingly slow when using mapped com ports under Citrix or   // SWB
      // Windows 2003.  Replaced call to GetComError with a call that       // SWB
      // returns only the used buffer space.                                // SWB
      Avail := OutQue - OutBufUsed;                                         // SWB
      if Avail < Len then begin
        Result := ecOutputBufferTooSmall;
        Exit;
      end;
      if Avail = Len then
        OBufFull := True;

      { Raise RTS if in RS485 mode. In 32bit mode it will be lowered  }
      { by the output thread. }
      if Win32Platform <> VER_PLATFORM_WIN32_NT then
        if RS485Mode then begin
          if BaseAddress = 0 then begin
            Result := ecBaseAddressNotSet;
            Exit;
          end;
          SetRTS(True);
        end;

      {Send the data}
      CharsOut := WriteCom(PAnsiChar(@Block), Len);
      if CharsOut <= 0 then begin
        CharsOut := Abs(CharsOut);
        Result := ecPutBlockFail;
        LastError := GetComError(ComStatus);
      end;

      {Flag output trigger}
      OutSentPending := True;
    finally
      LeaveCriticalSection(OutputSection);
    end;

    EnterCriticalSection(DataSection);
    try
      if DLoggingOn then
        if CharsOut = 0 then
          AddDispatchEntry(dtDispatch, dstWriteCom, 0, nil, 0)
        else
          AddDispatchEntry(dtDispatch, dstWriteCom, CharsOut,
                            PAnsiChar(@Block), CharsOut);

      if TracingOn and (CharsOut <> 0) then
        for I := 0 to CharsOut-1 do
          AddTraceEntry('T', PAnsiChar(@Block)[I]);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.InBuffUsed : Cardinal;
    {-Return number of bytes currently in input buffer}
  begin
    EnterCriticalSection(DispSection);
    try
      if DBufHead = DBufTail then
        if DispatchFull then
          Result := DispatchBufferSize
        else
          Result := 0
      else if DBufHead > DBufTail then
        Result := DBufHead-DBufTail
      else
        Result := (DBufHead+DispatchBufferSize)-DBufTail;

      if InAvailMessage then
        {In apw_TriggerAvail message so reduce by retrieved chars}
        Dec(Result, GetCount);
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.InBuffFree : Cardinal;
    {-Return number of bytes free in input buffer}
  begin
    EnterCriticalSection(DispSection);
    try
      if DBufHead = DBufTail then
        if DispatchFull then
          Result := 0
        else
          Result := DispatchBufferSize
      else if DBufHead > DBufTail then
        Result := (DBufTail+DispatchBufferSize)-DBufHead
      else
        Result := DBufTail-DBufHead;

      if InAvailMessage then
        {In apw_TriggerAvail message so reduce by retrieved chars}
        Inc(Result, GetCount);
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.OutBuffUsed : Cardinal;
    {-Return number of bytes currently in output buffer}
  begin
    EnterCriticalSection(OutputSection);
    try
      RefreshStatus;
      Result := ComStatus.cbOutQue;
    finally
      LeaveCriticalSection(OutputSection);
    end;
  end;

  function TApdBaseDispatcher.OutBuffFree : Cardinal;
    {-Return number of bytes free in output buffer}
  begin
    EnterCriticalSection(OutputSection);
    try
      RefreshStatus;
      Result := OutQue - ComStatus.cbOutQue;
    finally
      LeaveCriticalSection(OutputSection);
    end;
  end;

  function TApdBaseDispatcher.FlushOutBuffer : Integer;
    {-Flush the output buffer}
  begin
    Result := FlushCom(0);
  end;

  function TApdBaseDispatcher.FlushInBuffer : Integer;
  begin
    EnterCriticalSection(DispSection);
    try
      {Flush COMM buffer}
      Result := FlushCom(1);

      {Flush the dispatcher's buffer}
      if InAvailMessage then
        MaxGetCount := BuffCount(DBufHead, DBufTail, DispatchFull)
      else begin
        DBufTail := DBufHead;
        GetCount := 0;
      end;
      DispatchFull := False;

      {Reset data triggers}
      ResetDataTriggers;
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  procedure TApdBaseDispatcher.BufferSizes(var InSize, OutSize : Cardinal);
    {-Return buffer sizes}
  begin
    InSize := InQue;
    OutSize := OutQue;
  end;

  function TApdBaseDispatcher.HWFlowOptions(
                         BufferFull, BufferResume : Cardinal;
                         Options : Cardinal) : Integer;
    {-Turn on hardware flow control}
  begin
    {Validate the buffer points}
    if (BufferResume > BufferFull) or
       (BufferFull > InQue) then begin
      Result := ecBadArgument;
      Exit;
    end;

    EnterCriticalSection(DataSection);
    try
      GetComState(DCB);
      with DCB do begin
        Flags := Flags and not (AllHdwFlow);
        Flags := Flags and not (dcb_DTRBit1 or dcb_RTSBit1);
        DtrAuto := False;
        RtsAuto := False;

        {Receive flow control, set requested signal(s)}
        if FlagIsSet(Options, hfUseDtr) then begin
          Flags := Flags or dcb_DTR_CONTROL_HANDSHAKE;
          DtrAuto := True;
        end else begin
          { If static DTR wanted }
          if DTRState then
            { then assert DTR }
            Flags := Flags or dcb_DTR_CONTROL_ENABLE;
        end;

        if FlagIsSet(Options, hfUseRts) then begin
          Flags := Flags or dcb_RTS_CONTROL_HANDSHAKE;
          RtsAuto := True;
        end else begin
          { If static RTS wanted }
          if RTSState then
            {  then assert RTS }
            Flags := Flags or dcb_RTS_CONTROL_ENABLE;
        end;

        if RS485Mode and (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
          Flags := Flags or dcb_RTS_CONTROL_TOGGLE;
          RtsAuto := True;
        end;

        {Set receive flow buffer limits}
        XoffLim := InQue - BufferFull;
        XonLim := BufferResume;

        {Transmit flow control, set requested signal(s)}
        if FlagIsSet(Options, hfRequireDsr) then
          Flags := Flags or dcb_OutxDsrFlow;

        if FlagIsSet(Options, hfRequireCts) then
          Flags := Flags or dcb_OutxCtsFlow;

        {Set new DCB}
        Result := SetCommStateFix(DCB);
      end;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.HWFlowState : Integer;
    {-Returns state of flow control}
  begin
    with DCB do begin
      EnterCriticalSection(DataSection);
      try
        if not FlagIsSet(Flags, AllHdwFlow) then begin
          Result := fsOff;
          Exit;
        end else
          Result := fsOn;

        if Flags and InHdwFlow <> 0 then begin
          {Get latest flow status}
          RefreshStatus;

          {Set appropriate flow state}
          if (Flags and dcb_OutxDsrFlow <> 0) and
             (fDsrHold in ComStatus.Flags) then
            Result := fsDsrHold;

          if (Flags and dcb_OutxCtsFlow <> 0) and
             (fCtlHold in ComStatus.Flags) then
            Result := fsCtsHold;
        end;
      finally
        LeaveCriticalSection(DataSection);
      end;
    end;
  end;

  function TApdBaseDispatcher.SWFlowEnable(
                         BufferFull, BufferResume : Cardinal;
                         Options : Cardinal) : Integer;
    {-Turn on software flow control}
  begin
    {Validate the buffer points}
    if (BufferResume > BufferFull) or
       (BufferFull > InQue) then begin
      Result := ecBadArgument;
      Exit;
    end;

    EnterCriticalSection(DataSection);
    try
      { Make sure we have an up-to-date DCB }
      GetComState(DCB);
      with DCB do begin
        if FlagIsSet(Options, sfReceiveFlow) then begin
          {Receive flow control}
          Flags := Flags or dcb_InX;

          {Set receive flow buffer limits}
          XoffLim := InQue - BufferFull;
          XonLim := BufferResume;

          {Set flow control characters}
          XOnChar := cXon;
          XOffChar := cXoff;
        end;

        if FlagIsSet(Options, sfTransmitFlow) then begin
          {Transmit flow control}
          Flags := Flags or dcb_OutX;

          {Set flow control characters}
          XOnChar := cXon;
          XOffChar := cXoff;
        end;

        {Set new DCB}
        Result := SetCommStateFix(DCB);
      end;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.SWFlowDisable : Integer;
    {-Turn off all software flow control}
  begin
    with DCB do begin
      EnterCriticalSection(DataSection);
      try
        { Make sure we have an up-to-date DCB }
        GetComState(DCB);
        Flags := Flags and not AllSfwFlow;
        Result := SetCommStateFix(DCB);
      finally
        LeaveCriticalSection(DataSection);
      end;
    end;
  end;

  function TApdBaseDispatcher.SWFlowState : Integer;
    {-Returns state of flow control}
  begin
    with DCB do begin
      EnterCriticalSection(DataSection);
      try
        if FlagIsSet(Flags, dcb_InX) or FlagIsSet(Flags, dcb_OutX) then
          Result := fsOn
        else begin
          Result := fsOff;
          Exit;
        end;

        {Get latest flow status}
        RefreshStatus;

        {Set appropriate flow state}
        if (fXoffHold in ComStatus.Flags) then
          if (fXoffSent in ComStatus.Flags) then
            Result := fsXBothHold
          else
            Result := fsXOutHold
        else if (fXoffSent in ComStatus.Flags) then
          Result := fsXInHold;
      finally
        LeaveCriticalSection(DataSection);
      end;
    end;
  end;

  function TApdBaseDispatcher.SWFlowChars(OnChar, OffChar : AnsiChar) : Integer;
    {-Set on/off chars for software flow control}
  begin
    with DCB do begin
      EnterCriticalSection(DataSection);
      try
        { Make sure we have an up-to-date DCB }
        GetComState(DCB);

        {Set flow control characters}
        XOnChar := OnChar;
        XOffChar := OffChar;
        Result := SetCommStateFix(DCB);
      finally
        LeaveCriticalSection(DataSection);
      end;
    end;
  end;

  function TApdBaseDispatcher.SendNotify(Msg, Trigger, Data: Cardinal) : Boolean;
    {-Send trigger messages, return False to stop checking triggers}
  var
    lParam : DWORD;
    Res    : DWORD;
    i      : Integer;
  begin
    Result := True;

    if not HandlerServiceNeeded then Exit;

    {Don't let dispatcher change anything while sending messages}
    EnterCriticalSection(DataSection);
    try
      fEventBusy := True;
    finally
      LeaveCriticalSection(DataSection);
    end;

    try
      MaxGetCount := 0;

      {Flag apw_TriggerAvail messages}
      InAvailMessage := (Msg = apw_TriggerAvail) or (Msg = apw_TriggerData);

      {Clear trigger handle modification flags}
      lParam := (DWORD(fHandle) shl 16) + Data;

      for i := 0 to pred(EventTriggerHandlers.Count) do
        with PEventTriggerHandler(EventTriggerHandlers[i])^ do begin
          GetCount := 0;

          if not thDeleted then
            if thSync then
              DispThread.SyncNotify(Msg,Trigger,lParam,thNotify)
            else
              thNotify(Msg, Trigger, lParam);

          if ClosePending then begin
            {Port was closed by event handler, bail out}
            Result := False;
            Exit;
          end;

          {Note deepest look at input buffer}
          if GetCount > MaxGetCount then
            MaxGetCount := GetCount;
        end;

      for i := 0 to pred(ProcTriggerHandlers.Count) do
        with PProcTriggerHandler(ProcTriggerHandlers[i])^ do begin
          GetCount := 0;

          if not thDeleted and (@thNotify <> nil) then
            thNotify(Msg, Trigger, lParam);

          if ClosePending then begin
            {Port was closed by event handler, bail out}
            Result := False;
            Exit;
          end;

          {Note deepest look at input buffer}
          if GetCount > MaxGetCount then
            MaxGetCount := GetCount;
        end;

      if (WndTriggerHandlers.Count > 1) or PortHandlerInstalled then
        for i := 0 to pred(WndTriggerHandlers.Count) do
          with PWndTriggerHandler(WndTriggerHandlers[i])^ do begin
            GetCount := 0;

            if not thDeleted then
              SendMessageTimeout(thWnd, Msg, Trigger, lParam,
                SMTO_BLOCK, 3000, @Res);

            if ClosePending then begin
              {Port was closed by event handler, bail out}
              Result := False;
              Exit;
            end;

            {Note deepest look at input buffer}
            if GetCount > MaxGetCount then
              MaxGetCount := GetCount;
          end;

      { If in apw_TriggerAvail message remove the data now }
      if InAvailMessage then begin
        EnterCriticalSection(DispSection);
        try
          InAvailMessage := False;
          Inc(DBufTail, MaxGetCount);
          if DBufTail >= DispatchBufferSize then
            Dec(DBufTail, DispatchBufferSize);
          if MaxGetCount <> 0 then
            DispatchFull := False;

          {Force CheckTriggers to exit if another avail msg is pending}
          {Note: for avail msgs, trigger is really the byte count}
          if (Msg = apw_TriggerAvail) and (MaxGetCount <> Trigger) then
            Result := False;
        finally
          LeaveCriticalSection(DispSection);
        end;
      end;
    finally
      EnterCriticalSection(DataSection);
      try
        fEventBusy := False;

        if DeletePending then begin

          for i := pred(WndTriggerHandlers.Count) downto 0 do
            if PWndTriggerHandler(WndTriggerHandlers[i])^.thDeleted then begin
              Dispose(PWndTriggerHandler(WndTriggerHandlers[i]));
              WndTriggerHandlers.Delete(i);
            end;

          for i := pred(ProcTriggerHandlers.Count) downto 0 do
            if PProcTriggerHandler(ProcTriggerHandlers[i])^.thDeleted then begin
              Dispose(PProcTriggerHandler(ProcTriggerHandlers[i]));
              ProcTriggerHandlers.Delete(i);
            end;

          for i := pred(EventTriggerHandlers.Count) downto 0 do
            if PEventTriggerHandler(EventTriggerHandlers[i])^.thDeleted then begin
              Dispose(PEventTriggerHandler(EventTriggerHandlers[i]));
              EventTriggerHandlers.Delete(i);
            end;

          DeletePending := False;
          UpdateHandlerFlags(fuKeepPort);
        end;
      finally
        LeaveCriticalSection(DataSection);
      end;
    end;
    GetCount := 0;
  end;

  function MatchString(var Indexes : TCheckIndex; const C : AnsiChar; Len : Cardinal;
                        P : PAnsiChar; IgnoreCase : Boolean) : Boolean;
    {-Checks for string P on consecutive calls, returns True when found}
  var
    I        : Cardinal;
    Check    : Boolean;
    GotFirst : Boolean;
  begin
    Result := False;

    if IgnoreCase then
      AnsiUpperBuff(@C, 1);

    GotFirst := False;
    Check := True;
    for I := 0 to Len-1 do begin
      {Check another index?}
      if Check then begin
        {Compare this index...}
        if C = P[Indexes[I]] then      
          {Got match, was it complete?}
          if Indexes[I] = Len-1 then begin
            Indexes[I] := 0;
            Result := True;

            {Clear all inprogress matches}
            FillChar(Indexes, SizeOf(Indexes), 0);
          end else
            Inc(Indexes[I])
        else
          {No match, reset index}
          if C = P[0] then begin
            GotFirst := True;
            Indexes[I] := 1
          end else
            Indexes[I] := 0;
      end;

      {See if last match was on first char}
      if Indexes[I] = 1 then
        GotFirst := True;

      {See if we should check the next index}
      if I <> Len-1 then
        if GotFirst then
          {Got a previous restart, don't allow more restarts}
          Check := Indexes[I+1] <> 0
        else
          {Not a restart, check next index if in progress or on first char}
          Check := (Indexes[I+1] <> 0) or (C = P[0])
      else
        Check := False;
    end;
  end;

  function TApdBaseDispatcher.CheckStatusTriggers : Boolean;
    {-Check status triggers for H, send notification messages as required}
    {-Return True if more checks remain}
  var
    J : Integer;
    Hit : Cardinal;
    StatusLen : Cardinal;
    Res : Byte;
    BufCnt : Cardinal;
  begin
    {Check status triggers}
    for J := 0 to pred(StatusTriggers.Count) do begin
      with PStatusTrigger(StatusTriggers[J])^ do begin
        if tSActive and not StatusHit then begin
          Hit := stNotActive;
          StatusLen := 0;
          case tSType of
            stLine :
              if LastError and tValue <> 0 then begin
                Hit := stLine;
                tValue := LastError;
              end;
            stModem :
              begin
                {Check for changed bits}
                Res := Lo(tValue) xor ModemStatus;

                {Skip bits not in our mask}
                Res := Res and Hi(tValue);

                {If anything is still set, it's a hit}
                if Res <> 0 then begin
                  Hit := stModem;
                end;
              end;
            stOutBuffFree :
              begin
                BufCnt := OutBuffFree;
                if BufCnt >= tValue then begin
                  StatusLen := BufCnt;
                  Hit := stOutBuffFree;
                end;
              end;
            stOutBuffUsed :
              begin
                BufCnt := OutBuffUsed;
                if BufCnt <= tValue then begin
                  StatusLen := BufCnt;
                  Hit := stOutBuffUsed;
                end;
              end;
            stOutSent :
              if OutSentPending then begin
                OutSentPending := False;
                StatusLen := 0;
                Hit := stOutSent;
              end;
          end;
          if Hit <> stNotActive then begin
            {Clear the trigger and send the notification message}
            tSActive := False;

            {Prevent status trigger re-entrancy issues}
            GlobalStatHit := True;
            StatusHit := True;

            if DLoggingOn then
              AddDispatchEntry(dtTrigger, dstStatus, tHandle, nil, 0);

            Result :=
              SendNotify(apw_TriggerStatus, tHandle, StatusLen);
            Exit;
          end;
        end;
      end;
      if J >= StatusTriggers.Count then break;
    end;
    {No more checks required}
    Result := False;
  end;

  function TApdBaseDispatcher.CheckReceiveTriggers : Boolean;
    {-Check all receive triggers for H, send notification messages as required}
    {-Return True if more checks remain}
  type
    LH = record L,H : Byte; end;
  var
    I : Cardinal;
    J : Integer;
    BufCnt : Cardinal;
    MatchSize : Cardinal;
    CC : Cardinal;
    AnyMatch : Boolean;
    C : AnsiChar;

    function CharCount(CurTail, Adjust : Cardinal) : Cardinal;
      {-Return the number of characters available between CurTail }
      { and DBufTail that haven't already been extracted. CurTail }
      { is first adjusted downward by Adjust, the size of the     }
      { current match string }
    begin
      if Adjust <= CurTail then
        Dec(CurTail, Adjust)
      else
        CurTail := (CurTail + DispatchBufferSize) - Adjust;
      Result := BuffCount(CurTail, DBufTail, DispatchFull) + 1;
      if InAvailMessage then
        Dec(Result, GetCount);
    end;

  begin
    {Assume triggers need to be re-checked}
    Result := True;

    I := LastTailData;
    {Check data triggers}
    if LastTailData <> DBufHead then begin
      {Prepare}

      {Loop through new data in dispatch buffer}
      while I <> DBufHead do begin
        C := DBuffer^[I];

        {Check each trigger for a match on this character}
        AnyMatch := False;
        MatchSize := 0;
        for J := 0 to pred(DataTriggers.Count) do
          with PDataTrigger(DataTriggers[J])^ do
            if tLen <> 0 then begin
              tMatched := tMatched or
                          MatchString(tChkIndex, C, tLen, tData, tIgnoreCase);
              if tMatched and (tLen > MatchSize) then
                MatchSize := tLen;
              if not AnyMatch then
                AnyMatch := tMatched;
            end;

        {Send len message if we have any matches}
        if AnyMatch then begin
          {Send len message up to first matching char}
          if (LenTrigger <> 0) and
            (NotifyTail <> I) and
            (Integer(CharCount(I, 0))-
             Integer(MatchSize) >= Integer(LenTrigger))
            then begin

            {Generate len message for preceding data}
            CC := CharCount(I, MatchSize);
            if DLoggingOn then
              AddDispatchEntry(dtTrigger, dstAvail, CC, nil, 0);
            Result := SendNotify(apw_TriggerAvail, CC, 0);
            LastTailData := I;
            NotifyTail := I;
          end;

          {Process the matches}
          for J := pred(DataTriggers.Count) downto 0 do begin
            with PDataTrigger(DataTriggers[J])^ do
              if tMatched then begin
                {No preceding data or msg pending, send data msg}
                if DLoggingOn then
                  AddDispatchEntry(dtTrigger, dstData, tHandle, nil, 0);

                tMatched := False;
                Result :=
                  SendNotify(apw_TriggerData, tHandle, tLen);
              end;
            if J >= DataTriggers.Count then break;
          end;

          {Exit after all data triggers that matched on this char}
          if I = DispatchBufferSize-1 then
            LastTailData := 0
          else
            LastTailData := I+1;
          Exit;
        end;

        {Next index for buffer}
        if I = DispatchBufferSize-1 then
          I := 0
        else
          inc(I);
      end;

      {Update last tail for data triggers}
      LastTailData := I;
    end;

    {Check for length trigger}

    BufCnt := InBuffUsed;

    if (LenTrigger <> 0) and
       (NotifyTail <> I) and
       (BufCnt >= LenTrigger) then begin
      if DLoggingOn then
        AddDispatchEntry(dtTrigger, dstAvail, BufCnt, nil, 0);

      Result :=
        SendNotify(apw_TriggerAvail, BufCnt, 0);
      NotifyTail := I;
      Exit;
    end;

    {No more checks required}
    Result := False;
  end;

  function TApdBaseDispatcher.CheckTimerTriggers : Boolean;
    {-Check timer triggers for H, send notification messages as required}
    {-Return True if more checks remain}
  var
    J : Integer;
  begin
    {Check for timer triggers}
    for J := 0 to pred(TimerTriggers.Count) do begin
      with PTimerTrigger(TimerTriggers[J])^ do
        if tActive and TimerExpired(tET) then begin
          tActive := False;

          if DLoggingOn then
            AddDispatchEntry(dtTrigger, dstTimer, tHandle, nil, 0);

          Result := SendNotify(apw_TriggerTimer, tHandle, 0);
          Exit;
        end;
      if J >= TimerTriggers.Count then break;
    end;
    {No more checks required}
    Result := False;
  end;

  function TApdBaseDispatcher.ExtractData : Boolean;
    {-Move data from communications driver to dispatch buffer}
    {-Return True if data available, false otherwise}
  var
    BytesToRead : Cardinal;
    FreeSpace : Cardinal;
    BeginFree : Cardinal;
    EndFree : Cardinal;
    Len : Integer;
  begin
    EnterCriticalSection(DispSection);
    try
      {Nothing to do if dispatch buffer is already full}
      if DispatchFull then begin
        if (DLoggingOn) then                                                // SWB
            AddDispatchEntry(dtDispatch,                                    // SWB
                             dstStatus,                                     // SWB
                             0,                                             // SWB
                             PAnsiChar('Dispatch buffer full.'),            // SWB
                             21);                                           // SWB
        Result := True;
        Exit;
      end;

      ComStatus.cbInQue := InQueueUsed;                                  // SWB
      if ComStatus.cbInQue > 0 then begin
        Result := True;

        if DBufHead = DBufTail then begin
          {Buffer is completely empty}
          FreeSpace := DispatchBufferSize;
          EndFree := DispatchBufferSize-DBufHead;
        end else if DBufHead > DBufTail then begin
          {Buffer not wrapped}
          FreeSpace := (DBufTail+DispatchBufferSize)-DBufHead;
          EndFree := DispatchBufferSize-DBufHead;
        end else begin
          {Buffer is wrapped}
          FreeSpace := DBufTail-DBufHead;
          EndFree := DBufTail-DBufHead;
        end;

        {Figure out how much data to read}
        if ComStatus.cbInQue > FreeSpace then begin
          BytesToRead := FreeSpace;
        end else begin
          BytesToRead := ComStatus.cbInQue;
        end;

        {Figure where data fits (end and/or beginning of buffer)}
        if BytesToRead > EndFree then
          BeginFree := BytesToRead-EndFree
        else
          BeginFree := 0;

        {Move data to end of dispatch buffer}
        if EndFree <> 0 then begin
          Len := ReadCom(PAnsiChar(@DBuffer^[DBufHead]), EndFree);

          {Restore data count on errors}
          if Len < 0 then begin
            Len := 0;
            GetComEventMask(-1);
          end;

          if DLoggingOn then
            if Len = 0 then
              AddDispatchEntry(dtDispatch, dstReadCom, Len, nil, 0)
            else
              AddDispatchEntry(dtDispatch, dstReadCom, Len,
                                @DBuffer^[DBufHead], Len);

          {Increment buffer head}
          Inc(DBufHead, Len);

          if Cardinal(Len) < EndFree then
            BeginFree := 0;

        end else
          Len := 0;

        {Handle buffer wrap}
        if DBufHead = DispatchBufferSize then
          DBufHead := 0;

        {Check for a full dispatch buffer}
        if Len <> 0 then
          DispatchFull := DBufHead = DBufTail;

        {Move data to beginning of dispatch buffer}
        if BeginFree <> 0 then begin
          Len := ReadCom(PAnsiChar(@DBuffer^[DBufHead]), BeginFree);

          {Restore data count on errors}
          if Len < 0 then begin
            Len := Abs(Len);
            GetComEventMask(-1);
          end;

          if DLoggingOn then
            if Len = 0 then
              AddDispatchEntry(dtDispatch, dstReadCom, Len, nil, 0)
            else
              AddDispatchEntry(dtDispatch, dstReadCom, Len,
                                @DBuffer^[DBufHead], Len);

          {Increment buffer head}
          Inc(DBufHead, Len);

          {Check for a full dispatch buffer}
          DispatchFull := DBufHead = DBufTail;

        end;
      end else
        Result := False;
    finally
      LeaveCriticalSection(DispSection);
    end;
  end;

  function TApdBaseDispatcher.CheckTriggers : Boolean;
    {-Check all triggers for H, send notification messages as required}
    {-Return True if more checks remain}
    {-Only used by the Winsock dispatcher}
  begin
    Result := True;

    {Check timers, exit true if any hit}
    if CheckTimerTriggers then
      Exit;

    {Check status triggers, exit true if any hit}
    if CheckStatusTriggers then
      Exit;

    {Check receive data triggers, exit true if any hit}
    if CheckReceiveTriggers then
      Exit;

    {No trigger hits, exit false}
    Result := False;
  end;

  procedure TApdBaseDispatcher.CreateDispatcherWindow;
    {-Create dispatcher window element}
    {-Only used by the Winsock dispatcher}
  begin
    fDispatcherWindow :=
      CreateWindow(DispatcherClassName,    {window class name}
                   '',                     {caption}
                   ws_Overlapped,          {window style}
                   0,                      {X}
                   0,                      {Y}
                   10,                     {width}
                   10,                     {height}
                   0,                      {parent}
                   0,                      {menu}
                   HInstance,              {instance}
                   nil);                   {parameter}

    ShowWindow(fDispatcherWindow, sw_Hide);
  end;

{Trigger functions}

  procedure TApdBaseDispatcher.RegisterWndTriggerHandler(HW : TApdHwnd);
  var
    TH : PWndTriggerHandler;
  begin
    EnterCriticalSection(DataSection);
    try
      {Allocate memory for TriggerHandler node}
      New(TH);

      {Fill in data}
      with TH^ do begin
        thWnd := HW;
        thDeleted := False;
      end;

      WndTriggerHandlers.Add(TH);
      HandlerServiceNeeded := True;

      if DLoggingOn then
        AddDispatchEntry(dtTriggerHandlerAlloc,dstWndHandler,HW,nil,0);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.RegisterProcTriggerHandler(NP : TApdNotifyProc);
  var
    TH : PProcTriggerHandler;
  begin
    EnterCriticalSection(DataSection);
    try
      {Allocate memory for TriggerHandler node}
      New(TH);

      {Fill in data}
      with TH^ do begin
        thnotify := NP;
        thDeleted := False;
      end;

      ProcTriggerHandlers.Add(TH);
      HandlerServiceNeeded := True;

      if DLoggingOn then
        AddDispatchEntry(dtTriggerHandlerAlloc,dstProcHandler,0,nil,0);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.RegisterSyncEventTriggerHandler(NP : TApdNotifyEvent);
  var
    TH : PEventTriggerHandler;
  begin
    EnterCriticalSection(DataSection);
    try
      {Allocate memory for TriggerHandler node}
      New(TH);

      {Fill in data}
      with TH^ do begin
        thNotify := NP;
        thSync := True;
        thDeleted := False;
      end;

      EventTriggerHandlers.Add(TH);
      HandlerServiceNeeded := True;

      if DLoggingOn then
        AddDispatchEntry(dtTriggerHandlerAlloc,dstEventHandler,1,nil,0);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.RegisterEventTriggerHandler(NP : TApdNotifyEvent);
  var
    TH : PEventTriggerHandler;
  begin
    EnterCriticalSection(DataSection);
    try
      {Allocate memory for TriggerHandler node}
      New(TH);

      {Fill in data}
      with TH^ do begin
        thNotify := NP;
        thSync := False;
        thDeleted := False;
      end;

      EventTriggerHandlers.Add(TH);
      HandlerServiceNeeded := True;

      if DLoggingOn then
        AddDispatchEntry(dtTriggerHandlerAlloc,dstEventHandler,0,nil,0);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.DeregisterWndTriggerHandler(HW : TApdHwnd);
  var
    i : Integer;
  begin
    EnterCriticalSection(DataSection);
    try
      for i := 0 to pred(WndTriggerHandlers.Count) do
        with PWndTriggerHandler(WndTriggerHandlers[i])^ do
          if thWnd = HW then begin
            if DLoggingOn then
              AddDispatchEntry(dtTriggerHandlerDispose,dstWndHandler,HW,nil,0);
            if fEventBusy then begin
              thDeleted := True;
              DeletePending := True;
            end else begin
              Dispose(PWndTriggerHandler(WndTriggerHandlers[i]));
              WndTriggerHandlers.Delete(i);
            end;
            exit;
          end;

      UpdateHandlerFlags(fuKeepPort);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.DeregisterProcTriggerHandler(NP : TApdNotifyProc);
  var
    i : Integer;
  begin
    EnterCriticalSection(DataSection);
    try
      for i := 0 to pred(ProcTriggerHandlers.Count) do
        with PProcTriggerHandler(ProcTriggerHandlers[i])^ do
          if @thNotify = @NP then begin
            if DLoggingOn then
              AddDispatchEntry(dtTriggerHandlerDispose,dstProcHandler,0,nil,0);
            if fEventBusy then begin
              thDeleted := True;
              DeletePending := True;
            end else begin
              Dispose(PProcTriggerHandler(ProcTriggerHandlers[i]));
              ProcTriggerHandlers.Delete(i);
            end;
            exit;
          end;

      UpdateHandlerFlags(fuKeepPort);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.DeregisterEventTriggerHandler(NP : TApdNotifyEvent);
  var
    i : Integer;
  begin
    EnterCriticalSection(DataSection);
    try
      for i := 0 to pred(EventTriggerHandlers.Count) do
        with PEventTriggerHandler(EventTriggerHandlers[i])^ do
          if @thNotify = @NP then begin
            if DLoggingOn then
              AddDispatchEntry(dtTriggerHandlerDispose,dstEventHandler,0,nil,0);
            if fEventBusy then begin
              thDeleted := True;
              DeletePending := True;
            end else begin
              Dispose(PEventTriggerHandler(EventTriggerHandlers[i]));
              EventTriggerHandlers.Delete(i);
            end;
            exit;
          end;

      UpdateHandlerFlags(fuKeepPort);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.GetTriggerHandle : Cardinal;
    {-Find, allocate and return the first free trigger handle}
  var
    I : Integer;
    Good : Boolean;
  begin
    { Allocate a trigger handle. If we can, within the size of the handle's   }
    { datatype, we just increment TriggerCounter to get a new handle. If not, }
    { we need to check the existing handles to find a unique one.             }
    if TriggerCounter < MaxTriggerHandle then begin
      Result := TriggerCounter shl 3; {low three bits reserved for trigger specific information}
      inc(TriggerCounter);
    end else begin
      Result := FirstTriggerCounter shl 3; {lowest possible handle value}
      repeat
        Good := True; {Assume success}
        for i := 0 to pred(TimerTriggers.Count) do
          with PTimerTrigger(TimerTriggers[i])^ do
            if tHandle = Result then begin
              Good := False;
              break;
            end;
        if Good then for i := 0 to pred(StatusTriggers.Count) do
          with PStatusTrigger(StatusTriggers[i])^ do
            if (tHandle and not 7)= Result then begin
              Good := False;
              break;
            end;
        if Good then for i := 0 to pred(DataTriggers.Count) do
          with PDataTrigger(DataTriggers[i])^ do
            if tHandle = Result then begin
              Good := False;
              break;
            end;
        if not Good then
          inc(Result,(1 shl 3));
      until Good;
      if Result > MaxTriggerHandle then
        Result := 0;
    end;
  end;

  function TApdBaseDispatcher.FindTriggerFromHandle(TriggerHandle : Cardinal; Delete : Boolean;
                                   var T : TTriggerType; var Trigger : Pointer) : Integer;
    {-Find the trigger index}
  var
    i : Integer;
    b : Byte;
  begin
    T := ttNone;
    Result := ecOk;
    if (TriggerHandle > 1) then begin
      for i := 0 to pred(TimerTriggers.Count) do begin
        Trigger := TimerTriggers[i];
        with PTimerTrigger(Trigger)^ do
          if tHandle = TriggerHandle then begin
            T := ttTimer;
            if Delete then begin
              TimerTriggers.Delete(i);
              Dispose(PTimerTrigger(Trigger));
              if DLoggingOn then
                AddDispatchEntry(dtTriggerDispose,dstTimer,TriggerHandle,nil,0);
              Trigger := nil;
            end;
            exit;
          end;
      end;
      for i := 0 to pred(StatusTriggers.Count) do begin
        Trigger := StatusTriggers[i];
        with PStatusTrigger(Trigger)^ do
          if tHandle = TriggerHandle then begin
            T := ttStatus;
            if Delete then begin
              StatusTriggers.Delete(i);
              Dispose(PStatusTrigger(Trigger));
              if DLoggingOn then begin
                b := lo(TriggerHandle and (StatusTypeMask));
                AddDispatchEntry(dtTriggerDispose,dstStatusTrigger,TriggerHandle,@b,1);
              end;
              Trigger := nil;
            end;
            exit;
          end;
      end;
      for i := 0 to pred(DataTriggers.Count) do begin
        Trigger := DataTriggers[i];
        with PDataTrigger(Trigger)^ do
          if Cardinal(tHandle and not 7) = TriggerHandle then begin      {!!.01}
            T := ttData;
            if Delete then begin
              DataTriggers.Delete(i);
              Dispose(PDataTrigger(Trigger));
              if DLoggingOn then
                AddDispatchEntry(dtTriggerDispose,dstData,TriggerHandle,nil,0);
              Trigger := nil;
            end;
            exit;
          end;
      end;
    end else begin
      T := ttNone;
      Trigger := nil;
    end;
    if T = ttNone then
      Result := ecBadTriggerHandle;
  end;

  procedure TApdBaseDispatcher.ChangeLengthTrigger(Length : Cardinal);
    {-Change the length trigger to Length}
  begin
    EnterCriticalSection(DataSection);
    try
      LenTrigger := Length;

      if DLoggingOn then
        AddDispatchEntry(dtTriggerDataChange,dstAvailTrigger,Length,nil,0);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.AddTimerTrigger : Integer;
    {-Add a timer trigger}
  var
    NewTimerTrigger : PTimerTrigger;
  begin
    EnterCriticalSection(DataSection);
    try
      NewTimerTrigger := AllocMem(sizeof(TTimerTrigger));
      with NewTimerTrigger^ do begin
        tHandle := GetTriggerHandle;
        tTicks := 0;
        tActive := False;
        tValid := True;
        Result := tHandle;
      end;
      if Result > 0 then begin
       TimerTriggers.Add(NewTimerTrigger);
       if DLoggingOn then
         AddDispatchEntry(dtTriggerAlloc,dstTimerTrigger,Result,nil,0);
      end else
        Result := ecNoMoreTriggers;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.AddDataTriggerLen(Data : PAnsiChar;
                              IgnoreCase : Boolean; Len : Cardinal) : Integer;
    {-Add a data trigger, data is any ASCIIZ string so no embedded zeros}
  var
    NewDataTrigger : PDataTrigger;
  begin
    EnterCriticalSection(DataSection);
    try
      if Len <= MaxTrigData then begin
        NewDataTrigger := AllocMem(sizeof(TDataTrigger));
        with NewDataTrigger^ do begin
          tHandle := GetTriggerHandle;
          tLen := Len;
          FillChar(tChkIndex, SizeOf(TCheckIndex), 0);
          tMatched := False;
          tIgnoreCase := IgnoreCase;
          Move(Data^, tData, Len);
          if IgnoreCase and (Len <> 0) then
            AnsiUpperBuff(@tData, Len);
          Result := tHandle;
        end;
        if Result > 0 then begin
          DataTriggers.Add(NewDataTrigger);
          if DLoggingOn then
            AddDispatchEntry(dtTriggerAlloc,dstDataTrigger,Result,Data,Len);
        end else
          Result := ecNoMoreTriggers;

      end else
        Result := ecTriggerTooLong;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.AddDataTrigger(Data : PAnsiChar;
                           IgnoreCase : Boolean) : Integer;
    {-Add a data trigger, data is any ASCIIZ string so no embedded nulls}
  begin
    Result := AddDataTriggerLen(Data, IgnoreCase, AnsiStrings.StrLen(Data));
  end;

  function TApdBaseDispatcher.AddStatusTrigger(SType : Cardinal) : Integer;
    {-Add a status trigger of type SType}
  var
    NewStatusTrigger : PStatusTrigger;
  begin
    if (SType > stOutSent) then begin
      Result := ecBadArgument;
      Exit;
    end;

    EnterCriticalSection(DataSection);
    try
      NewStatusTrigger := AllocMem(sizeof(TStatusTrigger));
      with NewStatusTrigger^ do begin
        tHandle := GetTriggerHandle or SType;
        tSType := SType;
        tSActive := False;
        Result := tHandle;
      end;
      if (Result and not 7) > 0 then begin
        StatusTriggers.Add(NewStatusTrigger);
        if DLoggingOn then
          AddDispatchEntry(dtTriggerAlloc, dstStatusTrigger,
            Result, @SType, 1);
      end else
        Result := ecNoMoreTriggers;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.RemoveTrigger(TriggerHandle : Cardinal) : Integer;
    {-Remove the trigger for Index}
  var
    Trigger : Pointer;
    T : TTriggerType;
  begin
    EnterCriticalSection(DataSection);
    try
      if TriggerHandle = 1 then
        {Length trigger}
        begin
          LenTrigger := 0;
          Result := ecOk;
        end
      else
        {Other trigger}
        Result := FindTriggerFromHandle(TriggerHandle, True, T, Trigger);
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.SetTimerTrigger(TriggerHandle : Cardinal;
                            Ticks : Integer; Activate : Boolean) : Integer;
  const
    DeactivateStr : Ansistring = 'Deactivated';
  var
    Trigger : PTimerTrigger;
    T : TTriggerType;
  begin
    EnterCriticalSection(DataSection);
    try
      FindTriggerFromHandle(TriggerHandle, False, T, Pointer(Trigger));
      if (Trigger <> nil) and (T = ttTimer) then
        with Trigger^ do begin
          if Activate then begin
            if Ticks <> 0 then
              tTicks := Ticks;
            NewTimer(tET, tTicks);
          end;
          if DLoggingOn then
            if Activate then
              AddDispatchEntry(dtTriggerDataChange, dstTimerTrigger,
                TriggerHandle,@Ticks,sizeof(Ticks))
            else
              AddDispatchEntry(dtTriggerDataChange, dstTimerTrigger,
                TriggerHandle,@DeactivateStr[1],Length(DeactivateStr));
          tActive := Activate;
          Result := ecOk;
        end
      else
        Result := ecBadTriggerHandle;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.ExtendTimer(TriggerHandle : Cardinal;
                        Ticks : Integer) : Integer;
  var
    Trigger : PTimerTrigger;
    T : TTriggerType;
  begin
    EnterCriticalSection(DataSection);
    try
      FindTriggerFromHandle(TriggerHandle, False, T, Pointer(Trigger));
      if (Trigger <> nil) and (T = ttTimer) then
        with Trigger^ do begin
          Inc(tET.ExpireTicks, Ticks);
          Result := ecOk;
          if DLoggingOn then
            AddDispatchEntry(dtTriggerDataChange, dstTimerTrigger,
              TriggerHandle, @Ticks,sizeof(Ticks));
        end
      else
        Result := ecBadTriggerHandle;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.TimerTicksRemaining(TriggerHandle : Cardinal;
                                var TicksRemaining : Integer) : Integer;
  var
    Trigger : PTimerTrigger;
    T : TTriggerType;
  begin
    TicksRemaining := 0;
    EnterCriticalSection(DataSection);
    try
      FindTriggerFromHandle(TriggerHandle, False, T, Pointer(Trigger));
      if (Trigger <> nil) and (T = ttTimer) then
        with Trigger^ do begin
          TicksRemaining := RemainingTime(tET);
          Result := ecOk;
        end
      else
        Result := ecBadTriggerHandle;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.UpdateHandlerFlags(FlagUpdate : TApHandlerFlagUpdate);
  var
    HandlersInstalled : Boolean;
  begin
    EnterCriticalSection(DataSection);
    try
      HandlersInstalled := (WndTriggerHandlers.Count > 1) or
        (ProcTriggerHandlers.Count > 0) or (EventTriggerHandlers.Count > 0);

      case FlagUpdate of
        fuKeepPort :
          HandlerServiceNeeded := (HandlersInstalled or PortHandlerInstalled);

        fuEnablePort :
          begin
            PortHandlerInstalled := True;
            HandlerServiceNeeded := True;
          end;

        fuDisablePort :
          begin
            PortHandlerInstalled := False;
            HandlerServiceNeeded := HandlersInstalled;
          end;
      end;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.SetStatusTrigger(TriggerHandle : Cardinal;
    Value : Cardinal; Activate : Boolean) : Integer;
  type
    LH = record L,H : Byte; end;
  var
    Trigger : PStatusTrigger;
    T : TTriggerType;

    function SetLineBits(Value : Cardinal) : Cardinal;
      {-Return mask that can be checked against LastError later}
    begin
      Result := 0;
      if FlagIsSet(Value, lsOverrun) then
        Result := ce_Overrun;
      if FlagIsSet(Value, lsParity) then
        Result := Result or ce_RxParity;
      if FlagIsSet(Value, lsFraming) then
        Result := Result or ce_Frame;
      if FlagIsSet(Value, lsBreak) then
        Result := Result or ce_Break;
    end;

  begin
    EnterCriticalSection(DataSection);
    try
      FindTriggerFromHandle(TriggerHandle, False, T, Pointer(Trigger));
      if (Trigger <> nil) and (T = ttStatus) then
        with Trigger^ do begin
          if Activate then begin
            case tSType of
              stLine  :
                tValue := SetLineBits(Value);
              stModem :
                begin
                  {Hi tValue is delta mask, Lo is current modem status}
                  LH(tValue).H := Value;
                  LH(tValue).L := Value and ModemStatus;
                end;
              stOutBuffFree,
              stOutBuffUsed :
                tValue := Value;
            end;
            if DLoggingOn then
              AddDispatchEntry(dtTriggerDataChange, dstStatusTrigger,
                TriggerHandle, @tValue, sizeof(Cardinal));
          end;
          tSActive := Activate;
          Result := ecOK;
        end
      else
        Result := ecBadTriggerHandle;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  class procedure TApdBaseDispatcher.ClearSaveBuffers(var Save : TTriggerSave);
  begin
    with Save do begin
      if tsTimerTriggers <> nil then begin
        while tsTimerTriggers.Count > 0 do begin
          Dispose(PTimerTrigger(tsTimerTriggers[0]));
          tsTimerTriggers.Delete(0);
        end;
        tsTimerTriggers.Free;
        tsTimerTriggers := nil;
      end;
      if tsDataTriggers <> nil then begin
        while tsDataTriggers.Count > 0 do begin
          Dispose(PDataTrigger(tsDataTriggers[0]));
          tsDataTriggers.Delete(0);
        end;
        tsDataTriggers.Free;
        tsDataTriggers := nil;
      end;
      if tsStatusTriggers <> nil then begin
        while tsStatusTriggers.Count > 0 do begin
          Dispose(PStatusTrigger(tsStatusTriggers[0]));
          tsStatusTriggers.Delete(0);
        end;
        tsStatusTriggers.Free;
        tsStatusTriggers := nil;
      end;
    end;
  end;

  procedure TApdBaseDispatcher.SaveTriggers(var Save : TTriggerSave);
    {-Saves all current triggers to Save}
  var
    i : Integer;
    NewTimerTrigger : PTimerTrigger;
    NewDataTrigger : PDataTrigger;
    NewStatusTrigger : PStatusTrigger;
  begin
    with Save do begin
      EnterCriticalSection(DataSection);
      try
        ClearSaveBuffers(Save);

        tsLenTrigger := LenTrigger;
        tsTimerTriggers := TList.Create;
        for i := 0 to pred(TimerTriggers.Count) do begin
          NewTimerTrigger := AllocMem(sizeof(TTimerTrigger));
          move(PTimerTrigger(TimerTriggers[i])^, NewTimerTrigger^,
            sizeof(TTimerTrigger));
          tsTimerTriggers.Add(NewTimerTrigger);
        end;
        tsDataTriggers := TList.Create;
        for i := 0 to pred(DataTriggers.Count) do begin
          NewDataTrigger := AllocMem(sizeof(TDataTrigger));
          move(PDataTrigger(DataTriggers[i])^, NewDataTrigger^,
            sizeof(TDataTrigger));
          tsDataTriggers.Add(NewDataTrigger);
        end;
        tsStatusTriggers := TList.Create;
        for i := 0 to pred(StatusTriggers.Count) do begin
          NewStatusTrigger := AllocMem(sizeof(TStatusTrigger));
          move(PStatusTrigger(StatusTriggers[i])^, NewStatusTrigger^,
            sizeof(TStatusTrigger));
          tsStatusTriggers.Add(NewStatusTrigger);
        end;
      finally
        LeaveCriticalSection(DataSection);
      end;
    end;
  end;

  procedure TApdBaseDispatcher.RestoreTriggers(var Save : TTriggerSave);
    {-Restores previously saved triggers}
  var
    i : Integer;
    NewTimerTrigger : PTimerTrigger;
    NewDataTrigger : PDataTrigger;
    NewStatusTrigger : PStatusTrigger;
  begin
    with Save do begin
      EnterCriticalSection(DataSection);
      try
        LenTrigger := tsLenTrigger;
        while TimerTriggers.Count > 0 do begin
          Dispose(PTimerTrigger(TimerTriggers[0]));
          TimerTriggers.Delete(0);
        end;
        while DataTriggers.Count > 0 do begin
          Dispose(PDataTrigger(DataTriggers[0]));
          DataTriggers.Delete(0);
        end;
        while StatusTriggers.Count > 0 do begin
          Dispose(PStatusTrigger(StatusTriggers[0]));
          StatusTriggers.Delete(0);
        end;
        if tsTimerTriggers <> nil then
          for i := 0 to pred(tsTimerTriggers.Count) do begin
            NewTimerTrigger := AllocMem(sizeof(TTimerTrigger));
            move(PTimerTrigger(tsTimerTriggers[i])^, NewTimerTrigger^,
              sizeof(TTimerTrigger));
            TimerTriggers.Add(NewTimerTrigger);
          end;
        if tsDataTriggers <> nil then
          for i := 0 to pred(tsDataTriggers.Count) do begin
            NewDataTrigger := AllocMem(sizeof(TDataTrigger));
            move(PDataTrigger(tsDataTriggers[i])^, NewDataTrigger^,
              sizeof(TDataTrigger));
            DataTriggers.Add(NewDataTrigger);
          end;
        if tsStatusTriggers <> nil then
          for i := 0 to pred(tsStatusTriggers.Count) do begin
            NewStatusTrigger := AllocMem(sizeof(TStatusTrigger));
            move(PStatusTrigger(tsStatusTriggers[i])^, NewStatusTrigger^,
              sizeof(TStatusTrigger));
            StatusTriggers.Add(NewStatusTrigger);
          end;
      finally
        LeaveCriticalSection(DataSection);
      end;
    end;
  end;

  function TApdBaseDispatcher.ChangeBaud(NewBaud : Integer) : Integer;
    {-Change the baud rate of port H to NewBaud}
  begin
    Result := SetLine(NewBaud, DontChangeParity, DontChangeDatabits,
      DontChangeStopbits);
  end;

  function TApdBaseDispatcher.SetDataPointer(P : Pointer; Index : Cardinal) : Integer;
    {-Set a data pointer}
  begin
    EnterCriticalSection(DataSection);
    try
      if (Index >= 1) and (Index <= MaxDataPointers) then begin
        DataPointers[Index] := P;
        Result := ecOK;
      end else
        Result := ecBadArgument;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.GetDataPointer(var P : Pointer;
                           Index : Cardinal) : Integer;
    {-Return a data pointer}
  begin
    EnterCriticalSection(DataSection);
    try
      if (Index >= 1) and (Index <= MaxDataPointers) then begin
        P := DataPointers[Index];
        Result := ecOK;
      end else
        Result := ecBadArgument;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.GetFlowOptions(var HWOpts, SWOpts, BufferFull,
        BufferResume : Cardinal; var OnChar, OffChar : AnsiChar) : Integer;
  begin
    HWOpts := 0;
    SWOpts := 0;

    EnterCriticalSection(DataSection);
    try
      Result := GetComState(DCB);

      if (DCB.Flags and dcb_DTR_CONTROL_HANDSHAKE) <> 0 then
        HWOpts := HWOpts or hfUseDtr;

      if (DCB.Flags and dcb_RTS_CONTROL_HANDSHAKE) <> 0 then
        HWOpts := HWOpts or hfUseRts;

      if (DCB.Flags and dcb_OutxDsrFlow) <> 0 then
        HWOpts := HWOpts or hfRequireDsr;

      if (DCB.Flags and dcb_OutxCtsFlow) <> 0 then
        HWOpts := HWOpts or hfRequireCts;

      if (DCB.Flags and dcb_InX) <> 0 then
        SWOpts := SWOpts or sfReceiveFlow;

      if (DCB.Flags and dcb_OutX) <> 0 then
        SWOpts := SWOpts or sfTransmitFlow;

      OnChar := DCB.XOnChar;
      OffChar := DCB.XOffChar;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.OptionsOn(Options : Cardinal);
    {-Enable the port options in Options}
  begin
    EnterCriticalSection(DataSection);
    try
      Flags := Flags or Options;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.OptionsOff(Options : Cardinal);
    {-Disable the port options in Options}
  begin
    EnterCriticalSection(DataSection);
    try
      Flags := Flags and not Options;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.OptionsAreOn(Options : Cardinal) : Boolean;
    {-Return True if the specified options are on}
  begin
    EnterCriticalSection(DataSection);
    try
      Result := (Flags and Options) = Options;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.ClearTracing : Integer;
    {-Clears the trace buffer}
  begin
    Result := ecOK;
    EnterCriticalSection(DataSection);
    try
      TraceIndex := 0;
      TraceWrapped := False;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.AbortTracing;
    {-Stops tracing and destroys the tracebuffer}
  begin
    EnterCriticalSection(DataSection);
    try
      TracingOn := False;
      if TraceQueue <> nil then begin
        FreeMem(TraceQueue, TraceMax*2);
        TraceQueue := nil;
      end;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.InitTracing(NumEntries : Cardinal) : Integer;
    {-Prepare a circular tracing queue}
  begin
    EnterCriticalSection(DataSection);
    try
      if TraceQueue <> nil then
        {Just clear buffer if already on}
        ClearTracing
      else begin
        {Limit check size of trace buffer}
        if NumEntries > HighestTrace then begin
          Result := ecBadArgument;
          exit;
        end;

        {Allocate trace buffer and start tracing}
        TraceMax := NumEntries;
        TraceIndex := 0;
        TraceWrapped := False;
        TraceQueue := AllocMem(NumEntries*2);
      end;
      TracingOn := True;
      Result := ecOK;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.AddTraceEntry(CurEntry : AnsiChar; CurCh : AnsiChar);
    {-Add a trace event to the global TraceQueue}
  begin
    EnterCriticalSection(DataSection);
    try
      if TraceQueue <> nil then begin
        TraceQueue^[TraceIndex].EventType := CurEntry;
        TraceQueue^[TraceIndex].C := CurCh;
        Inc(TraceIndex);
        if TraceIndex = TraceMax then begin
          TraceIndex := 0;
          TraceWrapped := True;
        end;
      end;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.DumpTracePrim(FName : string;
                          AppendFile, InHex, AllHex : Boolean) : Integer;
    {-Write the TraceQueue to FName}
  const
    Digits : array[0..$F] of AnsiChar = '0123456789ABCDEF';
    LowChar : array[Boolean] of Byte = (32, 33);
  var
    Start, Len : Cardinal;
    TraceFile : Text;
    TraceFileBuffer : array[1..512] of AnsiChar;
    LastEventType : AnsiChar;
    First : Boolean;
    Col : Cardinal;
    I : Cardinal;
    Res : Cardinal;

    procedure CheckCol(N : Cardinal);
      {-Wrap if N bytes would exceed column limit}
    begin
      Inc(Col, N);
      if Col > MaxTraceCol then begin
        WriteLn(TraceFile);
        Col := N;
      end;
    end;

    function HexB(B : Byte) : AnsiString;
      {-Return hex string for byte}
    begin
      SetLength(Result, 2);
      HexB[1] := Digits[B shr 4];
      HexB[2] := Digits[B and $F];
    end;

  begin
    Result := ecOK;

    {Make sure we have something to do}
    if TraceQueue = nil then
      Exit;

    {Turn tracing off now}
//    TracingOn := False;                                                   // SWB

    EnterCriticalSection(DataSection);
    try
      {Set the Start and Len markers}
      Len := TraceIndex;
      if TraceWrapped then
        Start := TraceIndex
      else if TraceIndex <> 0 then
        Start := 0
      else begin
        {No events, just exit}
//        AbortTracing;                                                     // SWB
        Exit;
      end;

      Assign(TraceFile, FName);
      SetTextBuf(TraceFile, TraceFileBuffer, SizeOf(TraceFileBuffer));
      if AppendFile and ExistFileZ(FName) then begin
        {Open an existing file}
        Append(TraceFile);
        Res := IoResult;
      end else begin
        {Open new file}
        ReWrite(TraceFile);
        Res := IoResult;
      end;
      if Res <> ecOK then begin
        Result := -Res;
        AbortTracing;
        Exit;
      end;

      try
        {Write the trace queue}
        LastEventType := #0;
        First := True;
        Col := 0;
        repeat
          {Some formattting}
          with TraceQueue^[Start] do begin
            if EventType <> LastEventType then begin
              if not First then begin
                WriteLn(TraceFile,^M^J);
                Col := 0;
              end;
              {First := False;}
              case EventType of
                'T' : WriteLn(TraceFile, 'Transmit: ');
                'R' : WriteLn(TraceFile, 'Receive: ');
                else  WriteLn(TraceFile, 'Special-'+EventType+': ');
              end;
              LastEventType := EventType;
            end;

            {Write the current char}
            if AllHex then begin
              CheckCol(4);
              Write(TraceFile, '[',HexB(Ord(C)),']');
            end else
            if (Ord(C) < LowChar[InHex]) or (Ord(C) > 126) then begin
              if InHex then begin
                CheckCol(4);
                Write(TraceFile, '[',HexB(Ord(C)),']')
              end else begin
                if Ord(C) > 99 then
                  I := 5
                else if Ord(C) > 9 then
                  I := 4
                else
                  I := 3;
                CheckCol(I);
                Write(TraceFile, '[',Ord(C),']')
              end;
            end else begin
              CheckCol(1);
              Write(TraceFile, C);
            end;

            {Get the next char}
            Inc(Start);
            if Start = TraceMax then
              Start := 0;
          end;
          First := False;
        until Start = Len;

      finally
        Close(TraceFile);
        Result := -IoResult;
//        AbortTracing;                                                     // SWB
        InitTracing(TraceMax);                                              // SWB
      end;

    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.DumpTrace(FName : string;
                      InHex, AllHex : Boolean) : Integer;
    {-Write the TraceQueue to FName}
  begin
    Result := DumpTracePrim(FName, False, InHex, AllHex);
  end;

  function TApdBaseDispatcher.AppendTrace(FName : string;
                        InHex, AllHex : Boolean) : Integer;
    {-Append the TraceQueue to FName}
  begin
    Result := DumpTracePrim(FName, True, InHex, AllHex);
  end;

  procedure TApdBaseDispatcher.StartTracing;
    {-Restarts tracing after a StopTracing}
  begin
    EnterCriticalSection(DataSection);
    try
      if TraceQueue <> nil then
        TracingOn := True;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.StopTracing;
    {-Stops tracing temporarily}
  begin
    EnterCriticalSection(DataSection);
    try
      TracingOn := False;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.ClearDispatchLogging;
    {-Clear the dispatch log}
  begin
    DLoggingQueue.Clear;                                                    // SWB
  end;

  procedure TApdBaseDispatcher.AbortDispatchLogging;
    {-Abort dispatch logging}
  begin
    DLoggingOn := False;
    DLoggingQueue.Clear;                                                    // SWB
  end;

  procedure TApdBaseDispatcher.StartDispatchLogging;
    {-Restarts logging after a pause}
  begin
    DLoggingOn := True;
  end;

  procedure TApdBaseDispatcher.StopDispatchLogging;
    {-Pause dispatch logging}
  begin
    DLoggingOn := False;
  end;

  procedure TApdBaseDispatcher.InitDispatchLogging(QueueSize : Cardinal);
    {-Enable dispatch logging}
  begin
    ClearDispatchLogging;
    DLoggingMax := QueueSize;
    DLoggingOn := True;
  end;

  {apro.str offsets used for logging strings:}
  const
    drTypeBase    = 15001;
    drSubTypeBase = 15100;
    Header1       = 15501;
    Header2       = 15502;
    MaxTelnetTag  = 42;
    TelnetBase    = 15700;
    MSTagBase     = 15601;

  function GetDTStr(drType : TDispatchType) : string;
  begin
    Result := AproLoadStr(drTypeBase + ord(drType));
  end;

  function GetDSTStr(drsType : TDispatchSubType) : string;
  begin
    if drsType = dstNone then
      Result := ''
    else
      Result := AproLoadStr(drSubTypeBase + ord(drsType));
  end;

  function GetTimeStr(drTime : DWORD) : string;
  begin
    Result := Format('%07.7d', [drTime]);
    Insert('.', Result, Length(Result) - 2);                             {!!.04}
  end;

  function TApdBaseDispatcher.DumpDispatchLogPrim(FName : string;
                                                  AppendFile, InHex, AllHex : Boolean) : Integer;

    {-Dump the dispatch log}
  const
    StartColumn = 45;
    Digits : array[0..$F] of AnsiChar = '0123456789ABCDEF';
    LowChar : array[Boolean] of Byte = (32, 33);
  var
    I, J : Cardinal;
    Col : Cardinal;
    Res : Integer;
    DumpFile : Text;
    C : AnsiChar;
    LogFileBuffer : array[1..512] of AnsiChar;
    S : string[80];
    logBfr      : TLogBuffer;                                               // SWB

    function GetOSVersion : string;
    var
      OSVersion : TOSVersionInfo;
      SerPack : string;                                                  {!!.04}
    begin
      OSVersion.dwOSVersionInfoSize := SizeOf(OSVersion);
      GetVersionEx(OSVersion);
      SerPack := '';                                                     {!!.04}

      case OSVersion.dwPlatformID of
        VER_PLATFORM_WIN32s        : begin                               {!!.04}
          SerPack := StrPas(OSVersion.szCSDVersion);                     {!!.04}
          Result := 'Win32s on Windows ';
        end;                                                             {!!.04}
        VER_PLATFORM_WIN32_WINDOWS : begin                               {!!.04}
          case OsVersion.dwMinorVersion of                               {!!.04}
            0 : if Trim(OsVersion.szCSDVersion[1]) = 'B' then            {!!.04}
                  Result := 'Win32 on Windows 95 OSR 2 '                 {!!.04}
                else                                                     {!!.04}
                  Result := 'Win32 on Windows 95 OSR 1 ';                {!!.04}
            10 : if Trim(OsVersion.szCSDVersion[1]) = 'A' then           {!!.04}
                   Result := 'Win32 on Windows 98 OSR 2 '                {!!.04}
                 else                                                    {!!.04}
                   Result := 'Win32 on Windows 98 OSR 1 ';               {!!.04}
            90 : if (OsVersion.dwBuildNumber = 73010104) then            {!!.04}
                   Result := 'Win32 on Windows ME ';                     {!!.04}
          else Result := 'Win32 on Windows 9x';                          {!!.04}
          end;                                                           {!!.04}
        end;                                                             {!!.04}
        VER_PLATFORM_WIN32_NT      : begin                               {!!.04}
          SerPack := StrPas(OSVersion.szCSDVersion);                     {!!.04}
          case OSVersion.dwMajorVersion of                               {!!.04}
            2 : if OsVersion.dwMinorVersion = 6 then                     // --sm
                  Result := 'Window CE ';                                // --sm
            3 : Result := 'Windows NT 3.5 ';                             {!!.04}
            4 : Result := 'Windows NT 4 ';                               {!!.04}
            5 : case OSVersion.dwMinorVersion of                         {!!.04}
                0 : Result := 'Windows 2000 ';                           {!!.04}
                1 : Result := 'Windows XP ';                             {!!.04}
                2 : Result := 'Windows 2003 ';                           // --sm
                end;
            6 : case OSVersion.dwMinorVersion of                         // --sm
                0 : Result := 'Windows Vista ';                          // --sm
                1 : Result := 'Windows 7 ';                              // --sm
                end;                                                     {!!.04}
            else Result := 'WinNT ';                                     {!!.04}
          end;                                                           {!!.04}
        end;                                                             {!!.04}
        else Result := 'Unknown';
      end;
      Result := Result + IntToStr(OSVersion.dwMajorVersion) + '.' +
        IntToStr(OSVersion.dwMinorVersion) + ' ' + SerPack;              {!!.04}
    end;

    procedure CheckCol(N : Cardinal);
      {-Wrap if N bytes would exceed column limit}
    begin
      Inc(Col, N);
      if Col > MaxTraceCol then begin
        WriteLn(DumpFile);
        Write(DumpFile, '':StartColumn-1);
        Col := StartColumn+N;
      end;
    end;

  begin
    Result := ecOK;

    {Make sure we have something to do}
    if ((DLoggingQueue = nil) or                                            // SWB
        (DLoggingQueue.Count = 0)) then begin                               // SWB
//      AbortDispatchLogging;                                               // SWB
      Exit;
    end;

    EnterCriticalSection(DataSection);
    try
      Assign(DumpFile, FName);
      SetTextBuf(DumpFile, LogFileBuffer, SizeOf(LogFileBuffer));
      if AppendFile and ExistFileZ(FName) then begin
        {Append to existing file}
        Append(DumpFile);
        Res := IoResult;
      end else begin
        {Create new file}
        Rewrite(DumpFile);
        Res := IoResult;
      end;
      if Res <> 0 then begin
        Result := -Res;
        Close(DumpFile);
        if IoResult <> 0 then ;
        Exit;
      end;

      {Write heading just once}
      {$IFDEF APAX}
        WriteLn(DumpFile, 'APAX', ApaxVersionStr);
      {$ELSE}
        WriteLn(DumpFile, 'APRO ', ApVersionStr);
        {write compiler version to log}
        S := 'RAD Studio XEn';

        WriteLn(DumpFile, 'Compiler : ', S);
      {$ENDIF}

      {write operating system to log}
      S := ShortString(GetOSVersion());
      WriteLn(DumpFile, 'Operating System : ', S);

      WriteLn(DumpFile, 'Device: ', DeviceName);

      S := ShortString(FormatDateTime('dd/mm/yy, hh:mm:ss', Now));       {!!.02}
      WriteLn(DumpFile, 'Date/time: ', S);                               {!!.02}

      WriteLn(DumpFile, AproLoadStr(Header1));
      WriteLn(DumpFile, AproLoadStr(Header2));

      {Loop through all entries}
      repeat
        {Get the next entry and remove from queue}
        logBfr := TLogBuffer(DLoggingQueue.Pop);                            // SWB
        {Write a report line}
        if (Assigned(logBfr)) then begin                                    // SWB
          with logBfr do begin
            Write(DumpFile, format('%8s  %-8s  %-12s  %08.8x  ',
              [GetTimeStr(drTime),GetDTStr(drType),GetDSTStr(drSubType),drData]));
            if drMoreData = 0 then begin

              {Add telnet tags if necessary}
              if drType = dtTelnet then begin
                S := ' [';
                if drData <= MaxTelnetTag then
                  S := S + ShortString(AproLoadStr(TelnetBase + ord(drData)));
                Write(DumpFile, trim(string(S)),']');
              end;

              WriteLn(DumpFile)
            end else begin
              if (drSubType = dstStatusTrigger)
              and ((drType = dtTriggerAlloc)
              or (drType = dtTriggerDispose))
              then begin
                case Byte(drBuffer^) of                                     // SWB
                0 : Write(DumpFile, '(Not active)');
                1 : Write(DumpFile, '(Modem status)');
                2 : Write(DumpFile, '(Line status)');
                3 : Write(DumpFile, '(Output buffer free)');
                4 : Write(DumpFile, '(Output buffer used)');
                5 : Write(DumpFile, '(Output sent)');
                end;
              end else begin
                Col := StartColumn;
                for I := 0 to (drMoreData - 1) do begin                     // SWB
                  C := (drBuffer + I)^;                                     // SWB
                  if AllHex then begin
                    if drType = dtUser then begin
                      CheckCol(1);
                      Write(DumpFile, C);
                    end else begin
                      CheckCol(4);
                      Write(DumpFile, '[',IntToHex(Ord(C), 2),']');
                    end;
                  end else
                  if (Ord(C) < LowChar[InHex]) or (Ord(C) > 126) then begin
                    if InHex then begin
                      CheckCol(4);
                      Write(DumpFile, '[',IntToHex(Ord(C),2),']')
                    end else begin
                      if Ord(C) > 99 then
                        J := 5
                      else if Ord(C) > 9 then
                        J := 4
                      else
                        J := 3;
                      CheckCol(J);
                      Write(DumpFile, '[',Ord(C),']')
                    end;
                  end else begin
                    CheckCol(1);
                    Write(DumpFile, C);
                  end;
                end;
              end;

              {Add modem status tags}
              if drSubType = dstModemStatus then begin
                S := ' (';
                for I := 0 to 7 do
                  if Odd(drData shr I) then
                    S := S + ShortString(AproLoadStr(MSTagBase + I));
                Write(DumpFile, trim(string(S)),')');
              end;

              WriteLn(DumpFile);

            end;
          end;
          logBfr.Free;                                                      // SWB
        end;
      until (not Assigned(logBfr));                                         // SWB

      Close(DumpFile);
      Result := -IoResult;
//      AbortDispatchLogging;                                               // SWB
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.DumpDispatchLog(
                            FName : string;
                            InHex, AllHex : Boolean) : Integer;

    {-Dump the dispatch log}
  begin
    Result := DumpDispatchLogPrim(FName, False, InHex, AllHex);
  end;

  function TApdBaseDispatcher.AppendDispatchLog(
                              FName : string;
                              InHex, AllHex : Boolean) : Integer;
    {-Append the dispatch log}
  begin
    Result := DumpDispatchLogPrim(FName, True, InHex, AllHex);
  end;

  function TApdBaseDispatcher.GetDispatchTime : DWORD;
    {-Return elapsed time}
  begin
    Result := (AdTimeGetTime - TimeBase);
  end;

  procedure TApdBaseDispatcher.AddDispatchEntry(
                             DT : TDispatchType;
                             DST : TDispatchSubType;
                             Data : Cardinal;
                             Buffer : Pointer;
                             BufferLen : Cardinal);
  var
    logBuf      : TLogBuffer;                                               // SWB
  begin
    if DLoggingOn then                                                 {!!.02}
    begin                                                                   // SWB
        // If there is a limit to the log queue size and we have            // SWB
        // exceeded it, pop the oldest entries from the queue until we      // SWB
        // are under the limit again.                                       // SWB
        while ((DLoggingMax > 0) and                                        // SWB
               (Cardinal(DLoggingQueue.BytesQueued) > DLoggingMax)) do      // SWB
        begin                                                               // SWB
            logBuf := TLogBuffer(DLoggingQueue.Pop);                        // SWB
            logBuf.Free;                                                    // SWB
        end;                                                                // SWB
        // Add the new entry to the queue                                   // SWB
        logBuf := TLogBuffer.Create(DT,                                     // SWB
                                    DST,                                    // SWB
                                    GetDispatchTime,                        // SWB
                                    Data,                                   // SWB
                                    PAnsiChar(Buffer),                          // SWB
                                    BufferLen);                             // SWB
        DLoggingQueue.Push(logBuf);                                         // SWB
    end;                                                                    // SWB
  end;

  function TApdBaseDispatcher.ClassifyStatusTrigger(
                                  TriggerHandle : Cardinal) : Cardinal;
    {-Return the type for TriggerHandle}
  begin
    Result := TriggerHandle and StatusTypeMask;
  end;

  procedure TApdBaseDispatcher.SetEventBusy(
                         var WasOn : Boolean;
                         SetOn : Boolean);
    {-Set/Clear the event busy flag}
  begin
    EnterCriticalSection(DataSection);
    try
      WasOn := fEventBusy;
      fEventBusy := SetOn;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function PortIn(Address: Word): Byte;
    {-Use this instead of Port since it works in both 16 and 32-bit mode}
    asm
      mov dx,ax
      in  al,dx
    end;


  procedure TApdBaseDispatcher.SetRS485Mode(OnOff : Boolean);
    {-Set/reset the RS485 flag}
  var
    LocalBaseAddress : Word;

    procedure GetLocalBaseAddress;
    {Undocumented function returns the base address in edx}
    {$ifndef CPUX64}
    asm
      mov    eax,CidEX
      push   eax
      push   10
      call   EscapeCommFunction  //  (CidEx, 10);
      mov    LocalBaseAddress, dx
    end;
    {$else}
    asm
      mov    ecx, CidEX
      mov    rdx,10
      call   EscapeCommFunction  //  (CidEx, 10);
      mov    LocalBaseAddress, dx
    end;
    {$endif}

  begin
    EnterCriticalSection(DataSection);
    try
      RS485Mode := OnOff;

      if RS485Mode then begin
        {Handle entering RS485 mode}
        if Assigned(OutThread) then
          OutThread.Priority :=
            TThreadPriority(Ord(tpHigher) + ThreadBoost);
        if Win32Platform <> VER_PLATFORM_WIN32_NT then begin
          GetLocalBaseAddress;
          BaseAddress := LocalBaseAddress;
        end;
      end else begin
        if Assigned(OutThread) then
          OutThread.Priority :=
            TThreadPriority(Ord(tpNormal) + ThreadBoost);
      end;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdBaseDispatcher.SetBaseAddress(NewBaseAddress : Word);
    {-Set the base address}
  begin
    EnterCriticalSection(DataSection);
    try
      BaseAddress := NewBaseAddress;
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  function TApdBaseDispatcher.GetBaseAddress : Word;
    {-Get the base address}
  begin
    Result := BaseAddress;
  end;

  constructor TApdDispatcherThread.Create(Disp : TApdBaseDispatcher);
  begin
    H := Disp;
    inherited Create(False);
    FreeOnTerminate := True;
  end;

  procedure TApdDispatcherThread.SyncEvent;
  begin
    pTriggerEvent(pMsg,pTrigger,plParam);
  end;

  procedure TApdDispatcherThread.SyncNotify(Msg, Trigger : Cardinal;
    lParam : Integer; Event : TApdNotifyEvent);
  begin
    pMsg := Msg;
    pTrigger := Trigger;
    plParam := lParam;
    pTriggerEvent := Event;
    Synchronize(SyncEvent);
  end;

  procedure TApdDispatcherThread.Sync(Method: TThreadMethod);
  {- public version of Synchronize}
  begin
    Synchronize(Method);
  end;

  {Output event thread}
  procedure TOutThread.Execute;
    {-Wait for and process output events}
  var
    Res : Integer;
    OutOL         : TOverlapped;       {For output event waiting}

    function DataInBuffer : Boolean;
      {indicate whether the output buffer has data to be sent}
    begin
      with H do begin
        EnterCriticalSection(OutputSection);
        try
          DataInBuffer := OBufFull or (OBufHead <> OBufTail);
        finally
          LeaveCriticalSection(OutputSection);
        end;
      end;
    end;

    procedure ProcessOutputEvent(H : TApdBaseDispatcher);
    var
      NumToWrite : Integer;
      NumWritten : DWORD;
      Ok         : Boolean;
      TempBuff   : POBuffer;
    begin
      while DataInBuffer do begin
        with H do begin
          EnterCriticalSection(OutputSection);
          try
          {Check for buffer wrap-around.  If wrap around has occurred,
           use a temp buffer to shuffle around the buffer contents to make the
           data in the buffer reside at contiguous locations.  This is done to
           prevent scheduling delays in the OS from causing us to emit data with
           potentially large gaps in the output stream of bytes when buffer wrap-
           around occurs.}
            if OBufTail < OBufHead then
              NumToWrite := OBufHead - OBufTail
            else begin
              if (OBufHead = 0) then
                NumToWrite := OutQue - OBufTail
              else begin
                GetMem(TempBuff, OBufHead);
                Move(OBuffer^, TempBuff^, OBufHead);
                Move(OBuffer^[OBufTail], OBuffer^, OutQue - OBufTail);
                Move(TempBuff^, OBuffer^[OutQue - OBufTail], OBufHead);
                FreeMem(TempBuff);
                Inc(OBufHead, OutQue - OBufTail);
                NumToWrite := OBufHead;
                OBufTail := 0;
              end;
            end;
          finally
            LeaveCriticalSection(OutputSection);
          end;
          Ok := WriteFile(CidEx,
                          OBuffer^[OBufTail],
                          NumToWrite,
                          NumWritten,
                          @OutOL);
          if not Ok then begin
            if GetLastError = ERROR_IO_PENDING then begin
              {expected -- write is pending}
              {$IFDEF DebugThreadConsole}
              Writeln(ThreadStatus(OutSleep));
              {$ENDIF}
              Res := WaitForMultipleObjects(2,
                                            @OutWaitObjects2,
                                            False,
                                            INFINITE);
              {$IFDEF DebugThreadConsole}
              Writeln(ThreadStatus(OutWake));
              {$ENDIF}
              case Res of
                WAIT_OBJECT_0 :
                  begin
                    {overlapped i/o completed}
                    if GetOverLappedResult(CidEx, OutOL, NumWritten, False) then begin
                      EnterCriticalSection(OutputSection);
                      try
                        Inc(OBufTail, NumWritten);
                        if(OBufTail = OutQue) then
                          OBufTail := 0;
                        { If nothing left in the buffer, reset the }
                        { queue to avoid buffer wrap-arounds. }
                        if(OBufTail = OBufHead) then begin
                          OBufTail := 0;
                          OBufHead := 0;
                        end;
                        OBufFull := False;
                        ResetEvent(OutOL.hEvent);
                      finally
                        LeaveCriticalSection(OutputSection);
                      end;
                    end else begin
                      {GetOverLappedResult failed.}
                    end;
                  end;
                WAIT_OBJECT_0 + 1 :
                  begin
                    {flush buffer requested, acknowledge and exit}
                    SetEvent(GeneralEvent);
                    Exit;
                  end;
                WAIT_TIMEOUT :
                  {couldn't send all data}
              else
                {an unexpected error occurred with WaitForMultipleObjects}
              end;
            end else begin
              {WriteFile failed, but not because of delayed write}
              { Give up on sending this block, update the queue
                pointers, and continue.  We get here if we lose
                carrier during a transmit, and if we continue to
                try to resend the data, we'll loop forever.}
              EnterCriticalSection(OutputSection);
              try
                inc(OBufTail, NumToWrite);
                if (OBufTail = OutQue) then
                  OBufTail := 0;
                { If nothing left in the buffer, reset the queue }
                { to avoid buffer wrap-arounds }
                if (OBufTail = OBufHead) then begin
                  OBufTail := 0;
                  OBufHead := 0;
                end;
                OBufFull := False;
              finally
                LeaveCriticalSection(OutputSection);
              end;
            end;
          end else begin
            { WriteFile completed immediately -- update buffer pointer }
            EnterCriticalSection(OutputSection);
            try
              Inc(OBufTail, NumWritten);
              if (OBufTail = OutQue) then
                OBufTail := 0;
              { If nothing left in the buffer, reset the queue to }
              { avoid buffer wrap-arounds }
              if (OBufTail = OBufHead) then begin
                OBufTail := 0;
                OBufHead := 0;
              end;
              OBufFull := False;
            finally
              LeaveCriticalSection(OutputSection);
            end;
          end;
          {No more data in buffer, if in RS485 mode wait for TE}
          if Win32Platform <> VER_PLATFORM_WIN32_NT then
            if RS485Mode then begin
              repeat
              until (PortIn(BaseAddress+5) and $40) <> 0;
              SetRTS(False);
            end;
        end;
      end;
    end;

  begin
    InterLockedIncrement(H.ActiveThreads);
    try
      FillChar(OutOL, SizeOf(OutOL), #0);
      with H do begin
        {$IFDEF DebugThreads}
        if DLoggingOn then
          AddDispatchEntry(dtThread, dstThreadStart, 3, nil, 0);
        {$ENDIF}

        {set the event used for overlapped i/o to signal completion}
        OutOL.hEvent := SentEvent;

        {Ready to go, set the general event}
        SetEvent(GeneralEvent);

        {Repeat until port is closed}
        repeat
          {$IFDEF DebugThreads}
          if DLoggingOn then
            AddDispatchEntry(dtThread, dstThreadSleep, 3, nil, 0);
          {$ENDIF}

          {Wait for either an output event or a flush event}
          {$IFDEF DebugThreadConsole}
          Writeln(ThreadStatus(OutSleep));
          {$ENDIF}
          Res := WaitForMultipleObjects(2,
                                        @OutWaitObjects1,
                                        False,
                                        INFINITE);
          {$IFDEF DebugThreadConsole}
          Writeln(ThreadStatus(OutWake));
          {$ENDIF}
          {$IFDEF DebugThreads}
          if DLoggingOn then
            AddDispatchEntry(dtThread, dstThreadWake, 3, nil, 0);
          {$ENDIF}

          case Res of
            WAIT_OBJECT_0 :
              begin
                {output event}
                {Exit immediately if thread was killed while waiting}
                if KillThreads then begin
                  {$IFDEF DebugThreads}
                  if DLoggingOn then
                    AddDispatchEntry(dtThread, dstThreadExit, 3, nil, 0);
                  {$ENDIF}
                  {Finished here, okay to close the port}
                  H.ThreadGone(Self);
                  Exit;
                end;

                {We have data to send, so process it...}
                ProcessOutputEvent(H);
              end;
            WAIT_OBJECT_0 + 1 :
              begin
                {flush buffer requested, acknowledge and continue}
                SetEvent(GeneralEvent);
              end;
          else
            {unexpected problem with WaitFor}
          end;
        until KillThreads or ClosePending;
        {$IFDEF DebugThreads}
        if DLoggingOn then
          AddDispatchEntry(dtThread, dstThreadExit, 3, nil, 0);
        {$ENDIF}
      end;
      H.ThreadGone(Self);
    except
      ShowException(ExceptObject,ExceptAddr);
    end;
  end;

  {Communications event thread}
  procedure TComThread.Execute;
    {-Wait for and process communications events}
  var
    Junk     : DWORD;
    LastMask : Integer;
    Timeouts : TCommTimeouts;
    ComOL    : TOverlapped;       {For com event waiting}
  begin
    InterLockedIncrement(H.ActiveThreads);
    try
      FillChar(ComOL, SizeOf(ComOL), #0);
      with H do begin
        {$IFDEF DebugThreads}
        if DLoggingOn then
          AddDispatchEntry(dtThread, dstThreadStart, 1, nil, 0);
        {$ENDIF}

        ComOL.hEvent := CreateEvent(nil, True, False, nil);

        {Set our standard win32 events}

        { Note, NuMega's BoundsChecker will flag a bogus error on the }
        { following statement because we use the undocumented ring_te flag }

        if Win32Platform = VER_PLATFORM_WIN32_NT then
          LastMask := DefEventMask and not ev_RingTe
        else
          LastMask := DefEventMask;
        SetCommMask(CidEx, LastMask);

        FillChar(Timeouts, SizeOf(TCommTimeouts), 0);
        Timeouts.ReadIntervalTimeout := MaxDWord;
        SetCommTimeouts(CidEx, Timeouts);

        {Ready to go, set the general event}
        SetEvent(GeneralEvent);

        {Repeat until port is closed}
        repeat
          {$IFDEF DebugThreads}
          if DLoggingOn then
            AddDispatchEntry(dtThread, dstThreadSleep, 1, nil, 0);
          {$ENDIF}

          {$IFDEF DebugThreadConsole}
          Writeln(ThreadStatus(ComSleep));
          {$ENDIF}

          {Release time slice until we get a communications event}
          if not WaitComEvent(CurrentEvent, @ComOL) then begin
            if GetLastError = ERROR_IO_PENDING then begin
              if GetOverLappedResult(CidEx,
                                     ComOL,
                                     Junk,
                                     True) then begin

                {WIN32 bug workaround: Apro gets the modem status bits
                with a call (later) to GetCommModemStatus. Unfortunately,
                that routine never seems to return either RI or TERI.
                So, we note either EV_RING or EV_RINGTE here and later
                manually merge the TERI bit into ModemStatus.}
                if ((CurrentEvent and EV_RINGTE) <> 0) or
                   ((CurrentEvent and EV_RING) <> 0) then
                  RingFlag := True;

                {Read complete, reset event}
                ResetEvent(ComOL.hEvent);
              end else begin
                {Port closed or other fatal condition, just exit the thread}
                SetEvent(GeneralEvent);
                CloseHandle(ComOL.hEvent);
                H.ThreadGone(Self);
                Exit;
              end;
            end else begin
              { If we get an ERROR_INVALID_PARAMETER, we assume it's our }
              { use of ev_RingTe -- clear the flag and try again }
              if (GetLastError = ERROR_INVALID_PARAMETER) and
                 (LastMask and EV_RINGTE <> 0) then begin
                LastMask := DefEventMask and not EV_RINGTE;
                SetCommMask(CidEx, LastMask);
              end;
            end;
          end;

          {Exit immediately if thread was killed while waiting}
          if KillThreads then begin
            SetEvent(GeneralEvent);
            {$IFDEF DebugThreads}
            if DLoggingOn then
              AddDispatchEntry(dtThread, dstThreadExit, 1, nil, 0);
            {$ENDIF}
            CloseHandle(ComOL.hEvent);
            H.ThreadGone(Self);
            Exit;
          end;

          {$IFDEF DebugThreadConsole}
          Writeln(ThreadStatus(ComWake));
          {$ENDIF}
          {$IFDEF DebugThreads}
          if DLoggingOn then
            AddDispatchEntry(dtThread, dstThreadWake, 1, @CurrentEvent, 2);
          {$ENDIF}

          {Signal com event}
          SetEvent(ComEvent);

          {$IFDEF DebugThreadConsole}
          Writeln(ThreadStatus(ComSleep));
          {$ENDIF}

          {Wait for the dispatcher thread to complete}
          WaitForSingleObject(ReadyEvent, INFINITE);

          {$IFDEF DebugThreadConsole}
          Writeln(ThreadStatus(ComWake));
          {$ENDIF}

        until KillThreads;

        {$IFDEF DebugThreads}
        if DLoggingOn then
          AddDispatchEntry(dtThread, dstThreadExit, 1, nil, 0);
        {$ENDIF}

        {Finished here, okay to close the port}
        SetEvent(GeneralEvent);
      end;
      CloseHandle(ComOL.hEvent);
      H.ThreadGone(Self);
    except
      ShowException(ExceptObject,ExceptAddr);
    end;
  end;

  procedure TDispThread.Execute;
    {-Wait for and process communications events}
    procedure ProcessComEvent(H : TApdBaseDispatcher);
    {$IFNDEF UseAwWin32}                                                    // SWB
    var                                                                     // SWB
        bfr         : TIOBuffer;                                            // SWB
    {$ENDIF}                                                                // SWB
    begin
      with H do begin
        {$IFNDEF UseAwWin32}                                                // SWB
        // Read the first status packet from the queue & copy its contents  // SWB
        // to CurrentEvent so that the status event handlers can process it.// SWB
        bfr := FQueue.Peek;                                                 // SWB
        if (Assigned(bfr)) then                                             // SWB
        begin                                                               // SWB
            if (bfr is TStatusBuffer) then                                  // SWB
            begin                                                           // SWB
                CurrentEvent := TStatusBuffer(bfr).Status;                  // SWB
                FQueue.Pop;                                                 // SWB
                TStatusBuffer(bfr).Free;                                    // KGM
            end else                                                        // SWB
            begin                                                           // SWB
                bfr.InUse := False;                                         // SWB
                CurrentEvent := 0;                                          // SWB
            end;                                                            // SWB
        end else                                                            // SWB
            CurrentEvent := 0;                                              // SWB
        {WIN32 bug workaround: Apro gets the modem status bits              // SWB
        with a call (later) to GetCommModemStatus. Unfortunately,           // SWB
        that routine never seems to return either RI or TERI.               // SWB
        So, we note either EV_RING or EV_RINGTE here and later              // SWB
        manually merge the TERI bit into ModemStatus.}                      // SWB
        if ((CurrentEvent and (EV_RINGTE or EV_RING)) <> 0) then            // SWB
            RingFlag := True;                                               // SWB
        {$ENDIF}                                                            // SWB
        {Check for modem events}
        if CurrentEvent and ModemEvent <> 0 then begin

          {A modem status event...}
          MapEventsToMS(CurrentEvent);

          {$IFDEF DebugThreads}
          if DLoggingOn then
            AddDispatchEntry(dtDispatch, dstModemStatus,
                              ModemStatus, @CurrentEvent, 2);
          {$ENDIF}

          {Check for status triggers}
          if not fEventBusy then begin
            while CheckStatusTriggers do
              if ClosePending then
                Exit;

            {Allow status triggers to hit again}
            if GlobalStatHit then
              ResetStatusHits;
          end;
        end;

        {Check for line events}
        if CurrentEvent and LineEvent <> 0 then begin
          {A line status/error event}
          RefreshStatus;

          {$IFDEF DebugThreads}
          if DLoggingOn then
            AddDispatchEntry(dtDispatch, dstLineStatus,
                              0, @CurrentEvent, 2);
          {$ENDIF}

          {Check for status triggers}
          if not fEventBusy then begin
            while CheckStatusTriggers do
              if ClosePending then
                Exit;

            {Allow status triggers to hit again}
            if GlobalStatHit then
              ResetStatusHits;
          end;
        end;

        { Get any available data }
        ExtractData;

        {Check for received status & data triggers}
        if not fEventBusy then begin
          ModemStatus := GetModemStatus;                                 {!!.06}
          while CheckStatusTriggers do
            if ClosePending then
              Exit;
          while CheckReceiveTriggers do
            if ClosePending then
              Exit;
        end;
        if GlobalStatHit then
          ResetStatusHits;

        {Let the com thread continue...}
        SetEvent(ReadyEvent);
      end;
    end;

    procedure ProcessTimer(H : TApdBaseDispatcher);
    begin
      with H do begin
        if ClosePending then
          Exit;

        if not fEventBusy then begin
          GlobalStatHit := False;

          {Issue all status and timer triggers}

          while (CheckStatusTriggers or CheckTimerTriggers) and not ClosePending do
            ;
          {Allow status triggers to hit again}
          if GlobalStatHit then
            ResetStatusHits;
        end else begin
          {$IFDEF DebugThreads}
          if DLoggingOn then
            AddDispatchEntry(dtError, dstNone, 0, nil, 0);
          {$ENDIF}
        end;
      end;
    end;

  begin
    InterLockedIncrement(H.ActiveThreads);
    try
      with H do begin
        {$IFDEF DebugThreads}
        if DLoggingOn then
          AddDispatchEntry(dtThread, dstThreadStart, 2, nil, 0);
        {$ENDIF}

        try
          {Ready to go, set the general event}
          SetEvent(GeneralEvent);

          {Repeat until port is closed}
          repeat
            {$IFDEF DebugThreads}
            if DLoggingOn then
              AddDispatchEntry(dtThread, dstThreadSleep, 2, nil, 0);
            {$ENDIF}

            {$IFDEF DebugThreadConsole}
            Writeln(ThreadStatus(DispSleep));
            {$ENDIF}

            {Wait for either a com event or a timeout}
            FQueue.WaitForBuffer(50);                                       // SWB
            {$IFDEF DebugThreadConsole}
            Writeln(ThreadStatus(DispWake));
            {$ENDIF}

            {Exit immediately if thread was killed while waiting}
            if KillThreads then begin
              {$IFDEF DebugThreads}
              if DLoggingOn then
                AddDispatchEntry(dtThread, dstThreadExit, 2, nil, 0);
              {$ENDIF}
              {Finished here, okay to close the port}
              Exit;
            end;

            {$IFDEF DebugThreads}
            if DLoggingOn then
              AddDispatchEntry(dtThread, dstThreadWake, 2, nil, 0);
            {$ENDIF}

            {Process it...}
            ProcessComEvent(H);
            ProcessTimer(H);

          until KillThreads or ClosePending;

          {$IFDEF DebugThreads}
          if DLoggingOn then
            AddDispatchEntry(dtThread, dstThreadExit, 2, nil, 0);
          {$ENDIF}

          {Finished here, okay to close the port}
          SetEvent(GeneralEvent);

        finally
          { Make sure DonePortPrim gets called }
          DoDonePortPrim := (ClosePending or KillThreads);
          {$IFDEF DebugThreadConsole}
          Writeln(ThreadStatus(DispKill));
          {$ENDIF}
          H.ThreadGone(Self);
        end;
      end;
    except
      ShowException(ExceptObject,ExceptAddr);
    end;
  end;

procedure LockPortList;
begin
  EnterCriticalSection(PortListSection);
end;

procedure UnlockPortList;
begin
  LeaveCriticalSection(PortListSection);
end;

procedure FinalizeUnit; far;
begin
  PortList.Free;
  PortList := nil;
end;

procedure InitializeUnit;
begin
  PortList := TList.Create;

  FillChar(PortListSection, SizeOf(PortListSection), 0);
  InitializeCriticalSection(PortListSection);
end;

initialization            // SZ FIXME loader lock
  InitializeUnit;

finalization
  FinalizeUnit;
  DeleteCriticalSection(PortListSection);

end.
