// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFaxCtl.pas' rev: 32.00 (Windows)

#ifndef AdfaxctlHPP
#define AdfaxctlHPP

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
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <OoMisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adfaxctl
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TMonitorThread;
class DELPHICLASS TApdFaxDriverInterface;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TMonitorThread : public System::Classes::TThread
{
	typedef System::Classes::TThread inherited;
	
public:
	TApdFaxDriverInterface* Owner;
	NativeUInt Pipe;
	_OVERLAPPED Overlapped;
	NativeUInt Semaphore;
	System::StaticArray<NativeUInt, 2> Events;
	bool ThreadCompleted;
	virtual void __fastcall Execute(void);
public:
	/* TThread.Create */ inline __fastcall TMonitorThread(void)/* overload */ : System::Classes::TThread() { }
	/* TThread.Create */ inline __fastcall TMonitorThread(bool CreateSuspended)/* overload */ : System::Classes::TThread(CreateSuspended) { }
	/* TThread.Destroy */ inline __fastcall virtual ~TMonitorThread(void) { }
	
};


class PASCALIMPLEMENTATION TApdFaxDriverInterface : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	System::UnicodeString fFileName;
	System::UnicodeString fDocName;
	System::Classes::TNotifyEvent fOnDocStart;
	System::Classes::TNotifyEvent fOnDocEnd;
	TMonitorThread* MonitorThread;
	_SECURITY_DESCRIPTOR SecDesc;
	_SECURITY_ATTRIBUTES SecAttr;
	HWND FWindowHandle;
	
protected:
	void __fastcall WndProc(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall NotifyStartDoc(void);
	virtual void __fastcall NotifyEndDoc(void);
	
public:
	__fastcall virtual TApdFaxDriverInterface(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdFaxDriverInterface(void);
	__property System::UnicodeString DocName = {read=fDocName};
	
__published:
	__property System::UnicodeString FileName = {read=fFileName, write=fFileName};
	__property System::Classes::TNotifyEvent OnDocStart = {read=fOnDocStart, write=fOnDocStart};
	__property System::Classes::TNotifyEvent OnDocEnd = {read=fOnDocEnd, write=fOnDocEnd};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adfaxctl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFAXCTL)
using namespace Adfaxctl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfaxctlHPP
