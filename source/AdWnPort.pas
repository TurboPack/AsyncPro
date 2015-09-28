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
{*                   ADWNPORT.PAS 4.06                   *}
{*********************************************************}
{* TApdWinsockPort component                             *}
{*********************************************************}

{
  Implements the TApdWinsockPort component, actual Winsock dispatcher
  is in AwWnSock.pas.  Unlike the serial port device layer (dlWin32),
  Winsock is not multi-threaded.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}
{$A4}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdWnPort;
  { -Winsock comport component }

interface

uses
  {-----RTL}
  Messages,
  SysUtils,
  Classes,
  Forms,
  Windows,
  OoMisc,
  AwUser,
  AwWnSock,
  AdSocket,
  AdWUtil,
  AdExcept,
  AdPort,
  AdPacket;

const
  adwDefWsMode = WsClient;
  adwDefWsPort = 'telnet';
  adwDefWsTelnet = True;

type

  { moved to OOMisc to prevent type conflicts }                          {!!.06}
  {PInAddr = ^TInAddr;
  TInAddr = packed record
    case Integer of
      0 : (S_un_b : SunB);
      1 : (S_un_w : SunW);
      2 : (S_addr : Integer);
  end;}

  TApdSocksVersion = (svNone, svSocks4, svSocks4a, svSocks5);

  TApdSocksServerInfo = class (TPersistent)
    private
      FAddress      : string;
      FPassword     : string;
      FPort         : Word;
      FSocksVersion : TApdSocksVersion;
      FUserCode     : string;
      
    protected
      procedure SetAddress (v : string);
      procedure SetPassword (v : string);
      procedure SetPort (v : Word);
      procedure SetSocksVersion (v : TApdSocksVersion);
      procedure SetUserCode (v : string);
      
    public
      constructor Create; 
      
    published
      property Address : string read FAddress write SetAddress;
      property Password : string read FPassword write SetPassword;
      property Port : Word read FPort write SetPort;
      property SocksVersion : TApdSocksVersion
               read FSocksVersion write SetSocksVersion default svNone;
      property UserCode : string read FUserCode write SetUserCode;
  end;

  TWsAcceptEvent = procedure(Sender : TObject; Addr : TInAddr;
                             var Accept : Boolean) of object;
  TWsErrorEvent = procedure(Sender : TObject; ErrCode : Integer) of object;


  {Custom Port component}
  TApdCustomWinsockPort = class(TApdCustomComPort)
  protected {private}
    { Property Support }
    FOnWsAccept : TWsAcceptEvent;
    FOnWsConnect : TNotifyEvent;
    FOnWsDisconnect : TNotifyEvent;
    FOnWsError : TWsErrorEvent;
    FWsAddress : string;
    FWsMode : TWsMode;
    FWsPort : string;
    FWsTelnet : Boolean;
    FSockInstance : TFarProc;
    FComWindowProc : Pointer;
    FWsLocalAddresses : TStringList;
    FWsLocalAddressIndex : Integer;
    FWsSocksServerInfo : TApdSocksServerInfo;
    FConnectPacket : TApdDataPacket;
    FSocksComplete : Boolean;
    FTimer : Integer;
    FConnectFired : Boolean;                                             {!!.05}
  protected
    function ActivateDeviceLayer : TApdBaseDispatcher; override;
    procedure DeviceLayerChanged; override;
    function  DoAccept(Addr : Integer) : Boolean; virtual;
    procedure DoConnect; virtual;
    procedure DoDisconnect; virtual;
    procedure DoError(ErrCode : Integer); virtual;
    procedure EnumHostAddresses;
    function  InitializePort : Integer; override;
    procedure PortOpen; override;
    procedure PortClose; override;
    procedure ValidateComport; override;
    procedure SetUseMSRShadow(NewUse : Boolean); override;
    procedure SetWsAddress(Value : string);
    procedure SetWsLocalAddresses (Value : TStringList);
    function GetWsLocalAddresses: TStringList;                           {!!.04}
    procedure SetWsLocalAddressIndex (Value : Integer);
    procedure SetWsMode(Value : TWsMode);
    procedure SetWsPort(Value : string);
    procedure SockWndProc(var Message : TMessage);
    function OpenSocksConnection : Integer;
    function OpenSocksSocket : Integer;
    procedure ContinueSocksNegotiation;
    procedure ConnectToSocks4;
    procedure ConnectToSocks4a;
    procedure ConnectToSocks5;
    procedure EnableSocks4Reply;
    procedure EnableSocks5Reply;
    procedure EnableSocks5UserNameReply;
    procedure EnableSocks5RequestReply;
    procedure EnableSocks5RequestEndReply (Len : Integer);
    procedure SendSocks5UserName;
    procedure SendSocks5Request;
    procedure Socks4Packet (Sender : TObject; Data : Pointer; Size : Integer);
    procedure Socks5Packet (Sender : TObject; Data : Pointer; Size : Integer);
    procedure Socks5UserNamePacket (Sender : TObject; Data : Pointer;
                                    Size : Integer);
    procedure Socks5RequestPacket (Sender : TObject; Data : Pointer;
                                   Size : Integer);
    procedure Socks5RequestEndPacket (Sender : TObject; Data : Pointer;
                                      Size : Integer);

  public
    property WsAddress : string read FWsAddress write SetWsAddress;
    property WsLocalAddresses : TStringList
             read GetWsLocalAddresses write SetWsLocalAddresses;         {!!.04}
    property WsLocalAddressIndex : Integer
             read FWsLocalAddressIndex write SetWsLocalAddressIndex;
    property WsMode : TWsMode read FWsMode write SetWsMode default adwDefWsMode;
    property WsPort : string read FWsPort write SetWsPort;
    property WsSocksServerInfo : TApdSocksServerInfo
             read FWsSocksServerInfo write FWsSocksServerInfo;
    property WsTelnet : Boolean read FWsTelnet write FWsTelnet default adwDefWsTelnet;

    property OnWsAccept : TWsAcceptEvent read FOnWsAccept write FOnWsAccept;
    property OnWsConnect : TNotifyEvent read FOnWsConnect write FOnWsConnect;
    property OnWsDisconnect : TNotifyEvent read FOnWsDisconnect write FOnWsDisconnect;
    property OnWsError : TWsErrorEvent read FOnWsError write FOnWsError;

    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  end;


  {Port component}
  TApdWinsockPort = class(TApdCustomWinsockPort)
  published
    { Properties }
    property WsAddress;
    property WsLocalAddresses;
    property WsLocalAddressIndex;
    property WsMode;
    property WsPort;
    property WsSocksServerInfo;
    property WsTelnet;

    { Inherited Properties }
    property AutoOpen;
    property Baud;
    property BufferFull;
    property BufferResume;
    property CommNotificationLevel;
    property ComNumber;
    property DataBits;
    property DeviceLayer;
    property DTR;
    property HWFlowOptions;
    property InSize;
    property RS485Mode;
    property TraceAllHex;                                                {!!.04}                                           
    property Tracing;
    property TraceSize;
    property TraceName;
    property TraceHex;
    property LogAllHex;                                                  {!!.04}
    property Logging;
    property LogSize;
    property LogName;
    property LogHex;
    property Open;
    property OutSize;
    property Parity;
    property PromptForPort;                                              {!!.04}
    property RTS;
    property StopBits;
    property SWFlowOptions;
    property Tag;
    property TapiMode;
    property UseEventWord;
    property UseMSRShadow;
    property XOffChar;
    property XOnChar;

    { Events }
    property OnWsAccept;
    property OnWsConnect;
    property OnWsDisconnect;
    property OnWsError;
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
    property OnWaitChar;
  end;


implementation

uses
  AnsiStrings;

constructor TApdSocksServerInfo.Create;
begin
  inherited Create;

  FSocksVersion := svNone;
end;

procedure TApdSocksServerInfo.SetAddress (v : string);
begin
  if v <> FAddress then
    FAddress := v;
end;

procedure TApdSocksServerInfo.SetPassword (v : string);
begin
  if v <> FPassword then
    FPassword := v;
end;

procedure TApdSocksServerInfo.SetPort (v : Word);
begin
  if v <> FPort then
    FPort := v;
end;

procedure TApdSocksServerInfo.SetSocksVersion (v : TApdSocksVersion);
begin
  if v <> FSocksVersion then
    FSocksVersion := v;
end;

procedure TApdSocksServerInfo.SetUserCode (v : string);
begin
  if v <> FUserCode then
    FUserCode := v;
end;

constructor TApdCustomWinsockPort.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FDeviceLayers := FDeviceLayers + [dlWinsock];
  FWsPort := adwDefWsPort;
  FWsTelnet := adwDefWsTelnet;
  FConnectFired := False;                                                {!!.05}
  FWsSocksServerInfo := TApdSocksServerInfo.Create;

  FWsLocalAddresses := TStringList.Create;
  EnumHostAddresses;
end;

destructor TApdCustomWinsockPort.Destroy;
begin
  if (Assigned(FSockInstance)) then                                         // SWB
    FreeObjectInstance(FSockInstance);                                      // SWB
  FWsLocalAddresses.Free;
  FWsSocksServerInfo.Free;

  inherited Destroy;
end;

function TApdCustomWinsockPort.ActivateDeviceLayer : TApdBaseDispatcher;
begin
  if DeviceLayer = dlWinsock then
    Result := TApdWinSockDispatcher.Create(Self)
  else
    Result := inherited ActivateDeviceLayer;
end;                   

procedure TApdCustomWinsockPort.DeviceLayerChanged;
begin
  if DeviceLayer = dlWinsock then begin
    TapiMode := tmOff;
    FUseMSRShadow := False;
  end else
    TapiMode := tmAuto;
end;

function TApdCustomWinsockPort.DoAccept(Addr : Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnWsAccept) then FOnWsAccept(Self, TInAddr(Addr), Result);
end;

procedure TApdCustomWinsockPort.DoConnect;
begin
  FConnectFired := True;                                                 {!!.05}
  if Assigned(FOnWsConnect) then FOnWsConnect(Self);
end;

procedure TApdCustomWinsockPort.DoDisconnect;
begin
  if (FConnectFired or (FWsMode = WsServer))and Assigned(FOnWsDisconnect){!!.06}
    then FOnWsDisconnect(Self);
  FConnectFired := False;                                                {!!.05}
end;

procedure TApdCustomWinsockPort.DoError(ErrCode : Integer);
begin
  {if (ErrCode >= 10052) and (ErrCode <= 10054) then}                    {!!.05}
  case ErrCode of                                                        {!!.05}
    10052,     {wsaENetReset}                                            {!!.05}
    10053,     {wsaEConnAborted}                                         {!!.05}
    10054,     {wsaEConnReset}                                           {!!.05}
    10061:     {wsaEConnRefused}                                         {!!.05}
      if (FWsMode = WsClient) then begin
        PostMessage(ComWindow, CM_APDSOCKETQUIT, 0, 0);
      end else
        DoDisconnect;
  end;
  if Assigned(FOnWsError) then FOnWsError(Self, ErrCode);
end;

procedure TApdCustomWinsockPort.EnumHostAddresses;
const
  MaxAddrs = 256;

var
  HostStr : array[0..255] of AnsiChar;
  HostEnt : PHostEnt;
  i       : Integer;
  
begin
  FWsLocalAddresses.Clear;
  if SockFuncs.GetHostName (@HostStr, SizeOf (HostStr)) = 0 then begin
    HostEnt := SockFuncs.GetHostByName (@HostStr);
    if assigned (HostEnt) then
      for i := 0 to MaxAddrs - 1 do
        if (HostEnt.h_addr_list[i] = nil) then
          break
        else
          FWsLocalAddresses.Add (Format ('%d.%d.%d.%d',
                  [Integer (HostEnt.h_addr_list[i].S_un_b.s_b1),
                   Integer (HostEnt.h_addr_list[i].S_un_b.s_b2),
                   Integer (HostEnt.h_addr_list[i].S_un_b.s_b3),
                   Integer (HostEnt.h_addr_list[i].S_un_b.s_b4)]));
  end;
end;

function TApdCustomWinsockPort.InitializePort : Integer;
var
  TempAddress : DWORD;
  ErrCode : Integer;
  TempPort : Word;
begin
  if DeviceLayer = dlWinsock then begin
    { Convert or lookup the address }
    if FWsMode = WsClient then begin
      FDispatcher.DeviceName := format(                                  {!!.06}
        'Winsock client, connect to %s on port %s', [WsAddress, WsPort]);{!!.06}
      if FWsAddress = '' then
        raise EApdSocketException.CreateTranslate(WSAEDESTADDRREQ, 0, 0);
      { Handle SOCKS negotiation if needed }
      if WsSocksServerInfo.SocksVersion <> svNone then begin
        Result := OpenSocksConnection;
        Exit;
      end;
      TempAddress := (ApdSocket.String2NetAddr(FWsAddress).S_addr);
      if TempAddress = INADDR_NONE then
        TempAddress := (ApdSocket.LookupName(AnsiString(FWsAddress)).S_addr);
      if TempAddress = 0 then
        if Assigned(FOnWsError) then begin
          OnWsError(Self, ADWSCANTRESOLVE);
          Result := -ADWSCANTRESOLVE;
          Exit;
        end else
          raise EApdSocketException.CreateTranslate(ADWSCANTRESOLVE, 0, 0);
    end else begin
      TempAddress := INADDR_ANY;
      FDispatcher.DeviceName := format(                                  {!!.06}
        'Winsock server on port %s', [WsPort]);                          {!!.06}
    end;

    { Convert or lookup the port }
    Val(FWsPort, TempPort, ErrCode);
    if ErrCode <> 0 then
      TempPort := ApdSocket.LookupService(AnsiString(FWsPort));
    if TempPort = 0 then
      raise EApdSocketException.CreateTranslate(ADWSINVPORT, 0, 0);
    TempPort := ApdSocket.htons(TempPort);

    { Init the socket }

    TApdWinSockDispatcher(Dispatcher).InitSocketData(WsLocalAddressIndex,
                          TempAddress, TempPort,
                         (FWsMode = WsClient), FWsTelnet);
    Result := Dispatcher.InitSocket(FInSize, FOutSize);
    if Result < 0 then
      raise EApdSocketException.CreateTranslate(-Result, 0, 0);
    PortState := psOpen;                                             
  end else
    Result := inherited InitializePort;
end;

{ This is our access to the Comport window }
procedure TApdCustomWinsockPort.SockWndProc(var Message: TMessage);

  procedure Default;
  begin
    with Message do
      Result := CallWindowProc(FComWindowProc, ComWindow, Msg, wParam, lParam);
  end;

begin
  if Message.Msg = CM_APDSOCKETMESSAGE then
    with Message do begin
      case wParam of
        FD_CONNECT : DoConnect;
        FD_CLOSE   : PostMessage(ComWindow, CM_APDSOCKETQUIT, 0, 0);
        FD_ACCEPT  : Result := Integer(DoAccept(LParam));
        FD_CLOSE or FD_CONNECT : DoDisconnect;
      else
        DoError(wParam);
      end;
    end
  else if Message.Msg = CM_APDSOCKETQUIT then
    Open := False
  else Default;
end;

procedure TApdCustomWinsockPort.PortOpen;
begin
  if (Assigned(FSockInstance)) then                                         // SWB
    FreeObjectInstance(FSockInstance);                                      // SWB
  FSockInstance := MakeObjectInstance(SockWndProc);
  FComWindowProc := Pointer(SetWindowLong(ComWindow, GWL_WNDPROC, Integer(FSockInstance)));
  { Perform the SOCKS negotiation }
  if WsSocksServerInfo.SocksVersion <> svNone then
    ContinueSocksNegotiation;
  inherited PortOpen;
end;

procedure TApdCustomWinsockPort.PortClose;
begin
  inherited PortClose;
  DoDisconnect;
end;

procedure TApdCustomWinsockPort.ValidateComport;
begin
  { If we're in Winsock mode, we don't care if it's a valid comport number }
  if DeviceLayer <> dlWinsock then
    inherited ValidateComport;
end;

procedure TApdCustomWinsockPort.SetUseMSRShadow(NewUse : Boolean);
begin
  inherited SetUseMSRShadow(NewUse);
  if DeviceLayer = dlWinsock then
    FUseMSRShadow := False;
end;

procedure TApdCustomWinsockPort.SetWsAddress(Value : string);
begin
  if (Value = FWsAddress) then Exit;
  if (PortState = psOpen) then                                        
    raise EApdSocketException.CreateTranslate(ADWSCANTCHANGE, 0, 0)
  else
    FWsAddress := Trim(Value);
end;

procedure TApdCustomWinsockPort.SetWsLocalAddresses (Value : TStringList);
begin
  FWsLocalAddresses.Assign (Value);
end;

function TApdCustomWinsockPort.GetWsLocalAddresses: TStringList;         {!!.04}
begin                                                                    {!!.04}
  EnumHostAddresses;                                                     {!!.04}
  Result := FWsLocalAddresses;                                           {!!.04}
end;                                                                     {!!.04}

procedure TApdCustomWinsockPort.SetWsLocalAddressIndex (Value : Integer);
begin
  if Value <> FWsLocalAddressIndex then
    FWsLocalAddressIndex := Value;
end;

procedure TApdCustomWinsockPort.SetWsMode(Value : TWsMode);
begin
  if (Value = FWsMode) then Exit;
  if (PortState = psOpen) then                                      
    raise EApdSocketException.CreateTranslate(ADWSCANTCHANGE, 0, 0)
  else
    FWsMode := Value;
end;

procedure TApdCustomWinsockPort.SetWsPort(Value : string);
begin
  if (Value = FWsPort) then Exit;
  if (PortState = psOpen) then
    raise EApdSocketException.CreateTranslate(ADWSCANTCHANGE, 0, 0)
  else
    FWsPort := Trim(Value);
end;

function TApdCustomWinsockPort.OpenSocksConnection : Integer;
{ Create the Socks reply data packet and open the socket }
begin
  { Set up the data packet }
  FConnectPacket := TApdDataPacket.Create (Self);
  FConnectPacket.Enabled := False;
  FConnectPacket.ComPort := Self;
  FConnectPacket.StartCond := scAnyData;
  FConnectPacket.Timeout := 0;
  FConnectPacket.AutoEnable := False;
  { Open the socket }
  Result := OpenSocksSocket;
end;

function TApdCustomWinsockPort.OpenSocksSocket : Integer;
{ Open a socket for SOCKS negotiation }
var
  TempAddress : DWORD;
  TempPort    : Word;

begin
  { Convert or lookup the address }
  TempAddress := (ApdSocket.String2NetAddr (WsSocksServerInfo.Address).S_addr);
  if TempAddress = INADDR_NONE then
    TempAddress := (ApdSocket.LookupName (AnsiString(WsSocksServerInfo.Address)).S_addr);
  if TempAddress = 0 then begin
    FSocksComplete := True;
    if Assigned (FOnWsError) then begin
      Result := -ADWSCANTRESOLVE;
      OnWsError (Self, ADWSCANTRESOLVE);
      Exit;
    end else
      raise EApdSocketException.CreateTranslate(ADWSCANTRESOLVE, 0, 0);
  end;

  { Convert or lookup the port }
  TempPort := ApdSocket.htons (WsSocksServerInfo.Port);

  { Init the socket }

  TApdWinSockDispatcher (Dispatcher).InitSocketData (WsLocalAddressIndex,
                          TempAddress, TempPort,
                         (FWsMode = WsClient), FWsTelnet);
  Result := Dispatcher.InitSocket (FInSize, FOutSize);
  if Result < 0 then begin
    FSocksComplete := True;
    if Assigned (FOnWsError) then begin
      Result := -ADWSCANTRESOLVE;
      OnWsError (Self, ADWSCANTRESOLVE);
      Exit;
    end else
      raise EApdSocketException.CreateTranslate (-Result, 0, 0);
  end;
  PortState := psOpen;
end;

procedure TApdCustomWinsockPort.ContinueSocksNegotiation;
{ Actually perform the SOCKS negotiation }
begin
  try
    { Perform SOCKS negotiation based upon the socks version }
    case WsSocksServerInfo.SocksVersion of
      svNone    : Exit;
      svSocks4  : ConnectToSocks4;
      svSocks4a : ConnectToSocks4a;
      svSocks5  : ConnectToSocks5;
    end;
    { Wait for the negotiation to complete }
    while FSocksComplete = False do 
      DelayTicks (1, True);
  finally
    { release SOCKS reply data packet }
    FConnectPacket.Free;
  end;
end;

procedure TApdCustomWinsockPort.ConnectToSocks4;
{ Sends a Socks 4 request }
var
  TempAddress : DWORD;
  ErrCode     : Integer;
  TempPort    : Word;

begin
  EnableSocks4Reply;
  { Convert or lookup the port }
  Val (FWsPort, TempPort, ErrCode);
  if ErrCode <> 0 then
    TempPort := ApdSocket.LookupService (AnsiString(FWsPort));
  if TempPort = 0 then
    raise EApdSocketException.CreateTranslate (ADWSINVPORT, 0, 0);
  TempPort := ApdSocket.htons (TempPort);

  { Convert or lookup the IP address }
  if FWsAddress = '' then
    raise EApdSocketException.CreateTranslate (WSAEDESTADDRREQ, 0, 0);
  TempAddress := (ApdSocket.String2NetAddr (FWsAddress).S_addr);
  if TempAddress = INADDR_NONE then
    TempAddress := (ApdSocket.LookupName (AnsiString(FWsAddress)).S_addr);
  if TempAddress = 0 then
    if Assigned (FOnWsError) then begin
      OnWsError (Self, ADWSCANTRESOLVE);
      Exit;
    end else
      raise EApdSocketException.CreateTranslate (ADWSCANTRESOLVE, 0, 0);

  { Send the SOCKS 4 request }
  PutChar (#$04); { VN - Version Number }
  PutChar (#$01); { CD - Command Code - 1 }

  PutChar (AnsiChar (TempPort and $00ff)); { DSTPORT - Destination Port }
  PutChar (AnsiChar ((TempPort and $ff00) shr 8));

  PutChar (AnsiChar (TempAddress and $000000ff)); { DSTID - Dest IP }
  PutChar (AnsiChar ((TempAddress and $0000ff00) shr 8));
  PutChar (AnsiChar ((TempAddress and $00ff0000) shr 16));
  PutChar (AnsiChar ((TempAddress and $ff000000) shr 24));

  Output := AnsiString(WsSocksServerInfo.UserCode); { USERID - User ID }
  PutChar (#$00);
end;

procedure TApdCustomWinsockPort.ConnectToSocks4a;
{ Sends a socks 4a request }
var
  ErrCode     : Integer;
  TempPort    : Word;

begin
  EnableSocks4Reply;
  { Convert or lookup the port }
  Val (FWsPort, TempPort, ErrCode);
  if ErrCode <> 0 then
    TempPort := ApdSocket.LookupService (AnsiString(FWsPort));
  if TempPort = 0 then
    raise EApdSocketException.CreateTranslate (ADWSINVPORT, 0, 0);
  TempPort := ApdSocket.htons (TempPort);

  { Send the SOCKS 4a request }
  PutChar (#$04); { VN - Version Number }
  PutChar (#$01); { CD - Command Code - 1 }
  PutChar (AnsiChar (TempPort and $00ff)); { DSTPORT - Destination Port }
  PutChar (AnsiChar ((TempPort and $ff00) shr 8));
  PutChar (#$00); { DSTIP - Destination IP - 1 to indicate domain }
  PutChar (#$00);
  PutChar (#$00);
  PutChar (#$01);
  Output := AnsiString(WsSocksServerInfo.UserCode);
  PutChar (#$00);
  Output := AnsiString(Self.WsAddress);
  PutChar (#$00);
end;

procedure TApdCustomWinsockPort.ConnectToSocks5;
{ Sends a socks 5 request }
begin
  EnableSocks5Reply;
  PutChar (#$05); { VN - Version Number }
  PutChar (#$02); { NMETHODS - Number of authentication methods }
  PutChar (#$00); { METHODS - No authentication }
  PutChar (#$02); { METHODS - Username/Password }
end;

procedure TApdCustomWinsockPort.EnableSocks4Reply;
{ Turn on the data packet that receives the reply from a socks 4 and 4a
  request }
begin
  FConnectPacket.Enabled := False;
  FConnectPacket.StartCond := scAnyData;
  FConnectPacket.EndCond := [ecPacketSize];
  FConnectPacket.PacketSize := 8;
  FConnectPacket.OnPacket := Socks4Packet;
  FConnectPacket.Enabled := True;
end;

procedure TApdCustomWinsockPort.EnableSocks5Reply;
{ Turn on the data packet that receives the reply from a socks 5 request }
begin
  FConnectPacket.Enabled := False;
  FConnectPacket.StartCond := scAnyData;
  FConnectPacket.EndCond := [ecPacketSize];
  FConnectPacket.PacketSize := 2;
  FConnectPacket.OnPacket := Socks5Packet;
  FConnectPacket.Enabled := True;
end;

procedure TApdCustomWinsockPort.EnableSocks5UserNameReply;
{ Turns on the data packet that receives the reply from a SOCKS 5 username
  packet }
begin
  FConnectPacket.Enabled := False;
  FConnectPacket.StartCond := scAnyData;
  FConnectPacket.EndCond := [ecPacketSize];
  FConnectPacket.PacketSize := 2;
  FConnectPacket.OnPacket := Socks5UserNamePacket;
  FConnectPacket.Enabled := True;
end;

procedure TApdCustomWinsockPort.EnableSocks5RequestReply;
{ Turns on the data packet that receives the reply from a SOCKS 5 request
  packet }
begin
  FConnectPacket.Enabled := False;
  FConnectPacket.StartCond := scAnyData;
  FConnectPacket.EndCond := [ecPacketSize];
  FConnectPacket.PacketSize := 5;
  FConnectPacket.OnPacket := Socks5RequestPacket;
  FConnectPacket.Enabled := True;
end;

procedure TApdCustomWinsockPort.EnableSocks5RequestEndReply (Len : Integer);
{ Gets the last bit of the SOCKS 5 request packet }
begin
  FConnectPacket.Enabled := False;
  FConnectPacket.StartCond := scAnyData;
  FConnectPacket.EndCond := [ecPacketSize];
  FConnectPacket.PacketSize := Len;
  FConnectPacket.OnPacket := Socks5RequestEndPacket;
  FConnectPacket.Enabled := True;
end;

procedure TApdCustomWinsockPort.SendSocks5UserName;
{ Sends a user name packet to continue the SOCKS5 negotiation }
begin
  EnableSocks5UserNameReply;
  PutChar (#$05); { VER - Version Number }
  PutChar (AnsiChar (Length (WsSocksServerInfo.UserCode))); { ULEN }
  Output := AnsiString(WsSocksServerInfo.UserCode); { UNAME }
  PutChar (AnsiChar (Length (WsSocksServerInfo.Password))); { PLEN }
  Output := AnsiString(WsSocksServerInfo.Password); { PASSWD }
end;

procedure TApdCustomWinsockPort.SendSocks5Request;
{ Sends a request packet to continue the SOCKS 5 negotiation }
var
  TempAddress : DWORD;
  ErrCode     : Integer;
  TempPort    : Word;

begin
  EnableSocks5RequestReply;
  { Convert or lookup the port }
  Val (FWsPort, TempPort, ErrCode);
  if ErrCode <> 0 then
    TempPort := ApdSocket.LookupService (AnsiString(FWsPort));
  if TempPort = 0 then
    raise EApdSocketException.CreateTranslate (ADWSINVPORT, 0, 0);
  TempPort := ApdSocket.htons (TempPort);

  { Convert or lookup the IP address }
  if FWsAddress = '' then
    raise EApdSocketException.CreateTranslate (WSAEDESTADDRREQ, 0, 0);
  TempAddress := (ApdSocket.String2NetAddr (FWsAddress).S_addr);
  if TempAddress = INADDR_NONE then
    TempAddress := (ApdSocket.LookupName (AnsiString(FWsAddress)).S_addr);
  if TempAddress = 0 then
    if Assigned (FOnWsError) then begin
      OnWsError (Self, ADWSCANTRESOLVE);
      Exit;
    end else
      raise EApdSocketException.CreateTranslate (ADWSCANTRESOLVE, 0, 0);

  { Send the Request packet }
  PutChar (#$05); { VER - Version Number }
  PutChar (#$01); { CMD }
  PutChar (#$00); { RSV }
  PutChar (#$01); { ATYP}
  PutChar (AnsiChar (TempAddress and $000000ff)); { DSTID - Dest IP }
  PutChar (AnsiChar ((TempAddress and $0000ff00) shr 8));
  PutChar (AnsiChar ((TempAddress and $00ff0000) shr 16));
  PutChar (AnsiChar ((TempAddress and $ff000000) shr 24));

  PutChar (AnsiChar (TempPort and $00ff)); { DSTPORT - Destination Port }
  PutChar (AnsiChar ((TempPort and $ff00) shr 8));
end;

procedure TApdCustomWinsockPort.Socks4Packet (Sender : TObject; Data : Pointer;
                                              Size : Integer);
{ Handle the socks 4/4a reply }
var
  Buffer : array[0..8] of byte;

begin
  FConnectPacket.Enabled := False;
  FSocksComplete := True;
  Move (Data^, Buffer[0], Size);
  { Interpret the reply }
  case Buffer[1] of
    90 :
      begin
        { All is ok }
      end;
    91 :
      if Assigned (FOnWsError) then 
        OnWsError (Self, ADWSREQUESTFAILED)
      else
        raise EApdSocketException.CreateTranslate (ADWSREQUESTFAILED, 0, 0);
    92 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSREJECTEDIDENTD)
      else
        raise EApdSocketException.CreateTranslate (ADWSREJECTEDIDENTD, 0, 0);
    93 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSREJECTEDUSERID)
      else
        raise EApdSocketException.CreateTranslate (ADWSREJECTEDUSERID, 0, 0);
    else
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSUNKNOWNERROR)
      else
        raise EApdSocketException.CreateTranslate (ADWSUNKNOWNERROR, 0, 0);
  end;
end;

procedure TApdCustomWinsockPort.Socks5Packet (Sender : TObject; Data : Pointer;
                                              Size : Integer);
{ Handle the socks 4/4a reply }
var
  Buffer : array[0..2] of byte;

begin
  FConnectPacket.Enabled := False;
  Move (Data^, Buffer[0], Size);
  { Interpret the reply }
  case Buffer[1] of
    00 : SendSocks5Request; { No user name needed, send the request }
    02 : SendSocks5UserName; { Username/password required - send it }
    else
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSUNKNOWNERROR)
      else
        raise EApdSocketException.CreateTranslate (ADWSUNKNOWNERROR, 0, 0);
  end;
end;

procedure TApdCustomWinsockPort.Socks5UserNamePacket (Sender : TObject;
                                                      Data : Pointer;
                                                      Size : Integer);
{ Receive and interpret the SOCKS 5 Username packet reply }                                                      
var
  Buffer : array[0..2] of byte;

begin
  FConnectPacket.Enabled := False;
  Move (Data^, Buffer[0], Size);
  { Interpret the reply }
  case Buffer[1] of
    00 : SendSocks5Request; { UserName/Password OK - send the request }
    else
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSUNKNOWNERROR)
      else
        raise EApdSocketException.CreateTranslate (ADWSUNKNOWNERROR, 0, 0);
  end;
end;

procedure TApdCustomWinsockPort.Socks5RequestPacket (Sender : TObject;
                                                     Data : Pointer;
                                                     Size : Integer);
{ Get and interpret the first part of the SOCK5 request packet reply }                                                     
var
  Buffer : array[0..5] of byte;
  Len : Integer;

begin
  Move (Data^, Buffer[0], Size);
  { Interpret the reply }
  case Buffer[1] of
    $00 : begin
            { All is OK }
          end;
    $01 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSSOCKSERROR)
      else
        raise EApdSocketException.CreateTranslate (ADWSSOCKSERROR, 0, 0);
    $02 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSCONNECTIONNOTALLOWED)
      else
        raise EApdSocketException.CreateTranslate (ADWSCONNECTIONNOTALLOWED,
                                                   0, 0);
    $03 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSNETWORKUNREACHABLE)
      else
        raise EApdSocketException.CreateTranslate (ADWSNETWORKUNREACHABLE,
                                                   0, 0);
    $04 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSHOSTUNREACHABLE)
      else
        raise EApdSocketException.CreateTranslate (ADWSHOSTUNREACHABLE, 0, 0);
    $05 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSREFUSED)
      else
        raise EApdSocketException.CreateTranslate (ADWSREFUSED, 0, 0);
    $06 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSTTLEXPIRED)
      else
        raise EApdSocketException.CreateTranslate (ADWSTTLEXPIRED, 0, 0);
    $07 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSBADCOMMAND)
      else
        raise EApdSocketException.CreateTranslate (ADWSBADCOMMAND, 0, 0);
    $08 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSBADADDRESSTYPE)
      else
        raise EApdSocketException.CreateTranslate (ADWSBADADDRESSTYPE, 0, 0);
    else
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSUNKNOWNERROR)
      else
        raise EApdSocketException.CreateTranslate (ADWSUNKNOWNERROR, 0, 0);
  end;

  { Get the rest of the request packet - trigger errors for unsupported
    address types }
  Len := 2;
  case Buffer[3] of
    $01 : Len := 5;
    $02 : Len := Byte (Buffer[4]) + 2;
    $03 :
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSUNSUPPORTEDREPLY)
      else
        raise EApdSocketException.CreateTranslate (ADWSUNSUPPORTEDREPLY, 0, 0);
    else
      if Assigned (FOnWsError) then
        OnWsError (Self, ADWSINVALIDREPLY)
      else
        raise EApdSocketException.CreateTranslate (ADWSINVALIDREPLY, 0, 0);
  end;
  
  EnableSocks5RequestEndReply (Len);
end;

procedure TApdCustomWinsockPort.Socks5RequestEndPacket (Sender : TObject;
                                                        Data : Pointer;
                                                        Size : Integer);
{ Get the rest of the SOCKS 5 request packet reply }
begin
  FConnectPacket.Enabled := False;
  FSocksComplete := True;
end;

end.
