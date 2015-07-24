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
 *   Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADSAPIPH.PAS 4.06                   *}
{*********************************************************}
{* TApdSAPIPhone component                               *}
{*********************************************************}

{
  The TApdSapiPhone component descends directly from the TApdTapiDevice,
  so it has similar characteristics. The differences are in the phone prompts,
  and the redirection of the audio streams to/from a TApdSapiEngine.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdSapiPh;

interface

uses
  Windows,
  Messages,
  Classes,
  SysUtils,
  MMSystem,
  INIFiles,
  OoMisc,
  AdSapiEn,
  AdTUtil,
  AdTapi,
  AdSapiGr,
  AdISapi,
  DateUtils,
  Variants,
  ActiveX,
  ComObj,
  Dialogs;

const
  ApdSapiAskOperator = WPARAM(-3);
  ApdSapiAskHangUp = WPARAM(-4);
  ApdSapiAskBack = WPARAM(-5);
  ApdSapiAskWhere = WPARAM(-10);
  ApdSapiAskHelp = WPARAM(-11);
  ApdSapiAskRepeat = WPARAM(12);
  ApdSapiAskSpeakFaster = WPARAM(13);
  ApdSapiAskSpeakSlower = WPARAM(-14);
  ApdSapiAbort = WPARAM(-98);
  ApdSapiTimeout = WPARAM(-99);

  ApdSapiSpeedChange = 25;

  ApdSapiConnect    = 1;
  ApdSapiDisConnect = 2;

  { Replies from the Ask... controls }

  { Replies that are normally not handled by the control }
  ApdTCR_ABORT          = -1;
  ApdTCR_NORESPONSE     = -2;
  ApdTCR_ASKOPERATOR    = -3;
  ApdTCR_ASKHANGUP      = -4;
  ApdTCR_ASKBACK        = -5;
  { Replies that are normally handled by the control }
  ApdTCR_ASKWHERE       = -10;
  ApdTCR_ASKHELP        = -11;
  ApdTCR_ASKREPEAT      = -12;
  ApdTCR_ASKSPEAKFASTER = -13;
  ApdTCR_ASKSPEAKSLOWER = -14;

type


  TApdSapiPhoneSettings = set of (psVerify, psCanGoBack,
                                  psDisableSpeedChange, psEnableOperator,
                                  psEnableAskHangup);
  TApdSapiPhoneReply = (prOk, prAbort, prNoResponse, prOperator, prHangUp,
                        prBack, prWhere, prHelp, prRepeat, prSpeakFaster,
                        prSpeakSlower, prCheck, prError, prUnknown);
  TApdPhraseType = (ptHelp, ptBack, ptOperator, ptHangup, ptRepeat,
                    ptWhere, ptSpeakFaster, ptSpeakSlower, ptUnknown,
                    ptNone, ptCustom, ptAbort, ptTimeout);

  TGrammarStringHandler = (gshIgnore, gshInsert, gshAutoReplace);

  TApdSapiPhoneEvent = procedure (Sender : TObject) of object;
  TApdOnAskForStringFinish = procedure (Sender : TObject;
                                        Reply : TApdSapiPhoneReply;
                                        Data : string;
                                        SpokenData : string) of object;
  TApdOnAskForDateTimeFinish = procedure (Sender : TObject;
                                          Reply : TApdSapiPhoneReply;
                                          Data : TDateTime;
                                          SpokenData : string) of object;
  TApdOnAskForIntegerFinish = procedure (Sender : TObject;
                                         Reply : TApdSapiPhoneReply;
                                         Data : Integer;
                                         SpokenData : string) of object;
  TApdOnAskForBooleanFinish = procedure (Sender : TObject;
                                         Reply : TApdSapiPhoneReply;
                                         Data : Boolean;
                                         SpokenData : string) of object;

  { Internal event to parse custom responses spoken by the user }
  TApdCustomDataHandler = procedure (LastReply : TApdPhraseType;
                                     LastRule : Integer;
                                     LastPhrase : string) of object;
  { Internal event to trigger the OnAskFor...Finish event }
  TApdAskForEventTrigger = procedure (Reply : TApdSapiPhoneReply;
                                      Data : Pointer;
                                      SpokenData : string) of object;

  ESapiPhoneError = class (EApdSapiEngineException);

  TApdSapiGrammarList = class (TStringList)
    private
    protected
    public
      procedure ReadSectionValues (Section : string; List : TStringList);
      function SectionExists (Section : string) : Boolean;
    published
  end;

  TApdSapiPhonePrompts = class (TPersistent)
    private
      FAskAreaCode    : string;
      FAskLastFour    : string;
      FAskNextThree   : string;
      FCannotGoBack   : string;
      FCannotHangUp   : string;
      FGoingBack      : string;
      FHangingUp      : string;
      FHelp           : string;
      FHelp2          : string;
      FHelpVerify     : string;
      FMain           : string;
      FMain2          : string;
      FMaxSpeed       : string;
      FMinSpeed       : string;
      FOperator       : string;
      FNoOperator     : string;
      FNoSpeedChange  : string;
      FSpeakingFaster : string;
      FSpeakingSlower : string;
      FTooFewDigits   : string;
      FTooManyDigits  : string;
      FUnrecognized   : string;
      FVerifyPost     : string;
      FVerifyPre      : string;
      FWhere          : string;
      FWhere2         : string;

    protected
      procedure SetAskAreaCode (v : string);
      procedure SetAskLastFour (v : string);
      procedure SetAskNextThree (v : string);
      procedure SetCannotGoBack (v : string);
      procedure SetCannotHangUp (v : string);
      procedure SetGoingBack (v : string);
      procedure SetHangingUp (v : string);
      procedure SetHelp (v : string);
      procedure SetHelp2 (v : string);
      procedure SetHelpVerify (v : string);
      procedure SetMain (v : string);
      procedure SetMain2 (v : string);
      procedure SetMaxSpeed (v : string);
      procedure SetMinSpeed (v : string);
      procedure SetOperator (v : string);
      procedure SetNoOperator (v : string);
      procedure SetNoSpeedChange (v : string);
      procedure SetSpeakingFaster (v : string);
      procedure SetSpeakingSlower (v : string);
      procedure SetTooFewDigits (v : string);
      procedure SetTooManyDigits (v : string);
      procedure SetUnrecognized (v : string);
      procedure SetVerifyPost (v : string);
      procedure SetVerifyPre (v : string);
      procedure SetWhere (v : string);
      procedure SetWhere2 (v : string);

    public
      constructor Create; 

      function GenerateGrammar (NewPrompt1 : string; NewPrompt2 : string;
                                NewHelp1 : string; NewHelp2 : string;
                                NewWhere1 : string;
                                NewWhere2 : string) : string;
      function GenerateExtensionGrammar (NewTooFewDigits : string;
                                         NewTooManyDigits : string) : string;
      function GeneratePhoneNumberGrammar (NewAskAreaCode : string;
                                           NewAskNextThree : string;
                                           NewAskLastFour : string) : string;

    published
      property AskAreaCode : string read FAskAreaCode write SetAskAreaCode;
      property AskLastFour : string read FAskLastFour write SetAskLastFour;
      property AskNextThree : string read FAskNextThree write SetAskNextThree;
      property CannotGoBack : string read FCannotGoBack write SetCannotGoBack;
      property CannotHangUp : string read FCannotHangUp write SetCannotHangUp;
      property HangingUp : string read FHangingUp write SetHangingUp;
      property Help : string read FHelp write SetHelp;
      property Help2 : string read FHelp2 write SetHelp2;
      property HelpVerify : string read FHelPVerify write SetHelpVerify;
      property GoingBack : string read FGoingBack write SetGoingBack;
      property Main : string read FMain write SetMain;
      property Main2 : string read FMain2 write SetMain2;
      property MaxSpeed : string read FMaxSpeed write SetMaxSpeed;
      property MinSpeed : string read FMinSpeed write SetMinSpeed;
      property Operator : string read FOperator write SetOperator;
      property NoOperator : string read FNoOperator write SetNoOperator;
      property NoSpeedChange : string
               read FNoSpeedChange write SetNoSpeedChange;
      property SpeakingFaster : string
               read FSpeakingFaster write SetSpeakingFaster;
      property SpeakingSlower : string
               read FSpeakingSlower write SetSpeakingSlower;
      property TooFewDigits : string read FTooFewDigits write SetTooFewDigits;
      property TooManyDigits : string
               read FTooManyDigits write SetTooManyDigits;
      property Unrecognized : string read FUnrecognized write SetUnRecognized;
      property VerifyPost : string read FVerifyPost write SetVerifyPost;
      property VerifyPre : string read FVerifyPre write SetVerifyPre;
      property Where : string read FWhere write SetWhere;
      property Where2 : string read FWhere2 write SetWhere2;
  end;

  { TApdSapiAskForInfo handles the actual work of asking the user for a
    response.  This handles getting help, repeating prompts and related
    items }

{$M+}
  TApdSapiAskForInfo = class (TObject)
    private
      FReplyHandle   : THandle;
      FPrompts       : TApdSapiPhonePrompts;
      FSapiEngine    : TApdCustomSapiEngine;
      FAskForGrammar : TStringList;
      FMainGrammar   : TStringList;
      FOptions       : TApdSapiPhoneSettings;
      FStringHandler : TGrammarStringHandler;

    protected
      function DeterminePhraseTypeEx (Phrase : string;
                                      var Rule : string) : TApdPhraseType;
      function IsAnglePhrase (Phrase : string) : Boolean;
      function IsParenPhrase (Phrase : string) : Boolean;
      function IsQuoted (Phrase : string) : Boolean;
      function KillQuotes (Phrase : string) : string;
      function GetValue (Value : string) : string;
      function GetKey (Value : string) : string;
      function AnalyzeRule (Tokens : TStringList; CurrentRule : string;
                            INIFile : TApdSapiGrammarList;
                            CurrentSection : TStringList;
                            var CurrentWord : Integer;
                            var MatchingKey : string
                            ) : Boolean;
      function RecurseRules (Tokens : TStringList;
                             INIFile : TApdSapiGrammarList;
                             CurrentSection : string;
                             var CurrentWord : Integer;
                             var MatchingKey : string
                             ) : Boolean;
      function LocateRule (Tokens : TStringList) : string;
      procedure InitializeMainGrammar;
      procedure SapiPhraseFinishHook (Sender : TObject; Phrase : string;
                                      Results : Integer); virtual;
      procedure SetAskForGrammar (v : TStringList);
      procedure SetMainGrammar (v : TStringList);
      procedure SetOptions (v : TApdSapiPhoneSettings);
      procedure SetReplyHandle (v : THandle);

    public
      constructor Create;
      destructor Destroy; override;

      procedure AskFor;
      function DeterminePhraseType (Phrase : string) : TApdPhraseType;
      function FindGrammarRule (var Phrase : string) : string;

    published
      property AskForGrammar : TStringList
               read FAskForGrammar write SetAskForGrammar;
      property MainGrammar : TStringList
               read FMainGrammar write SetMainGrammar;
      property Options : TApdSapiPhoneSettings read FOptions write SetOptions;
      property Prompts : TApdSapiPhonePrompts read FPrompts write FPrompts;
      property ReplyHandle : THandle read FReplyHandle write SetReplyHandle;
      property SapiEngine : TApdCustomSapiEngine
               read FSapiEngine write FSapiEngine;
  end;
{$M-}

  TApdCustomSapiPhone = class (TApdCustomTapiDevice)
    private
      FSapiEngine                : TApdCustomSapiEngine;
      IAMM                       : IAudioMultiMediaDevice;
      IAT                        : IAudioTel;

      FNumDigits                 : Integer;
      FNoAnswerMax               : Integer;
      FNoAnswerTime              : Integer;
      FOptions                   : TApdSapiPhoneSettings;
      FInAskFor                  : Boolean;
      FSpellingEchoBack          : Boolean;

      FPrompts                   : TApdSapiPhonePrompts;
      FInfo                      : TApdSapiAskForInfo;

      FExtension                 : string;
      FDigitCount                : Integer;
      FSpelledWord               : string;
      FList                      : TStringList;

      FCustomDataHandler         : TApdCustomDataHandler;
      FEventTrigger              : TApdAskForEventTrigger;

      FOnAskForDateFinish        : TApdOnAskForDateTimeFinish;
      FOnAskForExtensionFinish   : TApdOnAskForStringFinish;
      FOnAskForListFinish        : TApdOnAskForIntegerFinish;
      FOnAskForPhoneNumberFinish : TApdOnAskForStringFinish;
      FOnAskForSpellingFinish    : TApdOnAskForStringFinish;
      FOnAskForTimeFinish        : TApdOnAskForDateTimeFinish;
      FOnAskForYesNoFinish       : TApdOnAskForBooleanFinish;
      FOnTapiDisconnect          : TNotifyEvent;

    protected
      procedure AskForDateDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
      procedure AskForExtensionDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
      procedure AskForListDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
      procedure AskForPhoneNumberDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
      procedure AskForSpellingDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
      procedure AskForTimeDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
      procedure AskForYesNoDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);

      procedure AskForDateTrigger (Reply : TApdSapiPhoneReply;
                                   Data : Pointer;
                                   SpokenData : string);
      procedure AskForExtensionTrigger (Reply : TApdSapiPhoneReply;
                                        Data : Pointer;
                                        SpokenData : string);
      procedure AskForListTrigger (Reply : TApdSapiPhoneReply;
                                   Data : Pointer;
                                   SpokenData : string);
      procedure AskForPhoneNumberTrigger (Reply : TApdSapiPhoneReply;
                                          Data : Pointer;
                                          SpokenData : string);
      procedure AskForSpellingTrigger (Reply : TApdSapiPhoneReply;
                                       Data : Pointer;
                                       SpokenData : string);
      procedure AskForTimeTrigger (Reply : TApdSapiPhoneReply;
                                   Data : Pointer;
                                   SpokenData : string);
      procedure AskForYesNoTrigger (Reply : TApdSapiPhoneReply;
                                    Data : Pointer;
                                    SpokenData : string);

      function ConvertResponse (RCode : Integer ) : TApdSapiPhoneReply;
      procedure DoLineCallState (Device, P1, P2, P3 : Integer); override;
      procedure ExitAskFor (Reply : TApdSapiPhoneReply;
                            Data : Pointer;
                            SpokenData : string);
      function GetPhraseData (LParam : Integer) : string;
      function FixNumerics (Phrase : string) : string;
      function InterpretDate (Phrase : string;
                              var Trusted : Boolean) : TDateTime; virtual;
      function InterpretPhoneNumber (Phrase : string) : string;
      function InterpretTime (Phrase : string) : TDateTime; virtual;
      procedure Notification(AComponent : TComponent; Operation: TOperation);
                override;
      procedure PhraseHandler (var Msg : TMessage); message apw_SapiInfoPhrase;
      procedure SapiPhoneCallback (var Msg : TMessage);
                message apw_SapiPhoneCallBack;
      procedure SetNoAnswerMax (v : Integer);
      procedure SetNoAnswerTime (v : Integer);
      procedure SetNumDigits (v : Integer);
      procedure SetOptions (v : TApdSapiPhoneSettings);
      procedure SetSpellingEchoBack (v : Boolean);
      procedure UpdateStateMachine (LastReply : TApdPhraseType;
                                    LastRule : Integer;
                                    LastPhrase : string);

    public
      constructor Create (AOwner : TComponent); override;
      destructor Destroy; override;

      procedure AbortAskFor;
      procedure AskForDate (NewPrompt1 : string);
      procedure AskForDateEx (NewPrompt1 : string; NewPrompt2 : string;
                              NewHelp1 : string; NewHelp2 : string;
                              NewWhere1 : string;
                              NewWhere2 : string);
      procedure AskForExtension (NewPrompt1 : string);
      procedure AskForExtensionEx (NewPrompt1 : string; NewPrompt2 : string;
                                   NewTooManyDigits : string;
                                   NewTooFewDigits : string;
                                   NewNumDigits : Integer;
                                   NewHelp1 : string;
                                   NewHelp2 : string;
                                   NewWhere1 : string;
                                   NewWhere2 : string);
      procedure AskForList (List : TStringList;
                           NewPrompt1 : string);
      procedure AskForListEx (List : TStringList;
                              NewPrompt1 : string; NewPrompt2 : string;
                              NewHelp1 : string; NewHelp2 : string;
                              NewWhere1 : string;
                              NewWhere2 : string);
      procedure AskForPhoneNumber (NewPrompt1 : string);
      procedure AskForPhoneNumberEx (NewPrompt1 : string;
                                     NewPrompt2 : string;
                                     NewAskAreaCode : string;
                                     NewAskNextThree : string;
                                     NewAskLastFour : string;
                                     NewHelp1 : string;
                                     NewHelp2 : string;
                                     NewWhere1 : string;
                                     NewWhere2 : string);
      procedure AskForSpelling (NewPrompt1 : string);
      procedure AskForSpellingEx (NewPrompt1 : string;
                                  NewPrompt2 : string;
                                  NewHelp1 : string;
                                  NewHelp2 : string;
                                  NewWhere1 : string;
                                  NewWhere2 : string);
      procedure AskForTime (NewPrompt1 : string);
      procedure AskForTimeEx (NewPrompt1 : string; NewPrompt2 : string;
                              NewHelp1 : string; NewHelp2 : string;
                              NewWhere1 : string;
                              NewWhere2 : string);
      procedure AskForYesNo (NewPrompt1 : string);
      procedure AskForYesNoEx (NewPrompt1 : string;
                               NewPrompt2 : string;
                               NewHelp1 : string; NewHelp2 : string;
                               NewWhere1 : string;
                               NewWhere2 : string);
      procedure SetDefaultPrompts (NewPrompt1 : string; NewPrompt2 : string;
                                   NewHelp1 : string; NewHelp2 : string;
                                   NewWhere1 : string; NewWhere2 : string);
      procedure Speak (const Text : string);

      property Prompts : TApdSapiPhonePrompts read FPrompts write FPrompts;

    published
      property NoAnswerMax : Integer read FNoAnswerMax write SetNoAnswerMax;
      property NoAnswerTime : Integer read FNoAnswerTime write SetNoAnswerTime;
      property NumDigits : Integer read FNumDigits write SetNumDigits;
      property Options : TApdSapiPhoneSettings read FOptions write SetOptions;
      property SapiEngine : TApdCustomSapiEngine
               read FSapiEngine write FSapiEngine;
      property SpellingEchoBack : Boolean
               read FSpellingEchoBack write SetSpellingEchoBack default True;

      property OnAskForDateFinish : TApdOnAskForDateTimeFinish
               read FOnAskForDateFinish write FOnAskForDateFinish;
      property OnAskForExtensionFinish : TApdOnAskForStringFinish
               read FOnAskForExtensionFinish write FOnAskForExtensionFinish;
      property OnAskForListFinish : TApdOnAskForIntegerFinish
               read FOnAskForListFinish write FOnAskForListFinish;
      property OnAskForPhoneNumberFinish : TApdOnAskForStringFinish
               read FOnAskForPhoneNumberFinish
               write FOnAskForPhoneNumberFinish;
      property OnAskForSpellingFinish : TApdOnAskForStringFinish
               read FOnAskForSpellingFinish write FOnAskFOrSpellingFinish;
      property OnAskForTimeFinish : TApdOnAskForDateTimeFinish
               read FOnAskForTimeFinish write FOnAskForTimeFinish;
      property OnAskForYesNoFinish : TApdOnAskForBooleanFinish
               read FOnAskForYesNoFinish write FOnAskForYesNoFinish;
      property OnTapiDisconnect : TNotifyEvent
               read FOnTapiDisconnect write FOnTapiDisconnect;
      {properties}
      property SelectedDevice;
      property ComPort;
      property StatusDisplay;
      property TapiLog;
      property AnswerOnRing;
      property RetryWait;
      property MaxAttempts;
      property ShowTapiDevices;
      property ShowPorts;
      property EnableVoice;
      property FilterUnsupportedDevices;

      {events}
      property OnTapiStatus;
      property OnTapiLog;
      property OnTapiPortOpen;
      property OnTapiPortClose;
      property OnTapiConnect;
      property OnTapiFail;
      property OnTapiDTMF;
      property OnTapiCallerID;
      property OnTapiWaveNotify;
      property OnTapiWaveSilence;

  end;

  TApdSapiPhone = class (TApdCustomSapiPhone)
    private
    protected
    public
    published
      property NoAnswerMax;
      property NoAnswerTime;
      property NumDigits;
      property Options;
      property SapiEngine;

      {properties}
      property SelectedDevice;
      property ComPort;
      property StatusDisplay;
      property TapiLog;
      property AnswerOnRing;
      property RetryWait;
      property MaxAttempts;
      property ShowTapiDevices;
      property ShowPorts;
      property EnableVoice;
      property FilterUnsupportedDevices;                               

      {events}
      property OnTapiStatus;
      property OnTapiLog;
      property OnTapiPortOpen;
      property OnTapiPortClose;
      property OnTapiConnect;
      property OnTapiFail;
      property OnTapiDTMF;
      property OnTapiCallerID;
      property OnTapiWaveNotify;
      property OnTapiWaveSilence;
  end;

implementation

procedure TokenizePhrase (Phrase : string;
                                             Tokens : TStringList);
{ Tokenizes a series of words into a TStringList }

  procedure AddWord (Tokens : TStringList; var NewWord : ShortString);
  begin
    if NewWord <> '' then
      Tokens.Add (string(NewWord));
    NewWord := '';
  end;
  
type
  TParseState = (psColChars, psColSpace, psInQuote);
  
var
  State      : TParseState;
  i          : Integer;
  PhraseLen  : Integer;
  WorkString : ShortString;

begin
  Tokens.Clear;
  i := 1;
  WorkString := '';
  State := psColChars;
  PhraseLen := Length (Phrase);
  while i <= PhraseLen do begin
    case State of
      psColChars :
        if Phrase[i] = ' ' then begin
          State := psColSpace;
          AddWord (Tokens, WorkString);
        end else if Phrase[i] = '"' then begin
          State := psInQuote;
          AddWord (Tokens, WorkString);
          WorkString := WorkString + ShortString(Phrase[i]);
        end else
          WorkString := WorkString + ShortString(Phrase[i]);
      psColSpace :
        if Phrase[i] = '"' then begin
          State := psInQuote;
          WorkString := WorkString + ShortString(Phrase[i]);
        end else if Phrase[i] <> ' ' then begin
          WorkString := WorkString + ShortString(Phrase[i]);
          State := psColChars;
        end;
      psInQuote :
        if Phrase[i] = '"' then begin
          WorkString := WorkString + ShortString(Phrase[i]);
          AddWord (Tokens, WorkString);
          State := psColChars;
        end else
          WorkString := WorkString + ShortString(Phrase[i]);
    end;
    Inc (i);
  end;
  if PhraseLen > 1 then begin
    if (WorkString[1] = '"') and (WorkString[PhraseLen] <> '"') then
      WorkString := WorkString + '"';
  end;
  AddWord (Tokens, WorkString);
end;

{ TApdSapiGrammarList }
procedure TApdSapiGrammarList.ReadSectionValues (Section : string;
                                                 List : TStringList);
var
  i : Integer;
  FirstChar : Char;
begin
  i := IndexOf ('[' + Section + ']');
  List.Clear;
  if i < 0 then
    Exit;
  Inc (i);
  while (i < Count) do begin
    if Length (Strings[i]) > 0 then begin
     FirstChar := Trim (Strings[i])[1];
     if (FirstChar <> ';') and (FirstChar <> '[') then
       List.Add (Strings[i])
     else if FirstChar = '[' then
       Exit;
    end;
    Inc (i);
  end;
end;                                                 

function TApdSapiGrammarList.SectionExists (Section : string) : Boolean;
begin
  if IndexOf ('[' + Section + ']') >= 0 then
    Result := True
  else
    Result := False;
end;

{ TApdSapiPhonePrompts }

constructor TApdSapiPhonePrompts.Create;
begin
  inherited Create;

  AskAreaCode    := ApdAskAreaCode;
  AskLastFour    := ApdAskLastFour;
  AskNextThree   := ApdAskNextThree;
  CannotGoBack   := ApdCannotGoBack;
  CannotHangUp   := ApdCannotHangUp;
  HangingUp      := ApdHangingUp;
  Help           := ApdHelp;
  Help2          := ApdHelp2;
  HelpVerify     := ApdHelpVerify;
  GoingBack      := ApdGoingBack;
  Main           := ApdMain;
  Main2          := ApdMain2;
  FMaxSpeed      := ApdMaxSpeed;
  FMinSpeed      := ApdMinSpeed;
  Operator       := ApdOperator;
  NoOperator     := ApdNoOperator;
  NoSpeedChange  := ApdNoSpeedChange;
  SpeakingFaster := ApdSpeakingFaster;
  SpeakingSlower := ApdSpeakingSlower;
  TooFewDigits   := ApdTooFewDigits;
  TooManyDigits  := ApdTooManyDigits;
  Unrecognized   := ApdUnrecognized;
  VerifyPost     := ApdVerifyPost;
  VerifyPre      := ApdVerifyPre;
  Where          := ApdWhere;
  Where2         := ApdWhere2;
end;

function TApdSapiPhonePrompts.GenerateExtensionGrammar (
                                         NewTooFewDigits : string;
                                         NewTooManyDigits : string) : string;
begin
  Result := '';
  if NewTooFewDigits <> '' then
    Result := Result + 'TooFewDigits=' + NewTooFewDigits + ^M^J
  else if TooFewDigits <> '' then
    Result := Result + 'TooFewDigits=' + TooFewDigits + ^M^J;

  if NewTooManyDigits <> '' then
    Result := Result + 'TooManyDigits=' + NewTooManyDigits + ^M^J
  else if TooManyDigits <> '' then
    Result := Result + 'TooManyDigits =' + TooManyDigits + ^M^J;
end;

function TApdSapiPhonePrompts.GenerateGrammar (NewPrompt1 : string;
                                               NewPrompt2 : string;
                                               NewHelp1 : string;
                                               NewHelp2 : string;
                                               NewWhere1 : string;
                                               NewWhere2 : string) : string;
begin
  Result := '[Prompts]'^M^J;
  if NewPrompt1 <> '' then
    Result := Result + 'Main=' + NewPrompt1 + ^M^J
  else if Main <> '' then
    Result := Result + 'Main=' + Main + ^M^J;

  if NewPrompt2 <> '' then
    Result := Result + 'Main.2=' + NewPrompt2 + ^M^J
  else if Main2 <> '' then
    Result := Result + 'Main=' + Main2 + ^M^J;

  if NewWhere1 <> '' then
    Result := Result + 'Where=' + NewWhere1 + ^M^J
  else if Where <> '' then
    Result := Result + 'Where=' + Where + ^M^J;

  if NewWhere2 <> '' then
    Result := Result + 'Where.2=' + NewWhere2 + ^M^J
  else if Where2 <> '' then
    Result := Result + 'Where.2=' + Where2 + ^M^J;

  if NewHelp1 <> '' then
    Result := Result + 'Help=' + NewHelp1 + ^M^J
  else if Help <> '' then
    Result := Result + 'Help=' + Help + ^M^J;

  if NewHelp2 <> '' then
    Result := Result + 'Help.2=' + NewHelp2+ ^M^J
  else if Help2 <> '' then
    Result := Result + 'Help.2=' + Help2 + ^M^J;
end;

function TApdSapiPhonePrompts.GeneratePhoneNumberGrammar (
                                           NewAskAreaCode : string;
                                           NewAskNextThree : string;
                                           NewAskLastFour : string) : string;
begin
  Result := '';
  if NewAskAreaCode <> '' then
    Result := Result + 'AskAreaCode =' + NewAskAreaCode + ^M^J
  else if AskAreaCode <> '' then
    Result := Result + 'AskAreaCode =' + AskAreaCode + ^M^J;

  if NewAskNextThree <> '' then
    Result := Result + 'AskNextThree =' + NewAskNextThree + ^M^J
  else if AskNextThree <> '' then
    Result := Result + 'AskNextThree =' + AskNextThree + ^M^J;

  if NewAskLastFour <> '' then
    Result := Result + 'AskLastFour =' + NewAskLastFour + ^M^J
  else if AskLastFour <> '' then
    Result := Result + 'AskLastFour =' + AskLastFour + ^M^J;
end;

procedure TApdSapiPhonePrompts.SetAskAreaCode (v : string);
begin
  if v <> FAskAreaCode then
    FAskAreaCode := v;
end;

procedure TApdSapiPhonePrompts.SetAskLastFour (v : string);
begin
  if v <> FAskLastFour then
    FAskLastFour := v;
end;

procedure TApdSapiPhonePrompts.SetAskNextThree (v : string);
begin
  if v <> FAskNextThree then
    FAskNextThree := v;

end;

procedure TApdSapiPhonePrompts.SetCannotGoBack (v : string);
begin
  if v <> FCannotGoBack then
    FCannotGoBack := v;
end;

procedure TApdSapiPhonePrompts.SetCannotHangUp (v : string);
begin
  if v <> FCannotHangUp then
    FCannotHangUp := v;
end;

procedure TApdSapiPhonePrompts.SetGoingBack (v : string);
begin
  if v <> FGoingBack then
    FGoingBack := v;
end;

procedure TApdSapiPhonePrompts.SetHangingUp (v : string);
begin
  if v <> FHangingUp then
    FHangingUp := v;
end;

procedure TApdSapiPhonePrompts.SetHelp (v : string);
begin
  if v <> FHelp then
    FHelp := v;
end;

procedure TApdSapiPhonePrompts.SetHelp2 (v : string);
begin
  if v <> FHelp2 then
    FHelp2 := v;
end;

procedure TApdSapiPhonePrompts.SetHelpVerify (v : string);
begin
  if v <> FHelpVerify then
    FHelpVerify := v;
end;

procedure TApdSapiPhonePrompts.SetMain (v : string);
begin
  if v <> FMain then
    FMain := v;
end;

procedure TApdSapiPhonePrompts.SetMain2 (v : string);
begin
  if v <> FMain2 then
    FMain2 := v;
end;

procedure TApdSapiPhonePrompts.SetMaxSpeed (v : string);
begin
  if v <> FMaxSpeed then
    FMaxSpeed := v;
end;

procedure TApdSapiPhonePrompts.SetMinSpeed (v : string);
begin
  if v <> FMinSpeed then
    FMinSpeed := v;
end;

procedure TApdSapiPhonePrompts.SetOperator (v : string);
begin
  if v <> FOperator then
    FOperator := v;
end;

procedure TApdSapiPhonePrompts.SetNoOperator (v : string);
begin
  if v <> FNoOperator then
    FNoOperator := v;
end;

procedure TApdSapiPhonePrompts.SetNoSpeedChange (v : string);
begin
  if v <> FNoSpeedChange then
    FNoSpeedChange := v;
end;

procedure TApdSapiPhonePrompts.SetSpeakingFaster (v : string);
begin
  if v <> FSpeakingFaster then
    FSpeakingFaster := v;
end;

procedure TApdSapiPhonePrompts.SetSpeakingSlower (v : string);
begin
  if v <> FSpeakingSlower then
    FSpeakingSlower := v;
end;

procedure TApdSapiPhonePrompts.SetTooFewDigits (v : string);
begin
  if v <> FTooFewDigits then
    FTooFewDigits := v;
end;

procedure TApdSapiPhonePrompts.SetTooManyDigits (v : string);
begin
  if v <> FTooManyDigits then
    FTooManyDigits := v;
end;

procedure TApdSapiPhonePrompts.SetUnrecognized (v : string);
begin
  if v <> FUnrecognized then
    FUnrecognized := v;
end;

procedure TApdSapiPhonePrompts.SetVerifyPost (v : string);
begin
  if v <> FVerifyPost then
    FVerifyPost := v;
end;

procedure TApdSapiPhonePrompts.SetVerifyPre (v : string);
begin
  if v <> FVerifyPre then
    FVerifyPre := v;
end;

procedure TApdSapiPhonePrompts.SetWhere (v : string);
begin
  if v <> FWhere then
    FWhere := v;
end;

procedure TApdSapiPhonePrompts.SetWhere2 (v : string);
begin
  if v <> FWhere2 then
    FWhere2 := v;
end;

{ TApdSapiAskForInfo }

constructor TApdSapiAskForInfo.Create;
begin
  inherited Create;

  FAskForGrammar := TStringList.Create;
  FMainGrammar := TStringList.Create;
  FPrompts := TApdSapiPhonePrompts.Create;
  FStringHandler := gshIgnore; 

  InitializeMainGrammar;
end;

destructor TApdSapiAskForInfo.Destroy;
begin
  FAskForGrammar.Free;
  FMainGrammar.Free;
  FPrompts.Free;
    
  inherited Destroy;
end;

procedure TApdSapiAskForInfo.AskFor;
begin
  if not Assigned (FSapiEngine) then
    raise ESapiPhoneError.Create (-1, ecApdNoSapiEngine);

  if not Assigned (FPrompts) then
    raise ESapiPhoneError.Create (-1, ecApdNoPrompts);

  FSapiEngine.RegisterPhraseFinishHook (SapiPhraseFinishHook);

  FSapiEngine.Speak (Prompts.Main);
  FSapiEngine.DirectSR.GrammarFromString (FMainGrammar.Text + ^M^J +
                                          FAskForGrammar.Text);
  FSapiEngine.Listening := True;
end;

function TApdSapiAskForInfo.DeterminePhraseType (Phrase : string) : TApdPhraseType;
var
  PhraseType : string;

begin
  Result := DeterminePhraseTypeEx (Phrase, PhraseType);
end;

function TApdSapiAskForInfo.DeterminePhraseTypeEx (Phrase : string;
                                                   var Rule : string) : TApdPhraseType;
begin
  Result := ptUnknown;
  Rule := FindGrammarRule (Phrase);
  if Rule = '' then begin
    Result := ptNone;
    Exit;
  end;
  try
    case StrToInt (Rule) of
      -3  : Result := ptOperator;
      -4  : Result := ptHangup;
      -5  : Result := ptBack;
      -10 : Result := ptWhere;
      -11 : Result := ptHelp;
      -12 : Result := ptRepeat;
      -13 : Result := ptSpeakFaster;
      -14 : Result := ptSpeakSlower;
    end;

  except
    on EConvertError do
      begin
      end;
  end;
end;

function TApdSapiAskForInfo.GetKey (Value : string) : string;
{ Returns the Key portion of <Key>=<Value> }
var
  Sep : Integer;

begin
  Result := '';
  Sep := Pos ('=', Value);
  if Sep > 1 then
    Result := Copy (Value, 1, Sep - 1);
end;

function TApdSapiAskForInfo.GetValue (Value : string) : string;
{ Returns the Value portion of <Key>=<Value> }
var
  Sep : Integer;

begin
  Result := '';
  Sep := Pos ('=', Value);
  if Sep > 0 then
    Result := Copy (Value, Sep + 1, Length (Value) - Sep)
end;

function TApdSapiAskForInfo.IsAnglePhrase (Phrase : string) : Boolean;
begin
  Result := False;
  if Phrase = '' then
    Exit;
  if (Phrase[1] = '<') and (Phrase[Length (Phrase)] = '>') then
    Result := True;
end;

function TApdSapiAskForInfo.IsParenPhrase (Phrase : string) : Boolean;
begin
  Result := False;
  if Phrase = '' then
    Exit;
  if (Phrase[1] = '(') and (Phrase[Length (Phrase)] = ')') then
    Result := True;
end;

function TApdSapiAskForInfo.IsQuoted (Phrase : string) : Boolean;
begin
  Result := False;
  if Phrase = '' then
    Exit;
  if (Phrase[1] = '"') and (Phrase[Length (Phrase)] = '"') then
    Result := True;
end;

function TApdSapiAskForInfo.KillQuotes (Phrase : string) : string;
begin
  Result := Phrase;
  if IsQuoted (Phrase) then
    Result := Copy (Phrase, 2, Length (Phrase) - 2);
end;

function TApdSapiAskForInfo.AnalyzeRule (Tokens : TStringList;
                                         CurrentRule : string;
                                         INIFile : TApdSapiGrammarList;
                                         CurrentSection : TStringList;
                                         var CurrentWord : Integer;
                                         var MatchingKey : string) : Boolean;
var
  List : TStringList;
  i : Integer;
  j : Integer;
  Optional : Boolean;
  RCode : Boolean;
  OldCurrentWord : Integer;

begin
  OldCurrentWord := CurrentWord;
  Result := True;
  Optional := False;
  { Tokenize the rule that is being analyzed }
  List := TStringList.Create;
  try
    TokenizePhrase (CurrentRule, List);
    i := 0;
    while i < List.Count do begin
      { If the token is of the form <stuff> or (stuff), first check to see
        if there is a section of that name.  If there is then use RecurseRules
        to analyze it.  If there isn't a section with that name, then see
        if there is one or more rules with that name in the current section.
        If so, then analyze those rules. }
      if (IsAnglePhrase (List[i])) or (IsParenPhrase (List[i])) then begin
        if INIFile.SectionExists (List[i]) then begin
          RCode := RecurseRules (Tokens, INIFile, List[i], CurrentWord,
                                 MatchingKey);
          if (not RCode) and (not Optional) then begin
            Result := False;
            CurrentWord := OldCurrentWord;
            Exit;
          end;
        end else begin
          RCode := False;
          for j := 0 to CurrentSection.Count - 1 do
            if GetKey (CurrentSection[j]) = List[i] then begin
              if AnalyzeRule (Tokens, GetValue (CurrentSection[j]),
                              INIFile, CurrentSection, CurrentWord,
                              MatchingKey) then
                RCode := True;
            end;
          if (not RCode) and (not Optional) then begin
            Result := False;
            CurrentWord := OldCurrentWord;
            Exit;
          end;
        end;
        Optional := False;
      end else if List[i] = '[opt]' then begin
        Optional := True;
      end else if List[i] = '[1+]' then begin
      end else if List[i] = '[0+]' then begin
        Optional := True;
      end else if IsQuoted (List[i]) then begin
        case FStringHandler of
          gshIgnore :
            begin
              { do nothing }
            end;
          gshInsert :
            begin
              Tokens.Insert(CurrentWord, KillQuotes (List[i]));
              Inc (CurrentWord);
            end;
          gshAutoReplace :
            begin
              if (i = 0) then begin
                Tokens.Insert(0, KillQuotes (List[i]));
                Inc (CurrentWord);
              end else begin
                if (IsAnglePhrase (List[i - 1])) or
                   (IsParenPhrase (List[i - 1])) or
                   (CurrentWord = 0) then begin
                  Tokens.Insert(0, KillQuotes (List[i]));
                  Inc (CurrentWord);
                end else begin
                  if (i > 1) and (List[i - 2] = '[opt]') then begin
                    Tokens.Insert(0, KillQuotes (List[i]));
                    Inc (CurrentWord);
                  end else
                    Tokens[CurrentWord - 1] := KillQuotes (List[i]);
                end;
              end;
            end;
        end;
      end else begin
        if CurrentWord < Tokens.Count then begin
          if List[i] = Tokens[CurrentWord] then begin
            Inc (CurrentWord);
          end else if not Optional then
            Result := False;
        end else if CurrentWord >= Tokens.Count then begin
          Exit;
        end;
        Optional := False;
      end;
      Inc (i);
    end;
  finally
    List.Free;
  end;
end;

function TApdSapiAskForInfo.RecurseRules (Tokens : TStringList;
                                          INIFile : TApdSapiGrammarList;
                                          CurrentSection : string;
                                          var CurrentWord : Integer;
                                          var MatchingKey : string) : Boolean;
{ Recurse Rules loads a new section and then analyzes it }
var
  i : Integer;
  Value : string;
  List : TStringList;

begin
  Result := False;
  List := TStringList.Create;
  try
    { Does the section ask for exists as a section in the grammar }
    if INIFile.SectionExists (CurrentSection) then begin
      INIFile.ReadSectionValues (CurrentSection, List);
      for i := 0 to List.Count - 1 do begin
        Value := GetKey (List[i]);
        if (Value = '') or (Value = CurrentSection) or
           ((not IsAnglePhrase (Value)) and
            (not IsParenPhrase (Value))) then begin
          Value := GetValue (List[i]);
          { Analyze the rule }
          if AnalyzeRule (Tokens, Value, INIFile, List, CurrentWord,
                          MatchingKey) then begin
            { The rule matched.  Exit successfully }
            if (Value <> '') and
               ((MatchingKey = '') or (IsAnglePhrase (MatchingKey)) or
                (IsParenPhrase (MatchingKey))) then
              MatchingKey := GetKey (List[i]);
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  finally
    List.Free;
  end;
end;

function TApdSapiAskForInfo.LocateRule (Tokens : TStringList) : string;

  procedure PreparseGrammar (Grammar : TStringList);
  var
    i : Integer;
  begin
    for i := Grammar.Count - 1 downto 0 do begin
      Grammar[i] := Trim (Grammar[i]);
      if Grammar[i] = '' then
        Grammar.Delete(i)
      else if (Copy (Grammar[i], 1, 2) = '//') or
              (Copy (Grammar[i], 1, 1) = ';') then
        Grammar.Delete(i);
    end;
  end;

var
  INIFile : TApdSapiGrammarList;
  MatchingKey : string;
  FWorkingGrammar : TStringList;
  CurrentWord : Integer;

begin
  Result := '';
  CurrentWord := 0;
  MatchingKey := '';
  { Create an INI file that will be used to work with the grammar }
  INIFile := TApdSapiGrammarList.Create;
  try
    { Create a work grammar and merge all the grammars into it }
    FWorkingGrammar := TStringList.Create;
    try
      FWorkingGrammar.Text := FMainGrammar.Text + ^M^J + FAskForGrammar.Text;
      PreparseGrammar (FWorkingGrammar);
      INIFile.Assign (FWorkingGrammar); 
    finally
      FWorkingGrammar.Free;
    end;
    { Analyze the grammar - start with the <Start> rule }
    RecurseRules (Tokens, INIFile, '<Start>', CurrentWord, MatchingKey);
    Result := MatchingKey;
  finally
    INIFile.Free;
  end;
end;

function TApdSapiAskForInfo.FindGrammarRule (var Phrase : string) : string;

var
  Tokens : TStringList;
  i      : Integer;
  
begin
  Result := '';
  if Phrase = '' then
    Exit;
  Tokens := TStringList.Create;
  try
    { Break the phrase down into its tokens }
    TokenizePhrase (Phrase, Tokens);
    { Find the first rule that matches the phrase }
    Result := LocateRule (Tokens);
    Phrase := '';
    for i := 0 to Tokens.Count - 1 do 
      if i < Tokens.Count - 1 then
        Phrase := Phrase + Tokens[i] + ' '
      else
        Phrase := Phrase + Tokens[i];
  finally
    Tokens.Free;
  end;
end;

procedure TApdSapiAskForInfo.InitializeMainGrammar;
begin
  with FMainGrammar do begin
    Clear;
    Text := ApdDefaultPhoneGrammar;
  end;
end;

procedure TApdSapiAskForInfo.SapiPhraseFinishHook (Sender : TObject;
                                                   Phrase : string;
                                                   Results : Integer);
var
  PhraseType  : TApdPhraseType;
  PhraseRule  : string;
  StringData  : PChar;

begin
  PhraseType := DeterminePhraseTypeEx (Phrase, PhraseRule);
  case PhraseType of
    ptHelp        :
      FSapiEngine.Speak (Prompts.Help);
    ptBack        :
      begin
        if psCanGoBack in Options then begin
          FSapiEngine.DeRegisterPhraseFinishHook (SapiPhraseFinishHook);
          FSapiEngine.Speak (Prompts.GoingBack);
          if ReplyHandle <> 0 then
            PostMessage (ReplyHandle, apw_SapiInfoPhrase, WPARAM(ApdSapiAskBack), 0);
        end else 
          FSapiEngine.Speak (Prompts.CannotGoBack);
      end;
    ptOperator    :
      begin
        if psEnableOperator in Options then begin
          FSapiEngine.DeRegisterPhraseFinishHook (SapiPhraseFinishHook);
          FSapiEngine.Speak (Prompts.Operator);
          if ReplyHandle <> 0 then
            PostMessage (ReplyHandle, apw_SapiInfoPhrase, ApdSapiAskOperator, 0);
        end else 
          FSapiEngine.Speak (Prompts.NoOperator);
      end;
    ptHangup      :
      begin
        if psEnableAskHangup in Options then begin
          FSapiEngine.DeRegisterPhraseFinishHook (SapiPhraseFinishHook);
          FSapiEngine.Speak (Prompts.HangingUp);
          if ReplyHandle <> 0 then
            PostMessage (ReplyHandle, apw_SapiInfoPhrase, ApdSapiAskHangup, 0);
        end else 
          FSapiEngine.Speak (Prompts.CannotHangUp);
      end;
    ptWhere       :
      begin
        FSapiEngine.Speak (Prompts.Where);
        if ReplyHandle <> 0 then
          PostMessage (ReplyHandle, apw_SapiInfoPhrase, ApdSapiAskWhere, 0);
      end;
    ptRepeat      :
      begin
        FSapiEngine.Speak (Prompts.Main2);
        if ReplyHandle <> 0 then
          PostMessage (ReplyHandle, apw_SapiInfoPhrase, ApdSapiAskRepeat, 0);
      end;
    ptSpeakFaster :
      begin
        if psDisableSpeedChange in Options then begin
          FSapiEngine.Speak (Prompts.NoSpeedChange);
        end else begin
          if FSapiEngine.DirectSS.Speed < FSapiEngine.DirectSS.MaxSpeed -
                                          ApdSapiSpeedChange then begin
            FSapiEngine.DirectSS.Speed := FSapiEngine.DirectSS.Speed +
                                          ApdSapiSpeedChange;
            FSapiEngine.Speak (Prompts.SpeakingFaster);
            if ReplyHandle <> 0 then
              PostMessage (ReplyHandle, apw_SapiInfoPhrase,
                           ApdSapiAskSpeakFaster, 0);
          end else 
            FSapiEngine.Speak (Prompts.MaxSpeed);
        end;
      end;
    ptSpeakSlower :
      begin
        if psDisableSpeedChange in Options then begin
          FSapiEngine.Speak (Prompts.NoSpeedChange);
        end else begin
          if FSapiEngine.DirectSS.Speed > FSapiEngine.DirectSS.MinSpeed +
                                          ApdSapiSpeedChange then begin
            FSapiEngine.DirectSS.Speed := FSapiEngine.DirectSS.Speed -
                                          ApdSapiSpeedChange;
            FSapiEngine.Speak (Prompts.SpeakingSlower);
            if ReplyHandle <> 0 then
              PostMessage (ReplyHandle, apw_SapiInfoPhrase,
                           ApdSapiAskSpeakSlower, 0);
          end else 
            FSapiEngine.Speak (Prompts.MinSpeed);
        end;
      end;
    ptNone        :
      begin
      end;
    ptUnknown     :
      begin
        { Parse unrecognized grammar rules here }
        try
          if ReplyHandle <> 0 then begin
            StringData := StrAlloc (Length (Phrase) + 1);
            StrPCopy (StringData, Phrase);
            PostMessage (ReplyHandle, apw_SapiInfoPhrase,
                         StrToInt (PhraseRule), Integer (StringData));
          end;
        except
          on EConvertError do
            FSapiEngine.Speak (Prompts.Unrecognized);
        end;
      end;
  end;
end;

procedure TApdSapiAskForInfo.SetAskForGrammar (v : TStringList);
begin
  FAskForGrammar.Assign (v);
end;

procedure TApdSapiAskForInfo.SetMainGrammar (v : TStringList);
begin
  FMainGrammar.Assign (v);
end;

procedure TApdSapiAskForInfo.SetOptions (v : TApdSapiPhoneSettings);
begin
  if v <> FOptions then
    FOptions := v;
end;

procedure TApdSapiAskForInfo.SetReplyHandle (v : THandle);
begin
  if v <> FReplyHandle then
    FReplyHandle := v;
end;

{ TApdCustomSapiPhone }

constructor TApdCustomSapiPhone.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);
  FSpellingEchoBack := True;

  FInfo := TApdSapiAskForInfo.Create;
  FPrompts := TApdSapiPhonePrompts.Create;
  FList := TStringList.Create;

  FSapiEngine := SearchSapiEngine (Owner);
end;

destructor TApdCustomSapiPhone.Destroy;
begin
  AbortAskFor;
  CancelCall;

  FInfo.Free;
  FPrompts.Free;
  FList.Free;

  inherited Destroy;
end;

procedure TApdCustomSapiPhone.AbortAskFor;
begin
  ExitAskFor (prAbort, nil, '');
end;

procedure TApdCustomSapiPhone.AskForDateDataHandler (LastReply : TApdPhraseType;
                                                     LastRule : Integer;
                                                     LastPhrase : string);
var
  OutDate : PDateTime;
  Trusted : Boolean;

begin
  if LastRule = -500 then begin
    GetMem (OutDate, SizeOf (TDateTime));
    OutDate^ := InterpretDate (LastPhrase, Trusted);
    if Trusted then
      ExitAskFor (prOk, OutDate, LastPhrase)
    else
      ExitAskFor (prCheck, OutDate, LastPhrase)
  end else 
    FSapiEngine.Speak (Prompts.Unrecognized);
end;

procedure TApdCustomSapiPhone.AskForExtensionDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
var
  OutExtension : PChar;

begin
  if LastRule = -400 then begin
    FExtension := FExtension + LastPhrase;
    FDigitCount := FDigitCount + 1;
    if FDigitCount >= NumDigits then begin
      GetMem (OutExtension, (Length (FExtension) + 1) * SizeOf(Char));  //@@@ SZ (was length(OutExtension) 17.04.2008
      StrPCopy (OutExtension, FExtension);
      ExitAskFor (prOk, OutExtension, LastPhrase);
    end;
  end else
    FSapiEngine.Speak (Prompts.Unrecognized);
end;

procedure TApdCustomSapiPhone.AskForListDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
var
  OutIndex : PInteger;
  i : Integer;

begin
  GetMem (OutIndex, sizeof (Integer));
  if LastRule = -300 then begin
    i := FList.IndexOf (LastPhrase);
    if i > -1 then begin
      OutIndex^ := i;
      ExitAskFor (prOk, OutIndex, LastPhrase);
    end else
      FSapiEngine.Speak (Prompts.Unrecognized);
  end else
    FSapiEngine.Speak (Prompts.Unrecognized);
end;

procedure TApdCustomSapiPhone.AskForPhoneNumberDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
var
  PhoneNumber : PChar;

begin
  if LastRule = -600 then begin
    LastPhrase := InterpretPhoneNumber (LastPhrase);
    GetMem (PhoneNumber, (Length (LastPhrase) + 1) * SizeOf(Char));
    StrPCopy (PhoneNumber, LastPhrase);
    ExitAskFor (prOk, PhoneNumber, LastPhrase);
  end else
    FSapiEngine.Speak (Prompts.Unrecognized);
end;

procedure TApdCustomSapiPhone.AskForSpellingDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
var
  OutSpelledWord : PChar;

begin
  if LastRule = -200 then begin
    if FSpellingEchoBack then
      FSapiEngine.Speak (LastPhrase);
    FSpelledWord := FSpelledWord + LastPhrase;
  end else if LastRule = -201 then begin
    GetMem (OutSpelledWord, (Length (FSpelledWord) + 1) * SizeOf(Char));
    StrPCopy (OutSpelledWord, FSpelledWord);
    ExitAskFor (prOk, OutSpelledWord, LastPhrase);
  end else if LastRule = -202 then begin
    FSpelledWord := '';
  end else if LastRule = -203 then begin
     FSpelledWord := Copy (FSpelledWord, 1, Length (FSpelledWord) - 1);
  end else if LastRule = -203 then
    FSapiEngine.Speak (ApdYouHaveSpelled + FSpelledWord)
  else
    FSapiEngine.Speak (Prompts.Unrecognized);
end;

procedure TApdCustomSapiPhone.AskForTimeDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
var
  OutTime : PDateTime;
begin
  if (LastRule <= -700) and (LastRule >= -705) then begin
    GetMem (OutTime, SizeOf (TDateTime));
    OutTime^ := InterpretTime (LastPhrase);
    ExitAskFor (prOk, OutTime, LastPhrase);
  end else
    FSapiEngine.Speak (Prompts.Unrecognized);
end;

procedure TApdCustomSapiPhone.AskForYesNoDataHandler (LastReply : TApdPhraseType;
                                       LastRule : Integer;
                                       LastPhrase : string);
var
  Reply : PBoolean;
begin
  if LastRule = -100 then begin
    GetMem (Reply, SizeOf (Boolean));
    Reply^ := True;
    ExitAskFor (prOk, Reply, LastPhrase);
  end else if LastRule = -101 then begin
    GetMem (Reply, SizeOf (Boolean));
    Reply^ := False;
    ExitAskFor (prOk, Reply, LastPhrase);
  end else
    FSapiEngine.Speak (Prompts.Unrecognized);
end;

procedure TApdCustomSapiPhone.AskForDateTrigger (Reply : TApdSapiPhoneReply;
                                                 Data : Pointer;
                                                 SpokenData : string);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnAskForDateFinish) then begin
    if Assigned (Data) then begin
      FOnAskForDateFinish (Self, Reply, TDateTime (Data^), SpokenData);
      FreeMem (Data);
    end else
      FOnAskForDateFinish (Self, Reply, 0, SpokenData);
  end;
end;

procedure TApdCustomSapiPhone.AskForExtensionTrigger (Reply : TApdSapiPhoneReply;
                                                      Data : Pointer;
                                                      SpokenData : string);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnAskForExtensionFinish) then begin
    if Assigned (Data) then begin
      FOnAskForExtensionFinish (Self, Reply, string (PChar (Data)),
                                SpokenData);
      FreeMem (Data);
    end else
      FOnAskForExtensionFinish (Self, Reply, '', SpokenData);
  end;
end;

procedure TApdCustomSapiPhone.AskForListTrigger (Reply : TApdSapiPhoneReply;
                                                 Data : Pointer;
                                                 SpokenData : string);
var
  OutIdx : PInteger;

begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnAskForListFinish) then begin
    if Assigned (Data) then begin
      OutIdx := Data;
      FOnAskForListFinish (Self, Reply, OutIdx^, SpokenData);
      FreeMem (Data);
    end else
      FOnAskForListFinish (Self, Reply, -1, SpokenData);
  end;
end;

procedure TApdCustomSapiPhone.AskForPhoneNumberTrigger (
                                   Reply : TApdSapiPhoneReply;
                                   Data : Pointer;
                                   SpokenData : string);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnAskForPhoneNumberFinish) then begin
    if Assigned (Data) then begin
      FOnAskForPhoneNumberFinish (Self, Reply, string (PChar (Data)),
                                  SpokenData);
      FreeMem (Data);
    end else
      FOnAskForPhoneNumberFinish (Self, Reply, '', SpokenData);
  end;
end;

procedure TApdCustomSapiPhone.AskForSpellingTrigger (
                                   Reply : TApdSapiPhoneReply;
                                   Data : Pointer;
                                   SpokenData : string);
begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnAskForSpellingFinish) then begin
    if Assigned (Data) then begin
      FOnAskForSpellingFinish (Self, Reply, string (PChar (Data)),
                               SpokenData);
      FreeMem (Data);
    end else
      FOnAskForSpellingFinish (Self, Reply, '', SpokenData);
  end;
end;

procedure TApdCustomSapiPhone.AskForTimeTrigger (Reply : TApdSapiPhoneReply;
                                                 Data : Pointer;
                                                 SpokenData : string);
var
  OutTime : PDateTime;

begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnAskForTimeFinish) then begin
    if Assigned (Data) then begin
      OutTime := Data;
      FOnAskForTimeFinish (Self, Reply, TDateTime (OutTime^), SpokenData);
      FreeMem (Data);
    end else
      FOnAskForTimeFinish (Self, Reply, 0, SpokenData);
  end;
end;

procedure TApdCustomSapiPhone.AskForYesNoTrigger (Reply : TApdSapiPhoneReply;
                                   Data : Pointer;
                                   SpokenData : string);
var
  Response : PBoolean;

begin
  { Events may still be firing after components are destroyed - or while they
    are being destroyed.  Check for this in all of the event triggers }
  if csDestroying in ComponentState then
    Exit;
  if Assigned (FOnAskForYesNoFinish) then begin
    if Assigned (Data) then begin
      Response := Data;
      FOnAskForYesNoFinish (Self, Reply, Boolean (Response^), SpokenData);
      FreeMem (Data);
    end else
      FOnAskForYesNoFinish (Self, Reply, False, SpokenData);
  end;
end;

procedure TApdCustomSapiPhone.AskForDate (NewPrompt1 : string);
begin
  AskForDateEx (NewPrompt1, '', '', '', '', '');
end;

procedure TApdCustomSapiPhone.AskForDateEx (NewPrompt1 : string;
                                            NewPrompt2 : string;
                                            NewHelp1 : string;
                                            NewHelp2 : string;
                                            NewWhere1 : string;
                                            NewWhere2 : string);

begin
  AbortAskFor;
  { Initialize the custom grammar }

  with FInfo.AskForGrammar do begin
    Clear;
    Text :=ApdAskForDateGrammar;
  end;

  { Initialize the ask for engine }

  FInfo.ReplyHandle := FHandle;
  FInfo.SapiEngine := SapiEngine;
  FInfo.Options := Options;

  { Set up the prompts }

  SetDefaultPrompts (NewPrompt1, NewPrompt2, NewHelp1, NewHelp2, NewWhere1,
                     NewWhere2);

  { Start listening for a response }

  FCustomDataHandler := AskForDateDataHandler;
  FEventTrigger := AskForDateTrigger;

  FInfo.AskFor;
end;

procedure TApdCustomSapiPhone.AskForExtension (NewPrompt1 : string);
begin
  AskForExtensionEx (NewPrompt1, '', '', '', 0, '', '', '', '');
end;

procedure TApdCustomSapiPhone.AskForExtensionEx (NewPrompt1 : string;
                                                 NewPrompt2 : string;
                                                 NewTooManyDigits : string;
                                                 NewTooFewDigits : string;
                                                 NewNumDigits : Integer;
                                                 NewHelp1 : string;
                                                 NewHelp2 : string;
                                                 NewWhere1 : string;
                                                 NewWhere2 : string);
begin
  AbortAskFor;
  { Initialize the custom grammar }
  with FInfo.AskForGrammar do begin
    Clear;
    Text :=ApdAskForExtensionGrammar;
  end;

  { Initialize the ask for engine }

  FInfo.ReplyHandle := FHandle;
  FInfo.SapiEngine := SapiEngine;
  FInfo.Options := Options;
  FExtension := '';
  FDigitCount := 0;

  { Set up the prompts }

  SetDefaultPrompts (NewPrompt1, NewPrompt2, NewHelp1, NewHelp2, NewWhere1,
                     NewWhere2);

  { Start listening for a response }

  FCustomDataHandler := AskForExtensionDataHandler;
  FEventTrigger := AskForExtensionTrigger;

  FInfo.AskFor;
end;

procedure TApdCustomSapiPhone.AskForList (List : TStringList;
                                          NewPrompt1 : string);
begin
  AskForListEx (List, NewPrompt1, '', '', '', '', '');
end;

procedure TApdCustomSapiPhone.AskForListEx (List : TStringList;
                                            NewPrompt1 : string;
                                            NewPrompt2 : string;
                                            NewHelp1 : string;
                                            NewHelp2 : string;
                                            NewWhere1 : string;
                                            NewWhere2 : string);
var
  i : Integer;

begin
  AbortAskFor;
  { Initialize the custom grammar }
  { Always build the grammar manually }
  with FInfo.AskForGrammar do begin
    Clear;
    Add ('[<MyGrammar>]');
    Add ('<MyGrammar>=(MyList)');
    Add ('');
    Add ('[(MyList)]');
    Add ('-300=(MyListItems)');
    Add ('');
    Add ('[(MyListItems)]');
    for i := 0 to List.Count - 1 do
      Add ('=' + List[i]);
  end;

  { Initialize the ask for engine }

  FInfo.ReplyHandle := FHandle;
  FInfo.SapiEngine := SapiEngine;
  FInfo.Options := Options;
  FList.Assign (List);

  { Set up the prompts }

  SetDefaultPrompts (NewPrompt1, NewPrompt2, NewHelp1, NewHelp2, NewWhere1,
                     NewWhere2);

  { Start listening for a response }

  FCustomDataHandler := AskForListDataHandler;
  FEventTrigger := AskForListTrigger;

  FInfo.AskFor;
end;

procedure TApdCustomSapiPhone.AskForPhoneNumber (NewPrompt1 : string);
begin
  AskForPhoneNumberEx (NewPrompt1, '', '', '', '', '', '', '', '');
end;

procedure TApdCustomSapiPhone.AskForPhoneNumberEx (NewPrompt1 : string;
                                                   NewPrompt2 : string;
                                                   NewAskAreaCode : string;
                                                   NewAskNextThree : string;
                                                   NewAskLastFour : string;
                                                   NewHelp1 : string;
                                                   NewHelp2 : string;
                                                   NewWhere1 : string;
                                                   NewWhere2 : string);
begin
  AbortAskFor;
  { Initialize the custom grammar }
  with FInfo.AskForGrammar do begin
    Clear;
    Text := ApdAskForPhoneNumberGrammar;
  end;

  { Initialize the ask for engine }

  FInfo.ReplyHandle := FHandle;
  FInfo.SapiEngine := SapiEngine;
  FInfo.Options := Options;

  { Set up the prompts }

  SetDefaultPrompts (NewPrompt1, NewPrompt2, NewHelp1, NewHelp2, NewWhere1,
                     NewWhere2);

  { Start listening for a response }

  FCustomDataHandler := AskForPhoneNumberDataHandler;
  FEventTrigger := AskForPhoneNumberTrigger;

  FInfo.AskFor;
end;

procedure TApdCustomSapiPhone.AskForSpelling (NewPrompt1 : string);
begin
  AskForSpellingEx (NewPrompt1, '', '', '', '', '');
end;

procedure TApdCustomSapiPhone.AskForSpellingEx (NewPrompt1 : string;
                                                NewPrompt2 : string;
                                                NewHelp1 : string;
                                                NewHelp2 : string;
                                                NewWhere1 : string;
                                                NewWhere2 : string);

begin
  AbortAskFor;
  { Initialize the custom grammar }

  with FInfo.AskForGrammar do begin
    Clear;
    Text := ApdAskForSpellingGrammar;
  end;

  { Initialize the ask for engine }

  FInfo.ReplyHandle := FHandle;
  FInfo.SapiEngine := SapiEngine;
  FInfo.Options := Options;
  FSpelledWord := '';

  { Set up the prompts }

  SetDefaultPrompts (NewPrompt1, NewPrompt2, NewHelp1, NewHelp2, NewWhere1,
                     NewWhere2);

  { Start listening for a response }

  FCustomDataHandler := AskForSpellingDataHandler;
  FEventTrigger := AskForSpellingTrigger;

  FInfo.AskFor;
end;

procedure TApdCustomSapiPhone.AskForTime (NewPrompt1 : string);
begin
  AskForTimeEx (NewPrompt1, '', '', '', '', '');
end;

procedure TApdCustomSapiPhone.AskForTimeEx (NewPrompt1 : string;
                                            NewPrompt2 : string;
                                            NewHelp1 : string;
                                            NewHelp2 : string;
                                            NewWhere1 : string;
                                            NewWhere2 : string);
begin
  AbortAskFor;
  { Initialize the custom grammar }
  with FInfo.AskForGrammar do begin
    Clear;
    Text := ApdAskForTimeGrammar;
  end;

  { Initialize the ask for engine }

  FInfo.ReplyHandle := FHandle;
  FInfo.SapiEngine := SapiEngine;
  FInfo.Options := Options;

  { Set up the prompts }

  SetDefaultPrompts (NewPrompt1, NewPrompt2, NewHelp1, NewHelp2, NewWhere1,
                     NewWhere2);

  { Start listening for a response }

  FCustomDataHandler := AskForTimeDataHandler;
  FEventTrigger := AskForTimeTrigger;

  FInfo.AskFor;
end;

procedure TApdCustomSapiPhone.AskForYesNo (NewPrompt1 : string);
begin
  AskForYesNoEx (NewPrompt1, '', '', '', '', '');
end;

procedure TApdCustomSapiPhone.AskForYesNoEx (NewPrompt1 : string;
                                             NewPrompt2 : string;
                                             NewHelp1 : string;
                                             NewHelp2 : string;
                                             NewWhere1 : string;
                                             NewWhere2 : string);
begin
  AbortAskFor;
  { Initialize the custom grammar }

  with FInfo.AskForGrammar do begin
    Clear;
    Text := ApdAskForYesNoGrammar;
  end;

  { Initialize the ask for engine }

  FInfo.ReplyHandle := FHandle;
  FInfo.SapiEngine := SapiEngine;
  FInfo.Options := Options;

  { Set up the prompts }

  SetDefaultPrompts (NewPrompt1, NewPrompt2, NewHelp1, NewHelp2, NewWhere1,
                     NewWhere2);

  { Start listening for a response }

  FCustomDataHandler := AskForYesNoDataHandler;
  FEventTrigger := AskForYesNoTrigger;

  FInfo.AskFor;
end;

function TApdCustomSapiPhone.ConvertResponse (RCode : Integer ) :
                                              TApdSapiPhoneReply;
begin
  case RCode of
    $0                    : Result := prOk;
    ApdTCR_ABORT          : Result := prAbort;
    ApdTCR_NORESPONSE     : Result := prNoResponse;
    ApdTCR_ASKOPERATOR    : Result := prOperator;
    ApdTCR_ASKHANGUP      : Result := prHangUp;
    ApdTCR_ASKBACK        : Result := prBack;
    ApdTCR_ASKWHERE       : Result := prWhere;
    ApdTCR_ASKHELP        : Result := prHelp;
    ApdTCR_ASKREPEAT      : Result := prRepeat;
    ApdTCR_ASKSPEAKFASTER : Result := prSpeakFaster;
    ApdTCR_ASKSPEAKSLOWER : Result := prSpeakSlower;
  else
    Result := prUnknown;
  end;
end;

procedure TApdCustomSapiPhone.DoLineCallState (Device, P1, P2, P3 : Integer);

  procedure AssignWaveInDevice;
  var
    Res             : Integer;
    DeviceID        : DWORD;
    WaveFormat      : TWaveFormatEx;
    WaveId          : SDATA;

  begin
    DeviceID := GetWaveDeviceId (False);
    { Set up the wave format. }
    with WaveFormat do begin
      wFormatTag      := WAVE_FORMAT_PCM;
      nChannels       := Channels;
      nSamplesPerSec  := SamplesPerSecond;
      nAvgBytesPerSec := SamplesPerSecond * (BitsPerSample div 8);
      nBlockAlign     := (Channels * BitsPerSample) div 8;
      wBitsPerSample  := BitsPerSample;
      cbSize          := 0;
    end;
    { Open the TAPI wave in device. }

    IAMM := CreateComObject (CLSID_MMAudioSource) as IAudioMultiMediaDevice;
    if Assigned (IAMM) then begin
      Res := IAMM.DeviceNumSet (DeviceID);
      if Res <> 0 then
        raise Exception.Create (ecApdBadDeviceNum +
                                IntToStr (Res));
      IAT := CreateComObject (CLSID_AudioSourceTel) as IAudioTel;
      if Assigned (IAT) then begin
        try
          WaveID.pData := @WaveFormat;
          WaveID.dwSize := SizeOf (TWaveFormatEx);
          FSapiEngine.CheckError (IAT.WaveFormatSet (WaveID));
          FSapiEngine.CheckError (IAT.AudioObject (IAMM));
          FSapiEngine.DirectSR.InitAudioSourceObject (NativeUInt (IAT));
        except
          on E:EOleException do begin
            FSapiEngine.CheckError (E.ErrorCode);
          end;
        end;
      end else
        raise Exception.Create (ecApdCannotCreateCOM);
    end else
      raise Exception.Create (ecApdCannotCreateCOM);
  end;

begin
  inherited DoLineCallState (Device, P1, P2, P3);
  case P1 of
    LineCallState_Connected :
      begin
        if Assigned (FSapiEngine) then begin
          if (not (tfPhoneOptimized in FSapiEngine.SSVoices.Features[
                  FSapiEngine.SSVoices.CurrentVoice])) or
             (not (sfPhoneOptimized in FSapiEngine.SREngines.Features[
                  FSapiEngine.SREngines.CurrentEngine])) then
            raise ESapiPhoneError.Create (-1, ecApdNotPhone);
          AssignWaveInDevice;
          { in Win9x, sending audio output via SAPI to the wave handle causes }
          { the audio to go through the sound card instead of TAPI, we'll use }
          { the WaveDeviceID instead of the WaveInHandle for 9x }
          if IsWin2000 then                                              {!!.04}
            FSapiEngine.DirectSS.InitAudioDestMM (WaveInHandle)          {!!.02}
          else                                                           {!!.02}
            FSapiEngine.DirectSS.InitAudioDestMM (GetWaveDeviceId(True));{!!.02}

          try
            FSapiEngine.DirectSR.Microphone := scApdTelMic;
          except
            on EOleError do
              if Assigned (FSapiEngine.OnSRError) then
                FSapiEngine.OnSRError (FSapiEngine, 0, '',
                                       ApdStrE_CANNOTSETMIC);
          end;
        end;
        PostMessage (FHandle, apw_SapiPhoneCallBack, ApdSapiConnect, 0);
      end;
    LineCallState_Disconnected :
      begin
        AbortAskFor;
        if Assigned (FSapiEngine) then begin
          FSapiEngine.Speaking := False;
          FSapiEngine.Listening := False;
          { Give the engine a little slack }
          DelayTicks (4, True);
          FSapiEngine.DirectSS.InitAudioDestMM (0);
          FSapiEngine.DirectSR.InitAudioSourceObject (0);
          try
            FSapiEngine.DirectSR.Microphone := scApdTelMic;
          except
            on EOleError do begin
              { Events may still be firing after components are destroyed - or while they
                are being destroyed.  Check for this in all of the event triggers }
              if csDestroying in ComponentState then
                Exit;
              if Assigned (FSapiEngine.OnSRError) then
                FSapiEngine.OnSRError (FSapiEngine, 0, '',
                                       ApdStrE_CANNOTSETMIC);
            end;
          end;
        end;
        PostMessage (FHandle, apw_SapiPhoneCallBack, ApdSapiDisConnect, 0);
      end;
  end;
end;

function TApdCustomSapiPhone.GetPhraseData (LParam : Integer) : string;
var
  TheString : PChar;
begin
  if LParam = 0 then
    Exit;
  TheString := PChar (LParam);
  Result := TheString;
  StrDispose (TheString);
end;

function TApdCustomSapiPhone.FixNumerics (Phrase : string) : string;
var
  i : Integer;
  j : Integer;
  Tokens : TStringList;
begin
  Tokens := TStringList.Create;
  try
    TokenizePhrase (Phrase, Tokens);
    i := Tokens.Count - 1;
    while i >= 0 do begin
      for j := 1 to ApdNumericCvtEntries do
        if Tokens[i] = ApdNumericCvt[j].InputPhrase then
          case ApdNumericCvt[j].PhraseType of
            ptConvert :
              Tokens[i] := ApdNumericCvt[j].OutputPhrase;
            ptDrop :
              Tokens.Delete (i);
            ptConvertJoin :
              if i < Tokens.Count - 1 then begin
                Tokens[i] := ApdNumericCvt[j].OutputPhrase +
                             Tokens[i + 1];
                Tokens.Delete(i + 1);
              end else
                Tokens[i] := ApdNumericCvt[j].OutputPhrase;
          end;
      Dec (i);
    end;
    Result := '';
    for i := 0 to Tokens.Count - 1 do
      if i < Tokens.Count - 1 then
        Result := Result + Tokens[i] + ' '
      else
        Result := Result + Tokens[i];
  finally
    Tokens.Free;
  end;
end;

function TApdCustomSapiPhone.InterpretDate (Phrase : string;
                                            var Trusted : Boolean) : TDateTime;

  function ConvertDateWord (DateWord : string; var Number : Integer) : TApdDateWordType;
  var
    i : Integer;
  begin
    Number := 0;
    Result := dwtUnknown;
    for i := 1 to ApdDateWordCount do
      if ApdDateWordList[i].DateWord = DateWord then begin
        Result := ApdDateWordList[i].WordType;
        Number := ApdDateWordList[i].Number;
        Exit;
      end;
  end;

type
  TDateState = (dsDateStart, dsInMonth, dsInYear, dsInYear2, dsInNextLast,
                dsIdle);

var
  Tokens          : TStringList;
  State           : TDateState;
  i               : Integer;
  Month           : Word;
  Day             : Word;
  Year            : Word;
  Number          : Integer;
  DayOffset       : Integer;
  MonthOffset     : Integer;
  YearOffset      : Integer;
  OffsetDir       : Integer;
  TodaysDayNum    : Integer;
  TodaysMonthNum  : Integer;
  WorkNum         : Integer;
  CurYear         : Integer;

begin
  Result := 0;
  Trusted := True;
  Phrase := FixNumerics (Phrase);
  if Phrase = '' then
    Exit;

  State := dsDateStart;
  DecodeDate (Date, Year, Month, Day);
  CurYear := Year;
  TodaysDayNum := DayOfTheWeek (Day);
  TodaysMonthNum := MonthOfTheYear (Day);

  DayOffset := 0;
  MonthOffset := 0;
  YearOffset := 0;
  OffsetDir := 1;

  Tokens := TStringList.Create;
  try
    { Break the phrase down into its tokens }
    TokenizePhrase (Phrase, Tokens);

    for i := 0 to Tokens.Count - 1 do begin
      case State of
        dsDateStart :
          begin
            case ConvertDateWord (Tokens[i], Number) of
              dwtMonth :
                begin
                  Month := Number;
                  State := dsInMonth;
                end;
              dwtDay :
                begin
                  if Number >= TodaysDayNum then
                    DayOffset := Number - TodaysDayNum + 1
                  else
                    DayOffset := 8 + Number - TodaysDayNum;
                  State := dsIdle;
                end;
              dwtNext :
                State := dsInNextLast;
              dwtLast :
                begin
                  OffsetDir := -1;
                  State := dsInNextLast;
                end;
              dwtToday :
                State := dsIdle;
              dwtTomorrow :
                begin
                  State := dsIdle;
                  DayOffset := 1;
                end;
              dwtYesterday :
                begin
                  State := dsIdle;
                  DayOffset := -1;
                end;
              dwtUnknown :
                begin
                  try
                    Month := StrToInt (Tokens[i]);
                    State := dsInMonth;
                  except
                    on EConvertError do
                      begin
                      end;
                  end;
                end;
            end;
          end;

        dsInMonth :
          begin
            try
              Day := StrToInt (Tokens[i]);
              if Day > 31 then begin
                Year := Day;
                Day := 1;
                State := dsIdle;
                Trusted := False;
              end else
                State := dsInYear;
            except
              on EConvertError do
                begin
                end;
            end;
          end;

        dsInYear :
          begin
            try
              Year := StrToInt (Tokens[i]);
              if Year < 10 then
                Year := Year * 1000
              else
                Year := Year * 100;
              State := dsInYear2;
              if i = Tokens.Count - 1 then
                Year := Year div  100 + (CurYear div 100) * 100;
            except
              on EConvertError do
                begin
                end;
            end;
          end;

        dsInYear2 :
          begin
            try
              WorkNum := StrToInt (Tokens[i]);
              if WorkNum <> 0 then begin
                Year := Year + StrToInt (Tokens[i]);
                State := dsIdle;
              end;
            except
              on EConvertError do
                begin
                end;
            end;
          end;

        dsInNextLast :
          begin
            case ConvertDateWord (Tokens[i], Number) of
              dwtWeekOff :
                begin
                  DayOffset := 7;
                  State := dsIdle;
                end;
              dwtMonthOff :
                begin
                  MonthOffset := 1;
                  State := dsIdle;
                end;
              dwtYearOff :
                begin
                  YearOffset := 1;
                  State := dsIdle;
                end;
              dwtDay :
                begin
                  if OffsetDir > 0 then
                    DayOffset := 8 + Number - TodaysDayNum
                  else
                    DayOffset := 6 + TodaysDayNum - Number;
                  State := dsIdle;
                end;
              dwtMonth :
                begin
                  if OffsetDir > 0 then
                    MonthOffset := 4 + Number - TodaysMonthNum
                  else
                    MonthOffset := 8 + TodaysMonthNum - Number;
                  State := dsIdle;
                end;
            end;
          end;

        dsIdle :
          begin
          end;
      end;
    end;
  finally
    Tokens.Free;
  end;

  Result := EncodeDate (Year, Month, Day) + (DayOffset * OffsetDir);
  Result := IncYear (Result, YearOffset * OffsetDir);
  Result := IncMonth (Result, MonthOffset * OffsetDir);
end;

function TApdCustomSapiPhone.InterpretPhoneNumber (Phrase : string) : string;
var
  State : Integer;
  i : Integer;
  List : TStringList;
  j : Integer;
  GotOne : Boolean;

begin
  Result := '';
  State := 0;
  List := TStringList.Create;
  try
    TokenizePhrase (Phrase, List);
    for i := 0 to List.Count - 1 do begin
      case State of
        0 :
          begin
            GotOne := False;
            if List[i] = 'hundred' then
              State := 1
            else begin
              for j := 1 to ApdPhoneNumberEntries do
               if ApdPhoneNumberConvert[j].InputPhrase = List[i] then begin
                 Result := Result + ApdPhoneNumberConvert[j].OutputPhrase;
                 GotOne := True;
                 Break;
               end;
              if not GotOne then
                Result := Result + List[i];
            end;
          end;
        1 :
          begin
            GotOne := False;
            if List[i] <> 'and' then
              Result := Result + '00';
            for j := 1 to ApdPhoneNumberEntries do
             if ApdPhoneNumberConvert[j].InputPhrase = List[i] then begin
               Result := Result + ApdPhoneNumberConvert[j].OutputPhrase;
               GotOne := True;
               Break;
             end;
            if not GotOne then
              Result := Result + List[i];
            State := 0;
          end;
      end;
    end;
  finally
    List.Free;
  end;
end;

function TApdCustomSapiPhone.InterpretTime (Phrase : string) : TDateTime;

  function ConvertTimeWord (TimeWord : string) : TApdTimeWordType;
  var
    i : Integer;
  begin
    Result := twtUnknown;
    for i := 1 to ApdTimeWordCount do
      if ApdTimeWordList[i].TimeWord = TimeWord then begin
        Result := ApdTimeWordList[i].WordType;
        Exit;
      end;
  end;

type
  TTimeState = (tsTimeStart, tsInQuarterHalf, tsInBeforeAfter,
                tsInHours, tsInOClock, tsInMinutes, tsGetAMPM,
                tsIdle);
  TTimeOffset = (toNone, toQuarter, toHalf);
  TTimeBeforeAfter = (tbaAfter, tbaBefore);
  TTimeAMPM = (tapAM, tapPM);


var
  Tokens          : TStringList;
  State           : TTimeState;
  i               : Integer;
  TimeOffset      : TTimeOffset;
  TimeBeforeAfter : TTimeBeforeAfter;
  TimeAMPM        : TTimeAMPM;
  Hour            : Integer;
  Minute          : Integer;

begin
  Result := 0;
  Phrase := FixNumerics (Phrase);
  if Phrase = '' then
    Exit;

  State := tsTimeStart;
  TimeOffset := toNone;
  TimeBeforeAfter := tbaAfter;
  TimeAMPM := tapAM;
  Hour := 0;
  Minute := 0;

  Tokens := TStringList.Create;
  try
    { Break the phrase down into its tokens }
    TokenizePhrase (Phrase, Tokens);

    for i := 0 to Tokens.Count - 1 do begin
      case State of
        tsTimeStart :
          begin
            case ConvertTimeWord (Tokens[i]) of
              twtQuarter  :
                begin
                  TimeOffset := toQuarter;
                  State := tsInQuarterHalf;
                end;
              twtHalf     :
                begin
                  TimeOffset := toHalf;
                  State := tsInQuarterHalf;
                end;
              twtMidnight :
                begin
                  Hour := 12;
                  State := tsIdle;
                  TimeAMPM := tapAM;
                end;
              twtNoon     :
                begin
                  Hour := 12;
                  TimeAMPM := tapPM;
                  State := tsIdle;
                end;
              twtUnknown  :
                begin
                  try
                    Hour := StrToInt (Tokens[i]);
                  except
                    on EConvertError do begin
                    end;
                  end;
                  if Hour < 7 then
                    TimeAMPM := tapPM;
                  State := tsInHours;
                end;
              else begin
              end;
            end;
          end;

        tsInQuarterHalf :
          begin
            case ConvertTimeWord (Tokens[i]) of
              twtAfter  :
                State := tsInBeforeAfter;
              twtBefore :
                begin
                  TimeBeforeAfter := tbaBefore;
                  State := tsInBeforeAfter;
                end;
              else begin
              end;
            end;
          end;

        tsInBeforeAfter :
          begin
            case ConvertTimeWord (Tokens[i]) of
              twtMidnight :
                begin
                  Hour := 12;
                  TimeAMPM := tapAM;
                  State := tsIdle;
                end;
              twtNoon :
                begin
                  Hour := 12;
                  TimeAMPM := tapPM;
                  State := tsIdle;
                end;
              twtUnknown :
                begin
                  try
                    Hour := StrToInt (Tokens[i]);
                  except
                    on EConvertError do begin
                    end;
                  end;
                  if Hour < 7 then
                    TimeAMPM := tapPM;
                  State := tsGetAMPM;
                end;
            end;
          end;

        tsGetAMPM :
          begin
            case ConvertTimeWord (Tokens[i]) of
              twtAM :
                State := tsIdle;
              twtPM :
                begin
                  TimeAMPM := tapPM;
                  State := tsIdle;
                end;
              else
                begin
                end;
            end;
          end;

        tsInHours :
          begin
            case ConvertTimeWord (Tokens[i]) of
              twtAfter :
                begin
                  Minute := Hour;
                  Hour := 0;
                  State := tsInBeforeAfter;
                end;
              twtBefore :
                begin
                  Minute := Hour;
                  Hour := 0;
                  State := tsInBeforeAfter;
                  TimeBeforeAfter := tbaBefore;
                end;
              twtUnknown :
                begin
                  try
                    Minute := StrToInt (Tokens[i]);
                  except
                    on EConvertError do begin
                    end;
                  end;
                  State := tsGetAMPM;
                end;
            end;
          end;

        tsIdle :
          begin
          end;
      end;
    end;
  finally
    Tokens.Free;
  end;

  if (TimeAMPM = tapAM) and (Hour = 12) then
    Hour := 0;
  if (TimeAMPM = tapPM) and (Hour < 12) then
    Hour := Hour + 12;
  case TimeOffset of
    toHalf : Minute := 30;
    toQuarter : Minute := 15;
  end;
  if TimeBeforeAfter = tbaBefore then begin
    Minute := 60 - Minute;
    Dec (Hour);
    if Hour < 0 then
      Hour := 23;
  end;

  Result := EncodeTime (Hour, Minute, 0, 0);
end;

procedure TApdCustomSapiPhone.Notification(AComponent : TComponent;
                                            Operation : TOperation);
  {-Handle new/deleted components}
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    {Owned components going away}
    if AComponent = FSapiEngine then
      FSapiEngine := nil;
  end else if Operation = opInsert then begin
    {Check for new Sapi Engine}
    if AComponent is TApdSapiEngine then begin
      if not Assigned (FSapiEngine) then
        FSapiEngine := TApdSapiEngine (AComponent);
    end;
  end;
end;

procedure TApdCustomSapiPhone.PhraseHandler (var Msg : TMessage);
var
  LastReply : TApdPhraseType;
  LastRule : Integer;
  LastPhrase : string;

begin
  LastRule := 0;
  LastPhrase := '';
  if Msg.WParam = ApdSapiAskOperator then
    LastReply := ptOperator
  else if Msg.WParam = ApdSapiAskHangUp then
    LastReply := ptHangup
  else if Msg.WParam = ApdSapiAskBack then
    LastReply := ptBack
  else if Msg.WParam = ApdSapiAskWhere then
    LastReply := ptWhere
  else if Msg.WParam = ApdSapiAskHelp then
    LastReply := ptHelp
  else if Msg.WParam = ApdSapiAskRepeat then
    LastReply := ptRepeat
  else if Msg.WParam = ApdSapiAskSpeakFaster then
    LastReply := ptSpeakFaster
  else if Msg.WParam = ApdSapiAskSpeakSlower then
    LastReply := ptSpeakSlower
  else if Msg.WParam = ApdSapiAbort then
    LastReply := ptAbort
  else
  begin
    LastReply := ptCustom;
    LastRule := Msg.WParam;
    LastPhrase := GetPhraseData (Msg.LParam);
  end;
  UpdateStateMachine (LastReply, LastRule, LastPhrase);
end;

procedure TApdCustomSapiPhone.ExitAskFor (Reply : TApdSapiPhoneReply;
                                          Data : Pointer;
                                          SpokenData : string);
var
  FWorkTrigger : TApdAskForEventTrigger;

begin
  if not Assigned (FSapiEngine) then begin
    FInAskFor := False;
    FWorkTrigger := FEventTrigger;
    FCustomDataHandler := nil;
    FEventTrigger      := nil;
    Exit;
  end;
  FSapiEngine.Listening := False;
  FSapiEngine.Speaking := False;
  FSapiEngine.DeRegisterPhraseFinishHook (FInfo.SapiPhraseFinishHook);
  FInAskFor := False;
  FWorkTrigger := FEventTrigger;
  FCustomDataHandler := nil;
  FEventTrigger      := nil;
  if Assigned (FWorkTrigger) then
    FWorkTrigger (Reply, Data, SpokenData);
end;

procedure TApdCustomSapiPhone.UpdateStateMachine (LastReply : TApdPhraseType;
                                                  LastRule : Integer;
                                                  LastPhrase : string);
begin
  case LastReply of
    ptAbort :
      ExitAskFor (prAbort, nil, LastPhrase);
    ptOperator :
      ExitAskFor (prOperator, nil, LastPhrase);
    ptHangup   :
      ExitAskFor (prHangup, nil, LastPhrase);
    ptBack     :
      ExitAskFor (prBack, nil, LastPhrase);
    ptCustom   :
      if Assigned (FCustomDataHandler) then
        FCustomDataHandler (LastReply, LastRule, LastPhrase);
  end;
end;

procedure TApdCustomSapiPhone.SapiPhoneCallback (var Msg : TMessage);
begin
  case Msg.WParam of
    ApdSapiConnect :
      begin
      end;
    ApdSapiDisconnect :
      begin
        { Events may still be firing after components are destroyed - or while they
          are being destroyed.  Check for this in all of the event triggers }
        if csDestroying in ComponentState then
          Exit;
        if Assigned (FOnTapiDisconnect) then
          FOnTapiDisconnect (Self);
      end;
  end;
end;

procedure TApdCustomSapiPhone.SetNoAnswerMax (v : Integer);
begin
  if v <> FNoAnswerMax then
    FNoAnswerMax := v;
end;

procedure TApdCustomSapiPhone.SetNoAnswerTime (v : Integer);
begin
  if v <> FNoAnswerTime then
    FNoAnswerTime := v;
end;

procedure TApdCustomSapiPhone.SetDefaultPrompts (NewPrompt1 : string;
                                                 NewPrompt2 : string;
                                                 NewHelp1 : string;
                                                 NewHelp2 : string;
                                                 NewWhere1 : string;
                                                 NewWhere2 : string);
begin
  if NewPrompt1 <> '' then
    FInfo.FPrompts.Main := NewPrompt1
  else
    FInfo.FPrompts.Main := FPrompts.Main;

  if NewPrompt2 <> '' then
    FInfo.FPrompts.Main2 := NewPrompt2
  else
    FInfo.FPrompts.Main2 := FPrompts.Main2;

  if NewHelp1 <> '' then
    FInfo.FPrompts.Help := NewHelp1
  else
    FInfo.FPrompts.Help:= FPrompts.Help;

  if NewHelp2 <> '' then
    FInfo.FPrompts.Help2 := NewHelp2
  else
    FInfo.FPrompts.Help2:= FPrompts.Help2;

  if NewWhere1 <> '' then
    FInfo.FPrompts.Where := NewWhere1
  else
    FInfo.FPrompts.Where := FPrompts.Where2;

  if NewWhere2 <> '' then
    FInfo.FPrompts.Where2 := NewWhere2
  else
    FInfo.FPrompts.Where2 := FPrompts.Where2;
end;

procedure TApdCustomSapiPhone.SetNumDigits (v : Integer);
begin
  if v <> FNumDigits then
    FNumDigits := v;
end;

procedure TApdCustomSapiPhone.SetOptions (v : TApdSapiPhoneSettings);
begin
  if v <> FOptions then
    FOptions := v;
end;

procedure TApdCustomSapiPhone.SetSpellingEchoBack (v : Boolean);
begin
  if v <> FSpellingEchoBack then
    FSpellingEchoBack := v;
end;

procedure TApdCustomSapiPhone.Speak (const Text : string);
begin
  if Assigned (FSapiEngine) then
    FSapiEngine.Speak (Text);
end;


end.

