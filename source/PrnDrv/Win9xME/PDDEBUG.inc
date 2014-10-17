{*********************************************************}
{*                   PDDEBUG.INC 4.05                    *}
{*      Copyright (C) TurboPower Software  1996-2002     *}
{*                 All rights reserved.                  *}
{*********************************************************}
{.$DEFINE LogControls}  {Define to generate a log file of controls received}

{----------------------------------------------}
{ debug routines for the printer driver engine }
{----------------------------------------------}

{$IFDEF LogControls}
const
  nclogEnable       = $FFFF;
  nclogDisable      = $FFFE;
  nclogSetCvtRes    = $FFFD;
  nclogCBFnDump     = $FFFC;
  {nclogAdvSetupDlg = $FFFB;}
  nclogBitmapBits   = $FFFA;
  nclogColorInfo    = $FFF9;
  nclogDevBitBlt    = $FFF8;
  nclogDevExtTxtOut = $FFF7;
  nclogDevGetCharW  = $FFF6;
  nclogDeviceBitmap = $FFF5;
  {nclogDeviceCap   = $FFF4;}
  {nclogDeviceMode  = $FFF3;}
  nclogDevSelectBM  = $FFF2;
  {nclogDevInstall  = $FFF1;}
  {nclogDIBBlt      = $FFF0;}
  nclogEnumDFonts   = $FFEF;
  nclogEnumObj      = $FFEE;
  {nclogExtDevMode  = $FFED;}
  {nclogExtDMPropSht= $FFEC;}
  nclogOutput       = $FFEB;
  nclogPixel        = $FFEA;
  nclogRealizeObj   = $FFE9;
  nclogSetAttribute = $FFE8;
  nclogSetDIBits    = $FFE7;
  nclogStretchDIB   = $FFE6;
  nclogStretchBlt   = $FFE5;
  nclogOrientation  = $FFE4;
  nclogBandSize     = $FFE3;
  nclogLndscpRotate = $FFE2;
  nclogLndscpAlloc  = $FFE1;
  nclogLndscpFree   = $FFE0;

const
  Digits : array[0..$F] of Char = '0123456789ABCDEF';

var
  LF        : Text;
  LFName    : String;
  WinSysDir : array[0..255] of Char;

function HexB(B : Byte) : String;
  {-Return the hex string for a byte.}
begin
  Result[0] := #2;
  Result[1] := Digits[B shr 4];
  Result[2] := Digits[B and $F];
end;

function HexW(W : Word) : String;
  {-Return the hex string for a word.}
begin
  Result[0] := #4;
  Result[1] := Digits[hi(W) shr 4];
  Result[2] := Digits[hi(W) and $F];
  Result[3] := Digits[lo(W) shr 4];
  Result[4] := Digits[lo(W) and $F];
end;

function HexPtr(P : Pointer) : String;
  {-Return the hex string for a pointer}
begin
  Result := HexW(OS(P).S)+':' + HexW(OS(P).O);
end;

procedure LogControl(lpdv : PDev; func : Word;
                     lpInData, lpOutData : Pointer);
type
  String10 = String[10];

  PBandInfo = ^TBandInfo;
  TBandInfo =
    record
      fGraphics : WordBool;
      fText     : WordBool;
      rcGraphic : TRect;
    end;

  procedure NonControlLog(s : String10);
    {not a control function}
  begin
    writeln(LF, '     ',
                '  ', s,
                '  ', HexPtr(lpdv),
                '  ', HexPtr(lpdv^.lpMD),
                '  ', HexPtr(lpInData),
                '  ', HexPtr(lpOutData));
  end;

  procedure NCIntegerInDataLog(s : String10);
    {lpInData is pointer to integer value, function is not from control}
  var
    IntVal : Integer;

  begin
    if lpInData = nil then
      NonControlLog(s)
    else begin
      IntVal := PInteger(lpInData)^;
      writeln(LF, '     ',
                  '  ', s,
                  '  ', HexPtr(lpdv),
                  '  ', HexPtr(lpdv^.lpMD),
                  '  ', IntVal:9,
                  '  ', HexPtr(lpOutData));
    end;
  end;

  procedure NCIntegerInOutDataLog(s : String10);
    {lpInData and lpOutData are pointers to integer value,
     function is not from control}
  var
    IntVal1 : Integer;
    IntVal2 : Integer;

  begin
    if (lpInData = nil) or (lpOutData = nil) then
      NonControlLog(s)
    else begin
      IntVal1 := PInteger(lpInData)^;
      IntVal2 := PInteger(lpOutData)^;
      writeln(LF, '     ',
                  '  ', s,
                  '  ', HexPtr(lpdv),
                  '  ', HexPtr(lpdv^.lpMD),
                  '  ', IntVal1:9,
                  '  ', IntVal2:9);
    end;
  end;

  procedure StdLog(s : String10);
    {standard info only}
  begin
    writeln(LF, func:5,
                '  ', s,
                '  ', HexPtr(lpdv),
                '  ', HexPtr(lpdv^.lpMD),
                '  ', HexPtr(lpInData),
                '  ', HexPtr(lpOutData));
  end;

  procedure StdPreLog(s : String10);
    {standard info without line feed (escape specific info to follow)}
  begin
    write(LF, func:5,
              '  ', s,
              '  ', HexPtr(lpdv),
              '  ', HexPtr(lpdv^.lpMD),
              '  ', HexPtr(lpInData),
              '  ', HexPtr(lpOutData),
              '  ');
  end;

  procedure ShortLog(s : String10);
    {standard info only (no lpInData or lpOutData)}
  begin
    writeln(LF, func:5,
                '  ', s,
                '  ', HexPtr(lpdv),
                '  ', HexPtr(lpdv^.lpMD));
  end;

  procedure ShortPreLog(s : String10);
    {abreviated info without line feed (escape specific info to follow)}
  begin
    write(LF, func:5,
              '  ', s,
              '  ', HexPtr(lpdv),
              '  ', HexPtr(lpdv^.lpMD),
              '                        ');
  end;

  procedure IntegerInDataLog(s : String10);
    {lpInData is pointer to integer value}
  var
    IntVal : Integer;

  begin
    if lpInData = nil then
      StdLog(s)
    else begin
      IntVal := PInteger(lpInData)^;
      writeln(LF, func:5,
                  '  ', s,
                  '  ', HexPtr(lpdv),
                  '  ', HexPtr(lpdv^.lpMD),
                  '  ', IntVal:9,
                  '  ', HexPtr(lpOutData));
    end;
  end;

  procedure UnknownEscapeLog(i : Integer);
    {log an unknown escape code}
  begin
    StdLog('          ');
  end;

begin
  assign(LF, LFName);
  append(LF);
  case func of
      { writeln(LF, 'func  name           lpdv       lpXPDV     lpInData     lpOutData     Escape-Specific'); }
      {              xxxx  xxxxxxxx     xxxx:xxxx   xxxx:xxxx   xxxx:xxxx    xxxx:xxxx                     }
    nclogEnable :
      NCIntegerInDataLog('Enable    ');
    nclogDisable :
      NonControlLog('Disable   ');
    nclogSetCvtRes :
      NCIntegerInDataLog('SetCvtRes ');
    nclogCBFnDump :
      NCIntegerInDataLog('CBfnDump  ');
    nclogBitmapBits :
      NonControlLog('BitmapBits');
    nclogColorInfo :
      NonControlLog('ColorInfo ');
    nclogDevBitBlt :
      NonControlLog('DevBitBlt ');
    nclogDevExtTxtOut :
      NonControlLog('DevExtTOut');
    nclogDevGetCharW :
      NonControlLog('DevGetChrW');
    nclogDeviceBitmap :
      NonControlLog('DeviceBM  ');
    nclogDevSelectBM :
      NonControlLog('DevSelBM  ');
    nclogEnumDFonts :
      NonControlLog('EnumDFonts');
    nclogEnumObj :
      NCIntegerInDataLog('EnumObj   ');
    nclogOutput :
      NCIntegerInDataLog('Output    ');
    nclogPixel :
      NonControlLog('Pixel     ');
    nclogRealizeObj :
      NCIntegerInDataLog('RealizeObj');
    nclogSetAttribute :
      NonControlLog('SetAttrib ');
    nclogSetDIBits :
      NonControlLog('SetDIBits ');
    nclogStretchDIB :
      NCIntegerInDataLog('StretchDIB');
    nclogStretchBlt :
      NonControlLog('StretchBlt');
    nclogOrientation :
      NCIntegerInDataLog('Orient:P/L');
    nclogBandSize :
      NCIntegerInOutDataLog('Band Size ');
    nclogLndscpRotate :
      NonControlLog('LndscpRot ');
    nclogLndscpAlloc :
      NonControlLog('LndscpMemA');
    nclogLndscpFree :
      NonControlLog('LndscpMemF');

    WinTypes.AbortDoc :
      StdLog('AbortDoc  ');
    BandInfo :
      begin
        ShortPreLog('BandInfo  ');
        with PBandInfo(lpInData)^ do begin
          if fGraphics then
            write(LF,' g:T')
          else
            write(LF,' g:F');
          if fText then
            write(LF,' t:T ')
          else
            write(LF,' t:F ');
          with rcGraphic do
            writeln(LF,Left:6,Right:6,Top:6,Bottom:6);
        end;
      end;
    Begin_Path :
      ShortLog('BeginPath ');
    Clip_To_Path :
      ShortLog('ClipToPath');
    DraftMode :
      IntegerInDataLog('DraftMode ');
    DrawPatternRect :
      StdLog('DrawPtnRct');
    EnableDuplex :
      IntegerInDataLog('EnableDplx');
    EnablePairKerning :
      IntegerInDataLog('EnablPrKrn');
    EnableRelativeWidths :
      IntegerInDataLog('EnablRlWid');
    End_Path :
      StdLog('EndPath   ');
    WinTypes.EndDoc :
      StdLog('EndDoc    ');
    EnumPaperBins :
      ShortLog('EnumPprBin');
    EnumPaperMetrics :
      IntegerInDataLog('EnumPprMet');
    EpsPrinting :
      ShortLog('EPS Print ');
    Ext_Device_Caps :
      IntegerInDataLog('ExtDevCaps');
    FlushOutput :
      ShortLog('FlushOut ');
    GetColorTable :
      IntegerInDataLog('GetClrTabl');
    GetExtendedTextMetrics :
      ShortLog('GetExtTMet');
    GetExtentTable :
      ShortLog('GetXtntTbl');
    GetPairKernTable :
      ShortLog('GetPrKrnTb');
    GetPhysPageSize :
      ShortLog('GetPhyPgSz');
    GetPrintingOffset :
      ShortLog('GetPrntOfs');
    GetScalingFactor :
      ShortLog('GetScalFct');
    GetSetPaperBins :
      ShortLog('GetSetPBin');
    GetSetPaperMetrics :
      begin
        ShortPreLog('GetSetPMet');
        with PRect(lpInData)^ do
          writeln(LF,Left:6,Right:6,Top:6,Bottom:6);
      end;
    GetSetPrintOrient :
      IntegerInDataLog('GetSetPOri');
    GetTechnology :
      ShortLog('GetTechnol');
    GetTrackKernTable :
      ShortLog('GetTrkKerT');
    GetVectorBrushSize :
      ShortLog('GetVctBrSz');
    GetVectorPenSize :
      ShortLog('GetVctPnSz');
    NewFrame :
      ShortLog('NewFrame  ');
    NextBand :
      ShortLog('NextBand  ');
    PassThrough :
      ShortLog('PassThru  ');
    QueryEscSupport :
      IntegerInDataLog('QueryEsc  ');
    ResetDevice :
      StdLog('ResetDC   ');
    Restore_CTM :
      ShortLog('RstrCTM ');
    Save_CTM :
      ShortLog('SaveCTM ');
    Set_Arc_Direction :
      IntegerInDataLog('SetArcDir ');
    Set_Background_Color :
      begin
        ShortPreLog('SetBGColor');
        if (lpInData = nil) then
          writeln(LF,'(get cur color)')
        else
          writeln(LF,PLongInt(lpInData)^);
      end;
    Set_Bounds :
      ShortLog('SetBounds ');
    Set_Clip_Box :
      ShortLog('SetClipBox');
    Set_Poly_Mode :
      IntegerInDataLog('SetPolyMd ');
    Set_Screen_Angle :
      IntegerInDataLog('SetScrnAng');
    Set_Spread :
      IntegerInDataLog('SetSpread ');
    WinTypes.SetAbortProc :
      IntegerInDataLog('SetAbortPr');
    SetAllJustValues :
      ShortLog('SetAllJust');
    SetColorTable :
      ShortLog('SetColrTbl');
    SetCopyCount :
      IntegerInDataLog('SetCopyCnt');
    SetKernTrack :
      IntegerInDataLog('SetKernTrk');
    SetEndCap :
      IntegerInDataLog('SetLineCap');
    SetLineJoin :
      IntegerInDataLog('SetLnJoin ');
    SetMiterLimit :
      ShortLog('SetMitrLim');
    WinTypes.StartDoc :
      begin
        ShortPreLog('StartDoc  ');
        writeln(LF,PChar(lpInData));
      end;
    Transform_CTM :
      ShortLog('TrnsfrmCTM');
  else
    UnknownEscapeLog(func);
  end;
  close(LF);
end;

{$ENDIF}


