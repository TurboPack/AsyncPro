// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdSocket.pas' rev: 32.00 (Windows)

#ifndef AdsocketHPP
#define AdsocketHPP

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
#include <Vcl.Forms.hpp>
#include <OoMisc.hpp>
#include <AdWUtil.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adsocket
{
//-- forward type declarations -----------------------------------------------
struct TCMAPDSocketMessage;
class DELPHICLASS EApdSocketException;
class DELPHICLASS TApdSocket;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TCMAPDSocketMessage
{
public:
	unsigned Msg;
	int Socket;
	System::Word SelectEvent;
	System::Word SelectError;
	int Result;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION EApdSocketException : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	int ErrorCode;
	__fastcall EApdSocketException(int ErrCode, System::WideChar * Dummy);
	__fastcall EApdSocketException(int ErrCode, int Dummy1, int Dummy2);
public:
	/* Exception.Create */ inline __fastcall EApdSocketException(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EApdSocketException(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EApdSocketException(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EApdSocketException(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EApdSocketException(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EApdSocketException(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EApdSocketException(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EApdSocketException(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EApdSocketException(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EApdSocketException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EApdSocketException(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EApdSocketException(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EApdSocketException(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TWsMode : unsigned char { wsClient, wsServer };

typedef void __fastcall (__closure *TWsNotifyEvent)(System::TObject* Sender, int Socket);

typedef void __fastcall (__closure *TWsSocketErrorEvent)(System::TObject* Sender, int Socket, int ErrCode);

class PASCALIMPLEMENTATION TApdSocket : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
protected:
	HWND FHandle;
	TWsNotifyEvent FOnWsAccept;
	TWsNotifyEvent FOnWsConnect;
	TWsNotifyEvent FOnWsDisconnect;
	TWsSocketErrorEvent FOnWsError;
	TWsNotifyEvent FOnWsRead;
	TWsNotifyEvent FOnWsWrite;
	bool asDllLoaded;
	int asStartErrorCode;
	Adwutil::TwsaData asWSData;
	System::UnicodeString __fastcall GetDescription(void);
	HWND __fastcall GetHandle(void);
	int __fastcall GetLastError(void);
	System::UnicodeString __fastcall GetLocalHost(void);
	System::UnicodeString __fastcall GetLocalAddress(void);
	System::UnicodeString __fastcall GetSystemStatus(void);
	MESSAGE void __fastcall CMAPDSocketMessage(TCMAPDSocketMessage &Message);
	void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	DYNAMIC void __fastcall ShowErrorMessage(int Err);
	virtual void __fastcall DoAccept(int Socket);
	virtual void __fastcall DoConnect(int Socket);
	virtual void __fastcall DoDisconnect(int Socket);
	virtual void __fastcall DoError(int Socket, int ErrCode);
	virtual void __fastcall DoRead(int Socket);
	virtual void __fastcall DoWrite(int Socket);
	
public:
	__fastcall virtual TApdSocket(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdSocket(void);
	void __fastcall CheckLoaded(void);
	virtual void __fastcall DefaultHandler(void *Message);
	int __fastcall htonl(int HostLong);
	System::Word __fastcall htons(System::Word HostShort);
	int __fastcall ntohl(int NetLong);
	System::Word __fastcall ntohs(System::Word NetShort);
	System::UnicodeString __fastcall NetAddr2String(Oomisc::TInAddr InAddr);
	Oomisc::TInAddr __fastcall String2NetAddr(const System::UnicodeString S);
	System::UnicodeString __fastcall LookupAddress(Oomisc::TInAddr InAddr);
	Oomisc::TInAddr __fastcall LookupName(const System::AnsiString Name);
	System::UnicodeString __fastcall LookupPort(System::Word Port);
	int __fastcall LookupService(const System::AnsiString Service);
	int __fastcall AcceptSocket(int Socket, Adwutil::TSockAddrIn &Address);
	int __fastcall BindSocket(int Socket, const Adwutil::TSockAddrIn &Address);
	bool __fastcall CanReadSocket(int Socket, int WaitTime);
	bool __fastcall CanWriteSocket(int Socket, int WaitTime);
	int __fastcall CloseSocket(int Socket);
	int __fastcall ConnectSocket(int Socket, const Adwutil::TSockAddrIn &Address);
	int __fastcall CreateSocket(void);
	int __fastcall ListenSocket(int Socket, int Backlog);
	int __fastcall ReadSocket(int Socket, void *Buf, int BufSize, int Flags);
	int __fastcall ShutdownSocket(int Socket, int How);
	int __fastcall SetSocketOptions(int Socket, unsigned Level, int OptName, void *OptVal, int OptLen);
	int __fastcall SetAsyncStyles(int Socket, int lEvent);
	int __fastcall WriteSocket(int Socket, void *Buf, int BufSize, int Flags);
	__property System::UnicodeString Description = {read=GetDescription};
	__property HWND Handle = {read=GetHandle, nodefault};
	__property System::Word HighVersion = {read=asWSData.wHighVersion, nodefault};
	__property int LastError = {read=GetLastError, nodefault};
	__property System::UnicodeString LocalHost = {read=GetLocalHost};
	__property System::UnicodeString LocalAddress = {read=GetLocalAddress};
	__property System::Word MaxSockets = {read=asWSData.iMaxSockets, nodefault};
	__property System::UnicodeString SystemStatus = {read=GetSystemStatus};
	__property System::Word WsVersion = {read=asWSData.wVersion, nodefault};
	__property TWsNotifyEvent OnWsAccept = {read=FOnWsAccept, write=FOnWsAccept};
	__property TWsNotifyEvent OnWsConnect = {read=FOnWsConnect, write=FOnWsConnect};
	__property TWsNotifyEvent OnWsDisconnect = {read=FOnWsDisconnect, write=FOnWsDisconnect};
	__property TWsSocketErrorEvent OnWsError = {read=FOnWsError, write=FOnWsError};
	__property TWsNotifyEvent OnWsRead = {read=FOnWsRead, write=FOnWsRead};
	__property TWsNotifyEvent OnWsWrite = {read=FOnWsWrite, write=FOnWsWrite};
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 IPStrSize = System::Int8(0xf);
static const System::Word CM_APDSOCKETMESSAGE = System::Word(0xb11);
static const System::Word CM_APDSOCKETQUIT = System::Word(0xb12);
static const System::Word ADWSBASE = System::Word(0x2328);
static const System::Word ADWSERROR = System::Word(0x2329);
static const System::Word ADWSLOADERROR = System::Word(0x232a);
static const System::Word ADWSVERSIONERROR = System::Word(0x232b);
static const System::Word ADWSNOTINIT = System::Word(0x232c);
static const System::Word ADWSINVPORT = System::Word(0x232d);
static const System::Word ADWSCANTCHANGE = System::Word(0x232e);
static const System::Word ADWSCANTRESOLVE = System::Word(0x232f);
static const System::Word ADWSREQUESTFAILED = System::Word(0x2330);
static const System::Word ADWSREJECTEDIDENTD = System::Word(0x2331);
static const System::Word ADWSREJECTEDUSERID = System::Word(0x2332);
static const System::Word ADWSUNKNOWNERROR = System::Word(0x2333);
static const System::Word ADWSSOCKSERROR = System::Word(0x2334);
static const System::Word ADWSCONNECTIONNOTALLOWED = System::Word(0x2335);
static const System::Word ADWSNETWORKUNREACHABLE = System::Word(0x2336);
static const System::Word ADWSHOSTUNREACHABLE = System::Word(0x2337);
static const System::Word ADWSREFUSED = System::Word(0x2338);
static const System::Word ADWSTTLEXPIRED = System::Word(0x2339);
static const System::Word ADWSBADCOMMAND = System::Word(0x233a);
static const System::Word ADWSBADADDRESSTYPE = System::Word(0x233b);
static const System::Word ADWSUNSUPPORTEDREPLY = System::Word(0x233c);
static const System::Word ADWSINVALIDREPLY = System::Word(0x233d);
}	/* namespace Adsocket */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSOCKET)
using namespace Adsocket;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdsocketHPP
