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
{*                   PDRVINST.PAS 4.06                   *}
{*********************************************************}
{* Printer driver installation                           *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$X+,I-,T-}
{$IFDEF Win32}
{$H-,J-}
{$ENDIF}

unit PDrvInst;
  {- Fax printer driver installation unit }

  {Note: Does not install compressed printer driver files}

interface

uses
  OoMisc,
  AdExcept,
  SysUtils;

type
  TInstallDriverCallback = function : Boolean;
  NotFoundException = class(Exception);
  CantCopyException = class(Exception);

const
  InstallDriverCallback : TInstallDriverCallback = nil;

var
  DrvInstallError : Integer;
    { Contains the error code for the printer driver installation }
  DrvInstallExtError : Integer;
    { Contains the extended error for the printer driver installation }
  ErrorFile : string;
    { Contains the name of the file that couldn't be processed }

function InstallDriver (Filename : ShortString) : Boolean;
  { Attempt to install the print driver.  Return True if successful. }

implementation

uses
  WinTypes,
  WinProcs,
  WinSpool,
  Registry,
  Messages,
  PDrvUni;

type
  PPrinterStrings = ^TPrinterStrings;
  TPrinterStrings =
    record
      pPortName       : ShortString;               {eg, PRINTFAX:}
      pDriverName     : ShortString;               {eg, APF Fax}
      pComment        : ShortString;
      pSepFile        : ShortString;
      pServerName     : ShortString;
      pPrintProcessor : ShortString;
      pDataType       : ShortString;
      pDriverFileBase : ShortString;               {eg, APFFILE}
      pDriverFileName : ShortString;               {eg, APFFILE.DRV}
      SourceDirectory : ShortString;               {eg, A:\INSTALL\}
    end;

var
  PrinterStrings      : PPrinterStrings;

{-------------------------------------------------}
{ Copy the printer driver to the system directory }
{-------------------------------------------------}

procedure CopyDriverToSystemDirectory;
  { Copy the fax printer driver to the windows system directory }
var
  lpszSrcFilename : PChar;
  lpszDestFilename: PChar;
  lpszSrcDir      : PChar;
  lpszDestDir     : PChar;
  lpszCurDir      : PChar;
  lpszTempFile    : PChar;
  TempFileLen     : DWORD;

begin
  with PrinterStrings^ do begin
    lpszSrcFilename := StrAlloc(Max_Path);
    lpszSrcDir := StrAlloc(Max_Path);
    lpszDestDir := StrAlloc(Max_Path);
    lpszTempFile := StrAlloc(Max_Path);

    try                                                              
      StrPCopy(lpszSrcFilename, pDriverFileName);
      lpszDestFilename := lpszSrcFilename;
      StrPCopy(lpszSrcDir, SourceDirectory);
      lpszCurDir := nil;
      TempFileLen := Max_Path;

      GetSystemDirectory(lpszDestDir, Max_Path);
      DrvInstallExtError := VerInstallFile(0, lpszSrcFilename,
                                           lpszDestFilename,
                                           lpszSrcDir, lpszDestDir,
                                           lpszCurDir,
                                           lpszTempFile, TempFileLen);

      if DrvInstallExtError <> 0 then
        if (DrvInstallExtError and (VIF_FILEINUSE or VIF_SRCOLD)) = 0 then
          if (DrvInstallExtError and VIF_CANNOTREADSRC) <> 0 then
            raise NotFoundException.Create(StrPas(lpszSrcFilename))
          else
            raise CantCopyException.Create(StrPas(lpszSrcFilename));

    finally
      StrDispose(lpszTempFile);
      StrDispose(lpszDestDir);
      StrDispose(lpszSrcDir);
      StrDispose(lpszSrcFilename);
    end;                                                              
  end;
end;

{-----------------------------------------------------------------}
{ Code for reading string table entries directly from driver file }
{-----------------------------------------------------------------}

{ resource ID constants for printer driver installation strings }
{$I PDrvInst.INC}

type
  PStringTableItem = ^TStringTableItem;
  TStringTableItem =
    record
      Id    : Word;
      Tag   : ShortString;
      Next  : PStringTableItem;
    end;

procedure BuildStringTableList (var StringTableList : PStringTableItem);
  { Build a linked list of all string table entries in driver file }
type
  {Old header snippet}
  OldHeader =
    record
      Junk1         : array[1..$18] of Char;
      NewHeaderFlag : Byte;
      Junk2         : array[1..$23] of Char;
      NewHeaderOfs  : Word;
    end;

  {New header snippet}
  NewHeader =
    record
      Junk : array[1..36] of Byte;
      ResTableOfs   : Word;
    end;

  {Resource table entry}
  ResourceNameInfo =
    record
      rnOffset : Word;
      rnLength : Word;
      rnFlags  : Word;
      rnID     : Word;
      rnHandle : Word;
      rnNLoad  : Word;
    end;

var
  F        : File;
  OH       : OldHeader;
  NH       : NewHeader;
  RN       : ResourceNameInfo;
  ResType  : Word;
  Count    : Word;
  Align    : Word;
  ANode    : PStringTableItem;
  SaveMode : Byte;                                                  

  function ReadNextType : Boolean;
    {-Read the next resource type record}
  begin
    {Read resource type and count}
    BlockRead(F, ResType, 2);
    BlockRead(F, Count, SizeOf(Count));
    ReadNextType := Lo(ResType) <> 0;
  end;

  procedure SkipNextType;
    {-Skip all nameinfo entries for this resource type}
  var
    I : Word;
    Junk : array[1..5] of Word;
  begin
    BlockRead(F, Junk, 4);
    for I := 1 to Count do
      BlockRead(F, RN, SizeOf(RN));
  end;

  procedure ReadStringResource (var NextNode : PStringTableItem);
    {-Load the string table into an internal list}
  var
    Junk      : array[1..10] of Byte;
    B         : Byte;
    Adjust    : Longint;
    i,j       : Integer;
    SavedPos  : Longint;

  begin
    BlockRead(F, Junk, 4);    { reserved bytes }

    for j := 1 to count do begin
      BlockRead(F, RN, SizeOf(RN));
      Adjust := 2 shl pred(Align);
      SavedPos := FilePos(f);

      Seek(F, LongInt(RN.rnOffset)*Adjust);
      for i := 0 to 15 do begin
        BlockRead(F, B, 1);
        if B <> 0 then begin
          if NextNode <> nil then begin
            GetMem(NextNode^.Next, sizeof(TStringTableItem));
            NextNode := NextNode^.Next;
          end else begin
            GetMem(StringTableList, sizeof(TStringTableItem));
            NextNode := StringTableList;
          end;
          NextNode^.Next := nil;
          BlockRead(F, NextNode^.Tag[1], B);
          NextNode^.Tag[0] := Chr(B);
          NextNode^.Id := pred(RN.rnID and $7FFF) * 16 + i;
        end;
      end;

      Seek(f, SavedPos);
    end;
  end;

begin
  with PrinterStrings^ do begin
    {Open file}
    SaveMode := FileMode;
    FileMode := fmOpenRead;
    Assign(F, AddBackSlash(SourceDirectory) + pDriverFileName);
    Reset(F, 1);
    FileMode := SaveMode;
    if IoResult <> 0 then begin
      ErrorFile := AddBackSlash(SourceDirectory) + pDriverFileName;
      ErrorFile := pDriverFileName;                                      {!!.04}
      DrvInstallError := ecDrvDriverNotFound;
      Exit;
    end;                                                             

    {Read in old-style header, done if no new style header}
    BlockRead(F, OH, SizeOf(OH));
    if OH.NewHeaderFlag < $40 then
      Exit;

    {Read in new header, seek to start of Resource Table}
    Seek(F, OH.NewHeaderOfs);
    BlockRead(F, NH, SizeOf(NH));
    Seek(F, OH.NewHeaderOfs+NH.ResTableOfs);

    {Read align shift word}
    BlockRead(F, Align, 2);

    ANode := nil;

    while ReadNextType do begin
      {Exit on errors}
      if IoResult <> 0 then begin
        Close(F);
        if IoResult <> 0 then ;
        Exit;
      end;

      {Handle this resource type}
      if ResType = $8006 then
        ReadStringResource(ANode)
      else
        SkipNextType;
    end;

    {Close up and exit}
    Close(F);
    if IoResult <> 0 then ;
  end;
end;

procedure KillStringTableList (StringTableList : PStringTableItem);
  { Kill the linked list of all string table entries }
var
  NextNode : PStringTableItem;

begin
  while (StringTableList <> nil) do begin
    NextNode := StringTableList^.Next;
    FreeMem(StringTableList, sizeof(TStringTableItem));
    StringTableList := NextNode;
  end;
end;

function GetStringTableItem (StringTableList : PStringTableItem;
                             WhichItem : Word;
                             Default : ShortString) : ShortString;
  { Search the string list for WhichItem }
begin
  GetStringTableItem := Default;

  while (StringTableList <> nil) and
        (StringTableList^.Id <> WhichItem) do
    StringTableList := StringTableList^.Next;

  if (StringTableList <> nil) then
    GetStringTableItem := StringTableList^.Tag;
end;

{---------------------------------------------------------------}
{ Install the printer driver into windows (registry or win.ini) }
{---------------------------------------------------------------}

const
  secPorts        : array[0..5]  of Char = 'Ports';
  secDevices      : array[0..7]  of Char = 'devices';
  secPrinterPorts : array[0..12] of Char = 'PrinterPorts';

function RegisterPrinter : Integer;
  { Register the new printer driver to Windows }
var
  StringTable : PStringTableItem;
  KeyBuf      : PChar;
  ValBuf      : PChar;
  PrntInfo    : PPrinterInfo2;
  DrvrInfo    : PDriverInfo2;
  SizeNeeded  : DWord;
  TempStr     : ShortString;
  H           : THandle;
  DriverDir   : PChar;
  Ports       : Array[0..255] of char;
  BytesRead,
  PortsRead   : DWORD;
begin
  with PrinterStrings^ do begin
    StringTable := nil;
    BuildStringTableList(StringTable);
    EnumPorts(nil,1,@Ports,sizeof(Ports),BytesRead,PortsRead);
    pPortName       := GetStringTableItem(StringTable, idPortName, 'PRINTFAX:');
    pDriverName     := GetStringTableItem(StringTable, idDriverName, '');
    pComment        := GetStringTableItem(StringTable, idComment, '');
    pSepFile        := GetStringTableItem(StringTable, idSepFile, '');
    pServerName     := GetStringTableItem(StringTable, idServerName, '');
    pPrintProcessor := GetStringTableItem(StringTable, idPrintProcessor, 'WinPrint');
    pDataType       := GetStringTableItem(StringTable, idDataType, 'RAW');
    KillStringTableList(StringTable);

    if DrvInstallError <> ecOk then begin
      Result := DrvInstallError;
      exit;
    end;

    { verify required string resources }
    if (pPortName = '') or (pDriverName = '') then begin
      DrvInstallError := ecDrvBadResources;
      RegisterPrinter := ecDrvBadResources;
      exit;
    end;

    KeyBuf := StrAlloc(256);
    ValBuf := StrAlloc(256);

    {add the port}
    StrPCopy(KeyBuf, pPortName);
    StrCopy(ValBuf, #0);
    WriteProfileString(secPorts, KeyBuf, ValBuf);
    WriteProfileString(nil,nil,nil); {flush}
    SendMessage(hwnd_Broadcast, wm_WinIniChange, 0, longint(@secPorts));
    EnumPorts(nil,1,@Ports,sizeof(Ports),BytesRead,PortsRead);

    {$IFDEF Win32}
    DriverDir := StrAlloc(255);
    GetPrinterDriverDirectory(nil, nil, 1, DriverDir, 255, SizeNeeded);
    TempStr := AddBackSlash(StrPas(DriverDir));
    StrDispose(DriverDir);

    GetMem(DrvrInfo, sizeof(TDriverInfo2));
    FillChar(DrvrInfo^, sizeof(TDriverInfo2), 0);
    DrvrInfo^.pName       := StrAlloc(255);
    DrvrInfo^.pDriverPath := StrAlloc(255);
    DrvrInfo^.pDataFile   := DrvrInfo^.pDriverPath;
    DrvrInfo^.pConfigFile := DrvrInfo^.pDriverPath;
    try

      DrvrInfo^.cVersion := $400;
      StrPCopy(DrvrInfo^.pName, pDriverName);
      DrvrInfo^.pEnvironment := 'Windows 4.0';
      StrPCopy(DrvrInfo^.pDriverPath, TempStr + pDriverFileName);

      if not AddPrinterDriver(nil, 2, DrvrInfo) then
        if GetLastError <> 1795 {ERROR_PRINTER_DRIVER_ALREADY_INSTALLED} then
          raise Exception.CreateFmt('Failed to add printer driver. Reason: %d',[GetLastError]);

    finally
      StrDispose(DrvrInfo^.pName);
      StrDispose(DrvrInfo^.pDriverPath);
      FreeMem(DrvrInfo, sizeof(TDriverInfo2));
    end;

    GetMem(PrntInfo, sizeof(TPrinterInfo2));
    FillChar(PrntInfo^, sizeof(TPrinterInfo2), 0);

    PrntInfo^.pServerName     := StrAlloc(255);
    PrntInfo^.pPrinterName    := StrAlloc(255);
    PrntInfo^.pPortName       := StrAlloc(255);
    PrntInfo^.pDriverName     := StrAlloc(255);
    PrntInfo^.pComment        := StrAlloc(255);
    PrntInfo^.pPrintProcessor := StrAlloc(255);
    PrntInfo^.pDataType       := StrAlloc(255);

    StrPCopy(PrntInfo^.pServerName, pServerName);
    StrPCopy(PrntInfo^.pPrinterName, pDriverName);
    StrPCopy(PrntInfo^.pPortName, pPortName);
    StrPCopy(PrntInfo^.pDriverName, pDriverName);
    StrPCopy(PrntInfo^.pComment, pComment);
    StrPCopy(PrntInfo^.pPrintProcessor, pPrintProcessor);
    StrPCopy(PrntInfo^.pDataType, pDataType);

    H := AddPrinter(nil, 2, PrntInfo);
    if H = 0 then
      begin
        if GetLastError <> ERROR_PRINTER_ALREADY_EXISTS then begin
          DrvInstallError := ecCannotAddPrinter;
          raise Exception.CreateFmt('Failed to add printer. Reason: %d (%s)',[GetLastError,ErrorMsg(GetLastError)]);
        end;
      end
    else
      ClosePrinter(H);

    StrDispose(PrntInfo^.pServerName);
    StrDispose(PrntInfo^.pPrinterName);
    StrDispose(PrntInfo^.pPortName);
    StrDispose(PrntInfo^.pDriverName);
    StrDispose(PrntInfo^.pComment);
    StrDispose(PrntInfo^.pPrintProcessor);
    StrDispose(PrntInfo^.pDataType);
    FreeMem(PrntInfo, sizeof(TPrinterInfo2));

    {$ELSE}
    {associate the driver with the port}
    StrPCopy(ValBuf, pDriverFileBase);
    StrCat(ValBuf, ',');
    StrCat(ValBuf, StrPCopy(KeyBuf, pPortName));
    StrPCopy(KeyBuf, pDriverName);
    WriteProfileString(secDevices, KeyBuf, ValBuf);

    {define port/driver parameters}
    StrCat(ValBuf, ',15,45');
    WriteProfileString(secPrinterPorts, KeyBuf, ValBuf);

    {send WinIniChanged messages -- order does seem to be important!}
    SendMessage(hwnd_Broadcast, wm_WinIniChange, 0, longint(@secPrinterPorts));
    SendMessage(hwnd_Broadcast, wm_WinIniChange, 0, longint(@secDevices));
    {$ENDIF}

    StrDispose(KeyBuf);
    StrDispose(ValBuf);
  end;
  Result := ecOk;
end;

{----------------------------------------------------}
{ Check if the printer driver installed successfully }
{----------------------------------------------------}

var
  PrinterIC    : HDC;
  TimesChecked : Byte;
  TimerHandle  : Word;
  zDriverFile  : PChar;
  zPortName    : PChar;

procedure TimerCallback (hwnd : HWND; msg : Word; idTimer : Word;
                         dwTime : Longint); export;
  { Callback used for checking if printer available }
begin
  inc(TimesChecked);
  PrinterIC := CreateIC(zDriverFile, '', zPortName, nil);
end;

function InstalledOk : Boolean;
  { Try to create an IC for the print driver to see if it installed ok }
var
  pdrvHandle : THandle;
  StrBuf1    : array[0..255] of Char;
  StrBuf2    : array[0..255] of Char;

begin
  with PrinterStrings^ do begin
    PrinterIC := 0;
    TimesChecked := 0;
    InstalledOk := False;

    GetSystemDirectory(StrBuf1, 256);
    pdrvHandle := LoadLibrary(StrCat(OoMisc.AddBackSlashZ(StrBuf1, StrBuf1),
                                     StrPCopy(StrBuf2, pDriverFileName)));
    if (pdrvHandle > 32) then begin
      zDriverFile := StrAlloc(255);
      StrPCopy(zDriverFile, pDriverFileBase);
      zPortName := StrAlloc(255);
      StrPCopy(zPortName, pPortName);

      TimerHandle := SetTimer(0, 0, 1000, @TimerCallback);

      repeat
        SafeYield;
      until (TimesChecked > 10) or (PrinterIC <> 0);
      KillTimer(0, TimerHandle);

      InstalledOk := (PrinterIC <> 0);
      if PrinterIC <> 0 then begin
        DeleteDC(PrinterIC);
        DrvInstallError := ecOK;
      end;
      StrDispose(zPortName);
      StrDispose(zDriverFile);
      FreeLibrary(pdrvHandle);
    end;
  end;
end;

{---------------------------------------}
{ Main printer driver installation code }
{---------------------------------------}


function InstallDriver (Filename : ShortString) : Boolean;
  { Attempt to install the print driver.  Return True if successful. }
begin
  InstallDriver := False;

  if not IsWinNT then begin
    with PrinterStrings^ do begin
      Filename := ExpandFilename(Filename);
      pDriverFileName := ExtractFileName(Filename);
      pDriverFileBase := JustName(Filename);
      SourceDirectory := ExtractFilePath(Filename);

      try
        DrvInstallError := InstallUniDrvFiles;
        if (DrvInstallError = ecOk) or
           (DrvInstallError = ecUniAlreadyInstalled) then begin
          DrvInstallError := ecOk;
          CopyDriverToSystemDirectory;
          if (DrvInstallError = ecOk) then begin
            if RegisterPrinter = ecOk then
              InstallDriver := InstalledOk
            else
              InstallDriver := False;
          end;
        end;
        if (@InstallDriverCallback <> nil) then
          InstallDriver := InstallDriverCallback;
      except
        on E:NotFoundException do begin
          ErrorFile := E.Message;
          DrvInstallError := ecDrvDriverNotFound;
        end;
        on E:CantCopyException do begin
          ErrorFile := E.Message;
          DrvInstallError := ecDrvCopyError;
        end;
      end;

    end;
  end;
end;

initialization
  GetMem(PrinterStrings, sizeof(TPrinterStrings));
  FillChar(PrinterStrings^, sizeof(TPrinterStrings), 0);

finalization
  FreeMem(PrinterStrings);
end.

