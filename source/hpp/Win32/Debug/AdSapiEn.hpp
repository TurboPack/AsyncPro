// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdSapiEn.pas' rev: 32.00 (Windows)

#ifndef AdsapienHPP
#define AdsapienHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.OleServer.hpp>
#include <Vcl.OleCtrls.hpp>
#include <System.Win.StdVCL.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Controls.hpp>
#include <OoMisc.hpp>
#include <AdISapi.hpp>
#include <AdSapiGr.hpp>
#include <System.Contnrs.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <AdExcept.hpp>
#include <System.Win.ComObj.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adsapien
{
//-- forward type declarations -----------------------------------------------
struct TApdRegisteredEvent;
class DELPHICLASS EApdSapiEngineException;
class DELPHICLASS TApdSSVoices;
class DELPHICLASS TApdSREngines;
class DELPHICLASS TApdCustomSapiEngine;
class DELPHICLASS TApdSapiEngine;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TApdSapiDuplex : unsigned char { sdFull, sdHalf, sdHalfDelayed };

enum DECLSPEC_DENUM TApdSapiWaitMode : unsigned char { wmNone, wmWaitSpeaking, wmWaitListening, wmRestoreListen };

enum DECLSPEC_DENUM TApdCharacterSet : unsigned char { csText, csIPAPhonetic, csEnginePhonetic };

enum DECLSPEC_DENUM Adsapien__1 : unsigned char { toTagged };

typedef System::Set<Adsapien__1, Adsapien__1::toTagged, Adsapien__1::toTagged> TApdTTSOptions;

enum DECLSPEC_DENUM TApdTTSAge : unsigned char { tsBaby, tsToddler, tsChild, tsAdolescent, tsAdult, tsElderly, tsUnknown };

enum DECLSPEC_DENUM Adsapien__2 : unsigned char { tfAnyWord, tfVolume, tfSpeed, tfPitch, tfTagged, tfIPAUnicode, tfVisual, tfWordPosition, tfPCOptimized, tfPhoneOptimized, tfFixedAudio, tfSingleInstance, tfThreadSafe, tfIPATextData, tfPreferred, tfTransplanted, tfSAPI4 };

typedef System::Set<Adsapien__2, Adsapien__2::tfAnyWord, Adsapien__2::tfSAPI4> TApdTTSFeatures;

enum DECLSPEC_DENUM TApdTTSGender : unsigned char { tgNeutral, tgFemale, tgMale, tgUnknown };

enum DECLSPEC_DENUM Adsapien__3 : unsigned char { tiLexPronounce, tiTTSAttributes, tiTTSCentral, tiTTSDialogs, tiAttributes, tiIAttributes, tiLexPronounce2 };

typedef System::Set<Adsapien__3, Adsapien__3::tiLexPronounce, Adsapien__3::tiLexPronounce2> TApdTTSInterfaces;

enum DECLSPEC_DENUM Adsapien__4 : unsigned char { sfIndepSpeaker, sfIndepMicrophone, sfTrainWord, sfTrainPhonetic, sfWildcard, sfAnyWord, sfPCOptimized, sfPhoneOptimized, sfGramList, sfGramLink, sfMultiLingual, sfGramRecursive, sfIPAUnicode, sfSingleInstance, sfThreadSafe, sfFixedAudio, sfIPAWord, sfSAPI4 };

typedef System::Set<Adsapien__4, Adsapien__4::sfIndepSpeaker, Adsapien__4::sfSAPI4> TApdSRFeatures;

enum DECLSPEC_DENUM Adsapien__5 : unsigned char { sgCFG, sgDictation, sgLimitedDomain };

typedef System::Set<Adsapien__5, Adsapien__5::sgCFG, Adsapien__5::sgLimitedDomain> TApdSRGrammars;

enum DECLSPEC_DENUM Adsapien__6 : unsigned char { siLexPronounce, siSRAttributes, siSRCentral, siSRGramCommon, siSRDialogs, siSRGramCFG, siSRGramDictation, siSRGramInsertionGui, siSREsBasic, siSREsMerge, siSREsAudio, siSREsCorrection, siSREsEval, siSREsGraph, siSREsMemory, siSREsModifyGui, siSREsSpeaker, siSRSpeaker, siSREsScores, siSREsAudioEx, siSRGramLexPron, siSREsGraphEx, siLexPronounce2, siAttributes, siSRSpeaker2, siSRDialogs2 };

typedef System::Set<Adsapien__6, Adsapien__6::siLexPronounce, Adsapien__6::siSRDialogs2> TApdSRInterfaces;

enum DECLSPEC_DENUM TApdSRSequences : unsigned char { ssDiscrete, ssContinuous, ssWordSpot, ssContCFGDiscDict, ssUnknown };

enum DECLSPEC_DENUM TApdSRInterferenceType : unsigned char { itAudioStarted, itAudioStopped, itDeviceOpened, itDeviceClosed, itNoise, itTooLoud, itTooQuiet, itUnknown };

enum DECLSPEC_DENUM Adsapien__7 : unsigned char { ttCurrentMic, ttCurrentGrammar, ttGeneral };

typedef System::Set<Adsapien__7, Adsapien__7::ttCurrentMic, Adsapien__7::ttGeneral> TApdSRTrainingType;

typedef void __fastcall (__closure *TApdOnSapiError)(System::TObject* Sender, int Error, const System::UnicodeString Details, const System::UnicodeString Message);

typedef void __fastcall (__closure *TApdSapiNotifyEvent)(System::TObject* Sender);

typedef void __fastcall (__closure *TApdSRInterferenceEvent)(System::TObject* Sender, TApdSRInterferenceType InterferenceType);

typedef void __fastcall (__closure *TApdSRPhraseFinishEvent)(System::TObject* Sender, const System::UnicodeString Phrase);

typedef void __fastcall (__closure *TApdSRPhraseHypothesisEvent)(System::TObject* Sender, const System::UnicodeString Phrase);

typedef void __fastcall (__closure *TApdSRTrainingRequestedEvent)(System::TObject* Sender, TApdSRTrainingType Training);

typedef void __fastcall (__closure *TApdSRVUMeterEvent)(System::TObject* Sender, int Level);

typedef void __fastcall (__closure *TApdSSAttributeChanged)(System::TObject* Sender, int Attribute);

typedef void __fastcall (__closure *TApdPhraseFinishMethod)(System::TObject* Sender, System::UnicodeString Phrase, int Results);

typedef TApdPhraseFinishMethod *PApdPhraseFinishMethod;

enum DECLSPEC_DENUM TApdRegisteredEventTypes : unsigned char { etPhraseFinish };

typedef TApdRegisteredEvent *PApdRegisteredEvent;

struct DECLSPEC_DRECORD TApdRegisteredEvent
{
public:
	TApdPhraseFinishMethod CallBack;
	TApdRegisteredEventTypes EventType;
	bool Active;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION EApdSapiEngineException : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
private:
	int FErrorCode;
	
public:
	__fastcall EApdSapiEngineException(const int ErrCode, const System::UnicodeString Msg);
	
__published:
	__property int ErrorCode = {read=FErrorCode, nodefault};
public:
	/* Exception.CreateFmt */ inline __fastcall EApdSapiEngineException(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EApdSapiEngineException(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EApdSapiEngineException(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EApdSapiEngineException(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EApdSapiEngineException(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EApdSapiEngineException(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EApdSapiEngineException(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EApdSapiEngineException(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EApdSapiEngineException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EApdSapiEngineException(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EApdSapiEngineException(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EApdSapiEngineException(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdSSVoices : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString operator[](int x) { return this->ModeName[x]; }
	
private:
	int FCurrentVoice;
	Adisapi::TDirectSS* FiDirectSS;
	
protected:
	bool __fastcall CheckIndex(int x);
	TApdTTSAge __fastcall GetAge(int x);
	int __fastcall GetCount(void);
	int __fastcall GetCurrentVoice(void);
	System::UnicodeString __fastcall GetDialect(int x);
	int __fastcall GetEngineFeatures(int x);
	System::UnicodeString __fastcall GetEngineID(int x);
	TApdTTSFeatures __fastcall GetFeatures(int x);
	TApdTTSGender __fastcall GetGender(int x);
	TApdTTSInterfaces __fastcall GetInterfaces(int x);
	int __fastcall GetLanguageID(int x);
	System::UnicodeString __fastcall GetMfgName(int x);
	System::UnicodeString __fastcall GetModeID(int x);
	System::UnicodeString __fastcall GetModeName(int x);
	System::UnicodeString __fastcall GetProductName(int x);
	System::UnicodeString __fastcall GetSpeaker(int x);
	System::UnicodeString __fastcall GetStyle(int x);
	void __fastcall SetCurrentVoice(int v);
	
public:
	int __fastcall Find(System::UnicodeString Criteria);
	__property TApdTTSAge Age[int x] = {read=GetAge};
	__property System::UnicodeString Dialect[int x] = {read=GetDialect};
	__property int EngineFeatures[int x] = {read=GetEngineFeatures};
	__property System::UnicodeString EngineID[int x] = {read=GetEngineID};
	__property TApdTTSFeatures Features[int x] = {read=GetFeatures};
	__property TApdTTSGender Gender[int x] = {read=GetGender};
	__property TApdTTSInterfaces Interfaces[int x] = {read=GetInterfaces};
	__property int LanguageID[int x] = {read=GetLanguageID};
	__property System::UnicodeString MfgName[int x] = {read=GetMfgName};
	__property System::UnicodeString ModeID[int x] = {read=GetModeID};
	__property System::UnicodeString ModeName[int x] = {read=GetModeName/*, default*/};
	__property System::UnicodeString ProductName[int x] = {read=GetProductName};
	__property System::UnicodeString Speaker[int x] = {read=GetSpeaker};
	__property System::UnicodeString Style[int x] = {read=GetStyle};
	
__published:
	__property int Count = {read=GetCount, nodefault};
	__property int CurrentVoice = {read=GetCurrentVoice, write=SetCurrentVoice, nodefault};
public:
	/* TObject.Create */ inline __fastcall TApdSSVoices(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TApdSSVoices(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdSREngines : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString operator[](int x) { return this->ModeName[x]; }
	
private:
	int FCurrentEngine;
	Adisapi::TDirectSR* FiDirectSR;
	
protected:
	bool __fastcall CheckIndex(int x);
	int __fastcall GetCount(void);
	int __fastcall GetCurrentEngine(void);
	System::UnicodeString __fastcall GetDialect(int x);
	int __fastcall GetEngineFeatures(int x);
	System::UnicodeString __fastcall GetEngineId(int x);
	TApdSRFeatures __fastcall GetFeatures(int x);
	TApdSRGrammars __fastcall GetGrammars(int x);
	TApdSRInterfaces __fastcall GetInterfaces(int x);
	int __fastcall GetLanguageID(int x);
	int __fastcall GetMaxWordsState(int x);
	int __fastcall GetMaxWordsVocab(int x);
	System::UnicodeString __fastcall GetMfgName(int x);
	System::UnicodeString __fastcall GetModeID(int x);
	System::UnicodeString __fastcall GetModeName(int x);
	System::UnicodeString __fastcall GetProductName(int x);
	TApdSRSequences __fastcall GetSequencing(int x);
	void __fastcall SetCurrentEngine(int v);
	
public:
	__property System::UnicodeString Dialect[int x] = {read=GetDialect};
	__property int EngineFeatures[int x] = {read=GetEngineFeatures};
	__property System::UnicodeString EngineID[int x] = {read=GetEngineId};
	__property TApdSRFeatures Features[int x] = {read=GetFeatures};
	__property TApdSRGrammars Grammars[int x] = {read=GetGrammars};
	__property TApdSRInterfaces Interfaces[int x] = {read=GetInterfaces};
	__property int LanguageID[int x] = {read=GetLanguageID};
	__property int MaxWordsState[int x] = {read=GetMaxWordsState};
	__property int MaxWordsVocab[int x] = {read=GetMaxWordsVocab};
	__property System::UnicodeString MfgName[int x] = {read=GetMfgName};
	__property System::UnicodeString ModeID[int x] = {read=GetModeID};
	__property System::UnicodeString ModeName[int x] = {read=GetModeName/*, default*/};
	__property System::UnicodeString ProductName[int x] = {read=GetProductName};
	__property TApdSRSequences Sequencing[int x] = {read=GetSequencing};
	
__published:
	__property int Count = {read=GetCount, nodefault};
	__property int CurrentEngine = {read=GetCurrentEngine, write=SetCurrentEngine, nodefault};
public:
	/* TObject.Create */ inline __fastcall TApdSREngines(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TApdSREngines(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdCustomSapiEngine : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	Adisapi::TDirectSR* FiDirectSR;
	Adisapi::TDirectSS* FiDirectSS;
	TApdCharacterSet FCharSet;
	bool FDictation;
	bool FSpeaking;
	bool FListening;
	System::Word FSRAmplitude;
	int FSRAutoGain;
	TApdTTSOptions FTTSOptions;
	System::Classes::TStringList* FWordList;
	TApdSREngines* FSREngines;
	TApdSSVoices* FSSVoices;
	System::Classes::TList* FPhraseFinishClients;
	HWND FHandle;
	bool FAutoTrain;
	TApdSapiDuplex FDuplex;
	TApdSapiWaitMode FWaitMode;
	bool FInitSR;
	bool FInitSS;
	TApdSRInterferenceEvent FOnInterference;
	TApdSRPhraseFinishEvent FOnPhraseFinish;
	TApdSRPhraseHypothesisEvent FOnPhraseHypothesis;
	TApdSapiNotifyEvent FOnSpeakStart;
	TApdSapiNotifyEvent FOnSpeakStop;
	TApdOnSapiError FOnSRError;
	TApdOnSapiError FOnSRWarning;
	TApdSSAttributeChanged FOnSSAttributeChanged;
	TApdOnSapiError FOnSSError;
	TApdOnSapiError FOnSSWarning;
	TApdSRTrainingRequestedEvent FOnTrainingRequested;
	TApdSRVUMeterEvent FOnVUMeter;
	
protected:
	System::Word __fastcall GetSRAmplitude(void);
	int __fastcall GetSRAutoGain(void);
	void __fastcall InitializeSpeaking(int &CSet, int &Options);
	virtual void __fastcall Loaded(void);
	void __fastcall SetAutoTrain(bool v);
	void __fastcall SetCharSet(TApdCharacterSet v);
	void __fastcall SetDictation(bool v);
	void __fastcall SetDuplex(TApdSapiDuplex v);
	void __fastcall SetInitSR(const bool v);
	void __fastcall SetInitSS(const bool v);
	void __fastcall SetListening(bool v);
	void __fastcall SetSpeaking(bool v);
	void __fastcall SetSRAutoGain(int Value);
	void __fastcall SetTTSOptions(TApdTTSOptions v);
	void __fastcall SetWordList(System::Classes::TStringList* v);
	void __fastcall TriggerAudioStart(System::TObject* Sender, int hi, int lo);
	void __fastcall TriggerAudioStop(System::TObject* Sender, int hi, int lo);
	void __fastcall TriggerInterference(System::TObject* Sender, int beginhi, int beginlo, int endhi, int endlo, int type_);
	void __fastcall TriggerPhraseFinish(System::TObject* Sender, int flags, int beginhi, int beginlo, int endhi, int endlo, const System::WideString Phrase, const System::WideString parsed, int results);
	void __fastcall TriggerPhraseFinishClients(System::UnicodeString Phrase, int Results);
	void __fastcall TriggerPhraseHypothesis(System::TObject* Sender, int flags, int beginhi, int beginlo, int endhi, int endlo, const System::WideString Phrase, int results);
	void __fastcall TriggerSpeakStart(System::TObject* Sender, int beginhi, int beginlo);
	void __fastcall TriggerSpeakStop(System::TObject* Sender, int beginhi, int beginlo, int endhi, int endlo);
	void __fastcall TriggerSRError(System::TObject* Sender, int Error, const System::WideString Details, const System::WideString Message);
	void __fastcall TriggerSRWarning(System::TObject* Sender, int Error, const System::WideString Details, const System::WideString Message);
	void __fastcall TriggerSSAttribChanged(System::TObject* Sender, int Attribute);
	void __fastcall TriggerSSError(System::TObject* Sender, int Error, const System::WideString Details, const System::WideString Message);
	void __fastcall TriggerSSWarning(System::TObject* Sender, int Error, const System::WideString Details, const System::WideString Message);
	void __fastcall TriggerTrainingRequested(System::TObject* Sender, int train);
	void __fastcall TriggerVUMeter(System::TObject* Sender, int beginhi, int beginlo, int level);
	void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TApdCustomSapiEngine(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomSapiEngine(void);
	void __fastcall CheckError(unsigned ErrorCode);
	void __fastcall DeRegisterPhraseFinishHook(TApdPhraseFinishMethod PhraseFinishMethod);
	void __fastcall InitializeSapi(void);
	void __fastcall InitializeSR(void);
	void __fastcall InitializeSS(void);
	bool __fastcall IsSapi4Installed(void);
	void __fastcall Listen(void);
	void __fastcall PauseListening(void);
	void __fastcall PauseSpeaking(void);
	void __fastcall RegisterPhraseFinishHook(TApdPhraseFinishMethod PhraseFinishMethod);
	void __fastcall ResumeListening(void);
	void __fastcall ResumeSpeaking(void);
	void __fastcall ShowAboutDlg(const System::UnicodeString Caption);
	void __fastcall ShowGeneralDlg(const System::UnicodeString Caption);
	void __fastcall ShowLexiconDlg(const System::UnicodeString Caption);
	void __fastcall ShowSRAboutDlg(const System::UnicodeString Caption);
	void __fastcall ShowSRGeneralDlg(const System::UnicodeString Caption);
	void __fastcall ShowSRLexiconDlg(const System::UnicodeString Caption);
	void __fastcall ShowSSAboutDlg(const System::UnicodeString Caption);
	void __fastcall ShowSSGeneralDlg(const System::UnicodeString Caption);
	void __fastcall ShowSSLexiconDlg(const System::UnicodeString Caption);
	void __fastcall ShowTrainGeneralDlg(const System::UnicodeString Caption);
	void __fastcall ShowTrainMicDlg(const System::UnicodeString Caption);
	void __fastcall ShowTranslateDlg(const System::UnicodeString Caption);
	void __fastcall Speak(System::UnicodeString Text);
	void __fastcall SpeakFile(System::UnicodeString FileName);
	void __fastcall SpeakFileToFile(const System::UnicodeString InFile, const System::UnicodeString OutFile);
	void __fastcall SpeakStream(System::Classes::TStream* Stream, System::UnicodeString FileName);
	void __fastcall SpeakToFile(const System::UnicodeString Text, const System::UnicodeString FileName);
	void __fastcall StopListening(void);
	void __fastcall StopSpeaking(void);
	void __fastcall WaitUntilDoneSpeaking(void);
	__property Adisapi::TDirectSR* DirectSR = {read=FiDirectSR, write=FiDirectSR};
	__property Adisapi::TDirectSS* DirectSS = {read=FiDirectSS, write=FiDirectSS};
	__property bool InitSR = {read=FInitSR, write=SetInitSR, default=1};
	__property bool InitSS = {read=FInitSS, write=SetInitSS, default=1};
	__property bool Listening = {read=FListening, write=SetListening, nodefault};
	__property bool Speaking = {read=FSpeaking, write=SetSpeaking, nodefault};
	__property TApdSREngines* SREngines = {read=FSREngines, write=FSREngines};
	__property TApdSSVoices* SSVoices = {read=FSSVoices, write=FSSVoices};
	
__published:
	__property bool AutoTrain = {read=FAutoTrain, write=SetAutoTrain, default=0};
	__property TApdCharacterSet CharSet = {read=FCharSet, write=SetCharSet, nodefault};
	__property bool Dictation = {read=FDictation, write=SetDictation, nodefault};
	__property TApdSapiDuplex Duplex = {read=FDuplex, write=SetDuplex, default=2};
	__property System::Word SRAmplitude = {read=GetSRAmplitude, nodefault};
	__property int SRAutoGain = {read=GetSRAutoGain, write=SetSRAutoGain, nodefault};
	__property TApdTTSOptions TTSOptions = {read=FTTSOptions, write=SetTTSOptions, nodefault};
	__property System::Classes::TStringList* WordList = {read=FWordList, write=SetWordList};
	__property TApdSRInterferenceEvent OnInterference = {read=FOnInterference, write=FOnInterference};
	__property TApdSRPhraseFinishEvent OnPhraseFinish = {read=FOnPhraseFinish, write=FOnPhraseFinish};
	__property TApdSRPhraseHypothesisEvent OnPhraseHypothesis = {read=FOnPhraseHypothesis, write=FOnPhraseHypothesis};
	__property TApdSapiNotifyEvent OnSpeakStart = {read=FOnSpeakStart, write=FOnSpeakStart};
	__property TApdSapiNotifyEvent OnSpeakStop = {read=FOnSpeakStop, write=FOnSpeakStop};
	__property TApdOnSapiError OnSRError = {read=FOnSRError, write=FOnSRError};
	__property TApdOnSapiError OnSRWarning = {read=FOnSRWarning, write=FOnSRWarning};
	__property TApdSSAttributeChanged OnSSAttributeChanged = {read=FOnSSAttributeChanged, write=FOnSSAttributeChanged};
	__property TApdOnSapiError OnSSError = {read=FOnSSError, write=FOnSSError};
	__property TApdOnSapiError OnSSWarning = {read=FOnSSWarning, write=FOnSSWarning};
	__property TApdSRTrainingRequestedEvent OnTrainingRequested = {read=FOnTrainingRequested, write=FOnTrainingRequested};
	__property TApdSRVUMeterEvent OnVUMeter = {read=FOnVUMeter, write=FOnVUMeter};
};


class PASCALIMPLEMENTATION TApdSapiEngine : public TApdCustomSapiEngine
{
	typedef TApdCustomSapiEngine inherited;
	
__published:
	__property CharSet;
	__property Dictation;
	__property SRAmplitude;
	__property SRAutoGain;
	__property TTSOptions;
	__property WordList;
	__property OnInterference;
	__property OnPhraseFinish;
	__property OnPhraseHypothesis;
	__property OnSpeakStart;
	__property OnSpeakStop;
	__property OnSRError;
	__property OnSRWarning;
	__property OnSSAttributeChanged;
	__property OnSSError;
	__property OnSSWarning;
	__property OnTrainingRequested;
	__property OnVUMeter;
public:
	/* TApdCustomSapiEngine.Create */ inline __fastcall virtual TApdSapiEngine(System::Classes::TComponent* AOwner) : TApdCustomSapiEngine(AOwner) { }
	/* TApdCustomSapiEngine.Destroy */ inline __fastcall virtual ~TApdSapiEngine(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 ApdCHARSET_TEXT = System::Int8(0x0);
static const System::Int8 ApdCHARSET_IPAPHONETIC = System::Int8(0x1);
static const System::Int8 ApdCHARSET_ENGINEPHONETIC = System::Int8(0x2);
static const System::Int8 ApdTTSDATAFLAG_TAGGED = System::Int8(0x1);
static const System::Int8 ApdTTSAGE_BABY = System::Int8(0x1);
static const System::Int8 ApdTTSAGE_TODDLER = System::Int8(0x3);
static const System::Int8 ApdTTSAGE_CHILD = System::Int8(0x6);
static const System::Int8 ApdTTSAGE_ADOLESCENT = System::Int8(0xe);
static const System::Int8 ApdTTSAGE_ADULT = System::Int8(0x1e);
static const System::Int8 ApdTTSAGE_ELDERLY = System::Int8(0x46);
static const System::Int8 ApdTTSFEATURE_ANYWORD = System::Int8(0x1);
static const System::Int8 ApdTTSFEATURE_VOLUME = System::Int8(0x2);
static const System::Int8 ApdTTSFEATURE_SPEED = System::Int8(0x4);
static const System::Int8 ApdTTSFEATURE_PITCH = System::Int8(0x8);
static const System::Int8 ApdTTSFEATURE_TAGGED = System::Int8(0x10);
static const System::Int8 ApdTTSFEATURE_IPAUNICODE = System::Int8(0x20);
static const System::Int8 ApdTTSFEATURE_VISUAL = System::Int8(0x40);
static const System::Byte ApdTTSFEATURE_WORDPOSITION = System::Byte(0x80);
static const System::Word ApdTTSFEATURE_PCOPTIMIZED = System::Word(0x100);
static const System::Word ApdTTSFEATURE_PHONEOPTIMIZED = System::Word(0x200);
static const System::Word ApdTTSFEATURE_FIXEDAUDIO = System::Word(0x400);
static const System::Word ApdTTSFEATURE_SINGLEINSTANCE = System::Word(0x800);
static const System::Word ApdTTSFEATURE_THREADSAFE = System::Word(0x1000);
static const System::Word ApdTTSFEATURE_IPATEXTDATA = System::Word(0x2000);
static const System::Word ApdTTSFEATURE_PREFERRED = System::Word(0x4000);
static const System::Word ApdTTSFEATURE_TRANSPLANTED = System::Word(0x8000);
static const int ApdTTSFEATURE_SAPI4 = int(0x10000);
static const System::Int8 ApdGENDER_NEUTRAL = System::Int8(0x0);
static const System::Int8 ApdGENDER_FEMALE = System::Int8(0x1);
static const System::Int8 ApdGENDER_MALE = System::Int8(0x2);
static const System::Int8 ApdTTSI_ILEXPRONOUNCE = System::Int8(0x1);
static const System::Int8 ApdTTSI_ITTSATTRIBUTES = System::Int8(0x2);
static const System::Int8 ApdTTSI_ITTSCENTRAL = System::Int8(0x4);
static const System::Int8 ApdTTSI_ITTSDIALOGS = System::Int8(0x8);
static const System::Int8 ApdTTSI_ATTRIBUTES = System::Int8(0x10);
static const System::Int8 ApdTTSI_IATTRIBUTES = System::Int8(0x10);
static const System::Int8 ApdTTSI_ILEXPRONOUNCE2 = System::Int8(0x20);
static const System::Int8 ApdSRFEATURE_INDEPSPEAKER = System::Int8(0x1);
static const System::Int8 ApdSRFEATURE_INDEPMICROPHONE = System::Int8(0x2);
static const System::Int8 ApdSRFEATURE_TRAINWORD = System::Int8(0x4);
static const System::Int8 ApdSRFEATURE_TRAINPHONETIC = System::Int8(0x8);
static const System::Int8 ApdSRFEATURE_WILDCARD = System::Int8(0x10);
static const System::Int8 ApdSRFEATURE_ANYWORD = System::Int8(0x20);
static const System::Int8 ApdSRFEATURE_PCOPTIMIZED = System::Int8(0x40);
static const System::Byte ApdSRFEATURE_PHONEOPTIMIZED = System::Byte(0x80);
static const System::Word ApdSRFEATURE_GRAMLIST = System::Word(0x100);
static const System::Word ApdSRFEATURE_GRAMLINK = System::Word(0x200);
static const System::Word ApdSRFEATURE_MULTILINGUAL = System::Word(0x400);
static const System::Word ApdSRFEATURE_GRAMRECURSIVE = System::Word(0x800);
static const System::Word ApdSRFEATURE_IPAUNICODE = System::Word(0x1000);
static const System::Word ApdSRFEATURE_SINGLEINSTANCE = System::Word(0x2000);
static const System::Word ApdSRFEATURE_THREADSAFE = System::Word(0x4000);
static const System::Word ApdSRFEATURE_FIXEDAUDIO = System::Word(0x8000);
static const int ApdSRFEATURE_IPAWORD = int(0x10000);
static const int ApdSRFEATURE_SAPI4 = int(0x20000);
static const System::Int8 ApdSRGRAM_CFG = System::Int8(0x1);
static const System::Int8 ApdSRGRAM_DICTATION = System::Int8(0x2);
static const System::Int8 ApdSRGRAM_LIMITEDDOMAIN = System::Int8(0x4);
static const System::Int8 ApdSRI_ILEXPRONOUNCE = System::Int8(0x1);
static const System::Int8 ApdSRI_ISRATTRIBUTES = System::Int8(0x2);
static const System::Int8 ApdSRI_ISRCENTRAL = System::Int8(0x4);
static const System::Int8 ApdSRI_ISRDIALOGS = System::Int8(0x8);
static const System::Int8 ApdSRI_ISRGRAMCOMMON = System::Int8(0x10);
static const System::Int8 ApdSRI_ISRGRAMCFG = System::Int8(0x20);
static const System::Int8 ApdSRI_ISRGRAMDICTATION = System::Int8(0x40);
static const System::Byte ApdSRI_ISRGRAMINSERTIONGUI = System::Byte(0x80);
static const System::Word ApdSRI_ISRESBASIC = System::Word(0x100);
static const System::Word ApdSRI_ISRESMERGE = System::Word(0x200);
static const System::Word ApdSRI_ISRESAUDIO = System::Word(0x400);
static const System::Word ApdSRI_ISRESCORRECTION = System::Word(0x800);
static const System::Word ApdSRI_ISRESEVAL = System::Word(0x1000);
static const System::Word ApdSRI_ISRESGRAPH = System::Word(0x2000);
static const System::Word ApdSRI_ISRESMEMORY = System::Word(0x4000);
static const System::Word ApdSRI_ISRESMODIFYGUI = System::Word(0x8000);
static const int ApdSRI_ISRESSPEAKER = int(0x10000);
static const int ApdSRI_ISRSPEAKER = int(0x20000);
static const int ApdSRI_ISRESSCORES = int(0x40000);
static const int ApdSRI_ISRESAUDIOEX = int(0x80000);
static const int ApdSRI_ISRGRAMLEXPRON = int(0x100000);
static const int ApdSRI_ISRRESGRAPHEX = int(0x200000);
static const int ApdSRI_ILEXPRONOUNCE2 = int(0x400000);
static const int ApdSRI_IATTRIBUTES = int(0x800000);
static const int ApdSRI_ISRSPEAKER2 = int(0x1000000);
static const int ApdSRI_ISRDIALOGS2 = int(0x2000000);
static const System::Int8 ApdSRSEQUENCE_DISCRETE = System::Int8(0x0);
static const System::Int8 ApdSRSEQUENCE_CONTINUOUS = System::Int8(0x1);
static const System::Int8 ApdSRSEQUENCE_WORDSPOT = System::Int8(0x2);
static const System::Int8 ApdSRSEQUENCE_CONTCFGDISCDICT = System::Int8(0x3);
static const System::Int8 ApdSRMSGINT_NOISE = System::Int8(0x1);
static const System::Int8 ApdSRMSGINT_NOSIGNAL = System::Int8(0x2);
static const System::Int8 ApdSRMSGINT_TOOLOUD = System::Int8(0x3);
static const System::Int8 ApdSRMSGINT_TOOQUIET = System::Int8(0x4);
static const System::Int8 ApdSRMSGINT_AUDIODATA_STOPPED = System::Int8(0x5);
static const System::Int8 ApdSRMSGINT_AUDIODATA_STARTED = System::Int8(0x6);
static const System::Int8 ApdSRMSGINT_IAUDIO_STARTED = System::Int8(0x7);
static const System::Int8 ApdSRMSGINT_IAUDIO_STOPPED = System::Int8(0x8);
static const System::Int8 ApdSRGNSTRAIN_GENERAL = System::Int8(0x1);
static const System::Int8 ApdSRGNSTRAIN_GRAMMAR = System::Int8(0x2);
static const System::Int8 ApdSRGNSTRAIN_MICROPHONE = System::Int8(0x4);
static const System::Int8 ApdTTSERR_NONE = System::Int8(0x0);
static const unsigned ApdTTSERR_INVALIDINTERFACE = unsigned(0x80004002);
static const unsigned ApdTTSERR_OUTOFDISK = unsigned(0x80040205);
static const unsigned ApdTTSERR_NOTSUPPORTED = unsigned(0x80004001);
static const unsigned ApdTTSERR_VALUEOUTOFRANGE = unsigned(0x8000ffff);
static const unsigned ApdTTSERR_INVALIDWINDOW = unsigned(0x8004000f);
static const unsigned ApdTTSERR_INVALIDPARAM = unsigned(0x80070057);
static const unsigned ApdTTSERR_INVALIDMODE = unsigned(0x80040206);
static const unsigned ApdTTSERR_INVALIDKEY = unsigned(0x80040209);
static const unsigned ApdTTSERR_WAVEFORMATNOTSUPPORTED = unsigned(0x80040202);
static const unsigned ApdTTSERR_INVALIDCHAR = unsigned(0x80040208);
static const unsigned ApdTTSERR_QUEUEFULL = unsigned(0x8004020a);
static const unsigned ApdTTSERR_WAVEDEVICEBUSY = unsigned(0x80040203);
static const unsigned ApdTTSERR_NOTPAUSED = unsigned(0x80040501);
static const unsigned ApdTTSERR_ALREADYPAUSED = unsigned(0x80040502);
static const System::Int8 ApdSRERR_NONE = System::Int8(0x0);
static const unsigned ApdSRERR_OUTOFDISK = unsigned(0x80040205);
static const unsigned ApdSRERR_NOTSUPPORTED = unsigned(0x80004001);
static const unsigned ApdSRERR_NOTENOUGHDATA = unsigned(0x80040201);
static const unsigned ApdSRERR_VALUEOUTOFRANGE = unsigned(0x8000ffff);
static const unsigned ApdSRERR_GRAMMARTOOCOMPLEX = unsigned(0x80040406);
static const unsigned ApdSRERR_GRAMMARWRONGTYPE = unsigned(0x80040407);
static const unsigned ApdSRERR_INVALIDWINDOW = unsigned(0x8004000f);
static const unsigned ApdSRERR_INVALIDPARAM = unsigned(0x80070057);
static const unsigned ApdSRERR_INVALIDMODE = unsigned(0x80040206);
static const unsigned ApdSRERR_TOOMANYGRAMMARS = unsigned(0x8004040b);
static const unsigned ApdSRERR_INVALIDLIST = unsigned(0x80040207);
static const unsigned ApdSRERR_WAVEDEVICEBUSY = unsigned(0x80040203);
static const unsigned ApdSRERR_WAVEFORMATNOTSUPPORTED = unsigned(0x80040202);
static const unsigned ApdSRERR_INVALIDCHAR = unsigned(0x80040208);
static const unsigned ApdSRERR_GRAMTOOCOMPLEX = unsigned(0x80040406);
static const unsigned ApdSRERR_GRAMTOOLARGE = unsigned(0x80040411);
static const unsigned ApdSRERR_INVALIDINTERFACE = unsigned(0x80004002);
static const unsigned ApdSRERR_INVALIDKEY = unsigned(0x80040209);
static const unsigned ApdSRERR_INVALIDFLAG = unsigned(0x80040204);
static const unsigned ApdSRERR_GRAMMARERROR = unsigned(0x80040416);
static const unsigned ApdSRERR_INVALIDRULE = unsigned(0x80040417);
static const unsigned ApdSRERR_RULEALREADYACTIVE = unsigned(0x80040418);
static const unsigned ApdSRERR_RULENOTACTIVE = unsigned(0x80040419);
static const unsigned ApdSRERR_NOUSERSELECTED = unsigned(0x8004041a);
static const unsigned ApdSRERR_BAD_PRONUNCIATION = unsigned(0x8004041b);
static const unsigned ApdSRERR_DATAFILEERROR = unsigned(0x8004041c);
static const unsigned ApdSRERR_GRAMMARALREADYACTIVE = unsigned(0x8004041d);
static const unsigned ApdSRERR_GRAMMARNOTACTIVE = unsigned(0x8004041e);
static const unsigned ApdSRERR_GLOBALGRAMMARALREADYACTIVE = unsigned(0x8004041f);
static const unsigned ApdSRERR_LANGUAGEMISMATCH = unsigned(0x80040420);
static const unsigned ApdSRERR_MULTIPLELANG = unsigned(0x80040421);
static const unsigned ApdSRERR_LDGRAMMARNOWORDS = unsigned(0x80040422);
static const unsigned ApdSRERR_NOLEXICON = unsigned(0x80040423);
static const unsigned ApdSRERR_SPEAKEREXISTS = unsigned(0x80040424);
static const unsigned ApdSRERR_GRAMMARENGINEMISMATCH = unsigned(0x80040425);
static const unsigned ApdSRERR_BOOKMARKEXISTS = unsigned(0x80040426);
static const unsigned ApdSRERR_BOOKMARKDOESNOTEXIST = unsigned(0x80040427);
static const unsigned ApdSRERR_MICWIZARDCANCELED = unsigned(0x80040428);
static const unsigned ApdSRERR_WORDTOOLONG = unsigned(0x80040429);
static const unsigned ApdSRERR_BAD_WORD = unsigned(0x8004042a);
static const unsigned ApdE_WRONGTYPE = unsigned(0x8004020c);
static const unsigned ApdE_BUFFERTOOSMALL = unsigned(0x8004020d);
extern DELPHI_PACKAGE TApdCustomSapiEngine* __fastcall SearchSapiEngine(System::Classes::TComponent* const C);
}	/* namespace Adsapien */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSAPIEN)
using namespace Adsapien;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdsapienHPP
