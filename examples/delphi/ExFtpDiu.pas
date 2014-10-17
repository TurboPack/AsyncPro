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

{***********************************************************}
{*                      ExFtpDiu.PAS                       *}
{***********************************************************}

{**********************Description**************************}
{*This is a simple example that demonstrates how to login, *}
{*     logout, and show current directory for a FTP server.*}
{***********************************************************}

unit ExFtpDiu;

interface

uses
  WinProcs, WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  Dialogs, OoMisc, AdPort, AdWnPort, AdFtp, StdCtrls;

type
  TForm1 = class(TForm)
    ApdFtpClient1: TApdFtpClient;
    btnLogin: TButton;
    btnLogout: TButton;
    lbxCurrentDir: TListBox;
    Label1: TLabel;
    edtServer: TEdit;
    edtUser: TEdit;
    Label2: TLabel;
    edtPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    btnClose: TButton;
    Label5: TLabel;
    procedure ApdFtpClient1FtpStatus(Sender: TObject;
      StatusCode: TFtpStatusCode; InfoText: PChar);
    procedure btnLoginClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure ApdFtpClient1FtpError(Sender: TObject; ErrorCode: Integer;
      ErrorText: PChar);
    procedure lbxCurrentDirMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbxCurrentDirDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure ApdFtpClient1WsError(Sender: TObject; ErrCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  SelectedDir : string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  with ApdFtpClient1 do begin
    edtServer.Text   := ServerAddress;
    edtUser.Text     := UserName;
    edtPassword.Text := Password;
  end;
end;

procedure TForm1.btnLoginClick(Sender: TObject);
begin
  with ApdFtpClient1 do begin
    ServerAddress := edtServer.Text;
    UserName      := edtUser.Text;
    Password      := edtPassword.Text;
    Login;
  end;
end;

procedure TForm1.btnLogoutClick(Sender: TObject);
begin
  ApdFtpClient1.Logout;
end;

procedure TForm1.lbxCurrentDirMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
begin
  i := lbxCurrentDir.ItemAtPos(Point(X, Y), True);
  if (i > -1) then
    SelectedDir := lbxCurrentDir.Items[i];
end;

procedure TForm1.lbxCurrentDirDblClick(Sender: TObject);
begin
  ApdFtpClient1.ChangeDir(SelectedDir);
end;

procedure TForm1.ApdFtpClient1FtpStatus(Sender: TObject;
  StatusCode: TFtpStatusCode; InfoText: PChar);
begin
  case StatusCode of
    scLogin      : ApdFtpClient1.CurrentDir;
    scLogout     : begin
                     lbxCurrentDir.Clear;
                     Caption := 'ExFtpDir';
                   end;
    scComplete   : ApdFtpClient1.CurrentDir;
    scCurrentDir : begin
                     Caption := StrPas(InfoText);
                     ApdFtpClient1.ListDir('', False);
                   end;
    scDataAvail  : with LbxCurrentDir.Items do begin
                     Text := StrPas(InfoText);
                     Insert(0, '..');
                     Insert(0, '.');
                   end;
  end;
end;

procedure TForm1.ApdFtpClient1FtpError(Sender: TObject; ErrorCode: Integer;
  ErrorText: PChar);
begin
  Caption := StrPas(ErrorText);
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  ApdFtpClient1.Logout;
  Close;
end;

procedure TForm1.ApdFtpClient1WsError(Sender: TObject; ErrCode: Integer);
begin
  ShowMessage('WsError');
end;

end.
