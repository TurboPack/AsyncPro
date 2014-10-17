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
{*                       APAXIMPL.PAS 1.13                        *}
{******************************************************************}
{* ApaxImpl.PAS - ActiveX implementation unit                     *}
{******************************************************************}

unit ApaxImpl;
{$I AXDEFINE.INC}
{$I AwDefine.inc} 
{$IFNDEF APAX}
!!! Add APAX to the project options Defines !!!
{$ENDIF}
{$IFNDEF Ver130}
!!! This should be compiled in Delphi 5, it may work with others
!!! but it hasnt been tested there
{$ENDIF}
interface

uses
  Windows, ActiveX, Classes, Controls, Graphics, Menus, Forms, StdCtrls,
  Dialogs, ComServ, StdVCL, AXCtrls, AxTerm, ExtCtrls, APAX1_TLB, AdFtp,
  AdPort, AdWnPort, AdSocket, AdPacket, AdTapi, AdTUtil, AdProtCl, AdTrmEmu,
  OOMisc;

type
  TApax = class(TActiveXControl, IApax)
  private
    { Private declarations }
    FDelphiControl: TApxTerminal;
    FEvents: IApaxEvents;
    procedure MSCommEvent;
    procedure CloseButtonClickEvent(var Default: WordBool);
    procedure ConnectButtonClickEvent(var Default: WordBool);
    procedure CTSChangedEvent(NewValue: WordBool);
    procedure CursorMovedEvent(aRow, aCol: Integer);
    procedure ProcessCharEvent(Character   : Char;
                               var ReplaceWith : string;
                               Commands    : TAdEmuCommandList;
                               CharSource  : TAdCharSource);

    procedure DataTriggerEvent(Index: Integer; Timeout: WordBool;
      Data: OleVariant; Size: Integer; var ReEnable: WordBool);
    procedure DCDChangedEvent(NewValue: WordBool);
    procedure DeviceButtonClickEvent(DeviceType: TApxDeviceType);
    procedure DSRChangedEvent(NewValue: WordBool);
    procedure EmulationButtonClickEvent(Emulation: TApxTerminalEmulation);
    procedure FontButtonClickEvent(var Default: WordBool);
    procedure LineBreakEvent;
    procedure LineErrorEvent;
    procedure ListenButtonClickEvent(var Default: WordBool);
    procedure PortCloseEvent;
    procedure PortOpenEvent;
    procedure ProtocolAcceptEvent(var Accept: WordBool; var FName: WideString);
    procedure ProtocolFinishEvent(ErrorCode: Integer);
    procedure ProtocolLogEvent(Log: Integer);
    procedure ProtocolStatusEvent(Options: Integer);
    procedure ReceiveButtonClickEvent(var Default: WordBool);
    procedure RingEvent;
    procedure RXDEvent(Data: OleVariant);
    procedure SendButtonClickEvent(var Default: WordBool);
    procedure TapiCallerIDEvent(const ID, IDName: WideString);
    procedure TapiConnectEvent;
    procedure TapiDTMFEvent(Digit: Byte; ErrorCode: Integer);
    procedure TapiFailEvent;
    procedure TapiGetNumberEvent(var PhoneNum: WideString);
    procedure TapiPortCloseEvent;
    procedure TapiPortOpenEvent;
    procedure TapiStatusEvent(First, Last: WordBool; Device, Message, Param1,
      Param2, Param3: Integer);
    procedure TapiWaveNotifyEvent(Msg: TWaveMessage);
    procedure TapiWaveSilenceEvent(var StopRecording, Hangup: WordBool);
    procedure WinsockAcceptEvent(Addr: WideString; var Accept: WordBool);
    procedure WinsockConnectEvent;
    procedure WinsockDisconnectEvent;
    procedure WinsockErrorEvent(ErrCode: Integer);
    procedure WinsockGetAddressEvent(var Address, Port: WideString);

    { FTP event handlers }
    procedure DoFTPErrorEvent(Sender : TObject; ErrorCode : Integer; ErrorText : PChar);
    procedure DoFTPLogEvent(Sender : TObject; LogCode : TFtpLogCode);
    procedure DoFTPReplyEvent(Sender : TObject; ReplyCode : Integer; ReplyText : PChar);
    procedure DoFTPStatusEvent(Sender : TObject; StatusCode : TFtpStatusCode; InfoText : PChar);

  protected
    { Protected declarations }
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure InitializeControl; override;
    function AddDataTrigger(const TriggerString: WideString; PacketSize,
      Timeout: Integer; IncludeStrings, IgnoreCase: WordBool): Integer;
      safecall;
    function Close: Integer; safecall;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function EstimateTransferSecs(Size: Integer): Integer; safecall;
    function Get_AbortNoCarrier: WordBool; safecall;
    function Get_AnswerOnRing: Integer; safecall;
    function Get_AsciiCharDelay: Integer; safecall;
    function Get_AsciiCRTranslation: TxAsciiEOLTranslation; safecall;
    function Get_AsciiEOFTimeout: Integer; safecall;
    function Get_AsciiEOLChar: Integer; safecall;
    function Get_AsciiLFTranslation: TxAsciiEOLTranslation; safecall;
    function Get_AsciiLineDelay: Integer; safecall;
    function Get_AsciiSuppressCtrlZ: WordBool; safecall;
    function Get_Batch: WordBool; safecall;
    function Get_Baud: Integer; safecall;
    function Get_BlockCheckMethod: TxBlockCheckMethod; safecall;
    function Get_BlockErrors: Integer; safecall;
    function Get_BlockLength: Integer; safecall;
    function Get_BlockNumber: Integer; safecall;
    function Get_BytesRemaining: Integer; safecall;
    function Get_BytesTransferred: Integer; safecall;
    function Get_CallerID: WideString; safecall;
    function Get_Caption: WideString; safecall;
    function Get_CaptionAlignment: TxAlignment; safecall;
    function Get_CaptionWidth: Integer; safecall;
    function Get_CaptureFile: WideString; safecall;
    function Get_CaptureMode: TxAdCaptureMode; safecall;
    function Get_Color: OLE_COLOR; safecall;
    function Get_Columns: Integer; safecall;
    function Get_ComNumber: Integer; safecall;
    function Get_CTS: WordBool; safecall;
    function Get_Cursor: Smallint; safecall;
    function Get_DataBits: Integer; safecall;
    function Get_DataTriggerString: WideString; safecall;
    function Get_DCD: WordBool; safecall;
    function Get_DeviceType: TxApxDeviceType; safecall;
    function Get_Dialing: WordBool; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    function Get_DSR: WordBool; safecall;
    function Get_DTR: WordBool; safecall;
    function Get_ElapsedTicks: Integer; safecall;
    function Get_Emulation: TxApxTerminalEmulation; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_EnableVoice: WordBool; safecall;
    function Get_FileDate: Double; safecall;
    function Get_FileLength: Integer; safecall;
    function Get_FinishWait: Integer; safecall;
    function Get_FlowState: TxFlowControlState; safecall;
    function Get_Font: IFontDisp; safecall;
    function Get_HandshakeRetry: Integer; safecall;
    function Get_HandshakeWait: Integer; safecall;
    function Get_HonorDirectory: WordBool; safecall;
    function Get_HWFlowRequireCTS: WordBool; safecall;
    function Get_HWFlowRequireDSR: WordBool; safecall;
    function Get_HWFlowUseDTR: WordBool; safecall;
    function Get_HWFlowUseRTS: WordBool; safecall;
    function Get_InBuffFree: Integer; safecall;
    function Get_InBuffUsed: Integer; safecall;
    function Get_IncludeDirectory: WordBool; safecall;
    function Get_InitialPosition: Integer; safecall;
    function Get_InProgress: WordBool; safecall;
    function Get_InterruptWave: WordBool; safecall;
    function Get_KermitCtlPrefix: Integer; safecall;
    function Get_KermitHighbitPrefix: Integer; safecall;
    function Get_KermitLongBlocks: WordBool; safecall;
    function Get_KermitMaxLen: Integer; safecall;
    function Get_KermitMaxWindows: Integer; safecall;
    function Get_KermitPadCharacter: Integer; safecall;
    function Get_KermitPadCount: Integer; safecall;
    function Get_KermitRepeatPrefix: Integer; safecall;
    function Get_KermitSWCTurnDelay: Integer; safecall;
    function Get_KermitTerminator: Integer; safecall;
    function Get_KermitTimeoutSecs: Integer; safecall;
    function Get_KermitWindowsTotal: Integer; safecall;
    function Get_KermitWindowsUsed: Integer; safecall;
    function Get_LightsLitColor: OLE_COLOR; safecall;
    function Get_LightsNotLitColor: OLE_COLOR; safecall;
    function Get_LightWidth: Integer; safecall;
    function Get_LineError: Integer; safecall;
    function Get_LogAllHex: WordBool; safecall;
    function Get_Logging: TxTraceLogState; safecall;
    function Get_LogHex: WordBool; safecall;
    function Get_LogName: WideString; safecall;
    function Get_LogSize: Integer; safecall;
    function Get_MaxAttempts: Integer; safecall;
    function Get_MaxMessageLength: Integer; safecall;
    function Get_OutBuffFree: Integer; safecall;
    function Get_OutBuffUsed: Integer; safecall;
    function Get_Parity: TxParity; safecall;
    function Get_PromptForPort: WordBool; safecall;
    function Get_Protocol: TxProtocolType; safecall;
    function Get_ProtocolStatus: Integer; safecall;
    function Get_ProtocolStatusDisplay: WordBool; safecall;
    function Get_ReceiveDirectory: WideString; safecall;
    function Get_ReceiveFileName: WideString; safecall;
    function Get_RI: WordBool; safecall;
    function Get_Rows: Integer; safecall;
    function Get_RS485Mode: WordBool; safecall;
    function Get_RTS: WordBool; safecall;
    function Get_RTSLowForWrite: WordBool; safecall;
    function Get_ScrollbackEnabled: WordBool; safecall;
    function Get_ScrollbackRows: Integer; safecall;
    function Get_SelectedDevice: WideString; safecall;
    function Get_SendFileName: WideString; safecall;
    function Get_ShowConnectButtons: WordBool; safecall;
    function Get_ShowDeviceSelButton: WordBool; safecall;
    function Get_ShowLightCaptions: WordBool; safecall;
    function Get_ShowLights: WordBool; safecall;
    function Get_ShowProtocolButtons: WordBool; safecall;
    function Get_ShowStatusBar: WordBool; safecall;
    function Get_ShowTerminalButtons: WordBool; safecall;
    function Get_ShowToolBar: WordBool; safecall;
    function Get_SilenceThreshold: Integer; safecall;
    function Get_StatusInterval: Integer; safecall;
    function Get_StopBits: Integer; safecall;
    function Get_SWFlowOptions: TxSWFlowOptions; safecall;
    function Get_TapiAttempt: Integer; safecall;
    function Get_TapiCancelled: WordBool; safecall;
    function Get_TapiFailCode: Integer; safecall;                       {!!.01}
    function Get_TapiNumber: WideString; safecall;
    function Get_TapiRetryWait: Integer; safecall;
    function Get_TapiState: TxTapiState; safecall;
    function Get_TerminalActive: WordBool; safecall;
    function Get_TerminalBlinkTime: Integer; safecall;
    function Get_TerminalHalfDuplex: WordBool; safecall;
    function Get_TerminalLazyByteDelay: Integer; safecall;
    function Get_TerminalLazyTimeDelay: Integer; safecall;
    function Get_TerminalUseLazyDisplay: WordBool; safecall;
    function Get_TerminalWantAllKeys: WordBool; safecall;
    function Get_TotalErrors: Integer; safecall;
    function Get_TransmitTimeout: Integer; safecall;
    function Get_TrimSeconds: Integer; safecall;
    function Get_UpcaseFileNames: WordBool; safecall;
    function Get_UseSoundCard: WordBool; safecall;
    function Get_Version: WideString; safecall;
    function Get_Visible: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    function Get_WaveFileName: WideString; safecall;
    function Get_WaveState: TxWaveState; safecall;
    function Get_WinsockAddress: WideString; safecall;
    function Get_WinsockMode: TxWsMode; safecall;
    function Get_WinsockPort: WideString; safecall;
    function Get_WriteFailAction: TxWriteFailAction; safecall;
    function Get_WsTelnet: WordBool; safecall;
    function Get_XOffChar: Integer; safecall;
    function Get_XOnChar: Integer; safecall;
    function Get_XYmodemBlockWait: Integer; safecall;
    function Get_Zmodem8K: WordBool; safecall;
    function Get_ZmodemFileOptions: TxZmodemFileOptions; safecall;
    function Get_ZmodemFinishRetry: Integer; safecall;
    function Get_ZmodemOptionOverride: WordBool; safecall;
    function Get_ZmodemRecover: WordBool; safecall;
    function Get_ZmodemSkipNoFile: WordBool; safecall;
    function GetAttributes(aRow, aCol: Integer): Integer; safecall;
    function GetLine(Index: Integer): WideString; safecall;
    function IsPortAvail(ComNumber: Integer): WordBool; safecall;
    function IsRightToLeft: WordBool; safecall;
    function PortOpen: Integer; safecall;
    function TapiAnswer: Integer; safecall;
    function TapiDial: Integer; safecall;
    function TapiTranslatePhoneNo(const CanonicalAddr: WideString): WideString;
      safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    function WinsockConnect: Integer; safecall;
    function WinsockListen: Integer; safecall;
    procedure _Set_Font(const Value: IFontDisp); safecall;
    procedure AboutBox; safecall;
    procedure AddStringToLog(const S: WideString); safecall;
    procedure CancelProtocol; safecall;
    procedure Clear; safecall;
    procedure ClearAll; safecall;
    procedure CopyToClipboard; safecall;
    procedure DisableDataTrigger(Index: Integer); safecall;
    procedure EnableDataTrigger(Index: Integer); safecall;
    procedure FlushInBuffer; safecall;
    procedure FlushOutBuffer; safecall;
    procedure InitiateAction; reintroduce; safecall;
    function PutData(Data: OleVariant): Integer; safecall;
    function PutString(const S: WideString): Integer; safecall;
    function PutStringCRLF(const S: WideString): Integer; safecall;
    procedure RemoveDataTrigger(Index: Integer); safecall;
    procedure SendBreak(Ticks: Integer; Yield: WordBool); safecall;
    procedure Set_AbortNoCarrier(Value: WordBool); safecall;
    procedure Set_AnswerOnRing(Value: Integer); safecall;
    procedure Set_AsciiCharDelay(Value: Integer); safecall;
    procedure Set_AsciiCRTranslation(Value: TxAsciiEOLTranslation); safecall;
    procedure Set_AsciiEOFTimeout(Value: Integer); safecall;
    procedure Set_AsciiEOLChar(Value: Integer); safecall;
    procedure Set_AsciiLFTranslation(Value: TxAsciiEOLTranslation); safecall;
    procedure Set_AsciiLineDelay(Value: Integer); safecall;
    procedure Set_AsciiSuppressCtrlZ(Value: WordBool); safecall;
    procedure Set_Baud(Value: Integer); safecall;
    procedure Set_BlockCheckMethod(Value: TxBlockCheckMethod); safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure Set_CaptionAlignment(Value: TxAlignment); safecall;
    procedure Set_CaptionWidth(Value: Integer); safecall;
    procedure Set_CaptureFile(const Value: WideString); safecall;
    procedure Set_CaptureMode(Value: TxAdCaptureMode); safecall;
    procedure Set_Color(Value: OLE_COLOR); safecall;
    procedure Set_Columns(Value: Integer); safecall;
    procedure Set_ComNumber(Value: Integer); safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure Set_DataBits(Value: Integer); safecall;
    procedure Set_DataTriggerString(const Value: WideString); safecall;
    procedure Set_DeviceType(Value: TxApxDeviceType); safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure Set_DTR(Value: WordBool); safecall;
    procedure Set_Emulation(Value: TxApxTerminalEmulation); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_EnableVoice(Value: WordBool); safecall;
    procedure Set_FinishWait(Value: Integer); safecall;
    procedure Set_Font(var Value: IFontDisp); safecall;
    procedure Set_HandshakeRetry(Value: Integer); safecall;
    procedure Set_HandshakeWait(Value: Integer); safecall;
    procedure Set_HonorDirectory(Value: WordBool); safecall;
    procedure Set_HWFlowRequireCTS(Value: WordBool); safecall;
    procedure Set_HWFlowRequireDSR(Value: WordBool); safecall;
    procedure Set_HWFlowUseDTR(Value: WordBool); safecall;
    procedure Set_HWFlowUseRTS(Value: WordBool); safecall;
    procedure Set_IncludeDirectory(Value: WordBool); safecall;
    procedure Set_InterruptWave(Value: WordBool); safecall;
    procedure Set_KermitCtlPrefix(Value: Integer); safecall;
    procedure Set_KermitHighbitPrefix(Value: Integer); safecall;
    procedure Set_KermitMaxLen(Value: Integer); safecall;
    procedure Set_KermitMaxWindows(Value: Integer); safecall;
    procedure Set_KermitPadCharacter(Value: Integer); safecall;
    procedure Set_KermitPadCount(Value: Integer); safecall;
    procedure Set_KermitRepeatPrefix(Value: Integer); safecall;
    procedure Set_KermitSWCTurnDelay(Value: Integer); safecall;
    procedure Set_KermitTerminator(Value: Integer); safecall;
    procedure Set_KermitTimeoutSecs(Value: Integer); safecall;
    procedure Set_LightsLitColor(Value: OLE_COLOR); safecall;
    procedure Set_LightsNotLitColor(Value: OLE_COLOR); safecall;
    procedure Set_LightWidth(Value: Integer); safecall;
    procedure Set_LogAllHex(Value: WordBool); safecall;
    procedure Set_Logging(Value: TxTraceLogState); safecall;
    procedure Set_LogHex(Value: WordBool); safecall;
    procedure Set_LogName(const Value: WideString); safecall;
    procedure Set_LogSize(Value: Integer); safecall;
    procedure Set_MaxAttempts(Value: Integer); safecall;
    procedure Set_MaxMessageLength(Value: Integer); safecall;
    procedure Set_Parity(Value: TxParity); safecall;
    procedure Set_PromptForPort(Value: WordBool); safecall;
    procedure Set_Protocol(Value: TxProtocolType); safecall;
    procedure Set_ProtocolStatusDisplay(Value: WordBool); safecall;
    procedure Set_ReceiveDirectory(const Value: WideString); safecall;
    procedure Set_ReceiveFileName(const Value: WideString); safecall;
    procedure Set_Rows(Value: Integer); safecall;
    procedure Set_RS485Mode(Value: WordBool); safecall;
    procedure Set_RTS(Value: WordBool); safecall;
    procedure Set_RTSLowForWrite(Value: WordBool); safecall;
    procedure Set_ScrollbackEnabled(Value: WordBool); safecall;
    procedure Set_ScrollbackRows(Value: Integer); safecall;
    procedure Set_SelectedDevice(const Value: WideString); safecall;
    procedure Set_SendFileName(const Value: WideString); safecall;
    procedure Set_ShowConnectButtons(Value: WordBool); safecall;
    procedure Set_ShowDeviceSelButton(Value: WordBool); safecall;
    procedure Set_ShowLightCaptions(Value: WordBool); safecall;
    procedure Set_ShowLights(Value: WordBool); safecall;
    procedure Set_ShowProtocolButtons(Value: WordBool); safecall;
    procedure Set_ShowStatusBar(Value: WordBool); safecall;
    procedure Set_ShowTerminalButtons(Value: WordBool); safecall;
    procedure Set_ShowToolBar(Value: WordBool); safecall;
    procedure Set_SilenceThreshold(Value: Integer); safecall;
    procedure Set_StatusInterval(Value: Integer); safecall;
    procedure Set_StopBits(Value: Integer); safecall;
    procedure Set_SWFlowOptions(Value: TxSWFlowOptions); safecall;
    procedure Set_TapiNumber(const Value: WideString); safecall;
    procedure Set_TapiRetryWait(Value: Integer); safecall;
    procedure Set_TerminalActive(Value: WordBool); safecall;
    procedure Set_TerminalBlinkTime(Value: Integer); safecall;
    procedure Set_TerminalHalfDuplex(Value: WordBool); safecall;
    procedure Set_TerminalLazyByteDelay(Value: Integer); safecall;
    procedure Set_TerminalLazyTimeDelay(Value: Integer); safecall;
    procedure Set_TerminalUseLazyDisplay(Value: WordBool); safecall;
    procedure Set_TerminalWantAllKeys(Value: WordBool); safecall;
    procedure Set_TransmitTimeout(Value: Integer); safecall;
    procedure Set_TrimSeconds(Value: Integer); safecall;
    procedure Set_UpcaseFileNames(Value: WordBool); safecall;
    procedure Set_UseSoundCard(Value: WordBool); safecall;
    procedure Set_Version(const Value: WideString); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    procedure Set_WinsockAddress(const Value: WideString); safecall;
    procedure Set_WinsockMode(Value: TxWsMode); safecall;
    procedure Set_WinsockPort(const Value: WideString); safecall;
    procedure Set_WriteFailAction(Value: TxWriteFailAction); safecall;
    procedure Set_WsTelnet(Value: WordBool); safecall;
    procedure Set_XOffChar(Value: Integer); safecall;
    procedure Set_XOnChar(Value: Integer); safecall;
    procedure Set_XYmodemBlockWait(Value: Integer); safecall;
    procedure Set_Zmodem8K(Value: WordBool); safecall;
    procedure Set_ZmodemFileOptions(Value: TxZmodemFileOptions); safecall;
    procedure Set_ZmodemFinishRetry(Value: Integer); safecall;
    procedure Set_ZmodemOptionOverride(Value: WordBool); safecall;
    procedure Set_ZmodemRecover(Value: WordBool); safecall;
    procedure Set_ZmodemSkipNoFile(Value: WordBool); safecall;
    procedure SetAttributes(aRow, aCol, Value: Integer); safecall;
    procedure SetLine(Index: Integer; const Value: WideString); safecall;
    procedure StartReceive; safecall;
    procedure StartTransmit; safecall;
    procedure TapiAutoAnswer; safecall;
    procedure TapiCancelCall; safecall;
    procedure TapiConfigAndOpen; safecall;
    procedure TapiPlayWaveFile(const FileName: WideString); safecall;
    procedure TapiRecordWaveFile(const FileName: WideString;
      Overwrite: WordBool); safecall;
    function TapiSelectDevice: WordBool; safecall;
    procedure TapiSendTone(const Digits: WideString); safecall;
    procedure TapiSetRecordingParams(NumChannels, NumSamplesPerSecond,
      NumBitsPerSample: Integer); safecall;
    procedure TapiShowConfigDialog(AllowEdit: WordBool); safecall;
    procedure TapiStopWaveFile; safecall;
    procedure TerminalSetFocus; safecall;
    procedure TerminalWriteString(const S: WideString); safecall;
    procedure TerminalWriteStringCRLF(const S: WideString); safecall;
    procedure RemoveAllDataTriggers; safecall;
    function TapiStatusMsg(Message, State, Reason: Integer): WideString;
      safecall;
    function Get_TapiStatusDisplay: WordBool; safecall;
    procedure Set_TapiStatusDisplay(Value: WordBool); safecall;
    function Get_CDHolding: WordBool; safecall;
    function Get_CommPort: Smallint; safecall;
    function Get_CTSHolding: WordBool; safecall;
    function Get_DSRHolding: WordBool; safecall;
    function Get_DTREnable: WordBool; safecall;
    function Get_Handshaking: HandshakeConstants; safecall;
    function Get_InBufferCount: Smallint; safecall;
    function Get_InBufferSize: Smallint; safecall;
    function Get_OutBufferCount: Smallint; safecall;
    function Get_OutBufferSize: Smallint; safecall;
    function Get_RTSEnable: WordBool; safecall;
    function Get_Settings: WideString; safecall;
    procedure Set_Break(Value: WordBool); safecall;
    procedure Set_CommPort(Value: Smallint); safecall;
    procedure Set_DTREnable(Value: WordBool); safecall;
    procedure Set_Handshaking(Value: HandshakeConstants); safecall;
    procedure Set_InBufferSize(Value: Smallint); safecall;
    procedure Set_OutBufferSize(Value: Smallint); safecall;
    procedure Set_RTSEnable(Value: WordBool); safecall;
    procedure Set_Settings(const Value: WideString); safecall;
    function Get_Input: OleVariant; safecall;
    function Get_InputLen: Smallint; safecall;
    function Get_InputMode: InputModeConstants; safecall;
    procedure Set_InputLen(Value: Smallint); safecall;
    procedure Set_InputMode(Value: InputModeConstants); safecall;
    procedure Set_Output(Value: OleVariant); safecall;
    function Get_CommEvent: Smallint; safecall;
    function Get_MSCommCompatible: WordBool; safecall;
    procedure Set_MSCommCompatible(Value: WordBool); safecall;
    function Get_RTThreshold: Smallint; safecall;
    procedure Set_RTThreshold(Value: Smallint); safecall;
    function Get_SThreshold: Smallint; safecall;
    procedure Set_SThreshold(Value: Smallint); safecall;
    function TapiTranslateDialog(const CanonicalAddr: WideString): WordBool;
      safecall;
    function ErrorMsg(ErrorCode: Integer): WideString; safecall;
    function ErrorMsgEx(ErrorCode: Integer;
      var LanguageFile: WideString): WideString; safecall;
    function EnumTapiFirst: WideString; safecall;
    function EnumTapiNext: WideString; safecall;
    function Get_WsLocalDescription: WideString; safecall;
    function Get_WsLocalHighVersion: WideString; safecall;
    function Get_WsLocalSystemStatus: WideString; safecall;
    function Get_WsLocalVersion: WideString; safecall;
    function Get_WsLocalAddress: WideString; safecall;
    function Get_WsLocalHostName: WideString; safecall;
    function Get_WsLocalMaxSockets: Integer; safecall;
    function IsPortInstalled(ComNumber: Integer): WordBool; safecall;
    procedure DelayTicks(Ticks: Integer); safecall;
    function FTPChangeDir(const RemotePathName: WideString): WordBool;
      safecall;
    function FTPAbort: WordBool; safecall;
    function FTPCurrentDir: WideString; safecall;
    function Get_FTPAccount: WideString; safecall;
    procedure Set_FTPAccount(const Value: WideString); safecall;
    function FTPDelete(const RemotePathName: WideString): WordBool; safecall;
    function Get_FTPConnected: WordBool; safecall;
    function Get_FTPConnectTimeout: Integer; safecall;
    procedure Set_FTPConnectTimeout(Value: Integer); safecall;
    function Get_FTPFileLength: Integer; safecall;
    function Get_FTPFileType: TxFTPFileType; safecall;
    procedure Set_FTPFileType(Value: TxFTPFileType); safecall;
    function FTPHelp(const Command: WideString): WideString; safecall;
    function Get_FTPInProgress: WordBool; safecall;
    function FTPListDir(const RemotePathName: WideString;
      FullList: WordBool): WideString; safecall;
    function FTPLogIn: WordBool; safecall;
    function FTPLogOut: WordBool; safecall;
    function FTPMakeDir(const RemotePathName: WideString): WordBool; safecall;
    function Get_FTPPassword: WideString; safecall;
    procedure Set_FTPPassword(const Value: WideString); safecall;
    function FTPRename(const RemotePathName,
      NewPathName: WideString): WordBool; safecall;
    function Get_FTPRestartAt: Integer; safecall;
    procedure Set_FTPRestartAt(Value: Integer); safecall;
    function FTPRetrieve(const RemotePathName, LocalPathName: WideString;
      RetrieveMode: TxFTPRetrieveMode): WordBool; safecall;
    function FTPSendFTPCommand(const FTPCommand: WideString): WideString;
      safecall;
    function Get_FTPServerAddress: WideString; safecall;
    procedure Set_FTPServerAddress(const Value: WideString); safecall;
    function FTPStatus(const RemotePathName: WideString): WideString; safecall;
    function IApax.FTPRetrieve = IApax_FTPRetrieve;
    function FTPStore(const RemotePathName, LocalPathName: WideString;
      StoreMode: TxFTPStoreMode): WordBool; safecall;
    function IApax_FTPRetrieve(const RemotePathName, LocalPathName: WideString;
      RetrieveMode: TxFTPRetrieveMode): WordBool; safecall;
    function Get_FTPTransferTimeout: Integer; safecall;
    function Get_FTPUserLoggedIn: WordBool; safecall;
    procedure Set_FTPTransferTimeout(Value: Integer); safecall;
    function Get_FTPUserName: WideString; safecall;
    procedure Set_FTPUserName(const Value: WideString); safecall;  function IApax.Get_FTPFileType = IApax_Get_FTPFileType;
    procedure IApax.Set_FTPFileType = IApax_Set_FTPFileType;
    function Get_FTPState: Integer; safecall;
    function IApax_Get_FTPFileType: TxFTPFileType; safecall;
    procedure IApax_Set_FTPFileType(Value: TxFTPFileType); safecall;
    function Get_FTPBytesTransferred: Integer; safecall;
    procedure TapiLoadConfig(const RegKey, KeyName: WideString); safecall;
    procedure TapiSaveConfig(const RegKey, KeyName: WideString); safecall;
    function GetTapiConfig: OleVariant; safecall;
    procedure SetTapiConfig(Value: OleVariant); safecall;
    function Get_FilterTapiDevices: WordBool; safecall;
    procedure Set_FilterTapiDevices(Value: WordBool); safecall;
  public
    function SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult; override;

  end;


implementation

uses SysUtils, ComObj,
     AxAbout, AxDevPg, AxLgtsPg, AxTermPg, AxProtPg, AxTrigPg;

{ ======================================================================= }
{ == TApax ============================================================== }
{ ======================================================================= }
procedure TApax.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  DefinePropertyPage(Class_ApxTerminalPage);
  DefinePropertyPage(Class_ApxDevicePage);
  DefinePropertyPage(Class_ApxProtocolPage);
  DefinePropertyPage(Class_ApxTriggerPage);
  DefinePropertyPage(Class_ApxLightsPage);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IApaxEvents;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.InitializeControl;
begin
  FDelphiControl := Control as TApxTerminal;
  FDelphiControl.MSCommOnCommEvent := MSCommEvent;
  FDelphiControl.OnCloseButtonClick := CloseButtonClickEvent;
  FDelphiControl.OnConnectButtonClick := ConnectButtonClickEvent;
  FDelphiControl.OnCTSChanged := CTSChangedEvent;
  FDelphiControl.OnCursorMoved := CursorMovedEvent;
  FDelphiControl.OnProcessChar := ProcessCharEvent;
  FDelphiControl.OnDataTrigger := DataTriggerEvent;
  FDelphiControl.OnDCDChanged := DCDChangedEvent;
  FDelphiControl.OnDeviceButtonClick := DeviceButtonClickEvent;
  FDelphiControl.OnDSRChanged := DSRChangedEvent;
  FDelphiControl.OnEmulationButtonClick := EmulationButtonClickEvent;
  FDelphiControl.OnFontButtonClick := FontButtonClickEvent;
  FDelphiControl.OnLineBreak := LineBreakEvent;
  FDelphiControl.OnLineError := LineErrorEvent;
  FDelphiControl.OnListenButtonClick := ListenButtonClickEvent;
  FDelphiControl.OnPortClose := PortCloseEvent;
  FDelphiControl.OnPortOpen := PortOpenEvent;
  FDelphiControl.OnProtocolAccept := ProtocolAcceptEvent;
  FDelphiControl.OnProtocolFinish := ProtocolFinishEvent;
  FDelphiControl.OnProtocolLog := ProtocolLogEvent;
  FDelphiControl.OnProtocolStatus := ProtocolStatusEvent;
  FDelphiControl.OnReceiveButtonClick := ReceiveButtonClickEvent;
  FDelphiControl.OnRing := RingEvent;
  FDelphiControl.OnRXD := RXDEvent;
  FDelphiControl.OnSendButtonClick := SendButtonClickEvent;
  FDelphiControl.OnTapiCallerID := TapiCallerIDEvent;
  FDelphiControl.OnTapiConnect := TapiConnectEvent;
  FDelphiControl.OnTapiDTMF := TapiDTMFEvent;
  FDelphiControl.OnTapiFail := TapiFailEvent;
  FDelphiControl.OnTapiGetNumber := TapiGetNumberEvent;
  FDelphiControl.OnTapiPortClose := TapiPortCloseEvent;
  FDelphiControl.OnTapiPortOpen := TapiPortOpenEvent;
  FDelphiControl.OnTapiStatus := TapiStatusEvent;
  FDelphiControl.OnTapiWaveNotify := TapiWaveNotifyEvent;
  FDelphiControl.OnTapiWaveSilence := TapiWaveSilenceEvent;
  FDelphiControl.OnWinsockAccept := WinsockAcceptEvent;
  FDelphiControl.OnWinsockConnect := WinsockConnectEvent;
  FDelphiControl.OnWinsockDisconnect := WinsockDisconnectEvent;
  FDelphiControl.OnWinsockError := WinsockErrorEvent;
  FDelphiControl.OnWinsockGetAddress := WinsockGetAddressEvent;

  { FTP stuff }
  FDelphiControl.FTPClient.OnFtpError := DoFTPErrorEvent;
  FDelphiControl.FTPClient.OnFtpLog := DoFTPLogEvent;
  FDelphiControl.FTPClient.OnFtpReply := DoFTPReplyEvent;
  FDelphiControl.FTPClient.OnFtpStatus := DoFTPStatusEvent;

end;
{ ----------------------------------------------------------------------- }
function TApax.AddDataTrigger(const TriggerString: WideString; PacketSize,
  Timeout: Integer; IncludeStrings, IgnoreCase: WordBool): Integer;
begin
  Result := FDelphiControl.AddDataTrigger(TriggerString, PacketSize, Timeout, IncludeStrings, IgnoreCase);
end;
{ ----------------------------------------------------------------------- }
function TApax.Close: Integer;
begin
  Result := FDelphiControl.Close;
end;
{ ----------------------------------------------------------------------- }
function TApax.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := FDelphiControl.DrawTextBiDiModeFlagsReadingOnly;
end;
{ ----------------------------------------------------------------------- }
function TApax.EstimateTransferSecs(Size: Integer): Integer;
begin
  Result := FDelphiControl.EstimateTransferSecs(Size);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AbortNoCarrier: WordBool;
begin
  Result := FDelphiControl.AbortNoCarrier;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AnswerOnRing: Integer;
begin
  Result := FDelphiControl.AnswerOnRing;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AsciiCharDelay: Integer;
begin
  Result := FDelphiControl.AsciiCharDelay;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AsciiCRTranslation: TxAsciiEOLTranslation;
begin
  Result := Ord(FDelphiControl.AsciiCRTranslation);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AsciiEOFTimeout: Integer;
begin
  Result := FDelphiControl.AsciiEOFTimeout;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AsciiEOLChar: Integer;
begin
  Result := FDelphiControl.AsciiEOLChar;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AsciiLFTranslation: TxAsciiEOLTranslation;
begin
  Result := Ord(FDelphiControl.AsciiLFTranslation);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AsciiLineDelay: Integer;
begin
  Result := FDelphiControl.AsciiLineDelay;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_AsciiSuppressCtrlZ: WordBool;
begin
  Result := FDelphiControl.AsciiSuppressCtrlZ;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Batch: WordBool;
begin
  Result := FDelphiControl.Batch;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Baud: Integer;
begin
  Result := FDelphiControl.Baud;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_BlockCheckMethod: TxBlockCheckMethod;
begin
  Result := Ord(FDelphiControl.BlockCheckMethod);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_BlockErrors: Integer;
begin
  Result := FDelphiControl.BlockErrors;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_BlockLength: Integer;
begin
  Result := FDelphiControl.BlockLength;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_BlockNumber: Integer;
begin
  Result := FDelphiControl.BlockNumber;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_BytesRemaining: Integer;
begin
  Result := FDelphiControl.BytesRemaining;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_BytesTransferred: Integer;
begin
  Result := FDelphiControl.BytesTransferred;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CallerID: WideString;
begin
  Result := FDelphiControl.CallerID;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Caption: WideString;
begin
  Result := FDelphiControl.Caption;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CaptionAlignment: TxAlignment;
begin
  Result := Ord(FDelphiControl.CaptionAlignment);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CaptionWidth: Integer;
begin
  Result := FDelphiControl.CaptionWidth;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CaptureFile: WideString;
begin
  Result := FDelphiControl.CaptureFile;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CaptureMode: TxAdCaptureMode;
begin
  Result := Ord(FDelphiControl.CaptureMode);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Color: OLE_COLOR;
begin
  Result := OLE_COLOR(FDelphiControl.Color);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Columns: Integer;
begin
  Result := FDelphiControl.Columns;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ComNumber: Integer;
begin
  Result := FDelphiControl.ComNumber;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CTS: WordBool;
begin
  Result := FDelphiControl.CTS;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Cursor: Smallint;
begin
  Result := Smallint(FDelphiControl.Cursor);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DataBits: Integer;
begin
  Result := FDelphiControl.DataBits;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DataTriggerString: WideString;
begin
  Result := FDelphiControl.DataTriggerString;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.DisableDataTrigger(Index: Integer);
begin
  FDelphiControl.DisableDataTrigger(Index);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.EnableDataTrigger(Index: Integer);
begin
  FDelphiControl.EnableDataTrigger(Index);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DCD: WordBool;
begin
  Result := FDelphiControl.DCD;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DeviceType: TxApxDeviceType;
begin
  Result := Ord(FDelphiControl.DeviceType);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Dialing: WordBool;
begin
  Result := FDelphiControl.Dialing;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DoubleBuffered: WordBool;
begin
  Result := FDelphiControl.DoubleBuffered;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DSR: WordBool;
begin
  Result := FDelphiControl.DSR;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DTR: WordBool;
begin
  Result := FDelphiControl.DTR;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ElapsedTicks: Integer;
begin
  Result := FDelphiControl.ElapsedTicks;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Emulation: TxApxTerminalEmulation;
begin
  Result := Ord(FDelphiControl.Emulation);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Enabled: WordBool;
begin
  Result := FDelphiControl.Enabled;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_EnableVoice: WordBool;
begin
  Result := FDelphiControl.EnableVoice;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_FileDate: Double;
begin
  Result := Double(FDelphiControl.FileDate);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_FileLength: Integer;
begin
  Result := FDelphiControl.FileLength;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_FinishWait: Integer;
begin
  Result := FDelphiControl.FinishWait;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_FlowState: TxFlowControlState;
begin
  Result := Ord(FDelphiControl.FlowState);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Font: IFontDisp;
begin
  GetOleFont(FDelphiControl.Font, Result);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_HandshakeRetry: Integer;
begin
  Result := FDelphiControl.HandshakeRetry;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_HandshakeWait: Integer;
begin
  Result := FDelphiControl.HandshakeWait;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_HonorDirectory: WordBool;
begin
  Result := FDelphiControl.HonorDirectory;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_HWFlowRequireCTS: WordBool;
begin
  Result := FDelphiControl.HWFlowRequireCTS;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_HWFlowRequireDSR: WordBool;
begin
  Result := FDelphiControl.HWFlowRequireDSR;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_HWFlowUseDTR: WordBool;
begin
  Result := FDelphiControl.HWFlowUseDTR;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_HWFlowUseRTS: WordBool;
begin
  Result := FDelphiControl.HWFlowUseRTS;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InBuffFree: Integer;
begin
  Result := FDelphiControl.InBuffFree;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InBuffUsed: Integer;
begin
  Result := FDelphiControl.InBuffUsed;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_IncludeDirectory: WordBool;
begin
  Result := FDelphiControl.IncludeDirectory;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InitialPosition: Integer;
begin
  Result := FDelphiControl.InitialPosition;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InProgress: WordBool;
begin
  Result := FDelphiControl.InProgress;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InterruptWave: WordBool;
begin
  Result := FDelphiControl.InterruptWave;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitCtlPrefix: Integer;
begin
  Result := FDelphiControl.KermitCtlPrefix;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitHighbitPrefix: Integer;
begin
  Result := FDelphiControl.KermitHighbitPrefix;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitLongBlocks: WordBool;
begin
  Result := FDelphiControl.KermitLongBlocks;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitMaxLen: Integer;
begin
  Result := FDelphiControl.KermitMaxLen;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitMaxWindows: Integer;
begin
  Result := FDelphiControl.KermitMaxWindows;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitPadCharacter: Integer;
begin
  Result := FDelphiControl.KermitPadCharacter;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitPadCount: Integer;
begin
  Result := FDelphiControl.KermitPadCount;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitRepeatPrefix: Integer;
begin
  Result := FDelphiControl.KermitRepeatPrefix;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitSWCTurnDelay: Integer;
begin
  Result := FDelphiControl.KermitSWCTurnDelay;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitTerminator: Integer;
begin
  Result := FDelphiControl.KermitTerminator;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitTimeoutSecs: Integer;
begin
  Result := FDelphiControl.KermitTimeoutSecs;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitWindowsTotal: Integer;
begin
  Result := FDelphiControl.KermitWindowsTotal;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_KermitWindowsUsed: Integer;
begin
  Result := FDelphiControl.KermitWindowsUsed;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_LightsLitColor: OLE_COLOR;
begin
  Result := OLE_COLOR(FDelphiControl.LightsLitColor);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_LightsNotLitColor: OLE_COLOR;
begin
  Result := OLE_COLOR(FDelphiControl.LightsNotLitColor);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_LightWidth: Integer;
begin
  Result := FDelphiControl.LightWidth;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_LineError: Integer;
begin
  Result := FDelphiControl.LineError;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_LogAllHex: WordBool;
begin
  Result := FDelphiControl.LogAllHex;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Logging: TxTraceLogState;
begin
  Result := Ord(FDelphiControl.Logging);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_LogHex: WordBool;
begin
  Result := FDelphiControl.LogHex;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_LogName: WideString;
begin
  Result := FDelphiControl.LogName;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_LogSize: Integer;
begin
  Result := FDelphiControl.LogSize;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_MaxAttempts: Integer;
begin
  Result := FDelphiControl.MaxAttempts;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_MaxMessageLength: Integer;
begin
  Result := FDelphiControl.MaxMessageLength;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_OutBuffFree: Integer;
begin
  Result := FDelphiControl.OutBuffFree;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_OutBuffUsed: Integer;
begin
  Result := FDelphiControl.OutBuffUsed;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Parity: TxParity;
begin
  Result := Ord(FDelphiControl.Parity);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_PromptForPort: WordBool;
begin
  Result := FDelphiControl.PromptForPort;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Protocol: TxProtocolType;
begin
  Result := Ord(FDelphiControl.Protocol);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ProtocolStatus: Integer;
begin
  Result := FDelphiControl.ProtocolStatus;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ProtocolStatusDisplay: WordBool;
begin
  Result := FDelphiControl.ProtocolStatusDisplay;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ReceiveDirectory: WideString;
begin
  Result := FDelphiControl.ReceiveDirectory;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ReceiveFileName: WideString;
begin
  Result := FDelphiControl.ReceiveFileName;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_RI: WordBool;
begin
  Result := FDelphiControl.RI;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Rows: Integer;
begin
  Result := FDelphiControl.Rows;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_RS485Mode: WordBool;
begin
  Result := FDelphiControl.RS485Mode;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_RTS: WordBool;
begin
  Result := FDelphiControl.RTS;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_RTSLowForWrite: WordBool;
begin
  Result := FDelphiControl.RTSLowForWrite;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ScrollbackEnabled: WordBool;
begin
  Result := FDelphiControl.ScrollbackEnabled;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ScrollbackRows: Integer;
begin
  Result := FDelphiControl.ScrollbackRows;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_SelectedDevice: WideString;
begin
  Result := FDelphiControl.SelectedDevice;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_SendFileName: WideString;
begin
  Result := FDelphiControl.SendFileName;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ShowConnectButtons: WordBool;
begin
  Result := FDelphiControl.ShowConnectButtons;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ShowDeviceSelButton: WordBool;
begin
  Result := FDelphiControl.ShowDeviceSelButton;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ShowLightCaptions: WordBool;
begin
  Result := FDelphiControl.ShowLightCaptions;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ShowLights: WordBool;
begin
  Result := FDelphiControl.ShowLights;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ShowProtocolButtons: WordBool;
begin
  Result := FDelphiControl.ShowProtocolButtons;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ShowStatusBar: WordBool;
begin
  Result := FDelphiControl.ShowStatusBar;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ShowTerminalButtons: WordBool;
begin
  Result := FDelphiControl.ShowTerminalButtons;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ShowToolBar: WordBool;
begin
  Result := FDelphiControl.ShowToolBar;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_SilenceThreshold: Integer;
begin
  Result := FDelphiControl.SilenceThreshold;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_StatusInterval: Integer;
begin
  Result := FDelphiControl.StatusInterval;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_StopBits: Integer;
begin
  Result := FDelphiControl.StopBits;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_SWFlowOptions: TxSWFlowOptions;
begin
  Result := Ord(FDelphiControl.SWFlowOptions);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TapiAttempt: Integer;
begin
  Result := FDelphiControl.TapiAttempt;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TapiCancelled: WordBool;
begin
  Result := FDelphiControl.TapiCancelled;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TapiNumber: WideString;
begin
  Result := FDelphiControl.TapiNumber;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TapiRetryWait: Integer;
begin
  Result := FDelphiControl.TapiRetryWait;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TapiState: TxTapiState;
begin
  Result := Ord(FDelphiControl.TapiState);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TerminalActive: WordBool;
begin
  Result := FDelphiControl.TerminalActive;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TerminalBlinkTime: Integer;
begin
  Result := FDelphiControl.TerminalBlinkTime;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TerminalHalfDuplex: WordBool;
begin
  Result := FDelphiControl.TerminalHalfDuplex;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TerminalLazyByteDelay: Integer;
begin
  Result := FDelphiControl.TerminalLazyByteDelay;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TerminalLazyTimeDelay: Integer;
begin
  Result := FDelphiControl.TerminalLazyTimeDelay;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TerminalUseLazyDisplay: WordBool;
begin
  Result := FDelphiControl.TerminalUseLazyDisplay;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TerminalWantAllKeys: WordBool;
begin
  Result := FDelphiControl.TerminalWantAllKeys;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TotalErrors: Integer;
begin
  Result := FDelphiControl.TotalErrors;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TransmitTimeout: Integer;
begin
  Result := FDelphiControl.TransmitTimeout;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TrimSeconds: Integer;
begin
  Result := FDelphiControl.TrimSeconds;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_UpcaseFileNames: WordBool;
begin
  Result := FDelphiControl.UpcaseFileNames;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_UseSoundCard: WordBool;
begin
  Result := FDelphiControl.UseSoundCard;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Version: WideString;
begin
  Result := FDelphiControl.Version;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Visible: WordBool;
begin
  Result := FDelphiControl.Visible;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_VisibleDockClientCount: Integer;
begin
  Result := FDelphiControl.VisibleDockClientCount;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WaveFileName: WideString;
begin
  Result := FDelphiControl.WaveFileName;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WaveState: TxWaveState;
begin
  Result := Ord(FDelphiControl.WaveState);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WinsockAddress: WideString;
begin
  Result := FDelphiControl.WinsockAddress;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WinsockMode: TxWsMode;
begin
  Result := Ord(FDelphiControl.WinsockMode);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WinsockPort: WideString;
begin
  Result := FDelphiControl.WinsockPort;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WriteFailAction: TxWriteFailAction;
begin
  Result := Ord(FDelphiControl.WriteFailAction);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WsTelnet: WordBool;
begin
  Result := FDelphiControl.WsTelnet;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_XOffChar: Integer;
begin
  Result := FDelphiControl.XOffChar;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_XOnChar: Integer;
begin
  Result := FDelphiControl.XOnChar;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_XYmodemBlockWait: Integer;
begin
  Result := FDelphiControl.XYmodemBlockWait;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Zmodem8K: WordBool;
begin
  Result := FDelphiControl.Zmodem8K;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ZmodemFileOptions: TxZmodemFileOptions;
begin
  Result := Ord(FDelphiControl.ZmodemFileOptions);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ZmodemFinishRetry: Integer;
begin
  Result := FDelphiControl.ZmodemFinishRetry;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ZmodemOptionOverride: WordBool;
begin
  Result := FDelphiControl.ZmodemOptionOverride;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ZmodemRecover: WordBool;
begin
  Result := FDelphiControl.ZmodemRecover;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_ZmodemSkipNoFile: WordBool;
begin
  Result := FDelphiControl.ZmodemSkipNoFile;
end;
{ ----------------------------------------------------------------------- }
function TApax.GetAttributes(aRow, aCol: Integer): Integer;
begin
  Result := FDelphiControl.GetAttributes(aRow, aCol);
end;
{ ----------------------------------------------------------------------- }
function TApax.GetLine(Index: Integer): WideString;
begin
  Result := FDelphiControl.GetLine(Index);
end;
{ ----------------------------------------------------------------------- }
function TApax.IsRightToLeft: WordBool;
begin
  Result := FDelphiControl.IsRightToLeft;
end;
{ ----------------------------------------------------------------------- }
function TApax.PortOpen: Integer;
begin
  Result := FDelphiControl.PortOpen;
end;
{ ----------------------------------------------------------------------- }
function TApax.TapiAnswer: Integer;
begin
  Result := FDelphiControl.TapiAnswer;
end;
{ ----------------------------------------------------------------------- }
function TApax.TapiDial: Integer;
begin           
  Result := FDelphiControl.TapiDial;
end;
{ ----------------------------------------------------------------------- }
function TApax.TapiTranslatePhoneNo(
  const CanonicalAddr: WideString): WideString;
begin
  Result := FDelphiControl.TapiTranslatePhoneNo(CanonicalAddr);
end;
{ ----------------------------------------------------------------------- }
function TApax.UseRightToLeftReading: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftReading;
end;
{ ----------------------------------------------------------------------- }
function TApax.UseRightToLeftScrollBar: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftScrollBar;
end;
{ ----------------------------------------------------------------------- }
function TApax.WinsockConnect: Integer;
begin           
  Result := FDelphiControl.WinsockConnect;
end;
{ ----------------------------------------------------------------------- }
function TApax.WinsockListen: Integer;
begin           
  Result := FDelphiControl.WinsockListen;
end;
{ ----------------------------------------------------------------------- }
procedure TApax._Set_Font(const Value: IFontDisp);
begin
  SetOleFont(FDelphiControl.Font, Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.AboutBox;
begin
  ShowApaxAbout;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.AddStringToLog(const S: WideString);
begin
  FDelphiControl.AddStringToLog(S);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.CancelProtocol;
begin    
  FDelphiControl.CancelProtocol;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Clear;
begin                          
  FDelphiControl.Clear;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ClearAll;
begin                 
  FDelphiControl.ClearAll;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.CopyToClipboard;
begin
  FDelphiControl.CopyToClipboard;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.FlushInBuffer;
begin                    
  FDelphiControl.FlushInBuffer;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.FlushOutBuffer;
begin
  FDelphiControl.FlushOutBuffer;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.InitiateAction;
begin
  FDelphiControl.InitiateAction;
end;
{ ----------------------------------------------------------------------- }
function TApax.PutData(Data: OleVariant): Integer;
begin                                       
  Result := FDelphiControl.PutData(Data);
end;
{ ----------------------------------------------------------------------- }
function TApax.PutString(const S: WideString): Integer;
begin                   
  Result := FDelphiControl.PutString(S);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.RemoveDataTrigger(Index: Integer);
begin                                                     
  FDelphiControl.RemoveDataTrigger(Index);
end;
{ ----------------------------------------------------------------------- }
function TApax.PutStringCRLF(const S: WideString): Integer;
begin                                                   
  Result := FDelphiControl.PutStringCRLF(S);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.SendBreak(Ticks: Integer; Yield: WordBool);
begin                                                          
  FDelphiControl.SendBreak(Ticks, Yield);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AbortNoCarrier(Value: WordBool);
begin
  FDelphiControl.AbortNoCarrier := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AnswerOnRing(Value: Integer);
begin
  FDelphiControl.AnswerOnRing := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AsciiCharDelay(Value: Integer);
begin
  FDelphiControl.AsciiCharDelay := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AsciiCRTranslation(Value: TxAsciiEOLTranslation);
begin
  FDelphiControl.AsciiCRTranslation := TAsciiEOLTranslation(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AsciiEOFTimeout(Value: Integer);
begin
  FDelphiControl.AsciiEOFTimeout := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AsciiEOLChar(Value: Integer);
begin
  FDelphiControl.AsciiEOLChar := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AsciiLFTranslation(Value: TxAsciiEOLTranslation);
begin
  FDelphiControl.AsciiLFTranslation := TAsciiEOLTranslation(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AsciiLineDelay(Value: Integer);
begin
  FDelphiControl.AsciiLineDelay := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_AsciiSuppressCtrlZ(Value: WordBool);
begin
  FDelphiControl.AsciiSuppressCtrlZ := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Baud(Value: Integer);
begin
  FDelphiControl.Baud := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_BlockCheckMethod(Value: TxBlockCheckMethod);
begin
  FDelphiControl.BlockCheckMethod := TBlockCheckMethod(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Caption(const Value: WideString);
begin
  FDelphiControl.Caption := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_CaptionAlignment(Value: TxAlignment);
begin
  FDelphiControl.CaptionAlignment := TAlignment(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_CaptionWidth(Value: Integer);
begin
  FDelphiControl.CaptionWidth := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_CaptureFile(const Value: WideString);
begin
  FDelphiControl.CaptureFile := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_CaptureMode(Value: TxAdCaptureMode);
begin
  FDelphiControl.CaptureMode := TAdCaptureMode(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Color(Value: OLE_COLOR);
begin
  FDelphiControl.Color := TColor(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Columns(Value: Integer);
begin
  FDelphiControl.Columns := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ComNumber(Value: Integer);
begin                                                             
  FDelphiControl.ComNumber := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Cursor(Value: Smallint);
begin
  FDelphiControl.Cursor := TCursor(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_DataBits(Value: Integer);
begin
  FDelphiControl.DataBits := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_DataTriggerString(const Value: WideString);
begin
  FDelphiControl.DataTriggerString := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_DeviceType(Value: TxApxDeviceType);
begin
  FDelphiControl.DeviceType := TApxDeviceType(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_DoubleBuffered(Value: WordBool);
begin
  FDelphiControl.DoubleBuffered := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_DTR(Value: WordBool);
begin
  FDelphiControl.DTR := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Emulation(Value: TxApxTerminalEmulation);
begin
  FDelphiControl.Emulation := TApxTerminalEmulation(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Enabled(Value: WordBool);
begin
  FDelphiControl.Enabled := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_EnableVoice(Value: WordBool);
begin
  FDelphiControl.EnableVoice := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_FinishWait(Value: Integer);
begin
  FDelphiControl.FinishWait := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Font(var Value: IFontDisp);
begin
  SetOleFont(FDelphiControl.Font, Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_HandshakeRetry(Value: Integer);
begin
  FDelphiControl.HandshakeRetry := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_HandshakeWait(Value: Integer);
begin
  FDelphiControl.HandshakeWait := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_HonorDirectory(Value: WordBool);
begin
  FDelphiControl.HonorDirectory := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_HWFlowRequireCTS(Value: WordBool);
begin
  FDelphiControl.HWFlowRequireCTS := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_HWFlowRequireDSR(Value: WordBool);
begin
  FDelphiControl.HWFlowRequireDSR := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_HWFlowUseDTR(Value: WordBool);
begin
  FDelphiControl.HWFlowUseDTR := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_HWFlowUseRTS(Value: WordBool);
begin
  FDelphiControl.HWFlowUseRTS := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_IncludeDirectory(Value: WordBool);
begin
  FDelphiControl.IncludeDirectory := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_InterruptWave(Value: WordBool);
begin
  FDelphiControl.InterruptWave := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitCtlPrefix(Value: Integer);
begin
  FDelphiControl.KermitCtlPrefix := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitHighbitPrefix(Value: Integer);
begin
  FDelphiControl.KermitHighbitPrefix := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitMaxLen(Value: Integer);
begin
  FDelphiControl.KermitMaxLen := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitMaxWindows(Value: Integer);
begin
  FDelphiControl.KermitMaxWindows := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitPadCharacter(Value: Integer);
begin
  FDelphiControl.KermitPadCharacter := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitPadCount(Value: Integer);
begin
  FDelphiControl.KermitPadCount := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitRepeatPrefix(Value: Integer);
begin
  FDelphiControl.KermitRepeatPrefix := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitSWCTurnDelay(Value: Integer);
begin
  FDelphiControl.KermitSWCTurnDelay := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitTerminator(Value: Integer);
begin
  FDelphiControl.KermitTerminator := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_KermitTimeoutSecs(Value: Integer);
begin
  FDelphiControl.KermitTimeoutSecs := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_LightsLitColor(Value: OLE_COLOR);
begin
  FDelphiControl.LightsLitColor := TColor(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_LightsNotLitColor(Value: OLE_COLOR);
begin
  FDelphiControl.LightsNotLitColor := TColor(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_LightWidth(Value: Integer);
begin
  FDelphiControl.LightWidth := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_LogAllHex(Value: WordBool);
begin
  FDelphiControl.LogAllHex := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Logging(Value: TxTraceLogState);
begin
  FDelphiControl.Logging := TTraceLogState(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_LogHex(Value: WordBool);
begin
  FDelphiControl.LogHex := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_LogName(const Value: WideString);
begin
  FDelphiControl.LogName := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_LogSize(Value: Integer);
begin
  FDelphiControl.LogSize := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_MaxAttempts(Value: Integer);
begin
  FDelphiControl.MaxAttempts := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_MaxMessageLength(Value: Integer);
begin
  FDelphiControl.MaxMessageLength := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Parity(Value: TxParity);
begin                                 
  FDelphiControl.Parity := TParity(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_PromptForPort(Value: WordBool);
begin
  FDelphiControl.PromptForPort := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Protocol(Value: TxProtocolType);
begin
  FDelphiControl.Protocol := TProtocolType(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ProtocolStatusDisplay(Value: WordBool);
begin
  FDelphiControl.ProtocolStatusDisplay := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ReceiveDirectory(const Value: WideString);
begin
  FDelphiControl.ReceiveDirectory := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ReceiveFileName(const Value: WideString);
begin
  FDelphiControl.ReceiveFileName := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Rows(Value: Integer);
begin
  FDelphiControl.Rows := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_RS485Mode(Value: WordBool);
begin
  FDelphiControl.RS485Mode := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_RTS(Value: WordBool);
begin
  FDelphiControl.RTS := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_RTSLowForWrite(Value: WordBool);
begin
  FDelphiControl.RTSLowForWrite := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ScrollbackEnabled(Value: WordBool);
begin
  FDelphiControl.ScrollbackEnabled := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ScrollbackRows(Value: Integer);
begin
  FDelphiControl.ScrollbackRows := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_SelectedDevice(const Value: WideString);
begin                                                
  FDelphiControl.SelectedDevice := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_SendFileName(const Value: WideString);
begin
  FDelphiControl.SendFileName := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ShowConnectButtons(Value: WordBool);
begin
  FDelphiControl.ShowConnectButtons := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ShowDeviceSelButton(Value: WordBool);
begin
  FDelphiControl.ShowDeviceSelButton := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ShowLightCaptions(Value: WordBool);
begin
  FDelphiControl.ShowLightCaptions := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ShowLights(Value: WordBool);
begin
  FDelphiControl.ShowLights := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ShowProtocolButtons(Value: WordBool);
begin
  FDelphiControl.ShowProtocolButtons := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ShowStatusBar(Value: WordBool);
begin
  FDelphiControl.ShowStatusBar := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ShowTerminalButtons(Value: WordBool);
begin
  FDelphiControl.ShowTerminalButtons := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ShowToolBar(Value: WordBool);
begin
  FDelphiControl.ShowToolBar := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_SilenceThreshold(Value: Integer);
begin
  FDelphiControl.SilenceThreshold := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_StatusInterval(Value: Integer);
begin
  FDelphiControl.StatusInterval := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_StopBits(Value: Integer);
begin                                                                 
  FDelphiControl.StopBits := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_SWFlowOptions(Value: TxSWFlowOptions);
begin
  FDelphiControl.SWFlowOptions := TSWFlowOptions(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TapiNumber(const Value: WideString);
begin
  FDelphiControl.TapiNumber := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TapiRetryWait(Value: Integer);
begin
  FDelphiControl.TapiRetryWait := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TerminalActive(Value: WordBool);
begin                                                   
  FDelphiControl.TerminalActive := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TerminalBlinkTime(Value: Integer);
begin
  FDelphiControl.TerminalBlinkTime := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TerminalHalfDuplex(Value: WordBool);
begin
  FDelphiControl.TerminalHalfDuplex := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TerminalLazyByteDelay(Value: Integer);
begin
  FDelphiControl.TerminalLazyByteDelay := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TerminalLazyTimeDelay(Value: Integer);
begin
  FDelphiControl.TerminalLazyTimeDelay := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TerminalUseLazyDisplay(Value: WordBool);
begin
  FDelphiControl.TerminalUseLazyDisplay := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TerminalWantAllKeys(Value: WordBool);
begin
  FDelphiControl.TerminalWantAllKeys := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TransmitTimeout(Value: Integer);
begin
  FDelphiControl.TransmitTimeout := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TrimSeconds(Value: Integer);
begin
  FDelphiControl.TrimSeconds := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_UpcaseFileNames(Value: WordBool);
begin
  FDelphiControl.UpcaseFileNames := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_UseSoundCard(Value: WordBool);
begin
  FDelphiControl.UseSoundCard := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Version(const Value: WideString);
begin
  FDelphiControl.Version := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Visible(Value: WordBool);
begin             
  FDelphiControl.Visible := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_WinsockAddress(const Value: WideString);
begin
  FDelphiControl.WinsockAddress := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_WinsockMode(Value: TxWsMode);
begin
  FDelphiControl.WinsockMode := TWsMode(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_WinsockPort(const Value: WideString);
begin
  FDelphiControl.WinsockPort := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_WriteFailAction(Value: TxWriteFailAction);
begin
  FDelphiControl.WriteFailAction := TWriteFailAction(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_WsTelnet(Value: WordBool);
begin
  FDelphiControl.WsTelnet := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_XOffChar(Value: Integer);
begin
  FDelphiControl.XOffChar := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_XOnChar(Value: Integer);
begin
  FDelphiControl.XOnChar := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_XYmodemBlockWait(Value: Integer);
begin
  FDelphiControl.XYmodemBlockWait := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Zmodem8K(Value: WordBool);
begin
  FDelphiControl.Zmodem8K := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ZmodemFileOptions(Value: TxZmodemFileOptions);
begin
  FDelphiControl.ZmodemFileOptions := TZmodemFileOptions(Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ZmodemFinishRetry(Value: Integer);
begin
  FDelphiControl.ZmodemFinishRetry := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ZmodemOptionOverride(Value: WordBool);
begin
  FDelphiControl.ZmodemOptionOverride := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ZmodemRecover(Value: WordBool);
begin
  FDelphiControl.ZmodemRecover := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_ZmodemSkipNoFile(Value: WordBool);
begin
  FDelphiControl.ZmodemSkipNoFile := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.SetAttributes(aRow, aCol, Value: Integer);
begin
  FDelphiControl.SetAttributes(aRow, aCol, Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.SetLine(Index: Integer; const Value: WideString);
begin
  FDelphiControl.SetLine(Index, Value);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.StartReceive;
begin                                                  
  FDelphiControl.StartReceive;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.StartTransmit;
begin                                     
  FDelphiControl.StartTransmit;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiAutoAnswer;
begin                                      
  FDelphiControl.TapiAutoAnswer;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiCancelCall;
begin
  FDelphiControl.TapiCancelCall;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiConfigAndOpen;
begin                                       
  FDelphiControl.TapiConfigAndOpen;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiPlayWaveFile(const FileName: WideString);
begin
  FDelphiControl.TapiPlayWaveFile(FileName);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiRecordWaveFile(const FileName: WideString;
  Overwrite: WordBool);
begin
  FDelphiControl.TapiRecordWaveFile(FileName, Overwrite);
end;
{ ----------------------------------------------------------------------- }
function TApax.TapiSelectDevice: WordBool;
begin
  Result := FDelphiControl.TapiSelectDevice;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiSendTone(const Digits: WideString);
begin
  FDelphiControl.TapiSendTone(Digits);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiSetRecordingParams(NumChannels, NumSamplesPerSecond,
  NumBitsPerSample: Integer);
begin
  FDelphiControl.TapiSetRecordingParams(NumChannels, NumSamplesPerSecond, NumBitsPerSample);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiShowConfigDialog(AllowEdit: WordBool);
begin
  FDelphiControl.TapiShowConfigDialog(AllowEdit);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiStopWaveFile;
begin
  FDelphiControl.TapiStopWaveFile;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TerminalSetFocus;
begin
  FDelphiControl.TerminalSetFocus;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TerminalWriteString(const S: WideString);
begin
  FDelphiControl.TerminalWriteString(S);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TerminalWriteStringCRLF(const S: WideString);
begin
  FDelphiControl.TerminalWriteStringCRLF(S);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.RemoveAllDataTriggers;
begin                                          
  FDelphiControl.RemoveAllDataTriggers;
end;
{ ----------------------------------------------------------------------- }
function TApax.TapiStatusMsg(Message, State, Reason: Integer): WideString;
begin
  Result := FDelphiControl.TapiStatusMsg(Message, State, Reason);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TapiStatusDisplay: WordBool;
begin
  Result := FDelphiControl.TapiStatusDisplay;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_TapiStatusDisplay(Value: WordBool);
begin
  FDelphiControl.TapiStatusDisplay := Value;
end;

{ ======================================================================= }
{ == Apax events ======================================================== }
{ ======================================================================= }
procedure TApax.CloseButtonClickEvent(var Default: WordBool);
var
  TempDefault: WordBool;
begin                                              
  TempDefault := WordBool(Default);
  if FEvents <> nil then FEvents.OnCloseButtonClick(TempDefault);
  Default := WordBool(TempDefault);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ConnectButtonClickEvent(var Default: WordBool);
var
  TempDefault: WordBool;
begin                                              
  TempDefault := WordBool(Default);
  if FEvents <> nil then FEvents.OnConnectButtonClick(TempDefault);
  Default := WordBool(TempDefault);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.CTSChangedEvent(NewValue: WordBool);
begin
  if FEvents <> nil then FEvents.OnCTSChanged(NewValue);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.CursorMovedEvent(aRow, aCol: Integer);
begin                
  if FEvents <> nil then FEvents.OnCursorMoved(aRow, aCol);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ProcessCharEvent(Character: Char; var ReplaceWith: string;
  Commands: TAdEmuCommandList; CharSource: TAdCharSource);
var
  ReplaceWide : WideString;
begin
  ReplaceWide := ReplaceWith;
  if FEvents <> nil then FEvents.OnProcessChar(ord(CharSource), ord(Character), ReplaceWide);
  ReplaceWith := ReplaceWide;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.DataTriggerEvent(Index: Integer; Timeout: WordBool;
  Data: OleVariant; Size: Integer; var ReEnable: WordBool);
var
  TempReEnable: WordBool;
begin                                         
  TempReEnable := WordBool(ReEnable);
  if FEvents <> nil then FEvents.OnDataTrigger(Index, Timeout, Data, Size, TempReEnable);
  ReEnable := WordBool(TempReEnable);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.DCDChangedEvent(NewValue: WordBool);
begin                                         
  if FEvents <> nil then FEvents.OnDCDChanged(NewValue);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.DeviceButtonClickEvent(DeviceType: TApxDeviceType);
begin                
  if FEvents <> nil then FEvents.OnDeviceButtonClick(TxApxDeviceType(DeviceType));
end;
{ ----------------------------------------------------------------------- }
procedure TApax.DSRChangedEvent(NewValue: WordBool);
begin               
  if FEvents <> nil then FEvents.OnDSRChanged(NewValue);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.EmulationButtonClickEvent(Emulation: TApxTerminalEmulation);
begin                    
  if FEvents <> nil then FEvents.OnEmulationButtonClick(TxApxTerminalEmulation(Emulation));
end;
{ ----------------------------------------------------------------------- }
procedure TApax.FontButtonClickEvent(var Default: WordBool);
var
  TempDefault: WordBool;
begin                    
  TempDefault := WordBool(Default);
  if FEvents <> nil then FEvents.OnFontButtonClick(TempDefault);
  Default := WordBool(TempDefault);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.LineBreakEvent;
begin                                             
  if FEvents <> nil then FEvents.OnLineBreak;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.LineErrorEvent;
begin              
  if FEvents <> nil then FEvents.OnLineError;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ListenButtonClickEvent(var Default: WordBool);
var
  TempDefault: WordBool;
begin                  
  TempDefault := WordBool(Default);
  if FEvents <> nil then FEvents.OnListenButtonClick(TempDefault);
  Default := WordBool(TempDefault);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.PortCloseEvent;
begin              
  if FEvents <> nil then FEvents.OnPortClose;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.PortOpenEvent;
begin                 
  if FEvents <> nil then FEvents.OnPortOpen;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ProtocolAcceptEvent(var Accept: WordBool;
  var FName: WideString);
var
  TempAccept: WordBool;
  TempFName: WideString;
begin              
  TempAccept := WordBool(Accept);
  TempFName := WideString(FName);
  if FEvents <> nil then FEvents.OnProtocolAccept(TempAccept, TempFName);
  Accept := WordBool(TempAccept);
  FName := WideString(TempFName);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ProtocolFinishEvent(ErrorCode: Integer);
begin               
  if FEvents <> nil then FEvents.OnProtocolFinish(ErrorCode);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ProtocolLogEvent(Log: Integer);
begin                
  if FEvents <> nil then FEvents.OnProtocolLog(Log);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ProtocolStatusEvent(Options: Integer);
begin                                         
  if FEvents <> nil then FEvents.OnProtocolStatus(Options);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.ReceiveButtonClickEvent(var Default: WordBool);
var
  TempDefault: WordBool;
begin                                            
  TempDefault := WordBool(Default);
  if FEvents <> nil then FEvents.OnReceiveButtonClick(TempDefault);
  Default := WordBool(TempDefault);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.RingEvent;
begin                     
  if FEvents <> nil then FEvents.OnRing;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.RXDEvent(Data: OleVariant);
begin                                  
  if FEvents <> nil then FEvents.OnRXD(Data);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.SendButtonClickEvent(var Default: WordBool);
var
  TempDefault: WordBool;
begin                                 
  TempDefault := WordBool(Default);
  if FEvents <> nil then FEvents.OnSendButtonClick(TempDefault);
  Default := WordBool(TempDefault);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiCallerIDEvent(const ID, IDName: WideString);
begin
  if FEvents <> nil then FEvents.OnTapiCallerID(ID, IDName);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiConnectEvent;
begin
  if FEvents <> nil then FEvents.OnTapiConnect;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiDTMFEvent(Digit: Byte; ErrorCode: Integer);
begin
  if FEvents <> nil then FEvents.OnTapiDTMF(Digit, ErrorCode);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiFailEvent;
begin                 
  if FEvents <> nil then FEvents.OnTapiFail;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiGetNumberEvent(var PhoneNum: WideString);
var
  TempPhoneNum: WideString;
begin
  TempPhoneNum := WideString(PhoneNum);
  if FEvents <> nil then FEvents.OnTapiGetNumber(TempPhoneNum);
  PhoneNum := WideString(TempPhoneNum);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiPortCloseEvent;
begin                        
  if FEvents <> nil then FEvents.OnTapiPortClose;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiPortOpenEvent;
begin                
  if FEvents <> nil then FEvents.OnTapiPortOpen;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiStatusEvent(First, Last: WordBool; Device, Message,
  Param1, Param2, Param3: Integer);
begin               
  if FEvents <> nil then FEvents.OnTapiStatus(First, Last, Device, Message, Param1, Param2, Param3);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiWaveNotifyEvent(Msg: TWaveMessage);
begin                     
  if FEvents <> nil then FEvents.OnTapiWaveNotify(TxWaveMessage(Msg));
end;
{ ----------------------------------------------------------------------- }
procedure TApax.TapiWaveSilenceEvent(var StopRecording, Hangup: WordBool);
var
  TempStopRecording: WordBool;
  TempHangup: WordBool;
begin                 
  TempStopRecording := WordBool(StopRecording);
  TempHangup := WordBool(Hangup);
  if FEvents <> nil then FEvents.OnTapiWaveSilence(TempStopRecording, TempHangup);
  StopRecording := WordBool(TempStopRecording);
  Hangup := WordBool(TempHangup);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.WinsockAcceptEvent(Addr: WideString; var Accept: WordBool);
var
  TempAccept: WordBool;
begin                                             
  TempAccept := WordBool(Accept);
  if FEvents <> nil then FEvents.OnWinsockAccept(Addr, TempAccept);
  Accept := WordBool(TempAccept);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.WinsockConnectEvent;
begin                       
  if FEvents <> nil then FEvents.OnWinsockConnect;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.WinsockDisconnectEvent;
begin                
  if FEvents <> nil then FEvents.OnWinsockDisconnect;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.WinsockErrorEvent(ErrCode: Integer);
begin
  if FEvents <> nil then FEvents.OnWinsockError(ErrCode);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.WinsockGetAddressEvent(var Address, Port: WideString);
var
  TempAddress: WideString;
  TempPort: WideString;
begin                
  TempAddress := WideString(Address);
  TempPort := WideString(Port);
  if FEvents <> nil then FEvents.OnWinsockGetAddress(TempAddress, TempPort);
  Address := WideString(TempAddress);
  Port := WideString(TempPort);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.MSCommEvent;
begin                                               
  if FEvents <> nil then FEvents.OnComm;
end;


{ ======================================================================= }
{ == MSComm compatible properties ======================================= }
{ ======================================================================= }

function TApax.Get_CDHolding: WordBool;
begin
  Result := FDelphiControl.MSCommCDHolding;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CommPort: Smallint;
begin
  Result := FDelphiControl.MSCommCommPort;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CTSHolding: WordBool;
begin
  Result := FDelphiControl.MSCommCTSHolding;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DSRHolding: WordBool;
begin
  Result := FDelphiControl.MSCommDSRHolding;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_DTREnable: WordBool;
begin
  Result := FDelphiControl.MSCommDTREnable;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Handshaking: HandshakeConstants;
begin
  Result := HandshakeConstants(FDelphiControl.MSCommHandshaking);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InBufferCount: Smallint;
begin
  Result := FDelphiControl.MSCommInBufferCount;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InBufferSize: Smallint;
begin
  Result := FDelphiControl.MSCommInBufferSize;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_OutBufferCount: Smallint;
begin
  Result := FDelphiControl.MSCommOutBufferCount;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_OutBufferSize: Smallint;
begin
  Result := FDelphiControl.MSCommOutBufferSize;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_RTSEnable: WordBool;
begin
  Result := FDelphiControl.MSCommRTSEnable;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Settings: WideString;
begin
  Result := FDelphiControl.MSCommSettings;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Break(Value: WordBool);
begin
  FDelphiControl.MSCommBreak := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_CommPort(Value: Smallint);
begin
  FDelphiControl.MSCommCommPort := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_DTREnable(Value: WordBool);
begin
  FDelphiControl.MSCommDTREnable := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Handshaking(Value: HandshakeConstants);
begin
  FDelphiControl.MSCommHandshaking := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_InBufferSize(Value: Smallint);
begin
  FDelphiControl.MSCommInBufferSize := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_OutBufferSize(Value: Smallint);
begin
  FDelphiControl.MSCommOutBufferSize := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_RTSEnable(Value: WordBool);
begin
  FDelphiControl.MSCommRTSEnable := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Settings(const Value: WideString);
begin
  FDelphiControl.MSCommSettings := Value;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_Input: OleVariant;
begin
  Result := FDelphiControl.MSCommInput;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InputLen: Smallint;
begin
  Result := FDelphiControl.MSCommInputLen;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_InputMode: InputModeConstants;
begin
  Result := FDelphiControl.MSCommInputMode;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_InputLen(Value: Smallint);
begin
  FDelphiControl.MSCommInputLen := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_InputMode(Value: InputModeConstants);
begin
  FDelphiControl.MSCommInputMode := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_Output(Value: OleVariant);
begin
  FDelphiControl.MSCommOutPut := Value;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_CommEvent: Smallint;
begin
  Result := FDelphiControl.MSCommCommEvent;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_MSCommCompatible: WordBool;
begin
  Result := FDelphiControl.MSCommCompatible;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_MSCommCompatible(Value: WordBool);
begin
  FDelphiControl.MSCommCompatible := Value;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_RTThreshold: Smallint;
begin
  Result := FDelphiControl.MSCommRTThreshold;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_RTThreshold(Value: Smallint);
begin
  FDelphiControl.MSCommRTThreshold := Value;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_SThreshold: Smallint;
begin
  Result := FDelphiControl.MSCommSThreshold;
end;
{ ----------------------------------------------------------------------- }
procedure TApax.Set_SThreshold(Value: Smallint);
begin
  FDelphiControl.MSCommSThreshold := Value;
end;
{ ----------------------------------------------------------------------- }
function TApax.IsPortAvail(ComNumber: Integer): WordBool;
begin
  Result := FDelphiControl.IsPortAvail(ComNumber);
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_TapiFailCode: Integer;
begin
  Result := FDelphiControl.TapiFailCode;
end;
{ ----------------------------------------------------------------------- }
function TApax.TapiTranslateDialog(
  const CanonicalAddr: WideString): WordBool;
begin
  Result := FDelphiControl.TapiTranslateDialog(CanonicalAddr);
end;
{ ----------------------------------------------------------------------- }
function TApax.ErrorMsg(ErrorCode: Integer): WideString;
begin
  Result := FDelphiControl.ErrorMsg(ErrorCode);
end;
{ ----------------------------------------------------------------------- }
function TApax.ErrorMsgEx(ErrorCode: Integer;
  var LanguageFile: WideString): WideString;
begin

end;
{ ----------------------------------------------------------------------- }
function TApax.EnumTapiFirst: WideString;
begin
  Result := FDelphiControl.EnumTapiFirst;
end;
{ ----------------------------------------------------------------------- }
function TApax.EnumTapiNext: WideString;
begin
  Result := FDelphiControl.EnumTapiNext;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WsLocalDescription: WideString;
begin
  Result := FDelphiControl.WsLocalDescription;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WsLocalHighVersion: WideString;
begin
  Result := FDelphiControl.WsLocalHighVersion;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WsLocalSystemStatus: WideString;
begin
  Result := FDelphiControl.WsLocalSystemStatus;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WsLocalVersion: WideString;
begin
  Result := FDelphiControl.WsLocalVersion;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WsLocalAddress: WideString;
begin
  Result := FDelphiControl.WsLocalAddress;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WsLocalHostName: WideString;
begin
  Result := FDelphiControl.WsLocalHost;
end;
{ ----------------------------------------------------------------------- }
function TApax.Get_WsLocalMaxSockets: Integer;
begin
  Result := FDelphiControl.WsLocalMaxSockets;
end;
{ ----------------------------------------------------------------------- }
function TApax.IsPortInstalled(ComNumber: Integer): WordBool;
begin
  Result := FDelphiControl.IsPortInstalled(ComNumber);
end;
{ ----------------------------------------------------------------------- }
procedure TApax.DelayTicks(Ticks: Integer);
begin
  FDelphiControl.DelayTicks(Ticks);
end;
{ ----------------------------------------------------------------------- }
function TApax.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
begin
  inherited SafeCallException(ExceptObject, ExceptAddr);                 {!!.11}
  Result := HResult($8000FFFF); { E_UNEXPECTED }
end;

{ ----------------------------------------------------------------------- }

{FTP Support}
function TApax.FTPAbort: WordBool;
begin
  Result := FDelphiControl.FTPClient.Abort;
end;

function TApax.FTPChangeDir(const RemotePathName: WideString): WordBool;
begin
  Result := FDelphiControl.FTPClient.ChangeDir(RemotePathName);
end;

function TApax.FTPCurrentDir: WideString;
begin
  Result := FDelphiControl.FTPClient.CurrentDir;
end;

function TApax.Get_FTPAccount: WideString;
begin
  Result := FDelphiControl.FTPClient.Account;
end;

procedure TApax.Set_FTPAccount(const Value: WideString);
begin
  FDelphiControl.FTPClient.Account := Value;
end;

function TApax.FTPDelete(const RemotePathName: WideString): WordBool;
begin
  Result := FDelphiControl.FTPClient.Delete(RemotePathName);
end;

function TApax.Get_FTPConnected: WordBool;
begin
  Result := FDelphiControl.FTPClient.Connected;
end;

function TApax.Get_FTPConnectTimeout: Integer;
begin
  Result := FDelphiControl.FTPClient.ConnectTimeout;
end;

procedure TApax.Set_FTPConnectTimeout(Value: Integer);
begin
  FDelphiControl.FTPClient.ConnectTimeout := Value;
end;

function TApax.Get_FTPFileLength: Integer;
begin
  Result := FDelphiControl.FTPClient.FileLength;
end;

function TApax.Get_FTPFileType: TxFTPFileType;
begin
  Result := Ord(FDelphiControl.FTPClient.FileType);
end;

procedure TApax.Set_FTPFileType(Value: TxFTPFileType);
begin
  FDelphiControl.FTPClient.FileType := TFTPFileType(Value);
end;

function TApax.FTPHelp(const Command: WideString): WideString;
begin
  Result := FDelphiControl.FTPClient.Help(Command);
end;

function TApax.Get_FTPInProgress: WordBool;
begin
  Result := FDelphiControl.FTPClient.InProgress;
end;

function TApax.FTPListDir(const RemotePathName: WideString;
  FullList: WordBool): WideString;
begin
  Result := FDelphiControl.FTPClient.ListDir(RemotePathName, FullList);
end;

function TApax.FTPLogIn: WordBool;
begin
  Result := FDelphiControl.FTPClient.LogIn;
end;

function TApax.FTPLogOut: WordBool;
begin
  Result := FDelphiControl.FTPClient.LogOut;
end;

function TApax.FTPMakeDir(const RemotePathName: WideString): WordBool;
begin
  Result := FDelphiControl.FTPClient.MakeDir(RemotePathName);
end;

function TApax.Get_FTPPassword: WideString;
begin
  Result := FDelphiControl.FTPClient.Password;
end;

procedure TApax.Set_FTPPassword(const Value: WideString);
begin
  FDelphiControl.FTPClient.Password := Value;
end;

function TApax.FTPRename(const RemotePathName,
  NewPathName: WideString): WordBool;
begin
  Result := FDelphiControl.FTPClient.Rename(RemotePathName, NewPathName);
end;

function TApax.Get_FTPRestartAt: Integer;
begin
  Result := FDelphiControl.FTPClient.RestartAt;
end;

procedure TApax.Set_FTPRestartAt(Value: Integer);
begin
  FDelphiControl.FTPClient.RestartAt := Value;
end;

function TApax.FTPRetrieve(const RemotePathName, LocalPathName: WideString;
  RetrieveMode: TxFTPRetrieveMode): WordBool;
begin
  Result := FDelphiControl.FTPClient.Retrieve(RemotePathName, LocalPathName,
    TFTPRetrieveMode(RetrieveMode));
end;

function TApax.FTPSendFTPCommand(const FTPCommand: WideString): WideString;
begin
  Result := FDelphiControl.FTPClient.SendFTPCommand(FTPCommand);
end;

function TApax.Get_FTPServerAddress: WideString;
begin
  Result := FDelphiControl.FTPClient.ServerAddress;
end;

procedure TApax.Set_FTPServerAddress(const Value: WideString);
begin
  FDelphiControl.FTPClient.ServerAddress := Value;
end;

function TApax.FTPStatus(const RemotePathName: WideString): WideString;
begin
  Result := FDelphiControl.FTPClient.Status(RemotePathName);
end;

function TApax.FTPStore(const RemotePathName, LocalPathName: WideString;
  StoreMode: TxFTPStoreMode): WordBool;
begin
  Result := FDelphiControl.FTPClient.Store(RemotePathName, LocalPathName,
    TFTPStoreMode(StoreMode));
end;

function TApax.IApax_FTPRetrieve(const RemotePathName,
  LocalPathName: WideString; RetrieveMode: TxFTPRetrieveMode): WordBool;
begin
  Result := FDelphiControl.FTPClient.Retrieve(RemotePathName, LocalPathName,
    TFTPRetrieveMode(RetrieveMode));
end;

function TApax.Get_FTPTransferTimeout: Integer;
begin
  Result := FDelphiControl.FTPClient.TransferTimeout;
end;

function TApax.Get_FTPUserLoggedIn: WordBool;
begin
  Result := FDelphiControl.FTPClient.UserLoggedIn;
end;

procedure TApax.Set_FTPTransferTimeout(Value: Integer);
begin
  FDelphiControl.FTPClient.TransferTimeout := Value;
end;

function TApax.Get_FTPUserName: WideString;
begin
  Result := FDelphiControl.FTPClient.UserName;
end;

procedure TApax.Set_FTPUserName(const Value: WideString);
begin
  FDelphiControl.FTPClient.UserName := Value;
end;

function TApax.Get_FTPState: Integer;
begin
  Result := ord(FDelphiControl.FTPClient.FTPState);
end;

function TApax.IApax_Get_FTPFileType: TxFTPFileType;
begin
  Result := ord(FDelphiControl.FTPClient.FileType);
end;

procedure TApax.IApax_Set_FTPFileType(Value: TxFTPFileType);
begin
  FDelphiControl.FTPClient.FileType := TFTPFileType(Value);
end;

function TApax.Get_FTPBytesTransferred: Integer;
begin
  Result := FDelphiControl.FTPClient.BytesTransferred;
end;

procedure TApax.DoFTPErrorEvent(Sender: TObject; ErrorCode: Integer;
  ErrorText: PChar);
begin
  if FEvents <> nil then FEvents.OnFTPError(ErrorCode, ErrorText);
end;

procedure TApax.DoFTPLogEvent(Sender: TObject; LogCode: TFtpLogCode);
begin
  if FEvents <> nil then FEvents.OnFTPLog(ord(LogCode));
end;

procedure TApax.DoFTPReplyEvent(Sender: TObject; ReplyCode: Integer;
  ReplyText: PChar);
begin
  if FEvents <> nil then FEvents.OnFtpReply(ReplyCode, ReplyText);
end;

procedure TApax.DoFTPStatusEvent(Sender: TObject;
  StatusCode: TFtpStatusCode; InfoText: PChar);
begin
  if FEvents <> nil then FEvents.OnFTPStatus(ord(StatusCode), InfoText);
end;

procedure TApax.TapiLoadConfig(const RegKey, KeyName: WideString);       {!!.11}
begin
  FDelphiControl.TapiLoadConfig(RegKey, KeyName);
end;

procedure TApax.TapiSaveConfig(const RegKey, KeyName: WideString);       {!!.11}
begin
  FDelphiControl.GetData (120);
  FDelphiControl.TapiSaveConfig(RegKey, KeyName);
end;

function TApax.GetTapiConfig: OleVariant;                                {!!.11}
begin
   Result := FDelphiControl.GetTapiConfig;
end;

procedure TApax.SetTapiConfig(Value: OleVariant);                        {!!.11}
begin
  FDelphiControl.SetTapiConfig(Value);
end;

function TApax.Get_FilterTapiDevices: WordBool;                          {!!.12}
begin
  Result := FDelphiControl.FilterTapiDevices;
end;

procedure TApax.Set_FilterTapiDevices(Value: WordBool);                  {!!.12}
begin
  FDelphiControl.FilterTapiDevices := Value;
end;

initialization
{$IFDEF DEBUGAPAX}
  // allocate a console window for our debug output
  AllocConsole;
{$ENDIF}

  TActiveXControlFactory.Create(
    ComServer,
    TApax,
    TApxTerminal,
    Class_Apax,
    1,
    '', // unlicensed
    OLEMISC_SIMPLEFRAME or OLEMISC_ACTSLIKELABEL or OLEMISC_SETCLIENTSITEFIRST,
    tmApartment);//tmBoth);

end.

