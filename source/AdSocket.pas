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
{*                   ADSOCKET.PAS 5.00                   *}
{*********************************************************}
{* Winsock support classes                               *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+,T-}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdSocket;
  { -Apro Winsock support classes }

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Forms,
  OOMisc,
  AdWUtil;

const
  IPStrSize = 15;
  { This should be the same in AWUSER.PAS }
  CM_APDSOCKETMESSAGE = WM_USER + $0711;
  CM_APDSOCKETQUIT    = WM_USER + $0712;

  { APRO Specific errors }
  ADWSBASE   =  9000;

  ADWSERROR        = (ADWSBASE + 1);                                   
  ADWSLOADERROR    = (ADWSBASE + 2);                                   
  ADWSVERSIONERROR = (ADWSBASE + 3);                                   
  ADWSNOTINIT      = (ADWSBASE + 4);                                   
  ADWSINVPORT      = (ADWSBASE + 5);                                   
  ADWSCANTCHANGE   = (ADWSBASE + 6);                                   
  ADWSCANTRESOLVE  = (ADWSBASE + 7);
  { Socks 4/4a errors }
  ADWSREQUESTFAILED  = (ADWSBASE + 8);
  ADWSREJECTEDIDENTD = (ADWSBASE + 9);
  ADWSREJECTEDUSERID = (ADWSBASE + 10);
  ADWSUNKNOWNERROR   = (ADWSBASE + 11);
  { Socks 5 errors }
  ADWSSOCKSERROR           = (ADWSBASE + 12);
  ADWSCONNECTIONNOTALLOWED = (ADWSBASE + 13);
  ADWSNETWORKUNREACHABLE   = (ADWSBASE + 14);
  ADWSHOSTUNREACHABLE      = (ADWSBASE + 15);
  ADWSREFUSED              = (ADWSBASE + 16);
  ADWSTTLEXPIRED           = (ADWSBASE + 17);
  ADWSBADCOMMAND           = (ADWSBASE + 18);
  ADWSBADADDRESSTYPE       = (ADWSBASE + 19);
  ADWSUNSUPPORTEDREPLY     = (ADWSBASE + 20);
  ADWSINVALIDREPLY         = (ADWSBASE + 21);

type
  TCMAPDSocketMessage = record
    Msg: Cardinal;
    Socket: TSocket;
    SelectEvent: Word;
    SelectError: Word;
    Result: Integer;
  end;

  EApdSocketException = class(Exception)
    ErrorCode : Integer;
    { Dummy parameters are a hack to make BCB happy }
    constructor CreateNoInit(ErrCode : Integer; Dummy : PChar);
    constructor CreateTranslate(ErrCode, Dummy1, Dummy2 : Integer);
  end;

  TWsMode = (wsClient, wsServer);

  TWsNotifyEvent = procedure (Sender : TObject; Socket : TSocket) of object;
  TWsSocketErrorEvent =
    procedure (Sender : TObject; Socket : TSocket; ErrCode : Integer) of object;

  TApdSocket = class(TComponent)
  protected {private}
    { Property Support Fields }
    FHandle : HWnd;
    FOnWsAccept : TWsNotifyEvent;
    FOnWsConnect : TWsNotifyEvent;
    FOnWsDisconnect : TWsNotifyEvent;
    FOnWsError : TWsSocketErrorEvent;
    FOnWsRead : TWsNotifyEvent;
    FOnWsWrite : TWsNotifyEvent;
    { Internal Use }
    asDllLoaded : Boolean;
    asStartErrorCode : Integer;
    asWSData : TWSAData;
    function GetDescription : string;
    function GetHandle : HWnd;
    function GetLastError : Integer;
    function GetLocalHost : string;
    function GetLocalAddress : string;
    function GetSystemStatus : string;
    procedure CMAPDSocketMessage(var Message: TCMAPDSocketMessage); message CM_APDSOCKETMESSAGE;
    procedure WndProc(var Message : TMessage);
  protected
    procedure ShowErrorMessage(Err : Integer); dynamic;
    procedure DoAccept(Socket : TSocket); virtual;
    procedure DoConnect(Socket : TSocket); virtual;
    procedure DoDisconnect(Socket : TSocket); virtual;
    procedure DoError(Socket : TSocket; ErrCode : Integer); virtual;
    procedure DoRead(Socket : TSocket); virtual;
    procedure DoWrite(Socket : TSocket); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Conversion routines }
    procedure CheckLoaded;
    procedure DefaultHandler(var Message); override;
    function htonl(HostLong : Integer) : Integer;
    function htons(HostShort : Word) : Word;
    function ntohl(NetLong : Integer) : Integer;
    function ntohs(NetShort : Word) : Word;
    function NetAddr2String(InAddr : TInAddr) : string;
    function String2NetAddr(const S : string) : TInAddr;
    { Lookup routines }
    function LookupAddress(InAddr : TInAddr) : string;
    function LookupName(const Name : AnsiString) : TInAddr;
    function LookupPort(Port : Word) : string;
    function LookupService(const Service : AnsiString) : Integer;
    { Socket methods }
    function AcceptSocket(Socket : TSocket; var Address : TSockAddrIn) : TSocket;
    function BindSocket(Socket : TSocket; Address : TSockAddrIn) : Integer;
    function CanReadSocket(Socket : TSocket; WaitTime : Integer) : Boolean;
    function CanWriteSocket(Socket : TSocket; WaitTime : Integer) : Boolean;
    function CloseSocket(Socket : TSocket) : Integer;
    function ConnectSocket(Socket : TSocket; Address : TSockAddrIn) : Integer;
    function CreateSocket : TSocket;
    function ListenSocket(Socket : TSocket; Backlog : Integer) : Integer;
    function ReadSocket(Socket : TSocket; var Buf; BufSize, Flags : Integer) : Integer;
    function ShutdownSocket(Socket : TSocket; How : Integer) : Integer;
    function SetSocketOptions(Socket : TSocket; Level : Cardinal; OptName : Integer;
             var OptVal; OptLen : Integer): Integer;
    function SetAsyncStyles(Socket : TSocket; lEvent : Integer) : Integer;
    function WriteSocket(Socket : TSocket; var Buf; BufSize, Flags : Integer) : Integer;
    { Properties }
    property Description : string read GetDescription;
    property Handle : HWnd read GetHandle;
    property HighVersion : Word read asWSData.wHighVersion;
    property LastError : Integer read GetLastError;
    property LocalHost : string read GetLocalHost;
    property LocalAddress : string read GetLocalAddress;
    property MaxSockets : Word read asWSData.iMaxSockets;
    property SystemStatus : string read GetSystemStatus;
    property WsVersion : Word read asWSData.wVersion;
    { Events }
    property OnWsAccept : TWsNotifyEvent read FOnWsAccept write FOnWsAccept;
    property OnWsConnect : TWsNotifyEvent read FOnWsConnect write FOnWsConnect;
    property OnWsDisconnect : TWsNotifyEvent read FOnWsDisconnect write FOnWsDisconnect;
    property OnWsError : TWsSocketErrorEvent read FOnWsError write FOnWsError;
    property OnWsRead : TWsNotifyEvent read FOnWsRead write FOnWsRead;
    property OnWsWrite : TWsNotifyEvent read FOnWsWrite write FOnWsWrite;
  end;

implementation

uses
  AnsiStrings, AdExcept;

{ - Winsock exception stuff }
constructor EApdSocketException.CreateNoInit(ErrCode : Integer; Dummy : PChar);
begin
  ErrorCode := ErrCode;
  inherited CreateFmt(AproLoadStr(ADWSNOTINIT), [AproLoadStr(ErrCode)]);
end;

constructor EApdSocketException.CreateTranslate(ErrCode, Dummy1, Dummy2 : Integer);
begin
  ErrorCode := ErrCode;
  inherited Create(AproLoadStr(ErrorCode));
end;

{ -Creates the TApdSocket instance }
constructor TApdSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { Load the Winsock DLL and initialize function pointers }
  asDllLoaded := LoadWinsock;
  if not asDllLoaded then begin
    { Be nice to the COMPLIB - an exception would not be good here }
    ShowErrorMessage(ADWSLOADERROR);
    asStartErrorCode := ADWSLOADERROR;
    Exit;
  end;
  { Start Winsock }
  asStartErrorCode := SockFuncs.WSAStartup(SOCK_VERSION, asWSData);
  if asStartErrorCode <> 0 then begin
    ShowErrorMessage(asStartErrorCode);
    Exit;
  end;
  { Verify version }
  if (HiByte(asWSData.wVersion) <> HiByte(SOCK_VERSION)) or
    (LoByte(asWSData.wVersion) <> LoByte(SOCK_VERSION)) then begin
      asStartErrorCode := ADWSVERSIONERROR;
      ShowErrorMessage(asStartErrorCode);
    end;
  FHandle := AllocateHWnd(WndProc);                                
end;

{ -Destroys the TApdSocket instance }
destructor TApdSocket.Destroy;
begin
  if asDllLoaded then begin
    with SockFuncs do begin
      { Cancel blocking calls if we had any }
      WSACancelBlockingCall;
      { Shut down Winsock }
      WSACleanup;
    end;
  end;
  if FHandle <> 0 then DeallocateHWnd(FHandle);
  inherited Destroy;
end;

{ -Gets the info in the Description field of WSAData }
function TApdSocket.GetDescription : string;
begin
  Result := string(asWSData.szDescription);
end;

{ -Creates window handle for class }
function TApdSocket.GetHandle : HWnd;
begin
  Result := FHandle;
end;

{ -Gets the last Winsock error }
function TApdSocket.GetLastError : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.WSAGetLastError;
end;

{ -Gets the name of the local host machine }
function TApdSocket.GetLocalHost : string; // --sm how GetLocalHost is called - none
var
  HostStr : array[0..255] of AnsiChar;      // --sm AnsiString? (sz: yes)
begin
  Result := '';
  CheckLoaded;
  if SockFuncs.GetHostName(@HostStr, SizeOf(HostStr)) = 0 then begin   // --sm GetHostName
    Result := string(HostStr);
  end;
end;

{ -Gets the address of the local host machine }
function TApdSocket.GetLocalAddress : string;
var
  HostStr : array[0..255] of AnsiChar;
  HostEnt : PHostEnt;
begin
  Result := '';
  CheckLoaded;
  if SockFuncs.GetHostName(@HostStr, SizeOf(HostStr)) = 0 then begin
    HostEnt := SockFuncs.GetHostByName(@HostStr);
    if Assigned(HostEnt) then
      Result := NetAddr2String (HostEnt.h_addr_list[0]^);
  end;
end;

{ -Gets the info in the SystemStatus field of WSAData }
function TApdSocket.GetSystemStatus : string;
begin
  Result := string(asWSData.szSystemStatus);
end;

{ -Message handler for Winsock messages }
procedure TApdSocket.CMAPDSocketMessage(var Message: TCMAPDSocketMessage);
begin
  with Message do begin
    if SelectError = 0 then begin
      case SelectEvent of
        FD_CONNECT : DoConnect(Socket);
        FD_CLOSE   : DoDisconnect(Socket);
        FD_READ    : DoRead(Socket);
        FD_WRITE   : DoWrite(Socket);
        FD_ACCEPT  : DoAccept(Socket);
      end;
    end else begin
      DoError(Socket, SelectError);
    end;
  end;
end;

{ -Default handler (intentionally empty) }
procedure TApdSocket.DefaultHandler(var Message);
begin
end;

{ -WndProc to be used by the window handle }
procedure TApdSocket.WndProc(var Message: TMessage);
begin
  try
    Dispatch(Message);
    if Message.Msg = WM_QUERYENDSESSION then
      Message.Result := 1;
  except
    Application.HandleException(Self);
  end;
end;

{ -Shows error message in a non-exception manner }
procedure TApdSocket.ShowErrorMessage(Err : Integer);
begin
  { This is an opportunity to detect and handle Winsock load problems }
  { before the point where an exception might be raised }
end;

procedure TApdSocket.DoAccept(Socket : TSocket);
begin
  if Assigned(FOnWsAccept) then FOnWsAccept(Self, Socket);
end;

procedure TApdSocket.DoConnect(Socket : TSocket);
begin
  if Assigned(FOnWsConnect) then FOnWsConnect(Self, Socket);
end;

procedure TApdSocket.DoDisconnect(Socket : TSocket);
begin
  if Assigned(FOnWsDisconnect) then FOnWsDisconnect(Self, Socket);
end;

procedure TApdSocket.DoRead(Socket : TSocket);
begin
  if Assigned(FOnWsRead) then FOnWsRead(Self, Socket);
end;

procedure TApdSocket.DoError(Socket : TSocket; ErrCode : Integer);
begin
  if Assigned(FOnWsError) then
    FOnWsError(Self, Socket, ErrCode)
  else
    raise EApdSocketException.CreateTranslate(ErrCode, 0, 0);
end;

procedure TApdSocket.DoWrite(Socket : TSocket);
begin
  if Assigned(FOnWsWrite) then FOnWsWrite(Self, Socket);
end;

{ -Checks the status of the DLL and Winsock }
procedure TApdSocket.CheckLoaded;
begin
  if asStartErrorCode <> 0 then
    raise EApdSocketException.CreateNoInit(asStartErrorCode, nil);
end;

{ Conversion routines }

{ -Converts Integer from Intel to Internet byte order }
function TApdSocket.htonl(HostLong : Integer) : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.htonl(HostLong);
end;

{ -Converts Word from Intel to Internet byte order }
function TApdSocket.htons(HostShort : Word) : Word;
begin
  CheckLoaded;
  Result := SockFuncs.htons(HostShort);
end;

{ -Converts Integer from Internet to Intel byte order }
function TApdSocket.ntohl(NetLong : Integer) : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.ntohl(NetLong);
end;

{ -Converts Word from Internet to Intel byte order }
function TApdSocket.ntohs(NetShort : Word) : Word;
begin
  CheckLoaded;
  Result := SockFuncs.ntohs(NetShort);
end;

{ -Converts TInAddr to a XXX.XXX.XXX.XXX string }
function TApdSocket.NetAddr2String(InAddr : TInAddr) : string;
var
  TempStr : array[0..IPStrSize] of AnsiChar;
begin
  Result := '';
  CheckLoaded;
  AnsiStrings.StrCopy(TempStr, @SockFuncs.INet_NtoA(InAddr)^);
  Result := string(TempStr);
end;

{ -Converts XXX.XXX.XXX.XXX string to a TInAddr }
function TApdSocket.String2NetAddr(const S : string) : TInAddr;
var
  TempStr : array[0..IPStrSize] of AnsiChar;
begin
  FillChar(Result, SizeOf(Result), #0);
  CheckLoaded;
  AnsiStrings.StrPLCopy(TempStr, AnsiString(S), IPStrSize);
  Result.S_addr := SockFuncs.INet_Addr(@TempStr);
end;

{ Lookup functions }

{ -Returns a name for an IP address }
function TApdSocket.LookupAddress(InAddr : TInAddr) : string;
var
  HostEnt : PHostEnt;
  TempStr : array[0..255] of AnsiChar;
begin
  Result := '';
  CheckLoaded;
  HostEnt := SockFuncs.GetHostByAddr(InAddr, SizeOf(InAddr), PF_INET);
  if Assigned(HostEnt) then
    Result := string(AnsiStrings.StrCopy(TempStr, @HostEnt^.h_name^));
end;

{ -Returns an IP address for a name }
function TApdSocket.LookupName(const Name : AnsiString) : TInAddr;
var
  HostEnt : PHostEnt;
begin
  FillChar(Result, SizeOf(Result), #0);
  CheckLoaded;
  HostEnt := SockFuncs.GetHostByName(PAnsiChar(Name));
  if Assigned(HostEnt) then
    Result.S_addr := HostEnt.h_addr_list[0].S_addr;
end;

{ -Returns a service name for a port }
function TApdSocket.LookupPort(Port : Word) : string;
var
  ServEnt : PServEnt;
begin
  Result := '';
  CheckLoaded;
  ServEnt := SockFuncs.GetServByPort(htons(Port), nil);
  if Assigned(ServEnt) then
    Result := string(ServEnt^.s_name);
end;

{ -Returns a port for a service name }
function TApdSocket.LookupService(const Service : AnsiString) : Integer;
var
  ServEnt : PServEnt;
begin
  Result := 0;
  CheckLoaded;
  ServEnt := SockFuncs.GetServByName(PAnsiChar(Service), 'tcp');
  if Assigned(ServEnt) then
    Result := ntohs(ServEnt^.s_port)
end;

{ -Accepts a socket connection }
function TApdSocket.AcceptSocket(Socket : TSocket; var Address : TSockAddrIn) : TSocket;
var
  Len  : Integer;
begin
  CheckLoaded;
  Len := Sizeof(TSockAddrIn);
  Result := SockFuncs.Accept(Socket, Address, Len);
  if Result = SOCKET_ERROR then DoError(Socket, SockFuncs.WSAGetLastError);
end;

{ -Binds a socket }
function TApdSocket.BindSocket(Socket : TSocket; Address : TSockAddrIn) : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.Bind(Socket, Address, Sizeof(TSockAddrIn));
  if Result = SOCKET_ERROR then DoError(Socket, SockFuncs.WSAGetLastError);
end;

{ -Closes a socket }
function TApdSocket.CloseSocket(Socket : TSocket) : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.CloseSocket(Socket);
  if Result = SOCKET_ERROR then DoError(Socket, SockFuncs.WSAGetLastError);
end;

{ -Connects to a socket }
function TApdSocket.ConnectSocket(Socket : TSocket; Address : TSockAddrIn) : Integer;
var
  ErrCode : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.Connect(Socket, Address, Sizeof(TSockAddrIn));
  if Result = SOCKET_ERROR then begin
    ErrCode := SockFuncs.WSAGetLastError;
    if ErrCode <> WSAEWOULDBLOCK then DoError(Socket, ErrCode);
  end;
end;

{ -Creates a socket }
function TApdSocket.CreateSocket : TSocket;
begin
  CheckLoaded;
  Result := SockFuncs.Socket(AF_INET, SOCK_STREAM, 0);
  if Result = SOCKET_ERROR then
    raise EApdSocketException.CreateTranslate(SockFuncs.WSAGetLastError, 0, 0);
end;

{ -Listens to a socket }
function TApdSocket.ListenSocket(Socket : TSocket; Backlog : Integer) : Integer;
var
  ErrCode : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.Listen(Socket, Backlog);
  if Result = SOCKET_ERROR then begin
    ErrCode := SockFuncs.WSAGetLastError;
    if ErrCode <> WSAEWOULDBLOCK then DoError(Socket, ErrCode);
  end;
end;

{ -Reads from a socket }
function TApdSocket.ReadSocket(Socket : TSocket; var Buf; BufSize, Flags : Integer) : Integer;
var
  ErrCode : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.Recv(Socket, Buf, BufSize, Flags);
  if Result = SOCKET_ERROR then begin
    ErrCode := SockFuncs.WSAGetLastError;
    if ErrCode <> WSAEWOULDBLOCK then DoError(Socket, ErrCode);
  end;
end;

{ -Wait until socket has data to read or timeout (milliseconds)}
function TApdSocket.CanReadSocket(Socket : TSocket;
                                  WaitTime : Integer) : Boolean;
var
  RFDS    : TFDSet;
  Timeout : TTimeVal;
begin
  CheckLoaded;
  RFDS.fd_count := 1;
  RFDS.fd_array[0] := Socket;
  Timeout.tv_sec := WaitTime div 1000;
  Timeout.tv_usec := (WaitTime mod 1000) * 1000;
  Result := SockFuncs.Select(0, @RFDS, nil, nil, @Timeout) > 0;
end;

{ -Wait until socket can be written to or timeout (milliseconds)}
function TApdSocket.CanWriteSocket(Socket : TSocket;
                                   WaitTime : Integer) : Boolean;
var
  WFDS    : TFDSet;
  Timeout : TTimeVal;
begin
  CheckLoaded;
  WFDS.fd_count := 1;
  WFDS.fd_array[0] := Socket;
  Timeout.tv_sec := WaitTime div 1000;
  Timeout.tv_usec := (WaitTime mod 1000) * 1000;
  Result := SockFuncs.Select(0, nil, @WFDS, nil, @Timeout) > 0;
end;

{ -Shuts the socket down -- does not close the socket }
function TApdSocket.ShutdownSocket(Socket : TSocket; How : Integer) : Integer;
var
  ErrCode : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.Shutdown(Socket, How);
  if Result = SOCKET_ERROR then begin
    ErrCode := SockFuncs.WSAGetLastError;
    if ErrCode <> WSAEWOULDBLOCK then DoError(Socket, ErrCode);
  end;
end;

{ -Sets the Async Styles of a Socket }
function TApdSocket.SetAsyncStyles(Socket : TSocket; lEvent : Integer) : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.WSAAsyncSelect(Socket, Handle, CM_APDSOCKETMESSAGE, lEvent);
  if Result = SOCKET_ERROR then DoError(Socket, SockFuncs.WSAGetLastError);
end;

{ -Sets socket options }
function TApdSocket.SetSocketOptions(Socket : TSocket; Level : Cardinal; OptName : Integer;
  var OptVal; OptLen : Integer): Integer;
begin
  CheckLoaded;
  Result := SockFuncs.SetSockOpt(Socket, Level, OptName, OptVal, OptLen);
  if Result = SOCKET_ERROR then DoError(Socket, SockFuncs.WSAGetLastError);
end;

{ -Writes to a socket }
function TApdSocket.WriteSocket(Socket : TSocket; var Buf; BufSize, Flags : Integer) : Integer;
var
  ErrCode : Integer;
begin
  CheckLoaded;
  Result := SockFuncs.Send(Socket, Buf, BufSize, Flags);
  if Result = SOCKET_ERROR then begin
    ErrCode := SockFuncs.WSAGetLastError;
    if ErrCode <> WSAEWOULDBLOCK then DoError(Socket, ErrCode);
  end;
end;


end.
