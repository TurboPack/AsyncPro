// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdPort.pas' rev: 32.00 (Windows)

#ifndef AdportHPP
#define AdportHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <LNSWin32.hpp>
#include <AdExcept.hpp>
#include <AdSelCom.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adport
{
//-- forward type declarations -----------------------------------------------
struct TUserListEntry;
class DELPHICLASS TApdCustomComPort;
class DELPHICLASS TApdComPort;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TParity : unsigned char { pNone, pOdd, pEven, pMark, pSpace };

typedef Awuser::TApdBaseDispatcher* __fastcall (*TActivationProcedure)(System::TObject* Owner);

enum DECLSPEC_DENUM TDeviceLayer : unsigned char { dlWin32, dlWinsock };

typedef System::Set<TDeviceLayer, TDeviceLayer::dlWin32, TDeviceLayer::dlWinsock> TDeviceLayers;

typedef int TBaudRate;

enum DECLSPEC_DENUM TTapiMode : unsigned char { tmNone, tmAuto, tmOn, tmOff };

enum DECLSPEC_DENUM TPortState : unsigned char { psClosed, psShuttingDown, psOpen };

enum DECLSPEC_DENUM THWFlowOptions : unsigned char { hwfUseDTR, hwfUseRTS, hwfRequireDSR, hwfRequireCTS };

typedef System::Set<THWFlowOptions, THWFlowOptions::hwfUseDTR, THWFlowOptions::hwfRequireCTS> THWFlowOptionSet;

enum DECLSPEC_DENUM TSWFlowOptions : unsigned char { swfNone, swfReceive, swfTransmit, swfBoth };

enum DECLSPEC_DENUM TFlowControlState : unsigned char { fcOff, fcOn, fcDsrHold, fcCtsHold, fcDcdHold, fcXOutHold, fcXInHold, fcXBothHold };

enum DECLSPEC_DENUM TTraceLogState : unsigned char { tlOff, tlOn, tlDump, tlAppend, tlClear, tlPause, tlAppendAndContinue };

typedef void __fastcall (__closure *TTriggerEvent)(System::TObject* CP, System::Word Msg, System::Word TriggerHandle, System::Word Data);

typedef void __fastcall (__closure *TTriggerAvailEvent)(System::TObject* CP, System::Word Count);

typedef void __fastcall (__closure *TTriggerDataEvent)(System::TObject* CP, System::Word TriggerHandle);

typedef void __fastcall (__closure *TTriggerStatusEvent)(System::TObject* CP, System::Word TriggerHandle);

typedef void __fastcall (__closure *TTriggerTimerEvent)(System::TObject* CP, System::Word TriggerHandle);

typedef void __fastcall (__closure *TTriggerLineErrorEvent)(System::TObject* CP, System::Word Error, bool LineBreak);

typedef void __fastcall (__closure *TWaitCharEvent)(System::TObject* CP, char C);

typedef void __fastcall (__closure *TPortCallback)(System::TObject* CP, bool Opening);

enum DECLSPEC_DENUM TApdCallbackType : unsigned char { ctOpen, ctClosing, ctClosed };

typedef void __fastcall (__closure *TPortCallbackEx)(System::TObject* CP, TApdCallbackType CallbackType);

typedef TUserListEntry *PUserListEntry;

struct DECLSPEC_DRECORD TUserListEntry
{
public:
	NativeUInt Handle;
	TPortCallback OpenClose;
	TPortCallbackEx OpenCloseEx;
	bool IsEx;
};


enum DECLSPEC_DENUM TApThreadBoost : unsigned char { tbNone, tbPlusOne, tbPlusTwo };

class PASCALIMPLEMENTATION TApdCustomComPort : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	int __fastcall GetLastWinError(void);
	
protected:
	bool Force;
	TPortState PortState;
	bool OpenPending;
	bool ForceOpen;
	System::Classes::TList* UserList;
	bool CopyTriggers;
	Oomisc::TTriggerSave SaveTriggerBuffer;
	bool BusyBeforeWait;
	bool WaitPrepped;
	NativeUInt fComWindow;
	TActivationProcedure fCustomDispatcher;
	Vcl::Controls::TWinControl* FMasterTerminal;
	TDeviceLayer FDeviceLayer;
	TDeviceLayers FDeviceLayers;
	Awuser::TApdBaseDispatcher* FDispatcher;
	System::Word FComNumber;
	int FBaud;
	TParity FParity;
	System::Word FDatabits;
	System::Word FStopbits;
	System::Word FInSize;
	System::Word FOutSize;
	bool FOpen;
	bool FPromptForPort;
	bool FAutoOpen;
	System::Word FCommNotificationLevel;
	System::Word FTapiCid;
	TTapiMode FTapiMode;
	bool FRS485Mode;
	TApThreadBoost FThreadBoost;
	bool FDTR;
	bool FRTS;
	System::Word FBufferFull;
	System::Word FBufferResume;
	THWFlowOptionSet FHWFlowOptions;
	TSWFlowOptions FSWFlowOptions;
	char FXOnChar;
	char FXOffChar;
	TTraceLogState FTracing;
	unsigned FTraceSize;
	System::UnicodeString FTraceName;
	bool FTraceHex;
	bool FTraceAllHex;
	TTraceLogState FLogging;
	unsigned FLogSize;
	System::UnicodeString FLogName;
	bool FLogHex;
	bool FLogAllHex;
	bool FUseMSRShadow;
	bool FUseEventWord;
	System::Word FTriggerLength;
	TTriggerEvent FOnTrigger;
	TTriggerAvailEvent FOnTriggerAvail;
	TTriggerDataEvent FOnTriggerData;
	TTriggerStatusEvent FOnTriggerStatus;
	TTriggerTimerEvent FOnTriggerTimer;
	TTriggerLineErrorEvent FOnTriggerLineError;
	System::Classes::TNotifyEvent FOnTriggerModemStatus;
	System::Classes::TNotifyEvent FOnTriggerOutbuffFree;
	System::Classes::TNotifyEvent FOnTriggerOutbuffUsed;
	System::Classes::TNotifyEvent FOnTriggerOutSent;
	System::Classes::TNotifyEvent FOnPortOpen;
	System::Classes::TNotifyEvent FOnPortClose;
	TWaitCharEvent FOnWaitChar;
	void __fastcall SetDeviceLayer(const TDeviceLayer NewDevice);
	void __fastcall SetComNumber(const System::Word NewNumber);
	void __fastcall SetBaud(const int NewBaud);
	void __fastcall SetParity(const TParity NewParity);
	void __fastcall SetDatabits(const System::Word NewBits);
	void __fastcall SetStopbits(const System::Word NewBits);
	void __fastcall SetInSize(const System::Word NewSize);
	void __fastcall SetOutSize(const System::Word NewSize);
	void __fastcall SetTracing(const TTraceLogState NewState);
	void __fastcall SetTraceSize(const unsigned NewSize);
	void __fastcall SetLogging(const TTraceLogState NewState);
	void __fastcall SetLogSize(const unsigned NewSize);
	void __fastcall SetOpen(const bool Enable);
	void __fastcall SetHWFlowOptions(const THWFlowOptionSet NewOpts);
	TFlowControlState __fastcall GetFlowState(void);
	void __fastcall SetSWFlowOptions(const TSWFlowOptions NewOpts);
	void __fastcall SetXonChar(const char NewChar);
	void __fastcall SetXoffChar(const char NewChar);
	void __fastcall SetBufferFull(const System::Word NewFull);
	void __fastcall SetBufferResume(const System::Word NewResume);
	void __fastcall SetTriggerLength(const System::Word NewLength);
	void __fastcall SetDTR(const bool NewDTR);
	void __fastcall SetRTS(const bool NewRTS);
	void __fastcall SetOnTrigger(const TTriggerEvent Value);
	void __fastcall SetOnTriggerAvail(const TTriggerAvailEvent Value);
	void __fastcall SetOnTriggerData(const TTriggerDataEvent Value);
	void __fastcall SetOnTriggerStatus(const TTriggerStatusEvent Value);
	void __fastcall SetOnTriggerTimer(const TTriggerTimerEvent Value);
	void __fastcall SetOnTriggerLineError(const TTriggerLineErrorEvent Value);
	void __fastcall SetOnTriggerModemStatus(const System::Classes::TNotifyEvent Value);
	void __fastcall SetOnTriggerOutbuffFree(const System::Classes::TNotifyEvent Value);
	void __fastcall SetOnTriggerOutbuffUsed(const System::Classes::TNotifyEvent Value);
	void __fastcall SetOnTriggerOutSent(const System::Classes::TNotifyEvent Value);
	System::Word __fastcall GetBaseAddress(void);
	Awuser::TApdBaseDispatcher* __fastcall GetDispatcher(void);
	System::Byte __fastcall GetModemStatus(void);
	bool __fastcall GetDSR(void);
	bool __fastcall GetCTS(void);
	bool __fastcall GetRI(void);
	bool __fastcall GetDCD(void);
	bool __fastcall GetDeltaDSR(void);
	bool __fastcall GetDeltaCTS(void);
	bool __fastcall GetDeltaRI(void);
	bool __fastcall GetDeltaDCD(void);
	System::Word __fastcall GetLineError(void);
	bool __fastcall GetLineBreak(void);
	System::Word __fastcall GetInBuffUsed(void);
	System::Word __fastcall GetInBuffFree(void);
	System::Word __fastcall GetOutBuffUsed(void);
	System::Word __fastcall GetOutBuffFree(void);
	void __fastcall SetUseEventWord(bool NewUse);
	void __fastcall SetCommNotificationLevel(System::Word NewLevel);
	void __fastcall SetRS485Mode(bool NewMode);
	void __fastcall SetBaseAddress(System::Word NewBaseAddress);
	void __fastcall SetThreadBoost(TApThreadBoost NewBoost);
	virtual Awuser::TApdBaseDispatcher* __fastcall ActivateDeviceLayer(void);
	virtual void __fastcall DeviceLayerChanged(void);
	virtual int __fastcall InitializePort(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall RegisterComPort(bool Enabling);
	virtual void __fastcall ValidateComport(void);
	virtual void __fastcall SetUseMSRShadow(bool NewUse);
	virtual void __fastcall Trigger(System::Word Msg, System::Word TriggerHandle, System::Word Data);
	virtual void __fastcall TriggerAvail(System::Word Count);
	virtual void __fastcall TriggerData(System::Word TriggerHandle);
	virtual void __fastcall TriggerStatus(System::Word TriggerHandle);
	virtual void __fastcall TriggerTimer(System::Word TriggerHandle);
	virtual void __fastcall UpdateHandlerFlag(void);
	DYNAMIC void __fastcall PortOpen(void);
	DYNAMIC void __fastcall PortClose(void);
	DYNAMIC void __fastcall PortClosing(void);
	virtual void __fastcall TriggerLineError(const System::Word Error, const bool LineBreak);
	virtual void __fastcall TriggerModemStatus(void);
	virtual void __fastcall TriggerOutbuffFree(void);
	virtual void __fastcall TriggerOutbuffUsed(void);
	virtual void __fastcall TriggerOutSent(void);
	virtual void __fastcall WaitChar(char C);
	void __fastcall InitTracing(const unsigned NumEntries);
	void __fastcall DumpTrace(const System::UnicodeString FName, const bool InHex);
	void __fastcall AppendTrace(const System::UnicodeString FName, const bool InHex, const TTraceLogState NewState);
	void __fastcall ClearTracing(void);
	void __fastcall AbortTracing(void);
	void __fastcall StartTracing(void);
	void __fastcall StopTracing(void);
	void __fastcall InitLogging(const unsigned Size);
	void __fastcall DumpLog(const System::UnicodeString FName, const bool InHex);
	void __fastcall AppendLog(const System::UnicodeString FName, const bool InHex, const TTraceLogState NewState);
	void __fastcall ClearLogging(void);
	void __fastcall AbortLogging(void);
	void __fastcall StartLogging(void);
	void __fastcall StopLogging(void);
	
public:
	bool OverrideLine;
	__fastcall virtual TApdCustomComPort(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomComPort(void);
	DYNAMIC void __fastcall InitPort(void);
	virtual void __fastcall DonePort(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall ForcePortOpen(void);
	void __fastcall SendBreak(System::Word Ticks, bool Yield);
	void __fastcall SetBreak(bool BreakOn);
	void __fastcall RegisterUser(const NativeUInt H);
	void __fastcall RegisterUserEx(const NativeUInt H);
	void __fastcall RegisterUserCallback(TPortCallback CallBack);
	void __fastcall RegisterUserCallbackEx(TPortCallbackEx CallBackEx);
	void __fastcall DeregisterUser(const NativeUInt H);
	void __fastcall DeregisterUserCallback(TPortCallback CallBack);
	void __fastcall DeregisterUserCallbackEx(TPortCallbackEx CallBackEx);
	virtual void __fastcall ProcessCommunications(void);
	void __fastcall FlushInBuffer(void);
	void __fastcall FlushOutBuffer(void);
	System::Word __fastcall AddDataTrigger(const System::ShortString &Data, const bool IgnoreCase);
	System::Word __fastcall AddTimerTrigger(void);
	System::Word __fastcall AddStatusTrigger(const System::Word SType);
	void __fastcall RemoveTrigger(const System::Word Handle);
	void __fastcall RemoveAllTriggers(void);
	void __fastcall SetTimerTrigger(const System::Word Handle, const int Ticks, const bool Activate);
	void __fastcall SetStatusTrigger(const System::Word Handle, const System::Word Value, const bool Activate);
	bool __fastcall CharReady(void);
	char __fastcall PeekChar(const System::Word Count);
	char __fastcall GetChar(void);
	void __fastcall PeekBlock(void *Block, const System::Word Len);
	void __fastcall GetBlock(void *Block, const System::Word Len);
	void __fastcall PutChar(const char C);
	void __fastcall PutString(const System::UnicodeString S)/* overload */;
	void __fastcall PutString(const System::AnsiString S)/* overload */;
	int __fastcall PutBlock(const void *Block, const System::Word Len);
	bool __fastcall CheckForString(System::Byte &Index, char C, const System::AnsiString S, bool IgnoreCase);
	bool __fastcall WaitForString(const System::AnsiString S, const int Timeout, const bool Yield, const bool IgnoreCase);
	int __fastcall WaitForMultiString(const System::AnsiString S, const int Timeout, const bool Yield, const bool IgnoreCase, const char SepChar);
	void __fastcall PrepareWait(void);
	__property System::Word ComNumber = {read=FComNumber, write=SetComNumber, default=0};
	__property TActivationProcedure CustomDispatcher = {read=fCustomDispatcher, write=fCustomDispatcher};
	__property TDeviceLayer DeviceLayer = {read=FDeviceLayer, write=SetDeviceLayer, default=0};
	__property NativeUInt ComWindow = {read=fComWindow};
	__property int Baud = {read=FBaud, write=SetBaud, default=19200};
	__property TParity Parity = {read=FParity, write=SetParity, default=0};
	__property bool PromptForPort = {read=FPromptForPort, write=FPromptForPort, default=1};
	__property System::Word DataBits = {read=FDatabits, write=SetDatabits, default=8};
	__property System::Word StopBits = {read=FStopbits, write=SetStopbits, default=1};
	__property System::Word InSize = {read=FInSize, write=SetInSize, default=4096};
	__property System::Word OutSize = {read=FOutSize, write=SetOutSize, default=4096};
	__property bool Open = {read=FOpen, write=SetOpen, default=0};
	__property bool AutoOpen = {read=FAutoOpen, write=FAutoOpen, default=1};
	__property System::Word CommNotificationLevel = {read=FCommNotificationLevel, write=SetCommNotificationLevel, default=10};
	__property TTapiMode TapiMode = {read=FTapiMode, write=FTapiMode, default=1};
	__property System::Word TapiCid = {read=FTapiCid, write=FTapiCid, nodefault};
	__property bool RS485Mode = {read=FRS485Mode, write=SetRS485Mode, default=0};
	__property System::Word BaseAddress = {read=GetBaseAddress, write=SetBaseAddress, default=0};
	__property TApThreadBoost ThreadBoost = {read=FThreadBoost, write=SetThreadBoost, nodefault};
	__property Vcl::Controls::TWinControl* MasterTerminal = {read=FMasterTerminal, write=FMasterTerminal};
	__property bool DTR = {read=FDTR, write=SetDTR, default=1};
	__property bool RTS = {read=FRTS, write=SetRTS, default=1};
	__property THWFlowOptionSet HWFlowOptions = {read=FHWFlowOptions, write=SetHWFlowOptions, default=0};
	__property TFlowControlState FlowState = {read=GetFlowState, nodefault};
	__property TSWFlowOptions SWFlowOptions = {read=FSWFlowOptions, write=SetSWFlowOptions, default=0};
	__property char XOnChar = {read=FXOnChar, write=SetXonChar, default=17};
	__property char XOffChar = {read=FXOffChar, write=SetXoffChar, default=19};
	__property System::Word BufferFull = {read=FBufferFull, write=SetBufferFull, default=0};
	__property System::Word BufferResume = {read=FBufferResume, write=SetBufferResume, default=0};
	__property TTraceLogState Tracing = {read=FTracing, write=SetTracing, default=0};
	__property unsigned TraceSize = {read=FTraceSize, write=SetTraceSize, default=10000};
	__property System::UnicodeString TraceName = {read=FTraceName, write=FTraceName};
	__property bool TraceHex = {read=FTraceHex, write=FTraceHex, default=1};
	__property bool TraceAllHex = {read=FTraceAllHex, write=FTraceAllHex, default=0};
	__property TTraceLogState Logging = {read=FLogging, write=SetLogging, default=0};
	__property unsigned LogSize = {read=FLogSize, write=SetLogSize, default=10000};
	__property System::UnicodeString LogName = {read=FLogName, write=FLogName};
	__property bool LogHex = {read=FLogHex, write=FLogHex, default=1};
	__property bool LogAllHex = {read=FLogAllHex, write=FLogAllHex, default=0};
	__property bool UseMSRShadow = {read=FUseMSRShadow, write=SetUseMSRShadow, default=1};
	__property bool UseEventWord = {read=FUseEventWord, write=SetUseEventWord, default=1};
	void __fastcall AddTraceEntry(const char CurEntry, const char CurCh);
	void __fastcall AddStringToLog(System::AnsiString S);
	__property System::Word TriggerLength = {read=FTriggerLength, write=SetTriggerLength, default=1};
	__property TTriggerEvent OnTrigger = {read=FOnTrigger, write=SetOnTrigger};
	__property TTriggerAvailEvent OnTriggerAvail = {read=FOnTriggerAvail, write=SetOnTriggerAvail};
	__property TTriggerDataEvent OnTriggerData = {read=FOnTriggerData, write=SetOnTriggerData};
	__property TTriggerStatusEvent OnTriggerStatus = {read=FOnTriggerStatus, write=SetOnTriggerStatus};
	__property TTriggerTimerEvent OnTriggerTimer = {read=FOnTriggerTimer, write=SetOnTriggerTimer};
	__property System::Classes::TNotifyEvent OnPortOpen = {read=FOnPortOpen, write=FOnPortOpen};
	__property System::Classes::TNotifyEvent OnPortClose = {read=FOnPortClose, write=FOnPortClose};
	__property TTriggerLineErrorEvent OnTriggerLineError = {read=FOnTriggerLineError, write=SetOnTriggerLineError};
	__property System::Classes::TNotifyEvent OnTriggerModemStatus = {read=FOnTriggerModemStatus, write=SetOnTriggerModemStatus};
	__property System::Classes::TNotifyEvent OnTriggerOutbuffFree = {read=FOnTriggerOutbuffFree, write=SetOnTriggerOutbuffFree};
	__property System::Classes::TNotifyEvent OnTriggerOutbuffUsed = {read=FOnTriggerOutbuffUsed, write=SetOnTriggerOutbuffUsed};
	__property System::Classes::TNotifyEvent OnTriggerOutSent = {read=FOnTriggerOutSent, write=SetOnTriggerOutSent};
	__property TWaitCharEvent OnWaitChar = {read=FOnWaitChar, write=FOnWaitChar};
	__property System::AnsiString Output = {write=PutString};
	__property System::UnicodeString OutputUni = {write=PutString};
	__property Awuser::TApdBaseDispatcher* Dispatcher = {read=GetDispatcher};
	Awuser::TApdBaseDispatcher* __fastcall ValidDispatcher(void);
	__property System::Byte ModemStatus = {read=GetModemStatus, nodefault};
	__property bool DSR = {read=GetDSR, nodefault};
	__property bool CTS = {read=GetCTS, nodefault};
	__property bool RI = {read=GetRI, nodefault};
	__property bool DCD = {read=GetDCD, nodefault};
	__property bool DeltaDSR = {read=GetDeltaDSR, nodefault};
	__property bool DeltaCTS = {read=GetDeltaCTS, nodefault};
	__property bool DeltaRI = {read=GetDeltaRI, nodefault};
	__property bool DeltaDCD = {read=GetDeltaDCD, nodefault};
	__property System::Word LineError = {read=GetLineError, nodefault};
	__property bool LineBreak = {read=GetLineBreak, nodefault};
	__property System::Word InBuffUsed = {read=GetInBuffUsed, nodefault};
	__property System::Word InBuffFree = {read=GetInBuffFree, nodefault};
	__property System::Word OutBuffUsed = {read=GetOutBuffUsed, nodefault};
	__property System::Word OutBuffFree = {read=GetOutBuffFree, nodefault};
	__property int LastWinError = {read=GetLastWinError, nodefault};
};


class PASCALIMPLEMENTATION TApdComPort : public TApdCustomComPort
{
	typedef TApdCustomComPort inherited;
	
__published:
	__property DeviceLayer = {default=0};
	__property ComNumber = {default=0};
	__property Baud = {default=19200};
	__property PromptForPort = {default=1};
	__property Parity = {default=0};
	__property DataBits = {default=8};
	__property StopBits = {default=1};
	__property InSize = {default=4096};
	__property OutSize = {default=4096};
	__property AutoOpen = {default=1};
	__property Open = {default=0};
	__property DTR = {default=1};
	__property RTS = {default=1};
	__property HWFlowOptions = {default=0};
	__property SWFlowOptions = {default=0};
	__property XOnChar = {default=17};
	__property XOffChar = {default=19};
	__property BufferFull = {default=0};
	__property BufferResume = {default=0};
	__property Tracing = {default=0};
	__property TraceSize = {default=10000};
	__property TraceName = {default=0};
	__property TraceHex = {default=1};
	__property TraceAllHex = {default=0};
	__property Logging = {default=0};
	__property LogSize = {default=10000};
	__property LogName = {default=0};
	__property LogHex = {default=1};
	__property LogAllHex = {default=0};
	__property UseMSRShadow = {default=1};
	__property UseEventWord = {default=1};
	__property CommNotificationLevel = {default=10};
	__property TapiMode = {default=1};
	__property RS485Mode = {default=0};
	__property OnPortClose;
	__property OnPortOpen;
	__property OnTrigger;
	__property OnTriggerAvail;
	__property OnTriggerData;
	__property OnTriggerStatus;
	__property OnTriggerTimer;
	__property OnTriggerLineError;
	__property OnTriggerModemStatus;
	__property OnTriggerOutbuffFree;
	__property OnTriggerOutbuffUsed;
	__property OnTriggerOutSent;
	__property Tag = {default=0};
public:
	/* TApdCustomComPort.Create */ inline __fastcall virtual TApdComPort(System::Classes::TComponent* AOwner) : TApdCustomComPort(AOwner) { }
	/* TApdCustomComPort.Destroy */ inline __fastcall virtual ~TApdComPort(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::StaticArray<System::SmallString<5>, 5> ParityName;
static const TDeviceLayer adpoDefDeviceLayer = (TDeviceLayer)(0);
static const bool adpoDefPromptForPort = true;
static const System::Int8 adpoDefComNumber = System::Int8(0x0);
static const System::Word adpoDefBaudRt = System::Word(0x4b00);
static const TParity adpoDefParity = (TParity)(0);
static const System::Int8 adpoDefDatabits = System::Int8(0x8);
static const System::Int8 adpoDefStopbits = System::Int8(0x1);
static const System::Word adpoDefInSize = System::Word(0x1000);
static const System::Word adpoDefOutSize = System::Word(0x1000);
static const bool adpoDefOpen = false;
static const bool adpoDefAutoOpen = true;
static const System::Int8 adpoDefBaseAddress = System::Int8(0x0);
static const TTapiMode adpoDefTapiMode = (TTapiMode)(1);
static const bool adpoDefDTR = true;
static const bool adpoDefRTS = true;
static const TTraceLogState adpoDefTracing = (TTraceLogState)(0);
static const System::Word adpoDefTraceSize = System::Word(0x2710);
#define adpoDefTraceName L"APRO.TRC"
static const bool adpoDefTraceHex = true;
static const bool adpoDefTraceAllHex = false;
static const TTraceLogState adpoDefLogging = (TTraceLogState)(0);
static const System::Word adpoDefLogSize = System::Word(0x2710);
#define adpoDefLogName L"APRO.LOG"
static const bool adpoDefLogHex = true;
static const bool adpoDefLogAllHex = false;
static const bool adpoDefUseMSRShadow = true;
static const bool adpoDefUseEventWord = true;
static const TSWFlowOptions adpoDefSWFlowOptions = (TSWFlowOptions)(0);
static const System::WideChar adpoDefXonChar = (System::WideChar)(0x11);
static const System::WideChar adpoDefXoffChar = (System::WideChar)(0x13);
static const System::Int8 adpoDefBufferFull = System::Int8(0x0);
static const System::Int8 adpoDefBufferResume = System::Int8(0x0);
static const System::Int8 adpoDefTriggerLength = System::Int8(0x1);
static const System::Int8 adpoDefCommNotificationLevel = System::Int8(0xa);
static const bool adpoDefRS485Mode = false;
extern DELPHI_PACKAGE TApdCustomComPort* __fastcall SearchComPort(System::Classes::TComponent* const C);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ComName(const System::Word ComNumber);
}	/* namespace Adport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADPORT)
using namespace Adport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdportHPP
