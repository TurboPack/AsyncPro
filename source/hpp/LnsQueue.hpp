// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'LnsQueue.pas' rev: 28.00 (Windows)

#ifndef LnsqueueHPP
#define LnsqueueHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.SyncObjs.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <OoMisc.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Lnsqueue
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIOBuffer;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIOBuffer : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool FInUse;
	int FDataSize;
	
public:
	__property bool InUse = {read=FInUse, write=FInUse, nodefault};
	__property int Size = {read=FDataSize, nodefault};
public:
	/* TObject.Create */ inline __fastcall TIOBuffer(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIOBuffer(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TDataBuffer;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TDataBuffer : public TIOBuffer
{
	typedef TIOBuffer inherited;
	
private:
	char *FData;
	int FDataUsed;
	int FDataRead;
	
public:
	__fastcall TDataBuffer(int size);
	__fastcall virtual ~TDataBuffer(void);
	__property char * Data = {read=FData, write=FData};
	__property int BytesUsed = {read=FDataUsed, write=FDataUsed, nodefault};
	__property int BytesRead = {read=FDataRead, write=FDataRead, nodefault};
};

#pragma pack(pop)

class DELPHICLASS TStatusBuffer;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TStatusBuffer : public TIOBuffer
{
	typedef TIOBuffer inherited;
	
private:
	unsigned FStatus;
	
public:
	__property unsigned Status = {read=FStatus, write=FStatus, nodefault};
public:
	/* TObject.Create */ inline __fastcall TStatusBuffer(void) : TIOBuffer() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TStatusBuffer(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TLogBuffer;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TLogBuffer : public TIOBuffer
{
	typedef TIOBuffer inherited;
	
private:
	Oomisc::TDispatchType FType;
	Oomisc::TDispatchSubType FSubType;
	unsigned FTime;
	unsigned FData;
	char *FBuffer;
	unsigned __fastcall GetMoreData(void);
	
public:
	__fastcall TLogBuffer(Oomisc::TDispatchType typ, Oomisc::TDispatchSubType styp, unsigned tim, unsigned data, char * bfr, int bfrLen);
	__fastcall virtual ~TLogBuffer(void);
	__property Oomisc::TDispatchType drType = {read=FType, nodefault};
	__property Oomisc::TDispatchSubType drSubType = {read=FSubType, nodefault};
	__property unsigned drTime = {read=FTime, nodefault};
	__property unsigned drData = {read=FData, nodefault};
	__property unsigned drMoreData = {read=GetMoreData, nodefault};
	__property char * drBuffer = {read=FBuffer};
};

#pragma pack(pop)

class DELPHICLASS TIOQueue;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIOQueue : public System::Classes::TList
{
	typedef System::Classes::TList inherited;
	
private:
	System::Syncobjs::TCriticalSection* FLock;
	System::Syncobjs::TEvent* FEvent;
	int FBytesQueued;
	
public:
	__fastcall TIOQueue(void);
	__fastcall virtual ~TIOQueue(void);
	virtual void __fastcall Clear(void);
	TIOBuffer* __fastcall Peek(void);
	TIOBuffer* __fastcall Pop(void);
	void __fastcall Push(TIOBuffer* item);
	System::Types::TWaitResult __fastcall WaitForBuffer(int tmo);
	__property int BytesQueued = {read=FBytesQueued, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word IO_BUFFER_SIZE = System::Word(0x100);
}	/* namespace Lnsqueue */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_LNSQUEUE)
using namespace Lnsqueue;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// LnsqueueHPP
