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
{*                   AWYMODEM.PAS 4.06                   *}
{*********************************************************}
{* YModem protocol                                       *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$I-,B-,F+,A-,X+}

unit AwYmodem;
  {-Provides Ymodem/YmodemG recieve and transmit functions}

interface

uses
  Windows,
  Messages,
  SysUtils,
  OoMisc,
  AwUser,
  AwTPcl,
  AwAbsPcl,
  AwXmodem,
  AdPort;    

{constructors/destructors}
function ypInit(var P : PProtocolData; H : TApdCustomComPort;         
                Use1K, UseGMode : Boolean;
                Options : Cardinal) : Integer;
procedure ypDone(var P : PProtocolData);

function ypReinit(P : PProtocolData; Use1K, UseGMode : Boolean) : Integer;
procedure ypDonePart(P : PProtocolData);

{Control}
procedure ypPrepareTransmit(P : PProtocolData);
procedure ypPrepareReceive(P : PProtocolData);
procedure ypTransmit(Msg, wParam : Cardinal; lParam : LongInt);
procedure ypReceive(Msg, wParam : Cardinal; lParam : LongInt);

implementation

const
  aDataTrigger = 0;
  LogYModemState : array[TYmodemState] of TDispatchSubType = (        
     dsttyInitial, dsttyHandshake, dsttyGetFileName, dsttySendFileName,
     dsttyDraining, dsttyReplyPending, dsttyPrepXmodem, dsttySendXmodem,
     dsttyFinished, dsttyFinishDrain, dsttyDone, dstryInitial,
     dstryDelay, dstryWaitForHSReply, dstryWaitForBlockStart,
     dstryCollectBlock, dstryProcessBlock, dstryOpenFile,
     dstryPrepXmodem, dstryReceiveXmodem, dstryFinished, dstryDone);

  procedure ypInitData(P : PProtocolData; Use1K, UseGMode : Boolean);
    {-Allocates and initializes a protocol control block with options}
  begin
    with P^ do begin
      {Set modes}
      aCurProtocol := Ymodem;
      xpSetCRCMode(P, True);
      xpSet1KMode(P, Use1K);
      xpSetGMode(P, UseGMode);

      {Other inits}
      aBatchProtocol := True;

      {Don't ask for any EOT retries}
      xEotCheckCount := 0;
    end;
  end;

  function ypInit(var P : PProtocolData; H : TApdCustomComPort;       
                  Use1K, UseGMode : Boolean;
                  Options : Cardinal) : Integer;
    {-Allocates and initializes a protocol control block with options}
  var
    InSize, OutSize : Cardinal;
  begin
    {Check for adequate output buffer size}
    H.ValidDispatcher.BufferSizes(InSize, OutSize);
    if OutSize < (1024+XmodemOverhead) then begin
      ypInit := ecOutputBufferTooSmall;
      Exit;
    end;

    {Init standard data}
    if apInitProtocolData(P, H, Options) <> ecOk then begin
      ypInit := ecOutOfMemory;
      Exit;
    end;

    with P^ do begin
      {Allocate the name block buffer}
      yFileHeader := AllocMem(SizeOf(TDataBlock)+XmodemOverhead);

      {Can't fail after this}
      ypInit := ecOK;

      {Init the protocol data}
      ypInitData(P, Use1K, UseGMode);
    end;
  end;

  function ypReinit(P : PProtocolData; Use1K, UseGMode : Boolean) : Integer;
    {-Allocates and initializes a protocol control block with options}
  begin
    with P^ do begin
      {Allocate the name block buffer}
      yFileHeader := AllocMem(SizeOf(TDataBlock)+XmodemOverhead);

      {Can't fail after this}
      ypReinit := ecOK;

      {Init the data}
      ypInitData(P, Use1K, UseGMode);

      {Reset the read/write hooks}
      apResetReadWriteHooks(P);
    end;
  end;

  procedure ypDone(var P : PProtocolData);
    {-Destroy Ymodem object}
  begin
    if P <> nil then begin
      FreeMem(P^.yFileHeader, SizeOf(TDataBlock)+XmodemOverhead);
      apDoneProtocol(P);
    end;
  end;

  procedure ypDonePart(P : PProtocolData);
    {-Destroy Ymodem object}
  begin
    if P <> nil then
      FreeMem(P^.yFileHeader, SizeOf(TDataBlock)+XmodemOverhead);
  end;

  procedure ypPrepareTransmit(P : PProtocolData);
    {-Prepare to transmit a Ymodem batch}
  begin
    with P^ do begin
      {Reset status vars}
      apResetStatus(P);
      aProtocolStatus := psProtocolHandshake;
      apShowFirstStatus(P);
      aForceStatus := False;
      aTimerStarted := False;

      {Set first state}
      yYmodemState := tyInitial;

      {Flush trigger buffer}
      aHC.FlushInBuffer;
    end;
  end;

  procedure ypTransmit(Msg, wParam : Cardinal;
                      lParam : LongInt);
    {-Perform one increment of Ymodem batch transmit}
  label
    ExitPoint;
  var
    TriggerID   : Cardinal absolute wParam;
    XState      : Cardinal;
    Finished    : Boolean;
    StatusTicks : Longint;                                         
    ExitStateMachine : Boolean;
    I           : Integer;
    P           : PProtocolData;
    Len         : Byte;
    S2          : string[13];
    S1          : TPathCharArrayA;
    S           : string[fsPathname];
    Name        : string[fsName];
    Dispatcher      : TApdBaseDispatcher;

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
        end else
          CheckErrors := False;
      end;
    end;

  begin
    Finished := False;                                                 {!!.01}
    try                                                                {!!.01}
      {Get the protocol pointer from data pointer 1}
      Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
      with Dispatcher do
        GetDataPointer(Pointer(P), ProtocolDataPtr);
    except                                                             {!!.01}
      on EAccessViolation do                                           {!!.01}
        { No access to P^, just exit }                                 {!!.01}
        Exit;                                                          {!!.01}
    end;                                                               {!!.01}

    with P^ do begin
      {$IFDEF Win32}
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if yYmodemState = ryDone then begin
        LeaveCriticalSection(aProtSection);
        Exit;
      end;
      {$ENDIF}

        {Set TriggerID directly for TriggerAvail messages}
        if Msg = apw_TriggerAvail then
          TriggerID := aDataTrigger;

        repeat
          try                                                          {!!.01}         
            if Dispatcher.Logging then
              Dispatcher.AddDispatchEntry(
                dtYModem,LogYModemState[yYmodemState],0,nil,0);

            {Check for user or remote abort}
            if (Integer(TriggerID) = aNoCarrierTrigger) or
               (Msg = apw_ProtocolAbort) or
               (Msg = apw_ProtocolCancel) then begin
              if Msg = apw_ProtocolCancel then begin
                xpCancel(P);
                aProtocolStatus := psCancelRequested;
              end else if (Msg = apw_ProtocolAbort) then                    
                aProtocolStatus := psAbort                                  
              else                                                          
                aProtocolStatus := psAbortNoCarrier;
              yYmodemState := tyFinished;
              aForceStatus := False;
              apLogFile(P, lfTransmitFail);
            end;

            {Show status periodically}
            if yYmodemState <> tySendXmodem then begin
              if (Integer(TriggerID) = aStatusTrigger) or aForceStatus then begin
                if aTimerStarted then
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
            end;

            ExitStateMachine := True;

            {Process current state}
            case yYmodemState of
              tyInitial :
                begin
                  {Check for handshake character}
                  yYmodemState := tyHandshake;
                  aHandshakeAttempt := 0;
                  if not xpPrepHandshake(P) then
                    yYmodemState := tyFinished;
                end;

              tyHandshake :
                if TriggerID = aDataTrigger  then begin
                  if xpProcessHandshake(P) then begin
                    {Start protocol timer now}
                    aTimerStarted := True;
                    NewTimer(aTimer, 1);
                    aBlockErrors := 0;
                    yYmodemState := tyGetFileName;
                    {If GMode don't allow any more errors}
                    if xGMode then
                      xMaxBlockErrors := 0;
                  end else begin
                    {Not a valid handshake character, note error}
                    if not xpPrepHandshake(P) then
                      yYmodemState := tyFinished;
                  end;
                end else if Integer(TriggerID) = aTimeoutTrigger then      
                  {Timeout waiting for handshake character, note error}
                  if not xpPrepHandshake(P) then
                    yYmodemState := tyFinished;

              tyGetFileName :
                if apNextFile(P, aPathName) then begin
                  {Open file now to get size and date stamp}
                  apPrepareReading(P);

                  {Quit if we couldn't open the file}
                  if aProtocolError <> ecOk then begin
                    yYmodemState := tyFinished;
                    goto ExitPoint;
                  end;

                  {Save the file name and length}
                  StrLCopy(ySaveName, aPathName, SizeOf(ySaveName));
                  ySaveLen := aSrcFileLen;

                  {Make a Ymodem file header record}
                  FillChar(yFileHeader^, SizeOf(yFileHeader^)+XmodemOverhead, 0);

                  {Fill in the file name}
                  S := StrPas(aPathName);
                  Name := ExtractFileName(S);
                  if FlagIsSet(aFlags, apIncludeDirectory) then
                    StrPCopy(S1, S)
                  else
                    StrPCopy(S1, Name);

                  {Change name to lower case, change '\' to '/'}
                  Len := StrLen(S1);
                  AnsiLowerBuff(S1, Len);
                  for I := 0 to Len-1 do begin
                    {S1[I] := LoCaseMac(S1[I]);}
                    if S1[I] = '\' then
                      S1[I] := '/';
                  end;
                  Move(S1[0], yFileHeader^, Len);

                  {Fill in file size}
                  Str(aSrcFileLen, S2);
                  Move(S2[1], yFileHeader^[Len+2], Length(S2));
                  Inc(Len, Length(S2));

                  {Convert time stamp to Ymodem format and stuff in yFileHeader}
                  if aSrcFileDate <> 0 then begin
                    S2 := ' ' + apOctalStr(apPackToYMTimeStamp(aSrcFileDate));
                    Move(S2[1], yFileHeader^[Len+2], Length(S2));
                    Inc(Len, Length(S2)+2);
                  end;

                  {Determine block size from the used part of the yFileHeader}
                  if Len <= 128 then begin
                    aBlockLen := 128;
                    x1KMode := False;
                    xStartChar := cSoh;
                  end else begin
                    aBlockLen := 1024;
                    x1KMode := True;
                    xStartChar := cStx;
                  end;

                  {Init status vars for the header transfer}
                  aSrcFileLen := aBlockLen;
                  aBytesRemaining := aBlockLen;
                  aBytesTransferred := 0;
                  aElapsedTicks := 0;
                  aPathname[0] := #0;

                  {Go send the file header}
                  yYmodemState := tySendFileName;
                end else
                  yYModemState := tyFinished;

              tySendFileName :
                begin
                  {Send the file header}
                  aBlockNum := 0;
                  xpTransmitBlock(P, yFileHeader^, aBlockLen, ' ');
                  if aProtocolError <> ecOK then begin
                    yYmodemState := tyFinished;
                    goto ExitPoint;
                  end;

                  {If we get this far we will eventually need a cleanup block}
                  aFilesSent := True;

                  {Wait for the buffer to drain}
                  yYmodemState := tyDraining;
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, DrainWait, True);
                  Dispatcher.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                end;

              tyDraining :
                if (Integer(TriggerID) = aOutBuffUsedTrigger) or
                   (Integer(TriggerID) = aTimeoutTrigger) then begin      
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, xBlockWait, True);
                  yYmodemState := tyReplyPending;
                end;

              tyReplyPending :
                if TriggerID = aDataTrigger then begin
                  {Process the header reply}
                  if xGMode then
                    yYModemState := tyPrepXmodem
                  else if xpProcessBlockReply(P) then
                    yYmodemState := tyPrepXmodem
                  else if CheckErrors then
                    yYmodemState := tyFinished
                  else
                    yYmodemState := tySendFilename
                end else if Integer(TriggerID) = aTimeoutTrigger then     
                  {Timeout waiting for header reply}
                  if CheckErrors then
                    yYmodemState := tyFinished
                  else
                    yYmodemState := tySendFilename;

              tyPrepXmodem :
                begin
                  {Reset some status vars}
                  aBytesTransferred := 0;
                  aElapsedTicks := 0;

                  {Restore the pathname and file size}
                  if aUpcaseFileNames then
                    AnsiUpper(ySaveName);
                  StrLCopy(aPathname, ySaveName, SizeOf(aPathname));
                  aSrcFileLen := ySaveLen;
                  aBytesRemaining := ySaveLen;

                  if y128BlockMode then begin                            {!!.06}
                  {Start transmitting the file with 128 byte blocks}
                    x1KMode := False;                                    {!!.06}
                    xStartChar := cSOH;                                  {!!.06}
                    aBlockLen := 128;                                    {!!.06}
                  end else begin                                         {!!.06}
                  {Start transmitting the file with 1K blocks}
                    x1KMode := True;
                    xStartChar := cStx;
                    aBlockLen := 1024;
                  end;                                                   {!!.06}
                  aCheckType := bcCrc16;
                  aForceStatus := True;
                  xXmodemState := txInitial;
                  yYmodemState := tySendXmodem;
                  aDataBlock := nil;
                  ExitStateMachine := False;
                  if Dispatcher.CharReady then
                    TriggerID := aDataTrigger;
                end;

              tySendXmodem :
                begin
                  {Let the Xmodem state machine handle it}
                  XState := xpTransmitPrim(apw_FromYmodem,
                                       TriggerID, lParam);
                  if XState = 1 then begin
                    if aProtocolError = ecOK then
                      yYmodemState := tyInitial
                     else
                      yYmodemState := tyFinished;
                  end;
                  ExitStateMachine := True;
                end;

              tyFinished :
                begin
                  apFinishReading(P);
                  if aFilesSent and (aProtocolStatus <> psCancelRequested)
                   and (aProtocolStatus <> psAbort) then begin
                    {Send an empty header block to indicate end of Batch}
                    FillChar(yFileHeader^, 128, 0);
                    aBlockNum := 0;
                    x1KMode := False;
                    aBlockLen := 128;
                    xStartChar := cSoh;
                    xpTransmitBlock(P, yFileHeader^, aBlockLen, ' ');
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aFinishWait, True);
                    Dispatcher.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
                    yYmodemState := tyFinishDrain;
                  end else begin
                    {Never sent any files, quit without sending empty block}
                    apShowLastStatus(P);
                    apSignalFinish(P);
                    yYmodemState := tyDone;
                  end;
                end;

              tyFinishDrain :
                if (Integer(TriggerID) = aTimeoutTrigger) or
                   (Integer(TriggerID) = aOutBuffUsedTrigger) then begin  
                  {We're finished}
                  apShowLastStatus(P);
                  yYmodemState := tyDone;
                  apSignalFinish(P);
                end;
            end;

    ExitPoint:
            {Set function result}
            case yYmodemState of
              {Leave protocol state machine}
              tyDone,
              tyReplyPending,
              tyDraining,
              tyFinishDrain       : Finished := True;

              {Stay in protocol state machine}
              tyGetFileName,
              tySendFileName,
              tyFinished          : Finished := False;

              {Stay in protocol machine if data available}
              tyPrepXmodem,
              tyHandshake         : Finished := not Dispatcher.CharReady;

              {Leave or stay as required}
              tySendXmodem        : Finished := ExitStateMachine;
              else                  Finished := True;
            end;

            {If staying in state machine simulate data received}
            if not Finished then
              TriggerID := aDataTrigger;
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

  procedure ypPrepareReceive(P : PProtocolData);
    {-Prepare for Ymodem receive}
  begin
    with P^ do begin
      {Reset status vars}
      apResetStatus(P);
      aProtocolError := ecOK;
      apShowFirstStatus(P);
      aForceStatus := False;
      aTimerStarted := False;
      yYmodemState := ryInitial;
    end;
  end;

  procedure ypReceive(Msg, wParam : Cardinal; lParam : LongInt);
    {-Ymodem receive state machine}
  label
    ExitPoint;
  var
    TriggerID   : Cardinal absolute wParam;
    P           : PProtocolData;
    Code        : Integer;
    Res         : Cardinal;
    XState      : Cardinal;
    BlockSize   : Cardinal;
    BlockPos    : Integer;
    I           : Integer;
    CurSize     : LongInt;
    Finished    : Boolean;
    StatusTicks : LongInt;                                        
    ExitStateMachine : Boolean;
    C           : AnsiChar;
    F           : File;
    S           : AnsiString;
    {$IFDEF HugeStr}
    SLen        : Byte;
    {$ELSE}
    SLen        : Byte absolute S;
    {$ENDIF}
    S1          : ShortString;
    S1Len       : Byte absolute S1;
    Name        : String[fsName];
    NameExt     : array[0..fsName] of AnsiChar;
    Dispatcher      : TApdBaseDispatcher;

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
        end else
          CheckErrors := False;
      end;
    end;

  begin
    Finished := False;                                                 {!!.01}
    ExitStateMachine := True;

    {Get the protocol pointer from data pointer 1}
    Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
    with Dispatcher do begin
      try                                                              {!!.01}
        GetDataPointer(Pointer(P), ProtocolDataPtr);
      except                                                           {!!.01}
        on EAccessViolation do                                         {!!.01}
          { No access to P^, exit }                                    {!!.01}
          Exit;                                                        {!!.01}
      end;                                                             {!!.01}

    with P^ do begin
      {$IFDEF Win32}
      EnterCriticalSection(aProtSection);

      {Exit if protocol was cancelled while waiting for crit section}
      if yYmodemState = ryDone then begin
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
                dtYModem,LogYModemState[yYmodemState],0,nil,0);

            {Check for user abort}
            if (Integer(TriggerID) = aNoCarrierTrigger) or
                (Msg = apw_ProtocolAbort) or
                (Msg = apw_ProtocolCancel) then begin
              if Msg = apw_ProtocolCancel then begin
                xpCancel(P);
                aProtocolStatus := psCancelRequested;
              end else if (Msg = apw_ProtocolAbort) then
                aProtocolStatus := psAbort
              else
                aProtocolStatus := psAbortNoCarrier;
              apLogFile(P, lfReceiveFail);
              yYmodemState := ryFinished;
              aForceStatus := False;
            end;

            {Show status periodically}
            if yYmodemState <> ryReceiveXmodem then begin
              if (Integer(TriggerID) = aStatusTrigger) or aForceStatus then begin
                if TimerTicksRemaining(aStatusTrigger,
                                        StatusTicks) <> 0 then
                  StatusTicks := 0;
                if StatusTicks <= 0 then begin
                  apShowStatus(P, 0);
                  SetTimerTrigger(aStatusTrigger, aStatusInterval, True);
                  aForceStatus := False;
                end;
              end;
            end;

            {Process current state}
            case yYmodemState of
              ryInitial :
                begin
                  {Manually reset status vars before getting a file header}
                  aSrcFileLen := 0;
                  aBytesRemaining := 0;
                  aBytesTransferred := 0;
                  aElapsedTicks := 0;
                  aBlockNum := 0;
                  aPathname[0] := #0;
                  aHandshakeAttempt := 0;

                  {Get a ymodem header block}
                  FillChar(yFileHeader^, SizeOf(yFileHeader^)+XmodemOverhead, 0);
                  x1KMode := False;
                  aCheckType := bcCrc16;
                  BlockSize := 128;
                  aBlockNum := 0;
                  xOverheadLen := 4;

                  {Testing shows a short delay is required here for Telix}
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, TelixDelay, True);
                  yYmodemState := ryDelay;
                end;

              ryDelay :
                if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Finished with Telix delay, send handshake}
                  xHandshake := xpGetHandshakeChar(P);
                  PutChar(xHandshake);
                  xEotCounter := 0;
                  xCanCounter := 0;

                  {Start waiting for handshake reply}
                  yYmodemState := ryWaitForHSReply;
                  Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                end;

              ryWaitForHSReply :
                if TriggerID = aDataTrigger then begin
                  {Got handshake reply, see if it's a block start}
                  yYmodemState := ryWaitForBlockStart;
                  if xGMode then
                    xMaxBlockErrors := 0;

                  {Force a fresh timer for each file}
                  aTimerStarted := False;
                end else if Integer(TriggerID) = aTimeoutTrigger then begin
                  {Timeout waiting for handshake reply, resend or fail}
                  Inc (aHandshakeAttempt);
                  if aHandshakeAttempt > aHandshakeRetry then begin
                    apProtocolError(P, ecTimeout);
                    yYmodemState := ryFinished
                  end else begin
                    if aBlockErrors > xMaxBlockErrors then
                      xHandshake := ChkReq;
                    Dispatcher.PutChar(xHandshake);
                    Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                  end;
                end;

              ryWaitForBlockStart :
                if TriggerID = aDataTrigger then begin
                  {Got data, see if it's a block start character}
                  if xpCheckForBlockStart(P, C) then begin
                    case xpProcessBlockStart(P, C) of
                      pbs128, pbs1024 :
                        begin
                          if not aTimerStarted then begin
                            aTimerStarted := True;
                            NewTimer(aTimer, 1);
                          end;
                          yYmodemState := ryCollectBlock;
                        end;
                      pbsCancel, pbsEOT :
                        yYmodemState := ryFinished;
                    end;
                  end;
                end else if Integer(TriggerID) = aTimeoutTrigger then
                  {Timeout out waiting for rest of block, quit or resend handshake}
                  if CheckErrors then
                    yYmodemState := ryFinished
                  else
                    yYmodemState := ryInitial;

              ryCollectBlock :
                if TriggerID = aDataTrigger then begin
                  {Collect new data into DataBlock}
                  if xpCollectBlock(P, yFileHeader^) then
                    yYmodemState := ryProcessBlock;
                end else if Integer(TriggerID) = aTimeoutTrigger then
                  {Timeout out collecting initial block, quit or resend handshake}
                  if CheckErrors then
                    yYmodemState := ryFinished
                  else
                    yYmodemState := ryInitial;

              ryProcessBlock :
                begin
                  {Go process data already in DataBlock}
                  xpReceiveBlock(P, yFileHeader^, BlockSize, xHandshake);
                  xpSendHandshakeChar(P, xHandshake);

                  {Extract file info if we got block ok}
                  if aProtocolError = ecOK then begin
                    {Finished if entire block is null}
                    Finished := True;
                    I := 3;
                    while (I < 120) and Finished do begin
                      if yFileHeader^[I] <> #0 then
                        Finished := False;
                      Inc(I);
                    end;

                    {If finished, send last ack and exit}
                    if Finished then begin
                      yYmodemState := ryFinished;
                      goto ExitPoint;
                    end;

                    {$IFDEF HugeStr}
                    SetLength(S, 1024);
                    {$ENDIF}

                    {Extract the file name from the header}
                    BlockPos := 3;
                    I := 0;
                    while (yFileHeader^[BlockPos] <> #0) and
                          (BlockPos < fsPathName+2) do begin
                      Inc(I);
                      S[I] := yFileHeader^[BlockPos];
                      if S[I] = '/' then
                        S[I] := '\';
                      Inc(BlockPos);
                    end;
                    SLen := I;

                    if aUpcaseFileNames then begin
                      {$IFDEF HugeStr}
                      SetLength(S, SLen);
                      AnsiUpperBuff(PAnsiChar(S), SLen);
                      {$ELSE}
                      AnsiUpperBuff(@S[1], SLen);
                      {$ENDIF}
                    end;
                    StrPCopy(aPathname, S);

                    if not FlagIsSet(aFlags, apHonorDirectory) then begin
                      Name := ExtractFileName(S);
                      StrPCopy(NameExt, Name);
                      AddBackSlashZ(aPathName, aDestDir);
                      StrLCat(aPathName, NameExt, SizeOf(aPathName));
                    end;

                    {Extract the file size}
                    I := 1;
                    Inc(BlockPos);
                    while (yFileHeader^[BlockPos] <> #0) and
                          (yFileHeader^[BlockPos] <> ' ') and
                          (I <= 255) do begin
                      S1[I] := yFileHeader^[BlockPos];
                      Inc(I);
                      Inc(BlockPos);
                    end;
                    Dec(I);
                    S1Len := I;

                    if S1Len = 0 then
                      aSrcFileLen := 0
                    else begin
                      Val(S1, aSrcFileLen, Code);
                      if Code <> 0 then
                        aSrcFileLen := 0;
                    end;
                    aBytesRemaining := aSrcFileLen;

                    {Extract the file date/time stamp}
                    I := 1;
                    Inc(BlockPos);
                    while (yFileHeader^[BlockPos] <> #0) and
                          (yFileHeader^[BlockPos] <> ' ') and
                          (I <= 255) do begin
                      S1[I] := yFileHeader^[BlockPos];
                      Inc(I);
                      Inc(BlockPos);
                    end;
                    Dec(I);
                    S1Len := I;
                    if S1Len = 0 then
                      yNewDT := 0
                    else begin
                      yNewDT := apOctalStr2Long(S1);
                      if yNewDT = 0 then begin
                        {Invalid char in date/time stamp, show the error and continue}
                        yNewDT := 0;
                        aProtocolStatus := psInvalidDate;
                        apShowStatus(P, 0);
                      end;
                    end;

                    {Manually reset status vars before getting file}
                    aBytesTransferred := 0;
                    aElapsedTicks := 0;

                    {Receive the file using CRC and 1K blocks}
                    x1KMode := True;
                    aCheckType := bcCrc16;
                    aBlockLen := 1024;
                    ySaveLen := aSrcFileLen;

                    {Go prep Xmodem}
                    yYmodemState := ryPrepXmodem;
                  end else
                    {Error getting name block...}
                    if xGMode then
                      {Can't recover when in GMode, go quit}
                      yYmodemState := ryFinished
                    else begin
                      {Nak already sent, go get block again}
                      yYmodemState := ryWaitForHSReply;
                      Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                    end;
                end;

              ryPrepXmodem :
                begin
                  xXmodemState := rxInitial;
                  aDataBlock := nil;
                  apResetStatus(P);
                  aProtocolStatus := psProtocolHandshake;
                  yYmodemState := ryReceiveXmodem;
                  ExitStateMachine := False;
                  aSrcFileLen := ySaveLen;
                end;

              ryReceiveXmodem :
                begin
                  ExitStateMachine := True;
                  XState := xpReceivePrim(apw_FromYmodem, TriggerID, lParam);

                  if XState = 1 then begin
                    if aProtocolError = ecOK then begin
                      {If this is a file, check for truncation and file date}
                      Assign(F, aPathname);
                      Reset(F, 1);
                      if IOResult = 0 then begin
                        {If a new file size was supplied, truncate to that length}
                        if ySaveLen <> 0 then begin

                          {Get the file size of the file (as received)}
                          CurSize := FileSize(F);

                          {If the requested file size is within one block, truncate the file}
                          if (CurSize - ySaveLen) < 1024 then begin
                            Seek(F, ySaveLen);
                            Truncate(F);
                            Res := IOResult;
                            if Res <> 0 then begin
                              apProtocolError(P, Res);
                              yYmodemState := ryFinished;
                              goto ExitPoint;
                            end;
                          end;
                        end;

                        {If a new date/time stamp was specified, update the file time}
                        if yNewDT <> 0 then begin
                          yNewDT := apYMTimeStampToPack(yNewDT);
                          FileSetDate(TFileRec(F).Handle, yNewDT);
                        end;
                      end;
                      Close(F);
                      if IOResult <> 0 then ;

                      {Go look for another file}
                      yYmodemState := ryInitial;
                      Dispatcher.SetTimerTrigger(aTimeoutTrigger, aHandshakeWait, True);
                      aForceStatus := True;
                    end else
                      yYmodemState := ryFinished;
                  end;
                end;

              ryFinished :
                begin
                  apShowLastStatus(P);
                  apSignalFinish(P);
                  yYmodemState := ryDone;
                end;
            end;

    ExitPoint:
            {Set function result}
            case yYmodemState of
              {Stay in state machine}
              ryInitial,
              ryOpenFile,
              ryProcessBlock,
              ryFinished,
              ryPrepXmodem        : Finished := False;

              {Leave only if no data waiting}
              ryWaitForBlockStart,
              ryCollectBlock      : begin
                                      Finished := not CharReady;
                                      TriggerID := aDataTrigger;
                                    end;

              {Stay or leave as previously specified}
              ryReceiveXmodem     : Finished := ExitStateMachine;

              {Leave state machine}
              ryDone,
              ryDelay,
              ryWaitForHSReply    : Finished := True;
              else                  Finished := True;

            end;
            except                                                     {!!.01}
              on EAccessViolation do begin                             {!!.01}
                Finished := True;                                      {!!.01}
                aProtocolError := ecAbortNoCarrier;                    {!!.01}
                apSignalFinish(P);                                     {!!.01}
              end;                                                     {!!.01}
            end;                                                       {!!.01}
          until Finished;
      end;
      {$IFDEF Win32}                                               {!!.01}
      LeaveCriticalSection(P^.aProtSection);                       {!!.01}
      {$ENDIF}                                                     {!!.01}
    end;
  end;

end.
