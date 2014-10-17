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
{*                   ADISAPI.PAS 4.06                    *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{$UNDEF LIVE_SERVER_AT_DESIGN_TIME}
{$A+}

{$IFDEF AProBCB}
  {$Warnings Off}
{$ENDIF}

{ This unit contains the type library needed by the Sapi Engine and Sapi
  Phone components }

unit AdISapi;


interface                 

uses                         
  ActiveX,
  Classes,
  Graphics,
  OleCtrls,
  {$IFDEF Delphi5}
  OleServer,
  {$ENDIF}
  StdVCL,
  {$IFDEF Delphi6}
  Variants,
  {$ENDIF}
  Windows,
  OoMisc;

const

  { TypeLibrary Major and minor versions }

  ACTIVEVOICEPROJECTLibMajorVersion = 1;
  ACTIVEVOICEPROJECTLibMinorVersion = 0;

  ACTIVELISTENPROJECTLibMajorVersion = 1;
  ACTIVELISTENPROJECTLibMinorVersion = 0;

  TELLibMajorVersion = 1;
  TELLibMinorVersion = 0;

  LIBID_ACTIVEVOICEPROJECTLib : TGUID =
      '{EEE78583-FE22-11D0-8BEF-0060081841DE}';

  DIID__DirectSSEvents : TGUID = '{EEE78597-FE22-11D0-8BEF-0060081841DE}';
  IID_IDirectSS : TGUID = '{EEE78590-FE22-11D0-8BEF-0060081841DE}';
  CLASS_DirectSS : TGUID = '{EEE78591-FE22-11D0-8BEF-0060081841DE}';
  CLASS_VoiceProp : TGUID = '{EEE78592-FE22-11D0-8BEF-0060081841DE}';

  LIBID_ACTIVELISTENPROJECTLib : TGUID =
      '{4E3D9D11-0C63-11D1-8BFB-0060081841DE}';

  DIID__DirectSREvents : TGUID = '{4E3D9D20-0C63-11D1-8BFB-0060081841DE}';
  IID_IDirectSR : TGUID = '{4E3D9D1E-0C63-11D1-8BFB-0060081841DE}';
  CLASS_DirectSR : TGUID = '{4E3D9D1F-0C63-11D1-8BFB-0060081841DE}';

  LIBID_TELLib : TGUID = '{FC9E7401-6058-11D1-8C66-0060081841DE}';

  LANG_LEN     = 64;

type
  {$IFDEF VERSION4}
  QWORD = Int64;
  {$ELSE}
  QWORD = Longint;
  LongWord = Longint; 
  {$ENDIF}
  SDATA = record
    pData : pointer;
    dwSize : DWORD;
  end;
  TSData = SDATA;

  PLanguageW = ^TLanguageW;
  LANGUAGEW = record
    LanguageID : LangID;
    szDialect : array[0..LANG_LEN - 1] of WideChar;
  end;
  TLanguageW = LANGUAGEW;

  SRGRMFMT = UINT;

  PSRPhraseW = ^TSRPhraseW;
  SRPHRASEW = record
    dwSize :    DWORD;
    abWords : record end;
  end;
  TSRPhraseW = SRPHRASEW;

const
  {$IFDEF VERSION4}
  {$EXTERNALSYM CLSID_MMAudioSource}
  {$ENDIF}
  CLSID_MMAudioSource : TGUID = '{D24FE500-C743-11CD-80E5-00AA003E4B50}';
  {$IFDEF VERSION4}
  {$EXTERNALSYM CLSID_AudioSourceTel}
  {$ENDIF} 
  CLSID_AudioSourceTel : TGUID = '{2EC5A8A5-E65B-11D0-8FAC-08002BE4E62A}';
  {$IFDEF VERSION4}
  {$EXTERNALSYM CLSID_AudioDestTel}
  {$ENDIF}
  CLSID_AudioDestTel : TGUID = '{2EC5A8A6-E65B-11D0-8FAC-08002BE4E62A}';

  SID_IAudioMultiMediaDevice = '{B68AD320-C743-11cd-80E5-00AA003E4B50}';
  SID_IAudioTel              = '{2EC5A8A7-E65B-11D0-8FAC-08002BE4E62A}';

  {$IFDEF VERSION4}
  {$EXTERNALSYM IID_IAudioMultiMediaDevice}
  {$ENDIF}
  IID_IAudioMultiMediaDevice : TGUID = '{B68AD320-C743-11CD-80E5-00AA003E4B50}';

  {$IFDEF VERSION4}
  {$EXTERNALSYM IID_IAudioTel}
  {$ENDIF}
  IID_IAudioTel : TGUID = '{2EC5A8A7-E65B-11D0-8FAC-08002BE4E62A}';

type

  { Speech recognition event types }

  TDirectSRClickIn =
      procedure (Sender : TObject; x : Integer; y : Integer) of object;
  TDirectSRClickOut =
      procedure (Sender : TObject; x : Integer; y : Integer) of object;
  TDirectSRPhraseFinish =
      procedure (Sender : TObject; flags : Integer; beginhi : Integer;
                 beginlo : Integer; endhi : Integer;
                 endlo : Integer; const Phrase : WideString;
                 const parsed : WideString; results : Integer) of object;
  TDirectSRPhraseStart =
      procedure (Sender : TObject; hi : Integer; lo : Integer) of object;
  TDirectSRBookMark =
      procedure (Sender : TObject; MarkID : Integer) of object;
  TDirectSRPhraseHypothesis =
      procedure (Sender : TObject; flags : Integer; beginhi : Integer;
                 beginlo : Integer; endhi : Integer;
                 endlo : Integer; const Phrase : WideString;
                 results : Integer) of object;
  TDirectSRReEvaluate =
      procedure (Sender : TObject; results : Integer) of object;
  TDirectSRTraining =
      procedure (Sender : TObject; train : Integer) of object;
  TDirectSRUnArchive =
      procedure (Sender : TObject; results : Integer) of object;
  TDirectSRAttribChanged =
      procedure (Sender : TObject; Attribute : Integer) of object;
  TDirectSRInterference =
      procedure (Sender : TObject; beginhi : Integer; beginlo : Integer;
                 endhi : Integer; endlo : Integer; type_ : Integer) of object;
  TDirectSRSound =
      procedure (Sender : TObject; beginhi : Integer; beginlo : Integer;
                 endhi : Integer; endlo : Integer) of object;
  TDirectSRUtteranceBegin =
      procedure (Sender : TObject; beginhi : Integer;
                 beginlo : Integer) of object;
  TDirectSRUtteranceEnd =
      procedure (Sender : TObject; beginhi : Integer; beginlo : Integer;
                 endhi : Integer; endlo : Integer) of object;
  TDirectSRVUMeter =
      procedure (Sender : TObject; beginhi : Integer; beginlo:Integer;
                level : Integer) of object;
  TDirectSRError =
      procedure (Sender : TObject; warning : LongWord;
                 const Details : WideString;
                 const Message : WideString) of object;
  TDirectSRwarning =
      procedure (Sender : TObject; warning : LongWord;
                 const Details : WideString;
                 const Message : WideString) of object;

  { Speech synthesis event types }

  TDirectSSClickIn =
      procedure (Sender : TObject; x : Integer; y : Integer) of object;
  TDirectSSClickOut =
      procedure (Sender : TObject; x : Integer; y : Integer) of object;
  TDirectSSAudioStart =
      procedure (Sender : TObject; hi : Integer; lo : Integer) of object;
  TDirectSSAudioStop =
      procedure (Sender : TObject; hi : Integer; lo : Integer) of object;
  TDirectSSAttribChanged =
      procedure (Sender : TObject; which_attribute : Integer) of object;
  TDirectSSVisual =
      procedure (Sender : TObject; timehi : Integer; timelo : Integer;
                 Phoneme : Smallint; EnginePhoneme : Smallint; hints : Integer;
                 MouthHeight : Smallint; bMouthWidth : Smallint;
                 bMouthUpturn : Smallint; bJawOpen : Smallint;
                 TeethUpperVisible : Smallint;
                 TeethLowerVisible : Smallint; TonguePosn : Smallint;
                 LipTension : Smallint) of object;
  TDirectSSWordPosition =
      procedure (Sender : TObject; hi : Integer; lo : Integer;
                 byteoffset : Integer) of object;
  TDirectSSBookMark =
      procedure (Sender : TObject; hi : Integer; lo : Integer;
                 MarkNum : Integer) of object;
  TDirectSSTextDataStarted =
      procedure (Sender : TObject; hi : Integer; lo : Integer) of object;
  TDirectSSTextDataDone =
      procedure (Sender : TObject; hi : Integer; lo : Integer;
                 Flags : Integer) of object;
  TDirectSSActiveVoiceStartup =
      procedure (Sender : TObject; init : Integer; init2 : Integer) of object;
  TDirectSSError =
      procedure (Sender : TObject; warning : LongWord;
                 const Details : WideString;
                 const Message : WideString) of object;
  TDirectSSwarning =
      procedure (Sender : TObject; warning : LongWord;
                 const Details : WideString;
                 const Message : WideString) of object;
  TDirectSSVisualFuture =
      procedure (Sender : TObject; milliseconds : Integer; timehi : Integer;
                 timelo : Integer; Phoneme : Smallint;
                 EnginePhoneme : Smallint; hints : Integer;
                 MouthHeight : Smallint; bMouthWidth : Smallint;
                 bMouthUpturn : Smallint; bJawOpen : Smallint;
                 TeethUpperVisible : Smallint;
                 TeethLowerVisible : Smallint;
                 TonguePosn : Smallint; LipTension : Smallint) of object;

type
  {$IFDEF VERSION4}
  {.$ EXTERNALSYM IAudioMultiMediaDevice}
  {$ENDIF}
  IAudioMultiMediaDevice = interface (IUnknown)
    [SID_IAudioMultiMediaDevice]
    function CustomMessage (uMsg : UINT; dData : SDATA) : HResult; stdcall;
    function DeviceNumGet (var dwDeviceID : DWORD) : HResult; stdcall;
    function DeviceNumSet (dwDeviceID : DWORD) : HResult; stdcall;
  end; // IAudioMultiMediaDevice
  {$IFDEF VERSION4}
  {.$ EXTERNALSYM PIAUDIOMULTIMEDIADEVICE}
  {$ENDIF}
  PIAUDIOMULTIMEDIADEVICE = ^IAudioMultiMediaDevice;

  {$IFDEF VERSION4}
  {.$ EXTERNALSYM IAudioTel}
  {$ENDIF}
  IAudioTel = interface (IUnknown)
    ['{2EC5A8A7-E65B-11d0-8FAC-08002BE4E62A}']
    function AudioObject (AudioObject : IUnknown) : HResult; stdcall;
    function WaveFormatSet (dWFEX : SDATA) : HResult; stdcall;
  end;
  {$IFDEF VERSION4}
  {.$ EXTERNALSYM PIAUDIOTEL}
  {$ENDIF}
  PIAUDIOTEL = ^IAudioTel;
  
  { Forward declarations of types }

  _DirectSREvents = dispinterface;
  IDirectSR = interface;
  IDirectSRDisp = dispinterface;

  _DirectSSEvents = dispinterface;
  IDirectSS = interface;
  IDirectSSDisp = dispinterface;

  { Declaration of CoClasses - map each CoClass to it's default interface }

  DirectSR = IDirectSR;
  DirectSS = IDirectSS;
  VoiceProp = IUnknown;

  { Needed structures }
  
  PInteger1 = ^Integer;
  PWideString1 = ^WideString; 

  { _DirectSREvents }

  _DirectSREvents = dispinterface
    ['{4E3D9D20-0C63-11D1-8BFB-0060081841DE}']
    procedure ClickIn (x : Integer; y : Integer); dispid 1;
    procedure ClickOut (x : Integer; y : Integer); dispid 2;
    procedure PhraseFinish (flags : Integer; beginhi : Integer;
                            beginlo : Integer;
                            endhi : Integer; endlo : Integer;
                            const Phrase : WideString;
                            const parsed : WideString;
                            results : Integer); dispid 3;
    procedure PhraseStart (hi : Integer; lo : Integer); dispid 4;
    procedure BookMark (MarkID : Integer); dispid 5;
    procedure Paused; dispid 6;
    procedure PhraseHypothesis (flags : Integer; beginhi : Integer;
                                beginlo : Integer; endhi : Integer;
                                endlo : Integer; const Phrase : WideString;
                                results : Integer); dispid 7;
    procedure ReEvaluate (results : Integer); dispid 8;
    procedure Training (train : Integer); dispid 9;
    procedure UnArchive (results : Integer); dispid 10;
    procedure AttribChanged (Attribute : Integer); dispid 11;
    procedure Interference (beginhi : Integer; beginlo : Integer;
                            endhi : Integer;
                            endlo : Integer; type_ : Integer); dispid 12;
    procedure Sound (beginhi : Integer; beginlo : Integer; endhi : Integer;
                     endlo : Integer); dispid 13;
    procedure UtteranceBegin (beginhi : Integer; beginlo : Integer); dispid 14;
    procedure UtteranceEnd (beginhi : Integer; beginlo : Integer;
                            endhi : Integer; endlo : Integer); dispid 15;
    procedure VUMeter (beginhi : Integer; beginlo : Integer;
                       level : Integer); dispid 16;
    procedure Error (warning : LongWord; const Details : WideString;
                     const Message : WideString); dispid 17;
    procedure warning (warning : LongWord; const Details : WideString;
                       const Message : WideString); dispid 18;
  end;

  { IDirectSR }

  IDirectSR = interface (IDispatch)
    ['{4E3D9D1E-0C63-11D1-8BFB-0060081841DE}']
    function Get_debug : Smallint; safecall;
    procedure Set_debug (pVal : Smallint); safecall;
    function Get_Initialized : Smallint; safecall;
    procedure Set_Initialized (pVal : Smallint); safecall;
    procedure Deactivate; safecall;
    procedure Activate; safecall;
    function Get_LastHeard : WideString; safecall;
    procedure Set_LastHeard (const pVal : WideString); safecall;
    procedure GrammarFromString (const grammar : WideString); safecall;
    procedure GrammarFromFile (const FileName : WideString); safecall;
    procedure GrammarFromResource (Instance : Integer;
                                   ResID : Integer); safecall;
    procedure GrammarFromStream (Stream : Integer); safecall;
    function Get_AutoGain : Integer; safecall;
    procedure Set_AutoGain (pVal : Integer); safecall;
    function Get_MinAutoGain : Integer; safecall;
    function Get_MaxAutoGain : Integer; safecall;
    function Get_Echo : Smallint; safecall;
    procedure Set_Echo (pVal : Smallint); safecall;
    function Get_EnergyFloor : Integer; safecall;
    procedure Set_EnergyFloor (pVal : Integer); safecall;
    function Get_MaxEnergyFloor : Integer; safecall;
    function Get_MinEnergyFloor : Integer; safecall;
    function Get_Microphone : WideString; safecall;
    procedure Set_Microphone (const pVal : WideString); safecall;
    function Get_Speaker : WideString; safecall;
    procedure Set_Speaker (const pVal : WideString); safecall;
    function Get_RealTime : Integer; safecall;
    procedure Set_RealTime (pVal : Integer); safecall;
    function Get_MaxRealTime : Integer; safecall;
    function Get_MinRealTime : Integer; safecall;
    function Get_Threshold : Integer; safecall;
    procedure Set_Threshold (pVal : Integer); safecall;
    function Get_MaxThreshold : Integer; safecall;
    function Get_MinThreshold : Integer; safecall;
    function Get_CompleteTimeOut : Integer; safecall;
    procedure Set_CompleteTimeOut (pVal : Integer); safecall;
    function Get_IncompleteTimeOut : Integer; safecall;
    procedure Set_IncompleteTimeOut (pVal : Integer); safecall;
    function Get_MaxCompleteTimeOut : Integer; safecall;
    function Get_MinCompleteTimeOut : Integer; safecall;
    function Get_MaxIncompleteTimeOut : Integer; safecall;
    function Get_MinIncompleteTimeOut : Integer; safecall;
    procedure Pause; safecall;
    procedure Resume; safecall;
    procedure PosnGet (out hi : Integer; out lo : Integer); safecall;
    procedure AboutDlg (hwnd : Integer; const title : WideString); safecall;
    procedure GeneralDlg (hwnd : Integer; const title : WideString); safecall;
    procedure LexiconDlg (hwnd : Integer; const title : WideString); safecall;
    procedure TrainGeneralDlg (hwnd : Integer;
                               const title : WideString); safecall;
    procedure TrainMicDlg (hwnd : Integer; const title : WideString); safecall;
    function Get_Wave (results : Integer) : Integer; safecall;
    function Get_Phrase (results : Integer;
                          rank : Integer) : WideString; safecall;
    function Get_CreateResultsObject (results : Integer) : Integer; safecall;
    procedure DestroyResultsObject (resobj : Integer); safecall;
    procedure Select (index : Integer); safecall;
    procedure Listen; safecall;
    procedure SelectEngine (index : SYSINT); safecall;
    function FindEngine (const EngineId : WideString;
                          const MfgName : WideString;
                          const ProductName : WideString;
                          const ModeID : WideString;
                          const ModeName : WideString; LanguageID : Integer;
                          const dialect : WideString; Sequencing : Integer;
                          MaxWordsVocab : Integer; MaxWordsState : Integer;
                          Grammars : Integer; Features : Integer;
                          Interfaces : Integer; EngineFeatures : Integer;
                          RankEngineID : Integer; RankMfgName : Integer;
                          RankProductName : Integer; RankModeID : Integer;
                          RankModeName : Integer; RankLanguage : Integer;
                          RankDialect : Integer; RankSequencing : Integer;
                          RankMaxWordsVocab : Integer;
                          RankMaxWordsState : Integer; RankGrammars : Integer;
                          RankFeatures : Integer; RankInterfaces : Integer;
                          RankEngineFeatures : Integer) : Integer; safecall;
    function Get_CountEngines : Integer; safecall;
    function ModeName (index : SYSINT) : WideString; safecall;
    function EngineId (index : SYSINT) : WideString; safecall;
    function MfgName (index : SYSINT) : WideString; safecall;
    function ProductName (index : SYSINT) : WideString; safecall;
    function ModeID (index : SYSINT) : WideString; safecall;
    function Features (index : SYSINT) : Integer; safecall;
    function Interfaces (index : SYSINT) : Integer; safecall;
    function EngineFeatures (index : SYSINT) : Integer; safecall;
    function LanguageID (index : SYSINT) : Integer; safecall;
    function dialect (index : SYSINT) : WideString; safecall;
    function Sequencing (index : SYSINT) : Integer; safecall;
    function MaxWordsVocab (index : SYSINT) : Integer; safecall;
    function MaxWordsState (index : SYSINT) : Integer; safecall;
    function Grammars (index : SYSINT) : Integer; safecall;
    procedure InitAudioSourceDirect (direct : Integer); safecall;
    procedure InitAudioSourceObject (object_ : Integer); safecall;
    function Get_FileName : WideString; safecall;
    procedure Set_FileName (const pVal : WideString); safecall;
    function Get_FlagsGet (results : Integer;
                            rank : Integer) : Integer; safecall;
    function Get_Identify (results : Integer) : WideString; safecall;
    procedure TimeGet (results : Integer; var beginhi : Integer;
                       var beginlo : Integer; var endhi : Integer;
                       var endlo : Integer); safecall;
    procedure Correction (results : Integer; const Phrase : WideString;
                          confidence : Smallint); safecall;
    procedure Validate (results : Integer; confidence : Smallint); safecall;
    function Get_ReEvaluate (results : Integer) : Integer; safecall;
    function Get_GetPhraseScore (results : Integer;
                                 rank : Integer) : Integer; safecall;
    procedure Archive (keepresults : Integer; out size : Integer;
                       out pVal : Integer); safecall;
    procedure DeleteArchive (Archive : Integer); safecall;
    procedure GrammarFromMemory (grammar : Integer; size : Integer); safecall;
    procedure GrammarDataSet (Data : Integer; size : Integer); safecall;
    procedure GrammarToMemory (var grammar : Integer;
                               var size : Integer); safecall;
    procedure ActivateAndAssignWindow (hwnd : Integer); safecall;
    function Get_LastError : Integer; safecall;
    procedure Set_LastError (pVal : Integer); safecall;
    function Get_SuppressExceptions : Integer; safecall;
    procedure Set_SuppressExceptions (pVal : Integer); safecall;
    function Get_hwnd : Integer; safecall;
    function Find (const RankList : WideString) : Integer; safecall;
    function Get_SRMode : Integer; safecall;
    procedure Set_SRMode (pVal : Integer); safecall;
    function Get_GetAllArcStrings (punk : Integer;
                                    results : Integer) : WideString; safecall;
    function Get_Attributes (Attrib : Integer) : Integer; safecall;
    procedure Set_Attributes (Attrib : Integer; pVal : Integer); safecall;
    function Get_AttributeString (Attrib : Integer) : WideString; safecall;
    procedure Set_AttributeString (Attrib : Integer;
                                   const pVal : WideString); safecall;
    function Get_AttributeMemory (Attrib : Integer;
                                   var size : Integer) : Integer; safecall;
    procedure Set_AttributeMemory (Attrib : Integer;
                                   var size : Integer;
                                   pVal : Integer); safecall;
    function Get_WaveEx (results : Integer; beginhi : Integer;
                          beginlo : Integer; endhi : Integer;
                          endlo : Integer) : Integer; safecall;
    function Get_NodeStart (results : Integer) : Integer; safecall;
    function Get_NodeEnd (results : Integer) : Integer; safecall;
    procedure ArcEnum (results : Integer; node : Integer; Outgoing : Integer;
                       var nodelist : Integer;
                       var countnodes : Integer); safecall;
    procedure BestPathEnum (results : Integer; rank : Integer;
                            var startpath : Integer; startpathsteps : Integer;
                            var endpath : Integer; endpathsteps : Integer;
                            exactmatch : Integer; var arclist : Integer;
                            var arccount : Integer); safecall;
    function Get_DataGetString (results : Integer; id : Integer;
                                const Attrib : WideString) :
                                                        WideString; safecall;
    procedure DataGetTime (results : Integer; id : Integer;
                           const Attrib : WideString; var hi : Integer;
                           var lo : Integer); safecall;
    function Get_score (results : Integer; scoretype : Integer;
                        var path : Integer;pathsteps : Integer;
                        pathindexstart : Integer;
                        pathindexcount : Integer) : Integer; safecall;
    procedure GetAllArcs (results : Integer; var arcids : Integer;
                          var arccount : Integer); safecall;
    procedure GetAllNodes (results : Integer; var Nodes : Integer;
                           var countnodes : Integer); safecall;
    function Get_NodeGet (results : Integer; arc : Integer;
                          destination : Integer) : Integer; safecall;
    function Get_GraphDWORDGet (results : Integer; id : Integer;
                                 const Attrib : WideString) : Integer; safecall;
    procedure RenameSpeaker (const OldName : WideString;
                             const newName : WideString); safecall;
    procedure DeleteSpeaker (const Speaker : WideString); safecall;
    procedure CommitSpeaker; safecall;
    procedure RevertSpeaker (const Speaker : WideString); safecall;
    function Get_SpeakerInfoChanged (var filetimehi : Integer;
                                     var filetimelo : Integer) :
                                                            Integer; safecall;
    procedure TrainPhrasesDlg (hwnd : Integer;
                               const title : WideString); safecall;
    procedure LexAddTo (lex : LongWord; charset : Integer;
                        const text : WideString;
                        const pronounce : WideString; partofspeech : Integer;
                        EngineInfo : Integer;
                        engineinfosize : Integer); safecall;
    procedure LexGetFrom (lex : Integer; charset : Integer;
                          const text : WideString; sense : Integer;
                          var pronounce : WideString;
                          var partofspeech : Integer;
                          var EngineInfo : Integer;
                          var sizeofengineinfo : Integer); safecall;
    procedure LexRemoveFrom (lex : Integer; const text : WideString;
                             sense : Integer); safecall;
    procedure QueryLexicons (f : Integer; var pdw : Integer); safecall;
    procedure ChangeSpelling (lex : Integer; const stringa : WideString;
                              const stringb : WideString); safecall;
    property debug : Smallint read Get_debug write Set_debug;
    property Initialized : Smallint read Get_Initialized write Set_Initialized;
    property LastHeard : WideString read Get_LastHeard write Set_LastHeard;
    property AutoGain : Integer read Get_AutoGain write Set_AutoGain;
    property MinAutoGain : Integer read Get_MinAutoGain;
    property MaxAutoGain : Integer read Get_MaxAutoGain;
    property Echo : Smallint read Get_Echo write Set_Echo;
    property EnergyFloor : Integer read Get_EnergyFloor write Set_EnergyFloor;
    property MaxEnergyFloor : Integer read Get_MaxEnergyFloor;
    property MinEnergyFloor : Integer read Get_MinEnergyFloor;
    property Microphone : WideString read Get_Microphone write Set_Microphone;
    property Speaker : WideString read Get_Speaker write Set_Speaker;
    property RealTime : Integer read Get_RealTime write Set_RealTime;
    property MaxRealTime : Integer read Get_MaxRealTime;
    property MinRealTime : Integer read Get_MinRealTime;
    property Threshold : Integer read Get_Threshold write Set_Threshold;
    property MaxThreshold : Integer read Get_MaxThreshold;
    property MinThreshold : Integer read Get_MinThreshold;
    property CompleteTimeOut : Integer
             read Get_CompleteTimeOut write Set_CompleteTimeOut;
    property IncompleteTimeOut : Integer
             read Get_IncompleteTimeOut write Set_IncompleteTimeOut;
    property MaxCompleteTimeOut : Integer read Get_MaxCompleteTimeOut;
    property MinCompleteTimeOut : Integer read Get_MinCompleteTimeOut;
    property MaxIncompleteTimeOut : Integer read Get_MaxIncompleteTimeOut;
    property MinIncompleteTimeOut : Integer read Get_MinIncompleteTimeOut;
    property Wave[results : Integer] : Integer read Get_Wave;
    property Phrase[results : Integer; rank : Integer] : WideString
             read Get_Phrase;
    property CreateResultsObject[results : Integer] : Integer
             read Get_CreateResultsObject;
    property CountEngines : Integer read Get_CountEngines;
    property FileName : WideString read Get_FileName write Set_FileName;
    property FlagsGet[results : Integer; rank : Integer] : Integer
             read Get_FlagsGet;
    property Identify[results : Integer] : WideString read Get_Identify;
    property ReEvaluate[results : Integer] : Integer read Get_ReEvaluate;
    property GetPhraseScore[results : Integer; rank : Integer] : Integer
             read Get_GetPhraseScore;
    property LastError : Integer read Get_LastError write Set_LastError;
    property SuppressExceptions : Integer
             read Get_SuppressExceptions write Set_SuppressExceptions;
    property hwnd : Integer read Get_hwnd;
    property SRMode : Integer read Get_SRMode write Set_SRMode;
    property GetAllArcStrings[punk : Integer; results : Integer] : WideString
             read Get_GetAllArcStrings;
    property Attributes[Attrib : Integer] : Integer
             read Get_Attributes write Set_Attributes;
    property AttributeString[Attrib : Integer] : WideString
             read Get_AttributeString write Set_AttributeString;
    property AttributeMemory[Attrib : Integer; var size : Integer] : Integer
             read Get_AttributeMemory write Set_AttributeMemory;
    property WaveEx[results : Integer; beginhi : Integer; beginlo : Integer;
                    endhi : Integer; endlo : Integer] : Integer read Get_WaveEx;
    property NodeStart[results : Integer] : Integer read Get_NodeStart;
    property NodeEnd[results : Integer] : Integer read Get_NodeEnd;
    property DataGetString[results : Integer; id : Integer;
                           const Attrib : WideString] : WideString
             read Get_DataGetString;
    property score[results : Integer; scoretype : Integer;
                   var path : Integer; pathsteps : Integer;
                   pathindexstart : Integer; pathindexcount : Integer] : Integer
             read Get_score;
    property NodeGet[results : Integer; arc : Integer;
                     destination : Integer] : Integer read Get_NodeGet;
    property GraphDWORDGet[results : Integer; id : Integer;
                           const Attrib : WideString] : Integer
             read Get_GraphDWORDGet;
    property SpeakerInfoChanged[var filetimehi : Integer;
                                var filetimelo : Integer] : Integer
             read Get_SpeakerInfoChanged;
  end;

  { IDirectSRDisp }

  IDirectSRDisp = dispinterface
    ['{4E3D9D1E-0C63-11D1-8BFB-0060081841DE}']
    property debug : Smallint dispid 1;
    property Initialized : Smallint dispid 2;
    procedure Deactivate; dispid 4;
    procedure Activate; dispid 5;
    property LastHeard : WideString dispid 6;
    procedure GrammarFromString (const grammar : WideString); dispid 7;
    procedure GrammarFromFile (const FileName : WideString); dispid 8;
    procedure GrammarFromResource (Instance : Integer;
                                   ResID : Integer); dispid 9;
    procedure GrammarFromStream (Stream : Integer); dispid 10;
    property AutoGain : Integer dispid 11;
    property MinAutoGain : Integer readonly dispid 12;
    property MaxAutoGain : Integer readonly dispid 13;
    property Echo : Smallint dispid 14;
    property EnergyFloor : Integer dispid 15;
    property MaxEnergyFloor : Integer readonly dispid 16;
    property MinEnergyFloor : Integer readonly dispid 17;
    property Microphone : WideString dispid 18;
    property Speaker : WideString dispid 19;
    property RealTime : Integer dispid 20;
    property MaxRealTime : Integer readonly dispid 21;
    property MinRealTime : Integer readonly dispid 22;
    property Threshold : Integer dispid 23;
    property MaxThreshold : Integer readonly dispid 24;
    property MinThreshold : Integer readonly dispid 25;
    property CompleteTimeOut : Integer dispid 26;
    property IncompleteTimeOut : Integer dispid 27;
    property MaxCompleteTimeOut : Integer readonly dispid 28;
    property MinCompleteTimeOut : Integer readonly dispid 29;
    property MaxIncompleteTimeOut : Integer readonly dispid 30;
    property MinIncompleteTimeOut : Integer readonly dispid 31;
    procedure Pause; dispid 32;
    procedure Resume; dispid 33;
    procedure PosnGet (out hi : Integer; out lo : Integer); dispid 34;
    procedure AboutDlg (hwnd : Integer; const title : WideString); dispid 35;
    procedure GeneralDlg (hwnd : Integer; const title : WideString); dispid 36;
    procedure LexiconDlg (hwnd : Integer; const title : WideString); dispid 37;
    procedure TrainGeneralDlg (hwnd : Integer;
                               const title : WideString); dispid 38;
    procedure TrainMicDlg (hwnd : Integer; const title : WideString); dispid 39;
    property Wave[results : Integer] : Integer readonly dispid 40;
    property Phrase[results : Integer;
                    rank : Integer] : WideString readonly dispid 41;
    property CreateResultsObject[results : Integer] : Integer
             readonly dispid 42;
    procedure DestroyResultsObject (resobj : Integer); dispid 43;
    procedure Select (index : Integer); dispid 44;
    procedure Listen; dispid 45;
    procedure SelectEngine (index : SYSINT); dispid 46;
    function FindEngine (const EngineId : WideString;
                         const MfgName : WideString;
                         const ProductName : WideString;
                         const ModeID : WideString;
                         const ModeName : WideString; LanguageID : Integer;
                         const dialect : WideString; Sequencing : Integer;
                         MaxWordsVocab : Integer; MaxWordsState : Integer;
                         Grammars : Integer; Features : Integer;
                         Interfaces : Integer; EngineFeatures : Integer;
                         RankEngineID : Integer; RankMfgName : Integer;
                         RankProductName : Integer; RankModeID : Integer;
                         RankModeName : Integer; RankLanguage : Integer;
                         RankDialect : Integer; RankSequencing : Integer;
                         RankMaxWordsVocab : Integer;
                         RankMaxWordsState : Integer; RankGrammars : Integer;
                         RankFeatures : Integer; RankInterfaces : Integer;
                         RankEngineFeatures : Integer) : Integer; dispid 47;
    property CountEngines : Integer readonly dispid 48;
    function ModeName (index : SYSINT) : WideString; dispid 49;
    function EngineId (index : SYSINT) : WideString; dispid 50;
    function MfgName (index : SYSINT) : WideString; dispid 51;
    function ProductName (index : SYSINT) : WideString; dispid 52;
    function ModeID (index : SYSINT) : WideString; dispid 53;
    function Features (index : SYSINT) : Integer; dispid 54;
    function Interfaces (index : SYSINT) : Integer; dispid 55;
    function EngineFeatures (index : SYSINT) : Integer; dispid 56;
    function LanguageID (index : SYSINT) : Integer; dispid 57;
    function dialect (index : SYSINT) : WideString; dispid 58;
    function Sequencing (index : SYSINT) : Integer; dispid 59;
    function MaxWordsVocab (index : SYSINT) : Integer; dispid 60;
    function MaxWordsState (index : SYSINT) : Integer; dispid 61;
    function Grammars (index : SYSINT) : Integer; dispid 62;
    procedure InitAudioSourceDirect (direct : Integer); dispid 63;
    procedure InitAudioSourceObject (object_ : Integer); dispid 64;
    property FileName : WideString dispid 65;
    property FlagsGet[results : Integer;
                      rank : Integer] : Integer readonly dispid 66;
    property Identify[results : Integer] : WideString readonly dispid 67;
    procedure TimeGet (results : Integer; var beginhi : Integer;
                      var beginlo : Integer; var endhi : Integer;
                      var endlo : Integer); dispid 68;
    procedure Correction (results : Integer; const Phrase : WideString;
                         confidence : Smallint); dispid 69;
    procedure Validate (results : Integer; confidence : Smallint); dispid 70;
    property ReEvaluate[results : Integer] : Integer readonly dispid 71;
    property GetPhraseScore[results : Integer;
                            rank : Integer] : Integer readonly dispid 72;
    procedure Archive (keepresults : Integer; out size : Integer;
                      out pVal : Integer); dispid 73;
    procedure DeleteArchive (Archive : Integer); dispid 74;
    procedure GrammarFromMemory (grammar : Integer; size : Integer); dispid 75;
    procedure GrammarDataSet (Data : Integer; size : Integer); dispid 76;
    procedure GrammarToMemory (var grammar : Integer;
                              var size : Integer); dispid 77;
    procedure ActivateAndAssignWindow (hwnd : Integer); dispid 78;
    property LastError : Integer dispid 79;
    property SuppressExceptions : Integer dispid 80;
    property hwnd : Integer readonly dispid 81;
    function Find (const RankList : WideString) : Integer; dispid 82;
    property SRMode : Integer dispid 83;
    property GetAllArcStrings[punk : Integer;
                              results : Integer] : WideString
             readonly dispid 84;
    property Attributes[Attrib : Integer] : Integer dispid 85;
    property AttributeString[Attrib : Integer] : WideString dispid 86;
    property AttributeMemory[Attrib : Integer;
                             var size : Integer] : Integer dispid 87;
    property WaveEx[results : Integer; beginhi : Integer; beginlo : Integer;
                    endhi : Integer; endlo : Integer] : Integer
             readonly dispid 88;
    property NodeStart[results : Integer] : Integer readonly dispid 89;
    property NodeEnd[results : Integer] : Integer readonly dispid 90;
    procedure ArcEnum (results : Integer; node : Integer; Outgoing : Integer;
                      var nodelist : Integer;
                      var countnodes : Integer); dispid 91;
    procedure BestPathEnum (results : Integer; rank : Integer;
                           var startpath : Integer; startpathsteps : Integer;
                           var endpath : Integer; endpathsteps : Integer;
                           exactmatch : Integer; var arclist : Integer;
                           var arccount : Integer); dispid 92;
    property DataGetString[results : Integer; id : Integer;
                           const Attrib : WideString] : WideString
                           readonly dispid 93;
    procedure DataGetTime (results : Integer; id : Integer;
                          const Attrib : WideString; var hi : Integer; 
                          var lo : Integer); dispid 94;
    property score[results : Integer; scoretype : Integer;
                   var path : Integer; pathsteps : Integer;
                   pathindexstart : Integer; pathindexcount : Integer] : Integer
                   readonly dispid 95;
    procedure GetAllArcs (results : Integer; var arcids : Integer;
                         var arccount : Integer); dispid 96;
    procedure GetAllNodes (results : Integer; var Nodes : Integer;
                          var countnodes : Integer); dispid 97;
    property NodeGet[results : Integer; arc : Integer;
                     destination : Integer] : Integer readonly dispid 98;
    property GraphDWORDGet[results : Integer; id : Integer;
                           const Attrib : WideString] : Integer
             readonly dispid 99;
    procedure RenameSpeaker (const OldName : WideString;
                            const newName : WideString); dispid 100;
    procedure DeleteSpeaker (const Speaker : WideString); dispid 101;
    procedure CommitSpeaker; dispid 102;
    procedure RevertSpeaker (const Speaker : WideString); dispid 103;
    property SpeakerInfoChanged[var filetimehi : Integer;
                                var filetimelo : Integer] : Integer
                                readonly dispid 104;
    procedure TrainPhrasesDlg (hwnd : Integer;
                              const title : WideString); dispid 105;
    procedure LexAddTo (lex : LongWord; charset : Integer;
                        const text : WideString;
                        const pronounce : WideString; partofspeech : Integer;
                        EngineInfo : Integer;
                        engineinfosize : Integer); dispid 106;
    procedure LexGetFrom (lex : Integer; charset : Integer; const text:
                         WideString; sense : Integer;
                         var pronounce : WideString;
                         var partofspeech : Integer;
                         var EngineInfo : Integer;
                         var sizeofengineinfo : Integer); dispid 107;
    procedure LexRemoveFrom (lex : Integer; const text : WideString;
                            sense : Integer); dispid 108;
    procedure QueryLexicons (f : Integer; var pdw : Integer); dispid 109;
    procedure ChangeSpelling (lex : Integer; const stringa : WideString;
                             const stringb : WideString); dispid 110;
  end;

  { TApdCustomDirectSR }

  TDirectSR = class (TOleControl)
  private
    FOnClickIn : TDirectSRClickIn;
    FOnClickOut : TDirectSRClickOut;
    FOnPhraseFinish : TDirectSRPhraseFinish;
    FOnPhraseStart : TDirectSRPhraseStart;
    FOnBookMark : TDirectSRBookMark;
    FOnPaused : TNotifyEvent;
    FOnPhraseHypothesis : TDirectSRPhraseHypothesis;
    FOnReEvaluate : TDirectSRReEvaluate;
    FOnTraining : TDirectSRTraining;
    FOnUnArchive : TDirectSRUnArchive;
    FOnAttribChanged : TDirectSRAttribChanged;
    FOnInterference : TDirectSRInterference;
    FOnSound : TDirectSRSound;
    FOnUtteranceBegin : TDirectSRUtteranceBegin;
    FOnUtteranceEnd : TDirectSRUtteranceEnd;
    FOnVUMeter : TDirectSRVUMeter;
    FOnError : TDirectSRError;
    FOnwarning : TDirectSRwarning;
    FIntf : IDirectSR;
    function GetControlInterface : IDirectSR;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_Wave (results : Integer) : Integer;
    function Get_Phrase (results : Integer; rank : Integer) : WideString;
    function Get_CreateResultsObject (results : Integer) : Integer;
    function Get_FlagsGet (results : Integer; rank : Integer) : Integer;
    function Get_Identify (results : Integer) : WideString;
    function Get_ReEvaluate (results : Integer) : Integer;
    function Get_GetPhraseScore (results : Integer; rank : Integer) : Integer;
    function Get_GetAllArcStrings (punk : Integer;
                                   results : Integer) : WideString;
    function Get_Attributes (Attrib : Integer) : Integer;
    procedure Set_Attributes (Attrib : Integer; pVal : Integer);
    function Get_AttributeString (Attrib : Integer) : WideString;
    procedure Set_AttributeString (Attrib : Integer; const pVal : WideString);
    function Get_AttributeMemory (Attrib : Integer;
                                  var size : Integer) : Integer;
    procedure Set_AttributeMemory (Attrib : Integer; var size : Integer;
                                  pVal : Integer);
    function Get_WaveEx (results : Integer; beginhi : Integer;
                         beginlo : Integer; endhi : Integer;
                         endlo : Integer) : Integer;
    function Get_NodeStart (results : Integer) : Integer;
    function Get_NodeEnd (results : Integer) : Integer;
    function Get_DataGetString (results : Integer; id : Integer;
                                const Attrib : WideString) : WideString;
    function Get_score (results : Integer; scoretype : Integer;
                        var path : Integer; pathsteps : Integer;
                        pathindexstart : Integer;
                        pathindexcount : Integer) : Integer; 
    function Get_NodeGet (results : Integer; arc : Integer;
                          destination : Integer) : Integer;
    function Get_GraphDWORDGet (results : Integer; id : Integer;
                                const Attrib : WideString) : Integer;
    function Get_SpeakerInfoChanged (var filetimehi : Integer;
                                     var filetimelo : Integer) : Integer;
  public
    procedure Deactivate;
    procedure Activate;
    procedure GrammarFromString (const grammar : WideString);
    procedure GrammarFromFile (const FileName : WideString);
    procedure GrammarFromResource (Instance : Integer; ResID : Integer);
    procedure GrammarFromStream (Stream : Integer);
    procedure Pause;
    procedure Resume;
    procedure PosnGet (out hi : Integer; out lo : Integer);
    procedure AboutDlg (hwnd : Integer; const title : WideString);
    procedure GeneralDlg (hwnd : Integer; const title : WideString);
    procedure LexiconDlg (hwnd : Integer; const title : WideString);
    procedure TrainGeneralDlg (hwnd : Integer; const title : WideString);
    procedure TrainMicDlg (hwnd : Integer; const title : WideString);
    procedure DestroyResultsObject (resobj : Integer);
    procedure Select (index : Integer);
    procedure Listen;
    procedure SelectEngine (index : SYSINT);
    function FindEngine (const EngineId : WideString;
                         const MfgName : WideString;
                         const ProductName : WideString;
                         const ModeID : WideString;
                         const ModeName : WideString;
                         LanguageID : Integer; const dialect : WideString;
                         Sequencing : Integer; MaxWordsVocab : Integer;
                         MaxWordsState : Integer; Grammars : Integer;
                         Features : Integer; Interfaces : Integer;
                         EngineFeatures : Integer; RankEngineID : Integer;
                         RankMfgName : Integer; RankProductName : Integer;
                         RankModeID : Integer; RankModeName : Integer;
                         RankLanguage : Integer; RankDialect : Integer;
                         RankSequencing : Integer; RankMaxWordsVocab : Integer;
                         RankMaxWordsState : Integer; RankGrammars : Integer;
                         RankFeatures : Integer; RankInterfaces : Integer;
                         RankEngineFeatures : Integer) : Integer;
    function ModeName (index : SYSINT) : WideString;
    function EngineId (index : SYSINT) : WideString;
    function MfgName (index : SYSINT) : WideString;
    function ProductName (index : SYSINT) : WideString;
    function ModeID (index : SYSINT) : WideString;
    function Features (index : SYSINT) : Integer;
    function Interfaces (index : SYSINT) : Integer;
    function EngineFeatures (index : SYSINT) : Integer;
    function LanguageID (index : SYSINT) : Integer;
    function dialect (index : SYSINT) : WideString;
    function Sequencing (index : SYSINT) : Integer;
    function MaxWordsVocab (index : SYSINT) : Integer;
    function MaxWordsState (index : SYSINT) : Integer;
    function Grammars (index : SYSINT) : Integer;
    procedure InitAudioSourceDirect (direct : Integer);
    procedure InitAudioSourceObject (object_ : Integer);
    procedure TimeGet (results : Integer; var beginhi : Integer;
                       var beginlo : Integer; var endhi : Integer;
                       var endlo : Integer);
    procedure Correction (results : Integer; const Phrase : WideString;
                          confidence : Smallint);
    procedure Validate (results : Integer; confidence : Smallint);
    procedure Archive (keepresults : Integer;
                       out size : Integer; out pVal : Integer);
    procedure DeleteArchive (Archive : Integer);
    procedure GrammarFromMemory (grammar : Integer; size : Integer);
    procedure GrammarDataSet (Data : Integer; size : Integer);
    procedure GrammarToMemory (var grammar : Integer; var size : Integer);
    procedure ActivateAndAssignWindow (hwnd : Integer);
    function Find (const RankList : WideString) : Integer;
    procedure ArcEnum (results : Integer; node : Integer; Outgoing : Integer;
                       var nodelist : Integer; var countnodes : Integer);
    procedure BestPathEnum (results : Integer; rank : Integer;
                            var startpath : Integer; startpathsteps : Integer;
                            var endpath : Integer; endpathsteps : Integer;
                            exactmatch : Integer; var arclist : Integer;
                            var arccount : Integer);
    procedure DataGetTime (results : Integer; id : Integer;
                           const Attrib : WideString; var hi : Integer;
                           var lo : Integer);
    procedure GetAllArcs (results : Integer; var arcids : Integer;
                          var arccount : Integer);
    procedure GetAllNodes (results : Integer; var Nodes : Integer;
                           var countnodes : Integer);
    procedure RenameSpeaker (const OldName : WideString;
                             const newName : WideString);
    procedure DeleteSpeaker (const Speaker : WideString);
    procedure CommitSpeaker;
    procedure RevertSpeaker (const Speaker : WideString);
    procedure TrainPhrasesDlg (hwnd : Integer; const title : WideString);
    procedure LexAddTo (lex : LongWord; charset : Integer;
                        const text : WideString; const pronounce : WideString;
                        partofspeech : Integer; EngineInfo : Integer;
                        engineinfosize : Integer);
    procedure LexGetFrom (lex : Integer; charset : Integer;
                          const text : WideString; sense : Integer;
                          var pronounce : WideString;
                          var partofspeech : Integer; var EngineInfo : Integer;
                         var sizeofengineinfo : Integer);
    procedure LexRemoveFrom (lex : Integer; const text : WideString;
                             sense : Integer);
    procedure QueryLexicons (f : Integer; var pdw : Integer);
    procedure ChangeSpelling (lex : Integer; const stringa : WideString;
                              const stringb : WideString);
    property  ControlInterface : IDirectSR read GetControlInterface;
    property  DefaultInterface : IDirectSR read GetControlInterface;
    property MinAutoGain : Integer index 12 read GetIntegerProp;
    property MaxAutoGain : Integer index 13 read GetIntegerProp;
    property MaxEnergyFloor : Integer index 16 read GetIntegerProp;
    property MinEnergyFloor : Integer index 17 read GetIntegerProp;
    property MaxRealTime : Integer index 21 read GetIntegerProp;
    property MinRealTime : Integer index 22 read GetIntegerProp;
    property MaxThreshold : Integer index 24 read GetIntegerProp;
    property MinThreshold : Integer index 25 read GetIntegerProp;
    property MaxCompleteTimeOut : Integer index 28 read GetIntegerProp;
    property MinCompleteTimeOut : Integer index 29 read GetIntegerProp;
    property MaxIncompleteTimeOut : Integer index 30 read GetIntegerProp;
    property MinIncompleteTimeOut : Integer index 31 read GetIntegerProp;
    property Wave[results : Integer] : Integer read Get_Wave;
    property Phrase[results : Integer; rank : Integer] : WideString
             read Get_Phrase;
    property CreateResultsObject[results : Integer] : Integer
             read Get_CreateResultsObject;
    property CountEngines : Integer index 48 read GetIntegerProp;
    property FlagsGet[results : Integer; rank : Integer] : Integer
             read Get_FlagsGet;
    property Identify[results : Integer] : WideString read Get_Identify;
    property ReEvaluate[results : Integer] : Integer read Get_ReEvaluate;
    property GetPhraseScore[results : Integer; rank : Integer] : Integer
             read Get_GetPhraseScore;
    property hwnd : Integer index 81 read GetIntegerProp;
    property GetAllArcStrings[punk : Integer; results : Integer] : WideString
             read Get_GetAllArcStrings;
    property Attributes[Attrib : Integer] : Integer
             read Get_Attributes write Set_Attributes;
    property AttributeString[Attrib : Integer] : WideString
             read Get_AttributeString write Set_AttributeString;
    property AttributeMemory[Attrib : Integer; var size : Integer] : Integer
             read Get_AttributeMemory write Set_AttributeMemory;
    property WaveEx[results : Integer; beginhi : Integer; beginlo : Integer;
                    endhi : Integer; endlo : Integer] : Integer read Get_WaveEx;
    property NodeStart[results : Integer] : Integer read Get_NodeStart;
    property NodeEnd[results : Integer] : Integer read Get_NodeEnd;
    property DataGetString[results : Integer; id : Integer;
                           const Attrib : WideString] : WideString
             read Get_DataGetString;
    property score[results : Integer; scoretype : Integer; var path : Integer;
                   pathsteps : Integer; pathindexstart : Integer;
                   pathindexcount : Integer] : Integer read Get_score;
    property NodeGet[results : Integer; arc : Integer;
                     destination : Integer] : Integer read Get_NodeGet;
    property GraphDWORDGet[results : Integer; id : Integer;
                           const Attrib : WideString] : Integer
             read Get_GraphDWORDGet;
    property SpeakerInfoChanged[var filetimehi : Integer;
                                var filetimelo : Integer] : Integer
             read Get_SpeakerInfoChanged;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property debug : Smallint index 1
             read GetSmallintProp write SetSmallintProp stored False;
    property Initialized : Smallint index 2
             read GetSmallintProp write SetSmallintProp stored False;
    property LastHeard : WideString index 6
             read GetWideStringProp write SetWideStringProp stored False;
    property AutoGain : Integer index 11
             read GetIntegerProp write SetIntegerProp stored False;
    property Echo : Smallint index 14
             read GetSmallintProp write SetSmallintProp stored False;
    property EnergyFloor : Integer index 15
             read GetIntegerProp write SetIntegerProp stored False;
    property Microphone : WideString index 18
             read GetWideStringProp write SetWideStringProp stored False;
    property Speaker : WideString index 19
             read GetWideStringProp write SetWideStringProp stored False;
    property RealTime : Integer index 20
             read GetIntegerProp write SetIntegerProp stored False;
    property Threshold : Integer index 23
             read GetIntegerProp write SetIntegerProp stored False;
    property CompleteTimeOut : Integer index 26
             read GetIntegerProp write SetIntegerProp stored False;
    property IncompleteTimeOut : Integer index 27
             read GetIntegerProp write SetIntegerProp stored False;
    property FileName : WideString index 65
             read GetWideStringProp write SetWideStringProp stored False;
    property LastError : Integer index 79
             read GetIntegerProp write SetIntegerProp stored False;
    property SuppressExceptions : Integer index 80
             read GetIntegerProp write SetIntegerProp stored False;
    property SRMode : Integer index 83
             read GetIntegerProp write SetIntegerProp stored False;
    property OnClickIn : TDirectSRClickIn
             read FOnClickIn write FOnClickIn;
    property OnClickOut : TDirectSRClickOut
             read FOnClickOut write FOnClickOut;
    property OnPhraseFinish : TDirectSRPhraseFinish
             read FOnPhraseFinish write FOnPhraseFinish;
    property OnPhraseStart : TDirectSRPhraseStart
             read FOnPhraseStart write FOnPhraseStart;
    property OnBookMark : TDirectSRBookMark
             read FOnBookMark write FOnBookMark;
    property OnPaused : TNotifyEvent
             read FOnPaused write FOnPaused;
    property OnPhraseHypothesis : TDirectSRPhraseHypothesis
             read FOnPhraseHypothesis write FOnPhraseHypothesis;
    property OnReEvaluate : TDirectSRReEvaluate
             read FOnReEvaluate write FOnReEvaluate;
    property OnTraining : TDirectSRTraining
             read FOnTraining write FOnTraining;
    property OnUnArchive : TDirectSRUnArchive
             read FOnUnArchive write FOnUnArchive;
    property OnAttribChanged : TDirectSRAttribChanged
             read FOnAttribChanged write FOnAttribChanged;
    property OnInterference : TDirectSRInterference
             read FOnInterference write FOnInterference;
    property OnSound : TDirectSRSound read FOnSound write FOnSound;
    property OnUtteranceBegin : TDirectSRUtteranceBegin
             read FOnUtteranceBegin write FOnUtteranceBegin;
    property OnUtteranceEnd : TDirectSRUtteranceEnd
             read FOnUtteranceEnd write FOnUtteranceEnd;
    property OnVUMeter : TDirectSRVUMeter read FOnVUMeter write FOnVUMeter;
    property OnError : TDirectSRError read FOnError write FOnError;
    property Onwarning : TDirectSRwarning read FOnwarning write FOnwarning;
  end;

  { _DirectSSEvents }

  _DirectSSEvents = dispinterface
    ['{EEE78597-FE22-11D0-8BEF-0060081841DE}']
    procedure ClickIn (x : Integer; y : Integer); dispid 1;
    procedure ClickOut (x : Integer; y : Integer); dispid 2;
    procedure AudioStart (hi : Integer; lo : Integer); dispid 3;
    procedure AudioStop (hi : Integer; lo : Integer); dispid 4;
    procedure AttribChanged (which_attribute : Integer); dispid 5;
    procedure Visual (timehi : Integer; timelo : Integer; Phoneme : Smallint;
                      EnginePhoneme : Smallint; hints : Integer;
                      MouthHeight : Smallint; bMouthWidth : Smallint;
                      bMouthUpturn : Smallint; bJawOpen : Smallint;
                      TeethUpperVisible : Smallint; TeethLowerVisible : Smallint;
                      TonguePosn : Smallint; LipTension : Smallint); dispid 6;
    procedure WordPosition (hi : Integer; lo : Integer;
                            byteoffset : Integer); dispid 7;
    procedure BookMark (hi : Integer; lo : Integer; MarkNum : Integer);
              dispid 8;
    procedure TextDataStarted (hi : Integer; lo : Integer); dispid 9;
    procedure TextDataDone (hi : Integer; lo : Integer; Flags : Integer);
              dispid 10;
    procedure ActiveVoiceStartup (init : Integer; init2 : Integer); dispid 11;
    procedure Debugging; dispid 12;
    procedure Error (warning : LongWord; const Details:
                     WideString; const Message : WideString); dispid 13;
    procedure warning (warning : LongWord; const Details : WideString;
                       const Message : WideString); dispid 14;
    procedure VisualFuture (milliseconds : Integer; timehi : Integer;
                            timelo : Integer; Phoneme : Smallint;
                            EnginePhoneme : Smallint; hints : Integer;
                            MouthHeight : Smallint; bMouthWidth : Smallint;
                            bMouthUpturn : Smallint; bJawOpen : Smallint;
                            TeethUpperVisible : Smallint;
                            TeethLowerVisible : Smallint;
                            TonguePosn : Smallint;
                            LipTension : Smallint); dispid 15;
  end;

  { IDirectSS }

  IDirectSS = interface (IDispatch)
    ['{EEE78590-FE22-11D0-8BEF-0060081841DE}']
    function Get_debug : Smallint; safecall;
    procedure Set_debug (pVal : Smallint); safecall;
    function Get_Initialized : Smallint; safecall;
    procedure Set_Initialized (pVal : Smallint); safecall;
    procedure Speak (const text : WideString); safecall;
    function Get_Pitch : Integer; safecall;
    procedure Set_Pitch (pVal : Integer); safecall;
    function Get_MaxPitch : Integer; safecall;
    procedure Set_MaxPitch (pVal : Integer); safecall;
    function Get_MinPitch : Integer; safecall;
    procedure Set_MinPitch (pVal : Integer); safecall;
    function Get_Speed : Integer; safecall;
    procedure Set_Speed (pVal : Integer); safecall;
    function Get_MaxSpeed : Integer; safecall;
    procedure Set_MaxSpeed (pVal : Integer); safecall;
    function Get_MinSpeed : Integer; safecall;
    procedure Set_MinSpeed (pVal : Integer); safecall;
    function Get_VolumeRight : Integer; safecall;
    procedure Set_VolumeRight (pVal : Integer); safecall;
    function Get_MinVolumeRight : Integer; safecall;
    procedure Set_MinVolumeRight (pVal : Integer); safecall;
    function Get_MaxVolumeRight : Integer; safecall;
    procedure Set_MaxVolumeRight (pVal : Integer); safecall;
    procedure Select (index : SYSINT); safecall;
    function EngineID (index : SYSINT) : WideString; safecall;
    function Get_CountEngines : Integer; safecall;
    function ModeName (index : SYSINT) : WideString; safecall;
    function MfgName (index : SYSINT) : WideString; safecall;
    function ProductName (index : SYSINT) : WideString; safecall;
    function ModeID (index : SYSINT) : WideString; safecall;
    function Speaker (index : SYSINT) : WideString; safecall;
    function Style (index : SYSINT) : WideString; safecall;
    function Gender (index : SYSINT) : Integer; safecall;
    function Age (index : SYSINT) : Integer; safecall;
    function Features (index : SYSINT) : Integer; safecall;
    function Interfaces (index : SYSINT) : Integer; safecall;
    function EngineFeatures (index : SYSINT) : Integer; safecall;
    function LanguageID (index : SYSINT) : Integer; safecall;
    function Dialect (index : SYSINT) : WideString; safecall;
    function Get_RealTime : Integer; safecall;
    procedure Set_RealTime (pVal : Integer); safecall;
    function Get_MaxRealTime : Integer; safecall;
    function Get_MinRealTime : Integer; safecall;
    procedure Set_MinRealTime (pVal : Integer); safecall;
    procedure AudioPause; safecall;
    procedure AudioReset; safecall;
    procedure AudioResume; safecall;
    procedure Inject (const value : WideString); safecall;
    function Get_Tagged : Integer; safecall;
    procedure Set_Tagged (pVal : Integer); safecall;
    function Phonemes (charset : Integer; Flags : Integer;
                       const input : WideString) : WideString; safecall;
    procedure PosnGet (var hi : Integer; var lo : Integer); safecall;
    procedure TextData (characterset : Integer; Flags : Integer;
                        const text : WideString); safecall;
    procedure InitAudioDestMM (deviceid : Integer); safecall;
    procedure AboutDlg (hWnd : Integer; const title : WideString); safecall;
    procedure GeneralDlg (hWnd : Integer; const title : WideString); safecall;
    procedure LexiconDlg (hWnd : Integer; const title : WideString); safecall;
    procedure TranslateDlg (hWnd : Integer; const title : WideString); safecall;
    function FindEngine (const EngineID : WideString;
                         const MfgName : WideString;
                         const ProductName : WideString;
                         const ModeID : WideString;
                         const ModeName : WideString;
                         LanguageID : Integer; const Dialect : WideString;
                         const Speaker : WideString; const Style : WideString;
                         Gender : Integer; Age : Integer; Features : Integer;
                         Interfaces : Integer; EngineFeatures : Integer;
                         RankEngineID : Integer; RankMfgName : Integer;
                         RankProductName : Integer; RankModeID : Integer;
                         RankModeName : Integer; RankLanguage : Integer;
                         RankDialect : Integer; RankSpeaker : Integer;
                         RankStyle : Integer; RankGender : Integer;
                         RankAge : Integer; RankFeatures : Integer;
                         RankInterfaces : Integer;
                         RankEngineFeatures : Integer) : Integer; safecall;
    function Get_MouthHeight : Smallint; safecall;
    procedure Set_MouthHeight (pVal : Smallint); safecall;
    function Get_MouthWidth : Smallint; safecall;
    procedure Set_MouthWidth (pVal : Smallint); safecall;
    function Get_MouthUpturn : Smallint; safecall;
    procedure Set_MouthUpturn (pVal : Smallint); safecall;
    function Get_JawOpen : Smallint; safecall;
    procedure Set_JawOpen (pVal : Smallint); safecall;
    function Get_TeethUpperVisible : Smallint; safecall;
    procedure Set_TeethUpperVisible (pVal : Smallint); safecall;
    function Get_TeethLowerVisible : Smallint; safecall;
    procedure Set_TeethLowerVisible (pVal : Smallint); safecall;
    function Get_TonguePosn : Smallint; safecall;
    procedure Set_TonguePosn (pVal : Smallint); safecall;
    function Get_LipTension : Smallint; safecall;
    procedure Set_LipTension (pVal : Smallint); safecall;
    function Get_CallBacksEnabled : Smallint; safecall;
    procedure Set_CallBacksEnabled (pVal : Smallint); safecall;
    function Get_MouthEnabled : Smallint; safecall;
    procedure Set_MouthEnabled (pVal : Smallint); safecall;
    function Get_LastError : Integer; safecall;
    procedure Set_LastError (pVal : Integer); safecall;
    function Get_SuppressExceptions : Smallint; safecall;
    procedure Set_SuppressExceptions (pVal : Smallint); safecall;
    function Get_Speaking : Smallint; safecall;
    procedure Set_Speaking (pVal : Smallint); safecall;
    function Get_LastWordPosition : Integer; safecall;
    procedure Set_LastWordPosition (pVal : Integer); safecall;
    function Get_LipType : Smallint; safecall;
    procedure Set_LipType (pVal : Smallint); safecall;
    procedure GetPronunciation (charset : Integer; const text : WideString;
                                Sense : Integer; var Pronounce : WideString;
                                var PartOfSpeech : Integer;
                                var EngineInfo : WideString); safecall;
    procedure InitAudioDestDirect (direct : Integer); safecall;
    function Get_Sayit : WideString; safecall;
    procedure Set_Sayit (const newVal : WideString); safecall;
    procedure InitAudioDestObject (object_ : Integer); safecall;
    function Get_FileName : WideString; safecall;
    procedure Set_FileName (const pVal : WideString); safecall;
    function Get_CurrentMode : Integer; safecall;
    procedure Set_CurrentMode (pVal : Integer); safecall;
    function Get_hWnd : Integer; safecall;
    function Find (const RankList : WideString) : Integer; safecall;
    function Get_VolumeLeft : Integer; safecall;
    procedure Set_VolumeLeft (pVal : Integer); safecall;
    function Get_MinVolumeLeft : Integer; safecall;
    procedure Set_MinVolumeLeft (pVal : Integer); safecall;
    function Get_MaxVolumeLeft : Integer; safecall;
    procedure Set_MaxVolumeLeft (pVal : Integer); safecall;
    function Get_AudioDest : Integer; safecall;
    function Get_Attributes (Attrib : Integer) : Integer; safecall;
    procedure Set_Attributes (Attrib : Integer; pVal : Integer); safecall;
    function Get_AttributeString (Attrib : Integer) : WideString; safecall;
    procedure Set_AttributeString (Attrib : Integer;
                                  const pVal : WideString); safecall;
    function Get_AttributeMemory (Attrib : Integer;
                                  var size : Integer) : Integer; safecall;
    procedure Set_AttributeMemory (Attrib : Integer;
                                  var size : Integer; pVal : Integer); safecall;
    procedure LexAddTo (lex : LongWord; charset : Integer;
                        const text : WideString; const Pronounce : WideString;
                        PartOfSpeech : Integer; EngineInfo : Integer;
                        engineinfosize : Integer); safecall;
    procedure LexGetFrom (lex : Integer; charset : Integer;
                          const text : WideString; Sense : Integer;
                          var Pronounce : WideString;
                          var PartOfSpeech : Integer; var EngineInfo : Integer;
                          var sizeofengineinfo : Integer); safecall;
    procedure LexRemoveFrom (lex : Integer; const text : WideString;
                             Sense : Integer); safecall;
    procedure QueryLexicons (f : Integer; var pdw : Integer); safecall;
    procedure ChangeSpelling (lex : Integer; const stringa : WideString;
                              const stringb : WideString); safecall;
    property debug : Smallint read Get_debug write Set_debug;
    property Initialized : Smallint read Get_Initialized write Set_Initialized;
    property Pitch : Integer read Get_Pitch write Set_Pitch;
    property MaxPitch : Integer read Get_MaxPitch write Set_MaxPitch;
    property MinPitch : Integer read Get_MinPitch write Set_MinPitch;
    property Speed : Integer read Get_Speed write Set_Speed;
    property MaxSpeed : Integer read Get_MaxSpeed write Set_MaxSpeed;
    property MinSpeed : Integer read Get_MinSpeed write Set_MinSpeed;
    property VolumeRight : Integer read Get_VolumeRight write Set_VolumeRight;
    property MinVolumeRight : Integer
             read Get_MinVolumeRight write Set_MinVolumeRight;
    property MaxVolumeRight : Integer
             read Get_MaxVolumeRight write Set_MaxVolumeRight;
    property CountEngines : Integer read Get_CountEngines;
    property RealTime : Integer read Get_RealTime write Set_RealTime;
    property MaxRealTime : Integer read Get_MaxRealTime;
    property MinRealTime : Integer read Get_MinRealTime write Set_MinRealTime;
    property Tagged : Integer read Get_Tagged write Set_Tagged;
    property MouthHeight : Smallint read Get_MouthHeight write Set_MouthHeight;
    property MouthWidth : Smallint read Get_MouthWidth write Set_MouthWidth;
    property MouthUpturn : Smallint read Get_MouthUpturn write Set_MouthUpturn;
    property JawOpen : Smallint read Get_JawOpen write Set_JawOpen;
    property TeethUpperVisible : Smallint
             read Get_TeethUpperVisible write Set_TeethUpperVisible;
    property TeethLowerVisible : Smallint
             read Get_TeethLowerVisible write Set_TeethLowerVisible;
    property TonguePosn : Smallint read Get_TonguePosn write Set_TonguePosn;
    property LipTension : Smallint read Get_LipTension write Set_LipTension;
    property CallBacksEnabled : Smallint
             read Get_CallBacksEnabled write Set_CallBacksEnabled;
    property MouthEnabled : Smallint
             read Get_MouthEnabled write Set_MouthEnabled;
    property LastError : Integer read Get_LastError write Set_LastError;
    property SuppressExceptions : Smallint
             read Get_SuppressExceptions write Set_SuppressExceptions;
    property Speaking : Smallint read Get_Speaking write Set_Speaking;
    property LastWordPosition : Integer
             read Get_LastWordPosition write Set_LastWordPosition;
    property LipType : Smallint read Get_LipType write Set_LipType;
    property Sayit : WideString read Get_Sayit write Set_Sayit;
    property FileName : WideString read Get_FileName write Set_FileName;
    property CurrentMode : Integer read Get_CurrentMode write Set_CurrentMode;
    property hWnd : Integer read Get_hWnd;
    property VolumeLeft : Integer read Get_VolumeLeft write Set_VolumeLeft;
    property MinVolumeLeft : Integer
             read Get_MinVolumeLeft write Set_MinVolumeLeft;
    property MaxVolumeLeft : Integer
             read Get_MaxVolumeLeft write Set_MaxVolumeLeft;
    property AudioDest : Integer read Get_AudioDest;
    property Attributes[Attrib : Integer] : Integer
             read Get_Attributes write Set_Attributes;
    property AttributeString[Attrib : Integer] : WideString
             read Get_AttributeString write Set_AttributeString;
    property AttributeMemory[Attrib : Integer; var size : Integer] : Integer
             read Get_AttributeMemory write Set_AttributeMemory;
  end;

  { IDirectSSDisp }

  IDirectSSDisp = dispinterface
    ['{EEE78590-FE22-11D0-8BEF-0060081841DE}']
    property debug : Smallint dispid 1;
    property Initialized : Smallint dispid 2;
    procedure Speak (const text : WideString); dispid 6;
    property Pitch : Integer dispid 7;
    property MaxPitch : Integer dispid 8;
    property MinPitch : Integer dispid 9;
    property Speed : Integer dispid 10;
    property MaxSpeed : Integer dispid 11;
    property MinSpeed : Integer dispid 12;
    property VolumeRight : Integer dispid 13;
    property MinVolumeRight : Integer dispid 14;
    property MaxVolumeRight : Integer dispid 15;
    procedure Select (index : SYSINT); dispid 16;
    function EngineID (index : SYSINT) : WideString; dispid 17;
    property CountEngines : Integer readonly dispid 18;
    function ModeName (index : SYSINT) : WideString; dispid 19;
    function MfgName (index : SYSINT) : WideString; dispid 20;
    function ProductName (index : SYSINT) : WideString; dispid 21;
    function ModeID (index : SYSINT) : WideString; dispid 22;
    function Speaker (index : SYSINT) : WideString; dispid 23;
    function Style (index : SYSINT) : WideString; dispid 24;
    function Gender (index : SYSINT) : Integer; dispid 25;
    function Age (index : SYSINT) : Integer; dispid 26;
    function Features (index : SYSINT) : Integer; dispid 27;
    function Interfaces (index : SYSINT) : Integer; dispid 28;
    function EngineFeatures (index : SYSINT) : Integer; dispid 29;
    function LanguageID (index : SYSINT) : Integer; dispid 30;
    function Dialect (index : SYSINT) : WideString; dispid 31;
    property RealTime : Integer dispid 32;
    property MaxRealTime : Integer readonly dispid 33;
    property MinRealTime : Integer dispid 34;
    procedure AudioPause; dispid 35;
    procedure AudioReset; dispid 36;
    procedure AudioResume; dispid 37;
    procedure Inject (const value : WideString); dispid 38;
    property Tagged : Integer dispid 39;
    function Phonemes (charset : Integer; Flags : Integer;
                       const input : WideString) : WideString; dispid 40;
    procedure PosnGet (var hi : Integer; var lo : Integer); dispid 41;
    procedure TextData (characterset : Integer; Flags : Integer;
                        const text : WideString); dispid 42;
    procedure InitAudioDestMM (deviceid : Integer); dispid 43;
    procedure AboutDlg (hWnd : Integer; const title : WideString); dispid 44;
    procedure GeneralDlg (hWnd : Integer; const title : WideString); dispid 45;
    procedure LexiconDlg (hWnd : Integer; const title : WideString); dispid 46;
    procedure TranslateDlg (hWnd : Integer; const title : WideString);
              dispid 47;
    function FindEngine (const EngineID : WideString;
                         const MfgName : WideString;
                         const ProductName : WideString;
                         const ModeID : WideString;
                         const ModeName : WideString;
                         LanguageID : Integer; const Dialect : WideString;
                         const Speaker : WideString; const Style : WideString;
                         Gender : Integer; Age : Integer; Features : Integer;
                         Interfaces : Integer; EngineFeatures : Integer;
                         RankEngineID : Integer; RankMfgName : Integer;
                         RankProductName : Integer; RankModeID : Integer;
                         RankModeName : Integer; RankLanguage : Integer;
                         RankDialect : Integer; RankSpeaker : Integer;
                         RankStyle : Integer; RankGender : Integer;
                         RankAge : Integer; RankFeatures : Integer;
                         RankInterfaces : Integer;
                         RankEngineFeatures : Integer) : Integer; dispid 48;
    property MouthHeight : Smallint dispid 49;
    property MouthWidth : Smallint dispid 50;
    property MouthUpturn : Smallint dispid 51;
    property JawOpen : Smallint dispid 52;
    property TeethUpperVisible : Smallint dispid 53;
    property TeethLowerVisible : Smallint dispid 54;
    property TonguePosn : Smallint dispid 55;
    property LipTension : Smallint dispid 56;
    property CallBacksEnabled : Smallint dispid 57;
    property MouthEnabled : Smallint dispid 58;
    property LastError : Integer dispid 59;
    property SuppressExceptions : Smallint dispid 60;
    property Speaking : Smallint dispid 61;
    property LastWordPosition : Integer dispid 62;
    property LipType : Smallint dispid 63;
    procedure GetPronunciation (charset : Integer; const text : WideString;
                                Sense : Integer; var Pronounce : WideString;
                                var PartOfSpeech : Integer;
                                var EngineInfo : WideString); dispid 64;
    procedure InitAudioDestDirect (direct : Integer); dispid 65;
    property Sayit : WideString dispid 66;
    procedure InitAudioDestObject (object_ : Integer); dispid 67;
    property FileName : WideString dispid 68;
    property CurrentMode : Integer dispid 69;
    property hWnd : Integer readonly dispid 70;
    function Find (const RankList : WideString) : Integer; dispid 71;
    property VolumeLeft : Integer dispid 72;
    property MinVolumeLeft : Integer dispid 73;
    property MaxVolumeLeft : Integer dispid 74;
    property AudioDest : Integer readonly dispid 75;
    property Attributes[Attrib : Integer] : Integer dispid 76;
    property AttributeString[Attrib : Integer] : WideString dispid 77;
    property AttributeMemory[Attrib : Integer;
                             var size : Integer] : Integer dispid 78;
    procedure LexAddTo (lex : LongWord; charset : Integer;
                        const text : WideString;
                        const Pronounce : WideString; PartOfSpeech : Integer;
                        EngineInfo : Integer;
                        engineinfosize : Integer); dispid 79;
    procedure LexGetFrom (lex : Integer; charset : Integer;
                          const text : WideString; Sense : Integer;
                          var Pronounce : WideString;
                          var PartOfSpeech : Integer; var EngineInfo : Integer;
                          var sizeofengineinfo : Integer); dispid 80;
    procedure LexRemoveFrom (lex : Integer; const text : WideString;
                             Sense : Integer); dispid 81;
    procedure QueryLexicons (f : Integer; var pdw : Integer); dispid 82;
    procedure ChangeSpelling (lex : Integer; const stringa : WideString;
                              const stringb : WideString); dispid 83;
  end;

  { TApdCustomDirectSS }

  TDirectSS = class (TOleControl) 
  private
    FOnClickIn : TDirectSSClickIn;
    FOnClickOut : TDirectSSClickOut;
    FOnAudioStart : TDirectSSAudioStart;
    FOnAudioStop : TDirectSSAudioStop;
    FOnAttribChanged : TDirectSSAttribChanged;
    FOnVisual : TDirectSSVisual;
    FOnWordPosition : TDirectSSWordPosition;
    FOnBookMark : TDirectSSBookMark;
    FOnTextDataStarted : TDirectSSTextDataStarted;
    FOnTextDataDone : TDirectSSTextDataDone;
    FOnActiveVoiceStartup : TDirectSSActiveVoiceStartup;
    FOnDebugging : TNotifyEvent;
    FOnError : TDirectSSError;
    FOnwarning : TDirectSSwarning;
    FOnVisualFuture : TDirectSSVisualFuture;
    FIntf : IDirectSS;
    function GetControlInterface : IDirectSS;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_Attributes (Attrib : Integer) : Integer;
    procedure Set_Attributes (Attrib : Integer; pVal : Integer);
    function Get_AttributeString (Attrib : Integer) : WideString;
    procedure Set_AttributeString (Attrib : Integer; const pVal : WideString);
    function Get_AttributeMemory (Attrib : Integer;
                                  var size : Integer) : Integer;
    procedure Set_AttributeMemory (Attrib : Integer;
                                   var size : Integer; pVal : Integer);
  public
    constructor Create (AOwner : TComponent); override;
    
    procedure Speak (const text : WideString);
    procedure Select (index : SYSINT);
    function EngineID (index : SYSINT) : WideString;
    function ModeName (index : SYSINT) : WideString;
    function MfgName (index : SYSINT) : WideString;
    function ProductName (index : SYSINT) : WideString;
    function ModeID (index : SYSINT) : WideString;
    function Speaker (index : SYSINT) : WideString;
    function Style (index : SYSINT) : WideString;
    function Gender (index : SYSINT) : Integer;
    function Age (index : SYSINT) : Integer;
    function Features (index : SYSINT) : Integer;
    function Interfaces (index : SYSINT) : Integer;
    function EngineFeatures (index : SYSINT) : Integer;
    function LanguageID (index : SYSINT) : Integer;
    function Dialect (index : SYSINT) : WideString;
    procedure AudioPause;
    procedure AudioReset;
    procedure AudioResume;
    procedure Inject (const value : WideString);
    function Phonemes (charset : Integer; Flags : Integer;
                       const input : WideString) : WideString;
    procedure PosnGet (var hi : Integer; var lo : Integer);
    procedure TextData (characterset : Integer; Flags : Integer;
                        const text : WideString);
    procedure InitAudioDestMM (deviceid : Integer);
    procedure AboutDlg (hWnd : Integer; const title : WideString);
    procedure GeneralDlg (hWnd : Integer; const title : WideString);
    procedure LexiconDlg (hWnd : Integer; const title : WideString);
    procedure TranslateDlg (hWnd : Integer; const title : WideString);
    function FindEngine (const EngineID : WideString;
                         const MfgName : WideString;
                         const ProductName : WideString;
                         const ModeID : WideString; const ModeName : WideString;
                         LanguageID : Integer; const Dialect : WideString;
                         const Speaker : WideString; const Style : WideString;
                         Gender : Integer; Age : Integer; Features : Integer;
                         Interfaces : Integer; EngineFeatures : Integer;
                         RankEngineID : Integer; RankMfgName : Integer;
                         RankProductName : Integer; RankModeID : Integer;
                         RankModeName : Integer; RankLanguage : Integer;
                         RankDialect : Integer; RankSpeaker : Integer;
                         RankStyle : Integer; RankGender : Integer;
                         RankAge : Integer; RankFeatures : Integer;
                         RankInterfaces : Integer;
                         RankEngineFeatures : Integer) : Integer;
    procedure GetPronunciation (charset : Integer; const text : WideString;
                                Sense : Integer; var Pronounce : WideString;
                                var PartOfSpeech : Integer;
                                var EngineInfo : WideString);
    procedure InitAudioDestDirect (direct : Integer);
    procedure InitAudioDestObject (object_ : Integer);
    function Find (const RankList : WideString) : Integer;
    procedure LexAddTo (lex : LongWord; charset : Integer;
                        const text : WideString; const Pronounce : WideString;
                        PartOfSpeech : Integer; EngineInfo : Integer;
                        engineinfosize : Integer);
    procedure LexGetFrom (lex : Integer; charset : Integer;
                          const text : WideString; Sense : Integer;
                          var Pronounce : WideString;
                          var PartOfSpeech : Integer; var EngineInfo : Integer;
                          var sizeofengineinfo : Integer);
    procedure LexRemoveFrom (lex : Integer; const text : WideString;
                             Sense : Integer);
    procedure QueryLexicons (f : Integer; var pdw : Integer);
    procedure ChangeSpelling (lex : Integer; const stringa : WideString;
                              const stringb : WideString);
    property  ControlInterface : IDirectSS read GetControlInterface;
    property  DefaultInterface : IDirectSS read GetControlInterface;
    property CountEngines : Integer index 18 read GetIntegerProp;
    property MaxRealTime : Integer index 33 read GetIntegerProp;
    property hWnd : Integer index 70 read GetIntegerProp;
    property AudioDest : Integer index 75 read GetIntegerProp;
    property Attributes[Attrib : Integer] : Integer
             read Get_Attributes write Set_Attributes;
    property AttributeString[Attrib : Integer] : WideString
             read Get_AttributeString write Set_AttributeString;
    property AttributeMemory[Attrib : Integer; var size : Integer] : Integer
             read Get_AttributeMemory write Set_AttributeMemory;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property debug : Smallint index 1
             read GetSmallintProp write SetSmallintProp stored False;
    property Initialized : Smallint index 2
             read GetSmallintProp write SetSmallintProp stored False;
    property Pitch : Integer index 7
             read GetIntegerProp write SetIntegerProp stored False;
    property MaxPitch : Integer index 8
             read GetIntegerProp write SetIntegerProp stored False;
    property MinPitch : Integer index 9
             read GetIntegerProp write SetIntegerProp stored False;
    property Speed : Integer index 10
             read GetIntegerProp write SetIntegerProp stored False;
    property MaxSpeed : Integer index 11
             read GetIntegerProp write SetIntegerProp stored False;
    property MinSpeed : Integer index 12
             read GetIntegerProp write SetIntegerProp stored False;
    property VolumeRight : Integer index 13
             read GetIntegerProp write SetIntegerProp stored False;
    property MinVolumeRight : Integer index 14
             read GetIntegerProp write SetIntegerProp stored False;
    property MaxVolumeRight : Integer index 15
             read GetIntegerProp write SetIntegerProp stored False;
    property RealTime : Integer index 32
             read GetIntegerProp write SetIntegerProp stored False;
    property MinRealTime : Integer index 34
             read GetIntegerProp write SetIntegerProp stored False;
    property Tagged : Integer index 39
             read GetIntegerProp write SetIntegerProp stored False;
    property MouthHeight : Smallint index 49
             read GetSmallintProp write SetSmallintProp stored False;
    property MouthWidth : Smallint index 50
             read GetSmallintProp write SetSmallintProp stored False;
    property MouthUpturn : Smallint index 51
             read GetSmallintProp write SetSmallintProp stored False;
    property JawOpen : Smallint index 52
             read GetSmallintProp write SetSmallintProp stored False;
    property TeethUpperVisible : Smallint index 53
             read GetSmallintProp write SetSmallintProp stored False;
    property TeethLowerVisible : Smallint index 54
             read GetSmallintProp write SetSmallintProp stored False;
    property TonguePosn : Smallint index 55
             read GetSmallintProp write SetSmallintProp stored False;
    property LipTension : Smallint index 56
             read GetSmallintProp write SetSmallintProp stored False;
    property CallBacksEnabled : Smallint index 57
             read GetSmallintProp write SetSmallintProp stored False;
    property MouthEnabled : Smallint index 58
             read GetSmallintProp write SetSmallintProp stored False;
    property LastError : Integer index 59
             read GetIntegerProp write SetIntegerProp stored False;
    property SuppressExceptions : Smallint index 60
             read GetSmallintProp write SetSmallintProp stored False;
    property Speaking : Smallint index 61
             read GetSmallintProp write SetSmallintProp stored False;
    property LastWordPosition : Integer index 62
             read GetIntegerProp write SetIntegerProp stored False;
    property LipType : Smallint index 63
             read GetSmallintProp write SetSmallintProp stored False;
    property Sayit : WideString index 66
             read GetWideStringProp write SetWideStringProp stored False;
    property FileName : WideString index 68
             read GetWideStringProp write SetWideStringProp stored False;
    property CurrentMode : Integer index 69
             read GetIntegerProp write SetIntegerProp stored False;
    property VolumeLeft : Integer index 72
             read GetIntegerProp write SetIntegerProp stored False;
    property MinVolumeLeft : Integer index 73
             read GetIntegerProp write SetIntegerProp stored False;
    property MaxVolumeLeft : Integer index 74
             read GetIntegerProp write SetIntegerProp stored False;
    property OnClickIn : TDirectSSClickIn read FOnClickIn write FOnClickIn;
    property OnClickOut : TDirectSSClickOut read FOnClickOut write FOnClickOut;
    property OnAudioStart : TDirectSSAudioStart
             read FOnAudioStart write FOnAudioStart;
    property OnAudioStop : TDirectSSAudioStop
             read FOnAudioStop write FOnAudioStop;
    property OnAttribChanged : TDirectSSAttribChanged
             read FOnAttribChanged write FOnAttribChanged;
    property OnVisual : TDirectSSVisual read FOnVisual write FOnVisual;
    property OnWordPosition : TDirectSSWordPosition
             read FOnWordPosition write FOnWordPosition;
    property OnBookMark : TDirectSSBookMark read FOnBookMark write FOnBookMark;
    property OnTextDataStarted : TDirectSSTextDataStarted
             read FOnTextDataStarted write FOnTextDataStarted;
    property OnTextDataDone : TDirectSSTextDataDone
             read FOnTextDataDone write FOnTextDataDone;
    property OnActiveVoiceStartup : TDirectSSActiveVoiceStartup
             read FOnActiveVoiceStartup write FOnActiveVoiceStartup;
    property OnDebugging : TNotifyEvent read FOnDebugging write FOnDebugging;
    property OnError : TDirectSSError read FOnError write FOnError;
    property Onwarning : TDirectSSwarning read FOnwarning write FOnwarning;
    property OnVisualFuture : TDirectSSVisualFuture
             read FOnVisualFuture write FOnVisualFuture;
  end;

implementation

uses ComObj;

procedure TDirectSR.InitControlData;
const
  CEventDispIDs : array [0..17] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006,
    $00000007, $00000008, $00000009, $0000000A, $0000000B, $0000000C,
    $0000000D, $0000000E, $0000000F, $00000010, $00000011, $00000012);
  {$IFDEF Delphi5}
  CControlData : TControlData2 = (
    ClassID : '{4E3D9D1F-0C63-11D1-8BFB-0060081841DE}';
    EventIID : '{4E3D9D20-0C63-11D1-8BFB-0060081841DE}';
    EventCount : 18;
    EventDispIDs : @CEventDispIDs;
    LicenseKey : nil (*HR:$80004002*);
    Flags : $00000000;
    Version : 401);
  {$ELSE}
  CControlData : TControlData = (
    ClassID : '{4E3D9D1F-0C63-11D1-8BFB-0060081841DE}';
    EventIID : '{4E3D9D20-0C63-11D1-8BFB-0060081841DE}';
    EventCount : 18;
    EventDispIDs : @CEventDispIDs;
    LicenseKey : nil;
    Flags : $00000000;
    Version : 300);
  {$ENDIF}
begin
  ControlData := @CControlData;
  {$IFDEF Delphi5}
  TControlData2 (CControlData).FirstEventOfs := Cardinal (@@FOnClickIn) -
                                                Cardinal (Self);
  {$ENDIF}
end;

procedure TDirectSR.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown (OleObject) as IDirectSR;
  end;

begin
  if FIntf = nil then
    DoCreate;
end;

function TDirectSR.GetControlInterface : IDirectSR;
begin
  CreateControl;
  Result := FIntf;
end;

function TDirectSR.Get_Wave (results : Integer) : Integer;
begin
  Result := DefaultInterface.Wave[results];
end;

function TDirectSR.Get_Phrase (results : Integer; rank : Integer) : WideString;
begin
  Result := DefaultInterface.Phrase[results, rank];
end;

function TDirectSR.Get_CreateResultsObject (results : Integer) : Integer;
begin
  Result := DefaultInterface.CreateResultsObject[results];
end;

function TDirectSR.Get_FlagsGet (results : Integer; rank : Integer) : Integer;
begin
  Result := DefaultInterface.FlagsGet[results, rank];
end;

function TDirectSR.Get_Identify (results : Integer) : WideString;
begin
  Result := DefaultInterface.Identify[results];
end;

function TDirectSR.Get_ReEvaluate (results : Integer) : Integer;
begin
  Result := DefaultInterface.ReEvaluate[results];
end;

function TDirectSR.Get_GetPhraseScore (results : Integer;
                                       rank : Integer) : Integer;
begin
  Result := DefaultInterface.GetPhraseScore[results, rank];
end;

function TDirectSR.Get_GetAllArcStrings (punk : Integer;
                                         results : Integer) : WideString;
begin
  Result := DefaultInterface.GetAllArcStrings[punk, results];
end;

function TDirectSR.Get_Attributes (Attrib : Integer) : Integer;
begin
  Result := DefaultInterface.Attributes[Attrib];
end;

procedure TDirectSR.Set_Attributes (Attrib : Integer; pVal : Integer);
begin
  DefaultInterface.Attributes[Attrib] := pVal;
end;

function TDirectSR.Get_AttributeString (Attrib : Integer) : WideString;
begin
  Result := DefaultInterface.AttributeString[Attrib];
end;

procedure TDirectSR.Set_AttributeString (Attrib : Integer;
                                         const pVal : WideString);
  { Warning : The property AttributeString has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.AttributeString := pVal;
end;

function TDirectSR.Get_AttributeMemory (Attrib : Integer;
                                        var size : Integer) : Integer;
begin
  Result := DefaultInterface.AttributeMemory[Attrib, size];
end;

procedure TDirectSR.Set_AttributeMemory (Attrib : Integer;
                                         var size : Integer;
                                         pVal : Integer);
begin
  DefaultInterface.AttributeMemory[Attrib, size] := pVal;
end;

function TDirectSR.Get_WaveEx (results : Integer; beginhi : Integer;
                               beginlo : Integer; endhi : Integer;
                               endlo : Integer) : Integer;
begin
  Result := DefaultInterface.WaveEx[results, beginhi, beginlo, endhi, endlo];
end;

function TDirectSR.Get_NodeStart (results : Integer) : Integer;
begin
  Result := DefaultInterface.NodeStart[results];
end;

function TDirectSR.Get_NodeEnd (results : Integer) : Integer;
begin
  Result := DefaultInterface.NodeEnd[results];
end;

function TDirectSR.Get_DataGetString (results : Integer; id : Integer;
                                      const Attrib : WideString):
                                      WideString;
begin
  Result := DefaultInterface.DataGetString[results, id, Attrib];
end;

function TDirectSR.Get_score (results : Integer; scoretype : Integer;
                              var path : Integer; pathsteps : Integer;
                              pathindexstart : Integer;
                              pathindexcount : Integer) : Integer;
begin
  Result := DefaultInterface.score[results, scoretype, path, pathsteps,
                                   pathindexstart, pathindexcount];
end;

function TDirectSR.Get_NodeGet (results : Integer; arc : Integer;
                                destination : Integer) : Integer;
begin
  Result := DefaultInterface.NodeGet[results, arc, destination];
end;

function TDirectSR.Get_GraphDWORDGet (results : Integer; id : Integer;
                                      const Attrib : WideString):
                                      Integer;
begin
  Result := DefaultInterface.GraphDWORDGet[results, id, Attrib];
end;

function TDirectSR.Get_SpeakerInfoChanged (var filetimehi : Integer;
                                           var filetimelo : Integer):
                                           Integer;
begin
  Result := DefaultInterface.SpeakerInfoChanged[filetimehi, filetimelo];
end;

procedure TDirectSR.Deactivate;
begin
  DefaultInterface.Deactivate;
end;

procedure TDirectSR.Activate;
begin
  DefaultInterface.Activate;
end;

procedure TDirectSR.GrammarFromString (const grammar : WideString);
begin
  DefaultInterface.GrammarFromString (grammar);
end;

procedure TDirectSR.GrammarFromFile (const FileName : WideString);
begin
  DefaultInterface.GrammarFromFile (FileName);
end;

procedure TDirectSR.GrammarFromResource (Instance : Integer;
                                         ResID : Integer);
begin
  DefaultInterface.GrammarFromResource (Instance, ResID);
end;

procedure TDirectSR.GrammarFromStream (Stream : Integer);
begin
  DefaultInterface.GrammarFromStream (Stream);
end;

procedure TDirectSR.Pause;
begin
  DefaultInterface.Pause;
end;

procedure TDirectSR.Resume;
begin
  DefaultInterface.Resume;
end;

procedure TDirectSR.PosnGet (out hi : Integer; out lo : Integer);
begin
  DefaultInterface.PosnGet (hi, lo);
end;

procedure TDirectSR.AboutDlg (hwnd : Integer; const title : WideString);
begin
  DefaultInterface.AboutDlg (hwnd, title);
end;

procedure TDirectSR.GeneralDlg (hwnd : Integer; const title : WideString);
begin
  DefaultInterface.GeneralDlg (hwnd, title);
end;

procedure TDirectSR.LexiconDlg (hwnd : Integer; const title : WideString);
begin
  DefaultInterface.LexiconDlg (hwnd, title);
end;

procedure TDirectSR.TrainGeneralDlg (hwnd : Integer;
                                             const title : WideString);
begin
  DefaultInterface.TrainGeneralDlg (hwnd, title);
end;

procedure TDirectSR.TrainMicDlg (hwnd : Integer;
                                         const title : WideString);
begin
  DefaultInterface.TrainMicDlg (hwnd, title);
end;

procedure TDirectSR.DestroyResultsObject (resobj : Integer);
begin
  DefaultInterface.DestroyResultsObject (resobj);
end;

procedure TDirectSR.Select (index : Integer);
begin
  DefaultInterface.Select (index);
end;

procedure TDirectSR.Listen;
begin
  DefaultInterface.Listen;
end;

procedure TDirectSR.SelectEngine (index : SYSINT);
begin
  DefaultInterface.SelectEngine (index);
end;

function TDirectSR.FindEngine (const EngineId : WideString;
                               const MfgName : WideString;
                               const ProductName : WideString;
                               const ModeID : WideString;
                               const ModeName : WideString;
                               LanguageID : Integer;
                               const dialect : WideString;
                               Sequencing : Integer;
                               MaxWordsVocab : Integer;
                               MaxWordsState : Integer;
                               Grammars : Integer; Features : Integer;
                               Interfaces : Integer;
                               EngineFeatures : Integer;
                               RankEngineID : Integer;
                               RankMfgName : Integer;
                               RankProductName : Integer;
                               RankModeID : Integer;
                               RankModeName : Integer;
                               RankLanguage : Integer;
                               RankDialect : Integer;
                               RankSequencing : Integer;
                               RankMaxWordsVocab : Integer;
                               RankMaxWordsState : Integer;
                               RankGrammars : Integer;
                               RankFeatures : Integer;
                               RankInterfaces : Integer;
                               RankEngineFeatures : Integer) : Integer;
begin
  Result := DefaultInterface.FindEngine (EngineId, MfgName, ProductName, ModeID,
                                         ModeName, LanguageID, dialect,
                                         Sequencing, MaxWordsVocab,
                                         MaxWordsState, Grammars, Features,
                                         Interfaces, EngineFeatures,
                                         RankEngineID, RankMfgName,
                                         RankProductName, RankModeID,
                                         RankModeName, RankLanguage,
                                         RankDialect, RankSequencing,
                                         RankMaxWordsVocab, RankMaxWordsState,
                                         RankGrammars, RankFeatures,
                                         RankInterfaces, RankEngineFeatures);
end;

function TDirectSR.ModeName (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.ModeName (index);
end;

function TDirectSR.EngineId (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.EngineId (index);
end;

function TDirectSR.MfgName (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.MfgName (index);
end;

function TDirectSR.ProductName (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.ProductName (index);
end;

function TDirectSR.ModeID (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.ModeID (index);
end;

function TDirectSR.Features (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.Features (index);
end;

function TDirectSR.Interfaces (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.Interfaces (index);
end;

function TDirectSR.EngineFeatures (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.EngineFeatures (index);
end;

function TDirectSR.LanguageID (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.LanguageID (index);
end;

function TDirectSR.dialect (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.dialect (index);
end;

function TDirectSR.Sequencing (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.Sequencing (index);
end;

function TDirectSR.MaxWordsVocab (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.MaxWordsVocab (index);
end;

function TDirectSR.MaxWordsState (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.MaxWordsState (index);
end;

function TDirectSR.Grammars (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.Grammars (index);
end;

procedure TDirectSR.InitAudioSourceDirect (direct : Integer);
begin
  DefaultInterface.InitAudioSourceDirect (direct);
end;

procedure TDirectSR.InitAudioSourceObject (object_ : Integer);
begin
  DefaultInterface.InitAudioSourceObject (object_);
end;

procedure TDirectSR.TimeGet (results : Integer; var beginhi : Integer;
                             var beginlo : Integer; var endhi : Integer;
                             var endlo : Integer);
begin
  DefaultInterface.TimeGet (results, beginhi, beginlo, endhi, endlo);
end;

procedure TDirectSR.Correction (results : Integer;
                                const Phrase : WideString;
                                confidence : Smallint);
begin
  DefaultInterface.Correction (results, Phrase, confidence);
end;

procedure TDirectSR.Validate (results : Integer; confidence : Smallint);
begin
  DefaultInterface.Validate (results, confidence);
end;

procedure TDirectSR.Archive (keepresults : Integer; out size : Integer;
                             out pVal : Integer);
begin
  DefaultInterface.Archive (keepresults, size, pVal);
end;

procedure TDirectSR.DeleteArchive (Archive : Integer);
begin
  DefaultInterface.DeleteArchive (Archive);
end;

procedure TDirectSR.GrammarFromMemory (grammar : Integer; size : Integer);
begin
  DefaultInterface.GrammarFromMemory (grammar, size);
end;

procedure TDirectSR.GrammarDataSet (Data : Integer; size : Integer);
begin
  DefaultInterface.GrammarDataSet (Data, size);
end;

procedure TDirectSR.GrammarToMemory (var grammar : Integer;
                                     var size : Integer);
begin
  DefaultInterface.GrammarToMemory (grammar, size);
end;

procedure TDirectSR.ActivateAndAssignWindow (hwnd : Integer);
begin
  DefaultInterface.ActivateAndAssignWindow (hwnd);
end;

function TDirectSR.Find (const RankList : WideString) : Integer;
begin
  Result := DefaultInterface.Find (RankList);
end;

procedure TDirectSR.ArcEnum (results : Integer; node : Integer;
                             Outgoing : Integer; var nodelist : Integer;
                             var countnodes : Integer);
begin
  DefaultInterface.ArcEnum (results, node, Outgoing, nodelist, countnodes);
end;

procedure TDirectSR.BestPathEnum (results : Integer; rank : Integer;
                                  var startpath : Integer;
                                  startpathsteps : Integer;
                                  var endpath : Integer;
                                  endpathsteps : Integer;
                                  exactmatch : Integer;
                                  var arclist : Integer;
                                  var arccount : Integer);
begin
  DefaultInterface.BestPathEnum (results, rank, startpath, startpathsteps,
                                 endpath, endpathsteps, exactmatch, arclist,
                                 arccount);
end;

procedure TDirectSR.DataGetTime (results : Integer; id : Integer;
                                 const Attrib : WideString;
                                 var hi : Integer; var lo : Integer);
begin
  DefaultInterface.DataGetTime (results, id, Attrib, hi, lo);
end;

procedure TDirectSR.GetAllArcs (results : Integer; var arcids : Integer;
                                var arccount : Integer);
begin
  DefaultInterface.GetAllArcs (results, arcids, arccount);
end;

procedure TDirectSR.GetAllNodes (results : Integer; var Nodes : Integer;
                                 var countnodes : Integer);
begin
  DefaultInterface.GetAllNodes (results, Nodes, countnodes);
end;

procedure TDirectSR.RenameSpeaker (const OldName : WideString;
                                   const newName : WideString);
begin
  DefaultInterface.RenameSpeaker (OldName, newName);
end;

procedure TDirectSR.DeleteSpeaker (const Speaker : WideString);
begin
  DefaultInterface.DeleteSpeaker (Speaker);
end;

procedure TDirectSR.CommitSpeaker;
begin
  DefaultInterface.CommitSpeaker;
end;

procedure TDirectSR.RevertSpeaker (const Speaker : WideString);
begin
  DefaultInterface.RevertSpeaker (Speaker);
end;

procedure TDirectSR.TrainPhrasesDlg (hwnd : Integer;
                                     const title : WideString);
begin
  DefaultInterface.TrainPhrasesDlg (hwnd, title);
end;

procedure TDirectSR.LexAddTo (lex : LongWord; charset : Integer;
                              const text : WideString;
                              const pronounce : WideString;
                              partofspeech : Integer;
                              EngineInfo : Integer;
                              engineinfosize : Integer);
begin
  DefaultInterface.LexAddTo (lex, charset, text, pronounce, partofspeech,
                             EngineInfo, engineinfosize);
end;

procedure TDirectSR.LexGetFrom (lex : Integer; charset : Integer;
                                const text : WideString; sense : Integer;
                                var pronounce : WideString;
                                var partofspeech : Integer;
                                var EngineInfo : Integer;
                                var sizeofengineinfo : Integer);
begin
  DefaultInterface.LexGetFrom (lex, charset, text, sense, pronounce,
                               partofspeech, EngineInfo, sizeofengineinfo);
end;

procedure TDirectSR.LexRemoveFrom (lex : Integer; const text : WideString;
                                   sense : Integer);
begin
  DefaultInterface.LexRemoveFrom (lex, text, sense);
end;

procedure TDirectSR.QueryLexicons (f : Integer; var pdw : Integer);
begin
  DefaultInterface.QueryLexicons (f, pdw);
end;

procedure TDirectSR.ChangeSpelling (lex : Integer;
                                    const stringa : WideString;
                                    const stringb : WideString);
begin
  DefaultInterface.ChangeSpelling (lex, stringa, stringb);
end;


constructor TDirectSS.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);
end;

procedure TDirectSS.InitControlData;
const
  CEventDispIDs : array [0..14] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006,
    $00000007, $00000008, $00000009, $0000000A, $0000000B, $0000000C,
    $0000000D, $0000000E, $0000000F);
  {$IFDEF Delphi5}
  CControlData : TControlData2 = (
    ClassID : '{EEE78591-FE22-11D0-8BEF-0060081841DE}';
    EventIID : '{EEE78597-FE22-11D0-8BEF-0060081841DE}';
    EventCount : 15;
    EventDispIDs : @CEventDispIDs;
    LicenseKey : nil (*HR:$80004002*);
    Flags : $00000000;
    Version : 401);
  {$ELSE}
  CControlData : TControlData = (
    ClassID : '{EEE78591-FE22-11D0-8BEF-0060081841DE}';
    EventIID : '{EEE78597-FE22-11D0-8BEF-0060081841DE}';
    EventCount : 15;
    EventDispIDs : @CEventDispIDs;
    LicenseKey : nil;
    Flags : $00000000;
    Version : 300);
  {$ENDIF}
begin
  ControlData := @CControlData;
  {$IFDEF Delphi5}
  TControlData2 (CControlData).FirstEventOfs := Cardinal (@@FOnClickIn) -
                                                Cardinal (Self);
  {$ENDIF}
end;

procedure TDirectSS.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown (OleObject) as IDirectSS;
  end;

begin
  if FIntf = nil then
    DoCreate;
end;

function TDirectSS.GetControlInterface : IDirectSS;
begin
  CreateControl;
  Result := FIntf;
end;

function TDirectSS.Get_Attributes (Attrib : Integer) : Integer;
begin
  Result := DefaultInterface.Attributes[Attrib];
end;

procedure TDirectSS.Set_Attributes (Attrib : Integer; pVal : Integer);
begin
  DefaultInterface.Attributes[Attrib] := pVal;
end;

function TDirectSS.Get_AttributeString (Attrib : Integer) : WideString;
begin
  Result := DefaultInterface.AttributeString[Attrib];
end;

procedure TDirectSS.Set_AttributeString (Attrib : Integer;
                                         const pVal : WideString);
  { Warning : The property AttributeString has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.AttributeString := pVal;
end;

function TDirectSS.Get_AttributeMemory (Attrib : Integer;
                                        var size : Integer) : Integer;
begin
  Result := DefaultInterface.AttributeMemory[Attrib, size];
end;

procedure TDirectSS.Set_AttributeMemory (Attrib : Integer;
                                         var size : Integer;
                                         pVal : Integer);
begin
  DefaultInterface.AttributeMemory[Attrib, size] := pVal;
end;

procedure TDirectSS.Speak (const text : WideString);
begin
  DefaultInterface.Speak (text);
end;

procedure TDirectSS.Select (index : SYSINT);
begin
  DefaultInterface.Select (index);
end;

function TDirectSS.EngineID (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.EngineID (index);
end;

function TDirectSS.ModeName (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.ModeName (index);
end;

function TDirectSS.MfgName (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.MfgName (index);
end;

function TDirectSS.ProductName (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.ProductName (index);
end;

function TDirectSS.ModeID (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.ModeID (index);
end;

function TDirectSS.Speaker (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.Speaker (index);
end;

function TDirectSS.Style (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.Style (index);
end;

function TDirectSS.Gender (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.Gender (index);
end;

function TDirectSS.Age (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.Age (index);
end;

function TDirectSS.Features (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.Features (index);
end;

function TDirectSS.Interfaces (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.Interfaces (index);
end;

function TDirectSS.EngineFeatures (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.EngineFeatures (index);
end;

function TDirectSS.LanguageID (index : SYSINT) : Integer;
begin
  Result := DefaultInterface.LanguageID (index);
end;

function TDirectSS.Dialect (index : SYSINT) : WideString;
begin
  Result := DefaultInterface.Dialect (index);
end;

procedure TDirectSS.AudioPause;
begin
  DefaultInterface.AudioPause;
end;

procedure TDirectSS.AudioReset;
begin
  DefaultInterface.AudioReset;
end;

procedure TDirectSS.AudioResume;
begin
  DefaultInterface.AudioResume;
end;

procedure TDirectSS.Inject (const value : WideString);
begin
  DefaultInterface.Inject (value);
end;

function TDirectSS.Phonemes (charset : Integer; Flags : Integer;
                             const input : WideString) : WideString;
begin
  Result := DefaultInterface.Phonemes (charset, Flags, input);
end;

procedure TDirectSS.PosnGet (var hi : Integer; var lo : Integer);
begin
  DefaultInterface.PosnGet (hi, lo);
end;

procedure TDirectSS.TextData (characterset : Integer; Flags : Integer;
                              const text : WideString);
begin
  DefaultInterface.TextData (characterset, Flags, text);
end;

procedure TDirectSS.InitAudioDestMM (deviceid : Integer);
begin
  DefaultInterface.InitAudioDestMM (deviceid);
end;

procedure TDirectSS.AboutDlg (hWnd : Integer; const title : WideString);
begin
  DefaultInterface.AboutDlg (hWnd, title);
end;

procedure TDirectSS.GeneralDlg (hWnd : Integer; const title : WideString);
begin
  DefaultInterface.GeneralDlg (hWnd, title);
end;

procedure TDirectSS.LexiconDlg (hWnd : Integer; const title : WideString);
begin
  DefaultInterface.LexiconDlg (hWnd, title);
end;

procedure TDirectSS.TranslateDlg (hWnd : Integer;
                                  const title : WideString);
begin
  DefaultInterface.TranslateDlg (hWnd, title);
end;

function TDirectSS.FindEngine (const EngineID : WideString;
                               const MfgName : WideString;
                               const ProductName : WideString;
                               const ModeID : WideString;
                               const ModeName : WideString;
                               LanguageID : Integer;
                               const Dialect : WideString;
                               const Speaker : WideString;
                               const Style : WideString;
                               Gender : Integer; Age : Integer;
                               Features : Integer; Interfaces : Integer;
                               EngineFeatures : Integer;
                               RankEngineID : Integer;
                               RankMfgName : Integer;
                               RankProductName : Integer;
                               RankModeID : Integer;
                               RankModeName : Integer;
                               RankLanguage : Integer;
                               RankDialect : Integer;
                               RankSpeaker : Integer;
                               RankStyle : Integer; RankGender : Integer;
                               RankAge : Integer; RankFeatures : Integer;
                               RankInterfaces : Integer;
                               RankEngineFeatures : Integer) : Integer;
begin
  Result := DefaultInterface.FindEngine (EngineID, MfgName, ProductName, ModeID,
                                         ModeName, LanguageID, Dialect, Speaker,
                                         Style, Gender, Age, Features,
                                         Interfaces, EngineFeatures,
                                         RankEngineID, RankMfgName,
                                         RankProductName, RankModeID,
                                         RankModeName, RankLanguage,
                                         RankDialect, RankSpeaker, RankStyle,
                                         RankGender, RankAge, RankFeatures,
                                         RankInterfaces, RankEngineFeatures);
end;

procedure TDirectSS.GetPronunciation (charset : Integer;
                                      const text : WideString;
                                      Sense : Integer;
                                      var Pronounce : WideString;
                                      var PartOfSpeech : Integer;
                                      var EngineInfo : WideString);
begin
  DefaultInterface.GetPronunciation (charset, text, Sense, Pronounce,
                                     PartOfSpeech, EngineInfo);
end;

procedure TDirectSS.InitAudioDestDirect (direct : Integer);
begin
  DefaultInterface.InitAudioDestDirect (direct);
end;

procedure TDirectSS.InitAudioDestObject (object_ : Integer);
begin
  DefaultInterface.InitAudioDestObject (object_);
end;

function TDirectSS.Find (const RankList : WideString) : Integer;
begin
  Result := DefaultInterface.Find (RankList);
end;

procedure TDirectSS.LexAddTo (lex : LongWord; charset : Integer;
                              const text : WideString;
                              const Pronounce : WideString;
                              PartOfSpeech : Integer;
                              EngineInfo : Integer;
                              engineinfosize : Integer);
begin
  DefaultInterface.LexAddTo (lex, charset, text, Pronounce, PartOfSpeech,
                             EngineInfo, engineinfosize);
end;

procedure TDirectSS.LexGetFrom (lex : Integer; charset : Integer;
                                const text : WideString; Sense : Integer;
                                var Pronounce : WideString;
                                var PartOfSpeech : Integer;
                                var EngineInfo : Integer;
                                var sizeofengineinfo : Integer);
begin
  DefaultInterface.LexGetFrom (lex, charset, text, Sense, Pronounce,
                               PartOfSpeech, EngineInfo, sizeofengineinfo);
end;

procedure TDirectSS.LexRemoveFrom (lex : Integer; const text : WideString;
                                   Sense : Integer);
begin
  DefaultInterface.LexRemoveFrom (lex, text, Sense);
end;

procedure TDirectSS.QueryLexicons (f : Integer; var pdw : Integer);
begin
  DefaultInterface.QueryLexicons (f, pdw);
end;

procedure TDirectSS.ChangeSpelling (lex : Integer;
                                    const stringa : WideString;
                                    const stringb : WideString);
begin
  DefaultInterface.ChangeSpelling (lex, stringa, stringb);
end;                                

end.



