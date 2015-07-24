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
{*                    AWFAX.PAS 4.06                     *}
{*********************************************************}
{* Low-level fax support                                 *}
{*********************************************************}

{
  Contains the fax state machine, access methods for the fax
  records, etc.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$A+,F+,I-,R-,S-,V-,X+,T-}
{$J+}

{.$DEFINE DebugFax}

unit AwFax;
  {-Class 1, class 2 and class 2.0 fax send/receive objects}

interface

uses
  Windows,
  Graphics,
  Messages,
  SysUtils,
  Classes,
  OoMisc,
  AwUser,
  AwFaxCvt,
  AwAbsFax;

{$IFDEF DebugFax}
var
  debug : text;
{$ENDIF}

const
  MaxModIndex = 6;
  PhysicalTopMargin : Word = 8; {Physical top margin in raster lines}

  {Default values for fax transmit yielding}
  DefMaxSendCnt   = 50;         {Max blocks/lines per call}
  DefBufferMin    = 1000;       {Minimum buffer quantity before yield}

  awfDefFaxDialTimeout  = 1092;    {Default ticks for dial timeout}
  awfDefCmdTimeout      = 182;     {Default ticks for command timeout (10 secs)}
  awfDefTransTimeout    = 1092;    {Default ticks to wait for flow control release}
  aDataTrigger          = 0;

type
  PFaxDataBuffer = ^TFaxDataBuffer;
  TFaxDataBuffer = array[0..$FFF0] of Byte;

  {Class 2/2.0 command/response strings}
  TClass2Str = String[13];

  {Modem response string}
  TModemResponse = String[128];

  {Class 1/2 abstract data}
  PC12AbsData = ^TC12AbsData;
  TC12AbsData = record
    cForceStatus  : Boolean;            {True to force special status}
    cMorePages    : Boolean;            {True if more fax pages to receive}
    cSessionRes   : Boolean;            {Remote/session resolution}
    cSessionWid   : Boolean;            {Remote/session high width}
    cSessionECM   : Boolean;            {Remote/session ECM}
    cCanDoHighRes : Boolean;            {True if capable of high res}
    cCanDoHighWid : Boolean;            {True if capable of high width}
    cLastFrame    : Boolean;            {True if last Class 1 frame}
    cToneDial     : Boolean;            {True to use tone dialing}
    cLastPageOk   : Boolean;            {True if last page received OK}
    cUseLengthWord: Boolean;            {True if file has length words}
    cCoverIsAPF   : Boolean;            {True if cover page is apf file}
    cInitSent     : Boolean;            {True if modem/def init sent once}
    cSlowBaud     : Boolean;            {True if using slow baud rate}
    cGotCFR       : Boolean;            {True if got CFR after training}
    cBlindDial    : Boolean;            {True to use X3 instead of X4}
    cDetectBusy   : Boolean;            {True to use X2 instead of X4}
    cCheckChar    : AnsiChar;               {ECM character}
    cResC         : AnsiChar;               {Resolution character}
    cResCPrev     : AnsiChar;               {Previous resolution}          
    cFaxAndData   : AnsiChar;               {'0' = fax, '1' = fax and data}
    cSessionScan  : Byte;               {Remote/session scantime}
    cReceivedFrame: Byte;               {last received HDLC frame type}
    cCRLFIndex    : Byte;               {Index for CRLF checking}
    cETXIndex     : Byte;               {Index for DLE/ETX checking}
    cReplyWait    : Word;               {Ticks to wait for a modem reply}
    cTransWait    : Word;               {Ticks to wait for outbuf space}
    cMaxFaxBPS    : Word;               {Max fax BPS for this modem}
    cBPSIndex     : Word;               {Last Class 1BPS index}
    cMinBytes     : Word;               {Minimum raster line length}
    cHangupCode   : Word;               {Last FHNG code}
    cCurrOfs      : Word;               {curr offset in DataBuffer}
    cBadData      : Word;               {Bad bytes during train}
    cRetry        : Word;               {General retry counter}
    cBytesRead    : Integer;            {Bytes to be transmitted}
    cDialWait     : Integer;            {ticks timeout for dialing}
    cAnswerOnRing : Integer;            {ring on which to answer phone}
    cRingCounter  : Integer;            {count of rings seen}
    cSessionBPS   : Integer;            {Remote/session BPS}
    cNormalBaud   : Integer;            {Normal baud rate}
    cInitBaud     : Integer;            {Initialization baud rate}
    cDataBuffer   : PFaxDataBuffer;     {buffer for received data}
    cInFile       : File;               {received data file}
    cFaxHeader    : TFaxHeaderRec;      {fax file header block}
    cPageHeader   : TPageHeaderRec;     {fax file page header block}
    cClassCmd     : TClass2Str;         {class 2/2.0 +FCLASS command}
    cModelCmd     : TClass2Str;         {class 2/2.0 model command}
    cMfrCmd       : TClass2Str;         {class 2/2.0 manufacturer command}
    cRevCmd       : TClass2Str;         {class 2/2.0 revision command}
    cDISCmd       : TClass2Str;         {class 2/2.0 DIS }
    cStationCmd   : TClass2Str;         {class 2/2.0 Station ID command}
    cDCCCmd       : TClass2Str;         {class 2/2.0 DCC command}
    cFaxResp      : TClass2Str;         {class 2/2.0 Fax call response}
    cDISResp      : TClass2Str;         {class 2/2.0 DIS response}
    cDCSResp      : TClass2Str;         {class 2/2.0 DCS response}
    cTSIResp      : TClass2Str;         {class 2/2.0 TSI response}
    cCSIResp      : TClass2Str;         {class 2/2.0 CSI response}
    cPageResp     : TClass2Str;         {class 2/2.0 page-end response}
    cHangResp     : TClass2Str;         {class 2/2.0 hangup response}
    cModCode      : String[3];          {modulation code}
    cForcedInit   : String[40];         {forced init string}          
    cModemInit    : String[40];         {optional modem init string}
    cDialPrefix   : String[40];         {dialing prefix}
    cDialTonePulse: AnsiChar;               {tone/pulse modifier}
    cResponse     : TModemResponse;     {Current modem response}
    cInFileName   : ShortString;        {name of current file}
    cReplyTimer   : EventTimer;         {Timer for all replies}
    cLocalMods    : array[1..MaxModIndex] of Boolean; {Local Class 1 mods}
    cRmtMods      : array[1..MaxModIndex] of Boolean; {Remote Class 1 mods}
    cBufferBlock  : array[0..8191] of byte; {Buffer for PutBlocks}
    cEnhTextEnabled : Boolean;          {True to use Enhanced mode}
    cEnhSmallFont   : TFont;            {Font used for header}
    cEnhStandardFont: TFont;            {Font used for other text}    
  end;

  PC12FaxData = ^TC12FaxData;
  TC12FaxData = record
    fPData        : PFaxData;
    fCData        : PC12AbsData;
  end;

type
  PC12SendFax = ^TC12SendFax;
  TC12SendFax = record
    fPData        : PFaxData;
    fCData        : PC12AbsData;        {Pointer to C12 abstract data}
    fSafeMode     : Boolean;            {True to not yield when critical}
    fMaxSendCount : Word;               {Max iterations before yield}
    fBufferMinimum: Word;               {Min outbuff value before yield}
    fMCFConnect   : Boolean;            {True if CONNECT waiting for MCF}
    fRetries      : Integer;            {Count of retries on failed page send}
    fMaxRetries   : Integer;            {Max times to retry failed send}
    fConverter    : PAbsFaxCvt;         {fax converter for header lines}
    fState        : SendStates;         {Current state of machine}
    fHeaderLine   : ShortString;        {Header line for each page}
    fCvrF         : TLineReader;        {File for cover page}        
    fCvrOpen      : Boolean;            {True if cover opened}
    fRetryPage    : Boolean;            {True to retry page}
    fRetryMax     : Word;               {Number of times to retry a page}
    fFastPage     : Boolean;            {True for old class 1 xmit neg.}
  end;

type
  PC12ReceiveFax = ^TC12ReceiveFax;
  TC12ReceiveFax = record
    fPData        : PFaxData;
    fCData        : PC12AbsData;        {Pointer to C12 abstract data}
    fSafeMode     : Boolean;            {True to not yield when critical}
    fOneFax       : Boolean;            {True if only receiving one fax}
    fConstantStatus : Boolean;          {True to display constant status}
    fShowStatus   : Boolean;            {True if status window opened}
    fLast         : AnsiChar;               {Last received data char}
    fPageStatus   : ReceivePageStatus;  {Status of most-recent page}
    fState        : ReceiveStates;      {Current state of StateMachine}
    fFirstState   : ReceiveStates;      {State in 1st call to FaxReceivePart}
    fRenegotiate  : Boolean;            {True if we get an EOM frame} 
  end;

{C12AbsData}
function cInitC12AbsData(var DP : PC12AbsData) : Integer;
  {-Allocate and initialize a C12AbsData record}

function cDoneC12AbsData(var DP : PC12AbsData) : Integer;
{-Dispose of a C12AbsData record}

{User Control}
procedure fSetFaxPort(FP : PFaxRec; ComPort : TApdBaseDispatcher);
  {-Select the commport to use}

procedure fSetModemInit(FP : PFaxRec; MIS : ShortString);
  {-Define the modem init string}

function fSetClassType(FP : PFaxRec; CT : ClassType) : ClassType;
  {-Set type of modem, return detected or set type}

procedure fSetInitBaudRate(FP : PFaxRec;
                           InitRate, NormalRate : Integer;
                           DoIt : Boolean);
  {-Set baud rate to use when initializing modem}

function fGetModemInfo(FP : PFaxRec; var FaxClass : AnsiChar;
                       var Model, Chip, Rev : TPassString;
                       Reset : Boolean) : Boolean;
  {-Get specific data from modem}

function fGetModemFeatures(FP : PFaxRec; var BPS : Integer;
                           var Correction : AnsiChar) : Integer;
  {-Return highest possible codes}

procedure fSetModemFeatures(FP : PFaxRec; BPS : Integer;
                            Correction : AnsiChar);
  {-Set modem features for this session}

function fGetLastPageStatus(FP : PFaxRec) : Boolean;
  {-Return True if last page received OK, false otherwise}

function fGetRemoteID(FP : PFaxRec) : ShortString;
  {-Return remote station ID}

procedure fGetSessionParams(FP : PFaxRec;
                            var BPS : Integer;
                            var Resolution : Boolean;
                            var Correction : Boolean);
  {-Return remote/session parameters}

function fGetHangupResult(FP : PFaxRec) : Word;
  {-Return last hangup result, class 2 only}

procedure fGetPageInfoC12(FP : PFaxRec;
                          var Pages : Word;
                          var Page : Word;
                          var BytesTransferred : Integer;
                          var PageLength : Integer);


{C12Send init/destroy routines}
function fInitC12SendFax(var FP : PFaxRec; ID : Str20;
                         ComPort : TApdBaseDispatcher; Window : TApdHwnd) : Integer;
  {-Allocate and initialize a send fax record}

{function fDoneC12SendFax(var FP : PFaxRec) : Integer;}
procedure fDoneC12SendFax(var FP : PFaxRec);
  {-Dispose of a send fax record}


{User control}
procedure fSetEnhTextEnabled(FP : PFaxRec; Enabled : Boolean);
  {-Select normal or "enhanced" text}

procedure fSetEnhSmallFont(FP : PFaxRec; SmFont : TFont);
  {-Select font for header text}

procedure fSetEnhStandardFont(FP : PFaxRec; StFont : TFont);
  {-Select font for normal text}

procedure fSetBlindDial(FP : PFaxRec; Blind : Boolean);
  {-Select normal or "blind" dialing}

procedure fSetDetectBusy(FP : PFaxRec; DetectBusySignal : Boolean);
  {-Select busy signal detection}

procedure fSetToneDial(FP : PFaxRec; Tone : Boolean);
  {-Select tone or pulse dial (send only)}

procedure fSetDialPrefix(FP : PFaxRec; P : ShortString);
  {-Set the dial prefix string}

procedure fSetDialTime(FP : PFaxRec; DT : Integer);
  {-Set the dialing timeout}

procedure fSetHeaderText(FP : PFaxRec; S : ShortString);
  {-Set HeaderLine to S}

procedure fSetMaxRetries(FP : PFaxRec; MR : Integer);
  {-Set MaxRetries to MR}

procedure fSetYielding(FP : PFaxRec; MaxLines, FreeBuffer : Word);
  {-Set the max lines sent per call and the minimum free outbuffer space}

procedure fSetSafeMode(FP : PFaxRec; SafeMode : Boolean);
  {-Enable/disable safe mode}


procedure fFaxTransmit(Msg, wParam : Cardinal;
                      lParam : Integer);
  {-Perform one increment of a fax transmit session}


function fPrepareFaxTransmit(FP : PFaxRec) : Integer;
  {-Start a background fax transmit}


{C12Receive init/destroy routines}
function fInitC12ReceiveFax(var FP : PFaxRec; ID : Str20;
                            ComPort : TApdBaseDispatcher; Window : TApdHwnd) : Integer;
  {-Allocate and initialize a receive fax record}

function fDoneC12ReceiveFax(var FP : PFaxRec) : Integer;
  {-Dispose of a receive fax record}


{User control}
function fInitModemForFaxReceive(FP : PFaxRec) : Boolean;
  {-Send nessessary commands to initialize modem for fax receive}

procedure fSetAnswerOnRing(FP : PFaxRec; AOR : Integer);
  {-set to answer call on AOR'th ring}

procedure fSetFaxAndData(FP : PFaxRec; OnOff : Boolean);
  {-True for fax to answer either fax or data, False for fax only}

procedure fSetConnectState(FP : PFaxRec);
  {-Force the receiver to pick up a connection in progress}

procedure fSetOneFax(FP : PFaxRec; OnOff : Boolean);
  {-Set "one fax" receive behavior on/off}



procedure fFaxReceive(Msg, wParam : Cardinal;
                     lParam : Integer);
  {-Perform one increment of a fax transmit session}


function fPrepareFaxReceive(FP : PFaxRec) : Integer;
  {-Prepare for first call to fFaxReceive}


function fGetModemClassSupport(FP : PFaxRec;
                                 var Class1, Class2, Class2_0 : Boolean;
                                 Reset : Boolean) : Boolean;
  {-Get class support, including 2.0}

const
  {Undocumented constants}
  AbortDelay : Word            = 1000;    {Msec wait for +++}
  PreCommandDelay : Word       = 100;     {MSec before general modem cmds}
  PreFaxDelay : Word           = 40;      {MSec before inprog fax modem cmds}
  ExtraCommandDelay : Word     = 200;     {MSec extra delay before some cmds}
  PreEOPDelay : Word           = 500;     {MSec delay before sending EOP}
  InterCharDelay : Word        = 0;       {MSec between modem chars}
  OkDelay : Word               = 18;      {Tick wait for optional OK}
  BaudChangeDelay : Word       = 9;       {Tick delay before changing baud}
  Class1Wait : Word            = 54;      {Tick till frame carrier}
  MaxClass1Retry : Word        = 3;       {Max class 1 frame retries}

implementation

uses
  AnsiStrings;

const
  {For calculating minimum bytes per line}
  ScanTimes : array[0..7, Boolean] of Byte = (
    (0,0),    {0}
    (5,5),    {1}
    (10,5),   {2}
    (10,10),  {3}
    (20,10),  {4}
    (20,20),  {5}
    (40,20),  {6}
    (40,40)); {7}

  {For calculating scan time response in DCS frame}
  ScanTimeResponse : array[0..7, Boolean] of Byte = (
    ($70, $70),
    ($10, $10),
    ($20, $10),
    ($20, $20),
    ($00, $20),
    ($00, $00),
    ($40, $00),
    ($40, $40));
  ZeroScanTime = $70;

  {For managing Class 1 modulations}
  ModArray : array[1..MaxModIndex] of String[3] = (
    '24', '48', '72', '96', '121', '145');

  {Short Train Modulations when we use V.17 -- need to eval this further}
  STModArray : array[1..MaxModIndex] of String[3] = (
    '24', '48', '72', '96', '122', '146');

  {For getting MaxFaxBPS from modulation index}
  Class1BPSArray : array[1..MaxModIndex] of Word = (
    2400, 4800, 7200, 9600, 12000, 14400);

  LogSendFaxState : array[SendStates] of TDispatchSubType = (
     dsttfNone, dsttfGetEntry, dsttfInit, dsttf1Init1, dsttf2Init1,
     dsttf2Init1A, dsttf2Init1B, dsttf2Init2, dsttf2Init3, dsttfDial,
     dsttfRetryWait, dsttf1Connect, dsttf1SendTSI, dsttf1TSIResponse,
     dsttf1DCSResponse, dsttf1TrainStart, dsttf1TrainFinish,
     dsttf1WaitCFR, dsttf1WaitPageConnect, dsttf2Connect,
     dsttf2GetParams, dsttfWaitXon, dsttfWaitFreeHeader,
     dsttfSendPageHeader, dsttfOpenCover, dsttfSendCover,
     dsttfPrepPage,  dsttfSendPage, dsttfDrainPage, dsttf1PageEnd,
     dsttf1PrepareEOP, dsttf1SendEOP, dsttf1WaitMPS, dsttf1WaitEOP,
     dsttf1WaitMCF, dsttf1SendDCN, dsttf1Hangup, dsttf1WaitHangup,
     dsttf2SendEOP, dsttf2WaitFPTS, dsttf2WaitFET, dsttf2WaitPageOK,
     dsttf2SendNewParams, dsttf2NextPage, dsttf20CheckPage,
     dsttfClose, dsttfCompleteOK, dsttfAbort, dsttfDone  );
   LogReceiveFaxState : array[ReceiveStates] of TDispatchSubType = (
     dstrfNone,
     dstrfInit, dstrf1Init1, dstrf2Init1, dstrf2Init1A, dstrf2Init1B,
     dstrf2Init2, dstrf2Init3, dstrfWaiting, dstrfAnswer,
     dstrf1SendCSI, dstrf1SendDIS, dstrf1CollectFrames,
     dstrf1CollectRetry1, dstrf1CollectRetry2, dstrf1StartTrain,
     dstrf1CollectTrain, dstrf1Timeout, dstrf1Retrain,
     dstrf1FinishTrain, dstrf1SendCFR, dstrf1WaitPageConnect,
     dstrf2ValidConnect, dstrf2GetSenderID, dstrf2GetConnect,
     dstrfStartPage, dstrfGetPageData, dstrf1FinishPage,
     dstrf1WaitEOP, dstrf1WritePage, dstrf1SendMCF, dstrf1WaitDCN,
     dstrf1WaitHangup, dstrf2GetPageResult, dstrf2GetFHNG,
     dstrfComplete, dstrfAbort, dstrfDone);

{General purpose}

function Pos(const Substr: string; const S: TModemResponse): Integer; overload;
begin
  Result := System.Pos(SubStr, string(S));
end;

  function TrimStationID(S : ShortString) : ShortString;
  begin
    S := Trim(S);
    if S[1] = '"' then
      S[1] := ' ';
    while (Length(S) > 0) and
          (not(Upcase(S[Length(S)]) in ['0'..'9','A'..'Z'])) do
      Dec(S[0]);
    TrimStationID := Trim(S);
  end;

  function PadCh(S : ShortString; Ch : AnsiChar; Len : Byte) : ShortString;
    {-Return a string right-padded to length len with ch}
  var
    o : ShortString;
    SLen : Byte absolute S;
  begin
    if Length(S) >= Len then
      PadCh := S
    else begin
      o[0] := AnsiChar(Len);
      Move(S[1], o[1], SLen);
      if SLen < 255 then
        FillChar(o[Succ(SLen)], Len-SLen, Ch);
      PadCh := o;
    end;
  end;

  function GetPackedDateTime : Integer;
    {-Return today's date/time in file packed date format}
  begin
    Result := DateTimeToFileDate(Now);
  end;

  function RotateByte(Code : AnsiChar) : Byte; assembler; register;
    {-Flip code MSB for LSB}

  {$ifndef CPUX64}
  asm
    //code = al
    mov dl,al
    xor eax,eax
    mov ecx,8
@1: shr dl,1
    rcl al,1
    loop @1
  end;
  {$else}
  asm
    //code = cl
    mov dl,cl
    xor eax,eax
    mov ecx,8
@1: shr dl,1
    rcl al,1
    loop @1
  end;
  {$endif}

  procedure Merge(var S : TModemResponse; C : AnsiChar);
    {-appends C to S, shifting S if it gets too long}
  var
    B : Byte absolute S;
  begin
    if B > SizeOf(TModemResponse)-1 then
      Move(S[2], S[1], B-1)
    else
      Inc(B);
    S[B] := C;
  end;

  procedure StripPrefix(var S : TModemResponse);
    {-removes prefix from faxmodem response string}
  var
    SepPos : Integer;
  begin
    S := Trim(S);
    SepPos := Pos(':', S);
    if SepPos = 0 then
      SepPos := Pos('=', S);
   if SepPos > 0 then
      Delete(S, 1, SepPos);
    S := Trim(S);
  end;

  function HasExtensionS(const Name : ShortString;
                         var DotPos : Word) : Boolean;
    {-Return whether and position of extension separator dot in a pathname}
  var
    I : Word;
  begin
    DotPos := 0;
    for I := Length(Name) downto 1 do
      if (Name[I] = '.') and (DotPos = 0) then
        DotPos := I;
    HasExtensionS :=
      (DotPos > 0) and (System.Pos('\', Copy(string(Name), Succ(DotPos), 64)) = 0);
  end;

  function DefaultExtensionS(Name, Ext : ShortString) : ShortString;
    {-Return a pathname with the specified extension attached}
  var
    DotPos : Word;
  begin
    if HasExtensionS(Name, DotPos) then
      DefaultExtensionS := Name
    else if Name = '' then
      DefaultExtensionS := ''
    else
      DefaultExtensionS := Name+'.'+Ext;
  end;

  function CheckForString(var Index : Byte; C : AnsiChar; S : ShortString) : Boolean;
    {-Checks for string S on consecutive calls, returns True when found}
  begin
    CheckForString := False;
    Inc(Index);

    {Compare...}
    if C = S[Index] then
      {Got match, was it complete?}
      if Index = Length(S) then begin
        Index := 0;
        CheckForString := True;
      end else
    else
      {No match, reset Index}
      if C = Upcase(S[1]) then
        Index := 1
      else
        Index := 0;
  end;

  procedure FlushInQueue(FP : PFaxRec);
    {-Read (flush) trailing data from last incoming block}
  var
    C : AnsiChar;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do
      while aPort.CharReady do
        aPort.GetChar(C);
  end;

{C12AbsData}

  procedure caFreeC12EnhFonts(var DP : PC12AbsData);
  begin
    with DP^ do begin
      cEnhSmallFont.Free;
      cEnhSmallFont := nil;
      cEnhStandardFont.Free;
      cEnhStandardFont := nil;
    end;
  end;

  procedure caInitC12EnhFonts(var DP : PC12AbsData);
  begin
    with DP^ do begin
      if Assigned(cEnhSmallFont) or Assigned(cEnhStandardFont) then
        caFreeC12EnhFonts(DP);
      cEnhSmallFont := TFont.Create;
      cEnhStandardFont := TFont.Create;
    end;
  end;

  function cInitC12AbsData(var DP : PC12AbsData) : Integer;
    {-Allocate and initialize a C12AbsData record}
  begin
    DP := AllocMem(SizeOf(TC12AbsData));

    with DP^ do begin
      cDataBuffer := AllocMem(DataBufferSize);

      cEnhTextEnabled := False;
      cBlindDial      := False;
      cDetectBusy     := True;
      cToneDial       := True;
      cDialWait       := awfDefFaxDialTimeout;
      cMaxFaxBPS      := 9600;
      cCheckChar      := '0';
      cAnswerOnRing   := 1;
      cReplyWait      := awfDefCmdTimeout;
      cTransWait      := awfDefTransTimeout;
      cFaxAndData     := '0';
      cForcedInit     := ShortString(DefNormalInit);                                  {!!.04}
    end;
    caInitC12EnhFonts(DP);                                          
    cInitC12AbsData   := ecOK;
  end;

  function cDoneC12AbsData(var DP : PC12AbsData) : Integer;
  begin
    cDoneC12AbsData := ecOK;
    if not Assigned(DP) then
      Exit;

    with DP^ do begin
      caFreeC12EnhFonts(DP);
      if cDataBuffer <> nil then                                   
        FreeMem(cDataBuffer, DataBufferSize);
      FreeMem(DP, SizeOf(TC12AbsData));
    end;
  end;

  procedure fSetFaxPort(FP : PFaxRec; ComPort : TApdBaseDispatcher);
    {-Set a new comport handle}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do
      aPort := ComPort;
  end;

  procedure fSetModemInit(FP : PFaxRec; MIS : ShortString);
    {-set modem init string}
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      if Length(MIS) > 0 then begin
        cModemInit := MIS;
        AnsiUpperBuff(@cModemInit[1], Length(MIS));
        if Pos('AT', cModemInit) <> 1 then                          
          cModemInit := 'AT'+cModemInit;
      end else cModemInit := '';                                    
    end;
  end;

  function fSetClassType(FP : PFaxRec; CT : ClassType) : ClassType;
    {-Set type of modem, return detected or set type}
  var
    Class1 : Boolean;
    Class2 : Boolean;
    Class2_0 : Boolean;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      if CT = ctDetect then begin
        if fGetModemClassSupport(FP, Class1, Class2, Class2_0, True) then begin
          if Class2_0 then
            aClassInUse := ctClass2_0
          else if Class2 then
            aClassInUse := ctClass2
          else if Class1 then
            aClassInUse := ctClass1
          else
            aClassInUse := ctUnknown;
        end else
          aClassInUse := ctUnknown;
      end else
        aClassInUse := CT;

      fSetClassType := aClassInUse;
    end;
  end;

  procedure caSwitchBaud(FP : PFaxRec; High : Boolean);
    {-Switch baud rates}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {first force baud to max of 19.2 for faxing}
      aPort.ChangeBaud(19200);                                      
      if High then begin
        {Switch to the high normal baud rate}
        if (cInitBaud <> 0) and cSlowBaud then begin
          DelayTicks(BaudChangeDelay, False);
          aPort.ChangeBaud(cNormalBaud);
          cSlowBaud := False;
        end;
      end else begin
        {Switch to low initialization baud rate}
        if (cInitBaud <> 0) and not cSlowBaud then begin
          DelayTicks(BaudChangeDelay, False);
          aPort.ChangeBaud(cInitBaud);
          cSlowBaud := True;
        end;
      end;
    end;
  end;

  procedure fSetInitBaudRate(FP : PFaxRec;
                             InitRate, NormalRate : Integer;
                             DoIt : Boolean);
    {-Set baud rate to use when initializing modem}
  var
    Parity   : Word;
    DataBits : TDataBits;
    StopBits : TStopBits;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      cInitBaud := InitRate;
      if (NormalRate = 0) and (aPort <> nil) then
        aPort.GetLine(cNormalBaud, Parity, DataBits, StopBits)
      else
        cNormalBaud := NormalRate;

      {Start in low baud}
      if DoIt and (aPort <> nil) then
        caSwitchBaud(FP, False);
    end;
  end;

  function caLocatePage(FP : PFaxRec; PgNo : Word) : Integer;
  var
    W : Word;
    L : Integer;
    P : TPageHeaderRec;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      caLocatePage := ecDiskRead;

      {validate number}
      if (PgNo = 0) or (PgNo > cFaxHeader.PageCount) then
        Exit;

      {start at head of file and walk the list of pages}
      Seek(cInFile, cFaxHeader.PageOfs);
      Result := -IOResult;
      if Result <> 0 then                                             
        Exit;

      if PgNo > 1 then begin
        for W := 1 to (PgNo-1) do begin
          BlockRead(cInFile, P, SizeOf(P));
          Result := -IOResult;
          if Result <> 0 then                                         
            Exit;
          L := FilePos(cInFile);
          Inc(L, P.ImgLength);

          Seek(cInFile, L);
          Result := -IoResult;
          if Result <> ecOk then
            Exit;
        end;
      end;

    end;
  end;

  function caOkResponse(FP : PFaxRec) : Boolean;
    {-Return True if Response contains OK}
  begin
    with PC12FaxData(FP)^, fCData^ do
      caOkResponse := Pos('OK', cResponse) > 0;
  end;

  function caRingResponse(FP : PFaxRec) : Boolean;                       {!!.04}
    {-Return True if Response contains RING}
  begin
    with PC12FaxData(FP)^, fCData^ do
      caRingResponse := Pos('RING', cResponse) > 0;
  end;

  function caStripRing(FP : PFaxRec) : Boolean;                          {!!.04}
    {-Remove RING response from cResponse, returns True if cResponse<>''}
  begin
    { occasionally, the RING response is received while we're initializing, }
    { this method removes the RING response so we can init successfully     }
    with PC12FaxData(FP)^, fCData^ do begin
      if caRingResponse(FP) then begin
        Delete(cResponse, Pos('RING', cResponse), 4);
        { increment the ring counter since we've seen a RING }
        Inc(cRingCounter);
      end;
      Result := cResponse <> '';
    end;
  end;

  function caConnectResponse(FP : PFaxRec) : Boolean;
    {-Return True if Response contains CONNECT}
  begin
    with PC12FaxData(FP)^, fCData^ do
      caConnectResponse := Pos('CONNECT', cResponse) > 0;
  end;

  function caNoCarrierResponse(FP : PFaxRec) : Boolean;
    {-Return True if Response contains NO CARRIER}
  begin
    with PC12FaxData(FP)^, fCData^ do
      caNoCarrierResponse := Pos({CA}'RRIER', cResponse) > 0;
  end;

  function caErrorResponse(FP : PFaxRec) : Boolean;
    {-Return True if Response contains ERROR}
  begin
    with PC12FaxData(FP)^, fCData^ do
      caErrorResponse := Pos('ERROR', cResponse) > 0;
  end;

  function caFHNGResponse(FP : PFaxRec) : Boolean;
    {-Return True if Response contains FHNG}
  begin
    with PC12FaxData(FP)^, fCData^ do
      caFHNGResponse := Pos(cHangResp, cResponse) > 0;
  end;

  function caExtractFHNGCode(FP : PFaxRec) : Word;
    {-Return numeric FHNG response}
  var
    {W    : Word;}                                                       {!!.04}
    {Code : Integer;}                                                    {!!.04}
    I    : Byte;
    S    : String[20];
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      I := Pos(':', cResponse);
      if I <> 0 then begin
        S := Copy(cResponse, I+1, 3);
        S := Trim(S);
        { class 2 returns the hangup code as decimal, 2.0 returns it as hex  }
        { fortunately, they use the same digits (eg, both will return '71'   }
        { for "RSPREC error").  We need to convert the Receive Phase D codes }
        { since they could be returned as '100' (Class2) or 'A0' (Class2.0). }
        if (Length(S) > 0) then                                          {!!.04}
          if (S[1] in ['A'..'F']) then                                   {!!.04}
            { it's a hex code, convert to the doc'd format }             {!!.04}
            Result := StrToIntDef(string(S[2]), 0) + 100                         {!!.04}
          else                                                           {!!.04}
            Result := StrToIntDef(string(S), -0)                                 {!!.04}
        else                                                             {!!.04}
          Result := 0;                                                   {!!.04}
        {Val(S, W, Code);}                                               {!!.04}
        {caExtractFHNGCode := W;}                                        {!!.04}
      end else
        caExtractFHNGCode := 0;
    end;
  end;

  function caAddReceivedCmd(FP : PFaxRec; var S : TModemResponse) : Boolean;
    {-if char(s) pending, add to command string; return True if complete
      response has been assembled}
  var
    C : AnsiChar;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      caAddReceivedCmd := False;
      while aPort.CharReady do begin
        aPort.GetChar(C);
        if C = #13 then begin
          if S <> '' then begin
            caAddReceivedCmd := True;
            Exit;
          end;
        end else if C >= #32 then
          Merge(S, C);
      end;
    end;
  end;

  procedure caPrepResponse(FP : PFaxRec);
    {-Prepare to receive/parse a new modem response}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      cResponse := '';
      cCRLFIndex := 0;
      cETXIndex := 0;
      aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
      NewTimer(cReplyTimer, cReplyWait);
    end;
  end;

  function caPutModemSlow(FP : PFaxRec; S : ShortString) : Integer;
    {-Send a modem command and prepare to wait for a response}
  var
    I : Word;
  begin
    Result := ecOK;
    with PC12FaxData(FP)^, fCData^, fPData^ do
      for I := 1 to Length(S) do begin
        DelayMS(InterCharDelay);
        Result := aPort.PutChar(S[I]);
        if Result <> ecOK then
          Exit;
      end;
  end;

  function caPutModem(FP : PFaxRec; S : ShortString) : Integer;
    {-Send a modem command and prepare to wait for a response}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      DelayMS(PreCommandDelay);
      Result := caPutModemSlow(FP, S+^M);
      if Result <> ecOK then
        Exit;
      caPrepResponse(FP);
    end;
  end;

  function caPutFaxCommand(FP : PFaxRec; S : ShortString) : Integer;
    {-Send FTM/FRM modem command}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      DelayMS(PreFaxDelay);
      Result := caPutModemSlow(FP, S+^M);
      if Result <> ecOK then
        Exit;
      caPrepResponse(FP);
    end;
  end;

  function caPutFrameR(FP : PFaxRec) : Integer;
    {-Send FRH=3 modem command}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      DelayMS(PreFaxDelay);
      Result := caPutModemSlow(FP, 'AT+FRH=3'^M);
      if Result <> ecOK then
        Exit;
      caPrepResponse(FP);
    end;
  end;

  function caPutFrameT(FP : PFaxRec) : Integer;
    {-Send FTH=3 modem command}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      DelayMS(PreFaxDelay);
      Result := caPutModemSlow(FP, 'AT+FTH=3'^M);
      if Result <> ecOK then
        Exit;
      caPrepResponse(FP);
    end;
  end;

  function caProcessModemCmd(FP : PFaxRec; S : ShortString) : Boolean;
  var
    Finished : Boolean;
    OkString : TModemResponse;
    WasBusy  : Boolean;
    Dummy    : Boolean;

  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {Send the command}
      caProcessModemCmd := False;
      if caPutModem(FP, S) <> ecOK then
        Exit;

      {Prepare to collect the response}
      caPrepResponse(FP);

      {Prepare to wait for responses}
      aPort.SetEventBusy(WasBusy, True);

      {Wait and collect...}
      repeat
        {Collect the response}
        cResponse := '';
        repeat
          Finished := caAddReceivedCmd(FP, cResponse);
          SafeYield;
          aPort.ProcessCommunications;
        until Finished or TimerExpired(cReplyTimer);

        {If timer expires just exit}
        if TimerExpired(cReplyTimer) then begin
          FlushInQueue(FP);
          aPort.SetEventBusy(Dummy, WasBusy);
          Exit;
        end;

        {Check for more data}
        SafeYield;
        aPort.ProcessCommunications;
        {if echo is on, we'll get our own command back. Eat it.}
        if cResponse = S then
          cResponse := '';
      until (cResponse <> '');

      {Check for errors}
      if not caErrorResponse(FP) then begin
        {Collect and discard the OK if above response was data}
        if Pos('OK', cResponse) = 0 then begin
          OkString := '';
          repeat
            Finished := caAddReceivedCmd(FP, OkString);
            SafeYield;
            aPort.ProcessCommunications;
          until Finished or TimerExpired(cReplyTimer);

          if TimerExpired(cReplyTimer) then begin
            FlushInQueue(FP);
            aPort.SetEventBusy(Dummy, WasBusy);
            Exit;
          end;
        end;
        caProcessModemCmd := True
      end else
        caProcessModemCmd := False;

      {Need to make sure all incoming data was processed}
      FlushInQueue(FP);

      {Restore the busy flag}
      aPort.SetEventBusy(Dummy, WasBusy);
    end;
  end;

  procedure caFlushModem(FP : PFaxRec);
    {-"Flush" modem for init}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {"reset" modem}
      aPort.FlushInBuffer;
      aPort.FlushOutBuffer;
      aPort.SetModem(False, False);
      DelayMS(FlushWait);
      aPort.SetModem(True, True);
      DelayMS(FlushWait);
    end;
  end;

  procedure fPrepCommands(FP : PFaxRec; Class2_0 : Boolean);
    {-Prepare for either class 2 or class 2.0 commands and responses}

    function MakeCmd(const S : TClass2Str) : TClass2Str;
      {-Prefix S with 'AT+F'}
    begin
      MakeCmd := 'AT+F' + S;
    end;

    function MakeResp(const S : TClass2Str) : TClass2Str;
      {-Prefix S with 'AT+F'}
    begin
      MakeResp := '+F' + S;
    end;

  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      if Class2_0 then begin
        cClassCmd     := MakeCmd(C20ClassCmd);
        cModelCmd     := MakeCmd(C20ModelCmd);
        cMfrCmd       := MakeCmd(C20MfrCmd);
        cRevCmd       := MakeCmd(C20RevCmd);
        cDISCmd       := MakeCmd(C20DISCmd);
        cStationCmd   := MakeCmd(C20StationCmd);
        cDCCCmd       := MakeCmd(C20DCCCmd);
        cFaxResp      := MakeResp(C20FaxResp);
        cDISResp      := MakeResp(C20DISResp);
        cDCSResp      := MakeResp(C20DCSResp);
        cTSIResp      := MakeResp(C20TSIResp);
        cCSIResp      := MakeResp(C20CSIResp);
        cPageResp     := MakeResp(C20PageResp);
        cHangResp     := 'F'+ C20HangResp;
      end else begin
        cClassCmd     := MakeCmd(C2ClassCmd);
        cModelCmd     := MakeCmd(C2ModelCmd);
        cMfrCmd       := MakeCmd(C2MfrCmd);
        cRevCmd       := MakeCmd(C2RevCmd);
        cDISCmd       := MakeCmd(C2DISCmd);
        cStationCmd   := MakeCmd(C2StationCmd);
        cDCCCmd       := MakeCmd(C2DCCCmd);
        cFaxResp      := MakeResp(C2FaxResp);
        cDISResp      := MakeResp(C2DISResp);
        cDCSResp      := MakeResp(C2DCSResp);
        cTSIResp      := MakeResp(C2TSIResp);
        cCSIResp      := MakeResp(C2CSIResp);
        cPageResp     := MakeResp(C2PageResp);
        cHangResp     := 'F' + C2HangResp;
      end;
    end;
  end;

  function fGetModemClassSupport(FP : PFaxRec;
                                 var Class1, Class2, Class2_0 : Boolean;
                                 Reset : Boolean) : Boolean;
  var
    LC      : Integer;
    WasBusy : Boolean;
    Dummy   : Boolean;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {Assume failure}
      fGetModemClassSupport := False;
      Class1 := False;
      Class2 := False;
      Class2_0 := False;

      {Prepare to wait for responses}
      aPort.SetEventBusy(WasBusy, True);

      {Reset the modem}
      if Reset then begin
        LC := 0;
        repeat

          Inc(LC);
          if (LC > 2) or not caProcessModemCmd(FP, cForcedInit) then begin 
            aPort.SetEventBusy(Dummy, WasBusy);
            Exit;
          end;
        until caOkResponse(FP);
      end;

      {Ask the modem...}
      if not caProcessModemCmd(FP, 'AT+FCLASS=?') then begin
        aPort.SetEventBusy(Dummy, WasBusy);
        Exit;
      end;
      StripPrefix(cResponse);

      {...see what it said}
      Class1 := Pos('1', cResponse) > 0;
      if Class1 then
        if Pos('1.0', cResponse) > 0 then
          cClassCmd := 'AT+FCLASS=1.0'
        else
          cClassCmd := 'AT+FCLASS=1';

      if Pos('2.0', cResponse) > 0 then begin
        Class2_0 := True;
        Class2 := Pos('2,', cResponse) > 0;
      end else
        Class2 := Pos('2', cResponse) > 0;

      fGetModemClassSupport := True;

      {Restore the busy flag}
      aPort.SetEventBusy(Dummy, WasBusy);
    end;
  end;

  function fGetModemInfo(FP : PFaxRec; var FaxClass : AnsiChar;
                         var Model, Chip, Rev : TPassString;
                         Reset : Boolean) : Boolean;
  var
    C1, C2, C2_0 : Boolean;
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      {assume failure}
      fGetModemInfo := False;

      {Get class to init}
      FaxClass := '0';
      Model := '';
      Chip  := '';
      Rev   := '';

      if Reset then begin
        caFlushModem(FP);

        if (cModemInit <> '') and (not caProcessModemCmd(FP, cModemInit)) then
          Exit;

        if not caProcessModemCmd(FP, cForcedInit) then              
          Exit;
      end;
      cInitSent := True;

      if not fGetModemClassSupport(FP, C1, C2, C2_0, True) then
        Exit;

      if C2_0 then begin
        fPrepCommands(FP, True);
        FaxClass := 'B'
      end else if C2 then begin
        fPrepCommands(FP, False);
        FaxClass := '2'
      end else if C1 then
        FaxClass := '1'
      else
        Exit;

      if caProcessModemCmd(FP, cModelCmd) then begin
        StripPrefix(cResponse);
        Model := cResponse;
      end;

      if caProcessModemCmd(FP, cMfrCmd) then begin
        StripPrefix(cResponse);
        Chip := cResponse;
      end;

      if caProcessModemCmd(FP, cRevCmd) then begin
        StripPrefix(cResponse);
        Rev := cResponse;
      end;

      fGetModemInfo := True;
    end;
  end;

  function fGetModemFeatures(FP : PFaxRec; var BPS : Integer;
                             var Correction : AnsiChar) : Integer;
    {-Return highest possible codes}
  var
    C : AnsiChar;
    BitChar : AnsiChar;
    Finished : Boolean;
  begin
    fGetModemFeatures := ecOK;

    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      BPS := 0;
      Correction := '0';

      {Assure we're a class 2 modem first}
      case aClassInUse of
        ctClass2    : fPrepCommands(FP, False);
        ctClass2_0  : fPrepCommands(FP, True);
        else
          Exit;
      end;

      {Test bit rates}
      C := '5';
      BitChar := '3';
      Finished := False;
      repeat
        if caProcessModemCmd(FP, cDISCmd+'=0,'+C+',0,0,0,0,0,3') and
           caOkResponse(FP) then begin
          BitChar := C;
          Finished := True;
        end;
        Dec(Byte(C));
        if (C = '1') and not Finished then begin
          BitChar := C;
          Finished := True;
        end;
      until Finished;
      case BitChar of
        '1' : BPS := 4800;
        '2' : BPS := 7200;
        '3' : BPS := 9600;
        '4' : BPS := 12000;
        '5' : BPS := 14400;
        else  BPS := 2400;
      end;

      {Test error correction}
      if caProcessModemCmd(FP, cDISCmd+'=0,0,0,0,0,1,0,3') and
         caOkResponse(FP) then
        Correction := '1'
      else
        Correction := '0';
    end;
  end;

  procedure fSetModemFeatures(FP : PFaxRec; BPS : Integer;
                               Correction : AnsiChar);
    {-Set modem features for this session}
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      cMaxFaxBPS := BPS;
      cCheckChar := Correction;
    end;
  end;

  function caSpeedCode(FP : PFaxRec) : AnsiChar;
    {-returns char code for speed}
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      case cMaxFaxBPS of
        2400 : caSpeedCode := '0';
        4800 : caSpeedCode := '1';
        7200 : caSpeedCode := '2';
        12000: caSpeedCode := '4';
        14400: caSpeedCode := '5';
        else   caSpeedCode := '3';
      end;
    end;
  end;

  procedure fGetPageInfoC12(FP : PFaxRec;
                            var Pages : Word;
                            var Page : Word;
                            var BytesTransferred : Integer;
                            var PageLength : Integer);
  var
    OutBuf : Word;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      if aSending then begin
        {Transmit data}
        Pages := cFaxHeader.PageCount;
        if aSendingCover then
          Page := 0
        else
          Page := aCurrPage;
        if Assigned(aPort) then                                        
          OutBuf := aPort.OutBuffUsed
        else                                                           
          OutBuf := 0;                                                 
        if OutBuf = 1 then
          OutBuf := 0;
        BytesTransferred := aDataCount - OutBuf;
        if BytesTransferred < 0 then
          BytesTransferred := 0;
        PageLength := aPageSize;
      end else begin
        Pages := 0;
        Page := aCurrPage;
        BytesTransferred := aDataCount;
        PageLength := 0;
      end;
    end;
  end;

  function fGetLastPageStatus(FP : PFaxRec) : Boolean;
    {-Return True if last page received OK, false otherwise}
  begin
    with PC12FaxData(FP)^, fCData^ do
      fGetLastPageStatus := cLastPageOk;
  end;

  function fGetRemoteID(FP : PFaxRec) : ShortString;
    {-Return remote station ID}
  begin
    with PC12FaxData(FP)^, fCData^ do
      fGetRemoteID := fPData^.aRemoteID;
  end;

  procedure fGetSessionParams(FP : PFaxRec;
                              var BPS : Integer;
                              var Resolution : Boolean;
                              var Correction : Boolean);
    {-Return remote or session parameters}
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      BPS := cSessionBPS;
      Resolution := cSessionRes;
      Correction := cSessionECM;
    end;
  end;

  function fGetHangupResult(FP : PFaxRec) : Word;
    {-Return last hangup result, class 2 only}
  begin
    with PC12FaxData(FP)^, fCData^ do
      fGetHangupResult := cHangupCode;
  end;

  procedure caCalcMinBytesPerLine(FP : PFaxRec);
    {-Calculate minimum byte per line}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do
      cMinBytes :=
        ((cSessionBPS * ScanTimes[cSessionScan, cSessionRes]) div 8000);
  end;

  procedure caExtractClass1Params(FP : PFaxRec;
                                  DIS : Boolean; B2, B3 : Byte);
    {-Extract bps, res, ecm from 2nd byte of DCS/DIS}
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      FillChar(cRmtMods, SizeOf(cRmtMods), False);
      cRmtMods[1] := True;
      cRmtMods[2] := True;

      if DIS then begin
        cRmtMods[6] := B2 and $20 = $20;
        cRmtMods[5] := B2 and $10 = $10;
        case B2 and $0C of
          $04 : cRmtMods[4] := True;
          $0C : begin
                  cRmtMods[3] := True;
                  cRmtMods[4] := True;
                end;
        end;

        {Set SessionBPS from lowest common between local and remote capabilities}
        {and less than or equal to MaxFaxBPS}
        cBPSIndex := MaxModIndex+1;
        repeat
          Dec(cBPSIndex);
        until (cLocalMods[cBPsIndex] and cRmtMods[cBPSIndex]) and
              (Class1BPSArray[cBPSIndex] <= cMaxFaxBPS);
        cSessionBPS := Class1BPSArray[cBPSIndex];

      end else begin
        if B2 and $20 = $20 then
          cBPSIndex := 6
        else if B2 and $10 = $10 then
          cBPSIndex := 5
        else begin
          case B2 and $0C of
            $00 : cBPSIndex := 1;
            $08 : cBPSIndex := 2;
            $04 : cBPSIndex := 4;
            else  cBPSIndex := 3;
          end;
        end;
        cSessionBPS := Class1BPSArray[cBPSIndex];
      end;

      {Set resolution and error correction}
      if DIS then
        cSessionRes := cResC = '1'
      else
        cSessionRes := B2 and $40 = $40;

      if DIS then
        cSessionWid := cPageHeader.ImgFlags and ffHighWidth <> 0
      else
        cSessionWid := B3 and $03 = $01;

      cSessionECM := False;

      if DIS then begin
        cCanDoHighRes := B2 and $40 = $40;
        cCanDoHighWid := B3 and $03 = $01;
      end;

      {Set scan times}
      case B3 and $70 of
        $70 : cSessionScan := 0;   {0,0}
        $10 : cSessionScan := 1;   {5,5}
        $60 : cSessionScan := 2;   {10,5}
        $20 : cSessionScan := 3;   {10,10}
        $30 : cSessionScan := 4;   {20,10}
        $00 : cSessionScan := 5;   {20,20}
        $50 : cSessionScan := 6;   {40,20}
        $40 : cSessionScan := 7;   {40,40}
      end;
      caCalcMinBytesPerLine(FP);
    end;
  end;

  procedure caExtractClass2Params(FP : PFaxRec; S : ShortString);
    {-Extract bps, res, ecm from S, as data from FDCS/FDIS}
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      case S[3] of
        '0': cSessionBPS := 2400;
        '1': cSessionBPS := 4800;
        '2': cSessionBPS := 7200;
        '4': cSessionBPS := 12000;
        '5': cSessionBPS := 14400;
        else cSessionBPS := 9600;
      end;

      cSessionRes   := S[1] = '1';
      cCanDoHighRes := cSessionRes;
      cSessionWid   := S[5] = '1';
      cCanDoHighWid := cSessionWid;

      case cResponse[11] of
        '1', '2' : cSessionECM := True;
        else       cSessionECM := False;
      end;

      cSessionScan := Ord(cResponse[15])-$30;

      caCalcMinBytesPerLine(FP);
    end;
  end;

(* not currently used

  function caModulationCode(FP : PFaxRec; B : Byte) : ShortString;
    {-Returns highest modulation string from 2nd byte of DCS/DIS}
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      if B and $20 = $20 then
        caModulationCode := '145'
      else if B and $10 = $10 then
        caModulationCode := '121'
      else begin
        case B and $0C of
          $00 : caModulationCode := '24';
          $08 : caModulationCode := '48';
          $04 : caModulationCode := '96';
          $0C : caModulationCode := '72';
        end;
      end;
    end;
  end; *)

  function caNextBPS(FP : PFaxRec) : Boolean;
    {-Return next lower BPS, False if at 2400}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      repeat
        Dec(cBPSIndex);
      until (cBPSIndex = 0) or (cLocalMods[cBPSIndex] and cRmtMods[cBPSIndex]);
      caNextBPS := cBPSIndex <> 0;
      if cBPSIndex <> 0 then
        cSessionBPS := Class1BPSArray[cBPSIndex];
      caCalcMinBytesPerLine(FP);
    end;
  end;

  function caSendClass1Command(FP : PFaxRec) : Boolean;                  {!!.01}
    { send the Class 1/1.0 command }
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      if cClassCmd = '' then begin
        cClassCmd := 'AT+FCLASS=1';
        Result := caProcessModemCmd(FP, cClassCmd);
        if not Result then begin
          cClassCmd := 'AT+FCLASS=1.0';
          Result := caProcessModemCmd(FP, cClassCmd)
        end;
      end else
        Result := caProcessModemCmd(FP, cClassCmd);
    end;
  end;

  procedure caGetClass1Modulations(FP : PFaxRec; Transmit : Boolean);
    {-Get this faxmodem's transmit/receive modulation capabilities}
  var
    Finished : Boolean;
    Dummy    : Boolean;
    WasBusy  : Boolean;
    I        : Word;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {At least one modem requires AT+FCLASS before FTM, so do it}
      if not caSendClass1Command(FP) then                                {!!.01}
        Exit;

      {Set defaults}
      FillChar(cLocalMods, SizeOf(cLocalMods), False);
      cLocalMods[1] := True;
      cLocalMods[2] := True;
      cBPSIndex := 1;

      {Send the appropriate command}
      if Transmit then
        caPutModem(FP, 'AT+FTM=?')
      else
        caPutModem(FP, 'AT+FRM=?');
      NewTimer(cReplyTimer, cReplyWait);

      {Prepare to wait...}
      aPort.SetEventBusy(WasBusy, True);

      repeat
        {Collect the response}
        cResponse := '';
        repeat
          Finished := caAddReceivedCmd(FP, cResponse);
          SafeYield;
          aPort.ProcessCommunications;
        until Finished or TimerExpired(cReplyTimer);

        {If this is a modulation response string, parse it}
        if Pos(',', cResponse) <> 0 then begin
          for I := 3 to 6 do
            cLocalMods[I] := Pos(ModArray[I], cResponse) <> 0;

          {Note highest mod}
          cBPSIndex := MaxModIndex;
          while not cLocalMods[cBPSIndex] do
            Dec(cBPSIndex);
        end;

        {Wait briefly for OK}
        if TimerExpired(cReplyTimer) then
          Finished := True
        else begin
          NewTimer(cReplyTimer, 36);
          Finished := caOkResponse(FP) or caErrorResponse(FP);
        end;

        SafeYield;
        aPort.ProcessCommunications;
      until Finished or TimerExpired(cReplyTimer);

      {Restore the busy flag}
      aPort.SetEventBusy(Dummy, WasBusy);
    end;
  end;

  procedure caHDLCStart(FP : PFaxRec; Last : Boolean);
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      DelayMS(FrameWait);
      aPort.PutChar(AddrField);
      if Last then
        aPort.PutChar(ControlFieldLast)
      else
        aPort.PutChar(ControlField);
    end;
  end;

  procedure caHDCLEnd(FP : PFaxRec);
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      aPort.PutChar(cDLE);
      aPort.PutChar(cETX);
    end;
  end;

  procedure caPutStandardFrame(FP : PFaxRec; Frame : Byte;
                               Last : Boolean);                     
    {-Transmit an standard frame of type Frame}
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {Send HDLC address and control fields}
      caHDLCStart(FP, Last);

      {Send fax control field, EOP format}
      aPort.PutChar(AnsiChar(Frame));

      {Send message terminator}
      caHDCLEnd(FP);
    end;
  end;

  procedure caPutTSIFrame(FP : PFaxRec);
    {-Transmit a TSI frame}
  var
    I : Word;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {Send HDLC address and control fields}
      caHDLCStart(FP, False);

      {Send fax control field, TSI format}
      aPort.PutChar(AnsiChar(TSIFrame or $01));

      {Send TSI data}
      for I := 19 downto Length(aStationID) do
        aPort.PutChar(' ');
      for I := Length(aStationID) downto 1 do
        aPort.PutChar(AnsiChar(aStationID[I]));

      {Send message terminator}
      caHDCLEnd(FP);
    end;
  end;

  procedure caPutDCSDISFrame(FP : PFaxRec; UseDIS : Boolean);
    {-Transmit a DCS or DIS frame}
  var
    B : Byte;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {Send HDLC address and control fields}
      caHDLCStart(FP, True);

      {Send fax control field, DCS format}
      if UseDIS then
        aPort.PutChar(AnsiChar(DISFrame))
      else
        aPort.PutChar(AnsiChar(DCSFrame or $01));

      {Send DCS/DIS data, first byte is static}
      aPort.PutChar(AnsiChar(DISGroup1));

      {Second byte contains resolution and BPS info}
      B := DISGroup3_1;

      {Can receive at high resolution, set when transmitting high res}
      if UseDIS or (cResC = '1') then
        B := B or DISHighResolution;

      if UseDIS then begin
        case cBPSIndex of
          6 :  B := B or DIS7200BPS or DIS14400BPS;
          5 :  B := B or DIS7200BPS or DIS12000BPS;                  
          3 :  B := B or DIS7200BPS;
          2 :  B := B or DIS4800BPS;
          1 :  B := B or DIS2400BPS;
          else B := B or DIS7200BPS
        end;
      end else begin
        case cBPSIndex of
          6 :  B := B or DIS14400BPS;
          5 :  B := B or DIS12000BPS;
          3 :  B := B or DIS7200BPS;
          2 :  B := B or DIS4800BPS;
          1 :  B := B or DIS2400BPS;
          else B := B or DIS9600BPS;
        end;
      end;
      aPort.PutChar(ANsiChar(B));

      {Note modulation code for training and message transmission}
      if not UseDIS then
        cModCode := ModArray[cBPSIndex];

      {Third byte}
      if UseDIS then
        B := DISGroup3_2 or ZeroScanTime
      else
        B := DISGroup3_2 or ScanTimeResponse[cSessionScan, cSessionRes];

      if UseDIS or ((cPageHeader.ImgFlags and ffHighWidth) <> 0) then
        B := B or DISWideWidth;

      aPort.PutChar(AnsiChar(B));

      {Last byte is static}
      aPort.PutChar(AnsiChar(DISGroup3_3));

      {Send message terminator}
      caHDCLEnd(FP);
    end;
  end;

  procedure caPutCSIFrame(FP : PFaxRec);
    {-Transmit a CSI frame}
  var
    I : Word;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {Send HDLC address and control fields}
      caHDLCStart(FP, False);

      {Send fax control field, CSI format}
      aPort.PutChar(AnsiChar(CSIFrame));

      {Send CSI data}
      for I := 19 downto Length(aStationID) do
        aPort.PutChar(' ');
      for I := Length(aStationID) downto 1 do
        aPort.PutChar(AnsiChar(aStationID[I]));

      {Send message terminator}
      caHDCLEnd(FP);
    end;
  end;

  procedure caPutTCFData(FP : PFaxRec);
    {-Put zeros for training data}
  var
    Required : Word;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {Assumes free space is available}

      Required := 18 * (cSessionBPS div 100);
      if Required > SizeOf(cBufferBlock) then
        {sanity check}
        Required := SizeOf(cBufferBlock);
      FillChar(cBufferBlock, Required, #0);
      aPort.PutBlock(cBufferBlock, Required);                      
      caHDCLEnd(FP);
    end;
  end;

  function caProcessFrame(FP : PFaxRec;
                         var Retrain, Last : Boolean) : Integer;
    {-Process the frame in Response}
  var
    I : Word;
  begin
    caProcessFrame := ecOK;

    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      Retrain := False;

      {Discard till flag byte}
      while (cResponse[1] <> #255) and (Length(cResponse) > 1) do
        Delete(cResponse, 1, 1);

      {If last frame, return True}
      Last := Byte(cResponse[2]) and $10 = $10;
      cReceivedFrame := Ord(cResponse[3]);

      {Process frame}
      case (cReceivedFrame and $FE )of
        TSIFrame,
        CSIFrame :
          begin
            {Extract remote station ID}
            for I := 1 to 20 do
              aRemoteID[I] := cResponse[24-I];
            aRemoteID[0] := #20;
            aFaxProgress := fpGotRemoteID;
            cForceStatus := True;
          end;
        DISFrame :
          begin
            {Extract session parameters}
            caExtractClass1Params(FP, True,
                                  Ord(cResponse[5]), Ord(cResponse[6]));

            if (not cCanDoHighRes and
               ((cPageHeader.ImgFlags and ffHighRes  ) <> 0)) or
               (not cCanDoHighWid and
               ((cPageHeader.ImgFlags and ffHighWidth) <> 0)) then begin
              afReportError(FP, ecFaxBadMachine);
              Exit;
            end else begin
              aFaxProgress := fpSessionParams;
              cForceStatus := True;
            end;
          end;
        DCSFrame :
          begin
            {Extract session parameters}
            caExtractClass1Params(FP, False, Ord(cResponse[5]),
                                  Ord(cResponse[6]));

            {Set modulation code}
            cModCode := ModArray[cBPSIndex];

            aFaxProgress := fpSessionParams;
            cForceStatus := True;
          end;
        CFRFrame :
          cGotCFR := True;
        NSFFrame :
          {Nothing to do for NSF frames} ;
        RTNFrame,
        FTTFrame :
          Retrain := True;
        DCNFrame :
          {Unexpected disconnect request}
          caProcessFrame := ecCancelRequested;
      end;
      caPrepResponse(FP);
    end;
  end;

{C12SendFax}

  function fInitC12SendFax(var FP : PFaxRec; ID : Str20;
                           ComPort : TApdBaseDispatcher; Window : TApdHwnd) : Integer;
  begin
    FP := AllocMem(SizeOf(TC12SendFax));
    with PC12SendFax(FP)^ do begin

      fMaxRetries    := DefMaxRetries;
      fMaxSendCount  := DefMaxSendCnt;
      fBufferMinimum := DefBufferMin;
      fSafeMode      := True;
      fFastPage      := True;                                       

      cInitC12AbsData(fCData);
      if fCData = nil then begin
        fInitC12SendFax := ecOutOfMemory;
        fDoneC12SendFax(FP);
        Exit;
      end;

      afInitFaxData(fPData, ID, ComPort, Window);
      if fPData = nil then begin
        fInitC12SendFax := ecOutOfMemory;
        fDoneC12SendFax(FP);
        Exit;
      end;
    end;

    with PC12SendFax(FP)^, fCData^, fPData^ do begin

      aSending := True;
    end;
    fInitC12SendFax := ecOK;
  end;

  procedure fDoneC12SendFax(var FP : PFaxRec);
  {function fDoneC12SendFax(var FP : PFaxRec) : Integer;}
  begin
    if not Assigned(FP) then
      Exit;

    with PC12SendFax(FP)^ do begin
      if Assigned(fConverter) then
        if PTextFaxData(fConverter^.UserData)^.IsExtended then
          fcDoneTextExConverter(fConverter)
        else
          fcDoneTextConverter(fConverter);
      afDoneFaxData(fPData);
      cDoneC12AbsData(fCData);
      FreeMem(FP, SizeOf(TC12SendFax));
    end;
  end;

  procedure fSetHeaderText(FP : PFaxRec; S : ShortString);
    {-set HeaderLine to S}
  begin
    with PC12SendFax(FP)^ do
      fHeaderLine := S;
  end;

  procedure fSetEnhTextEnabled(FP : PFaxRec; Enabled : Boolean);
  begin
    PC12FaxData(FP)^.fcData^.cEnhTextEnabled := Enabled;
  end;

  procedure fSetEnhSmallFont(FP : PFaxRec; SmFont : TFont);
  begin
    with PC12FaxData(FP)^, fcData^ do begin
      if Assigned(cEnhSmallFont) then
        cEnhSmallFont.Assign(SmFont);
    end;
  end;

  procedure fSetEnhStandardFont(FP : PFaxRec; StFont : TFont);
  begin
    with PC12FaxData(FP)^, fcData^ do begin
      if Assigned(cEnhStandardFont) then
        cEnhStandardFont.Assign(StFont);
    end;
  end;

  procedure fSetBlindDial(FP : PFaxRec; Blind : Boolean);
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      cBlindDial := Blind;
      if not cDetectBusy and cBlindDial then
        cForcedInit := ShortString(DefX1Init)
      else if not cDetectBusy then
        cForcedInit := ShortString(DefNoDetectBusyInit)
      else if cBlindDial then
        cForcedInit := ShortString(DefBlindInit)
      else
        cForcedInit := ShortString(DefNormalInit);
    end;
  end;

  procedure fSetDetectBusy(FP : PFaxRec; DetectBusySignal : Boolean);
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      cDetectBusy := DetectBusySignal;
      if not cDetectBusy and cBlindDial then
        cForcedInit := ShortString(DefX1Init)
      else if not cDetectBusy then
        cForcedInit := ShortString(DefNoDetectBusyInit)
      else if cBlindDial then
        cForcedInit := ShortString(DefBlindInit)
      else
        cForcedInit := ShortString(DefNormalInit);
    end;
  end;

  procedure fSetTapiDefInit(FP : PFaxRec);
  begin
    with PC12FaxData(FP)^, fCData^ do
      cForcedInit := ShortString(DefTapiInit);
  end;

  procedure fSetToneDial(FP : PFaxRec; Tone : Boolean);
  begin
    with PC12FaxData(FP)^, fCData^ do begin
      cToneDial := Tone;
      { bail if we're using the TAPI dialing properties }
      if fPData^.aUsingTapi then                                         {!!.04}
        Exit;                                                            {!!.04}
      {if cDialTonePulse = ' ' then}                                     {!!.04}
        {Exit;}                                                          {!!.04}
      if Tone then
        cDialTonePulse := 'T'
      else
        cDialTonePulse := 'P';
    end;
  end;

  procedure fSetDialPrefix(FP : PFaxRec; P : ShortString);
  begin
    with PC12FaxData(FP)^, fCData^ do
      cDialPrefix := P;
  end;

  procedure fSetDialTime(FP : PFaxRec; DT : Integer);
  begin
    with PC12FaxData(FP)^, fCData^ do
      cDialWait := DT;
  end;

  procedure csSendWhiteRasterLines(FP : PFaxRec; Count : Word);
    {-Send white raster lines to create a physical top margin}
  const
    WhiteLine : array[1..6] of Ansichar = #$00#$80#$B2'Y'#$01#$00;
  var
    I, J : Word;
  begin
    with PC12SendFax(FP)^, fCData^, fPData^ do begin
      if cMinBytes > SizeOf(WhiteLine) then
        J := succ(cMinBytes - SizeOf(WhiteLine))
      else
        J := 0;
      FillChar(cBufferBlock, J, #0);
      for I := 1 to Count do begin
        aPort.PutBlock(WhiteLine, SizeOf(WhiteLine));
        if J > 0 then
          aPort.PutBlock(cBufferBlock, J);
      end;
    end;
  end;

  procedure fSetMaxRetries(FP : PFaxRec; MR : Integer);
    {-set MaxRetries to MR}
  begin
    with PC12SendFax(FP)^ do
      fMaxRetries := MR;
  end;

  procedure fSetYielding(FP : PFaxRec; MaxLines, FreeBuffer : Word);
    {-Set the max lines sent per call and the minimum free outbuffer space}
  begin
    with PC12SendFax(FP)^ do begin
      fMaxSendCount := MaxLines;
      fBufferMinimum := FreeBuffer;
    end;
  end;

  procedure fSetSafeMode(FP : PFaxRec; SafeMode : Boolean);
    {-Enable/disable safe mode}
  begin
    with PC12SendFax(FP)^ do
      fSafeMode := SafeMode;
  end;

  procedure csPutBuffer(FP : PFaxRec; var Buffer; Len : Word);
  type
    BA = array[1..$FFF0] of AnsiChar;
  var
    I, J : Word;

  begin
    with PC12SendFax(FP)^, fCData^, fPData^ do begin
      J := 0;
      for I := 1 to Len do begin
        {Quote and send char}
        if BA(Buffer)[I] = cDLE then begin
          cBufferBlock[J] := Byte(cDLE);
          Inc(J);
          if J = SizeOf(cBufferBlock) then begin
            aPort.PutBlock(cBufferBlock, J);
            J := 0;
          end;
        end;
        cBufferBlock[J] := Byte(BA(Buffer)[I]);
        Inc(J);
        if J = SizeOf(cBufferBlock) then begin
          aPort.PutBlock(cBufferBlock, J);
          J := 0;
        end;
      end;
      if J > 0 then aPort.PutBlock(cBufferBlock, J);               
    end;
  end;

  procedure csPutLineBuffer(FP : PFaxRec; var Buffer; Len : Word);
    {Buffer has one raster line, no data word}
  type
    BA = array[1..$FFF0] of AnsiChar;
  var
    Count : Integer;
    I, J : Word;
  begin
    with PC12FaxData(FP)^, fCData^, fPData^ do begin
      {Transmit the raster line}
      J := 0;
      for I := 1 to Len do begin
        {Quote and send char}
        if BA(Buffer)[I] = cDLE then begin
          cBufferBlock[J] := Byte(cDLE);
          Inc(J);
          if J = SizeOf(cBufferBlock) then begin
            aPort.PutBlock(cBufferBlock, J);
            J := 0;
          end;
        end;
        cBufferBlock[J] := Byte(BA(Buffer)[I]);
        Inc(J);
        if J = SizeOf(cBufferBlock) then begin
          aPort.PutBlock(cBufferBlock, J);
          J := 0;
        end;
      end;
      if J > 0 then aPort.PutBlock(cBufferBlock, J);

      {Assure line has minimum number of bytes}
      if Len < cMinBytes then begin
        Count := (cMinBytes-Len);
        if Count > SizeOf(cBufferBlock) then
          Count := SizeOf(cBufferBlock);
        if Count > 0 then begin
          FillChar(cBufferBlock, Count, #0);
          aPort.PutBlock(cBufferBlock, Count);
        end;                                                         

        Inc(aDataCount, cMinBytes);
      end else
        Inc(aDataCount, Len);
    end;
  end;

  function csOpenFaxFile(FP : PFaxRec; Document : ShortString) : Integer;
  var
    W : Integer;                                                   
    S : String[6];
  begin
    with PC12SendFax(FP)^, fCData^, fPData^ do begin
      cInFileName := DefaultExtensionS(Document, aFaxFileExt);
      aSaveMode := FileMode;
      FileMode := fmOpenRead or fmShareDenyWrite;                  
      Assign(cInFile, string(cInFileName));
      Reset(cInFile, 1);
      FileMode := aSaveMode;
      W := -IOResult;                                               
      if W <> 0 then begin
        csOpenFaxFile := W;
        Exit;
      end;

      BlockRead(cInFile, cFaxHeader, SizeOf(TFaxHeaderRec));
      W := -IOResult;                                              
      if W <> 0 then begin
        Close(cInFile);
        if IOResult = 0 then ;
        csOpenFaxFile := W;
        Exit;
      end;

      SetLength(S, 6);
      Move(cFaxHeader, S[1], 6);

      if S <> DefAPFSig then begin
        csOpenFaxFile := ecFaxBadFormat;                           
        Close(cInFile);
        if IoResult <> 0 then ;
      end else
        csOpenFaxFile := ecOK;
    end;
  end;

  function csAdvancePage(FP : PFaxRec) : Integer;
    {-Advance CurrPage and read new page, return False on any error}
  var
    Res : Integer;
  begin
    with PC12SendFax(FP)^, fCData^, fPData^ do begin
      {Set page number}
      if aSendingCover then begin
        if cCoverIsAPF then begin
          Close(cInFile);
          Res := csOpenFaxFile(FP, aFaxFileName);
          if Res <> ecOK then begin
            csAdvancePage := Res;
            Exit;
          end;
        end else begin
          fCvrF.Free;                                             
          if IoResult <> 0 then ;
          fCvrOpen := False;
        end;
        aSendingCover := False;
        aCoverFile := '';
      end else begin
        Inc(aCurrPage);
        aDataCount := 0;
      end;

      {Seek to page}
      Res := caLocatePage(FP, aCurrPage);
      if Res <> ecOK then begin
        csAdvancePage := Res;
        Exit;
      end;

      {Read in the page header}
      BlockRead(cInFile, cPageHeader, SizeOf(TPageHeaderRec));
      cUseLengthWord := FlagIsSet(cPageHeader.ImgFlags, ffLengthWords);
      Res := -IOResult;                                             
      if Res <> ecOK then begin
        csAdvancePage := Res;
        Exit;
      end;

      cResCPrev := cResC;                                        

      {Build FDIS command params}
      if (cPageHeader.ImgFlags and ffHighRes) <> 0 then
        cResC := '1'
      else
        cResC := '0';

      csAdvancePage := ecOK;
    end;
  end;

  function csOpenCoverPage(FP : PFaxRec) : Integer;
    {-Open the cover file}
  var
    Res : Integer;
  begin
    with PC12SendFax(FP)^, fCData^, fPData^ do begin

      if cCoverIsAPF then begin
        {Open as an APF file}
        Close(cInFile);
        if IOResult <> 0 then ;
        Res := csOpenFaxFile(FP, aCoverFile);
        if Res <> ecOK then begin
          csOpenCoverPage := Res;
          Exit;
        end;

        {Goto the first page}
        Res := caLocatePage(FP, 1);
        if Res <> ecOK then begin
          csOpenCoverPage := Res;
          Exit;
        end;

        {Read in the page header}
        BlockRead(cInFile, cPageHeader, SizeOf(TPageHeaderRec));
        cUseLengthWord := FlagIsSet(cPageHeader.ImgFlags, ffLengthWords);
        Res := -IOResult;                                          
        if Res <> ecOK then begin
          csOpenCoverPage := Res;
          Exit;
        end;

      end else begin
        {Open as text file}
        fCvrF := TLineReader.Create(TFileStream.Create(string(aCoverFile),fmOpenRead or fmShareDenyWrite));
          fCvrOpen := True;
          {If BindFaxFont is undefined, APFAX.FNT must be in
           the current directory.}
          if PTextFaxData(fConverter^.UserData)^.IsExtended then
            Res := fcSetFont(fConverter, cEnhStandardFont, (cResC = '1'))
          else                                                           
            Res := fcLoadFont(fConverter, 'APFAX.FNT', StandardFont, (cResC = '1'));
          if Res <> ecOK then begin
            csOpenCoverPage := Res;
            afReportError(FP, Res);
            Exit;
          end;
      end;

      {Success}
      csOpenCoverPage := ecOK;
    end;
  end;

  {$IFDEF DebugFax}
  function StateStr(State : SendStates) : ShortString;
  begin
    case State of
      tfGetEntry : Result := 'tfGetEntry';
      tfInit : Result := 'tfInit';
      tfDial : Result := 'tfDial';
      tfSendPageHeader : Result := 'tfSendPageHeader';
      tfOpenCover : Result := 'tfOpenCover';
      tfPrepPage : Result := 'tfPrepPage';
      tf1PrepareEOP : Result := 'tf1PrepareEOP';
      tf2SendEOP : Result := 'tf2SendEOP';
      tf2SendNewParams : Result := 'tf2SendNewParams';
      tf2NextPage : Result := 'tf2NextPage';
      tfClose : Result := 'tfClose';
      tfAbort : Result := 'tfAbort';
      tfCompleteOK : Result := 'tfCompleteOK';
      tf1Init1 : Result := 'tf1Init1';
      tf2Init1 : Result := 'tf2Init1';
      tf2Init1A : Result := 'tf2Init1A';
      tf2Init1B : Result := 'tf2Init1B';                            
      tf2Init2 : Result := 'tf2Init2';
      tf2Init3 : Result := 'tf2Init3';
      tfRetryWait : Result := 'tfRetryWait';
      tf1Connect : Result := 'tf1Connect';
      tf1SendTSI : Result := 'tf1SendTSI';
      tf1TSIResponse : Result := 'tf1TSIResponse';
      tf1DCSResponse : Result := 'tf1DCSResponse';
      tf1TrainStart : Result := 'tf1TrainStart';
      tf1TrainFinish : Result := 'tf1TrainFinish';
      tf1WaitCFR : Result := 'tf1WaitCFR';
      tf1WaitPageConnect : Result := 'tf1WaitPageConnect';
      tf2Connect : Result := 'tf2Connect';
      tf2GetParams : Result := 'tf2GetParams';
      tfWaitXon : Result := 'tfWaitXon';
      tfWaitFreeHeader : Result := 'tfWaitFreeHeader';
      tfSendCover : Result := 'tfSendCover';
      tfSendPage : Result := 'tfSendPage';
      tfDrainPage : Result := 'tfDrainPage';
      tf1PageEnd : Result := 'tf1PageEnd';
      tf1SendEOP : Result := 'tf1SendEOP';
      tf1WaitMPS : Result := 'tf1WaitMPS';
      tf1WaitEOP : Result := 'tf1WaitEOP';
      tf1WaitMCF : Result := 'tf1WaitMCF';
      tf1SendDCN : Result := 'tf1SendDCN';
      tf1HangUp : Result := 'tf1HangUp';
      tf1WaitHangup : Result := 'tf1WaitHangup';
      tf2WaitFPTS : Result := 'tf2WaitFPTS';
      tf2WaitFET : Result := 'tf2WaitFET';
      tf2WaitPageOK : Result := 'tf2WaitPageOK';
      tf20CheckPage : Result := 'tf20CheckPage';
      tfDone        : Result := 'tfDone       ';
    end;
  end;
  {$ENDIF}

  const
    InState : Boolean = False;                                        

  procedure fFaxTransmit(Msg, wParam : Cardinal;
                        lParam : Integer);
    {-Perform one increment of a fax transmit}
  label
    ExitPoint;
  const
    LastPageCode = #$2E;
    MorePagesCode : array[Boolean] of AnsiChar = (#$2C, #$3B);
    ResolutionChangeCode : array[Boolean] of AnsiChar = ('0', '1');
  var
    TriggerID   : Word absolute wParam;
    FP          : PFaxRec;
    Res         : Integer;
    Finished    : Boolean;
    Retrain     : Boolean;
    C           : AnsiChar;
    FaxWid      : AnsiChar;
    I           : Word;
    Count       : Integer;
    S           : ShortString;
    StatusTimer : EventTimer;
    Dispatcher      : TApdBaseDispatcher;

    function CheckResponse : Boolean;
      {-Check for text responses, check for and process HDLC frames}
    begin
      with PC12SendFax(FP)^, fCData^, fPData^ do begin
        {Collect chars till CR/LF or DLE/ETX}
        Finished := False;
        CheckResponse := False;
        while aPort.CharReady and not Finished do begin
          aPort.GetChar(C);
          cResponse := cResponse + C;
          if CheckForString(cCRLFIndex, C, ^M^J) then begin
            cResponse := Trim(cResponse);
            if cResponse <> '' then begin
              {Got a text response}
              Finished := True;
              CheckResponse := True;

              {Most error responses are aborts}
              if caErrorResponse(FP) then begin
                case fState of
                  tf1WaitEOP,
                  tf1WaitMCF,
                  tf1SendEOP : {Let state machine handle}
                  else begin
                    {It's an error}
                    afReportError(FP, ecFaxBadModemResult);
                    fState := tfAbort;
                  end;
                end;
              end else if caFHNGResponse(FP) then begin
                case fState of
                  tf2WaitFET, tf20CheckPage :
                    {FHNG expected} ;
                  else begin
                    {FHNG not expected, abort}
                    afReportError(FP, ecFaxBadModemResult);
                    cHangupCode := caExtractFHNGCode(FP);
                    fState := tfAbort;
                  end;
                end;
              end;
            end;
          end else if CheckForString(cEtxIndex, C, #16#3) then begin
            {An HDLC frame, process it now}
            Res := caProcessFrame(FP, Retrain, cLastFrame);

            {Abort if we got a DCN frame - or if machine does not have the}
            {capability to receive the document we're sending}
            if (Res = ecCancelRequested) or
               (Res = ecFaxBadMachine) then begin
              afReportError(FP, Res);
              fState := tfAbort;
              CheckResponse := True;
            end;

            {If this is a retrain request change the current state}
            if Retrain then begin
              if caNextBPS(FP) then begin
                caPutFrameT(FP);
                fState := tf1TSIResponse;
              end else begin
                afReportError(FP, ecFaxTrainError);
                fState := tfAbort;
              end;
            end;
          end;
        end;
      end;
    end;

    function ReadNextLine : Word;
      {-Read the next wordlength raster line}
    var
      Len : Word;
    begin
      with PC12SendFax(FP)^, fCData^, fPData^ do begin
        BlockRead(cInFile, Len, 2, cBytesRead);
        if Len > DataBufferSize then
          Len := DataBufferSize;
        BlockRead(cInFile, cDataBuffer^, Len, cBytesRead);
        ReadNextLine := -IoResult;                                   
        if Len < cMinBytes then begin
          FillChar(cDataBuffer^[Len], cMinBytes-cBytesRead, 0);
          cBytesRead := cMinBytes;
        end;
        Inc(aDataCount, Len+2);
      end;
    end;

    procedure ForceHangup;
    begin
      with PC12SendFax(FP)^, fCData^, fPData^ do begin
        if aPort.CheckDCD then begin
          DelayMS(AbortDelay);
          aPort.PutString('+++');
          DelayMS(AbortDelay);
          caPutModem(FP, 'ATH0');
          DelayMS(AbortDelay);
          aPort.FlushInBuffer;

          {If DCD still set then toggle DTR}
          if aPort.CheckDCD then
            caFlushModem(FP);
        end else begin
          {Just make sure we're back on hook}
          caPutModem(FP, 'ATH0');
          DelayMS(AbortDelay);
          aPort.FlushInBuffer;
        end;
      end;
    end;

    function MorePages : Boolean;
      {-Return True if there are more pages to send}
    begin
      with PC12SendFax(FP)^, fCData^, fPData^ do begin
        MorePages := (aFaxFileName <> '') and
                     ((aSendingCover) or (aCurrPage < cFaxHeader.PageCount));
       {Set cMorePages for use after the call to csAdvancePage}
        cMorePages := Result;                                       
      end;
    end;

    function ResolutionChange : Boolean;
      {-Return True if page has different resolution than previous one}
    begin
      with PC12SendFax(FP)^, fCData^, fPData^ do
        Result := (cResCPrev <> ' ') and (cResCPrev <> cResC);
    end;

  begin
    {Get the protocol pointer from data pointer 1}
    Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
    with Dispatcher do
      Dispatcher.GetDataPointer(Pointer(FP), 2);

    with PC12SendFax(FP)^, fCData^, fPData^ do begin

      {If it's a TriggerAvail message then force the TriggerID}
      if Msg = APW_TRIGGERAVAIL then
        TriggerID := aDataTrigger;

      {Exit immediately on triggers that aren't ours}
      if (TriggerID <> aDataTrigger) and
         (TriggerID <> aTimeoutTrigger) and
         (TriggerID <> aStatusTrigger) and
         (TriggerID <> aOutBuffFreeTrigger) and
         (TriggerID <> aOutBuffUsedTrigger) then
        Exit;

      {Exit immediately if we are currently processing an abort}
      if fState = tfAbort then
        Exit;

      {Process until we encounter a wait condition}
      repeat
        if aPort.Logging then
          aPort.AddDispatchEntry(dtFax,LogSendFaxState[fState],aPort.OutBuffUsed,nil,0);
        {$IFDEF DebugFax}
        writeln(debug, 'send top: ', statestr(fstate));
        {$ENDIF}

        {Check for user abort}
        if Msg = apw_FaxCancel then begin
          aFaxProgress := fpCancel;
          aFaxError := ecCancelRequested;
          fState := tfAbort;
          afFaxStatus(FP, False, False);                           
        end else begin
          {Show status periodically (but not when processing user aborts)}
          if (TriggerID = aStatusTrigger) or cForceStatus then begin
            cForceStatus := False;
            afFaxStatus(FP, False, False);
            aPort.SetTimerTrigger(aStatusTrigger, Secs2Ticks(aStatusInterval), True);

            {Exit immediately on status triggers}
            if TriggerID = aStatusTrigger then
              goto ExitPoint;
          end;
        end;

        {Preprocess pending modem responses}
        case fState of
          tfGetEntry : if InState then Exit;                         
          tfInit,
          tfDial,
          tfRetryWait,
          tfOpenCover,
          tfSendCover,
          tfWaitXon,
          tfWaitFreeHeader,
          tfSendPageHeader,
          tfPrepPage,
          tfSendPage,
          tfDrainPage,
          tf1PrepareEOP,
          tf2SendEOP,
          tf2SendNewParams,                                          
          tf2NextPage,
          tfClose,
          tfCompleteOK,
          tfAbort : {Don't preprocess these states} ;

          else begin
            {Preprocess all other states....}
            if TriggerID = aDataTrigger then begin
              {Data is available, check responses and HDLC frames}
              if not CheckResponse then
                {not ready yet, just exit}
                Exit
            end else if TriggerID = aTimeoutTrigger then begin
              case fState of
                tf1WaitMCF :
                  begin
                    aPort.PutChar(' ');
                    fState := tf1PrepareEOP;
                  end;
                tf1WaitHangup :
                  {Timeout waiting for normal hangup, force hangup and close OK}
                  begin
                    ForceHangup;
                    fState := tfClose;
                  end;
                tf1Connect, tf2Connect :
                   begin
                    {Timeout waiting for remote to answer}
                    afReportError(FP, ecNoAnswer);
                    fState := tfAbort;
                  end;
                else begin
                  afReportError(FP, ecTimeout);
                  fState := tfAbort;
                end;
              end;
            end;
          end;
        end;

        {Process the current fax transmit state}
        case fState of
          tfGetEntry :
            if not InState then begin
              InState := True;

              if afNextFax(FP) then begin
                {Assume fax number, name and cover are set}

                {Log transmit started}
                afLogFax(FP, lfaxTransmitStart);

                {Prepare for transmit}
                aConnectCnt := 0;
                aSendingCover := False;
                cCoverIsAPF := False;
                aPageCount  := 0;
                aCoverCount := 0;
                fRetries    := 0;
                cHangupCode := 0;
                aFaxError   := ecOK;
                cRetry      := 0;                                        {!!.05}

                {Status inits}
                aDataCount   := 0;
                aCurrPage    := 1;
                aPageSize    := 0;
                aRemoteID    := '';
                aCoverCount  := 0;
                aConnectCnt  := 0;

                {Open fax file}
                if aFaxFileName <> '' then begin
                  Res := csOpenFaxFile(FP, aFaxFileName);
                  if Res <> ecOK then begin
                    afReportError(FP, Res);
                    fState := tfAbort;
                    goto ExitPoint;
                  end;

                  {Verify it's one of ours}
                  SetLength(S, 6);
                  Move(cFaxHeader, S[1], 6);

                  if S <> DefAPFSig then begin
                    afReportError(FP, ecFaxBadFormat);
                    fState := tfAbort;
                    goto ExitPoint;
                  end;

                  {Note page count and continue}
                  aPageCount := (cFaxHeader.PageCount);
                end else if aCoverFile <> '' then begin
                  {Sending just cover}
                  aPageCount := 0;
                end else begin
                  afReportError(FP, ecNoFilename);
                  fState := tfAbort;
                  goto ExitPoint;
                end;

                fState := tfInit;

                {Make sure flow control is off to start}
                if FlagIsSet(afFlags, afSoftwareFlow) then
                  aPort.SWFlowDisable;
              end else
                fState := tfCompleteOK;
              Instate := False;
            end;

          tfInit :
            begin
              {Make sure station ID is all uppercase}
              if Length(aStationID) > 0 then
                AnsiUpperBuff(@aStationID[1], Length(aStationID));

              if aCoverFile <> '' then begin
                aCoverCount := 1;
                aSendingCover := True;
                cCoverIsAPF := Pos('.'+aFaxFileExt, aCoverFile) <> 0;
              end;

              {Read first page header}
              if aFaxFileName <> '' then begin
                Res := caLocatePage(FP, aCurrPage);
                if Res <> ecOK then begin
                  afReportError(FP, Res);
                  fState := tfAbort;
                  goto ExitPoint;
                end;

                BlockRead(cInFile, cPageHeader, SizeOf(TPageHeaderRec));
                cUseLengthWord := FlagIsSet(cPageHeader.ImgFlags, ffLengthWords);
                Res := -IOResult;
                if Res <> ecOK then begin
                  afReportError(FP, Res);
                  fState := tfAbort;
                  goto ExitPoint;
                end;

                {Set resolution character for DIS/DCS commands/frames}

                cResCPrev := cResC;

                if (cPageHeader.ImgFlags and ffHighRes) <> 0 then
                  cResC := '1'
                else
                  cResC := '0';

              end else begin
                {Just sending cover, assume low res}
                cResC := '0';
                {If cover is APF, open to get its res}
                if cCoverIsAPF then begin
                  Res := csOpenCoverPage(FP);
                  if Res <> ecOK then begin
                    afReportError(FP, Res);
                    fState := tfAbort;
                    goto ExitPoint;
                  end;

                  if (cPageHeader.ImgFlags and ffHighRes) <> 0 then
                    cResC := '1'
                  else
                    cResC := '0';
                  Close(cInFile);
                  if IoResult <> 0 then ;
                end;
              end;

              {Say we're initializing}
              aFaxProgress := fpInitModem;
              cForceStatus := True;

              caPutModem(FP, cClassCmd);                                 {!!.01}
              {Select next state for Class1 or Class2 modems}
              if aClassInUse = ctClass1 then                             {!!.01}
                fState := tf1Init1                                       {!!.01}
              else                                                       {!!.01}
                fState := tf2Init1;                                      {!!.01}
            end;

          tf1Init1 :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then
                fState := tfDial
              else begin
                afReportError(FP, ecFaxInitError);
                fState := tfAbort;
              end;

          tf2Init1 :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                caPutModem(FP, cStationCmd+'="'+aStationID+'"');
                if (aClassInUse = ctClass2_0) then
                  fState := tf2Init1A
                else
                  fstate := tf2Init2;
              end else begin
                afReportError(FP, ecFaxInitError);
                fState := tfAbort;
              end;

          tf2Init1A :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                caPutModem(FP, 'AT+FLO=2');
                fState := tf2Init1B;
              end else begin
                afReportError(FP, ecFaxInitError);
                fState := tfAbort;
              end;

          tf2Init1B :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                caPutModem(FP, 'AT+FNR=1,1,1,0');
                fState := tf2Init2;
              end else begin
                afReportError(FP, ecFaxInitError);
                fState := tfAbort;
              end;

          tf2Init2 :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                if ((cPageHeader.ImgFlags and ffHighWidth) <> 0) then
                  FaxWid := '1'
                else
                  FaxWid := '0';

                caPutModem(FP, cDISCmd+'='+cResC+','+
                             caSpeedCode(FP)+','+
                             FaxWid+
                             ',2,0,'+
                             cCheckChar+
                             ',0,0');
                fState := tf2Init3;
              end else begin
                afReportError(FP, ecFaxInitError);
                fState := tfAbort;
              end;

          tf2Init3 :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then
                fState := tfDial
              else begin
                afReportError(FP, ecFaxInitError);
                fState := tfAbort;
              end;

          tfDial:
            begin
              {Build modem dial string}
              fSetToneDial(FP, cToneDial);                               {!!.01}
              if aSendManual then
                s := 'ATD'
              else
                S := ShortString('ATD') + cDialTonePulse + cDialPrefix + aPhoneNum;

              caPutModem(FP, S);
              aPort.SetTimerTrigger(aTimeoutTrigger, cDialWait, True);
              if aSendManual then
                aFaxProgress := fpConnecting
              else
                aFaxProgress := fpDialing;
              cForceStatus := True;
              if aClassInUse = ctClass1 then
                fState := tf1Connect
              else
                fState := tf2Connect;
              aSendManual := False;                                    
            end;

          tfRetryWait :
            fState := tfInit{tfDial};                                  

          tf1Connect :
            if TriggerID = aDataTrigger then
              if caConnectResponse(FP) then
                caPrepResponse(FP)
              else if caOkResponse(FP) then begin
                if cLastFrame then begin
                  {Last frame was processed, prepare to transmit TSI}
                  DelayMS(ExtraCommandDelay);
                  caPutFrameT(FP);
                  cLastFrame := False;
                  fState := tf1SendTSI;
                end else begin
                  {Ask for another frame}
                  caPutFrameR(FP);
                end;
              end else if (Pos('BUSY', cResponse) <> 0) or
                          (Pos('ANSWER', cResponse) <> 0) then begin
                Inc(aConnectCnt);
                if (aConnectCnt < aMaxConnect) or (aMaxConnect = 0) then begin
                  {No connect, delay and retry}
                  aFaxProgress := fpBusyWait;
                  cForceStatus := True;
                  fState := tfRetryWait;
                  aPort.SetTimerTrigger(aTimeoutTrigger, aRetryWait, True);
                end else begin
                  {Too many failed connect attempts}
                  afFaxStatus(FP, False, False);
                  if FlagIsSet(afFlags, afAbortNoConnect) then begin
                    afReportError(FP, ecFaxBusy);
                    fState := tfAbort;
                  end else begin
                    {Get next fax entry}
                    Close(cInFile);
                    if IOResult = 0 then ;
                    afReportError(FP, ecFaxBusy);
                    afLogFax(FP, lfaxTransmitFail);
                    aFaxProgress := fpInitModem;
                    fState := tfGetEntry;
                  end;
                end
              end else if (Pos('VOICE', cResponse) > 0) or
                (Pos('VCON', cResponse) > 0) then begin             
                {Modem is receiving a voice call}
                afReportError(FP, ecFaxVoiceCall);
                fState := tfAbort;
              end else if Pos('NO DIAL', cResponse) > 0 then begin
                {No dialtone when trying to dial}
                afReportError(FP, ecFaxNoDialTone);
                fState := tfAbort;
              end else if caNoCarrierResponse(FP) then begin
                {No carrier when trying to call}
                afReportError(FP, ecFaxNoCarrier);
                fState := tfAbort;
              end else
                {Must have been the command echo, discard it and keep going}
                caPrepResponse(FP);

          tf1SendTSI :
            if TriggerID = aDataTrigger then
              if caConnectResponse(FP) then begin
                caPutTSIFrame(FP);
                caPrepResponse(FP);
                fState := tf1TSIResponse;
              end else
                caPrepResponse(FP);

          tf1TSIResponse :
            if TriggerID = aDataTrigger then
              if caConnectResponse(FP) then begin
                caPutDCSDISFrame(FP, False);
                caPrepResponse(FP);
                fState := tf1DCSResponse;
              end else
                caPrepResponse(FP);

          tf1DCSResponse :
            if TriggerID = aDataTrigger then
              { some modems are returning "Connect" instead of "OK" }
              if caOkResponse(FP) or caConnectResponse(FP) then begin    {!!.04}
                {Start training...}
                caPutFaxCommand(FP, 'AT+FTM='+cModCode);
                fState := tf1TrainStart;
              end else
                caPrepResponse(FP);

          tf1TrainStart :
            if TriggerID = aDataTrigger then
              if caConnectResponse(FP) or caOkResponse(FP) then begin    {!!.05}
                {Send training data}
                if FlagIsSet(afFlags, afSoftwareFlow) then
                  aPort.SWFlowEnable(0, 0, sfTransmitFlow);
                caPutTCFData(FP);
                caPrepResponse(FP);
                fState := tf1TrainFinish;
              end else
                caPrepResponse(FP);

          tf1TrainFinish :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                {Ask for CFR frame}
                if FlagIsSet(afFlags, afSoftwareFlow) then
                  aPort.SWFlowDisable;
                DelayMS(ExtraCommandDelay);
                caPutFrameR(FP);
                fState := tf1WaitCFR;
                cGotCFR := False;
              end;

          tf1WaitCFR :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                if cLastFrame then begin
                  {Send carrier}
                  if cGotCFR then begin
                    DelayMS(ExtraCommandDelay);
                    caPutFaxCommand(FP, 'AT+FTM='+StModArray[cBpsIndex]);
                    cLastFrame := False;
                    fState := tf1WaitPageConnect;
                  end else begin
                    {Must be a re-negotiate, restart from DCS again}
                    DelayMS(ExtraCommandDelay);
                    caPutFrameT(FP);
                    fState := tf1TSIResponse;
                  end;
                end else begin
                  {Ask for another frame}
                  caPutFrameR(FP);
                  caPrepResponse(FP);
                end;
              end else
                caPrepResponse(FP);


          tf1WaitPageConnect :
            if TriggerID = aDataTrigger then
              if caConnectResponse(FP) then begin
                fState := tfWaitXon;
                aPort.SetTimerTrigger(aTimeoutTrigger, 18, True);
              end else
                caPrepResponse(FP);

          tf2Connect :
            if TriggerID = aDataTrigger then
              if Pos(cFaxResp, cResponse) <> 0 then begin
                aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
                cResponse := '';
                fState := tf2GetParams;
              end else if (Pos('BUSY', cResponse) <> 0) or
                          (Pos('ANSWER', cResponse) <> 0) then begin
                Inc(aConnectCnt);
                if (aConnectCnt < aMaxConnect) or (aMaxConnect = 0) then begin
                  {No connect, delay and retry}
                  aFaxProgress := fpBusyWait;
                  cForceStatus := True;
                  fState := tfRetryWait;
                  aPort.SetTimerTrigger(aTimeoutTrigger, aRetryWait, True);
                end else begin
                  {Too many failed connect attempts}
                  afFaxStatus(FP, False, False);

                  if FlagIsSet(afFlags, afAbortNoConnect) then begin
                    afReportError(FP, ecFaxBusy);
                    cForceStatus := True;
                    fState := tfAbort;
                  end else begin
                    {Get next fax entry}
                    Close(cInFile);
                    if IOResult = 0 then ;
                    afReportError(FP, ecFaxBusy);
                    afLogFax(FP, lfaxTransmitFail);
                    fState := tfGetEntry;
                  end;
                end
              end else if (Pos('VOICE', cResponse) > 0) or
                (Pos('VCON', cResponse) > 0) then begin             
                {Modem is receiving a voice call}
                afReportError(FP, ecFaxVoiceCall);
                fState := tfAbort;
              end else if Pos('NO DIAL', cResponse) > 0 then begin
                {No dialtone when trying to dial}
                afReportError(FP, ecFaxNoDialTone);
                fState := tfAbort;
              end else
                {Unknown but probably acceptable response, just ignore it}
                caPrepResponse(FP);

          tf2GetParams :
            if TriggerID = aDataTrigger then
              if Pos(cDISResp, cResponse) <> 0 then begin
                StripPrefix(cResponse);
                caExtractClass2Params(FP, cResponse);

                if (((cPageHeader.ImgFlags and ffHighWidth) <> 0)
                      and not cCanDoHighWid) or
                  (((cPageHeader.ImgFlags and ffHighRes  ) <> 0)
                      and not cCanDoHighRes) then begin
                  afReportError(FP, ecFaxBadMachine);
                  fState := tfAbort;
                end else begin
                  aFaxProgress := fpSessionParams;
                  cForceStatus := True;
                  caPrepResponse(FP);
                end;
              end else if Pos(cCSIResp, cResponse) <> 0 then begin
                StripPrefix(cResponse);
                aRemoteID := TrimStationID(cResponse);
                aFaxProgress := fpGotRemoteID;
                cForceStatus := True;
                caPrepResponse(FP);
              end else if (Pos(cDCSResp, cResponse) > 0) then begin
                StripPrefix(cResponse);
                caExtractClass2Params(FP, cResponse);
                aFaxProgress := fpSessionParams;
                cForceStatus := True;
                caPrepResponse(FP);
              end else if caOkResponse(FP) then begin
                caPutModem(FP, 'AT+FDT');
                {Stay in this state to handle the response}
                aPort.SetTimerTrigger(aTimeoutTrigger, 546, True);
                NewTimer(cReplyTimer, 546);
              end else if caConnectResponse(FP) then begin
                if aClassInUse = ctClass2_0 then begin
                  fState := tfWaitFreeHeader;
                  aPort.SetStatusTrigger(aOutBuffFreeTrigger, MaxData, True);
                  aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
                end else begin
                  fState := tfWaitXon;
                  aPort.SetTimerTrigger(aTimeoutTrigger, 18, True);
                end;                                                         
              end else
                caPrepResponse(FP);

          tfWaitXon :
            if TriggerID = aDataTrigger then begin
              aPort.GetChar(C);
              if C = cXOn then begin
                fState := tfWaitFreeHeader;
                aPort.SetStatusTrigger(aOutBuffFreeTrigger, MaxData, True);
                aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
              end;
            end else if TriggerID = aTimeoutTrigger then begin
              fState := tfWaitFreeHeader;
              aPort.SetStatusTrigger(aOutBuffFreeTrigger, MaxData, True);
              aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
            end;

          tfWaitFreeHeader :
            if TriggerID = aOutBuffFreeTrigger then begin
              aFaxProgress := fpSendPage;
              fState := tfSendPageHeader;

              {Finished with handshaking, turn on flow control}
              if FlagIsSet(afFlags, afSoftwareFlow) then
                aPort.SWFlowEnable(0, 0, sfTransmitFlow);

            end else if TriggerID = aTimeoutTrigger then begin
              afReportError(FP, ecTimeout);
              fState := tfAbort;
            end;

          tfSendPageHeader :
            begin
              {Select font for title line}
              if PTextFaxData(fConverter^.UserData)^.IsExtended then
                Res := fcSetFont(fConverter, cEnhSmallFont, (cResC = '1'))
              else                                                         
                Res := fcLoadFont(fConverter, 'APFAX.FNT', SmallFont, (cResC = '1'));
              if Res <> ecOK then begin
                afReportError(FP, Res);
                fState := tfAbort;
                goto ExitPoint;
              end;

              {Convert and send header line}
              if fHeaderLine <> '' then begin
                S := afConvertHeaderString(FP, fHeaderLine);

                {Force a small top margin}
                csSendWhiteRasterLines(FP, PhysicalTopMargin);

                {Add some zeros to give state machine caller some breathing room}
                Count := (Integer(fBufferMinimum) - Integer(aPort.OutBuffUsed));
                if Count > SizeOf(cBufferBlock) then
                  Count := SizeOf(cBufferBlock);
                if Count > 0 then begin
                  FillChar(cBufferBlock, Count, #0);
                  aPort.PutBlock(cBufferBlock, Count);
                end;

                {Send all raster rows in header}
                with fConverter^, PTextFaxData(UserData)^ do begin
                  if Length(S) <> 255 then
                    S[Length(S)+1] := #0
                  else
                    S[255] := #0;
                  for I := 1 to FontRec.Height do begin
                    {Rasterize, compress and transmit each row}
                    FillChar(cDataBuffer^, DataBufferSize, 0);
                    fcRasterizeText(fConverter, @S[1], I, cDataBuffer^);
                    acCompressRasterLine(fConverter, cDataBuffer^);
                    csPutLineBuffer(FP, DataLine^, ByteOfs);
                  end;
                end;

                {Force the first disk read}
                cBytesRead := 1;
              end else
                csSendWhiteRasterLines(FP, PhysicalTopMargin);

              {Add some zeros to give state machine caller some breathing room}
              Count := (Integer(fBufferMinimum) - Integer(aPort.OutBuffUsed));
              if Count > SizeOf(cBufferBlock) then
                Count := SizeOf(cBufferBlock);
              if Count > 0 then begin
                FillChar(cBufferBlock, Count, #0);
                aPort.PutBlock(cBufferBlock, Count);
              end;

              if aCoverFile = '' then
                fState := tfPrepPage
              else
                fState := tfOpenCover;
            end;

          tfOpenCover:
            begin
              aDataCount := 0;
              Res := csOpenCoverPage(FP);
              if Res <> ecOK then begin
                afReportError(FP, Res);
                fState := tfAbort;
                goto ExitPoint;
              end;

              if cCoverIsAPF then
                fState := tfPrepPage
              else begin
                fState := tfSendCover;
                aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
                aPort.SetStatusTrigger(aOutBuffFreeTrigger,
                                  DataBufferSize, True);
                aFaxProgress := fpSendPage;
              end;
            end;

          tfSendCover:
            if TriggerID = aOutBuffFreeTrigger then begin
              {Convert and send text lines...}
              {while (not Eof(TextFile(fCvrF))) and}
              while not fCvrF.EOLF and
                    (aPort.OutBuffFree > MaxData) do begin

                {Read next text line}
                S := fCvrF.NextLine;
                {Convert it...}
                S := afConvertHeaderString(FP, S);
                with fConverter^, PTextFaxData(UserData)^ do begin
                  if Length(S) <> 255 then
                    S[Length(S)+1] := #0
                  else
                    S[255] := #0;

                  {...and send all raster lines}
                  for I := 1 to FontRec.Height do begin
                    {Rasterize, compress and transmit each row}
                    FillChar(cDataBuffer^, DataBufferSize, 0);
                    fcRasterizeText(fConverter, @S[1], I, cDataBuffer^);
                    acCompressRasterLine(fConverter, cDataBuffer^);
                    csPutLineBuffer(FP, DataLine^, ByteOfs);
                  end;
                end;
              end;

              {Handle exit from loop}
              if fCvrF.EOLF then begin
                {Exited due to eof, finish this page}
                acMakeEndOfPage(fConverter,
                                cDataBuffer^,
                                cBytesRead);
                csPutBuffer(FP, cDataBuffer^, cBytesRead);

                Count := (cMinBytes - cBytesRead);
                if Count > SizeOf(cBufferBlock) then
                  Count := SizeOf(cBufferBlock);
                if Count > 0 then begin
                  FillChar(cBufferBlock, Count, #0);
                  aPort.PutBlock(cBufferBlock, Count);
                end;

                if aClassInUse = ctClass1 then begin
                  caHDCLEnd(FP);
                  aFaxProgress := fpSendPage;
                end;

                {Set state and triggers for output buffer drain}
                fState := tfDrainPage;
                aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
                aPort.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
              end else begin
                {Exited because outbuff is too full}
                aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
                aPort.SetStatusTrigger(aOutBuffFreeTrigger,
                                  DataBufferSize, True);
              end;
            end else if TriggerID = aTimeoutTrigger then begin
              afReportError(FP, ecTimeout);
              cForceStatus := True;
              fState := tfAbort;
              goto ExitPoint;
            end;

          tfPrepPage :
            begin
              {Position at the start of data}
              aDataCount := 0;
              aPageSize := cPageHeader.ImgLength;
              fState := tfSendPage;
              cForceStatus := True;
              aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
              aPort.SetStatusTrigger(aOutBuffFreeTrigger,
                                DataBufferSize, True);
            end;

          tfSendPage :
            if TriggerID = aOutBuffFreeTrigger then begin
              Count := 0;
              NewTimer(StatusTimer, Secs2Ticks(aStatusInterval * 3)); 
              while (Count < fMaxSendCount) and
                    (aPort.OutBuffUsed <= fBufferMinimum) and
                    (aPort.OutBuffFree >= DataBufferSize) do begin

                if TimerExpired(StatusTimer) then begin
                  cForceStatus := False;
                  afFaxStatus(FP, False, False);
                  aPort.SetTimerTrigger(aStatusTrigger, Secs2Ticks(aStatusInterval), True);
                  NewTimer(StatusTimer, Secs2Ticks(aStatusInterval * 2));
                end;

                Inc(Count);
                if aDataCount < aPageSize then begin
                  {Get next block of data to send}
                  if cUseLengthWord then
                    {Reads line and increments DataCount}
                    Res := ReadNextLine
                  else begin
                    BlockRead(cInFile, cDataBuffer^,
                              DataBufferSize, cBytesRead);
                    Inc(aDataCount, cBytesRead);
                    Res := -IOResult;
                  end;

                  if Res <> ecOk then begin
                    afReportError(FP, Res);
                    fState := tfAbort;
                    goto ExitPoint;
                  end;

                  {Send data}
                  csPutBuffer(FP, cDataBuffer^, cBytesRead);
                end else begin
                  {End of this page, add Class 1 termination}
                  if aClassInUse = ctClass1 then begin
                    caHDCLEnd(FP);
                    aFaxProgress := fpSendPage;
                  end;

                  {Wait for page to drain}
                  fState := tfDrainPage;

                  {Force exit from while loop}
                  Count := fMaxSendCount + 1;
                end;
              end;

              {Set triggers for next stage}
              if fState = tfDrainPage then begin
                {End of page, set drain triggers}
                aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
                aPort.SetStatusTrigger(aOutBuffUsedTrigger, 0, True);
              end else begin
                {More data to come, wait for buffer freespace}
                aPort.SetTimerTrigger(aTimeoutTrigger, cTransWait, True);
                aPort.SetStatusTrigger(aOutBuffFreeTrigger,
                                  DataBufferSize, True);
              end;

            end else if TriggerID = aTimeoutTrigger then begin
              afReportError(FP, ecTimeout);
              cForceStatus := True;
              fState := tfAbort;
              goto ExitPoint;
            end else begin
              {Discard incoming data while sending page}
              if TriggerID = aDataTrigger then begin
                while aPort.CharReady do
                  aPort.GetChar(C);
              end;
            end;

          tfDrainPage :
            if TriggerID = aOutBuffUsedTrigger then begin
              {Finished with data, turn off flow control}
              if FlagIsSet(afFlags, afSoftwareFlow) then
                aPort.SWFlowDisable;

              if MorePages then begin
                {Advance to next page}
                Res := csAdvancePage(FP);
                if Res <> ecOK then begin
                  fState := tfAbort;
                  goto ExitPoint;
                end;
              end;

              case aClassInUse of
                ctClass1   :
                  fState := tf1PageEnd;                           
                ctClass2   :
                  begin
                    aPort.PutChar(cDLE);
                    aPort.PutChar(cETX);
                    fState := tf2SendEOP;
                  end;
                ctClass2_0 :
                  begin
                    aPort.PutChar(cDLE);
                    if cMorePages then
                      aPort.PutChar(MorePagesCode[ResolutionChange])
                    else
                      aPort.PutChar(LastPageCode);                    
                    fState := tf2SendEOP;
                  end;
              end;

              {Force status one more time so user's display shows 100%}
              cForceStatus := True;
              aFaxProgress := fpSendPage;
            end else if TriggerID = aTimeoutTrigger then begin
              afReportError(FP, ecTimeout);
              cForceStatus := True;
              fState := tfAbort;
            end else begin
              {Discard any incoming data until we're finished draining}
              while aPort.CharReady do
                aPort.GetChar(C);
            end;

          tf1PageEnd :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                cRetry := 0;
                fState := tf1PrepareEOP;
                aFaxProgress := fpSendPageStatus;
              end else
                caPrepResponse(FP);

          tf1PrepareEOP :
            begin
              Inc(cRetry);
              if cRetry > 3 then begin
                if fState = tf1WaitMCF then begin                        {!!.06}
                { some receivers will disconnect after receiving the MCF }
                { frame, which is our message that all pages have been   }
                { sent. According to the spec, this is a fatal error, but}
                { it's a common implementation in real-life. This change }
                { generates the OnFaxError event with ErrorCode = -8071, }
                { but also generates an OnFaxFinish with ErrorCode = 0.  }
                { HangupCode is set to 52 ("MPS sent three times without }
                { response"), but it can still be considered a successful}
                { fax since the remote received all pages.               }
                  afReportError(FP, ecFaxMCFNoAnswer);                   {!!.06}
                  aFaxError := ecOK;                                     {!!.06}
                  cHangupCode := 52;                                     {!!.06}
                  cForceStatus := True;                                  {!!.06}
                  fState := tf1Hangup;                                   {!!.06}
                end else begin                                           {!!.06}
                  afReportError(FP, ecTimeout);
                  cForceStatus := True;
                  fState := tfAbort;
                end                                                      {!!.06}
           end else begin
                DelayMS(PreEOPDelay);
                caPutFrameT(FP);
                fState := tf1SendEOP;
              end;
            end;

          tf1SendEOP :
            if TriggerID = aDataTrigger then
              if caConnectResponse(FP) then begin
                if cMorePages then begin
                  if fFastPage then
                    {Send end of page, stay in phase C}
                    caPutStandardFrame(FP, MPSFrame or $01, True)
                  else
                    {Send end of page, switch to phase B}
                    caPutStandardFrame(FP, EOMFrame or $01, True)
                end else
                  {Send end of page, no more pages frame}
                  caPutStandardFrame(FP, EOPFrame or $01, True);     

                caPrepResponse(FP);
                fState := tf1WaitMPS;
              end else
                caPrepResponse(FP);

          tf1WaitMPS :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                {Ask for comfirmation}
                DelayMS(ExtraCommandDelay);
                caPutFrameR(FP);
                fState := tf1WaitMCF;
                aPort.SetTimerTrigger(aTimeoutTrigger, 54, True);
                fMCFConnect := False;
              end else
                caPrepResponse(FP);

          tf1WaitEOP :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                {Ask for comfirmation}
                DelayMS(ExtraCommandDelay);
                caPutFrameR(FP);
                fState := tf1WaitMCF;
                NewTimer(cReplyTimer, 54);
                fMCFConnect := False;
              end else
                caPrepResponse(FP);

          tf1WaitMCF :
            if TriggerID = aDataTrigger then
              if caConnectResponse(FP) then begin
                fMCFConnect := True;
                caPrepResponse(FP);
              end else if caErrorResponse(FP) then begin
                fState := tf1PrepareEOP;
              end else if caOkResponse(FP) then begin
                case cReceivedFrame of
                  RTPFrame :
                    if cMorePages then begin
                      caPutFrameT(FP);
                      fState := tf1TSIResponse;
                    end else begin
                      {No more pages}
                      caPutFrameT(FP);
                      fState := tf1SendDCN;
                    end;
                  RTNFrame :
                    begin
                      afReportError(FP, ecFaxSessionError);
                      fState := tfAbort;
                    end;
                  MCFFrame :
                    if cMorePages then begin
                      if fFastPage then begin
                        {Staying in phase C}
                        caPutFaxCommand(FP, 'AT+FTM='+cModCode);
                        fState := tf1WaitPageConnect;
                      end else begin
                        {Switching to phase B}
                        if cLastFrame then begin
                          {Remote is skipping resend of CSI/DIS, so we'll}
                          {restart phase B by sending our DCS}
                          caPutFrameT(FP);
                          fState := tf1TSIResponse;
                        end else
                          {Remote is sending its CSI/DIS, go get them}
                          fState := tf1Connect;
                      end;
                    end else begin
                      {No more pages}
                      caPutFrameT(FP);
                      fState := tf1SendDCN;
                    end;
                end;

                if cReceivedFrame in [RTPFrame, MCFFrame] then begin     {!!.05}
                  aFaxProgress := fpPageOK;                              {!!.05}
                  cForceStatus := True;                                  {!!.05}
                end;                                                     {!!.05}       

                {Ask for the next frame if there are more coming}
                if not cLastFrame then
                  caPutFrameR(FP);
              end else
                caPrepResponse(FP);

          tf1SendDCN :
            if TriggerID = aDataTrigger then
              if caConnectResponse(FP) then begin
                caPutStandardFrame(FP, DCNFrame or $01, True);       
                caPrepResponse(FP);
                fState := tf1Hangup;
              end else
                caPrepResponse(FP);

          tf1HangUp :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                {Hangup}
                caPutModem(FP, 'ATH');

                {Special short (2 seconds) wait for hangup result}
                aPort.SetTimerTrigger(aTimeoutTrigger, 26, True);
                fState := tf1WaitHangup;
              end else
                caPrepResponse(FP);

          tf1WaitHangup :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then
                fState := tfClose
              else
                caPrepResponse(FP);

          tf2SendEOP :
            begin
              {Prepare to receive EOP response}
              cResponse := '';
              aPort.SetTimerTrigger(aTimeoutTrigger, cTranswait, True);
              aFaxProgress := fpSendPageStatus;
              cForceStatus := True;
              if aClassInUse = ctClass2 then
                fState := tf2WaitFPTS
              else
                fState := tf20CheckPage;
            end;

          tf2WaitFPTS:
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                if cMorePages then
                  S := ShortString('AT+FET=') + ResolutionChangeCode[ResolutionChange]
                else
                  S := 'AT+FET=2';
                caPutModem(FP, S);
                fState := tf2WaitFET;
                aPort.SetTimerTrigger(aTimeoutTrigger, cTranswait, True);
              end else begin
                afReportError(FP, ecFaxSessionError);
                fState := tfAbort;
              end;

          tf2WaitFET :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then
                {Got OK from FPTS:1}
                if ResolutionChange then
                  fState := tf2SendNewParams
                else                                                
                  fState := tf2NextPage
              else if caFHNGResponse(FP) then begin
                cHangupCode := caExtractFHNGCode(FP);
                caPrepResponse(FP);
              end else if Pos(cPageResp, cResponse) <> 0 then begin
                StripPrefix(cResponse);
                case cResponse[1] of
                  '1', '3' : {page good}
                    begin
                      aFaxProgress := fpPageOK;
                      cForceStatus := True;
                      caPrepResponse(FP);
                      {Stay in this state for OK}
                    end;

                  '2' : {page bad, retry requested}
                    begin
                      aFaxProgress := fpPageError;
                      fState := tf2WaitPageOK;
                      cForceStatus := True;
                      caPrepResponse(FP);
                    end;

                  '4', '5' :  {page good/bad, interrupt requested}
                    begin
                      afReportError(FP, ecCancelRequested);
                      cForceStatus := True;
                      fState := tfAbort;
                    end;
                  else begin
                    afReportError(FP, ecFaxPageError);
                    cForceStatus := True;
                    fState := tfAbort;
                  end;
                end;
              end else begin
                afReportError(FP, ecFaxPageError);
                cForceStatus := True;
                fState := tfAbort;
              end;

          tf20CheckPage :
            if TriggerID = aDataTrigger then begin
              if caOkResponse(FP) then begin
                {Remote accepted page, move on}
                if ResolutionChange then
                  fState := tf2SendNewParams
                else                                                  
                  fState := tf2NextPage;
                aFaxProgress := fpPageOK;
                cForceStatus := True;
              end else if caErrorResponse(FP) then begin
                {Remote rejected page, attempt retry}
                caPutModem(FP, 'AT+FPS?');
                caPrepResponse(FP);
                fState := tf2WaitPageOK;
                cForceStatus := True;
                aFaxProgress := fpPageError;
              end else if caFHNGResponse(FP) then begin
                cHangupCode := caExtractFHNGCode(FP);
              end else begin
                afReportError(FP, ecFaxPageError);
                cForceStatus := True;
                fState := tfAbort;
              end;
            end;

          tf2WaitPageOK :
            if TriggerID = aDataTrigger then
              if caOkResponse(FP) then begin
                Inc(fRetries);
                if fRetries > fMaxRetries then begin
                  {Abort}
                  aPort.PutString('AT+FKS'^M);
                  afReportError(FP, ecFaxSessionError);
                  cForceStatus := True;
                  fState := tfAbort;
                end else begin
                  {Let modem start retraining...}
                  caPutModem(FP, 'AT+FDT');

                  {Reset to beginning of this same page}
                  if aFaxFileName <> '' then begin
                    Res := caLocatePage(FP, aCurrPage);
                    if Res <> ecOK then begin
                      afReportError(FP, Res);
                      fState := tfAbort;
                      goto ExitPoint;
                    end;

                    BlockRead(cInFile, cPageHeader, SizeOf(TPageHeaderRec));
                    cUseLengthWord :=
                      FlagIsSet(cPageHeader.ImgFlags, ffLengthWords);
                    Res := -IOResult;                                
                    if Res <> ecOK then begin
                      afReportError(FP, Res);
                      fState := tfAbort;
                      goto ExitPoint;
                    end;
                  end else begin
                    {Sending cover only, close to prepare for re-open above}
                    fCvrF.Free;
                    fCvrOpen := False;
                  end;

                  {Go back to training state}
                  fState := tf2GetParams;
                end;
              end else begin
                afReportError(FP, ecFaxSessionError);
                cForceStatus := True;
                fState := tfAbort;
              end;

          tf2SendNewParams :
            if cMorePages then begin
              if aClassInUse = ctClass2 then
                caPutModem(FP, ShortString('AT+FDIS=') + cResC)
              else
                caPutModem(FP, ShortString('AT+FIS=') + cResC);
               fState := tf2GetParams;
            end else
              fState := tfClose;

          tf2NextPage :
            if cMorePages then begin
              {Advance to next page}
              DelayTicks(5, True);                                 
              caPutModem(FP, 'AT+FDT');
              fState := tf2GetParams;
            end else
              fState := tfClose;

          tfClose :
            begin
              if fCvrOpen then begin
                fCvrF.Free;
                fCvrOpen := False;
              end;
              Close(cInFile);
              if IoResult = 0 then ;
              fRetries := 0;
              aSendingCover := False;

              {Tell status we're finished with this fax}
              aFaxProgress := fpFinished;
              cForceStatus := True;

              {Log this successful transfer}
              afLogFax(FP, lfaxTransmitOk);

              {Look for another fax to send}
              fState := tfGetEntry;

              caSwitchBaud(FP, False);
            end;

          tfAbort :
            begin
              {Assure files are closed}
              Close(cInFile);
              if IoResult <> 0 then ;
              if fCvrOpen then begin
                fCvrF.Free;
                fCvrOpen := False;
              end;

              afLogFax(FP, lfaxTransmitFail);
              ForceHangup;

              {Exit or remain in state machine}
              if FlagIsSet(afFlags, afExitOnError) or
                 FlagIsSet(afFlags, afAbortNoConnect) or
                 (Msg = APW_FAXCANCEL) then begin
                aFaxProgress := fpCancel;
                afFaxStatus(FP, False, True);
                afSignalFinish(FP);
                cInitSent := False;
                fState := tfDone;
              end else
                fState := tfGetEntry;

              caSwitchBaud(FP, False);
            end;

          tfCompleteOK :
            begin
              afFaxStatus(FP, False, True);
              afSignalFinish(FP);
              cInitSent := False;
              fState := tfDone;
            end;
        end;

ExitPoint:
        Instate := False;                                              
        {Should we exit?}
        case fState of
          {stay}
          tfGetEntry,
          tfInit,
          tfDial,
          tfSendPageHeader,
          tfOpenCover,
          tfPrepPage,
          tf1PrepareEOP,
          tf2SendEOP,
          tf2NextPage,
          tfClose,
          tfAbort,
          tfCompleteOK : Finished := False;

          {Stay/leave conditionally}
          tf1Init1,
          tf2Init1,
          tf2Init1A,
          tf2Init1B,
          tf2Init2,
          tf2Init3,
          tf1Connect,
          tf1SendTSI,
          tf1TSIResponse,
          tf1DCSResponse,
          tf1TrainStart,
          tf1TrainFinish,
          tf1WaitCFR,
          tf1WaitPageConnect,
          tf2Connect,
          tf2GetParams,
          tf1PageEnd,
          tf1SendEOP,
          tf1WaitMPS,
          tf1WaitEOP,
          tf1WaitMCF,
          tf1SendDCN,
          tf1Hangup,
          tf1WaitHangup,
          tf2WaitFPTS,
          tf2WaitFET,
          tf2WaitPageOK,
          tf20CheckPage : Finished := not aPort.CharReady;

          {leave}
          tfRetryWait,
          tfWaitXon,
          tfWaitFreeHeader,
          tfSendCover,
          tfSendPage,
          tfDrainPage,
          tfDone          : Finished := True;
        end;

        {If we're not exiting, set TriggerID to indicate data is available}
        TriggerID := aDataTrigger;

      until Finished;
    end;
  end;

  function fPrepareFaxTransmit(FP : PFaxRec) : Integer;
    {-Prepare a fax send session}
  begin
    fPrepareFaxTransmit := ecOK;

    with PC12SendFax(FP)^, fCData^, fPData^ do begin

      cResC := ' '; {Ain't seen nuthin' yet}

      { Do we have a converter?  If so, is it the right type? }
      if Assigned(fConverter) then begin
        if cEnhTextEnabled <>
           PTextFaxData(fConverter^.UserData)^.IsExtended then begin
          if PTextFaxData(fConverter^.UserData)^.IsExtended then
            fcDoneTextExConverter(fConverter)
          else
            fcDoneTextConverter(fConverter);
        end;
      end;

      { If we don't have a converter at this point -- init a new one }
      if not Assigned(fConverter) then begin
        if cEnhTextEnabled then
          fcInitTextExConverter(fConverter)
        else
          fcInitTextConverter(fConverter);
      end;

      {Inits}
      FillChar(cFaxHeader, SizeOf(TFaxHeaderRec), 0);
      fState := tfGetEntry;
      aFaxProgress := fpInitModem;
      aFaxError := ecOK;
      aFaxListNode := aFaxListHead;
      afFaxStatus(FP, True, False);

      {Status inits}
      aDataCount   := 0;
      aCurrPage    := 1;
      aPageSize    := 0;
      aRemoteID    := '';
      aCoverCount  := 0;
      aFaxFileName := '';
      aCoverFile   := '';
      aPhoneNum    := '';
      aConnectCnt  := 0;

      {Force 19200 port rate}
      aPort.ChangeBaud(19200);

      {"reset" modem}
      aPort.SetModem(True, True);                                    

      {If Class hasn't been set yet then figure out highest class}
      if aClassInUse = ctUnknown then
        aClassInUse := ctDetect;
      if (aClassInUse = ctDetect) then
        if fSetClassType(FP, ctDetect) = ctUnknown then begin
          afReportError(FP, ecFaxInitError);{ecFaxBadModemResult);}      {!!.04}
          Exit;
        end;

      {If not sent already, send modem and def init strings}
      if not cInitSent then begin
        {Send user init}
        if (cModemInit <> '') and
           (not caProcessModemCmd(FP, cModemInit)) then begin
          afReportError(FP, ecFaxInitError);{ecFaxBadModemResult);}      {!!.04}
          Exit;
        end;

        {Send required inits}
        if not caProcessModemCmd(FP, cForcedInit) then begin         
          afReportError(FP, ecFaxInitError);{ecFaxBadModemResult);}      {!!.04}
          Exit;
        end;
        cInitSent := True;
      end;

      {Set class 2 commands/responses}
      case aClassInUse of
        ctClass2    : fPrepCommands(FP, False);
        ctClass2_0  : fPrepCommands(FP, True);
      end;

      {Switch to normal baud rate}
      caSwitchBaud(FP, True);

      {Get class1 get modulation capabilities}
      if aClassInUse = ctClass1 then
        caGetClass1Modulations(FP, True);

      {Say we're in progress}
      aInProgress := True;
    end;
  end;

{C12ReceiveFax}

  function fInitC12ReceiveFax(var FP : PFaxRec; ID : Str20;
                              ComPort : TApdBaseDispatcher; Window : TApdHwnd) : Integer;
    {-Create and init the C12 receive component}
  begin
    FP := AllocMem(SizeOf(TC12ReceiveFax));
    with PC12ReceiveFax(FP)^ do begin
      cInitC12AbsData(fCData);
      if fCData = nil then begin
        fInitC12ReceiveFax := ecOutOfMemory;
        fDoneC12ReceiveFax(FP);
        Exit;
      end;

      afInitFaxData(fPData, ID, ComPort, Window);
      if fPData = nil then begin
        fInitC12ReceiveFax := ecOutOfMemory;
        fDoneC12ReceiveFax(FP);
        Exit;
      end;
    end;

    with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
      aCurrPage     := 1;
      cCurrOfs      := 0;
      fLast         := #255;
      aSending      := False;
      fState        := rfInit;
      fFirstState   := rfInit;
    end;
    fInitC12ReceiveFax := ecOK;
  end;

  function fDoneC12ReceiveFax(var FP : PFaxRec) : Integer;
  begin
    fDoneC12ReceiveFax := ecOK;
    if not Assigned(FP) then
      Exit;

    with PC12ReceiveFax(FP)^ do begin
      afDoneFaxData(fPData);
      cDoneC12AbsData(fCData);
      FreeMem(FP, SizeOf(TC12ReceiveFax));
    end;
  end;

  function fInitModemForFaxReceive(FP : PFaxRec) : Boolean;
    {-Send nessessary commands to initialize modem for fax receive}
  var
    WasBusy  : Boolean;
    Dummy    : Boolean;

    procedure Cleanup;
    begin
      with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
        FlushInQueue(FP);
        aPort.SetEventBusy(Dummy, WasBusy);
      end;
    end;

  begin
    with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
      {Force 19200 port rate}
      aPort.ChangeBaud(19200);                                      

      fInitModemForFaxReceive := False;
      caFlushModem(FP);

      {Prepare to wait for responses}
      aPort.SetEventBusy(WasBusy, True);

      if (cModemInit <> '') and
         (not caProcessModemCmd(FP, cModemInit)) then begin
        CleanUp;
        Exit;
      end;

      if not caProcessModemCmd(FP, cForcedInit) then begin
        CleanUp;
        Exit;
      end;
      cInitSent := True;

      {Make sure we know the class type}
      if aClassInUse = ctDetect then
        aClassInUse := fSetClassType(FP, aClassInUse);

      {Prep for class2/2.0}
      case aClassInUse of
        ctClass2    : fPrepCommands(FP, False);
        ctClass2_0  : fPrepCommands(FP, True);
      end;

      {Send the class command}
      if aClassInUse = ctClass1 then                                     {!!.01}
        Result := caSendClass1Command(FP)                                {!!.01}
      else                                                               {!!.01}
        Result := caProcessModemCmd(FP, cClassCmd);                      {!!.01}

      if not Result then begin                                           {!!.01}
        CleanUp;
        Exit;
      end;

      {Switch to normal baud rate}
      caSwitchBaud(FP, True);

      if (aClassInUse = ctClass2) or (aClassInUse = ctClass2_0) then begin
        if (aClassInUse = ctClass2) then
          if not caProcessModemCmd(FP, 'AT+FCLASS=0') then begin
            Cleanup;
            Exit;
          end;

        if not caProcessModemCmd(FP, 'AT+FCR=1') then begin
          CleanUp;
          Exit;
        end;

        if not caProcessModemCmd(FP, cStationCmd+'="'+aStationID+'"') then begin
          CleanUp;
          Exit;
        end;

        if not caProcessModemCmd(FP, ShortString('AT+FAA=') + cFaxAndData) then begin
          CleanUp;
          Exit;
        end;

        if not caProcessModemCmd(
               FP, cDCCCmd+'=1,'+caSpeedCode(FP)+',0,2,0,0,0,0') then begin
          CleanUp;
          Exit;
        end;
      end else if (aClassInUse = ctClass1) then begin                 
        { Even though we don't officially support class 1 adaptive answer,  }
        { get the modulation capabilities here since they will be needed if }
        { the programmer decides to support it. }
        caGetClass1Modulations(FP, False);

        {Set highest BPSIndex from MaxFaxBPS and local modulation capabilities}
        inc(cBPSIndex);
        repeat
          dec(cBPSIndex);
        until Class1BPSArray[cBPSIndex] <= cMaxFaxBPS;
      end;

      fInitModemForFaxReceive := True;
    end;

    {Allow other trigger handlers to run again}
    CleanUp;
  end;

  procedure fSetConnectState(FP : PFaxRec);
    {-Force the receiver to pick up a connection in progress}
  begin
    with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
      {Init to midstream values}
      fFirstState := rf2GetSenderID;
      fPageStatus := rpsNewDocument;
      cInitSent := True;
      cResponse := '';
      aFaxError := ecOK;

      aCurrPage := 1;
      aDataCount := 0;
      cInFileName := '';
      aRemoteID := '';
      aPhoneNum := '';
      aFaxFileName := '';

      {Show the first status here}
      fShowStatus := True;
      afFaxStatus(FP, True, False);

      {Start a timer for collecting the next fax response}
      NewTimer(cReplyTimer, cReplyWait);
      aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
    end;
  end;

  procedure fSetAnswerOnRing(FP : PFaxRec; AOR : Integer);
    {-set Nth ring for modem answer}
  begin
    with PC12FaxData(FP)^, fCData^ do
      cAnswerOnRing := AOR;
  end;

  procedure fSetFaxAndData(FP : PFaxRec; OnOff : Boolean);
    {-True for fax to answer either fax or data, False for fax only}
  begin
    with PC12FaxData(FP)^, fCData^ do
      if OnOff then
        cFaxAndData := '1'
      else
        cFaxAndData := '0';
  end;

  procedure fSetOneFax(FP : PFaxRec; OnOff : Boolean);
    {-Set "one fax" receive behavior on/off}
  begin
    with PC12ReceiveFax(FP)^ do
      fOneFax := OnOff;
  end;

  procedure crFlushBuffer(FP : PFaxRec);
    {-write current buffered data to InFile}
  var
    BytesWritten : Integer;
    Res : Integer;
  begin
    with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
      {Write the block}
      BlockWrite(cInFile, cDataBuffer^, cCurrOfs, BytesWritten);
      Res := -IOResult;                                             
      if BytesWritten <> cCurrOfs then
        Res := ecDeviceWrite;
      if Res <> ecOK then
        afReportError(FP, Res);
      cCurrOfs := 0;
    end;
  end;

  function crAddReceivedData(FP : PFaxRec) : Boolean;
    {-Get waiting FAX stream data.  Returns True if EOP seen.}
  var
    C : AnsiChar;
    Count : Word;

    function AddToStream(C : ANsiChar) : Boolean;
    begin
      with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
        AddToStream := True;
        if (aClassInUse = ctClass2) then
          cDataBuffer^[cCurrOfs] := RotateByte(C)
        else
          cDataBuffer^[cCurrOfs] := Byte(C);
        Inc(cCurrOfs);
        if cCurrOfs >= DataBufferSize then begin
          crFlushBuffer(FP);
          if aFaxError <> ecOK then
            AddToStream := False;
        end;
      end;
    end;

  begin
    with PC12ReceiveFax(FP)^ , fCData^, fPData^do begin
      crAddReceivedData := False;
      aFaxError := ecOK;

      if aPort.CharReady then begin

        {Process while received data ready}
        Count := 0;
        while aPort.CharReady do begin

          {Periodically exit back to state machine to check abort and status}
          Inc(Count);
          if Count > DefStatusBytes then
            Exit;

          aPort.GetChar(C);

          {check for <DLE><ETX> pair indicating end of page}
          if C = cETX then
            if fLast = cDLE then begin
              crFlushBuffer(FP);
              crAddReceivedData := True;
              Exit;
            end;

            {Write data, DLE is data link escape}
            if (C <> cDLE) or ((C = cDLE) and (fLast = cDLE)) then begin
              if AddToStream(C) then
                Inc(aDataCount)
              else begin
                {Error writing to file, let state machine handle error}
                crAddReceivedData := True;
                Exit;
              end;
              if fLast = cDLE then
                fLast := #255
              else
                fLast := C;
            end else
              fLast := C;
        end;

        {update our timeout}
        aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
      end;
    end;
  end;

  function crUpdateMainHeader(FP : PFaxRec) : Integer;
    {-Update the contents of the main header in the file}
  var
    I : Integer;
    L : Integer;
    W : Integer;
  begin
    with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
      {Refresh needed fields of MainHeader rec}
      with cFaxHeader do begin
        SenderID := aRemoteID;
        FDateTime := GetPackedDateTime;
      end;

      {Save current file position for later}
      L := FilePos(cInFile);
      I := -IOResult;
      if I <> 0 then begin
        crUpdateMainHeader := I;
        Exit;
      end;

      {seek to head of file}
      Seek(cInFile, 0);
      I := -IOResult;                                                    {!!.04}
      if I <> 0 then begin
        crUpdateMainHeader := I;
        Exit;
      end;

      {Write the header}
      BlockWrite(cInFile, cFaxHeader, SizeOf(cFaxHeader), W);
      I := -IOResult;                                                
      if (I = 0) and (W <> SizeOf(cFaxHeader)) then
        I := ecDeviceWrite;
      if I <> 0 then begin
        crUpdateMainHeader := I;
        Exit;
      end;

      {Return to original position}
      Seek(cInFile, L);
      I := -IOResult;                                                 
      crUpdateMainHeader := I;
    end;
  end;


  function crUpdatePageHeader(FP : PFaxRec; PgNo : Word;
                              var PgInfo : TPageHeaderRec) : Integer;
    {-Update the contents of the PgNo-th page header in the file}
  var
    I : Integer;
    W : Integer;
    L : Integer;
  begin
    with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
      {save current file position for later}
      L := FilePos(cInFile);
      I := -IOResult;                                                
      if I <> 0 then begin
        crUpdatePageHeader := I;
        Exit;
      end;

      {find the page in question}
      I := caLocatePage(FP, PgNo);
      if I <> 0 then begin
        crUpdatePageHeader := I;
        Exit;
      end;

      {update the header}
      BlockWrite(cInFile, PgInfo, SizeOf(TPageHeaderRec), W);
      I := -IOResult;                                                
      if (I = 0) and (W <> SizeOf(TPageHeaderRec)) then
        I := ecDeviceWrite;
      if I <> 0 then begin
        crUpdatePageHeader := I;
        Exit;
      end;

      {Return to original position}
      Seek(cInFile, L);
      I := -IOResult;                                               
      crUpdatePageHeader := I;
    end;
  end;

  {$IFDEF DebugFax}
  function RStateStr(State : ReceiveStates) : ShortString;
  begin
    case State of
      rfNone : Result := 'rfNone';
      rfInit : Result := 'rfInit';
      rf1Init1 : Result := 'rf1Init1';
      rf2Init1 : Result := 'rf2Init1';
      rf2Init1A : Result := 'rf2Init1A';
      rf2Init1B : Result := 'rf2Init1B';                             
      rf2Init2 : Result := 'rf2Init2';
      rf2Init3 : Result := 'rf2Init3';
      rfWaiting : Result := 'rfWaiting';
      rfAnswer : Result := 'rfAnswer';
      rf1SendCSI : Result := 'rf1SendCSI';
      rf1SendDIS : Result := 'rf1SendDIS';
      rf1CollectFrames : Result := 'rf1CollectFrames';
      rf1StartTrain : Result := 'rf1StartTrain';
      rf1CollectTrain : Result := 'rf1CollectTrain';
      rf1Retrain : Result := 'rf1Retrain';
      rf1FinishTrain : Result := 'rf1FinishTrain';
      rf1SendCFR : Result := 'rf1SendCFR';
      rf1WaitPageConnect : Result := 'rf1WaitPageConnect';
      rf2ValidConnect : Result := 'rf2ValidConnect';
      rf2GetSenderID : Result := 'rf2GetSenderID';
      rf2GetConnect : Result := 'rf2GetConnect';
      rfStartPage : Result := 'rfStartPage';
      rfGetPageData : Result := 'rfGetPageData';
      rf1FinishPage : Result := 'rf1FinishPage';
      rf1WaitEOP : Result := 'rf1WaitEOP';
      rf1WritePage : Result := 'rf1WritePage';
      rf1SendMCF : Result := 'rf1SendMCF';
      rf1WaitDCN : Result := 'rf1WaitDCN';
      rf1WaitHangup : Result := 'rf1WaitHangup';
      rf2GetPageResult : Result := 'rf2GetPageResult';
      rf2GetFHNG : Result := 'rf2GetFHNG';
      rfComplete : Result := 'rfComplete';
      rfAbort : Result := 'rfAbort';
      rfDone : Result := 'rfDone';
    end;
  end;
  {$ENDIF}

  procedure fFaxReceive(Msg, wParam : Cardinal;
                       lParam : Integer);
    {-Perform one increment of a fax receive}
  label
    ExitPoint;
  var
    TriggerID : Word absolute wParam;
    FP        : PFaxRec;
    Res       : Integer;
    C         : AnsiChar;
    Finished  : Boolean;
    Retrain   : Boolean;
    PercentBad : Word;
    Critical  : Boolean;
    Dispatcher    : TApdBaseDispatcher;

    function CheckResponse : Boolean;
      {-Check for text responses, check for and process HDLC frames}
    begin
      with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
        {Collect chars till CR/LF or DLE/ETX}
        Finished := False;
        CheckResponse := False;
        while aPort.CharReady and not Finished do begin
          aPort.GetChar(C);
          cResponse := cResponse + C;
          if CheckForString(cCRLFIndex, C, ^M^J) then begin
            cResponse := Trim(cResponse);
            if cResponse <> '' then begin
              {Got a text response}
              Finished := True;
              CheckResponse := True;

              {All error responses are aborts}
              if caErrorResponse(FP) then begin
                afReportError(FP, ecFaxBadModemResult);
                fState := rfAbort;
              end else if caFHNGResponse(FP) and
                          (fState <> rf2GetFHNG) then begin
                {Unexpected FHNGs are also aborts}
                afReportError(FP, ecFaxSessionError);
                cHangupCode := caExtractFHNGCode(FP);
                fState := rfAbort;
              end;
            end;
          end else if CheckForString(cEtxIndex, C, #16#3) then begin
            {An HDLC frame, process it now}
            Res := caProcessFrame(FP, Retrain, cLastFrame);

            {Abort if we got a DCN frame}
            if Res = ecCancelRequested then
              if fState <> rf1WaitDCN then begin
                afReportError(FP, Res);
                fState := rfAbort;
                CheckResponse := True;
              end else
                aFaxError := ecOK;

            {If this is a retrain request change the current state}
            if Retrain then begin
              DelayMS(ExtraCommandDelay);
              caPutFrameR(FP);
              fState := rf1CollectFrames;
            end;
          end;
        end;
      end;
    end;

    function OpenIncomingFile : Boolean;
    begin
      with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
        OpenIncomingFile := False;
        aCurrPage := 1;
        FillChar(cFaxHeader, SizeOf(cFaxHeader), 0);
        Move(DefAPFSig, cFaxHeader, SizeOf(DefAPFSig));
        cFaxHeader.FDateTime := GetPackedDateTime;
        cFaxHeader.SenderID  := PadCh(aRemoteID, ' ', 20);
        cFaxHeader.PageCount := 0;
        cFaxHeader.PageOfs   := SizeOf(cFaxHeader);
        afFaxName(FP);
        Assign(cInFile, string(aFaxFileName));
        Rewrite(cInFile, 1);
        aFaxError := -IOResult;
        if aFaxError = ecOK then begin
          BlockWrite(cInFile, cFaxHeader, SizeOf(cFaxHeader));
          aFaxError := -IOResult;
          if aFaxError <> 0 then
            Exit;
        end else
          Exit;
        OpenIncomingFile := True;
      end;
    end;

    function WritePage : Integer;
      {-Commit the received page}
    begin
      with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
        {Write received page, but only if we have incremented our page count}
        if aCurrPage > cFaxHeader.PageCount then                         {!!.04}
          Inc(cFaxHeader.PageCount);
        Result := crUpdateMainHeader(FP);
        if Result = ecOK then begin
          cPageHeader.ImgLength := aDataCount;
          Result := crUpdatePageHeader(FP, aCurrPage, cPageHeader);
        end;
     end;
    end;

    procedure ForceHangup;
    begin
      with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
        caFlushModem(FP);
        DelayMS(AbortDelay);
        aPort.PutString('+++');
        DelayMS(AbortDelay);
        caPutModem(FP, 'ATH');
        DelayMS(AbortDelay);
        aPort.FlushInBuffer;
      end;
    end;
  begin
    {Get the protocol pointer from data pointer 1}
    Dispatcher := TApdBaseDispatcher(PortList[LH(lParam).H]);
    with Dispatcher do
      Dispatcher.GetDataPointer(Pointer(FP), 2);

    with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
      {Function result is always zero unless the protocol is over}

      {If it's a TriggerAvail message then force the TriggerID}
      if Msg = APW_TRIGGERAVAIL then
        TriggerID := aDataTrigger;

      {Exit immediately on triggers that aren't ours}
      if (TriggerID <> aDataTrigger) and
         (TriggerID <> aTimeoutTrigger) and
         (TriggerID <> aStatusTrigger) and
         (TriggerID <> aOutBuffFreeTrigger) and
         (TriggerID <> aOutBuffUsedTrigger) then
        Exit;

      {Exit immediately if we are currently processing an abort}
      if fState = rfAbort then
        Exit;

      {Process until we encounter a wait condition}
      Critical := False;
      repeat
        if aPort.Logging then
          aPort.AddDispatchEntry(dtFax,LogReceiveFaxState[fState],0,nil,0);
        {$IFDEF DebugFax}
        writeln(debug, 'rcv top: ', rstatestr(fstate));
        {$ENDIF}

        {Check for user abort}
        if (Msg = apw_FaxCancel) then begin
          aFaxProgress := fpCancel;
          aFaxError := ecCancelRequested;
          fState := rfAbort;
          afFaxStatus(FP, False, False);                            
        end else begin
          {Show status periodically}
          if (TriggerID = aStatusTrigger) or cForceStatus then begin
            cForceStatus := False;
            afFaxStatus(FP, False, False);
            aPort.SetTimerTrigger(aStatusTrigger, Secs2Ticks(aStatusInterval), True);

            {Exit immediately on status triggers}
            if TriggerID = aStatusTrigger then
              Exit;
          end;
        end;

        {Preprocess pending modem responses}
        case fState of
          rf1Init1,
          rf2Init1,
          rf2Init1A,
          rf2Init1B,                                                 
          rf2Init2,
          rf2Init3,
          rfWaiting,
          rf1SendCSI,
          rf1SendDIS,
          rf1CollectFrames,
          rf1StartTrain,
          rf1Retrain,
          rf1FinishTrain,
          rf1SendCFR,
          rf1WaitPageConnect,
          rf1FinishPage,
          rf1WaitEOP,
          rf1SendMCF,
          rf1WaitDCN,
          rf1WaitHangup,
          rf2GetConnect,
          rf2ValidConnect,
          rf2GetSenderID,
          rf2GetPageResult,
          rf2GetFHNG :
            begin
              if aPort.Logging then
                aPort.AddDispatchEntry(dtFax,LogReceiveFaxState[fState],0,nil,0);
              {$IFDEF DebugFax}
              writeln(debug, 'rcv preprocess: ', rstatestr(fstate));
              {$ENDIF}
              {Preprocess these states, check for responses and HDLC frames}
              if TriggerID = aDataTrigger then begin
                {Data is available, check responses and HDLC frames}
                if not CheckResponse then begin

                  {Data not available yet but we're in a critical state, don't
                   exit state machine but check for more data or timeout.}
                  if Critical then begin
                    if TimerExpired(cReplyTimer) then begin
                      Critical := False;
                      afReportError(FP, ecTimeout);
                      fState := rfAbort;
                    end else begin
                      aPort.ProcessCommunications;
                      Continue;
                    end;
                  end else
                    {Not critical, no response yet, just exit}
                    Exit;
                end;
              end;

              {Check for timeouts}
              if (TriggerID <> aDataTrigger) or
                 (Critical and TimerExpired(cReplyTimer)) then begin
                case fState of
                  rf1WaitDCN :
                    {Exit normally if the DCN never comes}
                    fState := rfComplete;
                  rf1CollectFrames :
                    {Retry on collectframes timeouts}
                    fState := rf1CollectRetry1;
                  rf1CollectRetry1 :
                    {Ignore timeout after AT<cr>}
                    fState := rf1CollectRetry2;
                  rf1SendCSI :
                    {If retry in progress, then retry here as well}
                    if cRetry <> 0 then
                      fState := rf1CollectRetry1
                    else begin
                      afReportError(FP, ecTimeout);
                      fState := rfAbort;
                    end;
                  else begin
                    afReportError(FP, ecTimeout);
                    fState := rfAbort;
                  end;
                end;
              end;
          end;
        end;

        {Main state machine}
        case fState of
          rfInit :
            begin
              cCurrOfs := 0;
              fLast := #255;
              cResponse := '';
              fPageStatus := rpsNewDocument;
              aCurrPage := 0;
              cRingCounter := 0;
              aDataCount := 0;
              cInFileName := '';
              aRemoteID := '';
              aPhoneNum := '';
              aFaxFileName := '';
              aRetryCnt := 0;
              cLastPageOk := False;
              fRenegotiate := False;
              cRetry := 0;                                               {!!.05}

              {Constant status}
              if fConstantStatus and not fShowStatus then begin
                fShowStatus := True;
                afFaxStatus(FP, True, False);
              end;

              {Make sure flow control is off}
              if FlagIsSet(afFlags, afSoftwareFlow) then
                aPort.SWFlowDisable;

              {Make sure modem lines are up}
              aPort.SetModem(True, True);

              {Set the fax class}
              if aClassInUse = ctClass1 then begin
                fState := rf1Init1;
                caPutModem(FP, cClassCmd);                               {!!.06}
              end else begin
                fState := rf2Init1;
                caPutModem(FP, cClassCmd);
              end;

              aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
            end;

          rf1Init1 :
            begin                                                        {!!.04}
              if caStripRing(FP)then                                     {!!.04}
                if caOkResponse(FP) then begin
                  caSwitchBaud(FP, True);
                  aPort.SetTimerTrigger(aTimeoutTrigger, 0, False);
                  if aUsingTapi then                                     {!!.04}
                    { we don't want to wait for a ring, }
                    { TAPI has already waited for us }
                    fState := rfAnswer                                   {!!.04}
                  else                                                   {!!.04}
                    fState := rfWaiting;

                  aFaxProgress := fpWaiting;
                end else begin
                  afReportError(FP, ecFaxInitError);
                  fState := rfAbort;
                end;
            end;                                                         {!!.04}

          rf2Init1 :
            begin                                                        {!!.04}
              if caStripRing(FP) then                                    {!!.04}
                if caOkResponse(FP) then begin
                  caSwitchBaud(FP, True);
                  caPutModem(FP, cDCCCmd+'=1,'+caSpeedCode(FP)+',0,2,0,'+
                                 cCheckChar+',0,0');

                  if (aClassInUse = ctClass2_0) then
                    fState := rf2Init1A
                  else
                    fState := rf2Init3;
                end else begin
                  afReportError(FP, ecFaxInitError);
                  fState := rfAbort;
                end;
            end;                                                         {!!.04}

          rf2Init1A :
            begin                                                        {!!.04}
              if caStripRing(FP) then                                    {!!.04}
                if caOkResponse(FP) then begin
                  caPutModem(FP, 'AT+FLO=2');
                  fState := rf2Init1B;
                end else begin
                  afReportError(FP, ecFaxInitError);
                  fState := rfAbort;
                end;
            end;                                                         {!!.04}

          rf2Init1B :
            begin                                                        {!!.04}
              if caStripRing(FP) then                                    {!!.04}
                if caOkResponse(FP) then begin
                  caPutModem(FP, 'AT+FNR=1,1,1,0');
                  fState := rf2Init3;
                end else begin
                  afReportError(FP, ecFaxInitError);
                  fState := rfAbort;
                end;
            end;                                                         {!!.04}

          rf2Init3 :
            begin                                                        {!!.04}
              if caStripRing(FP) then                                    {!!.04}
                if caOkResponse(FP) then begin
                  if aUsingTapi then                                     {!!.04}
                    { we don't want to wait for a ring, }
                    { TAPI has already waited for us }
                    fState := rfAnswer                                   {!!.04}
                  else                                                   {!!.04}
                    fState := rfWaiting;
                  aPort.SetTimerTrigger(aTimeoutTrigger, 0, False);
                  aFaxProgress := fpWaiting;
                end else begin
                  afReportError(FP, ecFaxInitError);
                  fState := rfAbort;
                end;
            end;                                                         {!!.04}

          rfWaiting :
            if caRingResponse(FP) then begin                             {!!.04}
              Inc(cRingCounter);
              if cRingCounter >= cAnswerOnRing then begin
                fPageStatus := rpsNewDocument;
                fState := rfAnswer;

                {Show the first status here}
                if not fShowStatus then begin
                  fShowStatus := True;
                  afFaxStatus(FP, True, False);
                end;

                aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
              end else
                caPrepResponse(FP);
            end else if (Pos('NO C', cResponse) > 0) then begin
              {Report connection failure, stay in this state}
              aFaxProgress := fpNoConnect;
              cForceStatus := True;
            end else if caConnectResponse(FP) then begin
              {Modem is receiving a data call}
              afReportError(FP, ecFaxDataCall);
              fState := rfAbort;
              end else if (Pos('VOICE', cResponse) > 0) or
                (Pos('VCON', cResponse) > 0) then begin
              {Modem is receiving a voice call}
              afReportError(FP, ecFaxVoiceCall);
              fState := rfAbort;
            end else
              caPrepResponse(FP);

          rfAnswer :
            begin
              fPageStatus := rpsNewDocument;                             {!!.04}
              if not fShowStatus then begin
                fShowStatus := True;
                afFaxStatus(FP, True, False);
              end;

              caPutModem(FP, 'ATA');
              aPort.SetTimerTrigger(aTimeoutTrigger, cDialWait, True);
              NewTimer(cReplyTimer, cDialWait);
              aFaxProgress := fpAnswer;
              cForceStatus := True;
              if aClassInUse = ctClass1 then begin
                fState := rf1SendCSI;
                Critical := fSafeMode;
              end else
                fState := rf2ValidConnect;
            end;

          rf1SendCSI :
            if caConnectResponse(FP) then begin
              caPutCSIFrame(FP);
              fState := rf1SendDIS;
              caPrepResponse(FP);
            end else
              caPrepResponse(FP);

          rf1SendDIS :
            if caConnectResponse(FP) then begin
              caPutDCSDISFrame(FP, True);
              caPrepResponse(FP);
            end else if caOkResponse(FP) then begin
              DelayMS(ExtraCommandDelay);
              DelayMS(200);
              caPutFrameR(FP);
              aPort.SetTimerTrigger(aTimeoutTrigger, Class1Wait, True);
              fState := rf1CollectFrames;
            end else
              caPrepResponse(FP);

          rf1CollectFrames :
            if caConnectResponse(FP) then
              caPrepResponse(FP)
            else if caOkResponse(FP) then begin
              if cLastFrame then begin
                {Turn on flow control first to avoid setcommstate bug}
                if FlagIsSet(afFlags, afSoftwareFlow) then
                  aPort.SWFlowEnable(
                                DispatchBufferSize-(DispatchBufferSize shr 2),
                                DispatchBufferSize shr 2,
                                sfReceiveFlow);


                caPutFaxCommand(FP, 'AT+FRM='+cModCode);
                fState := rf1StartTrain;
                NewTimer(cReplyTimer, cReplyWait);
                cRetry := 0;
              end else begin
                {Ask for next frame}

                caPutFrameR(FP);
                cRetry := 0;
              end;
            end else
              caPrepResponse(FP);

          rf1CollectRetry1 :
            begin
              Inc(cRetry);
              if cRetry <= 3 then begin
                {Failed to get any frames, first get modem's attention}
                caPutModem(FP, 'AT'+cCR);
                fState := rf1CollectRetry2;
              end else begin
                {Too many errors, bail out}
                { changed ErrorCode, ecTimeout was too ambiguous }
                afReportError(FP, ecFaxNoCarrier{ecTimeout});            {!!.04}
                fState := rfAbort;
              end;
            end;

          rf1CollectRetry2 :
            begin
              caPutFrameT(FP);
              fState := rf1SendCSI;
            end;

          rf1StartTrain :
            if caConnectResponse(FP) then begin
              fState := rf1CollectTrain;
              aDataCount := 0;
              cBadData := 0;
              NewTimer(cReplyTimer, cReplyWait);{182 ticks}
            end else
              caPrepResponse(FP);

          rf1CollectTrain :
            if TriggerID = aDataTrigger then begin
              {Let dispatcher check for incoming data...}
              {aPort.ProcessCommunications;}                             {!!.04}
              while aPort.CharReady and
                    not TimerExpired(cReplyTimer) do begin
                {...and keep checking until no data is available}
                aPort.GetChar(C);
                Inc(aDataCount);
                if C <> #0 then
                  Inc(cBadData);
                if (C = cDLE) or (cResponse = cDLE) then begin           {!!.04}
                  {in case the cETX isn't in the same readcom, set this flag}
                  {and catch it the next round}
                  cResponse := cDLE;                                     {!!.04}
                  if C = cETX then begin
                    {Calculate amount of valid training data}
                    PercentBad := (cBadData * Integer(100)) div aDataCount;
                    if PercentBad < MaxBadPercent then begin
                      fState := rf1FinishTrain;
                      caPrepResponse(FP);
                      {Don't process any more characters in this state}
                      Break;
                    end else begin
                      {Failed to train, prepare to send FTT}
                      caPutFrameT(FP);
                      fState := rf1Retrain;
                    end;
                  end;
                end;
              end;

              {Abort if time expires before all training data is received}
              if TimerExpired(cReplyTimer) then begin
                fState := rfAbort;
                Critical := False;
              end;

            end else begin
              {aPort.ProcessCommunications;}                             {!!.04}
              if TimerExpired(cReplyTimer) then begin
                {Just in case...}
                fState := rfAbort;
                Critical := False;
              end;
            end;

          rf1Retrain :
            if caConnectResponse(FP) then begin
              caPutStandardFrame(FP, FTTFrame, True);
              if cModCode <> '24' then begin
                {Step down and try again}
                caPrepResponse(FP);
                {Stay in this state to wait for OK}
              end else begin
                {Fatal error, couldn't train at any baud rate}
                afReportError(FP, ecFaxTrainError);
                {Don't bother waiting for OK}
                fState := rfAbort;
              end;
            end else if caOkResponse(FP) then begin
              {Expect DCS again}
              caPutFrameR(FP);
              fState := rf1CollectFrames;
            end else
              caPrepResponse(FP);

          rf1FinishTrain :
            if caNoCarrierResponse(FP) then begin

              {Turn off flow control for HDLC frames}
              if FlagIsSet(afFlags, afSoftwareFlow) then
                aPort.SWFlowDisable;

              DelayMS(20);
              caPutFrameT(FP);
              fState := rf1SendCFR;
            end else
              caPrepResponse(FP);

          rf1SendCFR :
            if caConnectResponse(FP) then begin
              {Finished with Phase B, turn on flow control}
              if FlagIsSet(afFlags, afSoftwareFlow) then
                aPort.SWFlowEnable(
                              DispatchBufferSize-(DispatchBufferSize shr 2),
                              DispatchBufferSize shr 2,
                              sfReceiveFlow);

              caPutStandardFrame(FP, CFRFrame, True);               
              caPrepResponse(FP);

            end else if caOkResponse(FP) then begin
              Critical := False;
              caPutFaxCommand(FP, 'AT+FRM='+StModArray[cBpsIndex]);
              fState := rf1WaitPageConnect;

              {Not critical anymore, here's our chance to accept and log}
              if not afAcceptFax(FP, aRemoteID) then begin
                afReportError(FP, ecFileRejected);
                ForceHangup;
                cForceStatus := True;
                afLogFax(FP, lfaxReceiveSkip);
                fState := rfAbort;
              end else begin
                {File accepted, open file and log it}
                {Don't do this if this is a retrain}
                if (fPageStatus = rpsNewDocument) then begin        
                  if OpenIncomingFile then begin
                    {Log receive started}
                    afLogFax(FP, lfaxReceiveStart);
                    fPageStatus := rpsNewPage;
                    aCurrPage := 0;
                  end else begin
                    afReportError(FP, aFaxError);
                    fState := rfAbort;
                    goto ExitPoint;
                  end;
                end;                                                
              end;
            end else
              caPrepResponse(FP);

          rf1WaitPageConnect :
            if caConnectResponse(FP) then begin
              fState := rfStartPage;
              aFaxProgress := fpSessionParams;
              cForceStatus := True
            end else
              caPrepResponse(FP);

          rf2ValidConnect :
            if Pos(cFaxResp, cResponse) > 0 then begin
              aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
              aFaxProgress := fpIncoming;
              fState := rf2GetSenderID;
              Critical := fSafeMode;
            end else
              caPrepResponse(FP);

          rf2GetSenderID :
            if Pos(cTSIResp, cResponse) > 0 then begin
              aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
              StripPrefix(cResponse);
              aRemoteID := TrimStationID(cResponse);

              {Let user accept or reject this fax}
              if not afAcceptFax(FP, aRemoteID) then begin
                aPort.PutString('AT+FKS'^M);
                afReportError(FP, ecFileRejected);
                ForceHangup;
                cForceStatus := True;
                afLogFax(FP, lfaxReceiveSkip);
                fState := rfAbort;
              end else begin
                {File accepted, keep going}
                aFaxProgress := fpGotRemoteID;
                cForceStatus := True;

                {Open incoming file and log now}
                {Don't do this if this is a retrain}
                if fPageStatus = rpsNewDocument then begin         
                  if OpenIncomingFile then begin
                    {Log receive started}
                    afLogFax(FP, lfaxReceiveStart);
                    fPageStatus := rpsNewPage;
                    aCurrPage := 0;
                  end else begin
                    afReportError(FP, aFaxError);
                    fState := rfAbort;
                    goto ExitPoint;
                  end;
                end;                                               
              end;
            end else if Pos(cDCSResp, cResponse) > 0 then begin
              aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
              StripPrefix(cResponse);
              caExtractClass2Params(FP, cResponse);
              aFaxProgress := fpSessionParams;
              cForceStatus := True;
            end else if caOkResponse(FP) then begin
              Critical := False;
              caPutModem(FP, 'AT+FDR');
              cForceStatus := True;
              fState := rf2GetConnect;
              aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
            end else
              caPrepResponse(FP);

          rf2GetConnect :
            if Pos(cDCSResp, cResponse) > 0 then begin
              {Got current session parameters}
              aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
              StripPrefix(cResponse);
              caExtractClass2Params(FP, cResponse);
              aFaxProgress := fpSessionParams;
              cForceStatus := True;
            end else if caConnectResponse(FP) then begin
              {Finished with Phase B, turn on flow control}
              if FlagIsSet(afFlags, afSoftwareFlow) then
                aPort.SWFlowEnable(
                              DispatchBufferSize-(DispatchBufferSize shr 2),
                              DispatchBufferSize shr 2,
                              sfReceiveFlow);
              fState := rfStartPage;
              Critical := fSafeMode;
            end else
              caPrepResponse(FP);

          rfStartPage :
            begin
              Critical := False;
              Inc(aCurrPage);

              {Start or continue fax file}
              case fPageStatus of
                rpsNewPage:
                  begin
                    FillChar(cPageHeader, SizeOf(cPageHeader), 0);
                    if cSessionRes then
                      cPageHeader.ImgFlags :=
                        cPageHeader.ImgFlags or ffHighRes;
                    if cSessionWid then
                      cPageHeader.ImgFlags :=
                        cPageHeader.ImgFlags or ffHighWidth;

                    BlockWrite(cInFile, cPageHeader, SizeOf(cPageHeader));
                    aFaxError := -IoResult;                         
                    if aFaxError <> ecOK then begin
                      afReportError(FP, aFaxError);
                      fState := rfAbort;
                      goto ExitPoint;
                    end;
                  end;
                rpsNewDocument:
                  begin
                    Close(cInFile);
                    if IOResult = 0 then ;
                    if OpenIncomingFile then begin
                      {Log receive started}
                      afLogFax(FP, lfaxReceiveStart);

                      FillChar(cPageHeader, SizeOf(cPageHeader), 0);
                      if cSessionRes then
                        cPageHeader.ImgFlags :=
                          cPageHeader.ImgFlags or ffHighRes;

                      if cSessionWid then
                        cPageHeader.ImgFlags :=
                          cPageHeader.ImgFlags or ffHighWidth;

                      BlockWrite(cInFile, cPageHeader, SizeOf(cPageHeader));
                      aFaxError := -IOResult;                      
                      if aFaxError <> ecOK then begin
                        afReportError(FP, aFaxError);
                        fState := rfAbort;
                        goto ExitPoint;
                      end;
                    end else begin
                      afReportError(FP, aFaxError);
                      fState := rfAbort;
                      goto ExitPoint;
                    end;
                  end;
              end;

              {Init vars for receiving a new page}
              cCurrOfs := 0;
              fLast := #255;
              aPort.SetTimerTrigger(aTimeoutTrigger, cReplyWait, True);
              aDataCount := 0;

              {Say we're ready to receive fax data}
              if (aClassInUse = ctClass2) or (aClassInUse = ctClass2_0) then
                aPort.PutChar(cDC2);

              {Set next state and show new status}
              fState := rfGetPageData;
              aFaxProgress := fpGetPage;
              cForceStatus := True;
            end;

          rfGetPageData :
            if crAddReceivedData(FP) then begin
              if aFaxError = ecOk then begin
                {Normal end of page}
                fLast := #255;
                aFaxProgress := fpGetPage;
                cForceStatus := True;
                caPrepResponse(FP);

                {Finished with Phase C, turn off flow control}
                if FlagIsSet(afFlags, afSoftwareFlow) then
                  aPort.SWFlowDisable;

                if aClassInUse = ctClass1 then
                  fState := rf1FinishPage
                else begin
                  fState := rf2GetPageResult;
                  Critical := fSafeMode;
                end;
              end else begin
                {Error writing page}
                fState := rfAbort;
                cForceStatus := True;
              end;
            end;

          rf1FinishPage :
            if caNoCarrierResponse(FP) then begin
              caPutFrameR(FP);
              fState := rf1WaitEOP;
              Critical := fSafeMode;
            end else
              caPrepResponse(FP);

          rf1WaitEOP :
            if caConnectResponse(FP) then
              caPrepResponse(FP)
            else if caOkResponse(FP) then begin
              if cLastFrame then begin
                cLastFrame := False;
                cMorePages := (cReceivedFrame and $FE = MPSFrame) or
                              (cReceivedFrame and $FE = EOMFrame);
                fRenegotiate := cReceivedFrame and $FE = EOMFrame;  
                fState := rf1WritePage;
                aFaxProgress := fpGetPageResult;
                cLastPageOk := True;
                cForceStatus := True;
              end else
                {Ask for another frame}
                caPutFrameR(FP);
            end else
              caPrepResponse(FP);

          rf1WritePage :
            begin
              {Write received page}
              Res := WritePage;
              if Res <> ecOk then begin
                fState := rfAbort;
                goto ExitPoint;
              end;

              {Prepare to send MCF}
              caPutFrameT(FP);
              fState := rf1SendMCF;

              aFaxProgress := fpCheckMorePages;
              cLastPageOk := True;
              cForceStatus := True;
            end;

          rf1SendMCF :
            if caConnectResponse(FP) then begin
              if fRenegotiate and cMorePages then begin
                {Transmitter is switching to phase B}
                caPutStandardFrame(FP, MCFFrame, False);
                fState := rf1SendCSI;

              end else
                {Transmitter is staying in phase C}
                caPutStandardFrame(FP, MCFFrame, True);             
              caPrepResponse(FP);
            end else if caOkResponse(FP) then begin
              Critical := False;

              {Get more pages or done}
              if cMorePages then begin
                {Prepare to receive another page}
                if fRenegotiate then begin
                  {Transmitter is switching to phase B}
                  DelayMS(ExtraCommandDelay);
                  caPutFrameT(FP);
                  fState := rf1SendCSI;
                end else begin
                  {Transmitter is staying in phase C}              
                  caPutFaxCommand(FP, 'AT+FRM='+cModCode);
                  fPageStatus := rpsNewPage;
                  fState := rfStartPage;
                end;                                                
              end else begin
                {Ask for DCN}
                DelayMS(ExtraCommandDelay);
                caPutFrameR(FP);
                fState := rf1WaitDCN;

                {No more pages, close and log this fax}
                Close(cInFile);
                if IOResult = 0 then ;
                afLogFax(FP, lfaxReceiveOK);
                {aFaxFileName := '';}                                    {!!.04}

                aFaxProgress := fpGetHangup;
                cForceStatus := True;
              end;
            end else
              caPrepResponse(FP);

          rf1WaitDCN :
            if caConnectResponse(FP) then
              caPrepResponse(FP)
            else if caOkResponse(FP) then begin
              if cLastFrame then begin
                {Hang up}
                caPutModem(FP, 'ATH');
                fState := rf1WaitHangup;
              end else
                caPutFrameR(FP);
            end else
              caPrepResponse(FP);

          rf1WaitHangup :
            if caOkResponse(FP) then begin
              aFaxProgress := fpGotHangup;
              cForceStatus := True;
              fState := rfComplete;
            end else
              caPrepResponse(FP);

          rf2GetPageResult :
            if Pos(cPageResp, cResponse) > 0 then begin
              aFaxProgress := fpGetPageResult;
              cForceStatus := True;
              StripPrefix(cResponse);
              case cResponse[1] of
                '1','3','5':  {page good}
                  begin
                    cLastPageOk := True;
                    aFaxError := WritePage;
                    if aFaxError <> ecOk then begin
                      afReportError(FP, aFaxError);
                      fState := rfAbort;
                      goto ExitPoint;
                    end;
                  end;
                else  {page bad, discard}
                  begin
                    cLastPageOk := False;
                    if caLocatePage(FP, aCurrPage) <> 0 then
                      fState := rfAbort
                    else begin
                      Truncate(cInFile);
                      aFaxError := -IOResult;                       
                      if aFaxError <> ecOK then begin
                        afReportError(FP, aFaxError);
                        fState := rfAbort;
                        goto ExitPoint;
                      end;
                    end;
                  end;
              end;
            end else if Pos('+FET', cResponse) > 0 then begin
              aFaxProgress := fpCheckMorePages;
              cForceStatus := True;
              StripPrefix(cResponse);
              case cResponse[1] of
                '0':  fPageStatus := rpsNewPage;
                '1':  fPageStatus := rpsNewDocument;
                '2':  fPageStatus := rpsEndOfDocument;
                '3':  fPageStatus := rpsMoreSame;
                else  fPageStatus := rpsBadPage;
              end;
            end else if caOkResponse(FP) then begin
              Critical := False;
              caPutModem(FP, 'AT+FDR');
              if fPageStatus = rpsEndOfDocument then begin
                {Close and log receive OK}
                Close(cInFile);
                if IOResult = 0 then ;
                afLogFax(FP, lfaxReceiveOK);
                {aFaxFileName := '';}                                    {!!.04}
                fState := rf2GetFHNG;
                aFaxProgress := fpGetHangup;
                cForceStatus := True;
              end else
                fState := rf2GetConnect;
            end else if caErrorResponse(FP) then begin
              {Class 2.0 page error}
              cLastPageOk := False;
              if caLocatePage(FP, aCurrPage) <> 0 then
                {Error seeking to old page, abort}
                fState := rfAbort
              else begin
                Truncate(cInFile);
                aFaxError := -IOResult;                            
                if aFaxError <> ecOK then begin
                  {Error truncating file, abort}
                  afReportError(FP, aFaxError);
                  fState := rfAbort;
                  goto ExitPoint;
                end else begin
                  {Request this page fax page again}
                  Critical := False;
                  caPutModem(FP, 'AT+FDR');
                  fState := rf2GetConnect;
                end;
              end;
            end else
              caPrepResponse(FP);

          rf2GetFHNG :
            if caFHNGResponse(FP) then begin
              cHangupCode := caExtractFHNGCode(FP);
              aFaxProgress := fpGotHangup;
              cForceStatus := True;
              cResponse := '';
            end else if Pos('+FET', cResponse) > 0 then begin
              {Allow redundant FET}
              aFaxProgress := fpGetHangup;
              cForceStatus := True;
              cResponse := '';
            end else if caOkResponse(FP) then
              fState := rfComplete
            else
              caPrepResponse(FP);

          rfAbort :
            begin
              Critical := False;
              {Log receive failed}
              if aFaxFileName <> '' then begin
                if WritePage <> 0 then ;
                Close(cInFile);
                if IoResult <> 0 then ;
                afLogFax(FP, lfaxReceiveFail);
              end;

              {Try to hangup modem}
              ForceHangup;

              {Finished with status?}
              if (fShowStatus and not fConstantStatus) or
                 (Msg = APW_FAXCANCEL) then begin
                afFaxStatus(FP, False, True);
                fShowStatus := False;
              end;

              {Exit on errors or stay?}
              if FlagIsSet(afFlags, afExitOnError) or
                 (Msg = APW_FAXCANCEL) or (aUsingTapi) then begin        {!!.04}
                afSignalFinish(FP);
                cInitSent := False;
                fState := rfDone;
              end else
                fState := rfInit;
            end;

          rfComplete :
            begin
              caSwitchBaud(FP, False);

              {Finished or go look for more faxes?}
              if fOneFax or aUsingTapi then begin                        {!!.04}
                {Finished, exit}
                afSignalFinish(FP);
                cInitSent := False;
                fState := rfDone;
                {Finished with status?}
                if (fShowStatus and not fConstantStatus) or
                   (Msg = APW_FAXCANCEL) then begin
                  afFaxStatus(FP, False, True);
                  fShowStatus := False;
                end;
              end else begin
                {Keep going, but see if we should get rid of status}
                if not fConstantStatus then begin
                  afFaxStatus(FP, False, True);
                  fShowStatus := False;
                end;
                fState := rfInit;
              end;
            end;
        end;

ExitPoint:
        if Critical then begin
          {State machine is critical, stay here}
          Finished := False;
          TriggerID := aDataTrigger;
        end else
          {Should we stay or exit?}
          case fState of
            {Stay}
            rfInit,
            rfAnswer,
            rfStartPage,
            rf1WritePage,                                         
            rfComplete,
            rfAbort          :  Finished := False;

            {Conditional exit}
            rf1Init1,
            rf2Init1,
            rf2Init1A,
            rf2Init1B,
            rf2Init2,
            rf2Init3,
            rfWaiting,
            rf1SendCSI,
            rf1SendDIS,
            rf1CollectFrames,
            rf1StartTrain,
            rf1Retrain,
            rf1FinishTrain,
            rf1SendCFR,
            rf1WaitPageConnect,
            rf1FinishPage,
            rf1WaitEOP,
            rf1SendMCF,
            rf1WaitDCN,
            rf1WaitHangup,
            rf2GetConnect,
            rf2ValidConnect,
            rf2GetSenderID,
            rf2GetPageResult,
            rfGetPageData,
            rf2GetFHNG      : Finished := not aPort.CharReady;

            {Exit}
            rf1CollectRetry1,
            rf1CollectRetry2,
            rf1CollectTrain,
            rfDone           : Finished := True;
          end;
      until Finished;
    end;
  end;

  function fPrepareFaxReceive(FP : PFaxRec) : Integer;
    {-Prepare a fax receive session}
  var
    WasBusy  : Boolean;
    Dummy    : Boolean;

    procedure Cleanup;
    begin
      with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
        FlushInQueue(FP);
        aPort.SetEventBusy(Dummy, WasBusy);
      end;
    end;

  begin
    fPrepareFaxReceive := ecOK;

    with PC12ReceiveFax(FP)^, fCData^, fPData^ do begin
      {Inits}
      fState := fFirstState;
      aFaxError := ecOK;
      aFaxProgress := 0;

      {If Class hasn't been set yet then figure out highest class}
      if (aClassInUse = ctDetect) or (aClassInUse = ctUnknown) then
        if fSetClassType(FP, ctDetect) = ctUnknown then begin
          afReportError(FP, ecFaxInitError);{ecFaxBadModemResult);}      {!!.04} 
          Exit;
        end;

      {Prepare class 2 commands}
      case aClassInUse of
        ctClass2    : fPrepCommands(FP, False);
        ctClass2_0  : fPrepCommands(FP, True);
      end;

      {Block other trigger handlers}
      aPort.SetEventBusy(WasBusy, True);

      {If not sent already, send modem and def init strings}
      if not cInitSent then begin
        {Send user init}
        if (cModemInit <> '') and
           (not caProcessModemCmd(FP, cModemInit)) then begin
          Cleanup;
          Exit;
        end;

        {Send required inits}
        if not caProcessModemCmd(FP, cForcedInit) then begin
          Cleanup;
          Exit;
        end;
        cInitSent := True;
      end;

      {Set class}
      if (fFirstState <> rf2GetSenderID) then
        if aClassInUse = ctClass1 then begin
          if not caProcessModemCmd(FP, cClassCmd) then begin             {!!.06}
            Cleanup;
            Exit;
          end;
          caSwitchBaud(FP, True);
        end else begin
          if not caProcessModemCmd(FP, cClassCmd) then begin
            Cleanup;
            Exit;
          end;
          caSwitchBaud(FP, True);
          if not caProcessModemCmd(FP, 'AT+FCR=1') then begin
            Cleanup;
            Exit;
          end;
          if not caProcessModemCmd(FP, cStationCmd+'="'+aStationID+'"') then begin
            Cleanup;
            Exit;
          end;
          if not caProcessModemCmd(FP, ShortString('AT+FAA=') + cFaxAndData) then begin
            Cleanup;
            Exit;
          end;
        end;

      {Get class1 get modulation capabilities}
      if aClassInUse = ctClass1 then begin
        caGetClass1Modulations(FP, False);

        {Set highest BPSIndex from MaxFaxBPS and local modulation capabilities}
        Inc(cBPSIndex);
        repeat
          Dec(cBPSIndex)
        until Class1BPSArray[cBPSIndex] <= cMaxFaxBPS;
      end;

      {Say we're in progress}
      aInProgress := True;

      Cleanup;
    end;
  end;

{$IFDEF DebugFax}

  procedure FinalizeFax; far;
  begin
    Close(Debug);
  end;

initialization
  Assign(Debug, 'debug.txt');
  Rewrite(Debug);

finalization
  FinalizeFax;
{$ENDIF DebugFax}
end.

