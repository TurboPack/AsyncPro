// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwFax.pas' rev: 32.00 (Windows)

#ifndef AwfaxHPP
#define AwfaxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <AwFaxCvt.hpp>
#include <AwAbsFax.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awfax
{
//-- forward type declarations -----------------------------------------------
struct TC12AbsData;
struct TC12FaxData;
struct TC12SendFax;
struct TC12ReceiveFax;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::Byte, 65521> TFaxDataBuffer;

typedef TFaxDataBuffer *PFaxDataBuffer;

typedef System::SmallString<13> TClass2Str;

typedef System::SmallString<128> TModemResponse;

typedef TC12AbsData *PC12AbsData;

struct DECLSPEC_DRECORD TC12AbsData
{
public:
	bool cForceStatus;
	bool cMorePages;
	bool cSessionRes;
	bool cSessionWid;
	bool cSessionECM;
	bool cCanDoHighRes;
	bool cCanDoHighWid;
	bool cLastFrame;
	bool cToneDial;
	bool cLastPageOk;
	bool cUseLengthWord;
	bool cCoverIsAPF;
	bool cInitSent;
	bool cSlowBaud;
	bool cGotCFR;
	bool cBlindDial;
	bool cDetectBusy;
	char cCheckChar;
	char cResC;
	char cResCPrev;
	char cFaxAndData;
	System::Byte cSessionScan;
	System::Byte cReceivedFrame;
	System::Byte cCRLFIndex;
	System::Byte cETXIndex;
	System::Word cReplyWait;
	System::Word cTransWait;
	System::Word cMaxFaxBPS;
	System::Word cBPSIndex;
	System::Word cMinBytes;
	System::Word cHangupCode;
	System::Word cCurrOfs;
	System::Word cBadData;
	System::Word cRetry;
	int cBytesRead;
	int cDialWait;
	int cAnswerOnRing;
	int cRingCounter;
	int cSessionBPS;
	int cNormalBaud;
	int cInitBaud;
	TFaxDataBuffer *cDataBuffer;
	System::file cInFile;
	Oomisc::TFaxHeaderRec cFaxHeader;
	Oomisc::TPageHeaderRec cPageHeader;
	TClass2Str cClassCmd;
	TClass2Str cModelCmd;
	TClass2Str cMfrCmd;
	TClass2Str cRevCmd;
	TClass2Str cDISCmd;
	TClass2Str cStationCmd;
	TClass2Str cDCCCmd;
	TClass2Str cFaxResp;
	TClass2Str cDISResp;
	TClass2Str cDCSResp;
	TClass2Str cTSIResp;
	TClass2Str cCSIResp;
	TClass2Str cPageResp;
	TClass2Str cHangResp;
	System::SmallString<3> cModCode;
	System::SmallString<40> cForcedInit;
	System::SmallString<40> cModemInit;
	System::SmallString<40> cDialPrefix;
	char cDialTonePulse;
	TModemResponse cResponse;
	System::ShortString cInFileName;
	Oomisc::EventTimer cReplyTimer;
	System::StaticArray<bool, 6> cLocalMods;
	System::StaticArray<bool, 6> cRmtMods;
	System::StaticArray<System::Byte, 8192> cBufferBlock;
	bool cEnhTextEnabled;
	Vcl::Graphics::TFont* cEnhSmallFont;
	Vcl::Graphics::TFont* cEnhStandardFont;
};


typedef TC12FaxData *PC12FaxData;

struct DECLSPEC_DRECORD TC12FaxData
{
public:
	Awabsfax::TFaxData *fPData;
	TC12AbsData *fCData;
};


typedef TC12SendFax *PC12SendFax;

struct DECLSPEC_DRECORD TC12SendFax
{
public:
	Awabsfax::TFaxData *fPData;
	TC12AbsData *fCData;
	bool fSafeMode;
	System::Word fMaxSendCount;
	System::Word fBufferMinimum;
	bool fMCFConnect;
	int fRetries;
	int fMaxRetries;
	Oomisc::TAbsFaxCvt *fConverter;
	Awabsfax::SendStates fState;
	System::ShortString fHeaderLine;
	Oomisc::TLineReader* fCvrF;
	bool fCvrOpen;
	bool fRetryPage;
	System::Word fRetryMax;
	bool fFastPage;
};


typedef TC12ReceiveFax *PC12ReceiveFax;

struct DECLSPEC_DRECORD TC12ReceiveFax
{
public:
	Awabsfax::TFaxData *fPData;
	TC12AbsData *fCData;
	bool fSafeMode;
	bool fOneFax;
	bool fConstantStatus;
	bool fShowStatus;
	char fLast;
	Awabsfax::ReceivePageStatus fPageStatus;
	Awabsfax::ReceiveStates fState;
	Awabsfax::ReceiveStates fFirstState;
	bool fRenegotiate;
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 MaxModIndex = System::Int8(0x6);
extern DELPHI_PACKAGE System::Word PhysicalTopMargin;
static const System::Int8 DefMaxSendCnt = System::Int8(0x32);
static const System::Word DefBufferMin = System::Word(0x3e8);
static const System::Word awfDefFaxDialTimeout = System::Word(0x444);
static const System::Byte awfDefCmdTimeout = System::Byte(0xb6);
static const System::Word awfDefTransTimeout = System::Word(0x444);
static const System::Int8 aDataTrigger = System::Int8(0x0);
extern DELPHI_PACKAGE System::Word AbortDelay;
extern DELPHI_PACKAGE System::Word PreCommandDelay;
extern DELPHI_PACKAGE System::Word PreFaxDelay;
extern DELPHI_PACKAGE System::Word ExtraCommandDelay;
extern DELPHI_PACKAGE System::Word PreEOPDelay;
extern DELPHI_PACKAGE System::Word InterCharDelay;
extern DELPHI_PACKAGE System::Word OkDelay;
extern DELPHI_PACKAGE System::Word BaudChangeDelay;
extern DELPHI_PACKAGE System::Word Class1Wait;
extern DELPHI_PACKAGE System::Word MaxClass1Retry;
extern DELPHI_PACKAGE int __fastcall cInitC12AbsData(PC12AbsData &DP);
extern DELPHI_PACKAGE int __fastcall cDoneC12AbsData(PC12AbsData &DP);
extern DELPHI_PACKAGE void __fastcall fSetFaxPort(Awabsfax::PFaxRec FP, Awuser::TApdBaseDispatcher* ComPort);
extern DELPHI_PACKAGE void __fastcall fSetModemInit(Awabsfax::PFaxRec FP, System::ShortString &MIS);
extern DELPHI_PACKAGE Oomisc::ClassType __fastcall fSetClassType(Awabsfax::PFaxRec FP, Oomisc::ClassType CT);
extern DELPHI_PACKAGE void __fastcall fSetInitBaudRate(Awabsfax::PFaxRec FP, int InitRate, int NormalRate, bool DoIt);
extern DELPHI_PACKAGE bool __fastcall fGetModemClassSupport(Awabsfax::PFaxRec FP, bool &Class1, bool &Class2, bool &Class2_0, bool Reset);
extern DELPHI_PACKAGE bool __fastcall fGetModemInfo(Awabsfax::PFaxRec FP, char &FaxClass, Oomisc::TPassString &Model, Oomisc::TPassString &Chip, Oomisc::TPassString &Rev, bool Reset);
extern DELPHI_PACKAGE int __fastcall fGetModemFeatures(Awabsfax::PFaxRec FP, int &BPS, char &Correction);
extern DELPHI_PACKAGE void __fastcall fSetModemFeatures(Awabsfax::PFaxRec FP, int BPS, char Correction);
extern DELPHI_PACKAGE void __fastcall fGetPageInfoC12(Awabsfax::PFaxRec FP, System::Word &Pages, System::Word &Page, int &BytesTransferred, int &PageLength);
extern DELPHI_PACKAGE bool __fastcall fGetLastPageStatus(Awabsfax::PFaxRec FP);
extern DELPHI_PACKAGE System::ShortString __fastcall fGetRemoteID(Awabsfax::PFaxRec FP);
extern DELPHI_PACKAGE void __fastcall fGetSessionParams(Awabsfax::PFaxRec FP, int &BPS, bool &Resolution, bool &Correction);
extern DELPHI_PACKAGE System::Word __fastcall fGetHangupResult(Awabsfax::PFaxRec FP);
extern DELPHI_PACKAGE int __fastcall fInitC12SendFax(Awabsfax::PFaxRec &FP, Oomisc::Str20 &ID, Awuser::TApdBaseDispatcher* ComPort, HWND Window);
extern DELPHI_PACKAGE void __fastcall fDoneC12SendFax(Awabsfax::PFaxRec &FP);
extern DELPHI_PACKAGE void __fastcall fSetHeaderText(Awabsfax::PFaxRec FP, System::ShortString &S);
extern DELPHI_PACKAGE void __fastcall fSetEnhTextEnabled(Awabsfax::PFaxRec FP, bool Enabled);
extern DELPHI_PACKAGE void __fastcall fSetEnhSmallFont(Awabsfax::PFaxRec FP, Vcl::Graphics::TFont* SmFont);
extern DELPHI_PACKAGE void __fastcall fSetEnhStandardFont(Awabsfax::PFaxRec FP, Vcl::Graphics::TFont* StFont);
extern DELPHI_PACKAGE void __fastcall fSetBlindDial(Awabsfax::PFaxRec FP, bool Blind);
extern DELPHI_PACKAGE void __fastcall fSetDetectBusy(Awabsfax::PFaxRec FP, bool DetectBusySignal);
extern DELPHI_PACKAGE void __fastcall fSetToneDial(Awabsfax::PFaxRec FP, bool Tone);
extern DELPHI_PACKAGE void __fastcall fSetDialPrefix(Awabsfax::PFaxRec FP, System::ShortString &P);
extern DELPHI_PACKAGE void __fastcall fSetDialTime(Awabsfax::PFaxRec FP, int DT);
extern DELPHI_PACKAGE void __fastcall fSetMaxRetries(Awabsfax::PFaxRec FP, int MR);
extern DELPHI_PACKAGE void __fastcall fSetYielding(Awabsfax::PFaxRec FP, System::Word MaxLines, System::Word FreeBuffer);
extern DELPHI_PACKAGE void __fastcall fSetSafeMode(Awabsfax::PFaxRec FP, bool SafeMode);
extern DELPHI_PACKAGE void __fastcall fFaxTransmit(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE int __fastcall fPrepareFaxTransmit(Awabsfax::PFaxRec FP);
extern DELPHI_PACKAGE int __fastcall fInitC12ReceiveFax(Awabsfax::PFaxRec &FP, Oomisc::Str20 &ID, Awuser::TApdBaseDispatcher* ComPort, HWND Window);
extern DELPHI_PACKAGE int __fastcall fDoneC12ReceiveFax(Awabsfax::PFaxRec &FP);
extern DELPHI_PACKAGE bool __fastcall fInitModemForFaxReceive(Awabsfax::PFaxRec FP);
extern DELPHI_PACKAGE void __fastcall fSetConnectState(Awabsfax::PFaxRec FP);
extern DELPHI_PACKAGE void __fastcall fSetAnswerOnRing(Awabsfax::PFaxRec FP, int AOR);
extern DELPHI_PACKAGE void __fastcall fSetFaxAndData(Awabsfax::PFaxRec FP, bool OnOff);
extern DELPHI_PACKAGE void __fastcall fSetOneFax(Awabsfax::PFaxRec FP, bool OnOff);
extern DELPHI_PACKAGE void __fastcall fFaxReceive(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE int __fastcall fPrepareFaxReceive(Awabsfax::PFaxRec FP);
}	/* namespace Awfax */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWFAX)
using namespace Awfax;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwfaxHPP
