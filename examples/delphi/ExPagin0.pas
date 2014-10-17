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
{*                   EXPAGIN0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{*          A paging demonstration program               *}
{*********************************************************}

unit ExPagin0;

interface

uses
{$ifndef WIN32 }
  WinTypes, WinProcs,
{$else }
  Windows,
{$endif }
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, IniFiles, FileCtrl,
  OoMisc, AdPort, AdWnPort, AdPager;

type
  TForm1 = class(TForm)
    btnSend: TButton;
    mmoMsg: TMemo;
    Label1: TLabel;
    Label4: TLabel;
    pnlStatus: TPanel;
    btnExit: TButton;
    bvlStatus1: TBevel;
    Label7: TLabel;
    btnDisconnect: TButton;
    ComPort: TApdComPort;
    TAPPager: TApdTAPPager;
    Label3: TLabel;
    edPagerAddr: TEdit;
    edPagerID: TEdit;
    WinsockPort: TApdWinsockPort;
    TAPLog: TApdPagerLog;
    SNPPPager: TApdSNPPPager;
    SNPPLog: TApdPagerLog;
    mmoPageStatus: TMemo;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    cbLogging: TCheckBox;
    btnViewLog: TButton;
    btnClearLog: TButton;
    GroupBox2: TGroupBox;
    lbUsers: TListBox;
    btnAdd: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure PageEvent(Sender: TObject; Event: TTAPStatus);
    procedure mmoMsgChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbLoggingClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbUsersClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure ComPortTriggerAvail(CP: TObject; Count: Word);
    procedure btnViewLogClick(Sender: TObject);
    procedure btnClearLogClick(Sender: TObject);
    procedure SNPPPagerSNPPEvent(Sender: TObject; Code: Integer;
      Msg: String);

  private
    { Private declarations }
    procedure GetUsers;
    procedure AddEntry(const Name, Protocol, Addr, PagerID: string);
    function GetEntry(User: string): string;
    function GetCurUser: string;
    procedure SendBySNPP;
    procedure SendByTAP;
    procedure SNPPQuit;
    procedure ClearEds;
    procedure GetUserInfo(User: string);
    procedure UpdateMessage;
    procedure TAPQuit;
    procedure ClearCurVars;
    procedure SetLogFiles;
    procedure ClearLog;
    procedure ViewLog;
    procedure SetStatus(StatusMsg: string);
    procedure InitLogFile;

    procedure SetLogging(AreLogging: Boolean);
    function GetLogging: Boolean;
  public
    { Public declarations }
    PacketCt, AckCt: Integer;
    Cancelled : Boolean;

    PagerList, PagerINI: TIniFile;
    LineBuff: string;  { status monitor buffering }

    PageType, CurUser, CurPagerAddress, CurWSPort, CurPagerID: string;

    LogName: string;

    property Logging: boolean
      read GetLogging write SetLogging;
  end;

var
  Form1: TForm1;

implementation

uses ExPagin1, ExPagin2;

{$R *.DFM}

const
  PAGER_FILE = 'PAGERS.LST';
  PAGER_INIT = 'PAGING.INI';

  EntryType: array [0..1] of string = ('TAP', 'SNPP');

{ Form Methods }
procedure TForm1.FormCreate(Sender: TObject);
begin
  ClearCurVars;
  PageType        := 'TAP';

  PagerList := TIniFile.Create(ExtractFilePath(Application.ExeName) + PAGER_FILE);
  GetUsers;
  ClearEds;

  PagerINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + PAGER_INIT);
  Logging := PagerINI.ReadBool('INIT', 'LOGGING', FALSE);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  UpdateMessage;
end;

procedure TForm1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Cancelled := TRUE;
  TAPQuit;
  SNPPQuit;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  PagerList.Free;
  PagerINI.Free;
end;

{ Communications Event Handlers }
procedure TForm1.ComPortTriggerAvail(CP: TObject; Count: Word);
var
  Ch: Char;
  i: Word;
begin
  for i := 1 to Count do begin
    Ch := ComPort.GetChar;
    case Ch of
      #13: begin
        mmoPageStatus.Lines.Add(LineBuff);
        LineBuff := '';
      end;
      #10: {ignore };
    else
      LineBuff := LineBuff + Ch;
    end;
  end;
end;


procedure TForm1.PageEvent(Sender: TObject; Event: TTAPStatus);
begin
  case Event of
    psLoginPrompt: SetStatus('Got Login Prompt');
    psLoggedIn:    SetStatus('Logged In');
    psLoginErr:    SetStatus('Login Error');
    psLoginFail:   SetStatus('Login Failed');
    psMsgOkToSend: SetStatus('Got OK to Send');

    psSendingMsg: begin
      Inc(PacketCt);
      SetStatus('Sending packet ' + IntToStr(PacketCt) + '...');
    end;

    psMsgAck:begin
      Inc(AckCt);
      SetStatus('Packet ' + IntToStr(AckCt) + ' Acknowledged');
    end;

    psMsgCompleted:  SetStatus('Message Completed');
    psMsgNak:        SetStatus('Message Error');
    psMsgRs:         SetStatus('Message Abort');
    psDone: begin
      SetStatus('Page Done');
    end;

  end;
end ;


{ Control Event Handlers }
procedure TForm1.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.mmoMsgChange(Sender: TObject);
begin
  UpdateMessage;
end;

procedure TForm1.lbUsersClick(Sender: TObject);
begin
  GetUserInfo(GetCurUser);
  edPagerID.Text := CurPagerID;
  edPagerAddr.Text := CurPagerAddress
end;

procedure TForm1.btnSendClick(Sender: TObject);
var
  i: Integer;
begin
  btnSend.Caption := 'Please Wait';
  btnSend.Enabled := FALSE;

  PacketCt := 0;
  AckCt := 0;

  i := 0;
  Cancelled := FALSE;
  while (not Cancelled) and (i <= Pred(lbUsers.Items.Count)) do begin
    if lbUsers.Selected[i] then begin
      CurUser := lbUsers.Items[i];
      GetUserInfo(CurUser);

      if PageType = 'TAP' then begin
        SendByTAP;
      end
      else if PageType = 'SNPP' then begin
        SendBySNPP;
      end
      else

        Application.MessageBox('Unknown transmission type requested', 'Error', MB_OK or MB_ICONEXCLAMATION);

    end;

    Inc(i);
  end;

  btnSend.Caption := 'Send';
  btnSend.Enabled := TRUE;
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  if PageType = 'TAP' then begin
    TAPQuit;
  end
  else if PageType = 'SNPP' then begin
    SNPPQuit;
  end
  else begin
    Application.MessageBox('Unknown protocol', 'Error', MB_OK or MB_ICONEXCLAMATION);
  end;
  Cancelled := TRUE;
end;

procedure TForm1.cbLoggingClick(Sender: TObject);
begin
  Logging := cbLogging.Checked;
end;

procedure TForm1.btnViewLogClick(Sender: TObject);
begin
  InitLogFile;
  ViewLog;
end;

procedure TForm1.btnClearLogClick(Sender: TObject);
begin
  ClearLog;
end;

procedure TForm1.ClearEds;
begin
  edPagerAddr.Text := '';
  edPagerID.Text := '';
end;

procedure TForm1.UpdateMessage;
begin
  TAPPager.Message.Assign(mmoMsg.Lines);
  SNPPPager.Message.Assign(mmoMsg.Lines);
end;

procedure TForm1.ClearCurVars;
begin
  CurUser         := '';
  CurPagerID      := '';
  CurPagerAddress := '';
  CurWSPort       := '';
end;

procedure TForm1.SetStatus(StatusMsg: string);
var
  S: string;
begin
  S := Format('Status: %s', [StatusMsg]);
  Label7.Caption := S;
end ;

procedure TForm1.GetUsers;
begin
  lbUsers.Items.Clear;
  PagerList.ReadSection('PAGERS', lbUsers.Items);
end;

function TForm1.GetCurUser: string;
begin
  Result := lbUsers.Items[lbUsers.ItemIndex];
end;

function TForm1.GetEntry(User: string): string;
begin
  Result := PagerList.ReadString('PAGERS', User, '');
end;

procedure TForm1.GetUserInfo(User: string);
var
  PBar, PComma, PColon: Integer;
  UserDat: string;
begin
  UserDat := GetEntry(User);

  PBar   := Pos('|', UserDat);
  PComma := Pos(',', UserDat);
  PColon := Pos(':', UserDat);

  PageType        := Copy(UserDat, 1, PBar - 1);

  if (PageType = 'TAP') then begin
    CurPagerAddress := Copy(UserDat, PBar + 1, (PComma - 1) - PBar);
    CurWSPort       := '';
    CurPagerID      := Copy(UserDat, PComma + 1, Length(UserDat)-PComma);
  end
  else if (PageType = 'SNPP') then begin
    CurPagerAddress := Copy(UserDat, PBar + 1, (PColon - 1) - PBar);
    CurWSPort       := Copy(UserDat, PColon + 1, (PComma - 1) - PColon);
    CurPagerID      := Copy(UserDat, PComma + 1, Length(UserDat)-PComma);
  end
  else {bad entry} begin
    CurPagerAddress := '';
    CurWSPort       := '';
    CurPagerID      := '';
  end;
end;

procedure TForm1.SendByTAP;
begin
  TAPPager.PhoneNumber := CurPagerAddress;
  TAPPager.PagerID     := CurPagerID;
  TAPPager.Message     := mmoMsg.Lines;
  TAPPager.Send;
end;

procedure TForm1.TAPQuit;
begin
  TAPPager.CancelCall;
  TAPPager.Disconnect;
end;

procedure TForm1.SendBySNPP;
begin
  WinsockPort.WsAddress := CurPagerAddress;
  WinsockPort.WsPort := CurWSPort;
  SNPPPager.PagerID := CurPagerID;
  SNPPPager.Message := mmoMsg.Lines;
  SNPPPager.Send;
end;

procedure TForm1.SNPPQuit;
begin
  SNPPPager.Quit;
end;

{ Pager List Managaement }

procedure TForm1.AddEntry(const Name, Protocol, Addr, PagerID: string);
begin
  PagerList.WriteString('PAGERS', Name, Protocol + '|' + Addr + ',' + PagerID);
  GetUsers;
end;

procedure TForm1.btnEditClick(Sender: TObject);
var
  Rslt: Integer;
begin
  if lbUsers.ItemIndex = -1 then begin
    Application.MessageBox('No user selected', 'Error', MB_OK or MB_ICONINFORMATION);
    Exit;
  end;

  Form2.edName.Text        := GetCurUser;
  Form2.edName.ReadOnly    := TRUE;
  Form2.edPagerAddr.Text := edPagerAddr.Text;
  Form2.edPagerID.Text     := edPagerID.Text;
  Form2.Caption := 'Update User';
  Rslt := Form2.ShowModal;
  if Rslt = mrOK then begin
    AddEntry(Form2.edName.Text, EntryType[Form2.RadioGroup1.ItemIndex], Form2.edPagerAddr.Text, Form2.edPagerID.Text);
    GetUsers;
  end;
  Form2.ClearEds;
end;

procedure TForm1.btnAddClick(Sender: TObject);
var
  Rslt: Integer;
begin
  Form2.edName.ReadOnly := FALSE;
  Form2.Caption := 'Add New User';
  Rslt := Form2.ShowModal;
  if Rslt = mrOK then
  begin
    AddEntry(Form2.edName.Text, EntryType[Form2.RadioGroup1.ItemIndex], Form2.edPagerAddr.Text, Form2.edPagerID.Text);
    GetUsers;
  end;
  Form2.ClearEds;
end;

procedure TForm1.btnRemoveClick(Sender: TObject);
var
  Rslt: Integer;
begin
  Rslt := Application.MessageBox('You are about to remove the selected user from the list, proceed?',
    'Inquiry', MB_YESNO or MB_ICONQUESTION);
  if (Rslt = ID_YES) then begin
    PagerList.DeleteKey('PAGERS', GetCurUser);
    GetUsers;
  end;
end;


{ Logging Management }
procedure TForm1.InitLogFile;
var
  LName, LPath: string;
  F: TextFile;
begin
  LName := PagerINI.ReadString('INIT', 'LOGFILE', '');

  LPath := ExtractFilePath(LName);
  LName := ExtractFileName(LName);

  if  (not DirectoryExists(LPath)) then begin
    { no such directory, use default }
    LPath := ExtractFilePath(Application.ExeName);
  end;

  if (LName = '') or (not FileExists(LPath + LName)) then begin
    { create file }
    AssignFile(F, LPath + LName);
    ReWrite(F);
    CloseFile(F);

    { store new log path }
    PagerINI.WriteString('INIT', 'LOGFILE', LPath + LName);
  end;

  LogName := LPath + LName;
end;

procedure TForm1.ViewLog;
begin
  Form3.Memo1.Lines.LoadFromFile(LogName);
  Form3.Edit1.Text := LogName;
  Form3.ShowModal;
  if Form3.Changed then
  begin
    LogName := Form3.Edit1.Text;
    PagerINI.WriteString('INIT', 'LOGFILE', LogName);
    SetLogFiles;
    InitLogFile;
  end;
end;

procedure TForm1.ClearLog;
var
  Rslt: Integer;
begin
  Rslt := Application.MessageBox('You are about to delete the pager log, proceed?', 'Inquiry', MB_YESNO or MB_ICONQUESTION);
  if (Rslt = ID_YES) then
    if FileExists(LogName) then begin
      DeleteFile(LogName);
      InitLogFile;
    end;
end;

procedure TForm1.SetLogging(AreLogging: Boolean);
begin
  cbLogging.Checked := AreLogging;
  PagerINI.WriteBool('INIT', 'LOGGING', AreLogging);
  SetLogFiles;
end;

function TForm1.GetLogging: Boolean;
begin
  Result := cbLogging.Checked;
end;

procedure TForm1.SetLogFiles;
begin
  LogName := PagerINI.ReadString('INIT', 'LOGFILE', '');
  InitLogFile;

  if Logging then begin
    TAPLog.HistoryName := LogName;
    SNPPLog.HistoryName := LogName;
  end
  else begin
    TAPLog.HistoryName := '';
    SNPPLog.HistoryName := '';
  end;
end;

procedure TForm1.SNPPPagerSNPPEvent(Sender: TObject; Code: Integer;
  Msg: String);
begin
  mmoPageStatus.Lines.Add(Msg);
end;

end.


