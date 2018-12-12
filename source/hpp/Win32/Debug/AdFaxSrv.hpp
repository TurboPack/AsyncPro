// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFaxSrv.pas' rev: 32.00 (Windows)

#ifndef AdfaxsrvHPP
#define AdfaxsrvHPP

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
#include <Vcl.Dialogs.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <OoMisc.hpp>
#include <AdFax.hpp>
#include <AdPort.hpp>
#include <AdTapi.hpp>
#include <AdFaxPrn.hpp>
#include <AdExcept.hpp>
#include <AdFStat.hpp>
#include <AdFIDlg.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adfaxsrv
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFaxListObj;
class DELPHICLASS TApdFaxJobHandler;
class DELPHICLASS TApdFaxServerManager;
class DELPHICLASS TApdFaxClient;
class DELPHICLASS TApdCustomFaxServer;
class DELPHICLASS TApdFaxServer;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TFaxServerMode : unsigned char { fsmIdle, fsmSend, fsmReceive };

typedef void __fastcall (__closure *TFaxServerStatusEvent)(System::TObject* CP, TFaxServerMode FaxMode, bool First, bool Last, System::Word Status);

typedef void __fastcall (__closure *TFaxServerFatalErrorEvent)(System::TObject* CP, TFaxServerMode FaxMode, int ErrorCode, int HangupCode);

typedef void __fastcall (__closure *TFaxServerFinishEvent)(System::TObject* CP, TFaxServerMode FaxMode, int ErrorCode);

typedef void __fastcall (__closure *TFaxServerPortOpenCloseEvent)(System::TObject* CP, bool Opening);

typedef void __fastcall (__closure *TFaxServerAcceptEvent)(System::TObject* CP, bool &Accept);

typedef void __fastcall (__closure *TFaxServerNameEvent)(System::TObject* CP, Oomisc::TPassString &Name);

typedef void __fastcall (__closure *TFaxServerLogEvent)(System::TObject* CP, Oomisc::TFaxLogCode LogCode, Oomisc::TFaxServerLogCode ServerCode);

typedef void __fastcall (__closure *TFaxServerManagerQueriedEvent)(TApdFaxServerManager* Mgr, TApdCustomFaxServer* QueryFrom, const System::UnicodeString JobToSend);

typedef void __fastcall (__closure *TManagerUpdateRecipientEvent)(TApdFaxServerManager* Mgr, System::UnicodeString JobFile, const Oomisc::TFaxJobHeaderRec &JobHeader, Oomisc::TFaxRecipientRec &RecipHeader);

typedef void __fastcall (__closure *TManagerUserGetJobEvent)(TApdFaxServerManager* Mgr, TApdCustomFaxServer* QueryFrom, System::UnicodeString &JobFile, System::UnicodeString &FaxFile, System::UnicodeString &CoverFile, int &RecipientNum);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TFaxListObj : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	int FileTime;
	Oomisc::TFaxJobHeaderRec JobHeader;
public:
	/* TObject.Create */ inline __fastcall TFaxListObj(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TFaxListObj(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdFaxJobHandler : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
public:
	void __fastcall AddRecipient(Oomisc::TPassString &JobFileName, const Oomisc::TFaxRecipientRec &RecipientInfo);
	void __fastcall MakeJob(Oomisc::TPassString &FaxName, Oomisc::TPassString &CoverName, Oomisc::TPassString &JobName, Oomisc::TPassString &Sender, Oomisc::TPassString &DestName, const Oomisc::TFaxRecipientRec &Recipient);
	System::Uitypes::TModalResult __fastcall ShowFaxJobInfoDialog(Oomisc::TPassString &JobFileName, Oomisc::TPassString &DlgCaption);
	void __fastcall ExtractAPF(Oomisc::TPassString &JobFileName, Oomisc::TPassString &FaxName);
	bool __fastcall ExtractCoverFile(Oomisc::TPassString &JobFileName, Oomisc::TPassString &CoverName);
	int __fastcall GetRecipient(Oomisc::TPassString &JobFileName, int Index, Oomisc::TFaxRecipientRec &Recipient);
	void __fastcall GetJobHeader(Oomisc::TPassString &JobFileName, Oomisc::TFaxJobHeaderRec &JobHeader);
	int __fastcall GetRecipientStatus(Oomisc::TPassString &JobFileName, int JobNum);
	void __fastcall CancelRecipient(Oomisc::TPassString &JobFileName, System::Byte JobNum);
	void __fastcall ConcatFaxes(Oomisc::TPassString &DestFaxFile, Oomisc::TPassString *FaxFiles, const int FaxFiles_High);
	void __fastcall ResetAPJPartials(Oomisc::TPassString &JobFileName, bool ResetAttemptNum);
	void __fastcall ResetAPJStatus(Oomisc::TPassString &JobFileName);
	void __fastcall ResetRecipientStatus(Oomisc::TPassString &JobFileName, System::Byte JobNum, System::Byte NewStatus);
	void __fastcall RescheduleJob(Oomisc::TPassString &JobFileName, int JobNum, System::TDateTime NewSchedDT, bool ResetStatus);
public:
	/* TComponent.Create */ inline __fastcall virtual TApdFaxJobHandler(System::Classes::TComponent* AOwner) : Oomisc::TApdBaseComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TApdFaxJobHandler(void) { }
	
};


class PASCALIMPLEMENTATION TApdFaxServerManager : public TApdFaxJobHandler
{
	typedef TApdFaxJobHandler inherited;
	
private:
	Oomisc::TPassString FMonitorDir;
	System::Classes::TStringList* FFaxList;
	Oomisc::TPassString FJobFileExt;
	bool FPaused;
	System::Classes::TFileStream* FLockFile;
	bool FDeleteOnComplete;
	bool FFirstGetJob;
	bool FInGetJob;
	TFaxServerManagerQueriedEvent FFaxServerManagerQueriedEvent;
	TManagerUpdateRecipientEvent FManagerUpdateRecipientEvent;
	TManagerUserGetJobEvent FManagerUserGetJobEvent;
	
public:
	__fastcall virtual TApdFaxServerManager(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdFaxServerManager(void);
	Oomisc::TPassString __fastcall GetNextFax(void);
	System::TDateTime __fastcall GetSchedTime(Oomisc::TPassString &JobFileName);
	bool __fastcall GetJob(Oomisc::TFaxRecipientRec &Recipient, TApdCustomFaxServer* QueryFrom, Oomisc::TPassString &JobFileName, Oomisc::TPassString &FaxFile, Oomisc::TPassString &CoverFile);
	void __fastcall UpdateStatus(Oomisc::TPassString &JobFileName, System::Word JobNumber, System::Word Result, bool Failed);
	void __fastcall Reset(void);
	void __fastcall SetMonitorDir(const Oomisc::TPassString &Value);
	__property System::Classes::TStringList* FaxList = {read=FFaxList};
	
__published:
	__property bool DeleteOnComplete = {read=FDeleteOnComplete, write=FDeleteOnComplete, nodefault};
	__property Oomisc::TPassString MonitorDir = {read=FMonitorDir, write=SetMonitorDir};
	__property Oomisc::TPassString JobFileExt = {read=FJobFileExt, write=FJobFileExt};
	__property bool Paused = {read=FPaused, write=FPaused, default=0};
	__property TFaxServerManagerQueriedEvent OnQueried = {read=FFaxServerManagerQueriedEvent, write=FFaxServerManagerQueriedEvent};
	__property TManagerUpdateRecipientEvent OnRecipientComplete = {read=FManagerUpdateRecipientEvent, write=FManagerUpdateRecipientEvent};
	__property TManagerUserGetJobEvent OnCustomGetJob = {read=FManagerUserGetJobEvent, write=FManagerUserGetJobEvent};
};


class PASCALIMPLEMENTATION TApdFaxClient : public TApdFaxJobHandler
{
	typedef TApdFaxJobHandler inherited;
	
private:
	Oomisc::TPassString FJobName;
	Oomisc::TPassString FSender;
	Oomisc::TPassString FCoverFileName;
	Oomisc::TPassString FJobFileName;
	Oomisc::TPassString FFaxFileName;
	System::TDateTime __fastcall GetScheduleDateTime(void);
	void __fastcall SetHeaderLine(const Oomisc::TPassString &Value);
	void __fastcall SetHeaderRecipient(const Oomisc::TPassString &Value);
	void __fastcall SetHeaderTitle(const Oomisc::TPassString &Value);
	void __fastcall SetPhoneNumber(const Oomisc::TPassString &Value);
	void __fastcall SetScheduleDateTime(const System::TDateTime Value);
	Oomisc::TPassString __fastcall GetHeaderLine(void);
	Oomisc::TPassString __fastcall GetHeaderRecipient(void);
	Oomisc::TPassString __fastcall GetHeaderTitle(void);
	Oomisc::TPassString __fastcall GetPhoneNumber(void);
	
public:
	Oomisc::TFaxRecipientRec Recipient;
	__fastcall virtual TApdFaxClient(System::Classes::TComponent* AOwner);
	int __fastcall CopyJobToServer(Oomisc::TPassString &SourceJob, Oomisc::TPassString &DestJob, bool OverWrite);
	void __fastcall MakeFaxJob(void);
	__property System::TDateTime ScheduleDateTime = {read=GetScheduleDateTime, write=SetScheduleDateTime};
	
__published:
	__property Oomisc::TPassString CoverFileName = {read=FCoverFileName, write=FCoverFileName};
	__property Oomisc::TPassString FaxFileName = {read=FFaxFileName, write=FFaxFileName};
	__property Oomisc::TPassString JobFileName = {read=FJobFileName, write=FJobFileName};
	__property Oomisc::TPassString JobName = {read=FJobName, write=FJobName};
	__property Oomisc::TPassString Sender = {read=FSender, write=FSender};
	__property Oomisc::TPassString PhoneNumber = {read=GetPhoneNumber, write=SetPhoneNumber};
	__property Oomisc::TPassString HeaderLine = {read=GetHeaderLine, write=SetHeaderLine};
	__property Oomisc::TPassString HeaderRecipient = {read=GetHeaderRecipient, write=SetHeaderRecipient};
	__property Oomisc::TPassString HeaderTitle = {read=GetHeaderTitle, write=SetHeaderTitle};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TApdFaxClient(void) { }
	
};


class PASCALIMPLEMENTATION TApdCustomFaxServer : public Adfax::TApdCustomAbstractFax
{
	typedef Adfax::TApdCustomAbstractFax inherited;
	
private:
	Adport::TApdCustomComPort* FComPort;
	Adtapi::TApdCustomTapiDevice* FTapiDevice;
	Adfax::TApdAbstractFaxStatus* FStatusDisplay;
	Adfax::TApdFaxLog* FFaxLog;
	Adfax::TApdSendFax* FSendFax;
	Adfax::TApdReceiveFax* FRecvFax;
	Vcl::Extctrls::TTimer* FSendQueryTimer;
	bool FSoftwareFlow;
	bool FSafeMode;
	bool FExitOnError;
	bool FBlindDial;
	bool FToneDial;
	bool FConstantStatus;
	int FInitBaud;
	int FNormalBaud;
	Oomisc::TPassString FCoverFile;
	Oomisc::TPassString FHeaderTitle;
	Oomisc::TPassString FPhoneNumber;
	Oomisc::TPassString FHeaderLine;
	Oomisc::TPassString FHeaderRecipient;
	Oomisc::TPassString FDestinationDir;
	Oomisc::TPassString FFaxFile;
	Oomisc::TPassString FFaxFileExt;
	Oomisc::TPassString FHeaderSender;
	Adfax::TFaxClass FFaxClass;
	Adfax::TFaxNameMode FFaxNameMode;
	Adfax::TModemString FModemInit;
	Adfax::TStationID FStationID;
	System::Word FAnswerOnRing;
	System::Word FBufferMinimum;
	System::Word FStatusInterval;
	System::Word FMaxSendCount;
	bool FMonitoring;
	bool FOldMonitoring;
	Adfaxprn::TApdCustomFaxPrinter* FFaxPrinter;
	bool FPrintOnReceive;
	TFaxServerMode FFaxServerMode;
	bool FFaxInProgress;
	System::Word FDesiredBPS;
	bool FDesiredECM;
	bool FDetectBusy;
	int FPageLength;
	System::Word FDelayBetweenSends;
	TApdFaxServerManager* FServerManager;
	int FSendQueryInterval;
	System::Word FDialAttempts;
	System::Word FDialWait;
	System::Word FDialRetryWait;
	Adfax::TModemString FDialPrefix;
	Vcl::Graphics::TFont* FEnhFont;
	Vcl::Graphics::TFont* FEnhHeaderFont;
	bool FEnhTextEnabled;
	bool WaitingOnTapi;
	Oomisc::TFaxServerLogCode FServerLogCode;
	TFaxServerFatalErrorEvent FFaxServerFatalErrorEvent;
	TFaxServerStatusEvent FFaxServerStatusEvent;
	TFaxServerFinishEvent FFaxServerFinishEvent;
	TFaxServerPortOpenCloseEvent FFaxServerPortOpenCloseEvent;
	TFaxServerAcceptEvent FFaxServerAcceptEvent;
	TFaxServerNameEvent FFaxServerNameEvent;
	TFaxServerLogEvent FFaxServerLogEvent;
	bool FSwitchingModes;
	bool FWaitForRing;
	
protected:
	HIDESBASE void __fastcall SetComPort(Adport::TApdCustomComPort* const Value);
	HIDESBASE void __fastcall SetFaxLog(Adfax::TApdFaxLog* const Value);
	HIDESBASE void __fastcall SetStatusDisplay(Adfax::TApdAbstractFaxStatus* const Value);
	void __fastcall SetAnswerOnRing(const System::Word Value);
	void __fastcall SetBlindDial(const bool Value);
	void __fastcall SetBufferMinimum(const System::Word Value);
	void __fastcall SetConstantStatus(const bool Value);
	void __fastcall SetCoverFile(const Oomisc::TPassString &Value);
	void __fastcall SetDestinationDir(const Oomisc::TPassString &Value);
	HIDESBASE void __fastcall SetExitOnError(const bool Value);
	HIDESBASE void __fastcall SetFaxClass(const Adfax::TFaxClass Value);
	virtual void __fastcall SetFaxFile(const Oomisc::TPassString &Value);
	HIDESBASE void __fastcall SetFaxFileExt(const Oomisc::TPassString &Value);
	void __fastcall SetFaxNameMode(const Adfax::TFaxNameMode Value);
	void __fastcall SetHeaderLine(const Oomisc::TPassString &Value);
	void __fastcall SetHeaderRecipient(const Oomisc::TPassString &Value);
	void __fastcall SetHeaderSender(const Oomisc::TPassString &Value);
	void __fastcall SetHeaderTitle(const Oomisc::TPassString &Value);
	HIDESBASE void __fastcall SetInitBaud(const int Value);
	void __fastcall SetMaxSendCount(const System::Word Value);
	HIDESBASE void __fastcall SetModemInit(const Adfax::TModemString &Value);
	HIDESBASE void __fastcall SetNormalBaud(const int Value);
	void __fastcall SetPhoneNumber(const Oomisc::TPassString &Value);
	void __fastcall SetSafeMode(const bool Value);
	HIDESBASE void __fastcall SetSoftwareFlow(const bool Value);
	HIDESBASE void __fastcall SetStationID(const Adfax::TStationID &Value);
	HIDESBASE void __fastcall SetStatusInterval(const System::Word Value);
	void __fastcall SetToneDial(const bool Value);
	void __fastcall SetMonitoring(const bool Value);
	void __fastcall SetFaxPrinter(Adfaxprn::TApdCustomFaxPrinter* const Value);
	void __fastcall SetPrintOnReceive(const bool Value);
	HIDESBASE void __fastcall SetDesiredBPS(const System::Word Value);
	HIDESBASE void __fastcall SetDesiredECM(const bool Value);
	void __fastcall SetDetectBusy(const bool Value);
	void __fastcall SetDelayBetweenSends(const System::Word Value);
	void __fastcall SetServerManager(TApdFaxServerManager* const Value);
	void __fastcall SetSendQueryInterval(const int Value);
	void __fastcall SetFaxServerMode(const TFaxServerMode Value);
	void __fastcall SetDialAttempts(const System::Word Value);
	void __fastcall SetDialWait(const System::Word Value);
	void __fastcall SetDialPrefix(const Adfax::TModemString &Value);
	void __fastcall SetEnhFont(Vcl::Graphics::TFont* const Value);
	void __fastcall SetEnhHeaderFont(Vcl::Graphics::TFont* const Value);
	void __fastcall SetEnhTextEnabled(const bool Value);
	void __fastcall SetTapiDevice(Adtapi::TApdCustomTapiDevice* const Value);
	HIDESBASE int __fastcall GetPageLength(void);
	HIDESBASE int __fastcall GetBytesTransferred(void);
	HIDESBASE System::Word __fastcall GetCurrentPage(void);
	System::Word __fastcall GetDialAttempt(void);
	System::Word __fastcall GetDialAttempts(void);
	HIDESBASE unsigned __fastcall GetElapsedTime(void);
	HIDESBASE System::Word __fastcall GetFaxProgress(void);
	HIDESBASE System::Word __fastcall GetHangupCode(void);
	HIDESBASE int __fastcall GetModemBPS(void);
	HIDESBASE System::UnicodeString __fastcall GetModemChip(void);
	HIDESBASE bool __fastcall GetModemECM(void);
	HIDESBASE System::UnicodeString __fastcall GetModemModel(void);
	HIDESBASE System::UnicodeString __fastcall GetModemRevision(void);
	HIDESBASE System::UnicodeString __fastcall GetRemoteID(void);
	HIDESBASE System::Word __fastcall GetSessionBPS(void);
	HIDESBASE bool __fastcall GetSessionECM(void);
	HIDESBASE bool __fastcall GetSessionResolution(void);
	HIDESBASE bool __fastcall GetSessionWidth(void);
	HIDESBASE Adfax::TFaxClassSet __fastcall GetSupportedFaxClasses(void);
	HIDESBASE System::Word __fastcall GetTotalPages(void);
	void __fastcall FInternalFaxFinish(System::TObject* CP, int ErrorCode);
	void __fastcall FInternalFaxStatus(System::TObject* CP, bool First, bool Last);
	void __fastcall FInternalSendQueryTimer(System::TObject* Sender);
	void __fastcall FInternalTapiPortOpenClose(System::TObject* Sender);
	void __fastcall FInternalTapiFail(System::TObject* Sender);
	void __fastcall FInternalPortToggle(System::TObject* CP, bool Opening);
	void __fastcall FInternalFaxAccept(System::TObject* CP, bool &Accept);
	void __fastcall FInternalFaxName(System::TObject* CP, Oomisc::TPassString &Name);
	void __fastcall FInternalFaxLog(System::TObject* CP, Oomisc::TFaxLogCode LogCode);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	HIDESBASE void __fastcall CheckPort(void);
	
public:
	Oomisc::TPassString CurrentJobFileName;
	int CurrentJobNumber;
	Oomisc::TFaxRecipientRec CurrentRecipient;
	Oomisc::TFaxJobHeaderRec CurrentJobHeader;
	__fastcall virtual TApdCustomFaxServer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomFaxServer(void);
	bool __fastcall StartTransmitSingle(void);
	void __fastcall ForceSendQuery(void);
	HIDESBASE void __fastcall CancelFax(void);
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=SetComPort};
	__property Adtapi::TApdCustomTapiDevice* TapiDevice = {read=FTapiDevice, write=SetTapiDevice};
	__property TApdFaxServerManager* ServerManager = {read=FServerManager, write=SetServerManager};
	__property Adfax::TApdAbstractFaxStatus* StatusDisplay = {read=FStatusDisplay, write=SetStatusDisplay};
	__property Adfaxprn::TApdCustomFaxPrinter* FaxPrinter = {read=FFaxPrinter, write=SetFaxPrinter};
	__property Adfax::TApdFaxLog* FaxLog = {read=FFaxLog, write=SetFaxLog};
	__property bool ExitOnError = {read=FExitOnError, write=SetExitOnError, default=0};
	__property Adfax::TFaxClass FaxClass = {read=FFaxClass, write=SetFaxClass, default=1};
	__property Oomisc::TPassString FaxFile = {read=FFaxFile, write=SetFaxFile};
	__property Oomisc::TPassString FaxFileExt = {read=FFaxFileExt, write=SetFaxFileExt};
	__property int InitBaud = {read=FInitBaud, write=SetInitBaud, default=0};
	__property Adfax::TModemString ModemInit = {read=FModemInit, write=SetModemInit};
	__property int NormalBaud = {read=FNormalBaud, write=SetNormalBaud, default=0};
	__property bool SoftwareFlow = {read=FSoftwareFlow, write=SetSoftwareFlow, default=0};
	__property Adfax::TStationID StationID = {read=FStationID, write=SetStationID};
	__property System::Word StatusInterval = {read=FStatusInterval, write=SetStatusInterval, default=1};
	__property System::Word DesiredBPS = {read=FDesiredBPS, write=SetDesiredBPS, default=9600};
	__property bool DesiredECM = {read=FDesiredECM, write=SetDesiredECM, default=0};
	__property System::Word DelayBetweenSends = {read=FDelayBetweenSends, write=SetDelayBetweenSends, default=18};
	__property int SendQueryInterval = {read=FSendQueryInterval, write=SetSendQueryInterval, nodefault};
	__property int BytesTransferred = {read=GetBytesTransferred, nodefault};
	__property System::Word CurrentPage = {read=GetCurrentPage, nodefault};
	__property unsigned ElapsedTime = {read=GetElapsedTime, nodefault};
	__property System::Word FaxProgress = {read=GetFaxProgress, nodefault};
	__property System::Word HangupCode = {read=GetHangupCode, nodefault};
	__property int ModemBPS = {read=GetModemBPS, nodefault};
	__property System::UnicodeString ModemChip = {read=GetModemChip};
	__property bool ModemECM = {read=GetModemECM, nodefault};
	__property System::UnicodeString ModemModel = {read=GetModemModel};
	__property System::UnicodeString ModemRevision = {read=GetModemRevision};
	__property int PageLength = {read=GetPageLength, nodefault};
	__property System::UnicodeString RemoteID = {read=GetRemoteID};
	__property System::Word SessionBPS = {read=GetSessionBPS, nodefault};
	__property bool SessionECM = {read=GetSessionECM, nodefault};
	__property bool SessionResolution = {read=GetSessionResolution, nodefault};
	__property bool SessionWidth = {read=GetSessionWidth, nodefault};
	__property Adfax::TFaxClassSet SupportedFaxClasses = {read=GetSupportedFaxClasses, nodefault};
	__property System::Word TotalPages = {read=GetTotalPages, nodefault};
	__property bool BlindDial = {read=FBlindDial, write=SetBlindDial, default=0};
	__property System::Word BufferMinimum = {read=FBufferMinimum, write=SetBufferMinimum, default=1000};
	__property Oomisc::TPassString CoverFile = {read=FCoverFile, write=SetCoverFile};
	__property bool DetectBusy = {read=FDetectBusy, write=SetDetectBusy, default=1};
	__property System::Word DialAttempt = {read=GetDialAttempt, nodefault};
	__property System::Word DialAttempts = {read=GetDialAttempts, write=SetDialAttempts, default=3};
	__property Adfax::TModemString DialPrefix = {read=FDialPrefix, write=SetDialPrefix};
	__property System::Word DialWait = {read=FDialWait, write=SetDialWait, default=60};
	__property System::Word DialRetryWait = {read=FDialRetryWait, write=FDialRetryWait, default=60};
	__property Oomisc::TPassString HeaderLine = {read=FHeaderLine, write=SetHeaderLine};
	__property Oomisc::TPassString HeaderRecipient = {read=FHeaderRecipient, write=SetHeaderRecipient};
	__property Oomisc::TPassString HeaderSender = {read=FHeaderSender, write=SetHeaderSender};
	__property Oomisc::TPassString HeaderTitle = {read=FHeaderTitle, write=SetHeaderTitle};
	__property System::Word MaxSendCount = {read=FMaxSendCount, write=SetMaxSendCount, default=50};
	__property Oomisc::TPassString PhoneNumber = {read=FPhoneNumber, write=SetPhoneNumber};
	__property bool SafeMode = {read=FSafeMode, write=SetSafeMode, default=1};
	__property bool ToneDial = {read=FToneDial, write=SetToneDial, default=1};
	__property bool EnhTextEnabled = {read=FEnhTextEnabled, write=SetEnhTextEnabled, nodefault};
	__property Vcl::Graphics::TFont* EnhHeaderFont = {read=FEnhHeaderFont, write=SetEnhHeaderFont};
	__property Vcl::Graphics::TFont* EnhFont = {read=FEnhFont, write=SetEnhFont};
	__property System::Word AnswerOnRing = {read=FAnswerOnRing, write=SetAnswerOnRing, default=1};
	__property bool ConstantStatus = {read=FConstantStatus, write=SetConstantStatus, default=0};
	__property Oomisc::TPassString DestinationDir = {read=FDestinationDir, write=SetDestinationDir};
	__property Adfax::TFaxNameMode FaxNameMode = {read=FFaxNameMode, write=SetFaxNameMode, default=1};
	__property bool PrintOnReceive = {read=FPrintOnReceive, write=SetPrintOnReceive, nodefault};
	__property bool Monitoring = {read=FMonitoring, write=SetMonitoring, nodefault};
	__property bool FaxInProgress = {read=FFaxInProgress, write=FFaxInProgress, default=0};
	__property TFaxServerMode FaxServerMode = {read=FFaxServerMode, write=SetFaxServerMode, nodefault};
	__property TFaxServerStatusEvent OnFaxServerStatus = {read=FFaxServerStatusEvent, write=FFaxServerStatusEvent};
	__property TFaxServerFatalErrorEvent OnFaxServerFatalError = {read=FFaxServerFatalErrorEvent, write=FFaxServerFatalErrorEvent};
	__property TFaxServerFinishEvent OnFaxServerFinish = {read=FFaxServerFinishEvent, write=FFaxServerFinishEvent};
	__property TFaxServerPortOpenCloseEvent OnFaxServerPortOpenClose = {read=FFaxServerPortOpenCloseEvent, write=FFaxServerPortOpenCloseEvent};
	__property TFaxServerAcceptEvent OnFaxServerAccept = {read=FFaxServerAcceptEvent, write=FFaxServerAcceptEvent};
	__property TFaxServerNameEvent OnFaxServerName = {read=FFaxServerNameEvent, write=FFaxServerNameEvent};
	__property TFaxServerLogEvent OnFaxServerLog = {read=FFaxServerLogEvent, write=FFaxServerLogEvent};
};


class PASCALIMPLEMENTATION TApdFaxServer : public TApdCustomFaxServer
{
	typedef TApdCustomFaxServer inherited;
	
__published:
	__property ComPort;
	__property TapiDevice;
	__property ServerManager;
	__property StatusDisplay;
	__property FaxLog;
	__property ExitOnError = {default=0};
	__property FaxClass = {default=1};
	__property InitBaud = {default=0};
	__property ModemInit;
	__property NormalBaud = {default=0};
	__property SoftwareFlow = {default=0};
	__property StationID;
	__property StatusInterval = {default=1};
	__property DelayBetweenSends = {default=18};
	__property SendQueryInterval;
	__property DesiredBPS = {default=9600};
	__property DesiredECM = {default=0};
	__property FaxFileExt;
	__property BlindDial = {default=0};
	__property BufferMinimum = {default=1000};
	__property DetectBusy = {default=1};
	__property DialWait = {default=60};
	__property DialRetryWait = {default=60};
	__property DialAttempts = {default=3};
	__property MaxSendCount = {default=50};
	__property SafeMode = {default=1};
	__property ToneDial = {default=1};
	__property DialPrefix = {default=0};
	__property EnhTextEnabled;
	__property EnhFont;
	__property EnhHeaderFont;
	__property AnswerOnRing = {default=1};
	__property ConstantStatus = {default=0};
	__property DestinationDir = {default=0};
	__property FaxNameMode = {default=1};
	__property PrintOnReceive;
	__property FaxPrinter;
	__property OnFaxServerStatus;
	__property OnFaxServerFatalError;
	__property OnFaxServerFinish;
	__property OnFaxServerPortOpenClose;
	__property OnFaxServerAccept;
	__property OnFaxServerName;
	__property OnFaxServerLog;
public:
	/* TApdCustomFaxServer.Create */ inline __fastcall virtual TApdFaxServer(System::Classes::TComponent* AOwner) : TApdCustomFaxServer(AOwner) { }
	/* TApdCustomFaxServer.Destroy */ inline __fastcall virtual ~TApdFaxServer(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 adfDefDelayBetweenSends = System::Int8(0x12);
static const System::Int8 adfDefSendQueryInterval = System::Int8(0x1e);
#define adfDefJobFileExt L"APJ"
static const int apfDefJobHeaderID = int(0x304a5041);
static const bool adfDefFaxServerManagerPaused = false;
#define ServerManagerLockFileName L"SRVMGR.LCK"
static const System::Int8 stNone = System::Int8(0x0);
static const System::Int8 stPartial = System::Int8(0x1);
static const System::Int8 stComplete = System::Int8(0x2);
static const System::Int8 stPaused = System::Int8(0x3);
}	/* namespace Adfaxsrv */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFAXSRV)
using namespace Adfaxsrv;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfaxsrvHPP
