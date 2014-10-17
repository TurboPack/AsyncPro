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
{*                   AWABSFAX.PAS 4.06                   *}
{*********************************************************}
{* Abstract fax                                          *}
{*********************************************************}  

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$A+,V-,I-,B-,F+,X+,Q-,N+}

unit AwAbsFax;
  {-Abstract data and routines for Class I/II fax}

interface

uses
  Windows,
  Messages,
  SysUtils,
  {----------APW}
  AdExcept,                                                         
  OoMisc,
  AwUser;

type
  {Fax notification function}
  TFaxFunc = procedure(
                      Msg, wParam : Cardinal;
                      lParam : LongInt);

  {Abstract fax data}
  PFaxData = ^TFaxData;
  TFaxData = record
    aStatusTrigger      : Integer;     {Status timer trigger handle}
    aTimeoutTrigger     : Integer;     {Timeout timer trigger handle}
    aOutBuffFreeTrigger : Integer;     {Outbuffree status trigger handle}
    aOutBuffUsedTrigger : Integer;     {Outbuffused status trigger handle}
    {aNoCarrierTrigger   : Integer;}   {No carrier status trigger handle}{!!.02}
    aStatusInterval     : Integer;     {Ticks between status updates}
    aHWindow            : HWnd;        {Window associated with fax}
    aPort               : TApdBaseDispatcher;     {Com port object to use}
    aCurFaxFunc         : TFaxFunc;    {Routine to process fax send/receives}
    aSending            : Boolean;     {True if sending faxes}
    aSendingCover       : Boolean;     {True if sending cover page}
    aInProgress         : Boolean;     {True during fax sessions}
    aMaxConnect         : Cardinal;    {max number of connect attempts}
    aConnectCnt         : Cardinal;    {count of connect attempts}
    aRetryCnt           : Cardinal;    {Number of class 1 frame attempts}
    aRetryWait          : Cardinal;    {ticks to wait between connect attempts}
    afFlags             : Cardinal;    {fax send/receive options}
    aSaveStatus         : Cardinal;    {Temp var and save between states}
    aFaxProgress        : Cardinal;    {For storing progress codes}
    aFaxListCount       : Cardinal;    {Number of fax entries}
    aFaxError           : Integer;     {Fax error code}
    aCurrPage           : Integer;     {counter for pages}
    aPageCount          : Integer;     {total pages in document}
    aCoverCount         : Integer;     {Number of cover pages, 0 or 1}
    aDataCount          : LongInt;     {count of received "real" data bytes}
    aPageSize           : LongInt;     {size of page file in bytes}
    aFaxListHead        : PFaxEntry;   {Head of fax entry list}
    aFaxListTail        : PFaxEntry;   {Tail of fax entry list}
    aFaxListNode        : PFaxEntry;   {Current node of fax entry list}
    aClassInUse         : ClassType;   {class of device in use}
    aStationID          : Str20;       {Station ID (usually phone #)}
    aRemoteID           : Str20;       {StationID of remote}
    aStNumber           : TChar20Array;{Station ID, usually phone number}
    aDestDir            : ShortString; {destination directory}
    aFaxFileExt         : ShortString; {fax file extension}
    aFaxFileName        : ShortString; {current document being processed}
    aCoverFile          : ShortString; {cover page file if any}
    aPhoneNum           : String[40];  {phone number to dial}
    aStatusTimer        : EventTimer;  {Timer for status updates}
    aTitle              : ShortString; {Sender title}
    aRecipient          : ShortString; {Recipient's name}
    aSender             : ShortString; {Sender's name}
    aSaveMode           : Byte;        {Save FileMode}
    aSendManual         : Boolean;     {Save FaxMode}
    aConcatFax          : Boolean;     {Fax is concatenated}
    HaveTriggerHandler  : Boolean;
    aUsingTapi          : Boolean;     {True if we're integrated with TAPI}{!!.04}
  end;

  TFaxRec = record
    aPData : PFaxData;             {Pointer to fax data}
  end;

  PFaxRec = ^TFaxRec;

  {Prepare procedure}
  TFaxPrepProc = function(P : PFaxRec) : Integer;

  {Various hook types}
  FaxStatusProc = procedure (FP : PFaxRec;
                             Starting, Ending : Boolean);
  NextFaxFunc = function(FP : PFaxRec;
                         var Number : ShortString;
                         var FName : ShortString;
                         var Cover : ShortString) : Boolean;
  FaxLogProc = procedure(FP : PFaxRec; Log : TFaxLogCode);               {!!.04}
  FaxNameFunc = function (FP : PFaxRec) : ShortString;
  AcceptFaxFunc = function(FP : PFaxRec;
                           RemoteName : Str20) : Boolean;

{FaxData init/destroy routines}
function afInitFaxData(var PData : PFaxData; ID : Str20;
                       ComPort : TApdBaseDispatcher; Window : TApdHwnd) : Integer;

function afDoneFaxData(var PData : PFaxData) : Integer;


{Option management}
procedure afOptionsOn(FP : PFaxRec; OptionFlags : Word);

  {-Activate multiple options}
procedure afOptionsOff(FP : PFaxRec; OptionFlags : Word);

  {-Deactivate multiple options}
function afOptionsAreOn(FP : PFaxRec; OptionFlags : Word) : Boolean;

  {-Return True if all specified options are on}

{User control}
procedure afSetTitle(FP : PFaxRec; NewTitle : ShortString);

  {-Set title of sender (used in header line)}
procedure afSetRecipientName(FP : PFaxRec; NewName : ShortString);

  {-Set name of recipient}
procedure afSetSenderName(FP : PFaxRec; NewName : ShortString);

  {-Set name of sender}
procedure afSetDestinationDir(FP : PFaxRec; Dest : ShortString);

  {-Set a destination directory for received files}
procedure afSetStationID(FP : PFaxRec; NewID : Str20);

  {-Assign our station ID}
procedure afSetConnectAttempts(FP : PFaxRec; Attempts : Word;
                               DelayTicks : Word);

  {-Set number of connect attempts per fax, 0 = infinite}
procedure afSetNextFax(FP : PFaxRec;
                       Number : ShortString;
                       FName : ShortString;
                       Cover : ShortString);
  {-Set the next fax to transmit}

procedure afSetComHandle(FP : PFaxRec; NewHandle : TApdBaseDispatcher);
  {-Set a new comhandle to use}

procedure afSetWindow(FP : PFaxRec; NewWindow : TApdHwnd);
  {-Set a new window handle to use}

procedure afSetFaxName(FP : PFaxRec; FaxName : ShortString);
  {-Set the name of the incoming fax}


{Fax entry list stuff}
function afAddFaxEntry(FP : PFaxRec;
                       const Number : ShortString;
                       const FName : ShortString;
                       const Cover : ShortString) : Integer;

  {-Add another number to the built-in list}
procedure afClearFaxEntries(FP : PFaxRec);

  {-Remove all fax entries from builtin list}

{Status info}
function afGetFaxName(FP : PFaxRec) : ShortString;

  {-Return name of current fax and size if known}
function afGetFaxProgress(FP : PFaxRec) : Word;

  {-Return fax progress code}

procedure afReportError(FP : PFaxRec; ErrorCode : Integer);

  {-Report the error}
procedure afSignalFinish(FP : PFaxRec);

  {-Send finish message to parent window}
procedure afStartFax(FP : PFaxRec; StartProc : TFaxPrepProc; FaxFunc : TFaxFunc);

  {-Start the fax session}
procedure afStopFax(FP : PFaxRec);
  {-Stop the fax session}

function afStatusMsg(P : PAnsiChar; Status : Word) : PAnsiChar;
  {-Return an appropriate error message from the stringtable}


{Private functions}
function afConvertHeaderString(FP : PFaxRec; S : ShortString) : ShortString;
  {-Compress a fax header string, converting tags to appropriate values}


{Hooks, private}
procedure afFaxStatus(FP : PFaxRec; Starting, Ending : Boolean);

function afNextFax(FP : PFaxRec) : Boolean;

procedure afLogFax(FP : PFaxRec; Log : TFaxLogCode);                     {!!.04}

procedure afFaxName(FP : PFaxRec);

function afAcceptFax(FP : PFaxRec; RemoteName : Str20) : Boolean;


{Builtin functions}
function afNextFaxList(FP : PFaxRec;
                       var Number : ShortString;
                       var FName : ShortString;
                       var Cover : ShortString) : Boolean;

  {-Returns next fax name/number in builtin list}
function afFaxNameMD(FP : PFaxRec) : ShortString;

  {-Returns name for incoming fax}
function afFaxNameCount(FP : PFaxRec) : ShortString;

  {-Returns name for incoming fax}

{Private data types}
type
  {End-of-page status}
  ReceivePageStatus = (
    rpsBadPage,
    rpsMoreSame,
    rpsNewPage,
    rpsNewDocument,
    rpsEndOfDocument);

  {Send machine states}
  SendStates = (
    tfNone,

    {Setup, both classes}
    tfGetEntry,
    tfInit,

    {Phase A, Class 1}
    tf1Init1,

    {Phase A, Class 2}
    tf2Init1,
    tf2Init1A,
    tf2Init1B,                     
    tf2Init2,
    tf2Init3,

    {Phase A, both classes}
    tfDial,
    tfRetryWait,

    {Phase B, Class 1}
    tf1Connect,
    tf1SendTSI,
    tf1TSIResponse,
    tf1DCSResponse,
    tf1TrainStart,
    tf1TrainFinish,
    tf1WaitCFR,
    tf1WaitPageConnect,

    {Phase B, Class 2}
    tf2Connect,
    tf2GetParams,

    {Phase C, both classes}
    tfWaitXon,
    tfWaitFreeHeader,
    tfSendPageHeader,
    tfOpenCover,
    tfSendCover,
    tfPrepPage,
    tfSendPage,
    tfDrainPage,

    {Phase D states for Class 1}
    tf1PageEnd,
    tf1PrepareEOP,
    tf1SendEOP,
    tf1WaitMPS,
    tf1WaitEOP,
    tf1WaitMCF,
    tf1SendDCN,
    tf1Hangup,
    tf1WaitHangup,

    {Phase D, Class 2}
    tf2SendEOP,
    tf2WaitFPTS,
    tf2WaitFET,
    tf2WaitPageOK,
    tf2SendNewParams,
    tf2NextPage,
    tf20CheckPage,

    {Phase E, both classes}
    tfClose,
    tfCompleteOK,
    tfAbort,
    tfDone);

  {Receive machine states}
  ReceiveStates = (
    rfNone,

    {Setup, both classes}
    rfInit,

    {Setup, class 1}
    rf1Init1,

    {Setup, class 2}
    rf2Init1,
    rf2Init1A,
    rf2Init1B,                     
    rf2Init2,
    rf2Init3,

    {Phase A, both classes}
    rfWaiting,
    rfAnswer,

    {Phase B, class 1}
    rf1SendCSI,
    rf1SendDIS,
    rf1CollectFrames,
    rf1CollectRetry1,
    rf1CollectRetry2,
    rf1StartTrain,
    rf1CollectTrain,
    rf1Timeout,
    rf1Retrain,
    rf1FinishTrain,
    rf1SendCFR,
    rf1WaitPageConnect,

    {Phase B, class 2}
    rf2ValidConnect,
    rf2GetSenderID,
    rf2GetConnect,

    {Phase C}
    rfStartPage,
    rfGetPageData,

    {Phase D, class 1}
    rf1FinishPage,
    rf1WaitEOP,
    rf1WritePage,
    rf1SendMCF,
    rf1WaitDCN,
    rf1WaitHangup,

    {Phase D, class 2}
    rf2GetPageResult,
    rf2GetFHNG,

    {Phase E, both classes}
    rfComplete,
    rfAbort,
    rfDone);

const
  {Bit reversed fax control fields IDs from HDLC info field}
  NSFFrame = $20;
  EOPFrame = $2E;
  CSIFrame = $40;
  TSIFrame = $42;
  FTTFrame = $44;
  RTNFrame = $4C;
  MPSFrame = $4E;
  DISFrame = $80;
  DCSFrame = $82;
  CFRFrame = $84;
  MCFFrame = $8C;
  EOMFrame = $8E;
  DCNFrame = $FA;
  RTPFrame = $CC;

  {Size of buffer for fax file data}
  DataBufferSize = 4096;

  {DIS/DCS permanent bit masks, bit reversed}
  DISGroup1   = $00;        {No group 1/2 options}
  DISGroup3_1 = $02;        {RS 465 receiver/transmitter support}
  DISGroup3_2 = $88;        {A4 width, unlimited len, extended byte}
  DISGroup3_3 = $00;        {No extended options}

  {DIS/DCS option bits for DISGroup3_1}
  DISHighResolution = $40;
  DIS2400BPS        = $00;
  DIS4800BPS        = $08;
  DIS7200BPS        = $0C;
  DIS9600BPS        = $04;
  DIS12000BPS       = $10;
  DIS14400BPS       = $20;

  {DIS/DCS option bits for DISGroup3_2}
  DISWideWidth      = $01;

  {Class 1 constants}
  AddrField = #$FF;
  ControlField = #$03;
  ControlFieldLast = #$13;

  {Variable class 2/2.0 commands}
  C2ClassCmd    = 'CLASS=2';    C20ClassCmd    = 'CLASS=2.0';
  C2ModelCmd    = 'MDL?';       C20ModelCmd    = 'MI?';
  C2MfrCmd      = 'MFR?';       C20MfrCmd      = 'MM?';
  C2RevCmd      = 'REV?';       C20RevCmd      = 'MR?';
  C2DISCmd      = 'DIS';        C20DISCmd      = 'IS';
  C2StationCmd  = 'LID';        C20StationCmd  = 'LI';
  C2DCCCmd      = 'DCC';        C20DCCCmd      = 'CC';

  {Variable class 2/2.0 responses}
  C2FaxResp     = 'CON';        C20FaxResp     = 'CO';
  C2DISResp     = 'DIS';        C20DISResp     = 'IS';
  C2DCSResp     = 'DCS';        C20DCSResp     = 'CS';
  C2TSIResp     = 'TSI';        C20TSIResp     = 'TI';
  C2CSIResp     = 'CSI';        C20CSIResp     = 'CI';
  C2PageResp    = 'PTS';        C20PageResp    = 'PS';
  C2HangResp    = 'HNG';        C20HangResp    = 'HS';

const
  {Fax constants}
  DefFaxFileExt = 'APF';                        {Default extension}

  {Misc constants}
  DosDelimSet : set of Char = ['\', ':', #0];

implementation

{General routines}

  procedure AnsiUpCheck(B : PAnsiChar; Len : Word);
  begin
    if Len <> 0 then
      AnsiUpperBuff(B, Len);
  end;

  function AddBackSlashS(DirName : ShortString) : ShortString;
    {-Add a default backslash to a directory name}
  begin
    if DirName[Length(DirName)] in DosDelimSet then
      AddBackSlashS := DirName
    else
      AddBackSlashS := DirName+'\';
  end;

{Date routines}

  function TodayString : ShortString;
    {-return today's date}
  begin
    {Get the system date}
    Result := DateToStr(SysUtils.Date);
  end;

  function NowString : ShortString;
    {-return the current time as a "HH:MMpm" string}
  begin
    Result := TimeToStr(Now);
  end;

{FaxData routines}

  function afInitFaxData(var PData : PFaxData; ID : Str20;
                         ComPort : TApdBaseDispatcher; Window : TApdHwnd) : Integer;
    {-Allocate and initialize a FaxData structure}
  begin
    PData := AllocMem(SizeOf(TFaxData));

    afInitFaxData := ecOK;

    with PData^ do begin
      aPort := ComPort;
      aHWindow := Window;
      aStationID := ID;
      aMaxConnect := DefConnectAttempts;
      afFlags := DefFaxOptions;
      aStatusInterval := DefStatusTimeout;
      aFaxFileExt := DefFaxFileExt;
    end;
  end;

  function afDoneFaxData(var PData : PFaxData) : Integer;
    {-Dispose of a FaxData record}
  var
    Node : PFaxEntry;
    Next : PFaxEntry;
  begin
    afDoneFaxData := ecOK;
    if not Assigned(PData) then
      Exit;

    with PData^ do begin
      {Dispose of faxentry list}
      if aFaxListCount <> 0 then begin
        Node := aFaxListHead;
        while Node <> nil do begin
          Next := Node^.fNext;
          FreeMem(Node, SizeOf(TFaxEntry));
          Node := Next;
        end;
      end;
    end;
    FreeMem(PData, SizeOf(TFaxData));
  end;

  procedure afOptionsOn(FP : PFaxRec; OptionFlags : Word);
    {-Activate multiple options}
  begin
    with FP^, aPData^ do
      afFlags := afFlags or (OptionFlags and not BadFaxOptions);
  end;

  procedure afOptionsOff(FP : PFaxRec; OptionFlags : Word);
    {-Deactivate multiple options}
  begin
    with FP^, aPData^ do
      afFlags := afFlags and not (OptionFlags and not BadFaxOptions);
  end;

  function afOptionsAreOn(FP : PFaxRec; OptionFlags : Word) : Boolean;
    {-Return True if all specified options are on}
  begin
    with FP^, aPData^ do
      afOptionsAreOn := (afFlags and OptionFlags = OptionFlags);
  end;

  procedure afSetConnectAttempts(FP : PFaxRec; Attempts : Word;
                                DelayTicks : Word);
    {-Set number of connect attempts per fax, 0 = infinite}
  begin
    with FP^, aPData^ do begin
      aMaxConnect := Attempts;
      aRetryWait := DelayTicks;
    end;
  end;

  procedure afSetNextFax(FP : PFaxRec;
                         Number : ShortString;
                         FName : ShortString;
                         Cover : ShortString);
    {-Set the next fax to transmit}

  begin
    with FP^, aPData^ do begin
      {Get the next fax to send}
      aPhoneNum := Number;
      aFaxFileName := FName;
      aCoverFile := Cover;

      {Upcase the file names}
      AnsiUpCheck(@aFaxFileName[1], Length(aFaxFileName));
      AnsiUpCheck(@aCoverFile[1], Length(aCoverFile));
    end;
  end;

  procedure afSetComHandle(FP : PFaxRec; NewHandle : TApdBaseDispatcher);
    {-Set a new comhandle to use}
  begin
    with FP^, aPData^ do
      aPort := NewHandle
  end;

  procedure afSetWindow(FP : PFaxRec; NewWindow : TApdHwnd);
    {-Set a new window handle to use}
  begin
    with FP^, aPData^ do
      aHWindow := NewWindow;
  end;

  procedure afSetTitle(FP : PFaxRec; NewTitle : ShortString);
  begin
    with FP^, aPData^ do
      aTitle := NewTitle;
  end;

  procedure afSetRecipientName(FP : PFaxRec; NewName : ShortString);
    {-Set name of recipient}
  begin
    with FP^, aPData^ do
      aRecipient := NewName;
  end;

  procedure afSetSenderName(FP : PFaxRec; NewName : ShortString);
    {-Set name of sender}
  begin
    with FP^, aPData^ do
      aSender := NewName;
  end;

  procedure afSetDestinationDir(FP : PFaxRec; Dest : ShortString);
    {-Set a destination directory for received files}
  begin
    with FP^, aPData^ do begin
      aDestDir := Dest;
      AnsiUpCheck(@aDestDir[1], Length(aDestDir));
    end;
  end;

  procedure afSetStationID(FP : PFaxRec; NewID : Str20);
  begin
    with FP^, aPData^ do
      aStationID := NewID;
  end;

  procedure afFaxStatus(FP : PFaxRec; Starting, Ending : Boolean);
    {-Fax status message, wParam mask: $01 = starting, $02 = ending}
    {                     lParam = FP}
  const
    StartMask : array[Boolean] of Word = ($00, $01);
    EndMask   : array[Boolean] of Word = ($00, $02);
  {$IFDEF Win32}
  var
    Res : DWORD;
  {$ENDIF}
  begin
    with FP^, aPData^ do
      {$IFDEF Win32}
      SendMessageTimeout(aHWindow, APW_FAXSTATUS,
                         StartMask[Starting] or EndMask[Ending],
                         LongInt(FP),
                         SMTO_ABORTIFHUNG + SMTO_BLOCK,
                         1000, Res);
      {$ELSE}
      SendMessage(aHWindow, APW_FAXSTATUS,
                  StartMask[Starting] or EndMask[Ending], LongInt(FP));
      {$ENDIF}
  end;

  function afNextFax(FP : PFaxRec) : Boolean;
    {-Return next number to dial, wParam not used}
    {                             lParam = FP   }
  {$IFDEF Win32}
  var
    Res : DWORD;
  {$ENDIF}
  begin
    with FP^, aPData^ do
      {$IFDEF Win32}
      SendMessageTimeout(aHWindow, APW_FAXNEXTFILE, 0, LongInt(FP),
                         SMTO_ABORTIFHUNG + SMTO_BLOCK,
                         2000, Res);                                  
      afNextFax := Boolean(Res);
      {$ELSE}
      afNextFax :=
        Boolean(SendMessage(aHWindow, APW_FAXNEXTFILE, 0, LongInt(FP)));
      {$ENDIF}
  end;

  procedure afLogFax(FP : PFaxRec; Log : TFaxLogCode);                   {!!.04}
    {-Logs the fax, wParam = logcode, lParam not used }
  {$IFDEF Win32}
  var
    Res : DWORD;
  {$ENDIF}
  begin
    with FP^, aPData^ do
      {$IFDEF Win32}
      SendMessageTimeout(aHWindow, APW_FAXLOG, Integer(Log), LongInt(FP),
                         SMTO_ABORTIFHUNG + SMTO_BLOCK,
                         1000, Res);
      {$ELSE}
      SendMessage(aHWindow, APW_FAXLOG, Integer(Log), LongInt(FP));
      {$ENDIF}
  end;

  procedure afFaxName(FP : PFaxRec);
    {-Call FaxName hook, wParam not used, lParam = FP}
  {$IFDEF Win32}
  var
    Res : DWORD;
  {$ENDIF}
  begin
    with FP^, aPData^ do
      {$IFDEF Win32}
      SendMessageTimeout(aHWindow, APW_FAXNAME, 0, LongInt(FP),
                         SMTO_ABORTIFHUNG + SMTO_BLOCK,
                         1000, Res);
      {$ELSE}
      SendMessage(aHWindow, APW_FAXNAME, 0, LongInt(FP));
      {$ENDIF}
  end;

  function afAcceptFax(FP : PFaxRec; RemoteName : Str20) : Boolean;
    {-Call AcceptFax hook, wParam not used, lParam = FP}
  var
    P : array[0..20] of Char;
    {$IFDEF Win32}
    Res : DWORD;
    {$ENDIF}
  begin
    with FP^, aPData^ do begin
      StrPCopy(P, RemoteName);
      {$IFDEF Win32}
      SendMessageTimeout(aHWindow, APW_FAXACCEPT, 0, LongInt(FP),
                         SMTO_ABORTIFHUNG + SMTO_BLOCK,
                         1000, Res);
      afAcceptFax := Boolean(Res);
      {$ELSE}
      afAcceptFax := Boolean(
         SendMessage(aHWindow, APW_FAXACCEPT, 0, LongInt(FP)));
      {$ENDIF}
    end;
  end;

  function afConvertHeaderString(FP : PFaxRec; S : ShortString) : ShortString;
    {-Compress a fax header string, converting tags to appropriate values}
  var
    I, N : Integer;
    T : String;
  begin
    with FP^, aPData^ do begin
      {walk thru the string, converting tags to appropriate data}
      I := Pos('$', S);
      while I > 0 do begin
        {get length of tag}
        N := I;
        while (N <= Length(S)) and (S[n] <> ' ') do
          Inc(N);
        Dec(N, I);

        {preserve and delete tag from the main string}
        T := Copy(S, I, N);
        Delete(S, I, N);

        {which tag?}
        case Upcase(T[2]) of
          'D':  {insert Date}
            T := TodayString;

          'T':  {insert Time}
            T := NowString;

          'I':  {insert station Id}
            T := aStationID;

          'S':  {insert Sender (Title)}
            T := aTitle;

          'P':  {insert current Page number}
            if aCoverCount > 0 then
              if aSendingCover then
                T := '1'
              else
                Str(aCurrPage+1, T)
            else
              Str(aCurrPage, T);

          'N':  {insert Number of pages}
            Str(aPageCount+aCoverCount, T);

          'F' : {insert from name}
            T := aSender;

          'R' : {insert recipient's name}
            T := aRecipient;

          '$' : {insert a dollar sign}                                   {!!.01}
            T := #1;                                                     {!!.01}

          else  {invalid tag, do nothing}
            T := '';
        end;
        Insert(T, S, I);

        {find next tag}
        I := Pos('$', S);
      end;
      while Pos(#1, S) > 0 do                                            {!!.01}
        S[Pos(#1, S)] := '$';                                            {!!.01}
      afConvertHeaderString := S;
    end;
  end;

  function afAddFaxEntry(FP : PFaxRec;
                         const Number : ShortString;
                         const FName : ShortString;
                         const Cover : ShortString) : Integer;
    {-Add another number to the built-in list}
  var
    Node : PFaxEntry;
  begin
    with FP^, aPData^ do begin
      Node := AllocMem(SizeOf(TFaxEntry));
      afAddFaxEntry := ecOk;

      {Create new node}
      with Node^ do begin
        fNumber := Number;
        fFName := FName;
        fCover := Cover;
        fNext := nil;
      end;

      if aFaxListHead = nil then begin
        {Set head/tail if this is the first...}
        aFaxListHead := Node;
        aFaxListTail := Node;
        aFaxListNode := Node;
        aFaxListCount := 1;
      end else begin
        {Attach to previous tail}
        aFaxListTail^.fNext := Node;
        aFaxListTail := Node;
        Inc(aFaxListCount);
      end;
    end;
  end;

  procedure afClearFaxEntries(FP : PFaxRec);
    {-Remove all fax entries from builtin list}
  var
    Node : PFaxEntry;
    Next : PFaxEntry;
  begin
    with FP^, aPData^ do begin
      Node := aFaxListHead;
      while Node <> nil do begin
        Next := Node^.fNext;
        FreeMem(Node, SizeOf(TFaxEntry));
        Node := Next;
      end;
      aFaxListCount := 0;
      aFaxListHead := nil;
      aFaxListTail := nil;
      aFaxListNode := nil;
    end;
  end;

  function afGetFaxName(FP : PFaxRec) : ShortString;
    {-Return name of current fax, with path if supplied}
  begin
    with FP^, aPData^ do
      afGetFaxName := aFaxFileName;
  end;

  procedure afSetFaxName(FP : PFaxRec; FaxName : ShortString);
    {-Set the name of the incoming fax}
  begin
    with FP^, aPData^ do
      aFaxFileName := FaxName;
  end;

  function afGetFaxProgress(FP : PFaxRec) : Word;
    {-Return fax progress code}
  begin
    with FP^, aPData^ do
      afGetFaxProgress := aFaxProgress;
  end;

  procedure afReportError(FP : PFaxRec; ErrorCode : Integer);
    {-Report the error}
  {$IFDEF Win32}
  var
    Res : DWORD;
  {$ENDIF}
  begin
    with FP^, aPData^ do begin
      aFaxError := ErrorCode;
      {$IFDEF Win32}
      SendMessageTimeout(aHWindow, APW_FAXERROR, ErrorCode, 0,
                         SMTO_ABORTIFHUNG + SMTO_BLOCK,
                         1000, Res);
      {$ELSE}
      SendMessage(aHWindow, APW_FAXERROR, ErrorCode, 0);
      {$ENDIF}
    end;
  end;

  procedure afSignalFinish(FP : PFaxRec);
    {-Send finish message to parent window}
  var
    ErrMsg : String;
  begin
    with FP^, aPData^ do begin
      {aPort.pSetFaxFlag(False);}
      afStopFax(FP);
      ErrMsg := 'ErrorCode:' + IntToStr(aFaxError);
      aPort.AddDispatchEntry(dtFax, dstStatus, 0,
        @ErrMsg[1], Length(ErrMsg));                               

      PostMessage(aHWindow, apw_FaxFinish, Word(aFaxError), Longint(FP));
    end;
  end;

  procedure afStartFax(FP : PFaxRec;
                       StartProc : TFaxPrepProc;
                       FaxFunc : TFaxFunc);
    {-Setup standard fax triggers}
  {var}
    {lParam : LongInt;}                                                  {!!.04}
  begin
    with FP^, aPData^ do begin

      HaveTriggerHandler := False;
      {Note the fax}
      aCurFaxFunc := FaxFunc;
      aPort.RemoveAllTriggers;                                           {!!.02}
      {Set up standard triggers}
      aPort.ChangeLengthTrigger(1);
      aTimeoutTrigger := aPort.AddTimerTrigger;
      aStatusTrigger := aPort.AddTimerTrigger;
      aOutBuffFreeTrigger := aPort.AddStatusTrigger(stOutBuffFree);
      aOutBuffUsedTrigger := aPort.AddStatusTrigger(stOutBuffUsed);
      {aNoCarrierTrigger := aPort.AddStatusTrigger(stModem);}            {!!.02}

      {All set?}
      if (aTimeoutTrigger < 0) or
         (aStatusTrigger < 0) or (aOutBuffFreeTrigger < 0) or
         (aOutBuffUsedTrigger < 0) {or (aNoCarrierTrigger < 0)}then begin{!!.02}
        {Send error message and give up}
        afReportError(FP, ecNoMoreTriggers);
        afSignalFinish(FP);
        Exit;
      end;

      {Store fax pointer}
      aPort.SetDataPointer(Pointer(FP), 2);

      {Prepare fax}
      if assigned(StartProc) then
        StartProc(FP);
      if aFaxError = ecOK then begin
        {add our state machine as a trigger handler procedure}
        aPort.RegisterProcTriggerHandler(FaxFunc);
        HaveTriggerHandler := True;
        {Call fax notification directly the first time...}
        {LH(lParam).H := aPort.Handle;}                                  {!!.04}
        {LH(lParam).L := 0;}                                             {!!.04}
        {FaxFunc(0, 0, lParam);}                                         {!!.04}
        {Activate status timer now, we'll enter the state machine in 2 ticks}
        aPort.SetTimerTrigger(aStatusTrigger, 2, True);                  {!!.04}
      end else begin
        {Couldn't get started, finish now}
        afFaxStatus(FP, False, True);
        afSignalFinish(FP);
      end;
    end;
  end;

  procedure afStopFax(FP : PFaxRec);
    {-Stop the fax}

    procedure RemoveIt(Trig : Integer);
    begin
      with FP^, aPData^ do
        if Trig > 0 then
          aPort.RemoveTrigger(Trig);
    end;

  begin
    with FP^, aPData^ do begin
      {Remove the fax triggers}
      {RemoveIt(aDataTrigger);}
      RemoveIt(aTimeoutTrigger);
      RemoveIt(aStatusTrigger);
      RemoveIt(aOutBuffFreeTrigger);
      RemoveIt(aOutBuffUsedTrigger);
      {RemoveIt(aNoCarrierTrigger);}                                     {!!.02}

      {Remove our trigger handler}
      if HaveTriggerHandler then begin
        aPort.DeregisterProcTriggerHandler(aCurFaxFunc);
        HaveTriggerHandler := False;
      end;                                                          

      {Say we're not in progress anymore}
      aInProgress := False;
    end;
  end;

  function afStatusMsg(P : PAnsiChar; Status : Word) : PAnsiChar;
    {-Return an appropriate error message from the stringtable}
  begin
    case Status of
      fpInitModem..fpFinished :
        AproLoadZ(P, Status);
      else
        P[0] := #0;
    end;
    Result := P;
  end;

{Builtin functions}

  function afNextFaxList(FP : PFaxRec;
                         var Number : ShortString;
                         var FName : ShortString;
                         var Cover : ShortString) : Boolean;
  begin
    with FP^, aPData^ do begin
      if aFaxListNode <> nil then begin
        afNextFaxList := True;
        with aFaxListNode^ do begin
          Number := fNumber;
          FName := fFName;
          Cover := fCover;
          aFaxListNode := fNext;
        end;
      end else
        afNextFaxList := False;
    end;
  end;

  function afFaxNameMD(FP : PFaxRec) : ShortString;
    {-Returns name for incoming fax like MMDD0001.APF}
  var
    I      : Word;
    Y,M,D  : Word;
    MS, DS : String[2];
    FName1 : String[4];
    FName  : ShortString;

    procedure MakeFileName(I : Word);
    var
      CountS : String[4];
      J : Word;
    begin
      with FP^, aPData^ do begin
        Str(I:4, CountS);
        for J := 1 to 4 do
          if CountS[J] = ' ' then
            CountS[J] := '0';
        FName := FName1 + CountS + '.' + aFaxFileExt;
        if aDestDir <> '' then
          FName := AddBackSlashS(aDestDir)+FName;
      end;
    end;

  begin
    with FP^, aPData^ do begin
      {Get the date}
      DecodeDate(SysUtils.Date, Y, M, D);
      Str(M:2, MS);
      Str(D:2, DS);
      FName1 := MS + DS;
      for I := 1 to 4 do
        if FName1[I] = ' ' then
          FName1[I] := '0';

      {Find last file with this date}
      I := 0;
      repeat
        Inc(I);
        MakeFileName(I);
      until not FileExists(FName) or (I = 10000);

      if I < 10000 then begin
        MakeFileName(I);
        afFaxNameMD := FName;
      end else
        afFaxNameMD := 'NONAME.APF';
    end;
  end;

  function afFaxNameCount(FP : PFaxRec) : ShortString;
    {-Returns name for incoming fax like FAX00001.APF}
  var
    I : Word;
    FName : ShortString;

    procedure MakeFileName(I : Word);
    var
      CountS : String[4];
      J : Word;
    begin
      with FP^, aPData^ do begin
        Str(I:4, CountS);
        for J := 1 to 4 do
          if CountS[J] = ' ' then
            CountS[J] := '0';
        FName := 'FAX' + CountS + '.' + aFaxFileExt;
        if aDestDir <> '' then
          FName := AddBackSlashS(aDestDir)+FName;
      end;
    end;

  begin
    with FP^, aPData^ do begin
      {Find last file}
      I := 0;
      repeat
        Inc(I);
        MakeFileName(I);
      until not FileExists(FName) or (I = 10000);

      if I < 10000 then begin
        MakeFileName(I);
        afFaxNameCount := FName;
      end else
        afFaxNameCount := 'NONAME.APF';
    end;
  end;

initialization

end.

