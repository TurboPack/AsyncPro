// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwUser.pas' rev: 32.00 (Windows)

#ifndef AwuserHPP
#define AwuserHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Winapi.MMSystem.hpp>
#include <OoMisc.hpp>
#include <AdExcept.hpp>
#include <LnsQueue.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awuser
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdDispatcherThread;
class DELPHICLASS TOutThread;
class DELPHICLASS TComThread;
class DELPHICLASS TDispThread;
class DELPHICLASS TApdBaseDispatcher;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TApHandlerFlagUpdate : unsigned char { fuKeepPort, fuEnablePort, fuDisablePort };

class PASCALIMPLEMENTATION TApdDispatcherThread : public System::Classes::TThread
{
	typedef System::Classes::TThread inherited;
	
private:
	unsigned pMsg;
	unsigned pTrigger;
	int plParam;
	Oomisc::TApdNotifyEvent pTriggerEvent;
	void __fastcall SyncEvent(void);
	
protected:
	TApdBaseDispatcher* H;
	
public:
	__fastcall TApdDispatcherThread(TApdBaseDispatcher* Disp);
	void __fastcall SyncNotify(unsigned Msg, unsigned Trigger, int lParam, Oomisc::TApdNotifyEvent Event);
	void __fastcall Sync(System::Classes::TThreadMethod Method);
	__property ReturnValue;
public:
	/* TThread.Destroy */ inline __fastcall virtual ~TApdDispatcherThread(void) { }
	
};


class PASCALIMPLEMENTATION TOutThread : public TApdDispatcherThread
{
	typedef TApdDispatcherThread inherited;
	
public:
	virtual void __fastcall Execute(void);
public:
	/* TApdDispatcherThread.Create */ inline __fastcall TOutThread(TApdBaseDispatcher* Disp) : TApdDispatcherThread(Disp) { }
	
public:
	/* TThread.Destroy */ inline __fastcall virtual ~TOutThread(void) { }
	
};


class PASCALIMPLEMENTATION TComThread : public TApdDispatcherThread
{
	typedef TApdDispatcherThread inherited;
	
public:
	virtual void __fastcall Execute(void);
public:
	/* TApdDispatcherThread.Create */ inline __fastcall TComThread(TApdBaseDispatcher* Disp) : TApdDispatcherThread(Disp) { }
	
public:
	/* TThread.Destroy */ inline __fastcall virtual ~TComThread(void) { }
	
};


class PASCALIMPLEMENTATION TDispThread : public TApdDispatcherThread
{
	typedef TApdDispatcherThread inherited;
	
public:
	virtual void __fastcall Execute(void);
public:
	/* TApdDispatcherThread.Create */ inline __fastcall TDispThread(TApdBaseDispatcher* Disp) : TApdDispatcherThread(Disp) { }
	
public:
	/* TThread.Destroy */ inline __fastcall virtual ~TDispThread(void) { }
	
};


typedef System::TMetaClass* TApdDispatcherClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdBaseDispatcher : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::TObject* fOwner;
	int fHandle;
	bool OpenHandle;
	int CidEx;
	int LastError;
	unsigned InQue;
	unsigned OutQue;
	unsigned ModemStatus;
	_COMSTAT ComStatus;
	_DCB DCB;
	int LastBaud;
	unsigned Flags;
	bool DTRState;
	bool DTRAuto;
	bool RTSState;
	bool RTSAuto;
	unsigned fDispatcherWindow;
	unsigned LastModemStatus;
	unsigned LastLineErr;
	bool RS485Mode;
	System::Word BaseAddress;
	bool PortHandlerInstalled;
	bool HandlerServiceNeeded;
	System::Classes::TList* WndTriggerHandlers;
	System::Classes::TList* ProcTriggerHandlers;
	System::Classes::TList* EventTriggerHandlers;
	System::Classes::TList* TimerTriggers;
	System::Classes::TList* DataTriggers;
	System::Classes::TList* StatusTriggers;
	unsigned LastTailData;
	unsigned LastTailLen;
	unsigned LenTrigger;
	bool GlobalStatHit;
	bool InAvailMessage;
	unsigned GetCount;
	unsigned MaxGetCount;
	bool DispatchFull;
	unsigned NotifyTail;
	bool KillThreads;
	TApdDispatcherThread* ComThread;
	TDispThread* fDispThread;
	TApdDispatcherThread* OutThread;
	TApdDispatcherThread* StatusThread;
	System::Byte ThreadBoost;
	_RTL_CRITICAL_SECTION DataSection;
	_RTL_CRITICAL_SECTION OutputSection;
	_RTL_CRITICAL_SECTION DispSection;
	NativeUInt ComEvent;
	NativeUInt ReadyEvent;
	NativeUInt GeneralEvent;
	NativeUInt OutputEvent;
	NativeUInt SentEvent;
	NativeUInt OutFlushEvent;
	System::StaticArray<NativeUInt, 2> OutWaitObjects1;
	System::StaticArray<NativeUInt, 2> OutWaitObjects2;
	unsigned CurrentEvent;
	bool RingFlag;
	Lnsqueue::TIOQueue* FQueue;
	Oomisc::TOBuffer *OBuffer;
	unsigned OBufHead;
	unsigned OBufTail;
	bool OBufFull;
	Oomisc::TDBuffer *DBuffer;
	unsigned DBufHead;
	unsigned DBufTail;
	bool fEventBusy;
	bool DeletePending;
	bool ClosePending;
	bool OutSentPending;
	bool TracingOn;
	Oomisc::TTraceQueue *TraceQueue;
	unsigned TraceIndex;
	unsigned TraceMax;
	bool TraceWrapped;
	bool DLoggingOn;
	Lnsqueue::TIOQueue* DLoggingQueue;
	unsigned DLoggingMax;
	unsigned TimeBase;
	unsigned TimerID;
	unsigned TriggerCounter;
	bool DispActive;
	bool DoDonePortPrim;
	int ActiveThreads;
	bool CloseComActive;
	virtual int __fastcall EscapeComFunction(int Func) = 0 ;
	virtual int __fastcall FlushCom(int Queue) = 0 ;
	virtual int __fastcall GetComError(_COMSTAT &Stat) = 0 ;
	virtual unsigned __fastcall GetComEventMask(int EvtMask) = 0 ;
	virtual int __fastcall GetComState(_DCB &DCB) = 0 ;
	virtual int __fastcall ReadCom(char * Buf, int Size) = 0 ;
	virtual int __fastcall SetComState(_DCB &DCB) = 0 ;
	virtual int __fastcall WriteCom(char * Buf, int Size) = 0 ;
	virtual bool __fastcall WaitComEvent(unsigned &EvtMask, Winapi::Windows::POverlapped lpOverlapped) = 0 ;
	virtual bool __fastcall SetupCom(int InSize, int OutSize) = 0 ;
	bool __fastcall CheckReceiveTriggers(void);
	bool __fastcall CheckStatusTriggers(void);
	bool __fastcall CheckTimerTriggers(void);
	bool __fastcall CheckTriggers(void);
	void __fastcall CreateDispatcherWindow(void);
	virtual void __fastcall DonePortPrim(void);
	int __fastcall DumpDispatchLogPrim(System::UnicodeString FName, bool AppendFile, bool InHex, bool AllHex);
	int __fastcall DumpTracePrim(System::UnicodeString FName, bool AppendFile, bool InHex, bool AllHex);
	bool __fastcall ExtractData(void);
	int __fastcall FindTriggerFromHandle(unsigned TriggerHandle, bool Delete, Oomisc::TTriggerType &T, void * &Trigger);
	unsigned __fastcall GetDispatchTime(void);
	System::Byte __fastcall GetModemStatusPrim(System::Byte ClearMask);
	unsigned __fastcall GetTriggerHandle(void);
	void __fastcall MapEventsToMS(int Events);
	int __fastcall PeekBlockPrim(char * Block, unsigned Offset, unsigned Len, unsigned &NewTail);
	int __fastcall PeekCharPrim(char &C, unsigned Count);
	void __fastcall RefreshStatus(void);
	void __fastcall ResetStatusHits(void);
	void __fastcall ResetDataTriggers(void);
	bool __fastcall SendNotify(unsigned Msg, unsigned Trigger, unsigned Data);
	int __fastcall SetCommStateFix(_DCB &DCB);
	virtual void __fastcall StartDispatcher(void) = 0 ;
	virtual void __fastcall StopDispatcher(void) = 0 ;
	void __fastcall ThreadGone(System::TObject* Sender);
	void __fastcall ThreadStart(System::TObject* Sender);
	void __fastcall WaitTxSent(void);
	virtual unsigned __fastcall OutBufUsed(void) = 0 ;
	virtual unsigned __fastcall InQueueUsed(void);
	
public:
	Oomisc::TDataPointerArray DataPointers;
	System::UnicodeString DeviceName;
	int LastWinError;
	__property bool Active = {read=DispActive, nodefault};
	__property bool Logging = {read=DLoggingOn, nodefault};
	void __fastcall AddDispatchEntry(Oomisc::TDispatchType DT, Oomisc::TDispatchSubType DST, unsigned Data, void * Buffer, unsigned BufferLen);
	void __fastcall AddStringToLog(System::AnsiString S);
	__property int ComHandle = {read=CidEx, nodefault};
	virtual int __fastcall OpenCom(System::WideChar * ComName, unsigned InQueue, unsigned OutQueue) = 0 ;
	virtual int __fastcall CloseCom(void) = 0 ;
	virtual bool __fastcall CheckPort(System::WideChar * ComName) = 0 ;
	__property unsigned DispatcherWindow = {read=fDispatcherWindow, nodefault};
	__property TDispThread* DispThread = {read=fDispThread};
	__property bool EventBusy = {read=fEventBusy, write=fEventBusy, nodefault};
	__property int Handle = {read=fHandle, nodefault};
	__property System::TObject* Owner = {read=fOwner};
	__fastcall TApdBaseDispatcher(System::TObject* Owner);
	__fastcall virtual ~TApdBaseDispatcher(void);
	void __fastcall AbortDispatchLogging(void);
	void __fastcall AbortTracing(void);
	int __fastcall AddDataTrigger(char * Data, bool IgnoreCase);
	int __fastcall AddDataTriggerLen(char * Data, bool IgnoreCase, unsigned Len);
	int __fastcall AddStatusTrigger(unsigned SType);
	int __fastcall AddTimerTrigger(void);
	void __fastcall AddTraceEntry(char CurEntry, char CurCh);
	int __fastcall AppendDispatchLog(System::UnicodeString FName, bool InHex, bool AllHex);
	int __fastcall AppendTrace(System::UnicodeString FName, bool InHex, bool AllHEx);
	void __fastcall BufferSizes(unsigned &InSize, unsigned &OutSize);
	int __fastcall ChangeBaud(int NewBaud);
	void __fastcall ChangeLengthTrigger(unsigned Length);
	bool __fastcall CheckCTS(void);
	bool __fastcall CheckDCD(void);
	bool __fastcall CheckDeltaCTS(void);
	bool __fastcall CheckDeltaDSR(void);
	bool __fastcall CheckDeltaRI(void);
	bool __fastcall CheckDeltaDCD(void);
	bool __fastcall CheckDSR(void);
	bool __fastcall CheckLineBreak(void);
	bool __fastcall CheckRI(void);
	unsigned __fastcall ClassifyStatusTrigger(unsigned TriggerHandle);
	void __fastcall ClearDispatchLogging(void);
	__classmethod void __fastcall ClearSaveBuffers(Oomisc::TTriggerSave &Save);
	int __fastcall ClearTracing(void);
	void __fastcall DeregisterWndTriggerHandler(HWND HW);
	void __fastcall DeregisterProcTriggerHandler(Oomisc::TApdNotifyProc NP);
	void __fastcall DeregisterEventTriggerHandler(Oomisc::TApdNotifyEvent NP);
	void __fastcall DonePort(void);
	int __fastcall DumpDispatchLog(System::UnicodeString FName, bool InHex, bool AllHex);
	int __fastcall DumpTrace(System::UnicodeString FName, bool InHex, bool AllHex);
	int __fastcall ExtendTimer(unsigned TriggerHandle, int Ticks);
	int __fastcall FlushInBuffer(void);
	int __fastcall FlushOutBuffer(void);
	bool __fastcall CharReady(void);
	System::Word __fastcall GetBaseAddress(void);
	int __fastcall GetBlock(char * Block, unsigned Len);
	int __fastcall GetChar(char &C);
	int __fastcall GetDataPointer(void * &P, unsigned Index);
	int __fastcall GetFlowOptions(unsigned &HWOpts, unsigned &SWOpts, unsigned &BufferFull, unsigned &BufferResume, char &OnChar, char &OffChar);
	void __fastcall GetLine(int &Baud, System::Word &Parity, Oomisc::TDatabits &DataBits, Oomisc::TStopbits &StopBits);
	int __fastcall GetLineError(void);
	System::Byte __fastcall GetModemStatus(void);
	int __fastcall HWFlowOptions(unsigned BufferFull, unsigned BufferResume, unsigned Options);
	int __fastcall HWFlowState(void);
	unsigned __fastcall InBuffUsed(void);
	unsigned __fastcall InBuffFree(void);
	void __fastcall InitDispatchLogging(unsigned QueueSize);
	int __fastcall InitPort(System::WideChar * AComName, int Baud, unsigned Parity, Oomisc::TDatabits DataBits, Oomisc::TStopbits StopBits, unsigned InSize, unsigned OutSize, unsigned FlowOpts);
	int __fastcall InitSocket(unsigned InSize, unsigned OutSize);
	int __fastcall InitTracing(unsigned NumEntries);
	bool __fastcall OptionsAreOn(unsigned Options);
	void __fastcall OptionsOn(unsigned Options);
	void __fastcall OptionsOff(unsigned Options);
	unsigned __fastcall OutBuffUsed(void);
	unsigned __fastcall OutBuffFree(void);
	int __fastcall PeekBlock(char * Block, unsigned Len);
	int __fastcall PeekChar(char &C, unsigned Count);
	virtual int __fastcall ProcessCommunications(void) = 0 ;
	int __fastcall PutBlock(const void *Block, unsigned Len);
	int __fastcall PutChar(char C);
	int __fastcall PutString(System::AnsiString S);
	void __fastcall RegisterWndTriggerHandler(HWND HW);
	void __fastcall RegisterProcTriggerHandler(Oomisc::TApdNotifyProc NP);
	void __fastcall RegisterSyncEventTriggerHandler(Oomisc::TApdNotifyEvent NP);
	void __fastcall RegisterEventTriggerHandler(Oomisc::TApdNotifyEvent NP);
	void __fastcall RemoveAllTriggers(void);
	int __fastcall RemoveTrigger(unsigned TriggerHandle);
	void __fastcall RestoreTriggers(Oomisc::TTriggerSave &Save);
	void __fastcall SaveTriggers(Oomisc::TTriggerSave &Save);
	void __fastcall SetBaseAddress(System::Word NewBaseAddress);
	void __fastcall SendBreak(unsigned Ticks, bool Yield);
	void __fastcall SetBreak(bool BreakOn);
	virtual void __fastcall SetThreadBoost(System::Byte Boost);
	int __fastcall SetDataPointer(void * P, unsigned Index);
	int __fastcall SetDtr(bool OnOff);
	void __fastcall SetEventBusy(bool &WasOn, bool SetOn);
	void __fastcall SetRS485Mode(bool OnOff);
	int __fastcall SetRts(bool OnOff);
	int __fastcall SetLine(int Baud, unsigned Parity, Oomisc::TDatabits DataBits, Oomisc::TStopbits StopBits);
	int __fastcall SetModem(bool DTR, bool RTS);
	int __fastcall SetStatusTrigger(unsigned TriggerHandle, unsigned Value, bool Activate);
	int __fastcall SetTimerTrigger(unsigned TriggerHandle, int Ticks, bool Activate);
	int __fastcall SetCommBuffers(int InSize, int OutSize);
	void __fastcall StartDispatchLogging(void);
	void __fastcall StartTracing(void);
	void __fastcall StopDispatchLogging(void);
	void __fastcall StopTracing(void);
	int __fastcall SWFlowChars(char OnChar, char OffChar);
	int __fastcall SWFlowDisable(void);
	int __fastcall SWFlowEnable(unsigned BufferFull, unsigned BufferResume, unsigned Options);
	int __fastcall SWFlowState(void);
	int __fastcall TimerTicksRemaining(unsigned TriggerHandle, int &TicksRemaining);
	virtual void __fastcall UpdateHandlerFlags(TApHandlerFlagUpdate FlagUpdate);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 FirstTriggerCounter = System::Int8(0x1);
static const System::Word MaxTriggerHandle = System::Word(0x1000);
static const System::Int8 StatusTypeMask = System::Int8(0x7);
static const System::Word ThreadStartWait = System::Word(0xbb8);
static const System::Word ModemEvent = System::Word(0x2138);
static const System::Byte LineEvent = System::Byte(0xc0);
static const System::Word DefEventMask = System::Word(0x21f9);
extern DELPHI_PACKAGE System::Classes::TList* PortList;
extern DELPHI_PACKAGE void * __fastcall GetTComRecPtr(int Cid, TApdDispatcherClass DeviceLayerClass);
extern DELPHI_PACKAGE System::Byte __fastcall PortIn(System::Word Address);
extern DELPHI_PACKAGE void __fastcall LockPortList(void);
extern DELPHI_PACKAGE void __fastcall UnlockPortList(void);
}	/* namespace Awuser */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWUSER)
using namespace Awuser;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwuserHPP
