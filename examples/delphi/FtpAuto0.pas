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
{*                   FTPAUTO0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* This example demonstrates how to automate the process *}
{*       of downloading files from a FTP host            *}
{*********************************************************}

unit FtpAuto0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OoMisc, AdPort, AdWnPort, AdFtp, ExtCtrls;

type
  TForm1 = class(TForm)
    ApdFtpClient1: TApdFtpClient;
    GroupBox1: TGroupBox;
    btnLogin: TButton;
    btnLogout: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtURL: TEdit;
    edtUsername: TEdit;
    edtPassword: TEdit;
    GroupBox2: TGroupBox;
    lbxFiles: TListBox;
    Memo1: TMemo;
    Label5: TLabel;
    edtLocalDir: TEdit;
    procedure btnLoginClick(Sender: TObject);
    procedure ApdFtpClient1FtpStatus(Sender: TObject; StatusCode: TFtpStatusCode;
      InfoText: PChar);
    procedure btnLogoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApdFtpClient1FtpError(Sender: TObject; ErrorCode: Integer;
      ErrorText: PChar);
    procedure FormDestroy(Sender: TObject);
    procedure lbxFilesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbxFilesDblClick(Sender: TObject);
  private
    procedure RetrieveNext;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  DownloadList : TStringList; { list files to be transfered }
  CurrentFile  : string;      { file currently being transfered }
  SelectedDir  : string;      { current working directory }


procedure TForm1.FormCreate(Sender: TObject);
begin
  edtURL.Text      := ApdFtpClient1.ServerAddress;
  edtUsername.Text := ApdFtpClient1.Username;
  edtPassword.Text := ApdFtpClient1.Password;
  DownloadList     := TStringList.Create;
end;

procedure TForm1.btnLoginClick(Sender: TObject);
begin
  ApdFtpClient1.ServerAddress := edtURL.Text;
  ApdFtpClient1.Username      := edtUsername.Text;
  ApdFtpClient1.Password      := edtPassword.Text;
  ApdFtpClient1.Login;
end;

procedure TForm1.btnLogoutClick(Sender: TObject);
begin
  ApdFtpClient1.Logout;
end;

procedure TForm1.ApdFtpClient1FtpStatus(Sender: TObject; StatusCode: TFtpStatusCode;
  InfoText: PChar);
begin
  case StatusCode of
    scLogout :     { cleanup lists }
      begin
        Caption := 'Logged out';
        lbxFiles.Clear;
        DownloadList.Clear;
      end;
    scLogin :      { request name of CWD }
      begin
        Caption := 'Logged in';
        ApdFtpClient1.CurrentDir;
      end;
    scCurrentDir : { request a list of files in CWD }
      ApdFtpClient1.ListDir('', False);
    scComplete :   { CWD changed, request its name }
      ApdFtpClient1.CurrentDir;
    scDataAvail :  { file list data, download 1st in the list }
      begin
        lbxFiles.Items.Text := StrPas(InfoText);
        DownloadList.Assign(lbxFiles.Items);
        lbxFiles.Items.Insert(0, '..');
        lbxFiles.Items.Insert(0, '.');
        RetrieveNext;
      end;
    scProgress :   { display download progress }
      Caption := CurrentFile + '  ' + IntToStr(ApdFtpClient1.BytesTransferred);
    scTransferOK : { file downloaded, download the next in list }
      begin
        if (DownloadList.Count > 0) then
          DownloadList.Delete(0);
        RetrieveNext;
      end;
  end;
end;

procedure TForm1.RetrieveNext; { download next file }
begin
  if (DownloadList.Count > 0) then begin
    CurrentFile := DownloadList[0];
    Caption := DownloadList[0];
    ApdFtpClient1.Retrieve(DownloadList[0],
      edtLocalDir.Text + '\' + DownloadList[0],rmReplace);
  end;
end;

procedure TForm1.ApdFtpClient1FtpError(Sender: TObject; ErrorCode: Integer;
  ErrorText: PChar);
begin
  if (DownloadList.Count > 0) then
    DownloadList.Delete(0);
  RetrieveNext;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  DownloadList.Free;
end;

procedure TForm1.lbxFilesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
begin
  i := lbxFiles.ItemAtPos(Point(X, Y), True);
  if (i > -1) then
    SelectedDir := lbxFiles.Items[i];
end;

procedure TForm1.lbxFilesDblClick(Sender: TObject);
begin
  ApdFtpClient1.ChangeDir(SelectedDir);
end;

end.
