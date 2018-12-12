// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwWnsock.pas' rev: 32.00 (Windows)

#ifndef AwwnsockHPP
#define AwwnsockHPP

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

namespace Awwnsock
{
//-- forward type declarations -----------------------------------------------
struct TServerClientRec;
class DELPHICLASS TWsConnection;
class DELPHICLASS TApdDeviceSocket;
class DELPHICLASS TApdWinsockDispatcher;
//-- type declarations -------------------------------------------------------
typedef TServerClientRec *PServerClientRec;

struct DECLSPEC_DRECORD TServerClientRec
{
public:
	int ServerSocket;
	int ClientSocket;
};


enum DECLSPEC_DENUM TWsConnectionState : unsigned char { wcsInit, wcsConnected };

enum DECLSPEC_DENUM TTelnetOpt : unsigned char { tnoFalse, tnoNegotiating, tnoTrue };

class PASCALIMPLEMENTATION TWsConnection : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	unsigned FSimBuf;
	int FCommSocket;
	TApdWinsockDispatcher* FDispatcher;
	TWsConnectionState FConnectionState;
	char *FInBuf;
	char *FInBufEnd;
	bool FInBufFull;
	unsigned FInSize;
	char *FInStart;
	char *FInCursor;
	char *FInEnd;
	bool FIsClient;
	bool FIsTelnet;
	char *FOutBuf;
	char *FOutBufEnd;
	bool FOutBufFull;
	unsigned FOutSize;
	char *FOutStart;
	char *FOutEnd;
	int FSocketHandle;
	TTelnetOpt FOptBinary;
	TTelnetOpt FOptSupga;
	TTelnetOpt FOptEcho;
	
protected:
	bool __fastcall GetConnected(void);
	unsigned __fastcall GetInChars(void);
	unsigned __fastcall GetOutChars(void);
	void __fastcall SetConnectionState(TWsConnectionState Value);
	
public:
	__fastcall virtual TWsConnection(System::Classes::TComponent* AOwner, unsigned InSize, unsigned OutSize);
	__fastcall virtual ~TWsConnection(void);
	char * __fastcall FindIAC(char * Start, unsigned Size);
	void __fastcall FlushInBuffer(void);
	void __fastcall FlushOutBuffer(void);
	bool __fastcall HandleCommand(char Command, char Option);
	int __fastcall ProcessCommands(char * Dest, unsigned Size);
	int __fastcall ReadBuf(void *Buf, int Size);
	void __fastcall SendDo(char Option);
	void __fastcall SendDont(char Option);
	void __fastcall SendWill(char Option);
	void __fastcall SendWont(char Option);
	void __fastcall SendTerminal(void);
	int __fastcall Shutdown(void);
	int __fastcall WriteBuf(void *Buf, int Size);
	__property int CommSocket = {read=FCommSocket, nodefault};
	__property bool Connected = {read=GetConnected, nodefault};
	__property TWsConnectionState ConnectionState = {read=FConnectionState, write=SetConnectionState, nodefault};
	__property unsigned InChars = {read=GetInChars, nodefault};
	__property unsigned InSize = {read=FInSize, nodefault};
	__property bool IsClient = {read=FIsClient, write=FIsClient, nodefault};
	__property bool IsTelnet = {read=FIsTelnet, write=FIsTelnet, nodefault};
	__property unsigned OutChars = {read=GetOutChars, nodefault};
	__property unsigned OutSize = {read=FOutSize, nodefault};
	__property int SocketHandle = {read=FSocketHandle, nodefault};
public:
	/* TComponent.Create */ inline __fastcall virtual TWsConnection(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	
};


class PASCALIMPLEMENTATION TApdDeviceSocket : public Adsocket::TApdSocket
{
	typedef Adsocket::TApdSocket inherited;
	
private:
	System::AnsiString FWsTerminal;
	_RTL_CRITICAL_SECTION SockSection;
	
protected:
	int __fastcall DoDispMessage(int Socket, unsigned Event, int LP);
	int __fastcall DoWsMessage(int Socket, unsigned Event, int LP);
	virtual void __fastcall DoAccept(int Socket);
	virtual void __fastcall DoConnect(int Socket);
	virtual void __fastcall DoDisconnect(int Socket);
	virtual void __fastcall DoError(int Socket, int ErrCode);
	virtual void __fastcall DoRead(int Socket);
	virtual void __fastcall DoWrite(int Socket);
	int __fastcall TweakSocket(int Socket);
	
public:
	__fastcall virtual TApdDeviceSocket(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdDeviceSocket(void);
	void __fastcall LockList(void);
	void __fastcall UnLockList(void);
	TWsConnection* __fastcall FindConnection(int Socket);
	__property System::AnsiString WsTerminal = {read=FWsTerminal, write=FWsTerminal};
};


class PASCALIMPLEMENTATION TApdWinsockDispatcher : public Awuser::TApdBaseDispatcher
{
	typedef Awuser::TApdBaseDispatcher inherited;
	
private:
	bool InDispatcher;
	Adwutil::TSockAddrIn WsSockAddr;
	Adwutil::TSockAddrIn WsHostAddr;
	bool WsIsClient;
	bool WsIsTelnet;
	
protected:
	virtual int __fastcall EscapeComFunction(int Func);
	virtual int __fastcall FlushCom(int Queue);
	virtual int __fastcall GetComError(_COMSTAT &Stat);
	virtual unsigned __fastcall GetComEventMask(int EvtMask);
	virtual int __fastcall GetComState(_DCB &DCB);
	virtual int __fastcall SetComState(_DCB &DCB);
	virtual void __fastcall StartDispatcher(void);
	virtual void __fastcall StopDispatcher(void);
	virtual int __fastcall ReadCom(char * Buf, int Size);
	virtual int __fastcall WriteCom(char * Buf, int Size);
	virtual bool __fastcall SetupCom(int InSize, int OutSize);
	virtual bool __fastcall WaitComEvent(unsigned &EvtMask, Winapi::Windows::POverlapped lpOverlapped);
	unsigned __fastcall Dispatcher(unsigned Msg, unsigned wParam, int lParam);
	virtual unsigned __fastcall OutBufUsed(void);
	virtual unsigned __fastcall InQueueUsed(void);
	
public:
	virtual int __fastcall CloseCom(void);
	void __fastcall InitSocketData(int LocalAddress, int Address, unsigned Port, bool IsClient, bool IsTelnet);
	virtual int __fastcall OpenCom(System::WideChar * ComName, unsigned InQueue, unsigned OutQueue);
	virtual int __fastcall ProcessCommunications(void);
	virtual bool __fastcall CheckPort(System::WideChar * ComName);
public:
	/* TApdBaseDispatcher.Create */ inline __fastcall TApdWinsockDispatcher(System::TObject* Owner) : Awuser::TApdBaseDispatcher(Owner) { }
	/* TApdBaseDispatcher.Destroy */ inline __fastcall virtual ~TApdWinsockDispatcher(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 DefAsyncStyles = System::Int8(0x3b);
#define DefWsTerminal L"vt100"
static const bool DefOptSupga = true;
static const bool DefOptEcho = true;
static const char TELNET_IAC = '\xff';
static const char TELNET_DONT = '\xfe';
static const char TELNET_DO = '\xfd';
static const char TELNET_WONT = '\xfc';
static const char TELNET_WILL = '\xfb';
static const char TELNET_SB = '\xfa';
static const char TELNET_GA = '\xf9';
static const char TELNET_EL = '\xf8';
static const char TELNET_EC = '\xf7';
static const char TELNET_AYT = '\xf6';
static const char TELNET_AO = '\xf5';
static const char TELNET_IP = '\xf4';
static const char TELNET_BRK = '\xf3';
static const char TELNET_DM = '\xf2';
static const char TELNET_NOP = '\xf1';
static const char TELNET_SE = '\xf0';
static const char TELNET_EOR = '\xef';
static const char TELNET_ABORT = '\xee';
static const char TELNET_SUSP = '\xed';
static const char TELNET_EOF = '\xec';
static const System::WideChar TELNET_NULL = (System::WideChar)(0x0);
static const System::WideChar TELNET_LF = (System::WideChar)(0xa);
static const System::WideChar TELNET_CR = (System::WideChar)(0xd);
static const System::WideChar TELNETOPT_BINARY = (System::WideChar)(0x0);
static const System::WideChar TELNETOPT_ECHO = (System::WideChar)(0x1);
static const System::WideChar TELNETOPT_SUPGA = (System::WideChar)(0x3);
static const System::WideChar TELNETOPT_TERM = (System::WideChar)(0x18);
static const System::WideChar TELNETOPT_SPEED = (System::WideChar)(0x20);
extern DELPHI_PACKAGE TApdDeviceSocket* ApdSocket;
extern DELPHI_PACKAGE void __fastcall DeactivateAwWnSock(void);
}	/* namespace Awwnsock */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWWNSOCK)
using namespace Awwnsock;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwwnsockHPP
