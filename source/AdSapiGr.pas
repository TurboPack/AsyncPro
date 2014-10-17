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
{*                   ADSAPIGR.PAS 4.06                   *}
{*********************************************************}
{* SAPI grammar definitions                              *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdSapiGr;

interface

resourcestring
  { AskFor xxx Prompts }
  ApdAskAreaCode = 'What is the area code?';
  ApdAskLastFour = 'What are the last four digits of the phone number?';
  ApdAskNextThree = 'What are the next three digits of the phone number?';
  ApdCannotGoBack = 'Cannot go back.';
  ApdCannotHangUp = 'Cannot hang up now.';
  ApdHangingUp = 'Goodbye.';
  ApdHelp = 'This is help.';
  ApdHelp2 = 'This is additional help.';
  ApdHelpVerify = 'You can speak yes or no, or press 1 for yes, or 2 for no.';
  ApdGoingBack = 'Going back.';
  ApdMain = 'Please say something.';
  ApdMain2 = 'Please say the something. - Shorter prompt';
  ApdMaxSpeed = 'I am speaking as fast as I can.';
  ApdMinSpeed = 'I am speaking as slowly as I can.';
  ApdOperator = 'Connecting to an operator.';
  ApdNoOperator = 'An operator is not available.';
  ApdNoSpeedChange = 'Cannot change speed.';
  ApdSpeakingFaster = 'Speaking faster.';
  ApdSpeakingSlower = 'Speaking slower.';
  ApdTooFewDigits = 'Not enough digits for the extension.';
  ApdTooManyDigits = 'Too many digits for the extension.';
  ApdUnrecognized = 'Sorry, I didn''t understand.';
  ApdVerifyPost = 'Is this correct?';
  ApdVerifyPre = 'I heard:';
  ApdWhere = 'You are somewhere.';
  ApdWhere2 = 'You are somewhere - Shorter prompt.';
  ApdYouHaveSpelled = 'You have spelled: ';

  { Error Codes }
  { SAPI Engine }
  ecApdNoSS     = 'Speech synthesis engine is not assigned';
  ecApdNoSR     = 'Speech recognition engine is not assigned';
  ecApdBadIndex = 'Invalid speech engine';
  ecNoSREngines = 'No speech recognition engines are installed';
  ecNoSSEngines = 'No speech synthesis engines are installed';
  { SAPI Phone }
  ecApdNoSapiEngine = 'No SAPI engine';
  ecApdNoPrompts = 'No prompts';
  ecApdBadDeviceNum = 'Unable to set device number: ';
  ecApdCannotCreateCOM = 'Cannot create COM Object';
  ecApdNotPhone = 'SAPI Engine is not phone optimized';

  { More error strings }
  {SS}
  ApdStrTTSERR_INVALIDINTERFACE          = 'Invalid interface';
  ApdStrTTSERR_OUTOFDISK                 = 'Out of disk space';
  ApdStrTTSERR_NOTSUPPORTED              = 'Not supported';
  ApdStrTTSERR_VALUEOUTOFRANGE           = 'Value out of range';
  ApdStrTTSERR_INVALIDWINDOW             = 'Invalid window';
  ApdStrTTSERR_INVALIDPARAM              = 'Invalid parameter';
  ApdStrTTSERR_INVALIDMODE               = 'Invalid mode';
  ApdStrTTSERR_INVALIDKEY                = 'Invalid key';
  ApdStrTTSERR_WAVEFORMATNOTSUPPORTED    = 'Wave format not supported';
  ApdStrTTSERR_INVALIDCHAR               = 'Invalid character';
  ApdStrTTSERR_QUEUEFULL                 = 'Queue full';
  ApdStrTTSERR_WAVEDEVICEBUSY            = 'Wave device busy';
  ApdStrTTSERR_NOTPAUSED                 = 'Not paused';
  ApdStrTTSERR_ALREADYPAUSED             = 'Already paused';
  {SR}
  ApdStrSRERR_OUTOFDISK                  = 'Out of disk space';
  ApdStrSRERR_NOTSUPPORTED               = 'Not supported';
  ApdStrSRERR_NOTENOUGHDATA              = 'Not enough data';
  ApdStrSRERR_VALUEOUTOFRANGE            = 'Value out of range';
  ApdStrSRERR_GRAMMARTOOCOMPLEX          = 'Grammar too complex';
  ApdStrSRERR_GRAMMARWRONGTYPE           = 'Grammar is of the wrong type';
  ApdStrSRERR_INVALIDWINDOW              = 'Invalid window';
  ApdStrSRERR_INVALIDPARAM               = 'Invalid parameter';
  ApdStrSRERR_INVALIDMODE                = 'Invalid mode';
  ApdStrSRERR_TOOMANYGRAMMARS            = 'Too many grammars';
  ApdStrSRERR_INVALIDLIST                = 'Invalid list';
  ApdStrSRERR_WAVEDEVICEBUSY             = 'Wave device busy';
  ApdStrSRERR_WAVEFORMATNOTSUPPORTED     = 'Wave format not supported';
  ApdStrSRERR_INVALIDCHAR                = 'Invalid character';
  ApdStrSRERR_GRAMTOOCOMPLEX             = 'Grammar too complex';
  ApdStrSRERR_GRAMTOOLARGE               = 'Grammar too large';
  ApdStrSRERR_INVALIDINTERFACE           = 'Invalid interface';
  ApdStrSRERR_INVALIDKEY                 = 'Invalid key';
  ApdStrSRERR_INVALIDFLAG                = 'Invalid flag';
  ApdStrSRERR_GRAMMARERROR               = 'Grammar error';
  ApdStrSRERR_INVALIDRULE                = 'Invalid rule';
  ApdStrSRERR_RULEALREADYACTIVE          = 'Rule already active';
  ApdStrSRERR_RULENOTACTIVE              = 'Rule not active';
  ApdStrSRERR_NOUSERSELECTED             = 'No users selected';
  ApdStrSRERR_BAD_PRONUNCIATION          = 'Bad pronunciation';
  ApdStrSRERR_DATAFILEERROR              = 'Data file error';
  ApdStrSRERR_GRAMMARALREADYACTIVE       = 'Grammar already active';
  ApdStrSRERR_GRAMMARNOTACTIVE           = 'Grammar not active';
  ApdStrSRERR_GLOBALGRAMMARALREADYACTIVE = 'Global grammar already active';
  ApdStrSRERR_LANGUAGEMISMATCH           = 'Language mismatch';
  ApdStrSRERR_MULTIPLELANG               = 'Multiple languages';
  ApdStrSRERR_LDGRAMMARNOWORDS           = 'No words in grammar';
  ApdStrSRERR_NOLEXICON                  = 'No lexicon';
  ApdStrSRERR_SPEAKEREXISTS              = 'Speaker exists';
  ApdStrSRERR_GRAMMARENGINEMISMATCH      = 'Grammar engine mismatch';
  ApdStrSRERR_BOOKMARKEXISTS             = 'Bookmark exists';
  ApdStrSRERR_BOOKMARKDOESNOTEXIST       = 'Bookmark does not exist';
  ApdStrSRERR_MICWIZARDCANCELED          = 'Microphone wizard cancelled';
  ApdStrSRERR_WORDTOOLONG                = 'Word too long';
  ApdStrSRERR_BAD_WORD                   = 'Bad word';
  ApdStrE_WRONGTYPE                      = 'Wrong type';
  ApdStrE_BUFFERTOOSMALL                 = 'Bufer too small';
  ApdStrE_UNKNOWN                        = 'Unknown error';

  { APRO SAPI Errors }
  ApdStrE_CANNOTCREATESS                 = 'Unable to create speech ' +
                                           'synthesis interface';
  ApdStrE_CANNOTCREATESR                 = 'Unable to create speech ' +
                                           'recognition interface';
  ApdStrE_CANNOTSETSPEAKER               = 'Cannot set speech recognition ' +
                                           'speaker';
  ApdStrE_CANNOTSETMIC                   = 'Cannot set microphone';
  ApdStrE_NOSAPI4                        = 'SAPI 4 Engine was not found';
  
  { Other things }
  scApdTrainGeneral = 'General Training';
  scApdTrainMic     = 'Microphone Training';
  scApdTrainGrammar = 'Phrase Training';

const
  scApdDefaultUser : string = 'APRO User';
  scApdDefaultMic  : string = 'Default Microphone';
  scApdTelMic      : string = 'Telephone';
  
  { Default grammars used by the TApdSapiPhone component -
    These are declared as constants.  It appears that if resource strings
    are used, the grammars wind up truncated. }

  { DefaultPhoneGrammar - This grammar is used as a skeleton by all the
    AskFor methods in the TApdSapiPhone component.  It provides a basic
    driver for the "ask the user for something" loop.  It provides a link to
    <MyGrammar> which is used to provide specific information needed for the
    data being asked. }
    
  ApdDefaultPhoneGrammar : string =
    '[Grammar]' + ^M^J +
    'LangId=1033' + ^M^J +
    'Type=CFG' + ^M^J +
    '' + ^M^J +
    '[Prompts]' + ^M^J +
    '; you need to modify the next few prompts' + ^M^J +
    'Main=Please say something.' + ^M^J +
    ';Main.2=Please say the something. - Shorter prompt' + ^M^J +
    'Where=You are somewhere.' + ^M^J +
    'Help=This is help.' + ^M^J +
    '' + ^M^J +
    'VerifyPre=I heard:' + ^M^J +
    'VerifyPost=Is this correct?' + ^M^J +
    'Unrecognized=Sorry, I didn''t understand.' + ^M^J +
    'SpeakingFaster=Speaking faster.' + ^M^J +
    'SpeakingSlower=Speaking slower.' + ^M^J +
    'HelpVerify=You can speak yes or no, or press 1 for yes, or 2 for no.' +
        ^M^J +
    '' + ^M^J +
    '[Settings]' + ^M^J +
    'Verify=0' + ^M^J +
    '; verification on grammars just respeaks the recognize string' + ^M^J +
    '' + ^M^J +
    '; you usually wont need to change wha''t below here' + ^M^J +
    '[<Start>]' + ^M^J +
    '<Start>=<AskGrammar>' + ^M^J +
    '<Start>=<Verify>' + ^M^J +
    '' + ^M^J +
    '[<AskGrammar>]' + ^M^J +
    '<AskGrammar>=<MyGrammar>' + ^M^J +
    '<AskGrammar>=(DefaultResponses)' + ^M^J +
    '' + ^M^J +
    '; **********************************************************************' +
        ^M^J +
    '; all controls should have these default responses' + ^M^J +
    '[(DefaultResponses)]' + ^M^J +
    '=[opt] (DefaultJunkBegin) (ValidDefault) [opt] (DefaultJunkEnd)' + ^M^J +
    '' + ^M^J +
    '[(ValidDefault)]' + ^M^J +
    '-3=(AskOperator)' + ^M^J +
    '-4=(AskHangUp)' + ^M^J +
    '-5=(AskBack)' + ^M^J +
    '-10=(AskWhere)' + ^M^J +
    '-11=(AskHelp)' + ^M^J +
    '-12=(AskRepeat)' + ^M^J +
    '-13=(AskSpeakFaster)' + ^M^J +
    '-14=(AskSpeakSlower)' + ^M^J +
    '' + ^M^J +
    '[(DefaultJunkBegin)]' + ^M^J +
    '=could you' + ^M^J +
    '=I want [opt] to' + ^M^J +
    '=please' + ^M^J +
    '' + ^M^J +
    '[(DefaultJunkEnd)]' + ^M^J +
    '=please' + ^M^J +
    '=now [opt] please' + ^M^J +
    '' + ^M^J +
    '[(AskOperator)]' + ^M^J +
    '=[opt] (TalkToOperator) (OperatorName)' + ^M^J +
    '' + ^M^J +
    '[(TalkToOperator)]' + ^M^J +
    '=talk to' + ^M^J +
    '=speak with' + ^M^J +
    '=connect me to' + ^M^J +
    '=give me' + ^M^J +
    '' + ^M^J +
    '[(OperatorName)]' + ^M^J +
    '=[opt] an operator' + ^M^J +
    '=someone real' + ^M^J +
    '=real person' + ^M^J +
    '=living person' + ^M^J +
    '=warm body' + ^M^J +
    '' + ^M^J +
    '[(AskHangUp)]' + ^M^J +
    '=hang up' + ^M^J +
    '=goodbye' + ^M^J +
    '' + ^M^J +
    '[(AskBack)]' + ^M^J +
    '=scratch that' + ^M^J +
    '=go back' + ^M^J +
    '=undo that' + ^M^J +
    '=I made a mistake' + ^M^J +
    '=never mind' + ^M^J +
    '' + ^M^J +
    '[(AskWhere)]' + ^M^J +
    '=where am I' + ^M^J +
    '=where were we' + ^M^J +
    '=what am I doing' + ^M^J +
    '=what''s going on' + ^M^J +
    '' + ^M^J +
    '[(AskHelp)]' + ^M^J +
    '=[opt] some help [opt] me' + ^M^J +
    '=give me help' + ^M^J +
    '=what can I say' + ^M^J +
    '=list [opt] voice commands' + ^M^J +
    '=what are my options' + ^M^J +
    '=tell me what I can say' + ^M^J +
    '' + ^M^J +
    '[(AskRepeat)]' + ^M^J +
    '=what' + ^M^J +
    '=what did you say' + ^M^J +
    '=repeat [opt] that' + ^M^J +
    '=huh' + ^M^J +
    '' + ^M^J +
    '[(AskSpeakFaster)]' + ^M^J +
    '=speak faster' + ^M^J +
    '=talk faster' + ^M^J +
    '=speak more quickly' + ^M^J +
    '=talk more quickly' + ^M^J +
    '' + ^M^J +
    '[(AskSpeakSlower)]' + ^M^J +
    '=speak slower' + ^M^J +
    '=talk slower' + ^M^J +
    '=speak more slowly' + ^M^J +
    '=talk more slowly' + ^M^J +
    '' + ^M^J +
    '; entries necessary for verification to work' + ^M^J +
    '[<Verify>]' + ^M^J +
    '<Verify>=(YesNo)' + ^M^J +
    '<Verify>=(DefaultResponses)' + ^M^J;

  { AskForDateGrammar - This grammar provides everything needed for asking
    the user for a date. }

  ApdAskForDateGrammar : string =
    '[<MyGrammar>]' + ^M^J +
    '<MyGrammar>=(TheDate)' + ^M^J +
    '' + ^M^J +
    '[(TheDate)]' + ^M^J +
    '-500=<Date>' + ^M^J +
    '' + ^M^J +
    '[<Year>]' + ^M^J +
    '<Year>=<DoubleNumber>' + ^M^J +
    '<Year>=<Less1000000Not>' + ^M^J +
    '<Year>=<Less1000Not>' + ^M^J +
    '<Year>=<Less100Not>' + ^M^J +
    '// Double-number cominations, like "ninteen sixty"' + ^M^J +
    '<DoubleNumber>=<Less100Not> <DoubleDigit>' + ^M^J +
    '<DoubleNumber>=<Less100Not> oh "0" <1_9>' + ^M^J +
    '<DoubleNumber>=<Less100Not> hundred "00"' + ^M^J +
    '' + ^M^J +
    '[<Month>]' + ^M^J +
    '<Month>=january' + ^M^J +
    '<Month>=february' + ^M^J +
    '<Month>=march' + ^M^J +
    '<Month>=april' + ^M^J +
    '<Month>=may' + ^M^J +
    '<Month>=june' + ^M^J +
    '<Month>=july' + ^M^J +
    '<Month>=august' + ^M^J +
    '<Month>=september' + ^M^J +
    '<Month>=october' + ^M^J +
    '<Month>=november' + ^M^J +
    '<Month>=december' + ^M^J +
    '' + ^M^J +
    '[<MonthNum>]' + ^M^J +
    '<MonthNum>=1' + ^M^J +
    '<MonthNum>=2' + ^M^J +
    '<MonthNum>=3' + ^M^J +
    '<MonthNum>=4' + ^M^J +
    '<MonthNum>=5' + ^M^J +
    '<MonthNum>=6' + ^M^J +
    '<MonthNum>=7' + ^M^J +
    '<MonthNum>=8' + ^M^J +
    '<MonthNum>=9' + ^M^J +
    '<MonthNum>=10' + ^M^J +
    '<MonthNum>=11' + ^M^J +
    '<MonthNum>=12' + ^M^J +
    '' + ^M^J +
    '[<Date>]' + ^M^J +
    '<Date>=<Month> " " <Date2>' + ^M^J +
    '<Date>=<MonthNum> " " <Date2>' + ^M^J +
    '<Date>=[opt] <NextLast> <Day>' + ^M^J +
    '<Date>=<NextLast> <TimePeriod>' + ^M^J +
    '<Date>=<NextLast> <Month>' + ^M^J +
    '<Date>=<RelDay>' + ^M^J +
    '<Date2>=<Ordinal> [opt] <Date3>' + ^M^J +
    '<Date2>=<1_31>' + ^M^J +
    '<Date2>=<YearMore31>' + ^M^J +
    '<Date3>=", " <Year>' + ^M^J +
    '<YearMore31>=<DoubleNumber>' + ^M^J +
    '<YearMore31>=<Less1000000Not>' + ^M^J +
    '<YearMore31>=<Less1000Not>' + ^M^J +
    '<YearMore31>=<32_99>' + ^M^J +
    '<1_31>=<1_9>' + ^M^J +
    '<1_31>=<10_19>' + ^M^J +
    '<1_31>=<20_31>' + ^M^J +
    '// Double-number cominations, like "ninteen sixty"' + ^M^J +
    '<DoubleNumber>=<Less100Not> <DoubleDigit>' + ^M^J +
    '<DoubleNumber>=<Less100Not> oh "0" <1_9>' + ^M^J +
    '<DoubleNumber>=<Less100Not> hundred "00"' + ^M^J +
    '<NextLast>=next' + ^M^J +
    '<NextLast>=last' + ^M^J +
    '<Day>=monday' + ^M^J +
    '<Day>=tuesday' + ^M^J +
    '<Day>=wednesday' + ^M^J +
    '<Day>=thursday' + ^M^J +
    '<Day>=friday' + ^M^J +
    '<Day>=saturday' + ^M^J +
    '<Day>=sunday' + ^M^J +
    '<RelDay>=today' + ^M^J +
    '<RelDay>=yesterday' + ^M^J +
    '<RelDay>=tomorrow' + ^M^J +
    '<TimePeriod>=week' + ^M^J +
    '<TimePeriod>=month' + ^M^J +
    '' + ^M^J +
    '// Less than 1,000,000,000,000,000, not padded with zeros' + ^M^J +
    '<Less1000000000000000Not>=<Less100Not> <Less1000000000000000Not2>' +
        ^M^J +
    '<Less1000000000000000Not>=<Less1000Not> <Less1000000000000000Not2>' +
        ^M^J +
    '<Less1000000000000000Not2>=trillion "000000000000"' + ^M^J +
    '<Less1000000000000000Not2>=trillion [opt] and <Less1000000000000Pad>' +
        ^M^J +
    '// Less than 1,000,000,000,000, padded with zeros' + ^M^J +
    '<Less1000000000000Pad>="000" <Less1000000000Pad>' + ^M^J +
    '<Less1000000000000Pad>=billion [opt] and "001" <Less1000000000Pad>' +
        ^M^J +
    '<Less1000000000000Pad>=<Less1000Pad> <Less1000000000000Pad2>' + ^M^J +
    '<Less1000000000000Pad>=<Less1000Pad> <Less1000000000000Pad2>' + ^M^J +
    '<Less1000000000000Pad2>=billion "000000000"' + ^M^J +
    '<Less1000000000000Pad2>=billion [opt] and <Less1000000000Pad>' + ^M^J +
    '// Less than 1,000,000,000,000, not padded with zeros' + ^M^J +
    '<Less1000000000000Not>=<Less100Not> <Less1000000000000Not2>' + ^M^J +
    '<Less1000000000000Not>=<Less1000Not> <Less1000000000000Not2>' + ^M^J +
    '<Less1000000000000Not2>=billion "000000000"' + ^M^J +
    '<Less1000000000000Not2>=billion [opt] and <Less1000000000Pad>' + ^M^J +
    '// Less than 1,000,000,000, padded with zeros' + ^M^J +
    '<Less1000000000Pad>="000" <Less1000000Pad>' + ^M^J +
    '<Less1000000000Pad>=million [opt] and "001" <Less1000000Pad>' + ^M^J +
    '<Less1000000000Pad>=<Less1000Pad> <Less1000000000Pad2>' + ^M^J +
    '<Less1000000000Pad2>=million "000000"' + ^M^J +
    '<Less1000000000Pad2>=million [opt] and <Less1000000Pad>' + ^M^J +
    '// Less than 1,000,000,000, not padded with zeros' + ^M^J +
    '<Less1000000000Not>=<Less100Not> <Less1000000000Not2>' + ^M^J +
    '<Less1000000000Not>=<Less1000Not> <Less1000000000Not2>' + ^M^J +
    '<Less1000000000Not2>=million "000000"' + ^M^J +
    '<Less1000000000Not2>=million [opt] and <Less1000000Pad>' + ^M^J +
    '// Less than 1,000,000, padded with zeros' + ^M^J +
    '<Less1000000Pad>="000" <Less1000Pad>' + ^M^J +
    '<Less1000000Pad>=thousand [opt] and "001" <Less1000Pad>' + ^M^J +
    '<Less1000000Pad>=<Less1000Pad> <Less1000000Pad2>' + ^M^J +
    '<Less1000000Pad2>=thousand "000"' + ^M^J +
    '<Less1000000Pad2>=thousand [opt] and <Less1000Pad>' + ^M^J +
    '' + ^M^J +
    '[<Ordinal>]' + ^M^J +
    '<Ordinal>=<OrdinalLess1000000000000000Not>' + ^M^J +
    '<Ordinal>=<OrdinalLess1000000000000Not>' + ^M^J +
    '<Ordinal>=<OrdinalLess1000000000Not>' + ^M^J +
    '<Ordinal>=<OrdinalLess1000000Not>' + ^M^J +
    '<Ordinal>=<OrdinalLess1000Not>' + ^M^J +
    '<Ordinal>=<OrdinalLess100Not>' + ^M^J +
    '<Orindal>=<Less100Not> hundredth "00"' + ^M^J +
    '<OrdinalLess1000000000000000Not>=<Less100Not> trillionth "000000000000"' + ^M^J +
    '<OrdinalLess1000000000000000Not>=<Less100Not> trillion [opt] and ' +
        '<OrdinalLess1000000000000Pad>' + ^M^J +
    '<OrdinalLess1000000000000000Not>=<Less1000Not> trillionth "000000000000"' + ^M^J +
    '<OrdinalLess1000000000000000Not>=<Less1000Not> trillion [opt] and ' +
      '<OrdinalLess1000000000000Pad>' + ^M^J +
    '<OrdinalLess1000000000000Pad>="000" <OrdinalLess1000000000Pad>' + ^M^J +
    '<OrdinalLess1000000000000Pad>=billion [opt] and "001" ' +
        '<OrdinalLess1000000000Pad>' + ^M^J +
    '<OrdinalLess1000000000000Pad>=<Less1000Pad> ' +
        '<OrdinalLess1000000000000Pad2>' + ^M^J +
    '<OrdinalLess1000000000000Pad>=<Less1000Pad> ' +
        '<OrdinalLess1000000000000Pad2>' + ^M^J +
    '<OrdinalLess1000000000000Pad2>=billionth "000000000"' + ^M^J +
    '<OrdinalLess1000000000000Pad2>=billion [opt] and ' +
        '<OrdinalLess1000000000Pad>' + ^M^J +
    '<OrdinalLess1000000000000Not>=<Less100Not> ' +
        '<OrdinalLess1000000000000Not2>' + ^M^J +
    '<OrdinalLess1000000000000Not>=<Less1000Not> ' +
        '<OrdinalLess1000000000000Not2>' + ^M^J +
    '<OrdinalLess1000000000000Not2>=billionth "000000000"' + ^M^J +
    '<OrdinalLess1000000000000Not2>=billion [opt] and ' +
        '<OrdinalLess1000000000Pad>' + ^M^J +
    '<OrdinalLess1000000000Pad>="000" <OrdinalLess1000000Pad>' + ^M^J +
    '<OrdinalLess1000000000Pad>=million [opt] and "001" ' +
        '<OrdinalLess1000000Pad>' + ^M^J +
    '<OrdinalLess1000000000Pad>=<Less1000Pad> <OrdinalLess1000000000Pad2>' +
        ^M^J +
    '<OrdinalLess1000000000Pad2>=millionth "000000"' + ^M^J +
    '<OrdinalLess1000000000Pad2>=million [opt] and <OrdinalLess1000000Pad>' +
         ^M^J +
    '<OrdinalLess1000000000Not>=<Less100Not> <OrdinalLess1000000000Not2>' +
        ^M^J +
    '<OrdinalLess1000000000Not>=<Less1000Not> <OrdinalLess1000000000Not2>' +
        ^M^J +
    '<OrdinalLess1000000000Not2>=millionth "000000"' + ^M^J +
    '<OrdinalLess1000000000Not2>=million [opt] and <OrdinalLess1000000Pad>' +
        ^M^J +
    '// Ordinal Less than 1,000,000, padded with zeros, without ending' + ^M^J +
    '<OrdinalLess1000000Pad>="000" <OrdinalLess1000Pad>' + ^M^J +
    '<OrdinalLess1000000Pad>=thousand [opt] and "001" <OrdinalLess1000Pad>' +
        ^M^J +
    '<OrdinalLess1000000Pad>=<Less1000Pad> <OrdinalLess1000000Pad2>' + ^M^J +
    '<OrdinalLess1000000Pad2>=thousandth "000"' + ^M^J +
    '<OrdinalLess1000000Pad2>=thousandth [opt] and <OrdinalLess1000Pad>' +
        ^M^J +
    '// Ordinal Less than 1,000,000, not padded with zeros, without ending' +
        ^M^J +
    '<OrdinalLess1000000Not>=<1_9> thousandth "000"' + ^M^J +
    '<OrdinalLess1000000Not>=<1_9> thousand [opt] and <OrdinalLess1000Pad>' +
        ^M^J +
    '<OrdinalLess1000000Not>=<DoubleDigit> <OrdinalLess1000000Not2>' + ^M^J +
    '<OrdinalLess1000000Not>=<TripleDigit> <OrdinalLess1000000Not2>' + ^M^J +
    '<OrdinalLess1000000Not2>=thousandth "000"' + ^M^J +
    '<OrdinalLess1000000Not2>=thousand [opt] and <OrdinalLess1000Pad>' + ^M^J +
    '// Ordinal Less than 1000, padded with zeros, without ending' + ^M^J +
    '<OrdinalLess1000Pad>="0" <OrdinalLess100Pad>' + ^M^J +
    '<OrdinalLess1000Pad>=<OrdinalTripleDigit>' + ^M^J +
    '// Ordinal Less than 1000, not padded with zeros, without ending' + ^M^J +
    '<OrdinalLess1000Not>=<OrdinalTripleDigit>' + ^M^J +
    '' + ^M^J +
    '[<1_9>]' + ^M^J +
    '<1_9>=1' + ^M^J +
    '<1_9>=2' + ^M^J +
    '<1_9>=3' + ^M^J +
    '<1_9>=4' + ^M^J +
    '<1_9>=5' + ^M^J +
    '<1_9>=6' + ^M^J +
    '<1_9>=7' + ^M^J +
    '<1_9>=8' + ^M^J +
    '<1_9>=9' + ^M^J +
    '' + ^M^J +
    '[<Ordinal1_9>]' + ^M^J +
    '<Ordinal1_9>=first "1"' + ^M^J +
    '<Ordinal1_9>=second "2"' + ^M^J +
    '<Ordinal1_9>=third "3"' + ^M^J +
    '<Ordinal1_9>=fourth "4"' + ^M^J +
    '<Ordinal1_9>=fifth "5"' + ^M^J +
    '<Ordinal1_9>=sixth "6"' + ^M^J +
    '<Ordinal1_9>=seventh "7"' + ^M^J +
    '<Ordinal1_9>=eighth "8"' + ^M^J +
    '<Ordinal1_9>=ninth "9"' + ^M^J +
    '' + ^M^J +
    '[<0_9>]' + ^M^J +
    '<0_9>=zero "0"' + ^M^J +
    '<0_9>=oh "0"' + ^M^J +
    '<0_9>=<1_9>' + ^M^J +
    '' + ^M^J +
    '[<Ordinal0_9>]' + ^M^J +
    '// Ordinal Zero through nine, without ending' + ^M^J +
    '<Ordinal0_9>=zeroth "0"' + ^M^J +
    '<Ordinal0_9>=<Ordinal1_9>' + ^M^J +
    '' + ^M^J +
    '[<10_19>]' + ^M^J +
    '<10_19>=10' + ^M^J +
    '<10_19>=11' + ^M^J +
    '<10_19>=12' + ^M^J +
    '<10_19>=13' + ^M^J +
    '<10_19>=14' + ^M^J +
    '<10_19>=15' + ^M^J +
    '<10_19>=16' + ^M^J +
    '<10_19>=17' + ^M^J +
    '<10_19>=18' + ^M^J +
    '<10_19>=19' + ^M^J +
    '' + ^M^J +
    '[<Ordinal10_19>]' + ^M^J +
    '<Ordinal10_19>=tenth "10"' + ^M^J +
    '<Ordinal10_19>=eleventh "11"' + ^M^J +
    '<Ordinal10_19>=twelfth "12"' + ^M^J +
    '<Ordinal10_19>=thirteenth "13"' + ^M^J +
    '<Ordinal10_19>=fourteenth "14"' + ^M^J +
    '<Ordinal10_19>=fifteenth "15"' + ^M^J +
    '<Ordinal10_19>=sixteenth "16"' + ^M^J +
    '<Ordinal10_19>=seventeenth "17"' + ^M^J +
    '<Ordinal10_19>=eighteenth "18"' + ^M^J +
    '<Ordinal10_19>=nineteenth "19"' + ^M^J +
    '' + ^M^J +
    '[<20_99>]' + ^M^J +
    '<20_99>=<20_31>' + ^M^J +
    '<20_99>=<32_99>' + ^M^J +
    '' + ^M^J +
    '[<20_31>]' + ^M^J +
    '<20_31>=20' + ^M^J +
    '<20_31>=twenty "2" <1_9>' + ^M^J +
    '<20_31>=30' + ^M^J +
    '' + ^M^J +
    '[<32_99>]' + ^M^J +
    '<32_99>=thirty "3" <1_9>' + ^M^J +
    '<32_99>=forty "40"' + ^M^J +
    '<32_99>=forty "4" <1_9>' + ^M^J +
    '<32_99>=fifty "50"' + ^M^J +
    '<32_99>=fifty "5" <1_9>' + ^M^J +
    '<32_99>=sixty "60"' + ^M^J +
    '<32_99>=sixty "6" <1_9>' + ^M^J +
    '<32_99>=seventy "70"' + ^M^J +
    '<32_99>=seventy "7" <1_9>' + ^M^J +
    '<32_99>=eighty "80"' + ^M^J +
    '<32_99>=eighty "8" <1_9>' + ^M^J +
    '<32_99>=ninety "90"' + ^M^J +
    '<32_99>=ninety "9" <1_9>' + ^M^J +
    '' + ^M^J +
    '[<Ordinal20_99>]' + ^M^J +
    '<Ordinal20_99>=twentieth "20"' + ^M^J +
    '<Ordinal20_99>=twenty "2" <Ordinal1_9>' + ^M^J +
    '<Ordinal20_99>=thirtieth "30"' + ^M^J +
    '<Ordinal20_99>=thirty "3" <Ordinal1_9>' + ^M^J +
    '<Ordinal20_99>=fortieth "40"' + ^M^J +
    '<Ordinal20_99>=forty "4" <Ordinal1_9>' + ^M^J +
    '<Ordinal20_99>=fiftieth "50"' + ^M^J +
    '<Ordinal20_99>=fifty "5" <Ordinal1_9>' + ^M^J +
    '<Ordinal20_99>=sixtieth "60"' + ^M^J +
    '<Ordinal20_99>=sixty "6" <Ordinal1_9>' + ^M^J +
    '<Ordinal20_99>=seventieth "70"' + ^M^J +
    '<Ordinal20_99>=seventy "7" <Ordinal1_9>' + ^M^J +
    '<Ordinal20_99>=eightieth "80"' + ^M^J +
    '<Ordinal20_99>=eighty "8" <Ordinal1_9>' + ^M^J +
    '<Ordinal20_99>=ninetieth "90"' + ^M^J +
    '<Ordinal20_99>=ninety "9" <Ordinal1_9>' + ^M^J +
    '' + ^M^J +
    '[<DoubleDigit>]' + ^M^J +
    '<DoubleDigit>=<20_99>' + ^M^J +
    '<DoubleDigit>=<10_19>' + ^M^J +
    '' + ^M^J +
    '[<OrdinalDoubleDigit>]' + ^M^J +
    '<OrdinalDoubleDigit>=<Ordinal20_99>' + ^M^J +
    '<OrdinalDoubleDigit>=<Ordinal10_19>' + ^M^J +
    '' + ^M^J +
    '[<TripleDigit>]' + ^M^J +
    '<TripleDigit>=hundred "1" <Less100Pad>' + ^M^J +
    '<TripleDigit>=<1_9> <TripleDigit2>' + ^M^J +
    '<TripleDigit2>=hundred [opt] and <Less100Pad>' + ^M^J +
    '<TripleDigit2>=hundred "00"' + ^M^J +
    '' + ^M^J +
    '[<OrdinalTripleDigit>]' + ^M^J +
    '<OrdinalTripleDigit>=hundred "1" <OrdinalLess100Pad>' + ^M^J +
    '<OrdinalTripleDigit>=<1_9> hundred [opt] and <OrdinalLess100Pad>' + ^M^J +
    '<OrdinalTripleDigit>=<1_9> hundredth "00"' + ^M^J +
    '' + ^M^J +
    '[<Less100Not>]' + ^M^J +
    '// Less that 100, not padded with zeros' + ^M^J +
    '<Less100Not>=<1_9>' + ^M^J +
    '<Less100Not>=<DoubleDigit>' + ^M^J +
    '<Less100Not>=zero "0"' + ^M^J +
    '' + ^M^J +
    '[<OrdinalLess100Not>]' + ^M^J +
    '// Ordinal, Less that 100, not padded with zeros, without ending' + ^M^J +
    '<OrdinalLess100Not>=<Ordinal1_9>' + ^M^J +
    '<OrdinalLess100Not>=<OrdinalDoubleDigit>' + ^M^J +
    '<OrdinalLess100Not>=zeroeth "0"' + ^M^J +
    '' + ^M^J +
    '[<Less100Pad>]' + ^M^J +
    '// Less that 100, padded with zeros' + ^M^J +
    '<Less100Pad>="0" <1_9>' + ^M^J +
    '<Less100Pad>=<DoubleDigit>' + ^M^J +
    '<Less100Pad>=zero "00"' + ^M^J +
    '' + ^M^J +
    '[<OrdinalLess100Pad>]' + ^M^J +
    '// Ordinal Less that 100, padded with zeros, without ending' + ^M^J +
    '<OrdinalLess100Pad>="0" <Ordinal1_9>' + ^M^J +
    '<OrdinalLess100Pad>=<OrdinalDoubleDigit>' + ^M^J +
    '<OrdinalLess100Pad>=zeroeth "00"' + ^M^J +
    '' + ^M^J +
    '[<Less1000Not>]' + ^M^J +
    '// Less than 1000, not padded with zeros' + ^M^J +
    '<Less1000Not>=<TripleDigit>' + ^M^J +
    '' + ^M^J +
    '[<Less1000Pad>]' + ^M^J +
    '// Less than 1000, padded with zeros' + ^M^J +
    '<Less1000Pad>="0" <Less100Pad>' + ^M^J +
    '<Less1000Pad>=<TripleDigit>' + ^M^J +
    '' + ^M^J +
    '[<Less1000000Not>]' + ^M^J +
    '// Less than 1,000,000, not padded with zeros' + ^M^J +
    '<Less1000000Not>=<1_9> thousand "000"' + ^M^J +
    '<Less1000000Not>=<1_9> thousand [opt] and <Less1000Pad>' + ^M^J +
    '<Less1000000Not>=<DoubleDigit> <Less1000000Not2>' + ^M^J +
    '<Less1000000Not>=<TripleDigit> <Less1000000Not2>' + ^M^J +
    '<Less1000000Not2>=thousand "000"' + ^M^J +
    '<Less1000000Not2>=thousand [opt] and <Less1000Pad>' + ^M^J;

  ApdAskForExtensionGrammar : string =
    '[<MyGrammar>]' + ^M^J +
    '<MyGrammar>=(Extension)' + ^M^J +
    '' + ^M^J +
    '[(Extension)]' + ^M^J +
    '-400=(ExtensionDigits)' + ^M^J +
    '' + ^M^J +
    '[(ExtensionDigits)]' + ^M^J +
    '=0' + ^M^J +
    '=1' + ^M^J +
    '=2' + ^M^J +
    '=3' + ^M^J +
    '=4' + ^M^J +
    '=5' + ^M^J +
    '=6' + ^M^J +
    '=7' + ^M^J +
    '=8' + ^M^J +
    '=9' + ^M^J;

  ApdAskForPhoneNumberGrammar : string =
    '[<MyGrammar>]' + ^M^J +
    '<MyGrammar>=(GetPhoneNumber)' + ^M^J +
    '' + ^M^J +
    '[(GetPhoneNumber)]' + ^M^J +
    '-600=<PhoneNumber>' + ^M^J +
    '' + ^M^J +
    '[<PhoneNumber>]' + ^M^J +
    '<PhoneNumber>=area code <ThreeDigits> [opt] <DashSlash> "-" ' +
        '<ThreeDigits> [opt] <DashSlash> "-" <FourDigits>' + ^M^J +
    '<PhoneNumber>=<ThreeDigits> [opt] <DashSlash> "-" <FourDigits>' + ^M^J +
    '<PhoneNumber>=<ThreeDigits> [opt] <DashSlash> "-" <ThreeDigits> [opt] ' +
        '<DashSlash> "-" <FourDigits>' + ^M^J +
    '<PhoneNumber>=1 <ThreeDigits> [opt] <DashSlash> "-" <ThreeDigits> ' +
        '[opt] <DashSlash> "-" <FourDigits>' + ^M^J +
    '<PhoneNumber>=1 8 hundred "00-" <ThreeDigits> [opt] <DashSlash> "-" ' +
        '<FourDigits>' + ^M^J +
    '<PhoneNumber>=1 9 hundred "00-" <ThreeDigits> [opt] <DashSlash> "-" ' +
        '<FourDigits>' + ^M^J +
{   '<PhoneNumber>=<ZeroOh> one one [opt] <DashSlash> "011-" <ThreeDigits> ' +
        '[opt] <DashSlash> "-" <Digits>' + ^M^J +
    '<PhoneNumber>=X. "x" [1+] <0_9>' + ^M^J +
    '<PhoneNumber>=extension "x" [1+] <0_9>' + ^M^J + }
    '<ThreeDigits>=<0_9> <0_9> <0_9>' + ^M^J +
    '<ThreeDigits>=<0_9> <DoubleDigit>' + ^M^J +
    '<ThreeDigits>=<TripleDigit>' + ^M^J +
    '<FourDigits>=<0_9> <ThreeDigits>' + ^M^J +
    '<FourDigits>=<DoubleDigit> <Last2Digits>' + ^M^J +
    '<Last2Digits>=<DoubleDigit>' + ^M^J +
    '<Last2Digits>=<0_9> <0_9>' + ^M^J +
    '<Last2Digits>=hundred "00"' + ^M^J +
    '<DashSlash>=-\dash' + ^M^J +
    '<DashSlash>=dash' + ^M^J +
    '<DashSlash>=/\slash' + ^M^J +
    '<DashSlash>=slash' + ^M^J +
    '<ZeroOh>=zero' + ^M^J +
    '<ZeroOh>=oh' + ^M^J +
    '' + ^M^J +
    '[<1_9>]' + ^M^J +
    '<1_9>=1' + ^M^J +
    '<1_9>=2' + ^M^J +
    '<1_9>=3' + ^M^J +
    '<1_9>=4' + ^M^J +
    '<1_9>=5' + ^M^J +
    '<1_9>=6' + ^M^J +
    '<1_9>=7' + ^M^J +
    '<1_9>=8' + ^M^J +
    '<1_9>=9' + ^M^J +
    '' + ^M^J +
    '[<0_9>]' + ^M^J +
    '<0_9>=zero "0"' + ^M^J +
    '<0_9>=oh "0"' + ^M^J +
    '<0_9>=<1_9>' + ^M^J +
    '' + ^M^J +
    '[<10_19>]' + ^M^J +
    '<10_19>=10' + ^M^J +
    '<10_19>=11' + ^M^J +
    '<10_19>=12' + ^M^J +
    '<10_19>=13' + ^M^J +
    '<10_19>=14' + ^M^J +
    '<10_19>=15' + ^M^J +
    '<10_19>=16' + ^M^J +
    '<10_19>=17' + ^M^J +
    '<10_19>=18' + ^M^J +
    '<10_19>=19' + ^M^J +
    '' + ^M^J +
    '[<20_99>]' + ^M^J +
    '<20_99>=<20_31>' + ^M^J +
    '<20_99>=<32_99>' + ^M^J +
    '' + ^M^J +
    '[<20_31>]' + ^M^J +
    '<20_31>=20' + ^M^J +
    '<20_31>=twenty "2" <1_9>' + ^M^J +
    '<20_31>=30' + ^M^J +
    '' + ^M^J +
    '[<32_99>]' + ^M^J +
    '<32_99>=thirty "3" <1_9>' + ^M^J +
    '<32_99>=40' + ^M^J +
    '<32_99>=forty "4" <1_9>' + ^M^J +
    '<32_99>=50' + ^M^J +
    '<32_99>=fifty "5" <1_9>' + ^M^J +
    '<32_99>=60' + ^M^J +
    '<32_99>=sixty "6" <1_9>' + ^M^J +
    '<32_99>=70' + ^M^J +
    '<32_99>=seventy "7" <1_9>' + ^M^J +
    '<32_99>=80' + ^M^J +
    '<32_99>=eighty "8" <1_9>' + ^M^J +
    '<32_99>=90' + ^M^J +
    '<32_99>=ninety "9" <1_9>' + ^M^J +
    '' + ^M^J +
    '[<DoubleDigit>]' + ^M^J +
    '<DoubleDigit>=<20_99>' + ^M^J +
    '<DoubleDigit>=<10_19>' + ^M^J +
    '' + ^M^J +
    '[<OrdinalDoubleDigit>]' + ^M^J +
    '<OrdinalDoubleDigit>=<Ordinal20_99>' + ^M^J +
    '<OrdinalDoubleDigit>=<Ordinal10_19>' + ^M^J +
    '' + ^M^J +
    '[<TripleDigit>]' + ^M^J +
    '<TripleDigit>=hundred "1" <Less100Pad>' + ^M^J +
    '<TripleDigit>=<1_9> <TripleDigit2>' + ^M^J +
    '<TripleDigit2>=hundred [opt] and <Less100Pad>' + ^M^J +
    '<TripleDigit2>=hundred "00"' + ^M^J +
    '' + ^M^J +
    '[<Less100Not>]' + ^M^J +
    '// Less that 100, not padded with zeros' + ^M^J +
    '<Less100Not>=<1_9>' + ^M^J +
    '<Less100Not>=<DoubleDigit>' + ^M^J +
    '<Less100Not>=zero "0"' + ^M^J +
    '' + ^M^J +
    '[<Less100Pad>]' + ^M^J +
    '// Less that 100, padded with zeros' + ^M^J +
    '<Less100Pad>="0" <1_9>' + ^M^J +
    '<Less100Pad>=<DoubleDigit>' + ^M^J +
    '<Less100Pad>=zero "00"' + ^M^J;

  ApdAskForSpellingGrammar : string =
    '[<MyGrammar>]' + ^M^J +
    '<MyGrammar>=(Spelling)' + ^M^J +
    '' + ^M^J +
    '[(Spelling)]' + ^M^J +
    '-200=(Letter)' + ^M^J +
    '-201=(DoneSpelling)' + ^M^J +
    '-202=(EraseSpelling)' + ^M^J +
    '-203=(SpellingCorrection)' + ^M^J +
    '-204=(WhatHaveISpelled)' + ^M^J +
    '' + ^M^J +
    '[(Letter)]' + ^M^J +
    '=A' + ^M^J +
    '=B' + ^M^J +
    '=C' + ^M^J +
    '=D' + ^M^J +
    '=E' + ^M^J +
    '=F' + ^M^J +
    '=G' + ^M^J +
    '=H' + ^M^J +
    '=I' + ^M^J +
    '=J' + ^M^J +
    '=K' + ^M^J +
    '=L' + ^M^J +
    '=M' + ^M^J +
    '=N' + ^M^J +
    '=O' + ^M^J +
    '=P' + ^M^J +
    '=Q' + ^M^J +
    '=R' + ^M^J +
    '=S' + ^M^J +
    '=T' + ^M^J +
    '=U' + ^M^J +
    '=V' + ^M^J +
    '=W' + ^M^J +
    '=X' + ^M^J +
    '=Y' + ^M^J +
    '=Z' + ^M^J +
    '' + ^M^J +
    '[(DoneSpelling)]' + ^M^J +
    '=thats it' + ^M^J +
    '=opt ime done' + ^M^J +
    '=thats all' + ^M^J +
    '=finished' + ^M^J +
    '=done' + ^M^J +
    '' + ^M^J +
    '[(EraseSpelling)]' + ^M^J +
    '=clear [opt] that' + ^M^J +
    '=start over' + ^M^J +
    '' + ^M^J +
    '[(SpellingCorrection)]' + ^M^J +
    '=delete' + ^M^J +
    '=oops' + ^M^J +
    '' + ^M^J +
    '[(WhatHaveISpelled)]' + ^M^J +
    '=what did I spell' + ^M^J +
    '=repeat it back to me' + ^M^J +
    '=what have I spelled' + ^M^J +
    '=what have I said' + ^M^J;

  ApdAskForTimeGrammar : string =
    '[<MyGrammar>]' + ^M^J +
    '<MyGrammar>=(GetTime)' + ^M^J +
    '' + ^M^J +
    '[(GetTime)]' + ^M^J +
    '-700=<Time>' + ^M^J +
    '' + ^M^J +
    '[<Time>]' + ^M^J +
    '<Time>=<Hours> <Time2>' + ^M^J +
    '<Time>=midnight "12:00 AM"' + ^M^J +
    '<Time>=noon "12:00 PM"' + ^M^J +
    '<Time>=quarter <Time4>' + ^M^J +
    '<Time>=half <Time5>' + ^M^J +
    '<Time>=<Natural> <Time3>' + ^M^J +
    '<Time>=<Natural> <Time4>' + ^M^J + 
    '<Time2>=o''clock ":00" [opt] <AMPM>' + ^M^J +
    '<Time2>=":" <Minutes> [opt] <AMPM>' + ^M^J +
    '<Time2>=":00" [opt] <AMPM>' + ^M^J +
    '<Time3>=hundred hours ":00"' + ^M^J +
    '<Time3>=":" <Minutes> hours' + ^M^J +
    '<Time4>=<PastAfter> <Hours> ":15" [opt] <AMPM>' + ^M^J +
    '<Time4>=<PastAfter> noon "12:15 PM"' + ^M^J +
    '<Time4>=<PastAfter> midnight "12:15 AM"' + ^M^J +
    '<Time4>=<BeforeTo> <HoursMinus1> ":45" [opt] <AMPM>' + ^M^J +
    '<Time4>=<BeforeTo> noon "11:45 AM"' + ^M^J +
    '<Time4>=<BeforeTo> midnight "11:45 PM"' + ^M^J +
    '<Time5>=<PastAfter> <Hours> ":30" [opt] <AMPM>' + ^M^J +
    '<Time5>=<PastAfter> noon "12:30 PM"' + ^M^J +
    '<Time5>=<PastAfter> midnight "12:30 AM"' + ^M^J +
    '<PastAfter>=past' + ^M^J +
    '<PastAfter>=after' + ^M^J +
    '<BeforeTo>=before' + ^M^J +
    '<BeforeTo>=to' + ^M^J +
    '<BeforeTo>=til' + ^M^J +
    '<Minutes>=<DoubleDigit>' + ^M^J +
    '<Minutes>=oh "0" <0_9>' + ^M^J +
    '<Hours>=<1_9>' + ^M^J +
    '<Hours>=10' + ^M^J +
    '<Hours>=11' + ^M^J +
    '<Hours>=12' + ^M^J +
    '<HoursMinus1>=1' + ^M^J +
    '<HoursMinus1>=2' + ^M^J +
    '<HoursMinus1>=3' + ^M^J +
    '<HoursMinus1>=4' + ^M^J +
    '<HoursMinus1>=5' + ^M^J +
    '<HoursMinus1>=6' + ^M^J +
    '<HoursMinus1>=7' + ^M^J +
    '<HoursMinus1>=8' + ^M^J +
    '<HoursMinus1>=9' + ^M^J +
    '<HoursMinus1>=10' + ^M^J +
    '<HoursMinus1>=11' + ^M^J +
    '<HoursMinus1>=12' + ^M^J +
    '<AMPM>=a. m. " AM"' + ^M^J +
    '<AMPM>=a.m. " AM"' + ^M^J +
    '<AMPM>=am " AM"' + ^M^J +
    '<AMPM>=p. m. " PM"' + ^M^J +
    '<AMPM>=p.m. " PM"' + ^M^J +
    '<AMPM>=pm " PM"' + ^M^J +
    '<AMPM>=in the evening " PM"' + ^M^J +
    '<AMPM>=at night " PM"' + ^M^J +
    '<AMPM>=in the morning " AM"' + ^M^J +
    '<AMPM>=afternoon " PM"' + ^M^J +
    '' + ^M^J +
    '[<Natural>]' + ^M^J +
    '<Natural>=<Less1000000000000000Not>' + ^M^J +
    '<Natural>=<Less1000000000000Not>' + ^M^J +
    '<Natural>=<Less1000000000Not>' + ^M^J +
    '<Natural>=<Less1000000Not>' + ^M^J +
    '<Natural>=<Less1000Not>' + ^M^J +
    '<Natural>=<Less100Not>' + ^M^J +
    '// Less than 1,000,000,000,000,000, not padded with zeros' + ^M^J +
    '<Less1000000000000000Not>=<Less100Not> <Less1000000000000000Not2>' + ^M^J +
    '<Less1000000000000000Not>=<Less1000Not> <Less1000000000000000Not2>' +
        ^M^J +
    '<Less1000000000000000Not2>=trillion "000000000000"' + ^M^J +
    '<Less1000000000000000Not2>=trillion [opt] and <Less1000000000000Pad>' +
        ^M^J +
    '// Less than 1,000,000,000,000, padded with zeros' + ^M^J +
    '<Less1000000000000Pad>="000" <Less1000000000Pad>' + ^M^J +
    '<Less1000000000000Pad>=billion [opt] and "001" <Less1000000000Pad>' +
        ^M^J +
    '<Less1000000000000Pad>=<Less1000Pad> <Less1000000000000Pad2>' + ^M^J +
    '<Less1000000000000Pad>=<Less1000Pad> <Less1000000000000Pad2>' + ^M^J +
    '<Less1000000000000Pad2>=billion "000000000"' + ^M^J +
    '<Less1000000000000Pad2>=billion [opt] and <Less1000000000Pad>' + ^M^J +
    '// Less than 1,000,000,000,000, not padded with zeros' + ^M^J +
    '<Less1000000000000Not>=<Less100Not> <Less1000000000000Not2>' + ^M^J +
    '<Less1000000000000Not>=<Less1000Not> <Less1000000000000Not2>' + ^M^J +
    '<Less1000000000000Not2>=billion "000000000"' + ^M^J +
    '<Less1000000000000Not2>=billion [opt] and <Less1000000000Pad>' + ^M^J +
    '// Less than 1,000,000,000, padded with zeros' + ^M^J +
    '<Less1000000000Pad>="000" <Less1000000Pad>' + ^M^J +
    '<Less1000000000Pad>=million [opt] and "001" <Less1000000Pad>' + ^M^J +
    '<Less1000000000Pad>=<Less1000Pad> <Less1000000000Pad2>' + ^M^J +
    '<Less1000000000Pad2>=million "000000"' + ^M^J +
    '<Less1000000000Pad2>=million [opt] and <Less1000000Pad>' + ^M^J +
    '// Less than 1,000,000,000, not padded with zeros' + ^M^J +
    '<Less1000000000Not>=<Less100Not> <Less1000000000Not2>' + ^M^J +
    '<Less1000000000Not>=<Less1000Not> <Less1000000000Not2>' + ^M^J +
    '<Less1000000000Not2>=million "000000"' + ^M^J +
    '<Less1000000000Not2>=million [opt] and <Less1000000Pad>' + ^M^J +
    '// Less than 1,000,000, padded with zeros' + ^M^J +
    '<Less1000000Pad>="000" <Less1000Pad>' + ^M^J +
    '<Less1000000Pad>=thousand [opt] and "001" <Less1000Pad>' + ^M^J +
    '<Less1000000Pad>=<Less1000Pad> <Less1000000Pad2>' + ^M^J +
    '<Less1000000Pad2>=thousand "000"' + ^M^J +
    '<Less1000000Pad2>=thousand [opt] and <Less1000Pad>' + ^M^J +
    '' + ^M^J +
    '[<1_9>]' + ^M^J +
    '<1_9>=1' + ^M^J +
    '<1_9>=2' + ^M^J +
    '<1_9>=3' + ^M^J +
    '<1_9>=4' + ^M^J +
    '<1_9>=5' + ^M^J +
    '<1_9>=6' + ^M^J +
    '<1_9>=7' + ^M^J +
    '<1_9>=8' + ^M^J +
    '<1_9>=9' + ^M^J +
    '' + ^M^J +
    '[<0_9>]' + ^M^J +
    '<0_9>=zero "0"' + ^M^J +
    '<0_9>=oh "0"' + ^M^J +
    '<0_9>=<1_9>' + ^M^J +
    '' + ^M^J +
    '[<10_19>]' + ^M^J +
    '<10_19>=10' + ^M^J +
    '<10_19>=11' + ^M^J +
    '<10_19>=12' + ^M^J +
    '<10_19>=13' + ^M^J +
    '<10_19>=14' + ^M^J +
    '<10_19>=15' + ^M^J +
    '<10_19>=16' + ^M^J +
    '<10_19>=17' + ^M^J +
    '<10_19>=18' + ^M^J +
    '<10_19>=19' + ^M^J +
    '' + ^M^J +
    '[<20_99>]' + ^M^J +
    '<20_99>=<20_31>' + ^M^J +
    '<20_99>=<32_99>' + ^M^J +
    '' + ^M^J +
    '[<20_31>]' + ^M^J +
    '<20_31>=20' + ^M^J +
    '<20_31>=twenty "2" <1_9>' + ^M^J +
    '<20_31>=30' + ^M^J +
    '' + ^M^J +
    '[<32_99>]' + ^M^J +
    '<32_99>=thirty "3" <1_9>' + ^M^J +
    '<32_99>=40' + ^M^J +
    '<32_99>=forty "4" <1_9>' + ^M^J +
    '<32_99>=50' + ^M^J +
    '<32_99>=fifty "5" <1_9>' + ^M^J +
    '<32_99>=60' + ^M^J +
    '<32_99>=sixty "6" <1_9>' + ^M^J +
    '<32_99>=70' + ^M^J +
    '<32_99>=seventy "7" <1_9>' + ^M^J +
    '<32_99>=80' + ^M^J +
    '<32_99>=eighty "8" <1_9>' + ^M^J +
    '<32_99>=90' + ^M^J +
    '<32_99>=ninety "9" <1_9>' + ^M^J +
    '' + ^M^J +
    '[<DoubleDigit>]' + ^M^J +
    '<DoubleDigit>=<20_99>' + ^M^J +
    '<DoubleDigit>=<10_19>' + ^M^J +
    '' + ^M^J +
    '[<TripleDigit>]' + ^M^J +
    '<TripleDigit>=hundred "1" <Less100Pad>' + ^M^J +
    '<TripleDigit>=<1_9> <TripleDigit2>' + ^M^J +
    '<TripleDigit2>=hundred [opt] and <Less100Pad>' + ^M^J +
    '<TripleDigit2>=hundred "00"' + ^M^J +
    '' + ^M^J +
    '[<Less100Not>]' + ^M^J +
    '// Less that 100, not padded with zeros' + ^M^J +
    '<Less100Not>=<1_9>' + ^M^J +
    '<Less100Not>=<DoubleDigit>' + ^M^J +
    '<Less100Not>=zero "0"' + ^M^J +
    '' + ^M^J +
    '[<Less100Pad>]' + ^M^J +
    '// Less that 100, padded with zeros' + ^M^J +
    '<Less100Pad>="0" <1_9>' + ^M^J +
    '<Less100Pad>=<DoubleDigit>' + ^M^J +
    '<Less100Pad>=zero "00"' + ^M^J +
    '' + ^M^J +
    '[<Less1000Not>]' + ^M^J +
    '// Less than 1000, not padded with zeros' + ^M^J +
    '<Less1000Not>=<TripleDigit>' + ^M^J +
    '' + ^M^J +
    '[<Less1000Pad>]' + ^M^J +
    '// Less than 1000, padded with zeros' + ^M^J +
    '<Less1000Pad>="0" <Less100Pad>' + ^M^J +
    '<Less1000Pad>=<TripleDigit>' + ^M^J +
    '' + ^M^J +
    '[<Less1000000Not>]' + ^M^J +
    '// Less than 1,000,000, not padded with zeros' + ^M^J +
    '<Less1000000Not>=<1_9> thousand "000"' + ^M^J +
    '<Less1000000Not>=<1_9> thousand [opt] and <Less1000Pad>' + ^M^J +
    '<Less1000000Not>=<DoubleDigit> <Less1000000Not2>' + ^M^J +
    '<Less1000000Not>=<TripleDigit> <Less1000000Not2>' + ^M^J +
    '<Less1000000Not2>=thousand "000"' + ^M^J +
    '<Less1000000Not2>=thousand [opt] and <Less1000Pad>' + ^M^J;

  ApdAskForYesNoGrammar : string =
    '[<MyGrammar>]' + ^M^J +
    '<MyGrammar>=(YesNoReply)' + ^M^J +
    '' + ^M^J +
    '[(YesNoReply)]' + ^M^J +
    '-100=(YesReplies)' + ^M^J +
    '-101=(NoReplies)' + ^M^J +
    '' + ^M^J +
    '[(YesReplies)]' + ^M^J +
    '=yes' + ^M^J +
    '=yup' + ^M^J +
    '=go for it' + ^M^J +
    '=yeah [opt] sure' + ^M^J +
    '=do it' + ^M^J +
    '=you betcha' + ^M^J +
    '=sure' + ^M^J +
    '=okay' + ^M^J +
    '=yep' + ^M^J +
    '=fer sure' + ^M^J +
    '' + ^M^J +
    '[(NoReplies)]' + ^M^J +
    '=no' + ^M^J +
    '=nope' + ^M^J +
    '=nah' + ^M^J +
    '=no way' + ^M^J +
    '=stop' + ^M^J +
    '=no thanks' + ^M^J +
    '=no thank you' + ^M^J +
    '=don''t do it' +^M^J +
    '=naw' + ^M^J;

type
  TApdSapiPhraseType = (ptConvert, ptDrop, ptConvertJoin);

  TApdSapiParseTable = record
    PhraseType   : TApdSapiPhraseType;
    InputPhrase  : string;
    OutputPhrase : string;
  end;

const
  ApdPhoneNumberEntries = 12;
  ApdPhoneNumberConvert :
    array [1..ApdPhoneNumberEntries] of TApdSapiParseTable =
    ((PhraseType : ptConvert; InputPhrase : 'twenty';  OutputPhrase : '2'),
     (PhraseType : ptConvert; InputPhrase : 'thirty';  OutputPhrase : '3'),
     (PhraseType : ptConvert; InputPhrase : 'forty';   OutputPhrase : '4'),
     (PhraseType : ptConvert; InputPhrase : 'fifty';   OutputPhrase : '5'),
     (PhraseType : ptConvert; InputPhrase : 'sixty';   OutputPhrase : '6'),
     (PhraseType : ptConvert; InputPhrase : 'seventy'; OutputPhrase : '7'),
     (PhraseType : ptConvert; InputPhrase : 'eighty';  OutputPhrase : '8'),
     (PhraseType : ptConvert; InputPhrase : 'ninety';  OutputPhrase : '9'),
     (PhraseType : ptConvert; InputPhrase : 'dash';    OutputPhrase : '-'),
     (PhraseType : ptConvert; InputPhrase : 'slash';   OutputPhrase : '-'),
     (PhraseType : ptConvert; InputPhrase : 'oh';      OutputPhrase : '0'),
     (PhraseType : ptConvert; InputPhrase : 'zero';    OutputPhrase : '0'));

  ApdNumericCvtEntries = 29;
  ApdNumericCvt :
    array [1..ApdNumericCvtEntries] of TApdSapiParseTable =
    ((PhraseType : ptConvertJoin; InputPhrase : 'twenty';  OutputPhrase : '2'),
     (PhraseType : ptConvertJoin; InputPhrase : 'thirty';  OutputPhrase : '3'),
     (PhraseType : ptConvertJoin; InputPhrase : 'forty';   OutputPhrase : '4'),
     (PhraseType : ptConvertJoin; InputPhrase : 'fifty';   OutputPhrase : '5'),
     (PhraseType : ptConvertJoin; InputPhrase : 'sixty';   OutputPhrase : '6'),
     (PhraseType : ptConvertJoin; InputPhrase : 'seventy'; OutputPhrase : '7'),
     (PhraseType : ptConvertJoin; InputPhrase : 'eighty';  OutputPhrase : '8'),
     (PhraseType : ptConvertJoin; InputPhrase : 'ninety';  OutputPhrase : '9'),
     (PhraseType : ptConvert;     InputPhrase : 'oh';      OutputPhrase : '0'),
     (PhraseType : ptConvert;     InputPhrase : 'zero';    OutputPhrase : '0'),
     (PhraseType : ptConvert;     InputPhrase : 'first';   OutputPhrase : '1'),
     (PhraseType : ptConvert;     InputPhrase : 'second';  OutputPhrase : '2'),
     (PhraseType : ptConvert;     InputPhrase : 'third';   OutputPhrase : '3'),
     (PhraseType : ptConvert;     InputPhrase : 'fourth';  OutputPhrase : '4'),
     (PhraseType : ptConvert;     InputPhrase : 'fifth';   OutputPhrase : '5'),
     (PhraseType : ptConvert;     InputPhrase : 'sixth';   OutputPhrase : '6'),
     (PhraseType : ptConvert;     InputPhrase : 'seventh'; OutputPhrase : '7'),
     (PhraseType : ptConvert;     InputPhrase : 'eighth';  OutputPhrase : '8'),
     (PhraseType : ptConvert;     InputPhrase : 'ninth';   OutputPhrase : '9'),
     (PhraseType : ptConvert;     InputPhrase : 'tenth';   OutputPhrase : '10'),
     (PhraseType : ptConvert;     InputPhrase : 'eleventh';
         OutputPhrase : '11'),
     (PhraseType : ptConvert;     InputPhrase : 'twelfth';
         OutputPhrase : '12'),
     (PhraseType : ptConvert;     InputPhrase : 'thirteenth';
         OutputPhrase : '13'),
     (PhraseType : ptConvert;     InputPhrase : 'fourteenth';
         OutputPhrase : '14'),
     (PhraseType : ptConvert;     InputPhrase : 'fifteenth';
         OutputPhrase : '15'),
     (PhraseType : ptConvert;     InputPhrase : 'sixteenth';
         OutputPhrase : '16'),
     (PhraseType : ptConvert;     InputPhrase : 'seventeenth';
         OutputPhrase : '17'),
     (PhraseType : ptConvert;     InputPhrase : 'eighteenth';
         OutputPhrase : '18'),
     (PhraseType : ptConvert;     InputPhrase : 'nineteenth';
         OutputPhrase : '19'));

type
  TApdTimeWordType = (twtQuarter, twtHalf, twtMidnight, twtNoon, twtAfter,
                      twtBefore, twtPM, twtAM, twtUnknown);

   TApdTimeWord = record
     WordType : TApdTimeWordType;
     TimeWord : string;
   end;

const
  ApdTimeWordCount = 19;
  ApdTimeWordList : array [1..ApdTimeWordCount] of TApdTimeWord =
    ((WordType : twtQuarter;  TimeWord : 'quarter'),
     (WordType : twtHalf;     TimeWord : 'half'),
     (WordType : twtMidnight; TimeWord : 'midnight'),
     (WordType : twtNoon;     TimeWord : 'noon'),
     (WordType : twtAfter;    TimeWord : 'after'),
     (WordType : twtAfter;    TimeWord : 'past'),
     (WordType : twtBefore;   TimeWord : 'before'),
     (WordType : twtBefore;   TimeWord : 'to'),
     (WordType : twtBefore;   TimeWord : 'til'),
     (WordType : twtPM;       TimeWord : 'p.m.'),
     (WordType : twtPM;       TimeWord : 'p. m.'),
     (WordType : twtPM;       TimeWord : 'pm'),
     (WordType : twtPM;       TimeWord : 'evening'),
     (WordType : twtPM;       TimeWord : 'night'),
     (WordType : twtPM;       TimeWord : 'afternoon'),
     (WordType : twtAM;       TimeWord : 'a.m.'),
     (WordType : twtAM;       TimeWord : 'a. m.'),
     (WordType : twtAM;       TimeWord : 'am'),
     (WordType : twtAM;       TimeWord : 'morning'));

type
  TApdDateWordType = (dwtMonth, dwtDay, dwtNext, dwtLast, dwtToday,
                      dwtTomorrow, dwtYesterday, dwtWeekOff, dwtMonthOff,
                      dwtYearOff, dwtUnknown);

   TApdDateWord = record
     WordType : TApdDateWordType;
     DateWord : string;
     Number   : Integer;
   end;

const
  ApdDateWordCount = 27;
  ApdDateWordList : array [1..ApdDateWordCount] of TApdDateWord =
    ((WordType : dwtMonth;     DateWord : 'january';   Number : 1),
     (WordType : dwtMonth;     DateWord : 'february';  Number : 2),
     (WordType : dwtMonth;     DateWord : 'march';     Number : 3),
     (WordType : dwtMonth;     DateWord : 'april';     Number : 4),
     (WordType : dwtMonth;     DateWord : 'may';       Number : 5),
     (WordType : dwtMonth;     DateWord : 'june';      Number : 6),
     (WordType : dwtMonth;     DateWord : 'july';      Number : 7),
     (WordType : dwtMonth;     DateWord : 'august';    Number : 8),
     (WordType : dwtMonth;     DateWord : 'september'; Number : 9),
     (WordType : dwtMonth;     DateWord : 'october';   Number : 10),
     (WordType : dwtMonth;     DateWord : 'november';  Number : 11),
     (WordType : dwtMonth;     DateWord : 'december';  Number : 12),
     (WordType : dwtDay;       DateWord : 'monday';    Number : 1),
     (WordType : dwtDay;       DateWord : 'tuesday';   Number : 2),
     (WordType : dwtDay;       DateWord : 'wednesday'; Number : 3),
     (WordType : dwtDay;       DateWord : 'thursday';  Number : 4),
     (WordType : dwtday;       DateWord : 'friday';    Number : 5),
     (WordType : dwtDay;       DateWord : 'saturday';  Number : 6),
     (WordType : dwtDay;       DateWord : 'sunday';    Number : 7),
     (WordType : dwtNext;      DateWord : 'next'),
     (WordType : dwtLast;      DateWord : 'last'),
     (WordType : dwtToday;     DateWord : 'today';     Number : 0),
     (WordType : dwtTomorrow;  DateWord : 'tomorrow';  Number : 1),
     (WordType : dwtYesterday; DateWord : 'yesterday'; Number : -1),
     (WordType : dwtWeekOff;   DateWord : 'week';      Number : 7),
     (WordType : dwtMonthOff;  DateWord : 'month';     Number : 31),
     (WordType : dwtYearOff;   DateWord : 'year';      Number : 365));

implementation

end.
