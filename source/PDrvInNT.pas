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
{*                   PDRVINNT.PAS 4.06                   *}
{*********************************************************}
{* Printer driver installation - NT/2K/XP                *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$X+,I-,T-}
{$H-,J-}

unit PDrvInNT;
  {- Fax printer driver installation unit for NT}

interface

const
  DriverFileName     = 'APFPDENT.DLL';
  Monitor40FileName  = 'APFMON40.DLL';
  Monitor40Name      = 'APFMON40';
  Monitor35FileName  = 'APFMON35.DLL';
  Monitor35Name      = 'APFMON35';
  FilterName         = 'APFAXCNV.DLL';
  Environment        = 'Windows NT x86';
  PortName           = 'PRINTFAX:';
  DriverName         = 'TPS APW Fax Printer';
  ProcessorName      = 'WinPrint';
  PrinterName        = 'APF Fax Printer';

function InstallDriver32(SourcePath : string) : boolean;
  { Attempt to install the print driver.}

implementation

uses
  Windows,
  WinSpool,
  SysUtils,
  Messages,
  OoMisc,
  PDrvInst,
  PDrvUnNT,
  AdExcept;

type
  PPrinterStrings = ^TPrinterStrings;
  TPrinterStrings =
    record
      pPortName       : ShortString;
      pComment        : ShortString;
      pSepFile        : ShortString;
      pServerName     : ShortString;
      pPrintProcessor : ShortString;
      pDataType       : ShortString;
      pDriverFileBase : ShortString;
      SourceDirectory : ShortString;
    end;
var
  PrinterStrings      : PPrinterStrings;


{-------------------------------------------------}
{ Copy the printer driver to the system directory }
{-------------------------------------------------}

procedure CopyDriver(lpszSrcFilename,lpszDestDir : pChar);
  { Copy the fax printer driver to the windows system directory }
var
  lpszDestFilename: PChar;
  lpszSrcDir      : PChar;
  lpszCurDir      : PChar;
  lpszTempFile    : PChar;
  TempFileLen     : DWORD;

begin
  with PrinterStrings^ do begin
    lpszSrcDir := StrAlloc(Max_Path);
    lpszTempFile := StrAlloc(Max_Path);
    try
      lpszDestFilename := lpszSrcFilename;
      StrPCopy(lpszSrcDir, SourceDirectory);
      lpszCurDir := nil;
      TempFileLen := Max_Path;

      DrvInstallExtError := VerInstallFile(0, lpszSrcFilename,
                                           lpszDestFilename,
                                           lpszSrcDir, lpszDestDir,
                                           lpszCurDir,
                                           lpszTempFile, TempFileLen);


      if DrvInstallExtError <> 0 then
        if (DrvInstallExtError AND (VIF_FILEINUSE or VIF_SRCOLD)) = 0 then
          if (DrvInstallExtError and VIF_CANNOTREADSRC) <> 0 then
            raise NotFoundException.Create(StrPas(lpszSrcFilename) + ' not found')
          else
            raise CantCopyException.Create('');

    finally
      StrDispose(lpszTempFile);
      StrDispose(lpszSrcDir);
    end;
  end;
end;

procedure RegisterPrinter;
  { Register the new printer driver to Windows }
var
  KeyBuf      : PChar;
  ValBuf      : PChar;
  PrntInfo    : PPrinterInfo2;
  DrvrInfo    : PDriverInfo2;
  MonitorInfo : PMonitorInfo2;
  DriverDir   : PChar;
  SizeNeeded  : DWord;
  TempStr     : ShortString;
  StrBuf1     : array[0..255] of Char;
  Osi         : TOSVersionInfo;
  H           : THandle;
  MonitorFound: Boolean;
begin
  with PrinterStrings^ do begin
    pPortName       := PortName;
    pComment        := '';
    pSepFile        := '';
    pServerName     := '';
    pPrintProcessor := ProcessorName;
    pDataType       := 'RAW';

    if DrvInstallError <> ecOk then
      exit;

    KeyBuf := StrAlloc(256);
    ValBuf := StrAlloc(256);

    try

      DriverDir := StrAlloc(255);
      try
        GetPrinterDriverDirectory(nil, nil, 1, DriverDir, 255, SizeNeeded);
        TempStr := AddBackSlash(StrPas(DriverDir));

        DrvInstallError := ecOK;
        CopyDriver(DriverFileName,DriverDir);

      finally
        StrDispose(DriverDir);
      end;


      GetMem(DrvrInfo, sizeof(TDriverInfo2));
      try
        FillChar(DrvrInfo^, sizeof(TDriverInfo2), 0);

        DrvrInfo^.pName       := StrAlloc(255);
        DrvrInfo^.pDriverPath := StrAlloc(255);
        DrvrInfo^.pDataFile   := StrAlloc(255);
        DrvrInfo^.pConfigFile := StrAlloc(255);
        DrvrInfo^.pEnvironment := StrAlloc(255);
        try
          DrvrInfo^.cVersion := $1;
          StrPCopy(DrvrInfo^.pName, DriverName);
          StrPCopy(DrvrInfo^.pDatafile, TempStr + DriverFileName);
          DrvrInfo^.pEnvironment := Environment;
          StrPCopy(DrvrInfo^.pDriverPath, TempStr + 'RASDD.DLL');
          StrPCopy(DrvrInfo^.pConfigFile, TempStr + 'RASDDUI.DLL');
          if not AddPrinterDriver(nil, 2, DrvrInfo) then
            if GetLastError <> 1795 {ERROR_PRINTER_DRIVER_ALREADY_INS} then
              raise Exception.CreateFmt('Failed to add printer driver. '   
                + 'Reason: %d (%s)',[GetLastError,ErrorMsg(GetLastError)]);
        finally
          StrDispose(DrvrInfo^.pName);
          StrDispose(DrvrInfo^.pDriverPath);
          StrDispose(DrvrInfo^.pDataFile);
          StrDispose(DrvrInfo^.pConfigFile);
        end;
      finally
        FreeMem(DrvrInfo, sizeof(TDriverInfo2));
      end;

      GetMem(MonitorInfo, sizeof(TMonitorInfo2));
      try
        FillChar(MonitorInfo^, sizeof(TMonitorInfo2), 0);

        MonitorInfo^.pName     := StrAlloc(255);
        MonitorInfo^.pDLLName     := StrAlloc(255);
        try
          GetSystemDirectory(StrBuf1, 256);

          Osi.dwOSVersionInfoSize := sizeof(Osi);
          GetVersionEx(Osi);

          MonitorFound := FileExists(StrPas(StrBuf1)+'\'+FilterName);

          if MonitorFound then
            if (Osi.dwMajorVersion = 3) and (Osi.dwMinorVersion <= 51) then
              MonitorFound := FileExists(StrPas(StrBuf1)+'\'+Monitor35FileName)
            else
              MonitorFound := FileExists(StrPas(StrBuf1)+'\'+Monitor40FileName);

          if (Osi.dwMajorVersion = 3) and (Osi.dwMinorVersion <= 51) then
            begin
              DrvInstallError := ecOK;
              if not MonitorFound then                                 
                CopyDriver(Monitor35FileName,StrBuf1);
              StrPCopy(MonitorInfo^.pName, Monitor35Name);
              StrPCopy(MonitorInfo^.pDLLName, Monitor35FileName);
            end
          else
            begin
              DrvInstallError := ecOK;                                 
              if not MonitorFound then                                 
                CopyDriver(Monitor40FileName,StrBuf1);
              StrPCopy(MonitorInfo^.pName, Monitor40Name);
              StrPCopy(MonitorInfo^.pDLLName, Monitor40FileName);
            end;
          if not MonitorFound then begin
            CopyDriver(FilterName,StrBuf1);
            MonitorInfo^.pEnvironment := Environment;
          end;
          if not AddMonitor(nil,2,MonitorInfo) then
            if GetLastError <> 3006 {ERROR_PRINT_MONITOR_ALREADY_INSTALLED} then
              raise Exception.CreateFmt('Failed to add printer monitor. '  
                + 'Reason: %d (%s)',[GetLastError,ErrorMsg(GetLastError)]);
        finally
          StrDispose(MonitorInfo^.pName);
          StrDispose(MonitorInfo^.pDLLName);
        end;
      finally
        FreeMem(MonitorInfo, sizeof(TMonitorInfo2));
      end;

      GetMem(PrntInfo, sizeof(TPrinterInfo2));
      try
        FillChar(PrntInfo^, sizeof(TPrinterInfo2), 0);

        PrntInfo^.pServerName     := StrAlloc(255);
        PrntInfo^.pPrinterName    := StrAlloc(255);
        PrntInfo^.pPortName       := StrAlloc(255);
        PrntInfo^.pDriverName     := StrAlloc(255);
        PrntInfo^.pComment        := StrAlloc(255);
        PrntInfo^.pPrintProcessor := StrAlloc(255);
        PrntInfo^.pDataType       := StrAlloc(255);
        PrntInfo^.pShareName      := StrAlloc(255);
        try
          StrPCopy(PrntInfo^.pServerName, pServerName);
          PrntInfo^.pServerName := nil;
          StrPCopy(PrntInfo^.pPrinterName, PrinterName);
          StrPCopy(PrntInfo^.pPortName, pPortName);
          StrPCopy(PrntInfo^.pDriverName, DriverName);
          StrPCopy(PrntInfo^.pComment, pComment);
          StrPCopy(PrntInfo^.pPrintProcessor, pPrintProcessor);
          StrPCopy(PrntInfo^.pDataType, pDataType);
          PrntInfo^.pShareName := 'shared printer';
          PrntInfo^.Attributes := PRINTER_ATTRIBUTE_LOCAL;               {!!.04}
          H := AddPrinter(nil, 2, PrntInfo);
          if H = 0 then
            begin
              if GetLastError <> ERROR_PRINTER_ALREADY_EXISTS then begin
                DrvInstallError := ecCannotAddPrinter;
                raise Exception.CreateFmt('Failed to add printer. '
                + 'Reason: %d (%s)',[GetLastError,ErrorMsg(GetLastError)]);
              end;
            end
          else
            ClosePrinter(H);
        finally
          StrDispose(PrntInfo^.pServerName);
          StrDispose(PrntInfo^.pPrinterName);
          StrDispose(PrntInfo^.pPortName);
          StrDispose(PrntInfo^.pDriverName);
          StrDispose(PrntInfo^.pComment);
          StrDispose(PrntInfo^.pPrintProcessor);
          StrDispose(PrntInfo^.pDataType);
        end;
      finally
        FreeMem(PrntInfo, sizeof(TPrinterInfo2));
      end;


    finally
      StrDispose(KeyBuf);
      StrDispose(ValBuf);
    end;
  end;
end;

{----------------------------------------------------}
{ Check if the printer driver installed successfully }
{----------------------------------------------------}

function InstalledOk : Boolean;
  { Try to create an IC for the print driver to see if it installed ok }
var
  PrinterIC    : HDC;
  zDriverFile  : PChar;
  zPortName    : PChar;
  Instance     : THandle;
  DriverDir    : PChar;
  SizeNeeded   : DWord;
  TempStr      : ShortString;
begin
  InstalledOk := False;

  with PrinterStrings^ do begin

    DriverDir := StrAlloc(255);
    try
      GetPrinterDriverDirectory(nil, nil, 1, DriverDir, 255, SizeNeeded);
      TempStr := AddBackSlash(StrPas(DriverDir));

      zDriverFile := StrAlloc(255);
      zPortName := StrAlloc(255);
      try

        StrPCopy(zDriverFile,TempStr+StrPas(DriverFileName));
        Instance := LoadLibrary(zDriverFile);
        if Instance = 0 then
          raise Exception.CreateFmt('Unable to load driver DLL. Reason:%d',[GetLastError]);
        try
          StrPCopy(zDriverFile, pDriverFileBase);
          StrPCopy(zPortName, pPortName);

          PrinterIC := CreateIC('WINSPOOL', PrinterName, zPortName, nil);

          InstalledOk := (PrinterIC <> 0);
          if PrinterIC <> 0 then begin
            DeleteDC(PrinterIC);
            DrvInstallError := ecOK;
          end;
        finally
          FreeLibrary(Instance);
        end;
      finally
        StrDispose(zPortName);
        StrDispose(zDriverFile);
      end;

    finally
      StrDispose(DriverDir);
    end;


  end;
end;

{---------------------------------------}
{ Main printer driver installation code }
{---------------------------------------}

function InstallDriver32(SourcePath : string) : boolean;
  { Attempt to install the print driver.  Return True if successful. }
var
  Filename : ShortString;
begin
  Result := False;

  with PrinterStrings^ do begin
   
    DrvInstallError := ecOk;

    Filename := StrPas(DriverFileName);
    Filename := ExpandFilename(Filename);
    pDriverFileBase := JustName(Filename);
    SourceDirectory := SourcePath;

    try
      DrvInstallError := InstallNTUniDrvFiles;
      if (DrvInstallError = ecOk) or
         (DrvInstallError = ecUniAlreadyInstalled) then begin
        DrvInstallError := ecOk;
        RegisterPrinter;
      end;
    except
      on NotFoundException do begin
        ErrorFile := DriverFileName;                                     {!!.04}
        DrvInstallError := ecDrvDriverNotFound;
      end;
      on CantCopyException do
        DrvInstallError := ecDrvCopyError;
    end;

    if (DrvInstallError = ecOk) then
      Result := InstalledOk;
  end;

end;

initialization
  GetMem(PrinterStrings, sizeof(TPrinterStrings));
  FillChar(PrinterStrings^, sizeof(TPrinterStrings), 0);

finalization
  FreeMem(PrinterStrings);
end.

