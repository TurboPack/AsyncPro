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
{*                   FAXMON0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{* A printer driver fax monitor application that works   *}
{*     with FaxServr.                                    *}
{*********************************************************}

unit FaxMon0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, AdFaxCtl, StdCtrls, ShellAPI, Menus, ExtCtrls, OoMisc;

{$DEFINE UseTrayIcon}

const
  {$IFDEF UseTrayIcon}
  Am_tiCallBack          = WM_USER + $300;
  {$ENDIF}
  Am_NotifyFaxAvailable  = WM_USER + $301;
  Am_NotifyFaxSent       = WM_USER + $302;
  Am_QueryPending        = WM_USER + $303;
type
  TState = (Printing,Generated,Queued,Sent);
const
  StateString : array[TState] of string[9] =
    ('Printing','Generated','Queued','Sent');
type
  TPrintJob = class
    private
      fDocName,
      fFileName : string;
      fState : TState;
      JobAtom : Word;
      function GetJobString : string;
    public
      property DocName : string read fDocName write fDocName;
      property FileName : string read fFileName write fFileName;
      property State : TState read fState write fState;
      property JobString : string read GetJobString;
  end;

  TfFaxMon0 = class(TForm)
    Driver: TApdFaxDriverInterface;
    Label1: TLabel;
    edtServerPath: TEdit;
    btnSelect: TButton;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    mnClose: TMenuItem;
    ListBox1: TListBox;
    Label2: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure DriverDocStart(Sender: TObject);
    procedure DriverDocEnd(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnCloseClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    AppHandle : hWnd;
    FileCount : Integer;
    {$IFDEF UseTrayIcon}
    tiActive     : boolean;
    tiNotifyData : TNotifyIconData;
    tiPresent    : boolean;
    procedure tiAdd;
    procedure tiCallBack(var Msg : TMessage); message Am_tiCallBack;
    procedure tiDelete;
    function tiGetIconHandle : hIcon;
    procedure tiInitNotifyData;
    procedure MainFormMinimize(Sender : TObject);
    procedure MainFormRestore(Sender : TObject);
    {$ENDIF}
  public
    procedure AmNotifyFaxSent(var Message : TMessage); message Am_NotifyFaxSent;
    procedure AmQueryPending(var Message : TMessage); message Am_QueryPending;
  end;

var
  fFaxMon0: TfFaxMon0;

implementation

{$R *.DFM}

function TPrintJob.GetJobString : string;
begin
  Result := DocName + '(' + StateString[State] + ')';
end;

procedure TfFaxMon0.FormCreate(Sender: TObject);
begin
  {$IFDEF UseTrayIcon}
  Application.OnMinimize := MainFormMinimize;
  Application.OnRestore := MainFormRestore;
  {$ENDIF}
end;

procedure TfFaxMon0.DriverDocStart(Sender: TObject);
var
  NewJob : TPrintJob;
begin
  NewJob := TPrintJob.Create;
  NewJob.DocName := Driver.DocName;
  Driver.FileName := 'C:\FMTEMP'+IntToStr(FileCount)+'.APF';
  inc(FileCount);
  NewJob.FileName := Driver.FileName;
  NewJob.State := Printing;
  ListBox1.Items.AddObject(NewJob.JobString,NewJob);
end;

procedure TfFaxMon0.DriverDocEnd(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    with TPrintJob(ListBox1.Items.Objects[i]) do
    if (State = Printing) and (DocName = Driver.DocName) then begin
      State := Generated;
      ListBox1.Items[i] := JobString;
      break;
    end;
end;

procedure TfFaxMon0.AmNotifyFaxSent(var Message : TMessage);
var
  i : integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    with TPrintJob(ListBox1.Items.Objects[i]) do
      if JobAtom = Message.lParam then begin
        State := Sent;
        ListBox1.Items[Message.wParam] := JobString;
        DeleteAtom(JobAtom);
        break;
      end;
end;

procedure TfFaxMon0.AmQueryPending(var Message : TMessage);
var
  i : Integer;
  Pending : integer;
begin
  Pending := 0;
  for i := 0 to pred(ListBox1.Items.Count) do
    with TPrintJob(ListBox1.Items.Objects[i]) do
      if State <> Sent then
        inc(Pending);
  Message.Result := Pending;
end;

procedure TfFaxMon0.btnSelectClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edtServerPath.Text := OpenDialog1.FileName;
end;

procedure TfFaxMon0.FormActivate(Sender: TObject);
{$IFDEF UseTrayIcon}
var
  OSVerInfo : TOSVersionInfo;
{$ENDIF}
begin
  {$IFDEF UseTrayIcon}
  tiPresent := false;
  OSVerInfo.dwOSVersionInfoSize := sizeof(OSVerInfo);
  if GetVersionEx(OSVerInfo) then begin
    {Note: Windows95 returns version major:minor = 4:0}
    if (OSVerInfo.dwPlatformID = VER_PLATFORM_WIN32_WINDOWS) or {Windows95}
       (OSVerInfo.dwPlatformID = VER_PLATFORM_WIN32_NT) then    {WindowsNT}
      tiPresent := OSVerInfo.dwMajorVersion > 3
  end;
  {$ENDIF}
end;

procedure TfFaxMon0.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFDEF UseTrayIcon}
  tiDelete;
  {$ENDIF}
end;

{$IFDEF UseTrayIcon}
procedure TfFaxMon0.MainFormMinimize(Sender : TObject);
begin
  if tiPresent then begin
    tiAdd;
    ShowWindow(Application.Handle,SW_HIDE);
    Hide;
  end;
end;

procedure TfFaxMon0.MainFormRestore(Sender : TObject);
begin
  if tiPresent then begin
    tiDelete;
    Show;
    SetForegroundWindow(Handle);
  end;
end;

procedure TfFaxMon0.tiAdd;
begin
  if tiPresent and (not tiActive) then begin
    tiInitNotifyData;
    tiActive := Shell_NotifyIcon(NIM_ADD, @tiNotifyData);
  end;
end;

procedure TfFaxMon0.tiCallBack(var Msg : TMessage);
var
  P : TPoint;
begin
  with Msg do begin
    case lParam of
      WM_RBUTTONDOWN :
        begin
          GetCursorPos(P);
          SetForegroundWindow(Application.Handle);
          Application.ProcessMessages;
          PopupMenu.Popup(P.X, P.Y);
        end;
      WM_LBUTTONDBLCLK :
        Application.Restore;
    end;{case}
  end;
end;

procedure TfFaxMon0.tiDelete;
begin
  if tiPresent and tiActive then begin
    tiActive := not Shell_NotifyIcon(NIM_DELETE, @tiNotifyData);
  end;
end;

function TfFaxMon0.tiGetIconHandle : hIcon;
begin
  Result := Application.Icon.Handle;
  if Result = 0 then
    Result := LoadIcon(0, IDI_Application);
end;

procedure TfFaxMon0.tiInitNotifyData;
begin
  if tiPresent then begin
    FillChar(tiNotifyData, sizeof(tiNotifyData), 0);
    with tiNotifyData do begin
      cbSize := sizeof(tiNotifyData);
      Wnd    := Handle;
      uID    := 1;
      uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
      StrCopy(szTip, 'Fax Monitor');
      uCallBackMessage := Am_tiCallBack;
      hIcon := tiGetIconHandle;
    end;
  end;
end;
{$ENDIF}

procedure TfFaxMon0.mnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfFaxMon0.Timer1Timer(Sender: TObject);
const
  MaxRetryCount = 10000;
var
  Job : TPrintJob;
  AtomString : string;
  RetryCount : Integer;
  Done : Boolean;
begin
  if ListBox1.Items.Count <> 0 then begin
    Timer1.Enabled := False;
    try
      repeat
        Done := True;
        Job := TPrintJob(ListBox1.Items.Objects[0]);
        case Job.State of
        Printing : ;
        Generated :
          begin
            if (AppHandle = 0) or not IsWindow(AppHandle) then begin
              ShellExecute(0, nil, pChar(edtServerPath.Text), nil, '', sw_ShowNormal);
              RetryCount := 0;
              repeat
                AppHandle := FindWindow('TForm1', 'Fax server');
                Application.ProcessMessages;
                inc(RetryCount);
              until (RetryCount > MaxRetryCount) or (AppHandle <> 0);
            end;
            if AppHandle <> 0 then begin
              AtomString := Job.DocName + #27 + Job.FileName + #0;
              Job.JobAtom := GlobalAddAtom(pChar(AtomString));
              PostMessage(AppHandle,Am_NotifyFaxAvailable,Handle,Job.JobAtom);
              Job.State := Queued;
              ListBox1.Items[0] := Job.JobString;
            end else
              ShowMessage('Timeout waiting for server app to start');
          end;
        Queued : ;
        Sent :
          begin
            TPrintJob(ListBox1.Items.Objects[0]).Free;
            ListBox1.Items.Delete(0);
            Done := False;
          end;
        end;
      until Done or (ListBox1.Items.Count = 0);
    finally
      Timer1.Enabled := True;
    end;
  end;
end;

end.
