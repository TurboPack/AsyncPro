// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdTapi.pas' rev: 32.00 (Windows)

#ifndef AdtapiHPP
#define AdtapiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Win.Registry.hpp>
#include <System.Classes.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <System.Variants.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Dialogs.hpp>
#include <Winapi.MMSystem.hpp>
#include <System.SysUtils.hpp>
#include <AdTUtil.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <AdExcept.hpp>
#include <AdTSel.hpp>
#include <AdPort.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adtapi
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomTapiDevice;
class DELPHICLASS TApdTapiLog;
class DELPHICLASS TApdAbstractTapiStatus;
class DELPHICLASS TApdTapiDevice;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TTapiState : unsigned char { tsIdle, tsOffering, tsAccepted, tsDialTone, tsDialing, tsRingback, tsBusy, tsSpecialInfo, tsConnected, tsProceeding, tsOnHold, tsConferenced, tsOnHoldPendConf, tsOnHoldPendTransfer, tsDisconnected, tsUnknown };

enum DECLSPEC_DENUM TWaveState : unsigned char { wsIdle, wsPlaying, wsRecording, wsData };

enum DECLSPEC_DENUM TWaveMessage : unsigned char { waPlayOpen, waPlayDone, waPlayClose, waRecordOpen, waDataReady, waRecordClose };

enum DECLSPEC_DENUM TTapiLogCode : unsigned char { ltapiNone, ltapiCallStart, ltapiCallFinish, ltapiDial, ltapiAccept, ltapiAnswer, ltapiConnect, ltapiCancel, ltapiDrop, ltapiBusy, ltapiDialFail, ltapiReceivedDigit };

typedef void __fastcall (__closure *TTapiStatusEvent)(System::TObject* CP, bool First, bool Last, int Device, int Message, int Param1, int Param2, int Param3);

typedef void __fastcall (__closure *TTapiLogEvent)(System::TObject* CP, TTapiLogCode Log);

typedef void __fastcall (__closure *TTapiDTMFEvent)(System::TObject* CP, System::WideChar Digit, int ErrorCode);

typedef void __fastcall (__closure *TTapiCallerIDEvent)(System::TObject* CP, System::UnicodeString ID, System::UnicodeString IDName);

typedef void __fastcall (__closure *TTapiWaveNotify)(System::TObject* CP, TWaveMessage Msg);

typedef void __fastcall (__closure *TTapiWaveSilence)(System::TObject* CP, bool &StopRecording, bool &Hangup);

class PASCALIMPLEMENTATION TApdCustomTapiDevice : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	int LineApp;
	Adtutil::TLineExtensionID LineExt;
	int LineHandle;
	int CallHandle;
	int SelectedLine;
	Adtutil::TVarString VS;
	Vcl::Extctrls::TTimer* DialTimer;
	int RequestedId;
	int AsyncReply;
	int CallState;
	bool ReplyReceived;
	bool CallStateReceived;
	bool TapiInUse;
	bool TapiHasOpened;
	bool Initializing;
	bool Connected;
	bool StoppingCall;
	bool ShuttingDown;
	bool RetryPending;
	bool TapiFailFired;
	bool ReplyWait;
	bool StateWait;
	bool PassThruMode;
	wavehdr_tag *WaveOutHeader;
	wavehdr_tag *WaveInHeader;
	NativeInt WaveOutHandle;
	NativeInt WaveInHandle;
	int BytesRecorded;
	int TotalBytesRecorded;
	void *WaveInBuffer1;
	void *WaveInBuffer2;
	void *WaveOutBuffer1;
	void *WaveOutBuffer2;
	System::Byte ActiveBuffer;
	int MmioInHandle;
	int MmioOutHandle;
	_MMCKINFO RootChunk;
	_MMCKINFO DataChunk;
	System::Sysutils::TFileName TempFileName;
	System::Byte Channels;
	System::Byte BitsPerSample;
	int SamplesPerSecond;
	int WaveInBufferSize;
	int BytesToPlay;
	int BytesPlayed;
	int BytesInBuffer;
	System::Byte ActiveWaveOutBuffer;
	int WaveOutBufferSize;
	int FAvgWaveInAmplitude;
	bool FCancelled;
	bool FDialing;
	int FDialTime;
	System::Classes::TStrings* FTapiDevices;
	System::UnicodeString FSelectedDevice;
	int FApiVersion;
	unsigned FDeviceCount;
	unsigned FTrueDeviceCount;
	bool FOpen;
	Adtutil::TCallInfo *FCallInfo;
	Adport::TApdCustomComPort* FComPort;
	TApdAbstractTapiStatus* FStatusDisplay;
	TApdTapiLog* FTapiLog;
	System::UnicodeString FNumber;
	System::Word FMaxAttempts;
	System::Word FAttempt;
	System::Word FRetryWait;
	System::Byte FAnsRings;
	HWND FParentHWnd;
	bool FShowTapiDevices;
	bool FShowPorts;
	bool FEnableVoice;
	int FMaxMessageLength;
	System::Sysutils::TFileName FWaveFileName;
	bool FInterruptWave;
	HWND FHandle;
	TWaveState FWaveState;
	bool FUseSoundCard;
	Adtutil::TLineMonitorTone FSilence;
	System::Byte FTrimSeconds;
	int FSilenceThreshold;
	bool FMonitorRecording;
	int FFailCode;
	bool FFilterUnsupportedDevices;
	bool FWaitingForCall;
	TTapiCallerIDEvent FOnTapiCallerID;
	System::Classes::TNotifyEvent FOnTapiConnect;
	TTapiDTMFEvent FOnTapiDTMF;
	System::Classes::TNotifyEvent FOnTapiFail;
	TTapiLogEvent FOnTapiLog;
	System::Classes::TNotifyEvent FOnTapiPortClose;
	System::Classes::TNotifyEvent FOnTapiPortOpen;
	TTapiStatusEvent FOnTapiStatus;
	TTapiWaveNotify FOnTapiWaveNotify;
	TTapiWaveSilence FOnTapiWaveSilence;
	virtual void __fastcall DoLineCallInfo(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineCallState(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineClose(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineCreate(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineDevState(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineGenerate(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineMonitorDigits(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineMonitorMedia(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineMonitorTone(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineReply(int Device, int P1, int P2, int P3);
	virtual void __fastcall DoLineRequest(int Device, int P1, int P2, int P3);
	bool __fastcall HandleLineErr(int LineErr);
	bool __fastcall HangupCall(bool AbortRetries);
	void __fastcall UpdateCallInfo(int Device);
	int __fastcall WaitForCallState(int DesiredCallState);
	int __fastcall WaitForReply(int ID);
	void __fastcall SetOpen(bool NewOpen);
	void __fastcall AssureTapiReady(void);
	int __fastcall CidFromTapiDevice(void);
	void __fastcall CheckVoiceCapable(void);
	void __fastcall CheckWaveException(int ErrorCode, int Mode);
	void __fastcall CheckWaveInSilence(void);
	bool __fastcall CloseTapiPort(void);
	void __fastcall CloseWaveFile(void);
	void __fastcall CreateDialTimer(void);
	int __fastcall DeviceIDFromName(const System::UnicodeString Name);
	void __fastcall DialPrim(bool PassThru);
	void __fastcall EnumLineDevices(void);
	void __fastcall FreeWaveInBuffers(void);
	void __fastcall FreeWaveOutBuffer(void);
	int __fastcall GetSelectedLine(void);
	unsigned __fastcall GetWaveDeviceId(const bool Play);
	void __fastcall LoadWaveOutBuffer(void);
	void __fastcall MonitorDTMF(int &CallHandle, const int DTMFMode);
	void __fastcall OpenTapiPort(void);
	void __fastcall OpenWaveFile(void);
	void __fastcall PlayWaveOutBuffer(void);
	void __fastcall PrepareWaveInHeader(void);
	bool __fastcall StartTapi(void);
	bool __fastcall StopTapi(void);
	void __fastcall TapiDialTimer(System::TObject* Sender);
	void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	void __fastcall WriteWaveBuffer(void);
	unsigned __fastcall GetBPSRate(void);
	System::UnicodeString __fastcall GetCalledID(void);
	System::AnsiString __fastcall GetCalledIDName(void);
	System::AnsiString __fastcall GetCallerID(void);
	System::AnsiString __fastcall GetCallerIDName(void);
	int __fastcall GetComNumber(void);
	HWND __fastcall GetParentHWnd(void);
	TTapiState __fastcall GetTapiState(void);
	void __fastcall SetStatusDisplay(TApdAbstractTapiStatus* const NewDisplay);
	void __fastcall SetTapiLog(TApdTapiLog* const NewLog);
	void __fastcall SetTapiDevices(System::Classes::TStrings* const Values);
	void __fastcall SetSelectedDevice(const System::UnicodeString NewDevice);
	void __fastcall SetEnableVoice(bool Value);
	void __fastcall SetMonitorRecording(const bool Value);
	void __fastcall SetFilterUnsupportedDevices(const bool Value);
	__property bool Open = {read=FOpen, write=SetOpen, nodefault};
	void __fastcall TapiStatus(bool First, bool Last, unsigned Device, unsigned Message, unsigned Param1, unsigned Param2, unsigned Param3);
	void __fastcall TapiLogging(TTapiLogCode Log);
	void __fastcall TapiPortOpen(void);
	void __fastcall TapiPortClose(void);
	void __fastcall TapiConnect(void);
	void __fastcall TapiFail(void);
	void __fastcall TapiDTMF(System::WideChar Digit, int ErrorCode);
	void __fastcall TapiCallerID(System::UnicodeString ID, System::UnicodeString IDName);
	void __fastcall TapiWave(TWaveMessage Msg);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TApdCustomTapiDevice(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomTapiDevice(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall Dial(System::UnicodeString ANumber);
	void __fastcall AutoAnswer(void);
	void __fastcall ConfigAndOpen(void);
	bool __fastcall CancelCall(void);
	void __fastcall CopyCallInfo(Adtutil::PCallInfo &CallInfo);
	Oomisc::TTapiConfigRec __fastcall GetDevConfig(void);
	int __fastcall MontorTones(const Adtutil::TLineMonitorTones *Tones, const int Tones_High);
	void __fastcall SetDevConfig(const Oomisc::TTapiConfigRec &Config);
	void __fastcall PlayWaveFile(System::UnicodeString FileName);
	void __fastcall StopWaveFile(void);
	void __fastcall StartWaveRecord(void);
	void __fastcall StopWaveRecord(void);
	void __fastcall SaveWaveFile(System::UnicodeString FileName, bool Overwrite);
	void __fastcall SetRecordingParams(System::Byte NumChannels, int NumSamplesPerSecond, System::Byte NumBitsPerSample);
	void __fastcall ShowConfigDialog(void);
	Oomisc::TTapiConfigRec __fastcall ShowConfigDialogEdit(const Oomisc::TTapiConfigRec &Init);
	System::Uitypes::TModalResult __fastcall SelectDevice(void);
	void __fastcall SendTone(System::UnicodeString Digits, int Duration = 0x0);
	void __fastcall Transfer(System::UnicodeString aNumber);
	void __fastcall HoldCall(void);
	void __fastcall UnHoldCall(void);
	void __fastcall AutomatedVoicetoComms(void);
	System::UnicodeString __fastcall TapiStatusMsg(const unsigned Message, const unsigned State, const unsigned Reason);
	System::UnicodeString __fastcall FailureCodeMsg(const int FailureCode);
	System::AnsiString __fastcall TranslateAddress(System::AnsiString CanonicalAddr);
	int __fastcall TranslateAddressEx(System::AnsiString CanonicalAddr, int Flags, System::AnsiString &DialableStr, System::AnsiString &DisplayableStr, int &CurrentCountry, int &DestCountry, int &TranslateResults);
	bool __fastcall TranslateDialog(System::UnicodeString CanonicalAddr);
	System::UnicodeString __fastcall TapiLogToString(const TTapiLogCode LogCode);
	__property int ApiVersion = {read=FApiVersion, nodefault};
	__property System::Word Attempt = {read=FAttempt, nodefault};
	__property unsigned BPSRate = {read=GetBPSRate, nodefault};
	__property System::UnicodeString CalledID = {read=GetCalledID};
	__property System::AnsiString CalledIDName = {read=GetCalledIDName};
	__property System::AnsiString CallerID = {read=GetCallerID};
	__property System::AnsiString CallerIDName = {read=GetCallerIDName};
	__property bool Cancelled = {read=FCancelled, nodefault};
	__property int ComNumber = {read=GetComNumber, nodefault};
	__property bool Dialing = {read=FDialing, nodefault};
	__property int FailureCode = {read=FFailCode, nodefault};
	__property bool WaitingForCall = {read=FWaitingForCall, nodefault};
	__property System::Classes::TStrings* TapiDevices = {read=FTapiDevices, write=SetTapiDevices};
	__property System::UnicodeString SelectedDevice = {read=FSelectedDevice, write=SetSelectedDevice};
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=FComPort};
	__property TApdAbstractTapiStatus* StatusDisplay = {read=FStatusDisplay, write=SetStatusDisplay};
	__property TApdTapiLog* TapiLog = {read=FTapiLog, write=SetTapiLog};
	__property System::Byte AnswerOnRing = {read=FAnsRings, write=FAnsRings, default=2};
	__property System::Word MaxAttempts = {read=FMaxAttempts, write=FMaxAttempts, default=3};
	__property System::Word RetryWait = {read=FRetryWait, write=FRetryWait, default=60};
	__property bool ShowTapiDevices = {read=FShowTapiDevices, write=FShowTapiDevices, nodefault};
	__property bool ShowPorts = {read=FShowPorts, write=FShowPorts, nodefault};
	__property bool EnableVoice = {read=FEnableVoice, write=SetEnableVoice, nodefault};
	__property bool InterruptWave = {read=FInterruptWave, write=FInterruptWave, nodefault};
	__property bool UseSoundCard = {read=FUseSoundCard, write=FUseSoundCard, nodefault};
	__property System::Byte TrimSeconds = {read=FTrimSeconds, write=FTrimSeconds, nodefault};
	__property int SilenceThreshold = {read=FSilenceThreshold, write=FSilenceThreshold, nodefault};
	__property bool MonitorRecording = {read=FMonitorRecording, write=SetMonitorRecording, nodefault};
	__property HWND ParentHWnd = {read=GetParentHWnd, write=FParentHWnd};
	__property bool FilterUnsupportedDevices = {read=FFilterUnsupportedDevices, write=SetFilterUnsupportedDevices, default=1};
	__property System::UnicodeString Number = {read=FNumber};
	__property unsigned DeviceCount = {read=FDeviceCount, nodefault};
	__property TTapiState TapiState = {read=GetTapiState, nodefault};
	__property System::Sysutils::TFileName WaveFileName = {read=FWaveFileName};
	__property int MaxMessageLength = {read=FMaxMessageLength, write=FMaxMessageLength, default=60};
	__property TWaveState WaveState = {read=FWaveState, nodefault};
	__property int AvgWaveInAmplitude = {read=FAvgWaveInAmplitude, nodefault};
	__property TTapiStatusEvent OnTapiStatus = {read=FOnTapiStatus, write=FOnTapiStatus};
	__property TTapiLogEvent OnTapiLog = {read=FOnTapiLog, write=FOnTapiLog};
	__property System::Classes::TNotifyEvent OnTapiPortOpen = {read=FOnTapiPortOpen, write=FOnTapiPortOpen};
	__property System::Classes::TNotifyEvent OnTapiPortClose = {read=FOnTapiPortClose, write=FOnTapiPortClose};
	__property System::Classes::TNotifyEvent OnTapiConnect = {read=FOnTapiConnect, write=FOnTapiConnect};
	__property System::Classes::TNotifyEvent OnTapiFail = {read=FOnTapiFail, write=FOnTapiFail};
	__property TTapiDTMFEvent OnTapiDTMF = {read=FOnTapiDTMF, write=FOnTapiDTMF};
	__property TTapiCallerIDEvent OnTapiCallerID = {read=FOnTapiCallerID, write=FOnTapiCallerID};
	__property TTapiWaveNotify OnTapiWaveNotify = {read=FOnTapiWaveNotify, write=FOnTapiWaveNotify};
	__property TTapiWaveSilence OnTapiWaveSilence = {read=FOnTapiWaveSilence, write=FOnTapiWaveSilence};
};


class PASCALIMPLEMENTATION TApdTapiLog : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	System::UnicodeString FTapiHistoryName;
	TApdCustomTapiDevice* FTapiDevice;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TApdTapiLog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdTapiLog(void);
	virtual void __fastcall UpdateLog(const TTapiLogCode Log);
	
__published:
	__property System::UnicodeString TapiHistoryName = {read=FTapiHistoryName, write=FTapiHistoryName};
	__property TApdCustomTapiDevice* TapiDevice = {read=FTapiDevice, write=FTapiDevice};
};


class PASCALIMPLEMENTATION TApdAbstractTapiStatus : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	bool FAnswering;
	Vcl::Controls::TCaption FCaption;
	bool FCtl3D;
	Vcl::Forms::TForm* FDisplay;
	Vcl::Forms::TPosition FPosition;
	bool FVisible;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	TApdCustomTapiDevice* FTapiDevice;
	void __fastcall SetPosition(const Vcl::Forms::TPosition NewPosition);
	void __fastcall SetCtl3D(const bool NewCtl3D);
	void __fastcall SetVisible(const bool NewVisible);
	void __fastcall SetCaption(const Vcl::Controls::TCaption NewCaption);
	void __fastcall GetProperties(void);
	void __fastcall Show(void);
	
public:
	__fastcall virtual TApdAbstractTapiStatus(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdAbstractTapiStatus(void);
	virtual void __fastcall UpdateDisplay(bool First, bool Last, unsigned Device, unsigned Message, unsigned Param1, unsigned Param2, unsigned Param3) = 0 ;
	DYNAMIC void __fastcall CreateDisplay(void) = 0 ;
	DYNAMIC void __fastcall DestroyDisplay(void) = 0 ;
	__property bool Answering = {read=FAnswering, write=FAnswering, nodefault};
	__property Vcl::Forms::TForm* Display = {read=FDisplay, write=FDisplay};
	
__published:
	__property Vcl::Forms::TPosition Position = {read=FPosition, write=SetPosition, nodefault};
	__property bool Ctl3D = {read=FCtl3D, write=SetCtl3D, nodefault};
	__property bool Visible = {read=FVisible, write=SetVisible, nodefault};
	__property TApdCustomTapiDevice* TapiDevice = {read=FTapiDevice, write=FTapiDevice};
	__property Vcl::Controls::TCaption Caption = {read=FCaption, write=SetCaption};
};


class PASCALIMPLEMENTATION TApdTapiDevice : public TApdCustomTapiDevice
{
	typedef TApdCustomTapiDevice inherited;
	
__published:
	__property SelectedDevice = {default=0};
	__property ComPort;
	__property StatusDisplay;
	__property TapiLog;
	__property AnswerOnRing = {default=2};
	__property RetryWait = {default=60};
	__property MaxAttempts = {default=3};
	__property ShowTapiDevices;
	__property ShowPorts;
	__property EnableVoice;
	__property FilterUnsupportedDevices = {default=1};
	__property OnTapiStatus;
	__property OnTapiLog;
	__property OnTapiPortOpen;
	__property OnTapiPortClose;
	__property OnTapiConnect;
	__property OnTapiFail;
	__property OnTapiDTMF;
	__property OnTapiCallerID;
	__property OnTapiWaveNotify;
	__property OnTapiWaveSilence;
public:
	/* TApdCustomTapiDevice.Create */ inline __fastcall virtual TApdTapiDevice(System::Classes::TComponent* AOwner) : TApdCustomTapiDevice(AOwner) { }
	/* TApdCustomTapiDevice.Destroy */ inline __fastcall virtual ~TApdTapiDevice(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 Success = System::Int8(0x0);
static const System::Int8 WaitErr_WaitAborted = System::Int8(0x1);
static const System::Int8 WaitErr_WaitTimedOut = System::Int8(0x2);
static const System::Int8 LineCallState_Any = System::Int8(0x0);
static const System::Word WaitTimeout = System::Word(0x7530);
static const System::Word TapiErrorBase = System::Word(0x35e8);
static const System::Word TapiStatusBase = System::Word(0x34bc);
static const System::Int8 lcsBase = System::Int8(0x0);
static const System::Int8 ldsBase = System::Int8(0x20);
static const System::Int8 lrBase = System::Int8(0x40);
static const System::Int8 asBase = System::Int8(0x60);
static const System::Byte lcsdBase = System::Byte(0x96);
#define DefTapiHistoryName L"APROTAPI.HIS"
static const System::Int8 DefMaxAttempts = System::Int8(0x3);
static const System::Int8 DefAnsRings = System::Int8(0x2);
static const System::Int8 DefRetryWait = System::Int8(0x3c);
static const bool DefShowTapiDevices = true;
static const bool DefShowPorts = true;
static const System::Int8 DefMaxMessageLength = System::Int8(0x3c);
static const TWaveState DefWaveState = (TWaveState)(0);
static const bool DefUseSoundCard = false;
static const System::Int8 DefTrimSeconds = System::Int8(0x2);
static const System::Int8 DefSilenceThreshold = System::Int8(0x32);
static const System::Int8 DefChannels = System::Int8(0x1);
static const System::Int8 DefBitsPerSample = System::Int8(0x10);
static const System::Word DefSamplesPerSecond = System::Word(0x1f40);
static const bool DefMonitorRecording = false;
static const System::Int8 WaveInError = System::Int8(0x1);
static const System::Int8 WaveOutError = System::Int8(0x2);
static const System::Int8 MMioError = System::Int8(0x3);
static const System::Int8 BufferSeconds = System::Int8(0x1);
static const System::Int8 WaveOutBufferSeconds = System::Int8(0x3);
}	/* namespace Adtapi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADTAPI)
using namespace Adtapi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdtapiHPP
