// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwWin32.pas' rev: 32.00 (Windows)

#ifndef Awwin32HPP
#define Awwin32HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <AdWUtil.hpp>
#include <AdSocket.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awwin32
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdWin32Dispatcher;
class DELPHICLASS TApdTAPI32Dispatcher;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TApdWin32Dispatcher : public Awuser::TApdBaseDispatcher
{
	typedef Awuser::TApdBaseDispatcher inherited;
	
protected:
	_OVERLAPPED ReadOL;
	_OVERLAPPED WriteOL;
	virtual int __fastcall EscapeComFunction(int Func);
	virtual int __fastcall FlushCom(int Queue);
	virtual int __fastcall GetComError(_COMSTAT &Stat);
	virtual unsigned __fastcall GetComEventMask(int EvtMask);
	virtual int __fastcall GetComState(_DCB &DCB);
	virtual int __fastcall SetComState(_DCB &DCB);
	virtual int __fastcall ReadCom(char * Buf, int Size);
	virtual int __fastcall WriteCom(char * Buf, int Size);
	virtual bool __fastcall SetupCom(int InSize, int OutSize);
	virtual void __fastcall StartDispatcher(void);
	virtual void __fastcall StopDispatcher(void);
	virtual bool __fastcall WaitComEvent(unsigned &EvtMask, Winapi::Windows::POverlapped lpOverlapped);
	virtual unsigned __fastcall OutBufUsed(void);
	
public:
	virtual int __fastcall CloseCom(void);
	virtual int __fastcall OpenCom(System::WideChar * ComName, unsigned InQueue, unsigned OutQueue);
	virtual int __fastcall ProcessCommunications(void);
	virtual bool __fastcall CheckPort(System::WideChar * ComName);
public:
	/* TApdBaseDispatcher.Create */ inline __fastcall TApdWin32Dispatcher(System::TObject* Owner) : Awuser::TApdBaseDispatcher(Owner) { }
	/* TApdBaseDispatcher.Destroy */ inline __fastcall virtual ~TApdWin32Dispatcher(void) { }
	
};


class PASCALIMPLEMENTATION TApdTAPI32Dispatcher : public TApdWin32Dispatcher
{
	typedef TApdWin32Dispatcher inherited;
	
public:
	__fastcall TApdTAPI32Dispatcher(System::TObject* Owner, int InCid);
	virtual int __fastcall OpenCom(System::WideChar * ComName, unsigned InQueue, unsigned OutQueue);
public:
	/* TApdBaseDispatcher.Destroy */ inline __fastcall virtual ~TApdTAPI32Dispatcher(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Awwin32 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWWIN32)
using namespace Awwin32;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Awwin32HPP
