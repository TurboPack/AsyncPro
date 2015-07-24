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
{*                   AWWNSOCK.PAS 4.06                   *}
{*********************************************************}
{* Winsock device layer and dispatcher                   *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$X+,F+,K+,B-,T-}
 {$J+}

unit AwWnsock;
  { -Device layer for Winsock API }

interface

uses
  Windows,
  Classes,
  SysUtils,
  AdWUtil,
  AdSocket,
  OoMisc,
  awUser;

const
  DefAsyncStyles = FD_READ or FD_WRITE or FD_ACCEPT or FD_CONNECT or FD_CLOSE;
  DefWsTerminal = 'vt100';
  DefOptSupga  = True;
  DefOptEcho   = True;

  { Telnet Commands }
  TELNET_IAC   = #255;  { Interpret as Command }
  TELNET_DONT  = #254;  { Stop performing, or not expecting him to perform }
  TELNET_DO    = #253;  { Perform, or expect him to perform }
  TELNET_WONT  = #252;  { Refusal to perform }
  TELNET_WILL  = #251;  { Desire to perform }
  TELNET_SB    = #250;  { What follow is sub-negotiation of indicated option }
  TELNET_GA    = #249;  { Go ahead signal }
  TELNET_EL    = #248;  { Erase Line function }
  TELNET_EC    = #247;  { Erase Character function }
  TELNET_AYT   = #246;  { Are You There function }
  TELNET_AO    = #245;  { Abort Output function }
  TELNET_IP    = #244;  { Interrupt Process function }
  TELNET_BRK   = #243;  { NVT break character }
  TELNET_DM    = #242;  { Data stream portion of a Synch (DATAMARK) }
  TELNET_NOP   = #241;  { No operation }
  TELNET_SE    = #240;  { End of sub-negotiation parameters }
  TELNET_EOR   = #239;  { End of record }
  TELNET_ABORT = #238;  { Abort process }
  TELNET_SUSP  = #237;  { Suspend current process }
  TELNET_EOF   = #236;  { End of file }

  TELNET_NULL  = #0;
  TELNET_LF    = #10;
  TELNET_CR    = #13;                                               

  { Telnet Options }
  TELNETOPT_BINARY = #0;     { Transmit binary }
  TELNETOPT_ECHO   = #1;     { Echo mode }
  TELNETOPT_SUPGA  = #3;     { Suppress Go-Ahead }
  TELNETOPT_TERM   = #24;    { Terminal Type }
  TELNETOPT_SPEED  = #32;    { Terminal Speed }

type
  PServerClientRec = ^TServerClientRec;
  TServerClientRec = record
    ServerSocket : TSocket;
    ClientSocket : TSocket;
  end;

  TWsConnectionState = (wcsInit, wcsConnected);

  TTelnetOpt = (tnoFalse, tnoNegotiating, tnoTrue);                

  TApdWinsockDispatcher = class;

  TWsConnection = class(TComponent)
  private
    FSimBuf : Cardinal;                                               
    FCommSocket : TSocket;        { Socket which the IO goes through }
    FDispatcher : TApdWinsockDispatcher; { Pointer to the associated ComRec }
    FConnectionState : TWsConnectionState;
    FInBuf : PAnsiChar;               { Pointer to input buffer }
    FInBufEnd : PANsiChar;            { Sentinel at end of input buffer }
    FInBufFull : Boolean;         { Flag set when buffer is full }
    FInSize : Cardinal;           { Size of input buffer }
    FInStart : PAnsiChar;             { Pointer to first character of data }
    FInCursor : PAnsiChar;            { Pointer to first char to be telnet checked }
    FInEnd : PAnsiChar;               { Pointer to first free character in buffer }
    FIsClient : Boolean;          { True if socket is a client -- false if server }
    FIsTelnet : Boolean;          { True if telnet parsing should be done }
    FOutBuf : PANsiChar;              { Pointer to output buffer }
    FOutBufEnd : PANsiChar;           { Sentinel at end of output buffer }
    FOutBufFull : Boolean;        { Flag set when buffer is full }
    FOutSize : Cardinal;          { Size of output buffer }
    FOutStart : PAnsiChar;            { Pointer to first character of data }
    FOutEnd : PAnsiChar;              { Pointer to first free character in buffer }
    FSocketHandle : TSocket;      { Socket that is associated with the comport }
    FOptBinary : TTelnetOpt;
    FOptSupga  : TTelnetOpt;
    FOptEcho   : TTelnetOpt;
  protected
    function GetConnected : Boolean;
    function GetInChars : Cardinal;
    function GetOutChars : Cardinal;
    procedure SetConnectionState(Value : TWsConnectionState);
  public
    constructor CreateInit(AOwner: TComponent; InSize, OutSize : Cardinal); virtual;
    destructor Destroy; override;
    function FindIAC(Start : PAnsiChar; Size : Cardinal) : PANsiChar;
    procedure FlushInBuffer;
    procedure FlushOutBuffer;
    function HandleCommand(Command, Option : AnsiChar) : Boolean;
    function ProcessCommands(Dest : PAnsiChar; Size : Cardinal) : Integer;
    function ReadBuf(var Buf; Size : Integer) : Integer;
    procedure SendDo(Option: AnsiChar);
    procedure SendDont(Option: AnsiChar);
    procedure SendWill(Option: AnsiChar);
    procedure SendWont(Option: AnsiChar);
    procedure SendTerminal;
    function Shutdown : Integer;
    function WriteBuf(var Buf; Size : Integer) : Integer;
    property CommSocket : TSocket read FCommSocket;
    property Connected : Boolean read GetConnected;
    property ConnectionState : TWsConnectionState
      read FConnectionState write SetConnectionState;
    property InChars : Cardinal read GetInChars;
    property InSize : Cardinal read FInSize;
    property IsClient : Boolean read FIsClient write FIsClient;
    property IsTelnet : Boolean read FIsTelnet write FIsTelnet;
    property OutChars : Cardinal read GetOutChars;
    property OutSize : Cardinal read FOutSize;
    property SocketHandle : TSocket read FSocketHandle;
  end;


  TApdDeviceSocket = class(TApdSocket)
  private
    FWsTerminal : ansistring;
    SockSection : TRTLCriticalSection;
  protected
    function DoDispMessage(Socket : TSocket; Event : Cardinal; LP : Integer) : Integer;
    function DoWsMessage(Socket : TSocket; Event : Cardinal; LP : Integer) : Integer;
    procedure DoAccept(Socket : TSocket); override;
    procedure DoConnect(Socket : TSocket); override;
    procedure DoDisconnect(Socket : TSocket); override;
    procedure DoError(Socket : TSocket; ErrCode : Integer); override;
    procedure DoRead(Socket : TSocket); override;
    procedure DoWrite(Socket : TSocket); override;
    function TweakSocket(Socket : TSocket) : TSocket;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LockList;
    procedure UnLockList;
    function FindConnection(Socket : TSocket) : TWsConnection;
    property WsTerminal : Ansistring read FWsTerminal write FWsTerminal;
  end;

  TApdWinsockDispatcher = class(TApdBaseDispatcher)
  private
    InDispatcher : Boolean;
    WsSockAddr : TSockAddrIn;
    WsHostAddr : TSockAddrIn;
    WsIsClient : Boolean;
    WsIsTelnet : Boolean;
  protected
    function EscapeComFunction(Func : Integer) : Integer; override;
    function FlushCom(Queue : Integer) : Integer; override;
    function GetComError(var Stat : TComStat) : Integer; override;
    function GetComEventMask(EvtMask : Integer) : Cardinal; override;
    function GetComState(var DCB: TDCB): Integer; override;
    function SetComState(var DCB : TDCB) : Integer; override;
    procedure StartDispatcher; override;
    procedure StopDispatcher; override;
    function ReadCom(Buf : PAnsiChar; Size: Integer) : Integer; override;
    function WriteCom(Buf : PAnsiChar; Size: Integer) : Integer; override;
    function SetupCom(InSize, OutSize : Integer) : Boolean; override;
    function WaitComEvent(var EvtMask : DWORD;
      lpOverlapped : POverlapped) : Boolean; override;
    function Dispatcher(Msg : Cardinal;
                         wParam : Cardinal; lParam : Integer) : Cardinal;
    function OutBufUsed: Cardinal; override;                                // SWB
    function InQueueUsed : Cardinal; override;                              // SWB
  public
    function CloseCom : Integer; override;
    procedure InitSocketData(LocalAddress, Address : Integer; Port : Cardinal;
      IsClient, IsTelnet : Boolean);
    function OpenCom(ComName: PChar; InQueue,
      OutQueue : Cardinal) : Integer; override;
    function ProcessCommunications : Integer; override;
    function CheckPort(ComName: PChar): Boolean; override;
  end;

var
  ApdSocket : TApdDeviceSocket;

procedure DeactivateAwWnSock; //SZ - made public

implementation
uses
  AdPort;

{ TWsConnection methods }

{ Create and initialize connection -- owner is assumed to be a TApdDeviceSocket }
constructor TWsConnection.CreateInit(AOwner: TComponent; InSize, OutSize : Cardinal);
begin
  inherited Create(AOwner);
  FSocketHandle := TApdDeviceSocket(Owner).CreateSocket;
  { Create input buffer, and initialize -- full flag is already False }
  GetMem(FInBuf, InSize);
  FInSize := InSize;
  FInBufEnd := FInBuf + FInSize;
  FInStart := FInBuf;
  FInEnd := FInBuf;
  FInCursor := FInBuf;
  { Create output buffer, and initialize -- full flag is already False }
  { Extra space for telnet escaping }
  GetMem(FOutBuf, OutSize + 4096);
  FOutSize := OutSize + 4096;
  FOutBufEnd := FOutBuf + FOutSize;
  FOutStart := FOutBuf;
  FOutEnd := FOutBuf;
  { Other inits }
  FCommSocket := SOCKET_ERROR;
  ConnectionState := wcsInit;
end;

function TWsConnection.FindIAC(Start : PAnsiChar; Size : Cardinal) : PAnsiChar;
var
  I : Cardinal;
begin
  if FIsTelnet then begin
    Result := Start;
  end else begin
    Result := Start + Size;
    Exit;
  end;
  for I := 0 to Size do begin
    if (Result^ = TELNET_IAC) then Exit;
    if (FOptBinary = tnoFalse) and (Result^ = TELNET_CR) then Exit;
    Result := (Start + I);
  end;
end;

{ Flush local input buffer }
procedure TWsConnection.FlushInBuffer;
begin
  FInStart := FInBuf;
  FInCursor := FInBuf;
  FInEnd := FInBuf;
  FInBufFull := False;
end;

{ Flush local output buffer }
procedure TWsConnection.FlushOutBuffer;
begin
  FOutStart := FOutBuf;
  FOutEnd := FOutBuf;
  FOutBufFull := False;
end;

{ Handle a telnet command - result is True if negotation command }
function TWsConnection.HandleCommand(Command, Option : AnsiChar) : Boolean;
begin
  Result := True;
  case Command of
    TELNET_DONT :
    begin
      if FDispatcher.DLoggingOn then
        FDispatcher.AddDispatchEntry(dtTelnet, dstRDont, Ord(Option), nil, 0);
      case Option of
        TELNETOPT_BINARY :
        begin
          if FOptBinary <> tnoNegotiating then
            SendWont(Option);
          FOptBinary := tnoFalse;
        end;
        TELNETOPT_SUPGA  :
        begin
          if FOptSupga <> tnoNegotiating then
            SendWont(Option);
          FOptSupga := tnoFalse;
        end else begin
          SendWont(Option);
        end;
      end;
    end;
    TELNET_DO :
    begin
      if FDispatcher.DLoggingOn then
        FDispatcher.AddDispatchEntry(dtTelnet, dstRDo, Ord(Option), nil, 0);
      case Option of
        TELNETOPT_BINARY :
        begin
          if FOptBinary <> tnoNegotiating then
            SendWill(Option);
          FOptBinary := tnoTrue;
        end;
        TELNETOPT_SUPGA  :
        begin
          if FOptSupga <> tnoNegotiating then begin
            if FOptSupga = tnoTrue then begin
              SendWill(Option);
            end else begin
              SendWont(Option);
            end;
          end else begin
            FOptSupga := tnoTrue;
          end;
        end;
        TELNETOPT_TERM   :
        begin
          SendWill(Option);
        end;
        TELNETOPT_SPEED  :
        begin
          SendWont(Option);
        end;
        TELNETOPT_ECHO   :
        begin
          SendWont(Option);
        end else begin
          SendWont(Option);
        end;
      end;
    end;
    TELNET_WONT :
    begin
      if FDispatcher.DLoggingOn then
        FDispatcher.AddDispatchEntry(dtTelnet, dstRWont, Ord(Option), nil, 0);
      case Option of
        TELNETOPT_BINARY :
        begin
          if FOptBinary <> tnoNegotiating then
            SendDont(Option);
          FOptBinary := tnoFalse;
        end;
        TELNETOPT_SUPGA  :
        begin
          if FOptSupga <> tnoNegotiating then
            SendDont(Option);
          FOptSupga := tnoFalse;
        end;
        TELNETOPT_ECHO   :
        begin
          if FOptEcho <> tnoNegotiating then
            SendDont(Option);
          FOptEcho := tnoFalse;
        end else begin
          SendDont(Option);
        end;
      end;
    end;
    TELNET_WILL :
    begin
      if FDispatcher.DLoggingOn then
        FDispatcher.AddDispatchEntry(dtTelnet, dstRWill, Ord(Option), nil, 0);
      case Option of
        TELNETOPT_BINARY :
        begin
          if FOptBinary <> tnoNegotiating then
            SendDo(Option);
          FOptBinary := tnoTrue;
        end;
        TELNETOPT_SUPGA  :
        begin
          if FOptSupga <> tnoNegotiating then begin
            if DefOptSupga then begin
              SendDo(Option);
            end else begin
              SendDont(Option);
            end;
          end else begin
            FOptSupga := tnoTrue;
          end;
        end;
        TELNETOPT_ECHO   :
        begin
          if FOptEcho <> tnoNegotiating then begin
            if DefOptEcho then begin
              SendDo(Option);
            end else begin
              SendDont(Option);
            end;
          end else begin
            FOptEcho := tnoTrue;
          end;
        end else begin
          SendDont(Option);
        end;
      end;
    end else begin
      Result := False;
      if FDispatcher.DLoggingOn then
        FDispatcher.AddDispatchEntry(dtTelnet, dstCommand, Ord(Command), nil, 0);
    end;
  end;
end;

{ Process & strip telnet commands -- calling method is responsible for }
{ ensuring there is at least Size bytes left in the Dest buffer }
function TWsConnection.ProcessCommands(Dest : PAnsiChar; Size : Cardinal) : Integer;
var
  StartDest, EndBuf, Temp : PAnsiChar;

  function NextChar : AnsiChar;
  begin
    if (FInCursor + 1) = FInBufEnd then
      Result := FInBuf^
    else
      Result := (FInCursor + 1)^;
  end;

begin
  StartDest := Dest;
  EndBuf := FInCursor + Size;
  while FInCursor < EndBuf do begin
    if FInCursor^ <> TELNET_IAC then begin
      { ASCII mode, and CR/NULL received -- strip the null }
      if (FOptBinary = tnoFalse) and (FInCursor^ = TELNET_CR) and
         (NextChar = TELNET_NULL) then begin
        Dest^ := FInCursor^;
        Dest := Dest + 1;
        FInCursor := FInCursor + 2;
        if FInCursor > FinBufEnd then begin
          FInCursor := FInBuf + 1;
          Break;
        end;
      end else begin
        { Copy over verbatim }
        Dest^ := FInCursor^;
        FInCursor := FInCursor + 1;
        Dest := Dest + 1;
      end;
    end else begin
      if ((FInCursor + 1) = FInBufEnd) and (FInEnd = FInBuf) then
        break;
      if NextChar = TELNET_IAC then begin
        { It's an escaped IAC -- copy a single over }
        Dest^ := FInCursor^;
        Dest := Dest + 1;
        FInCursor := FInCursor + 2;
        if FInCursor > FinBufEnd then begin
          FInCursor := FInBuf + 1;
          break;
        end;
      end else begin
        { If at the end of the buffer, and made it this far, exit loop }
        if (FInCursor + 1) = FInBufEnd then begin
          FInCursor := FInCursor + 1;
          Break;
        end;
        if NextChar <> TELNET_SB then begin
          { It's an actual command -- strip it and act on it }
          if HandleCommand((FInCursor + 1)^, (FInCursor + 2)^) then
            FInCursor := FInCursor + 3
          else
            FInCursor := FInCursor + 2;
        end else begin
          { It's a subnegotation situation -- look for the end }
          if (FInCursor + 2)^ = TELNETOPT_TERM then
            SendTerminal;
          Temp := FindIAC((FInCursor + 1), EndBuf - (FInCursor + 1));
          if (Temp + 1)^ = TELNET_SE then
            FInCursor := Temp + 2;
        end;
      end;
    end;
  end;
  Result := (Dest - StartDest);
end;

{ Read from Winsock and process telnet commands if applicable }
function TWsConnection.ReadBuf(var Buf; Size : Integer) : Integer;
var
  NumRead,
  NumRead2 : Integer;
  CanRead,
  CanRead2 : Cardinal;

  function MinCard(C1, C2 : Cardinal) : Cardinal; assembler;
  {$ifndef CPUX64}
  asm
    cmp   eax,edx
    jbe   @1
    mov   eax,edx
  @1:
  end;
  {$else}
  asm
    sub   ecx,ecx
    sbb   eax,eax
    and   eax,ecx
    add   eax,edx
  end;
  {$endif}

  procedure UpDatePtr(var SPtr : PAnsiChar; Delta : Integer);
  begin
    SPtr := SPtr + Delta;
    if SPtr >= FInBufEnd then
      SPtr := FInBuf + (SPtr - FInBufEnd);
  end;

  procedure MoveChunk(BeginPt, EndPt : PAnsiChar);
  var
    CanMove : Cardinal;
  begin
    CanMove := (EndPt - BeginPt);
    CanMove := MinCard(CanMove, (Size - Result));
    Move(BeginPt^, (PAnsiChar(@Buf)+Result)^, CanMove);
    Inc(Result, CanMove);

   if CanMove > 0 then begin
     UpDatePtr(FInStart, CanMove);
     if FInStart >= FInBufEnd then
       FInStart := FInBuf;
   end;
   if (FInStart <> FInEnd) or (CanMove > 0) then
     FInBufFull := False;
   if FInStart <= FInEnd then
     if (FInCursor < FInStart) or (FInCursor >= FInEnd) then
       FInCursor := FInStart
     else
   else
     if (FInCursor < FInStart) and (FInCursor >= FInEnd) then
       FInCursor := FInStart;
  end;

  procedure ProcessChunk(BuffEnd : Boolean);
  var
    CanMove, Processed : Cardinal;
    EndPt, ResetPt : PAnsiChar;
  begin
    if BuffEnd then begin
      EndPt := FInBufEnd;
      ResetPt := FInBuf;
    end else begin
      EndPt := FInEnd;
      ResetPt := FInEnd;
    end;
    CanMove := MinCard((EndPt - FInCursor), (Size - Result));
    if CanMove > 0 then begin
      Processed := ProcessCommands(PAnsiChar(@Buf)+Result, CanMove);
      Inc(Result, Processed);
      if FInCursor >= EndPt then
        FInCursor := ResetPt;
      FInStart := FInCursor;
      FInBufFull := False;
    end;
  end;

begin
  Result := 0;
  if (FInEnd >= FInStart) and not FInBufFull then begin
    { Not currently wrapped -- but we can if need be }
    CanRead := (FInBufEnd - FInEnd);
    CanRead2 := (FInStart - FInBuf);
    NumRead := ApdSocket.ReadSocket(FCommSocket, FInEnd^, CanRead, 0);
    if NumRead = SOCKET_ERROR then
      NumRead := 0;
    if NumRead > 0 then begin
      FInEnd := FInEnd + NumRead;
      if FInEnd = FInBufEnd then
        FInEnd := FInBuf;
      if FInStart = FInEnd then
        FInBufFull := True;
    end;
    if Size = 0 then
      Exit;
    if NumRead = Integer(CanRead) then begin
      { Try again with wrap -- possibly more to read }
      NumRead2 := ApdSocket.ReadSocket(FCommSocket, FInBuf^, CanRead2, 0);
      if NumRead2 = SOCKET_ERROR then
        NumRead2 := 0;
      if NumRead2 > 0 then begin
        FInEnd := FInBuf + NumRead2;
        FInBufFull := (FInStart = FInEnd);
      end;
      if NumRead2 > 0 then begin
        { Successful wrap read }
        FInCursor := FindIAC(FInCursor, (FInBufEnd - FInCursor));
        { Are we processing telnet stuff? }
        if FInCursor = FInBufEnd then begin
          { No IACs found }
          FInCursor := FInBuf;
          MoveChunk(FInStart, FInBufEnd);
        end else begin
          { Move data prior to IAC }
          MoveChunk(FInStart, FInCursor);
          { Process and move beyond IAC }
          ProcessChunk(True);
          if FInCursor <> FInBuf then
            Exit;
        end;
        { Ready to process wrapped data }
        FInCursor := FindIAC(FInCursor, (FInEnd - FInCursor));
        { Are we processing telnet stuff? }
        if FInCursor = FInEnd then begin
          { No IACs found }
          FInCursor := FInStart;
          MoveChunk(FInBuf, FInEnd);
        end else begin
          { Move data prior to IAC }
          MoveChunk(FInBuf, FInCursor);
          { Process and move beyond IAC }
          ProcessChunk(False);
        end;
      end else begin
        { We didn't wrap }
        FInCursor := FindIAC(FInCursor, (FInEnd - FInCursor));
        { Are we processing telnet stuff? }
        if FInCursor = FInEnd then begin
          { No IACs found }
          FInCursor := FInStart;
          MoveChunk(FInStart, FInEnd);
        end else begin
          { Move data prior to IAC }
          MoveChunk(FInStart, FInCursor);
          { Process and move beyond IAC }
          ProcessChunk(False);
        end;
      end;
    end else begin
      { Read all there was available -- no need to wrap }
      FInCursor := FindIAC(FInCursor, (FInEnd - FInCursor));
      { Are we processing telnet stuff? }
      if FInCursor = FInEnd then begin
        { No IACs found }
        FInCursor := FInStart;
        MoveChunk(FInStart, FInEnd);
      end else begin
        { Move data prior to IAC }
        MoveChunk(FInStart, FInCursor);
        { Process and move beyond IAC }
        ProcessChunk(False);
      end;
    end;
  end else begin
    { Already wrapped }
    if not FInBufFull then begin
      { Read as much as we can }
      CanRead := (FInStart - FInEnd);
      NumRead := ApdSocket.ReadSocket(FCommSocket, FInEnd^, CanRead, 0);
      if NumRead = SOCKET_ERROR then
        NumRead := 0;
      FInEnd := FInEnd + NumRead;
      if FInEnd = FInBufEnd then
        FInEnd := FInBuf;
      if (NumRead > 0) and (FInStart = FInEnd) then
        FInBufFull := True;
    end;
    if Size = 0 then
      Exit;
    { Is the cursor on the first half or second half of wrap? }
    if FInCursor >= FInStart then begin
      { Yes, cursor is on first half }
      FInCursor := FindIAC(FInCursor, (FInBufEnd - FInCursor));
      if FInCursor = FInBufEnd then begin
        { No IACs found }
        FInCursor := FInStart;
        MoveChunk(FInStart, FInBufEnd);
        if (FInStart <> FInEnd) then
          FInBufFull := False;
        FInCursor := FInStart;
      end else begin
        { Move data prior to IAC }
        MoveChunk(FInStart, FInCursor);
        { Process and move beyond IAC }
        ProcessChunk(True);
        if (FInStart <> FInEnd) then
          FInBufFull := False;
        FInCursor := FInStart;
      end;
    end else begin
      { Cursor is on second half }
      FInCursor := FindIAC(FInCursor, (FInEnd - FInCursor));
      { Move first half }
      MoveChunk(FInStart, FInBufEnd);
      { Process second half up to IAC }
      MoveChunk(FInBuf, FInCursor);
    end;
  end;
end;

destructor TWsConnection.Destroy;
begin
  FreeMem(FInBuf, FInSize);
  FreeMem(FOutBuf, FOutSize);
  inherited Destroy;
end;

function TWsConnection.GetConnected : Boolean;
begin
 Result := (ConnectionState = wcsConnected);
end;

{ Get number of characters currently in the input buffer }
function TWsConnection.GetInChars : Cardinal;
var
  Buf : AnsiChar;
begin
  if FInBufFull then
    Result := FInSize
  else begin
    if ConnectionState = wcsConnected then
      { Force a read from Winsock if anything is available }
      ReadBuf(Buf, 0);
    if FInBufFull then
      Result := FInSize
    else
      if FInEnd >= FInStart then
        Result := FInEnd - FInStart
      else
        Result := Integer(FInSize) - (FInStart - FInEnd);
  end;
end;

{ Get number of characters currently in the output buffer }
function TWsConnection.GetOutChars : Cardinal;
var
  Buf : AnsiChar;
begin
  if (ConnectionState = wcsConnected) then
    { Force a write to Winsock if buffer has data }
    if FOutBufFull or (FOutStart <> FOutEnd) then begin
      WriteBuf(Buf, 0);
    end else begin
      FSimBuf := 0;
    end;
  Result := FSimBuf;
end;

{ Set the connection state and DCD if necessary }
procedure TWsConnection.SetConnectionState(Value : TWsConnectionState);
begin
  if FConnectionState <> Value then begin
    if FConnectionState = wcsConnected then
      ClearFlag(FDispatcher.ModemStatus, DCDMask);
    FConnectionState := Value;
    if FConnectionState = wcsConnected then
      SetFlag(FDispatcher.ModemStatus, DCDMask);
  end;
end;

{ Send Telnet DO command with option }
procedure TWsConnection.SendDo(Option: AnsiChar);
var
  Buf : array[1..3] of AnsiChar;
begin
  Buf[1] := TELNET_IAC;
  Buf[2] := TELNET_DO;
  Buf[3] := Option;
  ApdSocket.WriteSocket(FCommSocket, Buf, SizeOf(Buf), 0);
  if FDispatcher.DLoggingOn then
    FDispatcher.AddDispatchEntry(dtTelnet, dstSDo, Ord(Option), nil, 0);
end;

{ Send Telnet DONT command with option }
procedure TWsConnection.SendDont(Option: AnsiChar);
var
  Buf : array[1..3] of AnsiChar;
begin
  Buf[1] := TELNET_IAC;
  Buf[2] := TELNET_DONT;
  Buf[3] := Option;
  ApdSocket.WriteSocket(FCommSocket, Buf, SizeOf(Buf), 0);
  if FDispatcher.DLoggingOn then
    FDispatcher.AddDispatchEntry(dtTelnet, dstSDont, Ord(Option), nil, 0);
end;

{ Send Telnet Terminal type }
procedure TWsConnection.SendTerminal;
var
  Temp : Ansistring;
begin
  Temp := TELNET_IAC + TELNET_SB + TELNETOPT_TERM + #0 +
    ApdSocket.WsTerminal + TELNET_IAC + TELNET_SE;
  ApdSocket.WriteSocket(FCommSocket, Temp[1], Length(Temp), 0);
  if FDispatcher.DLoggingOn then
    FDispatcher.AddDispatchEntry(dtTelnet, dstSTerm, 0, @ApdSocket.FWsTerminal[1],
      Length(ApdSocket.WsTerminal));
end;

{ Send Telnet WILL command with option }
procedure TWsConnection.SendWill(Option: AnsiChar);
var
  Buf : array[1..3] of AnsiChar;
begin
  Buf[1] := TELNET_IAC;
  Buf[2] := TELNET_WILL;
  Buf[3] := Option;
  ApdSocket.WriteSocket(FCommSocket, Buf, SizeOf(Buf), 0);
  if FDispatcher.DLoggingOn then
    FDispatcher.AddDispatchEntry(dtTelnet, dstSWill, Ord(Option), nil, 0);
end;

{ Send Telnet WONT command with option }
procedure TWsConnection.SendWont(Option: AnsiChar);
var
  Buf : array[1..3] of AnsiChar;
begin
  Buf[1] := TELNET_IAC;
  Buf[2] := TELNET_WONT;
  Buf[3] := Option;
  ApdSocket.WriteSocket(FCommSocket, Buf, SizeOf(Buf), 0);
  if FDispatcher.DLoggingOn then
    FDispatcher.AddDispatchEntry(dtTelnet, dstSWont, Ord(Option), nil, 0);
end;

{ Shuts down the connection }
function TWsConnection.Shutdown : Integer;
begin
  with ApdSocket do begin
    { If we have a client connected, shut it down first }
    if not FIsClient and (FCommSocket <> SOCKET_ERROR) then
      CloseSocket(FCommSocket);
    CloseSocket(FSocketHandle);
  end;
  Result := 0;
end;

function TWsConnection.WriteBuf(var Buf; Size : Integer) : Integer;
var
  Start, Cursor, SrcPtr, DestPtr, EndBuf : PAnsiChar;
  CanMove, CanMove2 : Integer;
  Sent : Integer;
begin
  Inc(FSimBuf, Size);
  Start := @Buf;
  Result := 0;
  if Size > 0 then begin
    if FIsTelnet then
      Cursor := FindIAC(Start, Size)
    else
      Cursor := (Start + Size);
    if not FOutBufFull then begin
      if (Cursor - Start) = Size then begin
        { No IACs -- move as much of the buffer as possible }
        if FOutEnd >= FOutStart then begin
          { Not wrapped }
          CanMove := (FOutBufEnd - FOutEnd);
          if Size > CanMove then begin
            { Need to wrap }
            Move(Buf, FOutEnd^, CanMove);
            Inc(Result, CanMove);
            CanMove2 := (FOutStart - FOutBuf);
            if CanMove2 > (Size - CanMove) then
              CanMove2 := (Size - CanMove);
            Move((PAnsiChar(@Buf)+CanMove)^, FOutBuf^, CanMove2);
            Inc(Result, CanMove2);
            FOutEnd := FOutBuf + CanMove2;
            if (FOutEnd = FOutStart) then
              FOutBufFull := True;
          end else begin
            { Don't need to wrap }
            Move(Buf, FOutEnd^, Size);
            FOutEnd := FOutEnd + Size;
            if FOutEnd = FOutBufEnd then
              FOutEnd := FOutBuf;
            if (FOutEnd = FOutStart) then
              FOutBufFull := True;
            Inc(Result, Size);
          end;
        end else begin
          { Already wrapped }
          CanMove := (FOutStart - FOutEnd);
          if CanMove > Size then
            CanMove := Size;
          Move(Buf, FOutEnd^, CanMove);
          Inc(Result, CanMove);
          FOutEnd := (FOutEnd + CanMove);
          if FOutEnd = FOutBufEnd then
            FOutEnd := FOutBuf;
          if (FOutEnd = FOutStart) then
            FOutBufFull := True;
        end;
      end else begin
        { Move data by bytes -- doubling each $FF }
        SrcPtr := @Buf;
        EndBuf := (SrcPtr + Size);
        DestPtr := FOutEnd;
        while SrcPtr < EndBuf do begin
          if SrcPtr^ = TELNET_IAC then begin
            { IAC needs to be doubled (escaped) }
            DestPtr^ := SrcPtr^;
            SrcPtr := (SrcPtr + 1);
            Inc(Result);
            DestPtr := (DestPtr + 1);
            if (DestPtr = FOutBufEnd) then
              DestPtr := FOutBuf;
            if (DestPtr = FOutStart) then
              EndBuf := SrcPtr;
            { Write second character and advance DestPtr }
            DestPtr^ := TELNET_IAC;
            DestPtr := (DestPtr + 1);
            if (DestPtr = FOutBufEnd) then
              DestPtr := FOutBuf;
            if (DestPtr = FOutStart) then
              EndBuf := SrcPtr;
          end else if (SrcPtr^ = TELNET_CR) and
                      ((SrcPtr + 1)^ <> TELNET_LF) and
                      (FOptBinary = tnoFalse) then begin
            { CR needs a null added after it }
            DestPtr^ := SrcPtr^;
            SrcPtr := (SrcPtr + 1);
            Inc(Result);
            DestPtr := (DestPtr + 1);
            if (DestPtr = FOutBufEnd) then
              DestPtr := FOutBuf;
            if (DestPtr = FOutStart) then
              EndBuf := SrcPtr;
            { Write second character and advance DestPtr }
            DestPtr^ := TELNET_NULL;
            DestPtr := (DestPtr + 1);
            if (DestPtr = FOutBufEnd) then
              DestPtr := FOutBuf;
            if (DestPtr = FOutStart) then
              EndBuf := SrcPtr;
          end else begin
            { Simple case, just copy }
            DestPtr^ := SrcPtr^;
            SrcPtr := (SrcPtr + 1);
            Inc(Result);
            DestPtr := (DestPtr + 1);
            if (DestPtr = FOutBufEnd) then
              DestPtr := FOutBuf;
            if DestPtr = FOutStart then
              EndBuf := SrcPtr;
          end;
        end;
        FOutEnd := DestPtr;
        if (FOutEnd = FOutStart) then
          FOutBufFull := True;
      end;
    end;
  end;
  if FOutEnd > FOutStart then begin
    { Not wrapped, can send in one chunk }
    Sent := ApdSocket.WriteSocket(FCommSocket, FOutStart^, (FOutEnd - FOutStart), 0);
    if Sent > 0 then
      FOutBufFull := False;
    if Sent <> SOCKET_ERROR then begin
      FOutStart := (FOutStart + Sent);
      if FOutStart = FOutBufEnd then
        FOutStart := FOutBuf;
    end;
  end else begin
    { Wrapped, send first half }
    Sent := ApdSocket.WriteSocket(FCommSocket, FOutStart^, (FOutBufEnd - FOutStart), 0);
    if Sent > 0 then
      FOutBufFull := False;
    if Sent <> SOCKET_ERROR then begin
      FOutStart := (FOutStart + Sent);
      if FOutStart = FOutBufEnd then begin
        FOutStart := FOutBuf;
        { Send second half }
        Sent := ApdSocket.WriteSocket(FCommSocket, FOutBuf^, (FOutEnd - FOutBuf), 0);
        if Sent > 0 then
          FOutBufFull := False;
        if Sent <> SOCKET_ERROR then
          FOutStart := (FOutBuf + Sent);
      end;
    end;
  end;
end;

{ TApdDeviceSocket methods }

constructor TApdDeviceSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWsTerminal := DefWsTerminal;
  FillChar(SockSection, SizeOf(SockSection), #0);
  InitializeCriticalSection(SockSection);
end;

destructor TApdDeviceSocket.Destroy;
begin
  DeleteCriticalSection(SockSection);
  inherited Destroy;
end;

function TApdDeviceSocket.DoDispMessage(Socket: TSocket; Event : Cardinal; LP : Integer) : Integer;
var
  ComRec : Pointer;
begin
  Result := 0;
  ComRec := TApdBaseDispatcher(GetTComRecPtr(Socket, TApdWinsockDispatcher));
  if Assigned(ComRec) then
    Result := SendMessage(TApdBaseDispatcher(ComRec).DispatcherWindow, CM_APDSOCKETMESSAGE, Socket, LP);
end;

function TApdDeviceSocket.DoWsMessage(Socket : TSocket; Event : Cardinal; LP : Integer) : Integer;
var
  ComRec : TApdBaseDispatcher;
begin
  Result := 0;
  ComRec := TApdBaseDispatcher(GetTComRecPtr(Socket, TApdWinsockDispatcher));
  if Assigned(ComRec) then begin
    ComRec.EventBusy := True;
    { Send the message to the comport }
    if ComRec.Owner <> nil then
      Result := SendMessage(TApdCustomComPort(ComRec.Owner).ComWindow, CM_APDSOCKETMESSAGE, Event, LP);
    ComRec.EventBusy := False;
  end;
end;

{ Handle FD_ACCEPT Message }
procedure TApdDeviceSocket.DoAccept(Socket: TSocket);
var
  Connection : TWsConnection;
  ComRec : TApdWinsockDispatcher;
  TempSocket : TSocket;
begin
  ComRec := nil;
  Connection := ApdSocket.FindConnection(Socket);
  if Assigned (Connection) then
    ComRec := Connection.FDispatcher;
  if Assigned(ComRec) then begin
    with ComRec, Connection do begin
      if FCommSocket = SOCKET_ERROR then begin
        FCommSocket := ApdSocket.AcceptSocket(Socket, WsSockAddr);
        if FCommSocket = SOCKET_ERROR then begin
          { Error Occurred -- Clean up and exit }
          FillChar(WsSockAddr, SizeOf(WsSockAddr), #0);
          Exit;
        end;
      { We already have a client, so kill this one... }
      end else begin
        TempSocket := ApdSocket.AcceptSocket(Socket, WsSockAddr);
        ApdSocket.CloseSocket(TempSocket);
        Exit;
      end;
      if DoWsMessage(Socket, FD_ACCEPT, Integer(WsSockAddr.sin_addr)) = 1 then begin
        { Accept connection }
        ConnectionState := wcsConnected;
      end else begin
        { Kill connection }
        ApdSocket.CloseSocket(FCommSocket);
        FillChar(WsSockAddr, SizeOf(WsSockAddr), #0);
        FCommSocket := SOCKET_ERROR;
      end;
    end;
  end;
  inherited DoAccept(Socket);
end;

{ Handle FD_CONNECT Message }
procedure TApdDeviceSocket.DoConnect(Socket: TSocket);
var
  Connection : TWsConnection;
begin
  Connection := ApdSocket.FindConnection(Socket);
  if not Assigned(Connection) then Exit;
  with TWsConnection(Connection) do begin
    ConnectionState := wcsConnected;
    if FIsClient then
      FCommSocket := Socket;
  end;
  DoWsMessage(Socket, FD_CONNECT, 0);
  inherited DoConnect(Socket);
end;

{ Handle FD_CLOSE Message }
procedure TApdDeviceSocket.DoDisconnect(Socket: TSocket);
var
  Connection : TWsConnection;
  ComRec : TApdWinsockDispatcher;
begin
  Connection := ApdSocket.FindConnection(Socket);
  if Assigned (Connection) then begin
    with Connection do begin
      ComRec := TApdWinsockDispatcher(GetTComRecPtr(FSocketHandle, TApdWinsockDispatcher));
      if Assigned(ComRec) then begin
        with ComRec do begin
          FillChar(WsSockAddr, SizeOf(WsSockAddr), #0);
          FCommSocket := SOCKET_ERROR;
          ConnectionState := wcsInit;
        end;
      end;
      if Socket = FSocketHandle then
        DoWsMessage(FSocketHandle, FD_CLOSE, 0)
      else begin
        { "Special" msg to signal it's the connected client closing }
        DoWsMessage(FSocketHandle, FD_CLOSE or FD_CONNECT, 0);
        CloseSocket(Socket);
      end;
    end;
  end;
  inherited DoDisconnect(Socket);
end;

{ Handle Async Errors Without Raising Exceptions }
procedure TApdDeviceSocket.DoError(Socket : TSocket; ErrCode : Integer);
var
  CorrectedSocket : TSocket;
begin
  CorrectedSocket := TweakSocket(Socket);
  if CorrectedSocket <> -1 then
    DoWsMessage(CorrectedSocket, ErrCode, 0);
  if Assigned(FOnWsError) then FOnWsError(Self, Socket, ErrCode);
end;

{ Handle FD_READ Message }
procedure TApdDeviceSocket.DoRead(Socket: TSocket);
var
  CorrectedSocket : TSocket;
begin
  CorrectedSocket := TweakSocket(Socket);
  if CorrectedSocket <> -1 then
    DoDispMessage(CorrectedSocket, FD_READ, 0);
  inherited DoRead(Socket);
end;

{ Handle FD_WRITE Message }
procedure TApdDeviceSocket.DoWrite(Socket: TSocket);
begin
  inherited DoWrite(Socket);
end;

{ Returns a Socket handle for a CommSocket handle }
function TApdDeviceSocket.TweakSocket(Socket : TSocket) : TSocket;
var
  Connection : TWsConnection;
begin
  Connection := ApdSocket.FindConnection(Socket);
  if Assigned(Connection) then
    Result := Connection.SocketHandle
  else
    Result := -1;
end;

{ Finds a connection that corresponds to a Socket handle }
const
  LastSocket : TSocket = -1;
  LastConnection : TWsConnection = nil;

procedure TApdDeviceSocket.LockList;
begin
  EnterCriticalSection(SockSection);
end;

procedure TApdDeviceSocket.UnLockList;
begin
  LeaveCriticalSection(SockSection);
end;

function TApdDeviceSocket.FindConnection(Socket : TSocket) : TWsConnection;
var
  I : Integer;
begin
  LockList;
  try
    if (Socket = LastSocket) and (LastConnection <> nil) then
      Result := LastConnection
    else begin
      for I := 0 to Pred(ComponentCount) do begin
        if Components[I] is TWsConnection then begin
          if (TWsConnection(Components[I]).CommSocket = Socket) or
             (TWsConnection(Components[I]).SocketHandle = Socket) then begin
            Result := TWsConnection(Components[I]);
            LastSocket := Socket;
            LastConnection := Result;
            Exit;
          end;
        end;
      end;
      Result := nil;
    end;
  finally
    UnlockList;
  end;
end;

function TApdWinsockDispatcher.CheckPort(ComName: PChar): Boolean;
// Returns true if a port exists (this is basically untested)
begin
   Result := OpenCom(ComName, 64, 64) <> 0;
   if Result then
     CloseCom;
end;

function TApdWinsockDispatcher.CloseCom : Integer;
  { -Close the socket (and connected client's socket) and cleanup }
var
  Connection : TWsConnection;
begin
  ApdSocket.LockList;
  try
    Connection := ApdSocket.FindConnection(CidEx);
    if Assigned(Connection) then
      with Connection do begin
        Result := Shutdown;
        Free;
        LastSocket := -1;
        LastConnection := nil;
      end
    else Result := -1;
  finally
    ApdSocket.UnLockList;
  end;
end;

function TApdWinsockDispatcher.EscapeComFunction(Func : Integer) : Integer;
  { -Perform the extended comm function Func }
begin
  Result := 0;
end;

function TApdWinsockDispatcher.FlushCom(Queue : Integer) : Integer;
  { -Flush the input or output buffer }
var
  Connection : TWsConnection;
begin
  Connection := ApdSocket.FindConnection(CidEx);
  if Assigned(Connection) then begin
    case Queue of
      0 : Connection.FlushOutBuffer;
      1 : Connection.FlushInBuffer;
    end;
  end;
  Result := ecOK;
end;

function TApdWinsockDispatcher.GetComError(var Stat : TComStat) : Integer;
  { -Get the current error and update Stat }
var
  Connection : TWsConnection;
  OutBytes : Cardinal;
begin
  Connection := ApdSocket.FindConnection(CidEx);
  if Assigned(Connection) then begin
    with Connection do begin
      Stat.cbInQue := GetInChars;
      { Fudge a little to ensure enough room for IACs and satisfy the }
      { dispatcher's assumptions... }
      OutBytes := GetOutChars;
      Stat.cbOutQue := OutBytes;
    end;
  end;
  { since we're a nonblocking socket, practically every function will }
  { return WSAEWOULDBLOCK, filter it out here so it doesn't propagate }
  { through to the OnTriggerXxx events }
  if ApdSocket.LastError <> WSAEWOULDBLOCK then                          {!!.05}
    Result := ApdSocket.LastError                                        {!!.05}
  else                                                                   {!!.05}
    Result := 0;                                                         {!!.05}
end;

function TApdWinsockDispatcher.GetComEventMask(EvtMask : Integer) : Cardinal;
  { -Set the communications event mask }
begin
  Result := 0;
end;

function TApdWinsockDispatcher.GetComState(var DCB : TDCB) : Integer;
  { -Fill in DCB with the current communications state }
begin
  DCB.BaudRate := 19200;
  DCB.ByteSize := 8;
  DCB.StopBits := 1;
  DCB.Parity := 0;
  Result := 0;
end;

function TApdWinsockDispatcher.OpenCom(ComName : PChar; InQueue, OutQueue : Cardinal) : Integer;
  { -Open the socket specified by ComName }
begin
  try
    ApdSocket.LockList;
    try
      Result := TWsConnection.CreateInit(ApdSocket, InQueue, OutQueue).SocketHandle;
    finally
      ApdSocket.UnLockList;
    end;
    CidEx := Result;
  except
    Result := -ApdSocket.LastError;
  end;
end;

function TApdWinsockDispatcher.ReadCom(Buf : PAnsiChar; Size : Integer) : Integer;
  { -Read Size bytes from Connection }
var
  Connection : TWsConnection;
begin
  Result := 0;
  Connection := ApdSocket.FindConnection(CidEx);
  if Assigned(Connection) then
    if Connection.ConnectionState = wcsConnected then begin
      Result := Connection.ReadBuf(Buf^, Size);
    end;
end;

function TApdWinsockDispatcher.SetComState(var DCB : TDCB) : Integer;
  { -Set the a new communications device state from DCB }
begin
  Result := ecOk;
end;

function TApdWinsockDispatcher.WriteCom(Buf : PAnsiChar; Size : Integer) : Integer;
  { -Write data to Connection }
var
  Connection : TWsConnection;
begin
  Result := 0;
  Connection := ApdSocket.FindConnection(CidEx);
  if Assigned(Connection) then
    Result := Connection.WriteBuf(Buf^, Size);
end;

function TApdWinsockDispatcher.ProcessCommunications : Integer;
  {-Not needed, communications are always running in separate threads}
begin
  Result := Dispatcher(0, 1, 0);
end;

function TApdWinsockDispatcher.SetupCom(InSize, OutSize : Integer) : Boolean;
  { -Bind Socket, and Connect or Listen }
var
  Connection : TWsConnection;
  Dummy : Bool;

  function IsError(EC : Integer) : Boolean;
  begin
    Result := False;
    if EC = SOCKET_ERROR then
      Result := ApdSocket.LastError <> WSAEWOULDBLOCK;
  end;

begin
  Result := False;
  Dummy := True;
  if IsError(ApdSocket.SetSocketOptions(CidEx, Sol_Socket, So_ReuseAddr, Dummy, SizeOf(Dummy))) then Exit;
  if IsError(ApdSocket.BindSocket(CidEx, WsHostAddr)) then Exit;
  if IsError(ApdSocket.SetAsyncStyles(CidEx, DefAsyncStyles)) then Exit;
  if WsIsClient then begin
    if IsError(ApdSocket.ConnectSocket(CidEx, WsSockAddr)) then Exit;
  end else
    if IsError(ApdSocket.ListenSocket(CidEx, 5)) then Exit;
  Connection := ApdSocket.FindConnection(CidEx);
  if Assigned(Connection) then
    with Connection do begin
      IsClient := WsIsClient;
      IsTelnet := WsIsTelnet;
      FDispatcher := Self;
    end;
  Result := True;
end;

function TApdWinsockDispatcher.Dispatcher(Msg : Cardinal;
                       wParam : Cardinal; lParam : Integer) : Cardinal;
  {-Dispatch Winsock functions}

begin
  Result := 0;

  if InDispatcher then exit;

  InDispatcher := True;
  try
    {Check for events at each open port}

    if ClosePending then Exit;

    RefreshStatus;

    if ComStatus.cbInQue > 0 then
      ExtractData;

    {Check for triggers}
    if (wParam = 0) and not EventBusy then begin

      GlobalStatHit := False;
      while CheckTriggers and not ClosePending do
        ;

      {Allow status triggers to hit again}
      if GlobalStatHit then
        ResetStatusHits;

    end else
    {Attempt at re-entrancy}
    if DLoggingOn then
      AddDispatchEntry(dtError, dstNone, 0, nil, 0);

  finally
    InDispatcher := False;
    if ClosePending then
      DonePortPrim;
  end;
end;

function WsCommTimer(H : TApdHwnd; Msg, wParam : Cardinal;
                      lParam : Integer) : Cardinal; stdcall; export;
  {-Dispatch COMM functions}
var
  I : Integer;
begin
  for I := 0 to pred(PortList.Count) do
    if (I < PortList.Count) and (PortList[i] <> nil) then
      with TApdWinsockDispatcher(PortList[i]) do
        if (TimerID = wParam) then begin
          Result := Dispatcher(0, 0, lParam);
          Exit;
        end;
  Result := 0;
end;

procedure TApdWinsockDispatcher.InitSocketData(LocalAddress, Address : Integer;
                       Port : Cardinal; IsClient, IsTelnet : Boolean);
begin
  {Init Winsock data}
  WsIsClient := IsClient;
  WsIsTelnet := IsTelnet;
  WsSockAddr.sin_family := AF_INET;
  WsSockAddr.sin_port := Port;
  WsSockAddr.sin_addr := TInAddr (Address);
  WsHostAddr.sin_family := AF_INET;
  if not IsClient then
    WsHostAddr.sin_port := Port;
end;

procedure TApdWinsockDispatcher.StartDispatcher;
begin
  {See if we're already active}
  if DispActive then
    raise Exception.Create('Dispatcher already started');

  DispActive := True;

  TimerID := SetTimer(0, 1, TimerFreq, @WsCommTimer);
  if TimerID = 0 then
    raise Exception.Create('Resource not available');

  {Start dispatcher}
  CreateDispatcherWindow;
end;

procedure TApdWinsockDispatcher.StopDispatcher;
begin
  if not DispActive then
    Exit;

  KillTimer(0, TimerID);
  {Shut down dispatcher}
  DestroyWindow(DispatcherWindow);
  DispActive := False;
end;

function TApdWinsockDispatcher.WaitComEvent(var EvtMask : DWORD;
                               lpOverlapped : POverlapped) : Boolean;
begin
  { Doesn't apply to Winsock }
  Result := True;
end;

function DispatcherWndFunc(hWindow : TApdHwnd; Msg, wParam : Cardinal;
                           lParam : Integer) : Integer; stdcall; export;
  {-Window function for wm_CommNotify or cw_ApdSocketMessage messages}
var
  I : Integer;
begin
  Result := 0;
  if Msg = cm_ApdSocketMessage then begin
    for I := 0 to pred(PortList.Count) do begin
      if (I < PortList.Count) and (PortList[i] <> nil) then
        with TApdWinsockDispatcher(PortList[i]) do
          if (CidEx = Integer(wParam)) then begin
            Result := Dispatcher(Msg, 0, lParam);
            break;
          end;
    end;
  end else
    Result := DefWindowProc(hWindow, Msg, wParam, lParam);
end;

procedure RegisterDispatcherClass;
const
  Registered : Boolean = False;
var
  XClass: TWndClass;
begin
  if Registered then
    Exit;
  Registered := True;

  with XClass do begin
    Style         := 0;
    lpfnWndProc   := @DispatcherWndFunc;
    cbClsExtra    := 0;
    cbWndExtra    := 0;
    if ModuleIsLib and not ModuleIsPackage then
      hInstance   := SysInit.hInstance
    else
      hInstance   := System.MainInstance;
    hIcon         := 0;
    hCursor       := 0;
    hbrBackground := 0;
    lpszMenuName  := nil;
    lpszClassName := DispatcherClassName;
  end;
  Windows.RegisterClass(XClass);
end;

procedure DeactivateAwWnSock;
  { -Frees the ApdSocket object }
begin
  FreeAndNil(ApdSocket);
end;

// Added by SWB to be consistent with awwin32 which needed a separate routine
// to return the number of bytes used in the output buffer because the
// ClearCommError call was too slow to be used for this purpose.
function TApdWinsockDispatcher.OutBufUsed: Cardinal;
var
  Connection : TWsConnection;
begin
  Connection := ApdSocket.FindConnection(CidEx);
  if Assigned(Connection) then
    Result := Connection.GetOutChars
  else
    Result := 0;
end;
// Added by SWB to be consistent with LnsWin32 which needed a separate routine
// to return the number of bytes available to be read in the input queue.
function TApdWinsockDispatcher.InQueueUsed : Cardinal;
var
  Connection : TWsConnection;
begin
  Connection := ApdSocket.FindConnection(CidEx);
  if Assigned(Connection) then
    Result := Connection.GetInChars
  else
    Result := 0;
end;

initialization        //SZ FIXME loader lock

  {if not (csDesigning in ComponentState) then}
    RegisterDispatcherClass;
  {Create the ApdSocket}
  if not IsLibrary then //SZ: bugfix Loader Lock Problem!! (never ever call LoadLibrary from initialization / dllmain)
    ApdSocket := TApdDeviceSocket.Create(nil);

finalization            //SZ: bugfix Loader Lock Problem!!
  if not IsLibrary then
    DeactivateAwWnSock;
end.
