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
unit EmulatorFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OoMisc, AdPort, AdWnPort, StdCtrls, AdProtcl,
  Menus, ComCtrls, ToolWin, AdTapi, OleCtrls, isp3, AdPStat,
  ImgList, ADTrmEmu;

type
  TEmulatorForm = class(TForm)
    SockPort: TApdWinsockPort;
    XferProtocol: TApdProtocol;
    ToolBar: TToolBar;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    SessionMenu: TMenuItem;
    SessionExit: TMenuItem;
    OptionMenu: TMenuItem;
    OptionHosts: TMenuItem;
    ConnectBtn: TToolButton;
    DisconnectBtn: TToolButton;
    ToolBarImages: TImageList;
    TapiDev: TApdTapiDevice;
    SessionConnect: TMenuItem;
    SessionDisconnect: TMenuItem;
    FontDlg: TFontDialog;
    OptionsFont: TMenuItem;
    FontBtn: TToolButton;
    UploadMenu: TMenuItem;
    UploadX: TMenuItem;
    UploadY: TMenuItem;
    UploadZ: TMenuItem;
    UploadK: TMenuItem;
    UploadA: TMenuItem;
    DownloadMenu: TMenuItem;
    DownloadX: TMenuItem;
    DownloadY: TMenuItem;
    DownloadZ: TMenuItem;
    DownloadK: TMenuItem;
    DownloadA: TMenuItem;
    XferStatus: TApdProtocolStatus;
    FtpMenu: TMenuItem;
    HostsBtn: TToolButton;
    EditMenu: TMenuItem;
    EditCopy: TMenuItem;
    EditPaste: TMenuItem;
    CopyBtn: TToolButton;
    PasteBtn: TToolButton;
    OptionsXfer: TMenuItem;
    Options80: TMenuItem;
    Options132: TMenuItem;
    Col80Btn: TToolButton;
    Col132Btn: TToolButton;
    HelpMenu: TMenuItem;
    HelpAbout: TMenuItem;
    HelpContents: TMenuItem;
    OptionsLogging: TMenuItem;
    OptionsTrace: TMenuItem;
    TermWindow: TAdTerminal;
    VT100Emul: TAdVT100Emulator;
    XferLog: TApdProtocolLog;
    procedure FormCreate(Sender: TObject);
    procedure SockPortTriggerData(CP: TObject; TriggerHandle: Word);
    procedure XferProtocolProtocolFinish(CP: TObject; ErrorCode: Integer);
    procedure FormShow(Sender: TObject);
    procedure OptionHostsClick(Sender: TObject);
    procedure SockPortWsError(Sender: TObject; ErrCode: Integer);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure FormDestroy(Sender: TObject);
    procedure SockPortWsDisconnect(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure DisconnectBtnClick(Sender: TObject);
    procedure SockPortWsConnect(Sender: TObject);
    procedure SessionConnectClick(Sender: TObject);
    procedure SessionDisconnectClick(Sender: TObject);
    procedure TapiDevTapiConnect(Sender: TObject);
    procedure TapiDevTapiPortClose(Sender: TObject);
    procedure SessionExitClick(Sender: TObject);
    procedure FontBtnClick(Sender: TObject);
    procedure OptionsFontClick(Sender: TObject);
    procedure UploadXClick(Sender: TObject);
    procedure DownloadXClick(Sender: TObject);
    procedure UploadYClick(Sender: TObject);
    procedure DownloadYClick(Sender: TObject);
    procedure UploadZClick(Sender: TObject);
    procedure DownloadZClick(Sender: TObject);
    procedure UploadKClick(Sender: TObject);
    procedure DownloadKClick(Sender: TObject);
    procedure UploadAClick(Sender: TObject);
    procedure DownloadAClick(Sender: TObject);
    procedure FtpMenuClick(Sender: TObject);
    procedure HostsBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
    procedure EditCopyClick(Sender: TObject);
    procedure EditPasteClick(Sender: TObject);
    procedure OptionsXferClick(Sender: TObject);
    procedure Col80BtnClick(Sender: TObject);
    procedure Col132BtnClick(Sender: TObject);
    procedure Options80Click(Sender: TObject);
    procedure Options132Click(Sender: TObject);
    procedure HelpAboutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HelpContentsClick(Sender: TObject);
    procedure OptionsLoggingClick(Sender: TObject);
    procedure OptionsTraceClick(Sender: TObject);
    procedure TapiDevTapiFail(Sender: TObject);
    procedure TermWindowCursorMoved(aSender: TObject; aRow, aCol: Integer);
  private
    FNumWaitHandles : Integer;
    FStringFound    : Integer;
    FWaitHandles    : array [1..100] of Integer;
    FZrQinitHandle  : Integer;
    FConnectedBmp   : TBitmap;
    FNotConnectedBmp: TBitmap;
    FHostName       : String;
    FForeground     : String;
    FBackground     : String;
    FFirstPass      : Boolean;
    FConnectTimeout : Integer;
    FDatabits       : Integer;
    FStopbits       : Integer;
    FParity         : TParity;
    FConnectType    : String;

    procedure DoConnect(host : String);
    procedure IdleAction(Sender : TObject; var Done : Boolean);
    procedure ResizeWindow;

    procedure DoCommTrace;
  public
    { Public declarations }
  end;

const
    HostsKey = 'SOFTWARE\Aurora Software\TransTerm\CurrentVersion\Hosts';
    OptKey   = 'SOFTWARE\Aurora Software\TransTerm\CurrentVersion\Options';

var
  EmulatorForm: TEmulatorForm;

implementation

uses HostsFrm, ConnectFrm, Registry, DialingFrm, ColourFrm, XmodemFrm,
  YZmodemFrm, AsciiFrm, FtpLoginFrm, FtpFrm, Clipbrd, XferOptFrm, AboutDlg;

{$R *.DFM}
procedure TEmulatorForm.IdleAction(Sender : TObject; var Done : Boolean);
begin
    if (FFirstPass) then
    begin
        FFirstPass := False;
        if (ConnectBtn.Enabled) then
            ConnectBtnClick(ConnectBtn);
    end;
    Done := True;
end;

procedure TEmulatorForm.ResizeWindow;
begin
    with TermWindow do
    begin
        if (Options80.Checked) then
            Columns := 80
        else
            Columns := 132;
        Rows := 24;
        ClientWidth := CharWidth * Columns;
        ClientHeight := CharHeight * Rows;
    end;
    StatusBar.Top := TermWindow.Top + TermWindow.Height + 1;
    ClientWidth := TermWindow.Width + 8;
    ClientHeight := TermWindow.Top + TermWindow.Height +
                    Statusbar.Height + 4;
    if (Width > Screen.Width) then
        Width := Screen.Width;
    if (Height > Screen.Height) then
        Height := Screen.Height;
    if ((Top+Height) > Screen.Height) then
        Top := Screen.Height - Height;
    if ((Left+Width) > Screen.Width) then
        Left := Screen.Width - Width;

end;

procedure TEmulatorForm.FormCreate(Sender: TObject);
var
    exeDir   : String;
    slash    : Integer;

begin
    exeDir := Application.ExeName;
    slash := LastDelimiter('\', exeDir);
    if (slash > 0) then
        exeDir := Copy(exeDir, 1, slash-1);
    Application.HelpFile := exeDir + '\TransTerm.hlp';
    TermWindow.Emulator.KeyboardMapping.LoadFromFile(exeDir + '\vt100keymap.txt');
    
    FNumWaitHandles := 0;
    FStringFound := 0;
    FZrQinitHandle := 0;
    FConnectedBmp := TBitmap.Create;
    FNotConnectedBmp := TBitmap.Create;
    FConnectedBmp.LoadFromFile(exeDir + '\Connected.bmp');
    FConnectedBmp.Transparent := True;
    FNotConnectedBmp.LoadFromFile(exeDir + '\NotConnected.bmp');
    FNotConnectedBmp.Transparent := True;
    FHostName := '';
    FFirstPass := True;
    FConnectTimeout := 60;

    Application.OnIdle := IdleAction;
end;

procedure TEmulatorForm.SockPortTriggerData(CP: TObject;
  TriggerHandle: Word);
var
    i    : Integer;
begin
    if (FZrQinitHandle = TriggerHandle) then
    begin
        TermWindow.Active := False;
        XferProtocol.StartReceive;
        DoCommTrace;
        Exit;
    end;
    for i:=1 to FNumWaitHandles do
    begin
        if (FWaitHandles[i] = TriggerHandle) then
            FStringFound := i;
    end;
end;

procedure TEmulatorForm.XferProtocolProtocolFinish(CP: TObject;
  ErrorCode: Integer);
begin
    // Make sure that port is set to proper settings after
    // transfer complete
    if (FConnectType = 'Serial') then
    begin
        SockPort.DataBits := FDatabits;
        SockPort.StopBits := FStopbits;
        SockPort.Parity := FParity;
    end;
    TermWindow.Active := True;
    DoCommTrace;
    if (ErrorCode <> 0) then
        ShowMessageFmt('Transfer of ' + XferProtocol.FileName + ' failed!'#10#10 +
                       'Error = %d',
                       [ErrorCode]);
end;
//
procedure TEmulatorForm.FormShow(Sender: TObject);
var
    reg         : TRegistry;
    bStat       : Boolean;
begin
    //  Load options from registry
    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        bStat := reg.OpenKey(OptKey, False);
        if (bStat) then
        begin
            try
                with TermWindow do
                begin
                    Font.Name := reg.ReadString('FontName');
                    Font.Size := reg.ReadInteger('FontSize');
                end;
                with XferProtocol do
                begin
                    AsciiCharDelay := reg.ReadInteger('AsciiCharDelay');
                    AsciiCRTranslation := TAsciiEOLTranslation(reg.ReadInteger('AsciiCRTranslation'));
                    AsciiEOFTimeout := reg.ReadInteger('AsciiEOFTimeout');
                    AsciiEOLChar := Chr(reg.ReadInteger('AsciiEOLChar'));
                    AsciiLFTranslation := TAsciiEOLTranslation(reg.ReadInteger('AsciiLFTranslation'));
                    AsciiLineDelay := reg.ReadInteger('AsciiLineDelay');
                    AsciiSuppressCtrlZ := Boolean(reg.ReadInteger('AsciiSuppressCtrlZ'));
                    KermitMaxLen := reg.ReadInteger('KermitMaxLen');
                    KermitMaxWindows := reg.ReadInteger('KermitMaxWindows');
                    KermitTimeoutSecs := reg.ReadInteger('KermitTimeoutSecs');
                    ZmodemFileOption := TZmodemFileOptions(reg.ReadInteger('ZmodemFileOption'));
                    ZmodemOptionOverride := Boolean(reg.ReadInteger('ZmodemOptionOverride'));
                    ZmodemRecover := Boolean(reg.ReadInteger('ZmodemRecover'));
                    ZmodemSkipNoFile := Boolean(reg.ReadInteger('ZmodemSkipNoFile'));
                    DestinationDirectory := reg.ReadString('DestinationDirectory');
                end;
            except
                ;
            end;
        end;
    finally
        reg.Free;
    end;
    //  Get main window organized
    ResizeWindow;
    if (SockPort.Open) then
    begin
        ConnectBtn.Enabled := False;
        DisconnectBtn.Enabled := True;
        SessionConnect.Enabled := False;
        SessionDisconnect.Enabled := True;
    end else
    begin
        ConnectBtn.Enabled := True;
        DisconnectBtn.Enabled := False;
        SessionConnect.Enabled := True;
        SessionDisconnect.Enabled := False;
    end;
end;

procedure TEmulatorForm.OptionHostsClick(Sender: TObject);
begin
    HostsBtnClick(HostsBtn);
end;

procedure TEmulatorForm.SockPortWsError(Sender: TObject; ErrCode: Integer);
begin
{ TODO : 
We need a way to show this message.
We can't do it here because ShowMessage causes the application to
lock up. }
//    ShowMessage('OOPS!  Error = ' + IntToStr(ErrCode));
end;

procedure TEmulatorForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
    if (Panel.Text = 'Connect') then
    begin
        if (SockPort.Open) then
        begin
            if (Assigned(FConnectedBmp)) then
                StatusBar.Canvas.StretchDraw(Rect, FConnectedBmp);
            ConnectBtn.Enabled := False;
            DisconnectBtn.Enabled := True;
            SessionConnect.Enabled := False;
            SessionDisconnect.Enabled := True;
        end else
        begin
            if (Assigned(FNotConnectedBmp)) then
                StatusBar.Canvas.StretchDraw(Rect, FNotConnectedBmp);
            ConnectBtn.Enabled := True;
            DisconnectBtn.Enabled := False;
            SessionConnect.Enabled := True;
            SessionDisconnect.Enabled := False;
        end;
    end;
end;

procedure TEmulatorForm.FormDestroy(Sender: TObject);
begin
    if (Assigned(FConnectedBmp)) then
       FConnectedBmp.Free;
    if (Assigned(FNotConnectedBmp)) then
        FNotConnectedBmp.Free;
end;

procedure TEmulatorForm.SockPortWsDisconnect(Sender: TObject);
var
    i           : Integer;
begin
    Caption := 'TransTerm';
    for i:=1 to FNumWaitHandles do
        SockPort.RemoveTrigger(FWaitHandles[i]);
    FNumWaitHandles := 0;
    SockPort.RemoveTrigger(FZrQInitHandle);
    FZrqInitHandle := 0;
    if (Assigned(StatusBar)) then
        StatusBar.Invalidate;
    if (Assigned(ConnectBtn)) then
        ConnectBtn.Enabled := True;
    if (Assigned(DisconnectBtn)) then
        DisconnectBtn.Enabled := False;
    if (Assigned(SessionConnect)) then
        SessionConnect.Enabled := True;
    if (Assigned(SessionDisconnect)) then
        SessionDisconnect.Enabled := False;
end;

procedure TEmulatorForm.DoConnect(host : String);
var
    reg         : TRegistry;
    bStat       : Boolean;
    hostKey     : String;
    connectType : String;
    serDevice   : String;
    parity      : String;
    phone       : String;

begin
    FHostName := host;
    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        hostKey := HostsKey + '\' + host;
        bStat := reg.OpenKey(hostKey, False);
        if (not bStat) then
            raise Exception.CreateFmt('Internal error.  Could not open ' +
                                      'registry key for host %s',
                                      [host]);
        connectType := reg.ReadString('ConnectType');
        FConnectType := connectType;
        if (connectType = 'Telnet') then
        begin
            SockPort.Open := False;
            SockPort.TapiMode := tmOff;
            SockPort.DeviceLayer := dlWinsock;
            SockPort.WsAddress := reg.ReadString('IPAddress');
            SockPort.WsTelnet := True;
            SockPort.WsPort := IntToStr(reg.ReadInteger('TCPPort'));
            SockPort.Open := True;
        end else
        begin
            SockPort.Open := False;
            SockPort.Devicelayer := dlWin32;
            serDevice := reg.ReadString('SerialDevice');
            if (Pos('Direct to Com', serDevice) > 0) then
            begin
                SockPort.TapiMode := tmOff;
                SockPort.ComNumber :=
                    StrToInt(Copy(serDevice, 14, Length(serDevice)));
            end else
            begin
                SockPort.TapiMode := tmOn;
                TapiDev.SelectedDevice := serDevice;
            end;
            SockPort.Baud := reg.ReadInteger('LineSpeed');
            SockPort.DataBits := reg.ReadInteger('DataBits');
            SockPort.Parity := pNone;
            parity := reg.ReadString('Parity');
            if (parity = 'Odd') then
                SockPort.Parity := pOdd;
            if (parity = 'Even') then
                SockPort.Parity := pEven;
            if (parity = 'Space') then
                SockPort.Parity := pSpace;
            if (parity = 'Mark') then
                SockPort.Parity := pMark;
            SockPort.StopBits := reg.ReadInteger('StopBits');
            //  These are used in the TapiConnect event to reset the
            //  serial port to the proper settings.
            FDatabits := SockPort.DataBits;
            FStopbits := SockPort.StopBits;
            FParity := SockPort.Parity;
            phone := reg.ReadString('Phone');
            if (phone = '') then
            begin
                if (SockPort.TapiMode = tmOn) then
                    TapiDev.ConfigAndOpen
                else
                begin
                    SockPort.Open := True;
                    Caption := 'TransTerm - ' + host;
                    StatusBar.Invalidate;
                end;
            end else
            begin
                DialingForm.Caption := 'Dialing ' + phone;
                DialingForm.Show;
                try
                    TapiDev.Dial(TapiDev.TranslateAddress(phone));
                except
                    DialingForm.Close;
                    raise;
                end;
            end;
        end;
        TermWindow.Clear;
        TermWindow.SetFocus;
    finally
       reg.Free;
   end;
end;

procedure TEmulatorForm.ConnectBtnClick(Sender: TObject);
var
    stat        : Integer;

begin
    stat := ConnectForm.ShowModal;
    if (stat = mrOk) then
        DoConnect(ConnectForm.HostName);
end;

procedure TEmulatorForm.DisconnectBtnClick(Sender: TObject);
begin
    if ((SockPort.TapiMode = tmOn) or (SockPort.TapiMode = tmAuto)) then
        TapiDev.CancelCall;
    SockPort.Open := False;
    if (SockPort.TapiMode = tmOff) then
    begin
        Caption := 'TransTerm';
        StatusBar.Invalidate;
    end;
end;

procedure TEmulatorForm.SockPortWsConnect(Sender: TObject);
begin
    Caption := 'TransTerm - ' + SockPort.WsAddress;
    ConnectBtn.Enabled := False;
    DisconnectBtn.Enabled := True;
    SessionConnect.Enabled := False;
    SessionDisconnect.Enabled := True;
    FZrQinitHandle := SockPort.AddDataTrigger('rz' + #13 + '**' + #24 + 'B',
                                              False);
end;

procedure TEmulatorForm.SessionConnectClick(Sender: TObject);
begin
    ConnectBtnClick(ConnectBtn);
end;

procedure TEmulatorForm.SessionDisconnectClick(Sender: TObject);
begin
    DisconnectBtnClick(DisconnectBtn);
end;

procedure TEmulatorForm.TapiDevTapiConnect(Sender: TObject);
begin
    Caption := 'TransTerm - ' + FHostName;
    DialingForm.Close;
    StatusBar.Invalidate;
    //  Reset the databits, etc. because TAPI sets them to the default
    //  defined for the modem, not to the values needed by the connection.
    if (FConnectType = 'Serial') then
    begin
        SockPort.DataBits := FDatabits;
        SockPort.StopBits := FStopbits;
        SockPort.Parity := FParity;
    end;
    if (FZrQinitHandle = 0) then
        FZrQinitHandle := SockPort.AddDataTrigger('rz' + #13 + '**' + #24 + 'B',
                                                  False);
end;

procedure TEmulatorForm.TapiDevTapiPortClose(Sender: TObject);
var
    i           : Integer;
begin
    Caption := 'TransTerm';
    for i:=1 to FNumWaitHandles do
        SockPort.RemoveTrigger(FWaitHandles[i]);
    FNumWaitHandles := 0;
    SockPort.RemoveTrigger(FZrQInitHandle);
    FZrqInitHandle := 0;
    if (Assigned(StatusBar)) then
        StatusBar.Invalidate;
    if (Assigned(ConnectBtn)) then
        ConnectBtn.Enabled := True;
    if (Assigned(DisconnectBtn)) then
        DisconnectBtn.Enabled := False;
    if (Assigned(SessionConnect)) then
        SessionConnect.Enabled := True;
    if (Assigned(SessionDisconnect)) then
        SessionDisconnect.Enabled := False;
end;

procedure TEmulatorForm.SessionExitClick(Sender: TObject);
begin
    Close;
end;

procedure TEmulatorForm.FontBtnClick(Sender: TObject);
var
   reg    : TRegistry;
   bStat  : Boolean;

begin
    FontDlg.Font := TermWindow.Font;
    if (FontDlg.Execute) then
    begin
        TermWindow.Font := FontDlg.Font;
        ResizeWindow;
        reg := TRegistry.Create;
        try
            reg.RootKey := HKEY_LOCAL_MACHINE;
            bStat := reg.OpenKey(OptKey, True);
            if (bStat) then
            begin
                reg.WriteString('FontName', TermWindow.Font.Name);
                reg.WriteInteger('FontSize', TermWindow.Font.Size);
            end;
        finally
            reg.Free;
        end;
    end;
end;

procedure TEmulatorForm.OptionsFontClick(Sender: TObject);
begin
    FontBtnClick(FontBtn);
end;

procedure TEmulatorForm.UploadXClick(Sender: TObject);
var
    stat    : Integer;

begin
    with XmodemForm do
    begin
        SendRecv := 'S';
        stat := ShowModal;
        if (stat = mrOk) then
        begin
            // Make sure that port is set to 8N1 before starting
            // transfer
            if (FConnectType = 'Serial') then
            begin
                SockPort.DataBits := 8;
                SockPort.StopBits := 1;
                SockPort.Parity := pNone;
            end;
            XferProtocol.FileMask := FileName;
            XferProtocol.ProtocolType := Protocol;
            SockPort.FlushInBuffer;
            TermWindow.Active := False;
            XferProtocol.StartTransmit;
        end;
        DoCommTrace;
    end;
end;

procedure TEmulatorForm.DownloadXClick(Sender: TObject);
var
    stat    : Integer;
begin
    with XmodemForm do
    begin
        SendRecv := 'R';
        stat := ShowModal;
        if (stat = mrOk) then
        begin
            // Make sure that port is set to 8N1 before starting
            // transfer
            if (FConnectType = 'Serial') then
            begin
                SockPort.DataBits := 8;
                SockPort.StopBits := 1;
                SockPort.Parity := pNone;
            end;
            XferProtocol.FileName := FileName;
            XferProtocol.ProtocolType := Protocol;
            TermWindow.Active := False;
            XferProtocol.StartReceive;
        end;
    end;
    DoCommTrace;
end;

procedure TEmulatorForm.UploadYClick(Sender: TObject);
var
    stat    : Integer;

begin
    YZmodemForm.Protocol := ptYmodem;
    stat := YZModemForm.ShowModal;
    if (stat = mrOk) then
    begin
        // Make sure that port is set to 8N1 before starting
        // transfer
        if (FConnectType = 'Serial') then
        begin
            SockPort.DataBits := 8;
            SockPort.StopBits := 1;
            SockPort.Parity := pNone;
        end;
        XferProtocol.ProtocolType := ptYmodem;
        XferProtocol.FileMask := YZModemForm.FileName;
        SockPort.FlushInBuffer;
        TermWindow.Active := False;
        XFerProtocol.StartTransmit;
    end;
    DoCommTrace;
end;

procedure TEmulatorForm.DownloadYClick(Sender: TObject);
begin
    with XferProtocol do
    begin
        // Make sure that port is set to 8N1 before starting
        // transfer
        if (FConnectType = 'Serial') then
        begin
            SockPort.DataBits := 8;
            SockPort.StopBits := 1;
            SockPort.Parity := pNone;
        end;
        ProtocolType := ptYmodem;
        FileName := '';
        TermWindow.Active := False;
        StartReceive;
    end;
    DoCommTrace;
end;

procedure TEmulatorForm.UploadZClick(Sender: TObject);
var
    stat    : Integer;

begin
    YZmodemForm.Protocol := ptZmodem;
    stat := YZModemForm.ShowModal;
    if (stat = mrOk) then
    begin
        // Make sure that port is set to 8N1 before starting
        // transfer
        if (FConnectType = 'Serial') then
        begin
            SockPort.DataBits := 8;
            SockPort.StopBits := 1;
            SockPort.Parity := pNone;
        end;
        XferProtocol.ProtocolType := ptZmodem;
        XferProtocol.FileMask := YZModemForm.FileName;
        SockPort.FlushInBuffer;
        TermWindow.Active := False;
        XFerProtocol.StartTransmit;
    end;
    DoCommTrace;
end;

procedure TEmulatorForm.DownloadZClick(Sender: TObject);
begin
    with XferProtocol do
    begin
        // Make sure that port is set to 8N1 before starting
        // transfer
        if (FConnectType = 'Serial') then
        begin
            SockPort.DataBits := 8;
            SockPort.StopBits := 1;
            SockPort.Parity := pNone;
        end;
        ProtocolType := ptZmodem;
        FileName := '';
        TermWindow.Active := False;
        StartReceive;
    end;
    DoCommTrace;
end;

procedure TEmulatorForm.UploadKClick(Sender: TObject);
var
    stat    : Integer;

begin
    YZmodemForm.Protocol := ptKermit;
    stat := YZModemForm.ShowModal;
    if (stat = mrOk) then
    begin
        XferProtocol.ProtocolType := ptKermit;
        XferProtocol.FileMask := YZModemForm.FileName;
        SockPort.FlushInBuffer;
        TermWindow.Active := False;
        XFerProtocol.StartTransmit;
    end;
    DoCommTrace;
end;

procedure TEmulatorForm.DownloadKClick(Sender: TObject);
begin
    with XferProtocol do
    begin
        ProtocolType := ptKermit;
        FileName := '';
        TermWindow.Active := False;
        StartReceive;
    end;
    DoCommTrace;
end;

procedure TEmulatorForm.UploadAClick(Sender: TObject);
var
    stat    : Integer;

begin
    AsciiForm.SendRecv := 'S';
    stat := AsciiForm.ShowModal;
    if (stat = mrOk) then
    begin
        XferProtocol.ProtocolType := ptAscii;
        XferProtocol.FileMask := AsciiForm.FileName;
        if (AsciiForm.XlateBtn.Checked) then
        begin
            XferProtocol.AsciiCRTranslation := aetStrip;
            XferProtocol.AsciiLFTranslation := aetNone;
        end else
        begin
            XferProtocol.AsciiCRTranslation := aetNone;
            XferProtocol.AsciiLFTranslation := aetNone;
        end;
        XferProtocol.StartTransmit;
    end;
    DoCommTrace;
end;

procedure TEmulatorForm.DownloadAClick(Sender: TObject);
var
    stat    : Integer;

begin
    AsciiForm.SendRecv := 'R';
    stat := AsciiForm.ShowModal;
    if (stat = mrOk) then
    begin
        XferProtocol.ProtocolType := ptAscii;
        XferProtocol.FileName := AsciiForm.FileName;
        if (AsciiForm.XlateBtn.Checked) then
        begin
            XferProtocol.AsciiCRTranslation := aetNone;
            XferProtocol.AsciiLFTranslation := aetAddCRBefore;
        end else
        begin
            XferProtocol.AsciiCRTranslation := aetNone;
            XferProtocol.AsciiLFTranslation := aetNone;
        end;
        XferProtocol.StartReceive;
    end;
end;

procedure TEmulatorForm.FtpMenuClick(Sender: TObject);
var
    stat     : Integer;

begin
    stat := FtpLoginForm.ShowModal;
    if (stat <> mrOk) then
        Exit;

    FtpForm.UserId := FtpLoginForm.UserId;
    FtpForm.Passwd := FtpLoginForm.Passwd;
    FtpForm.HostName := FtpLoginForm.HostName;
    FtpForm.ShowModal;
end;

procedure TEmulatorForm.HostsBtnClick(Sender: TObject);
begin
    HostsForm.ShowModal;
end;

procedure TEmulatorForm.CopyBtnClick(Sender: TObject);
begin
    TermWindow.CopyToClipboard;
end;

procedure TEmulatorForm.PasteBtnClick(Sender: TObject);
var
    clipBoard : TClipboard;
    cbText    : String;
    i         : Integer;

begin
    clipBoard := TClipboard.Create;
    try
        with clipBoard do
        begin
            if (HasFormat(CF_TEXT)) then
            begin
                cbText := AsText;
                for i:=1 to Length(cbText) do
                begin
                    if (cbText[i] <> #10) then
                        SockPort.PutChar(cbText[i]);
                end;
            end;
        end;
    finally
        clipBoard.Free;
    end;
end;

procedure TEmulatorForm.EditCopyClick(Sender: TObject);
begin
    CopyBtnClick(CopyBtn);
end;

procedure TEmulatorForm.EditPasteClick(Sender: TObject);
begin
    PasteBtnClick(PasteBtn);
end;

procedure TEmulatorForm.OptionsXferClick(Sender: TObject);
begin
    XferOptForm.ShowModal;
end;

procedure TEmulatorForm.Col80BtnClick(Sender: TObject);
begin
    Col80Btn.Enabled := False;
    Options80.Checked := True;
    Col132Btn.Enabled := True;
    Options132.Checked := False;
    ResizeWindow;
end;

procedure TEmulatorForm.Col132BtnClick(Sender: TObject);
begin
    Col80Btn.Enabled := True;
    Options80.Checked := False;
    Col132Btn.Enabled := False;
    Options132.Checked := True;
    ResizeWindow;

end;

procedure TEmulatorForm.Options80Click(Sender: TObject);
begin
    Col80BtnClick(Col80Btn);
end;

procedure TEmulatorForm.Options132Click(Sender: TObject);
begin
    Col132BtnClick(Col132Btn);
end;

procedure TEmulatorForm.HelpAboutClick(Sender: TObject);
begin
    AboutDialog.ShowModal;
end;

procedure TEmulatorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    DeleteFile('APRO.log.sav');
    DeleteFile('APRO.trc.sav');
    MoveFile('APRO.log', 'APRO.log.sav');
    MoveFile('APRO.trc', 'APRO.trc.sav');
end;

procedure TEmulatorForm.HelpContentsClick(Sender: TObject);
begin
    Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TEmulatorForm.OptionsLoggingClick(Sender: TObject);
begin
    OptionsLogging.Checked := not OptionsLogging.Checked;
    if (OptionsLogging.Checked) then
        SockPort.Logging := tlOn
    else
        SockPort.Logging := tlAppend;
end;

procedure TEmulatorForm.OptionsTraceClick(Sender: TObject);
begin
    OptionsTrace.Checked := not OptionsTrace.Checked;
    if (OptionsTrace.Checked) then
        SockPort.Tracing := tlOn
    else
        SockPort.Tracing := tlAppend;
end;

procedure TEmulatorForm.DoCommTrace;
begin
    with SockPort do
    begin
        if (OptionsLogging.Checked) then
            Logging := tlAppendAndContinue;
        if (OptionsTrace.Checked) then
            Tracing := tlAppendAndContinue;
    end;
end;

procedure TEmulatorForm.TapiDevTapiFail(Sender: TObject);
begin
    Caption := 'TransTerm';
    if (Assigned(DialingForm) and (DialingForm.Visible)) then
        DialingForm.Close;
end;

procedure TEmulatorForm.TermWindowCursorMoved(aSender: TObject; aRow,
  aCol: Integer);
begin
    StatusBar.Panels[1].Text := Format('%2d:%2d', [aRow, aCol]);
    StatusBar.Invalidate;
end;

end.
