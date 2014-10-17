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
 *
 * ***** END LICENSE BLOCK ***** *)

{******************************************************************}
{*                         AXFTP.PAS 1.13                         *}
{******************************************************************}
{*  Provides FTP support for APAX                                 *}
{******************************************************************}

unit AxFtp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  AdFtp, AdPort, OOMisc;

type
  TApxFTPState = (fsNone, fsAbort, fsChangeDir, fsCurrentDir, fsDelete, fsHelp,
    fsListDir, fsLogIn, fsLogOut, fsMakeDir, fsRemoveDir, fsRename, fsRetrieve,
    fsSendFTPCommand, fsStatus, fsStore);


  TApxFtpClient = class(TComponent)
  private
    { Private declarations }
    FFtpClient : TApdFTPClient;

    FFTPState: TApxFTPState;
    FOnFtpError: TFtpErrorEvent;
    FOnFtpLog: TFtpLogEvent;
    FOnFtpReply: TFtpReplyEvent;
    FOnFtpStatus: TFtpStatusEvent;
    procedure SetAccount(const Value: string);
    procedure SetConnectTimeout(const Value: Integer);
    procedure SetFileType(const Value: TFTPFileType);
    procedure SetPassiveMode(const Value: Boolean);
    procedure SetPassword(const Value: string);
    procedure SetRestartAt(const Value: LongInt);
    procedure SetServerAddress(const Value: string);
    procedure SetTransferTimeout(const Value: Integer);
    procedure SetUserName(const Value: string);
    procedure SetLogging(const Value: TTraceLogState);
    procedure SetLogAllHex(const Value: Boolean);
    procedure SetLogHex(const Value: Boolean);
    procedure SetLogName(const Value: string);
    procedure SetLogSize(const Value: Integer);
    function GetBytesTransferred: LongInt;
    function GetFileLength: LongInt;
    function GetConnected: Boolean;
    function GetInProgress: Boolean;
    function GetUserLoggedIn: Boolean;
    function GetTransferTimeout: Integer;
    function GetPassiveMode: Boolean;
    function GetConnectTimeout: Integer;
    function GetRestartAt: LongInt;
    function GetUserName: string;
    function GetServerAddress: string;
    function GetAccount: string;
    function GetFileType: TFTPFileType;
    function GetPassword: string;
    function GetLogAllHex: Boolean;
    function GetLogging: TTraceLogState;
    function GetLogHex: Boolean;
    function GetLogName: string;
    function GetLogSize: Integer;
  protected
    { Protected declarations }
    FSucceeded : Boolean;
    FFailed    : Boolean;
    FStoredString : string;

    procedure InternalOnFTPError(Sender : TObject; ErrorCode : Integer; ErrorText : PChar);
    procedure InternalOnFTPLog(Sender : TObject; LogCode : TFtpLogCode);
    procedure InternalOnFTPReply(Sender : TObject; ReplyCode : Integer; ReplyText : PChar);
    procedure InternalOnFTPStatus(Sender : TObject; StatusCode : TFtpStatusCode; InfoText : PChar);
    procedure InternalOnWsError(Sender : TObject; ErrCode : Integer);

    procedure DoFTPLog(LogCode : TFTPLogCode);

    function WaitForStatusBool : Boolean;
    function WaitForStatusString : string;

  public
    { Public declarations }
    constructor Create(Aowner : TComponent); override;
    destructor Destroy; override;

    property FTPState : TApxFTPState read FFTPState;

  published
    { Published declarations }
    property Account : string read GetAccount write SetAccount;
    property BytesTransferred : LongInt read GetBytesTransferred;
    property Connected : Boolean read GetConnected;
    property ConnectTimeout : Integer read GetConnectTimeout write SetConnectTimeout;
    property FileLength : LongInt read GetFileLength;
    property FileType : TFTPFileType read GetFileType write SetFileType;
    property InProgress : Boolean read GetInProgress;
    property PassiveMode : Boolean read GetPassiveMode write SetPassiveMode;
    property Password : string read GetPassword write SetPassword;
    property RestartAt : LongInt read GetRestartAt write SetRestartAt;
    property ServerAddress : string read GetServerAddress write SetServerAddress;
    property TransferTimeout : Integer read GetTransferTimeout write SetTransferTimeout;
    property UserLoggedIn : Boolean read GetUserLoggedIn;
    property UserName : string read GetUserName write SetUserName;

    { derived from the comport }
    property Logging : TTraceLogState read GetLogging write SetLogging;
    property LogHex : Boolean read GetLogHex write SetLogHex;
    property LogAllHex : Boolean read GetLogAllHex write SetLogAllHex;
    property LogName : string read GetLogName write SetLogName;
    property LogSize : Integer read GetLogSize write SetLogSize;

    function Abort : Boolean;
    function ChangeDir(const RemotePathName : string) : Boolean;
    function CurrentDir : string;
    function Delete(const RemotePathName : string) : Boolean;
    function Help(const Command : string) : string;
    function ListDir(const RemotePathName : string; FullList : Boolean) : string;
    function LogIn : Boolean;
    function LogOut : Boolean;
    function MakeDir(const RemotePathName : string) : Boolean;
    function RemoveDir(const RemotePathName : string) : Boolean;
    function Rename(const RemotePathName, NewPathName : string) : Boolean;
    function Retrieve(const RemotePathName, LocalPathName : string; RetrieveMode : TFTPRetrieveMode) : Boolean;
    function SendFTPCommand(const FTPCommand : string) : string;
    function Status(const RemotePathName : string) : string;
    function Store(const RemotePathName, LocalPathName : string; StoreMode : TFTPStoreMode) : Boolean;

    { published events }
    property OnFtpError : TFtpErrorEvent
      read FOnFtpError write FOnFtpError;
    property OnFtpLog : TFtpLogEvent
      read FOnFtpLog write  FOnFtpLog;
    property OnFtpReply : TFtpReplyEvent
      read FOnFtpReply write FOnFtpReply;
    property OnFtpStatus : TFtpStatusEvent
      read FOnFtpStatus write FOnFtpStatus;
  end;

implementation

{ TApxFtpClient }

function TApxFtpClient.Abort: Boolean;
begin
  FFTPState := fsAbort;
  DoFTPLog(lcUserAbort);
  FFTPCLient.Abort;
  Result := WaitForStatusBool;
end;

function TApxFtpClient.ChangeDir(const RemotePathName: string): Boolean;
begin
  FFTPState := fsChangeDir;
  FFTPCLient.ChangeDir (RemotePathName);
  Result := WaitForStatusBool;
end;

constructor TApxFtpClient.Create;
begin
  inherited;
  FFTPClient := TApdFTPClient.Create(nil);

  FFTPClient.OnFtpError := InternalOnFTPError;
//  FFTPClient.OnFtpLog :=  InternalOnFTPLog;
  FFTPClient.OnFTPReply := InternalOnFTPReply;
  FFTPClient.OnFtpStatus := InternalOnFTPStatus;
  FFTPClient.OnWsError := InternalOnWsError;
end;

function TApxFtpClient.CurrentDir: string;
begin
  FFTPState := fsCurrentDir;
  FFTPClient.CurrentDir;
  Result := WaitForStatusString;
end;

function TApxFtpClient.Delete(const RemotePathName: string): Boolean;
begin
  FFTPState := fsDelete;
  DoFTPLog(lcDelete);
  FFTPClient.Delete(RemotePathName);
  Result := WaitForStatusBool;
end;

destructor TApxFtpClient.Destroy;
begin
  FFailed := True;
  FFTPClient.Free;
  inherited;
end;

procedure TApxFtpClient.DoFTPLog(LogCode: TFTPLogCode);
begin
  if Assigned(FOnFTPLog) then
    FOnFTPLog(Self, LogCode);
end;

function TApxFtpClient.GetAccount: string;
begin
  Result := FFTPClient.Account;
end;

function TApxFtpClient.GetBytesTransferred: LongInt;
begin
  Result := FFTPClient.BytesTransferred;
end;

function TApxFtpClient.GetConnected: Boolean;
begin
  Result := FFTPClient.Connected;
end;

function TApxFtpClient.GetConnectTimeout: Integer;
begin
  Result := FFTPClient.ConnectTimeout;
end;

function TApxFtpClient.GetFileLength: LongInt;
begin
  Result := FFTPClient.FileLength;
end;

function TApxFtpClient.GetFileType: TFTPFileType;
begin
  Result := FFTPClient.FileType;
end;

function TApxFtpClient.GetInProgress: Boolean;
begin
  Result := FFTPClient.InProgress;
end;

function TApxFtpClient.GetLogAllHex: Boolean;
begin
  Result := FFTPClient.LogAllHex;
end;

function TApxFtpClient.GetLogging: TTraceLogState;
begin
  Result := FFTPClient.Logging;
end;

function TApxFtpClient.GetLogHex: Boolean;
begin
  Result := FFTPClient.LogHex;
end;

function TApxFtpClient.GetLogName: string;
begin
  Result := FFTPClient.LogName;
end;

function TApxFtpClient.GetLogSize: Integer;
begin
  Result := FFTPClient.LogSize;
end;

function TApxFtpClient.GetPassiveMode: Boolean;
begin
  Result := FFTPClient.PassiveMode;
end;

function TApxFtpClient.GetPassword: string;
begin
  Result := FFTPClient.Password;
end;

function TApxFtpClient.GetRestartAt: LongInt;
begin
  Result := FFTPClient.RestartAt;
end;

function TApxFtpClient.GetServerAddress: string;
begin
  Result := FFTPClient.ServerAddress;
end;

function TApxFtpClient.GetTransferTimeout: Integer;
begin
  Result := FFTPClient.TransferTimeout;
end;

function TApxFtpClient.GetUserLoggedIn: Boolean;
begin
  Result := FFTPClient.UserLoggedIn;
end;

function TApxFtpClient.GetUserName: string;
begin
  Result := FFTPClient.UserName;
end;

function TApxFtpClient.Help(const Command: string): string;
begin
  FFTPState := fsHelp;
  FFTPClient.Help(Command);
  Result := WaitForStatusString;
end;

procedure TApxFtpClient.InternalOnFTPError(Sender: TObject;
  ErrorCode: Integer; ErrorText: PChar);
begin
  FFailed := True;
  { do the event thing }
  if Assigned(FOnFTPError) then
    FOnFTPError(Sender, ErrorCode, ErrorText);
end;

procedure TApxFtpClient.InternalOnFTPLog(Sender: TObject;
  LogCode: TFtpLogCode);
begin
  { do the event thing }
  {if Assigned(FOnFTPLog) then
    FOnFTPLog(Sender, LogCode);}
  { actually, we'll do the log thing ourselves }
end;

procedure TApxFtpClient.InternalOnFTPReply(Sender: TObject;
  ReplyCode: Integer; ReplyText: PChar);
begin
  { do the event thing }
  if Assigned(FOnFTPReply) then
    FOnFTPReply(Sender, ReplyCode, ReplyText);
end;

procedure TApxFtpClient.InternalOnFTPStatus(Sender: TObject;
  StatusCode: TFtpStatusCode; InfoText: PChar);
begin
  if Assigned(FOnFTPStatus) then
    FOnFTPStatus(Sender, StatusCode, InfoText);
  case FFTPState of
    fsNone :
      begin
        { nothing to do }
      end;
    fsAbort :
      begin
        FSucceeded := True;
      end;
    fsChangeDir :
      begin
        case StatusCode of
          scComplete :
            begin
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsCurrentDir :
      begin
        case StatusCode of
          scCurrentDir :
            begin
              FStoredString := string(InfoText);
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsDelete :
      begin
        case StatusCode of
          scComplete :
            begin
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsHelp :
      begin
        case StatusCode of
          scDataAvail :
            begin
              FStoredString := string(InfoText);
              FSucceeded := True;
            end;
        else
          FFailed := True;
        end;
      end;
    fsListDir :
      begin
        case StatusCode of
          scDataAvail :
            begin
              FStoredString := string(InfoText);
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsLogIn :
      begin
        case StatusCode of
          scOpen :
            begin
              { ignore it }
              DoFTPLog(lcOpen);
            end;
          scLogin :
            begin
              FSucceeded := True;
              DoFTPLog(lcLogin);
            end;
          else
            FFailed := True;
        end;
      end;
    fsLogOut :
      begin
        case StatusCode of
          scLogout :
            begin
              DoFTPLog(lcLogout);
            end;
          scClose :
            begin
              FSucceeded := True;
              DoFTPLog(lcClose);
            end;
          end;
      end;
    fsMakeDir :
      begin
        case StatusCode of
          scComplete :
            begin
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsRemoveDir :
      begin
        case StatusCode of
          scComplete :
            begin
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsRename :
      begin
        case StatusCode of
          scComplete :
            begin
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsRetrieve :
      begin
        case StatusCode of
          scTransferOK :
            begin
              DelayTicks(9, True);
              FSucceeded := True;
            end;
          scTimeout :
            begin
              { may need fancy schmancy error handler }
              FFailed :=True;
            end;
          scProgress :
            begin
              { ignore }
            end;
          else
            FFailed := True;
        end;
      end;
    fsSendFTPCommand :
      begin
        case StatusCode of
          scComplete :
            begin
              FStoredString := string(InfoText);
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsStatus :
      begin
        case StatusCode of
          scDataAvail :
            begin
              FStoredString := string(InfoText);
              FSucceeded := True;
            end;
          else
            FFailed := True;
        end;
      end;
    fsStore :
      begin
        case StatusCode of
          scProgress :
            begin
              { ignore }
            end;
          scTimeout :
            begin
              FFailed := True;
            end;
          scTransferOK :
            begin
              DelayTicks(9, True);
              FSucceeded := True;
            end;     
          else
            FFailed := True;
        end;
      end;
  end;
end;

procedure TApxFtpClient.InternalOnWsError(Sender: TObject;
  ErrCode: Integer);
begin
  FFailed := True;
  { do the event thing }
end;

function TApxFtpClient.ListDir(const RemotePathName: string;
  FullList: Boolean): string;
begin
  FFTPState := fsListDir;
  FFTPClient.ListDir(RemotePathName, FullList);
  Result := WaitForStatusString;
end;

function TApxFtpClient.LogIn: Boolean;
begin
  FFTPState := fsLogin;
  try
    Result := FFTPClient.Login;
  except
    Result := False;
  end;
  DelayTicks(4, True);
end;

function TApxFtpClient.LogOut: Boolean;
begin
  FFTPState := fsLogOut;
  Result := FFTPClient.LogOut;
end;

function TApxFtpClient.MakeDir(const RemotePathName: string): Boolean;
begin
  FFTPState := fsMakeDir;
  FFTPClient.MakeDir(RemotePathName);
  Result := WaitForStatusBool;
end;

function TApxFtpClient.RemoveDir(const RemotePathName: string): Boolean;
begin
  FFTPState := fsRemoveDir;            
  DoFTPLog(lcDelete);
  FFTPClient.RemoveDir(RemotePathName);
  Result := WaitForStatusBool;
end;

function TApxFtpClient.Rename(const RemotePathName,
  NewPathName: string): Boolean;
begin
  FFTPState := fsRename;
  DoFTPLog(lcRename);
  FFTPClient.Rename(RemotePathName, NewPathName);
  Result := WaitForStatusBool;
end;

function TApxFtpClient.Retrieve(const RemotePathName,
  LocalPathName: string; RetrieveMode: TFTPRetrieveMode): Boolean;
begin
  FFTPState := fsRetrieve;
  if RetrieveMode in [rmReplace, rmAppend] then
    DoFTPLog(lcReceive)
  else
    DoFTPLog(lcRestart);
  FFTPClient.Retrieve(RemotePathName, LocalPathName, RetrieveMode);
  Result := WaitForStatusBool;
  if Result then
    DoFTPLog(lcComplete);
end;

function TApxFtpClient.SendFTPCommand(const FTPCommand: string): string;
begin
  FFTPState := fsSendFTPCommand;
  FFTPClient.SendFTPCommand(FTPCommand);
  Result := WaitForStatusString;
end;

procedure TApxFtpClient.SetAccount(const Value: string);
begin
  FFTPClient.Account := Value;
end;

procedure TApxFtpClient.SetConnectTimeout(const Value: Integer);
begin
  FFTPClient.ConnectTimeout := Value;
end;

procedure TApxFtpClient.SetFileType(const Value: TFTPFileType);
begin
  FFTPClient.FileType := Value;
end;

procedure TApxFtpClient.SetLogAllHex(const Value: Boolean);
begin
  FFTPClient.LogAllHex := Value;
end;

procedure TApxFtpClient.SetLogging(const Value: TTraceLogState);
begin
  FFTPClient.Logging := Value;
end;

procedure TApxFtpClient.SetLogHex(const Value: Boolean);
begin
  FFTPClient.LogHex := Value;
end;

procedure TApxFtpClient.SetLogName(const Value: string);
begin
  FFTPClient.LogName := Value;
end;

procedure TApxFtpClient.SetLogSize(const Value: Integer);
begin
  FFTPClient.LogSize := Value;
end;

procedure TApxFtpClient.SetPassiveMode(const Value: Boolean);
begin
  FFTPClient.PassiveMode := Value;
end;

procedure TApxFtpClient.SetPassword(const Value: string);
begin
  FFTPClient.Password := Value;
end;

procedure TApxFtpClient.SetRestartAt(const Value: LongInt);
begin
  FFTPClient.RestartAt := Value;
end;

procedure TApxFtpClient.SetServerAddress(const Value: string);
begin
  FFTPClient.ServerAddress := Value;
end;

procedure TApxFtpClient.SetTransferTimeout(const Value: Integer);
begin
  FFTPClient.TransferTimeout := Value;
end;

procedure TApxFtpClient.SetUserName(const Value: string);
begin
  FFTPClient.UserName := Value;
end;

function TApxFtpClient.Status(const RemotePathName: string): string;
begin
  FFTPState := fsStatus;
  FFTPClient.Status(RemotePathName);
  Result := WaitForStatusString;
end;

function TApxFtpClient.Store(const RemotePathName, LocalPathName: string;
  StoreMode: TFTPStoreMode): Boolean;
begin
  FFTPState := fsStore;
  if StoreMode in [smAppend, smReplace, smUnique] then
    DoFTPLog(lcStore)
  else
    DoFTPLog(lcRestart);
  FFTPClient.Store(RemotePathName, LocalPathName, StoreMode);
  Result := WaitForStatusBool;
  if Result then
    DoFTPLog(lcComplete);
end;

function TApxFtpClient.WaitForStatusBool: Boolean;
var
  Res : Integer;
  {ET : EventTimer;}
begin
  FSucceeded := False;
  FFailed := False;
  {if Connected then
    NewTimer(ET, FTransferTimeout)
  else
    NewTimer(ET, FConnectTimeout);}
  repeat
    Res := SafeYield;
  until (Res = WM_QUIT) {or TimerExpired(ET) }or FSucceeded or FFailed;
  Result := FSucceeded;
end;

function TApxFtpClient.WaitForStatusString: string;
var
  Res : Integer;
  {ET : EventTimer;}
begin
  FSucceeded := False;
  FFailed := False;
  FStoredString := '';
  {if Connected then
    NewTimer(ET, FTransferTimeout)
  else
    NewTimer(ET, FConnectTimeout);}
  repeat
    Res := SafeYield;
  until (Res = WM_QUIT) or (Res = WM_DESTROY){or TimerExpired(ET) }or FSucceeded or FFailed;
  if FSucceeded then
    Result := FStoredString
  else
    Result := '';
end;

end.
