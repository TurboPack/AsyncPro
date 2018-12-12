// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdPager.pas' rev: 32.00 (Windows)

#ifndef AdpagerHPP
#define AdpagerHPP

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

namespace Adpager
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdAbstractPager;
class DELPHICLASS TApdPagerLog;
class DELPHICLASS TApdCustomModemPager;
class DELPHICLASS TApdTAPPager;
class DELPHICLASS TApdCustomINetPager;
class DELPHICLASS TApdSNPPPager;
//-- type declarations -------------------------------------------------------
typedef System::Word TTriggerHandle;

typedef System::AnsiString TCmdString;

class PASCALIMPLEMENTATION TApdAbstractPager : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	Adport::TApdCustomComPort* FPort;
	System::AnsiString FPagerID;
	System::Classes::TStrings* FMessage;
	TApdPagerLog* FPagerLog;
	bool FExitOnError;
	System::AnsiString FPageMode;
	System::AnsiString FFailReason;
	void __fastcall WriteToEventLog(const System::AnsiString S)/* overload */;
	void __fastcall WriteToEventLog(const System::UnicodeString S)/* overload */;
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Send(void) = 0 ;
	virtual void __fastcall SetMessage(System::Classes::TStrings* Msg);
	virtual void __fastcall SetPagerID(System::AnsiString ID);
	void __fastcall SetPagerLog(TApdPagerLog* const NewLog);
	__property System::Classes::TStrings* Message = {read=FMessage, write=SetMessage};
	__property System::AnsiString PagerID = {read=FPagerID, write=SetPagerID};
	__property TApdPagerLog* PagerLog = {read=FPagerLog, write=SetPagerLog};
	__property bool ExitOnError = {read=FExitOnError, write=FExitOnError, default=0};
	
public:
	__fastcall virtual TApdAbstractPager(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdAbstractPager(void);
};


class PASCALIMPLEMENTATION TApdPagerLog : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	System::AnsiString FHistoryName;
	TApdAbstractPager* FPager;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TApdPagerLog(System::Classes::TComponent* AOwner);
	virtual void __fastcall UpdateLog(const System::AnsiString LogStr);
	
__published:
	__property TApdAbstractPager* Pager = {read=FPager, write=FPager};
	__property System::AnsiString HistoryName = {read=FHistoryName, write=FHistoryName};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TApdPagerLog(void) { }
	
};


enum DECLSPEC_DENUM TDialingCondition : unsigned char { dsNone, dsOffHook, dsDialing, dsRinging, dsWaitForConnect, dsConnected, dsWaitingToRedial, dsRedialing, dsMsgNotSent, dsCancelling, dsDisconnect, dsCleanup, deNone, deNoDialTone, deLineBusy, deNoConnection };

typedef TDialingCondition TDialingStatus;

typedef void __fastcall (__closure *TDialStatusEvent)(System::TObject* Sender, TDialingStatus Event);

typedef TDialingCondition TDialError;

typedef void __fastcall (__closure *TDialErrorEvent)(System::TObject* Sender, TDialError Error);

class PASCALIMPLEMENTATION TApdCustomModemPager : public TApdAbstractPager
{
	typedef TApdAbstractPager inherited;
	
private:
	Adtapi::TApdTapiDevice* FTapiDev;
	bool mpGotOkay;
	bool FConnected;
	bool FSent;
	bool FAborted;
	bool Waiting;
	bool FCancelled;
	TDialingCondition FDialStatus;
	TDialingCondition FDialError;
	bool FDirectToPort;
	bool FAbortNoConnect;
	bool FBlindDial;
	bool FToneDial;
	System::Word FDialAttempt;
	System::Word FDialAttempts;
	System::Word FDialRetryWait;
	System::Word FDialWait;
	System::AnsiString FDialPrefix;
	System::AnsiString FModemHangup;
	System::AnsiString FModemInit;
	System::AnsiString FPhoneNumber;
	bool FUseTapi;
	System::Word OKTrig;
	System::Word ErrorTrig;
	System::Word ConnectTrig;
	System::Word BusyTrig;
	System::Word VoiceTrig;
	System::Word NoCarrierTrig;
	System::Word NoDialtoneTrig;
	TDialStatusEvent FOnDialStatus;
	TDialErrorEvent FOnDialError;
	void __fastcall AddInitModemDataTrigs(void);
	void __fastcall DoOpenPort(void);
	virtual void __fastcall DoDirect(void);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall DoCleanup(void);
	virtual void __fastcall DoDial(void);
	virtual void __fastcall DoStartCall(void);
	virtual void __fastcall TerminatePage(void);
	virtual void __fastcall DoFailedToSend(void);
	void __fastcall DoInitializePort(void);
	Adtapi::TApdTapiDevice* __fastcall GetTapiDev(void);
	__property Adtapi::TApdTapiDevice* TapiDev = {read=GetTapiDev};
	void __fastcall SetUseTapi(const bool Value);
	void __fastcall SetTapiDev(Adtapi::TApdTapiDevice* const Value);
	virtual void __fastcall InitProperties(void);
	virtual void __fastcall SetPortOpts(void);
	void __fastcall DoDialStatus(TDialingCondition Event);
	void __fastcall InitCallStateFlags(void);
	void __fastcall SetBlindDial(bool BlindDialVal);
	void __fastcall SetDialPrefix(System::AnsiString CmdStr);
	void __fastcall SetModemHangup(System::AnsiString CmdStr);
	void __fastcall SetModemInit(System::AnsiString CmdStr);
	Adport::TApdCustomComPort* __fastcall GetPort(void);
	virtual void __fastcall SetPort(Adport::TApdCustomComPort* ThePort);
	void __fastcall SetToneDial(bool ToneDial);
	
public:
	__fastcall virtual TApdCustomModemPager(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomModemPager(void);
	virtual void __fastcall Loaded(void);
	System::AnsiString __fastcall DialStatusMsg(TDialingCondition Status);
	__property Adport::TApdCustomComPort* Port = {read=GetPort, write=SetPort};
	__property bool AbortNoConnect = {read=FAbortNoConnect, write=FAbortNoConnect, default=0};
	__property bool BlindDial = {read=FBlindDial, write=SetBlindDial, default=0};
	__property System::Word DialAttempt = {read=FDialAttempt, write=FDialAttempt, nodefault};
	__property System::Word DialAttempts = {read=FDialAttempts, write=FDialAttempts, default=3};
	__property System::AnsiString DialPrefix = {read=FDialPrefix, write=SetDialPrefix};
	__property System::Word DialRetryWait = {read=FDialRetryWait, write=FDialRetryWait, default=30};
	__property System::Word DialWait = {read=FDialWait, write=FDialWait, default=60};
	__property System::AnsiString ModemHangup = {read=FModemHangup, write=SetModemHangup};
	__property System::AnsiString ModemInit = {read=FModemInit, write=SetModemInit};
	__property System::AnsiString PhoneNumber = {read=FPhoneNumber, write=FPhoneNumber};
	__property bool ToneDial = {read=FToneDial, write=SetToneDial, default=1};
	__property bool DirectToPort = {read=FDirectToPort, write=FDirectToPort, default=0};
	__property bool UseTapi = {read=FUseTapi, write=SetUseTapi, default=0};
	__property Adtapi::TApdTapiDevice* TapiDevice = {read=FTapiDev, write=SetTapiDev};
	__property TDialErrorEvent OnDialError = {read=FOnDialError, write=FOnDialError};
	__property TDialStatusEvent OnDialStatus = {read=FOnDialStatus, write=FOnDialStatus};
	virtual void __fastcall CancelCall(void);
};


enum DECLSPEC_DENUM TTapStatus : unsigned char { psNone, psLoginPrompt, psLoggedIn, psLoginErr, psLoginFail, psMsgOkToSend, psSendingMsg, psMsgAck, psMsgNak, psMsgRs, psMsgCompleted, psDone, psSendTimedOut };

typedef void __fastcall (__closure *TTAPStatusEvent)(System::TObject* Sender, TTapStatus Event);

typedef void __fastcall (__closure *TTapGetNextMessageEvent)(System::TObject* Sender, bool &DoneMessages);

class PASCALIMPLEMENTATION TApdTAPPager : public TApdCustomModemPager
{
	typedef TApdCustomModemPager inherited;
	
private:
	bool FUseEscapes;
	int FMaxMsgLen;
	System::AnsiString FPassword;
	System::Classes::TStrings* FBlocks;
	int FMsgIdx;
	System::Word FtrgIDPrompt;
	System::Word FtrgLoginSucc;
	System::Word FtrgLoginFail;
	System::Word FtrgLoginErr;
	System::Word FtrgOkToSend;
	System::Word FtrgMsgAck;
	System::Word FtrgMsgNak;
	System::Word FtrgMsgRs;
	System::Word FtrgSendTimer;
	System::Word FtrgDCon;
	Vcl::Extctrls::TTimer* tpPingTimer;
	int tpPingCount;
	int tpTAPRetries;
	int FTapWait;
	TTapStatus FPageStatus;
	System::Classes::TNotifyEvent FOnTAPFinish;
	TTAPStatusEvent FOnTAPStatus;
	TTapGetNextMessageEvent FOnGetNextMessage;
	void __fastcall PingTimerOnTimer(System::TObject* Sender);
	void __fastcall StartPingTimer(void);
	void __fastcall DonePingTimer(void);
	
protected:
	virtual void __fastcall DoDirect(void);
	void __fastcall DoTAPStatus(TTapStatus Status);
	virtual void __fastcall DoStartCall(void);
	virtual void __fastcall InitProperties(void);
	virtual void __fastcall SetPort(Adport::TApdCustomComPort* ThePort);
	virtual void __fastcall TerminatePage(void);
	void __fastcall DataTriggerHandler(unsigned Msg, unsigned wParam, int lParam);
	void __fastcall FreeLoginTriggers(void);
	void __fastcall FreeLogoutTriggers(void);
	void __fastcall FreeMsgTriggers(void);
	void __fastcall FreeResponseTriggers(void);
	System::AnsiString __fastcall HandleToTrigger(System::Word TriggerHandle);
	System::UnicodeString __fastcall HandleToTriggerUni(System::Word TriggerHandle);
	void __fastcall InitLoginTriggers(void);
	void __fastcall InitLogoutTriggers(void);
	void __fastcall InitMsgTriggers(void);
	void __fastcall DoCurMessageBlock(void);
	void __fastcall DoFirstMessageBlock(void);
	void __fastcall DoNextMessageBlock(void);
	
public:
	__fastcall virtual TApdTAPPager(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdTAPPager(void);
	virtual void __fastcall Send(void);
	void __fastcall ReSend(void);
	void __fastcall Disconnect(void);
	System::AnsiString __fastcall TAPStatusMsg(TTapStatus Status);
	
__published:
	__property Port;
	__property PagerID = {default=0};
	__property Message;
	__property PagerLog;
	__property AbortNoConnect = {default=0};
	__property BlindDial = {default=0};
	__property DialAttempt;
	__property DialAttempts = {default=3};
	__property DialPrefix = {default=0};
	__property DialRetryWait = {default=30};
	__property DialWait = {default=60};
	__property ExitOnError = {default=0};
	__property ModemHangup = {default=0};
	__property ModemInit = {default=0};
	__property PhoneNumber = {default=0};
	__property ToneDial = {default=1};
	__property DirectToPort = {default=0};
	__property TapiDevice;
	__property UseTapi = {default=0};
	__property System::AnsiString TapPassword = {read=FPassword, write=FPassword};
	__property int TapWait = {read=FTapWait, write=FTapWait, default=30};
	__property int MaxMessageLength = {read=FMaxMsgLen, write=FMaxMsgLen, default=80};
	__property bool UseEscapes = {read=FUseEscapes, write=FUseEscapes, default=0};
	__property OnDialError;
	__property OnDialStatus;
	__property System::Classes::TNotifyEvent OnTAPFinish = {read=FOnTAPFinish, write=FOnTAPFinish};
	__property TTAPStatusEvent OnTAPStatus = {read=FOnTAPStatus, write=FOnTAPStatus};
	__property TTapGetNextMessageEvent OnGetNextMessage = {read=FOnGetNextMessage, write=FOnGetNextMessage};
};


class PASCALIMPLEMENTATION TApdCustomINetPager : public TApdAbstractPager
{
	typedef TApdAbstractPager inherited;
	
protected:
	Adwnport::TApdWinsockPort* __fastcall GetPort(void);
	void __fastcall SetPort(Adwnport::TApdWinsockPort* ThePort);
	
public:
	__fastcall virtual TApdCustomINetPager(System::Classes::TComponent* AOwner);
	__property Adwnport::TApdWinsockPort* Port = {read=GetPort, write=SetPort};
public:
	/* TApdAbstractPager.Destroy */ inline __fastcall virtual ~TApdCustomINetPager(void) { }
	
};


typedef void __fastcall (__closure *TSNPPMessage)(System::TObject* Sender, int Code, System::AnsiString Msg);

class PASCALIMPLEMENTATION TApdSNPPPager : public TApdCustomINetPager
{
	typedef TApdCustomINetPager inherited;
	
private:
	bool FSent;
	bool FCancelled;
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
	System::AnsiString FServerInitString;
	System::AnsiString FServerDoneString;
	System::AnsiString FServerSuccStr;
	System::AnsiString FServerDataInp;
	System::AnsiString FServerRespFailCont;
	System::AnsiString FServerRespFailTerm;
	int FCommDelay;
	System::Classes::TNotifyEvent FOnLogin;
	System::Classes::TNotifyEvent FOnLogout;
	TSNPPMessage FOnSNPPSuccess;
	TSNPPMessage FOnSNPPError;
	void __fastcall FreePackets(void);
	void __fastcall InitPackets(void);
	void __fastcall DoLoginString(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoServerSucc(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoServerDataMsg(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoServerError(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoServerFatalError(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoLogoutString(System::TObject* Sender, System::AnsiString Data);
	void __fastcall PutString(System::AnsiString S);
	void __fastcall DoMultiLine(void);
	void __fastcall MakePacket(Adpacket::TApdDataPacket* ThePacket, System::AnsiString StartStr, System::AnsiString EndStr, Adpacket::TStringPacketNotifyEvent HandlerMethod);
	void __fastcall ReleasePacket(Adpacket::TApdDataPacket* &ThePacket);
	void __fastcall DoClose(void);
	void __fastcall DoStart(void);
	
public:
	virtual void __fastcall PutPagerID(void);
	virtual void __fastcall PutMessage(void);
	virtual void __fastcall PutSend(void);
	virtual void __fastcall PutQuit(void);
	virtual void __fastcall Send(void);
	__fastcall virtual TApdSNPPPager(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdSNPPPager(void);
	void __fastcall Quit(void);
	__property System::AnsiString ServerInitString = {read=FServerInitString, write=FServerInitString};
	__property System::AnsiString ServerSuccessString = {read=FServerSuccStr, write=FServerSuccStr};
	__property System::AnsiString ServerDataInput = {read=FServerDataInp, write=FServerDataInp};
	__property System::AnsiString ServerResponseFailContinue = {read=FServerRespFailCont, write=FServerRespFailCont};
	__property System::AnsiString ServerResponseFailTerminate = {read=FServerRespFailTerm, write=FServerRespFailTerm};
	__property System::AnsiString ServerDoneString = {read=FServerDoneString, write=FServerDoneString};
	
__published:
	__property PagerID = {default=0};
	__property Port;
	__property Message;
	__property ExitOnError = {default=0};
	__property PagerLog;
	__property int CommDelay = {read=FCommDelay, write=FCommDelay, default=0};
	__property System::Classes::TNotifyEvent OnLogin = {read=FOnLogin, write=FOnLogin};
	__property TSNPPMessage OnSNPPSuccess = {read=FOnSNPPSuccess, write=FOnSNPPSuccess};
	__property TSNPPMessage OnSNPPError = {read=FOnSNPPError, write=FOnSNPPError};
	__property System::Classes::TNotifyEvent OnLogout = {read=FOnLogout, write=FOnLogout};
};


//-- var, const, procedure ---------------------------------------------------
#define atpCRLF L"\r\n"
static const System::Int8 CmdLen = System::Int8(0x29);
static const System::Int8 MAX_MSG_LEN = System::Int8(0x50);
extern DELPHI_PACKAGE int STD_DELAY;
static const bool adpgDefAbortNoConnect = false;
static const bool adpgDefBlindDial = false;
static const bool adpgDefToneDial = true;
static const bool adpgDefExitOnError = false;
static const System::Int8 adpgDefDialAttempts = System::Int8(0x3);
static const System::Int8 adpgDefDialRetryWait = System::Int8(0x1e);
static const System::Int8 adpgDefDialWait = System::Int8(0x3c);
static const System::Word adpgDefTimerTrig = System::Word(0x438);
#define adpgPulseDialPrefix L"DP"
#define adpgToneDialPrefix L"DT"
#define adpgDefDialPrefix L"DT"
#define adpgDefModemInitCmd L"ATZ"
#define adpgDefNormalInit L"X4"
#define adpgDefBlindInit L"X3"
#define adpgDefNoDetectBusyInit L"X2"
#define adpgDefX1Init L"X1"
#define adpgDefInit L"X4"
#define adpgDefModemHangupCmd L"+++~~~ATH"
#define adpgDefPagerHistoryName L"APROPAGR.HIS"
static const System::Word TDS_NONE = System::Word(0x11f8);
static const System::Word TDS_OFFHOOK = System::Word(0x11f9);
static const System::Word TDS_DIALING = System::Word(0x11fa);
static const System::Word TDS_RINGING = System::Word(0x11fb);
static const System::Word TDS_WAITFORCONNECT = System::Word(0x11fc);
static const System::Word TDS_CONNECTED = System::Word(0x11fd);
static const System::Word TDS_WAITINGTOREDIAL = System::Word(0x11fe);
static const System::Word TDS_REDIALING = System::Word(0x11ff);
static const System::Word TDS_MSGNOTSENT = System::Word(0x1200);
static const System::Word TDS_CANCELLING = System::Word(0x1201);
static const System::Word TDS_DISCONNECT = System::Word(0x1202);
static const System::Word TDS_CLEANUP = System::Word(0x1203);
static const System::Word TDE_NONE = System::Word(0x1216);
static const System::Word TDE_NODIALTONE = System::Word(0x1217);
static const System::Word TDE_LINEBUSY = System::Word(0x1218);
static const System::Word TDE_NOCONNECTION = System::Word(0x1219);
static const System::Word TPS_NONE = System::Word(0x1234);
static const System::Word TPS_LOGINPROMPT = System::Word(0x1235);
static const System::Word TPS_LOGGEDIN = System::Word(0x1236);
static const System::Word TPS_LOGINERR = System::Word(0x1237);
static const System::Word TPS_LOGINFAIL = System::Word(0x1238);
static const System::Word TPS_MSGOKTOSEND = System::Word(0x1239);
static const System::Word TPS_SENDINGMSG = System::Word(0x123a);
static const System::Word TPS_MSGACK = System::Word(0x123b);
static const System::Word TPS_MSGNAK = System::Word(0x123c);
static const System::Word TPS_MSGRS = System::Word(0x123d);
static const System::Word TPS_MSGCOMPLETED = System::Word(0x123e);
static const System::Word TPS_DONE = System::Word(0x123f);
extern DELPHI_PACKAGE System::AnsiString FapOKTrig;
extern DELPHI_PACKAGE System::AnsiString FapErrorTrig;
extern DELPHI_PACKAGE System::AnsiString FapConnectTrig;
extern DELPHI_PACKAGE System::AnsiString FapBusyTrig;
extern DELPHI_PACKAGE System::AnsiString FapVoiceTrig;
extern DELPHI_PACKAGE System::AnsiString FapNoCarrierTrig;
extern DELPHI_PACKAGE System::AnsiString FapNoDialtoneTrig;
extern DELPHI_PACKAGE System::AnsiString TAP_ID_PROMPT;
extern DELPHI_PACKAGE System::AnsiString TAP_LOGIN_ACK;
extern DELPHI_PACKAGE System::AnsiString TAP_LOGIN_NAK;
extern DELPHI_PACKAGE System::AnsiString TAP_LOGIN_FAIL;
extern DELPHI_PACKAGE System::AnsiString TAP_MSG_OKTOSEND;
extern DELPHI_PACKAGE System::AnsiString TAP_MSG_ACK;
extern DELPHI_PACKAGE System::AnsiString TAP_MSG_NAK;
extern DELPHI_PACKAGE System::AnsiString TAP_MSG_RS;
extern DELPHI_PACKAGE System::AnsiString TAP_DISCONNECT;
extern DELPHI_PACKAGE System::AnsiString TAP_AUTO_LOGIN;
extern DELPHI_PACKAGE System::AnsiString TAP_LOGOUT;
static const System::Int8 MAX_TAP_RETRIES = System::Int8(0x3);
}	/* namespace Adpager */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADPAGER)
using namespace Adpager;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdpagerHPP
