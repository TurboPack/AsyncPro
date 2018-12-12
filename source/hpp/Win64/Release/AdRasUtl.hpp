// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdRasUtl.pas' rev: 32.00 (Windows)

#ifndef AdrasutlHPP
#define AdrasutlHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <AdExcept.hpp>
#include <OoMisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adrasutl
{
//-- forward type declarations -----------------------------------------------
struct TRasDialParams;
struct TRasConn;
struct TRasConnStatus;
struct TRasEntryName;
struct TRasDialExtensions;
struct TRasDeviceInfo;
struct TRasCountryInfo;
struct TRasDialDlgInfo;
struct TRasMonitorDlgInfo;
struct TRasPhonebookDlgInfo;
//-- type declarations -------------------------------------------------------
typedef NativeUInt *PHRasConn;

typedef NativeUInt HRasConn;

typedef unsigned TRasState;

typedef unsigned TRasError;

typedef TRasDialParams *PRasDialParams;

struct DECLSPEC_DRECORD TRasDialParams
{
public:
	unsigned dwSize;
	System::StaticArray<System::WideChar, 257> szEntryName;
	System::StaticArray<System::WideChar, 129> szPhoneNumber;
	System::StaticArray<System::WideChar, 129> szCallbackNumber;
	System::StaticArray<System::WideChar, 257> szUserName;
	System::StaticArray<System::WideChar, 257> szPassword;
	System::StaticArray<System::WideChar, 16> szDomain;
};


typedef TRasConn *PRasConn;

struct DECLSPEC_DRECORD TRasConn
{
public:
	unsigned dwSize;
	unsigned rasConn;
	System::StaticArray<System::WideChar, 257> szEntryName;
	System::StaticArray<System::WideChar, 17> szDeviceType;
	System::StaticArray<System::WideChar, 129> szDeviceName;
};


typedef System::StaticArray<TRasConn, 65> TRasConnArray;

typedef TRasConnArray *PRasConnArray;

typedef TRasConnStatus *PRasConnStatus;

struct DECLSPEC_DRECORD TRasConnStatus
{
public:
	unsigned dwSize;
	unsigned rasConnState;
	unsigned dwError;
	System::StaticArray<System::WideChar, 17> szDeviceType;
	System::StaticArray<System::WideChar, 129> szDeviceName;
};


typedef TRasEntryName *PRasEntryName;

struct DECLSPEC_DRECORD TRasEntryName
{
public:
	int dwSize;
	System::StaticArray<System::WideChar, 257> szEntryName;
};


typedef System::StaticArray<TRasEntryName, 65> TRasEntryNameArray;

typedef TRasEntryNameArray *PRasEntryNameArray;

typedef TRasDialExtensions *PRasDialExtensions;

struct DECLSPEC_DRECORD TRasDialExtensions
{
public:
	unsigned dwSize;
	unsigned dwfOptions;
	HWND hwndParent;
	unsigned reserved;
};


typedef TRasDeviceInfo *PRasDeviceInfo;

struct DECLSPEC_DRECORD TRasDeviceInfo
{
public:
	unsigned dwSize;
	System::StaticArray<System::WideChar, 17> szDeviceType;
	System::StaticArray<System::WideChar, 129> szDeviceName;
};


typedef TRasCountryInfo *PRasCountryInfo;

struct DECLSPEC_DRECORD TRasCountryInfo
{
public:
	unsigned dwSize;
	unsigned dwCountryID;
	unsigned dwNextCountryID;
	unsigned dwCountryCode;
	unsigned dwCountryNameOffset;
};


typedef TRasDialDlgInfo *PRasDialDlgInfo;

struct DECLSPEC_DRECORD TRasDialDlgInfo
{
public:
	unsigned dwSize;
	HWND hwndOwner;
	unsigned dwFlags;
	int xDlg;
	int yDlg;
	unsigned dwSubEntry;
	unsigned dwError;
	unsigned reserved;
	unsigned reserved2;
};


typedef TRasMonitorDlgInfo *PRasMonitorDlgInfo;

struct DECLSPEC_DRECORD TRasMonitorDlgInfo
{
public:
	unsigned dwSize;
	HWND hwndOwner;
	unsigned dwFlags;
	unsigned dwStartPage;
	int xDlg;
	int yDlg;
	unsigned dwError;
	unsigned reserved;
	unsigned reserved2;
};


typedef TRasPhonebookDlgInfo *PRasPhonebookDlgInfo;

struct DECLSPEC_DRECORD TRasPhonebookDlgInfo
{
public:
	unsigned dwSize;
	HWND hwndOwner;
	unsigned dwFlags;
	int xDlg;
	int yDlg;
	unsigned dwCallbackId;
	void *pCallback;
	unsigned dwError;
	unsigned reserved;
	unsigned reserved2;
};


typedef unsigned __stdcall (*TRasDial)(PRasDialExtensions lpDialExtensions, System::WideChar * lszPhonebook, PRasDialParams lpDialParams, unsigned dwNotifierType, unsigned lpvNotifier, PHRasConn lpConn);

typedef System::LongBool __stdcall (*TRasDialDlg)(System::WideChar * lpszPhonebook, System::WideChar * lpszEntry, System::WideChar * lpszPhoneNumber, PRasDialDlgInfo lpDialDlgInfo);

typedef System::LongBool __stdcall (*TRasMonitorDlg)(System::WideChar * lpszDeviceName, PRasMonitorDlgInfo lpMonitorDlgInfo);

typedef System::LongBool __stdcall (*TRasPhonebookDlg)(System::WideChar * lpszPhonebook, System::WideChar * lpszEntry, PRasPhonebookDlgInfo lpPBDlgInfo);

typedef unsigned __stdcall (*TRasEnumConnections)(PRasConn lpConn, unsigned &lpBufSize, unsigned &lpNumConnections);

typedef unsigned __stdcall (*TRasEnumEntries)(System::WideChar * lpReserved, System::WideChar * lpszPhonebook, PRasEntryName lpEntryName, unsigned &lpEntryNameSize, unsigned &lpNumEntries);

typedef unsigned __stdcall (*TRasClearConnectionStatistics)(NativeUInt Conn);

typedef unsigned __stdcall (*TRasGetConnectionStatistics)(NativeUInt Conn, Oomisc::PRasStatistics lpStatistics);

typedef unsigned __stdcall (*TRasGetConnectStatus)(NativeUInt Conn, PRasConnStatus lpConnStatus);

typedef unsigned __stdcall (*TRasGetErrorString)(unsigned ErrorCode, System::WideChar * lpszErrorString, unsigned BufSize);

typedef unsigned __stdcall (*TRasHangup)(NativeUInt RasConn);

typedef unsigned __stdcall (*TRasGetEntryDialParams)(System::WideChar * lpszPhonebook, PRasDialParams lpDialParams, System::LongBool &Password);

typedef unsigned __stdcall (*TRasSetEntryDialParams)(System::WideChar * lpszPhonebook, PRasDialParams lpDialParams, System::LongBool RemovePassword);

typedef unsigned __stdcall (*TRasCreatePhonebookEntry)(NativeUInt HWnd, System::WideChar * lpszPhoneBook);

typedef unsigned __stdcall (*TRasEditPhonebookEntry)(NativeUInt HWnd, System::WideChar * lpszPhonebook, System::WideChar * lpszEntryName);

typedef unsigned __stdcall (*TRasDeleteEntry)(System::WideChar * lpszPhonebook, System::WideChar * lpszEntryName);

typedef unsigned __stdcall (*TRasRenameEntry)(System::WideChar * lpszPhonebook, System::WideChar * lpszEntryOld, System::WideChar * lpszEntryNew);

typedef unsigned __stdcall (*TRasEnumDevices)(PRasDeviceInfo lpDeviceInfo, unsigned &lpDeviceInfoSize, unsigned &lpNumDevices);

typedef unsigned __stdcall (*TRasGetCountryInfo)(PRasCountryInfo lpCountryInfo, unsigned &lpCountryInfoSize);

typedef unsigned __stdcall (*TRasGetEntryProperties)(System::WideChar * lpszPhonebook, System::WideChar * lpszEntry, Oomisc::PRasEntry lpEntry, unsigned &lpEntrySize, Oomisc::PTapiConfigRec lpDeviceInfo, unsigned &lpDeviceInfoSize);

typedef unsigned __stdcall (*TRasSetEntryProperties)(System::WideChar * lpszPhonebook, System::WideChar * lpszEntry, Oomisc::PRasEntry lpEntryInfo, unsigned EntryInfoSize, Oomisc::PTapiConfigRec lpDeviceInfo, unsigned DeviceInfoSize);

typedef unsigned __stdcall (*TRasValidateEntryName)(System::WideChar * lpszPhonebook, System::WideChar * lpszEntry);

//-- var, const, procedure ---------------------------------------------------
#define RASDLL L"RASAPI32"
#define RasDlgDLL L"RASDLG"
#define AdRasDialEvent L"RasDialEvent"
static const System::Word WM_RASDIALEVENT = System::Word(0xcccd);
static const System::Int8 ntNotifyDialFunc1 = System::Int8(0x0);
static const System::Int8 ntNotifyDialFunc2 = System::Int8(0x1);
extern DELPHI_PACKAGE unsigned ntNotifyWindow;
static const System::Int8 deUsePrefixSuffix = System::Int8(0x1);
static const System::Int8 dePausedStates = System::Int8(0x2);
static const System::Int8 deIgnoreModemSpeaker = System::Int8(0x4);
static const System::Int8 deSetModemSpeaker = System::Int8(0x8);
static const System::Int8 deIgnoreSoftwarecompression = System::Int8(0x10);
static const System::Int8 deSetSoftwarecompression = System::Int8(0x20);
static const System::Int8 deDisableConnectedUI = System::Int8(0x40);
static const System::Byte deDisableReconnectUI = System::Byte(0x80);
static const System::Word deDisableReconnect = System::Word(0x100);
static const System::Word deNoUser = System::Word(0x200);
static const System::Word dePauseOnScript = System::Word(0x400);
static const System::Word deRouter = System::Word(0x800);
static const System::Int8 ecRasOK = System::Int8(0x0);
static const System::Int8 ecRasFunctionNotSupported = System::Int8(-1);
static const System::Word ecRasRasBase = System::Word(0x258);
static const System::Word ecRasPending = System::Word(0x258);
static const System::Word ecRasInvalidPortHandle = System::Word(0x259);
static const System::Word ecRasPortAlreadyOpen = System::Word(0x25a);
static const System::Word ecRasBufferTooSmall = System::Word(0x25b);
static const System::Word ecRasWrongInfoSpecified = System::Word(0x25c);
static const System::Word ecRasCannotSetPortInfo = System::Word(0x25d);
static const System::Word ecRasPortNotConnected = System::Word(0x25e);
static const System::Word ecRasEventInvalid = System::Word(0x25f);
static const System::Word ecRasDeviceDoesNotExist = System::Word(0x260);
static const System::Word ecRasDeviceTypeDoesNotExist = System::Word(0x261);
static const System::Word ecRasInvalidBuffer = System::Word(0x262);
static const System::Word ecRasRouteNotAvailable = System::Word(0x263);
static const System::Word ecRasRouteNotAllocated = System::Word(0x264);
static const System::Word ecRasInvalidCompression = System::Word(0x265);
static const System::Word ecRasOutOfBuffers = System::Word(0x266);
static const System::Word ecRasPortNotFound = System::Word(0x267);
static const System::Word ecRasAsyncRequestPending = System::Word(0x268);
static const System::Word ecRasAlreadyDisconnecting = System::Word(0x269);
static const System::Word ecRasPortNotOpen = System::Word(0x26a);
static const System::Word ecRasPortDisconnected = System::Word(0x26b);
static const System::Word ecRasNoEndPoints = System::Word(0x26c);
static const System::Word ecRasCannotOpenPhonebook = System::Word(0x26d);
static const System::Word ecRasCannotLoadPhonebook = System::Word(0x26e);
static const System::Word ecRasCannotFindPhonebookEntry = System::Word(0x26f);
static const System::Word ecRasCannotWritePhonebook = System::Word(0x270);
static const System::Word ecRasCorruptPhonebook = System::Word(0x271);
static const System::Word ecRasCannotLoadString = System::Word(0x272);
static const System::Word ecRasKeyNotFound = System::Word(0x273);
static const System::Word ecRasDisconnection = System::Word(0x274);
static const System::Word ecRasRemoteDisconnection = System::Word(0x275);
static const System::Word ecRasHardwareFailure = System::Word(0x276);
static const System::Word ecRasUserDisconnection = System::Word(0x277);
static const System::Word ecRasInvalidSize = System::Word(0x278);
static const System::Word ecRasPortNotAvailable = System::Word(0x279);
static const System::Word ecRasCannotProjectClient = System::Word(0x27a);
static const System::Word ecRasUnknown = System::Word(0x27b);
static const System::Word ecRasWrongDeviceAttached = System::Word(0x27c);
static const System::Word ecRasBadString = System::Word(0x27d);
static const System::Word ecRasRequestTimeout = System::Word(0x27e);
static const System::Word ecRasCannotGetLana = System::Word(0x27f);
static const System::Word ecRasNetBiosError = System::Word(0x280);
static const System::Word ecRasServerOutOfResources = System::Word(0x281);
static const System::Word ecRasNameExistsOnNet = System::Word(0x282);
static const System::Word ecRasServerGeneralNetFailure = System::Word(0x283);
static const System::Word ecRasMsgAliasNotAdded = System::Word(0x284);
static const System::Word ecRasAuthInternal = System::Word(0x285);
static const System::Word ecRasRestrictedLogonHours = System::Word(0x286);
static const System::Word ecRasAcctDisabled = System::Word(0x287);
static const System::Word ecRasPasswordExpired = System::Word(0x288);
static const System::Word ecRasNoDialinPermission = System::Word(0x289);
static const System::Word ecRasServerNotResponding = System::Word(0x28a);
static const System::Word ecRasFromDevice = System::Word(0x28b);
static const System::Word ecRasUnrecognizedResponse = System::Word(0x28c);
static const System::Word ecRasMacroNotFound = System::Word(0x28d);
static const System::Word ecRasMacroNotDefined = System::Word(0x28e);
static const System::Word ecRasMessageMacroNotFound = System::Word(0x28f);
static const System::Word ecRasDefaultOffMacroNotFound = System::Word(0x290);
static const System::Word ecRasFilecouldNotBeOpened = System::Word(0x291);
static const System::Word ecRasDeviceNameTooLong = System::Word(0x292);
static const System::Word ecRasDevicenameNotFound = System::Word(0x293);
static const System::Word ecRasNoResponses = System::Word(0x294);
static const System::Word ecRasNoCommandFound = System::Word(0x295);
static const System::Word ecRasWrongKeySpecified = System::Word(0x296);
static const System::Word ecRasUnknownDeviceType = System::Word(0x297);
static const System::Word ecRasAllocatingMemory = System::Word(0x298);
static const System::Word ecRasPortNotConfigured = System::Word(0x299);
static const System::Word ecRasDeviceNotReady = System::Word(0x29a);
static const System::Word ecRasErrorReadingIniFile = System::Word(0x29b);
static const System::Word ecRasNoConnection = System::Word(0x29c);
static const System::Word ecRasBadUsageInIniFile = System::Word(0x29d);
static const System::Word ecRasReadingSectionName = System::Word(0x29e);
static const System::Word ecRasReadingDeviceType = System::Word(0x29f);
static const System::Word ecRasReadingDeviceName = System::Word(0x2a0);
static const System::Word ecRasReadingUsage = System::Word(0x2a1);
static const System::Word ecRasReadingMaxConnectBPS = System::Word(0x2a2);
static const System::Word ecRasReadingMaxCarrierBPS = System::Word(0x2a3);
static const System::Word ecRasLineBusy = System::Word(0x2a4);
static const System::Word ecRasVoiceAnswer = System::Word(0x2a5);
static const System::Word ecRasNoAnswer = System::Word(0x2a6);
static const System::Word ecRasNoCarrier = System::Word(0x2a7);
static const System::Word ecRasNoDialtone = System::Word(0x2a8);
static const System::Word ecRasInCommand = System::Word(0x2a9);
static const System::Word ecRasWritingSectionName = System::Word(0x2aa);
static const System::Word ecRasWritingDeviceType = System::Word(0x2ab);
static const System::Word ecRasWritingDeviceName = System::Word(0x2ac);
static const System::Word ecRasWritingMaxConnectBPS = System::Word(0x2ad);
static const System::Word ecRasWritingMaxCarrierBPS = System::Word(0x2ae);
static const System::Word ecRasWritingUsage = System::Word(0x2af);
static const System::Word ecRasWritingDefaultOff = System::Word(0x2b0);
static const System::Word ecRasReadingDefaultOff = System::Word(0x2b1);
static const System::Word ecRasEmptyIniFile = System::Word(0x2b2);
static const System::Word ecRasAuthenticationFailure = System::Word(0x2b3);
static const System::Word ecRasPortOrDevice = System::Word(0x2b4);
static const System::Word ecRasNotBinaryMacro = System::Word(0x2b5);
static const System::Word ecRasDCBNotFound = System::Word(0x2b6);
static const System::Word ecRasStateMachinesNotStarted = System::Word(0x2b7);
static const System::Word ecRasStateMachinesAlreadyStarted = System::Word(0x2b8);
static const System::Word ecRasPartialResponseLooping = System::Word(0x2b9);
static const System::Word ecRasUnknownResponseKey = System::Word(0x2ba);
static const System::Word ecRasRecvBufFull = System::Word(0x2bb);
static const System::Word ecRasCmdTooLong = System::Word(0x2bc);
static const System::Word ecRasUnsupportedBPS = System::Word(0x2bd);
static const System::Word ecRasUnexpectedResponse = System::Word(0x2be);
static const System::Word ecRasInteractiveMode = System::Word(0x2bf);
static const System::Word ecRasBadCallbackNumber = System::Word(0x2c0);
static const System::Word ecRasInvalidAuthState = System::Word(0x2c1);
static const System::Word ecRasWritingInitBPS = System::Word(0x2c2);
static const System::Word ecRasX25Diagnostic = System::Word(0x2c3);
static const System::Word ecRasAcctExpired = System::Word(0x2c4);
static const System::Word ecRasChangingPassword = System::Word(0x2c5);
static const System::Word ecRasOverrun = System::Word(0x2c6);
static const System::Word ecRasRasBaseManConnotInitialize = System::Word(0x2c7);
static const System::Word ecRasBiplexPortNotAvailable = System::Word(0x2c8);
static const System::Word ecRasNoActiveISDNLines = System::Word(0x2c9);
static const System::Word ecRasNoISDNChannelsAvailable = System::Word(0x2ca);
static const System::Word ecRasTooManyLineErrors = System::Word(0x2cb);
static const System::Word ecRasIPConfiguration = System::Word(0x2cc);
static const System::Word ecRasNoIPAddresses = System::Word(0x2cd);
static const System::Word ecRasPPPTimeout = System::Word(0x2ce);
static const System::Word ecRasPPPRemoteTerminated = System::Word(0x2cf);
static const System::Word ecRasPPPNoProtocolsConfigured = System::Word(0x2d0);
static const System::Word ecRasPPPNoResponse = System::Word(0x2d1);
static const System::Word ecRasPPPInvalidPacket = System::Word(0x2d2);
static const System::Word ecRasPhoneNumberTooLong = System::Word(0x2d3);
static const System::Word ecRasIPXCPNoDialOutConfigured = System::Word(0x2d4);
static const System::Word ecRasIPXCPNoDialInConfigured = System::Word(0x2d5);
static const System::Word ecRasIPXCPDialOutAlreadyActive = System::Word(0x2d6);
static const System::Word ecRasAccessingTCPCFGDLL = System::Word(0x2d7);
static const System::Word ecRasNOIPRasAdapter = System::Word(0x2d8);
static const System::Word ecRasSlipRequiresIP = System::Word(0x2d9);
static const System::Word ecRasProjectionNotComplete = System::Word(0x2da);
static const System::Word ecRasProtocolNotConfigured = System::Word(0x2db);
static const System::Word ecRasPPPNotConverging = System::Word(0x2dc);
static const System::Word ecRasPPPCPRejected = System::Word(0x2dd);
static const System::Word ecRasPPPLCPTerminated = System::Word(0x2de);
static const System::Word ecRasPPPRequiredAddressRejected = System::Word(0x2df);
static const System::Word ecRasPPPNCPTerminated = System::Word(0x2e0);
static const System::Word ecRasPPPLoopbackDetected = System::Word(0x2e1);
static const System::Word ecRasPPPNoAddressAssigned = System::Word(0x2e2);
static const System::Word ecRasCannotUseLogonCredentials = System::Word(0x2e3);
static const System::Word ecRasTapiConfiguration = System::Word(0x2e4);
static const System::Word ecRasNoLocalEncryption = System::Word(0x2e5);
static const System::Word ecRasNoRemoteEncryption = System::Word(0x2e6);
static const System::Word ecRasRemoteRequiresEncryption = System::Word(0x2e7);
static const System::Word ecRasIPXCPNetNumberConflict = System::Word(0x2e8);
static const System::Word ecRasInvalidSMM = System::Word(0x2e9);
static const System::Word ecRasSMMUninitialized = System::Word(0x2ea);
static const System::Word ecRasNoMACForPort = System::Word(0x2eb);
static const System::Word ecRasSMMTimeOut = System::Word(0x2ec);
static const System::Word ecRasBadPhoneNumber = System::Word(0x2ed);
static const System::Word ecRasWrongModule = System::Word(0x2ee);
static const System::Word ecRasInvalidCallBackNumber = System::Word(0x2ef);
static const System::Word ecRasScriptSyntax = System::Word(0x2f0);
static const System::Word ecRasHangupFailed = System::Word(0x2f1);
static const System::Word ecRasRasEnd = System::Word(0x2f1);
static const System::Int8 csRasBase = System::Int8(0x0);
extern DELPHI_PACKAGE unsigned AdRasPlatformID;
extern DELPHI_PACKAGE void __fastcall LoadRASDLL(void);
extern DELPHI_PACKAGE int __fastcall AdRasDial(PRasDialExtensions PDialExtensions, const System::UnicodeString Phonebook, PRasDialParams PDialParams, unsigned NotifierType, unsigned Notifier, NativeUInt &HConn);
extern DELPHI_PACKAGE int __fastcall AdRasDialDlg(const System::UnicodeString Phonebook, const System::UnicodeString EntryName, const System::UnicodeString PhoneNumber, PRasDialDlgInfo PDialDlgInfo);
extern DELPHI_PACKAGE int __fastcall AdRasMonitorDlg(const System::UnicodeString DeviceName, PRasMonitorDlgInfo PMonitorDlgInfo);
extern DELPHI_PACKAGE int __fastcall AdRasPhonebookDlg(const System::UnicodeString Phonebook, const System::UnicodeString EntryName, PRasPhonebookDlgInfo PPhonebookDlgInfo);
extern DELPHI_PACKAGE int __fastcall AdRasEnumConnections(PRasConn PConn, unsigned &ConnSize, unsigned &NumConnections);
extern DELPHI_PACKAGE int __fastcall AdRasEnumEntries(const System::UnicodeString Phonebook, PRasEntryName PEntryName, unsigned &EntryNameSize, unsigned &NumEntries);
extern DELPHI_PACKAGE int __fastcall AdRasClearConnectionStatistics(NativeUInt HConn);
extern DELPHI_PACKAGE int __fastcall AdRasGetConnectionStatistics(NativeUInt HConn, Oomisc::PRasStatistics PStatistics);
extern DELPHI_PACKAGE int __fastcall AdRasGetConnectStatus(NativeUInt HConn, PRasConnStatus PConnStatus);
extern DELPHI_PACKAGE System::UnicodeString __fastcall AdRasGetErrorString(int ErrorCode);
extern DELPHI_PACKAGE int __fastcall AdRasHangup(NativeUInt HConn);
extern DELPHI_PACKAGE int __fastcall AdRasGetEntryDialParams(const System::UnicodeString Phonebook, PRasDialParams PDialParams, bool &GotPassword);
extern DELPHI_PACKAGE int __fastcall AdRasSetEntryDialParams(const System::UnicodeString Phonebook, PRasDialParams PDialParams, bool RemovePassword);
extern DELPHI_PACKAGE int __fastcall AdRasCreatePhonebookEntry(NativeUInt HWnd, const System::UnicodeString PhoneBook);
extern DELPHI_PACKAGE int __fastcall AdRasEditPhonebookEntry(NativeUInt HWnd, const System::UnicodeString Phonebook, const System::UnicodeString EntryName);
extern DELPHI_PACKAGE int __fastcall AdRasDeleteEntry(const System::UnicodeString Phonebook, const System::UnicodeString EntryName);
extern DELPHI_PACKAGE int __fastcall AdRasRenameEntry(const System::UnicodeString Phonebook, const System::UnicodeString EntryOld, const System::UnicodeString EntryNew);
extern DELPHI_PACKAGE int __fastcall AdRasEnumDevices(PRasDeviceInfo PDeviceInfo, unsigned &DeviceInfoSize, unsigned &NumDevices);
extern DELPHI_PACKAGE int __fastcall AdRasGetCountryInfo(PRasCountryInfo PCountryInfo, unsigned &CountryInfoSize);
extern DELPHI_PACKAGE int __fastcall AdRasGetEntryProperties(const System::UnicodeString Phonebook, const System::UnicodeString EntryName, Oomisc::PRasEntry PEntry, unsigned &EntrySize, Oomisc::PTapiConfigRec PDeviceInfo, unsigned &DeviceInfoSize);
extern DELPHI_PACKAGE int __fastcall AdRasSetEntryProperties(const System::UnicodeString Phonebook, const System::UnicodeString EntryName, Oomisc::PRasEntry PEntry, unsigned &EntrySize, Oomisc::PTapiConfigRec PDeviceInfo, unsigned &DeviceInfoSize);
extern DELPHI_PACKAGE int __fastcall AdRasValidateEntryName(const System::UnicodeString Phonebook, const System::UnicodeString EntryName);
}	/* namespace Adrasutl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADRASUTL)
using namespace Adrasutl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdrasutlHPP
