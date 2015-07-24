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
 *   Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   AWKERMIT.PAS 4.06                   *}
{*********************************************************}
{* Kermit protocol                                       *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$V-,I-,B-,F+,A-,X+}

unit AwKermit;
  {-Provides Kermit receive and transmit functions}

interface

uses
  Windows,
  Messages,
  SysUtils,
  OoMisc,
  AwUser,
  AwTPcl,
  AwAbsPcl,
  AdPort;     

const
  {Constants}
  DefMinRepeatCnt = 4;      {Minimum characters to use repeat prefix}
  FastAbort = False;        {Use Error packet for aborting}
  DefHibitPrefix = '&';     {Default char for hibit prefixing}
  CancelWait = 182;         {Wait 10 seconds for cancel transmit}
  DiscardChar = 'D';        {For signaling an abort}
  MaxWindowSlots = 27;      {Avoids MS-Kermit bug}

  {For estimating protocol transfer times}
  KermitOverhead = 20;      {Bytes of overhead for each block}
  KermitTurnDelay = 1000;   {Msecs of turn around delay}
  SWCKermitTurnDelay = 0;   {Msecs of turn around delay on SWC xfers}

  {#Z+}
  {Packet types}
  KBreak           = 'B';        {Break transmission (EOT)}
  KData            = 'D';        {Data packet}
  KError           = 'E';        {Error packet}
  KFile            = 'F';        {File header packet}
  KNak             = 'N';        {Negative acknowledge packet}
  KSendInit        = 'S';        {Initial packet (exchange options)}
  KDisplay         = 'X';        {Display text on screen packet}
  KAck             = 'Y';        {Acknowledge packet}
  KEndOfFile       = 'Z';        {End of file packet}
  {#Z-}

const
  {Default kermit options (from the Kermit Protocol Manual)}
  DefKermitOptions : TKermitOptions =
    (MaxPacketLen : 80;                    {80 characters}
     MaxTimeout :  5;                      {5 seconds}
     PadCount : 0;                         {No pad chars}
     PadChar : #0;                         {Null pad char}
     Terminator : cCR;                     {Carriage return}
     CtlPrefix : '#';                      {'#' char}
     HibitPrefix : 'Y';                    {Space means no hibit prefixing}
     Check : '1';                          {1 byte chksum}
     RepeatPrefix : '~';                   {Default repeat prefix}
     CapabilitiesMask : 0;                 {No default extended caps}
     WindowSize : 0;                       {No default windows}
     MaxLongPacketLen : 0);                {No default long packets}

  {#Z+}
  {Default kermit options (from the Kermit Protocol Manual)}
  MissingKermitOptions : TKermitOptions =
    (MaxPacketLen : 80;                    {80 characters}
     MaxTimeout :  5;                      {5 seconds}
     PadCount : 0;                         {No pad chars}
     PadChar : #0;                         {Null pad char}
     Terminator : cCR;                     {Carriage return}
     CtlPrefix : '#';                      {'#' char}
     HibitPrefix : ' ';                    {No hibit prefixing}
     Check : '1';                          {1 byte chksum}
     RepeatPrefix : ' ';                   {Default repeat prefix}
     CapabilitiesMask : 0;                 {No default extended caps}
     WindowSize : 0;                       {No default windows}
     MaxLongPacketLen : 0);                {No default long packets}
   {#Z-}

{Constructors/destructors}
function kpInit(var P : PProtocolData; H : TApdCustomComPort;     
                Options : Cardinal) : Integer;
procedure kpDone(var P : PProtocolData);

function kpReinit(P : PProtocolData) : Integer;
procedure kpDonePart(P : PProtocolData);

{Options}
function kpSetKermitOptions(P : PProtocolData; KOptions : TKermitOptions) : Integer;
function kpSetMaxPacketLen(P : PProtocolData; MaxLen : Byte) : Integer;
function kpSetMaxLongPacketLen(P : PProtocolData; MaxLen : Cardinal) : Integer;
function kpSetMaxWindows(P : PProtocolData; MaxNum : Byte): Integer;
function kpSetSWCTurnDelay(P : PProtocolData; TrnDelay : Cardinal) : Integer;
function kpSetMaxTimeoutSecs(P : PProtocolData; MaxTimeout : Byte) : Integer;
function kpSetPacketPadding(P : PProtocolData; C : AnsiChar; Count : Byte) : Integer;
function kpSetTerminator(P : PProtocolData; C : AnsiChar) : Integer;
function kpSetCtlPrefix(P : PProtocolData; C : AnsiChar) : Integer;
function kpSetHibitPrefix(P : PProtocolData; C : AnsiChar) : Integer;
function kpSetRepeatPrefix(P : PProtocolData; C : AnsiChar) : Integer;
function kpSetKermitCheck(P : PProtocolData; CType : Byte) : Integer;
function kpGetSWCSize(P : PProtocolData) : Byte;
function kpGetLPStatus(P : PProtocolData;
                      var InUse : Bool;
                      var PacketSize : Cardinal) : Integer;
function kpWindowsUsed(P : PProtocolData) : Byte;

{Control}
procedure kpPrepareReceive(P : PProtocolData);
procedure kpReceive(Msg, wParam : Cardinal;
                       lParam : Integer);
procedure kpPrepareTransmit(P : PProtocolData);
procedure kpTransmit(Msg, wParam : Cardinal;
                       lParam : Integer);


implementation

uses
  AnsiStrings;

const
  {'S' - SendInit packet option index}
  MaxL    = 1;     {Max packet length sender can receive (Def = none)}
  Time    = 2;     {Max seconds to wait before timing out (Def = none)}
  NPad    = 3;     {Number of padding chars before packets (Def = none)}
  PadC    = 4;     {Padding character (Def = Nul)}
  EOL     = 5;     {Packet terminator character (Def = CR)}
  QCtl    = 6;     {Prefix char for control-char encoding (Def = #)}
  QBin    = 7;     {Prefix char for hi-bit encoding (Def = ' ' none)}
  Chkt    = 8;     {1=chksum, 2=2 byte chksum, 3=CRC (Def = 1)}
  Rept    = 9;     {Prefix char for repeat-count encoding (Def = ' ' none)}
  Capa    = 10;    {Advanced capabilities bit masks}
  Windo   = 11;    {Size of the sliding window (in packets)}
  MaxLx1  = 12;    {long packet size div 95}
  MaxLx2  = 13;    {Long packet size mod 95}
  SendInitLen = 13; {Size of SendInit data block}
  MaxKermitOption = 13;

  {Advanced capability bit masks}
  LastMask       = $01;  {Set if more bit masks follow}
  LongPackets    = $02;  {Set if using long packets}
  SlidingWindows = $04;  {Set if using sliding windows}
  FileAttribute  = $08;  {Set if using Attribut packets, not supported}

  {Text strings for various error/abort conditions}
  eRecInitTO = 'Timeout waiting for RecInit packet';
  eFileTO = 'Timeout waiting for File packet';
  eDataTO = 'Timeout waiting for Data packet';
  eSync = 'Failed to syncronize protocol';
  eAsync = 'Blockcheck or other error';
  eCancel = 'Canceled';
  eFileExists = 'Not allowed to overwrite existing file';
  eFileError = 'Error opening or writing file';

  {Check to aCheckType conversion array}
  CheckVal : array[1..3] of Byte = (bcChecksum1, bcChecksum2, bcCrcK);

  {Used in ProtocolReceivePart/ProtocolTransmitPart}
  FirstDataState : array[Boolean] of TKermitDataState = (dskData, dskCheck1); 
  FreeMargin = 20;

  aDataTrigger = 0;

  LogKermitState : array[TKermitState] of TDispatchSubType = (
    dsttkInit, dsttkInitReply, dsttkCollectInit, dsttkOpenFile,
    dsttkSendFile, dsttkFileReply, dsttkCollectFile, dsttkCheckTable,
    dsttkSendData, dsttkBlockReply, dsttkCollectBlock, dsttkSendEof,
    dsttkEofReply, dsttkCollectEof, dsttkSendBreak, dsttkBreakReply,
    dsttkCollectBreak, dsttkComplete, dsttkWaitCancel, dsttkError,
    dsttkDone, dstrkInit, dstrkGetInit, dstrkCollectInit,
    dstrkGetFile, dstrkCollectFile, dstrkGetData, dstrkCollectData,
    dstrkComplete, dstrkWaitCancel, dstrkError, dstrkDone);          

  function ToChar(C : AnsiChar) : AnsiChar;
    {-Returns C+$20}
//  asm
//    add al,$20;
//  end;
  begin
    Result:= AnsiChar(byte(C)+$20);
  end;

  function UnChar(C : AnsiChar) : AnsiChar;
    {-Returns C-$20}
//  asm
//    sub al,$20
//  end;
  begin
    Result:= AnsiChar(byte(C)-$20);
  end;

  function Ctl(C : AnsiChar) : AnsiChar;
    {-Returns C xor $40}
//  asm
//    xor al,$40
//  end;
  begin
    Result:= AnsiChar(Byte(c) xor $40);
  end;

  function Inc64(W : Cardinal) : Cardinal;
    {-Returns (W+1) mod 64}
//  asm
//    inc ax
//    and ax,$3F
//  end;
  begin
    Result:= (W+1) and $3F;
  end;

  function Dec64(W : Cardinal) : Cardinal;
    {-Returns (W-1) or 63 if W=0}
//  asm
//    dec ax
//    jns @@done
//    mov ax,63
//    @@done:
//  end;
  begin
    Result:= W-1;
    if Integer(Result) < 0 then Result:= 63;
  end;

  function IsCtl(C : AnsiChar) : Bool;
  begin
    IsCtl := (C <= #31) or (C = #127);
  end;

  function IsHiBit(C : AnsiChar) : Bool;
  begin
    IsHiBit := (Ord(C) and $80) <> 0;
  end;

  function HiBit(C : AnsiChar) : AnsiChar;
//  asm
//    or ax,$80
//  end;
  begin
    Result:= AnsiChar(byte(c) or $80);
  end;

  procedure kpFinishWriting(P : PProtocolData);
    {-Handle "discard" option}
  begin
    with P^ do begin
      if aFileOpen then begin
        {Let parent close file}
        aapFinishWriting(P);

        {Discard the file if asked to do so}
        if (kActualDataLen >= 1) and (aDataBlock^[1] = DiscardChar) then begin
          Erase(aWorkFile);
          if IOResult = 0 then ;
        end;
      end;
    end;
  end;

  procedure kpAllocateWindowTable(P : PProtocolData);
    {-Allocate the window table}
  begin
    with P^ do
      {Allocate sliding window data table}
      kDataTable := AllocMem(kTableSize*aBlockLen);
  end;

  procedure kpDeallocateWindowTable(P : PProtocolData);
    {-Deallocate current window table}
  begin
    with P^ do
      FreeMem(kDataTable, kTableSize*aBlockLen);
  end;

  procedure kpRawInit(P : PProtocolData);
    {-Do low-level initializations}
  begin
    with P^ do begin
      aCurProtocol := Kermit;
      aFileOfs := 0;
      aBlockLen := DefKermitOptions.MaxPacketLen;
      aFileOpen := False;
      kUsingHibit := False;
      kUsingRepeat := False;
      kKermitOptions := DefKermitOptions;
      kPacketType := ' ';
      kMinRepeatCnt := DefMinRepeatCnt;
      aBatchProtocol := True;
      kLPInUse := False;
      apResetReadWriteHooks(P);
    end;
  end;

  function kpInit(var P : PProtocolData; H : TApdCustomComPort;
                  Options : Cardinal) : Integer;
    {-Allocates and initializes a protocol control block with options}
  begin
    {Check for adequate output buffer size}
    if H.OutBuffUsed + H.OutBuffFree < 1024 then begin
      kpInit := ecOutputBufferTooSmall;
      Exit;
    end;
    {Allocate the protocol data record}
    if apInitProtocolData(P, H, Options) <> 0 then begin
      kpInit := ecOutOfMemory;
      Exit;
    end;

    with P^ do begin
      aDataBlock := nil;
      kWorkBlock := nil;
      kDataTable := nil;

      kpRawInit(P);

      aOverhead := KermitOverhead;
      aTurnDelay := KermitTurnDelay;
      kSWCTurnDelay := SWCKermitTurnDelay;

      apFinishWriting := kpFinishWriting;
      kKermitOptions := DefKermitOptions;
      with kKermitOptions do begin
        if MaxLongPacketLen = 0 then
          aBlockLen := MaxPacketLen
        else
          aBlockLen := MaxLongPacketLen;
        if WindowSize = 0 then
          kTableSize := 1
        else
          kTableSize := WindowSize;
        aCheckType := CheckVal[Byte(Check)-$30];
      end;

      {Allocate data and work blocks}
      aDataBlock := AllocMem(SizeOf(TDataBlock));
      kWorkBlock := AllocMem(SizeOf(TDataBlock));

      {Allocate table for data blocks}
      kpAllocateWindowTable(P);

    end;

    {All okay}
    kpInit := ecOK;
  end;

  function kpReinit(P : PProtocolData) : Integer;
    {-Allocates and initializes a protocol control block with options}
  begin
    with P^ do begin
      aDataBlock := nil;
      kWorkBlock := nil;
      kDataTable := nil;

      kpRawInit(P);

      apFinishWriting := kpFinishWriting;
      kKermitOptions := DefKermitOptions;
      with kKermitOptions do begin
        if MaxLongPacketLen = 0 then
          aBlockLen := MaxPacketLen
        else
          aBlockLen := MaxLongPacketLen;
        if WindowSize = 0 then
          kTableSize := 1
        else
          kTableSize := WindowSize;
        aCheckType := CheckVal[Byte(Check)-$30];
      end;

      {Allocate data and work blocks}
      aDataBlock := AllocMem(SizeOf(TDataBlock));
      kWorkBlock := AllocMem(SizeOf(TDataBlock));

      {Allocate table for data blocks}
      kpAllocateWindowTable(P);

      {Allocate internal buffer }
      kInBuff := AllocMem(SizeOf(TInBuffer));
      kInBuffHead := 1;
      kInBuffTail := 1;                                             
    end;

    {All okay}
    kpReinit := ecOK;
  end;

  procedure kpDonePart(P : PProtocolData);
    {-Disposes of Kermit protocol record}
  begin
    with P^ do begin
      kpDeallocateWindowTable(P);
      FreeMem(aDataBlock, SizeOf(TDataBlock));
      FreeMem(kWorkBlock, SizeOf(TDataBlock));
      if kInBuff <> nil then begin
        FreeMem(kInBuff, SizeOf(TInBuffer));
        kInBuff := nil;
      end;                                                        
    end;
  end;

  procedure kpDone(var P : PProtocolData);
    {-Disposes of Kermit protocol record}
  begin
    with P^ do begin
      kpDonePart(P);
      apDoneProtocol(P);
    end;
  end;

  function kpSetKermitOptions(P : PProtocolData;
                              KOptions : TKermitOptions) : Integer;
    {-Update the KermitProtocol object to use KOptions}
  begin
    with P^ do begin
      if aCurProtocol <> Kermit then begin
        kpSetKermitOptions := ecBadProtocolFunction;
        Exit;
      end;

      kKermitOptions := KOptions;
      aCheckType := CheckVal[Byte(kKermitOptions.Check)-$30];
      kpSetKermitOptions := ecOk;
      {Check for errors}
    end;
  end;

  function kpSetMaxPacketLen(P : PProtocolData; MaxLen : Byte) : Integer;
    {-Set the maximum packet length}
  begin
    with P^ do begin
      if aCurProtocol <> Kermit then begin
        kpSetMaxPacketLen := ecBadProtocolFunction;
        Exit;
      end;

      if MaxLen > 94 then
        kpSetMaxPacketLen := ecBadArgument
      else begin
        kpSetMaxPacketLen := ecOk;
        kKermitOptions.MaxPacketLen := MaxLen;
      end;
    end;
  end;

  function kpSetMaxLongPacketLen(P : PProtocolData; MaxLen : Cardinal) : Integer;
    {-Set the maximum packet length}
  begin
    with P^ do begin
      if aCurProtocol <> Kermit then begin
        kpSetMaxLongPacketLen := ecBadProtocolFunction;
        Exit;
      end;

      if MaxLen > 1024 then begin
        kpSetMaxLongPacketLen := ecBadArgument;
        Exit;
      end;

      {Assume success}
      kpSetMaxLongPacketLen := ecOK;

      {Deallocate current table}
      kpDeallocateWindowTable(P);

      if MaxLen > 0 then begin
        SetFlag(aFlags, apKermitLongPackets);
        with kKermitOptions do begin
          CapabilitiesMask := CapabilitiesMask or LongPackets;
          MaxLongPacketLen := MaxLen;
          aBlockLen := MaxLen;
          if kKermitOptions.Check = '1' then
            kKermitOptions.Check := '2';
        end;
      end else begin
        ClearFlag(aFlags, apKermitLongPackets);
        with kKermitOptions do begin
          CapabilitiesMask := CapabilitiesMask and not LongPackets;
          MaxLongPacketLen := 0;
        end;
        aBlockLen := 80;
      end;

      {Reallocate table}
      kpAllocateWindowTable(P);
    end;
  end;

  function kpSetMaxWindows(P : PProtocolData; MaxNum : Byte) : Integer;
    {-Set the number of windows for SWC}
  begin
    with P^ do begin
      if aCurProtocol <> Kermit then begin
        kpSetMaxWindows := ecBadProtocolFunction;
        Exit;
      end;

      if MaxNum > MaxWindowSlots then begin
        kpSetMaxWindows := ecBadArgument;
        Exit;
      end;

      {Assume success}
      kpSetMaxWindows := ecOK;

      {Deallocate current table}
      kpDeallocateWindowTable(P);

      if MaxNum > 0 then begin
        SetFlag(aFlags, apKermitSWC);
        with kKermitOptions do begin
          CapabilitiesMask := CapabilitiesMask or SlidingWindows;
          WindowSize := MaxNum and $1F;
          kTableSize := WindowSize;
        end;
      end else begin
        ClearFlag(aFlags, apKermitSWC);
        with kKermitOptions do begin
          CapabilitiesMask := CapabilitiesMask and not SlidingWindows;
          WindowSize := 0;
        end;
        kTableSize := 1;
      end;

      {Reallocate current table}
      kpAllocateWindowTable(P);
    end;
  end;

  function kpSetSWCTurnDelay(P : PProtocolData; TrnDelay : Cardinal) : Integer;
  begin
    with P^ do
      if aCurProtocol <> Kermit then
        kpSetSWCTurnDelay := ecBadProtocolFunction
      else begin
        kpSetSWCTurnDelay := ecOK;
        kSWCTurnDelay := TrnDelay;
      end;
  end;

  function kpGetSWCSize(P : PProtocolData) : Byte;
    {-Return size of current window (0 if not in use)}
  begin
    with P^ do
      if aCurProtocol <> Kermit then
        kpGetSWCSize := 0
      else
        kpGetSWCSize := kKermitOptions.WindowSize;
  end;

  function kpGetLPStatus(P : PProtocolData;
                         var InUse : Bool;
                         var PacketSize : Cardinal) : Integer;
    {-Return status of long packet feature}
  begin
    with P^ do begin
      if aCurProtocol <> Kermit then
        kpGetLPStatus := ecBadProtocolFunction
      else begin
        kpGetLPStatus := ecOK;
        InUse := kLPInUse;
        if InUse then
          PacketSize := kKermitOptions.MaxLongPacketLen
        else
          PacketSize := 0;
      end;
    end;
  end;

  function kpSetMaxTimeoutSecs(P : PProtocolData; MaxTimeout : Byte) : Integer;
    {-Set the maximum time to wait for a packet}
  begin
    with P^ do
      if aCurProtocol <> Kermit then
        kpSetMaxTimeoutSecs := ecBadProtocolFunction
      else begin
        kpSetMaxTimeoutSecs := ecOK;
        kKermitOptions.MaxTimeout := MaxTimeout;
      end;
  end;

  function kpSetPacketPadding(P : PProtocolData;
                              C : AnsiChar;
                              Count : Byte) : Integer;
    {-Set the pad character and count}
  begin
    with P^, kKermitOptions do begin
      if aCurProtocol <> Kermit then
        kpSetPacketPadding := ecBadProtocolFunction
      else begin
        kpSetPacketPadding := ecOK;
        PadChar := C;
        PadCount := Count;
      end;
    end;
  end;

  function kpSetTerminator(P : PProtocolData; C : AnsiChar) : Integer;
    {-Set the packet terminator}
  begin
    with P^ do
      if aCurProtocol <> Kermit then
        kpSetTerminator := ecBadProtocolFunction
      else begin
        kpSetTerminator := ecOK;
        kKermitOptions.Terminator := C;
      end;
  end;

  function kpSetCtlPrefix(P : PProtocolData; C : AnsiChar) : Integer;
    {-Set the control character quote prefix}
  begin
    with P^ do
      if aCurProtocol <> Kermit then
        kpSetCtlPrefix := ecBadProtocolFunction
      else begin
        kpSetCtlPrefix := ecOK;
        kKermitOptions.CtlPrefix := C;
      end;
  end;

  function kpSetHibitPrefix(P : PProtocolData; C : AnsiChar) : Integer;
    {-Set the hibit quote prefix}
  begin
    with P^ do
      if aCurProtocol <> Kermit then
        kpSetHibitPrefix := ecBadProtocolFunction
      else begin
        kpSetHibitPrefix := ecOK;
        kKermitOptions.HibitPrefix := C;
      end;
  end;

  function kpSetRepeatPrefix(P : PProtocolData; C : AnsiChar) : Integer;
    {-Set the repeat quote prefix}
  begin
    with P^ do
      if aCurProtocol <> Kermit then
        kpSetRepeatPrefix := ecBadProtocolFunction
      else begin
        kpSetRepeatPrefix := ecOK;
        kKermitOptions.RepeatPrefix := C;
      end;
  end;

  function kpSetKermitCheck(P : PProtocolData; CType : Byte) : Integer;
    {-Set the block check type (bcCheckSum1 (default), bcCheckSum2, bcCrcK)}
  begin
    with P^ do begin
      if aCurProtocol <> Kermit then begin
        kpSetKermitCheck := ecBadProtocolFunction;
        Exit;
      end;

      kpSetKermitCheck := ecOk;
      with kKermitOptions do begin
        case CType of
          bcCheckSum1 : Check := '1';
          bcCheckSum2 : Check := '2';
          bcCrcK      : Check := '3';
          else
            begin
              kpSetKermitCheck := ecBadArgument;
              Check := '1';
            end;
        end;
      end;
      aCheckType := CheckVal[Byte(kKermitOptions.Check)-$30];
    end;
  end;

  { Buffer management methods }
  function kpCharReady(P : PProtocolData) : Boolean;
  begin
    with P^ do
      Result := kInBuffHead < kInBuffTail;
  end;

  function kpGetChar(P : PProtocolData) : AnsiChar;
  begin
    with P^ do begin
      inc(kInBuffHead);
      Result := KInBuff^[kInBuffHead];
      if kInBuffHead >= kInBuffTail then begin
        kInBuffHead := 1;
        kInBuffTail := 1;
      end;                                                             
    end;                                                               
  end;                                                                 

  procedure kpCompactInBuff(P : PProtocolData);                        
  var                                                                  
    TempBuffer : PInBuffer;                                            
  begin                                                                
    with P^ do begin                                                   
      TempBuffer := AllocMem(SizeOf(TInBuffer));                       
      FillChar(TempBuffer^, SizeOf(TInBuffer), #0);                    
      Move(kInBuff^[kInBuffHead], TempBuffer^[1],                      
        kInBuffTail - kInBuffHead);                                    
      Move(TempBuffer^[1], kInBuff^[1], SizeOf(TInBuffer));            
      kInBuffTail := kInBuffTail - kInBuffHead + 1;                    
      kInBuffHead := 1;                                                
      FreeMem(TempBuffer, SizeOf(TInBuffer));                          
    end;                                                               
  end;                                                                 

  procedure kpFillInBuff(P : PProtocolData);                           
  begin                                                                
    with P^ do begin                                                   
      while aHC.ValidDispatcher.CharReady do begin                     
        inc(kInBuffTail);                                              
        kInBuff^[kInBuffTail] := aHC.GetChar;                          
        if kInBuffHead > (SizeOf(kInBuff^) div 2) then                 
          kpCompactInBuff(P);                                          
      end;                                                             
    end;                                                               
  end;                                                                 

  procedure kpFlushInBuffer(P : PProtocolData);                        
  begin                                                                
    with P^ do begin                                                   
      aHC.ValidDispatcher.FlushInBuffer;                               
      kInBuffHead := 1;                                                
      kInBuffTail := 1;                                                
    end;                                                               
  end;                                                                 

  procedure kpUpdateBlockCheck(P : PProtocolData; CurByte: Byte);
    {-Updates the block check character (whatever it is)}
  begin
    with P^ do begin
      {Do checksums if requested or check type not known}
      aBlockCheck := apUpdateCheckSum(CurByte, aBlockCheck);

      {Do crc if requested or check type not known}
      kBlockCheck2 := apUpdateCrcKermit(CurByte, kBlockCheck2);
    end;
  end;

  procedure kpSendBlockCheck(P : PProtocolData);
    {-Makes final adjustment and sends the aBlockCheck character}
  var
    Check : Cardinal;
    C : AnsiChar;
  begin
    with P^ do begin
      if kCheckKnown then
        kTempCheck := kKermitOptions.Check
      else
        kTempCheck := '1';

      case kTempCheck of
        '1' : {Standard 1 byte checksum}
          begin
            {Add bits 6,7 into 0-5}
            Check := Lo(aBlockCheck);
            C := ToChar(AnsiChar((Check + (Check shr 6)) and $3F));
            aHC.PutChar(C);
          end;
        '2' : {2 byte checksum}
          begin
            {1st byte has bits 11-6, second has bits 5-0}
            Check := aBlockCheck;
            C := ToChar(AnsiChar((Check shr 6) and $3F));
            aHC.PutChar(C);
            C := ToChar(AnsiChar(Check and $3F));
            aHC.PutChar(C);
          end;
        '3' : {2 byte CRC}
          begin
            Check := kBlockCheck2;
            C := ToChar(AnsiChar((Check shr 12) and $0F));
            aHC.PutChar(C);
            C := ToChar(AnsiChar((Check shr 6) and $3F));
            aHC.PutChar(C);;
            C := ToChar(AnsiChar(Check and $3F));
            aHC.PutChar(C);
          end;
      end;
    end;
  end;

  procedure kpPutToChar(P : PProtocolData; C : AnsiChar);
    {-Put a promoted character}
  begin
    with P^ do
      aHC.PutChar(ToChar(C));
  end;

  procedure kpPutHeader(P : PProtocolData; HType : AnsiChar; Len : Cardinal);
    {-Start a header}
  var
    I : Byte;
  begin
    with P^ do begin
      {Init the block check character}
      aBlockCheck := 0;
      kBlockCheck2 := 0;

      {Send the Mark, Len, Seq and Type fields}
      aHC.PutChar(cSoh);
      if Len <= 94 then begin
        kpPutToChar(P, AnsiChar(Len));
        kpPutToChar(P, AnsiChar(aBlockNum));
        aHC.PutChar(HType);
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(Len))));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(aBlockNum))));
        kpUpdateBlockCheck(P, Byte(HType));
      end else begin
        {Adjust Len to long packet specification}
        Dec(Len, 2);

        {Send Len, Seq and Type fields}
        kpPutToChar(P, #0);
        kpPutToChar(P, AnsiChar(aBlockNum));
        aHC.PutChar(HType);

        {Update header check}
        I := 32;
        Inc(I, Ord(ToChar(AnsiChar(aBlockNum))));
        Inc(I, Ord(HType));

        {Send Lenx1 and Lenx2, update header checksum}
        kpPutToChar(P, AnsiChar(Len div 95));
        Inc(I, Ord(ToChar(AnsiChar(Len div 95))));
        kpPutToChar(P, AnsiChar(Len mod 95));
        Inc(I, Ord(ToChar(AnsiChar(Len mod 95))));
        I := (I + (I shr 6)) and $3F;

        {Send the header checksum}
        kpPutToChar(P, AnsiChar(I));

        {Update regular block check}
        kpUpdateBlockCheck(P, Byte(ToChar(#0)));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(aBlockNum))));
        kpUpdateBlockCheck(P, Byte(HType));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(Len div 95))));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(Len mod 95))));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(I))));
      end;

      {Note what block number needs an Ack}
      kExpectedAck := aBlockNum;
    end;
  end;

  procedure kpTransmitBlock(P : PProtocolData;
                          var Block : TDataBlock;
                          BLen : Cardinal;
                          BType : AnsiChar);
      {-Transmits one data subpacket from Block}
  var
    I : Cardinal;
  begin
    with P^ do begin
      if BLen = 0 then
        Exit;

      {Send the data field}
      aHC.PutBlock(Block, BLen);
      for I := 1 to BLen do
        kpUpdateBlockCheck(P, Byte(Block[I]));
    end;
  end;

  procedure kpSendTerminator(P : PProtocolData);
    {-Send the terminator and padding chars}
  begin
    with P^ do
      aHC.PutChar(kKermitOptions.Terminator);
  end;

  procedure kpSendPacket(P : PProtocolData; PT : AnsiChar);
    {-Send a packet of type PT}
  const
    CheckLen : array[1..3] of Byte = (3, 4, 5);
  var
    TotalLen : Cardinal;
    I : Byte;
  begin
    with P^ do begin
      {Put required padding}
      with kKermitOptions do
        for I := 1 to PadCount do
          aHC.PutChar(PadChar);

      {Calc total length}
      TotalLen := kDataLen + CheckLen[(Byte(kKermitOptions.Check)-$30)];

      {Send the header...}
      kpPutHeader(P, PT, TotalLen);

      {Send the data field}
      kpTransmitBlock(P, aDataBlock^, kDataLen, PT);

      {Finish up}
      kpSendBlockCheck(P);
      kpSendTerminator(P);
    end;
  end;

  procedure kpSendError(P : PProtocolData; Msg : AnsiString);
    {-Send error packet}
  begin
    with P^ do begin
      aBlockNum := Inc64(aBlockNum);
      kDataLen := Length(Msg);
      Move(Msg[1], aDataBlock^[1], kDataLen);
      kpSendPacket(P, KError);
    end;
  end;

  procedure kpCancel(P : PProtocolData);
    {-Sends the cancel string}
  const
    AckLen : array[1..3] of Byte = (3, 4, 5);
  var
    B : Byte;
  begin
    with P^ do begin
      if aHC.Open then begin
        if FastAbort then
          {Abort by sending error packet (old method)}
          kpSendError(P, eCancel)

        else if kReceiveInProgress then begin
          {Abort by sending 'Z' in data field of Ack packet (new method)}
          B := AckLen[Byte(kKermitOptions.Check)-$30];
          aDataBlock^[1] := 'Z';
          kpPutHeader(P, KAck, B+1);
          kpTransmitBlock(P, aDataBlock^, 1, KAck);
          kpSendBlockCheck(P);
          kpSendTerminator(P);

        end else begin
          {Abort by sending EOF packet with 'D' in data field (new method)}
          kDataLen := 1;
          aDataBlock^[1] := DiscardChar;
          aBlockNum := Inc64(aBlockNum);
          kpSendPacket(P, KEndOfFile);
        end;
      end;

      {Show cancel to status}
      aProtocolStatus := psCancelRequested;
    end;
  end;

  procedure kpResetStatus(P : PProtocolData);
    {-Typical reset but aBlockNum must _not_ be reset during protocol}
  begin
    with P^ do begin
      if aInProgress = 0 then begin
        {New protocol, reset status vars}
        aBytesRemaining := 0;
        aBlockNum := 0;
      end;
      aProtocolError := ecOK;
      aProtocolStatus := psOK;
      aSrcFileLen := 0;
      aBytesTransferred := 0;
      aElapsedTicks := 0;
      aBlockErrors := 0;
      aTotalErrors := 0;
    end;
  end;

  procedure kpGetDataChar(P : PProtocolData;
                          var C : AnsiChar;
                          var TableIndex : Cardinal;
                          var RepeatCnt : Cardinal);
    {-Get C from kDataTable handling all prefixing}
  var
    Finished : Bool;
    CtlChar : Bool;
    HibitChar : Bool;
    Repeating : Bool;
  begin
    with P^ do begin
      Finished := False;
      CtlChar := False;
      HibitChar := False;
      Repeating := False;
      RepeatCnt := 1;

      with kKermitOptions do
        repeat
          C := kDataTable^[TableIndex];
          Inc(TableIndex);

          {Set flags according to the Char received}
          if (C = HibitPrefix) and (kUsingHibit) and (not HibitChar) then begin
            if (CtlChar) then
              Exit;
            HibitChar := True;
          end else if C = CtlPrefix then begin
            if CtlChar then begin
              if HibitChar then
                C := AnsiChar(Byte(C) or $80);
              Exit;
            end else
              {Note that the next char is Ctl escaped}
              CtlChar := True;
          end else if (C = RepeatPrefix) and (kUsingRepeat and not Repeating) then begin
            if CtlChar then begin
              {process as ctl char}
              if HibitChar then
                C := AnsiChar(Byte(C) or $80);
              Exit;
            end else begin
              {Repeat flag set, get the count}
              C := kDataTable^[TableIndex];
              Inc(TableIndex);
              Repeating := True;
              RepeatCnt := Byte(UnChar(C));
            end;
          end else begin
            {Normal character}
            Finished := True;

            if (HibitChar and kUsingHibit) then
              C := AnsiChar(Byte(C) or $80);

            if CtlChar then
              {Don't escape normal or hibit Prefix characters}
              if (C = AnsiChar(Byte(CtlPrefix) or $80)) or
                 (kUsingRepeat and (C = AnsiChar(Byte(RepeatPrefix) or $80))) or
                 (kUsingHibit and (C = AnsiChar(Byte(HibitPrefix) or $80))) or
                 (C = RepeatPrefix) then
                {do nothing}
              else
                {Ok to Ctl it}
                C := Ctl(C);
          end;
        until Finished;
    end;
  end;

  procedure kpCheckForHeader(P : PProtocolData);
    {-Checks for a header}
  const
    CheckLen : array[1..3] of Byte = (3, 4, 5);
  var
    C : AnsiChar;
  begin
    with P^ do begin
      {Assume no header ready}
      aProtocolStatus := psNoHeader;

      {If continuing a previous header we need to restore aBlockCheck}
      if kKermitHeaderState <> hskNone then begin
        aBlockCheck := kSaveCheck;
        kBlockCheck2 := kSaveCheck2;
      end;

      {Process potential header characters}
      while kpCharReady(P) and (kKermitHeaderState <> hskDone) do begin
        C := kpGetChar(P);

        if C = cSoh then
          kKermitHeaderState := hskNone;

        case kKermitHeaderState of
          hskNone :
            if C = cSoh then begin
              kKermitHeaderState := hskGotMark;
              aBlockCheck := 0;
              kBlockCheck2 := 0;
              kLongCheck := 32;
            end;
          hskGotMark :
            begin
              kKermitHeaderState := hskGotLen;
              kpUpdateBlockCheck(P, Byte(C));
              C := UnChar(C);
              kGetLong := (C = #0);
              kRecDataLen := Ord(C);
            end;
          hskGotLen :
            begin
              kKermitHeaderState := hskGotSeq;
              kpUpdateBlockCheck(P, Byte(C));
              Inc(kLongCheck, Byte(C));
              C := UnChar(C);
              kRecBlockNum := Ord(C);
            end;
          hskGotSeq :
            begin
              kPacketType := C;
              kpUpdateBlockCheck(P, Byte(C));
              Inc(kLongCheck, Byte(C));
              if kGetLong then
                kKermitHeaderState := hskGotType
              else
                kKermitHeaderState := hskDone;
            end;
          hskGotType :
            begin
              kKermitHeaderState := hskGotLong1;
              kpUpdateBlockCheck(P, Byte(C));
              Inc(kLongCheck, Byte(C));
              C := UnChar(C);
              kRecDataLen := Cardinal(C)*95;
            end;
          hskGotLong1 :
            begin
              kKermitHeaderState := hskGotLong2;
              kpUpdateBlockCheck(P, Byte(C));
              Inc(kLongCheck, Byte(C));
              C := UnChar(C);
              Inc(kRecDataLen, Byte(C));
            end;
          hskGotLong2 :
            begin
              kKermitHeaderState := hskDone;
              kLongCheck := (kLongCheck + (kLongCheck shr 6)) and $3F;
              kpUpdateBlockCheck(P, Byte(C));
              C := UnChar(C);
              if C = AnsiChar(kLongCheck) then
                aProtocolStatus := psBlockCheckError;
              Inc(kRecDataLen, 2);
            end;
        end;
      end;

      if kKermitHeaderState = hskDone then begin
        {Say we got a header}
        aProtocolStatus := psGotHeader;

        {Account for other extra bytes in length}
        if kCheckKnown then
          Dec(kRecDataLen, (CheckLen[Byte(kKermitOptions.Check)-$30]))
        else
          Dec(kRecDataLen, (CheckLen[1]));
        if Integer(kRecDataLen) < 0 then
          kRecDataLen := 0;
      end else begin
        {Say no header ready}
        aProtocolStatus := psNoHeader;
        kSaveCheck := aBlockCheck;
        kSaveCheck2 := kBlockCheck2;
      end;
    end;
  end;

  function kpNextSeq(P : PProtocolData; I : Integer) : Integer;
    {-Increment I to next slot, accounting for current table size}
  begin
    with P^ do begin
      Inc(I);
      if I > Integer(kTableSize) then
        I := 1;
      kpNextSeq := I;
    end;
  end;

  function kpPrevSeq(P : PProtocolData; I : Integer) : Integer;
    {-Decrement I to previous slot, accounting for current table size}
  begin
    with P^ do begin
      Dec(I);
      if I = 0 then
        I := kTableSize;
      kpPrevSeq := I;
    end;
  end;

  function kpTableFull(P : PProtocolData) : Bool;
    {-Returns True if the send table is full}
  begin
    with P^ do
      kpTableFull := kInfoTable[kpNextSeq(P, kTableHead)].InUse;
  end;

  function kpPacketsOutstanding(P : PProtocolData) : Bool;
    {-True if there are unacked packets in the table}
  var
    I : Integer;
  begin
    with P^ do begin
      kpPacketsOutstanding := True;
      for I := 1 to kTableSize do
        if kInfoTable[I].InUse then
          Exit;
      kpPacketsOutstanding := False;
    end;
  end;

  function kpGetOldestSequence(P : PProtocolData) : Integer;
  var
    I, Oldest : Integer;
  begin
    Oldest := MaxInt;
    with P^ do begin
      for I := 1 to kTableSize do begin
        if kInfoTable[I].InUse and (kInfoTable[I].Seq < Oldest) then
          Oldest := I;
      end;
      if Oldest = MaxInt then
        Result := -1
      else
        Result := kInfoTable[Oldest].Seq;
    end;
  end;

  function kpSeqInTable(P : PProtocolData; CurSeq : Integer) : Integer;
    {-Return the position in the table of CurSeq, or -1 of not found}
  var
    I : Integer;
  begin
    with P^ do begin
      kpSeqInTable := -1;
      for I := 1 to kTableSize do
        if kInfoTable[I].Seq = CurSeq then begin
          kpSeqInTable := I;
          Exit;
        end;
    end;
  end;

  procedure kpGotAck(P : PProtocolData; CurSeq : Cardinal);
    {-Note ACK for block number CurSeq}
  var
    I : Integer;
  begin
    with P^ do begin
      I := kpSeqInTable(P, CurSeq);
      if I <> - 1 then
        kInfoTable[I].InUse := False;
    end;
  end;

  function kpWindowsUsed(P : PProtocolData) : Byte;
    {-Return number of window slots in use}
  var
    I : Integer;
    Cnt : Cardinal;
  begin
    with P^ do begin
      if not kpPacketsOutstanding(P) then begin
        kpWindowsUsed := 0;
        Exit;
      end;

      Cnt := 0;
      for I := 1 to kTableSize do
        if kInfoTable[I].InUse then
          Inc(Cnt);

      kpWindowsUsed := Cnt;
    end;
  end;

  procedure kpWritePacket(P : PProtocolData; Index : Byte);
    {-Expand and write the packet from table slot Index}
  var
    TIndex : Cardinal;
    WIndex : Cardinal;
    LastIndex : Cardinal;
    RepeatCnt : Cardinal;
    Free : Cardinal;
    Left : Cardinal;
    C : AnsiChar;
    Failed : Bool;

    procedure WriteBlock;
    begin
      with P^ do begin
        Failed := apWriteProtocolBlock(P, kWorkBlock^, SizeOf(kWorkBlock^));
        Inc(aFileOfs, SizeOf(kWorkBlock^));
        WIndex := 1;
        Free := SizeOf(kWorkBlock^);
      end;
    end;

  begin
    with P^ do begin
      {Set starting indexes}
      TIndex := Cardinal(Index-1)*aBlockLen;
      LastIndex := Integer(TIndex)+kInfoTable[Index].Len;
      WIndex := 1;

      {Loop through this block in kDataTable...}
      Failed := False;
      repeat
        {Get a character with escaping already translated}
        kpGetDataChar(P, C, TIndex, RepeatCnt);

        if RepeatCnt = 1 then begin
          {Single char, just add it to WorkBlock}
          kWorkBlock^[WIndex] := C;
          Inc(WIndex);
        end else begin
          {Repeating char, start filling aDataBlock(s)}
          Free := SizeOf(kWorkBlock^)-(WIndex-1);
          Left := RepeatCnt;
          repeat
            if Free >= Left then begin
              FillChar(kWorkBlock^[WIndex], Left, C);
              Inc(WIndex, Left);
              Left := 0;
            end else begin
              FillChar(kWorkBlock^[WIndex], Free, C);
              Inc(WIndex, Free);
              Dec(Left, Free);
            end;

            {Flush WorkBlock if it fills}
            if WIndex = SizeOf(kWorkBlock^)+1 then
              WriteBlock;
          until (Left = 0) or Failed;
        end;

        {Flush WorkBlock if it fills}
        if WIndex = SizeOf(kWorkBlock^)+1 then
          WriteBlock;

      until (TIndex = LastIndex) or Failed;

      {Commit last, or only, block}
      if WIndex <> 1 then begin
        Failed := apWriteProtocolBlock(P, kWorkBlock^, WIndex-1);
        Inc(aFileOfs, WIndex-1);
      end;
    end;
  end;

  function kpSeqGreater(P : PProtocolData; Seq1, Seq2 : Byte) : Bool;
    {-Return True if Seq is greater than Seq2, accounting for wrap at 64}
  var
    I : Integer;
  begin
    with P^ do begin
      I := Seq1 - Seq2;
      if I > 0 then
        kpSeqGreater := (I < 32)
      else
        kpSeqGreater := (Abs(I) > 32);
    end;
  end;

  function kpLoSeq(P : PProtocolData) : Byte;
    {-Return sequence number of oldest possible sequence number}
    {-Current Seq - (kTableSize)}
  begin
    with P^ do begin
      {Handle case of no windows}
      if kTableSize = 1 then begin
        kpLoSeq := kRecBlockNum;
        Exit;
      end;

      kpLoSeq := kInfoTable[kTableTail].Seq;
    end;
  end;

  function kpHiSeq(P : PProtocolData) : Byte;
    {-Return sequence number of highest acceptable sequence number}
  var
    I     : Byte;
    Count : Byte;
  begin
    with P^ do begin
      {Handle case of no windows}
      if kTableSize = 1 then begin
        kpHiSeq := kRecBlockNum;
        Exit;
      end;

      {Search backwards counting free (acked) slots}
      I := kpPrevSeq(P, kTableHead);
      Count := 0;
      repeat
        with kInfoTable[I] do
          if Acked or not InUse then
            Inc(Count);
        I := kpPrevSeq(P, I);
      until (I = kTableHead);

      {HiSeq is current sequence number + Count}
      Inc(Count, kRecBlockNum);
      if Count > 64 then
        Dec(Count, 64);
      kpHiSeq := Count;
    end;
  end;

  function kpSeqDiff(P : PProtocolData; Seq1, Seq2 : Byte) : Byte;
    {-Assuming Seq1 > Seq2, return the difference}
  begin
    with P^ do begin
      if Seq1 > Seq2 then
        kpSeqDiff := Seq1-Seq2
      else
        kpSeqDiff := (Seq1+64)-Seq2;
    end;
  end;

  procedure kpAddToTable(P : PProtocolData; Seq : Byte);
    {-Add Seq to proper location in table}
  var
    CurSeq : Byte;
    HeadSeq : Byte;
    I : Cardinal;
    Diff : Cardinal;
  begin
    with P^ do begin
      {Calculate kTableHead value for Seq (range known to be OK)}
      HeadSeq := kInfoTable[kTableHead].Seq;

      if kpSeqGreater(P, Seq, HeadSeq) then begin
        {Incoming packet is new, rotate table, writing old slots as required}
        Diff := kpSeqDiff(P, Seq, HeadSeq);
        for I := 1 to Diff do begin
          kTableHead := kpNextSeq(P, kTableHead);
          if kTableHead = kTableTail then begin
            if kInfoTable[kTableTail].InUse then begin
              kpWritePacket(P, kTableTail);
              kInfoTable[kTableTail].InUse := False;
              kInfoTable[kTableTail].Acked := False;
            end;
            kTableTail := kpNextSeq(P, kTableTail);
          end;
        end;
        I := kTableHead;

      end else begin
        {Incoming packet is a retransmitted packet, find associated table index}
        CurSeq := HeadSeq;
        I := kTableHead;
        while CurSeq <> Seq do begin
          CurSeq := Dec64(CurSeq);
          I := kpPrevSeq(P, I);
        end;
      end;

      {Stuff info table}
      kInfoTable[I].Seq   := Seq;
      kInfoTable[I].Acked := True;
      kInfoTable[I].Len   := kRecDataLen;
      kInfoTable[I].InUse := True;

      {Stuff data table}
      Move(aDataBlock^, kDataTable^[(I-1)*aBlockLen], kRecDataLen);
    end;
  end;

  procedure kpSendNak(P : PProtocolData);
    {-Send an nak packet for packet Seq}
  const
    NakLen = 3;
  begin
    with P^ do begin
      kpPutHeader(P, KNak, NakLen);

      {Put checksum}
      kpSendBlockCheck(P);

      {Put terminator}
      kpSendTerminator(P);
    end;
  end;

  procedure kpSendAck(P : PProtocolData; Seq : Byte);
    {-Send an acknowledge packet for packet Seq}
  const
    AckLen : array[1..3] of Byte = (3, 4, 5);
  var
    B : Byte;
    Save : Byte;
  begin
    with P^ do begin
      B := AckLen[Byte(kKermitOptions.Check)-$30];

      {kpPutHeader uses aBlockNum so we'll need to change it temporarily}
      Save := aBlockNum;
      aBlockNum := Seq;

      kpPutHeader(P, KAck, B);

      {Put checksum}
      kpSendBlockCheck(P);

      {Put terminator}
      kpSendTerminator(P);

      aBlockNum := Save;
    end;
  end;

  function kpDataCount(P : PProtocolData; Index : Byte) : Cardinal;
    {-Count actual data characters in slot Index}
  var
    TIndex : Cardinal;
    DIndex : Cardinal;
    LastIndex : Cardinal;
    RepeatCnt : Cardinal;
    C : AnsiChar;
  begin
    with P^ do begin
      {Set starting indexes}
      TIndex := Cardinal(Index-1)*aBlockLen;
      LastIndex := Integer(TIndex)+kInfoTable[Index].Len;
      DIndex := 1;

      {Loop through this block in kDataTable...}
      repeat
        {Get a character with escaping already translated}
        kpGetDataChar(P, C, TIndex, RepeatCnt);
        Inc(DIndex, RepeatCnt);
      until (TIndex = LastIndex);

      {Commit last, or only, block}
      kpDataCount := DIndex-1;
    end;
  end;

  procedure kpProcessDataPacket(P : PProtocolData);
    {-Process received data packet}
  var
    I : Cardinal;
    Count : Cardinal;
  begin
    with P^ do begin
      aProtocolError := ecOK;

      if (kpSeqGreater(P, kRecBlockNum, kpLoSeq(P)) or (kRecBlockNum = kpLoSeq(P))) and
         (kpSeqGreater(P, kpHiSeq(P), kRecBlockNum) or (kRecBlockNum = kpHiSeq(P))) then begin

        {Acceptable data packet}
        kpAddToTable(P, kRecBlockNum);

        {Exit on errors, will be handled by state machine}
        if aProtocolError <> ecOK then
          Exit;

        {Nak missing packets}
        if kpSeqGreater(P, kRecBlockNum, aBlockNum) then begin
          I := aBlockNum;
          repeat
            kpSendNak(P);
            I := Inc64(I);
          until I = kRecBlockNum;
        end else if kRecBlockNum = aBlockNum then begin
          {Adjust status variables}
          Count := kpDataCount(P, kTableHead);
          Inc(aBytesTransferred, Count);
          Dec(aBytesRemaining, Count);
          aElapsedTicks := ElapsedTime(aTimer);
        end;

        {Ack the packet we got}
        kpSendAck(P, kRecBlockNum);

        {Expect next highest sequence beyond highest table entry}
        aBlockNum := Inc64(kInfoTable[kTableHead].Seq);

      end else begin
        {Unacceptable block number, ignore it}
        aBlockNum := aBlockNum;
      end;
    end;
  end;

  function kpIncTableIndex(P : PProtocolData; Index, Increment : Byte) : Byte;
    {-Increment table index, wrap at table size}
  begin
    with P^ do begin
      Inc(Index, Increment);
      if Index > kTableSize then
        Dec(Index, kTableSize);
      kpIncTableIndex := Index;
    end;
  end;

  procedure kpFlushTableToDisk(P : PProtocolData);
    {-Write all outstanding packets to disk}
  var
    Last, I : Cardinal;
  begin
    with P^ do begin
      Last := kpIncTableIndex(P, kTableHead, 1);
      I := Last;
      repeat
        with kInfoTable[I] do begin
          if InUse then
            if Acked then
              kpWritePacket(P, I)
            else begin
              apProtocolError(P, ecTableFull);
              Exit;
            end;
        end;
        I := kpIncTableIndex(P, I, 1);
      until (I = Last);
    end;
  end;


  procedure kpReceiveBlock(P : PProtocolData);
    {-Get the datafield of a Kermit packet}
  var
    C : AnsiChar;
    Check1 : Cardinal;
    Check2 : Cardinal;
    Check3 : Cardinal;
  label
    ExitPoint;
  begin
    with P^ do begin
      {Get the data block}
      if kRecDataLen > 1024 then
        kRecDataLen := 1024;
      kActualDataLen := kRecDataLen;

      {If continuing a previous block we need to restore aBlockCheck}
      if kBlockIndex <> 1 then begin
        aBlockCheck := kSaveCheck;
        kBlockCheck2 := kSaveCheck2;
      end;

      {Set desired check type}
      if kCheckKnown then
        kTempCheck := kKermitOptions.Check
      else
        kTempCheck := '1';

      while kpCharReady(P) do begin
        C := kpGetChar(P);

        case kKermitDataState of
          dskData :
            begin
              aDataBlock^[kBlockIndex] := C;
              kpUpdateBlockCheck(P, Byte(C));
              Inc(kBlockIndex);
              if kBlockIndex > kRecDataLen then begin
                kKermitDataState := dskCheck1;
              end;
            end;
          dskCheck1 :
            begin
              kC1 := UnChar(C);
              if kTempCheck = '1' then begin
                Check1 := Lo(aBlockCheck);
                Check1 := (Check1 + (Check1 shr 6)) and $3F;
                if Check1 <> Byte(kC1) then
                  aProtocolStatus := psBlockCheckError
                else
                  aProtocolStatus := psGotData;
                Exit;
              end else
                kKermitDataState := dskCheck2;
            end;
          dskCheck2 :
            begin
              kC2 := UnChar(C);
              if kTempCheck = '2' then begin
                {1st byte has bits 11-6}
                Check1 := (aBlockCheck shr 6) and $3F;
                {Second byte has bits 5-0}
                Check2 := aBlockCheck and $3F;
                if (Check1 <> Byte(kC1)) or (Check2 <> Byte(kC2)) then
                  aProtocolStatus := psBlockCheckError
                else
                  aProtocolStatus := psGotData;
                Exit;
              end else
                kKermitDataState := dskCheck3;
            end;
          dskCheck3 :
            begin
              kC3 := UnChar(C);
              Check1 := (kBlockCheck2 shr 12) and $0F;
              Check2 := (kBlockCheck2 shr 6) and $3F;
              Check3 := kBlockCheck2 and $3F;
              if (Check1 <> Byte(kC1)) or
                 (Check2 <> Byte(kC2)) or
                 (Check3 <> Byte(kC3)) then
                aProtocolStatus := psBlockCheckError
              else
                aProtocolStatus := psGotData;
              Exit;
            end;
        end;
      end;

      {If we exit this way we don't have a data block yet}
      aProtocolStatus := psNoData;
      kSaveCheck := aBlockCheck;
      kSaveCheck2 := kBlockCheck2;
    end;
  end;

  procedure kpExpandFileInfo(P : PProtocolData);
    {Un-escapes file info }
  var
    ExName : PDataBlock;
    Index, NIndex : Cardinal;
    Repeating : Boolean;
    RepeatCount : Integer;
    C : AnsiChar;
  begin
    with P^ do begin
      ExName := AllocMem(SizeOf(TDataBlock));
      FillChar(ExName^[1], SizeOf(ExName^), #0);
      Repeating := False;
      RepeatCount := 0;
      Index := 1;
      NIndex := 1;
      repeat
        C := aDataBlock^[Index];
        if Repeating then begin
          if RepeatCount = 0 then begin
            if C = kKermitOptions.CtlPrefix then begin
              { the repeat char is a literal char }
              ExName^[NIndex] := C;
              inc(NIndex);
            end else
              { get the number of times to repeat the next char }
              RepeatCount := Ord(C) - 32
           end else begin
            { repeat the current char }
            FillChar(ExName^[NIndex], RepeatCount, C);
            inc(NIndex, RepeatCount);
            RepeatCount := 0;
            Repeating := False;
          end
        end else if C = kKermitOptions.RepeatPrefix then
          { see if this is a repeat char prefix }
          Repeating := True
        else begin
          { just a regular char }
          ExName^[NIndex] := C;
          inc(NIndex);
        end;
        inc(Index);
      until Index > kActualDataLen;
      { initialize aDataBlock }
      FillChar(aDataBlock^[1], SizeOf(aDataBlock^), #0);
      { mode the unescaped file info to aDataBlock }
      Move(ExName^[1], aDataBlock^[1], NIndex);
      kActualDataLen := NIndex;
    end;
    FreeMem(ExName, SizeOf(TDataBlock));
  end;

  procedure kpExtractFileInfo(P : PProtocolData);
    {-Extracts the file name from the aDatablock}
  var
    S    : string[fsPathname];
    Name : string[fsName];
    NameExt : array[0..fsName] of AnsiChar;
  begin
    with P^ do begin
      kpExpandFileInfo(P);
      if kActualDataLen <= 255 then begin
        Move(aDataBlock^[1], aPathname[0], kActualDataLen);
        aPathname[kActualDataLen] := #0;
      end else begin
        Move(aDataBlock^[1], aPathname[0], SizeOf(aPathName));
        aPathname[fsPathName] := #0;
      end;

      {Should we use its directory or ours?}
      if not FlagIsSet(aFlags, apHonorDirectory) then begin
        S := AnsiStrings.StrPas(aPathname);
        Name := ShortString(ExtractFileName(string(S)));
        AnsiStrings.StrPCopy(NameExt, Name);
        AddBackSlashZ(aPathName, aDestDir);
        AnsiStrings.StrLCat(aPathName, NameExt, SizeOf(aPathName));
      end;
    end;
  end;

  procedure kpSendInitialize(P : PProtocolData);
    {-Send our SendInit packet and get a response}
  const
    StdHdrLen = 13;
  var
    kSaveCheckChar : AnsiChar;
  begin
    with P^ do begin
      {Send the header}
      kpPutHeader(P, KSendInit, StdHdrLen+3);

      with kKermitOptions do begin
        {Flush input buffer in preparation for reply}
        kpFlushInBuffer(P);

        WindowSize := WindowSize and $1F;
        {Send the data bytes for the Send Initialize packet}
        kpPutToChar(P, AnsiChar(MaxPacketLen));
        kpPutToChar(P, AnsiChar(MaxTimeout));
        kpPutToChar(P, AnsiChar(PadCount));
        aHC.PutChar(Ctl(PadChar));
        kpPutToChar(P, Terminator);
        aHC.PutChar(CtlPrefix);
        aHC.PutChar(HibitPrefix);
        aHC.PutChar(Check);
        aHC.PutChar(RepeatPrefix);
        kpPutToChar(P, AnsiChar(CapabilitiesMask));
        kpPutToChar(P, AnsiChar(WindowSize));
        kpPutToChar(P, AnsiChar(MaxLongPacketLen div 95));
        kpPutToChar(P, AnsiChar(MaxLongPacketLen mod 95));

        {Always use 1-byte checksum for SendInit packets}
        kSaveCheckChar := Check;
        Check := '1';

        {Update the check value}
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(MaxPacketLen))));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(MaxTimeout))));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(PadCount))));
        kpUpdateBlockCheck(P, Byte(Ctl(PadChar)));
        kpUpdateBlockCheck(P, Byte(ToChar(Terminator)));
        kpUpdateBlockCheck(P, Byte(CtlPrefix));
        kpUpdateBlockCheck(P, Byte(HibitPrefix));
        kpUpdateBlockCheck(P, Byte(kSaveCheckChar));
        kpUpdateBlockCheck(P, Byte(RepeatPrefix));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(CapabilitiesMask))));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(WindowSize))));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(MaxLongPacketLen div 95))));
        kpUpdateBlockCheck(P, Byte(ToChar(AnsiChar(MaxLongPacketLen mod 95))));

        {Send the check value and terminator}
        kpSendBlockCheck(P);
        kpSendTerminator(P);

        {Restore the desired check type}
        Check := kSaveCheckChar;
      end;
    end;
  end;

  procedure kpSendDataPacket(P : PProtocolData; Slot : Cardinal);
    {-Send the prepared data packet in kDataTable[Slot]}
  var
    SaveBlockNum : Cardinal;
  begin
    with P^ do begin
      {Move data from table to aDataBlock}
      kDataLen := kInfoTable[Slot].Len;
      Move(kDataTable^[(Slot-1)*aBlockLen], aDataBlock^, kDataLen);

      {Send the packet}
      SaveBlockNum := aBlockNum;
      aBlockNum := kInfoTable[Slot].Seq;
      kpSendPacket(P, KData);
      aBlockNum := SaveBlockNum;
    end;
  end;

  procedure kpResendDataPacket(P : PProtocolData; Seq : Integer);
    {-Resend a data packet}
  var
    I : Cardinal;
    SaveBlockNum : Cardinal;
  begin
    with P^ do begin
      {Find our sequence in the table}
      for I := 1 to kTableSize do
        if kInfoTable[I].Seq = Seq then
          Break;
      {Move data from Table to a DataBlock}
      kDataLen := kInfoTable[I].Len;
      Move(kDataTable^[(I-1)*aBlockLen], aDataBlock^, kDataLen);

      {Send the packet}
      SaveBlockNum := aBlockNum;
      aBlockNum := kINfoTable[I].Seq;
      kpSendPacket(P, kData);
      aBlockNum := SaveBlockNum;
    end;
  end;

  procedure kpSendFilePacket(P : PProtocolData);
    {-Fill in the Data field with Pathname and send a file packet}
  var
    S : TCharArray;
  begin
    with P^ do begin
      {Send the data field}
      if FlagIsSet(aFlags, apIncludeDirectory) then
        AnsiStrings.StrCopy(S, aPathname)
      else
        JustFileNameZ(S, aPathname);
      kDataLen := AnsiStrings.StrLen(S);

      {Truncate if aPathname is a long filename greater than blocksize}
      if kDataLen > aBlockLen then
        kDataLen := aBlockLen;

      Move(S[0], aDataBlock^[1], kDataLen);
      kpSendPacket(P, KFile);
    end;
  end;

  procedure kpProcessOptions(P : PProtocolData);
    {-Save the just-received options}
  var
    Tmp : Byte;
    LBLen : Cardinal;
    NewTableSize : Cardinal;
    NewaBlockLen : Cardinal;
  begin
    with P^ do begin
      aProtocolError := ecOK;

      {Move defaults in}
      kUsingRepeat := False;
      kUsingHibit := False;
      kRmtKermitOptions := MissingKermitOptions;

      {Override the defaults where specified}
      Move (aDataBlock^[1], kRmtKermitOptions,
            SizeOf(kRmtKermitOptions));

      {Limit the block size, if requested}
      if kRmtKermitOptions.MaxPacketLen < kKermitOptions.MaxPacketLen then
        kKermitOptions.MaxPacketLen := kRmtKermitOptions.MaxPacketLen;

      {Set repeat option if both sides are asking for it}
      Tmp := Byte(kRmtKermitOptions.RepeatPrefix);
      if (AnsiChar(Tmp) = kKermitOptions.RepeatPrefix) and
         (((Tmp > 32) and (Tmp < 63)) or ((Tmp > 95) and (Tmp < 127))) then
        kUsingRepeat := True;

      {Set hibit quoting option if either side asks for it}
      Tmp := Byte(kRmtKermitOptions.HibitPrefix);
      if ((Tmp > 32) and (Tmp < 63)) or ((Tmp > 95) and (Tmp < 127)) then begin
        kUsingHibit := True;
        kKermitOptions.HibitPrefix := kRmtKermitOptions.HibitPrefix;
      end;
      if not kUsingHibit then begin
        Tmp := Byte(kKermitOptions.HibitPrefix);
        {if we want it, and the remote said he can do it if requested, turn it on}
        if ((Tmp > 32) and (Tmp < 63)) or ((Tmp > 95) and (Tmp < 127)) then
          if kRmtKermitOptions.HibitPrefix = 'Y' then
            kUsingHibit := True;
      end;

      {Set long packets if sender asks and we allow}
      if (Byte(kRmtKermitOptions.CapabilitiesMask) and LongPackets <> 0) and
         (FlagIsSet(aFlags, apKermitLongPackets)) then begin
        kKermitOptions.CapabilitiesMask :=
          kKermitOptions.CapabilitiesMask or LongPackets;
        LBLen := Cardinal(Byte(UnChar(aDataBlock^[MaxLx1])) * 95) +
                     (Byte(UnChar(aDataBlock^[MaxLx2])));
        if LBLen = 0 then
          kKermitOptions.MaxLongPacketLen := kKermitOptions.MaxPacketLen
        else if (LBLen > 0) and (LBLen <= 1024) then
          kKermitOptions.MaxLongPacketLen := LBLen
        else
          kKermitOptions.MaxLongPacketLen := 500;
        kLPInUse := True;
      end;

      {Set SWC if sender asks and we allow}
      NewTableSize := kTableSize;
      if (Byte(kRmtKermitOptions.CapabilitiesMask) and SlidingWindows <> 0) and
         (FlagIsSet(aFlags, apKermitSWC)) then begin
        kKermitOptions.CapabilitiesMask :=
          kKermitOptions.CapabilitiesMask or SlidingWindows;
        {If remote's window size is less than ours then use its size}
        Tmp := kRmtKermitOptions.WindowSize and $1F;
        if Tmp < kKermitOptions.WindowSize then begin
          kKermitOptions.WindowSize := Tmp;
          NewTableSize := Tmp;
        end;
      end else begin
        NewTableSize := 1;
        kKermitOptions.WindowSize := 1;
      end;

      if kKermitState = rkCollectInit then
        {We're receiving, use whatever block check type sender asks for}
        if (kRmtKermitOptions.Check >= '1') and
           (kRmtKermitOptions.Check <= '3') then
          kKermitOptions.Check := kRmtKermitOptions.Check
      else
        {We're transmitting, agree on check type or force '1'}
        if kKermitOptions.Check <> kRmtKermitOptions.Check then
          kKermitOptions.Check := '1';
      aCheckType := CheckVal[Byte(kKermitOptions.Check)-$30];

      {Set status and other options}
      with kKermitOptions do begin
        if kLPInUse then
          NewaBlockLen := MaxLongPacketLen
        else
          NewaBlockLen := MaxPacketLen;
        if NewTableSize > 1 then
          aTurnDelay := kSWCTurnDelay
        {else}
          {aTurnDelay := KermitTurnDelay;}
      end;

      {Allocate new kDataTable to account for changes in aBlockLen/window count}
      if (NewTableSize <> kTableSize) or (NewaBlockLen <> aBlockLen) then begin
        kpDeallocateWindowTable(P);
        kTableSize := NewTableSize;
        aBlockLen := NewaBlockLen;
        kpAllocateWindowTable(P);
      end;
    end;
  end;

  procedure kpSendOptions(P : PProtocolData);
    {-Send our options}
  var
    TotalLen : Byte;
  begin
    with P^ do begin
      Move(kKermitOptions, aDataBlock^[1], MaxKermitOption);
      aDataBlock^[12] := AnsiChar(kKermitOptions.MaxLongPacketLen div 95);
      aDataBlock^[13] := AnsiChar(kKermitOptions.MaxLongPacketLen mod 95);
      TotalLen := MaxKermitOption+3;

      {Can't use SendAck so we'll do everything here}
      kpPutHeader(P, KAck, TotalLen);

      {Put each option, transforming as required}
      kpPutToChar(P, aDataBlock^[1]);                             {MaxL}
      kpUpdateBlockCheck(P, Byte(ToChar(aDataBlock^[1])));
      kpPutToChar(P, aDataBlock^[2]);                             {Time}
      kpUpdateBlockCheck(P, Byte(ToChar(aDataBlock^[2])));
      kpPutToChar(P, aDataBlock^[3]);                             {NPad}
      kpUpdateBlockCheck(P, Byte(ToChar(aDataBlock^[3])));
      aHC.PutChar(Ctl(aDataBlock^[4]));                          {PadC}
      kpUpdateBlockCheck(P, Byte(Ctl(aDataBlock^[4])));
      kpPutToChar(P, aDataBlock^[5]);                             {EOL}
      kpUpdateBlockCheck(P, Byte(ToChar(aDataBlock^[5])));
      aHC.PutChar(aDataBlock^[6]);                               {QCtl}
      kpUpdateBlockCheck(P, Byte(aDataBlock^[6]));
      aHC.PutChar(aDataBlock^[7]);                               {QBin}
      kpUpdateBlockCheck(P, Byte(aDataBlock^[7]));
      aHC.PutChar(aDataBlock^[8]);                               {Chkt}
      kpUpdateBlockCheck(P, Byte(aDataBlock^[8]));
      aHC.PutChar(aDataBlock^[9]);                               {Rept}
      kpUpdateBlockCheck(P, Byte(aDataBlock^[9]));
      kpPutToChar(P, aDataBlock^[10]);                            {Capas}
      kpUpdateBlockCheck(P, Byte(ToChar(aDataBlock^[10])));
      kpPutToChar(P, aDataBlock^[11]);                            {Windo}
      kpUpdateBlockCheck(P, Byte(ToChar(aDataBlock^[11])));
      kpPutToChar(P, aDataBlock^[12]);                            {MaxLx1}
      kpUpdateBlockCheck(P, Byte(ToChar(aDataBlock^[12])));
      kpPutToChar(P, aDataBlock^[13]);                            {MaxLx2}
      kpUpdateBlockCheck(P, Byte(ToChar(aDataBlock^[13])));

      {Put checksum and terminator}
      kpSendBlockCheck(P);
      kpSendTerminator(P);

      {Check type has been decided upon}
      kCheckKnown := True;
    end;
  end;

  function kpCheckRetries(P : PProtocolData) : Bool;
    {-Increments retry count, returns True if greater than aHandshakeRetry}
  var
    Failed : Boolean;
  begin
    with P^ do begin
      aForceStatus := True;

      {Exit if an abort is pending}
      if aProtocolStatus = psCancelRequested then
        kpCheckRetries := True
      else begin
        Inc(aBlockErrors);
        Inc(aTotalErrors);
        Failed := aBlockErrors > aHandshakeRetry;
        if Failed then begin
          if aProtocolError = ecOK then
            aProtocolError := ecProtocolError;
          apProtocolError(P, aProtocolError);
        end;
        kpCheckRetries := Failed;
      end;
    end;
  end;

  procedure kpLoadTransmitData(P : PProtocolData);
    {-Escapes data from WorkBlock into DataBlock}
  label
    Skip;
  const
    SafetyMargin = 5;
  var
    WIndex : Cardinal;
    DIndex : Cardinal;
    RIndex : Cardinal;
    RepeatCnt : Cardinal;
    C : AnsiChar;
    ByteCnt : Cardinal;

    function Repeating(C : AnsiChar; var Cnt : Cardinal) : Bool;
      {Returns True (and new index) if repeat C's are found}
    const
      MaxRpt = 94;  {Per Kermit Protocol Manual}
    var
      Index : Cardinal;
    begin
      with P^ do begin
        Index := WIndex;
        Cnt := 1;

        {Loop while next chars are the same as C}
        while (Index <= kWorkLen) and
              (kWorkBlock^[Index] = C) and
              (Cnt < MaxRpt) do begin
          Inc(Cnt);
          Inc(Index);
        end;

        {Set function result (Cnt already has repeat count)}
        Repeating := Cnt > kMinRepeatCnt;
      end;
    end;

    function ReloadWorkBlock : Bool;
      {-Reloads WorkBlock if required -- Return False to Exit}
    begin
      with P^ do begin
        ReloadWorkBlock := False;
        if kWorkEndPending and (WIndex > kWorkLen) then
          Exit;

        {Reload WorkBlock as needed}
        if (WIndex > SizeOf(kWorkBlock^)) then begin
          kWorkLen := SizeOf(kWorkBlock^);
          kWorkEndPending := apReadProtocolBlock(P, kWorkBlock^, kWorkLen);

          {Finished if no more bytes read}
          if kWorkEndPending and (kWorkLen = 0) then
            Exit;

          if aProtocolError = ecOK then begin
            WIndex := 1;
            Inc(aFileOfs, kWorkLen);
          end else begin
            kpCancel(P);
            Exit;
          end;
        end;

        {If we get here, block was reloaded ok or didn't need reload}
        ReloadWorkBlock := True;
      end;
    end;

  begin
    with P^ do begin
      {Exit immediately if no more DataBlocks to send}
      if (kWorkEndPending) and (kLastWorkIndex > kWorkLen) then begin
        aProtocolStatus := psEndFile;
        Exit;
      end;

      with kKermitOptions do begin
        WIndex := kLastWorkIndex;
        DIndex := 1;
        ByteCnt := 0;

        if kLPInUse then
          RIndex := kKermitOptions.MaxLongPacketLen - SafetyMargin
        else
          RIndex := kKermitOptions.MaxPacketLen - SafetyMargin;

        while DIndex < RIndex do begin
          {C is the next character to move}
          C := kWorkBlock^[WIndex];
          Inc(WIndex);
          Inc(ByteCnt);

          {Look ahead for repeating Char sequence}
          if kUsingRepeat then
            if Repeating(C, RepeatCnt) then begin
              {C is a repeating char, add repeat prefix and count}
              aDataBlock^[DIndex] := RepeatPrefix;
              aDataBlock^[DIndex+1] := ToChar(AnsiChar(RepeatCnt));
              Inc(DIndex, 2);
              Inc(WIndex, RepeatCnt-1);
              Inc(ByteCnt, RepeatCnt-1);
            end;

          {Process all escaping conditions}
          if kUsingHibit then begin
            if (C = HibitPrefix) or (C = AnsiChar(Byte(HibitPrefix) or $80)) then begin
              if IsHibit(C) then begin
                aDataBlock^[DIndex] := HibitPrefix;
                Inc(DIndex);
              end;
              aDataBlock^[DIndex] := CtlPrefix;
              aDataBlock^[DIndex+1] := HibitPrefix;
              Inc(Dindex,2);
              goto Skip;
            end else if IsHibit(C) then begin
              C := AnsiChar(Byte(C) and $7F);
              aDataBlock^[DIndex] := HibitPrefix;
              Inc(DIndex);
            end;
          end;

          if IsCtl(C) then begin
            {C is a control character, add prefix and modified C}
            aDataBlock^[DIndex] := CtlPrefix;
            aDataBlock^[DIndex+1] := Ctl(C);
            Inc(DIndex, 2);
          end else if (C = CtlPrefix) or (C = HiBit(CtlPrefix)) then begin
            {C is the prefix char, add prefix and normal CtlPrefix char}
            aDataBlock^[DIndex] := CtlPrefix;
            aDataBlock^[DIndex+1] := C;
            Inc(DIndex, 2);
          end else if kUsingRepeat and
            ((C = RepeatPrefix) or (C = Hibit(RepeatPrefix))) then begin
            {C is repeat prefix char, add prefix and normal RepeatPrefix char}
            aDataBlock^[DIndex] := CtlPrefix;
            aDataBlock^[Dindex+1] := C;
            Inc(DIndex, 2);
          end else begin
            {Normal, single, unescaped character}
            aDataBlock^[DIndex] := C;
            Inc(DIndex);
          end;

Skip:
          {Check if WorkBlock should be reloaded}
          if not ReloadWorkBlock then begin
            kDataLen := DIndex - 1;
            Dec(aBytesRemaining, ByteCnt);
            Inc(aBytesTransferred, ByteCnt);
            aElapsedTicks := ElapsedTime(aTimer);
            kLastWorkIndex := WIndex;
            Exit;
          end;
        end;

        kDataLen := DIndex - 1;
        Dec(aBytesRemaining, ByteCnt);
        Inc(aBytesTransferred, ByteCnt);
        aElapsedTicks := ElapsedTime(aTimer);
        kLastWorkIndex := WIndex;
      end;
    end;
  end;

  procedure kpOpenFile(P : PProtocolData);
    {-Open file from data in just received file packet}
  begin
    with P^ do begin
      {Assume error}
      kKermitState := rkError;

      {Get info from file packet}
      kpExtractFileInfo(P);

      {Send file name to user's LogFile procedure}
      apLogFile(P, lfReceiveStart);

      {Accept this file?}
      kSkipped := False;
      if not apAcceptFile(P, aPathname) then begin
        aProtocolStatus := psFileRejected;
        aForceStatus := True;
        kpCancel(P);
        kSkipped := True;
        Exit;
      end;

      {Reset status stuff}
      aFileOfs := 0;
      aBlockNum := Inc64(kRecBlockNum);
      aBlockErrors := 0;
      NewTimer(aTimer, 1);
      aTimerStarted := False;
      aBytesRemaining := 0;
      aBytesTransferred := 0;
      aTotalErrors := 0;
      aSrcFileLen := 0;

      {Prepare to write to file}
      aProtocolError := ecOK;
      apPrepareWriting(P);
      if (aProtocolError = ecOK) and
         (aProtocolStatus <> psCantWriteFile) then begin
        {File opened OK}
        kReceiveInProgress := True;
        kpSendAck(P, kRecBlockNum);

        {Init sequence}
        kTableHead := 1;
        kTableTail := 1;
        FillChar(kInfoTable, SizeOf(kInfoTable), 0);
        kInfoTable[1].Seq := kRecBlockNum;

        {Set next state}
        kKermitState := rkGetData;
        aHC.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
      end else begin
        {Error opening/creating file, tell remote we're aborting}
        if aProtocolStatus <> psCantWriteFile then
          aProtocolError := ecCantWriteFile;
        kpSendError(P, eFileError);
        kKermitState := rkError;
      end;
    end;
  end;

  procedure kpPrepareReceive(P : PProtocolData);
    {-Prepare to start receiving}
  begin
    with P^ do begin
      aSaveStatus := psOK;
      aBlockNum := 0;
      kReceiveInProgress := False;
      kTransmitInProgress := False;
      aBytesRemaining := 0;
      aBytesTransferred := 0;
      aTotalErrors := 0;
      aForceStatus := True;
      kKermitState := rkInit;
      kKermitHeaderState := hskNone;
      FillChar(kInfoTable, SizeOf(kInfoTable), 0);
      aElapsedTicks := 0;
      kpResetStatus(P);
      aProtocolStatus := psProtocolHandshake;
      apShowFirstStatus(P);
      kTableHead := 1;
      kTableTail := 1;
      aTimerStarted := False;
      kCheckKnown := False;
    end;
  end;

  procedure kpReceive(Msg, wParam : Cardinal;
                     lParam : Integer);
    {-Performs one increment of a Kermit receive}
  label
    ExitPoint;
  var
    TriggerID   : Cardinal absolute wParam;
    P           : PProtocolData;
    Finished    : Bool;
    StatusTicks : Integer;
    Dispatcher      : TApdBaseDispatcher;
  begin
    Finished := False;                                                 {!!.01}
    try                                                                {!!.01}
      {Get the protocol pointer from data pointer 1}
      Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
      with Dispatcher do
        GetDataPointer(Pointer(P), 1);
    except                                                             {!!.01}
      on EAccessViolation do                                           {!!.01}
        { No access to P^, just exit }                                 {!!.01}
        Exit;                                                          {!!.01}
    end;                                                               {!!.01}

    with P^ do begin
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if kKermitState = rkDone then begin
        LeaveCriticalSection(aProtSection);
        Exit;
      end;
        {Force TriggerID for TriggerAvail messages}
        if Msg = apw_TriggerAvail then begin
          kpFillInBuff(P);
          TriggerID := aDataTrigger;
        end;

        repeat
          try                                                          {!!.01}
            if Dispatcher.Logging then
              Dispatcher.AddDispatchEntry(
                dtKermit,LogKermitState[kKermitState],0,nil,0);


            {rkDone could arrive with the trailing padding and CR}
            if kKermitState = rkDone then begin
              while kpCharReady(P) do
                kpGetChar(P);
              LeaveCriticalSection(aProtSection);
              Exit;
            end;

            {Restore last status}
            aProtocolStatus := aSaveStatus;

            {Check for user abort}
            if aSaveStatus <> psCancelRequested then begin
              if Integer(TriggerID) = aNoCarrierTrigger then begin
                aProtocolStatus := psAbortNoCarrier;
                kKermitState := rkError;
              end;
              if Msg = apw_ProtocolCancel then begin
                kpCancel(P);
                kKermitState := rkError;
              end;
            end;

            {Show status at requested intervals and after significant events}
            if aForceStatus or (Integer(TriggerID) = aStatusTrigger) then begin
              if Dispatcher.TimerTicksRemaining(aStatusTrigger,
                                      StatusTicks) <> 0 then
                StatusTicks := 0;
              if StatusTicks <= 0 then begin
                apShowStatus(P, 0);
                Dispatcher.SetTimerTrigger(aStatusTrigger, aStatusInterval, True);
                aForceStatus := False;
              end;
              if Integer(TriggerID) = aStatusTrigger then begin
                LeaveCriticalSection(aProtSection);
                Exit;
              end;
            end;

            {Preprocess incoming headers}
            case kKermitState of
              rkGetInit,
              rkGetFile,
              rkGetData :
                if TriggerID = aDataTrigger then begin
                  {Header might be present, try to get one}
                  kpCheckForHeader(P);
                  case aProtocolStatus of
                    psOK, psNoHeader, psGotHeader : ;
                    else if kpCheckRetries(P) then
                      kKermitState := rkError;
                  end;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout while waiting for header}
                  if kpCheckRetries(P) then
                    {Fatal error if too many retries}
                    kKermitState := rkError
                  else
                    {Let state machine take apropriate recovery action}
                    aProtocolStatus := psTimeout;
                end else
                  {Indicate that we don't have a header yet}
                  aProtocolStatus := psNoHeader;
            end;

            {Preprocess incoming datapackets}
            case kKermitState of
              rkCollectInit,
              rkCollectFile,
              rkCollectData :
                if TriggerID = aDataTrigger then begin
                  kpReceiveBlock(P);
                  case aProtocolStatus of
                    psOK, psNoData, psGotData : ;
                    else begin
                      aForceStatus := True;
                      if kpCheckRetries(P) then
                        kKermitState := rkError
                    end;
                  end;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout waiting for datapacket}
                  aForceStatus := True;
                  if kpCheckRetries(P) then
                    {Fatal error if too many retries}
                    kKermitState := rkError
                  else
                    {Let state machine take apropriate recovery action}
                    aProtocolStatus := psTimeout;
                end else
                  aProtocolStatus := psNoData;
            end;

            {Main state processor}
            case kKermitState of
              rkInit :
                begin
                  aBlockNum := 0;

                  {Wait for SendInit packet}
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  kKermitState := rkGetInit;
                  kRecDataLen := 0;
                end;

              rkGetInit :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      kKermitState := rkCollectInit;
                      kKermitDataState := FirstDataState[kRecDataLen=0];
                      kBlockIndex := 1;
                    end;
                  psNoheader :
                    {Keep waiting};
                  else
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end;

              rkCollectInit :
                case aProtocolStatus of
                  psGotData :
                    case kPacketType of
                      KSendInit :
                        begin
                          kpProcessOptions(P);
                          if aProtocolError <> ecOK then
                            {if we have an error with the KSendInit packet, the}
                            {other side may be giving us a 1-byte checksum}
                            if aBlockCheck = Ord(kC1) then
                              aProtocolError := ecOK;
                          if aProtocolError = ecOK then begin
                            kpSendOptions(P);
                            aBlockErrors := 0;
                            kKermitState := rkGetFile;
                            Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                          end else begin
                            kKermitState := rkError;
                            {force a 1-byte checksum since we got an error}
                            kCheckKnown := False;
                          end;
                        end;
                      KError :
                        kKermitState := rkError;
                      else begin
                        kKermitState := rkGetInit;
                        Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                      end;
                    end;
                  psNoData :
                    {Keep waiting for data};
                  else begin
                    {Timeout or other error, retry}
                    kKermitState := rkGetInit;
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  end;
                end;

              rkGetFile :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      kKermitState := rkCollectFile;
                      kKermitDataState := FirstDataState[kRecDataLen=0];
                      kBlockIndex := 1;
                    end;
                  psNoheader :
                    {Keep waiting};
                  else
                    kpSendNak(P);
                end;

              rkCollectFile :
                case aProtocolStatus of
                  psGotData :
                    case kPacketType of
                      KFile :     {Open/create the file}
                        kpOpenFile(P);
                      KSendInit : {Got another SendInit, process again}
                        begin
                          kpProcessOptions(P);
                          if aProtocolError = ecOK then begin
                            kpSendOptions(P);
                            aBlockErrors := 0;
                            kKermitState := rkGetFile;
                          end else begin
                            kKermitState := rkError;
                            kCheckKnown := False;
                          end;
                        end;
                      KDisplay : {Ignore}
                        ;
                      KBreak : {Got break, protocol transfer is finished}
                        begin
                          kpSendAck(P, kRecBlockNum);
                          kKermitState := rkComplete;
                        end;
                      KEndOfFile :  {Got out of place end of file header}
                        begin
                          kpSendAck(P, kRecBlockNum);
                          if kpCheckRetries(P) then begin
                            kpSendError(P, eSync);
                            kKermitState := rkError;
                          end;
                          kKermitState := rkGetFile;
                        end;
                      else
                        kKermitState := rkError;
                    end;
                  psNoData :
                    {Keep waiting for data};
                  else
                    {Timeout or other error, retry}
                    kKermitState := rkGetFile;
                    kpSendNak(P);
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end;

              rkGetData :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      kKermitState := rkCollectData;
                      kKermitDataState := FirstDataState[kRecDataLen=0];
                      kBlockIndex := 1;
                    end;
                  psNoheader :
                    {Keep waiting};
                  else
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end;

              rkCollectData :
                case aProtocolStatus of
                  psGotData :
                    case kPacketType of
                      KData : {Got data packet}
                        begin
                          aForceStatus := True;
                          kpProcessDataPacket(P);
                          if aProtocolError = ecOK then begin
                            aBlockErrors := 0;
                            kKermitState := rkGetData;
                            Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                          end else begin
                            kpCancel(P);
                            kKermitState := rkError;
                          end;
                        end;
                      KEndOfFile :
                        if (kActualDataLen > 1) and
                           (aDataBlock^[1] = DiscardChar) then begin
                          kKermitState := rkError;
                          aProtocolStatus := psCancelRequested;
                        end else begin
                          kpFlushTableToDisk(P);
                          if aProtocolError = ecOK then begin
                            apFinishWriting(P);
                            if aProtocolError = ecOK then begin
                              apLogFile(P, lfReceiveOk);
                              kReceiveInProgress := False;
                              kpSendAck(P, kRecBlockNum);
                              aBlockNum := kpNextSeq(P, kRecBlockNum);
                              aBlockErrors := 0;
                              kKermitState := rkGetFile;
                              aTimerStarted := False;
                            end else begin
                              kpCancel(P);
                              kKermitState := rkError;
                            end;
                          end else begin
                            kpCancel(P);
                            kKermitState := rkError;
                          end;
                        end;
                      KFile :
                        begin
                          kpSendAck(P, kRecBlockNum);
                          if kpCheckRetries(P) then begin
                            kpSendError(P, eSync);
                            kKermitState := rkError;
                          end else
                            Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                        end;
                    end;
                  psNoData :
                    {Keep waiting for data};

                  else begin
                    {NAK if not using Windows (window logic will NAK later)}
                    if kTableSize = 1 then
                      kpSendNak(P);
                    kKermitState := rkGetData;
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  end;
                end;

              rkWaitCancel :
                if (Integer(TriggerID) = aTimeoutTrigger) or
                   (Integer(TriggerID) = aOutBuffUsedTrigger) then
                 kKermitState := rkError;

              rkError :
                begin
                  apFinishWriting(P);
                  if kSkipped then
                    apLogFile(P, lfReceiveSkip)
                  else
                    apLogFile(P, lfReceiveFail);
                  kpFlushInBuffer(P);
                  kKermitState := rkComplete;
                end;

              rkComplete :
                begin
                  kKermitState := rkDone;
                  apShowLastStatus(P);

                  {Remove our triggers, restore old triggers}
                  kpFlushInBuffer(P);
                  apSignalFinish(P);
                end;
            end;

            {Reset header state after complete headers}
            if aProtocolStatus = psGotHeader then
              kKermitHeaderState := hskNone;

            {Reset status for various conditions}
            case aProtocolStatus of
              psGotHeader, psNoHeader, psGotData, psNoData :
                aProtocolStatus := psOK;
            end;

            {Save last status value}
            aSaveStatus := aProtocolStatus;

            {Stay in state machine or exit}
            case kKermitState of
              {Stay in state machine if more data ready}
              rkGetInit,
              rkCollectInit,
              rkGetFile,
              rkCollectFile,
              rkGetData,
              rkCollectData,
              rkWaitCancel  : Finished := not kpCharReady(P);


              {Stay in state machine for these interim states}
              rkInit,
              rkComplete,
              rkError       : Finished := False;

              {Done state}
              rkDone        : Finished := True;
              else            Finished := True;
            end;

            {If staying in state machine force data ready}
            TriggerID := aDataTrigger;
          except                                                       {!!.01}
            on EAccessViolation do begin                               {!!.01}
              Finished := True;                                        {!!.01}
              aProtocolError := ecAbortNoCarrier;                      {!!.01}
              apSignalFinish(P);                                       {!!.01}
            end;                                                       {!!.01}
          end;                                                         {!!.01}
        until Finished;
      LeaveCriticalSection(P^.aProtSection);                         {!!.01}
    end;

  end;

  procedure kpPrepareTransmit(P : PProtocolData);
    {-Prepare to start transmitting}
  begin
    with P^ do begin
      aSaveStatus := psOK;
      aBlockNum := 0;
      kReceiveInProgress := False;
      kTransmitInProgress := False;
      aBytesRemaining := 0;
      aBytesTransferred := 0;
      aTotalErrors := 0;
      aForceStatus := True;
      kKermitState := tkInit;
      kKermitHeaderState := hskNone;
      FillChar(kInfoTable, SizeOf(kInfoTable), 0);
      aElapsedTicks := 0;
      kpResetStatus(P);
      aProtocolStatus := psProtocolHandshake;
      apShowFirstStatus(P);
      aTimerStarted := False;
      kCheckKnown := False;
    end;
  end;

  procedure kpTransmit(Msg, wParam : Cardinal;
                      lParam : Integer);
    {-Performs one increment of a Kermit transmit}
  var
    TriggerID   : Cardinal absolute wParam;
    P           : PProtocolData;
    Finished    : Bool;
    StatusTicks : Integer;
    Dispatcher      : TApdBaseDispatcher;
  begin
    Finished := False;                                                 {!!.01}
    try                                                                {!!.01}
      {Get the protocol pointer from data pointer 1}
      Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
      with Dispatcher do
        GetDataPointer(Pointer(P), 1);
    except                                                             {!!.01}
      on EAccessViolation do                                           {!!.01}
        { No access to P^, just exit }                                 {!!.01}
        Exit;                                                          {!!.01}
    end;                                                               {!!.01}

    with P^ do begin
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if kKermitState = tkDone then begin
        LeaveCriticalSection(aProtSection);
        Exit;
      end;
        {Force TriggerID for TriggerAvail messages}
        if Msg = apw_TriggerAvail then begin
          kpFillInBuff(P);
          TriggerID := aDataTrigger;
        end;

        repeat
          try                                                          {!!.01}
            if Dispatcher.Logging then
              Dispatcher.AddDispatchEntry(
                dtKermit,LogKermitState[kKermitState],0,nil,0);

            {Nothing to do if state is tkDone}
            if kKermitState = tkDone then begin
              LeaveCriticalSection(aProtSection);
              Exit;
            end;

            {Restore last status}
            aProtocolStatus := aSaveStatus;

            {Check for user abort}
            if aSaveStatus <> psCancelRequested then begin
              if Integer(TriggerID) = aNoCarrierTrigger then begin
                aProtocolStatus := psAbortNoCarrier;
                kKermitState := rkError;
              end;
              if Msg = apw_ProtocolCancel then begin
                kpCancel(P);
                kKermitState := tkError;
              end;
            end;

            {Show status at requested intervals and after significant events}
            if aForceStatus or (Integer(TriggerID) = aStatusTrigger) then begin
              if Dispatcher.TimerTicksRemaining(aStatusTrigger,
                                      StatusTicks) <> 0 then
                StatusTicks := 0;
              if StatusTicks <= 0 then begin
                apShowStatus(P, 0);
                Dispatcher.SetTimerTrigger(aStatusTrigger, aStatusInterval, True);
                aForceStatus := False;
              end;
              if Integer(TriggerID) = aStatusTrigger then begin
                LeaveCriticalSection(aProtSection);
                Exit;
              end;
            end;

            {Preprocess incoming headers}
            case kKermitState of
              tkInitReply,
              tkFileReply,
              tkBlockReply,
              tkEofReply,
              tkBreakReply :
                if TriggerID = aDataTrigger then
                  {Got data, see if it's a header}
                  kpCheckForHeader(P)
                else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timed out waiting for header...}
                  aForceStatus := True;
                  if kpCheckRetries(P) then
                    {Fatal error if too many retries}
                    kKermitState := tkError
                  else
                    {Let state machine take apropriate recovery action}
                    aProtocolStatus := psTimeout;
                end else
                  {Indicate that we don't have a header yet}
                  aProtocolStatus := psNoHeader;
            end;

            {Preprocess incoming datapackets}
            case kKermitState of
              tkCollectInit,
              tkCollectFile,
              tkCollectBlock,
              tkCollectEof,
              tkCollectBreak :
                if TriggerID = aDataTrigger then begin
                  kpReceiveBlock(P);
                  case aProtocolStatus of
                    psOK, psNoData, psGotData : ;
                    else begin
                      aForceStatus := True;
                      if kpCheckRetries(P) then
                        kKermitState := tkError
                    end;
                  end;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout waiting for datapacket}
                  aForceStatus := True;
                  if kpCheckRetries(P) then
                    {Fatal error if too many retries}
                    kKermitState := tkError
                  else
                    {Let state machine take apropriate recovery action}
                    aProtocolStatus := psTimeout;
                end else
                  {Indicate that we don't have any data yet}
                  aProtocolStatus := psNoData;
            end;

            {Process current state}
            case kKermitState of
              tkInit :
                begin
                  aBlockNum := 0;

                  {Send SendInit packet}
                  kpSendInitialize(P);

                  {Start waiting for reply}
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  kKermitState := tkInitReply;
                end;

              tkInitReply :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      kKermitState := tkCollectInit;
                      kKermitDataState := FirstDataState[kRecDataLen=0];
                      kBlockIndex := 1;
                    end;
                  psNoheader :
                    {Keep waiting};
                  else
                    {Timeout or block error, resend SendInit}
                    if kpCheckRetries(P) then
                      kKermitState := tkError
                    else begin
                      kpFlushInBuffer(P);
                      kKermitState := tkInit;
                    end;
                end;

              tkCollectInit :
                case aProtocolStatus of
                  psGotData :
                    case kPacketType of
                      KAck :
                        begin
                          kpProcessOptions(P);
                          if aProtocolError = ecOK then begin
                            kKermitState := tkOpenFile;
                            aBlockErrors := 0;
                            kCheckKnown := True;
                          end else
                            kKermitState := tkError;
                        end;
                      KError :
                        kKermitState := tkError;
                      else
                        if kpCheckRetries(P) then
                          kKermitState := tkError
                        else
                          kKermitState := tkInit;
                    end;
                  psNoData :
                    {Keep waiting for data};
                  else
                    {Timeout or other error, retry}
                    kKermitState := tkInit;
                end;

              tkOpenFile :
                begin
                  aForceStatus := True;
                  kpResetStatus(P);
                  if not apNextFile(P, aPathname) then begin
                    {Error - no files to send (AsyncStatus already set)}
                    kKermitState := tkError;
                  end else begin
                    aForceStatus := True;
                    if aUpcaseFileNames then
                      AnsiUpper(aPathname);
                    apPrepareReading(P);
                    if aProtocolError = ecOK then begin
                      {Read the first protocol buffer}
                      kWorkLen := SizeOf(kWorkBlock^);
                      aFileOfs := 0;
                      kWorkEndPending := apReadProtocolBlock(P, kWorkBlock^, kWorkLen);
                      if aProtocolError = ecOK then begin
                        aFileOfs := kWorkLen;
                        kLastWorkIndex := 1;
                        kTransmitInProgress := True;
                        apLogFile(P, lfTransmitStart);
                        kKermitState := tkSendFile;
                        aBlockNum := Inc64(aBlockNum);
                        NewTimer(aTimer, 1);
                        aTimerStarted := True;
                      end else
                        kKermitState := tkError;
                    end else
                      kKermitState := tkError;
                  end;
                end;

              tkSendFile :
                begin
                  aForceStatus := True;
                  {aBlockNum := Inc64(aBlockNum);}
                  kpSendFilePacket(P);
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  kKermitState := tkFileReply;
                end;

              tkFileReply :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      kKermitState := tkCollectFile;
                      kKermitDataState := FirstDataState[kRecDataLen=0];
                      kBlockIndex := 1;
                    end;
                  psNoheader :
                    {Keep waiting};
                  else if kpCheckRetries(P) then
                    kKermitState := tkError
                  else
                    kKermitState := tkSendFile;
                end;

              tkCollectFile :
                case aProtocolStatus of
                  psGotData :
                    case kPacketType of
                      KAck :
                        if kRecBlockNum = kExpectedAck then begin
                          aBlockErrors := 0;
                          kTableHead := 1;
                          kKermitState := tkCheckTable;
                        end else begin
                          if kpCheckRetries(P) then
                            kKermitState := tkError
                          else
                            kKermitState := tkSendFile;
                        end;
                      KEndOfFile,
                      KError :
                        kKermitState := tkError;
                      else
                        if kpCheckRetries(P) then
                          kKermitState := tkError
                        else
                          kKermitState := tkSendFile;
                    end;
                  psNoData :
                    {Keep waiting for data} ;
                  else
                    {Timeout or other error}
                    kKermitState := tkSendFile;
                end;

              tkCheckTable :
                begin
                  {See if there is room to load another buffer into table}
                  if not kpTableFull(P) then begin
                    {Get next escaped block}
                    kpLoadTransmitData(P);
                    if aProtocolStatus = psEndFile then begin
                      {No more data to send, wait for acks or send eof}
                      if kpPacketsOutstanding(P) then
                        kKermitState := tkBlockReply
                      else begin
                        aBlockNum := Inc64(aBlockNum);
                        kKermitState := tkSendEof;
                      end;
                    end else begin
                      {Save in table}
                      aBlockNum := Inc64(aBlockNum);
                      kTableHead := kpNextSeq(P, kTableHead);
                      Move(aDataBlock^, kDataTable^[(kTableHead-1)*aBlockLen], kDataLen);
                      kInfoTable[kTableHead].Len := kDataLen;
                      kInfoTable[kTableHead].InUse := True;
                      kInfoTable[kTableHead].Seq := aBlockNum;
                      kInfoTable[kTableHead].Retries := 0;
                      kNext2Send := kTableHead;
                      kKermitState := tkSendData;
                      Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                      Dispatcher.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                     end;
                  end else begin
                    {Table full, wait for Acks...}
                    kKermitState := tkBlockReply;
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger,
                      Secs2Ticks(kKermitOptions.MaxTimeout), True);
                  end;
                end;

              tkSendData :
                if Integer(TriggerID) = aOutBuffUsedTrigger then begin
                  aForceStatus := True;
                  kpSendDataPacket(P, kNext2Send);
                  kKermitState := tkBlockReply;
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  apProtocolError(P, ecTimeout);
                  kKermitState := tkError;
                end;

              tkBlockReply :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      kKermitState := tkCollectBlock;
                      kKermitDataState := FirstDataState[kRecDataLen=0];
                      kBlockIndex := 1;
                    end;
                  psNoHeader :
                    kKermitState := tkCheckTable;
                  else begin
                    kKermitState := tkSendData;
                    kpResendDataPacket(P, kpGetOldestSequence(P));
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                    Dispatcher.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                  end;
                end;

              tkCollectBlock :
                case aProtocolStatus of
                  psGotData :
                    case kPacketType of
                      KAck :
                        begin
                          aBlockErrors := 0;
                          if (kRecDataLen > 0) and
                             (aDataBlock^[1] in ['Z', 'X', 'D']) then begin
                            {Abort requested}
                            aProtocolStatus := psCancelRequested;
                            kKermitState := tkError;
                          end else begin
                            {Signal Ack, then go load next block}
                            kpGotAck(P, kRecBlockNum);
                            kKermitState := tkCheckTable;
                            Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                          end;
                        end;
                      KError :
                        kKermitState := tkError;
                      else
                        if kpCheckRetries(P) then
                          kKermitState := tkError
                        else begin
                          kNext2Send := kpSeqInTable(P, kRecBlockNum);
                          if kNext2Send <> -1 then begin
                            {Resend Nak'd packet}
                            Inc(kInfoTable[kNext2Send].Retries);
                            if kInfoTable[kNext2Send].Retries < aHandshakeRetry then begin
                              kKermitState := tkSendData;
                              Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                              Dispatcher.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                            end else
                              kKermitState := tkError;
                          end else begin
                            {Nak outside of table...}
                            if kRecBlockNum = Inc64(aBlockNum) then begin
                              {...was one past the table, treat as nak}
                              kpGotAck(P, aBlockNum);
                              kKermitState := tkCheckTable;
                              Dispatcher.SetTimerTrigger(aTimeoutTrigger,
                                               aHandshakeWait, True);
                            end else begin
                              {...was more than one past the table, ignore}
                              kNext2Send := kTableHead;
                              kKermitState := tkCheckTable;
                            end;
                          end;
                        end;
                    end;
                  psNoData :
                    {Keep waiting};
                  else begin
                    kKermitState := tkSendData;
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                    Dispatcher.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                  end;
                end;

              tkSendEof :
                begin
                  aForceStatus := True;
                  apFinishReading(P);
                  apLogFile(P, lfTransmitOk);
                  kTransmitInProgress := False;
                  kDataLen := 0;
                  {aBlockNum := Inc64(aBlockNum);}
                  kpSendPacket(P, KEndOfFile);
                  kKermitState := tkEofReply;
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end;

              tkEofReply :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      kKermitState := tkCollectEof;
                      kKermitDataState := FirstDataState[kRecDataLen=0];
                      kBlockIndex := 1;
                    end;
                  psNoHeader :
                    {Keep waiting} ;
                  else
                    {Timeout or other error}
                    kKermitState := tkSendEof;
                end;

              tkCollectEof :
                case aProtocolStatus of
                  psGotData :
                    case kPacketType of
                      KAck :
                        begin
                          aBlockErrors := 0;
                          if not apNextFile(P, aPathname) then begin
                            {No more files, terminate protocol}
                            kKermitState := tkSendBreak;
                            aProtocolError := ecOK;
                          end else begin
                            kpResetStatus(P);
                            if aUpcaseFileNames then
                              AnsiUpper(aPathname);
                            apPrepareReading(P);
                            if aProtocolError = ecOK then begin
                              {Read the first protocol buffer}
                              kWorkLen := SizeOf(kWorkBlock^);
                              aFileOfs := 0;
                              kWorkEndPending :=
                                apReadProtocolBlock(P, kWorkBlock^, kWorkLen);
                              if aProtocolError = ecOK then begin
                                aFileOfs := kWorkLen;
                                kLastWorkIndex := 1;
                                kTransmitInProgress := True;
                                apLogFile(P, lfTransmitStart);
                                kKermitState := tkSendFile;
                                aBlockNum := Inc64(aBlockNum);
                                NewTimer(aTimer, 1);
                                aTimerStarted := True;
                              end else
                                kKermitState := tkError;
                            end else
                              kKermitState := tkError;
                          end;
                        end;
                      KError :
                         kKermitState := tkError;
                      else
                        if kpCheckRetries(P) then
                          kKermitState := tkError
                        else
                          kKermitState := tkSendEof;
                    end;
                  psNoData :
                    {Keep waiting for data};
                  else
                    {Timeout or other error}
                    kKermitState := tkSendEof;
                end;

              tkSendBreak :
                begin
                  aForceStatus := True;
                  kDataLen := 0;
                  aBlockNum := Inc64(aBlockNum);
                  kpSendPacket(P, KBreak);
                  kKermitState := tkBreakReply;
                end;

              tkBreakReply :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      kKermitState := tkCollectBreak;
                      kKermitDataState := FirstDataState[kRecDataLen=0];
                      kBlockIndex := 1;
                    end;
                  psNoHeader :
                    {Keep waiting};
                  else
                    {Timeout or other error}
                    kKermitState := tkSendBreak;
                end;

              tkCollectBreak :
                case aProtocolStatus of
                  psGotData :
                    case kPacketType of
                      KAck :
                        kKermitState := tkComplete
                      else
                        kKermitState := tkError;
                    end;
                  psNoData :
                    {Keep waiting for data};
                  else
                    {Timeout or other error}
                    kKermitState := tkSendBreak;
                end;

              tkWaitCancel :
                if (Integer(TriggerID) = aTimeoutTrigger) or
                   (Integer(TriggerID) = aOutBuffUsedTrigger) then
                  kKermitState := tkError;

              tkError :
                begin
                  apFinishReading(P);
                  apLogFile(P, lfTransmitFail);
                  kKermitState := tkComplete;
                end;

              tkComplete :
                begin
                  apShowLastStatus(P);
                  kKermitState := tkDone;
                  apSignalFinish(P);
                end;
            end;

            {Reset header state after complete headers}
            if aProtocolStatus = psGotHeader then
              kKermitHeaderState := hskNone;

            {Reset aProtocolStatus for various conditions}
            case aProtocolStatus of
              psGotHeader, psNoHeader, psGotData, psNoData :
                aProtocolStatus := psOK;
            end;

            {Stay in state machine or exit}
            case kKermitState of
              {Stay in state machine if more data ready}
              tkInitReply,
              tkCollectInit,
              tkFileReply,
              tkCollectFile,
              tkCollectBlock,
              tkEofReply,
              tkCollectEof,
              tkBreakReply,
              tkCollectBreak,
              tkWaitCancel   : Finished := not kpCharReady(P);

              {Stay in state machine if data ready or room in table}
              tkBlockReply : if not kpTableFull(P) and
                                (aProtocolStatus <> psEndFile) then
                               Finished := False
                             else
                               Finished := not kpCharReady(P);

              {Stay in state machine, interim states}
              tkInit,
              tkOpenFile,
              tkSendFile,
              tkCheckTable,
              tkSendEof,
              tkSendBreak,
              tkComplete,
              tkError        : Finished := False;

              {Leave state machine, waiting for trigger}
              tkSendData     : Finished := True;

              {Done state}
              tkDone         : Finished := True;
              else             Finished := True;
            end;

            {Store protocol status}
            aSaveStatus := aProtocolStatus;

            {If staying is state machine force data ready}
            TriggerID := aDataTrigger;
          except                                                       {!!.01}
            on EAccessViolation do begin                               {!!.01}
              Finished := True;                                        {!!.01}
              aProtocolError := ecAbortNoCarrier;                      {!!.01}
              apSignalFinish(P);                                       {!!.01}
            end;                                                       {!!.01}
          end;                                                         {!!.01}
        until Finished;
      LeaveCriticalSection(P^.aProtSection);                         {!!.01}
    end;
  end;

end.

