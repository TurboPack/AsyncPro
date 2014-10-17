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
{*                   PDRVUNNT.PAS 4.06                   *}
{*********************************************************}
{* NT/2K/XP Printer driver installation                  *}
{*********************************************************}


{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$X+,I-,T-}
{$IFDEF Win32}
{$H-,J-}
{$ENDIF}

unit PDrvUnNT;
  {- Fax printer driver installation -- UniDriver support for NT}

interface

function UniDrvFilesExist : Boolean;
  { Returns True if the RASDD driver files are already installed }
function InstallNTUniDrvFiles : Integer;
  { Attempts to install RASDD driver files from setup disks }

implementation

uses
  Windows,
  WinSpool,
  SysUtils,
  IniFiles,
  Classes,
  OoMisc,
  LZExpand,
  ShellAPI,
  Messages,
  Dialogs;

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
  {- Note! This version assumes that both TextToFind and SectionToSearch are upper case }
var
  Buf       : array[0..255] of Char;
  GotSec    : Boolean;
  FoundText : Boolean;

begin
  Result := '';
  GotSec := False;
  FoundText := False;

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
  SizeNeeded : DWORD;                                              
  StBuf1 : array[0..255] of Char;
  StBuf2 : array[0..255] of Char;
  StBuf3 : array[0..255] of Char;
  SysDir : array[0..255] of Char;
begin
  UniDrvFilesExist := False;

  { get the Windows system directory }
  if not GetPrinterDriverDirectory(nil, nil, 1, @SysDir, sizeof(SysDir), SizeNeeded) then begin
    MessageDlg('Couldn''t determine the Windows NT printer driver directory',
               mtError, [mbOK], 0);
    Exit;
  end;

  StrCopy(StBuf1, SysDir);
  AddBackSlashZ(StBuf1, StBuf1);
  StrCopy(StBuf2, StBuf1);
  StrCopy(StBuf3, StBuf1);
  StrCat(StBuf1, 'Rasdd.dll');
  StrCat(StBuf2, 'Rasddui.dll');
  StrCat(StBuf3, 'Rasddui.hlp');
  UniDrvFilesExist := ExistFileZ(StBuf1) and ExistFileZ(StBuf2) and ExistFileZ(StBuf3);
end;

function InstallNTUniDrvFiles : Integer;
type
  PLocals = ^TLocals;
  TLocals = record
    InfTextFile   : TextFile;
    InfBuf        : TFileBuf;

    InfIniFile    : TIniFile;
    DiskList      : TStringList;
    Strings       : TStringList;
    WinOther      : TStringList;
    RASDDDLL      : ShortString;
    RASDDDLLDNum  : Byte;
    RASDDDLLFile  : ShortString;
    RASDDDLLDisk  : ShortString;
    RASDDUI       : ShortString;
    RASDDUIDNum   : Byte;
    RASDDUIFile   : ShortString;
    RASDDUIDisk   : ShortString;
    RASDDHLP      : ShortString;
    RASDDHLPDNum  : Byte;
    RASDDHLPFile  : ShortString;
    RASDDHLPDisk  : ShortString;

    WinDir        : array[0..255] of Char;
    SysDir        : array[0..255] of Char;
    DriverDir     : array[0..255] of Char;

    WinNT4Layout   : Boolean;
    Failed        : Boolean;
    OpenDialog    : TOpenDialog;

    St            : ShortString;
    StBuf         : array[0..255] of Char;
  end;

var
  LocalVars  : PLocals;
  SizeNeeded : DWORD;
  Ok         : Boolean;

  function InstallUniFile (SourceName : PChar; DestName : PChar) : Boolean;
    { Copy and uncompress one file }
  var
    StrBuf      : array[0..255] of Char;
    StrBuf1     : array[0..255] of Char;
  begin

    with LocalVars^ do begin

      StrCopy(StrBuf, '');

      StrCat(StrBuf, SourceName);
      StrCat(StrBuf, ' ');
      StrCat(StrBuf, DriverDir);
      AddBackSlashZ(StrBuf, StrBuf);
      StrCat(StrBuf, DestName);

      StrCopy(StrBuf1, '');
      StrCat(StrBuf1, DriverDir);
      AddBackSlashZ(StrBuf1, StrBuf1);
      StrCat(StrBuf1, DestName);
      if StrPos(SourceName, DestName) = nil then
        Result := (WinExecAndWait32('expand ', StrBuf, sw_Hide) <> -1)
      else
        Result := CopyFile(SourceName, StrBuf1, False);
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
      if OpenDialog <> nil then
        OpenDialog.Free;
      if Strings <> nil then
        Strings.Free;
    end;
  end;

  procedure ReplaceString(Strings : TStrings; var St : string);
    {- replaces expressions of the form %exp% with their name from Strings}
  var
    i,p1,p2 : integer;
    Key,Tmp : string;
  begin
    p1 := pos('%',St);
    if p1 <> 0 then begin
      delete(St,p1,1);
      p2 := pos('%',St);
      if p2 = 0 then
        raise exception.Create('Unexpected INF format encountered');
      Key := copy(St,p1,p2-p1);
      delete(St,p1,p2-p1+1);
      for i := 0 to pred(Strings.Count) do begin
        Tmp := Strings[i];
        if copy(Tmp,1,p2-p1) = Key then begin
          p2 := pos('=',Tmp);
          if p2 <> 0 then begin
            Insert(copy(Tmp,P2+1,MaxLongInt),St,p1);
            break;
          end;
        end;
      end;
    end;
  end;

begin
  GetMem(LocalVars, sizeof(TLocals));
  with LocalVars^ do begin
    InfIniFile := nil;
    DiskList := nil;
    OpenDialog := nil;

    if UniDrvFilesExist then begin
      CleanUp;
      Result := ecUniAlreadyInstalled;
      Exit;
    end;

    if (GetSystemDirectory(SysDir, sizeof(SysDir)) = 0) then begin
      CleanUp;
      Result := ecUniCannotGetWinDir;
      Exit;
    end;
    { get the Windows NT printer driver directory }
    if not GetPrinterDriverDirectory(nil, nil, 1, @DriverDir, sizeof(DriverDir), SizeNeeded) then begin
      CleanUp;
      Result := ecUniCannotGetPrinterDriverDir;
      Exit;
    end;
    if (GetWindowsDirectory(WinDir, sizeof(WinDir)) = 0) then begin
      CleanUp;
      Result := ecUniCannotGetWinDir;
      Exit;
    end;

    WinNT4Layout := True;
    StrCopy(StBuf, WinDir);
    StrCat(StBuf, '\INF\LAYOUT.INF');
    InfIniFile := TIniFile.Create(StrPas(StBuf));

    { find out what version of NT it is }
    St := InfIniFile.ReadString('version', 'signature', '');
    if (St <> '$Windows NT$') then
      WinNT4Layout := False;

    { read the disk name list and search for RASDD.DLL/HLP in this inf file }
    if WinNT4Layout then begin
      RasDDDLL := InfIniFile.ReadString('SourceDisksFiles', 'Rasdd.dll', '');
      RASDDHLP := InfIniFile.ReadString('SourceDisksFiles', 'Rasddui.hlp', '');
      RASDDUI := InfIniFile.ReadString('SourceDisksFiles', 'Rasddui.dll', '');

      Strings := TStringList.Create;
      InfIniFile.ReadSectionValues('Strings', Strings);

      RASDDDLLDNum := StrToIntDef(ExtractWordS(1, RASDDDLL, ','), 0);
      St := InfIniFile.ReadString('SourceDisksNames.x86',
                                  IntToStr(RASDDDLLDNum),'');
      RASDDDLLDisk := ExtractWordS(1, St, ',\');
      ReplaceString(Strings,RASDDDLLDisk);
      RASDDDLLFile := 'Rasdd.dl_';

      RASDDHLPDNum := StrToIntDef(ExtractWordS(1, RASDDHLP, ','), 0);
      St := InfIniFile.ReadString('SourceDisksNames.x86',
                                  IntToStr(RASDDHLPDNum),'');
      RASDDHLPDisk := ExtractWordS(1, St, ',\');
      ReplaceString(Strings,RASDDHLPDisk);
      RASDDHLPFile := 'Rasddui.hl_';

      RASDDUIDNum := StrToIntDef(ExtractWordS(1, RASDDUI, ','), 0);
      St := InfIniFile.ReadString('SourceDisksNames.x86',
                                  IntToStr(RASDDUIDNum),'');
      RASDDUIDisk := ExtractWordS(1, St, ',\');
      ReplaceString(Strings,RASDDUIDisk);
      RASDDUIFile := 'Rasddui.dl_';
    end else begin
      { NT 3.51 }
      InfIniFile.Free;

      StrCopy(StBuf, SysDir);
      StrCat(StBuf, '\SETUP.INF');
      InfIniFile := TIniFile.Create(StrPas(StBuf));

      DiskList := TStringList.Create;
      InfIniFile.ReadSectionValues('Source Media Descriptions', DiskList);

      Assign(InfTextFile, StrPas(SysDir) + '\PRINTER.INF');
      SetTextBuf(InfTextFile, InfBuf, sizeof(TFileBuf));
      Reset(InfTextFile);
      RASDDDLL := FindTextInSection(InfTextFile, pChar('RASDD'),pChar('[FILES-PRINTERDRIVER]'));
      RASDDHLP := FindTextInSection(InfTextFile, pChar('RASDD'),pChar('[FILES-PRINTERDRIVERHELP]'));
      RASDDUI := FindTextInSection(InfTextFile, pChar('RASDDUI'),pChar('[FILES-PRINTERCONFIG]'));
      Close(InfTextFile);
      
      RASDDDLLDNum := StrToInt(ExtractWordS(2, RASDDDLL, '=,'));
      RASDDDLLDisk := ExtractWordS(2, DiskList.Strings[pred(RASDDDLLDNum)],
                                   ',"');
      RASDDDLLFile := 'Rasdd.dl_';

      RASDDHLPDNum := StrToInt(ExtractWordS(2, RASDDHLP, '=,'));
      RASDDHLPDisk := ExtractWordS(2, DiskList.Strings[pred(RASDDHLPDNum)],
                                   ',"');
      RASDDHLPFile := 'Rasddui.hl_';

      RASDDUIDNum := StrToInt(ExtractWordS(2, RASDDUI, '=,'));
      RASDDUIDisk := ExtractWordS(2, DiskList.Strings[pred(RASDDUIDNum)],
                                   ',"');
      RASDDUIFile := 'Rasddui.dl_';
    end;

    Failed := False;
    OpenDialog := TOpenDialog.Create(nil);
    with OpenDialog do begin
      if RASDDDLLDisk = '' then
        Title := 'Browse to listed file'
      else
        Title := 'Insert ' + RASDDDLLDisk + ' and Browse to listed file';
      Filename := RASDDDLLFile;
      Options := [ofFileMustExist];
      Filter := Filename+'|'+'Rasdd.dl?'+'|'+'All files|*.*';
    end;
    Failed := not OpenDialog.Execute;

    if (not Failed) then
      { found RASDD.dll, uncompress it }
      Failed := not InstallUniFile(StrPCopy(StBuf, OpenDialog.Filename), 'Rasdd.dll');

    if (not Failed) and (RASDDHLPDNum <> RASDDDLLDNum) then begin
      { need another disk prompt }
      with OpenDialog do begin
        if RASDDDLLDisk = '' then
          Title := 'Browse to listed file'
        else
          Title := 'Insert ' + RASDDHLPDisk + ' and Browse to listed file';
        Filename := RASDDHLPFile;
        Filter := Filename+'|'+'Rasddui.hl?'+'|'+'All files|*.*';
        if not OpenDialog.Execute then
          Failed := True;
      end;
    end else
      if FileExists(ExtractFilePath(OpenDialog.FileName) + 'Rasddui.hlp') then
        OpenDialog.Filename := ExtractFilePath(OpenDialog.FileName) + 'Rasddui.hlp'
      else
        OpenDialog.FileName := ExtractFilePath(OpenDialog.FileName) + 'Rasddui.hl_';

    if (not Failed) then
      { found RASDDUI.hlp, uncompress it }
      Failed := not InstallUniFile(StrPCopy(StBuf, OpenDialog.Filename),
                                   'Rasddui.hlp');

    OpenDialog.Filename := RASDDUIFile;
    if (not Failed) and (RASDDUIDNum <> RASDDHLPDNum) then
      { need another disk prompt }
      with OpenDialog do begin
        if RASDDDLLDisk = '' then
          Title := 'Browse to listed file'
        else
          Title := 'Insert ' + RASDDUIDisk + ' and Browse to listed file';
        Filter := Filename+'|'+'Rasddui.dl?'+'|'+'All files|*.*';
        if not OpenDialog.Execute then
          Failed := True;
      end;

    if FileExists(ExtractFilePath(OpenDialog.FileName) + 'Rasddui.dll') then
      OpenDialog.FileName := ExtractFilePath(OpenDialog.FileName) + 'Rasddui.dll'
    else
      OpenDialog.FileName := ExtractFilePath(OpenDialog.FileName) + 'Rasddui.dl_';

    if (not Failed) then
      { found RASDDUI.DLL, uncompress it}
      Failed := not InstallUniFile(StrPCopy(StBuf, OpenDialog.Filename), 'Rasddui.dll');

    { make sure files were copied correctly to the windows system directory }
    Ok := UniDrvFilesExist;
    if not Ok then begin
      CleanUp;
      Result := ecRasDDNotInstalled;                                     {!!.05}
    end else begin
      CleanUp;
      Result := ecOK;
    end;
  end;
end;

end.
