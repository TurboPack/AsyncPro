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
 *
 * ***** END LICENSE BLOCK ***** *)

unit APAX1_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// PASTLWTR : $Revision: 1.1.1.1 $
// File generated on 9/11/2002 1:30:03 PM from Type Library described below.

// ************************************************************************ //
// Type Lib: E:\APAX\Apax1.tlb (1)
// IID\LCID: {797E7185-0DB7-4E3A-939B-234871F7FAC9}\0
// Helpfile: C:\TurboPower\APAX\Apax.chm
// DepndLst:
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARNINGS OFF} 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  APAX1MajorVersion = 1;
  APAX1MinorVersion = 11;

  LIBID_APAX1: TGUID = '{797E7185-0DB7-4E3A-939B-234871F7FAC9}';

  IID_IApax: TGUID = '{7147F87B-077B-4796-9C82-C0BA5C846876}';
  DIID_IApaxEvents: TGUID = '{EB835ACB-DEA7-4527-92BA-2BE7FBEFAFB5}';
  CLASS_Apax: TGUID = '{28E7F3B1-59C2-4B1C-9D8E-0610B280898D}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TxFlowControlState
type
  TxFlowControlState = TOleEnum;
const
  fcOff = $00000000;
  fcOn = $00000001;
  fcDsrHold = $00000002;
  fcCtsHold = $00000003;
  fcDcdHold = $00000004;
  fcXOutHold = $00000005;
  fcXInHold = $00000006;
  fcXBothHold = $00000007;

// Constants for enum TxTapiState
type
  TxTapiState = TOleEnum;
const
  tsIdle = $00000000;
  tsOffering = $00000001;
  tsAccepted = $00000002;
  tsDialTone = $00000003;
  tsDialing = $00000004;
  tsRingback = $00000005;
  tsBusy = $00000006;
  tsSpecialInfo = $00000007;
  tsConnected = $00000008;
  tsProceeding = $00000009;
  tsOnHold = $0000000A;
  tsConferenced = $0000000B;
  tsOnHoldPendConf = $0000000C;
  tsOnHoldPendTransfer = $0000000D;
  tsDisconnected = $0000000E;
  tsUnknown = $0000000F;

// Constants for enum TxWaveState
type
  TxWaveState = TOleEnum;
const
  wsIdle = $00000000;
  wsPlaying = $00000001;
  wsRecording = $00000002;
  wsData = $00000003;

// Constants for enum TxApxDeviceType
type
  TxApxDeviceType = TOleEnum;
const
  dtDirect = $00000000;
  dtTAPI = $00000001;
  dtWinsock = $00000002;

// Constants for enum TxTraceLogState
type
  TxTraceLogState = TOleEnum;
const
  tlOff = $00000000;
  tlOn = $00000001;
  tlDump = $00000002;
  tlAppend = $00000003;
  tlClear = $00000004;
  tlPause = $00000005;

// Constants for enum TxParity
type
  TxParity = TOleEnum;
const
  pNone = $00000000;
  pOdd = $00000001;
  pEven = $00000002;
  pMark = $00000003;
  pSpace = $00000004;

// Constants for enum TxSWFlowOptions
type
  TxSWFlowOptions = TOleEnum;
const
  swfNone = $00000000;
  swfReceive = $00000001;
  swfTransmit = $00000002;
  swfBoth = $00000003;

// Constants for enum TxWsMode
type
  TxWsMode = TOleEnum;
const
  wsClient = $00000000;
  wsServer = $00000001;

// Constants for enum TxAdCaptureMode
type
  TxAdCaptureMode = TOleEnum;
const
  cmOff = $00000000;
  cmOn = $00000001;
  cmAppend = $00000002;

// Constants for enum TxApxTerminalEmulation
type
  TxApxTerminalEmulation = TOleEnum;
const
  teTTY = $00000000;
  teVT100 = $00000001;

// Constants for enum TxProtocolType
type
  TxProtocolType = TOleEnum;
const
  ptNoProtocol = $00000000;
  ptXmodem = $00000001;
  ptXmodemCRC = $00000002;
  ptXmodem1K = $00000003;
  ptXmodem1KG = $00000004;
  ptYmodem = $00000005;
  ptYmodemG = $00000006;
  ptZmodem = $00000007;
  ptKermit = $00000008;
  ptAscii = $00000009;

// Constants for enum TxAsciiEOLTranslation
type
  TxAsciiEOLTranslation = TOleEnum;
const
  aetNone = $00000000;
  aetStrip = $00000001;
  aetAddCRBefore = $00000002;
  aetAddLFAfter = $00000003;

// Constants for enum TxBlockCheckMethod
type
  TxBlockCheckMethod = TOleEnum;
const
  bcmNone = $00000000;
  bcmChecksum = $00000001;
  bcmChecksum2 = $00000002;
  bcmCrc16 = $00000003;
  bcmCrc32 = $00000004;
  bcmCrcK = $00000005;

// Constants for enum TxWriteFailAction
type
  TxWriteFailAction = TOleEnum;
const
  wfWriteNone = $00000000;
  wfWriteFail = $00000001;
  wfWriteRename = $00000002;
  wfWriteAnyway = $00000003;
  wfWriteResume = $00000004;

// Constants for enum TxZmodemFileOptions
type
  TxZmodemFileOptions = TOleEnum;
const
  zfoNoOption = $00000000;
  zfoWriteNewerLonger = $00000001;
  zfoWriteCrc = $00000002;
  zfoWriteAppend = $00000003;
  zfoWriteClobber = $00000004;
  zfoWriteNewer = $00000005;
  zfoWriteDifferent = $00000006;
  zfoWriteProtect = $00000007;

// Constants for enum TxAlignment
type
  TxAlignment = TOleEnum;
const
  taLeftJustify = $00000000;
  taRightJustify = $00000001;
  taCenter = $00000002;

// Constants for enum TxWaveMessage
type
  TxWaveMessage = TOleEnum;
const
  waPlayOpen = $00000000;
  waPlayDone = $00000001;
  waPlayClose = $00000002;
  waRecordOpen = $00000003;
  waDataReady = $00000004;
  waRecordClose = $00000005;

// Constants for enum HandshakeConstants
type
  HandshakeConstants = TOleEnum;
const
  comNone = $00000000;
  comXOnXoff = $00000001;
  comRTS = $00000002;
  comRTSXOnXOff = $00000003;

// Constants for enum InputModeConstants
type
  InputModeConstants = TOleEnum;
const
  comInputModeText = $00000000;
  comInputModeBinary = $00000001;

// Constants for enum CommEventConstants
type
  CommEventConstants = TOleEnum;
const
  comEventBreak = $000003E9;
  comEventCTSTO = $000003EA;
  comEventDSRTO = $000003EB;
  comEventFrame = $000003EC;
  comEventOverrun = $000003EE;
  comEventCDTO = $000003EF;
  comEventRxOver = $000003F0;
  comEventRxParity = $000003F1;
  comEventTxFull = $000003F2;

// Constants for enum OnCommConstants
type
  OnCommConstants = TOleEnum;
const
  comEvSend = $00000001;
  comEvReceive = $00000002;
  comEvCTS = $00000003;
  comEvDSR = $00000004;
  comEvCD = $00000005;
  comEvRing = $00000006;

// Constants for enum TxDragMode
type
  TxDragMode = TOleEnum;
const
  dmManual = $00000000;
  dmAutomatic = $00000001;

// Constants for enum TxMouseButton
type
  TxMouseButton = TOleEnum;
const
  mbLeft = $00000000;
  mbRight = $00000001;
  mbMiddle = $00000002;

// Constants for enum TxFTPFileType
type
  TxFTPFileType = TOleEnum;
const
  ftAscii = $00000000;
  ftBinary = $00000001;

// Constants for enum TxFTPRetrieveMode
type
  TxFTPRetrieveMode = TOleEnum;
const
  rmAppend = $00000000;
  rmReplace = $00000001;
  rmRestart = $00000002;

// Constants for enum TxFTPStoreMode
type
  TxFTPStoreMode = TOleEnum;
const
  smAppend = $00000000;
  smReplace = $00000001;
  smUnique = $00000002;
  smRestart = $00000003;

// Constants for enum TxFTPState
type
  TxFTPState = TOleEnum;
const
  fsNone = $00000000;
  fsAbort = $00000001;
  fsChangeDir = $00000002;
  fsCurrentDir = $00000003;
  fsDelete = $00000004;
  fsHelp = $00000005;
  fsListDir = $00000006;
  fsLogIn = $00000007;
  fsLogOut = $00000008;
  fsMakeDir = $00000009;
  fsRemoveDir = $0000000A;
  fsRename = $0000000B;
  fsRetrieve = $0000000C;
  fsSendFTPCommand = $0000000D;
  fsStatus = $0000000E;
  fsStore = $0000000F;

// Constants for enum TxFTPLogCode
type
  TxFTPLogCode = TOleEnum;
const
  lcClose = $00000000;
  lcOpen = $00000001;
  lcLogout = $00000002;
  lcLogin = $00000003;
  lcDelete = $00000004;
  lcRename = $00000005;
  lcReceive = $00000006;
  lcStore = $00000007;
  lcComplete = $00000008;
  lcRestart = $00000009;
  lcTimeout = $0000000A;
  lcUserAbort = $0000000B;

// Constants for enum TxFTPStatusCode
type
  TxFTPStatusCode = TOleEnum;
const
  scClose = $00000000;
  scOpen = $00000001;
  scLogout = $00000002;
  scLogin = $00000003;
  scComplete = $00000004;
  scCurrentDir = $00000005;
  scDataAvail = $00000006;
  scProgress = $00000007;
  scTransferOK = $00000008;
  scTimeout = $00000009;

// Constants for enum TxProtocolLogCode
type
  TxProtocolLogCode = TOleEnum;
const
  lfReceiveStart = $00000000;
  lfReceiveOK = $00000001;
  lfReceiveFail = $00000002;
  lfReceiveSkip = $00000003;
  lfTransmitStart = $00000004;
  lfTransmitOK = $00000005;
  lfTransmitFail = $00000006;
  lfTransmitSkip = $00000007;

// Constants for enum TxCharSource
type
  TxCharSource = TOleEnum;
const
  csUnknown = $00000000;
  csKeyboard = $00000001;
  csPort = $00000002;
  csWriteChar = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IApax = interface;
  IApaxDisp = dispinterface;
  IApaxEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Apax = IApax;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PPUserType1 = ^IFontDisp; {*}


// *********************************************************************//
// Interface: IApax
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7147F87B-077B-4796-9C82-C0BA5C846876}
// *********************************************************************//
  IApax = interface(IDispatch)
    ['{7147F87B-077B-4796-9C82-C0BA5C846876}']
    function  PortOpen: Integer; safecall;
    function  TapiDial: Integer; safecall;
    function  TapiAnswer: Integer; safecall;
    function  WinsockConnect: Integer; safecall;
    function  WinsockListen: Integer; safecall;
    function  Close: Integer; safecall;
    procedure AddStringToLog(const S: WideString); safecall;
    procedure FlushInBuffer; safecall;
    procedure FlushOutBuffer; safecall;
    function  PutData(Data: OleVariant): Integer; safecall;
    function  PutString(const S: WideString): Integer; safecall;
    function  PutStringCRLF(const S: WideString): Integer; safecall;
    procedure SendBreak(Ticks: Integer; Yield: WordBool); safecall;
    function  AddDataTrigger(const TriggerString: WideString; PacketSize: Integer; 
                             Timeout: Integer; IncludeStrings: WordBool; IgnoreCase: WordBool): Integer; safecall;
    procedure DisableDataTrigger(Index: Integer); safecall;
    procedure EnableDataTrigger(Index: Integer); safecall;
    procedure RemoveDataTrigger(Index: Integer); safecall;
    procedure Clear; safecall;
    procedure ClearAll; safecall;
    procedure CopyToClipboard; safecall;
    function  GetAttributes(aRow: Integer; aCol: Integer): Integer; safecall;
    procedure SetAttributes(aRow: Integer; aCol: Integer; Value: Integer); safecall;
    function  GetLine(Index: Integer): WideString; safecall;
    procedure SetLine(Index: Integer; const Value: WideString); safecall;
    procedure TerminalSetFocus; safecall;
    procedure TerminalWriteString(const S: WideString); safecall;
    procedure TerminalWriteStringCRLF(const S: WideString); safecall;
    procedure TapiAutoAnswer; safecall;
    procedure TapiCancelCall; safecall;
    procedure TapiConfigAndOpen; safecall;
    function  TapiSelectDevice: WordBool; safecall;
    procedure TapiSendTone(const Digits: WideString); safecall;
    procedure TapiSetRecordingParams(NumChannels: Integer; NumSamplesPerSecond: Integer; 
                                     NumBitsPerSample: Integer); safecall;
    procedure TapiShowConfigDialog(AllowEdit: WordBool); safecall;
    procedure TapiPlayWaveFile(const FileName: WideString); safecall;
    procedure TapiRecordWaveFile(const FileName: WideString; Overwrite: WordBool); safecall;
    procedure TapiStopWaveFile; safecall;
    function  TapiTranslatePhoneNo(const CanonicalAddr: WideString): WideString; safecall;
    procedure CancelProtocol; safecall;
    function  EstimateTransferSecs(Size: Integer): Integer; safecall;
    procedure StartTransmit; safecall;
    procedure StartReceive; safecall;
    function  Get_CTS: WordBool; safecall;
    function  Get_DCD: WordBool; safecall;
    function  Get_DSR: WordBool; safecall;
    function  Get_FlowState: TxFlowControlState; safecall;
    function  Get_InBuffUsed: Integer; safecall;
    function  Get_InBuffFree: Integer; safecall;
    function  Get_LineError: Integer; safecall;
    function  Get_OutBuffFree: Integer; safecall;
    function  Get_OutBuffUsed: Integer; safecall;
    function  Get_RI: WordBool; safecall;
    function  Get_TapiAttempt: Integer; safecall;
    function  Get_CallerID: WideString; safecall;
    function  Get_TapiCancelled: WordBool; safecall;
    function  Get_Dialing: WordBool; safecall;
    function  Get_TapiState: TxTapiState; safecall;
    function  Get_WaveFileName: WideString; safecall;
    function  Get_WaveState: TxWaveState; safecall;
    function  Get_Batch: WordBool; safecall;
    function  Get_BlockErrors: Integer; safecall;
    function  Get_BlockLength: Integer; safecall;
    function  Get_BlockNumber: Integer; safecall;
    function  Get_BytesRemaining: Integer; safecall;
    function  Get_BytesTransferred: Integer; safecall;
    function  Get_ElapsedTicks: Integer; safecall;
    function  Get_FileDate: Double; safecall;
    function  Get_FileLength: Integer; safecall;
    function  Get_InProgress: WordBool; safecall;
    function  Get_InitialPosition: Integer; safecall;
    function  Get_KermitLongBlocks: WordBool; safecall;
    function  Get_KermitWindowsTotal: Integer; safecall;
    function  Get_KermitWindowsUsed: Integer; safecall;
    function  Get_ProtocolStatus: Integer; safecall;
    function  Get_TotalErrors: Integer; safecall;
    function  Get_Baud: Integer; safecall;
    procedure Set_Baud(Value: Integer); safecall;
    function  Get_ComNumber: Integer; safecall;
    procedure Set_ComNumber(Value: Integer); safecall;
    function  Get_DeviceType: TxApxDeviceType; safecall;
    procedure Set_DeviceType(Value: TxApxDeviceType); safecall;
    function  Get_DataBits: Integer; safecall;
    procedure Set_DataBits(Value: Integer); safecall;
    function  Get_DTR: WordBool; safecall;
    procedure Set_DTR(Value: WordBool); safecall;
    function  Get_HWFlowUseDTR: WordBool; safecall;
    procedure Set_HWFlowUseDTR(Value: WordBool); safecall;
    function  Get_HWFlowUseRTS: WordBool; safecall;
    procedure Set_HWFlowUseRTS(Value: WordBool); safecall;
    function  Get_HWFlowRequireDSR: WordBool; safecall;
    procedure Set_HWFlowRequireDSR(Value: WordBool); safecall;
    function  Get_HWFlowRequireCTS: WordBool; safecall;
    procedure Set_HWFlowRequireCTS(Value: WordBool); safecall;
    function  Get_LogAllHex: WordBool; safecall;
    procedure Set_LogAllHex(Value: WordBool); safecall;
    function  Get_Logging: TxTraceLogState; safecall;
    procedure Set_Logging(Value: TxTraceLogState); safecall;
    function  Get_LogHex: WordBool; safecall;
    procedure Set_LogHex(Value: WordBool); safecall;
    function  Get_LogName: WideString; safecall;
    procedure Set_LogName(const Value: WideString); safecall;
    function  Get_LogSize: Integer; safecall;
    procedure Set_LogSize(Value: Integer); safecall;
    function  Get_Parity: TxParity; safecall;
    procedure Set_Parity(Value: TxParity); safecall;
    function  Get_PromptForPort: WordBool; safecall;
    procedure Set_PromptForPort(Value: WordBool); safecall;
    function  Get_RS485Mode: WordBool; safecall;
    procedure Set_RS485Mode(Value: WordBool); safecall;
    function  Get_RTS: WordBool; safecall;
    procedure Set_RTS(Value: WordBool); safecall;
    function  Get_StopBits: Integer; safecall;
    procedure Set_StopBits(Value: Integer); safecall;
    function  Get_SWFlowOptions: TxSWFlowOptions; safecall;
    procedure Set_SWFlowOptions(Value: TxSWFlowOptions); safecall;
    function  Get_XOffChar: Integer; safecall;
    procedure Set_XOffChar(Value: Integer); safecall;
    function  Get_XOnChar: Integer; safecall;
    procedure Set_XOnChar(Value: Integer); safecall;
    function  Get_WinsockMode: TxWsMode; safecall;
    procedure Set_WinsockMode(Value: TxWsMode); safecall;
    function  Get_WinsockAddress: WideString; safecall;
    procedure Set_WinsockAddress(const Value: WideString); safecall;
    function  Get_WinsockPort: WideString; safecall;
    procedure Set_WinsockPort(const Value: WideString); safecall;
    function  Get_WsTelnet: WordBool; safecall;
    procedure Set_WsTelnet(Value: WordBool); safecall;
    function  Get_AnswerOnRing: Integer; safecall;
    procedure Set_AnswerOnRing(Value: Integer); safecall;
    function  Get_EnableVoice: WordBool; safecall;
    procedure Set_EnableVoice(Value: WordBool); safecall;
    function  Get_MaxAttempts: Integer; safecall;
    procedure Set_MaxAttempts(Value: Integer); safecall;
    function  Get_InterruptWave: WordBool; safecall;
    procedure Set_InterruptWave(Value: WordBool); safecall;
    function  Get_MaxMessageLength: Integer; safecall;
    procedure Set_MaxMessageLength(Value: Integer); safecall;
    function  Get_SelectedDevice: WideString; safecall;
    procedure Set_SelectedDevice(const Value: WideString); safecall;
    function  Get_SilenceThreshold: Integer; safecall;
    procedure Set_SilenceThreshold(Value: Integer); safecall;
    function  Get_TapiNumber: WideString; safecall;
    procedure Set_TapiNumber(const Value: WideString); safecall;
    function  Get_TapiRetryWait: Integer; safecall;
    procedure Set_TapiRetryWait(Value: Integer); safecall;
    function  Get_TrimSeconds: Integer; safecall;
    procedure Set_TrimSeconds(Value: Integer); safecall;
    function  Get_UseSoundCard: WordBool; safecall;
    procedure Set_UseSoundCard(Value: WordBool); safecall;
    function  Get_CaptureFile: WideString; safecall;
    procedure Set_CaptureFile(const Value: WideString); safecall;
    function  Get_CaptureMode: TxAdCaptureMode; safecall;
    procedure Set_CaptureMode(Value: TxAdCaptureMode); safecall;
    function  Get_Color: OLE_COLOR; safecall;
    procedure Set_Color(Value: OLE_COLOR); safecall;
    function  Get_Columns: Integer; safecall;
    procedure Set_Columns(Value: Integer); safecall;
    function  Get_Emulation: TxApxTerminalEmulation; safecall;
    procedure Set_Emulation(Value: TxApxTerminalEmulation); safecall;
    function  Get_Font: IFontDisp; safecall;
    procedure _Set_Font(const Value: IFontDisp); safecall;
    procedure Set_Font(var Value: IFontDisp); safecall;
    function  Get_Rows: Integer; safecall;
    procedure Set_Rows(Value: Integer); safecall;
    function  Get_ScrollbackEnabled: WordBool; safecall;
    procedure Set_ScrollbackEnabled(Value: WordBool); safecall;
    function  Get_ScrollbackRows: Integer; safecall;
    procedure Set_ScrollbackRows(Value: Integer); safecall;
    function  Get_TerminalActive: WordBool; safecall;
    procedure Set_TerminalActive(Value: WordBool); safecall;
    function  Get_TerminalBlinkTime: Integer; safecall;
    procedure Set_TerminalBlinkTime(Value: Integer); safecall;
    function  Get_TerminalHalfDuplex: WordBool; safecall;
    procedure Set_TerminalHalfDuplex(Value: WordBool); safecall;
    function  Get_TerminalLazyByteDelay: Integer; safecall;
    procedure Set_TerminalLazyByteDelay(Value: Integer); safecall;
    function  Get_TerminalLazyTimeDelay: Integer; safecall;
    procedure Set_TerminalLazyTimeDelay(Value: Integer); safecall;
    function  Get_TerminalUseLazyDisplay: WordBool; safecall;
    procedure Set_TerminalUseLazyDisplay(Value: WordBool); safecall;
    function  Get_TerminalWantAllKeys: WordBool; safecall;
    procedure Set_TerminalWantAllKeys(Value: WordBool); safecall;
    function  Get_Version: WideString; safecall;
    procedure Set_Version(const Value: WideString); safecall;
    function  Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function  Get_DataTriggerString: WideString; safecall;
    procedure Set_DataTriggerString(const Value: WideString); safecall;
    function  Get_ProtocolStatusDisplay: WordBool; safecall;
    procedure Set_ProtocolStatusDisplay(Value: WordBool); safecall;
    function  Get_Protocol: TxProtocolType; safecall;
    procedure Set_Protocol(Value: TxProtocolType); safecall;
    function  Get_AbortNoCarrier: WordBool; safecall;
    procedure Set_AbortNoCarrier(Value: WordBool); safecall;
    function  Get_AsciiCharDelay: Integer; safecall;
    procedure Set_AsciiCharDelay(Value: Integer); safecall;
    function  Get_AsciiCRTranslation: TxAsciiEOLTranslation; safecall;
    procedure Set_AsciiCRTranslation(Value: TxAsciiEOLTranslation); safecall;
    function  Get_AsciiEOFTimeout: Integer; safecall;
    procedure Set_AsciiEOFTimeout(Value: Integer); safecall;
    function  Get_AsciiEOLChar: Integer; safecall;
    procedure Set_AsciiEOLChar(Value: Integer); safecall;
    function  Get_AsciiLFTranslation: TxAsciiEOLTranslation; safecall;
    procedure Set_AsciiLFTranslation(Value: TxAsciiEOLTranslation); safecall;
    function  Get_AsciiLineDelay: Integer; safecall;
    procedure Set_AsciiLineDelay(Value: Integer); safecall;
    function  Get_AsciiSuppressCtrlZ: WordBool; safecall;
    procedure Set_AsciiSuppressCtrlZ(Value: WordBool); safecall;
    function  Get_BlockCheckMethod: TxBlockCheckMethod; safecall;
    procedure Set_BlockCheckMethod(Value: TxBlockCheckMethod); safecall;
    function  Get_FinishWait: Integer; safecall;
    procedure Set_FinishWait(Value: Integer); safecall;
    function  Get_HandshakeRetry: Integer; safecall;
    procedure Set_HandshakeRetry(Value: Integer); safecall;
    function  Get_HandshakeWait: Integer; safecall;
    procedure Set_HandshakeWait(Value: Integer); safecall;
    function  Get_HonorDirectory: WordBool; safecall;
    procedure Set_HonorDirectory(Value: WordBool); safecall;
    function  Get_IncludeDirectory: WordBool; safecall;
    procedure Set_IncludeDirectory(Value: WordBool); safecall;
    function  Get_KermitCtlPrefix: Integer; safecall;
    procedure Set_KermitCtlPrefix(Value: Integer); safecall;
    function  Get_KermitHighbitPrefix: Integer; safecall;
    procedure Set_KermitHighbitPrefix(Value: Integer); safecall;
    function  Get_KermitMaxLen: Integer; safecall;
    procedure Set_KermitMaxLen(Value: Integer); safecall;
    function  Get_KermitMaxWindows: Integer; safecall;
    procedure Set_KermitMaxWindows(Value: Integer); safecall;
    function  Get_KermitPadCharacter: Integer; safecall;
    procedure Set_KermitPadCharacter(Value: Integer); safecall;
    function  Get_KermitPadCount: Integer; safecall;
    procedure Set_KermitPadCount(Value: Integer); safecall;
    function  Get_KermitRepeatPrefix: Integer; safecall;
    procedure Set_KermitRepeatPrefix(Value: Integer); safecall;
    function  Get_KermitSWCTurnDelay: Integer; safecall;
    procedure Set_KermitSWCTurnDelay(Value: Integer); safecall;
    function  Get_KermitTerminator: Integer; safecall;
    procedure Set_KermitTerminator(Value: Integer); safecall;
    function  Get_KermitTimeoutSecs: Integer; safecall;
    procedure Set_KermitTimeoutSecs(Value: Integer); safecall;
    function  Get_ReceiveDirectory: WideString; safecall;
    procedure Set_ReceiveDirectory(const Value: WideString); safecall;
    function  Get_ReceiveFileName: WideString; safecall;
    procedure Set_ReceiveFileName(const Value: WideString); safecall;
    function  Get_RTSLowForWrite: WordBool; safecall;
    procedure Set_RTSLowForWrite(Value: WordBool); safecall;
    function  Get_SendFileName: WideString; safecall;
    procedure Set_SendFileName(const Value: WideString); safecall;
    function  Get_StatusInterval: Integer; safecall;
    procedure Set_StatusInterval(Value: Integer); safecall;
    function  Get_TransmitTimeout: Integer; safecall;
    procedure Set_TransmitTimeout(Value: Integer); safecall;
    function  Get_UpcaseFileNames: WordBool; safecall;
    procedure Set_UpcaseFileNames(Value: WordBool); safecall;
    function  Get_WriteFailAction: TxWriteFailAction; safecall;
    procedure Set_WriteFailAction(Value: TxWriteFailAction); safecall;
    function  Get_XYmodemBlockWait: Integer; safecall;
    procedure Set_XYmodemBlockWait(Value: Integer); safecall;
    function  Get_Zmodem8K: WordBool; safecall;
    procedure Set_Zmodem8K(Value: WordBool); safecall;
    function  Get_ZmodemFileOptions: TxZmodemFileOptions; safecall;
    procedure Set_ZmodemFileOptions(Value: TxZmodemFileOptions); safecall;
    function  Get_ZmodemFinishRetry: Integer; safecall;
    procedure Set_ZmodemFinishRetry(Value: Integer); safecall;
    function  Get_ZmodemOptionOverride: WordBool; safecall;
    procedure Set_ZmodemOptionOverride(Value: WordBool); safecall;
    function  Get_ZmodemRecover: WordBool; safecall;
    procedure Set_ZmodemRecover(Value: WordBool); safecall;
    function  Get_ZmodemSkipNoFile: WordBool; safecall;
    procedure Set_ZmodemSkipNoFile(Value: WordBool); safecall;
    function  Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function  Get_CaptionAlignment: TxAlignment; safecall;
    procedure Set_CaptionAlignment(Value: TxAlignment); safecall;
    function  Get_CaptionWidth: Integer; safecall;
    procedure Set_CaptionWidth(Value: Integer); safecall;
    function  Get_LightWidth: Integer; safecall;
    procedure Set_LightWidth(Value: Integer); safecall;
    function  Get_LightsLitColor: OLE_COLOR; safecall;
    procedure Set_LightsLitColor(Value: OLE_COLOR); safecall;
    function  Get_LightsNotLitColor: OLE_COLOR; safecall;
    procedure Set_LightsNotLitColor(Value: OLE_COLOR); safecall;
    function  Get_ShowLightCaptions: WordBool; safecall;
    procedure Set_ShowLightCaptions(Value: WordBool); safecall;
    function  Get_ShowLights: WordBool; safecall;
    procedure Set_ShowLights(Value: WordBool); safecall;
    function  Get_ShowStatusBar: WordBool; safecall;
    procedure Set_ShowStatusBar(Value: WordBool); safecall;
    function  Get_ShowToolBar: WordBool; safecall;
    procedure Set_ShowToolBar(Value: WordBool); safecall;
    function  Get_ShowDeviceSelButton: WordBool; safecall;
    procedure Set_ShowDeviceSelButton(Value: WordBool); safecall;
    function  Get_ShowConnectButtons: WordBool; safecall;
    procedure Set_ShowConnectButtons(Value: WordBool); safecall;
    function  Get_ShowProtocolButtons: WordBool; safecall;
    procedure Set_ShowProtocolButtons(Value: WordBool); safecall;
    function  Get_ShowTerminalButtons: WordBool; safecall;
    procedure Set_ShowTerminalButtons(Value: WordBool); safecall;
    function  Get_DoubleBuffered: WordBool; safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    function  Get_VisibleDockClientCount: Integer; safecall;
    function  DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function  Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure InitiateAction; safecall;
    function  IsRightToLeft: WordBool; safecall;
    function  UseRightToLeftReading: WordBool; safecall;
    function  UseRightToLeftScrollBar: WordBool; safecall;
    function  Get_Cursor: Smallint; safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure AboutBox; safecall;
    procedure RemoveAllDataTriggers; safecall;
    function  TapiStatusMsg(Message: Integer; State: Integer; Reason: Integer): WideString; safecall;
    function  Get_TapiStatusDisplay: WordBool; safecall;
    procedure Set_TapiStatusDisplay(Value: WordBool); safecall;
    function  Get_CDHolding: WordBool; safecall;
    function  Get_CommPort: Smallint; safecall;
    procedure Set_CommPort(Value: Smallint); safecall;
    function  Get_CTSHolding: WordBool; safecall;
    function  Get_DSRHolding: WordBool; safecall;
    function  Get_DTREnable: WordBool; safecall;
    procedure Set_DTREnable(Value: WordBool); safecall;
    function  Get_Handshaking: HandshakeConstants; safecall;
    procedure Set_Handshaking(Value: HandshakeConstants); safecall;
    function  Get_InBufferSize: Smallint; safecall;
    procedure Set_InBufferSize(Value: Smallint); safecall;
    function  Get_InBufferCount: Smallint; safecall;
    procedure Set_Break(Param1: WordBool); safecall;
    function  Get_OutBufferSize: Smallint; safecall;
    procedure Set_OutBufferSize(Value: Smallint); safecall;
    function  Get_OutBufferCount: Smallint; safecall;
    function  Get_RTSEnable: WordBool; safecall;
    procedure Set_RTSEnable(Value: WordBool); safecall;
    function  Get_Settings: WideString; safecall;
    procedure Set_Settings(const Value: WideString); safecall;
    procedure Set_Output(Param1: OleVariant); safecall;
    function  Get_Input: OleVariant; safecall;
    function  Get_InputMode: InputModeConstants; safecall;
    procedure Set_InputMode(Value: InputModeConstants); safecall;
    function  Get_InputLen: Smallint; safecall;
    procedure Set_InputLen(Value: Smallint); safecall;
    function  Get_CommEvent: Smallint; safecall;
    function  Get_MSCommCompatible: WordBool; safecall;
    procedure Set_MSCommCompatible(Value: WordBool); safecall;
    function  Get_RTThreshold: Smallint; safecall;
    procedure Set_RTThreshold(Value: Smallint); safecall;
    function  Get_SThreshold: Smallint; safecall;
    procedure Set_SThreshold(Value: Smallint); safecall;
    function  IsPortAvail(ComNumber: Integer): WordBool; safecall;
    function  TapiTranslateDialog(const CanonicalAddr: WideString): WordBool; safecall;
    function  Get_TapiFailCode: Integer; safecall;
    function  ErrorMsg(ErrorCode: Integer): WideString; safecall;
    function  EnumTapiFirst: WideString; safecall;
    function  EnumTapiNext: WideString; safecall;
    function  Get_WsLocalVersion: WideString; safecall;
    function  Get_WsLocalHighVersion: WideString; safecall;
    function  Get_WsLocalDescription: WideString; safecall;
    function  Get_WsLocalSystemStatus: WideString; safecall;
    function  Get_WsLocalMaxSockets: Integer; safecall;
    function  Get_WsLocalHostName: WideString; safecall;
    function  Get_WsLocalAddress: WideString; safecall;
    function  IsPortInstalled(ComNumber: Integer): WordBool; safecall;
    procedure DelayTicks(Ticks: Integer); safecall;
    function  FTPAbort: WordBool; safecall;
    function  Get_FTPAccount: WideString; safecall;
    procedure Set_FTPAccount(const Value: WideString); safecall;
    function  FTPChangeDir(const RemotePathName: WideString): WordBool; safecall;
    function  Get_FTPConnected: WordBool; safecall;
    function  Get_FTPConnectTimeout: Integer; safecall;
    procedure Set_FTPConnectTimeout(Value: Integer); safecall;
    function  FTPCurrentDir: WideString; safecall;
    function  Get_FTPFileLength: Integer; safecall;
    function  FTPDelete(const RemotePathName: WideString): WordBool; safecall;
    function  Get_FTPFileType: TxFTPFileType; safecall;
    procedure Set_FTPFileType(Value: TxFTPFileType); safecall;
    function  FTPHelp(const Command: WideString): WideString; safecall;
    function  Get_FTPInProgress: WordBool; safecall;
    function  FTPListDir(const RemotePathName: WideString; FullList: WordBool): WideString; safecall;
    function  FTPLogIn: WordBool; safecall;
    function  FTPLogOut: WordBool; safecall;
    function  FTPMakeDir(const RemotePathName: WideString): WordBool; safecall;
    function  Get_FTPPassword: WideString; safecall;
    procedure Set_FTPPassword(const Value: WideString); safecall;
    function  FTPRename(const RemotePathName: WideString; const NewPathName: WideString): WordBool; safecall;
    function  Get_FTPRestartAt: Integer; safecall;
    procedure Set_FTPRestartAt(Value: Integer); safecall;
    function  FTPRetrieve(const RemotePathName: WideString; const LocalPathName: WideString; 
                          RetrieveMode: TxFTPRetrieveMode): WordBool; safecall;
    function  FTPSendFTPCommand(const FTPCommand: WideString): WideString; safecall;
    function  Get_FTPServerAddress: WideString; safecall;
    procedure Set_FTPServerAddress(const Value: WideString); safecall;
    function  FTPStatus(const RemotePathName: WideString): WideString; safecall;
    function  FTPStore(const RemotePathName: WideString; const LocalPathName: WideString; 
                       StoreMode: TxFTPStoreMode): WordBool; safecall;
    function  Get_FTPTransferTimeout: Integer; safecall;
    procedure Set_FTPTransferTimeout(Value: Integer); safecall;
    function  Get_FTPUserLoggedIn: WordBool; safecall;
    function  Get_FTPUserName: WideString; safecall;
    procedure Set_FTPUserName(const Value: WideString); safecall;
    function  Get_FTPState: Integer; safecall;
    function  Get_FTPBytesTransferred: Integer; safecall;
    procedure TapiLoadConfig(const RegKey: WideString; const KeyName: WideString); safecall;
    function  GetTapiConfig: OleVariant; safecall;
    procedure SetTapiConfig(Value: OleVariant); safecall;
    procedure TapiSaveConfig(const RegKey: WideString; const KeyName: WideString); safecall;
    function  Get_FilterTapiDevices: WordBool; safecall;
    procedure Set_FilterTapiDevices(Value: WordBool); safecall;
    property CTS: WordBool read Get_CTS;
    property DCD: WordBool read Get_DCD;
    property DSR: WordBool read Get_DSR;
    property FlowState: TxFlowControlState read Get_FlowState;
    property InBuffUsed: Integer read Get_InBuffUsed;
    property InBuffFree: Integer read Get_InBuffFree;
    property LineError: Integer read Get_LineError;
    property OutBuffFree: Integer read Get_OutBuffFree;
    property OutBuffUsed: Integer read Get_OutBuffUsed;
    property RI: WordBool read Get_RI;
    property TapiAttempt: Integer read Get_TapiAttempt;
    property CallerID: WideString read Get_CallerID;
    property TapiCancelled: WordBool read Get_TapiCancelled;
    property Dialing: WordBool read Get_Dialing;
    property TapiState: TxTapiState read Get_TapiState;
    property WaveFileName: WideString read Get_WaveFileName;
    property WaveState: TxWaveState read Get_WaveState;
    property Batch: WordBool read Get_Batch;
    property BlockErrors: Integer read Get_BlockErrors;
    property BlockLength: Integer read Get_BlockLength;
    property BlockNumber: Integer read Get_BlockNumber;
    property BytesRemaining: Integer read Get_BytesRemaining;
    property BytesTransferred: Integer read Get_BytesTransferred;
    property ElapsedTicks: Integer read Get_ElapsedTicks;
    property FileDate: Double read Get_FileDate;
    property FileLength: Integer read Get_FileLength;
    property InProgress: WordBool read Get_InProgress;
    property InitialPosition: Integer read Get_InitialPosition;
    property KermitLongBlocks: WordBool read Get_KermitLongBlocks;
    property KermitWindowsTotal: Integer read Get_KermitWindowsTotal;
    property KermitWindowsUsed: Integer read Get_KermitWindowsUsed;
    property ProtocolStatus: Integer read Get_ProtocolStatus;
    property TotalErrors: Integer read Get_TotalErrors;
    property Baud: Integer read Get_Baud write Set_Baud;
    property ComNumber: Integer read Get_ComNumber write Set_ComNumber;
    property DeviceType: TxApxDeviceType read Get_DeviceType write Set_DeviceType;
    property DataBits: Integer read Get_DataBits write Set_DataBits;
    property DTR: WordBool read Get_DTR write Set_DTR;
    property HWFlowUseDTR: WordBool read Get_HWFlowUseDTR write Set_HWFlowUseDTR;
    property HWFlowUseRTS: WordBool read Get_HWFlowUseRTS write Set_HWFlowUseRTS;
    property HWFlowRequireDSR: WordBool read Get_HWFlowRequireDSR write Set_HWFlowRequireDSR;
    property HWFlowRequireCTS: WordBool read Get_HWFlowRequireCTS write Set_HWFlowRequireCTS;
    property LogAllHex: WordBool read Get_LogAllHex write Set_LogAllHex;
    property Logging: TxTraceLogState read Get_Logging write Set_Logging;
    property LogHex: WordBool read Get_LogHex write Set_LogHex;
    property LogName: WideString read Get_LogName write Set_LogName;
    property LogSize: Integer read Get_LogSize write Set_LogSize;
    property Parity: TxParity read Get_Parity write Set_Parity;
    property PromptForPort: WordBool read Get_PromptForPort write Set_PromptForPort;
    property RS485Mode: WordBool read Get_RS485Mode write Set_RS485Mode;
    property RTS: WordBool read Get_RTS write Set_RTS;
    property StopBits: Integer read Get_StopBits write Set_StopBits;
    property SWFlowOptions: TxSWFlowOptions read Get_SWFlowOptions write Set_SWFlowOptions;
    property XOffChar: Integer read Get_XOffChar write Set_XOffChar;
    property XOnChar: Integer read Get_XOnChar write Set_XOnChar;
    property WinsockMode: TxWsMode read Get_WinsockMode write Set_WinsockMode;
    property WinsockAddress: WideString read Get_WinsockAddress write Set_WinsockAddress;
    property WinsockPort: WideString read Get_WinsockPort write Set_WinsockPort;
    property WsTelnet: WordBool read Get_WsTelnet write Set_WsTelnet;
    property AnswerOnRing: Integer read Get_AnswerOnRing write Set_AnswerOnRing;
    property EnableVoice: WordBool read Get_EnableVoice write Set_EnableVoice;
    property MaxAttempts: Integer read Get_MaxAttempts write Set_MaxAttempts;
    property InterruptWave: WordBool read Get_InterruptWave write Set_InterruptWave;
    property MaxMessageLength: Integer read Get_MaxMessageLength write Set_MaxMessageLength;
    property SelectedDevice: WideString read Get_SelectedDevice write Set_SelectedDevice;
    property SilenceThreshold: Integer read Get_SilenceThreshold write Set_SilenceThreshold;
    property TapiNumber: WideString read Get_TapiNumber write Set_TapiNumber;
    property TapiRetryWait: Integer read Get_TapiRetryWait write Set_TapiRetryWait;
    property TrimSeconds: Integer read Get_TrimSeconds write Set_TrimSeconds;
    property UseSoundCard: WordBool read Get_UseSoundCard write Set_UseSoundCard;
    property CaptureFile: WideString read Get_CaptureFile write Set_CaptureFile;
    property CaptureMode: TxAdCaptureMode read Get_CaptureMode write Set_CaptureMode;
    property Color: OLE_COLOR read Get_Color write Set_Color;
    property Columns: Integer read Get_Columns write Set_Columns;
    property Emulation: TxApxTerminalEmulation read Get_Emulation write Set_Emulation;
    property Font: IFontDisp read Get_Font write _Set_Font;
    property Rows: Integer read Get_Rows write Set_Rows;
    property ScrollbackEnabled: WordBool read Get_ScrollbackEnabled write Set_ScrollbackEnabled;
    property ScrollbackRows: Integer read Get_ScrollbackRows write Set_ScrollbackRows;
    property TerminalActive: WordBool read Get_TerminalActive write Set_TerminalActive;
    property TerminalBlinkTime: Integer read Get_TerminalBlinkTime write Set_TerminalBlinkTime;
    property TerminalHalfDuplex: WordBool read Get_TerminalHalfDuplex write Set_TerminalHalfDuplex;
    property TerminalLazyByteDelay: Integer read Get_TerminalLazyByteDelay write Set_TerminalLazyByteDelay;
    property TerminalLazyTimeDelay: Integer read Get_TerminalLazyTimeDelay write Set_TerminalLazyTimeDelay;
    property TerminalUseLazyDisplay: WordBool read Get_TerminalUseLazyDisplay write Set_TerminalUseLazyDisplay;
    property TerminalWantAllKeys: WordBool read Get_TerminalWantAllKeys write Set_TerminalWantAllKeys;
    property Version: WideString read Get_Version write Set_Version;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property DataTriggerString: WideString read Get_DataTriggerString write Set_DataTriggerString;
    property ProtocolStatusDisplay: WordBool read Get_ProtocolStatusDisplay write Set_ProtocolStatusDisplay;
    property Protocol: TxProtocolType read Get_Protocol write Set_Protocol;
    property AbortNoCarrier: WordBool read Get_AbortNoCarrier write Set_AbortNoCarrier;
    property AsciiCharDelay: Integer read Get_AsciiCharDelay write Set_AsciiCharDelay;
    property AsciiCRTranslation: TxAsciiEOLTranslation read Get_AsciiCRTranslation write Set_AsciiCRTranslation;
    property AsciiEOFTimeout: Integer read Get_AsciiEOFTimeout write Set_AsciiEOFTimeout;
    property AsciiEOLChar: Integer read Get_AsciiEOLChar write Set_AsciiEOLChar;
    property AsciiLFTranslation: TxAsciiEOLTranslation read Get_AsciiLFTranslation write Set_AsciiLFTranslation;
    property AsciiLineDelay: Integer read Get_AsciiLineDelay write Set_AsciiLineDelay;
    property AsciiSuppressCtrlZ: WordBool read Get_AsciiSuppressCtrlZ write Set_AsciiSuppressCtrlZ;
    property BlockCheckMethod: TxBlockCheckMethod read Get_BlockCheckMethod write Set_BlockCheckMethod;
    property FinishWait: Integer read Get_FinishWait write Set_FinishWait;
    property HandshakeRetry: Integer read Get_HandshakeRetry write Set_HandshakeRetry;
    property HandshakeWait: Integer read Get_HandshakeWait write Set_HandshakeWait;
    property HonorDirectory: WordBool read Get_HonorDirectory write Set_HonorDirectory;
    property IncludeDirectory: WordBool read Get_IncludeDirectory write Set_IncludeDirectory;
    property KermitCtlPrefix: Integer read Get_KermitCtlPrefix write Set_KermitCtlPrefix;
    property KermitHighbitPrefix: Integer read Get_KermitHighbitPrefix write Set_KermitHighbitPrefix;
    property KermitMaxLen: Integer read Get_KermitMaxLen write Set_KermitMaxLen;
    property KermitMaxWindows: Integer read Get_KermitMaxWindows write Set_KermitMaxWindows;
    property KermitPadCharacter: Integer read Get_KermitPadCharacter write Set_KermitPadCharacter;
    property KermitPadCount: Integer read Get_KermitPadCount write Set_KermitPadCount;
    property KermitRepeatPrefix: Integer read Get_KermitRepeatPrefix write Set_KermitRepeatPrefix;
    property KermitSWCTurnDelay: Integer read Get_KermitSWCTurnDelay write Set_KermitSWCTurnDelay;
    property KermitTerminator: Integer read Get_KermitTerminator write Set_KermitTerminator;
    property KermitTimeoutSecs: Integer read Get_KermitTimeoutSecs write Set_KermitTimeoutSecs;
    property ReceiveDirectory: WideString read Get_ReceiveDirectory write Set_ReceiveDirectory;
    property ReceiveFileName: WideString read Get_ReceiveFileName write Set_ReceiveFileName;
    property RTSLowForWrite: WordBool read Get_RTSLowForWrite write Set_RTSLowForWrite;
    property SendFileName: WideString read Get_SendFileName write Set_SendFileName;
    property StatusInterval: Integer read Get_StatusInterval write Set_StatusInterval;
    property TransmitTimeout: Integer read Get_TransmitTimeout write Set_TransmitTimeout;
    property UpcaseFileNames: WordBool read Get_UpcaseFileNames write Set_UpcaseFileNames;
    property WriteFailAction: TxWriteFailAction read Get_WriteFailAction write Set_WriteFailAction;
    property XYmodemBlockWait: Integer read Get_XYmodemBlockWait write Set_XYmodemBlockWait;
    property Zmodem8K: WordBool read Get_Zmodem8K write Set_Zmodem8K;
    property ZmodemFileOptions: TxZmodemFileOptions read Get_ZmodemFileOptions write Set_ZmodemFileOptions;
    property ZmodemFinishRetry: Integer read Get_ZmodemFinishRetry write Set_ZmodemFinishRetry;
    property ZmodemOptionOverride: WordBool read Get_ZmodemOptionOverride write Set_ZmodemOptionOverride;
    property ZmodemRecover: WordBool read Get_ZmodemRecover write Set_ZmodemRecover;
    property ZmodemSkipNoFile: WordBool read Get_ZmodemSkipNoFile write Set_ZmodemSkipNoFile;
    property Caption: WideString read Get_Caption write Set_Caption;
    property CaptionAlignment: TxAlignment read Get_CaptionAlignment write Set_CaptionAlignment;
    property CaptionWidth: Integer read Get_CaptionWidth write Set_CaptionWidth;
    property LightWidth: Integer read Get_LightWidth write Set_LightWidth;
    property LightsLitColor: OLE_COLOR read Get_LightsLitColor write Set_LightsLitColor;
    property LightsNotLitColor: OLE_COLOR read Get_LightsNotLitColor write Set_LightsNotLitColor;
    property ShowLightCaptions: WordBool read Get_ShowLightCaptions write Set_ShowLightCaptions;
    property ShowLights: WordBool read Get_ShowLights write Set_ShowLights;
    property ShowStatusBar: WordBool read Get_ShowStatusBar write Set_ShowStatusBar;
    property ShowToolBar: WordBool read Get_ShowToolBar write Set_ShowToolBar;
    property ShowDeviceSelButton: WordBool read Get_ShowDeviceSelButton write Set_ShowDeviceSelButton;
    property ShowConnectButtons: WordBool read Get_ShowConnectButtons write Set_ShowConnectButtons;
    property ShowProtocolButtons: WordBool read Get_ShowProtocolButtons write Set_ShowProtocolButtons;
    property ShowTerminalButtons: WordBool read Get_ShowTerminalButtons write Set_ShowTerminalButtons;
    property DoubleBuffered: WordBool read Get_DoubleBuffered write Set_DoubleBuffered;
    property VisibleDockClientCount: Integer read Get_VisibleDockClientCount;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Cursor: Smallint read Get_Cursor write Set_Cursor;
    property TapiStatusDisplay: WordBool read Get_TapiStatusDisplay write Set_TapiStatusDisplay;
    property CDHolding: WordBool read Get_CDHolding;
    property CommPort: Smallint read Get_CommPort write Set_CommPort;
    property CTSHolding: WordBool read Get_CTSHolding;
    property DSRHolding: WordBool read Get_DSRHolding;
    property DTREnable: WordBool read Get_DTREnable write Set_DTREnable;
    property Handshaking: HandshakeConstants read Get_Handshaking write Set_Handshaking;
    property InBufferSize: Smallint read Get_InBufferSize write Set_InBufferSize;
    property InBufferCount: Smallint read Get_InBufferCount;
    property Break: WordBool write Set_Break;
    property OutBufferSize: Smallint read Get_OutBufferSize write Set_OutBufferSize;
    property OutBufferCount: Smallint read Get_OutBufferCount;
    property RTSEnable: WordBool read Get_RTSEnable write Set_RTSEnable;
    property Settings: WideString read Get_Settings write Set_Settings;
    property Output: OleVariant write Set_Output;
    property Input: OleVariant read Get_Input;
    property InputMode: InputModeConstants read Get_InputMode write Set_InputMode;
    property InputLen: Smallint read Get_InputLen write Set_InputLen;
    property CommEvent: Smallint read Get_CommEvent;
    property MSCommCompatible: WordBool read Get_MSCommCompatible write Set_MSCommCompatible;
    property RTThreshold: Smallint read Get_RTThreshold write Set_RTThreshold;
    property SThreshold: Smallint read Get_SThreshold write Set_SThreshold;
    property TapiFailCode: Integer read Get_TapiFailCode;
    property WsLocalVersion: WideString read Get_WsLocalVersion;
    property WsLocalHighVersion: WideString read Get_WsLocalHighVersion;
    property WsLocalDescription: WideString read Get_WsLocalDescription;
    property WsLocalSystemStatus: WideString read Get_WsLocalSystemStatus;
    property WsLocalMaxSockets: Integer read Get_WsLocalMaxSockets;
    property WsLocalHostName: WideString read Get_WsLocalHostName;
    property WsLocalAddress: WideString read Get_WsLocalAddress;
    property FTPAccount: WideString read Get_FTPAccount write Set_FTPAccount;
    property FTPConnected: WordBool read Get_FTPConnected;
    property FTPConnectTimeout: Integer read Get_FTPConnectTimeout write Set_FTPConnectTimeout;
    property FTPFileLength: Integer read Get_FTPFileLength;
    property FTPFileType: TxFTPFileType read Get_FTPFileType write Set_FTPFileType;
    property FTPInProgress: WordBool read Get_FTPInProgress;
    property FTPPassword: WideString read Get_FTPPassword write Set_FTPPassword;
    property FTPRestartAt: Integer read Get_FTPRestartAt write Set_FTPRestartAt;
    property FTPServerAddress: WideString read Get_FTPServerAddress write Set_FTPServerAddress;
    property FTPTransferTimeout: Integer read Get_FTPTransferTimeout write Set_FTPTransferTimeout;
    property FTPUserLoggedIn: WordBool read Get_FTPUserLoggedIn;
    property FTPUserName: WideString read Get_FTPUserName write Set_FTPUserName;
    property FTPState: Integer read Get_FTPState;
    property FTPBytesTransferred: Integer read Get_FTPBytesTransferred;
    property FilterTapiDevices: WordBool read Get_FilterTapiDevices write Set_FilterTapiDevices;
  end;

// *********************************************************************//
// DispIntf:  IApaxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7147F87B-077B-4796-9C82-C0BA5C846876}
// *********************************************************************//
  IApaxDisp = dispinterface
    ['{7147F87B-077B-4796-9C82-C0BA5C846876}']
    function  PortOpen: Integer; dispid 1;
    function  TapiDial: Integer; dispid 2;
    function  TapiAnswer: Integer; dispid 3;
    function  WinsockConnect: Integer; dispid 4;
    function  WinsockListen: Integer; dispid 5;
    function  Close: Integer; dispid 6;
    procedure AddStringToLog(const S: WideString); dispid 7;
    procedure FlushInBuffer; dispid 8;
    procedure FlushOutBuffer; dispid 9;
    function  PutData(Data: OleVariant): Integer; dispid 10;
    function  PutString(const S: WideString): Integer; dispid 11;
    function  PutStringCRLF(const S: WideString): Integer; dispid 12;
    procedure SendBreak(Ticks: Integer; Yield: WordBool); dispid 13;
    function  AddDataTrigger(const TriggerString: WideString; PacketSize: Integer; 
                             Timeout: Integer; IncludeStrings: WordBool; IgnoreCase: WordBool): Integer; dispid 14;
    procedure DisableDataTrigger(Index: Integer); dispid 15;
    procedure EnableDataTrigger(Index: Integer); dispid 16;
    procedure RemoveDataTrigger(Index: Integer); dispid 17;
    procedure Clear; dispid 18;
    procedure ClearAll; dispid 19;
    procedure CopyToClipboard; dispid 20;
    function  GetAttributes(aRow: Integer; aCol: Integer): Integer; dispid 21;
    procedure SetAttributes(aRow: Integer; aCol: Integer; Value: Integer); dispid 22;
    function  GetLine(Index: Integer): WideString; dispid 23;
    procedure SetLine(Index: Integer; const Value: WideString); dispid 24;
    procedure TerminalSetFocus; dispid 25;
    procedure TerminalWriteString(const S: WideString); dispid 26;
    procedure TerminalWriteStringCRLF(const S: WideString); dispid 27;
    procedure TapiAutoAnswer; dispid 28;
    procedure TapiCancelCall; dispid 29;
    procedure TapiConfigAndOpen; dispid 30;
    function  TapiSelectDevice: WordBool; dispid 31;
    procedure TapiSendTone(const Digits: WideString); dispid 32;
    procedure TapiSetRecordingParams(NumChannels: Integer; NumSamplesPerSecond: Integer; 
                                     NumBitsPerSample: Integer); dispid 33;
    procedure TapiShowConfigDialog(AllowEdit: WordBool); dispid 34;
    procedure TapiPlayWaveFile(const FileName: WideString); dispid 35;
    procedure TapiRecordWaveFile(const FileName: WideString; Overwrite: WordBool); dispid 36;
    procedure TapiStopWaveFile; dispid 37;
    function  TapiTranslatePhoneNo(const CanonicalAddr: WideString): WideString; dispid 38;
    procedure CancelProtocol; dispid 39;
    function  EstimateTransferSecs(Size: Integer): Integer; dispid 40;
    procedure StartTransmit; dispid 41;
    procedure StartReceive; dispid 42;
    property CTS: WordBool readonly dispid 43;
    property DCD: WordBool readonly dispid 44;
    property DSR: WordBool readonly dispid 45;
    property FlowState: TxFlowControlState readonly dispid 46;
    property InBuffUsed: Integer readonly dispid 47;
    property InBuffFree: Integer readonly dispid 48;
    property LineError: Integer readonly dispid 49;
    property OutBuffFree: Integer readonly dispid 50;
    property OutBuffUsed: Integer readonly dispid 51;
    property RI: WordBool readonly dispid 52;
    property TapiAttempt: Integer readonly dispid 53;
    property CallerID: WideString readonly dispid 54;
    property TapiCancelled: WordBool readonly dispid 55;
    property Dialing: WordBool readonly dispid 56;
    property TapiState: TxTapiState readonly dispid 57;
    property WaveFileName: WideString readonly dispid 58;
    property WaveState: TxWaveState readonly dispid 59;
    property Batch: WordBool readonly dispid 60;
    property BlockErrors: Integer readonly dispid 61;
    property BlockLength: Integer readonly dispid 62;
    property BlockNumber: Integer readonly dispid 63;
    property BytesRemaining: Integer readonly dispid 64;
    property BytesTransferred: Integer readonly dispid 65;
    property ElapsedTicks: Integer readonly dispid 66;
    property FileDate: Double readonly dispid 67;
    property FileLength: Integer readonly dispid 68;
    property InProgress: WordBool readonly dispid 69;
    property InitialPosition: Integer readonly dispid 70;
    property KermitLongBlocks: WordBool readonly dispid 71;
    property KermitWindowsTotal: Integer readonly dispid 72;
    property KermitWindowsUsed: Integer readonly dispid 73;
    property ProtocolStatus: Integer readonly dispid 74;
    property TotalErrors: Integer readonly dispid 75;
    property Baud: Integer dispid 76;
    property ComNumber: Integer dispid 77;
    property DeviceType: TxApxDeviceType dispid 78;
    property DataBits: Integer dispid 79;
    property DTR: WordBool dispid 80;
    property HWFlowUseDTR: WordBool dispid 81;
    property HWFlowUseRTS: WordBool dispid 82;
    property HWFlowRequireDSR: WordBool dispid 83;
    property HWFlowRequireCTS: WordBool dispid 84;
    property LogAllHex: WordBool dispid 85;
    property Logging: TxTraceLogState dispid 86;
    property LogHex: WordBool dispid 87;
    property LogName: WideString dispid 88;
    property LogSize: Integer dispid 89;
    property Parity: TxParity dispid 90;
    property PromptForPort: WordBool dispid 91;
    property RS485Mode: WordBool dispid 92;
    property RTS: WordBool dispid 93;
    property StopBits: Integer dispid 94;
    property SWFlowOptions: TxSWFlowOptions dispid 95;
    property XOffChar: Integer dispid 96;
    property XOnChar: Integer dispid 97;
    property WinsockMode: TxWsMode dispid 98;
    property WinsockAddress: WideString dispid 99;
    property WinsockPort: WideString dispid 100;
    property WsTelnet: WordBool dispid 101;
    property AnswerOnRing: Integer dispid 102;
    property EnableVoice: WordBool dispid 103;
    property MaxAttempts: Integer dispid 104;
    property InterruptWave: WordBool dispid 105;
    property MaxMessageLength: Integer dispid 106;
    property SelectedDevice: WideString dispid 107;
    property SilenceThreshold: Integer dispid 108;
    property TapiNumber: WideString dispid 109;
    property TapiRetryWait: Integer dispid 110;
    property TrimSeconds: Integer dispid 111;
    property UseSoundCard: WordBool dispid 112;
    property CaptureFile: WideString dispid 113;
    property CaptureMode: TxAdCaptureMode dispid 114;
    property Color: OLE_COLOR dispid -501;
    property Columns: Integer dispid 115;
    property Emulation: TxApxTerminalEmulation dispid 116;
    property Font: IFontDisp dispid -512;
    property Rows: Integer dispid 117;
    property ScrollbackEnabled: WordBool dispid 118;
    property ScrollbackRows: Integer dispid 119;
    property TerminalActive: WordBool dispid 120;
    property TerminalBlinkTime: Integer dispid 121;
    property TerminalHalfDuplex: WordBool dispid 122;
    property TerminalLazyByteDelay: Integer dispid 123;
    property TerminalLazyTimeDelay: Integer dispid 124;
    property TerminalUseLazyDisplay: WordBool dispid 125;
    property TerminalWantAllKeys: WordBool dispid 126;
    property Version: WideString dispid 127;
    property Visible: WordBool dispid 128;
    property DataTriggerString: WideString dispid 129;
    property ProtocolStatusDisplay: WordBool dispid 130;
    property Protocol: TxProtocolType dispid 131;
    property AbortNoCarrier: WordBool dispid 132;
    property AsciiCharDelay: Integer dispid 133;
    property AsciiCRTranslation: TxAsciiEOLTranslation dispid 134;
    property AsciiEOFTimeout: Integer dispid 135;
    property AsciiEOLChar: Integer dispid 136;
    property AsciiLFTranslation: TxAsciiEOLTranslation dispid 137;
    property AsciiLineDelay: Integer dispid 138;
    property AsciiSuppressCtrlZ: WordBool dispid 139;
    property BlockCheckMethod: TxBlockCheckMethod dispid 140;
    property FinishWait: Integer dispid 141;
    property HandshakeRetry: Integer dispid 142;
    property HandshakeWait: Integer dispid 143;
    property HonorDirectory: WordBool dispid 144;
    property IncludeDirectory: WordBool dispid 145;
    property KermitCtlPrefix: Integer dispid 146;
    property KermitHighbitPrefix: Integer dispid 147;
    property KermitMaxLen: Integer dispid 148;
    property KermitMaxWindows: Integer dispid 149;
    property KermitPadCharacter: Integer dispid 150;
    property KermitPadCount: Integer dispid 151;
    property KermitRepeatPrefix: Integer dispid 152;
    property KermitSWCTurnDelay: Integer dispid 153;
    property KermitTerminator: Integer dispid 154;
    property KermitTimeoutSecs: Integer dispid 155;
    property ReceiveDirectory: WideString dispid 156;
    property ReceiveFileName: WideString dispid 157;
    property RTSLowForWrite: WordBool dispid 158;
    property SendFileName: WideString dispid 159;
    property StatusInterval: Integer dispid 160;
    property TransmitTimeout: Integer dispid 161;
    property UpcaseFileNames: WordBool dispid 162;
    property WriteFailAction: TxWriteFailAction dispid 163;
    property XYmodemBlockWait: Integer dispid 164;
    property Zmodem8K: WordBool dispid 165;
    property ZmodemFileOptions: TxZmodemFileOptions dispid 166;
    property ZmodemFinishRetry: Integer dispid 167;
    property ZmodemOptionOverride: WordBool dispid 168;
    property ZmodemRecover: WordBool dispid 169;
    property ZmodemSkipNoFile: WordBool dispid 170;
    property Caption: WideString dispid -518;
    property CaptionAlignment: TxAlignment dispid 171;
    property CaptionWidth: Integer dispid 172;
    property LightWidth: Integer dispid 173;
    property LightsLitColor: OLE_COLOR dispid 174;
    property LightsNotLitColor: OLE_COLOR dispid 175;
    property ShowLightCaptions: WordBool dispid 176;
    property ShowLights: WordBool dispid 177;
    property ShowStatusBar: WordBool dispid 178;
    property ShowToolBar: WordBool dispid 179;
    property ShowDeviceSelButton: WordBool dispid 180;
    property ShowConnectButtons: WordBool dispid 181;
    property ShowProtocolButtons: WordBool dispid 182;
    property ShowTerminalButtons: WordBool dispid 183;
    property DoubleBuffered: WordBool dispid 184;
    property VisibleDockClientCount: Integer readonly dispid 185;
    function  DrawTextBiDiModeFlagsReadingOnly: Integer; dispid 187;
    property Enabled: WordBool dispid -514;
    procedure InitiateAction; dispid 188;
    function  IsRightToLeft: WordBool; dispid 189;
    function  UseRightToLeftReading: WordBool; dispid 192;
    function  UseRightToLeftScrollBar: WordBool; dispid 193;
    property Cursor: Smallint dispid 194;
    procedure AboutBox; dispid -552;
    procedure RemoveAllDataTriggers; dispid 186;
    function  TapiStatusMsg(Message: Integer; State: Integer; Reason: Integer): WideString; dispid 190;
    property TapiStatusDisplay: WordBool dispid 191;
    property CDHolding: WordBool readonly dispid 195;
    property CommPort: Smallint dispid 196;
    property CTSHolding: WordBool readonly dispid 197;
    property DSRHolding: WordBool readonly dispid 198;
    property DTREnable: WordBool dispid 199;
    property Handshaking: HandshakeConstants dispid 200;
    property InBufferSize: Smallint dispid 201;
    property InBufferCount: Smallint readonly dispid 202;
    property Break: WordBool writeonly dispid 203;
    property OutBufferSize: Smallint dispid 204;
    property OutBufferCount: Smallint readonly dispid 205;
    property RTSEnable: WordBool dispid 207;
    property Settings: WideString dispid 208;
    property Output: OleVariant writeonly dispid 209;
    property Input: OleVariant readonly dispid 210;
    property InputMode: InputModeConstants dispid 211;
    property InputLen: Smallint dispid 212;
    property CommEvent: Smallint readonly dispid 213;
    property MSCommCompatible: WordBool dispid 206;
    property RTThreshold: Smallint dispid 214;
    property SThreshold: Smallint dispid 215;
    function  IsPortAvail(ComNumber: Integer): WordBool; dispid 220;
    function  TapiTranslateDialog(const CanonicalAddr: WideString): WordBool; dispid 221;
    property TapiFailCode: Integer readonly dispid 222;
    function  ErrorMsg(ErrorCode: Integer): WideString; dispid 217;
    function  EnumTapiFirst: WideString; dispid 218;
    function  EnumTapiNext: WideString; dispid 219;
    property WsLocalVersion: WideString readonly dispid 216;
    property WsLocalHighVersion: WideString readonly dispid 223;
    property WsLocalDescription: WideString readonly dispid 224;
    property WsLocalSystemStatus: WideString readonly dispid 225;
    property WsLocalMaxSockets: Integer readonly dispid 226;
    property WsLocalHostName: WideString readonly dispid 227;
    property WsLocalAddress: WideString readonly dispid 228;
    function  IsPortInstalled(ComNumber: Integer): WordBool; dispid 229;
    procedure DelayTicks(Ticks: Integer); dispid 230;
    function  FTPAbort: WordBool; dispid 231;
    property FTPAccount: WideString dispid 233;
    function  FTPChangeDir(const RemotePathName: WideString): WordBool; dispid 234;
    property FTPConnected: WordBool readonly dispid 235;
    property FTPConnectTimeout: Integer dispid 236;
    function  FTPCurrentDir: WideString; dispid 237;
    property FTPFileLength: Integer readonly dispid 239;
    function  FTPDelete(const RemotePathName: WideString): WordBool; dispid 238;
    property FTPFileType: TxFTPFileType dispid 240;
    function  FTPHelp(const Command: WideString): WideString; dispid 241;
    property FTPInProgress: WordBool readonly dispid 232;
    function  FTPListDir(const RemotePathName: WideString; FullList: WordBool): WideString; dispid 242;
    function  FTPLogIn: WordBool; dispid 243;
    function  FTPLogOut: WordBool; dispid 244;
    function  FTPMakeDir(const RemotePathName: WideString): WordBool; dispid 245;
    property FTPPassword: WideString dispid 246;
    function  FTPRename(const RemotePathName: WideString; const NewPathName: WideString): WordBool; dispid 247;
    property FTPRestartAt: Integer dispid 248;
    function  FTPRetrieve(const RemotePathName: WideString; const LocalPathName: WideString; 
                          RetrieveMode: TxFTPRetrieveMode): WordBool; dispid 249;
    function  FTPSendFTPCommand(const FTPCommand: WideString): WideString; dispid 250;
    property FTPServerAddress: WideString dispid 251;
    function  FTPStatus(const RemotePathName: WideString): WideString; dispid 252;
    function  FTPStore(const RemotePathName: WideString; const LocalPathName: WideString; 
                       StoreMode: TxFTPStoreMode): WordBool; dispid 253;
    property FTPTransferTimeout: Integer dispid 254;
    property FTPUserLoggedIn: WordBool readonly dispid 255;
    property FTPUserName: WideString dispid 256;
    property FTPState: Integer readonly dispid 257;
    property FTPBytesTransferred: Integer readonly dispid 259;
    procedure TapiLoadConfig(const RegKey: WideString; const KeyName: WideString); dispid 258;
    function  GetTapiConfig: OleVariant; dispid 261;
    procedure SetTapiConfig(Value: OleVariant); dispid 263;
    procedure TapiSaveConfig(const RegKey: WideString; const KeyName: WideString); dispid 264;
    property FilterTapiDevices: WordBool dispid 260;
  end;

// *********************************************************************//
// DispIntf:  IApaxEvents
// Flags:     (4096) Dispatchable
// GUID:      {EB835ACB-DEA7-4527-92BA-2BE7FBEFAFB5}
// *********************************************************************//
  IApaxEvents = dispinterface
    ['{EB835ACB-DEA7-4527-92BA-2BE7FBEFAFB5}']
    procedure OnCTSChanged(NewValue: WordBool); dispid 1;
    procedure OnDCDChanged(NewValue: WordBool); dispid 2;
    procedure OnDSRChanged(NewValue: WordBool); dispid 3;
    procedure OnLineBreak; dispid 4;
    procedure OnLineError; dispid 5;
    procedure OnPortClose; dispid 6;
    procedure OnPortOpen; dispid 7;
    procedure OnRing; dispid 8;
    procedure OnRXD(Data: OleVariant); dispid 9;
    procedure OnWinsockAccept(const Addr: WideString; var Accept: WordBool); dispid 10;
    procedure OnWinsockConnect; dispid 11;
    procedure OnWinsockDisconnect; dispid 12;
    procedure OnWinsockError(ErrCode: Integer); dispid 13;
    procedure OnWinsockGetAddress(var Address: WideString; var Port: WideString); dispid 14;
    procedure OnDataTrigger(Index: Integer; Timeout: WordBool; Data: OleVariant; Size: Integer; 
                            var ReEnable: WordBool); dispid 15;
    procedure OnTapiCallerID(const ID: WideString; const IDName: WideString); dispid 16;
    procedure OnTapiConnect; dispid 17;
    procedure OnTapiDTMF(Digit: Byte; ErrorCode: Integer); dispid 18;
    procedure OnTapiFail; dispid 19;
    procedure OnTapiGetNumber(var PhoneNum: WideString); dispid 20;
    procedure OnTapiPortClose; dispid 21;
    procedure OnTapiPortOpen; dispid 22;
    procedure OnTapiStatus(First: WordBool; Last: WordBool; Device: Integer; Message: Integer; 
                           Param1: Integer; Param2: Integer; Param3: Integer); dispid 23;
    procedure OnTapiWaveNotify(Msg: TxWaveMessage); dispid 24;
    procedure OnTapiWaveSilence(var StopRecording: WordBool; var Hangup: WordBool); dispid 25;
    procedure OnCursorMoved(aRow: Integer; aCol: Integer); dispid 26;
    procedure OnProtocolAccept(var Accept: WordBool; var FName: WideString); dispid 27;
    procedure OnProtocolFinish(ErrorCode: Integer); dispid 28;
    procedure OnProtocolLog(Log: Integer); dispid 29;
    procedure OnProtocolStatus(Options: Integer); dispid 30;
    procedure OnConnectButtonClick(var Default: WordBool); dispid 31;
    procedure OnListenButtonClick(var Default: WordBool); dispid 32;
    procedure OnCloseButtonClick(var Default: WordBool); dispid 33;
    procedure OnDeviceButtonClick(DeviceType: TxApxDeviceType); dispid 34;
    procedure OnSendButtonClick(var Default: WordBool); dispid 35;
    procedure OnReceiveButtonClick(var Default: WordBool); dispid 36;
    procedure OnFontButtonClick(var Default: WordBool); dispid 37;
    procedure OnComm; dispid 38;
    procedure OnEmulationButtonClick(Emulation: TxApxTerminalEmulation); dispid 39;
    procedure OnFTPError(ErrorCode: Integer; const ErrorText: WideString); dispid 40;
    procedure OnFTPLog(LogCode: TxFTPLogCode); dispid 41;
    procedure OnFTPReply(ReplyCode: Integer; const ReplyText: WideString); dispid 42;
    procedure OnFTPStatus(StatusCode: TxFTPStatusCode; const InfoText: WideString); dispid 43;
    procedure OnProcessChar(CharSource: TxCharSource; Character: Byte; var ReplaceWith: WideString); dispid 44;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TApax
// Help String      : Apax Control
// Default Interface: IApax
// Def. Intf. DISP? : No
// Event   Interface: IApaxEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TApaxOnCTSChanged = procedure(Sender: TObject; NewValue: WordBool) of object;
  TApaxOnDCDChanged = procedure(Sender: TObject; NewValue: WordBool) of object;
  TApaxOnDSRChanged = procedure(Sender: TObject; NewValue: WordBool) of object;
  TApaxOnRXD = procedure(Sender: TObject; Data: OleVariant) of object;
  TApaxOnWinsockAccept = procedure(Sender: TObject; const Addr: WideString; var Accept: WordBool) of object;
  TApaxOnWinsockError = procedure(Sender: TObject; ErrCode: Integer) of object;
  TApaxOnWinsockGetAddress = procedure(Sender: TObject; var Address: WideString; 
                                                        var Port: WideString) of object;
  TApaxOnDataTrigger = procedure(Sender: TObject; Index: Integer; Timeout: WordBool; 
                                                  Data: OleVariant; Size: Integer; 
                                                  var ReEnable: WordBool) of object;
  TApaxOnTapiCallerID = procedure(Sender: TObject; const ID: WideString; const IDName: WideString) of object;
  TApaxOnTapiDTMF = procedure(Sender: TObject; Digit: Byte; ErrorCode: Integer) of object;
  TApaxOnTapiGetNumber = procedure(Sender: TObject; var PhoneNum: WideString) of object;
  TApaxOnTapiStatus = procedure(Sender: TObject; First: WordBool; Last: WordBool; Device: Integer; 
                                                 Message: Integer; Param1: Integer; 
                                                 Param2: Integer; Param3: Integer) of object;
  TApaxOnTapiWaveNotify = procedure(Sender: TObject; Msg: TxWaveMessage) of object;
  TApaxOnTapiWaveSilence = procedure(Sender: TObject; var StopRecording: WordBool; 
                                                      var Hangup: WordBool) of object;
  TApaxOnCursorMoved = procedure(Sender: TObject; aRow: Integer; aCol: Integer) of object;
  TApaxOnProtocolAccept = procedure(Sender: TObject; var Accept: WordBool; var FName: WideString) of object;
  TApaxOnProtocolFinish = procedure(Sender: TObject; ErrorCode: Integer) of object;
  TApaxOnProtocolLog = procedure(Sender: TObject; Log: Integer) of object;
  TApaxOnProtocolStatus = procedure(Sender: TObject; Options: Integer) of object;
  TApaxOnConnectButtonClick = procedure(Sender: TObject; var Default: WordBool) of object;
  TApaxOnListenButtonClick = procedure(Sender: TObject; var Default: WordBool) of object;
  TApaxOnCloseButtonClick = procedure(Sender: TObject; var Default: WordBool) of object;
  TApaxOnDeviceButtonClick = procedure(Sender: TObject; DeviceType: TxApxDeviceType) of object;
  TApaxOnSendButtonClick = procedure(Sender: TObject; var Default: WordBool) of object;
  TApaxOnReceiveButtonClick = procedure(Sender: TObject; var Default: WordBool) of object;
  TApaxOnFontButtonClick = procedure(Sender: TObject; var Default: WordBool) of object;
  TApaxOnEmulationButtonClick = procedure(Sender: TObject; Emulation: TxApxTerminalEmulation) of object;
  TApaxOnFTPError = procedure(Sender: TObject; ErrorCode: Integer; const ErrorText: WideString) of object;
  TApaxOnFTPLog = procedure(Sender: TObject; LogCode: TxFTPLogCode) of object;
  TApaxOnFTPReply = procedure(Sender: TObject; ReplyCode: Integer; const ReplyText: WideString) of object;
  TApaxOnFTPStatus = procedure(Sender: TObject; StatusCode: TxFTPStatusCode; 
                                                const InfoText: WideString) of object;
  TApaxOnProcessChar = procedure(Sender: TObject; CharSource: TxCharSource; Character: Byte; 
                                                  var ReplaceWith: WideString) of object;

  TApax = class(TOleControl)
  private
    FOnCTSChanged: TApaxOnCTSChanged;
    FOnDCDChanged: TApaxOnDCDChanged;
    FOnDSRChanged: TApaxOnDSRChanged;
    FOnLineBreak: TNotifyEvent;
    FOnLineError: TNotifyEvent;
    FOnPortClose: TNotifyEvent;
    FOnPortOpen: TNotifyEvent;
    FOnRing: TNotifyEvent;
    FOnRXD: TApaxOnRXD;
    FOnWinsockAccept: TApaxOnWinsockAccept;
    FOnWinsockConnect: TNotifyEvent;
    FOnWinsockDisconnect: TNotifyEvent;
    FOnWinsockError: TApaxOnWinsockError;
    FOnWinsockGetAddress: TApaxOnWinsockGetAddress;
    FOnDataTrigger: TApaxOnDataTrigger;
    FOnTapiCallerID: TApaxOnTapiCallerID;
    FOnTapiConnect: TNotifyEvent;
    FOnTapiDTMF: TApaxOnTapiDTMF;
    FOnTapiFail: TNotifyEvent;
    FOnTapiGetNumber: TApaxOnTapiGetNumber;
    FOnTapiPortClose: TNotifyEvent;
    FOnTapiPortOpen: TNotifyEvent;
    FOnTapiStatus: TApaxOnTapiStatus;
    FOnTapiWaveNotify: TApaxOnTapiWaveNotify;
    FOnTapiWaveSilence: TApaxOnTapiWaveSilence;
    FOnCursorMoved: TApaxOnCursorMoved;
    FOnProtocolAccept: TApaxOnProtocolAccept;
    FOnProtocolFinish: TApaxOnProtocolFinish;
    FOnProtocolLog: TApaxOnProtocolLog;
    FOnProtocolStatus: TApaxOnProtocolStatus;
    FOnConnectButtonClick: TApaxOnConnectButtonClick;
    FOnListenButtonClick: TApaxOnListenButtonClick;
    FOnCloseButtonClick: TApaxOnCloseButtonClick;
    FOnDeviceButtonClick: TApaxOnDeviceButtonClick;
    FOnSendButtonClick: TApaxOnSendButtonClick;
    FOnReceiveButtonClick: TApaxOnReceiveButtonClick;
    FOnFontButtonClick: TApaxOnFontButtonClick;
    FOnComm: TNotifyEvent;
    FOnEmulationButtonClick: TApaxOnEmulationButtonClick;
    FOnFTPError: TApaxOnFTPError;
    FOnFTPLog: TApaxOnFTPLog;
    FOnFTPReply: TApaxOnFTPReply;
    FOnFTPStatus: TApaxOnFTPStatus;
    FOnProcessChar: TApaxOnProcessChar;
    FIntf: IApax;
    function  GetControlInterface: IApax;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    procedure Set_Output(Param1: OleVariant);
    function  Get_Input: OleVariant;
  public
    function  PortOpen: Integer;
    function  TapiDial: Integer;
    function  TapiAnswer: Integer;
    function  WinsockConnect: Integer;
    function  WinsockListen: Integer;
    function  Close: Integer;
    procedure AddStringToLog(const S: WideString);
    procedure FlushInBuffer;
    procedure FlushOutBuffer;
    function  PutData(Data: OleVariant): Integer;
    function  PutString(const S: WideString): Integer;
    function  PutStringCRLF(const S: WideString): Integer;
    procedure SendBreak(Ticks: Integer; Yield: WordBool);
    function  AddDataTrigger(const TriggerString: WideString; PacketSize: Integer; 
                             Timeout: Integer; IncludeStrings: WordBool; IgnoreCase: WordBool): Integer;
    procedure DisableDataTrigger(Index: Integer);
    procedure EnableDataTrigger(Index: Integer);
    procedure RemoveDataTrigger(Index: Integer);
    procedure Clear;
    procedure ClearAll;
    procedure CopyToClipboard;
    function  GetAttributes(aRow: Integer; aCol: Integer): Integer;
    procedure SetAttributes(aRow: Integer; aCol: Integer; Value: Integer);
    function  GetLine(Index: Integer): WideString;
    procedure SetLine(Index: Integer; const Value: WideString);
    procedure TerminalSetFocus;
    procedure TerminalWriteString(const S: WideString);
    procedure TerminalWriteStringCRLF(const S: WideString);
    procedure TapiAutoAnswer;
    procedure TapiCancelCall;
    procedure TapiConfigAndOpen;
    function  TapiSelectDevice: WordBool;
    procedure TapiSendTone(const Digits: WideString);
    procedure TapiSetRecordingParams(NumChannels: Integer; NumSamplesPerSecond: Integer; 
                                     NumBitsPerSample: Integer);
    procedure TapiShowConfigDialog(AllowEdit: WordBool);
    procedure TapiPlayWaveFile(const FileName: WideString);
    procedure TapiRecordWaveFile(const FileName: WideString; Overwrite: WordBool);
    procedure TapiStopWaveFile;
    function  TapiTranslatePhoneNo(const CanonicalAddr: WideString): WideString;
    procedure CancelProtocol;
    function  EstimateTransferSecs(Size: Integer): Integer;
    procedure StartTransmit;
    procedure StartReceive;
    function  DrawTextBiDiModeFlagsReadingOnly: Integer;
    procedure InitiateAction;
    function  IsRightToLeft: WordBool;
    function  UseRightToLeftReading: WordBool;
    function  UseRightToLeftScrollBar: WordBool;
    procedure AboutBox;
    procedure RemoveAllDataTriggers;
    function  TapiStatusMsg(Message: Integer; State: Integer; Reason: Integer): WideString;
    function  IsPortAvail(ComNumber: Integer): WordBool;
    function  TapiTranslateDialog(const CanonicalAddr: WideString): WordBool;
    function  ErrorMsg(ErrorCode: Integer): WideString;
    function  EnumTapiFirst: WideString;
    function  EnumTapiNext: WideString;
    function  IsPortInstalled(ComNumber: Integer): WordBool;
    procedure DelayTicks(Ticks: Integer);
    function  FTPAbort: WordBool;
    function  FTPChangeDir(const RemotePathName: WideString): WordBool;
    function  FTPCurrentDir: WideString;
    function  FTPDelete(const RemotePathName: WideString): WordBool;
    function  FTPHelp(const Command: WideString): WideString;
    function  FTPListDir(const RemotePathName: WideString; FullList: WordBool): WideString;
    function  FTPLogIn: WordBool;
    function  FTPLogOut: WordBool;
    function  FTPMakeDir(const RemotePathName: WideString): WordBool;
    function  FTPRename(const RemotePathName: WideString; const NewPathName: WideString): WordBool;
    function  FTPRetrieve(const RemotePathName: WideString; const LocalPathName: WideString; 
                          RetrieveMode: TxFTPRetrieveMode): WordBool;
    function  FTPSendFTPCommand(const FTPCommand: WideString): WideString;
    function  FTPStatus(const RemotePathName: WideString): WideString;
    function  FTPStore(const RemotePathName: WideString; const LocalPathName: WideString; 
                       StoreMode: TxFTPStoreMode): WordBool;
    procedure TapiLoadConfig(const RegKey: WideString; const KeyName: WideString);
    function  GetTapiConfig: OleVariant;
    procedure SetTapiConfig(Value: OleVariant);
    procedure TapiSaveConfig(const RegKey: WideString; const KeyName: WideString);
    property  ControlInterface: IApax read GetControlInterface;
    property  DefaultInterface: IApax read GetControlInterface;
    property CTS: WordBool index 43 read GetWordBoolProp;
    property DCD: WordBool index 44 read GetWordBoolProp;
    property DSR: WordBool index 45 read GetWordBoolProp;
    property FlowState: TOleEnum index 46 read GetTOleEnumProp;
    property InBuffUsed: Integer index 47 read GetIntegerProp;
    property InBuffFree: Integer index 48 read GetIntegerProp;
    property LineError: Integer index 49 read GetIntegerProp;
    property OutBuffFree: Integer index 50 read GetIntegerProp;
    property OutBuffUsed: Integer index 51 read GetIntegerProp;
    property RI: WordBool index 52 read GetWordBoolProp;
    property TapiAttempt: Integer index 53 read GetIntegerProp;
    property CallerID: WideString index 54 read GetWideStringProp;
    property TapiCancelled: WordBool index 55 read GetWordBoolProp;
    property Dialing: WordBool index 56 read GetWordBoolProp;
    property TapiState: TOleEnum index 57 read GetTOleEnumProp;
    property WaveFileName: WideString index 58 read GetWideStringProp;
    property WaveState: TOleEnum index 59 read GetTOleEnumProp;
    property Batch: WordBool index 60 read GetWordBoolProp;
    property BlockErrors: Integer index 61 read GetIntegerProp;
    property BlockLength: Integer index 62 read GetIntegerProp;
    property BlockNumber: Integer index 63 read GetIntegerProp;
    property BytesRemaining: Integer index 64 read GetIntegerProp;
    property BytesTransferred: Integer index 65 read GetIntegerProp;
    property ElapsedTicks: Integer index 66 read GetIntegerProp;
    property FileDate: Double index 67 read GetDoubleProp;
    property FileLength: Integer index 68 read GetIntegerProp;
    property InProgress: WordBool index 69 read GetWordBoolProp;
    property InitialPosition: Integer index 70 read GetIntegerProp;
    property KermitLongBlocks: WordBool index 71 read GetWordBoolProp;
    property KermitWindowsTotal: Integer index 72 read GetIntegerProp;
    property KermitWindowsUsed: Integer index 73 read GetIntegerProp;
    property ProtocolStatus: Integer index 74 read GetIntegerProp;
    property TotalErrors: Integer index 75 read GetIntegerProp;
    property DoubleBuffered: WordBool index 184 read GetWordBoolProp write SetWordBoolProp;
    property VisibleDockClientCount: Integer index 185 read GetIntegerProp;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp;
    property CDHolding: WordBool index 195 read GetWordBoolProp;
    property CTSHolding: WordBool index 197 read GetWordBoolProp;
    property DSRHolding: WordBool index 198 read GetWordBoolProp;
    property InBufferCount: Smallint index 202 read GetSmallintProp;
    property Break: WordBool index 203 write SetWordBoolProp;
    property OutBufferCount: Smallint index 205 read GetSmallintProp;
    property Output: OleVariant index 209 write SetOleVariantProp;
    property Input: OleVariant index 210 read GetOleVariantProp;
    property CommEvent: Smallint index 213 read GetSmallintProp;
    property TapiFailCode: Integer index 222 read GetIntegerProp;
    property WsLocalVersion: WideString index 216 read GetWideStringProp;
    property WsLocalHighVersion: WideString index 223 read GetWideStringProp;
    property WsLocalDescription: WideString index 224 read GetWideStringProp;
    property WsLocalSystemStatus: WideString index 225 read GetWideStringProp;
    property WsLocalMaxSockets: Integer index 226 read GetIntegerProp;
    property WsLocalHostName: WideString index 227 read GetWideStringProp;
    property WsLocalAddress: WideString index 228 read GetWideStringProp;
    property FTPConnected: WordBool index 235 read GetWordBoolProp;
    property FTPFileLength: Integer index 239 read GetIntegerProp;
    property FTPInProgress: WordBool index 232 read GetWordBoolProp;
    property FTPUserLoggedIn: WordBool index 255 read GetWordBoolProp;
    property FTPState: Integer index 257 read GetIntegerProp;
    property FTPBytesTransferred: Integer index 259 read GetIntegerProp;
  published
    property  ParentColor;
    property  ParentFont;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property Baud: Integer index 76 read GetIntegerProp write SetIntegerProp stored False;
    property ComNumber: Integer index 77 read GetIntegerProp write SetIntegerProp stored False;
    property DeviceType: TOleEnum index 78 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property DataBits: Integer index 79 read GetIntegerProp write SetIntegerProp stored False;
    property DTR: WordBool index 80 read GetWordBoolProp write SetWordBoolProp stored False;
    property HWFlowUseDTR: WordBool index 81 read GetWordBoolProp write SetWordBoolProp stored False;
    property HWFlowUseRTS: WordBool index 82 read GetWordBoolProp write SetWordBoolProp stored False;
    property HWFlowRequireDSR: WordBool index 83 read GetWordBoolProp write SetWordBoolProp stored False;
    property HWFlowRequireCTS: WordBool index 84 read GetWordBoolProp write SetWordBoolProp stored False;
    property LogAllHex: WordBool index 85 read GetWordBoolProp write SetWordBoolProp stored False;
    property Logging: TOleEnum index 86 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property LogHex: WordBool index 87 read GetWordBoolProp write SetWordBoolProp stored False;
    property LogName: WideString index 88 read GetWideStringProp write SetWideStringProp stored False;
    property LogSize: Integer index 89 read GetIntegerProp write SetIntegerProp stored False;
    property Parity: TOleEnum index 90 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property PromptForPort: WordBool index 91 read GetWordBoolProp write SetWordBoolProp stored False;
    property RS485Mode: WordBool index 92 read GetWordBoolProp write SetWordBoolProp stored False;
    property RTS: WordBool index 93 read GetWordBoolProp write SetWordBoolProp stored False;
    property StopBits: Integer index 94 read GetIntegerProp write SetIntegerProp stored False;
    property SWFlowOptions: TOleEnum index 95 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property XOffChar: Integer index 96 read GetIntegerProp write SetIntegerProp stored False;
    property XOnChar: Integer index 97 read GetIntegerProp write SetIntegerProp stored False;
    property WinsockMode: TOleEnum index 98 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property WinsockAddress: WideString index 99 read GetWideStringProp write SetWideStringProp stored False;
    property WinsockPort: WideString index 100 read GetWideStringProp write SetWideStringProp stored False;
    property WsTelnet: WordBool index 101 read GetWordBoolProp write SetWordBoolProp stored False;
    property AnswerOnRing: Integer index 102 read GetIntegerProp write SetIntegerProp stored False;
    property EnableVoice: WordBool index 103 read GetWordBoolProp write SetWordBoolProp stored False;
    property MaxAttempts: Integer index 104 read GetIntegerProp write SetIntegerProp stored False;
    property InterruptWave: WordBool index 105 read GetWordBoolProp write SetWordBoolProp stored False;
    property MaxMessageLength: Integer index 106 read GetIntegerProp write SetIntegerProp stored False;
    property SelectedDevice: WideString index 107 read GetWideStringProp write SetWideStringProp stored False;
    property SilenceThreshold: Integer index 108 read GetIntegerProp write SetIntegerProp stored False;
    property TapiNumber: WideString index 109 read GetWideStringProp write SetWideStringProp stored False;
    property TapiRetryWait: Integer index 110 read GetIntegerProp write SetIntegerProp stored False;
    property TrimSeconds: Integer index 111 read GetIntegerProp write SetIntegerProp stored False;
    property UseSoundCard: WordBool index 112 read GetWordBoolProp write SetWordBoolProp stored False;
    property CaptureFile: WideString index 113 read GetWideStringProp write SetWideStringProp stored False;
    property CaptureMode: TOleEnum index 114 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Color: TColor index -501 read GetTColorProp write SetTColorProp stored False;
    property Columns: Integer index 115 read GetIntegerProp write SetIntegerProp stored False;
    property Emulation: TOleEnum index 116 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Font: TFont index -512 read GetTFontProp write SetTFontProp stored False;
    property Rows: Integer index 117 read GetIntegerProp write SetIntegerProp stored False;
    property ScrollbackEnabled: WordBool index 118 read GetWordBoolProp write SetWordBoolProp stored False;
    property ScrollbackRows: Integer index 119 read GetIntegerProp write SetIntegerProp stored False;
    property TerminalActive: WordBool index 120 read GetWordBoolProp write SetWordBoolProp stored False;
    property TerminalBlinkTime: Integer index 121 read GetIntegerProp write SetIntegerProp stored False;
    property TerminalHalfDuplex: WordBool index 122 read GetWordBoolProp write SetWordBoolProp stored False;
    property TerminalLazyByteDelay: Integer index 123 read GetIntegerProp write SetIntegerProp stored False;
    property TerminalLazyTimeDelay: Integer index 124 read GetIntegerProp write SetIntegerProp stored False;
    property TerminalUseLazyDisplay: WordBool index 125 read GetWordBoolProp write SetWordBoolProp stored False;
    property TerminalWantAllKeys: WordBool index 126 read GetWordBoolProp write SetWordBoolProp stored False;
    property Version: WideString index 127 read GetWideStringProp write SetWideStringProp stored False;
    property Visible: WordBool index 128 read GetWordBoolProp write SetWordBoolProp stored False;
    property DataTriggerString: WideString index 129 read GetWideStringProp write SetWideStringProp stored False;
    property ProtocolStatusDisplay: WordBool index 130 read GetWordBoolProp write SetWordBoolProp stored False;
    property Protocol: TOleEnum index 131 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AbortNoCarrier: WordBool index 132 read GetWordBoolProp write SetWordBoolProp stored False;
    property AsciiCharDelay: Integer index 133 read GetIntegerProp write SetIntegerProp stored False;
    property AsciiCRTranslation: TOleEnum index 134 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AsciiEOFTimeout: Integer index 135 read GetIntegerProp write SetIntegerProp stored False;
    property AsciiEOLChar: Integer index 136 read GetIntegerProp write SetIntegerProp stored False;
    property AsciiLFTranslation: TOleEnum index 137 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AsciiLineDelay: Integer index 138 read GetIntegerProp write SetIntegerProp stored False;
    property AsciiSuppressCtrlZ: WordBool index 139 read GetWordBoolProp write SetWordBoolProp stored False;
    property BlockCheckMethod: TOleEnum index 140 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property FinishWait: Integer index 141 read GetIntegerProp write SetIntegerProp stored False;
    property HandshakeRetry: Integer index 142 read GetIntegerProp write SetIntegerProp stored False;
    property HandshakeWait: Integer index 143 read GetIntegerProp write SetIntegerProp stored False;
    property HonorDirectory: WordBool index 144 read GetWordBoolProp write SetWordBoolProp stored False;
    property IncludeDirectory: WordBool index 145 read GetWordBoolProp write SetWordBoolProp stored False;
    property KermitCtlPrefix: Integer index 146 read GetIntegerProp write SetIntegerProp stored False;
    property KermitHighbitPrefix: Integer index 147 read GetIntegerProp write SetIntegerProp stored False;
    property KermitMaxLen: Integer index 148 read GetIntegerProp write SetIntegerProp stored False;
    property KermitMaxWindows: Integer index 149 read GetIntegerProp write SetIntegerProp stored False;
    property KermitPadCharacter: Integer index 150 read GetIntegerProp write SetIntegerProp stored False;
    property KermitPadCount: Integer index 151 read GetIntegerProp write SetIntegerProp stored False;
    property KermitRepeatPrefix: Integer index 152 read GetIntegerProp write SetIntegerProp stored False;
    property KermitSWCTurnDelay: Integer index 153 read GetIntegerProp write SetIntegerProp stored False;
    property KermitTerminator: Integer index 154 read GetIntegerProp write SetIntegerProp stored False;
    property KermitTimeoutSecs: Integer index 155 read GetIntegerProp write SetIntegerProp stored False;
    property ReceiveDirectory: WideString index 156 read GetWideStringProp write SetWideStringProp stored False;
    property ReceiveFileName: WideString index 157 read GetWideStringProp write SetWideStringProp stored False;
    property RTSLowForWrite: WordBool index 158 read GetWordBoolProp write SetWordBoolProp stored False;
    property SendFileName: WideString index 159 read GetWideStringProp write SetWideStringProp stored False;
    property StatusInterval: Integer index 160 read GetIntegerProp write SetIntegerProp stored False;
    property TransmitTimeout: Integer index 161 read GetIntegerProp write SetIntegerProp stored False;
    property UpcaseFileNames: WordBool index 162 read GetWordBoolProp write SetWordBoolProp stored False;
    property WriteFailAction: TOleEnum index 163 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property XYmodemBlockWait: Integer index 164 read GetIntegerProp write SetIntegerProp stored False;
    property Zmodem8K: WordBool index 165 read GetWordBoolProp write SetWordBoolProp stored False;
    property ZmodemFileOptions: TOleEnum index 166 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property ZmodemFinishRetry: Integer index 167 read GetIntegerProp write SetIntegerProp stored False;
    property ZmodemOptionOverride: WordBool index 168 read GetWordBoolProp write SetWordBoolProp stored False;
    property ZmodemRecover: WordBool index 169 read GetWordBoolProp write SetWordBoolProp stored False;
    property ZmodemSkipNoFile: WordBool index 170 read GetWordBoolProp write SetWordBoolProp stored False;
    property Caption: WideString index -518 read GetWideStringProp write SetWideStringProp stored False;
    property CaptionAlignment: TOleEnum index 171 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property CaptionWidth: Integer index 172 read GetIntegerProp write SetIntegerProp stored False;
    property LightWidth: Integer index 173 read GetIntegerProp write SetIntegerProp stored False;
    property LightsLitColor: TColor index 174 read GetTColorProp write SetTColorProp stored False;
    property LightsNotLitColor: TColor index 175 read GetTColorProp write SetTColorProp stored False;
    property ShowLightCaptions: WordBool index 176 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowLights: WordBool index 177 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowStatusBar: WordBool index 178 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowToolBar: WordBool index 179 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowDeviceSelButton: WordBool index 180 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowConnectButtons: WordBool index 181 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowProtocolButtons: WordBool index 182 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowTerminalButtons: WordBool index 183 read GetWordBoolProp write SetWordBoolProp stored False;
    property Cursor: Smallint index 194 read GetSmallintProp write SetSmallintProp stored False;
    property TapiStatusDisplay: WordBool index 191 read GetWordBoolProp write SetWordBoolProp stored False;
    property CommPort: Smallint index 196 read GetSmallintProp write SetSmallintProp stored False;
    property DTREnable: WordBool index 199 read GetWordBoolProp write SetWordBoolProp stored False;
    property Handshaking: TOleEnum index 200 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property InBufferSize: Smallint index 201 read GetSmallintProp write SetSmallintProp stored False;
    property OutBufferSize: Smallint index 204 read GetSmallintProp write SetSmallintProp stored False;
    property RTSEnable: WordBool index 207 read GetWordBoolProp write SetWordBoolProp stored False;
    property Settings: WideString index 208 read GetWideStringProp write SetWideStringProp stored False;
    property InputMode: TOleEnum index 211 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property InputLen: Smallint index 212 read GetSmallintProp write SetSmallintProp stored False;
    property MSCommCompatible: WordBool index 206 read GetWordBoolProp write SetWordBoolProp stored False;
    property RTThreshold: Smallint index 214 read GetSmallintProp write SetSmallintProp stored False;
    property SThreshold: Smallint index 215 read GetSmallintProp write SetSmallintProp stored False;
    property FTPAccount: WideString index 233 read GetWideStringProp write SetWideStringProp stored False;
    property FTPConnectTimeout: Integer index 236 read GetIntegerProp write SetIntegerProp stored False;
    property FTPFileType: TOleEnum index 240 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property FTPPassword: WideString index 246 read GetWideStringProp write SetWideStringProp stored False;
    property FTPRestartAt: Integer index 248 read GetIntegerProp write SetIntegerProp stored False;
    property FTPServerAddress: WideString index 251 read GetWideStringProp write SetWideStringProp stored False;
    property FTPTransferTimeout: Integer index 254 read GetIntegerProp write SetIntegerProp stored False;
    property FTPUserName: WideString index 256 read GetWideStringProp write SetWideStringProp stored False;
    property FilterTapiDevices: WordBool index 260 read GetWordBoolProp write SetWordBoolProp stored False;
    property OnCTSChanged: TApaxOnCTSChanged read FOnCTSChanged write FOnCTSChanged;
    property OnDCDChanged: TApaxOnDCDChanged read FOnDCDChanged write FOnDCDChanged;
    property OnDSRChanged: TApaxOnDSRChanged read FOnDSRChanged write FOnDSRChanged;
    property OnLineBreak: TNotifyEvent read FOnLineBreak write FOnLineBreak;
    property OnLineError: TNotifyEvent read FOnLineError write FOnLineError;
    property OnPortClose: TNotifyEvent read FOnPortClose write FOnPortClose;
    property OnPortOpen: TNotifyEvent read FOnPortOpen write FOnPortOpen;
    property OnRing: TNotifyEvent read FOnRing write FOnRing;
    property OnRXD: TApaxOnRXD read FOnRXD write FOnRXD;
    property OnWinsockAccept: TApaxOnWinsockAccept read FOnWinsockAccept write FOnWinsockAccept;
    property OnWinsockConnect: TNotifyEvent read FOnWinsockConnect write FOnWinsockConnect;
    property OnWinsockDisconnect: TNotifyEvent read FOnWinsockDisconnect write FOnWinsockDisconnect;
    property OnWinsockError: TApaxOnWinsockError read FOnWinsockError write FOnWinsockError;
    property OnWinsockGetAddress: TApaxOnWinsockGetAddress read FOnWinsockGetAddress write FOnWinsockGetAddress;
    property OnDataTrigger: TApaxOnDataTrigger read FOnDataTrigger write FOnDataTrigger;
    property OnTapiCallerID: TApaxOnTapiCallerID read FOnTapiCallerID write FOnTapiCallerID;
    property OnTapiConnect: TNotifyEvent read FOnTapiConnect write FOnTapiConnect;
    property OnTapiDTMF: TApaxOnTapiDTMF read FOnTapiDTMF write FOnTapiDTMF;
    property OnTapiFail: TNotifyEvent read FOnTapiFail write FOnTapiFail;
    property OnTapiGetNumber: TApaxOnTapiGetNumber read FOnTapiGetNumber write FOnTapiGetNumber;
    property OnTapiPortClose: TNotifyEvent read FOnTapiPortClose write FOnTapiPortClose;
    property OnTapiPortOpen: TNotifyEvent read FOnTapiPortOpen write FOnTapiPortOpen;
    property OnTapiStatus: TApaxOnTapiStatus read FOnTapiStatus write FOnTapiStatus;
    property OnTapiWaveNotify: TApaxOnTapiWaveNotify read FOnTapiWaveNotify write FOnTapiWaveNotify;
    property OnTapiWaveSilence: TApaxOnTapiWaveSilence read FOnTapiWaveSilence write FOnTapiWaveSilence;
    property OnCursorMoved: TApaxOnCursorMoved read FOnCursorMoved write FOnCursorMoved;
    property OnProtocolAccept: TApaxOnProtocolAccept read FOnProtocolAccept write FOnProtocolAccept;
    property OnProtocolFinish: TApaxOnProtocolFinish read FOnProtocolFinish write FOnProtocolFinish;
    property OnProtocolLog: TApaxOnProtocolLog read FOnProtocolLog write FOnProtocolLog;
    property OnProtocolStatus: TApaxOnProtocolStatus read FOnProtocolStatus write FOnProtocolStatus;
    property OnConnectButtonClick: TApaxOnConnectButtonClick read FOnConnectButtonClick write FOnConnectButtonClick;
    property OnListenButtonClick: TApaxOnListenButtonClick read FOnListenButtonClick write FOnListenButtonClick;
    property OnCloseButtonClick: TApaxOnCloseButtonClick read FOnCloseButtonClick write FOnCloseButtonClick;
    property OnDeviceButtonClick: TApaxOnDeviceButtonClick read FOnDeviceButtonClick write FOnDeviceButtonClick;
    property OnSendButtonClick: TApaxOnSendButtonClick read FOnSendButtonClick write FOnSendButtonClick;
    property OnReceiveButtonClick: TApaxOnReceiveButtonClick read FOnReceiveButtonClick write FOnReceiveButtonClick;
    property OnFontButtonClick: TApaxOnFontButtonClick read FOnFontButtonClick write FOnFontButtonClick;
    property OnComm: TNotifyEvent read FOnComm write FOnComm;
    property OnEmulationButtonClick: TApaxOnEmulationButtonClick read FOnEmulationButtonClick write FOnEmulationButtonClick;
    property OnFTPError: TApaxOnFTPError read FOnFTPError write FOnFTPError;
    property OnFTPLog: TApaxOnFTPLog read FOnFTPLog write FOnFTPLog;
    property OnFTPReply: TApaxOnFTPReply read FOnFTPReply write FOnFTPReply;
    property OnFTPStatus: TApaxOnFTPStatus read FOnFTPStatus write FOnFTPStatus;
    property OnProcessChar: TApaxOnProcessChar read FOnProcessChar write FOnProcessChar;
  end;

procedure Register;

implementation

uses ComObj;

procedure TApax.InitControlData;
const
  CEventDispIDs: array [0..43] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006,
    $00000007, $00000008, $00000009, $0000000A, $0000000B, $0000000C,
    $0000000D, $0000000E, $0000000F, $00000010, $00000011, $00000012,
    $00000013, $00000014, $00000015, $00000016, $00000017, $00000018,
    $00000019, $0000001A, $0000001B, $0000001C, $0000001D, $0000001E,
    $0000001F, $00000020, $00000021, $00000022, $00000023, $00000024,
    $00000025, $00000026, $00000027, $00000028, $00000029, $0000002A,
    $0000002B, $0000002C);
  CLicenseKey: array[0..38] of Word = ( $007B, $0032, $0031, $0033, $0045, $0030, $0042, $0031, $0046, $002D, $0033
    , $0034, $0036, $0034, $002D, $0034, $0032, $0041, $0043, $002D, $0041
    , $0032, $0042, $0035, $002D, $0043, $0045, $0039, $0030, $0033, $0039
    , $0045, $0044, $0037, $0038, $0035, $0032, $007D, $0000);
  CTFontIDs: array [0..0] of DWORD = (
    $FFFFFE00);
  CControlData: TControlData2 = (
    ClassID: '{28E7F3B1-59C2-4B1C-9D8E-0610B280898D}';
    EventIID: '{EB835ACB-DEA7-4527-92BA-2BE7FBEFAFB5}';
    EventCount: 44;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $0000001D;
    Version: 401;
    FontCount: 1;
    FontIDs: @CTFontIDs);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnCTSChanged) - Cardinal(Self);
end;

procedure TApax.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IApax;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TApax.GetControlInterface: IApax;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TApax.Set_Output(Param1: OleVariant);
begin
  DefaultInterface.Set_Output(Param1);
end;

function  TApax.Get_Input: OleVariant;
begin
  Result := DefaultInterface.Get_Input;
end;

function  TApax.PortOpen: Integer;
begin
  Result := DefaultInterface.PortOpen;
end;

function  TApax.TapiDial: Integer;
begin
  Result := DefaultInterface.TapiDial;
end;

function  TApax.TapiAnswer: Integer;
begin
  Result := DefaultInterface.TapiAnswer;
end;

function  TApax.WinsockConnect: Integer;
begin
  Result := DefaultInterface.WinsockConnect;
end;

function  TApax.WinsockListen: Integer;
begin
  Result := DefaultInterface.WinsockListen;
end;

function  TApax.Close: Integer;
begin
  Result := DefaultInterface.Close;
end;

procedure TApax.AddStringToLog(const S: WideString);
begin
  DefaultInterface.AddStringToLog(S);
end;

procedure TApax.FlushInBuffer;
begin
  DefaultInterface.FlushInBuffer;
end;

procedure TApax.FlushOutBuffer;
begin
  DefaultInterface.FlushOutBuffer;
end;

function  TApax.PutData(Data: OleVariant): Integer;
begin
  Result := DefaultInterface.PutData(Data);
end;

function  TApax.PutString(const S: WideString): Integer;
begin
  Result := DefaultInterface.PutString(S);
end;

function  TApax.PutStringCRLF(const S: WideString): Integer;
begin
  Result := DefaultInterface.PutStringCRLF(S);
end;

procedure TApax.SendBreak(Ticks: Integer; Yield: WordBool);
begin
  DefaultInterface.SendBreak(Ticks, Yield);
end;

function  TApax.AddDataTrigger(const TriggerString: WideString; PacketSize: Integer; 
                               Timeout: Integer; IncludeStrings: WordBool; IgnoreCase: WordBool): Integer;
begin
  Result := DefaultInterface.AddDataTrigger(TriggerString, PacketSize, Timeout, IncludeStrings, 
                                            IgnoreCase);
end;

procedure TApax.DisableDataTrigger(Index: Integer);
begin
  DefaultInterface.DisableDataTrigger(Index);
end;

procedure TApax.EnableDataTrigger(Index: Integer);
begin
  DefaultInterface.EnableDataTrigger(Index);
end;

procedure TApax.RemoveDataTrigger(Index: Integer);
begin
  DefaultInterface.RemoveDataTrigger(Index);
end;

procedure TApax.Clear;
begin
  DefaultInterface.Clear;
end;

procedure TApax.ClearAll;
begin
  DefaultInterface.ClearAll;
end;

procedure TApax.CopyToClipboard;
begin
  DefaultInterface.CopyToClipboard;
end;

function  TApax.GetAttributes(aRow: Integer; aCol: Integer): Integer;
begin
  Result := DefaultInterface.GetAttributes(aRow, aCol);
end;

procedure TApax.SetAttributes(aRow: Integer; aCol: Integer; Value: Integer);
begin
  DefaultInterface.SetAttributes(aRow, aCol, Value);
end;

function  TApax.GetLine(Index: Integer): WideString;
begin
  Result := DefaultInterface.GetLine(Index);
end;

procedure TApax.SetLine(Index: Integer; const Value: WideString);
begin
  DefaultInterface.SetLine(Index, Value);
end;

procedure TApax.TerminalSetFocus;
begin
  DefaultInterface.TerminalSetFocus;
end;

procedure TApax.TerminalWriteString(const S: WideString);
begin
  DefaultInterface.TerminalWriteString(S);
end;

procedure TApax.TerminalWriteStringCRLF(const S: WideString);
begin
  DefaultInterface.TerminalWriteStringCRLF(S);
end;

procedure TApax.TapiAutoAnswer;
begin
  DefaultInterface.TapiAutoAnswer;
end;

procedure TApax.TapiCancelCall;
begin
  DefaultInterface.TapiCancelCall;
end;

procedure TApax.TapiConfigAndOpen;
begin
  DefaultInterface.TapiConfigAndOpen;
end;

function  TApax.TapiSelectDevice: WordBool;
begin
  Result := DefaultInterface.TapiSelectDevice;
end;

procedure TApax.TapiSendTone(const Digits: WideString);
begin
  DefaultInterface.TapiSendTone(Digits);
end;

procedure TApax.TapiSetRecordingParams(NumChannels: Integer; NumSamplesPerSecond: Integer; 
                                       NumBitsPerSample: Integer);
begin
  DefaultInterface.TapiSetRecordingParams(NumChannels, NumSamplesPerSecond, NumBitsPerSample);
end;

procedure TApax.TapiShowConfigDialog(AllowEdit: WordBool);
begin
  DefaultInterface.TapiShowConfigDialog(AllowEdit);
end;

procedure TApax.TapiPlayWaveFile(const FileName: WideString);
begin
  DefaultInterface.TapiPlayWaveFile(FileName);
end;

procedure TApax.TapiRecordWaveFile(const FileName: WideString; Overwrite: WordBool);
begin
  DefaultInterface.TapiRecordWaveFile(FileName, Overwrite);
end;

procedure TApax.TapiStopWaveFile;
begin
  DefaultInterface.TapiStopWaveFile;
end;

function  TApax.TapiTranslatePhoneNo(const CanonicalAddr: WideString): WideString;
begin
  Result := DefaultInterface.TapiTranslatePhoneNo(CanonicalAddr);
end;

procedure TApax.CancelProtocol;
begin
  DefaultInterface.CancelProtocol;
end;

function  TApax.EstimateTransferSecs(Size: Integer): Integer;
begin
  Result := DefaultInterface.EstimateTransferSecs(Size);
end;

procedure TApax.StartTransmit;
begin
  DefaultInterface.StartTransmit;
end;

procedure TApax.StartReceive;
begin
  DefaultInterface.StartReceive;
end;

function  TApax.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := DefaultInterface.DrawTextBiDiModeFlagsReadingOnly;
end;

procedure TApax.InitiateAction;
begin
  DefaultInterface.InitiateAction;
end;

function  TApax.IsRightToLeft: WordBool;
begin
  Result := DefaultInterface.IsRightToLeft;
end;

function  TApax.UseRightToLeftReading: WordBool;
begin
  Result := DefaultInterface.UseRightToLeftReading;
end;

function  TApax.UseRightToLeftScrollBar: WordBool;
begin
  Result := DefaultInterface.UseRightToLeftScrollBar;
end;

procedure TApax.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure TApax.RemoveAllDataTriggers;
begin
  DefaultInterface.RemoveAllDataTriggers;
end;

function  TApax.TapiStatusMsg(Message: Integer; State: Integer; Reason: Integer): WideString;
begin
  Result := DefaultInterface.TapiStatusMsg(Message, State, Reason);
end;

function  TApax.IsPortAvail(ComNumber: Integer): WordBool;
begin
  Result := DefaultInterface.IsPortAvail(ComNumber);
end;

function  TApax.TapiTranslateDialog(const CanonicalAddr: WideString): WordBool;
begin
  Result := DefaultInterface.TapiTranslateDialog(CanonicalAddr);
end;

function  TApax.ErrorMsg(ErrorCode: Integer): WideString;
begin
  Result := DefaultInterface.ErrorMsg(ErrorCode);
end;

function  TApax.EnumTapiFirst: WideString;
begin
  Result := DefaultInterface.EnumTapiFirst;
end;

function  TApax.EnumTapiNext: WideString;
begin
  Result := DefaultInterface.EnumTapiNext;
end;

function  TApax.IsPortInstalled(ComNumber: Integer): WordBool;
begin
  Result := DefaultInterface.IsPortInstalled(ComNumber);
end;

procedure TApax.DelayTicks(Ticks: Integer);
begin
  DefaultInterface.DelayTicks(Ticks);
end;

function  TApax.FTPAbort: WordBool;
begin
  Result := DefaultInterface.FTPAbort;
end;

function  TApax.FTPChangeDir(const RemotePathName: WideString): WordBool;
begin
  Result := DefaultInterface.FTPChangeDir(RemotePathName);
end;

function  TApax.FTPCurrentDir: WideString;
begin
  Result := DefaultInterface.FTPCurrentDir;
end;

function  TApax.FTPDelete(const RemotePathName: WideString): WordBool;
begin
  Result := DefaultInterface.FTPDelete(RemotePathName);
end;

function  TApax.FTPHelp(const Command: WideString): WideString;
begin
  Result := DefaultInterface.FTPHelp(Command);
end;

function  TApax.FTPListDir(const RemotePathName: WideString; FullList: WordBool): WideString;
begin
  Result := DefaultInterface.FTPListDir(RemotePathName, FullList);
end;

function  TApax.FTPLogIn: WordBool;
begin
  Result := DefaultInterface.FTPLogIn;
end;

function  TApax.FTPLogOut: WordBool;
begin
  Result := DefaultInterface.FTPLogOut;
end;

function  TApax.FTPMakeDir(const RemotePathName: WideString): WordBool;
begin
  Result := DefaultInterface.FTPMakeDir(RemotePathName);
end;

function  TApax.FTPRename(const RemotePathName: WideString; const NewPathName: WideString): WordBool;
begin
  Result := DefaultInterface.FTPRename(RemotePathName, NewPathName);
end;

function  TApax.FTPRetrieve(const RemotePathName: WideString; const LocalPathName: WideString; 
                            RetrieveMode: TxFTPRetrieveMode): WordBool;
begin
  Result := DefaultInterface.FTPRetrieve(RemotePathName, LocalPathName, RetrieveMode);
end;

function  TApax.FTPSendFTPCommand(const FTPCommand: WideString): WideString;
begin
  Result := DefaultInterface.FTPSendFTPCommand(FTPCommand);
end;

function  TApax.FTPStatus(const RemotePathName: WideString): WideString;
begin
  Result := DefaultInterface.FTPStatus(RemotePathName);
end;

function  TApax.FTPStore(const RemotePathName: WideString; const LocalPathName: WideString; 
                         StoreMode: TxFTPStoreMode): WordBool;
begin
  Result := DefaultInterface.FTPStore(RemotePathName, LocalPathName, StoreMode);
end;

procedure TApax.TapiLoadConfig(const RegKey: WideString; const KeyName: WideString);
begin
  DefaultInterface.TapiLoadConfig(RegKey, KeyName);
end;

function  TApax.GetTapiConfig: OleVariant;
begin
  Result := DefaultInterface.GetTapiConfig;
end;

procedure TApax.SetTapiConfig(Value: OleVariant);
begin
  DefaultInterface.SetTapiConfig(Value);
end;

procedure TApax.TapiSaveConfig(const RegKey: WideString; const KeyName: WideString);
begin
  DefaultInterface.TapiSaveConfig(RegKey, KeyName);
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TApax]);
end;

end.
