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
 *  Sulaiman Mah
 *  Sean B. Durkin
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   AWWIN32.PAS 5.00                    *}
{*********************************************************}
{* Win32 serial device layer and dispatcher              *}
{*********************************************************}

{
  Along with AwUser.pas, this unit defines/implements the dreaded Windows
  serial port dispatcher. This unit provides the interface to the Win32
  serial port drivers, the threading code is in AwUser.pas.
  Be extrememly cautious when making changes here or in AwUser. The multi-
  threaded nature, and very strict timing requirements, can lead to very
  unpredictable results. Things as simple as adding doing a writeln to a
  console window can dramatically change the results.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$X+,F+,K+,B-}

unit AwWin32;
  {-Device layer for standard Win32 communications API}

interface

uses
  Windows,
  Classes,
  SysUtils,
  AdWUtil,
  AdSocket,
  OoMisc,
  awUser;

type

  TApdWin32Dispatcher = class(TApdBaseDispatcher)
  protected
    ReadOL    : TOverLapped;
    WriteOL   : TOverLapped;
    function EscapeComFunction(Func : Integer) : LongInt; override;
    function FlushCom(Queue : Integer) : Integer; override;
    function GetComError(var Stat : TComStat) : Integer; override;
    function GetComEventMask(EvtMask : Integer) : Cardinal; override;
    function GetComState(var DCB: TDCB): Integer; override;
    function SetComState(var DCB : TDCB) : Integer; override;
    function ReadCom(Buf : PAnsiChar; Size: Integer) : Integer; override;
    function WriteCom(Buf : PAnsiChar; Size: Integer) : Integer; override;
    function SetupCom(InSize, OutSize : Integer) : Boolean; override;
    procedure StartDispatcher; override;
    procedure StopDispatcher; override;
    function WaitComEvent(var EvtMask : DWORD;
      lpOverlapped : POverlapped) : Boolean; override;
    function OutBufUsed: Cardinal; override;                                // SWB
  public
    function CloseCom : Integer; override;
    function OpenCom(ComName: PChar; InQueue,
      OutQueue : Cardinal) : Integer; override;
    function ProcessCommunications : Integer; override;
    function CheckPort(ComName: PChar): Boolean; override;
  end;

  TApdTAPI32Dispatcher = class(TApdWin32Dispatcher)
  public
    constructor Create(Owner : TObject; InCid : Integer);
    function OpenCom(ComName: PChar; InQueue,
      OutQueue : Cardinal) : Integer; override;
  end;

implementation

uses
  StrUtils;

function TApdWin32Dispatcher.CheckPort(ComName: PChar): Boolean; //SZ
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

  function TApdWin32Dispatcher.CloseCom : Integer;
    {-Close the comport and cleanup}
  begin
    // Under certain circumstances, it is possible that CloseCom can be called
    // recursively.  In that event, we don't want to be re-executing this code.
    // So, set a flag to show that we are inside this method and check it
    // every time we enter.  If it is already set, just exit and do nothing.
    // This used to be accomplished by acquiring the DataSection critical section
    // but this lead to occasional deadlocks.
    EnterCriticalSection(DataSection);                                      // SWB
    if (CloseComActive) then                                                // SWB
    begin                                                                   // SWB
        LeaveCriticalSection(DataSection);                                  // SWB
        Result := 0;                                                        // SWB
        Exit;                                                               // SWB
    end;                                                                    // SWB
    CloseComActive := True;                                                 // SWB
    LeaveCriticalSection(DataSection);                                      // SWB
    try                                                                     // SWB
        {Release the events}
        if ReadOL.hEvent <> 0 then begin
          CloseHandle(ReadOL.hEvent);
          ReadOL.hEvent := 0;
        end;
        if WriteOL.hEvent <> 0 then begin
          CloseHandle(WriteOL.hEvent);
          WriteOL.hEvent := 0;
        end;

        if DispActive then begin
          KillThreads := True;

          {Force the comm thread to wake...}
          SetCommMask(CidEx, 0);
          SetEvent(ReadyEvent);
          ResetEvent(GeneralEvent);

          {$IFDEF DebugThreadConsole}
          Writeln(ThreadStatus(ComKill));
          {$ENDIF}
        end;

        {Close the comport}
        if CloseHandle(CidEx) then begin
          Result := 0;
          CidEx := -1;
        end else
          Result := -1;
    finally                                                                 // SWB
        CloseComActive := False;                                            // SWB
    end;                                                                    // SWB
  end;

  function TApdWin32Dispatcher.EscapeComFunction(Func: Integer): LongInt;
    {-Perform the extended comm function Func}
  begin
    EscapeCommFunction(CidEx, Func);
    Result := 0;
  end;

  function TApdWin32Dispatcher.FlushCom(Queue: Integer): Integer;
    {-Flush the input or output buffer}
  begin
    if (Queue = 0) and (OutThread <> nil) then begin
      {Flush our own output buffer...}
      SetEvent(OutFlushEvent);
      { this can cause a hang when using an IR port that does not have a }
      { connection (the IR receiver is not in range), the port drivers   }
      { will not flush the buffers, so we'd wait forever                 }
      WaitForSingleObject(GeneralEvent, 5000);{INFINITE);}               {!!.02}
      {...XMit thread has acknowledged our request, so flush it}
      EnterCriticalSection(OutputSection);
      try
        OBufFull := False;
        OBufHead := 0;
        OBufTail := 0;
        Result := Integer(PurgeComm(CidEx,
          PURGE_TXABORT or PURGE_TXCLEAR));
      finally
        LeaveCriticalSection(OutputSection);
      end;
    end else
      Result := Integer(PurgeComm(CidEx, PURGE_RXABORT or PURGE_RXCLEAR));

    if Result = 1 then
      Result := 0
    else
      Result := -Integer(GetLastError);
  end;

  function TApdWin32Dispatcher.GetComError(var Stat: TComStat): Integer;
    {-Get the current error and update Stat}
  var
    Errors : DWORD;
  begin
    if ClearCommError(CidEx, Errors, @Stat) then
      Result := Errors
    else
      Result := 0;

    {Replace information about Windows output buffer with our own}
    Stat.cbOutQue := OutBufUsed;                                            // SWB
  end;

  function TApdWin32Dispatcher.GetComEventMask(EvtMask: Integer): Cardinal;
    {-Set the communications event mask}
  begin
    Result := 0;
  end;

  function TApdWin32Dispatcher.GetComState(var DCB: TDCB): Integer;
    {-Fill in DCB with the current communications state}
  begin
    if Integer(GetCommState(CidEx, DCB)) = 1 then
      Result := 0
    else
      Result := -1;
  end;

  function TApdWin32Dispatcher.OpenCom(ComName: PChar; InQueue, OutQueue: Cardinal): Integer;
    {-Open the comport specified by ComName}
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

    if Result <> Integer(INVALID_HANDLE_VALUE) then begin
      CidEx := Result;
      {Create port data structure}
      ReadOL.hEvent := CreateEvent(nil, True, False, nil);
      WriteOL.hEvent := CreateEvent(nil, True, False, nil);
      if (ReadOL.hEvent = 0) or (WriteOL.hEvent = 0) then begin
        {Failed to create events, get rid of everything}
        CloseHandle(ReadOL.hEvent);
        CloseHandle(WriteOL.hEvent);
        CloseHandle(Result);
        Result := ecOutOfMemory;
        Exit;
      end;
    end else
      {Failed to open port, just return error signal, caller will
       call GetLastError to get actual error code}
      Result := -1;
  end;

  function TApdWin32Dispatcher.ReadCom(Buf: PAnsiChar; Size: Integer): Integer;
    {-Read Size bytes from the comport specified by Cid}
  var
    OK  : Bool;
    Temp : DWORD;
  begin
    {Post a read request...}
    OK := ReadFile(CidEx,                       {handle}
                   Buf^,                        {buffer}
                   Size,                        {bytes to read}
                   Temp,                        {bytes read}
                   @ReadOL);                    {overlap record}

    {...and see what happened}
    if not OK then begin
      if GetLastError = ERROR_IO_PENDING then begin
        {Waiting for data}
        if GetOverLappedResult(CidEx,           {handle}
                               ReadOL,          {overlapped structure}
                               Temp,            {bytes written}
                               True) then begin {wait for completion}
          {Read complete, reset event}
          ResetEvent(ReadOL.hEvent);
        end;
      end;
    end;
    Result := Integer(Temp);
  end;

  function TApdWin32Dispatcher.SetComState(var DCB: TDCB): Integer;
    {-Set the a new communications device state from DCB}
  begin
    if SetCommState(CidEx, DCB) then
      Result := 0
    else
      Result := -Integer(GetLastError);
  end;

  function TApdWin32Dispatcher.WriteCom(Buf: PAnsiChar; Size: Integer): Integer;
    {-Write data to the comport}
  type
    PBArray = ^TBArray;
    TBArray = array[0..pred(High(Integer))] of Byte;
  var
    SizeAtEnd : Integer;
    LeftOver  : Integer;
  begin
    {Add the data to the output queue}
    EnterCriticalSection(OutputSection);
    try
      {we already know at this point that there is enough room for the block}
      SizeAtEnd := OutQue - OBufHead;
      if SizeAtEnd >= Size then begin
        {can move data to output queue in one block}
        Move(Buf^, OBuffer^[OBufHead], Size);
        if SizeAtEnd = Size then
          OBufHead := 0
        else
          Inc(OBufHead, Size);
      end else begin
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

  function TApdWin32Dispatcher.SetupCom(InSize, OutSize : Integer) : Boolean;
    {-Set new in/out buffer sizes}
  begin
    Result := SetupComm(CidEx, InSize, OutSize);
  end;

  function TApdWin32Dispatcher.WaitComEvent(var EvtMask : DWORD;
                              lpOverlapped : POverlapped) : Boolean;
  begin
    Result := WaitCommEvent(CidEx, EvtMask, lpOverlapped);
  end;

  procedure TApdWin32Dispatcher.StartDispatcher;
  begin
    EnterCriticalSection(DataSection);
    try
      {See if we're already active}
      if DispActive then
        raise Exception.Create('Dispatcher already started');

      DispActive := True;

      {Create the com events thread}
      KillThreads := False;

      ComThread := TComThread.Create(Self);
      {Wait for it to start...}
      WaitForSingleObject(GeneralEvent, ThreadStartWait);
      {$IFDEF DebugThreadConsole}
      Writeln(ThreadStatus(ComStart));
      {$ENDIF}

      {Create the dispatcher thread}
      fDispThread := TDispThread.Create(Self);
      {Wait for it to start...}
      WaitForSingleObject(GeneralEvent, ThreadStartWait);
      {$IFDEF DebugThreadConsole}
      Writeln(ThreadStatus(DispStart));
      {$ENDIF}

      {Create the output thread}
      OutThread := TOutThread.Create(Self);
      {Wait for it to start...}
      WaitForSingleObject(GeneralEvent, ThreadStartWait);
      {$IFDEF DebugThreadConsole}
      Writeln(ThreadStatus(OutStart));
      {$ENDIF}
    finally
      LeaveCriticalSection(DataSection);
    end;
  end;

  procedure TApdWin32Dispatcher.StopDispatcher;
   var
    ET : EventTimer;
  begin
      if not DispActive then
        Exit;

      { Set the flag to kill the threads next time they wake, or after }
      { their current processing }
      KillThreads := True;

      if Assigned(OutThread) then begin
        {Force the output thread to wake...}
        SetEvent(OutFlushEvent);

        {...and wait for it to die}
        while (OutThread <> nil) do
          SafeYield;

        {$IFDEF DebugThreadConsole}
        Writeln(ThreadStatus(OutKill));
        {$ENDIF}
      end;

      if Assigned(ComThread) then begin
        {Force the comm thread to wake...}
        SetCommMask(CidEx, 0);
        SetEvent(ReadyEvent);

        {... and wait for it to die}
        ResetEvent(GeneralEvent);
        while (ComThread <> nil) do
          SafeYield;

        {$IFDEF DebugThreadConsole}
        Writeln(ThreadStatus(ComKill));
        {$ENDIF}
      end;

      {Now kill the timer}
      KillTimer(0, TimerID);

      if Assigned(DispThread) then begin
        KillThreads := True;
        {Wait for it to die}
        NewTimer(ET, 36);  { start a 2-second timer to prevent blocks }
        while (DispThread <> nil) and not(TimerExpired(ET)) do
          SafeYield;
        if DispThread <> nil then begin
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

      if ComEvent <> INVALID_HANDLE_VALUE then begin
        if CloseHandle(ComEvent) then
          ComEvent := INVALID_HANDLE_VALUE;
      end;

      if ReadyEvent <> INVALID_HANDLE_VALUE then begin
        if CloseHandle(ReadyEvent) then
          ReadyEvent := INVALID_HANDLE_VALUE;
      end;

      if GeneralEvent <> INVALID_HANDLE_VALUE then begin
        if CloseHandle(GeneralEvent) then
          GeneralEvent := INVALID_HANDLE_VALUE;
      end;

      if OutputEvent <> INVALID_HANDLE_VALUE then begin
        if CloseHandle(OutputEvent) then
          OutputEvent := INVALID_HANDLE_VALUE;
      end;

      if SentEvent <> INVALID_HANDLE_VALUE then begin
        if CloseHandle(SentEvent) then
          SentEvent := INVALID_HANDLE_VALUE;
      end;

      if OutFlushEvent <> INVALID_HANDLE_VALUE then begin
        if CloseHandle(OutFlushEvent) then
          OutFlushEvent := INVALID_HANDLE_VALUE;
      end;
  end;

  function TApdWin32Dispatcher.ProcessCommunications : Integer;
    {-Communications are running in separate threads -- give them a chance}
  begin
    Sleep(0);
    Result := 0;
  end;

  constructor TApdTAPI32Dispatcher.Create(Owner : TObject; InCid : Integer);
  begin
    CidEx := InCid;
    inherited Create(Owner);
  end;

  function TApdTAPI32Dispatcher.OpenCom(ComName: PChar; InQueue, OutQueue : Cardinal) : Integer;
  begin
    ReadOL.hEvent := CreateEvent(nil, True, False, nil);
    WriteOL.hEvent := CreateEvent(nil, True, False, nil);
    if (ReadOL.hEvent = 0) or (WriteOL.hEvent = 0) then begin
      CloseCom;
      Result := -1;
      Exit;
    end;
    if CidEx <> 0 then
      Result := CidEx
    else begin
      Result := ecCommNotOpen;
      SetLastError(-Result);
    end;
  end;
// Added by SWB
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

end.
