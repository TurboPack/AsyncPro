// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdWnPort.pas' rev: 32.00 (Windows)

#ifndef AdwnportHPP
#define AdwnportHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Windows.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <AwWnsock.hpp>
#include <AdSocket.hpp>
#include <AdWUtil.hpp>
#include <AdExcept.hpp>
#include <AdPort.hpp>
#include <AdPacket.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adwnport
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdSocksServerInfo;
class DELPHICLASS TApdCustomWinsockPort;
class DELPHICLASS TApdWinsockPort;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TApdSocksVersion : unsigned char { svNone, svSocks4, svSocks4a, svSocks5 };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdSocksServerInfo : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FAddress;
	System::UnicodeString FPassword;
	System::Word FPort;
	TApdSocksVersion FSocksVersion;
	System::UnicodeString FUserCode;
	
protected:
	void __fastcall SetAddress(System::UnicodeString v);
	void __fastcall SetPassword(System::UnicodeString v);
	void __fastcall SetPort(System::Word v);
	void __fastcall SetSocksVersion(TApdSocksVersion v);
	void __fastcall SetUserCode(System::UnicodeString v);
	
public:
	__fastcall TApdSocksServerInfo(void);
	
__published:
	__property System::UnicodeString Address = {read=FAddress, write=SetAddress};
	__property System::UnicodeString Password = {read=FPassword, write=SetPassword};
	__property System::Word Port = {read=FPort, write=SetPort, nodefault};
	__property TApdSocksVersion SocksVersion = {read=FSocksVersion, write=SetSocksVersion, default=0};
	__property System::UnicodeString UserCode = {read=FUserCode, write=SetUserCode};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TApdSocksServerInfo(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TWsAcceptEvent)(System::TObject* Sender, Oomisc::TInAddr Addr, bool &Accept);

typedef void __fastcall (__closure *TWsErrorEvent)(System::TObject* Sender, int ErrCode);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdCustomWinsockPort : public Adport::TApdCustomComPort
{
	typedef Adport::TApdCustomComPort inherited;
	
protected:
	TWsAcceptEvent FOnWsAccept;
	System::Classes::TNotifyEvent FOnWsConnect;
	System::Classes::TNotifyEvent FOnWsDisconnect;
	TWsErrorEvent FOnWsError;
	System::UnicodeString FWsAddress;
	Adsocket::TWsMode FWsMode;
	System::UnicodeString FWsPort;
	bool FWsTelnet;
	void *FSockInstance;
	void *FComWindowProc;
	System::Classes::TStringList* FWsLocalAddresses;
	int FWsLocalAddressIndex;
	TApdSocksServerInfo* FWsSocksServerInfo;
	Adpacket::TApdDataPacket* FConnectPacket;
	bool FSocksComplete;
	int FTimer;
	bool FConnectFired;
	virtual Awuser::TApdBaseDispatcher* __fastcall ActivateDeviceLayer(void);
	virtual void __fastcall DeviceLayerChanged(void);
	virtual bool __fastcall DoAccept(int Addr);
	virtual void __fastcall DoConnect(void);
	virtual void __fastcall DoDisconnect(void);
	virtual void __fastcall DoError(int ErrCode);
	void __fastcall EnumHostAddresses(void);
	virtual int __fastcall InitializePort(void);
	DYNAMIC void __fastcall PortOpen(void);
	DYNAMIC void __fastcall PortClose(void);
	virtual void __fastcall ValidateComport(void);
	virtual void __fastcall SetUseMSRShadow(bool NewUse);
	void __fastcall SetWsAddress(System::UnicodeString Value);
	void __fastcall SetWsLocalAddresses(System::Classes::TStringList* Value);
	System::Classes::TStringList* __fastcall GetWsLocalAddresses(void);
	void __fastcall SetWsLocalAddressIndex(int Value);
	void __fastcall SetWsMode(Adsocket::TWsMode Value);
	void __fastcall SetWsPort(System::UnicodeString Value);
	void __fastcall SockWndProc(Winapi::Messages::TMessage &Message);
	int __fastcall OpenSocksConnection(void);
	int __fastcall OpenSocksSocket(void);
	void __fastcall ContinueSocksNegotiation(void);
	void __fastcall ConnectToSocks4(void);
	void __fastcall ConnectToSocks4a(void);
	void __fastcall ConnectToSocks5(void);
	void __fastcall EnableSocks4Reply(void);
	void __fastcall EnableSocks5Reply(void);
	void __fastcall EnableSocks5UserNameReply(void);
	void __fastcall EnableSocks5RequestReply(void);
	void __fastcall EnableSocks5RequestEndReply(int Len);
	void __fastcall SendSocks5UserName(void);
	void __fastcall SendSocks5Request(void);
	void __fastcall Socks4Packet(System::TObject* Sender, void * Data, int Size);
	void __fastcall Socks5Packet(System::TObject* Sender, void * Data, int Size);
	void __fastcall Socks5UserNamePacket(System::TObject* Sender, void * Data, int Size);
	void __fastcall Socks5RequestPacket(System::TObject* Sender, void * Data, int Size);
	void __fastcall Socks5RequestEndPacket(System::TObject* Sender, void * Data, int Size);
	
public:
	__property System::UnicodeString WsAddress = {read=FWsAddress, write=SetWsAddress};
	__property System::Classes::TStringList* WsLocalAddresses = {read=GetWsLocalAddresses, write=SetWsLocalAddresses};
	__property int WsLocalAddressIndex = {read=FWsLocalAddressIndex, write=SetWsLocalAddressIndex, nodefault};
	__property Adsocket::TWsMode WsMode = {read=FWsMode, write=SetWsMode, default=0};
	__property System::UnicodeString WsPort = {read=FWsPort, write=SetWsPort};
	__property TApdSocksServerInfo* WsSocksServerInfo = {read=FWsSocksServerInfo, write=FWsSocksServerInfo};
	__property bool WsTelnet = {read=FWsTelnet, write=FWsTelnet, default=1};
	__property TWsAcceptEvent OnWsAccept = {read=FOnWsAccept, write=FOnWsAccept};
	__property System::Classes::TNotifyEvent OnWsConnect = {read=FOnWsConnect, write=FOnWsConnect};
	__property System::Classes::TNotifyEvent OnWsDisconnect = {read=FOnWsDisconnect, write=FOnWsDisconnect};
	__property TWsErrorEvent OnWsError = {read=FOnWsError, write=FOnWsError};
	__fastcall virtual TApdCustomWinsockPort(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomWinsockPort(void);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdWinsockPort : public TApdCustomWinsockPort
{
	typedef TApdCustomWinsockPort inherited;
	
__published:
	__property WsAddress = {default=0};
	__property WsLocalAddresses;
	__property WsLocalAddressIndex;
	__property WsMode = {default=0};
	__property WsPort = {default=0};
	__property WsSocksServerInfo;
	__property WsTelnet = {default=1};
	__property AutoOpen = {default=1};
	__property Baud = {default=19200};
	__property BufferFull = {default=0};
	__property BufferResume = {default=0};
	__property CommNotificationLevel = {default=10};
	__property ComNumber = {default=0};
	__property DataBits = {default=8};
	__property DeviceLayer = {default=0};
	__property DTR = {default=1};
	__property HWFlowOptions = {default=0};
	__property InSize = {default=4096};
	__property RS485Mode = {default=0};
	__property TraceAllHex = {default=0};
	__property Tracing = {default=0};
	__property TraceSize = {default=10000};
	__property TraceName = {default=0};
	__property TraceHex = {default=1};
	__property LogAllHex = {default=0};
	__property Logging = {default=0};
	__property LogSize = {default=10000};
	__property LogName = {default=0};
	__property LogHex = {default=1};
	__property Open = {default=0};
	__property OutSize = {default=4096};
	__property Parity = {default=0};
	__property PromptForPort = {default=1};
	__property RTS = {default=1};
	__property StopBits = {default=1};
	__property SWFlowOptions = {default=0};
	__property Tag = {default=0};
	__property TapiMode = {default=1};
	__property UseEventWord = {default=1};
	__property UseMSRShadow = {default=1};
	__property XOffChar = {default=19};
	__property XOnChar = {default=17};
	__property OnWsAccept;
	__property OnWsConnect;
	__property OnWsDisconnect;
	__property OnWsError;
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
	__property OnWaitChar;
public:
	/* TApdCustomWinsockPort.Create */ inline __fastcall virtual TApdWinsockPort(System::Classes::TComponent* AOwner) : TApdCustomWinsockPort(AOwner) { }
	/* TApdCustomWinsockPort.Destroy */ inline __fastcall virtual ~TApdWinsockPort(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const Adsocket::TWsMode adwDefWsMode = (Adsocket::TWsMode)(0);
#define adwDefWsPort L"telnet"
static const bool adwDefWsTelnet = true;
}	/* namespace Adwnport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADWNPORT)
using namespace Adwnport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdwnportHPP
