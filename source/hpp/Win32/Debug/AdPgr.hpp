// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdPgr.pas' rev: 32.00 (Windows)

#ifndef AdpgrHPP
#define AdpgrHPP

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
#include <AdPort.hpp>
#include <AdExcept.hpp>
#include <AdTapi.hpp>
#include <AdTUtil.hpp>
#include <AdWnPort.hpp>
#include <AdPacket.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adpgr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdPgrLog;
class DELPHICLASS TApdCustomPager;
class DELPHICLASS TApdTapProperties;
class DELPHICLASS TApdPager;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TPortOpts : unsigned char { p7E1, p8N1, pCustom };

typedef System::Set<TPortOpts, TPortOpts::p7E1, TPortOpts::pCustom> TPortOptsSet;

enum DECLSPEC_DENUM TApdPagerMode : unsigned char { pmTAP, pmSNPP };

typedef System::Set<TApdPagerMode, TApdPagerMode::pmTAP, TApdPagerMode::pmSNPP> TPagerModeSet;

enum DECLSPEC_DENUM TPageStatus : unsigned char { psNone, psInitFail, psConnected, psLineBusy, psDisconnect, psNoDialtone, psMsgNotSent, psWaitingToRedial, psLoginPrompt, psLoggedIn, psDialing, psRedialing, psLoginRetry, psMsgOkToSend, psSendingMsg, psMsgAck, psMsgNak, psMsgRs, psMsgCompleted, psSendTimedOut, psLoggingOut, psDone };

typedef void __fastcall (__closure *TPageStatusEvent)(TApdCustomPager* Pager, TPageStatus Event, int Param1, int Param2);

typedef void __fastcall (__closure *TPageErrorEvent)(TApdCustomPager* Pager, int Code);

typedef void __fastcall (__closure *TPageFinishEvent)(TApdCustomPager* Pager, int Code, System::UnicodeString Msg);

typedef void __fastcall (__closure *TTapGetNextMessageEvent)(TApdCustomPager* Pager, bool &DoneMessages);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdPgrLog : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TApdCustomPager* FOwner;
	bool FVerboseLog;
	bool FEnabled;
	System::UnicodeString FLogName;
	
public:
	__fastcall TApdPgrLog(TApdCustomPager* Owner);
	void __fastcall AddLogString(bool Verbose, const System::UnicodeString StatusString);
	void __fastcall ClearLog(void);
	
__published:
	__property System::UnicodeString LogName = {read=FLogName, write=FLogName};
	__property bool VerboseLog = {read=FVerboseLog, write=FVerboseLog, nodefault};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TApdPgrLog(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdCustomPager : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	Adport::TApdCustomComPort* FPort;
	Adtapi::TApdTapiDevice* FTapiDevice;
	Oomisc::TTapiConfigRec FOrigTapiConfig;
	TApdPgrLog* FEventLog;
	System::UnicodeString FPagerID;
	System::Classes::TStrings* FMessage;
	bool FExitOnError;
	bool FUseEscapes;
	NativeUInt FHandle;
	bool mpGotOkay;
	bool FConnected;
	bool FSent;
	bool FAborted;
	bool FRedialFlag;
	bool FLoginRetry;
	bool FTerminating;
	bool FCancelled;
	bool FAbortNoConnect;
	bool FBlindDial;
	bool FToneDial;
	bool FTapHotLine;
	System::Word FDialAttempt;
	System::Word FDialAttempts;
	System::UnicodeString FDialPrefix;
	System::UnicodeString FModemHangup;
	System::UnicodeString FModemInit;
	System::UnicodeString FPhoneNumber;
	System::UnicodeString FTonePrefix;
	System::Word OKTrig;
	System::Word ErrorTrig;
	System::Word ConnectTrig;
	System::Word BusyTrig;
	System::Word NoCarrierTrig;
	System::Word NoDialtoneTrig;
	bool FOkayToSend;
	bool FSessionOpen;
	bool FQuit;
	bool FGotSuccess;
	Adpacket::TApdDataPacket* FLoginPacket;
	Adpacket::TApdDataPacket* FServerSuccPacket;
	Adpacket::TApdDataPacket* FServerDataMsgPacket;
	Adpacket::TApdDataPacket* FServerErrorPacket;
	Adpacket::TApdDataPacket* FServerFatalErrorPacket;
	Adpacket::TApdDataPacket* FServerDonePacket;
	System::UnicodeString FPassword;
	System::Classes::TStringList* FMsgBlockList;
	int FMsgIdx;
	System::Word FtrgIDPrompt;
	System::Word FtrgLoginSucc;
	System::Word FtrgLoginFail;
	System::Word FtrgLoginRetry;
	System::Word FtrgOkToSend;
	System::Word FtrgMsgAck;
	System::Word FtrgMsgNak;
	System::Word FtrgMsgRs;
	System::Word FtrgSendTimer;
	System::Word FtrgDCon;
	Vcl::Extctrls::TTimer* tpPingTimer;
	Vcl::Extctrls::TTimer* tpModemInitTimer;
	Vcl::Extctrls::TTimer* WaitTimer;
	int tpPingCount;
	int FTapWait;
	int TempWait;
	TPageFinishEvent FOnPageFinish;
	TPageStatusEvent FOnPageStatus;
	TPageErrorEvent FOnPageError;
	TTapGetNextMessageEvent FOnGetNextMessage;
	System::UnicodeString FServerInitString;
	System::UnicodeString FServerDoneString;
	System::UnicodeString FServerSuccStr;
	System::UnicodeString FServerDataInp;
	System::UnicodeString FServerRespFailCont;
	System::UnicodeString FServerRespFailTerm;
	int FCommDelay;
	int FMaxMessageLength;
	TApdPagerMode FPagerMode;
	TPortOpts FPortOpts;
	bool FPortOpenedByUser;
	System::UnicodeString FPageMode;
	System::UnicodeString FLogName;
	void __fastcall DoDial(void);
	void __fastcall DoInitializePort(void);
	void __fastcall DoPortOpenCloseEx(System::TObject* CP, Adport::TApdCallbackType CallbackType);
	void __fastcall InitCallStateFlags(void);
	void __fastcall SetUseEscapes(bool UseEscapesVal);
	void __fastcall AddInitModemDataTrigs(void);
	void __fastcall SetPortOpts(void);
	void __fastcall DoOpenPort(void);
	void __fastcall BuildTapMessages(void);
	void __fastcall ModemInitTimerOnTimer(System::TObject* Sender);
	void __fastcall PingTimerOnTimer(System::TObject* Sender);
	void __fastcall WaitTimerOnTimer(System::TObject* Sender);
	void __fastcall DoneModemInitTimer(void);
	void __fastcall DonePingTimer(void);
	void __fastcall FreeTrigger(Adport::TApdCustomComPort* Port, System::Word &Trigger);
	void __fastcall FreePackets(void);
	void __fastcall InitPackets(void);
	void __fastcall DoLoginString(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoServerSucc(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoServerDataMsg(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoServerError(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoServerFatalError(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoLogoutString(System::TObject* Sender, System::AnsiString Data);
	void __fastcall PutString(const System::AnsiString S);
	void __fastcall DoMultiLine(void);
	void __fastcall MakePacket(Adpacket::TApdDataPacket* ThePacket, System::UnicodeString StartStr, System::UnicodeString EndStr, Adpacket::TStringPacketNotifyEvent HandlerMethod);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetMessage(System::Classes::TStrings* Msg);
	void __fastcall SetPagerID(System::UnicodeString ID);
	void __fastcall DoPageStatus(TPageStatus Status);
	void __fastcall DoPageError(int Error);
	__property NativeUInt Handle = {read=FHandle, nodefault};
	void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	void __fastcall DoStartCall(void);
	void __fastcall TerminatePage(void);
	void __fastcall DoFailedToSend(void);
	void __fastcall LogOutTAP(void);
	void __fastcall DataTriggerHandler(unsigned Msg, unsigned wParam, int lParam);
	void __fastcall DoPageStatusTrig(unsigned Trig);
	void __fastcall FreeLoginTriggers(void);
	void __fastcall FreeLogoutTriggers(void);
	void __fastcall FreeMsgTriggers(void);
	void __fastcall FreeResponseTriggers(void);
	void __fastcall InitLoginTriggers(void);
	void __fastcall InitLogoutTriggers(void);
	void __fastcall InitMsgTriggers(void);
	void __fastcall DoCurMessageBlock(void);
	void __fastcall DoFirstMessageBlock(void);
	void __fastcall DoNextMessageBlock(void);
	__property System::UnicodeString ServerInitString = {read=FServerInitString, write=FServerInitString};
	__property System::UnicodeString ServerSuccessString = {read=FServerSuccStr, write=FServerSuccStr};
	__property System::UnicodeString ServerDataInput = {read=FServerDataInp, write=FServerDataInp};
	__property System::UnicodeString ServerResponseFailContinue = {read=FServerRespFailCont, write=FServerRespFailCont};
	__property System::UnicodeString ServerResponseFailTerminate = {read=FServerRespFailTerm, write=FServerRespFailTerm};
	__property System::UnicodeString ServerDoneString = {read=FServerDoneString, write=FServerDoneString};
	virtual void __fastcall PutMessage(void);
	virtual void __fastcall PutSend(void);
	virtual void __fastcall PutQuit(void);
	
public:
	__property System::Classes::TStrings* Message = {read=FMessage, write=SetMessage};
	__property System::UnicodeString PagerID = {read=FPagerID, write=SetPagerID};
	__property bool ExitOnError = {read=FExitOnError, write=FExitOnError, nodefault};
	__property bool UseEscapes = {read=FUseEscapes, write=SetUseEscapes, nodefault};
	__property Adport::TApdCustomComPort* Port = {read=FPort, write=FPort};
	__property Adtapi::TApdTapiDevice* TapiDevice = {read=FTapiDevice, write=FTapiDevice};
	__property TApdPagerMode PagerMode = {read=FPagerMode, write=FPagerMode, nodefault};
	__property TPortOpts PortOpts = {read=FPortOpts, write=FPortOpts, nodefault};
	__property bool AbortNoConnect = {read=FAbortNoConnect, write=FAbortNoConnect, nodefault};
	__property System::UnicodeString LogName = {read=FLogName, write=FLogName};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__fastcall virtual TApdCustomPager(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomPager(void);
	void __fastcall Send(void);
	void __fastcall Disconnect(void);
	void __fastcall CancelCall(void);
	__property System::Word DialAttempts = {read=FDialAttempts, write=FDialAttempts, nodefault};
	__property System::UnicodeString PhoneNumber = {read=FPhoneNumber, write=FPhoneNumber};
	__property bool ToneDial = {read=FToneDial, write=FToneDial, nodefault};
	__property System::UnicodeString ModemInit = {read=FModemInit, write=FModemInit};
	__property System::UnicodeString ModemHangup = {read=FModemHangup, write=FModemHangup};
	__property bool TapHotLine = {read=FTapHotLine, write=FTapHotLine, nodefault};
	__property System::UnicodeString DialPrefix = {read=FDialPrefix, write=FDialPrefix};
	__property bool BlindDial = {read=FBlindDial, write=FBlindDial, nodefault};
	__property int TapWait = {read=FTapWait, write=FTapWait, nodefault};
	__property int MaxMessageLength = {read=FMaxMessageLength, write=FMaxMessageLength, nodefault};
	void __fastcall Quit(void);
	__property TApdPgrLog* EventLog = {read=FEventLog, write=FEventLog};
	__property TPageStatusEvent OnPageStatus = {read=FOnPageStatus, write=FOnPageStatus};
	__property TPageFinishEvent OnPageFinish = {read=FOnPageFinish, write=FOnPageFinish};
	__property TPageErrorEvent OnPageError = {read=FOnPageError, write=FOnPageError};
	__property TTapGetNextMessageEvent OnGetNextMessage = {read=FOnGetNextMessage, write=FOnGetNextMessage};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdTapProperties : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TApdCustomPager* FOwner;
	int __fastcall GetTapWait(void);
	void __fastcall SetTapWait(const int Value);
	Adtapi::TApdTapiDevice* __fastcall GetTapiDevice(void);
	void __fastcall SetTapiDevice(Adtapi::TApdTapiDevice* const Value);
	System::UnicodeString __fastcall GetModemInit(void);
	void __fastcall SetModemInit(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetModemHangup(void);
	void __fastcall SetModemHangup(const System::UnicodeString Value);
	System::Word __fastcall GetDialAttempts(void);
	void __fastcall SetDialAttempts(const System::Word Value);
	System::UnicodeString __fastcall GetDialPrefix(void);
	void __fastcall SetDialPrefix(const System::UnicodeString Value);
	bool __fastcall GetTapHotLine(void);
	void __fastcall SetTapHotLine(const bool Value);
	bool __fastcall GetBlindDial(void);
	void __fastcall SetBlindDial(const bool Value);
	bool __fastcall GetToneDial(void);
	void __fastcall SetToneDial(const bool Value);
	int __fastcall GetMaxMessageLength(void);
	void __fastcall SetMaxMessageLength(const int Value);
	TPortOpts __fastcall GetPortOpts(void);
	void __fastcall SetPortOpts(const TPortOpts Value);
	
public:
	__fastcall TApdTapProperties(TApdCustomPager* Owner);
	
__published:
	__property int TapWait = {read=GetTapWait, write=SetTapWait, nodefault};
	__property System::Word DialAttempts = {read=GetDialAttempts, write=SetDialAttempts, nodefault};
	__property System::UnicodeString DialPrefix = {read=GetDialPrefix, write=SetDialPrefix};
	__property int MaxMessageLength = {read=GetMaxMessageLength, write=SetMaxMessageLength, nodefault};
	__property bool TapHotLine = {read=GetTapHotLine, write=SetTapHotLine, nodefault};
	__property bool BlindDial = {read=GetBlindDial, write=SetBlindDial, nodefault};
	__property bool ToneDial = {read=GetToneDial, write=SetToneDial, nodefault};
	__property Adtapi::TApdTapiDevice* TapiDevice = {read=GetTapiDevice, write=SetTapiDevice};
	__property System::UnicodeString ModemHangup = {read=GetModemHangup, write=SetModemHangup};
	__property System::UnicodeString ModemInit = {read=GetModemInit, write=SetModemInit};
	__property TPortOpts PortOpts = {read=GetPortOpts, write=SetPortOpts, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TApdTapProperties(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdPager : public TApdCustomPager
{
	typedef TApdCustomPager inherited;
	
private:
	TApdTapProperties* FTapProperties;
	
public:
	__fastcall virtual TApdPager(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdPager(void);
	
__published:
	__property Port;
	__property PagerID = {default=0};
	__property EventLog;
	__property Message;
	__property ExitOnError;
	__property Name = {default=0};
	__property Password = {default=0};
	__property PagerMode;
	__property UseEscapes;
	__property TApdTapProperties* TapProperties = {read=FTapProperties, write=FTapProperties};
	__property OnPageError;
	__property OnPageStatus;
	__property OnPageFinish;
	__property OnGetNextMessage;
};


//-- var, const, procedure ---------------------------------------------------
#define atpCRLF L"\r\n"
static const System::Int8 MAX_MSG_LEN = System::Int8(0x50);
extern DELPHI_PACKAGE int STD_DELAY;
static const bool adpgDefAbortNoConnect = false;
static const bool adpgDefBlindDial = false;
static const bool adpgDefToneDial = true;
static const bool adpgDefExitOnError = false;
static const bool adpgDefUseEscapes = false;
static const System::Int8 adpgDefDialAttempts = System::Int8(0x3);
static const System::Int8 adpgDefDialRetryWait = System::Int8(0x1e);
static const System::Word adpgDefTimerTrig = System::Word(0x438);
static const TApdPagerMode adpgDefPagerMode = (TApdPagerMode)(0);
static const TPortOpts adpgDefPortOpts = (TPortOpts)(0);
#define adpgPulseDialPrefix L"DP"
#define adpgToneDialPrefix L"DT"
#define adpgDefModemInitCmd L"ATZ"
#define adpgDefModemHangupCmd L"+++~~~ATH"
extern DELPHI_PACKAGE System::UnicodeString FapOKTrig;
extern DELPHI_PACKAGE System::UnicodeString FapErrorTrig;
extern DELPHI_PACKAGE System::UnicodeString FapConnectTrig;
extern DELPHI_PACKAGE System::UnicodeString FapBusyTrig;
extern DELPHI_PACKAGE System::UnicodeString FapNoCarrierTrig;
extern DELPHI_PACKAGE System::UnicodeString FapNoDialtoneTrig;
}	/* namespace Adpgr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADPGR)
using namespace Adpgr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdpgrHPP
