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

{******************************************************************}
{*                        AXTERM.PAS 1.13                         *}
{******************************************************************}
{* AxTerm.PAS - Terminal, ComPort, DataPacket, TapiDevice, etc.   *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxTerm;

interface

uses
  Windows, Classes, Controls, SysUtils, Messages, StdCtrls, extctrls, Graphics,
  ComCtrls, Forms, ToolWin, AxCtrls, StdVcl, Menus, Imglist,
  AdTrmBuf, AdTrmEmu, AdPort, AdPacket, AdTapi, AdTStat, AdTUtil, AdFtp, AxFtp,
  AdProtcl, AdPStat, AdSocket, AwWnsock, AdWUtil, AdWnPort, OoMisc;

const
  sApaxVersion = '1.12';

const { set property bit masks }
  { terminal character attributes }
  tcaxMask          = $0000003F;
  tcaxNone          = $00000000;
  tcaxBold          = $00000001;
  tcaxUnderline     = $00000002;
  tcaxStrikethrough = $00000004;
  tcaxBlink         = $00000008;
  tcaxReverse       = $00000010;
  tcaxInvisible     = $00000020;

const { data packet end conditions }
  ecxMask           = $00000003;
  ecxNone           = $00000000;
  ecxString         = $00000001;
  ecxPacketSize     = $00000002;

const { component messages }
  CM_INITAPAX      = apw_First+ 12; //WM_USER + 1;
  CM_WINSOCKEVENT  = apw_First+ 13; //WM_USER + 2;
  CM_NAGSCREEN     = apw_First+ 14; //WM_USER + 3;
  CM_PROTOCOLEVENT = apw_First+ 15; // used for OnProtocolFinish, ..Log, ..Status
  CM_PORTCLOSEVENT = apw_First+ 16; // used for OnPortClose, OnTapiPortClose

const
  { winsock event message parameters }
  wpWsConnect        = 1;
  wpWsDisconnect     = 2;
  wpWsError          = 3;
  { protocol event message parameters }
  wpProtocolFinish   = 1;
  wpProtocolLog      = 2;
  wpProtocolStatus   = 3;
  { port close event message parameters }
  wpPortClose        = 1;
  wpTapiPortClose    = 2;

type { Apax enumerations }
  TApxTerminalEmulation = (teTTY, teVT100);
  TApxDeviceType = (dtDirect, dtTAPI, dtWinsock);

type { status lights }
  TApxLightID = (liBRK, liCTS, liDCD, liDSR, liERR, liRNG, liRXD, liTXD);
  TApxLightRec = record
    Enabled : Boolean;
    Lit   : Boolean;
    Panel : TStatusPanel;
  end;
  TApxLights = array[TApxLightID] of TApxLightRec;

type { toolbar buttons }
  TApxToolBtnID = (tbConnect, tbListen, tbClose, tbDevice, tbSend, tbReceive, tbFont, tbEmulation);
  TApxToolButtons = array[TApxToolBtnID] of TToolButton;

type { event handler templates }
  { com port events }
  TApxNotifyEvent            = procedure of object;
  TApxDataReceivedEvent      = procedure(Data : OleVariant) of object;
  TApxStatusChangedEvent     = procedure(NewValue : WordBool) of object;
  TApxWinsockAcceptEvent     = procedure(Addr : WideString; var Accept : WordBool) of object;
  TApxWinsockErrorEvent      = procedure(ErrCode : Integer) of object;
  TApxWinsockAddressEvent    = procedure(var Address, Port : WideString) of object;

  { data packet events }
  TApxDataTriggerEvent      = procedure(Index : Integer; Timeout : WordBool; Data : OleVariant; Size : Integer; var ReEnable : WordBool) of object;

  { tapi device events }
  TApxTapiCallerIDEvent     = procedure(const ID, IDName : WideString) of object;
  TApxTapiDTMFEvent         = procedure(Digit : Byte; ErrorCode : Integer) of object;
  TApxTapiStatusEvent       = procedure(First, Last : WordBool; Device, Message, Param1, Param2, Param3 : Integer) of object;
  TApxTapiWaveNotifyEvent   = procedure(Msg : TWaveMessage) of object;
  TApxTapiWaveSilenceEvent  = procedure(var StopRecording : WordBool; var Hangup : WordBool) of object;
  TApxTapiNotifyEvent       = procedure of object;
  TApxTapiNumberEvent       = procedure(var PhoneNum : WideString) of object;

  { terminal events }
  TApxCursorMovedEvent      = procedure (aRow, aCol : integer) of object;
  TApxProcessCharEvent      = procedure (Character   : Char;
                                         var ReplaceWith : string;
                                         Commands    : TAdEmuCommandList;
                                         CharSource  : TAdCharSource) of object;

  { protocol events }
  TApxProtocolAcceptEvent   = procedure(var Accept : WordBool; var FName : WideString) of object;
  TApxProtocolFinishEvent   = procedure(ErrorCode : Integer) of object;
  TApxProtocolLogEvent      = procedure(Log : Integer) of object;
  TApxProtocolStatusEvent   = procedure(Options : Integer) of object;

  { tool button events }
  TApxToolButtonClickEvent      = procedure(var Default : WordBool) of object;
  TApxDeviceButtonClickEvent    = procedure(DeviceType : TApxDeviceType) of object;
  TApxEmulationButtonClickEvent = procedure(Emulation : TApxTerminalEmulation) of object;


type { TApxDataTriggers }
  TApxDataTriggers = class(TObject)
  protected {private}
    FList      : TStringList;
    FOwner     : TComponent;
    FPort      : TApdCustomWinsockPort;
    FOnPacket  : TPacketNotifyEvent;
    FOnTimeout : TNotifyEvent;

    function  GetDataTriggerString : string;
    procedure SetDataTriggerString(const Value : string);
  public
    constructor Create(AOwner : TComponent; APort : TApdCustomWinsockPort; OnPacket : TPacketNotifyEvent; OnTimeout : TNotifyEvent);
    destructor Destroy; override;
    function Add(const TriggerString : string; PacketSize, Timeout : Integer; IncludeStrings, IgnoreCase : Boolean) : Integer;
    procedure Clear;
    procedure Delete(Index : Integer);
    procedure Disable(Index : Integer);
    procedure Enable(Index : Integer);

    property DataTriggerString : string read GetDataTriggerString write SetDataTriggerString;
  end;


type { TApxCircularBuffer }
  TApxCircularBuffer = class(TObject)
  private
    PBuffer : PByteArray;
    Head    : Smallint;
    Tail    : Smallint;
    Full    : Boolean;
  protected
    FCount  : Smallint;
    FSize   : Smallint;
    function GetCount : Smallint;
    procedure SetSize(Value : Smallint);
  public
    constructor Create(ASize : Smallint);
    destructor Destroy; override;

    procedure Clear;
    function GetByte : Byte;
    function PutByte(Data : Byte) : Boolean;

    property Count : Smallint
      read GetCount;
    property Size : Smallint
      read FSize write SetSize;
  end;

type { TApxTerminal }
  TApxTerminal = class(TCustomPanel)
    protected { private variables }
      { com port }
      FPort                  : TApdCustomWinsockPort;
      FConnected             : Boolean;
      FDeviceType            : TApxDeviceType;
      FLineErrorFlags        : Word;
      FLineErrorTrigger      : Word;
      FLogAllHex             : WordBool;
      FOnLineBreak           : TApxNotifyEvent;
      FOnCTSChanged          : TApxStatusChangedEvent;
      FOnDCDChanged          : TApxStatusChangedEvent;
      FOnDSRChanged          : TApxStatusChangedEvent;
      FOnLineError           : TApxNotifyEvent;
      FOnPortOpen            : TApxNotifyEvent;
      FOnPortClose           : TApxNotifyEvent;
      FOnRing                : TApxNotifyEvent;
      FOnRXD                 : TApxDataReceivedEvent;
      FOnWinsockAccept       : TApxWinsockAcceptEvent;
      FOnWinsockConnect      : TApxNotifyEvent;
      FOnWinsockDisconnect   : TApxNotifyEvent;
      FOnWinsockError        : TApxWinsockErrorEvent;
      FOnWinsockGetAddress   : TApxWinsockAddressEvent;
      FStatusFlags           : Word;
      FStatusTrigger         : Word;
      FBRKOffTrigger         : Word;
      FERROffTrigger         : Word;
      FRNGOffTrigger         : Word;
      FRXDOffTrigger         : Word;
      FTXDOffTrigger         : Word;
      FBRKOnTrigger          : Word;
      FERROnTrigger          : Word;
      FRNGOnTrigger          : Word;
      FRXDOnTrigger          : Word;
      FTXDOnTrigger          : Word;
      { data packets }
      FDataTriggerString     : WideString;
      FDataTriggers          : TApxDataTriggers;
      FOnDataTrigger         : TApxDataTriggerEvent;

      { tapi device }
      FTapiDevice            : TApdTapiDevice;
      FTapiStatus            : TApdTapiStatus;
      FTapiStatusDisplay     : WordBool;
      FWaveFileOverwrite     : Boolean;
      FTapiNumber            : WideString;
      FWaveFileName          : string;
      FOnTapiCallerID        : TApxTapiCallerIDEvent;
      FOnTapiConnect         : TApxTapiNotifyEvent;
      FOnTapiDTMF            : TApxTapiDTMFEvent;
      FOnTapiFail            : TApxTapiNotifyEvent;
      FOnTapiPortClose       : TApxTapiNotifyEvent;
      FOnTapiPortOpen        : TApxTapiNotifyEvent;
      FOnTapiStatus          : TApxTapiStatusEvent;
      FOnTapiWaveNotify      : TApxTapiWaveNotifyEvent;
      FOnTapiWaveSilence     : TApxTapiWaveSilenceEvent;
      FOnTapiGetNumber       : TApxTapiNumberEvent;

      { terminal }
      FTerminal              : TAdTerminal;
      FColor                 : TColor;
      FOnCursorMoved         : TApxCursorMovedEvent;
      FCaptureMode           : TAdCaptureMode;
      FOnProcessChar         : TApxProcessCharEvent;
      FVT100Emulator         : TAdVT100Emulator;
      FTTYEmulator           : TAdTTYEmulator;

      { protocol }
      FProtocol              : TApdCustomProtocol;
      FProtocolStatus        : TApdProtocolStatus;
      FProtocolStatusDisplay : WordBool;
      FOnProtocolFinish      : TApxProtocolFinishEvent;
      FOnProtocolLog         : TApxProtocolLogEvent;
      FOnProtocolStatus      : TApxProtocolStatusEvent;
      FOnProtocolAccept      : TApxProtocolAcceptEvent;

      { status bar }
      FLitColor              : TColor;
      FNotLitColor           : TColor;
      FStatusBar             : TStatusBar;
      FLights                : TApxLights;
      FLightWidth            : Integer;
      FCaption               : WideString;
      FCaptionAlignment      : TAlignment;
      FCaptionWidth          : Integer;
      FCaptionPanel          : TStatusPanel;
      FEndPanel              : TStatusPanel;
      FShowLightCaptions     : WordBool;
      FShowLights            : WordBool;
      FShowStatusBar         : WordBool;

      { toolbar }
      FToolBar               : TToolBar;
      FToolButtons           : TApxToolButtons;
      FDeviceSeparator       : TToolButton;
      FConnectSeparator      : TToolButton;
      FProtocolSeparator     : TToolButton;
      FTerminalSeparator     : TToolButton;
      FButtonImages          : TImageList;
      FShowDeviceSelButton   : WordBool;
      FShowConnectButtons    : WordBool;
      FShowProtocolButtons   : WordBool;
      FShowTerminalButtons   : WordBool;
      FShowToolbar           : WordBool;
      FOnConnectButtonClick  : TApxToolButtonClickEvent;
      FOnListenButtonClick   : TApxToolButtonClickEvent;
      FOnCloseButtonClick    : TApxToolButtonClickEvent;
      FOnDeviceButtonClick   : TApxDeviceButtonClickEvent;
      FOnSendButtonClick     : TApxToolButtonClickEvent;
      FOnReceiveButtonClick  : TApxToolButtonClickEvent;
      FOnFontButtonClick     : TApxToolButtonClickEvent;
      FOnEmulationButtonClick : TApxEmulationButtonClickEvent;

      { MSComm Compatibilty }
      FMSCommBreak           : WordBool;
      FMSCommCDHolding       : WordBool;
      FMSCommCommEvent       : Smallint;
      FMSCommCommPort        : Smallint;
      FMSCommCompatible      : WordBool;
      FMSCommCTSHolding      : WordBool;
      FMSCommDSRHolding      : WordBool;
      FMSCommDTREnable       : WordBool;
      FMSCommHandshaking     : Integer;
      FMSCommInBufferSize    : Smallint;
      FMSCommInBufferCount   : Smallint;
      FMSCommInputLen        : Smallint;
      FMSCommInputMode       : Integer;
      FMSCommOutBufferSize   : Smallint;
      FMSCommOutBufferCount  : Smallint;
      FMSCommRTSEnable       : WordBool;
      FMSCommRTThreshold     : Smallint;
      FMSCommSettings        : WideString;
      FMSCommSThreshold      : Smallint;
      FMSCommOnCommEvent     : TApxNotifyEvent;

      { circular input buffer for MSCommCompatiblity }
      FMSCommInBuffer        : TApxCircularBuffer;

      { FTP stuff }
      FFTPClient             : TApxFTPClient;

      { misc }
      FOleContainerReady     : Boolean;
      FEnumIndex             : Integer;
    protected { internal event handlers }

      procedure DoToolButtonClick(Sender : TObject);
      procedure DoDeviceMenuClick(Sender: TObject);
      procedure DoEmulationMenuClick(Sender: TObject);
      procedure DoDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);

      { com port }
      procedure DoPortOpen(Sender : TObject);
      procedure DoPortClose(Sender : TObject);
      procedure DoTriggerAvail(CP : TObject; Count : Word);
      procedure DoTriggerModemStatus(Sender: TObject);
      procedure DoTriggerLineError(CP : TObject; Error : Word; LineBreak : Boolean);
      procedure DoTriggerOutSent(Sender : TObject);
      procedure DoTriggerTimer(CP : TObject; TriggerHandle : Word);

      { winsock }
      procedure DoWsAccept(Sender : TObject; Addr : TInAddr; var Accept : Boolean);
      procedure DoWsConnect(Sender : TObject);
      procedure DoWsDisconnect(Sender : TObject);
      procedure DoWsError(Sender : TObject; ErrCode : Integer);
      procedure DoWinsockGetAddress;

      { data packets }
      procedure DoPacketData(Sender : TObject; Data : Pointer; Size : Integer);
      procedure DoPacketTimeout(Sender : TObject);

      { tapi device }
      procedure DoTapiCallerID(CP : TObject; ID, IDName : string);
      procedure DoTapiConnect(Sender : TObject);
      procedure DoTapiDTMF(CP : TObject; Digit : Char; ErrorCode : Integer);
      procedure DoTapiFail(Sender : TObject);
      procedure DoTapiPortClose(Sender : TObject);
      procedure DoTapiPortOpen(Sender : TObject);
      procedure DoTapiStatus(CP : TObject; First, Last : Boolean; Device, Message, Param1, Param2, Param3 : Integer);
      procedure DoTapiWaveNotify(CP : TObject; Msg : TWaveMessage);
      procedure DoTapiWaveSilence(CP : TObject; var StopRecording, Hangup : Boolean);
      procedure DoTapiGetNumber;

      { terminal }
      procedure DoCursorMoved(aSender : TObject; aRow, aCol : integer);
      procedure DoProcessChar(Sender      : TObject;
                              Character   : Char;
                              var ReplaceWith : string;
                              Commands    : TAdEmuCommandList;
                              CharSource  : TAdCharSource);


      { protocol }
      procedure DoProtocolAccept(CP : TObject; var Accept : Boolean; var FName : TPassString);
      procedure DoProtocolFinish(CP : TObject; ErrorCode : Integer);
      procedure DoProtocolLog(CP : TObject; Log : Word);
      procedure DoProtocolStatus(CP : TObject; Options : Word);

    protected { property access methods }
      { com port }
      function  GetBaud: Integer;
      procedure SetBaud(Value: Integer);
      function  GetBufferFull: Integer;
      procedure SetBufferFull(Value: Integer);
      function  GetBufferResume: Integer;
      procedure SetBufferResume(Value: Integer);
      function  GetComNumber: Integer;
      procedure SetComNumber(Value: Integer);
      function  GetCTS: WordBool;
      function  GetDataBits: Integer;
      procedure SetDataBits(Value: Integer);
      function  GetDCD: WordBool;
      function  GetDSR: WordBool;
      function  GetDTR: WordBool;
      procedure SetDTR(Value: WordBool);
      function  GetFlowState: TFlowControlState;
      function  GetHWFlowUseDTR: WordBool;
      procedure SetHWFlowUseDTR(Value: WordBool);
      function  GetHWFlowUseRTS: WordBool;
      procedure SetHWFlowUseRTS(Value: WordBool);
      function  GetHWFlowRequireDSR: WordBool;
      procedure SetHWFlowRequireDSR(Value: WordBool);
      function  GetHWFlowRequireCTS: WordBool;
      procedure SetHWFlowRequireCTS(Value: WordBool);
      function  GetInBuffUsed : Integer;
      function  GetInBuffFree : Integer;
      function  GetInSize: Integer;
      procedure SetInSize(Value: Integer);
      function  GetLineError: Integer;
      function  GetLogging: TTraceLogState;
      procedure SetLogging(Value: TTraceLogState);
      function  GetLogHex: WordBool;
      procedure SetLogHex(Value: WordBool);
      function  GetLogName: WideString;
      procedure SetLogName(const Value: WideString);
      function  GetLogSize: Integer;
      procedure SetLogSize(Value: Integer);
      function  GetOutBuffFree: Integer;
      function  GetOutBuffUsed: Integer;
      function  GetOutSize: Integer;
      procedure SetOutSize(Value: Integer);
      function  GetParity: TParity;
      procedure SetParity(Value: TParity);
      function  GetPromptForPort: WordBool;
      procedure SetPromptForPort(Value: WordBool);
      function  GetRI: WordBool;
      function  GetRS485Mode: WordBool;
      procedure SetRS485Mode(Value: WordBool);
      function  GetRTS: WordBool;
      procedure SetRTS(Value: WordBool);
      function  GetSWFlowOptions: TSWFlowOptions;
      procedure SetSWFlowOptions(Value: TSWFlowOptions);
      function  GetStopBits: Integer;
      procedure SetStopBits(Value: Integer);
      function  GetWinsockMode : TWsMode;
      procedure SetWinsockMode(Value : TWsMode);
      function  GetWinsockAddress : Widestring;
      procedure SetWinsockAddress(const Value : Widestring);
      function  GetWinsockPort : Widestring;
      procedure SetWinsockPort(const Value : Widestring);
      function  GetWSTelnet : WordBool;
      procedure SetWsTelnet(Value : WordBool);
      function  GetXOffChar: Integer;
      procedure SetXOffChar(Value: Integer);
      function  GetXOnChar: Integer;
      procedure SetXOnChar(Value: Integer);
      function  GetLogAllHex : WordBool;
      procedure SetLogAllHex(Value : WordBool);
      procedure SetDeviceType(Value : TApxDeviceType);

      { Winsock }
      function GetWsLocalAddress: WideString;
      function GetWsLocalDescription: WideString;
      function GetWsLocalHighVersion: Widestring;
      function GetWsLocalHost: WideString;
      function GetWsLocalMaxSockets: Integer;
      function GetWsLocalSystemStatus: WideString;
      function GetWsLocalVersion: Widestring;

      { tapi device }
      function  GetTapiStatusDisplay : WordBool;
      procedure SetTapiStatusDisplay(Value : WordBool);
      function  GetAnswerOnRing : Integer;
      procedure SetAnswerOnRing(Value : Integer);
      function  GetAttempt : Integer;
      function  GetCallerID : WideString;
      function  GetCancelled : WordBool;
      function  GetDialing : WordBool;
      function  GetEnableVoice : WordBool;
      procedure SetEnableVoice(Value : WordBool);
      function  GetTapiFailCode : Integer;                               {!!.01}
      function  GetInterruptWave : WordBool;
      procedure SetInterruptWave(Value : WordBool);
      function  GetMaxAttempts : Integer;
      procedure SetMaxAttempts(Value : Integer);
      function  GetMaxMessageLength : Integer;
      procedure SetMaxMessageLength(Value : Integer);
      function  GetRetryWait : Integer;
      procedure SetRetryWait(Value : Integer);
      function  GetSelectedDevice : WideString;
      procedure SetSelectedDevice(const Value : WideString);
      function  GetSilenceThreshold : Integer;
      procedure SetSilenceThreshold(Value : Integer);
      function  GetTapiState : TTapiState;
      function  GetTrimSeconds : Integer;
      procedure SetTrimSeconds(Value : Integer);
      function  GetUseSoundCard : WordBool;
      procedure SetUseSoundCard(Value : WordBool);
      function  GetWaveFileName : WideString;
      function  GetWaveState : TWaveState; 
      function GetFilterTapiDevices: WordBool;                           {!!.12}
      procedure SetFilterTapiDevices(Value: WordBool);                   {!!.12}

      { terminal }
      function  GetActive : WordBool;
      procedure SetActive(Value : WordBool);
      function  GetBlinkTime : Integer;
      procedure SetBlinkTime(Value : Integer);
      function  GetCaptureMode : TAdCaptureMode;
      procedure SetCaptureMode(Value : TAdCaptureMode);
      function  GetCaptureFile : WideString;
      procedure SetCaptureFile(const Value : WideString);
      function  GetColumns : Integer;
      procedure SetColumns(Value : Integer);
      function  GetEmulation : TApxTerminalEmulation;
      procedure SetEmulation(Value : TApxTerminalEmulation);
      function  GetFont : TFont;
      procedure SetFont(Value : TFont);
      function  GetHalfDuplex : WordBool;
      procedure SetHalfDuplex(Value : WordBool);
      function  GetLazyByteDelay : Integer;
      procedure SetLazyByteDelay(Value : Integer);
      function  GetLazyTimeDelay : Integer;
      procedure SetLazyTimeDelay(Value : Integer);
      function  GetRows : Integer;
      procedure SetRows(Value : Integer);
      function  GetScrollback : WordBool;
      procedure SetScrollback(Value : WordBool);
      function  GetScrollbackRows : Integer;
      procedure SetScrollbackRows(Value : Integer);
      procedure SetTerminalColor(Value : TColor);
      function  GetUseLazyDisplay : WordBool;
      procedure SetUseLazyDisplay(Value : WordBool);
      function  GetWantAllKeys : WordBool;
      procedure SetWantAllKeys(Value : WordBool);
      function  GetVersion : WideString;
      procedure SetVersion(const Value : WideString);

      { data triggers }
      function  GetDataTriggerString : WideString;
      procedure SetDataTriggerString(const Value : WideString);

      { protocol }
      function  GetProtocolType : TProtocolType;
      procedure SetProtocolType(Value : TProtocolType);
      function  GetProtocolStatusDisplay : WordBool;
      procedure SetProtocolStatusDisplay(Value : WordBool);
      function  GetReceiveDirectory : WideString;
      procedure SetReceiveDirectory(const Value : WideString);
      function  GetSendFileName : WideString;
      procedure SetSendFileName(const Value : WideString);
      function  GetBlockCheckMethod : TBlockCheckMethod;
      procedure SetBlockCheckMethod(Value : TBlockCheckMethod);
      function  GetHandshakeRetry : Integer;
      procedure SetHandshakeRetry(Value : Integer);
      function  GetHandshakeWait : Integer;
      procedure SetHandshakeWait(Value : Integer);
      function  GetTransmitTimeout : Integer;
      procedure SetTransmitTimeout(Value : Integer);
      function  GetFinishWait : Integer;
      procedure SetFinishWait(Value : Integer);
      function  GetWriteFailAction : TWriteFailAction;
      procedure SetWriteFailAction(Value :TWriteFailAction);
      function  GetHonorDirectory : WordBool;
      procedure SetHonorDirectory(Value : WordBool);
      function  GetIncludeDirectory : WordBool;
      procedure SetIncludeDirectory(Value : WordBool);
      function  GetRTSLowForWrite : WordBool;
      procedure SetRTSLowForWrite(Value : WordBool);
      function  GetAbortNoCarrier : WordBool;
      procedure SetAbortNoCarrier(Value : WordBool);
      function  GetAsciiSuppressCtrlZ : WordBool;
      procedure SetAsciiSuppressCtrlZ(Value : WordBool);
      function  GetUpcaseFileNames : WordBool;
      procedure SetUpcaseFileNames(Value : WordBool);
      function  GetBatch : WordBool;
      function  GetBlockLength : Integer;
      function  GetBlockNumber : Integer;
      function  GetProtocolStatus : Integer;
      function  GetFileLength : Integer;
      function  GetFileDate : TDateTime;
      function  GetInitialPosition : Integer;
      function  GetStatusInterval : Integer;
      procedure SetStatusInterval(Value : Integer);
      function  GetInProgress : WordBool;
      function  GetBlockErrors : Integer;
      function  GetTotalErrors : Integer;
      function  GetBytesRemaining : Integer;
      function  GetBytesTransferred : Integer;
      function  GetElapsedTicks : Integer;
      function  GetReceiveFileName : WideString;
      procedure SetReceiveFileName(const Value : WideString);
      function  GetXYmodemBlockWait : Integer;
      procedure SetXYmodemBlockWait(Value : Integer);
      function  GetZmodemOptionOverride : WordBool;
      procedure SetZmodemOptionOverride(Value : WordBool);
      function  GetZmodemSkipNoFile : WordBool;
      procedure SetZmodemSkipNoFile(Value : WordBool);
      function  GetZmodemFileOptions : TZmodemFileOptions;
      procedure SetZmodemFileOptions(Value : TZmodemFileOptions);
      function  GetZmodemRecover : WordBool;
      procedure SetZmodemRecover(Value : WordBool);
      function  GetZmodem8K : WordBool;
      procedure SetZmodem8K(Value : WordBool);
      function  GetZmodemFinishRetry : Integer;
      procedure SetZmodemFinishRetry(Value : Integer);
      function  GetKermitMaxLen : Integer;
      procedure SetKermitMaxLen(Value : Integer);
      function  GetKermitMaxWindows : Integer;
      procedure SetKermitMaxWindows(Value : Integer);
      function  GetKermitSWCTurnDelay : Integer;
      procedure SetKermitSWCTurnDelay(Value : Integer);
      function  GetKermitTimeoutSecs : Integer;
      procedure SetKermitTimeoutSecs(Value : Integer);
      function  GetKermitPadCharacter : Integer;
      procedure SetKermitPadCharacter(Value : Integer);
      function  GetKermitPadCount : Integer;
      procedure SetKermitPadCount(Value : Integer);
      function  GetKermitTerminator : Integer;
      procedure SetKermitTerminator(Value : Integer);
      function  GetKermitCtlPrefix : Integer;
      procedure SetKermitCtlPrefix(Value : Integer);
      function  GetKermitHighbitPrefix : Integer;
      procedure SetKermitHighbitPrefix(Value : Integer);
      function  GetKermitRepeatPrefix : Integer;
      procedure SetKermitRepeatPrefix(Value : Integer);
      function  GetKermitWindowsTotal : Integer;
      function  GetKermitWindowsUsed : Integer;
      function  GetKermitLongBlocks : WordBool;
      function  GetAsciiCharDelay : Integer;
      procedure SetAsciiCharDelay(Value : Integer);
      function  GetAsciiLineDelay : Integer;
      procedure SetAsciiLineDelay(Value : Integer);
      function  GetAsciiEOLChar : Integer;
      procedure SetAsciiEOLChar(Value : Integer);
      function  GetAsciiCRTranslation : TAsciiEOLTranslation;
      procedure SetAsciiCRTranslation(Value : TAsciiEOLTranslation);
      function  GetAsciiLFTranslation : TAsciiEOLTranslation;
      procedure SetAsciiLFTranslation(Value : TAsciiEOLTranslation);
      function  GetAsciiEOFTimeout : Integer;
      procedure SetAsciiEOFTimeout(Value : Integer);

      { statusbar }
      procedure SetCaption(const Value : WideString);
      procedure SetCaptionAlignment(Value : TAlignment);
      procedure SetCaptionWidth(Value : Integer);
      procedure SetLitColor(Value : TColor);
      procedure SetNotLitColor(Value : TColor);
      procedure SetShowLightCaptions(Value : WordBool);
      procedure SetLightWidth(Value : Integer);
      procedure SetShowLights(Value : WordBool);
      procedure SetShowStatusBar(Value : WordBool);

      { toolbar }
      procedure SetShowToolBar(Value : WordBool);
      procedure SetShowDeviceSelButton(Value : WordBool);
      procedure SetShowConnectButtons(Value : WordBool);
      procedure SetShowProtocolButtons(Value : WordBool);
      procedure SetShowTerminalButtons(Value : WordBool);

      { MSComm Compatibilty }
      function  GetMSCommBreak : WordBool;
      procedure SetMSCommBreak(Value : WordBool);
      function  GetMSCommCDHolding : WordBool;
      function  GetMSCommCommEvent : Smallint;
      function  GetMSCommCommPort : Smallint;
      procedure SetMSCommCommPort(Value : Smallint);
      function  GetMSCommCompatible : WordBool;
      procedure SetMSCommCompatible(Value : WordBool);
      function  GetMSCommCTSHolding : WordBool;
      function  GetMSCommDSRHolding : WordBool;
      function  GetMSCommDTREnable : WordBool;
      procedure SetMSCommDTREnable(Value : WordBool);
      function  GetMSCommHandshaking : Integer;
      procedure SetMSCommHandshaking(Value : Integer);
      function  GetMSCommInBufferSize : Smallint;
      procedure SetMSCommInBufferSize(Value : Smallint);
      function  GetMSCommInBufferCount : Smallint;
      procedure SetMSCommInBufferCount(Value : Smallint);
      function  GetMSCommInput : OleVariant;
      function  GetMSCommInputLen : Smallint;
      procedure SetMSCommInputLen(Value : Smallint);
      function  GetMSCommInputMode : Integer;
      procedure SetMSCommInputMode(Value : Integer);
      function  GetMSCommOutBufferSize : Smallint;
      procedure SetMSCommOutBufferSize(Value : Smallint);
      function  GetMSCommOutBufferCount : Smallint;
      procedure SetMSCommOutBufferCount(Value : Smallint);
      procedure SetMSCommOutput(Value : OleVariant);
      function  GetMSCommRTSEnable : WordBool;
      procedure SetMSCommRTSEnable(Value : WordBool);
      procedure SetMSCommRTThreshold(Value : Smallint);
      function  GetMSCommRTThreshold : Smallint;
      function  GetMSCommSettings : WideString;
      procedure SetMSCommSettings(Value : WideString);
      procedure SetMSCommSThreshold(Value : Smallint);
      function  GetMSCommSThreshold : Smallint;

      { misc internal methods }
      procedure CreateStatusBar;
      procedure FreeStatusBar;
      procedure CreateToolBar;
      procedure FreeToolBar;
      procedure AddToolButton(ID : TApxToolBtnID);
      procedure RemoveToolButton(ID : TApxToolBtnID);
      function  AddToolButtonSeparator(AWidth : Integer) : TToolButton;
      procedure AddLight(ID : TApxLightID);
      function  ChangeLight(ID : TApxLightID; NewValue : Boolean) : Boolean;
      procedure RemoveLight(ID : TApxLightID);
      procedure UpdateEndPanel;
      procedure CreateWnd; override;
      procedure CMInitApax(var Msg : TMessage); message CM_INITAPAX;
      procedure CMWinsockEvent(var Msg : TMessage); message CM_WINSOCKEVENT;
      procedure CMProtocolEvent(var Msg : TMessage); message CM_PROTOCOLEVENT;
      procedure CMPortCloseEvent(var Msg : TMessage); message CM_PORTCLOSEVENT;


    public { methods }
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      { connection methods }
      function PortOpen : Integer;
      function TapiDial : Integer;
      function TapiAnswer : Integer;
      function WinsockConnect : Integer;
      function WinsockListen : Integer;
      function Close : Integer;

      { com port public methods }
      procedure AddStringToLog(const S : WideString);
      procedure FlushInBuffer;
      procedure FlushOutBuffer;
      function  GetData(Size : Integer) : OleVariant;
      function  IsPortAvail(ComNumber : Integer) : WordBool;             {!!.01}
      function  IsPortInstalled(ComNumber : Integer) : WordBool;         {!!.01}
      function  PutData(Data : OleVariant) : Integer;                    {!!.01}
      function  PutString(const S : WideString) : Integer;               {!!.01}
      function  PutStringCRLF(const S : WideString) : Integer;           {!!.01}
      procedure SendBreak(Ticks : Integer; Yield : WordBool);

      { data trigger public methods }
      function  AddDataTrigger(const TriggerString : WideString; PacketSize, Timeout : Integer; IncludeStrings, IgnoreCase : WordBool) : Integer;
      procedure DisableDataTrigger(Index : Integer);
      procedure EnableDataTrigger(Index : Integer);
      procedure RemoveDataTrigger(Index : Integer);
      procedure RemoveAllDataTriggers;

      { terminal public methods }
      procedure Clear;
      procedure ClearAll;
      procedure CopyToClipboard;
      function  GetAttributes(aRow, aCol : Integer) : Integer;
      procedure SetAttributes(aRow, aCol, Value : Integer);
      function  GetLine(Index : Integer): WideString;
      procedure SetLine(Index : Integer ; const Value : WideString);
      procedure TerminalSetFocus;
      procedure TerminalWriteString(const S : WideString);
      procedure TerminalWriteStringCRLF(const S : WideString);

      { tapi device public methods }
      procedure TapiAutoAnswer;
      procedure TapiCancelCall;
      procedure TapiConfigAndOpen;
      procedure TapiPlayWaveFile(const FileName : WideString);
      procedure TapiRecordWaveFile(const FileName : WideString; Overwrite : WordBool);
      function  TapiSelectDevice : WordBool;{!!.01}
      procedure TapiSendTone(const Digits : WideString);
      procedure TapiSetRecordingParams(NumChannels : Integer; NumSamplesPerSecond : Integer; NumBitsPerSample : Integer);
      procedure TapiShowConfigDialog(AllowEdit : WordBool);
      function  TapiStatusMsg(const Message, State, Reason : Integer) : WideString;
      procedure TapiStopWaveFile;
      function  TapiTranslatePhoneNo(const CanonicalAddr : WideString) : WideString;
      function  TapiTranslateDialog(const CanonicalAddr : WideString) : WordBool; {!!.01}
      function  EnumTapiFirst : WideString;                              {!!.01}
      function  EnumTapiNext : WideString;                               {!!.01}
      procedure TapiLoadConfig(const RegKey, KeyName : WideString);      {!!.11}
      procedure TapiSaveConfig(const RegKey, KeyName : WideString);      {!!.11}
      function  GetTapiConfig : OleVariant;                              {!!.11}
      procedure SetTapiConfig(Config : OleVariant);                      {!!.11}
      
      { protocol public methods }
      procedure CancelProtocol;
      function  EstimateTransferSecs(const Size : Integer) : Integer;
      procedure StartTransmit;
      procedure StartReceive;

      { general public methods }
      function  ErrorMsg(ErrorCode : Integer) : WideString;              {!!.01}
      function  ErrorMsgEx(ErrorCode : Integer; LangIniFile : WideString) : WideString;{!!.01}
      procedure DelayTicks(Ticks : Integer);                             {!!.01}
    public { properties }
      { com port run-time read-only properties }
      property CTS         : WordBool read GetCTS;
      property DCD         : WordBool read GetDCD;
      property DSR         : WordBool read GetDSR;
      property FlowState   : TFlowControlState read GetFlowState;
      property InBuffUsed  : Integer read GetInBuffUsed;
      property InBuffFree  : Integer read GetInBuffFree;
      property LineError   : Integer read GetLineError;
      property OutBuffFree : Integer read GetOutBuffFree;
      property OutBuffUsed : Integer read GetOutBuffUsed;
      property RI          : WordBool read GetRI;

      { com port run-time read/write properties }
      property Connected : Boolean read FConnected;

      { tapi device run-time read-only properties }
      property TapiAttempt   : Integer read GetAttempt;
      property CallerID      : WideString read GetCallerID;
      property TapiCancelled : WordBool read GetCancelled;
      property Dialing       : WordBool read GetDialing;
      property TapiState     : TTapiState read GetTapiState;
      property WaveFileName  : WideString read GetWaveFileName;
      property WaveState     : TWaveState read GetWaveState;
      property TapiFailCode  : Integer read GetTapiFailCode;             {!!.01}

      { protocol run-time read-only properties }
      property Batch              : WordBool read GetBatch;
      property BlockErrors        : Integer read GetBlockErrors;
      property BlockLength        : Integer read GetBlockLength;
      property BlockNumber        : Integer read GetBlockNumber;
      property BytesRemaining     : Integer read GetBytesRemaining;
      property BytesTransferred   : Integer read GetBytesTransferred;
      property ElapsedTicks       : Integer read GetElapsedTicks;
      property FileDate           : TDateTime read GetFileDate;
      property FileLength         : Integer read GetFileLength;
      property InProgress         : WordBool read GetInProgress;
      property InitialPosition    : Integer read GetInitialPosition;
      property KermitLongBlocks   : WordBool read GetKermitLongBlocks;
      property KermitWindowsTotal : Integer read GetKermitWindowsTotal;
      property KermitWindowsUsed  : Integer read GetKermitWindowsUsed;
      property ProtocolStatus     : Integer read GetProtocolStatus;
      property TotalErrors        : Integer read GetTotalErrors;

      { Winsock local address run-time read-only properties }
      property WsLocalVersion      : Widestring read GetWsLocalVersion;  {!!.01}
      property WsLocalHighVersion  : Widestring read GetWsLocalHighVersion;{!!.01}
      property WsLocalDescription  : WideString read GetWsLocalDescription;{!!.01}
      property WsLocalSystemStatus : WideString read GetWsLocalSystemStatus;{!!.01}
      property WsLocalMaxSockets   : Integer read GetWsLocalMaxSockets;  {!!.01}
      property WsLocalHost         : WideString read GetWsLocalHost;     {!!.01}
      property WsLocalAddress      : WideString read GetWsLocalAddress;  {!!.01}

      { MSComm Compatibilty run-time properties }
      property MSCommBreak          : WordBool read GetMSCommBreak write SetMSCommBreak;
      property MSCommCDHolding      : WordBool read GetMSCommCDHolding;
      property MSCommCommEvent      : Smallint read GetMSCommCommEvent;
      property MSCommCTSHolding     : WordBool read GetMSCommCTSHolding;
      property MSCommDSRHolding     : WordBool read GetMSCommDSRHolding;
      property MSCommInBufferCount  : Smallint read GetMSCommInBufferCount write SetMSCommInBufferCount;
      property MSCommInput          : OleVariant read GetMSCommInput;
      property MSCommOutBufferCount : Smallint read GetMSCommOutBufferCount write SetMSCommOutBufferCount;
      property MSCommOutput         : OleVariant write SetMSCommOutput;

      property FTPClient            : TApxFTPClient read FFTPClient write FFTPClient;
    published { properties }
      { com port published properties }
      property Baud             : Integer read GetBaud write SetBaud;
      property ComNumber        : Integer read GetComNumber write SetComNumber;
      property DeviceType       : TApxDeviceType read FDeviceType write SetDeviceType;
      property DataBits         : Integer read GetDataBits write SetDataBits;
      property DTR              : WordBool read GetDTR write SetDTR;
      property HWFlowUseDTR     : WordBool read GetHWFlowUseDTR write SetHWFlowUseDTR;
      property HWFlowUseRTS     : WordBool read GetHWFlowUseRTS write SetHWFlowUseRTS;
      property HWFlowRequireDSR : WordBool read GetHWFlowRequireDSR write SetHWFlowRequireDSR;
      property HWFlowRequireCTS : WordBool read GetHWFlowRequireCTS write SetHWFlowRequireCTS;
      property InBuffSize       : Integer read GetInSize write SetInSize;
      property LogAllHex        : WordBool read GetLogAllHex write SetLogAllHex;
      property Logging          : TTraceLogState read GetLogging write SetLogging;
      property LogHex           : WordBool read GetLogHex write SetLogHex;
      property LogName          : WideString read GetLogName write SetLogName;
      property LogSize          : Integer read GetLogSize write SetLogSize;
      property OutBuffSize      : Integer read GetOutSize write SetOutSize;
      property Parity           : TParity read GetParity write SetParity;
      property PromptForPort    : WordBool read GetPromptForPort write SetPromptForPort;
      property RS485Mode        : WordBool read GetRS485Mode write SetRS485Mode;
      property RTS              : WordBool read GetRTS write SetRTS;
      property StopBits         : Integer read GetStopBits write SetStopBits;
      property SWFlowOptions    : TSWFlowOptions read GetSWFlowOptions write SetSWFlowOptions;
      property XOffChar         : Integer read GetXOffChar write SetXOffChar;
      property XOnChar          : Integer read GetXOnChar write SetXOnChar;

      { winsock published properties }
      property WinsockMode       : TWsMode read GetWinsockMode write SetWinsockMode;
      property WinsockAddress    : WideString read GetWinsockAddress write SetWinsockAddress;
      property WinsockPort       : WideString read GetWinsockPort write SetWinsockPort;
      property WsTelnet          : WordBool read GetWsTelnet write SetWsTelnet;

      { tapi device published properties }
      property AnswerOnRing      : Integer read GetAnswerOnRing write SetAnswerOnRing;
      property EnableVoice       : WordBool read GetEnableVoice write SetEnableVoice;
      property MaxAttempts       : Integer read GetMaxAttempts write SetMaxAttempts;
      property InterruptWave     : WordBool read GetInterruptWave write SetInterruptWave;
      property MaxMessageLength  : Integer read GetMaxMessageLength write SetMaxMessageLength;
      property SelectedDevice    : WideString read GetSelectedDevice write SetSelectedDevice;
      property SilenceThreshold  : Integer read GetSilenceThreshold write SetSilenceThreshold;
      property TapiNumber        : WideString read FTapiNumber write FTapiNumber;
      property TapiRetryWait     : Integer read GetRetryWait write SetRetryWait;
      property TrimSeconds       : Integer read GetTrimSeconds write SetTrimSeconds;
      property TapiStatusDisplay : WordBool read GetTapiStatusDisplay write SetTapiStatusDisplay;
      property UseSoundCard      : WordBool read GetUseSoundCard write SetUseSoundCard;
      property FilterTapiDevices : WordBool                       {!!.12}
                 read GetFilterTapiDevices
                 write SetFilterTapiDevices;

      { terminal published properties }
      property Align;
      property CaptureFile            : WideString read GetCaptureFile write SetCaptureFile;
      property CaptureMode            : TAdCaptureMode read GetCaptureMode write SetCaptureMode;
      property Color                  : TColor read FColor write SetTerminalColor;
      property Columns                : Integer read GetColumns write SetColumns;
      property Emulation              : TApxTerminalEmulation read GetEmulation write SetEmulation;
      property Font                   : TFont read GetFont write SetFont;
      property Rows                   : Integer read GetRows write SetRows;
      property ScrollbackEnabled      : WordBool read GetScrollback write SetScrollback;
      property ScrollbackRows         : Integer read GetScrollbackRows write SetScrollbackRows;
      property TerminalActive         : WordBool read GetActive write SetActive;
      property TerminalBlinkTime      : Integer read GetBlinkTime write SetBlinkTime;
      property TerminalHalfDuplex     : WordBool read GetHalfDuplex write SetHalfDuplex;
      property TerminalLazyByteDelay  : Integer read GetLazyByteDelay write SetLazyByteDelay;
      property TerminalLazyTimeDelay  : Integer read GetLazyTimeDelay write SetLazyTimeDelay;
      property TerminalUseLazyDisplay : WordBool read GetUseLazyDisplay write SetUseLazyDisplay;
      property TerminalWantAllKeys    : WordBool read GetWantAllKeys write SetWantAllKeys;
      property Version                : WideString read GetVersion write SetVersion;
      property Visible;

      { data packet published properties }
      property DataTriggerString : WideString read GetDataTriggerString write SetDataTriggerString;

      { protocol published properties }
      property ProtocolStatusDisplay : WordBool read GetProtocolStatusDisplay write SetProtocolStatusDisplay;
      property Protocol              : TProtocolType read GetProtocolType write SetProtocolType;
      property AbortNoCarrier        : WordBool read GetAbortNoCarrier write SetAbortNoCarrier;
      property AsciiCharDelay        : Integer read GetAsciiCharDelay write SetAsciiCharDelay;
      property AsciiCRTranslation    : TAsciiEOLTranslation read GetAsciiCRTranslation write SetAsciiCRTranslation;
      property AsciiEOFTimeout       : Integer read GetAsciiEOFTimeout write SetAsciiEOFTimeout;
      property AsciiEOLChar          : Integer read GetAsciiEOLChar write SetAsciiEOLChar;
      property AsciiLFTranslation    : TAsciiEOLTranslation read GetAsciiLFTranslation write SetAsciiLFTranslation;
      property AsciiLineDelay        : Integer read GetAsciiLineDelay write SetAsciiLineDelay;
      property AsciiSuppressCtrlZ    : WordBool read GetAsciiSuppressCtrlZ write SetAsciiSuppressCtrlZ;
      property BlockCheckMethod      : TBlockCheckMethod  read GetBlockCheckMethod write SetBlockCheckMethod;
      property FinishWait            : Integer read GetFinishWait write SetFinishWait;
      property HandshakeRetry        : Integer read GetHandshakeRetry write SetHandshakeRetry;
      property HandshakeWait         : Integer read GetHandshakeWait write SetHandshakeWait;
      property HonorDirectory        : WordBool read GetHonorDirectory write SetHonorDirectory;
      property IncludeDirectory      : WordBool read GetIncludeDirectory write SetIncludeDirectory;
      property KermitCtlPrefix       : Integer read GetKermitCtlPrefix write SetKermitCtlPrefix;
      property KermitHighbitPrefix   : Integer read GetKermitHighbitPrefix write SetKermitHighbitPrefix;
      property KermitMaxLen          : Integer read GetKermitMaxLen write setKermitMaxLen;
      property KermitMaxWindows      : Integer read GetKermitMaxWindows write SetKermitMaxWindows;
      property KermitPadCharacter    : Integer read GetKermitPadCharacter write SetKermitPadCharacter;
      property KermitPadCount        : Integer read GetKermitPadCount write SetKermitPadCount;
      property KermitRepeatPrefix    : Integer read GetKermitRepeatPrefix write SetKermitRepeatPrefix;
      property KermitSWCTurnDelay    : Integer read GetKermitSWCTurnDelay write SetKermitSWCTurnDelay;
      property KermitTerminator      : Integer read GetKermitTerminator write SetKermitTerminator;
      property KermitTimeoutSecs     : Integer read GetKermitTimeoutSecs write SetKermitTimeoutSecs;
      property ReceiveDirectory      : WideString read GetReceiveDirectory write SetReceiveDirectory;
      property ReceiveFileName       : WideString read GetReceiveFileName write SetReceiveFileName;
      property RTSLowForWrite        : WordBool read GetRTSLowForWrite write SetRTSLowForWrite;
      property SendFileName          : WideString read GetSendFileName write SetSendFileName;
      property StatusInterval        : Integer read GetStatusInterval write SetStatusInterval;
      property TransmitTimeout       : Integer read GetTransmitTimeout write SetTransmitTimeout;
      property UpcaseFileNames       : WordBool read GetUpcaseFileNames write SetUpcaseFileNames;
      property WriteFailAction       : TWriteFailAction read GetWriteFailAction write SetWriteFailAction;
      property XYmodemBlockWait      : Integer read GetXYmodemBlockWait write SetXYmodemBlockWait;
      property Zmodem8K              : WordBool read GetZmodem8K write SetZmodem8K;
      property ZmodemFileOptions     : TZModemFileOptions read GetZmodemFileOptions write SetZmodemFileOptions;
      property ZmodemFinishRetry     : Integer read GetZmodemFinishRetry write SetZmodemFinishRetry;
      property ZmodemOptionOverride  : WordBool read GetZmodemOptionOverride write SetZmodemOptionOverride;
      property ZmodemRecover         : WordBool read GetZmodemRecover write SetZmodemRecover;
      property ZmodemSkipNoFile      : WordBool read GetZmodemSkipNoFile write SetZmodemSkipNoFile;

      { statusbar published properties }
      property Caption           : WideString read FCaption write SetCaption;
      property CaptionAlignment  : TAlignment read FCaptionAlignment write SetCaptionAlignment;
      property CaptionWidth      : Integer read FCaptionWidth write SetCaptionWidth;
      property LightWidth        : Integer read FLightWidth write SetLightWidth;
      property LightsLitColor    : TColor read FLitColor write SetLitColor;
      property LightsNotLitColor : TColor read FNotLitColor write SetNotLitColor;
      property ShowLightCaptions : WordBool read FShowLightCaptions write SetShowLightCaptions;
      property ShowLights        : WordBool read FShowLights write SetShowLights;
      property ShowStatusBar     : WordBool read FShowStatusBar write SetShowStatusBar;

      { toolbar published properties }
      property ShowToolBar         : WordBool read FShowToolBar write SetShowToolBar;
      property ShowDeviceSelButton : WordBool read FShowDeviceSelButton write SetShowDeviceSelButton;
      property ShowConnectButtons  : WordBool read FShowConnectButtons write SetShowConnectButtons;
      property ShowProtocolButtons : WordBool read FShowProtocolButtons write SetShowProtocolButtons;
      property ShowTerminalButtons : WordBool read FShowTerminalButtons write SetShowTerminalButtons;

      { MSComm Compatibilty published properties }
      property MSCommCommPort      : Smallint read GetMSCommCommPort write SetMSCommCommPort;
      property MSCommCompatible    : WordBool read GetMSCommCompatible write SetMSCommCompatible;
      property MSCommDTREnable     : WordBool read GetMSCommDTREnable write SetMSCommDTREnable;
      property MSCommHandshaking   : Integer read GetMSCommHandshaking write SetMSCommHandshaking;
      property MSCommInBufferSize  : Smallint read GetMSCommInBufferSize write SetMSCommInBufferSize;
      property MSCommInputLen      : Smallint read GetMSCommInputLen write SetMSCommInputLen;
      property MSCommInputMode     : Integer read GetMSCommInputMode write SetMSCommInputMode;
      property MSCommOutBufferSize : Smallint read GetMSCommOutBufferSize write SetMSCommOutBufferSize;
      property MSCommRTSEnable     : WordBool read GetMSCommRTSEnable write SetMSCommRTSEnable;
      property MSCommRTThreshold   : Smallint read GetMSCommRTThreshold write SetMSCommRTThreshold;
      property MSCommSettings      : WideString read GetMSCommSettings write SetMSCommSettings;
      property MSCommSThreshold    : Smallint read GetMSCommSThreshold write SetMSCommSThreshold;


    published { events }
      { com port published events }
      property OnCTSChanged : TApxStatusChangedEvent read FOnCTSChanged write FOnCTSChanged;
      property OnDCDChanged : TApxStatusChangedEvent read FOnDCDChanged write FOnDCDChanged;
      property OnDSRChanged : TApxStatusChangedEvent read FOnDSRChanged write FOnDSRChanged;
      property OnLineBreak  : TApxNotifyEvent read FOnLineBreak write FOnLineBreak;
      property OnLineError  : TApxNotifyEvent read FOnLineError write FOnLineError;
      property OnPortClose  : TApxNotifyEvent read FOnPortClose write FOnPortClose;
      property OnPortOpen   : TApxNotifyEvent read FOnPortOpen write FOnPortOpen;
      property OnRing       : TApxNotifyEvent read FOnRing write FOnRing;
      property OnRXD        : TApxDataReceivedEvent read FOnRXD write FOnRXD;

      { winsock published events }
      property OnWinsockAccept     : TApxWinsockAcceptEvent read FOnWinsockAccept write FOnWinsockAccept;
      property OnWinsockConnect    : TApxNotifyEvent read FOnWinsockConnect write FOnWinsockConnect;
      property OnWinsockDisconnect : TApxNotifyEvent read FOnWinsockDisconnect write FOnWinsockDisconnect;
      property OnWinsockError      : TApxWinsockErrorEvent read FOnWinsockError write FOnWinsockError;
      property OnWinsockGetAddress : TApxWinsockAddressEvent read FOnWinsockGetAddress write FOnWinsockGetAddress;

      { data packet published events }
      property OnDataTrigger : TApxDataTriggerEvent read FOnDataTrigger write FOnDataTrigger;

      { tapi device published events }
      property OnTapiCallerID    : TApxTapiCallerIDEvent read FOnTapiCallerID write FOnTapiCallerID;
      property OnTapiConnect     : TApxTapiNotifyEvent read FOnTapiConnect write FOnTapiConnect;
      property OnTapiDTMF        : TApxTapiDTMFEvent read FOnTapiDTMF write FOnTapiDTMF;
      property OnTapiFail        : TApxTapiNotifyEvent read FOnTapiFail write FOnTapiFail;
      property OnTapiGetNumber   : TApxTapiNumberEvent read FOnTapiGetNumber write FOnTapiGetNumber;
      property OnTapiPortClose   : TApxTapiNotifyEvent read FOnTapiPortClose write FOnTapiPortClose;
      property OnTapiPortOpen    : TApxTapiNotifyEvent read FOnTapiPortOpen write FOnTapiPortOpen;
      property OnTapiStatus      : TApxTapiStatusEvent read FOnTapiStatus write FOnTapiStatus;
      property OnTapiWaveNotify  : TApxTapiWaveNotifyEvent read FOnTapiWaveNotify write FOnTapiWaveNotify;
      property OnTapiWaveSilence : TApxTapiWaveSilenceEvent read FOnTapiWaveSilence write FOnTapiWaveSilence;

      { terminal published events }
      property OnCursorMoved : TApxCursorMovedEvent read FOnCursorMoved write FOnCursorMoved;
      property OnProcessChar : TApxProcessCharEvent read FOnProcessChar write FOnProcessChar;

      { protocol published events }
      property OnProtocolAccept : TApxProtocolAcceptEvent read FOnProtocolAccept write FOnProtocolAccept;
      property OnProtocolFinish : TApxProtocolFinishEvent read FOnProtocolFinish write FOnProtocolFinish;
      property OnProtocolLog    : TApxProtocolLogEvent read FOnProtocolLog write FOnProtocolLog;
      property OnProtocolStatus : TApxProtocolStatusEvent read FOnProtocolStatus write FOnProtocolStatus;

      { toolbar published events }
      property OnConnectButtonClick : TApxToolButtonClickEvent read FOnConnectButtonClick write FOnConnectButtonClick;
      property OnListenButtonClick  : TApxToolButtonClickEvent read FOnListenButtonClick  write FOnListenButtonClick ;
      property OnCloseButtonClick   : TApxToolButtonClickEvent read FOnCloseButtonClick   write FOnCloseButtonClick  ;
      property OnDeviceButtonClick  : TApxDeviceButtonClickEvent read FOnDeviceButtonClick  write FOnDeviceButtonClick ;
      property OnSendButtonClick    : TApxToolButtonClickEvent read FOnSendButtonClick    write FOnSendButtonClick   ;
      property OnReceiveButtonClick : TApxToolButtonClickEvent read FOnReceiveButtonClick write FOnReceiveButtonClick;
      property OnFontButtonClick    : TApxToolButtonClickEvent read FOnFontButtonClick    write FOnFontButtonClick   ;
      property OnEmulationButtonClick : TApxEmulationButtonClickEvent read FOnEmulationButtonClick  write FOnEmulationButtonClick ;

      { MSComm Compatibility events }
      property MSCommOnCommEvent : TApxNotifyEvent read FMSCommOnCommEvent write FMSCommOnCommEvent;

  end;

{ misc public routines }
procedure ParseDataTriggerString(const DataTriggerString : string; List : TStringList);


implementation

uses
  AdSelCom, AxTSel, AxWsSel, AdExcept, Dialogs, Registry;

{$R *.RES} // icons for the buttons

const { default values }
  DefMainPanelHeight   = 350;
  DefMainPanelWidth    = 510;
  DefToolbarHeight     = 20;
  DefCaptionAlignment  = taCenter;
  DefCaptionWidth      = 100;
  DefLightWidth        = 40;
  DefNotLitColor       = clTeal;
  DefLitColor          = clRed;
  DefTerminalColor     = clNavy;
  DefDeviceType        = dtDirect;
  DefProtocolType      = ptZmodem;
  DefStatusFlags       = msCTSDelta or msDSRDelta or msRingDelta or msDCDDelta;
  DefLineErrorFlags    = lsOverrun or lsParity or lsFraming or lsBreak;
  DefBRKDuration       = 36;
  DefERRDuration       = 36;
  DefRNGDuration       = 8;
  DefRXDDuration       = 1;
  DefTXDDuration       = 1;


const { text arrays }
  LightText : array[TApxLightID] of string =
    ('BRK', 'CTS', 'DCD', 'DSR', 'ERR', 'RNG', 'RXD', 'TXD');
  ToolBtnText : array[TApxToolBtnID] of string =
    ('Dial', 'Listen', 'Close', 'Device', 'Send', '  Receive  ', 'Font', 'Emulation');
  ToolBtnHint : array[TApxToolBtnID] of string =
    ('Establish Outgoing Connection', 'Listen for Incoming Connection',
     'Close Connection', 'Select Device Type', 'Transmit File', 'Receive File',
     'Terminal Font', 'Terminal Emulation');
  DeviceTypeText : array[TApxDeviceType] of string =
    ('Direct', 'Tapi', 'Winsock');
  EmulationTypeText : array[TApxTerminalEmulation] of string =
    ('TTY', 'VT100');

const { MSComm compatibility constants - must match type library constants }
  { HandshakeConstants }
  comNone = $00000000;
  comXOnXoff = $00000001;
  comRTS = $00000002;
  comRTSXOnXOff = $00000003;

  { InputModeConstants }
  comInputModeText = $00000000;
  comInputModeBinary = $00000001;

  { CommEventConstants }
  comEventBreak = $000003E9;
  comEventCTSTO = $000003EA;
  comEventDSRTO = $000003EB;
  comEventFrame = $000003EC;
  comEventOverrun = $000003EE;
  comEventCDTO = $000003EF;
  comEventRxOver = $000003F0;
  comEventRxParity = $000003F1;
  comEventTxFull = $000003F2;

  { OnCommConstants }
  comEvSend = $00000001;
  comEvReceive = $00000002;
  comEvCTS = $00000003;
  comEvDSR = $00000004;
  comEvCD = $00000005;
  comEvRing = $00000006;

  { defaults }
  DefMSCommInBufferSize   = 1024;
  DefMSCommInputLen       = 0;
  DefMSCommInputMode      = comInputModeText;
  DefMSCommOutBufferSize  = 512;
  DefMSCommRTThreshold    = 0;
  DefMSCommSThreshold     = 0;


{ ======================================================================= }
{ == data trigger parsing routines ====================================== }
{ ======================================================================= }
function CharPos(C: AnsiChar; const S : string): Integer;
  { more efficient version of Pos for single character }
var
  i : Integer;
begin
  for i := 1 to length(S) do
    if (S[i] = C) then begin
      Result := i;
      Exit;
    end;
  Result := 0;
end;
{ ----------------------------------------------------------------------- }
procedure ParseTriggerString(const TriggerString : string; var StartString, EndString : string);
  { parse individual trigger string into StartString and EndString }
  function FindWildcard (AString : string) : Integer;                    {!!.12}
  var                                                                    {!!.12}
    Done : Boolean;                                                      {!!.12}
  begin                                                                  {!!.12}
    Done := False;                                                       {!!.12}
    Result := 0;                                                         {!!.12}
    while (not Done) and (AString <> '') do begin                        {!!.12}
      Result := CharPos ('*', AString);                                  {!!.12}
      if Result < 2 then                                                 {!!.12}
        Done := True                                                     {!!.12}
      else if AString[Result - 1] = '\' then                             {!!.12}
        AString := Copy (AString, Result + 1,                            {!!.12}
                         Length (AString) - Result)                      {!!.12}
      else                                                               {!!.12}
        Done := True;                                                    {!!.12}
    end;                                                                 {!!.12}
  end;                                                                   {!!.12}

var
  i : Integer;
begin
  StartString := '';
  EndString := '';
  if (TriggerString <> '') then begin
    {i := CharPos('*', TriggerString);}                                  {!!.12}
    i := FindWildcard (TriggerString);                                   {!!.12}
    if (i = 0) then
      StartString := TriggerString
    else begin
      if (i > 1) then
       StartString := Copy(TriggerString, 1, i-1);
      if (i {<}<= (Length(TriggerString)-1)) {and (i > 0)} then          {!!.12}
        EndString := Copy(TriggerString, i + 1, Length(TriggerString));
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure ParseDataTriggerString(const DataTriggerString : string; List : TStringList);
  { parse concatenated trigger strings into list of individual trigger strings }
var
  Str, S : string;
  i : Integer;
begin
  Str := DataTriggerString;
  while (Str <> '') do begin
    i := CharPos('|', Str);
    if (i > 0) then
      S := Copy(Str, 1, i-1)
    else
      S := Str;
    List.Add(S);
    System.Delete(Str, 1, Length(S)+1);
  end;
end;


{ ======================================================================= }
{ == TApxDataTriggers =================================================== }
{ ======================================================================= }
constructor TApxDataTriggers.Create(AOwner : TComponent;
                                    APort : TApdCustomWinsockPort;
                                    OnPacket : TPacketNotifyEvent;
                                    OnTimeout : TNotifyEvent);
begin
  inherited Create;
  FOwner := AOwner;
  FPort := APort;
  FOnPacket := OnPacket;
  FOnTimeout := OnTimeout;
  FList := TStringList.Create;
end;
{ ----------------------------------------------------------------------- }
destructor TApxDataTriggers.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;
{ ----------------------------------------------------------------------- }
function TApxDataTriggers.GetDataTriggerString : string;
var
  i : Integer;
begin
  Result := '';
  if FList.Count > 0 then
    for i := 0 to Pred(FList.Count) do begin
      if (i > 0) then
        Result := Result + '|';
      Result := Result + FList[i];
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxDataTriggers.SetDataTriggerString(const Value : string);
var
  TriggerStrings : TStringList;
  i : Integer;
begin
  Clear;
  if (Value <> '') then begin
    TriggerStrings := TStringList.Create;
    try
      ParseDataTriggerString(Value, TriggerStrings);
      if (TriggerStrings.Count > 0) then
        for i := 0 to Pred(TriggerStrings.Count) do
          Add(TriggerStrings[i], 0, 0, True, True);
    finally
      TriggerStrings.Free;
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxDataTriggers.Add(const TriggerString : string;
                              PacketSize, Timeout : Integer;
                              IncludeStrings, IgnoreCase : Boolean) : Integer;
var
  Pkt : TApdDataPacket;
  SS, ES : string;
begin
  Pkt := TApdDataPacket.Create(FOwner);
  Pkt.ComPort := FPort;
  Pkt.OnPacket := FOnPacket;
  Pkt.OnTimeout := FOnTimeout;
  Pkt.EndCond := [];
  Pkt.AutoEnable := False;
  Pkt.Tag := FList.Count;
  Pkt.Name := 'Index' + IntToStr(Pkt.Tag);
  ParseTriggerString(TriggerString, SS, ES);
  Pkt.StartString := SS;
  Pkt.EndString := ES;
  if (Pkt.StartString = '') then
    Pkt.StartCond := scAnyData
  else
    Pkt.StartCond := scString;

  if (Pkt.EndString <> '') then
    Pkt.EndCond := Pkt.EndCond + [ecString];

  Pkt.PacketSize := PacketSize;
  if (Pkt.PacketSize > 0) then
    Pkt.EndCond := Pkt.EndCond + [ecPacketSize];

  Pkt.Timeout := 0; {Timeout;}                                           {!!.11}
  Pkt.EnableTimeout := Timeout;                                          {!!.11}
  Pkt.IncludeStrings := IncludeStrings;
  Pkt.IgnoreCase := IgnoreCase;
  Result := FList.AddObject(TriggerString, Pkt);
  Pkt.Enabled := True;
end;
{ ----------------------------------------------------------------------- }
procedure TApxDataTriggers.Clear;
begin
  while FList.Count > 0 do
    Delete(0);
end;
{ ----------------------------------------------------------------------- }
procedure TApxDataTriggers.Delete(Index : Integer);
var
  i : Integer;
begin
  if (Index >= 0) and (Index < FList.Count) then begin
    if Assigned(FList.Objects[Index]) then begin
      TApdDataPacket(FList.Objects[Index]).Enabled := False;             {!!.12}
      TApdDataPacket(FList.Objects[Index]).Free;
    end;
    FList.Delete(Index);

    { adjust index tag of the packets following the deleted item }
    if (Index < FList.Count) then
      for i := Index to Pred(FList.Count) do
        TApdDataPacket(FList.Objects[Index]).Tag := i;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxDataTriggers.Enable(Index : Integer);
begin
  if (Index >= 0) and (Index < FList.Count) then
    if Assigned(FList.Objects[Index]) then
      TApdDataPacket(FList.Objects[Index]).Enabled := True;
end;
{ ----------------------------------------------------------------------- }
procedure TApxDataTriggers.Disable(Index : Integer);
begin
  if (Index >= 0) and (Index < FList.Count) then
    if Assigned(FList.Objects[Index]) then
      TApdDataPacket(FList.Objects[Index]).Enabled := False;
end;


{ ====================================================================== }
{ == keyboard hook function ============================================ }
{ ====================================================================== }
{$IFDEF USEKEYHOOK}
var
  HookID : Cardinal;
  ApxTerminal : TApxTerminal;

function KeyHook(nCode : Integer; wParam, lParam : Longint) : Longint; stdcall;
begin
  if (ApxTerminal.FTerminal.Focused and ApxTerminal.FPort.Open)  then begin
    case wParam of
      13 : begin
             if ((lParam and $80000000) = 0) then
               ApxTerminal.PutStringCRLF('');
             Result := -1;
           end;
      27 : begin
             if ((lParam and $80000000) = 0) then
               ApxTerminal.PutString(chr(27));
             Result := -1;
           end;
      else
        Result := CallNextHookEx(HookID, nCode, wParam, lParam);
    end;
  end else
    Result := CallNextHookEx(HookID, nCode, wParam, lParam);

end;
{$ENDIF}

{ ======================================================================= }
{ == TApxTerminal ======================================================= }
{ ======================================================================= }
constructor TApxTerminal.Create(AOwner : TComponent);
var
  ID : TApxLightID;
begin
{$IFDEF DEBUGAPAX}
WriteDebug('-----------------------------------');
WriteDebug('TApxTerminal.Create');
{$ENDIF}
  inherited Create(AOwner);

  { keyboard hook }
  {$IFDEF USEKEYHOOK}
  ApxTerminal := Self;
  HookID := SetWindowsHookEx(WH_KEYBOARD, @KeyHook, 0, GetCurrentThreadID);
  {$ENDIF}

  { main component panel }
  Align := alNone;
  Height := DefMainPanelHeight;
  Width := DefMainPanelWidth;
  BorderStyle := bsSingle;

  { initialize com port }
  FPort := TApdCustomWinsockPort.Create(Self);
  FPort.AutoOpen := False;
  FPort.Open := False;
  FPort.OnPortOpen := DoPortOpen;
  FPort.OnPortClose := DoPortClose;
  FPort.OnTriggerAvail := DoTriggerAvail;
  FPort.OnTriggerLineError := DoTriggerLineError;
  FPort.OnTriggerModemStatus := DoTriggerModemStatus;
  FPort.OnTriggerOutSent := DoTriggerOutSent;
  FPort.OnTriggerTimer := DoTriggerTimer;
  FPort.OnWsAccept := DoWsAccept;
  FPort.OnWsConnect := DoWsConnect;
  FPort.OnWsDisconnect := DoWsDisconnect;
  FPort.OnWsError := DoWsError;
  FLineErrorFlags := DefLineErrorFlags;
  FStatusFlags := DefStatusFlags;
  FDeviceType := DefDeviceType;
  FMSCommCompatible := False;

  { initialize data triggers }
  FDataTriggers := TApxDataTriggers.Create(Self, FPort, DoPacketData, DoPacketTimeout);

  { initialize tapi device }
  FTapiDevice := TApdTapiDevice.Create(Self);
  FTapiStatus := TApdTapiStatus.Create(Self);
  FTapiDevice.StatusDisplay := FTapiStatus;
  FTapiStatus.TapiDevice := FTapiDevice;
  FTapiStatusDisplay := True;
  FTapiDevice.ComPort := FPort;
  FTapiDevice.ShowPorts := False;
  FTapiDevice.OnTapiCallerID := DoTapiCallerID;
  FTapiDevice.OnTapiConnect := DoTapiConnect;
  FTapiDevice.OnTapiDTMF := DoTapiDTMF;
  FTapiDevice.OnTapiFail := DoTapiFail;
  FTapiDevice.OnTapiPortClose := DoTapiPortClose;
  FTapiDevice.OnTapiPortOpen := DoTapiPortOpen;
  FTapiDevice.OnTapiStatus := DoTapiStatus;
  FTapiDevice.OnTapiWaveNotify := DoTapiWaveNotify;
  FTapiDevice.OnTapiWaveSilence := DoTapiWaveSilence;
  FTapiDevice.FilterUnsupportedDevices := True;                          {!!.12}

  { initialize protocol }
  FProtocol := TApdCustomProtocol.Create(Self);
  FProtocolStatus := TApdProtocolStatus.Create(Self);
  FProtocol.StatusDisplay := FProtocolStatus;
  FProtocolStatus.Protocol := FProtocol;
  FProtocolStatusDisplay := True;
  FProtocol.ComPort := FPort;
  FProtocol.OnProtocolFinish := DoProtocolFinish;
  FProtocol.OnProtocolLog := DoProtocolLog;
  FProtocol.OnProtocolStatus := DoProtocolStatus;
  FProtocol.OnProtocolAccept := DoProtocolAccept;
  FProtocol.ProtocolType := DefProtocolType;

  { terminal }
  FTerminal := TAdTerminal.Create(Self);
  FTerminal.Parent := Self;
  FTerminal.Align := alClient;
  FTerminal.ComPort := FPort;
  FTerminal.OnCursorMoved := DoCursorMoved;
  FCaptureMode := cmOff;
  FColor := DefTerminalColor;
  FTerminal.Color := FColor;
  FTTYEmulator := TAdTTYEmulator.Create(Self);;
  FTTYEmulator.OnProcessChar := DoProcessChar;
  FVT100Emulator := TAdVT100Emulator.Create(Self);
  FVT100Emulator.OnProcessChar := DoProcessChar;
  FTerminal.Emulator := FTTYEmulator;

  { statusbar and toolbar - initialize but do not create until container is ready }
  FOleContainerReady := False;

  { status bar }
  FLitColor := DefLitColor;
  FNotLitColor := DefNotLitColor;
  FLightWidth := DefLightWidth;
  FCaption := 'APAX ' + ApaxVersionStr;    { an error here means you need to rebuild }
  FCaptionAlignment := DefCaptionAlignment;
  FCaptionWidth := DefCaptionWidth;
  for ID := Low(TApxLightID) to High(TApxLightID) do
    FLights[ID].Enabled := True;
  FShowLights := True;
  FShowLightCaptions := True;
  FShowStatusBar := True;

  { tool bar }
  FShowToolbar := True;
  FShowDeviceSelButton := True;
  FShowConnectButtons  := True;
  FShowProtocolButtons := True;
  FShowTerminalButtons := True;

  { MSComm compatibility }
  FMSCommCompatible     := False;
  FMSCommInBuffer       := nil;

  FMSCommCommEvent      := 0;
  FMSCommInBufferSize   := DefMSCommInBufferSize;
  FMSCommInputLen       := DefMSCommInputLen;
  FMSCommInputMode      := DefMSCommInputMode;
  FMSCommOutBufferSize  := DefMSCommOutBufferSize;
  FMSCommRTThreshold    := DefMSCommRTThreshold;
  FMSCommSThreshold     := DefMSCommSThreshold;

  { FTP stuff }
  FFTPClient := TApxFTPClient.Create(Self);

end;
{ ----------------------------------------------------------------------- }
destructor TApxTerminal.Destroy;
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.Destroy');
{$ENDIF}
  Close;
  ShowStatusBar := False;
  ShowToolBar := False;
  if Assigned(FButtonImages) then
    FButtonImages.Free;
  FVT100Emulator.Free;
  FTTYEmulator.Free;
//  if Assigned(FTerminal.Emulator) then
//    FTerminal.Emulator.Free;
  FTerminal.Free;
  FProtocol.StatusDisplay.Free;
  FProtocol.Free;
  FTapiDevice.Free;
  FDataTriggers.Free;
  FFTPClient.Free;
  FPort.Free;
  if Assigned(FMSCommInBuffer) then
    FMSCommInBuffer.Free;
  {$IFDEF UseKeyHook}
  UnhookWindowsHookEx(HookID);
  HookID := 0;
  {$ENDIF}
  inherited Destroy;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.CreateWnd;
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.CreateWnd');
{$ENDIF}
  inherited CreateWnd;
  if not FOleContainerReady then begin
    FOleContainerReady := True;
    PostMessage(Handle, CM_INITAPAX, 0, 0);
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.CMInitApax(var Msg : TMessage);
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.CMInitApax' + IntToStr(Handle));
{$ENDIF}
  if (Msg.Msg = CM_INITAPAX) then begin
    if FShowStatusBar then begin
      CreateStatusBar;
      UpdateEndPanel;
    end;
    if FShowToolBar then
      CreateToolBar;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.CMWinsockEvent(var Msg : TMessage);
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.CMWinsockEvent');
{$ENDIF}
  if (Msg.Msg = CM_WINSOCKEVENT) then
    case Msg.WParam of
      wpWsConnect    : if Assigned(FOnWinsockConnect) then
                       try
                         FOnWinsockConnect;
                       except
                       end;
      wpWsDisconnect : if Assigned(FOnWinsockDisconnect) then
                       try
                         FOnWinsockDisconnect;
                       except
                       end;
      wpWsError      : if Assigned(FOnWinsockError) then
                       try
                         FOnWinsockError(Msg.lParam);
                       except
                       end;
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.CMProtocolEvent(var Msg : TMessage);
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.CMProtocolEvent');
{$ENDIF}
  if Msg.Msg = CM_PROTOCOLEVENT then
    case Msg.WParam of
      wpProtocolFinish : if Assigned(FOnProtocolFinish) then
                           try
                             FOnProtocolFinish(Msg.lParam);
                           except
                           end;
      wpProtocolLog    : if Assigned(FOnProtocolLog) then
                           try
                             FOnProtocolLog(Msg.lParam);
                           except
                           end;
      wpProtocolStatus : if Assigned(FOnProtocolStatus) then
                           try
                             FOnProtocolStatus(Msg.lParam);
                           except
                           end;

    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.CMPortCloseEvent(var Msg : TMessage);             {!!.12}
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.CMPortCloseEvent');
{$ENDIF}
  if Msg.Msg = CM_PORTCLOSEVENT then
    case Msg.WParam of
      wpPortClose      : if Assigned(FOnPortClose) then
                           try
                             FOnPortClose;
                             FConnected := False;
                           except
                           end;
      wpTapiPortClose  : if Assigned(FOnProtocolLog) then
                           try
                             FOnTapiPortClose;
                             FConnected := False;
                           except
                           end;
    end;
end;

{ ======================================================================= }
{ == toolbar methods ==================================================== }
{ ======================================================================= }
procedure TApxTerminal.CreateToolbar;
  { create tool bar and add buttons }
begin 
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.CreateToolbar');
{$ENDIF}
  if not FOleContainerReady then
    Exit;

  { button images - add in order of TApxToolButtonID }
  if not Assigned(FButtonImages) then begin
    FButtonImages := TImageList.CreateSize(16, 16);
    with FButtonImages do begin
      ResourceLoad(rtBitmap, 'CONNECT', clOlive);
      ResourceLoad(rtBitmap, 'LISTEN', clOlive);
      ResourceLoad(rtBitmap, 'CLOSE', clOlive);
      ResourceLoad(rtBitmap, 'DEVICE', clOlive);
      ResourceLoad(rtBitmap, 'SEND', clOlive);
      ResourceLoad(rtBitmap, 'RECEIVE', clOlive);
      ResourceLoad(rtBitmap, 'FONT', clOlive);
      ResourceLoad(rtBitmap, 'EMULATION', clOlive);
    end;
  end;

  { toolbar }
  if not Assigned(FToolBar) then begin
    FToolBar := TToolBar.Create(Self);
    with FToolBar do begin
      Parent := Self;
      ShowCaptions := False;
      EdgeBorders := [ebLeft, ebTop, ebRight, ebBottom];
      EdgeInner := esLowered;
      Flat := True;
      Images := FButtonImages;
    end;
  end;

  { terminal buttons }
  if FShowTerminalButtons then begin
    FTerminalSeparator := AddToolButtonSeparator(10);
    AddToolButton(tbEmulation);
    AddToolButton(tbFont);
  end;

  { protocol buttons }
  if FShowProtocolButtons then begin
    FProtocolSeparator := AddToolButtonSeparator(10);
    AddToolButton(tbReceive);
    AddToolButton(tbSend);
  end;

  { connect buttons }
  if FShowConnectButtons then begin
    FConnectSeparator := AddToolButtonSeparator(10);
    AddToolButton(tbClose);
    AddToolButton(tbListen);
    AddToolButton(tbConnect);
  end;

  { device select button }
  if FShowDeviceSelButton then begin
    FDeviceSeparator := AddToolButtonSeparator(10);
    AddToolButton(tbDevice);
  end;

  FToolbar.Height := FToolbar.ButtonHeight + 4;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.FreeToolBar;
var
  ID : TApxToolBtnID;
begin                                 
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.FreeToolbar');
{$ENDIF}
  for ID := Low(TApxToolBtnID) to High(TApxToolBtnID) do
    RemoveToolButton(ID);
  if Assigned(FToolBar) then begin
    FToolBar.Free;
    FToolBar := nil;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetShowToolBar(Value : WordBool);
begin     
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.ShowToolbar');
{$ENDIF}
  if (Value <> FShowToolBar) then begin
    FShowToolBar := Value;
    if Value then
      CreateToolBar
    else
      FreeToolBar
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.AddToolButtonSeparator(AWidth : Integer) : TToolButton;
begin                               
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.AddToolButtonSeparator');
{$ENDIF}
  Result := TToolButton.Create(FToolBar);
  with Result do begin
    Parent := FToolBar;
    Style := tbsSeparator;
    Caption := '|';
    Width := AWidth;
    ImageIndex := -1;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.AddToolButton(ID : TApxToolBtnID);
var
  MenuItem : TMenuItem;
  DT : TApxDeviceType;
  ET : TApxTerminalEmulation;
begin      
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.AddToolButton: ' + IntToStr(ord(ID)));
{$ENDIF}
  if Assigned(FToolBar) then begin
    FToolButtons[ID] := TToolButton.Create(FToolBar);
    with FToolButtons[ID] do begin
      Parent := FToolBar;
      Tag := Integer(ID);
      Caption := ToolBtnText[ID];
      OnClick := DoToolButtonClick;
      Hint := ToolBtnHint[ID];
      ShowHint := True;
      ImageIndex := Tag;
    end;

    { device type and emulation buttons have dropdown menus }
    if (ID = tbDevice) or (ID = tbEmulation) then begin
      FToolButtons[ID].Style := tbsDropDown;
      FToolButtons[ID].DropDownMenu := TPopupMenu.Create(FToolButtons[ID]);
      FToolButtons[ID].DropDownMenu.AutoPopup := True;

      if (ID = tbDevice) then
        for DT := Low(TApxDeviceType) to High(TApxDeviceType) do begin
          MenuItem := TMenuItem.Create(FToolButtons[ID].DropDownMenu);
          MenuItem.Caption := DeviceTypeText[DT];
          MenuItem.Tag := Integer(DT);
          MenuItem.OnClick := DoDeviceMenuClick;
          MenuItem.RadioItem := True;
          FToolButtons[ID].DropDownMenu.Items.Add(MenuItem);
        end
      else if (ID = tbEmulation) then
        for ET := Low(TApxTerminalEmulation) to High(TApxTerminalEmulation) do begin
          MenuItem := TMenuItem.Create(FToolButtons[ID].DropDownMenu);
          MenuItem.Caption := EmulationTypeText[ET];
          MenuItem.Tag := Integer(ET);
          MenuItem.OnClick := DoEmulationMenuClick;
          MenuItem.RadioItem := True;
          FToolButtons[ID].DropDownMenu.Items.Add(MenuItem);
        end;
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.RemoveToolButton(ID : TApxToolBtnID);
begin                                       
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.RemoveToolButton' + IntToStr(ord(ID)));
{$ENDIF}
  if Assigned(FToolButtons[ID]) then begin
    if Assigned(FToolButtons[ID].DropDownMenu) then
      FToolButtons[ID].DropDownMenu.Free;
    FToolButtons[ID].Free;
    FToolButtons[ID] := nil;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetShowDeviceSelButton(Value : WordBool);
begin
  if (Value <> FShowDeviceSelButton) then begin
    FShowDeviceSelButton := Value;
    if FShowDeviceSelButton then begin
      FDeviceSeparator := AddToolButtonSeparator(10);
      AddToolButton(tbDevice);
    end else begin
      FDeviceSeparator.Free;
      RemoveToolButton(tbDevice);
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetShowConnectButtons(Value : WordBool);
begin
  if (Value <> FShowConnectButtons) then begin
    FShowConnectButtons := Value;
    if FShowConnectButtons then begin
      FConnectSeparator := AddToolButtonSeparator(10);
      AddToolButton(tbClose);
      AddToolButton(tbListen);
      AddToolButton(tbConnect);
    end else begin
      FConnectSeparator.Free;
      RemoveToolButton(tbClose);
      RemoveToolButton(tbListen);
      RemoveToolButton(tbConnect);
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetShowProtocolButtons(Value : WordBool);
begin
  if (Value <> FShowProtocolButtons) then begin
    FShowProtocolButtons := Value;
    if FShowProtocolButtons then begin
      FProtocolSeparator := AddToolButtonSeparator(10);
      AddToolButton(tbReceive);
      AddToolButton(tbSend);
    end else begin
      FProtocolSeparator.Free;
      RemoveToolButton(tbReceive);
      RemoveToolButton(tbSend);
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetShowTerminalButtons(Value : WordBool);
begin
  if (Value <> FShowTerminalButtons) then begin
    FShowTerminalButtons := Value;
    if FShowTerminalButtons then begin
      FTerminalSeparator := AddToolButtonSeparator(10);
      AddToolButton(tbEmulation);
      AddToolButton(tbFont);
    end else begin
      FTerminalSeparator.Free;
      RemoveToolButton(tbEmulation);
      RemoveToolButton(tbFont);
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoToolButtonClick(Sender : TObject);
var
  Default : WordBool;
begin
  Default := True;
  case TApxToolBtnID(TToolButton(Sender).Tag) of
    tbConnect : begin
                  FOnConnectButtonClick(Default);
                  if Default then
                    case DeviceType of
                      dtDirect  : PortOpen;
                      dtTapi    : TapiDial;
                      dtWinsock : WinsockConnect;
                    end;
                end;
    tbListen  : begin
                  FOnListenButtonClick(Default);
                  if Default then
                    case DeviceType of
                      dtDirect  : PortOpen;
                      dtTapi    : TapiAnswer;
                      dtWinsock : WinsockListen;
                    end;
                end;
    tbClose   : begin
                  FOnCloseButtonClick(Default);
                  Close;                                                 {!!.01}
                  {if Default then
                    case DeviceType of
                      dtDirect  : FPort.Open := False;
                      dtTapi    : FTapiDevice.CancelCall;
                      dtWinsock : FPort.Open := False;
                    end;}
                end;
    tbSend    : begin
                  FOnSendButtonClick(Default);
                  if Default then
                    with TOpenDialog.Create(Application) do begin
                      try
                        FileName := '*.*';
                        if Execute then
                          SendFileName := FileName;
                          FProtocol.StartTransmit;
                      finally
                        Free;
                      end;
                    end;
                end;
    tbReceive : begin
                  FOnReceiveButtonClick(Default);
                  if Default then
                    FProtocol.StartReceive;
                end;
    tbFont    : begin
                  FOnFontButtonClick(Default);
                  if Default then
                    with TFontDialog.Create(Application) do begin
                      try
                        Font := FTerminal.Font;
                        if Execute then
                          FTerminal.Font := Font;
                      finally
                        Free;
                      end;
                    end;
                end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoDeviceMenuClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  DeviceType := TApxDeviceType(TMenuItem(Sender).Tag);
  case DeviceType of
    dtDirect : with TComSelectForm.Create(Application) do begin
                 try
                   if (ShowModal = mrOk) then
                     ComNumber := SelectedComNum;
                 finally
                   Free;
                 end;
               end;
    dtTapi    : with TTapiDeviceSelectionForm.Create(Application) do begin
                 try
                   Number := FTapiNumber;
                   ShowOnlySupported := FilterTapiDevices;
                   FEnableVoice := EnableVoice;
                   TapiDevice := SelectedDevice;
                   if (ShowModal = mrOk) then begin
                     FTapiNumber := Number;
                     SelectedDevice := TapiDevice;
                   end;
                 finally
                   Free;
                 end;
               end;
    dtWinsock : with TWinsockSelectForm.Create(Application) do begin
                 try
                   Address := WinsockAddress;
                   Port    := WinsockPort;
                   if (ShowModal = mrOk) then begin
                     WinsockAddress := Address;
                     WinsockPort    := Port;
                   end;
                 finally
                   Free;
                 end;
               end;
  end;
  FOnDeviceButtonClick(DeviceType);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoEmulationMenuClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  Emulation := TApxTerminalEmulation(TMenuItem(Sender).Tag);
  FOnEmulationButtonClick(Emulation);
end;

{ ======================================================================= }
{ == status bar methods ================================================= }
{ ======================================================================= }
procedure TApxTerminal.CreateStatusBar;
  { create status bar and add lights }
var
  ID : TApxLightID;
begin                                        
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.CreateStatusBar');
{$ENDIF}
  if not FOleContainerReady then
    Exit;

  { status bar}
  if not Assigned(FStatusBar) then begin
    FStatusBar := TStatusBar.Create(Self);
    FStatusBar.Parent := Self;
    FStatusBar.Align := alBottom;
    FStatusBar.OnDrawPanel := DoDrawPanel;
  end;

  { caption panel }
  FCaptionPanel := FStatusBar.Panels.Add;
  FCaptionPanel.Bevel := pbLowered;
  FCaptionPanel.Text := FCaption;
  FCaptionPanel.Alignment := FCaptionAlignment;
  FCaptionPanel.Width := FCaptionWidth;

  { end panel }
  FEndPanel := FStatusBar.Panels.Add;
  FEndPanel.Bevel := pbLowered;
  FEndPanel.Text := '';
  FEndPanel.Alignment := taRightJustify;

  { status lights }
  if FShowLights and (FDeviceType <> dtWinsock) then
    for ID := Low(TApxLightID) to High(TApxLightID) do
      AddLight(ID);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.FreeStatusBar;
var
  ID : TApxLightID;
begin                                   
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.FreeStatusBar');
{$ENDIF}
  for ID := Low(TApxLightID) to High(TApxLightID) do
    RemoveLight(ID);
  if Assigned(FCaptionPanel) then begin
    FCaptionPanel.Free;
    FCaptionPanel := nil;
  end;
  if Assigned(FEndPanel) then begin
    FEndPanel.Free;
    FEndPanel := nil;
  end;
  if Assigned(FStatusBar) then begin
    FStatusBar.Free;
    FStatusBar := nil;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetShowStatusBar(Value : WordBool);
begin
  if (Value <> FShowStatusBar) then begin
    FShowStatusBar := Value;
    if Value then
      CreateStatusBar
    else
      FreeStatusBar;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetShowLights(Value : WordBool);
var
  ID : TApxLightID;
begin
  if (Value <> FShowLights) then begin
    if Value and (FDeviceType = dtWinsock) then
      Exit;
    FShowLights := Value;
    if Assigned(FStatusBar) then begin
      for ID := Low(TApxLightID) to High(TApxLightID) do
        if FShowLights then
          AddLight(ID)
        else
          RemoveLight(ID);
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var
  ID : TApxLightID;
  R : TRect;
begin
  for ID := Low(TApxLightID) to High(TApxLightID) do
    if (FLights[ID].Panel = Panel) then begin
      if FLights[ID].Lit then
        StatusBar.Canvas.Brush.Color := FLitColor
      else
        StatusBar.Canvas.Brush.Color := FNotLitColor;
      StatusBar.Canvas.FillRect(Rect);
      StatusBar.Canvas.Pen.Color := clWhite;
      StatusBar.Canvas.MoveTo(0, 0);
      StatusBar.Canvas.LineTo(Width, 0);
      StatusBar.Canvas.MoveTo(0, 0);
      StatusBar.Canvas.LineTo(0, Height);
      StatusBar.Canvas.Pen.Color := clDkGray;
      StatusBar.Canvas.MoveTo(Width - 1, 1);
      StatusBar.Canvas.LineTo(Width - 1, Height);
      StatusBar.Canvas.MoveTo(1, Height - 1);
      StatusBar.Canvas.LineTo(Width, Height - 1);
      if FShowLightCaptions then begin
        StatusBar.Canvas.Pen.Color := clBlack; { !!! FFontColor; }
        R := Rect;
        DrawText(StatusBar.Canvas.Handle, PChar(LightText[ID]), -1, R,
                 DT_VCENTER or DT_CENTER or DT_SINGLELINE);
      end;
      Break;
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetCaption(const Value : WideString);
begin
  if (Value <> FCaption) then begin
    FCaption := Value;
    if Assigned(FCaptionPanel) then begin
      FCaptionPanel.Text := FCaption;
      FCaptionPanel.Width := FCaptionWidth;
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetCaptionAlignment(Value : TAlignment);
begin
  if (Value <> FCaptionAlignment) then begin
    FCaptionAlignment := Value;
    if Assigned(FCaptionPanel) then
      FCaptionPanel.Alignment := FCaptionAlignment;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetCaptionWidth(Value : Integer);
begin
  if (Value <> FCaptionWidth) then begin
    FCaptionWidth := Value;
    if Assigned(FCaptionPanel) then
      FCaptionPanel.Width := FCaptionWidth;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.UpdateEndPanel;
begin
  if Assigned(FEndPanel) then
    case FDeviceType of
      dtDirect  : FEndPanel.Text := 'Com Port: ' + IntToStr(FPort.ComNumber);
      dtTAPI    : FEndPanel.Text := SelectedDevice;
      dtWinsock : FEndPanel.Text := 'Winsock';
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLightWidth(Value : Integer);
var
  ID : TApxLightID;
begin
  if (Value <> FLightWidth) then begin
    FLightWidth := Value;
    if Assigned(FStatusBar) then begin
      for ID := Low(TApxLightID) to High(TApxLightID) do
        if Assigned(FLights[ID].Panel) then
          FLights[ID].Panel.Width := FLightWidth;
      FStatusBar.Repaint;
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.AddLight(ID : TApxLightID);
begin
  FLights[ID].Enabled := True;
  if (FLights[ID].Panel = nil) and Assigned(FStatusBar) then begin
    FLights[ID].Panel := FStatusBar.Panels.Add;
    FLights[ID].Panel.Index := FEndPanel.Index;
    FLights[ID].Panel.Bevel := pbLowered;
    FLights[ID].Panel.Width := FLightWidth;
    FLights[ID].Panel.Style := psOwnerDraw;
    FStatusBar.Repaint;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.RemoveLight(ID : TApxLightID);
begin
  FLights[ID].Enabled := False;
  if (FLights[ID].Panel <> nil) then begin
    FLights[ID].Panel.Free;
    FLights[ID].Panel := nil;
    FStatusBar.Repaint;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.ChangeLight(ID : TApxLightID; NewValue : Boolean) : Boolean;
  { returns true if light changed }
begin
  Result := FLights[ID].Lit <> NewValue;
  FLights[ID].Lit := NewValue;
  if Assigned(FStatusBar) and FLights[ID].Enabled and Result then begin
    FStatusBar.Repaint;
    if NewValue and FPort.Open then
      case ID of
        liBRK : FPort.SetTimerTrigger(FBRKOffTrigger, DefBRKDuration, True);
        liERR : FPort.SetTimerTrigger(FERROffTrigger, DefERRDuration, True);
        liRNG : FPort.SetTimerTrigger(FRNGOffTrigger, DefRNGDuration, True);
        liRXD : FPort.SetTimerTrigger(FRXDOffTrigger, DefRXDDuration, True);
        liTXD : FPort.SetTimerTrigger(FTXDOffTrigger, DefTXDDuration, True);
      end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetShowLightCaptions(Value : WordBool);
begin
  if (Value <> FShowLightCaptions) then begin
    FShowLightCaptions := Value;
    if Assigned(FStatusBar) then
      FStatusBar.Repaint;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLitColor(Value : TColor);
begin
  if (Value <> FLitColor) then begin
    FLitColor := Value;
    if Assigned(FStatusBar) then
      FStatusBar.Repaint;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetNotLitColor(Value : TColor);
begin
  if (Value <> FNotLitColor) then begin
    FNotLitColor := Value;
    if Assigned(FStatusBar) then
      FStatusBar.Repaint;
  end;
end;


{ ======================================================================= }
{ == data trigger methods (internal) ==================================== }
{ ======================================================================= }
function TApxTerminal.GetDataTriggerString : WideString;
begin
  Result := WideString(FDataTriggers.DataTriggerString);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetDataTriggerString(const Value : WideString);
begin
  FDataTriggers.DataTriggerString := string(Value);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.AddDataTrigger(const TriggerString : WideString;
                                     PacketSize, Timeout : Integer;
                                     IncludeStrings, IgnoreCase : WordBool) : Integer;
begin
  Result := FDataTriggers.Add(TriggerString, PacketSize, Timeout, IncludeStrings, IgnoreCase);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.RemoveDataTrigger(Index : Integer);
begin
  try
    FDataTriggers.Delete(Index);
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.RemoveAllDataTriggers;
begin
  try
    FDataTriggers.Clear;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.EnableDataTrigger(Index : Integer);
begin
  FDataTriggers.Enable(Index);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DisableDataTrigger(Index : Integer);
begin
  FDataTriggers.Disable(Index);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoPacketData(Sender : TObject; Data : Pointer; Size : Integer);
var
  i        : Integer;
  varData  : OleVariant;
  Pkt      : TApdDataPacket;
  ReEnable : WordBool;
begin
  if (Size > 0) then begin
    varData := VarArrayCreate([1, Size], varByte);
    for i := 1 to Size do
      varData[i] := TByteArray(Data^)[i-1];
  end else
    varData := EmptyParam;
  ReEnable := False;
  Pkt := TApdDataPacket(Sender);
  if Assigned(FOnDataTrigger) then
    try
      FOnDataTrigger(Pkt.Tag, False, varData, Size, ReEnable);
    except
    end;

  Pkt.Enabled := ReEnable;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoPacketTimeout(Sender : TObject);
var
  Pkt : TApdDataPacket;
  ReEnable : WordBool;
begin
  ReEnable := False;
  Pkt := TApdDataPacket(Sender);
  if Assigned(FOnDataTrigger) then
    try
      FOnDataTrigger(Pkt.Tag, True, EmptyParam, 0, ReEnable);
    except
    end;

  Pkt.Enabled := ReEnable;
end;

{ ======================================================================= }
{ == com port methods =================================================== }
{ ======================================================================= }
procedure TApxTerminal.DoPortOpen(Sender : TObject);
begin                                 
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoPortOpen');
{$ENDIF}
  FConnected := True;                                                    {!!.12}
  if FLineErrorTrigger = 0 then                                          {!!.01}
    FLineErrorTrigger := FPort.AddStatusTrigger(stLine);
  if FStatusTrigger = 0 then                                             {!!.01}
    FStatusTrigger    := FPort.AddStatusTrigger(stModem);
  if FTXDOnTrigger = 0 then                                              {!!.01}
    FTXDOnTrigger     := FPort.AddStatusTrigger(stOutSent);
  FPort.SetStatusTrigger(FLineErrorTrigger, FLineErrorFlags, True);
  FPort.SetStatusTrigger(FStatusTrigger, FStatusFlags, True);
  FPort.SetStatusTrigger(FTXDOnTrigger, 0, True);

  FRNGOffTrigger := FPort.AddTimerTrigger;
  FERROffTrigger := FPort.AddTimerTrigger;
  FBRKOffTrigger := FPort.AddTimerTrigger;
  FRXDOffTrigger := FPort.AddTimerTrigger;
  FTXDOffTrigger := FPort.AddTimerTrigger;

  ChangeLight(liCTS, FPort.CTS);
  ChangeLight(liDCD, FPort.DCD);
  ChangeLight(liDSR, FPort.DSR);
  ChangeLight(liRNG, FPort.DeltaRI);
  if Assigned(FOnPortOpen) then
    try
      FOnPortOpen;
    except
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoPortClose(Sender : TObject);
begin                              
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoPortClose');
{$ENDIF}
  try
    FPort.RemoveAllTriggers;
    FStatusTrigger         := 0;                                           {!!.01}
    FBRKOffTrigger         := 0;                                           {!!.01}
    FERROffTrigger         := 0;                                           {!!.01}
    FRNGOffTrigger         := 0;                                           {!!.01}
    FRXDOffTrigger         := 0;                                           {!!.01}
    FTXDOffTrigger         := 0;                                           {!!.01}
    FBRKOnTrigger          := 0;                                           {!!.01}
    FERROnTrigger          := 0;                                           {!!.01}
    FRNGOnTrigger          := 0;                                           {!!.01}
    FRXDOnTrigger          := 0;                                           {!!.01}
    FTXDOnTrigger          := 0;                                           {!!.01}
    FLineErrorTrigger := 0;                                                {!!.01}
    ChangeLight(liBRK, False);
    ChangeLight(liCTS, False);
    ChangeLight(liDCD, False);
    ChangeLight(liDSR, False);
    ChangeLight(liERR, False);
    ChangeLight(liRNG, False);
    ChangeLight(liRXD, False);
    ChangeLight(liTXD, False);
    PostMessage(Handle, CM_PORTCLOSEVENT, wpPortClose, 0);
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTriggerAvail(CP : TObject; Count : Word);
var
  i : Integer;
  varData : OleVariant;
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoTriggerAvail: ' + IntToStr(Count));
{$ENDIF}
  ChangeLight(liRXD, True);
  if FMSCommCompatible then begin
    if not Assigned(FMSCommInBuffer) then
      FMSCommInBuffer.Create(FMSCommInBufferSize);
    for i := 1 to Count do
      FMSCommInBuffer.PutByte(Byte(FPort.GetChar));
    if (FMSCommInBuffer.Count = FMSCommInBuffer.Size) then begin
      FMSCommCommEvent := comEventRxOver;
      FMsCommOnCommEvent;
    end else if (FMSCommInBuffer.Count >= FMSCommRTThreshold) then begin
      FMSCommCommEvent := comEvReceive;
      FMsCommOnCommEvent;
    end;
  end else begin
    varData := VarArrayCreate([1, Count], varByte);
    for i := 1 to Count do
      try
        varData[i] := Byte(FPort.GetChar);
      except
      end;
    try
      FOnRXD(varData);
    except
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTriggerModemStatus(Sender : TObject);
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoTriggerModemStatus');
{$ENDIF}
  try
    if ChangeLight(liCTS, FPort.CTS) then begin
      FMSCommCommEvent := comEvCTS;
      FOnCTSChanged(FPort.CTS);
    end else if ChangeLight(liDCD, FPort.DCD) then begin
      FMSCommCommEvent := comEvCD;
      FOnDCDChanged(FPort.DCD);
    end else if ChangeLight(liDSR, FPort.DSR) then begin
      FMSCommCommEvent := comEvDSR;
      FOnDSRChanged(FPort.DSR);
    end else if ChangeLight(liRNG, FPort.DeltaRI) and FPort.DeltaRI then begin
      FMSCommCommEvent := comEvRing;
      FOnRing;
    end;
    if FMSCommCompatible then
      FMsCommOnCommEvent;
    if FPort.Open then begin                                             {!!.01}
      if FStatusTrigger = 0 then                                         {!!.01}
        FStatusTrigger := FPort.AddStatusTrigger(stModem);
      FPort.SetStatusTrigger(FStatusTrigger, FStatusFlags, True);
    end;                                                                 {!!.01}
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTriggerLineError(CP : TObject; Error : Word; LineBreak : Boolean);
begin             
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoTriggerLineError');
{$ENDIF}
  try
    if LineBreak then begin
      ChangeLight(liBRK, LineBreak);
      FMSCommCommEvent := comEventBreak;
      if Assigned(FOnLineBreak) then
        FOnLineBreak;
    end else begin
      ChangeLight(liERR, True);
      if Assigned(FOnLineError) then
        FOnLineError;
    end;
    if FPort.Open then begin                                               {!!.01}
      if FLineErrorTrigger = 0 then                                        {!!.01}
        FLineErrorTrigger := FPort.AddStatusTrigger(stLine);
      FPort.SetStatusTrigger(FLineErrorTrigger, FLineErrorFlags, True);
    end;                                                                   {!!.01}
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTriggerOutSent(Sender : TObject);
begin          
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoTriggerOutSent');
{$ENDIF}
  try
    ChangeLight(liTXD, True);
    if FMSCommCompatible then begin
      Application.ProcessMessages;  { give dispatcher some time before checking buffer count }
      if (FPort.OutBuffUsed < Word(FMSCommSThreshold)) then begin
        FMSCommCommEvent := comEvSend;
        FMSCommOnCommEvent;
      end;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTriggerTimer(CP : TObject; TriggerHandle : Word);
begin                                    
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoTriggerTimer');
{$ENDIF}
  try
    if (TriggerHandle = FERROffTrigger) then begin
      ChangeLight(liERR, False);
      FPort.SetStatusTrigger(FERROnTrigger, lsOverrun or lsParity or lsFraming, True);
    end else if (TriggerHandle = FBRKOffTrigger) then begin
      ChangeLight(liBRK, False);
      FPort.SetStatusTrigger(FBRKOnTrigger, lsBreak, True);
    end else if (TriggerHandle = FRXDOffTrigger) then begin
      if (FPort.InBuffUsed = 0) then
        ChangeLight(liRXD, False)
      else
        FPort.SetTimerTrigger(FRXDOffTrigger, DefRXDDuration, True);
    end else if (TriggerHandle = FTXDOffTrigger) then begin
      if (FPort.OutBuffUsed = 0) then begin
        ChangeLight(liTXD, False);
        FPort.SetStatusTrigger(FTXDOnTrigger, 0, True);
      end else
        FPort.SetTimerTrigger(FTXDOffTrigger, DefTXDDuration, True);
    end else if (TriggerHandle = FRNGOffTrigger) then
      ChangeLight(liRNG, False);
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoWsAccept(Sender : TObject; Addr : TInAddr; var Accept : Boolean);
var
  wbAccept : WordBool;
  S : string;
begin                                  
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoWsAccept');
{$ENDIF}
  wbAccept := True;
  if Assigned(FOnWinsockAccept) then begin
    S := '';
    try
      S := ApdSocket.NetAddr2String(Addr);
    except
    end;
    try
    FOnWinsockAccept(WideString(S), wbAccept);
    except
    end;
    Accept := wbAccept;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoWsConnect(Sender : TObject);
begin                              
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoWsConnect');
{$ENDIF}
  PostMessage(Handle, CM_WINSOCKEVENT, wpWsConnect, 0);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoWsDisconnect(Sender : TObject);
begin                               
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoWsDisconnect');
{$ENDIF}
  PostMessage(Handle, CM_WINSOCKEVENT, wpWsDisconnect, 0);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoWsError(Sender : TObject; ErrCode : Integer);
begin                                  
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.DoWsError: ' + IntToStr(ErrCode));
{$ENDIF}
  PostMessage(Handle, CM_WINSOCKEVENT, wpWsError, ErrCode);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoWinsockGetAddress;
var
  A, P : WideString;
begin
  if Assigned(FOnWinsockGetAddress) then begin
    A := WinsockAddress;
    P := WinsockPort;
    try
      FOnWinsockGetAddress(A, P);
    except
    end;
    WinsockAddress := A;
    WinsockPort := P;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.PortOpen : Integer;
begin                                      
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.PortOpen');
{$ENDIF}
  Close;                                                                 {!!.01}
  //FPort.Open := False;
  FDeviceType := dtDirect;
  FPort.DeviceLayer := dlWin32;
  FPort.TapiMode := tmOff;
  try
    FPort.Open := True;
    UpdateEndPanel;
    Result := 0;
  except
    on E : EAPDException do Result := E.ErrorCode;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.TapiAnswer : Integer;
begin                            
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.TapiAnswer');
{$ENDIF}
  Close;                                                                 {!!.01}
  //FPort.Open := False;
  FDeviceType := dtTapi;
  FPort.DeviceLayer := dlWin32;
  FPort.TapiMode := tmOn;
  try
    FTapiDevice.AutoAnswer;
    UpdateEndPanel;
    Result := 0;
  except
    on E : EAPDException do Result := E.ErrorCode;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.TapiDial : Integer;
begin                              
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.TapiDial');
{$ENDIF}
  Close;                                                                 {!!.01}
  //FPort.Open := False;
  FDeviceType := dtTapi;
  FPort.DeviceLayer := dlWin32;
  FPort.TapiMode := tmOn;
  DoTapiGetNumber;
  try
    FTapiDevice.Dial(FTapiNumber);
    FConnected := True;                                                  {!!.12}
    UpdateEndPanel;
    Result := 0;
  except
    on E : EAPDException do Result := E.ErrorCode;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.WinsockConnect : Integer;
var
  ID :TApxLightID;
begin        
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.WinsockConnect');
{$ENDIF}
  Close;                                                                 {!!.01}
  //FPort.Open := False;
  for ID := Low(TApxLightID) to High(TApxLightID) do
    RemoveLight(ID);
  FDeviceType := dtWinsock;
  FPort.DeviceLayer := dlWinsock;
  FPort.TapiMode := tmOff;
  FPort.WsMode := wsClient;
  FPort.WsTelnet := wsTelnet;                                            {!!.01}
  DoWinsockGetAddress;
  try
    FPort.Open := True;
    UpdateEndPanel;
    Result := 0;
  except
    on E : EAPDException do Result := E.ErrorCode;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.WinsockListen : Integer;
var
  ID :TApxLightID;
begin                                  
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.WinsockListen');
{$ENDIF}
  Close;                                                                 {!!.01}
  //FPort.Open := False;
  for ID := Low(TApxLightID) to High(TApxLightID) do
    RemoveLight(ID);
  FDeviceType := dtWinsock;
  FPort.DeviceLayer := dlWinsock;
  FPort.TapiMode := tmOff;
  FPort.WsMode := wsServer;
  FPort.WsTelnet := wsTelnet;                                            {!!.01}
  DoWinsockGetAddress;
  try
    FPort.Open := True;
    UpdateEndPanel;
    Result := 0;
  except
    on E : EAPDException do Result := E.ErrorCode;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.Close : Integer;
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.Close');
{$ENDIF}
  try
    if FConnected or FTapiDevice.WaitingForCall then begin               {!!.12}
      if (FDeviceType = dtTapi) then
        FTapiDevice.CancelCall
      else
        FPort.Open := False;
    end;                                                                 {!!.11}
    Result := 0;
  except
    on E : EAPDException do Result := E.ErrorCode;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetDeviceType(Value : TApxDeviceType);
var
  ID :TApxLightID;
begin
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.SetDeviceType(' + IntToStr(ord(Value)) + ')');
{$ENDIF}
  if (Value <> FDeviceType) then begin
    FDeviceType := Value;
    if FPort.Open then                                                   {!!.01}
      Close;                                                             {!!.01}
    case FDeviceType of
      dtDirect  : begin
                    for ID := Low(TApxLightID) to High(TApxLightID) do
                      AddLight(ID);
                    FPort.DeviceLayer := dlWin32;
                    FPort.TapiMode := tmOff;
                  end;
      dtTAPI    : begin
                    for ID := Low(TApxLightID) to High(TApxLightID) do
                      AddLight(ID);
                    FPort.DeviceLayer := dlWin32;
                    FPort.TapiMode := tmOn;
                  end;
      dtWinsock : begin
                    for ID := Low(TApxLightID) to High(TApxLightID) do
                      RemoveLight(ID);
                    FPort.DeviceLayer := dlWinsock;
                    FPort.TapiMode := tmOff;
                  end;
    end;
    UpdateEndPanel;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWinsockMode : TWsMode;
begin
  Result := FPort.WsMode;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetWinsockMode(Value : TWsMode);
begin
  FPort.WsMode := Value;
  UpdateEndPanel;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWinsockAddress : Widestring;
begin
  Result := FPort.WsAddress;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetWinsockAddress(const Value : Widestring);
begin
  FPort.WsAddress := Value;
  UpdateEndPanel;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWinsockPort : Widestring;
begin
  Result := FPort.WsPort;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetWinsockPort(const Value : Widestring);
begin
  FPort.WsPort := Value;
  UpdateEndPanel;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetWsTelnet : WordBool;
begin
  Result := FPort.WsTelnet;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetWsTelnet(Value: WordBool);
begin
  FPort.WsTelnet := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetPromptForPort: WordBool;
begin
  Result := FPort.PromptForPort;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetPromptForPort(Value: WordBool);
begin
  FPort.PromptForPort := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetComNumber: Integer;
begin
  Result := FPort.ComNumber;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetComNumber(Value: Integer);
begin       
{$IFDEF DEBUGAPAX}
WriteDebug('TApxTerminal.SetComNumber(' + IntToStr(Value) + ')');
{$ENDIF}
  FPort.ComNumber := Value;
  UpdateEndPanel;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetDataBits: Integer;
begin
  Result := FPort.DataBits;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetDataBits(Value: Integer);
begin
  FPort.DataBits := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetStopBits: Integer;
begin
  Result := FPort.StopBits;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetStopBits(Value: Integer);
begin
  FPort.StopBits := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetCTS: WordBool;
begin
  Result := FPort.CTS;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetDCD: WordBool;
begin
  Result := FPort.DCD;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetDSR: WordBool;
begin
  Result := FPort.DSR;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetDTR: WordBool;
begin
  Result := FPort.DTR;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetDTR(Value: WordBool);
begin
  FPort.DTR := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetRI: WordBool;
begin
  Result := FPort.RI;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetRTS: WordBool;
begin
  Result := FPort.RTS;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetRTS(Value: WordBool);
begin
  FPort.RTS := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetLineError: Integer;
begin
  Result := FPort.LineError;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetBufferFull: Integer;
begin
  Result := FPort.BufferFull;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetBufferFull(Value: Integer);
begin
  if ((Value <= 100) and (Value >= 0)) then
    FPort.BufferFull := Trunc(Value / 100 * FPort.InSize)
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetBufferResume: Integer;
begin
  Result := FPort.BufferResume;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetBufferResume(Value: Integer);
begin
  if ((Value <= 100) and (Value >= 0)) then
    FPort.BufferResume := Trunc(Value / 100 * FPort.InSize)
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetXOffChar: Integer;
begin
  Result := Integer(FPort.XOffChar);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetXOffChar(Value: Integer);
begin
  FPort.XOffChar := char(Value);
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetXOnChar: Integer;
begin
  Result := Integer(FPort.XOnChar);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetXOnChar(Value: Integer);
begin
  FPort.XOnChar := char(Value);
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetOutBuffFree: Integer;
begin
  Result := FPort.OutBuffFree;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetOutBuffUsed: Integer;
begin
  Result := FPort.OutBuffUsed;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetOutSize: Integer;
begin
  Result := FPort.OutSize;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetOutSize(Value: Integer);
begin
  FPort.OutSize := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetInSize: Integer;
begin
  Result := FPort.InSize;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetInSize(Value: Integer);
begin
  FPort.InSize := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetLogHex: WordBool;
begin
  Result := FPort.LogHex;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLogHex(Value: WordBool);
begin
  FPort.LogHex := Value;
  FFTPClient.LogHex := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetLogName: WideString;
begin
  Result := FPort.LogName;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLogName(const Value: WideString);
begin
  FPort.LogName := Value;
  FFTPClient.LogName := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetLogSize: Integer;
begin
  Result := FPort.LogSize;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLogSize(Value: Integer);
begin
  FPort.LogSize := Value;
  FFTPClient.LogSize := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetData(Size : Integer) : OleVariant;
begin
  if (Size <= FPort.InBuffUsed) then begin
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.IsPortAvail(ComNumber: Integer): WordBool;
var
  Old : Boolean;
begin
  Old := ShowPortsInUse;
  ShowPortsInUse := False;
  Result := IsPortAvailable(ComNumber);
  ShowPortsInUse := Old;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.IsPortInstalled(ComNumber: Integer): WordBool;
var
  Old : Boolean;
begin
  Old := ShowPortsInUse;
  ShowPortsInUse := True;
  Result := IsPortAvailable(ComNumber);
  ShowPortsInUse := Old;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.PutData(Data : OleVariant) : Integer;
var
  i : Integer;
begin
  Result := ecOK;
  if VarIsArray(Data) then
    for i := VarArrayLowBound(Data, 1) to VarArrayHighBound(Data, 1) do
      try
        FPort.PutChar(Char(Byte(Data[i])));
      except
        on E : EAPDException do Result := E.ErrorCode;
      end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.PutString(const S: WideString) : Integer;
begin
  Result := ecOK;
  try
    FPort.PutString(S);
  except
    on E : EAPDException do Result := E.ErrorCode;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.PutStringCRLF(const S: WideString) : Integer;
begin
  Result := ecOK;
  try
    FPort.PutString(string(S) + #13#10);
  except
    on E : EAPDException do Result := E.ErrorCode;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.FlushInBuffer;
begin
  FPort.FlushInBuffer;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.FlushOutBuffer;
begin
  FPort.FlushOutBuffer;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetParity: TParity;
begin
  Result := FPort.Parity;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetParity(Value: TParity);
begin
  FPort.Parity := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBaud: Integer;
begin
  Result := FPort.Baud;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetBaud(Value: Integer);
begin
  FPort.Baud := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetRS485Mode: WordBool;
begin
  Result := FPort.RS485Mode;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetRS485Mode(Value: WordBool);
begin
  FPort.RS485Mode := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetHWFlowUseDTR: WordBool;
begin
  Result := hwfUseDTR in FPort.HWFlowOptions;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetHWFlowUseRTS: WordBool;
begin
  Result := hwfUseRTS in FPort.HWFlowOptions;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetHWFlowRequireDSR: WordBool;
begin
  Result := hwfRequireDSR in FPort.HWFlowOptions;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetHWFlowRequireCTS: WordBool;
begin
  Result := hwfRequireCTS in FPort.HWFlowOptions;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetHWFlowUseDTR(Value: WordBool);
begin
  if Value then
    FPort.HWFlowOptions := FPort.HWFlowOptions + [hwfUseDTR]
  else
    FPort.HWFlowOptions := FPort.HWFlowOptions - [hwfUseDTR];
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetHWFlowUseRTS(Value: WordBool);
begin
  if Value then
    FPort.HWFlowOptions := FPort.HWFlowOptions + [hwfUseRTS]
  else
    FPort.HWFlowOptions := FPort.HWFlowOptions - [hwfUseRTS];
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetHWFlowRequireDSR(Value: WordBool);
begin
  if Value then
    FPort.HWFlowOptions := FPort.HWFlowOptions + [hwfRequireDSR]
  else
    FPort.HWFlowOptions := FPort.HWFlowOptions - [hwfRequireDSR];
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetHWFlowRequireCTS(Value: WordBool);
begin
  if Value then
    FPort.HWFlowOptions := FPort.HWFlowOptions + [hwfRequireCTS]
  else
    FPort.HWFlowOptions := FPort.HWFlowOptions - [hwfRequireCTS];
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetFlowState: TFlowControlState;
begin
  Result := FPort.FlowState;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetSWFlowOptions: TSWFlowOptions;
begin
  Result := FPort.SWFlowOptions;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetSWFlowOptions(Value: TSWFlowOptions);
begin
  FPort.SWFlowOptions := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetLogging: TTraceLogState;
begin
  Result := FPort.Logging;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLogging(Value: TTraceLogState);
begin
  FPort.Logging := Value;
  FFTPClient.Logging := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SendBreak(Ticks : Integer; Yield : WordBool);
begin
  if (Ticks < 0) then
    FPort.SetBreak(True)
  else FPort.SendBreak(Ticks, Yield);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.AddStringToLog(const S : WideString);
begin
  FPort.AddStringToLog(S);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetInBuffUsed : Integer;
begin
  Result := FPort.InBuffUsed;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetInBuffFree : Integer;
begin
  Result := FPort.InBuffFree;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLogAllHex(Value : WordBool);
begin
  FPort.LogAllHex := Value;
  FFTPClient.LogAllHex := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetLogAllHex : WordBool;
begin
  Result := FPort.LogAllHex;
end;

{ ======================================================================= }
{ == tapi device methods ================================================ }
{ ======================================================================= }
function TApxTerminal.GetTapiStatusDisplay : WordBool;
begin
  Result := FTapiStatusDisplay;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetTapiStatusDisplay(Value : WordBool);
begin
  if (Value <> FTapiStatusDisplay) then begin
    FTapiStatusDisplay := Value;
    if (FTapiStatusDisplay) then begin
      FTapiDevice.StatusDisplay := FTapiStatus;
      FTapiStatus.TapiDevice := FTapiDevice;
    end else begin
      FTapiDevice.StatusDisplay := nil;
      FTapiStatus.TapiDevice := nil;
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiGetNumber;
var
  P : WideString;
begin
  P := FTapiNumber;
  try
    FOnTapiGetNumber(P);
    FTapiNumber := P;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiCallerID(CP : TObject; ID, IDName : string);
begin
  if Assigned(FOnTapiCallerID) then
    try
      FOnTapiCallerID(ID, IDName);
    except
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiConnect(Sender : TObject);
begin
  FConnected := True;                                                    {!!.12}
  if Assigned(FOnTapiConnect) then
    try
      FOnTapiConnect;
    except
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiDTMF(CP : TObject; Digit : Char;
                                    ErrorCode : Integer);
begin
  if Assigned(FOnTapiDTMF) then
    try
      FOnTapiDTMF(Byte(Digit), ErrorCode);
    except
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiFail(Sender : TObject);
begin
  if Assigned(FOnTapiFail) then
    try
      FOnTapiFail;
    except
    end;                         
  FConnected := False;                                                   {!!.12}
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiPortClose(Sender : TObject);
begin
  PostMessage(Handle, CM_PORTCLOSEVENT, wpTapiPortClose, 0);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiPortOpen(Sender : TObject);
begin
  FConnected := True;                                                    {!!.12}
  if Assigned(FOnTapiPortOpen) then
    try
      FOnTapiPortOpen;
    except
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiStatus(CP : TObject; First, Last : Boolean;
                                      Device, Message, Param1,
                                      Param2, Param3 : Integer);
begin
  if Assigned(FOnTapiStatus) then
    try
      FOnTapiStatus(First, Last, Device, Message, Param1, Param2, Param3);
    except
    end;
  if (Message = LineDevState_Ringing) and Assigned(FOnRing) then         {!!.11}
    try                                                                  {!!.11}
      FOnRing;                                                           {!!.11}
    except                                                               {!!.11}
    end;                                                                 {!!.11}
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiWaveNotify(CP : TObject; Msg : TWaveMessage);
begin
  if (Msg = waDataReady) then
    FTapiDevice.SaveWaveFile(FWaveFileName, FWaveFileOverwrite)
  else if Assigned(FOnTapiWaveNotify) then
    FOnTapiWaveNotify(Msg);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoTapiWaveSilence(CP : TObject; var StopRecording, Hangup : Boolean);
var
  wbStopRecording, wbHangup : WordBool;
begin
  if Assigned(FOnTapiWaveSilence) then begin
    wbStopRecording := StopRecording;
    wbHangup := Hangup;
    FOnTapiWaveSilence(wbStopRecording, wbHangup);
    StopRecording := wbStopRecording;
    Hangup := wbHangup;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiAutoAnswer;
begin
  TapiAnswer;                                                            {!!.12}
//  Close;                                                                 {!!.01}
//  FTapiDevice.AutoAnswer;
end;
{ ----------------------------------------------------------------------- }
procedure  TApxTerminal.TapiCancelCall;
begin
  Close;                                                                 {!!.01}
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiConfigAndOpen;
begin                                                                
  Close;                                                                 {!!.01}
  FTapiDevice.ConfigAndOpen;
  UpdateEndPanel;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.TapiSelectDevice : WordBool;                       {!!.01}
begin
  Result := FTapiDevice.SelectDevice = mrOK;
  UpdateEndPanel;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiSendTone(const Digits : WideString);
begin
  FTapiDevice.SendTone(Digits);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiSetRecordingParams(NumChannels : Integer;
                                              NumSamplesPerSecond : Integer;
                                              NumBitsPerSample : Integer);
begin
  FTapiDevice.SetRecordingParams(NumChannels, NumSamplesPerSecond,
                                 NumBitsPerSample);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiShowConfigDialog(AllowEdit : WordBool);
var
  Config : TTapiConfigRec;
begin
  if AllowEdit then begin
    Config := FTapiDevice.GetDevConfig;
    Config := FTapiDevice.ShowConfigDialogEdit(Config);
    FTapiDevice.SetDevConfig(Config);
  end else
    FTapiDevice.ShowConfigDialog;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiPlayWaveFile(const FileName : WideString);
begin
  FTapiDevice.PlayWaveFile(FileName);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiRecordWaveFile(const FileName : WideString; Overwrite : WordBool);
begin
  FWaveFileName := FileName;
  FWaveFileOverwrite := Overwrite;
  FTapiDevice.StartWaveRecord;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiStopWaveFile;
begin
  case FTapiDevice.WaveState of
    wsPlaying   : FTapiDevice.StopWaveFile;
    wsRecording : FTapiDevice.StopWaveRecord;
  end;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.TapiStatusMsg(const Message, State, Reason : Integer) : WideString;
begin
  Result := FTapiDevice.TapiStatusMsg(Message, State, Reason);
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.TapiTranslatePhoneNo(const CanonicalAddr : WideString) : WideString;
begin
  Result := FTapiDevice.TranslateAddress(CanonicalAddr);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.TapiTranslateDialog(                               {!!.01}
  const CanonicalAddr: WideString): WordBool;
begin
  Result := FTapiDevice.TranslateDialog(CanonicalAddr);
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetAnswerOnRing : Integer;
begin
  Result := FTapiDevice.AnswerOnRing;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAnswerOnRing(Value : Integer);
begin
  FTapiDevice.AnswerOnRing := Integer(Value);
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetAttempt : Integer;
begin
  Result := FTapiDevice.Attempt;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetCallerID : WideString;
begin
  Result := FTapiDevice.CallerID;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetCancelled : WordBool;
begin
  Result := FTapiDevice.Cancelled;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetDialing : WordBool;
begin
  Result := FTapiDevice.Dialing;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetEnableVoice : WordBool;
begin
  Result := FTapiDevice.EnableVoice;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetEnableVoice(Value : WordBool);
begin
  FTapiDevice.EnableVoice := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetTapiFailCode: Integer;                          {!!.01}
begin
  Result := FTapiDevice.FailureCode;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetInterruptWave : WordBool;
begin
  Result := FTapiDevice.InterruptWave;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetInterruptWave(Value : WordBool);
begin
  FTapiDevice.InterruptWave := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMaxAttempts : Integer;
begin
  Result := FTapiDevice.MaxAttempts;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMaxAttempts(Value : Integer);
begin
  FTapiDevice.MaxAttempts := Lo(Value);
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMaxMessageLength : Integer;
begin
  Result := FTapiDevice.MaxMessageLength;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMaxMessageLength(Value : Integer);
begin
  FTapiDevice.MaxMessageLength := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetRetryWait : Integer;
begin
  Result := FTapiDevice.RetryWait;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetRetryWait(Value : Integer);
begin
  FTapiDevice.RetryWait := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetSelectedDevice : WideString;
begin
  Result := FTapiDevice.SelectedDevice;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetSelectedDevice(const Value : WideString);
begin
  FTapiDevice.SelectedDevice := Value;
  UpdateEndPanel;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetFilterTapiDevices : WordBool;
begin
  Result := FTapiDevice.FilterUnsupportedDevices;
end;
//function  TApxTerminal.GetFilterUnsupportedDevices : WordBool;           {!!.12}
//begin
 // Result := FTapiDevice.FilterUnsupportedDevices;
//end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetFilterTapiDevices(Value : WordBool);    {!!.12}
begin
  FTapiDevice.FilterUnsupportedDevices := Value;
  UpdateEndPanel;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetSilenceThreshold : Integer;
begin
  Result := FTapiDevice.SilenceThreshold;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetSilenceThreshold(Value : Integer);
begin
  FTapiDevice.SilenceThreshold := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetTapiState : TTapiState;
begin
  Result := FTapiDevice.TapiState;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetTrimSeconds : Integer;
begin
  Result := FTapiDevice.TrimSeconds;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetTrimSeconds(Value : Integer);
begin
  FTapiDevice.TrimSeconds := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetUseSoundCard : WordBool;
begin
  Result := FTapiDevice.UseSoundCard
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetUseSoundCard(Value : WordBool);
begin
  FTapiDevice.UseSoundCard := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetWaveFileName : WideString;
begin
  Result := FTapiDevice.WaveFileName;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetWaveState : TWaveState;
begin
  Result := FTapiDevice.WaveState;
end;

{ ======================================================================= }
{ == terminal methods =================================================== }
{ ======================================================================= }
function TApxTerminal.GetCaptureMode : TAdCaptureMode;
begin
  Result := FTerminal.Capture;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetCaptureMode(Value : TAdCaptureMode);
begin
  FTerminal.Capture := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetFont : TFont;
begin
  Result := FTerminal.Font;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetFont(Value : TFont);
begin
  FTerminal.Font := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.Clear;
begin
  FTerminal.Clear;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.ClearAll;
begin
  FTerminal.ClearAll;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.CopyToClipboard;
begin
  FTerminal.CopyToClipboard;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TerminalSetFocus;
begin
  Windows.SetFocus(FTerminal.Handle);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TerminalWriteString(const S : WideString);
begin
  FTerminal.WriteString(S);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TerminalWriteStringCRLF(const S : WideString);
begin
  FTerminal.WriteString(S + #13#10);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoCursorMoved(aSender : TObject; aRow, aCol : integer);
begin
  if Assigned(FOnCursorMoved) then
    try
      FOnCursorMoved(aRow, aCol);
    except
    end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoProcessChar(Sender      : TObject;
                              Character   : Char;
                              var ReplaceWith : string;
                              Commands    : TAdEmuCommandList;
                              CharSource  : TAdCharSource);
begin
  if Assigned(FOnProcessChar) then
    try
      FOnProcessChar(Character, ReplaceWith, Commands, CharSource);
    except
      ReplaceWith := Character;
    end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBlinkTime : Integer;
begin
  Result := FTerminal.BlinkTime;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetBlinkTime(Value : Integer);
begin
  FTerminal.BlinkTime := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetColumns : Integer;
begin
  Result := FTerminal.Columns;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetColumns(Value : Integer);
begin
  FTerminal.Columns := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetLazyByteDelay : Integer;
begin
  Result := FTerminal.LazyByteDelay;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLazyByteDelay(Value : Integer);
begin
  FTerminal.LazyByteDelay := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetLazyTimeDelay : Integer;
begin
  Result := FTerminal.LazyTimeDelay;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLazyTimeDelay(Value : Integer);
begin
  FTerminal.LazyTimeDelay := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetRows : Integer;
begin
  Result := FTerminal.Rows;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetRows(Value : Integer);
begin
  FTerminal.Rows := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetScrollbackRows : Integer;
begin
  Result := FTerminal.ScrollbackRows;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetScrollbackRows(Value : Integer);
begin
  FTerminal.ScrollbackRows := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetEmulation : TApxTerminalEmulation;
begin
    if FTerminal.Emulator is TAdTTYEmulator then
      Result := teTTY
    else
      Result := teVT100
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetEmulation(Value : TApxTerminalEmulation);
var
  SavedActive : Boolean;
begin
  SavedActive := FTerminal.Active;
  FTerminal.Active := False;
  if Value = teTTY then begin
    FTerminal.Emulator := FTTYEmulator;
    FTerminal.Color := DefTerminalColor;
  end else begin
    FTerminal.Emulator := FVT100Emulator;
    FTerminal.Color := clBlack;
  end;
 FTerminal.Active := SavedActive;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetAttributes(aRow, aCol : Integer): Integer;
var
  Attr : TAdTerminalCharAttrs;
begin
  Result := tcaxNone;
  Attr := FTerminal.Attributes[aRow, aCol];
  if (tcaBold in Attr) then
    Result := Result + tcaxBold;
  if (tcaUnderline in Attr) then
    Result := Result + tcaxUnderline;
  if (tcaStrikethrough in Attr) then
    Result := Result + tcaxStrikethrough;
  if (tcaBlink in Attr) then
    Result := Result + tcaxBlink;
  if (tcaReverse in Attr) then
    Result := Result + tcaxReverse;
  if (tcaInvisible in Attr) then
    Result := Result + tcaxInvisible;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAttributes(aRow, aCol, Value : Integer);
var
  Attr : TAdTerminalCharAttrs;
begin
  Attr := [];
  if (Value and tcaxBold) > 0 then
    Attr := Attr + [tcaBold];
  if (Value and tcaxUnderline) > 0 then
    Attr := Attr + [tcaUnderLine];
  if (Value and tcaxStrikethrough) > 0 then
    Attr := Attr + [tcaStrikethrough];
  if (Value and tcaxBlink) > 0 then
    Attr := Attr + [tcaBlink];
  if (Value and tcaxReverse) > 0 then
    Attr := Attr + [tcaReverse];
  if (Value and tcaxInvisible) > 0 then
    Attr := Attr + [tcaInvisible];
  FTerminal.Attributes[aRow, aCol] := Attr;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetLine(Index: Integer): WideString;
begin
  Result := FTerminal.Line[Index];
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetLine(Index : Integer ; const Value : WideString);
begin
  FTerminal.Line[Index] := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetActive : WordBool;
begin
  Result := FTerminal.Active;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetActive(Value : WordBool);
begin
  FTerminal.Active := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetScrollback : WordBool;
begin
  Result := FTerminal.Scrollback;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetScrollback(Value : WordBool);
begin
  FTerminal.Scrollback := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetCaptureFile : WideString;
begin
  Result := FTerminal.CaptureFile;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetCaptureFile(const Value : WideString);
begin
  FTerminal.CaptureFile := string(Value);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetUseLazyDisplay : WordBool;
begin
  Result := FTerminal.UseLazyDisplay;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetUseLazyDisplay(Value : WordBool);
begin
  FTerminal.UseLazyDisplay := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWantAllKeys : WordBool;
begin
  Result := FTerminal.WantAllKeys;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetWantAllKeys(Value : WordBool);
begin
  FTerminal.WantAllKeys := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetHalfDuplex : WordBool;
begin
  Result := FTerminal.HalfDuplex;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetHalfDuplex(Value : WordBool);
begin
  FTerminal.HalfDuplex := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetTerminalColor(Value : TColor);
begin
  FColor := Value;
  FTerminal.Color := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetVersion : WideString;
begin
  Result := sApaxVersion;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetVersion(const Value : WideString);
begin
  { nop }
end;

{ ======================================================================= }
{ == protocol methods =================================================== }
{ ======================================================================= }
procedure TApxTerminal.DoProtocolFinish(CP : TObject; ErrorCode : Integer);
begin
  PostMessage(Handle, CM_PROTOCOLEVENT, wpProtocolFinish, ErrorCode);
{  if Assigned(FOnProtocolFinish) then
    try
      FOnProtocolFinish(ErrorCode);
    except
    end;}
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoProtocolLog(CP : TObject; Log : Word);
begin
  PostMessage(Handle, CM_PROTOCOLEVENT, wpProtocolLog, Log);
{  if Assigned(FOnProtocolLog) then
    try
      FOnProtocolLog(Log);
    except
    end;}
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoProtocolStatus(CP : TObject; Options : Word);
begin
  PostMessage(Handle, CM_PROTOCOLEVENT, wpProtocolStatus, Options);
{  if Assigned(FOnProtocolStatus) then
    try
      FOnProtocolStatus(Options);
    except
    end;}
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DoProtocolAccept(CP : TObject; var Accept : Boolean;
                                        var FName : TPassString);
var
  wsFName : WideString;
  wbAccept : WordBool;
begin
  if Assigned(FOnProtocolAccept) then begin
    wbAccept := Accept;
    wsFName := FName;
    try
      FOnProtocolAccept(wbAccept, wsFName);
    except
      wbAccept := False;
    end;
    Accept := wbAccept;
    FName := wsFName;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetProtocolType : TProtocolType;
begin
  Result := FProtocol.ProtocolType;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetProtocolType(Value : TProtocolType);
begin
  FProtocol.ProtocolType := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetProtocolStatusDisplay : WordBool;
begin
  Result := FProtocolStatusDisplay;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetProtocolStatusDisplay(Value : WordBool);
begin
  FProtocolStatusDisplay := Value;
  if (FProtocolStatusDisplay) then begin
    FProtocol.StatusDisplay := FProtocolStatus;
    FProtocolStatus.Protocol := FProtocol;
  end else begin
    FProtocol.StatusDisplay := nil;
    FProtocolStatus.Protocol := nil;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetReceiveDirectory : WideString;
begin
  Result := FProtocol.DestinationDirectory;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetReceiveDirectory(const Value : WideString);
begin
  FProtocol.DestinationDirectory := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetSendFileName : WideString;
begin
  Result := FProtocol.FileMask;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetSendFileName(const Value : WideString);
begin
  FProtocol.FileMask := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBlockCheckMethod : TBlockCheckMethod;
begin
  Result := FProtocol.BlockCheckMethod;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetBlockCheckMethod(Value : TBlockCheckMethod);
begin
  FProtocol.BlockCheckMethod := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetHandshakeRetry : Integer;
begin
  Result := FProtocol.HandshakeRetry;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetHandshakeRetry(Value : Integer);
begin
  FProtocol.HandshakeRetry := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetHandshakeWait : Integer;
begin
  Result := FProtocol.HandshakeWait;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetHandshakeWait(Value : Integer);
begin
  FProtocol.HandshakeWait := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetTransmitTimeout : Integer;
begin
  Result := FProtocol.TransmitTimeout;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetTransmitTimeout(Value : Integer);
begin
  FProtocol.TransmitTimeout := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetFinishWait : Integer;
begin
  Result := FProtocol.FinishWait;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetFinishWait(Value : Integer);
begin
  FProtocol.FinishWait := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWriteFailAction : TWriteFailAction;
begin
  Result := FProtocol.WriteFailAction;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetWriteFailAction(Value :TWriteFailAction);
begin
  FProtocol.WriteFailAction := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetHonorDirectory : WordBool;
begin
  Result := FProtocol.HonorDirectory;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetHonorDirectory(Value : WordBool);
begin
  FProtocol.HonorDirectory := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetIncludeDirectory : WordBool;
begin
  Result := FProtocol.IncludeDirectory;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetIncludeDirectory(Value : WordBool);
begin
  FProtocol.IncludeDirectory := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetRTSLowForWrite : WordBool;
begin
  Result := FProtocol.RTSLowForWrite;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetRTSLowForWrite(Value : WordBool);
begin
  FProtocol.RTSLowForWrite := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetAbortNoCarrier : WordBool;
begin
  Result := FProtocol.AbortNoCarrier;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAbortNoCarrier(Value : WordBool);
begin
  FProtocol.AbortNoCarrier := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetAsciiSuppressCtrlZ : WordBool;
begin
  Result := FProtocol.AsciiSuppressCtrlZ;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAsciiSuppressCtrlZ(Value : WordBool);
begin
  FProtocol.AsciiSuppressCtrlZ := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetUpcaseFileNames : WordBool;
begin
  Result := FProtocol.UpcaseFileNames;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetUpcaseFileNames(Value : WordBool);
begin
  FProtocol.UpcaseFileNames := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBatch : WordBool;
begin
  Result := FProtocol.Batch;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBlockLength : Integer;
begin
  Result := FProtocol.BlockLength;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBlockNumber : Integer;
begin
  Result := FProtocol.BlockNumber;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetProtocolStatus : Integer;
begin
  Result := FProtocol.ProtocolStatus;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetFileLength : Integer;
begin
  Result := FProtocol.FileLength;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetFileDate : TDateTime;
begin
  Result := FProtocol.FileDate;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetInitialPosition : Integer;
begin
  Result := FProtocol.InitialPosition;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetStatusInterval : Integer;
begin
  Result := FProtocol.StatusInterval;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetStatusInterval(Value : Integer);
begin
  FProtocol.StatusInterval := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetInProgress : WordBool;
begin
  Result := FProtocol.InProgress;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBlockErrors : Integer;
begin
  Result := FProtocol.BlockErrors;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetTotalErrors : Integer;
begin
  Result := FProtocol.TotalErrors;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBytesRemaining : Integer;
begin
  Result := FProtocol.BytesRemaining;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetBytesTransferred : Integer;
begin
  Result := FProtocol.BytesTransferred;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetElapsedTicks : Integer;
begin
  Result := FProtocol.ElapsedTicks;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetReceiveFileName : WideString;
begin
  Result := FProtocol.FileName;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetReceiveFileName(const Value : WideString);
begin
  FProtocol.FileName := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetXYmodemBlockWait : Integer;
begin
  Result := FProtocol.XYmodemBlockWait;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetXYmodemBlockWait(Value : Integer);
begin
  FProtocol.XYmodemBlockWait := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetZmodemOptionOverride : WordBool;
begin
  Result := FProtocol.ZmodemOptionOverride;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetZmodemOptionOverride(Value : WordBool);
begin
  FProtocol.ZmodemOptionOverride := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetZmodemSkipNoFile : WordBool;
begin
  Result := FProtocol.ZmodemSkipNoFile;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetZmodemSkipNoFile(Value : WordBool);
begin
  FProtocol.ZmodemSkipNoFile := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetZmodemFileOptions : TZmodemFileOptions;
begin
  Result := FProtocol.ZmodemFileOption;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetZmodemFileOptions(Value : TZmodemFileOptions);
begin
  FProtocol.ZmodemFileOption := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetZmodemRecover : WordBool;
begin
  Result := FProtocol.ZmodemRecover;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetZmodemRecover(Value : WordBool);
begin
  FProtocol.ZmodemRecover := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetZmodem8K : WordBool;
begin
  Result := FProtocol.Zmodem8K;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetZmodem8K(Value : WordBool);
begin
  FProtocol.Zmodem8K := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetZmodemFinishRetry : Integer;
begin
  Result := FProtocol.ZmodemFinishRetry;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetZmodemFinishRetry(Value : Integer);
begin
  FProtocol.ZmodemFinishRetry := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitMaxLen : Integer;
begin
  Result := FProtocol.KermitMaxLen;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.setKermitMaxLen(Value : Integer);
begin
  FProtocol.KermitMaxLen := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitMaxWindows : Integer;
begin
  Result := FProtocol.KermitMaxWindows;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitMaxWindows(Value : Integer);
begin
  FProtocol.KermitMaxWindows := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitSWCTurnDelay : Integer;
begin
  Result := FProtocol.KermitSWCTurnDelay;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitSWCTurnDelay(Value : Integer);
begin
  FProtocol.KermitSWCTurnDelay := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitTimeoutSecs : Integer;
begin
  Result := FProtocol.KermitTimeoutSecs;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitTimeoutSecs(Value : Integer);
begin
  FProtocol.KermitTimeoutSecs := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitPadCharacter : Integer;
begin
  Result := Integer(FProtocol.KermitPadCharacter);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitPadCharacter(Value : Integer);
begin
  FProtocol.KermitPadCharacter := Char(Value);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitPadCount : Integer;
begin
  Result := FProtocol.KermitPadCount;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitPadCount(Value : Integer);
begin
  FProtocol.KermitPadCount := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitTerminator : Integer;
begin
  Result := Integer(FProtocol.KermitTerminator);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitTerminator(Value : Integer);
begin
  FProtocol.KermitTerminator := Char(Value);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitCtlPrefix : Integer;
begin
  Result := Integer(FProtocol.KermitCtlPrefix);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitCtlPrefix(Value : Integer);
begin
  FProtocol.KermitCtlPrefix := Char(Value);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitHighbitPrefix : Integer;
begin
  Result := Integer(FProtocol.KermitHighbitPrefix);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitHighbitPrefix(Value : Integer);
begin
  FProtocol.KermitHighbitPrefix := Char(Value);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitRepeatPrefix : Integer;
begin
  Result := Integer(FProtocol.KermitRepeatPrefix);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetKermitRepeatPrefix(Value : Integer);
begin
  FProtocol.KermitRepeatPrefix := Char(Value);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitWindowsTotal : Integer;
begin
  Result := FProtocol.KermitWindowsTotal;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitWindowsUsed : Integer;
begin
  Result := FProtocol.KermitWindowsUsed;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetKermitLongBlocks : WordBool;
begin
  Result := FProtocol.KermitLongBlocks;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetAsciiCharDelay : Integer;
begin
  Result := FProtocol.AsciiCharDelay;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAsciiCharDelay(Value : Integer);
begin
  FProtocol.AsciiCharDelay := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetAsciiLineDelay : Integer;
begin
  Result := FProtocol.AsciiLineDelay;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAsciiLineDelay(Value : Integer);
begin
  FProtocol.AsciiLineDelay := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetAsciiEOLChar : Integer;
begin
  Result := Integer(FProtocol.AsciiEOLChar);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAsciiEOLChar(Value : Integer);
begin
  FProtocol.AsciiEOLChar := Char(Value);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetAsciiCRTranslation : TAsciiEOLTranslation;
begin
  Result := FProtocol.AsciiCRTranslation;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAsciiCRTranslation(Value : TAsciiEOLTranslation);
begin
  FProtocol.AsciiCRTranslation := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetAsciiLFTranslation : TAsciiEOLTranslation;
begin
  Result := FProtocol.AsciiLFTranslation;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAsciiLFTranslation(Value : TAsciiEOLTranslation);
begin
  FProtocol.AsciiLFTranslation := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetAsciiEOFTimeout : Integer;
begin
  Result := FProtocol.AsciiEOFTimeout;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetAsciiEOFTimeout(Value : Integer);
begin
  FProtocol.AsciiEOFTimeout := Value;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.EstimateTransferSecs(const Size : Integer) : Integer;
begin
  Result := FProtocol.EstimateTransferSecs(Size);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.StartTransmit;
begin
  FProtocol.StartTransmit;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.StartReceive;
begin
  FProtocol.StartReceive;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.CancelProtocol;
begin
  FProtocol.CancelProtocol;
end;

{ ======================================================================= }
{ == MSComm Compatibilty ================================================ }
{ ======================================================================= }
function TApxTerminal.GetMSCommBreak : WordBool;
begin
  Result := False;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommBreak(Value : WordBool);
begin
  SendBreak(1, True);
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommCDHolding : WordBool;
begin
  Result := DCD;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommCommEvent : Smallint;
begin
  Result := FMSCommCommEvent;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommCommPort : Smallint;
begin
  Result := ComNumber;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommCommPort(Value : Smallint);
begin
  ComNumber := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommCompatible : WordBool;
begin
  Result := FMSCommCompatible;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommCompatible(Value : WordBool);
begin
  if (Value <> FMSCommCompatible) then begin
    FMSCommCompatible := Value;
    if FMSCommCompatible then begin
      if Assigned(FMSCommInBuffer) then
        FMSCommInBuffer.Size := FMSCommInBufferSize
      else
        FMSCommInBuffer := TApxCircularBuffer.Create(FMSCommInBufferSize);
    end else
      FMSCommInBuffer := nil;
  end;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommCTSHolding : WordBool;
begin
  Result := CTS;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommDSRHolding : WordBool;
begin
  Result := DSR;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommDTREnable : WordBool;
begin
  Result := DTR;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommDTREnable(Value : WordBool);
begin
  DTR := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommHandshaking : Integer;
begin
  if (SWFlowOptions = swfNone) then begin
    if HWFlowUseRTS then
      Result := comRTS
    else
      Result := comNone;
  end else begin
    if HWFlowUseRTS then
      Result := comRTSXOnXoff
    else
      Result := comXOnXoff;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommHandshaking(Value : Integer);
begin
  case Value of
    comNone       : begin
                      SWFlowOptions := swfNone;
                      HWFlowUseRTS := False;
                    end;
    comXOnXoff    : begin
                      SWFlowOptions := swfBoth;
                      HWFlowUseRTS := False;
                    end;
    comRTS        : begin
                      SWFlowOptions := swfNone;
                      HWFlowUseRTS := True;
                    end;
    comRTSXOnXOff : begin
                      SWFlowOptions := swfBoth;
                      HWFlowUseRTS := True;
                    end;
  end;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommInBufferSize : Smallint;
begin
  Result := FMSCommInBufferSize;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommInBufferSize(Value : Smallint);
begin
  if (Value <> FMSCommInBufferSize) then begin
    FMSCommInBufferSize := Value;
    if FMSCommCompatible then begin
      if Assigned(FMSCommInBuffer) then
        FMSCommInBuffer.Size := FMSCommInBufferSize
      else
        FMSCommInBuffer := TApxCircularBuffer.Create(FMSCommInBufferSize);
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommInBufferCount : Smallint;
begin
  if FMSCommCompatible and Assigned(FMSCommInBuffer) then
    Result := FMSCommInBuffer.Count
  else
    Result := 0;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommInBufferCount(Value : Smallint);
begin
  if FMSCommCompatible and Assigned(FMSCommInBuffer) and (Value = 0) then
    FMSCommInBuffer.Clear;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommInput : OleVariant;
var
  i, N : Smallint;
  S : WideString;
begin
  if not FMSCommCompatible or (FMSCommInBuffer.Count = 0) then
    Result := Null
  else begin
    if (FMSCommInBuffer.Count <= FMSCommInputLen) or (FMSCommInputLen = 0) then
      N := FMSCommInBuffer.Count
    else
      N := FMSCommInputLen;
    if (FMSCommInputMode = comInputModeText) then begin
      S := '';                                                           {!!.01}
      for i := 1 to N do
        S := S + Char(FMSCommInBuffer.GetByte);                          {!!.01}
      Result := S;                                                       {!!.01}
    end else begin
      Result := VarArrayCreate([1, N], varByte);
      for i := 1 to N do
        Result[i] := FMSCommInBuffer.GetByte;
    end;
  end;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommInputLen : Smallint;
begin
  Result := FMSCommInputLen;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommInputLen(Value : Smallint);
begin
  FMSCommInputLen := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommInputMode : Integer;
begin
  Result := FMSCommInputMode;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommInputMode(Value : Integer);
begin
  FMSCommInputMode := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommOutBufferSize : Smallint;
begin
  result := FMSCommOutBufferSize;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommOutBufferSize(Value : Smallint);
begin
  if (Value <> FMSCommOutBufferSize) then begin
    FMSCommOutBufferSize := Value;
    if FMSCommCompatible then
      FPort.OutSize := Value;
  end;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommOutBufferCount : Smallint;
begin
  if FMSCommCompatible then
    Result := OutBuffUsed
  else
    Result := 0;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommOutBufferCount(Value : Smallint);
begin
  if FMSCommCompatible and (Value = 0) then
    FlushOutBuffer;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommOutput(Value : OleVariant);
begin
  PutData(Value);
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommRTSEnable : WordBool;
begin
  Result := RTS;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommRTSEnable(Value : WordBool);
begin
  RTS := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommRTThreshold : Smallint;
begin
  Result := FMSCommRTThreshold;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommRTThreshold(Value : Smallint);
begin
  FMSCommRTThreshold := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommSThreshold : Smallint;
begin
  Result := FMSCommSThreshold;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommSThreshold(Value : Smallint);
begin
  FMSCommSThreshold := Value;
end;
{ ----------------------------------------------------------------------- }
function  TApxTerminal.GetMSCommSettings : WideString;
const
  ParityChar : array[TParity] of Char = ('N', 'O', 'E', 'M', 'S');
begin
  Result := IntToStr(Baud) + ',' + ParityChar[Parity] + ',' + IntToStr(DataBits) + ',';
  if (DataBits = 5) and (StopBits = 2) then
    Result := Result + '1.5'
  else
    Result := Result + IntToStr(StopBits);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetMSCommSettings(Value : WideString);
var
  i : Integer;
  S, SubStr : string;
begin
  S := Value;
  if (S <> '') then begin
    { baud }
    i := CharPos(',', Value);
    if (i > 1) then begin
      SubStr := Copy(S, 1, i-1);
      S := Copy(S, i+1, Length(S));
      Baud := StrToIntDef(SubStr, 19200);
    end else
      Exit;

    { parity }
    i := CharPos(',', S);
    if (i > 1) then begin
      SubStr := Copy(S, 1, i-1);
      S := Copy(S, i+1, Length(S));
      case SubStr[1] of
        'E' : Parity := pEven;
        'M' : Parity := pMark;
        'N' : Parity := pNone;
        'O' : Parity := pOdd;
        'S' : Parity := pSpace;
      end;
    end else
      Exit;

    { data bits }
    i := CharPos(',', S);
    if (i > 1) then begin
      SubStr := Copy(S, 1, i-1);
      S := Copy(S, i+1, Length(S));
      DataBits := StrToIntDef(SubStr, 8);
    end else
      Exit;

    { stop bits }
    if (S <> '') then begin
      if (S = '1.5')  or (S = '2') then
        StopBits := 2
      else
        StopBits := 1;
    end;
  end;
end;

{ ======================================================================= }
{ == TApxCircularBuffer ================================================= }
{ ======================================================================= }
constructor TApxCircularBuffer.Create(ASize : Smallint);
begin
  inherited Create;
  FSize := ASize;
  GetMem(PBuffer, ASize);
  Head := 0;
  Tail := 0;
  Full := False;
end;
{ ----------------------------------------------------------------------- }
destructor TApxCircularBuffer.Destroy;
begin
  FreeMem(PBuffer, FSize);
  inherited Destroy;
end;
{ ----------------------------------------------------------------------- }
procedure TApxCircularBuffer.Clear;
begin
  Head := 0;
  Tail := 0;
  Full := False;
end;
{ ----------------------------------------------------------------------- }
function TApxCircularBuffer.GetByte : Byte;
begin
  if (Count > 0) then begin
    Result := PBuffer^[Head];
    Head := (Head + 1) mod FSize;
    Full := False;
  end else
    Result := 0;
end;
{ ----------------------------------------------------------------------- }
function TApxCircularBuffer.PutByte(Data : Byte) : Boolean;
begin
  if not Full then begin
    PBuffer^[Tail] := Data;
    Tail := (Tail + 1) mod FSize;
    if (Tail = Head) then
      Full := True;
    Result := True;
  end else
    Result := False;  { buffer full }
end;
{ ----------------------------------------------------------------------- }
function TApxCircularBuffer.GetCount : Smallint;
begin
  if Full then
    Result := FSize
  else if (Head <= Tail) then
    Result := Tail - Head
  else
    Result := (FSize - Head - 1) + Tail;
end;
{ ----------------------------------------------------------------------- }
procedure TApxCircularBuffer.SetSize(Value : Smallint);
begin
  if (Value <> FSize) then begin
    FreeMem(PBuffer, FSize);
    GetMem(PBuffer, Value);
    FSize := Value;
    Head := 0;
    Tail := 0;
    Full := False;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWsLocalAddress: WideString;                     {!!.01}
begin
  Result := ApdSocket.LocalAddress;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWsLocalDescription: WideString;                 {!!.01}
begin
  Result := ApdSocket.Description;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWsLocalHighVersion: Widestring;                 {!!.01}
begin
  Result := IntToStr(LOBYTE(ApdSocket.HighVersion)) + '.' +
            IntToStr(HIBYTE(ApdSocket.HighVersion));
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWsLocalHost: WideString;                        {!!.01}
begin
  Result := ApdSocket.LocalHost;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWsLocalMaxSockets: Integer;                     {!!.01}
begin
  Result := ApdSocket.MaxSockets;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWsLocalSystemStatus: WideString;                {!!.01}
begin
  Result := ApdSocket.SystemStatus;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetWsLocalVersion: Widestring;                     {!!.01}
begin
  Result := IntToStr(LOBYTE(ApdSocket.WsVersion)) + '.' +
            IntToStr(HIBYTE(ApdSocket.WsVersion));
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.ErrorMsg(ErrorCode: Integer): WideString;          {!!.01}
begin
  Result := AdExcept.ErrorMsg(ErrorCode);
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.ErrorMsgEx(ErrorCode: Integer;                     {!!.01}
  LangIniFile: WideString): WideString;
begin

end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.EnumTapiFirst: WideString;
begin
  FEnumIndex := 0;
  if FTapiDevice.TapiDevices.Count > 0 then
    Result := FTapiDevice.TapiDevices[FEnumIndex]
  else
    Result := '';
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.EnumTapiNext: WideString;
begin
  inc(FEnumIndex);
  if FTapiDevice.TapiDevices.Count > FEnumIndex then
    Result := FTapiDevice.TapiDevices[FEnumIndex]
  else
    Result := '';
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.DelayTicks(Ticks: Integer);
begin
  OOMisc.DelayTicks(Ticks, True);
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiLoadConfig(const RegKey, KeyName: WideString);{!!.11}
var
  Reg : TRegistry;
  TapiCfg : TTapiConfigRec;
begin
  Reg := nil;
  try
    try
      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      TapiCfg.DataSize := 0;
      FillChar(TapiCfg.Data, SizeOf(TapiCfg.Data), #0);
      if Reg.OpenKey(RegKey, False) then begin
        Reg.ReadBinaryData(KeyName, TapiCfg.Data, TapiCfg.DataSize);
        FTapiDevice.SetDevConfig(TapiCfg);
      end;
    except
      { eat the exception here }
    end;
  finally
    Reg.Free;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.TapiSaveConfig(const RegKey, KeyName: WideString);{!!.11}
var
  Reg : TRegistry;
  TapiCfg : TTapiConfigRec;
begin
  Reg := nil;
  try
    try
      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      TapiCfg := FTapiDevice.GetDevConfig;
      Reg.OpenKey(RegKey, True);
      Reg.WriteBinaryData(KeyName, TapiCfg.Data, TapiCfg.DataSize);
    except
      { eat the exception here }
    end;
  finally
    Reg.Free;
  end;
end;
{ ----------------------------------------------------------------------- }
function TApxTerminal.GetTapiConfig: OleVariant;                         {!!.11}
var
  i : Integer;
  TapiCfg : TTapiConfigRec;
begin
  TapiCfg := FTapiDevice.GetDevConfig;
  Result := VarArrayCreate([1, TapiCfg.DataSize], varByte);
  for i := 1 to TapiCfg.DataSize do
    try
      Result[i] := Byte(TapiCfg.Data[i]);
    except
    end;

end;
{ ----------------------------------------------------------------------- }
procedure TApxTerminal.SetTapiConfig(Config: OleVariant);                {!!.11}
var
  i : Integer;
  TapiCfg : TTapiConfigRec;
begin
  try
    TapiCfg.DataSize := VarArrayHighBound(Config, 1);
    TapiCfg.Data[0] := TapiCfg.DataSize;
    for i := 1 to VarArrayHighBound(Config, 1)  do
      TapiCfg.Data[i] := Config[i];
    FTapiDevice.SetDevConfig(TapiCfg);
  except
  { eat the exception }
  end;
end;

end.
