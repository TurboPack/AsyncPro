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
{*                   ADLIBMDM.PAS 5.00                   *}
{*********************************************************}
{* TApdLibModem component, types used by LibModem, and   *}
{* the modem selection dialog                            *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdLibMdm;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  OOMisc,
  AdXBase,
  AdXParsr,
  AdExcept;

type
  { LibModem type definitions }
  TApdLoadModemRecord = procedure (ModemName, Manufacturer, Model, ModemFile : string;
                                   var CanLoad : Boolean) of object;
  TApdLoadModem = procedure (ModemName, Manufacturer, Model : string;
                             var CanLoad : Boolean) of object;

  { an entry from modemcap.xml describing the modem, one per modem }
  PLmModemName = ^TLmModemName;
  TLmModemName = record
    ModemName : string;
    Manufacturer : string;
    Model : string;
    ModemFile : string;
  end;

  { a modem response }
  PLmResponseData = ^TLmResponseData;
  TLmResponseData = record
    Response                         : string;
    ResponseType                     : string;
  end;

  { lots of modem responses }
  PLmResponses = ^TLmResponses;
  TLmResponses = record
    OK                               : TList;          // LmResponseData
    NegotiationProgress              : TList;          // LmResponseData
    Connect                          : TList;          // LmResponseData
    Error                            : TList;          // LmResponseData
    NoCarrier                        : TList;          // LmResponseData
    NoDialTone                       : TList;          // LmResponseData
    Busy                             : TList;          // LmResponseData
    NoAnswer                         : TList;          // LmResponseData
    Ring                             : TList;          // LmResponseData
    VoiceView1                       : TList;          // LmResponseData
    VoiceView2                       : TList;          // LmResponseData
    VoiceView3                       : TList;          // LmResponseData
    VoiceView4                       : TList;          // LmResponseData
    VoiceView5                       : TList;          // LmResponseData
    VoiceView6                       : TList;          // LmResponseData
    VoiceView7                       : TList;          // LmResponseData
    VoiceView8                       : TList;          // LmResponseData
    RingDuration                     : TList;          // LmResponseData
    RingBreak                        : TList;          // LmResponseData
    Date                             : TList;          // LmResponseData
    Time                             : TList;          // LmResponseData
    Number                           : TList;          // LmResponseData
    Name                             : TList;          // LmResponseData
    Msg                              : TList;          // LmResponseData
    SingleRing                       : TList;          // LmResponseData
    DoubleRing                       : TList;          // LmResponseData
    TripleRing                       : TList;          // LmResponseData
    Voice                            : TList;          // LmResponseData
    Fax                              : TList;          // LmResponseData
    Data                             : TList;          // LmResponseData
    Other                            : TList;          // LmResponseData
  end;

  { a modem command }
  PLmModemCommand = ^TLmModemCommand;
  TLmModemCommand = record
    Command                          : string;
    Sequence                         : Integer;
  end;

  { fax commands and responses }
  TLmFaxClassDetails = record
    ModemResponseFaxDetect           : string;
    ModemResponseDataDetect          : string;
    SerialSpeedFaxDetect             : string;
    SerialSpeedDataDetect            : string;
    HostCommandFaxDetect             : string;
    HostCommandDataDetect            : string;
    ModemResponseFaxConnect          : string;
    ModemResponseDataConnect         : string;
    AnswerCommand                    : TList;
  end;

  { more fax commands and responses }
  TLmFaxDetails = record
    ExitCommand                      : string;
    PreAnswerCommand                 : string;
    PreDialCommand                   : string;
    ResetCommand                     : string;
    SetupCommand                     : string;
    EnableV17Recv                    : string;
    EnableV17Send                    : string;
    FixModemClass                    : string;
    FixSerialSpeed                   : string;
    HighestSendSpeed                 : string;
    LowestSendSpeed                  : string;
    HardwareFlowControl              : string;
    SerialSpeedInit                  : string;
    Cl1FCS                           : string;
    Cl2DC2                           : string;
    Cl2lsEx                          : string;
    Cl2RecvBOR                       : string;
    Cl2SendBOR                       : string;
    Cl2SkipCtrlQ                     : string;
    Cl2SWBOR                         : string;
    Class2FlowOff                    : string;
    Class2FlowHW                     : string;
    Class2FlowSW                     : string;

    FaxClass1                        : TLmFaxClassDetails;
    FaxClass2                        : TLmFaxClassDetails;
    FaxClass2_0                      : TLmFaxClassDetails;
  end;

  { supported wave formats }
  PLmWaveFormat = ^TLMWaveFormat;
  TLmWaveFormat = record
    ChipSet                          : string;
    Speed                            : string;
    SampleSize                       : string;
  end;

  { wave details }
  TLmWaveDriver = record
    BaudRate                         : string;
    WaveHardwareID                   : string;
    WaveDevices                      : string;
    LowerMid                         : string;
    LowerWaveInPid                   : string;
    LowerWaveOutPid                  : string;
    WaveOutMixerDest                 : string;
    WaveOutMixerSource               : string;
    WaveInMixerDest                  : string;
    WaveInMixerSource                : string;

    WaveFormat                       : TList;          // LmWaveFormat
  end;

  { voice modem properties }
  TLmVoiceSettings = record
    VoiceProfile                     : string;
    HandsetCloseDelay                : Integer;
    SpeakerPhoneSpecs                : string;
    AbortPlay                        : string;
    CallerIDOutSide                  : string;
    CallerIDPrivate                  : string;
    TerminatePlay                    : string;
    TerminateRecord                  : string;
    VoiceManufacturerID              : string;
    VoiceProductIDWaveIn             : string;
    VoiceProductIDWaveOut            : string;
    VoiceSwitchFeatures              : string;
    VoiceBaudRate                    : Integer;
    VoiceMixerMid                    : string;
    VoiceMixerPid                    : string;
    VoiceMixerLineID                 : string;

    CloseHandset                     : TList;             // LmModemCommand;
    EnableCallerID                   : TList;             // LmModemCommand;
    EnableDistinctiveRing            : TList;             // LmModemCommand;
    GenerateDigit                    : TList;             // LmModemCommand;
    HandsetPlayFormat                : TList;             // LmModemCommand;
    HandsetRecordFormat              : TList;             // LmModemCommand;
    LineSetPlayFormat                : TList;             // LmModemCommand;
    LineSetRecordFormat              : TList;             // LmModemCommand;
    OpenHandset                      : TList;             // LmModemCommand;
    SpeakerPhoneDisable              : TList;             // LmModemCommand;
    SpeakerPhoneEnable               : TList;             // LmModemCommand;
    SpeakerPhoneMute                 : TList;             // LmModemCommand;
    SpeakerPhoneSetVolumeGain        : TList;             // LmModemCommand;
    SpeakerPhoneUnMute               : TList;             // LmModemCommand;
    StartPlay                        : TList;             // LmModemCommand;
    StartRecord                      : TList;             // LmModemCommand;
    StopPlay                         : TList;             // LmModemCommand;
    StopRecord                       : TList;             // LmModemCommand;
    VoiceAnswer                      : TList;             // LmModemCommand;
    VoiceDialNumberSetup             : TList;             // LmModemCommand;
    VoiceToDataAnswer                : TList;             // LmModemCommand;

    WaveDriver                       : TLmWaveDriver;
  end;

  { lots of specialized modem commands }
  TLmModemSettings = record
    Prefix                           : string;
    Terminator                       : string;
    DialPrefix                       : string;
    DialSuffix                       : string;
    SpeakerVolume_High               : string;
    SpeakerVolume_Low                : string;
    SpeakerVolume_Med                : string;
    SpeakerMode_Dial                 : string;
    SpeakerMode_Off                  : string;
    SpeakerMode_On                   : string;
    SpeakerMode_Setup                : string;
    FlowControl_Hard                 : string;
    FlowControl_Off                  : string;
    FlowControl_Soft                 : string;
    ErrorControl_Forced              : string;
    ErrorControl_Off                 : string;
    ErrorControl_On                  : string;
    ErrorControl_Cellular            : string;
    ErrorControl_Cellular_Forced     : string;
    Compression_Off                  : string;
    Compression_On                   : string;
    Modulation_Bell                  : string;
    Modulation_CCITT                 : string;
    Modulation_CCITT_V23             : string;
    SpeedNegotiation_On              : string;
    SpeedNegotiation_Off             : string;
    Pulse                            : string;
    Tone                             : string;
    Blind_Off                        : string;
    Blind_On                         : string;
    CallSetupFailTimer               : string;
    InactivityTimeout                : string;
    CompatibilityFlags               : string;
    ConfigDelay                      : Integer;
  end;

  { modem hardware settings }
  TLmModemHardware = record
    AutoConfigOverride               : string;
    ComPort                          : string;
    InvalidRDP                       : string;
    IoBaseAddress                    : Integer;
    InterruptNumber                  : Integer;
    PermitShare                      : Boolean;
    RxFIFO                           : string;
    RxTxBufferSize                   : Integer;
    TxFIFO                           : string;
    Pcmcia                           : string;
    BusType                          : string;
    PCCARDAttributeMemoryAddress     : Integer;
    PCCARDAttributeMemorySize        : Integer;
    PCCARDAttributeMemoryOffset      : Integer;
  end;

  { the whole shebang }
  PLmModem = ^TLmModem;
  TLmModem = record
    Inheritance                      : string;
    AttachedTo                       : string;
    FriendlyName                     : string;
    Manufacturer                     : string;
    Model                            : string;
    ModemID                          : string;
    InactivityFormat                 : string;
    Reset                            : string;
    DCB                              : string;
    Properties                       : string;
    ForwardDelay                     : Integer;
    VariableTerminator               : string;
    InfPath                          : string;
    InfSection                       : string;
    ProviderName                     : string;
    DriverDesc                       : string;
    ResponsesKeyName                 : string;
    Default                          : string;
    CallSetupFailTimeout             : Integer;
    InactivityTimeout                : Integer;
    SupportsWaitForBongTone          : Boolean;
    SupportsWaitForQuiet             : Boolean;
    SupportsWaitForDialTone          : Boolean;
    SupportsSpeakerVolumeLow         : Boolean;
    SupportsSpeakerVolumeMed         : Boolean;
    SupportsSpeakerVolumeHigh        : Boolean;
    SupportsSpeakerModeOff           : Boolean;
    SupportsSpeakerModeDial          : Boolean;
    SupportsSpeakerModeOn            : Boolean;
    SupportsSpeakerModeSetup         : Boolean;
    SupportsSetDataCompressionNegot  : Boolean;
    SupportsSetErrorControlProtNegot : Boolean;
    SupportsSetForcedErrorControl    : Boolean;
    SupportsSetCellular              : Boolean;
    SupportsSetHardwareFlowControl   : Boolean;
    SupportsSetSoftwareFlowControl   : Boolean;
    SupportsCCITTBellToggle          : Boolean;
    SupportsSetSpeedNegotiation      : Boolean;
    SupportsSetTonePulse             : Boolean;
    SupportsBlindDial                : Boolean;
    SupportsSetV21V23                : Boolean;
    SupportsModemDiagnostics         : Boolean;
    MaxDTERate                       : Integer;
    MaxDCERate                       : Integer;
    CurrentCountry                   : string;
    MaximumPortSpeed                 : Integer;
    PowerDelay                       : Integer;
    ConfigDelay                      : Integer;
    BaudRate                         : Integer;

    Responses                        : TLmResponses;
    Answer                           : TList;
    Fax                              : TList;
    FaxDetails                       : TLmFaxDetails;
    Voice                            : TLmVoiceSettings;
    Hangup                           : TList;
    Init                             : TList;
    Monitor                          : TList;
    Settings                         : TLmModemSettings;
    Hardware                         : TLmModemHardware;
    BaudRates                        : TStringList;
    Options                          : TStringList;
  end;

  TApdModemLoadState = (mlsGeneral, mlsResponses, mlsAnswer, mlsFax,
                        mlsFaxDetails, mlsVoice, mlsHangup, mlsInit,
                        mlsMonitor, mlsSettings, mlsHardware, mlsBaudRates,
                        mlsOptions, mlsISDN, mlsGSM, mlsNone);

  TApdResponseLoadState = (rlsOK, rlsNegotiationProgress, rlsConnect,
                           rlsError, rlsNoCarrier, rlsNoDialTone, rlsBusy,
                           rlsNoAnswer, rlsRing, rlsVoiceView1, rlsVoiceView2,
                           rlsVoiceView3, rlsVoiceView4, rlsVoiceView5,
                           rlsVoiceView6, rlsVoiceView7, rlsVoiceView8,
                           rlsRingDuration, rlsRingBreak, rlsDate, rlsTime,
                           rlsNumber, rlsName, rlsMessage, rlsSingleRing,
                           rlsDoubleRing, rlsTripleRing, rlsVoice, rlsFax,
                           rlsData, rlsOther, rlsNone);

  TApdVoiceLoadState = (vlsCloseHandset, vlsEnableCallerID,
                        vlsEnableDistinctiveRing, vlsGenerateDigit,
                        vlsHandsetPlayFormat, vlsHandsetRecordFormat,
                        vlsLineSetPlayFormat, vlsLineSetRecordFormat,
                        vlsOpenHandset, vlsSpeakerPhoneDisable,
                        vlsSpeakerPhoneEnable, vlsSpeakerPhoneMute,
                        vlsSpeakerPhoneSetVolumeGain, vlsSpeakerPhoneUnMute,
                        vlsStartPlay, vlsStartRecord, vlsStopPlay,
                        vlsStopRecord, vlsVoiceAnswer, vlsVoiceDialNumberSetup,
                        vlsVoiceToDataAnswer, vlsWaveDriver, vlsWaveFormat,
                        vlsNone);

  TApdFaxLoadState = (flsClass1, flsClass2, flsClass2_0, flsClass1Answer,
                      flsClass2Answer, flsClass2_0Answer, flsNone);


  { loose wrapper around TLmModem so it can be easily referenced from a TStringList }
  TLmModemClass = class
    LmModem : TLmModem;
  end;

  { loose wrapper around the TLmModemName record for use in our TStringLists }
  TApdLmModemNameClass = class(TObject)
    ModemName : string;
    Manufacturer : string;
    Model : string;
    ModemFile : string;
  end;

  TApdLmModemCollectionItem = class(TCollectionItem)
  private
    FModemName    : string;
    FManufacturer : string;
    FModel        : string;
    FModemFile    : string;
  published
    property ModemName    : string
      read FModemName write FModemName;
    property Manufacturer : string
      read FManufacturer write FManufacturer;
    property Model        : string
      read FModel write FModel;
    property ModemFile    : string
      read FModemFile write FModemFile;
  end;

  TApdLmModemCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TApdLmModemCollectionItem;
    procedure SetItem(Index: Integer; const Value: TApdLmModemCollectionItem);
  public
    function Add : TApdLmModemCollectionItem;
    property Items[Index: Integer] : TApdLmModemCollectionItem
      read GetItem write SetItem; default;
  end;

  TApdLibModem = class (TComponent)
    private
      FLibModemPath : string;
      FCompleteDbs : Boolean;
      FReadingAttributes : Boolean;

      FModemList : TList;          { contains the modemcap records }
      FModem : TList;              { contains the modem details    }
      FCurIndex : Integer;

      FModemLoadState : TApdModemLoadState;
      FResponseLoadState : TApdResponseLoadState;
      FVoiceLoadState : TApdVoiceLoadState;
      FFaxLoadState : TApdFaxLoadState;
      FCurModemIdx : Integer;

      FOnLoadModemRecord : TApdLoadModemRecord;
      FOnLoadModem : TApdLoadModem;
      FLastSeq : Integer;

    protected
      procedure SetLibModemPath (v : string);
      procedure LoadModemListAttribute (oOwner     : TObject;
                                        sName,
                                        sValue     : DOMString;
                                        bSpecified : Boolean);
      procedure LoadModemListElementBegin (oOwner : TObject;
                                           sValue : DOMString);
      procedure LoadModemListElementStart (oOwner : TObject;
                                           sValue : DOMString);
      procedure LoadModemListElementEnd (oOwner : TObject;
                                         sValue : DOMString);

      procedure AddCommand (CmdList : TList; sValue : DOMString);
      procedure LoadModemGeneral (oOwner     : TObject;
                                  sName,
                                  sValue     : DOMString;
                                  bSpecified : Boolean);
      procedure LoadVoiceSettings (oOwner     : TObject;
                                   sName,
                                   sValue     : DOMString;
                                   bSpecified : Boolean);
      procedure LoadModemSettings (oOwner     : TObject;
                                   sName,
                                   sValue     : DOMString;
                                   bSpecified : Boolean);
      procedure LoadHardwareSettings (oOwner     : TObject;
                                      sName,
                                      sValue     : DOMString;
                                      bSpecified : Boolean);
      procedure LoadFaxClassDetails (FaxClass : TLmFaxClassDetails;
                                       sName,
                                       sValue     : DOMString);
      procedure LoadFaxDetails (oOwner     : TObject;
                                       sName,
                                       sValue     : DOMString;
                                       bSpecified : Boolean);
      procedure LoadModemResponses (oOwner     : TObject;
                                           sName,
                                           sValue     : DOMString;
                                           bSpecified : Boolean);

      procedure LoadModemAttribute (oOwner     : TObject;
                                    sName,
                                    sValue     : DOMString;
                                    bSpecified : Boolean);
      procedure LoadModemBeginElement (oOwner : TObject;
                                       sValue : DOMString);
      procedure CharData (oOwner : TObject; sValue : DOMString);
      procedure LoadModemElementEnd (oOwner : TObject;
                                     sValue : DOMString);

      function GetXMLInteger (Value : string; Default : Integer) : Integer;
      function GetXMLBoolean (Value : string; Default : Boolean) : Boolean;

      procedure LoadModemList;
      procedure FreeModemList;
      function CreateModem : PLmModem;
      procedure FreeModemEntry (Value : Integer);
      procedure FreeModem;
      procedure LoadModem (FileName : string; Append : Boolean);

    public
      constructor Create (AOwner : TComponent); override;
      destructor Destroy; override;

      { loads a specific modem detail structure from modemcap, shows }
      { a dialog when appropriate }
      function SelectModem(var ModemFile, ModemManufacturer, ModemName: string;
        var LmModem : TLmModem) : Boolean;

      { returns True if the specified modem is in modemcap }
      function IsModemValid(ModemFile, ModemName : string) : Boolean;    {!!.04}

      { these methods manage the modem detail files }
      { create a new modem detail file with appropriate headers }
      function CreateNewDetailFile(const ModemDetailFile : string) : Integer;
      { adds a modem to the modem detail file }
      function AddModem(const ModemDetailFile : string; Modem : TLmModem) : Integer;
      { deletes a modem from the modem detail file }
      function DeleteModem(const ModemDetailFile, ModemName : string) : Integer;
      { retrieves a specific modem from the modem detail file }
      function GetModem(const ModemDetailFile, ModemName : string;
        var Modem : TLmModem) : Integer;
      { retrieves all modems from a modem detail file }
      function GetModems(const ModemDetailFile : string) : TStringList;

      { these methods manage the modemcap index }
      { add a modem record to modemcap }
      function AddModemRecord(ModemRecord : TLmModemName) : Integer;
      { delete a modem record from modemcap }
      function DeleteModemRecord(ModemRecord : TLmModemName) : Integer;
      { retrieves all modem records from modemcap }
      function GetModemRecords : TApdLmModemCollection;

      { the last modem detail loaded }
      property Modem : TList read FModem write FModem;

    published
      property LibModemPath : string read FLibModemPath write SetLibModemPath;
      property CompleteDbs : Boolean read FCompleteDbs;

      property OnLoadModemRecord : TApdLoadModemRecord
               read FOnLoadModemRecord write FOnLoadModemRecord;
      property OnLoadModem : TApdLoadModem
               read FOnLoadModem write FOnLoadModem;
  end;

  { the modem selection dialog }
  TApdModemSelectionDialog = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    cbxManufacturer: TComboBox;
    cbxName: TComboBox;
    lblText: TLabel;
    lblManufacturer: TLabel;
    lblModemName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbxManufacturerSelect(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbxNameChange(Sender: TObject);
  private
    { Private declarations }
    Activated : Boolean;                                                 {!!.02}
    ModemList : TApdLibModem;
    AvailableModems : TStringList;
    OldOnLoadModem : TApdLoadModem;
    OldOnLoadModemRecord : TApdLoadModemRecord;
    procedure LoadModemEvent (ModemName, Manufacturer, Model : string;
                         var CanLoad : Boolean);
    procedure LoadModemRecordEvent (ModemName, Manufacturer, Model, ModemFile : string;
                               var CanLoad : Boolean);
  public
    { Public declarations }
    LmModem : TLmModem;
    SelectedModemName,
    SelectedModemManufacturer,
    SelectedModemFile : string;
  end;

implementation

{$R *.dfm}

uses
  AdXLbMdm;

{ TApdLibModem }
constructor TApdLibModem.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);
  FLibModemPath := '/etc/modemcap';
  FCompleteDbs := False;
  FReadingAttributes := False;

  FModemList := TList.Create;
  FModemList.Clear;

  FModem := TList.Create;
  FModem.Clear;
end;

destructor TApdLibModem.Destroy;
begin
  FreeModemList;
  FModemList.Free;

  FreeModem;
  FModem.Free;

  inherited Destroy;
end;

procedure TApdLibModem.SetLibModemPath (v : string);
begin
  if v <> FLibModemPath then
    FLibModemPath := v;
end;

procedure TApdLibModem.FreeModemList;
var
  i : Integer;
begin
  for i := 0 to FModemList.Count - 1 do
    if assigned (FModemList[i]) then
      Dispose(PLmModemName(FModemList[i]));
  FModemList.Clear;
end;

procedure TApdLibModem.LoadModemListAttribute (oOwner     : TObject;
                                               sName,
                                               sValue     : DOMString;
                                               bSpecified : Boolean);
begin
  if not FReadingAttributes then
    Exit;
  if sName = 'ModemName' then
    PLmModemName (FModemList [FCurIndex]).ModemName := sValue
  else if sName = 'Manufacturer' then
    PLmModemName (FModemList [FCurIndex]).Manufacturer := sValue
  else if sName = 'Model' then
    PLmModemName (FModemList [FCurIndex]).Model := sValue
  else if sName = 'ModemFile' then
    PLmModemName (FModemList [FCurIndex]).ModemFile := sValue;
end;

procedure TApdLibModem.LoadModemListElementStart (oOwner : TObject;
                                                  sValue : DOMString);
var
  CanLoad : Boolean;
  tmp: PLmModemName;
begin
  if (sValue = 'ModemRecord') or (sValue = 'ModemCap') then begin

    // Create new record

    New(tmp);
    FModemList.Add(tmp); // --sm check sizeof
    FCurIndex := FModemList.Count - 1;

    // There are some strange things that go on in the parsing of the file.
    // It appears that all the attributes are read, THEN the OnStartElement
    // event will fire (for example, all the <ModemCap xxx="yyy"> attributes
    // will fire, when they are done, then OnStartElement will fire with
    // ModemCap.  To get around this, we will look for a ModemCap entry
    // to start the first record.  On each ModemRecord value that we get here,
    // fire the OnLoadModemRecord event (since it happens after the record
    // was loaded.

    // The CurIndex will always point to the record that is the next one to
    // be filled out.  The record that was just loaded will be in CurIndex - 1.

    // One annoying side effect of this is that an additional blank record
    // is added at the end of the list.  TODO - fix this.

    if sValue = 'ModemRecord' then begin
      CanLoad := True;
      if (Assigned (FOnLoadModemRecord)) and
         (Assigned (FModemList [FCurIndex])) and
         (FCurIndex >= 1) then
        FOnLoadModemRecord (PLmModemName (FModemList [FCurIndex - 1]).ModemName,
                            PLmModemName (FModemList [FCurIndex - 1]).Manufacturer,
                            PLmModemName (FModemList [FCurIndex - 1]).Model,
                            PLmModemName (FModemList [FCurIndex - 1]).ModemFile,
                            CanLoad);
      if (not CanLoad) and (FCurIndex >= 1) then begin
        FreeMem (FModemList[FCurIndex - 1]);
        FModemList.Delete (FCurIndex - 1);
        FCurIndex := FModemList.Count - 1;
        FCompleteDbs := False;
      end;
    end;

    FReadingAttributes := True
  end else
    FReadingAttributes := False;
end;

procedure TApdLibModem.LoadModemListElementEnd (oOwner : TObject;
                                                sValue : DOMString);
begin
  { nothing to do here }
end;

procedure TApdLibModem.LoadModemListElementBegin (oOwner : TObject;
                                                  sValue : DOMString);
begin
  { nothing to do here }
end;

procedure TApdLibModem.LoadModemList;
var
  Parser : TApdParser;
begin
  Parser := TApdParser.Create (Self);
  try
    FCompleteDbs := True;
    Parser.OnStartElement := LoadModemListElementStart;
    Parser.OnEndElement := LoadModemListElementEnd;
    Parser.OnAttribute := LoadModemListAttribute;
    Parser.OnBeginElement := LoadModemListElementBegin;
    try
      Parser.ParseDataSource (AddBackSlash (FLibModemPath) +
                              'modemcap.xml');

      { Delete the last record.  The last record will always be a dummy. }
      if FCurIndex > 0 then
        FModemList.Delete (FCurIndex);
    except
      FCompleteDbs := False;
    end;
  finally
    Parser.Free;
  end;
end;

procedure TApdLibModem.FreeModemEntry (Value : Integer);
var
  i : Integer;
begin
  { Release all the responses }

  if Assigned (PLmModem (FModem[Value]).Responses.OK) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.OK.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.OK[i]);
    PLmModem (FModem[Value]).Responses.Ok.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.NegotiationProgress) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.NegotiationProgress.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.NegotiationProgress[i]);
    PLmModem (FModem[Value]).Responses.NegotiationProgress.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Connect) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Connect.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Connect[i]);
    PLmModem (FModem[Value]).Responses.Connect.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Error) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Error.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Error[i]);
    PLmModem (FModem[Value]).Responses.Error.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.NoCarrier) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.NoCarrier.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.NoCarrier[i]);
    PLmModem (FModem[Value]).Responses.NoCarrier.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.NoDialTone) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.NoDialTone.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.NoDialTone[i]);
    PLmModem (FModem[Value]).Responses.NoDialTone.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Busy) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Busy.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Busy[i]);
    PLmModem (FModem[Value]).Responses.Busy.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.NoAnswer) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.NoAnswer.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.NoAnswer[i]);
    PLmModem (FModem[Value]).Responses.NoAnswer.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Ring) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Ring.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Ring[i]);
    PLmModem (FModem[Value]).Responses.Ring.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.VoiceView1) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.VoiceView1.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.VoiceView1[i]);
    PLmModem (FModem[Value]).Responses.VoiceView1.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.VoiceView2) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.VoiceView2.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.VoiceView2[i]);
    PLmModem (FModem[Value]).Responses.VoiceView2.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.VoiceView3) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.VoiceView3.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.VoiceView3[i]);
    PLmModem (FModem[Value]).Responses.VoiceView3.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.VoiceView4) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.VoiceView4.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.VoiceView4[i]);
    PLmModem (FModem[Value]).Responses.VoiceView4.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.VoiceView5) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.VoiceView5.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.VoiceView5[i]);
    PLmModem (FModem[Value]).Responses.VoiceView5.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.VoiceView6) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.VoiceView6.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.VoiceView6[i]);
    PLmModem (FModem[Value]).Responses.VoiceView6.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.VoiceView7) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.VoiceView7.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.VoiceView7[i]);
    PLmModem (FModem[Value]).Responses.VoiceView7.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.VoiceView8) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.VoiceView8.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.VoiceView8[i]);
    PLmModem (FModem[Value]).Responses.VoiceView8.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.RingDuration) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.RingDuration.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.RingDuration[i]);
    PLmModem (FModem[Value]).Responses.RingDuration.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.RingBreak) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.RingBreak.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.RingBreak[i]);
    PLmModem (FModem[Value]).Responses.RingBreak.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Date) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Date.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Date[i]);
    PLmModem (FModem[Value]).Responses.Date.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Time) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Time.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Time[i]);
    PLmModem (FModem[Value]).Responses.Time.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Number) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Number.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Number[i]);
    PLmModem (FModem[Value]).Responses.Number.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Name) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Name.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Name[i]);
    PLmModem (FModem[Value]).Responses.Name.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Msg) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Msg.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Msg[i]);
    PLmModem (FModem[Value]).Responses.Msg.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.SingleRing) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.SingleRing.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.SingleRing[i]);
    PLmModem (FModem[Value]).Responses.SingleRing.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.DoubleRing) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.DoubleRing.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.DoubleRing[i]);
    PLmModem (FModem[Value]).Responses.DoubleRing.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.TripleRing) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.TripleRing.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.TripleRing[i]);
    PLmModem (FModem[Value]).Responses.TripleRing.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Voice) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Voice.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Voice[i]);
    PLmModem (FModem[Value]).Responses.Voice.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Fax) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Fax.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Fax[i]);
    PLmModem (FModem[Value]).Responses.Fax.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Data) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Data.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Data[i]);
    PLmModem (FModem[Value]).Responses.Data.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Responses.Other) then begin
    for i := 0 to PLmModem (FModem[Value]).Responses.Other.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Responses.Other[i]);
    PLmModem (FModem[Value]).Responses.Other.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Answer) then begin
    for i := 0 to PLmModem (FModem[Value]).Answer.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Answer[i]);
    PLmModem (FModem[Value]).Answer.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Fax) then begin
    for i := 0 to PLmModem (FModem[Value]).Fax.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Fax[i]);
    PLmModem (FModem[Value]).Fax.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Hangup) then begin
    for i := 0 to PLmModem (FModem[Value]).Hangup.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Hangup[i]);
    PLmModem (FModem[Value]).Hangup.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Init) then begin
    for i := 0 to PLmModem (FModem[Value]).Init.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Init[i]);
    PLmModem (FModem[Value]).Init.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Monitor) then begin
    for i := 0 to PLmModem (FModem[Value]).Monitor.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Monitor[i]);
    PLmModem (FModem[Value]).Monitor.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.CloseHandset) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.CloseHandset.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.CloseHandset[i]);
    PLmModem (FModem[Value]).Voice.CloseHandset.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.EnableCallerID) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.EnableCallerID.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.EnableCallerID[i]);
    PLmModem (FModem[Value]).Voice.EnableCallerID.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.EnableDistinctiveRing) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.EnableDistinctiveRing.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.EnableDistinctiveRing[i]);
    PLmModem (FModem[Value]).Voice.EnableDistinctiveRing.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.GenerateDigit) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.GenerateDigit.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.GenerateDigit[i]);
    PLmModem (FModem[Value]).Voice.GenerateDigit.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.HandsetPlayFormat) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.HandsetPlayFormat.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.HandsetPlayFormat[i]);
    PLmModem (FModem[Value]).Voice.HandsetPlayFormat.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.HandsetRecordFormat) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.HandsetRecordFormat.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.HandsetRecordFormat[i]);
    PLmModem (FModem[Value]).Voice.HandsetRecordFormat.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.LineSetPlayFormat) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.LineSetPlayFormat.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.LineSetPlayFormat[i]);
    PLmModem (FModem[Value]).Voice.LineSetPlayFormat.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.LineSetRecordFormat) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.LineSetRecordFormat.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.LineSetRecordFormat[i]);
    PLmModem (FModem[Value]).Voice.LineSetRecordFormat.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.OpenHandset) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.OpenHandset.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.OpenHandset[i]);
    PLmModem (FModem[Value]).Voice.OpenHandset.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.SpeakerPhoneDisable) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.SpeakerPhoneDisable.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.SpeakerPhoneDisable[i]);
    PLmModem (FModem[Value]).Voice.SpeakerPhoneDisable.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.SpeakerPhoneEnable) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.SpeakerPhoneEnable.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.SpeakerPhoneEnable[i]);
    PLmModem (FModem[Value]).Voice.SpeakerPhoneEnable.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.SpeakerPhoneMute) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.SpeakerPhoneMute.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.SpeakerPhoneMute[i]);
    PLmModem (FModem[Value]).Voice.SpeakerPhoneMute.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.SpeakerPhoneSetVolumeGain) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.SpeakerPhoneSetVolumeGain.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.SpeakerPhoneSetVolumeGain[i]);
    PLmModem (FModem[Value]).Voice.SpeakerPhoneSetVolumeGain.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.SpeakerPhoneUnMute) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.SpeakerPhoneUnMute.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.SpeakerPhoneUnMute[i]);
    PLmModem (FModem[Value]).Voice.SpeakerPhoneUnMute.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.StartPlay) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.StartPlay.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.StartPlay[i]);
    PLmModem (FModem[Value]).Voice.StartPlay.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.StartRecord) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.StartRecord.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.StartRecord[i]);
    PLmModem (FModem[Value]).Voice.StartRecord.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.StopPlay) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.StopPlay.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.StopPlay[i]);
    PLmModem (FModem[Value]).Voice.StopPlay.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.StopRecord) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.StopRecord.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.StopRecord[i]);
    PLmModem (FModem[Value]).Voice.StopRecord.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.VoiceAnswer) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.VoiceAnswer.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.VoiceAnswer[i]);
    PLmModem (FModem[Value]).Voice.VoiceAnswer.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.VoiceDialNumberSetup) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.VoiceDialNumberSetup.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.VoiceDialNumberSetup[i]);
    PLmModem (FModem[Value]).Voice.VoiceDialNumberSetup.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.VoiceToDataAnswer) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.VoiceToDataAnswer.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.VoiceToDataAnswer[i]);
    PLmModem (FModem[Value]).Voice.VoiceToDataAnswer.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Voice.WaveDriver.WaveFormat) then begin
    for i := 0 to PLmModem (FModem[Value]).Voice.WaveDriver.WaveFormat.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).Voice.WaveDriver.WaveFormat[i]);
    PLmModem (FModem[Value]).Voice.WaveDriver.WaveFormat.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).FaxDetails.FaxClass1.AnswerCommand) then begin
    for i := 0 to PLmModem (FModem[Value]).FaxDetails.FaxClass1.AnswerCommand.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).FaxDetails.FaxClass1.AnswerCommand[i]);
    PLmModem (FModem[Value]).FaxDetails.FaxClass1.AnswerCommand.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).FaxDetails.FaxClass2.AnswerCommand) then begin
    for i := 0 to PLmModem (FModem[Value]).FaxDetails.FaxClass2.AnswerCommand.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).FaxDetails.FaxClass2.AnswerCommand[i]);
    PLmModem (FModem[Value]).FaxDetails.FaxClass2.AnswerCommand.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).FaxDetails.FaxClass2_0.AnswerCommand) then begin
    for i := 0 to PLmModem (FModem[Value]).FaxDetails.FaxClass2_0.AnswerCommand.Count - 1 do
      FreeMem (PLmModem (FModem[Value]).FaxDetails.FaxClass2_0.AnswerCommand[i]);
    PLmModem (FModem[Value]).FaxDetails.FaxClass2_0.AnswerCommand.Free;
  end;

  if Assigned (PLmModem (FModem[Value]).Options) then
    PLmModem (FModem[Value]).Options.Free;
  if Assigned (PLmModem (FModem[Value]).BaudRates) then
    PLmModem (FModem[Value]).BaudRates.Free;

  FreeMem (FModem[Value]);
end;

procedure TApdLibModem.FreeModem;
var
  i : Integer;
begin
  for i := 0 to FModem.Count - 1 do
    if assigned (FModem[i]) then
      FreeModemEntry (i);
  FModem.Clear;
end;

function TApdLibModem.CreateModem : PLmModem;
begin
  New(Result);
  if not Assigned (Result) then
    Exit;

  { Create all the responses }

  Result.Responses.OK := TList.Create;
  Result.Responses.NegotiationProgress := TList.Create;
  Result.Responses.Connect := TList.Create;
  Result.Responses.Error := TList.Create;
  Result.Responses.NoCarrier := TList.Create;
  Result.Responses.NoDialTone := TList.Create;
  Result.Responses.Busy := TList.Create;
  Result.Responses.NoAnswer := TList.Create;
  Result.Responses.Ring := TList.Create;
  Result.Responses.VoiceView1 := TList.Create;
  Result.Responses.VoiceView2 := TList.Create;
  Result.Responses.VoiceView3 := TList.Create;
  Result.Responses.VoiceView4 := TList.Create;
  Result.Responses.VoiceView5 := TList.Create;
  Result.Responses.VoiceView6 := TList.Create;
  Result.Responses.VoiceView7 := TList.Create;
  Result.Responses.VoiceView8 := TList.Create;
  Result.Responses.RingDuration := TList.Create;
  Result.Responses.RingBreak := TList.Create;
  Result.Responses.Date := TList.Create;
  Result.Responses.Time := TList.Create;
  Result.Responses.Number := TList.Create;
  Result.Responses.Name := TList.Create;
  Result.Responses.Msg := TList.Create;
  Result.Responses.SingleRing := TList.Create;
  Result.Responses.DoubleRing := TList.Create;
  Result.Responses.TripleRing := TList.Create;
  Result.Responses.Voice := TList.Create;
  Result.Responses.Fax := TList.Create;
  Result.Responses.Data := TList.Create;
  Result.Responses.Other := TList.Create;

  { Create Voice Entries }

  Result.Voice.CloseHandset := TList.Create;
  Result.Voice.EnableCallerID := TList.Create;
  Result.Voice.EnableDistinctiveRing := TList.Create;
  Result.Voice.GenerateDigit := TList.Create;
  Result.Voice.HandsetPlayFormat := TList.Create;
  Result.Voice.HandsetRecordFormat := TList.Create;
  Result.Voice.LineSetPlayFormat := TList.Create;
  Result.Voice.LineSetRecordFormat := TList.Create;
  Result.Voice.OpenHandset := TList.Create;
  Result.Voice.SpeakerPhoneDisable := TList.Create;
  Result.Voice.SpeakerPhoneEnable := TList.Create;
  Result.Voice.SpeakerPhoneMute := TList.Create;
  Result.Voice.SpeakerPhoneSetVolumeGain := TList.Create;
  Result.Voice.SpeakerPhoneUnMute := TList.Create;
  Result.Voice.StartPlay := TList.Create;
  Result.Voice.StartRecord := TList.Create;
  Result.Voice.StopPlay := TList.Create;
  Result.Voice.StopRecord := TList.Create;
  Result.Voice.VoiceAnswer := TList.Create;
  Result.Voice.VoiceDialNumberSetup := TList.Create;
  Result.Voice.VoiceToDataAnswer := TList.Create;
  Result.Voice.WaveDriver.WaveFormat := TList.Create;

  { Create Fax Entries }

  Result.FaxDetails.FaxClass1.AnswerCommand := TList.Create;
  Result.FaxDetails.FaxClass2.AnswerCommand := TList.Create;
  Result.FaxDetails.FaxClass2_0.AnswerCommand := TList.Create;

  Result.Options := TStringList.Create;
  Result.BaudRates := TStringList.Create;

  { Create other things }

  Result.Answer := TList.Create;
  Result.Fax := TList.Create;
  Result.Hangup := TList.Create;
  Result.Init := TList.Create;
  Result.Monitor := TList.Create;
end;

procedure TApdLibModem.LoadModemGeneral (oOwner     : TObject;
                                           sName,
                                           sValue     : DOMString;
                                           bSpecified : Boolean);
begin
  if sName = 'Inheritance' then
    PLmModem (FModem[FCurModemIdx]).Inheritance:= sValue
  else if sName = 'AttachedTo' then
    PLmModem (FModem[FCurModemIdx]).AttachedTo:= sValue
  else if sName = 'FriendlyName' then
    PLmModem (FModem[FCurModemIdx]).FriendlyName := sValue
  else if sName = 'Manufacturer' then
    PLmModem (FModem[FCurModemIdx]).Manufacturer := sValue
  else if sName = 'Model' then
    PLmModem (FModem[FCurModemIdx]).Model := sValue
  else if sName = 'ModemID' then
    PLmModem (FModem[FCurModemIdx]).ModemID := sValue
  else if sName = 'InactivityFormat' then
    PLmModem (FModem[FCurModemIdx]).InactivityFormat := sValue
  else if sName = 'Reset' then
    PLmModem (FModem[FCurModemIdx]).Reset := sValue
  else if sName = 'DCB' then
    PLmModem (FModem[FCurModemIdx]).DCB := sValue
  else if sName = 'Properties' then
    PLmModem (FModem[FCurModemIdx]).Properties := sValue
  else if sName = 'ForwardDelay' then
    PLmModem (FModem[FCurModemIdx]).ForwardDelay := GetXMLInteger (sValue, 0)
  else if sName = 'VariableTerminator' then
    PLmModem (FModem[FCurModemIdx]).VariableTerminator := sValue
  else if sName = 'InfPath' then
    PLmModem (FModem[FCurModemIdx]).InfPath := sValue
  else if sName = 'InfSection' then
    PLmModem (FModem[FCurModemIdx]).InfSection := sValue
  else if sName = 'ProviderName' then
    PLmModem (FModem[FCurModemIdx]).ProviderName := sValue
  else if sName = 'DriverDesc' then
    PLmModem (FModem[FCurModemIdx]).DriverDesc := sValue
  else if sName = 'ResponsesKeyName' then
    PLmModem (FModem[FCurModemIdx]).ResponsesKeyName := sValue
  else if sName = 'Default' then
    PLmModem (FModem[FCurModemIdx]).Default := sValue
  else if sName = 'CallSetupFailTimeout' then
    PLmModem (FModem[FCurModemIdx]).CallSetupFailTimeout := GetXMLInteger (sValue, 0)
  else if sName = 'InactivityTimeout' then
    PLmModem (FModem[FCurModemIdx]).CallSetupFailTimeout := GetXMLInteger (sValue, 0)
  else if sName = 'SupportsWaitForBongTone' then
    PLmModem (FModem[FCurModemIdx]).SupportsWaitForBongTone := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsWaitForQuiet' then
    PLmModem (FModem[FCurModemIdx]).SupportsWaitForQuiet := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsWaitForDialTone' then
    PLmModem (FModem[FCurModemIdx]).SupportsWaitForDialTone := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSpeakerVolumeLow' then
    PLmModem (FModem[FCurModemIdx]).SupportsSpeakerVolumeLow := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSpeakerVolumeMed' then
    PLmModem (FModem[FCurModemIdx]).SupportsSpeakerVolumeMed := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSpeakerVolumeHigh' then
    PLmModem (FModem[FCurModemIdx]).SupportsSpeakerVolumeHigh := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSpeakerModeOff' then
    PLmModem (FModem[FCurModemIdx]).SupportsSpeakerModeOff := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSpeakerModeDial' then
    PLmModem (FModem[FCurModemIdx]).SupportsSpeakerModeDial := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSpeakerModeOn' then
    PLmModem (FModem[FCurModemIdx]).SupportsSpeakerModeOn := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSpeakerModeSetup' then
    PLmModem (FModem[FCurModemIdx]).SupportsSpeakerModeSetup := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetDataCompressionNegot' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetDataCompressionNegot := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetErrorControlProtNegot' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetErrorControlProtNegot := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetForcedErrorControl' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetForcedErrorControl := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetCellular' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetCellular := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetHardwareFlowControl' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetHardwareFlowControl := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetSoftwareFlowControl' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetSoftwareFlowControl := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsCCITTBellToggle' then
    PLmModem (FModem[FCurModemIdx]).SupportsCCITTBellToggle := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetSpeedNegotiation' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetSpeedNegotiation := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetTonePulse' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetTonePulse := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsBlindDial' then
    PLmModem (FModem[FCurModemIdx]).SupportsBlindDial := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsSetV21V23' then
    PLmModem (FModem[FCurModemIdx]).SupportsSetV21V23 := GetXMLBoolean (sValue, False)
  else if sName = 'SupportsModemDiagnostics' then
    PLmModem (FModem[FCurModemIdx]).SupportsModemDiagnostics := GetXMLBoolean (sValue, False)
  else if sName = 'MaxDTERate' then
    PLmModem (FModem[FCurModemIdx]).MaxDTERate := GetXMLInteger (sValue, 0)
  else if sName = 'MaxDCERate' then
    PLmModem (FModem[FCurModemIdx]).MaxDCERate := GetXMLInteger (sValue, 0)
  else if sName = 'CurrentCountry' then
    PLmModem (FModem[FCurModemIdx]).CurrentCountry := sValue
  else if sName = 'MaximumPortSpeed' then
    PLmModem (FModem[FCurModemIdx]).MaximumPortSpeed := GetXMLInteger (sValue, 0)
  else if sName = 'PowerDelay' then
    PLmModem (FModem[FCurModemIdx]).PowerDelay := GetXMLInteger (sValue, 0)
  else if sName = 'ConfigDelay' then
    PLmModem (FModem[FCurModemIdx]).ConfigDelay := GetXMLInteger (sValue, 0)
  else if sName = 'BaudRate' then
    PLmModem (FModem[FCurModemIdx]).BaudRate := GetXMLInteger (sValue, 0);
end;

procedure TApdLibModem.LoadVoiceSettings (oOwner     : TObject;
                                          sName,
                                          sValue     : DOMString;
                                          bSpecified : Boolean);
begin
  if sName = 'VoiceProfile' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceProfile := sValue
  else if sName = 'HandsetCloseDelay' then
    PLmModem (FModem[FCurModemIdx]).Voice.HandsetCloseDelay := GetXMLInteger (sValue, 0)
  else if sName = 'SpeakerPhoneSpecs' then
    PLmModem (FModem[FCurModemIdx]).Voice.SpeakerPhoneSpecs := sValue
  else if sName = 'AbortPlay' then
    PLmModem (FModem[FCurModemIdx]).Voice.AbortPlay := sValue
  else if sName = 'CallerIDOutSide' then
    PLmModem (FModem[FCurModemIdx]).Voice.CallerIDOutSide := sValue
  else if sName = 'CallerIDPrivate' then
    PLmModem (FModem[FCurModemIdx]).Voice.CallerIDPrivate:= sValue
  else if sName = 'TerminatePlay' then
    PLmModem (FModem[FCurModemIdx]).Voice.TerminatePlay := sValue
  else if sName = 'TerminateRecord' then
    PLmModem (FModem[FCurModemIdx]).Voice.TerminateRecord := sValue
  else if sName = 'VoiceManufacturerID' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceManufacturerID := sValue
  else if sName = 'VoiceProductIDWaveIn' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceProductIDWaveIn := sValue
  else if sName = 'VoiceProductIDWaveOut' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceProductIDWaveOut := sValue
  else if sName = 'VoiceSwitchFeatures' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceSwitchFeatures := sValue
  else if sName = 'VoiceBaudRate' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceBaudRate := GetXMLInteger (sValue, 0)
  else if sName = 'VoiceMixerMid' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceMixerMid := sValue
  else if sName = 'VoiceMixerPid' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceMixerPid := sValue
  else if sName = 'VoiceMixerLineID' then
    PLmModem (FModem[FCurModemIdx]).Voice.VoiceMixerLineID := sValue

    
  else if sName = 'BaudRate' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.BaudRate := sValue
  else if sName = 'WaveHardwareID' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveHardwareID := sValue
  else if sName = 'WaveDevices' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveDevices := sValue
  else if sName = 'LowerMid' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.LowerMid := sValue
  else if sName = 'LowerWaveInPid' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.LowerWaveInPid := sValue
  else if sName = 'LowerWaveOutPid' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.LowerWaveOutPid := sValue
  else if sName = 'WaveOutMixerDest' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveOutMixerDest := sValue
  else if sName = 'WaveOutMixerSource' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveOutMixerSource := sValue
  else if sName = 'WaveInMixerDest' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveInMixerDest := sValue
  else if sName = 'WaveInMixerSource' then
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveInMixerSource := sValue

  else if sName = 'ChipSet' then
    PLmWaveFormat(PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveFormat[
      PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveFormat.Count-1]).ChipSet := sValue
  else if sName = 'Speed' then
    PLmWaveFormat(PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveFormat[
      PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveFormat.Count-1]).Speed := sValue
  else if sName = 'SampleSize' then
    PLmWaveFormat(PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveFormat[
      PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveFormat.Count-1]).SampleSize := sValue;      
end;

procedure TApdLibModem.LoadModemSettings (oOwner     : TObject;
                                          sName,
                                          sValue     : DOMString;
                                          bSpecified : Boolean);
begin
  if sName = 'Prefix' then
    PLmModem (FModem[FCurModemIdx]).Settings.Prefix := sValue
  else if sName = 'Terminator' then
    PLmModem (FModem[FCurModemIdx]).Settings.Terminator := sValue
  else if sName = 'DialPrefix' then
    PLmModem (FModem[FCurModemIdx]).Settings.DialPrefix := sValue
  else if sName = 'DialSuffix' then
    PLmModem (FModem[FCurModemIdx]).Settings.DialSuffix := sValue
  else if sName = 'SpeakerVolume_High' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeakerVolume_High := sValue
  else if sName = 'SpeakerVolume_Low' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeakerVolume_Low := sValue
  else if sName = 'SpeakerVolume_Med' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeakerVolume_Med := sValue
  else if sName = 'SpeakerMode_Dial' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeakerMode_Dial := sValue
  else if sName = 'SpeakerMode_Off' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeakerMode_Off := sValue
  else if sName = 'SpeakerMode_On' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeakerMode_On := sValue
  else if sName = 'SpeakerMode_Setup' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeakerMode_Setup := sValue
  else if sName = 'FlowControl_Hard' then
    PLmModem (FModem[FCurModemIdx]).Settings.FlowControl_Hard := sValue
  else if sName = 'FlowControl_Off' then
    PLmModem (FModem[FCurModemIdx]).Settings.FlowControl_Off := sValue
  else if sName = 'FlowControl_Soft' then
    PLmModem (FModem[FCurModemIdx]).Settings.FlowControl_Soft := sValue
  else if sName = 'ErrorControl_Forced' then
    PLmModem (FModem[FCurModemIdx]).Settings.ErrorControl_Forced := sValue
  else if sName = 'ErrorControl_Off' then
    PLmModem (FModem[FCurModemIdx]).Settings.ErrorControl_Off := sValue
  else if sName = 'ErrorControl_On' then
    PLmModem (FModem[FCurModemIdx]).Settings.ErrorControl_On := sValue
  else if sName = 'ErrorControl_Cellular' then
    PLmModem (FModem[FCurModemIdx]).Settings.ErrorControl_Cellular := sValue
  else if sName = 'ErrorControl_Cellular_Forced' then
    PLmModem (FModem[FCurModemIdx]).Settings.ErrorControl_Cellular_Forced := sValue
  else if sName = 'Compression_Off' then
    PLmModem (FModem[FCurModemIdx]).Settings.Compression_Off := sValue
  else if sName = 'Compression_On' then
    PLmModem (FModem[FCurModemIdx]).Settings.Compression_On := sValue
  else if sName = 'Modulation_Bell' then
    PLmModem (FModem[FCurModemIdx]).Settings.Modulation_Bell := sValue
  else if sName = 'Modulation_CCITT' then
    PLmModem (FModem[FCurModemIdx]).Settings.Modulation_CCITT := sValue
  else if sName = 'Modulation_CCITT_V23' then
    PLmModem (FModem[FCurModemIdx]).Settings.Modulation_CCITT_V23 := sValue
  else if sName = 'SpeedNegotiation_On' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeedNegotiation_On := sValue
  else if sName = 'SpeedNegotiation_Off' then
    PLmModem (FModem[FCurModemIdx]).Settings.SpeedNegotiation_Off := sValue
  else if sName = 'Pulse' then
    PLmModem (FModem[FCurModemIdx]).Settings.Pulse := sValue
  else if sName = 'Tone' then
    PLmModem (FModem[FCurModemIdx]).Settings.Tone := sValue
  else if sName = 'Blind_Off' then
    PLmModem (FModem[FCurModemIdx]).Settings.Blind_Off := sValue
  else if sName = 'Blind_On' then
    PLmModem (FModem[FCurModemIdx]).Settings.Blind_On := sValue
  else if sName = 'CallSetupFailTimer' then
    PLmModem (FModem[FCurModemIdx]).Settings.CallSetupFailTimer := sValue
  else if sName = 'InactivityTimeout' then
    PLmModem (FModem[FCurModemIdx]).Settings.InactivityTimeout := sValue
  else if sName = 'CompatibilityFlags' then
    PLmModem (FModem[FCurModemIdx]).Settings.CompatibilityFlags := sValue
  else if sName = 'ConfigDelay' then
    PLmModem (FModem[FCurModemIdx]).Settings.ConfigDelay := GetXMLInteger (sValue, 0);
end;

procedure TApdLibModem.LoadHardwareSettings (oOwner     : TObject;
                                             sName,
                                             sValue     : DOMString;
                                             bSpecified : Boolean);
begin
  if sName = 'AutoConfigOverride' then
    PLmModem (FModem[FCurModemIdx]).Hardware.AutoConfigOverride := sValue
  else if sName = 'ComPort' then
    PLmModem (FModem[FCurModemIdx]).Hardware.ComPort := sValue
  else if sName = 'InvalidRDP' then
    PLmModem (FModem[FCurModemIdx]).Hardware.InvalidRDP := sValue
  else if sName = 'IoBaseAddress' then
    PLmModem (FModem[FCurModemIdx]).Hardware.IoBaseAddress := GetXMLInteger (sValue, 0)
  else if sName = 'InterruptNumber' then
    PLmModem (FModem[FCurModemIdx]).Hardware.InterruptNumber := GetXMLInteger (sValue, 0)
  else if sName = 'PermitShare' then
    PLmModem (FModem[FCurModemIdx]).Hardware.PermitShare := GetXMLBoolean (sValue, False)
  else if sName = 'RxFIFO' then
    PLmModem (FModem[FCurModemIdx]).Hardware.RxFIFO := sValue
  else if sName = 'RxTxBufferSize' then
    PLmModem (FModem[FCurModemIdx]).Hardware.RxTxBufferSize := GetXMLInteger (sValue, 0)
  else if sName = 'TxFIFO' then
    PLmModem (FModem[FCurModemIdx]).Hardware.TxFIFO := sValue
  else if sName = 'Pcmcia' then
    PLmModem (FModem[FCurModemIdx]).Hardware.Pcmcia := sValue
  else if sName = 'BusType' then
    PLmModem (FModem[FCurModemIdx]).Hardware.BusType := sValue
  else if sName = 'PCCARDAttributeMemoryAddress' then
    PLmModem (FModem[FCurModemIdx]).Hardware.PCCARDAttributeMemoryAddress := GetXMLInteger (sValue, 0)
  else if sName = 'PCCARDAttributeMemorySize' then
    PLmModem (FModem[FCurModemIdx]).Hardware.PCCARDAttributeMemorySize := GetXMLInteger (sValue, 0)
  else if sName = 'PCCARDAttributeMemoryOffset' then
    PLmModem (FModem[FCurModemIdx]).Hardware.PCCARDAttributeMemoryOffset := GetXMLInteger (sValue, 0)
end;

procedure TApdLibModem.LoadFaxDetails (oOwner     : TObject;
                                       sName,
                                       sValue     : DOMString;
                                       bSpecified : Boolean);
begin
  if sName = 'ExitCommand' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.ExitCommand := sValue
  else if sName = 'PreAnswerCommand' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.PreAnswerCommand := sValue
  else if sName = 'PreDialCommand' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.PreDialCommand := sValue
  else if sName = 'ResetCommand' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.ResetCommand := sValue
  else if sName = 'SetupCommand' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.SetupCommand := sValue
  else if sName = 'EnableV17Recv' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.EnableV17Recv := sValue
  else if sName = 'EnableV17Send' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.EnableV17Send := sValue
  else if sName = 'FixModemClass' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.FixModemClass := sValue
  else if sName = 'FixSerialSpeed' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.FixSerialSpeed := sValue
  else if sName = 'HighestSendSpeed' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.HighestSendSpeed := sValue
  else if sName = 'LowestSendSpeed' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.LowestSendSpeed := sValue
  else if sName = 'HardwareFlowControl' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.HardwareFlowControl := sValue
  else if sName = 'SerialSpeedInit' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.SerialSpeedInit := sValue
  else if sName = 'Cl1FCS' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Cl1FCS := sValue
  else if sName = 'Cl2DC2' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Cl2DC2 := sValue
  else if sName = 'Cl2lsEx' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Cl2lsEx := sValue
  else if sName = 'Cl2RecvBOR' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Cl2RecvBOR := sValue
  else if sName = 'Cl2SendBOR' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Cl2SendBOR := sValue
  else if sName = 'Cl2SkipCtrlQ' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Cl2SkipCtrlQ := sValue
  else if sName = 'Cl2SWBOR' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Cl2SWBOR := sValue
  else if sName = 'Class2FlowOff' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Class2FlowOff := sValue
  else if sName = 'Class2FlowHW' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Class2FlowHW := sValue
  else if sName = 'Class2FlowSW' then
    PLmModem (FModem[FCurModemIdx]).FaxDetails.Class2FlowSW := sValue
end;

procedure TApdLibModem.LoadFaxClassDetails (FaxClass : TLmFaxClassDetails;
                                       sName,
                                       sValue     : DOMString);
begin
  if sName = 'ModemResponseFaxDetect' then
    FaxClass.ModemResponseFaxDetect := sValue
  else if sName = 'ModemResponseDataDetect' then
    FaxClass.ModemResponseDataDetect := sValue
  else if sName = 'SerialSpeedFaxDetect' then
    FaxClass.SerialSpeedFaxDetect := sValue
  else if sName = 'SerialSpeedDataDetect' then
    FaxClass.SerialSpeedDataDetect := sValue
  else if sName = 'HostCommandFaxDetect' then
    FaxClass.HostCommandFaxDetect := sValue
  else if sName = 'HostCommandDataDetect' then
    FaxClass.HostCommandDataDetect := sValue
  else if sName = 'ModemResponseFaxConnect' then
    FaxClass.ModemResponseFaxConnect := sValue
  else if sName = 'ModemResponseDataConnect' then
    FaxClass.ModemResponseDataConnect := sValue
end;

procedure TApdLibModem.LoadModemResponses (oOwner     : TObject;
                                           sName,
                                           sValue     : DOMString;
                                           bSpecified : Boolean);

  procedure AddResponse (Location : TList; Value : string);
  var
    Response : PLmResponseData;
  begin
    Response := AllocMem (SizeOf (TLmResponseData));
    Response.Response := sValue;
    Location.Add (Response);
  end;

begin
  case FResponseLoadState of
    rlsOK                  :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.OK, sValue);
    rlsNegotiationProgress :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.NegotiationProgress,
                   sValue);
    rlsConnect             :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Connect, sValue);
    rlsError               :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Error, sValue);
    rlsNoCarrier           :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.NoCarrier, sValue);
    rlsNoDialTone          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.NoDialTone,
                   sValue);
    rlsBusy                :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Busy, sValue);
    rlsNoAnswer            :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.NoAnswer, sValue);
    rlsRing                :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Ring, sValue);
    rlsVoiceView1          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.VoiceView1,
                   sValue);
    rlsVoiceView2          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.VoiceView2,
                   sValue);
    rlsVoiceView3          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.VoiceView3,
                   sValue);
    rlsVoiceView4          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.VoiceView4,
                   sValue);
    rlsVoiceView5          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.VoiceView5,
                   sValue);
    rlsVoiceView6          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.VoiceView6,
                   sValue);
    rlsVoiceView7          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.VoiceView7,
                   sValue);
    rlsVoiceView8          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.VoiceView8,
                   sValue);
    rlsRingDuration        :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.RingDuration,
                   sValue);
    rlsRingBreak           :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.RingBreak,
                   sValue);
    rlsDate                :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Date, sValue);
    rlsTime                :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Time, sValue);
    rlsNumber              :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Number, sValue);
    rlsName                :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Name, sValue);
    rlsMessage             :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Msg, sValue);
    rlsSingleRing          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.SingleRing,
                   sValue);
    rlsDoubleRing          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.DoubleRing,
                   sValue);
    rlsTripleRing          :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.TripleRing,
                   sValue);
    rlsVoice               :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Voice, sValue);
    rlsFax                 :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Fax, sValue);
    rlsData                :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Data, sValue);
    rlsOther               :
      AddResponse (PLmModem (FModem[FCurModemIdx]).Responses.Other, sValue);
  end;
end;

procedure TApdLibModem.AddCommand (CmdList : TList; sValue : DOMString);
var
  Command : PLmModemCommand;
begin
  Command := AllocMem (SizeOf (TLmModemCommand));
  Command.Command := sValue;
  Command.Sequence := FLastSeq;
  CmdList.Add (Command);
end;

procedure TApdLibModem.LoadModemAttribute (oOwner     : TObject;
                                           sName,
                                           sValue     : DOMString;
                                           bSpecified : Boolean);
begin
  case FModemLoadState of
    mlsGeneral    : LoadModemGeneral (oOwner, sName, sValue, bSpecified);
    mlsResponses  : begin end;
    mlsAnswer     : if sName = 'Sequence' then
                      try
                        FLastSeq := StrToInt (sValue);
                      except
                        FLastSeq := -1;
                      end;
    mlsFax        : if sName = 'Sequence' then
                      try
                        FLastSeq := StrToInt (sValue);
                      except
                        FLastSeq := -1;
                      end;
    mlsFaxDetails :
      case FFaxLoadState of
          flsClass1   :
            LoadFaxClassDetails (PLmModem (FModem[FCurModemIdx]).FaxDetails.FaxClass1, sname, sValue);
          flsClass2   :
            LoadFaxClassDetails (PLmModem (FModem[FCurModemIdx]).FaxDetails.FaxClass2, sname, sValue);
          flsClass2_0 :
            LoadFaxClassDetails (PLmModem (FModem[FCurModemIdx]).FaxDetails.FaxClass2_0, sname, sValue);
          flsClass1Answer, flsClass2Answer, flsClass2_0Answer :
            if sName = 'Sequence' then
              try
                FLastSeq := StrToInt (sValue);
              except
                FLastSeq := -1;
              end;
        else
          LoadFaxDetails (oOwner, sName, sValue, bSpecified);
      end;
    mlsVoice      :
      if sName = 'Sequence' then
        try
          FLastSeq := StrToInt (sValue);
        except
          FLastSeq := -1;
        end
      else
        LoadVoiceSettings (oOwner, sName, sValue, bSpecified);
    mlsHangup     : if sName = 'Sequence' then
                      try
                        FLastSeq := StrToInt (sValue);
                      except
                        FLastSeq := -1;
                      end;
    mlsInit       : if sName = 'Sequence' then
                      try
                        FLastSeq := StrToInt (sValue);
                      except
                        FLastSeq := -1;
                      end;
    mlsMonitor    : if sName = 'Sequence' then
                      try
                        FLastSeq := StrToInt (sValue);
                      except
                        FLastSeq := -1;
                      end;
    mlsSettings   : LoadModemSettings (oOwner, sName, sValue, bSpecified);
    mlsHardware   : LoadHardwareSettings (oOwner, sName, sValue, bSpecified);
    mlsBaudRates  : begin end;
    mlsOptions    : begin end;
    mlsISDN       : begin end;
    mlsGSM        : begin end;
  end;
end;

procedure TApdLibModem.LoadModemBeginElement (oOwner : TObject;
                                              sValue : DOMString);
begin
  FResponseLoadState := rlsNone;
  FLastSeq := 0;

  if (sValue = 'Modem') then begin

    // Create new record

    FModem.Add (CreateModem);
    FCurModemIdx := FModem.Count - 1;

    FModemLoadState := mlsGeneral;

  end else if (sValue = 'Answer') then
    FModemLoadState := mlsAnswer
  else if (sValue = 'Fax') then
    FModemLoadState := mlsFax
  else if (sValue = 'Hangup') then
    FModemLoadState := mlsHangup
  else if (sValue = 'Init') then
    FModemLoadState := mlsInit
  else if (sValue = 'Monitor') then
    FModemLoadState := mlsMonitor
  else if (sValue = 'Settings') then
    FModemLoadState := mlsSettings
  else if (sValue = 'Hardware') then
    FModemLoadState := mlsHardware

  else if (sValue = 'BaudRates') then
    FModemLoadState := mlsBaudRates
  else if (sValue = 'Options') then
    FModemLoadState := mlsOptions

  // Handle all the fax options

  else if (sValue = 'FaxDetails') then
    FModemLoadState := mlsFaxDetails
  else if (sValue = 'Class1') then
    FFaxLoadState := flsClass1
  else if (sValue = 'Class2') then
    FFaxLoadState := flsClass2
  else if (sValue = 'Class2_0') then
    FFaxLoadState := flsClass2_0
  else if (sValue = 'AnswerCommand') then
    case FFaxLoadState of
      flsClass1   : FFaxLoadState := flsClass1Answer;
      flsClass2   : FFaxLoadState := flsClass2Answer;
      flsClass2_0 : FFaxLoadState := flsClass2_0Answer;
    end
  // Handle all the voice options

  else if (sValue = 'Voice') then
    FModemLoadState := mlsVoice
  else if (sValue = 'CloseHandset') then
    FVoiceLoadState := vlsCloseHandset
  else if (sValue = 'EnableCallerID') then
    FVoiceLoadState := vlsEnableCallerID
  else if (sValue = 'EnableDistinctiveRing') then
    FVoiceLoadState := vlsEnableDistinctiveRing
  else if (sValue = 'GenerateDigit') then
    FVoiceLoadState := vlsGenerateDigit
  else if (sValue = 'HandsetPlayFormat') then
    FVoiceLoadState := vlsHandsetPlayFormat
  else if (sValue = 'HandsetRecordFormat') then
    FVoiceLoadState := vlsHandsetRecordFormat
  else if (sValue = 'LineSetPlayFormat') then
    FVoiceLoadState := vlsLineSetPlayFormat
  else if (sValue = 'LineSetRecordFormat') then
    FVoiceLoadState := vlsLineSetRecordFormat
  else if (sValue = 'OpenHandset') then
    FVoiceLoadState := vlsOpenHandset
  else if (sValue = 'SpeakerPhoneDisable') then
    FVoiceLoadState := vlsSpeakerPhoneDisable
  else if (sValue = 'SpeakerPhoneEnable') then
    FVoiceLoadState := vlsSpeakerPhoneEnable
  else if (sValue = 'SpeakerPhoneMute') then
    FVoiceLoadState := vlsSpeakerPhoneMute
  else if (sValue = 'SpeakerPhoneSetVolumeGain') then
    FVoiceLoadState := vlsSpeakerPhoneSetVolumeGain
  else if (sValue = 'SpeakerPhoneUnMute') then
    FVoiceLoadState := vlsSpeakerPhoneUnMute
  else if (sValue = 'StartPlay') then
    FVoiceLoadState := vlsStartPlay
  else if (sValue = 'StartRecord') then
    FVoiceLoadState := vlsStartRecord
  else if (sValue = 'StopPlay') then
    FVoiceLoadState := vlsStopPlay
  else if (sValue = 'StopRecord') then
    FVoiceLoadState := vlsStopRecord
  else if (sValue = 'VoiceAnswer') then
    FVoiceLoadState := vlsVoiceAnswer
  else if (sValue = 'VoiceDialNumberSetup') then
    FVoiceLoadState := vlsVoiceDialNumberSetup
  else if (sValue = 'VoiceToDataAnswer') then
    FVoiceLoadState := vlsVoiceToDataAnswer
  else if (sValue = 'WaveDriver') then
    FVoiceLoadState := vlsWaveDriver
  else if (sValue = 'WaveFormat') then begin
    FVoiceLoadState := vlsWaveFormat;
    PLmModem (FModem[FCurModemIdx]).Voice.WaveDriver.WaveFormat.Add (
      AllocMem (sizeof (TLmWaveFormat))); 
  end

  // Handle the various type of responses

  else if (sValue = 'Responses') then
    FModemLoadState := mlsResponses
  else if (sValue = 'OKResponses') then
    FResponseLoadState := rlsOk
  else if (sValue = 'NegotiationProgressResponses') then
    FResponseLoadState := rlsNegotiationProgress
  else if (sValue = 'ConnectResponses') then
    FResponseLoadState := rlsConnect
  else if (sValue = 'ErrorResponses') then
    FResponseLoadState := rlsError
  else if (sValue = 'NoCarrierResponses') then
    FResponseLoadState := rlsNoCarrier
  else if (sValue = 'NoDialToneResponses') then
    FResponseLoadState := rlsNoDialTone
  else if (sValue = 'BusyResponses') then
    FResponseLoadState := rlsBusy
  else if (sValue = 'NoAnswerResponses') then
    FResponseLoadState := rlsNoAnswer
  else if (sValue = 'RingResponses') then
    FResponseLoadState := rlsRing
  else if (sValue = 'VoiceView1Responses') then
    FResponseLoadState := rlsVoiceView1
  else if (sValue = 'VoiceView2Responses') then
    FResponseLoadState := rlsVoiceView2
  else if (sValue = 'VoiceView3Responses') then
    FResponseLoadState := rlsVoiceView3
  else if (sValue = 'VoiceView4Responses') then
    FResponseLoadState := rlsVoiceView4
  else if (sValue = 'VoiceView5Responses') then
    FResponseLoadState := rlsVoiceView5
  else if (sValue = 'VoiceView6Responses') then
    FResponseLoadState := rlsVoiceView6
  else if (sValue = 'VoiceView7Responses') then
    FResponseLoadState := rlsVoiceView7
  else if (sValue = 'VoiceView8Responses') then
    FResponseLoadState := rlsVoiceView8
  else if (sValue = 'RingDurationResponses') then
    FResponseLoadState := rlsRingDuration
  else if (sValue = 'RingBreakResponses') then
    FResponseLoadState := rlsRingBreak
  else if (sValue = 'DateResponses') then
    FResponseLoadState := rlsDate
  else if (sValue = 'TimeResponses') then
    FResponseLoadState := rlsTime
  else if (sValue = 'NumberResponses') then
    FResponseLoadState := rlsNumber
  else if (sValue = 'NameResponses') then
    FResponseLoadState := rlsName
  else if (sValue = 'MessageResponses') then
    FResponseLoadState := rlsMessage
  else if (sValue = 'SingeRingResponses') then
    FResponseLoadState := rlsSingleRing
  else if (sValue = 'DoubleRingResponses') then
    FResponseLoadState := rlsDoubleRing
  else if (sValue = 'TripleRingResponses') then
    FResponseLoadState := rlsTripleRing
  else if (sValue = 'VoiceResponses') then
    FResponseLoadState := rlsVoice
  else if (sValue = 'FaxResponses') then
    FResponseLoadState := rlsFax
  else if (sValue = 'DataResponses') then
    FResponseLoadState := rlsData
  else if (sValue = 'OtherResponses') then
    FResponseLoadState := rlsOther;

end;

procedure TApdLibModem.CharData (oOwner : TObject; sValue : DOMString);
begin
                                               
  case FModemLoadState of
    mlsGeneral    : begin end;
    mlsResponses  :
      if (FResponseLoadState <> rlsNone) then
        LoadModemResponses (oOwner, '', sValue, True);
    mlsAnswer     : AddCommand (PLmModem (FModem[FCurModemIdx]).Answer, sValue);
    mlsFax        : AddCommand (PLmModem (FModem[FCurModemIdx]).Fax, sValue);
    mlsFaxDetails :
      case FFaxLoadState of
        flsClass1Answer   :
          AddCommand (PLmModem (FModem[FCurModemIdx]).FaxDetails.FaxClass1.AnswerCommand, sValue);
        flsClass2Answer   :
          AddCommand (PLmModem (FModem[FCurModemIdx]).FaxDetails.FaxClass2.AnswerCommand, sValue);
        flsClass2_0Answer :
          AddCommand (PLmModem (FModem[FCurModemIdx]).FaxDetails.FaxClass2_0.AnswerCommand, sValue);
      end;
    mlsVoice      :
      case FVoiceLoadState of
        vlsCloseHandset              :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.CloseHandset, sValue);
        vlsEnableCallerID            :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.EnableCallerID, sValue);
        vlsEnableDistinctiveRing     :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.EnableDistinctiveRing, sValue);
        vlsGenerateDigit             :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.GenerateDigit, sValue);
        vlsHandsetPlayFormat         :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.HandsetPlayFormat, sValue);
        vlsHandsetRecordFormat       :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.HandsetRecordFormat, sValue);
        vlsLineSetPlayFormat         :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.LineSetPlayFormat, sValue);
        vlsLineSetRecordFormat       :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.LineSetRecordFormat, sValue);
        vlsOpenHandset               :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.OpenHandset, sValue);
        vlsSpeakerPhoneDisable       :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.SpeakerPhoneDisable, sValue);
        vlsSpeakerPhoneEnable        :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.SpeakerPhoneEnable, sValue);
        vlsSpeakerPhoneMute          :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.SpeakerPhoneMute, sValue);
        vlsSpeakerPhoneSetVolumeGain :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.SpeakerPhoneSetVolumeGain, sValue);
        vlsSpeakerPhoneUnMute        :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.SpeakerPhoneUnMute, sValue);
        vlsStartPlay                 :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.StartPlay, sValue);
        vlsStartRecord               :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.StartRecord, sValue);
        vlsStopPlay:
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.StopPlay, sValue);
        vlsStopRecord:
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.StopRecord, sValue);
        vlsVoiceAnswer               :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.VoiceAnswer, sValue);
        vlsVoiceDialNumberSetup      :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.VoiceDialNumberSetup, sValue);
        vlsVoiceToDataAnswer         :
          AddCommand (PLmModem (FModem[FCurModemIdx]).Voice.VoiceToDataAnswer, sValue);
        vlsWaveDriver                : begin end;
        vlsWaveFormat                : begin end;
        vlsNone                      : begin end;
      end;
    mlsHangup     : AddCommand (PLmModem (FModem[FCurModemIdx]).Hangup, sValue);
    mlsInit       : AddCommand (PLmModem (FModem[FCurModemIdx]).Init, sValue);
    mlsMonitor    : AddCommand (PLmModem (FModem[FCurModemIdx]).Monitor, sValue);
    mlsSettings   : begin end;
    mlsHardware   : begin end;
    mlsBaudRates  : PLmModem (FModem[FCurModemIdx]).BaudRates.Add (sValue);
    mlsOptions    : PLmModem (FModem[FCurModemIdx]).Options.Add (sValue); 
    mlsISDN       : begin end;
    mlsGSM        : begin end;
  end;

end;

procedure TApdLibModem.LoadModemElementEnd (oOwner : TObject;
                                            sValue : DOMString);
var
  CanLoad : Boolean;
begin
  if sValue = 'Modem' then begin
    CanLoad := True;
    if (Assigned (FOnLoadModem)) and
       (Assigned (FModem [FCurModemIdx])) and
       (FCurModemIdx >= 1) then
      FOnLoadModem (PLmModem (FModem [FCurModemIdx - 1]).FriendlyName,
                    PLmModem (FModem [FCurModemIdx - 1]).Manufacturer,
                    PLmModem (FModem [FCurModemIdx - 1]).Model,
                    CanLoad);
    if (not CanLoad) and (FCurModemIdx >= 1) then begin
      FreeMem (FModem[FCurModemIdx - 1]);
      FModem.Delete (FCurModemIdx - 1);
      FCurModemIdx := FModem.Count - 1;
    end;
  end;
  if ((FModemLoadState <> mlsResponses) and (FModemLoadState <> mlsVoice)) or
     ((sValue = 'Response') and (FModemLoadState = mlsResponses)) or
     ((sValue = 'Voice') and (FModemLoadState = mlsVoice)) then
    FModemLoadState := mlsNone;
  if FModemLoadState = mlsResponses then
    FResponseLoadState := rlsNone;
  if FModemLoadState = mlsVoice then
    FVoiceLoadState := vlsNone;
end;

procedure TApdLibModem.LoadModem (FileName : string; Append : Boolean);
var
  Parser : TApdParser;
begin
  if not Append then
    FreeModem;

  Parser := TApdParser.Create (Self);
  try
    Parser.OnBeginElement := LoadModemBeginElement;
    Parser.OnEndElement := LoadModemElementEnd;
    Parser.OnAttribute := LoadModemAttribute;
    Parser.OnCharData := CharData;
    try
      Parser.ParseDataSource (AddBackSlash (FLibModemPath) +
                              FileName);

      // Delete the last record.  The last record will always be a dummy.
      if FCurModemIdx > 0 then
        FModem.Delete (FCurModemIdx);
    except
    end;
  finally
    Parser.Free;
  end;
end;

function TApdLibModem.GetXMLBoolean(Value: string;
  Default: Boolean): Boolean;
begin  
  Result := Default;
  Value := UpperCase (Value);
  if (Value = '1') or (Value = 'TRUE') or (Value = 'T') or (Value = 'YES') or
     (Value = 'Y') or (Value = 'ON') then
    Result := True
  else if (Value = '0') or (Value = 'FALSE') or (Value = 'F') or
          (Value = 'NO') or (Value = 'N') or (Value = 'OFF') then
    Result := False;
end;

function TApdLibModem.GetXMLInteger(Value: string;
  Default: Integer): Integer;
begin
  Result := StrToIntDef (Value, Default);
end;

function TApdLibModem.SelectModem(var ModemFile, ModemManufacturer, ModemName: string;
  var LmModem: TLmModem): Boolean;
var
  Dialog : TApdModemSelectionDialog;
begin
{
    if you know which modem you will use, set ModemFile to the modem detail file
      where that modem resides, and ModemName to the name of the modem

    if you are using a subset of modemcap, you can create a 'mymodems.xml' that
      only contains the modems you want to support.  Set ModemCapFolder to the
      folder where that file is, then call SelectModem with ModemFile = 'mymodems.xml'
      and you'll get the modem selection dialog with only your modems

    Of course, if the specified modem file, manufacturer and/or modemname isn't
      found, we'll show the whole thing
}
  { selecting a specific modem from a specific detail }
  if (ModemFile <> '') and (ModemName <> '') then
    if GetModem(ModemFile, ModemName, LmModem) = ecOK then begin
      { we found the modem }
      Result := True;
      Exit;
    end;

  Dialog := nil;
  try
    Dialog := TApdModemSelectionDialog.Create(nil);
    Dialog.ModemList := Self;
    if Dialog.ShowModal = mrOK then begin
      ModemFile := Dialog.SelectedModemFile;
      ModemManufacturer := Dialog.SelectedModemManufacturer;
      ModemName := Dialog.SelectedModemName;
      lmModem := PLmModem(FModem[0])^; // --sz Move(PLmModem(FModem[0])^, LmModem, SizeOf(TLmModem));  // --sz this will not work because it would be moving the memory content of an AnsiString, let Delphi copy the record // --sm check
      Result := True;
    end else
      Result := False;
  finally
    Dialog.Free;
  end;
end;

function TApdLibModem.CreateNewDetailFile(
  const ModemDetailFile: string): Integer;
  { create a new modem detail file with appropriate headers }
var
  Detail : TApdModemCapDetail;

begin
  Detail := nil;
  try
    Detail := TApdModemCapDetail.Create(self);
    Result := Detail.CreateNewDetailFile(
      AddBackSlash(FLibModemPath) + ModemDetailFile);
  finally
    Detail.Free;
  end;
end;

function TApdLibModem.AddModem(const ModemDetailFile: string;
  Modem: TLmModem): Integer;
  { adds a modem to the modem detail file, creates a new one if necessary }
var
  Detail : TApdModemCapDetail;
  S : string;
begin
  Detail := nil;
  try
    Detail := TApdModemCapDetail.Create(self);
    Result := ecOK;
    S := AddBackSlash (FLibModemPath) + ModemDetailFile;
    if not FileExists(S) then
      Result := Detail.CreateNewDetailFile(S);
    if Result = ecOK then
      Result := Detail.AddModem(S, Modem);
  finally
    Detail.Free;
  end;
end;

function TApdLibModem.AddModemRecord(ModemRecord: TLmModemName): Integer;
var
  Detail : TApdModemCapDetail;
  S : string;
begin
  Detail := nil;
  try
    Detail := TApdModemCapDetail.Create(self);
    S := AddBackSlash (FLibModemPath) + 'modemcap.xml';
    Result := Detail.AddModemRecord(S, ModemRecord);
  finally
    Detail.Free;
  end;
end;

function TApdLibModem.DeleteModem(const ModemDetailFile, ModemName: string): Integer;
  { deletes a modem from the modem detail file }
var
  Detail : TApdModemCapDetail;
  S : string;
begin
  Detail := nil;
  try
    Detail := TApdModemCapDetail.Create(self);
    S := AddBackSlash (FLibModemPath) + ModemDetailFile;
    Result := Detail.DeleteModem(S, ModemName);
  finally
    Detail.Free;
  end;
end;

function TApdLibModem.GetModemRecords : TApdLmModemCollection;
var
  I : Integer;
  Item : TApdLmModemCollectionItem;
begin
  LoadModemList;
  Result := TApdLmModemCollection.Create(TApdLmModemCollectionItem);
  for I := 0 to pred(FModemList.Count) do begin
    Item := Result.Add;
    Item.ModemName := PLmModemName(FModemList[I]).ModemName;
    Item.Manufacturer := PLmModemName(FModemList[I]).Manufacturer;
    Item.Model := PLmModemName(FModemList[I]).Model;
    Item.ModemFile := PLmModemName(FModemList[I]).ModemFile;
  end;
end;

function TApdLibModem.DeleteModemRecord(
  ModemRecord: TLmModemName): Integer;
var
  Detail : TApdModemCapDetail;
  S : string;
begin
  Detail := nil;
  try
    Detail := TApdModemCapDetail.Create(self);
    S := AddBackSlash (FLibModemPath) + 'modemcap.xml';
    Result := Detail.DeleteModemRecord(S, ModemRecord);
  finally
    Detail.Free;
  end;
end;

function TApdLibModem.GetModem(const ModemDetailFile,
  ModemName: string; var Modem : TLmModem) : Integer;
  { retrieves a specific modem from the modem detail file }
var
  I : Integer;
begin
  if not FileExists(AddBackSlash (FLibModemPath) +
    ModemDetailFile) then begin
    Result := ecFileNotFound;
    Exit;
  end;
  LoadModem(ModemDetailFile, False);
  { assume we won't find this particular modem }
  Result := ecModemNotFound;
  for I := 0 to pred(FModem.Count) do begin
    if PLmModem(FModem[I])^.FriendlyName = ModemName then begin
      { oops, we assumed wrong... }
      Modem := PLmModem(FModem[I])^; // --sz Move(PLmModem(FModem[I])^, Modem, SizeOf(TLmModem));       // --sm check
      Result := ecOK;
      Break;
    end;
  end;
end;

function TApdLibModem.GetModems(const ModemDetailFile : string): TStringList;
  { retrieves all modems from a modem detail file       }
  { Result is a TStringList, .Strings is the modem name }
  {                          .Objects is the TLmModem   }
var
  I : Integer;
  ModemDetail : TLmModemClass;
  LmModem : TLmModem;
  Res : TStringList;
begin
  Res := TStringList.Create;
  LoadModem(ModemDetailFile, False);
  for I := 0 to pred(FModem.Count) do begin
    ModemDetail := TLmModemClass.Create;
    lmModem := PLmModem(FModem[I])^; // --sz  Move(PLmModem(FModem[I])^, LmModem, SizeOf(TLmModem));
    ModemDetail.LmModem := LmModem;
    Res.AddObject(ModemDetail.LmModem.FriendlyName, ModemDetail);
  end;
  Result := Res;
end;

function TApdLibModem.IsModemValid(ModemFile, ModemName: string): Boolean;{!!.04}
var
  Res : Integer;
  LmMdm : TLmModem;
begin
  { make sure the dir is present }
  Res := GetFileAttributes(PChar(LibModemPath));
  Result := (Res <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Res <> 0);
  { selecting a specific modem from a specific detail }
  if (Result) and (ModemFile <> '') and (ModemName <> '') then
    if GetModem(ModemFile, ModemName, LmMdm) <> ecOK then
      { we couldn't find the modem }
      Result := False;
end;

{ TApdLmModemCollection }

function TApdLmModemCollection.GetItem(Index: Integer): TApdLmModemCollectionItem;
begin
  Result := TApdLmModemCollectionItem(inherited GetItem(Index));
end;

procedure TApdLmModemCollection.SetItem(Index: Integer; const Value: TApdLmModemCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TApdLmModemCollection.Add : TApdLmModemCollectionItem;
begin
  Result := TApdLmModemCollectionItem(inherited Add);
end;


{ TApxModemSelectionDialog }

procedure TApdModemSelectionDialog.FormCreate(Sender: TObject);
begin
  AvailableModems := TStringList.Create;
  Activated := False;                                                    {!!.02}
end;

procedure TApdModemSelectionDialog.FormActivate(Sender: TObject);
{const}                                                                  {!!.02}
  {Activated : Boolean = False;}                                         {!!.02}
begin
  { make sure we load modemcap only once }
  if Activated then exit;
  Activated := True;
  Repaint;
  { save the existing event handlers }
  OldOnLoadModemRecord := ModemList.OnLoadModemRecord;
  OldOnLoadModem := ModemList.OnLoadModem;
  { use ours }
  ModemList.OnLoadModemRecord := LoadModemRecordEvent;
  ModemList.OnLoadModem := LoadModemEvent;

  { this could take awhile, change the cursor... }
  Screen.Cursor := crHourglass;
  ModemList.LoadModemList;
  { ...awhile is over, change the cursor back and update our label }
  Screen.Cursor := crDefault;
  AvailableModems.Sort;
  lblText.Caption := 'Select the modem manufacturer from the list below,' +
    ' then select the modem name.'
end;

procedure TApdModemSelectionDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  { restore the original events }
  ModemList.OnLoadModemRecord := OldOnLoadModemRecord;
  ModemList.OnLoadModem := OldOnLoadModem;
  while AvailableModems.Count > 0 do begin                               {!!.05}
    AvailableModems.Objects[pred(AvailableModems.Count)].Free;           {!!.05}
    AvailableModems.Delete(pred(AvailableModems.Count));                 {!!.05}
  end;                                                                   {!!.05}
  AvailableModems.Free;
end;

procedure TApdModemSelectionDialog.LoadModemEvent(ModemName, Manufacturer,
  Model: string; var CanLoad: Boolean);
begin
  if (Manufacturer = cbxManufacturer.Text) and
    ((ModemName = cbxName.Text) or (Model = cbxName.Text)) then
      CanLoad := True
    else
      CanLoad := False;
end;

procedure TApdModemSelectionDialog.LoadModemRecordEvent(ModemName, Manufacturer,
  Model, ModemFile: string; var CanLoad: Boolean);
var
  ModemList : TApdLmModemNameClass;
begin
  ModemList := TApdLmModemNameClass.Create;
  ModemList.ModemName := ModemName;
  ModemList.Manufacturer := Manufacturer;
  ModemList.Model := Model;
  ModemList.ModemFile := ModemFile;
  AvailableModems.AddObject(Manufacturer, ModemList);
  if cbxManufacturer.Items.IndexOf(Manufacturer) = -1 then
    cbxManufacturer.Items.Add(Manufacturer);
end;

procedure TApdModemSelectionDialog.cbxManufacturerSelect(Sender: TObject);
  { show the modems from the selected manufacturer }
var
  I : Integer;
  ModemName : string;
begin
  I := AvailableModems.IndexOf(cbxManufacturer.Text);
  if I > -1 then begin
    cbxName.Items.Clear;
    while AvailableModems[I] = cbxManufacturer.Text do begin
      ModemName := TApdLmModemNameClass(AvailableModems.Objects[I]).ModemName;
      if ModemName = '' then
        ModemName := TApdLmModemNameClass(AvailableModems.Objects[I]).Model;
      cbxName.Items.Add(ModemName);
      inc(I);
      if I > pred(AvailableModems.Count) then break;
    end;
  end;
  btnOK.Enabled := (cbxManufacturer.ItemIndex > -1) and                  {!!.02}
    (cbxName.ItemIndex > -1);                                            {!!.02}
end;

procedure TApdModemSelectionDialog.btnOKClick(Sender: TObject);
var
  ModemName : string;
  I : Integer;
begin
  if (cbxManufacturer.Text <> '') and (cbxName.Text <> '') then begin
    I := AvailableModems.IndexOf(cbxManufacturer.Text);
    if I > -1 then begin
      ModemName := cbxName.Text;
      while I < pred(AvailableModems.Count) do begin
        ModemName := TApdLmModemNameClass(AvailableModems.Objects[I]).ModemName;
        if ModemName = '' then
          ModemName := TApdLmModemNameClass(AvailableModems.Objects[I]).Model;
        if ModemName = cbxName.Text then begin
          SelectedModemFile := TApdLmModemNameClass(AvailableModems.Objects[I]).ModemFile;
          break;
        end else
          inc(I);
        if I > pred(AvailableModems.Count) then break;
      end;
      ModemList.LoadModem(SelectedModemFile, True);
      SelectedModemManufacturer := cbxManufacturer.Text;
      SelectedModemName := ModemName;
      ModalResult := mrOK;
    end;
  end else
    ShowMessage('Select a modem manufacturer and name');
end;


procedure TApdModemSelectionDialog.cbxNameChange(Sender: TObject);
begin
  btnOK.Enabled := (cbxManufacturer.ItemIndex > -1) and                  {!!.02}
    (cbxName.ItemIndex > -1);                                            {!!.02}
end;

end.

