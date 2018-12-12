// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'adgsm.pas' rev: 32.00 (Windows)

#ifndef AdgsmHPP
#define AdgsmHPP

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
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <OoMisc.hpp>
#include <AdPort.hpp>
#include <AdPacket.hpp>
#include <AdExcept.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adgsm
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdSMSMessage;
class DELPHICLASS TApdMessageStore;
class DELPHICLASS TApdCustomGSMPhone;
class DELPHICLASS TApdGSMPhone;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TGSMStates : unsigned char { gsNone, gsConfig, gsSendAll, gsListAll, gsSend, gsSendFStore, gsWrite, gsDelete, gsNofify };

enum DECLSPEC_DENUM TApdSMSStatus : unsigned char { srUnread, srRead, ssUnsent, ssSent, ssAll, ssUnknown };

enum DECLSPEC_DENUM TGSMMode : unsigned char { gmDetect, gmPDU, gmText };

typedef System::Set<TGSMMode, TGSMMode::gmDetect, TGSMMode::gmText> TGSMModeSet;

typedef void __fastcall (__closure *TApdGSMNextMessageEvent)(TApdCustomGSMPhone* Pager, int ErrorCode, bool &NextMessageReady);

typedef void __fastcall (__closure *TApdGSMNewMessageEvent)(TApdCustomGSMPhone* Pager, int FIndex, System::UnicodeString Message);

typedef void __fastcall (__closure *TApdGSMMessageListEvent)(System::TObject* Sender);

typedef void __fastcall (__closure *TApdGSMCompleteEvent)(TApdCustomGSMPhone* Pager, TGSMStates State, int ErrorCode);

class PASCALIMPLEMENTATION TApdSMSMessage : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FMessageIndex;
	System::UnicodeString FAddress;
	System::UnicodeString FMessage;
	System::UnicodeString FName;
	TApdSMSStatus FStatus;
	System::UnicodeString FTimeStampStr;
	System::TDateTime FTimeStamp;
	
protected:
	System::AnsiString __fastcall GetMessageAsPDU(void);
	void __fastcall SetMessageAsPDU(System::AnsiString v);
	
public:
	__property System::UnicodeString Address = {read=FAddress, write=FAddress};
	__property System::UnicodeString Message = {read=FMessage, write=FMessage};
	__property System::AnsiString MessageAsPDU = {read=GetMessageAsPDU, write=SetMessageAsPDU};
	__property int MessageIndex = {read=FMessageIndex, write=FMessageIndex, nodefault};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property TApdSMSStatus Status = {read=FStatus, write=FStatus, nodefault};
	__property System::TDateTime TimeStamp = {read=FTimeStamp, write=FTimeStamp};
	__property System::UnicodeString TimeStampStr = {read=FTimeStampStr, write=FTimeStampStr};
public:
	/* TObject.Create */ inline __fastcall TApdSMSMessage(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TApdSMSMessage(void) { }
	
};


class PASCALIMPLEMENTATION TApdMessageStore : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
public:
	TApdSMSMessage* operator[](int Index) { return this->Messages[Index]; }
	
private:
	int FCapacity;
	TApdCustomGSMPhone* FGSMPhone;
	TApdSMSMessage* __fastcall GetMessage(int Index);
	void __fastcall SetMessage(int Index, TApdSMSMessage* const Value);
	void __fastcall SetMSCapacity(const int Value);
	
protected:
	bool JustClearStore;
	virtual int __fastcall GetCapacity(void);
	void __fastcall ClearStore(void);
	
public:
	__fastcall TApdMessageStore(TApdCustomGSMPhone* GSMPhone);
	int __fastcall AddMessage(const System::UnicodeString Dest, const System::UnicodeString Msg);
	virtual void __fastcall Clear(void);
	virtual void __fastcall Delete(int PhoneIndex);
	__property TApdSMSMessage* Messages[int Index] = {read=GetMessage, write=SetMessage/*, default*/};
	__property int Capacity = {read=FCapacity, write=SetMSCapacity, nodefault};
public:
	/* TStringList.Destroy */ inline __fastcall virtual ~TApdMessageStore(void) { }
	
};


class PASCALIMPLEMENTATION TApdCustomGSMPhone : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	TApdGSMNewMessageEvent FOnNewMessage;
	TApdGSMNextMessageEvent FOnNextMessage;
	TApdGSMMessageListEvent FOnMessageList;
	TApdGSMCompleteEvent FOnGSMComplete;
	Adport::TApdCustomComPort* FComPort;
	int FNeedNewMessage;
	System::UnicodeString FRecNewMess;
	bool FConnected;
	int FErrorCode;
	TGSMStates FGSMState;
	TGSMMode FGSMMode;
	NativeUInt FHandle;
	System::UnicodeString FMessage;
	TApdMessageStore* FMessageStore;
	bool FNotifyOnNewMessage;
	bool FQueryModemOnly;
	bool FQuickConnect;
	bool FConfigList;
	System::UnicodeString FSMSAddress;
	System::UnicodeString FSMSCenter;
	System::AnsiString FTempWriteMess;
	bool FPDUMode;
	Adpacket::TApdDataPacket* ResponsePacket;
	Adpacket::TApdDataPacket* ErrorPacket;
	Adpacket::TApdDataPacket* NotifyPacket;
	TApdSMSMessage* TempSMSMessage;
	void __fastcall SetMessage(const System::UnicodeString Value);
	void __fastcall SetCenter(const System::UnicodeString Value);
	void __fastcall SetNotifyOnNewMessage(const bool Value);
	void __fastcall SetGSMMode(const TGSMMode NewMode);
	
protected:
	int CmdIndex;
	System::AnsiString ResponseStr;
	System::AnsiString NotifyStr;
	TGSMModeSet FSupportedGSMModes;
	void __fastcall CheckPort(void);
	void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall ResponseStringPacket(System::TObject* Sender, System::AnsiString Data);
	void __fastcall NotifyStringPacket(System::TObject* Sender, System::AnsiString Data);
	void __fastcall SetPDUMode(bool v);
	TGSMMode __fastcall GetGSMMode(void);
	void __fastcall ErrorStringPacket(System::TObject* Sender, System::AnsiString Data);
	void __fastcall DoFail(const System::UnicodeString Msg, const int ErrCode);
	void __fastcall DeleteFromMemoryIndex(int PhoneIndex);
	__property NativeUInt Handle = {read=FHandle, nodefault};
	void __fastcall SetState(TGSMStates NewState);
	
public:
	__fastcall virtual TApdCustomGSMPhone(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomGSMPhone(void);
	void __fastcall SendMessage(void);
	void __fastcall SendAllMessages(void);
	void __fastcall ListAllMessages(void);
	void __fastcall Connect(void);
	void __fastcall SendFromMemory(int TheIndex);
	void __fastcall WriteToMemory(const System::AnsiString Dest, const System::AnsiString Msg);
	void __fastcall ProcessResponse(void);
	void __fastcall Synchronize(void);
	void __fastcall QueryModem(void);
	System::AnsiString __fastcall StatusToStr(TApdSMSStatus StatusString);
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=FComPort};
	__property System::UnicodeString SMSAddress = {read=FSMSAddress, write=FSMSAddress};
	__property System::UnicodeString SMSMessage = {read=FMessage, write=SetMessage};
	__property System::UnicodeString SMSCenter = {read=FSMSCenter, write=SetCenter};
	__property bool NotifyOnNewMessage = {read=FNotifyOnNewMessage, write=SetNotifyOnNewMessage, default=0};
	__property TApdMessageStore* MessageStore = {read=FMessageStore, write=FMessageStore};
	__property bool QuickConnect = {read=FQuickConnect, write=FQuickConnect, default=0};
	__property TGSMMode GSMMode = {read=GetGSMMode, write=SetGSMMode, nodefault};
	__property int SMSErrorCode = {read=FErrorCode, nodefault};
	__property TGSMStates GSMState = {read=FGSMState, nodefault};
	__property TApdGSMNewMessageEvent OnNewMessage = {read=FOnNewMessage, write=FOnNewMessage};
	__property TApdGSMNextMessageEvent OnNextMessage = {read=FOnNextMessage, write=FOnNextMessage};
	__property TApdGSMMessageListEvent OnMessageList = {read=FOnMessageList, write=FOnMessageList};
	__property TApdGSMCompleteEvent OnGSMComplete = {read=FOnGSMComplete, write=FOnGSMComplete};
};


class PASCALIMPLEMENTATION TApdGSMPhone : public TApdCustomGSMPhone
{
	typedef TApdCustomGSMPhone inherited;
	
public:
	__fastcall virtual TApdGSMPhone(System::Classes::TComponent* Owner);
	__fastcall virtual ~TApdGSMPhone(void);
	
__published:
	__property ComPort;
	__property QuickConnect = {default=0};
	__property GSMMode;
	__property SMSAddress = {default=0};
	__property SMSMessage = {default=0};
	__property SMSCenter = {default=0};
	__property NotifyOnNewMessage = {default=0};
	__property OnNewMessage;
	__property OnNextMessage;
	__property OnMessageList;
	__property OnGSMComplete;
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word ApdGSMResponse = System::Word(0x464);
extern DELPHI_PACKAGE System::AnsiString __fastcall PDUToString(System::AnsiString v);
extern DELPHI_PACKAGE System::AnsiString __fastcall StringToPDU(System::AnsiString v);
}	/* namespace Adgsm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADGSM)
using namespace Adgsm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdgsmHPP
