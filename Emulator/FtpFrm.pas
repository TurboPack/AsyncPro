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
 * The Original Code is LNS Software Systems
 *
 * The Initial Developer of the Original Code is LNS Software Systems
 *
 * Portions created by the Initial Developer are Copyright (C) 1998-2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)
unit FtpFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Ftpcli, OoMisc, AdPort, AdWnPort, AdFtp;

const
  FTP_MSG       = WM_USER + 1;

type
  TState = (sNotConnected, sConnecting, sDisconnecting, sDisconnected,
            sIdle, sGetDir, sGetDirFiles, sChangeDir,
            sDeleting, sRenaming, sReceiving, sSending);

  TFtpAction = (faLogoff, faGetDir, faGetDirFiles, faReceive, faSend);

  TDirType = (dtUnix, dtWindows);

  TFtpForm = class(TForm)
    StatusWindow: TMemo;
    Localpanel: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    LocalDirEdit: TEdit;
    Label4: TLabel;
    RemoteDirEdit: TEdit;
    LocalDirs: TListView;
    LocalFiles: TListView;
    LCopyBtn: TButton;
    LDelBtn: TButton;
    LRenBtn: TButton;
    LChDirBtn: TButton;
    RemoteDirs: TListView;
    RemoteFiles: TListView;
    RChDirBtn: TButton;
    RCopyBtn: TButton;
    RDelBtn: TButton;
    RRenBtn: TButton;
    GroupBox1: TGroupBox;
    AsciiXferBtn: TRadioButton;
    BinaryXferBtn: TRadioButton;
    Label5: TLabel;
    Ftp: TApdFtpClient;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LocalDirEditExit(Sender: TObject);
    procedure LocalDirEditKeyPress(Sender: TObject; var Key: Char);
    procedure LocalDirsDblClick(Sender: TObject);
    procedure LCopyBtnClick(Sender: TObject);
    procedure LChDirBtnClick(Sender: TObject);
    procedure RChDirBtnClick(Sender: TObject);
    procedure RemoteDirEditExit(Sender: TObject);
    procedure RemoteDirEditKeyPress(Sender: TObject; var Key: Char);
    procedure RemoteDirsDblClick(Sender: TObject);
    procedure AsciiXferBtnClick(Sender: TObject);
    procedure BinaryXferBtnClick(Sender: TObject);
    procedure RCopyBtnClick(Sender: TObject);
    procedure LDelBtnClick(Sender: TObject);
    procedure RDelBtnClick(Sender: TObject);
    procedure LRenBtnClick(Sender: TObject);
    procedure LocalFilesEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure RRenBtnClick(Sender: TObject);
    procedure RemoteFilesEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure FtpFtpStatus(Sender: TObject; StatusCode: TFtpStatusCode;
      InfoText: PChar);
    procedure FtpFtpError(Sender: TObject; ErrorCode: Integer;
      ErrorText: PChar);
    procedure FormDestroy(Sender: TObject);
    procedure FtpFtpReply(Sender: TObject; ReplyCode: Integer;
      ReplyText: PChar);
  private
    FState          : TState;
    FCurFileName    : String;
    FCurFileSize    : Integer;
    FFilesToXfer    : TStringList;

    procedure BuildFileList(ctrl: TListView);
    function  DirType(line: String): TDirType;
    procedure FtpMsg(var Message: TMessage); message FTP_MSG;
    function  GetHostName : String;
    function  GetUserId   : String;
    function  GetPasswd   : String;
    procedure SetHostName(hname : String);
    procedure SetUserId(uid : String);
    procedure SetPasswd(pwd : String);
    procedure ShowLocalFiles;
    procedure ShowRemoteFiles(dir: String);
    function IsDirectory(bfr: String): Boolean;
    function GetFileName(bfr: String): String;
    function StrTok(s: String; delim: Char; num: Integer): String;
    function GetDateTime(bfr: String): String;
    function GetSize(bfr: String): String;
  public
    property HostName  : String read GetHostName write SetHostName;
    property UserId    : String read GetUserId write SetUserId;
    property Passwd    : String read GetPasswd write SetPasswd;
  end;

var
  FtpForm: TFtpForm;

implementation

uses FtpProgressFrm, Registry, EmulatorFrm;

{$R *.DFM}
function  TFtpForm.GetHostName : String;
begin
    Result := Ftp.ServerAddress;
end;

function TFtpForm.GetUserId : String;
begin
    Result := Ftp.Username;
end;

function TFtpForm.GetPasswd : String;
begin
    Result := Ftp.Password;
end;

procedure TFtpForm.SetHostName(hname : String);
var
    reg         : TRegistry;
    bStat       : Boolean;
    hostKey     : String;

begin
    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        hostKey := HostsKey + '\' + hname;
        bStat := reg.OpenKey(hostKey, False);
        if (not bStat) then
            raise Exception.CreateFmt('Internal error.  Could not open ' +
                                      'registry key for host %s',
                                      [hname]);
        Ftp.ServerAddress := reg.ReadString('IPAddress');
   finally
       reg.Free;
   end;
end;

procedure TFtpForm.SetUserId(uid : String);
begin
    Ftp.UserName := uid;
end;

procedure TFtpForm.SetPasswd(pwd : String);
begin
    Ftp.Password := pwd;
end;
// Build a list of files to be transferred in FFilesToXfer
procedure TFtpForm.BuildFileList(ctrl: TListView);
var
    i           : Integer;
begin
    // Build the list of files to retrieve
    FFilesToXfer.Clear;
    for i:=0 to (ctrl.Items.Count - 1) do
        if (ctrl.Items[i].Selected) then
            FFilesToXfer.Add(Format('%s=%s',
                                    [ctrl.Items[i].Caption,
                                     ctrl.Items[i].SubItems[1]]));
end;

procedure TFtpForm.ShowLocalFiles;
var
    dir       : String;
    stat      : Integer;
    sr        : TSearchRec;
    li        : TListItem;
    sysMod    : TSystemTime;

begin
    LocalFiles.Items.Clear;
    LocalDirs.Items.Clear;

    dir := GetCurrentDir;
    LocalDirEdit.Text := dir;
    if ((dir <> '') and (dir[Length(dir)] = '\')) then
        dir := Copy(dir, 1, Length(dir)-1);
    stat := FindFirst(dir + '\*.*',
                      faAnyFile,
                      sr);
    try
        while (stat = 0) do
        begin
            if ((sr.Attr and faDirectory) = 0) then
            begin
                li := LocalFiles.Items.Add;
                li.Caption := sr.Name;
                FileTimeToSystemTime(sr.FindData.ftLastWriteTime, sysMod);
                li.SubItems.Add(DateTimeToStr(SystemTimeToDateTime(sysMod)));
                li.SubItems.Add(IntToStr(sr.Size));
            end else
            begin
                li := LocalDirs.Items.Add;
                li.Caption := sr.Name;
            end;
            stat := FindNext(sr);
        end;
    finally
        FindClose(sr);
    end;
end;
// Populate the remote directory and file lists from the directory info
// returned by the remote host.
//
// dir contains 1 line for each directory / file. The format of each line is:
//
// For Windows Systems
// <date> <time> <type> <path>
//
// where <type> is '<DIR>' or an empty string
//
// *** OR ***
//
// For Unix Systems
// <permissions> <?> <user> <group> <size> <month> <day> <year_or_time> <path>
procedure TFtpForm.ShowRemoteFiles(dir: String);
var
    line        : String;
    split       : Integer;
    dotSeen     : Boolean;
    dotdotSeen  : Boolean;
    fname       : String;
    li          : TListItem;
begin
    RemoteDirs.Items.Clear;
    RemoteFiles.Items.Clear;
    dotseen := False;
    dotdotseen := False;
    while (dir <> '') do
    begin
        // Get the next line from the directory list
        split := Pos(#10, dir);
        if (split > 0) then
        begin
            line := Trim(Copy(dir, 1, split - 1));
            dir := Trim(Copy(dir, split + 1, MaxInt));
        end else
        begin
            line := Trim(dir);
            dir := '';
        end;
        while (line[Length(line)] = #13) do
            line := Trim(Copy(line, 1, Length(line) - 1));
        if (line <> '') then
        begin
            // Extract the info that we need from the directory line
            fname := GetFileName(line);
            if (fname <> '') then
            begin
                if (IsDirectory(line)) then
                begin
                    li := RemoteDirs.Items.Add;
                    li.Caption := fname;
                    if (fname = '.') then
                        dotSeen := True
                    else
                        if (fname = '..') then
                            dotdotSeen := True;
                end else
                begin
                    li := RemoteFiles.Items.Add;
                    li.Caption := fname;
                    li.SubItems.Add(GetDateTime(line));
                    li.SubItems.Add(GetSize(line));
                end;
            end;
        end;
    end;
    //  Make sure . and .. directories are included since these are
    //  not returned by Windows systems
    if (not dotseen) then
    begin
        li := RemoteDirs.Items.Add;
        li.Caption := '.';
    end;
    if (not dotdotseen) then
    begin
        li := RemoteDirs.Items.Add;
        li.Caption := '..';
    end;
end;

procedure TFtpForm.FormShow(Sender: TObject);
begin
    FFilesToXfer := TStringList.Create;
    FState := sNotConnected;
    if (Ftp.FileType = ftBinary) then
    begin
        BinaryXferBtn.Checked := True;
        AsciiXferBtn.Checked := False;
    end else
    begin
        BinaryXferBtn.Checked := False;
        AsciiXferBtn.Checked := True;
    end;
    ShowLocalFiles;
    FState := sConnecting;
    if (not Ftp.Login) then
    begin
        ShowMessage('Could not login to FTP site. Login failed!');
        FState := sNotConnected;
        PostMessage(Handle, WM_CLOSE, 0, 0);
    end;
end;

procedure TFtpForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (FState = sNotConnected) then
        Action := caHide
    else
    begin
        Action := caNone;
        PostMessage(Handle, FTP_MSG, wParam(faLogoff), 0);
    end;
end;

procedure TFtpForm.LocalDirEditExit(Sender: TObject);
begin
    LocalDirEdit.Text := TrimLeft(TrimRight(LocalDirEdit.Text));
    ChDir(LocalDirEdit.Text);
    ShowLocalFiles;
end;

procedure TFtpForm.LocalDirEditKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #13) then
        LocalDirEditExit(LocalDirEdit);
end;

procedure TFtpForm.LocalDirsDblClick(Sender: TObject);
begin
    with LocalDirs do
    begin
        if (SelCount > 0) then
        begin
            ChDir(Selected.Caption);
            ShowLocalFiles;
        end;
    end;
end;

procedure TFtpForm.LCopyBtnClick(Sender: TObject);
begin
    if (LocalFiles.SelCount = 0) then
        raise Exception.Create('Please select one or more files from the ' +
                               'left hand list.');

    if (FState = sIdle) then
    begin
        BuildFileList(LocalFiles);

        Screen.Cursor := crHourGlass;
        PostMessage(Handle, FTP_MSG, wParam(faSend), 0);
    end;
end;

procedure TFtpForm.LChDirBtnClick(Sender: TObject);
begin
    LocalDirEditExit(LocalDirEdit);
end;

procedure TFtpForm.RChDirBtnClick(Sender: TObject);
begin
    if (FState = sIdle) then
    begin
        RemoteDirEdit.Text := Trim(RemoteDirEdit.Text);
        FState := sChangeDir;
        if (not Ftp.ChangeDir(RemoteDirEdit.Text)) then
        begin
            ShowMessage('Could not change directory.  ChangeDir failed!');
            FState := sIdle;
        end;
    end;
end;

procedure TFtpForm.RemoteDirEditExit(Sender: TObject);
begin
    RChDirBtnClick(RChDirBtn);
end;

procedure TFtpForm.RemoteDirEditKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #13) then
        RChDirBtnClick(RChDirBtn);
end;

procedure TFtpForm.RemoteDirsDblClick(Sender: TObject);
begin
    if (FState = sIdle) then
        with RemoteDirs do
        begin
            if (SelCount > 0) then
            begin
                FState := sChangeDir;
                if (not Ftp.ChangeDir(Selected.Caption)) then
                begin
                    ShowMessage('Could not change directory.  ChangeDir failed!');
                    FState := sIdle;
                end;
            end;
        end;
end;

procedure TFtpForm.AsciiXferBtnClick(Sender: TObject);
begin
    BinaryXferBtn.Checked := not AsciiXferBtn.Checked;
    if (AsciiXferBtn.Checked) then
        Ftp.FileType := ftAscii
    else
        Ftp.FileType := ftBinary;
end;

procedure TFtpForm.BinaryXferBtnClick(Sender: TObject);
begin
    AsciiXferBtn.Checked := not BinaryXferBtn.Checked;
    if (BinaryXferBtn.Checked) then
        Ftp.FileType := ftBinary
    else
        Ftp.FileType := ftAscii;
end;

procedure TFtpForm.RCopyBtnClick(Sender: TObject);
begin
    if (RemoteFiles.SelCount = 0) then
        raise Exception.Create('Please select one or more files from the ' +
                               'right hand list.');

    if (FState = sIdle) then
    begin
        BuildFileList(RemoteFiles);

        Screen.Cursor := crHourGlass;
        PostMessage(Handle, FTP_MSG, wParam(faReceive), 0);
    end;
end;

procedure TFtpForm.LDelBtnClick(Sender: TObject);
var
    i        : Integer;
    stat     : Integer;

begin
    if (LocalFiles.SelCount = 0) then
        raise Exception.Create('Please select one or more files from the ' +
                               'left hand list.');

    stat := Application.MessageBox('Do you really want to delete these files?',
                                   'FTP',
                                   MB_APPLMODAL or MB_ICONQUESTION or
                                   MB_YESNO);
    if (stat <> IDYES) then
        Exit;

    for i:=0 to (LocalFiles.Items.Count-1) do
    begin
        if (LocalFiles.Items[i].Selected) then
            DeleteFile(LocalFiles.Items[i].Caption);
    end;
    ShowLocalFiles;
end;

procedure TFtpForm.RDelBtnClick(Sender: TObject);
var
    stat     : Integer;
begin
    if (RemoteFiles.SelCount = 0) then
        raise Exception.Create('Please select one or more files from the ' +
                               'right hand list.');

    if (FState = sIdle) then
    begin
        stat := Application.MessageBox('Do you really want to delete these files?',
                                       'FTP',
                                       MB_APPLMODAL or MB_ICONQUESTION or
                                       MB_YESNO);
        if (stat <> IDYES) then
            Exit;

        Screen.Cursor := crHourGlass;
        BuildFileList(RemoteFiles);
        FState := sDeleting;
        FCurFileName := FFilesToXfer.Names[0];
        if (not Ftp.Delete(FCurFileName)) then
        begin
            ShowMessage('Could not delete file. Delete failed!');
            FState := sIdle;
            Screen.Cursor := crDefault;
        end;
    end;
end;

procedure TFtpForm.LRenBtnClick(Sender: TObject);
var
    i        : Integer;

begin
    if (LocalFiles.SelCount = 0) then
        raise Exception.Create('Please select one or more files from the ' +
                               'left hand list.');

    for i:=0 to (LocalFiles.Items.Count-1) do
    begin
        if (LocalFiles.Items[i].Selected) then
        begin
            LocalFiles.Items[i].EditCaption;
        end;
    end;
end;

procedure TFtpForm.LocalFilesEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
    if (S <> Item.Caption) then
    begin
        MoveFile(PChar(Item.Caption), PChar(S));
        ShowLocalFiles;
    end;
end;

procedure TFtpForm.RRenBtnClick(Sender: TObject);
var
    i        : Integer;

begin
    if (RemoteFiles.SelCount = 0) then
        raise Exception.Create('Please select one or more files from the ' +
                               'right hand list.');

    if (FState = sIdle) then
        for i:=0 to (RemoteFiles.Items.Count-1) do
        begin
            if (RemoteFiles.Items[i].Selected) then
            begin
                RemoteFiles.Items[i].EditCaption;
            end;
        end;
end;

procedure TFtpForm.RemoteFilesEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
    if ((FState = sIdle) and (S <> Item.Caption)) then
    begin
        FState := sRenaming;
        if (not Ftp.Rename(Item.Caption, S)) then
        begin
            ShowMessage('Could not rename file. Rename failed!');
            S := Item.Caption;
            FState := sIdle;
        end;
    end;
end;
//  Return dtUnix if the directory line is in Unix format, return
//  dtWindows otherwise.  Windows directory lines begin with the
//  file time, so the presesnce of a numberic character in the first
//  position should indicate a Windows system.
function TFtpForm.DirType(line: String): TDirType;
begin
    if ((line <> '') and
        (line[1] >= '0') and
        (line[1] <= '9')) then
        Result := dtWindows
    else
        Result := dtUnix;
end;
//  Return True if directory item given by bfr is a directory.  Return False
//  if a file.
function TFtpForm.IsDirectory(bfr: String): Boolean;
var
    stemp       : String;
begin
    if (DirType(bfr) = dtUnix) then
    begin
        stemp := Copy(bfr, 1, 1);
        Result := (stemp = 'd');
    end else
    begin
        stemp := StrTok(bfr, ' ', 3);
        Result := (stemp = '<DIR>');
    end;
end;
//  Return the file name contained in the directory item given by bfr
function TFtpForm.GetFileName(bfr: String): String;
begin
    if (DirType(bfr) = dtUnix) then
        Result := StrTok(bfr, ' ', 9)
    else
        Result := StrTok(bfr, ' ', 4);
end;
//  Return the nth token from string.  Tokens are delimited by one or more
//  occurences of delim.
function TFtpForm.StrTok(s: String; delim: Char; num: Integer): String;
var
    i           : Integer;
begin
    i := 1;
    Result := '';
    while ((i <= Length(s)) and (num > 0)) do
    begin
        if (s[i] <> delim) then
        begin
            if (num = 1) then
                Result := Result + s[i];
            Inc(i);
        end else
        begin
            Dec(num);
            while ((i <= Length(s)) and (s[i] = delim)) do
                Inc(i);
        end;
    end;
end;
//  Return the date and time from the directory entry given by bfr
function TFtpForm.GetDateTime(bfr: String): String;
begin
    if (DirType(bfr) = dtUnix) then
        Result := StrTok(bfr, ' ', 6) + ' ' + StrTok(bfr, ' ', 7) + ' ' +
                  StrTok(bfr, ' ', 8)
    else
        Result := StrTok(bfr, ' ', 1) + ' ' + StrTok(bfr, ' ', 2);
end;
//  Return the file size from the directory entry given by bfr
function TFtpForm.GetSize(bfr: String): String;
begin
    if (DirType(bfr) = dtUnix) then
        Result := StrTok(bfr, ' ', 5)
    else
        Result := StrTok(bfr, ' ', 3);
end;
// Update our state depending on the FTP status events received
procedure TFtpForm.FtpFtpStatus(Sender: TObject;
  StatusCode: TFtpStatusCode; InfoText: PChar);
begin
    case StatusCode of
      scLogin:
      begin
        if (FState = sConnecting) then
        begin
            FState := sIdle;
            PostMessage(Handle, FTP_MSG, wParam(faGetDir), 0);
        end;
      end;

      scClose:
      begin
        if (FState = sConnecting) then
            ShowMessage('Could not login to FTP server. Connection closed');
        FState := sNotConnected;
        PostMessage(Handle, WM_CLOSE, 0, 0);
      end;

      scCurrentDir:
      begin
        if (FState = sGetDir) then
        begin
            RemoteDirEdit.Text := String(InfoText);
            FState := sIdle;
            PostMessage(Handle, FTP_MSG, wParam(faGetDirFiles), 0);
        end;
      end;

      scDataAvail:
      begin
        if (FState = sGetDirFiles) then
        begin
            ShowRemoteFiles(InfoText);
            FState := sIdle;
        end;
      end;

      scComplete:
      begin
        case FState of
          sChangeDir:
          begin
            FState := sIdle;
            PostMessage(Handle, FTP_MSG, wParam(faGetDir), 0);
          end;

          sDeleting:
          begin
            StatusWindow.Lines.Add(Format('Deleted %s', [FCurFileName]));
            FState := sIdle;
            FFilesToXfer.Delete(0);
            if (FFilesToXfer.Count > 0) then
            begin
                FState := sDeleting;
                FCurFileName := FFilesToXfer.Names[0];
                if (not Ftp.Delete(FCurFileName)) then
                begin
                    ShowMessage('Could not delete file.  Delete failed!');
                    FState := sIdle;
                end;
            end else
            begin
                Screen.Cursor := crDefault;
                PostMessage(Handle, FTP_MSG, wParam(faGetDirFiles), 0);
            end;
          end;

          sRenaming:
            FState := sIdle;
        end;
      end;

      scProgress:
      begin
        if ((FState = sReceiving) or
            (FState = sSending)) then
        begin
            StatusWindow.Lines.Add(Format('Transferring %s - %d of %d bytes',
                                          [FCurFileName,
                                           Ftp.BytesTransferred,
                                           FCurFileSize]));
            with FtpProgressForm do
            begin
                if (not Visible) then
                    Show;
                SetParams('Copying ' + FCurFilename, 0, FCurFileSize);
                BarPosition := Ftp.BytesTransferred;
                Application.ProcessMessages;
            end;
        end;
      end;

      scTransferOk:
      begin
        StatusWindow.Lines.Add(Format('Transfer of %s complete',
                                      [FCurFileName]));
        // Set up to transfer the next file
        FFilesToXfer.Delete(0);
        if (FFilesToXfer.Count > 0) then
        begin
            case FState of
              sReceiving:
              begin
                FState := sIdle;
                PostMessage(Handle, FTP_MSG, wParam(faReceive), 0);
              end;

              sSending:
              begin
                FState := sIdle;
                PostMessage(Handle, FTP_MSG, wParam(faSend), 0);
              end;
            end;
        end else
        begin
            Screen.Cursor := crDefault;
            FtpProgressForm.Close;
            case FState of
              sReceiving:
              begin
                FState := sIdle;
                ShowLocalFiles;
              end;

              sSending:
              begin
                FState := sIdle;
                PostMessage(Handle, FTP_MSG, wParam(faGetDirFiles), 0);
              end;

              else
                FState := sIdle;
            end;
        end;
      end;
    end;
end;

procedure TFtpForm.FtpFtpError(Sender: TObject; ErrorCode: Integer;
  ErrorText: PChar);
begin
    ShowMessageFmt('FTP Error. %s', [ErrorText]);
    case FState of
      sConnecting:
        PostMessage(Handle, FTP_MSG, wParam(faLogoff), 0);

      sDisconnecting:
      begin
        FState := sDisconnected;
        PostMessage(Handle, WM_CLOSE, 0, 0);
      end;

      sGetDir,
      sGetDirFiles,
      sChangeDir,
      sReceiving,
      sSending,
      sDeleting,
      sRenaming:
        FState := sIdle;
    end;
end;
// Process our messages to ourself.  wParam tells us what to do
procedure TFtpForm.FtpMsg(var Message: TMessage);
begin
    case TFtpAction(Message.WParam) of
      faLogoff:
      begin
        FState := sDisconnecting;
        if (not Ftp.Logout) then
        begin
            FState := sNotConnected;
            PostMessage(Handle, WM_CLOSE, 0, 0);
        end;
      end;

      faGetDir:
      begin
        if (FState = sIdle) then
        begin
            FState := sGetDir;
            if (not Ftp.CurrentDir) then
            begin
                ShowMessage('Could not get current directory. CurrentDir failed!');
                FState := sIdle;
                PostMessage(Handle, FTP_MSG, wParam(faLogoff), 0);
            end;
        end;
      end;

      faGetDirFiles:
      begin
        if (Fstate = sIdle) then
        begin
            FState := sGetDirFiles;
            if (not Ftp.ListDir('', True)) then
            begin
                ShowMessage('Could not get list of files in current directory.' +
                            'ListDir failed!');
                FState := sIdle;
                PostMessage(Handle, FTP_MSG, wParam(faLogoff), 0);
            end;
        end;
      end;

      faReceive:
      begin
        if (FState = sIdle) then
        begin
            FCurFileName := FFilesToXfer.Names[0];
            try
                FCurFileSize := StrToInt(FFilesToXfer.Values[FCurFileName]);
            except
                FCurFileSize := 0;
            end;
            FState := sReceiving;
            if (not Ftp.Retrieve(FCurFileName,
                                 FCurFileName,
                                 rmReplace)) then
            begin
                ShowMessage('Could not transfer file.  Retrieve failed!');
                FState := sIdle;
                Screen.Cursor := crDefault;
            end;
        end;
      end;

      faSend:
      begin
        if (FState = sIdle) then
        begin
            FCurFileName := FFilesToXfer.Names[0];
            try
                FCurFileSize := StrToInt(FFilesToXfer.Values[FCurFileName]);
            except
                FCurFileSize := 0;
            end;
            FState := sSending;
            if (not Ftp.Store(FCurFileName,
                              FCurFileName,
                              smReplace)) then
            begin
                ShowMessage('Could not transfer file.  Retrieve failed!');
                FState := sIdle;
                Screen.Cursor := crDefault;
            end;
        end;
      end;
    end;
end;

procedure TFtpForm.FormDestroy(Sender: TObject);
begin
    if (Assigned(FFilesToXfer)) then
        FFilesToXfer.Free;
end;

procedure TFtpForm.FtpFtpReply(Sender: TObject; ReplyCode: Integer;
  ReplyText: PChar);
begin
    StatusWindow.Lines.Add(Format('%d - %s', [ReplyCode, String(ReplyText)]));
end;

end.
