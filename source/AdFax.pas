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
 *  Stephen W. Boyd             - Fixed a problem where an application would
 *                                throw an access violation when shutting down.
 *                                Added check for existance of FaxList before
 *                                attempting to access it in FindFax and
 *                                TApdCustomAbstractFax.Destroy.  
 *  Kevin G. McCoy              - Fixed line end corruption on fax logs. 4 Feb 2007
 *   Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                    ADFAX.PAS 4.06                     *}
{*********************************************************}
{* TApdAbstractFax, TApdSendFax, TApdReceiveFax, status  *}
{* and log components                                    *}
{*********************************************************}
{* These components are wrappers to the low-level fax    *}
{* code found in the AwFax and AwAbsFax units.           *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$I+,G+,X+,F+,V-,J+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdFax;
  {-Fax send/receive components}

interface

uses         
  Windows,
  SysUtils,
  Classes,
  Messages,
  Controls,
  Graphics,
  Forms,
  OoMisc,
  AwUser,
  AwAbsFax,
  AwFax,
  AwFaxCvt,
  AdExcept,
  AdPort,
  AdTapi,
  AdTUtil;

type
  {Fax classes}
  TFaxClass = (fcUnknown, fcDetect, fcClass1, fcClass2, fcClass2_0);
  TFaxClassSet = set of TFaxClass;

  {General fax event handlers}
  TFaxStatusEvent = procedure(CP : TObject; First, Last : Boolean) of object;
  TFaxLogEvent    = procedure(CP : TObject; LogCode : TFaxLogCode) of object;
  TFaxErrorEvent  = procedure(CP : TObject; ErrorCode : Integer) of object;
  TFaxFinishEvent = procedure(CP : TObject; ErrorCode : Integer) of object;

  {Receive fax event handlers}
  TFaxAcceptEvent = procedure(CP : TObject; var Accept : Boolean) of object;
  TFaxNameEvent   = procedure(CP : TObject; var Name : TPassString) of object;

  {Transmit fax event handlers}
  TFaxNextEvent   = procedure(CP : TObject;
                              var APhoneNumber : TPassString;
                              var AFaxFile : TPassString;
                              var ACoverFile : TPassString) of object;

  {Modem command string}
  TModemString = String[40];
  TStationID   = String[20];

  {Fax send/receive mode}
  TFaxMode = (fmNone, fmSend, fmReceive);

  {Automatic Fax naming modes}
  TFaxNameMode = (fnNone, fnCount, fnMonthDay);

const
  {Defaults for fax log}
  adfDefFaxHistoryName     = 'APROFAX.HIS';

  {Defaults for TApdCustomAbstractFax properties}
  adfDefInitBaud       = 0;
  adfDefNormalBaud     = 0;
  adfDefFaxClass       = fcDetect;
  adfDefAbortNoConnect = False;
  adfDefExitOnError    = False;
  adfDefSoftwareFlow   = False;
  adfDefFaxStatusInterval = 1;        {in seconds}
  adfDefDesiredBPS     = 9600;
  adfDefDesiredECM     = False;

  {Defaults for TApdReceiveFax properties}
  adfDefAnswerOnRing   = 1;
  adfDefFaxAndData     = False;
  adfDefOneFax         = False;
  adfDefConstantStatus = False;
  adfDefSafeMode       = True;
  adfDefFaxFileExt     = 'APF';

  {Defaults for TApdSendFax properties}
  adfDefBlindDial      = False;
  adfDefDetectBusy     = True;                                         
  adfDefToneDial       = True;
  adfDefDialWait       = 60;       {in seconds}
  adfDefDialAttempts   = 3;
  adfDefDialRetryWait  = 60;       {in seconds}
  adfDefMaxSendCount   = 50;
  adfDefBufferMinimum  = 1000;
  adfDefFaxNameMode    = fnCount;
  adfDefDestinationDir = '';

type
  {Forwards}
  TApdAbstractFaxStatus = class;
  TApdFaxLog = class;

  {Custom abstract fax component}
  TApdCustomAbstractFax = class(TApdBaseComponent)
  protected
    {Private}
    Fax          : PFaxRec;      {Data structure for send/receive}
    FaxMode      : TFaxMode;     {Sending or receiving?}
    MsgHandler   : HWnd;         {Fax message window}
    PrepProc     : TFaxPrepProc; {Procedure for preparing to fax}
    FaxFunc      : TFaxFunc;     {Function for fax session}
    FWaitForTapi : Boolean;      {Flag indicating that we're waiting for TAPI}
    FTapiPrepared: Boolean;      {Flag indicating we're hooked into TAPI events}{!!.04}
    FUserOnTapiPortOpen : TNotifyEvent;   {the TapiDevice.OnTapiPortOpen event}
    FUserOnTapiPortClose : TNotifyEvent;  {the TapiDevice.OnTapiPortClose event}
    FUserOnTapiStatus : TTapiStatusEvent; {the TapiDevice.OnTapiStatus event}

    {General}
    FModemModel    : TPassString;  {Modem model string}
    FModemChip     : TPassString;  {Modem chip string}
    FModemRevision : TPassString;  {Modem revision string}
    FModemBPS      : Integer;      {Highest BPS supported by modem}
    FCorrection    : Boolean;      {True if modem supports ECM}
    FComPort       : TApdCustomComport;     {ComPort component}
    FTapiDevice    : TApdCustomTapiDevice;  {TapiDevice component}
    FStatusDisplay : TApdAbstractFaxStatus; {Status component}
    FFaxLog        : TApdFaxLog;            {Logging component}
    FFaxFile       : TPassString;           {Fax file name}
    FSupportedFaxClasses :TFaxClassSet;     {Holds supported class info}

    {Internal}
    FVersion       : Integer;
    FTempFile      : TPassString;                
    FStartTime     : DWORD;

    {Events}
    FOnFaxStatus   : TFaxStatusEvent;
    FOnFaxLog      : TFaxLogEvent;
    FOnFaxError    : TFaxErrorEvent;
    FOnFaxFinish   : TFaxFinishEvent;

    {Property get/set methods}
    function GetElapsedTime: DWORD;                                    
    function GetFaxFile : TPassString; virtual;
    procedure SetFaxFile(const NewFile : TPassString); virtual;
    function GetInitBaud : Integer;
    procedure SetInitBaud(const NewBaud : Integer);
    function GetInProgress: Boolean;                                   
    function GetNormalBaud : Integer;
    procedure SetNormalBaud(const NewBaud : Integer);
    function GetFaxClass : TFaxClass;
    procedure SetFaxClass(const NewClass : TFaxClass);
    function GetModemInit : TModemString;
    procedure SetModemInit(const NewInit : TModemString);
    function GetStationID : TStationID;
    procedure SetStationID(const NewID : TStationID);
    procedure SetComPort(const NewPort : TApdCustomComPort);
    procedure SetStatusDisplay(const NewDisplay : TApdAbstractFaxStatus);
    procedure SetFaxLog(const NewLog : TApdFaxLog);
    function GetRemoteID : TStationID;
    function GetSupportedFaxClasses : TFaxClassSet;
    function GetFaxProgress : Word;
    function GetFaxError : Integer;
    function GetSessionBPS : Word;
    function GetSessionResolution : Boolean;
    function GetSessionWidth : Boolean;
    function GetSessionECM : Boolean;
    function GetHangupCode : Word;
    function GetLastPageStatus : Boolean;
    function GetModemModel : TPassString;
    function GetModemRevision : TPassString;
    function GetModemChip : TPassString;
    function GetModemBPS : Integer;
    function GetModemECM : Boolean;
    function GetTotalPages : Word;
    function GetCurrentPage : Word;
    function GetBytesTransferred : Integer;
    function GetPageLength : Integer;
    function GetAbortNoConnect : Boolean;
    procedure SetAbortNoConnect (NewValue : Boolean);
    function GetExitOnError : Boolean;
    procedure SetExitOnError(NewValue : Boolean);
    function GetSoftwareFlow : Boolean;
    procedure SetSoftwareFlow(NewValue : Boolean);
    function GetStatusInterval : Word;
    procedure SetStatusInterval(NewValue : Word);
    function GetDesiredBPS : Word;
    procedure SetDesiredBPS(NewBPS : Word);
    function GetDesiredECM : Boolean;
    procedure SetDesiredECM(NewECM : Boolean);
    function GetFaxFileExt : TPassString;
    procedure SetFaxFileExt(const NewExt : TPassString);

    {Private methods}
    procedure CheckPort;
    procedure CreateFaxMessageHandler;
    procedure Notification(AComponent : TComponent;
                           Operation : TOperation); override;

    procedure PrepareTapi; virtual;
    procedure UnprepareTapi; virtual;
    procedure OpenTapiPort;
    procedure CloseTapiPort;
    procedure WaitForTapi;                                               {!!.04}
    {TapiDevice event handlers}
    procedure FaxTapiPortOpenClose(Sender : TObject);

    procedure Loaded; override;
    procedure ReadVersionCheck(Reader : TReader);
    procedure WriteVersionCheck(Writer : TWriter);
    procedure DefineProperties(Filer : TFiler); override;

    {Event methods}
    procedure apwFaxStatus(CP : TObject; First, Last : Boolean); virtual;
    procedure apwFaxLog(CP : TObject; LogCode : TFaxLogCode); virtual;
    procedure apwFaxError(CP : TObject; ErrorCode : Integer); virtual;
    procedure apwFaxFinish(CP : TObject; ErrorCode : Integer); virtual;

  public {published later}
    property InitBaud : Integer
      read GetInitBaud write SetInitBaud default adfDefInitBaud;
    property NormalBaud : Integer
      read GetNormalBaud write SetNormalBaud default adfDefNormalBaud;
    property FaxClass : TFaxClass
      read GetFaxClass write SetFaxClass default adfDefFaxClass;
    property ModemInit : TModemString
      read GetModemInit write SetModemInit;
    property StationID : TStationID
      read GetStationID write SetStationID;
    property ComPort : TApdCustomComPort
      read FComPort write SetComPort;
    property TapiDevice : TApdCustomTapiDevice
      read FTapiDevice write FTapiDevice;
    property StatusDisplay : TApdAbstractFaxStatus
      read FStatusDisplay write SetStatusDisplay;
    property FaxLog : TApdFaxLog
      read FFaxLog write SetFaxLog;
    property FaxFile : TPassString
      read GetFaxFile write SetFaxFile;
    property AbortNoConnect : Boolean
      read GetAbortNoConnect write SetAbortNoConnect default adfDefAbortNoConnect;
    property ExitOnError : Boolean
      read GetExitOnError write SetExitOnError default adfDefExitOnError;
    property SoftwareFlow : Boolean
      read GetSoftwareFlow write SetSoftwareFlow default adfDefSoftwareFlow;
    property StatusInterval : Word
      read GetStatusInterval write SetStatusInterval default adfDefFaxStatusInterval;
    property DesiredBPS : Word
      read GetDesiredBPS write SetDesiredBPS default adfDefDesiredBPS;
    property DesiredECM : Boolean
      read GetDesiredECM write SetDesiredECM default adfDefDesiredECM;
    property FaxFileExt : TPassString
      read GetFaxFileExt write SetFaxFileExt;

    {Fax events}
    property OnFaxStatus : TFaxStatusEvent
      read FOnFaxStatus write FOnFaxStatus;
    property OnFaxLog : TFaxLogEvent
      read FOnFaxLog write FOnFaxLog;
    property OnFaxError : TFaxErrorEvent
      read FOnFaxError write FOnFaxError;
    property OnFaxFinish : TFaxFinishEvent
      read FOnFaxFinish write FOnFaxFinish;

 public
    {Runtime, readonly properties}
    property SupportedFaxClasses : TFaxClassSet
      read GetSupportedFaxClasses;
    property FaxProgress : Word
      read GetFaxProgress;
    property FaxError : Integer
      read GetFaxError;
    property SessionBPS : Word
      read GetSessionBPS;
    property SessionResolution : Boolean
      read GetSessionResolution;
    property SessionWidth : Boolean
      read GetSessionWidth;
    property SessionECM : Boolean
      read GetSessionECM;
    property HangupCode : Word
      read GetHangupCode;
    property LastPageStatus : Boolean
      read GetLastPageStatus;
    property ModemModel : TPassString
      read GetModemModel;
    property ModemRevision: TPassString
      read GetModemRevision;
    property ModemChip : TPassString
      read GetModemChip;
    property ModemBPS : Integer
      read GetModemBPS;
    property ModemECM : Boolean
      read GetModemECM;
    property TotalPages : Word
      read GetTotalPages;
    property CurrentPage : Word
      read GetCurrentPage;
    property BytesTransferred : Integer
      read GetBytesTransferred;
    property PageLength : Integer
      read GetPageLength;
    property RemoteID : TStationID
      read GetRemoteID;
    property ElapsedTime : DWORD
      read GetElapsedTime;
    property InProgress : Boolean
      read GetInProgress;

    {Creation/destruction}
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdAbstractFax component}
    destructor Destroy; override;
      {-Destroy a tApdAbstractFax component}

    {General}
    procedure CancelFax;
      {-Cancel the fax session}
    function StatusMsg(const Status : Word) : TPassString;
      {-Return a status message for Status}
    function LogMsg(const LogCode : TFaxLogCode) : string;               {!!.04}
      {-Return a string describing the log code }
  end;

  {Abstract fax status class}
  TApdAbstractFaxStatus = class(TApdBaseComponent)
  protected {private}
    {.Z+}
    FDisplay         : TForm;
    FPosition        : TPosition;
    FCtl3D           : Boolean;
    FVisible         : Boolean;
    FCaption         : TCaption;

    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

  protected
    FFax             : TApdCustomAbstractFax;

    procedure SetPosition(const NewPosition : TPosition);
    procedure SetCtl3D(const NewCtl3D : Boolean);
    procedure SetVisible(const NewVisible : Boolean);
    procedure GetProperties;
    procedure SetCaption(const NewCaption : TCaption);
    procedure Show;

  public
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdAbstractStatus component}
    destructor Destroy; override;
      {-Destroy a TApdAbstractStatus component}
    {.Z-}
    procedure UpdateDisplay(const First, Last : Boolean); virtual; abstract;
      {-Update the status display with current data}
    procedure CreateDisplay; dynamic; abstract;
      {-Create the status display}
    procedure DestroyDisplay; dynamic; abstract;
      {-Destroy the status display}

    property Display : TForm
      read FDisplay write FDisplay;

  published
    property Position : TPosition
      read FPosition write SetPosition;
    property Ctl3D : Boolean
      read FCtl3D write SetCtl3D;
    property Visible : Boolean
      read FVisible write SetVisible;
    property Fax : TApdCustomAbstractFax
      read FFax write FFax;
    property Caption : TCaption
      read FCaption write SetCaption;
  end;

  {Builtin faxlog procedure}
  TApdFaxLog = class(TApdBaseComponent)
  protected
    {.Z+}
    FFaxHistoryName : TPassString;                                       {!!.02}
    FFax            : TApdCustomAbstractFax;

    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

  public
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdFaxLog component}
    {.Z-}
    function GetLogString(const Log : TFaxLogCode;
      aFax : TApdCustomAbstractFax): string; virtual;                    {!!.04}
      {-Returns a log string }
    procedure UpdateLog(const Log : TFaxLogCode); virtual;
      {-Add a log entry}

  published
    property FaxHistoryName : TPassString                                {!!.02}
      read FFaxHistoryName write FFaxHistoryName;
    property Fax : TApdCustomAbstractFax
      read FFax write FFax;
  end;

  {Abstract fax component}
  TApdAbstractFax = class(TApdCustomAbstractFax)
  published
    property InitBaud;
    property NormalBaud;
    property FaxClass;
    property ModemInit;
    property StationID;
    property ComPort;
    property TapiDevice;
    property StatusDisplay;
    property FaxLog;
    property FaxFile;
    property AbortNoConnect;
    property ExitOnError;
    property SoftwareFlow;
    property StatusInterval;
    property DesiredBPS;
    property DesiredECM;
    property FaxFileExt;
    property OnFaxStatus;
    property OnFaxLog;
    property OnFaxError;
    property OnFaxFinish;
  end;

  {Receive fax custom component}
  TApdCustomReceiveFax = class(TApdAbstractFax)
  protected
    {General}
    FFaxNameMode      : TFaxNameMode;  {Automatic fax name mode}

    {Read only}
    RingCount         : Word;          {Number of rings received so far}

    FOnFaxAccept      : TFaxAcceptEvent;
    FOnFaxName        : TFaxNameEvent;

    {Property access methods}
    function GetAnswerOnRing : Word;
    procedure SetAnswerOnRing(const NewVal : Word);
    function GetFaxAndData : Boolean;
    procedure SetFaxAndData(const NewVal : Boolean);
    function GetOneFax : Boolean;
    procedure SetOneFax(NewValue : Boolean);
    function GetConstantStatus : Boolean;
    procedure SetConstantStatus(const NewValue : Boolean);
    function GetDestinationDir : TPassString;
    procedure SetDestinationDir(const NewDir : TPassString);

    {Event message methods}
    procedure apwFaxAccept(CP : TObject; var Accept : Boolean); virtual;
    procedure apwFaxName(CP : TObject; var Name : TPassString); virtual;

  public
    {Properties}
    property AnswerOnRing : Word
      read GetAnswerOnRing write SetAnswerOnRing default adfDefAnswerOnRing;
    property FaxAndData : Boolean
      read GetFaxAndData write SetFaxAndData default adfDefFaxAndData;
    property FaxNameMode : TFaxNameMode
      read FFaxNameMode write FFaxNameMode default adfDefFaxNameMode;
    property OneFax : Boolean
      read GetOneFax write SetOneFax default adfDefOneFax;
    property ConstantStatus : Boolean
      read GetConstantStatus write SetConstantStatus default adfDefConstantStatus;
    property DestinationDir : TPassString
      read GetDestinationDir write SetDestinationDir;

    {Event properties}
    property OnFaxAccept : TFaxAcceptEvent
      read FOnFaxAccept write FOnFaxAccept;
    property OnFaxName : TFaxNameEvent
      read FOnFaxName write FOnFaxName;

    { TAPI integration stuff }
    procedure PrepareTapi; override;
    procedure UnprepareTapi; override;
    procedure TapiPassiveAnswer;
    procedure FaxTapiStatus(CP: TObject; First, Last: Boolean;
      Device, Message, Param1, Param2, Param3: Integer);

  public
    {Creation/destruction}
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdReceiveFax component}
    destructor Destroy; override;
      {-Destroy a TApdReceiveFax component}

    {User control}
    procedure InitModemForFaxReceive;
      {-Send necessary commands to initialize modem for fax receive}
    procedure PrepareConnectInProgress;
      {-Prepare to connect to a fax session already in progress}
    procedure StartReceive;
      {-Start a background fax receive session}
    procedure StartManualReceive(SendATAToModem : Boolean);
      {-Start an immediate receive, optionally picking up call with modem}
  end;

  {Receive fax component}
  TApdReceiveFax = class(TApdCustomReceiveFax)
  published
    property AnswerOnRing;
    property FaxAndData;
    property FaxNameMode;
    property OneFax;
    property ConstantStatus;
    property DestinationDir;
    property OnFaxAccept;
    property OnFaxName;
  end;

  {Send fax component}
  TApdCustomSendFax = class(TApdAbstractFax)
  protected
    {Private}
    WasSent     : Boolean;

    {Properties}
    FCoverFile   : TPassString;
    FFaxFileList : TStringList;
    FPhoneNumber : TPassString;

    {Event properties}
    FOnFaxNext : TFaxNextEvent;

    {Property access methods}
    function GetFastPage : Boolean;
    procedure SetFastPage(const NewVal : Boolean);
    function GetEnhTextEnabled : Boolean;
    procedure SetEnhTextEnabled(const NewVal : Boolean);
    function GetEnhHeaderFont : TFont;
    procedure SetEnhHeaderFont(const NewVal : TFont);
    function GetEnhFont : TFont;
    procedure SetEnhFont(const NewVal : TFont);
    procedure SetFaxFileList(const NewVal : TStringList);
    function GetFaxFile : TPassString; override;
    procedure SetFaxFile(const NewFile : TPassString); override;
    function GetBlindDial : Boolean;
    procedure SetBlindDial(const NewVal : Boolean);
    function GetDetectBusy : Boolean;
    procedure SetDetectBusy(const NewVal : Boolean);                
    function GetToneDial : Boolean;
    procedure SetToneDial(const NewVal : Boolean);
    function GetDialPrefix : TModemString;
    procedure SetDialPrefix(const NewPrefix : TModemString);
    function GetDialWait : Word;
    procedure SetDialWait(const NewWait : Word);
    function GetDialAttempts : Word;
    procedure SetDialAttempts(const NewAttempts : Word);
    function GetDialRetryWait : Word;
    procedure SetDialRetryWait(const NewWait : Word);
    function GetMaxSendCount : Word;
    procedure SetMaxSendCount(const NewCount : Word);
    function GetBufferMinimum : Word;
    procedure SetBufferMinimum(const NewMin : Word);
    function GetHeaderLine : TPassString;
    procedure SetHeaderLine(const S : TPassString);
    function GetDialAttempt : Word;
    function GetSafeMode : Boolean;
    procedure SetSafeMode(NewMode : Boolean);
    function GetHeaderSender : TPassString;
    procedure SetHeaderSender(const NewSender : TPassString);
    function GetHeaderRecipient : TPassString;
    procedure SetHeaderRecipient(const NewRecipient : TPassString);
    function GetHeaderTitle : TPassString;
    procedure SetHeaderTitle(const NewTitle : TPassString);

    {Event methods}
    procedure apwFaxNext(CP : TObject;
                         var APhoneNumber : TPassString;
                         var AFaxFile : TPassString;
                         var ACoverFile : TPassString); virtual;

  public
    {Read/write properties}
    property FastPage : Boolean
      read GetFastPage write SetFastPage;
    property EnhTextEnabled : Boolean
      read GetEnhTextEnabled write SetEnhTextEnabled;
    property EnhHeaderFont : TFont
      read GetEnhHeaderFont write SetEnhHeaderFont;
    property EnhFont : TFont
      read GetEnhFont write SetEnhFont;
    property FaxFileList : TStringList
      read FFaxFileList write SetFaxFileList;
    property BlindDial : Boolean
      read GetBlindDial write SetBlindDial default adfDefBlindDial;
    property DetectBusy : Boolean
      read GetDetectBusy write SetDetectBusy default adfDefDetectBusy; 
    property ToneDial : Boolean
      read GetToneDial write SetToneDial default adfDefToneDial;
    property DialPrefix : TModemString
      read GetDialPrefix write SetDialPrefix;
    property DialWait : Word
      read GetDialWait write SetDialWait default adfDefDialWait;
    property DialAttempts : Word
      read GetDialAttempts write SetDialAttempts default adfDefDialAttempts;
    property DialRetryWait : Word
      read GetDialRetryWait write SetDialRetryWait default adfDefDialRetryWait;
    property MaxSendCount : Word
      read GetMaxSendCount write SetMaxSendCount default adfDefMaxSendCount;
    property BufferMinimum : Word
      read GetBufferMinimum write SetBufferMinimum default adfDefBufferMinimum;
    property HeaderLine : TPassString
      read GetHeaderLine write SetHeaderLine;
    property CoverFile : TPassString
      read FCoverFile write FCoverFile;
    property PhoneNumber : TPassString
      read FPhoneNumber write FPhoneNumber;
    property SafeMode : Boolean
      read GetSafeMode write SetSafeMode default adfDefSafeMode;
    property HeaderSender : TPassString
      read GetHeaderSender write SetHeaderSender;
    property HeaderRecipient : TPassString
      read GetHeaderRecipient write SetHeaderRecipient;
    property HeaderTitle : TPassString
      read GetHeaderTitle write SetHeaderTitle;

    {Read only properties}
    property DialAttempt : Word
      read GetDialAttempt;

    {Events}
    property OnFaxNext : TFaxNextEvent
      read FOnFaxNext write FOnFaxNext;

  public
    {Creation/destruction}
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdSendFax component}
    destructor Destroy; override;
      {-Destroy a TApdSendFax component}

    procedure ConvertCover(const InCover, OutCover : string);          
      {Replace the tags in a text cover page }
    procedure ConcatFaxes(FileName : TPassString);
      {-Concat faxes in list to single file}
    procedure StartTransmit;
      {-Start a background fax send session}
    procedure StartManualTransmit;
      {-Start a background fax send session, already in progress}   
  end;

  {Send fax component}
  TApdSendFax = class(TApdCustomSendFax)
  published
    property EnhTextEnabled;
    property EnhHeaderFont;
    property EnhFont;
    property FaxFileList;
    property BlindDial;
    property DetectBusy;                                            
    property ToneDial;
    property DialPrefix;
    property DialWait;
    property DialAttempts;
    property DialRetryWait;
    property MaxSendCount;
    property BufferMinimum;
    property HeaderLine;
    property CoverFile;
    property PhoneNumber;
    property SafeMode;
    property DialAttempt;
    property OnFaxNext;
    property HeaderSender;
    property HeaderRecipient;
    property HeaderTitle;
  end;

implementation

uses
  Types, AnsiStrings;

type
  {A list of active TApdXxxFax components}
  PFaxWindowNode = ^TFaxWindowNode;
  TFaxWindowNode = record
    fwWindow   : TApdHwnd;
    fwFax      : TApdCustomAbstractFax;
  end;

var
  FaxList : TList;

{Message handling window for all fax components}

  function FindFax(Handle : TApdHwnd) : TApdCustomAbstractFax;
    {-Return fax component for this window handle}
  var
    I : Integer;
  begin
    if (Assigned(FaxList)) then                                             // SWB
        for I := 0 to FaxList.Count-1 do begin
          with PFaxWindowNode(FaxList.Items[I])^ do begin
            if fwWindow = Handle then begin
              Result := fwFax;
              Exit;
            end;
          end;
        end;
    Result := nil;
  end;

  function FaxMessageHandler(hWindow : TApdHwnd; Msg, wParam : Integer;
                             lParam : Integer) : Integer; stdcall; export;
    {-Window procedure for all APW_FAXXxx messages}
  const
    BoolRes : array[Boolean] of Integer = (0, 1);
  var
    P         : TApdCustomAbstractFax;
    Accept    : Boolean;
    FName     : TPassString;
    Number    : TPassString;
    CoverName : TPassString;
    ErrorCode : Integer;
    Temp      : SmallInt;
  begin
    Temp := word(wParam);
    ErrorCode := Temp;

    P := FindFax(hWindow);
    if Assigned(P) then begin
      Result := 0;
      case Msg of
        {General events}
        APW_FAXSTATUS :
          with P do
            apwFaxStatus(P, wParam = 1, wParam = 2);
        APW_FAXLOG :
          with P do
            apwFaxLog(P, TFaxLogCode(wParam));
        APW_FAXERROR :
          with P do
            apwFaxError(P, ErrorCode);
        APW_FAXFINISH :
          with P do
            apwFaxFinish(P, ErrorCode);

        {Receive events}
        APW_FAXNAME :
          with TApdReceiveFax(P) do begin
            apwFaxName(P, FFaxFile);
            afSetFaxName(Fax, FFaxFile);
          end;

        APW_FAXACCEPT :
          with TApdReceiveFax(P) do begin
            Accept := True;
            apwFaxAccept(P, Accept);
            Result := BoolRes[Accept];
          end;

        {Send events}
        APW_FAXNEXTFILE :
          with TApdSendFax(P) do begin
            apwFaxNext(P, Number, FName, CoverName);
            if Number <> '' then begin
              afSetNextFax(Fax, Number, FName, CoverName);
              Result := 1;
            end else
              Result := 0;
          end;
        else
          Result := DefWindowProc(hWindow, Msg, wParam, lParam);
      end;
    end else
      Result :=  DefWindowProc(hWindow, Msg, wParam, lParam);
  end;

  procedure RegisterFaxMessageHandlerClass;
  const
    Registered : Boolean = False;
  var
    XClass: TWndClass;
  begin
    if Registered then
      Exit;
    Registered := True;

    with XClass do begin
      Style         := 0;
      lpfnWndProc   := @FaxMessageHandler;
      cbClsExtra    := 0;
      cbWndExtra    := 0;
      if ModuleIsLib and not ModuleIsPackage then
        hInstance   := SysInit.hInstance
      else
        hInstance   := System.MainInstance;
      hIcon         := 0;
      hCursor       := 0;
      hbrBackground := 0;
      lpszMenuName  := nil;
      lpszClassName := FaxHandlerClassName;
    end;
    Windows.RegisterClass(XClass);
  end;

{TApdAbstractFax}

  function SearchStatusDisplay(const C : TComponent) : TApdAbstractFaxStatus;
    {-Search for a status display in the same form as TComponent}

    function FindStatusDisplay(const C : TComponent) : TApdAbstractFaxStatus;
    var
      I  : Integer;
    begin
      Result := nil;
      if not Assigned(C) then
        Exit;

      {Look through all of the owned components}
      for I := 0 to C.ComponentCount-1 do begin
        if C.Components[I] is TApdAbstractFaxStatus then begin
          {...and it's not assigned}
          if not Assigned(TApdAbstractFaxStatus(C.Components[I]).FFax) then begin
            Result := TApdAbstractFaxStatus(C.Components[I]);
            Exit;
          end;
        end;

        {If this isn't one, see if it owns other components}
        Result := FindStatusDisplay(C.Components[I]);
      end;
    end;

  begin
    {Search the entire form}
    Result := FindStatusDisplay(C);
  end;

  function SearchFaxLog(const C : TComponent) : TApdFaxLog;
    {-Search for a fax log in the same form as TComponent}

    function FindFaxLog(const C : TComponent) : TApdFaxLog;
    var
      I  : Integer;
    begin
      Result := nil;
      if not Assigned(C) then
        Exit;

      {Look through all of the owned components}
      for I := 0 to C.ComponentCount-1 do begin
        if C.Components[I] is TApdFaxLog then begin
          {...and it's not assigned}
          if not Assigned(TApdFaxLog(C.Components[I]).FFax) then begin
            Result := TApdFaxLog(C.Components[I]);
            Exit;
          end;
        end;

        {If this isn't one, see if it owns other components}
        Result := FindFaxLog(C.Components[I]);
      end;
    end;

  begin
    {Search the entire form}
    Result := FindFaxLog(C);
  end;

  constructor TApdCustomAbstractFax.Create(AOwner : TComponent);
    {-Create a TApdAbstractFax component}
  begin
    Fax := nil;
    inherited Create(AOwner);

    {Inits}
    FaxMode := fmNone;
    FModemModel := '';
    FModemChip := '';
    FModemRevision := '';
    FModemBPS := 0;
    FFaxFile := '';
    FSupportedFaxClasses := [];

    {Search for comport}
    FComPort := SearchComPort(Owner);

    {Force port values}
    if Assigned(FComPort) then with FComPort do begin
      Databits := 8;
      Stopbits := 1;
      Parity := pNone;
      Baud := 19200;
      InSize := 8192;
      OutSize := 8192;
      HWFlowOptions := [hwfUseRTS, hwfRequireCTS];
    end;

    {Search for fax status display}
    StatusDisplay := SearchStatusDisplay(Owner);

    {Search for fax log display}
    FaxLog := SearchFaxLog(Owner);

    {Initialize versioning info}
    FVersion := 0;

    FUserOnTapiPortOpen := nil;                                          {!!.04}
    FUserOnTapiPortClose := nil;                                         {!!.04}
    FUserOnTapiStatus := nil;                                            {!!.04}
  end;

  destructor TApdCustomAbstractFax.Destroy;
    {-Destroy a tApdAbstractFax component}
  var
    I : Integer;
    P : PFaxWindowNode;
  begin
    {Get rid of msg handler window and node}
    if not (csDesigning in ComponentState) then
        if (Assigned(FaxList)) then                                         // SWB
          with FaxList do
            if Count > 0 then
              for I := 0 to Count-1 do begin
                P := PFaxWindowNode(Items[I]);
                if P^.fwFax = Self then begin
                  DestroyWindow(P^.fwWindow);
                  Remove(Items[I]);
                  Dispose(P);
                  break;
                end;
              end;

    inherited Destroy;
  end;

  function TApdCustomAbstractFax.GetFaxFile : TPassString;
    {-Return the fax file name}
  begin
    Result := FFaxFile;
  end;

  procedure TApdCustomAbstractFax.SetFaxFile(const NewFile : TPassString);
    {-Set the fax file name}
  begin
    FFaxFile := NewFile;
  end;

  function TApdCustomAbstractFax.GetInitBaud : Integer;
    {-Return the init baud rate}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cInitBaud
  end;

  procedure TApdCustomAbstractFax.SetInitBaud(const NewBaud : Integer);
    {-Set a new init baud rate}
  begin
    fSetInitBaudRate(Fax, NewBaud, NormalBaud,
                     not (csDesigning in ComponentState));
  end;

  function TApdCustomAbstractFax.GetNormalBaud : Integer;
    {-Return the normal baud rate}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cNormalBaud
  end;

  procedure TApdCustomAbstractFax.SetNormalBaud(const NewBaud : Integer);
    {-Set the normal baud rate}
  begin
    PC12FaxData(Fax)^.fCData^.cNormalBaud := NewBaud;
  end;

  function TApdCustomAbstractFax.GetFaxClass : TFaxClass;
    {-Return the fax class}
  begin
    Result := TFaxClass(Fax^.aPData^.aClassInUse)
  end;

  procedure TApdCustomAbstractFax.SetFaxClass(const NewClass : TFaxClass);
    {-Set the desired fax class}
  begin
    Fax^.aPData^.aClassInUse := OoMisc.ClassType(NewClass);
  end;

  function TApdCustomAbstractFax.GetModemInit : TModemString;
    {-Return the modem init string}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cModemInit
  end;

  procedure TApdCustomAbstractFax.SetModemInit(const NewInit : TModemString);
    {-Set the modem init string}
  begin
    fSetModemInit(Fax,NewInit);
  end;

  function TApdCustomAbstractFax.GetStationID : TStationID;
    {-Return the station ID}
  begin
    Result := Fax^.aPData^.aStationID
  end;

  procedure TApdCustomAbstractFax.SetStationID(const NewID : TStationID);
    {-Set a new station ID}
  begin
    Fax^.aPData^.aStationID := NewID;
  end;

  procedure TApdCustomAbstractFax.SetComPort(const NewPort : TApdCustomComPort);
    {-Set a new comport}
  begin
    if NewPort <> FComPort then begin
      FComPort := NewPort;
      if Assigned(FComPort) then with FComPort do begin
        {Force the critical comport properties}
        if not (csLoading in ComponentState) then begin
          OverrideLine := True;
          Databits := 8;
          Stopbits := 1;
          Parity := pNone;
          Baud := 19200;
          InSize := 8192;
          OutSize := 8192;
          HWFlowOptions := [hwfUseRTS, hwfRequireCTS];
        end;
      end;

      {If we switched comports we probably need new info}
      FModemModel := '';
      FModemChip := '';
      FModemRevision := '';
      FModemBPS := 0;
    end;
  end;

  procedure TApdCustomAbstractFax.SetStatusDisplay(
                                  const NewDisplay : TApdAbstractFaxStatus);
    {-Set the status display component}
  begin
    if NewDisplay <> FStatusDisplay then begin
      FStatusDisplay := NewDisplay;
      if Assigned(FStatusDisplay) then
        FStatusDisplay.FFax := Self;
    end;
  end;

  procedure TApdCustomAbstractFax.SetFaxLog(const NewLog : TApdFaxLog);
    {-Set the fax loggign component}
  begin
    if NewLog <> FFaxLog then begin
      FFaxLog := NewLog;
      if Assigned(FFaxLog) then
        FFaxLog.FFax := Self;
    end;
  end;

  function TApdCustomAbstractFax.GetRemoteID : TStationID;
    {-Return the remote's ID}
  begin
    Result := fGetRemoteID(Fax)
  end;

  function TApdCustomAbstractFax.GetSupportedFaxClasses : TFaxClassSet;
    {-Return the supported classes}
  var
    Class1, Class2, Class2_0 : Boolean;
  begin
    if not Fax^.aPData^.aInProgress then begin
      CheckPort;
      fGetModemClassSupport(Fax, Class1, Class2, Class2_0, False);
      Result := [];
      if Class1 then
        Include(Result, fcClass1);
      if Class2 then
        Include(Result, fcClass2);
      if Class2_0 then
        Include(Result, fcClass2_0);

      {Save it}
      FSupportedFaxClasses := Result;
    end else
      {Can't physically check because we're in progress, return last known}
      Result := FSupportedFaxClasses;
  end;

  function TApdCustomAbstractFax.GetFaxProgress : Word;
    {-Return the current fax progress code}
  begin
    Result := Fax^.aPData^.aFaxProgress
  end;

  function TApdCustomAbstractFax.GetFaxError : Integer;
    {-Return the current fax error code}
  begin
    Result := Fax^.aPData^.aFaxError
  end;

  function TApdCustomAbstractFax.GetSessionBPS : Word;
    {-Return the negotiated BPS}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cSessionBPS
  end;

  function TApdCustomAbstractFax.GetSessionResolution : Boolean;
    {-Return the negotiated resolution (true for high, false for standard)}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cSessionRes
  end;

  function TApdCustomAbstractFax.GetSessionWidth : Boolean;
    {-Return the session width}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cSessionWid
  end;

  function TApdCustomAbstractFax.GetSessionECM : Boolean;
    {-Return the session ECM}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cSessionECM
  end;

  function TApdCustomAbstractFax.GetHangupCode : Word;
    {-Return the last hangup code}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cHangupCode
  end;

  function TApdCustomAbstractFax.GetLastPageStatus : Boolean;
    {-Return the last page status}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cLastPageOK
  end;

  function TApdCustomAbstractFax.GetModemModel : TPassString;
    {-Return the modem model string}
  var
    HighClass : AnsiChar;
  begin
    if (FModemModel = '') and (not Fax^.aPData^.aInProgress) then begin
      {Make sure port is assigned}
      CheckPort;

      {Send the commands to get all info}
      fGetModemInfo(Fax, HighClass, FModemModel, FModemChip,
                    FModemRevision, False);
    end;
    Result := FModemModel;
  end;

  function TApdCustomAbstractFax.GetModemRevision : TPassString;
    {-Return the modem revision string}
  var
    HighClass : AnsiChar;
  begin
    if (FModemRevision = '') and (not Fax^.aPData^.aInProgress) then begin
      {Make sure port is assigned}
      CheckPort;

      {Send the commands to get all info}
      fGetModemInfo(Fax, HighClass, FModemModel, FModemChip,
                    FModemRevision, False);
    end;
    Result := FModemRevision;
  end;

  function TApdCustomAbstractFax.GetModemChip : TPassString;
    {-Return the modem chip string}
  var
    HighClass : AnsiChar;
  begin
    if (FModemChip = '') and (not Fax^.aPData^.aInProgress) then begin
      {Make sure port is assigned}
      CheckPort;

      {Send the commands to get all info}
      fGetModemInfo(Fax, HighClass, FModemModel, FModemChip,
                    FModemRevision, False);
    end;
    Result := FModemChip;
  end;

  function TApdCustomAbstractFax.GetModemBPS : Integer;
    {-Return the highest BPS support by the modem}
  var
    C : AnsiChar;
  begin
    if not Fax^.aPData^.aInProgress then begin
      CheckPort;
      fGetModemFeatures(Fax, FModemBPS, C);
    end;
    Result := FModemBPS;
  end;

  function TApdCustomAbstractFax.GetModemECM : Boolean;
    {-Return True if the modem supports ECM}
  var
    C : AnsiChar;
  begin
    if not Fax^.aPData^.aInProgress then begin
      CheckPort;
      fGetModemFeatures(Fax, FModemBPS, C);
      FCorrection := C = '1';
    end;
    Result := FCorrection;
  end;

  function TApdCustomAbstractFax.GetTotalPages : Word;
    {-Return total pages to transmit, returns 0 when receiving}
  var
    Junk1 : Word;
    Junk2 : Integer;
  begin
    fGetPageInfoC12(Fax, Result, Junk1, Junk2, Junk2)
  end;

  function TApdCustomAbstractFax.GetCurrentPage : Word;
    {-Return the current page, 0 for cover}
  var
    Junk1 : Word;
    Junk2 : Integer;
  begin
    fGetPageInfoC12(Fax, Junk1, Result, Junk2, Junk2)
  end;

  function TApdCustomAbstractFax.GetBytesTransferred : Integer;
    {-Return the bytes transferred for this page}
  var
    Junk1 : Word;
    Junk2 : Integer;
  begin
    fGetPageInfoC12(Fax, Junk1, Junk1, Result, Junk2)
  end;

  function TApdCustomAbstractFax.GetPageLength : Integer;
    {-Return the total bytes for this page, 0 when receiving}
  var
    Junk1 : Word;
    Junk2 : Integer;
  begin
    fGetPageInfoC12(Fax, Junk1, Junk1, Junk2, Result)
  end;

  function TApdCustomAbstractFax.GetAbortNoConnect : Boolean;
    {-Return the AbortNoConnect setting}
  begin
    Result := Fax^.aPData^.afFlags and afAbortNoConnect <> 0
  end;

  procedure TApdCustomAbstractFax.SetAbortNoConnect(NewValue : Boolean);
    {-Enable/disable the AbortNoConnect option}
  begin
    with Fax^.aPData^ do
      if NewValue then
        afFlags := afFlags or afAbortNoConnect
      else
        afFlags := afFlags and not afAbortNoConnect;
  end;

  function TApdCustomAbstractFax.GetExitOnError : Boolean;
    {-Return the ExitOnError setting}
  begin
    Result := Fax^.aPData^.afFlags and afExitOnError <> 0
  end;

  procedure TApdCustomAbstractFax.SetExitOnError(NewValue : Boolean);
    {-Set the ExitOnError option}
  begin
    with Fax^.aPData^ do
      if NewValue then
        afFlags := afFlags or afExitOnError
      else
        afFlags := afFlags and not afExitOnError;
  end;

  function TApdCustomAbstractFax.GetSoftwareFlow : Boolean;
    {-Return the NoSoftwareFlow option}
  begin
    Result := Fax^.aPData^.afFlags and afSoftwareFlow <> 0
  end;

  procedure TApdCustomAbstractFax.SetSoftwareFlow(NewValue : Boolean);
    {-Set the NoSoftwareFlow option}
  begin
    with Fax^.aPData^ do
      if NewValue then
        afFlags := afFlags or afSoftwareFlow
      else
        afFlags := afFlags and not afSoftwareFlow;
  end;

  function TApdCustomAbstractFax.GetStatusInterval : Word;
    {-Return the status interval}
  begin
    Result := Fax^.aPData^.aStatusInterval;
  end;

  procedure TApdCustomAbstractFax.SetStatusInterval(NewValue : Word);
    {-Set a new status interval}
  begin
    Fax^.aPdata^.aStatusInterval := NewValue;
  end;

  function TApdCustomAbstractFax.GetDesiredBPS : Word;
    {-Return the desired BPS rate}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cMaxFaxBPS
  end;

  procedure TApdCustomAbstractFax.SetDesiredBPS(NewBPS : Word);
    {-Set the desired BPS}
  begin
    PC12FaxData(Fax)^.fCData^.cMaxFaxBPS := NewBPS;
  end;

  function TApdCustomAbstractFax.GetDesiredECM : Boolean;
    {-Return the desired ECM state}
  begin
    if PC12FaxData(Fax)^.fCData^.cCheckChar = '0' then
      Result := False
    else
      Result := True
  end;

  procedure TApdCustomAbstractFax.SetDesiredECM(NewECM : Boolean);
    {-Set a new desired ECM}
  const
    CharValue : array[Boolean] of AnsiChar = ('0', '1');
  begin
    PC12FaxData(Fax)^.fCData^.cCheckChar := CharValue[NewECM];
  end;

  function TApdCustomAbstractFax.GetFaxFileExt : TPassString;
    {-Return the fax file extension}
  begin
    Result := Fax^.aPData^.aFaxFileExt
  end;

  procedure TApdCustomAbstractFax.SetFaxFileExt(const NewExt : TPassString);
    {-Set a new fax file extension}
  begin
    Fax^.aPData^.aFaxFileExt := NewExt;
  end;

  procedure TApdCustomAbstractFax.apwFaxStatus(CP : TObject; First, Last : Boolean);
    {-Process the fax status message}
  begin
    if First then                                                        {!!.02}
      FStartTime := 0;                                                   {!!.02}
    if (FaxProgress = fpGotRemoteID) and (FStartTime = 0) then
      FStartTime := AdTimeGetTime;
    {Automatically hand off to status display, if one is attached}
    if Assigned(FStatusDisplay) then
      StatusDisplay.UpdateDisplay(First, Last);

    {Call the users status handler}
    if Assigned(FOnFaxStatus) then
      FOnFaxStatus(CP, First, Last);
  end;

  procedure TApdCustomAbstractFax.apwFaxLog(CP : TObject; LogCode : TFaxLogCode);
    {-Process the fax log message}
  begin
    {Automatically hand off to fax log, if one is attached}
    if Assigned(FFaxLog) then
      FaxLog.UpdateLog(LogCode);

    {Call the user log event}
    if Assigned(FOnFaxLog) then
      FOnFaxLog(CP, LogCode);

    {If receive is ending, clear the faxname field}
    {case LogCode of}                                                    {!!.04}
      {lfaxReceiveOK,}                                                   {!!.04}
      {lfaxReceiveFail,}                                                 {!!.04}
      {lfaxReceiveSkip :}                                                {!!.04}
        {FaxFile := '';}                                                 {!!.04}
    {end;}                                                               {!!.04}
  end;

  procedure TApdCustomAbstractFax.apwFaxError(CP : TObject;
                                              ErrorCode : Integer);
    {-Process the fax error message}
  begin
    if Assigned(FOnFaxError) then
      FOnFaxError(CP, ErrorCode);
  end;

  procedure TApdCustomAbstractFax.apwFaxFinish(CP : TObject;
                                               ErrorCode : Integer);
    {-Process the fax finish message}
  begin
    if Fax^.aPData^.aConcatFax then
      DeleteFile(string(FTempFile));
    if Assigned(FOnFaxFinish) then
      FOnFaxFinish(CP, ErrorCode);
    Fax^.aPData^.aFaxFileName := '';                                     {!!.04}
    if Assigned(FTapiDevice) then begin                                  {!!.04}
      CloseTapiPort;                                                     {!!.04}
      if (FaxMode = fmReceive) and (not TApdCustomReceiveFax(CP).OneFax) then{!!.04}
        TApdCustomReceiveFax(CP).TapiPassiveAnswer                       {!!.04}
      else                                                               {!!.04}
        UnprepareTapi;                                                   {!!.04}
    end;                                                                 {!!.04}
  end;

  procedure TApdCustomAbstractFax.CancelFax;
    {-Cancel the fax session}
  begin
    if (@FaxFunc <> nil) and (Fax^.aPData^.aInProgress) then
      FaxFunc(APW_FAXCANCEL, 0, Integer(ComPort.Dispatcher.Handle) shl 16);
  end;

  function TApdCustomAbstractFax.StatusMsg(const Status : Word) : TPassString;
    {-Return a status message for Status}
  var
    P : array[0..MaxMessageLen] of AnsiChar;
  begin
    afStatusMsg(P, Status);
    Result := AnsiStrings.StrPas(P);
  end;

  function TApdCustomAbstractFax.LogMsg(const LogCode: TFaxLogCode): string;
    {-Return a string describing the log code }
  begin
    { strings defined in AdExcept.inc }
    case LogCode of
      lfaxNone          : Result := slfaxNone;
      lfaxTransmitStart : Result := slfaxTransmitStart;
      lfaxTransmitOk    : Result := slfaxTransmitOk;
      lfaxTransmitFail  : Result := slfaxTransmitFail;
      lfaxReceiveStart  : Result := slfaxReceiveStart;
      lfaxReceiveOk     : Result := slfaxReceiveOk;
      lfaxReceiveSkip   : Result := slfaxReceiveSkip;
      lfaxReceiveFail   : Result := slfaxReceiveFail;
    end;
  end;

  procedure TApdCustomAbstractFax.CheckPort;
    {-Set port's Dispatcher or raise exception}
  begin
    {Make sure comport is open, pass handle to fax}
    if Assigned(FComPort) then begin
      if (FComPort.DeviceLayer = dlWinSock) then
        raise ECannotUseWithWinSock.Create(ecCannotUseWithWinSock, False);

      { let the dispatcher handle the TAPI integration }
      {if (FComPort.TapiMode = tmOn) and (not FComPort.Open) then}       {!!.04}
        {raise ENotOpenedByTapi.Create(ecNotOpenedByTapi, False);}       {!!.04}
      {if Assigned(FTapiDevice) then}                                    {!!.04}
        {FComPort.TapiMode := tmOn;}                                     {!!.04}

      { if this returns nil, the port isn't open, raise the exception here }
      if ComPort.Dispatcher = nil then                                   {!!.04}
        raise ECommNotOpen.Create(ecCommNotOpen, False);                 {!!.04}

      fSetFaxPort(Fax, ComPort.Dispatcher);

      {Make sure output buffer is big enough}
      if ComPort.OutSize < 8192 then
        raise EOutputBufferTooSmall.Create(ecOutputBufferTooSmall, False);
    end else
      raise EPortNotAssigned.Create(ecPortNotAssigned, False);
  end;

  procedure TApdCustomAbstractFax.CreateFaxMessageHandler;
    {-Create message handler window}
  var
    Node : PFaxWindowNode;
    Instance : Integer;
  begin
    if ModuleIsLib and not ModuleIsPackage then
      Instance   := SysInit.hInstance
    else
      Instance   := System.MainInstance;
    MsgHandler :=
      CreateWindow(FaxHandlerClassName,        {window class name}
                   '',                         {caption}
                   0,                          {window style}
                   0,                          {X}
                   0,                          {Y}
                   0,                          {width}
                   0,                          {height}
                   0,                          {parent}
                   0,                          {menu}
                   Instance,
                   nil);                       {parameter}

    if MsgHandler = 0 then
      raise EInternal.Create(ecInternal, False);

    ShowWindow(MsgHandler, sw_Hide);

    {Add to global list}
    Node := nil;
    try
      New(Node);
      Node^.fwWindow := MsgHandler;
      Node^.fwFax := Self;
      FaxList.Add(Node);
    except
      on EOutOfMemory do begin
        if Node <> nil then
          Dispose(Node);
        raise;
      end;
    end;
  end;

  procedure TApdCustomAbstractFax.Notification(AComponent : TComponent;
                                               Operation : TOperation);
    {-Handle dependent components coming and going}
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      {Owned components going away}
      if AComponent = FComPort then
        ComPort := nil;
      if AComponent = FStatusDisplay then
        StatusDisplay := nil;
      if AComponent = FFaxLog then
        FaxLog := nil;
    end else if Operation = opInsert then begin
      {Check for new comport}
      if AComponent is TApdCustomComPort then begin
        if not Assigned(FComPort) then
          ComPort := TApdCustomComPort(AComponent);
      end;

      {Check for new status component}
      if AComponent is TApdAbstractFaxStatus then begin
        if not Assigned(FStatusDisplay) then
          if not Assigned(TApdAbstractFaxStatus(AComponent).FFax) then
            StatusDisplay := TApdAbstractFaxStatus(AComponent);
      end;

      {Check for new status component}
      if AComponent is TApdFaxLog then begin
        if not Assigned(FFaxLog) then
          if not Assigned(TApdFaxLog(AComponent).FFax) then
            FaxLog := TApdFaxLog(AComponent);
      end;
    end;
  end;

  procedure TApdCustomAbstractFax.Loaded;
  begin
    inherited Loaded;

    {reset status interval if old version}
    if (FVersion = 0) then begin
      Fax^.aPData^.aStatusInterval := 1;
      FVersion := 1;
    end;
  end;

  procedure TApdCustomAbstractFax.PrepareTapi;
    { prepare the TapiDevice }
  begin
    if FTapiPrepared then Exit;                                          {!!.04}
    FWaitForTapi := False;
    Fax^.aPData^.aUsingTapi := True;                                     {!!.04}
    FUserOnTapiPortOpen := FTapiDevice.OnTapiPortOpen;
    FTapiDevice.OnTapiPortOpen := FaxTapiPortOpenClose;
    FUserOnTapiPortClose := FTapiDevice.OnTapiPortClose;
    FTapiDevice.OnTapiPortClose := FaxTapiPortOpenClose;
    FUserOnTapiStatus := FTapiDevice.OnTapiStatus;
    FTapiPrepared := True;                                               {!!.04}
  end;

  procedure TApdCustomAbstractFax.UnprepareTapi;
    { called from apwFaxFinish, restore the original event handlers }
  begin
    Fax^.aPData^.aUsingTapi := False;                                    {!!.04}
    FTapiDevice.OnTapiPortOpen := FUserOnTapiPortOpen;
    FTapiDevice.OnTapiPortClose := FUserOnTapiPortClose;
    FTapiPrepared := False;                                              {!!.04}
  end;

  procedure TApdCustomAbstractFax.OpenTapiPort;
    { perform a ConfigAndOpen synchronously }
  begin
    { assumes that TapiDevice is assigned }
    FWaitForTapi := True;
    { open with TAPI }
    FTapiDevice.ConfigAndOpen;
    { wait for the OnTapiPortOpen }
    WaitForTapi;                                                         {!!.04}
    {while FWaitForTapi do}                                              {!!.04}
      {DelayTicks(2, True);}                                             {!!.04}
  end;

  procedure TApdCustomAbstractFax.CloseTapiPort;
    { perform a CancelCall synchronously }
  begin
    if FTapiDevice.WaitingForCall then Exit;                             {!!.04}
    FWaitForTapi := True;
    { tell TAPI to close the port }
    FTapiDevice.CancelCall;
    { wait for the OnTapiPortClose }
    WaitForTapi;                                                         {!!.04}
    {while FWaitForTapi do}                                              {!!.04}
      {DelayTicks(2, True);}                                             {!!.04}
   end;

  procedure TApdCustomAbstractFax.FaxTapiPortOpenClose(Sender : TObject);
  begin
    if FComPort.Open then begin
      // it's an OnTapiPortOpen
      if Assigned(FUserOnTapiPortOpen) then
        FUserOnTapiPortOpen(Sender);
    end else begin
      // it's an OnTapiPortClose
      if Assigned(FUserOnTapiPortClose) then
        FUserOnTapiPortClose(Sender);
    end;
    FWaitForTapi := False;
  end;

const
  CurComponentVersion = 1;

  procedure TApdCustomAbstractFax.ReadVersionCheck(Reader : TReader);
  begin
    FVersion := Reader.ReadInteger;
  end;

  procedure TApdCustomAbstractFax.WriteVersionCheck(Writer : TWriter);
  begin
    FVersion := CurComponentVersion;
    Writer.WriteInteger(FVersion);
  end;

  procedure TApdCustomAbstractFax.DefineProperties(Filer : TFiler);
  begin
    inherited DefineProperties(Filer);

    Filer.DefineProperty('FakeProperty', ReadVersionCheck, WriteVersionCheck, True);
  end;

{TApdCustomReceiveFax}

  constructor TApdCustomReceiveFax.Create(AOwner : TComponent);
    {-Create a TApdReceiveFax component}
  begin
    inherited Create(AOwner);

    {Create the message handler window instance}
    if not (csDesigning in ComponentState) then begin
      RegisterFaxMessageHandlerClass;
      CreateFaxMessageHandler;
    end;

    {Create the ReceiveFax data structure}
    CheckException(Self,
      fInitC12ReceiveFax(Fax, '',  nil, MsgHandler));

    {Inits}
    FaxMode := fmReceive;
    PrepProc := fPrepareFaxReceive;
    FaxFunc := fFaxReceive;

    {All property inits (abstract and receive)}
    AbortNoConnect := adfDefAbortNoConnect;
    ExitOnError := adfDefExitOnError;
    SoftwareFlow := adfDefSoftwareFlow;
    InitBaud := adfDefInitBaud;
    NormalBaud := adfDefNormalBaud;
    FaxClass := adfDefFaxClass;
    AnswerOnRing := adfDefAnswerOnRing;
    FaxAndData := adfDefFaxAndData;
    OneFax := adfDefOneFax;
    ConstantStatus := adfDefConstantStatus;
    FaxNameMode := adfDefFaxNameMode;
    DestinationDir := adfDefDestinationDir;
    FaxFileExt := adfDefFaxFileExt;
  end;

  destructor TApdCustomReceiveFax.Destroy;
    {-Destroy a TApdReceiveFax component}
  begin
    fDoneC12ReceiveFax(Fax);
    inherited Destroy;
  end;

  function TApdCustomReceiveFax.GetAnswerOnRing : Word;
    {-Return the number of rings to wait before answering}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cAnswerOnRing
  end;

  procedure TApdCustomReceiveFax.SetAnswerOnRing(const NewVal : Word);
    {-Set the number of rings to count before answering}
  begin
    PC12FaxData(Fax)^.fCData^.cAnswerOnRing := NewVal;
  end;

  function TApdCustomReceiveFax.GetFaxAndData : Boolean;
    {-Return the FaxAndData setting}
  begin
    Result := (PC12FaxData(Fax)^.fCData^.cFaxAndData = '1')
  end;

  procedure TApdCustomReceiveFax.SetFaxAndData(const NewVal : Boolean);
    {-Enable/disable adaptive answer}
  const
    FaxData : array[Boolean] of AnsiChar = ('0', '1');
  begin
    PC12FaxData(Fax)^.fCData^.cFaxAndData := FaxData[NewVal];
  end;

  function TApdCustomReceiveFax.GetOneFax : Boolean;
    {-Return the value of the OneFax option}
  begin
    Result := PC12ReceiveFax(Fax)^.fOneFax
  end;

  procedure TApdCustomReceiveFax.SetOneFax(NewValue : Boolean);
    {-Set the OneFax option}
  begin
    PC12ReceiveFax(Fax)^.fOneFax := NewValue;
  end;

  function TApdCustomReceiveFax.GetConstantStatus : Boolean;
    {-Return the value of the ConstantStatus option}
  begin
    Result := PC12ReceiveFax(Fax)^.fConstantStatus
  end;

  procedure TApdCustomReceiveFax.SetConstantStatus(const NewValue : Boolean);
    {-Set ConstantStatus behavior on/off}
  begin
    PC12ReceiveFax(Fax)^.fConstantStatus := NewValue;
  end;

  function TApdCustomReceiveFax.GetDestinationDir : TPassString;
    {-Return the destination directory}
  begin
    Result := Fax^.aPData^.aDestDir
  end;

  procedure TApdCustomReceiveFax.SetDestinationDir(const NewDir : TPassString);
    {-Set the destination directory}
  begin
    Fax^.aPData^.aDestDir := AddBackSlash(NewDir);
  end;

  procedure TApdCustomReceiveFax.apwFaxAccept(CP : TObject; var Accept : Boolean);
    {-Process the fax accept message}
  begin
    if Assigned(FOnFaxAccept) then
      FOnFaxAccept(CP, Accept)
    else
      Accept := True;
  end;

  procedure TApdCustomReceiveFax.apwFaxName(CP : TObject;
                                            var Name : TPassString);
    {-Process the fax name message}
  begin
    if Assigned(FOnFaxName) then
      {Use users faxname hook}
      FOnFaxName(CP, Name)
    else begin
      {Nothing assigned, use one of the built in methods}
      case FFaxNameMode of
        fnMonthDay :
          Name := afFaxNameMD(Fax);
        fnCount :
          Name := afFaxNameCount(Fax);
        else
          if FFaxFile = '' then                                          {!!.01}
            Name := 'noname.apf'
          else                                                           {!!.01}
            Name := FFaxFile;                                            {!!.01}
      end;
    end;
    FFaxFile := Name;                                                    {!!.01}
  end;

  procedure TApdCustomReceiveFax.PrepareTapi;
  begin
    inherited;
    FTapiDevice.OnTapiStatus := FaxTapiStatus;
  end;

  procedure TApdCustomReceiveFax.UnprepareTapi;
  begin
    inherited;
    FTapiDevice.OnTapiStatus := FUserOnTapiStatus;
  end;

  procedure TApdCustomReceiveFax.TapiPassiveAnswer;
    { set up the TAPI device for AutoAnswer }
  begin
    FTapiDevice.AnswerOnRing := AnswerOnRing + 10;
    FTapiDevice.AutoAnswer;
  end;

  procedure TApdCustomReceiveFax.FaxTapiStatus(CP: TObject; First, Last: Boolean;
      Device, Message, Param1, Param2, Param3: Integer);
  begin
    if Assigned(FUserOnTapiStatus) then
      FUserOnTapiStatus(CP, First, Last, Device, Message, Param1, Param2, Param3);
    if (Message = Line_LineDevState) and (Param1 = LineDevState_Ringing) then begin
      if Param3 >= AnswerOnRing - 1 then begin
        FTapiDevice.CancelCall;
        OpenTapiPort;
        WaitForTapi;                                                     {!!.04}
        {while not FComPort.Open do}                                     {!!.04}
          {DelayTicks(2, True);}                                         {!!.04}
        {Make sure comport is open, pass handle to fax}
        CheckPort;
        {Validate the port that TAPI gave us}
        with FComPort do begin                                           {!!.04}
          Databits := 8;                                                 {!!.04}
          Stopbits := 1;                                                 {!!.04}
          Parity := pNone;                                               {!!.04}
          Baud := 19200;                                                 {!!.04}
          InSize := 8192;                                                {!!.04}
          OutSize := 8192;                                               {!!.04}
          HWFlowOptions := [hwfUseRTS, hwfRequireCTS];                   {!!.04}
        end;                                                             {!!.04}

        {Start the fax}
        {StartManualReceive(True);}                                      {!!.04}
        {if not PC12ReceiveFax(Fax)^.FcData^.cInitSent then}             {!!.04}
         {PC12ReceiveFax(Fax)^.fFirstState := rfInit;}                   {!!.04}
        afStartFax(Fax, fPrepareFaxReceive, fFaxReceive);
      end;
    end;
  end;

  procedure TApdCustomReceiveFax.InitModemForFaxReceive;
    {-Send nessessary commands to initialize modem for fax receive}
  begin
    if not Fax^.aPData^.aInProgress then begin
      CheckPort;
      if not fInitModemForFaxReceive(Fax) then
        CheckException(Self, ecFaxInitError);
    end;
  end;

  procedure TApdCustomReceiveFax.PrepareConnectInProgress;
    {-Prepare to connect to a fax session already in progress}
  begin
    fSetConnectState(Fax);
  end;

  procedure TApdCustomReceiveFax.StartReceive;
    {-Start a background fax receive session}
  begin
    with Fax^ do begin
      { integrate with TAPI }
      if Assigned(FTapiDevice) then begin
        { set up the event handlers }
        PrepareTapi;
        { put TapiDevice in AutoAnswer mode }
        TapiPassiveAnswer;
        { don't need to do anything else here, we'll react to TAPI status }
        Exit;
      end;
      {Make sure comport is open, pass handle to fax}
      CheckPort;

      {Start the fax}
      if FaxMode = fmReceive then begin
        if not PC12ReceiveFax(Fax)^.FcData^.cInitSent then
          PC12ReceiveFax(Fax)^.fFirstState := rfInit;
        afStartFax(Fax, fPrepareFaxReceive, fFaxReceive);
      end;
    end;
  end;

  procedure TApdCustomReceiveFax.StartManualReceive(SendATAToModem : Boolean);
    {-Start an immediate fax receive}
  begin
    with PC12ReceiveFax(Fax)^, fcData^, fpData^ do begin
      {Make sure comport is open, pass handle to fax}
      if Assigned(FTapiDevice) then begin                                {!!.04}
        { set up the event handlers }
        PrepareTapi;                                                     {!!.04}
        { open the port }
        OpenTapiPort;                                                    {!!.04}
      end;                                                               {!!.04}
      CheckPort;

      {Start the fax}
      if FaxMode = fmReceive then begin
        fPageStatus := rpsNewDocument;
        cResponse := '';
        aFaxError := ecOK;
        aCurrPage := 1;
        aDataCount := 0;
        cInFileName := '';
        aRemoteID := '';
        aPhoneNum := '';
        aFaxFileName := '';
        if SendATAToModem then begin
          fFirstState := rfAnswer;
          afStartFax(Fax, fPrepareFaxReceive, fFaxReceive);
        end else begin
          afStartFax(Fax, nil, fFaxReceive);

          if Fax^.aPData^.aClassInUse <> ctClass1 then
            fFirstState := rf2ValidConnect;
          fState := fFirstState;

          {let a timer trigger force us into the state machine}
          aPort.SetTimerTrigger(aTimeoutTrigger, 1, True);
        end;
      end;
    end;
  end;

{TApdSendFax}

  constructor TApdCustomSendFax.Create(AOwner : TComponent);
    {-Create a TApdSendFax component}
  begin
    inherited Create(AOwner);

    {Create the message handler window instance}
    if not (csDesigning in ComponentState) then begin
      RegisterFaxMessageHandlerClass;
      CreateFaxMessageHandler;
    end;

    {Create the fax file list}
    FFaxFileList := TStringList.Create;

    {Create the SendFax data structure}
    CheckException(Self,
      fInitC12SendFax(Fax, '',  nil, MsgHandler));

    {Inits}
    FaxMode := fmSend;
    PrepProc := fPrepareFaxTransmit;
    FaxFunc := fFaxTransmit;
    WasSent := False;
    FCoverFile := '';
    FPhoneNumber := '';

    {Property inits}
    AbortNoConnect := adfDefAbortNoConnect;
    ExitOnError := adfDefExitOnError;
    SoftwareFlow := adfDefSoftwareFlow;
    BlindDial := adfDefBlindDial;
    DetectBusy := adfDefDetectBusy;
    ToneDial := adfDefToneDial;
    DialWait := adfDefDialWait;
    DialAttempts := adfDefDialAttempts;
    DialRetryWait := adfDefDialRetryWait;
    MaxSendCount := adfDefMaxSendCount;
    BufferMinimum := adfDefBufferMinimum;
    SafeMode := adfDefSafeMode;
  end;

  destructor TApdCustomSendFax.Destroy;
    {-Destroy a TApdSendFax component}
  begin
    FFaxFileList.Free;
    fDoneC12SendFax(Fax);
    inherited Destroy;
  end;

  function TApdCustomSendFax.GetFastPage : Boolean;
  begin
    Result := PC12SendFax(Fax)^.fFastPage;
  end;

  procedure TApdCustomSendFax.SetFastPage(const NewVal : Boolean);
  begin
    PC12SendFax(Fax)^.fFastPage := NewVal;
  end;

  function TApdCustomSendFax.GetEnhTextEnabled : Boolean;
  begin
    Result := PC12FaxData(Fax)^.fcData^.cEnhTextEnabled;
  end;

  procedure TApdCustomSendFax.SetEnhTextEnabled(const NewVal : Boolean);
  begin
    fSetEnhTextEnabled(Fax, NewVal);
  end;

  function TApdCustomSendFax.GetEnhHeaderFont : TFont;
  begin
    Result := PC12FaxData(Fax)^.fcData^.cEnhSmallFont;
  end;

  procedure TApdCustomSendFax.SetEnhHeaderFont(const NewVal : TFont);
  begin
    fSetEnhSmallFont(Fax, NewVal);
  end;

  function TApdCustomSendFax.GetEnhFont : TFont;
  begin
    Result := PC12FaxData(Fax)^.fcData^.cEnhStandardFont;
  end;

  procedure TApdCustomSendFax.SetEnhFont(const NewVal : TFont);
  begin
    fSetEnhStandardFont(Fax, NewVal);
  end;

  procedure TApdCustomSendFax.SetFaxFileList(const NewVal : TStringList);
  begin
    FFaxFileList.Assign(NewVal);
  end;

  function TApdCustomSendFax.GetFaxFile : TPassString;
  begin
    if FFaxFileList.Count > 0 then
      Result := TPassString(FFaxFileList[0])
    else
      Result := '';
  end;

  procedure TApdCustomSendFax.SetFaxFile(const NewFile : TPassString);
  begin
    FFaxFileList.Clear;
    FFaxFileList.Add(string(NewFile));
  end;

  function TApdCustomSendFax.GetBlindDial : Boolean;
    {-Return setting for "blind dialing"}
  begin
    Result := PC12FaxData(Fax)^.fcData^.cBlindDial;
  end;

  procedure TApdCustomSendFax.SetBlindDial(const NewVal : Boolean);
    {-Enable or disable "blind dialing"}
  begin
    fSetBlindDial(Fax, NewVal);
  end;

  function TApdCustomSendFax.GetDetectBusy : Boolean;
    {-Return setting for busy signal detection}
  begin
    Result := PC12FaxData(Fax)^.fcData^.cDetectBusy;
  end;

  procedure TApdCustomSendFax.SetDetectBusy(const NewVal : Boolean);
    {-Enable or disable busy signal detection}
  begin
    fSetDetectBusy(Fax, NewVal);
  end;

  function TApdCustomSendFax.GetToneDial : Boolean;
    {-Return the current dial type}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cToneDial;
  end;

  procedure TApdCustomSendFax.SetToneDial(const NewVal : Boolean);
    {-Set the dial type}
  begin
    PC12FaxData(Fax)^.fCdata^.cToneDial := NewVal;
  end;

  function TApdCustomSendFax.GetDialPrefix : TModemString;
    {-Return the dial prefix string}
  begin
    Result := PC12FaxData(Fax)^.fCData^.cDialPrefix;
  end;

  procedure TApdCustomSendFax.SetDialPrefix(const NewPrefix : TModemString);
    {-Set a new dial prefix}
  begin
    PC12FaxData(Fax)^.fCData^.cDialPrefix := NewPrefix;
  end;

  function TApdCustomSendFax.GetDialWait : Word;
    {-Return the dial wait time, in seconds}
  begin
    Result := Ticks2Secs(PC12FaxData(Fax)^.fCData^.cDialWait)
  end;

  procedure TApdCustomSendFax.SetDialWait(const NewWait : Word);
    {-Set new dial wait time, in seconds}
  begin
    PC12FaxData(Fax)^.fCData^.cDialWait := Secs2Ticks(NewWait);
  end;

  function TApdCustomSendFax.GetDialAttempts : Word;
    {-Return the number of times a dial should be attempted}
  begin
    Result := Fax^.aPData^.aMaxConnect
  end;

  function TApdCustomSendFax.GetSafeMode : Boolean;
    {-Return the SafeMode setting}
  begin
    Result := PC12SendFax(Fax)^.fSafeMode
  end;

  procedure TApdCustomSendFax.SetSafeMode(NewMode : Boolean);
    {-Set SafeMode}
  begin
    PC12SendFax(Fax)^.fSafeMode := NewMode;
  end;

  function TApdCustomSendFax.GetHeaderSender : TPassString;
    {-Return the header sender string}
  begin
    Result := Fax^.aPData^.aSender
  end;

  procedure TApdCustomSendFax.SetHeaderSender(const NewSender : TPassString);
    {-Set a new header sender string}
  begin
    Fax^.aPData^.aSender := NewSender;
  end;

  function TApdCustomSendFax.GetHeaderRecipient : TPassString;
    {-Return the header recipient string}
  begin
    Result := Fax^.aPData^.aRecipient
  end;

  procedure TApdCustomSendFax.SetHeaderRecipient(
                              const NewRecipient : TPassString);
    {-Set a new header recipient string}
  begin
    Fax^.aPData^.aRecipient := NewRecipient;
  end;

  function TApdCustomSendFax.GetHeaderTitle : TPassString;
    {-Return the header title string}
  begin
    Result := Fax^.aPData^.aTitle
  end;

  procedure TApdCustomSendFax.SetHeaderTitle(const NewTitle : TPassString);
    {-Set a new header title string}
  begin
    Fax^.aPData^.aTitle := NewTitle;
  end;

  procedure TApdCustomSendFax.SetDialAttempts(const NewAttempts : Word);
    {-Set the number of dial attempts}
  begin
    Fax^.aPData^.aMaxConnect := NewAttempts;
  end;

  function TApdCustomSendFax.GetDialRetryWait : Word;
    {-Return the number of seconds to wait between redial attempts}
  begin
    Result := Ticks2Secs(Fax^.aPData^.aRetryWait)
  end;

  procedure TApdCustomSendFax.SetDialRetryWait(const NewWait : Word);
    {-Set the number of seconds to wait between redial attempts}
  begin
    Fax^.aPData^.aRetryWait := Secs2Ticks(NewWait);
  end;

  function TApdCustomSendFax.GetMaxSendCount : Word;
    {-Return the max send count before yielding}
  begin
    Result := PC12SendFax(Fax)^.fMaxSendCount
  end;

  procedure TApdCustomSendFax.SetMaxSendCount(const NewCount : Word);
    {-Set the max send count}
  begin
    PC12SendFax(Fax)^.fMaxSendCount := NewCount;
  end;

  function TApdCustomSendFax.GetBufferMinimum : Word;
    {-Return the minimum buffer level before yielding}
  begin
    Result := PC12SendFax(Fax)^.fBufferMinimum
  end;

  procedure TApdCustomSendFax.SetBufferMinimum(const NewMin : Word);
    {-Set the buffer minimum buffer level before yielding}
  begin
    PC12SendFax(Fax)^.fBufferMinimum := NewMin;
  end;

  function TApdCustomSendFax.GetHeaderLine : TPassString;
    {-Return the current header line}
  begin
    Result := PC12SendFax(Fax)^.fHeaderLine
  end;

  procedure TApdCustomSendFax.SetHeaderLine(const S : TPassString);
    {-Set a new header line}
  begin
    PC12SendFax(Fax)^.fHeaderLine := S;
  end;

  function TApdCustomSendFax.GetDialAttempt : Word;
    {-Return the current dial attempt number}
  begin
    Result := Fax^.aPData^.aConnectCnt + 1
  end;

  procedure TApdCustomSendFax.ConcatFaxes(FileName : TPassString);
    {-Return the file name of the concatenated APFs from the FaxFileList}
  var
    I : Integer;
    DestFile, SourceFile : TFileStream;
    DestHeader, SourceHeader : TFaxHeaderRec;
  begin
    { make sure all files are available }                                {!!.01}
    I := 0;                                                              {!!.01}
    while (I < FFaxFileList.Count)and FileExists(FFaxFileList[I])  do    {!!.02}
      inc(I);                                                            {!!.01}
    if I < FFaxFileList.Count then begin                                 {!!.01}
      FTempFile := TPassString(FFaxFileList[I]);                         {!!.01}
      Exit;                                                              {!!.01}
    end;                                                                 {!!.01}

    { Create temp file }
    DestFile := TFileStream.Create(string(FileName), fmCreate or fmShareExclusive);
    try
      { Open first source file }
      SourceFile := TFileStream.Create(FFaxFileList[0], fmOpenRead or fmShareDenyWrite);
      try
        { Read header of the first APF }
        SourceFile.ReadBuffer(DestHeader, SizeOf(DestHeader));
        if (DestHeader.Signature <> DefAPFSig) then
          raise EFaxBadFormat.Create(ecFaxBadFormat, False);
        { Copy first source file to dest }
        DestFile.CopyFrom(SourceFile, 0);
        SourceFile.Free;
        SourceFile := nil;
        { Append remaining files in the list }
        for I := 1 to Pred(FFaxFileList.Count) do begin
          SourceFile := TFileStream.Create(FFaxFileList[I], fmOpenRead or fmShareDenyWrite);
          SourceFile.ReadBuffer(SourceHeader, SizeOf(SourceHeader));
          if (SourceHeader.Signature <> DefAPFSig) then
            raise EFaxBadFormat.Create(ecFaxBadFormat, False);
          DestFile.CopyFrom(SourceFile, SourceFile.Size - SizeOf(SourceHeader));
          DestHeader.PageCount := DestHeader.PageCount + SourceHeader.PageCount;
          SourceFile.Free;
          SourceFile := nil;
        end;
        DestFile.Position := 0;
        DestFile.WriteBuffer(DestHeader, SizeOf(DestHeader));
      finally
        SourceFile.Free;
      end;
    finally
      DestFile.Free;
    end;
  end;

  procedure TApdCustomSendFax.apwFaxNext(CP : TObject;
                                         var APhoneNumber : TPassString;
                                         var AFaxFile : TPassString;
                                         var ACoverFile : TPassString);
    {-Return the next fax to send (phonenumber, filename and cover file)}
  begin
    if Assigned(FOnFaxNext) then begin
      {Let the user fill in the info...}
      APhoneNumber := '';
      AFaxFile := '';
      ACoverFile := '';
      FOnFaxNext(CP, APhoneNumber, AFaxFile, ACoverFile);

      {...and note the info in these properties for status reporting}
      PhoneNumber := APhoneNumber;
      FaxFile := AFaxFile;
      CoverFile := ACoverFile;
    end else begin
      {No OnFaxNext hook specified, use the properties}
      if WasSent then begin
        {FaxFile was already sent, return null number}
        APhoneNumber := '';
        AFaxFile:= '';
        ACoverFile := '';
      end else begin
        {Return the current values of the properties}
        WasSent := True;
        APhoneNumber := PhoneNumber;
        if Fax^.aPData^.aConcatFax then
          AFaxFile := FTempFile
        else
          AFaxFile := FaxFile;
        ACoverFile := CoverFile;
      end;
    end;
  end;

  procedure TApdCustomSendFax.StartTransmit;
    {-Start a background fax send session}

    function CreateTempFileName : string;
    {-create a temporary file name}
    var
      TempPath : PChar;
    begin
      TempPath := StrAlloc(256);
      try
        GetTempPath(255, TempPath);
        {$IFOPT H+}
        SetLength(Result, 255);
        GetTempFileName(TempPath, '~AP', 0, PChar(Result));
        SetLength(Result, StrLen(PChar(Result)));
        {$ELSE}
        GetTempFileName(TempPath, '~AP', 0, @Result[1]);
        Result[0] := Chr(StrLen(@Result[1]));
        {$ENDIF}
      finally
        StrDispose(TempPath);
      end;
      Result := ExpandFileName(Result);
    end;

  begin
    with Fax^ do begin
      { integrate with TAPI }
      if Assigned(FTapiDevice) then begin
        PrepareTapi;
        OpenTapiPort;
        {translate the phone number using TAPI }
        FPhoneNumber := FTapiDevice.TranslateAddress(FPhoneNumber);
        { force the low level fax code to use a modified init and skip dial modifiers }
        PC12FaxData(Fax)^.fcData^.cForcedInit := TPassString(DefTapiInit);
        PC12FaxData(Fax)^.fcData^.cDialPrefix := '';
        PC12FaxData(Fax)^.fcData^.cDialTonePulse := ' ';
      end;
      {Make sure comport is open, pass handle to fax}
      CheckPort;

      if (FFaxFileList.Count > 1) and not Assigned(FOnFaxNext) then begin
        FTempFile := TPassString(CreateTempFileName());
        ConcatFaxes(FTempFile);
        aPData^.aConcatFax := True;
      end else begin
        aPData^.aConcatFax := False;
      end;

      {Inits}
      WasSent := False;

      {Start the fax}
      if FaxMode = fmSend then
        afStartFax(Fax, fPrepareFaxTransmit, fFaxTransmit);
    end;
  end;

  procedure TApdCustomSendFax.StartManualTransmit;
    {-Start a background fax send session, already in progress}
  begin
    with PC12SendFax(Fax)^, fpData^ do
      aSendManual := True;
    if FPhoneNumber = '' then
      FPhoneNumber := 'Manual';
    StartTransmit;
  end;

{TApdAbstractStatus}

  procedure TApdAbstractFaxStatus.Notification(AComponent : TComponent;
                                               Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      if AComponent = FFax then
        FFax := nil;
    end;
  end;

  procedure TApdAbstractFaxStatus.SetPosition(const NewPosition : TPosition);
    {-Set the position property of the status window}
  begin
    if NewPosition <> FPosition then begin
      FPosition := NewPosition;
      if Assigned(FDisplay) then
        FDisplay.Position := NewPosition;
    end;
  end;

  procedure TApdAbstractFaxStatus.SetCtl3D(const NewCtl3D : Boolean);
    {-Set the 3D property of the status window}
  begin
    if NewCtl3D <> FCtl3D then begin
      FCtl3D := NewCtl3D;
      if Assigned(FDisplay) then
        FDisplay.Ctl3D := NewCtl3D;
    end;
  end;

  procedure TApdAbstractFaxStatus.SetVisible(const NewVisible : Boolean);
    {-Set the visible property of the status window}
  begin
    if NewVisible <> FVisible then begin
      FVisible := NewVisible;
      if Assigned(FDisplay) then
        FDisplay.Visible := NewVisible;
    end;
  end;

  procedure TApdAbstractFaxStatus.SetCaption(const NewCaption : TCaption);
    {-Set the caption property of the status window}
  begin
    if NewCaption <> FCaption then begin
      FCaption := NewCaption;
      if Assigned(FDisplay) then
        FDisplay.Caption := NewCaption;
    end;
  end;

  procedure TApdAbstractFaxStatus.GetProperties;
    {-Get the properties we care about from the status window}
  begin
    if Assigned(FDisplay) then begin
      Position := FDisplay.Position;
      Ctl3D    := FDisplay.Ctl3D;
      Visible  := FDisplay.Visible;
      Caption  := FDisplay.Caption;
    end;
  end;

  constructor TApdAbstractFaxStatus.Create(AOwner : TComponent);
    {-Create the underlying status window}
  begin
    inherited Create(AOwner);
    CreateDisplay;
    GetProperties;
    Caption := 'Fax Status';
  end;

  destructor TApdAbstractFaxStatus.Destroy;
    {-Get rid of the status window}
  begin
    DestroyDisplay;
    inherited Destroy;
  end;

  procedure TApdAbstractFaxStatus.Show;
    {-Show the status window}
  begin
    if Assigned(FDisplay) then
      FDisplay.Show;
  end;

{TApdFaxLog}

  procedure TApdFaxLog.Notification(AComponent : TComponent;
                                    Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);

    if Operation = opRemove then begin
      {Owned components going away}
      if AComponent = FFax then
        FFax := nil;
    end;
  end;

  constructor TApdFaxLog.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);

    {Inits}
    FaxHistoryName := adfDefFaxHistoryName;
  end;

  function TApdFaxLog.GetLogString(const Log: TFaxLogCode;               {!!.04}
    aFax : TApdCustomAbstractFax): string;
    {-returns the string to add to the log, passing in the fax device so }
    { we can use this with the fax server components }
  var
    I : Integer;
    DTStr : string;
  begin
    { Format of entries
        Transmit <filename> to <phonenumber> started at <date/time>
        Transmit to <remoteid> finished at <date/time>
        Transmit failed at <date/time>

        Receive <filename> from <remoteid> started at <date/time>
        Receive finished at <date/time>
        Receive failed at <date/time>
        Receive skipped at <date/time>
    }
    Result := '';
    DTStr := DateTimeToStr(Now);
    {Write the transmit log entry}
    if aFax is TApdSendFax then begin
      with TApdSendFax(aFax) do begin
        case Log of
          lfaxTransmitStart :
            begin
              for I := 0 to Pred(FFaxFileList.Count) do
                Result := Result + Format('Transmit %s to %s started at %s'#13#10, // KGM
                  [FFaxFileList[I], PhoneNumber, DTStr]);
                { remove the last CR/LF }
                Delete(Result, Length(Result)-1, 2);                               // KGM
             end;
          lfaxTransmitOK :
            Result := Format('Transmit to %s finished OK at %s (%d)'#13#10,
              [RemoteID, DTStr, HangupCode]);
          lfaxTransmitFail :
            if FaxClass in [fcClass2, fcClass2_0] then
              Result := Format('Transmit failed at %s'#13#10'  (%s) (%d)'#13#10,
                [DTStr, ErrorMsg(FaxError), HangupCode])
            else
              Result := Format('Transmit failed at %s'#13#10'  (%s)'#13#10,
                [DTStr, ErrorMsg(FaxError)])
        end;
      end;
    end;

    {Write the receive log entry}
    if aFax is TApdReceiveFax then begin
      with TApdReceiveFax(aFax) do begin
        case Log of
          lfaxReceiveStart :
            Result := Format('Receive %s from %s started at %s',
              [FaxFile, RemoteID, DTStr]);
          lfaxReceiveOK :
            Result := Format('Receive finished OK at %s'#13#10, [DTStr]);
          lfaxReceiveSkip :
            Result := Format('Receive skipped at %s'#13#10, [DTStr]);
          lfaxReceiveFail :
            if FaxClass in [fcClass2, fcClass2_0] then
              Result := Format('Receieve failed at %s'#13#10'  (%s) (%d)'#13#10,
              [DTStr, ErrorMsg(FaxError), HangupCode])
            else
              Result := Format('Receive failed at %s'#13#10'  (%s)'#13#10,
                [DTStr, ErrorMsg(FaxError)]);
        end;
      end;
    end;
  end;


 { many changes made to use new GetLogString method }
  procedure TApdFaxLog.UpdateLog(const Log : TFaxLogCode);               {!!.04}
    {-Update the standard log}
  var
    HisFile : TextFile;
  begin
    {Exit if no name specified}
    if FFaxHistoryName = '' then
      Exit;

    {Create or open the history file}
    { modified for .02 to check for existence of the file first }
    try
      AssignFile(HisFile, string(FFaxHistoryName));
      if FileExists(string(FFaxHistoryName)) then                                {!!.02}
        Append(HisFile)
      else                                                               {!!.02}
        Rewrite(HisFile);                                                {!!.02}
    except
      {on E : EInOutError do}                                            {!!.02}
        {if E.ErrorCode = 2 then}                                        {!!.02}
          {File not found, open as new}
          {Rewrite(HisFile)}                                             {!!.02}
        {else}                                                           {!!.02}
          {Unexpected error, forward the exception}
          raise;
    end;
    WriteLn(HisFile, GetLogString(Log, Fax));
    Close(HisFile);
    if IOResult <> 0 then ;
  end;

function TApdCustomAbstractFax.GetElapsedTime: DWORD;
  { returns elapsed time in ms since fpGotRemoteID, from FaxProgress = }
  { fpGotRemoteID to the OnFaxFinish event }
begin
  Result := AdTimeGetTime - FStartTime;
end;

function TApdCustomAbstractFax.GetInProgress: Boolean;
  { returns True if we are faxing, false if we are not }
begin
  Result := Fax^.aPData^.aInProgress;
end;

procedure TApdCustomSendFax.ConvertCover(const InCover, OutCover: string);
  { convert a text cover page with replaceable tags into a text file with }
  { the tags replaced }
var
  InFile, OutFile : TextFile;
  S : string;
begin
  try
    AssignFile(InFile, InCover);
    Reset(InFile);
    AssignFile(OutFile, OutCover);
    Rewrite(OutFile);
    while not EOF(InFile) do begin
      ReadLn(InFile, S);
      WriteLn(OutFile, afConvertHeaderString(Fax, ShortString(S)));
    end;
  finally
    CloseFile(InFile);
    CloseFile(OutFile);
  end;
end;

procedure TApdCustomAbstractFax.WaitForTapi;                             {!!.04}
var
  ET : EventTimer;
begin
  { create a 5-second limit to wait for TAPI to respond }
  NewTimer(ET, 91);
  while FWaitForTapi and (not TimerExpired(ET)) and
    (SafeYield <> WM_QUIT) do;
end;

initialization
  FaxList := TList.Create;

finalization
begin                                                                       // SWB
  FaxList.Free;
  FaxList := nil;                                                           // SWB
end;                                                                        // SWB

end.
