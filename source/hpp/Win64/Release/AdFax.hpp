// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFax.pas' rev: 32.00 (Windows)

#ifndef AdfaxHPP
#define AdfaxHPP

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
#include <Winapi.Messages.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <AwAbsFax.hpp>
#include <AwFax.hpp>
#include <AwFaxCvt.hpp>
#include <AdExcept.hpp>
#include <AdPort.hpp>
#include <AdTapi.hpp>
#include <AdTUtil.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adfax
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomAbstractFax;
class DELPHICLASS TApdAbstractFaxStatus;
class DELPHICLASS TApdFaxLog;
class DELPHICLASS TApdAbstractFax;
class DELPHICLASS TApdCustomReceiveFax;
class DELPHICLASS TApdReceiveFax;
class DELPHICLASS TApdCustomSendFax;
class DELPHICLASS TApdSendFax;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TFaxClass : unsigned char { fcUnknown, fcDetect, fcClass1, fcClass2, fcClass2_0 };

typedef System::Set<TFaxClass, TFaxClass::fcUnknown, TFaxClass::fcClass2_0> TFaxClassSet;

typedef void __fastcall (__closure *TFaxStatusEvent)(System::TObject* CP, bool First, bool Last);

typedef void __fastcall (__closure *TFaxLogEvent)(System::TObject* CP, Oomisc::TFaxLogCode LogCode);

typedef void __fastcall (__closure *TFaxErrorEvent)(System::TObject* CP, int ErrorCode);

typedef void __fastcall (__closure *TFaxFinishEvent)(System::TObject* CP, int ErrorCode);

typedef void __fastcall (__closure *TFaxAcceptEvent)(System::TObject* CP, bool &Accept);

typedef void __fastcall (__closure *TFaxNameEvent)(System::TObject* CP, Oomisc::TPassString &Name);

typedef void __fastcall (__closure *TFaxNextEvent)(System::TObject* CP, Oomisc::TPassString &APhoneNumber, Oomisc::TPassString &AFaxFile, Oomisc::TPassString &ACoverFile);

typedef System::SmallString<40> TModemString;

typedef System::SmallString<20> TStationID;

enum DECLSPEC_DENUM TFaxMode : unsigned char { fmNone, fmSend, fmReceive };

enum DECLSPEC_DENUM TFaxNameMode : unsigned char { fnNone, fnCount, fnMonthDay };

class PASCALIMPLEMENTATION TApdCustomAbstractFax : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	Awabsfax::TFaxRec *Fax;
	TFaxMode FaxMode;
	HWND MsgHandler;
	Awabsfax::TFaxPrepProc PrepProc;
	Awabsfax::TFaxFunc FaxFunc;
	bool FWaitForTapi;
	bool FTapiPrepared;
	System::Classes::TNotifyEvent FUserOnTapiPortOpen;
	System::Classes::TNotifyEvent FUserOnTapiPortClose;
	Adtapi::TTapiStatusEvent FUserOnTapiStatus;
	Oomisc::TPassString FModemModel;
	Oomisc::TPassString FModemChip;
	Oomisc::TPassString FModemRevision;
	int FModemBPS;
	bool FCorrection;
	Adport::TApdCustomComPort* FComPort;
	Adtapi::TApdCustomTapiDevice* FTapiDevice;
	TApdAbstractFaxStatus* FStatusDisplay;
	TApdFaxLog* FFaxLog;
	Oomisc::TPassString FFaxFile;
	TFaxClassSet FSupportedFaxClasses;
	int FVersion;
	Oomisc::TPassString FTempFile;
	unsigned FStartTime;
	TFaxStatusEvent FOnFaxStatus;
	TFaxLogEvent FOnFaxLog;
	TFaxErrorEvent FOnFaxError;
	TFaxFinishEvent FOnFaxFinish;
	unsigned __fastcall GetElapsedTime(void);
	virtual Oomisc::TPassString __fastcall GetFaxFile(void);
	virtual void __fastcall SetFaxFile(const Oomisc::TPassString &NewFile);
	int __fastcall GetInitBaud(void);
	void __fastcall SetInitBaud(const int NewBaud);
	bool __fastcall GetInProgress(void);
	int __fastcall GetNormalBaud(void);
	void __fastcall SetNormalBaud(const int NewBaud);
	TFaxClass __fastcall GetFaxClass(void);
	void __fastcall SetFaxClass(const TFaxClass NewClass);
	TModemString __fastcall GetModemInit(void);
	void __fastcall SetModemInit(const TModemString &NewInit);
	TStationID __fastcall GetStationID(void);
	void __fastcall SetStationID(const TStationID &NewID);
	void __fastcall SetComPort(Adport::TApdCustomComPort* const NewPort);
	void __fastcall SetStatusDisplay(TApdAbstractFaxStatus* const NewDisplay);
	void __fastcall SetFaxLog(TApdFaxLog* const NewLog);
	TStationID __fastcall GetRemoteID(void);
	TFaxClassSet __fastcall GetSupportedFaxClasses(void);
	System::Word __fastcall GetFaxProgress(void);
	int __fastcall GetFaxError(void);
	System::Word __fastcall GetSessionBPS(void);
	bool __fastcall GetSessionResolution(void);
	bool __fastcall GetSessionWidth(void);
	bool __fastcall GetSessionECM(void);
	System::Word __fastcall GetHangupCode(void);
	bool __fastcall GetLastPageStatus(void);
	Oomisc::TPassString __fastcall GetModemModel(void);
	Oomisc::TPassString __fastcall GetModemRevision(void);
	Oomisc::TPassString __fastcall GetModemChip(void);
	int __fastcall GetModemBPS(void);
	bool __fastcall GetModemECM(void);
	System::Word __fastcall GetTotalPages(void);
	System::Word __fastcall GetCurrentPage(void);
	int __fastcall GetBytesTransferred(void);
	int __fastcall GetPageLength(void);
	bool __fastcall GetAbortNoConnect(void);
	void __fastcall SetAbortNoConnect(bool NewValue);
	bool __fastcall GetExitOnError(void);
	void __fastcall SetExitOnError(bool NewValue);
	bool __fastcall GetSoftwareFlow(void);
	void __fastcall SetSoftwareFlow(bool NewValue);
	System::Word __fastcall GetStatusInterval(void);
	void __fastcall SetStatusInterval(System::Word NewValue);
	System::Word __fastcall GetDesiredBPS(void);
	void __fastcall SetDesiredBPS(System::Word NewBPS);
	bool __fastcall GetDesiredECM(void);
	void __fastcall SetDesiredECM(bool NewECM);
	Oomisc::TPassString __fastcall GetFaxFileExt(void);
	void __fastcall SetFaxFileExt(const Oomisc::TPassString &NewExt);
	void __fastcall CheckPort(void);
	void __fastcall CreateFaxMessageHandler(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall PrepareTapi(void);
	virtual void __fastcall UnprepareTapi(void);
	void __fastcall OpenTapiPort(void);
	void __fastcall CloseTapiPort(void);
	void __fastcall WaitForTapi(void);
	void __fastcall FaxTapiPortOpenClose(System::TObject* Sender);
	virtual void __fastcall Loaded(void);
	void __fastcall ReadVersionCheck(System::Classes::TReader* Reader);
	void __fastcall WriteVersionCheck(System::Classes::TWriter* Writer);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall apwFaxStatus(System::TObject* CP, bool First, bool Last);
	virtual void __fastcall apwFaxLog(System::TObject* CP, Oomisc::TFaxLogCode LogCode);
	virtual void __fastcall apwFaxError(System::TObject* CP, int ErrorCode);
	virtual void __fastcall apwFaxFinish(System::TObject* CP, int ErrorCode);
	
public:
	__property int InitBaud = {read=GetInitBaud, write=SetInitBaud, default=0};
	__property int NormalBaud = {read=GetNormalBaud, write=SetNormalBaud, default=0};
	__property TFaxClass FaxClass = {read=GetFaxClass, write=SetFaxClass, default=1};
	__property TModemString ModemInit = {read=GetModemInit, write=SetModemInit};
	__property TStationID StationID = {read=GetStationID, write=SetStationID};
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=SetComPort};
	__property Adtapi::TApdCustomTapiDevice* TapiDevice = {read=FTapiDevice, write=FTapiDevice};
	__property TApdAbstractFaxStatus* StatusDisplay = {read=FStatusDisplay, write=SetStatusDisplay};
	__property TApdFaxLog* FaxLog = {read=FFaxLog, write=SetFaxLog};
	__property Oomisc::TPassString FaxFile = {read=GetFaxFile, write=SetFaxFile};
	__property bool AbortNoConnect = {read=GetAbortNoConnect, write=SetAbortNoConnect, default=0};
	__property bool ExitOnError = {read=GetExitOnError, write=SetExitOnError, default=0};
	__property bool SoftwareFlow = {read=GetSoftwareFlow, write=SetSoftwareFlow, default=0};
	__property System::Word StatusInterval = {read=GetStatusInterval, write=SetStatusInterval, default=1};
	__property System::Word DesiredBPS = {read=GetDesiredBPS, write=SetDesiredBPS, default=9600};
	__property bool DesiredECM = {read=GetDesiredECM, write=SetDesiredECM, default=0};
	__property Oomisc::TPassString FaxFileExt = {read=GetFaxFileExt, write=SetFaxFileExt};
	__property TFaxStatusEvent OnFaxStatus = {read=FOnFaxStatus, write=FOnFaxStatus};
	__property TFaxLogEvent OnFaxLog = {read=FOnFaxLog, write=FOnFaxLog};
	__property TFaxErrorEvent OnFaxError = {read=FOnFaxError, write=FOnFaxError};
	__property TFaxFinishEvent OnFaxFinish = {read=FOnFaxFinish, write=FOnFaxFinish};
	__property TFaxClassSet SupportedFaxClasses = {read=GetSupportedFaxClasses, nodefault};
	__property System::Word FaxProgress = {read=GetFaxProgress, nodefault};
	__property int FaxError = {read=GetFaxError, nodefault};
	__property System::Word SessionBPS = {read=GetSessionBPS, nodefault};
	__property bool SessionResolution = {read=GetSessionResolution, nodefault};
	__property bool SessionWidth = {read=GetSessionWidth, nodefault};
	__property bool SessionECM = {read=GetSessionECM, nodefault};
	__property System::Word HangupCode = {read=GetHangupCode, nodefault};
	__property bool LastPageStatus = {read=GetLastPageStatus, nodefault};
	__property Oomisc::TPassString ModemModel = {read=GetModemModel};
	__property Oomisc::TPassString ModemRevision = {read=GetModemRevision};
	__property Oomisc::TPassString ModemChip = {read=GetModemChip};
	__property int ModemBPS = {read=GetModemBPS, nodefault};
	__property bool ModemECM = {read=GetModemECM, nodefault};
	__property System::Word TotalPages = {read=GetTotalPages, nodefault};
	__property System::Word CurrentPage = {read=GetCurrentPage, nodefault};
	__property int BytesTransferred = {read=GetBytesTransferred, nodefault};
	__property int PageLength = {read=GetPageLength, nodefault};
	__property TStationID RemoteID = {read=GetRemoteID};
	__property unsigned ElapsedTime = {read=GetElapsedTime, nodefault};
	__property bool InProgress = {read=GetInProgress, nodefault};
	__fastcall virtual TApdCustomAbstractFax(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomAbstractFax(void);
	void __fastcall CancelFax(void);
	Oomisc::TPassString __fastcall StatusMsg(const System::Word Status);
	System::UnicodeString __fastcall LogMsg(const Oomisc::TFaxLogCode LogCode);
};


class PASCALIMPLEMENTATION TApdAbstractFaxStatus : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	Vcl::Forms::TForm* FDisplay;
	Vcl::Forms::TPosition FPosition;
	bool FCtl3D;
	bool FVisible;
	Vcl::Controls::TCaption FCaption;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	TApdCustomAbstractFax* FFax;
	void __fastcall SetPosition(const Vcl::Forms::TPosition NewPosition);
	void __fastcall SetCtl3D(const bool NewCtl3D);
	void __fastcall SetVisible(const bool NewVisible);
	void __fastcall GetProperties(void);
	void __fastcall SetCaption(const Vcl::Controls::TCaption NewCaption);
	void __fastcall Show(void);
	
public:
	__fastcall virtual TApdAbstractFaxStatus(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdAbstractFaxStatus(void);
	virtual void __fastcall UpdateDisplay(const bool First, const bool Last) = 0 ;
	DYNAMIC void __fastcall CreateDisplay(void) = 0 ;
	DYNAMIC void __fastcall DestroyDisplay(void) = 0 ;
	__property Vcl::Forms::TForm* Display = {read=FDisplay, write=FDisplay};
	
__published:
	__property Vcl::Forms::TPosition Position = {read=FPosition, write=SetPosition, nodefault};
	__property bool Ctl3D = {read=FCtl3D, write=SetCtl3D, nodefault};
	__property bool Visible = {read=FVisible, write=SetVisible, nodefault};
	__property TApdCustomAbstractFax* Fax = {read=FFax, write=FFax};
	__property Vcl::Controls::TCaption Caption = {read=FCaption, write=SetCaption};
};


class PASCALIMPLEMENTATION TApdFaxLog : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	Oomisc::TPassString FFaxHistoryName;
	TApdCustomAbstractFax* FFax;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TApdFaxLog(System::Classes::TComponent* AOwner);
	virtual System::UnicodeString __fastcall GetLogString(const Oomisc::TFaxLogCode Log, TApdCustomAbstractFax* aFax);
	virtual void __fastcall UpdateLog(const Oomisc::TFaxLogCode Log);
	
__published:
	__property Oomisc::TPassString FaxHistoryName = {read=FFaxHistoryName, write=FFaxHistoryName};
	__property TApdCustomAbstractFax* Fax = {read=FFax, write=FFax};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TApdFaxLog(void) { }
	
};


class PASCALIMPLEMENTATION TApdAbstractFax : public TApdCustomAbstractFax
{
	typedef TApdCustomAbstractFax inherited;
	
__published:
	__property InitBaud = {default=0};
	__property NormalBaud = {default=0};
	__property FaxClass = {default=1};
	__property ModemInit = {default=0};
	__property StationID = {default=0};
	__property ComPort;
	__property TapiDevice;
	__property StatusDisplay;
	__property FaxLog;
	__property FaxFile = {default=0};
	__property AbortNoConnect = {default=0};
	__property ExitOnError = {default=0};
	__property SoftwareFlow = {default=0};
	__property StatusInterval = {default=1};
	__property DesiredBPS = {default=9600};
	__property DesiredECM = {default=0};
	__property FaxFileExt = {default=0};
	__property OnFaxStatus;
	__property OnFaxLog;
	__property OnFaxError;
	__property OnFaxFinish;
public:
	/* TApdCustomAbstractFax.Create */ inline __fastcall virtual TApdAbstractFax(System::Classes::TComponent* AOwner) : TApdCustomAbstractFax(AOwner) { }
	/* TApdCustomAbstractFax.Destroy */ inline __fastcall virtual ~TApdAbstractFax(void) { }
	
};


class PASCALIMPLEMENTATION TApdCustomReceiveFax : public TApdAbstractFax
{
	typedef TApdAbstractFax inherited;
	
protected:
	TFaxNameMode FFaxNameMode;
	System::Word RingCount;
	TFaxAcceptEvent FOnFaxAccept;
	TFaxNameEvent FOnFaxName;
	System::Word __fastcall GetAnswerOnRing(void);
	void __fastcall SetAnswerOnRing(const System::Word NewVal);
	bool __fastcall GetFaxAndData(void);
	void __fastcall SetFaxAndData(const bool NewVal);
	bool __fastcall GetOneFax(void);
	void __fastcall SetOneFax(bool NewValue);
	bool __fastcall GetConstantStatus(void);
	void __fastcall SetConstantStatus(const bool NewValue);
	Oomisc::TPassString __fastcall GetDestinationDir(void);
	void __fastcall SetDestinationDir(const Oomisc::TPassString &NewDir);
	virtual void __fastcall apwFaxAccept(System::TObject* CP, bool &Accept);
	virtual void __fastcall apwFaxName(System::TObject* CP, Oomisc::TPassString &Name);
	
public:
	__property System::Word AnswerOnRing = {read=GetAnswerOnRing, write=SetAnswerOnRing, default=1};
	__property bool FaxAndData = {read=GetFaxAndData, write=SetFaxAndData, default=0};
	__property TFaxNameMode FaxNameMode = {read=FFaxNameMode, write=FFaxNameMode, default=1};
	__property bool OneFax = {read=GetOneFax, write=SetOneFax, default=0};
	__property bool ConstantStatus = {read=GetConstantStatus, write=SetConstantStatus, default=0};
	__property Oomisc::TPassString DestinationDir = {read=GetDestinationDir, write=SetDestinationDir};
	__property TFaxAcceptEvent OnFaxAccept = {read=FOnFaxAccept, write=FOnFaxAccept};
	__property TFaxNameEvent OnFaxName = {read=FOnFaxName, write=FOnFaxName};
	virtual void __fastcall PrepareTapi(void);
	virtual void __fastcall UnprepareTapi(void);
	void __fastcall TapiPassiveAnswer(void);
	void __fastcall FaxTapiStatus(System::TObject* CP, bool First, bool Last, int Device, int Message, int Param1, int Param2, int Param3);
	__fastcall virtual TApdCustomReceiveFax(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomReceiveFax(void);
	void __fastcall InitModemForFaxReceive(void);
	void __fastcall PrepareConnectInProgress(void);
	void __fastcall StartReceive(void);
	void __fastcall StartManualReceive(bool SendATAToModem);
};


class PASCALIMPLEMENTATION TApdReceiveFax : public TApdCustomReceiveFax
{
	typedef TApdCustomReceiveFax inherited;
	
__published:
	__property AnswerOnRing = {default=1};
	__property FaxAndData = {default=0};
	__property FaxNameMode = {default=1};
	__property OneFax = {default=0};
	__property ConstantStatus = {default=0};
	__property DestinationDir = {default=0};
	__property OnFaxAccept;
	__property OnFaxName;
public:
	/* TApdCustomReceiveFax.Create */ inline __fastcall virtual TApdReceiveFax(System::Classes::TComponent* AOwner) : TApdCustomReceiveFax(AOwner) { }
	/* TApdCustomReceiveFax.Destroy */ inline __fastcall virtual ~TApdReceiveFax(void) { }
	
};


class PASCALIMPLEMENTATION TApdCustomSendFax : public TApdAbstractFax
{
	typedef TApdAbstractFax inherited;
	
protected:
	bool WasSent;
	Oomisc::TPassString FCoverFile;
	System::Classes::TStringList* FFaxFileList;
	Oomisc::TPassString FPhoneNumber;
	TFaxNextEvent FOnFaxNext;
	bool __fastcall GetFastPage(void);
	void __fastcall SetFastPage(const bool NewVal);
	bool __fastcall GetEnhTextEnabled(void);
	void __fastcall SetEnhTextEnabled(const bool NewVal);
	Vcl::Graphics::TFont* __fastcall GetEnhHeaderFont(void);
	void __fastcall SetEnhHeaderFont(Vcl::Graphics::TFont* const NewVal);
	Vcl::Graphics::TFont* __fastcall GetEnhFont(void);
	void __fastcall SetEnhFont(Vcl::Graphics::TFont* const NewVal);
	void __fastcall SetFaxFileList(System::Classes::TStringList* const NewVal);
	virtual Oomisc::TPassString __fastcall GetFaxFile(void);
	virtual void __fastcall SetFaxFile(const Oomisc::TPassString &NewFile);
	bool __fastcall GetBlindDial(void);
	void __fastcall SetBlindDial(const bool NewVal);
	bool __fastcall GetDetectBusy(void);
	void __fastcall SetDetectBusy(const bool NewVal);
	bool __fastcall GetToneDial(void);
	void __fastcall SetToneDial(const bool NewVal);
	TModemString __fastcall GetDialPrefix(void);
	void __fastcall SetDialPrefix(const TModemString &NewPrefix);
	System::Word __fastcall GetDialWait(void);
	void __fastcall SetDialWait(const System::Word NewWait);
	System::Word __fastcall GetDialAttempts(void);
	void __fastcall SetDialAttempts(const System::Word NewAttempts);
	System::Word __fastcall GetDialRetryWait(void);
	void __fastcall SetDialRetryWait(const System::Word NewWait);
	System::Word __fastcall GetMaxSendCount(void);
	void __fastcall SetMaxSendCount(const System::Word NewCount);
	System::Word __fastcall GetBufferMinimum(void);
	void __fastcall SetBufferMinimum(const System::Word NewMin);
	Oomisc::TPassString __fastcall GetHeaderLine(void);
	void __fastcall SetHeaderLine(const Oomisc::TPassString &S);
	System::Word __fastcall GetDialAttempt(void);
	bool __fastcall GetSafeMode(void);
	void __fastcall SetSafeMode(bool NewMode);
	Oomisc::TPassString __fastcall GetHeaderSender(void);
	void __fastcall SetHeaderSender(const Oomisc::TPassString &NewSender);
	Oomisc::TPassString __fastcall GetHeaderRecipient(void);
	void __fastcall SetHeaderRecipient(const Oomisc::TPassString &NewRecipient);
	Oomisc::TPassString __fastcall GetHeaderTitle(void);
	void __fastcall SetHeaderTitle(const Oomisc::TPassString &NewTitle);
	virtual void __fastcall apwFaxNext(System::TObject* CP, Oomisc::TPassString &APhoneNumber, Oomisc::TPassString &AFaxFile, Oomisc::TPassString &ACoverFile);
	
public:
	__property bool FastPage = {read=GetFastPage, write=SetFastPage, nodefault};
	__property bool EnhTextEnabled = {read=GetEnhTextEnabled, write=SetEnhTextEnabled, nodefault};
	__property Vcl::Graphics::TFont* EnhHeaderFont = {read=GetEnhHeaderFont, write=SetEnhHeaderFont};
	__property Vcl::Graphics::TFont* EnhFont = {read=GetEnhFont, write=SetEnhFont};
	__property System::Classes::TStringList* FaxFileList = {read=FFaxFileList, write=SetFaxFileList};
	__property bool BlindDial = {read=GetBlindDial, write=SetBlindDial, default=0};
	__property bool DetectBusy = {read=GetDetectBusy, write=SetDetectBusy, default=1};
	__property bool ToneDial = {read=GetToneDial, write=SetToneDial, default=1};
	__property TModemString DialPrefix = {read=GetDialPrefix, write=SetDialPrefix};
	__property System::Word DialWait = {read=GetDialWait, write=SetDialWait, default=60};
	__property System::Word DialAttempts = {read=GetDialAttempts, write=SetDialAttempts, default=3};
	__property System::Word DialRetryWait = {read=GetDialRetryWait, write=SetDialRetryWait, default=60};
	__property System::Word MaxSendCount = {read=GetMaxSendCount, write=SetMaxSendCount, default=50};
	__property System::Word BufferMinimum = {read=GetBufferMinimum, write=SetBufferMinimum, default=1000};
	__property Oomisc::TPassString HeaderLine = {read=GetHeaderLine, write=SetHeaderLine};
	__property Oomisc::TPassString CoverFile = {read=FCoverFile, write=FCoverFile};
	__property Oomisc::TPassString PhoneNumber = {read=FPhoneNumber, write=FPhoneNumber};
	__property bool SafeMode = {read=GetSafeMode, write=SetSafeMode, default=1};
	__property Oomisc::TPassString HeaderSender = {read=GetHeaderSender, write=SetHeaderSender};
	__property Oomisc::TPassString HeaderRecipient = {read=GetHeaderRecipient, write=SetHeaderRecipient};
	__property Oomisc::TPassString HeaderTitle = {read=GetHeaderTitle, write=SetHeaderTitle};
	__property System::Word DialAttempt = {read=GetDialAttempt, nodefault};
	__property TFaxNextEvent OnFaxNext = {read=FOnFaxNext, write=FOnFaxNext};
	__fastcall virtual TApdCustomSendFax(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomSendFax(void);
	void __fastcall ConvertCover(const System::UnicodeString InCover, const System::UnicodeString OutCover);
	void __fastcall ConcatFaxes(Oomisc::TPassString &FileName);
	void __fastcall StartTransmit(void);
	void __fastcall StartManualTransmit(void);
};


class PASCALIMPLEMENTATION TApdSendFax : public TApdCustomSendFax
{
	typedef TApdCustomSendFax inherited;
	
__published:
	__property EnhTextEnabled;
	__property EnhHeaderFont;
	__property EnhFont;
	__property FaxFileList;
	__property BlindDial = {default=0};
	__property DetectBusy = {default=1};
	__property ToneDial = {default=1};
	__property DialPrefix = {default=0};
	__property DialWait = {default=60};
	__property DialAttempts = {default=3};
	__property DialRetryWait = {default=60};
	__property MaxSendCount = {default=50};
	__property BufferMinimum = {default=1000};
	__property HeaderLine = {default=0};
	__property CoverFile = {default=0};
	__property PhoneNumber = {default=0};
	__property SafeMode = {default=1};
	__property DialAttempt;
	__property OnFaxNext;
	__property HeaderSender = {default=0};
	__property HeaderRecipient = {default=0};
	__property HeaderTitle = {default=0};
public:
	/* TApdCustomSendFax.Create */ inline __fastcall virtual TApdSendFax(System::Classes::TComponent* AOwner) : TApdCustomSendFax(AOwner) { }
	/* TApdCustomSendFax.Destroy */ inline __fastcall virtual ~TApdSendFax(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define adfDefFaxHistoryName L"APROFAX.HIS"
static const System::Int8 adfDefInitBaud = System::Int8(0x0);
static const System::Int8 adfDefNormalBaud = System::Int8(0x0);
static const TFaxClass adfDefFaxClass = (TFaxClass)(1);
static const bool adfDefAbortNoConnect = false;
static const bool adfDefExitOnError = false;
static const bool adfDefSoftwareFlow = false;
static const System::Int8 adfDefFaxStatusInterval = System::Int8(0x1);
static const System::Word adfDefDesiredBPS = System::Word(0x2580);
static const bool adfDefDesiredECM = false;
static const System::Int8 adfDefAnswerOnRing = System::Int8(0x1);
static const bool adfDefFaxAndData = false;
static const bool adfDefOneFax = false;
static const bool adfDefConstantStatus = false;
static const bool adfDefSafeMode = true;
#define adfDefFaxFileExt L"APF"
static const bool adfDefBlindDial = false;
static const bool adfDefDetectBusy = true;
static const bool adfDefToneDial = true;
static const System::Int8 adfDefDialWait = System::Int8(0x3c);
static const System::Int8 adfDefDialAttempts = System::Int8(0x3);
static const System::Int8 adfDefDialRetryWait = System::Int8(0x3c);
static const System::Int8 adfDefMaxSendCount = System::Int8(0x32);
static const System::Word adfDefBufferMinimum = System::Word(0x3e8);
static const TFaxNameMode adfDefFaxNameMode = (TFaxNameMode)(1);
#define adfDefDestinationDir L""
}	/* namespace Adfax */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFAX)
using namespace Adfax;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfaxHPP
