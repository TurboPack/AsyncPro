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
 *  Stephen W. Boyd             - Created this module to replace serial port
 *                                dispatcher.  The old dispatcher was too
 *                                prone to suffering input overruns if the
 *                                event handlers didn't return control to
 *                                the dispatch thread fast enough.
 *                                August 2005.
 *  Sulaiman Mah
 *  Sean B. Durkin
 *  Sebastian Zierer
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                   LNSWIN32.PAS 4.06                   *}
{*********************************************************}
{* Win32 serial device layer and dispatcher              *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{  A direct replacement for AwWin32.pas.  The multithreading aspects have been
   redesigned where necessary to make it more efficient and less prone to
   data overruns.  Anything not directly related to multithreading has been
   stolen from AwWin32.pas mostly unchanged.

   TApdTAPIDispatcher stolen in its entirety from AwWin32.pas

   The Win32 Dispatcher now consists of 4 threads.  These are:

   1) TReadThread       - Waits for TStatusThread to notify it that an EV_RXCHAR
                          event has occured and reads as much data as is
                          available at that time.  It also reads any available data
                          every 50 ms just in case we have a misbehaving driver
                          that doesn't provide the EV_RXCHAR event reliably.
                          All data read is placed onto a queue for TDispThread
                          to process.  This allows TDispThread, and hence any
                          event handlers, to take as much time as they need
                          without worrying about data overruns.
   2) TWriteThread      - Waits for output to appear in the dispatcher's output
                          buffer.  It copies all available output to a temporary
                          buffer, marks the dispatcher's buffer as empty and
                          sends the data from the temporary buffer.  This provides
                          a crude double buffering capability and improves
                          performance for streaming protocols like zmodem.
   3) TStatusThread     - Waits for serial port events by calling WaitCommEvent.
                          When an event occurs it either wakes up TReadThread or
                          queues a status change notification to TDispThread as
                          appropriate.
   4) TDispThread       - This is the original TDispThread from AwUser.  It
                          continues largely unchanged from the original. The
                          only real difference is that it now waits for data to
                          appear in the queue and reads from the queue rather than
                          issuing its own WaitCommEvent and ReadFile calls.

   The original serial port dispatcher in AwWin32 can still be used by setting
   the condition UseAwWin32 and recompiling.
}

unit LNSWin32;

interface

uses Windows, AwUser, SysUtils, OoMisc, LNSQueue, SyncObjs;

type
  TApdWin32Thread = class(TApdDispatcherThread)
  private
    function  GetComHandle : THandle;
    function  GetDLoggingOn : Boolean;
    function  GetGeneralEvent : THandle;
    function  GetKillThreads : Boolean;
    function  GetQueue : TIOQueue;
    function  GetSerialEvent : TEvent;
    procedure SetKillThreads(value : Boolean);
    procedure ThreadGone(Sender : TObject);
    procedure ThreadStart(Sender : TObject);
  protected
    procedure AddDispatchEntry(DT : TDispatchType;
                               DST : TDispatchSubType;
                               Data : Cardinal;
                               Buffer : Pointer;
                               BufferLen : Cardinal);
    function  WaitForOverlapped(ovl : POverlapped) : Integer; virtual;

    property ComHandle : THandle read GetComHandle;
    property DLoggingOn : Boolean read GetDLoggingOn;
    property GeneralEvent : THandle read GetGeneralEvent;
    property KillThreads : Boolean read GetKillThreads write SetKillThreads;
    property Queue : TIOQueue read GetQueue;
    property SerialEvent : TEvent read GetSerialEvent;
  end;

  TReadThread = class(TApdWin32Thread)
  protected
    procedure Execute; override;
    function  ReadSerial(Buf : PAnsiChar;
                         Size: Integer;
                         ovl : POverlapped) : Integer;
  end;

  TWriteThread = class(TApdWin32Thread)
  private
    function  GetOutFlushEvent : THandle;
    function  GetOutputEvent : THandle;
  protected
    function  DataInBuffer : Boolean;
    procedure Execute; override;
    function  WaitForOverlapped(ovl : POverlapped) : Integer; override;
    function  WriteSerial(ovl : POverlapped) : Integer;

    property  OutFlushEvent : THandle read GetOutFlushEvent;
    property  OutputEvent : THandle read GetOutputEvent;
  end;

  TStatusThread = class(TApdWin32Thread)
  private
    LastMask        : DWORD;
  protected
    procedure Execute; override;
    function  WaitSerialEvent(var EvtMask : DWORD;
                              ovl : POverlapped) : Integer;
  end;

  TApdWin32Dispatcher = class(TApdBaseDispatcher)
  private
    FSerialEvent    : TEvent;
  protected
    function  EscapeComFunction(Func : Integer) : LongInt; override;
    function  FlushCom(Queue : Integer) : Integer; override;
    function  GetComError(var Stat : TComStat) : Integer; override;
    function  GetComEventMask(EvtMask : Integer) : Cardinal; override;
    function  GetComState(var DCB: TDCB): Integer; override;
    function  InQueueUsed : Cardinal; override;
    function  OutBufUsed: Cardinal; override;
    function  ReadCom(Buf : PAnsiChar; Size: Integer) : Integer; override;
    function  SetComState(var DCB : TDCB) : Integer; override;
    function  SetupCom(InSize, OutSize : Integer) : Boolean; override;
    procedure StartDispatcher; override;
    procedure StopDispatcher; override;
    function  WaitComEvent(var EvtMask : DWORD;
                           lpOverlapped : POverlapped) : Boolean; override;
    function  WriteCom(Buf : PAnsiChar; Size: Integer) : Integer; override;
  public
    constructor Create(Owner : TObject);
    destructor  Destroy; override;
    function  CloseCom : Integer; override;
    function  OpenCom(ComName: PChar; InQueue, OutQueue : Cardinal) : Integer; override;
    function  ProcessCommunications : Integer; override;
    function CheckPort(ComName: PChar): Boolean; override;
  end;

  TApdTAPI32Dispatcher = class(TApdWin32Dispatcher)
  public
    constructor Create(Owner : TObject; InCid : Integer);
    function OpenCom(ComName: PChar; InQueue,
      OutQueue : Cardinal) : Integer; override;
  end;

implementation

uses  Math, StrUtils;

//  TApdWin32Dispatcher methods
//
constructor TApdWin32Dispatcher.Create(Owner : TObject);
begin
    inherited Create(Owner);
    FSerialEvent := TEvent.Create(nil, False, False, '');
end;

destructor  TApdWin32Dispatcher.Destroy;
begin
    if (Assigned(FSerialEvent)) then
        FSerialEvent.Free;
    inherited Destroy;
end;

function TApdWin32Dispatcher.CheckPort(ComName: PChar): Boolean;
// Returns true if a port exists
var
  Tmp: string;
  CC: PCommConfig;
  Len: Cardinal;
begin
  Tmp := ComName;
  if AnsiStartsText('\\.\', Tmp) then
    Delete(Tmp, 1, 4);

  New(CC);
  try
    FillChar(CC^, SizeOf(CC^), 0);
    CC^.dwSize := SizeOf(CC^);
    Len := SizeOf(CC^);
    Result := GetDefaultCommConfig(PChar(Tmp), CC^, Len);
  finally
    Dispose(CC);
  end;
  if (not Result) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
  begin
    GetMem(CC, Len);
    try
      FillChar(CC^, SizeOf(CC^), 0);
      CC^.dwSize := SizeOf(CC^);
      Result := GetDefaultCommConfig(PChar(Tmp), CC^, Len);
    finally
      FreeMem(CC);
    end;
  end;
end;

// Close the comport and wait for the I/O threads to terminate
function TApdWin32Dispatcher.CloseCom : Integer;
var
    ET : EventTimer;
begin
    // Under certain circumstances, it is possible that CloseCom can be called
    // recursively.  In that event, we don't want to be re-executing this code.
    // So, set a flag to show that we are inside this method and check it
    // every time we enter.  If it is already set, just exit and do nothing.
    // This used to be accomplished by acquiring the DataSection critical section
    // but this lead to occasional deadlocks.

    EnterCriticalSection(DataSection);
    if (CloseComActive) then
    begin
        LeaveCriticalSection(DataSection);
        Result := 0;
        Exit;
    end;
    CloseComActive := True;
    LeaveCriticalSection(DataSection);

    try
        if DispActive then
        begin
            { Set the flag to kill the threads next time they wake, or after }
            { their current processing }
            KillThreads := True;

            if Assigned(StatusThread) then
            begin
                {Force the comm thread to wake...}
                SetCommMask(CidEx, 0);
                SetEvent(ReadyEvent);
                {...and wait for it to die}
                while (StatusThread <> nil) do
                    SafeYield;
            end;

            if Assigned(OutThread) then
            begin
                {Force the output thread to wake...}
                SetEvent(OutFlushEvent);
                {...and wait for it to die}
                while (OutThread <> nil) do
                    SafeYield;
            end;

            if Assigned(ComThread) then
            begin
                {Force the comm thread to wake...}
                FSerialEvent.SetEvent;
                {... and wait for it to die}
                ResetEvent(GeneralEvent);
                while (ComThread <> nil) do
                    SafeYield;
            end;

            {Now kill the timer}
            KillTimer(0, TimerID);

            if Assigned(DispThread) then
            begin
                {Wait for it to die}
                NewTimer(ET, 36);  { start a 2-second timer to prevent blocks }
                while (DispThread <> nil) and not(TimerExpired(ET)) do
                    SafeYield;
                if DispThread <> nil then
                begin
                    {$IFDEF DebugThreadConsole}
                    WriteLn('DispThread<>nil');
                    {$ENDIF}
                    { thread didn't die, reset the event }
                    SetEvent(ComEvent);
                    {Wait for it to die yet again}
                    NewTimer(ET, 36);  { start a 2-second timer to prevent blocks }
                    while (DispThread <> nil) and not(TimerExpired(ET)) do
                        SafeYield;
                    if DispThread <> nil then
                        { disp thread is not responding, brutally terminate it }
                        DispThread.Free;
                end;
                {$IFDEF DebugThreadConsole}
                Writeln(ThreadStatus(DispKill));
                {$ENDIF}
            end;
            {$IFDEF DebugThreadConsole}
            Writeln(ThreadStatus(ComKill));
            {$ENDIF}
        end;
        {Close the comport}
        if (CidEx >= 0) then
        begin
            if CloseHandle(CidEx) then
            begin
                Result := 0;
                CidEx := -1;
            end else
                Result := -1;
        end else
            Result := 0;
    finally
        CloseComActive := False;
    end;
end;

function TApdWin32Dispatcher.EscapeComFunction(Func: Integer): LongInt;
begin
    EscapeCommFunction(CidEx, Func);
    Result := 0;
end;
// Flush the I/O buffers.  Queue = 0 - flush output queues.  Queue = 1 - flush input.
function TApdWin32Dispatcher.FlushCom(Queue : Integer) : Integer;
begin
    Result := 0;
    if ((Queue = 0) and Assigned(OutThread)) then
    begin
        // Flush output buffers
        EnterCriticalSection(OutputSection);
        try
            OBufFull := False;
            OBufHead := 0;
            OBufTail := 0;
        finally
            LeaveCriticalSection(OutputSection);
        end;
        Result := Integer(PurgeComm(CidEx, PURGE_TXABORT or PURGE_TXCLEAR));
        // Wake up the output thread in case it was waiting for I/O completion
        // and Windows failed to wake it up after we flushed the buffers.
        SetEvent(OutFlushEvent);
        WaitForSingleObject(GeneralEvent, 5000);
    end;
    if (Queue = 1) then
    begin
        // Flush input buffers
        Result := Integer(PurgeComm(CidEx, PURGE_RXABORT or PURGE_RXCLEAR));
        FQueue.Clear;
    end;
end;
// Get the current error and status
function TApdWin32Dispatcher.GetComError(var Stat: TComStat): Integer;
var
    Errors      : DWORD;
begin
    if (ClearCommError(CidEx, Errors, @Stat)) then
        Result := Errors
    else
        Result := 0;
    {Replace information about Windows output buffer with our own}
    Stat.cbOutQue := OutBufUsed;
end;
// Set the communications event mask
function TApdWin32Dispatcher.GetComEventMask(EvtMask: Integer): Cardinal;
begin
    Result := 0;
end;
// Fill in DCB with the current communications state
function TApdWin32Dispatcher.GetComState(var DCB: TDCB): Integer;
begin
if Integer(GetCommState(CidEx, DCB)) = 1 then
    Result := 0
else
    Result := -1;
end;
// Open the COM port specified by ComName
function TApdWin32Dispatcher.OpenCom(ComName: PChar; InQueue, OutQueue: Cardinal): Integer;
begin
    {Open the device}
    Result := CreateFile(ComName,                       {name}
                         GENERIC_READ or GENERIC_WRITE, {access attributes}
                         0,                             {no sharing}
                         nil,                           {no security}
                         OPEN_EXISTING,                 {creation action}
                         FILE_ATTRIBUTE_NORMAL or
                         FILE_FLAG_OVERLAPPED,          {attributes}
                         0);                            {no template}

    if Result <> Integer(INVALID_HANDLE_VALUE) then
    begin
        CidEx := Result;
    end else
        {Failed to open port, just return error signal, caller will
         call GetLastError to get actual error code}
        Result := -1;
end;
// Return the number of bytes available to be read from the input queue.  Returns
// zero if the first buffer on the queue is not a data buffer, returns the number
// of bytes available in the first buffer otherwise.
function TApdWin32Dispatcher.InQueueUsed : Cardinal;
var
     bfr         : TIOBuffer;
begin
    bfr := FQueue.Peek;
    if (Assigned(bfr)) then
    begin
        if (bfr is TDataBuffer) then
        begin
            Result := TDataBuffer(bfr).BytesUsed - TDataBuffer(bfr).BytesRead;
            bfr.InUse := False;
        end else
        begin
            Result := 0;
            bfr.InUse := False;
        end;
    end else
        Result := 0;
end;
// Return the number of bytes currently used in the output buffer
function TApdWin32Dispatcher.OutBufUsed: Cardinal;
begin
    EnterCriticalSection(OutputSection);
    try
        Result := 0;
        if OBufFull then
            Result := OutQue
        else if OBufHead > OBufTail then
          {Buffer is not wrapped}
            Result := OBufHead - OBufTail
        else if OBufHead < OBufTail then
          {Buffer is wrapped}
            Result := OBufHead + (OutQue - OBufTail);
    finally
        LeaveCriticalSection(OutputSection);
    end;
end;
// Communications are running in separate threads -- give them a chance
function TApdWin32Dispatcher.ProcessCommunications : Integer;
begin
    Sleep(0);
    Result := 0;
end;
//  Rather than reading directly from the serial port, as we used to do, we
//  now read from the input queue.
function TApdWin32Dispatcher.ReadCom(Buf : PAnsiChar; Size: Integer) : Integer;
var
    bfr         : TIOBuffer;
    len         : Integer;
    bytesToRead : Integer;
    done        : Boolean;
begin
    len := Size;
    done := False;
    while (not done) do
    begin
        bfr := FQueue.Peek;
        // We can only read if the first buffer on the queue is a data buffer.
        // If it is a status buffer, it must be processed first.
        if (Assigned(bfr)) then
        begin
            if (bfr is TDataBuffer) then
            begin
                with TDataBuffer(bfr) do
                begin
                    // Read either all the data in the buffer or as much as the caller
                    // can accept.
                    bytesToRead := Min(len, BytesUsed - BytesRead);
                    Move((Data + BytesRead)^, Buf^, bytesToRead);// --sm check
                    BytesRead := BytesRead + bytesToRead;
                    Dec(len, bytesToRead);
                    Inc(Buf, bytesToRead);
                    // If all data has been read from the buffer, remove it from the queue
                    // and free it.  Otherwise, leave it on the queue so we can read
                    // the remainder on the next call to this subroutine.
                    if (BytesRead >= BytesUsed) then
                    begin
                        FQueue.Pop;
                        Free;
                    end else
                        InUse := False;
                    if (len <= 0) then
                        done := True;
                end;
            end else
            begin
                bfr.InUse := False;
                done := True;
            end;
        end else
            done := True;
    end;
    Result := Size - len;                       // ttl # bytes read
end;
// Set the a new communications device state from DCB
function TApdWin32Dispatcher.SetComState(var DCB: TDCB): Integer;
begin
if SetCommState(CidEx, DCB) then
    Result := 0
else
    Result := -Integer(GetLastError);
end;

// Set new in/out buffer sizes
function TApdWin32Dispatcher.SetupCom(InSize, OutSize : Integer) : Boolean;
begin
    Result := SetupComm(CidEx, InSize, OutSize);
end;

//  Start all threads and generally get the dispatcher ready to go
procedure TApdWin32Dispatcher.StartDispatcher;
begin
    EnterCriticalSection(DataSection);
    try
        if (DispActive) then
            raise Exception.Create('Dispatcher already started.');
        DispActive := True;
        KillThreads := False;
        ComThread := TReadThread.Create(Self);
        WaitForSingleObject(GeneralEvent, ThreadStartWait);
        fDispThread := TDispThread.Create(Self);
        WaitForSingleObject(GeneralEvent, ThreadStartWait);
        OutThread := TWriteThread.Create(Self);
        WaitForSingleObject(GeneralEvent, ThreadStartWait);
        StatusThread := TStatusThread.Create(Self);
        WaitForSingleObject(GeneralEvent, ThreadStartWait);
    finally
        LeaveCriticalSection(DataSection);
    end;
end;

//  Shutdown the dispatcher
procedure TApdWin32Dispatcher.StopDispatcher;
begin
    if DispActive then
        CloseCom;

    if ComEvent <> INVALID_HANDLE_VALUE then
    begin
        if CloseHandle(ComEvent) then
            ComEvent := INVALID_HANDLE_VALUE;
    end;

    if ReadyEvent <> INVALID_HANDLE_VALUE then
    begin
        if CloseHandle(ReadyEvent) then
            ReadyEvent := INVALID_HANDLE_VALUE;
    end;

    if GeneralEvent <> INVALID_HANDLE_VALUE then
    begin
        if CloseHandle(GeneralEvent) then
            GeneralEvent := INVALID_HANDLE_VALUE;
    end;

    if OutputEvent <> INVALID_HANDLE_VALUE then
    begin
        if CloseHandle(OutputEvent) then
            OutputEvent := INVALID_HANDLE_VALUE;
    end;

    if SentEvent <> INVALID_HANDLE_VALUE then
    begin
        if CloseHandle(SentEvent) then
            SentEvent := INVALID_HANDLE_VALUE;
    end;

    if OutFlushEvent <> INVALID_HANDLE_VALUE then
    begin
        if CloseHandle(OutFlushEvent) then
            OutFlushEvent := INVALID_HANDLE_VALUE;
    end;
end;

//  This doesn't apply to WIN32 dispatcher any more
function TApdWin32Dispatcher.WaitComEvent(var EvtMask : DWORD;
                                          lpOverlapped : POverlapped) : Boolean;
begin
    EvtMask := 0;
    Result := True;
end;

//  Place outbound data into the output buffer & wake up the output thread
function TApdWin32Dispatcher.WriteCom(Buf: PAnsiChar; Size: Integer): Integer;
type
    PBArray = ^TBArray;
    TBArray = array[0..pred(High(Integer))] of Byte;
var
    SizeAtEnd   : Integer;
    LeftOver    : Integer;
begin
    {Add the data to the output queue}
    EnterCriticalSection(OutputSection);
    try
        {we already know at this point that there is enough room for the block}
        SizeAtEnd := OutQue - OBufHead;
        if SizeAtEnd >= Size then
        begin
            {can move data to output queue in one block}
            Move(Buf^, OBuffer^[OBufHead], Size);
            if SizeAtEnd = Size then
                OBufHead := 0
            else
                Inc(OBufHead, Size);
        end else
        begin
            { need to use two moves }
            Move(Buf^, OBuffer^[OBufHead], SizeAtEnd);
            LeftOver := Size - SizeAtEnd;
            Move(PBArray(Buf)^[SizeAtEnd], OBuffer^, LeftOver);
            OBufHead := LeftOver;
        end;
    finally
      LeaveCriticalSection(OutputSection);
    end;
    {...finally, wake up the output thread to send the data}
    SetEvent(OutputEvent);
    Result := Size;   {report all was sent}
end;

//  TApdWin32Threads.  Contains some general support routines required by both
//  read & write threads.
procedure TApdWin32Thread.AddDispatchEntry(DT : TDispatchType;
                                           DST : TDispatchSubType;
                                           Data : Cardinal;
                                           Buffer : Pointer;
                                           BufferLen : Cardinal);
begin
    TApdWin32Dispatcher(H).AddDispatchEntry(DT, DST, Data, Buffer, BufferLen);
end;

function  TApdWin32Thread.GetComHandle : THandle;
begin
    Result := TApdWin32Dispatcher(H).ComHandle;
end;

function  TApdWin32Thread.GetDLoggingOn : Boolean;
begin
    Result := TApdWin32Dispatcher(H).DLoggingOn;
end;

function  TApdWin32Thread.GetGeneralEvent : THandle;
begin
    Result := TApdWin32Dispatcher(H).GeneralEvent;
end;

function  TApdWin32Thread.GetKillThreads : Boolean;
begin
    Result := TApdWin32Dispatcher(H).KillThreads;
end;

function  TApdWin32Thread.GetQueue : TIOQueue;
begin
    Result := TApdWin32Dispatcher(H).FQueue;
end;

function  TApdWin32Thread.GetSerialEvent : TEvent;
begin
    Result := TApdWin32Dispatcher(H).FSerialEvent;
end;

procedure TApdWin32Thread.SetKillThreads(value : Boolean);
begin
    TApdWin32Dispatcher(H).KillThreads := value;
end;

procedure TApdWin32Thread.ThreadGone(Sender : TObject);
begin
    TApdWin32Dispatcher(H).ThreadGone(Sender);
end;

procedure TApdWin32Thread.ThreadStart(Sender : TObject);
begin
    TApdWin32Dispatcher(H).ThreadStart(Sender);
end;

//  Wait for an overlapped I/O to complete.  We wake up every 100ms and check to
//  see if the dispatcher has been shutdown.
function  TApdWin32Thread.WaitForOverlapped(ovl : POverlapped) : Integer;
var
    stat        : DWORD;
    bytesRead   : Cardinal;
begin
    repeat
        stat := WaitForSingleObject(ovl.hEvent, 100);
    until ((stat <> WAIT_TIMEOUT) or Terminated or KillThreads);
    case stat of
      WAIT_OBJECT_0:
        if (GetOverlappedResult(ComHandle,
                                ovl^,
                                bytesRead,
                                True)) then
        begin
            Result := bytesRead;
            ResetEvent(ovl.hEvent);
        end else
            Result := ecDeviceRead;
      WAIT_TIMEOUT:
        Result := 0;
      else
        Result := ecDeviceRead;
    end;
end;

//  TReadThread methods.  This thread does nothing except wait for input
//  from the comm port.  When input is received it is placed onto the queue
//  for the dispatcher thread to process.
procedure TReadThread.Execute;
var
    dbfr        : TDataBuffer;
    bytesRead   : Integer;
    stat        : TWaitResult;
    rovl        : TOverlapped;
    Timeouts    : TCommTimeouts;
    istat       : Integer;
begin
    ThreadStart(Self);
{$IFDEF DebugThreads}
    if (DLoggingOn) then
        AddDispatchEntry(dtThread, dstThreadStart, 1, nil, 0);
{$ENDIF}
    FillChar(rovl, SizeOf(rovl), 0);
    rovl.hEvent := CreateEvent(nil, True, False, nil);
    dbfr := nil;
    try
        // Set the timeouts so that a read will return immediately.
        FillChar(Timeouts, SizeOf(TCommTimeouts), 0);
        Timeouts.ReadIntervalTimeout := MaxDWord;
        SetCommTimeouts(ComHandle, Timeouts);

        ReturnValue := 0;
        while ((not Terminated) and (not KillThreads)) do
        begin
            // Wait for something to happen on the serial port
{$IFDEF DebugThreads}
            if (DLoggingOn) then
                AddDispatchEntry(dtThread, dstThreadSleep, 1, nil, 0);
{$ENDIF}
            stat := SerialEvent.WaitFor(50);
            if ((stat <> wrSignaled) and (stat <> wrTimeout)) then
            begin
                ReturnValue := ecDeviceRead;
                KillThreads := True;
                Continue;
            end;
{$IFDEF DebugThreads}
            if (DLoggingOn) then
                AddDispatchEntry(dtThread, dstThreadWake, 1, nil, 0);
{$ENDIF}
            // Was it an input arrival notification?  If so, read the
            // available input & queue it to the dispatcher thread.
            try
                if (not Assigned(dbfr)) then
                    dbfr := TDataBuffer.Create(IO_BUFFER_SIZE);
            except
                dbfr := nil;
                ReturnValue := ecNoMem;
                KillThreads := True;
                Continue;
            end;
            bytesRead := ReadSerial(dbfr.Data, dbfr.Size, @rovl);
            while (bytesRead > 0) do
            begin
{$IFDEF DebugThreads}
                if (DLoggingOn) then
                    AddDispatchEntry(dtThread,
                                     dstThreadDataQueued,
                                     ComHandle,
                                     dbfr.Data,
                                     bytesRead);
{$ENDIF}
                dbfr.BytesUsed := bytesRead;
                Queue.Push(dbfr);
                try
                    dbfr := TDataBuffer.Create(IO_BUFFER_SIZE);
                except
                    dbfr := nil;
                    ReturnValue := ecNoMem;
                    KillThreads := True;
                    Break;
                end;
                bytesRead := ReadSerial(dbfr.Data, dbfr.Size, @rovl);
            end;
            if (bytesRead < 0) then
            begin
                istat := GetLastError;
{$IFDEF DebugSerialIO}
                MessageBox(0,
                           PChar(Format('ReadSerial failed! Error = %d.',
                                        [istat])),
                           '',
                           MB_OK or MB_APPLMODAL or MB_ICONEXCLAMATION);
{$ENDIF}
                // An invalid handle error means that someone else (probably
                // TAPI) has closed the port. So just quit without an error.
                if (istat <> ERROR_INVALID_HANDLE) then
                    ReturnValue := ecDeviceRead;
                KillThreads := True;
                Continue;
            end;
        end;
    finally
        CloseHandle(rovl.hEvent);
        if (Assigned(dbfr)) then
            dbfr.Free;
{$IFDEF DebugThreads}
        if (DLoggingOn) then
            AddDispatchEntry(dtThread, dstThreadExit, 1, nil, 0);
{$ENDIF}
        ThreadGone(Self);
    end;
end;
//  Read up to Size bytes from the serial port into Buf.  Return the number of
//  bytes read or a negative error number.  An error code of ERROR_OPERATION_ABORTED
//  is caused by flushing the com port so we just ignore it.
function  TReadThread.ReadSerial(Buf : PAnsiChar;
                                 Size : Integer;
                                 ovl : POverlapped) : Integer;
var
    bytesRead   : Cardinal;
    istat       : Integer;
begin
    if (not ReadFile(ComHandle, Buf^, Size, bytesRead, ovl)) then
    begin
        istat := GetLastError;
        if (istat = ERROR_IO_PENDING) then
        begin
            Result := WaitForOverlapped(ovl);
            if (Result < 0) then
            begin
                istat := GetLastError;
                if (GetLastError = ERROR_OPERATION_ABORTED) then
                    Result := 0
                else
                    TApdBaseDispatcher(H).LastWinError := istat;
            end;
        end else
        begin
            TApdBaseDispatcher(H).LastWinError := istat;
            Result := ecDeviceRead;
        end;
    end else
        Result := bytesRead;
end;
//  TWriteThread methods.  This thread does nothing except wait for data to
//  be written to the comm port.  When output arrives it is written to the
//  port.
function  TWriteThread.DataInBuffer : Boolean;
begin
    with TApdWin32Dispatcher(H) do begin
        EnterCriticalSection(OutputSection);
        try
            DataInBuffer := OBufFull or (OBufHead <> OBufTail);
        finally
            LeaveCriticalSection(OutputSection);
        end;
    end;
end;

procedure TWriteThread.Execute;
var
    outEvents       : array [0..1] of THandle;
    stat            : DWORD;
    ovl             : TOverlapped;
    istat       : Integer;
begin
    ThreadStart(Self);
{$IFDEF DebugThreads}
    if (DLoggingOn) then
        AddDispatchEntry(dtThread, dstThreadStart, 3, nil, 0);
{$ENDIF}
    outEvents[0] := OutputEvent;
    outEvents[1] := OutFlushEvent;
    FillChar(ovl, SizeOf(ovl), 0);
    ovl.hEvent := CreateEvent(nil, True, False, nil);
    try
        ReturnValue := 0;
        while ((not Terminated) and (not KillThreads)) do
        begin
{$IFDEF DebugThreads}
            if (DLoggingOn) then
                AddDispatchEntry(dtThread, dstThreadSleep, 3, nil, 0);
{$ENDIF}
            // Wait for output to appear in the queue or for a flush request
            stat := WaitForMultipleObjects(Length(outEvents),
                                           @outEvents[0],
                                           False,
                                           100);
{$IFDEF DebugThreads}
            if (DLoggingOn) then
                AddDispatchEntry(dtThread, dstThreadWake, 3, nil, 0);
{$ENDIF}
            case stat of
              WAIT_OBJECT_0:
                // Output has arrived in buffer, send it
                if (not KillThreads) then
                    if (WriteSerial(@ovl) <> 0) then
                    begin
                        istat := GetLastError;
{$IFDEF DebugSerialIO}
                        MessageBox(0,
                                   PChar(Format('WriteSerial failed! Error = %d.',
                                                [istat])),
                                   '',
                                   MB_OK or MB_APPLMODAL or MB_ICONEXCLAMATION);
{$ENDIF}
                        // An invalid handle error means that someone else (probably
                        // TAPI) has closed the port. So just quit without an error.
                        if (istat <> ERROR_INVALID_HANDLE) then
                        begin
                            TApdBaseDispatcher(H).LastWinError := istat;
                            ReturnValue := ecDeviceWrite;
                        end;
                        KillThreads := True;
                    end;
              WAIT_OBJECT_0 + 1:
                // Flush of output buffer requested, acknowledge & continue
                SetEvent(GeneralEvent);
              WAIT_TIMEOUT:
                ;
              else
              begin
                TApdBaseDispatcher(H).LastWinError := GetLastError;
                ReturnValue := ecDeviceWrite;
                KillThreads := True;
              end;
            end;
        end;
    finally
        CloseHandle(ovl.hEvent);
{$IFDEF DebugThreads}
        if (DLoggingOn) then
            AddDispatchEntry(dtThread, dstThreadExit, 3, nil, 0);
{$ENDIF}
        ThreadGone(Self);
    end;
end;

function  TWriteThread.GetOutFlushEvent : THandle;
begin
    Result := TApdWin32Dispatcher(H).OutFlushEvent;
end;

function  TWriteThread.GetOutputEvent : THandle;
begin
    Result := TApdWin32Dispatcher(H).OutputEvent;
end;
// Write all data currently in the output buffer to the serial port.  The
// output is copied to a temporary buffer first to free the main output buffer
// faster and to make buffer flush requests easier to handle properly.
function  TWriteThread.WriteSerial(ovl : POverlapped) : Integer;
var
    numToWrite      : Integer;
    numWritten      : Cardinal;
    count           : Integer;
    tempBuff        : POBuffer;
    stat            : Integer;
begin
    tempBuff := nil;
    try
        while (DataInBuffer) do
        begin
            with TApdWin32Dispatcher(H) do
            begin
                EnterCriticalSection(OutputSection);
                try
                    // Move everything from the main buffer to a temporary buffer.
                    // This accomplishes 2 things: 1) It frees the main buffer so that
                    // that main thread can continue writing sooner.  2) It simplifies
                    // matters when we receive a flush request while waiting for I/O
                    // to complete because the flush routine can do its thing without
                    // having to worry about messing with our buffer management.
                    if OBufTail < OBufHead then
                    begin
                        numToWrite := OBufHead - OBufTail;
                        GetMem(tempBuff, numToWrite);
                        Move(OBuffer^[OBufTail], tempBuff^, numToWrite);
                    end else
                    begin
                        numToWrite := (OutQue - OBufTail) + OBufHead;
                        GetMem(tempBuff, numToWrite);
                        Move(OBuffer^[OBufTail], tempBuff^, OutQue - OBufTail);
                        Move(OBuffer^[0], tempBuff^[OutQue - OBufTail], OBufHead);
                    end;
                    // Reset the queue head and tail
                    OBufHead := 0;
                    OBufTail := 0;
                    OBufFull := False;
                finally
                    LeaveCriticalSection(OutputSection);
                end;
                // write the data that we found in tbe buffer & wait for I/O
                // completion.  Wait for all data in tempBuff to be written
                count := 0;
                while (count < numToWrite) do
                begin
{$IFDEF DebugThreads}
                    if (DLoggingOn) then
                        AddDispatchEntry(dtThread,
                                         dstThreadDataWritten,
                                         ComHandle,
                                         tempBuff,
                                         numToWrite - count);
{$ENDIF}
                    if (not WriteFile(ComHandle,
                                      tempBuff^[count],
                                      numToWrite - count,
                                      numWritten,
                                      ovl)) then
                        if (GetLastError = ERROR_IO_PENDING) then
                        begin
                            stat := WaitForOverlapped(ovl);
                            case stat of
                              // Flush request.  Set the general event & quit.
                              -(WAIT_OBJECT_0 + 1):
                              begin
                                SetEvent(GeneralEvent);
                                Result := 0;
                                Exit;
                              end;
                              // I/O error.  Propogate the error and quit.
                              // An error of ERROR_OPERATION_ABORTED is caused
                              // by flushing the com port so we just ignore it.
                              ecDeviceWrite:
                              begin
                                stat := GetLastError;
                                if (stat = ERROR_OPERATION_ABORTED) then
                                    Result := 0
                                else
                                begin
                                    LastWinError := stat;
                                    Result := ecDeviceWrite;
                                end;
                                Exit;
                              end;
                              // I/O complete. Increment count of bytes written & loop
                              else
                                Inc(count, stat);
                            end;
                        end else
                        begin
                            LastWinError := GetLastError;
                            Result := ecDeviceWrite;
                            Exit;
                        end
                    else
                        // Increment count of bytes written & loop
                        Inc(count, numWritten);
                end;
                // All data written, release the buffer
                FreeMem(tempBuff);
                tempBuff := nil;
                // No more data in buffer, if in RS485 mode wait for TE
                if Win32Platform <> VER_PLATFORM_WIN32_NT then
                    if RS485Mode then
                    begin
                        repeat
                        until (PortIn(BaseAddress+5) and $40) <> 0;
                        SetRTS(False);
                    end;
            end;
        end;
        Result := 0;
    finally
        if (Assigned(tempBuff)) then
            FreeMem(tempBuff);
    end;
end;
//  Wait for either the event signalling I/O completion of the OutputFlushEvent.
//  Returns the number of bytes written if I/O complete, -(WAIT_IBJECT_0 + 1) if
//  flush requested or ecDeviceWrite if error.
function  TWriteThread.WaitForOverlapped(ovl : POverlapped) : Integer;
var
    waitEvents      : array [0..1] of THandle;
    stat            : DWORD;
    bytesWritten    : Cardinal;
begin
    waitEvents[0] := ovl.hEvent;
    waitEvents[1] := OutFlushEvent;
    repeat
        stat := WaitForMultipleObjects(Length(waitEvents),
                                       @waitEvents[0],
                                       False,
                                       100);
    until ((stat <> WAIT_TIMEOUT) or Terminated or KillThreads);
    case stat of
      WAIT_OBJECT_0:
        if (GetOverlappedResult(ComHandle, ovl^, bytesWritten, True)) then
        begin
            Result := BytesWritten;
            ResetEvent(ovl.hEvent);
        end else
        begin
            TApdBaseDispatcher(H).LastWinError := GetLastError;
            Result := ecDeviceWrite;
        end;
      WAIT_OBJECT_0 + 1:
        Result := -(WAIT_OBJECT_0 + 1);
      else
      begin
        TApdBaseDispatcher(H).LastWinError := GetLastError;
        Result := ecDeviceWrite;
      end;
    end;
end;

//  TStatusThread methods.  This thread does nothing except wait for line and / or
//  modem events.  When an event occurs a status buffer is added to the queue
//  for processing by the dispatcher thread.
procedure TStatusThread.Execute;
var
    evt         : DWORD;
    stat        : Integer;
    wovl        : TOverlapped;
    sbfr        : TStatusBuffer;
    istat       : Integer;
begin
    ThreadStart(Self);
{$IFDEF DebugThreads}
    if (DLoggingOn) then
        AddDispatchEntry(dtThread, dstThreadStart, 4, nil, 0);
{$ENDIF}
    FillChar(wovl, SizeOf(wovl), 0);
    wovl.hEvent := CreateEvent(nil, True, False, nil);
    sbfr := nil;
    try
        // Set the mask used to signal WaitCommEvent which events to wait for.
        { Note, NuMega's BoundsChecker will flag a bogus error on the }
        { following statement because we use the undocumented ring_te flag }
        if Win32Platform = VER_PLATFORM_WIN32_NT then
          LastMask := DefEventMask and (not ev_RingTe)
        else
          LastMask := DefEventMask;
        SetCommMask(ComHandle, LastMask);

        ReturnValue := 0;
        while ((not Terminated) and (not KillThreads)) do
        begin
{$IFDEF DebugThreads}
            if (DLoggingOn) then
                AddDispatchEntry(dtThread, dstThreadSleep, 4, nil, 0);
{$ENDIF}
            stat := WaitSerialEvent(evt, @wovl);
            if (stat < 0) then
            begin
                istat := GetLastError;
{$IFDEF DebugSerialIO}
                MessageBox(0,
                           PChar(Format('ReadSerial failed! Error = %d.',
                                        [istat])),
                           '',
                           MB_OK or MB_APPLMODAL or MB_ICONEXCLAMATION);
{$ENDIF}
                // An invalid handle error means that someone else (probably
                // TAPI) has closed the port. So just quit without an error.
                if (istat <> ERROR_INVALID_HANDLE) then
                    ReturnValue := stat;
                KillThreads := True;
                Continue;
            end;
{$IFDEF DebugThreads}
            if (DLoggingOn) then
                AddDispatchEntry(dtThread, dstThreadWake, 4, nil, 0);
{$ENDIF}
            // Was it a data notification event?  If so, kick the read thread
            // in the butt.
            if ((evt and EV_RXCHAR) <> 0) then
                SerialEvent.SetEvent;
            // Was it a modem or line status change?  If so, queue
            // a status buffer to the dispatcher thread.
            if ((evt and (ModemEvent or LineEvent)) <> 0) then
            begin
                try
                    sbfr := TStatusBuffer.Create;
                except
                    sbfr := nil;
                    ReturnValue := ecNoMem;
                    KillThreads := True;
                end;
{$IFDEF DebugThreads}
                if (DLoggingOn) then
                    AddDispatchEntry(dtThread,
                                     dstThreadStatusQueued,
                                     ComHandle,
                                     @evt,
                                     SizeOf(evt));
{$ENDIF}
                sbfr.Status := evt;
                Queue.Push(sbfr);
                sbfr := nil;
            end;
        end;
    finally
        CloseHandle(wovl.hEvent);
        if (Assigned(sbfr)) then
            sbfr.Free;
{$IFDEF DebugThreads}
        if (DLoggingOn) then
            AddDispatchEntry(dtThread, dstThreadExit, 4, nil, 0);
{$ENDIF}
        ThreadGone(Self);
    end;
end;
//  Wait for an event on the serial port.  Returns 0 if OK, or a negative error
//  number otherwise.  It is OK to wait indefinitely for the overlapped I/O
//  to complete because we do a SetCommMask in StopDispatcher, which causes
//  WaitCommEvent to wake up.
function  TStatusThread.WaitSerialEvent(var EvtMask : DWORD;
                                        ovl : POverlapped) : Integer;
var
    bStat       : Boolean;
    istat       : Integer;
begin
    EvtMask := 0;
    bStat := WaitCommEvent(ComHandle, EvtMask, ovl);
    if (not bStat) then
    begin
        // If error is ERROR_INVALID_PARAMETER, assume it's our use of
        // ev_RingTe.  Clear the flag and try again.
        if ((GetLastError = ERROR_INVALID_PARAMETER) and
            ((LastMask and EV_RINGTE) <> 0)) then
        begin
            LastMask := LastMask and (not EV_RINGTE);
            SetCommMask(ComHandle, LastMask);
            bStat := WaitCommEvent(ComHandle, EvtMask, ovl);
        end;
    end;
    if (not bStat) then
    begin
        istat := GetLastError;
        if (istat = ERROR_IO_PENDING) then
            Result := WaitForOverlapped(ovl)
        else
        begin
            TApdBaseDispatcher(H).LastWinError := istat;
            Result := ecDeviceRead;
        end;
    end else
        Result := 0;
end;

constructor TApdTAPI32Dispatcher.Create(Owner : TObject; InCid : Integer);
begin
    CidEx := InCid;
    inherited Create(Owner);
end;

function TApdTAPI32Dispatcher.OpenCom(ComName: PChar; InQueue, OutQueue : Cardinal) : Integer;
begin
    if CidEx <> 0 then
        Result := CidEx
    else
    begin
        Result := ecCommNotOpen;
        SetLastError(-Result);
    end;
end;

end.
