// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdISapi.pas' rev: 32.00 (Windows)

#ifndef AdisapiHPP
#define AdisapiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.OleCtrls.hpp>
#include <Vcl.OleServer.hpp>
#include <System.Win.StdVCL.hpp>
#include <System.Variants.hpp>
#include <Winapi.Windows.hpp>
#include <OoMisc.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adisapi
{
//-- forward type declarations -----------------------------------------------
struct SDATA;
struct LANGUAGEW;
struct SRPHRASEW;
__interface IAudioMultiMediaDevice;
typedef System::DelphiInterface<IAudioMultiMediaDevice> _di_IAudioMultiMediaDevice;
__interface IAudioTel;
typedef System::DelphiInterface<IAudioTel> _di_IAudioTel;
__interface IDirectSR;
typedef System::DelphiInterface<IDirectSR> _di_IDirectSR;
__interface IDirectSS;
typedef System::DelphiInterface<IDirectSS> _di_IDirectSS;
class DELPHICLASS TDirectSR;
class DELPHICLASS TDirectSS;
//-- type declarations -------------------------------------------------------
typedef __int64 QWORD;

typedef int LongWord;

struct DECLSPEC_DRECORD SDATA
{
public:
	void *pData;
	unsigned dwSize;
};


typedef SDATA TSData;

typedef LANGUAGEW *PLanguageW;

struct DECLSPEC_DRECORD LANGUAGEW
{
public:
	System::Word LanguageID;
	System::StaticArray<System::WideChar, 64> szDialect;
};


typedef LANGUAGEW TLanguageW;

typedef unsigned SRGRMFMT;

typedef SRPHRASEW *PSRPhraseW;

struct DECLSPEC_DRECORD SRPHRASEW
{
	
private:
	struct DECLSPEC_DRECORD _SRPHRASEW__1
	{
	};
	
	
	
public:
	unsigned dwSize;
	_SRPHRASEW__1 abWords;
};


typedef SRPHRASEW TSRPhraseW;

typedef void __fastcall (__closure *TDirectSRClickIn)(System::TObject* Sender, int x, int y);

typedef void __fastcall (__closure *TDirectSRClickOut)(System::TObject* Sender, int x, int y);

typedef void __fastcall (__closure *TDirectSRPhraseFinish)(System::TObject* Sender, int flags, int beginhi, int beginlo, int endhi, int endlo, const System::WideString Phrase, const System::WideString parsed, int results);

typedef void __fastcall (__closure *TDirectSRPhraseStart)(System::TObject* Sender, int hi, int lo);

typedef void __fastcall (__closure *TDirectSRBookMark)(System::TObject* Sender, int MarkID);

typedef void __fastcall (__closure *TDirectSRPhraseHypothesis)(System::TObject* Sender, int flags, int beginhi, int beginlo, int endhi, int endlo, const System::WideString Phrase, int results);

typedef void __fastcall (__closure *TDirectSRReEvaluate)(System::TObject* Sender, int results);

typedef void __fastcall (__closure *TDirectSRTraining)(System::TObject* Sender, int train);

typedef void __fastcall (__closure *TDirectSRUnArchive)(System::TObject* Sender, int results);

typedef void __fastcall (__closure *TDirectSRAttribChanged)(System::TObject* Sender, int Attribute);

typedef void __fastcall (__closure *TDirectSRInterference)(System::TObject* Sender, int beginhi, int beginlo, int endhi, int endlo, int type_);

typedef void __fastcall (__closure *TDirectSRSound)(System::TObject* Sender, int beginhi, int beginlo, int endhi, int endlo);

typedef void __fastcall (__closure *TDirectSRUtteranceBegin)(System::TObject* Sender, int beginhi, int beginlo);

typedef void __fastcall (__closure *TDirectSRUtteranceEnd)(System::TObject* Sender, int beginhi, int beginlo, int endhi, int endlo);

typedef void __fastcall (__closure *TDirectSRVUMeter)(System::TObject* Sender, int beginhi, int beginlo, int level);

typedef void __fastcall (__closure *TDirectSRError)(System::TObject* Sender, int warning, const System::WideString Details, const System::WideString Message);

typedef void __fastcall (__closure *TDirectSRwarning)(System::TObject* Sender, int warning, const System::WideString Details, const System::WideString Message);

typedef void __fastcall (__closure *TDirectSSClickIn)(System::TObject* Sender, int x, int y);

typedef void __fastcall (__closure *TDirectSSClickOut)(System::TObject* Sender, int x, int y);

typedef void __fastcall (__closure *TDirectSSAudioStart)(System::TObject* Sender, int hi, int lo);

typedef void __fastcall (__closure *TDirectSSAudioStop)(System::TObject* Sender, int hi, int lo);

typedef void __fastcall (__closure *TDirectSSAttribChanged)(System::TObject* Sender, int which_attribute);

typedef void __fastcall (__closure *TDirectSSVisual)(System::TObject* Sender, int timehi, int timelo, short Phoneme, short EnginePhoneme, int hints, short MouthHeight, short bMouthWidth, short bMouthUpturn, short bJawOpen, short TeethUpperVisible, short TeethLowerVisible, short TonguePosn, short LipTension);

typedef void __fastcall (__closure *TDirectSSWordPosition)(System::TObject* Sender, int hi, int lo, int byteoffset);

typedef void __fastcall (__closure *TDirectSSBookMark)(System::TObject* Sender, int hi, int lo, int MarkNum);

typedef void __fastcall (__closure *TDirectSSTextDataStarted)(System::TObject* Sender, int hi, int lo);

typedef void __fastcall (__closure *TDirectSSTextDataDone)(System::TObject* Sender, int hi, int lo, int Flags);

typedef void __fastcall (__closure *TDirectSSActiveVoiceStartup)(System::TObject* Sender, int init, int init2);

typedef void __fastcall (__closure *TDirectSSError)(System::TObject* Sender, int warning, const System::WideString Details, const System::WideString Message);

typedef void __fastcall (__closure *TDirectSSwarning)(System::TObject* Sender, int warning, const System::WideString Details, const System::WideString Message);

typedef void __fastcall (__closure *TDirectSSVisualFuture)(System::TObject* Sender, int milliseconds, int timehi, int timelo, short Phoneme, short EnginePhoneme, int hints, short MouthHeight, short bMouthWidth, short bMouthUpturn, short bJawOpen, short TeethUpperVisible, short TeethLowerVisible, short TonguePosn, short LipTension);

__interface  INTERFACE_UUID("{B68AD320-C743-11CD-80E5-00AA003E4B50}") IAudioMultiMediaDevice  : public System::IInterface 
{
	virtual HRESULT __stdcall CustomMessage(unsigned uMsg, const SDATA dData) = 0 ;
	virtual HRESULT __stdcall DeviceNumGet(unsigned &dwDeviceID) = 0 ;
	virtual HRESULT __stdcall DeviceNumSet(unsigned dwDeviceID) = 0 ;
};

typedef _di_IAudioMultiMediaDevice *PIAUDIOMULTIMEDIADEVICE;

__interface  INTERFACE_UUID("{2EC5A8A7-E65B-11D0-8FAC-08002BE4E62A}") IAudioTel  : public System::IInterface 
{
	virtual HRESULT __stdcall AudioObject(System::_di_IInterface AudioObject) = 0 ;
	virtual HRESULT __stdcall WaveFormatSet(const SDATA dWFEX) = 0 ;
};

typedef _di_IAudioTel *PIAUDIOTEL;

typedef _di_IDirectSR DirectSR;

typedef _di_IDirectSS DirectSS;

typedef System::_di_IInterface VoiceProp;

typedef int *PInteger1;

typedef System::WideString *PWideString1;

__interface  INTERFACE_UUID("{4E3D9D1E-0C63-11D1-8BFB-0060081841DE}") IDirectSR  : public IDispatch 
{
	virtual HRESULT __safecall Get_debug(short &__Get_debug_result) = 0 ;
	virtual HRESULT __safecall Set_debug(short pVal) = 0 ;
	virtual HRESULT __safecall Get_Initialized(short &__Get_Initialized_result) = 0 ;
	virtual HRESULT __safecall Set_Initialized(short pVal) = 0 ;
	virtual HRESULT __safecall Deactivate(void) = 0 ;
	virtual HRESULT __safecall Activate(void) = 0 ;
	virtual HRESULT __safecall Get_LastHeard(System::WideString &__Get_LastHeard_result) = 0 ;
	virtual HRESULT __safecall Set_LastHeard(const System::WideString pVal) = 0 ;
	virtual HRESULT __safecall GrammarFromString(const System::WideString grammar) = 0 ;
	virtual HRESULT __safecall GrammarFromFile(const System::WideString FileName) = 0 ;
	virtual HRESULT __safecall GrammarFromResource(int Instance, int ResID) = 0 ;
	virtual HRESULT __safecall GrammarFromStream(int Stream) = 0 ;
	virtual HRESULT __safecall Get_AutoGain(int &__Get_AutoGain_result) = 0 ;
	virtual HRESULT __safecall Set_AutoGain(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MinAutoGain(int &__Get_MinAutoGain_result) = 0 ;
	virtual HRESULT __safecall Get_MaxAutoGain(int &__Get_MaxAutoGain_result) = 0 ;
	virtual HRESULT __safecall Get_Echo(short &__Get_Echo_result) = 0 ;
	virtual HRESULT __safecall Set_Echo(short pVal) = 0 ;
	virtual HRESULT __safecall Get_EnergyFloor(int &__Get_EnergyFloor_result) = 0 ;
	virtual HRESULT __safecall Set_EnergyFloor(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxEnergyFloor(int &__Get_MaxEnergyFloor_result) = 0 ;
	virtual HRESULT __safecall Get_MinEnergyFloor(int &__Get_MinEnergyFloor_result) = 0 ;
	virtual HRESULT __safecall Get_Microphone(System::WideString &__Get_Microphone_result) = 0 ;
	virtual HRESULT __safecall Set_Microphone(const System::WideString pVal) = 0 ;
	virtual HRESULT __safecall Get_Speaker(System::WideString &__Get_Speaker_result) = 0 ;
	virtual HRESULT __safecall Set_Speaker(const System::WideString pVal) = 0 ;
	virtual HRESULT __safecall Get_RealTime(int &__Get_RealTime_result) = 0 ;
	virtual HRESULT __safecall Set_RealTime(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxRealTime(int &__Get_MaxRealTime_result) = 0 ;
	virtual HRESULT __safecall Get_MinRealTime(int &__Get_MinRealTime_result) = 0 ;
	virtual HRESULT __safecall Get_Threshold(int &__Get_Threshold_result) = 0 ;
	virtual HRESULT __safecall Set_Threshold(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxThreshold(int &__Get_MaxThreshold_result) = 0 ;
	virtual HRESULT __safecall Get_MinThreshold(int &__Get_MinThreshold_result) = 0 ;
	virtual HRESULT __safecall Get_CompleteTimeOut(int &__Get_CompleteTimeOut_result) = 0 ;
	virtual HRESULT __safecall Set_CompleteTimeOut(int pVal) = 0 ;
	virtual HRESULT __safecall Get_IncompleteTimeOut(int &__Get_IncompleteTimeOut_result) = 0 ;
	virtual HRESULT __safecall Set_IncompleteTimeOut(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxCompleteTimeOut(int &__Get_MaxCompleteTimeOut_result) = 0 ;
	virtual HRESULT __safecall Get_MinCompleteTimeOut(int &__Get_MinCompleteTimeOut_result) = 0 ;
	virtual HRESULT __safecall Get_MaxIncompleteTimeOut(int &__Get_MaxIncompleteTimeOut_result) = 0 ;
	virtual HRESULT __safecall Get_MinIncompleteTimeOut(int &__Get_MinIncompleteTimeOut_result) = 0 ;
	virtual HRESULT __safecall Pause(void) = 0 ;
	virtual HRESULT __safecall Resume(void) = 0 ;
	virtual HRESULT __safecall PosnGet(/* out */ int &hi, /* out */ int &lo) = 0 ;
	virtual HRESULT __safecall AboutDlg(int hwnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall GeneralDlg(int hwnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall LexiconDlg(int hwnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall TrainGeneralDlg(int hwnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall TrainMicDlg(int hwnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall Get_Wave(int results, int &__Get_Wave_result) = 0 ;
	virtual HRESULT __safecall Get_Phrase(int results, int rank, System::WideString &__Get_Phrase_result) = 0 ;
	virtual HRESULT __safecall Get_CreateResultsObject(int results, int &__Get_CreateResultsObject_result) = 0 ;
	virtual HRESULT __safecall DestroyResultsObject(int resobj) = 0 ;
	virtual HRESULT __safecall Select(int index) = 0 ;
	virtual HRESULT __safecall Listen(void) = 0 ;
	virtual HRESULT __safecall SelectEngine(int index) = 0 ;
	virtual HRESULT __safecall FindEngine(const System::WideString EngineId, const System::WideString MfgName, const System::WideString ProductName, const System::WideString ModeID, const System::WideString ModeName, int LanguageID, const System::WideString dialect, int Sequencing, int MaxWordsVocab, int MaxWordsState, int Grammars, int Features, int Interfaces, int EngineFeatures, int RankEngineID, int RankMfgName, int RankProductName, int RankModeID, int RankModeName, int RankLanguage, int RankDialect, int RankSequencing, int RankMaxWordsVocab, int RankMaxWordsState, int RankGrammars, int RankFeatures, int RankInterfaces, int RankEngineFeatures, int &__FindEngine_result) = 0 ;
	virtual HRESULT __safecall Get_CountEngines(int &__Get_CountEngines_result) = 0 ;
	virtual HRESULT __safecall ModeName(int index, System::WideString &__ModeName_result) = 0 ;
	virtual HRESULT __safecall EngineId(int index, System::WideString &__EngineId_result) = 0 ;
	virtual HRESULT __safecall MfgName(int index, System::WideString &__MfgName_result) = 0 ;
	virtual HRESULT __safecall ProductName(int index, System::WideString &__ProductName_result) = 0 ;
	virtual HRESULT __safecall ModeID(int index, System::WideString &__ModeID_result) = 0 ;
	virtual HRESULT __safecall Features(int index, int &__Features_result) = 0 ;
	virtual HRESULT __safecall Interfaces(int index, int &__Interfaces_result) = 0 ;
	virtual HRESULT __safecall EngineFeatures(int index, int &__EngineFeatures_result) = 0 ;
	virtual HRESULT __safecall LanguageID(int index, int &__LanguageID_result) = 0 ;
	virtual HRESULT __safecall dialect(int index, System::WideString &__dialect_result) = 0 ;
	virtual HRESULT __safecall Sequencing(int index, int &__Sequencing_result) = 0 ;
	virtual HRESULT __safecall MaxWordsVocab(int index, int &__MaxWordsVocab_result) = 0 ;
	virtual HRESULT __safecall MaxWordsState(int index, int &__MaxWordsState_result) = 0 ;
	virtual HRESULT __safecall Grammars(int index, int &__Grammars_result) = 0 ;
	virtual HRESULT __safecall InitAudioSourceDirect(int direct) = 0 ;
	virtual HRESULT __safecall InitAudioSourceObject(int object_) = 0 ;
	virtual HRESULT __safecall Get_FileName(System::WideString &__Get_FileName_result) = 0 ;
	virtual HRESULT __safecall Set_FileName(const System::WideString pVal) = 0 ;
	virtual HRESULT __safecall Get_FlagsGet(int results, int rank, int &__Get_FlagsGet_result) = 0 ;
	virtual HRESULT __safecall Get_Identify(int results, System::WideString &__Get_Identify_result) = 0 ;
	virtual HRESULT __safecall TimeGet(int results, int &beginhi, int &beginlo, int &endhi, int &endlo) = 0 ;
	virtual HRESULT __safecall Correction(int results, const System::WideString Phrase, short confidence) = 0 ;
	virtual HRESULT __safecall Validate(int results, short confidence) = 0 ;
	virtual HRESULT __safecall Get_ReEvaluate(int results, int &__Get_ReEvaluate_result) = 0 ;
	virtual HRESULT __safecall Get_GetPhraseScore(int results, int rank, int &__Get_GetPhraseScore_result) = 0 ;
	virtual HRESULT __safecall Archive(int keepresults, /* out */ int &size, /* out */ int &pVal) = 0 ;
	virtual HRESULT __safecall DeleteArchive(int Archive) = 0 ;
	virtual HRESULT __safecall GrammarFromMemory(int grammar, int size) = 0 ;
	virtual HRESULT __safecall GrammarDataSet(int Data, int size) = 0 ;
	virtual HRESULT __safecall GrammarToMemory(int &grammar, int &size) = 0 ;
	virtual HRESULT __safecall ActivateAndAssignWindow(int hwnd) = 0 ;
	virtual HRESULT __safecall Get_LastError(int &__Get_LastError_result) = 0 ;
	virtual HRESULT __safecall Set_LastError(int pVal) = 0 ;
	virtual HRESULT __safecall Get_SuppressExceptions(int &__Get_SuppressExceptions_result) = 0 ;
	virtual HRESULT __safecall Set_SuppressExceptions(int pVal) = 0 ;
	virtual HRESULT __safecall Get_hwnd(int &__Get_hwnd_result) = 0 ;
	virtual HRESULT __safecall Find(const System::WideString RankList, int &__Find_result) = 0 ;
	virtual HRESULT __safecall Get_SRMode(int &__Get_SRMode_result) = 0 ;
	virtual HRESULT __safecall Set_SRMode(int pVal) = 0 ;
	virtual HRESULT __safecall Get_GetAllArcStrings(int punk, int results, System::WideString &__Get_GetAllArcStrings_result) = 0 ;
	virtual HRESULT __safecall Get_Attributes(int Attrib, int &__Get_Attributes_result) = 0 ;
	virtual HRESULT __safecall Set_Attributes(int Attrib, int pVal) = 0 ;
	virtual HRESULT __safecall Get_AttributeString(int Attrib, System::WideString &__Get_AttributeString_result) = 0 ;
	virtual HRESULT __safecall Set_AttributeString(int Attrib, const System::WideString pVal) = 0 ;
	virtual HRESULT __safecall Get_AttributeMemory(int Attrib, int &size, int &__Get_AttributeMemory_result) = 0 ;
	virtual HRESULT __safecall Set_AttributeMemory(int Attrib, int &size, int pVal) = 0 ;
	virtual HRESULT __safecall Get_WaveEx(int results, int beginhi, int beginlo, int endhi, int endlo, int &__Get_WaveEx_result) = 0 ;
	virtual HRESULT __safecall Get_NodeStart(int results, int &__Get_NodeStart_result) = 0 ;
	virtual HRESULT __safecall Get_NodeEnd(int results, int &__Get_NodeEnd_result) = 0 ;
	virtual HRESULT __safecall ArcEnum(int results, int node, int Outgoing, int &nodelist, int &countnodes) = 0 ;
	virtual HRESULT __safecall BestPathEnum(int results, int rank, int &startpath, int startpathsteps, int &endpath, int endpathsteps, int exactmatch, int &arclist, int &arccount) = 0 ;
	virtual HRESULT __safecall Get_DataGetString(int results, int id, const System::WideString Attrib, System::WideString &__Get_DataGetString_result) = 0 ;
	virtual HRESULT __safecall DataGetTime(int results, int id, const System::WideString Attrib, int &hi, int &lo) = 0 ;
	virtual HRESULT __safecall Get_score(int results, int scoretype, int &path, int pathsteps, int pathindexstart, int pathindexcount, int &__Get_score_result) = 0 ;
	virtual HRESULT __safecall GetAllArcs(int results, int &arcids, int &arccount) = 0 ;
	virtual HRESULT __safecall GetAllNodes(int results, int &Nodes, int &countnodes) = 0 ;
	virtual HRESULT __safecall Get_NodeGet(int results, int arc, int destination, int &__Get_NodeGet_result) = 0 ;
	virtual HRESULT __safecall Get_GraphDWORDGet(int results, int id, const System::WideString Attrib, int &__Get_GraphDWORDGet_result) = 0 ;
	virtual HRESULT __safecall RenameSpeaker(const System::WideString OldName, const System::WideString newName) = 0 ;
	virtual HRESULT __safecall DeleteSpeaker(const System::WideString Speaker) = 0 ;
	virtual HRESULT __safecall CommitSpeaker(void) = 0 ;
	virtual HRESULT __safecall RevertSpeaker(const System::WideString Speaker) = 0 ;
	virtual HRESULT __safecall Get_SpeakerInfoChanged(int &filetimehi, int &filetimelo, int &__Get_SpeakerInfoChanged_result) = 0 ;
	virtual HRESULT __safecall TrainPhrasesDlg(int hwnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall LexAddTo(int lex, int charset, const System::WideString text, const System::WideString pronounce, int partofspeech, int EngineInfo, int engineinfosize) = 0 ;
	virtual HRESULT __safecall LexGetFrom(int lex, int charset, const System::WideString text, int sense, System::WideString &pronounce, int &partofspeech, int &EngineInfo, int &sizeofengineinfo) = 0 ;
	virtual HRESULT __safecall LexRemoveFrom(int lex, const System::WideString text, int sense) = 0 ;
	virtual HRESULT __safecall QueryLexicons(int f, int &pdw) = 0 ;
	virtual HRESULT __safecall ChangeSpelling(int lex, const System::WideString stringa, const System::WideString stringb) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_debug() { short __r; HRESULT __hr = Get_debug(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short debug = {read=_scw_Get_debug, write=Set_debug};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_Initialized() { short __r; HRESULT __hr = Get_Initialized(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short Initialized = {read=_scw_Get_Initialized, write=Set_Initialized};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_LastHeard() { System::WideString __r; HRESULT __hr = Get_LastHeard(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString LastHeard = {read=_scw_Get_LastHeard, write=Set_LastHeard};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AutoGain() { int __r; HRESULT __hr = Get_AutoGain(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AutoGain = {read=_scw_Get_AutoGain, write=Set_AutoGain};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinAutoGain() { int __r; HRESULT __hr = Get_MinAutoGain(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinAutoGain = {read=_scw_Get_MinAutoGain};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxAutoGain() { int __r; HRESULT __hr = Get_MaxAutoGain(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxAutoGain = {read=_scw_Get_MaxAutoGain};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_Echo() { short __r; HRESULT __hr = Get_Echo(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short Echo = {read=_scw_Get_Echo, write=Set_Echo};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_EnergyFloor() { int __r; HRESULT __hr = Get_EnergyFloor(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int EnergyFloor = {read=_scw_Get_EnergyFloor, write=Set_EnergyFloor};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxEnergyFloor() { int __r; HRESULT __hr = Get_MaxEnergyFloor(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxEnergyFloor = {read=_scw_Get_MaxEnergyFloor};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinEnergyFloor() { int __r; HRESULT __hr = Get_MinEnergyFloor(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinEnergyFloor = {read=_scw_Get_MinEnergyFloor};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Microphone() { System::WideString __r; HRESULT __hr = Get_Microphone(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Microphone = {read=_scw_Get_Microphone, write=Set_Microphone};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Speaker() { System::WideString __r; HRESULT __hr = Get_Speaker(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Speaker = {read=_scw_Get_Speaker, write=Set_Speaker};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_RealTime() { int __r; HRESULT __hr = Get_RealTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int RealTime = {read=_scw_Get_RealTime, write=Set_RealTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxRealTime() { int __r; HRESULT __hr = Get_MaxRealTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxRealTime = {read=_scw_Get_MaxRealTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinRealTime() { int __r; HRESULT __hr = Get_MinRealTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinRealTime = {read=_scw_Get_MinRealTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Threshold() { int __r; HRESULT __hr = Get_Threshold(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Threshold = {read=_scw_Get_Threshold, write=Set_Threshold};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxThreshold() { int __r; HRESULT __hr = Get_MaxThreshold(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxThreshold = {read=_scw_Get_MaxThreshold};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinThreshold() { int __r; HRESULT __hr = Get_MinThreshold(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinThreshold = {read=_scw_Get_MinThreshold};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CompleteTimeOut() { int __r; HRESULT __hr = Get_CompleteTimeOut(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CompleteTimeOut = {read=_scw_Get_CompleteTimeOut, write=Set_CompleteTimeOut};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_IncompleteTimeOut() { int __r; HRESULT __hr = Get_IncompleteTimeOut(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int IncompleteTimeOut = {read=_scw_Get_IncompleteTimeOut, write=Set_IncompleteTimeOut};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxCompleteTimeOut() { int __r; HRESULT __hr = Get_MaxCompleteTimeOut(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxCompleteTimeOut = {read=_scw_Get_MaxCompleteTimeOut};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinCompleteTimeOut() { int __r; HRESULT __hr = Get_MinCompleteTimeOut(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinCompleteTimeOut = {read=_scw_Get_MinCompleteTimeOut};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxIncompleteTimeOut() { int __r; HRESULT __hr = Get_MaxIncompleteTimeOut(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxIncompleteTimeOut = {read=_scw_Get_MaxIncompleteTimeOut};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinIncompleteTimeOut() { int __r; HRESULT __hr = Get_MinIncompleteTimeOut(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinIncompleteTimeOut = {read=_scw_Get_MinIncompleteTimeOut};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Wave(int results) { int __r; HRESULT __hr = Get_Wave(results, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Wave[int results] = {read=_scw_Get_Wave};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Phrase(int results, int rank) { System::WideString __r; HRESULT __hr = Get_Phrase(results, rank, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Phrase[int results][int rank] = {read=_scw_Get_Phrase};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CreateResultsObject(int results) { int __r; HRESULT __hr = Get_CreateResultsObject(results, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CreateResultsObject[int results] = {read=_scw_Get_CreateResultsObject};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CountEngines() { int __r; HRESULT __hr = Get_CountEngines(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CountEngines = {read=_scw_Get_CountEngines};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_FileName() { System::WideString __r; HRESULT __hr = Get_FileName(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString FileName = {read=_scw_Get_FileName, write=Set_FileName};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_FlagsGet(int results, int rank) { int __r; HRESULT __hr = Get_FlagsGet(results, rank, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int FlagsGet[int results][int rank] = {read=_scw_Get_FlagsGet};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Identify(int results) { System::WideString __r; HRESULT __hr = Get_Identify(results, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Identify[int results] = {read=_scw_Get_Identify};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_ReEvaluate(int results) { int __r; HRESULT __hr = Get_ReEvaluate(results, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int ReEvaluate[int results] = {read=_scw_Get_ReEvaluate};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_GetPhraseScore(int results, int rank) { int __r; HRESULT __hr = Get_GetPhraseScore(results, rank, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int GetPhraseScore[int results][int rank] = {read=_scw_Get_GetPhraseScore};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_LastError() { int __r; HRESULT __hr = Get_LastError(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int LastError = {read=_scw_Get_LastError, write=Set_LastError};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_SuppressExceptions() { int __r; HRESULT __hr = Get_SuppressExceptions(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int SuppressExceptions = {read=_scw_Get_SuppressExceptions, write=Set_SuppressExceptions};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_hwnd() { int __r; HRESULT __hr = Get_hwnd(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int hwnd = {read=_scw_Get_hwnd};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_SRMode() { int __r; HRESULT __hr = Get_SRMode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int SRMode = {read=_scw_Get_SRMode, write=Set_SRMode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_GetAllArcStrings(int punk, int results) { System::WideString __r; HRESULT __hr = Get_GetAllArcStrings(punk, results, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString GetAllArcStrings[int punk][int results] = {read=_scw_Get_GetAllArcStrings};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Attributes(int Attrib) { int __r; HRESULT __hr = Get_Attributes(Attrib, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Attributes[int Attrib] = {read=_scw_Get_Attributes, write=Set_Attributes};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_AttributeString(int Attrib) { System::WideString __r; HRESULT __hr = Get_AttributeString(Attrib, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString AttributeString[int Attrib] = {read=_scw_Get_AttributeString, write=Set_AttributeString};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AttributeMemory(int Attrib, int &size) { int __r; HRESULT __hr = Get_AttributeMemory(Attrib, size, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AttributeMemory[int Attrib][int size] = {read=_scw_Get_AttributeMemory, write=Set_AttributeMemory};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_WaveEx(int results, int beginhi, int beginlo, int endhi, int endlo) { int __r; HRESULT __hr = Get_WaveEx(results, beginhi, beginlo, endhi, endlo, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int WaveEx[int results][int beginhi][int beginlo][int endhi][int endlo] = {read=_scw_Get_WaveEx};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NodeStart(int results) { int __r; HRESULT __hr = Get_NodeStart(results, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NodeStart[int results] = {read=_scw_Get_NodeStart};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NodeEnd(int results) { int __r; HRESULT __hr = Get_NodeEnd(results, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NodeEnd[int results] = {read=_scw_Get_NodeEnd};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_DataGetString(int results, int id, const System::WideString Attrib) { System::WideString __r; HRESULT __hr = Get_DataGetString(results, id, Attrib, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString DataGetString[int results][int id][const System::WideString Attrib] = {read=_scw_Get_DataGetString};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_score(int results, int scoretype, int &path, int pathsteps, int pathindexstart, int pathindexcount) { int __r; HRESULT __hr = Get_score(results, scoretype, path, pathsteps, pathindexstart, pathindexcount, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int score[int results][int scoretype][int path][int pathsteps][int pathindexstart][int pathindexcount] = {read=_scw_Get_score};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_NodeGet(int results, int arc, int destination) { int __r; HRESULT __hr = Get_NodeGet(results, arc, destination, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int NodeGet[int results][int arc][int destination] = {read=_scw_Get_NodeGet};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_GraphDWORDGet(int results, int id, const System::WideString Attrib) { int __r; HRESULT __hr = Get_GraphDWORDGet(results, id, Attrib, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int GraphDWORDGet[int results][int id][const System::WideString Attrib] = {read=_scw_Get_GraphDWORDGet};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_SpeakerInfoChanged(int &filetimehi, int &filetimelo) { int __r; HRESULT __hr = Get_SpeakerInfoChanged(filetimehi, filetimelo, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int SpeakerInfoChanged[int filetimehi][int filetimelo] = {read=_scw_Get_SpeakerInfoChanged};
};

class PASCALIMPLEMENTATION TDirectSR : public Vcl::Olectrls::TOleControl
{
	typedef Vcl::Olectrls::TOleControl inherited;
	
private:
	TDirectSRClickIn FOnClickIn;
	TDirectSRClickOut FOnClickOut;
	TDirectSRPhraseFinish FOnPhraseFinish;
	TDirectSRPhraseStart FOnPhraseStart;
	TDirectSRBookMark FOnBookMark;
	System::Classes::TNotifyEvent FOnPaused;
	TDirectSRPhraseHypothesis FOnPhraseHypothesis;
	TDirectSRReEvaluate FOnReEvaluate;
	TDirectSRTraining FOnTraining;
	TDirectSRUnArchive FOnUnArchive;
	TDirectSRAttribChanged FOnAttribChanged;
	TDirectSRInterference FOnInterference;
	TDirectSRSound FOnSound;
	TDirectSRUtteranceBegin FOnUtteranceBegin;
	TDirectSRUtteranceEnd FOnUtteranceEnd;
	TDirectSRVUMeter FOnVUMeter;
	TDirectSRError FOnError;
	TDirectSRwarning FOnwarning;
	_di_IDirectSR FIntf;
	_di_IDirectSR __fastcall GetControlInterface(void);
	
protected:
	HIDESBASE void __fastcall CreateControl(void);
	virtual void __fastcall InitControlData(void);
	int __fastcall Get_Wave(int results);
	System::WideString __fastcall Get_Phrase(int results, int rank);
	int __fastcall Get_CreateResultsObject(int results);
	int __fastcall Get_FlagsGet(int results, int rank);
	System::WideString __fastcall Get_Identify(int results);
	int __fastcall Get_ReEvaluate(int results);
	int __fastcall Get_GetPhraseScore(int results, int rank);
	System::WideString __fastcall Get_GetAllArcStrings(int punk, int results);
	int __fastcall Get_Attributes(int Attrib);
	void __fastcall Set_Attributes(int Attrib, int pVal);
	System::WideString __fastcall Get_AttributeString(int Attrib);
	void __fastcall Set_AttributeString(int Attrib, const System::WideString pVal);
	int __fastcall Get_AttributeMemory(int Attrib, int &size);
	void __fastcall Set_AttributeMemory(int Attrib, int &size, int pVal);
	int __fastcall Get_WaveEx(int results, int beginhi, int beginlo, int endhi, int endlo);
	int __fastcall Get_NodeStart(int results);
	int __fastcall Get_NodeEnd(int results);
	System::WideString __fastcall Get_DataGetString(int results, int id, const System::WideString Attrib);
	int __fastcall Get_score(int results, int scoretype, int &path, int pathsteps, int pathindexstart, int pathindexcount);
	int __fastcall Get_NodeGet(int results, int arc, int destination);
	int __fastcall Get_GraphDWORDGet(int results, int id, const System::WideString Attrib);
	int __fastcall Get_SpeakerInfoChanged(int &filetimehi, int &filetimelo);
	
public:
	void __fastcall Deactivate(void);
	void __fastcall Activate(void);
	void __fastcall GrammarFromString(const System::WideString grammar);
	void __fastcall GrammarFromFile(const System::WideString FileName);
	void __fastcall GrammarFromResource(int Instance, int ResID);
	void __fastcall GrammarFromStream(int Stream);
	void __fastcall Pause(void);
	void __fastcall Resume(void);
	void __fastcall PosnGet(/* out */ int &hi, /* out */ int &lo);
	void __fastcall AboutDlg(int hwnd, const System::WideString title);
	void __fastcall GeneralDlg(int hwnd, const System::WideString title);
	void __fastcall LexiconDlg(int hwnd, const System::WideString title);
	void __fastcall TrainGeneralDlg(int hwnd, const System::WideString title);
	void __fastcall TrainMicDlg(int hwnd, const System::WideString title);
	void __fastcall DestroyResultsObject(int resobj);
	void __fastcall Select(int index);
	void __fastcall Listen(void);
	void __fastcall SelectEngine(int index);
	int __fastcall FindEngine(const System::WideString EngineId, const System::WideString MfgName, const System::WideString ProductName, const System::WideString ModeID, const System::WideString ModeName, int LanguageID, const System::WideString dialect, int Sequencing, int MaxWordsVocab, int MaxWordsState, int Grammars, int Features, int Interfaces, int EngineFeatures, int RankEngineID, int RankMfgName, int RankProductName, int RankModeID, int RankModeName, int RankLanguage, int RankDialect, int RankSequencing, int RankMaxWordsVocab, int RankMaxWordsState, int RankGrammars, int RankFeatures, int RankInterfaces, int RankEngineFeatures);
	System::WideString __fastcall ModeName(int index);
	System::WideString __fastcall EngineId(int index);
	System::WideString __fastcall MfgName(int index);
	System::WideString __fastcall ProductName(int index);
	System::WideString __fastcall ModeID(int index);
	int __fastcall Features(int index);
	int __fastcall Interfaces(int index);
	int __fastcall EngineFeatures(int index);
	int __fastcall LanguageID(int index);
	System::WideString __fastcall dialect(int index);
	int __fastcall Sequencing(int index);
	int __fastcall MaxWordsVocab(int index);
	int __fastcall MaxWordsState(int index);
	int __fastcall Grammars(int index);
	void __fastcall InitAudioSourceDirect(int direct);
	void __fastcall InitAudioSourceObject(int object_);
	void __fastcall TimeGet(int results, int &beginhi, int &beginlo, int &endhi, int &endlo);
	void __fastcall Correction(int results, const System::WideString Phrase, short confidence);
	void __fastcall Validate(int results, short confidence);
	void __fastcall Archive(int keepresults, /* out */ int &size, /* out */ int &pVal);
	void __fastcall DeleteArchive(int Archive);
	void __fastcall GrammarFromMemory(int grammar, int size);
	void __fastcall GrammarDataSet(int Data, int size);
	void __fastcall GrammarToMemory(int &grammar, int &size);
	void __fastcall ActivateAndAssignWindow(int hwnd);
	int __fastcall Find(const System::WideString RankList);
	void __fastcall ArcEnum(int results, int node, int Outgoing, int &nodelist, int &countnodes);
	void __fastcall BestPathEnum(int results, int rank, int &startpath, int startpathsteps, int &endpath, int endpathsteps, int exactmatch, int &arclist, int &arccount);
	void __fastcall DataGetTime(int results, int id, const System::WideString Attrib, int &hi, int &lo);
	void __fastcall GetAllArcs(int results, int &arcids, int &arccount);
	void __fastcall GetAllNodes(int results, int &Nodes, int &countnodes);
	void __fastcall RenameSpeaker(const System::WideString OldName, const System::WideString newName);
	void __fastcall DeleteSpeaker(const System::WideString Speaker);
	void __fastcall CommitSpeaker(void);
	void __fastcall RevertSpeaker(const System::WideString Speaker);
	void __fastcall TrainPhrasesDlg(int hwnd, const System::WideString title);
	void __fastcall LexAddTo(int lex, int charset, const System::WideString text, const System::WideString pronounce, int partofspeech, int EngineInfo, int engineinfosize);
	void __fastcall LexGetFrom(int lex, int charset, const System::WideString text, int sense, System::WideString &pronounce, int &partofspeech, int &EngineInfo, int &sizeofengineinfo);
	void __fastcall LexRemoveFrom(int lex, const System::WideString text, int sense);
	void __fastcall QueryLexicons(int f, int &pdw);
	void __fastcall ChangeSpelling(int lex, const System::WideString stringa, const System::WideString stringb);
	__property _di_IDirectSR ControlInterface = {read=GetControlInterface};
	__property _di_IDirectSR DefaultInterface = {read=GetControlInterface};
	__property int MinAutoGain = {read=GetIntegerProp, index=12, nodefault};
	__property int MaxAutoGain = {read=GetIntegerProp, index=13, nodefault};
	__property int MaxEnergyFloor = {read=GetIntegerProp, index=16, nodefault};
	__property int MinEnergyFloor = {read=GetIntegerProp, index=17, nodefault};
	__property int MaxRealTime = {read=GetIntegerProp, index=21, nodefault};
	__property int MinRealTime = {read=GetIntegerProp, index=22, nodefault};
	__property int MaxThreshold = {read=GetIntegerProp, index=24, nodefault};
	__property int MinThreshold = {read=GetIntegerProp, index=25, nodefault};
	__property int MaxCompleteTimeOut = {read=GetIntegerProp, index=28, nodefault};
	__property int MinCompleteTimeOut = {read=GetIntegerProp, index=29, nodefault};
	__property int MaxIncompleteTimeOut = {read=GetIntegerProp, index=30, nodefault};
	__property int MinIncompleteTimeOut = {read=GetIntegerProp, index=31, nodefault};
	__property int Wave[int results] = {read=Get_Wave};
	__property System::WideString Phrase[int results][int rank] = {read=Get_Phrase};
	__property int CreateResultsObject[int results] = {read=Get_CreateResultsObject};
	__property int CountEngines = {read=GetIntegerProp, index=48, nodefault};
	__property int FlagsGet[int results][int rank] = {read=Get_FlagsGet};
	__property System::WideString Identify[int results] = {read=Get_Identify};
	__property int ReEvaluate[int results] = {read=Get_ReEvaluate};
	__property int GetPhraseScore[int results][int rank] = {read=Get_GetPhraseScore};
	__property int hwnd = {read=GetIntegerProp, index=81, nodefault};
	__property System::WideString GetAllArcStrings[int punk][int results] = {read=Get_GetAllArcStrings};
	__property int Attributes[int Attrib] = {read=Get_Attributes, write=Set_Attributes};
	__property System::WideString AttributeString[int Attrib] = {read=Get_AttributeString, write=Set_AttributeString};
	__property int AttributeMemory[int Attrib][int size] = {read=Get_AttributeMemory, write=Set_AttributeMemory};
	__property int WaveEx[int results][int beginhi][int beginlo][int endhi][int endlo] = {read=Get_WaveEx};
	__property int NodeStart[int results] = {read=Get_NodeStart};
	__property int NodeEnd[int results] = {read=Get_NodeEnd};
	__property System::WideString DataGetString[int results][int id][const System::WideString Attrib] = {read=Get_DataGetString};
	__property int score[int results][int scoretype][int path][int pathsteps][int pathindexstart][int pathindexcount] = {read=Get_score};
	__property int NodeGet[int results][int arc][int destination] = {read=Get_NodeGet};
	__property int GraphDWORDGet[int results][int id][const System::WideString Attrib] = {read=Get_GraphDWORDGet};
	__property int SpeakerInfoChanged[int filetimehi][int filetimelo] = {read=Get_SpeakerInfoChanged};
	
__published:
	__property TabStop = {default=1};
	__property Align = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property Visible = {default=1};
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnStartDrag;
	__property short debug = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=1, nodefault};
	__property short Initialized = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=2, nodefault};
	__property System::WideString LastHeard = {read=GetWideStringProp, write=SetWideStringProp, stored=false, index=6};
	__property int AutoGain = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=11, nodefault};
	__property short Echo = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=14, nodefault};
	__property int EnergyFloor = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=15, nodefault};
	__property System::WideString Microphone = {read=GetWideStringProp, write=SetWideStringProp, stored=false, index=18};
	__property System::WideString Speaker = {read=GetWideStringProp, write=SetWideStringProp, stored=false, index=19};
	__property int RealTime = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=20, nodefault};
	__property int Threshold = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=23, nodefault};
	__property int CompleteTimeOut = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=26, nodefault};
	__property int IncompleteTimeOut = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=27, nodefault};
	__property System::WideString FileName = {read=GetWideStringProp, write=SetWideStringProp, stored=false, index=65};
	__property int LastError = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=79, nodefault};
	__property int SuppressExceptions = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=80, nodefault};
	__property int SRMode = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=83, nodefault};
	__property TDirectSRClickIn OnClickIn = {read=FOnClickIn, write=FOnClickIn};
	__property TDirectSRClickOut OnClickOut = {read=FOnClickOut, write=FOnClickOut};
	__property TDirectSRPhraseFinish OnPhraseFinish = {read=FOnPhraseFinish, write=FOnPhraseFinish};
	__property TDirectSRPhraseStart OnPhraseStart = {read=FOnPhraseStart, write=FOnPhraseStart};
	__property TDirectSRBookMark OnBookMark = {read=FOnBookMark, write=FOnBookMark};
	__property System::Classes::TNotifyEvent OnPaused = {read=FOnPaused, write=FOnPaused};
	__property TDirectSRPhraseHypothesis OnPhraseHypothesis = {read=FOnPhraseHypothesis, write=FOnPhraseHypothesis};
	__property TDirectSRReEvaluate OnReEvaluate = {read=FOnReEvaluate, write=FOnReEvaluate};
	__property TDirectSRTraining OnTraining = {read=FOnTraining, write=FOnTraining};
	__property TDirectSRUnArchive OnUnArchive = {read=FOnUnArchive, write=FOnUnArchive};
	__property TDirectSRAttribChanged OnAttribChanged = {read=FOnAttribChanged, write=FOnAttribChanged};
	__property TDirectSRInterference OnInterference = {read=FOnInterference, write=FOnInterference};
	__property TDirectSRSound OnSound = {read=FOnSound, write=FOnSound};
	__property TDirectSRUtteranceBegin OnUtteranceBegin = {read=FOnUtteranceBegin, write=FOnUtteranceBegin};
	__property TDirectSRUtteranceEnd OnUtteranceEnd = {read=FOnUtteranceEnd, write=FOnUtteranceEnd};
	__property TDirectSRVUMeter OnVUMeter = {read=FOnVUMeter, write=FOnVUMeter};
	__property TDirectSRError OnError = {read=FOnError, write=FOnError};
	__property TDirectSRwarning Onwarning = {read=FOnwarning, write=FOnwarning};
public:
	/* TOleControl.Create */ inline __fastcall virtual TDirectSR(System::Classes::TComponent* AOwner) : Vcl::Olectrls::TOleControl(AOwner) { }
	/* TOleControl.Destroy */ inline __fastcall virtual ~TDirectSR(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TDirectSR(HWND ParentWindow) : Vcl::Olectrls::TOleControl(ParentWindow) { }
	
};


__interface  INTERFACE_UUID("{EEE78590-FE22-11D0-8BEF-0060081841DE}") IDirectSS  : public IDispatch 
{
	virtual HRESULT __safecall Get_debug(short &__Get_debug_result) = 0 ;
	virtual HRESULT __safecall Set_debug(short pVal) = 0 ;
	virtual HRESULT __safecall Get_Initialized(short &__Get_Initialized_result) = 0 ;
	virtual HRESULT __safecall Set_Initialized(short pVal) = 0 ;
	virtual HRESULT __safecall Speak(const System::WideString text) = 0 ;
	virtual HRESULT __safecall Get_Pitch(int &__Get_Pitch_result) = 0 ;
	virtual HRESULT __safecall Set_Pitch(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxPitch(int &__Get_MaxPitch_result) = 0 ;
	virtual HRESULT __safecall Set_MaxPitch(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MinPitch(int &__Get_MinPitch_result) = 0 ;
	virtual HRESULT __safecall Set_MinPitch(int pVal) = 0 ;
	virtual HRESULT __safecall Get_Speed(int &__Get_Speed_result) = 0 ;
	virtual HRESULT __safecall Set_Speed(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxSpeed(int &__Get_MaxSpeed_result) = 0 ;
	virtual HRESULT __safecall Set_MaxSpeed(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MinSpeed(int &__Get_MinSpeed_result) = 0 ;
	virtual HRESULT __safecall Set_MinSpeed(int pVal) = 0 ;
	virtual HRESULT __safecall Get_VolumeRight(int &__Get_VolumeRight_result) = 0 ;
	virtual HRESULT __safecall Set_VolumeRight(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MinVolumeRight(int &__Get_MinVolumeRight_result) = 0 ;
	virtual HRESULT __safecall Set_MinVolumeRight(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxVolumeRight(int &__Get_MaxVolumeRight_result) = 0 ;
	virtual HRESULT __safecall Set_MaxVolumeRight(int pVal) = 0 ;
	virtual HRESULT __safecall Select(int index) = 0 ;
	virtual HRESULT __safecall EngineID(int index, System::WideString &__EngineID_result) = 0 ;
	virtual HRESULT __safecall Get_CountEngines(int &__Get_CountEngines_result) = 0 ;
	virtual HRESULT __safecall ModeName(int index, System::WideString &__ModeName_result) = 0 ;
	virtual HRESULT __safecall MfgName(int index, System::WideString &__MfgName_result) = 0 ;
	virtual HRESULT __safecall ProductName(int index, System::WideString &__ProductName_result) = 0 ;
	virtual HRESULT __safecall ModeID(int index, System::WideString &__ModeID_result) = 0 ;
	virtual HRESULT __safecall Speaker(int index, System::WideString &__Speaker_result) = 0 ;
	virtual HRESULT __safecall Style(int index, System::WideString &__Style_result) = 0 ;
	virtual HRESULT __safecall Gender(int index, int &__Gender_result) = 0 ;
	virtual HRESULT __safecall Age(int index, int &__Age_result) = 0 ;
	virtual HRESULT __safecall Features(int index, int &__Features_result) = 0 ;
	virtual HRESULT __safecall Interfaces(int index, int &__Interfaces_result) = 0 ;
	virtual HRESULT __safecall EngineFeatures(int index, int &__EngineFeatures_result) = 0 ;
	virtual HRESULT __safecall LanguageID(int index, int &__LanguageID_result) = 0 ;
	virtual HRESULT __safecall Dialect(int index, System::WideString &__Dialect_result) = 0 ;
	virtual HRESULT __safecall Get_RealTime(int &__Get_RealTime_result) = 0 ;
	virtual HRESULT __safecall Set_RealTime(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxRealTime(int &__Get_MaxRealTime_result) = 0 ;
	virtual HRESULT __safecall Get_MinRealTime(int &__Get_MinRealTime_result) = 0 ;
	virtual HRESULT __safecall Set_MinRealTime(int pVal) = 0 ;
	virtual HRESULT __safecall AudioPause(void) = 0 ;
	virtual HRESULT __safecall AudioReset(void) = 0 ;
	virtual HRESULT __safecall AudioResume(void) = 0 ;
	virtual HRESULT __safecall Inject(const System::WideString value) = 0 ;
	virtual HRESULT __safecall Get_Tagged(int &__Get_Tagged_result) = 0 ;
	virtual HRESULT __safecall Set_Tagged(int pVal) = 0 ;
	virtual HRESULT __safecall Phonemes(int charset, int Flags, const System::WideString input, System::WideString &__Phonemes_result) = 0 ;
	virtual HRESULT __safecall PosnGet(int &hi, int &lo) = 0 ;
	virtual HRESULT __safecall TextData(int characterset, int Flags, const System::WideString text) = 0 ;
	virtual HRESULT __safecall InitAudioDestMM(int deviceid) = 0 ;
	virtual HRESULT __safecall AboutDlg(int hWnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall GeneralDlg(int hWnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall LexiconDlg(int hWnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall TranslateDlg(int hWnd, const System::WideString title) = 0 ;
	virtual HRESULT __safecall FindEngine(const System::WideString EngineID, const System::WideString MfgName, const System::WideString ProductName, const System::WideString ModeID, const System::WideString ModeName, int LanguageID, const System::WideString Dialect, const System::WideString Speaker, const System::WideString Style, int Gender, int Age, int Features, int Interfaces, int EngineFeatures, int RankEngineID, int RankMfgName, int RankProductName, int RankModeID, int RankModeName, int RankLanguage, int RankDialect, int RankSpeaker, int RankStyle, int RankGender, int RankAge, int RankFeatures, int RankInterfaces, int RankEngineFeatures, int &__FindEngine_result) = 0 ;
	virtual HRESULT __safecall Get_MouthHeight(short &__Get_MouthHeight_result) = 0 ;
	virtual HRESULT __safecall Set_MouthHeight(short pVal) = 0 ;
	virtual HRESULT __safecall Get_MouthWidth(short &__Get_MouthWidth_result) = 0 ;
	virtual HRESULT __safecall Set_MouthWidth(short pVal) = 0 ;
	virtual HRESULT __safecall Get_MouthUpturn(short &__Get_MouthUpturn_result) = 0 ;
	virtual HRESULT __safecall Set_MouthUpturn(short pVal) = 0 ;
	virtual HRESULT __safecall Get_JawOpen(short &__Get_JawOpen_result) = 0 ;
	virtual HRESULT __safecall Set_JawOpen(short pVal) = 0 ;
	virtual HRESULT __safecall Get_TeethUpperVisible(short &__Get_TeethUpperVisible_result) = 0 ;
	virtual HRESULT __safecall Set_TeethUpperVisible(short pVal) = 0 ;
	virtual HRESULT __safecall Get_TeethLowerVisible(short &__Get_TeethLowerVisible_result) = 0 ;
	virtual HRESULT __safecall Set_TeethLowerVisible(short pVal) = 0 ;
	virtual HRESULT __safecall Get_TonguePosn(short &__Get_TonguePosn_result) = 0 ;
	virtual HRESULT __safecall Set_TonguePosn(short pVal) = 0 ;
	virtual HRESULT __safecall Get_LipTension(short &__Get_LipTension_result) = 0 ;
	virtual HRESULT __safecall Set_LipTension(short pVal) = 0 ;
	virtual HRESULT __safecall Get_CallBacksEnabled(short &__Get_CallBacksEnabled_result) = 0 ;
	virtual HRESULT __safecall Set_CallBacksEnabled(short pVal) = 0 ;
	virtual HRESULT __safecall Get_MouthEnabled(short &__Get_MouthEnabled_result) = 0 ;
	virtual HRESULT __safecall Set_MouthEnabled(short pVal) = 0 ;
	virtual HRESULT __safecall Get_LastError(int &__Get_LastError_result) = 0 ;
	virtual HRESULT __safecall Set_LastError(int pVal) = 0 ;
	virtual HRESULT __safecall Get_SuppressExceptions(short &__Get_SuppressExceptions_result) = 0 ;
	virtual HRESULT __safecall Set_SuppressExceptions(short pVal) = 0 ;
	virtual HRESULT __safecall Get_Speaking(short &__Get_Speaking_result) = 0 ;
	virtual HRESULT __safecall Set_Speaking(short pVal) = 0 ;
	virtual HRESULT __safecall Get_LastWordPosition(int &__Get_LastWordPosition_result) = 0 ;
	virtual HRESULT __safecall Set_LastWordPosition(int pVal) = 0 ;
	virtual HRESULT __safecall Get_LipType(short &__Get_LipType_result) = 0 ;
	virtual HRESULT __safecall Set_LipType(short pVal) = 0 ;
	virtual HRESULT __safecall GetPronunciation(int charset, const System::WideString text, int Sense, System::WideString &Pronounce, int &PartOfSpeech, System::WideString &EngineInfo) = 0 ;
	virtual HRESULT __safecall InitAudioDestDirect(int direct) = 0 ;
	virtual HRESULT __safecall Get_Sayit(System::WideString &__Get_Sayit_result) = 0 ;
	virtual HRESULT __safecall Set_Sayit(const System::WideString newVal) = 0 ;
	virtual HRESULT __safecall InitAudioDestObject(int object_) = 0 ;
	virtual HRESULT __safecall Get_FileName(System::WideString &__Get_FileName_result) = 0 ;
	virtual HRESULT __safecall Set_FileName(const System::WideString pVal) = 0 ;
	virtual HRESULT __safecall Get_CurrentMode(int &__Get_CurrentMode_result) = 0 ;
	virtual HRESULT __safecall Set_CurrentMode(int pVal) = 0 ;
	virtual HRESULT __safecall Get_hWnd(int &__Get_hWnd_result) = 0 ;
	virtual HRESULT __safecall Find(const System::WideString RankList, int &__Find_result) = 0 ;
	virtual HRESULT __safecall Get_VolumeLeft(int &__Get_VolumeLeft_result) = 0 ;
	virtual HRESULT __safecall Set_VolumeLeft(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MinVolumeLeft(int &__Get_MinVolumeLeft_result) = 0 ;
	virtual HRESULT __safecall Set_MinVolumeLeft(int pVal) = 0 ;
	virtual HRESULT __safecall Get_MaxVolumeLeft(int &__Get_MaxVolumeLeft_result) = 0 ;
	virtual HRESULT __safecall Set_MaxVolumeLeft(int pVal) = 0 ;
	virtual HRESULT __safecall Get_AudioDest(int &__Get_AudioDest_result) = 0 ;
	virtual HRESULT __safecall Get_Attributes(int Attrib, int &__Get_Attributes_result) = 0 ;
	virtual HRESULT __safecall Set_Attributes(int Attrib, int pVal) = 0 ;
	virtual HRESULT __safecall Get_AttributeString(int Attrib, System::WideString &__Get_AttributeString_result) = 0 ;
	virtual HRESULT __safecall Set_AttributeString(int Attrib, const System::WideString pVal) = 0 ;
	virtual HRESULT __safecall Get_AttributeMemory(int Attrib, int &size, int &__Get_AttributeMemory_result) = 0 ;
	virtual HRESULT __safecall Set_AttributeMemory(int Attrib, int &size, int pVal) = 0 ;
	virtual HRESULT __safecall LexAddTo(int lex, int charset, const System::WideString text, const System::WideString Pronounce, int PartOfSpeech, int EngineInfo, int engineinfosize) = 0 ;
	virtual HRESULT __safecall LexGetFrom(int lex, int charset, const System::WideString text, int Sense, System::WideString &Pronounce, int &PartOfSpeech, int &EngineInfo, int &sizeofengineinfo) = 0 ;
	virtual HRESULT __safecall LexRemoveFrom(int lex, const System::WideString text, int Sense) = 0 ;
	virtual HRESULT __safecall QueryLexicons(int f, int &pdw) = 0 ;
	virtual HRESULT __safecall ChangeSpelling(int lex, const System::WideString stringa, const System::WideString stringb) = 0 ;
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_debug() { short __r; HRESULT __hr = Get_debug(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short debug = {read=_scw_Get_debug, write=Set_debug};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_Initialized() { short __r; HRESULT __hr = Get_Initialized(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short Initialized = {read=_scw_Get_Initialized, write=Set_Initialized};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Pitch() { int __r; HRESULT __hr = Get_Pitch(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Pitch = {read=_scw_Get_Pitch, write=Set_Pitch};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxPitch() { int __r; HRESULT __hr = Get_MaxPitch(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxPitch = {read=_scw_Get_MaxPitch, write=Set_MaxPitch};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinPitch() { int __r; HRESULT __hr = Get_MinPitch(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinPitch = {read=_scw_Get_MinPitch, write=Set_MinPitch};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Speed() { int __r; HRESULT __hr = Get_Speed(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Speed = {read=_scw_Get_Speed, write=Set_Speed};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxSpeed() { int __r; HRESULT __hr = Get_MaxSpeed(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxSpeed = {read=_scw_Get_MaxSpeed, write=Set_MaxSpeed};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinSpeed() { int __r; HRESULT __hr = Get_MinSpeed(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinSpeed = {read=_scw_Get_MinSpeed, write=Set_MinSpeed};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_VolumeRight() { int __r; HRESULT __hr = Get_VolumeRight(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int VolumeRight = {read=_scw_Get_VolumeRight, write=Set_VolumeRight};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinVolumeRight() { int __r; HRESULT __hr = Get_MinVolumeRight(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinVolumeRight = {read=_scw_Get_MinVolumeRight, write=Set_MinVolumeRight};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxVolumeRight() { int __r; HRESULT __hr = Get_MaxVolumeRight(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxVolumeRight = {read=_scw_Get_MaxVolumeRight, write=Set_MaxVolumeRight};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CountEngines() { int __r; HRESULT __hr = Get_CountEngines(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CountEngines = {read=_scw_Get_CountEngines};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_RealTime() { int __r; HRESULT __hr = Get_RealTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int RealTime = {read=_scw_Get_RealTime, write=Set_RealTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxRealTime() { int __r; HRESULT __hr = Get_MaxRealTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxRealTime = {read=_scw_Get_MaxRealTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinRealTime() { int __r; HRESULT __hr = Get_MinRealTime(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinRealTime = {read=_scw_Get_MinRealTime, write=Set_MinRealTime};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Tagged() { int __r; HRESULT __hr = Get_Tagged(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Tagged = {read=_scw_Get_Tagged, write=Set_Tagged};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_MouthHeight() { short __r; HRESULT __hr = Get_MouthHeight(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short MouthHeight = {read=_scw_Get_MouthHeight, write=Set_MouthHeight};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_MouthWidth() { short __r; HRESULT __hr = Get_MouthWidth(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short MouthWidth = {read=_scw_Get_MouthWidth, write=Set_MouthWidth};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_MouthUpturn() { short __r; HRESULT __hr = Get_MouthUpturn(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short MouthUpturn = {read=_scw_Get_MouthUpturn, write=Set_MouthUpturn};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_JawOpen() { short __r; HRESULT __hr = Get_JawOpen(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short JawOpen = {read=_scw_Get_JawOpen, write=Set_JawOpen};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_TeethUpperVisible() { short __r; HRESULT __hr = Get_TeethUpperVisible(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short TeethUpperVisible = {read=_scw_Get_TeethUpperVisible, write=Set_TeethUpperVisible};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_TeethLowerVisible() { short __r; HRESULT __hr = Get_TeethLowerVisible(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short TeethLowerVisible = {read=_scw_Get_TeethLowerVisible, write=Set_TeethLowerVisible};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_TonguePosn() { short __r; HRESULT __hr = Get_TonguePosn(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short TonguePosn = {read=_scw_Get_TonguePosn, write=Set_TonguePosn};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_LipTension() { short __r; HRESULT __hr = Get_LipTension(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short LipTension = {read=_scw_Get_LipTension, write=Set_LipTension};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_CallBacksEnabled() { short __r; HRESULT __hr = Get_CallBacksEnabled(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short CallBacksEnabled = {read=_scw_Get_CallBacksEnabled, write=Set_CallBacksEnabled};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_MouthEnabled() { short __r; HRESULT __hr = Get_MouthEnabled(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short MouthEnabled = {read=_scw_Get_MouthEnabled, write=Set_MouthEnabled};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_LastError() { int __r; HRESULT __hr = Get_LastError(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int LastError = {read=_scw_Get_LastError, write=Set_LastError};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_SuppressExceptions() { short __r; HRESULT __hr = Get_SuppressExceptions(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short SuppressExceptions = {read=_scw_Get_SuppressExceptions, write=Set_SuppressExceptions};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_Speaking() { short __r; HRESULT __hr = Get_Speaking(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short Speaking = {read=_scw_Get_Speaking, write=Set_Speaking};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_LastWordPosition() { int __r; HRESULT __hr = Get_LastWordPosition(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int LastWordPosition = {read=_scw_Get_LastWordPosition, write=Set_LastWordPosition};
	#pragma option push -w-inl
	/* safecall wrapper */ inline short _scw_Get_LipType() { short __r; HRESULT __hr = Get_LipType(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property short LipType = {read=_scw_Get_LipType, write=Set_LipType};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_Sayit() { System::WideString __r; HRESULT __hr = Get_Sayit(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString Sayit = {read=_scw_Get_Sayit, write=Set_Sayit};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_FileName() { System::WideString __r; HRESULT __hr = Get_FileName(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString FileName = {read=_scw_Get_FileName, write=Set_FileName};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_CurrentMode() { int __r; HRESULT __hr = Get_CurrentMode(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int CurrentMode = {read=_scw_Get_CurrentMode, write=Set_CurrentMode};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_hWnd() { int __r; HRESULT __hr = Get_hWnd(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int hWnd = {read=_scw_Get_hWnd};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_VolumeLeft() { int __r; HRESULT __hr = Get_VolumeLeft(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int VolumeLeft = {read=_scw_Get_VolumeLeft, write=Set_VolumeLeft};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MinVolumeLeft() { int __r; HRESULT __hr = Get_MinVolumeLeft(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MinVolumeLeft = {read=_scw_Get_MinVolumeLeft, write=Set_MinVolumeLeft};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_MaxVolumeLeft() { int __r; HRESULT __hr = Get_MaxVolumeLeft(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int MaxVolumeLeft = {read=_scw_Get_MaxVolumeLeft, write=Set_MaxVolumeLeft};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AudioDest() { int __r; HRESULT __hr = Get_AudioDest(__r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AudioDest = {read=_scw_Get_AudioDest};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_Attributes(int Attrib) { int __r; HRESULT __hr = Get_Attributes(Attrib, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int Attributes[int Attrib] = {read=_scw_Get_Attributes, write=Set_Attributes};
	#pragma option push -w-inl
	/* safecall wrapper */ inline System::WideString _scw_Get_AttributeString(int Attrib) { System::WideString __r; HRESULT __hr = Get_AttributeString(Attrib, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property System::WideString AttributeString[int Attrib] = {read=_scw_Get_AttributeString, write=Set_AttributeString};
	#pragma option push -w-inl
	/* safecall wrapper */ inline int _scw_Get_AttributeMemory(int Attrib, int &size) { int __r; HRESULT __hr = Get_AttributeMemory(Attrib, size, __r); System::CheckSafecallResult(__hr); return __r; }
	#pragma option pop
	__property int AttributeMemory[int Attrib][int size] = {read=_scw_Get_AttributeMemory, write=Set_AttributeMemory};
};

class PASCALIMPLEMENTATION TDirectSS : public Vcl::Olectrls::TOleControl
{
	typedef Vcl::Olectrls::TOleControl inherited;
	
private:
	TDirectSSClickIn FOnClickIn;
	TDirectSSClickOut FOnClickOut;
	TDirectSSAudioStart FOnAudioStart;
	TDirectSSAudioStop FOnAudioStop;
	TDirectSSAttribChanged FOnAttribChanged;
	TDirectSSVisual FOnVisual;
	TDirectSSWordPosition FOnWordPosition;
	TDirectSSBookMark FOnBookMark;
	TDirectSSTextDataStarted FOnTextDataStarted;
	TDirectSSTextDataDone FOnTextDataDone;
	TDirectSSActiveVoiceStartup FOnActiveVoiceStartup;
	System::Classes::TNotifyEvent FOnDebugging;
	TDirectSSError FOnError;
	TDirectSSwarning FOnwarning;
	TDirectSSVisualFuture FOnVisualFuture;
	_di_IDirectSS FIntf;
	_di_IDirectSS __fastcall GetControlInterface(void);
	
protected:
	HIDESBASE void __fastcall CreateControl(void);
	virtual void __fastcall InitControlData(void);
	int __fastcall Get_Attributes(int Attrib);
	void __fastcall Set_Attributes(int Attrib, int pVal);
	System::WideString __fastcall Get_AttributeString(int Attrib);
	void __fastcall Set_AttributeString(int Attrib, const System::WideString pVal);
	int __fastcall Get_AttributeMemory(int Attrib, int &size);
	void __fastcall Set_AttributeMemory(int Attrib, int &size, int pVal);
	
public:
	__fastcall virtual TDirectSS(System::Classes::TComponent* AOwner);
	void __fastcall Speak(const System::WideString text);
	void __fastcall Select(int index);
	System::WideString __fastcall EngineID(int index);
	System::WideString __fastcall ModeName(int index);
	System::WideString __fastcall MfgName(int index);
	System::WideString __fastcall ProductName(int index);
	System::WideString __fastcall ModeID(int index);
	System::WideString __fastcall Speaker(int index);
	System::WideString __fastcall Style(int index);
	int __fastcall Gender(int index);
	int __fastcall Age(int index);
	int __fastcall Features(int index);
	int __fastcall Interfaces(int index);
	int __fastcall EngineFeatures(int index);
	int __fastcall LanguageID(int index);
	System::WideString __fastcall Dialect(int index);
	void __fastcall AudioPause(void);
	void __fastcall AudioReset(void);
	void __fastcall AudioResume(void);
	void __fastcall Inject(const System::WideString value);
	System::WideString __fastcall Phonemes(int charset, int Flags, const System::WideString input);
	void __fastcall PosnGet(int &hi, int &lo);
	void __fastcall TextData(int characterset, int Flags, const System::WideString text);
	void __fastcall InitAudioDestMM(int deviceid);
	void __fastcall AboutDlg(int hWnd, const System::WideString title);
	void __fastcall GeneralDlg(int hWnd, const System::WideString title);
	void __fastcall LexiconDlg(int hWnd, const System::WideString title);
	void __fastcall TranslateDlg(int hWnd, const System::WideString title);
	int __fastcall FindEngine(const System::WideString EngineID, const System::WideString MfgName, const System::WideString ProductName, const System::WideString ModeID, const System::WideString ModeName, int LanguageID, const System::WideString Dialect, const System::WideString Speaker, const System::WideString Style, int Gender, int Age, int Features, int Interfaces, int EngineFeatures, int RankEngineID, int RankMfgName, int RankProductName, int RankModeID, int RankModeName, int RankLanguage, int RankDialect, int RankSpeaker, int RankStyle, int RankGender, int RankAge, int RankFeatures, int RankInterfaces, int RankEngineFeatures);
	void __fastcall GetPronunciation(int charset, const System::WideString text, int Sense, System::WideString &Pronounce, int &PartOfSpeech, System::WideString &EngineInfo);
	void __fastcall InitAudioDestDirect(int direct);
	void __fastcall InitAudioDestObject(int object_);
	int __fastcall Find(const System::WideString RankList);
	void __fastcall LexAddTo(int lex, int charset, const System::WideString text, const System::WideString Pronounce, int PartOfSpeech, int EngineInfo, int engineinfosize);
	void __fastcall LexGetFrom(int lex, int charset, const System::WideString text, int Sense, System::WideString &Pronounce, int &PartOfSpeech, int &EngineInfo, int &sizeofengineinfo);
	void __fastcall LexRemoveFrom(int lex, const System::WideString text, int Sense);
	void __fastcall QueryLexicons(int f, int &pdw);
	void __fastcall ChangeSpelling(int lex, const System::WideString stringa, const System::WideString stringb);
	__property _di_IDirectSS ControlInterface = {read=GetControlInterface};
	__property _di_IDirectSS DefaultInterface = {read=GetControlInterface};
	__property int CountEngines = {read=GetIntegerProp, index=18, nodefault};
	__property int MaxRealTime = {read=GetIntegerProp, index=33, nodefault};
	__property int hWnd = {read=GetIntegerProp, index=70, nodefault};
	__property int AudioDest = {read=GetIntegerProp, index=75, nodefault};
	__property int Attributes[int Attrib] = {read=Get_Attributes, write=Set_Attributes};
	__property System::WideString AttributeString[int Attrib] = {read=Get_AttributeString, write=Set_AttributeString};
	__property int AttributeMemory[int Attrib][int size] = {read=Get_AttributeMemory, write=Set_AttributeMemory};
	
__published:
	__property TabStop = {default=1};
	__property Align = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property Visible = {default=1};
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnStartDrag;
	__property short debug = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=1, nodefault};
	__property short Initialized = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=2, nodefault};
	__property int Pitch = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=7, nodefault};
	__property int MaxPitch = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=8, nodefault};
	__property int MinPitch = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=9, nodefault};
	__property int Speed = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=10, nodefault};
	__property int MaxSpeed = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=11, nodefault};
	__property int MinSpeed = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=12, nodefault};
	__property int VolumeRight = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=13, nodefault};
	__property int MinVolumeRight = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=14, nodefault};
	__property int MaxVolumeRight = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=15, nodefault};
	__property int RealTime = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=32, nodefault};
	__property int MinRealTime = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=34, nodefault};
	__property int Tagged = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=39, nodefault};
	__property short MouthHeight = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=49, nodefault};
	__property short MouthWidth = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=50, nodefault};
	__property short MouthUpturn = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=51, nodefault};
	__property short JawOpen = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=52, nodefault};
	__property short TeethUpperVisible = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=53, nodefault};
	__property short TeethLowerVisible = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=54, nodefault};
	__property short TonguePosn = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=55, nodefault};
	__property short LipTension = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=56, nodefault};
	__property short CallBacksEnabled = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=57, nodefault};
	__property short MouthEnabled = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=58, nodefault};
	__property int LastError = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=59, nodefault};
	__property short SuppressExceptions = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=60, nodefault};
	__property short Speaking = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=61, nodefault};
	__property int LastWordPosition = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=62, nodefault};
	__property short LipType = {read=GetSmallintProp, write=SetSmallintProp, stored=false, index=63, nodefault};
	__property System::WideString Sayit = {read=GetWideStringProp, write=SetWideStringProp, stored=false, index=66};
	__property System::WideString FileName = {read=GetWideStringProp, write=SetWideStringProp, stored=false, index=68};
	__property int CurrentMode = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=69, nodefault};
	__property int VolumeLeft = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=72, nodefault};
	__property int MinVolumeLeft = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=73, nodefault};
	__property int MaxVolumeLeft = {read=GetIntegerProp, write=SetIntegerProp, stored=false, index=74, nodefault};
	__property TDirectSSClickIn OnClickIn = {read=FOnClickIn, write=FOnClickIn};
	__property TDirectSSClickOut OnClickOut = {read=FOnClickOut, write=FOnClickOut};
	__property TDirectSSAudioStart OnAudioStart = {read=FOnAudioStart, write=FOnAudioStart};
	__property TDirectSSAudioStop OnAudioStop = {read=FOnAudioStop, write=FOnAudioStop};
	__property TDirectSSAttribChanged OnAttribChanged = {read=FOnAttribChanged, write=FOnAttribChanged};
	__property TDirectSSVisual OnVisual = {read=FOnVisual, write=FOnVisual};
	__property TDirectSSWordPosition OnWordPosition = {read=FOnWordPosition, write=FOnWordPosition};
	__property TDirectSSBookMark OnBookMark = {read=FOnBookMark, write=FOnBookMark};
	__property TDirectSSTextDataStarted OnTextDataStarted = {read=FOnTextDataStarted, write=FOnTextDataStarted};
	__property TDirectSSTextDataDone OnTextDataDone = {read=FOnTextDataDone, write=FOnTextDataDone};
	__property TDirectSSActiveVoiceStartup OnActiveVoiceStartup = {read=FOnActiveVoiceStartup, write=FOnActiveVoiceStartup};
	__property System::Classes::TNotifyEvent OnDebugging = {read=FOnDebugging, write=FOnDebugging};
	__property TDirectSSError OnError = {read=FOnError, write=FOnError};
	__property TDirectSSwarning Onwarning = {read=FOnwarning, write=FOnwarning};
	__property TDirectSSVisualFuture OnVisualFuture = {read=FOnVisualFuture, write=FOnVisualFuture};
public:
	/* TOleControl.Destroy */ inline __fastcall virtual ~TDirectSS(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TDirectSS(HWND ParentWindow) : Vcl::Olectrls::TOleControl(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 ACTIVEVOICEPROJECTLibMajorVersion = System::Int8(0x1);
static const System::Int8 ACTIVEVOICEPROJECTLibMinorVersion = System::Int8(0x0);
static const System::Int8 ACTIVELISTENPROJECTLibMajorVersion = System::Int8(0x1);
static const System::Int8 ACTIVELISTENPROJECTLibMinorVersion = System::Int8(0x0);
static const System::Int8 TELLibMajorVersion = System::Int8(0x1);
static const System::Int8 TELLibMinorVersion = System::Int8(0x0);
extern DELPHI_PACKAGE GUID LIBID_ACTIVEVOICEPROJECTLib;
extern DELPHI_PACKAGE GUID DIID__DirectSSEvents;
extern DELPHI_PACKAGE GUID IID_IDirectSS;
extern DELPHI_PACKAGE GUID CLASS_DirectSS;
extern DELPHI_PACKAGE GUID CLASS_VoiceProp;
extern DELPHI_PACKAGE GUID LIBID_ACTIVELISTENPROJECTLib;
extern DELPHI_PACKAGE GUID DIID__DirectSREvents;
extern DELPHI_PACKAGE GUID IID_IDirectSR;
extern DELPHI_PACKAGE GUID CLASS_DirectSR;
extern DELPHI_PACKAGE GUID LIBID_TELLib;
static const System::Int8 LANG_LEN = System::Int8(0x40);
#define SID_IAudioMultiMediaDevice L"{B68AD320-C743-11cd-80E5-00AA003E4B50}"
#define SID_IAudioTel L"{2EC5A8A7-E65B-11D0-8FAC-08002BE4E62A}"
}	/* namespace Adisapi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADISAPI)
using namespace Adisapi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdisapiHPP
