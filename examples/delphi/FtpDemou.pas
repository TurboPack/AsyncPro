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

{*********************************************************}
{*                   FTPDEMOU.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* This example demonstrates how to use Ftp transfers    *}
{*      with Send and Receive options.                   *}
{*********************************************************}

unit FtpDemou;

interface

uses
  WinProcs, WinTypes, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, OoMisc, AdFtp, StdCtrls, Menus, ExtCtrls, FileCtrl,
  AdPort, AdWnPort, TabNotBk, ComCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    ApdFtpClient1: TApdFtpClient;
    File1: TMenuItem;
    Send1: TMenuItem;
    Recieve1: TMenuItem;
    Directory1: TMenuItem;
    List1: TMenuItem;
    Change1: TMenuItem;
    CreateDir1: TMenuItem;
    FullList1: TMenuItem;
    NamesList1: TMenuItem;
    Delete1: TMenuItem;
    Misc1: TMenuItem;
    Help1: TMenuItem;
    SendFtp1: TMenuItem;
    Status1: TMenuItem;
    Rename1: TMenuItem;
    ApdFtpLog1: TApdFtpLog;
    N3: TMenuItem;
    Delete2: TMenuItem;
    Rename2: TMenuItem;
    TabbedNotebook1: TTabbedNotebook;
    Label7: TLabel;
    ServerEdit: TEdit;
    Label2: TLabel;
    UserNameEdit: TEdit;
    Label3: TLabel;
    PasswordEdit: TEdit;
    ReceiveMode1: TRadioGroup;
    SendMode1: TRadioGroup;
    Label1: TLabel;
    TimeoutEdit: TEdit;
    Label6: TLabel;
    RestartEdit: TEdit;
    FileType1: TRadioGroup;
    LoginBtn: TButton;
    LogoutBtn: TButton;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Log1: TMenuItem;
    N4: TMenuItem;
    Login1: TMenuItem;
    Logout1: TMenuItem;
    N2: TMenuItem;
    ExitBtn: TButton;
    Clearmemo1: TMenuItem;
    GroupBox2: TGroupBox;
    InfoMemo: TMemo;
    ReplyMemo: TMemo;
    ReceiveBtn: TButton;
    SendBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure Recieve1Click(Sender: TObject);
    procedure NamesList1Click(Sender: TObject);
    procedure FullList1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure Send1Click(Sender: TObject);
    procedure CreateDir1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure SendFtp1Click(Sender: TObject);
    procedure Status1Click(Sender: TObject);
    procedure Log1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure AbortBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure ApdFtpClient1FtpStatus(Sender: TObject;
      StatusCode: TFtpStatusCode; Info: PChar);
    procedure Login1Click(Sender: TObject);
    procedure ApdFtpClient1FtpError(Sender: TObject; ErrorCode: Integer;
      ErrorText: PChar);
    procedure ApdFtpClient1FtpReply(Sender: TObject; ReplyCode: Integer;
      Reply: PChar);
  private
    { Private declarations }
    procedure Getproperties;
    procedure Setproperties;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  DefCaption = 'FtpDemo: Ftp Client';


function GetFileName(const Caption : string; var FN : string) : Boolean;
begin
  FN := '';
  Result := InputQuery('FtpDemo', Caption, FN);
end;

function GetRemoteDirName(var R : string) : Boolean;
begin
  Result := GetFileName('Remote Directory', R);
end;

function GetRemoteFileName(var R : string) : Boolean;
begin
  Result := GetFileName('Remote file name', R);
end;

function GetRLNames(var R, L : string) : Boolean;
begin
  Result := False;
  if GetFileName('Remote file name', R) then
    Result := GetFileName( 'Local file name', L);
end;

function GetRNNames(var R, N : string) : Boolean;
begin
  Result := False;
  if GetFileName('Remote file name', R) then
    Result := GetFileName('New file name', N);
end;

{------------------------------------------------------------------}
procedure TForm1.GetProperties;
begin
  with ApdFtpClient1 do begin
    UserNameEdit.Text := UserName;
    PasswordEdit.Text := Password;
    ServerEdit.Text := ServerAddress;
    TimeoutEdit.Text := IntToStr(TransferTimeout);
    RestartEdit.Text := IntToStr(RestartAt);
    FileType1.ItemIndex := Integer(FileType);
  end;
end;

procedure TForm1.Setproperties;
begin
  with ApdFtpClient1 do begin
    UserName := UserNameEdit.Text;
    Password := PasswordEdit.Text;
    ServerAddress := ServerEdit.Text;
    TransferTimeout := StrToIntDef(TimeoutEdit.Text, 1092);
    RestartAt := StrToIntDef(RestartEdit.Text, 0);
    FileType := TFtpFileType(FileType1.ItemIndex);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  GetProperties;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Logout1Click(nil);
  Close;
end;

procedure TForm1.Login1Click(Sender: TObject);
begin
  SetProperties;
  if not ApdFtpClient1.Login then
    ShowMessage('ogin failure');
end;

procedure TForm1.Logout1Click(Sender: TObject);
begin
  ApdFtpClient1.Logout;
  InfoMemo.Clear;
end;

procedure TForm1.Change1Click(Sender: TObject);
var
  R : string;
begin
  if GetRemoteDirName(R) then
    if not ApdFtpClient1.ChangeDir(R) then
      ShowMessage('cannot process command');
end;

procedure TForm1.NamesList1Click(Sender: TObject);
var
  R : string;
begin
  if GetFileName('Remote directory or null string', R) then
    if not ApdFtpClient1.ListDir(R, False) then
      ShowMessage('cannot process command');
end;

procedure TForm1.FullList1Click(Sender: TObject);
var
  R : string;
begin
  if GetFileName('Remote directory or null string', R) then
    if not ApdFtpClient1.ListDir(R, True) then
      ShowMessage('cannot process command');
end;

procedure TForm1.Help1Click(Sender: TObject);
var
  C : string;
begin
  C := '';
  if InputQuery('ExFtp1 - Help', 'FTP command', C) then
    if not ApdFtpClient1.Help(C) then
      ShowMessage('cannot process command');
end;

procedure TForm1.Send1Click(Sender: TObject);
var
  R, L : string;
begin
  SetProperties;
  if GetRLNames(R, L) then
    if not ApdFtpClient1.Store(R, L, TFtpStoreMode(SendMode1.ItemIndex)) then
      ShowMessage('cannot process command');
end;

procedure TForm1.Recieve1Click(Sender: TObject);
var
  L, R : string;
begin
  SetProperties;
  if GetRLNames(R, L) then
    if not ApdFtpClient1.Retrieve(R, L, TFtpRetrieveMode(ReceiveMode1.ItemIndex)) then
      ShowMessage('cannot process command');
end;

procedure TForm1.CreateDir1Click(Sender: TObject);
var
  R : string;
begin
  if GetRemoteDirName(R) then
    if not ApdFtpClient1.MakeDir(R) then
      ShowMessage('cannot process command');
end;

procedure TForm1.Delete1Click(Sender: TObject);
var
  R : string;
begin
  if GetRemoteFileName(R) then
    if not ApdFtpClient1.Delete(R) then
      ShowMessage('cannot process command');
end;

procedure TForm1.SendFtp1Click(Sender: TObject);
var
  C : string;
begin
  C := '';
  if InputQuery(DefCaption, 'Ftp command', C) then
    if not ApdFtpClient1.SendFtpCommand(C) then
      ShowMessage('cannot process command');
end;

procedure TForm1.Status1Click(Sender: TObject);
var
  R : string;
begin
  if GetRemoteDirName(R) then
    if not ApdFtpClient1.Status(R) then
      ShowMessage('cannot process command');
end;

procedure TForm1.Log1Click(Sender: TObject);
begin
  Log1.Checked := not Log1.Checked;
  ApdFtpLog1.Enabled := Log1.Checked;
end;

procedure TForm1.Rename1Click(Sender: TObject);
var
  R, N : string;
begin
  if GetRNNames(R, N) then
    if not ApdFtpClient1.Rename(R, N) then
      ShowMessage('cannot process command');
end;

procedure TForm1.AbortBtnClick(Sender: TObject);
begin
  ApdFtpClient1.Abort;
end;

procedure TForm1.ClearBtnClick(Sender: TObject);
begin
  InfoMemo.Clear;
  ReplyMemo.Clear;
end;

procedure TForm1.ApdFtpClient1FtpStatus(Sender: TObject;
  StatusCode: TFtpStatusCode; Info: PChar);
begin
  case StatusCode of
    scClose :
      Caption := DefCaption;
    scOpen :
      Caption := ' connected to ' + ApdFtpClient1.ServerAddress;
    scComplete :
      InfoMemo.Lines.Add('operation complete');
    scDataAvail :
      InfoMemo.Lines.SetText(Info);
    scLogin :
      begin
        Caption := ApdFtpClient1.UserName + ' logged on to ' + ApdFtpClient1.ServerAddress;
        ApdFtpClient1.SendFtpCommand('STAT');
      end;
    scLogout :
      Caption := ApdFtpClient1.UserName + ' logged out';
    scProgress :
      Caption := IntToStr(ApdFtpClient1.BytesTransferred) + ' bytes Transferred';
    scTransferOK :
      Caption := Caption + ' - transfer complete';
    scTimeout :
      ShowMessage('Transfer timed out');
  end;
end;

procedure TForm1.ApdFtpClient1FtpError(Sender: TObject; ErrorCode: Integer;
  ErrorText: PChar);
var
  MBCaption : array[0..25] of Char;
begin
  StrPCopy(MBCaption, 'FTP Error: ' + IntToStr(ErrorCode));
  MessageBox(Handle, ErrorText, MBCaption, MB_ICONEXCLAMATION or MB_OK);
end;

procedure TForm1.ApdFtpClient1FtpReply(Sender: TObject; ReplyCode: Integer;
  Reply: PChar);
begin
  ReplyMemo.Lines.Add(StrPas(Reply));
end;

end.
