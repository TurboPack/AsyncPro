(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADSAPIEN.PAS 4.06                   *}
{*********************************************************}
{* TApdSAPIEngine component                              *}
{*********************************************************}

{
  provides Text-to-Speech and Speech-to-Text using SAPI 4. SAPI 4 is available
  for Win9x/ME/2K/XP.  SAPI 5 is a newer, more flexible API, but it was not
  functional when APRO 4 was released. You'll probably need to install SAPI 4
  since it is not installed by default.
    The SAPI4 SDK can be downloaded from
    http://www.microsoft.com/downloads/release.asp?ReleaseID=26299. The
    Spchapi.exe download from that site is 848K, and contains just the
    supporting API, it does not contain any speech recognition or synthesis
    engines.  The SAPI4SDK.exe (8,023k) and SAPI4SDKSuite.exe (40,001K)
    downloads contain the API binaries as well as recognition/systhesis engines
    and the SDK examples and help.  The MS-supplied speech recognition and
    speech synthesis engines only support English, but other third-party
    providers have engines tailored for different languages. There are several
    third-party speech engine providers that can be used with the Speech API,
    here are a few links:
    http://www.lhsl.com/default2.htm
    http://www.att.com/aspg/
    http://www.lucent.com/products/solution/0,,CTID+2002-STID+10054-SOID+851-LOCL+1,00.html
    http://www.dragonsys.com/products/dev_main.html
    http://www-4.ibm.com/software/speech/

    A www.google.com search for "speech engine" came up with a bunch of
    other sources also.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdSapiEn;

interface

uses                                   
  Windows,
  ActiveX,
  Classes,
  Graphics,
  {$IFDEF Delphi5}
  OleServer,
  {$ENDIF}
  OleCtrls,
  StdVCL,
  SysUtils,
  Controls,
  OoMisc,
  AdISapi,
  AdSapiGr,
  {$IFDEF Delphi5}
  Contnrs,
  {$ENDIF}
  Messages,
  Forms,
  Dialogs,  
  AdExcept,
  ComObj;

const

  { Constants from the Speech API }

  { TTS Character Sets }

  ApdCHARSET_TEXT                  = $00;
  ApdCHARSET_IPAPHONETIC           = $01;
  ApdCHARSET_ENGINEPHONETIC        = $02;

  { TTS Options }

  ApdTTSDATAFLAG_TAGGED            = $01;

  { TTS Ages }

  ApdTTSAGE_BABY                   = 1;
  ApdTTSAGE_TODDLER                = 3;
  ApdTTSAGE_CHILD                  = 6;
  ApdTTSAGE_ADOLESCENT             = 14;
  ApdTTSAGE_ADULT                  = 30;
  ApdTTSAGE_ELDERLY                = 70;

  { TTS Features }

  ApdTTSFEATURE_ANYWORD            = $00001;
  ApdTTSFEATURE_VOLUME             = $00002;
  ApdTTSFEATURE_SPEED              = $00004;
  ApdTTSFEATURE_PITCH              = $00008;
  ApdTTSFEATURE_TAGGED             = $00010;
  ApdTTSFEATURE_IPAUNICODE         = $00020;
  ApdTTSFEATURE_VISUAL             = $00040;
  ApdTTSFEATURE_WORDPOSITION       = $00080;
  ApdTTSFEATURE_PCOPTIMIZED        = $00100;
  ApdTTSFEATURE_PHONEOPTIMIZED     = $00200;
  ApdTTSFEATURE_FIXEDAUDIO         = $00400;
  ApdTTSFEATURE_SINGLEINSTANCE     = $00800;
  ApdTTSFEATURE_THREADSAFE         = $01000;
  ApdTTSFEATURE_IPATEXTDATA        = $02000;
  ApdTTSFEATURE_PREFERRED          = $04000;
  ApdTTSFEATURE_TRANSPLANTED       = $08000;
  ApdTTSFEATURE_SAPI4              = $10000;

  { TTS Genders }

  ApdGENDER_NEUTRAL                = 0;
  ApdGENDER_FEMALE                 = 1;
  ApdGENDER_MALE                   = 2;

  { TTS Interfaces }

  ApdTTSI_ILEXPRONOUNCE            = $01;
  ApdTTSI_ITTSATTRIBUTES           = $02;
  ApdTTSI_ITTSCENTRAL              = $04;
  ApdTTSI_ITTSDIALOGS              = $08;
  ApdTTSI_ATTRIBUTES               = $10;
  ApdTTSI_IATTRIBUTES              = $10;
  ApdTTSI_ILEXPRONOUNCE2           = $20;

  { SR Features }

  ApdSRFEATURE_INDEPSPEAKER        = $00001;
  ApdSRFEATURE_INDEPMICROPHONE     = $00002;
  ApdSRFEATURE_TRAINWORD           = $00004;
  ApdSRFEATURE_TRAINPHONETIC       = $00008;
  ApdSRFEATURE_WILDCARD            = $00010;
  ApdSRFEATURE_ANYWORD             = $00020;
  ApdSRFEATURE_PCOPTIMIZED         = $00040;
  ApdSRFEATURE_PHONEOPTIMIZED      = $00080;
  ApdSRFEATURE_GRAMLIST            = $00100;
  ApdSRFEATURE_GRAMLINK            = $00200;
  ApdSRFEATURE_MULTILINGUAL        = $00400;
  ApdSRFEATURE_GRAMRECURSIVE       = $00800;
  ApdSRFEATURE_IPAUNICODE          = $01000;
  ApdSRFEATURE_SINGLEINSTANCE      = $02000;
  ApdSRFEATURE_THREADSAFE          = $04000;
  ApdSRFEATURE_FIXEDAUDIO          = $08000; 
  ApdSRFEATURE_IPAWORD             = $10000;
  ApdSRFEATURE_SAPI4               = $20000;

  { SR Supported grammar types }

  ApdSRGRAM_CFG                    = $1;
  ApdSRGRAM_DICTATION              = $2;
  ApdSRGRAM_LIMITEDDOMAIN          = $4;

  { SR Interfaces }

  ApdSRI_ILEXPRONOUNCE             = $0000001;
  ApdSRI_ISRATTRIBUTES             = $0000002;
  ApdSRI_ISRCENTRAL                = $0000004;
  ApdSRI_ISRDIALOGS                = $0000008;
  ApdSRI_ISRGRAMCOMMON             = $0000010;
  ApdSRI_ISRGRAMCFG                = $0000020;
  ApdSRI_ISRGRAMDICTATION          = $0000040;
  ApdSRI_ISRGRAMINSERTIONGUI       = $0000080;
  ApdSRI_ISRESBASIC                = $0000100;
  ApdSRI_ISRESMERGE                = $0000200;
  ApdSRI_ISRESAUDIO                = $0000400;
  ApdSRI_ISRESCORRECTION           = $0000800;
  ApdSRI_ISRESEVAL                 = $0001000;
  ApdSRI_ISRESGRAPH                = $0002000;
  ApdSRI_ISRESMEMORY               = $0004000;
  ApdSRI_ISRESMODIFYGUI            = $0008000;
  ApdSRI_ISRESSPEAKER              = $0010000;
  ApdSRI_ISRSPEAKER                = $0020000;
  ApdSRI_ISRESSCORES               = $0040000;
  ApdSRI_ISRESAUDIOEX              = $0080000;
  ApdSRI_ISRGRAMLEXPRON            = $0100000;
  ApdSRI_ISRRESGRAPHEX             = $0200000;
  ApdSRI_ILEXPRONOUNCE2            = $0400000;
  ApdSRI_IATTRIBUTES               = $0800000;
  ApdSRI_ISRSPEAKER2               = $1000000;
  ApdSRI_ISRDIALOGS2               = $2000000;

  { SR Sequences }

  ApdSRSEQUENCE_DISCRETE           = 0;
  ApdSRSEQUENCE_CONTINUOUS         = 1;
  ApdSRSEQUENCE_WORDSPOT           = 2;
  ApdSRSEQUENCE_CONTCFGDISCDICT    = 3;

  { SR Interference Types }

  ApdSRMSGINT_NOISE                = $0001;
  ApdSRMSGINT_NOSIGNAL             = $0002;
  ApdSRMSGINT_TOOLOUD              = $0003;
  ApdSRMSGINT_TOOQUIET             = $0004;
  ApdSRMSGINT_AUDIODATA_STOPPED    = $0005;
  ApdSRMSGINT_AUDIODATA_STARTED    = $0006;
  ApdSRMSGINT_IAUDIO_STARTED       = $0007;
  ApdSRMSGINT_IAUDIO_STOPPED       = $0008;

  { SR Training Requests }

  ApdSRGNSTRAIN_GENERAL            =  $01;
  ApdSRGNSTRAIN_GRAMMAR            =  $02;
  ApdSRGNSTRAIN_MICROPHONE         =  $04;

  { SS Error codes }

  ApdTTSERR_NONE                   = $00000000;
  ApdTTSERR_INVALIDINTERFACE       = $80004002;
  ApdTTSERR_OUTOFDISK              = $80040205;
  ApdTTSERR_NOTSUPPORTED           = $80004001;
  ApdTTSERR_VALUEOUTOFRANGE        = $8000FFFF;
  ApdTTSERR_INVALIDWINDOW          = $8004000F;
  ApdTTSERR_INVALIDPARAM           = $80070057;
  ApdTTSERR_INVALIDMODE            = $80040206;
  ApdTTSERR_INVALIDKEY             = $80040209;
  ApdTTSERR_WAVEFORMATNOTSUPPORTED = $80040202;
  ApdTTSERR_INVALIDCHAR            = $80040208;
  ApdTTSERR_QUEUEFULL              = $8004020A;
  ApdTTSERR_WAVEDEVICEBUSY         = $80040203;
  ApdTTSERR_NOTPAUSED              = $80040501;
  ApdTTSERR_ALREADYPAUSED          = $80040502;

  { SR Error Codes }

  ApdSRERR_NONE                    = $00000000;
  ApdSRERR_OUTOFDISK               = $80040205;
  ApdSRERR_NOTSUPPORTED            = $80004001;
  ApdSRERR_NOTENOUGHDATA           = $80040201;
  ApdSRERR_VALUEOUTOFRANGE         = $8000FFFF;
  ApdSRERR_GRAMMARTOOCOMPLEX       = $80040406;
  ApdSRERR_GRAMMARWRONGTYPE        = $80040407;
  ApdSRERR_INVALIDWINDOW           = $8004000F;
  ApdSRERR_INVALIDPARAM            = $80070057;
  ApdSRERR_INVALIDMODE             = $80040206;
  ApdSRERR_TOOMANYGRAMMARS         = $8004040B;
  ApdSRERR_INVALIDLIST             = $80040207;
  ApdSRERR_WAVEDEVICEBUSY          = $80040203;
  ApdSRERR_WAVEFORMATNOTSUPPORTED  = $80040202;
  ApdSRERR_INVALIDCHAR             = $80040208;
  ApdSRERR_GRAMTOOCOMPLEX          = $80040406;
  ApdSRERR_GRAMTOOLARGE            = $80040411;
  ApdSRERR_INVALIDINTERFACE        = $80004002;
  ApdSRERR_INVALIDKEY              = $80040209;
  ApdSRERR_INVALIDFLAG             = $80040204;
  ApdSRERR_GRAMMARERROR            = $80040416;
  ApdSRERR_INVALIDRULE             = $80040417;
  ApdSRERR_RULEALREADYACTIVE       = $80040418;
  ApdSRERR_RULENOTACTIVE           = $80040419;
  ApdSRERR_NOUSERSELECTED          = $8004041A;
  ApdSRERR_BAD_PRONUNCIATION       = $8004041B;
  ApdSRERR_DATAFILEERROR           = $8004041C;
  ApdSRERR_GRAMMARALREADYACTIVE    = $8004041D;
  ApdSRERR_GRAMMARNOTACTIVE        = $8004041E;
  ApdSRERR_GLOBALGRAMMARALREADYACTIVE = $8004041F;
  ApdSRERR_LANGUAGEMISMATCH        = $80040420;
  ApdSRERR_MULTIPLELANG            = $80040421;
  ApdSRERR_LDGRAMMARNOWORDS        = $80040422;
  ApdSRERR_NOLEXICON               = $80040423;
  ApdSRERR_SPEAKEREXISTS           = $80040424;
  ApdSRERR_GRAMMARENGINEMISMATCH   = $80040425;
  ApdSRERR_BOOKMARKEXISTS          = $80040426;
  ApdSRERR_BOOKMARKDOESNOTEXIST    = $80040427;
  ApdSRERR_MICWIZARDCANCELED       = $80040428;
  ApdSRERR_WORDTOOLONG             = $80040429;
  ApdSRERR_BAD_WORD                = $8004042A;
  ApdE_WRONGTYPE                   = $8004020C;
  ApdE_BUFFERTOOSMALL              = $8004020D;

type

  TApdSapiDuplex = (sdFull, sdHalf, sdHalfDelayed);
  TApdSapiWaitMode = (wmNone, wmWaitSpeaking, wmWaitListening,
                      wmRestoreListen);
  TApdCharacterSet = (csText, csIPAPhonetic, csEnginePhonetic);
  TApdTTSOptions = set of (toTagged);
  TApdTTSAge = (tsBaby, tsToddler, tsChild, tsAdolescent, tsAdult, tsElderly,
                tsUnknown);
  TApdTTSFeatures = set of (tfAnyWord, tfVolume, tfSpeed, tfPitch, tfTagged,
                            tfIPAUnicode, tfVisual, tfWordPosition,
                            tfPCOptimized, tfPhoneOptimized, tfFixedAudio,
                            tfSingleInstance, tfThreadSafe, tfIPATextData,
                            tfPreferred, tfTransplanted, tfSAPI4);
  TApdTTSGender = (tgNeutral, tgFemale, tgMale, tgUnknown);
  TApdTTSInterfaces = set of (tiLexPronounce, tiTTSAttributes, tiTTSCentral,
                              tiTTSDialogs, tiAttributes, tiIAttributes,
                              tiLexPronounce2);

  TApdSRFeatures = set of (sfIndepSpeaker, sfIndepMicrophone, sfTrainWord,
                           sfTrainPhonetic, sfWildcard, sfAnyWord,
                           sfPCOptimized, sfPhoneOptimized, sfGramList,
                           sfGramLink, sfMultiLingual, sfGramRecursive,
                           sfIPAUnicode, sfSingleInstance, sfThreadSafe,
                           sfFixedAudio, sfIPAWord, sfSAPI4);
  TApdSRGrammars = set of (sgCFG, sgDictation, sgLimitedDomain);
  TApdSRInterfaces = set of (siLexPronounce, siSRAttributes, siSRCentral,
                             siSRGramCommon, siSRDialogs, siSRGramCFG,
                             siSRGramDictation, siSRGramInsertionGui,
                             siSREsBasic, siSREsMerge, siSREsAudio,
                             siSREsCorrection, siSREsEval, siSREsGraph,
                             siSREsMemory, siSREsModifyGui, siSREsSpeaker,
                             siSRSpeaker, siSREsScores, siSREsAudioEx,
                             siSRGramLexPron, siSREsGraphEx, siLexPronounce2,
                             siAttributes, siSRSpeaker2, siSRDialogs2);
  TApdSRSequences = (ssDiscrete, ssContinuous, ssWordSpot, ssContCFGDiscDict,
                     ssUnknown);
  TApdSRInterferenceType = (itAudioStarted, itAudioStopped, itDeviceOpened,
                            itDeviceClosed, itNoise, itTooLoud, itTooQuiet,
                            itUnknown);
  TApdSRTrainingType = set of (ttCurrentMic, ttCurrentGrammar, ttGeneral);

  { Event types }

  TApdOnSapiError =
      procedure (Sender : TObject; Error : LongWord;
                 const Details : string; const Message : string) of object;
  TApdSapiNotifyEvent =
      procedure (Sender : TObject) of object;
  TApdSRInterferenceEvent =
      procedure (Sender : TObject;
                 InterferenceType : TApdSRInterferenceType) of object;
  TApdSRPhraseFinishEvent =
      procedure (Sender : TObject; const Phrase : string) of object;
  TApdSRPhraseHypothesisEvent =
      procedure (Sender : TObject; const Phrase : string) of object;
  TApdSRTrainingRequestedEvent =
      procedure (Sender : TObject; Training : TApdSRTrainingType) of object;
  TApdSRVUMeterEvent =
      procedure (Sender : TObject; Level : Integer) of object;
  TApdSSAttributeChanged =
      procedure (Sender : TObject; Attribute: Integer) of object;

  { Hook methods }

  TApdPhraseFinishMethod =
    procedure (Sender : TObject; Phrase : string; Results : Integer) of object;
  PApdPhraseFinishMethod = ^TApdPhraseFinishMethod;

  TApdRegisteredEventTypes = (etPhraseFinish);
  PApdRegisteredEvent = ^TApdRegisteredEvent;
  TApdRegisteredEvent = record
    CallBack : TApdPhraseFinishMethod;
    EventType : TApdRegisteredEventTypes;
    Active : Boolean;
  end;

  { Exceptions }

  EApdSapiEngineException = class (Exception)
    private
      FErrorCode : Integer;

    public
      constructor Create (const ErrCode : Integer; const Msg : string);
      { Note: ErrCode is before the string to prevent problems in compiling
              with C++ Builder }

    published
      property ErrorCode : Integer read FErrorCode;
  end;

  { TApdSSVoices }
  
  TApdSSVoices = class (TObject)
    private
      FCurrentVoice : Integer;
      FiDirectSS    : TDirectSS;

    protected
      function CheckIndex (x : Integer) : Boolean;
      function GetAge (x : Integer) : TApdTTSAge;
      function GetCount : Integer;
      function GetCurrentVoice : Integer;
      function GetDialect (x : Integer) : string;
      function GetEngineFeatures (x : Integer) : Integer;
      function GetEngineID (x : Integer) : string;
      function GetFeatures (x : Integer) : TApdTTSFeatures;
      function GetGender (x : Integer) : TApdTTSGender;
      function GetInterfaces (x : Integer) : TApdTTSInterfaces;
      function GetLanguageID (x : Integer) : Integer;
      function GetMfgName (x : Integer) : string;
      function GetModeID (x : Integer) : string;
      function GetModeName (x : Integer) : string;
      function GetProductName (x : Integer) : string;
      function GetSpeaker (x : Integer) : string;
      function GetStyle (x : Integer) : string;
      procedure SetCurrentVoice (v : Integer);

    public
      function Find (Criteria : string) : Integer;

      property Age[x : Integer] : TApdTTSAge read GetAge;
      property Dialect[x : Integer] : string read GetDialect;
      property EngineFeatures[x : Integer] : Integer read GetEngineFeatures;
      property EngineID[x : Integer] : string read GetEngineID;
      property Features[x : Integer] : TApdTTSFeatures read GetFeatures;
      property Gender[x : Integer] : TApdTTSGender read GetGender;
      property Interfaces[x : Integer] : TApdTTSInterfaces read GetInterfaces;
      property LanguageID[x : Integer] : Integer read GetLanguageID;
      property MfgName[x : Integer] : string read GetMfgName;
      property ModeID[x : Integer] : string read GetModeID;
      property ModeName[x : Integer] : string read GetModeName; default;
      property ProductName[x : Integer] : string read GetProductName;
      property Speaker[x : Integer] : string read GetSpeaker;
      property Style[x : Integer] : string read GetStyle;

    published
      property Count : Integer read GetCount;
      property CurrentVoice : Integer
               read GetCurrentVoice write SetCurrentVoice;
  end;

  { TApdSREngines }
  
  TApdSREngines = class (TObject)
    private
      FCurrentEngine : Integer;
      FiDirectSR     : TDirectSR;

    protected
      function  CheckIndex (x : Integer) : Boolean;

      function  GetCount : Integer;
      function  GetCurrentEngine : Integer;
      function  GetDialect (x : Integer) : string;
      function  GetEngineFeatures (x : Integer) : Integer;
      function  GetEngineId (x : Integer) : string;
      function  GetFeatures (x : Integer) : TApdSRFeatures;
      function  GetGrammars (x : Integer) : TApdSRGrammars;
      function  GetInterfaces (x : Integer) : TApdSRInterfaces;
      function  GetLanguageID (x : Integer) : Integer;
      function  GetMaxWordsState (x : Integer) : Integer;
      function  GetMaxWordsVocab (x : Integer) : Integer;
      function  GetMfgName (x : Integer) : string;
      function  GetModeID (x : Integer) : string;
      function  GetModeName (x : Integer) : string;
      function  GetProductName (x : Integer) : string;
      function  GetSequencing (x : Integer) : TApdSRSequences;
      procedure SetCurrentEngine (v : Integer);

    public
      property Dialect[x : Integer] : string read GetDialect;
      property EngineFeatures[x : Integer] : Integer read GetEngineFeatures;
      property EngineID[x : Integer] : string read GetEngineID;
      property Features[x : Integer] : TApdSRFeatures read GetFeatures;
      property Grammars[x : Integer] : TApdSRGrammars read GetGrammars;
      property Interfaces[x : Integer] : TApdSRInterfaces read GetInterfaces;
      property LanguageID[x : Integer] : Integer read GetLanguageID;
      property MaxWordsState[x : Integer] : Integer read GetMaxWordsState;
      property MaxWordsVocab[x : Integer] : Integer read GetMaxWordsVocab;
      property MfgName[x : Integer] : string read GetMfgName;
      property ModeID[x : Integer] : string read GetModeID;
      property ModeName[x : Integer] : string read GetModeName; default;
      property ProductName[x : Integer] : string read GetProductName;
      property Sequencing[x : Integer] : TApdSRSequences read GetSequencing;

    published
      property Count : Integer read GetCount;
      property CurrentEngine : Integer
               read GetCurrentEngine write SetCurrentEngine;

  end;

  { TApdCustomSapiEngine }

  TApdCustomSapiEngine = class (TApdBaseComponent) 
    private
      FiDirectSR                : TDirectSR;
      FiDirectSS                : TDirectSS;
      FCharSet                  : TApdCharacterSet;
      FDictation                : Boolean;
      FSpeaking                 : Boolean;
      FListening                : Boolean;
      FSRAmplitude              : Word;
      FSRAutoGain               : Integer;
      FTTSOptions               : TApdTTSOptions;
      FWordList                 : TStringList;
      FSREngines                : TApdSREngines;
      FSSVoices                 : TApdSSVoices;
      FPhraseFinishClients      : TList;
      FHandle                   : HWnd;
      FAutoTrain                : Boolean;
      FDuplex                   : TApdSapiDuplex;
      FWaitMode                 : TApdSapiWaitMode;
      FInitSR                   : Boolean;                               {!!.04}
      FInitSS                   : Boolean;                               {!!.04}

      FOnInterference           : TApdSRInterferenceEvent;
      FOnPhraseFinish           : TApdSRPhraseFinishEvent;
      FOnPhraseHypothesis       : TApdSRPhraseHypothesisEvent;
      FOnSpeakStart             : TApdSapiNotifyEvent;
      FOnSpeakStop              : TApdSapiNotifyEvent;
      FOnSRError                : TApdOnSapiError;
      FOnSRWarning              : TApdOnSapiError;
      FOnSSAttributeChanged     : TApdSSAttributeChanged;
      FOnSSError                : TApdOnSapiError;
      FOnSSWarning              : TApdOnSapiError;
      FOnTrainingRequested      : TApdSRTrainingRequestedEvent;
      FOnVUMeter                : TApdSRVUMeterEvent;

    protected
      function GetSRAmplitude : Word;
      function GetSRAutoGain : Integer;
      procedure InitializeSpeaking (var CSet : Integer;
                                    var Options : Integer);
      procedure Loaded; override;
      procedure SetAutoTrain (v : Boolean);
      procedure SetCharSet (v : TApdCharacterSet);
      procedure SetDictation (v : Boolean);
      procedure SetDuplex (v : TApdSapiDuplex);
      procedure SetInitSR (const v : Boolean);                           {!!.04}
      procedure SetInitSS (const v : Boolean);                           {!!.04}                                  
      procedure SetListening (v : Boolean);
      procedure SetSpeaking (v : Boolean);
      procedure SetSRAutoGain (Value: Integer);
      procedure SetTTSOptions (v : TApdTTSOptions);
      procedure SetWordList (v : TStringList);

      procedure TriggerAudioStart (Sender : TObject; hi : Integer;
                                   lo : Integer);
      procedure TriggerAudioStop (Sender : TObject; hi : Integer;
                                  lo : Integer);
      procedure TriggerInterference (Sender : TObject; beginhi : Integer;
                                     beginlo : Integer; endhi : Integer;
                                     endlo : Integer; type_ : Integer);
      procedure TriggerPhraseFinish (Sender : TObject; flags : Integer;
                                     beginhi : Integer; beginlo : Integer;
                                     endhi : Integer; endlo : Integer;
                                     const Phrase : WideString;
                                     const parsed : WideString;
                                     results : Integer);
      procedure TriggerPhraseFinishClients (Phrase : string; Results : Integer);
      procedure TriggerPhraseHypothesis (Sender : TObject; flags : Integer;
                                         beginhi : Integer; beginlo : Integer;
                                         endhi : Integer; endlo : Integer;
                                         const Phrase : WideString;
                                         results : Integer);
      procedure TriggerSpeakStart (Sender : TObject; beginhi : Integer;
                                   beginlo : Integer);
      procedure TriggerSpeakStop (Sender : TObject; beginhi : Integer;
                                  beginlo : Integer; endhi : Integer;
                                  endlo : Integer);
      procedure TriggerSRError (Sender : TObject; Error : LongWord;
                                const Details : WideString;
                                const Message : WideString);
      procedure TriggerSRWarning (Sender : TObject; Error : LongWord;
                                  const Details : WideString;
                                  const Message : WideString);
      procedure TriggerSSAttribChanged (Sender : TObject; Attribute: Integer);
      procedure TriggerSSError (Sender : TObject; Error : LongWord;
                                const Details : WideString;
                                const Message : WideString);
      procedure TriggerSSWarning (Sender : TObject; Error : LongWord;
                                  const Details : WideString;
                                  const Message : WideString);
      procedure TriggerTrainingRequested (Sender : TObject; train : Integer);
      procedure TriggerVUMeter (Sender : TObject; beginhi : Integer;
                                beginlo : Integer; level : Integer);
      procedure WndProc (var Message : TMessage);

    public
      constructor Create (AOwner : TComponent); override;
      destructor Destroy; override;

      procedure CheckError (ErrorCode : DWORD);
      procedure DeRegisterPhraseFinishHook (
                                 PhraseFinishMethod : TApdPhraseFinishMethod);
      procedure InitializeSapi;                                        {!!.01}
      procedure InitializeSR;                                          {!!.04}
      procedure InitializeSS;                                          {!!.04}
      function IsSapi4Installed : Boolean;
      procedure Listen;
      procedure PauseListening;
      procedure PauseSpeaking;
      procedure RegisterPhraseFinishHook (
                                 PhraseFinishMethod : TApdPhraseFinishMethod);
      procedure ResumeListening;
      procedure ResumeSpeaking;
      procedure ShowAboutDlg (const Caption : string);
      procedure ShowGeneralDlg (const Caption : string);
      procedure ShowLexiconDlg (const Caption : string);
      procedure ShowSRAboutDlg (const Caption : string);
      procedure ShowSRGeneralDlg (const Caption : string);
      procedure ShowSRLexiconDlg (const Caption : string);
      procedure ShowSSAboutDlg (const Caption : string);
      procedure ShowSSGeneralDlg (const Caption : string);
      procedure ShowSSLexiconDlg (const Caption : string);
      procedure ShowTrainGeneralDlg (const Caption : string);
      procedure ShowTrainMicDlg (const Caption : string);
      procedure ShowTranslateDlg (const Caption : string);
      procedure Speak (Text : string);
      procedure SpeakFile (FileName : string);
      procedure SpeakFileToFile (const InFile, OutFile : string);
      procedure SpeakStream (Stream : TStream; FileName : string);
      procedure SpeakToFile (const Text, FileName : string);
      procedure StopListening;
      procedure StopSpeaking;
      procedure WaitUntilDoneSpeaking;

      property DirectSR : TDirectSR read FiDirectSR write FiDirectSR;
      property DirectSS : TDirectSS read FiDirectSS write FiDirectSS;
      property InitSR : Boolean read FInitSR write SetInitSR             {!!.04}
               default True;                                             {!!.04}
      property InitSS : Boolean read FInitSS write SetInitSS             {!!.04}
               default True;                                             {!!.04}
      property Listening : Boolean read FListening write SetListening;
      property Speaking : Boolean read FSpeaking write SetSpeaking;
      property SREngines: TApdSREngines
               read FSREngines write FSREngines;
      property SSVoices : TApdSSVoices
               read FSSVoices write FSSVoices;

    published
      property AutoTrain : Boolean read FAutoTrain write SetAutoTrain
               default False;
      property CharSet : TApdCharacterSet read FCharSet write SetCharSet;
      property Dictation : Boolean read FDictation write SetDictation;
      property Duplex : TApdSapiDuplex
               read FDuplex write SetDuplex default sdHalfDelayed;
      property SRAmplitude : Word read GetSRAmplitude;
      property SRAutoGain : Integer read GetSRAutoGain write SetSRAutoGain;
      property TTSOptions : TApdTTSOptions
               read FTTSOptions write SetTTSOptions;
      property WordList : TStringLIst read FWordList write SetWordList;

      property OnInterference : TApdSRInterferenceEvent
               read FOnInterference write FOnInterference;
      property OnPhraseFinish : TApdSRPhraseFinishEvent
               read FOnPhraseFinish write FOnPhraseFinish;
      property OnPhraseHypothesis : TApdSRPhraseHypothesisEvent
               read FOnPhraseHypothesis write FOnPhraseHypothesis;
      property OnSpeakStart : TApdSapiNotifyEvent
               read FOnSpeakStart write FOnSpeakStart;
      property OnSpeakStop : TApdSapiNotifyEvent
               read FOnSpeakStop write FOnSpeakStop;
      property OnSRError : TApdOnSapiError read FOnSRError write FOnSRError;
      property OnSRWarning : TApdOnSapiError
               read FOnSRWarning write FOnSRWarning;
      property OnSSAttributeChanged : TApdSSAttributeChanged
               read FOnSSAttributeChanged write FOnSSAttributeChanged;
      property OnSSError : TApdOnSapiError read FOnSSError write FOnSSError;
      property OnSSWarning : TApdOnSapiError
               read FOnSSWarning write FOnSSWarning;
      property OnTrainingRequested : TApdSRTrainingRequestedEvent
               read FOnTrainingRequested write FOnTrainingRequested;
      property OnVUMeter : TApdSRVUMeterEvent
               read FOnVUMeter write FOnVUMeter;
  end;

  TApdSapiEngine = class (TApdCustomSapiEngine)
    published
      property CharSet;
      property Dictation;
      property SRAmplitude;
      property SRAutoGain;
      property TTSOptions;
      property WordList;

      property OnInterference;
      property OnPhraseFinish;
      property OnPhraseHypothesis;
      property OnSpeakStart;
      property OnSpeakStop;
      property OnSRError;
      property OnSRWarning;
      property OnSSAttributeChanged;
      property OnSSError;
      property OnSSWarning;
      property OnTrainingRequested;
      property OnVUMeter;
  end;

{.Z+}
function SearchSapiEngine (const C : TComponent) : TApdCustomSapiEngine;
{.Z-}

implementation

{Miscellaneous procedures}

function SearchSapiEngine (const C : TComponent) : TApdCustomSapiEngine;
{-Search for a sapi engine in the same form as TComponent}

  function FindSapiEngine (const C : TComponent) : TApdCustomSapiEngine;
  var
    I  : Integer;
  begin
    Result := nil;
    if not Assigned (C) then
      Exit;

    {Look through all of the owned components}
    for I := 0 to C.ComponentCount - 1 do begin
      if C.Components[I] is TApdCustomSapiEngine then begin
        Result := TApdCustomSapiEngine (C.Components[I]);
        Exit;
      end;

      {If this isn't one, see if it owns other components}
      Result := FindSapiEngine (C.Components[I]);
    end;
  end;

begin
  {Search the entire form}
  Result := FindSapiEngine (C);
end;

{ EApdSapiEngineException }

constructor EApdSapiEngineException.Create (const ErrCode : Integer;
                                            const Msg : string);
begin
  inherited Create (Msg);

  FErrorCode := ErrCode;
end;

{ TApdSSVoices }

function TApdSSVoices.CheckIndex (x : Integer) : Boolean;
begin
  if not Assigned (FiDirectSS) then
    raise EApdSapiEngineException.CreateFmt (ecApdNOSS, [0]);
  if (x < 0) or (x >= FiDirectSS.CountEngines) then
    raise EApdSapiEngineException.CreateFmt (ecApdBadIndex, [0]);
  Result := True;
end;

function TApdSSVoices.Find (Criteria : string) : Integer;
begin
  Result := FiDirectSS.Find (Criteria);
end;

function TApdSSVoices.GetAge (x : Integer) : TApdTTSAge;

  function ConvertAge (v : Integer) : TApdTTSAge;
  begin
    case v of
      ApdTTSAGE_BABY       : Result := tsBaby;
      ApdTTSAGE_TODDLER    : Result := tsToddler;
      ApdTTSAGE_CHILD      : Result := tsChild;
      ApdTTSAGE_ADOLESCENT : Result := tsAdolescent;
      ApdTTSAGE_ADULT      : Result := tsAdult;
      ApdTTSAGE_ELDERLY    : Result := tsElderly;
    else
      Result := tsUnknown;
    end;
  end;

begin
  CheckIndex (x);
  Result := ConvertAge (FiDirectSS.Age (x + 1));
end;

function TApdSSVoices.GetCount : Integer;
begin
  Result := FiDirectSS.CountEngines;
end;

function TApdSSVoices.GetCurrentVoice : Integer;
begin
  result := FCurrentVoice;
end;

function TApdSSVoices.GetDialect (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSS.Dialect (x + 1);
end;

function TApdSSVoices.GetEngineFeatures (x : Integer) : Integer;
begin
  CheckIndex (x);
  Result := FiDirectSS.EngineFeatures (x + 1);
end;

function TApdSSVoices.GetEngineID (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSS.EngineID (x + 1);
end;

function TApdSSVoices.GetFeatures (x : Integer) : TApdTTSFeatures;

  function ConvertFeatures (v : Integer) :  TApdTTSFeatures;
  begin
    Result := [];
    if (v and ApdTTSFEATURE_ANYWORD) <> 0 then
      Result := Result + [tfAnyWord];
    if (v and ApdTTSFEATURE_VOLUME) <> 0 then
      Result := Result + [tfVolume];
    if (v and ApdTTSFEATURE_SPEED) <> 0 then
      Result := Result + [tfSpeed];
    if (v and ApdTTSFEATURE_PITCH) <> 0 then
      Result := Result + [tfPitch];
    if (v and ApdTTSFEATURE_TAGGED) <> 0 then
      Result := Result + [tfTagged];
    if (v and ApdTTSFEATURE_IPAUNICODE) <> 0 then
      Result := Result + [tfIPAUnicode];
    if (v and ApdTTSFEATURE_VISUAL) <> 0 then
      Result := Result + [tfVisual];
    if (v and ApdTTSFEATURE_WORDPOSITION) <> 0 then
      Result := Result + [tfWordPosition];
    if (v and ApdTTSFEATURE_PCOPTIMIZED) <> 0 then
      Result := Result + [tfPCOptimized];
    if (v and ApdTTSFEATURE_PHONEOPTIMIZED) <> 0 then
      Result := Result + [tfPhoneOptimized];
    if (v and ApdTTSFEATURE_FIXEDAUDIO) <> 0 then
      Result := Result + [tfFixedAudio];
    if (v and ApdTTSFEATURE_SINGLEINSTANCE) <> 0 then
      Result := Result + [tfSingleInstance];
    if (v and ApdTTSFEATURE_THREADSAFE) <> 0 then
      Result := Result + [tfThreadSafe];
    if (v and ApdTTSFEATURE_IPATEXTDATA) <> 0 then
      Result := Result + [tfIPATextData];
    if (v and ApdTTSFEATURE_PREFERRED) <> 0 then
      Result := Result + [tfPreferred];
    if (v and ApdTTSFEATURE_TRANSPLANTED) <> 0 then
      Result := Result + [tfTransplanted];
    if (v and ApdTTSFEATURE_SAPI4) <> 0 then
      Result := Result + [tfSAPI4];
  end;

begin
  CheckIndex (x);
  Result := ConvertFeatures (FiDirectSS.Features (x + 1));
end;

function TApdSSVoices.GetGender (x : Integer) : TApdTTSGender;

  function ConvertGender (v : Integer) : TApdTTSGender;
  begin
    case v of
      ApdGENDER_NEUTRAL : Result := tgNeutral;
      ApdGENDER_FEMALE  : Result := tgFemale;
      ApdGENDER_MALE    : Result := tgMale;
    else
       Result := tgUnknown;
    end;
  end;

begin
  CheckIndex (x);
  Result := ConvertGender (FiDirectSS.Gender (x + 1));
end;

function TApdSSVoices.GetInterfaces (x : Integer) : TApdTTSInterfaces;

  function ConvertInterfaces (v : Integer) : TApdTTSInterfaces;
  begin
    Result := [];
    if (v and ApdTTSI_ILEXPRONOUNCE) <> 0 then
      Result := Result + [tiLexPronounce];
    if (v and ApdTTSI_ITTSATTRIBUTES) <> 0 then
      Result := Result + [tiTTSAttributes];
    if (v and ApdTTSI_ITTSCENTRAL) <> 0 then
      Result := Result + [tiTTSCentral];
    if (v and ApdTTSI_ITTSDIALOGS) <> 0 then
      Result := Result + [tiTTSDialogs];
    if (v and ApdTTSI_ATTRIBUTES) <> 0 then
      Result := Result + [tiAttributes];
    if (v and ApdTTSI_IATTRIBUTES) <> 0 then
      Result := Result + [tiIAttributes];
    if (v and ApdTTSI_ILEXPRONOUNCE2) <> 0 then
      Result := Result + [tiLexPronounce2];
  end;

begin
  CheckIndex (x);
  Result := ConvertInterfaces (FiDirectSS.Interfaces (x + 1));
end;

function TApdSSVoices.GetLanguageID (x : Integer) : Integer;
begin
  CheckIndex (x);
  Result := FiDirectSS.LanguageID (x + 1);
end;

function TApdSSVoices.GetMfgName (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSS.MfgName (x + 1);
end;

function TApdSSVoices.GetModeID (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSS.ModeID (x + 1);
end;

function TApdSSVoices.GetModeName (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSS.ModeName (x + 1);
end;

function TApdSSVoices.GetProductName (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSS.ProductName (x + 1);
end;

function TApdSSVoices.GetSpeaker (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSS.Speaker (x + 1);
end;

function TApdSSVoices.GetStyle (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSS.Style (x + 1);
end;

procedure TApdSSVoices.SetCurrentVoice (v : Integer);
begin
  if v <> FCurrentVoice then begin
    CheckIndex (v);
    FiDirectSS.Select (v + 1);
    FCurrentVoice := v;
  end;
end;

{ TApdSREngines }

function TApdSREngines.CheckIndex (x : Integer) : Boolean;
begin
  if not Assigned (FiDirectSR) then
    raise EApdSapiEngineException.CreateFmt (ecApdNoSR, [0]);
  if (x < 0) or (x >= FiDirectSR.CountEngines) then
    raise EApdSapiEngineException.CreateFmt (ecApdBadIndex, [0]);
  Result := True;
end;

function TApdSREngines.GetCount : Integer;
begin
  Result := FiDirectSR.CountEngines;
end;

function TApdSREngines.GetCurrentEngine : Integer;
begin
  Result := FCurrentEngine;
end;

function TApdSREngines.GetDialect (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSR.Dialect (x + 1);
end;

function TApdSREngines.GetEngineFeatures (x : Integer) : Integer;
begin
  CheckIndex (x);
  Result := FiDirectSR.EngineFeatures (x + 1);
end;

function TApdSREngines.GetEngineId (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSR.EngineId (x + 1);
end;

function TApdSREngines.GetFeatures (x : Integer) : TApdSRFeatures;

  function ConvertFeatures (v : Integer) : TApdSRFeatures;
  begin
    Result := [];
    if (v and ApdSRFEATURE_INDEPSPEAKER) <> 0 then
      Result := Result + [sfIndepSpeaker];
    if (v and ApdSRFEATURE_INDEPMICROPHONE) <> 0 then
      Result := Result + [sfIndepMicrophone];
    if (v and ApdSRFEATURE_TRAINWORD) <> 0 then
      Result := Result + [sfTrainWord];
    if (v and ApdSRFEATURE_TRAINPHONETIC) <> 0 then
      Result := Result + [sfTrainPhonetic];
    if (v and ApdSRFEATURE_WILDCARD) <> 0 then
      Result := Result + [sfWildcard];
    if (v and ApdSRFEATURE_ANYWORD) <> 0 then
      Result := Result + [sfAnyWord];
    if (v and ApdSRFEATURE_PCOPTIMIZED) <> 0 then
      Result := Result + [sfPCOptimized];
    if (v and ApdSRFEATURE_PHONEOPTIMIZED) <> 0 then
      Result := Result + [sfPhoneOptimized];
    if (v and ApdSRFEATURE_GRAMLIST) <> 0 then
      Result := Result + [sfGramList];
    if (v and ApdSRFEATURE_GRAMLINK) <> 0 then
      Result := Result + [sfGramLink];
    if (v and ApdSRFEATURE_MULTILINGUAL) <> 0 then
      Result := Result + [sfMultiLingual];
    if (v and ApdSRFEATURE_GRAMRECURSIVE) <> 0 then
      Result := Result + [sfGramRecursive];
    if (v and ApdSRFEATURE_IPAUNICODE) <> 0 then
      Result := Result + [sfIPAUnicode];
    if (v and ApdSRFEATURE_SINGLEINSTANCE) <> 0 then
      Result := Result + [sfSingleInstance];
    if (v and ApdSRFEATURE_THREADSAFE) <> 0 then
      Result := Result + [sfThreadSafe];
    if (v and ApdSRFEATURE_FIXEDAUDIO) <> 0 then
      Result := Result + [sfFixedAudio];
    if (v and ApdSRFEATURE_IPAWORD) <> 0 then
      Result := Result + [sfIPAWord];
    if (v and ApdSRFEATURE_SAPI4) <> 0 then
      Result := Result + [sfSAPI4];
  end;

begin
  CheckIndex (x);
  Result := ConvertFeatures (FiDirectSR.Features (x + 1));
end;

function TApdSREngines.GetGrammars (x : Integer) : TApdSRGrammars;

  function ConvertGrammars (v : Integer) : TApdSRGrammars;
  begin
    Result := [];
    if (v and ApdSRGRAM_CFG) <> 0 then
      Result := Result + [sgCFG];
    if (v and ApdSRGRAM_DICTATION) <> 0 then
      Result := Result + [sgDictation];
    if (v and ApdSRGRAM_LIMITEDDOMAIN) <> 0 then
      Result := Result + [sgLimitedDomain];
  end;

begin
  CheckIndex (x);
  Result := ConvertGrammars (FiDirectSR.Grammars (x + 1));
end;

function TApdSREngines.GetInterfaces (x : Integer) : TApdSRInterfaces;

  function ConvertInterfaces (v : Integer) : TApdSRInterfaces;
  begin
    Result := [];
    if (v and ApdSRI_ILEXPRONOUNCE) <> 0 then
      Result := Result + [siLexPronounce];
    if (v and ApdSRI_ISRATTRIBUTES) <> 0 then
      Result := Result + [siSRAttributes];
    if (v and ApdSRI_ISRCENTRAL) <> 0 then
      Result := Result + [siSRCentral];
    if (v and ApdSRI_ISRDIALOGS) <> 0 then
      Result := Result + [siSRDialogs];
    if (v and ApdSRI_ISRGRAMCOMMON) <> 0 then
      Result := Result + [siSRGramCommon];
    if (v and ApdSRI_ISRGRAMCFG) <> 0 then
      Result := Result + [siSRGramCFG];
    if (v and ApdSRI_ISRGRAMDICTATION) <> 0 then
      Result := Result + [siSRGramDictation];
    if (v and ApdSRI_ISRGRAMINSERTIONGUI) <> 0 then
      Result := Result + [siSRGramInsertionGui];
    if (v and ApdSRI_ISRESBASIC) <> 0 then
      Result := Result + [siSREsBasic];
    if (v and ApdSRI_ISRESMERGE) <> 0 then
      Result := Result + [siSREsMerge];
    if (v and ApdSRI_ISRESAUDIO) <> 0 then
      Result := Result + [siSREsAudio];
    if (v and ApdSRI_ISRESCORRECTION) <> 0 then
      Result := Result + [siSREsCorrection];
    if (v and ApdSRI_ISRESEVAL) <> 0 then
      Result := Result + [siSREsEval];
    if (v and ApdSRI_ISRESGRAPH) <> 0 then
      Result := Result + [siSREsGraph];
    if (v and ApdSRI_ISRESMEMORY) <> 0 then
      Result := Result + [siSREsMemory];
    if (v and ApdSRI_ISRESMODIFYGUI) <> 0 then
      Result := Result + [siSREsModifyGui];
    if (v and ApdSRI_ISRESSPEAKER) <> 0 then
      Result := Result + [siSREsSpeaker];
    if (v and ApdSRI_ISRSPEAKER) <> 0 then
      Result := Result + [siSRSpeaker];
    if (v and ApdSRI_ISRESSCORES) <> 0 then
      Result := Result + [siSREsScores];
    if (v and ApdSRI_ISRESAUDIOEX) <> 0 then
      Result := Result + [siSREsAudioEx];
    if (v and ApdSRI_ISRGRAMLEXPRON) <> 0 then
      Result := Result + [siSRGramLexPron];
    if (v and ApdSRI_ISRRESGRAPHEX) <> 0 then
      Result := Result + [siSREsGraphEx];
    if (v and ApdSRI_ILEXPRONOUNCE2) <> 0 then
      Result := Result + [siLexPronounce2];
    if (v and ApdSRI_IATTRIBUTES) <> 0 then
      Result := Result + [siAttributes];
    if (v and ApdSRI_ISRSPEAKER2) <> 0 then
      Result := Result + [siSRSpeaker2];
    if (v and ApdSRI_ISRDIALOGS2) <> 0 then
      Result := Result + [siSRDialogs2];
  end;

begin
  CheckIndex (x);
  Result := ConvertInterfaces (FiDirectSR.Interfaces (x + 1));
end;

function TApdSREngines.GetLanguageID (x : Integer) : Integer;
begin
  CheckIndex (x);
  Result := FiDirectSR.LanguageID (x + 1);
end;

function TApdSREngines.GetMaxWordsState (x : Integer) : Integer;
begin
  CheckIndex (x);
  Result := FiDirectSR.MaxWordsState (x + 1);
end;

function TApdSREngines.GetMaxWordsVocab (x : Integer) : Integer;
begin
  CheckIndex (x);
  Result := FiDirectSR.MaxWordsVocab (x + 1);
end;

function TApdSREngines.GetMfgName (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSR.MfgName (x + 1);
end;

function TApdSREngines.GetModeID (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSR.ModeID (x + 1);
end;

function TApdSREngines.GetModeName (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSR.ModeName (x + 1);
end;

function TApdSREngines.GetProductName (x : Integer) : string;
begin
  CheckIndex (x);
  Result := FiDirectSR.ProductName (x + 1);
end;

function TApdSREngines.GetSequencing (x : Integer) : TApdSRSequences;

  function ConvertSequencing (v : Integer) : TApdSRSequences;
  begin
    case v of
      ApdSRSEQUENCE_DISCRETE        : Result := ssDiscrete;
      ApdSRSEQUENCE_CONTINUOUS      : Result := ssContinuous;
      ApdSRSEQUENCE_WORDSPOT        : Result := ssWordSpot;
      ApdSRSEQUENCE_CONTCFGDISCDICT : Result := ssContCFGDiscDict;
    else
      Result := ssUnknown;
    end;
  end;

begin
  CheckIndex (x);
  Result := ConvertSequencing (FiDirectSR.Sequencing (x + 1));
end;

procedure TApdSREngines.SetCurrentEngine (v : Integer);
begin
  if v <> FCurrentEngine then begin
    CheckIndex (v);
    FiDirectSR.Select (v + 1);
    FCurrentEngine := v;
  end;
end;

{ TApdCustomSapiEngine }                     

constructor TApdCustomSapiEngine.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);

  FInitSR := True;                                                     {!!.04}
  FInitSS := True;                                                     {!!.04}

  FHandle := AllocateHWnd (WndProc);

  (*if not IsSapi4Installed then begin                                 {!!.04}
    if Assigned (FOnSRError) then                                      {!!.04}
      FOnSRError (Self, 0, '', ApdStrE_NOSAPI4);                       {!!.04}
    if Assigned (FOnSSError) then                                      {!!.04}
      FOnSSError (Self, 0, '', ApdStrE_NOSAPI4);                       {!!.04}
  end; *)                                                              {!!.04}

  FSpeaking := False;
  FListening := False;
  FDuplex := sdHalfDelayed;
  FWaitMode := wmNone;

  { Create needed classes }

  FWordList := TStringList.Create;
  FSSVoices := TApdSSVoices.Create;
  FSREngines := TApdSREngines.Create;

  { Create Registers }

  FPhraseFinishClients := TList.Create;

  FiDirectSS := nil;
  FiDirectSR := nil;

  FAutoTrain := False;
end;

destructor TApdCustomSapiEngine.Destroy;
var
  i : Integer;
  
begin
  FWordList.Free;

  FSSVoices.Free;
  FSREngines.Free;

  for i := 0 to FPhraseFinishClients.Count - 1 do begin
    Dispose (FPhraseFinishClients[i]);
  end;
  FPhraseFinishClients.Free;

  if Assigned (FiDirectSS) then
    FiDirectSS.Free;
  if Assigned (FiDirectSR) then
    FiDirectSR.Free;

  if FHandle <> 0 then
    DeallocateHWnd (FHandle);
  inherited Destroy;
end;

procedure TApdCustomSapiEngine.CheckError (ErrorCode : DWORD);
begin
  case ErrorCode of
    ApdSRERR_NONE                       :
      begin
      end;

  { SS }

    ApdTTSERR_INVALIDINTERFACE          :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_INVALIDINTERFACE);
    ApdTTSERR_OUTOFDISK                 :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_OUTOFDISK);
    ApdTTSERR_NOTSUPPORTED              :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_NOTSUPPORTED);
    ApdTTSERR_VALUEOUTOFRANGE           :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_VALUEOUTOFRANGE);
    ApdTTSERR_INVALIDWINDOW             :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_INVALIDWINDOW);
    ApdTTSERR_INVALIDPARAM              :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_INVALIDPARAM);
    ApdTTSERR_INVALIDMODE               :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_INVALIDMODE);
    ApdTTSERR_INVALIDKEY                :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_INVALIDKEY);
    ApdTTSERR_WAVEFORMATNOTSUPPORTED    :
      raise EApdSapiEngineException.Create (ErrorCode,
                                          ApdStrTTSERR_WAVEFORMATNOTSUPPORTED);
    ApdTTSERR_INVALIDCHAR               :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_INVALIDCHAR);
    ApdTTSERR_QUEUEFULL                 :
      raise EApdSapiEngineException.Create (ErrorCode, ApdStrTTSERR_QUEUEFULL);
    ApdTTSERR_WAVEDEVICEBUSY            :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_WAVEDEVICEBUSY);
    ApdTTSERR_NOTPAUSED                 :
      raise EApdSapiEngineException.Create (ErrorCode, ApdStrTTSERR_NOTPAUSED);
    ApdTTSERR_ALREADYPAUSED             :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrTTSERR_ALREADYPAUSED);

  { SR }

    ApdSRERR_NOTENOUGHDATA              :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_NOTENOUGHDATA);
    ApdSRERR_GRAMMARTOOCOMPLEX          :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_GRAMMARTOOCOMPLEX);
    ApdSRERR_GRAMMARWRONGTYPE           :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_GRAMMARWRONGTYPE);
    ApdSRERR_TOOMANYGRAMMARS            :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_INVALIDLIST);
    ApdSRERR_INVALIDLIST                :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_INVALIDLIST);
    ApdSRERR_GRAMTOOLARGE               :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_GRAMTOOLARGE);
    ApdSRERR_INVALIDFLAG                :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_INVALIDFLAG);
    ApdSRERR_GRAMMARERROR               :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_GRAMMARERROR);
    ApdSRERR_INVALIDRULE                :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_INVALIDRULE);
    ApdSRERR_RULEALREADYACTIVE          :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_RULEALREADYACTIVE);
    ApdSRERR_RULENOTACTIVE              :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_RULENOTACTIVE);
    ApdSRERR_NOUSERSELECTED             :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_NOUSERSELECTED);
    ApdSRERR_BAD_PRONUNCIATION          :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_BAD_PRONUNCIATION);
    ApdSRERR_DATAFILEERROR              :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_DATAFILEERROR);
    ApdSRERR_GRAMMARALREADYACTIVE       :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_GRAMMARALREADYACTIVE);
    ApdSRERR_GRAMMARNOTACTIVE           :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_GRAMMARNOTACTIVE);
    ApdSRERR_GLOBALGRAMMARALREADYACTIVE :
      raise EApdSapiEngineException.Create (ErrorCode,
                                       ApdStrSRERR_GLOBALGRAMMARALREADYACTIVE);
    ApdSRERR_LANGUAGEMISMATCH           :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_LANGUAGEMISMATCH);
    ApdSRERR_MULTIPLELANG               :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_MULTIPLELANG);
    ApdSRERR_LDGRAMMARNOWORDS           :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_LDGRAMMARNOWORDS);
    ApdSRERR_NOLEXICON                  :
      raise EApdSapiEngineException.Create (ErrorCode, ApdStrSRERR_NOLEXICON);
    ApdSRERR_SPEAKEREXISTS              :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_SPEAKEREXISTS);
    ApdSRERR_GRAMMARENGINEMISMATCH      :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_GRAMMARENGINEMISMATCH);
    ApdSRERR_BOOKMARKEXISTS             :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_BOOKMARKEXISTS);
    ApdSRERR_BOOKMARKDOESNOTEXIST       :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_BOOKMARKDOESNOTEXIST);
    ApdSRERR_MICWIZARDCANCELED          :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_MICWIZARDCANCELED);
    ApdSRERR_WORDTOOLONG                :
      raise EApdSapiEngineException.Create (ErrorCode,
                                            ApdStrSRERR_WORDTOOLONG);
    ApdSRERR_BAD_WORD                   :
      raise EApdSapiEngineException.Create (ErrorCode, ApdStrSRERR_BAD_WORD);
    ApdE_WRONGTYPE                      :
      raise EApdSapiEngineException.Create (ErrorCode, ApdStrE_WRONGTYPE);
    ApdE_BUFFERTOOSMALL                 :
      raise EApdSapiEngineException.Create (ErrorCode, ApdStrE_BUFFERTOOSMALL);
    else
      raise EApdSapiEngineException.Create (ErrorCode, ApdStrE_UNKNOWN);
  end;
end;

procedure TApdCustomSapiEngine.DeRegisterPhraseFinishHook (
                                 PhraseFinishMethod : TApdPhraseFinishMethod);
var
  Idx : Integer;
  Event : PApdRegisteredEvent;

begin
  for Idx := FPhraseFinishClients.Count - 1 downto 0 do begin
    Event := FPhraseFinishClients[Idx];
    if (@Event.CallBack = @PhraseFinishMethod) then
      FPhraseFinishClients.Delete (Idx);
  end;
end;

function TApdCustomSapiEngine.GetSRAmplitude : Word;
begin
  result := FSRAmplitude;
end;

function TApdCustomSapiEngine.GetSRAutoGain : Integer;
begin
  if Assigned (FiDirectSR) then
    FSRAutoGain := FiDirectSR.AutoGain;
  Result := FSRAutoGain;
end;

procedure TApdCustomSapiEngine.InitializeSapi;                         {!!.01}
{ InitializeSapi is called by Loaded to initialize the SAPI engines }  {!!.01}
{ It should not be called directly UNLESS the TApdCustomSapiEngine  }  {!!.01}
{ is being created dynamically.  In this case, InitializeSapi       }  {!!.01}
{ be called after the creation to initialize the SAPI engine.       }  {!!.01}
begin                                                                  {!!.01}
  if InitSS then                                                       {!!.04}
    InitializeSS;                                                      {!!.04}
  if InitSR then                                                       {!!.04}
    InitializeSR;                                                      {!!.04}
end;                                                                   {!!.01}

procedure TApdCustomSapiEngine.InitializeSpeaking (var CSet : Integer;
                                                   var Options : Integer);
begin
  Speaking := True;
  case CharSet of
    csText           : CSet := ApdCHARSET_TEXT;
    csIPAPhonetic    : CSet := ApdCHARSET_IPAPHONETIC;
    csEnginePhonetic : CSet := ApdCHARSET_ENGINEPHONETIC;
  else
    CSet := ApdCHARSET_TEXT;
  end;
  Options := 0;
  if toTagged in TTSOptions then
    Options := Options or ApdTTSDATAFLAG_TAGGED;
end;

procedure TApdCustomSapiEngine.InitializeSR;                             {!!.04}
begin                                                                    {!!.04}
  if (not ((csDesigning in ComponentState) or                            {!!.04}
           (csLoading in ComponentState))) and                           {!!.04}
      (FiDirectSR = nil) then begin                                      {!!.04}

    { Create the SAPI Interaces }                                        {!!.04}

    try                                                                  {!!.04}
      FiDirectSR := TDirectSR.Create (Self);                             {!!.04}
      FiDirectSR.Visible := False;                                       {!!.04}
      FSREngines.FiDirectSR := FiDirectSR;                               {!!.04}
      FiDirectSR.Initialized := 1;                                       {!!.04}
    except                                                               {!!.04}
      on EOleError do                                                    {!!.04}
        TriggerSRError (Self, 0, '', ApdStrE_CANNOTCREATESR);            {!!.04}
    end;                                                                 {!!.04}

    { Set the speaker.  Since there doesn't seem to be a way to determine
      what the users are, use a default user.  Sapi will automatically
      use this user name. }

    try                                                                  {!!.04}
      FiDirectSR.Speaker := scApdDefaultUser;                            {!!.04}
    except                                                               {!!.04}
      on EOleError do                                                    {!!.04}
        TriggerSRError (Self, 0, '', ApdStrE_CANNOTSETSPEAKER);          {!!.04}
    end;                                                                 {!!.04}

    try                                                                  {!!.04}
      FiDirectSR.Microphone := scApdDefaultMic;                          {!!.04}
    except                                                               {!!.04}
      on EOleError do                                                    {!!.04}
        TriggerSRError (Self, 0, '', ApdStrE_CANNOTSETMIC);              {!!.04}
    end;                                                                 {!!.04}

    { Connect events }                                                   {!!.04}

    FiDirectSR.OnPhraseFinish := TriggerPhraseFinish;                    {!!.04}
    FiDirectSR.OnVUMeter := TriggerVUMeter;                              {!!.04}
    FiDirectSR.OnUtteranceBegin := TriggerSpeakStart;                    {!!.04}
    FiDirectSR.OnUtteranceEnd := TriggerSpeakStop;                       {!!.04}
    FiDirectSR.OnInterference := TriggerInterference;                    {!!.04}
    FiDirectSR.OnPhraseHypothesis := TriggerPhraseHypothesis;            {!!.04}
    FiDirectSR.OnTraining := TriggerTrainingRequested;                   {!!.04}
    FiDirectSR.OnWarning := TriggerSRWarning;                            {!!.04}
    FiDirectSR.OnError := TriggerSRError;                                {!!.04}
  end;                                                                   {!!.04}
end;                                                                     {!!.04}

procedure TApdCustomSapiEngine.InitializeSS;                             {!!.04}
begin                                                                    {!!.04}
  if (not ((csDesigning in ComponentState) or                            {!!.04}
           (csLoading in ComponentState))) and                           {!!.04}
      (FiDirectSS = nil) then begin                                      {!!.04}

    { Create the SAPI Interaces }                                        {!!.04}

    try                                                                  {!!.04}
      FiDirectSS := TDirectSS.Create (Self);                             {!!.04}
      FiDirectSS.Visible := False;                                       {!!.04}
      FSSVoices.FiDirectSS := FiDirectSS;                                {!!.04}
      FiDirectSS.Initialized := 1;                                       {!!.04}
    except                                                               {!!.04}
      on EOleError do                                                    {!!.04}
        TriggerSSError (Self, 0, '', ApdStrE_CANNOTCREATESS);            {!!.04}
    end;                                                                 {!!.04}

    { Connect events }                                                   {!!.04}

    FiDirectSS.OnAudioStart := TriggerAudioStart;                        {!!.04}
    FiDirectSS.OnAudioStop := TriggerAudioStop;                          {!!.04}
    FiDirectSS.OnError := TriggerSSError;                                {!!.04}
    FiDirectSS.Onwarning := TriggerSSWarning;                            {!!.04}
    FiDirectSS.OnAttribChanged := TriggerSSAttribChanged;                {!!.04}
  end;                                                                   {!!.04}
end;                                                                     {!!.04}

function TApdCustomSapiEngine.IsSapi4Installed : Boolean;
var
  SysDir : PChar;
begin
  Result := True;
  SysDir := StrAlloc (Max_Path);
  try
    if GetWindowsDirectory (SysDir, Max_Path) <> 0 then begin
      if not FileExists (SysDir + '\Speech\Speech.DLL') then           {!!.01}
        Result := False;
    end;
  finally
    StrDispose (SysDir);
  end;        
end;

procedure TApdCustomSapiEngine.Listen;
var
  GrammarString : string;
  i : Integer;
begin
  if SREngines.Count = 0 then
    raise EApdSapiEngineException.CreateFmt (ecNoSREngines, [0]);
  if Dictation then begin
    GrammarString := '[Grammar]'^M^J'type=dictation'^M^J;
    if WordList.Count > 0 then begin
      GrammarString := GrammarString + '[WordGroups]'^M^J +
                       '=ApdWords'^M^J + '[ApdWords]'^M^J;
      for i := 0 to WordList.Count - 1 do
        GrammarString := GrammarString + '=' + WordList[i] + ^M^J;
    end;

  end else begin
    GrammarString := '[Grammar]'^M^J'type=cfg'^M^J;
    if WordList.Count > 0 then begin
      GrammarString := GrammarString + '[<Start>]'^M^J;
      for i := 0 to WordList.Count - 1 do
        GrammarString := GrammarString + '<Start>=' + WordList[i] + ^M^J;
    end;
  end;


  FiDirectSR.GrammarFromString (GrammarString);

  case Duplex of
    sdFull :
      Listening := True;
    sdHalf :
      if Speaking then begin
        Speaking := False;
        Listening := True;
      end;
    sdHalfDelayed :
      if Speaking then
        FWaitMode := wmWaitSpeaking;
  end;
end;

procedure TApdCustomSapiEngine.Loaded;
begin
  inherited Loaded;

  if IsSapi4Installed then                                             {!!.04}
    InitializeSapi                                                     {!!.01}
  else begin                                                           {!!.04}
    if Assigned (FOnSRError) then                                      {!!.04}
      FOnSRError (Self, 0, '', ApdStrE_NOSAPI4);                       {!!.04}
    if Assigned (FOnSSError) then                                      {!!.04}
      FOnSSError (Self, 0, '', ApdStrE_NOSAPI4);                       {!!.04}
  end;                                                                 {!!.04}
end;

procedure TApdCustomSapiEngine.PauseListening;
begin
  FiDirectSR.Pause;
end;

procedure TApdCustomSapiEngine.PauseSpeaking;
begin
  FiDirectSS.AudioPause;
end;

procedure TApdCustomSapiEngine.RegisterPhraseFinishHook (
                                 PhraseFinishMethod : TApdPhraseFinishMethod);

var
  Event : PApdRegisteredEvent;
  Idx : Integer;
  AlreadyRegistered : Boolean;

begin
  AlreadyRegistered := False;
  for Idx := 0 to FPhraseFinishClients.Count - 1 do begin
    Event := FPhraseFinishClients[Idx];
    if (@Event.CallBack = @PhraseFinishMethod) then
      AlreadyRegistered := True;
  end;
  if not AlreadyRegistered then begin
    New (Event);
    Event.CallBack := PhraseFinishMethod;
    Event.EventType := etPhraseFinish;
    Event.Active := True;
    FPhraseFinishClients.Add (Event); 
  end;    
end;

procedure TApdCustomSapiEngine.ResumeListening;
begin
  FiDirectSR.Resume;
end;

procedure TApdCustomSapiEngine.ResumeSpeaking;
begin
  FiDirectSS.AudioResume;
end;

procedure TApdCustomSapiEngine.SetAutoTrain (v : Boolean);
begin
  if FAutoTrain <> v then
    FAutoTrain := v;
end;

procedure TApdCustomSapiEngine.SetCharSet (v : TApdCharacterSet);
begin
  if FCharSet <> v then
    FCharSet := v;
end;

procedure TApdCustomSapiEngine.SetDictation (v : Boolean);
begin
  if v <> FDictation then
    FDictation := v;
end;

procedure TApdCustomSapiEngine.SetDuplex (v : TApdSapiDuplex);
begin
  if v <> FDuplex then
    FDuplex := v;
end;

procedure TApdCustomSapiEngine.SetInitSR (const v : Boolean);            {!!.04}
begin                                                                    {!!.04}
  if v <> FInitSR then                                                   {!!.04}
    FInitSR := v;                                                        {!!.04}
end;                                                                     {!!.04}

procedure TApdCustomSapiEngine.SetInitSS (const v : Boolean);            {!!.04}
begin                                                                    {!!.04}
  if v <> FInitSS then                                                   {!!.04}
    FInitSS := v;                                                        {!!.04}
end;                                                                     {!!.04}

procedure TApdCustomSapiEngine.SetListening (v : Boolean);
begin
  if not Assigned (FiDirectSR) then begin                                {!!.04}
    FListening := v;                                                     {!!.04}
    Exit;                                                                {!!.04}
  end;                                                                   {!!.04}
                                                 
  if (not v) and FListening then begin
    FiDirectSR.Deactivate;
    { Put in a slight delay - sometimes the events get slightly out of sync }
    DelayTicks (4, True);
  end else if (v) and not (FListening) then
    FiDirectSR.Activate;
  if v <> FListening then
    FListening := v;
end;

procedure TApdCustomSapiEngine.SetSpeaking (v : Boolean);
begin
  if not Assigned (FiDirectSS) then begin                                {!!.04}
    FSpeaking := v;                                                      {!!.04}
    Exit;                                                                {!!.04}
  end;                                                                   {!!.04}

  if (not v) and (FSpeaking) then
    FiDirectSS.AudioReset;
  if v <> FSpeaking then
    FSpeaking := v;
end;

procedure TApdCustomSapiEngine.SetSRAutoGain (Value: Integer);
begin
  if FSRAutoGain <> Value then begin
    FSRAutoGain := Value;
    if Assigned (FiDirectSR) then
      FiDirectSR.AutoGain := FSRAutoGain;
  end;
end;

procedure TApdCustomSapiEngine.SetTTSOptions (v : TApdTTSOptions);
begin
  if FTTSOptions <> v then
    FTTSOptions := v;
end;

procedure TApdCustomSapiEngine.SetWordList (v : TStringList);
begin
  FWordList.Assign (v);
end;

procedure TApdCustomSapiEngine.ShowAboutDlg (const Caption : string);
begin
  ShowSSAboutDlg (Caption);
end;

procedure TApdCustomSapiEngine.ShowGeneralDlg (const Caption : string);
begin
  ShowSSGeneralDlg (Caption);
end;

procedure TApdCustomSapiEngine.ShowLexiconDlg (const Caption : string);
begin
  ShowSSLexiconDlg (Caption);
end;

procedure TApdCustomSapiEngine.ShowSRAboutDlg (const Caption : string);
begin
  FiDirectSR.AboutDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.ShowSRGeneralDlg (const Caption : string);
begin
  FiDirectSR.GeneralDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.ShowSRLexiconDlg (const Caption : string);
begin
  FiDirectSR.LexiconDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.ShowSSAboutDlg (const Caption : string);
begin
  FiDirectSS.AboutDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.ShowSSGeneralDlg (const Caption : string);
begin
  FiDirectSS.GeneralDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.ShowTrainGeneralDlg (const Caption : string);
begin
  FiDirectSR.TrainGeneralDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.ShowSSLexiconDlg (const Caption : string);
begin
  FiDirectSR.LexiconDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.ShowTrainMicDlg (const Caption : string);
begin
  FiDirectSR.TrainMicDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.ShowTranslateDlg (const Caption : string);
begin
  FiDirectSS.TranslateDlg (Application.Handle, Caption);
end;

procedure TApdCustomSapiEngine.Speak (Text : string);
var
  CSet : Integer;
  Options : Integer;
begin
  if Text = '' then
    Exit;
  if SSVoices.Count = 0 then
    raise EApdSapiEngineException.CreateFmt (ecNoSSEngines, [0]);
  InitializeSpeaking (CSet, Options);
  FiDirectSS.FileName := #0;

  case FDuplex of
    sdHalf :
      if Listening then begin
        Listening := False;
        FWaitMode := wmRestoreListen;
      end;
    sdFull :
      begin
      end;
    sdHalfDelayed :
      if Listening then begin
        Listening := False;
        FWaitMode := wmRestoreListen;
      end;
  end;
  
  FiDirectSS.TextData (CSet, Options, Text);
end;

procedure TApdCustomSapiEngine.SpeakFile (FileName : string);
var
  fpIn : TFileStream;
begin
  fpIn := TFileStream.Create (FileName, fmOpenRead);
  try
    SpeakStream (fpIn, #0);
  finally
    fpIn.Free;
  end;
end;

procedure TApdCustomSapiEngine.SpeakFileToFile (const InFile, OutFile : string);
var
  fpIn : TFileStream;
begin
  fpIn := TFileStream.Create (InFile, fmOpenRead);
  try
    SpeakStream (fpIn, OutFile);
  finally
    fpIn.Free;
  end;
end;

procedure TApdCustomSapiEngine.SpeakStream (Stream : TStream;
                                            FileName : string);

  type
    TApdCharSet = Set of Char;

  function FindCharReverse (Buffer : PChar; StartAt : Integer;
                            c : TApdCharSet) : Integer;
  begin
    while (StartAt >= 0) and (not (Buffer[StartAt] in c)) do
      Dec (StartAt, 1);
    Result := StartAt + 1;
  end;

var
  CSet : Integer;
  Options : Integer;
  WorkString : array [0..8192] of Char;
  i : Integer;
  j : Integer;
begin
  if SSVoices.Count = 0 then
    raise EApdSapiEngineException.CreateFmt (ecNoSSEngines, [0]);
  InitializeSpeaking (CSet, Options);

  case FDuplex of
    sdHalf :
      if Listening then
        Listening := False;
    sdFull :
      begin
      end;
    sdHalfDelayed :
      if Listening then begin
        Listening := False;
        FWaitMode := wmRestoreListen;
      end;
  end;
  
  WorkString := '';

  while Stream.Position < Stream.Size do begin
    i := Stream.Read (WorkString, 8192);
    WorkString[i] := #$00;
    if Stream.Position < Stream.Size then begin
      j := FindCharReverse (WorkString, i, ['.', '!', '?']);
      if j <= 0 then begin
        j := FindCharReverse (WorkString, i, [' ', ',']);
        if j > 0 then begin
          Stream.Position := Stream.Position + (j - 8192);
          WorkString[j] := #$00;
        end
      end else begin
        Stream.Position := Stream.Position + (j - 8192);
        WorkString[j] := #$00;
      end;
    end;

    FiDirectSS.TextData (CSet, Options, WorkString);
  end;
end;

procedure TApdCustomSapiEngine.SpeakToFile (const Text, FileName : string);
var
  CSet : Integer;
  Options : Integer;
begin
  if Text = '' then
    Exit;
  if SSVoices.Count = 0 then
    raise EApdSapiEngineException.CreateFmt (ecNoSSEngines, [0]);
  InitializeSpeaking (CSet, Options);
  FiDirectSS.FileName := FileName;

  case FDuplex of
    sdHalf :
      if Listening then
        Listening := False;
    sdFull :
      begin
      end;
    sdHalfDelayed :
      if Listening then begin
        Listening := False;
        FWaitMode := wmRestoreListen;
      end;
  end;

  FiDirectSS.TextData (CSet, Options, Text);
end;

procedure TApdCustomSapiEngine.StopListening;
begin
  Listening := False;
end;

procedure TApdCustomSapiEngine.StopSpeaking;
begin
  Speaking := False;
end;

procedure TApdCustomSapiEngine.TriggerAudioStart (Sender : TObject;
                                                  hi : Integer; lo : Integer);
begin
  Speaking := True;
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSpeakStart) then
    FOnSpeakStart (Sender);
end;

procedure TApdCustomSapiEngine.TriggerAudioStop (Sender : TObject;
                                                 hi : Integer; lo : Integer);
begin
  Speaking := False;
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSpeakStop) then
    FOnSpeakStop (Sender);

  case FWaitMode of
    wmWaitSpeaking :
      begin
        Listening := True;
        FWaitMode := wmNone;
      end;
    wmRestoreListen :
      begin
        Listening := True;
        FWaitMode := wmNone;
      end;
  end;
end;

procedure TApdCustomSapiEngine.TriggerInterference (Sender : TObject;
                                                    beginhi : Integer;
                                                    beginlo : Integer;
                                                    endhi : Integer;
                                                    endlo : Integer;
                                                    type_ : Integer);

  function ConvertInterferenceType (InterferenceType : Integer) :
                                                       TApdSRInterferenceType;
  begin
    case InterferenceType of
      ApdSRMSGINT_AUDIODATA_STARTED :
        Result := itAudioStarted;
      ApdSRMSGINT_AUDIODATA_STOPPED :
        Result := itAudioStopped;
      ApdSRMSGINT_IAudio_STARTED :
        Result := itDeviceOpened;
      ApdSRMSGINT_IAudio_STOPPED :
        Result := itDeviceClosed;
      ApdSRMSGINT_NOISE :
        Result := itNoise;
      ApdSRMSGINT_TOOLOUD :
        Result := itTooLoud;
      ApdSRMSGINT_TOOQUIET :
        Result := itTooQuiet;
      else
        Result := itUnknown;
    end;
  end;

begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnInterference) then
    FOnInterference (Sender, ConvertInterferenceType (type_));
end;

procedure TApdCustomSapiEngine.TriggerPhraseFinish (Sender : TObject;
                                                    flags : Integer;
                                                    beginhi : Integer;
                                                    beginlo : Integer;
                                                    endhi : Integer;
                                                    endlo : Integer;
                                                    const Phrase : WideString;
                                                    const parsed : WideString;
                                                    results : Integer);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Phrase = '' then
    Exit;
  if Assigned (FOnPhraseFinish) then
    FOnPhraseFinish (Sender, Phrase);
  TriggerPhraseFinishClients (Phrase, Results);
  case FWaitMode of
    wmWaitListening :
      begin
        Listening := False;
        FWaitMode := wmNone;
      end;
  end;
end;

procedure TApdCustomSapiEngine.TriggerPhraseFinishClients (Phrase : string;
                                                           Results : Integer);
var
  i : Integer;
  Event : PApdRegisteredEvent;

begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  for i := 0 to FPhraseFinishClients.Count - 1 do begin
    Event := PApdRegisteredEvent (FPhraseFinishClients[i]);
    Event.CallBack (Self, Phrase, Results);
  end;
end;

procedure TApdCustomSapiEngine.TriggerPhraseHypothesis (Sender : TObject;
                                                        flags : Integer;
                                                        beginhi : Integer;
                                                        beginlo : Integer;
                                                        endhi : Integer;
                                                        endlo : Integer;
                                                        const Phrase : WideString;
                                                        results : Integer);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnPhraseHypothesis) then
    FOnPhraseHypothesis (Sender, Phrase);
end;

procedure TApdCustomSapiEngine.TriggerSpeakStart (Sender : TObject;
                                                  beginhi : Integer;
                                                  beginlo : Integer);
begin
  Speaking := True;
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSpeakStart) then
    FOnSpeakStart (Sender);
end;

procedure TApdCustomSapiEngine.TriggerSpeakStop (Sender : TObject;
                                                 beginhi : Integer;
                                                 beginlo : Integer;
                                                 endhi : Integer;
                                                 endlo : Integer);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSpeakStop) then
    FOnSpeakStop (Sender);

  Speaking := False;
  case FWaitMode of
    wmWaitSpeaking :
      begin
        Listening := True;
        FWaitMode := wmNone;
      end;
    wmRestoreListen :
      begin
        Listening := True;
        FWaitMode := wmNone;
      end;
  end;
end;

procedure TApdCustomSapiEngine.TriggerSRError (Sender : TObject;
                                               Error : LongWord;
                                               const Details : WideString;
                                               const Message : WideString);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSRError) then
    FOnSRError (Sender, Error, Details, Message);
end;

procedure TApdCustomSapiEngine.TriggerSRWarning (Sender : TObject;
                                                 Error : LongWord;
                                                 const Details : WideString;
                                                 const Message : WideString);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSRWarning) then
    FOnSRWarning (Sender, Error, Details, Message);
end;

procedure TApdCustomSapiEngine.TriggerSSAttribChanged (Sender : TObject;
                                                       Attribute: Integer);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSSAttributeChanged) then
    FOnSSAttributeChanged (Sender, Attribute);
end;

procedure TApdCustomSapiEngine.TriggerSSError (Sender : TObject;
                                               Error : LongWord;
                                               const Details : WideString;
                                               const Message : WideString);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSSError) then
    FOnSSError (Sender, Error, Details, Message);
end;

procedure TApdCustomSapiEngine.TriggerSSWarning (Sender : TObject;
                                                 Error : LongWord;
                                                 const Details : WideString;
                                                 const Message : WideString);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnSSWarning) then
    FOnSSWarning (Sender, Error, Details, Message);
end;

procedure TApdCustomSapiEngine.TriggerTrainingRequested (Sender : TObject;
                                                         train : Integer);

  function ConvertTrainingType (TrainingType : Integer) : TApdSRTrainingType;
  begin
    Result := [];
    if (TrainingType and ApdSRGNSTRAIN_GENERAL) <> 0 then
      Result := Result + [ttGeneral];
    if (TrainingType and ApdSRGNSTRAIN_GRAMMAR) <> 0 then
      Result := Result + [ttCurrentGrammar];
    if (TrainingType and ApdSRGNSTRAIN_MICROPHONE) <> 0 then
      Result := Result + [ttCurrentMic];
  end;

begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if FAutoTrain then
    PostMessage (FHandle, apw_SapiTrain, train, 0);
  if Assigned (FOnTrainingRequested) then
    FOnTrainingRequested (Sender, ConvertTrainingType (train));
end;

procedure TApdCustomSapiEngine.TriggerVUMeter (Sender : TObject;
                                               beginhi : Integer;
                                               beginlo : Integer;
                                               level : Integer);
begin
  FSRAmplitude := Level;
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnVUMeter) then
    FOnVUMeter (Sender, level);
end;

procedure TApdCustomSapiEngine.WaitUntilDoneSpeaking;
begin
  while Speaking do
    SafeYield;
end;

procedure TApdCustomSapiEngine.WndProc (var Message: TMessage);
begin
  case Message.Msg of
    apw_SapiTrain :
      begin
        if (Message.wParam and ApdSRGNSTRAIN_GENERAL) <> 0 then
          ShowTrainGeneralDlg (scApdTrainGeneral)
        else if (Message.wParam and ApdSRGNSTRAIN_GRAMMAR) <> 0 then
          ShowTrainGeneralDlg (scApdTrainGeneral)
        else if (Message.wParam and ApdSRGNSTRAIN_MICROPHONE) <> 0 then
          ShowTrainMicDlg (scApdTrainMic);
      end;
  end;
  try
    Dispatch (Message);
    if Message.Msg = WM_QUERYENDSESSION then
      Message.Result := 1;
  except
    Application.HandleException (Self);
  end;
end;

end.


