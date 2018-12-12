// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdTUtil.pas' rev: 32.00 (Windows)

#ifndef AdtutilHPP
#define AdtutilHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <OoMisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adtutil
{
//-- forward type declarations -----------------------------------------------
struct TVarString;
struct TLineExtensionID;
struct TLineCountryEntry;
struct TLineCountryList;
struct TLineDialParams;
struct TLineDevCaps;
struct TLineAddressCaps;
struct TLineCallParams;
struct TLineAddressStatus;
struct TLineDevStatus;
struct TCallInfo;
struct TCallStatus;
struct TLineTranslateOutput;
struct TLineTranslateCaps;
struct TLineMonitorTone;
struct TLineGenerateTone;
//-- type declarations -------------------------------------------------------
typedef TVarString *PVarString;

struct DECLSPEC_DRECORD TVarString
{
	
public:
	union
	{
		struct 
		{
			System::StaticArray<char, 1025> StringData;
		};
		struct 
		{
			unsigned TotalSize;
			unsigned NeededSize;
			unsigned UsedSize;
			unsigned StringFormat;
			unsigned StringSize;
			unsigned StringOffset;
		};
		
	};
};


typedef TLineExtensionID *PLineExtensionID;

struct DECLSPEC_DRECORD TLineExtensionID
{
public:
	unsigned ExtensionID0;
	unsigned ExtensionID1;
	unsigned ExtensionID2;
	unsigned ExtensionID3;
};


struct DECLSPEC_DRECORD TLineCountryEntry
{
public:
	int CountryID;
	int CountryCode;
	int NextCountryID;
	int CountryNameSize;
	int CountryNameOffset;
	int SameAreaRuleSize;
	int SameAreaRuleOffset;
	int LongDistanceRuleSize;
	int LongDistanceRuleOffset;
	int InternationalRuleSize;
	int InternationalRuleOffset;
};


typedef TLineCountryList *PLineCountryList;

struct DECLSPEC_DRECORD TLineCountryList
{
public:
	int TotalSize;
	int NeededSize;
	int UsedSize;
	int NumCountries;
	int CountryListSize;
	int CountryListOffset;
	
public:
	union
	{
		struct 
		{
			System::StaticArray<System::Byte, 44001> BufferBytes;
		};
		struct 
		{
			System::StaticArray<TLineCountryEntry, 1001> Buffer;
		};
		
	};
};


typedef TLineDialParams *PLineDialParams;

struct DECLSPEC_DRECORD TLineDialParams
{
public:
	unsigned DialPause;
	unsigned DialSpeed;
	unsigned DigitDuration;
	unsigned WaitForDialtone;
};


typedef TLineDevCaps *PLineDevCaps;

struct DECLSPEC_DRECORD TLineDevCaps
{
	
public:
	union
	{
		struct 
		{
			System::StaticArray<char, 65521> Data;
		};
		struct 
		{
			unsigned TotalSize;
			unsigned NeededSize;
			unsigned UsedSize;
			unsigned ProviderInfoSize;
			unsigned ProviderInfoOffset;
			unsigned SwitchInfoSize;
			unsigned SwitchInfoOffset;
			unsigned PermanentLineID;
			unsigned LineNameSize;
			unsigned LineNameOffset;
			unsigned StringFormat;
			unsigned AddressModes;
			unsigned NumAddresses;
			unsigned BearerModes;
			unsigned MaxRate;
			unsigned MediaModes;
			unsigned GenerateToneModes;
			unsigned GenerateToneMaxNumFreq;
			unsigned GenerateDigitModes;
			unsigned MonitorToneMaxNumFreq;
			unsigned MonitorToneMaxNumEntries;
			unsigned MonitorDigitModes;
			unsigned GatherDigitsMinTimeout;
			unsigned GatherDigitsMaxTimeout;
			unsigned MedCtlDigitMaxListSize;
			unsigned MedCtlMediaMaxListSize;
			unsigned MedCtlToneMaxListSize;
			unsigned MedCtlCallStateMaxListSize;
			unsigned DevCapFlags;
			unsigned MaxNumActiveCalls;
			unsigned AnswerMode;
			unsigned RingModes;
			unsigned LineStates;
			unsigned UUIAcceptSize;
			unsigned UUIAnswerSize;
			unsigned UUIMakeCallSize;
			unsigned UUIdropSize;
			unsigned UUISendUserUserInfoSize;
			unsigned UUICallInfoSize;
			TLineDialParams MinDialParams;
			TLineDialParams MaxDialParams;
			TLineDialParams DefaultDialParams;
			unsigned NumTerminals;
			unsigned TerminalCapsSize;
			unsigned TerminalCapsOffset;
			unsigned TerminalTextEntrySize;
			unsigned TerminalTextSize;
			unsigned TerminalTextOffset;
			unsigned DevSpecificSize;
			unsigned DevSpecificOffset;
			unsigned LineFeatures;
			int EndMark;
		};
		
	};
};


typedef TLineAddressCaps *PLineAddressCaps;

struct DECLSPEC_DRECORD TLineAddressCaps
{
	
public:
	union
	{
		struct 
		{
			System::StaticArray<char, 65521> Data;
		};
		struct 
		{
			unsigned TotalSize;
			unsigned NeededSize;
			unsigned UsedSize;
			unsigned LineDeviceID;
			unsigned AddressSize;
			unsigned AddressOffset;
			unsigned DevSpecificSize;
			unsigned DevSpecificOffset;
			unsigned AddressSharing;
			unsigned AddressStates;
			unsigned CallInfoStates;
			unsigned CallerIDFlags;
			unsigned CalledIDFlags;
			unsigned ConnectedIDFlags;
			unsigned RedirectionIDFlags;
			unsigned RedirectingIDFlags;
			unsigned CallStates;
			unsigned DialToneModes;
			unsigned BusyModes;
			unsigned SpecialInfo;
			unsigned DisconnectModes;
			unsigned MaxNumActiveCalls;
			unsigned MaxNumOnHoldCalls;
			unsigned MaxNumOnHoldPendingCalls;
			unsigned MaxNumConference;
			unsigned MaxNumTransConf;
			unsigned AddrCapFlags;
			unsigned CallFeatures;
			unsigned RemoveFromConfCaps;
			unsigned RemoveFromConfState;
			unsigned TransferModes;
			unsigned ParkModes;
			unsigned ForwardModes;
			unsigned MaxForwardEntries;
			unsigned MaxSpecificEntries;
			unsigned MinFwdNumRings;
			unsigned MaxFwdNumRings;
			unsigned MaxCallCompletions;
			unsigned CallCompletionConds;
			unsigned CallCompletionModes;
			unsigned NumCompletionMessages;
			unsigned CompletionMsgTextEntrySize;
			unsigned CompletionMsgTextSize;
			unsigned CompletionMsgTextOffset;
			unsigned AddressFeatures;
			unsigned PredictiveAutoTransferStates;
			unsigned NumCallTreatments;
			unsigned CallTreatmentListSize;
			unsigned CallTreatmentListOffset;
			unsigned DeviceClassesSize;
			unsigned DeviceClassesOffset;
			unsigned MaxCallDataSize;
			unsigned CallFeatures2;
			unsigned MaxNoAnswerTimeout;
			unsigned ConnectedModes;
			unsigned OfferingModes;
			unsigned AvailableMediaModes;
			int EndMark;
		};
		
	};
};


typedef TLineCallParams *PLineCallParams;

struct DECLSPEC_DRECORD TLineCallParams
{
public:
	unsigned TotalSize;
	unsigned BearerMode;
	unsigned MinRate;
	unsigned MaxRate;
	unsigned MediaMode;
	unsigned CallParamFlags;
	unsigned AddressMode;
	unsigned AddressID;
	TLineDialParams DialParams;
	unsigned OrigAddressSize;
	unsigned OrigAddressOffset;
	unsigned DisplayableAddressSize;
	unsigned DisplayableAddressOffset;
	unsigned CalledPartySize;
	unsigned CalledPartyOffset;
	unsigned CommentSize;
	unsigned CommentOffset;
	unsigned UserUserInfoSize;
	unsigned UserUserInfoOffset;
	unsigned HighLevelCompSize;
	unsigned HighLevelCompOffset;
	unsigned LowLevelCompSize;
	unsigned LowLevelCompOffset;
	unsigned DevSpecificSize;
	unsigned DevSpecificOffset;
};


typedef TLineAddressStatus *PLineAddressStatus;

struct DECLSPEC_DRECORD TLineAddressStatus
{
public:
	unsigned TotalSize;
	unsigned NeededSize;
	unsigned UsedSize;
	unsigned NumInUse;
	unsigned NumActiveCalls;
	unsigned NumOnHoldCalls;
	unsigned NumOnHoldPendCalls;
	unsigned AddressFeatures;
	unsigned NumRingsNoAnswer;
	unsigned ForwardNumEntries;
	unsigned ForwardSize;
	unsigned ForwardOffset;
	unsigned TerminalModesSize;
	unsigned TerminalModesOffset;
	unsigned DevSpecificSize;
	unsigned DevSpecificOffset;
};


typedef TLineDevStatus *PLineDevStatus;

struct DECLSPEC_DRECORD TLineDevStatus
{
	
public:
	union
	{
		struct 
		{
			System::StaticArray<System::Byte, 65521> Data;
		};
		struct 
		{
			unsigned TotalSize;
			unsigned NeededSize;
			unsigned UsedSize;
			unsigned NumOpens;
			unsigned OpenMediaModes;
			unsigned NumActiveCalls;
			unsigned NumOnHoldCalls;
			unsigned NumOnHoldPendCalls;
			unsigned LineFeatures;
			unsigned NumCallCompletions;
			unsigned RingMode;
			unsigned SignalLevel;
			unsigned BatteryLevel;
			unsigned RoamMode;
			unsigned DevStatusFlags;
			unsigned TerminalModesSize;
			unsigned TerminalModesOffset;
			unsigned DevSpecificSize;
			unsigned DevSpecificOffset;
			unsigned AvailableMediaModes;
			unsigned AppInfoSize;
			unsigned AppInfoOffset;
			unsigned EndMark;
		};
		
	};
};


typedef int TLineApp;

typedef int *PLineApp;

typedef int TLine;

typedef int *PLine;

typedef int TCall;

typedef int *PCall;

typedef TCallInfo *PCallInfo;

struct DECLSPEC_DRECORD TCallInfo
{
	
public:
	union
	{
		struct 
		{
			System::StaticArray<System::Byte, 65521> Data;
		};
		struct 
		{
			unsigned TotalSize;
			unsigned NeededSize;
			unsigned UsedSize;
			int Line;
			unsigned LineDeviceID;
			unsigned AddressID;
			unsigned BearerMode;
			unsigned Rate;
			unsigned MediaMode;
			unsigned AppSpecific;
			unsigned CallID;
			unsigned RelatedCallID;
			unsigned CallParamFlags;
			unsigned CallStates;
			unsigned MonitorDigitModes;
			unsigned MonitorMediaModes;
			TLineDialParams DialParams;
			unsigned Origin;
			unsigned Reason;
			unsigned CompletionID;
			unsigned NumOwners;
			unsigned NumMonitors;
			unsigned CountryCode;
			unsigned Trunk;
			unsigned CallerIDFlags;
			unsigned CallerIDSize;
			unsigned CallerIDOffset;
			unsigned CallerIDNameSize;
			unsigned CallerIDNameOffset;
			unsigned CalledIDFlags;
			unsigned CalledIDSize;
			unsigned CalledIDOffset;
			unsigned CalledIDNameSize;
			unsigned CalledIDNameOffset;
			unsigned ConnectedIDdFlags;
			unsigned ConnectedIDSize;
			unsigned ConnectedIDOffset;
			unsigned ConnectedIDNameSize;
			unsigned ConnectedIDNameOffset;
			unsigned RedirectionIDFlags;
			unsigned RedirectionIDSize;
			unsigned RedirectionIDOffset;
			unsigned RedirectionIDNameSize;
			unsigned RedirectionIDNameOffset;
			unsigned RedirectingIDFlags;
			unsigned RedirectingIDSize;
			unsigned RedirectingIDOffset;
			unsigned RedirectingIDNameSize;
			unsigned RedirectingIDNameOffset;
			unsigned AppNameSize;
			unsigned AppNameOffset;
			unsigned DisplayableAddressSize;
			unsigned DisplayableAddressOffset;
			unsigned CalledPartySize;
			unsigned CalledPartyOffset;
			unsigned CommentSize;
			unsigned CommentOffset;
			unsigned DisplaySize;
			unsigned DisplayOffset;
			unsigned UserUserInfoSize;
			unsigned UserUserInfoOffset;
			unsigned HighLevelCompSize;
			unsigned HighLevelCompOffset;
			unsigned LowLevelCompSize;
			unsigned LowLevelCompOffset;
			unsigned ChargingInfoSize;
			unsigned ChargingInfoOffset;
			unsigned TerminalModesSize;
			unsigned TerminalModesOffset;
			unsigned DevSpecificSize;
			unsigned DevSpecificOffset;
			int EndMark;
		};
		
	};
};


typedef TCallStatus *PCallStatus;

struct DECLSPEC_DRECORD TCallStatus
{
	
public:
	union
	{
		struct 
		{
			System::StaticArray<System::Byte, 65521> Data;
		};
		struct 
		{
			unsigned TotalSize;
			unsigned NeededSize;
			unsigned UsedSize;
			unsigned CallState;
			unsigned CallStateMode;
			unsigned CallPrivilege;
			unsigned CallFeatures;
			unsigned DevSpecificSize;
			unsigned DevSpecificOffset;
			unsigned EndMark;
		};
		
	};
};


typedef TLineTranslateOutput *PLineTranslateOutput;

struct DECLSPEC_DRECORD TLineTranslateOutput
{
	
public:
	union
	{
		struct 
		{
			System::StaticArray<System::Byte, 65521> Data;
		};
		struct 
		{
			unsigned TotalSize;
			unsigned NeededSize;
			unsigned UsedSize;
			unsigned DialableStringSize;
			unsigned DialableStringOffset;
			unsigned DisplayableStringSize;
			unsigned DisplayableStringOffset;
			unsigned CurrentCountry;
			unsigned DestCountry;
			unsigned TranslateResults;
			unsigned EndMark;
		};
		
	};
};


typedef TLineTranslateCaps *PLineTranslateCaps;

struct DECLSPEC_DRECORD TLineTranslateCaps
{
	
public:
	union
	{
		struct 
		{
			System::StaticArray<System::Byte, 65521> Data;
		};
		struct 
		{
			unsigned TotalSize;
			unsigned NeededSize;
			unsigned UsedSize;
			unsigned NumLocations;
			unsigned LocationListSize;
			unsigned LocationListOffset;
			unsigned CurrentLocationID;
			unsigned NumCards;
			unsigned CardListSize;
			unsigned CardListOffset;
			unsigned CurrentPreferredCardID;
			unsigned EndMark;
		};
		
	};
};


typedef TLineMonitorTone *PLineMonitorTone;

struct DECLSPEC_DRECORD TLineMonitorTone
{
public:
	unsigned AppSpecific;
	unsigned Duration;
	unsigned Frequency1;
	unsigned Frequency2;
	unsigned Frequency3;
};


typedef TLineGenerateTone *PLineGenerateTone;

struct DECLSPEC_DRECORD TLineGenerateTone
{
public:
	unsigned Frequency;
	unsigned CadenceOn;
	unsigned CadenceOff;
	unsigned Volume;
};


typedef void __stdcall (*TLineCallback)(int Device, int Message, int Instance, int Param1, int Param2, int Param3);

typedef int __stdcall (*TLineInitialize)(int &LineApp, NativeUInt Instance, TLineCallback Callback, char * AppName, unsigned &NumDevs);

typedef int __stdcall (*TLineShutdown)(int LineApp);

typedef int __stdcall (*TLineNegotiateApiVersion)(int LineApp, int DeviceID, int APILowVersion, int APIHighVersion, int &ApiVersion, TLineExtensionID &LE);

typedef int __stdcall (*TLineGetDevCaps)(int LineApp, unsigned DeviceID, unsigned ApiVersion, unsigned ExtVersion, PLineDevCaps LineDevCaps);

typedef int __stdcall (*TLineOpen)(int LineApp, unsigned DeviceID, int &Line, unsigned ApiVersion, unsigned ExtVersion, unsigned CallbackInstance, unsigned Privleges, unsigned MediaModes, unsigned CallParams);

typedef int __stdcall (*TLineMakeCall)(int Line, int &Call, char * DestAddress, unsigned CountryCode, const PLineCallParams CallParams);

typedef int __stdcall (*TLineAccept)(int Call, char * UserUserInfo, unsigned Size);

typedef int __stdcall (*TLineAnswer)(int Call, char * UserUserInfo, unsigned Size);

typedef int __stdcall (*TLineDeallocateCall)(int Call);

typedef int __stdcall (*TLineDrop)(int Call, char * UserInfo, unsigned Size);

typedef int __stdcall (*TLineClose)(int Line);

typedef int __stdcall (*TLineGetCountry)(int CountryID, int ApiVersion, PLineCountryList LineCountryList);

typedef int __stdcall (*TLineConfigDialog)(unsigned DeviceID, HWND Owner, char * DeviceClass);

typedef int __stdcall (*TLineConfigDialogEdit)(unsigned DeviceID, HWND Owner, char * DeviceClass, const void *inDevConfig, unsigned Size, TVarString &DevConfig);

typedef int __stdcall (*TLineGetID)(int Line, unsigned AddressID, int Call, unsigned Select, TVarString &DeviceID, char * DeviceClass);

typedef int __stdcall (*TLineSetStatusMessages)(int Line, unsigned LineStates, unsigned AddressStates);

typedef int __stdcall (*TLineGetStatusMessages)(int Line, unsigned &LineStates, unsigned &AddressStates);

typedef int __stdcall (*TLineGetAddressCaps)(int LineApp, unsigned DeviceID, unsigned AddressId, unsigned ApiVersion, unsigned ExtVersion, PLineAddressCaps LineAddressCaps);

typedef int __stdcall (*TLineGetAddressStatus)(int Line, unsigned AddressID, TLineAddressStatus &AddressStatus);

typedef int __stdcall (*TLineGetLineDevStatus)(int Line, TLineDevStatus &DevStatus);

typedef int __stdcall (*TLineGetDevConfig)(unsigned DeviceID, TVarString &DeviceConfig, char * DeviceClass);

typedef int __stdcall (*TLineSetDevConfig)(unsigned DeviceID, const void *DeviceConfig, unsigned Size, char * DeviceClass);

typedef int __stdcall (*TLineGetCallInfo)(int Call, PCallInfo CallInfo);

typedef int __stdcall (*TLineGetCallStatus)(int Call, PCallStatus CallStatus);

typedef int __stdcall (*TLineSetMediaMode)(int Call, unsigned MediaModes);

typedef int __stdcall (*TLineMonitorDigits)(int Call, unsigned DigitModes);

typedef int __stdcall (*TLineGenerateDigits)(int Call, unsigned DigitModes, char * Digits, unsigned Duration);

typedef int __stdcall (*TLineMonitorMedia)(int Call, unsigned MediaModes);

typedef int __stdcall (*TLineHandoff)(int Call, char * FileName, unsigned MediaMode);

typedef int __stdcall (*TLineSetCallParams)(int Call, unsigned BearerMode, unsigned MinRate, unsigned MaxRate, PLineDialParams DialParams);

typedef int __stdcall (*TLineTranslateAddress)(int Line, unsigned DeviceID, unsigned APIVersion, char * AddressIn, unsigned Card, unsigned TranslateOptions, PLineTranslateOutput TranslateOutput);

typedef int __stdcall (*TLineTranslateDialog)(int Line, unsigned DeviceID, unsigned APIVersion, HWND HwndOwner, char * AddressIn);

typedef int __stdcall (*TLineSetCurrentLocation)(int Line, unsigned Location);

typedef int __stdcall (*TLineSetTollList)(int Line, unsigned DeviceID, char * AddressIn, unsigned TollListOption);

typedef int __stdcall (*TLineGetTranslateCaps)(int Line, unsigned APIVersion, PLineTranslateCaps TranslateCaps);

typedef int __stdcall (*TLineMonitorTones)(int Call, const void *LINEMONITORTONE, unsigned NumEntries);

typedef int __stdcall (*TLineGenerateTones)(int Call, unsigned ToneMode, unsigned Duration, unsigned NumTones, const void *LINEGENERATETONE);

typedef int __stdcall (*TLineHold)(int Call);

typedef int __stdcall (*TLineUnhold)(int Call);

typedef int __stdcall (*TLineTransfer)(int Call, char * DestAddress, unsigned CountryCode);

//-- var, const, procedure ---------------------------------------------------
static const System::Word MaxCountries = System::Word(0x3e8);
static const int TapiLowVer = int(0x10004);
static const int TapiHighVer = int(0x10004);
static const System::Word Wom_Open = System::Word(0x3bb);
static const System::Word Wom_Close = System::Word(0x3bc);
static const System::Word Wom_Done = System::Word(0x3bd);
static const System::Int8 Line_AddressState = System::Int8(0x0);
static const System::Int8 Line_CallInfo = System::Int8(0x1);
static const System::Int8 Line_CallState = System::Int8(0x2);
static const System::Int8 Line_Close = System::Int8(0x3);
static const System::Int8 Line_DevSpecific = System::Int8(0x4);
static const System::Int8 Line_DevSpecificFeature = System::Int8(0x5);
static const System::Int8 Line_GatherDigits = System::Int8(0x6);
static const System::Int8 Line_Generate = System::Int8(0x7);
static const System::Int8 Line_LineDevState = System::Int8(0x8);
static const System::Int8 Line_MonitorDigits = System::Int8(0x9);
static const System::Int8 Line_MonitorMedia = System::Int8(0xa);
static const System::Int8 Line_MonitorTone = System::Int8(0xb);
static const System::Int8 Line_Reply = System::Int8(0xc);
static const System::Int8 Line_Request = System::Int8(0xd);
static const System::Int8 Phone_Button = System::Int8(0xe);
static const System::Int8 Phone_Close = System::Int8(0xf);
static const System::Int8 Phone_DevSpecific = System::Int8(0x10);
static const System::Int8 Phone_Reply = System::Int8(0x11);
static const System::Int8 Phone_State = System::Int8(0x12);
static const System::Int8 Line_Create = System::Int8(0x13);
static const System::Int8 Phone_Create = System::Int8(0x14);
static const System::Int8 Line_AgentSpecific = System::Int8(0x15);
static const System::Int8 Line_AgentStatus = System::Int8(0x16);
static const System::Int8 Line_AppNewCall = System::Int8(0x17);
static const System::Int8 Line_ProxyRequest = System::Int8(0x18);
static const System::Int8 Line_Remove = System::Int8(0x19);
static const System::Int8 Phone_Remove = System::Int8(0x1a);
static const System::Int8 Line_APDSpecific = System::Int8(0x20);
static const System::Int8 LineAddrCapFlags_FwdNumRings = System::Int8(0x1);
static const System::Int8 LineAddrCapFlags_PickupGroupID = System::Int8(0x2);
static const System::Int8 LineAddrCapFlags_Secure = System::Int8(0x4);
static const System::Int8 LineAddrCapFlags_BlockIDDefault = System::Int8(0x8);
static const System::Int8 LineAddrCapFlags_BlockIDOverride = System::Int8(0x10);
static const System::Int8 LineAddrCapFlags_Dialed = System::Int8(0x20);
static const System::Int8 LineAddrCapFlags_OrigOffHook = System::Int8(0x40);
static const System::Byte LineAddrCapFlags_DestOffHook = System::Byte(0x80);
static const System::Word LineAddrCapFlags_FwdConsult = System::Word(0x100);
static const System::Word LineAddrCapFlags_SetupConfNull = System::Word(0x200);
static const System::Word LineAddrCapFlags_AutoReconnect = System::Word(0x400);
static const System::Word LineAddrCapFlags_CompletionID = System::Word(0x800);
static const System::Word LineAddrCapFlags_TransferHeld = System::Word(0x1000);
static const System::Word LineAddrCapFlags_TransferMake = System::Word(0x2000);
static const System::Word LineAddrCapFlags_ConferenceHeld = System::Word(0x4000);
static const System::Word LineAddrCapFlags_ConferenceMake = System::Word(0x8000);
static const int LineAddrCapFlags_PartialDial = int(0x10000);
static const int LineAddrCapFlags_FwdStatusValid = int(0x20000);
static const int LineAddrCapFlags_FwdIntextAddr = int(0x40000);
static const int LineAddrCapFlags_FwdBusyNaAddr = int(0x80000);
static const int LineAddrCapFlags_AcceptToAlert = int(0x100000);
static const int LineAddrCapFlags_ConfDrop = int(0x200000);
static const int LineAddrCapFlags_PickupCallWait = int(0x400000);
static const int LineAddrCapFlags_PredictiveDialer = int(0x800000);
static const int LineAddrCapFlags_Queue = int(0x1000000);
static const int LineAddrCapFlags_RoutePoint = int(0x2000000);
static const int LineAddrCapFlags_HoldMakesNew = int(0x4000000);
static const int LineAddrCapFlags_NoInternalCalls = int(0x8000000);
static const int LineAddrCapFlags_NoExternalCalls = int(0x10000000);
static const int LineAddrCapFlags_SetCallingID = int(0x20000000);
static const System::Int8 LineAddressMode_AddressID = System::Int8(0x1);
static const System::Int8 LineAddressMode_DialableAddr = System::Int8(0x2);
static const System::Int8 LineAddressSharing_Private = System::Int8(0x1);
static const System::Int8 LineAddressSharing_BridgedExcl = System::Int8(0x2);
static const System::Int8 LineAddressSharing_BridgedNew = System::Int8(0x4);
static const System::Int8 LineAddressSharing_BridgedShared = System::Int8(0x8);
static const System::Int8 LineAddressSharing_Monitored = System::Int8(0x10);
static const System::Int8 LineAddressState_Other = System::Int8(0x1);
static const System::Int8 LineAddressState_DevSpecific = System::Int8(0x2);
static const System::Int8 LineAddressState_InUseZero = System::Int8(0x4);
static const System::Int8 LineAddressState_InUseOne = System::Int8(0x8);
static const System::Int8 LineAddressState_InUseMany = System::Int8(0x10);
static const System::Int8 LineAddressState_NumCalls = System::Int8(0x20);
static const System::Int8 LineAddressState_Forward = System::Int8(0x40);
static const System::Byte LineAddressState_Terminals = System::Byte(0x80);
static const System::Word LineAddressState_CapsChange = System::Word(0x100);
static const System::Word AllAddressStates = System::Word(0x1ff);
static const System::Int8 LineAddrFeature_Forward = System::Int8(0x1);
static const System::Int8 LineAddrFeature_MakeCall = System::Int8(0x2);
static const System::Int8 LineAddrFeature_Pickup = System::Int8(0x4);
static const System::Int8 LineAddrFeature_SetMediaControl = System::Int8(0x8);
static const System::Int8 LineAddrFeature_SetTerminal = System::Int8(0x10);
static const System::Int8 LineAddrFeature_SetupConf = System::Int8(0x20);
static const System::Int8 LineAddrFeature_UncompleteCall = System::Int8(0x40);
static const System::Byte LineAddrFeature_Unpark = System::Byte(0x80);
static const System::Word LineAddrFeature_PickupHeld = System::Word(0x100);
static const System::Word LineAddrFeature_PickupGroup = System::Word(0x200);
static const System::Word LineAddrFeature_PickupDirect = System::Word(0x400);
static const System::Word LineAddrFeature_PickupWaiting = System::Word(0x800);
static const System::Word LineAddrFeature_ForwardFwd = System::Word(0x1000);
static const System::Word LineAddrFeature_ForwardDnd = System::Word(0x2000);
static const System::Int8 LineAgentFeature_SetAgentGroup = System::Int8(0x1);
static const System::Int8 LineAgentFeature_SetAgentState = System::Int8(0x2);
static const System::Int8 LineAgentFeature_SetAgentActivity = System::Int8(0x4);
static const System::Int8 LineAgentFeature_AgentSpecific = System::Int8(0x8);
static const System::Int8 LineAgentFeature_GetAgentActivityList = System::Int8(0x10);
static const System::Int8 LineAgentFeature_GetAgentGroup = System::Int8(0x20);
static const System::Int8 LineAgentState_LoggedOff = System::Int8(0x1);
static const System::Int8 LineAgentState_NotReady = System::Int8(0x2);
static const System::Int8 LineAgentState_Ready = System::Int8(0x4);
static const System::Int8 LineAgentState_BusyAcd = System::Int8(0x8);
static const System::Int8 LineAgentState_BusyIncoming = System::Int8(0x10);
static const System::Int8 LineAgentState_BusyOutbound = System::Int8(0x20);
static const System::Int8 LineAgentState_BusyOther = System::Int8(0x40);
static const System::Byte LineAgentState_WorkingAfterCall = System::Byte(0x80);
static const System::Word LineAgentState_Unknown = System::Word(0x100);
static const System::Word LineAgentState_Unavail = System::Word(0x200);
static const System::Int8 LineAgentStatus_Group = System::Int8(0x1);
static const System::Int8 LineAgentStatus_State = System::Int8(0x2);
static const System::Int8 LineAgentStatus_NextState = System::Int8(0x4);
static const System::Int8 LineAgentStatus_Activity = System::Int8(0x8);
static const System::Int8 LineAgentStatus_ActivityList = System::Int8(0x10);
static const System::Int8 LineAgentStatus_GroupList = System::Int8(0x20);
static const System::Int8 LineAgentStatus_CapsChange = System::Int8(0x40);
static const System::Byte LineAgentStatus_ValidStates = System::Byte(0x80);
static const System::Word LineAgentStatus_ValidNextStates = System::Word(0x100);
static const System::Int8 LineAnswerMode_None = System::Int8(0x1);
static const System::Int8 LineAnswerMode_Drop = System::Int8(0x2);
static const System::Int8 LineAnswerMode_Hold = System::Int8(0x4);
static const System::Int8 LineBearerMode_Voice = System::Int8(0x1);
static const System::Int8 LineBearerMode_Speech = System::Int8(0x2);
static const System::Int8 LineBearerMode_MultiUse = System::Int8(0x4);
static const System::Int8 LineBearerMode_Data = System::Int8(0x8);
static const System::Int8 LineBearerMode_AltSpeechData = System::Int8(0x10);
static const System::Int8 LineBearerMode_NonCallSignaling = System::Int8(0x20);
static const System::Int8 LineBearerMode_PassThrough = System::Int8(0x40);
static const System::Byte LineBearerMode_RestrictedData = System::Byte(0x80);
static const System::Int8 LineBusyMode_Station = System::Int8(0x1);
static const System::Int8 LineBusyMode_Trunk = System::Int8(0x2);
static const System::Int8 LineBusyMode_Unknown = System::Int8(0x4);
static const System::Int8 LineBusyMode_Unavail = System::Int8(0x8);
static const System::Int8 LineCallComplCond_Busy = System::Int8(0x1);
static const System::Int8 LineCallComplCond_NoAnswer = System::Int8(0x2);
static const System::Int8 LineCallComplMode_CampOn = System::Int8(0x1);
static const System::Int8 LineCallComplMode_CallBack = System::Int8(0x2);
static const System::Int8 LineCallComplMode_Intrude = System::Int8(0x4);
static const System::Int8 LineCallComplMode_Message = System::Int8(0x8);
static const System::Int8 LineCallFeature_Accept = System::Int8(0x1);
static const System::Int8 LineCallFeature_AddToConf = System::Int8(0x2);
static const System::Int8 LineCallFeature_Answer = System::Int8(0x4);
static const System::Int8 LineCallFeature_BlindTransfer = System::Int8(0x8);
static const System::Int8 LineCallFeature_CompleteCall = System::Int8(0x10);
static const System::Int8 LineCallFeature_CompleteTransf = System::Int8(0x20);
static const System::Int8 LineCallFeature_Dial = System::Int8(0x40);
static const System::Byte LineCallFeature_Drop = System::Byte(0x80);
static const System::Word LineCallFeature_GatherDigits = System::Word(0x100);
static const System::Word LineCallFeature_GenerateDigits = System::Word(0x200);
static const System::Word LineCallFeature_GenerateTone = System::Word(0x400);
static const System::Word LineCallFeature_Hold = System::Word(0x800);
static const System::Word LineCallFeature_MonitorDigits = System::Word(0x1000);
static const System::Word LineCallFeature_MonitorMedia = System::Word(0x2000);
static const System::Word LineCallFeature_MonitorTones = System::Word(0x4000);
static const System::Word LineCallFeature_Park = System::Word(0x8000);
static const int LineCallFeature_PrepareAddConf = int(0x10000);
static const int LineCallFeature_ReDirect = int(0x20000);
static const int LineCallFeature_RemoveFromConf = int(0x40000);
static const int LineCallFeature_SecureCall = int(0x80000);
static const int LineCallFeature_SendUserUser = int(0x100000);
static const int LineCallFeature_SetCallparams = int(0x200000);
static const int LineCallFeature_SetMediaControl = int(0x400000);
static const int LineCallFeature_SetTerminal = int(0x800000);
static const int LineCallFeature_SetupConf = int(0x1000000);
static const int LineCallFeature_SetupTransfer = int(0x2000000);
static const int LineCallFeature_SwapHold = int(0x4000000);
static const int LineCallFeature_UnHold = int(0x8000000);
static const int LineCallFeature_ReleaseUserUserInfo = int(0x10000000);
static const int LineCallFeature_SetTreatment = int(0x20000000);
static const int LineCallFeature_SetQos = int(0x40000000);
static const unsigned LineCallFeature_SetCallData = unsigned(0x80000000);
static const System::Int8 LineCallFeature2_NoHoldConference = System::Int8(0x1);
static const System::Int8 LineCallFeature2_OneStepTransfer = System::Int8(0x2);
static const System::Int8 LineCallFeature2_ComplCampOn = System::Int8(0x4);
static const System::Int8 LineCallFeature2_ComplCallback = System::Int8(0x8);
static const System::Int8 LineCallFeature2_ComplIntrude = System::Int8(0x10);
static const System::Int8 LineCallFeature2_ComplMessage = System::Int8(0x20);
static const System::Int8 LineCallFeature2_TransferNorm = System::Int8(0x40);
static const System::Byte LineCallFeature2_TransferConf = System::Byte(0x80);
static const System::Word LineCallFeature2_ParkDirect = System::Word(0x100);
static const System::Word LineCallFeature2_ParkNonDirect = System::Word(0x200);
static const System::Int8 LineCallInfoState_Other = System::Int8(0x1);
static const System::Int8 LineCallInfoState_DevSpecific = System::Int8(0x2);
static const System::Int8 LineCallInfoState_BearerMode = System::Int8(0x4);
static const System::Int8 LineCallInfoState_Rate = System::Int8(0x8);
static const System::Int8 LineCallInfoState_MediaMode = System::Int8(0x10);
static const System::Int8 LineCallInfoState_AppSpecific = System::Int8(0x20);
static const System::Int8 LineCallInfoState_CallID = System::Int8(0x40);
static const System::Byte LineCallInfoState_RelatedCallID = System::Byte(0x80);
static const System::Word LineCallInfoState_Origin = System::Word(0x100);
static const System::Word LineCallInfoState_Reason = System::Word(0x200);
static const System::Word LineCallInfoState_CompletionID = System::Word(0x400);
static const System::Word LineCallInfoState_NumOwnerIncr = System::Word(0x800);
static const System::Word LineCallInfoState_NumOwnerDecr = System::Word(0x1000);
static const System::Word LineCallInfoState_NumMonitors = System::Word(0x2000);
static const System::Word LineCallInfoState_Trunk = System::Word(0x4000);
static const System::Word LineCallInfoState_CallerID = System::Word(0x8000);
static const int LineCallInfoState_CalledID = int(0x10000);
static const int LineCallInfoState_ConnectedID = int(0x20000);
static const int LineCallInfoState_RedirectionID = int(0x40000);
static const int LineCallInfoState_RedirectingID = int(0x80000);
static const int LineCallInfoState_Display = int(0x100000);
static const int LineCallInfoState_UserUserInfo = int(0x200000);
static const int LineCallInfoState_HighLevelComp = int(0x400000);
static const int LineCallInfoState_LowLevelComp = int(0x800000);
static const int LineCallInfoState_ChargingInfo = int(0x1000000);
static const int LineCallInfoState_Terminal = int(0x2000000);
static const int LineCallInfoState_DialParams = int(0x4000000);
static const int LineCallInfoState_MonitorModes = int(0x8000000);
static const int LineCallInfoState_Treatment = int(0x10000000);
static const int LineCallInfoState_Qos = int(0x20000000);
static const int LineCallInfoState_CallData = int(0x40000000);
static const System::Int8 LineCallOrigin_Outbound = System::Int8(0x1);
static const System::Int8 LineCallOrigin_Internal = System::Int8(0x2);
static const System::Int8 LineCallOrigin_External = System::Int8(0x4);
static const System::Int8 LineCallOrigin_Unknown = System::Int8(0x10);
static const System::Int8 LineCallOrigin_Unavail = System::Int8(0x20);
static const System::Int8 LineCallOrigin_Conference = System::Int8(0x40);
static const System::Byte LineCallOrigin_Inbound = System::Byte(0x80);
static const System::Int8 LineCallParamFlags_Secure = System::Int8(0x1);
static const System::Int8 LineCallParamFlags_Idle = System::Int8(0x2);
static const System::Int8 LineCallParamFlags_BlockID = System::Int8(0x4);
static const System::Int8 LineCallParamFlags_OrigOffHook = System::Int8(0x8);
static const System::Int8 LineCallParamFlags_DestOffHook = System::Int8(0x10);
static const System::Int8 LineCallParamFlags_NoHoldConference = System::Int8(0x20);
static const System::Int8 LineCallParamFlags_PredictiveDial = System::Int8(0x40);
static const System::Byte LineCallParamFlags_OneStepTransfer = System::Byte(0x80);
static const System::Int8 LineCallPartyID_Blocked = System::Int8(0x1);
static const System::Int8 LineCallPartyID_OutOfArea = System::Int8(0x2);
static const System::Int8 LineCallPartyID_Name = System::Int8(0x4);
static const System::Int8 LineCallPartyID_Address = System::Int8(0x8);
static const System::Int8 LineCallPartyID_Partial = System::Int8(0x10);
static const System::Int8 LineCallPartyID_Unknown = System::Int8(0x20);
static const System::Int8 LineCallPartyID_Unavail = System::Int8(0x40);
static const System::Int8 LineCallPrivilege_None = System::Int8(0x1);
static const System::Int8 LineCallPrivilege_Monitor = System::Int8(0x2);
static const System::Int8 LineCallPrivilege_Owner = System::Int8(0x4);
static const System::Int8 LineCallReason_Direct = System::Int8(0x1);
static const System::Int8 LineCallReason_FwdBusy = System::Int8(0x2);
static const System::Int8 LineCallReason_FwdNoAnswer = System::Int8(0x4);
static const System::Int8 LineCallReason_FwdUnCond = System::Int8(0x8);
static const System::Int8 LineCallReason_Pickup = System::Int8(0x10);
static const System::Int8 LineCallReason_Unpark = System::Int8(0x20);
static const System::Int8 LineCallReason_Redirect = System::Int8(0x40);
static const System::Byte LineCallReason_CallCompletion = System::Byte(0x80);
static const System::Word LineCallReason_Transfer = System::Word(0x100);
static const System::Word LineCallReason_Reminder = System::Word(0x200);
static const System::Word LineCallReason_Unknown = System::Word(0x400);
static const System::Word LineCallReason_Unavail = System::Word(0x800);
static const System::Word LineCallReason_Intrude = System::Word(0x1000);
static const System::Word LineCallReason_Parked = System::Word(0x2000);
static const System::Word LineCallReason_CampedOn = System::Word(0x4000);
static const System::Word LineCallReason_RouteRequest = System::Word(0x8000);
static const System::Int8 LineCallSelect_Line = System::Int8(0x1);
static const System::Int8 LineCallSelect_Address = System::Int8(0x2);
static const System::Int8 LineCallSelect_Call = System::Int8(0x4);
static const System::Int8 LineCallState_Idle = System::Int8(0x1);
static const System::Int8 LineCallState_Offering = System::Int8(0x2);
static const System::Int8 LineCallState_Accepted = System::Int8(0x4);
static const System::Int8 LineCallState_Dialtone = System::Int8(0x8);
static const System::Int8 LineCallState_Dialing = System::Int8(0x10);
static const System::Int8 LineCallState_Ringback = System::Int8(0x20);
static const System::Int8 LineCallState_Busy = System::Int8(0x40);
static const System::Byte LineCallState_SpecialInfo = System::Byte(0x80);
static const System::Word LineCallState_Connected = System::Word(0x100);
static const System::Word LineCallState_Proceeding = System::Word(0x200);
static const System::Word LineCallState_OnHold = System::Word(0x400);
static const System::Word LineCallState_Conferenced = System::Word(0x800);
static const System::Word LineCallState_OnHoldPendConf = System::Word(0x1000);
static const System::Word LineCallState_OnHoldPendTransfer = System::Word(0x2000);
static const System::Word LineCallState_Disconnected = System::Word(0x4000);
static const System::Word LineCallState_Unknown = System::Word(0x8000);
static const System::Int8 LineCallTreatment_Silence = System::Int8(0x1);
static const System::Int8 LineCallTreatment_Ringback = System::Int8(0x2);
static const System::Int8 LineCallTreatment_Busy = System::Int8(0x3);
static const System::Int8 LineCallTreatment_Music = System::Int8(0x4);
static const System::Int8 LineCardOption_Predefined = System::Int8(0x1);
static const System::Int8 LineCardOption_Hidden = System::Int8(0x2);
static const System::Int8 LineConnectedMode_Active = System::Int8(0x1);
static const System::Int8 LineConnectedMode_Inactive = System::Int8(0x2);
static const System::Int8 LineConnectedMode_ActiveHeld = System::Int8(0x4);
static const System::Int8 LineConnectedMode_InactiveHeld = System::Int8(0x8);
static const System::Int8 LineConnectedMode_Confirmed = System::Int8(0x10);
static const System::Int8 LineDevCapFlags_CrossAddrConf = System::Int8(0x1);
static const System::Int8 LineDevCapFlags_HighLevComp = System::Int8(0x2);
static const System::Int8 LineDevCapFlags_LowLevComp = System::Int8(0x4);
static const System::Int8 LineDevCapFlags_MediaControl = System::Int8(0x8);
static const System::Int8 LineDevCapFlags_MultipleAddr = System::Int8(0x10);
static const System::Int8 LineDevCapFlags_CloseDrop = System::Int8(0x20);
static const System::Int8 LineDevCapFlags_DialBilling = System::Int8(0x40);
static const System::Byte LineDevCapFlags_DialQuiet = System::Byte(0x80);
static const System::Word LineDevCapFlags_DialDialtone = System::Word(0x100);
static const System::Int8 LineDevState_Other = System::Int8(0x1);
static const System::Int8 LineDevState_Ringing = System::Int8(0x2);
static const System::Int8 LineDevState_Connected = System::Int8(0x4);
static const System::Int8 LineDevState_Disconnected = System::Int8(0x8);
static const System::Int8 LineDevState_MsgWaitOn = System::Int8(0x10);
static const System::Int8 LineDevState_MsgWaitOff = System::Int8(0x20);
static const System::Int8 LineDevState_InService = System::Int8(0x40);
static const System::Byte LineDevState_OutOfService = System::Byte(0x80);
static const System::Word LineDevState_Maintenance = System::Word(0x100);
static const System::Word LineDevState_Open = System::Word(0x200);
static const System::Word LineDevState_Close = System::Word(0x400);
static const System::Word LineDevState_NumCalls = System::Word(0x800);
static const System::Word LineDevState_NumCompletions = System::Word(0x1000);
static const System::Word LineDevState_Terminals = System::Word(0x2000);
static const System::Word LineDevState_RoamMode = System::Word(0x4000);
static const System::Word LineDevState_Battery = System::Word(0x8000);
static const int LineDevState_Signal = int(0x10000);
static const int LineDevState_DevSpecific = int(0x20000);
static const int LineDevState_ReInit = int(0x40000);
static const int LineDevState_Lock = int(0x80000);
static const int LineDevState_CapsChange = int(0x100000);
static const int LineDevState_ConfigChange = int(0x200000);
static const int LineDevState_TranslateChange = int(0x400000);
static const int LineDevState_ComplCancel = int(0x800000);
static const int LineDevState_Removed = int(0x1000000);
static const int AllLineDeviceStates = int(0x1ffffff);
static const System::Int8 LineDevStatusFlags_Connected = System::Int8(0x1);
static const System::Int8 LineDevStatusFlags_MsgWait = System::Int8(0x2);
static const System::Int8 LineDevStatusFlags_InService = System::Int8(0x4);
static const System::Int8 LineDevStatusFlags_Locked = System::Int8(0x8);
static const System::Int8 LineDialToneMode_Normal = System::Int8(0x1);
static const System::Int8 LineDialToneMode_Special = System::Int8(0x2);
static const System::Int8 LineDialToneMode_Internal = System::Int8(0x4);
static const System::Int8 LineDialToneMode_External = System::Int8(0x8);
static const System::Int8 LineDialToneMode_Unknown = System::Int8(0x10);
static const System::Int8 LineDialToneMode_Unavail = System::Int8(0x20);
static const System::Int8 LineDigitMode_Pulse = System::Int8(0x1);
static const System::Int8 LineDigitMode_DTMF = System::Int8(0x2);
static const System::Int8 LineDigitMode_DTMFEnd = System::Int8(0x4);
static const System::Int8 LineDisconnectMode_Normal = System::Int8(0x1);
static const System::Int8 LineDisconnectMode_Unknown = System::Int8(0x2);
static const System::Int8 LineDisconnectMode_Reject = System::Int8(0x4);
static const System::Int8 LineDisconnectMode_PickUp = System::Int8(0x8);
static const System::Int8 LineDisconnectMode_Forwarded = System::Int8(0x10);
static const System::Int8 LineDisconnectMode_Busy = System::Int8(0x20);
static const System::Int8 LineDisconnectMode_NoAnswer = System::Int8(0x40);
static const System::Byte LineDisconnectMode_BadAddress = System::Byte(0x80);
static const System::Word LineDisconnectMode_Unreachable = System::Word(0x100);
static const System::Word LineDisconnectMode_Congestion = System::Word(0x200);
static const System::Word LineDisconnectMode_Incompatible = System::Word(0x400);
static const System::Word LineDisconnectMode_Unavail = System::Word(0x800);
static const System::Word LineDisconnectMode_NoDialtone = System::Word(0x1000);
static const System::Word LineDisconnectMode_NumberChanged = System::Word(0x2000);
static const System::Word LineDisconnectMode_OutOfOrder = System::Word(0x4000);
static const System::Word LineDisconnectMode_TempFailure = System::Word(0x8000);
static const int LineDisconnectMode_QOSUnavail = int(0x10000);
static const int LineDisconnectMode_Blocked = int(0x20000);
static const int LineDisconnectMode_DoNotDisturb = int(0x40000);
static const int LineDisconnectMode_Cancelled = int(0x80000);
static const int LineErr_Allocated = int(-2147483647);
static const int LineErr_BadDeviceID = int(-2147483646);
static const int LineErr_BearerModeUnavail = int(-2147483645);
static const int LineErr_CallUnavail = int(-2147483643);
static const int LineErr_CompletionOverRun = int(-2147483642);
static const int LineErr_ConferenceFull = int(-2147483641);
static const int LineErr_DialBilling = int(-2147483640);
static const int LineErr_DialDialtone = int(-2147483639);
static const int LineErr_DialPrompt = int(-2147483638);
static const int LineErr_DialQuiet = int(-2147483637);
static const int LineErr_IncompatibleApiVersion = int(-2147483636);
static const int LineErr_IncompatibleExtVersion = int(-2147483635);
static const int LineErr_IniFileCorrupt = int(-2147483634);
static const int LineErr_InUse = int(-2147483633);
static const int LineErr_InvalAddress = int(-2147483632);
static const int LineErr_InvalAddressID = int(-2147483631);
static const int LineErr_InvalAddressMode = int(-2147483630);
static const int LineErr_InvalAddressState = int(-2147483629);
static const int LineErr_InvalAppHandle = int(-2147483628);
static const int LineErr_InvalAppName = int(-2147483627);
static const int LineErr_InvalBearerMode = int(-2147483626);
static const int LineErr_InvalCallComplMode = int(-2147483625);
static const int LineErr_InvalCallHandle = int(-2147483624);
static const int LineErr_InvalCallParams = int(-2147483623);
static const int LineErr_InvalCallPrivilege = int(-2147483622);
static const int LineErr_InvalCallSelect = int(-2147483621);
static const int LineErr_InvalCallState = int(-2147483620);
static const int LineErr_InvalCallStateList = int(-2147483619);
static const int LineErr_InvalCard = int(-2147483618);
static const int LineErr_InvalCompletionID = int(-2147483617);
static const int LineErr_InvalConfCallHandle = int(-2147483616);
static const int LineErr_InvalConsultCallHandle = int(-2147483615);
static const int LineErr_InvalCountryCode = int(-2147483614);
static const int LineErr_InvalDeviceClass = int(-2147483613);
static const int LineErr_InvalDeviceHandle = int(-2147483612);
static const int LineErr_InvalDialParams = int(-2147483611);
static const int LineErr_InvalDigitList = int(-2147483610);
static const int LineErr_InvalDigitMode = int(-2147483609);
static const int LineErr_InvalDigits = int(-2147483608);
static const int LineErr_InvalExtVersion = int(-2147483607);
static const int LineErr_InvalGroupID = int(-2147483606);
static const int LineErr_InvalLineHandle = int(-2147483605);
static const int LineErr_InvalLineState = int(-2147483604);
static const int LineErr_InvalLocation = int(-2147483603);
static const int LineErr_InvalMediaList = int(-2147483602);
static const int LineErr_InvalMediaMode = int(-2147483601);
static const int LineErr_InvalMessageID = int(-2147483600);
static const int LineErr_InvalParam = int(-2147483598);
static const int LineErr_InvalParkID = int(-2147483597);
static const int LineErr_InvalParkMode = int(-2147483596);
static const int LineErr_InvalPointer = int(-2147483595);
static const int LineErr_InvalPrivSelect = int(-2147483594);
static const int LineErr_InvalRate = int(-2147483593);
static const int LineErr_InvalRequestMode = int(-2147483592);
static const int LineErr_InvalTerminalID = int(-2147483591);
static const int LineErr_InvalTerminalMode = int(-2147483590);
static const int LineErr_InvalTimeout = int(-2147483589);
static const int LineErr_InvalTone = int(-2147483588);
static const int LineErr_InvalToneList = int(-2147483587);
static const int LineErr_InvalToneMode = int(-2147483586);
static const int LineErr_InvalTransferMode = int(-2147483585);
static const int LineErr_LineMapperFailed = int(-2147483584);
static const int LineErr_NoConference = int(-2147483583);
static const int LineErr_NoDevice = int(-2147483582);
static const int LineErr_NoDriver = int(-2147483581);
static const int LineErr_NoMem = int(-2147483580);
static const int LineErr_NoRequest = int(-2147483579);
static const int LineErr_NotOwner = int(-2147483578);
static const int LineErr_NotRegistered = int(-2147483577);
static const int LineErr_OperationFailed = int(-2147483576);
static const int LineErr_OperationUnavail = int(-2147483575);
static const int LineErr_RateUnavail = int(-2147483574);
static const int LineErr_ResourceUnavail = int(-2147483573);
static const int LineErr_RequestOverRun = int(-2147483572);
static const int LineErr_StructureTooSmall = int(-2147483571);
static const int LineErr_TargetNotFound = int(-2147483570);
static const int LineErr_TargetSelf = int(-2147483569);
static const int LineErr_Uninitialized = int(-2147483568);
static const int LineErr_UserUserInfoTooBig = int(-2147483567);
static const int LineErr_ReInit = int(-2147483566);
static const int LineErr_AddressBlocked = int(-2147483565);
static const int LineErr_BillingRejected = int(-2147483564);
static const int LineErr_InvalFeature = int(-2147483563);
static const int LineErr_NoMultipleInstance = int(-2147483562);
static const int LineErr_InvalAgentID = int(-2147483561);
static const int LineErr_InvalAgentGroup = int(-2147483560);
static const int LineErr_InvalPassword = int(-2147483559);
static const int LineErr_InvalAgentState = int(-2147483558);
static const int LineErr_InvalAgentActivity = int(-2147483557);
static const int LineErr_DialVoiceDetect = int(-2147483556);
static const System::Int8 LineFeature_DevSpecific = System::Int8(0x1);
static const System::Int8 LineFeature_DevSpecificFeat = System::Int8(0x2);
static const System::Int8 LineFeature_Forward = System::Int8(0x4);
static const System::Int8 LineFeature_MakeCall = System::Int8(0x8);
static const System::Int8 LineFeature_SetMediaControl = System::Int8(0x10);
static const System::Int8 LineFeature_SetTerminal = System::Int8(0x20);
static const System::Int8 LineFeature_SetDevStatus = System::Int8(0x40);
static const System::Byte LineFeature_ForwardFwd = System::Byte(0x80);
static const System::Word LineFeature_ForwardDnd = System::Word(0x100);
static const System::Int8 LineForwardMode_Uncond = System::Int8(0x1);
static const System::Int8 LineForwardMode_UncondInternal = System::Int8(0x2);
static const System::Int8 LineForwardMode_UncondExternal = System::Int8(0x4);
static const System::Int8 LineForwardMode_UncondSpecific = System::Int8(0x8);
static const System::Int8 LineForwardMode_Busy = System::Int8(0x10);
static const System::Int8 LineForwardMode_BusyInternal = System::Int8(0x20);
static const System::Int8 LineForwardMode_BusyExternal = System::Int8(0x40);
static const System::Byte LineForwardMode_BusySpecific = System::Byte(0x80);
static const System::Word LineForwardMode_NoAnsw = System::Word(0x100);
static const System::Word LineForwardMode_NoAnswInternal = System::Word(0x200);
static const System::Word LineForwardMode_NoAnswExternal = System::Word(0x400);
static const System::Word LineForwardMode_NoAnswSpecific = System::Word(0x800);
static const System::Word LineForwardMode_BusyNA = System::Word(0x1000);
static const System::Word LineForwardMode_BusyNAInternal = System::Word(0x2000);
static const System::Word LineForwardMode_BusyNAExternal = System::Word(0x4000);
static const System::Word LineForwardMode_BusyNASpecific = System::Word(0x8000);
static const int LineForwardMode_Unknown = int(0x10000);
static const int LineForwardMode_Unavail = int(0x20000);
static const System::Int8 LineGatherTerm_BufferFull = System::Int8(0x1);
static const System::Int8 LineGatherTerm_TermDigit = System::Int8(0x2);
static const System::Int8 LineGatherTerm_FirstTimeout = System::Int8(0x4);
static const System::Int8 LineGatherTerm_InterTimeout = System::Int8(0x8);
static const System::Int8 LineGatherTerm_Cancel = System::Int8(0x10);
static const System::Int8 LineGenerateTerm_Done = System::Int8(0x1);
static const System::Int8 LineGenerateTerm_Cancel = System::Int8(0x2);
static const System::Int8 LineInitializeExOption_UseHiddenWindow = System::Int8(0x1);
static const System::Int8 LineInitializeExOption_UseEvent = System::Int8(0x2);
static const System::Int8 LineInitializeExOption_UseCompletionPort = System::Int8(0x3);
static const System::Int8 LineLocationOption_PulseDial = System::Int8(0x1);
static const unsigned LineMapper = unsigned(0xffffffff);
static const System::Int8 LineMediaControl_None = System::Int8(0x1);
static const System::Int8 LineMediaControl_Start = System::Int8(0x2);
static const System::Int8 LineMediaControl_Reset = System::Int8(0x4);
static const System::Int8 LineMediaControl_Pause = System::Int8(0x8);
static const System::Int8 LineMediaControl_Resume = System::Int8(0x10);
static const System::Int8 LineMediaControl_RateUp = System::Int8(0x20);
static const System::Int8 LineMediaControl_RateDown = System::Int8(0x40);
static const System::Byte LineMediaControl_RateNormal = System::Byte(0x80);
static const System::Word LineMediaControl_VolumeUp = System::Word(0x100);
static const System::Word LineMediaControl_VolumeDown = System::Word(0x200);
static const System::Word LineMediaControl_VolumeNormal = System::Word(0x400);
static const System::Int8 LineMediaMode_Unknown = System::Int8(0x2);
static const System::Int8 LineMediaMode_InteractiveVoice = System::Int8(0x4);
static const System::Int8 LineMediaMode_AutomatedVoice = System::Int8(0x8);
static const System::Int8 LineMediaMode_DataModem = System::Int8(0x10);
static const System::Int8 LineMediaMode_G3Fax = System::Int8(0x20);
static const System::Int8 LineMediaMode_TDD = System::Int8(0x40);
static const System::Byte LineMediaMode_G4Fax = System::Byte(0x80);
static const System::Word LineMediaMode_DigitalData = System::Word(0x100);
static const System::Word LineMediaMode_Teletex = System::Word(0x200);
static const System::Word LineMediaMode_Videotex = System::Word(0x400);
static const System::Word LineMediaMode_Telex = System::Word(0x800);
static const System::Word LineMediaMode_Mixed = System::Word(0x1000);
static const System::Word LineMediaMode_ADSI = System::Word(0x2000);
static const System::Word LineMediaMode_VoiceView = System::Word(0x4000);
static const System::Word Last_LineMediaMode = System::Word(0x4000);
static const System::Int8 LineOfferingMode_Active = System::Int8(0x1);
static const System::Int8 LineOfferingMode_Inactive = System::Int8(0x2);
static const unsigned LineOpenOption_SingleAddress = unsigned(0x80000000);
static const int LineOpenOption_Proxy = int(0x40000000);
static const System::Int8 LineParkMode_Directed = System::Int8(0x1);
static const System::Int8 LineParkMode_NonDirected = System::Int8(0x2);
static const System::Int8 LineProxyRequest_SetAgentGroup = System::Int8(0x1);
static const System::Int8 LineProxyRequest_SetAgentState = System::Int8(0x2);
static const System::Int8 LineProxyRequest_SetAgentActivity = System::Int8(0x3);
static const System::Int8 LineProxyRequest_GetAgentCaps = System::Int8(0x4);
static const System::Int8 LineProxyRequest_GetAgentStatus = System::Int8(0x5);
static const System::Int8 LineProxyRequest_AgentSpecific = System::Int8(0x6);
static const System::Int8 LineProxyRequest_GetAgentActivityList = System::Int8(0x7);
static const System::Int8 LineProxyRequest_GetAgentGroupList = System::Int8(0x8);
static const System::Int8 LineRemoveFromConf_None = System::Int8(0x1);
static const System::Int8 LineRemoveFromConf_Last = System::Int8(0x2);
static const System::Int8 LineRemoveFromConf_Any = System::Int8(0x3);
static const System::Int8 LineRequestMode_MakeCall = System::Int8(0x1);
static const System::Int8 LineRequestMode_MediaCall = System::Int8(0x2);
static const System::Int8 LineRequestMode_Drop = System::Int8(0x4);
static const System::Int8 Last_LineRequestMode = System::Int8(0x2);
static const System::Int8 LineRoamMode_Unknown = System::Int8(0x1);
static const System::Int8 LineRoamMode_Unavail = System::Int8(0x2);
static const System::Int8 LineRoamMode_Home = System::Int8(0x4);
static const System::Int8 LineRoamMode_RoamA = System::Int8(0x8);
static const System::Int8 LineRoamMode_RoamB = System::Int8(0x10);
static const System::Int8 LineSpecialInfo_NoCircuit = System::Int8(0x1);
static const System::Int8 LineSpecialInfo_CustIrreg = System::Int8(0x2);
static const System::Int8 LineSpecialInfo_Reorder = System::Int8(0x4);
static const System::Int8 LineSpecialInfo_Unknown = System::Int8(0x8);
static const System::Int8 LineSpecialInfo_Unavail = System::Int8(0x10);
static const System::Int8 LineTermDev_Phone = System::Int8(0x1);
static const System::Int8 LineTermDev_Headset = System::Int8(0x2);
static const System::Int8 LineTermDev_Speaker = System::Int8(0x4);
static const System::Int8 LineTermMode_Buttons = System::Int8(0x1);
static const System::Int8 LineTermMode_Lamps = System::Int8(0x2);
static const System::Int8 LineTermMode_Display = System::Int8(0x4);
static const System::Int8 LineTermMode_Ringer = System::Int8(0x8);
static const System::Int8 LineTermMode_HookSwitch = System::Int8(0x10);
static const System::Int8 LineTermMode_MediaToLine = System::Int8(0x20);
static const System::Int8 LineTermMode_MediaFromLine = System::Int8(0x40);
static const System::Byte LineTermMode_MediaBiDirect = System::Byte(0x80);
static const System::Int8 LineTermSharing_Private = System::Int8(0x1);
static const System::Int8 LineTermSharing_SharedExcl = System::Int8(0x2);
static const System::Int8 LineTermSharing_SharedConf = System::Int8(0x4);
static const System::Int8 LineTollListOption_Add = System::Int8(0x1);
static const System::Int8 LineTollListOption_Remove = System::Int8(0x2);
static const System::Int8 LineToneMode_Custom = System::Int8(0x1);
static const System::Int8 LineToneMode_Ringback = System::Int8(0x2);
static const System::Int8 LineToneMode_Busy = System::Int8(0x4);
static const System::Int8 LineToneMode_Beep = System::Int8(0x8);
static const System::Int8 LineToneMode_Billing = System::Int8(0x10);
static const System::Int8 LineTransferMode_Transfer = System::Int8(0x1);
static const System::Int8 LineTransferMode_Conference = System::Int8(0x2);
static const System::Int8 LineTranslateOption_CareOverride = System::Int8(0x1);
static const System::Int8 LineTranslateOption_CancelCallWaiting = System::Int8(0x2);
static const System::Int8 LineTranslateOption_ForceLocal = System::Int8(0x4);
static const System::Int8 LineTranslateOption_ForceLD = System::Int8(0x8);
static const System::Int8 LineTranslateResult_Canonical = System::Int8(0x1);
static const System::Int8 LineTranslateResult_International = System::Int8(0x2);
static const System::Int8 LineTranslateResult_LongDistance = System::Int8(0x4);
static const System::Int8 LineTranslateResult_Local = System::Int8(0x8);
static const System::Int8 LineTranslateResult_InTollList = System::Int8(0x10);
static const System::Int8 LineTranslateResult_NotInTollList = System::Int8(0x20);
static const System::Int8 LineTranslateResult_DialBilling = System::Int8(0x40);
static const System::Byte LineTranslateResult_DialQuiet = System::Byte(0x80);
static const System::Word LineTranslateResult_DialDialTone = System::Word(0x100);
static const System::Word LineTranslateResult_DialPrompt = System::Word(0x200);
static const System::Word LineTranslateResult_VoiceDetect = System::Word(0x400);
static const System::Int8 APDSPECIFIC_TAPIChange = System::Int8(0x1);
static const System::Int8 APDSPECIFIC_BUSY = System::Int8(0x2);
static const System::Int8 APDSPECIFIC_DIALFAIL = System::Int8(0x4);
static const System::Int8 APDSPECIFIC_RETRYWAIT = System::Int8(0x8);
static const System::Int8 APDSPECIFIC_DEVICEInUse = System::Int8(0x10);
extern DELPHI_PACKAGE int __fastcall tuLineGenerateTones(int Call, unsigned ToneMode, unsigned Duration, unsigned NumTones, const void *LINEGENERATETONE);
extern DELPHI_PACKAGE int __fastcall tuLineMonitorTones(int Call, const void *LINEMONITORTONE, unsigned NumEntries);
extern DELPHI_PACKAGE int __fastcall tuLineSetCallParams(int Call, unsigned BearerMode, unsigned MinRate, unsigned MaxRate, PLineDialParams DialParams);
extern DELPHI_PACKAGE int __fastcall tuLineHandoff(int Call, char * FileName, unsigned MediaMode);
extern DELPHI_PACKAGE int __fastcall tuLineMonitorMedia(int Call, unsigned MediaModes);
extern DELPHI_PACKAGE int __fastcall tuLineGenerateDigits(int Call, unsigned DigitModes, char * Digits, unsigned Duration);
extern DELPHI_PACKAGE int __fastcall tuLineMonitorDigits(int Call, unsigned DigitModes);
extern DELPHI_PACKAGE int __fastcall tuLineInitialize(int &LineApp, NativeUInt Instance, TLineCallback Callback, char * AppName, unsigned &NumDevs);
extern DELPHI_PACKAGE int __fastcall tuLineShutdown(int LineApp);
extern DELPHI_PACKAGE int __fastcall tuLineNegotiateApiVersion(int LineApp, int DeviceID, int APILowVersion, int APIHighVersion, int &ApiVersion, TLineExtensionID &LE);
extern DELPHI_PACKAGE int __fastcall tuLineGetDevCaps(int LineApp, unsigned DeviceID, unsigned ApiVersion, unsigned ExtVersion, PLineDevCaps LineDevCaps);
extern DELPHI_PACKAGE int __fastcall tuLineOpen(int LineApp, unsigned DeviceID, int &Line, unsigned ApiVersion, unsigned ExtVersion, unsigned CallbackInstance, unsigned Privleges, unsigned MediaModes, unsigned CallParams);
extern DELPHI_PACKAGE int __fastcall tuLineMakeCall(int Line, int &Call, char * DestAddress, unsigned CountryCode, const PLineCallParams CallParams);
extern DELPHI_PACKAGE int __fastcall tuLineAccept(int Call, char * UserUserInfo, unsigned Size);
extern DELPHI_PACKAGE int __fastcall tuLineAnswer(int Call, char * UserUserInfo, unsigned Size);
extern DELPHI_PACKAGE int __fastcall tuLineDeallocateCall(int Call);
extern DELPHI_PACKAGE int __fastcall tuLineDrop(int Call, char * UserInfo, unsigned Size);
extern DELPHI_PACKAGE int __fastcall tuLineClose(int Line);
extern DELPHI_PACKAGE int __fastcall tuLineGetCountry(int CountryID, int ApiVersion, PLineCountryList LineCountryList);
extern DELPHI_PACKAGE int __fastcall tuLineConfigDialog(unsigned DeviceID, HWND Owner, char * DeviceClass);
extern DELPHI_PACKAGE int __fastcall tuLineConfigDialogEdit(unsigned DeviceID, HWND Owner, char * DeviceClass, const void *inDevConfig, unsigned Size, TVarString &DevConfig);
extern DELPHI_PACKAGE int __fastcall tuLineGetID(int Line, unsigned AddressID, int Call, unsigned Select, TVarString &DeviceID, char * DeviceClass);
extern DELPHI_PACKAGE int __fastcall tuLineSetStatusMessages(int Line, unsigned LineStates, unsigned AddressStates);
extern DELPHI_PACKAGE int __fastcall tuLineGetStatusMessages(int Line, unsigned &LineStates, unsigned &AddressStates);
extern DELPHI_PACKAGE int __fastcall tuLineGetAddressCaps(int LineApp, unsigned DeviceID, unsigned AddressId, unsigned ApiVersion, unsigned ExtVersion, PLineAddressCaps LineAddressCaps);
extern DELPHI_PACKAGE int __fastcall tuLineGetAddressStatus(int Line, unsigned AddressID, TLineAddressStatus &AddressStatus);
extern DELPHI_PACKAGE int __fastcall tuLineGetLineDevStatus(int Line, PLineDevStatus &DevStatus);
extern DELPHI_PACKAGE int __fastcall tuLineGetDevConfig(unsigned DeviceID, TVarString &DeviceConfig, char * DeviceClass);
extern DELPHI_PACKAGE int __fastcall tuLineSetDevConfig(unsigned DeviceID, const void *DeviceConfig, unsigned Size, char * DeviceClass);
extern DELPHI_PACKAGE int __fastcall tuLineGetCallInfo(int Call, PCallInfo CallInfo);
extern DELPHI_PACKAGE int __fastcall tuLineGetCallStatus(int Call, PCallStatus CallStatus);
extern DELPHI_PACKAGE int __fastcall tuLineSetMediaMode(int Call, unsigned MediaModes);
extern DELPHI_PACKAGE int __fastcall tuLineSetCurrentLocation(int Line, unsigned Location);
extern DELPHI_PACKAGE int __fastcall tuLineSetTollList(int Line, unsigned DeviceID, char * AddressIn, unsigned TollListOption);
extern DELPHI_PACKAGE int __fastcall tuLineGetDevCapsDyn(int LineApp, unsigned DeviceID, unsigned ApiVersion, unsigned ExtVersion, PLineDevCaps &LineDevCaps);
extern DELPHI_PACKAGE int __fastcall tuLineGetLineDevStatusDyn(int Line, PLineDevStatus &DevStatus);
extern DELPHI_PACKAGE int __fastcall tuLineGetCallInfoDyn(int Call, PCallInfo &CallInfo);
extern DELPHI_PACKAGE int __fastcall tuLineGetCallStatusDyn(int Call, PCallStatus &CallStatus);
extern DELPHI_PACKAGE int __fastcall tuLineTranslateAddressDyn(int Line, unsigned DeviceID, unsigned APIVersion, System::UnicodeString AddressIn, unsigned Card, unsigned TranslateOptions, PLineTranslateOutput &TranslateOutput);
extern DELPHI_PACKAGE int __fastcall tuLineTranslateDialog(int Line, unsigned DeviceID, unsigned APIVersion, HWND HwndOwner, System::UnicodeString AddressIn);
extern DELPHI_PACKAGE int __fastcall tuLineHold(int &Call);
extern DELPHI_PACKAGE int __fastcall tuLineUnhold(int &Call);
extern DELPHI_PACKAGE int __fastcall tuLineTransfer(int &Call, char * DestAddress, unsigned CountryCode);
extern DELPHI_PACKAGE void __fastcall UnloadTapiDLL(void);
}	/* namespace Adtutil */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADTUTIL)
using namespace Adtutil;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdtutilHPP
