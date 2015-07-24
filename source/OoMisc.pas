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
 *    Sulaiman Mah
 *    Sean B. Durkin
 *    Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                    OOMISC.PAS 5.00                    *}
{*********************************************************}
{* Miscellaneous supporting methods and types            *}
{*********************************************************}

{
  OOMisc is our catch-all unit for supporting methods and definitions.
  OOMisc is used by almost all APRO units, and is automatically included
  in the uses clause when an APRO component is dropped on a form.
  The APRO base classes are defined here also.
  A bit of APRO trivia: OOMisc stands for "Object Oriented Miscellaneous",
  and was introduced in the early DOS days.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit OoMisc;
  {-Unit for miscellaneous routines}

interface

uses
  Windows,
  Classes,
  Controls,
  ShellAPI,
  OleCtrls,
  Forms,
  Graphics,
  MMSystem,
  SysUtils,
  Messages;

const
  ApVersionStr = 'v5.00';
  {$IFDEF Apax}
  ApaxVersionStr = 'v1.14';                                              // SWB
  {$ENDIF}

  { Product name}
  ApdProductName = 'Async Professional';
  ApdShortProductName = 'APRO';

  ApdVendor = 'TurboPower Software Company';
  ApdVendorURL = 'http://www.TurboPower.com';

  { Version numbers }
  ApdXSLImplementation = 0.0;
  ApdXMLSpecification = '1.0';

  fsPathName  = 255;
  fsDirectory = 255;
  fsFileName  = 255;
  fsExtension = 255;
  fsName      = 255;

  {shareable reading file mode}
  ApdShareFileRead = $40;

const
  { Printer driver consts }
  ApdDefFileName   = 'C:\DEFAULT.APF';
  ApdPipeTimeout   = 5000; { ms }
  ApdPipeName      = '\\.\pipe\ApFaxCnv';
  ApdSemaphoreName = 'ApFaxCnvSem';
  ApdRegKey        = '\SOFTWARE\TurboPower\ApFaxCnv\Settings';
  ApdIniFileName   = 'APFPDENG.INI';
  ApdIniSection    = 'Settings';
  ApdIniKey        = 'AutoExec';
  ApdDef32PrinterName = 'APF Fax Printer';
  ApdDef16PrinterName = 'Print To Fax';
  ApdDefPrinterPort   = 'PRINTFAX';

  ApdDefaultTerminalName = '<default>';
  ApdNoTerminalName      = '<none>';


  {Event codes: (inbound)}
  eNull        = 0;
  eStartDoc    = 1;
  eEndDoc      = 2;

  {Event codes: (outbound)}
  eSetFileName = 3;

type
  TPipeEvent = record
    Event : Byte;
    Data : ShortString;
  end;
  { XML definitions }
  DOMString = WideString;
type
  CharSet = set of AnsiChar;

  TPassString = string[255];
  TApdHwnd = HWND;


  {Standard event timer record structure used by all timing routines}
  EventTimer = record
    StartTicks : Integer;  {Tick count when timer was initialized}
    ExpireTicks : Integer; {Tick count when timer will expire}
  end;

{$IFNDEF PRNDRV}                                                         {!!.06}
type{ moved from AdTapi.pas }                                            {!!.06}
  { TAPI device config record, opaque and undefined by definition }      {!!.06}
  PTapiConfigRec = ^TTapiConfigRec;                                      {!!.06}
  TTapiConfigRec = record                                                {!!.06}
    DataSize : Cardinal;                                                 {!!.06}
    Data : array[0..1023] of Byte;                                       {!!.06}
  end;

{ moved from AdRasUtl.pas }                                              {!!.06}
const {RasMaximum buffer sizes}                                          {!!.06}
  RasMaxDomain      = 15;                                                {!!.06}
  RasMaxPassword    = 256;                                               {!!.06}
  RasMaxUserName    = 256;                                               {!!.06}
  RasMaxEntryName   = 256;                                               {!!.06}
  RasMaxPhoneBook   = 256;                                               {!!.06}
  RasMaxError       = 256;                                               {!!.06}
  RasMaxEntries     = 64;                                                {!!.06}
  RasMaxDeviceName  = 128;                                               {!!.06}
  RasMaxDeviceType  = 16;                                                {!!.06}
  RasMaxPhoneNumber = 128;                                               {!!.06}
  RasMaxCallBackNum = 128;                                               {!!.06}
  RasMaxAreaCode    = 10;                                                {!!.06}
  RasMaxPadType     = 32;                                                {!!.06}
  RasMaxX25Address  = 200;                                               {!!.06}
  RasMaxIPAddress   = 15;                                                {!!.06}
  RasMaxIPXAddress  = 21;                                                {!!.06}
  RasMaxFacilities  = 200;                                               {!!.06}
  RasMaxUserData    = 200;                                               {!!.06}

type  { moved from AdRasUtl.pas }                                        {!!.06}
  {RAS IP address - "a.b.c.d"}                                           {!!.06}
  PRasIPAddr = ^TRasIPAddr;                                              {!!.06}
  TRasIPAddr = record                                                    {!!.06}
    a : byte;                                                            {!!.06}
    b : byte;                                                            {!!.06}
    c : byte;                                                            {!!.06}
    d : byte;                                                            {!!.06}
  end;                                                                   {!!.06}

type { moved from AdRasUtl.pas }                                         {!!.06}
  {RAS phonebook entry properties}                                       {!!.06}
  {!!.06} {Renamed fields to sync with underlying RASENTRY structure }
  { dwOptions -> dwfOptions, dwAlternatesOffset -> dwAlternateOffset, }
  { dwNetProtocols -> dwfNetProtocols }
  PRasEntry = ^TRasEntry;                                                {!!.06}
  TRasEntry = record                                                     {!!.06}
    dwSize             : DWord;                                          {!!.06}
    dwfOptions         : DWord;                                          {!!.06}
    dwCountryID        : DWord;                                          {!!.06}
    dwCountryCode      : DWord;                                          {!!.06}
    szAreaCode         : array[0..RasMaxAreaCode] of char;               {!!.06}     // tchar
    szLocalPhoneNumber : array[0..RasMaxPhoneNumber] of char;            {!!.06}     // tchar
    dwAlternateOffset  : DWord;                                          {!!.06}
    IPAddr             : TRasIPAddr;                                     {!!.06}
    IPAddrDns          : TRasIPAddr;                                     {!!.06}
    IPAddrDnsAlt       : TRasIPAddr;                                     {!!.06}
    IPAddrWins         : TRasIPAddr;                                     {!!.06}
    IPAddrWinsAlt      : TRasIPAddr;                                     {!!.06}
    dwFrameSize        : DWord;                                          {!!.06}
    dwfNetProtocols    : DWord;                                          {!!.06}
    dwFramingProtocol  : DWord;                                          {!!.06}
    szScript           : array[0..Max_PATH-1] of char;                   {!!.06} // --SZ TCHAR in ras.h, so use char here 
    szAutodialDll      : array[0..Max_PATH-1] of char;                   {!!.06}
    szAutodialFunc     : array[0..Max_PATH-1] of char;                   {!!.06}
    szDeviceType       : array[0..RasMaxDeviceType] of char;             {!!.06}
    szDeviceName       : array[0..RasMaxDeviceName] of char;             {!!.06}
    szX25PadType       : array[0..RasMaxPadType] of char;                {!!.06}
    szX25Address       : array[0..RasMaxX25Address] of char;             {!!.06}
    szX25Facilities    : array[0..RasMaxFacilities] of char;             {!!.06}
    szX25UserData      : array[0..RasMaxUserData] of char;               {!!.06}
    dwChannels         : DWord;                                          {!!.06}
    dwReserved1        : DWord;                                          {!!.06}
    dwReserved2        : DWord;                                          {!!.06}
  end;                                                                   {!!.06}

const   {RASENTRY 'dwfOptions' bit flags}                                {!!.06}
  RASEO_UseCountryAndAreaCodes    = $00000001;                           {!!.06}
  RASEO_SpecificIpAddr            = $00000002;                           {!!.06}
  RASEO_SpecificNameServers       = $00000004;                           {!!.06}
  RASEO_IpHeaderCompression       = $00000008;                           {!!.06}
  RASEO_RemoteDefaultGateway      = $00000010;                           {!!.06}
  RASEO_DisableLcpExtensions      = $00000020;                           {!!.06}
  RASEO_TerminalBeforeDial        = $00000040;                           {!!.06}
  RASEO_TerminalAfterDial         = $00000080;                           {!!.06}
  RASEO_ModemLights               = $00000100;                           {!!.06}
  RASEO_SwCompression             = $00000200;                           {!!.06}
  RASEO_RequireEncryptedPw        = $00000400;                           {!!.06}
  RASEO_RequireMsEncryptedPw      = $00000800;                           {!!.06}
  RASEO_RequireDataEncryption     = $00001000;                           {!!.06}
  RASEO_NetworkLogon              = $00002000;                           {!!.06}
  RASEO_UseLogonCredentials       = $00004000;                           {!!.06}
  RASEO_PromoteAlternates         = $00008000;                           {!!.06}
  RASEO_SecureLocalFiles          = $00010000;                           {!!.06}
  RASEO_RequireEAP                = $00020000;                           {!!.06}
  RASEO_RequirePAP                = $00040000;                           {!!.06}
  RASEO_RequireSPAP               = $00080000;                           {!!.06}
  RASEO_Custom                    = $00100000;                           {!!.06}
  RASEO_PreviewPhoneNumber        = $00200000;                           {!!.06}
  RASEO_SharedPhoneNumbers        = $00800000;                           {!!.06}
  RASEO_PreviewUserPw             = $01000000;                           {!!.06}
  RASEO_PreviewDomain             = $02000000;                           {!!.06}
  RASEO_ShowDialingProgress       = $04000000;                           {!!.06}
  RASEO_RequireCHAP               = $08000000;                           {!!.06}
  RASEO_RequireMsCHAP             = $10000000;                           {!!.06}
  RASEO_RequireMsCHAP2            = $20000000;                           {!!.06}
  RASEO_RequireW95MSCHAP          = $40000000;                           {!!.06}
  RASEO_CustomScript              = $80000000;                           {!!.06}

  {RASENTRY 'dwfNetProtocols' bit flags}                                 {!!.06}
  RASNP_NetBEUI                   = $00000001;                           {!!.06}
  RASNP_Ipx                       = $00000002;                           {!!.06}
  RASNP_Ip                        = $00000004;                           {!!.06}

  {RASENTRY 'dwFramingProtocols' bit flags}                              {!!.06}
  RASFP_Ppp                       = $00000001;                           {!!.06}
  RASFP_Slip                      = $00000002;                           {!!.06}
  RASFP_Ras                       = $00000004;                           {!!.06}

  {RASENTRY 'szDeviceType' default strings}                              {!!.06}
  RASDT_Modem                     = 'modem';                             {!!.06}
  RASDT_Isdn                      = 'isdn';                              {!!.06}
  RASDT_X25                       = 'x25';                               {!!.06}
  RASDT_Vpn                       = 'vpn';                               {!!.06}
  RASDT_Pad                       = 'pad';                               {!!.06}
  RASDT_Generic                   = 'GENERIC';                           {!!.06}
  RASDT_Serial        	          = 'SERIAL';                            {!!.06}
  RASDT_FrameRelay                = 'FRAMERELAY';                        {!!.06}
  RASDT_Atm                       = 'ATM';                               {!!.06}
  RASDT_Sonet                     = 'SONET';                             {!!.06}
  RASDT_SW56                      = 'SW56';                              {!!.06}
  RASDT_Irda                      = 'IRDA';                              {!!.06}
  RASDT_Parallel                  = 'PARALLEL';                          {!!.06}

type
  PRasStatistics = ^TRasStatistics;                                      {!!.06}
  TRasStatistics = record                                                {!!.06}
    dwSize                    : DWORD;                                   {!!.06}
    dwBytesXmited             : DWORD;                                   {!!.06}
    dwBytesRcved              : DWORD;                                   {!!.06}
    dwFramesXmited            : DWORD;                                   {!!.06}
    dwFramesRcved             : DWORD;                                   {!!.06}
    dwCrcErr                  : DWORD;                                   {!!.06}
    dwTimeoutErr              : DWORD;                                   {!!.06}
    dwAlignmentErr            : DWORD;                                   {!!.06}
    dwHardwareOverrunErr      : DWORD;                                   {!!.06}
    dwFramingErr              : DWORD;                                   {!!.06}
    dwBufferOverrunErr        : DWORD;                                   {!!.06}
    dwCompressionRatioIn      : DWORD;                                   {!!.06}
    dwCompressionRatioOut     : DWORD;                                   {!!.06}
    dwBps                     : DWORD;                                   {!!.06}
    dwConnectDuration         : DWORD;                                   {!!.06}
  end;                                                                   {!!.06}
{$ENDIF}                                                                 {!!.06}
const
  {Compile-time configurations}
  MaxComHandles = 50;               {Max comm ports open at once}
  DispatchBufferSize = 8192;        {Size of each port's dispatch buffer}
  MaxMessageLen = 80;               {All error and status strings less than 80}

  {For skipping line parameter changes}
  DontChangeBaud         = 0;
  DontChangeParity       = SpaceParity + 1;
  DontChangeDatabits     = 9;
  DontChangeStopbits     = TwoStopbits + 1;

  {Modem status trigger options}
  msCTSDelta   = $0010;
  msDSRDelta   = $0020;
  msRingDelta  = $0004;
  msDCDDelta   = $0080;

  {Line status trigger options}
  lsOverrun  = $0001;
  lsParity   = $0002;
  lsFraming  = $0004;
  lsBreak    = $0008;

  {Line and driver errors}
  leNoError    = 0;   {No error, ordinal value matches ecOK}
  leBuffer     = 1;   {Buffer overrun in COMM.DRV}
  leOverrun    = 2;   {UART receiver overrun}
  leParity     = 3;   {UART receiver parity error}
  leFraming    = 4;   {UART receiver framing error}
  leCTSTO      = 5;   {Transmit timeout waiting for CTS}
  leDSRTO      = 6;   {Transmit timeout waiting for DSR}
  leDCDTO      = 7;   {Transmit timeout waiting for RLSD}
  leTxFull     = 8;   {Transmit queue is full}
  leBreak      = 9;   {Break condition received}
  leIOError    = 10;  {Windows error.  LastWinError contains the error code.} 

  {Status trigger subtypes}
  stNotActive   = 0;  {not active}
  stModem       = 1;  {Trigger on modem status change}
  stLine        = 2;  {Trigger on line status change}
  stOutBuffFree = 3;  {Trigger on outbuff free level}
  stOutBuffUsed = 4;  {Trigger on outbuff used level}
  stOutSent     = 5;  {Trigger on any PutXxx call}

  {Next file method}
  nfNone               = 0;  {No next file method specified}
  nfMask               = 1;  {Use built-in next file mask method}
  nfList               = 2;  {Use built-in next file list method}

  {Action to take if incoming file exists}
  wfcWriteNone          = 0;  {No option set yet}
  wfcWriteFail          = 1;  {Fail the open attempt}
  wfcWriteRename        = 2;  {Rename the incoming file}
  wfcWriteAnyway        = 3;  {Overwrite the existing file}
  wfcWriteResume        = 4;  {Resume an interrupted receive}    

  {Ascii CR/LF translation options}
  atNone               = 0;  {No CR/LF translations}
  atStrip              = 1;  {Strip CRs or LFs}
  atAddCRBefore        = 2;  {Add CR before each LF}
  atAddLFAfter         = 3;  {Add LF after each CR}      
  atEOFMarker          : Ansichar = ^Z; {Add constant for standard EOF }

  {Protocol status start/end flags}
  apFirstCall          = $01; {Indicates the first call to status}
  apLastCall           = $02; {Indicates the last call to status}

  {For specifying log file calls}
  lfReceiveStart       = 0;  {Receive starting}
  lfReceiveOk          = 1;  {File received ok}
  lfReceiveFail        = 2;  {File receive failed}
  lfReceiveSkip        = 3;  {File was rejected by receiver}
  lfTransmitStart      = 4;  {Transmit starting}
  lfTransmitOk         = 5;  {File was transmitted ok}
  lfTransmitFail       = 6;  {File transmit failed}
  lfTransmitSkip       = 7;  {File was skipped, rejected by receiver}

type
  {Convenient types used by protocols}
  TNameCharArray  = array[0..fsFileName ] of AnsiChar; //SZ used by protocols --> Ansi
  TExtCharArray   = array[0..fsExtension] of AnsiChar;
  TPathCharArray  = array[0..fsPathName ] of Char;
  TPathCharArrayA = array[0..fsPathName ] of AnsiChar;  //SZ FIXME can this be changed to Char??
  TDirCharArray   = array[0..fsDirectory] of AnsiChar;
  TChar20Array    = array[0..20] of AnsiChar;
  TCharArray      = array[0..255] of AnsiChar;

  {For generic buffer typecasts}
  PByteBuffer = ^TByteBuffer;
  TByteBuffer = array[1..65535] of Byte;

  {Port characteristic constants}
  TDatabits = 5..DontChangeDatabits;
  TStopbits = 1..DontChangeStopbits;

  {NotifyProc type, same as a window procedure}
  TApdNotifyProc = procedure(Msg, wParam : Cardinal;
                         lParam : Integer);
  TApdNotifyEvent = procedure(Msg, wParam : Cardinal;
                         lParam : Integer) of object;
const
  {Avoid requiring WIN31}
  ev_CTSS   = $0400;           {CTS state}
  ev_DSRS   = $0800;           {DSR state}
  ev_RLSDS  = $1000;           {RLSD state}
  ev_RingTe = $2000;           {Ring trailing edge indicator}

const
  {MSRShadow register from COMM.DRV}
  MsrShadowOfs = 35;           {Offset of MSRShadow from EventWord}

const
  {Modem status bit masks}
  DeltaCTSMask     = $01;      {CTS changed since last read}
  DeltaDSRMask     = $02;      {DSR changed since last read}
  DeltaRIMask      = $04;      {RI changed since last read}
  DeltaDCDMask     = $08;      {DCD changed since last read}
  CTSMask          = $10;      {Clear to send}
  DSRMask          = $20;      {Data set ready}
  RIMask           = $40;      {Ring indicator}
  DCDMask          = $80;      {Data carrier detect}

const
  {Message base}
  apw_First              = $7E00;   {Sets base for all APW messages}

const
  {Custom message types}
  apw_TriggerAvail       = apw_First+1;   {Trigger for any data avail}
  apw_TriggerData        = apw_First+2;   {Trigger data}
  apw_TriggerTimer       = apw_First+3;   {Trigger timer}
  apw_TriggerStatus      = apw_First+4;   {Status change (modem, line, buffer)}
  apw_FromYmodem         = apw_First+5;   {Tells Xmodem it was called from Ymodem}
  apw_PortOpen           = apw_First+8;   {Apro, tell users port open}
  apw_PortClose          = apw_First+9;   {Apro, tell users port closed}
  apw_ClosePending       = apw_First+10;  {Apro, tell ourself that the port was closed}

const
  {Protocol message types}
  apw_ProtocolCancel     = apw_First+20;  {To protocol - chk for protcl abort}
  apw_ProtocolStatus     = apw_First+21;  {From protocol - update status display}
  apw_ProtocolLog        = apw_First+22;  {From protocol - LogFile message}
  apw_ProtocolNextFile   = apw_First+23;  {From protocol - return next file}
  apw_ProtocolAcceptFile = apw_First+24;  {From protocol - accept file}
  apw_ProtocolFinish     = apw_First+25;  {From protocol - protocol is finished}
  apw_ProtocolResume     = apw_First+26;  {From protocol - resume request}
  apw_ProtocolError      = apw_First+27;  {From protocol - error during protocol}
  apw_ProtocolAbort      = apw_First+28;  {To protocol - abort the transfer}

const
  {Modem message types}
  apw_AutoAnswer         = apw_First+40;  {To modem, enter AutoAnswer}
  apw_CancelCall         = apw_First+41;  {To modem, cancel the call}
  apw_StartDial          = apw_First+42;  {To modem, start the process}

  {deprecated modem message types, note that some conflict with new messages}
  apw_ModemOk            = apw_First+40;  {From modem - got OK response}
  apw_ModemConnect       = apw_First+41;  {From modem - got CONNECT response}
  apw_ModemBusy          = apw_First+42;  {From modem - got BUSY response}
  apw_ModemVoice         = apw_First+43;  {From modem - got VOICE response}
  apw_ModemNoCarrier     = apw_First+44;  {From modem - got NO CARRIER response}
  apw_ModemNoDialTone    = apw_First+45;  {From modem - got NO DIALTONE response}
  apw_ModemError         = apw_First+46;  {From modem - got ERROR response}
  apw_GotLineSpeed       = apw_First+47;  {From modem - got connect speed}
  apw_GotErrCorrection   = apw_First+48;  {From modem - got EC response}
  apw_GotDataCompression = apw_First+49;  {From modem - got compression response}
  apw_CmdTimeout         = apw_First+50;  {From modem - command timed out}
  apw_DialTimeout        = apw_First+51;  {From modem - dial timed out}
  apw_AnswerTimeout      = apw_First+52;  {From modem - answer timed out}
  apw_DialCount          = apw_First+53;  {From modem - dial still in progress}
  apw_AnswerCount        = apw_First+54;  {From modem - answer still in progress}
  apw_ModemRing          = apw_First+55;  {From modem - phone rang}
  apw_ModemIsConnected   = apw_First+56;  {From modem - connection completed}
  apw_ConnectFailed      = apw_First+57;  {From modem - connection failed}
  apw_CommandProcessed   = apw_First+58;  {From modem - finished command}

const
  {Terminal message types}
  apw_TermStart          = apw_First+60;  {To terminal - start}
  apw_TermStop           = apw_First+61;  {To terminal - stop}
  apw_TermSetCom         = apw_First+62;  {To terminal - set com handle}
  apw_TermRelCom         = apw_First+63;  {To terminal - release com handle}
  apw_TermSetEmuPtr      = apw_First+64;  {To terminal - set emulator pointer}
  apw_TermSetEmuProc     = apw_First+65;  {To terminal - set emulator proc}
  apw_TermClear          = apw_First+66;  {To terminal - clear window}
  apw_TermBuffer         = apw_First+67;  {To terminal - alloc new buffers}
  apw_TermColors         = apw_First+68;  {To terminal - set new colors}
  apw_TermToggleScroll   = apw_First+69;  {To terminal - toggle scrollback}
  apw_TermCapture        = apw_First+70;  {To terminal - set capture mode}
  apw_TermStuff          = apw_First+71;  {To terminal - stuff data}
  apw_TermPaint          = apw_First+72;  {To terminal - update screen}
  apw_TermSetWndProc     = apw_First+73;  {To terminal - set window proc}
  apw_TermColorsH        = apw_First+74;  {To terminal - set highlight colors}
  apw_TermSave           = apw_First+75;  {To terminal - save/restore}
  apw_TermColorMap       = apw_First+76;  {To terminal - get/set color map}
  apw_TermForceSize      = apw_First+77;  {To terminal - force new size}
  apw_TermFontSize       = apw_First+78;  {To terminal - get font size}

const
  apw_TermStatus         = apw_First+80;  {From terminal - show status}
  apw_TermBPlusStart     = apw_First+81;  {From terminal - B+ is starting}
  apw_TermError          = apw_First+82;  {From terminal - error}
  apw_CursorPosReport    = apw_First+83;  {From terminal - Cursor Pos Report}

const
  apw_FaxCvtStatus       = apw_First+90;  {From fax converter - show status}
  apw_FaxUnpStatus       = apw_First+91;  {From fax unpacker - show status}
  apw_FaxOutput          = apw_First+92;  {From fax unpacker - output line}

const
  apw_ViewSetFile        = apw_First+100; {To fax viewer - change file name}
  apw_ViewSetFG          = apw_First+101; {To fax viewer - set foreground color}
  apw_ViewSetBG          = apw_First+102; {To fax viewer - set background color}
  apw_ViewSetScale       = apw_First+103; {To fax viewer - set scale factors}
  apw_ViewSetScroll      = apw_First+104; {To fax viewer - set scroll increments}
  apw_ViewSelectAll      = apw_First+105; {To fax viewer - select entire image}
  apw_ViewSelect         = apw_First+106; {To fax viewer - select image rect}
  apw_ViewCopy           = apw_First+107; {To fax viewer - copy data to cboard}
  apw_ViewSetWndProc     = apw_First+108; {To fax viewer - set window procedure}
  apw_ViewSetWhitespace  = apw_First+109; {To fax viewer - set whitespace comp}
  apw_ViewGetBitmap      = apw_First+110; {To fax viewer - get memory bmp}
  apw_ViewGetNumPages    = apw_First+111; {To fax viewer - get num pages}
  apw_ViewStartUpdate    = apw_First+112; {To fax viewer - start scale update}
  apw_ViewEndUpdate      = apw_First+113; {To fax viewer - end scale upate}
  apw_ViewGotoPage       = apw_First+114; {To fax viewer - go to a page}
  apw_ViewGetCurPage     = apw_First+115; {To fax viewer - get current page #}
  apw_ViewSetDesignMode  = apw_First+116; {To fax viewer - indicate in design}
  apw_ViewSetRotation    = apw_First+117; {To fax viewer - set rotation}
  apw_ViewSetAutoScale   = apw_First+118; {To fax viewer - auto scaling}
  apw_ViewNotifyPage     = apw_First+119; {To fax viewer - notify of page chg}
  apw_ViewGetPageDim     = apw_First+120; {To fax viewer - get pg dimensions}
  apw_ViewSetLoadWholeFax= apw_First+121; {To fax viewer - set load whole fax}
  apw_ViewSetBusyCursor  = apw_First+122; {To fax viewer - set cursor for busy}
  apw_ViewerError        = apw_First+123; {Fax viewer error report}
  apw_ViewGetPageFlags   = apw_First+124; {To fax viewer - get pg flags}
  apw_ViewGetFileName    = apw_First+125; {To fax viewer - get file name}

const
  apw_TermBlinkTimeChange      = apw_First+130; {set new blink time}
  apw_TermPersistentMarkChange = apw_First+131; {set persistent blocks}
  apw_TermSetKeyEmuPtr         = apw_First+132; {set Key Emulator pointer }
  apw_TermSetKeyEmuProc        = apw_First+133; {set Key Emulator proc }
  apw_TermSetHalfDuplex        = apw_First+134; {set Duplex mode}
  apw_TermGetBuffPtr           = apw_First+135; {get a pointer to term buffer}
  apw_TermGetClientLine        = apw_First+136; {get the first client line in buffer}
  apw_TermWaitForPort          = apw_First+137; {wait for the port to open}{!!.03}
  apw_TermNeedsUpdate          = apw_First+138; {update needed}          {!!.05}

const
  apw_PrintDriverJobCreated    = apw_First+140; {printer driver created fax job}
  apw_BeginDoc                 = apw_First+141; {printer driver starts printing}
  apw_EndDoc                   = apw_First+142; {printer driver has finished printing}
  apw_AddPrim                  = apw_First+143; {internal FaxSrvx sample message}
  apw_EndPage                  = apw_First+144; {printer driver EndOfPage/idShell}
  
const
  apw_FaxCancel          = apw_First+160; {To fax - cancel the session}
  apw_FaxNextfile        = apw_First+161; {From fax - return next fax to send}
  apw_FaxStatus          = apw_First+162; {From fax - show the fax status}
  apw_FaxLog             = apw_First+163; {From fax - log the fax start/stop}
  apw_FaxName            = apw_First+164; {From fax - name the incoming fax}
  apw_FaxAccept          = apw_First+165; {From fax - accept this fax?}
  apw_FaxError           = apw_First+166; {From fax - session had error}
  apw_FaxFinish          = apw_First+167; {From fax - session finished}

const
  apw_TapiWaveMessage    = apw_First+180; {Tapi wave event message}
  apw_TapiEventMessage   = apw_First+181; {Tapi general event message}
  apw_VoIPEventMessage   = apw_First+182; {AdVoIP general event message}
  apw_VoIPNotifyMessage  = apw_First+183; {AdVoIP internal notification message}

const
  apw_StateDeactivate    = apw_First+190; {State deactivation message }
  apw_StateChange        = apw_First+191; {from State to StateMachine }

const
  apw_SapiTrain          = apw_First+192; {Sapi training requested}
  apw_SapiPhoneCallBack  = apw_First+193; {Sapi AskFor phrase return}
  apw_SapiInfoPhrase     = apw_First+194; {Sapi TAPI connection status}

const
  apw_PgrStatusEvent     = apw_First+200; {Pager status event}

const
  {Window class names}
  DispatcherClassName      = 'awDispatch';
  ProtocolClassName        = 'awProtocol';
  TerminalClassName        = 'awTerminal';
  MessageHandlerClassName  = 'awMsgHandler';
  FaxViewerClassName       = 'awViewer';
  FaxViewerClassNameDesign = 'dcViewer';
  TerminalClassNameDesign  = 'dcTerminal';
  FaxHandlerClassName      = 'awFaxHandler';

const
  {Error groups}
  egDos                  =  -0;     {DOS, DOS critical and file I/O}
  egGeneral              =  -1;     {General errors}
  egOpenComm             =  -2;     {OpenComm errors}
  egSerialIO             =  -3;     {Errors during serial I/O processing}
  egModem                =  -4;     {Errors during modem processing}
  egTrigger              =  -5;     {Error setting up triggers}
  egProtocol             =  -6;     {Errors that apply to one or more protocols}
  egINI                  =  -7;     {INI database errors}
  egFax                  =  -8;     {FAX errors}
  egAdWinsock            =   9;     {APro specific Winsock errors}
  egWinsock              =  10;     {Winsock errors}
  egWinsockEx            =  11;     {Additional Winsock errors}
  egTapi                 = -13;     {TAPI errors}

const
  { Below are all error codes used by APRO -- resource IDs are Abs(ErrorCode) }
  { The corresponding strings can be found in APW.STR and AdExcept.inc. If    }
  { you are adding strings, it's best to go there first to 'stake a claim' on }
  { an appropriate range of IDs -- since constants for some status strings    }
  { are found in the applicable component's unit instead of here...           }

  {No error}
  ecOK                     = 0;         {Okay}

const
  {egDOS}
  ecFileNotFound           = -2;       {File not found}
  ecPathNotFound           = -3;       {Path not found}
  ecTooManyFiles           = -4;       {Too many open files}
  ecAccessDenied           = -5;       {File access denied}
  ecInvalidHandle          = -6;       {Invalid file handle}
  ecOutOfMemory            = -8;       {Insufficient memory}
  ecInvalidDrive           = -15;      {Invalid drive}
  ecNoMoreFiles            = -18;      {No more files}
  ecDiskRead               = -100;     {Attempt to read beyond end of file}
  ecDiskFull               = -101;     {Disk is full}
  ecNotAssigned            = -102;     {File not Assign-ed}
  ecNotOpen                = -103;     {File not open}
  ecNotOpenInput           = -104;     {File not open for input}
  ecNotOpenOutput          = -105;     {File not open for output}
  ecWriteProtected         = -150;     {Disk is write-protected}
  ecUnknownUnit            = -151;     {Unknown disk unit}
  ecDriveNotReady          = -152;     {Drive is not ready}
  ecUnknownCommand         = -153;     {Unknown command}
  ecCrcError               = -154;     {Data error}
  ecBadStructLen           = -155;     {Bad request structure length}
  ecSeekError              = -156;     {Seek error}
  ecUnknownMedia           = -157;     {Unknown media type}
  ecSectorNotFound         = -158;     {Disk sector not found}
  ecOutOfPaper             = -159;     {Printer is out of paper}
  ecDeviceWrite            = -160;     {Device write error}
  ecDeviceRead             = -161;     {Device read error}
  ecHardwareFailure        = -162;     {General failure}

const
  {egGeneral}
  ecBadHandle              = -1001;    {Bad handle passed to com function}
  ecBadArgument            = -1002;    {Bad argument passed to function}
  ecGotQuitMsg             = -1003;    {Yielding routine got WM_QUIT message}
  ecBufferTooBig           = -1004;    {Terminal buffer size too big}
  ecPortNotAssigned        = -1005;    {ComPort component not assigned}
  ecInternal               = -1006;    {Internal INIDB errors}
  ecModemNotAssigned       = -1007;    {Modem component not assigned}
  ecPhonebookNotAssigned   = -1008;    {Phonebook component not assgnd}
  ecCannotUseWithWinSock   = -1009;    {Component not compatible with WinSock}

const
  {egOpenComm}
  ecBadId                  = -2001;    {ie_BadId - bad or unsupported ID}
  ecBaudRate               = -2002;    {ie_Baudrate - unsupported baud rate}
  ecByteSize               = -2003;    {ie_Bytesize - invalid byte size}
  ecDefault                = -2004;    {ie_Default - error in default parameters}
  ecHardware               = -2005;    {ie_Hardware - hardware not present}
  ecMemory                 = -2006;    {ie_Memory - unable to allocate queues}
  ecCommNotOpen            = -2007;    {ie_NOpen - device not open}
  ecAlreadyOpen            = -2008;    {ie_Open - device already open}
  ecNoHandles              = -2009;    {No more handles, can't open port}
  ecNoTimers               = -2010;    {No timers available}
  ecNoPortSelected         = -2011;    {No port selected (attempt to open com0)}
  ecNotOpenedByTapi        = -2012;    {Comport was not opened by Tapi}

const
  {egSerialIO}
  ecNullApi                = -3001;    {No device layer specified}
  ecNotSupported           = -3002;    {Function not supported by driver}
  ecRegisterHandlerFailed  = -3003;    {EnableCommNotification failed}
  ecPutBlockFail           = -3004;    {Failed to put entire block}
  ecGetBlockFail           = -3005;    {Failed to get entire block}
  ecOutputBufferTooSmall   = -3006;    {Output buffer too small for block}
  ecBufferIsEmpty          = -3007;    {Buffer is empty}
  ecTracingNotEnabled      = -3008;    {Tracing not enabled}
  ecLoggingNotEnabled      = -3009;    {Logging not enabled}
  ecBaseAddressNotSet      = -3010;    {Base addr not found, RS485 mode}

const
  {Modem/Pager}
  ecModemNotStarted        = -4001;    {StartModem has not been called}
  ecModemBusy              = -4002;    {Modem is busy elsewhere}
  ecModemNotDialing        = -4003;    {Modem is not currently dialing}
  ecNotDialing             = -4004;    {TModemDialer is not dialing}
  ecAlreadyDialing         = -4005;    {TModemdialer is already dialing}
  ecModemNotResponding     = -4006;    {No response from modem}
  ecModemRejectedCommand   = -4007;    {Bad command sent to modem}
  ecModemStatusMismatch    = -4008;    {Wrong modem status requested}

  ecDeviceNotSelected      = -4009;    { Um, the modem wan't selected }
  ecModemDetectedBusy      = -4010;    { Modem detected busy signal }
  ecModemNoDialtone        = -4011;    { No dialtone detected }
  ecModemNoCarrier         = -4012;    { No carrier from modem }
  ecModemNoAnswer          = -4013;    { Modem returned No Answer response }

  { Pager }
  ecInitFail               = -4014;    { Modem initialization failure }
  ecLoginFail              = -4015;    { Login Failure }
  ecMinorSrvErr            = -4016;    { SNPP - Minor Server Error }
  ecFatalSrvErr            = -4017;    { SNPP - Fatal Server Error }

const
  {LibModem}
  ecModemNotFound          = -4020;    { Modem not found in modemcap }
  ecInvalidFile            = -4021;    { a modemcap file is invalid }

const {RAS connection status codes}
  csOpenPort               = 4500;
  csPortOpened             = 4501;
  csConnectDevice          = 4502;
  csDeviceConnected        = 4503;
  csAllDevicesConnected    = 4504;
  csAuthenticate           = 4505;
  csAuthNotify             = 4506;
  csAuthRetry              = 4507;
  csAuthCallback           = 4508;
  csAuthChangePassword     = 4509;
  csAuthProject            = 4510;
  csAuthLinkSpeed          = 4511;
  csAuthAck                = 4512;
  csReAuthenticate         = 4513;
  csAuthenticated          = 4514;
  csPrepareForCallback     = 4515;
  csWaitForModemReset      = 4516;
  csWaitForCallback        = 4517;
  csProjected              = 4518;

  csStartAuthentication    = 4519;
  csCallbackComplete       = 4520;
  csLogonNetwork           = 4521;
  csSubEntryConnected      = 4522;
  csSubEntryDisconnected   = 4523;
  csRasInteractive         = 4550;
  csRasRetryAuthentication = 4551;
  csRasCallbackSetByCaller = 4552;
  csRasPasswordExpired     = 4553;
  csRasDeviceConnected     = 4599;
  csRasBaseEnd             = csSubEntryDisconnected;
  csRasPaused              = $1000;
  csInteractive            = csRasPaused;
  csRetryAuthentication    = csRasPaused + 1;
  csCallbackSetByCaller    = csRasPaused + 2;
  csPasswordExpired        = csRasPaused + 3;
  csRasPausedEnd           = csRasPaused + 3;

  csRasConnected           = $2000;
  csRasDisconnected        = csRasConnected + 1;

  { Protocols }
  { If strings are added -- apStatusMsg needs to be changed in AWABSPCL.PAS }

const
  psOK                 = 4700;   {Protocol is ok}
  psProtocolHandshake  = 4701;   {Protocol handshaking in progress}
  psInvalidDate        = 4702;   {Bad date/time stamp received and ignored}
  psFileRejected       = 4703;   {Incoming file was rejected}
  psFileRenamed        = 4704;   {Incoming file was renamed}
  psSkipFile           = 4705;   {Incoming file was skipped}
  psFileDoesntExist    = 4706;   {Incoming file doesn't exist locally, skipped}
  psCantWriteFile      = 4707;   {Incoming file skipped due to Zmodem options}
  psTimeout            = 4708;   {Timed out waiting for something}
  psBlockCheckError    = 4709;   {Bad checksum or CRC}
  psLongPacket         = 4710;   {Block too long}
  psDuplicateBlock     = 4711;   {Duplicate block received and ignored}
  psProtocolError      = 4712;   {Error in protocol}
  psCancelRequested    = 4713;   {Cancel requested}
  psEndFile            = 4714;   {At end of file}
  psResumeBad          = 4715;   {B+ host refused resume request}
  psSequenceError      = 4716;   {Block was out of sequence}
  psAbortNoCarrier     = 4717;   {Aborting on carrier loss}
  psAbort              = 4730;   {Session aborted}                     

const
  {Specific to certain protocols}
  psGotCrcE            = 4718;   {Got CrcE packet (Zmodem)}
  psGotCrcG            = 4719;   {Got CrcG packet (Zmodem)}
  psGotCrcW            = 4720;   {Got CrcW packet (Zmodem)}
  psGotCrcQ            = 4721;   {Got CrcQ packet (Zmodem)}
  psTryResume          = 4722;   {B+ is trying to resume a download}
  psHostResume         = 4723;   {B+ host is resuming}
  psWaitAck            = 4724;   {Waiting for B+ ack (internal)}

const
  {Internal}
  psNoHeader           = 4725;   {Protocol is waiting for header (internal)}
  psGotHeader          = 4726;   {Protocol has header (internal)}
  psGotData            = 4727;   {Protocol has data packet (internal)}
  psNoData             = 4728;   {Protocol doesn't have data packet yet (internal)}

  { Constants for fax strings }
  { If strings are added -- afStatusMsg needs to be changed in AWABSFAX.PAS }
const
  {Fax progress codes, sending}
  fpInitModem          = 4801;   {Initializing modem for fax processing}
  fpDialing            = 4802;   {Dialing}
  fpBusyWait           = 4803;   {Busy, FaxTransmit is waiting}
  fpSendPage           = 4804;   {Sending document page data}
  fpSendPageStatus     = 4805;   {Send EOP}
  fpPageError          = 4806;   {Error sending page}
  fpPageOK             = 4807;   {Page accepted by remote}
  fpConnecting         = 4808;   {Send call handoff connecting}

const
  {Fax progress codes, receiving}
  fpWaiting            = 4820;   {Waiting for incoming call}
  fpNoConnect          = 4821;   {No connect on this call}
  fpAnswer             = 4822;   {Answering incoming call}
  fpIncoming           = 4823;   {Incoming call validated as fax}
  fpGetPage            = 4824;   {Getting page data}
  fpGetPageResult      = 4825;   {Getting end-of-page signal}
  fpCheckMorePages     = 4826;   {getting end-of-document status}
  fpGetHangup          = 4827;   {Get hangup command}
  fpGotHangup          = 4828;   {Got Class 2 FHNG code}

const
  {Fax server codes }
  fpSwitchModes        = 4830;   {Switching from send/recv or recv/send} 
  fpMonitorEnabled     = 4831;   {Monitoring for incoming faxes}         
  fpMonitorDisabled    = 4832;   {Not monitoring for incoming faxes}     
  
const
  {Fax progress codes, common}
  fpSessionParams      = 4840;   {Getting connection params}
  fpGotRemoteID        = 4841;   {got called-station ID}
  fpCancel             = 4842;   {User abort}
  fpFinished           = 4843;   {Finished with this fax}

const
  {Trigger errors}
  ecNoMoreTriggers         = -5001;    {No more trigger slots}
  ecTriggerTooLong         = -5002;    {Data trigger too long}
  ecBadTriggerHandle       = -5003;    {Bad trigger handle}

const
  {Packet errors}
  ecStartStringEmpty       = -5501;    {Start string is empty}
  ecPacketTooSmall         = -5502;    {Packet size cannot be smaller than start string}
  ecNoEndCharCount         = -5503;    {CharCount packets must have an end-condition}
  ecEmptyEndString         = -5504;    {End string is empty}
  ecZeroSizePacket         = -5505;    {Packet size cannot be zero}
  ecPacketTooLong          = -5506;    {Packet too long}

const
  {Protocol errors}
  ecBadFileList            = -6001;    {Bad format in file list}
  ecNoSearchMask           = -6002;    {No search mask specified during transmit}
  ecNoMatchingFiles        = -6003;    {No files matched search mask}
  ecDirNotFound            = -6004;    {Directory in search mask doesn't exist}
  ecCancelRequested        = -6005;    {Cancel requested}
  ecTimeout                = -6006;    {Fatal time out}
  ecProtocolError          = -6007;    {Unrecoverable event during protocol}
  ecTooManyErrors          = -6008;    {Too many errors during protocol}
  ecSequenceError          = -6009;    {Block sequence error in Xmodem}
  ecNoFilename             = -6010;    {No filename specified in protocol receive}
  ecFileRejected           = -6011;    {File was rejected}
  ecCantWriteFile          = -6012;    {Cant write file}
  ecTableFull              = -6013;    {Kermit window table is full, fatal error}
  ecAbortNoCarrier         = -6014;    {Aborting due to carrier loss}
  ecBadProtocolFunction    = -6015;    {Function not support by protocol}
  ecProtocolAbort          = -6016;    {Session aborted}

const
  {INI database}
  ecKeyTooLong             = -7001;    {Key string too long}
  ecDataTooLarge           = -7002;    {Data string too long}
  ecNoFieldsDefined        = -7003;    {No fields defined in database}
  ecIniWrite               = -7004;    {Generic INI file write error}
  ecIniRead                = -7005;    {Generic INI file read error}
  ecNoIndexKey             = -7006;    {No index defined for database}
  ecRecordExists           = -7007;    {Record already exists}
  ecRecordNotFound         = -7008;    {Record not found in database}
  ecMustHaveIdxVal         = -7009;    {Invalid index key name}
  ecDatabaseFull           = -7010;    {Maximum database records (999) reached}
  ecDatabaseEmpty          = -7011;    {No records in database}
  ecDatabaseNotPrepared    = -7012;    {iPrepareIniDatabase not called}
  ecBadFieldList           = -7013;    {Bad field list in INIDB}
  ecBadFieldForIndex       = -7014;    {Bad field for index in INIDB}

const                                                                    {!!.04}
  {State Machine}                                                        {!!.04}
  ecNoStateMachine         = -7500;    {No state machine}                {!!.04}
  ecNoStartState           = -7501;    {StartState not set}              {!!.04}
  ecNoSapiEngine           = -7502;    {SAPI Engine not set}             {!!.04}               

const
  ecFaxBadFormat           = -8001;    {File is not an APF file}
  ecBadGraphicsFormat      = -8002;    {Unsupported graphics file format}
  ecConvertAbort           = -8003;    {User aborted fax conversion}
  ecUnpackAbort            = -8004;    {User aborted fax unpack}
  ecCantMakeBitmap         = -8005;    {CreateBitmapIndirect API failure}
  ecNoImageLoaded          = -8050;    {no image loaded into viewer}
  ecNoImageBlockMarked     = -8051;    {no block of image marked}
  ecFontFileNotFound       = -8052;    {APFAX.FNT not found, or resource bad}
  ecInvalidPageNumber      = -8053;    {Invalid page number specified for fax}
  ecBmpTooBig              = -8054;    {BMP size exceeds Windows' maxheight of 32767}
  ecEnhFontTooBig          = -8055;    {Font selected for enh text converter too large}

const
  ecFaxBadMachine          = -8060;    {Fax incompatible with remote fax}
  ecFaxBadModemResult      = -8061;    {Bad response from modem}
  ecFaxTrainError          = -8062;    {Modems failed to train}
  ecFaxInitError           = -8063;    {Error while initializing modem}
  ecFaxBusy                = -8064;    {Called fax number was busy}
  ecFaxVoiceCall           = -8065;    {Called fax number answered with voice}
  ecFaxDataCall            = -8066;    {Incoming data call}
  ecFaxNoDialTone          = -8067;    {No dial tone}
  ecFaxNoCarrier           = -8068;    {Failed to connect to remote fax}
  ecFaxSessionError        = -8069;    {Fax failed in mid-session}
  ecFaxPageError           = -8070;    {Fax failed at page end}
  ecFaxGDIPrintError       = -8071;    {NextBand GDI error in fax print driver}
  ecFaxMixedResolution     = -8072;    {Multiple resolutions in one session}
  ecFaxConverterInitFail   = -8073;    {Initialization of fax converter failed}
  ecNoAnswer               = -8074;    {Remote fax did not answer}                 
  ecAlreadyMonitored       = -8075;    {MonitorDir already being used}
  ecFaxMCFNoAnswer         = -8076;    {Remote disconnected after last page}{!!.06}

const
  ecUniAlreadyInstalled    = -8080;    {Unidrv support files already installed}
  ecUniCannotGetSysDir     = -8081;    {Cannot determine windows system dir}
  ecUniCannotGetWinDir     = -8082;    {Cannot determine windows dir}
  ecUniUnknownLayout       = -8083;    {Cannot determine setup file layout}
  ecUniCannotInstallFile   = -8085;    {Cannot install Unidrv files to system dir}
  ecRasDDNotInstalled      = -8086;    {Cannot install RASDD files }     {!!.05}
  ecDrvCopyError           = -8087;    {Error copying printer driver}
  ecCannotAddPrinter       = -8088;    {32-bit AddPrinter call failed}
  ecDrvBadResources        = -8089;    {Bad/missing resources in driver}
  ecDrvDriverNotFound      = -8090;    {Driver file not found}
  ecUniCannotGetPrinterDriverDir
                           = -8091;    {Cannot determine Win NT printer driver dir}
  ecInstallDriverFailed    = -8092;    {AddPrinterDriver API failed}

    { TApdGSMPhone error codes }
const
  ecSMSBusy                = -8100;    {Busy with another command}
  ecSMSTimedOut            = -8101;    {Timed out, no response back}
  ecSMSTooLong             = -8102;    {SMS message too long}
  ecSMSUnknownStatus       = -8103;    {Status unknown}
  ecSMSInvalidNumber       = -8138;    {Invalid Number or Network out of order} {!!.06}
  ecMEFailure              = -8300;    {Mobile Equipment Failure}
  ecServiceRes             = -8301;    {SMS service of ME reserved}
  ecBadOperation           = -8302;    {Operation not allowed}
  ecUnsupported            = -8303;    {Operation not supported}
  ecInvalidPDU             = -8304;    {Invalid PDU mode parameter}
  ecInvalidText            = -8305;    {Invalid Text mode parameter}
  ecSIMInsert              = -8310;    {SIM card not inserted}
  ecSIMPin                 = -8311;    {SIM PIN required}
  ecSIMPH                  = -8312;    {PH-SIM PIN required}
  ecSIMFailure             = -8313;    {SIM failure}
  ecSIMBusy                = -8314;    {SIM busy}
  ecSIMWrong               = -8315;    {SIM wrong}
  ecSIMPUK                 = -8316;    {SIM PUK required}
  ecSIMPIN2                = -8317;    {SIM PIN2 required}
  ecSIMPUK2                = -8318;    {SIM PUK2 required}
  ecMemFail                = -8320;    {Memory failure}
  ecInvalidMemIndex        = -8321;    {Invalid memory index}
  ecMemFull                = -8322;    {Memory full}
  ecSMSCAddUnknown         = -8330;    {SMS Center Address unknown}
  ecNoNetwork              = -8331;    {No network service}
  ecNetworkTimeout         = -8332;    {Network timeout}
  ecCNMAAck                = -8340;    {No +CNMA acknowledgement expected}
  ecUnknown                = -8500;    {Unknown error}


const
  ecADWSERROR                      = 9001;
  ecADWSLOADERROR                  = 9002;
  ecADWSVERSIONERROR               = 9003;
  ecADWSNOTINIT                    = 9004;
  ecADWSINVPORT                    = 9005;
  ecADWSCANTCHANGE                 = 9006;
  ecADWSCANTRESOLVE                = 9007;

  { All Windows Sockets error constants are biased by 10000 from the "normal" }
  wsaBaseErr = 10000;

  { Windows Sockets definitions of regular Microsoft C error constants }
  wsaEIntr  = 10004;
  wsaEBadF  = 10009;
  wsaEAcces = 10013;
  wsaEFault = 10014;
  wsaEInVal = 10022;
  wsaEMFile = 10024;

  { Windows Sockets definitions of regular Berkeley error constants }
  wsaEWouldBlock     = 10035;
  wsaEInProgress     = 10036;
  wsaEAlReady        = 10037;
  wsaENotSock        = 10038;
  wsaEDestAddrReq    = 10039;
  wsaEMsgSize        = 10040;
  wsaEPrototype      = 10041;
  wsaENoProtoOpt     = 10042;
  wsaEProtoNoSupport = 10043;
  wsaESocktNoSupport = 10044;
  wsaEOpNotSupp      = 10045;
  wsaEPfNoSupport    = 10046;
  wsaEAfNoSupport    = 10047;
  wsaEAddrInUse      = 10048;
  wsaEAddrNotAvail   = 10049;
  wsaENetDown        = 10050;
  wsaENetUnreach     = 10051;
  wsaENetReset       = 10052;
  wsaEConnAborted    = 10053;
  wsaEConnReset      = 10054;
  wsaENoBufs         = 10055;
  wsaEIsConn         = 10056;
  wsaENotConn        = 10057;
  wsaEShutDown       = 10058;
  wsaETooManyRefs    = 10059;
  wsaETimedOut       = 10060;
  wsaEConnRefused    = 10061;
  wsaELoop           = 10062;
  wsaENameTooLong    = 10063;
  wsaEHostDown       = 10064;
  wsaEHostUnreach    = 10065;
  wsaENotEmpty       = 10066;
  wsaEProcLim        = 10067;
  wsaEUsers          = 10068;
  wsaEDQuot          = 10069;
  wsaEStale          = 10070;
  wsaERemote         = 10071;
  wsaEDiscOn         = 10101;

  { Extended Windows Sockets error constant definitions }

  wsaSysNotReady     = 10091;
  wsaVerNotSupported = 10092;
  wsaNotInitialised  = 10093;

  { Error return codes from gethostbyname() and gethostbyaddr() (when using the }
  { resolver). Note that these errors are retrieved via wsaGetLastError() and }
  { must therefore follow the rules for avoiding clashes with error numbers from }
  { specific implementations or language run-time systems.  For this reason the }
  { codes are based at 10000+1001. Note also that [wsa]No_Address is defined }
  { only for compatibility purposes. }
  { Authoritative Answer: Host not found }
  wsaHost_Not_Found = 11001;
  Host_Not_Found    = wsaHost_Not_Found;

  { Non-Authoritative: Host not found, or ServerFAIL }
  wsaTry_Again = 11002;
  Try_Again    = wsaTry_Again;

  { Non recoverable errors, FORMERR, REFUSED, NotIMP }
  wsaNo_Recovery = 11003;
  No_Recovery    = wsaNo_Recovery;

  { Valid name, no data record of requested type }
  wsaNo_Data = 11004;
  No_Data    = wsaNo_Data;

  { no address, look for MX record }
  wsaNo_Address = wsaNo_Data;
  No_Address    = wsaNo_Address;

  { The string resource range 13500 - 13800 is used for TAPI }
  { status messages, which do not require constants here     }

const
  {Adjusted TAPI error codes}
  ecAllocated              = -13801;
  ecBadDeviceID            = -13802;
  ecBearerModeUnavail      = -13803;
  ecCallUnavail            = -13805;
  ecCompletionOverrun      = -13806;
  ecConferenceFull         = -13807;
  ecDialBilling            = -13808;
  ecDialDialtone           = -13809;
  ecDialPrompt             = -13810;
  ecDialQuiet              = -13811;
  ecIncompatibleApiVersion = -13812;
  ecIncompatibleExtVersion = -13813;
  ecIniFileCorrupt         = -13814;
  ecInUse                  = -13815;
  ecInvalAddress           = -13816;
  ecInvalAddressID         = -13817;
  ecInvalAddressMode       = -13818;
  ecInvalAddressState      = -13819;
  ecInvalAppHandle         = -13820;
  ecInvalAppName           = -13821;
  ecInvalBearerMode        = -13822;
  ecInvalCallComplMode     = -13823;
  ecInvalCallHandle        = -13824;
  ecInvalCallParams        = -13825;
  ecInvalCallPrivilege     = -13826;
  ecInvalCallSelect        = -13827;
  ecInvalCallState         = -13828;
  ecInvalCallStatelist     = -13829;
  ecInvalCard              = -13830;
  ecInvalCompletionID      = -13831;
  ecInvalConfCallHandle    = -13832;
  ecInvalConsultCallHandle = -13833;
  ecInvalCountryCode       = -13834;
  ecInvalDeviceClass       = -13835;
  ecInvalDeviceHandle      = -13836;
  ecInvalDialParams        = -13837;
  ecInvalDigitList         = -13838;
  ecInvalDigitMode         = -13839;
  ecInvalDigits            = -13840;
  ecInvalExtVersion        = -13841;
  ecInvalGroupID           = -13842;
  ecInvalLineHandle        = -13843;
  ecInvalLineState         = -13844;
  ecInvalLocation          = -13845;
  ecInvalMediaList         = -13846;
  ecInvalMediaMode         = -13847;
  ecInvalMessageID         = -13848;
  ecInvalParam             = -13850;
  ecInvalParkID            = -13851;
  ecInvalParkMode          = -13852;
  ecInvalPointer           = -13853;
  ecInvalPrivSelect        = -13854;
  ecInvalRate              = -13855;
  ecInvalRequestMode       = -13856;
  ecInvalTerminalID        = -13857;
  ecInvalTerminalMode      = -13858;
  ecInvalTimeout           = -13859;
  ecInvalTone              = -13860;
  ecInvalToneList          = -13861;
  ecInvalToneMode          = -13862;
  ecInvalTransferMode      = -13863;
  ecLineMapperFailed       = -13864;
  ecNoConference           = -13865;
  ecNoDevice               = -13866;
  ecNoDriver               = -13867;
  ecNoMem                  = -13868;
  ecNoRequest              = -13869;
  ecNotOwner               = -13870;
  ecNotRegistered          = -13871;
  ecOperationFailed        = -13872;
  ecOperationUnavail       = -13873;
  ecRateUnavail            = -13874;
  ecResourceUnavail        = -13875;
  ecRequestOverrun         = -13876;
  ecStructureTooSmall      = -13877;
  ecTargetNotFound         = -13878;
  ecTargetSelf             = -13879;
  ecUninitialized          = -13880;
  ecUserUserInfoTooBig     = -13881;
  ecReinit                 = -13882;
  ecAddressBlocked         = -13883;
  ecBillingRejected        = -13884;
  ecInvalFeature           = -13885;
  ecNoMultipleInstance     = -13886;

const
  {Apro encounters a few of its own TAPI errors, place these error
   codes after the native TAPI error codes, but leave a little bit
   of room for expansion of the TAPI error codes.}
  ecTapiBusy               = -13928;
  ecTapiNotSet             = -13929;
  ecTapiNoSelect           = -13930;
  ecTapiLoadFail           = -13931;
  ecTapiGetAddrFail        = -13932;
  ecTapiUnexpected         = -13934;
  ecTapiVoiceNotSupported  = -13935;
  ecTapiWaveFail           = -13936;
  ecTapiCIDBlocked         = -13937;
  ecTapiCIDOutOfArea       = -13938;
  ecTapiWaveFormatError    = -13939;
  ecTapiWaveReadError      = -13940;
  ecTapiWaveBadFormat      = -13941;
  ecTapiTranslateFail      = -13942;
  ecTapiWaveDeviceInUse    = -13943;
  ecTapiWaveFileExists     = -13944;
  ecTapiWaveNoData         = -13945;

  ecVoIPNotSupported       = -13950;    { TAPI3/H.323 not found }
  ecVoIPCallBusy           = -13951;    { remote was busy }
  ecVoIPBadAddress         = -13952;    { destination address bad }
  ecVoIPNoAnswer           = -13953;    { remote did not answer }
  ecVoIPCancelled          = -13954;    { cancelled }
  ecVoIPRejected           = -13955;    { remote rejected the call }
  ecVoIPFailed             = -13956;    { general failure }
  ecVoIPTapi3NotInstalled  = -13957;    { ITTapi interface failure }     {!!.01}
  ecVoIPH323NotFound       = -13958;    { H.323 line not found }         {!!.01}
  ecVoIPTapi3EventFailure  = -13959;    { event notify failure }         {!!.01}

  {RAS error codes}
  ecRasLoadFail            = -13980;

const
  {Convenient character constants (and aliases)}
  cNul = #0;
  cSoh = #1;
  cStx = #2;
  cEtx = #3;
  cEot = #4;
  cEnq = #5;
  cAck = #6;
  cBel = #7;
  cBS  = #8;
  cTab = #9;
  cLF  = #10;
  cVT  = #11;
  cFF  = #12;
  cCR  = #13;
  cSO  = #14;
  cSI  = #15;
  cDle = #16;
  cDC1 = #17;       cXon  = #17;
  cDC2 = #18;
  cDC3 = #19;       cXoff = #19;
  cDC4 = #20;
  cNak = #21;
  cSyn = #22;
  cEtb = #23;
  cCan = #24;
  cEM  = #25;
  cSub = #26;
  cEsc = #27;
  cFS  = #28;
  cGS  = #29;
  cRS  = #30;
  cUS  = #31;

type
  {Protocol status information record}
  TProtocolInfo = record
    piProtocolType     : Cardinal;
    piBlockErrors      : Cardinal;
    piTotalErrors      : Cardinal;
    piBlockSize        : Cardinal;
    piBlockNum         : Cardinal;
    piFileSize         : Integer;
    piBytesTransferred : Integer;
    piBytesRemaining   : Integer;
    piInitFilePos      : Integer;
    piElapsedTicks     : Integer;
    piFlags            : Integer;
    piBlockCheck       : Cardinal;
    piFileName         : TPathCharArrayA;
    piError            : Integer;
    piStatus           : Cardinal;
  end;

const
  {Port options}
  poUseEventWord   = $04;   {Set to use the event word}

  { APRO-specific flags used in InitPort}
  ipAssertDTR      = $00000001;
  ipAssertRTS      = $00000002;
  ipAutoDTR        = $00000010;
  ipAutoRTS        = $00000020;

  {Hardware flow control options}
  hfUseDTR         = $01;   {Use DTR for receive flow control}
  hfUseRTS         = $02;   {Use RTS for receive flow control}
  hfRequireDSR     = $04;   {Require DSR before transmitting}
  hfRequireCTS     = $08;   {Require CTS before transmitting}

  {Software flow control options}
  sfTransmitFlow   = $01;   {Honor received Xon/Xoffs}
  sfReceiveFlow    = $02;   {Send Xon/Xoff as required}

  {Define bits for TDCB Flags field}
  dcb_Binary                = $0001;
  dcb_Parity                = $0002;
  dcb_OutxCTSFlow           = $0004;
  dcb_OutxDSRFlow           = $0008;
  dcb_DTRBit1               = $0010;
  dcb_DTRBit2               = $0020;
  dcb_DsrSensitivity        = $0040;
  dcb_TxContinueOnXoff      = $0080;
  dcb_OutX                  = $0100;
  dcb_InX                   = $0200;
  dcb_ErrorChar             = $0400;
  dcb_Null                  = $0800;
  dcb_RTSBit1               = $1000;
  dcb_RTSBit2               = $2000;
  dcb_AbortOnError          = $4000;

  dcb_DTR_CONTROL_ENABLE    = dcb_DTRBit1;
  dcb_DTR_CONTROL_HANDSHAKE = dcb_DTRBit2;
  dcb_RTS_CONTROL_ENABLE    = dcb_RTSBit1;
  dcb_RTS_CONTROL_HANDSHAKE = dcb_RTSBit2;
  dcb_RTS_CONTROL_TOGGLE    = (dcb_RTSBit1 + dcb_RTSBit2);

  {For reporting flow states, note: no receive hardware flow status is provided}
  fsOff      = 1;  {No flow control is in use}
  fsOn       = 2;  {Flow control is but not transmit blocked}
  fsDsrHold  = 3;  {Flow control is on and transmit blocked by low DSR}
  fsCtsHold  = 4;  {Flow control is on and transmit blocked by low CTS}
  fsDcdHold  = 5;  {Flow control is on and transmit blocked by low DCD}
  fsXOutHold = 6;  {Flow control is on and transmit blocked by Xoff}
  fsXInHold  = 7;  {Flow control is on and receive blocked by Xoff}
  fsXBothHold= 8;  {Flow control is on and both are blocked by Xoff}

const
  {Emulator commands}
  eNone            = 0;       {No command, ignore this char}
  eChar            = 1;       {No command, process the char}
  eGotoXY          = 2; {X}   {Absolute goto cursor position call}
  eUp              = 3; {X}   {Cursor up}
  eDown            = 4; {X}   {Cursor down}
  eRight           = 5; {X}   {Cursor right}
  eLeft            = 6; {X}   {Cursor left}
  eClearBelow      = 7; {R}   {Clear screen below cursor}
  eClearAbove      = 8; {R}   {Clear screen above cursor}
  eClearScreen     = 9; {R}   {Clear entire screen}
  eClearEndofLine  = 10;{R}   {Clear from cursor to end of line}
  eClearStartOfLine= 11;{R}   {Clear from cursor to the start of line}
  eClearLine       = 12;{R}   {Clear entire line that cursor is on}
  eSetMode         = 13;{X}   {Set video mode}
  eSetBackground   = 14;      {Set background attribute}
  eSetForeground   = 15;      {Set foreground attribute}
  eSetAttribute    = 16;{X}   {Set video attribute (foreground and background)}
  eSaveCursorPos   = 17;      {Save cursor position}
  eRestoreCursorPos= 18;      {Restore cursor position}
  eDeviceStatusReport = 19;{X}{Report device status or cursor position}
  eString          = 20;      {Pascal style string}
  eHT              = 21;      {Horizontal Tab Character}
  eError           = 255;     {indicates a parser error}

  eAPC  { } = 30;      {Application programming command}
  eCBT  {X} = 31;      {Cursor backward tabulation}
  eCCH  { } = 32;      {Cancel character}
  eCHA  {X} = 33;      {Cursor horizontal absolute}
  eCHT  {X} = 34;      {Cursor horizontal tabulation}
  eCNL  {X} = 35;      {Cursor next line}
  eCPL  {X} = 36;      {Cursor preceding line}
  eCPR  {X} = 37;      {Cursor position report}
  eCRM  {.} = 38;      {Control representation mode}
  eCTC  {X} = 39;      {Cursor tabulation control}
  eCUB  {X} = eLeft;   {Cursor backward}
  eCUD  {X} = eDown;   {Cursor down}
  eCUF  {X} = eRight;  {Cursor forward}
  eCUP  {X} = eGotoXY; {Cursor position}
  eCUU  {X} = eUp;     {Cursor up}
  eCVT  {X} = 40;      {Cursor vertical tabulation}
  eDA   {X} = 41;      {Device attributes}
  eDAQ  { } = 42;      {Define area qualification}
  eDCH  {X} = 43;      {Delete character}
  eDCS  { } = 44;      {Device control string}
  eDL   {X} = 45;      {Delete line}
  eDMI  { } = 46;      {Disable manual input}
  eDSR  {X} = eDeviceStatusReport;{Device status report}
  eEA   { } = 47;      {Erase in area}
  eEBM  { } = 48;      {Editing boundry mode}
  eECH  {X} = 49;      {Erase character}
  eED   {X} = 50;      {Erase in Display}
  eEF   { } = 51;      {Erase in field}
  eEL   {X} = 52;      {Erase in line}
  eEMI  { } = 53;      {Enable manual input}
  eEPA  { } = 54;      {End of protected mode}
  eERM  { } = 55;      {Erasure mode}
  eESA  { } = 56;      {End of selected area}
  eFEAM { } = 57;      {Format effector action mode}
  eFETM { } = 58;      {Format effector transfer mode}
  eFNT  { } = 59;      {Font selection}
  eGATM { } = 60;      {Guarded area transfer mode}
  eGSM  { } = 61;      {Graphics size modification}
  eGSS  { } = 62;      {Graphics size selection}
  eHEM  { } = 63;      {Horizontal editing mode}
  eHPA  {X} = eCHA;    {Horizontal position absolute}
  eHPR  {X} = eCUF;    {Horizontal position relative}
  eHTJ  {X} = 64;      {Horizontal tab with justification}
  eHTS  {X} = 65;      {Horizontal tabulation set}
  eHVP  {X} = eCUP;    {Horizontal and vertical position}
  eICH  {X} = 66;      {Insert character}
  eIL   {X} = 67;      {Insert line}
  eIND  {X} = eCUD;    {Index}
  eINT  { } = 68;      {Interrupt}
  eIRM  {.} = 69;      {Inseration-Replacement mode}
  eJFY  { } = 70;      {Justify}
  eKAM  {.} = 71;      {Keyboard action mode}
  eLNM  {.} = 72;      {Line feed new line mode}
  eMATM { } = 73;      {Multiple area transfer mode}
  eMC   {.} = 74;      {Media copy}
  eMW   {.} = 75;      {Message waiting}
  eNEL  {X} = 76;      {Next line}
  eNP   {.} = 77;      {Next page}
  eOSC  { } = 78;      {Operating system command}
  ePLD  { } = 79;      {Partial line down}
  ePLU  { } = 80;      {Partial line up}
  ePM   { } = 81;      {Privacy message}
  ePP   {.} = 82;      {Preceding page}
  ePU1  { } = 83;      {Private use 1}
  ePU2  { } = 84;      {Private use 2}
  ePUM  { } = 85;      {Positioning unit mode}
  eQUAD { } = 86;      {Quad}
  eREP  { } = 87;      {Repeat}
  eRI   {X} = 88;      {Reverse index}
  eRIS  {.} = 89;      {Reset to initial state}
  eRM   {.} = 90;      {Reset mode}
  eSATM { } = 91;      {Selected area transfer mode}
  eSD   { } = 92;      {Scroll down}
  eSEM  { } = 93;      {selected editing extent mode}
  eSGR  {X} = eSetAttribute;{Select graphics rendition}
  eSL   { } = 94;      {Scroll left}
  eSM   {.} = eSetMode;{Set Mode}
  eSPA  { } = 95;      {Start of protected area}
  eSPI  { } = 96;      {Spacing increment}
  eSR   { } = 97;      {Scroll right}
  eSRM  { } = 98;      {Send-Receive mode}
  eSRTM { } = 99;      {Status report transfer mode}
  eSS2  { } = 100;     {Single shift 2}
  eSS3  { } = 101;     {Single shift 3}
  eSSA  { } = 102;     {Start of selected area}
  eST   { } = 103;     {String terminator}
  eSTS  { } = 104;     {Set transmit state}
  eSU   { } = 105;     {Scroll up}
  eTBC  {X} = 106;     {Tabulation clear}
  eTSM  { } = 107;     {Tabulation stop mode}
  eTSS  { } = 108;     {Thin space specification}
  eTTM  { } = 109;     {Transfer termination mode}
  eVEM  { } = 110;     {Vertical editing mode}
  eVPA  {X} = 111;     {Vertical position absolute}
  eVPR  {X} = eCUD;    {Vertical position relative}
  eVTS  {X} = 112;     {vertical tabulation set}
  eDECSTBM  = 113;     {dec private-set Top/Bottom margin}

  eENQ  {X} = 114;     {enquiry request}
  eBEL  {X} = 115;     {sound bell}
  eBS   {X} = 116;     {backspace}
  eLF   {X} = 117;     {line feed command}
  eCR   {X} = 118;     {carriage return}
  eSO   {X} = 119;     {invoke G1 charset}
  eSI   {X} = 120;     {invoke G0 charset}
  eIND2 {X} = 121;     {corrected eIND (<> eCUD, eDown) new term only}
  eDECALN   = 122;     {DEC PRIVATE-screen alignment display}
  eDECDHL   = 123;     {DEC PRIVATE-Double height line}
  eDECDWL   = 124;     {DEC PRIVATE-Double width line}
  eDECLL    = 125;     {DEC PRIVATE-load LEDs}
  eDECREQTPARM = 126;  {DEC PRIVATE-request terminal parameters}
  eDECSWL   = 127;     {DEC PRIVATE-single width line}
  eDECTST   = 128;     {DEC PRIVATE-Invoke confidence test}
  eDECSCS   = 129;     {DEC PRIVATE-select charset}

  {Extended attributes}
  eattrBlink      = $01;
  eattrInverse    = $02;
  eattrIntense    = $04;
  eattrInvisible  = $08;
  eattrUnderline  = $10;

  {ANSI color constants}
  emBlack       = 0;
  emRed         = 1;
  emGreen       = 2;
  emYellow      = 3;
  emBlue        = 4;
  emMagenta     = 5;
  emCyan        = 6;
  emWhite       = 7;
  emBlackBold   = 8;
  emRedBold     = 9;
  emGreenBold   = 10;
  emYellowBold  = 11;
  emBlueBold    = 12;
  emMagentaBold = 13;
  emCyanBold    = 14;
  emWhiteBold   = 15;

  {AnsiEmulator option flags}
  teMapVT100           = $0001;

  {Misc}
  MaxParams   = 5;       {Maximum parameters for our interpreter}
  MaxQueue    = 20;      {Maximum characters in queue}
  MaxOther    = 11;      {Maximum other data}
  MaxParamLength = 5;    {Maximum parameter length for interpreter}
  KeyMappingLen = 20;    {Maximum length of a keymapping}

type
  {AnsiEmulator's parser states}
  TAnsiParser = (GotNone, GotEscape, GotBracket, GotSemiColon, GotParam,
                 GotCommand, GotControlSeqIntro, GotLeftBrace, GotRightBrace,
                 GotSpace, GotQuestionMark, GotQuestionParam);

  {Array used for internal queue}
  TApQueue = Array[1..MaxQueue] of AnsiChar;                                    // SWB

  {Emulator for PC ANSI codes}
  PAnsiEmulator = ^TAnsiEmulator;
  TAnsiEmulator = record
    emuType        : Cardinal;       { Emulator Type }
    emuFlags       : Cardinal;
    emuFirst       : Bool;           {True if first time thru}
    emuAttr        : Byte;
    emuIndex       : Cardinal;       {Index into rcvd byte array}
    emuParamIndex  : Cardinal;       {Parameter index}
    emuQueue       : TApQueue;       {Queue of recvd bytes}                 // SWB
    emuParamStr    : array[1..MaxParams] of string[MaxParamLength];
    emuParamInt    : array[1..MaxParams] of Integer;
    emuParserState : TAnsiParser;    {Current state}
    emuOther       : Pointer;
  end;

const
  {Terminal window Cardinal}
  gwl_Terminal = 0;

  {Terminal options}
  tws_WantTab        = $0001; {Process tabs internally}
  tws_IntHeight      = $0002; {Integral height}
  tws_IntWidth       = $0004; {Integral width}
  tws_AutoHScroll    = $0008; {Add/remove horiz scroll automatically}
  tws_AutoVScroll    = $0010; {Add/remove vert scroll automatically}

type
  {For general typecasting}
  LH = record
    L,H : Word;
  end;

  {IniDBase (deprecated) consts and types}
const
  MaxDBRecs    = 999;         {Maximum number of database records}
  MaxNameLen   = 21;          {Maximum length of a profile string key}
  MaxIndexLen  = 31;          {Maximum length of an index string}
  NonValue     = '#';         {Value of DB fields SPECIFICALLY left blank}
  dbIndex      = 'Index';     {Item index section heading}
  dbDefaults   = 'Defaults';  {Default value section heading}
  dbNumEntries = '_Entries';  {Number of entries key name}
  dbBogus      = 'None';      {Bogus key name for creating sections}

type
  PIniDatabaseKey = ^TIniDatabaseKey;
  TIniDatabaseKey = record
    KeyName  : PAnsiChar;
    DataSize : Cardinal;
    StrType  : Bool;
    Index    : Bool;
    Next     : PIniDatabaseKey;
  end;

  PIniDatabase = ^TIniDatabase;
  TIniDatabase = record
    FName          : PAnsiChar;
    DictionaryHead : PIniDatabaseKey;
    DictionaryTail : PIniDatabaseKey;
    NumRecords     : Integer;
    RecordSize     : Cardinal;
    DefaultRecord  : Pointer;
    Prepared       : Bool;
  end;

const
  ApdMaxTags      = 5;     {Maximum number of err corr or data comp tags}
  ApdTagSepChar   = ',';   {Character that separates tags in a profile string}

const
  ApdModemNameLen = 31;    {Length of a modem name string}
  ApdCmdLen       = 41;    {Maximum length of a modem command}
  ApdRspLen       = 21;    {Maximum length of a modem response}
  ApdTagLen       = 21;    {Maximum length of a tag string}
  ApdTagProfLen   = 105;   {Maximum length of a tag profile string}
  ApdBoolLen      = 5;     {Maximum length of a boolean string}
  ApdBaudLen      = 7;     {Maximum length of a baud rate string}
  ApdConfigLen    = 255;   {Maximum length of a configuration string}

type
  {where these same variables are declared as Strings.}
  TModemNameZ     = array[0..ApdModemNameLen] of AnsiChar; //SZ: must probably be Ansi
  TCmdStringZ     = array[0..ApdCmdLen] of AnsiChar;
  TRspStringZ     = array[0..ApdRspLen] of AnsiChar;
  TTagStringZ     = array[0..ApdTagLen] of AnsiChar;
  TTagProfStringZ = array[0..ApdTagProfLen] of AnsiChar;
  TConfigStringZ  = array[0..ApdConfigLen] of AnsiChar;
  TBoolStrZ       = array[0..ApdBoolLen] of AnsiChar;
  TBaudStrZ       = array[0..ApdBaudLen] of AnsiChar;

  TTagArrayZ = array[1..ApdMaxTags] of TTagStringZ;

  PModemBaseData = ^TModemBaseData;
  TModemBaseData = record
    Name          : TModemNameZ;
    InitCmd       : TCmdStringZ;
    DialCmd       : TCmdStringZ;
    DialTerm      : TCmdStringZ;
    DialCancel    : TCmdStringZ;
    HangupCmd     : TCmdStringZ;
    ConfigCmd     : TConfigStringZ;
    AnswerCmd     : TCmdStringZ;
    OkMsg         : TRspStringZ;
    ConnectMsg    : TRspStringZ;
    BusyMsg       : TRspStringZ;
    VoiceMsg      : TRspStringZ;
    NoCarrierMsg  : TRspStringZ;
    NoDialToneMsg : TRspStringZ;
    ErrorMsg      : TRspStringZ;
    RingMsg       : TRspStringZ;
  end;

  PModemData = ^TModemData;
  TModemData = record
    Data        : TModemBaseData;
    NumErrors   : Cardinal;
    Errors      : TTagArrayZ;
    NumComps    : Cardinal;
    Compression : TTagArrayZ;
    LockDTE     : Bool;
    DefBaud     : Integer;
  end;

  PModemXFer = ^TModemXFer;
  TModemXFer = record
    Data     : TModemBaseData;
    Errors   : TTagProfStringZ;
    Compress : TTagProfStringZ;
    LockDTE  : TBoolStrZ;
    DefBaud  : TBaudStrZ;
  end;

  PModemDatabase = ^TModemDatabase;
  TModemDatabase = record
    DB : PIniDatabase;
  end;


const
  {keyboard shift state masks}
  ksControl = $02;
  ksAlt     = $04;
  ksShift   = $08;

  {keyboard toggle state masks}
  tsCapital = $02;
  tsNumlock = $04;
  tsScroll  = $08;

  {keyboard INI file constants}
  ApdKeyMapNameLen  = 30;    {Length of a KeyMap name string}
  ApdMaxKeyMaps     = 100;   {Maximum possible key mapping per type}

  ApdKeyIndexName    = 'EMULATOR';
  ApdKeyIndexMaxLen  = 120;

type
  TKeyMapName    = array[0..ApdKeyMapNameLen] of AnsiChar;
  TKeyMapping    = array[0..KeyMappingLen] of Ansichar;
  TKeyMappingStr = string[KeyMappingLen];


  PKeyMapXFerRec = ^TKeyMapXFerRec;
  TKeyMapXFerRec = record
    Name : TKeyMapName;
    Keys : array[1..ApdMaxKeyMaps] of TKeyMapping;
  end;

  PVKeyMapRec = ^TVKeyMapRec;
  TVKEyMapRec = record
    KeyCode   : Cardinal;
    ShiftState: Cardinal;
    Mapping   : TKeyMappingStr;
  end;

  PKeyEmulator = ^TKeyEmulator;
  TKeyEmulator = record
    kbKeyFileName : PChar;                            { current file name }
    kbKeyName     : TKeyMapName;                      { current key index name }
    kbProcessAll  : Bool;
    kbProcessExt  : Bool;
    kbKeyNameList : array[0..ApdKeyIndexMaxLen] of Ansichar;
    kbKeyMap      : array[1..ApdMaxKeyMaps] of TVKeyMapRec;
    kbKeyDataBase : PIniDataBase;          { pointer to the INI data base file }
  end;

const
  {---- Option codes for protocols ----}
  apIncludeDirectory   = $0001;   {Set to include directory in file names}
  apHonorDirectory     = $0002;   {Set to honor directory in file names}
  apRTSLowForWrite     = $0004;   {Set to lower RTS during disk writes}
  apAbortNoCarrier     = $0008;   {Set to abort protocol on DCD loss}
  apKermitLongPackets  = $0010;   {Set to support long packets}
  apKermitSWC          = $0020;   {Set to support SWC}
  apZmodem8K           = $0040;   {Set to support 8K blocks}
  apBP2KTransmit       = $0080;   {Set to support 2K transmit blocks}
  apAsciiSuppressCtrlZ = $0100;   {Set to stop transmitting on ^Z}

  {---- Default options for protocols ----}
  DefProtocolOptions = 0;
  BadProtocolOptions = apKermitLongPackets+apKermitSWC+apZmodem8K;

  {Block check codes}
  bcNone      = 0;        {No block checking}
  bcChecksum1 = 1;        {Basic checksum}
  bcChecksum2 = 2;        {Two byte checksum}
  bcCrc16     = 3;        {16 bit Crc}
  bcCrc32     = 4;        {32 bit Crc}
  bcCrcK      = 5;        {Kermit style Crc}

  {Convenient blockcheck string constants}
  bcsNone      = 'No check';
  bcsChecksum1 = 'Checksum';
  bcsChecksum2 = 'Checksum2';
  bcsCrc16     = 'Crc16';
  bcsCrc32     = 'Crc32';
  bcsCrck      = 'CrcKermit';

  {Constants for supported protocol types}
  NoProtocol  = 0;
  Xmodem      = 1;
  XmodemCRC   = 2;
  Xmodem1K    = 3;
  Xmodem1KG   = 4;
  Ymodem      = 5;
  YmodemG     = 6;
  Zmodem      = 7;
  Kermit      = 8;
  Ascii       = 9;
  BPlus       = 10;

  {Zmodem attention string length}
  MaxAttentionLen = 32;

  {Zmodem file management options}
  zfWriteNewerLonger = 1;          {Transfer if new, newer or longer}
  zfWriteCrc         = 2;          {Not supported, same as WriteNewer}
  zfWriteAppend      = 3;          {Transfer if new, append if exists}
  zfWriteClobber     = 4;          {Transfer regardless}
  zfWriteNewer       = 5;          {Transfer if new or newer}
  zfWriteDifferent   = 6;          {Transfer if new or diff dates/lens}
  zfWriteProtect     = 7;          {Transfer only if new}

  {Convenient protocol string constants}
  ProtocolString : array[NoProtocol..BPlus] of array[0..9] of AnsiChar= (
    'None', 'Xmodem', 'XmodemCRC', 'Xmodem1K', 'Xmodem1KG',
    'Ymodem', 'YmodemG', 'Zmodem', 'Kermit', 'Ascii', 'B+');

type
  {For holding lists of files to transmit}
  PFileList = ^TFileList;
  TFileList = array[0..65535-1] of Char;

{Fax conversion}

const
  rw1728 = 1;                     {standard width}
  rw2048 = 2;                     {extra wide}

  {Fax pixel widths}
  StandardWidth  = 1728;          {Standard width in pixels}
  WideWidth      = 2048;          {Allowed higher resolution}

  {Option flags for FAX page header}
  ffHighRes     = $0001;          {Image stored in high-res mode}
  ffHighWidth   = $0002;          {Image uses option high-width mode}
  ffLengthWords = $0004;          {Set if raster lines include length Cardinal}

  {Options for fax conversion}
  fcDoubleWidth = $0001;          {Double the horizontal width in std res}
  fcHalfHeight  = $0002;          {Halve the vertical height in std res}
  fcCenterImage = $0004;          {Center graphics images horizontally}
  fcYield       = $0008;          {Have the converter yield while converting}
  fcYieldOften  = $0010;          {Increases the number of yields}

  {Flags passed to status function}
  csStarting    = $0001;
  csEnding      = $0002;

  {Font handles, same value as bytes-per-char}
  SmallFont    = 16;
  StandardFont = 48;

  {Maximum number of tree records}
  MaxTreeRec = 306;

  {Max size of decompress buffer}
  MaxData = 4096;

  {Text conversion limits}
  MaxLineLen = 144;

  {encoding/decoding table limits}
  MaxCodeTable   = 63;
  MaxMUCodeTable = 39;

  {default extensions}
  DefTextExt = 'TXT';
  DefTiffExt = 'TIF';
  DefPcxExt  = 'PCX';
  DefDcxExt  = 'DCX';
  DefBmpExt  = 'BMP';
  DefApfExt  = 'APF';

type
  {Compression code tables}
  TCodeRec = record
    Code : Word;
    Sig  : Word;
  end;

  TTermCodeArray   = array[0..MaxCodeTable] of TCodeRec;
  TMakeUpCodeArray = array[0..MaxMUCodeTable] of TCodeRec;

  PBufferedOutputFile = ^TBufferedOutputFile;
  TBufferedOutputFile = record
    BufPos  : Word;
    Buffer  : PByteArray;
    OutFile : File;
  end;

  {For storing station IDs}
  Str20 = string[20];

  {Stores information about our fonts}
  TFontRecord = record
    Bytes  : Byte;  {# of bytes per char in font}
    PWidth : Byte;  {width of font in pixels}
    Width  : Byte;  {width of font in bytes (e.g. 16-pixel-wide = 2)}
    Height : Byte;  {height of font in raster lines}
  end;

  {Fax file signature array}
  TSigArray = Array[0..5] of AnsiChar;

const
  {Default fax file signature, first 6 chars in an APF}
  DefAPFSig : TSigArray = 'APF10'#26;

type
  {APRO fax file header record}
  TFaxHeaderRec = packed record
    Signature  : TSigArray;              {APRO FAX signature}
    FDateTime  : Integer;                {Date and time in DOS format}
    SenderID   : Str20;                  {Station ID of sender}
    Filler     : Byte;                   {Alignment byte, unused}
    PageCount  : Word;                   {Number of pages in this file}
    PageOfs    : Integer;                {Offset in file of first page}
    Padding    : Array[39..64] of Byte;  {Expansion room}
  end;

  {APRO fax page header record}
  TPageHeaderRec = packed record
    ImgLength : Integer;                 {Bytes of image data in this page}
    ImgFlags  : Word;                    {Image flags for width, res, etc}
    Padding   : Array[7..16] of Byte;    {Expansion room}
  end;

  {APRO fax server job header}
  TFaxJobHeaderRec = packed record
    ID       : Integer;          {APRO fax job signature}
    Status   : Byte;             {0=none sent, 1=some sent, 2=all sent, 3=paused}
    JobName  : Str20;            {Friendly name of fax job}
    Sender   : String[40];       {Name of sender (same as HeaderSender)}
    SchedDT  : TDateTime;        {TDateTime the first job should be sent}
    NumJobs  : Byte;             {Number of FaxJobInfoRecs for this job}
    NextJob  : Byte;             {The index of the next FaxJobInfo to send}
    CoverOfs : Integer;          {Offset in file of text CoverFile data}
    FaxHdrOfs: Integer;          {Offset in file of TFaxHeaderRec}
    Padding  : Array[86..128] of Byte; {Expansion room}
  end;

  {APRO fax server job recipient record }
  TFaxRecipientRec = packed record
    Status         : Byte;             {0=not sent, 1=sending, 2=sent, 3=paused}
    JobID          : Byte;             {Unique ID for this job}
    SchedDT        : TDateTime;        {TDateTime this job should be sent}
    AttemptNum     : Byte;             {Retry number for this recipient}
    LastResult     : Word;             {Last ErrorCode for this fax}
    PhoneNumber    : String[50];       {Phone number to dial for this job}
    HeaderLine     : String[100];      {Header line}
    HeaderRecipient: String[30];       {Recipient's name}
    HeaderTitle    : String[30];       {Title of fax}
    Padding        : Array[228..256] of Byte;{Expansion room}
  end;

  {Pcx header}
  TPcxPalArray  = Array[0..47] of Byte;
  TPcxHeaderRec = packed record
    Mfgr      : Byte;
    Ver       : Byte;
    Encoding  : Byte;
    BitsPixel : Byte;
    XMin      : Word;
    YMin      : Word;
    XMax      : Word;
    YMax      : Word;
    HRes      : Word;
    VRes      : Word;
    Palette   : TPcxPalArray;
    Reserved  : Byte;
    Planes    : Byte;
    BytesLine : Word;
    PalType   : Word;
    Filler    : Array[1..58] of Byte;  {pad to 128 bytes}
  end;

  TDcxOfsArray = array[1..1024] of Integer;

  PDcxHeaderRec = ^TDcxHeaderRec;
  TDcxHeaderRec = packed record
    ID      : Integer;
    Offsets : TDcxOfsArray;
  end;

  TTreeRec = record
    Next0 : Integer;
    Next1 : Integer;
  end;
  TTreeArray = array[0..MaxTreeRec] of TTreeRec;
  PTreeArray = ^TTreeArray;

  {$IFNDEF DrvInst}
  PAbsFaxCvt = ^TAbsFaxCvt;

  {callback function to open a converter input file}
  TOpenFileCallback = function(Cvt : PAbsFaxCvt; FileName : string) : Integer;

  {callback function to close a converter input file}
  TCloseFileCallback = procedure(Cvt : PAbsFaxCvt);

  {callback function converters use to get input raster}
  TGetLineCallback = function(Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                              var EndOfPage, MorePages : Bool) : Integer;

  {callback function converters use to output data}
  TPutLineCallback = function(Cvt : PAbsFaxCvt; var Data; Len : Integer;
                              EndOfPage, MorePages : Bool) : Integer;


  {callback function for status information}
  TCvtStatusCallback = function(Cvt : PAbsFaxCvt; StatFlags : Word;
                                BytesRead, BytesToRead : Integer) : Bool;

  {base converter data}
  TAbsFaxCvt = record
    UseHighRes  : Bool;               {TRUE if for high-res mode}
    DoubleWidth : Bool;               {TRUE do double each pixel}
    HalfHeight  : Bool;               {TRUE to discard each raster line}
    Flags       : Cardinal;           {Options flags}
    ByteOfs     : Cardinal;           {Byte offset in buffer}
    BitOfs      : Cardinal;           {Bit offset in buffer}
    ResWidth    : Cardinal;           {Width of current resolution in pels}
    LeftMargin  : Cardinal;           {Left margin in pels}
    TopMargin   : Cardinal;           {Top margin in pels}
    CurrPage    : Cardinal;           {Current page being processed}
    CurrLine    : Cardinal;           {Number of text/raster lines cvted}
    LastPage    : Cardinal;           {Last page number used in file cvt}
    CurPagePos  : Integer;            {file offset of current page}
    CenterOfs   : Cardinal;           {Offset of center of bitmap}
    UserData    : Pointer;            {Data needed by higher level cvters}
    OtherData   : Pointer;            {Other, miscellaneous data}
    BytesRead   : Integer;
    BytesToRead : Integer;
    DataLine    : PByteArray;         {Buffered line of compressed data}
    TmpBuffer   : PByteArray;         {Temp compression buffer}
    GetLine     : TGetLineCallback;   {Callback function to get a raster line}
    OpenCall    : TOpenFileCallback;  {To open the input file, if any}
    CloseCall   : TCloseFileCallback; {To close the input file, if any}
    StatusFunc  : TCvtStatusCallback; {Callback for status display}
    StatusWnd   : HWnd;               {Handle of window receiving status msgs}
    DefExt      : string; // array[0..3] of AnsiChar;
    InFileName  : string; // array[0..255] of AnsiChar;
    OutFileName : string; // array[0..255] of AnsiChar;
    StationID   : AnsiString; //array[0..20] of AnsiChar;
    MainHeader  : TFaxHeaderRec;      {main header of fax output file}
    PageHeader  : TPageHeaderRec;     {header for current output page}
    OutFile     : PBufferedOutputFile;{Output file}
    PadPage     : Bool;               {True to pad text conversion to full page}{!!.04}
    {$IFNDEF PrnDrv}
    InBitmap    : Graphics.TBitmap;
    {$ENDIF}
  end;

{$IFNDEF PrnDrv}

type
  { moved from AdWUtil }                                                 {!!.06}
  SunB = packed record                                                   {!!.06}
    s_b1, s_b2, s_b3, s_b4 : AnsiChar;                                   {!!.06}
  end;                                                                   {!!.06}
  { moved from AdWUtil }                                                 {!!.06}
  SunW = packed record                                                   {!!.06}
    s_w1, s_w2 : Word;                                                   {!!.06}
  end;                                                                   {!!.06}

  { moved from AdWnPort and AdWUtil }                                    {!!.06}
  PInAddr = ^TInAddr;                                                    {!!.06}
  TInAddr = packed record                                                {!!.06}
    case Integer of                                                      {!!.06}
      0 : (S_un_b : SunB);                                               {!!.06}
      1 : (S_un_w : SunW);                                               {!!.06}
      2 : (S_addr : Integer);                                            {!!.06}
  end;                                                                   {!!.06}

  { XML support }
const
  {The following constants are the tokens needed to parse an XML
   document. The tokens are stored in UCS-4 format to reduce the
   number of conversions needed by the filter.}
  Xpc_BracketAngleLeft : array[0..0] of Integer = (60); {<}
  Xpc_BracketAngleRight : array[0..0] of Integer = (62); {>}
  Xpc_BracketSquareLeft : array[0..0] of Integer = (91); {[}
  Xpc_BracketSquareRight : array[0..0] of Integer = (93); {]}
  Xpc_CDATAStart :
    array[0..5] of Integer = (67, 68, 65, 84, 65, 91); {CDATA[}
  Xpc_CharacterRef : array[0..0] of Integer = (35); {#}
  Xpc_CharacterRefHex : array[0..0] of Integer = (120); {x}
  Xpc_CommentEnd : array[0..2] of Integer = (45, 45, 62); {-->}
  Xpc_CommentStart : array[0..3] of Integer = (60, 33, 45, 45); {<!--}
  Xpc_ConditionalEnd : array[0..2] of Integer = (93, 93, 62); {]]>}
  Xpc_ConditionalIgnore :
    array[0..5] of Integer = (73, 71, 78, 79, 82, 69); {IGNORE}
  Xpc_ConditionalInclude :
    array[0..6] of Integer = (73, 78, 67, 76, 85, 68, 69); {INCLUDE}
  Xpc_ConditionalStart :
    array[0..2] of Integer = (60, 33, 91); {<![}
  Xpc_Dash : array[0..0] of Integer = (45); {-}
  Xpc_DTDAttFixed :
    array[0..4] of Integer = (70, 73, 88, 69, 68); {FIXED}
  Xpc_DTDAttImplied :
    array[0..6] of Integer = (73, 77, 80, 76, 73, 69, 68); {IMPLIED}
  Xpc_DTDAttlist :
    array[0..8] of Integer =
      (60, 33, 65, 84, 84, 76, 73, 83, 84); {<!ATTLIST}
  Xpc_DTDAttRequired :
    array[0..7] of Integer =
      (82, 69, 81, 85, 73, 82, 69, 68); {REQUIRED}
  Xpc_DTDDocType :
    array[0..8] of Integer =
      (60, 33, 68, 79, 67, 84, 89, 80, 69); {<!DOCTYPE}
  Xpc_DTDElement :
    array[0..8] of Integer =
      (60, 33, 69, 76, 69, 77, 69, 78, 84); {<!ELEMENT}
  Xpc_DTDElementAny : array[0..2] of Integer = (65, 78, 89); {ANY}
  Xpc_DTDElementCharData :
    array[0..6] of Integer = (35, 80, 67, 68, 65, 84, 65); {#PCDATA}
  Xpc_DTDElementEmpty :
    array[0..4] of Integer = (69, 77, 80, 84, 89); {EMPTY}
  Xpc_DTDEntity :
    array[0..7] of Integer =
      (60, 33, 69, 78, 84, 73, 84, 89); {<!ENTITY}
  Xpc_DTDNotation :
    array[0..9] of Integer =
      (60, 33, 78, 79, 84, 65, 84, 73, 79, 78); {<!NOTATION}
  Xpc_Encoding : array[0..7] of Integer =
    (101, 110, 99, 111, 100, 105, 110, 103); {encoding}
  Xpc_Equation : array[0..0] of Integer = (61); {=}
  Xpc_ExternalPublic :
    array[0..5] of Integer = (80, 85, 66, 76, 73, 67); {PUBLIC}
  Xpc_ExternalSystem :
    array[0..5] of Integer = (83, 89, 83, 84, 69, 77); {SYSTEM}
  Xpc_GenParsedEntityEnd : array[0..0] of Integer = (59); {;}
  Xpc_ListOperator : array[0..0] of Integer = (124); {|}
  Xpc_MixedEnd : array[0..1] of Integer = (41, 42); {)*}
  Xpc_OneOrMoreOpr : array[0..0] of Integer = (42); {*}
  Xpc_ParamEntity : array[0..0] of Integer = (37); {%}
  Xpc_ParenLeft : array[0..0] of Integer = (40); {(}
  Xpc_ParenRight : array[0..0] of Integer = (41); {)}
  Xpc_ProcessInstrEnd : array[0..1] of Integer = (63, 62); {?>}
  Xpc_ProcessInstrStart : array[0..1] of Integer = (60, 63); {<?}
  Xpc_QuoteDouble : array[0..0] of Integer = (34); {"}
  Xpc_QuoteSingle : array[0..0] of Integer = (39); {'}
  Xpc_Standalone :
    array[0..9] of Integer =
      (115, 116, 97, 110, 100, 97, 108, 111, 110, 101); {standalone}
  Xpc_UnparsedEntity :
    array[0..4] of Integer = (78, 68, 65, 84, 65); {NDATA}
  Xpc_Version :
    array[0..6] of Integer =
      (118, 101, 114, 115, 105, 111, 110); {version}

const
  LIT_CHAR_REF = 1;
  LIT_ENTITY_REF = 2;
  LIT_PE_REF = 4;
  LIT_NORMALIZE = 8;

  CONTEXT_NONE = 0;
  CONTEXT_DTD = 1;
  CONTEXT_ENTITYVALUE = 2;
  CONTEXT_ATTRIBUTEVALUE = 3;

  CONTENT_UNDECLARED = 0;
  CONTENT_ANY = 1;
  CONTENT_EMPTY = 2;
  CONTENT_MIXED = 3;
  CONTENT_ELEMENTS = 4;

  OCCURS_REQ_NOREPEAT = 0;
  OCCURS_OPT_NOREPEAT = 1;
  OCCURS_OPT_REPEAT = 2;
  OCCURS_REQ_REPEAT = 3;

  REL_OR = 0;
  REL_AND = 1;
  REL_NONE = 2;

  ATTRIBUTE_UNDECLARED = 0;
  ATTRIBUTE_CDATA = 1;
  ATTRIBUTE_ID = 2;
  ATTRIBUTE_IDREF = 3;
  ATTRIBUTE_IDREFS = 4;
  ATTRIBUTE_ENTITY = 5;
  ATTRIBUTE_ENTITIES = 6;
  ATTRIBUTE_NMTOKEN = 7;
  ATTRIBUTE_NMTOKENS = 8;
  ATTRIBUTE_ENUMERATED = 9;
  ATTRIBUTE_NOTATION = 10;

  ATTRIBUTE_DEFAULT_UNDECLARED = 0;
  ATTRIBUTE_DEFAULT_SPECIFIED = 1;
  ATTRIBUTE_DEFAULT_IMPLIED = 2;
  ATTRIBUTE_DEFAULT_REQUIRED = 3;
  ATTRIBUTE_DEFAULT_FIXED = 4;

  ENTITY_UNDECLARED = 0;
  ENTITY_INTERNAL = 1;
  ENTITY_NDATA = 2;
  ENTITY_TEXT = 3;

  CONDITIONAL_INCLUDE = 0;
  CONDITIONAL_IGNORE = 1;

const
  LineBufferSize = 4096;
type
  TLineReader = class
    protected
      Buffer : array[0..LineBufferSize] of Ansichar;
      fEOLF : Boolean;
      ReadPtr : PAnsiChar;
      fStream : TStream;
      fBytesRead : Integer;
      fFileSize : Integer;
      procedure ReadPage;
    public
      property BytesRead : Integer read fBytesRead;
      constructor Create(Stream : TStream);
      destructor Destroy; override;
      property EOLF : Boolean read fEOLF;
      property FileSize : Integer read fFileSize;
      function NextLine : AnsiString;
  end;

  {String handling class, only used by the TApdPager}
type
  TAdStr = class
  private
    FMaxLen: Integer;
    FLen: Integer;
    FString: PChar;
    FCur: PChar;

  protected
    procedure SetLen(NewLen: Integer);
    function GetLen: Integer;

    procedure SetMaxLen(NewMaxLen: Integer);
    function GetMaxLen: Integer;

    function GetBuffLen: Integer;

    procedure SetChar(Index: Cardinal; Value: Char);
    function GetChar(Index: Cardinal): Char;

    function GetCurChar: Char;

  public
    constructor Create(AMaxLen: Cardinal);
    destructor Destroy; override;
    procedure Assign(Source: TAdStr);

    property Len: Integer
      read GetLen write SetLen;
    property MaxLen: Integer
      read GetMaxLen write SetMaxLen;
    property BuffLen: Integer
      read GetBuffLen;
    property Chars[Index: Cardinal]: Char
      read GetChar write SetChar; default;
    property CurChar: Char
      read GetCurChar;
    property Str: PChar
      read FString;
    property Cur: PChar
      read FCur;

    procedure First;
    procedure GotoPos(Index: Cardinal);
    procedure Last;
    procedure MoveBy(IndexBy: Integer);
    procedure Next;
    procedure Prev;

    procedure Append(const Text: string); overload;
    procedure Append(const Text: AnsiString); overload;
    procedure AppendTAdStr(TS: TAdStr);
    procedure AppendBuff(Buff: PChar);
    procedure Clear;
    function Copy(Index, SegLen: Integer): string; overload;
    function CopyAnsi(Index, SegLen: Integer): AnsiString; overload;
    procedure Delete(Index, SegLen: Integer);
    procedure Insert(const Text: string; Index: Integer); overload;
    procedure Insert(const Text: AnsiString; Index: Integer); overload;
    function Pos(const SubStr: string): Cardinal;
    function PosIdx(const SubStr: string; Index: Integer): Cardinal;
    procedure Prepend(const Text: string); overload;
    procedure Prepend(const Text: AnsiString); overload;
    procedure Resize(NewLen: Integer);
  end;

  TAdStrCur = class
  private
  public
  end;

  {text converter data}
  PTextFaxData = ^TTextFaxData;
  TTextFaxData = record
    IsExtended : Boolean;                      {Using extended text option?}
    ReadBuffer : PByteArray;                   {Input buffer}
    TabStop    : Cardinal;                     {Number of spaces per tab character}
    LineCount  : Cardinal;                     {Number of text lines between page}
    InFile     : TLineReader;                  {Input file}
    OnLine     : DWORD;                        {Number of current input line}
    CurRow     : Cardinal;                     {Current raster row of CurStr}
    CurStr     : array[0..255] of Ansichar;
    Pending    : string;
    FFPending  : Boolean;                      {TRUE if formfeed pending}
    FontRec    : TFontRecord;                  {Holds current font info}
    case Integer of
      0: (FontLoaded : Bool;                   {False until font loaded}
          FontPtr    : PByteArray);            {Pointer to the loaded font table}
      1: (Bitmap     : Graphics.TBitmap;       {Memory bitmap for rendering text}
          LineBytes  : Cardinal;               {Bytes per raster line}
          Offset     : Cardinal;               {Current offset in the bitmap}
          ImageSize  : Integer;                {Size of image structure}
          ImageData  : Pointer);               {Image data}
  end;


  {TIFF strip information}
  PStripRecord = ^TStripRecord;
  TStripRecord = packed record
    Offset : Integer;
    Length : Integer;
  end;

  PStripInfo = ^TStripInfo;
  TStripInfo = array[1..(65521 div SizeOf(TStripRecord))] of TStripRecord;

  {TIFF converter data}
  PTiffFaxData = ^TTiffFaxData;
  TTiffFaxData = record
    Intel       : Bool;                {TRUE if file is in Intel byte order}
    LastBitMask : Word;                {Last decode bit mask}
    CurrRBSize  : Cardinal;            {Amount of data in read buffer}
    CurrRBOfs   : Cardinal;            {Current offset in ReadBuffer}
    OnStrip     : Cardinal;            {Current strip being processed}
    OnRaster    : Cardinal;            {Current raster line being processed}
    Version     : Word;                {Version number from file preable}
    SubFile     : Word;                {TIFF tag field values for image:}
    ImgWidth    : Word;                {image width}
    ImgLen      : Word;                {length of image}
    ImgBytes    : Word;                {bytes per raster line}
    NumLines    : Word;                {image length (height)}
    CompMethod  : Word;                {compression type}
    PhotoMet    : Word;                {photometric conversion type}
    RowStrip    : DWORD;               {raster lines per image strip}
    StripOfs    : Integer;             {offset in file to first strip}
    StripCnt    : DWORD;               {number of strips}
    StripInfo   : PStripInfo;          {strip offsets/lengths}
    ByteCntOfs  : Integer;             {offset to byte count list}
    ImgStart    : Integer;             {start of image data in file}
    ReadBuffer  : PByteArray;          {buffer for reads}
    InFile      : File;                {input file}
  end;

  PDcxFaxData = ^TDcxFaxData;
  TDcxFaxData = record
    DcxHeader : TDcxHeaderRec;         {Offsets to DCX pages}
    DcxPgSz   : TDcxOfsArray;          {Number of bytes per PCX image}
    DcxNumPag : Cardinal;              {Number of pages (PCX images) in file}
    OnPage    : Cardinal;              {Current page being converted}
  end;

  PPcxFaxData = ^TPcxFaxData;
  TPcxFaxData = record
    CurrRBSize   : Cardinal;           {Read buffer size}
    CurrRBOfs    : Cardinal;           {Offset into read buffer}
    ActBytesLine : Cardinal;           {Actual number of bytes per line}
    ReadBuffer   : PByteArray;         {Read buffer}
    PcxHeader    : TPcxHeaderRec;      {Header from PCX image}
    PcxBytes     : DWORD;              {Number of bytes in PCX image}
    InFile       : File;               {Input file}
    PcxWidth     : Word;               {Width of raster line in pixels}
    DcxData      : PDcxFaxData;        {Optional DCX conversion data}
  end;

const
  DMSize = 32;

type
  PBitmapFaxData = ^TBitmapFaxData;
  TBitmapFaxData = record
    BmpHandle       : HBitmap;
    DataBitmap      : Graphics.TBitmap;
    BytesPerLine    : Cardinal;
    Width           : Cardinal;
    NumLines        : Cardinal;
    OnLine          : Cardinal;
    Offset          : Integer;
    BitmapBufHandle : THandle;
    BitmapBuf       : Pointer;
    NeedsDithering  : Boolean;
    DM              : array[0..Pred(DMSize),0..Pred(DMSize)] of Integer;
  end;
{$ENDIF}
{$ENDIF} {DrvInst}

{Fax unpacking}

{options passed to unpacker callback}
const
  upStarting = $0001;
  upEnding   = $0002;

{flags passed to unpacker status}
const
  usStarting = $0001;
  usEnding   = $0002;

const
  {unpacker options}
  ufYield            = $0001;
  ufAutoDoubleHeight = $0002;
  ufAutoHalfWidth    = $0004;
  ufAbort            = $0008;

  DefUnpackOptions = ufYield or ufAutoDoubleHeight;
  BadUnpackOptions = Cardinal(0);

  {const number of raster lines per allocated page}
  RasterBufferPageSize = Cardinal(1024);

type
  {settings for horizontal and vertical scaling}
  PScaleSettings = ^TScaleSettings;
  TScaleSettings = record
    HMult : Cardinal;
    HDiv  : Cardinal;
    VMult : Cardinal;
    VDiv  : Cardinal;
  end;

  PUnpackFax = ^TUnpackFax;

  {callback for outputting unpacked data}
  TUnpackLineCallback = function(Unpack : PUnpackFax; plFlags : Word;
    var Data; Len, PageNum : Cardinal) : Integer;

  {callback for outputting status information}
  TUnpackStatusCallback = procedure(Unpack : PUnpackFax; FaxFile : string;
    PageNum : Cardinal; BytesUnpacked, BytesToUnpack : Integer);

  {memory bitmap descriptor}
  PMemoryBitmapDesc = ^TMemoryBitmapDesc;
  TMemoryBitmapDesc = record
    Width  : Cardinal;
    Height : Cardinal;
    Bitmap : HBitmap;
  end;

  TUnpackFax = record
    {basic unpacker data}
    CurCode    : Cardinal;
    CurSig     : Cardinal;
    LineOfs    : Cardinal;            {Current offset in line}
    LineBit    : Cardinal;            {Current offset in byte}
    CurrPage   : Cardinal;            {Current page}
    CurrLine   : Cardinal;            {Current line}
    Flags      : Cardinal;            {Option flags}
    BadCodes   : Cardinal;            {Number of bad codes unpacked}
    WSFrom     : Cardinal;            {Whitespace comp - size of run to comp}
    WSTo       : Cardinal;            {Number of lines to compress to}
    WhiteCount : Cardinal;            {Count of white lines unpacked}
    TreeLast   : Integer;
    TreeNext   : Integer;
    Match      : Integer;
    ImgBytes   : Integer;
    ImgRead    : Integer;
    WhiteTree  : PTreeArray;          {Tree of white runlength codes}
    BlackTree  : PTreeArray;          {Tree of black runlength codes}
    LineBuffer : PByteArray;          {Buffer for decompression}
    TmpBuffer  : PByteArray;
    FileBuffer : PByteArray;          {File I/O buffer}
    FaxHeader  : TFaxHeaderRec;
    PageHeader : TPageHeaderRec;
    OutputLine : TUnpackLineCallback; {Output a decompressed raster line}
    Status     : TUnpackStatusCallback;
    UserData   : Pointer;             {Data needed by higher level unpackers}

    {scaling data}
    Height     : Cardinal;            {height of bitmap}
    Width      : Cardinal;            {width of bitmap}
    Handle     : THandle;             {handle to memory block}
    Pages      : Cardinal;            {pages allocate in handle}
    MaxWid     : Cardinal;            {maximum width of line}
    Lines      : Pointer;             {raster lines}
    Scale      : TScaleSettings;      {scale settings}
    MemBmp     : TMemoryBitmapDesc;   {memory bitmap}
    SaveHook   : TUnpackLineCallback; {saved output line hook}
    ToBuffer   : Bool;                {unpack to memory buffer?}
    Inverted   : Bool;                {TRUE if bitmap data should be inverted}
  end;

  {data for unpacking to PCX file}
  PUnpackToPcxData = ^TUnpackToPcxData;
  TUnpackToPcxData = record
    PBOfs       : Cardinal;
    Lines       : Cardinal;
    LastPage    : Cardinal;
    PCXOfs      : Integer;
    FileOpen    : Bool;
    DcxUnpack   : Bool;
    OutFile     : File;
    OutName     : array[0..255] of AnsiChar;
    PackBuffer  : array[0..511] of Byte;
    DcxHead     : TDcxHeaderRec;
  end;

{image converters}
const
  DCXHeaderID = 987654321;

{Fax viewer}

const
  {fax viewer window Cardinal}
  gwl_Viewer = 0;

const
  {special styles}
  vws_DragDrop  = $0001;

  {default colors}
  DefViewerBG = $FFFFFF;
  DefViewerFG = $000000;

  {default scrolling parameters}
  DefVScrollInc = 8;
  DefHScrollInc = 8;

{Abstract fax send/receive}
const
  {Constants used to initialize object fields}
  DefConnectAttempts : Cardinal = 1;   {Default one connect attempt}
  DefMaxRetries : Integer       = 2;   {Max times to retry sending a page}
  DefStatusTimeout : Integer    = 1;   {Seconds between status updates}

  {Constants used directly}
  DefNormalInit        : string = 'ATE0Q0V1X4S0=0S2=43';                 {!!.04}
  DefBlindInit         : string = 'ATE0Q0V1X3S0=0S2=43';                 {!!.04}
  DefNoDetectBusyInit  : string = 'ATE0Q0V1X2S0=0S2=43';                 {!!.04}
  DefX1Init            : string = 'ATE0Q0V1X1S0=0S2=43';                 {!!.04}
  DefTapiInit          : string = 'ATE0Q0V1S0=0S2=43';                   {!!.04}
  {DefInit                      = DefNormalInit;}                        {!!.04}
  DefStatusBytes : Cardinal        = 10000;   {Force periodic exit}
  MaxBadPercent : Cardinal         = 10;      {Error if this % bad training}
  FlushWait : Cardinal             = 500;     {Msec before/after DTR drop}
  FrameWait : Cardinal             = 20;      {Msec delay before HDLC frame}

  {Fax send/receive options}
  afAbortNoConnect      = $0001;   {Abort if no connect}
  afExitOnError         = $0002;   {Exit FaxTransmit/Receive on error}
  afCASSubmitUseControl = $0004;   {SubmitSingleFile uses control file}
  afSoftwareFlow        = $0008;   {Use software flow control in C1/2}

  DefFaxOptions : Cardinal = 0;
  BadFaxOptions = Cardinal(0);

  {Fax types (for specifying different send/receive state machines}
  ftNone              = 0;   {None specified}
  ftClass12           = 1;   {Class 1/2/2.0}

type
  ClassType = (ctUnknown, ctDetect, ctClass1, ctClass2, ctClass2_0);

  {Logging codes}
  TFaxLogCode = (
    lfaxNone,
    lfaxTransmitStart,
    lfaxTransmitOk,
    lfaxTransmitFail,
    lfaxReceiveStart,
    lfaxReceiveOk,
    lfaxReceiveSkip,
    lfaxReceiveFail);
  { APRO components now use the TFaxLogCode exclusively, TLogFaxCode defined }
  { here for backwards compatibility }
  TLogFaxCode = TFaxLogCode;                                             {!!.04}
  {Logging codes for TApdFaxServer}
  TFaxServerLogCode = (
    fslNone,
    fslPollingEnabled,
    fslPollingDisabled,
    fslMonitoringEnabled,
    fslMonitoringDisabled);

  {General fax states}
  FaxStateType = (
    faxReady,           {State machine ready immediately}
    faxWaiting,         {State machine waiting}
    faxCritical,        {State machine in critical state}
    faxFinished);       {State machine is finished}

type
  {A list of files/numbers to fax}
  TFaxNumber = String[40];
  PFaxEntry = ^TFaxEntry;
  TFaxEntry = record
    fNumber : TFaxNumber;
    fFName  : ShortString;
    fCover  : ShortString;
    fNext   : PFaxEntry;
  end;

  {A general (Pascal and C++) structure for returning the next fax to send}
  PSendFax = ^TSendFax;
  TSendFax = record
    sfNumber : array[0..40] of AnsiChar;
    sfFName  : array[0..255] of AnsiChar;
    sfCover  : array[0..255] of AnsiChar;
  end;

const
  {Trigger constants}
  MaxTrigData = 21;                 {Max length of data trigger (should be odd)}
  MaxDataPointers = 3;              {Max number of data pointers}
  TimerFreq = 50;                   {Dispatcher timer interval in millisecs}

  {Data pointer constants}
  dpProtocol = 1;
  dpFax      = 2;
  dpModem    = 3;

  {Tracing constants}
  MaxTraceCol = 78;                 {Wrap trace reports at this column}
  HighestTrace = 4000000;           {Largest acceptable trace buffer size}

  {Logging constants}
  MaxDLogQueueSize = 16000000;      {Largest acceptable log queue}

type
  {Types of dispatch entries}
  TDispatchType = (
     dtNone, dtDispatch, dtTrigger, dtError, dtThread,
     dtTriggerAlloc, dtTriggerDispose, dtTriggerHandlerAlloc,
     dtTriggerHandlerDispose, dtTriggerDataChange, dtTelnet, dtFax,
     dtXModem, dtYModem, dtZModem, dtKermit, dtAscii, dtBPlus,
     dtPacket, dtUser, dtScript);
  TDispatchSubType =
    (dstNone,
     dstReadCom, dstWriteCom, dstLineStatus, dstModemStatus,
     dstAvail, dstTimer, dstData, dstStatus,
     dstThreadStart, dstThreadExit, dstThreadSleep, dstThreadWake,
     dstDataTrigger, dstTimerTrigger, dstStatusTrigger, dstAvailTrigger,
     dstWndHandler, dstProcHandler, dstEventHandler,
     dstSWill, dstSWont, dstSDo, dstSDont, dstRWill, dstRWont,
     dstRDo, dstRDont, dstCommand, dstSTerm,
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
     dsttfClose, dsttfCompleteOK, dsttfAbort, dsttfDone, dstrfNone,
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
     dstrfComplete, dstrfAbort, dstrfDone,
     dsttxInitial, dsttxHandshake, dsttxGetBlock, dsttxWaitFreeSpace,
     dsttxSendBlock, dsttxDraining, dsttxReplyPending,
     dsttxEndDrain, dsttxFirstEndOfTransmit, dsttxRestEndOfTransmit,
     dsttxEotReply, dsttxFinished, dsttxDone,
     dstrxInitial, dstrxWaitForHSReply, dstrxWaitForBlockStart,
     dstrxCollectBlock, dstrxProcessBlock,  dstrxFinishedSkip,
     dstrxFinished, dstrxDone,
     dsttyInitial, dsttyHandshake, dsttyGetFileName, dsttySendFileName,
     dsttyDraining, dsttyReplyPending, dsttyPrepXmodem,
     dsttySendXmodem, dsttyFinished, dsttyFinishDrain, dsttyDone,
     dstryInitial, dstryDelay, dstryWaitForHSReply,
     dstryWaitForBlockStart, dstryCollectBlock, dstryProcessBlock,
     dstryOpenFile, dstryPrepXmodem, dstryReceiveXmodem, dstryFinished,
     dstryDone, dsttzInitial, dsttzHandshake, dsttzGetFile,
     dsttzSendFile, dsttzCheckFile, dsttzStartData, dsttzEscapeData,
     dsttzSendData, dsttzWaitAck, dsttzSendEof, dsttzDrainEof,
     dsttzCheckEof, dsttzSendFinish, dsttzCheckFinish, dsttzError,
     dsttzCleanup, dsttzDone, dstrzRqstFile, dstrzDelay, dstrzWaitFile,
     dstrzCollectFile, dstrzSendInit, dstrzSendBlockPrep,
     dstrzSendBlock, dstrzSync, dstrzStartFile, dstrzStartData,
     dstrzCollectData, dstrzGotData, dstrzWaitEof, dstrzEndOfFile,
     dstrzSendFinish, dstrzCollectFinish, dstrzError, dstrzWaitCancel,
     dstrzCleanup, dstrzDone,
     dsttkInit, dsttkInitReply, dsttkCollectInit, dsttkOpenFile,
     dsttkSendFile, dsttkFileReply, dsttkCollectFile, dsttkCheckTable,
     dsttkSendData, dsttkBlockReply, dsttkCollectBlock, dsttkSendEof,
     dsttkEofReply, dsttkCollectEof, dsttkSendBreak, dsttkBreakReply,
     dsttkCollectBreak, dsttkComplete, dsttkWaitCancel, dsttkError,
     dsttkDone, dstrkInit, dstrkGetInit, dstrkCollectInit,
     dstrkGetFile, dstrkCollectFile, dstrkGetData, dstrkCollectData,
     dstrkComplete, dstrkWaitCancel, dstrkError, dstrkDone,
     dsttaInitial, dsttaGetBlock, dsttaWaitFreeSpace, dsttaSendBlock,
     dsttaSendDelay, dsttaFinishDrain, dsttaFinished, dsttaDone,
     dstraInitial, dstraCollectBlock, dstraProcessBlock,
     dstraFinished, dstraDone, dstEnable, dstDisable, dstStringPacket,
     dstSizePacket, dstPacketTimeout, dstStartStr, dstEndStr,
     dstIdle, dstWaiting, dstCollecting, dstThreadStatusQueued,             // SWB
     dstThreadDataQueued, dstThreadDataWritten, dsttzSinit,                 // SWB
     dsttzCheckSInit                                                        // SWB
     );

  {For holding trace entries}
  TTraceRecord = record
    EventType : AnsiChar;
    C : AnsiChar;
  end;
  PTraceQueue = ^TTraceQueue;
  TTraceQueue = array[0..HighestTrace] of TTraceRecord;

  {DispatchBuffer type}
  PDBuffer = ^TDBuffer;
  TDBuffer = array[0..65527] of AnsiChar;

  {Output buffer type}
  POBuffer = ^TOBuffer;
  TOBuffer = array[0..pred(High(Integer))] of AnsiChar;

  {$IFNDEF PrnDrv}

  {For storing com name}
  TComName = array[0..5] of Char;

  {Trigger types}
  TTriggerType = (ttNone, ttAvail, ttTimer, ttData, ttStatus);

  {Timer trigger record}
  PTimerTrigger = ^TTimerTrigger;
  TTimerTrigger = record
    tHandle : Cardinal;
    tET     : EventTimer;
    tTicks  : Integer;
    tValid  : Bool;
    tActive : Bool;
  end;

  {Data trigger match array}
  TCheckIndex = array[0..MaxTrigData] of Cardinal;

  {Data trigger record}
  PDataTrigger = ^TDataTrigger;
  TDataTrigger = record
    tHandle     : Cardinal;
    tLen        : Cardinal;
    tChkIndex   : TCheckIndex;
    tMatched    : Bool;
    tIgnoreCase : Bool;
    tData       : array[0..MaxTrigData] of AnsiChar;
  end;

  {Status trigger record}
  PStatusTrigger = ^TStatusTrigger;
  TStatusTrigger = record
    tHandle    : Cardinal;
    tSType     : Cardinal;
    tValue     : Word;
    tSActive   : Boolean;
    StatusHit  : Boolean;
  end;

  {Trigger save record}
  TTriggerSave = record
    tsLenTrigger     : Cardinal;
    tsTimerTriggers  : Tlist;
    tsDataTriggers   : TList;
    tsStatusTriggers : TList;
  end;

  {Trigger handler records}
  PWndTriggerHandler = ^TWndTriggerHandler;
  TWndTriggerHandler = record
    thWnd     : TApdHwnd;           {Window that gets messages}
    thDeleted : Boolean;
  end;
  PProcTriggerHandler = ^TProcTriggerHandler;
  TProcTriggerHandler = record
    thNotify  : TApdNotifyProc;     {Address of notification proc}
    thDeleted : Boolean;
  end;
  PEventTriggerHandler = ^TEventTriggerHandler;
  TEventTriggerHandler = record
    thNotify  : TApdNotifyEvent;    {Address of notification event}
    thDeleted : Boolean;
    thSync : Boolean;
  end;
  {Data pointers for various purposes}
  TDataPointerArray = array[1..MaxDataPointers] of Pointer;
    {indexes in use internally (each component must use unique index) :
      1 : protocol component
      2 : fax component
      3 : legacy modem component
    }
  {$ENDIF}

procedure SetFlag(var Flags : Cardinal; FlagMask : Cardinal);

procedure ClearFlag(var Flags : Cardinal; FlagMask : Cardinal);

function FlagIsSet(Flags : Cardinal; FlagMask : Cardinal) : Bool;

procedure SetByteFlag(var Flags : Byte; FlagMask : Byte);

procedure ClearByteFlag(var Flags : Byte; FlagMask : Byte);

function ByteFlagIsSet(Flags : Byte; FlagMask : Byte) : Bool;

function MinWord(A, B : Cardinal) : Cardinal;

function AddWordToPtr(P : Pointer; W : Cardinal) : Pointer;

function AdTimeGetTime : DWord;

function Ticks2Secs(Ticks : Integer) : Integer;
function Secs2Ticks(Secs : Integer) : Integer;
function MSecs2Ticks(MSecs : Integer) : Integer;
procedure NewTimer(var ET : EventTimer; Ticks : Integer);
procedure NewTimerSecs(var ET : EventTimer; Secs : Integer);
function TimerExpired(ET : EventTimer) : Bool;
function ElapsedTime(ET : EventTimer) : Integer;
function ElapsedTimeInSecs(ET : EventTimer) : Integer;
function RemainingTime(ET : EventTimer) : Integer;
function RemainingTimeInSecs(ET : EventTimer) : Integer;
function DelayTicks(Ticks: Integer; Yield : Bool) : Integer;
{$IFNDEF PrnDrv}
function Long2StrZ(Dest : PChar; L : Integer) : PChar;
function Str2LongZ(S : PChar; var I : Integer) : Bool;
{$ENDIF}
function JustPathnameZ(out Dest : string; PathName : string) : string; overload;
function JustPathnameZ(Dest : PAnsiChar; PathName : PAnsiChar) : PAnsiChar; overload;
function JustFilenameZ(Dest : PAnsiChar; PathName : PAnsiChar) : PAnsiChar;
{$IFNDEF PrnDrv}
function JustExtensionZ(out Dest : string; Name : string) : string; overload;
{$ENDIF}
function StrStCopy(Dest : PWideChar; S : PWideChar; Pos, Count : Cardinal) : PWideChar; overload;
function StrStCopy(Dest : PAnsiChar; S : PAnsiChar; Pos, Count : Cardinal) : PAnsiChar; overload;
function AddBackSlashZ(Dest : PAnsiChar; DirName : PAnsiChar) : PAnsiChar; overload;
function AddBackSlashZ(out Dest : string; DirName : string) : string; overload;
{$IFNDEF PrnDrv}
function ExistFileZ(FName : string) : Bool; overload;
{$ENDIF}
function ForceExtensionZ(out Dest : string; Name, Ext : string) : string; overload;
function DefaultExtensionZ(out Dest : string; Name, Ext : string) : string; overload;
function GetPtr(P : Pointer; O : Integer) : Pointer;
procedure NotBuffer(var Buf; Len : Cardinal);

{$IFNDEF Win32}
{$IFNDEF Win64}
function Trim(const S : string) : string;
{$ENDIF}
{$ENDIF}

function DelayMS(MS : Cardinal) : Cardinal;

function SafeYield : Integer;

{$IFNDEF PrnDrv}
function JustName(PathName : String) : String;
  {-Return just the name (no extension, no path) of a pathname}

function AddBackSlash(const DirName : String) : String; overload;
  {-Add a default backslash to a directory name}

function AddBackSlash(const DirName : AnsiString) : AnsiString; overload;
  {-Add a default backslash to a directory name}

function IsWin2000 : Boolean;
  {- Returns True if running on Windows 2000 }

function IsWinNT : Boolean;
  {- Returns True is we are running on an NT platform (NT4 or 2K }

  { Base class definitions, this is how we get this unit automatically }
  { added to the uses clause when a component is dropped on the form.  }
type
  TApdBaseComponent = class(TComponent)
  protected
    function GetVersion : string;
    procedure SetVersion(const Value : string);
  published
    property Version : string
      read GetVersion
      write SetVersion
      stored False;
  end;

  TApdBaseWinControl = class(TWinControl)
  protected
    function GetVersion : string;
    procedure SetVersion(const Value : string);
  published
    property Version : string
      read GetVersion
      write SetVersion
      stored False;
  end;

  TApdBaseOleControl = class(TOleControl)
  protected
    function GetVersion : string;
    procedure SetVersion (const Value : string);
  published
    property Version : string
      read GetVersion
      write SetVersion
      stored False;
  end;

  TApdBaseGraphicControl = class(TGraphicControl)
  protected
    function GetVersion : string;
    procedure SetVersion (const Value : string);
  published
    property Version : string
      read GetVersion
      write SetVersion
      stored False;
  end;

  TApdBaseScrollingWinControl = class(TScrollingWinControl)
  protected
    function GetVersion : string;
    procedure SetVersion (const Value : string);
  published
    property Version : string
      read GetVersion
      write SetVersion
      stored False;
  end;

{$ENDIF}


function ApWinExecAndWait32(FileName : PChar; CommandLine : PChar;
                            Visibility : Integer) : Integer;

{$IFDEF Apax}
procedure WriteDebug(const S : string);
{$ENDIF}

{ These methods were overloaded to work around a Delphi 6 bug. }
procedure AssignFile(var F: File; const FileName: string); overload;
procedure AssignFile(var F: TextFile; const FileName : string); overload;
procedure Assign(var F: File; const FileName: string); overload;
procedure Assign(var F: TextFile; const FileName: string); overload;

implementation

uses
  AnsiStrings;

function StrLenW(const Str: PWideChar): Cardinal;
asm  
  cmp word ptr [eax], 0
  je @ZeroLen
  mov edx, eax
  neg edx
@MyLoop:
  mov cx, [eax]
  add eax, 2
  test cx, cx
  jnz @MyLoop
  lea eax, [eax + edx - 2]
  shr eax, 1
  ret
@ZeroLen:
  xor eax, eax
end;

{$IFDEF APAX}
procedure WriteDebug(const S : Ansistring);
var
  LogStream : TFileStream;
  TimeStamp : Ansistring;
begin
  LogStream := nil;
  try
    if FileExists('APAXDBG.TXT') then
      LogStream := TFileStream.Create('APAXDBG.TXT', fmOpenReadWrite or fmShareDenyNone)
    else
      LogStream := TFileStream.Create('APAXDBG.TXT', fmCreate or fmShareDenyNone);
    LogStream.Seek(0, soFromEnd);
    TimeStamp := FormatDateTime('dd/mm/yy : hh:mm:ss - ', Now) + S + #13#10;
    LogStream.WriteBuffer(TimeStamp[1], Length(TimeStamp));
    OutputDebugStringA(PAnsiChar(S)); // WriteLn(S);

  finally
    LogStream.Free;
  end;
end;
{$ENDIF}

procedure AssignFile(var F: File; const FileName: string);
begin
  System.AssignFile(F, FileName);
end;

procedure AssignFile(var F: TextFile; const FileName : string);
begin
  System.AssignFile(F, FileName);
end;

procedure Assign(var F: File; const FileName: string);
begin
  System.Assign(F, FileName);
end;

procedure Assign(var F: TextFile; const FileName: string);
begin
  System.Assign(F, FileName);
end;


const
  MaxTicks    = 39045157;   {Max ticks, 24.8 days}

  {Clock frequency of 1193180/65536 is reduced to 1675/92. This}
  {allows Integer conversions of Ticks values upto TicksPerDay}
  TicksFreq = 1675;
  SecsFreq  = 92;
  MSecsFreq = 92000;

{$IFNDEF PrnDrv}
{$IFNDEF DrvInst}
constructor TLineReader.Create(Stream : TStream);
begin
  fStream := Stream;
  fFileSize := fStream.Size;
  fBytesRead := 0;
  ReadPage;
end;

destructor TLineReader.Destroy;
begin
  fStream.Free;
  inherited Destroy;
end;

function TLineReader.NextLine : AnsiString;
var
  EOL : PAnsiChar;
  Done : Boolean;
begin
  Result := '';
  repeat
    Done := True;
    EOL := AnsiStrings.StrScan(ReadPtr,#13);
    if EOL <> nil then begin
      EOL^ := #0;
      Result := Result + AnsiStrings.StrPas(ReadPtr);
      ReadPtr := EOL;
      inc(ReadPtr);
      if ReadPtr^ = #10 then inc(ReadPtr);
    end else begin
      Result := Result + AnsiStrings.StrPas(ReadPtr);
      ReadPage;
      Done := EOLF;
    end;
  until Done;
end;

procedure TLineReader.ReadPage;
var
  BytesRead : Integer;
begin
  BytesRead := fStream.Read(Buffer,LineBufferSize);
  inc(fBytesRead,BytesRead);
  fEOLF := BytesRead = 0;
  if (fEOLF) then                                                           // SWB
    Buffer[0] := #0                                                         // SWB
  else                                                                      // SWB
  begin                                                                     // SWB
    { if we're at the end of the file, make sure it has the line term char }
    if (BytesRead<LineBufferSize) and                                      {!!.04}
      not(Buffer[BytesRead-1] in [#13,#$1A]) then                          {!!.04}
      Buffer[BytesRead] := #13;                                            {!!.04}
    ReadPtr := @Buffer[0];
    if ReadPtr^ = #10 then inc(ReadPtr);
//  if {not} fEOLF then                                                    {!!.04} // SWB
    if Buffer[BytesRead-1] = #$1A then
      Buffer[BytesRead-1] := #0
    else
      Buffer[BytesRead] := #0;
  end;
end;                                                                        // SWB

{ TAdStr }

constructor TAdStr.Create(AMaxLen: Cardinal);
begin
  inherited Create;
  FMaxLen := 0;
  FLen := 0;
  FString := nil;
  SetMaxLen(AMaxLen);
end;

destructor TAdStr.Destroy;
begin
  if Assigned(FString) then
    FreeMem(FString, FMaxLen + 1);
  inherited Destroy;
end;

procedure TAdStr.Append(const Text: string);
var
  NewLen: Integer;
  Buff: PChar;
begin
  if Text = '' then Exit;         { nothing to append }

  NewLen := Length(Text) + FLen;
  if NewLen > FMaxLen then         { if new text will be longer than allocated }
    Resize(NewLen);              { reallocate }

  Buff := StrAlloc(Length(Text) + 1);
  StrPCopy(Buff,Text);
  StrCat(FString, Buff);
  StrDispose(Buff);
  FLen := StrLen(FString);
end;

procedure TAdStr.Append(const Text: AnsiString);
begin
  Append(string(Text));
end;

procedure TAdStr.AppendBuff(Buff: PChar);
var
  BuffLen: Integer;
begin
  BuffLen := StrLen(Buff);
  if BuffLen = 0 then Exit;

  if BuffLen + FLen > FMaxLen then
    Resize(BuffLen + FLen);

  StrCat(FString, Buff);
  FLen := StrLen(FString);
end;

procedure TAdStr.AppendTAdStr(TS: TAdStr);
begin
  AppendBuff(TS.Str);
end;

procedure TAdStr.Assign(Source: TAdStr);
begin
  if not Assigned(Source) then Exit;

  if Source.MaxLen <> MaxLen then
    Resize(Source.MaxLen);

  FMaxLen := Source.MaxLen;

  StrCopy(FString, Source.Str);
  FLen    := StrLen(FString);

  GotoPos(Source.Cur - Source.Str);
end;

procedure TAdStr.Clear;
begin
  FString[0] := #0;
  FLen := 0;
  FCur := FString;
end;

function TAdStr.Copy(Index, SegLen: Integer): string;
var
  P:PChar;
  NewLen: Integer;
begin
  if (Index = 0) or (SegLen = 0) or (Index > FLen) then begin
    Result := '';
    Exit;
  end;

  NewLen := SegLen;
  if Index + (SegLen - 1) > FLen then  { requested segment runs past end of string }
    NewLen := FLen - Index;  { just return up to end of string }

  GotoPos(Index);

  P := StrAlloc(NewLen + 1);
  StrLCopy(P, FCur, NewLen);
  Result := StrPas(P);
  StrDispose(P);
end;

function TAdStr.CopyAnsi(Index, SegLen: Integer): AnsiString;
begin
  Result := AnsiString(Copy(Index, SegLen));
end;

procedure TAdStr.Delete(Index, SegLen: Integer);
var
  Src: PChar;
  SrcLen: Cardinal;
begin
  if (Index = 0) or (SegLen = 0) or (Index > FLen) then Exit;

  GotoPos(Index);             { locate starting point }
  if Index + (SegLen - 1) > FLen then  { delete rest of string }
    FCur[0] := #0
  else begin                  { remove chunk }
    Src := FCur + SegLen;     { find start of remain post chunk string }
    SrcLen := StrLen(Src);
    StrLCopy(FCur, Src, SrcLen);
  end;
  FLen := StrLen(FString);
end;

procedure TAdStr.First;
begin
  FCur := FString;
end;

function TAdStr.GetBuffLen: Integer;
begin
  Result := FMaxLen + 1;
end;

function TAdStr.GetChar(Index: Cardinal): Char;
begin
  Result := FString[Index];
end;

function TAdStr.GetCurChar: Char;
begin
  Result := FCur[0];
end;

function TAdStr.GetLen: Integer;
begin
  Result := FLen;
end;

function TAdStr.GetMaxLen: Integer;
begin
  Result := FMaxLen;
end;

procedure TAdStr.GotoPos(Index: Cardinal);
begin
  FCur := FString;
  Inc(FCur, Index-1);
end;

procedure TAdStr.Insert(const Text: string; Index: Integer);
var
  Buff: PChar;
  NewLen: Integer;
begin
  if (Index = 0) or (Index > FLen) or (Text = '') then Exit;

  NewLen := Length(Text) + FLen;
  if NewLen > FMaxLen then         { if new text will be longer than allocated }
    Resize(NewLen);              { reallocate }

  GotoPos(Index);                  { find insertion point }
  Buff := StrNew(FCur);            { make copy of rest of string }
  StrPCopy(FCur, Text);            { append Text at insertion point }
  StrCat(FString, Buff);           { add rest of string back on }
  StrDispose(Buff);
  FLen := StrLen(FString);
end;

procedure TAdStr.Insert(const Text: AnsiString; Index: Integer);
begin
  Insert(string(Text), Index);
end;

procedure TAdStr.Last;
begin
  FCur := StrEnd(FString) - 1;
end;

procedure TAdStr.Resize(NewLen: Integer);
var
  Temp: PChar;
  TempLen: Cardinal;
begin
  Temp := StrNew(FString);
  if (NewLen - 1) < FLen then
    TempLen := NewLen - 1
  else
    TempLen := FLen;
  SetMaxLen(NewLen);
  StrLCopy(FString, Temp, TempLen);
  StrDispose(Temp);
  FLen := StrLen(FString)
end;

procedure TAdStr.MoveBy(IndexBy: Integer);
begin
  if IndexBy < 0 then
    Dec(FCur, IndexBy)
  else
  if IndexBy > 0 then
    Inc(FCur, IndexBy)
  else
    {no change};
end;

procedure TAdStr.Next;
begin
  Inc(FCur, 1);
end;

function TAdStr.Pos(const SubStr: string): Cardinal;
var
  Buff: PChar;
begin
  Buff := StrAlloc(Length(SubStr) + 1);
  StrPCopy(Buff,SubStr);
  FCur := StrPos(FString, Buff);
  StrDispose(Buff);

  if FCur = nil then
    Result := 0
  else
    Result := FCur - FString + 1;
end;

function TAdStr.PosIdx(const SubStr: string; Index: Integer): Cardinal;
var
  Buff: PChar;
begin
  if (Index = 0) or (Index > FLen) then begin
    Result := 0 ;
    Exit ;
  end;

  GetMem(Buff, Length(SubStr) + 5);
  GotoPos(Index);
  FCur := StrPos(FCur, StrPCopy(Buff,SubStr));
  StrDispose(Buff);

  if FCur = nil then
    Result := 0
  else
    Result := FCur - FString + 1;
end;

procedure TAdStr.Prepend(const Text: string);
begin
  Insert(Text,1);
end;

procedure TAdStr.Prepend(const Text: AnsiString);
begin
  Insert(string(Text), 1);
end;

procedure TAdStr.Prev;
begin
  Dec(FCur,1);
end;

procedure TAdStr.SetChar(Index: Cardinal; Value: Char);
begin
  if FString[Index] <> Value then
    FString[Index] := Value;
end;

procedure TAdStr.SetLen(NewLen: Integer);
begin
  if NewLen <= FLen then
    FString[NewLen] := #0;
end;

procedure TAdStr.SetMaxLen(NewMaxLen: Integer);
begin
  if FMaxLen <> NewMaxLen then begin
    if Assigned(FString) then
      FreeMem(FString, FMaxLen + 5);
    FMaxLen := NewMaxLen;
    if FMaxLen = 0 then
      FString := nil
    else
      GetMem(FString, FMaxLen + 5);
  end;

  if Assigned(FString) then
    FString[0] := #0;
  FLen := 0;
end;

{$ENDIF}
{$ENDIF}

function MinWord(A, B : Cardinal) : Cardinal;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function FlagIsSet(Flags : Cardinal; FlagMask : Cardinal) : Bool;
begin
  FlagIsSet := (Flags and FlagMask) <> 0;
end;

procedure ClearFlag(var Flags : Cardinal; FlagMask : Cardinal);
begin
  Flags := Flags and not FlagMask;
end;

procedure SetFlag(var Flags : Cardinal; FlagMask : Cardinal);
begin
  Flags := Flags or FlagMask;
end;

function ByteFlagIsSet(Flags : Byte; FlagMask : Byte) : Bool;
begin
  ByteFlagIsSet := (Flags and FlagMask) <> 0;
end;

procedure ClearByteFlag(var Flags : Byte; FlagMask : Byte);
begin
  Flags := Flags and not FlagMask;
end;

procedure SetByteFlag(var Flags : Byte; FlagMask : Byte);
begin
  Flags := Flags or FlagMask;
end;

function AddWordToPtr(P : Pointer; W : Cardinal) : Pointer; assembler;
asm
  add   eax,edx
end;

const
  DosDelimSet : set of AnsiChar = ['\', ':', #0];

  MaxPCharLen = $7FFFFFFF;

  function SafeYield : Integer;
    {-Allow other processes a chance to run}
  var
    Msg : TMsg;
  begin
    SafeYield := 0;
    if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then begin
      if Msg.Message = wm_Quit then
        {Re-post quit message so main message loop will terminate}
        PostQuitMessage(Msg.WParam)
      else begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
      {Return message so caller can act on message if necessary}
      SafeYield := MAKELONG(Msg.Message, Msg.hwnd);
    end;
  end;

  { Centralized timer method, return is the number of ms since the system started }
  function AdTimeGetTime : DWord;
  begin
    Result := timeGetTime;                                                  // SWB
  end;

  function Ticks2Secs(Ticks : Integer) : Integer;
    {-Returns seconds value for Ticks Ticks}
  begin
    Ticks2Secs := ((Ticks + 9) * SecsFreq) div TicksFreq;
  end;

  function Secs2Ticks(Secs : Integer) : Integer;
    {-Returns Ticks value for Secs seconds}
  begin
    Secs2Ticks := (Secs * TicksFreq) div SecsFreq;
  end;

  function MSecs2Ticks(MSecs : Integer) : Integer;
    {-Returns Ticks value for msecs}
  begin
    Result := (MSecs * TicksFreq) div MSecsFreq;
  end;

  procedure NewTimer(var ET : EventTimer; Ticks : Integer);
    {-Returns a set EventTimer that will expire in Ticks}
  begin
    {Max acceptable value is MaxTicks}
    if Ticks > MaxTicks then
      Ticks := MaxTicks;

    with ET do begin
      StartTicks := AdTimeGetTime div 55;
      ExpireTicks := StartTicks + Ticks;
    end;
  end;

  procedure NewTimerSecs(var ET : EventTimer; Secs : Integer);
    {-Returns a set EventTimer}
  begin
    NewTimer(ET, Secs2Ticks(Secs));
  end;

  function TimerExpired(ET : EventTimer) : Bool;
    {-Returns True if ET has expired}
  var
    CurTicks : Integer;
  begin
    with ET do begin
      {Get current Ticks; assume timer has expired}
      CurTicks := AdTimeGetTime div 55;
      TimerExpired := True;
      {Check normal expiration}
      if CurTicks > ExpireTicks then
        Exit;
      {Check wrapped CurTicks}
      if (CurTicks < StartTicks) and
         ((CurTicks + MaxTicks) > ExpireTicks) then
        Exit;

      {If we get here, timer hasn't expired yet}
      TimerExpired := False;
    end;
  end;

  function ElapsedTime(ET : EventTimer) : Integer;
    {-Returns elapsed time, in Ticks, for this timer}
  var
    CurTicks : Integer;
  begin
    with ET do begin
      CurTicks := AdTimeGetTime div 55;
      if CurTicks >= StartTicks then
        {No wrap yet}
        ElapsedTime := CurTicks - StartTicks
      else
        {Got a wrap, account for it}
        ElapsedTime := (MaxTicks - StartTicks) + CurTicks;
    end;
  end;

  function ElapsedTimeInSecs(ET : EventTimer) : Integer;
    {-Returns elapsed time, in seconds, for this timer}
  begin
    ElapsedTimeInSecs := Ticks2Secs(ElapsedTime(ET));
  end;

  function RemainingTime(ET : EventTimer) : Integer;
    {-Returns remaining time, in Ticks, for this timer}
  var
    CurTicks : Integer;
    RemainingTicks : Integer;
  begin
    with ET do begin
      CurTicks := AdTimeGetTime div 55;
      if CurTicks >= StartTicks then
        {No wrap yet}
        RemainingTicks := ExpireTicks - CurTicks
      else
        {Got a wrap, account for it}
        RemainingTicks := (ExpireTicks - MaxTicks) - CurTicks;
    end;
    if RemainingTicks < 0 then
      RemainingTime := 0
    else
      RemainingTime := RemainingTicks;
  end;

  function RemainingTimeInSecs(ET : EventTimer) : Integer;
    {-Returns remaining time, in seconds, for this timer}
  begin
    RemainingTimeInSecs := Ticks2Secs(RemainingTime(ET));
  end;

  function DelayTicks(Ticks : Integer; Yield : Bool) : Integer;
    {-Delay for Ticks ticks}
  var
    ET : EventTimer;
    Res : Integer;
  begin
    if Ticks <= 0 then begin
      DelayTicks := 0;
      Exit;
    end else if Ticks > MaxTicks then
      Ticks := MaxTicks;

    Res := 0;
    NewTimer(ET, Ticks);
    repeat
      if Yield then
        Res := SafeYield;
    until (Res = wm_Quit) or TimerExpired(ET);
    DelayTicks := Res;
  end;

  {$IFNDEF PrnDrv}
  function Long2StrZ(Dest : PChar; L : Integer) : PChar;
    {-Convert a long/Cardinal/integer/byte/shortint to a string}
  var
    S : ShortString;
  begin
    Str(L, S);
    Result := StrPCopy(Dest, string(S));
  end;
  {$ENDIF}

const
  MaxLen  = 255;
  ExtLen = 3;

type
  TSmallArray = Array[0..MaxLen-1] of Char;

  {$IFNDEF PrnDrv}
  function Str2LongZ(S : PChar; var I : Integer) : Bool;
    {-Convert a string to a Integer, returning true if successful}
  var
    Err : Integer;
  begin
    Val(StrPas(S),I,Err);
    Result := Err = 0;
  end;
  {$ENDIF}

  function JustPathnameZ(out Dest : string; PathName : string) : string;
    {-Return just the drive:directory portion of a pathname}
  begin
    Result := ExtractFileDir(PathName);
    Dest := Result;
  end;

  function JustPathnameZ(Dest : PAnsiChar; PathName : PAnsiChar) : PAnsiChar; overload;
    {-Return just the drive:directory portion of a pathname}
  var
    I : Integer;

  begin
    I := AnsiStrings.StrLen(PathName);
    repeat
      Dec(I);
    until (I = -1) or (PathName[I] in DosDelimSet);

    if I = -1 then
      {Had no drive or directory name}
      Dest[0] := #0
    else if I = 0 then begin
      {Either the root directory of default drive or invalid pathname}
      Dest[0] := PathName[0];
      Dest[1] := #0;
    end else if (PathName[I] = '\') then begin
      if PathName[Pred(I)] = ':' then
        {Root directory of a drive, leave trailing backslash}
        Dest := StrStCopy(Dest, PathName, 0, Succ(I))
      else
        {Subdirectory, remove the trailing backslash}
        Dest := StrStCopy(Dest, PathName, 0, I);
    end else
      {Either the default directory of a drive or invalid pathname}
      Dest:= StrStCopy(Dest, PathName, 0, Succ(I));
    Result := Dest;
  end;

  function JustFilenameZ(Dest : PAnsiChar; PathName : PAnsiChar) : PAnsiChar;
    {-Return just the filename of a pathname}
  var
    I : Cardinal;
  begin
    I := AnsiStrings.StrLen(PathName);
    while (I > 0) and (not (PathName[I-1] in DosDelimSet)) do
      Dec(I);
    Dest := StrStCopy(Dest, PathName, I, MaxLen);
    Result := Dest;
  end;

  {$IFNDEF PrnDrv}
  function JustExtensionZ(out Dest : string; Name : string) : string;
  var
    X : string;
  begin
    X := ExtractFileExt(Name);
    if X = '' then
      Dest := ''
    else
      Dest := Copy(X, 2, 255);
    Result := Dest;
  end;
  {$ENDIF}

  function StrStCopy(Dest : PAnsiChar; S : PAnsiChar; Pos, Count : Cardinal) : PAnsiChar;
  var
    Len : Cardinal;

  begin
    Len := AnsiStrings.StrLen(S);
    if Pos < Len then begin
      if (Len-Pos) < Count then
        Count := Len-Pos;
      Move(S[Pos], Dest^, Count);
      Dest[Count] := #0;
    end else
      Dest[0] := #0;
    Result := Dest;
  end;

  function StrStCopy(Dest : PWideChar; S : PWideChar; Pos, Count : Cardinal) : PWideChar;
  var
    Len : Cardinal;
  begin
    Len := StrLenW(S);
    if Pos < Len then begin
      if (Len-Pos) < Count then
        Count := Len-Pos;
      Move(S[Pos], Dest^, Count * SizeOf(WideChar));
      Dest[Count] := #0;
    end else
      Dest[0] := #0;
    StrStCopy := Dest;
  end;


  function AddBackSlashZ(out Dest : string; DirName : string) : string; overload;
    {-Add a default backslash to a directory name}
  begin
    Result := IncludeTrailingPathDelimiter(DirName);
    Dest := Result;
  end;

  function AddBackSlashZ(Dest : PAnsiChar; DirName : PAnsiChar) : PAnsiChar;
    {-Add a default backslash to a directory name}
  var
    L : Cardinal;
  begin
    Result := Dest;
    AnsiStrings.StrCopy(Dest, DirName);
    L := AnsiStrings.StrLen(DirName);
    if (L > 0) and not(DirName[L-1] in DosDelimSet) then begin
      Dest[L] := '\';
      Dest[L+1] := #0;
    end;
  end;

  {$IFNDEF PrnDrv}
  function ExistFileZ(FName : string) : Bool;
  begin
    Result := FileExists(FName);
  end;
  {$ENDIF}

  function ForceExtensionZ(out Dest : string; Name, Ext : string) : string; overload;
  begin
    Result := ChangeFileExt(Name,'.'+Ext);
    Dest := Result;
  end;

  function DefaultExtensionZ(out Dest : string; Name, Ext : string) : string;
  var
    S : string;
  begin
    S := Name;
    if ExtractFileExt(S) = '' then
      S := ChangeFileExt(S,'.'+Ext);
    Dest := S;
    Result := S;
  end;

  function GetPtr(P : Pointer; O : Integer) : Pointer; assembler; register;
  asm
    add   eax,edx   {eax = P; edx = Offset}
  end;

  procedure NotBuffer(var Buf; Len : Cardinal); assembler; register;
  asm
    {eax is the pointer to the buffer}
    {edx is the length of the buffer}
    xor   ecx,ecx
    shr   edx,1
    rcl   ecx,1
    shr   edx,1
    rcl   ecx,1

    or    edx,edx
    jz    @2

@1: not   dword ptr [eax]
    add   eax,4
    dec   edx
    jnz   @1

@2: or    ecx,ecx
    jz    @4

@3: not   byte ptr [eax]
    inc   eax
    dec   ecx
    jnz   @3

@4:
  end;

  function DelayMS(MS : Cardinal) : Cardinal;
  var
    CDelay: Cardinal;
    CTime: Integer;
    LTime: Integer;
  begin
    {Always return the delayed MS value}
    DelayMS := MS;

    {Get starting time}
    LTime := AdTimeGetTime;

    {Delay for MS milliseconds}
    CDelay := 0;
    while CDelay < MS do begin
      CTime := AdTimeGetTime;
      Inc(CDelay, CTime - LTime);
      LTime := CTime;
    end;
  end;

{$IFNDEF PrnDrv}
  function JustName(PathName : string) : string;
    {-Return just the name (no extension, no path) of a pathname}
  var
    DotPos : Byte;
  begin
    PathName := ExtractFileName(PathName);
    DotPos := Pos('.', PathName);
    if DotPos > 0 then
      PathName := Copy(PathName, 1, DotPos-1);
    Result := PathName;
  end;

  function AddBackSlash(const DirName : String) : String;
  begin
    Result := IncludeTrailingPathDelimiter(DirName);
  end;

  function AddBackSlash(const DirName : AnsiString) : AnsiString;
  begin
    Result := AnsiString(IncludeTrailingPathDelimiter(string(DirName)));
  end;

function IsWin2000 : Boolean;
//var
// Osi : TOSVersionInfo;
begin
//  Result := False;
//  Osi.dwOSVersionInfoSize := sizeof(Osi);
//  GetVersionEx(Osi);
//  if (Osi.dwPlatformID = Ver_Platform_Win32_NT) then
//    if Osi.dwMinorVersion = 0 then                                       {!!.04}
//      Result := True;    //SZ: was false on Windows XP, Win7
  Result := CheckWin32Version(5, 0);
end;

function IsWinNT : Boolean;
var
  Osi : TOSVersionInfo;
begin
  Osi.dwOSVersionInfoSize := sizeof(Osi);
  GetVersionEx(Osi);
  Result :=  (Osi.dwPlatformID = Ver_Platform_Win32_NT);
end;

{ TApdBaseComponent }
function TApdBaseComponent.GetVersion : string;
begin
  Result := ApVersionStr;
end;

procedure TApdBaseComponent.SetVersion(const Value : string);
begin
end;

{ TApdBaseWinControl }
function TApdBaseWinControl.GetVersion : string;
begin
  Result := ApVersionStr;
end;

procedure TApdBaseWinControl.SetVersion(const Value : string);
begin
end;

{ TApdBaseOleControl }
function TApdBaseOleControl.GetVersion : string;
begin
  Result := ApVersionStr;
end;

procedure TApdBaseOleControl.SetVersion(const Value : string);
begin
end;

{ TApdBaseGraphicControl }
function TApdBaseGraphicControl.GetVersion: string;
begin
  Result := ApVersionStr;
end;

procedure TApdBaseGraphicControl.SetVersion(const Value: string);
begin
end;

{ TApdBaseScrollingWinControl }
function TApdBaseScrollingWinControl.GetVersion: string;
begin
  Result := ApVersionStr;
end;

procedure TApdBaseScrollingWinControl.SetVersion(const Value: string);
begin                    
end;
{$ENDIF}

function ApWinExecAndWait32(FileName : PChar; CommandLine : PChar;
                            Visibility : Integer) : Integer;
 { returns -1 if the Exec failed, otherwise returns the process' exit }
 { code when the process terminates }
var
  CmdLine: string;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  Temp : DWORD;
begin
  CmdLine := FileName;
  if Assigned(CommandLine) then
    CmdLine := CmdLine + ' ' + CommandLine;
  FillChar(StartupInfo, Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
      PChar(CmdLine),        { pointer to command line string }
      nil,                   { pointer to process security attributes }
      nil,                   { pointer to thread security attributes }
      false,                 { handle inheritance flag }
      CREATE_NEW_CONSOLE or  { creation flags }
      NORMAL_PRIORITY_CLASS,
      nil,                   { pointer to new environment block }
      nil,                   { pointer to current directory name }
      StartupInfo,           { pointer to STARTUPINFO }
      ProcessInfo) then      { pointer to PROCESS_INF }
        Result := -1
  else begin
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess,Temp);
    CloseHandle(ProcessInfo.hProcess);                                   {!!.02}
    CloseHandle(ProcessInfo.hThread);                                    {!!.02}
    Result := Integer(Temp);
  end;
end;

{ SZ - what is this????     removed because of Loader Lock problem FIXME
var                                                                         // SWB
    tc          : TTimeCaps;                                                // SWB

initialization
begin                                                                       // SWB
    timeGetDevCaps(@tc, SizeOf(tc));                                        // SWB
    timeBeginPeriod(tc.wPeriodMin);                                         // SWB
end;                                                                        // SWB

finalization                                                                // SWB
begin                                                                       // SWB
    timeEndPeriod(tc.wPeriodMin);                                           // SWB
end;

}                                                                       // SWB


end.



