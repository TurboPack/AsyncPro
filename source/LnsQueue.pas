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
 *  Stephen W. Boyd     - Created this module to provide input queueing for
 *                        serial port dispatcher.
 *                        August 2005
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)
{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit LnsQueue;

interface

uses Windows, SysUtils, SyncObjs, Classes, OoMisc;

const
    IO_BUFFER_SIZE  = 256;

type
  // An object to encapsulate an I/O buffer.  There a 3 kinds of buffer.  Data
  // buffers trace (logging) buffers and status buffers.
  TIOBuffer = class(TObject)
  protected
    FInUse      : Boolean;              // Set to true while processing events
                                        // and triggers for this buffer.
    FDataSize   : Integer;
  public
    property InUse : Boolean read FInUse write FInUse;
    property Size : Integer read FDataSize;
  end;

  TDataBuffer = class(TIOBuffer)
  private
    FData       : PAnsiChar;
    FDataUsed   : Integer;
    FDataRead   : Integer;
  public
    constructor Create(size : Integer);
    destructor Destroy; override;
    property Data : PAnsiChar read FData write FData;
    property BytesUsed : Integer read FDataUsed write FDataUsed;
    property BytesRead : Integer read FDataRead write FDataRead;
  end;

  TStatusBuffer = class(TIOBuffer)
  private
    FStatus     : DWORD;
  public
    property  Status : DWORD read FStatus write FStatus;
  end;

  TLogBuffer = class(TIOBuffer)
  private
    FType       : TDispatchType;
    FSubType    : TDispatchSubType;
    FTime       : DWord;
    FData       : Cardinal;
    FBuffer     : PAnsiChar;

    function  GetMoreData : Cardinal;
  public
    constructor Create(typ : TDispatchType;
                       styp : TDispatchSubType;
                       tim : DWORD;
                       data : Cardinal;
                       bfr : PAnsiChar;
                       bfrLen : Integer);
    destructor  Destroy; override;

    property drType : TDispatchType read FType;
    property drSubType : TDispatchSubType read FSubType;
    property drTime : DWORD read FTime;
    property drData : Cardinal read FData;
    property drMoreData : Cardinal read GetMoreData;
    property drBuffer : PAnsiChar read FBuffer;
  end;
  // A queue to hold serial port I/O buffers for delivery to / from the
  // dispatcher thread.  Also used to queue items to the dispatcher log.
  TIOQueue = class(TList)
  private
    FLock       : TCriticalSection;
    FEvent      : TEvent;
    FBytesQueued: Integer;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure Clear; override;
    function  Peek : TIOBuffer;
    function  Pop : TIOBuffer;
    procedure Push(item : TIOBuffer);
    function  WaitForBuffer(tmo : Integer) : TWaitResult;

    property BytesQueued : Integer read FBytesQueued;
  end;

implementation

{ TDataBuffer methods }
constructor TDataBuffer.Create(size : Integer);
begin
    inherited Create;
    FData := AllocMem(size);
    if (not Assigned(FData)) then
        raise Exception.Create('Insufficient memory to allocate I/O buffer.');
    FDataSize := size;
    FDataUsed := 0;
    FDataRead := 0;
end;

destructor TDataBuffer.Destroy;
begin
    if (Assigned(FData)) then
        FreeMem(FData);
    inherited Destroy;
end;
{ TLogBuffer methods }
constructor TLogBuffer.Create(typ : TDispatchType;
                              styp : TDispatchSubType;
                              tim : DWORD;
                              data : Cardinal;
                              bfr : PAnsiChar;
                              bfrLen : Integer);
begin
    inherited Create;
    FType := typ;
    FSubType := styp;
    FTime := tim;
    FData := data;
    FDataSize := bfrLen;
    if (FDataSize > 0) then
    begin
        GetMem(FBuffer, FDataSize);
        Move(bfr^, FBuffer^, FDataSize);
    end;
end;

destructor  TLogBuffer.Destroy;
begin
    if (Assigned(FBuffer)) then
        FreeMem(FBuffer);
    inherited Destroy;
end;

function  TLogBuffer.GetMoreData : Cardinal;
begin
    Result := Cardinal(FDataSize);
end;
{ TIOQueue methods }
constructor TIOQueue.Create;
begin
    inherited Create;
    FLock := TCriticalSection.Create;
    FEvent := TEvent.Create(nil, False, False, '');
end;

destructor  TIOQueue.Destroy;
begin
    Clear;
    if (Assigned(FLock)) then
    begin
        FLock.Free;
        // We must clear this pointer here so that Clear, which gets called
        // by the inherited Destroy method, knows that the lock is no longer
        // valid and won't try to acquire it.
        FLock := nil;
    end;
    if (Assigned(FEvent)) then
        FEvent.Free;
    inherited Destroy;
end;
// Remove all non-InUse buffers from the queue.  This used to purge the queue
// when the dispatcher is requested to flush the buffers.
procedure TIOQueue.Clear;
var
    i: Integer;
begin
    if (Assigned(FLock)) then
        FLock.Acquire;
    try
        i := 0;
        while (i < Count) do
            with TIOBuffer(Items[i]) do
            begin
                if (InUse) then
                    Inc(i)
                else
                begin
                    Free;
                    Delete(i);
                end;
            end;
    finally
        if (Assigned(FLock)) then
            FLock.Release
        else
            // If FLock is nil then we are Destroying so we should call the
            // inherited clear method to make sure that all memory allocated
            // by TList gets released.
            inherited Clear;
    end;
end;
// Return a pointer to the first buffer without removing it from the queue.
// Sets the FInUse flag to prevent the I/O threads from appending to the
// buffer while the dispatcher thread is reading it. Do not return a buffer
// pointer if the first buffer is being written to by the I/O thread.
function  TIOQueue.Peek : TIOBuffer;
begin
    FLock.Acquire;
    try
        if (Count > 0) then
        begin
            Result := TIOBuffer(Items[0]);
            if (Result.InUse) then
                Result := nil
            else
                Result.InUse := True;
        end else
            Result := nil;
    finally
        FLock.Release;
    end;
end;
// Remove the first buffer from the queue and return a pointer to it.
function  TIOQueue.Pop : TIOBuffer;
begin
    FLock.Acquire;
    try
        if (Count > 0) then
        begin
            Result := TIOBuffer(Items[0]);
            Dec(FBytesQueued, Result.Size);
            Delete(0);
        end else
            Result := nil;
    finally
        FLock.Release;
    end;
end;
// Add a new buffer to the end of the queue
procedure TIOQueue.Push(item : TIOBuffer);
begin
    FLock.Acquire;
    try
        Add(item);
        Inc(FBytesQueued, item.Size);
        FEvent.SetEvent;
    finally
        FLock.Release;
    end;
end;
//  Wait for a buffer to appear on the queue.  If there is a buffer available,
//  we return immediately, otherwise we wait for FEvent to be set.
function  TIOQueue.WaitForBuffer(tmo : Integer) : TWaitResult;
begin
    if (Count > 0) then
        Result := wrSignaled
    else
        Result := FEvent.WaitFor(tmo);
end;

end.
