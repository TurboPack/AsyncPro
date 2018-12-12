// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdITapi3.pas' rev: 32.00 (Windows)

#ifndef Aditapi3HPP
#define Aditapi3HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Win.StdVCL.hpp>
#include <System.Variants.hpp>
#include <Winapi.Windows.hpp>
#include <OoMisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Aditapi3
{
//-- forward type declarations -----------------------------------------------
__interface ITTAPI;
typedef System::DelphiInterface<ITTAPI> _di_ITTAPI;
__interface ITDispatchMapper;
typedef System::DelphiInterface<ITDispatchMapper> _di_ITDispatchMapper;
__interface ITRequest;
typedef System::DelphiInterface<ITRequest> _di_ITRequest;
__interface ITCollection;
typedef System::DelphiInterface<ITCollection> _di_ITCollection;
__interface ITCallStateEvent;
typedef System::DelphiInterface<ITCallStateEvent> _di_ITCallStateEvent;
__interface ITCallInfo;
typedef System::DelphiInterface<ITCallInfo> _di_ITCallInfo;
__interface ITAddress;
typedef System::DelphiInterface<ITAddress> _di_ITAddress;
__interface IEnumAddress;
typedef System::DelphiInterface<IEnumAddress> _di_IEnumAddress;
__interface IEnumCallHub;
typedef System::DelphiInterface<IEnumCallHub> _di_IEnumCallHub;
__interface ITCallHub;
typedef System::DelphiInterface<ITCallHub> _di_ITCallHub;
__interface IEnumCall;
typedef System::DelphiInterface<IEnumCall> _di_IEnumCall;
__interface IEnumUnknown;
typedef System::DelphiInterface<IEnumUnknown> _di_IEnumUnknown;
__interface ITBasicCallControl;
typedef System::DelphiInterface<ITBasicCallControl> _di_ITBasicCallControl;
__interface ITForwardInformation;
typedef System::DelphiInterface<ITForwardInformation> _di_ITForwardInformation;
__interface ITCallNotificationEvent;
typedef System::DelphiInterface<ITCallNotificationEvent> _di_ITCallNotificationEvent;
__interface ITTAPIEventNotification;
typedef System::DelphiInterface<ITTAPIEventNotification> _di_ITTAPIEventNotification;
__interface ITBasicAudioTerminal;
typedef System::DelphiInterface<ITBasicAudioTerminal> _di_ITBasicAudioTerminal;
__interface ITCallHubEvent;
typedef System::DelphiInterface<ITCallHubEvent> _di_ITCallHubEvent;
__interface ITAddressCapabilities;
typedef System::DelphiInterface<ITAddressCapabilities> _di_ITAddressCapabilities;
__interface IEnumBstr;
typedef System::DelphiInterface<IEnumBstr> _di_IEnumBstr;
__interface ITQOSEvent;
typedef System::DelphiInterface<ITQOSEvent> _di_ITQOSEvent;
__interface ITAddressEvent;
typedef System::DelphiInterface<ITAddressEvent> _di_ITAddressEvent;
__interface ITTerminal;
typedef System::DelphiInterface<ITTerminal> _di_ITTerminal;
__interface ITCallMediaEvent;
typedef System::DelphiInterface<ITCallMediaEvent> _di_ITCallMediaEvent;
__interface ITStream;
typedef System::DelphiInterface<ITStream> _di_ITStream;
__interface IEnumTerminal;
typedef System::DelphiInterface<IEnumTerminal> _di_IEnumTerminal;
__interface ITTAPIObjectEvent;
typedef System::DelphiInterface<ITTAPIObjectEvent> _di_ITTAPIObjectEvent;
__interface ITAddressTranslation;
typedef System::DelphiInterface<ITAddressTranslation> _di_ITAddressTranslation;
__interface ITAddressTranslationInfo;
typedef System::DelphiInterface<ITAddressTranslationInfo> _di_ITAddressTranslationInfo;
__interface IEnumLocation;
typedef System::DelphiInterface<IEnumLocation> _di_IEnumLocation;
__interface ITLocationInfo;
typedef System::DelphiInterface<ITLocationInfo> _di_ITLocationInfo;
__interface IEnumCallingCard;
typedef System::DelphiInterface<IEnumCallingCard> _di_IEnumCallingCard;
__interface ITCallingCard;
typedef System::DelphiInterface<ITCallingCard> _di_ITCallingCard;
__interface ITAgent;
typedef System::DelphiInterface<ITAgent> _di_ITAgent;
__interface IEnumAgentSession;
typedef System::DelphiInterface<IEnumAgentSession> _di_IEnumAgentSession;
__interface ITAgentSession;
typedef System::DelphiInterface<ITAgentSession> _di_ITAgentSession;
__interface ITACDGroup;
typedef System::DelphiInterface<ITACDGroup> _di_ITACDGroup;
__interface IEnumQueue;
typedef System::DelphiInterface<IEnumQueue> _di_IEnumQueue;
__interface ITQueue;
typedef System::DelphiInterface<ITQueue> _di_ITQueue;
__interface ITAgentEvent;
typedef System::DelphiInterface<ITAgentEvent> _di_ITAgentEvent;
__interface ITAgentSessionEvent;
typedef System::DelphiInterface<ITAgentSessionEvent> _di_ITAgentSessionEvent;
__interface ITACDGroupEvent;
typedef System::DelphiInterface<ITACDGroupEvent> _di_ITACDGroupEvent;
__interface ITQueueEvent;
typedef System::DelphiInterface<ITQueueEvent> _di_ITQueueEvent;
__interface ITTAPICallCenter;
typedef System::DelphiInterface<ITTAPICallCenter> _di_ITTAPICallCenter;
__interface IEnumAgentHandler;
typedef System::DelphiInterface<IEnumAgentHandler> _di_IEnumAgentHandler;
__interface ITAgentHandler;
typedef System::DelphiInterface<ITAgentHandler> _di_ITAgentHandler;
__interface IEnumACDGroup;
typedef System::DelphiInterface<IEnumACDGroup> _di_IEnumACDGroup;
__interface ITAgentHandlerEvent;
typedef System::DelphiInterface<ITAgentHandlerEvent> _di_ITAgentHandlerEvent;
__interface ITCallInfoChangeEvent;
typedef System::DelphiInterface<ITCallInfoChangeEvent> _di_ITCallInfoChangeEvent;
__interface ITRequestEvent;
typedef System::DelphiInterface<ITRequestEvent> _di_ITRequestEvent;
__interface ITMediaSupport;
typedef System::DelphiInterface<ITMediaSupport> _di_ITMediaSupport;
__interface ITTerminalSupport;
typedef System::DelphiInterface<ITTerminalSupport> _di_ITTerminalSupport;
__interface IEnumTerminalClass;
typedef System::DelphiInterface<IEnumTerminalClass> _di_IEnumTerminalClass;
__interface ITStreamControl;
typedef System::DelphiInterface<ITStreamControl> _di_ITStreamControl;
__interface IEnumStream;
typedef System::DelphiInterface<IEnumStream> _di_IEnumStream;
__interface ITSubStreamControl;
typedef System::DelphiInterface<ITSubStreamControl> _di_ITSubStreamControl;
__interface ITSubStream;
typedef System::DelphiInterface<ITSubStream> _di_ITSubStream;
__interface IEnumSubStream;
typedef System::DelphiInterface<IEnumSubStream> _di_IEnumSubStream;
__interface ITLegacyAddressMediaControl;
typedef System::DelphiInterface<ITLegacyAddressMediaControl> _di_ITLegacyAddressMediaControl;
__interface ITLegacyCallMediaControl;
typedef System::DelphiInterface<ITLegacyCallMediaControl> _di_ITLegacyCallMediaControl;
__interface ITDigitDetectionEvent;
typedef System::DelphiInterface<ITDigitDetectionEvent> _di_ITDigitDetectionEvent;
__interface ITDigitGenerationEvent;
typedef System::DelphiInterface<ITDigitGenerationEvent> _di_ITDigitGenerationEvent;
__interface ITPrivateEvent;
typedef System::DelphiInterface<ITPrivateEvent> _di_ITPrivateEvent;
__interface IReferenceClock;
typedef System::DelphiInterface<IReferenceClock> _di_IReferenceClock;
__interface IMediaFilter;
typedef System::DelphiInterface<IMediaFilter> _di_IMediaFilter;
struct TAM_Media_Type;
struct TPin_Info;
__interface IEnumMediaTypes;
typedef System::DelphiInterface<IEnumMediaTypes> _di_IEnumMediaTypes;
__interface IPin;
typedef System::DelphiInterface<IPin> _di_IPin;
__interface IEnumPins;
typedef System::DelphiInterface<IEnumPins> _di_IEnumPins;
struct TFilterInfo;
__interface IBaseFilter;
typedef System::DelphiInterface<IBaseFilter> _di_IBaseFilter;
__interface IEnumFilters;
typedef System::DelphiInterface<IEnumFilters> _di_IEnumFilters;
__interface IFilterGraph;
typedef System::DelphiInterface<IFilterGraph> _di_IFilterGraph;
__interface IGraphBuilder;
typedef System::DelphiInterface<IGraphBuilder> _di_IGraphBuilder;
__interface IFileSinkFilter;
typedef System::DelphiInterface<IFileSinkFilter> _di_IFileSinkFilter;
__interface IAMCopyCaptureFileProgress;
typedef System::DelphiInterface<IAMCopyCaptureFileProgress> _di_IAMCopyCaptureFileProgress;
__interface ICaptureGraphBuilder2;
typedef System::DelphiInterface<ICaptureGraphBuilder2> _di_ICaptureGraphBuilder2;
__interface IVideoWindow;
typedef System::DelphiInterface<IVideoWindow> _di_IVideoWindow;
__interface IMediaControl;
typedef System::DelphiInterface<IMediaControl> _di_IMediaControl;
//-- type declarations -------------------------------------------------------
typedef Winapi::Activex::TOleEnum ADDRESS_STATE;

typedef Winapi::Activex::TOleEnum CALLHUB_STATE;

typedef Winapi::Activex::TOleEnum DISCONNECT_CODE;

typedef Winapi::Activex::TOleEnum QOS_SERVICE_LEVEL;

typedef Winapi::Activex::TOleEnum FINISH_MODE;

typedef Winapi::Activex::TOleEnum CALL_STATE;

typedef Winapi::Activex::TOleEnum CALL_PRIVILEGE;

typedef Winapi::Activex::TOleEnum CALLINFO_LONG;

typedef Winapi::Activex::TOleEnum CALLINFO_STRING;

typedef Winapi::Activex::TOleEnum CALLINFO_BUFFER;

typedef Winapi::Activex::TOleEnum CALL_STATE_EVENT_CAUSE;

typedef Winapi::Activex::TOleEnum CALL_NOTIFICATION_EVENT;

typedef Winapi::Activex::TOleEnum TAPI_EVENT;

typedef Winapi::Activex::TOleEnum CALLHUB_EVENT;

typedef Winapi::Activex::TOleEnum ADDRESS_CAPABILITY;

typedef Winapi::Activex::TOleEnum ADDRESS_CAPABILITY_STRING;

typedef Winapi::Activex::TOleEnum QOS_EVENT;

typedef Winapi::Activex::TOleEnum ADDRESS_EVENT;

typedef Winapi::Activex::TOleEnum TERMINAL_STATE;

typedef Winapi::Activex::TOleEnum TERMINAL_TYPE;

typedef Winapi::Activex::TOleEnum TERMINAL_DIRECTION;

typedef Winapi::Activex::TOleEnum CALL_MEDIA_EVENT;

typedef Winapi::Activex::TOleEnum CALL_MEDIA_EVENT_CAUSE;

typedef Winapi::Activex::TOleEnum TAPIOBJECT_EVENT;

typedef Winapi::Activex::TOleEnum AGENT_SESSION_STATE;

typedef Winapi::Activex::TOleEnum AGENT_STATE;

typedef Winapi::Activex::TOleEnum AGENT_EVENT;

typedef Winapi::Activex::TOleEnum AGENT_SESSION_EVENT;

typedef Winapi::Activex::TOleEnum ACDGROUP_EVENT;

typedef Winapi::Activex::TOleEnum ACDQUEUE_EVENT;

typedef Winapi::Activex::TOleEnum AGENTHANDLER_EVENT;

typedef Winapi::Activex::TOleEnum CALLINFOCHANGE_CAUSE;

typedef _di_ITTAPI TAPI;

typedef _di_ITDispatchMapper DispatchMapper;

typedef _di_ITRequest RequestMakeCall;

typedef System::Byte *PByte1;

__interface  INTERFACE_UUID("{5EC5ACF2-9C02-11D0-8362-00AA003CCABD}") ITCollection  : public IDispatch 
{
	
public:
	System::OleVariant operator[](int Index) { return this->Item[Index]; }
	virtual HRESULT __safecall Get_Count(int &__Get_Count_result) = 0 ;
	virtual HRESULT __safecall Get_Item(int Index, System::OleVariant &__Get_Item_result) = 0 ;
	virtual HRESULT __safecall Get__NewEnum(System::_di_IInterface &__Get__NewEnum_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Count() { int __r; HRESULT __hr = Get_Count(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Count = {read=_scw_Get_Count};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Item(int Index) { System::OleVariant __r; HRESULT __hr = Get_Item(Index, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Item[int Index] = {read=_scw_Get_Item/*, default*/};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::_di_IInterface _scw_Get__NewEnum() { System::_di_IInterface __r; HRESULT __hr = Get__NewEnum(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::_di_IInterface _NewEnum = {read=_scw_Get__NewEnum};
};

__interface  INTERFACE_UUID("{62F47097-95C9-11D0-835D-00AA003CCABD}") ITCallStateEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Call(_di_ITCallInfo &__Get_Call_result) = 0 ;
	virtual HRESULT __safecall Get_State(Winapi::Activex::TOleEnum &__Get_State_result) = 0 ;
	virtual HRESULT __safecall Get_Cause(Winapi::Activex::TOleEnum &__Get_Cause_result) = 0 ;
	virtual HRESULT __safecall Get_CallbackInstance(int &__Get_CallbackInstance_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITCallInfo _scw_Get_Call() { _di_ITCallInfo __r; HRESULT __hr = Get_Call(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITCallInfo Call = {read=_scw_Get_Call};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_State() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_State(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum State = {read=_scw_Get_State};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Cause() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Cause(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Cause = {read=_scw_Get_Cause};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CallbackInstance() { int __r; HRESULT __hr = Get_CallbackInstance(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CallbackInstance = {read=_scw_Get_CallbackInstance};
};

__interface  INTERFACE_UUID("{350F85D1-1227-11D3-83D4-00C04FB6809F}") ITCallInfo  : public IDispatch 
{
	virtual HRESULT __safecall Get_Address(_di_ITAddress &__Get_Address_result) = 0 ;
	virtual HRESULT __safecall Get_CallState(Winapi::Activex::TOleEnum &__Get_CallState_result) = 0 ;
	virtual HRESULT __safecall Get_Privilege(Winapi::Activex::TOleEnum &__Get_Privilege_result) = 0 ;
	virtual HRESULT __safecall Get_CallHub(_di_ITCallHub &__Get_CallHub_result) = 0 ;
	virtual HRESULT __safecall Get_CallInfoLong(Winapi::Activex::TOleEnum CallInfoLong, int &__Get_CallInfoLong_result) = 0 ;
	virtual HRESULT __safecall Set_CallInfoLong(Winapi::Activex::TOleEnum CallInfoLong, int plCallInfoLongVal) = 0 ;
	virtual HRESULT __safecall Get_CallInfoString(Winapi::Activex::TOleEnum CallInfoString, System::WideString &__Get_CallInfoString_result) = 0 ;
	virtual HRESULT __safecall Set_CallInfoString(Winapi::Activex::TOleEnum CallInfoString, const System::WideString ppCallInfoString) = 0 ;
	virtual HRESULT __safecall Get_CallInfoBuffer(Winapi::Activex::TOleEnum CallInfoBuffer, System::OleVariant &__Get_CallInfoBuffer_result) = 0 ;
	virtual HRESULT __safecall Set_CallInfoBuffer(Winapi::Activex::TOleEnum CallInfoBuffer, const System::OleVariant ppCallInfoBuffer) = 0 ;
	virtual HRESULT __safecall GetCallInfoBuffer(Winapi::Activex::TOleEnum CallInfoBuffer, /* out */ unsigned &pdwSize, /* out */ PByte1 &ppCallInfoBuffer) = 0 ;
	virtual HRESULT __safecall SetCallInfoBuffer(Winapi::Activex::TOleEnum CallInfoBuffer, unsigned dwSize, System::Byte &pCallInfoBuffer) = 0 ;
	virtual HRESULT __safecall ReleaseUserUserInfo(void) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITAddress _scw_Get_Address() { _di_ITAddress __r; HRESULT __hr = Get_Address(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITAddress Address = {read=_scw_Get_Address};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_CallState() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_CallState(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum CallState = {read=_scw_Get_CallState};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Privilege() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Privilege(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Privilege = {read=_scw_Get_Privilege};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITCallHub _scw_Get_CallHub() { _di_ITCallHub __r; HRESULT __hr = Get_CallHub(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITCallHub CallHub = {read=_scw_Get_CallHub};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CallInfoLong(Winapi::Activex::TOleEnum CallInfoLong) { int __r; HRESULT __hr = Get_CallInfoLong(CallInfoLong, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CallInfoLong[Winapi::Activex::TOleEnum CallInfoLong] = {read=_scw_Get_CallInfoLong, write=Set_CallInfoLong};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_CallInfoString(Winapi::Activex::TOleEnum CallInfoString) { System::WideString __r; HRESULT __hr = Get_CallInfoString(CallInfoString, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString CallInfoString[Winapi::Activex::TOleEnum CallInfoString] = {read=_scw_Get_CallInfoString, write=Set_CallInfoString};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_CallInfoBuffer(Winapi::Activex::TOleEnum CallInfoBuffer) { System::OleVariant __r; HRESULT __hr = Get_CallInfoBuffer(CallInfoBuffer, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant CallInfoBuffer[Winapi::Activex::TOleEnum CallInfoBuffer] = {read=_scw_Get_CallInfoBuffer, write=Set_CallInfoBuffer};
};

__interface  INTERFACE_UUID("{B1EFC386-9355-11D0-835C-00AA003CCABD}") ITAddress  : public IDispatch 
{
	virtual HRESULT __safecall Get_State(Winapi::Activex::TOleEnum &__Get_State_result) = 0 ;
	virtual HRESULT __safecall Get_AddressName(System::WideString &__Get_AddressName_result) = 0 ;
	virtual HRESULT __safecall Get_ServiceProviderName(System::WideString &__Get_ServiceProviderName_result) = 0 ;
	virtual HRESULT __safecall Get_TAPIObject(_di_ITTAPI &__Get_TAPIObject_result) = 0 ;
	virtual HRESULT __safecall CreateCall(const System::WideString pDestAddress, int lAddressType, int lMediaTypes, _di_ITBasicCallControl &__CreateCall_result) = 0 ;
	virtual HRESULT __safecall Get_Calls(System::OleVariant &__Get_Calls_result) = 0 ;
	virtual HRESULT __safecall EnumerateCalls(_di_IEnumCall &__EnumerateCalls_result) = 0 ;
	virtual HRESULT __safecall Get_DialableAddress(System::WideString &__Get_DialableAddress_result) = 0 ;
	virtual HRESULT __safecall CreateForwardInfoObject(_di_ITForwardInformation &__CreateForwardInfoObject_result) = 0 ;
	virtual HRESULT __safecall Forward(const _di_ITForwardInformation pForwardInfo, const _di_ITBasicCallControl pCall) = 0 ;
	virtual HRESULT __safecall Get_CurrentForwardInfo(_di_ITForwardInformation &__Get_CurrentForwardInfo_result) = 0 ;
	virtual HRESULT __safecall Set_MessageWaiting(System::WordBool pfMessageWaiting) = 0 ;
	virtual HRESULT __safecall Get_MessageWaiting(System::WordBool &__Get_MessageWaiting_result) = 0 ;
	virtual HRESULT __safecall Set_DoNotDisturb(System::WordBool pfDoNotDisturb) = 0 ;
	virtual HRESULT __safecall Get_DoNotDisturb(System::WordBool &__Get_DoNotDisturb_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_State() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_State(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum State = {read=_scw_Get_State};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_AddressName() { System::WideString __r; HRESULT __hr = Get_AddressName(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString AddressName = {read=_scw_Get_AddressName};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_ServiceProviderName() { System::WideString __r; HRESULT __hr = Get_ServiceProviderName(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString ServiceProviderName = {read=_scw_Get_ServiceProviderName};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITTAPI _scw_Get_TAPIObject() { _di_ITTAPI __r; HRESULT __hr = Get_TAPIObject(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITTAPI TAPIObject = {read=_scw_Get_TAPIObject};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Calls() { System::OleVariant __r; HRESULT __hr = Get_Calls(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Calls = {read=_scw_Get_Calls};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_DialableAddress() { System::WideString __r; HRESULT __hr = Get_DialableAddress(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString DialableAddress = {read=_scw_Get_DialableAddress};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITForwardInformation _scw_Get_CurrentForwardInfo() { _di_ITForwardInformation __r; HRESULT __hr = Get_CurrentForwardInfo(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITForwardInformation CurrentForwardInfo = {read=_scw_Get_CurrentForwardInfo};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WordBool _scw_Get_MessageWaiting() { System::WordBool __r; HRESULT __hr = Get_MessageWaiting(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WordBool MessageWaiting = {read=_scw_Get_MessageWaiting, write=Set_MessageWaiting};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WordBool _scw_Get_DoNotDisturb() { System::WordBool __r; HRESULT __hr = Get_DoNotDisturb(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WordBool DoNotDisturb = {read=_scw_Get_DoNotDisturb, write=Set_DoNotDisturb};
};

__interface  INTERFACE_UUID("{B1EFC382-9355-11D0-835C-00AA003CCABD}") ITTAPI  : public IDispatch 
{
	virtual HRESULT __safecall Initialize(void) = 0 ;
	virtual HRESULT __safecall Shutdown(void) = 0 ;
	virtual HRESULT __safecall Get_Addresses(System::OleVariant &__Get_Addresses_result) = 0 ;
	virtual HRESULT __safecall EnumerateAddresses(_di_IEnumAddress &__EnumerateAddresses_result) = 0 ;
	virtual HRESULT __safecall RegisterCallNotifications(const _di_ITAddress pAddress, System::WordBool fMonitor, System::WordBool fOwner, int lMediaTypes, int lCallbackInstance, int &__RegisterCallNotifications_result) = 0 ;
	virtual HRESULT __safecall UnregisterNotifications(int lRegister) = 0 ;
	virtual HRESULT __safecall Get_CallHubs(System::OleVariant &__Get_CallHubs_result) = 0 ;
	virtual HRESULT __safecall EnumerateCallHubs(_di_IEnumCallHub &__EnumerateCallHubs_result) = 0 ;
	virtual HRESULT __safecall SetCallHubTracking(const System::OleVariant pAddresses, System::WordBool bTracking) = 0 ;
	virtual HRESULT __safecall EnumeratePrivateTAPIObjects(/* out */ _di_IEnumUnknown &ppEnumUnknown) = 0 ;
	virtual HRESULT __safecall Get_PrivateTAPIObjects(System::OleVariant &__Get_PrivateTAPIObjects_result) = 0 ;
	virtual HRESULT __safecall RegisterRequestRecipient(int lRegistrationInstance, int lRequestMode, System::WordBool fEnable) = 0 ;
	virtual HRESULT __safecall SetAssistedTelephonyPriority(const System::WideString pAppFilename, System::WordBool fPriority) = 0 ;
	virtual HRESULT __safecall SetApplicationPriority(const System::WideString pAppFilename, int lMediaType, System::WordBool fPriority) = 0 ;
	virtual HRESULT __safecall Set_EventFilter(int plFilterMask) = 0 ;
	virtual HRESULT __safecall Get_EventFilter(int &__Get_EventFilter_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Addresses() { System::OleVariant __r; HRESULT __hr = Get_Addresses(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Addresses = {read=_scw_Get_Addresses};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_CallHubs() { System::OleVariant __r; HRESULT __hr = Get_CallHubs(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant CallHubs = {read=_scw_Get_CallHubs};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_PrivateTAPIObjects() { System::OleVariant __r; HRESULT __hr = Get_PrivateTAPIObjects(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant PrivateTAPIObjects = {read=_scw_Get_PrivateTAPIObjects};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_EventFilter() { int __r; HRESULT __hr = Get_EventFilter(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int EventFilter = {read=_scw_Get_EventFilter, write=Set_EventFilter};
};

__interface  INTERFACE_UUID("{1666FCA1-9363-11D0-835C-00AA003CCABD}") IEnumAddress  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITAddress &ppElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumAddress &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{A3C15450-5B92-11D1-8F4E-00C04FB6809F}") IEnumCallHub  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITCallHub &ppElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumCallHub &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{A3C1544E-5B92-11D1-8F4E-00C04FB6809F}") ITCallHub  : public IDispatch 
{
	virtual HRESULT __safecall Clear(void) = 0 ;
	virtual HRESULT __safecall EnumerateCalls(_di_IEnumCall &__EnumerateCalls_result) = 0 ;
	virtual HRESULT __safecall Get_Calls(System::OleVariant &__Get_Calls_result) = 0 ;
	virtual HRESULT __safecall Get_NumCalls(int &__Get_NumCalls_result) = 0 ;
	virtual HRESULT __safecall Get_State(Winapi::Activex::TOleEnum &__Get_State_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Calls() { System::OleVariant __r; HRESULT __hr = Get_Calls(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Calls = {read=_scw_Get_Calls};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NumCalls() { int __r; HRESULT __hr = Get_NumCalls(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NumCalls = {read=_scw_Get_NumCalls};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_State() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_State(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum State = {read=_scw_Get_State};
};

__interface  INTERFACE_UUID("{AE269CF6-935E-11D0-835C-00AA003CCABD}") IEnumCall  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITCallInfo &ppElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumCall &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{00000100-0000-0000-C000-000000000046}") IEnumUnknown  : public System::IInterface 
{
	virtual HRESULT __stdcall RemoteNext(unsigned celt, /* out */ System::_di_IInterface &rgelt, /* out */ unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumUnknown &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{B1EFC389-9355-11D0-835C-00AA003CCABD}") ITBasicCallControl  : public IDispatch 
{
	virtual HRESULT __safecall Connect(System::WordBool fSync) = 0 ;
	virtual HRESULT __safecall Answer(void) = 0 ;
	virtual HRESULT __safecall Disconnect(Winapi::Activex::TOleEnum code) = 0 ;
	virtual HRESULT __safecall Hold(System::WordBool fHold) = 0 ;
	virtual HRESULT __safecall HandoffDirect(const System::WideString pApplicationName) = 0 ;
	virtual HRESULT __safecall HandoffIndirect(int lMediaType) = 0 ;
	virtual HRESULT __safecall Conference(const _di_ITBasicCallControl pCall, System::WordBool fSync) = 0 ;
	virtual HRESULT __safecall Transfer(const _di_ITBasicCallControl pCall, System::WordBool fSync) = 0 ;
	virtual HRESULT __safecall BlindTransfer(const System::WideString pDestAddress) = 0 ;
	virtual HRESULT __safecall SwapHold(const _di_ITBasicCallControl pCall) = 0 ;
	virtual HRESULT __safecall ParkDirect(const System::WideString pParkAddress) = 0 ;
	virtual HRESULT __safecall ParkIndirect(System::WideString &__ParkIndirect_result) = 0 ;
	virtual HRESULT __safecall Unpark(void) = 0 ;
	virtual HRESULT __safecall SetQOS(int lMediaType, Winapi::Activex::TOleEnum ServiceLevel) = 0 ;
	virtual HRESULT __safecall Pickup(const System::WideString pGroupID) = 0 ;
	virtual HRESULT __safecall Dial(const System::WideString pDestAddress) = 0 ;
	virtual HRESULT __safecall Finish(Winapi::Activex::TOleEnum finishMode) = 0 ;
	virtual HRESULT __safecall RemoveFromConference(void) = 0 ;
};

__interface  INTERFACE_UUID("{449F659E-88A3-11D1-BB5D-00C04FB6809F}") ITForwardInformation  : public IDispatch 
{
	virtual HRESULT __safecall Set_NumRingsNoAnswer(int plNumRings) = 0 ;
	virtual HRESULT __safecall Get_NumRingsNoAnswer(int &__Get_NumRingsNoAnswer_result) = 0 ;
	virtual HRESULT __safecall SetForwardType(int ForwardType, const System::WideString pDestAddress, const System::WideString pCallerAddress) = 0 ;
	virtual HRESULT __safecall Get_ForwardTypeDestination(int ForwardType, System::WideString &__Get_ForwardTypeDestination_result) = 0 ;
	virtual HRESULT __safecall Get_ForwardTypeCaller(int ForwardType, System::WideString &__Get_ForwardTypeCaller_result) = 0 ;
	virtual HRESULT __safecall GetForwardType(int ForwardType, /* out */ System::WideString &ppDestinationAddress, /* out */ System::WideString &ppCallerAddress) = 0 ;
	virtual HRESULT __safecall Clear(void) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NumRingsNoAnswer() { int __r; HRESULT __hr = Get_NumRingsNoAnswer(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NumRingsNoAnswer = {read=_scw_Get_NumRingsNoAnswer, write=Set_NumRingsNoAnswer};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_ForwardTypeDestination(int ForwardType) { System::WideString __r; HRESULT __hr = Get_ForwardTypeDestination(ForwardType, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString ForwardTypeDestination[int ForwardType] = {read=_scw_Get_ForwardTypeDestination};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_ForwardTypeCaller(int ForwardType) { System::WideString __r; HRESULT __hr = Get_ForwardTypeCaller(ForwardType, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString ForwardTypeCaller[int ForwardType] = {read=_scw_Get_ForwardTypeCaller};
};

__interface  INTERFACE_UUID("{895801DF-3DD6-11D1-8F30-00C04FB6809F}") ITCallNotificationEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Call(_di_ITCallInfo &__Get_Call_result) = 0 ;
	virtual HRESULT __safecall Get_Event(Winapi::Activex::TOleEnum &__Get_Event_result) = 0 ;
	virtual HRESULT __safecall Get_CallbackInstance(int &__Get_CallbackInstance_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITCallInfo _scw_Get_Call() { _di_ITCallInfo __r; HRESULT __hr = Get_Call(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITCallInfo Call = {read=_scw_Get_Call};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Event() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Event(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Event = {read=_scw_Get_Event};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CallbackInstance() { int __r; HRESULT __hr = Get_CallbackInstance(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CallbackInstance = {read=_scw_Get_CallbackInstance};
};

__interface  INTERFACE_UUID("{EDDB9426-3B91-11D1-8F30-00C04FB6809F}") ITTAPIEventNotification  : public System::IInterface 
{
	virtual HRESULT __stdcall Event(Winapi::Activex::TOleEnum TapiEvent, const _di_IDispatch pEvent) = 0 ;
};

__interface  INTERFACE_UUID("{B1EFC38D-9355-11D0-835C-00AA003CCABD}") ITBasicAudioTerminal  : public IDispatch 
{
	virtual HRESULT __safecall Set_Volume(int plVolume) = 0 ;
	virtual HRESULT __safecall Get_Volume(int &__Get_Volume_result) = 0 ;
	virtual HRESULT __safecall Set_Balance(int plBalance) = 0 ;
	virtual HRESULT __safecall Get_Balance(int &__Get_Balance_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Volume() { int __r; HRESULT __hr = Get_Volume(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Volume = {read=_scw_Get_Volume, write=Set_Volume};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Balance() { int __r; HRESULT __hr = Get_Balance(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Balance = {read=_scw_Get_Balance, write=Set_Balance};
};

__interface  INTERFACE_UUID("{A3C15451-5B92-11D1-8F4E-00C04FB6809F}") ITCallHubEvent  : public IDispatch 
{
	virtual HRESULT __stdcall Get_Event(/* out */ Winapi::Activex::TOleEnum &pEvent) = 0 ;
	virtual HRESULT __stdcall Get_CallHub(/* out */ _di_ITCallHub &ppCallHub) = 0 ;
	virtual HRESULT __stdcall Get_Call(/* out */ _di_ITCallInfo &ppCall) = 0 ;
};

__interface  INTERFACE_UUID("{8DF232F5-821B-11D1-BB5C-00C04FB6809F}") ITAddressCapabilities  : public IDispatch 
{
	virtual HRESULT __safecall Get_AddressCapability(Winapi::Activex::TOleEnum AddressCap, int &__Get_AddressCapability_result) = 0 ;
	virtual HRESULT __safecall Get_AddressCapabilityString(Winapi::Activex::TOleEnum AddressCapString, System::WideString &__Get_AddressCapabilityString_result) = 0 ;
	virtual HRESULT __safecall Get_CallTreatments(System::OleVariant &__Get_CallTreatments_result) = 0 ;
	virtual HRESULT __safecall EnumerateCallTreatments(_di_IEnumBstr &__EnumerateCallTreatments_result) = 0 ;
	virtual HRESULT __safecall Get_CompletionMessages(System::OleVariant &__Get_CompletionMessages_result) = 0 ;
	virtual HRESULT __safecall EnumerateCompletionMessages(_di_IEnumBstr &__EnumerateCompletionMessages_result) = 0 ;
	virtual HRESULT __safecall Get_DeviceClasses(System::OleVariant &__Get_DeviceClasses_result) = 0 ;
	virtual HRESULT __safecall EnumerateDeviceClasses(_di_IEnumBstr &__EnumerateDeviceClasses_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AddressCapability(Winapi::Activex::TOleEnum AddressCap) { int __r; HRESULT __hr = Get_AddressCapability(AddressCap, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AddressCapability[Winapi::Activex::TOleEnum AddressCap] = {read=_scw_Get_AddressCapability};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_AddressCapabilityString(Winapi::Activex::TOleEnum AddressCapString) { System::WideString __r; HRESULT __hr = Get_AddressCapabilityString(AddressCapString, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString AddressCapabilityString[Winapi::Activex::TOleEnum AddressCapString] = {read=_scw_Get_AddressCapabilityString};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_CallTreatments() { System::OleVariant __r; HRESULT __hr = Get_CallTreatments(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant CallTreatments = {read=_scw_Get_CallTreatments};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_CompletionMessages() { System::OleVariant __r; HRESULT __hr = Get_CompletionMessages(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant CompletionMessages = {read=_scw_Get_CompletionMessages};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_DeviceClasses() { System::OleVariant __r; HRESULT __hr = Get_DeviceClasses(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant DeviceClasses = {read=_scw_Get_DeviceClasses};
};

__interface  INTERFACE_UUID("{35372049-0BC6-11D2-A033-00C04FB6809F}") IEnumBstr  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ System::WideString &ppStrings, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumBstr &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{CFA3357C-AD77-11D1-BB68-00C04FB6809F}") ITQOSEvent  : public IDispatch 
{
	virtual HRESULT __stdcall Get_Call(/* out */ _di_ITCallInfo &ppCall) = 0 ;
	virtual HRESULT __stdcall Get_Event(/* out */ Winapi::Activex::TOleEnum &pQosEvent) = 0 ;
	virtual HRESULT __stdcall Get_MediaType(/* out */ int &plMediaType) = 0 ;
};

__interface  INTERFACE_UUID("{831CE2D1-83B5-11D1-BB5C-00C04FB6809F}") ITAddressEvent  : public IDispatch 
{
	virtual HRESULT __stdcall Get_Address(/* out */ _di_ITAddress &ppAddress) = 0 ;
	virtual HRESULT __stdcall Get_Event(/* out */ Winapi::Activex::TOleEnum &pEvent) = 0 ;
	virtual HRESULT __stdcall Get_Terminal(/* out */ _di_ITTerminal &ppTerminal) = 0 ;
};

__interface  INTERFACE_UUID("{B1EFC38A-9355-11D0-835C-00AA003CCABD}") ITTerminal  : public IDispatch 
{
	virtual HRESULT __safecall Get_Name(System::WideString &__Get_Name_result) = 0 ;
	virtual HRESULT __safecall Get_State(Winapi::Activex::TOleEnum &__Get_State_result) = 0 ;
	virtual HRESULT __safecall Get_TerminalType(Winapi::Activex::TOleEnum &__Get_TerminalType_result) = 0 ;
	virtual HRESULT __safecall Get_TerminalClass(System::WideString &__Get_TerminalClass_result) = 0 ;
	virtual HRESULT __safecall Get_MediaType(int &__Get_MediaType_result) = 0 ;
	virtual HRESULT __safecall Get_Direction(Winapi::Activex::TOleEnum &__Get_Direction_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Name() { System::WideString __r; HRESULT __hr = Get_Name(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Name = {read=_scw_Get_Name};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_State() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_State(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum State = {read=_scw_Get_State};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_TerminalType() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_TerminalType(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum TerminalType = {read=_scw_Get_TerminalType};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_TerminalClass() { System::WideString __r; HRESULT __hr = Get_TerminalClass(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString TerminalClass = {read=_scw_Get_TerminalClass};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MediaType() { int __r; HRESULT __hr = Get_MediaType(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MediaType = {read=_scw_Get_MediaType};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Direction() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Direction(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Direction = {read=_scw_Get_Direction};
};

__interface  INTERFACE_UUID("{FF36B87F-EC3A-11D0-8EE4-00C04FB6809F}") ITCallMediaEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Call(_di_ITCallInfo &__Get_Call_result) = 0 ;
	virtual HRESULT __safecall Get_Event(Winapi::Activex::TOleEnum &__Get_Event_result) = 0 ;
	virtual HRESULT __safecall Get_Error(HRESULT &__Get_Error_result) = 0 ;
	virtual HRESULT __safecall Get_Terminal(_di_ITTerminal &__Get_Terminal_result) = 0 ;
	virtual HRESULT __safecall Get_Stream(_di_ITStream &__Get_Stream_result) = 0 ;
	virtual HRESULT __safecall Get_Cause(Winapi::Activex::TOleEnum &__Get_Cause_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITCallInfo _scw_Get_Call() { _di_ITCallInfo __r; HRESULT __hr = Get_Call(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITCallInfo Call = {read=_scw_Get_Call};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Event() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Event(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Event = {read=_scw_Get_Event};
	#pragma option push -w-inl
	/* safecall wrapper */ inline HRESULT _scw_Get_Error() { HRESULT __r; HRESULT __hr = Get_Error(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property HRESULT Error = {read=_scw_Get_Error};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITTerminal _scw_Get_Terminal() { _di_ITTerminal __r; HRESULT __hr = Get_Terminal(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITTerminal Terminal = {read=_scw_Get_Terminal};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITStream _scw_Get_Stream() { _di_ITStream __r; HRESULT __hr = Get_Stream(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITStream Stream = {read=_scw_Get_Stream};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Cause() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Cause(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Cause = {read=_scw_Get_Cause};
};

__interface  INTERFACE_UUID("{EE3BD605-3868-11D2-A045-00C04FB6809F}") ITStream  : public IDispatch 
{
	virtual HRESULT __safecall Get_MediaType(int &__Get_MediaType_result) = 0 ;
	virtual HRESULT __safecall Get_Direction(Winapi::Activex::TOleEnum &__Get_Direction_result) = 0 ;
	virtual HRESULT __safecall Get_Name(System::WideString &__Get_Name_result) = 0 ;
	virtual HRESULT __safecall StartStream(void) = 0 ;
	virtual HRESULT __safecall PauseStream(void) = 0 ;
	virtual HRESULT __safecall StopStream(void) = 0 ;
	virtual HRESULT __safecall SelectTerminal(const _di_ITTerminal pTerminal) = 0 ;
	virtual HRESULT __safecall UnselectTerminal(const _di_ITTerminal pTerminal) = 0 ;
	virtual HRESULT __safecall EnumerateTerminals(/* out */ _di_IEnumTerminal &ppEnumTerminal) = 0 ;
	virtual HRESULT __safecall Get_Terminals(System::OleVariant &__Get_Terminals_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MediaType() { int __r; HRESULT __hr = Get_MediaType(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MediaType = {read=_scw_Get_MediaType};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Direction() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Direction(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Direction = {read=_scw_Get_Direction};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Name() { System::WideString __r; HRESULT __hr = Get_Name(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Name = {read=_scw_Get_Name};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Terminals() { System::OleVariant __r; HRESULT __hr = Get_Terminals(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Terminals = {read=_scw_Get_Terminals};
};

__interface  INTERFACE_UUID("{AE269CF4-935E-11D0-835C-00AA003CCABD}") IEnumTerminal  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITTerminal &ppElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumTerminal &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{F4854D48-937A-11D1-BB58-00C04FB6809F}") ITTAPIObjectEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_TAPIObject(_di_ITTAPI &__Get_TAPIObject_result) = 0 ;
	virtual HRESULT __safecall Get_Event(Winapi::Activex::TOleEnum &__Get_Event_result) = 0 ;
	virtual HRESULT __safecall Get_Address(_di_ITAddress &__Get_Address_result) = 0 ;
	virtual HRESULT __safecall Get_CallbackInstance(int &__Get_CallbackInstance_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITTAPI _scw_Get_TAPIObject() { _di_ITTAPI __r; HRESULT __hr = Get_TAPIObject(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITTAPI TAPIObject = {read=_scw_Get_TAPIObject};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Event() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Event(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Event = {read=_scw_Get_Event};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITAddress _scw_Get_Address() { _di_ITAddress __r; HRESULT __hr = Get_Address(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITAddress Address = {read=_scw_Get_Address};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CallbackInstance() { int __r; HRESULT __hr = Get_CallbackInstance(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CallbackInstance = {read=_scw_Get_CallbackInstance};
};

__interface  INTERFACE_UUID("{0C4D8F03-8DDB-11D1-A09E-00805FC147D3}") ITAddressTranslation  : public IDispatch 
{
	virtual HRESULT __safecall TranslateAddress(const System::WideString pAddressToTranslate, int lCard, int lTranslateOptions, _di_ITAddressTranslationInfo &__TranslateAddress_result) = 0 ;
	virtual HRESULT __safecall TranslateDialog(int hwndOwner, const System::WideString pAddressIn) = 0 ;
	virtual HRESULT __safecall EnumerateLocations(_di_IEnumLocation &__EnumerateLocations_result) = 0 ;
	virtual HRESULT __safecall Get_Locations(System::OleVariant &__Get_Locations_result) = 0 ;
	virtual HRESULT __safecall EnumerateCallingCards(_di_IEnumCallingCard &__EnumerateCallingCards_result) = 0 ;
	virtual HRESULT __safecall Get_CallingCards(System::OleVariant &__Get_CallingCards_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Locations() { System::OleVariant __r; HRESULT __hr = Get_Locations(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Locations = {read=_scw_Get_Locations};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_CallingCards() { System::OleVariant __r; HRESULT __hr = Get_CallingCards(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant CallingCards = {read=_scw_Get_CallingCards};
};

__interface  INTERFACE_UUID("{AFC15945-8D40-11D1-A09E-00805FC147D3}") ITAddressTranslationInfo  : public IDispatch 
{
	virtual HRESULT __safecall Get_DialableString(System::WideString &__Get_DialableString_result) = 0 ;
	virtual HRESULT __safecall Get_DisplayableString(System::WideString &__Get_DisplayableString_result) = 0 ;
	virtual HRESULT __safecall Get_CurrentCountryCode(int &__Get_CurrentCountryCode_result) = 0 ;
	virtual HRESULT __safecall Get_DestinationCountryCode(int &__Get_DestinationCountryCode_result) = 0 ;
	virtual HRESULT __safecall Get_TranslationResults(int &__Get_TranslationResults_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_DialableString() { System::WideString __r; HRESULT __hr = Get_DialableString(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString DialableString = {read=_scw_Get_DialableString};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_DisplayableString() { System::WideString __r; HRESULT __hr = Get_DisplayableString(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString DisplayableString = {read=_scw_Get_DisplayableString};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CurrentCountryCode() { int __r; HRESULT __hr = Get_CurrentCountryCode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CurrentCountryCode = {read=_scw_Get_CurrentCountryCode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_DestinationCountryCode() { int __r; HRESULT __hr = Get_DestinationCountryCode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int DestinationCountryCode = {read=_scw_Get_DestinationCountryCode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TranslationResults() { int __r; HRESULT __hr = Get_TranslationResults(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TranslationResults = {read=_scw_Get_TranslationResults};
};

__interface  INTERFACE_UUID("{0C4D8F01-8DDB-11D1-A09E-00805FC147D3}") IEnumLocation  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITLocationInfo &ppElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumLocation &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{0C4D8EFF-8DDB-11D1-A09E-00805FC147D3}") ITLocationInfo  : public IDispatch 
{
	virtual HRESULT __safecall Get_PermanentLocationID(int &__Get_PermanentLocationID_result) = 0 ;
	virtual HRESULT __safecall Get_CountryCode(int &__Get_CountryCode_result) = 0 ;
	virtual HRESULT __safecall Get_CountryID(int &__Get_CountryID_result) = 0 ;
	virtual HRESULT __safecall Get_Options(int &__Get_Options_result) = 0 ;
	virtual HRESULT __safecall Get_PreferredCardID(int &__Get_PreferredCardID_result) = 0 ;
	virtual HRESULT __safecall Get_LocationName(System::WideString &__Get_LocationName_result) = 0 ;
	virtual HRESULT __safecall Get_CityCode(System::WideString &__Get_CityCode_result) = 0 ;
	virtual HRESULT __safecall Get_LocalAccessCode(System::WideString &__Get_LocalAccessCode_result) = 0 ;
	virtual HRESULT __safecall Get_LongDistanceAccessCode(System::WideString &__Get_LongDistanceAccessCode_result) = 0 ;
	virtual HRESULT __safecall Get_TollPrefixList(System::WideString &__Get_TollPrefixList_result) = 0 ;
	virtual HRESULT __safecall Get_CancelCallWaitingCode(System::WideString &__Get_CancelCallWaitingCode_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_PermanentLocationID() { int __r; HRESULT __hr = Get_PermanentLocationID(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int PermanentLocationID = {read=_scw_Get_PermanentLocationID};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CountryCode() { int __r; HRESULT __hr = Get_CountryCode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CountryCode = {read=_scw_Get_CountryCode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CountryID() { int __r; HRESULT __hr = Get_CountryID(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CountryID = {read=_scw_Get_CountryID};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Options() { int __r; HRESULT __hr = Get_Options(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Options = {read=_scw_Get_Options};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_PreferredCardID() { int __r; HRESULT __hr = Get_PreferredCardID(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int PreferredCardID = {read=_scw_Get_PreferredCardID};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_LocationName() { System::WideString __r; HRESULT __hr = Get_LocationName(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString LocationName = {read=_scw_Get_LocationName};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_CityCode() { System::WideString __r; HRESULT __hr = Get_CityCode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString CityCode = {read=_scw_Get_CityCode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_LocalAccessCode() { System::WideString __r; HRESULT __hr = Get_LocalAccessCode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString LocalAccessCode = {read=_scw_Get_LocalAccessCode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_LongDistanceAccessCode() { System::WideString __r; HRESULT __hr = Get_LongDistanceAccessCode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString LongDistanceAccessCode = {read=_scw_Get_LongDistanceAccessCode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_TollPrefixList() { System::WideString __r; HRESULT __hr = Get_TollPrefixList(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString TollPrefixList = {read=_scw_Get_TollPrefixList};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_CancelCallWaitingCode() { System::WideString __r; HRESULT __hr = Get_CancelCallWaitingCode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString CancelCallWaitingCode = {read=_scw_Get_CancelCallWaitingCode};
};

__interface  INTERFACE_UUID("{0C4D8F02-8DDB-11D1-A09E-00805FC147D3}") IEnumCallingCard  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITCallingCard &ppElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumCallingCard &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{0C4D8F00-8DDB-11D1-A09E-00805FC147D3}") ITCallingCard  : public IDispatch 
{
	virtual HRESULT __safecall Get_PermanentCardID(int &__Get_PermanentCardID_result) = 0 ;
	virtual HRESULT __safecall Get_NumberOfDigits(int &__Get_NumberOfDigits_result) = 0 ;
	virtual HRESULT __safecall Get_Options(int &__Get_Options_result) = 0 ;
	virtual HRESULT __safecall Get_CardName(System::WideString &__Get_CardName_result) = 0 ;
	virtual HRESULT __safecall Get_SameAreaDialingRule(System::WideString &__Get_SameAreaDialingRule_result) = 0 ;
	virtual HRESULT __safecall Get_LongDistanceDialingRule(System::WideString &__Get_LongDistanceDialingRule_result) = 0 ;
	virtual HRESULT __safecall Get_InternationalDialingRule(System::WideString &__Get_InternationalDialingRule_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_PermanentCardID() { int __r; HRESULT __hr = Get_PermanentCardID(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int PermanentCardID = {read=_scw_Get_PermanentCardID};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NumberOfDigits() { int __r; HRESULT __hr = Get_NumberOfDigits(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NumberOfDigits = {read=_scw_Get_NumberOfDigits};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Options() { int __r; HRESULT __hr = Get_Options(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Options = {read=_scw_Get_Options};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_CardName() { System::WideString __r; HRESULT __hr = Get_CardName(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString CardName = {read=_scw_Get_CardName};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_SameAreaDialingRule() { System::WideString __r; HRESULT __hr = Get_SameAreaDialingRule(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString SameAreaDialingRule = {read=_scw_Get_SameAreaDialingRule};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_LongDistanceDialingRule() { System::WideString __r; HRESULT __hr = Get_LongDistanceDialingRule(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString LongDistanceDialingRule = {read=_scw_Get_LongDistanceDialingRule};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_InternationalDialingRule() { System::WideString __r; HRESULT __hr = Get_InternationalDialingRule(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString InternationalDialingRule = {read=_scw_Get_InternationalDialingRule};
};

__interface  INTERFACE_UUID("{5770ECE5-4B27-11D1-BF80-00805FC147D3}") ITAgent  : public IDispatch 
{
	virtual HRESULT __safecall EnumerateAgentSessions(_di_IEnumAgentSession &__EnumerateAgentSessions_result) = 0 ;
	virtual HRESULT __safecall CreateSession(const _di_ITACDGroup pACDGroup, const _di_ITAddress pAddress, _di_ITAgentSession &__CreateSession_result) = 0 ;
	virtual HRESULT __safecall CreateSessionWithPIN(const _di_ITACDGroup pACDGroup, const _di_ITAddress pAddress, const System::WideString pPIN, _di_ITAgentSession &__CreateSessionWithPIN_result) = 0 ;
	virtual HRESULT __safecall Get_ID(System::WideString &__Get_ID_result) = 0 ;
	virtual HRESULT __safecall Get_User(System::WideString &__Get_User_result) = 0 ;
	virtual HRESULT __safecall Set_State(Winapi::Activex::TOleEnum pAgentState) = 0 ;
	virtual HRESULT __safecall Get_State(Winapi::Activex::TOleEnum &__Get_State_result) = 0 ;
	virtual HRESULT __safecall Set_MeasurementPeriod(int plPeriod) = 0 ;
	virtual HRESULT __safecall Get_MeasurementPeriod(int &__Get_MeasurementPeriod_result) = 0 ;
	virtual HRESULT __safecall Get_OverallCallRate(System::Currency &__Get_OverallCallRate_result) = 0 ;
	virtual HRESULT __safecall Get_NumberOfACDCalls(int &__Get_NumberOfACDCalls_result) = 0 ;
	virtual HRESULT __safecall Get_NumberOfIncomingCalls(int &__Get_NumberOfIncomingCalls_result) = 0 ;
	virtual HRESULT __safecall Get_NumberOfOutgoingCalls(int &__Get_NumberOfOutgoingCalls_result) = 0 ;
	virtual HRESULT __safecall Get_TotalACDTalkTime(int &__Get_TotalACDTalkTime_result) = 0 ;
	virtual HRESULT __safecall Get_TotalACDCallTime(int &__Get_TotalACDCallTime_result) = 0 ;
	virtual HRESULT __safecall Get_TotalWrapUpTime(int &__Get_TotalWrapUpTime_result) = 0 ;
	virtual HRESULT __safecall Get_AgentSessions(System::OleVariant &__Get_AgentSessions_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_ID() { System::WideString __r; HRESULT __hr = Get_ID(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString ID = {read=_scw_Get_ID};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_User() { System::WideString __r; HRESULT __hr = Get_User(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString User = {read=_scw_Get_User};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_State() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_State(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum State = {read=_scw_Get_State, write=Set_State};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MeasurementPeriod() { int __r; HRESULT __hr = Get_MeasurementPeriod(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MeasurementPeriod = {read=_scw_Get_MeasurementPeriod, write=Set_MeasurementPeriod};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::Currency _scw_Get_OverallCallRate() { System::Currency __r; HRESULT __hr = Get_OverallCallRate(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::Currency OverallCallRate = {read=_scw_Get_OverallCallRate};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NumberOfACDCalls() { int __r; HRESULT __hr = Get_NumberOfACDCalls(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NumberOfACDCalls = {read=_scw_Get_NumberOfACDCalls};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NumberOfIncomingCalls() { int __r; HRESULT __hr = Get_NumberOfIncomingCalls(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NumberOfIncomingCalls = {read=_scw_Get_NumberOfIncomingCalls};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NumberOfOutgoingCalls() { int __r; HRESULT __hr = Get_NumberOfOutgoingCalls(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NumberOfOutgoingCalls = {read=_scw_Get_NumberOfOutgoingCalls};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalACDTalkTime() { int __r; HRESULT __hr = Get_TotalACDTalkTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalACDTalkTime = {read=_scw_Get_TotalACDTalkTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalACDCallTime() { int __r; HRESULT __hr = Get_TotalACDCallTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalACDCallTime = {read=_scw_Get_TotalACDCallTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalWrapUpTime() { int __r; HRESULT __hr = Get_TotalWrapUpTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalWrapUpTime = {read=_scw_Get_TotalWrapUpTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_AgentSessions() { System::OleVariant __r; HRESULT __hr = Get_AgentSessions(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant AgentSessions = {read=_scw_Get_AgentSessions};
};

__interface  INTERFACE_UUID("{5AFC314E-4BCC-11D1-BF80-00805FC147D3}") IEnumAgentSession  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITAgentSession &ppElements, /* out */ unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumAgentSession &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{5AFC3147-4BCC-11D1-BF80-00805FC147D3}") ITAgentSession  : public IDispatch 
{
	virtual HRESULT __safecall Get_Agent(_di_ITAgent &__Get_Agent_result) = 0 ;
	virtual HRESULT __safecall Get_Address(_di_ITAddress &__Get_Address_result) = 0 ;
	virtual HRESULT __safecall Get_ACDGroup(_di_ITACDGroup &__Get_ACDGroup_result) = 0 ;
	virtual HRESULT __safecall Set_State(Winapi::Activex::TOleEnum pSessionState) = 0 ;
	virtual HRESULT __safecall Get_State(Winapi::Activex::TOleEnum &__Get_State_result) = 0 ;
	virtual HRESULT __safecall Get_SessionStartTime(System::TDateTime &__Get_SessionStartTime_result) = 0 ;
	virtual HRESULT __safecall Get_SessionDuration(int &__Get_SessionDuration_result) = 0 ;
	virtual HRESULT __safecall Get_NumberOfCalls(int &__Get_NumberOfCalls_result) = 0 ;
	virtual HRESULT __safecall Get_TotalTalkTime(int &__Get_TotalTalkTime_result) = 0 ;
	virtual HRESULT __safecall Get_AverageTalkTime(int &__Get_AverageTalkTime_result) = 0 ;
	virtual HRESULT __safecall Get_TotalCallTime(int &__Get_TotalCallTime_result) = 0 ;
	virtual HRESULT __safecall Get_AverageCallTime(int &__Get_AverageCallTime_result) = 0 ;
	virtual HRESULT __safecall Get_TotalWrapUpTime(int &__Get_TotalWrapUpTime_result) = 0 ;
	virtual HRESULT __safecall Get_AverageWrapUpTime(int &__Get_AverageWrapUpTime_result) = 0 ;
	virtual HRESULT __safecall Get_ACDCallRate(System::Currency &__Get_ACDCallRate_result) = 0 ;
	virtual HRESULT __safecall Get_LongestTimeToAnswer(int &__Get_LongestTimeToAnswer_result) = 0 ;
	virtual HRESULT __safecall Get_AverageTimeToAnswer(int &__Get_AverageTimeToAnswer_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITAgent _scw_Get_Agent() { _di_ITAgent __r; HRESULT __hr = Get_Agent(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITAgent Agent = {read=_scw_Get_Agent};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITAddress _scw_Get_Address() { _di_ITAddress __r; HRESULT __hr = Get_Address(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITAddress Address = {read=_scw_Get_Address};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITACDGroup _scw_Get_ACDGroup() { _di_ITACDGroup __r; HRESULT __hr = Get_ACDGroup(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITACDGroup ACDGroup = {read=_scw_Get_ACDGroup};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_State() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_State(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum State = {read=_scw_Get_State, write=Set_State};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::TDateTime _scw_Get_SessionStartTime() { System::TDateTime __r; HRESULT __hr = Get_SessionStartTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::TDateTime SessionStartTime = {read=_scw_Get_SessionStartTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_SessionDuration() { int __r; HRESULT __hr = Get_SessionDuration(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int SessionDuration = {read=_scw_Get_SessionDuration};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NumberOfCalls() { int __r; HRESULT __hr = Get_NumberOfCalls(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NumberOfCalls = {read=_scw_Get_NumberOfCalls};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalTalkTime() { int __r; HRESULT __hr = Get_TotalTalkTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalTalkTime = {read=_scw_Get_TotalTalkTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AverageTalkTime() { int __r; HRESULT __hr = Get_AverageTalkTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AverageTalkTime = {read=_scw_Get_AverageTalkTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalCallTime() { int __r; HRESULT __hr = Get_TotalCallTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalCallTime = {read=_scw_Get_TotalCallTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AverageCallTime() { int __r; HRESULT __hr = Get_AverageCallTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AverageCallTime = {read=_scw_Get_AverageCallTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalWrapUpTime() { int __r; HRESULT __hr = Get_TotalWrapUpTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalWrapUpTime = {read=_scw_Get_TotalWrapUpTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AverageWrapUpTime() { int __r; HRESULT __hr = Get_AverageWrapUpTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AverageWrapUpTime = {read=_scw_Get_AverageWrapUpTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::Currency _scw_Get_ACDCallRate() { System::Currency __r; HRESULT __hr = Get_ACDCallRate(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::Currency ACDCallRate = {read=_scw_Get_ACDCallRate};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_LongestTimeToAnswer() { int __r; HRESULT __hr = Get_LongestTimeToAnswer(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int LongestTimeToAnswer = {read=_scw_Get_LongestTimeToAnswer};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AverageTimeToAnswer() { int __r; HRESULT __hr = Get_AverageTimeToAnswer(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AverageTimeToAnswer = {read=_scw_Get_AverageTimeToAnswer};
};

__interface  INTERFACE_UUID("{5AFC3148-4BCC-11D1-BF80-00805FC147D3}") ITACDGroup  : public IDispatch 
{
	virtual HRESULT __safecall Get_Name(System::WideString &__Get_Name_result) = 0 ;
	virtual HRESULT __safecall EnumerateQueues(_di_IEnumQueue &__EnumerateQueues_result) = 0 ;
	virtual HRESULT __safecall Get_Queues(System::OleVariant &__Get_Queues_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Name() { System::WideString __r; HRESULT __hr = Get_Name(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Name = {read=_scw_Get_Name};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Queues() { System::OleVariant __r; HRESULT __hr = Get_Queues(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Queues = {read=_scw_Get_Queues};
};

__interface  INTERFACE_UUID("{5AFC3158-4BCC-11D1-BF80-00805FC147D3}") IEnumQueue  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITQueue &ppElements, /* out */ unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumQueue &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{5AFC3149-4BCC-11D1-BF80-00805FC147D3}") ITQueue  : public IDispatch 
{
	virtual HRESULT __safecall Set_MeasurementPeriod(int plPeriod) = 0 ;
	virtual HRESULT __safecall Get_MeasurementPeriod(int &__Get_MeasurementPeriod_result) = 0 ;
	virtual HRESULT __safecall Get_TotalCallsQueued(int &__Get_TotalCallsQueued_result) = 0 ;
	virtual HRESULT __safecall Get_CurrentCallsQueued(int &__Get_CurrentCallsQueued_result) = 0 ;
	virtual HRESULT __safecall Get_TotalCallsAbandoned(int &__Get_TotalCallsAbandoned_result) = 0 ;
	virtual HRESULT __safecall Get_TotalCallsFlowedIn(int &__Get_TotalCallsFlowedIn_result) = 0 ;
	virtual HRESULT __safecall Get_TotalCallsFlowedOut(int &__Get_TotalCallsFlowedOut_result) = 0 ;
	virtual HRESULT __safecall Get_LongestEverWaitTime(int &__Get_LongestEverWaitTime_result) = 0 ;
	virtual HRESULT __safecall Get_CurrentLongestWaitTime(int &__Get_CurrentLongestWaitTime_result) = 0 ;
	virtual HRESULT __safecall Get_AverageWaitTime(int &__Get_AverageWaitTime_result) = 0 ;
	virtual HRESULT __safecall Get_FinalDisposition(int &__Get_FinalDisposition_result) = 0 ;
	virtual HRESULT __safecall Get_Name(System::WideString &__Get_Name_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MeasurementPeriod() { int __r; HRESULT __hr = Get_MeasurementPeriod(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MeasurementPeriod = {read=_scw_Get_MeasurementPeriod, write=Set_MeasurementPeriod};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalCallsQueued() { int __r; HRESULT __hr = Get_TotalCallsQueued(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalCallsQueued = {read=_scw_Get_TotalCallsQueued};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CurrentCallsQueued() { int __r; HRESULT __hr = Get_CurrentCallsQueued(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CurrentCallsQueued = {read=_scw_Get_CurrentCallsQueued};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalCallsAbandoned() { int __r; HRESULT __hr = Get_TotalCallsAbandoned(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalCallsAbandoned = {read=_scw_Get_TotalCallsAbandoned};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalCallsFlowedIn() { int __r; HRESULT __hr = Get_TotalCallsFlowedIn(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalCallsFlowedIn = {read=_scw_Get_TotalCallsFlowedIn};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TotalCallsFlowedOut() { int __r; HRESULT __hr = Get_TotalCallsFlowedOut(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TotalCallsFlowedOut = {read=_scw_Get_TotalCallsFlowedOut};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_LongestEverWaitTime() { int __r; HRESULT __hr = Get_LongestEverWaitTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int LongestEverWaitTime = {read=_scw_Get_LongestEverWaitTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CurrentLongestWaitTime() { int __r; HRESULT __hr = Get_CurrentLongestWaitTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CurrentLongestWaitTime = {read=_scw_Get_CurrentLongestWaitTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AverageWaitTime() { int __r; HRESULT __hr = Get_AverageWaitTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AverageWaitTime = {read=_scw_Get_AverageWaitTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_FinalDisposition() { int __r; HRESULT __hr = Get_FinalDisposition(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int FinalDisposition = {read=_scw_Get_FinalDisposition};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Name() { System::WideString __r; HRESULT __hr = Get_Name(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Name = {read=_scw_Get_Name};
};

__interface  INTERFACE_UUID("{5AFC314A-4BCC-11D1-BF80-00805FC147D3}") ITAgentEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Agent(_di_ITAgent &__Get_Agent_result) = 0 ;
	virtual HRESULT __safecall Get_Event(Winapi::Activex::TOleEnum &__Get_Event_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITAgent _scw_Get_Agent() { _di_ITAgent __r; HRESULT __hr = Get_Agent(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITAgent Agent = {read=_scw_Get_Agent};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Event() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Event(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Event = {read=_scw_Get_Event};
};

__interface  INTERFACE_UUID("{5AFC314B-4BCC-11D1-BF80-00805FC147D3}") ITAgentSessionEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Session(_di_ITAgentSession &__Get_Session_result) = 0 ;
	virtual HRESULT __safecall Get_Event(Winapi::Activex::TOleEnum &__Get_Event_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITAgentSession _scw_Get_Session() { _di_ITAgentSession __r; HRESULT __hr = Get_Session(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITAgentSession Session = {read=_scw_Get_Session};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Event() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Event(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Event = {read=_scw_Get_Event};
};

__interface  INTERFACE_UUID("{297F3032-BD11-11D1-A0A7-00805FC147D3}") ITACDGroupEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Group(_di_ITACDGroup &__Get_Group_result) = 0 ;
	virtual HRESULT __safecall Get_Event(Winapi::Activex::TOleEnum &__Get_Event_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITACDGroup _scw_Get_Group() { _di_ITACDGroup __r; HRESULT __hr = Get_Group(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITACDGroup Group = {read=_scw_Get_Group};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Event() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Event(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Event = {read=_scw_Get_Event};
};

__interface  INTERFACE_UUID("{297F3033-BD11-11D1-A0A7-00805FC147D3}") ITQueueEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Queue(_di_ITQueue &__Get_Queue_result) = 0 ;
	virtual HRESULT __safecall Get_Event(Winapi::Activex::TOleEnum &__Get_Event_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITQueue _scw_Get_Queue() { _di_ITQueue __r; HRESULT __hr = Get_Queue(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITQueue Queue = {read=_scw_Get_Queue};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Event() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Event(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Event = {read=_scw_Get_Event};
};

__interface  INTERFACE_UUID("{5AFC3154-4BCC-11D1-BF80-00805FC147D3}") ITTAPICallCenter  : public IDispatch 
{
	virtual HRESULT __safecall EnumerateAgentHandlers(_di_IEnumAgentHandler &__EnumerateAgentHandlers_result) = 0 ;
	virtual HRESULT __safecall Get_AgentHandlers(System::OleVariant &__Get_AgentHandlers_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_AgentHandlers() { System::OleVariant __r; HRESULT __hr = Get_AgentHandlers(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant AgentHandlers = {read=_scw_Get_AgentHandlers};
};

__interface  INTERFACE_UUID("{587E8C28-9802-11D1-A0A4-00805FC147D3}") IEnumAgentHandler  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITAgentHandler &ppElements, /* out */ unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumAgentHandler &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{587E8C22-9802-11D1-A0A4-00805FC147D3}") ITAgentHandler  : public IDispatch 
{
	virtual HRESULT __safecall Get_Name(System::WideString &__Get_Name_result) = 0 ;
	virtual HRESULT __safecall CreateAgent(_di_ITAgent &__CreateAgent_result) = 0 ;
	virtual HRESULT __safecall CreateAgentWithID(const System::WideString pID, const System::WideString pPIN, _di_ITAgent &__CreateAgentWithID_result) = 0 ;
	virtual HRESULT __safecall EnumerateACDGroups(_di_IEnumACDGroup &__EnumerateACDGroups_result) = 0 ;
	virtual HRESULT __safecall EnumerateUsableAddresses(_di_IEnumAddress &__EnumerateUsableAddresses_result) = 0 ;
	virtual HRESULT __safecall Get_ACDGroups(System::OleVariant &__Get_ACDGroups_result) = 0 ;
	virtual HRESULT __safecall Get_UsableAddresses(System::OleVariant &__Get_UsableAddresses_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Name() { System::WideString __r; HRESULT __hr = Get_Name(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Name = {read=_scw_Get_Name};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_ACDGroups() { System::OleVariant __r; HRESULT __hr = Get_ACDGroups(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant ACDGroups = {read=_scw_Get_ACDGroups};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_UsableAddresses() { System::OleVariant __r; HRESULT __hr = Get_UsableAddresses(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant UsableAddresses = {read=_scw_Get_UsableAddresses};
};

__interface  INTERFACE_UUID("{5AFC3157-4BCC-11D1-BF80-00805FC147D3}") IEnumACDGroup  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITACDGroup &ppElements, /* out */ unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumACDGroup &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{297F3034-BD11-11D1-A0A7-00805FC147D3}") ITAgentHandlerEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_AgentHandler(_di_ITAgentHandler &__Get_AgentHandler_result) = 0 ;
	virtual HRESULT __safecall Get_Event(Winapi::Activex::TOleEnum &__Get_Event_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITAgentHandler _scw_Get_AgentHandler() { _di_ITAgentHandler __r; HRESULT __hr = Get_AgentHandler(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITAgentHandler AgentHandler = {read=_scw_Get_AgentHandler};
	#pragma option push -w-inl
	/* safecall wrapper */ inline Winapi::Activex::TOleEnum _scw_Get_Event() { Winapi::Activex::TOleEnum __r; HRESULT __hr = Get_Event(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property Winapi::Activex::TOleEnum Event = {read=_scw_Get_Event};
};

__interface  INTERFACE_UUID("{5D4B65F9-E51C-11D1-A02F-00C04FB6809F}") ITCallInfoChangeEvent  : public IDispatch 
{
	virtual HRESULT __stdcall Get_Call(/* out */ _di_ITCallInfo &ppCall) = 0 ;
	virtual HRESULT __stdcall Get_Cause(/* out */ Winapi::Activex::TOleEnum &pCIC) = 0 ;
	virtual HRESULT __stdcall Get_CallbackInstance(/* out */ int &plCallbackInstance) = 0 ;
};

__interface  INTERFACE_UUID("{AC48FFDE-F8C4-11D1-A030-00C04FB6809F}") ITRequestEvent  : public IDispatch 
{
	virtual HRESULT __stdcall Get_RegistrationInstance(/* out */ int &plRegistrationInstance) = 0 ;
	virtual HRESULT __stdcall Get_RequestMode(/* out */ int &plRequestMode) = 0 ;
	virtual HRESULT __stdcall Get_DestAddress(/* out */ System::WideString &ppDestAddress) = 0 ;
	virtual HRESULT __stdcall Get_AppName(/* out */ System::WideString &ppAppName) = 0 ;
	virtual HRESULT __stdcall Get_CalledParty(/* out */ System::WideString &ppCalledParty) = 0 ;
	virtual HRESULT __stdcall Get_Comment(/* out */ System::WideString &ppComment) = 0 ;
};

__interface  INTERFACE_UUID("{B1EFC384-9355-11D0-835C-00AA003CCABD}") ITMediaSupport  : public IDispatch 
{
	virtual HRESULT __safecall Get_MediaTypes(int &__Get_MediaTypes_result) = 0 ;
	virtual HRESULT __safecall QueryMediaType(int lMediaType, System::WordBool &__QueryMediaType_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MediaTypes() { int __r; HRESULT __hr = Get_MediaTypes(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MediaTypes = {read=_scw_Get_MediaTypes};
};

__interface  INTERFACE_UUID("{B1EFC385-9355-11D0-835C-00AA003CCABD}") ITTerminalSupport  : public IDispatch 
{
	virtual HRESULT __safecall Get_StaticTerminals(System::OleVariant &__Get_StaticTerminals_result) = 0 ;
	virtual HRESULT __safecall EnumerateStaticTerminals(_di_IEnumTerminal &__EnumerateStaticTerminals_result) = 0 ;
	virtual HRESULT __safecall Get_DynamicTerminalClasses(System::OleVariant &__Get_DynamicTerminalClasses_result) = 0 ;
	virtual HRESULT __safecall EnumerateDynamicTerminalClasses(_di_IEnumTerminalClass &__EnumerateDynamicTerminalClasses_result) = 0 ;
	virtual HRESULT __safecall CreateTerminal(const System::WideString pTerminalClass, int lMediaType, Winapi::Activex::TOleEnum Direction, _di_ITTerminal &__CreateTerminal_result) = 0 ;
	virtual HRESULT __safecall GetDefaultStaticTerminal(int lMediaType, Winapi::Activex::TOleEnum Direction, _di_ITTerminal &__GetDefaultStaticTerminal_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_StaticTerminals() { System::OleVariant __r; HRESULT __hr = Get_StaticTerminals(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant StaticTerminals = {read=_scw_Get_StaticTerminals};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_DynamicTerminalClasses() { System::OleVariant __r; HRESULT __hr = Get_DynamicTerminalClasses(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant DynamicTerminalClasses = {read=_scw_Get_DynamicTerminalClasses};
};

__interface  INTERFACE_UUID("{AE269CF5-935E-11D0-835C-00AA003CCABD}") IEnumTerminalClass  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ GUID &pElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumTerminalClass &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{EE3BD604-3868-11D2-A045-00C04FB6809F}") ITStreamControl  : public IDispatch 
{
	virtual HRESULT __safecall CreateStream(int lMediaType, Winapi::Activex::TOleEnum td, _di_ITStream &__CreateStream_result) = 0 ;
	virtual HRESULT __safecall RemoveStream(const _di_ITStream pStream) = 0 ;
	virtual HRESULT __safecall EnumerateStreams(/* out */ _di_IEnumStream &ppEnumStream) = 0 ;
	virtual HRESULT __safecall Get_Streams(System::OleVariant &__Get_Streams_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Streams() { System::OleVariant __r; HRESULT __hr = Get_Streams(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Streams = {read=_scw_Get_Streams};
};

__interface  INTERFACE_UUID("{EE3BD606-3868-11D2-A045-00C04FB6809F}") IEnumStream  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITStream &ppElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumStream &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{EE3BD607-3868-11D2-A045-00C04FB6809F}") ITSubStreamControl  : public IDispatch 
{
	virtual HRESULT __safecall CreateSubStream(_di_ITSubStream &__CreateSubStream_result) = 0 ;
	virtual HRESULT __safecall RemoveSubStream(const _di_ITSubStream pSubStream) = 0 ;
	virtual HRESULT __safecall EnumerateSubStreams(/* out */ _di_IEnumSubStream &ppEnumSubStream) = 0 ;
	virtual HRESULT __safecall Get_SubStreams(System::OleVariant &__Get_SubStreams_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_SubStreams() { System::OleVariant __r; HRESULT __hr = Get_SubStreams(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant SubStreams = {read=_scw_Get_SubStreams};
};

__interface  INTERFACE_UUID("{EE3BD608-3868-11D2-A045-00C04FB6809F}") ITSubStream  : public IDispatch 
{
	virtual HRESULT __safecall StartSubStream(void) = 0 ;
	virtual HRESULT __safecall PauseSubStream(void) = 0 ;
	virtual HRESULT __safecall StopSubStream(void) = 0 ;
	virtual HRESULT __safecall SelectTerminal(const _di_ITTerminal pTerminal) = 0 ;
	virtual HRESULT __safecall UnselectTerminal(const _di_ITTerminal pTerminal) = 0 ;
	virtual HRESULT __safecall EnumerateTerminals(/* out */ _di_IEnumTerminal &ppEnumTerminal) = 0 ;
	virtual HRESULT __safecall Get_Terminals(System::OleVariant &__Get_Terminals_result) = 0 ;
	virtual HRESULT __safecall Get_Stream(_di_ITStream &__Get_Stream_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::OleVariant _scw_Get_Terminals() { System::OleVariant __r; HRESULT __hr = Get_Terminals(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::OleVariant Terminals = {read=_scw_Get_Terminals};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITStream _scw_Get_Stream() { _di_ITStream __r; HRESULT __hr = Get_Stream(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITStream Stream = {read=_scw_Get_Stream};
};

__interface  INTERFACE_UUID("{EE3BD609-3868-11D2-A045-00C04FB6809F}") IEnumSubStream  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned celt, /* out */ _di_ITSubStream &ppElements, unsigned &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned celt) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumSubStream &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{AB493640-4C0B-11D2-A046-00C04FB6809F}") ITLegacyAddressMediaControl  : public System::IInterface 
{
	virtual HRESULT __stdcall GetID(const System::WideString pDeviceClass, /* out */ unsigned &pdwSize, /* out */ PByte1 &ppDeviceID) = 0 ;
	virtual HRESULT __stdcall GetDevConfig(const System::WideString pDeviceClass, /* out */ unsigned &pdwSize, /* out */ PByte1 &ppDeviceConfig) = 0 ;
	virtual HRESULT __stdcall SetDevConfig(const System::WideString pDeviceClass, unsigned dwSize, System::Byte &pDeviceConfig) = 0 ;
};

__interface  INTERFACE_UUID("{D624582F-CC23-4436-B8A5-47C625C8045D}") ITLegacyCallMediaControl  : public IDispatch 
{
	virtual HRESULT __stdcall DetectDigits(int DigitMode) = 0 ;
	virtual HRESULT __stdcall GenerateDigits(const System::WideString pDigits, int DigitMode) = 0 ;
	virtual HRESULT __stdcall GetID(const System::WideString pDeviceClass, /* out */ unsigned &pdwSize, /* out */ PByte1 &ppDeviceID) = 0 ;
	virtual HRESULT __stdcall SetMediaType(int lMediaType) = 0 ;
	virtual HRESULT __stdcall MonitorMedia(int lMediaType) = 0 ;
};

__interface  INTERFACE_UUID("{80D3BFAC-57D9-11D2-A04A-00C04FB6809F}") ITDigitDetectionEvent  : public IDispatch 
{
	virtual HRESULT __stdcall Get_Call(/* out */ _di_ITCallInfo &ppCallInfo) = 0 ;
	virtual HRESULT __stdcall Get_Digit(/* out */ System::Byte &pucDigit) = 0 ;
	virtual HRESULT __stdcall Get_DigitMode(/* out */ int &pDigitMode) = 0 ;
	virtual HRESULT __stdcall Get_TickCount(/* out */ int &plTickCount) = 0 ;
	virtual HRESULT __stdcall Get_CallbackInstance(/* out */ int &plCallbackInstance) = 0 ;
};

__interface  INTERFACE_UUID("{80D3BFAD-57D9-11D2-A04A-00C04FB6809F}") ITDigitGenerationEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Call(_di_ITCallInfo &__Get_Call_result) = 0 ;
	virtual HRESULT __safecall Get_GenerationTermination(int &__Get_GenerationTermination_result) = 0 ;
	virtual HRESULT __safecall Get_TickCount(int &__Get_TickCount_result) = 0 ;
	virtual HRESULT __safecall Get_CallbackInstance(int &__Get_CallbackInstance_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITCallInfo _scw_Get_Call() { _di_ITCallInfo __r; HRESULT __hr = Get_Call(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITCallInfo Call = {read=_scw_Get_Call};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_GenerationTermination() { int __r; HRESULT __hr = Get_GenerationTermination(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int GenerationTermination = {read=_scw_Get_GenerationTermination};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_TickCount() { int __r; HRESULT __hr = Get_TickCount(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int TickCount = {read=_scw_Get_TickCount};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CallbackInstance() { int __r; HRESULT __hr = Get_CallbackInstance(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CallbackInstance = {read=_scw_Get_CallbackInstance};
};

__interface  INTERFACE_UUID("{0E269CD0-10D4-4121-9C22-9C85D625650D}") ITPrivateEvent  : public IDispatch 
{
	virtual HRESULT __safecall Get_Address(_di_ITAddress &__Get_Address_result) = 0 ;
	virtual HRESULT __safecall Get_Call(_di_ITCallInfo &__Get_Call_result) = 0 ;
	virtual HRESULT __safecall Get_CallHub(_di_ITCallHub &__Get_CallHub_result) = 0 ;
	virtual HRESULT __safecall Get_EventCode(int &__Get_EventCode_result) = 0 ;
	virtual HRESULT __safecall Get_EventInterface(_di_IDispatch &__Get_EventInterface_result) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITAddress _scw_Get_Address() { _di_ITAddress __r; HRESULT __hr = Get_Address(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITAddress Address = {read=_scw_Get_Address};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITCallInfo _scw_Get_Call() { _di_ITCallInfo __r; HRESULT __hr = Get_Call(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITCallInfo Call = {read=_scw_Get_Call};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_ITCallHub _scw_Get_CallHub() { _di_ITCallHub __r; HRESULT __hr = Get_CallHub(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_ITCallHub CallHub = {read=_scw_Get_CallHub};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_EventCode() { int __r; HRESULT __hr = Get_EventCode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int EventCode = {read=_scw_Get_EventCode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline _di_IDispatch _scw_Get_EventInterface() { _di_IDispatch __r; HRESULT __hr = Get_EventInterface(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property _di_IDispatch EventInterface = {read=_scw_Get_EventInterface};
};

__interface  INTERFACE_UUID("{E9225295-C759-11D1-A02B-00C04FB6809F}") ITDispatchMapper  : public IDispatch 
{
	virtual HRESULT __stdcall QueryDispatchInterface(const System::WideString pIID, const _di_IDispatch pInterfaceToMap, /* out */ _di_IDispatch &ppReturnedInterface) = 0 ;
};

__interface  INTERFACE_UUID("{AC48FFDF-F8C4-11D1-A030-00C04FB6809F}") ITRequest  : public IDispatch 
{
	virtual HRESULT __stdcall MakeCall(const System::WideString pDestAddress, const System::WideString pAppName, const System::WideString pCalledParty, const System::WideString pComment) = 0 ;
};

typedef int HSEMAPHORE;

typedef System::Comp TReference_Time;

__interface  INTERFACE_UUID("{56A86897-0AD4-11CE-B03A-0020AF0BA770}") IReferenceClock  : public System::IInterface 
{
	virtual HRESULT __stdcall GetTime(System::Comp &pTime) = 0 ;
	virtual HRESULT __stdcall AdviseTime(System::Comp baseTime, System::Comp streamTime, NativeUInt hEvent, unsigned &pdwAdviseCookie) = 0 ;
	virtual HRESULT __stdcall AdvisePeriodic(System::Comp startTime, System::Comp periodTime, int hSemaphore, unsigned &pdwAdviseCookie) = 0 ;
	virtual HRESULT __stdcall Unadvise(unsigned dwAdviseCookie) = 0 ;
};

enum DECLSPEC_DENUM TFilter_State : unsigned char { State_Stopped, State_Paused, State_Running };

__interface  INTERFACE_UUID("{56A86899-0AD4-11CE-B03A-0020AF0BA770}") IMediaFilter  : public IPersist 
{
	virtual HRESULT __stdcall Stop(void) = 0 ;
	virtual HRESULT __stdcall Pause(void) = 0 ;
	virtual HRESULT __stdcall Run(System::Comp tStart) = 0 ;
	virtual HRESULT __stdcall GetState(unsigned dwMilliSecsTimeout, TFilter_State &State) = 0 ;
	virtual HRESULT __stdcall SetSyncSource(_di_IReferenceClock pClock) = 0 ;
	virtual HRESULT __stdcall GetSyncSource(/* out */ _di_IReferenceClock &pClock) = 0 ;
};

struct DECLSPEC_DRECORD TAM_Media_Type
{
public:
	GUID majortype;
	GUID subtype;
	System::LongBool bFixedSizeSamples;
	System::LongBool bTemporalCompression;
	unsigned lSampleSize;
	GUID formattype;
	System::_di_IInterface pUnk;
	unsigned cbFormat;
	void *pbFormat;
};


typedef TAM_Media_Type *PAM_Media_Type;

enum DECLSPEC_DENUM TPin_Direction : unsigned char { PINDIR_INPUT, PINDIR_OUTPUT };

struct DECLSPEC_DRECORD TPin_Info
{
public:
	_di_IBaseFilter pFilter;
	TPin_Direction dir;
	System::StaticArray<System::WideChar, 128> achName;
};


__interface  INTERFACE_UUID("{89C31040-846B-11CE-97D3-00AA0055595A}") IEnumMediaTypes  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned cMediaTypes, PAM_Media_Type &ppMediaTypes, unsigned &pcFetched) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned cMediaTypes) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumMediaTypes &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{56A86891-0AD4-11CE-B03A-0020AF0BA770}") IPin  : public System::IInterface 
{
	virtual HRESULT __stdcall Connect(_di_IPin pReceivePin, const TAM_Media_Type &pmt) = 0 ;
	virtual HRESULT __stdcall ReceiveConnection(_di_IPin pConnector, const TAM_Media_Type &pmt) = 0 ;
	virtual HRESULT __stdcall Disconnect(void) = 0 ;
	virtual HRESULT __stdcall ConnectedTo(/* out */ _di_IPin &pPin) = 0 ;
	virtual HRESULT __stdcall ConnectionMediaType(TAM_Media_Type &pmt) = 0 ;
	virtual HRESULT __stdcall QueryPinInfo(TPin_Info &pInfo) = 0 ;
	virtual HRESULT __stdcall QueryDirection(TPin_Direction &pPinDir) = 0 ;
	virtual HRESULT __stdcall QueryId(System::WideChar * &Id) = 0 ;
	virtual HRESULT __stdcall QueryAccept(const TAM_Media_Type &pmt) = 0 ;
	virtual HRESULT __stdcall EnumMediaTypes(/* out */ _di_IEnumMediaTypes &ppEnum) = 0 ;
	virtual HRESULT __stdcall QueryInternalConnections(/* out */ _di_IPin &apPin, unsigned &nPin) = 0 ;
	virtual HRESULT __stdcall EndOfStream(void) = 0 ;
	virtual HRESULT __stdcall BeginFlush(void) = 0 ;
	virtual HRESULT __stdcall EndFlush(void) = 0 ;
	virtual HRESULT __stdcall NewSegment(System::Comp tStart, System::Comp tStop, double dRate) = 0 ;
};

__interface  INTERFACE_UUID("{56A86892-0AD4-11CE-B03A-0020AF0BA770}") IEnumPins  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned cPins, /* out */ _di_IPin &ppPins, unsigned &pcFetched) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned cPins) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumPins &ppEnum) = 0 ;
};

struct DECLSPEC_DRECORD TFilterInfo
{
public:
	System::StaticArray<System::WideChar, 128> achName;
	_di_IFilterGraph pGraph;
};


__interface  INTERFACE_UUID("{56A86895-0AD4-11CE-B03A-0020AF0BA770}") IBaseFilter  : public IMediaFilter 
{
	virtual HRESULT __stdcall EnumPins(/* out */ _di_IEnumPins &ppEnum) = 0 ;
	virtual HRESULT __stdcall FindPin(System::WideChar * Id, /* out */ _di_IPin &ppPin) = 0 ;
	virtual HRESULT __stdcall QueryFilterInfo(TFilterInfo &pInfo) = 0 ;
	virtual HRESULT __stdcall JoinFilterGraph(_di_IFilterGraph pGraph, System::WideChar * pName) = 0 ;
	virtual HRESULT __stdcall QueryVendorInfo(System::WideChar * &pVendorInfo) = 0 ;
};

__interface  INTERFACE_UUID("{56A86893-0AD4-11CE-B03A-0020AF0BA770}") IEnumFilters  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(unsigned cFilters, /* out */ _di_IBaseFilter &ppFilter, unsigned &pcFetched) = 0 ;
	virtual HRESULT __stdcall Skip(unsigned cFilters) = 0 ;
	virtual HRESULT __stdcall Reset(void) = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumFilters &ppEnum) = 0 ;
};

__interface  INTERFACE_UUID("{56A8689F-0AD4-11CE-B03A-0020AF0BA770}") IFilterGraph  : public System::IInterface 
{
	virtual HRESULT __stdcall AddFilter(_di_IBaseFilter pFilter, System::WideChar * pName) = 0 ;
	virtual HRESULT __stdcall RemoveFilter(_di_IBaseFilter pFilter) = 0 ;
	virtual HRESULT __stdcall EnumFilters(/* out */ _di_IEnumFilters &ppEnum) = 0 ;
	virtual HRESULT __stdcall FindFilterByName(System::WideChar * pName, /* out */ _di_IBaseFilter &ppFilter) = 0 ;
	virtual HRESULT __stdcall ConnectDirect(_di_IPin ppinOut, _di_IPin ppinIn, const TAM_Media_Type &pmt) = 0 ;
	virtual HRESULT __stdcall Reconnect(_di_IPin ppin) = 0 ;
	virtual HRESULT __stdcall Disconnect(_di_IPin ppin) = 0 ;
	virtual HRESULT __stdcall SetDefaultSyncSource(void) = 0 ;
};

__interface  INTERFACE_UUID("{56A868A9-0AD4-11CE-B03A-0020AF0BA770}") IGraphBuilder  : public IFilterGraph 
{
	virtual HRESULT __stdcall Connect(_di_IPin ppinOut, _di_IPin ppinIn) = 0 ;
	virtual HRESULT __stdcall Render(_di_IPin ppinOut) = 0 ;
	virtual HRESULT __stdcall RenderFile(System::WideChar * lpcwstrFile, System::WideChar * lpcwstrPlayList) = 0 ;
	virtual HRESULT __stdcall AddSourceFilter(System::WideChar * lpcwstrFileName, System::WideChar * lpcwstrFilterName, /* out */ _di_IBaseFilter &ppFilter) = 0 ;
	virtual HRESULT __stdcall SetLogFile(NativeUInt hFile) = 0 ;
	virtual HRESULT __stdcall Abort(void) = 0 ;
	virtual HRESULT __stdcall ShouldOperationContinue(void) = 0 ;
};

__interface  INTERFACE_UUID("{A2104830-7C70-11CF-8BCE-00AA00A3F1A6}") IFileSinkFilter  : public System::IInterface 
{
	virtual HRESULT __stdcall SetFileName(System::WideChar * pszFileName, const TAM_Media_Type &pmt) = 0 ;
	virtual HRESULT __stdcall GetCurFile(System::WideChar * &ppszFileName, TAM_Media_Type &pmt) = 0 ;
};

__interface  INTERFACE_UUID("{670D1D20-A068-11D0-B3F0-00AA003761C5}") IAMCopyCaptureFileProgress  : public System::IInterface 
{
	virtual HRESULT __stdcall Progress(int iProgress) = 0 ;
};

__interface  INTERFACE_UUID("{93E5A4E0-2D50-11D2-ABFA-00A0C9C6E38D}") ICaptureGraphBuilder2  : public System::IInterface 
{
	virtual HRESULT __stdcall SetFiltergraph(_di_IGraphBuilder pfg) = 0 ;
	virtual HRESULT __stdcall GetFiltergraph(/* out */ _di_IGraphBuilder &ppfg) = 0 ;
	virtual HRESULT __stdcall SetOutputFileName(System::PGUID pType, System::WideChar * lpstrFile, /* out */ _di_IBaseFilter &ppf, /* out */ _di_IFileSinkFilter &ppSink) = 0 ;
	virtual HRESULT __stdcall FindInterface(System::PGUID pCategory, System::PGUID pType, _di_IBaseFilter pf, System::PGUID riid, /* out */ void *ppint) = 0 ;
	virtual HRESULT __stdcall RenderStream(System::PGUID pCategory, System::PGUID pType, System::_di_IInterface pSource, _di_IBaseFilter pfCompressor, _di_IBaseFilter pfRenderer) = 0 ;
	virtual HRESULT __stdcall ControlStream(System::PGUID pCategory, System::PGUID pType, _di_IBaseFilter pFilter, System::Comp pstart, System::Comp pstop, System::Word wStartCookie, System::Word wStopCookie) = 0 ;
	virtual HRESULT __stdcall AllocCapFile(System::WideChar * lpstr, System::Comp dwlSize) = 0 ;
	virtual HRESULT __stdcall CopyCaptureFile(System::WideChar * lpwstrOld, System::WideChar * lpwstrNew, int fAllowEscAbort, _di_IAMCopyCaptureFileProgress pCallback) = 0 ;
	virtual HRESULT __stdcall FindPin(System::_di_IInterface pSource, TPin_Direction pindir, System::PGUID pCategory, System::PGUID pType, System::LongBool fUnconnected, int num, /* out */ _di_IPin &ppPin) = 0 ;
};

typedef int OAHWND;

__interface  INTERFACE_UUID("{56A868B4-0AD4-11CE-B03A-0020AF0BA770}") IVideoWindow  : public IDispatch 
{
	virtual HRESULT __stdcall put_Caption(System::WideChar * strCaption) = 0 ;
	virtual HRESULT __stdcall get_Caption(System::WideChar * &strCaption) = 0 ;
	virtual HRESULT __stdcall put_WindowStyle(int WindowStyle) = 0 ;
	virtual HRESULT __stdcall get_WindowStyle(int &WindowStyle) = 0 ;
	virtual HRESULT __stdcall put_WindowStyleEx(int WindowStyleEx) = 0 ;
	virtual HRESULT __stdcall get_WindowStyleEx(int &WindowStyleEx) = 0 ;
	virtual HRESULT __stdcall put_AutoShow(System::LongBool AutoShow) = 0 ;
	virtual HRESULT __stdcall get_AutoShow(System::LongBool &AutoShow) = 0 ;
	virtual HRESULT __stdcall put_WindowState(int WindowState) = 0 ;
	virtual HRESULT __stdcall get_WindowState(int &WindowState) = 0 ;
	virtual HRESULT __stdcall put_BackgroundPalette(int BackgroundPalette) = 0 ;
	virtual HRESULT __stdcall get_BackgroundPalette(int &pBackgroundPalette) = 0 ;
	virtual HRESULT __stdcall put_Visible(System::LongBool Visible) = 0 ;
	virtual HRESULT __stdcall get_Visible(System::LongBool &pVisible) = 0 ;
	virtual HRESULT __stdcall put_Left(int Left) = 0 ;
	virtual HRESULT __stdcall get_Left(int &pLeft) = 0 ;
	virtual HRESULT __stdcall put_Width(int Width) = 0 ;
	virtual HRESULT __stdcall get_Width(int &pWidth) = 0 ;
	virtual HRESULT __stdcall put_Top(int Top) = 0 ;
	virtual HRESULT __stdcall get_Top(int &pTop) = 0 ;
	virtual HRESULT __stdcall put_Height(int Height) = 0 ;
	virtual HRESULT __stdcall get_Height(int &pHeight) = 0 ;
	virtual HRESULT __stdcall put_Owner(int Owner) = 0 ;
	virtual HRESULT __stdcall get_Owner(int &Owner) = 0 ;
	virtual HRESULT __stdcall put_MessageDrain(int Drain) = 0 ;
	virtual HRESULT __stdcall get_MessageDrain(int &Drain) = 0 ;
	virtual HRESULT __stdcall get_BorderColor(int &Color) = 0 ;
	virtual HRESULT __stdcall put_BorderColor(int Color) = 0 ;
	virtual HRESULT __stdcall get_FullScreenMode(System::LongBool &FullScreenMode) = 0 ;
	virtual HRESULT __stdcall put_FullScreenMode(System::LongBool FullScreenMode) = 0 ;
	virtual HRESULT __stdcall SetWindowForeground(int Focus) = 0 ;
	virtual HRESULT __stdcall NotifyOwnerMessage(int hwnd, int uMsg, int wParam, int lParam) = 0 ;
	virtual HRESULT __stdcall SetWindowPosition(int Left, int Top, int Width, int Height) = 0 ;
	virtual HRESULT __stdcall GetWindowPosition(int &pLeft, int &pTop, int &pWidth, int &pHeight) = 0 ;
	virtual HRESULT __stdcall GetMinIdealImageSize(int &pWidth, int &pHeight) = 0 ;
	virtual HRESULT __stdcall GetMaxIdealImageSize(int &pWidth, int &pHeight) = 0 ;
	virtual HRESULT __stdcall GetRestorePosition(int &pLeft, int &pTop, int &pWidth, int &pHeight) = 0 ;
	virtual HRESULT __stdcall HideCursor(System::LongBool HideCursor) = 0 ;
	virtual HRESULT __stdcall IsCursorHidden(System::LongBool &CursorHidden) = 0 ;
};

typedef int OAFilterState;

__interface  INTERFACE_UUID("{56A868B1-0AD4-11CE-B03A-0020AF0BA770}") IMediaControl  : public IDispatch 
{
	virtual HRESULT __stdcall Run(void) = 0 ;
	virtual HRESULT __stdcall Pause(void) = 0 ;
	virtual HRESULT __stdcall Stop(void) = 0 ;
	virtual HRESULT __stdcall GetState(int msTimeout, int &pfs) = 0 ;
	virtual HRESULT __stdcall RenderFile(System::WideChar * strFilename) = 0 ;
	virtual HRESULT __stdcall AddSourceFilter(System::WideChar * strFilename, _di_IDispatch ppUnk) = 0 ;
	virtual HRESULT __stdcall get_FilterCollection(/* out */ _di_IDispatch &ppUnk) = 0 ;
	virtual HRESULT __stdcall get_RegFilterCollection(/* out */ _di_IDispatch &ppUnk) = 0 ;
	virtual HRESULT __stdcall StopWhenReady(void) = 0 ;
};

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 TAPI3LibMajorVersion = System::Int8(0x4);
static const System::Int8 TAPI3LibMinorVersion = System::Int8(0x0);
extern DELPHI_PACKAGE GUID LIBID_TAPI3Lib;
extern DELPHI_PACKAGE GUID IID_ITCollection;
extern DELPHI_PACKAGE GUID IID_ITCallStateEvent;
extern DELPHI_PACKAGE GUID IID_ITCallInfo;
extern DELPHI_PACKAGE GUID IID_ITAddress;
extern DELPHI_PACKAGE GUID IID_ITTAPI;
extern DELPHI_PACKAGE GUID IID_IEnumAddress;
extern DELPHI_PACKAGE GUID IID_IEnumCallHub;
extern DELPHI_PACKAGE GUID IID_ITCallHub;
extern DELPHI_PACKAGE GUID IID_IEnumCall;
extern DELPHI_PACKAGE GUID IID_IEnumUnknown;
extern DELPHI_PACKAGE GUID IID_ITBasicCallControl;
extern DELPHI_PACKAGE GUID IID_ITForwardInformation;
extern DELPHI_PACKAGE GUID IID_ITCallNotificationEvent;
extern DELPHI_PACKAGE GUID IID_ITTAPIEventNotification;
extern DELPHI_PACKAGE GUID IID_ITBasicAudioTerminal;
extern DELPHI_PACKAGE GUID IID_ITCallHubEvent;
extern DELPHI_PACKAGE GUID IID_ITAddressCapabilities;
extern DELPHI_PACKAGE GUID IID_IEnumBstr;
extern DELPHI_PACKAGE GUID IID_ITQOSEvent;
extern DELPHI_PACKAGE GUID IID_ITAddressEvent;
extern DELPHI_PACKAGE GUID IID_ITTerminal;
extern DELPHI_PACKAGE GUID IID_ITCallMediaEvent;
extern DELPHI_PACKAGE GUID IID_ITStream;
extern DELPHI_PACKAGE GUID IID_IEnumTerminal;
extern DELPHI_PACKAGE GUID IID_ITTAPIObjectEvent;
extern DELPHI_PACKAGE GUID IID_ITAddressTranslation;
extern DELPHI_PACKAGE GUID IID_ITAddressTranslationInfo;
extern DELPHI_PACKAGE GUID IID_IEnumLocation;
extern DELPHI_PACKAGE GUID IID_ITLocationInfo;
extern DELPHI_PACKAGE GUID IID_IEnumCallingCard;
extern DELPHI_PACKAGE GUID IID_ITCallingCard;
extern DELPHI_PACKAGE GUID IID_ITAgent;
extern DELPHI_PACKAGE GUID IID_IEnumAgentSession;
extern DELPHI_PACKAGE GUID IID_ITAgentSession;
extern DELPHI_PACKAGE GUID IID_ITACDGroup;
extern DELPHI_PACKAGE GUID IID_IEnumQueue;
extern DELPHI_PACKAGE GUID IID_ITQueue;
extern DELPHI_PACKAGE GUID IID_ITAgentEvent;
extern DELPHI_PACKAGE GUID IID_ITAgentSessionEvent;
extern DELPHI_PACKAGE GUID IID_ITACDGroupEvent;
extern DELPHI_PACKAGE GUID IID_ITQueueEvent;
extern DELPHI_PACKAGE GUID IID_ITTAPICallCenter;
extern DELPHI_PACKAGE GUID IID_IEnumAgentHandler;
extern DELPHI_PACKAGE GUID IID_ITAgentHandler;
extern DELPHI_PACKAGE GUID IID_IEnumACDGroup;
extern DELPHI_PACKAGE GUID IID_ITAgentHandlerEvent;
extern DELPHI_PACKAGE GUID IID_ITCallInfoChangeEvent;
extern DELPHI_PACKAGE GUID IID_ITRequestEvent;
extern DELPHI_PACKAGE GUID IID_ITMediaSupport;
extern DELPHI_PACKAGE GUID IID_ITTerminalSupport;
extern DELPHI_PACKAGE GUID IID_IEnumTerminalClass;
extern DELPHI_PACKAGE GUID IID_ITStreamControl;
extern DELPHI_PACKAGE GUID IID_IEnumStream;
extern DELPHI_PACKAGE GUID IID_ITSubStreamControl;
extern DELPHI_PACKAGE GUID IID_ITSubStream;
extern DELPHI_PACKAGE GUID IID_IEnumSubStream;
extern DELPHI_PACKAGE GUID IID_ITLegacyAddressMediaControl;
extern DELPHI_PACKAGE GUID IID_ITLegacyCallMediaControl;
extern DELPHI_PACKAGE GUID IID_ITDigitDetectionEvent;
extern DELPHI_PACKAGE GUID IID_ITDigitGenerationEvent;
extern DELPHI_PACKAGE GUID IID_ITPrivateEvent;
extern DELPHI_PACKAGE GUID DIID_ITTAPIDispatchEventNotification;
extern DELPHI_PACKAGE GUID CLASS_TAPI;
extern DELPHI_PACKAGE GUID IID_ITDispatchMapper;
extern DELPHI_PACKAGE GUID CLASS_DispatchMapper;
extern DELPHI_PACKAGE GUID IID_ITRequest;
extern DELPHI_PACKAGE GUID CLASS_RequestMakeCall;
extern DELPHI_PACKAGE GUID CLSID_FilterGraph;
extern DELPHI_PACKAGE GUID CLSID_CaptureGraphBuilder2;
extern DELPHI_PACKAGE GUID IID_IVideoWindow;
extern DELPHI_PACKAGE GUID IID_IMediaControl;
extern DELPHI_PACKAGE GUID IID_IPin;
extern DELPHI_PACKAGE GUID IID_IEnumPins;
extern DELPHI_PACKAGE GUID IID_IEnumMediaTypes;
extern DELPHI_PACKAGE GUID IID_IFilterGraph;
extern DELPHI_PACKAGE GUID IID_IEnumFilters;
extern DELPHI_PACKAGE GUID IID_IMediaFilter;
extern DELPHI_PACKAGE GUID IID_IBaseFilter;
extern DELPHI_PACKAGE GUID IID_IReferenceClock;
extern DELPHI_PACKAGE GUID IID_IReferenceClock2;
extern DELPHI_PACKAGE GUID IID_IMediaSample;
extern DELPHI_PACKAGE GUID IID_IMediaSample2;
extern DELPHI_PACKAGE GUID IID_IMemAllocator;
extern DELPHI_PACKAGE GUID IID_IMemInputPin;
extern DELPHI_PACKAGE GUID IID_IAMovieSetup;
extern DELPHI_PACKAGE GUID IID_IMediaSeeking;
extern DELPHI_PACKAGE GUID IID_IEnumRegFilters;
extern DELPHI_PACKAGE GUID IID_IFilterMapper;
extern DELPHI_PACKAGE GUID IID_IFilterMapper2;
extern DELPHI_PACKAGE GUID IID_IQualityControl;
extern DELPHI_PACKAGE GUID IID_IOverlayNotify;
extern DELPHI_PACKAGE GUID IID_IOverlay;
extern DELPHI_PACKAGE GUID IID_IMediaEventSink;
extern DELPHI_PACKAGE GUID IID_IFileSourceFilter;
extern DELPHI_PACKAGE GUID IID_IFileSinkFilter;
extern DELPHI_PACKAGE GUID IID_IFileSinkFilter2;
extern DELPHI_PACKAGE GUID IID_IFileAsyncIO;
extern DELPHI_PACKAGE GUID IID_IGraphBuilder;
extern DELPHI_PACKAGE GUID IID_ICaptureGraphBuilder;
extern DELPHI_PACKAGE GUID IID_IAMCopyCaptureFileProgress;
extern DELPHI_PACKAGE GUID IID_IFilterGraph2;
extern DELPHI_PACKAGE GUID IID_IStreamBuilder;
extern DELPHI_PACKAGE GUID IID_IAsyncReader;
extern DELPHI_PACKAGE GUID IID_IGraphVersion;
extern DELPHI_PACKAGE GUID IID_IResourceConsumer;
extern DELPHI_PACKAGE GUID IID_IResourceManager;
extern DELPHI_PACKAGE GUID IID_IDistributorNotify;
extern DELPHI_PACKAGE GUID IID_IAMStreamControl;
extern DELPHI_PACKAGE GUID IID_ISeekingPassThru;
extern DELPHI_PACKAGE GUID IID_IAMStreamConfig;
extern DELPHI_PACKAGE GUID IID_IConfigInterleaving;
extern DELPHI_PACKAGE GUID IID_IConfigAviMux;
extern DELPHI_PACKAGE GUID IID_IAMVideoCompression;
extern DELPHI_PACKAGE GUID IID_IAMVfwCaptureDialogs;
extern DELPHI_PACKAGE GUID IID_IAMVfwCompressDialogs;
extern DELPHI_PACKAGE GUID IID_IAMDroppedFrames;
extern DELPHI_PACKAGE GUID IID_IAMAudioInputMixer;
extern DELPHI_PACKAGE GUID IID_IAMAnalogVideoDecoder;
extern DELPHI_PACKAGE GUID IID_IAMVideoProcAmp;
extern DELPHI_PACKAGE GUID IID_IAMCameraControl;
extern DELPHI_PACKAGE GUID IID_IAMCrossbar;
extern DELPHI_PACKAGE GUID IID_IAMTuner;
extern DELPHI_PACKAGE GUID IID_IAMTunerNotification;
extern DELPHI_PACKAGE GUID IID_IAMTVTuner;
extern DELPHI_PACKAGE GUID IID_IBPCSatelliteTuner;
extern DELPHI_PACKAGE GUID IID_IAMTVAudio;
extern DELPHI_PACKAGE GUID IID_IAMTVAudioNotification;
extern DELPHI_PACKAGE GUID IID_IAMAnalogVideoEncoder;
extern DELPHI_PACKAGE GUID IID_IMediaPropertyBag;
extern DELPHI_PACKAGE GUID IID_IPersistMediaPropertyBag;
extern DELPHI_PACKAGE GUID IID_IAMPhysicalPinInfo;
extern DELPHI_PACKAGE GUID IID_IAMExtDevice;
extern DELPHI_PACKAGE GUID IID_IAMExtTransport;
extern DELPHI_PACKAGE GUID IID_IAMTimecodeReader;
extern DELPHI_PACKAGE GUID IID_IAMTimecodeGenerator;
extern DELPHI_PACKAGE GUID IID_IAMTimecodeDisplay;
extern DELPHI_PACKAGE GUID IID_IAMDevMemoryAllocator;
extern DELPHI_PACKAGE GUID IID_IAMDevMemoryControl;
extern DELPHI_PACKAGE GUID IID_IAMStreamSelect;
extern DELPHI_PACKAGE GUID IID_IAMovie;
extern DELPHI_PACKAGE GUID IID_ICreateDevEnum;
extern DELPHI_PACKAGE GUID IID_IDvdControl;
extern DELPHI_PACKAGE GUID IID_IDvdControl2;
extern DELPHI_PACKAGE GUID IID_IDvdInfo;
extern DELPHI_PACKAGE GUID IID_IDvdInfo2;
extern DELPHI_PACKAGE GUID IID_IDvdGraphBuilder;
extern DELPHI_PACKAGE GUID IID_IDvdState;
extern DELPHI_PACKAGE GUID IID_IDvdCmd;
extern DELPHI_PACKAGE GUID IID_IVideoFrameStep;
extern DELPHI_PACKAGE GUID IID_IFilterMapper3;
extern DELPHI_PACKAGE GUID IID_IOverlayNotify2;
extern DELPHI_PACKAGE GUID IID_ICaptureGraphBuilder2;
extern DELPHI_PACKAGE GUID IID_IMemAllocatorCallbackTemp;
extern DELPHI_PACKAGE GUID IID_IMemAllocatorNotifyCallbackTemp;
extern DELPHI_PACKAGE GUID IID_IAMVideoControl;
extern DELPHI_PACKAGE GUID IID_IKsPropertySet;
extern DELPHI_PACKAGE GUID IID_IAMResourceControl;
extern DELPHI_PACKAGE GUID IID_IAMClockAdjust;
extern DELPHI_PACKAGE GUID IID_IAMFilterMiscFlags;
extern DELPHI_PACKAGE GUID IID_IDrawVideoImage;
extern DELPHI_PACKAGE GUID IID_IDecimateVideoImage;
extern DELPHI_PACKAGE GUID IID_IAMVideoDecimationProperties;
extern DELPHI_PACKAGE GUID IID_IAMLatency;
extern DELPHI_PACKAGE GUID IID_IAMPushSource;
extern DELPHI_PACKAGE GUID IID_IAMDeviceRemoval;
extern DELPHI_PACKAGE GUID IID_IDVEnc;
extern DELPHI_PACKAGE GUID IID_IIPDVDec;
extern DELPHI_PACKAGE GUID IID_IDVSplitter;
extern DELPHI_PACKAGE GUID IID_IAMAudioRendererStats;
extern DELPHI_PACKAGE GUID IID_IAMGraphStreams;
extern DELPHI_PACKAGE GUID IID_IAMOverlayFX;
extern DELPHI_PACKAGE GUID IID_IAMOpenProgress;
extern DELPHI_PACKAGE GUID IID_IMpeg2Demultiplexer;
extern DELPHI_PACKAGE GUID IID_IEnumStreamIdMap;
extern DELPHI_PACKAGE GUID IID_IMPEG2StreamIdMap;
extern DELPHI_PACKAGE GUID IID_IDDrawExclModeVideo;
extern DELPHI_PACKAGE GUID IID_IDDrawExclModeVideoCallback;
extern DELPHI_PACKAGE GUID IID_IPinConnection;
extern DELPHI_PACKAGE GUID IID_IPinFlowControl;
extern DELPHI_PACKAGE GUID IID_IGraphConfig;
extern DELPHI_PACKAGE GUID IID_IGraphConfigCallback;
extern DELPHI_PACKAGE GUID IID_IFilterChain;
static const System::Int8 TAPIMEDIATYPE_AUDIO = System::Int8(0x8);
static const System::Word TAPIMEDIATYPE_VIDEO = System::Word(0x8000);
static const System::Int8 TAPIMEDIATYPE_DATAMODEM = System::Int8(0x10);
static const System::Int8 TAPIMEDIATYPE_G3FAX = System::Int8(0x20);
static const System::Int8 LINEADDRESSTYPE_PHONENUMBER = System::Int8(0x1);
static const System::Int8 LINEADDRESSTYPE_SDP = System::Int8(0x2);
static const System::Int8 LINEADDRESSTYPE_EMAILNAME = System::Int8(0x4);
static const System::Int8 LINEADDRESSTYPE_DOMAINNAME = System::Int8(0x8);
static const System::Int8 LINEADDRESSTYPE_IPADDRESS = System::Int8(0x10);
static const System::Int8 LINECALLORIGIN_OUTBOUND = System::Int8(0x1);
static const System::Int8 LINECALLORIGIN_INTERNAL = System::Int8(0x2);
static const System::Int8 LINECALLORIGIN_EXTERNAL = System::Int8(0x4);
static const System::Int8 LINECALLORIGIN_UNKNOWN = System::Int8(0x10);
static const System::Int8 LINECALLORIGIN_UNAVAIL = System::Int8(0x20);
static const System::Int8 LINECALLORIGIN_CONFERENCE = System::Int8(0x40);
static const System::Byte LINECALLORIGIN_INBOUND = System::Byte(0x80);
static const System::Int8 LINECALLREASON_DIRECT = System::Int8(0x1);
static const System::Int8 LINECALLREASON_FWDBUSY = System::Int8(0x2);
static const System::Int8 LINECALLREASON_FWDNOANSWER = System::Int8(0x4);
static const System::Int8 LINECALLREASON_FWDUNCOND = System::Int8(0x8);
static const System::Int8 LINECALLREASON_PICKUP = System::Int8(0x10);
static const System::Int8 LINECALLREASON_UNPARK = System::Int8(0x20);
static const System::Int8 LINECALLREASON_REDIRECT = System::Int8(0x40);
static const System::Byte LINECALLREASON_CALLCOMPLETION = System::Byte(0x80);
static const System::Word LINECALLREASON_TRANSFER = System::Word(0x100);
static const System::Word LINECALLREASON_REMINDER = System::Word(0x200);
static const System::Word LINECALLREASON_UNKNOWN = System::Word(0x400);
static const System::Word LINECALLREASON_UNAVAIL = System::Word(0x800);
static const System::Word LINECALLREASON_INTRUDE = System::Word(0x1000);
static const System::Word LINECALLREASON_PARKED = System::Word(0x2000);
static const System::Word LINECALLREASON_CAMPEDON = System::Word(0x4000);
static const System::Word LINECALLREASON_ROUTEREQUEST = System::Word(0x8000);
extern DELPHI_PACKAGE GUID IID_IConnectionPointContainer;
extern DELPHI_PACKAGE GUID CLSID_IBasicVideo;
extern DELPHI_PACKAGE GUID CLSID_HandsetTerminal;
extern DELPHI_PACKAGE GUID CLSID_HeadsetTerminal;
extern DELPHI_PACKAGE GUID CLSID_MediaStreamTerminal;
extern DELPHI_PACKAGE GUID CLSID_MicrophoneTerminal;
extern DELPHI_PACKAGE GUID CLSID_SpeakerphoneTerminal;
extern DELPHI_PACKAGE GUID CLSID_SpeakersTerminal;
extern DELPHI_PACKAGE GUID CLSID_VideoInputTerminal;
extern DELPHI_PACKAGE GUID CLSID_VideoWindowTerm;
#define CLSID_String_HandsetTerminal L"{AAF578EB-DC70-11d0-8ED3-00C04FB6809F}"
#define CLSID_String_HeadsetTerminal L"{AAF578ED-DC70-11d0-8ED3-00C04FB6809F}"
#define CLSID_String_MediaStreamTerminal L"{E2F7AEF7-4971-11D1-A671-006097C9A2E8}"
#define CLSID_String_MicrophoneTerminal L"{AAF578EF-DC70-11d0-8ED3-00C04FB6809F}"
#define CLSID_String_SpeakerphoneTerminal L"{AAF578EE-DC70-11d0-8ED3-00C04FB6809F}"
#define CLSID_String_SpeakersTerminal L"{AAF578F0-DC70-11d0-8ED3-00C04FB6809F}"
#define CLSID_String_VideoInputTerminal L"{AAF578EC-DC70-11d0-8ED3-00C04FB6809F}"
#define CLSID_String_VideoWindowTerm L"{F7438990-D6EB-11d0-82A6-00AA00B5CA1B}"
static const System::Int8 AS_INSERVICE = System::Int8(0x0);
static const System::Int8 AS_OUTOFSERVICE = System::Int8(0x1);
static const System::Int8 CHS_ACTIVE = System::Int8(0x0);
static const System::Int8 CHS_IDLE = System::Int8(0x1);
static const System::Int8 DC_NORMAL = System::Int8(0x0);
static const System::Int8 DC_NOANSWER = System::Int8(0x1);
static const System::Int8 DC_REJECTED = System::Int8(0x2);
static const System::Int8 QSL_NEEDED = System::Int8(0x1);
static const System::Int8 QSL_IF_AVAILABLE = System::Int8(0x2);
static const System::Int8 QSL_BEST_EFFORT = System::Int8(0x3);
static const System::Int8 FM_ASTRANSFER = System::Int8(0x0);
static const System::Int8 FM_ASCONFERENCE = System::Int8(0x1);
static const System::Int8 CS_IDLE = System::Int8(0x0);
static const System::Int8 CS_INPROGRESS = System::Int8(0x1);
static const System::Int8 CS_CONNECTED = System::Int8(0x2);
static const System::Int8 CS_DISCONNECTED = System::Int8(0x3);
static const System::Int8 CS_OFFERING = System::Int8(0x4);
static const System::Int8 CS_HOLD = System::Int8(0x5);
static const System::Int8 CS_QUEUED = System::Int8(0x6);
static const System::Int8 CP_OWNER = System::Int8(0x0);
static const System::Int8 CP_MONITOR = System::Int8(0x1);
static const System::Int8 CIL_MEDIATYPESAVAILABLE = System::Int8(0x0);
static const System::Int8 CIL_BEARERMODE = System::Int8(0x1);
static const System::Int8 CIL_CALLERIDADDRESSTYPE = System::Int8(0x2);
static const System::Int8 CIL_CALLEDIDADDRESSTYPE = System::Int8(0x3);
static const System::Int8 CIL_CONNECTEDIDADDRESSTYPE = System::Int8(0x4);
static const System::Int8 CIL_REDIRECTIONIDADDRESSTYPE = System::Int8(0x5);
static const System::Int8 CIL_REDIRECTINGIDADDRESSTYPE = System::Int8(0x6);
static const System::Int8 CIL_ORIGIN = System::Int8(0x7);
static const System::Int8 CIL_REASON = System::Int8(0x8);
static const System::Int8 CIL_APPSPECIFIC = System::Int8(0x9);
static const System::Int8 CIL_CALLPARAMSFLAGS = System::Int8(0xa);
static const System::Int8 CIL_CALLTREATMENT = System::Int8(0xb);
static const System::Int8 CIL_MINRATE = System::Int8(0xc);
static const System::Int8 CIL_MAXRATE = System::Int8(0xd);
static const System::Int8 CIL_COUNTRYCODE = System::Int8(0xe);
static const System::Int8 CIL_CALLID = System::Int8(0xf);
static const System::Int8 CIL_RELATEDCALLID = System::Int8(0x10);
static const System::Int8 CIL_COMPLETIONID = System::Int8(0x11);
static const System::Int8 CIL_NUMBEROFOWNERS = System::Int8(0x12);
static const System::Int8 CIL_NUMBEROFMONITORS = System::Int8(0x13);
static const System::Int8 CIL_TRUNK = System::Int8(0x14);
static const System::Int8 CIL_RATE = System::Int8(0x15);
static const System::Int8 CIS_CALLERIDNAME = System::Int8(0x0);
static const System::Int8 CIS_CALLERIDNUMBER = System::Int8(0x1);
static const System::Int8 CIS_CALLEDIDNAME = System::Int8(0x2);
static const System::Int8 CIS_CALLEDIDNUMBER = System::Int8(0x3);
static const System::Int8 CIS_CONNECTEDIDNAME = System::Int8(0x4);
static const System::Int8 CIS_CONNECTEDIDNUMBER = System::Int8(0x5);
static const System::Int8 CIS_REDIRECTIONIDNAME = System::Int8(0x6);
static const System::Int8 CIS_REDIRECTIONIDNUMBER = System::Int8(0x7);
static const System::Int8 CIS_REDIRECTINGIDNAME = System::Int8(0x8);
static const System::Int8 CIS_REDIRECTINGIDNUMBER = System::Int8(0x9);
static const System::Int8 CIS_CALLEDPARTYFRIENDLYNAME = System::Int8(0xa);
static const System::Int8 CIS_COMMENT = System::Int8(0xb);
static const System::Int8 CIS_DISPLAYABLEADDRESS = System::Int8(0xc);
static const System::Int8 CIS_CALLINGPARTYID = System::Int8(0xd);
static const System::Int8 CIB_USERUSERINFO = System::Int8(0x0);
static const System::Int8 CIB_DEVSPECIFICBUFFER = System::Int8(0x1);
static const System::Int8 CIB_CALLDATABUFFER = System::Int8(0x2);
static const System::Int8 CIB_CHARGINGINFOBUFFER = System::Int8(0x3);
static const System::Int8 CIB_HIGHLEVELCOMPATIBILITYBUFFER = System::Int8(0x4);
static const System::Int8 CIB_LOWLEVELCOMPATIBILITYBUFFER = System::Int8(0x5);
static const System::Int8 CEC_NONE = System::Int8(0x0);
static const System::Int8 CEC_DISCONNECT_NORMAL = System::Int8(0x1);
static const System::Int8 CEC_DISCONNECT_BUSY = System::Int8(0x2);
static const System::Int8 CEC_DISCONNECT_BADADDRESS = System::Int8(0x3);
static const System::Int8 CEC_DISCONNECT_NOANSWER = System::Int8(0x4);
static const System::Int8 CEC_DISCONNECT_CANCELLED = System::Int8(0x5);
static const System::Int8 CEC_DISCONNECT_REJECTED = System::Int8(0x6);
static const System::Int8 CEC_DISCONNECT_FAILED = System::Int8(0x7);
static const System::Int8 CNE_OWNER = System::Int8(0x0);
static const System::Int8 CNE_MONITOR = System::Int8(0x1);
static const System::Int8 TE_TAPIOBJECT = System::Int8(0x1);
static const System::Int8 TE_ADDRESS = System::Int8(0x2);
static const System::Int8 TE_CALLNOTIFICATION = System::Int8(0x4);
static const System::Int8 TE_CALLSTATE = System::Int8(0x8);
static const System::Int8 TE_CALLMEDIA = System::Int8(0x10);
static const System::Int8 TE_CALLHUB = System::Int8(0x20);
static const System::Int8 TE_CALLINFOCHANGE = System::Int8(0x40);
static const System::Byte TE_PRIVATE = System::Byte(0x80);
static const System::Word TE_REQUEST = System::Word(0x100);
static const System::Word TE_AGENT = System::Word(0x200);
static const System::Word TE_AGENTSESSION = System::Word(0x400);
static const System::Word TE_QOSEVENT = System::Word(0x800);
static const System::Word TE_AGENTHANDLER = System::Word(0x1000);
static const System::Word TE_ACDGROUP = System::Word(0x2000);
static const System::Word TE_QUEUE = System::Word(0x4000);
static const System::Word TE_DIGITEVENT = System::Word(0x8000);
static const int TE_GENERATEEVENT = int(0x10000);
static const System::Int8 CHE_CALLJOIN = System::Int8(0x0);
static const System::Int8 CHE_CALLLEAVE = System::Int8(0x1);
static const System::Int8 CHE_CALLHUBNEW = System::Int8(0x2);
static const System::Int8 CHE_CALLHUBIDLE = System::Int8(0x3);
static const System::Int8 AC_ADDRESSTYPES = System::Int8(0x0);
static const System::Int8 AC_BEARERMODES = System::Int8(0x1);
static const System::Int8 AC_MAXACTIVECALLS = System::Int8(0x2);
static const System::Int8 AC_MAXONHOLDCALLS = System::Int8(0x3);
static const System::Int8 AC_MAXONHOLDPENDINGCALLS = System::Int8(0x4);
static const System::Int8 AC_MAXNUMCONFERENCE = System::Int8(0x5);
static const System::Int8 AC_MAXNUMTRANSCONF = System::Int8(0x6);
static const System::Int8 AC_MONITORDIGITSUPPORT = System::Int8(0x7);
static const System::Int8 AC_GENERATEDIGITSUPPORT = System::Int8(0x8);
static const System::Int8 AC_GENERATETONEMODES = System::Int8(0x9);
static const System::Int8 AC_GENERATETONEMAXNUMFREQ = System::Int8(0xa);
static const System::Int8 AC_MONITORTONEMAXNUMFREQ = System::Int8(0xb);
static const System::Int8 AC_MONITORTONEMAXNUMENTRIES = System::Int8(0xc);
static const System::Int8 AC_DEVCAPFLAGS = System::Int8(0xd);
static const System::Int8 AC_ANSWERMODES = System::Int8(0xe);
static const System::Int8 AC_LINEFEATURES = System::Int8(0xf);
static const System::Int8 AC_SETTABLEDEVSTATUS = System::Int8(0x10);
static const System::Int8 AC_PARKSUPPORT = System::Int8(0x11);
static const System::Int8 AC_CALLERIDSUPPORT = System::Int8(0x12);
static const System::Int8 AC_CALLEDIDSUPPORT = System::Int8(0x13);
static const System::Int8 AC_CONNECTEDIDSUPPORT = System::Int8(0x14);
static const System::Int8 AC_REDIRECTIONIDSUPPORT = System::Int8(0x15);
static const System::Int8 AC_REDIRECTINGIDSUPPORT = System::Int8(0x16);
static const System::Int8 AC_ADDRESSCAPFLAGS = System::Int8(0x17);
static const System::Int8 AC_CALLFEATURES1 = System::Int8(0x18);
static const System::Int8 AC_CALLFEATURES2 = System::Int8(0x19);
static const System::Int8 AC_REMOVEFROMCONFCAPS = System::Int8(0x1a);
static const System::Int8 AC_REMOVEFROMCONFSTATE = System::Int8(0x1b);
static const System::Int8 AC_TRANSFERMODES = System::Int8(0x1c);
static const System::Int8 AC_ADDRESSFEATURES = System::Int8(0x1d);
static const System::Int8 AC_PREDICTIVEAUTOTRANSFERSTATES = System::Int8(0x1e);
static const System::Int8 AC_MAXCALLDATASIZE = System::Int8(0x1f);
static const System::Int8 AC_LINEID = System::Int8(0x20);
static const System::Int8 AC_ADDRESSID = System::Int8(0x21);
static const System::Int8 AC_FORWARDMODES = System::Int8(0x22);
static const System::Int8 AC_MAXFORWARDENTRIES = System::Int8(0x23);
static const System::Int8 AC_MAXSPECIFICENTRIES = System::Int8(0x24);
static const System::Int8 AC_MINFWDNUMRINGS = System::Int8(0x25);
static const System::Int8 AC_MAXFWDNUMRINGS = System::Int8(0x26);
static const System::Int8 AC_MAXCALLCOMPLETIONS = System::Int8(0x27);
static const System::Int8 AC_CALLCOMPLETIONCONDITIONS = System::Int8(0x28);
static const System::Int8 AC_CALLCOMPLETIONMODES = System::Int8(0x29);
static const System::Int8 AC_PERMANENTDEVICEID = System::Int8(0x2a);
static const System::Int8 ACS_PROTOCOL = System::Int8(0x0);
static const System::Int8 ACS_ADDRESSDEVICESPECIFIC = System::Int8(0x1);
static const System::Int8 ACS_LINEDEVICESPECIFIC = System::Int8(0x2);
static const System::Int8 ACS_PROVIDERSPECIFIC = System::Int8(0x3);
static const System::Int8 ACS_SWITCHSPECIFIC = System::Int8(0x4);
static const System::Int8 ACS_PERMANENTDEVICEGUID = System::Int8(0x5);
static const System::Int8 QE_NOQOS = System::Int8(0x1);
static const System::Int8 QE_ADMISSIONFAILURE = System::Int8(0x2);
static const System::Int8 QE_POLICYFAILURE = System::Int8(0x3);
static const System::Int8 QE_GENERICERROR = System::Int8(0x4);
static const System::Int8 AE_STATE = System::Int8(0x0);
static const System::Int8 AE_CAPSCHANGE = System::Int8(0x1);
static const System::Int8 AE_RINGING = System::Int8(0x2);
static const System::Int8 AE_CONFIGCHANGE = System::Int8(0x3);
static const System::Int8 AE_FORWARD = System::Int8(0x4);
static const System::Int8 AE_NEWTERMINAL = System::Int8(0x5);
static const System::Int8 AE_REMOVETERMINAL = System::Int8(0x6);
static const System::Int8 TS_INUSE = System::Int8(0x0);
static const System::Int8 TS_NOTINUSE = System::Int8(0x1);
static const System::Int8 TT_STATIC = System::Int8(0x0);
static const System::Int8 TT_DYNAMIC = System::Int8(0x1);
static const System::Int8 TD_CAPTURE = System::Int8(0x0);
static const System::Int8 TD_RENDER = System::Int8(0x1);
static const System::Int8 TD_BIDIRECTIONAL = System::Int8(0x2);
static const System::Int8 CME_NEW_STREAM = System::Int8(0x0);
static const System::Int8 CME_STREAM_FAIL = System::Int8(0x1);
static const System::Int8 CME_TERMINAL_FAIL = System::Int8(0x2);
static const System::Int8 CME_STREAM_NOT_USED = System::Int8(0x3);
static const System::Int8 CME_STREAM_ACTIVE = System::Int8(0x4);
static const System::Int8 CME_STREAM_INACTIVE = System::Int8(0x5);
static const System::Int8 CMC_UNKNOWN = System::Int8(0x0);
static const System::Int8 CMC_BAD_DEVICE = System::Int8(0x1);
static const System::Int8 CMC_CONNECT_FAIL = System::Int8(0x2);
static const System::Int8 CMC_LOCAL_REQUEST = System::Int8(0x3);
static const System::Int8 CMC_REMOTE_REQUEST = System::Int8(0x4);
static const System::Int8 CMC_MEDIA_TIMEOUT = System::Int8(0x5);
static const System::Int8 CMC_MEDIA_RECOVERED = System::Int8(0x6);
static const System::Int8 TE_ADDRESSCREATE = System::Int8(0x0);
static const System::Int8 TE_ADDRESSREMOVE = System::Int8(0x1);
static const System::Int8 TE_REINIT = System::Int8(0x2);
static const System::Int8 TE_TRANSLATECHANGE = System::Int8(0x3);
static const System::Int8 TE_ADDRESSCLOSE = System::Int8(0x4);
static const System::Int8 ASST_NOT_READY = System::Int8(0x0);
static const System::Int8 ASST_READY = System::Int8(0x1);
static const System::Int8 ASST_BUSY_ON_CALL = System::Int8(0x2);
static const System::Int8 ASST_BUSY_WRAPUP = System::Int8(0x3);
static const System::Int8 ASST_SESSION_ENDED = System::Int8(0x4);
static const System::Int8 AS_NOT_READY = System::Int8(0x0);
static const System::Int8 AS_READY = System::Int8(0x1);
static const System::Int8 AS_BUSY_ACD = System::Int8(0x2);
static const System::Int8 AS_BUSY_INCOMING = System::Int8(0x3);
static const System::Int8 AS_BUSY_OUTGOING = System::Int8(0x4);
static const System::Int8 AS_UNKNOWN = System::Int8(0x5);
static const System::Int8 AE_NOT_READY = System::Int8(0x0);
static const System::Int8 AE_READY = System::Int8(0x1);
static const System::Int8 AE_BUSY_ACD = System::Int8(0x2);
static const System::Int8 AE_BUSY_INCOMING = System::Int8(0x3);
static const System::Int8 AE_BUSY_OUTGOING = System::Int8(0x4);
static const System::Int8 AE_UNKNOWN = System::Int8(0x5);
static const System::Int8 ASE_NEW_SESSION = System::Int8(0x0);
static const System::Int8 ASE_NOT_READY = System::Int8(0x1);
static const System::Int8 ASE_READY = System::Int8(0x2);
static const System::Int8 ASE_BUSY = System::Int8(0x3);
static const System::Int8 ASE_WRAPUP = System::Int8(0x4);
static const System::Int8 ASE_END = System::Int8(0x5);
static const System::Int8 ACDGE_NEW_GROUP = System::Int8(0x0);
static const System::Int8 ACDGE_GROUP_REMOVED = System::Int8(0x1);
static const System::Int8 ACDQE_NEW_QUEUE = System::Int8(0x0);
static const System::Int8 ACDQE_QUEUE_REMOVED = System::Int8(0x1);
static const System::Int8 AHE_NEW_AGENTHANDLER = System::Int8(0x0);
static const System::Int8 AHE_AGENTHANDLER_REMOVED = System::Int8(0x1);
static const System::Int8 CIC_OTHER = System::Int8(0x0);
static const System::Int8 CIC_DEVSPECIFIC = System::Int8(0x1);
static const System::Int8 CIC_BEARERMODE = System::Int8(0x2);
static const System::Int8 CIC_RATE = System::Int8(0x3);
static const System::Int8 CIC_APPSPECIFIC = System::Int8(0x4);
static const System::Int8 CIC_CALLID = System::Int8(0x5);
static const System::Int8 CIC_RELATEDCALLID = System::Int8(0x6);
static const System::Int8 CIC_ORIGIN = System::Int8(0x7);
static const System::Int8 CIC_REASON = System::Int8(0x8);
static const System::Int8 CIC_COMPLETIONID = System::Int8(0x9);
static const System::Int8 CIC_NUMOWNERINCR = System::Int8(0xa);
static const System::Int8 CIC_NUMOWNERDECR = System::Int8(0xb);
static const System::Int8 CIC_NUMMONITORS = System::Int8(0xc);
static const System::Int8 CIC_TRUNK = System::Int8(0xd);
static const System::Int8 CIC_CALLERID = System::Int8(0xe);
static const System::Int8 CIC_CALLEDID = System::Int8(0xf);
static const System::Int8 CIC_CONNECTEDID = System::Int8(0x10);
static const System::Int8 CIC_REDIRECTIONID = System::Int8(0x11);
static const System::Int8 CIC_REDIRECTINGID = System::Int8(0x12);
static const System::Int8 CIC_USERUSERINFO = System::Int8(0x13);
static const System::Int8 CIC_HIGHLEVELCOMP = System::Int8(0x14);
static const System::Int8 CIC_LOWLEVELCOMP = System::Int8(0x15);
static const System::Int8 CIC_CHARGINGINFO = System::Int8(0x16);
static const System::Int8 CIC_TREATMENT = System::Int8(0x17);
static const System::Int8 CIC_CALLDATA = System::Int8(0x18);
static const System::Int8 CIC_PRIVILEGE = System::Int8(0x19);
static const System::Int8 CIC_MEDIATYPE = System::Int8(0x1a);
}	/* namespace Aditapi3 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADITAPI3)
using namespace Aditapi3;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Aditapi3HPP
