// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'LNSWin32.pas' rev: 32.00 (Windows)

#ifndef Lnswin32HPP
#define Lnswin32HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <AwUser.hpp>
#include <System.SysUtils.hpp>
#include <OoMisc.hpp>
#include <LnsQueue.hpp>
#include <System.SyncObjs.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Lnswin32
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdWin32Thread;
class DELPHICLASS TReadThread;
class DELPHICLASS TWriteThread;
class DELPHICLASS TStatusThread;
class DELPHICLASS TApdWin32Dispatcher;
class DELPHICLASS TApdTAPI32Dispatcher;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TApdWin32Thread : public Awuser::TApdDispatcherThread
{
	typedef Awuser::TApdDispatcherThread inherited;
	
private:
	NativeUInt __fastcall GetComHandle(void);
	bool __fastcall GetDLoggingOn(void);
	NativeUInt __fastcall GetGeneralEvent(void);
	bool __fastcall GetKillThreads(void);
	Lnsqueue::TIOQueue* __fastcall GetQueue(void);
	System::Syncobjs::TEvent* __fastcall GetSerialEvent(void);
	void __fastcall SetKillThreads(bool value);
	void __fastcall ThreadGone(System::TObject* Sender);
	void __fastcall ThreadStart(System::TObject* Sender);
	
protected:
	void __fastcall AddDispatchEntry(Oomisc::TDispatchType DT, Oomisc::TDispatchSubType DST, unsigned Data, void * Buffer, unsigned BufferLen);
	virtual int __fastcall WaitForOverlapped(Winapi::Windows::POverlapped ovl);
	__property NativeUInt ComHandle = {read=GetComHandle, nodefault};
	__property bool DLoggingOn = {read=GetDLoggingOn, nodefault};
	__property NativeUInt GeneralEvent = {read=GetGeneralEvent, nodefault};
	__property bool KillThreads = {read=GetKillThreads, write=SetKillThreads, nodefault};
	__property Lnsqueue::TIOQueue* QueueProp = {read=GetQueue};
	__property System::Syncobjs::TEvent* SerialEvent = {read=GetSerialEvent};
public:
	/* TApdDispatcherThread.Create */ inline __fastcall TApdWin32Thread(Awuser::TApdBaseDispatcher* Disp) : Awuser::TApdDispatcherThread(Disp) { }
	
public:
	/* TThread.Destroy */ inline __fastcall virtual ~TApdWin32Thread(void) { }
	
};


class PASCALIMPLEMENTATION TReadThread : public TApdWin32Thread
{
	typedef TApdWin32Thread inherited;
	
protected:
	virtual void __fastcall Execute(void);
	int __fastcall ReadSerial(char * Buf, int Size, Winapi::Windows::POverlapped ovl);
public:
	/* TApdDispatcherThread.Create */ inline __fastcall TReadThread(Awuser::TApdBaseDispatcher* Disp) : TApdWin32Thread(Disp) { }
	
public:
	/* TThread.Destroy */ inline __fastcall virtual ~TReadThread(void) { }
	
};


class PASCALIMPLEMENTATION TWriteThread : public TApdWin32Thread
{
	typedef TApdWin32Thread inherited;
	
private:
	NativeUInt __fastcall GetOutFlushEvent(void);
	NativeUInt __fastcall GetOutputEvent(void);
	
protected:
	bool __fastcall DataInBuffer(void);
	virtual void __fastcall Execute(void);
	virtual int __fastcall WaitForOverlapped(Winapi::Windows::POverlapped ovl);
	int __fastcall WriteSerial(Winapi::Windows::POverlapped ovl);
	__property NativeUInt OutFlushEvent = {read=GetOutFlushEvent, nodefault};
	__property NativeUInt OutputEvent = {read=GetOutputEvent, nodefault};
public:
	/* TApdDispatcherThread.Create */ inline __fastcall TWriteThread(Awuser::TApdBaseDispatcher* Disp) : TApdWin32Thread(Disp) { }
	
public:
	/* TThread.Destroy */ inline __fastcall virtual ~TWriteThread(void) { }
	
};


class PASCALIMPLEMENTATION TStatusThread : public TApdWin32Thread
{
	typedef TApdWin32Thread inherited;
	
private:
	unsigned LastMask;
	
protected:
	virtual void __fastcall Execute(void);
	int __fastcall WaitSerialEvent(unsigned &EvtMask, Winapi::Windows::POverlapped ovl);
public:
	/* TApdDispatcherThread.Create */ inline __fastcall TStatusThread(Awuser::TApdBaseDispatcher* Disp) : TApdWin32Thread(Disp) { }
	
public:
	/* TThread.Destroy */ inline __fastcall virtual ~TStatusThread(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdWin32Dispatcher : public Awuser::TApdBaseDispatcher
{
	typedef Awuser::TApdBaseDispatcher inherited;
	
private:
	System::Syncobjs::TEvent* FSerialEvent;
	
protected:
	virtual int __fastcall EscapeComFunction(int Func);
	virtual int __fastcall FlushCom(int QueueProp);
	virtual int __fastcall GetComError(_COMSTAT &Stat);
	virtual unsigned __fastcall GetComEventMask(int EvtMask);
	virtual int __fastcall GetComState(_DCB &DCB);
	virtual unsigned __fastcall InQueueUsed(void);
	virtual unsigned __fastcall OutBufUsed(void);
	virtual int __fastcall ReadCom(char * Buf, int Size);
	virtual int __fastcall SetComState(_DCB &DCB);
	virtual bool __fastcall SetupCom(int InSize, int OutSize);
	virtual void __fastcall StartDispatcher(void);
	virtual void __fastcall StopDispatcher(void);
	virtual bool __fastcall WaitComEvent(unsigned &EvtMask, Winapi::Windows::POverlapped lpOverlapped);
	virtual int __fastcall WriteCom(char * Buf, int Size);
	
public:
	__fastcall TApdWin32Dispatcher(System::TObject* Owner);
	__fastcall virtual ~TApdWin32Dispatcher(void);
	virtual int __fastcall CloseCom(void);
	virtual int __fastcall OpenCom(System::WideChar * ComName, unsigned InQueue, unsigned OutQueue);
	virtual int __fastcall ProcessCommunications(void);
	virtual bool __fastcall CheckPort(System::WideChar * ComName);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdTAPI32Dispatcher : public TApdWin32Dispatcher
{
	typedef TApdWin32Dispatcher inherited;
	
public:
	__fastcall TApdTAPI32Dispatcher(System::TObject* Owner, int InCid);
	virtual int __fastcall OpenCom(System::WideChar * ComName, unsigned InQueue, unsigned OutQueue);
public:
	/* TApdWin32Dispatcher.Destroy */ inline __fastcall virtual ~TApdTAPI32Dispatcher(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Lnswin32 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_LNSWIN32)
using namespace Lnswin32;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Lnswin32HPP
