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
{*                   AWZMODEM.PAS 4.06                   *}
{*********************************************************}
{* ZModem protocol                                       *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$Q-,V-,I-,B-,F+,A-,X+}

unit AwZmodem;
  {-Provides Zmodem receive and transmit functions}

interface

uses
  Windows,
  Messages,
  SysUtils,
  MMSystem,
  OoMisc,
  AwUser,
  AwTPcl,
  AwAbsPcl,
  AdPort;


const
  {Compile-time constants}
  MaxAttentionLen = 32;           {Maximum length of attention string}
  MaxHandshakeWait = 1092;        {Ticks to wait for first hdr (60 secs)}
  MaxBadBlocks = 20;              {Quit if this many bad blocks}
  DefReceiveTimeout = 364;        {Default Ticks for received data (20 secs)}
  DrainingStatusInterval  = 18;   {Default status interval for draining eof}
  DefFinishWaitZM = 364;          {Wait time for ZFins, 30 secs}
  DefFinishRetry = 3;             {Retry ZFin 3 times}

  {For estimating protocol transfer times}
  ZmodemTurnDelay = 0;            {Millisecond turnaround delay}
  ZmodemOverHead  = 20;           {Default overhead for each data subpacket}

  {For checking max block sizes}
  ZMaxBlock : Array[Boolean] of Cardinal = (1024, 8192);
  ZMaxWork  : Array[Boolean] of Cardinal = (2048, 16384);

  {Zmodem constants}
  ZPad       = '*';                  {Pad}
  ZDle       = cCan;                 {Data link escape}
  ZBin       = 'A';                  {Binary header using Crc16}
  ZHex       = 'B';                  {Hex header using Crc16}
  ZBin32     = 'C';                  {Binary header using Crc32}

  {Zmodem frame types}
  ZrQinit    = #0;                   {Request init (to receiver)}
  ZrInit     = #1;                   {Init (to sender)}
  ZsInit     = #2;                   {Init (to receiver) (optional)}
  ZAck       = #3;                   {Acknowledge last frame}
  ZFile      = #4;                   {File info frame (to receiver)}
  ZSkip      = #5;                   {Skip to next file (to receiver)}
  ZNak       = #6;                   {Error receiving last data subpacket}
  ZAbort     = #7;                   {Abort protocol}
  ZFin       = #8;                   {Finished protocol}
  ZRpos      = #9;                   {Resume from this file position}
  ZData      = #10;                  {Data subpacket(s) follows}
  ZEof       = #11;                  {End of current file}
  ZFerr      = #12;                  {Error reading or writing file}
  ZCrc       = #13;                  {Request for file CRC (to receiver)}
  ZChallenge = #14;                  {Challenge the sender}
  ZCompl     = #15;                  {Complete}
  ZCan       = #16;                  {Cancel requested (to either)}
  ZFreeCnt   = #17;                  {Request diskfree}
  ZCommand   = #18;                  {Execute this command (to receiver)}

{Constructors/destructors}
function zpInit(var P : PProtocolData; H : TApdCustomComPort;         
                Options : Cardinal) : Integer;
procedure zpDone(var P : PProtocolData);

function zpReinit(P : PProtocolData) : Integer;
procedure zpDonePart(P : PProtocolData);

{Options}
function zpSetFileMgmtOptions(P : PProtocolData;
                              Override, SkipNoFile : Bool;
                              FOpt : Byte) : Integer;
function zpSetRecoverOption(P : PProtocolData; OnOff : Bool) : Integer;
function zpSetBigSubpacketOption(P : PProtocolData;
                                 UseBig : Bool) : Integer;
function zpSetZmodemFinishWait(P : PProtocolData;
                               NewWait : Cardinal;
                               NewRetry : Byte) : Integer;

{Control}
procedure zpPrepareTransmit(P : PProtocolData);
procedure zpPrepareReceive(P : PProtocolData);
procedure zpTransmit(Msg, wParam : Cardinal; lParam : LongInt);
procedure zpReceive(Msg, wParam : Cardinal; lParam : LongInt);

implementation

const
  {For various hex char manipulations}
  HexDigits : array[0..15] of AnsiChar = '0123456789abcdef';

  {For initializing block check values}
  CheckInit : array[Boolean] of Integer = (0, -1);

  {For manipulating file management masks}
  FileMgmtMask = $07;              {Isolate file mgmnt values}
  FileSkipMask = $80;              {Skip file if dest doesn't exist}

  {Only supported conversion option}
  FileRecover = $03;               {Resume interrupted file transfer}

  {Data subpacket terminators}
  ZCrcE      = 'h';                {End  - last data subpacket of file}
  ZCrcG      = 'i';                {Go   - no response necessary}
  ZCrcQ      = 'j';                {Ack  - requests ZACK or ZRPOS}
  ZCrcW      = 'k';                {Wait - sender waits for answer}

  {Translate these escaped sequences}
  ZRub0      = 'l';                {Translate to $7F}
  ZRub1      = 'm';                {Translate to $FF}

  {Byte offsets for pos/flag bytes}
  ZF0 = 3;                         {Flag byte 3}
  ZF1 = 2;                         {Flag byte 2}
  ZF2 = 1;                         {Flag byte 1}
  ZF3 = 0;                         {Flag byte 0}
  ZP0 = 0;                         {Position byte 0}
  ZP1 = 1;                         {Position byte 1}
  ZP2 = 2;                         {Position byte 1}
  ZP3 = 3;                         {Position byte 1}

  {Bit masks for ZrInit}
  CanFdx  = $0001;           {Can handle full-duplex}
  CanOvIO = $0002;           {Can do disk and serial I/O overlaps}
  CanBrk  = $0004;           {Can send a break}
  CanCry  = $0008;           {Can encrypt/decrypt, not supported}
  CanLzw  = $0010;           {Can LZ compress, not supported}
  CanFc32 = $0020;           {Can use 32 bit CRC}
  EscAll  = $0040;           {Escapes all control chars, not supported}
  Esc8    = $0080;           {Escapes the 8th bit, not supported}

  {Bit masks for ZsInit}
  TESCtl  = $0040;           {Sender asks for escaped ctl chars, not supported}
  TESC8   = $0080;           {Sender asks for escaped hi bits, not supported}

  {Character constants}
  cDleHi  = AnsiChar(Ord(cDle) + $80);
  cXonHi  = AnsiChar(Ord(cXon) + $80);
  cXoffHi = AnsiChar(Ord(cXoff) + $80);

  aDataTrigger = 0;

  LogZModemState : array[TZmodemState] of TDispatchSubType = (
     dsttzInitial, dsttzHandshake, dsttzGetFile, dsttzSendFile,
     dsttzCheckFile, dsttzStartData, dsttzEscapeData, dsttzSendData,
     dsttzWaitAck, dsttzSendEof, dsttzDrainEof, dsttzCheckEof,
     dsttzSendFinish, dsttzCheckFinish, dsttzError, dsttzCleanup,
     dsttzDone,
     dstrzRqstFile, dstrzDelay, dstrzWaitFile, dstrzCollectFile,
     dstrzSendInit, dstrzSendBlockPrep, dstrzSendBlock, dstrzSync,
     dstrzStartFile, dstrzStartData, dstrzCollectData, dstrzGotData,
     dstrzWaitEof, dstrzEndOfFile, dstrzSendFinish, dstrzCollectFinish,
     dstrzError, dstrzWaitCancel, dstrzCleanup, dstrzDone,
     dsttzSInit, dsttzCheckSInit);                                          // SWB


  procedure zpPrepareWriting(P : PProtocolData);
    {-Prepare to save protocol blocks (usually opens a file)}
  var
    FileExists     : Bool;
    FileSkip       : Bool;
    Result         : Cardinal;
    FileLen        : LongInt;
    FileDate       : LongInt;
    SeekPoint      : LongInt;
    FileStartOfs   : LongInt;
    YMTSrcFileDate : LongInt;
    FileOpt        : Byte;

    procedure ErrorCleanup;
    begin
      with P^ do begin
        Close(aWorkFile);
        if IOResult <> 0 then ;
        FreeMem(aFileBuffer, FileBufferSize);
      end;
    end;

    { Allows a 1 sec fudge to compensate for FAT timestamp rounding }
    function YMStampEqual(YMStamp1, YMStamp2 : LongInt) : Boolean;
    begin
      Result := abs(YMStamp1 - YMStamp2) <= 1;
    end;

    { Allows a 1 sec fudge to compensate for FAT timestamp rounding }
    function YMStampLessOrEqual(YMStamp1, YMStamp2 : LongInt) : Boolean;
    begin
      Result := YMStampEqual(YMStamp1, YMStamp2) or (YMStamp1 < YMStamp2);
    end;

  begin
    with P^ do begin
      aProtocolError := ecOK;
      {Allocate a file buffer}
      aFileBuffer := AllocMem(FileBufferSize);

      {Set file mgmt options}
      FileSkip := (zFileMgmtOpts and FileSkipMask) <> 0;
      FileOpt := zFileMgmtOpts and FileMgmtMask;

      {Check for a local request for file recovery}
      if zReceiverRecover then
        zConvertOpts := zConvertOpts or FileRecover;

      {Does the file exist already?}
      aSaveMode := FileMode;
      FileMode := 0;
      Assign(aWorkFile, aPathName);
      Reset(aWorkFile, 1);
      Result := IOResult;
      FileMode := aSaveMode;

      {Exit on errors other than FileNotFound}
      if (Result <> 0) and (Result <> 2) then begin
        apProtocolError(P, -Result);
        ErrorCleanup;
        Exit;
      end;

      {Note if file exists, its size and timestamp}
      FileExists := (Result = 0);
      if FileExists then begin
        FileLen := FileSize(aWorkFile);
        FileDate := FileGetDate(TFileRec(aWorkFile).Handle);
        FileDate := apPackToYMTimeStamp(FileDate);
      end else begin
        FileLen := 0;
        FileDate := 0;
      end;
      Close(aWorkFile);
      if IOResult = 0 then ;

      {If recovering, skip all file managment checks and go append file}
      if FileExists and
         (aSrcFileLen > FileLen) and
         ((zConvertOpts and FileRecover) = FileRecover) then begin
        SeekPoint := FileLen;
        FileStartOfs := FileLen;
        aInitFilePos := FileLen;
      end else begin
        {Tell status we're not recovering}
        aInitFilePos := 0;

        {Check for skip condition}
        if FileSkip and not FileExists then begin
          aProtocolStatus := psFileDoesntExist;
          ErrorCleanup;
          Exit;
        end;

        {Process the file management options}
        SeekPoint := 0;
        FileStartOfs := 0;
        case FileOpt of
          zfWriteNewerLonger : {Transfer only if new, newer or longer}
            if FileExists then begin
              YMTSrcFileDate := apPackToYMTimeStamp(aSrcFileDate);
              if YMStampLessOrEqual(YMTSrcFileDate, FileDate) and
                 (aSrcFileLen <= FileLen) then begin
                aProtocolStatus := psCantWriteFile;
                ErrorCleanup;
                Exit;
              end;
            end;
          zfWriteAppend :      {Transfer regardless, append if exists}
            if FileExists then
              SeekPoint := FileLen;
          zfWriteClobber :     {Transfer regardless, overwrite} ;
            {Nothing to do, this is the normal behavior}
          zfWriteDifferent :   {Transfer only if new, size diff, or dates diff}
            if FileExists then begin
              YMTSrcFileDate := apPackToYMTimeStamp(aSrcFileDate);
              if YMStampEqual(YMTSrcFileDate, FileDate) and
                 (aSrcFileLen = FileLen) then begin
                aProtocolStatus := psCantWriteFile;
                ErrorCleanup;
                Exit;
              end;
            end;
          zfWriteProtect :     {Transfer only if dest file doesn't exist}
            if FileExists then begin
              aProtocolStatus := psCantWriteFile;
              ErrorCleanup;
              Exit;
            end;
          zfWriteCrc,          {Not supported, treat as WriteNewer}
          zfWriteNewer :       {Transfer only if new or newer}
            if FileExists then begin
              YMTSrcFileDate := apPackToYMTimeStamp(aSrcFileDate);
              if YMStampLessOrEqual(YMTSrcFileDate, FileDate) then
              begin
                aProtocolStatus := psCantWriteFile;
                ErrorCleanup;
                Exit;
              end;
            end;
        end;
      end;

      {Rewrite or append to file}
      Assign(aWorkFile, aPathname);
      if SeekPoint = 0 then begin
        {New or overwriting destination file}
        Rewrite(aWorkFile, 1);
      end else begin
        {Appending to file}
        Reset(aWorkFile, 1);
        Seek(aWorkFile, SeekPoint);
      end;
      Result := IOResult;
      if Result <> 0 then begin
        apProtocolError(P, -Result);
        ErrorCleanup;
        Exit;
      end;

      {Initialized the buffer management vars}
      aFileOfs := FileStartOfs;
      aStartOfs := FileStartOfs;
      aLastOfs := FileStartOfs;
      aEndOfs := aStartOfs + FileBufferSize;
      aFileOpen := True;
    end;
  end;

  procedure zpFinishWriting(P : PProtocolData);
    {-Cleans up after saving all protocol blocks}
  var
    BytesToWrite : Integer;
    BytesWritten : Integer;
    Result       : Cardinal;
  begin
    with P^ do begin
      if aFileOpen then begin
        {Error or end-of-file, commit buffer}
        BytesToWrite := aFileOfs - aStartOfs;
        BlockWrite(aWorkFile, aFileBuffer^, BytesToWrite, BytesWritten);
        Result := IOResult;
        if (Result <> 0) then
          apProtocolError(P, -Result);
        if (BytesToWrite <> BytesWritten) then
          apProtocolError(P, ecDiskFull);

        {Set the timestamp to that of the source file}
        if aProtocolError = ecOK then begin
          FileSetDate(TFileRec(aWorkFile).Handle, aSrcFileDate);
        end;

        {Clean up}
        Close(aWorkFile);
        if IOResult <> 0 then ;
        FreeMem(aFileBuffer, FileBufferSize);
        aFileOpen := False;
      end;
    end;
  end;

  procedure zpDeallocBuffers(P : PProtocolData);
    {-Release block and work buffers}
  begin
    with P^ do begin
      FreeMem(aDataBlock, ZMaxBlock[zUse8KBlocks]);
      FreeMem(zWorkBlock, ZMaxWork[zUse8KBlocks]);
    end;
  end;

  function zpAllocBuffers(P : PProtocolData) : Bool;
  begin
    with P^ do begin
      aDataBlock := nil;
      zWorkBlock := nil;
      aDataBlock := AllocMem(ZMaxBlock[zUse8KBlocks]);
      zWorkBlock := AllocMem(ZMaxWork[zUse8KBlocks]);
      zpAllocBuffers := True;
    end;
  end;

  procedure zpInitData(P : PProtocolData);
    {-Init the protocol data}
  begin
    with P^ do begin
      {Init this object's fields}
      aCurProtocol := Zmodem;
      aBatchProtocol := True;
      aFileOpen := False;
      aFileOfs := 0;
      aRcvTimeout := DefReceiveTimeout;
      aCheckType := bcCrc32;
      aSrcFileDate := 0;
      aBlockLen := ZMaxBlock[zUse8KBlocks];
      aOverhead := ZmodemOverhead;
      aTurnDelay := ZmodemTurnDelay;
      aFinishWait := DefFinishWaitZM;
      aHandshakeWait := MaxHandshakeWait;
      apResetReadWriteHooks(P);
      apPrepareWriting := zpPrepareWriting;
      apFinishWriting := zpFinishWriting;
      FillChar(zAttentionStr, MaxAttentionLen, 0);
      zLastFileOfs := 0;
      zUseCrc32 := True;
      zCanCrc32 := True;
      zReceiverRecover := False;
      zFileMgmtOpts := zfWriteNewer;
      zFileMgmtOverride := False;
      zTookHit := False;
      zGoodAfterBad := 0;
      zEscapePending := False;
      zHexPending := False;
      zFinishRetry := DefFinishRetry;
      zEscapeAll := False;
    end;
  end;

  function zpInit(var P : PProtocolData;
                  H : TApdCustomComPort;
                  Options : Cardinal) : Integer;
    {-Allocates and initializes a protocol control block with options}
  const
    MinSize : array[Boolean] of Cardinal = (2048+30, 16384+30);
  var
    InSize, OutSize : Cardinal;
  begin
    {Check for adequate output buffer size}
    H.ValidDispatcher.BufferSizes(InSize, OutSize);
    if OutSize < MinSize[FlagIsSet(Options, apZmodem8K)] then begin
      zpInit := ecOutputBufferTooSmall;
      Exit;
    end;

    {Allocate protocol record, init base data}
    if apInitProtocolData(P, H, Options) <> ecOk then begin
      zpInit := ecOutOfMemory;
      Exit;
    end;

    with P^ do begin
      {Allocate data blocks}
      zUse8KBlocks := FlagIsSet(Options, apZmodem8K);
      if not zpAllocBuffers(P) then begin
        zpInit := ecOutOfMemory;
        zpDone(P);
        Exit;
      end;

      {Can't fail after this}
      zpInit := ecOK;

      {Init the data}
      zpInitData(P);
    end;
  end;

  function zpReinit(P : PProtocolData) : Integer;
    {-Allocates and init just the Zmodem stuff}
  begin
    with P^ do begin
      {Allocate data blocks}
      zUse8KBlocks := False;
      if not zpAllocBuffers(P) then begin
        zpReinit := ecOutOfMemory;
        zpDone(P);
        Exit;
      end;

      {Can't fail after this}
      zpReinit := ecOK;

      {Init the data}
      zpInitData(P);
    end;
  end;

  procedure zpDone(var P : PProtocolData);
    {-Dispose of Zmodem}
  begin
    zpDeallocBuffers(P);
    apDoneProtocol(P);
  end;

  procedure zpDonePart(P : PProtocolData);
    {-Dispose of just the Zmodem stuff}
  begin
    zpDeallocBuffers(P);
  end;

  function zpSetFileMgmtOptions(P : PProtocolData;
                                 Override, SkipNoFile : Bool;
                                 FOpt : Byte) : Integer;
    {-Set file mgmt options to use when sender doesn't specify}
  const
    SkipMask : array[Boolean] of Byte = ($00, $80);
  begin
    with P^ do begin
      if aCurProtocol <> Zmodem then begin
        zpSetFileMgmtOptions := ecBadProtocolFunction;
        Exit;
      end;

      zpSetFileMgmtOptions := ecOK;
      zFileMgmtOverride := Override;
      zFileMgmtOpts := (FOpt and FileMgmtMask) or SkipMask[SkipNoFile];
    end;
  end;

  function zpSetRecoverOption(P : PProtocolData; OnOff : Bool) : Integer;
    {-Turn file recovery on (will be ignored if dest file doesn't exist)}
  begin
    with P^ do begin
      if aCurProtocol <> Zmodem then
        zpSetRecoverOption := ecBadProtocolFunction
      else begin
        zpSetRecoverOption := ecOK;
        zReceiverRecover := OnOff;
      end;
    end;
  end;

  function zpSetBigSubpacketOption(P : PProtocolData;
                                   UseBig : Bool) : Integer;
    {-Turn on/off 8K subpacket support}
  begin
    zpSetBigSubpacketOption := ecOk;
    with P^ do begin
      if aCurProtocol <> Zmodem then
        zpSetBigSubpacketOption := ecBadProtocolFunction
      else if UseBig <> zUse8KBlocks then begin
        {Changing block sizes, get rid of old buffers}
        zpDeallocBuffers(P);

        {Set new size and allocate buffers}
        if UseBig then
          aFlags := aFlags or apZmodem8K
        else
          aFlags := aFlags and not apZmodem8K;
        zUse8KBlocks := UseBig;
        if not zpAllocBuffers(P) then begin
          zpSetBigSubpacketOption := ecOutOfMemory;
          Exit;
        end;
        aBlockLen := ZMaxBlock[zUse8KBlocks];
      end;
    end;
  end;

  function zpSetZmodemFinishWait(P : PProtocolData;
                                 NewWait : Cardinal;
                                 NewRetry : Byte) : Integer;
    {-Set new finish wait and retry values}
  begin
    with P^ do begin
      if aCurProtocol <> Zmodem then
        zpSetZmodemFinishWait := ecBadProtocolFunction
      else begin
        zpSetZmodemFinishWait := ecOK;
        if aFinishWait <> 0 then
          aFinishWait := NewWait;
        zFinishRetry := NewRetry;
      end;
    end;
  end;

  procedure zpPutCharEscaped(P : PProtocolData; C : AnsiChar);
    {-Transmit with C with escaping as required}
  var
    C1 : AnsiChar;
    C2 : AnsiChar;
  begin
    with P^ do begin
      {Check for chars to escape}
      if zEscapeAll and ((Byte(C) and $60) = 0) then begin
        {Definitely needs escaping}
        aHC.PutChar(ZDle);
        zLastChar := AnsiChar(Byte(C) xor $40);
      end else if (Byte(C) and $11) = 0 then
        {No escaping, just send it}
        zLastChar := C
      else begin
        {Might need escaping}
        C1 := AnsiChar(Byte(C) and $7F);
        C2 := AnsiChar(Byte(zLastChar) and $7F);
        case C of
          cXon, cXoff, cDle,        {Escaped control chars}
          cXonHi, cXoffHi, cDleHi,  {Escaped hibit control chars}
          ZDle :                    {Escape the escape char}
            begin
              aHC.PutChar(ZDle);
              zLastChar := AnsiChar(Byte(C) xor $40);
            end;
          else
            if ((C1 = cCR) and (C2 = #$40)) then begin
              aHC.PutChar(ZDle);
              zLastChar := AnsiChar(Byte(C) xor $40);
            end else
              zLastChar := C;
        end;
      end;
      aHC.PutChar(zLastChar);
    end;
  end;

  procedure zpUpdateBlockCheck(P : PProtocolData; CurByte: Byte);
    {-Updates the block check character (whatever it is)}
  begin
    with P^ do
      if zUseCrc32 then
        aBlockCheck := apUpdateCrc32(CurByte, aBlockCheck)
      else
        aBlockCheck := apUpdateCrc(CurByte, aBlockCheck);
  end;

  procedure zpSendBlockCheck(P : PProtocolData);
    {-Makes final adjustment and sends the aBlockCheck character}
  type
    QB = array[1..4] of Ansichar;
  var
    I : Byte;
  begin
    with P^ do
      if zUseCrc32 then begin
        {Complete and send a 32 bit CRC}
        aBlockCheck := not aBlockCheck;
        for I := 1 to 4 do
          zpPutCharEscaped(P, QB(aBlockCheck)[I]);
      end else begin
        {Complete and send a 16 bit CRC}
        zpUpdateBlockCheck(P, 0);
        zpUpdateBlockCheck(P, 0);
        zpPutCharEscaped(P, AnsiChar(Hi(aBlockCheck)));
        zpPutCharEscaped(P, AnsiChar(Lo(aBlockCheck)));
      end;
  end;

  function zpVerifyBlockCheck(P : PProtocolData) : Bool;
    {-checks the block check value}
  begin
    with P^ do begin
      {Assume a block check error}
      zpVerifyBlockCheck := False;

      if zUseCrc32 then begin
        if aBlockCheck <> $DEBB20E3 then
          Exit
      end else begin
        zpUpdateBlockCheck(P, 0);
        zpUpdateBlockCheck(P, 0);
        if aBlockCheck <> 0 then
          Exit;
      end;

      {If we get here, the block check value is ok}
      zpVerifyBlockCheck := True;
    end;
  end;

  procedure zpCancel(P : PProtocolData);
    {-Sends the cancel string}
  const
    {Cancel string is 8 CANs followed by 8 Backspaces}
    CancelStr : array[0..16] of AnsiChar =
      #24#24#24#24#24#24#24#24#8#8#8#8#8#8#8#8#0;
  var
    TotalOverhead : Cardinal;
    OutBuff : Cardinal;
  begin
    with P^ do begin
      if aHC.Open then begin
        {Flush anything that might be left in the output buffer}
        OutBuff := aHC.OutBuffUsed;
        if OutBuff > aBlockLen then begin
          TotalOverhead := aOverhead * (OutBuff div aBlockLen);
          Dec(aBytesTransferred, Outbuff - TotalOverhead);
        end;
        aHC.FlushOutBuffer;

        {Send the cancel string}
        aHC.PutBlock(CancelStr, StrLen(CancelStr));
      end;
      aProtocolStatus := psCancelRequested;
      aForceStatus := True;
    end;
  end;

  function zpGotCancel(P : PProtocolData) : Bool;
    {-Return True if CanCount >= 5}
  begin
    with P^ do begin
      Inc(zCanCount);
      if zCanCount >= 5 then begin
        aProtocolStatus := psCancelRequested;
        aForceStatus := True;
        zpGotCancel := True;
      end else
        zpGotCancel := False;
    end;
  end;

  function zpGetCharStripped(P : PProtocolData; var C : AnsiChar) : Bool;
    {-Get next char, strip hibit, discard Xon/Xoff, return False for no char}
  begin
    with P^ do begin
      {Get a character, discard Xon and Xoff}
      repeat
        if aHC.CharReady then
          aHC.ValidDispatcher.GetChar(C)
        else begin
          zpGetCharStripped := False;
          Exit;
        end;
      until (C <> cXon) and (C <> cXoff);

      {Strip the high-order bit}
      C := AnsiChar(Ord(C) and Ord(#$7F));

      {Handle cancels}
      if (C = cCan) then begin
        if zpGotCancel(P) then begin
          zpGetCharStripped := False;
          Exit
        end;
      end else
        zCanCount := 0;
    end;
    zpGetCharStripped := True;
  end;

  procedure zpPutAttentionString(P : PProtocolData);
    {-Puts a string (#221 = Break, #222 = Delay)}
  var
    I  : Cardinal;
  begin
    with P^ do begin
      I := 1;
      while zAttentionStr[I] <> 0 do begin
        case zAttentionStr[I] of
          $DD : {Remote wants Break as his attention signal}
            aHC.SendBreak(1, False);
          $DE : {Remote wants us to pause for one second}
            DelayTicks(18, True);
          else   {Remote wants us to send a normal char}
            aHC.PutChar(AnsiChar(zAttentionStr[I]));
        end;
        Inc(I);
      end;
    end;
  end;

  procedure zpPutCharHex(P : PProtocolData; C : AnsiChar);
    {-Sends C as two hex ascii digits}
  var
    B : Byte absolute C;
  begin
    with P^ do begin
      aHC.PutChar(HexDigits[B shr 4]);
      aHC.PutChar(HexDigits[B and $0F]);
    end;
  end;

  procedure zpPutHexHeader(P : PProtocolData; FrameType : AnsiChar);
    {-Sends a hex header}
  const
    HexHeaderStr : array[0..4] of AnsiChar = ZPad+ZPad+ZDle+ZHex;
  var
    SaveCrc32 : Bool;
    Check     : Cardinal;
    I         : Byte;
    C         : AnsiChar;
  begin
    with P^ do begin
      {Initialize the aBlockCheck value}
      SaveCrc32 := zUseCrc32;
      zUseCrc32 := False;
      aBlockCheck := 0;

      {Send the header and the frame type}
      aHC.PutBlock(HexHeaderStr, SizeOf(HexHeaderStr)-1);
      zpPutCharHex(P, FrameType);
      zpUpdateBlockCheck(P, Ord(FrameType));

      {Send the position/flag bytes}
      for I := 0 to SizeOf(zTransHeader)-1 do begin
        zpPutCharHex(P, AnsiChar(zTransHeader[I]));
        zpUpdateBlockCheck(P, zTransHeader[I]);
      end;

      {Update Crc16 and send it (hex encoded)}
      zpUpdateBlockCheck(P, 0);
      zpUpdateBlockCheck(P, 0);
      Check := Cardinal(aBlockCheck);
      zpPutCharHex(P, AnsiChar(Hi(Check)));
      zpPutCharHex(P, AnsiChar(Lo(Check)));

      {End with a carriage return, hibit line feed}
      aHC.PutChar(cCR);
      C := AnsiChar(Ord(cLF) or $80); //SZ (was Chr)
      aHC.PutChar(C);

      {Conditionally send Xon}
      if (FrameType <> ZFin) and (FrameType <> ZAck) then
        aHC.PutChar(cXon);

      {Note frame type for status}
      zLastFrame := FrameType;

      {Restore crc type}
      zUseCrc32 := SaveCrc32;
    end;
  end;

  procedure zpGetCharEscaped(P : PProtocolData; var C : AnsiChar);
    {-Get a character (handle data link escaping)}
  label
    Escape;
  begin
    with P^ do begin
      zControlCharSkip := False;

      {Go get escaped char if we already have the escape}
      if zEscapePending then
        goto Escape;

      {Get a character}
      aHC.ValidDispatcher.GetChar(C);

      {Process char}
      case C of
        cXon,
        cXoff,
        cXonHi,
        cXoffHi : begin
                    {unescaped control char, ignore it}
                    zControlCharSkip := True;
                    Exit;
                  end;
      end;

      {If not data link escape or cancel then just return the character}
      if (C <> ZDle) then begin
        zCanCount := 0;
        Exit;
      end else if zpGotCancel(P) then
        {Got 5 cancels, ZDle's, in a row}
        Exit;

Escape:
      {Need another character, get it or say we're pending}
      if aHC.CharReady then begin
        zEscapePending := False;
        aHC.ValidDispatcher.GetChar(C);

        {If cancelling make sure we get at least 5 of them}
        if (C = cCan) then begin
          zpGotCancel(P);
          Exit;
        end else begin
          {Must be an escaped character}
          zCanCount := 0;
          case C of
            ZCrcE : {Last DataSubpacket of file}
              aProtocolStatus := psGotCrcE;
            ZCrcG : {Normal DataSubpacket, no response necessary}
              aProtocolStatus := psGotCrcG;
            ZCrcQ : {ZAck or ZrPos requested}
              aProtocolStatus := psGotCrcQ;
            ZCrcW : {DataSubpacket contains file information}
              aProtocolStatus := psGotCrcW;
            ZRub0 :         {Ascii delete}
              C := #$7F;
            ZRub1 :         {Hibit Ascii delete}
              C := #$FF;
            else            {Normal escaped character}
              C := AnsiChar(Ord(C) xor $40)
          end;
        end;
      end else
        zEscapePending := True;
    end;
  end;

  procedure zpGetCharHex(P : PProtocolData; var C : AnsiChar);
    {-Return a character that was transmitted in hex}
  label
    Hex;

    function NextHexNibble : Byte;
      {-Gets the next char, returns it as a hex nibble}
    var
      C : AnsiChar;
    begin
      with P^ do begin
        {Get the next char, assume it's ascii hex character}
        aHC.ValidDispatcher.GetChar(C);

        {Handle cancels}
        if (C = cCan) then begin
          if zpGotCancel(P) then begin
            NextHexNibble := 0;
            Exit;
          end;
        end else
          zCanCount := 0;

        {Ignore errors, they'll eventually show up as bad blocks}
        NextHexNibble := Pos(C, HexDigits) - 1;
      end;
    end;

  begin
    with P^  do begin
      if zHexPending then
        goto Hex;
      zHexChar := NextHexNibble shl 4;
Hex:
      if aHC.CharReady then begin
        zHexPending := False;
        Inc(zHexChar, NextHexNibble);
        C := AnsiChar(zHexChar);
      end else
        zHexPending := True;
    end;
  end;

  function zpCollectHexHeader(P : PProtocolData) : Bool;
    {-Gets the data and trailing portions of a hex header}
  var
    C : AnsiChar;
  begin
    with P^ do begin
      {Assume the header isn't ready}
      zpCollectHexHeader := False;

      zpGetCharHex(P, C);
      if zHexPending or (aProtocolStatus = psCancelRequested) then
        Exit;

      {Init block check on startup}
      if zHexHdrState = hhFrame then begin
        aBlockCheck := 0;
        zUseCrc32 := False;
      end;

      {Always update the block check}
      zpUpdateBlockCheck(P, Ord(C));

      {Process this character}
      case zHexHdrState of
        hhFrame :
          zRcvFrame := C;
        hhPos1..hhPos4 :
          zRcvHeader[Ord(zHexHdrState)-1] := Ord(C);
        hhCrc1 :
          {just keep going} ;
        hhCrc2 :
          if not zpVerifyBlockCheck(P) then begin
            aProtocolStatus := psBlockCheckError;
            Inc(aTotalErrors);
            zHeaderState := hsNone;
          end else begin
            {Say we got a good header}
            zpCollectHexHeader := True;
          end;
      end;

      {Goto next state}
      if zHexHdrState <> hhCrc2 then
        Inc(zHexHdrState)
      else
        zHexHdrState := hhFrame;
    end;
  end;

  function zpCollectBinaryHeader(P : PProtocolData; Crc32 : Bool) : Bool;
    {-Collects a binary header, returns True when ready}
  var
    C : AnsiChar;
  begin
    with P^ do begin
      {Assume the header isn't ready}
      zpCollectBinaryHeader := False;

      {Get the waiting character}
      zpGetCharEscaped(P, C);
      if zEscapePending or (aProtocolStatus = psCancelRequested) then
        Exit;
      if zControlCharSkip then
        Exit;

      {Init block check on startup}
      if zBinHdrState = bhFrame then begin
        zUseCrc32 := Crc32;
        aBlockCheck := CheckInit[zUseCrc32];
      end;

      {Always update the block check}
      zpUpdateBlockCheck(P, Ord(C));

      {Process this character}
      case zBinHdrState of
        bhFrame :
          zRcvFrame := C;
        bhPos1..bhPos4 :
          zRcvHeader[Ord(zBinHdrState)-1] := Ord(C);
        bhCrc2 :
          if not zUseCrc32 then begin
            if not zpVerifyBlockCheck(P) then begin
              aProtocolStatus := psBlockCheckError;
              Inc(aTotalErrors);
              zHeaderState := hsNone;
            end else begin
              {Say we got a good header}
              zpCollectBinaryHeader := True;
            end;
          end;
        bhCrc4 :
          {Check the Crc value}
          if not zpVerifyBlockCheck(P) then begin
            aProtocolStatus := psBlockCheckError;
            Inc(aTotalErrors);
            zHeaderState := hsNone;
          end else begin
            {Say we got a good header}
            zpCollectBinaryHeader := True;
          end;
      end;

      {Go to next state}
      if zBinHdrState <> bhCrc4 then
        Inc(zBinHdrState)
      else
        zBinHdrState := bhFrame;
    end;
  end;

  procedure zpCheckForHeader(P : PProtocolData);
    {-Samples input stream for start of header}
  var
    C : AnsiChar;
  begin
    with P^ do begin
      {Assume no header ready}
      aProtocolStatus := psNoHeader;

      {Process potential header characters}
      while aHC.CharReady do begin

        {Only get the next char if we don't know the header type yet}
        case zHeaderState of
          hsNone, hsGotZPad, hsGotZDle :
            if not zpGetCharStripped(P, C) then
              Exit;
        end;

        {Try to accumulate the start of a header}
        aProtocolStatus := psNoHeader;
        case zHeaderState of
          hsNone :
            if C = ZPad then
              zHeaderState := hsGotZPad;
          hsGotZPad :
            case C of
              ZPad : ;
              ZDle : zHeaderState := hsGotZDle;
              else   zHeaderState := hsNone;
            end;
          hsGotZDle :
            case C of
              ZBin   :
                begin
                  zWasHex := False;
                  zHeaderState := hsGotZBin;
                  zBinHdrState := bhFrame;
                  zEscapePending := False;
                  {if zpCollectBinaryHeader(P, False) then}
                  {  zHeaderState := hsGotHeader;         }
                end;
              ZBin32 :
                begin
                  zWasHex := False;
                  zHeaderState := hsGotZBin32;
                  zBinHdrState := bhFrame;
                  zEscapePending := False;
                  {if zpCollectBinaryHeader(P, True) then}
                  {  zHeaderState := hsGotHeader;        }
                end;
              ZHex   :
                begin
                  zWasHex := True;
                  zHeaderState := hsGotZHex;
                  zHexHdrState := hhFrame;
                  zHexPending := False;
                  {if zpCollectHexHeader(P) then}
                end;
              else
                zHeaderState := hsNone;
            end;
          hsGotZBin :
            if zpCollectBinaryHeader(P, False) then
              zHeaderState := hsGotHeader;
          hsGotZBin32 :
            if zpCollectBinaryHeader(P, True) then
              zHeaderState := hsGotHeader;
          hsGotZHex :
            if zpCollectHexHeader(P) then
              zHeaderState := hsGotHeader;
        end;

        if (zHeaderState = hsGotHeader) and (zRcvFrame = ZEof) and
          (zLastFrame = ZrPos) then
          zHeaderState := hsNone;

        {If we just got a header, note file pos and frame type}
        if zHeaderState = hsGotHeader then begin
          aProtocolStatus := psGotHeader;
          case zLastFrame of
            ZrPos, ZAck, ZData, ZEof :
              {Header contained a reported file position}
              zLastFileOfs := LongInt(zRcvHeader);
          end;

          {Note frame type for status}
          zLastFrame := zRcvFrame;

          {...and leave}
          Exit;
        end;

        {Also leave if we got any errors or we got a cancel request}
        if (aProtocolError <> ecOK) or
           (aProtocolStatus = psCancelRequested) then
          Exit;
      end;
    end;
  end;

  function zpBlockError(P : PProtocolData;
                        OkState, ErrorState : TZmodemState;
                        MaxErrors : Cardinal) : Boolean;
    {-Handle routine block/timeout errors, return True if error}
  begin
    with P^ do begin
      Inc(aBlockErrors);
      Inc(aTotalErrors);
      if aBlockErrors > MaxErrors then begin
        zpBlockError := True;
        zpCancel(P);
        apProtocolError(P, ecTooManyErrors);
        zZmodemState := ErrorState;
      end else begin
        zpBlockError := False;
        zZmodemState := OkState;
      end;
    end;
  end;

  function zpReceiveBlock(P : PProtocolData;
                          var Block : TDataBlock) : Bool;
    {-Get a binary data subpacket, return True when block complete (or error)}
  var
    C : AnsiChar;
  begin
    with P^ do begin
      {Assume the block isn't ready}
      zpReceiveBlock := False;

      while aHC.CharReady do begin
        {Handle first pass}
        if (zDataBlockLen = 0) and (zRcvBlockState = rbData) then
          aBlockCheck := CheckInit[zUseCrc32];

        {Get the waiting character}
        aProtocolStatus := psOK;
        zpGetCharEscaped(P, C);
        if zEscapePending or (aProtocolStatus = psCancelRequested) then
          Exit;
        if zControlCharSkip then
          Exit;

        {Always update the block check}
        zpUpdateBlockCheck(P, Ord(C));

        case zRcvBlockState of
          rbData :
            case aProtocolStatus of
              psOK :     {Normal character}
                begin
                  {Check for a long block}
                  Inc(zDataBlockLen);
                  if zDataBlockLen > aBlockLen then begin
                    aProtocolStatus := psLongPacket;
                    Inc(aTotalErrors);
                    Inc(aBlockErrors);
                    zpReceiveBlock := True;
                    Exit;
                  end;

                  {Store the character}
                  Block[zDataBlockLen] := C;
                end;

              psGotCrcE,
              psGotCrcG,
              psGotCrcQ,
              psGotCrcW : {End of DataSubpacket - get/check CRC}
                begin
                  zRcvBlockState := rbCrc;
                  zCrcCnt := 0;
                  aSaveStatus := aProtocolStatus;
                end;
            end;

          rbCrc :
            begin
              Inc(zCrcCnt);
              if (zUseCrc32 and (zCrcCnt = 4)) or
                 (not zUseCrc32 and (zCrcCnt = 2)) then begin
                if not zpVerifyBlockCheck(P) then begin
                  Inc(aBlockErrors);
                  Inc(aTotalErrors);
                  aProtocolStatus := psBlockCheckError;
                end else
                  {Show proper status}
                  aProtocolStatus := aSaveStatus;

                {Say block is ready for processing}
                zpReceiveBlock := True;
                Exit;
              end;
            end;
        end;
      end;
    end;
  end;


  procedure zpExtractFileInfo(P : PProtocolData);
    {-Extracts file information into fields}
  var
    BlockPos  : Cardinal;
    I         : Integer;
    Code      : Integer;
    S         : AnsiString;
    {$IFDEF HugeStr}
    SLen      : Byte;
    {$ELSE}
    SLen      : Byte absolute S;
    {$ENDIF}
    S1        : ShortString;
    S1Len     : Byte absolute S1;
    Name      : ShortString;
    NameExt   : array[0..255] of AnsiChar;
  begin
    with P^ do begin
      {Extract the file name from the data block}
      BlockPos := 1;
      {$IFDEF HugeStr}
      SetLength(S, 1024);
      {$ENDIF}
      while (aDataBlock^[BlockPos] <> #0) and (BlockPos < 255) do begin
        S[BlockPos] := aDataBlock^[BlockPos];
        if S[BlockPos] = '/' then
          S[BlockPos] := '\';
        Inc(BlockPos);
      end;
      SLen := BlockPos - 1;
      {$IFDEF HugeStr}
      SetLength(S, SLen);
      {$ENDIF}
      if (SLen > 0) and (aUpcaseFileNames) then begin
        {$IFDEF HugeStr}
        AnsiUpperBuff(PAnsiChar(S), SLen);
        {$ELSE}
        AnsiUpperBuff(@S[1], SLen);
        {$ENDIF}
      end;

      {Set Pathname}
      {$IFDEF Win32}
      if Length(S) > 255 then
        SetLength(S, 255);
      {$ENDIF}
      StrPCopy(aPathname, S);

      {Should we use its directory or ours?}
      if not FlagIsSet(aFlags, apHonorDirectory) then begin
        Name := ExtractFileName(S);
        StrPCopy(NameExt, Name);
        AddBackSlashZ(aPathName, aDestDir);
        StrLCat(aPathName, NameExt, SizeOf(aPathName));
      end;

      {Extract the file size}
      I := 1;
      Inc(BlockPos);
      while (aDataBlock^[BlockPos] <> #0) and
            (aDataBlock^[BlockPos] <> ' ') and
            (I <= 255) do begin
        S1[I] := aDataBlock^[BlockPos];
        Inc(I); Inc(BlockPos);
      end;
      Dec(I);
      S1Len := I;
      if S1Len = 0 then
        aSrcFileLen := 0
      else begin
        Val(S1, aSrcFileLen, Code);
        if Code <> 0 then
          {Invalid date format, just ignore}
          aSrcFileLen := 0;
      end;
      aBytesRemaining := aSrcFileLen;
      aBytesTransferred := 0;

      {Extract the file date/time stamp}
      I := 1;
      Inc(BlockPos);
      while (aDataBlock^[BlockPos] <> #0) and
            (aDataBlock^[BlockPos] <> ' ') and
            (I <= 255) do begin
        S1[I] := aDataBlock^[BlockPos];
        Inc(I);
        Inc(BlockPos);
      end;
      Dec(I);
      S1Len := I;
      S1 := apTrimZeros(S1);
      if S1 = '' then
        aSrcFileDate := apYMTimeStampToPack(apCurrentTimeStamp)
      else
        aSrcFileDate := apYMTimeStampToPack(apOctalStr2Long(S1));
    end;
  end;

  procedure zpWriteDataBlock(P : PProtocolData);
    {-Call WriteProtocolBlock for the last received DataBlock}
  var
    Failed : Bool;
  begin
    with P^ do begin
      {Write this block}
      Failed := apWriteProtocolBlock(P, aDataBlock^, zDataBlockLen);

      {Process result}
      if Failed then
        zpCancel(P)
      else begin
        Inc(aFileOfs, zDataBlockLen);
        Dec(aBytesRemaining, zDataBlockLen);
        Inc(aBytesTransferred, zDataBlockLen);
      end;
    end;
  end;

  procedure zpPrepareReceive(P : PProtocolData);
    {-Prepare to receive Zmodem parts}
  begin
    with P^ do begin
      {Init the status stuff}
      apResetStatus(P);
      apShowFirstStatus(P);
      NewTimer(aStatusTimer, aStatusInterval);
      aTimerStarted := False;

      {Flush input buffer}
      aHC.FlushInBuffer;

      {Init state variables}
      zHeaderType := ZrInit;
      zZmodemState := rzRqstFile;
      zHeaderState := hsNone;
      aProtocolError := ecOK;
    end;
  end;

  procedure zpReceive(Msg, wParam : Cardinal;
                     lParam : LongInt);
    {-Performs one increment of a Zmodem receive}
  label
    ExitPoint;
  var
    TriggerID   : Cardinal absolute wParam;
    P           : PProtocolData;
    Finished    : Bool;
    C           : AnsiChar;
    StatusTicks : LongInt;
    Dispatcher      : TApdBaseDispatcher;
  begin
    Finished := False;                                                   {!!.01}
    {Get the protocol pointer from data pointer 1}
    Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
    with Dispatcher do begin
      try                                                                {!!.01}
        {with ComPorts[LH(lParam).H] do}
        GetDataPointer(Pointer(P), 1);
      except                                                             {!!.01}
        on EAccessViolation do                                           {!!.01}
          { No access to P^, just exit }                                 {!!.01}
          Exit;
      end;                                                               {!!.01}

    with P^ do begin
      {$IFDEF Win32}
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if zZmodemState = rzDone then begin
        LeaveCriticalSection(aProtSection);
        Exit;
      end;
      {$ENDIF}
        {Set Trigger_ID directly for TriggerAvail messages}
        if Msg = apw_TriggerAvail then
          TriggerID := aDataTrigger;

        repeat
          try                                                            {!!.01}
            if Dispatcher.Logging then
              {$IFDEF Win32}
              Dispatcher.AddDispatchEntry(
                dtZModem,LogZModemState[zZmodemState],GetCurrentThreadID,nil,0);
              {$ELSE}
              Dispatcher.AddDispatchEntry(
                dtZModem,LogZModemState[zZmodemState],0,nil,0);
              {$ENDIF}

            {Check for user abort}
            if aProtocolStatus <> psCancelRequested then begin
              if (Integer(TriggerID) = aNoCarrierTrigger) then begin
                zZmodemState := rzError;
                aProtocolStatus := psAbortNoCarrier;
              end;
              if Msg = apw_ProtocolCancel then begin
                zpCancel(P);
                zZmodemState := rzError;
              end;
            end;

            {Show status at requested intervals and after significant events}
            if aForceStatus or (Integer(TriggerID) = aStatusTrigger) then begin
              if aTimerStarted then
                aElapsedTicks := ElapsedTime(aTimer);
              if TimerTicksRemaining(aStatusTrigger,
                                      StatusTicks) <> 0 then
                StatusTicks := 0;
              if StatusTicks <= 0 then begin
                apShowStatus(P, 0);
                SetTimerTrigger(aStatusTrigger, aStatusInterval, True);
                aForceStatus := False;
              end;
              if Integer(TriggerID) = aStatusTrigger then begin
                {$IFDEF Win32}
                LeaveCriticalSection(aProtSection);
                {$ENDIF}
                Exit;
              end;
            end;

            {Preprocess header requirements}
            case zZmodemState of
              rzWaitFile,
              rzStartData,
              rzWaitEof :
                if TriggerID = aDataTrigger then begin
                  {Header might be present, try to get one}
                  zpCheckForHeader(P);
                  if aProtocolStatus = psCancelRequested then
                    zZmodemState := rzError;
                end else if Integer(TriggerID) = aTimeoutTrigger then
                  {Timed out waiting for something, let state machine handle it}
                  aProtocolStatus := psTimeout
                else
                  {Indicate that we don't have a header}
                  aProtocolStatus := psNoHeader;
            end;

            {Main state processor}
            case zZmodemState of
              rzRqstFile :
                begin
                  zCanCount := 0;

                  {Init pos/flag bytes to zero}
                  LongInt(zTransHeader) := 0;

                  {Set our receive options}
                  zTransHeader[ZF0] := CanFdx or     {Full duplex}
                                       CanOvIO or    {Overlap I/O}
                                       CanFc32 or    {Use Crc32 on frames}
                                       CanBrk;       {Can send break}
                  {If user requested to escape all control chars, set flag} // SWB
                  if (P^.zEscapeControl) then                               // SWB
                    zTransHeader[ZF0] := zTransHeader[ZF0] or EscAll;       // SWB
                  P^.zEscapeAll := P^.zEscapeControl;                       // SWB

                  {Testing shows that Telix needs a delay here}
                  SetTimerTrigger(aTimeoutTrigger, TelixDelay, True);
                  zZmodemState := rzDelay;
                end;

              rzDelay :
                begin
                  {Send the header}
                  zpPutHexHeader(P, zHeaderType);

                  zZmodemState := rzWaitFile;
                  zHeaderState := hsNone;
                  SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end;

            rzSendBlockPrep :
              if TriggerID = aDataTrigger then begin
                while CharReady and (zDiscardCnt < 2) do begin
                  GetChar(C);
                  Inc(zDiscardCnt);
                end;
                if zDiscardCnt = 2 then
                  zZmodemState := rzSendBlock;
              end else if Integer(TriggerID) = aTimeoutTrigger then begin
                Inc(aBlockErrors);
                Inc(aTotalErrors);
                if aTotalErrors < aHandshakeRetry then
                  zZmodemState := rzRqstFile
                else
                  zZmodemState := rzCleanup;
              end;

              rzSendBlock :
                if TriggerID = aDataTrigger then begin
                  {Collect the data subpacket}
                  if zpReceiveBlock(P, aDataBlock^) then
                    if (aProtocolStatus = psBlockCheckError) or
                       (aProtocolStatus = psLongPacket) then
                      {Error receiving block, go try again}
                      zZmodemState := rzRqstFile
                    else
                      {Got block OK, go process}
                      zZmodemState := rzSendInit
                  else if aProtocolStatus = psCancelRequested then
                    zZmodemState := rzError;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timed out waiting for block...}
                  Inc(aBlockErrors);
                  Inc(aTotalErrors);
                  if aBlockErrors < aHandshakeRetry then begin
                    zpPutHexHeader(P, ZNak);
                    SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                    zZmodemState := rzWaitFile;
                    zHeaderState := hsNone;
                  end else
                    zZmodemState := rzCleanup;
                end;

              rzSendInit :
                begin
                  {Save attention string}
                  Move(aDataBlock^, zAttentionStr, MaxAttentionLen);

                  {Turn on escaping if transmitter requests it}
                  zEscapeAll := (zRcvHeader[ZF0] and EscAll) = EscAll;

                  {Needs an acknowledge}
                  zpPutHexHeader(P, ZAck);
                  {Go wait for ZFile packet}
                  zZmodemState := rzWaitFile;
                  SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end;

              rzWaitFile :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      case zRcvFrame of
                        ZrQInit : {Go send ZrInit again}
                          zZmodemState := rzRqstFile;
                        ZFile : {Beginning of file transfer attempt}
                          begin
                            {Save conversion and transport options}
                            zConvertOpts := zRcvHeader[ZF0];
                            zTransportOpts := zRcvHeader[ZF2];

                            {Save file mgmt options (if not overridden)}
                            if not zFileMgmtOverride then
                              zFileMgmtOpts := zRcvHeader[ZF1];

                            {Set file mgmt default if none specified}
                            if zFileMgmtOpts = 0 then
                              zFileMgmtOpts := zfWriteProtect;

                            {Start collecting the ZFile's data subpacket}
                            zZmodemState := rzCollectFile;
                            aBlockErrors := 0;
                            aTotalErrors := 0;
                            zDataBlockLen := 0;
                            zRcvBlockState := rbData;
                            SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                          end;

                        ZSInit :  {Sender's transmission options}
                          begin
                            {Start collecting ZSInit's data subpacket}
                            aBlockErrors := 0;
                            zDataBlockLen := 0;
                            zRcvBlockState := rbData;
                            SetTimerTrigger(aTimeoutTrigger,
                                             aHandshakeWait, True);
                            if zWasHex then begin
                              zZmodemState := rzSendBlockPrep;
                              zDiscardCnt := 0;
                            end else
                              zZmodemState := rzSendBlock;
                          end;

                        ZFreeCnt : {Sender is requesting a count of our freespace}
                          begin
                            LongInt(zTransHeader) := DiskFree(0);
                            zpPutHexHeader(P, ZAck);
                          end;

                        ZCommand : {Commands not implemented}
                          begin
                            zpPutHexHeader(P, ZNak);
                          end;

                        ZCompl,
                        ZFin:      {Finished}
                          begin
                            zZmodemState := rzSendFinish;
                            aBlockErrors := 0;
                          end;
                      end;
                      SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                    end;
                  psNoHeader :
                    {Keep waiting for a header} ;
                  psBlockCheckError,
                  psTimeout :
                    zpBlockError(P, rzRqstFile, rzCleanup, aHandshakeRetry);
                end;

              rzCollectFile :
                if TriggerID = aDataTrigger then begin
                  {Collect the data subpacket}
                  if zpReceiveBlock(P, aDataBlock^) then
                    if (aProtocolStatus = psBlockCheckError) or
                       (aProtocolStatus = psLongPacket) then
                      {Error getting block, go try again}
                      zZmodemState := rzRqstFile
                    else
                      {Got block OK, go extract file info}
                      zZmodemState := rzStartFile
                  else if aProtocolStatus = psCancelRequested then
                    zZmodemState := rzError;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout collecting block}
                  Inc(aBlockErrors);
                  Inc(aTotalErrors);
                  if aBlockErrors < aHandshakeRetry then begin
                    zpPutHexHeader(P, ZNak);
                    SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  end else
                    zZmodemState := rzCleanup;
                end;

              rzStartFile :
                begin
                  {Got the data subpacket to the ZFile, extract the file info}
                  zpExtractFileInfo(P);

                  {Call user's LogFile function}
                  aProtocolStatus := psOK;
                  apLogFile(P, lfReceiveStart);

                  {Accept this file}
                  if not apAcceptFile(P, aPathName) then begin
                    zHeaderType := ZSkip;
                    aProtocolStatus := psSkipFile;
                    apLogFile(P, lfReceiveSkip);
                    zZmodemState := rzRqstFile;
                    aForceStatus := True;
                    goto ExitPoint;
                  end;

                  {Prepare to write this file}
                  apPrepareWriting(P);
                  if aProtocolError = ecOK then begin
                    case aProtocolStatus of
                      psCantWriteFile,
                      psFileDoesntExist : {Skip this file}
                        begin
                          zHeaderType := ZSkip;
                          aProtocolStatus := psSkipFile;
                          apLogFile(P, lfReceiveSkip);
                          zZmodemState := rzRqstFile;
                          aForceStatus := True;
                          goto ExitPoint;
                        end;
                    end;
                  end else begin
                    zpCancel(P);
                    zZmodemState := rzError;
                    goto ExitPoint;
                  end;

                  {Start protocol timer now}
                  NewTimer(aTimer, 1);
                  aTimerStarted := True;

                  {Go send the initial ZrPos}
                  zZmodemState := rzSync;
                  aForceStatus := True;
                end;

              rzSync :
                begin
                  {Incoming data will just get discarded so flush inbuf now}
                  FlushInBuffer;

                  {Insert file size into header and send to remote}
                  LongInt(zTransHeader) := aFileOfs;
                  zpPutHexHeader(P, ZrPos);

                  {Set status info}
                  aBytesRemaining := aSrcFileLen - aFileOfs;
                  aBytesTransferred := aFileOfs;

                  zZmodemState := rzStartData;
                  zHeaderState := hsNone;
                  aBlockErrors := 0;
                  SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end;

              rzStartData :
                case aProtocolStatus of
                  psGotHeader :
                    case zRcvFrame of
                      ZData :  {One or more data subpackets follow}
                        begin
                          if aFileOfs <> zLastFileOfs then begin
                            Inc(aBlockErrors);
                            Inc(aTotalErrors);
                            if aBlockErrors > MaxBadBlocks then begin
                              zpCancel(P);
                              apProtocolError(P, ecTooManyErrors);
                              zZmodemState := rzError;
                              goto ExitPoint;
                            end;
                            zpPutAttentionString(P);
                            zZmodemState := rzSync;
                          end else begin
                            zZmodemState := rzCollectData;
                            zDataBlockLen := 0;
                            zRcvBlockState := rbData;
                            SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                         end;
                       end;
                      ZNak : {Nak received}
                        begin
                          Inc(aTotalErrors);
                          Inc(aBlockErrors);
                          if aBlockErrors > MaxBadBlocks then begin
                            zpCancel(P);
                            apProtocolError(P, ecTooManyErrors);
                            zZmodemState := rzError;
                          end else
                            {Resend ZrPos}
                            zZmodemState := rzSync;
                        end;
                      ZFile : {File frame}
                        {Already got a File frame, just go send ZrPos again}
                        zZmodemState := rzSync;
                      ZEof : {End of current file}
                        begin
                          aProtocolStatus := psEndFile;
                          zZmodemState := rzEndOfFile;
                        end;
                      else begin
                        {Error during GetHeader}
                        Inc(aTotalErrors);
                        Inc(aBlockErrors);
                        if aBlockErrors > MaxBadBlocks then begin
                          zpCancel(P);
                          apProtocolError(P, ecTooManyErrors);
                          zZmodemState := rzError;
                          goto ExitPoint;
                        end;
                        zpPutAttentionString(P);
                        zZmodemState := rzSync;
                      end;
                    end;
                  psNoHeader :
                    {Just keep waiting for header} ;
                  psBlockCheckError,
                  psTimeout :
                    zpBlockError(P, rzSync, rzError, aHandshakeRetry);
                end;

              rzCollectData :
                if TriggerID = aDataTrigger then begin
                  SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);

                  {Collect the data subpacket}
                  if zpReceiveBlock(P, aDataBlock^) then begin
                    {Block is okay -- process it}
                    case aProtocolStatus of
                      psCancelRequested : {Cancel requested}
                        zZmodemState := rzError;
                      psGotCrcW : {Send requests a wait}
                        begin
                          {Write this block}
                          zpWriteDataBlock(P);
                          if aProtocolError = ecOK then begin
                            {Acknowledge with the current file position}
                            LongInt(zTransHeader) := aFileOfs;
                            zpPutHexHeader(P, ZAck);
                            zZmodemState := rzStartData;
                            zHeaderState := hsNone;
                          end else begin
                            zpCancel(P);
                            zZmodemState := rzError;
                          end;
                        end;
                      psGotCrcQ : {Ack requested}
                        begin
                          {Write this block}
                          zpWriteDataBlock(P);
                          if aProtocolError = ecOK then begin
                            LongInt(zTransHeader) := aFileOfs;
                            zpPutHexHeader(P, ZAck);
                            {Don't change state - will get next data subpacket}
                          end else begin
                            zpCancel(P);
                            zZmodemState := rzError;
                          end;
                        end;
                      psGotCrcG : {Normal subpacket - no response necessary}
                        begin
                          {Write this block}
                          zpWriteDataBlock(P);
                          if aProtocolError <> ecOK then begin
                            zpCancel(P);
                            zZmodemState := rzError;
                          end;
                        end;
                      psGotCrcE : {Last data subpacket}
                        begin
                          {Write this block}
                          zpWriteDataBlock(P);
                          if aProtocolError = ecOK then begin
                            zZmodemState := rzWaitEof;
                            zHeaderState := hsNone;
                            aBlockErrors := 0;
                          end else begin
                            zpCancel(P);
                            zZmodemState := rzError;
                          end;
                        end;
                      else begin
                        {Error in block}
                        if aBlockErrors < MaxBadBlocks then begin
                          zpPutAttentionString(P);
                          zZmodemState := rzSync;
                        end else begin
                          zpCancel(P);
                          apProtocolError(P, ecTooManyErrors);
                          zZmodemState := rzError;
                        end;
                        goto ExitPoint;
                      end;
                    end;

                    {Prepare to collect next block}
                    aForceStatus := True;
                    zDataBlockLen := 0;
                    zRcvBlockState := rbData;
                  end else if aProtocolStatus = psCancelRequested then
                    zZmodemState := rzError

                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout collecting datasubpacket}
                  Inc(aBlockErrors);
                  Inc(aTotalErrors);
                  if aBlockErrors < MaxBadBlocks then begin
                    zpPutAttentionString(P);
                    zZmodemState := rzSync;
                  end else begin
                    zpCancel(P);
                    zZmodemState := rzError;
                  end;
                end;

              rzWaitEof :
                case aProtocolStatus of
                  psGotHeader :
                    case zRcvFrame of
                      ZEof : {End of current file}
                        begin
                          aProtocolStatus := psEndFile;
                          apShowStatus(P, 0);
                          apFinishWriting(P);
                          if aProtocolError = ecOK then
                            apLogFile(P, lfReceiveOk)
                          else
                            apLogFile(P, lfReceiveFail);

                          {Go get the next file}
                          zZmodemState := rzRqstFile;
                        end;
                      else begin
                        {Error during GetHeader}
                        Inc(aTotalErrors);
                        Inc(aBlockErrors);
                        if aBlockErrors > MaxBadBlocks then begin
                          zpCancel(P);
                          apProtocolError(P, ecTooManyErrors);
                          zZmodemState := rzError;
                          goto ExitPoint;
                        end;
                        zpPutAttentionString(P);
                        zZmodemState := rzSync;
                      end;
                    end;
                  psNoHeader :
                    {Just keep collecting rest of header} ;
                  psBlockCheckError,
                  psTimeout :
                    zpBlockError(P, rzSync, rzError, aHandshakeRetry);
                end;

              rzEndOfFile :
                if aFileOfs = zLastFileOfs then begin
                  apFinishWriting(P);

                  {Send Proper status to user logging routine}
                  if aProtocolError = ecOK then
                    apLogFile(P, lfReceiveOk)
                  else
                    apLogFile(P, lfReceiveFail);
                  zZmodemState := rzRqstFile;
                end else
                  zZmodemState := rzSync;

              rzSendFinish :
                begin
                  {Insert file position into header}
                  LongInt(zTransHeader) := aFileOfs;
                  zpPutHexHeader(P, ZFin);
                  zZmodemState := rzCollectFinish;
                  SetTimerTrigger(aTimeoutTrigger, aFinishWait, True);
                  zOCnt := 0;
                end;

              rzCollectFinish :
                if TriggerID = aDataTrigger then begin
                  GetChar(C);
                  if C = 'O' then begin
                    Inc(zOCnt);
                    if zOCnt = 2 then
                      zZmodemState := rzCleanup;
                  end;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Retry 3 times only (same as DSZ)}
                  Inc(aBlockErrors);
                  Inc(aTotalErrors);
                  if aBlockErrors < zFinishRetry then
                    {Go send ZFin again}
                    zZmodemState := rzSendFinish
                  else
                    {Cleanup anyway}
                    zZmodemState := rzCleanup;
                end;

              rzError :
                begin
                  if aFileOpen then begin
                    apFinishWriting(P);
                    apLogFile(P, lfReceiveFail);
                  end;

                  {Wait for cancel to go out}
                  if OutBuffUsed > 0 then begin
                    SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                    SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                    zZmodemState := rzWaitCancel;
                  end else
                    zZmodemState := rzCleanup;
                end;

              rzWaitCancel :
                {Cancel went out or we timed out, doesn't matter which}
                zZmodemState := rzCleanup;

              rzCleanup :
                begin
                  apShowLastStatus(P);
                  FlushInBuffer;
                  zZmodemState := rzDone;
                  apSignalFinish(P);
                end;
            end;

    ExitPoint:
            {Stay in state machine or leave?}
            case zZmodemState of
              {Stay in state machine for these states}
              rzRqstFile,
              rzSendInit,
              rzSync,
              rzStartFile,
              rzGotData,
              rzEndOfFile,
              rzSendFinish,
              rzError,
              rzCleanup            : Finished := False;

              {Stay in state machine only if more data ready}
              rzSendBlockPrep,
              rzSendBlock,
              rzWaitFile,
              rzWaitEof,
              rzCollectData,
              rzStartData,
              rzCollectFinish,
              rzCollectFile        : Finished := not CharReady;

              {Exit state machine on these states (waiting for trigger hit)}
              rzDelay,
              rzWaitCancel,
              rzDone               : Finished := True;
              else                   Finished := True;
            end;

            {Clear header state if we just processed a header}
            if (aProtocolStatus = psGotHeader) or
               (aProtocolStatus = psNoHeader) then
              aProtocolStatus := psOK;
            if zHeaderState = hsGotHeader then
              zHeaderState := hsNone;

            {If staying in state machine force data ready}
            TriggerID := aDataTrigger;
          except                                                         {!!.01}
            on EAccessViolation do begin                                 {!!.01}
              Finished := True;                                          {!!.01}
              aProtocolError := ecAbortNoCarrier;                        {!!.01}
              apSignalFinish(P);                                         {!!.01}
            end;                                                         {!!.01}
          end;                                                           {!!.01}
        until Finished;
      end;
      {$IFDEF Win32}                                                     {!!.01}
      LeaveCriticalSection(P^.aProtSection);                             {!!.01}
      {$ENDIF}                                                           {!!.01}
    end;
  end;

  procedure zpPutBinaryHeader(P : PProtocolData; FrameType : AnsiChar);
    {-Sends a binary header (Crc16 or Crc32)}
  var
    I : Integer;
  begin
    with P^ do begin
      zUseCrc32 := zCanCrc32;

      {Send '*'<DLE>}
      aHC.PutChar(ZPad);
      aHC.PutChar(ZDle);

      {Send frame identifier}
      if zUseCrc32 then begin
        aHC.PutChar(ZBin32);
        aBlockCheck := $FFFFFFFF;
      end else begin
        aHC.PutChar(ZBin);
        aBlockCheck := 0;
      end;

      {Send frame type}
      zpPutCharEscaped(P, FrameType);
      zpUpdateBlockCheck(P, Ord(FrameType));

      {Put the position/flags data bytes}
      for I := 0 to 3 do begin
        zpPutCharEscaped(P, AnsiChar(zTransHeader[I]));
        zpUpdateBlockCheck(P, Ord(zTransHeader[I]));
      end;

      {Put the Crc bytes}
      zpSendBlockCheck(P);

      {Note frame type for status}
      zLastFrame := FrameType;
    end;
  end;

  function zpEscapeChar(P : PProtocolData; C : AnsiChar) : Boolean;
    {-Return True if C needs to be escaped}
  var
    C1 : AnsiChar;
    C2 : AnsiChar;
  begin
    with P^ do begin
      {Check for chars to escape}
      if zEscapeAll and ((Byte(C) and $60) = 0) then
        {Definitely needs escaping}
        zpEscapeChar := True
      else if Ord(C) and $11 = 0 then
        {Definitely does not need escaping}
        zpEscapeChar := False
      else begin
        {Might need escaping}
        case C of
          cXon, cXoff, cDle,        {Escaped control chars}
          cXonHi, cXoffHi, cDleHi,  {Escaped hibit control chars}
          ZDle :                    {Escape the escape char}
            zpEscapeChar := True;
          else begin
            C1 := AnsiChar(Byte(C) and $7F);
            C2 := AnsiChar(Byte(zLastChar) and $7F);
            zpEscapeChar := ((C1 = cCR) and (C2 = #$40));
          end;
        end;
      end;
    end;
  end;

  procedure zpEscapeBlock(P : PProtocolData;
                          var Block : TDataBlock;
                          BLen : Cardinal);
    {-Escape data from Block into zWorkBlock}
  var
    I : Cardinal;
    C : AnsiChar;
  begin
    with P^ do begin
      {Initialize aBlockCheck}
      if zCanCrc32 then begin
        zUseCrc32 := True;
        aBlockCheck := $FFFFFFFF;
      end else begin
        zUseCrc32 := False;
        aBlockCheck := 0;
      end;

      {Escape the data into zWorkBlock}
      zWorkSize := 1;
      for I := 1 to BLen do begin
        {Escape the entire block}
        C := Block[I];
        zpUpdateBlockCheck(P, Ord(C));
        if zpEscapeChar(P, C) then begin
          {This character needs escaping, stuff a ZDle and escape it}
          zWorkBlock^[zWorkSize] := zDle;
          Inc(zWorkSize);
          C := AnsiChar(Ord(C) xor $40);
        end;

        {Stuff the character}
        zWorkBlock^[zWorkSize] := C;
        Inc(zWorkSize);
        zLastChar := C;
      end;
      Dec(zWorkSize);
    end;
  end;

  procedure zpTransmitBlock(P : PProtocolData);
      {-Transmits one data subpacket from Block}
  begin
    with P^ do begin
      if zWorkSize <> 0 then
        aHC.PutBlock(zWorkBlock^, zWorkSize);
      {Send the frame type}
      zpUpdateBlockCheck(P, Byte(zTerminator));
      aHC.PutChar(ZDle);
      aHC.PutChar(zTerminator);

      {Send the block check characters}
      zpSendBlockCheck(P);

      {Follow CrcW subpackets with an Xon}
      if zTerminator = ZCrcW then
        aHC.PutChar(cXon);

      {Update status vars}
      aLastBlockSize := zDataBlockLen;
      Inc(aFileOfs, zDataBlockLen);
      Inc(aBytesTransferred, zDataBlockLen);
      Dec(aBytesRemaining, zDataBlockLen);
      aForceStatus := True;
    end;
  end;

  procedure zpExtractReceiverInfo(P : PProtocolData);
    {-Extract receiver info from last ZrInit header}
  const
    Checks : array[Boolean] of Cardinal = (bcCrc16, bcCrc32);
  begin
    with P^ do begin
      {Extract info from received ZrInit}
      zRcvBuffLen := zRcvHeader[ZP0] + ((zRcvHeader[ZP1]) shl 8);
      zCanCrc32 := (zRcvHeader[ZF0] and CanFC32) = CanFC32;
      aCheckType := Checks[zCanCrc32];
      zEscapeAll := (zRcvHeader[ZF0] and EscAll) = EscAll;
    end;
  end;

  procedure zpInsertFileInfo(P : PProtocolData);
    {-Build a ZFile data subpacket}
  var
    I    : Cardinal;
    Name : string[fsName];
    CA   : TCharArray;
    S    : String[fsPathname];
    Len  : Byte;
  begin
    with P^ do begin
      {Make a file header record}
      FillChar(aDataBlock^, SizeOf(TDataBlock) , 0);

      {Fill in the file name}
      S := StrPas(aPathName);
      Name := ExtractFileName(S);
      if FlagIsSet(aFlags, apIncludeDirectory) then
        StrPCopy(CA, S)
      else
        StrPCopy(CA, Name);

      {Change name to lower case, change '\' to '/'}
      Len := StrLen(CA);
      AnsiLowerBuff(CA, Len);
      for I := 0 to Len-1 do begin
        {CA[I] := LoCaseMac(CA[I]);}
        if CA[I] = '\' then
          CA[I] := '/';
      end;
      Move(CA[0], aDataBlock^, Len);

      {Fill in file size}
      Str(aSrcFileLen, S);
      Move(S[1], aDataBlock^[Len+2], Length(S));
      Inc(Len, Length(S)+1);

      {Convert time stamp to Ymodem format and stuff in aDataBlock}
      if aSrcFileDate <> 0 then begin
        S := ' ' + apOctalStr(apPackToYMTimeStamp(aSrcFileDate));
        Move(S[1], aDataBlock^[Len+1], Length(S));
        Inc(Len, Length(S)+1);
      end;

      {Save the length of the file info string for the ZFile header}
      zDataBlockLen := Len;

      {Take care of status information}
      aBytesRemaining := aSrcFileLen;
      aBytesTransferred := 0;
      aForceStatus := True;
    end;
  end;

  procedure zpPrepareTransmit(P : PProtocolData);
    {-Transmit all files that fit the Mask}
  const
    MinSize : array[Boolean] of Cardinal = (2048+30, 16384+30);
  var
    InSize, OutSize : Cardinal;
  begin
    with P^ do begin
      {Check buffer sizes (again)}
      aHC.ValidDispatcher.BufferSizes(InSize, OutSize);
      if OutSize < MinSize[FlagIsSet(aFlags, apZmodem8K)] then begin
        aProtocolError := ecOutputBufferTooSmall;
        Exit;
      end;

      {Reset status vars}
      apResetStatus(P);
      apShowFirstStatus(P);
      NewTimer(aStatusTimer, aStatusInterval);
      aTimerStarted := False;

      {State machine inits}
      zHeaderState := hsNone;
      aForceStatus := False;
      zZmodemState := tzInitial;
      aProtocolError := ecOK;
    end;
  end;

  procedure zpGotZrPos(P : PProtocolData);
    {-Got an unsolicited ZRPOS, must be due to bad block}
  begin
    with P^ do begin
      Inc(aBlockErrors);
      Inc(aTotalErrors);
      aFileOfs := LongInt(zRcvHeader);
      if aFileOfs > aSrcFileLen then
        aFileOfs := aSrcFileLen;
      aBytesTransferred := aFileOfs;
      aBytesRemaining := aSrcFileLen - aBytesTransferred;
      if aBlockLen > 256 then
        aBlockLen := aBlockLen shr 1;
      aLastBlockSize := aBlockLen;
      zTookHit := True;
      zGoodAfterBad := 0;
      aHC.FlushOutBuffer;
      zZmodemState := tzStartData;
    end;
  end;

  procedure zpProcessHeader(P : PProtocolData);
    {-Process a header}
  begin
    with P^ do begin
      case aProtocolStatus of
        psGotHeader :
          case zRcvFrame of
            ZCan, ZAbort : {Receiver says quit}
              begin
                aProtocolStatus := psCancelRequested;
                aForceStatus := True;
                zZmodemState := tzError;
              end;
            ZAck :
              zZmodemState := tzStartData;
            ZrPos :        {Receiver is sending its desired file position}
              zpGotZrPos(P);
            else begin
              {Garbage, send Nak}
              zpPutBinaryHeader(P, ZNak);
            end;
          end;
        psBlockCheckError,
        psTimeout :
          zpBlockError(P, tzStartData, tzError, MaxBadBlocks);
      end;
    end;
  end;

  procedure zpTransmit(Msg, wParam : Cardinal;
                      lParam : LongInt);
    {-Performs one increment of a Zmodem transmit}
  label
    ExitPoint;
  const
    RZcommand : array[0..3] of AnsiChar = 'rz'+cCr;
    FreeMargin = 60;
  var
    TriggerID   : Cardinal absolute wParam;
    NewInterval : Cardinal;
    Finished    : Bool;
    Crc32       : LongInt;
    P           : PProtocolData;
    Secs        : LongInt;
    StatusTicks : LongInt;
    StartTick   : DWORD;
    Dispatcher  : TApdBaseDispatcher;
    saveCrc32   : Boolean;                                                  // SWB

    { BCB compiler bug workaround }
    procedure CheckFinished;
    begin
      Finished := not Dispatcher.CharReady;
    end;

  begin
    StartTick := AdTimeGetTime;
    Finished := False;                                                   {!!.01}
    try                                                                  {!!.01}
      {Get the protocol pointer from data pointer 1}
      Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
      with Dispatcher do
        GetDataPointer(Pointer(P), 1);
    except                                                               {!!.01}
      on EAccessViolation do                                             {!!.01}
        { No access to P^, just exit }                                   {!!.01}
        Exit;                                                            {!!.01}
    end;                                                                 {!!.01}

    with P^ do begin
      {$IFDEF Win32}
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if zZmodemState = tzDone then begin
        LeaveCriticalSection(aProtSection);
        Exit;
      end;
      {$ENDIF}
        {Force TriggerID for TriggerAvail messages}
        if Msg = apw_TriggerAvail then
          TriggerID := aDataTrigger;

        repeat
          try                                                            {!!.01}
            if Dispatcher.Logging then
              {$IFDEF Win32}
              Dispatcher.AddDispatchEntry(
                dtZModem,LogZModemState[zZmodemState],GetCurrentThreadID,nil,0);
              {$ELSE}
              Dispatcher.AddDispatchEntry(
                dtZModem,LogZModemState[zZmodemState],0,nil,0);
              {$ENDIF}

            {Check for user abort (but not twice)}
            if aProtocolStatus <> psCancelRequested then begin
              if (Integer(TriggerID) = aNoCarrierTrigger) then begin
                zZmodemState := tzError;
                aProtocolStatus := psAbortNoCarrier;
              end;
              if Msg = apw_ProtocolCancel then begin
                zpCancel(P);
                zZmodemState := tzError;
              end;
            end;

            {Show status at requested intervals and after significant events}
            if aForceStatus or (Integer(TriggerID) = aStatusTrigger) then begin
              if aTimerStarted then
                aElapsedTicks := ElapsedTime(aTimer);

              {Use user-specified status interval unless draining eof}
              if zZmodemState = tzDrainEof then
                NewInterval := DrainingStatusInterval
              else
                NewInterval := aStatusInterval;

              if Dispatcher.TimerTicksRemaining(aStatusTrigger,
                                      StatusTicks) <> 0 then
                StatusTicks := 0;
              if StatusTicks <= 0 then begin
                apShowStatus(P, 0);
                Dispatcher.SetTimerTrigger(aStatusTrigger, NewInterval, True);
                aForceStatus := False;
              end;

              if Integer(TriggerID) = aStatusTrigger then begin
                {$IFDEF Win32}
                LeaveCriticalSection(aProtSection);
                {$ENDIF}
                Exit;
              end;
            end;

            {Preprocess header requirements}
            case zZmodemState of
              tzHandshake,
              tzCheckFile,
              tzCheckEOF,
              tzDrainEof,
              tzCheckFinish,
              tzSendData,
              tzWaitAck,
              tzCheckSInit :                                                // SWB
                if TriggerID = aDataTrigger then begin
                  {Header might be present, try to get one}
                  zpCheckForHeader(P);
                  if aProtocolStatus = psCancelRequested then
                    zZmodemState := tzError;
                end else if Integer(TriggerID) = aTimeoutTrigger then
                  {Timeout, let state machine handle it}
                  aProtocolStatus := psTimeout
                else
                  {Indicate no header yet}
                  aProtocolStatus := psNoHeader;
            end;

            {Process the current state}
            case zZmodemState of
              tzInitial :
                begin
                  zCanCount := 0;

                  {Send RZ command (via the attention string)}
                  Move(RZcommand, zAttentionStr, SizeOf(RZcommand));
                  zpPutAttentionString(P);
                  FillChar(zAttentionStr, SizeOf(zAttentionStr), 0);

                  {Send ZrQinit header (requests receiver's ZrInit)}
                  LongInt(zTransHeader) := zZRQINITValue;
                  zpPutHexHeader(P, ZrQInit);
                  aBlockErrors := 0;
                  aTotalErrors := 0;
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  zZmodemState := tzHandshake;
                  zHeaderState := hsNone;
                end;

              tzHandshake :
                case aProtocolStatus of
                  psGotHeader :
                    case zRcvFrame of
                      ZrInit :     {Got ZrInit, extract info}
                        begin
                          zpExtractReceiverInfo(P);
                          zZmodemState := tzGetFile;
                          {If user requested escaped control chars, send ZSInit} // SWB
                          if (zEscapeControl and (not zEscapeAll)) then     // SWB
                            zZmodemState := tzSInit;                        // SWB
                        end;
                      ZChallenge : {Receiver is challenging, respond with same number}
                        begin
                          zTransHeader := zRcvHeader;
                          zpPutHexHeader(P, ZAck);
                        end;
                      ZCommand :   {Commands not supported}
                        zpPutHexHeader(P, ZNak);
                      ZrQInit :    {Remote is trying to transmit also, do nothing}
                        ;
                      else         {Unexpected reply, nak it}
                        zpPutHexHeader(P, ZNak);
                    end;
                  psNoHeader :
                    {Keep waiting for header} ;
                  psBlockCheckError,
                  psTimeout  : {Send another ZrQinit}
                    if not zpBlockError(P, tzHandshake,
                                        tzError, aHandshakeRetry) then begin
                      zpPutHexHeader(P, ZrQInit);
                      Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                    end;
                  end;

              tzSInit:                                                      // SWB
                begin                                                       // SWB
                  LongInt(zTransHeader) := 0;                               // SWB
                  if (zEscapeControl and (not zEscapeAll)) then             // SWB
                      zTransHeader[ZF0] := TESCtl;                          // SWB
                  zpPutHexHeader(P, ZSInit);                                // SWB
                  zEscapeAll := zEscapeControl;                             // SWB
                  zTerminator := ZCrcW;                                     // SWB
                  aDataBlock^[1] := #0;                                     // SWB
                  zDataBlockLen := 1;                                       // SWB
                  {The data block following ZSInit must have a 16 bit       // SWB
                   bit check sum}                                           // SWB
                  saveCrc32 := zCanCrc32;                                   // SWB
                  zCanCrc32 := False;                                       // SWB
                  zpEscapeBlock(P, aDataBlock^, zDataBlockLen);             // SWB
                  zpTransmitBlock(P);                                       // SWB
                  zCanCrc32 := saveCrc32;                                   // SWB
                  zZmodemState := tzCheckSInit;                             // SWB
                end;                                                        // SWB

              tzCheckSInit:                                                 // SWB
                case aProtocolStatus of                                     // SWB
                  psGotHeader :                                             // SWB
                    case zRcvFrame of                                       // SWB
                      ZrInit : {Got an extra ZrInit, ignore it}             // SWB
                        ;                                                   // SWB
                      ZAck :                                                // SWB
                        zZmodemState := tzGetFile;                          // SWB
                    end;                                                    // SWB
                  psNoHeader : {Keep waiting for header}                    // SWB
                    ;                                                       // SWB
                  psBlockCheckError,                                        // SWB
                  psTimeout :  {Timeout waiting for response to ZSInit}     // SWB
                    zZmodemState := tzInitial;                              // SWB
                end;                                                        // SWB

              tzGetFile :
                begin
                  {Get the next file to send}
                  if not apNextFile(P, aPathname) then begin
                    zZmodemState := tzSendFinish;
                    goto ExitPoint;
                  end;
                  aFilesSent := True;

                  {Let all hooks see an upper case pathname}
                  if aUpcaseFileNames then
                    AnsiUpper(aPathName);

                  {Zero out status fields in case status msg is waiting}
                  aBytesTransferred := 0;
                  aBytesRemaining := 0;

                  {Show file name to user logging routine}
                  apLogFile(P, lfTransmitStart);

                  {Prepare to read file blocks}
                  apPrepareReading(P);
                  if aProtocolError <> ecOK then begin
                    zpCancel(P);
                    zZmodemState := tzError;
                    goto ExitPoint;
                  end;

                  {Start protocol timer now}
                  NewTimer(aTimer, 1);
                  aTimerStarted := True;

                  {Build the header data area}
                  LongInt(zTransHeader) := 0;
                  zTransHeader[ZF1] := zFileMgmtOpts;
                  if zReceiverRecover then
                    zTransHeader[ZF0] := FileRecover;

                  {Insert file information into header}
                  zpInsertFileInfo(P);
                  aForceStatus := True;
                  zZmodemState := tzSendFile;
                end;

              tzSendFile :
                begin
                  {Send the ZFile header and data subpacket with file info}
                  zpPutBinaryHeader(P, ZFile);
                  zTerminator := ZCrcW;
                  zpEscapeBlock(P, aDataBlock^, zDataBlockLen);
                  zpTransmitBlock(P);

                  {Clear status vars that zpTransmitBlock changed}
                  aBytesTransferred := 0;
                  aBytesRemaining := 0;

                  {Go wait for response}
                  aBlockErrors := 0;
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  zZmodemState := tzCheckFile;
                  zHeaderState := hsNone;
                end;

              tzCheckFile :
                case aProtocolStatus of
                  psGotHeader :
                    case zRcvFrame of
                      ZrInit : {Got an extra ZrInit, ignore it}
                        ;
                      ZCrc :   {Receiver is asking for Crc32 of the file, send it}
                        begin
                          Crc32 := apCrc32OfFile(P, aPathName, 0);
                          if aProtocolError = ecOK then begin
                            LongInt(zTransHeader) := Crc32;
                            zpPutHexHeader(P, ZCrc);
                          end else
                            zZmodemState := tzError;
                        end;
                      ZSkip :  {Receiver wants to skip this file}
                        begin
                          aProtocolStatus := psSkipFile;
                          apShowStatus(P, 0);

                          {Close file and log skip}
                          apFinishReading(P);
                          apLogFile(P, lfTransmitSkip);

                          {Go look for another file}
                          zZmodemState := tzGetFile;
                        end;
                      ZrPos :  {Receiver tells us where to seek in our file}
                        begin
                          {Get file offset}
                          aFileOfs := LongInt(zRcvHeader);
                          aBytesTransferred := aFileOfs;
                          aInitFilePos := aFileOfs;
                          aBytesRemaining := aSrcFileLen - aBytesTransferred;

                          {Go send the data subpackets}
                          zZmodemState := tzStartData;
                        end;
                    end;
                  psNoHeader : {Keep waiting for header}
                    ;
                  psBlockCheckError,
                  psTimeout :  {Timeout waiting for response to ZFile}
                    if not zpBlockError(P, tzCheckFile,
                                        tzError, aHandshakeRetry) then begin
                      {Resend ZFile}
                      zpPutBinaryHeader(P, ZFile);

                      zpTransmitBlock(P);
                      Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                    end;
                end;

              tzStartData :
                begin
                  {Drain trailing chars from inbuffer...}
                  Dispatcher.FlushInBuffer;

                  {...and kill whatever might still be in the output buffer}
                  Dispatcher.FlushOutBuffer;

                  {Get ready}
                  zDataInTransit := 0;
                  aBlockErrors := 0;

                  {Send ZData header}
                  LongInt(zTransHeader) := aFileOfs;
                  zpPutBinaryHeader(P, ZData);

                  zZmodemState := tzEscapeData;
                end;

              tzEscapeData :
                begin
                  {Get a block to send}
                  if zTookHit then begin
                    Inc(zGoodAfterBad);
                    if zGoodAfterBad > 4 then begin
                      zTookHit := False;
                      if aBlockLen < ZMaxBlock[zUse8KBlocks] then
                        aBlockLen := ZMaxBlock[zUse8KBlocks];
                      aLastBlockSize := aBlockLen;
                    end;
                  end;
                  zDataBlockLen := aBlockLen;
                  aLastBlock := apReadProtocolBlock(P, aDataBlock^, zDataBlockLen);
                  if aProtocolError <> ecOK then begin
                    zpCancel(P);
                    zZmodemState := tzError;
                    goto ExitPoint;
                  end;

                  {Show the new data on the way}
                  if zRcvBuffLen <> 0 then
                    Inc(zDataInTransit, zDataBlockLen);

                  {Set the terminator}
                  if aLastBlock then
                    {Tell receiver its the last subpacket}
                    zTerminator := ZCrcE
                  else if (zRcvBuffLen <> 0) and
                          (zDataInTransit >= Integer(zRcvBuffLen)) then begin
                    {Receiver's buffer is nearly full, wait for acknowledge}
                    zTerminator := ZCrcW;
                  end else
                    {Normal data subpacket, no special action}
                    zTerminator := ZCrcG;

                  {Escape this data into zWorkBlock}
                  zpEscapeBlock(P, aDataBlock^, zDataBlockLen);

                  zZmodemState := tzSendData;
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                  Dispatcher.SetStatusTrigger(aOutBuffFreeTrigger, zWorkSize+FreeMargin, True);
                  aBlockErrors := 0;
                end;

              tzSendData :
                if (Integer(TriggerID) = aOutBuffFreeTrigger) then begin
                  zpTransmitBlock(P);
                  if aLastBlock then begin
                    zZmodemState := tzSendEof;
                    aBlockErrors := 0;
                  end else if zTerminator = ZCrcW then begin
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                    zZmodemState := tzWaitAck;
                  end else
                    zZmodemState := tzEscapeData;
                  aForceStatus := True;
                end else if TriggerID = aDataTrigger then
                  {Got a header from the receiver, process it}
                  if aProtocolStatus = psGotHeader then
                    zpProcessHeader(P);

              tzWaitAck :
                if TriggerID = aDataTrigger then
                  zpProcessHeader(P);

              tzSendEof :
                begin
                  {Send the eof}
                  LongInt(zTransHeader) := aFileOfs;
                  zpPutBinaryHeader(P, ZEof);
                  zZmodemState := tzDrainEof;
                  Dispatcher.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                  Dispatcher.SetTimerTrigger(aStatusTrigger,
                                   DrainingStatusInterval, True);

                  {Calculate how long it will take to drain the buffer}
                  if aActCPS <> 0 then begin
                    Secs := (Dispatcher.OutBuffUsed div aActCPS) * 2;
                    if Secs < 10 then
                      Secs := 10;
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, Secs2Ticks(Secs), True);
                  end else
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                end;

              tzDrainEof :
                if TriggerID = aDataTrigger then begin
                  case aProtocolStatus of
                    psGotHeader :
                      case zRcvFrame of
                        ZCan, ZAbort : {Receiver says quit}
                          begin
                            aProtocolStatus := psCancelRequested;
                            aForceStatus := True;
                            zZmodemState := tzError;
                          end;
                        ZrPos :        {Receiver is sending its file position}
                          zpGotZrPos(P);
                        ZAck :         {Response to last CrcW data subpacket}
                          ;
                        ZSkip, ZrInit : {Finished with this file}
                          begin
                            {Close file and log success}
                            apFinishReading(P);
                            apLogFile(P, lfTransmitOk);

                            {Go look for another file}
                            zZmodemState := tzGetFile;
                          end;
                        else begin
                          {Garbage, send Nak}
                          zpPutBinaryHeader(P, ZNak);
                        end;
                      end;

                    psBlockCheckError,
                    psTimeout :
                      zpBlockError(P, tzStartData, tzError, MaxBadBlocks);
                  end;

                end else if Integer(TriggerID) = aOutBuffUsedTrigger then begin
                  zZmodemState := tzCheckEof;
                  TriggerID := aDataTrigger;
                  zHeaderState := hsNone;
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aFinishWait, True);
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  apProtocolError(P, ecTimeout);
                  zZmodemState := tzError;
                end;

              tzCheckEof :
                case aProtocolStatus of
                  psGotHeader :
                    begin
                      case zRcvFrame of
                        ZCan, ZAbort : {Receiver says quit}
                          begin
                            aProtocolStatus := psCancelRequested;
                            aForceStatus := True;
                            zZmodemState := tzError;
                          end;
                        ZrPos :        {Receiver is sending its desired file position}
                          begin
                            Inc(aBlockErrors);
                            Inc(aTotalErrors);
                            aFileOfs := LongInt(zRcvHeader);
                            aBytesTransferred := aFileOfs;
                            aBytesRemaining := aSrcFileLen - aBytesTransferred;

                            {We got a hit, reduce block size by 1/2}
                            if aBlockLen > 256 then
                              aBlockLen := aBlockLen shr 1;
                            aLastBlockSize := aBlockLen;
                            zTookHit := True;
                            zGoodAfterBad := 0;
                            Dispatcher.FlushOutBuffer;
                            zZmodemState := tzStartData;
                          end;
                        ZAck :         {Response to last CrcW data subpacket}
                          ;
                        ZSkip, ZrInit : {Finished with this file}
                          begin
                            {Close file and log success}
                            apFinishReading(P);
                            apLogFile(P, lfTransmitOk);

                            {Go look for another file}
                            zZmodemState := tzGetFile;
                          end;
                        else begin
                          {Garbage, send Nak}
                          zpPutBinaryHeader(P, ZNak);
                        end;
                      end;
                    end;
                  psNoHeader :
                    {Keep waiting for header} ;
                  psBlockCheckError,
                  psTimeout :
                    zpBlockError(P, tzSendEof, tzError, MaxBadBlocks);
                end;

              tzSendFinish :
                begin
                  LongInt(zTransHeader) := aFileOfs;
                  zpPutHexHeader(P, ZFin);
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aFinishWait, True);
                  aBlockErrors := 0;
                  zZmodemState := tzCheckFinish;
                  zHeaderState := hsNone;
                end;

              tzCheckFinish :
                case aProtocolStatus of
                  psGotHeader :
                    case zRcvFrame of
                      ZFin :
                        begin
                          Dispatcher.PutChar('O');
                          Dispatcher.PutChar('O');
                          zZmodemState := tzCleanup;
                        end;
                      else begin
                        aProtocolError := ecOK;
                        zZmodemState := tzCleanup;
                      end;
                    end;
                  psNoHeader :
                    {Keep waiting for header} ;
                  psBlockCheckError,
                  psTimeout :
                    begin
                      {Give up quietly}
                      zZmodemState := tzCleanup;
                      aProtocolError := ecOK;
                    end;
                end;

              tzError :
                begin
                  {Cleanup on aborted or canceled protocol}
                  if aFilesSent then begin
                    apFinishReading(P);
                    apLogFile(P, lfTransmitFail);
                  end;
                  zZmodemState := tzCleanup;
                  if aProtocolStatus <> psCancelRequested then
                    Dispatcher.FlushOutBuffer;
                end;

              tzCleanup:
                begin
                  {Flush last few chars from last received header}
                  Dispatcher.FlushInBuffer;
                  zpPutAttentionString(P);

                  apShowLastStatus(P);
                  zZmodemState := tzDone;
                  apSignalFinish(P);

                  {Restore "no files" error code if we got that error earlier}
                  if (aProtocolError = ecOK) and not aFilesSent then
                    aProtocolError := ecNoMatchingFiles;
                end;
            end;

    ExitPoint:
            {Stay in state machine or exit?}
            case zZmodemState of
              {Leave state machine}
              tzHandshake,
              {tzSendData,}
              tzWaitAck,
              tzDrainEof,
              tzDone            : Finished := True;

              {Stay in state machine if we can send another packet}
              tzSendData        :
                begin
                  if (Dispatcher.OutBuffFree >= zWorkSize+FreeMargin) and
                    not Dispatcher.CharReady and
                     (StartTick = AdTimeGetTime) then begin
                    Finished := False;
                    TriggerID := aOutBuffFreeTrigger;
                    Dispatcher.SetStatusTrigger(aOutBuffFreeTrigger,
                      zWorkSize+FreeMargin, True);
                    Continue;
                  end else
                    Finished := True;
                end;

              {Stay in state machine only if data available}
              tzCheckFinish,
              tzCheckEof,
              tzCheckFile       : CheckFinished;

              {Stay in state machine}
              tzInitial,
              tzSInit,                                                      // SWB
              tzGetFile,
              tzSendFile,
              tzEscapeData,
              tzStartData,
              tzSendEof,
              tzSendFinish,
              tzError,
              tzCleanup         : Finished := False;
              else                Finished := True;
            end;

            {Clear header state if we just processed a header}
            if (aProtocolStatus = psGotHeader) or
               (aProtocolStatus = psNoHeader) then
              aProtocolStatus := psOK;
            if zHeaderState = hsGotHeader then
              zHeaderState := hsNone;

            {If staying in state machine for a check for data}
            TriggerID := aDataTrigger;
          except                                                         {!!.01}
            on EAccessViolation do begin                                 {!!.01}
              Finished := True;                                          {!!.01}
              aProtocolError := ecAbortNoCarrier;                        {!!.01}
              apSignalFinish(P);                                         {!!.01}
            end;                                                         {!!.01}
          end;                                                           {!!.01}
        until Finished;
      {$IFDEF Win32}                                                     {!!.01}
      LeaveCriticalSection(P^.aProtSection);                             {!!.01}
      {$ENDIF}                                                           {!!.01}
    end;

  end;

end.

