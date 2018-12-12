// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdMdm.pas' rev: 32.00 (Windows)

#ifndef AdmdmHPP
#define AdmdmHPP

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
#include <OoMisc.hpp>
#include <AdPort.hpp>
#include <AdPacket.hpp>
#include <AdLibMdm.hpp>
#include <AdExcept.hpp>
#include <Vcl.FileCtrl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Admdm
{
//-- forward type declarations -----------------------------------------------
struct TApdModemConfig;
class DELPHICLASS TApdModemNameProp;
struct TApdCallerIDInfo;
class DELPHICLASS TAdCustomModem;
class DELPHICLASS TAdModem;
class DELPHICLASS TAdAbstractModemStatus;
class DELPHICLASS TAdModemStatus;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TApdModemState : unsigned char { msUnknown, msIdle, msInitializing, msAutoAnswerBackground, msAutoAnswerWait, msAnswerWait, msDial, msConnectWait, msConnected, msHangup, msCancel };

enum DECLSPEC_DENUM TApdModemLogCode : unsigned char { mlNone, mlDial, mlAutoAnswer, mlAnswer, mlConnect, mlCancel, mlBusy, mlConnectFail };

enum DECLSPEC_DENUM TApdModemStatusAction : unsigned char { msaStart, msaClose, msaUpdate, msaDetailReplace, msaClear };

enum DECLSPEC_DENUM TApdModemSpeakerVolume : unsigned char { svLow, svMed, svHigh };

enum DECLSPEC_DENUM TApdModemSpeakerMode : unsigned char { smOff, smOn, smDial };

enum DECLSPEC_DENUM TApdModemFlowControl : unsigned char { fcOff, fcHard, fcSoft };

enum DECLSPEC_DENUM TApdModemErrorControl : unsigned char { ecOff, ecOn, ecForced, ecCellular };

enum DECLSPEC_DENUM TApdModemModulation : unsigned char { smBell, smCCITT, smCCITT_V23 };

struct DECLSPEC_DRECORD TApdModemConfig
{
public:
	System::SmallString<8> ConfigVersion;
	System::SmallString<20> AttachedTo;
	System::SmallString<100> Manufacturer;
	System::SmallString<100> ModemName;
	System::SmallString<100> ModemModel;
	System::Word DataBits;
	Adport::TParity Parity;
	System::Word StopBits;
	TApdModemSpeakerVolume SpeakerVolume;
	TApdModemSpeakerMode SpeakerMode;
	TApdModemFlowControl FlowControl;
	System::Set<TApdModemErrorControl, TApdModemErrorControl::ecOff, TApdModemErrorControl::ecCellular> ErrorControl;
	bool Compression;
	TApdModemModulation Modulation;
	bool ToneDial;
	bool BlindDial;
	int CallSetupFailTimeout;
	int InactivityTimeout;
	System::SmallString<50> ExtraSettings;
	System::StaticArray<System::Byte, 48> Padding;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdModemNameProp : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FManufacturer;
	System::UnicodeString FName;
	System::UnicodeString FModemFile;
	void __fastcall SetManufacturer(const System::UnicodeString Value);
	void __fastcall SetName(const System::UnicodeString Value);
	void __fastcall SetModemFile(const System::UnicodeString Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall Clear(void);
	
__published:
	__property System::UnicodeString Manufacturer = {read=FManufacturer, write=SetManufacturer};
	__property System::UnicodeString Name = {read=FName, write=SetName};
	__property System::UnicodeString ModemFile = {read=FModemFile, write=SetModemFile};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TApdModemNameProp(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TApdModemNameProp(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TApdCallerIDInfo
{
public:
	bool HasData;
	System::UnicodeString Date;
	System::UnicodeString Time;
	System::UnicodeString Number;
	System::UnicodeString Name;
	System::UnicodeString Msg;
};


typedef void __fastcall (__closure *TModemCallerIDEvent)(TAdCustomModem* Modem, const TApdCallerIDInfo &CallerID);

typedef void __fastcall (__closure *TModemNotifyEvent)(TAdCustomModem* Modem);

typedef void __fastcall (__closure *TModemFailEvent)(TAdCustomModem* Modem, int FailCode);

typedef void __fastcall (__closure *TModemLogEvent)(TAdCustomModem* Modem, TApdModemLogCode LogCode);

typedef void __fastcall (__closure *TModemStatusEvent)(TAdCustomModem* Modem, TApdModemState ModemState);

class PASCALIMPLEMENTATION TAdCustomModem : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	int FAnswerOnRing;
	unsigned FBPSRate;
	Adport::TApdCustomComPort* FComPort;
	int FDialTimeout;
	int FFailCode;
	System::UnicodeString FModemCapFolder;
	unsigned FRingWaitTimeout;
	int FRingCount;
	TAdAbstractModemStatus* FStatusDisplay;
	TApdModemNameProp* FSelectedDevice;
	TApdModemState FModemState;
	System::Classes::TStringList* FNegotiationResponses;
	TModemCallerIDEvent FOnModemCallerID;
	TModemLogEvent FOnModemLog;
	TModemNotifyEvent FOnModemDisconnect;
	TModemNotifyEvent FOnModemConnect;
	TModemFailEvent FOnModemFail;
	TModemStatusEvent FOnModemStatus;
	bool FConnected;
	System::UnicodeString FPhoneNumber;
	unsigned FStartTime;
	bool FDeviceSelected;
	TApdModemConfig FModemConfig;
	TApdCallerIDInfo FCallerIDInfo;
	NativeUInt FHandle;
	System::Byte FPortWasOpen;
	Adport::TTriggerEvent FSavedOnTrigger;
	unsigned __fastcall GetElapsedTime(void);
	System::Classes::TStringList* __fastcall GetNegotiationResponses(void);
	void __fastcall SetAnswerOnRing(const int Value);
	void __fastcall SetComPort(Adport::TApdCustomComPort* const Value);
	void __fastcall SetDialTimeout(const int Value);
	void __fastcall SetModemCapFolder(const System::UnicodeString Value);
	void __fastcall SetRingWaitTimeout(const unsigned Value);
	void __fastcall SetSelectedDevice(TApdModemNameProp* const Value);
	void __fastcall SetStatusDisplay(TAdAbstractModemStatus* const Value);
	bool __fastcall GetDeviceSelected(void);
	void __fastcall PortOpenCloseEx(System::TObject* CP, Adport::TApdCallbackType CallbackType);
	
protected:
	Adpacket::TApdDataPacket* ResponsePacket;
	bool Initialized;
	bool PassthroughMode;
	bool WaitingForResponse;
	bool OKResponse;
	bool ErrorResponse;
	bool ConnectResponse;
	bool TimedOut;
	System::UnicodeString LastCommand;
	System::Word DcdTrigger;
	System::Word StatusTimerTrigger;
	bool FCallerIDProvided;
	void __fastcall CheckReady(void);
	void __fastcall DoCallerID(void);
	void __fastcall DoConnect(void);
	void __fastcall DoDisconnect(void);
	void __fastcall DoFail(int Failure);
	void __fastcall DoLog(TApdModemLogCode LogCode);
	void __fastcall DoStatus(TApdModemState NewModemState);
	void __fastcall Initialize(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall ModemMessage(Winapi::Messages::TMessage &Message);
	void __fastcall PrepForConnect(bool EnableTriggers);
	void __fastcall ResponseStringPacket(System::TObject* Sender, System::AnsiString Data);
	void __fastcall ResponseTimeout(System::TObject* Sender);
	void __fastcall TriggerEvent(System::TObject* CP, System::Word Msg, System::Word TriggerHandle, System::Word Data);
	bool __fastcall SendCommands(System::Classes::TList* Commands);
	bool __fastcall CheckResponses(const System::UnicodeString Response, const System::UnicodeString DefResponse, System::Classes::TList* Responses);
	int __fastcall CheckErrors(const System::UnicodeString Response);
	void __fastcall CheckCallerID(const System::UnicodeString Response);
	bool __fastcall ParseStandardConnect(const System::UnicodeString Response);
	void __fastcall ChangeResponseTimeout(int aTimeout, int aEnableTimeout);
	
public:
	Adlibmdm::TLmModem LmModem;
	Adlibmdm::TApdLibModem* LibModem;
	__fastcall virtual TAdCustomModem(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TAdCustomModem(void);
	__property int AnswerOnRing = {read=FAnswerOnRing, write=SetAnswerOnRing, default=2};
	__property unsigned BPSRate = {read=FBPSRate, nodefault};
	__property TApdCallerIDInfo CallerIDInfo = {read=FCallerIDInfo, write=FCallerIDInfo};
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=SetComPort};
	__property bool Connected = {read=FConnected, nodefault};
	__property bool DeviceSelected = {read=GetDeviceSelected, nodefault};
	__property int DialTimeout = {read=FDialTimeout, write=SetDialTimeout, default=60};
	__property unsigned ElapsedTime = {read=GetElapsedTime, nodefault};
	__property int FailureCode = {read=FFailCode, nodefault};
	__property NativeUInt Handle = {read=FHandle, nodefault};
	__property System::UnicodeString ModemCapFolder = {read=FModemCapFolder, write=SetModemCapFolder};
	__property TApdModemState ModemState = {read=FModemState, nodefault};
	__property System::Classes::TStringList* NegotiationResponses = {read=GetNegotiationResponses};
	__property System::UnicodeString PhoneNumber = {read=FPhoneNumber};
	__property int RingCount = {read=FRingCount, nodefault};
	__property unsigned RingWaitTimeout = {read=FRingWaitTimeout, write=SetRingWaitTimeout, default=1200};
	__property TApdModemNameProp* SelectedDevice = {read=FSelectedDevice, write=SetSelectedDevice};
	__property TAdAbstractModemStatus* StatusDisplay = {read=FStatusDisplay, write=SetStatusDisplay};
	void __fastcall AutoAnswer(void);
	void __fastcall CancelCall(void);
	void __fastcall ConfigAndOpen(void);
	TApdModemConfig __fastcall DefaultDeviceConfig(void);
	void __fastcall Dial(const System::UnicodeString ANumber);
	System::UnicodeString __fastcall FailureCodeMsg(const int FailureCode);
	TApdModemConfig __fastcall GetDevConfig(void);
	System::UnicodeString __fastcall ModemLogToString(TApdModemLogCode LogCode);
	System::UnicodeString __fastcall ModemStatusMsg(TApdModemState Status);
	bool __fastcall SelectDevice(void);
	bool __fastcall SendCommand(const System::UnicodeString Command);
	void __fastcall SetDevConfig(const TApdModemConfig &Config);
	bool __fastcall ShowConfigDialog(void);
	System::UnicodeString __fastcall ConvertXML(const System::UnicodeString S);
	System::UnicodeString __fastcall StripXML(const System::UnicodeString S);
	__property TModemCallerIDEvent OnModemCallerID = {read=FOnModemCallerID, write=FOnModemCallerID};
	__property TModemNotifyEvent OnModemConnect = {read=FOnModemConnect, write=FOnModemConnect};
	__property TModemNotifyEvent OnModemDisconnect = {read=FOnModemDisconnect, write=FOnModemDisconnect};
	__property TModemFailEvent OnModemFail = {read=FOnModemFail, write=FOnModemFail};
	__property TModemLogEvent OnModemLog = {read=FOnModemLog, write=FOnModemLog};
	__property TModemStatusEvent OnModemStatus = {read=FOnModemStatus, write=FOnModemStatus};
};


class PASCALIMPLEMENTATION TAdModem : public TAdCustomModem
{
	typedef TAdCustomModem inherited;
	
__published:
	__property AnswerOnRing = {default=2};
	__property ComPort;
	__property DialTimeout = {default=60};
	__property ModemCapFolder = {default=0};
	__property RingWaitTimeout = {default=1200};
	__property SelectedDevice;
	__property StatusDisplay;
	__property OnModemCallerID;
	__property OnModemConnect;
	__property OnModemDisconnect;
	__property OnModemFail;
	__property OnModemLog;
	__property OnModemStatus;
public:
	/* TAdCustomModem.Create */ inline __fastcall virtual TAdModem(System::Classes::TComponent* AOwner) : TAdCustomModem(AOwner) { }
	/* TAdCustomModem.Destroy */ inline __fastcall virtual ~TAdModem(void) { }
	
};


class PASCALIMPLEMENTATION TAdAbstractModemStatus : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	Vcl::Forms::TForm* FStatusDialog;
	System::UnicodeString FCaption;
	bool FStarted;
	TAdCustomModem* FModem;
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetStarted(bool Start);
	void __fastcall SetModem(TAdCustomModem* const Value);
	
public:
	__fastcall virtual TAdAbstractModemStatus(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TAdAbstractModemStatus(void);
	__property Vcl::Forms::TForm* StatusDialog = {read=FStatusDialog, write=FStatusDialog};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property TAdCustomModem* Modem = {read=FModem, write=SetModem};
	__property bool Started = {read=FStarted, nodefault};
	void __fastcall UpdateDisplay(TAdCustomModem* Modem, const System::UnicodeString StatusStr, const System::UnicodeString TimeStr, const System::UnicodeString DetailStr, TApdModemStatusAction Action);
};


class PASCALIMPLEMENTATION TAdModemStatus : public TAdAbstractModemStatus
{
	typedef TAdAbstractModemStatus inherited;
	
__published:
	__property Caption = {default=0};
	__property Modem;
public:
	/* TAdAbstractModemStatus.Create */ inline __fastcall virtual TAdModemStatus(System::Classes::TComponent* AOwner) : TAdAbstractModemStatus(AOwner) { }
	/* TAdAbstractModemStatus.Destroy */ inline __fastcall virtual ~TAdModemStatus(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define ApxDefModemCapFolder L""
#define ApxDefModemStatusCaption L"Modem status"
#define ApxDefOKResponse L"OK\r\n"
#define ApxDefErrorResponse L"ERROR\r\n"
#define ApxDefBusyResponse L"BUSY\r\n"
#define ApxDefConnectResponse L"CONNECT"
#define ApxDefRingResponse L"RING\r\n"
#define ApxDefModemEscape L"+++"
#define ApxDefAnswerCommand L"ATA\r"
#define ApxDefHangupCmd L"ATH0\r"
static const System::Word ApxDefCommandTimeout = System::Word(0x7530);
static const System::Word ApxDefConnectTimeout = System::Word(0xea60);
static const System::Word ApxDefDTRTimeout = System::Word(0x3e8);
#define ApxModemConfigVersion L"1.00"
}	/* namespace Admdm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADMDM)
using namespace Admdm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdmdmHPP
