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
{*                   AWXMODEM.PAS 4.06                   *}
{*********************************************************}
{* XModem protocol                                       *}
{*********************************************************}
{*      Thanks to David Hudder for his substantial       *}
{*  contributions to improve efficiency and reliability  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$I-,B-,F+,A-,X+}

unit AwXmodem;
  {-Provides Xmodem/Crc/1K receive and transmit functions}

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

{Constructors/destructors}
function xpInit(var P : PProtocolData; H : TApdCustomComPort;          
                UseCRC, Use1K, UseGMode : Boolean;
                Options : Cardinal) : Integer;
procedure xpDone(var P : PProtocolData);

procedure xpReinit(P : PProtocolData; UseCRC, Use1K, UseGMode : Boolean);

{Options}
function xpSetCRCMode(P : PProtocolData; Enable : Boolean) : Integer;
function xpSet1KMode(P : PProtocolData; Enable : Boolean) : Integer;
function xpSetGMode(P : PProtocolData; Enable : Boolean) : Integer;
function xpSetBlockWait(P : PProtocolData; NewBlockWait : Cardinal) : Integer;
function xpSetXmodemFinishWait(P : PProtocolData; NewFinishWait : Cardinal) : Integer;

{Control}
procedure xpPrepareTransmit(P : PProtocolData);
procedure xpPrepareReceive(P : PProtocolData);
function xpTransmitPrim(Msg, wParam : Cardinal; lParam : LongInt) : LongInt;
procedure xpTransmit(Msg, wParam : Cardinal; lParam : LongInt);
function xpReceivePrim(Msg, wParam : Cardinal; lParam : LongInt) : LongInt;
procedure xpReceive(Msg, wParam : Cardinal; lParam : LongInt);

{Internal (but used by AWYMODEM)}
function xpPrepHandshake(P : PProtocolData) : Boolean;
function xpProcessHandshake(P : PProtocolData) : Boolean;
procedure xpTransmitBlock(P : PProtocolData; var Block : TDataBlock;
                          BLen : Cardinal; BType : AnsiChar);
procedure xpReceiveBlock(P : PProtocolData; var Block : TDataBlock;
                         var BlockSize : Cardinal; var HandShake : AnsiChar);
function xpProcessBlockReply(P : PProtocolData) : Boolean;
function xpCollectBlock(P : PProtocolData; var Block : TDataBlock) : Boolean;
function xpGetHandshakeChar(P : PProtocolData) : AnsiChar;
procedure xpSendHandshakeChar(P : PProtocolData; Handshake : AnsiChar);
function xpCheckForBlockStart(P : PProtocolData; var C : AnsiChar) : Boolean;
function xpProcessBlockStart(P : PProtocolData; C : AnsiChar) : TProcessBlockStart;

procedure xpCancel(P : PProtocolData);

const
  {Compile-time constants}
  DrainWait = 1092;              {OutBuf drain time before error (60 sec)}
  XmodemOverhead = 5;            {Overhead bytes for each block}
  XmodemTurnDelay = 1000;        {MSec turnaround delay for each block}

  {Mode request characters}
  GReq   = 'G';
  CrcReq = 'C';
  ChkReq = cNak;

implementation

const
  {Compile-time constants}
  DefBlockWait = 91;             {Normal between-block wait time (5 sec)}
  MaxCrcTry = 3;                 {Max tries for Crc before trying checksum}
  DefMaxBlockErrors = 5;         {Default maximum acceptable errors per block}
  aDataTrigger = 0;
const
  LogXModemState : array[TXmodemState] of TDispatchSubType = (
     dsttxInitial, dsttxHandshake, dsttxGetBlock, dsttxWaitFreeSpace,
     dsttxSendBlock, dsttxDraining, dsttxReplyPending,
     dsttxEndDrain, dsttxFirstEndOfTransmit, dsttxRestEndOfTransmit,
     dsttxEotReply, dsttxFinished, dsttxDone,
     dstrxInitial, dstrxWaitForHSReply, dstrxWaitForBlockStart,
     dstrxCollectBlock, dstrxProcessBlock,  dstrxFinishedSkip,
     dstrxFinished, dstrxDone);                                      

  function IsXYProtocol(Protocol : Byte) : Boolean;
    {-Return True if this is an Xmodem or Ymodem protocol}
  begin
    case Protocol of
      Xmodem, XmodemCRC, Xmodem1K, Xmodem1KG,
      Ymodem, YmodemG :
        IsXYProtocol := True;
      else
        IsXYProtocol := False;
    end;
  end;

  function IsXProtocol(Protocol : Byte) : Boolean;
    {-Return True if this is an Xmodem protocol}
  begin
    case Protocol of
      Xmodem, XmodemCRC, Xmodem1K, Xmodem1KG :
        IsXProtocol := True;
      else
        IsXProtocol := False;
    end;
  end;

  function GetProtocolType(CRC, OneK, G, Y : Boolean) : Cardinal;
    {-Return the protocol type}
  const
    KType : array[Boolean] of Cardinal = (Xmodem1K, Ymodem);
    GType : array[Boolean] of Cardinal = (Xmodem1KG, YmodemG);
  begin
    if not CRC then
      GetProtocolType := Xmodem
    else if not OneK then
      GetProtocolType := XmodemCRC
    else if not G then
      GetProtocolType := KType[Y]
    else
      GetProtocolType := GType[Y];
  end;

  procedure xpInitData(P : PProtocolData; UseCRC, Use1K, UseGMode : Boolean);
    {-Allocates and initializes a protocol control block with options}
  begin
    with P^ do begin
      {Set modes...}
      aCurProtocol := Xmodem;
      xpSetCRCMode(P, UseCRC);
      xpSet1KMode(P, Use1K);
      xpSetGMode(P, UseGMode);

      {Miscellaneous inits}
      xEotCheckCount := 1;
      xBlockWait := DefBlockWait;
      xMaxBlockErrors := DefMaxBlockErrors;
      aOverhead := XmodemOverhead;
      aTurnDelay := XmodemTurnDelay;
      aFinishWait := 0;

      {Set read/write hooks}
      apResetReadWriteHooks(P);
    end;
  end;

  function xpInit(var P : PProtocolData; H : TApdCustomComPort;       
                  UseCRC, Use1K, UseGMode : Boolean;
                  Options : Cardinal) : Integer;
    {-Allocates and initializes a protocol control block with options}
  var
    InSize, OutSize : Cardinal;
  begin
    {Check for adequate output buffer size}
    H.ValidDispatcher.BufferSizes(InSize, OutSize);
    if (OutSize < (1024 + XmodemOverhead)) then begin
      xpInit := ecOutputBufferTooSmall;
      Exit;
    end;

    {Init standard data}
    if apInitProtocolData(P, H, Options) <> ecOk then begin
      xpInit := ecOutOfMemory;
      Exit;
    end;

    {Can't fail after this}
    xpInit := ecOK;
    xpInitData(P, UseCRC, Use1K, UseGMode);
  end;

  procedure xpReinit(P : PProtocolData; UseCRC, Use1K, UseGMode : Boolean);
    {-Allocates and initializes a protocol control block with options}
  begin
    xpInitData(P, UseCRC, Use1K, UseGMode);
  end;

  procedure xpDone(var P : PProtocolData);
    {-Disposes of P}
  begin
    apDoneProtocol(P);
  end;

  function xpSetCRCMode(P : PProtocolData; Enable : Boolean) : Integer;
    {-Enable/disable CRC mode}
  var
    Y : Bool;
  begin
    with P^ do begin
      {Check protocol type}
      Y := False;
      case aCurProtocol of
        Xmodem, XmodemCRC   :
          ;
        Xmodem1K, Xmodem1KG :
          Enable := True;
        Ymodem, YmodemG     :
          begin
            Y := True;
            Enable := True;
          end;
        else begin
          xpSetCRCMode := ecBadProtocolFunction;
          Exit;
        end;
      end;

      {Ok now}
      xpSetCRCMode := ecOK;

      {Set check type}
      xCRCMode := Enable;
      if xCRCMode then
        aCheckType := bcCrc16
      else
        aCheckType := bcChecksum1;

      {Set the protocol type}
      aCurProtocol := GetProtocolType(xCRCMode, x1KMode, xGMode, Y);
    end;
  end;

  function xpSet1KMode(P : PProtocolData; Enable : Boolean) : Integer;
    {-Enable/disable Xmodem1K}
  var
    Y : Bool;
  begin
    with P^ do begin
      {Check the protocol type}
      case aCurProtocol of
        Xmodem, Xmodem1K, Xmodem1KG, XmodemCRC :
          Y := False;
        Ymodem, YmodemG :
          Y := True;
        else begin
          xpSet1KMode := ecBadProtocolFunction;
          Exit;
        end;
      end;

      {Ok now}
      xpSet1KMode := ecOK;

      {Turn 1K mode on or off}
      x1KMode := Enable;
      if x1KMode then begin
        aBlockLen := 1024;
        xStartChar := cStx;
        xCRCMode := True;
      end else begin
        aBlockLen := 128;
        xStartChar := cSoh;
      end;

      {Set the protocol type}
      aCurProtocol := GetProtocolType(xCRCMode, x1KMode, xGMode, Y);
    end;
  end;

  function xpSetGMode(P : PProtocolData; Enable : Boolean) : Integer;
    {-Enable/disable streaming}
  var
    Y : Bool;
  begin
    with P^ do begin
      {Check the protocol type}
      case aCurProtocol of
        Xmodem, Xmodem1K, Xmodem1KG, XmodemCRC :
          Y := False;
        Ymodem, YmodemG :
          Y := True;
        else begin
          xpSetGMode := ecBadProtocolFunction;
          Exit;
        end;
      end;

      {Ok now}
      xpSetGMode := ecOK;

      {Turn G mode on or off}
      xGMode := Enable;
      if xGMode then begin
        {Force 1K mode if entering G mode}
        xpSet1KMode(P, True);
        aTurnDelay := 0;
        xEotCheckCount := 0;
      end else begin
        aTurnDelay := XmodemTurnDelay;
        xEotCheckCount := 1;
        xMaxBlockErrors := DefMaxBlockErrors;
      end;

      {Set the protocol type}
      aCurProtocol := GetProtocolType(xCRCMode, x1KMode, xGMode, Y);
    end;
  end;

  function xpSetBlockWait(P : PProtocolData; NewBlockWait : Cardinal) : Integer;
    {-Set inter-block wait time}
  begin
    with P^ do begin
      if not IsXYProtocol(aCurProtocol) then
        xpSetBlockWait := ecBadProtocolFunction
      else begin
        xpSetBlockWait := ecOK;
        xBlockWait := NewBlockWait;
      end;
    end;
  end;

  function xpSetXmodemFinishWait(P : PProtocolData;
                                 NewFinishWait : Cardinal) : Integer;
    {-Set additional finish wait (time to wait for EOT response)}
  begin
    with P^ do begin
      if IsXYProtocol(aCurProtocol) then
        xpSetXmodemFinishWait := ecBadProtocolFunction
      else begin
        xpSetXmodemFinishWait := ecOK;
        aFinishWait := NewFinishWait;
      end;
    end;
  end;

  function xpPrepHandshake(P : PProtocolData) : Boolean;
    {-Prepare to wait for a handshake char, return False if too many errors}
  begin
    with P^ do begin
      Inc(aHandshakeAttempt);
      if aHandshakeAttempt > aHandshakeRetry then begin
        xpPrepHandshake := False;
        apProtocolError(P, ecTimeout);
      end else begin
        aHC.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
        xpPrepHandshake := True;
        if aHandshakeAttempt <> 1 then begin
          Inc(aBlockErrors);
          Inc(aTotalErrors);
          aForceStatus := True;
        end;
      end;
    end;
  end;

  procedure xpCancel(P : PProtocolData);
    {-Sends cancel request to remote}
  const
    CanStr : array[0..6] of AnsiChar = cCan+cCan+cCan+cBS+cBS+cBS;
  begin
    with P^ do begin
      if aHC.Open then begin
        {Flush anything that might be left in the output buffer}
        aHC.FlushOutBuffer;

        {Cancel with three CANCEL chars}
        aHC.PutBlock(CanStr, StrLen(CanStr));
      end;
      aForceStatus := True;
    end;
  end;

  function xpGetHandshakeChar(P : PProtocolData) : AnsiChar;
    {-Returns proper handshake character}
  begin
    with P^ do begin
      if xGMode then
        xpGetHandshakeChar := GReq
      else if xCRCMode then
        xpGetHandshakeChar := CrcReq
      else
        xpGetHandshakeChar := ChkReq;
    end;
  end;

  function xpProcessHandshake(P : PProtocolData) : Boolean;
    {-Process handshake, return true if OK}
  var
    C : AnsiChar;
  begin
    with P^ do begin
      {If we get here we know a character is waiting}
      aHC.ValidDispatcher.GetChar(C);
      aProtocolStatus := psOK;
      case C of
        cCan : {Remote requested a cancel}
          begin
            aProtocolStatus := psCancelRequested;
            aForceStatus := True;
          end;
        ChkReq : {Set checksum mode}
          begin
            aCheckType := bcChecksum1;
            xCRCMode := False;
          end;
        CrcReq : {Set CRC mode}
          begin
            aCheckType := bcCrc16;
            xCRCMode := True;
          end;
        GReq : {Set G mode (streaming mode)}
          begin
            aCheckType := bcCrc16;
            xCRCMode := True;
            xGMode := True;
          end;
        else begin {Unexpected character}
          aProtocolStatus := psProtocolError;
          aForceStatus := True;
        end;
      end;

      {Update the protocol type}
      if aProtocolStatus = psOK then
        aCurProtocol := GetProtocolType(xCRCMode, x1KMode, xGMode,
                                        not IsXProtocol(aCurProtocol));

      xpProcessHandshake := aProtocolStatus = psOK;
    end;
  end;

  function xpProcessBlockReply(P : PProtocolData) : Boolean;
    {-Process reply to last block; return True for ack}
  var
    C : AnsiChar;
  begin
    with P^ do begin
      {Handle GMode (all blocks are assumed to succeed)}
      if xGMode then begin
        aProtocolStatus := psOK;
        Inc(aBytesTransferred, aBlockLen);
        Dec(aBytesRemaining, aBlockLen);
        if aBytesRemaining < 0 then
          aBytesRemaining := 0;
        Inc(aBlockNum);
        Inc(aFileOfs, aBlockLen);

        {Check for cancel from remote}
        if aHC.CharReady then begin
          aHC.ValidDispatcher.GetChar(C);
          if (C = cCan) or (C = cNak) then begin
            aProtocolStatus := psCancelRequested;
            aForceStatus := True;
          end;
        end;
        xpProcessBlockReply := aProtocolStatus = psOK;
      end else begin
        {Get the reply}
        aHC.ValidDispatcher.GetChar(C);

        {Process the reply}
        case C of
          cAck : {Block was acknowledged}
            begin
              aProtocolStatus := psOK;
              Inc(aBytesTransferred, aBlockLen);
              Dec(aBytesRemaining, aBlockLen);
              if aBytesRemaining < 0 then
                aBytesRemaining := 0;
              Inc(aBlockNum);
              Inc(aFileOfs, aBlockLen);
            end;
          cCan : {Cancel}
            begin
              aProtocolStatus := psCancelRequested;
              aForceStatus := True;
            end;
          else {Nak or unexpected character}
            Inc(aBlockErrors);
            Inc(aTotalErrors);
            if C = cNak then
              aProtocolStatus := psBlockCheckError
            else
              aProtocolStatus := psProtocolError;
            aForceStatus := True;
        end;
        xpProcessBlockReply := aProtocolStatus = psOK;
      end;
    end;
  end;

  procedure xpTransmitBlock(P : PProtocolData; var Block : TDataBlock;
                            BLen : Cardinal; BType : AnsiChar);
    {-Transmits one data block}
  var
    I : Integer;
  begin
    with P^ do begin
      if aBlockErrors > xMaxBlockErrors then
        {Too many errors}
        if x1KMode and (aBlockLen = 1024) then begin
          {1KMode - reduce the block size and try again}
          aBlockLen := 128;
          xStartChar := cSoh;
          aBlockErrors := 0;
        end else begin
          {Std Xmodem - have to cancel}
          xpCancel(P);
          apProtocolError(P, ecTooManyErrors);
          Exit;
        end;

      {Send the StartBlock char, the block sequence and its compliment}
      with aHC do begin
        PutChar(xStartChar);
        PutChar(AnsiChar(Lo(aBlockNum)));
        PutChar(AnsiChar(not Lo(aBlockNum)));
      end;
      {Init the aBlockCheck value}
      aBlockCheck := 0;

      {Send the data on its way}
      aHC.PutBlock(Block, aBlockLen);

      {Calculate the check character}
      if xCRCMode then
        for  I := 1 to aBlockLen do
          aBlockCheck :=
            apUpdateCrc(Byte(Block[I]), aBlockCheck)
      else
        for I := 1 to aBlockLen do
          aBlockCheck :=
            apUpdateCheckSum(Byte(Block[I]), aBlockCheck);

      {Send the check character}
      if xCRCMode then begin
        aBlockCheck := apUpdateCrc(0, aBlockCheck);
        aBlockCheck := apUpdateCrc(0, aBlockCheck);
        aHC.PutChar(AnsiChar(Hi(aBlockCheck)));
        aHC.PutChar(AnsiChar(Lo(aBlockCheck)));
      end else
        aHC.PutChar(AnsiChar(aBlockCheck));
    end;
  end;

  procedure TransmitEot(P : PProtocolData; First : Boolean);
    {-Transmit an Xmodem EOT (end of transfer)}
  begin
    with P^ do begin
      aProtocolStatus := psOK;
      if First then begin
        aBlockErrors := 0;
        xNaksReceived := 0;
      end;

      {Ensure no stale ACKs are in the Rx buffer}
      aHC.FlushInBuffer;
      {Send the Eot char}
      aHC.PutChar(cEot);
    end;
  end;

  function ProcessEotReply(P : PProtocolData) : Boolean;
    {-Get a response to an EOT, return True for ack or cancel}
  var
    C : AnsiChar;
  begin
    with P^ do begin
      {Get the response}
      aHC.ValidDispatcher.GetChar(C);
      case C of
        cAck : {Receiver acknowledged Eot, this transfer is over}
          begin
            ProcessEotReply := True;
            aProtocolStatus := psEndFile;
          end;
        cCan : {Receiver asked to cancel, this transfer is over}
          begin
            ProcessEotReply := True;
            aProtocolStatus := psCancelRequested;
            aForceStatus := True;
          end;
        cNak : {Some Xmodems always NAK the first 1 or 2 EOTs}
                {So, don't count them as errors till we get 3 }
          begin
            ProcessEotReply := False;
            Inc(xNaksReceived);
            If xNaksReceived >= 3 then begin
              xpCancel(P);
              apProtocolError(P, ecTooManyErrors);
            end;
          end;
        else {Unexpected character received}
          ProcessEotReply := False;
          Inc(aBlockErrors);
          Inc(aTotalErrors);
          aProtocolStatus := psProtocolError;
      end
    end;
  end;

  procedure xpSendHandshakeChar(P : PProtocolData; Handshake : AnsiChar);
    {-Send the current handshake char}
  begin
    with P^ do
      {If in Gmode, filter out all standard Acks}
      if not xGmode or (Handshake <> cAck) then
        aHC.PutChar(Handshake);
  end;

  function xpCheckForBlockStart(P : PProtocolData; var C : AnsiChar) : Boolean;
    {-Scan input buffer for start char, return True if found}
  begin
    with P^ do begin
      aProtocolStatus := psOK;
      xpCheckForBlockStart := False;

      {Ready to scan...}
      aBlockErrors := 0;
      while aHC.CharReady do begin

        {Check the next character}
        aHC.ValidDispatcher.GetChar(C);
        case C of
          cSoh, cStx, cEot, cCan :
            begin
              xpCheckForBlockStart := True;
              Exit;
            end;
          else begin
            aProtocolStatus := psProtocolError;
            aForceStatus := True;
            xEotCounter := 0;
            xCanCounter := 0;
          end;
        end;
      end;
    end;
  end;

  function xpProcessBlockStart(P : PProtocolData;
                               C : AnsiChar) : TProcessBlockStart;
    {-Standard action for block start characters}
  begin
    with P^ do begin
      case C of
        cSoh :
          begin
            xpProcessBlockStart := pbs128;
            aBlockLen := 128;
            aBlkIndex := 0;
          end;
        cStx :
          begin
            xpProcessBlockStart := pbs1024;
            aBlockLen := 1024;
            aBlkIndex := 0;
          end;
        cCan :
          begin
            xEotCounter := 0;
            Inc(xCanCounter);
            if xCanCounter > 2 then begin
              xpProcessBlockStart := pbsCancel;
              xpCancel(P);
            end else
              xpProcessBlockStart :=  pbsNone;
          end;
        cEot :
          begin
            xCanCounter := 0;
            Inc(xEotCounter);
            if xEotCounter = 1 then begin
              xpProcessBlockStart := pbsNone;
              aHC.PutChar(cNak);
              aHC.SetTimerTrigger(aTimeoutTrigger, xBlockWait, True);
            end else begin
              xpProcessBlockStart := pbsEOT;
              aProtocolStatus := psEndFile;
              aHC.PutChar(cAck);
            end;
          end;
        else
          xpProcessBlockStart := pbsNone;
      end;
    end;
  end;

  function xpCollectBlock(P : PProtocolData; var Block : TDataBlock) : Boolean;
    {-Collect received data into DataBlock, return True for full block}
  var
    TotalLen : Cardinal;
    C : AnsiChar;
  begin
    with P^ do begin
      xHandshake := cNak;
      TotalLen := aBlockLen + xOverheadLen;
      while aHC.CharReady and (aBlkIndex < TotalLen) do begin
        aHC.ValidDispatcher.GetChar(C);
        Inc(aBlkIndex);
        Block[aBlkIndex] := C;
      end;
      xpCollectBlock := aBlkIndex = TotalLen;
    end;
  end;

  procedure xpReceiveBlock(P : PProtocolData; var Block : TDataBlock;
                           var BlockSize : Cardinal; var HandShake : AnsiChar);
    {-Process the data already in Block}
  type
    LHW = record
      L,H : AnsiChar;
    end;
  var
    R1, R2 : Byte;
    I      : Cardinal;
    Check  : Word;
  begin
    with P^ do begin
      {Get and compare block sequence numbers}
      R1 := Byte(Block[1]);
      R2 := Byte(Block[2]);
      if (not R1) <> R2 then begin
        Inc(aBlockErrors);
        Inc(aTotalErrors);
        xpCancel(P);
        aProtocolStatus := psSequenceError;
        apProtocolError(P, ecSequenceError);
        Exit;
      end;

      {Calculate the block check value}
      aBlockCheck := 0;
      if xCRCMode then
        for I := 3 to aBlockLen+2 do
          aBlockCheck := apUpdateCrc(Byte(Block[I]), aBlockCheck)
      else
        for I := 3 to aBlockLen+2 do
          aBlockCheck := apUpdateCheckSum(Byte(Block[I]), aBlockCheck);

      {Check the block-check character}
      if xCRCMode then begin
        aBlockCheck := apUpdateCrc(0, aBlockCheck);
        aBlockCheck := apUpdateCrc(0, aBlockCheck);
        LHW(Check).H := Block[aBlockLen+3];
        LHW(Check).L := Block[aBlockLen+4];
      end else begin
        Check := Byte(Block[aBlockLen+3]);
        aBlockCheck := aBlockCheck and $FF;
      end;

      if Check <> aBlockCheck then begin
        {Block check error}
        Inc(aBlockErrors);
        Inc(aTotalErrors);
        aHC.FlushInBuffer;
        aProtocolStatus := psBlockCheckError;
        Exit;
      end;

      {Check the block sequence for missing or duplicate blocks}
      if (aBlockNum <> 0) and (R1 = Lo(aBlockNum-1)) then begin
        {This is a duplicate block}
        HandShake := cAck;
        aBlockErrors := 0;
        aProtocolStatus := psDuplicateBlock;
        Exit;
      end;
      if R1 <> Lo(aBlockNum) then begin
        {Its a sequence error}
        xpCancel(P);
        aProtocolStatus := psSequenceError;
        apProtocolError(P, ecSequenceError);
        Exit;
      end;

      {Block is ok}
      Handshake := cAck;

      {Update status fields for the next call to the user status routine}
      Inc(aBlockNum);
      Inc(aBytesTransferred, aBlockLen);
      Dec(aBytesRemaining, aBlockLen);
      if aBytesRemaining < 0 then
        aBytesRemaining := 0;
      aBlockErrors := 0;
      aProtocolError := ecOK;
      aProtocolStatus := psOK;
      aForceStatus := True;
      BlockSize := aBlockLen;
    end;
  end;

  procedure xpPrepareTransmit(P : PProtocolData);
    {-Prepare for transmitting Xmodem}
  begin
    with P^ do begin
      {Inits}
      apResetStatus(P);
      apShowFirstStatus(P);

      {Get the file to transmit}
      if not apNextFile(P, aPathname) then begin
        {aProtocolError already set}
        apShowLastStatus(P);
        Exit;
      end;

      {Other inits}
      aTimerStarted := False;
      aForceStatus := True;
      xXmodemState := txInitial;
      aDataBlock := nil;

      {Discard any unread data}
      aHC.FlushInBuffer;
    end;
  end;

  function xpTransmitPrim(Msg, wParam : Cardinal;
                      lParam : LongInt) : LongInt;
    {-Perform one increment of an Xmodem transmit}
  var
    TriggerID   : Cardinal absolute wParam;
    P           : PProtocolData;
    Wait        : Cardinal;
    BufSize     : Cardinal;
    Finished    : Bool;
    C           : AnsiChar;
    StatusTicks : LongInt;
    ValidDispatcher      : TApdBaseDispatcher;

    procedure PrepSendBlock;
      {-Prepare to (re)send the current block}
    begin
      with P^ do begin
        aProtocolError := ecOK;
        {Don't waste time if the buffer space is available}
        if (aHC.OutBuffFree >= (aBlockLen+XmodemOverhead)) then
          xXmodemState := txSendBlock
        else begin
          xXmodemState := txWaitFreespace;
          aHC.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
          aHC.SetStatusTrigger(aOutBuffFreeTrigger,
                            aBlockLen+XmodemOverhead, True);
        end;
      end;
    end;

  begin
    Result := 0;                                                       {!!.01}
    Finished := False;                                                 {!!.01}
    {Get the protocol pointer from data pointer 1}
    ValidDispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
    {with TApdBaseDispatcher(PortList[LH(lParam).H]) do{    ComPorts[LH(lParam).H] do}
    with ValidDispatcher do begin
      try                                                              {!!.01}
        ValidDispatcher.GetDataPointer(Pointer(P), ProtocolDataPtr);
      except                                                           {!!.01}
        on EAccessViolation do begin                                   {!!.01}
        { No access to P^ so just exit }                               {!!.01}
        Exit;                                                          {!!.01}
      end;                                                             {!!.01}
    end;                                                               {!!.01}

    with P^ do begin
      {Function result is always zero unless the protocol is over}
      Result := 0;

      {$IFDEF Win32}
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if xXmodemState = txDone then begin
        LeaveCriticalSection(aProtSection);
        Result := 1;
        Exit;
      end;
      {$ENDIF}

        {If it's a TriggerAvail message then force the TriggerID}
        if Msg = apw_TriggerAvail then
          TriggerID := aDataTrigger;

        repeat
          try                                                          {!!.01}
            if ValidDispatcher.Logging then
              ValidDispatcher.AddDispatchEntry(
                dtXModem,LogXModemState[xXmodemState],0,nil,0);

            {Check for user or remote abort}
            if ((Integer(TriggerID) = aNoCarrierTrigger) and
              not aHC.ValidDispatcher.CheckDCD) or
              (Msg = apw_ProtocolCancel) then begin
              if Msg = apw_ProtocolCancel then begin
                xpCancel(P);
                aProtocolStatus := psCancelRequested;
              end else
                aProtocolStatus := psAbortNoCarrier;
              xXmodemState := txFinished;
              aForceStatus := True;
            end;

            {Show status periodically}
            if (Integer(TriggerID) = aStatusTrigger) or aForceStatus then begin
              if aTimerStarted then
                aElapsedTicks := ElapsedTime(aTimer);
              if ValidDispatcher.TimerTicksRemaining(aStatusTrigger,
                                      StatusTicks) <> 0 then
                StatusTicks := 0;
              if StatusTicks <= 0 then begin
                apShowStatus(P, 0);
                aHC.SetTimerTrigger(aStatusTrigger, aStatusInterval, True);
                aForceStatus := False;
              end;
            end;

            {Process current state}
            case xXmodemState of
              txInitial :
                begin
                  {Get a protocol DataBlock}
                  aDataBlock := AllocMem(SizeOf(TDataBlock));

                  {Upcase the pathname}
                  if aUpcaseFileNames then
                    AnsiUpper(aPathname);

                  {Show file name to user logging routine}
                  apLogFile(P, lfTransmitStart);

                  {Show handshaking in progress}
                  aProtocolStatus := psProtocolHandshake;
                  aForceStatus := True;

                  {Prepare to read protocol blocks}
                  apPrepareReading(P);
                  if aProtocolError = ecOK then begin
                    {Set the first block number}
                    aBlockNum := 1;

                    {Check for handshake character}
                    xXmodemState := txHandshake;
                    aHandshakeAttempt := 0;
                    if not xpPrepHandshake(P) then
                      xXmodemState := txFinished;
                  end else
                    xXmodemState := txFinished;
                end;

              txHandshake :
                if TriggerID = aDataTrigger then begin
                  if xpProcessHandshake(P) then begin
                    {Start protocol timer now}
                    NewTimer(aTimer, 1);
                    aTimerStarted := True;
                    xXmodemState := txGetBlock;
                    aFileOfs := 0;
                    aBlockErrors := 0;
                    aTotalErrors := 0;
                    if xGMode then
                      xMaxBlockErrors := 0;
                    aProtocolStatus := psOK;
                  end else begin
                    if aProtocolStatus = psCancelRequested then
                      xXmodemState := txFinished
                    else if not xpPrepHandshake(P) then
                      xXmodemState := txFinished
                  end;
                end else if Integer(TriggerID) = aTimeoutTrigger then
                  if not xpPrepHandshake(P) then
                    xXmodemState := txFinished;

              txGetBlock :
                begin
                  aLastBlockSize := aBlockLen;
                  aBlockErrors := 0;
                  aNoMoreData := apReadProtocolBlock(P, aDataBlock^, aLastBlockSize);
                  PrepSendBlock;
                end;

              txWaitFreeSpace :
                if Integer(TriggerID) = aOutBuffFreeTrigger then
                  {Got enough free space, go send the block}
                  xXmodemState := txSendBlock
                else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Never got adequate free space, can't continue}
                  apProtocolError(P, ecTimeout);
                  xXmodemState := txFinished;
                end else if (TriggerID = aDataTrigger) and xGMode then
                  {In G mode, cancels could show up here}
                  while aHC.CharReady do begin
                    aHC.ValidDispatcher.GetChar(C);
                    if (C = cCan) then begin
                      aProtocolStatus := psCancelRequested;
                      aForceStatus := True;
                      xXmodemState := txFinished;
                      break;
                    end;
                  end;

              txSendBlock :
                if aLastBlockSize <= 0 then
                  {Don't send empty blocks}
                  xXmodemState := txFirstEndOfTransmit
                else begin
                  {If no errors, then send this block to the remote}
                  if aProtocolError = ecOK then begin
                    xpTransmitBlock(P, aDataBlock^, aBlockLen, ' ');

                    {If TransmitBlock failed, go clean up}
                    if aProtocolError <> ecOK then begin
                      FlushOutBuffer;
                      xXmodemState := txFinished;
                    end else

                      {Prepare to handle reply}
                      if xGMode then begin
                        {Process possible reply}
                        if xpProcessBlockReply(P) then begin
                          {No reply, continue as though ack was received}
                          if aNoMoreData then begin
                            {Finished, wait for buffer to drain}
                            xXmodemState := txEndDrain;
                            if aFinishWait = 0 then begin
                              {Calculate finish drain time}
                              BufSize := InBuffUsed + InBuffFree;
                              Wait := 2 *
                                      (xBlockWait+((BufSize div aActCPS)*182) div 10);
                            end else
                              {Use user-specified finish drain time}
                              Wait := aFinishWait;
                            SetTimerTrigger(aTimeoutTrigger, Wait, True);
                            SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                          end else
                            xXmodemState := txGetBlock;
                        end else begin
                          {Got CAN or NAK, cancel the protocol}
                          FlushOutBuffer;
                          xXmodemState := txFinished;
                        end;
                      end else begin
                        {Wait for output buffer to drain}
                        xXmodemState := txDraining;
                        SetTimerTrigger(aTimeoutTrigger, DrainWait, True);
                        SetStatusTrigger( aOutBuffUsedTrigger, 0, True);
                      end;

                    {Force a status update}
                    aForceStatus := True;
                  end else begin
                    {Disk read error, have to give up}
                    xpCancel(P);
                    xXmodemState := txFinished;
                  end;
                end;

              txDraining :
                if (Integer(TriggerID) = aOutBuffUsedTrigger) or
                   (TriggerID = aDataTrigger) or
                   (Integer(TriggerID) = aTimeoutTrigger) then begin
                  xXmodemState := txReplyPending;
                  SetTimerTrigger(aTimeoutTrigger, xBlockWait, True);
                end;

              txReplyPending :
                if TriggerID = aDataTrigger then begin
                  if xpProcessBlockReply(P) then begin
                    {Got reply, go send next block}
                    if aNoMoreData then
                      xXmodemState := txFirstEndofTransmit
                    else
                      xXmodemState := txGetBlock;
                  end else
                    if aProtocolStatus = psCancelRequested then begin
                      {Got two cancels, we're finished}
                      FlushOutBuffer;
                      xXmodemState := txFinished;
                    end else
                      {Got junk or Nak for a response, go send block again}
                      PrepSendBlock;
                end else if Integer(TriggerID) = aTimeoutTrigger then
                  {Got timeout, try to send block again}
                  PrepSendBlock;

              txEndDrain:
                if (Integer(TriggerID) = aOutBuffUsedTrigger) or
                   (Integer(TriggerID) = aTimeoutTrigger) then
                  xXmodemState := txFirstEndOfTransmit;

              txFirstEndOfTransmit :
                begin
                  TransmitEot(P, True);
                  SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                  xXmodemState := txEotReply;
                end;

              txRestEndOfTransmit :
                begin
                  TransmitEot(P, False);
                  SetTimerTrigger(aTimeoutTrigger, xBlockWait, True);
                  if aBlockErrors <= xMaxBlockErrors then begin
                    xXmodemState := txEotReply;
                  end else begin
                    apProtocolError(P, ecTooManyErrors);
                    xXmodemState := txFinished;
                  end;
                end;

              txEotReply :
                if TriggerID = aDataTrigger then
                  if ProcessEotReply(P) then
                    xXmodemState := txFinished
                  else
                    xXmodemState := txRestEndOfTransmit
                else if Integer(TriggerID) = aTimeoutTrigger then
                  xXmodemState := txRestEndOfTransmit;

              txFinished :
                begin
                  if (aProtocolStatus <> psEndFile) or
                     (aProtocolError <> ecOK) then
                    FlushInBuffer;

                  {Close the file}
                  apFinishReading(P);

                  {Show status, user logging}
                  if (aProtocolStatus = psEndFile) then
                    apLogFile(P, lfTransmitOk)
                  else
                    apLogFile(P, lfTransmitFail);
                  {apShowLastStatus(P);}

                  {Clean up}
                  FreeMem(aDataBlock, SizeOf(TDataBlock));
                  xXmodemState := txDone;

                  if Msg <> apw_FromYmodem then begin
                    {Say we're finished}
                    apShowLastStatus(P);
                    apSignalFinish(P);
                  end else
                    apShowStatus(P, 0);

                  {Tell caller we're finished}
                  Result := 1;
                end;
            end;

            {Should we exit or not}
            case xXmodemState of
              {Stay in state machine}
              txGetBlock,
              txSendBlock,
              txFirstEndOfTransmit,
              txRestEndOfTransmit,
              txFinished            : Finished := False;

              {Stay in state machine if data available}
              txEotReply,
              txDraining,
              txReplyPending,
              txHandshake           : Finished := not CharReady;

              {Finished with state machine}
              txWaitFreeSpace,
              txEndDrain,
              txDone                : Finished := True
              else                    Finished := True;
            end;

            {Force data trigger if staying in state machine}
            TriggerID := aDataTrigger;
          except                                                       {!!.01}
            on EAccessViolation do begin                               {!!.01}
              Finished := True;                                        {!!.01}
              aProtocolError := ecAbortNoCarrier;                      {!!.01}
              apSignalFinish(P);                                       {!!.01}
            end;                                                       {!!.01}
          end;                                                         {!!.01}
        until Finished;
      end;
      {$IFDEF Win32}                                               {!!.01}
      LeaveCriticalSection(P^.aProtSection);                       {!!.01}
      {$ENDIF}                                                     {!!.01}
    end;
  end;

  procedure xpTransmit(Msg, wParam : Cardinal; lParam : LongInt);
  begin
    xpTransmitPrim(Msg, wParam, lParam);
  end;

  procedure xpPrepareReceive(P : PProtocolData);
    {-Starts Xmodem receive protocol}
  begin
    with P^ do begin
      {Prepare state machine, show first status}
      xXmodemState := rxInitial;
      aDataBlock := nil;
      apResetStatus(P);
      apShowFirstStatus(P);
      aForceStatus := False;
      aTimerStarted := False;
    end;
  end;

  function xpReceivePrim(Msg, wParam : Cardinal;
                     lParam : LongInt) : LongInt;
    {-Performs one increment of an Xmodem receive}
  label
    ExitPoint;
  var
    TriggerID   : Cardinal absolute wParam;
    P           : PProtocolData;
    DataPtr     : PDataBlock;
    Finished    : Boolean;
    C           : AnsiChar;
    StatusTicks : LongInt;
    ValidDispatcher      : TApdBaseDispatcher;

    procedure Cleanup(DisposeBuffers : Boolean);
      {-Handle error reporting and other cleanup}
    begin
      with P^ do begin
        if DisposeBuffers then
          FreeMem(aDataBlock, SizeOf(TDataBlock)+XmodemOverhead);

        if Msg <> apw_FromYmodem then begin
          apShowLastStatus(P);
          apSignalFinish(P);
        end;

        xXmodemState := rxDone;
        Result := 1;
      end;
    end;

    function CheckErrors : Boolean;
      {-Increment block errors, return True if too many}
    begin
      with P^ do begin
        Inc(aBlockErrors);
        Inc(aTotalErrors);
        if aBlockErrors > xMaxBlockErrors then begin
          CheckErrors := True;
          apProtocolError(P, ecTooManyErrors);
          aProtocolStatus := psProtocolError;
          aForceStatus := True;
        end else
          CheckErrors := False;
      end;
    end;

  begin
    Finished := False;                                                 {!!.01}
    {Get the protocol pointer from data pointer 1}
    try                                                                {!!.01}
      ValidDispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
      with ValidDispatcher do
        GetDataPointer(Pointer(P), ProtocolDataPtr);
    except                                                             {!!.01}
      on EAccessViolation do begin                                     {!!.01}
        { There is no access to P^ so just exit }                      {!!.01}
        Exit;                                                          {!!.01}
      end;                                                             {!!.01}
    end;                                                               {!!.01}

    with P^ do begin
      {$IFDEF Win32}
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if xXmodemState = rxDone then begin
        LeaveCriticalSection(aProtSection);
        Result := 1;
        Exit;
      end;
      {$ENDIF}
        {Set TriggerID directly for TriggerAvail messages}
        if Msg = apw_TriggerAvail then
          TriggerID := aDataTrigger;

        repeat
          try                                                          {!!.01}
            {Return 0 unless finished}
            Result := 0;

            if ValidDispatcher.Logging then
              ValidDispatcher.AddDispatchEntry(
                dtXModem,LogXModemState[xXmodemState],0,nil,0);

            {Check for user abort}
            if ((Integer(TriggerID) = aNoCarrierTrigger) and
              not ValidDispatcher.CheckDCD) or
               (Msg = apw_ProtocolCancel) then begin
              if Msg = apw_ProtocolCancel then begin
                xpCancel(P);
                aProtocolStatus := psCancelRequested;
              end else
                aProtocolStatus := psAbortNoCarrier;
              xXmodemState := rxFinished;
              aForceStatus := True;
            end;

            {Show status periodically}
            if (Integer(TriggerID) = aStatusTrigger) or aForceStatus then begin
              if aTimerStarted then
                aElapsedTicks := ElapsedTime(aTimer);
              if ValidDispatcher.TimerTicksRemaining( aStatusTrigger,
                                      StatusTicks) <> 0 then
                StatusTicks := 0;
              if StatusTicks <= 0 then begin
                apShowStatus(P, 0);
                ValidDispatcher.SetTimerTrigger(aStatusTrigger, aStatusInterval, True);
                aForceStatus := False;
              end;
            end;

            {Process current state}
            case xXmodemState of
              rxInitial :
                begin
                  {Get a protocol DataBlock}
                  aDataBlock := AllocMem(SizeOf(TDataBlock)+XmodemOverhead);

                  {Pathname should already have name of file to receive}
                  if aPathname[0] = #0 then begin
                    apProtocolError(P, ecNoFilename);
                    xpCancel(P);
                    Cleanup(True);
                    {$IFDEF Win32}
                    LeaveCriticalSection(aProtSection);
                    {$ENDIF}
                    Exit;
                  end else if aUpcaseFileNames then
                    AnsiUpper(aPathName);

                  {Send file name to user's LogFile procedure}
                  apLogFile(P, lfReceiveStart);

                  {Accept this file}
                  if not apAcceptFile(P, aPathName) then begin
                    xpCancel(P);
                    aProtocolStatus := psFileRejected;
                    xXmodemState := rxFinishedSkip;
                    goto ExitPoint;
                  end;

                  {Prepare to write file}
                  apPrepareWriting(P);
                  if (aProtocolError <> ecOK) or
                     (aProtocolStatus = psCantWriteFile) then begin
                    if aProtocolStatus = psCantWriteFile then
                      aProtocolError := ecCantWriteFile;
                    xpCancel(P);
                    xXmodemState := rxFinishedSkip;
                    goto ExitPoint;
                  end;

                  {Start sending handshakes}
                  aFileOfs := 0;
                  xXmodemState := rxWaitForHSReply;
                  xHandshake := xpGetHandshakeChar(P);
                  xpSendHandshakeChar(P, xHandshake);
                  aBlockNum := 1;
                  xEotCounter := 0;
                  xCanCounter := 0;
                  ValidDispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);

                  {Set overhead length based on check type}
                  if xCRCMode then
                    xOverheadLen := 4
                  else
                    xOverheadLen := 3;
                end;

              rxWaitForHSReply :
                if TriggerID = aDataTrigger then begin
                  xXmodemState := rxWaitForBlockStart;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  if CheckErrors then
                    xXmodemState := rxFinished
                  else begin
                    if (xHandshake = CrcReq) and
                       (aBlockErrors > MaxCrcTry) then begin
                      {Step down to Xmodem checksum}
                      aBlockErrors := 0;
                      aCheckType := bcChecksum1;
                      xHandshake := ChkReq;
                      xCRCMode := False;
                      Dec(xOverheadLen);
                    end;
                    ValidDispatcher.PutChar(xHandshake);
                    ValidDispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  end;
                end;

              rxWaitForBlockStart :
                if TriggerID = aDataTrigger then begin
                  {Check for timer start}
                  if not aTimerStarted then begin
                    NewTimer(aTimer, 0);
                    aTimerStarted := True;
                    if xGMode then
                      xMaxBlockErrors := 0;
                  end;

                  {Process the received character}
                  if xpCheckForBlockStart(P, C) then begin
                    case xpProcessBlockStart(P, C) of
                      pbs128, pbs1024 :
                        begin
                          xXmodemState := rxCollectBlock;
                          ValidDispatcher.SetTimerTrigger(aTimeoutTrigger, xBlockWait, True);
                        end;
                      pbsCancel, pbsEOT :
                        xXmodemState := rxFinished;
                    end;
                  end;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout waiting for block start}
                  if xEotCounter <> 0 then begin
                    {Timeout waiting for second cEot, end normally}
                    ValidDispatcher.PutChar(cAck);
                    xXmodemState := rxFinished;
                    aProtocolStatus := psEndFile;
                  end else if CheckErrors or (xCanCounter <> 0) then begin
                    {Too many errors, quit the protocol}
                    if xCanCounter <> 0 then begin
                      aProtocolStatus := psCancelRequested;
                      aForceStatus := True;
                    end;
                    xXmodemState := rxFinished;
                  end else begin
                    {Simple timeout, resend handshake}
                    xXmodemState := rxWaitForHSReply;
                    xpSendHandshakeChar(P, xHandshake);
                    ValidDispatcher.SetTimerTrigger(aTimeoutTrigger, xBlockWait, True);
                  end;
                end;

              rxCollectBlock :
                if TriggerID = aDataTrigger then begin
                  {Got data, collect into DataBlock}
                  if xpCollectBlock(P, aDataBlock^) then
                    xXmodemState := rxProcessBlock;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout out waiting for complete block, send nak}
                  ValidDispatcher.PutChar(cNak);
                  xXmodemState := rxWaitForBlockStart;
                  aProtocolStatus := psTimeout;
                  ValidDispatcher.SetTimerTrigger(aTimeoutTrigger, xBlockWait, True);
                end;

              rxProcessBlock :
                begin
                  {Go process what's in DataBlock}
                  xpReceiveBlock(P, aDataBlock^, aLastBlockSize, xHandshake);
                  xpSendHandshakeChar(P, xHandshake);
                  if aProtocolStatus = psOK then begin
                    {Got block ok, go write it out (skip blocknum bytes)}
                    DataPtr := aDataBlock;
                    DataPtr := AddWordToPtr(DataPtr, 2);
                    apWriteProtocolBlock(P, DataPtr^, aLastBlockSize);
                    if aProtocolError <> ecOK then begin
                      {Failed to write the block, cancel protocol}
                      xpCancel(P);
                      xXmodemState := rxFinished;
                    end else begin
                      {Normal received block -- keep going}
                      Inc(aFileOfs, aLastBlockSize);
                      xXmodemState := rxWaitForBlockStart;
                      ValidDispatcher.SetTimerTrigger(aTimeoutTrigger, xBlockWait, True);
                    end;
                  end else begin
                    if (aProtocolError <> ecOK) or xGMode then begin
                      {Fatal error - cancel protocol}
                      xpCancel(P);
                      xXmodemState := rxFinished;
                    end else begin
                      {Failed to get block, go try again}
                      xXmodemState := rxWaitForHSReply;
                      ValidDispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                    end;
                  end;
                end;

              rxFinishedSkip :
                begin
                  apFinishWriting(P);
                  apLogFile(P, lfReceiveSkip);
                  Cleanup(True);
                end;

              rxFinished :
                begin
                  apFinishWriting(P);
                  if (aProtocolStatus = psEndFile) then
                    apLogFile(P, lfReceiveOk)
                  else
                    apLogFile(P, lfReceiveFail);
                  Cleanup(True);
                end;
            end;

    ExitPoint:
            {Should we exit or not}
            case xXmodemState of
              {Stay in state machine}
              rxProcessBlock,
              rxFinishedSkip,
              rxFinished           : Finished := False;

              {Stay in state machine if data available}
              rxWaitForBlockStart,
              rxCollectBlock        : begin
                                        Finished := not ValidDispatcher.CharReady;
                                        TriggerID := aDataTrigger;
                                      end;

              {Finished with state machine}
              rxInitial,
              rxWaitForHSReply,
              rxDone                : Finished := True
              else                    Finished := True;
            end;
          except                                                       {!!.01}
            on EAccessViolation do begin                               {!!.01}
              Finished := True;                                        {!!.01}
              aProtocolError := ecAbortNoCarrier;                      {!!.01}
              apSignalFinish(P);                                       {!!.01}
            end;                                                       {!!.01}
          end;                                                         {!!.01}
        until Finished;
      {$IFDEF Win32}                                                 {!!.01}
      LeaveCriticalSection(P^.aProtSection);                         {!!.01}
      {$ENDIF}                                                       {!!.01}
    end;
  end;

  procedure xpReceive(Msg, wParam : Cardinal; lParam : LongInt);
  begin
    xpReceivePrim(Msg, wParam, lParam);
  end;

end.
