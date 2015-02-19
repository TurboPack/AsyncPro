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
{*                    ADFTP.PAS 4.06                     *}
{*********************************************************}
{* TApdFTPClient component                               *}
{*********************************************************}

{
  We descend from a TApdWinsockPort for the control connection,
  and create a TApdSocket for the data connection. We currently
  do not support proxy/firewall, mainly because that is in the
  TApdWinsockPort but not available at the TApdSocket.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+,B-,J+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdFtp;
  {-Delphi internet file transfer protocol (FTP) client component}

interface

uses
  Windows,
  Classes,
  Messages,
  SysUtils,
  Forms,
  OoMisc,
  AwUser,
  AdSocket,
  AdwUtil,
  AdWnPort,
  AdPort,
  AdPacket,
  AdExcept;

const {miscellaneous constants}
  MaxBuffer = 32768;
  MaxCmdStack = 32;

type {Ftp mode and status definitions}
  TFtpRetrieveMode  = (rmAppend, rmReplace, rmRestart);
  TFtpStoreMode     = (smAppend, smReplace, smUnique, smRestart);
  TFtpFileType      = (ftAscii, ftBinary);
  TFtpProcessState  = (psClosed, psLogin, psIdle, psDir, psGet, psPut, psRen,
                       psCmd, psMkDir);
  TFtpStatusCode    = (scClose, scOpen, scLogout, scLogin, scComplete,
                       scCurrentDir, scDataAvail, scProgress, scTransferOK,
                       scTimeout);
  TFtpLogCode       = (lcClose, lcOpen, lcLogout, lcLogin, lcDelete,
                       lcRename, lcReceive, lcStore, lcComplete,
                       lcRestart, lcTimeout, lcUserAbort);

type {Ftp event definitions}
  TFtpErrorEvent  = procedure(Sender : TObject;
                              ErrorCode : Integer;
                              ErrorText : PAnsiChar) of object;
  TFtpLogEvent    = procedure(Sender : TObject;
                              LogCode : TFtpLogCode) of object;
  TFtpReplyEvent  = procedure(Sender : TObject;
                              ReplyCode : Integer;
                              ReplyText : PAnsiChar) of object;
  TFtpStatusEvent = procedure(Sender : TObject;
                              StatusCode : TFtpStatusCode;
                              InfoText : PAnsiChar) of object;

type {forwards}
  TApdFtpLog = class;

  {custom ftp component}
  TApdCustomFtpClient = class(TApdCustomWinsockPort)
  protected {private}
    AbortXfer       : Boolean;
    CmdStack        : array[0..MaxCmdStack-1] of AnsiString;
    CmdsStacked     : Byte;
    DataName        : TSockAddrIn;
    DataSocket      : TSocket;
    hwndFtpEvent    : HWND;
    ReplyPacket     : TApdDataPacket;
    DataBuffer      : array[0..MaxBuffer] of Byte;
    ReplyBuffer     : array[0..MaxBuffer] of AnsiChar;
    ListenSocket    : TSocket;
    ListenName      : TSockAddrIn;
    LocalStream     : TFileStream;
    MultiLine       : Boolean;
    MultiLineTerm   : AnsiString;
    NoEvents        : Boolean;
    ProcessState    : TFtpProcessState;
    Sock            : TApdSocket;
    Timer           : Integer;

  protected {property variables}
    FAccount          : AnsiString;
    FBytesTransferred : Integer;
    FConnectTimeout   : Integer;
    FFileLength       : Integer;
    FFileType         : TFtpFileType;
    FFtpLog           : TApdFtpLog;
    FLocalFile        : AnsiString;
    FPassword         : AnsiString;
    FPassiveMode      : Boolean;
    FTransferTimeout  : Integer;
    FRemoteFile       : AnsiString;
    FRestartAt        : Integer;
    FReplyCode        : Integer;
    FUserLoggedIn     : Boolean;
    FUserName         : AnsiString;

  protected {event variables}
    FOnFtpError        : TFtpErrorEvent;
    FOnFtpStatus       : TFtpStatusEvent;
    FOnFtpConnected    : TNotifyEvent;
    FOnFtpDisconnected : TNotifyEvent;
    FOnFtpLog          : TFtpLogEvent;
    FOnFtpReply        : TFtpReplyEvent;

  protected {methods}
    procedure ChangeState(NewState : TFtpProcessState);
    function  DataConnect : Boolean;
    procedure DataConnectPASV(IP : AnsiString);
    procedure DataDisconnect(FlushBuffer : Boolean);
    procedure DataShutDown;
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    procedure FtpEventHandler(var Msg : TMessage);
    procedure FtpReplyHandler(ReplyCode : Integer; PData : PAnsiChar);
    function  GetConnected : Boolean;
    function  GetData : Integer;
    function  GetInProgress : Boolean;
    procedure Notification(AComponent : TComponent;
                           Operation : TOperation); override;
    function  PopCommand : AnsiString;
    procedure PostError(Code : Integer; Info : PAnsiChar);
    procedure PostLog(Code : TFtpLogCode);
    procedure PostStatus(Code : TFtpStatusCode; Info : PAnsiChar);
    procedure PushCommand(const Cmd : AnsiString);
    function  PutData : Integer;
    procedure ReplyPacketHandler(Sender : TObject; Data : Ansistring);
    procedure ResetTimer;
    procedure SendCommand(const Cmd : AnsiString);
    procedure SetFtpLog(const NewLog : TApdFtpLog);
    procedure StartTimer;
    procedure StopTimer;
    procedure TimerTrigger(Msg, wParam : Cardinal; lParam : Integer);
    procedure WsDataAccept(Sender : TObject; Socket : TSocket);
    procedure WsDataDisconnect(Sender : TObject; Socket : TSocket);
    procedure WsDataError(Sender : TObject; Socket : TSocket; ErrorCode : Integer);
    procedure WsDataRead(Sender : TObject; Socket : TSocket);
    procedure WsDataWrite(Sender : TObject; Socket : TSocket);

  protected {properties}
    property Account  : AnsiString
      read FAccount write FAccount;
    property ConnectTimeout : Integer
      read FConnectTimeout write FConnectTimeout;
    property FileType : TFtpFileType
      read FFileType write FFileType;
    property FtpLog : TApdFtpLog
      read FFtpLog write SetFtpLog;
    property Password : AnsiString
      read FPassword write FPassword;
    property PassiveMode : Boolean
      read FPassiveMode write FPassiveMode;
    property ServerAddress : String
      read FWsAddress write SetWsAddress;
    property TransferTimeout : Integer
      read FTransferTimeout write FTransferTimeout;
    property UserName : AnsiString
      read FUserName write FUserName;
  protected {events}
    property OnFtpError : TFtpErrorEvent
      read FOnFtpError write FOnFtpError;
    property OnFtpLog : TFtpLogEvent
      read FOnFtpLog write FOnFtpLog;
    property OnFtpReply : TFtpReplyEvent
      read FOnFtpReply write FOnFtpReply;
    property OnFtpStatus : TFtpStatusEvent
      read FOnFtpStatus write FOnFtpStatus;

  public {run-time properties}
    property BytesTransferred : Integer
      read FBytesTransferred;
    property Connected : Boolean
      read GetConnected;
    property InProgress : Boolean
      read GetInProgress;
    property FileLength : Integer
      read FFileLength;
    property ReplyCode : Integer
      read FReplyCode;
    property RestartAt : Integer
      read FRestartAt write FRestartAt;
    property UserLoggedIn : Boolean
      read FUserLoggedIn;

  public {methods}
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function  Abort : Boolean;
    function  ChangeDir(const RemotePathName : AnsiString) : Boolean;
    function  CurrentDir : Boolean;
    function  Delete(const RemotePathName : AnsiString) : Boolean;
    function  ListDir(const RemotePathName : AnsiString;
                      FullList : Boolean) : Boolean;
    function  Help(const Command : AnsiString) : Boolean;
    function  Login : Boolean;
    function  Logout : Boolean;
    function  MakeDir(const RemotePathName : AnsiString) : Boolean;
    function  RemoveDir (const RemotePathName : AnsiString) : Boolean;
    function  Rename(const RemotePathName, NewPathName : AnsiString) : Boolean;
    function  Retrieve(const RemotePathName, LocalPathName : AnsiString;
                       RetrieveMode : TFtpRetrieveMode) : Boolean;
    function  SendFtpCommand(const FtpCmd : AnsiString) : Boolean;
    function  Status(const RemotePathName : AnsiString) : Boolean;
    function  Store(const RemotePathName, LocalPathName : AnsiString;
                    StoreMode : TFtpStoreMode) : Boolean;
  end;


  {FtpLog component}
  TApdFtpLog = class(TApdBaseComponent)
  protected {properties}
    FEnabled        : Boolean;
    FFtpHistoryName : AnsiString;
    FFtpClient      : TApdCustomFtpClient;

  protected {methods}
    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

  public {methods}
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure UpdateLog(const LogCode : TFtpLogCode); virtual;

  published {properties}
    property Enabled : Boolean
      read FEnabled write FEnabled;
    property FtpHistoryName : AnsiString
      read FFtpHistoryName write FFtpHistoryName;
    property FtpClient : TApdCustomFtpClient
      read FFtpClient write FFtpClient;
  end;


  {Ftp component}
  TApdFtpClient = class(TApdCustomFtpClient)
  published {properties}
    property Account;
    property ConnectTimeout;
    property FileType;
    property FtpLog;
    property Password;
    property PassiveMode;
    property ServerAddress;
    property TransferTimeout;
    property UserName;
             {events}
    property OnFtpError;
    property OnFtpLog;
    property OnFtpReply;
    property OnFtpStatus;
             {inherited properties}
    property Logging;
    property LogSize;
    property LogName;
    property LogHex;
    property Tracing;
    property TraceSize;
    property TraceName;
    property TraceHex;
    property WsPort;
             {inherited events}
    property OnWsError;
  end;


implementation

uses
  AnsiStrings;

const {file data type constants}
  TypeChar  : array[TFtpFileType] of AnsiChar = ('A', 'I');

const {FTP commands}
  fcABOR = 'ABOR';
  fcACCT = 'ACCT';
  fcALLO = 'ALLO';
  fcAPPE = 'APPE';
  fcCDUP = 'CDUP';
  fcCWD  = 'CWD';
  fcDELE = 'DELE';
  fcHELP = 'HELP';
  fcLIST = 'LIST';
  fcMKD  = 'MKD';
  fcMODE = 'MODE';
  fcNLST = 'NLST';
  fcNOOP = 'NOOP';
  fcPASS = 'PASS';
  fcPASV = 'PASV';
  fcPORT = 'PORT';
  fcPWD  = 'PWD';
  fcQUIT = 'QUIT';
  fcREIN = 'REIN';
  fcREST = 'REST';
  fcRETR = 'RETR';
  fcRMD  = 'RMD';
  fcRNFR = 'RNFR';
  fcRNTO = 'RNTO';
  fcSITE = 'SITE';
  fcSIZE = 'SIZE';
  fcSMNT = 'SMNT';
  fcSTAT = 'STAT';
  fcSTOR = 'STOR';
  fcSTOU = 'STOU';
  fcSTRU = 'STRU';
  fcSYST = 'SYST';
  fcTYPE = 'TYPE';
  fcUSER = 'USER';

type {miscellaneous types}
  wParam = Integer;
  lParam = Integer;

const {miscellaneous constants}
  SockNameSize : Integer = SizeOf(TSockAddrIn);
  CRLF = #13 + #10;
  DefFtpHistoryName = 'APROFTP.HIS';
  DefServicePort = 'ftp';
  tmConnectTimer = 1;
  ecFtpConnectTimeout = -1;
  DefTransferTimeout = 1092;

  CM_APDFTPEVENT = CM_APDSOCKETQUIT + 10;
  FtpErrorMsg    = CM_APDFTPEVENT + 1;
  FtpLogMsg      = CM_APDFTPEVENT + 2;
  FtpReplyMsg    = CM_APDFTPEVENT + 3;
  FtpStatusMsg   = CM_APDFTPEVENT + 4;
  FtpTimeoutMsg  = CM_APDFTPEVENT + 5;


{.$DEFINE Debugging}
{$IFDEF Debugging}
const
  DebugLogFile = '\FtpLog.Txt';

procedure DebugTxt(const aStr : AnsiString);
var
  F : TextFile;
  S : AnsiString;
begin
  try
    AssignFile(F, DebugLogFile);
    Append(F);
  except
    on E : EInOutError do
      if (E.ErrorCode = 2) or (E.ErrorCode = 32) then
        Rewrite(F)
      else
        raise;
  end;

  S := DateTimeToStr(Now) + ' : ' + aStr;
  WriteLn(F, S);
  Close(F);
  if IOResult <> 0 then ;
end;
{$ENDIF}




{ TApdCustomFtpClient }
constructor TApdCustomFtpClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPassiveMode := False;
  FDeviceLayer := dlWinsock;
  FWsMode := wsClient;
  FWsPort := DefServicePort;
  AutoOpen := False;
  UseEventWord := False;
  hwndFtpEvent := AllocateHWnd(FtpEventHandler);
  Sock := TApdSocket.Create(Self);
  Sock.OnWsAccept := WsDataAccept;
  Sock.OnWsDisconnect := WsDataDisconnect;
  Sock.OnWsError := WsDataError;
  Sock.OnWsRead := WsDataRead;
  Sock.OnWsWrite := WsDataWrite;
  ListenSocket := Invalid_Socket;
  DataSocket := Invalid_Socket;
  ProcessState := psClosed;
  FTransferTimeout := DefTransferTimeout;
  FConnectTimeout := 0;
  FUserLoggedIn := False;
  FFileType := ftBinary;
  MultiLine := False;
  ReplyPacket := TApdDataPacket.Create(self);
  ReplyPacket.ComPort := Self;
  ReplyPacket.StartCond := scAnyData;
  ReplyPacket.EndString := CRLF;
  ReplyPacket.EndCond := [ecString];
  ReplyPacket.Timeout := 0;
  ReplyPacket.OnStringPacket := ReplyPacketHandler;
  ReplyPacket.Enabled := False;
{$IFDEF Debugging}
  if FileExists(DebugLogFile) then
    DeleteFile(DebugLogFile);
  FileClose(FileCreate(DebugLogFile));
{$ENDIF}
end;

destructor TApdCustomFtpClient.Destroy;
begin
  ReplyPacket.Free;
  NoEvents := True;
  DataShutDown;
  Open := False;
  {$IFDEF APAX}                                                          {!!.04}
  DelayTicks (4, True);
  {$ENDIF}                                                               {!!.04}
  if (hwndFtpEvent <> 0) then
    DeallocateHWnd(hwndFtpEvent);
  Sock.Free;
  inherited Destroy;
end;

function TApdCustomFtpClient.Abort : Boolean;
  {terminate file transfer in progress}
begin
  Result := (ProcessState > psIdle);
  if Result then begin
    AbortXfer := True;
    SendCommand(fcABOR);
    PostLog(lcUserAbort);
  end;
end;

function TApdCustomFtpClient.ChangeDir(const RemotePathName : AnsiString) : Boolean;
  {change the current working directory}
begin
  Result := (ProcessState = psIdle);
  if Result then begin
    ChangeState(psCmd);
    if (RemotePathName <> '') then
      SendCommand(fcCWD + ' ' + RemotePathName)
    else
      SendCommand(fcPWD);
  end;
end;

function TApdCustomFtpClient.CurrentDir : Boolean;
  {get the name of the current working directory}
begin
  Result := (ProcessState = psIdle);
  if Result then begin
    ChangeState(psCmd);
    SendCommand(fcPWD);
  end;
end;

function TApdCustomFtpClient.Delete(const RemotePathName : AnsiString) : Boolean;
  {delete specified remote file or directory}
begin
  Result := (ProcessState = psIdle) and (RemotePathName <> '');
  if Result then begin
    ChangeState(psCmd);
    FRemoteFile := RemotePathName;
    SendCommand(fcDELE + ' ' + RemotePathName);
    PostLog(lcDelete);
  end;
end;

function TApdCustomFtpClient.Help(const Command : AnsiString) : Boolean;
  {Obtain help for the specified Ftp command}
var
  Cmd : AnsiString;
begin
  Result := (ProcessState = psIdle);
  if Result then begin
    ChangeState(psCmd);
    Cmd := fcHELP;
    if (Command <> '') then
      Cmd := Cmd + ' ' + Command;
    SendCommand(Cmd);
  end;
end;

function TApdCustomFtpClient.ListDir(const RemotePathName : AnsiString;
                                     FullList : Boolean) : Boolean;
  {list contents of remote directory}
var
  S : AnsiString;
begin
  Result := (ProcessState = psIdle);
  if Result then begin
    ChangeState(psDir);
    if FullList then
      S := fcLIST
    else
      S := fcNLST;
    if (RemotePathName <> '') then
      S := S + ' ' + RemotePathName;
    PushCommand(S);
    FillChar(DataBuffer, SizeOf(DataBuffer), #0);
    FBytesTransferred := 0;
    if PassiveMode then
      PushCommand(fcPASV);
    PushCommand(AnsiString(fcType + ' ') + TypeChar[ftAscii]);
    Result := DataConnect;
  end;
end;

function TApdCustomFtpClient.MakeDir(const RemotePathName : AnsiString) : Boolean;
  {create specified remote directory}
begin
  Result := (ProcessState = psIdle);
  if Result then begin
    ChangeState(psMkDir);
    SendCommand(fcMKD + ' ' + RemotePathName);
  end;
end;

function TApdCustomFtpClient.RemoveDir (const RemotePathName : AnsiString) : Boolean;
  {delete specified remote file or directory}
begin
  Result := (ProcessState = psIdle) and (RemotePathName <> '');
  if Result then begin
    ChangeState(psCmd);
    FRemoteFile := RemotePathName;
    SendCommand(fcRMD + ' ' + RemotePathName);
    PostLog(lcDelete);
  end;
end;

function TApdCustomFtpClient.Rename(const RemotePathName, NewPathName : AnsiString) : Boolean;
  {rename specified remote file or directory}
begin
  Result := (ProcessState = psIdle) and
            (RemotePathName <> '') and (NewPathName <> '');
  if Result then begin
    ChangeState(psRen);
    PushCommand(fcRNTO + ' ' + NewPathName);
    FRemoteFile := RemotePathName;
    PostLog(lcRename);
    SendCommand(fcRNFR + ' ' + RemotePathName);
  end;
end;

function TApdCustomFtpClient.Retrieve(const RemotePathName, LocalPathName : AnsiString;
                                      RetrieveMode : TFtpRetrieveMode) : Boolean;
  {transfer a file from the server}
var
  FH : Integer;
begin
  Result := (ProcessState = psIdle) and
            (RemotePathName <> '') and (LocalPathName <> '');
  if Result then begin
    ChangeState(psGet);
    PushCommand(fcRETR + ' ' + RemotePathName);
    FRemoteFile := RemotePathName;
    FLocalFile := LocalPathName;
    if not FileExists(string(LocalPathName)) then begin
      FH := FileCreate(string(LocalPathName));
      FileClose(FH);
    end;
    if (RetrieveMode = rmReplace) then begin
      DeleteFile(string(LocalPathName));                                         {!!.04}
      LocalStream := TFileStream.Create(string(LocalPathName), fmCreate);        {!!.04}
      LocalStream.Position := 0;
      PostLog(lcReceive);
    end else if (RetrieveMode = rmAppend) then begin
      LocalStream := TFileStream.Create(string(LocalPathName), fmOpenReadWrite);
      LocalStream.Position := LocalStream.Size;
      PostLog(lcReceive);
    end else begin {RetrieveMode = rmRestart}
      LocalStream := TFileStream.Create(string(LocalPathName), fmOpenReadWrite);
      if (FRestartAt > LocalStream.Size) or (FRestartAt < 0) then
        FRestartAt := LocalStream.Size;
      LocalStream.Position := FRestartAt;
      PushCommand(AnsiString(fcREST + ' ' + IntToStr(FRestartAt)));
      PostLog(lcRestart);
    end;
    FBytesTransferred := 0;
    AbortXfer := False;
    if PassiveMode then
      PushCommand(fcPASV);
    PushCommand(AnsiString(fcType + ' ' + TypeChar[FFileType]));
    Result := DataConnect;
  end;
end;

function TApdCustomFtpClient.SendFtpCommand(const FtpCmd : AnsiString) : Boolean;
  {send any FTP command}
begin
  Result := (ProcessState = psIdle);
  if Result then begin
    ChangeState(psCmd);
    SendCommand(FtpCmd);
  end;
end;

function TApdCustomFtpClient.Status(const RemotePathName : AnsiString) : Boolean;
  {obtain status of server or optional directory listing}
var
  Cmd : AnsiString;
begin
  Result := (ProcessState = psIdle);
  if Result then begin
    ChangeState(psCmd);
    Cmd := fcSTAT;
    if (RemotePathName <> '') then
      Cmd := Cmd + ' ' + RemotePathName;
    SendCommand(Cmd);
  end;
end;

function TApdCustomFtpClient.Store(const RemotePathName, LocalPathName : AnsiString;
                                   StoreMode : TFtpStoreMode) : Boolean;
  {transfer a file to the server}
begin
  Result := (ProcessState = psIdle) and
            (RemotePathName <> '') and FileExists(string(LocalPathName));
  if Result then begin
    ChangeState(psPut);
    FRemoteFile := RemotePathName;
    FLocalFile := LocalPathName;
    if Assigned(LocalStream) then
      LocalStream.Free;
    LocalStream := TFileStream.Create(string(LocalPathName), fmOpenRead);
    FFileLength := LocalStream.Size;
    LocalStream.Position := 0;
    if (StoreMode = smAppend) then begin
      PushCommand(fcAPPE + ' ' + RemotePathName);
      PostLog(lcStore);
    end else if (StoreMode = smReplace) then begin
      PushCommand(fcSTOR + ' ' + RemotePathName);
      PostLog(lcStore);
    end else if (StoreMode = smUnique) then begin
      PushCommand(fcSTOU + ' ' + RemotePathName);
      PostLog(lcStore);
    end else begin {StoreMode = smReplace}
      if (FRestartAt > LocalStream.Size) or (FRestartAt < 0) then
        FRestartAt := 0;
      LocalStream.Position := FRestartAt;
      PushCommand(fcSTOR + ' ' + RemotePathName);
      PushCommand(AnsiString(fcREST + ' ' + IntToStr(FRestartAt)));
      PostLog(lcRestart);
    end;
    FBytesTransferred := 0;
    AbortXfer := False;
    if PassiveMode then
      PushCommand(fcPASV);
    PushCommand(AnsiString(fcType + ' ' + TypeChar[FFileType]));
    Result := DataConnect;
  end;
end;

function TApdCustomFtpClient.Login : Boolean;
  {log on to ftp server}
begin
  Result := (ProcessState in [psClosed, psLogin]);
  if Result then begin
    if (FConnectTimeout > 0) then
      SetTimer(hwndFtpEvent, tmConnectTimer, FConnectTimeout * 55, nil);
    if ProcessState = psClosed then begin
      { port is closed, connect and log in normally }
      try                                                                {!!.02}
        Open := True;
      except                                                             {!!.02}
        { if we got an exception here, the destination address was invalid }
        { if an OnWsError event is around, we'll let that notify the app;  }
        { if it's not there, then we'll let the exception do the notifying }
        if not Assigned(FOnWsError) then                                 {!!.02}
          raise;                                                         {!!.02}
      end;                                                               {!!.02}
      Result := Open;
    end else begin
      { port is already open, must be trying to re-log in }
      SendCommand(fcUSER + ' ' + FUserName);
    end;
    if Result then                                                       {!!.06}
      ChangeState(psLogin);
  end;
end;

function TApdCustomFtpClient.Logout : Boolean;
  {log off of ftp server}
begin
  Result := (Open = True);
  if Result then
    //SendCommand(fcQUIT);
    PutString(fcQuit + CRLF);
  while Open do                                                          {!!.02}
    DelayTicks(2, True);                                                 {!!.02}
end;

procedure TApdCustomFtpClient.ChangeState(NewState : TFtpProcessState);
  {change state variables, fire events, and cleanup as necessary}
begin
  case NewState of
    psClosed :
      begin
        StopTimer;
        ReplyPacket.Enabled := False;                                    {!!.02}
        DataShutDown;
        Open := False;
        FUserLoggedIn := False;
        CmdsStacked := 0;
        if (ProcessState > psLogin) then begin
          PostStatus(scLogout, nil);
          PostLog(lcLogout);
        end else
          PostStatus(scClose, nil);
      end;
    psIdle : DataDisconnect(True);
    end;
  ProcessState := NewState;
end;

procedure TApdCustomFtpClient.DataConnectPASV(IP : AnsiString);
  {establish a data connection to specified IP}
var
  DataSocketName : TSockAddrIn;
  wPort : Word;
  strPort : AnsiString;
  strPortHi : AnsiString;
  strPortLo : AnsiString;
  strAddr : AnsiString;
  i, j : Integer;
begin
  if not Assigned(Sock) then
    Exit;
  strAddr := IP;
  strPortHi := '';
  strPortLo := '';
  for i := 1 to 3 do
    if Pos(',', string(strAddr)) > 0 then
      strAddr[Pos(',', string(strAddr))]  := '.';
  i := Pos(',', string(strAddr));
  if (i > 0) then begin
    strPort := Copy(strAddr, i+1, Length(strAddr));
    System.Delete(strAddr, i, Length(strAddr));
    j := Pos(',', string(strPort));
    strPortHi := Copy(strPort, 1, j - 1);
    strPortLo := Copy(strPort, j + 1, Length(strPort));
  end;
  wPort := (StrToIntDef(string(strPortHi), 0) shl 8) + StrToIntDef(string(strPortLo), 0);
  with DataSocketName do begin
    sin_family := AF_INET;
    sin_addr := Sock.String2NetAddr(string(strAddr));
    sin_port := Sock.htons(wPort);
  end;
  Sock.ConnectSocket(DataSocket, DataSocketName);
end;

function TApdCustomFtpClient.DataConnect : Boolean;
  {establish a data connection}
var
  LocalIP : AnsiString;
begin
  Result := False;
  try
    if PassiveMode then begin
      DataSocket := Sock.CreateSocket;
      Result := (DataSocket <> Invalid_Socket);
      Sock.SetAsyncStyles(DataSocket, FD_CLOSE or FD_READ or FD_WRITE);
      SendCommand(PopCommand);
    end else begin
      if (SockFuncs.GetSockName(Dispatcher.ComHandle, ListenName, SockNameSize) = 0) then begin
        if (ListenSocket = Invalid_Socket) then
          ListenSocket := Sock.CreateSocket;
        if (ListenSocket <> Invalid_Socket) then begin
          Sock.SetAsyncStyles(ListenSocket, FD_ACCEPT or FD_CLOSE or FD_READ or FD_WRITE);
          ListenName.sin_family := AF_INET;
          ListenName.sin_port := Sock.htons(0);
          if (Sock.BindSocket(ListenSocket, ListenName) = 0) then
            if (SockFuncs.GetSockName(ListenSocket, ListenName, SockNameSize) = 0) then begin
              with ListenName do
                LocalIP := AnsiString(Sock.NetAddr2String(sin_addr) + '.' +
                  IntToStr(Lo(sin_port)) + '.' + IntToStr(Hi(sin_port)));
              while Pos('.', string(LocalIP)) > 0 do
                LocalIP[Pos('.', string(LocalIP))]  := ',';
              SendCommand(fcPORT + ' ' + LocalIP);
              if (Sock.ListenSocket(ListenSocket, 5) = 0) then
                Result := True;
            end;
        end;
      end;
    end;
  except
    DataShutDown;
    CmdsStacked := 0;
  end;
end;

procedure TApdCustomFtpClient.DataDisconnect(FlushBuffer : Boolean);
  {retrieve any remaining data and close the data connection}
begin
  try
    if (DataSocket <> Invalid_Socket) then begin
      Sock.SetAsyncStyles(DataSocket, 0);
      Sock.ShutdownSocket(DataSocket, SD_Send);
      if (ProcessState = psDir) or (ProcessState = psGet) then
        if FlushBuffer then
          repeat until (GetData <= 0);
      Sock.ShutdownSocket(DataSocket, SD_Both);
    end;
  finally
    DataShutDown;
  end;
end;

procedure TApdCustomFtpClient.DataShutDown;
  {shutdown data connection}
begin
  try
    if (DataSocket <> Invalid_Socket) then
      Sock.CloseSocket(DataSocket);
  except
  end;
  try
    if (ListenSocket <> Invalid_Socket) then
      Sock.CloseSocket(ListenSocket);
  except
  end;
  ListenSocket := Invalid_Socket;
  DataSocket := Invalid_Socket;
  if Assigned(LocalStream) then
    LocalStream.Free;
  LocalStream := nil;
  FFileLength := 0;
end;

procedure TApdCustomFtpClient.DoConnect;
  {control connection now established}
begin
  KillTimer(hwndFtpEvent, tmConnectTimer);
  ReplyPacket.Enabled := True;
  Dispatcher.RegisterEventTriggerHandler(TimerTrigger);
  ChangeState(psLogin);
end;

procedure TApdCustomFtpClient.DoDisconnect;
  {control connection now closed}
begin
  KillTimer(hwndFtpEvent, tmConnectTimer);
  if Assigned(Dispatcher) then                                           {!!.02}
    Dispatcher.DeRegisterEventTriggerHandler(TimerTrigger);
  ReplyPacket.Enabled := False;
  ChangeState(psClosed);
end;

procedure TApdCustomFtpClient.FtpEventHandler(var Msg : TMessage);
  {message handler to decouple events from the control connection}
var
  PInfo : PAnsiChar;
begin
  PInfo := Pointer(Msg.lParam);
  case Msg.Msg of

    WM_TIMER :
      begin
        ChangeState(psClosed);
        KillTimer(hwndFtpEvent, tmConnectTimer);
        if Assigned(FOnFtpError) then
          FOnFtpError(Self, ecFtpConnectTimeout, nil);
      end;

    FtpErrorMsg :
      if Assigned(FOnFtpError) then
        FOnFtpError(Self, Msg.wParam, PInfo);

    FtpLogMsg :
      if Assigned(FFtpLog) then
        TApdFtpLog(FFtpLog).UpdateLog(TFtpLogCode(Msg.wParam))
      else if Assigned(FOnFtpLog) then
        FOnFtpLog(Self, TFtpLogCode(Msg.wParam));

    FtpReplyMsg :
      begin
        FtpReplyHandler(Msg.wParam, PInfo);
        if Assigned(FOnFtpReply) and (not NoEvents) then
          FOnFtpReply(Self, Msg.wParam, PInfo);
      end;

    FtpStatusMsg :
      if Assigned(FOnFtpStatus) then
        FOnFtpStatus(Self, TFtpStatusCode(Msg.wParam), PInfo);

    FtpTimeoutMsg :
      begin
        AbortXfer := True;
        if (ProcessState > psLogin) then
          ChangeState(psIdle)
        else
          ChangeState(psClosed);
        if Assigned(FOnFtpStatus) then
          FOnFtpStatus(Self, TFtpStatusCode(Msg.wParam), PInfo);
      end;
  else
    Exit;
  end; {case}

  if Assigned(PInfo) then
    AnsiStrings.StrDispose(PInfo);
end;

procedure TApdCustomFtpClient.FtpReplyHandler(ReplyCode : Integer; PData : PAnsiChar);
  { Server reply handler - state machine }
var
  S : AnsiString;
  PReply : PAnsiChar;

  procedure Error(Code : Integer; PInfo : PAnsiChar);
  begin
    CmdsStacked := 0;
    case Code of
      221, 421 : ChangeState(psClosed);
    else
      PostError(Code, PInfo);
    end;
  end;

begin
  if not MultiLine then begin
    FillChar(ReplyBuffer, SizeOf(ReplyBuffer), #0);
    AnsiStrings.StrCopy(ReplyBuffer, PData);
    if (PData[3] = '-') then begin
      MultiLine := True;
      MultiLineTerm := AnsiString(IntToStr(ReplyCode) + ' ');
      Exit;
    end;
  end else begin
    if (Pos(MultiLineTerm, AnsiStrings.StrPas(PData)) <> 1) then begin
      AnsiStrings.StrCat(ReplyBuffer, PData);
      Exit;
    end else
      MultiLine := False
  end;
  PReply := ReplyBuffer;
  {$IFDEF Debugging}
  DebugTxt(AnsiStrings.StrPas(PReply));
  {$ENDIF}

  case ProcessState of
    psClosed, psIdle :
      case ReplyCode of
        125 : ; {ignore for now}
        150 : ; {ignore for now}
        226 : DataDisconnect(True);
      else
        Error(ReplyCode, PReply);
      end;
    psLogin :
      case ReplyCode of
        202 : ; {ignore}
        220 : begin
                PostStatus(scOpen, PReply + 4);
                SendCommand(fcUSER + ' ' + FUserName);
              end;
        230 : begin
                ChangeState(psIdle);
                FUserLoggedIn := True;
                PostStatus(scLogin, nil);
              end;
        331 : SendCommand(fcPASS + ' ' + FPassword);
        332 : SendCommand(fcACCT + ' ' + FAccount);
      else
        Error(ReplyCode, PReply);
      end; {case for psLogin}
    psDir, psGet, psPut :
      if (ReplyCode >= 200) then
        case ReplyCode of
          125 : ; {ignore for now}
          150 : ; {ignore for now}
          200 : PopCommand;
          226 : ; {ignore for now}
          227 :
            begin
              S := PReply;
              S := Copy(S, Pos('(', string(S)) + 1, Length(S));
              S := Copy(S, 1, Pos(')', string(S)) - 1);
              DataConnectPASV(S);
              PopCommand;
            end;
          250 : ChangeState(psIdle);
          350 : PopCommand;
        else
          Error(ReplyCode, PReply);
        end; {case for psDir, psGet, psPut}
    psRen :
      case ReplyCode of
        226 : ; {ignore for now}
        250 : begin
                ChangeState(psIdle);
                PostStatus(scComplete, nil);
              end;
        350 : PopCommand;
      else
        Error (ReplyCode, PReply);
      end; {case for psRen}
    psCmd :
      case ReplyCode of
        211, 212, 213, 214, 215 :
          begin
            PostStatus(scDataAvail, PReply + 4);
          end;
        225, 226 :
          begin
            ChangeState(psIdle);
          end;
        250 :
          begin
            PostStatus(scComplete, nil);
          end;
        257 :
          begin
            S := AnsiStrings.StrPas(PReply);
            S := Copy(S, Pos('"', string(S)) + 1, Length(S));
            S := Copy(S, 1, Pos('"', string(S)) - 1);
            AnsiStrings.StrPCopy(PReply, S);
            PostStatus(scCurrentDir, PReply);
          end;
      else
        Error(ReplyCode, PReply);
      end; {case for psCmd}

    psMkDir :
      case ReplyCode of
        250, 257 : ChangeState(psIdle);
      else
        Error(ReplyCode, PReply);
      end; {case for psMkDir}
  end; {case ProcessState of}
end;

function TApdCustomFtpClient.GetConnected : Boolean;
  {check control connection status}
begin
  Result := (ProcessState <> psClosed);
end;

function TApdCustomFtpClient.GetData : Integer;
  {retrieve data via data connection}
begin
  Result := 0;
  if (DataSocket = Invalid_Socket) then
    Exit;

  if (ProcessState = psGet) then begin
    if (not Assigned(LocalStream)) or AbortXfer then
      Exit;
    ResetTimer;
    Result := Sock.ReadSocket(DataSocket, DataBuffer, SizeOf(DataBuffer), 0);
    if (Result > 0) then begin
      FBytesTransferred := FBytesTransferred + Result;
      LocalStream.WriteBuffer(DataBuffer, Result);
      PostStatus(scProgress, nil);
    end;
  end else begin
    Result := Sock.ReadSocket(DataSocket, DataBuffer[FBytesTransferred],
                              SizeOf(DataBuffer) - FBytesTransferred, 0);
    if (Result > 0) then
      FBytesTransferred := FBytesTransferred + Result;
  end;
end;

function TApdCustomFtpClient.GetInProgress : Boolean;
  {check if data transfer is in progress}
begin
  Result := not ((ProcessState = psClosed) or (ProcessState = psIdle));
end;

procedure TApdCustomFtpClient.Notification(AComponent : TComponent;
                                           Operation : TOperation);
  {new/deleted log component}
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) then begin
    if (AComponent = FFtpLog) then
        FtpLog := nil;
  end else if (Operation = opInsert) then
    if (AComponent is TApdFtpLog) then
      if not Assigned(FFtpLog) then
        if not Assigned(TApdFtpLog(AComponent).FFtpClient) then
          FtpLog := TApdFtpLog(AComponent);
end;

function TApdCustomFtpClient.PopCommand : AnsiString;
  {pop ftp command off of command stack}
begin
  if (CmdsStacked > 0) then begin
    Dec(CmdsStacked);
    Result := CmdStack[CmdsStacked];
    SendCommand(Result);
  end else
    Result := '';
end;

procedure TApdCustomFtpClient.PostError(Code : Integer; Info : PAnsiChar);
  {place error event in message queue}
var
  PData : PAnsiChar;
begin
  PData := nil;
  if (ProcessState > psIdle) then
    ChangeState(psIdle);
    { filter out the 2xx codes, those are successful replies }
(*  from RFC 959, 2xx codes are successful replies, with the exception of
  202 and 221, which require special handling, all 2xx codes are:
         200 Command okay.
         202 Command not implemented, superfluous at this site.
         211 System status, or system help reply.
         212 Directory status.
         213 File status.
         214 Help message.
             On how to use the server or the meaning of a particular
             non-standard command.  This reply is useful only to the
             human user.
         215 NAME system type.
             Where NAME is an official system name from the list in the
             Assigned Numbers document.
         220 Service ready for new user.
         221 Service closing control connection.
             Logged out if appropriate.
         225 Data connection open; no transfer in progress.
         226 Closing data connection.
             Requested file action successful (for example, file
             transfer or file abort).
         227 Entering Passive Mode (h1,h2,h3,h4,p1,p2).
         230 User logged in, proceed.
         250 Requested file action okay, completed.
         257 "PATHNAME" created.
*)
  { section reorganized to fix mem leak (#3605)}                         {!!.05}
  if not NoEvents then begin
    if (Code = 202) or (Code > 299) then begin
      if Assigned(Info) then
        PData := AnsiStrings.StrNew(Info);
      PostMessage(hwndFtpEvent, FtpErrorMsg, Integer(Code), Integer(PData));
    end;
  end;
end;

procedure TApdCustomFtpClient.PostLog(Code : TFtpLogCode);
  {place log event in message queue}
begin
  PostMessage(hwndFtpEvent, FtpLogMsg, Integer(Code), 0);
end;

procedure TApdCustomFtpClient.PostStatus(Code : TFtpStatusCode; Info : PAnsiChar);
  {place status event in message queue}
var
  PData : PAnsiChar;
begin
  PData := nil;
  if (Code > scLogin) and (Code <> scProgress) then
    ChangeState(psIdle);
  if not NoEvents then begin
    if Assigned(Info) then
      PData := AnsiStrings.StrNew(Info);
    PostMessage(hwndFtpEvent, FtpStatusMsg, Integer(Code), Integer(PData));
  end;
end;

procedure TApdCustomFtpClient.PushCommand(const Cmd : AnsiString);
  {push ftp command onto command stack - dont call from an event handler}
begin
  if (CmdsStacked < MaxCmdStack) then begin
    CmdStack[CmdsStacked] := Cmd;
    Inc(CmdsStacked);
  end else begin
    CmdsStacked := 0;
    raise Exception.Create('FTP Command stack full');
  end;
end;

function TApdCustomFtpClient.PutData : Integer;
  {send as much data as possible}
var
  N, M : Integer;
  Done : Boolean;
begin
  Result := 0;
  if (DataSocket = Invalid_Socket) or (not Assigned(LocalStream)) then begin
    if (ProcessState > psIdle) then
      ChangeState(psIdle);
    Exit;
  end;

  Done := (LocalStream.Position = LocalStream.Size) or AbortXfer;
  while (not Done) do begin
    ResetTimer;
    if (LocalStream.Size - LocalStream.Position) < SizeOf(DataBuffer) then
      N := LocalStream.Size - LocalStream.Position
    else
      N := SizeOf(DataBuffer);
    LocalStream.ReadBuffer(DataBuffer, N);
    M := Sock.WriteSocket(DataSocket, DataBuffer, N, 0);
    if (M < N) then begin
      if (M > 0) then
        LocalStream.Position := LocalStream.Position - (N-M)
      else begin
        LocalStream.Position := LocalStream.Position - N;
        break;
      end;
    end;
    FBytesTransferred := FBytesTransferred + M;
    PostStatus(scProgress, nil);
    Done := (LocalStream.Position = LocalStream.Size) or AbortXfer;
  end;
  if Done then
    Sock.ShutDownSocket(DataSocket, SD_SEND);
end;

procedure TApdCustomFtpClient.ResetTimer;
  {reset transfer timeout timer}
begin
  if (Timer <> 0) and (FTransferTimeout > 0) then
    Dispatcher.SetTimerTrigger(Timer, FTransferTimeout, True);
end;

procedure TApdCustomFtpClient.SendCommand(const Cmd : AnsiString);
  {send FTP command String via control connection}
begin
  StartTimer;
{$IFDEF Debugging}
  DebugTxt(Cmd);
{$ENDIF}
  PutString(Cmd + CRLF);
end;

procedure TApdCustomFtpClient.SetFtpLog(const NewLog : TApdFtpLog);
  {set a new Ftp log component}
begin
  if (NewLog <> FFtpLog) then begin
    FFtpLog := NewLog;
    if Assigned(FFtpLog) then
      FFtpLog.FtpClient := Self;
  end;
end;

procedure TApdCustomFtpClient.StartTimer;
  {intialize transfer timeout timer}
begin
  StopTimer;
  if (FTransferTimeout > 0) and (Assigned(Dispatcher)) then begin        {!!.06}
    Timer := Dispatcher.AddTimerTrigger;
    Dispatcher.SetTimerTrigger(Timer, FTransferTimeout, True);
  end;
end;

procedure TApdCustomFtpClient.StopTimer;
  {remove transfer timeout timer}
begin
  if (Timer <> 0) then begin
    if Assigned(Dispatcher) then begin                                   {!!.04}
      Dispatcher.SetTimerTrigger(Timer, 0, False);
      Dispatcher.RemoveTrigger(Timer);
    end;                                                                 {!!.04}
    Timer := 0;
  end;
end;

procedure TApdCustomFtpClient.ReplyPacketHandler(Sender : TObject; Data : Ansistring);
var
  RCode : Integer;
  PReply : PAnsiChar;
begin
  RCode := StrToIntDef(Copy(string(Data), 1, 3), 0);
  PReply := AnsiStrAlloc(Length(Data)+ 1);
  AnsiStrings.StrPCopy(PReply, Data);
  PostMessage(hwndFtpEvent, FtpReplyMsg, RCode, Integer(PReply));
end;

procedure TApdCustomFtpClient.TimerTrigger(Msg, wParam : Cardinal; lParam : Integer);
  {control connection trigger handler}
begin
  if (Msg = apw_TriggerTimer) and (Integer(wParam) = Timer) then begin
    StopTimer;
    if (ProcessState <> psIdle) then
      PostMessage(hwndFtpEvent, FtpTimeoutMsg, 0, 0);
  end;
end;

procedure TApdCustomFtpClient.WsDataAccept(Sender : TObject; Socket : TSocket);
  {accept server request to open data connection}
begin
  DataSocket := Sock.AcceptSocket(ListenSocket, DataName);
end;

procedure TApdCustomFtpClient.WsDataDisconnect(Sender : TObject; Socket : TSocket);
  {data connection now closed}
var
  PInfo : PAnsiChar;
begin
  if (Socket = DataSocket) then begin
    if (ProcessState = psDir) then begin
      PInfo := AnsiStrAlloc(SizeOf(DataBuffer));
      AnsiStrings.StrCopy(PInfo, @DataBuffer);
      PostStatus(scDataAvail, PInfo);
    end else if (ProcessState = psGet) or (ProcessState = psPut) then
      PostStatus(scTransferOK, nil);
  end;
end;

procedure TApdCustomFtpClient.WsDataError(Sender : TObject; Socket : TSocket;
                                          ErrorCode : Integer);
  {data socket error - terminate FTP operation}
begin
  if not AbortXfer then begin
    AbortXfer := True;
    PostError(ErrorCode, nil);
  end;
end;

procedure TApdCustomFtpClient.WsDataRead(Sender : TObject; Socket : TSocket);
  {process reply from the ftp server}
begin
  if (Socket = DataSocket) then
    if (ProcessState = psDir) or (ProcessState = psGet) then
      GetData;
end;

procedure TApdCustomFtpClient.WsDataWrite(Sender : TObject; Socket : TSocket);
  {send blocks of file data as needed}
begin
  if (Socket = DataSocket) and (ProcessState = psPut) then
    PutData;
end;


{ TApdFtpLog }
constructor TApdFtpLog.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFtpHistoryName := DefFtpHistoryName;
  FEnabled := False;
end;

destructor TApdFtpLog.Destroy;
begin
  if Assigned(FFtpClient) then
    FFtpClient.FtpLog := nil;
  inherited Destroy;
end;

procedure TApdFtpLog.Notification(AComponent : TComponent;
                                  Operation: TOperation);
  {new/deleted ftp client component}
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then begin
    if (AComponent = FFtpClient) then
      FFtpClient := nil;
  end;
end;

procedure TApdFtpLog.UpdateLog(const LogCode : TFtpLogCode);
var
  F : TextFile;
  S : AnsiString;
begin
  if (not FEnabled) or (FFtpHistoryName = '') then
    Exit;
  try
    AssignFile(F, string(FFtpHistoryName));
    Append(F);
  except
    on E : EInOutError do
      if (E.ErrorCode = 2) or (E.ErrorCode = 32) then
        Rewrite(F)
      else
        raise;
  end;

  S := AnsiString(DateTimeToStr(Now) + ' : ');
  case LogCode of
    lcOpen :
      S := S + AnsiString('Connected to ' + FtpClient.ServerAddress);
    lcClose :
      S := S + 'Disconnected';
    lcLogin :
      S := S + FtpClient.UserName + ' logged in';
    lcLogout :
      S := S + FtpClient.UserName + ' logged out';
    lcDelete :
      S := S + 'Deleting ' + FtpClient.FRemoteFile;
    lcRename :
      S := S + 'Renaming ' + FtpClient.FRemoteFile;
    lcReceive :
      S := S + 'Downloading ' + FtpClient.FRemoteFile;
    lcStore :
      S := S + 'Uploading ' + FtpClient.FLocalFile;
    lcComplete :
      S := S + AnsiString('Transfer complete. ' +
             IntToStr(FtpClient.FBytesTransferred) + ' bytes Transferred');
    lcRestart :
      S := S + AnsiString('Attempting re-transfer at ' +
             IntToStr(FtpClient.FRestartAt) + ' bytes');
    lcTimeout :
      S := S + 'Transfer timed out';
    lcUserAbort :
      S := S + 'Transfer aborted by user';
  end;
  WriteLn(F, S);
  Close(F);
  if IOResult <> 0 then ;
end;


end.
