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
{*                    AWTPCL.PAS 4.06                    *}
{*********************************************************}
{* Protocol type definitions                             *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AwTPcl;
  {Type definitions for protocol units}

interface
uses
  Windows,
  SysUtils,
  OoMisc,
  AdPort, 
  AwUser;

const
  {Compile-time options}
  FileBufferSize = 8192;     {Size of buffer for receive/xmitting files}
  awpDefHandshakeWait = 182; {Wait time for resp during handshake (10 sec)}
  awpDefHandshakeRetry = 10; {Number of times to retry handshake}
  awpDefTransTimeout = 1092; {Ticks to wait for receiver flow control release}
  apMaxBlockSize = 1024;     {Maximum block size for most protocols}  
  BlockFillChar : AnsiChar = ^Z; {Fill character for partial protocol blocks}
  TelixDelay = 9;            {Delay handshake for 9 Ticks (for Telix)}
                 
const
  MaxWindowSlots = 27;       {Avoids MS-Kermit bug}
  BPTimeoutMax     = 546;    {Max Ticks allowed timeout per-char, 30 seconds}
  BPErrorMax       = 10;     {Max sequential errors}
  BPBufferMax      = 2048;   {Largest data block available}
  BPSendAheadMax   = 2;      {Max number of packets we can send ahead (normal)}
  BPDefFinishWait  = 273;    {Wait time for error ack, 15 seconds}
  ESCIResponse : String[31] = '#IB1,SSxx,GF,PB,DT';

type
  {Possible results for start block characters}
  TProcessBlockStart = (pbsNone, pbs128, pbs1024, pbsCancel, pbsEOT);

  {Holds info about Kermit data in Window slots}
  TSlotInfo = record
    Len     : Integer;
    Seq     : Integer;
    InUse   : Bool;
    Acked   : Bool;
    Retries : Cardinal;
  end;

  {Sliding window table, info}
  TInfoTable = array[1..MaxWindowSlots] of TSlotInfo;

  {Sliding window table, data}
  PDataTable = ^TDataTable;
  TDataTable = array[0..(MaxWindowSlots*1024)-1] of AnsiChar;

type
  {Xmodem protocol states}
  TXmodemState = (
    {Transmit states}
    txInitial,              {Open file, log it, etc.}
    txHandshake,            {Waiting for handshake}
    txGetBlock,             {Get the next block to transmit}
    txWaitFreeSpace,        {Wait until outbuffer has enough freespace}
    txSendBlock,            {Send next protocol block}
    txDraining,             {Waiting for protocol block to drain}
    txReplyPending,         {Waiting for reply to last block}
    txEndDrain,             {Wait for output buffer to drain before EOT}
    txFirstEndOfTransmit,   {Send first EOT}
    txRestEndOfTransmit,    {Send subseqent EOTs}
    txEotReply,             {Waiting for EOT reply}
    txFinished,             {Close file, log it, etc.}
    txDone,                 {Signal end of protocol}

    {Receive states}
    rxInitial,              {Initialize vars, get buffers, etc.}
    rxWaitForHSReply,       {Waiting for 1st reply to handshake}
    rxWaitForBlockStart,    {Wait for block start}
    rxCollectBlock,         {Collect data}
    rxProcessBlock,         {Process block}
    rxFinishedSkip,         {Close file, log as skip}
    rxFinished,             {Close file, log as good/bad}
    rxDone);                {Signal end of protocol}

  {Ymodem protocol transmit states}
  TYmodemState = (
    {Transmit states}
    tyInitial,              {Get next file}
    tyHandshake,            {Waiting for handshake}
    tyGetFileName,          {Get the next file to transmit}
    tySendFileName,         {Format and send file name block}
    tyDraining,             {Waiting for protocol block to drain}
    tyReplyPending,         {Waiting for reply to name block}
    tyPrepXmodem,           {Prepare to enter Xmodem state table}
    tySendXmodem,           {Calling Xmodem state table}
    tyFinished,             {Send EOT block}
    tyFinishDrain,          {Wait for EOT to block to drain}
    tyDone,                 {Signal end of protocol}

    {Receive states}
    ryInitial,              {Initialize vars, get buffers, etc.}
    ryDelay,                {Delay the handshake for Telix}
    ryWaitForHSReply,       {Waiting for 1st reply to handshake}
    ryWaitForBlockStart,    {Wait for block start}
    ryCollectBlock,         {Collect received chars into DataBlock}
    ryProcessBlock,         {Process complete DataBlock}
    ryOpenFile,             {Extract file info}
    ryPrepXmodem,           {Prepare to enter Xmodem state}
    ryReceiveXmodem,        {Calling Xmodem state table}
    ryFinished,             {Clean up}
    ryDone);                {Signal end of protocol}

  {Main Zmodem state table}
  TZmodemState = (
    {Transmit states}
    tzInitial,       {Allocates buffers, sends zrqinit}
    tzHandshake,     {Wait for hdr (zrinit), rsend zrqinit on timout}
    tzGetFile,       {Call NextFile, build ZFile packet}
    tzSendFile,      {Send ZFile packet}
    tzCheckFile,     {Wait for hdr (zrpos), set next state to tzData}
    tzStartData,     {Send ZData and next data subpacket}
    tzEscapeData,    {Check for header, escape next block}
    tzSendData,      {Wait for free space in buffer, send escaped block}
    tzWaitAck,       {Wait for Ack on ZCRCW packets}
    tzSendEof,       {Send eof}
    tzDrainEof,      {Wait for output buffer to drain}
    tzCheckEof,      {Wait for hdr (zrinit)}
    tzSendFinish,    {Send zfin}
    tzCheckFinish,   {Wait for hdr (zfin)}
    tzError,         {Cleanup after errors}
    tzCleanup,       {Release buffers and other cleanup}
    tzDone,          {Signal end of protocol}
    tzSInit,         {Send ZSInit packet}                                   // SWB
    tzCheckSInit,    {Wait for Ack to ZSInit packet}                        // SWB

    {Receive states}
    rzRqstFile,      {Send zrinit}
    rzDelay,         {Delay handshake for Telix}
    rzWaitFile,      {Waits for hdr (zrqinit, zrfile, zsinit, etc)}
    rzCollectFile,   {Collect file info into work block}
    rzSendInit,      {Extract send init info}
    rzSendBlockPrep, {Discard last two chars of previous hex packet}
    rzSendBlock,     {Collect sendinit block}
    rzSync,          {Send ZrPos with current file position}
    rzStartFile,     {Extract file info, prepare writing, etc., put zrpos}
    rzStartData,     {Wait for hdr (zrdata)}
    rzCollectData,   {Collect data subpacket}
    rzGotData,       {Got dsp, put it}
    rzWaitEof,       {Wait for hdr (zreof)}
    rzEndOfFile,     {Close file, log it, etc}
    rzSendFinish,    {Send ZFin, goto rzWaitOO}
    rzCollectFinish, {Check for OO, goto rzFinish}
    rzError,         {Handle errors while file was open}
    rzWaitCancel,    {Wait for the cancel to leave the outbuffer}
    rzCleanup,       {Clean up buffers, etc.}
    rzDone);         {Signal end of protocol}

  {General header collection states}
  THeaderState = (
    hsNone,          {Not currently checking for a header}
    hsGotZPad,       {Got initial or second asterisk}
    hsGotZDle,       {Got ZDle}
    hsGotZBin,       {Got start of binary header}
    hsGotZBin32,     {Got start of binary 32 header}
    hsGotZHex,       {Got start of hex header}
    hsGotHeader);    {Got complete header}

  {Hex header collection states}
  HexHeaderStates = (
    hhFrame,         {Processing frame type char}
    hhPos1,          {Processing 1st position info byte}
    hhPos2,          {Processing 2nd position info byte}
    hhPos3,          {Processing 3rd position info byte}
    hhPos4,          {Processing 4th position info byte}
    hhCrc1,          {Processing 1st CRC byte}
    hhCrc2);         {Processing 2nd CRC byte}

  {Binary header collection states}
  BinaryHeaderStates = (
    bhFrame,         {Processing frame type char}
    bhPos1,          {Processing 1st position info byte}
    bhPos2,          {Processing 2nd position info byte}
    bhPos3,          {Processing 3rd position info byte}
    bhPos4,          {Processing 1th position info byte}
    bhCrc1,          {Processing 1st CRC byte}
    bhCrc2,          {Processing 2nd CRC byte}
    bhCrc3,          {Processing 3rd CRC byte}
    bhCrc4);         {Processing 4th CRC byte}

  {Only two states possible when receiving blocks}
  ReceiveBlockStates = (
    rbData,          {Receiving data bytes}
    rbCrc);          {Receiving block check bytes}

  {Kermit state machine states}
  TKermitState = (
    {Transmit states}
    tkInit,           {Send SendInit packet}
    tkInitReply,      {Wait for header reply to SendInit}
    tkCollectInit,    {Collect data packet for SendInit reply}
    tkOpenFile,       {Open next file to transmit}
    tkSendFile,       {Send File packet}
    tkFileReply,      {Wait for header reply to File}
    tkCollectFile,    {Collect data packet for File reply}
    tkCheckTable,     {Check table for space, escape next block if room}
    tkSendData,       {Send next Data packet}
    tkBlockReply,     {Wait for header reply to Data}
    tkCollectBlock,   {Collect data packet for Data reply}
    tkSendEof,        {Send Eof packet}
    tkEofReply,       {Wait for header reply to Eof}
    tkCollectEof,     {Collect data packet for Eof reply}
    tkSendBreak,      {Send Break packet}
    tkBreakReply,     {Wait for header reply to Break}
    tkCollectBreak,   {Collect data packet for Break reply}
    tkComplete,       {Send Complete packet}
    tkWaitCancel,     {Wait for cancel to go out}
    tkError,          {Done, log and clean up}
    tkDone,           {Signals end of protocol}

    {Receive states}
    rkInit,           {Set initial timer}
    rkGetInit,        {Wait for SendInit header}
    rkCollectInit,    {Collect SendInit data field}
    rkGetFile,        {Wait for File header}
    rkCollectFile,    {Collect File data field}
    rkGetData,        {Wait for Data header}
    rkCollectData,    {Collect Data data field}
    rkComplete,       {Normal completion}
    rkWaitCancel,     {Wait for cancel to go out}
    rkError,          {Error completion}
    rkDone);          {Signals end of protocolcompletion}

  {Header state machine states}
  TKermitHeaderState = (
    hskNone,           {No header collection in process}
    hskGotMark,        {Got mark}
    hskGotLen,         {Got length byte}
    hskGotSeq,         {Got sequence number}
    hskGotType,        {Got packet type}
    hskGotLong1,       {Got first byte of long length}
    hskGotLong2,       {Got second byte of long length}
    hskDone);          {Got everything}

  TKermitDataState = (
    dskData,           {Collecting data bytes}
    dskCheck1,         {Collecting check bytes}
    dskCheck2,         {Collecting check bytes}
    dskCheck3);        {Collecting check bytes}

type
  {B+ buffer}
  PBPDataBlock = ^TBPDataBlock;
  TBPDataBlock = array[1..BPBufferMax] of AnsiChar;

  {B+ window buffer}
  TSABuffer = record
    Seq   : Cardinal;                {Sequence number}
    Num   : Cardinal;                {Packet's data size}
    PType : AnsiChar;                {Packet type}
    Buf   : PBPDataBlock;        {Packet's data}
  end;
  TSPackets = array[1..BPSendAheadMax] of TSABuffer;

  {For quoting params sets and all data}
  TQuoteArray = array[0..7] of Byte;
  TQuoteTable = array[0..255] of AnsiChar;

type
  {Main BPlus state table}
  TBPlusState = (
    {Receive states}
    rbInitial,         {Start waiting for first N packet}
    rbGetDLE,          {Get header start, <DLE>}
    rbGetB,            {Get B of header start}
    rbCollectPacket,   {Collect packet, checksum and verify}
    rbProcessPacket,   {Check packet type and dispatch}
    rbFinished,        {Normal end of protocol}
    rbSendEnq,         {Send <ENQ><ENQ> after a timeout}
    rbError,           {Error end of protocol}
    rbWaitErrorAck,    {Wait for Ack for failure packet}
    rbCleanup,         {Cleanup and end protocol}
    rbDone,            {Signal end}

    {Transmit states}
    tbInitial,         {Startup stuff}
    tbGetBlock,        {Read next block to xmit}
    tbWaitFreeSpace,   {Wait for free space to send block}
    tbSendData,        {Transmit the next block}
    tbCheckAck,        {Wait for acknowledgements (handle re-xmits)}
    tbEndOfFile,       {Send TC packet}
    tbEofAck,          {Wait for TC ack}
    tbError,           {Failed}
    tbWaitErrorAck,    {Wait for Ack for failure packet}
    tbCleanup,         {Cleanup and end protocol}
    tbDone);           {Signal end}

  {Packet collection states}
  TPacketState = (
    psGetDLE,          {Waiting for DLE}
    psGetB,            {Waiting for B}
    psGetSeq,          {Waiting for sequence number}
    psGetType,         {Get type byte}
    psGetData,         {Collecting data}
    psGetCheck1,       {Waiting for first check byte}
    psGetCheck2,       {Waiting for second check byte, if any}
    psCheckCheck,      {Checking block check}
    psSendAck,         {OK, sending ACK (finished)}
    psError,           {Error collecting packet}
    psSuccess);        {Packet collected OK}

  {Terminal packet state, when processing packets in terminal mode}
  TTermPacketState = (
    tpsWaitB,          {Waiting for B}
    tpsWaitSeq,        {Waiting for sequence}
    tpsWaitType,       {Waiting for packet type, process when found}
    tpsCollectPlus,    {Collecting + packet}
    tpsCollectAckPlus, {Collecting ack from + response}
    tpsCollectT,       {Collecting T packet}
    tpsCollectAckT,    {Collecting ack from optional T response}
    tpsError);         {Error collecting packet}

  {Ack collection state}
  TAckCollectionState = (
    acGetDLE,          {Wait for DLE}
    acGetNum,          {Wait for packet number}
    acHaveAck,         {Got ack, check sequence}
    acGetPacket,       {Got packet, start collecting}
    acCollectPacket,   {Collect packet}
    acSkipPacket1,     {Discard packet data}
    acSkipPacket2,     {Discard 1st checksum byte}
    acSkipPacket3,     {Discard quoted part of 1st checksum byte}
    acSkipPacket4,     {Discard 2nd checksum byte}
    acSkipPacket5,     {Discard quoted part of 2nd checksum byte}
    acTimeout,         {Timeout collecting data}
    acError,           {Error processing ack/packet}
    acSendNak,         {Sending nak}
    acSendEnq,         {Sending enq and resyncing}
    acResync1,         {Collect 1st DLE of resync}
    acResync2,         {Collect seq of first resync}
    acResync3,         {Collect 2nd DLE of resync}
    acResync4,         {Collect seq of second resync}
    acSendData,        {Sending data}
    acFailed);         {Failed miserably}

  {Protocol direction options}
  TDirection = (dUpload, dDownload);

  {Transfer parameters}
  ParamsRecord = record
    WinSend  : Byte;         {Send window size}
    WinRecv  : Byte;         {Receive window size}
    BlkSize  : Byte;         {Block size (* 128)}
    ChkType  : Byte;         {Check type, chksum or CRC}
    QuoteSet : TQuoteArray;  {Chars to quote}
    DROpt    : Byte;         {DL Recovery option}
    UROpt    : Byte;         {UL Recovery option}
    FIOpt    : Byte;         {File Info option}
  end;

  {Ascii state table}
  TAsciiState = (
    taInitial,         {Prepare to transmit file}
    taGetBlock,        {Get next block to transmit}
    taWaitFreeSpace,   {Wait for free space in output buffer}
    taSendBlock,       {Start transmitting current block}
    taSendDelay,       {Wait for delay for next outgoing character/line}
    taFinishDrain,     {Wait for last data to go out}
    taFinished,        {Normal or error completion, cleanup}
    taDone,            {Done with transmit}

    raInitial,         {Prepare to receive file}
    raCollectBlock,    {Collect block}
    raProcessBlock,    {Check for ^Z, write block to disk}
    raFinished,        {Normal or error completion, cleanup}
    raDone);           {Done with receive}

type
  {For storing received and transmitted blocks}
  PDataBlock = ^TDataBlock;
  TDataBlock = array[1..apMaxBlockSize] of AnsiChar;

  {Describes working buffer for expanding a standard buffer with escapes}
  PWorkBlock = ^TWorkBlock;
  TWorkBlock = array[1..2*apMaxBlockSize] of AnsiChar;

  {Describes 4K internal input buffer for Kermit}
  PInBuffer = ^TInBuffer;
  TInBuffer = array[1..4096] of AnsiChar;

  {Describes data area of headers}
  TPosFlags = array[0..3] of Byte;

  {For buffering received and transmitted files}
  PFileBuffer = ^TFileBuffer;
  TFileBuffer = array[0..FileBufferSize-1] of Byte;

  PProtocolData = ^TProtocolData;

  {Prepare procedure}
  TPrepareProc = procedure(P : PProtocolData);

  {Protocol notification function}
  TProtocolFunc = procedure(
                           Msg, wParam : Cardinal;
                           lParam : LongInt);

  {Hook types}
  PrepFinishProc = procedure(P : PProtocolData);
    {-Prepare/cleanup file reading/writing}
  ReadProtProc = function (P : PProtocolData;
                           var Block : TDataBlock;
                           var BlockSize : Cardinal) : Bool;
    {-Get next block of data to transmit}
  WriteProtProc = function (P : PProtocolData;
                            var Block : TDataBlock;
                            BlockSize : Cardinal) : Bool;
    {-Write block of data just received}
  CancelFunc = procedure(P : PProtocolData);
    {-Send Cancel sequence}
  ShowStatusProc = procedure(P : PProtocolData; Options : Cardinal);
    {-Send message to status window}
  NextFileFunc = function(P : PProtocolData; FName : PAnsiChar) : Bool;
    {-Request next file to transmit}
  LogFileProc = procedure(P : PProtocolData; LogFileStatus : Cardinal);
    {-Log transmitted/received file}
  AcceptFileFunc = function(P : PProtocolData; FName : PAnsiChar) : Bool;
    {-Accept this incoming file?}

  TKermitOptions = record
    MaxPacketLen     : Byte;
    MaxTimeout       : Byte;
    PadCount         : Byte;
    PadChar          : AnsiChar;
    Terminator       : AnsiChar;
    CtlPrefix        : AnsiChar;
    HibitPrefix      : AnsiChar;
    Check            : AnsiChar;
    RepeatPrefix     : AnsiChar;
    CapabilitiesMask : Byte;
    WindowSize       : Byte;
    MaxLongPacketLen : Cardinal;
    SendInitSize     : Cardinal;
  end;

  {The complete protocol record}
  TProtocolData = record
    {Trigger handles}
    aStatusTrigger       : Integer;         {Status timer trigger handle}
    aTimeoutTrigger      : Integer;         {Timeout timer trigger handle}
    aOutBuffFreeTrigger  : Integer;         {Outbuffree status trigger handle}
    aOutBuffUsedTrigger  : Integer;         {Outbuffused status trigger handle}
    aNoCarrierTrigger    : Integer;         {No carrier status trigger handle}

    {General...}
    aHWindow             : HWnd;            {Registered window}
    aHC                  : TApdCustomComPort;   {Handle of port component}
    aBatchProtocol       : Bool;            {True if protocol supports batch}
    aFilesSent           : Bool;            {True if we actually sent a file}
    aAbortFlag           : Bool;            {True to signal abort}
    aTimerStarted        : Bool;            {True once timer has been started}
    aCurProtocol         : Integer;         {Protocol type}
    aCheckType           : Cardinal;        {Code for block check type}
    aHandshakeRetry      : Cardinal;        {Attempts to retry handshaking}
    aHandshakeWait       : Cardinal;        {Wait seconds during handshaking}
    aHandshakeAttempt    : Cardinal;        {Current handshake attempt}
    aBlockLen            : Cardinal;        {Block length}
    aBlockNum            : Cardinal;        {Current block number}
    aFlags               : Cardinal;        {AbstractProtocol options}
    aTransTimeout        : Cardinal;        {Ticks to wait for trans freespace}
    aFinishWait          : Cardinal;        {Wait time for ZFin/EOT response}
    aRcvTimeout          : Cardinal;        {Seconds to wait for received char}
    aProtocolStatus      : Cardinal;        {Holds last status}
    aLastBlockSize       : Cardinal;        {Last blocksize}
    aProtocolError       : Integer;         {Holds last error}
    aSrcFileLen          : LongInt;         {Size of file (in bytes)}
    aSrcFileDate         : LongInt;         {Timestamp of source file}
    aBlockCheck          : DWORD;           {Block check value}
    aInitFilePos         : LongInt;         {Initial file pos during resumes}
    aReplyTimer          : EventTimer;      {Track timeouts waiting replies}
    aDataBlock           : PDataBlock;      {Working data block}
    aCurProtFunc         : TProtocolFunc;   {Protocol function}
    {$IFDEF Win32}
    aProtSection         : TRTLCriticalSection; {When state machine is busy}
    {$ENDIF}

    {Status...}
    aForceStatus         : Bool;            {Force status update}
    aTimerPending        : Bool;            {True if waiting to start timer}
    aInProgress          : Cardinal;        {Non-zero if protocol in progress}
    aBlockErrors         : Cardinal;        {Number of tries for block}
    aTotalErrors         : Cardinal;        {Number of total tries}
    aActCPS              : Cardinal;        {Port or modem CPS}
    aOverhead            : Cardinal;        {Overhead bytes per block}
    aTurnDelay           : Cardinal;        {MSec turnaround delay}
    aStatusInterval      : Cardinal;        {Ticks between status updates}
    aSaveStatus          : Cardinal;        {Save status at various points}
    aSaveError           : Integer;         {Save error at various points}
    aBytesRemaining      : LongInt;         {Bytes not yet transferred}
    aBytesTransferred    : LongInt;         {Bytes already transferred}
    aElapsedTicks        : LongInt;         {Elapseds Ticks as of last block}
    aStatusTimer         : EventTimer;      {How often to show status}
    aTimer               : EventTimer;      {Used to time a transfer}

    {File buffer managment...}
    aEndPending          : Bool;            {True when end-of-file is in buffer}
    aFileOpen            : Bool;            {True if file open in protocol}
    aNoMoreData          : Bool;            {Flag for tracking end-of-file}
    aLastBlock           : Bool;            {True at eof}
    aBlkIndex            : Cardinal;        {Index into received chars in DataBlock}
    aWriteFailOpt        : Integer;         {Rules for overwriting files}
    aStartOfs            : LongInt;         {Holds starting offset of file}
    aEndOfs              : LongInt;         {Holds ending offset of file}
    aLastOfs             : LongInt;         {FileOfs of last Get/Put}
    aFileOfs             : LongInt;         {Current file offset}
    aEndOfDataOfs        : LongInt;         {Ofs of buffer of end-of-file}
    aFileBuffer          : PFileBuffer;     {For reading/writing files}
    aSaveMode            : Cardinal;        {For saving file mode}

    {For getting the next file to transmit}
    aUpcaseFileNames     : Bool;            {True to upcase file names}
    aFindingFirst        : Bool;            {NextFileMask flag}
    aFileListIndex       : Cardinal;        {NextFileList index}
    aPathName            : TPathCharArrayA;  {Complete path name of current file}
    aSearchMask          : TPathCharArrayA;  {NextFileMask search mask}
    aFileList            : PFileList;       {NextFileList list pointer}
    aCurRec              : TSearchRec;      {NextFileMask search record}
    aFFOpen              : Boolean;         {True if FindFirst open}
    aJunk                : Byte;            {Keep Cardinal aligned}

    {Hooks that inform}
    apShowStatus         : ShowStatusProc;  {Send message to status window}
    apLogFile            : LogFileProc;     {Log transmitted/received file}

    {Hooks that return something}
    apNextFile           : NextFileFunc;    {Request next file to transmit}
    apAcceptFile         : AcceptFileFunc;  {Accept this incoming file?}

    {Hooks for read/write routines}
    apPrepareReading     : PrepFinishProc;  {Prepare to read blocks}
    apReadProtocolBlock  : ReadProtProc;    {Read block to transmit}
    apFinishReading      : PrepFinishProc;  {Cleanup from reading blocks}
    apPrepareWriting     : PrepFinishProc;  {Prepare to write blocks}
    apWriteProtocolBlock : WriteProtProc;   {Write received block}
    apFinishWriting      : PrepFinishProc;  {Cleanup from writing blocks}

    {Large structures}
    aWorkFile            : File;            {Temp file for Get/PutProtocolBlock}
    aDestDir             : TDirCharArray;   {Destination directory}

    case Byte of
      Xmodem : (
        {General}
        xCRCMode         : Bool;
        x1KMode          : Bool;            {True for XModem1K}
        xGMode           : Bool;            {True for YmodemG}
        xMaxBlockErrors  : Cardinal;        {Max number of allowed block errors}
        xBlockWait       : Cardinal;        {Wait seconds between blocks}
        xEotCheckCount   : Cardinal;        {Number of Eot retries required}
        xStartChar       : AnsiChar;            {Block start character}

        {Temp vars that state machine requires to be static}
        xHandshake       : AnsiChar;            {Handshake character}
        xNaksReceived    : Cardinal;        {Count naks received}
        xEotCounter      : Cardinal;        {Counts received EOTs}
        xCanCounter      : Cardinal;        {Counts received cCans}
        xOverheadLen     : Cardinal;        {Number of overhead bytes per block}

        {State information}
        xXmodemState     : TXmodemState;    {Current state of Xmodem}
        xJunk            : Byte;            {Keep Cardinal aligned}

        {Unique Ymodem fields}
        ySaveLen         : LongInt;         {Saved file length}
        yNewDT           : LongInt;         {Date/time stamp}
        ySaveName        : TPathCharArrayA;  {Saved file name}
        yFileHeader      : PDataBlock;      {Needed for file name block}
        y128BlockMode    : Bool;            {True to force 128 byte blocks}{!!.06}
        yYmodemState     : TYmodemState);   {Current Ymodem state}

      Zmodem : (
        {General}
        zLastFrame       : AnsiChar;            {Holds last frame type for status}
        zTerminator      : AnsiChar;            {Current block type}
        zHeaderType      : AnsiChar;            {Current header type}
        zZmodemState     : TZmodemState;    {Current Zmodem state}
        zHeaderState     : THeaderState;    {General header state}
        zHexHdrState     : HexHeaderStates; {Current hex header state}
        zBinHdrState     : BinaryHeaderStates; {Current binary header state}
        zRcvBlockState   : ReceiveBlockStates; {Current receive block state}
        zFileMgmtOverride: Boolean;         {True to override senders file mg opts}
        zReceiverRecover : Boolean;         {True to force file recovery}
        zUseCrc32        : Boolean;         {True when using 32bit CRCs}
        zCanCrc32        : Boolean;         {True when Crc32 capable}
        zHexPending      : Boolean;         {True for next char in hex pair}
        zEscapePending   : Boolean;         {True for next char in esc pair}
        zEscapeAll       : Boolean;         {Escaping all ctl chars}
        zControlCharSkip : Boolean;         {True to skip all ctrl chars}
        zWasHex          : Boolean;         {True if processing hex header}
        zDiscardCnt      : Cardinal;        {Characters discarded so far}
        zConvertOpts     : Cardinal;        {File conversion opts rqst by sender}
        zFileMgmtOpts    : Cardinal;        {File mgmt opts rqst by sender}
        zTransportOpts   : Cardinal;        {File transport opts rqst by sender}
        zFinishRetry     : Cardinal;        {Times to resend ZFin}
        zWorkSize        : Cardinal;        {Index into working buffer}
        zCanCount        : Cardinal;        {Track contiguous <cancels>}
        zHexChar         : Cardinal;        {Saved hex value}
        zCrcCnt          : Cardinal;        {Number of CRC bytes rcv'd}
        zOCnt            : Cardinal;        {Number of 'O's rcv'd}
        zLastFileOfs     : LongInt;         {File position reported by remote}
        zAttentionStr    : array[1..MaxAttentionLen] of Byte; {Attn string value}
        zEscapeControl   : Boolean;         {User request to escape all ctl}// SWB

        {For controlling autoadjustment of block size}
        zUse8KBlocks     : Boolean;         {True when using 8K blocks}
        zTookHit         : Bool;            {True if we got ZrPos packet}
        zGoodAfterBad    : Cardinal;        {Holds count of good blocks}

        {Working buffers}
        zDataBlockLen    : Cardinal;        {Count of valid data in DataBlock}
        zDataInTransit   : LongInt;         {Amount of unacked data in transit}
        zWorkBlock       : PWorkBlock;      {Holds fully escaped data block}

        {Receiving...}
        zRcvFrame        : AnsiChar;            {Type of last received frame}
        zRcvHeader       : TPosFlags;       {Received header}

        {Transmitting...}
        zRcvBuffLen      : Cardinal;        {Size of receiver's buffer}
        zLastChar        : AnsiChar;            {Last character sent}
        zTransHeader     : TPosFlags;       {Header to transmit}
        zZRQINITValue    : LongInt);        {Optional ZRQINIT value}

      Kermit : (
        {General}
        kPacketType      : AnsiChar;            {Type of last packet}
        kKermitState     : TKermitState;    {Current state of machine}
        kKermitHeaderState: TKermitHeaderState; {Current header state}
        kKermitDataState : TKermitDataState;   {Current data state}
        kCheckKnown      : Bool;            {True if we've agreed on check type}
        kLPInUse         : Bool;            {True if we're using long packets}
        kUsingHibit      : Bool;            {True if prefixing hibit chars}
        kUsingRepeat     : Bool;            {True if using repeat cnt feature}
        kReceiveInProgress : Bool;          {True if receiving a file}
        kTransmitInProgress : Bool;         {True if transmitting a file}
        kDataLen         : Cardinal;        {Length of sent packet data field}
        kRecDataLen      : Cardinal;        {Length of recd packet data field}
        kActualDataLen   : Cardinal;        {Length decoded data bytes}
        kMinRepeatCnt    : Cardinal;        {Min threshold to use repeat feature}
        kRecBlockNum     : Cardinal;        {Blocknum of last received packet}
        kExpectedAck     : Cardinal;        {Blocknum of next expected Ack}
        kBlockCheck2     : Cardinal;        {For holding Crc check value}
        kSWCTurnDelay    : Cardinal;        {Turn delay to use for SWC mode}
        kKermitOptions   : TKermitOptions;  {Options for this transfer}
        kRmtKermitOptions: TKermitOptions;  {Options remote says to use}

        {Internal buffer management}
        kInBuff          : PInBuffer;       {Internal 4K input buffer}
        kInBuffHead      : Cardinal;        {Pointer to head of buffer}
        kInBuffTail      : Cardinal;        {Pointer to tail of buffer}

        {Transmitting...}
        kWorkEndPending  : Bool;            {True if no more WorkBlocks}
        kWorkLen         : Cardinal;        {Count of bytes in temp pool}
        kLastWorkIndex   : Cardinal;        {For managing data pool}
        kWorkBlock       : PDataBlock;      {Holds quoted data block}

        {Table management}
        kTableSize       : Cardinal;        {Size of window table, 1-31}
        kTableHead       : Cardinal;        {Newest used slot}
        kTableTail       : Cardinal;        {Oldest used slot, rcv only}
        kBlockIndex      : Cardinal;        {Collects data field}
        kNext2Send       : Integer;         {Slot in table to send}
        kDataTable       : PDataTable;      {Window table data}
        kInfoTable       : TInfoTable;      {Window table info}

        {Temp variables used in state machine}
        kTempCheck       : AnsiChar;            {Used for collecting check chars}
        kC1              : AnsiChar;            {Used for collecting check chars}
        kC2              : AnsiChar;            {Used for collecting check chars}
        kC3              : AnsiChar;            {Used for collecting check chars}
        kSkipped         : Bool;            {True if file was not accepted}
        kGetLong         : Bool;            {True for long header}
        kLongCheck       : Integer;         {Long header checksum}
        kSaveCheck2      : Cardinal;        {Save incoming check between states}
        kSaveCheck       : LongInt);        {Save incoming check between states}

      BPlus : (
        bSaveC           : AnsiChar;            {Save last char between states}
        bLastType        : AnsiChar;            {Last received packet type}
        bQSP             : Bool;            {True for quoting}
        bQuoted          : Bool;            {True if last ch recd was quoted}
        bResumeFlag      : Bool;            {True if resuming an aborted dl}
        bAborting        : Bool;            {True if processing abort}
        bBPlusMode       : Bool;            {True if in full B+ mode}
        bQuotePending    : Bool;            {True if 2nd quote char pending}
        bSentENQ         : Bool;            {True if sent ENQ in CollectAck}
        bNAKSent         : Bool;            {True if NAK just sent}
        bFailed          : Bool;            {True if write failed}
        bChecksum        : Cardinal;        {Checksum or CRC}
        bTimerIndex      : Cardinal;        {Index for DLE timer}
        bNewChk          : Cardinal;        {Calculated block check}
        bCurTimer        : Cardinal;        {Current timer index}
        bAbortCount      : Integer;         {# of abort requests so far}
        bNextSeq         : Integer;         {Next sequence number}
        bPacketNum       : Integer;         {Current packet num}
        bIdx             : Integer;         {Index for collecting data blocks}
        bRSize           : Integer;         {Size of last recd buffer}
        bSeqNum          : Integer;         {Current sequence number}
        bNext2ACK        : Integer;         {Packet pending ACK}
        bNext2Fill       : Integer;         {Packet to load for send}
        bSAMax           : Integer;         {Highest current sendahead cnt}
        bSAWaiting       : Integer;         {# of packets outstanding ACKs}
        bSAErrors        : Integer;         {Keep track of SendAhead errors}
        bRPackets        : LongInt;         {Packets received}
        bRBuffer         : PBPDataBlock;    {Receive buffer}
        bSBuffer         : TSPackets;       {Send buffers}
        bQuoteTable      : TQuoteTable;     {Active quoting table}
        bHostParams      : ParamsRecord;    {Host's parameters}
        bOurParams       : ParamsRecord;    {Our parameters}
        bDirection       : TDirection;      {Upload or download}
        bBPlusState      : TBPlusState;     {Main state}
        bTermState       : TTermPacketState;{State of terminal during DLE}
        bPacketState     : TPacketState;    {Packet collection state}
        bAckState        : TAckCollectionState); {Ack collection state}

      Ascii : (
        sCtrlZEncountered: Bool;            {Found EOF character}
        sInterCharDelay  : Cardinal;        {Delay after each character}
        sInterLineDelay  : Cardinal;        {Delay after EOLChar}
        sInterCharTicks  : Cardinal;        {InterChar delay in ticks}
        sInterLineTicks  : Cardinal;        {InterLine delay in ticks}
        sMaxAccumDelay   : Cardinal;        {Max Ticks before yielding}
        sSendIndex       : Cardinal;        {Index into transmitted data}
        sCRTransMode     : Cardinal;        {CR translation opts}
        sLFTransMode     : Cardinal;        {LF translation opts}
        sEOLChar         : AnsiChar;            {End-of-line char}
        sAsciiState      : TAsciiState);    {Current state}
  end;

implementation
end.
