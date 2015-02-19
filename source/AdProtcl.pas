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
{*                   ADPROTCL.PAS 4.06                   *}
{*********************************************************}
{* TApdProtocol, status and log components               *}
{*********************************************************}

{
  TApdProtocol is a wrapper around the AwAbsPcl.pas abstract protocol
  layer, which uses protocol-specific code from AwZModem, AwXModem, etc.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$I+,G+,X+,F+,V-,Q-}

{$J+}

{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdProtcl;
  {-File transfer protocol VCL component}

interface

uses
  Windows,
  SysUtils,
  Classes,
  Messages,
  Controls,
  Graphics,
  Forms,
  OoMisc,
  AwUser,
  AwTPcl,
  AwAbsPcl,
  AwXmodem,
  AwYmodem,
  AwZmodem,
  AwKermit,
  AwAscii,
  AdExcept,
  AdPort;

type
  {Block check methods - NOTE! this must match OOMISC}
  TBlockCheckMethod = (
    bcmNone,
    bcmChecksum,
    bcmChecksum2,
    bcmCrc16,
    bcmCrc32,
    bcmCrcK);

  {Protocol types - NOTE! this must match OOMISC}
  TProtocolType = (
    ptNoProtocol,
    ptXmodem,
    ptXmodemCRC,
    ptXmodem1K,
    ptXmodem1KG,
    ptYmodem,
    ptYmodemG,
    ptZmodem,
    ptKermit,
    ptAscii);

  {Zmodem file management options - NOTE! this must match OOMISC}
  TZmodemFileOptions = (
    zfoNoOption,           {Place holder}
    zfoWriteNewerLonger,   {Transfer if new, newer or longer}
    zfoWriteCrc,           {Not supported, same as WriteNewer}
    zfoWriteAppend,        {Transfer if new, append if exists}
    zfoWriteClobber,       {Transfer regardless}
    zfoWriteNewer,         {Transfer if new or newer}
    zfoWriteDifferent,     {Transfer if new or diff dates/lens}
    zfoWriteProtect);      {Transfer only if new}

  {Action to take if incoming file exists - NOTE! this must match OOMISC}
  TWriteFailAction = (
    wfWriteNone,         {No option set yet}
    wfWriteFail,         {Fail the open attempt}
    wfWriteRename,       {Rename the incoming file}
    wfWriteAnyway,       {Overwrite the existing file}
    wfWriteResume);      {Resume an interrupted receive}

  {ASCII end-of-line translations}
  TAsciiEOLTranslation = (
    aetNone,             {No CR/LF translations}
    aetStrip,            {Strip CRs or LFs}
    aetAddCRBefore,      {Add CR before each LF}
    aetAddLFAfter);      {Add LF after each CR}

  {DeleteFailed options for TApdProtocolLog}
  TDeleteFailed = (dfNever, dfAlways, dfNonRecoverable);

const
  {Defaults for TApdProtocol properties}
  awpDefProtocolType         = ptZmodem;
  awpDefXYmodemBlockWait     = 91;
  awpDefYModem128ByteBlocks  = False;                                    {!!.06}
  awpDefZmodemOptionOverride = False;
  awpDefZmodemSkipNoFile     = False;
  awpDefZmodemFileOption     = zfoWriteNewer;
  awpDefZmodemRecover        = False;
  awpDefZmodem8K             = False;
  awpDefZmodemZRQINITValue   = 0;
  awpDefZmodemFinishRetry    = 0;
  awpDefZmodemEscControl     = False;                                       // SWB
  awpDefKermitMaxLen         = 80;
  awpDefKermitMaxWindows     = 0;
  awpDefKermitSWCTurnDelay   = 0;
  awpDefKermitTimeoutSecs    = 5;
  awpDefKermitPadCharacter   = ' ';
  awpDefKermitPadCount       = 0;
  awpDefKermitTerminator     = #13;
  awpDefKermitCtlPrefix      = '#';
  awpDefKermitHighbitPrefix  = 'Y';
  awpDefKermitRepeatPrefix   = '~';
  awpDefAsciiCharDelay       = 0;
  awpDefAsciiLineDelay       = 0;
  awpDefAsciiEOLChar         = #13;
  awpDefAsciiCRTranslation   = aetNone;
  awpDefAsciiLFTranslation   = aetNone;
  awpDefAsciiEOFTimeout      = 364;      {20 seconds}
  awpDefHonorDirectory       = False;
  awpDefIncludeDirectory     = False;
  awpDefRTSLowForWrite       = False;
  awpDefAbortNoCarrier       = False;
  awpDefBP2KTransmit         = False;
  awpDefAsciiSuppressCtrlZ   = False;
  awpDefFinishWait           = 364;
  awpDefTurnDelay            = 0;
  awpDefOverhead             = 0;
  awpDefWriteFailAction      = wfWriteRename;
  awpDefStatusInterval       = 18;
  awpDefUpcaseFileNames      = True;

  {Defaults for TApdProtocolLog properties}
  awpDefHistoryName       = 'APRO.HIS';
  awpDefDeleteFailed      = dfNonRecoverable;

  MaxKermitLongLen     = 1024;
  MaxKermitWindows     = 27;

  {Status options, just use the ones in OOMisc}
  {apFirstCall          = OoMisc.apFirstCall;}                           {!!.02}
  {apLastCall           = OoMisc.apLastCall;}                            {!!.02}

  {General protocol status constants}
  {psOK                 = OoMisc.psOK;}                                  {!!.02}
  {psProtocolHandshake  = OoMisc.psProtocolHandshake;}                   {!!.02}
  {psInvalidDate        = OoMisc.psInvalidDate;}                         {!!.02}
  {psFileRejected       = OoMisc.psFileRejected;}                        {!!.02}
  {psFileRenamed        = OoMisc.psFileRenamed;}                         {!!.02}
  {psSkipFile           = OoMisc.psSkipFile;}                            {!!.02}
  {psFileDoesntExist    = OoMisc.psFileDoesntExist;}                     {!!.02}
  {psCantWriteFile      = OoMisc.psCantWriteFile;}                       {!!.02}
  {psTimeout            = OoMisc.psTimeout;}                             {!!.02}
  {psBlockCheckError    = OoMisc.psBlockCheckError;}                     {!!.02}
  {psLongPacket         = OoMisc.psLongPacket;}                          {!!.02}
  {psDuplicateBlock     = OoMisc.psDuplicateBlock;}                      {!!.02}
  {psProtocolError      = OoMisc.psProtocolError;}                       {!!.02}
  {psCancelRequested    = OoMisc.psCancelRequested;}                     {!!.02}
  {psEndFile            = OoMisc.psEndFile;}                             {!!.02}
  {psResumeBad          = OoMisc.psResumeBad;}                           {!!.02}
  {psSequenceError      = OoMisc.psSequenceError;}                       {!!.02}
  {psAbortNoCarrier     = OoMisc.psAbortNoCarrier;}                      {!!.02}

  {Specific to certain protocols}
  {psGotCrcE            = OoMisc.psGotCrcE;}                             {!!.02}
  {psGotCrcG            = OoMisc.psGotCrcG;}                             {!!.02}
  {psGotCrcW            = OoMisc.psGotCrcW;}                             {!!.02}
  {psGotCrcQ            = OoMisc.psGotCrcQ;}                             {!!.02}
  {psTryResume          = OoMisc.psTryResume;}                           {!!.02}
  {psHostResume         = OoMisc.psHostResume;}                          {!!.02}
  {psWaitAck            = OoMisc.psWaitAck;}                             {!!.02}

  {For specifying log file calls}
  {lfReceiveStart       = OoMisc.lfReceiveStart;}                        {!!.02}
  {lfReceiveOk          = OoMisc.lfReceiveOk;}                           {!!.02}
  {lfReceiveFail        = OoMisc.lfReceiveFail;}                         {!!.02}
  {lfReceiveSkip        = OoMisc.lfReceiveSkip;}                         {!!.02}
  {lfTransmitStart      = OoMisc.lfTransmitStart;}                       {!!.02}
  {lfTransmitOk         = OoMisc.lfTransmitOk;}                          {!!.02}
  {lfTransmitFail       = OoMisc.lfTransmitFail;}                        {!!.02}
  {lfTransmitSkip       = OoMisc.lfTransmitSkip;}                        {!!.02}

type
  TApdAbstractStatus = class;
  TApdProtocolLog = class;

  {Protocol event handlers}
  TProtocolErrorEvent    = procedure(CP : TObject; ErrorCode : Integer)
                           of object;
  TProtocolFinishEvent   = procedure(CP : TObject; ErrorCode : Integer)
                           of object;
  TProtocolLogEvent      = procedure(CP : TObject; Log : Word)
                           of object;
  TProtocolResumeEvent   = procedure(CP : TObject;
                                     var Resume : TWriteFailAction)
                           of object;
  TProtocolStatusEvent   = procedure(CP : TObject; Options : Word)
                           of object;

  TProtocolNextFileEvent = procedure(CP : TObject; var FName : TPassString)
                           of object;
  TProtocolAcceptEvent   = procedure(CP : TObject;
                                     var Accept : Boolean;
                                     var FName : TPassString) of object;

  {Protocol component}
  TApdCustomProtocol = class(TApdBaseComponent)
  protected {private}
    {.Z+}
    {Private data}
    NeedBPS           : Boolean;         {True if we don't know BPS yet}
    ProtFunc          : TProtocolFunc;   {Current protocol function}
    Force             : Boolean;         {True to force setting options}

    {Property data}
    FMsgHandler       : HWnd;            {Window handler of MessageHandler}
    FComPort          : TApdCustomComPort; {Comport to use}
    FProtocolType     : TProtocolType;   {Current protocol}
    FStatusDisplay    : TApdAbstractStatus; {Built-in status display}
    FProtocolLog      : TApdProtocolLog; {Built-in protocol logging function}
    FXYmodemBlockWait : Cardinal;            {Inter-block delay in ticks}
    FZmodemOptionOverride : Boolean;     {True to override transmitter options}
    FZmodemSkipNoFile : Boolean;         {True to skip new incoming files}
    FZmodemFileOption : TZmodemFileOptions; {File mgmt options}
    FZmodemRecover    : Boolean;         {True to enable crash recovery}
    FZmodem8K         : Boolean;         {True to enable 8K zmodem}
    FZmodemZRQINITValue : Integer;       {Optional ZRQINIT data}
    FZmodemFinishRetry : Cardinal;           {Number of ZFin retries}
    FZmodemEscControl : Boolean;         {Escape all control chars}         // SWB
    FKermitMaxLen     : Cardinal;            {Max normal packet len}
    FKermitMaxWindows : Cardinal;            {Maximum number of windows}
    FKermitSWCTurnDelay : Cardinal;          {Turn delay when SWC in use}
    FKermitTimeoutSecs : Cardinal;           {Packet timeout in seconds}
    FKermitPadCharacter : AnsiChar;          {Pad character}
    FKermitPadCount   : Cardinal;            {Padding count}
    FKermitTerminator : AnsiChar;            {Packet terminator character (ASCII)}
    FKermitCtlPrefix  : AnsiChar;            {Control char prefix (ASCII value)}
    FKermitHighbitPrefix : AnsiChar;         {Hibit prefix (ASCII value)}
    FKermitRepeatPrefix : AnsiChar;          {Repeat prefix (ASCII value)}
    FAsciiCharDelay   : Cardinal;            {Inter-character delay}
    FAsciiLineDelay   : Cardinal;            {Inter-line delay}
    FAsciiEOLChar     : AnsiChar;            {End-of-line character (ASCII value)}
    FAsciiCRTranslation : TAsciiEOLTranslation; {ASCII translate CR}
    FAsciiLFTranslation : TAsciiEOLTranslation; {ASCII translate LF}
    FAsciiEOFTimeout  : Cardinal;            {Ticks to assume EOF}

    {Events}
    FOnProtocolAccept   : TProtocolAcceptEvent;
    FOnProtocolError    : TProtocolErrorEvent;
    FOnProtocolFinish   : TProtocolFinishEvent;
    FOnProtocolLog      : TProtocolLogEvent;
    FOnProtocolNextFile : TProtocolNextFileEvent;
    FOnProtocolResume   : TProtocolResumeEvent;
    FOnProtocolStatus   : TProtocolStatusEvent;

    procedure CreateMessageHandler;
    procedure CheckPort;

  protected
    {Misc protected methods}
    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

    {Property methods}
    procedure SetComPort(const NewComPort : TApdCustomComPort);
    procedure SetProtocolType(const NewProtocol : TProtocolType);
    function GetDestinationDirectory : AnsiString;
    procedure SetDestinationDirectory(const NewDir : AnsiString);
    function GetFileMask : TFileName;
    procedure SetFileMask(const NewFileMask : TFileName);
    function GetBatch : Boolean;
    function GetBlockCheckMethod : TBlockCheckMethod;
    procedure SetBlockCheckMethod(const NewMethod : TBlockCheckMethod);
    function GetHandshakeRetry : Cardinal;
    procedure SetHandshakeRetry(const NewRetry : Cardinal);
    function GetHandshakeWait : Cardinal;
    procedure SetHandshakeWait(const NewWait : Cardinal);
    function GetBlockLength : Cardinal;
    function GetBlockNumber : Cardinal;
    function GetTransmitTimeout : Cardinal;
    procedure SetTransmitTimeout(const NewTimeout : Cardinal);
    function GetFinishWait : Cardinal;
    procedure SetFinishWait(const NewWait : Cardinal);
    function GetActualBPS : Integer;
    procedure SetActualBPS(const NewBPS : Integer);
    function GetTurnDelay : Cardinal;
    procedure SetTurnDelay(const NewDelay : Cardinal);
    function GetOverhead : Cardinal;
    procedure SetOverhead(const NewOverhead : Cardinal);
    function GetWriteFailAction : TWriteFailAction;
    procedure SetWriteFailAction(const NewAction : TWriteFailAction);
    function GetProtocolStatus : Cardinal;
    function GetProtocolError : SmallInt;
    function GetFileLength : Integer;
    function GetFileDate : TDateTime;
    function GetInitialPosition : Integer;
    function GetStatusInterval : Cardinal;
    procedure SetStatusInterval(const NewInterval : Cardinal);
    procedure SetStatusDisplay(const NewDisplay : TApdAbstractStatus);
    procedure SetProtocolLog(const NewLog : TApdProtocolLog);
    function GetInProgress : Boolean;
    function GetBlockErrors : Cardinal;
    function GetTotalErrors : Cardinal;
    function GetBytesRemaining : Integer;
    function GetBytesTransferred : Integer;
    function GetElapsedTicks : Integer;
    function GetFileName : AnsiString;
    procedure SetFileName(const NewName : AnsiString);
    function GetXYmodemBlockWait : Cardinal;
    procedure SetXYmodemBlockWait(const NewWait : Cardinal);
    function GetYModem128ByteBlocks: Boolean;                            {!!.06}
    procedure SetYModem128ByteBlocks(const Value: Boolean);              {!!.06}
    function GetZmodemOptionOverride : Boolean;
    procedure SetZmodemOptionOverride(const NewOverride : Boolean);
    function GetZmodemSkipNoFile : Boolean;
    procedure SetZmodemSkipNoFile(const NewSkip : Boolean);
    function GetZmodemFileOption : TZmodemFileOptions;
    procedure SetZmodemFileOption(const NewOpt : TZmodemFileOptions);
    function GetZmodemRecover : Boolean;
    procedure SetZmodemRecover(const NewRecover : Boolean);
    function GetZmodem8K : Boolean;
    procedure SetZmodem8K(const New8K : Boolean);
    function GetZmodemZRQINITValue : Integer;
    procedure SetZmodemZRQINITValue(const NewZRQINITValue : Integer);
    function GetZmodemFinishRetry : Cardinal;
    procedure SetZmodemFinishRetry(const NewRetry : Cardinal);
    function GetZmodemEscControl : Boolean;                                 // SWB
    procedure SetZmodemEscControl(const newEsc : Boolean);                  // SWB
    function GetKermitMaxLen : Cardinal;
    procedure SetKermitMaxLen(const NewLen : Cardinal);
    function GetKermitMaxWindows : Cardinal;
    procedure SetKermitMaxWindows(const NewMax : Cardinal);
    function GetKermitSWCTurnDelay : Cardinal;
    procedure SetKermitSWCTurnDelay(const NewDelay : Cardinal);
    function GetKermitTimeoutSecs : Cardinal;
    procedure SetKermitTimeoutSecs(const NewTimeout : Cardinal);
    function GetKermitPadCharacter : AnsiChar;
    procedure SetKermitPadCharacter(NewChar : AnsiChar);
    function GetKermitPadCount : Cardinal;
    procedure SetKermitPadCount(NewCount : Cardinal);
    function GetKermitTerminator : AnsiChar;
    procedure SetKermitTerminator(const NewTerminator : AnsiChar);
    function GetKermitCtlPrefix : AnsiChar;
    procedure SetKermitCtlPrefix(const NewPrefix : AnsiChar);
    function GetKermitHighbitPrefix : AnsiChar;
    procedure SetKermitHighbitPrefix(const NewPrefix : AnsiChar);
    function GetKermitRepeatPrefix : AnsiChar;
    procedure SetKermitRepeatPrefix(const NewPrefix : AnsiChar);
    function GetKermitWindowsTotal : Cardinal;
    function GetKermitWindowsUsed : Cardinal;
    function GetKermitLongBlocks : Boolean;
    function GetAsciiCharDelay : Cardinal;
    procedure SetAsciiCharDelay(const NewDelay : Cardinal);
    function GetAsciiLineDelay : Cardinal;
    procedure SetAsciiLineDelay(const NewDelay : Cardinal);
    function GetAsciiEOLChar : AnsiChar;
    procedure SetAsciiEOLChar(const NewChar : AnsiChar);
    function GetAsciiCRTranslation : TAsciiEOLTranslation;
    procedure SetAsciiCRTranslation(const NewTrans : TAsciiEOLTranslation);
    function GetAsciiLFTranslation : TAsciiEOLTranslation;
    procedure SetAsciiLFTranslation(const NewTrans : TAsciiEOLTranslation);
    function GetAsciiEOFTimeout : Cardinal;
    procedure SetAsciiEOFTimeout(const NewTimeout : Cardinal);
    function GetHonorDirectory : Boolean;
    procedure SetHonorDirectory(const NewOpt : Boolean);
    function GetIncludeDirectory : Boolean;
    procedure SetIncludeDirectory(const NewOpt : Boolean);
    function GetRTSLowForWrite : Boolean;
    procedure SetRTSLowForWrite(const NewOpt : Boolean);
    function GetAbortNoCarrier : Boolean;
    procedure SetAbortNoCarrier(const NewOpt : Boolean);
    function GetBP2KTransmit : Boolean;
    procedure SetBP2KTransmit(const NewOpt : Boolean);
    function GetAsciiSuppressCtrlZ : Boolean;
    procedure SetAsciiSuppressCtrlZ(const NewOpt : Boolean);
    function GetUpcaseFileNames : Boolean;
    procedure SetUpcaseFileNames(NewUpcase : Boolean);

    {Port close callback}
    procedure apwPortCallbackEx(CP : TObject; CallbackType : TApdCallbackType);
                               
    {Protocol event methods}
    procedure apwProtocolAccept(CP : TObject; var Accept : Boolean;
                                var FName : TPassString); virtual;
    procedure apwProtocolError(CP : TObject; ErrorCode : Integer); virtual;
    procedure apwProtocolFinish(CP : TObject; ErrorCode : Integer); virtual;
    procedure apwProtocolLog(CP : TObject; Log : Cardinal); virtual;
    procedure apwProtocolNextFile(CP : TObject; var FName : TPassString); virtual;
    procedure apwProtocolResume(CP : TObject;
                                var Resume : TWriteFailAction); virtual;
    procedure apwProtocolStatus(CP : TObject; Options : Cardinal); virtual;

  public
    PData             : PProtocolData;   {Protocol data}

    constructor Create(AOwner : TComponent); override;
      {-Create a TApdProtocol component}
    destructor Destroy; override;
      {-Destroy a TApdProtocol component}
    procedure Assign(Source : TPersistent); override;
      {-Assign fields from TApdProtocol object specified by Source}
    {.Z-}
    function EstimateTransferSecs(const Size : Integer) : Integer;
      {-Return the number of seconds to transmit Size bytes}
    function StatusMsg(const Status : Cardinal) : AnsiString;
      {-Return a status message for Status}
    procedure StartTransmit;
      {-Start a background transmit session}
    procedure StartReceive;
      {-Start a background receive session}
    procedure CancelProtocol;
      {-Cancel the background protocol session}


    {General properties}
    property ComPort : TApdCustomComPort
      read FComPort write SetComPort;

    {General protocol control properties}
    property ProtocolType : TProtocolType
      read FProtocolType write SetProtocolType;
    property DestinationDirectory : AnsiString
      read GetDestinationDirectory write SetDestinationDirectory;
    property FileMask : TFileName
      read GetFileMask write SetFileMask;
    property BlockCheckMethod : TBlockCheckMethod
      read GetBlockCheckMethod write SetBlockCheckMethod;
    property HandshakeRetry : Cardinal
      read GetHandshakeRetry write SetHandshakeRetry default awpDefHandshakeRetry;
    property HandshakeWait : Cardinal
      read GetHandshakeWait write SetHandshakeWait default awpDefHandshakeWait;
    property TransmitTimeout : Cardinal
      read GetTransmitTimeout write SetTransmitTimeout default awpDefTransTimeout;
    property FinishWait : Cardinal
      read GetFinishWait write SetFinishWait default awpDefFinishWait;
    property ActualBPS : Integer
      read GetActualBPS write SetActualBPS;
    property TurnDelay : Cardinal
      read GetTurnDelay write SetTurnDelay default awpDefTurnDelay;
    property Overhead : Cardinal
      read GetOverhead write SetOverhead default awpDefOverhead;
    property WriteFailAction : TWriteFailAction
      read GetWriteFailAction write SetWriteFailAction
      default awpDefWriteFailAction;

    {Option properties}
    property HonorDirectory : Boolean
      read GetHonorDirectory write SetHonorDirectory
      default awpDefHonorDirectory;
    property IncludeDirectory : Boolean
      read GetIncludeDirectory write SetIncludeDirectory
      default awpDefIncludeDirectory;
    property RTSLowForWrite : Boolean
      read GetRTSLowForWrite write SetRTSLowForWrite
      default awpDefRTSLowForWrite;
    property AbortNoCarrier : Boolean
      read GetAbortNoCarrier write SetAbortNoCarrier
      default awpDefAbortNoCarrier;
    property BP2KTransmit : Boolean
      read GetBP2KTransmit write SetBP2KTransmit
      default awpDefBP2KTransmit;
    property AsciiSuppressCtrlZ : Boolean
      read GetAsciiSuppressCtrlZ write SetAsciiSuppressCtrlZ
      default awpDefAsciiSuppressCtrlZ;
    property UpcaseFileNames : Boolean
      read GetUpcaseFileNames write SetUpcaseFileNames
      default awpDefUpcaseFileNames;

    {Read only properties}
    property Batch : Boolean
      read GetBatch;
    property BlockLength : Cardinal
      read GetBlockLength;
    property BlockNumber : Cardinal
      read GetBlockNumber;
    property ProtocolStatus : Cardinal
      read GetProtocolStatus;
    property ProtocolError : SmallInt
      read GetProtocolError;
    property FileLength : Integer
      read GetFileLength;
    property FileDate : TDateTime
      read GetFileDate;
    property InitialPosition : Integer
      read GetInitialPosition;

    {Status properties}
    property StatusDisplay : TApdAbstractStatus
      read FStatusDisplay write SetStatusDisplay;
    property ProtocolLog : TApdProtocolLog
      read FProtocolLog write SetProtocolLog;
    property StatusInterval : Cardinal
      read GetStatusInterval write SetStatusInterval default awpDefStatusInterval;
    property InProgress : Boolean
      read GetInProgress;
    property BlockErrors : Cardinal
      read GetBlockErrors;
    property TotalErrors : Cardinal
      read GetTotalErrors;
    property BytesRemaining : Integer
      read GetBytesRemaining;
    property BytesTransferred : Integer
      read GetBytesTransferred;
    property ElapsedTicks : Integer
      read GetElapsedTicks;
    property FileName : AnsiString
      read GetFileName write SetFileName;

    {Xmodem/Ymodem properties}
    property XYmodemBlockWait : Cardinal
      read GetXYmodemBlockWait write SetXYmodemBlockWait
      default awpDefXYmodemBlockWait;
    property YModem128ByteBlocks : Boolean                               {!!.06}
      read GetYModem128ByteBlocks write SetYModem128ByteBlocks           {!!.06}
      default awpDefYModem128ByteBlocks;                                 {!!.06}

    {Zmodem properties}
    property ZmodemOptionOverride : Boolean
      read GetZmodemOptionOverride write SetZmodemOptionOverride
      default awpDefZmodemOptionOverride;
    property ZmodemSkipNoFile : Boolean
      read GetZmodemSkipNoFile write SetZmodemSkipNoFile
      default awpDefZmodemSkipNoFile;
    property ZmodemFileOption : TZmodemFileOptions
      read GetZmodemFileOption write SetZmodemFileOption
      default awpDefZmodemFileOption;
    property ZmodemRecover : Boolean
      read GetZmodemRecover write SetZmodemRecover default awpDefZmodemRecover;
    property Zmodem8K : Boolean
      read GetZmodem8K write SetZmodem8K default awpDefZmodem8K;
    property ZmodemZRQINITValue : Integer
      read GetZmodemZRQINITValue write SetZmodemZRQINITValue
      default awpDefZmodemZRQINITValue;
    property ZmodemFinishRetry : Cardinal
      read GetZmodemFinishRetry write SetZmodemFinishRetry
      default awpDefZmodemFinishRetry;
    property ZmodemEscControl : Boolean                                     // SWB
      read GetZmodemEscControl write SetZmodemEscControl                    // SWB
      default awpDefZmodemEscControl;                                       // SWB

    {Kermit properties}
    property KermitMaxLen : Cardinal
      read GetKermitMaxLen write setKermitMaxLen
      default awpDefKermitMaxLen;
    property KermitMaxWindows : Cardinal
      read GetKermitMaxWindows write SetKermitMaxWindows
      default awpDefKermitMaxWindows;
    property KermitSWCTurnDelay : Cardinal
      read GetKermitSWCTurnDelay write SetKermitSWCTurnDelay
      default awpDefKermitSWCTurnDelay;
    property KermitTimeoutSecs : Cardinal
      read GetKermitTimeoutSecs write SetKermitTimeoutSecs
      default awpDefKermitTimeoutSecs;
    property KermitPadCharacter : AnsiChar
      read GetKermitPadCharacter write SetKermitPadCharacter
      default awpDefKermitPadCharacter;
    property KermitPadCount : Cardinal
      read GetKermitPadCount write SetKermitPadCount
      default awpDefKermitPadCount;
    property KermitTerminator : AnsiChar
      read GetKermitTerminator write SetKermitTerminator
      default awpDefKermitTerminator;
    property KermitCtlPrefix : AnsiChar
      read GetKermitCtlPrefix write SetKermitCtlPrefix
      default awpDefKermitCtlPrefix;
    property KermitHighbitPrefix : AnsiChar
      read GetKermitHighbitPrefix write SetKermitHighbitPrefix
      default awpDefKermitHighbitPrefix;
    property KermitRepeatPrefix : AnsiChar
      read GetKermitRepeatPrefix write SetKermitRepeatPrefix
      default awpDefKermitRepeatPrefix;
    property KermitWindowsTotal : Cardinal
      read GetKermitWindowsTotal;
    property KermitWindowsUsed : Cardinal
      read GetKermitWindowsUsed;
    property KermitLongBlocks : Boolean
      read GetKermitLongBlocks;
    property AsciiCharDelay : Cardinal
      read GetAsciiCharDelay write SetAsciiCharDelay
      default awpDefAsciiCharDelay;
    property AsciiLineDelay : Cardinal
      read GetAsciiLineDelay write SetAsciiLineDelay
      default awpDefAsciiLineDelay;
    property AsciiEOLChar : AnsiChar
      read GetAsciiEOLChar write SetAsciiEOLChar
      default awpDefAsciiEOLChar;
    property AsciiCRTranslation : TAsciiEOLTranslation
      read GetAsciiCRTranslation write SetAsciiCRTranslation
      default awpDefAsciiCRTranslation;
    property AsciiLFTranslation : TAsciiEOLTranslation
      read GetAsciiLFTranslation write SetAsciiLFTranslation
      default awpDefAsciiLFTranslation;
    property AsciiEOFTimeout : Cardinal
      read GetAsciiEOFTimeout write SetAsciiEOFTimeout
      default awpDefAsciiEOFTimeout;

    {Protocol events}
    property OnProtocolAccept : TProtocolAcceptEvent
      read FOnProtocolAccept write FOnProtocolAccept;
    property OnProtocolError : TProtocolErrorEvent
      read FOnProtocolError write FOnProtocolError;
    property OnProtocolFinish : TProtocolFinishEvent
      read FOnProtocolFinish write FOnProtocolFinish;
    property OnProtocolLog : TProtocolLogEvent
      read FOnProtocolLog write FOnProtocolLog;
    property OnProtocolNextFile : TProtocolNextFileEvent
      read FOnProtocolNextFile write FOnProtocolNextFile;
    property OnProtocolResume : TProtocolResumeEvent
      read FOnProtocolResume write FOnProtocolResume;
    property OnProtocolStatus : TProtocolStatusEvent
      read FOnProtocolStatus write FOnProtocolStatus;
  end;

  {Abstract protocol status class}
  TApdAbstractStatus = class(TApdBaseComponent)
  protected {private}
    {.Z+}
    FDisplay         : TForm;
    FPosition        : TPosition;
    FCtl3D           : Boolean;
    FVisible         : Boolean;
    FCaption         : TCaption;                                      

    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

  protected
    FProtocol        : TApdCustomProtocol;

    procedure SetPosition(const NewPosition : TPosition);
    procedure SetCtl3D(const NewCtl3D : Boolean);
    procedure SetVisible(const NewVisible : Boolean);
    procedure SetCaption(const NewCaption : TCaption);               
    procedure GetProperties;
    procedure Show;

  public
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdAbstractStatus component}
    destructor Destroy; override;
      {-Destroy a TApdAbstractStatus component}
    {.Z-}
    procedure UpdateDisplay(First, Last : Boolean); virtual; abstract;
      {-Update the status display with current data}
    procedure CreateDisplay; dynamic; abstract;
      {-Create the status display}
    procedure DestroyDisplay; dynamic; abstract;
      {-Destroy the status display}

    property Display : TForm
      read FDisplay write FDisplay;

  published
    property Position : TPosition
      read FPosition write SetPosition;
    property Ctl3D : Boolean
      read FCtl3D write SetCtl3D;
    property Visible : Boolean
      read FVisible write SetVisible;
    property Protocol : TApdCustomProtocol
      read FProtocol write FProtocol;
    property Caption : TCaption
      read FCaption write SetCaption;                                 
  end;

  {Builtin log procedure}
  TApdProtocolLog = class(TApdBaseComponent)
  protected {private}
    {.Z+}
    FDeleteFailed  : TDeleteFailed;
    FHistoryName   : AnsiString;
    FProtocol      : TApdCustomProtocol;

    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

  public
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdProtocolLog component}
    {.Z-}
    procedure UpdateLog(const Log : Cardinal); virtual;
      {-Add a log entry}

  published
    property Protocol : TApdCustomProtocol
      read FProtocol write FProtocol;
    property DeleteFailed : TDeleteFailed
      read FDeleteFailed write FDeleteFailed default awpDefDeleteFailed;
    property HistoryName : AnsiString
      read FHistoryName write FHistoryName;
  end;

  {Protocol component}
  TApdProtocol = class(TApdCustomProtocol)
  published
    property ComPort;
    property ProtocolType;
    property DestinationDirectory;
    property FileMask;
    property BlockCheckMethod;
    property HandshakeRetry;
    property HandshakeWait;
    property TransmitTimeout;
    property FinishWait;
    property TurnDelay;
    property Overhead;
    property WriteFailAction;
    property HonorDirectory;
    property IncludeDirectory;
    property RTSLowForWrite;
    property AbortNoCarrier;
    property BP2KTransmit;
    property AsciiSuppressCtrlZ;
    property StatusDisplay;
    property ProtocolLog;
    property StatusInterval;
    property FileName;
    property XYmodemBlockWait;
    property ZmodemOptionOverride;
    property ZmodemSkipNoFile;
    property ZmodemFileOption;
    property ZmodemRecover;
    property Zmodem8K;
    property ZmodemFinishRetry;
    property ZmodemEscControl;                                              // SWB
    property KermitMaxLen;
    property KermitMaxWindows;
    property KermitSWCTurnDelay;
    property KermitTimeoutSecs;
    property KermitPadCharacter;
    property KermitPadCount;
    property KermitTerminator;
    property KermitCtlPrefix;
    property KermitHighbitPrefix;
    property KermitRepeatPrefix;
    property AsciiCharDelay;
    property AsciiLineDelay;
    property AsciiEOLChar;
    property AsciiCRTranslation;
    property AsciiLFTranslation;
    property AsciiEOFTimeout;
    property UpcaseFileNames;
    property OnProtocolAccept;
    property OnProtocolError;
    property OnProtocolFinish;
    property OnProtocolLog;
    property OnProtocolNextFile;
    property OnProtocolResume;
    property OnProtocolStatus;
  end;

  {.Z+}
  {A list of active TApdProtocol objects}
  PProtocolWindowNode = ^TProtocolWindowNode;
  TProtocolWindowNode = record
    pwWindow   : TApdHwnd;
    pwProtocol : TApdCustomProtocol;
  end;

  {Miscellaneous functions}
  function CheckNameString(const Check : TBlockCheckMethod) : AnsiString;
  function FormatMinSec(const TotalSecs : Integer) : AnsiString;
  {.Z-}
  function ProtocolName(const ProtocolType : TProtocolType) : AnsiString;

  {Component registration procedure}

implementation

uses
  Types, AnsiStrings;

const
  FileSkipMask = $80;   {Skip file if dest doesn't exist}
  FileRecover  = $03;   {Resume interrupted file transfer}

const
  {Table of protocol preparation procedures}
  PrepProcs : array[ptNoProtocol..ptAscii, Boolean] of TPrepareProc = (
    (nil, nil),                               {NoProtocol}
    (xpPrepareReceive, xpPrepareTransmit),    {Xmodem}
    (xpPrepareReceive, xpPrepareTransmit),    {XmodemCRC}
    (xpPrepareReceive, xpPrepareTransmit),    {Xmodem1K}
    (xpPrepareReceive, xpPrepareTransmit),    {Xmodem1KG}
    (ypPrepareReceive, ypPrepareTransmit),    {Ymodem}
    (ypPrepareReceive, ypPrepareTransmit),    {YmodemG}
    (zpPrepareReceive, zpPrepareTransmit),    {Zmodem}
    (kpPrepareReceive, kpPrepareTransmit),    {Kermit}
    (spPrepareReceive, spPrepareTransmit));    {Ascii}

  {Table of protocol functions}
  ProtFuncs : array[ptNoProtocol..ptAscii, Boolean] of TProtocolFunc = (
    (nil, nil),                   {NoProtocol}
    (xpReceive, xpTransmit),      {Xmodem}
    (xpReceive, xpTransmit),      {XmodemCRC}
    (xpReceive, xpTransmit),      {Xmodem1K}
    (xpReceive, xpTransmit),      {Xmodem1KG}
    (ypReceive, ypTransmit),      {Ymodem}
    (ypReceive, ypTransmit),      {YmodemG}
    (zpReceive, zpTransmit),      {Zmodem}
    (kpReceive, kpTransmit),      {Kermit}
    (spReceive, spTransmit));      {Ascii}

var
  ProtList : TList;

{General purpose routines}

  function LeftPad(const S : AnsiString; Len : Byte) : AnsiString;
    {-Return a string left-padded to length len}
  var
    o : AnsiString;
    SLen : Byte;
  begin
    SLen := Length(S);
    if SLen >= Len then
      LeftPad := S
    else if SLen < 255 then begin
      SetLength(o, Len);
      Move(S[1], o[Succ(Cardinal(Len))-SLen], SLen);
      FillChar(o[1], Len-SLen, ' ');
      LeftPad := o;
    end;
  end;

  function SearchStatusDisplay(const C : TComponent) : TApdAbstractStatus;
    {-Search for a status display in the same form as TComponent}

    function FindStatusDisplay(const C : TComponent) : TApdAbstractStatus;
    var
      I  : Integer;
    begin
      Result := nil;
      if not Assigned(C) then
        Exit;

      {Look through all of the owned components}
      for I := 0 to C.ComponentCount-1 do begin
        if C.Components[I] is TApdAbstractStatus then begin
          {...and it's not assigned}
          if not Assigned(TApdAbstractStatus(C.Components[I]).FProtocol) then begin
            Result := TApdAbstractStatus(C.Components[I]);
            Exit;
          end;
        end;

        {If this isn't one, see if it owns other components}
        Result := FindStatusDisplay(C.Components[I]);
      end;
    end;

  begin
    {Search the entire form}
    Result := FindStatusDisplay(C);
  end;

  function SearchProtocolLog(const C : TComponent) : TApdProtocolLog;
    {-Search for a protocol log in the same form as TComponent}

    function FindProtocolLog(const C : TComponent) : TApdProtocolLog;
    var
      I  : Integer;
    begin
      Result := nil;
      if not Assigned(C) then
        Exit;

      {Look through all of the owned components}
      for I := 0 to C.ComponentCount-1 do begin
        if C.Components[I] is TApdProtocolLog then begin
          {...and it's not assigned}
          if not Assigned(TApdProtocolLog(C.Components[I]).FProtocol) then begin
            Result := TApdProtocolLog(C.Components[I]);
            Exit;
          end;
        end;

        {If this isn't one, see if it owns other components}
        Result := FindProtocolLog(C.Components[I]);
      end;
    end;

  begin
    {Search the entire form}
    Result := FindProtocolLog(C);
  end;

{Message handler window}

  function FindProtocol(Handle : TApdHwnd) : TApdCustomProtocol;
    {-Return protocol object for this window handle}
  var
    I : Integer;
  begin
    for I := 0 to ProtList.Count-1 do begin
      with PProtocolWindowNode(ProtList.Items[I])^ do begin
        if pwWindow = Handle then begin
          Result := pwProtocol;
          Exit;
        end;
      end;
    end;
    Result := nil;
  end;

  function MessageHandler(hWindow : TApdHwnd; Msg, wParam : Integer;
                          lParam : Integer) : Integer; stdcall; export;
    {-Window function for all apw_ProtXxx messages}
  var
    P : TApdCustomProtocol;
    Accept : Boolean;
    FName : TPassString;
    Temp : TWriteFailAction;

  begin
    Result := 0;
    P := FindProtocol(hWindow);
    if Assigned(P) then begin
      with P do begin
        case Msg of
          APW_PROTOCOLSTATUS      :
            apwProtocolStatus(P, wParam);
          APW_PROTOCOLLOG         :
            apwProtocolLog(P, wParam);
          APW_PROTOCOLNEXTFILE    :
            begin
              FName := '';
              apwProtocolNextFile(P, FName);
              if FName <> '' then begin
                AnsiStrings.StrPCopy(PAnsiChar(lParam), FName);  // SZ: 30.01.2010 (http://www.delphimaster.ru/cgi-bin/forum.pl?id=1263549006&n=3)
                Result := 1;
              end else
                Result := 0;
            end;
          APW_PROTOCOLACCEPTFILE  :
            begin
              FName := AnsiStrings.StrPas(PAnsiChar(lParam));     //SZ: 30.01.2010 (as reported by mail from Kolan)
              apwProtocolAccept(P, Accept, FName);
              if Accept then begin
                if FileName <> '' then
                  AnsiStrings.StrPCopy(PAnsiChar(lParam), FName);
                Result := 1;
              end else
                Result := 0;
            end;
          APW_PROTOCOLFINISH      :
            apwProtocolFinish(P, SmallInt(wParam));
          APW_PROTOCOLRESUME      :
            begin
              Temp := TWriteFailAction(wParam);
              apwProtocolResume(P, Temp);
              MessageHandler := wParam;
            end;
          APW_PROTOCOLERROR       :
            apwProtocolError(P, SmallInt(wParam));
          else
            MessageHandler := DefWindowProc(hWindow, Msg, wParam, lParam);
        end;
      end;
    end else
      MessageHandler := DefWindowProc(hWindow, Msg, wParam, lParam);
  end;

  procedure RegisterMessageHandlerClass;
  const
    Registered : Boolean = False;
  var
    XClass: TWndClass;
  begin
    if Registered then
      Exit;
    Registered := True;

    with XClass do begin
      Style         := 0;
      lpfnWndProc   := @MessageHandler;
      cbClsExtra    := 0;
      cbWndExtra    := 0;
      if ModuleIsLib and not ModuleIsPackage then
        hInstance   := SysInit.hInstance
      else
        hInstance   := System.MainInstance;
      hIcon         := 0;
      hCursor       := 0;
      hbrBackground := 0;
      lpszMenuName  := nil;
      lpszClassName := MessageHandlerClassName;
    end;
    Windows.RegisterClass(XClass);
  end;

{TApdProtocol}

  procedure TApdCustomProtocol.CreateMessageHandler;
    {-Create message handler window}
  var
    Node : PProtocolWindowNode;
    hInstance : THandle;
  begin
    if ModuleIsLib and not ModuleIsPackage then
      hInstance   := SysInit.hInstance
    else
      hInstance   := System.MainInstance;
    FMsgHandler :=
      CreateWindow(MessageHandlerClassName,   {window class name}
      '',                         {caption}
      0,                          {window style}
      0,                          {X}
      0,                          {Y}
      0,                          {width}
      0,                          {height}
      0,                          {parent}
      0,                          {menu}
      hInstance,
      nil);

    if FMsgHandler = 0 then
      raise EInternal.Create(ecInternal, False);

    ShowWindow(FMsgHandler, sw_Hide);

    {Add to global list}
    Node := nil;
    try
      New(Node);
      Node^.pwWindow := FMsgHandler;
      Node^.pwProtocol := Self;
      ProtList.Add(Node);
      apSetProtocolWindow(PData, FMsgHandler);
    except
      on EOutOfMemory do begin
        if Node <> nil then
          Dispose(Node);
        raise;
      end;
    end;
  end;

  procedure TApdCustomProtocol.CheckPort;
    {-Set port's comhandle or raise exception}
  begin
    {Make sure comport is open, pass handle to protocol}
    if Assigned(FComPort) then
      apSetProtocolPort(PData, FComPort)
    else
      raise EPortNotAssigned.Create(ecPortNotAssigned, False);
  end;

  procedure TApdCustomProtocol.Notification(AComponent : TComponent;
                                            Operation : TOperation);
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      {Owned components going away}
      if AComponent = FComPort then
        ComPort := nil;
      if AComponent = FStatusDisplay then
        StatusDisplay := nil;
      if AComponent = FProtocolLog then
        ProtocolLog := nil;
    end else if Operation = opInsert then begin
      {Check for new comport}
      if AComponent is TApdCustomComPort then
        if not Assigned(FComPort) then
          ComPort := TApdCustomComPort(AComponent);

      {Check for new status component}
      if AComponent is TApdAbstractStatus then begin
        if not Assigned(FStatusDisplay) then
          if not Assigned(TApdAbstractStatus(AComponent).FProtocol) then
            StatusDisplay := TApdAbstractStatus(AComponent);
      end;

      {Check for new protocol log component}
      if AComponent is TApdProtocolLog then begin
        if not Assigned(FProtocolLog) then begin
          if not Assigned(TApdProtocolLog(AComponent).FProtocol) then begin
            ProtocolLog := TApdProtocolLog(AComponent);
            ProtocolLog.FProtocol := Self;
          end;
        end;
      end;
    end;
  end;

  procedure TApdCustomProtocol.SetComPort(const NewComPort : TApdCustomComPort);
    {-Set a new comport}
  begin
    if NewComPort <> FComPort then begin
      FComPort := NewComPort;
      if Assigned(FComPort) then
        apSetProtocolPort(PData, ComPort)
      else
        apSetProtocolPort(PData, nil);
    end;
  end;

  procedure TApdCustomProtocol.SetProtocolType(
                               const NewProtocol : TProtocolType);
    {-Set a new protocol type}
  var
    Status : Integer;
  begin
    if (NewProtocol <> FProtocolType) or
       (csLoading in ComponentState) then begin
      {Dispose of current protocol, if necessary}
      case FProtocolType of
        ptXmodem, ptXmodemCRC, ptXmodem1K, ptXmodem1KG :
          {nothing to do};
        ptYModem, ptYmodemG :
          ypDonePart(PData);
        ptZmodem :
          zpDonePart(PData);
        ptKermit :
          kpDonePart(PData);
        ptASCII :
          spDonePart(PData);
      end;

      {Init new protocol}
      Status := ecOk;
      Force := True;
      case NewProtocol of
        ptXmodem, ptXmodemCRC, ptXmodem1K, ptXmodem1KG :
          begin
            xpReinit(PData, NewProtocol <> ptXmodem,
                            NewProtocol = ptXmodem1K,
                            NewProtocol = ptXmodem1KG);
            SetXYmodemBlockWait(FXYmodemBlockWait);
          end;

        ptYmodem, ptYModemG :
          begin
            Status := ypReinit(PData,
                               True,
                               NewProtocol = ptYmodemG);
            if Status = ecOk then
              SetXYmodemBlockWait(FXYmodemBlockWait);
          end;

        ptZmodem :
          begin
            Status := zpReinit(PData);
            if Status = ecOk then begin
              SetZmodemOptionOverride(FZmodemOptionOverride);
              SetZmodemSkipNoFile(FZmodemSkipNoFile);
              SetZmodemFileOption(FZmodemFileOption);
              SetZmodemRecover(FZmodemRecover);
              SetZmodem8K(FZmodem8K);
              SetZmodemFinishRetry(FZmodemFinishRetry);
              SetZmodemEscControl(FZmodemEscControl);                       // SWB
            end;
          end;

        ptKermit :
          begin
            Status := kpReinit(PData);
            if Status = ecOk then begin
              SetKermitMaxLen(FKermitMaxLen);
              SetKermitMaxWindows(FKermitMaxWindows);
              SetKermitSWCTurnDelay(FKermitSWCTurnDelay);
              SetKermitTimeoutSecs(FKermitTimeoutSecs);
              SetKermitPadCharacter(FKermitPadCharacter);
              SetKermitPadCount(FKermitPadCount);
              SetKermitTerminator(FKermitTerminator);
              SetKermitCtlPrefix(FKermitCtlPrefix);
              SetKermitHighbitPrefix(FKermitHighbitPrefix);
              SetKermitRepeatPrefix(FKermitRepeatPrefix);
            end;
          end;

        ptASCII :
          begin
            Status := spReinit(PData);
            if Status = ecOk then begin
              SetAsciiCharDelay(FAsciiCharDelay);
              SetAsciiLineDelay(FAsciiLineDelay);
              SetAsciiEOLChar(FAsciiEOLChar);
              SetAsciiCRTranslation(FAsciiCRTranslation);
              SetAsciiLFTranslation(FAsciiLFTranslation);
              SetAsciiEOFTimeout(FAsciiEOFTimeout);
            end;
          end;
     end;

     {Note new protocol type}
     if Status = ecOk then
        FProtocolType := NewProtocol
     else
       CheckException(Self, Status);
    end;
  end;

  function TApdCustomProtocol.GetDestinationDirectory : AnsiString;
    {-Return the destination directory}
  begin
    Result := AnsiStrings.StrPas(PData^.aDestDir);
  end;

  procedure TApdCustomProtocol.SetDestinationDirectory(const NewDir : AnsiString);
    {-Set a new destination directory}
  begin
    with PData^ do
      AnsiStrings.StrPCopy(aDestDir, NewDir);
  end;

  function TApdCustomProtocol.GetFileMask : TFileName;
    {-Return the current file mask}
  begin
    Result := string(AnsiStrings.StrPas(PData^.aSearchMask));
  end;

  procedure TApdCustomProtocol.SetFileMask(const NewFileMask : TFileName);
    {-Set a new file mask}
  var
    S : TFileName;
  begin
    with PData^ do
      if Length(NewFileMask) > 255 then begin
        S := NewFileMask;
        SetLength(S, 255);
        AnsiStrings.StrPCopy(aSearchMask, AnsiString(S));
      end else
        AnsiStrings.StrPCopy(aSearchMask, AnsiString(NewFileMask));
  end;

  function TApdCustomProtocol.GetBatch : Boolean;
    {-Return True if the current protocol supports batch transfers}
  begin
    Result := PData^.aBatchProtocol;
  end;

  function TApdCustomProtocol.GetBlockCheckMethod : TBlockCheckMethod;
    {-Return the current block check method}
  begin
    Result := TBlockCheckMethod(PData^.aCheckType);
  end;

  function TApdCustomProtocol.GetProtocolStatus : Cardinal;
    {-Return the current protocol status}
  begin
    Result := PData^.aProtocolStatus;
  end;

  function TApdCustomProtocol.GetProtocolError : SmallInt;
    {-Return the current protocol error}
  begin
    Result := PData^.aProtocolError;
  end;

  function TApdCustomProtocol.GetFileLength : Integer;
    {-Return the file length}
  begin
    Result := PData^.aSrcFileLen;
  end;

  function TApdCustomProtocol.GetFileDate : TDateTime;
    {-Return the file timestamp}
  begin
    Result := FileDateToDateTime(PData^.aSrcFileDate);
  end;

  function TApdCustomProtocol.GetInitialPosition : Integer;
    {-Return the initial file position}
  begin
    Result := PData^.aInitFilePos;
  end;

  function TApdCustomProtocol.GetStatusInterval : Cardinal;
    {-Return the current status update interval, in ticks}
  begin
    Result := PData^.aStatusInterval;
  end;

  procedure TApdCustomProtocol.SetStatusInterval(const NewInterval : Cardinal);
    {-Set a new update status interval}
  begin
    with PData^ do
      if NewInterval <> aStatusInterval then
        aStatusInterval := NewInterval;
  end;

  procedure TApdCustomProtocol.SetStatusDisplay(
                               const NewDisplay : TApdAbstractStatus);
    {-Set a new status display}
  begin
    if NewDisplay <> FStatusDisplay then begin
      FStatusDisplay := NewDisplay;
      if Assigned(FStatusDisplay) then
        FStatusDisplay.FProtocol := Self;
    end;
  end;

  procedure TApdCustomProtocol.SetProtocolLog(const NewLog : TApdProtocolLog);
    {-Set a new protocol log}
  begin
    if NewLog <> FProtocolLog then begin
      FProtocolLog := NewLog;
      if Assigned(FProtocolLog) then
        FProtocolLog.FProtocol := Self;
    end;
  end;

  function TApdCustomProtocol.GetInProgress : Boolean;
    {-Return True if protocol is in progress}
  begin
    Result := PData^.aInProgress <> 0;
  end;

  function TApdCustomProtocol.GetBlockErrors : Cardinal;
    {-Return the number of block errors}
  begin
    Result := PData^.aBlockErrors;
  end;

  function TApdCustomProtocol.GetTotalErrors : Cardinal;
    {-Return the number of total errors}
  begin
    Result := PData^.aTotalErrors;
  end;

  function TApdCustomProtocol.GetBytesRemaining : Integer;
    {-Return the number of bytes remaining to be transferred}
  begin
    Result := apGetBytesRemaining(PData);
  end;

  function TApdCustomProtocol.GetBytesTransferred : Integer;
    {-Return the number of bytes transferred so far}
  begin
    Result := apGetBytesTransferred(PData);
  end;

  function TApdCustomProtocol.GetElapsedTicks : Integer;
    {-Return the ticks elapsed for this transfer}
  begin
    Result := PData^.aElapsedTicks;
  end;

  function TApdCustomProtocol.GetFileName : AnsiString;
    {-Return the current file name}
  begin
    Result := AnsiStrings.StrPas(PData^.aPathname);
  end;

  procedure TApdCustomProtocol.SetFileName(const NewName : AnsiString);
    {-Set/change the incoming file name}
  var
    P : array[0..255] of AnsiChar;
    S : AnsiString;
  begin
    {Allow changes only when WorkFile is *not* open}
    case TFileRec(PData^.aWorkFile).Mode of
      fmInput, fmOutput, fmInOut : ;
      else begin
        if Length(NewName) > 255 then begin
          S := NewName;
          SetLength(S, 255);
          AnsiStrings.StrPCopy(P, S);
        end else
          AnsiStrings.StrPCopy(P, NewName);
        apSetReceiveFileName(PData, P);
      end;
    end;
  end;

  function TApdCustomProtocol.GetXYmodemBlockWait : Cardinal;
    {-Return the X/Ymodem block wait value in ticks}
  begin
    case TProtocolType(PData^.aCurProtocol) of
      ptXmodem..ptYmodemG :
        begin
          FXYmodemBlockWait := PData^.xBlockWait;
          Result := FXYmodemBlockWait;
        end;
      else
        Result := FXYmodemBlockWait;
    end;
  end;

  procedure TApdCustomProtocol.SetXYmodemBlockWait(const NewWait : Cardinal);
    {-Set a new X/Ymodem block wait}
  begin
    if (NewWait <> FXYmodemBlockWait) or Force then begin
      FXYmodemBlockWait := NewWait;
      case TProtocolType(PData^.aCurProtocol) of
        ptXmodem..ptYmodemG :
          PData^.xBlockWait := NewWait;
      end;
    end;
  end;

  function TApdCustomProtocol.GetYModem128ByteBlocks: Boolean;           {!!.06}
    {-Get the YModem block size, not normally used }
  begin
    if PData^.aCurProtocol = ord(ptYModem) then
      Result := PData^.y128BlockMode
    else
      Result := False;
  end;

  procedure TApdCustomProtocol.SetYModem128ByteBlocks(const Value: Boolean);{!!.06}
    {-Set the YModem block size, not normally used }
  begin
    if PData^.aCurProtocol = ord(ptYModem) then
      PData^.y128BlockMode := Value;
  end;

  function TApdCustomProtocol.GetZmodemOptionOverride : Boolean;
    {-Return the zmodem override option}
  begin
    if PData^.aCurProtocol = Ord(ptZmodem) then
      FZmodemOptionOverride := PData^.ZFileMgmtOverride;
    Result := FZmodemOptionOverride;
  end;

  procedure TApdCustomProtocol.SetZmodemOptionOverride(
                               const NewOverride : Boolean);
    {-Enable/disable the zmodem option override option}
  begin
    if (NewOverride <> FZmodemOptionOverride) or Force then begin
      FZmodemOptionOverride := NewOverride;
      if PData^.aCurProtocol = Ord(ptZmodem) then
        PData^.ZFileMgmtOverride := NewOverride;
    end;
  end;

  function TApdCustomProtocol.GetZmodemSkipNoFile : Boolean;
    {-Return the zmodem skip no file option}
  begin
    if PData^.aCurProtocol = Ord(ptZmodem) then
      with PData^ do
        FZmodemSkipNoFile := (zFileMgmtOpts and FileSkipMask) <> 0;
    Result := FZmodemSkipNoFile;
  end;

  procedure TApdCustomProtocol.SetZmodemSkipNoFile(const NewSkip : Boolean);
    {-Enable/disable the skipnofile option}
  begin
    if (NewSkip <> FZmodemSkipNoFile) or Force then begin
      FZmodemSkipNoFile := NewSkip;
      if PData^.aCurProtocol = Ord(ptZmodem) then
        with PData^ do
          if NewSkip then
            zFileMgmtOpts := zFileMgmtOpts or FileSkipMask
          else
            zFileMgmtOpts := zFileMgmtOpts and not FileSkipMask;
    end;
  end;

  function TApdCustomProtocol.GetZmodemFileOption : TZmodemFileOptions;
    {-Return the zmodem file managment option}
  begin
    if PData^.aCurProtocol = Ord(ptZmodem) then
      FZmodemFileOption :=
        TZmodemFileOptions(PData^.zFileMgmtOpts and not FileSkipMask);
    Result := FZmodemFileOption;
  end;

  procedure TApdCustomProtocol.SetZmodemFileOption(
                               const NewOpt : TZmodemFileOptions);
    {-Set new file management options}
  var
    OldSkip : Boolean;
  begin
    if (NewOpt <> FZmodemFileOption) or Force then begin

      {Disallow zfoWriteCrc, it's not supported yet}
      if NewOpt = zfoWriteCrc then
        Exit;

      FZmodemFileOption := NewOpt;
      with PData^ do begin
        if aCurProtocol = Ord(ptZmodem) then begin
          OldSkip := ZmodemSkipNoFile;
          zFileMgmtOpts := Ord(NewOpt);
          if OldSkip then
            zFileMgmtOpts := zFileMgmtOpts or FileSkipMask;
        end;
      end;
    end;
  end;

  function TApdCustomProtocol.GetZmodemRecover : Boolean;
    {-Return the recovery option}
  begin
    if PData^.aCurProtocol = Ord(ptZmodem) then
      FZmodemRecover := PData^.zReceiverRecover;
    Result := FZmodemRecover;
  end;

  procedure TApdCustomProtocol.SetZmodemRecover(const NewRecover : Boolean);
    {-Enable/disable Zmodem crash recovery}
  begin
    if (NewRecover <> FZmodemRecover) or Force then begin
      FZmodemRecover := NewRecover;
      if PData^.aCurProtocol = Ord(ptZmodem) then
        PData^.zReceiverRecover := NewRecover;
    end;
  end;

  function TApdCustomProtocol.GetZmodem8K : Boolean;
    {-Return the state Zmodem's 8K mode}
  begin
    if PData^.aCurProtocol = Ord(ptZmodem) then
      FZmodem8K := PData^.zUse8KBlocks;
    Result := FZmodem8K;
  end;

  procedure TApdCustomProtocol.SetZmodem8K(const New8K : Boolean);
    {-Enable/disable 8K blocks}
  begin
    if (New8K <> FZmodem8K) or Force then begin
      FZmodem8K := New8K;
      if PData^.aCurProtocol = Ord(ptZmodem) then
        CheckException(Self, zpSetBigSubpacketOption(PData, New8K));
    end;
  end;

  function TApdCustomProtocol.GetZmodemZRQINITValue : Integer;
    {-Return the Zmodem's ZRQINIT value}
  begin
    if PData^.aCurProtocol = Ord(ptZmodem) then
      FZmodemZRQINITValue := PData^.zZRQINITValue;
    Result := FZmodemZRQINITValue;
  end;

  procedure TApdCustomProtocol.SetZmodemZRQINITValue(const NewZRQINITValue : Integer);
    {-Set the Zmodem's ZRQINIT value}
  begin
    if (NewZRQINITValue <> FZmodemZRQINITValue) or Force then begin
      FZmodemZRQINITValue := NewZRQINITValue;
      if PData^.aCurProtocol = Ord(ptZmodem) then
        PData^.zZRQINITValue := NewZRQINITValue;
    end;
  end;

  function TApdCustomProtocol.GetZmodemFinishRetry : Cardinal;
    {-Return the Zmodem finish retry count}
  begin
    if PData^.aCurProtocol = Ord(ptZmodem) then
      FZmodemFinishRetry := PData^.zFinishRetry;
    Result := FZmodemFinishRetry;
  end;

  procedure TApdCustomProtocol.SetZmodemFinishRetry(const NewRetry : Cardinal);
    {-Enable/disable 8K blocks}
  begin
    if (NewRetry <> FZmodemFinishRetry) or Force then begin
      FZmodemFinishRetry := NewRetry;
      if PData^.aCurProtocol = Ord(ptZmodem) then
        CheckException(Self,
          zpSetZmodemFinishWait(PData, PData^.aFinishWait, FZmodemFinishRetry));
    end;
  end;

  function TApdCustomProtocol.GetZmodemEscControl : Boolean;                // SWB
    {-Return the Zmodem escape control chars flag}                          // SWB
  begin                                                                     // SWB
    if PData^.aCurProtocol = Ord(ptZmodem) then                             // SWB
      FZmodemEscControl := PData^.zEscapeControl;                           // SWB
    Result := FZmodemEscControl;                                            // SWB
  end;                                                                      // SWB

  procedure TApdCustomProtocol.SetZmodemEscControl(const NewEsc : Boolean); // SWB
    {-Enable/disable escaping of control chars}                             // SWB
  begin                                                                     // SWB
    if (NewEsc <> FZmodemEscControl) or Force then begin                    // SWB
      FZmodemEscControl := NewEsc;                                          // SWB
      if PData^.aCurProtocol = Ord(ptZmodem) then                           // SWB
        PData^.zEscapeControl := FZmodemEscControl;                         // SWB
    end;                                                                    // SWB
  end;                                                                      // SWB

  function TApdCustomProtocol.GetKermitMaxLen : Cardinal;
    {-Return the max packet len (normal)}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then begin
      FKermitMaxLen := PData^.kKermitOptions.MaxLongPacketLen;
      if FKermitMaxLen = 0 then
        FKermitMaxLen := PData^.kKermitOptions.MaxPacketLen;
    end;
    Result := FKermitMaxLen;
  end;

  procedure TApdCustomProtocol.SetKermitMaxLen(const NewLen : Cardinal);
    {-Set a new max len}
  begin
    if (NewLen <> FKermitMaxLen) or Force then begin
      if NewLen <= 94 then begin
        FKermitMaxLen := NewLen;
        if PData^.aCurProtocol = Ord(ptKermit) then begin
          CheckException(Self, kpSetMaxPacketLen(PData, NewLen));
          CheckException(Self, kpSetMaxLongPacketLen(PData, 0));
        end;
      end else begin
        if NewLen > MaxKermitLongLen then
          FKermitMaxLen := MaxKermitLongLen
        else
          FKermitMaxLen := NewLen;
        if PData^.aCurProtocol = Ord(ptKermit) then
          CheckException(Self, kpSetMaxLongPacketLen(PData, NewLen));
      end;
    end;
  end;

  function TApdCustomProtocol.GetKermitMaxWindows : Cardinal;
    {-Return the maximum number of windows}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitMaxWindows := PData^.kKermitOptions.WindowSize;
    Result := FKermitMaxWindows;
  end;

  procedure TApdCustomProtocol.SetKermitMaxWindows(const NewMax : Cardinal);
    {-Set new max windows}
  begin
    if (NewMax <> FKermitMaxWindows) or Force then begin
      if NewMax > MaxKermitWindows then
        FKermitMaxWindows := MaxKermitWindows
      else
        FKermitMaxWindows := NewMax;

      {If not really using windows then disable SWC}
      if (NewMax = 0) or (NewMax = 1) then
        FKermitMaxWindows := 0;

      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self, kpSetMaxWindows(PData, FKermitMaxWindows));
    end;
  end;

  function TApdCustomProtocol.GetKermitSWCTurnDelay : Cardinal;
    {-Return the turn delay for when sliding windows are in use}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitSWCTurnDelay := PData^.kSWCTurnDelay;
    Result := FKermitSWCTurnDelay;
  end;

  procedure TApdCustomProtocol.SetKermitSWCTurnDelay(const NewDelay : Cardinal);
    {-Set new turn delay value for sliding windows}
  begin
    if (NewDelay <> FKermitSWCTurnDelay) or Force then begin
      FKermitSWCTurnDelay := NewDelay;
      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self, kpSetSWCTurnDelay(PData, NewDelay));
    end;
  end;

  function TApdCustomProtocol.GetKermitTimeoutSecs : Cardinal;
    {-Return the packet timeout, in seconds}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitTimeoutSecs := PData^.kKermitOptions.MaxTimeout;
    Result := FKermitTimeoutSecs;
  end;

  procedure TApdCustomProtocol.SetKermitTimeoutSecs(const NewTimeout : Cardinal);
    {-Set a new timeout value}
  begin
    if (NewTimeout <> FKermitTimeoutSecs) or Force then begin
      FKermitTimeoutSecs := NewTimeout;
      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self, kpSetMaxTimeoutSecs(PData, NewTimeout));
    end;
  end;

  function TApdCustomProtocol.GetKermitPadCharacter : AnsiChar;
    {-Return the new pad character}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitPadCharacter := PData^.kKermitOptions.PadChar;
    Result := FKermitPadCharacter;
  end;

  procedure TApdCustomProtocol.SetKermitPadCharacter(NewChar : AnsiChar);
    {-Set a new pad character}
  begin
    if (NewChar <> FKermitPadCharacter) or Force then begin
      FKermitPadCharacter := NewChar;
      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self,
          kpSetPacketPadding(PData, FKermitPadCharacter, FKermitPadCount));
    end;
  end;

  function TApdCustomProtocol.GetKermitPadCount : Cardinal;
    {-Return the pad count}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitPadCount := PData^.kKermitOptions.PadCount;
    Result := FKermitPadCount;
  end;

  procedure TApdCustomProtocol.SetKermitPadCount(NewCount : Cardinal);
    {-Set a new pad count}
  begin
    if (NewCount <> FKermitPadCount) or Force then begin
      FKermitPadCount := NewCount;
      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self,
          kpSetPacketPadding(PData, FKermitPadCharacter, FKermitPadCount));
    end;
  end;

  function TApdCustomProtocol.GetKermitTerminator : AnsiChar;
    {-Return the kermit terminator}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitTerminator := PData^.kKermitOptions.Terminator;
    Result := FKermitTerminator;
  end;

  procedure TApdCustomProtocol.SetKermitTerminator(const NewTerminator : AnsiChar);
    {-Set new terminator}
  begin
    if (NewTerminator <> FKermitTerminator) or Force then begin
      FKermitTerminator := NewTerminator;
      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self, kpSetTerminator(PData, NewTerminator));
    end;
  end;

  function TApdCustomProtocol.GetKermitCtlPrefix : AnsiChar;
    {-Return the control char prefix}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitCtlPrefix := PData^.kKermitOptions.CtlPrefix;
    Result := FKermitCtlPrefix;
  end;

  procedure TApdCustomProtocol.SetKermitCtlPrefix(const NewPrefix : AnsiChar);
    {-Set new ctrl char prefix}
  begin
    if (NewPrefix <> FKermitCtlPrefix) or Force then begin
      FKermitCtlPrefix := NewPrefix;
      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self, kpSetCtlPrefix(PData, NewPrefix));
    end;
  end;

  function TApdCustomProtocol.GetKermitHighbitPrefix : AnsiChar;
    {-Return the highbit prefix}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitHighbitPrefix := PData^.kKermitOptions.HibitPrefix;
    Result := FKermitHighbitPrefix;
  end;

  procedure TApdCustomProtocol.SetKermitHighbitPrefix(const NewPrefix : AnsiChar);
    {-Set new highbit prefix}
  begin
    if (NewPrefix <> FKermitHighbitPrefix) or Force then begin
      FKermitHighbitPrefix := NewPrefix;
      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self, kpSetHibitPrefix(PData, NewPrefix));
    end;
  end;

  function TApdCustomProtocol.GetKermitRepeatPrefix : AnsiChar;
    {-Return the repeat prefix}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      FKermitRepeatPrefix := PData^.kKermitOptions.RepeatPrefix;
    Result := FKermitRepeatPrefix;
  end;

  procedure TApdCustomProtocol.SetKermitRepeatPrefix(const NewPrefix : AnsiChar);
    {-Set a new repeat prefix}
  begin
    if (NewPrefix <> FKermitRepeatPrefix) or Force then begin
      FKermitRepeatPrefix := NewPrefix;
      if PData^.aCurProtocol = Ord(ptKermit) then
        CheckException(Self, kpSetRepeatPrefix(PData, NewPrefix));
    end;
  end;

  function TApdCustomProtocol.GetKermitWindowsTotal : Cardinal;
    {-Return the total number of windows negotiated}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      Result := kpGetSWCSize(PData)
    else
      Result := KermitMaxWindows;
  end;

  function TApdCustomProtocol.GetKermitWindowsUsed : Cardinal;
    {-Return the total number of windows filled with data}
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then
      Result := kpWindowsUsed(PData)
    else
      Result := 0;
  end;

  function TApdCustomProtocol.GetKermitLongBlocks : Boolean;
    {-Return True if long blocks are requested or negotiated}
  var
    Dummy : Cardinal;
    InUse : Bool;
  begin
    if PData^.aCurProtocol = Ord(ptKermit) then begin
      kpGetLPStatus(PData, InUse, Dummy);
      Result := InUse;
    end else
      Result := False;
  end;

  function TApdCustomProtocol.GetAsciiCharDelay : Cardinal;
    {-Return the inter-Char delay}
  begin
    if PData^.aCurProtocol = Ord(ptAscii) then
      FAsciiCharDelay := PData^.sInterCharDelay;
    Result := FAsciiCharDelay;
  end;

  procedure TApdCustomProtocol.SetAsciiCharDelay(const NewDelay : Cardinal);
    {-Set a new inter-char delay}
  begin
    if (NewDelay <> FAsciiCharDelay) or Force then begin
      FAsciiCharDelay := NewDelay;
      if PData^.aCurProtocol = Ord(ptAscii) then
        CheckException(Self,
          spSetDelays(PData, FAsciiCharDelay, FAsciiLineDelay));
    end;
  end;

  function TApdCustomProtocol.GetUpcaseFileNames : Boolean;
    {-Return the UpcaseFileNames value}
  begin
    Result := PData^.aUpcaseFileNames;
  end;

  procedure TApdCustomProtocol.SetUpcaseFileNames(NewUpcase : Boolean);
    {-Set a new UpcaseFileNames value}
  begin
    PData^.aUpcaseFileNames := NewUpcase;
  end;

  function TApdCustomProtocol.GetAsciiLineDelay : Cardinal;
    {-Return the inter-line delay}
  begin
    if PData^.aCurProtocol = Ord(ptAscii) then
      FAsciiLineDelay := PData^.sInterLineDelay;
    Result := FAsciiLineDelay;
  end;

  procedure TApdCustomProtocol.SetAsciiLineDelay(const NewDelay : Cardinal);
    {-Set a new inter-line delay}
  begin
    if (NewDelay <> FAsciiLineDelay) or Force then begin
      FAsciiLineDelay := NewDelay;
      if PData^.aCurProtocol = Ord(ptAscii) then
        CheckException(Self,
          spSetDelays(PData, FAsciiCharDelay, FAsciiLineDelay));
    end;
  end;

  function TApdCustomProtocol.GetAsciiEOLChar : AnsiChar;
    {-Return the EOL character}
  begin
    if PData^.aCurProtocol = Ord(ptAscii) then
      FAsciiEOLChar := PData^.sEOLChar;
    Result := FAsciiEOLChar;
  end;

  procedure TApdCustomProtocol.SetAsciiEOLChar(const NewChar : AnsiChar);
    {-Set new EOL char}
  begin
    if (NewChar <> FAsciiEOLChar) or Force then begin
      FAsciiEOLChar := NewChar;
      if PData^.aCurProtocol = Ord(ptAscii) then
        CheckException(Self, spSetEOLChar(PData, FAsciiEOLChar));
    end;
  end;

  function TApdCustomProtocol.GetAsciiCRTranslation : TAsciiEOLTranslation;
    {-Return the CR translation option}
  begin
    if PData^.aCurProtocol = Ord(ptAscii) then
      FAsciiCRTranslation := TAsciiEOLTranslation(PData^.sCRTransMode);
    Result := FAsciiCRTranslation;
  end;

  procedure TApdCustomProtocol.SetAsciiCRTranslation(
                            const NewTrans : TAsciiEOLTranslation);
    {-Set a new CR translation}
  begin
    if (NewTrans <> FAsciiCRTranslation) or Force then begin
      FAsciiCRTranslation := NewTrans;
      if PData^.aCurProtocol = Ord(ptAscii) then
        CheckException(Self,
          spSetEOLTranslation(PData, Ord(FAsciiCRTranslation),
                                     Ord(FAsciiLFTranslation)));
    end;
  end;

  function TApdCustomProtocol.GetAsciiLFTranslation : TAsciiEOLTranslation;
    {-Return LF translation option}
  begin
    if PData^.aCurProtocol = Ord(ptAscii) then
      FAsciiLFTranslation := TAsciiEOLTranslation(PData^.sLFTransMode);
    Result := FAsciiLFTranslation;
  end;

  procedure TApdCustomProtocol.SetAsciiLFTranslation(
                            const NewTrans : TAsciiEOLTranslation);
    {-Set a new LF translation}
  begin
    if (NewTrans <> FAsciiLFTranslation) or Force then begin
      FAsciiLFTranslation := NewTrans;
      if PData^.aCurProtocol = Ord(ptAscii) then
        CheckException(Self,
          spSetEOLTranslation(PData, Ord(FAsciiCRTranslation),
                                     Ord(FAsciiLFTranslation)));
    end;
  end;

  function TApdCustomProtocol.GetAsciiEOFTimeout : Cardinal;
    {-Return the EOF timeout value, in ticks}
  begin
    if PData^.aCurProtocol = Ord(ptAscii) then
      FAsciiEOFTimeout := PData^.aRcvTimeout;
    Result := FAsciiEOFTimeout;
  end;

  procedure TApdCustomProtocol.SetAsciiEOFTimeout(const NewTimeout : Cardinal);
    {-Set a new ascii timeout value}
  begin
    if (NewTimeout <> FAsciiEOFTimeout) or Force then begin
      FAsciiEOFTimeout := NewTimeout;
      if PData^.aCurProtocol = Ord(ptAscii) then
        CheckException(Self,
          spSetEOFTimeout(PData, FAsciiEOFTimeout));
    end;
  end;

  function TApdCustomProtocol.GetHonorDirectory : Boolean;
    {-Return the honor directory option}
  begin
    Result := PData^.aFlags and apHonorDirectory <> 0;
  end;

  procedure TApdCustomProtocol.SetHonorDirectory(const NewOpt : Boolean);
    {-Set the honordirectory option}
  begin
    with PData^ do
      if NewOpt <> (aFlags and apHonorDirectory <> 0) then
        if NewOpt then
          aFlags := aFlags or apHonorDirectory
        else
          aFlags := aFlags and not apHonorDirectory;
  end;

  function TApdCustomProtocol.GetIncludeDirectory : Boolean;
    {-Return the includedirectory option}
  begin
    Result := PData^.aFlags and apIncludeDirectory <> 0;
  end;

  procedure TApdCustomProtocol.SetIncludeDirectory(const NewOpt : Boolean);
    {-Set the include directory option}
  begin
    with PData^ do
      if NewOpt <> (aFlags and apIncludeDirectory <> 0) then
        if NewOpt then
          aFlags := aFlags or apIncludeDirectory
        else
          aFlags := aFlags and not apIncludeDirectory;
  end;

  function TApdCustomProtocol.GetRTSLowForWrite : Boolean;
    {-Return the RTSLowForWrite option}
  begin
    Result := PData^.aFlags and apRTSLowForWrite <> 0;
  end;

  procedure TApdCustomProtocol.SetRTSLowForWrite(const NewOpt : Boolean);
    {-Set the RTSLowForWrite option}
  begin
    with PData^ do
      if NewOpt <> (aFlags and apRTSLowForWrite <> 0) then
        if NewOpt then
          aFlags := aFlags or apRTSLowForWrite
        else
          aFlags := aFlags and not apRTSLowForWrite;
  end;

  function TApdCustomProtocol.GetAbortNoCarrier : Boolean;
    {-Return the AbortNoCarrier option}
  begin
    Result := PData^.aFlags and apAbortNoCarrier <> 0;
  end;

  procedure TApdCustomProtocol.SetAbortNoCarrier(const NewOpt : Boolean);
    {-Set the AbortNoCarrier option}
  begin
    with PData^ do
      if NewOpt <> (aFlags and apAbortNoCarrier <> 0) then
        if NewOpt then
          aFlags := aFlags or apAbortNoCarrier
        else
          aFlags := aFlags and not apAbortNoCarrier;
  end;

  { BP2KTransmit property is for the deprecated BPlus protocol, left }
  { here to prevent the 'missing property' error when updating from  }
  { previous versions }
  function TApdCustomProtocol.GetBP2KTransmit : Boolean;
    {-Return the BP2KTransmit option}
  begin
    Result := PData^.aFlags and apBP2KTransmit <> 0;
  end;

  procedure TApdCustomProtocol.SetBP2KTransmit(const NewOpt : Boolean);
    {-Set the BP2KTransmit option}
  begin
    with PData^ do
      if NewOpt <> (aFlags and apBP2KTransmit <> 0) then
        if NewOpt then
          aFlags := aFlags or apBP2KTransmit
        else
          aFlags := aFlags and not apBP2KTransmit;
  end;

  function TApdCustomProtocol.GetAsciiSuppressCtrlZ : Boolean;
    {-Return the AscciSuppressCtrlZ option}
  begin
    Result := PData^.aFlags and apAsciiSuppressCtrlZ <> 0;
  end;

  procedure TApdCustomProtocol.SetAsciiSuppressCtrlZ(const NewOpt : Boolean);
    {-Set the AsciiSuppressCtrlZ option}
  begin
    with PData^ do
      if NewOpt <> (aFlags and apAsciiSuppressCtrlZ <> 0) then
        if NewOpt then
          aFlags := aFlags or apAsciiSuppressCtrlZ
        else
          aFlags := aFlags and not apAsciiSuppressCtrlZ;
  end;

  procedure TApdCustomProtocol.SetBlockCheckMethod(
                               const NewMethod : TBlockCheckMethod);
    {-Set a new block check method}
  begin
    with PData^ do begin
      if (NewMethod <> TBlockCheckMethod(aCheckType)) and
         (aInProgress = 0) then begin
        case TProtocolType(PData^.aCurProtocol) of
           ptNoProtocol,
           ptXmodem1K, ptXmodem1KG,
           ptYmodem, ptYmodemG,
           ptAscii :
             {Don't change} ;
           ptXmodem :
             {Allow only switch to CRC}
             if NewMethod = bcmCrc16 then
               ProtocolType := ptXmodemCRC;
           ptXmodemCRC :
             {Allow only switch to checksum}
             if NewMethod = bcmChecksum then
               ProtocolType := ptXmodem;
           ptZmodem :
             {Allow only CRC16 and CRC32}
             case NewMethod of
               bcmCrc16, bcmCrc32 :
                 aCheckType := Cardinal(NewMethod);
             end;
           ptKermit :
             {Allow only Kermit types}
             case NewMethod of
               bcmChecksum, bcmChecksum2, bcmCrcK :
                 aCheckType := Cardinal(NewMethod);
             end;
        end;
      end;
    end;
  end;

  function TApdCustomProtocol.GetHandshakeRetry : Cardinal;
    {-Return the handshake retry count}
  begin
    Result := PData^.aHandshakeRetry;
  end;

  procedure TApdCustomProtocol.SetHandshakeRetry(const NewRetry : Cardinal);
    {-Set a new handshake retry value}
  begin
    with PData^ do
      if NewRetry <> aHandshakeRetry then
        aHandshakeRetry := NewRetry
  end;

  function TApdCustomProtocol.GetHandshakeWait : Cardinal;
    {-Return the handshake wait ticks}
  begin
    Result := PData^.aHandshakeWait;
  end;

  procedure TApdCustomProtocol.SetHandshakeWait(const NewWait : Cardinal);
    {-Set the handshake wait ticks}
  begin
    with PData^ do
      if NewWait <> aHandshakeWait then
        aHandshakeWait := NewWait;
  end;

  function TApdCustomProtocol.GetBlockLength : Cardinal;
    {-Return the current block length}
  begin
    if PData^.aInProgress <> 0 then begin
      Result := PData^.aLastBlockSize;
      if Result = 0 then
        Result := PData^.aBlockLen;
    end else
      Result := PData^.aBlockLen;
  end;

  function TApdCustomProtocol.GetBlockNumber : Cardinal;
    {-Return the current block number}
  begin
    Result := PData^.aBlockNum;
  end;

  function TApdCustomProtocol.GetTransmitTimeout : Cardinal;
    {-Return the current transmit timeout}
  begin
    Result := PData^.aTransTimeout;
  end;

  procedure TApdCustomProtocol.SetTransmitTimeout(const NewTimeout : Cardinal);
    {-Set a new transmit timeout}
  begin
    with PData^ do
      if NewTimeout <> aTransTimeout then
        aTransTimeout := NewTimeout;
  end;

  function TApdCustomProtocol.GetFinishWait : Cardinal;
    {-Return finish wait ticks}
  begin
    Result := PData^.aFinishWait;
  end;

  procedure TApdCustomProtocol.SetFinishWait(const NewWait : Cardinal);
    {-Set new finish wait ticks}
  begin
    with PData^ do
      if NewWait <> aFinishWait then
        aFinishWait := NewWait;
  end;

  function TApdCustomProtocol.GetActualBPS : Integer;
    {-Return actual CPS for protocol}
  begin
    Result := Integer(PData^.aActCPS) * 10;
  end;

  procedure TApdCustomProtocol.SetActualBPS(const NewBPS : Integer);
    {-Set the actual CPS for the protocol}
  begin
    with PData^ do begin
      NeedBPS := False;
      apSetActualBPS(PData, NewBPS);
    end;
  end;

  function TApdCustomProtocol.GetTurnDelay : Cardinal;
    {-Return the turnaround delay, in ticks}
  begin
    Result := PData^.aTurnDelay;
  end;

  procedure TApdCustomProtocol.SetTurnDelay(const NewDelay : Cardinal);
    {-Set the turnaround delay, in ticks}
  begin
    with PData^ do
      if NewDelay <> aTurnDelay then
        aTurnDelay := NewDelay;
  end;

  function TApdCustomProtocol.GetOverhead : Cardinal;
    {-Return number of overhead bytes}
  begin
    Result := PData^.aOverhead;
  end;

  procedure TApdCustomProtocol.SetOverhead(const NewOverhead : Cardinal);
    {-Set new number of overhead bytes}
  begin
    with PData^ do
      if NewOverhead <> aOverhead then
        aOverhead := NewOverhead;
  end;

  function TApdCustomProtocol.GetWriteFailAction : TWriteFailAction;
    {-Return writefail action}
  begin
    Result := TWriteFailAction(PData^.aWriteFailOpt);
  end;

  procedure TApdCustomProtocol.SetWriteFailAction(
                               const NewAction : TWriteFailAction);
    {-Set a new write fail action}
  begin
    with PData^ do
      if Ord(NewAction) <> aWriteFailOpt then
        aWriteFailOpt := Ord(NewAction);
  end;

  procedure TApdCustomProtocol.apwProtocolAccept(CP : TObject;
                                                 var Accept : Boolean;
                                                 var FName : TPassString);
    {-Internal event handling}
  begin
    Accept := True;
    if Assigned(FOnProtocolAccept) then
      FOnProtocolAccept(CP, Accept, FName);
  end;

  procedure TApdCustomProtocol.apwProtocolError(CP : TObject;
                                                ErrorCode : Integer);
    {-Internal event handling}
  begin
    if Assigned(FOnProtocolError) then
      FOnProtocolError(CP, ErrorCode);
  end;

  procedure TApdCustomProtocol.apwProtocolFinish(CP : TObject;
                                                 ErrorCode : Integer);
      {-Internal event handling}
  begin
    if Assigned (FComPort) then
      {FComPort.DeregisterUserCallback (apwPortCallback);}               {!!.03}
      FComPOrt.DeregisterUserCallbackEx(apwPortCallbackEx);              {!!.03}
    if Assigned(FOnProtocolFinish) then
      FOnProtocolFinish(CP, ErrorCode);
  end;

  procedure TApdCustomProtocol.apwProtocolLog(CP : TObject; Log : Cardinal);
    {-Internal event handling}
  begin
    {If LogProc is assigned then call it}
    if Assigned(FProtocolLog) then
      FProtocolLog.UpdateLog(Log);

    {If event handler is assigned then call it}
    if Assigned(FOnProtocolLog) then
      FOnProtocolLog(CP, Log);
  end;

  procedure TApdCustomProtocol.apwProtocolNextFile(CP : TObject;
                                                   var FName : TPassString);
    {-Internal event handling}
  var
    P : array[0..255] of AnsiChar;
  begin
    if Assigned(FOnProtocolNextFile) then
      FOnProtocolNextFile(CP, FName)
    else begin
      FillChar(P, SizeOf(P), 0);
      if apNextFileMask(PData, P) then
        FName := AnsiStrings.StrPas(P)
      else
        FName := '';
    end;
  end;

  procedure TApdCustomProtocol.apwProtocolResume(CP : TObject;
                                                 var Resume : TWriteFailAction);
    {-Internal event handling}
  begin
    if Assigned(FOnProtocolResume) then
      FOnProtocolResume(CP, Resume)
  end;

  procedure TApdCustomProtocol.apwProtocolStatus(CP : TObject; Options : Cardinal);
    {-Internal event handling}
  begin
    {Automatically hand off to status display, if one is attached}
    if Assigned(FStatusDisplay) then
      StatusDisplay.UpdateDisplay(Options and apFirstCall <> 0,
                                  Options and apLastCall <> 0);

    {Call user's event handler}
    if Assigned(FOnProtocolStatus) then
      FOnProtocolStatus(CP, Options);
  end;

  constructor TApdCustomProtocol.Create(AOwner : TComponent);
    {-Create the object instance}
  begin
    inherited Create(AOwner);

    {Inits}
    PData                := nil;
    Force                := False;
    FComPort             := nil;
    FProtocolType        := awpDefProtocolType;
    FStatusDisplay       := nil;
    FProtocolLog         := nil;
    FXYmodemBlockWait    := awpDefXYmodemBlockWait;
    FZmodemFileOption    := awpDefZmodemFileOption;
    FZmodemOptionOverride := awpDefZmodemOptionOverride;
    FZmodemSkipNoFile    := awpDefZmodemSkipNoFile;
    FZmodemRecover       := awpDefZmodemRecover;
    FZmodem8K            := awpDefZmodem8k;
    FZmodemZRQINITValue  := awpDefZmodemZRQINITValue;               
    FKermitMaxLen        := awpDefKermitMaxLen;
    FKermitMaxWindows    := awpDefKermitMaxWindows;
    FKermitSWCTurnDelay  := awpDefKermitSWCTurnDelay;
    FKermitTimeoutSecs   := awpDefKermitTimeoutSecs;
    FKermitTerminator    := awpDefKermitTerminator;
    FKermitCtlPrefix     := awpDefKermitCtlPrefix;
    FKermitHighbitPrefix := awpDefKermitHighbitPrefix;
    FKermitRepeatPrefix  := awpDefKermitRepeatPrefix;
    FAsciiCharDelay      := awpDefAsciiCharDelay;
    FAsciiLineDelay      := awpDefAsciiLineDelay;
    FAsciiEOLChar        := awpDefAsciiEOLChar;
    FAsciiCRTranslation  := awpDefAsciiCRTranslation;
    FAsciiLFTranslation  := awpDefAsciiLFTranslation;
    FAsciiEOFTimeout     := awpDefAsciiEOFTimeout;

    {Create the protocol element}
    NeedBPS := True;
    CheckException(Self, apInitProtocolData(PData, nil, DefProtocolOptions));

    {PData inits}
    HandshakeWait := awpDefHandshakeWait;
    HandshakeRetry := awpDefHandshakeRetry;
    TransmitTimeout := awpDefTransTimeout;
    FinishWait := awpDefFinishWait;
    TurnDelay := awpDefTurnDelay;
    Overhead := awpDefOverhead;
    HonorDirectory := awpDefHonorDirectory;
    IncludeDirectory := awpDefIncludeDirectory;
    RTSLowForWrite := awpDefRTSLowForWrite;
    AbortNoCarrier := awpDefAbortNoCarrier;
    BP2KTransmit := awpDefBP2KTransmit;
    AsciiSuppressCtrlZ := awpDefAsciiSuppressCtrlZ;
    UpcaseFileNames := awpDefUpcaseFileNames;

    {Option inits}
    with PData^ do begin
      aFlags := 0;
      if awpDefHonorDirectory then
        aFlags := aFlags or apHonorDirectory;
      if awpDefIncludeDirectory then
        aFlags := aFlags or apIncludeDirectory;
      if awpDefRTSLowForWrite then
        aFlags := aFlags or apRTSLowForWrite;
      if awpDefAbortNoCarrier then
        aFlags := aFlags or apAbortNoCarrier;
      if awpDefBP2KTransmit then
        aFlags := aFlags or apBP2KTransmit;
      if awpDefAsciiSuppressCtrlZ then
        aFlags := aFlags or apAsciiSuppressCtrlZ;
    end;

    {Search for comport}
    FComPort := SearchComPort(Owner);

    {Search for protocol status display}
    StatusDisplay := SearchStatusDisplay(Owner);

    {Search for protocol log}
    FProtocolLog := SearchProtocolLog(Owner);
    if Assigned(FProtocolLog) then
      ProtocolLog.FProtocol := Self;

    {Create the message handler instance...}
    if not (csDesigning in ComponentState) then begin
      RegisterMessageHandlerClass;
      CreateMessageHandler;
      FProtocolType := ptNoProtocol;
    end else begin
      FProtocolType := ptNoProtocol;
      SetProtocolType(awpDefProtocolType);
    end;
  end;

  destructor TApdCustomProtocol.Destroy;
    {-Destroy the object instance}
  var
    I : Cardinal;
    P : PProtocolWindowNode;
  begin
    {Get rid of msg handler window and node}
    if not (csDesigning in ComponentState) then
      with ProtList do
        if Count > 0 then
          for I := 0 to Count-1 do begin
            P := PProtocolWindowNode(Items[I]);
            if P^.pwProtocol = Self then begin
              DestroyWindow(P^.pwWindow);
              Remove(Items[I]);
              Dispose(P);
              break;
            end;
          end;

    ProtocolType := ptNoProtocol;
    apDoneProtocol(PData);
    inherited Destroy;
  end;

  procedure TApdCustomProtocol.Assign(Source : TPersistent);
    {-Assign Source to Self}
  var
    SrcType : TProtocolType;

  begin
    if Source is TApdCustomProtocol then begin
      {Note the current protocol type, then force deallocation of
       internal pointers}
      SrcType := TApdCustomProtocol(Source).ProtocolType;
      TApdCustomProtocol(Source).ProtocolType := ptNoProtocol;

      {Force the destination to noprotocol as well}
      ProtocolType := ptNoProtocol;

      {Free the existing critsection pointer}
      DeleteCriticalSection(PData^.aProtSection);

      {Assign new property values}
      Move(TApdCustomProtocol(Source).PData^, PData^, SizeOf(TProtocolData));

      {Overwrite the copied critsection pointer with our own}
      InitializeCriticalSection(PData^.aProtSection);

      NeedBPS           := TApdCustomProtocol(Source).NeedBPS;
      ProtFunc          := TApdCustomProtocol(Source).ProtFunc;
      Force             := TApdCustomProtocol(Source).Force;
      FMsgHandler       := TApdCustomProtocol(Source).FMsgHandler;
      FComPort          := TApdCustomProtocol(Source).FComPort;
      FStatusDisplay    := TApdCustomProtocol(Source).FStatusDisplay;
      FProtocolLog      := TApdCustomProtocol(Source).FProtocolLog;
      FXYmodemBlockWait := TApdCustomProtocol(Source).FXYmodemBlockWait;
      FZmodemOptionOverride := TApdCustomProtocol(Source).FZmodemOptionOverride;
      FZmodemSkipNoFile := TApdCustomProtocol(Source).FZmodemSkipNoFile;
      FZmodemFileOption := TApdCustomProtocol(Source).FZmodemFileOption;
      FZmodemRecover    := TApdCustomProtocol(Source).FZmodemRecover;
      FZmodem8K         := TApdCustomProtocol(Source).FZmodem8K;
      FZmodemZRQINITValue := TApdCustomProtocol(Source).FZmodemZRQINITValue; 
      FKermitMaxLen     := TApdCustomProtocol(Source).FKermitMaxLen;
      FKermitMaxWindows := TApdCustomProtocol(Source).FKermitMaxWindows;
      FKermitSWCTurnDelay := TApdCustomProtocol(Source).FKermitSWCTurnDelay;
      FKermitTimeoutSecs := TApdCustomProtocol(Source).FKermitTimeoutSecs;
      FKermitTerminator := TApdCustomProtocol(Source).FKermitTerminator;
      FKermitCtlPrefix  := TApdCustomProtocol(Source).FKermitCtlPrefix;
      FKermitHighbitPrefix := TApdCustomProtocol(Source).FKermitHighbitPrefix;
      FKermitRepeatPrefix := TApdCustomProtocol(Source).FKermitRepeatPrefix;
      FAsciiCharDelay   := TApdCustomProtocol(Source).FAsciiCharDelay;
      FAsciiLineDelay   := TApdCustomProtocol(Source).FAsciiLineDelay;
      FAsciiEOLChar     := TApdCustomProtocol(Source).FAsciiEOLChar;
      FAsciiCRTranslation := TApdCustomProtocol(Source).FAsciiCRTranslation;
      FAsciiLFTranslation := TApdCustomProtocol(Source).FAsciiLFTranslation;
      FAsciiEOFTimeout  := TApdCustomProtocol(Source).FAsciiEOFTimeout;
      FOnProtocolAccept   := TApdCustomProtocol(Source).FOnProtocolAccept;
      FOnProtocolError    := TApdCustomProtocol(Source).FOnProtocolError;
      FOnProtocolFinish   := TApdCustomProtocol(Source).FOnProtocolFinish;
      FOnProtocolLog      := TApdCustomProtocol(Source).FOnProtocolLog;
      FOnProtocolNextFile := TApdCustomProtocol(Source).FOnProtocolNextFile;
      FOnProtocolResume   := TApdCustomProtocol(Source).FOnProtocolResume;
      FOnProtocolStatus   := TApdCustomProtocol(Source).FOnProtocolStatus;

      {Set both protocols back to the src protocol type}
      ProtocolType        := SrcType;
      TApdCustomProtocol(Source).ProtocolType := SrcType;
    end;
  end;

  function TApdCustomProtocol.EstimateTransferSecs(const Size : Integer) : Integer;
    {-Returns ticks to send Size bytess}
  begin
    Result := apEstimateTransferSecs(PData, Size);
  end;

{  procedure TApdCustomProtocol.apwPortCallback (CP      : TObject;      {!!.03}
{                                                Opening : Boolean);
  begin
    if (not Opening) and (InProgress) then
      CancelProtocol;
  end;}

  procedure TApdCustomProtocol.apwPortCallbackEx(CP: TObject;
    CallbackType: TApdCallbackType);
  begin
    if InProgress and (CallbackType in [ctClosing, ctClosed]) then
      CancelProtocol;
  end;


  function TApdCustomProtocol.StatusMsg(const Status : Cardinal) : AnsiString;
    {-Return a resource string for Status}
  var
    P : array[0..MaxMessageLen] of AnsiChar;
  begin
    apStatusMsg(P, Status);
    Result := AnsiStrings.StrPas(P);
  end;

  procedure TApdCustomProtocol.StartTransmit;
    {-Start a transmit protocol session}
  begin
    with PData^ do begin
      {Exit quitely if no protocol selected}
      if FProtocolType = ptNoProtocol then
        Exit;

      {Make sure comport is open, pass handle to protocol}
      CheckPort;
      if Assigned(FComPort) then begin                                 
        apSetProtocolPort(PData, FComPort);
        {FComPort.RegisterUserCallback (apwPortCallback);}               {!!.03}
        FComPort.RegisterUserCallbackEx(apwPortCallbackEx);              {!!.03}
      end else                                                         
        raise EPortNotAssigned.Create(ecPortNotAssigned, False);

      {Set the protocol's aActCPS field if it isn't already set}
      if NeedBPS then with FComPort do begin
        ActualBPS := Baud;
        NeedBPS := False;
      end;

      {Start the protocol}
      if (FProtocolType >= ptNoProtocol) and
         (FProtocolType <= ptAscii) then begin
        ProtFunc := ProtFuncs[FProtocolType, True];
        apStartProtocol(PData, Ord(FProtocolType), True,
                        PrepProcs[FProtocolType, True],
                        ProtFunc);
      end;
    end;
  end;

  procedure TApdCustomProtocol.StartReceive;
    {-Start a protocol receive session}
  begin
    with PData^ do begin
      {Exit quietly if no protocol selected}
      if FProtocolType = ptNoProtocol then
        Exit;

      {Make sure comport is open, pass handle to protocol}
      if Assigned(FComPort) then begin                                 
        apSetProtocolPort(PData, FComPort);
        {FComPort.RegisterUserCallback (apwPortCallback);}               {!!.03}
        FComPort.RegisterUserCallbackEx(apwPortCallbackEx);              {!!.03}
      end else                                                         
        raise EPortNotAssigned.Create(ecPortNotAssigned, False);

      {Set the protocol's aActCPS field if it isn't already set}
      if NeedBPS then with FComPort do begin
        ActualBPS := Baud;
        NeedBPS := False;
      end;

      {Start the protocol}
      if (FProtocolType >= ptNoProtocol) and
         (FProtocolType <= ptAscii) then begin
        ProtFunc := ProtFuncs[FProtocolType, False];
        apStartProtocol(PData, Ord(FProtocolType), True,
                        PrepProcs[FProtocolType, False],
                        ProtFunc);
      end;
    end;
  end;

  procedure TApdCustomProtocol.CancelProtocol;
    {-Sends apw_ProtocolCancel message to protocol function}
  begin
    with PData^ do
      if (@ProtFunc <> nil) and InProgress then
        ProtFunc(APW_PROTOCOLCANCEL, 0, Integer(aHC.ValidDispatcher.handle) shl 16)
  end;

{TApdAbstractStatus}

  procedure TApdAbstractStatus.Notification(AComponent : TComponent;
                                            Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      if AComponent = FProtocol then
        FProtocol := nil;
    end;
  end;

  procedure TApdAbstractStatus.SetPosition(const NewPosition : TPosition);
  begin
    if NewPosition <> FPosition then begin
      FPosition := NewPosition;
      if Assigned(FDisplay) then
        FDisplay.Position := NewPosition;
    end;
  end;

  procedure TApdAbstractStatus.SetCtl3D(const NewCtl3D : Boolean);
  begin
    if NewCtl3D <> FCtl3D then begin
      FCtl3D := NewCtl3D;
      if Assigned(FDisplay) then
        FDisplay.Ctl3D := NewCtl3D;
    end;
  end;

  procedure TApdAbstractStatus.SetVisible(const NewVisible : Boolean);
  begin
    if NewVisible <> FVisible then begin
      FVisible := NewVisible;
      if Assigned(FDisplay) then
        FDisplay.Visible := NewVisible;
    end;
  end;

  procedure TApdAbstractStatus.SetCaption(const NewCaption : TCaption);
  begin
    if NewCaption <> FCaption then begin
      FCaption := NewCaption;
      if Assigned(FDisplay) then
        FDisplay.Caption := NewCaption;
    end;
  end;                                                                   

  procedure TApdAbstractStatus.GetProperties;
  begin
    if Assigned(FDisplay) then begin
      Position := FDisplay.Position;
      Ctl3D    := FDisplay.Ctl3D;
      Visible  := FDisplay.Visible;
      Caption  := FDisplay.Caption;                                 
    end;
  end;

  constructor TApdAbstractStatus.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    CreateDisplay;
    GetProperties;
    Caption := 'Protocol Status';                                  
  end;

  destructor TApdAbstractStatus.Destroy;
  begin
    DestroyDisplay;
    inherited Destroy;
  end;

  procedure TApdAbstractStatus.Show;
  begin
    if Assigned(FDisplay) then
      FDisplay.Show;
  end;

{TApdProtocolLog}

  procedure TApdProtocolLog.Notification(AComponent : TComponent;
                                         Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      {Owned components going away}
      if AComponent = FProtocol then
        FProtocol := nil;
    end;
  end;

  constructor TApdProtocolLog.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);

    {Inits}
    HistoryName := awpDefHistoryName;
    DeleteFailed := awpDefDeleteFailed;
  end;

  procedure TApdProtocolLog.UpdateLog(const Log : Cardinal);
    {-Update the standard log}
  var
    CPS : Cardinal;
    HisFile : TextFile;

    function DirectionString : AnsiString;
    begin
      case Log of
        lfReceiveStart, lfReceiveOk, lfReceiveSkip, lfReceiveFail :
          DirectionString := ' receive ';
        lfTransmitStart, lfTransmitOk, lfTransmitFail, lfTransmitSkip :
          DirectionString := ' transmit ';
      end;
    end;

  begin
    {Exit if no name specified}
    if FHistoryName = '' then
      Exit;

    {Create or open the history file}
    try
      AssignFile(HisFile, string(FHistoryName));
      Append(HisFile);
    except
      on E : EInOutError do
        if E.ErrorCode = 2 then
          {File not found, open as new}
          Rewrite(HisFile)
        else
          {Unexpected error, forward the exception}
          raise;
    end;

    {Write the log entry}
    with Protocol, pData^ do begin
      case Log of
        lfReceiveStart,
        lfTransmitStart :
          WriteLn(HisFile, ProtocolName(ProtocolType),
                           DirectionString,
                           'started on  ',
                           DateTimeToStr(Now), ' : ',
                           FileName);

        lfReceiveOk,
        lfTransmitOK :
          begin
            WriteLn(HisFile, ProtocolName(ProtocolType),
                             DirectionString,
                             'finished OK ',
                             DateTimeToStr(Now), ' : ',
                             FileName);
            if ElapsedTicks < 18 then
              CPS := FileLength
            else
              CPS := (FileLength div Ticks2Secs(ElapsedTicks));
            WriteLn(HisFile, '   Elapsed time: ',
                             FormatMinSec(Ticks2Secs(ElapsedTicks)),
                          '   CPS: ', CPS,
                          '   Size: ', FileLength, ^M^J);
          end;

        lfReceiveSkip :
          WriteLn(HisFile, ProtocolName(ProtocolType),
                           ' receive skipped ', FileName, ' ',
                           StatusMsg(ProtocolStatus), ^M^J);

        lfReceiveFail :
          begin
            WriteLn(HisFile, ProtocolName(ProtocolType),
                             ' receive failed ', FileName, ' ',
                             StatusMsg(ProtocolStatus), ^M^J);

            case FDeleteFailed of
              dfNever  :
                {Leave the partial file intact} ;
              dfAlways :
                if aProtocolError <> ecCantWriteFile then
                  DeleteFile(string(FileName));
              dfNonRecoverable :
                if (ProtocolType <> ptZmodem) and
                   (aProtocolError <> ecCantWriteFile) then
                  DeleteFile(string(FileName));
            end;
          end;

        lfTransmitFail :
          WriteLn(HisFile, ProtocolName(ProtocolType),
                           ' transmit failed ', FileName, ' ',
                           StatusMsg(ProtocolStatus), ^M^J);
        lfTransmitSkip :
          WriteLn(HisFile, ProtocolName(ProtocolType),
                           ' transmit skipped ', FileName, ' ',
                           StatusMsg(ProtocolStatus), ^M^J);
      end;
    end;

    Close(HisFile);
    if IOResult <> 0 then ;
  end;

{Miscellaneous functions}

  function ProtocolName(const ProtocolType : TProtocolType) : AnsiString;
    {-Return a string of the protocol type}
  begin
    if (ProtocolType >= ptNoProtocol) and (ProtocolType <= ptAscii) then
      Result := AnsiStrings.StrPas(ProtocolString[Ord(ProtocolType)])
    else
      Result := AnsiStrings.StrPas(ProtocolString[0]);
  end;

  function CheckNameString(const Check : TBlockCheckMethod) : AnsiString;
    {-Return a string of the block check type}
  begin
    case Check of
      bcmChecksum   : Result := bcsChecksum1;
      bcmChecksum2  : Result := bcsChecksum2;
      bcmCrc16      : Result := bcsCrc16;
      bcmCrc32      : Result := bcsCrc32;
      bcmCrcK       : Result := bcsCrcK;
      else            Result := bcsNone;
    end;
  end;

  function FormatMinSec(const TotalSecs : Integer) : AnsiString;
    {-Format TotalSecs as minutes:seconds, leftpadded to 6}
  var
    Min, Sec : Integer;
    S : AnsiString;
  begin
    Min := TotalSecs div 60;
    Sec := TotalSecs mod 60;
    Str(Sec:2, S);
    if S[1] = ' ' then
      S[1] := '0';
    FormatMinSec := LeftPad(AnsiString(IntToStr(Min) + ':' + string(S)), 6);
  end;

initialization
  ProtList := TList.Create;

finalization
  ProtList.Free;
end.

