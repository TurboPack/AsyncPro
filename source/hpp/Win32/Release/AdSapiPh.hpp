// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdSapiPh.pas' rev: 32.00 (Windows)

#ifndef AdsapiphHPP
#define AdsapiphHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.MMSystem.hpp>
#include <System.IniFiles.hpp>
#include <OoMisc.hpp>
#include <AdSapiEn.hpp>
#include <AdTUtil.hpp>
#include <AdTapi.hpp>
#include <AdSapiGr.hpp>
#include <AdISapi.hpp>
#include <System.DateUtils.hpp>
#include <System.Variants.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Win.ComObj.hpp>
#include <Vcl.Dialogs.hpp>
#include <AdPort.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adsapiph
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS ESapiPhoneError;
class DELPHICLASS TApdSapiGrammarList;
class DELPHICLASS TApdSapiPhonePrompts;
class DELPHICLASS TApdSapiAskForInfo;
class DELPHICLASS TApdCustomSapiPhone;
class DELPHICLASS TApdSapiPhone;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM Adsapiph__1 : unsigned char { psVerify, psCanGoBack, psDisableSpeedChange, psEnableOperator, psEnableAskHangup };

typedef System::Set<Adsapiph__1, Adsapiph__1::psVerify, Adsapiph__1::psEnableAskHangup> TApdSapiPhoneSettings;

enum DECLSPEC_DENUM TApdSapiPhoneReply : unsigned char { prOk, prAbort, prNoResponse, prOperator, prHangUp, prBack, prWhere, prHelp, prRepeat, prSpeakFaster, prSpeakSlower, prCheck, prError, prUnknown };

enum DECLSPEC_DENUM TApdPhraseType : unsigned char { ptHelp, ptBack, ptOperator, ptHangup, ptRepeat, ptWhere, ptSpeakFaster, ptSpeakSlower, ptUnknown, ptNone, ptCustom, ptAbort, ptTimeout };

enum DECLSPEC_DENUM TGrammarStringHandler : unsigned char { gshIgnore, gshInsert, gshAutoReplace };

typedef void __fastcall (__closure *TApdSapiPhoneEvent)(System::TObject* Sender);

typedef void __fastcall (__closure *TApdOnAskForStringFinish)(System::TObject* Sender, TApdSapiPhoneReply Reply, System::UnicodeString Data, System::UnicodeString SpokenData);

typedef void __fastcall (__closure *TApdOnAskForDateTimeFinish)(System::TObject* Sender, TApdSapiPhoneReply Reply, System::TDateTime Data, System::UnicodeString SpokenData);

typedef void __fastcall (__closure *TApdOnAskForIntegerFinish)(System::TObject* Sender, TApdSapiPhoneReply Reply, int Data, System::UnicodeString SpokenData);

typedef void __fastcall (__closure *TApdOnAskForBooleanFinish)(System::TObject* Sender, TApdSapiPhoneReply Reply, bool Data, System::UnicodeString SpokenData);

typedef void __fastcall (__closure *TApdCustomDataHandler)(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);

typedef void __fastcall (__closure *TApdAskForEventTrigger)(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);

#pragma pack(push,4)
class PASCALIMPLEMENTATION ESapiPhoneError : public Adsapien::EApdSapiEngineException
{
	typedef Adsapien::EApdSapiEngineException inherited;
	
public:
	/* EApdSapiEngineException.Create */ inline __fastcall ESapiPhoneError(const int ErrCode, const System::UnicodeString Msg) : Adsapien::EApdSapiEngineException(ErrCode, Msg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall ESapiPhoneError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : Adsapien::EApdSapiEngineException(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall ESapiPhoneError(NativeUInt Ident)/* overload */ : Adsapien::EApdSapiEngineException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall ESapiPhoneError(System::PResStringRec ResStringRec)/* overload */ : Adsapien::EApdSapiEngineException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall ESapiPhoneError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : Adsapien::EApdSapiEngineException(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall ESapiPhoneError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : Adsapien::EApdSapiEngineException(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall ESapiPhoneError(const System::UnicodeString Msg, int AHelpContext) : Adsapien::EApdSapiEngineException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ESapiPhoneError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : Adsapien::EApdSapiEngineException(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ESapiPhoneError(NativeUInt Ident, int AHelpContext)/* overload */ : Adsapien::EApdSapiEngineException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ESapiPhoneError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Adsapien::EApdSapiEngineException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ESapiPhoneError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : Adsapien::EApdSapiEngineException(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ESapiPhoneError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : Adsapien::EApdSapiEngineException(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ESapiPhoneError(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdSapiGrammarList : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
public:
	void __fastcall ReadSectionValues(System::UnicodeString Section, System::Classes::TStringList* List);
	bool __fastcall SectionExists(System::UnicodeString Section);
public:
	/* TStringList.Create */ inline __fastcall TApdSapiGrammarList(void)/* overload */ : System::Classes::TStringList() { }
	/* TStringList.Create */ inline __fastcall TApdSapiGrammarList(bool OwnsObjects)/* overload */ : System::Classes::TStringList(OwnsObjects) { }
	/* TStringList.Create */ inline __fastcall TApdSapiGrammarList(System::WideChar QuoteChar, System::WideChar Delimiter)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter) { }
	/* TStringList.Create */ inline __fastcall TApdSapiGrammarList(System::WideChar QuoteChar, System::WideChar Delimiter, System::Classes::TStringsOptions Options)/* overload */ : System::Classes::TStringList(QuoteChar, Delimiter, Options) { }
	/* TStringList.Create */ inline __fastcall TApdSapiGrammarList(System::Types::TDuplicates Duplicates, bool Sorted, bool CaseSensitive)/* overload */ : System::Classes::TStringList(Duplicates, Sorted, CaseSensitive) { }
	/* TStringList.Destroy */ inline __fastcall virtual ~TApdSapiGrammarList(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdSapiPhonePrompts : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FAskAreaCode;
	System::UnicodeString FAskLastFour;
	System::UnicodeString FAskNextThree;
	System::UnicodeString FCannotGoBack;
	System::UnicodeString FCannotHangUp;
	System::UnicodeString FGoingBack;
	System::UnicodeString FHangingUp;
	System::UnicodeString FHelp;
	System::UnicodeString FHelp2;
	System::UnicodeString FHelpVerify;
	System::UnicodeString FMain;
	System::UnicodeString FMain2;
	System::UnicodeString FMaxSpeed;
	System::UnicodeString FMinSpeed;
	System::UnicodeString FOperator;
	System::UnicodeString FNoOperator;
	System::UnicodeString FNoSpeedChange;
	System::UnicodeString FSpeakingFaster;
	System::UnicodeString FSpeakingSlower;
	System::UnicodeString FTooFewDigits;
	System::UnicodeString FTooManyDigits;
	System::UnicodeString FUnrecognized;
	System::UnicodeString FVerifyPost;
	System::UnicodeString FVerifyPre;
	System::UnicodeString FWhere;
	System::UnicodeString FWhere2;
	
protected:
	void __fastcall SetAskAreaCode(System::UnicodeString v);
	void __fastcall SetAskLastFour(System::UnicodeString v);
	void __fastcall SetAskNextThree(System::UnicodeString v);
	void __fastcall SetCannotGoBack(System::UnicodeString v);
	void __fastcall SetCannotHangUp(System::UnicodeString v);
	void __fastcall SetGoingBack(System::UnicodeString v);
	void __fastcall SetHangingUp(System::UnicodeString v);
	void __fastcall SetHelp(System::UnicodeString v);
	void __fastcall SetHelp2(System::UnicodeString v);
	void __fastcall SetHelpVerify(System::UnicodeString v);
	void __fastcall SetMain(System::UnicodeString v);
	void __fastcall SetMain2(System::UnicodeString v);
	void __fastcall SetMaxSpeed(System::UnicodeString v);
	void __fastcall SetMinSpeed(System::UnicodeString v);
	void __fastcall SetOperator(System::UnicodeString v);
	void __fastcall SetNoOperator(System::UnicodeString v);
	void __fastcall SetNoSpeedChange(System::UnicodeString v);
	void __fastcall SetSpeakingFaster(System::UnicodeString v);
	void __fastcall SetSpeakingSlower(System::UnicodeString v);
	void __fastcall SetTooFewDigits(System::UnicodeString v);
	void __fastcall SetTooManyDigits(System::UnicodeString v);
	void __fastcall SetUnrecognized(System::UnicodeString v);
	void __fastcall SetVerifyPost(System::UnicodeString v);
	void __fastcall SetVerifyPre(System::UnicodeString v);
	void __fastcall SetWhere(System::UnicodeString v);
	void __fastcall SetWhere2(System::UnicodeString v);
	
public:
	__fastcall TApdSapiPhonePrompts(void);
	System::UnicodeString __fastcall GenerateGrammar(System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	System::UnicodeString __fastcall GenerateExtensionGrammar(System::UnicodeString NewTooFewDigits, System::UnicodeString NewTooManyDigits);
	System::UnicodeString __fastcall GeneratePhoneNumberGrammar(System::UnicodeString NewAskAreaCode, System::UnicodeString NewAskNextThree, System::UnicodeString NewAskLastFour);
	
__published:
	__property System::UnicodeString AskAreaCode = {read=FAskAreaCode, write=SetAskAreaCode};
	__property System::UnicodeString AskLastFour = {read=FAskLastFour, write=SetAskLastFour};
	__property System::UnicodeString AskNextThree = {read=FAskNextThree, write=SetAskNextThree};
	__property System::UnicodeString CannotGoBack = {read=FCannotGoBack, write=SetCannotGoBack};
	__property System::UnicodeString CannotHangUp = {read=FCannotHangUp, write=SetCannotHangUp};
	__property System::UnicodeString HangingUp = {read=FHangingUp, write=SetHangingUp};
	__property System::UnicodeString Help = {read=FHelp, write=SetHelp};
	__property System::UnicodeString Help2 = {read=FHelp2, write=SetHelp2};
	__property System::UnicodeString HelpVerify = {read=FHelpVerify, write=SetHelpVerify};
	__property System::UnicodeString GoingBack = {read=FGoingBack, write=SetGoingBack};
	__property System::UnicodeString Main = {read=FMain, write=SetMain};
	__property System::UnicodeString Main2 = {read=FMain2, write=SetMain2};
	__property System::UnicodeString MaxSpeed = {read=FMaxSpeed, write=SetMaxSpeed};
	__property System::UnicodeString MinSpeed = {read=FMinSpeed, write=SetMinSpeed};
	__property System::UnicodeString Operator = {read=FOperator, write=SetOperator};
	__property System::UnicodeString NoOperator = {read=FNoOperator, write=SetNoOperator};
	__property System::UnicodeString NoSpeedChange = {read=FNoSpeedChange, write=SetNoSpeedChange};
	__property System::UnicodeString SpeakingFaster = {read=FSpeakingFaster, write=SetSpeakingFaster};
	__property System::UnicodeString SpeakingSlower = {read=FSpeakingSlower, write=SetSpeakingSlower};
	__property System::UnicodeString TooFewDigits = {read=FTooFewDigits, write=SetTooFewDigits};
	__property System::UnicodeString TooManyDigits = {read=FTooManyDigits, write=SetTooManyDigits};
	__property System::UnicodeString Unrecognized = {read=FUnrecognized, write=SetUnrecognized};
	__property System::UnicodeString VerifyPost = {read=FVerifyPost, write=SetVerifyPost};
	__property System::UnicodeString VerifyPre = {read=FVerifyPre, write=SetVerifyPre};
	__property System::UnicodeString Where = {read=FWhere, write=SetWhere};
	__property System::UnicodeString Where2 = {read=FWhere2, write=SetWhere2};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TApdSapiPhonePrompts(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdSapiAskForInfo : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	NativeUInt FReplyHandle;
	TApdSapiPhonePrompts* FPrompts;
	Adsapien::TApdCustomSapiEngine* FSapiEngine;
	System::Classes::TStringList* FAskForGrammar;
	System::Classes::TStringList* FMainGrammar;
	TApdSapiPhoneSettings FOptions;
	TGrammarStringHandler FStringHandler;
	
protected:
	TApdPhraseType __fastcall DeterminePhraseTypeEx(System::UnicodeString Phrase, System::UnicodeString &Rule);
	bool __fastcall IsAnglePhrase(System::UnicodeString Phrase);
	bool __fastcall IsParenPhrase(System::UnicodeString Phrase);
	bool __fastcall IsQuoted(System::UnicodeString Phrase);
	System::UnicodeString __fastcall KillQuotes(System::UnicodeString Phrase);
	System::UnicodeString __fastcall GetValue(System::UnicodeString Value);
	System::UnicodeString __fastcall GetKey(System::UnicodeString Value);
	bool __fastcall AnalyzeRule(System::Classes::TStringList* Tokens, System::UnicodeString CurrentRule, TApdSapiGrammarList* INIFile, System::Classes::TStringList* CurrentSection, int &CurrentWord, System::UnicodeString &MatchingKey);
	bool __fastcall RecurseRules(System::Classes::TStringList* Tokens, TApdSapiGrammarList* INIFile, System::UnicodeString CurrentSection, int &CurrentWord, System::UnicodeString &MatchingKey);
	System::UnicodeString __fastcall LocateRule(System::Classes::TStringList* Tokens);
	void __fastcall InitializeMainGrammar(void);
	virtual void __fastcall SapiPhraseFinishHook(System::TObject* Sender, System::UnicodeString Phrase, int Results);
	void __fastcall SetAskForGrammar(System::Classes::TStringList* v);
	void __fastcall SetMainGrammar(System::Classes::TStringList* v);
	void __fastcall SetOptions(TApdSapiPhoneSettings v);
	void __fastcall SetReplyHandle(NativeUInt v);
	
public:
	__fastcall TApdSapiAskForInfo(void);
	__fastcall virtual ~TApdSapiAskForInfo(void);
	void __fastcall AskFor(void);
	TApdPhraseType __fastcall DeterminePhraseType(System::UnicodeString Phrase);
	System::UnicodeString __fastcall FindGrammarRule(System::UnicodeString &Phrase);
	
__published:
	__property System::Classes::TStringList* AskForGrammar = {read=FAskForGrammar, write=SetAskForGrammar};
	__property System::Classes::TStringList* MainGrammar = {read=FMainGrammar, write=SetMainGrammar};
	__property TApdSapiPhoneSettings Options = {read=FOptions, write=SetOptions, nodefault};
	__property TApdSapiPhonePrompts* Prompts = {read=FPrompts, write=FPrompts};
	__property NativeUInt ReplyHandle = {read=FReplyHandle, write=SetReplyHandle, nodefault};
	__property Adsapien::TApdCustomSapiEngine* SapiEngine = {read=FSapiEngine, write=FSapiEngine};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdCustomSapiPhone : public Adtapi::TApdCustomTapiDevice
{
	typedef Adtapi::TApdCustomTapiDevice inherited;
	
private:
	Adsapien::TApdCustomSapiEngine* FSapiEngine;
	Adisapi::_di_IAudioMultiMediaDevice IAMM;
	Adisapi::_di_IAudioTel IAT;
	int FNumDigits;
	int FNoAnswerMax;
	int FNoAnswerTime;
	TApdSapiPhoneSettings FOptions;
	bool FInAskFor;
	bool FSpellingEchoBack;
	TApdSapiPhonePrompts* FPrompts;
	TApdSapiAskForInfo* FInfo;
	System::UnicodeString FExtension;
	int FDigitCount;
	System::UnicodeString FSpelledWord;
	System::Classes::TStringList* FList;
	TApdCustomDataHandler FCustomDataHandler;
	TApdAskForEventTrigger FEventTrigger;
	TApdOnAskForDateTimeFinish FOnAskForDateFinish;
	TApdOnAskForStringFinish FOnAskForExtensionFinish;
	TApdOnAskForIntegerFinish FOnAskForListFinish;
	TApdOnAskForStringFinish FOnAskForPhoneNumberFinish;
	TApdOnAskForStringFinish FOnAskForSpellingFinish;
	TApdOnAskForDateTimeFinish FOnAskForTimeFinish;
	TApdOnAskForBooleanFinish FOnAskForYesNoFinish;
	System::Classes::TNotifyEvent FOnTapiDisconnect;
	
protected:
	void __fastcall AskForDateDataHandler(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);
	void __fastcall AskForExtensionDataHandler(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);
	void __fastcall AskForListDataHandler(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);
	void __fastcall AskForPhoneNumberDataHandler(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);
	void __fastcall AskForSpellingDataHandler(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);
	void __fastcall AskForTimeDataHandler(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);
	void __fastcall AskForYesNoDataHandler(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);
	void __fastcall AskForDateTrigger(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);
	void __fastcall AskForExtensionTrigger(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);
	void __fastcall AskForListTrigger(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);
	void __fastcall AskForPhoneNumberTrigger(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);
	void __fastcall AskForSpellingTrigger(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);
	void __fastcall AskForTimeTrigger(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);
	void __fastcall AskForYesNoTrigger(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);
	TApdSapiPhoneReply __fastcall ConvertResponse(int RCode);
	virtual void __fastcall DoLineCallState(int Device, int P1, int P2, int P3);
	void __fastcall ExitAskFor(TApdSapiPhoneReply Reply, void * Data, System::UnicodeString SpokenData);
	System::UnicodeString __fastcall GetPhraseData(int LParam);
	System::UnicodeString __fastcall FixNumerics(System::UnicodeString Phrase);
	virtual System::TDateTime __fastcall InterpretDate(System::UnicodeString Phrase, bool &Trusted);
	System::UnicodeString __fastcall InterpretPhoneNumber(System::UnicodeString Phrase);
	virtual System::TDateTime __fastcall InterpretTime(System::UnicodeString Phrase);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	MESSAGE void __fastcall PhraseHandler(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall SapiPhoneCallback(Winapi::Messages::TMessage &Msg);
	void __fastcall SetNoAnswerMax(int v);
	void __fastcall SetNoAnswerTime(int v);
	void __fastcall SetNumDigits(int v);
	void __fastcall SetOptions(TApdSapiPhoneSettings v);
	void __fastcall SetSpellingEchoBack(bool v);
	void __fastcall UpdateStateMachine(TApdPhraseType LastReply, int LastRule, System::UnicodeString LastPhrase);
	
public:
	__fastcall virtual TApdCustomSapiPhone(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomSapiPhone(void);
	void __fastcall AbortAskFor(void);
	void __fastcall AskForDate(System::UnicodeString NewPrompt1);
	void __fastcall AskForDateEx(System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	void __fastcall AskForExtension(System::UnicodeString NewPrompt1);
	void __fastcall AskForExtensionEx(System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewTooManyDigits, System::UnicodeString NewTooFewDigits, int NewNumDigits, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	void __fastcall AskForList(System::Classes::TStringList* List, System::UnicodeString NewPrompt1);
	void __fastcall AskForListEx(System::Classes::TStringList* List, System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	void __fastcall AskForPhoneNumber(System::UnicodeString NewPrompt1);
	void __fastcall AskForPhoneNumberEx(System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewAskAreaCode, System::UnicodeString NewAskNextThree, System::UnicodeString NewAskLastFour, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	void __fastcall AskForSpelling(System::UnicodeString NewPrompt1);
	void __fastcall AskForSpellingEx(System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	void __fastcall AskForTime(System::UnicodeString NewPrompt1);
	void __fastcall AskForTimeEx(System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	void __fastcall AskForYesNo(System::UnicodeString NewPrompt1);
	void __fastcall AskForYesNoEx(System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	void __fastcall SetDefaultPrompts(System::UnicodeString NewPrompt1, System::UnicodeString NewPrompt2, System::UnicodeString NewHelp1, System::UnicodeString NewHelp2, System::UnicodeString NewWhere1, System::UnicodeString NewWhere2);
	void __fastcall Speak(const System::UnicodeString Text);
	__property TApdSapiPhonePrompts* Prompts = {read=FPrompts, write=FPrompts};
	
__published:
	__property int NoAnswerMax = {read=FNoAnswerMax, write=SetNoAnswerMax, nodefault};
	__property int NoAnswerTime = {read=FNoAnswerTime, write=SetNoAnswerTime, nodefault};
	__property int NumDigits = {read=FNumDigits, write=SetNumDigits, nodefault};
	__property TApdSapiPhoneSettings Options = {read=FOptions, write=SetOptions, nodefault};
	__property Adsapien::TApdCustomSapiEngine* SapiEngine = {read=FSapiEngine, write=FSapiEngine};
	__property bool SpellingEchoBack = {read=FSpellingEchoBack, write=SetSpellingEchoBack, default=1};
	__property TApdOnAskForDateTimeFinish OnAskForDateFinish = {read=FOnAskForDateFinish, write=FOnAskForDateFinish};
	__property TApdOnAskForStringFinish OnAskForExtensionFinish = {read=FOnAskForExtensionFinish, write=FOnAskForExtensionFinish};
	__property TApdOnAskForIntegerFinish OnAskForListFinish = {read=FOnAskForListFinish, write=FOnAskForListFinish};
	__property TApdOnAskForStringFinish OnAskForPhoneNumberFinish = {read=FOnAskForPhoneNumberFinish, write=FOnAskForPhoneNumberFinish};
	__property TApdOnAskForStringFinish OnAskForSpellingFinish = {read=FOnAskForSpellingFinish, write=FOnAskForSpellingFinish};
	__property TApdOnAskForDateTimeFinish OnAskForTimeFinish = {read=FOnAskForTimeFinish, write=FOnAskForTimeFinish};
	__property TApdOnAskForBooleanFinish OnAskForYesNoFinish = {read=FOnAskForYesNoFinish, write=FOnAskForYesNoFinish};
	__property System::Classes::TNotifyEvent OnTapiDisconnect = {read=FOnTapiDisconnect, write=FOnTapiDisconnect};
	__property SelectedDevice = {default=0};
	__property ComPort;
	__property StatusDisplay;
	__property TapiLog;
	__property AnswerOnRing = {default=2};
	__property RetryWait = {default=60};
	__property MaxAttempts = {default=3};
	__property ShowTapiDevices;
	__property ShowPorts;
	__property EnableVoice;
	__property FilterUnsupportedDevices = {default=1};
	__property OnTapiStatus;
	__property OnTapiLog;
	__property OnTapiPortOpen;
	__property OnTapiPortClose;
	__property OnTapiConnect;
	__property OnTapiFail;
	__property OnTapiDTMF;
	__property OnTapiCallerID;
	__property OnTapiWaveNotify;
	__property OnTapiWaveSilence;
};


class PASCALIMPLEMENTATION TApdSapiPhone : public TApdCustomSapiPhone
{
	typedef TApdCustomSapiPhone inherited;
	
__published:
	__property NoAnswerMax;
	__property NoAnswerTime;
	__property NumDigits;
	__property Options;
	__property SapiEngine;
	__property SelectedDevice = {default=0};
	__property ComPort;
	__property StatusDisplay;
	__property TapiLog;
	__property AnswerOnRing = {default=2};
	__property RetryWait = {default=60};
	__property MaxAttempts = {default=3};
	__property ShowTapiDevices;
	__property ShowPorts;
	__property EnableVoice;
	__property FilterUnsupportedDevices = {default=1};
	__property OnTapiStatus;
	__property OnTapiLog;
	__property OnTapiPortOpen;
	__property OnTapiPortClose;
	__property OnTapiConnect;
	__property OnTapiFail;
	__property OnTapiDTMF;
	__property OnTapiCallerID;
	__property OnTapiWaveNotify;
	__property OnTapiWaveSilence;
public:
	/* TApdCustomSapiPhone.Create */ inline __fastcall virtual TApdSapiPhone(System::Classes::TComponent* AOwner) : TApdCustomSapiPhone(AOwner) { }
	/* TApdCustomSapiPhone.Destroy */ inline __fastcall virtual ~TApdSapiPhone(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const NativeUInt ApdSapiAskOperator = NativeUInt(0xfffffffd);
static const NativeUInt ApdSapiAskHangUp = NativeUInt(0xfffffffc);
static const NativeUInt ApdSapiAskBack = NativeUInt(0xfffffffb);
static const NativeUInt ApdSapiAskWhere = NativeUInt(0xfffffff6);
static const NativeUInt ApdSapiAskHelp = NativeUInt(0xfffffff5);
static const NativeUInt ApdSapiAskRepeat = NativeUInt(0xc);
static const NativeUInt ApdSapiAskSpeakFaster = NativeUInt(0xd);
static const NativeUInt ApdSapiAskSpeakSlower = NativeUInt(0xfffffff2);
static const NativeUInt ApdSapiAbort = NativeUInt(0xffffff9e);
static const NativeUInt ApdSapiTimeout = NativeUInt(0xffffff9d);
static const System::Int8 ApdSapiSpeedChange = System::Int8(0x19);
static const System::Int8 ApdSapiConnect = System::Int8(0x1);
static const System::Int8 ApdSapiDisConnect = System::Int8(0x2);
static const System::Int8 ApdTCR_ABORT = System::Int8(-1);
static const System::Int8 ApdTCR_NORESPONSE = System::Int8(-2);
static const System::Int8 ApdTCR_ASKOPERATOR = System::Int8(-3);
static const System::Int8 ApdTCR_ASKHANGUP = System::Int8(-4);
static const System::Int8 ApdTCR_ASKBACK = System::Int8(-5);
static const System::Int8 ApdTCR_ASKWHERE = System::Int8(-10);
static const System::Int8 ApdTCR_ASKHELP = System::Int8(-11);
static const System::Int8 ApdTCR_ASKREPEAT = System::Int8(-12);
static const System::Int8 ApdTCR_ASKSPEAKFASTER = System::Int8(-13);
static const System::Int8 ApdTCR_ASKSPEAKSLOWER = System::Int8(-14);
}	/* namespace Adsapiph */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSAPIPH)
using namespace Adsapiph;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdsapiphHPP
