// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdVoIP.pas' rev: 32.00 (Windows)

#ifndef AdvoipHPP
#define AdvoipHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.OleServer.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Controls.hpp>
#include <System.Win.ComObj.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Forms.hpp>
#include <OoMisc.hpp>
#include <AdExcept.hpp>
#include <AdITapi3.hpp>

//-- user supplied -----------------------------------------------------------

namespace Advoip
{
//-- forward type declarations -----------------------------------------------
struct TApdVoIPCallInfo;
class DELPHICLASS TApdTerminals;
class DELPHICLASS TApdTapiEventSink;
class DELPHICLASS TApdVoIPTerminal;
class DELPHICLASS TApdVoIPLog;
class DELPHICLASS TApdCustomVoIP;
class DELPHICLASS TApdVoIP;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TApdTerminalDeviceClass : unsigned char { dcHandsetTerminal, dcHeadsetTerminal, dcMediaStreamTerminal, dcMicrophoneTerminal, dcSpeakerPhoneTerminal, dcSpeakersTerminal, dcVideoInputTerminal, dcVideoWindowTerminal };

enum DECLSPEC_DENUM TApdTerminalMediaType : unsigned char { mtAudio, mtVideo, mtDataModem, mtG3_Fax };

enum DECLSPEC_DENUM TApdMediaDirection : unsigned char { mdCapture, mdRender, mdBiDirectional };

enum DECLSPEC_DENUM TApdTerminalType : unsigned char { ttStatic, ttDynamic };

enum DECLSPEC_DENUM TApdTerminalState : unsigned char { tsInUse, tsNotInUse };

enum DECLSPEC_DENUM TApdDisconnectCode : unsigned char { dcNormal, dcNoAnswer, dcRejected };

enum DECLSPEC_DENUM TApdQOSServiceLevel : unsigned char { qsBestEffort, qsIfAvailable, qsNeeded };

enum DECLSPEC_DENUM TApdFinishMode : unsigned char { fmAsTransfer, fmAsConference };

enum DECLSPEC_DENUM TApdCallState : unsigned char { csIdle, csInProgress, csConnected, csDisconnected, csOffering, csHold, csQueued };

enum DECLSPEC_DENUM TApdAddressType : unsigned char { atPhoneNumber, atSDP, atEmailName, atDomainName, atIPAddress };

enum DECLSPEC_DENUM TApdCallPriviledge : unsigned char { cpOwner, cpMonitor };

enum DECLSPEC_DENUM TApdCallInfoLong : unsigned char { cilMediaTypesAvailable, cilBearerMode, cilCallerIDAddressType, cilCalledIDAddressType, cilConnectedIDAddressType, cilRedirectionIDAddressType, cilRedirectingIDAddresstype, cilOrigin, cilReason, cilAppSpecific, cilCallParamsFlags, cilCallTreatment, cilMinRate, cilMaxRate, cilCountryCode, cilCallID, cilRelatedCallID, cilCompletionID, cilNumberOfOwners, cilNumberOfMonitors, cilTrunk, cilRate };

enum DECLSPEC_DENUM TApdCallInfoType : unsigned char { cisCallerIDName, cisCallerIDNumber, cisCalledIDName, cisCalledIDNumber, cisConnectedIDName, cisConnectedIDNumber, cisRedirectionIDName, cisRedirectionIDNumber, cisRedirectingIDName, cisRedirectingIDNumber, cisCalledPartyFriendlyName, cisComment, cisDisplayableAddress, cisCallingPartyID };

enum DECLSPEC_DENUM TApdCallInfoBufferType : unsigned char { cibUserUserInfo, cibDevSpecificBuffer, cibCallDataBuffer, cibChargingInfoBuffer, cibHighLevelCompatibilityBuffer, cibLowLevelCompatibilityBuffer };

enum DECLSPEC_DENUM TApdAddressState : unsigned char { asInService, asOutOfService };

enum DECLSPEC_DENUM TApdCallHubState : unsigned char { chsActive, chsIdle };

typedef void __fastcall (__closure *TApdVoIPNotifyEvent)(TApdCustomVoIP* VoIP);

typedef void __fastcall (__closure *TApdVoIPFailEvent)(TApdCustomVoIP* VoIP, int ErrorCode);

typedef void __fastcall (__closure *TApdVoIPIncomingCallEvent)(TApdCustomVoIP* VoIP, System::UnicodeString CallerAddr, bool &Accept);

typedef void __fastcall (__closure *TApdVoIPStatusEvent)(TApdCustomVoIP* VoIP, System::Word TapiEvent, System::Word Status, System::Word SubStatus);

struct DECLSPEC_DRECORD TApdVoIPCallInfo
{
public:
	bool InfoAvailable;
	System::UnicodeString CallerIDName;
	System::UnicodeString CallerIDNumber;
	System::UnicodeString CalledIDName;
	System::UnicodeString CalledIDNumber;
	System::UnicodeString ConnectedIDName;
	System::UnicodeString ConnectedIDNumber;
	System::UnicodeString CalledPartyFriendlyName;
	System::UnicodeString Comment;
	System::UnicodeString DisplayableAddress;
	System::UnicodeString CallingPartyID;
	unsigned MediaTypesAvailable;
	unsigned CallerIDAddressType;
	unsigned CalledIDAddressType;
	unsigned ConnectedIDAddressType;
	unsigned Origin;
	unsigned Reason;
	unsigned MinRate;
	unsigned MaxRate;
	unsigned Rate;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdTerminals : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	/* TCollection.Create */ inline __fastcall TApdTerminals(System::Classes::TCollectionItemClass ItemClass) : System::Classes::TCollection(ItemClass) { }
	/* TCollection.Destroy */ inline __fastcall virtual ~TApdTerminals(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdTapiEventSink : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FRefCount;
	TApdCustomVoIP* FOwner;
	bool FAnswer;
	
public:
	__fastcall TApdTapiEventSink(TApdCustomVoIP* AOwner);
	HRESULT __stdcall QueryInterface(const GUID &IID, /* out */ void *Obj);
	int __stdcall _AddRef(void);
	int __stdcall _Release(void);
	HRESULT __stdcall Event(Winapi::Activex::TOleEnum TapiEvent, const _di_IDispatch pEvent);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TApdTapiEventSink(void) { }
	
private:
	void *__ITTAPIEventNotification;	// Aditapi3::ITTAPIEventNotification 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {EDDB9426-3B91-11D1-8F30-00C04FB6809F}
	operator Aditapi3::_di_ITTAPIEventNotification()
	{
		Aditapi3::_di_ITTAPIEventNotification intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Aditapi3::ITTAPIEventNotification*(void) { return (Aditapi3::ITTAPIEventNotification*)&__ITTAPIEventNotification; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {00000000-0000-0000-C000-000000000046}
	operator System::_di_IInterface()
	{
		System::_di_IInterface intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator System::IInterface*(void) { return (System::IInterface*)&__ITTAPIEventNotification; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdVoIPTerminal : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	TApdTerminalDeviceClass FTerminalDeviceClass;
	System::UnicodeString FDeviceName;
	TApdMediaDirection FMediaDirection;
	TApdTerminalMediaType FMediaType;
	TApdTerminalType FTerminalType;
	TApdTerminalState FTerminalState;
	bool __fastcall GetDeviceInUse(void);
	
__published:
	__property TApdTerminalDeviceClass DeviceClass = {read=FTerminalDeviceClass, nodefault};
	__property bool DeviceInUse = {read=GetDeviceInUse, nodefault};
	__property System::UnicodeString DeviceName = {read=FDeviceName};
	__property TApdMediaDirection MediaDirection = {read=FMediaDirection, nodefault};
	__property TApdTerminalMediaType MediaType = {read=FMediaType, nodefault};
	__property TApdTerminalType TerminalType = {read=FTerminalType, nodefault};
	__property TApdTerminalState TerminalState = {read=FTerminalState, nodefault};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TApdVoIPTerminal(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TApdVoIPTerminal(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdVoIPLog : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FVerboseLog;
	bool FEnabled;
	System::UnicodeString FLogName;
	
public:
	void __fastcall AddLogString(bool Verbose, const System::AnsiString S);
	void __fastcall ClearLog(void);
	
__published:
	__property System::UnicodeString LogName = {read=FLogName, write=FLogName};
	__property bool VerboseLog = {read=FVerboseLog, write=FVerboseLog, nodefault};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TApdVoIPLog(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TApdVoIPLog(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdCustomVoIP : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	bool FWaitingForCall;
	bool FConnected;
	System::UnicodeString FAudioInDevice;
	System::UnicodeString FVideoInDevice;
	System::UnicodeString FCallerIDName;
	System::UnicodeString FAudioOutDevice;
	System::UnicodeString FCallerIDNumber;
	TApdTerminals* FAvailableTerminalDevices;
	TApdVoIPFailEvent FOnFail;
	TApdVoIPIncomingCallEvent FOnIncomingCall;
	TApdVoIPNotifyEvent FOnDisconnect;
	TApdVoIPNotifyEvent FOnConnect;
	TApdVoIPStatusEvent FOnStatus;
	Vcl::Controls::TWinControl* FVideoOutWindow;
	Vcl::Controls::TWinControl* FPreviewWindow;
	bool FEnablePreview;
	bool FEnableVideo;
	bool FVideoOutWindowAutoSize;
	bool FPreviewWindowAutoSize;
	TApdVoIPLog* FEventLog;
	bool FVoIPAvailable;
	System::UnicodeString FCallerDisplayName;
	System::UnicodeString FCallComment;
	System::UnicodeString FCallDisplayableAddress;
	System::UnicodeString FCallCallingPartyID;
	int FConnectTimeout;
	TApdVoIPCallInfo __fastcall GetCallInfo(void);
	void __fastcall SetPreviewWindow(Vcl::Controls::TWinControl* const Value);
	void __fastcall SetVideoOutDevice(Vcl::Controls::TWinControl* const Value);
	void __fastcall SetEnablePreview(const bool Value);
	void __fastcall SetVideoInDevice(const System::UnicodeString Value);
	void __fastcall SetAudioInDevice(const System::UnicodeString Value);
	void __fastcall SetAudioOutDevice(const System::UnicodeString Value);
	void __fastcall SetEnableVideo(const bool Value);
	void __fastcall SetVideoOutWindowAutoSize(const bool Value);
	void __fastcall SetPreviewWindowAutoSize(const bool Value);
	Aditapi3::_di_ITCallInfo __fastcall GetCallInfoInterface(void);
	
protected:
	Aditapi3::_di_ITTAPI gpTapi;
	Aditapi3::_di_ITBasicCallControl gpCall;
	Aditapi3::_di_ITAddress gpAddress;
	int gulAdvise;
	TApdTapiEventSink* gpTAPIEventNotification;
	int NotifyRegister;
	HWND FHandle;
	int FErrorCode;
	bool FTapiInitialized;
	NativeUInt FConnectTimer;
	void __fastcall DoConnectEvent(void);
	void __fastcall DoDisconnectEvent(void);
	void __fastcall DoFailEvent(void);
	void __fastcall DoIncomingCallEvent(void);
	void __fastcall DoStatusEvent(System::Word TapiEvent, System::Word Status, System::Word SubStatus);
	void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	void __fastcall ProcessTapiEvent(Winapi::Activex::TOleEnum TapiEvent, _di_IDispatch pEvent);
	bool __fastcall AddressSupportsMediaType(Aditapi3::_di_ITAddress pAddress, Winapi::Activex::TOleEnum lMediaType);
	HRESULT __fastcall AnswerTheCall(void);
	unsigned __fastcall DetermineAddressType(const System::UnicodeString Addr);
	HRESULT __fastcall DisconnectTheCall(void);
	HRESULT __fastcall EnablePreviewWindow(Aditapi3::_di_ITAddress pAddress, Aditapi3::_di_ITStream pStream);
	HRESULT __fastcall FindTerminal(System::UnicodeString DevName, Winapi::Activex::TOleEnum MediaType, Winapi::Activex::TOleEnum MediaDir, Aditapi3::_di_ITTerminal &ppTerminal);
	HRESULT __fastcall FindTheAddress(void);
	HRESULT __fastcall GetTerminal(Aditapi3::_di_ITAddress pAddress, Aditapi3::_di_ITStream pStream, Aditapi3::_di_ITTerminal &ppTerminal);
	HRESULT __fastcall GetVideoRenderTerminal(Aditapi3::_di_ITAddress pAddress, Aditapi3::_di_ITTerminal &ppTerminal);
	HRESULT __fastcall GetVideoRenderTerminalFromStream(Aditapi3::_di_ITCallMediaEvent pCallMediaEvent, Aditapi3::_di_ITTerminal &ppTerminal, bool &pfRenderStream);
	void __fastcall HostWindow(Aditapi3::_di_IVideoWindow pVideoWindow, bool IsRenderStream);
	HRESULT __fastcall InitializeTapi(void);
	bool __fastcall IsAudioCaptureStream(Aditapi3::_di_ITStream pStream);
	bool __fastcall IsAudioRenderStream(Aditapi3::_di_ITStream pStream);
	bool __fastcall IsVideoCaptureStream(Aditapi3::_di_ITStream pStream);
	bool __fastcall IsVideoRenderStream(Aditapi3::_di_ITStream pStream);
	void __fastcall LoadTerminals(void);
	bool __fastcall MakeTheCall(unsigned dwAddressType, System::WideString szAddressToCall);
	HRESULT __fastcall RegisterTapiEventInterface(void);
	void __fastcall ReleaseTheCall(void);
	HRESULT __fastcall SelectTerminalOnCall(Aditapi3::_di_ITAddress pAddress, Aditapi3::_di_ITBasicCallControl pCall);
	void __fastcall ShutDownTapi(void);
	
public:
	__fastcall virtual TApdCustomVoIP(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomVoIP(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall CancelCall(void);
	void __fastcall Connect(System::UnicodeString DestAddr);
	bool __fastcall ShowMediaSelectionDialog(void);
	__property TApdTerminals* AvailableTerminalDevices = {read=FAvailableTerminalDevices};
	__property System::UnicodeString CallComment = {read=FCallComment, write=FCallComment};
	__property System::UnicodeString CallDisplayableAddress = {read=FCallDisplayableAddress, write=FCallDisplayableAddress};
	__property System::UnicodeString CallCallingPartyID = {read=FCallCallingPartyID, write=FCallCallingPartyID};
	__property TApdVoIPCallInfo CallInfo = {read=GetCallInfo};
	__property Aditapi3::_di_ITCallInfo CallInfoInterface = {read=GetCallInfoInterface};
	__property System::UnicodeString CallerIDName = {read=FCallerIDName};
	__property System::UnicodeString CallerIDNumber = {read=FCallerIDNumber};
	__property System::UnicodeString CallerDisplayName = {read=FCallerDisplayName};
	__property bool Connected = {read=FConnected, nodefault};
	__property int ErrorCode = {read=FErrorCode, nodefault};
	__property bool VoIPAvailable = {read=FVoIPAvailable, nodefault};
	__property bool WaitingForCall = {read=FWaitingForCall, nodefault};
	__property System::UnicodeString AudioInDevice = {read=FAudioInDevice, write=SetAudioInDevice};
	__property System::UnicodeString AudioOutDevice = {read=FAudioOutDevice, write=SetAudioOutDevice};
	__property int ConnectTimeout = {read=FConnectTimeout, write=FConnectTimeout, nodefault};
	__property bool EnablePreview = {read=FEnablePreview, write=SetEnablePreview, nodefault};
	__property bool EnableVideo = {read=FEnableVideo, write=SetEnableVideo, nodefault};
	__property System::UnicodeString VideoInDevice = {read=FVideoInDevice, write=SetVideoInDevice};
	__property Vcl::Controls::TWinControl* VideoOutWindow = {read=FVideoOutWindow, write=SetVideoOutDevice};
	__property bool VideoOutWindowAutoSize = {read=FVideoOutWindowAutoSize, write=SetVideoOutWindowAutoSize, nodefault};
	__property Vcl::Controls::TWinControl* PreviewWindow = {read=FPreviewWindow, write=SetPreviewWindow};
	__property bool PreviewWindowAutoSize = {read=FPreviewWindowAutoSize, write=SetPreviewWindowAutoSize, nodefault};
	__property TApdVoIPLog* EventLog = {read=FEventLog, write=FEventLog};
	__property TApdVoIPNotifyEvent OnConnect = {read=FOnConnect, write=FOnConnect};
	__property TApdVoIPNotifyEvent OnDisconnect = {read=FOnDisconnect, write=FOnDisconnect};
	__property TApdVoIPFailEvent OnFail = {read=FOnFail, write=FOnFail};
	__property TApdVoIPIncomingCallEvent OnIncomingCall = {read=FOnIncomingCall, write=FOnIncomingCall};
	__property TApdVoIPStatusEvent OnStatus = {read=FOnStatus, write=FOnStatus};
};


class PASCALIMPLEMENTATION TApdVoIP : public TApdCustomVoIP
{
	typedef TApdCustomVoIP inherited;
	
__published:
	__property AudioInDevice = {default=0};
	__property AudioOutDevice = {default=0};
	__property ConnectTimeout;
	__property EnablePreview;
	__property EnableVideo;
	__property EventLog;
	__property PreviewWindow;
	__property PreviewWindowAutoSize;
	__property VideoInDevice = {default=0};
	__property VideoOutWindow;
	__property VideoOutWindowAutoSize;
	__property OnConnect;
	__property OnDisconnect;
	__property OnFail;
	__property OnIncomingCall;
	__property OnStatus;
public:
	/* TApdCustomVoIP.Create */ inline __fastcall virtual TApdVoIP(System::Classes::TComponent* AOwner) : TApdCustomVoIP(AOwner) { }
	/* TApdCustomVoIP.Destroy */ inline __fastcall virtual ~TApdVoIP(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Advoip */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADVOIP)
using namespace Advoip;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdvoipHPP
