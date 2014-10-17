{*********************************************************}
{*                 APFAXCNV.PAS 4.06                     *}
{*      Copyright (c) TurboPower Software 1997-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I AwDefine.inc}                                                        {!!.06}

{ 4.06 additions:
  removed unneeded $IFDEFs
  The fax printer driver supports several registry entries to control the
  print jobs. Absence of these values will cause default behavior.
  HKEY_LOCAL_MACHINE
    ApdRegKey - defined in OOMisc.pas as '\SOFTWARE\TurboPower\ApFaxCnv\Settings'
      // idShell conversions
      ShellHandle : Integer, determines whether we are in an idShell conversion
                    this is the window handle that will receive our messages
      ShellName   : string, the name of the resulting APF for an idShell conversion

      // spawning app when print job starts
      AutoExec    : string, the name of an app to spawn if a TApdFaxDriverInterface isn't found
      Timeout     : Integer, the time we'll wait for the app to spawn

      // debug logging
      EventLogging: Boolean, whether we log the codes/subcodes
      DumpLogging : Boolean, whether we record the raw printer data
      EventLog    : string, the path\name of the event log
      DumpLog     : string, the path\name of the dump log

      // general
      DefFileName : string, the default name of the resulting APF
      SuppressAV  : Boolean, true to suppress any APRO-raised AVs

      // Post-print job APF modifications
      HeadFiller  : Integer, a 1-byte value to be written to the APF's file header
                    in the Filler field, can be used to identify the machine, job, etc
      HeadPadding : string, a 26-char value to be written to the APF's file header
                    in the Padding field, can be used for phone number, ID, etc
      *remember, the Boolean is added manually in RegEdit via a DWORD value,
                 0 = false, 1 = true
}

{   SWB additions
    Changed to generate a pipe name uniquue to the current terminal services
    session, if running in a terminal services environment.  This requires the
    use of JwaWtsApi32.pas which is part of the Jedi Code Library which is
    available at http://delphi-jedi.org.  This project must be compiled with the
    DYNAMIC_LINK condition set to allow it to work if the terminal services API
    is not present.
}

library ApFaxCnv;

{$IFNDEF PRNDRV}
  !! Define PRNDRV in  Project | Options | Directories/Conditionals
  !! this will reduce the size of the driver
{$ENDIF}

uses
  Windows,
  SysUtils,
  Registry,
  OOMisc,
  AwFaxCvt,
  JwaWtsApi32;

{$R *.RES}

const
  Version = '1';
  EventLog : string = 'C:\FAXCONV.LOG';                                  {!!.06}
  DumpLog  : PAnsiChar = 'C:\FAXCONV.DMP';                               {!!.06}

var
  T : Text;
  EventLogging : Boolean;                                                {!!.06}
  DumpLogging  : Boolean;                                                {!!.06}
  SuppressAV   : Boolean;                                                {!!.06}
  UseTSPipe    : Boolean;                                                   // SWB
  TSPipeName   : String;                                                    // SWB

procedure LogEvent(Msg : ShortString);
  {- Write line of trace info to the log file}
begin
  if EventLogging then begin                                             {!!.06}
    try
      AssignFile(T,EventLog);{'C:\FAXCONV.LOG');}                        {!!.06}
      try
        Append(T);
      except
        on E:EInOutError do
          if E.ErrorCode = 2 then
            Rewrite(T)
          else
            raise;
      end;
      Write(T,DateTimeToStr(Now),':');
      WriteLn(T,Msg);
      CloseFile(T);
    except
      ShowException(ExceptObject,ExceptAddr);
    end;
  end;                                                                   {!!.06}
end;
// Return True if running on NT 4.0 or later                                // SWB
function  IsWinNT : Boolean;                                                // SWB
var                                                                         // SWB
    osi         : OSVERSIONINFO;                                            // SWB
begin                                                                       // SWB
    Result := False;                                                        // SWB
    osi.dwOSVersionInfoSize := SizeOf(osi);                                 // SWB
    if (GetVersionEx(osi) and (osi.dwMajorVersion >= 4)) then               // SWB
    begin                                                                   // SWB
        LogEvent('Running NT or later.');                                   // SWB
        Result := True;                                                     // SWB
    end;                                                                    // SWB
end;                                                                        // SWB

// Return True if the Terminal Services API dll is present                  // SWB
function  IsTerminalServices : Boolean;                                     // SWB
var                                                                         // SWB
    path        : array [0..MAX_PATH] of Char;                              // SWB
    fptr        : PChar;                                                    // SWB
begin                                                                       // SWB
    if (SearchPath(nil,                                                     // SWB
                   'wtsapi32.dll',                                          // SWB
                   nil,                                                     // SWB
                   SizeOf(path),                                            // SWB
                   path,                                                    // SWB
                   fptr) <> 0) then                                         // SWB
    begin                                                                   // SWB
        LogEvent('wtsapi32.dll present.');                                  // SWB
        Result := True                                                      // SWB
    end else                                                                // SWB
    begin                                                                   // SWB
        LogEvent('wtsapi32.dll NOT present.');                              // SWB
        Result := False;                                                    // SWB
    end;                                                                    // SWB
end;                                                                        // SWB

function ClientAppRunning : Boolean;
  {- Check whether the controlling app. has been started.}
var
  Semaphore : THandle;
begin
  Result := False;

  Semaphore := OpenSemaphore(SYNCHRONIZE, False, ApdSemaphoreName);
  if Semaphore <> 0 then
    begin
      CloseHandle(Semaphore);
      Result := True;
    end
  else
    begin
      LogEvent('OpenSemaphore failed.');
      LogEvent('Reason:'+IntToStr(GetLastError));
    end;

  LogEvent('ClientAppRunning?');
  if Result then
    LogEvent('Yes')
  else
    LogEvent('No');
end;

function GetClientAppPath : string;
  {- Read the client app path (if any) from the registry.}
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey,False);
    Result := Reg.ReadString('AutoExec');
    LogEvent('GetClientAppPath:'+Result);
  finally
    Reg.Free;
  end;
end;

function GetTimeout : LongInt;
  {- Read the timeout value for waiting for the client from the registry.}
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey,False);
    try
      Result := Reg.ReadInteger('Timeout');
    except
      Result := LongInt(INFINITE);
    end;
    LogEvent('Timeout:'+IntToStr(Result));
  finally
    Reg.Free;
  end;
end;

procedure GetDriverSettings;                                             {!!.06}
  {- See if we should be logging the major events and dumping the data  }
  {  called when the printer driver is loaded and when print jobs start }
var
  Reg : TRegistry;
  S : string;
  sid : Pointer;                                                            // SWB
  len : Cardinal;                                                           // SWB
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey, False);
    try
      EventLogging := Reg.ReadBool('EventLogging');
    except
      EventLogging := False;
    end;
    try
      EventLog := Reg.ReadString('EventLog');
    except
      EventLog := 'C:\FAXCONV.LOG';
    end;
    try
      DumpLogging := Reg.ReadBool('DumpLogging');
    except
      DumpLogging := False;
    end;
    try
      S := Reg.ReadString('DumpLog');
      StrPCopy(DumpLog, S);
    except
      DumpLog := 'C:\FAXCONV.DMP';
    end;
    try
      SuppressAV := Reg.ReadBool('SuppressAV');
    except
      SuppressAV := False;
    end;
    try                                                                     // SWB
      UseTSPipe := Reg.ReadBool('UseTSPipe');                               // SWB
    except                                                                  // SWB
      UseTSPipe := False;                                                   // SWB
    end;                                                                    // SWB
  finally
    Reg.Free;
  end;
  // Figure out if we are running in a Terminal Services environment and    // SWB
  // create a pipe name unique to the TS session if we are.  Use the        // SWB
  // default pipe name if we are not.                                       // SWB
  if (IsWinNT and IsTerminalServices) then                                  // SWB
  begin                                                                     // SWB
    if (WTSQuerySessionInformation(WTS_CURRENT_SERVER_HANDLE,               // SWB
                                   WTS_CURRENT_SESSION,                     // SWB
                                   WTSSessionId,                            // SWB
                                   sid,                                     // SWB
                                   len)) then                               // SWB
        TSPipeName := Format('%s-TS%d', [ApdPipeName, Cardinal(sid^)])      // SWB
    else                                                                    // SWB
        TSPipeName := ApdPipeName                                           // SWB
  end else                                                                  // SWB
    TSPipeName := ApdPipeName;                                              // SWB
  LogEvent('Pipe name=' + TSPipeName);                                      // SWB
end;

function GetDefaultFileName : string;                                    {!!.06}
var
  Reg : TRegistry;
begin
  Result := ApdDefFileName;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey, False);
    Result := Reg.ReadString('DefFileName');
    if Result = '' then
      Result := ApdDefFileName;
  finally
    Reg.Free;
  end;
end;

procedure GetHeaderMods(var FaxHeader : TFaxHeaderRec);                  {!!.06}
var
  Reg : TRegistry;
  temp : string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey, False);
    Temp := Reg.ReadString('HeadFiller');
    if Length(Temp) > 0 then
      FaxHeader.Filler := Ord(Temp[1]);
    Temp := Reg.ReadString('HeadPadding');
    if Length(Temp) > 26 then
      Temp := Copy(Temp, 1, 26);
    Move(Temp[1], FaxHeader.Padding, Length(Temp));
  finally
    Reg.Free;
  end;
end;

function GetShellHandle : THandle;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey, False);
    try
      Result := Reg.ReadInteger('ShellHandle');
    except
      Result := INVALID_HANDLE_VALUE;
    end;
    LogEvent('ShellHandle:'+IntToStr(Result));
  finally
    Reg.Free;
  end;
end;

function GetShellName : string;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey, False);
    Result := Reg.ReadString('ShellName');
    if Result = '' then
      Result := GetDefaultFileName;{ApdDefFileName;}                     {!!.06}
    LogEvent('ShellName:'+Result);
  finally
    Reg.Free;
  end;
end;

procedure RemoveShellRegKeys;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey,False);
    Reg.DeleteValue('ShellName');
    Reg.DeleteValue('ShellHandle');
    LogEvent('Removed shell reg keys');
  finally
    Reg.Free;
  end;
end;

procedure HandleError(const ErrorText : string);                         {!!.06}
begin
  LogEvent('***' + ErrorText);
  if not SuppressAV then
    raise Exception.Create(ErrorText);
end;

function StartClientApp(AppPath : string) : Bool;
  {- Execute command line with default settings.}
var
  StartupInfo : TStartupInfo;
  ProcessInfo : TProcessInformation;
begin
  FillChar(StartupInfo,Sizeof(StartupInfo),0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_SHOWDEFAULT;
  LogEvent('StartClientApp:'+AppPath);
  Result :=
  CreateProcess(
    nil,                   {Application name (nil = take from next arg.)}
    pChar(AppPath),
    nil,                   {Process security attributes}
    nil,                   {Thread security attributes}
    false,                 {Inheritance flag}
    CREATE_NEW_CONSOLE or  {Creation flags}
    NORMAL_PRIORITY_CLASS,
    nil,                   {Environment block}
    nil,                   {Current directory name}
    StartupInfo,
    ProcessInfo);
  if not Result then
    LogEvent('CreateProcess failed. Reason:'+IntToStr(GetLastError));
end;

const
  BufferSize = 16384; // Could be anything > 560 (two landscape scan lines)
type
  pScanNode = ^tScanNode;
  tScanNode =
    record
      {used for landscape orientation only}
      ScanLines : array[1..8] of pointer;
      slIndex   : byte;
      NextNode  : pScanNode;
    end;
  TBuffer = array[0..pred(BufferSize)] of Byte;
  TFaxConvData = record
    FileHandle      : THandle;               {Raw dump file handle}
    apfConverter    : PAbsFaxCvt;            {Converter handle}
    cvtLastError    : Integer;               {Last error reported by converter}
    Buffer          : TBuffer;               {Local data buffer}
    ReadPtr         : 0..pred(BufferSize);   {Next byte to be processed}
    BytesInBuffer   : 0..BufferSize;         {Bytes in buffer}
    HaveData        : Bool;                  {Indicates whether data has been converted but not written}
    IsLandscape     : Bool;
    slDest          : PByteArray;            {Used during landscape rotation}
    slDataSize      : Integer;               {Used during landscape rotation}
    slBitWidth      : Integer;
    FirstScanNode   : pScanNode;
    CurrentScanNode : pScanNode;
  end;
  PFaxConvData = ^TFaxConvData;

procedure FaxConvInit; cdecl;
  {- Called by port driver during initialization.}
  {- Can be used for initialization.}
begin
  try
    GetDriverSettings;                                                   {!!.06}
    LogEvent('FaxConvInit');
    { make sure we don't have any residual registry keys... }
    RemoveShellRegKeys;
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;

function FaxConvStartDoc(DocName : PWideChar) : THandle; cdecl;
  {- Called by port driver when a new document is about to print.}
  {- Create output file(s) and notify client (if any).}
var
  FaxConvData        : PFaxConvData {Our data structure for this job.}
    absolute Result;                {Note! Pointer treated as handle.}
  Res                : Bool;        {Pipe API result var.}
  BytesReadFromPipe  : DWord;
  Semaphore          : THandle;     {For waiting for client to start.}
  PipeReadBuffer,
  PipeWriteBuffer    : TPipeEvent;
  ClientAppName      : string;      {Path to auto-start client.}
  ShellHandle        : THandle;
begin
  // see if we should be logging this
  GetDriverSettings;                                                     {!!.06}
  LogEvent('FaxConvStartDoc'+WideCharToString(DocName));
  try
    Result := 0;
    { see if the TApdFaxConverter is doing a ShellExecute }
    ShellHandle := GetShellHandle;
    if ShellHandle = INVALID_HANDLE_VALUE then begin
      if not ClientAppRunning then begin
        ClientAppName := GetClientAppPath;
        if ClientAppName <> '' then begin
          Semaphore := CreateSemaphore(nil, 0, 1, ApdSemaphoreName);
          if Semaphore <> 0 then
            try
              if StartClientApp(ClientAppName) then
                begin
                  LogEvent('Client app. started');
                  if Semaphore <> 0 then begin
                    LogEvent('Waiting for client...');
                    WaitForSingleObject(Semaphore,GetTimeout);
                    LogEvent('Client signaled');
                  end;
                end
              else
                begin
                  LogEvent('!!! Client app. didn''t start');
                end;
            finally
              CloseHandle(Semaphore);
            end
          else
            LogEvent('Unable to create semaphore');
        end;
      end;
    end;
    New(FaxConvData);

    if DumpLogging then begin                                            {!!.06}
      FaxConvData^.FileHandle := CreateFile(DumpLog {'C:\FAXCONV.DMP'},  {!!.06}
                                 GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS,
                                 FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN,
                                 0 );

      if FaxConvData^.FileHandle <> INVALID_HANDLE_VALUE then
        SetEndOfFile(FaxConvData^.FileHandle);
    end;                                                                 {!!.06}

    with FaxConvData^  do begin

      BytesInBuffer := 0;
      ReadPtr := 0;

      acInitFaxConverter(apfConverter, nil, nil, nil, nil, '');

      acSetResolutionMode(apfConverter, True); // High

      if ShellHandle <> INVALID_HANDLE_VALUE then begin
        ClientAppName := GetShellName;  //re-using ClientAppName
        StrPCopy(apfConverter^.OutFileName, ClientAppName);
      end else begin
        StrPCopy(apfConverter^.OutFileName, GetDefaultFileName);         {!!.06}

        PipeWriteBuffer.Event := eStartDoc;
        PipeWriteBuffer.Data := WideCharToString(DocName);

        Res := CallNamedPipe(PChar(TSPipeName),                             // SWB
                             @PipeWriteBuffer, sizeof(PipeWriteBuffer),
                             @PipeReadBuffer, sizeof(PipeReadBuffer),
                             BytesReadFromPipe, NMPWAIT_USE_DEFAULT_WAIT);

        if Res then
          begin
            LogEvent(format('Wrote %d bytes to pipe.',[sizeof(PipeWriteBuffer)]));
            LogEvent(format('Read %d bytes from pipe.',[BytesReadFromPipe]));
            if BytesReadFromPipe > 0 then begin
              LogEvent(format('Read code %d from pipe.',[PipeReadBuffer.Event]));
              StrPCopy(apfConverter^.OutFilename,PipeReadBuffer.Data);
              LogEvent('File name supplied:'+apfConverter^.OutFilename);
            end;
          end
        else
          begin
            LogEvent('CallNamedPipe failed. Reason:'+IntToStr(GetLastError));
          end;
      end;
      LogEvent('Output file: ' + apfConverter^.OutFilename);
      cvtLastError := acCreateOutputFile(apfConverter);
      if cvtLastError <> ecOk then begin
        LogEvent('acCreateOutputFile failure'+IntToStr(cvtLastError));
        exit;
      end;
    end;

    FaxConvData.apfConverter.StatusWnd := ShellHandle;                   {!!.01}
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;

{Codes defined by the printer mini-driver}
const
  BEGINDOC = $41;
  BEGINPAGE = $42;
  ENDDOC = $43;
  ENDPAGE = $44;
  ABORT = $45;
  PORTRAIT = $46;
  LANDSCAPE = $47;
  MULTCOP = $48;
  XM_ABS = $58;
  YM_ABS = $59;
  SENDBLOCK = $4D;
  ENDBLOCK = $4E;
  HIRES = $52;
  LORES = $53;

procedure Advance(Handle : THandle);
  {- Move buffer read pointer one byte forward}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  with FaxConvData^ do begin
    inc(ReadPtr);
    dec(BytesInBuffer);
  end;
end;

procedure AdvanceN(Handle : THandle;N : DWord);
  {- Move buffer read pointer N bytes forward}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  with FaxConvData^ do begin
    inc(ReadPtr,N);
    dec(BytesInBuffer,N);
  end;
end;

procedure ProcessBuffer(Handle : THandle);
  {- Process next escape sequence in buffer, then advance the pointer.}
var
  FaxConvData : PFaxConvData absolute Handle;
  S : string;
  N,i : integer;
  BytesWritten : DWord;
begin
  with FaxConvData^ do
    case Buffer[ReadPtr] of
    $1B :
      begin
        Advance(Handle);
        case Buffer[ReadPtr] of
        BEGINDOC :
          begin
            LogEvent('BEGINDOC');
            LogEvent('Driver Version: ' + Version);
            LogEvent('APRO Version: ' + ApVersionStr);
            Advance(Handle);
            HaveData := False;
          end;
        BEGINPAGE :
          begin
            LogEvent('BEGINPAGE');
            Advance(Handle);
            inc(apfConverter^.CurrPage);
          end;
        ENDDOC :
          begin
            LogEvent('ENDDOC');
            Advance(Handle);
          end;
        ENDPAGE :
          begin
            if apfConverter.StatusWnd <> INVALID_HANDLE_VALUE then       {!!.01}
              PostMessage(apfConverter.StatusWnd, apw_EndPage, 0, 0);    {!!.01}
            LogEvent('ENDPAGE');
            with apfConverter^  do begin
              FillChar(TmpBuffer^, MaxData, 0);
              if HaveData then
                begin
                  N := ByteOfs;
                  HaveData := False;
                end
              else
                N := 0;
              cvtLastError := acOutToFileCallBack(apfConverter, DataLine^, N, True, True);
            end;
            Advance(Handle);

          end;
        ABORT :
          begin
            LogEvent('ABORT');
            Advance(Handle);
          end;
        PORTRAIT :
          begin
            LogEvent('PORTRAIT');
            IsLandscape := False;
            Advance(Handle);
          end;
        LANDSCAPE :
          begin
            LogEvent('LANDSCAPE');
            IsLandscape := True;
            Advance(Handle);
          end;
        MULTCOP :
          begin
            LogEvent('MULTCOP');
            Advance(Handle);
          end;
        XM_ABS :
          begin
            LogEvent('XM_ABS');
            Advance(Handle);
            S := '';
            while char(Buffer[ReadPtr]) <> 'X' do begin
              S := S + char(Buffer[ReadPtr]);
              Advance(Handle);
            end;
            Advance(Handle);
            LogEvent(S);
          end;
        YM_ABS :
          begin
            LogEvent('YM_ABS');
            Advance(Handle);
            S := '';
            while char(Buffer[ReadPtr]) <> 'Y' do begin
              S := S + char(Buffer[ReadPtr]);
              Advance(Handle);
            end;
            Advance(Handle);
            LogEvent(S);
            N := StrToInt(S);
            { in Standard Res, RASDD is giving us YMove twice as big as they }
            { should be, we're dividing the increment in half here }
            if not apfConverter^.UseHighRes then
              N := N div 2;
            if HaveData then begin
              with ApfConverter^  do
                cvtLastError := acOutToFileCallBack(apfConverter, DataLine^, ByteOfs, False, True);
              HaveData := False;
            end;
            with ApfConverter^  do begin
              FillChar(TmpBuffer^, MaxData, 0);
              acCompressRasterLine(apfConverter, TmpBuffer^);
            end;
            for i := 1 to pred(N) do
              with ApfConverter^  do
                cvtLastError := acOutToFileCallBack(apfConverter, DataLine^, ByteOfs, False, True);
          end;
        SENDBLOCK :
          begin
            if HaveData then begin
              with ApfConverter^  do
                cvtLastError := acOutToFileCallBack(apfConverter, DataLine^, ByteOfs, False, True);
              HaveData := False;
            end;
            LogEvent('SENDBLOCK');
            Advance(Handle);
            S := '';
            while char(Buffer[ReadPtr]) <> 'M' do begin
              S := S + char(Buffer[ReadPtr]);
              Advance(Handle);
            end;
            Advance(Handle);
            LogEvent(S);
            N := StrToInt(S);

            if DumpLogging then                                          {!!.06}
              WriteFile(FileHandle,Buffer[ReadPtr],N,BytesWritten,nil);

            with ApfConverter^  do begin
              FillChar(TmpBuffer^, MaxData, 0);
              Move(Buffer[ReadPtr], TmpBuffer^, N);
              acCompressRasterLine(apfConverter, TmpBuffer^);
              FillChar(TmpBuffer^, MaxData, 0);
              HaveData := True;
            end;
            AdvanceN(Handle,N);
          end;
        ENDBLOCK :
          begin
            LogEvent('ENDBLOCK');
            Advance(Handle);
          end;
        HIRES :
          begin
            LogEvent('HIRES');
            Advance(Handle);
            acSetResolutionMode(apfConverter, True);
          end;
        LORES :
          begin
            LogEvent('LORES');
            Advance(Handle);
            acSetResolutionMode(apfConverter, False);
          end;
        else begin                                                       {!!.06}
          HandleError(format('Unexpected subcode in stream:%x',          {!!.06}
            [Buffer[ReadPtr]]));                                         {!!.06}
          Advance(Handle);                                               {!!.06}
        end;                                                             {!!.06}
        end
      end
    else begin                                                           {!!.06}
      HandleError(format('Unexpected code in stream:%x',                 {!!.06}
        [Buffer[ReadPtr]]));                                             {!!.06}
      Advance(Handle);                                                   {!!.06}
    end;                                                                 {!!.06}
  end;
end;

procedure TrimBuffer(Handle : THandle);
  {- Remove data already processed from the buffer.}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  with FaxConvData^ do begin
    move(Buffer[ReadPtr],Buffer,BytesInBuffer);
    ReadPtr := 0;
  end;
end;

procedure AddToBuffer(Handle : THandle;var InBuffer;InBufSize : DWord);
  {- Append data to buffer - process and trim as necessary to make it fit.}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  with FaxConvData^ do begin
    while BytesInBuffer + InBufSize > BufferSize do
      ProcessBuffer(Handle);
    TrimBuffer(Handle);
    move(InBuffer,Buffer[BytesInBuffer],InBufSize);
    inc(BytesInBuffer,InBufSize);
  end;
end;

procedure FaxConvEndDoc(Handle : THandle); cdecl;
  {- Called by driver when no more data is pending.}
  {- Process any remaining data in buffer and close output file(s).}
var
  FaxConvData : PFaxConvData absolute Handle;
  PipeWriteBuffer : TPipeEvent;
  BytesReadFromPipe : DWord;
  ShellHandle : THandle;
begin
  try
    LogEvent('FaxConvEndDoc');
    with FaxConvData^ do begin
      while BytesInBuffer > 0 do
        ProcessBuffer(Handle);

      if DumpLogging then                                                {!!.06}
        CloseHandle(FaxConvData.FileHandle);

      { insert HeadFiller and HeadPadding from registry }
      GetHeaderMods(apfConverter.MainHeader);                            {!!.06}

      if apfConverter <> nil then begin
        with apfConverter^ do
          cvtLastError := acCloseOutputFile(apfConverter);

        LogEvent('Closing output file: ' + apfConverter^.OutFilename);
        if cvtLastError <> ecOk then
          LogEvent('acCloseOutputFile failure'+IntToStr(cvtLastError));

        acDoneFaxConverter(apfConverter);

        ShellHandle := GetShellHandle;
        if ShellHandle <> INVALID_HANDLE_VALUE then begin
          LogEvent('Posting message to fax converter (' + IntToStr(ShellHandle) + ')');
          PostMessage(ShellHandle, apw_EndDoc, 0, 0);
          RemoveShellRegKeys;
        end else begin
          PipeWriteBuffer.Event := eEndDoc;

          CallNamedPipe(PChar(TSPipeName),                                  // SWB
                        @PipeWriteBuffer, sizeof(PipeWriteBuffer),
                        nil,0,
                        BytesReadFromPipe, NMPWAIT_NOWAIT);
        end;
      end;
    end;
    Dispose(FaxConvData);
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;

procedure FaxConvConvert(Handle : THandle;var InBuffer; InBufSize : DWord); cdecl;
  {- Called by driver for each block of data sent by Windows.}
  {- Put data block in buffer.}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  try
    LogEvent('FaxConvConvert');
    AddToBuffer(Handle,InBuffer,InBufSize);
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;

exports
  FaxConvInit,
  FaxConvStartDoc,
  FaxConvEndDoc,
  FaxConvConvert;

begin
end.

