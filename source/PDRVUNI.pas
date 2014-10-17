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
{*                   PDRVUNI.PAS 4.06                    *}
{*********************************************************}
{* Win9x/ME Printer driver installation methods          *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$X+,I-,T-}
{$H-,J-}

unit PDrvUni;
  {- Fax printer driver installation -- UniDrv.DLL/.HLP support }

interface

function UniDrvFilesExist : Boolean;
  { Returns True if both UniDrv.DLL and UniDrv.HLP are already installed }
function InstallUniDrvFiles : Integer;
  { Attempts to install UniDrv.DLL and UniDrv.HLP from setup disks }

implementation

uses
  SysUtils,
  IniFiles,
  Classes,
  OoMisc,
  LZExpand,
  ShellAPI,
  WinProcs,
  WinTypes,
  Messages,
  CommDlg;

type
  PFileBuf      = ^TFileBuf;
  TFileBuf      = array[0..16383] of Byte;

function CharExistsS(const S : ShortString; C : AnsiChar) : Boolean; register;
  {-Determine whether a given character exists in a string. }
asm
  xor   ecx, ecx
  mov   ch, [eax]
  inc   eax
  or    ch, ch
  jz    @@Done
  jmp   @@5

@@Loop:
  cmp   dl, [eax+3]
  jne   @@1
  inc   cl
  jmp   @@Done

@@1:
  cmp   dl, [eax+2]
  jne   @@2
  inc   cl
  jmp   @@Done

@@2:
  cmp   dl, [eax+1]
  jne   @@3
  inc   cl
  jmp   @@Done

@@3:
  cmp   dl, [eax+0]
  jne   @@4
  inc   cl
  jmp   @@Done

@@4:
  add   eax, 4
  sub   ch, 4

@@5:
  cmp   ch, 4
  jge   @@Loop

  cmp   ch, 3
  je    @@1

  cmp   ch, 2
  je    @@2

  cmp   ch, 1
  je    @@3

@@Done:
  xor   eax, eax
  mov   al, cl
end;

function WordPositionS(N : Cardinal; S, WordDelims : ShortString;
                      var Pos : Cardinal) : Boolean;
  {-Given an array of word delimiters, set Pos to the start position of the
    N'th word in a string.  Result indicates success/failure.}
var
  I     : Cardinal;
  Count : Byte;
  SLen  : Byte absolute S;
begin
  Count := 0;
  I := 1;
  Result := False;

  while (I <= SLen) and (Count <> N) do begin
    {skip over delimiters}
    while (I <= SLen) and CharExistsS(WordDelims, S[I]) do
      Inc(I);

    {if we're not beyond end of S, we're at the start of a word}
    if I <= SLen then
      Inc(Count);

    {if not finished, find the end of the current word}
    if Count <> N then
      while (I <= SLen) and not CharExistsS(WordDelims, S[I]) do
        Inc(I)
    else
      Pos := I;
      Result := True;
  end;
end;

function ExtractWordS(N : Cardinal; S, WordDelims : ShortString) : ShortString;
  {-Given an array of word delimiters, return the N'th word in a string.}
var
  I    : Cardinal;
  Len  : Byte;
  SLen : Byte absolute S;
begin
  Len := 0;
  if WordPositionS(N, S, WordDelims, I) then
    {find the end of the current word}
    while (I <= SLen) and not CharExistsS(WordDelims, S[I]) do begin
      {add the I'th character to result}
      Inc(Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  Result[0] := Char(Len);
end;

function WinExecAndWait32(FileName : PChar; CommandLine : PChar;
                          Visibility : Integer) : Integer;
 { returns -1 if the Exec failed, otherwise returns the process' exit
   code when the process terminates }
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir:ShortString;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  Temp : DWORD;
begin
  StrCopy(zAppName, FileName);
  StrCat(zAppName, CommandLine);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
      zAppName,                      { pointer to command line string }
      nil,                           { pointer to process security attributes }
      nil,                           { pointer to thread security attributes }
      false,                         { handle inheritance flag }
      CREATE_NEW_CONSOLE or          { creation flags }
      NORMAL_PRIORITY_CLASS,
      nil,                           { pointer to new environment block }
      nil,                           { pointer to current directory name }
      StartupInfo,                   { pointer to STARTUPINFO }
      ProcessInfo) then              { pointer to PROCESS_INF }
        Result := -1
  else begin
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess,Temp);
    Result := Integer(Temp);
  end;
end;

function FindTextInSection (var F : Text; TextToFind : PChar;
                            SectionToSearch : PChar) : ShortString;
var
  Buf       : array[0..255] of Char;
  GotSec    : Boolean;
  FoundText : Boolean;

begin
  Result := '';
  GotSec := False;
  FoundText := False;
  TextToFind := StrUpper(TextToFind);
  SectionToSearch := StrUpper(SectionToSearch);

  Reset(F);
  while (not GotSec) and (not eof(F)) do begin
    Readln(F, Buf);
    GotSec := (StrPos(StrUpper(Buf), SectionToSearch) <> nil);
  end;

  while (not FoundText) and GotSec do begin
    Readln(F, Buf);
    FoundText := (StrPos(StrUpper(Buf), TextToFind) <> nil);

    { did we start a new section? }
    if (Buf[0] = '[') and (Buf[pred(StrLen(Buf))] = ']') then
      GotSec := False;
  end;

  if FoundText then
    Result := StrPas(Buf);
end;

function UniDrvFilesExist : Boolean;
var
  StBuf1 : array[0..255] of Char;
  StBuf2 : array[0..255] of Char;

var
  SysDir        : array[0..255] of Char;

begin
  UniDrvFilesExist := False;

  { get the Windows system directory }
  if (GetSystemDirectory(SysDir, sizeof(SysDir)) = 0) then begin
    MessageBox(0, 'Couldn''t determine Windows\System directory', 'Error', MB_ICONEXCLAMATION);
    Exit;
  end;

  StrCopy(StBuf1, SysDir);
  AddBackSlashZ(StBuf1, StBuf1);
  StrCopy(StBuf2, StBuf1);
  StrCat(StBuf1, 'unidrv.dll');
  StrCat(StBuf2, 'unidrv.hlp');
  UniDrvFilesExist := ExistFileZ(StBuf1) and ExistFileZ(StBuf2);
end;

function InstallUniDrvFiles : Integer;
type
  PLocals = ^TLocals;
  TLocals = record
    InfTextFile   : TextFile;
    InfBuf        : TFileBuf;

    InfIniFile    : TIniFile;
    DiskList      : TStringList;
    WinOther      : TStringList;
    UniDrvDLL     : ShortString;
    UniDrvDLLDNum : Byte;
    UniDrvDLLFile : ShortString;
    UniDrvDLLDisk : ShortString;
    UniDrvHLP     : ShortString;
    UniDrvHLPDNum : Byte;
    UniDrvHLPFile : ShortString;
    UniDrvHLPDisk : ShortString;
    IconLib       : ShortString;
    IconLibDNum   : Byte;
    IconLibFile   : ShortString;
    IconLibDisk   : ShortString;

    WinDir        : array[0..255] of Char;
    SysDir        : array[0..255] of Char;

    Win95Layout   : Boolean;
    Failed        : Boolean;
    OpenDialog    : TOpenFileName;

    St            : ShortString;
    StBuf         : array[0..255] of Char;
    FileBuf       : array[0..255] of Char;
    TitleBuf      : array[0..255] of Char;
    FilterBuf     : array[0..255] of Char;
  end;

var
  LocalVars : PLocals;
  Temp      : string;                                               
  Ok        : Boolean;

  function InstallUniFile (SourceName : PChar; DestName : PChar) : Boolean;
    { Copy and uncompress one file }
  var
    ofStrSrc    : TOFStruct;
    ofStrDst    : TOFStruct;
    hfSrcFile   : Integer;
    hfDstFile   : Integer;
    StrBuf      : array[0..255] of Char;
  begin

    with LocalVars^ do
      if Win95Layout then begin
        StrCopy(StrBuf, ' /c extract.exe /Y /L ');                   
        StrCat(StrBuf, SysDir);
        StrCat(StrBuf, ' ');
        StrCat(StrBuf, SourceName);
        StrCat(StrBuf, ' ');
        StrCat(StrBuf, DestName);
        InstallUniFile :=
          (WinExecAndWait32('command.com', StrBuf, sw_Hide) <> -1);

        if not(FileExists(StrPas(SysDir) + '\' + StrPas(DestName))) then
          { file was not in specified CAB, if additional cabs are found }
          { we assume cabs are on CD, so we search all cabs for files   }
          if FileExists(ExtractFilePath(StrPas(SourceName)) + 'WIN95_02.CAB') then begin
            StrCopy(StrBuf, ' /c extract.exe /A /Y /L ');
            StrCat(StrBuf, SysDir);
            StrCat(StrBuf, ' ');
            StrCat(StrBuf, 'WIN95_02.CAB');
            StrCat(StrBuf, ' ');
            StrCat(StrBuf, DestName);
            Result := (WinExecAndWait32('command.com', StrBuf, sw_Hide) <> -1);
          end;

      end else begin
        InstallUniFile := False;
        StrCopy(StrBuf, SysDir);
        AddBackSlashZ(StrBuf, StrBuf);
        StrCat(StrBuf, DestName);
        hfSrcFile := LZOpenFile(SourceName, ofStrSrc, OF_READ);
        hfDstFile := LZOpenFile(StrBuf, ofStrDst, OF_CREATE);
        if (hfSrcFile <> -1) and (hfDstFile <> -1) then
          InstallUniFile := (LZCopy(hfSrcFile, hfDstFile) <> -1);
        LZClose(hfSrcFile);
        LZClose(hfDstFile);
      end;
  end;

  function FilterCopy(P : PChar; const S : string): PChar;
  begin
    Result := nil;
    if S <> '' then begin
      Result := StrPCopy(P, S);
      while P^ <> #0 do begin
        if P^ = '|' then P^ := #0;
        Inc(P);
      end;
      Inc(P);
      P^ := #0;
    end;
  end;

  procedure CleanUp;
  begin
    {free memory}
    with LocalVars^ do begin
      if InfIniFile <> nil then
        InfIniFile.Free;
      if DiskList <> nil then
        DiskList.Free;
    end;
  end;

begin
  Result := ecOK;
  GetMem(LocalVars, sizeof(TLocals));
  with LocalVars^ do begin
    InfIniFile := nil;
    DiskList := nil;
    FillChar(OpenDialog, SizeOf(OpenDialog), 0);

    if UniDrvFilesExist then begin
      Result := ecUniAlreadyInstalled;
    end;

    { get the Windows system directory and Windows directory }
    if (GetSystemDirectory(SysDir, sizeof(SysDir)) = 0) then begin
      CleanUp;
      Result := ecUniCannotGetSysDir;
      Exit;
    end;
    if (GetWindowsDirectory(WinDir, sizeof(WinDir)) = 0) then begin
      CleanUp;
      Result := ecUniCannotGetWinDir;
      Exit;
    end;

    Win95Layout := False;
    StrCopy(StBuf, SysDir);
    StrCat(StBuf, '\SETUP.INF');
    InfIniFile := TIniFile.Create(StrPas(StBuf));
    St := InfIniFile.ReadString('setup', 'help', '');
    if (St = '') then begin
      { must be Windows95, so open Layout.Inf instead }
      InfIniFile.Free;
      StrCopy(StBuf, WinDir);
      StrCat(StBuf, '\INF\LAYOUT.INF');
      InfIniFile := TIniFile.Create(StrPas(StBuf));

      { confirm that it's Windows95 }
      St := InfIniFile.ReadString('version', 'signature', '');
      if (St <> '$CHICAGO$') then begin
        CleanUp;
        Result := ecUniUnknownLayout;
        Exit;
      end;

      Win95Layout := True;

      if Result = ecUniAlreadyInstalled then
      { check to see if ICONLIB.DLL is installed }
        if not(FileExists(StrPas(SysDir) + '\iconlib.dll')) then
          Result := ecOK;
    end;
    if Result  <> ecOK then begin
      CleanUp;
      Result := ecUniAlreadyInstalled;
      Exit;
    end;

    { read the disk name list and search for UniDrv.DLL/HLP in this inf file }
    if Win95Layout then begin
      UniDrvDLL := InfIniFile.ReadString('SourceDisksFiles', 'unidrv.dll', '');
      UniDrvHLP := InfIniFile.ReadString('SourceDisksFiles', 'unidrv.hlp', '');
      IconLib := InfIniFile.ReadString('SourceDisksFiles', 'iconlib.dll', '');
      { It's OK if we can't find/parse the INF. Some installations of Windows }
      { do not install the LAYOUT.INF, so we will let the user browse for     }
      { the required files.  Default cab numbers are from the Win98SE MSDN CD }

      UniDrvDLLDNum := StrToIntDef(ExtractWordS(1, UniDrvDLL, ','), 13);
      St := InfIniFile.ReadString('SourceDisksNames',
                                  IntToStr(UniDrvDLLDNum),
                                  '');
      UniDrvDLLDisk := ExtractWordS(1, St, ',"');
      UniDrvDLLFile := ExtractWordS(2, St, ',"');

      UniDrvHLPDNum := StrToIntDef(ExtractWordS(1, UniDrvHLP, ','), 17);
      St := InfIniFile.ReadString('SourceDisksNames',
                                  IntToStr(UniDrvHLPDNum),
                                  '');
      UniDrvHLPDisk := ExtractWordS(1, St, ',"');
      UniDrvHLPFile := ExtractWordS(2, St, ',"');

      IconLibDNum := StrToIntDef(ExtractWordS(1, IconLib, ','), 12);
      St := InfIniFile.ReadString('SourceDisksNames',
                                  IntToStr(IconLibDNum),
                                  '');
      IconLibDisk := ExtractWordS(1, St, ',"');
      IconLibFile := ExtractWordS(2, St, ',"');
    end else begin
      { not Windows 95 }
      CleanUp;
      Result := ecUniUnknownLayout;
      Exit;
    end;

    Failed := False;
    OpenDialog.hInstance := HInstance;
    with OpenDialog do begin
      lStructSize := SizeOf(OpenDialog);
      Temp := 'Insert ' + UniDrvDLLDisk + ' and Browse to listed file';
      lpstrTitle := StrPCopy(TitleBuf, Temp);
      nMaxFile := SizeOf(FileBuf);
      lpstrFile := StrPCopy(FileBuf, UniDrvDLLFile);
      Flags := OFN_FILEMUSTEXIST;
      lpStrFilter := FilterCopy(FilterBuf,
        UniDrvDLLFile+'|'+UniDrvDLLFile+'|'+'All files|*.*');
    end;
    Failed := not GetOpenFileName(OpenDialog);

   if (not Failed) then
      { found unidrv.dll, uncompress it or extract it from cab file }
      Failed := not InstallUniFile(StrCopy(StBuf, OpenDialog.lpstrFile), 'unidrv.dll');

    if (not Failed) and (UniDrvHLPDNum <> UniDrvDLLDNum) then begin
      { if the new file is in the same directory, we don't need to show the dialog again }
      if not(FileExists(ExtractFilePath(
        StrPas(OpenDialog.lpstrFile)) + UniDrvHlpFile)) then
        { need another disk prompt }
        with OpenDialog do begin
          Temp := 'Insert ' + UniDrvHLPDisk + ' and Browse to listed file';
          lpstrTitle := StrPCopy(TitleBuf, Temp);
          nMaxFile := SizeOf(FileBuf);

          lpstrFile := StrPCopy(FileBuf, UniDrvHLPFile);
          lpStrFilter := FilterCopy(FilterBuf,
            UniDrvHLPFile+'|'+UniDrvHLPFile+'|'+'All files|*.*');
          Failed := not GetOpenFileName(OpenDialog);
        end;
    end;
    
    if (not Failed) then
      { found unidrv.hlp, uncompress it or extract it from cab file }
      Failed := not InstallUniFile(
        StrPCopy(StBuf,ExtractFilePath(
        StrPas(OpenDialog.lpstrFile)) + UniDrvHlpFile), 'unidrv.hlp');

    if Win95Layout then begin
      if (not Failed) and (IconLibDNum <> UniDrvHLPDNum) then
        { if the new file is in the same directory, we don't need to show the dialog again }
        if not(FileExists(ExtractFilePath(
          StrPas(OpenDialog.lpstrFile)) + IconLibFile)) then
          with OpenDialog do begin
            { need another disk prompt }
            Temp := 'Insert ' + IconLibDisk + ' and Browse to listed file';
            lpstrTitle := StrPCopy(TitleBuf, Temp);
                  nMaxFile := SizeOf(FileBuf);

            lpstrFile := StrPCopy(FileBuf, IconLibFile);
            lpStrFilter := FilterCopy(FilterBuf,
              IconLibFile+'|'+IconLibFile+'|'+'All files|*.*');
            Failed := not GetOpenFileName(OpenDialog);
          end;
      if (not Failed) then
        { found unidrv.hlp, uncompress it or extract it from cab file }
        Failed := not InstallUniFile(StrCopy(StBuf,
           StrPCopy(StBuf,ExtractFilePath(
          StrPas(OpenDialog.lpstrFile)) + IconLibFile)), 'iconlib.dll');
    end;

    { make sure files were copied correctly to the windows system directory }
    { some Windows install CDs do not include Unidrv.hlp, so ignore it if we }
    { don't find it }
    Ok := ExistFileZ(StrPCopy(StBuf, StrPas(SysDir) + '\unidrv.dll'))
      and ExistFileZ(StrPCopy(StBuf, StrPas(SysDir) + '\iconlib.dll'));
    if not Ok then begin
      CleanUp;
      Result := ecUniCannotInstallFile;
    end else begin
      CleanUp;
      Result := ecOK;
    end;
  end;
end;

end.
