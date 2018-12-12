// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdRas.pas' rev: 32.00 (Windows)

#ifndef AdrasHPP
#define AdrasHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Dialogs.hpp>
#include <AdRasUtl.hpp>
#include <OoMisc.hpp>
#include <AdExcept.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adras
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomRasDialer;
class DELPHICLASS TApdAbstractRasStatus;
class DELPHICLASS TApdRasDialer;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TApdRasDialMode : unsigned char { dmSync, dmAsync };

enum DECLSPEC_DENUM TApdRasSpeakerMode : unsigned char { smDefault, smSpeakerOn, smSpeakerOff };

enum DECLSPEC_DENUM TApdRasCompressionMode : unsigned char { cmDefault, cmCompressionOn, cmCompressionOff };

enum DECLSPEC_DENUM TApdRasDialOption : unsigned char { doPrefixSuffix, doPausedStates, doDisableConnectedUI, doDisableReconnectUI, doNoUser, doPauseOnScript };

typedef System::Set<TApdRasDialOption, TApdRasDialOption::doPrefixSuffix, TApdRasDialOption::doPauseOnScript> TApdRasDialOptions;

typedef void __fastcall (__closure *TApdRasStatusEvent)(System::TObject* Sender, int Status);

typedef void __fastcall (__closure *TApdRasErrorEvent)(System::TObject* Sender, int Error);

class PASCALIMPLEMENTATION TApdCustomRasDialer : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	HWND DialEventHandle;
	System::Word DialEventMsg;
	Adrasutl::TRasDialExtensions DialExtensions;
	Adrasutl::TRasDialParams EntryDialParams;
	Adrasutl::TRasDialDlgInfo DialDlgInfo;
	Adrasutl::TRasMonitorDlgInfo MonitorDlgInfo;
	Adrasutl::TRasPhonebookDlgInfo PhonebookDlgInfo;
	Vcl::Extctrls::TTimer* DisconnectTimer;
	TApdRasDialOptions FDialOptions;
	TApdRasDialMode FDialMode;
	TApdRasSpeakerMode FSpeakerMode;
	TApdRasCompressionMode FCompressionMode;
	System::UnicodeString FPhonebook;
	System::UnicodeString FEntryName;
	bool FHangupOnDestroy;
	System::UnicodeString FPhoneNumber;
	System::UnicodeString FCallBackNumber;
	System::UnicodeString FUserName;
	System::UnicodeString FPassword;
	System::UnicodeString FDomain;
	NativeUInt FConnection;
	TApdAbstractRasStatus* FStatusDisplay;
	unsigned FPlatformID;
	System::Classes::TNotifyEvent FOnConnected;
	TApdRasStatusEvent FOnDialStatus;
	TApdRasErrorEvent FOnDialError;
	System::Classes::TNotifyEvent FOnDisconnected;
	Adrasutl::PRasDialExtensions __fastcall AssembleDialExtensions(void);
	Adrasutl::PRasDialParams __fastcall AssembleDialParams(void);
	void __fastcall DialEventWindowProc(Winapi::Messages::TMessage &Msg);
	void __fastcall DoOnDialError(int Error);
	void __fastcall DoOnDialStatus(int Status);
	void __fastcall DoOnConnected(void);
	void __fastcall DoOnDisconnected(void);
	void __fastcall DoDisconnectTimer(System::TObject* Sender);
	NativeUInt __fastcall GetConnection(void);
	int __fastcall GetConnectState(void);
	System::UnicodeString __fastcall GetDeviceName(void);
	System::UnicodeString __fastcall GetDeviceType(void);
	int __fastcall GetFullConnectStatus(Adrasutl::PRasConnStatus PRCS);
	bool __fastcall GetIsRasAvailable(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetEntryName(System::UnicodeString Value);
	__property System::UnicodeString CallBackNumber = {read=FCallBackNumber, write=FCallBackNumber};
	__property TApdRasCompressionMode CompressionMode = {read=FCompressionMode, write=FCompressionMode, nodefault};
	__property TApdRasDialMode DialMode = {read=FDialMode, write=FDialMode, nodefault};
	__property TApdRasDialOptions DialOptions = {read=FDialOptions, write=FDialOptions, nodefault};
	__property System::UnicodeString Domain = {read=FDomain, write=FDomain};
	__property System::UnicodeString EntryName = {read=FEntryName, write=SetEntryName};
	__property bool HangupOnDestroy = {read=FHangupOnDestroy, write=FHangupOnDestroy, nodefault};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__property System::UnicodeString Phonebook = {read=FPhonebook, write=FPhonebook};
	__property System::UnicodeString PhoneNumber = {read=FPhoneNumber, write=FPhoneNumber};
	__property TApdRasSpeakerMode SpeakerMode = {read=FSpeakerMode, write=FSpeakerMode, nodefault};
	__property TApdAbstractRasStatus* StatusDisplay = {read=FStatusDisplay, write=FStatusDisplay};
	__property System::UnicodeString UserName = {read=FUserName, write=FUserName};
	__property System::Classes::TNotifyEvent OnConnected = {read=FOnConnected, write=FOnConnected};
	__property TApdRasStatusEvent OnDialStatus = {read=FOnDialStatus, write=FOnDialStatus};
	__property TApdRasErrorEvent OnDialError = {read=FOnDialError, write=FOnDialError};
	__property System::Classes::TNotifyEvent OnDisconnected = {read=FOnDisconnected, write=FOnDisconnected};
	
public:
	__property NativeUInt Connection = {read=GetConnection, nodefault};
	__property int ConnectState = {read=GetConnectState, nodefault};
	__property System::UnicodeString DeviceName = {read=GetDeviceName};
	__property System::UnicodeString DeviceType = {read=GetDeviceType};
	__property unsigned PlatformID = {read=FPlatformID, nodefault};
	__property bool IsRasAvailable = {read=GetIsRasAvailable, nodefault};
	__fastcall virtual TApdCustomRasDialer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomRasDialer(void);
	int __fastcall AddPhonebookEntry(System::UnicodeString PBEntryName, const Oomisc::TRasEntry &RasEntry, const Oomisc::TTapiConfigRec &TapiConfigRec);
	int __fastcall CreatePhonebookEntry(void);
	int __fastcall DeletePhonebookEntry(void);
	int __fastcall Dial(void);
	int __fastcall DialDlg(void);
	int __fastcall EditPhonebookEntry(void);
	int __fastcall ClearConnectionStatistics(void);
	int __fastcall GetConnectionStatistics(Oomisc::TRasStatistics &Statistics);
	System::UnicodeString __fastcall GetErrorText(int Error);
	int __fastcall GetPhonebookEntry(System::UnicodeString PBEntryName, Oomisc::TRasEntry &RasEntry, Oomisc::TTapiConfigRec &TapiConfigRec);
	System::UnicodeString __fastcall GetStatusText(int Status);
	void __fastcall Hangup(void);
	int __fastcall ListConnections(System::Classes::TStrings* List);
	int __fastcall ListEntries(System::Classes::TStrings* List);
	int __fastcall MonitorDlg(void);
	int __fastcall PhonebookDlg(void);
	int __fastcall GetDialParameters(void);
	int __fastcall SetDialParameters(void);
	int __fastcall ValidateEntryName(System::UnicodeString EntryName);
};


class PASCALIMPLEMENTATION TApdAbstractRasStatus : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	bool FCtl3D;
	Vcl::Forms::TForm* FDisplay;
	Vcl::Forms::TPosition FPosition;
	TApdCustomRasDialer* FRasDialer;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetCtl3D(bool Value);
	void __fastcall SetPosition(Vcl::Forms::TPosition Value);
	
public:
	__property Vcl::Forms::TForm* Display = {read=FDisplay, write=FDisplay};
	__fastcall virtual TApdAbstractRasStatus(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdAbstractRasStatus(void);
	DYNAMIC void __fastcall CreateDisplay(const System::UnicodeString EntryName) = 0 ;
	DYNAMIC void __fastcall DestroyDisplay(void) = 0 ;
	virtual void __fastcall UpdateDisplay(const System::UnicodeString StatusMsg) = 0 ;
	
__published:
	__property bool Ctl3D = {read=FCtl3D, write=SetCtl3D, nodefault};
	__property Vcl::Forms::TPosition Position = {read=FPosition, write=SetPosition, nodefault};
	__property TApdCustomRasDialer* RasDialer = {read=FRasDialer, write=FRasDialer};
};


class PASCALIMPLEMENTATION TApdRasDialer : public TApdCustomRasDialer
{
	typedef TApdCustomRasDialer inherited;
	
__published:
	__property CallBackNumber = {default=0};
	__property CompressionMode;
	__property DialMode;
	__property DialOptions;
	__property Domain = {default=0};
	__property EntryName = {default=0};
	__property HangupOnDestroy;
	__property OnConnected;
	__property OnDialStatus;
	__property OnDialError;
	__property OnDisconnected;
	__property Password = {default=0};
	__property Phonebook = {default=0};
	__property PhoneNumber = {default=0};
	__property SpeakerMode;
	__property StatusDisplay;
	__property UserName = {default=0};
public:
	/* TApdCustomRasDialer.Create */ inline __fastcall virtual TApdRasDialer(System::Classes::TComponent* AOwner) : TApdCustomRasDialer(AOwner) { }
	/* TApdCustomRasDialer.Destroy */ inline __fastcall virtual ~TApdRasDialer(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adras */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADRAS)
using namespace Adras;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdrasHPP
