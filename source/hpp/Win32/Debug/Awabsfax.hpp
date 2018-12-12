// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwAbsFax.pas' rev: 32.00 (Windows)

#ifndef AwabsfaxHPP
#define AwabsfaxHPP

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
#include <AdExcept.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awabsfax
{
//-- forward type declarations -----------------------------------------------
struct TFaxData;
struct TFaxRec;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (*TFaxFunc)(unsigned Msg, unsigned wParam, int lParam);

typedef TFaxData *PFaxData;

struct DECLSPEC_DRECORD TFaxData
{
public:
	int aStatusTrigger;
	int aTimeoutTrigger;
	int aOutBuffFreeTrigger;
	int aOutBuffUsedTrigger;
	int aStatusInterval;
	HWND aHWindow;
	Awuser::TApdBaseDispatcher* aPort;
	TFaxFunc aCurFaxFunc;
	bool aSending;
	bool aSendingCover;
	bool aInProgress;
	unsigned aMaxConnect;
	unsigned aConnectCnt;
	unsigned aRetryCnt;
	unsigned aRetryWait;
	unsigned afFlags;
	unsigned aSaveStatus;
	unsigned aFaxProgress;
	unsigned aFaxListCount;
	int aFaxError;
	int aCurrPage;
	int aPageCount;
	int aCoverCount;
	int aDataCount;
	int aPageSize;
	Oomisc::TFaxEntry *aFaxListHead;
	Oomisc::TFaxEntry *aFaxListTail;
	Oomisc::TFaxEntry *aFaxListNode;
	Oomisc::ClassType aClassInUse;
	Oomisc::Str20 aStationID;
	Oomisc::Str20 aRemoteID;
	Oomisc::TChar20Array aStNumber;
	System::ShortString aDestDir;
	System::ShortString aFaxFileExt;
	System::ShortString aFaxFileName;
	System::ShortString aCoverFile;
	System::SmallString<40> aPhoneNum;
	Oomisc::EventTimer aStatusTimer;
	System::ShortString aTitle;
	System::ShortString aRecipient;
	System::ShortString aSender;
	System::Byte aSaveMode;
	bool aSendManual;
	bool aConcatFax;
	bool HaveTriggerHandler;
	bool aUsingTapi;
};


struct DECLSPEC_DRECORD TFaxRec
{
public:
	TFaxData *aPData;
};


typedef TFaxRec *PFaxRec;

typedef int __fastcall (*TFaxPrepProc)(PFaxRec P);

typedef void __fastcall (*FaxStatusProc)(PFaxRec FP, bool Starting, bool Ending);

typedef bool __fastcall (*NextFaxFunc)(PFaxRec FP, System::ShortString &Number, System::ShortString &FName, System::ShortString &Cover);

typedef void __fastcall (*FaxLogProc)(PFaxRec FP, Oomisc::TFaxLogCode Log);

typedef System::ShortString __fastcall (*FaxNameFunc)(PFaxRec FP);

typedef bool __fastcall (*AcceptFaxFunc)(PFaxRec FP, Oomisc::Str20 &RemoteName);

enum DECLSPEC_DENUM ReceivePageStatus : unsigned char { rpsBadPage, rpsMoreSame, rpsNewPage, rpsNewDocument, rpsEndOfDocument };

enum DECLSPEC_DENUM SendStates : unsigned char { tfNone, tfGetEntry, tfInit, tf1Init1, tf2Init1, tf2Init1A, tf2Init1B, tf2Init2, tf2Init3, tfDial, tfRetryWait, tf1Connect, tf1SendTSI, tf1TSIResponse, tf1DCSResponse, tf1TrainStart, tf1TrainFinish, tf1WaitCFR, tf1WaitPageConnect, tf2Connect, tf2GetParams, tfWaitXon, tfWaitFreeHeader, tfSendPageHeader, tfOpenCover, tfSendCover, tfPrepPage, tfSendPage, tfDrainPage, tf1PageEnd, tf1PrepareEOP, tf1SendEOP, tf1WaitMPS, tf1WaitEOP, tf1WaitMCF, tf1SendDCN, tf1Hangup, tf1WaitHangup, tf2SendEOP, tf2WaitFPTS, tf2WaitFET, tf2WaitPageOK, tf2SendNewParams, tf2NextPage, tf20CheckPage, tfClose, tfCompleteOK, tfAbort, tfDone };

enum DECLSPEC_DENUM ReceiveStates : unsigned char { rfNone, rfInit, rf1Init1, rf2Init1, rf2Init1A, rf2Init1B, rf2Init2, rf2Init3, rfWaiting, rfAnswer, rf1SendCSI, rf1SendDIS, rf1CollectFrames, rf1CollectRetry1, rf1CollectRetry2, rf1StartTrain, rf1CollectTrain, rf1Timeout, rf1Retrain, rf1FinishTrain, rf1SendCFR, rf1WaitPageConnect, rf2ValidConnect, rf2GetSenderID, rf2GetConnect, rfStartPage, rfGetPageData, rf1FinishPage, rf1WaitEOP, rf1WritePage, rf1SendMCF, rf1WaitDCN, rf1WaitHangup, rf2GetPageResult, rf2GetFHNG, rfComplete, rfAbort, rfDone };

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 NSFFrame = System::Int8(0x20);
static const System::Int8 EOPFrame = System::Int8(0x2e);
static const System::Int8 CSIFrame = System::Int8(0x40);
static const System::Int8 TSIFrame = System::Int8(0x42);
static const System::Int8 FTTFrame = System::Int8(0x44);
static const System::Int8 RTNFrame = System::Int8(0x4c);
static const System::Int8 MPSFrame = System::Int8(0x4e);
static const System::Byte DISFrame = System::Byte(0x80);
static const System::Byte DCSFrame = System::Byte(0x82);
static const System::Byte CFRFrame = System::Byte(0x84);
static const System::Byte MCFFrame = System::Byte(0x8c);
static const System::Byte EOMFrame = System::Byte(0x8e);
static const System::Byte DCNFrame = System::Byte(0xfa);
static const System::Byte RTPFrame = System::Byte(0xcc);
static const System::Word DataBufferSize = System::Word(0x1000);
static const System::Int8 DISGroup1 = System::Int8(0x0);
static const System::Int8 DISGroup3_1 = System::Int8(0x2);
static const System::Byte DISGroup3_2 = System::Byte(0x88);
static const System::Int8 DISGroup3_3 = System::Int8(0x0);
static const System::Int8 DISHighResolution = System::Int8(0x40);
static const System::Int8 DIS2400BPS = System::Int8(0x0);
static const System::Int8 DIS4800BPS = System::Int8(0x8);
static const System::Int8 DIS7200BPS = System::Int8(0xc);
static const System::Int8 DIS9600BPS = System::Int8(0x4);
static const System::Int8 DIS12000BPS = System::Int8(0x10);
static const System::Int8 DIS14400BPS = System::Int8(0x20);
static const System::Int8 DISWideWidth = System::Int8(0x1);
static const char AddrField = '\xff';
static const System::WideChar ControlField = (System::WideChar)(0x3);
static const System::WideChar ControlFieldLast = (System::WideChar)(0x13);
#define C2ClassCmd L"CLASS=2"
#define C20ClassCmd L"CLASS=2.0"
#define C2ModelCmd L"MDL?"
#define C20ModelCmd L"MI?"
#define C2MfrCmd L"MFR?"
#define C20MfrCmd L"MM?"
#define C2RevCmd L"REV?"
#define C20RevCmd L"MR?"
#define C2DISCmd L"DIS"
#define C20DISCmd L"IS"
#define C2StationCmd L"LID"
#define C20StationCmd L"LI"
#define C2DCCCmd L"DCC"
#define C20DCCCmd L"CC"
#define C2FaxResp L"CON"
#define C20FaxResp L"CO"
#define C2DISResp L"DIS"
#define C20DISResp L"IS"
#define C2DCSResp L"DCS"
#define C20DCSResp L"CS"
#define C2TSIResp L"TSI"
#define C20TSIResp L"TI"
#define C2CSIResp L"CSI"
#define C20CSIResp L"CI"
#define C2PageResp L"PTS"
#define C20PageResp L"PS"
#define C2HangResp L"HNG"
#define C20HangResp L"HS"
#define DefFaxFileExt L"APF"
extern DELPHI_PACKAGE System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)> DosDelimSet;
extern DELPHI_PACKAGE int __fastcall afInitFaxData(PFaxData &PData, Oomisc::Str20 &ID, Awuser::TApdBaseDispatcher* ComPort, HWND Window);
extern DELPHI_PACKAGE int __fastcall afDoneFaxData(PFaxData &PData);
extern DELPHI_PACKAGE void __fastcall afOptionsOn(PFaxRec FP, System::Word OptionFlags);
extern DELPHI_PACKAGE void __fastcall afOptionsOff(PFaxRec FP, System::Word OptionFlags);
extern DELPHI_PACKAGE bool __fastcall afOptionsAreOn(PFaxRec FP, System::Word OptionFlags);
extern DELPHI_PACKAGE void __fastcall afSetConnectAttempts(PFaxRec FP, System::Word Attempts, System::Word DelayTicks);
extern DELPHI_PACKAGE void __fastcall afSetNextFax(PFaxRec FP, System::ShortString &Number, System::ShortString &FName, System::ShortString &Cover);
extern DELPHI_PACKAGE void __fastcall afSetComHandle(PFaxRec FP, Awuser::TApdBaseDispatcher* NewHandle);
extern DELPHI_PACKAGE void __fastcall afSetWindow(PFaxRec FP, HWND NewWindow);
extern DELPHI_PACKAGE void __fastcall afSetTitle(PFaxRec FP, System::ShortString &NewTitle);
extern DELPHI_PACKAGE void __fastcall afSetRecipientName(PFaxRec FP, System::ShortString &NewName);
extern DELPHI_PACKAGE void __fastcall afSetSenderName(PFaxRec FP, System::ShortString &NewName);
extern DELPHI_PACKAGE void __fastcall afSetDestinationDir(PFaxRec FP, System::ShortString &Dest);
extern DELPHI_PACKAGE void __fastcall afSetStationID(PFaxRec FP, Oomisc::Str20 &NewID);
extern DELPHI_PACKAGE void __fastcall afFaxStatus(PFaxRec FP, bool Starting, bool Ending);
extern DELPHI_PACKAGE bool __fastcall afNextFax(PFaxRec FP);
extern DELPHI_PACKAGE void __fastcall afLogFax(PFaxRec FP, Oomisc::TFaxLogCode Log);
extern DELPHI_PACKAGE void __fastcall afFaxName(PFaxRec FP);
extern DELPHI_PACKAGE bool __fastcall afAcceptFax(PFaxRec FP, Oomisc::Str20 &RemoteName);
extern DELPHI_PACKAGE System::ShortString __fastcall afConvertHeaderString(PFaxRec FP, System::ShortString &S);
extern DELPHI_PACKAGE int __fastcall afAddFaxEntry(PFaxRec FP, const System::ShortString &Number, const System::ShortString &FName, const System::ShortString &Cover);
extern DELPHI_PACKAGE void __fastcall afClearFaxEntries(PFaxRec FP);
extern DELPHI_PACKAGE System::ShortString __fastcall afGetFaxName(PFaxRec FP);
extern DELPHI_PACKAGE void __fastcall afSetFaxName(PFaxRec FP, System::ShortString &FaxName);
extern DELPHI_PACKAGE System::Word __fastcall afGetFaxProgress(PFaxRec FP);
extern DELPHI_PACKAGE void __fastcall afReportError(PFaxRec FP, int ErrorCode);
extern DELPHI_PACKAGE void __fastcall afSignalFinish(PFaxRec FP);
extern DELPHI_PACKAGE void __fastcall afStartFax(PFaxRec FP, TFaxPrepProc StartProc, TFaxFunc FaxFunc);
extern DELPHI_PACKAGE void __fastcall afStopFax(PFaxRec FP);
extern DELPHI_PACKAGE char * __fastcall afStatusMsg(char * P, System::Word Status);
extern DELPHI_PACKAGE bool __fastcall afNextFaxList(PFaxRec FP, System::ShortString &Number, System::ShortString &FName, System::ShortString &Cover);
extern DELPHI_PACKAGE System::ShortString __fastcall afFaxNameMD(PFaxRec FP);
extern DELPHI_PACKAGE System::ShortString __fastcall afFaxNameCount(PFaxRec FP);
}	/* namespace Awabsfax */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWABSFAX)
using namespace Awabsfax;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwabsfaxHPP
