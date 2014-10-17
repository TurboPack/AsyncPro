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
{*                   AWASCII.PAS 4.06                    *}
{*********************************************************}
{* ASCII protocol                                        *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$I-,B-,F+,A-,X+,J+}

unit AwAscii;
  {-Provides ASCII recieve and transmit functions}

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

function spInit(var P : PProtocolData; H : TApdCustomComPort; Options : Cardinal) : Integer;
procedure spDone(var P : PProtocolData);

function spReinit(P : PProtocolData) : Integer;
procedure spDonePart(P : PProtocolData);

{Options}
function spSetDelays(P : PProtocolData; CharDelay, LineDelay : Cardinal) : Integer;
function spSetEOLChar(P : PProtocolData; C : AnsiChar) : Integer;
function spGetLineNumber(P : PProtocolData) : LongInt;
function spSetEOLTranslation(P : PProtocolData; CR, LF : Cardinal) : Integer;
function spSetEOFTimeout(P : PProtocolData; NewTimeout : LongInt) : Integer;

{Control}
procedure spPrepareTransmit(P : PProtocolData);
procedure spPrepareReceive(P : PProtocolData);
procedure spTransmit(Msg, wParam : Cardinal; lParam : LongInt);
procedure spReceive(Msg, wParam : Cardinal; lParam : LongInt);

implementation

const
  {Compile time constants}
  awaDefInterCharDelay = 0;   {Default is zero ms delay between chars}
  awaDefInterLineDelay = 0;   {Default is zero ms delay between lines}
  awaDefEOLChar = cCR;        {Default EOL char is carriage return}
  awaDefRcvTimeout = 364;     {Default Ticks to assume end of receive, 20 sec}
  awaDefBlockLen = 60;        {Default block length (assume avg of 60)}
                           {Note: must be less than SizeOf(TDataBlock)-1}
  awaDefCRTranslate = atNone; {Default CR Translation is none}
  awaDefLFTranslate = atNone; {Default LF Translation is none}
  awaDefMaxAccumDelay = 250;  {Max accum milliseconds to delay in one call}

  aDataTrigger = 0;

  LogAsciiState : array[TAsciiState] of TDispatchSubType = (          
     dsttaInitial, dsttaGetBlock, dsttaWaitFreeSpace, dsttaSendBlock,
     dsttaSendDelay, dsttaFinishDrain, dsttaFinished, dsttaDone,
     dstraInitial, dstraCollectBlock, dstraProcessBlock,
     dstraFinished, dstraDone);

{Ascii protocol}

  procedure spInitData(P : PProtocolData);
    {-Init data}
  begin
    with P^ do begin
      {Init Ascii data}
      sInterCharDelay   := awaDefInterCharDelay;
      sInterLineDelay   := awaDefInterLineDelay;
      sEOLChar          := awaDefEOLChar;
      sCtrlZEncountered := False;
      aRcvTimeout       := awaDefRcvTimeout;
      sMaxAccumDelay    := awaDefMaxAccumDelay;
      aBlockLen         := awaDefBlockLen;
      aCheckType        := bcNone;
      aCurProtocol      := Ascii;
      sCRTransMode      := awaDefCRTranslate;
      sLFTransMode      := awaDefLFTranslate;

    end;
  end;

  function spInit(var P : PProtocolData; H : TApdCustomComPort; Options : Cardinal) : Integer;
  {-Allocates and initializes a protocol control block with Options}
  begin
    {Check for adequate output buffer size}
    if H.OutBuffUsed + H.OutBuffFree < 1024 then begin
      spInit := ecOutputBufferTooSmall;
      Exit;
    end;

    {Allocate block for protocol}
    if apInitProtocolData(P, H, Options) <> ecOk then begin
      spInit := ecOutOfMemory;
      Exit;
    end;

    {Get a protocol DataBlock}
    with P^ do begin
      aDataBlock := AllocMem(SizeOf(TDataBlock));

      {Can't fail after this}
      spInit := ecOK;

      spInitData(P);
    end;
  end;

  function spReinit(P : PProtocolData) : Integer;
    {-Allocates and initializes a protocol control block with Options}
  begin
    {Get a protocol DataBlock}
    with P^ do begin
      aDataBlock := AllocMem(SizeOf(TDataBlock));

      {Can't fail after this}
      spReinit := ecOK;
      spInitData(P);
      apResetReadWriteHooks(P);
    end;
  end;

  procedure spDonePart(P : PProtocolData);
    {-Disposes of P}
  begin
    with P^ do begin
      FreeMem(aDataBlock, SizeOf(TDataBlock));
    end;
  end;

  procedure spDone(var P : PProtocolData);
    {-Disposes of P}
  begin
    spDonePart(P);
    apDoneProtocol(P);
  end;

  function spSetDelays(P : PProtocolData;
                       CharDelay, LineDelay : Cardinal) : Integer;
    {-Set the delay (in ms) between each character and each line}

    function Cvt2Ticks(MS : Cardinal) : Cardinal;
      {-Convert to ticks rounding up}
    begin
      if MS mod 55 = 0 then
        Cvt2Ticks := MS div 55
      else
        Cvt2Ticks := (MS div 55) + 1;
    end;

  begin
    with P^ do begin
      if aCurProtocol <> Ascii then
        spSetDelays := ecBadProtocolFunction
      else begin
        spSetDelays := ecOK;
        sInterCharDelay := CharDelay;
        sInterLineDelay := LineDelay;
        sInterCharTicks := Cvt2Ticks(sInterCharDelay);
        sInterLineTicks := Cvt2Ticks(sInterLineDelay);
      end;
    end;
  end;

  function spSetEOLChar(P : PProtocolData; C : AnsiChar) : Integer;
    {-Set the character used to mark the end of line}
  begin
    with P^ do
      if aCurProtocol <> Ascii then
        spSetEOLChar := ecBadProtocolFunction
      else begin
        spSetEOLChar := ecOK;
        sEOLChar := C;
      end;
  end;

  function spGetLineNumber(P : PProtocolData) : LongInt;
    {-Return the current line number}
  begin
    with P^ do
      if aCurProtocol <> Ascii then
        spGetLineNumber := 0
      else
        spGetLineNumber := P^.aBlockNum;
  end;

  function spSetEOLTranslation(P : PProtocolData; CR, LF : Cardinal) : Integer;
    {-Set the translation modes for CR/LF translations}
  begin
    with P^ do
      if aCurProtocol <> Ascii then
        spSetEOLTranslation := ecBadProtocolFunction
      else begin
        spSetEOLTranslation := ecOK;
        sCRTransMode := CR;
        sLFTransMode := LF;
      end;
  end;

  function spSetEOFTimeout(P : PProtocolData; NewTimeout : LongInt) : Integer;
    {-Set the EOF timeout, in ticks}
  begin
    with P^ do
      if aCurProtocol <> Ascii then
        spSetEOFTimeout := ecBadProtocolFunction
      else begin
        spSetEOFTimeout := ecOK;
        aRcvTimeout := NewTimeout;
      end;
  end;

  procedure spCancel(P : PProtocolData);
    {-Cancel the Ascii protocol}
  begin
    with P^ do
      if aHC.Open then                                                 
        {Flush anything that might be left in the output buffer}
        aHC.FlushOutBuffer;
  end;

  function spSendBlockPart(P : PProtocolData; var Block : TDataBlock) : Boolean;
    {-Send part of the block, return True when finished}
  var
    AccumDelay : Cardinal;
    C : AnsiChar;
    Finished : Boolean;

    procedure SendChar(C : AnsiChar);
      {-Send current character and increment count}
    begin
      with P^ do begin
        {Send the character}
        aHC.PutChar(C);
        Inc(aBytesTransferred);
        Dec(aBytesRemaining);
      end;
    end;

  begin
    with P^ do begin
      {Assume not finished}
      spSendBlockPart := False;

      {Send as much data as we can}
      AccumDelay := 0;
      Finished := sSendIndex >= aLastBlockSize;
      while not Finished do begin
        {Get next character to send}
        Inc(sSendIndex);
        C := Block[sSendIndex];

        {Check character before sending}
        case C of
          {^Z : if FlagIsSet(aFlags, apAsciiSuppressCtrlZ) then begin} 
                 {spSendBlockPart := True;}
                 {Exit;}
               {end;}

          ^M : if sCRTransMode = atAddLFAfter then begin
                 aHC.PutString(^M^J);
                 Inc(aBytesTransferred, 2);
                 Dec(aBytesRemaining, 2);
               end else if sCRTransMode <> atStrip then
                 SendChar(^M);

          ^J : if sLFTransMode = atAddCRBefore then begin
                 aHC.PutString(^M^J);
                 Inc(aBytesTransferred, 2);
                 Dec(aBytesRemaining, 2);
               end else if sLFTransMode <> atStrip then
                 SendChar(^J);

           else begin                                                  
                  if C = atEOFMarker then begin                        
                    if FlagIsSet(aFlags, apAsciiSuppressCtrlZ) then begin 
                      spSendBlockPart := True;                         
                      aNoMoreData := True;                                  // SWB                         
                      Exit;
                    end;
                  end;                                                      // SWB
                  SendChar(C);                                              // SWB
                end;                                                   
        end;

        {Check for interline delay}
        if (C = sEOLChar) and (sInterLineDelay > 0) then begin
          if sInterLineDelay + AccumDelay < sMaxAccumDelay then
            Inc(AccumDelay, DelayMS(sInterLineDelay))
          else begin
            aHC.SetTimerTrigger(aTimeoutTrigger, sInterLineTicks, True);
            sAsciiState := taSendDelay;
            Exit;
          end;
        end;

        {Check for interchar delay}
        if sInterCharDelay > 0 then begin
          if sInterCharDelay + AccumDelay < sMaxAccumDelay then
            Inc(AccumDelay, DelayMS(sInterCharDelay))
          else begin
            aHC.SetTimerTrigger(aTimeoutTrigger, sInterCharTicks, True);
            sAsciiState := taSendDelay;
            Exit;
          end;
        end;

        {Set Finished flag}
        Finished := (sSendIndex >= aLastBlockSize) or
                    (AccumDelay > sMaxAccumDelay);
      end;

      {End of block if we get here}
      spSendBlockPart := True;
    end;
  end;

  function apCollectBlock(P : PProtocolData; var Block : TDataBlock) : Boolean;
    {-Collect received data into aDataBlock, return True for full block}
    {-Note: may go one past BlockLen}
  var
    C : AnsiChar;
    GotEOFMarker : Boolean;                                            

    procedure AddChar(C : AnsiChar);
      {-Add C to buffer}
    begin
      with P^ do begin
        Inc(aBlkIndex);
        Block[aBlkIndex] := C;
      end;
    end;

  begin
    with P^ do begin
      apCollectBlock := False;
      GotEOFMarker := False;                                           
      while aHC.CharReady and (aBlkIndex < aBlockLen) do begin

        {Start the protocol timer if first time thru}
        if aTimerPending then begin
          aTimerPending := False;
          NewTimer(aTimer, 0);
        end;

        {Get the char}
        aHC.ValidDispatcher.GetChar(C);

        {Character translations}
        case C of
          ^M : if sCRTransMode = atAddLFAfter then begin
                 AddChar(^M);
                 AddChar(^J);
               end else if sCRTransMode <> atStrip then
                 AddChar(^M);

          ^J : if sLFTransMode = atAddCRBefore then begin
                 AddChar(^M);
                 AddChar(^J);
               end else if sCRTransMode <> atStrip then
                 AddChar(^J);

          {^Z : begin}                                                 
                 {GotEOFMarker := True;}                               
                 {if not FlagIsSet(aFlags, apAsciiSuppressCtrlZ) then} 
                   {AddChar(^Z);}                                      
               {end;}                                                  

          else begin                                                   
                 if C = atEOFMarker then begin                         
                   GotEOFMarker := True;                               
                   if not FlagIsSet(aFlags, apAsciiSuppressCtrlZ) then 
                     AddChar(atEOFMarker);                             
                 end else                                              
                   AddChar(C);
               end;                                                    
        end;
        apCollectBlock := (aBlkIndex >= aBlockLen) or (GotEOFMarker);  
      end;
    end;
  end;

  procedure apReceiveBlock(P : PProtocolData; var Block : TDataBlock;
                           var BlockSize : Cardinal; var HandShake : AnsiChar);
    {-Receive block into Buffer}
  var
    I : Cardinal;
  begin
    with P^ do begin
      {Check for ^Z}
      I := 1;
      while (I < BlockSize) and not sCtrlZEncountered do begin
        if Block[I] = atEOFMarker then begin                           
          BlockSize := I;
          sCtrlZEncountered := True;
        end else
          Inc(I);
      end;

      {Update data areas and show status}
      Inc(aBytesTransferred, BlockSize);
      aElapsedTicks := ElapsedTime(aTimer);
    end;
  end;

  procedure spPrepareTransmit(P : PProtocolData);
    {-Prepare for transmitting ASCII}
  begin
    with P^ do begin
      aFindingFirst := True;
      aFileListIndex := 0;
      apResetStatus(P);
      apShowFirstStatus(P);
      if not apNextFile(P, aPathname) then begin
        apShowLastStatus(P);
        Exit;
      end;

      sCtrlZEncountered := False;
      aBlockNum := 0;
      aForceStatus := True;
      sAsciiState := taInitial;
      aProtocolError := ecOK;
      aNoMoreData := False;
    end;
  end;

  procedure spTransmit(Msg, wParam : Cardinal;
                     lParam : LongInt);
    {-Performs one increment of an ASCII transmit}
  var
    TriggerID   : Cardinal absolute wParam;
    P           : PProtocolData;
    Finished    : Boolean;
    StatusTicks : LongInt;                                        
    Dispatcher      : TApdBaseDispatcher;
  begin
    Finished := False;                                                 {!!.01}
    {Get the protocol pointer from data pointer 1}
    try                                                                {!!.01}
      Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
      with Dispatcher do
        GetDataPointer(Pointer(P), 1);
    except                                                             {!!.01}
      on EAccessViolation do begin                                     {!!.01}
        { There is no access to P^, and consequently to the port, }    {!!.01}
        { the TApdProtocol componenet handle, or anything else, so }   {!!.01}
        { the only thing to do here is exit }                          {!!.01}
        Exit;
      end;                                                             {!!.01}
    end;                                                               {!!.01}

    with P^ do begin
      {Function result is always zero unless the protocol is over}

      {$IFDEF Win32}
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if sAsciiState = taDone then begin
        LeaveCriticalSection(aProtSection);
        Exit;
      end;
      {$ENDIF}
        {Force TriggerID for TriggerAvail messages}
        if Msg = apw_TriggerAvail then
          TriggerID := aDataTrigger;

        repeat
          try                                                          {!!.01}
            if Dispatcher.Logging then
              Dispatcher.AddDispatchEntry(
                dtAscii,LogAsciiState[sAsciiState],0,nil,0);

            {Check for user or remote abort}
            if (Integer(TriggerID) = aNoCarrierTrigger) or
               (Msg = apw_ProtocolCancel) then begin
              if Integer(TriggerID) = aNoCarrierTrigger then
                aProtocolStatus := psAbortNoCarrier
              else
                aProtocolStatus := psCancelRequested;
              spCancel(P);
              sAsciiState := taFinished;
              aForceStatus := False;
            end;

            if (Integer(TriggerID) = aStatusTrigger) or aForceStatus then begin
              aElapsedTicks := ElapsedTime(aTimer);
              if Dispatcher.TimerTicksRemaining(aStatusTrigger,
                                      StatusTicks) <> 0 then
                StatusTicks := 0;
              if StatusTicks <= 0 then begin
                apShowStatus(P, 0);
                Dispatcher.SetTimerTrigger(aStatusTrigger, aStatusInterval, True);
                aForceStatus := False;
              end;                                                         
            end;

            {Process current state}
            case sAsciiState of
              taInitial :
                begin
                  {Pathname must already be set before we get here}
                  if aUpcaseFileNames then
                    AnsiUpper(aPathname);

                  {Show file name to user logging routine}
                  apLogFile(P, lfTransmitStart);

                  {Go prepare for reading protocol blocks}
                  apPrepareReading(P);
                  if aProtocolError = ecOK then begin
                    sAsciiState := taGetBlock;
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                  end else
                    sAsciiState := taFinished;
                  NewTimer(aTimer, 1);
                end;

              taGetBlock :
                begin
                  aLastBlockSize := aBlockLen;
                  aNoMoreData := apReadProtocolBlock(P, aDataBlock^, aLastBlockSize);
                  if (aProtocolError = ecOK) and (aLastBlockSize <> 0) then begin
                    sAsciiState := taWaitFreespace;
                    sSendIndex := 0;
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                    Dispatcher.SetStatusTrigger(aOutBuffFreeTrigger, aBlockLen+1, True);
                  end else
                    sAsciiState := taFinished;
                end;

              taWaitFreeSpace :
                if Integer(TriggerID) = aOutBuffFreeTrigger then
                  sAsciiState := taSendBlock
                else if Integer(TriggerID) = aTimeoutTrigger then       
                  sAsciiState := taFinished;

              taSendBlock :
                if spSendBlockPart(P, aDataBlock^) then begin
                  {Adjust block number and file position}
                  Inc(aBlockNum);
                  Inc(aFileOfs, aBlockLen);

                  {Go get next block to send}
                  if aNoMoreData then begin
                    sAsciiState := taFinishDrain;
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aTransTimeout, True);
                    Dispatcher.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                  end else
                    sAsciiState := taGetBlock;

                  {Update timer and force status}
                  aElapsedTicks := ElapsedTime(aTimer);
                  aForceStatus := True;
                end;

              taSendDelay :
                if Integer(TriggerID) = aTimeoutTrigger then
                  sAsciiState := taSendBlock;

              taFinishDrain :
                if Integer(TriggerID) = aOutBuffUsedTrigger then begin
                  sAsciiState := taFinished;
                  aProtocolStatus := psEndFile;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  apProtocolError(P, ecTimeout);
                  sAsciiState := taFinished;
                end;

              taFinished :
                begin
                  if aProtocolError <> ecOK then
                    Dispatcher.FlushInBuffer;

                  {Close the file}
                  apFinishReading(P);

                  {Show status, user logging, and clean up}
                  if aProtocolError = ecOK then
                    apLogFile(P, lfTransmitOk)
                  else
                    apLogFile(P, lfTransmitFail);
                  apShowLastStatus(P);

                  {Tell parent we're finished}
                  apSignalFinish(P);
                  sAsciiState := taDone;
                end;
            end;

            {Should we exit or not}                   
            case sAsciiState of
              {Stay in state machine}
              taGetBlock,
              taSendBlock,
              taFinished : Finished := False;

              {Exit state machine to wait for trigger}
              taFinishDrain,
              taWaitFreeSpace,
              taSendDelay,
              taDone : Finished := True;
              else     Finished := False;
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

  procedure spPrepareReceive(P : PProtocolData);
    {-Prepare to receive by Ascii protocol}
  begin
    with P^ do begin
      {Prepare to enter state machine}
      sAsciiState := raInitial;
      sCtrlZEncountered := False;
      apResetStatus(P);
      apShowFirstStatus(P);
      aProtocolError := ecOK;
      aForceStatus := False;
    end;
  end;

  procedure spReceive(Msg, wParam : Cardinal;
                     lParam : LongInt);
    {-Performs one increment of an Ascii receive}
  label
    ExitPoint;
  var
    TriggerID   : Cardinal absolute wParam;
    P           : PProtocolData;
    BlockSize   : Cardinal;
    Finished    : Boolean;
    Handshake   : AnsiChar;
    StatusTicks : LongInt;
    Dispatcher  : TApdBaseDispatcher;

    procedure Cleanup(DisposeBuffers : Boolean);
      {-Handle error reporting and other cleanup}
    begin
      with P^ do begin
        {if DisposeBuffers then}
        {  FreeMemCheck(aDataBlock, SizeOf(TDataBlock));}
        apShowLastStatus(P);

        {Tell parent we're finished}
        apSignalFinish(P);
        sAsciiState := raDone;
      end;
    end;

  begin
    Finished := False;                                                 {!!.01}                                                     
    {Get the protocol pointer from data pointer 1}
    try                                                                {!!.01}
      Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
      with Dispatcher do
        GetDataPointer(Pointer(P), 1);
    except                                                             {!!.01}
      on EAccessViolation do begin                                     {!!.01}
        { There is no access to P^ here, so the only thing to do is }  {!!.01}
        { exit }                                                       {!!.01}
        Exit;                                                          {!!.01}
      end;                                                             {!!.01}
    end;                                                               {!!.01}

    with P^ do begin
      {$IFDEF Win32}
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if sAsciiState = raDone then begin
        LeaveCriticalSection(aProtSection);
        Exit;
      end;
      {$ENDIF}
        {Force TriggerID for TriggerAvail messages}
        if Msg = apw_TriggerAvail then
          TriggerID := aDataTrigger;

        repeat
          try                                                          {!!.01}
            if Dispatcher.Logging then
              Dispatcher.AddDispatchEntry(
                dtAscii,LogAsciiState[sAsciiState],0,nil,0);

            {Check for use abort}
            if (Integer(TriggerID) = aNoCarrierTrigger) or
               (Msg = apw_ProtocolCancel) then begin
              if Integer(TriggerID) = aNoCarrierTrigger then           
                aProtocolStatus := psAbortNoCarrier
              else
                aProtocolStatus := psCancelRequested;
              spCancel(P);
              sAsciiState := raFinished;
              aForceStatus := False;
            end;

            {Show status periodically}
            if (Integer(TriggerID) = aStatusTrigger) or aForceStatus then begin
              if Dispatcher.TimerTicksRemaining(aStatusTrigger,
                                      StatusTicks) <> 0 then
                StatusTicks := 0;
              if StatusTicks <= 0 then begin
                apShowStatus(P, 0);
                Dispatcher.SetTimerTrigger(aStatusTrigger, aStatusInterval, True);
                aForceStatus := False;
              end;                                                          
            end;

            {Process current state}
            case sAsciiState of
              raInitial :
                begin
                  {Pathname should already have name of file to receive}
                  if aPathname[0] = #0 then begin
                    apProtocolError(P, ecNoFilename);
                    Cleanup(True);
                    goto ExitPoint;
                  end else if aUpcaseFileNames then
                    AnsiUpper(aPathname);

                  {Send file name to user's LogFile procedure}
                  apLogFile(P, lfReceiveStart);

                  {Accept this file}
                  if not apAcceptFile(P, aPathname) then begin
                    spCancel(P);
                    aProtocolStatus := psFileRejected;
                    goto ExitPoint;
                  end;

                  {Prepare file for writing protocol blocks}
                  apPrepareWriting(P);
                  if (aProtocolError <> ecOK) or
                     (aProtocolStatus = psCantWriteFile) then begin
                    if aProtocolStatus = psCantWriteFile then
                      aProtocolError := ecCantWriteFile;
                    spCancel(P);
                    sAsciiState := raFinished;
                    goto ExitPoint;
                  end;

                  {Prepare to collect first block}
                  sAsciiState := raCollectBlock;
                  aFileOfs := 0;
                  aBlockNum := 1;
                  aBlkIndex := 0;
                  aForceStatus := True;

                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aRcvTimeout, True);
                  aTimerPending := True;
                end;

              raCollectBlock :
                if TriggerID = aDataTrigger then begin
                  if apCollectBlock(P, aDataBlock^) then
                    sAsciiState := raProcessBlock;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout out waiting for complete block, assume EOF}
                  sCtrlZEncountered := True;
                  sAsciiState := raProcessBlock;
                end;

              raProcessBlock :
                begin
                  {Go process what's in aDataBlock}
                  BlockSize := aBlkIndex;
                  apReceiveBlock(P, aDataBlock^, BlockSize, Handshake);
                  apWriteProtocolBlock(P, aDataBlock^, BlockSize);
                  if aProtocolError = ecOK then begin
                    {Normal received block}
                    Inc(aFileOfs, BlockSize);
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aRcvTimeout, True);
                    aForceStatus := True;
                    aBlkIndex := 0;
                    if sCtrlZEncountered then
                      sAsciiState := raFinished
                    else
                      sAsciiState := raCollectBlock;
                  end else
                    {Error during write, clean up and exit}
                    sAsciiState := raFinished;
                end;

              raFinished :
                begin
                  apFinishWriting(P);
                  apLogFile(P, lfReceiveOk);
                  Cleanup(True);
                end;
            end;

ExitPoint:
            {Should we exit or not}
            case sAsciiState of
              {Stay in state machine or exit?}
              raProcessBlock,
              raFinished : Finished := False;

              raCollectBlock : begin
                                 Finished := not Dispatcher.CharReady;
                                 TriggerID := aDataTrigger;
                               end;
              raDone : Finished := True;
              else     Finished := True;
            end;
          except                                                       {!!.01}
            on EAccessViolation do begin                               {!!.01}
              Finished := True;                                        {!!.01}
              aProtocolError := ecAbortNoCarrier;                      {!!.01}
              apSignalFinish(P);                                       {!!.01}
            end;                                                       {!!.01}
          end;                                                         {!!.01}
        until Finished;                                                {!!.01}
      {$IFDEF Win32}                                                 {!!.01}
      LeaveCriticalSection(P^.aProtSection);                         {!!.01}
      {$ENDIF}                                                       {!!.01}
    end;                                                               {!!.01}
  end;

end.
