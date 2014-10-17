(* ***** BEGIN LICENSE BLOCK *****
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
{*                   APFPDENG.PAS 4.06                   *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AwDefine.Inc}

{$IFDEF Win32}
  !! Compile for 16-bit DLL only !!
{$ENDIF}

{$C MOVEABLE DISCARDABLE DEMANDLOAD}
{$X+,I-,T-,Q-,B-}

unit ApfPdEng;
  {- APF printer mini-driver engine (based on Bitmap sample from Win95 DDK) }

interface

uses  
  WinTypes,
  WinProcs,
  OoMisc;

{-------------------------------------------------------}
{ routines which the custom printer driver must define  }
{-------------------------------------------------------}

type
  TStartJobCallback = function (var uiData : Pointer;
                                JobDescription : PChar;
                                Filename : PChar) : Boolean;
  TEndJobCallback   = function (var uiData : Pointer;
                                JobCompletedNormally : Boolean) : Boolean;

var
  StartJobCallback : TStartJobCallback;
  EndJobCallback   : TEndJobCallback;

  ModuleName       : array[0..13] of Char;

{-------------------------------------------------------}
{ types used in functions exported to UniDrv.DLL        }
{-------------------------------------------------------}

type
  { C SDK/DDK to Pascal type equivilances }
  PPBrush             = Pointer;      { physical brush pointer }
  PPPen               = Pointer;      { physical pen pointer }
  DWord               = LongInt;
  PDWord              = ^DWord;

const
  cchFormName     = 32;
  orientPortrait  = 1;
  orientLandscape = 2;

type
  { as defined/extended in Print.H instead of WinTypes.Pas }
  PDevMode = ^TDevMode;
  TDevMode =  record
    dmDeviceName        : array[0..cchDeviceName-1] of Char;
    dmSpecVersion       : Word;
    dmDriverVersion     : Word;
    dmSize              : Word;
    dmDriverExtra       : Word;
    dmFields            : LongInt;
    dmOrientation       : Integer;
    dmPaperSize         : Integer;
    dmPaperLength       : Integer;
    dmPaperWidth        : Integer;
    dmScale             : Integer;
    dmCopies            : Integer;
    dmDefaultSource     : Integer;
    dmPrintQuality      : Integer;
    dmColor             : Integer;
    dmDuplex            : Integer;
    { additional fields (not defined in WinTypes.Pas / defined in Print.H) }
    dmYResolution       : Integer;
    dmTTOption          : Integer;
    dmCollate           : Integer;
    dmFormName          : array[0..pred(cchFormName)] of Char;
    dmLogPixels         : Word;
    dmBitsPerPel        : DWord;
    dmPelsWidth         : DWord;
    dmPelsHeight        : DWord;
    dmDisplayFlags      : DWord;
    dmDisplayFrequency  : DWord;
    dmICMMethod         : DWord;
    dmICMIntent         : DWord;
    dmMediaType         : DWord;
    dmDitherType        : DWord;
    dmReserved1         : DWord;
    dmReserved2         : DWord;
  end;

  PBitmap = ^TBitmap;
  TBitmap =
    record
      { as defined/extended in GdiDefs.Inc instead of WinTypes.Pas }
      bmType        : Integer;
      bmWidth       : Integer;
      bmHeight      : Integer;
      bmWidthBytes  : Integer;
      bmPlanes      : Byte;
      bmBitsPixel   : Byte;
      bmBits        : Pointer;
      bmWidthPlanes : DWord;    { product of bmWidthBytes and bmHeight }
      bmlpPDevice   : Pointer;  { pointer to next associated PDEVICE }
      bmSegmentIndex: Word;     { index to planes next segment (if <> 0) }
      bmScanSegment : Word;     { number of scans per segment }
      bmFillBytes   : Word;     { number of unused bytes per segment }
      futureUse4    : Word;     { reserved }
      futureUse5    : Word;     { reserved }
    end;

  pScanNode = ^tScanNode;
  tScanNode =
    record
      {used for landscape orientation only}
      ScanLines : array[1..8] of pointer;
      slIndex   : byte;
      NextNode  : pScanNode;
    end;

  PDevExt = ^TDevExt;
  TDevExt =
    record
      { our mini-driver specific extensions, pointed at by lpMD in TDev }
      cvtLastError      : Integer;
      cvtEndPageWritten : Boolean;
      cvtSomeDataWritten: Boolean;
      apfConverter      : PAbsFaxCvt;
      hAppDC            : HDC;
      IsLandscape       : Boolean;
      slDataSize        : Word;
      slBitWidth        : Word;
      FirstScanNode     : pScanNode;
      CurrentScanNode   : pScanNode;                             
      UserInstanceData  : Pointer;  { ptr to user record of instanced data }
    end;

  PDev = ^TDev;
  TDev =
    record
      iType       : Integer; { 0 iff memory bitmap, <> 0 iff our device }
      oBitmapHdr  : Integer; { pdev + oBitmapHdr points to shadow BitmapHdr }

      { unidrv never touches the following 3 words -- they are reserved for
        mini-driver use only and can be used/defined as our minidrv sees fit.}
      hMD         : THandle;
      lpMD        : PDevExt; { pointer to extended driver-specific info }
    end;

  PDrawMode = ^TDrawMode;
  TDrawMode =
    record
      Rop2              : Integer;  { 16-bit logical op }
      bkMode            : Integer;  { background mode (for text only) }
      TextColor         : DWord;    { physical background color }
      TBreakExtra       : Integer;  { total pixels to stuff into a line }
      BreakExtra        : Integer;  { TBreakExtra div BreakCount }
      BreakErr          : Integer;  { running error term }
      BreakRem          : Integer;  { TBreakExtra mod BreakCount }
      BreakCount        : Integer;  { count of breaks in the line }
      CharExtra         : Integer;  { extra pixels to stuff after each char }
      LbkColor          : DWord;    { logical background color }
      LTextColor        : DWord;    { transform for DIC image color matches }
      StretchBltMode    : Integer;  { stretch blt mode }
      eMiterLimit       : DWord;    { miter limit (single prec. IEEE float) }
    end;

  TFnOemDump = function(lpdv : PDev; lppoint : PPoint; word : Word) : Integer;
  TFnOemOutputChar = function(lpdv : PDev; lpstr : PStr; word : Word) : Integer;
  TFnEnumDFonts = function(lplogfont : PLogFont; lptextmetric : PTextMetric;
                           word : Word; lpvoid : Pointer) : Word;

  PCustomData = ^TCustomData;
  TCustomData =
    record
      cbSize          : Integer;            { size of this structure }
      hMD             : THandle;            { handle to mini-driver }
      fnOEMDump       : TFnOemDump;         { nil or pointer to OEMDump() }
      fnOEMOutputChar : TFnOemOutputChar;   { nil or pointer to OEMOutputChar() }
    end;

  PTextXForm = ^TTextXForm;
  TTextXForm =
    record
      ftHeight        : Integer;
      ftWidth         : Integer;
      ftEscapement    : Integer;
      ftOrientation   : Integer;
      ftWeight        : Integer;
      ftItalic        : Byte;
      ftUnderline     : Byte;
      ftStikeOut      : Byte;
      ftOutPrecision  : Byte;
      ftClipPrecision : Byte;
      ftAccelerator   : Word;
      ftOverhang      : Integer;
    end;

  PFontInfo = ^TFontInfo;
  TFontInfo =
    record
      dfType            : Integer;  { type field for the font }
      dfPoints          : Integer;  { point size of font }
      dfVertRes         : Integer;  { vertical digitization }
      dfHorizRes        : Integer;  { horizontal digitization }
      dfAscent          : Integer;  { baseline offset from char cell top }
      dfInternalLeading : Integer;  { internal leading included in font }
      dfExternalLeading : Integer;  { external leading included in font }
      dfItalic          : Byte;     { flag specifying if italic }
      dfUnderline       : Byte;     { flag specifying if underlined }
      dfStrikeOut       : Byte;     { flag specifying if struck out }
      dfWeight          : Integer;  { weight of font }
      dfCharSet         : Byte;     { character set of font }
      dfPixWidth        : Integer;  { width field for the font }
      dfPixHeight       : Integer;  { height field for the font }
      dfPitchAndFamily  : Byte;     { flag specifying variable pitch, family }
      dfAvgWidth        : Integer;  { average character width }
      dfMaxWidth        : Integer;  { maximum character width }
      dfFirstChar       : Byte;     { first character in the font }
      dfLastChar        : Byte;     { last character in the font }
      dfDefaultChar     : Byte;     { default character for out of range }
      dfBreakChar       : Byte;     { character to define wordbreaks }
      dfWidthBytes      : Integer;  { number of bytes in each row }
      dfDevice          : DWord;    { offset to device name }
      dfFace            : DWord;    { offset to face name }
      dfBitsPointer     : DWord;    { bits pointer }
      dfBitsOffset      : DWord;    { offset to the begining of the bitmap }
                                    { (On the disk, this is relative to the }
                                    { begining of the file. In memory this is }
                                    { relative to the begining of this struct) }
      dfReservedByte    : Byte;     { filler byte to WORD-align charoffset }
      dfCharOffset      : Word;     { area for storing the character offsets, }
                                    { facename, device name (opt), and bitmap. }
    end;

    HPropSheetPage = Pointer;
    TFnAddPropSheetPage = function(hpsp : HPropSheetPage; lparam : Longint) : WordBool;

{-------------------------------------------------------}
{ declarations for functions exported to UniDrv.DLL     }
{-------------------------------------------------------}

function  DevBitBlt(lpdv : PDev; DstxOrg : Integer; DstyOrg : Integer;
                    lpSrcDev : PBitmap; SrcxOrg : Integer; SrcyOrg : Integer;
                    xExt : Word; yExt : Word; lRop : Longint;
                    lpPBrush : PPBrush; lpDrawMode : PDrawMode) : WordBool;
                    export; {index 1}
function  ColorInfo(lpdv : PDev; ColorIn : DWord;
                    lpPhysBits : PDWord) : DWord; export; {index 2}
function  Control(lpdv : PDev; func : Word;
                  lpInData, lpOutData : Pointer) : Integer; export; {index 3}
procedure Disable(lpdv : PDev); export; {index 4}
function  Enable(lpdv : PDev; wStyle : Word; lpModel : PStr; lpPort : PStr;
                 lpStuff : PDevMode) : Integer; export; {index 5}
function  EnumDFonts(lpdv : PDev; lpFaceName : PStr;
                     lpCallbackFunc : TFnEnumDFonts;
                     lpClientData : Pointer) : Integer; export; {index 6}
function  EnumObj(lpdv : PDev; wStyle : Word; lpCallbackFunc : TFarProc;
                  lpClientData : Pointer) : Integer; export; {index 7}
function  Output(lpdv : PDev; wStyle : Word; wCount : Word; lpPoints : PPoint;
                 lpPPen : PPPen; lpPBrush : PPBrush; lpDrawMode : PDrawMode;
                 lpCR : PRect) : Integer; export; {index 8}
function  Pixel(lpdv : PDev; X, Y : Integer; Color : DWord;
                lpDrawMode : PDrawMode) : DWord; export; {index 9}
function  RealizeObject(lpdv : PDev; sStyle : Integer; lpInObj : PStr;
                        lpOutObj : PStr; lpTextXForm : PTextXForm) : DWord;
                        export; {index 10}
function  StrBlt(lpdv : PDev; X, Y : Integer; lpCR : PRect; lpStr : PStr;
                 Count : Integer; lpFontInfo : PFontInfo;
                 lpDrawMode : PDrawMode; lpXform : PTextXForm) : DWord;
                 export; {index 11}
function  ScanLR(lpdv : PDev; X, Y : Integer; Color : DWord;
                 DirStyle : Word) : Integer; export; {index 12}
procedure DeviceMode(hwnd : HWND; hInst : THandle; lpDevName : PStr;
                     lpPort : PStr); export; {index 13}
function  DevExtTextOut(lpdv : PDev; X, Y : Integer; lpCR : PRect;
                        lpStr : PStr; Count : Integer; lpFont : PFontInfo;
                        lpDrawMode : PDrawMode; lpXform : PTextXForm;
                        lpWidths : PInteger; lpOpaqRect : PRect;
                        Options : Word) : DWord; export; {index 14}
function  DevGetCharWidth(lpdv : PDev; lpBuf : PInteger; chFirst : Word;
                          chLast : Word; lpFont : PFontInfo;
                          lpDrawMode : PDrawMode;
                          lpXForm : PTextXForm) : Integer;
                          export; {index 15}
function  DeviceBitmap(lpdv : PDev; Command : Word; lpBitmap : PBitmap;
                       lpBits : PStr) : Integer; export; {index 16}
function  FastBorder(lpRect : PRect; Width : Integer; Depth : Integer;
                     lRop : Longint; lpdv : PDev; lpPBrush : PPBrush;
                     lpDrawMode : PDrawMode; lpCR : PRect) : Integer;
                     export; {index 17}
function  SetAttribute(lpdv : PDev; StateNum : Word; Index : Word;
                       Attribute : Word) : Integer; export; {index 18}
function  DIBBlt(lpBmp : PBitmap; wStyle : Word; iStart : Word; sScans : Word;
                 lpDIBits : PStr; lpBMI : PBitmapInfo;
                 lpDrawMode : PDrawMode;
                 lpConvInfo : PStr) : Integer; export; {index 19}
function  CreateDIBitmap : Integer; export; {index 20}
function  SetDIBitsToDevice(lpdv : PDev; DstXOrg, DstYOrg : Word;
                            StartScan, NumScans : Word; lpCR : PRect;
                            lpDrawMode : PDrawMode; lpDIBits : PStr;
                            lpDIBHdr : PBitmapInfoHeader;
                            lpConvInfo : PStr) : Integer; export; {index 21}
function StretchBlt(lpdv : PDev; DstX, DstY : Integer;
                    DstXE, DstYE : Integer; lpBitmaps : PBitmap;
                    SrcX, SrcY : Integer; SrcXE, SrcYE : Integer;
                    dwRop : DWord; lpbr : PPBrush; lpdm : PDrawMode;
                    lpClip : PRect) : Integer; export; {index 27}
function  StretchDIB(lpdv : PDev; wMode : Word; DstX, DstY : Integer;
                     DstXE, DstYE : Integer; SrcX, SrcY : Integer;
                     SrcXE, SrcYE : Integer; lpBits : PStr;
                     lpDIBHdr : PBitmapInfoHeader; lpConvInfo : PStr;
                     dwRop : DWord; lpbr : PPBrush; lpdm : PDrawMode;
                     lpClip : PRect) : Integer; export; {index 28}
function  ExtDeviceMode(hwnd : HWND; hInst : THandle; lpdmOut : PDevMode;
                        lpDevName : PStr; lpPort : PStr; lpdmIn : PDevMode;
                        lpProfile : PStr; wMode : Word) : Integer;
                        export; {index 90}
function  DeviceCapabilities(lpDevName : PStr; lpPort : PStr; wIndex : Word;
                             lpOutput : PStr; lpdm : PDevMode) : DWord;
                             export; {index 91}
function  AdvancedSetupDialog(hwnd : HWND; hInstMiniDrv : THandle;
                              lpdmIn : PDevMode; lpdmOut : PDevMode) : Longint;
                              export; {index 93}
function  DevInstall(hwnd : HWND; lpDevName : PStr; lpOldPort : PStr;
                     lpNewPort : PStr) : Integer; export; {index 94}
function  ExtDeviceModePropSheet(hwnd : HWND; hInst : THandle;
                                 lpDevName : PStr; lpPort : PStr;
                                 dwReserved : DWord;
                                 lpfnAdd : TFnAddPropSheetPage;
                                 lParam : Longint) : Integer;
                                 export; {index 95}
function  fnDump(lpdv : PDev; lpptCursor : PPoint;
                 fMode : WORD) : Integer; export; {index 100}

{-------------------------------------------------------}

implementation

uses
  AwFaxCvt;

{$R ApfPDEng.Res}   { Printer driver engine resources }

const
  { GDI escapes not defined in WinTypes.Pas }
  SetPrinterDC  = 9;
  ResetDevice   = 128;

type
  OS =
    record
      O, S : Word;    { for Seg/Ofs typecasting }
    end;

{$I PDDEBUG.INC}      {include printer driver diagnostics if enabled} 

{----------------------------------}
{ implicit imports from UniDrv.DLL }
{----------------------------------}

function  UniBitBlt(lpdv : PDev; sDestXOrg, sDestYOrg : Integer;
                    lpSrcDev : PBitmap; sSrcXOrg, sSrcYOrg : Integer;
                    sXExt, sYExt : Word; lRop3 : Longint;
                    lpPBrush : PPBrush; DrawMode : PDrawMode) : WordBool; far;
                    external 'UNIDRV' index 1;
function  UniColorInfo(lpdv : PDev; dwColorIn : DWord;
                       lpPColor : PDWord) : DWord; far;
                       external 'UNIDRV' index 2;
function  UniControl(lpdv : PDev; func : Word;
                     lpInData, lpOutData : pointer) : Integer; far;
                     external 'UNIDRV' index 3;
procedure UniDisable(lpdv : PDev); far;
                    external 'UNIDRV' index 4;
function  UniEnable(lpdv : PDev; wStyle : Word; lpDestDevType : PStr;
                    lpOutputFile : PStr; lpData : PDevMode;
                    lpCd : PCustomData) : Integer; far;
                    external 'UNIDRV' index 5;
function  UniEnumDFonts(lpdv : PDev; lpFaceName : PStr;
                        lpfnCallback : TFnEnumDFonts;
                        lpClientData : Pointer) : Integer; far;
                        external 'UNIDRV' index 6;
function  UniEnumObj(lpdv : PDev; wStyle : Word;
                     lpfnCallback : TFarProc;
                     lpClientData : Pointer) : Integer; far;
                     external 'UNIDRV' index 7;
function  UniOutput(lpdv : PDev; wStyle : Word; wCount : Word;
                    lppoints : PPoint; lpPPen : PPPen;
                    lpPBrush : PPBrush; lpDrawMode : PDrawMode;
                    lpClipRect : PRect) : Integer; far;
                    external 'UNIDRV' index 8;
function  UniPixel(lpdv : PDev; wX, wY : Integer; dwPhysColor : DWord;
                   lpDrawMode : PDrawMode) : Integer; far;
                   external 'UNIDRV' index 9;
function  UniRealizeObject(lpdv : PDev;  iStyle : Integer;
                           lpInObj : PStr; lpOutObj : PStr;
                           lpTextXForm : PTextXForm) : Integer; far;
                           external 'UNIDRV' index 10;
function  UniDeviceMode(hWnd : HWND; hInstance : THandle;
                        lpDestDevType : PStr;
                        lpOutputFile : PStr) : Integer; far;
                        external 'UNIDRV' index 13;
function  UniExtTextOut(lpdv : PDev; wDestXOrg, wDestYOrg : Integer;
                        lpClipRect : PRect; lpString : PStr;
                        nCount : Integer; lpFontInfo : PFontInfo;
                        lpDrawMode : PDrawMode; lpTextXForm : PTextXForm;
                        lpCharWidths : PInteger; lpOpaqueRect : PRect;
                        wOptions : Word) : DWord; far;
                        external 'UNIDRV' index 14;
function  UniGetCharWidth(lpdv : PDev; lpBuffer : PInteger;
                          wFirstChar : Word; wLastChar : Word;
                          lpFontInfo : PFontInfo; lpDrawMode : PDrawMode;
                          lpFontTrans : PTextXForm) : Integer; far;
                          external 'UNIDRV' index 15;
function  UniDIBBlt(lpbmp : PBitmap; style : Word; iStart : Word;
                    sScans : Word; lpDIBits : PStr; lpBMI : PBitmapInfo;
                    lpDrawMode : PDrawMode; lpConvInfo : PStr) : Integer; far;
                    external 'UNIDRV' index 19;
function  UniSetDIBitsToDevice(lpdv : PDev; wDestXOrg, wDestYOrg : Word;
                               StartScan : Word; NumScans : Word;
                               lpCR : PRect; lpDrawMode : PDrawMode;
                               lpDIBits : PStr; lpDIBHdr : PBitmapInfoHeader;
                               lpConvInfo : PStr) : Integer; far;
                               external 'UNIDRV' index 21;
function  UniStretchDIB(lpdv : PDev; wMode : Word; DstX, DstY : Integer;
                        DstXE, DstYE : Integer; SrcX, SrcY : Integer;
                        SrcXE, SrcYE : Integer; lpBits : PStr;
                        lpDIBHdr : PBitmapInfoHeader; lpConvInfo : PStr;
                        dwRop : DWord; lpbr : PPBrush; lpdm : PDrawMode;
                        lpClip : PRect) : Integer; far;
                        external 'UNIDRV' index 28;
function  UniDeviceSelectBitmap(lpdv : PDev; lpPrevBmp : PBitmap;
                                lpBmp : PBitmap; dwFlags : DWord) : WordBool; far;
                                external 'UNIDRV' index 29;
function  UniBitmapBits(lpdv : PDev; fFlags : DWord; dwCount : DWord;
                        lpBits : PStr) : WordBool; far;
                        external 'UNIDRV' index 30;
function  UniExtDeviceMode(hwnd : HWND; hInst : THandle; lpdmOut : PDevMode;
                           lpDevName : PStr; lpPort : PStr; lpdmIn : PDevMode;
                           lpProfile : PStr; wMode : Word) : Integer; far;
                           external 'UNIDRV' index 90;
function  UniDeviceCapabilities(lpDevName : PStr; lpPort : PStr;
                                wIndex : Word; lpOutput : PStr; lpdm : PDevMode;
                                hInstMiniDrv : THandle) : DWord; far;
                                external 'UNIDRV' index 91;
function  UniAdvancedSetupDialog(hwnd : HWND; hInstMiniDrv : THandle;
                                 lpdmIn, lpdmOut : PDevMode) : Longint; far;
                                 external 'UNIDRV' index 93;
function  UniDevInstall(hwnd : HWND; lpDevName : PStr; lpOldPort : PStr;
                        lpNewPort : PStr) : Integer; far;
                        external 'UNIDRV' index 94;
function  UniExtDeviceModePropSheet(hWnd : HWND; hInst : THandle;
                                    lpDevName : PStr; lpPort : PStr;
                                    dwReserved : DWord;
                                    lpfnAdd : TFnAddPropSheetPage;
                                    lParam : Longint) : Integer; far;
                                    external 'UNIDRV' index 95;


{-------------------------------------------------------------------}
{ the following are declarations for procedures defined later       }
{-------------------------------------------------------------------}

procedure ProcessLandscapeRasterLines (lpdv : PDev);  forward;
function  CreateNewNode  (lpdv : PDev) : pointer;     forward;
procedure FreeScanNodes  (lpdv : PDev);               forward; 

{-------------------------------------------------------------------}
{ the following are the core routines in the apf fax printer driver }
{-------------------------------------------------------------------}

function Control(lpdv : PDev; func : Word;
                 lpInData, lpOutData : Pointer) : Integer;
var
  lpXPDV        : PDevExt;
  Success       : Boolean;
  sRet          : Integer;
  i             : Integer;
  di            : TDocInfo;
  SaveDataLine  : PByteArray;
  SaveTempBuf   : PByteArray;                                    

begin
  { get pointer to our private data from MiniDrv data area in PDEVICE struct }
  lpXPDV := lpdv^.lpMD;

  {$IFDEF LogControls}
  LogControl(lpdv, func, lpInData, lpOutData);
  {$ENDIF}

  case func of
    SETPRINTERDC :
      begin
        { save app's DC for QueryAbort() calls }
        if (lpXPDV <> nil) then
          lpXPDV^.hAppDC := THandle(lpInData^);
      end;

    WinTypes.STARTDOC :
      begin
        with lpXPDV^ do begin
          { see if the TApdFaxConverter is doing an idShell conversion }
          apfConverter^.StatusWnd := GetPrivateProfileInt(ApdIniSection, {!!.01}
            'ShellHandle', -1, ApdIniFileName);                          {!!.01}
          if apfConverter^.StatusWnd <> -1 then                          {!!.01}
            PostMessage(apfConverter^.StatusWnd, apw_BeginDoc, 0, 0);    {!!.01}
          if (@StartJobCallback = nil) or
            not StartJobCallback(UserInstanceData,
                                 lpInData,
                                 apfConverter^.OutFilename) then begin
            Control := SP_ERROR;
            exit;
          end;

          { open the output file }
          cvtLastError := acCreateOutputFile(apfConverter);
          if cvtLastError <> ecOk then begin
            Control := SP_ERROR;
            exit;
          end;
          inc(apfConverter^.CurrPage);

          { pass nil file to OpenJob }
          di.cbSize := sizeof(TDocInfo);
          di.lpszDocName := nil;
          di.lpszOutput := 'nul';

          { call UniDrv.DLL's Control() passing DocInfo as lpOutData }
          sRet := UniControl(lpdv, func, lpInData, @di);

          Control := sRet;
          exit;
        end;
      end;

    RESETDEVICE :
      begin
        if (lpInData = nil) then
          exit;

        { copy data from old lpdv to new }
        with PDev(lpInData)^.lpMD^ do begin
          { we don't want to use the "Move" command to copy the entire
            structure since a new converter was allocated in the Enable
            before the ResetDevice call. }
          lpXPDV^.cvtLastError        := cvtLastError;
          lpXPDV^.cvtEndPageWritten   := cvtEndPageWritten;
          lpXPDV^.cvtSomeDataWritten  := cvtSomeDataWritten;
          lpXPDV^.hAppDC              := hAppDC;
          lpXPDV^.UserInstanceData    := UserInstanceData;
          SaveDataLine                := lpXPDV^.apfConverter^.DataLine;
          SaveTempBuf                 := lpXPDV^.apfConverter^.TmpBuffer;
          Move(apfConverter^, lpXPDV^.apfConverter^, sizeof(apfConverter^));
          lpXPDV^.apfConverter^.DataLine  := SaveDataLine;
          lpXPDV^.apfConverter^.TmpBuffer := SaveTempBuf;
        end;
      end;

    NEXTBAND :
      begin
        { protect against getting end-page band after an AbortDoc }
        if not assigned(lpXPDV^.UserInstanceData) then
          { we're done as far as we are concerned }
          exit;
        {
          Call UniDrv.DLL's NextBand function.  It will either call our
          fnDump callback to process the data in the band or it will
          return an empty rectangle to us to indicate an empty band (end
          of page).
        }
        sRet := UniControl(lpdv, func, lpInData, lpOutData);

        if lpXPDV^.cvtEndPageWritten then
          lpXPDV^.cvtEndPageWritten := False;

        { check for end of page or error }
        if sRet <= 0 then begin
          { problem converting the file.  force an AbortDoc }
          lpXPDV^.cvtLastError := ecFaxGDIPrintError;
          i := Control(lpdv, WinTypes.ABORTDOC, nil, nil);
        end else if IsRectEmpty(PRect(lpOutData)^) then begin
          { end of page indicated }
          with lpXPDV^ do begin
            if apfConverter^.StatusWnd <> -1 then                        {!!.01}
              PostMessage(apfConverter^.StatusWnd, apw_EndPage, 0, 0);   {!!.01}
          end;
          with lpXPDV^, apfConverter^ do begin
            if IsLandscape then
              { rotate data and send to converter }
              ProcessLandscapeRasterLines(lpdv);                  

            { write end of page (both portrait and landscape) }
            cvtLastError := acOutToFileCallback(apfConverter, DataLine^, 0,
                                                True, True);
            cvtEndPageWritten := True;
            inc(apfConverter^.CurrPage);
          end;
        end;

        Control := sRet;
        exit;
      end;

    WinTypes.ENDDOC,
    WinTypes.ABORTDOC :
      begin
        if lpXPDV^.UserInstanceData = nil then
          { we're done as far as we are concerned }
        exit;

        with lpXPDV^ do begin
          Success := (cvtLastError = ecOk) and (func = WinTypes.ENDDOC);

          if (apfConverter <> nil) then begin
            if Success then begin
              if (not cvtEndPageWritten) and (cvtSomeDataWritten) then begin
                if IsLandscape then
                  {rotate data and send to converter}
                  ProcessLandscapeRasterLines(lpdv);

                with apfConverter^ do
                  {Tell converter it's the end of document}
                  cvtLastError := acOutToFileCallback(apfConverter,
                                                      DataLine^, 0,
                                                      True, False);
                cvtEndPageWritten := True;
              end;
            end else if IsLandscape then
              {didn't succeed -- need to free image in memory}
              FreeScanNodes(lpdv);

            cvtLastError := acCloseOutputFile(apfConverter);
          end;

          try
           if (@EndJobCallback <> nil) then
             if not EndJobCallback(UserInstanceData, Success) then begin
               Control := SP_ERROR;
               exit;
             end;
          finally
            if apfConverter^.StatusWnd <> -1 then                        {!!.01}
              PostMessage(apfConverter^.StatusWnd, apw_EndDoc, 0, 0);    {!!.01}
          end;
        end;
      end;
  end;

  { call UniDrv's Control }
  Control := UniControl(lpdv, func, lpInData, lpOutData);
end;

procedure Disable(lpdv : PDev);
var
  lpXPDV : PDevExt;

begin
  {$IFDEF LogControls}
  LogControl(lpdv, $FFFE, nil, nil);
  {$ENDIF}

  { if allocated private PDEVICE data... }
  if (lpdv^.hMD <> 0) then begin
    { get pointer to our private data stored in UniDrv's PDEVICE }
    lpXPDV := lpdv^.lpMD;

    { free private PDEVICE buffer }
    FreeScanNodes(lpdv);                                          
    if lpXPDV^.apfConverter <> nil then
      acDoneFaxConverter(lpXPDV^.apfConverter);
    GlobalUnlock(lpdv^.hMD);
    GlobalFree(lpdv^.hMD);
  end;

  UniDisable(lpdv);
end;

function Enable(lpdv : PDev; wStyle : Word; lpModel : PStr; lpPort : PStr;
                lpStuff : PDevMode) : Integer;
var
  sRet    : Integer;
  IsHiRes : WordBool;
  h       : THandle;
  cd      : TCustomData;

begin
  {$IFDEF LogControls}
  LogControl(lpdv, $FFFF, @wStyle, nil);
  {$ENDIF}

  cd.cbSize := sizeof(TCustomData);
  cd.hMd := GetModuleHandle(ModuleName);

  { output raster graphics in portrait and landscape orientations }
  cd.fnOEMDump := fnDump;
  cd.fnOEMOutputChar := nil;

  sRet := UniEnable(lpdv, wStyle, lpModel, lpPort, lpStuff, @cd);
  if (sRet = 0) then begin
    Enable := sRet;
    exit;
  end;

  { allocate private PDEVICE }
  if ((wStyle and 1) = 0) then begin
    { "0" means we've been asked to initialize our data }
    lpdv^.hMD := GlobalAlloc(gHnd, sizeof(TDevExt));
    if (lpdv^.hMD = 0) then begin
      Enable := 0;
      exit;
    end;

    lpdv^.lpMD := GlobalLock(lpdv^.hMD);
    FillChar(lpdv^.lpMD^, sizeof(TDevExt), 0);
    with lpdv^.lpMD^ do begin
      acInitFaxConverter(apfConverter, nil, nil, nil, nil, '');

      { force margins off since GDI should handle margins for us }
      with apfConverter^ do begin
        LeftMargin := 0;
        TopMargin := 0;
      end;

      IsHiRes := True;      { default to true }
      IsLandscape := False; { default to false }
      if Assigned(lpStuff) then begin
        IsHiRes := lpStuff^.dmYResolution = 196;
        IsLandscape := lpStuff^.dmOrientation = orientLandscape;
      end;
      acSetResolutionMode(apfConverter, IsHiRes);

      {$IFDEF LogControls}
      LogControl(lpdv, nclogSetCvtRes, @IsHiRes, nil);
      LogControl(lpdv, nclogOrientation, @IsLandscape, nil);
      {$ENDIF}
    end;
  end;

  Enable := sRet;
end;

function fnDump(lpdv : PDev; lpptCursor : PPoint; fMode : WORD) : Integer;
  {
    Gets filled in band block from GDI and convert it a raster line at a
    time to apf format.
  }
var
  iScan             : Word;
  i                 : Word;
  WidthBytes        : Word;
  BandHeight        : Word;
  wScanlinesPerSeg  : Word;
  wSegmentInc       : Word;
  lpbmHdr           : PBitmap;
  lpSrc             : PByte;
  lpScanLine        : PByte;
  lpXPDV            : PDevExt;
  wRemainingScans   : Word;
  TmpBufLen         : Word;
  slDest            : PByteArray;

begin
  {$IFDEF LogControls}
  LogControl(lpdv, nclogCBFnDump, @fMode, nil);
  {$ENDIF}

  { get pointer to our private data from MiniDrv data area in PDEVICE struct }
  lpXPDV := lpdv^.lpMD;

  with lpXPDV^, apfConverter^ do begin
    { get pointer to source PBITMAP }
    lpbmHdr := PBitmap(PStr(lpdv) + lpdv^.oBitmapHdr);

    { initialize some things }
    lpSrc := lpbmHdr^.bmBits;
    WidthBytes := lpbmHdr^.bmWidthBytes;
    BandHeight := lpbmHdr^.bmHeight;
    wScanlinesPerSeg := lpbmHdr^.bmScanSegment;
    wSegmentInc := lpbmHdr^.bmSegmentIndex;
    slDataSize := WidthBytes;
    slBitWidth := lpbmHdr^.bmWidth;                             
    {$IFDEF LogControls}
    LogControl(lpdv, nclogBandSize, @lpbmHdr^.bmWidth, @lpbmHdr^.bmHeight);
    {$ENDIF}

    acInitDataLine(apfConverter);
    FillChar(TmpBuffer^, MaxData, 0);
    iScan := 0;
    while ((iScan < BandHeight) and
           QueryAbort(lpXPDV^.hAppDC,0)) do begin
      { get the next 64k segment of scans }
      if (iScan <> 0) then begin
        wRemainingScans := BandHeight - iScan;

        { cross the segment boundary }
        inc(OS(lpSrc).S, wSegmentInc);

        if (wScanlinesPerSeg > wRemainingScans) then
          wScanlinesPerSeg := wRemainingScans;
      end;

      { loop through scan lines in 64k segment }
      i := iScan;
      lpScanLine := lpSrc;
      if IsLandscape then begin
        {landscape - build entire image into memory; rotate later}
        while ((i < iScan + wScanlinesPerSeg) and
               QueryAbort(lpXPDV^.hAppDC,0)) do begin
          slDest := CreateNewNode(lpdv);
          move(lpScanLine^, slDest^[0], slDataSize);
          inc(OS(lpScanLine).O, WidthBytes);
          inc(i);
        end;
      end else begin
        {portrait - send scan lines directly to fax converter}
        while ((i < iScan + wScanlinesPerSeg) and
               QueryAbort(lpXPDV^.hAppDC,0)) do begin
          TmpBufLen := MinWord(216, WidthBytes);    {1728 div 8 -> 216}
          Move(lpScanLine^, TmpBuffer^, TmpBufLen);
          NotBuffer(TmpBuffer^, TmpBufLen);
          acCompressRasterLine(apfConverter, TmpBuffer^);
          FillChar(TmpBuffer^, MaxData, 0);
          cvtLastError := acOutToFileCallBack(apfConverter, DataLine^,
                                              ByteOfs, False, True);
          inc(OS(lpScanLine).O, WidthBytes);
          inc(i);
        end;
      end;                                                       

      inc(iScan,wScanlinesPerSeg);
    end;

    cvtSomeDataWritten := True;
  end;
  fnDump := 1;
end;

{-------------------------------------------------------------------}
{ the following are "helper" routines for landscape mode printing   }
{-------------------------------------------------------------------}

function CreateNewNode (lpdv : PDev) : pointer;
  { allocate a scan node (if necessary) and return pointer to scan data location }
var
  NewNode : pScanNode;
  lpXPDV  : PDevExt;

begin
  { get pointer to our private data from MiniDrv data area in PDEVICE struct }
  lpXPDV := lpdv^.lpMD;

  with lpXPDV^ do begin
    if (CurrentScanNode = nil) or
       (CurrentScanNode^.slIndex = 8) then begin
      {just starting or block of eight in current node full...}
      {...so allocate another node to hold up to eight more raster lines}
      GetMem(NewNode, sizeof(tScanNode));
      FillChar(NewNode^, sizeof(tScanNode), 0);
      if FirstScanNode = nil then begin
        FirstScanNode := NewNode;
        CurrentScanNode := NewNode;
        {$IFDEF LogControls}
        LogControl(lpdv, nclogLndscpAlloc, FirstScanNode, nil);
        {$ENDIF}
      end else begin
        CurrentScanNode^.NextNode := NewNode;
        CurrentScanNode := NewNode;
      end;
    end;

    {allocate space for one of eight raster lines in the node}
    with CurrentScanNode^ do begin
      inc(slIndex);
      GetMem(ScanLines[slIndex], slDataSize);
      CreateNewNode := ScanLines[slIndex];
    end;
  end;
end;

procedure FreeScanNodes (lpdv : PDev);
  { free the linked list of scan nodes }
var
  NodeToDel : pScanNode;
  lpXPDV    : PDevExt;

begin
  { get pointer to our private data from MiniDrv data area in PDEVICE struct }
  lpXPDV := lpdv^.lpMD;

  { free linked list of scan lines }
  with lpXPDV^ do begin
    CurrentScanNode := FirstScanNode;

    {$IFDEF LogControls}
    if FirstScanNode <> nil then
      LogControl(lpdv, nclogLndscpFree, FirstScanNode, nil);
    {$ENDIF}

    while CurrentScanNode <> nil do begin
      NodeToDel := CurrentScanNode;
      CurrentScanNode := CurrentScanNode^.NextNode;

      { free the scan line data }
      with NodeToDel^ do
        while (slIndex > 0) and (ScanLines[slIndex] <> nil) do begin
          FreeMem(ScanLines[slIndex], slDataSize);
          dec(slIndex);
        end;

      { free the linked list node }
      FreeMem(NodeToDel, sizeof(tScanNode));
    end;

    FirstScanNode := nil;
    CurrentScanNode := nil;
  end;
end;

procedure ProcessLandscapeRasterLines (lpdv : PDev);
  { translated data to portrait raster lines, then send it to converter. }
type
  TOctet        = array[0..7] of Byte;

  TRotatedLine  = array[0..220{pred(1728 div 8)}] of byte;

  PRotatedSet   = ^TRotatedSet;
  TRotatedSet   = array[0..7] of TRotatedLine;

  PTranslation  = ^TTranslation;
  TTranslation  = array[0..7, 0..1] of Byte;

const
  TransTable    : TTranslation = ((0, $80), (0, $40), (0, $20), (0, $10),
                                  (0, $08), (0, $04), (0, $02), (0, $01));

var
  lpXPDV          : PDevExt;

  LandscapeOctet  : TOctet;         { octet of bytes provided by GDI }
  PortraitOctet   : TOctet;         { octet of bytes after translation }
  PortraitSet     : PRotatedSet;    { eight rotated scan lines we're building }
  LScanLineOfs    : Word;           { byte offset of octet in landscape data }
  PScanLineOfs    : Word;           { byte offset of octet in portrait data }
  FirstOctet      : Boolean;        { first octect could contain padding lines }
  i               : Byte;
  j               : Byte;

begin
  { get pointer to our private data from MiniDrv data area in PDEVICE struct }
  lpXPDV := lpdv^.lpMD;

  {$IFDEF LogControls}
  LogControl(lpdv, nclogLndscpRotate, nil, nil);
  {$ENDIF}

  { allocate space for a set of eight complete scan lines }
  GetMem(PortraitSet, sizeof(TRotatedSet));

  with lpXPDV^ do begin
    LScanLineOfs := (slBitWidth div 8) + 1;   { skip over padding bytes }
    FirstOctet := True;
    while LScanLineOfs > 0 do begin
      CurrentScanNode := FirstScanNode;
      PScanLineOfs := 0;
      fillchar(PortraitSet^, sizeof(TRotatedSet), 0);
      while CurrentScanNode <> nil do begin
        { copy byte at ScanLineOfs for each scan line to landscape octet }
        fillchar(LandscapeOctet, sizeof(TOctet), 0);
        with CurrentScanNode^ do
          for i := 1 to slIndex do
            LandscapeOctet[pred(i)] := PByteArray(ScanLines[i])^[LScanLineOfs];

        { zero out the portrait octet }
        fillchar(PortraitOctet,  sizeof(TOctet), 0);

        { perform the translation }
        for i := 0 to 7 do
          for j := 0 to 7 do begin
            inc(PortraitOctet[i], TransTable[j, LandscapeOctet[j] and $1]);
            LandscapeOctet[j] := LandscapeOctet[j] shr 1;
          end;

        { translation complete -- move portrait octet to set of scan lines }
        for i := 0 to 7 do
          PortraitSet^[i][PScanLineOfs] := PortraitOctet[i];

        { increment byte offset into new portrait scan lines }
        inc(PScanLineOfs);

        { get another octet of data from the next node }
        CurrentScanNode := CurrentScanNode^.NextNode;
      end;

      { we've completely processed the LScanLineOfs byte from each scan line }
      { and generated eight new scan lines in portrait mode, so send them to }
      { the converter.  the new width is 216 bytes (1728 div 8) }
      with apfConverter^ do
(*
        if FirstOctet then begin
          FirstOctet := False;
          for i := pred(slBitWidth mod 8) to 7 do begin
            Move(PortraitSet^[i], TmpBuffer^, 216);
            NotBuffer(TmpBuffer^, 216);
            acCompressRasterLine(apfConverter, TmpBuffer^);
            FillChar(TmpBuffer^, MaxData, 0);
            cvtLastError := acOutToFileCallBack(apfConverter, DataLine^,
                                                ByteOfs, False, True);
          end;
        end else begin
*)
          for i := 0 to 7 do begin
            Move(PortraitSet^[i], TmpBuffer^, 216);
            NotBuffer(TmpBuffer^, 216);
            acCompressRasterLine(apfConverter, TmpBuffer^);
            FillChar(TmpBuffer^, MaxData, 0);
            cvtLastError := acOutToFileCallBack(apfConverter, DataLine^,
                                                ByteOfs, False, True);
          end;
(*
        end;
*)

      { decrement byte offset into landscape scan lines }
      dec(LScanLineOfs);
    end;

    FreeScanNodes(lpdv);
  end;

  { free allocated memory }
  FreeMem(PortraitSet, sizeof(TRotatedSet));
end;

{---------------------------------------------------------------}
{ the following are simply pass-through functions to UniDrv.DLL }
{---------------------------------------------------------------}

function AdvancedSetupDialog(hwnd : HWND;
                             hInstMiniDrv : THandle;        { handle of driver module }
                             lpdmIn : PDevMode;             { initial device settings }
                             lpdmOut : PDevMode) : Longint; { final device settings }
begin
  AdvancedSetupDialog := UniAdvancedSetupDialog(hwnd, hInstMiniDrv, lpdmIn, lpdmOut);
end;

function BitmapBits(lpdv : PDev; fFlags : DWord; dwCount : DWord;
                    lpBits : PStr) : WordBool;
begin
  {$IFDEF LogControls}
  LogControl(lpdv, nclogBitmapBits, nil, nil);
  {$ENDIF}
  BitmapBits := UniBitmapBits(lpdv, fFlags, dwCount, lpBits);
end;

function ColorInfo(lpdv : PDev; ColorIn : DWord;
                   lpPhysBits : PDWord) : DWord;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogColorInfo, nil, nil);
  {$ENDIF}
  ColorInfo := UniColorInfo(lpdv, ColorIn, lpPhysBits);
end;

function CreateDIBitmap : Integer;
begin
  {
    CreateDIBitmap is never called by GDI.
    Keep a stub function here so nobody complains.
  }
  CreateDIBitmap := 0;
end;

function DevBitBlt(lpdv : PDev;             { ptr to dest bitmap descriptor }
                   DstxOrg : Integer;       { destination origin x }
                   DstyOrg : Integer;       { destination origin y }
                   lpSrcDev : PBitmap;      { ptr to source bitmap descriptor }
                   SrcxOrg : Integer;       { source origin x }
                   SrcyOrg : Integer;       { source origin y }
                   xExt : Word;             { x extent of blt }
                   yExt : Word;             { y extent of blt }
                   lRop : Longint;          { raster operation descriptor }
                   lpPBrush : PPBrush;      { ptr to a physical brush (pattern) }
                   lpDrawMode : PDrawMode) : WordBool;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogDevBitBlt, nil, nil);
  {$ENDIF}
  DevBitBlt := UniBitBlt(lpdv, DstxOrg, DstyOrg, lpSrcDev, SrcxOrg, SrcyOrg,
                         xExt, yExt, lRop, lpPBrush, lpDrawMode);
end;

function DevExtTextOut(lpdv : PDev; X, Y : Integer; lpCR : PRect;
                       lpStr : PStr; Count : Integer; lpFont : PFontInfo;
                       lpDrawMode : PDrawMode; lpXform : PTextXForm;
                       lpWidths : PInteger; lpOpaqRect : PRect;
                       Options : Word) : DWord;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogDevExtTxtOut, nil, nil);
  {$ENDIF}
  DevExtTextOut := UniExtTextOut(lpdv, X, Y, lpCR, lpStr, Count,
                                 lpFont, lpDrawMode, lpXform, lpWidths,
                                 lpOpaqRect, Options);
end;

function DevGetCharWidth(lpdv : PDev; lpBuf : PInteger; chFirst : Word;
                         chLast : Word; lpFont : PFontInfo;
                         lpDrawMode : PDrawMode;
                         lpXForm : PTextXForm) : Integer;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogDevGetCharW, nil, nil);
  {$ENDIF}
  DevGetCharWidth := UniGetCharWidth(lpdv, lpBuf, chFirst, chLast,
                                     lpFont, lpDrawMode, lpXForm);
end;

function DeviceBitmap(lpdv : PDev; Command : Word; lpBitmap : PBitmap;
                      lpBits : PStr) : Integer;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogDeviceBitmap, nil, nil);
  {$ENDIF}
  DeviceBitmap := 0;
end;

function DeviceCapabilities(lpDevName : PStr; lpPort : PStr; wIndex : Word;
                            lpOutput : PStr; lpdm : PDevMode) : DWord;
begin
  DeviceCapabilities := UniDeviceCapabilities(lpDevName, lpPort, wIndex,
                                              lpOutput, lpdm,
                                              GetModuleHandle(ModuleName));
end;

procedure DeviceMode(hwnd : HWND; hInst : THandle; lpDevName : PStr;
                     lpPort : PStr);
begin
  UniDeviceMode(hwnd, hInst, lpDevName, lpPort);
end;

function DeviceSelectBitmap(lpdv : PDev; lpPrevBmp : PBitmap;
                            lpBmp : PBitmap; fFlags : DWord) :WordBool; export;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogDevSelectBM, nil, nil);
  {$ENDIF}
  DeviceSelectBitmap := UniDeviceSelectBitmap(lpdv, lpPrevBmp, lpBmp, fFlags);
end;

function DevInstall(hwnd : HWND; lpDevName : PStr; lpOldPort : PStr;
                    lpNewPort : PStr) : Integer;
begin
  DevInstall := UniDevInstall(hwnd, lpDevName, lpOldPort, lpNewPort);
end;

function DIBBlt(lpBmp : PBitmap; wStyle : Word; iStart : Word; sScans : Word;
                lpDIBits : PStr; lpBMI : PBitmapInfo;
                lpDrawMode : PDrawMode;
                lpConvInfo : PStr) : Integer;
begin
  DIBBlt := UniDIBBlt(lpBmp, wStyle, iStart, sScans, lpDIBits, lpBMI,
                      lpDrawMode, lpConvInfo);
end;

function EnumDFonts(lpdv : PDev; lpFaceName : PStr;
                    lpCallbackFunc : TFnEnumDFonts;
                    lpClientData : Pointer) : Integer;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogEnumDFonts, nil, nil);
  {$ENDIF}
  EnumDFonts := UniEnumDFonts(lpdv, lpFaceName, lpCallbackFunc, lpClientData);
end;

function EnumObj(lpdv : PDev; wStyle : Word; lpCallbackFunc : TFarProc;
                 lpClientData : Pointer) : Integer;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogEnumObj, @wStyle, nil);
  {$ENDIF}
  EnumObj := UniEnumObj(lpdv, wStyle, lpCallbackFunc, lpClientData);
end;

function ExtDeviceMode(hwnd : HWND;         { parent for DM_PROMPT dialog }
                       hInst : THandle;     { handle from LoadLibrary() }
                       lpdmOut : PDevMode;  { output DEVMODE for DM_COPY }
                       lpDevName : PStr;    { device name }
                       lpPort : PStr;       { port name }
                       lpdmIn : PDevMode;   { input DEVMODE for DM_MODIFY }
                       lpProfile : PStr;    { alternate .ini file }
                       wMode : Word) : Integer; { option(s) to carry out }
begin
  ExtDeviceMode := UniExtDeviceMode(hwnd, hInst, lpdmOut, lpDevName,
                                    lpPort, lpdmIn, lpProfile, wMode);
end;

function ExtDeviceModePropSheet(hwnd : HWND;                  { parent for dialog }
                                hInst : THandle;              { handle from LoadLibrary() }
                                lpDevName : PStr;             { friendly name }
                                lpPort : PStr;                { port name }
                                dwReserved : DWord;           { for future use }
                                lpfnAdd : TFnAddPropSheetPage;{ callback to add dialog }
                                lParam : Longint) : Integer;  { pass to callback }
begin
  ExtDeviceModePropSheet := UniExtDeviceModePropSheet(hwnd, hInst, lpDevName,
                                                      lpPort, dwReserved,
                                                      lpfnAdd, lParam);
end;

function FastBorder(lpRect : PRect; Width : Integer; Depth : Integer;
                    lRop : Longint; lpdv : PDev; lpPBrush : PPBrush;
                    lpDrawMode : PDrawMode; lpCR : PRect) : Integer;
begin
  FastBorder := 0;
end;

function Output(lpdv : PDev;                      { ptr to the destination }
                wStyle : Word;                    { output operation }
                wCount : Word;                    { number of points }
                lpPoints : PPoint;                { ptr to a set of points }
                lpPPen : PPPen;                   { ptr to a physical pen }
                lpPBrush : PPBrush;               { ptr to a physical brush }
                lpDrawMode : PDrawMode;           { ptr to a drawing mode }
                lpCR : PRect) : Integer;          { ptr to a clip rect if <> 0 }
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogOutput, @wStyle, nil);
  {$ENDIF}
  Output := UniOutput(lpdv, wStyle, wCount, lpPoints, lpPPen,
                      lpPBrush, lpDrawMode, lpCR);
end;

function Pixel(lpdv : PDev; X, Y : Integer; Color : DWord;
               lpDrawMode : PDrawMode) : DWord;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogPixel, nil, nil);
  {$ENDIF}
  Pixel := UniPixel(lpdv, X, Y, Color, lpDrawMode);
end;

function RealizeObject(lpdv : PDev; sStyle : Integer; lpInObj : PStr;
                       lpOutObj : PStr; lpTextXForm : PTextXForm) : DWord;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogRealizeObj, @sStyle, nil);
  {$ENDIF}
  RealizeObject := UniRealizeObject(lpdv, sStyle, lpInObj, lpOutObj, lpTextXForm);
end;

function ScanLR(lpdv : PDev; X, Y : Integer; Color : DWord;
                DirStyle : Word) : Integer;
begin
  {
    ScanLR is only called for RASDISPLAY devices.
    Keep a stub function here so nobody complains.
  }
  ScanLR := 0;
end;

function SetAttribute(lpdv : PDev; StateNum : Word; Index : Word;
                      Attribute : Word) : Integer;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogSetAttribute, nil, nil);
  {$ENDIF}
  SetAttribute := 0;
end;

function SetDIBitsToDevice(lpdv : PDev; DstXOrg, DstYOrg : Word;
                           StartScan, NumScans : Word; lpCR : PRect;
                           lpDrawMode : PDrawMode; lpDIBits : PStr;
                           lpDIBHdr : PBitmapInfoHeader;
                           lpConvInfo : PStr) : Integer;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogSetDIBits, nil, nil);
  {$ENDIF}
  SetDIBitsToDevice := UniSetDIBitsToDevice(lpdv, DstXOrg, DstYOrg,
                                            StartScan, NumScans, lpCR,
                                            lpDrawMode, lpDIBits,
                                            lpDIBHdr, lpConvInfo);
end;

function StrBlt(lpdv : PDev; X, Y : Integer; lpCR : PRect; lpStr : PStr;
                Count : Integer; lpFontInfo : PFontInfo;
                lpDrawMode : PDrawMode; lpXform : PTextXForm) : DWord;
begin
  {
    StrBlt is never called by GDI.
    Keep a stub function here so nobody complains
  }
  StrBlt := 0;
end;

function StretchBlt(lpdv : PDev; DstX, DstY : Integer;
                    DstXE, DstYE : Integer; lpBitmaps : PBitmap;
                    SrcX, SrcY : Integer; SrcXE, SrcYE : Integer;
                    dwRop : DWord; lpbr : PPBrush; lpdm : PDrawMode;
                    lpClip : PRect) : Integer;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogStretchBlt, nil, nil);
  {$ENDIF}
  StretchBlt := -1;   {tell GDI to do it}
end;

function StretchDIB(lpdv : PDev; wMode : Word; DstX, DstY : Integer;
                    DstXE, DstYE : Integer; SrcX, SrcY : Integer;
                    SrcXE, SrcYE : Integer; lpBits : PStr;
                    lpDIBHdr : PBitmapInfoHeader; lpConvInfo : PStr;
                    dwRop : DWord; lpbr : PPBrush; lpdm : PDrawMode;
                    lpClip : PRect) : Integer;
begin
  {$IFDEF LogControlsVerbose}
  LogControl(lpdv, nclogStretchDIB, @wMode, nil);
  {$ENDIF}
  StretchDIB := UniStretchDIB(lpdv, wMode, DstX, DstY, DstXE, DstYE,
                              SrcX, SrcY, SrcXE, SrcYE, lpBits, lpDIBHdr,
                              lpConvInfo, dwRop, lpbr, lpdm, lpClip);
end;

begin
  StartJobCallback := nil;
  EndJobCallback := nil;
  ModuleName[0] := #0;

  {$IFDEF LogControls}
  GetSystemDirectory(WinSysDir, 255);
  LFName := StrPas(WinSysDir) + '\PRNDRV.LOG';
  assign(LF, LFName);
  rewrite(LF);
  writeln(LF, 'func      name       lpdv       lpXpdv    lpInData  lpOutData  escape-specific');
  writeln(LF);
  close(LF);
  {$ENDIF}
end.

