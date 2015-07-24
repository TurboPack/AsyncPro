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
{*                   ADFAXSRV.PAS 4.06                   *}
{*********************************************************}

{
Description:
  Implements the fax server components. The idea of the
  fax server components is to create fax job files (APJ)
  which consist of a job header (TApdFaxJobHeader),
  1 or more recipient headers (TApdFaxRecipientHeader),
  a text cover page, and a fax file (APF). The APJ is
  manipulated with the TApdFaxJobHandler class.
  -The TApdFaxClient component wraps the handler class.
  -The TApdFaxServerManager component monitors a dir
   when a server asks for a job to send. The manager
   does this by opening each APJ and checking the job
   header & finds the job with the earliest scheduled
   date.
  -The TApdFaxServer wraps a TApdSendFax, TApdReceiveFax
   and a few supporting components. The Server is the
   only part that talks to the modem. The server
   requests jobs based on the SendQueryInterval
   property. The server can also receive faxes.

Known problems:
  These components were designed to be compatible with D1 Standard/Win16,
  so we couldn't use any built-in DB support or other cool features.

Expansion points:
  -Convert over to require TAPI, and the TAPI passive
   answering with the internal TApdReceiveFax. A lot
   of code is now dedicated to switching back and
   forth between send/recv.
  -Change the manager so it is data-aware (looks in
   a DB instead of a dir)
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F-,V-,P-,T-,B-}

unit AdFaxSrv;
  { -Integrated Fax Server }

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  OoMisc,
  AdFax,
  AdPort,
  AdTapi,
  AdFaxPrn,
  AdExcept,
  AdFStat,
  AdFIDlg {used for TShowJobInfoDialog};

const
  adfDefDelayBetweenSends = 18;                  {in ticks}
  adfDefSendQueryInterval = 30;                  {in miliseconds (30 seconds) }
  adfDefJobFileExt = 'APJ';
  apfDefJobHeaderID = 810176577;                 {'APJ0' in hex editor}
  adfDefFaxServerManagerPaused = False;
  ServerManagerLockFileName = 'SRVMGR.LCK';

  { Status byte  for   Job Header            /   Recipient Info }
  stNone     = 0;    { no faxes sent         /   fax job not sent }
  stPartial  = 1;    { some faxes sent       /   fax job being sent }
  stComplete = 2;    { no more faxes to send /   fax job sent }
  stPaused   = 3;    { entire file paused    /   this job is paused }

type
  TFaxServerMode = (fsmIdle, fsmSend, fsmReceive);

  { predefine the classes }
  TApdFaxServerManager = class;
  TApdCustomFaxServer = class;

  { event types }
  TFaxServerStatusEvent = procedure(CP : TObject; FaxMode: TFaxServerMode;
    First, Last : Boolean; Status: Word) of object;
  TFaxServerFatalErrorEvent = procedure(CP: TObject; FaxMode: TFaxServerMode;
    ErrorCode, HangupCode: Integer) of object;
  TFaxServerFinishEvent = procedure(CP: TObject; FaxMode: TFaxServerMode;
    ErrorCode: Integer) of object;
  TFaxServerPortOpenCloseEvent = procedure(CP: TObject; Opening: Boolean) of object;
  TFaxServerAcceptEvent = procedure(CP : TObject; var Accept : Boolean) of object;
  TFaxServerNameEvent   = procedure(CP : TObject; var Name : TPassString) of object;
  TFaxServerLogEvent = procedure(CP : TObject; LogCode : TFaxLogCode;
    ServerCode : TFaxServerLogCode) of object;

  { TApdFaxServerManager events }
  TFaxServerManagerQueriedEvent = procedure(Mgr : TApdFaxServerManager;
    QueryFrom : TApdCustomFaxServer; const JobToSend : string) of object;
  TManagerUpdateRecipientEvent = procedure (Mgr : TApdFaxServerManager;
    JobFile : string; JobHeader : TFaxJobHeaderRec;
    var RecipHeader : TFaxRecipientRec) of object;

  TManagerUserGetJobEvent = procedure(Mgr : TApdFaxServerManager;
    QueryFrom : TApdCustomFaxServer; var JobFile, FaxFile,
    CoverFile : string; var RecipientNum : Integer) of object;

  { Object used for ApdFaxServerManager.FFaxList to keep track of job files
    only used in ApdFaxServerManager's GetNextFax and UpdateStatus methods}
  TFaxListObj = class(TObject)
    FileTime: Integer;
    JobHeader: TFaxJobHeaderRec;
  end;

  { - The TApdFaxJobHandler class contains methods to manipulate APJ files, }
  {   the TApdFaxServerManager, and TApdFaxClient components are derived    }
  {   from this class to provide uniform APJ handling }
  TApdFaxJobHandler = class(TApdBaseComponent)
  public
    { - Adds a TFaxRecipientRec for a new recipient }
    procedure AddRecipient(JobFileName: TPassString;
      RecipientInfo: TFaxRecipientRec);
    { - Makes an APJ file from an APF, requires a recipient }
    procedure MakeJob(FaxName, CoverName, JobName, Sender, DestName: TPassString;
      Recipient: TFaxRecipientRec);
    { show dialog displaying information about the APJ }
    function ShowFaxJobInfoDialog(JobFileName, DlgCaption: TPassString): TModalResult;
    { - Extracts APF file from APJ, and saves to FaxName }
    procedure ExtractAPF(JobFileName, FaxName: TPassString);
    { - Extracts CoverPage text from APJ, and saves to CoverName, returns }
    {   true if a cover file is available, false otherwise }
    function ExtractCoverFile(JobFileName, CoverName: TPassString): Boolean;
    { - returns the FaxJobInfoRec for the Count recipient in the Job file }
    function GetRecipient(JobFileName: TPassString; Index: Integer;
      var Recipient: TFaxRecipientRec): Integer;
    { - returns the FaxJobHeaderRec for the specified JobFile }
    procedure GetJobHeader(JobFileName: TPassString;
      var JobHeader: TFaxJobHeaderRec);
    {- returns the status byte for the specified recipient }
    function GetRecipientStatus(JobFileName: TPassString;
      JobNum : Integer) : Integer;
    { - cancels an individual recipient }
    procedure CancelRecipient(JobFileName: TPassString; JobNum : Byte);
    { - Concatenates 2 APF files into 1 }
    procedure ConcatFaxes(DestFaxFile: TPassString; FaxFiles: array of TPassString);
    {- Resets all stPartial status flags to stNone, can set AttemptNum to 0 }
    procedure ResetAPJPartials(JobFileName: TPassString;                 {!!.03}
      ResetAttemptNum : Boolean);                                        {!!.03}
    {- Resets all status flags in an APJ to stNone}
    procedure ResetAPJStatus(JobFileName: TPassString);
    {- Resets individual recipient with new status, updates job header }
    procedure ResetRecipientStatus(JobFileName: TPassString;
      JobNum, NewStatus: Byte);
    {- Reschedules a recipient, updates job header }
    procedure RescheduleJob(JobFileName : TPassString;
      JobNum : Integer; NewSchedDT : TDateTime; ResetStatus: Boolean);
  end;

  { - the ApdFaxServerManager controls the flow of fax jobs to the ApdFaxServer.
      An ApdFaxClient will deposit pre-composed fax job files (APJ) into the
      MonitorDir folder, and an ApdFaxServer will call the GetNextFax method to
      get the next fax to be sent }

  TApdFaxServerManager = class(TApdFaxJobHandler)
  private
    FMonitorDir: TPassString;
    FFaxList: TStringList;
    FJobFileExt: TPassString;
    FPaused: Boolean;
    FLockFile: TFileStream;
    FDeleteOnComplete: Boolean;
    FFirstGetJob : Boolean;
    FInGetJob : Boolean;
    FFaxServerManagerQueriedEvent: TFaxServerManagerQueriedEvent;
    FManagerUpdateRecipientEvent: TManagerUpdateRecipientEvent;
    FManagerUserGetJobEvent: TManagerUserGetJobEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { - returns the file name of the next fax job to send }
    function GetNextFax: TPassString;
    { - returns the scheduled send time of the specified fax job }
    function GetSchedTime(JobFileName: TPassString): TDateTime;
    { - Returns the fax job in Recipient, True if ready, False otherwise }
    function GetJob(var Recipient: TFaxRecipientRec;
      QueryFrom: TApdCustomFaxServer; var JobFileName, FaxFile,
      CoverFile: TPassString): Boolean;
    { - updates status of individual fax jobs }
    procedure UpdateStatus(JobFileName: TPassString; JobNumber, Result: Word;
      Failed: Boolean);
    { - Resets internal fax list and properties }
    procedure Reset;
    procedure SetMonitorDir(const Value: TPassString);
    property FaxList : TStringList
      read FFaxList;
  published
    {-  Delete the APJ after all jobs are complete }
    property DeleteOnComplete: Boolean
      read FDeleteOnComplete write FDeleteOnComplete;
    { - The directory where we will look for APJ files }
    property MonitorDir: TPassString
      read FMonitorDir write SetMonitorDir;
    { - The default extension for APJ Files }
    property JobFileExt: TPassString
      read FJobFileExt write FJobFileExt;
    { - Pauses all fax jobs }
    property Paused: Boolean
      read FPaused write FPaused default adfDefFaxServerManagerPaused;
    { - Event generated when GetJob is called }
    property OnQueried : TFaxServerManagerQueriedEvent
      read FFaxServerManagerQueriedEvent
      write FFaxServerManagerQueriedEvent;
    { - Event generated when a recipient is complete (ecOK or failed ) }
    property OnRecipientComplete : TManagerUpdateRecipientEvent
      read FManagerUpdateRecipientEvent
      write FManagerUpdateRecipientEvent;
    { - Event generated to provide custom scheduling from app }
    { If this event is defined, this event will be responsible for }
    { feeding the fax jobs, the scheduling and queuing built into }
    { the ApdFaxServerManager will not be used }
    property OnCustomGetJob : TManagerUserGetJobEvent
      read FManagerUserGetJobEvent
      write FManagerUserGetJobEvent;
  end;


  { - The ApdFaxClient composes APJ files for use by the ApdFaxServerManager. }
  TApdFaxClient = class(TApdFaxJobHandler)
  private
    FJobName: TPassString;
    FSender: TPassString;
    FCoverFileName: TPassString;
    FJobFileName: TPassString;
    FFaxFileName: TPassString;
    function GetScheduleDateTime: TDateTime;
    procedure SetHeaderLine(const Value: TPassString);
    procedure SetHeaderRecipient(const Value: TPassString);
    procedure SetHeaderTitle(const Value: TPassString);
    procedure SetPhoneNumber(const Value: TPassString);
    procedure SetScheduleDateTime(const Value: TDateTime);
    function GetHeaderLine: TPassString;
    function GetHeaderRecipient: TPassString;
    function GetHeaderTitle: TPassString;
    function GetPhoneNumber: TPassString;
  public
    { - contains info about this job}
    Recipient: TFaxRecipientRec;
    constructor Create(AOwner: TComponent); override;
    { - Generic copying method }
    function CopyJobToServer(SourceJob, DestJob: TPassString;
      OverWrite: Boolean): Integer;
    { - Calls MakeJob with our property values }
    procedure MakeFaxJob;
    { - accepts TDateTime input to schedule job }
    property ScheduleDateTime: TDateTime
      read GetScheduleDateTime write SetScheduleDateTime;
  published
    { properties related to job header }
    property CoverFileName: TPassString
      read FCoverFileName write FCoverFileName;
    property FaxFileName: TPassString
      read FFaxFileName write FFaxFileName;
    property JobFileName: TPassString
      read FJobFileName write FJobFileName;
    property JobName: TPassString
      read FJobName write FJobName;
    property Sender: TPassString
      read FSender write FSender;
    { properties related to recipient, access methods refer to Recipient fields }
    property PhoneNumber: TPassString
      read GetPhoneNumber write SetPhoneNumber;
    property HeaderLine: TPassString
      read GetHeaderLine write SetHeaderLine;
    property HeaderRecipient: TPassString
      read GetHeaderRecipient write SetHeaderRecipient;
    property HeaderTitle: TPassString
      read GetHeaderTitle write SetHeaderTitle;
  end;

  TApdCustomFaxServer = class(TApdCustomAbstractFax)
  private
    { points to other components on the form }
    FComPort: TApdCustomComPort;
    FTapiDevice: TApdCustomTapiDevice;
    FStatusDisplay: TApdAbstractFaxStatus;
    FFaxLog: TApdFaxLog;
    { internal components }
    FSendFax: TApdSendFax;
    FRecvFax: TApdReceiveFax;
    FSendQueryTimer: TTimer;

    FSoftwareFlow: Boolean;
    FSafeMode: Boolean;
    FExitOnError: Boolean;
    FBlindDial: Boolean;
    FToneDial: Boolean;
    FConstantStatus: Boolean;
    FInitBaud: Integer;
    FNormalBaud: Integer;
    FCoverFile: TPassString;
    FHeaderTitle: TPassString;
    FPhoneNumber: TPassString;
    FHeaderLine: TPassString;
    FHeaderRecipient: TPassString;
    FDestinationDir: TPassString;
    FFaxFile: TPassString;
    FFaxFileExt: TPassString;
    FHeaderSender: TPassString;
    FFaxClass: TFaxClass;
    FFaxNameMode: TFaxNameMode;
    FModemInit: TModemString;
    FStationID: TStationID;
    FAnswerOnRing: Word;
    FBufferMinimum: Word;
    FStatusInterval: Word;
    FMaxSendCount: Word;
    FMonitoring: Boolean;
    FOldMonitoring: Boolean;
    FFaxPrinter: TApdCustomFaxPrinter;
    FPrintOnReceive: Boolean;

    FFaxServerMode: TFaxServerMode;
    FFaxInProgress: Boolean;
    FDesiredBPS: Word;
    FDesiredECM: Boolean;
    FDetectBusy: Boolean;
    FPageLength: Integer;
    FDelayBetweenSends: Word;
    FServerManager: TApdFaxServerManager;
    FSendQueryInterval: Integer;
    FDialAttempts: Word;
    FDialWait: Word;
    FDialRetryWait: Word;
    FDialPrefix: TModemString;
    FEnhFont: TFont;
    FEnhHeaderFont: TFont;
    FEnhTextEnabled: Boolean;
    WaitingOnTapi: Boolean;
    FServerLogCode: TFaxServerLogCode;
    FFaxServerFatalErrorEvent: TFaxServerFatalErrorEvent;
    FFaxServerStatusEvent: TFaxServerStatusEvent;
    FFaxServerFinishEvent: TFaxServerFinishEvent;
    FFaxServerPortOpenCloseEvent: TFaxServerPortOpenCloseEvent;
    FFaxServerAcceptEvent: TFaxServerAcceptEvent;
    FFaxServerNameEvent: TFaxServerNameEvent;
    FFaxServerLogEvent: TFaxServerLogEvent;
    FSwitchingModes: Boolean;
    FWaitForRing: Boolean;
  protected
    { property access methods }
    procedure SetComPort(const Value: TApdCustomComPort);
    procedure SetFaxLog(const Value: TApdFaxLog);
    procedure SetStatusDisplay(const Value: TApdAbstractFaxStatus);
    procedure SetAnswerOnRing(const Value: Word);
    procedure SetBlindDial(const Value: Boolean);
    procedure SetBufferMinimum(const Value: Word);
    procedure SetConstantStatus(const Value: Boolean);
    procedure SetCoverFile(const Value: TPassString);
    procedure SetDestinationDir(const Value: TPassString);
    procedure SetExitOnError(const Value: Boolean);
    procedure SetFaxClass(const Value: TFaxClass);
    procedure SetFaxFile(const Value: TPassString); override;
    procedure SetFaxFileExt(const Value: TPassString);
    procedure SetFaxNameMode(const Value: TFaxNameMode);
    procedure SetHeaderLine(const Value: TPassString);
    procedure SetHeaderRecipient(const Value: TPassString);
    procedure SetHeaderSender(const Value: TPassString);
    procedure SetHeaderTitle(const Value: TPassString);
    procedure SetInitBaud(const Value: Integer);
    procedure SetMaxSendCount(const Value: Word);
    procedure SetModemInit(const Value: TModemString);
    procedure SetNormalBaud(const Value: Integer);
    procedure SetPhoneNumber(const Value: TPassString);
    procedure SetSafeMode(const Value: Boolean);
    procedure SetSoftwareFlow(const Value: Boolean);
    procedure SetStationID(const Value: TStationID);
    procedure SetStatusInterval(const Value: Word);
    procedure SetToneDial(const Value: Boolean);
    procedure SetMonitoring(const Value: Boolean);
    procedure SetFaxPrinter(const Value: TApdCustomFaxPrinter);
    procedure SetPrintOnReceive(const Value: Boolean);
    procedure SetDesiredBPS(const Value: Word);
    procedure SetDesiredECM(const Value: Boolean);
    procedure SetDetectBusy(const Value: Boolean);
    procedure SetDelayBetweenSends(const Value: Word);
    procedure SetServerManager(const Value: TApdFaxServerManager);
    procedure SetSendQueryInterval(const Value: Integer);
    procedure SetFaxServerMode(const Value: TFaxServerMode);
    procedure SetDialAttempts(const Value: Word);
    procedure SetDialWait(const Value: Word);
    procedure SetDialPrefix(const Value: TModemString);
    procedure SetEnhFont(const Value: TFont);
    procedure SetEnhHeaderFont(const Value: TFont);
    procedure SetEnhTextEnabled(const Value: Boolean);
    procedure SetTapiDevice(const Value: TApdCustomTapiDevice);
    function GetPageLength: Integer;
    function GetBytesTransferred: Integer;
    function GetCurrentPage: Word;
    function GetDialAttempt: Word;
    function GetDialAttempts: Word;
    function GetElapsedTime: DWORD;                                      {!!.02}
    function GetFaxProgress: Word;
    function GetHangupCode: Word;
    function GetModemBPS: Integer;
    function GetModemChip: string;
    function GetModemECM: Boolean;
    function GetModemModel: string;
    function GetModemRevision: string;
    function GetRemoteID: string;
    function GetSessionBPS: Word;
    function GetSessionECM: Boolean;
    function GetSessionResolution: Boolean;
    function GetSessionWidth: Boolean;
    function GetSupportedFaxClasses: TFaxClassSet;
    function GetTotalPages: Word;

    { internal event handlers }
    procedure FInternalFaxFinish(CP: TObject; ErrorCode: Integer);
    procedure FInternalFaxStatus(CP : TObject; First, Last : Boolean);
    procedure FInternalSendQueryTimer(Sender: TObject);
    procedure FInternalTapiPortOpenClose(Sender: TObject);
    procedure FInternalTapiFail(Sender : TObject);
    procedure FInternalPortToggle(CP: TObject; Opening : Boolean);
    procedure FInternalFaxAccept(CP : TObject; var Accept : Boolean);
    procedure FInternalFaxName(CP : TObject; var Name : TPassString);
    procedure FInternalFaxLog(CP : TObject; LogCode: TFaxLogCode);

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    { - ensures component properties are correctly assigned }
    procedure CheckPort;
  public
    { the file name of the APJ being sent }
    CurrentJobFileName: TPassString;
    { the index of the job in the APJ being sent }
    CurrentJobNumber: Integer;
    { the TFaxRecipientRec of the job being sent }
    CurrentRecipient: TFaxRecipientRec;
    { the TFaxHeaderRec of the APJ being sent }
    CurrentJobHeader: TFaxJobHeaderRec;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function StartTransmitSingle: Boolean;
    { - checks the ApdFaxServerManager for ready jobs outside of the query interval }
    procedure ForceSendQuery;

    procedure CancelFax;

    { properties }
    property ComPort: TApdCustomComPort
      read FComPort write SetComPort;
    property TapiDevice: TApdCustomTapiDevice
      read FTapiDevice write SetTapiDevice;
    property ServerManager: TApdFaxServerManager
      read FServerManager write SetServerManager;
    property StatusDisplay: TApdAbstractFaxStatus
      read FStatusDisplay write SetStatusDisplay;
    property FaxPrinter: TApdCustomFaxPrinter
      read FFaxPrinter write SetFaxPrinter;
    property FaxLog: TApdFaxLog
      read FFaxLog write SetFaxLog;
    property ExitOnError: Boolean
      read FExitOnError write SetExitOnError default adfDefExitOnError;
    property FaxClass: TFaxClass
      read FFaxClass write SetFaxClass default adfDefFaxClass;
    property FaxFile: TPassString
      read FFaxFile write SetFaxFile;
    property FaxFileExt: TPassString
      read FFaxFileExt write SetFaxFileExt;
    property InitBaud: Integer
      read FInitBaud write SetInitBaud default adfDefInitBaud;
    property ModemInit: TModemString
      read FModemInit write SetModemInit;
    property NormalBaud: Integer
      read FNormalBaud write SetNormalBaud default adfDefNormalBaud;
    property SoftwareFlow: Boolean
      read FSoftwareFlow write SetSoftwareFlow default adfDefSoftwareFlow;
    property StationID: TStationID
      read FStationID write SetStationID;
    property StatusInterval: Word
      read FStatusInterval write SetStatusInterval default adfDefFaxStatusInterval;
    property DesiredBPS: Word
      read FDesiredBPS write SetDesiredBPS default adfDefDesiredBPS;
    property DesiredECM: Boolean
      read FDesiredECM write SetDesiredECM default adfDefDesiredECM;

    property DelayBetweenSends: Word
      read FDelayBetweenSends write SetDelayBetweenSends default adfDefDelayBetweenSends;
    property SendQueryInterval: Integer
      read FSendQueryInterval write SetSendQueryInterval;

    { general read-only properties }
    property BytesTransferred: Integer
      read GetBytesTransferred;
    property CurrentPage: Word
      read GetCurrentPage;
    property ElapsedTime : DWORD                                         {!!.02}
      read GetElapsedTime;                                               {!!.02}
    property FaxProgress: Word
      read GetFaxProgress;
    property HangupCode: Word
      read GetHangupCode;
    property ModemBPS: Integer
      read GetModemBPS;
    property ModemChip: string
      read GetModemChip;
    property ModemECM: Boolean
      read GetModemECM;
    property ModemModel: string
      read GetModemModel;
    property ModemRevision: string
      read GetModemRevision;
    property PageLength: Integer
      read GetPageLength;
    property RemoteID: string
      read GetRemoteID;
    property SessionBPS: Word
      read GetSessionBPS;
    property SessionECM: Boolean
      read GetSessionECM;
    property SessionResolution: Boolean
      read GetSessionResolution;
    property SessionWidth: Boolean
      read GetSessionWidth;
    property SupportedFaxClasses: TFaxClassSet
      read GetSupportedFaxClasses;
    property TotalPages: Word
      read GetTotalPages;

    { send-specific properties }
    property BlindDial: Boolean
      read FBlindDial write SetBlindDial default adfDefBlindDial;
    property BufferMinimum: Word
      read FBufferMinimum write SetBufferMinimum default adfDefBufferMinimum;
    property CoverFile: TPassString
      read FCoverFile write SetCoverFile;
    property DetectBusy: Boolean
      read FDetectBusy write SetDetectBusy default adfDefDetectBusy;
    property DialAttempt : Word
      read GetDialAttempt;
    property DialAttempts : Word
      read GetDialAttempts write SetDialAttempts default adfDefDialAttempts;
    property DialPrefix: TModemString
      read FDialPrefix write SetDialPrefix;
    property DialWait : Word
      read FDialWait write SetDialWait default adfDefDialWait;
    property DialRetryWait : Word
      read FDialRetryWait write FDialRetryWait default adfDefDialRetryWait;

    property HeaderLine: TPassString
      read FHeaderLine write SetHeaderLine;
    property HeaderRecipient: TPassString
      read FHeaderRecipient write SetHeaderRecipient;
    property HeaderSender: TPassString
      read FHeaderSender write SetHeaderSender;
    property HeaderTitle: TPassString
      read FHeaderTitle write SetHeaderTitle;

    property MaxSendCount: Word
      read FMaxSendCount write SetMaxSendCount default adfDefMaxSendCount;
    property PhoneNumber: TPassString
      read FPhoneNumber write SetPhoneNumber;
    property SafeMode: Boolean
      read FSafeMode write SetSafeMode default adfDefSafeMode;
    property ToneDial: Boolean
      read FToneDial write SetToneDial default adfDefToneDial;
    property EnhTextEnabled : Boolean
      read FEnhTextEnabled write SetEnhTextEnabled;
    property EnhHeaderFont : TFont
      read FEnhHeaderFont write SetEnhHeaderFont;
    property EnhFont : TFont
      read FEnhFont write SetEnhFont;

    { receive-specific properties }
    property AnswerOnRing: Word
      read FAnswerOnRing write SetAnswerOnRing default adfDefAnswerOnRing;
    property ConstantStatus: Boolean
      read FConstantStatus write SetConstantStatus default adfDefConstantStatus;
    property DestinationDir: TPassString
      read FDestinationDir write SetDestinationDir;
    property FaxNameMode: TFaxNameMode
      read FFaxNameMode write SetFaxNameMode default adfDefFaxNameMode;
    property PrintOnReceive: Boolean
      read FPrintOnReceive write SetPrintOnReceive;

    { controlling read-only properties }
    property Monitoring: Boolean
      read FMonitoring write SetMonitoring;
    property FaxInProgress: Boolean
      read FFaxInProgress write FFaxInProgress default False;
    property FaxServerMode: TFaxServerMode
      read FFaxServerMode write SetFaxServerMode;

    { events }
    property OnFaxServerStatus: TFaxServerStatusEvent
      read FFaxServerStatusEvent write FFaxServerStatusEvent;
    property OnFaxServerFatalError: TFaxServerFatalErrorEvent
      read FFaxServerFatalErrorEvent write FFaxServerFatalErrorEvent;
    property OnFaxServerFinish:  TFaxServerFinishEvent
      read FFaxServerFinishEvent write FFaxServerFinishEvent;
    property OnFaxServerPortOpenClose: TFaxServerPortOpenCloseEvent
      read FFaxServerPortOpenCloseEvent write FFaxServerPortOpenCloseEvent;
    property OnFaxServerAccept: TFaxServerAcceptEvent
      read FFaxServerAcceptEvent write FFaxServerAcceptEvent;
    property OnFaxServerName: TFaxServerNameEvent
      read FFaxServerNameEvent write FFaxServerNameEvent;
    property OnFaxServerLog: TFaxServerLogEvent
      read FFaxServerLogEvent write FFaxServerLogEvent;
  end;

  TApdFaxServer = class(TApdCustomFaxServer)
  published
    property ComPort;
    property TapiDevice;
    property ServerManager;
    property StatusDisplay;
    property FaxLog;
    property ExitOnError;
    property FaxClass;
    property InitBaud;
    property ModemInit;
    property NormalBaud;
    property SoftwareFlow;
    property StationID;
    property StatusInterval;
    property DelayBetweenSends;
    property SendQueryInterval;

    { general properties that apply to sending and receiving }
    property DesiredBPS;
    property DesiredECM;
    property FaxFileExt;

    { send-specific properties }
    property BlindDial;
    property BufferMinimum;
    property DetectBusy;
    property DialWait;
    property DialRetryWait;
    property DialAttempts;
    property MaxSendCount;
    property SafeMode;
    property ToneDial;
    property DialPrefix;
    property EnhTextEnabled;
    property EnhFont;
    property EnhHeaderFont;

    { receive-specific properties }
    property AnswerOnRing;
    property ConstantStatus;
    property DestinationDir;
    property FaxNameMode;
    property PrintOnReceive;
    property FaxPrinter;

    { events }
    property OnFaxServerStatus;
    property OnFaxServerFatalError;
    property OnFaxServerFinish;
    property OnFaxServerPortOpenClose;
    property OnFaxServerAccept;
    property OnFaxServerName;
    property OnFaxServerLog;
  end;

implementation

uses
  AnsiStrings;

{ TApdCustomFaxServer }

procedure TApdCustomFaxServer.CancelFax;
begin
  if FFaxServerMode = fsmSend then
    FSendFax.CancelFax
  else if FFaxServerMode = fsmReceive then
    FRecvFax.CancelFax;
end;

procedure TApdCustomFaxServer.CheckPort;
var
  ET : EventTimer;
begin
  if not Assigned(FComPort) then
    raise EPortNotAssigned.Create(ecPortNotAssigned, False);
  if FSendFax.ComPort = nil then
    FSendFax.ComPort := FComPort;
  if FRecvFax.Comport = nil then
    FRecvFax.ComPort := FComPort;

  if (FTapiDevice <> nil) and (FComPort.TapiMode in [tmOn, tmAuto]) then begin
    { open the device through TAPI if the device isn't already open }
    if not FComPort.Open then begin
      NewTimer(ET, 91);  { 5 seconds for TAPI to respond }
      WaitingOnTapi := True;
      FTapiDevice.ConfigAndOpen;
      repeat
        DelayTicks(4, True);
      until (not WaitingOnTapi) or TimerExpired(ET);
      if TimerExpired(ET) then
        FTapiDevice.CancelCall;
      if not FComPort.Open then begin
        if Assigned(FFaxServerFatalErrorEvent) then
          FFaxServerFatalErrorEvent(Self, TFaxServerMode(FaxMode),
            egTapi, FTapiDevice.FailureCode)
        else
          raise ETapiCallUnavail.Create(ecCallUnavail, True);
      end;

    end;
  end else
    FComPort.Open := True;

  { set up defaults for faxing }
  with FComPort do begin
    DataBits := 8;
    StopBits := 1;
    Parity := pNone;
    Baud := 19200;
    InSize := 8192;
    OutSize := 8192;
    HWFlowOptions := [hwfUseRTS, hwfRequireCTS];
  end;
end;

constructor TApdCustomFaxServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if not (csDesigning in ComponentState) then begin
    FSendFax := TApdSendFax.Create(Self);
    FRecvFax := TApdReceiveFax.Create(Self);
    FSendQueryTimer := TTimer.Create(Self);
    FSendQueryTimer.Enabled := False;

    { set up internal event handlers }
    FSendFax.OnFaxFinish := FInternalFaxFinish;
    FSendFax.OnFaxStatus := FInternalFaxStatus;
    FSendFax.OnFaxLog    := FInternalFaxLog;
    FRecvFax.OnFaxFinish := FInternalFaxFinish;
    FRecvFax.OnFaxLog    := FInternalFaxLog;
    FRecvFax.OnFaxStatus := FInternalFaxStatus;
    FRecvFax.OnFaxName   := FInternalFaxName;
    FRecvFax.OnFaxAccept := FInternalFaxAccept;
    FSendQueryTimer.OnTimer := FInternalSendQueryTimer;

    { property settings for internal components }
    FSendFax.AbortNoConnect := True;
    FSendFax.DialWait := adfDefDialWait;
    { we are handling retries now by rescheduling the job }
    FSendFax.DialAttempts := 1;
    FSendFax.DialRetryWait := adfDefDialRetryWait;
    FRecvFax.OneFax := True;
    FRecvFax.AbortNoConnect := True;
    FRecvFax.FaxAndData := False;
  end;
  { property inits }
  FaxFileExt := adfDefFaxFileExt;
  ExitOnError := adfDefExitOnError;
  SoftwareFlow := adfDefSoftwareFlow;
  BlindDial := adfDefBlindDial;
  DetectBusy := adfDefDetectBusy;
  ToneDial := adfDefToneDial;
  MaxSendCount := adfDefMaxSendCount;
  BufferMinimum := adfDefBufferMinimum;
  SafeMode := adfDefSafeMode;
  DelayBetweenSends := adfDefDelayBetweenSends;
  SendQueryInterval := adfDefSendQueryInterval;
  FaxFileExt := adfDefFaxFileExt;
  DestinationDir := adfDefDestinationDir;
  ExitOnError := adfDefExitOnError;
  SoftwareFlow := adfDefSoftwareFlow;
  InitBaud := adfDefInitBaud;
  NormalBaud := adfDefNormalBaud;
  FaxClass := adfDefFaxClass;
  AnswerOnRing := adfDefAnswerOnRing;
  ConstantStatus := adfDefConstantStatus;
  FaxNameMode := adfDefFaxNameMode;
  DestinationDir := adfDefDestinationDir;
  FaxFileExt := adfDefFaxFileExt;
  FPageLength := 0;
  FEnhFont := TFont.Create;
  FEnhHeaderFont := TFont.Create;
  FDialAttempts := adfDefDialAttempts;
  FDialRetryWait := adfDefDialRetryWait;
  FDialWait := AdfDefDialWait;

  FFaxServerMode := fsmIdle;
  FMonitoring := False;
  FOldMonitoring := False;
  FServerLogCode := fslNone;
  FSwitchingModes := False;
  FWaitForRing := False;
end;

destructor TApdCustomFaxServer.Destroy;
begin
  if Assigned(FComPort) then
    FComPort.DeregisterUserCallback(FInternalPortToggle);
  FSendFax.Free;
  FRecvFax.Free;
  EnhFont.Free;
  EnhHeaderFont.Free;
  inherited Destroy;
end;

procedure TApdCustomFaxServer.FInternalFaxAccept(CP: TObject;
  var Accept: Boolean);
begin
  if Assigned(FFaxServerAcceptEvent) then
    FFaxServerAcceptEvent(Self, Accept)
  else
    Accept := True;
end;

procedure TApdCustomFaxServer.FInternalFaxFinish(CP: TObject;
  ErrorCode: Integer);
var
  HangupCode: Word;
  FaxMode: TFaxServerMode;
begin
  if CP = FSendFax then
    FaxMode := fsmSend
  else if CP = FRecvFax then begin
    FaxMode := fsmReceive;
    FWaitForRing := False;
  end else
    FaxMode := fsmIdle;
  if FSwitchingModes then begin
    FSwitchingModes := False;
    exit;
  end;
  try
    if (FaxMode = fsmReceive) and FPrintOnReceive then
      if Assigned(FFaxPrinter) then begin
        FFaxPrinter.FileName := string(FFaxFile);
        FFaxPrinter.PrintFax;
      end;
    { update the APJ to show the status of this transmission }
    if FaxMode = fsmSend then begin
      inc(CurrentRecipient.AttemptNum);
      FServerManager.UpdateStatus(CurrentJobFileName, CurrentJobNumber,
        ErrorCode, CurrentRecipient.AttemptNum >= FDialAttempts);
      { delete temp files }
       DeleteFile(string(FaxFile));
       DeleteFile(string(CoverFile));
    end;
  finally
    FFaxInProgress := False;
  end;

  { recoverable ErrorCodes are ecOK and exCancelRequested, other error codes
    require some form of intervention (checking the port, re-initing the modem,
    etc }
  if (ErrorCode = ecOK) or (ErrorCode = ecCancelRequested) or
    (ErrorCode = ecFaxBusy) or (ErrorCode = ecNoAnswer) then begin       {!!.05}
    if Assigned (FFaxServerFinishEvent) then
      { don't fire the OnFaxFinish if we're just switching modes }
      if FSwitchingModes then
        FSwitchingModes := False
      else
        try
          FFaxServerFinishEvent(Self, FaxMode, ErrorCode);
        finally
          { this is here in case an exception was raised in the event }
        end;
    if FaxMode = fsmSend then
      { reschedule jobs that were busy or cancelled }
      if (ErrorCode = ecFaxBusy) or (ErrorCode = ecCancelRequested) or   {!!.05}
        (ErrorCode = ecNoAnswer) and                                     {!!.05}
        (CurrentRecipient.AttemptNum < FDialAttempts)then begin
        FServerManager.RescheduleJob(CurrentJobFileName, CurrentJobNumber,
          Now + (FDialRetryWait / SecsPerDay), False);
    end;

  end else begin
    Monitoring := False;
    FOldMonitoring := False;
    FSendQueryTimer.Enabled := False;
    if Assigned (FFaxServerFatalErrorEvent) then begin
      if FFaxServerMode = fsmSend then
        HangupCode := FSendFax.HangupCode
      else if FFaxServerMode = fsmReceive then
        HangupCode := FRecvFax.HangupCode
      else
        HangupCode := 0;
      try
        FFaxServerFatalErrorEvent(Self, FaxMode, ErrorCode, HangupCode);
      finally
        { just in case an exception is raised in the event }
      end;
    end;
  end;

  { if where being destroyed, just exit }
  if csDestroying in ComponentState then
    Exit;

  { check for new fax jobs to send }
  if FSendQueryInterval > 0 then begin
    { we'll set our timer for DelayBetweenSends, then check for a new job }
    { when our FInternalSendQueryTimer event fires }
    FSendQueryTimer.Interval := Ticks2Secs(FDelayBetweenSends) * 1000;
    FSendQueryTimer.Enabled := True;
  end else if FMonitoring or FOldMonitoring then begin
    CheckPort;
    FOldMonitoring := False;
    { backdoor Monitoring to force back into receive from SetMonitoring }
    FMonitoring := False;
    Monitoring := True;
  end else begin
    { done with the port, close it }
    if FComPort.TapiMode = tmOn then
      FTapiDevice.CancelCall
    else
      FComPort.Open := False;
  end;
end;

procedure TApdCustomFaxServer.FInternalFaxLog(CP: TObject;
  LogCode: TFaxLogCode);
var
  HisFile: TextFile;
  LogString: String;
begin
  if Assigned(FFaxServerLogEvent) then
    FFaxServerLogEvent(Self, LogCode, FServerLogCode);

  if FFaxServerMode = fsmReceive then
    FFaxFile := FRecvFax.FaxFile;

  { we need to add our custom log info to the ApdFaxLog file }
  if Assigned(FFaxLog) and (FFaxLog.FaxHistoryName <> '') then begin     {!!.04}
    { a log must be wanted, open or create the log file }
    AssignFile(HisFile, string(FFaxLog.FaxHistoryName));
    if FileExists(string(FFaxLog.FaxHistoryName)) then
      Append(HisFile)
    else
      Rewrite(HisFile);

    if FServerLogCode = fslNone then begin
      { a regular fax log }
      case LogCode of
        lfaxTransmitStart : { override the default string to use the APJ name }
          LogString := Format('Transmit %s (%d) to %s started at %s'#13#10,
                  [CurrentJobFileName, CurrentJobNumber, PhoneNumber,
                   DateTimeToStr(Now)]);

        lfaxTransmitOk,
        lfaxTransmitFail : LogString := FFaxLog.GetLogString(LogCode, FSendFax);

        lfaxReceiveStart,
        lfaxReceiveOk,
        lfaxReceiveSkip,
        lfaxReceiveFail  : LogString := FFaxLog.GetLogString(LogCode, FRecvFax);

      end;

    end else begin
      { it's a fax server log }
      LogString := 'Fax server ' + Self.Name;
      case FServerLogCode of
        fslPollingEnabled      : LogString := LogString + ' started polling ';
        fslPollingDisabled     : LogString := LogString + ' stopped polling ';
        fslMonitoringEnabled   : LogString := LogString + ' started monitoring ';
        fslMonitoringDisabled  : LogString := LogString + ' stopped monitoring ';
      end;
      LogString := LogString + 'at ' + DateTimeToStr(Now);
      WriteLn(HisFile, LogString);
      if (FComPort.TapiMode = tmOn) then
        LogString := '    using ' + FTapiDevice.SelectedDevice
      else
        LogString := '    using ' + ComName(FComPort.ComNumber);
    end;

    WriteLn(HisFile, LogString);
    CloseFile(HisFile);
    if IOResult <> 0 then ;
  end;
  FServerLogCode := fslNone;
end;

procedure TApdCustomFaxServer.FInternalFaxName(CP: TObject;
  var Name: TPassString);
  function GetFaxNameMD : string;
  var
    I, Y, M, D : Word;
    MM, DD : string[2];
    Num: ShortString;
    S, FName : string;
  begin
    DecodeDate(SysUtils.Date, Y, M, D);
    Str(M:2, MM);
    Str(D:2, DD);
    FName := string(MM + DD);
    I := 0;
    repeat
      inc(I);
      if I >= 10000 then break;
      Str(I:4, Num);
      S := FName + string(Num) + '.' + string(FFaxFileExt);
      while Pos(' ', S) > 0 do
        S[Pos(' ', S)] := '0';
    until not FileExists(AddBackslash(string(FDestinationDir)) + S);
    if I < 10000 then
      Result := AddBackslash(string(FDestinationDir)) + S
    else
      Result := AddBackslash(string(FDestinationDir)) + 'NONAME.APF';
  end;
  function GetFaxNameCount : string;
  var
    I : DWORD;
    Num: ShortString;
    S, FName : string;
  begin
    FName := 'FAX';
    I := 0;
    repeat
      inc(I);
      if I >= 100000 then break;
      Str(I:5, Num);
      S := FName + string(Num) + '.' + string(FFaxFileExt);
      while Pos(' ', S) > 0 do
        S[Pos(' ', S)] := '0';
    until not FileExists(AddBackslash(string(FDestinationDir)) + S);
    if I < 10000 then
      Result := AddBackslash(string(FDestinationDir)) + S
    else
      Result := AddBackslash(string(FDestinationDir)) + 'NONAME.APF';
  end;

begin
  if Assigned(FFaxServerNameEvent) and (FFaxNameMode = fnNone) then
    FFaxServerNameEvent(Self, Name) else begin
      {Nothing assigned, use one of the built in methods}
      case FFaxNameMode of
        fnMonthDay :
          Name := TPassString(GetFaxNameMD());
        fnCount :
          Name := TPassString(GetFaxNameCount());
        else
          Name := TPassString(AddBackslash(string(FDestinationDir)) + 'NONAME.APF');
      end;
    end;
end;

procedure TApdCustomFaxServer.FInternalFaxStatus(CP: TObject; First,
  Last: Boolean);
var
  Status: Word;
  FaxMode: TFaxServerMode;
begin
  if CP = FSendFax then
    FaxMode := fsmSend
  else if CP = FRecvFax then
    FaxMode := fsmReceive
  else FaxMode := fsmIdle;
  if First then
    FFaxInProgress := True
  else if Last then
    FFaxInProgress := False;
  if Assigned(FStatusDisplay) then begin
    { update the status display to show info pertinenet to the fax }
    { job instead of the regular send/receive fax info }
    with TStandardFaxDisplay(FStatusDisplay.Display) do begin
      if First then begin
        fsLabel2.Caption := 'Job file name:';
        fsLabel3.Caption := 'Job name:';
      end else if Last then begin
        fsLabel2.Caption := 'Fax file name:';
        fsLabel3.Caption := 'Cover file name:';
      end;
      fsFaxFileName.Caption := string(CurrentJobFileName);
      fsCoverFileName.Caption := string(CurrentJobHeader.JobName);
      fsDialAttempt.Caption := IntToStr(CurrentRecipient.AttemptNum + 1);
    end;
  end;

  if Assigned(FFaxServerStatusEvent) then begin
    if FSwitchingModes then
      Status := fpSwitchModes
    else if FFaxServerMode = fsmSend then
      Status := FSendFax.FaxProgress
    else if FFaxServerMode = fsmReceive then
      Status := FRecvFax.FaxProgress
    else
      Status := 0;
    OnFaxServerStatus(Self, FaxMode, First, Last, Status);
  end;
end;

procedure TApdCustomFaxServer.FInternalPortToggle(CP: TObject;
  Opening: Boolean);
begin
  if Assigned(FFaxServerPortOpenCloseEvent) then
    FFaxServerPortOpenCloseEvent(Self, Opening);
end;

procedure TApdCustomFaxServer.FInternalSendQueryTimer(Sender: TObject);
var
  JobFileName, FaxFileName, CoverFileName: TPassString;
  Recipient: TFaxRecipientRec;
begin
  if csDestroying in ComponentState then Exit;
  if FFaxInProgress then
    Exit;

  FaxFileName := '';
  CoverFileName := '';
  { shut the timer down while we are looking }
  FSendQueryTimer.Enabled := False;

  if Assigned(FServerManager) then
    if FServerManager.GetJob(Recipient, Self, JobFileName, FaxFileName,
      CoverFileName) then begin

      { generate the manager's OnQuery event }
      if Assigned(FServerManager.FFaxServerManagerQueriedEvent) then
        FServerManager.FFaxServerManagerQueriedEvent(FServerManager,
          Self, string(JobFileName));

      CurrentJobFileName := JobFileName;
      CurrentJobNumber := Recipient.JobID;
      CurrentRecipient := Recipient;
      FServerManager.GetJobHeader(CurrentJobFileName, CurrentJobHeader);

      HeaderSender := CurrentJobHeader.Sender;
      PhoneNumber := Recipient.PhoneNumber;
      HeaderLine := Recipient.HeaderLine;
      HeaderRecipient := Recipient.HeaderRecipient;
      HeaderTitle := Recipient.HeaderTitle;
      FaxFile := FaxFileName;
      CoverFile := CoverFileName;

      CheckPort;

      if not FComPort.Open then begin
        { the port couldn't be opened, so we'll just update the status }
        { so we can try to get the port later }
        FServerManager.UpdateStatus(CurrentJobFileName,
          CurrentJobNumber, Abs(ecCommNotOpen), False);
        FSendQueryTimer.Enabled := True;
        Exit;
      end;

      { save Monitoring, we will revert in the FInternalFaxFinish event }
      FOldMonitoring := Monitoring;
      { turn off receive mode }
      if FWaitForRing then begin
        FSwitchingModes := True;
        FRecvFax.CancelFax;
        DelayTicks(18, True);
      end else
        FSwitchingModes := False;
      { make sure we don't have any residual input }
      FComPort.FlushInBuffer;
      FaxServerMode := fsmSend;
      FSendFax.StartTransmit;
    end else begin
      { generate the manager's OnQuery event, no job ready }
      if Assigned(FServerManager.FFaxServerManagerQueriedEvent) then
        FServerManager.FFaxServerManagerQueriedEvent(FServerManager,
          Self, '');

      if FSendQueryInterval <> 0 then begin
        FSendQueryTimer.Interval := FSendQueryInterval * 1000;
        FSendQueryTimer.Enabled := True;
      end;
      if not FMonitoring then begin
        { done with the port, close it }
        if FComPort.TapiMode = tmOn then
          FTapiDevice.CancelCall
        else
          FComPort.Open := False;
      end else if not FWaitForRing then begin
        FaxServerMode := fsmReceive;
        FRecvFax.StartReceive;
        FWaitForRing := True;
      end else
        FSwitchingModes := False;
    end;

end;

procedure TApdCustomFaxServer.FInternalTapiPortOpenClose(Sender: TObject);
begin
  { this event handler is only used to update the flag }
  WaitingOnTapi := False;
end;

procedure TApdCustomFaxServer.FInternalTapiFail(Sender : TObject);
begin
  WaitingOnTapi := False;
end;

procedure TApdCustomFaxServer.ForceSendQuery;
var                                                                      {!!.02}
  OldPaused : Boolean;                                                   {!!.02}
begin
  OldPaused := FServerManager.FPaused;                                   {!!.02}
  FServerManager.Paused := False;                                        {!!.02}
  FInternalSendQueryTimer(nil);
  FServerManager.Paused := OldPaused;                                    {!!.02}
end;

function TApdCustomFaxServer.GetBytesTransferred: Integer;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.BytesTransferred
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.BytesTransferred
  else
    Result := 0;
end;

function TApdCustomFaxServer.GetCurrentPage: Word;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.CurrentPage
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.CurrentPage
  else
    Result := 0;
end;

function TApdCustomFaxServer.GetDialAttempt: Word;
begin
  if Assigned(FSendFax) then
    Result := FSendFax.DialAttempt
  else
    Result := 0;
end;

function TApdCustomFaxServer.GetDialAttempts: Word;
begin
  Result := FDialAttempts;
end;

function TApdCustomFaxServer.GetFaxProgress: Word;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.FaxProgress
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.FaxProgress
  else
    Result := 0;
end;

function TApdCustomFaxServer.GetHangupCode: Word;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.HangupCode
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.HangupCode
  else
    Result := 0;
end;

function TApdCustomFaxServer.GetModemBPS: Integer;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.ModemBPS
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.ModemBPS
  else
    Result := 0;
end;

function TApdCustomFaxServer.GetModemChip: string;
begin
  if FFaxServerMode = fsmSend then
    Result := string(FSendFax.ModemChip)
  else if FFaxServerMode = fsmReceive then
    Result := string(FRecvFax.ModemChip)
  else
    Result := '';
end;

function TApdCustomFaxServer.GetModemECM: Boolean;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.ModemECM
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.ModemECM
  else
    Result := False;
end;

function TApdCustomFaxServer.GetModemModel: string;
begin
  if FFaxServerMode = fsmSend then
    Result := string(FSendFax.ModemModel)
  else if FFaxServerMode = fsmReceive then
    Result := string(FRecvFax.ModemModel)
  else
    Result := '';
end;

function TApdCustomFaxServer.GetModemRevision: string;
begin
  if FFaxServerMode = fsmSend then
    Result := string(FSendFax.ModemRevision)
  else if FFaxServerMode = fsmReceive then
    Result := string(FRecvFax.ModemRevision)
  else
    Result := ''
end;

function TApdCustomFaxServer.GetPageLength: Integer;
var
  F: File;
begin
  Result := FPageLength;
  if FPageLength = 0 then
    if (FFaxFile <> '') and FileExists(string(FFaxFile)) then begin
      AssignFile(F, string(FFaxFile));
      Reset(F, 1);
      FPageLength := FileSize(F);
      CloseFile(F);
      Result := FPageLength;
  end;
end;

function TApdCustomFaxServer.GetRemoteID: string;
begin
  if FFaxServerMode = fsmSend then
    Result := string(FSendFax.RemoteID)
  else if FFaxServerMode = fsmReceive then
    Result := string(FRecvFax.RemoteID)
  else
    Result := '';
end;

function TApdCustomFaxServer.GetSessionBPS: Word;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.SessionBPS
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.SessionBPS
  else
    Result := 0;
end;

function TApdCustomFaxServer.GetSessionECM: Boolean;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.SessionECM
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.SessionECM
  else
    Result := False;
end;

function TApdCustomFaxServer.GetSessionResolution: Boolean;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.SessionResolution
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.SessionResolution
  else
    Result := True;
end;

function TApdCustomFaxServer.GetSessionWidth: Boolean;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.SessionWidth
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.SessionWidth
  else
    Result := True;
end;

function TApdCustomFaxServer.GetSupportedFaxClasses: TFaxClassSet;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.SupportedFaxClasses
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.SupportedFaxClasses
  else
    Result := [];
end;

function TApdCustomFaxServer.GetTotalPages: Word;
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.TotalPages
  else if FFaxServerMode = fsmReceive then
    Result := FRecvFax.TotalPages
  else
    Result := 0;
end;

procedure TApdCustomFaxServer.Notification(AComponent: TComponent;
  Operation: TOperation);
{ - handle dependent components coming and going }
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then begin
    if AComponent = FComPort then begin
      FComPort := nil;
      if not (csDesigning in ComponentState) then begin
        FSendFax.ComPort := nil;
        FRecvFax.ComPort := nil;
      end;
    end;
    if AComponent = FFaxLog then
      FFaxLog := nil;
    if AComponent = FFaxPrinter then begin
      FFaxPrinter := nil;
      FPrintOnReceive := False;
    end;
    if AComponent = FServerManager then
      FServerManager := nil;
    if AComponent = FStatusDisplay then
      FStatusDisplay := nil;
    if AComponent = FTapiDevice then begin
      FTapiDevice := nil;
      if Assigned(FComPort) then
        FComPort.TapiMode := tmOff;
    end;

  end else if Operation = opInsert then begin
    if AComponent is TApdCustomComPort then begin
      if not Assigned(FComPort) then
        ComPort := TApdCustomComPort(AComponent);
      if not (csDesigning in ComponentState) then begin
        if FSendFax.ComPort = nil then
          FSendFax.ComPort := TApdCustomComPort(AComponent);
        if FRecvFax.ComPort = nil then
          FRecvFax.ComPort := TApdCustomComPort(AComponent);
      end;
    end;
    if AComponent is TApdAbstractFaxStatus then begin
      if not Assigned(FStatusDisplay) then
        StatusDisplay := TApdAbstractFaxStatus(AComponent);
    end;
    if AComponent is TApdFaxLog then
      if not Assigned(FFaxLog) then
        FaxLog := TApdFaxLog(AComponent);
    if AComponent is TApdCustomFaxPrinter then
      if not Assigned(FFaxPrinter) then
        FaxPrinter := TApdCustomFaxPrinter(AComponent);
    if AComponent is TApdFaxServerManager then
     if not Assigned(FServerManager) then
       ServerManager := TApdFaxServerManager(AComponent);
    if AComponent is TApdCustomTapiDevice then
      if not Assigned(FTapiDevice) then
        TapiDevice := TApdCustomTapiDevice(AComponent);
  end;
end;

procedure TApdCustomFaxServer.SetAnswerOnRing(const Value: Word);
begin
  if FAnswerOnRing <> Value then begin
    FAnswerOnRing := Value;
    if Assigned(FRecvFax) then
      FRecvFax.AnswerOnRing := Value;
  end;
end;

procedure TApdCustomFaxServer.SetBlindDial(const Value: Boolean);
begin
  if FBlindDial <> Value then begin
    FBlindDial := Value;
    if Assigned(FSendFax) then
      FSendFax.BlindDial := Value;
  end;
end;

procedure TApdCustomFaxServer.SetBufferMinimum(const Value: Word);
begin
  if FBufferMinimum <> Value then begin
    FBufferMinimum := Value;
    if Assigned(FSendFax) then
      FSendFax.BufferMinimum := Value;
  end;
end;

procedure TApdCustomFaxServer.SetComPort(const Value: TApdCustomComPort);
begin
  if FComPort <> Value then begin
    if Assigned(FComPort) then
      FComPort.DeregisterUserCallBack(FInternalPortToggle);
    if Assigned(Value) then
      Value.RegisterUserCallBack(FInternalPortToggle);
    FComPort := Value;
    if Assigned(FSendFax) then
      FSendFax.ComPort := Value;
    if Assigned(FRecvFax) then
      FRecvFax.ComPort := Value;
  end;
end;

procedure TApdCustomFaxServer.SetConstantStatus(const Value: Boolean);
begin
  if FConstantStatus <> Value then begin
    FConstantStatus := Value;
    if Assigned(FRecvFax) then
      FRecvFax.ConstantStatus := Value;
  end;
end;

procedure TApdCustomFaxServer.SetCoverFile(const Value: TPassString);
begin
  if FCoverFile <> Value then begin
    FCoverFile := Value;
    if Assigned(FSendFax) then
      FSendFax.CoverFile := Value;
  end;
end;

procedure TApdCustomFaxServer.SetDelayBetweenSends(const Value: Word);
begin
  if FDelayBetweenSends <> Value then
    FDelayBetweenSends := Value;
end;

procedure TApdCustomFaxServer.SetDesiredBPS(const Value: Word);
begin
  if FDesiredBPS <> Value then begin
    FDesiredBPS := Value;
    if Assigned(FSendFax) then
      FSendFax.DesiredBPS := Value;
    if Assigned(FRecvFax) then
      FRecvFax.DesiredBPS := Value;
  end;
end;

procedure TApdCustomFaxServer.SetDesiredECM(const Value: Boolean);
begin
  if FDesiredECM <> Value then begin
    FDesiredECM := Value;
    if Assigned(FSendFax) then
      FSendFax.DesiredECM := Value;
    if Assigned(FRecvFax) then
      FRecvFax.DesiredECM := Value;
  end;
end;

procedure TApdCustomFaxServer.SetDestinationDir(const Value: TPassString);
begin
  if FDestinationDir <> Value then begin
    FDestinationDir := AddBackSlash(Value);
    if Assigned(FRecvFax) then
      FRecvFax.DestinationDir := FDestinationDir;
  end;
end;

procedure TApdCustomFaxServer.SetDetectBusy(const Value: Boolean);
begin
  if FDetectBusy <> Value then begin
    FDetectBusy := Value;
    if Assigned(FSendFax) then
      FSendFax.DetectBusy := Value;
  end;
end;

procedure TApdCustomFaxServer.SetDialAttempts(const Value: Word);
begin
  FDialAttempts := Value;
end;

procedure TApdCustomFaxServer.SetDialPrefix(const Value: TModemString);
begin
  if FDialPrefix <> Value then begin
    FDialPrefix := Value;
    if Assigned(FSendFax) then
      FSendFax.DialPrefix := Value;
  end;
end;

procedure TApdCustomFaxServer.SetDialWait(const Value: Word);
begin
  FDialWait := Value;
  if Assigned(FSendFax) then
    FSendFax.DialWait := Value;
end;

procedure TApdCustomFaxServer.SetEnhFont(const Value: TFont);
begin
  if FEnhFont <> Value then begin
    FEnhFont.Assign(Value);
    if Assigned(FSendFax) then
      FSendFax.EnhFont := Value;
  end;
end;

procedure TApdCustomFaxServer.SetEnhHeaderFont(const Value: TFont);
begin
  if FEnhHeaderFont <> Value then begin
    FEnhHeaderFont.Assign(Value);
    if Assigned(FSendFax) then
      FSendFax.EnhHeaderFont := Value;
  end;
end;

procedure TApdCustomFaxServer.SetEnhTextEnabled(const Value: Boolean);
begin
  if FEnhTextEnabled <> Value then begin
    FEnhTextEnabled := Value;
    if Assigned(FSendFax) then
      FSendFax.EnhTextEnabled := Value;
  end;
end;

procedure TApdCustomFaxServer.SetExitOnError(const Value: Boolean);
begin
  if FExitOnError <> Value then begin
    FExitOnError := Value;
    if Assigned(FSendFax) then
      FSendFax.ExitOnError := Value;
    if Assigned(FRecvFax) then
      FRecvFax.ExitOnError := Value;
  end;
end;

procedure TApdCustomFaxServer.SetFaxClass(const Value: TFaxClass);
begin
  if FFaxClass <> Value then begin
    FFaxClass := Value;
    if Assigned(FSendFax) then
      FSendFax.FaxClass := Value;
    if Assigned(FRecvFax) then
      FRecvFax.FaxClass := Value;
  end;
end;

procedure TApdCustomFaxServer.SetFaxFile(const Value: TPassString);
begin
  if FFaxFile <> Value then begin
    inherited SetFaxFile(Value);
    FFaxFile := Value;
    if Assigned(FSendFax) then
      FSendFax.FaxFile := Value;
    if Assigned(FRecvFax) then
      FRecvFax.FaxFile := Value;
    { force the page length check }
    FPageLength := 0;
    GetPageLength;
  end;
end;

procedure TApdCustomFaxServer.SetFaxFileExt(const Value: TPassString);
begin
  if FFaxFileExt <> Value then begin
    FFaxFileExt := Value;
    if Assigned(FSendFax) then
      FSendFax.FaxFileExt := Value;
    if Assigned(FRecvFax) then
      FRecvFax.FaxFileExt := Value;
  end;
end;

procedure TApdCustomFaxServer.SetFaxLog(const Value: TApdFaxLog);
begin
  if FFaxLog <> Value then begin
    FFaxLog := Value;
    { not using the TApdFaxLog directly anymore }
    {if Assigned(FSendFax) then}                                         {!!.04}
      {FSendFax.FaxLog := Value;}                                        {!!.04}
    {if Assigned(FRecvFax) then}                                         {!!.04}
      {FRecvFax.FaxLog := Value;}                                        {!!.04}
  end;
end;

procedure TApdCustomFaxServer.SetFaxNameMode(const Value: TFaxNameMode);
begin
  if FFaxNameMode <> Value then begin
    FFaxNameMode := Value;
    if Assigned(FRecvFax) then
      FRecvFax.FaxNameMode := Value;
  end;
end;

procedure TApdCustomFaxServer.SetFaxPrinter(
  const Value: TApdCustomFaxPrinter);
begin
  if FFaxPrinter <> Value then
    FFaxPrinter := Value;
end;

procedure TApdCustomFaxServer.SetFaxServerMode(
  const Value: TFaxServerMode);
begin
  FFaxServerMode := Value;
  if FFaxServerMode = fsmSend then begin
    if Assigned(FStatusDisplay) then
      FStatusDisplay.Fax := FSendFax;
    { not using the TApdFaxLog directly }
    {if Assigned(FFaxLog) then}                                          {!!.04}
      {FFaxLog.Fax := FSendFax;}                                         {!!.04}
  end else if FFaxServerMode = fsmReceive then begin
    if Assigned(FStatusDisplay) then
      FStatusDisplay.Fax := FRecvFax;
    {if Assigned(FFaxLog) then}                                          {!!.04}
      {FFaxLog.Fax := FRecvFax;}                                         {!!.04}
  end;
end;

procedure TApdCustomFaxServer.SetHeaderLine(const Value: TPassString);
begin
  if FHeaderLine <> Value then begin
    FHeaderLine := Value;
    if Assigned(FSendFax) then
      FSendFax.HeaderLine := Value;
  end;
end;

procedure TApdCustomFaxServer.SetHeaderRecipient(const Value: TPassString);
begin
  if FHeaderRecipient <> Value then begin
    FHeaderRecipient := Value;
    if Assigned(FSendFax) then
      FSendFax.HeaderRecipient := Value;
  end;
end;

procedure TApdCustomFaxServer.SetHeaderSender(const Value: TPassString);
begin
  if FHeaderSender <> Value then begin
    FHeaderSender := Value;
    if Assigned(FSendFax) then
      FSendFax.HeaderSender := Value;
  end;
end;

procedure TApdCustomFaxServer.SetHeaderTitle(const Value: TPassString);
begin
  if FHeaderTitle <> Value then begin
    FHeaderTitle := Value;
    if Assigned(FSendFax) then
      FSendFax.HeaderTitle := Value;
  end;
end;

procedure TApdCustomFaxServer.SetInitBaud(const Value: Integer);
begin
  if FInitBaud <> Value then begin
    FInitBaud := Value;
    if Assigned(FSendFax) then
      FSendFax.InitBaud := Value;
    if Assigned(FRecvFax) then
      FRecvFax.InitBaud := Value;
  end;
end;

procedure TApdCustomFaxServer.SetMaxSendCount(const Value: Word);
begin
  if FMaxSendCount <> Value then begin
    FMaxSendCount := Value;
    if Assigned(FSendFax) then
      FSendFax.MaxSendCount := Value;
  end;
end;

procedure TApdCustomFaxServer.SetModemInit(const Value: TModemString);
begin
  if FModemInit <> Value then begin
    FModemInit := Value;
    if Assigned(FSendFax) then
      FSendFax.ModemInit := Value;
    if Assigned(FRecvFax) then
      FRecvFax.ModemInit := Value;
  end;
end;

procedure TApdCustomFaxServer.SetMonitoring(const Value: Boolean);
  { - enables or disables automatic fax reception }
begin
  if csDesigning in ComponentState then
    Exit;
  if Value = FMonitoring then
    Exit;
  if Value then begin
    { enable monitoring for incoming faxes }
    if not FFaxInProgress then begin
      CheckPort;
      FaxServerMode := fsmReceive;

      if not FWaitForRing then begin
        FRecvFax.StartReceive;
        FWaitForRing := True;
      end;
    end;
    FServerLogCode := fslMonitoringEnabled;
    FInternalFaxLog(Self, lfaxNone);

    FMonitoring := True;
  end else begin
    { disable monitoring for incoming faxes }
    FServerLogCode := fslMonitoringDisabled;
    FInternalFaxLog(Self, lfaxNone);
    { if we are receiving a fax, disable monitoring and finish this fax }
    FMonitoring := False;
    { otherwise, terminate the monitoring }
    if FFaxInProgress then
      FMonitoring := False
    else begin
      FSwitchingModes := True;
      FRecvFax.CancelFax;
      FWaitForRing := False;
      FaxServerMode := fsmIdle;
    end;
  end;
end;

procedure TApdCustomFaxServer.SetNormalBaud(const Value: Integer);
begin
  if FNormalBaud <> Value then begin
    FNormalBaud := Value;
    if Assigned(FSendFax) then
      FSendFax.NormalBaud := Value;
    if Assigned(FRecvFax) then
      FRecvFax.NormalBaud := Value;
  end;
end;

procedure TApdCustomFaxServer.SetPhoneNumber(const Value: TPassString);
begin
  if FPhoneNumber <> Value then begin
    FPhoneNumber := Value;
    if Assigned(FSendFax) then
      FSendFax.PhoneNumber := Value;
  end;
end;

procedure TApdCustomFaxServer.SetPrintOnReceive(const Value: Boolean);
begin
  if FPrintOnReceive <> Value then begin
    if Assigned(FFaxPrinter) then
      FPrintOnReceive := Value
    else
      FPrintOnReceive := False;
  end;
end;

procedure TApdCustomFaxServer.SetSafeMode(const Value: Boolean);
begin
  if FSafeMode <> Value then begin
    FSafeMode := Value;
    if Assigned(FSendFax) then
      FSendFax.SafeMode := Value;
  end;
end;

procedure TApdCustomFaxServer.SetSendQueryInterval(const Value: Integer);
begin
  if FSendQueryInterval <> Value then begin
    FSendQueryInterval := Value;
    if FSendQueryInterval <> 0 then
      FServerLogCode := fslPollingEnabled
    else
      FServerLogCode := fslPollingDisabled;
    FInternalFaxLog(Self, lfaxNone);
    if csDesigning in ComponentState then
      Exit;
    if Assigned(FSendQueryTimer) then begin
      FSendQueryTimer.Interval := Value * 1000;
      FSendQueryTimer.Enabled := True;
    end;
  end;
end;

procedure TApdCustomFaxServer.SetServerManager(
  const Value: TApdFaxServerManager);
begin
  FServerManager := Value;
end;

procedure TApdCustomFaxServer.SetSoftwareFlow(const Value: Boolean);
begin
  if FSoftwareFlow <> Value then begin
    FSoftwareFlow := Value;
    if Assigned(FSendFax) then
      FSendFax.SoftwareFlow := Value;
    if Assigned(FRecvFax) then
      FRecvFax.SoftwareFlow := Value;
  end;
end;

procedure TApdCustomFaxServer.SetStationID(const Value: TStationID);
begin
  if FStationID <> Value then begin
    FStationID := Value;
    if Assigned(FSendFax) then
      FSendFax.StationID := Value;
    if Assigned(FRecvFax) then
      FRecvFax.StationID := Value;
  end;
end;

procedure TApdCustomFaxServer.SetStatusDisplay(
  const Value: TApdAbstractFaxStatus);
begin
  if FStatusDisplay <> Value then begin
    FStatusDisplay := Value;
  end;
end;

procedure TApdCustomFaxServer.SetStatusInterval(const Value: Word);
begin
  if FStatusInterval <> Value then begin
    FStatusInterval := Value;
    if Assigned(FSendFax) then
      FSendFax.StatusInterval := Value;
    if Assigned(FRecvFax) then
      FRecvFax.StatusInterval := Value;
  end;
end;

procedure TApdCustomFaxServer.SetTapiDevice(
  const Value: TApdCustomTapiDevice);
begin
  if FTapiDevice <> Value then begin
    FTapiDevice := Value;
    if Assigned(FTapiDevice) then begin
      FTapiDevice.OnTapiPortOpen := FInternalTapiPortOpenClose;
      FTapiDevice.OnTapiPortClose := FInternalTapiPortOpenClose;
      FTapiDevice.OnTapiFail := FInternalTapiFail;
    end;
  end;
end;

procedure TApdCustomFaxServer.SetToneDial(const Value: Boolean);
begin
  if FToneDial <> Value then begin
    FToneDial := Value;
    if Assigned(FSendFax) then
      FSendFax.ToneDial := Value;
  end;
end;

function TApdCustomFaxServer.StartTransmitSingle : Boolean;
  { - transmits a single fax, returns True if we can send immediately,
      False if we need to wait for an ongoing fax to complete }
begin
  if FFaxInProgress then begin
    Result := False;
  end else begin
    Result := True;
    ForceSendQuery;
  end;
end;

function TApdCustomFaxServer.GetElapsedTime: DWORD;                      {!!.02}
begin
  if FFaxServerMode = fsmSend then
    Result := FSendFax.ElapsedTime
  else if FFaxServerMode = fsmReceive then
    Result :=FRecvFax.ElapsedTime
  else
    Result := 0;
end;

{ TApdFaxServerManager }

constructor TApdFaxServerManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFaxList := TStringList.Create;
  FFaxList.Sorted := False;
  FJobFileExt := adfDefJobFileExt;
  FFirstGetJob := True;
end;

destructor TApdFaxServerManager.Destroy;
var
  I: Integer;
begin
  for I := Pred(FFaxList.Count) downto 0 do
    FFaxList.Objects[I].Free;
  FFaxList.Free;
  FLockFile.Free;
  DeleteFile(string(FMonitorDir) + ServerManagerLockFileName);
  inherited Destroy;
end;

function TApdFaxServerManager.GetJob(var Recipient: TFaxRecipientRec;
  QueryFrom : TApdCustomFaxServer; var JobFileName, FaxFile,
  CoverFile:  TPassString): Boolean;
{ returns the next scheduled fax.  Recipient is updated to reflect the info for
  the job, FaxFile is where the APF data is extracted to, CoverFile is where
  the cover page is extracted to. }
var
  JobStream   : TFileStream;
  JobHeader   : TFaxJobHeaderRec;
  TempDir     : TPathCharArray;
  TempFN      : TFileName;
  I,
  FileInc,
  NextJob     : Integer;
  NextSchedDT,
  EarliestDT  : TDateTime;
  TempRecip   : TFaxRecipientRec;
  sJobFile, sFaxFile, sCoverFile : string;
begin
  if Assigned(FManagerUserGetJobEvent) then begin
    { if the OnCustomGetJob event is defined, we'll let the application }
    { decide which fax to send next.  JobFileName is the APJ that we're }
    { working with, FaxFile is an extracted APF that we'll send,        }
    { CoverFile is a text file that contains the cover page text,       }
    { NextJob is the recipient number that we'll send, the application  }
    { is responsible for updating the appropriate status flags upon     }
    { completion }
    { we need to pass a string instead of a ShortString due to a }
    { compiler problem }
    sJobFile := '';
    sFaxFile := '';
    sCoverFile := '';
    NextJob := 0;
    FManagerUserGetJobEvent(Self, QueryFrom, sJobFile, sFaxFile,
    sCoverFile, NextJob);
    JobFileName := TPassString(sJobFile);
    FaxFile := TPassString(sFaxFile);
    CoverFile := TPassString(sCoverFile);
    Result := JobFileName <> '';
    if Result then
      Result := GetRecipient(JobFileName, NextJob, Recipient) = ecOK;
    Exit;
  end;
  if FPaused then begin
    Result := False;
    Exit;
  end;
  { wait if we're already in progress }
  while FInGetJob do
    Application.ProcessMessages;
  FInGetJob := True;
  JobFileName := GetNextFax;
  if JobFileName = '' then begin
    { a fax is not scheduled to be sent now, return False and exit }
    Result := False;
    FInGetJob := False;
    Exit;
  end;
  JobStream := nil;
  try
    try
      JobStream := TFileStream.Create(string(JobFileName), fmOpenReadWrite or fmShareDenyWrite);
    except
      { if an exception was raised here, the file was in use.  We'll }
      { just bail out now and try again on the next query }
      Result := False;
      FInGetJob := False;
      JobFileName := '';
      Exit;
    end;
    { read the JobHeader, set Status to stPartial, and write it back }
    JobStream.ReadBuffer(JobHeader, SizeOf(JobHeader));
    JobHeader.Status := stPartial;
    JobStream.Position := 0;
    JobStream.WriteBuffer(JobHeader, SizeOf(JobHeader));
    JobStream.Seek(JobHeader.NextJob * SizeOf(Recipient), soFromCurrent);

    { read the Recipient for our job, set Status as stPartial, and write it back }
    JobStream.ReadBuffer(Recipient, SizeOf(Recipient));
    Recipient.Status := stPartial;
    JobStream.Seek(-SizeOf(Recipient), soFromCurrent);
    JobStream.WriteBuffer(Recipient, SizeOf(Recipient));

    { now, find the next job to send so another fax server can find it }
    NextJob := 0;
    EarliestDT := MaxInt;
    NextSchedDT := MaxInt;
    JobStream.Seek(SizeOf(TFaxJobHeaderRec), soFromBeginning);
    for I := 0 to pred(JobHeader.NumJobs) do begin
      JobStream.ReadBuffer(TempRecip, SizeOf(TFaxRecipientRec));
      if TempRecip.SchedDT < EarliestDT then begin
        EarliestDT := TempRecip.SchedDT;
        if TempRecip.Status = stNone then begin                          {!!.05}
          NextJob := I;
          NextSchedDT := TempRecip.SchedDT;
        end;
      end;                                                               {!!.05}
    end;
    JobHeader.NextJob := NextJob;
    if NextSchedDT < MaxInt then
      JobHeader.SchedDT := NextSchedDT;
    JobStream.Seek(0, soFromBeginning);
    JobStream.WriteBuffer(JobHeader, SizeOf(TFaxJobHeaderRec));
  finally
    JobStream.Free;
    FInGetJob := False;
  end;

  FillChar(TempDir, SizeOf(TempDir), #0);
  FillChar(TempFN, SizeOf(TempFN), #0);
  GetTempPath(Length(TempDir), TempDir);
  TempFN := StrPas(TempDir) + string(FaxFile);

  FileInc := 0;
  if FaxFile = '' then begin
    FaxFile := TPassString(TempFN + string(JobHeader.JobName) + '.' + adfDefFaxFileExt);
    while FileExists(string(FaxFile)) do begin
      FaxFile := TPassString(TempFN + string(JobHeader.JobName) + IntToHex(FileInc, 2) +
        '.' + adfDefFaxFileExt);
      inc(FileInc);
    end;
  end;
  if CoverFile = '' then begin
    CoverFile := TPassString(ChangeFileExt(string(FaxFile), '.txt'));
  end;

  { extract the APF data to FaxFile }
  ExtractAPF(JobFileName, FaxFile);
  { extract the CoverFile data to CoverFile, clears CoverFile if one isn't there }
  if not(ExtractCoverFile(JobFileName, CoverFile)) then
    CoverFile := '';

  Result := True;

end;

function TApdFaxServerManager.GetNextFax: TPassString;
{ check the MonitorDir for files not accounted for and add them to
  the list.  Return the name of the job file if one is ready, or
  just return an empty string }
{ the format of the FFaxList is:
  String: <filename>
  Object: TFaxListObj }
var
  SR: TSearchRec;
  SchedDT, tNow: TDateTime;
  I: Integer;
  FileMask: TPassString;
  NewFaxListObj: TFaxListObj;
  AddFileInfo: Boolean;
begin
  for I := pred(FFaxList.Count) downto 0 do begin                        {!!.05}
    TFaxListObj(FFaxList.Objects[I]).Free;                               {!!.05}
    FFaxList.Delete(I);                                                  {!!.05}
  end;                                                                   {!!.05}
  { look for new files in MonitorDir }
  FileMask := AddBackSlash(FMonitorDir) + '*.' + FJobFileExt;
  if SysUtils.FindFirst(string(FileMask), faAnyFile, SR) = 0 then begin
    repeat
      { see if the filename is already in our list }
      AddFileInfo := False;
      I := FFaxList.IndexOf(SR.Name);
      if I = -1 then begin
        { the file name has not been logged }
        AddFileInfo := True;
{$WARN SYMBOL_DEPRECATED OFF}
      end else if SR.Time <> TFaxListObj(FFaxList.Objects[I]).FileTime then begin
        { the file name has been logged, but the timestamp has changed }
        { delete the old list item and add the new one }
        FFaxList.Objects[I].Free;
        FFaxList.Delete(I);
        AddFileInfo := True;
      end;

      if AddFileInfo then begin
        NewFaxListObj := TFaxListObj.Create;
        NewFaxListObj.FileTime := SR.Time;
{$WARN SYMBOL_DEPRECATED ON}
        GetJobHeader(TPassString(string(FMonitorDir) + SR.Name), NewFaxListObj.JobHeader);
        if NewFaxListObj.JobHeader.Status = stPartial then begin
          if FFirstGetJob then begin
            { if this is the first time through, reset all of the recipients }
            { that were stPartial to stNone }
            ResetAPJPartials(TPassString(string(FMonitorDir) + SR.Name), False);              {!!.03}
            GetJobHeader(TPassString(string(FMonitorDir) + SR.Name), NewFaxListObj.JobHeader);
          end;
        end;

        if AddFileInfo then
          FFaxList.AddObject(SR.Name, TFaxListObj(NewFaxListObj));
      end;

    until SysUtils.FindNext(SR) <> 0;
  end;
  SysUtils.FindClose(SR);

  { now, go through the list and find the next one to send }
  if FFaxList.Count = 0 then begin
    { nothing is ready yet, return an empty string }
    Result := '';
    Exit;
  end;

  for I := pred(FFaxList.Count) downto 0 do begin
    if not FileExists(string(FMonitorDir) + FFaxList[I]) then begin
      { the file has been deleted from the FMonitorDir, delete it from our list }
      FFaxList.Objects[I].Free;
      FFaxList.Delete(I);
    end else
    with TFaxListObj(FFaxList.Objects[I]) do begin
      { strip out the fax jobs that are already complete or paused }
      if JobHeader.Status in [stComplete, stPaused] then begin
        FFaxList.Objects[I].Free;
        FFaxList.Delete(I);
      end else
      { finally, strip out the jobs that are in progress }
      if JobHeader.Status = stPartial then
        if GetRecipientStatus(TPassString(string(FMonitorDir) + FFaxList[I]), JobHeader.NextJob) in
          [stPartial, stComplete, stPaused] then begin
          FFaxList.Objects[I].Free;
          FFaxList.Delete(I);

        end;
    end;
  end;
  FFirstGetJob := False;

  if FFaxList.Count = 0 then begin
    { nothing is ready yet, return an empty string }
    Result := '';
    exit;
  end;

  { get the scheduled time of the first fax in the list }
  SchedDT := MaxInt;

  { and assume that it is the fax we will send next }
  Result := '';
  { iterate through the list and find the earliest scheduled fax }
  for I := 0 to pred(FFaxList.Count) do
    with TFaxListObj(FFaxList.Objects[I]) do begin
      if (JobHeader.SchedDT < SchedDT) and
         (JobHeader.Status <> stComplete) then begin
        Result := TPassString(FFaxList.Strings[I]);
        SchedDT := TFaxListObj(FFaxList.Objects[I]).JobHeader.SchedDT;
      end;
    end;

  { add the FMonitorDir path to the APJ to send }
  Result := FMonitorDir + Result;

  { return an empty string if the fax isn't supposed to be sent yet }
  tNow := Now;
  if SchedDT > tNow  then
    Result := '';
end;

function TApdFaxServerManager.GetSchedTime(JobFileName: TPassString): TDateTime;
  { - finds the earliest scheduled time for the specified APJ }
var
  FS: TFileStream;
  JobHeader: TFaxJobHeaderRec;
begin
  FS := nil;
  try
    FS := TFileStream.Create(string(JobFileName), fmOpenRead or fmShareDenyNone);
    FS.ReadBuffer(JobHeader, SizeOf(JobHeader));
    Result := JobHeader.SchedDT;
  finally
    FS.Free;
  end;
end;

procedure TApdFaxServerManager.Reset;
  { - resets server manager }
var
  I : Integer;
begin
  { clear our internal list so the next time GetNextFax is fired all jobs will
    be added fresh }
  for I := Pred(FFaxList.Count) downto 0 do
    FFaxList.Objects[I].Free;
  FFaxList.Clear;
  FFirstGetJob := True;
end;

procedure TApdFaxServerManager.SetMonitorDir(const Value: TPassString);
begin
  if AnsiUpperCase(AddBackSlash(FMonitorDir)) <>
     AnsiUpperCase(AddBackSlash(Value)) then begin
    {FMonitorDir := AddBackSlash(Value);} {don't need this here}
    if csDesigning in ComponentState then begin
      FMonitorDir := AnsiUpperCase(Value);
      Exit;
    end;
    { free the old lock file, create the new one.  If another ApdFaxServerManager
      is already monitoring this directory an exception will be raised }
    FLockFile.Free;
    try
      FLockFile := TFileStream.Create(AddBackSlash(string(Value)) +
        ServerManagerLockFileName, fmCreate or fmShareExclusive);
      { hide the lock file }
      FileSetAttr(AddBackSlash(string(Value)) + ServerManagerLockFileName, faHidden);
      { if we got here, an exception was not raised, so accept the value }
      FMonitorDir := AnsiUpperCase(AddBackSlash(Value));
    except
      { if this exception is raised, the FMonitorDir directory is already being
        monitored by another ApdFaxServerManager.  Only one ApdFaxServerManager
        can monitor any given directory at a time }
      raise EAlreadyMonitored.Create(ecAlreadyMonitored, False);
    end;
  end;
end;

procedure TApdFaxServerManager.UpdateStatus(JobFileName: TPassString;
  JobNumber, Result: Word; Failed: Boolean);
var
  JobStream: TFileStream;
  JobHeader: TFaxJobHeaderRec;
  Recipient  : TFaxRecipientRec;
  I: Integer;
  JobStatus: Byte;
  FaxListNames: TPassString;
  NextJob : Integer;
  NextSchedDT : TDateTime;
  AllSuccess : Boolean;
begin
  JobStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenReadWrite or fmShareDenyWrite);
    JobStream.ReadBuffer(JobHeader, SizeOf(TFaxJobHeaderRec));
    I := SizeOf(TFaxJobHeaderRec) + (JobNumber * SizeOf(TFaxRecipientRec));
    JobStream.Seek(I, soFromBeginning);
    JobStream.ReadBuffer(Recipient, SizeOf(TFaxRecipientRec));
  finally
    { close the file so it could be deleted from the event handler below}
    JobStream.Free;
  end;
  Recipient.LastResult := Result;
  if Result = ecOK then
    Recipient.Status := stComplete    {fax was successful}
  else if Failed then
    Recipient.Status := stComplete    {fax failed, out of retries}
  else
    Recipient.Status := stNone;       {fax failed, but we will retry it}

  if Recipient.Status = stComplete then
    if Assigned(FManagerUpdateRecipientEvent) then begin
    { generate the OnRecipientComplete event.  Recipient.Status will always }
    { be stComplete (hence the name of the event). If Recipient.LastResult  }
    { the fax was sent successfully to this recipient. Otherwise, LastResult}
    { contains the ErrorCode from the last attempt. You can resubmit the    }
    { recipient by changing Recipient.Status to stNone. The JobFile is      }
    { closed, so it can be deleted from the event handler.                  }
      FManagerUpdateRecipientEvent(Self, string(JobFileName),
        JobHeader, Recipient);
    end;

  { if the file was deleted in the event, just exit }
  if not FileExists(string(JobFileName)) then
    Exit;

  inc(Recipient.AttemptNum);

  JobStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName),
      fmOpenReadWrite or fmShareDenyWrite);

    JobStream.Seek(I, soFromBeginning);
    JobStream.WriteBuffer(Recipient, SizeOf(TFaxRecipientRec));
    JobStream.Seek(SizeOf(JobHeader), soFromBeginning);

    JobStatus := stNone;
    for I := 0 to pred(JobHeader.NumJobs) do begin                       {!!.05}
      JobStream.ReadBuffer(Recipient, SizeOf(TFaxRecipientRec));
      JobStatus := JobStatus + Recipient.Status;
    end;
    if JobStatus = stNone then
      JobHeader.Status := stNone
    else if JobStatus = stComplete * JobHeader.NumJobs then
      JobHeader.Status := stComplete
    else
      JobHeader.Status := stPartial;

    AllSuccess := True;
    { find the next job }
    NextJob := 0;
    NextSchedDT := MaxInt;
    JobStream.Seek(SizeOf(TFaxJobHeaderRec), soFromBeginning);
    for I := 0 to pred(JobHeader.NumJobs) do begin
      JobStream.Read(Recipient, SizeOf(TFaxRecipientRec));
      { if the job is stNone, we are awaiting retry }
      if Recipient.Status = stNone then
        if Recipient.SchedDT < NextSchedDT then begin
          NextJob := I;
          NextSchedDT := Recipient.SchedDT;
        end;
      { AllSuccess should be True only if the status is complete and }
      { it completed OK }
      AllSuccess := AllSuccess and (Recipient.Status = stComplete) and
        (Recipient.LastResult = ecOK);
    end;
    JobHeader.NextJob := NextJob;
    if NextSchedDT < MaxInt then
      JobHeader.SchedDT := NextSchedDT;

    JobStream.Seek(0, soFromBeginning);
    JobStream.WriteBuffer(JobHeader, SizeOf(TFaxJobHeaderRec));
  finally
    JobStream.Free;
  end;

  { flag the file in the stringlist if all jobs are complete }
  if JobHeader.Status = stComplete then begin
    FaxListNames := ExtractFileName(JobFileName);
    I := FFaxList.IndexOf(string(FaxListNames));
    if I >= 0 then
      TFaxListObj(FFaxList.Objects[I]).JobHeader.Status := stComplete;
    { the job is complete, so delete it if DeleteOnComplete }
    if FDeleteOnComplete and AllSuccess then
      DeleteFile(string(JobFileName));
  end
end;


{ TApdFaxClient }
function TApdFaxClient.CopyJobToServer(SourceJob,
  DestJob: TPassString; OverWrite: Boolean): Integer;
{ - generic copying method, the full path for SourceJob and DestJob needs
    to be included.  This may not work for all networks, but it can handle
    mapped drives and //computername/shareddrive notation }
var
  MS: TMemoryStream;
begin
  { assume success }
  Result := 0;
  if not OverWrite and FileExists(string(DestJob)) then begin
    Result := -80;    { maps to ERROR_FILE_EXISTS }
    Exit;
  end;
  MS := nil;
  try
    MS := TMemoryStream.Create;
    try
      MS.LoadFromFile(string(SourceJob));
      MS.SaveToFile(string(DestJob));
    except
      Result := GetlastError;
    end;
  finally
    MS.Free;
  end;
end;

constructor TApdFaxClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSender := '';
  FJobName := '';
  FillChar(Recipient, SizeOf(TFaxRecipientRec), #0);
  Recipient.Status := 0;
  Recipient.SchedDT := Now;
  Recipient.AttemptNum := 0;
  Recipient.LastResult := 0;
end;

function TApdFaxClient.GetHeaderLine: TPassString;
begin
  Result := Recipient.HeaderLine;
end;

function TApdFaxClient.GetHeaderRecipient: TPassString;
begin
  Result := Recipient.HeaderRecipient;
end;

function TApdFaxClient.GetHeaderTitle: TPassString;
begin
  Result := Recipient.HeaderTitle;
end;

function TApdFaxClient.GetPhoneNumber: TPassString;
begin
  Result := Recipient.PhoneNumber;
end;

function TApdFaxClient.GetScheduleDateTime: TDateTime;
begin
  Result := Recipient.SchedDT;
end;

procedure TApdFaxClient.MakeFaxJob;
begin
  MakeJob(FaxFileName, CoverFileName, JobName, Sender, JobFileName, Recipient);
end;

procedure TApdFaxClient.SetHeaderLine(const Value: TPassString);
begin
  Recipient.HeaderLine := Value;
end;

procedure TApdFaxClient.SetHeaderRecipient(const Value: TPassString);
begin
  Recipient.HeaderRecipient := Value;
end;

procedure TApdFaxClient.SetHeaderTitle(const Value: TPassString);
begin
  Recipient.HeaderTitle := Value;
end;

procedure TApdFaxClient.SetPhoneNumber(const Value: TPassString);
begin
  Recipient.PhoneNumber := Value;
end;

procedure TApdFaxClient.SetScheduleDateTime(const Value: TDateTime);
begin
  Recipient.SchedDT := Value;
end;


{ TApdFaxJobHandler }

procedure TApdFaxJobHandler.AddRecipient(JobFileName: TPassString;
  RecipientInfo: TFaxRecipientRec);
{ adds a TFaxRecipientRec to an existing APJ file }
var
  JobStream, TempStream: TMemoryStream;
  JobHeader: TFaxJobHeaderRec;
begin
  { create 2 TMemoryStreams. TempStream reads the existing file, JobStream
    inserts the new record }
  JobStream := nil;
  try
    JobStream := TMemoryStream.Create;
    TempStream := nil;
    try
      TempStream := TMemoryStream.Create;
      TempStream.LoadFromFile(string(JobFileName));
      TempStream.ReadBuffer(JobHeader, SizeOf(JobHeader));
      TempStream.Position := 0;
      JobStream.CopyFrom(TempStream, SizeOf(JobHeader) +
        (JobHeader.NumJobs * SizeOf(TFaxRecipientRec)));
      { initialize RecipientInfo and insert it into the stream }
      with RecipientInfo do begin
        Status := 0;  { not sent }
        JobID := JobHeader.NumJobs;
        AttemptNum := 0;
        LastResult := 0;
        FillChar(Padding, SizeOf(Padding), #0);
      end;
      JobStream.WriteBuffer(RecipientInfo, SizeOf(RecipientInfo));
      { copy the remainder of the original }
      JobStream.CopyFrom(TempStream, TempStream.Size - TempStream.Position);
    finally
      TempStream.Free;
    end;
    { update the JobHeader info to reflect new recipient }
    inc(JobHeader.NumJobs);
    if JobHeader.CoverOfs <> 0 then
      inc(JobHeader.CoverOfs, SizeOf(TFaxRecipientRec));
    inc(JobHeader.FaxHdrOfs, SizeOf(TFaxRecipientRec));
    if RecipientInfo.SchedDT < JobHeader.SchedDT then begin
      JobHeader.SchedDT := RecipientInfo.SchedDT;
      JobHeader.NextJob := JobHeader.NumJobs - 1;
    end;
    JobStream.Position := 0;
    JobStream.WriteBuffer(JobHeader, SizeOf(JobHeader));
    JobStream.SaveToFile(string(JobFileName));
  finally
    JobStream.Free;
  end;
end;

procedure TApdFaxJobHandler.CancelRecipient(JobFileName: TPassString;
  JobNum: Byte);
var
  JobStream : TFileStream;
  RecipInfo : TFaxRecipientRec;
  StreamPos : Integer;
begin
  ResetRecipientStatus(JobFileName, JobNum, stComplete);
  JobStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenReadWrite or
      fmShareDenyWrite);
    StreamPos := SizeOf(TFaxJobHeaderRec) + (JobNum * SizeOf(TFaxRecipientRec));
    JobStream.Seek(StreamPos, soFromBeginning);
    JobStream.ReadBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
    RecipInfo.LastResult := Word(ecCancelRequested);
    JobStream.Seek(StreamPos, soFromBeginning);
    JobStream.WriteBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
  finally
    JobStream.Free;
  end;
end;

procedure TApdFaxJobHandler.ConcatFaxes(DestFaxFile: TPassString;
  FaxFiles: array of TPassString);
var
  I : Integer;
  DestFile, SourceFile : TFileStream;
  DestHeader, SourceHeader : TFaxHeaderRec;
begin
  DestFile := nil;
  SourceFile := nil;
  try
    { Create temp file }
    DestFile := TFileStream.Create(string(DestFaxFile), fmCreate or fmShareExclusive);
    try
      { Open first source file }
      SourceFile := TFileStream.Create(string(FaxFiles[0]), fmOpenRead or fmShareDenyNone);

      { Read header of the first APF }
      SourceFile.ReadBuffer(DestHeader, SizeOf(DestHeader));
      if (DestHeader.Signature <> DefAPFSig) then
        raise EFaxBadFormat.Create(ecFaxBadFormat, False);
      { Copy first source file to dest }
      DestFile.CopyFrom(SourceFile, 0);
      SourceFile.Free;
      SourceFile := nil;
      { Append remaining files in the list }
      for I := 1 to High(FaxFiles) do begin
        SourceFile := TFileStream.Create(string(FaxFiles[I]), fmOpenRead or fmShareDenyNone);
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

procedure TApdFaxJobHandler.ExtractAPF(JobFileName, FaxName: TPassString);
var
  JobStream, FaxStream: TFileStream;
  JobHeader: TFaxJobHeaderRec;
begin
  JobStream := nil;
  FaxStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenRead or fmShareDenyNone);
    FaxStream := TFileStream.Create(string(FaxName), fmCreate or fmShareExclusive);
    JobStream.ReadBuffer(JobHeader, SizeOf(JobHeader));
    JobStream.Seek(JobHeader.FaxHdrOfs, soFromBeginning);
    FaxStream.CopyFrom(JobStream, JobStream.Size - JobStream.Position);
  finally
    JobStream.Free;
    FaxStream.Free;
  end;
end;

function TApdFaxJobHandler.ExtractCoverFile(JobFileName,
  CoverName: TPassString): Boolean;
var
  JobStream, CoverStream: TFileStream;
  JobHeader: TFaxJobHeaderRec;
begin
  JobStream := nil;
  CoverStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenRead or fmShareDenyNone);
    JobStream.ReadBuffer(JobHeader, SizeOf(JobHeader));
    if JobHeader.CoverOfs > 0 then begin
      JobStream.Seek(JobHeader.CoverOfs, soFromBeginning);
      try
        CoverStream := TFileStream.Create(string(CoverName), fmCreate or fmShareExclusive);
        CoverStream.CopyFrom(JobStream, JobHeader.FaxHdrOfs - JobHeader.CoverOfs);
      finally
        CoverStream.Free;
      end;
      Result := True;
    end else
      Result := False;
  finally
    JobStream.Free;
  end;
end;

procedure TApdFaxJobHandler.GetJobHeader(JobFileName: TPassString;
  var JobHeader: TFaxJobHeaderRec);
var
  JobStream: TFileStream;
begin
  JobStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenRead or fmShareDenyNone);
    JobStream.ReadBuffer(JobHeader, SizeOf(JobHeader));
  finally
    JobStream.Free;
  end;
end;

function TApdFaxJobHandler.GetRecipient(JobFileName: TPassString; Index: Integer;
  var Recipient: TFaxRecipientRec): Integer;
{ - returns the FaxRecipientRec for the Index recipient in the Job file }
var
  JobStream: TFileStream;
  JobHeader: TFaxJobHeaderRec;
begin
  JobStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenRead or fmShareDenyNone);
    try
      JobStream.ReadBuffer(JobHeader, SizeOf(JobHeader));
      if Index <= JobHeader.NumJobs then begin
        JobStream.Seek(SizeOf(JobHeader) +
          ((Index {- 1}) * SizeOf(TFaxRecipientRec)), soFromBeginning);  {!!.02}
        JobStream.ReadBuffer(Recipient, SizeOf(TFaxRecipientRec));
        Result := ecOK;
      end else
        Result := ecDiskRead;
    except
      Result := GetLastError;
    end;
  finally
    JobStream.Free;
  end;
end;

function TApdFaxJobHandler.GetRecipientStatus(JobFileName: TPassString;
  JobNum: Integer): Integer;
var
  RecipHeader : TFaxRecipientRec;
begin
  if  GetRecipient(JobFileName, JobNum, RecipHeader) = ecOK then
    Result := RecipHeader.Status
  else
    Result := -1;
end;

procedure TApdFaxJobHandler.MakeJob(FaxName, CoverName, JobName, Sender,
  DestName: TPassString; Recipient: TFaxRecipientRec);
var
  JobHeader: TFaxJobHeaderRec;
  FaxStream, JobStream, CoverStream: TFileStream;
  FaxHeader : TFaxHeaderRec;                                             {!!.02}
begin
  FaxStream := nil;
  JobStream := nil;
  try
    FaxStream := TFileStream.Create(string(FaxName), fmOpenRead or fmShareDenyNone);

    { validate the fax file as a real APF }
    FaxStream.ReadBuffer(FaxHeader, SizeOf(TFaxHeaderRec));              {!!.02}
    if (FaxHeader.Signature <> DefAPFSig) then                           {!!.02}
      raise EFaxBadFormat.Create(ecFaxBadFormat, False);                 {!!.02}

    JobStream := TFileStream.Create(string(DestName), fmCreate or fmShareDenyWrite);
    { initialize JobHeader }
    FillChar(JobHeader, SizeOf(JobHeader), #0);
    JobHeader.ID := apfDefJobHeaderID;
    JobHeader.Status := stNone;
    FillChar(JobHeader.JobName[1], 20, #0);
    JobHeader.JobName := JobName;
    FillChar(JobHeader.Sender[1], 40, #0);
    JobHeader.Sender := Sender;
    JobHeader.SchedDT := Recipient.SchedDT;
    JobHeader.NumJobs := 1;
    JobHeader.NextJob := 0;
    JobHeader.CoverOfs := 0;
    JobHeader.FaxHdrOfs := 0;
    JobHeader.Status := 0;
    JobStream.WriteBuffer(JobHeader, SizeOf(JobHeader));
    { mark the job as not sent }
    Recipient.Status := 0;
    Recipient.JobID := JobHeader.NumJobs - 1;
    Recipient.AttemptNum := 0;
    Recipient.LastResult := 0;
    JobStream.WriteBuffer(Recipient, SizeOf(Recipient));
    { add the cover file if available }
    if (CoverName <> '') and (FileExists(string(CoverName))) then begin
      JobHeader.CoverOfs := JobStream.Position;
      CoverStream := nil;
      try
        CoverStream := TFileStream.Create(string(CoverName), fmOpenRead or fmShareDenyNone);
        JobStream.CopyFrom(CoverStream, 0);
      finally
        CoverStream.Free;
      end;
    end;
    { add the APF file if available }
    if (FaxName <> '') and (FileExists(string(FaxName))) then begin
      JobHeader.FaxHdrOfs := JobStream.Position;
      JobStream.CopyFrom(FaxStream, 0);
    end;
    { update the JobHeader with the new ofsets }
    JobStream.Position := 0;
    JobStream.WriteBuffer(JobHeader, SizeOf(JobHeader));
  finally
    FaxStream.Free;
    JobStream.Free;
  end;
end;

procedure TApdFaxJobHandler.RescheduleJob(JobFileName: TPassString;
  JobNum: Integer; NewSchedDT: TDateTime; ResetStatus : Boolean);
var
  JobStream : TFileStream;
  JobInfo   : TFaxJobHeaderRec;
  RecipInfo : TFaxRecipientRec;
  StreamPos : Integer;
  JobStatus : Integer;
begin
  if not FileExists(string(JobFileName)) then
    Exit;
  JobStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenReadWrite or
      fmShareDenyWrite);

    { get the job header }
    JobStream.Seek(0, soFromBeginning);
    JobStream.ReadBuffer(JobInfo, SizeOf(TFaxJobHeaderRec));
    if JobInfo.NumJobs < JobNum then
      raise EListError.Create('Job number out of bounds');
    { get the recipient header for JobNum }
    //StreamPos := JobStream.Position;                                   {!!.05}
    JobStream.Seek(JobNum * SizeOf(TFaxRecipientRec), soFromCurrent);
    StreamPos := JobStream.Position;                                     {!!.05}
    JobStream.ReadBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
    RecipInfo.SchedDT := NewSchedDT;
    if ResetStatus then
      RecipInfo.Status := stNone;
    JobStream.Seek(StreamPos, soFromBeginning);
    JobStream.WriteBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
    { update the job's SchedDT to reflect new schedule }
    if RecipInfo.SchedDT < JobInfo.SchedDT then begin
      JobInfo.SchedDT := RecipInfo.SchedDT;
      JobInfo.NextJob := JobInfo.NumJobs - 1;
    end;
    { check the status and update the job's status }
    if ResetStatus then begin
      JobStatus := 0;
      JobStream.Seek(SizeOf(TFaxJobHeaderRec), soFromBeginning);
      for StreamPos := 0 to pred(JobInfo.NumJobs) do begin
        JobStream.ReadBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
        JobStatus := JobStatus + RecipInfo.Status;
      end;
      if JobStatus = stNone then
        JobInfo.Status := stNone
      else if JobStatus = stComplete * JobInfo.NumJobs then
        JobInfo.Status := stComplete
      else
        JobInfo.Status := stPartial;
    end;
    JobStream.Seek(0, soFromBeginning);
    JobStream.WriteBuffer(JobInfo, SizeOf(TFaxJobHeaderRec));
  finally
    JobStream.Free;
  end;
end;

procedure TApdFaxJobHandler.ResetAPJPartials(JobFileName: TPassString;
  ResetAttemptNum : Boolean);                                            {!!.03}
var
  JobInfo   : TFaxJobHeaderRec;
  RecipInfo : TFaxRecipientRec;
  JobNum    : Integer;
  JobStream : TFileStream;
  StreamPos : Integer;
begin
  JobStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenReadWrite or
      fmShareDenyWrite);
    JobStream.Seek(0, soFromBeginning);
    JobStream.ReadBuffer(JobInfo, SizeOf(TFaxJobHeaderRec));
    JobInfo.Status := stNone;
    JobStream.Seek(0, soFromBeginning);
    JobStream.WriteBuffer(JobInfo, SizeOf(TFaxJobHeaderRec));

    for JobNum := 0 to pred(JobInfo.NumJobs) do begin
      StreamPos := JobStream.Position;
      JobStream.ReadBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
      if RecipInfo.Status = stPartial then begin
        RecipInfo.Status := stNone;
        if ResetAttemptNum then                                          {!!.03}
          RecipInfo.AttemptNum := 0;                                     {!!.03}
        JobStream.Position := StreamPos;
        JobStream.WriteBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
      end;
    end;
  finally
    JobStream.Free;
  end;
end;

procedure TApdFaxJobHandler.ResetAPJStatus(JobFileName: TPassString);
  {- resets APJ so all jobs are unhandled }
var
  JobInfo   : TFaxJobHeaderRec;
  RecipInfo : TFaxRecipientRec;
  JobNum    : Integer;
  JobStream : TFileStream;
  StreamPos : Integer;
begin
  JobStream := nil;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenReadWrite or
      fmShareDenyWrite);
    JobStream.Seek(0, soFromBeginning);
    JobStream.ReadBuffer(JobInfo, SizeOf(TFaxJobHeaderRec));
    JobInfo.Status := stNone;
    JobStream.Seek(0, soFromBeginning);
    JobStream.WriteBuffer(JobInfo, SizeOf(TFaxJobHeaderRec));

    for JobNum := 0 to pred(JobInfo.NumJobs) do begin
      StreamPos := JobStream.Position;
      JobStream.ReadBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
      RecipInfo.Status := stNone;
      JobStream.Position := StreamPos;
      JobStream.WriteBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
    end;
  finally
    JobStream.Free;
  end;
end;

procedure TApdFaxJobHandler.ResetRecipientStatus(JobFileName: TPassString;
  JobNum, NewStatus: Byte);
var
  JobStream    : TFileStream;
  JobInfo      : TFaxJobHeaderRec;
  RecipInfo    : TFaxRecipientRec;
  I,
  JobStatus,
  StreamPos    : Integer;
begin
  JobStream := nil;
  JobStatus := 0;
  try
    JobStream := TFileStream.Create(string(JobFileName), fmOpenReadWrite or
      fmShareDenyWrite);
    { read the job header }
    JobStream.Seek(0, soFromBeginning);
    JobStream.ReadBuffer(JobInfo, SizeOf(TFaxJobHeaderRec));
    { read all recipient headers and update the one we want to change }
    for I := 0 to pred(JobInfo.NumJobs) do begin
      StreamPos := JobStream.Position;
      JobStream.ReadBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
      if I = JobNum then begin
        RecipInfo.Status := NewStatus;
        JobStream.Seek(StreamPos, soFromBeginning);
        JobStream.WriteBuffer(RecipInfo, SizeOf(TFaxRecipientRec));
      end;
      { add the status to JobStatus }
      JobStatus := JobStatus + RecipInfo.Status;
    end;
    if JobStatus = stNone then
      JobInfo.Status := stNone
    else if JobStatus = stComplete * JobInfo.NumJobs then
      JobInfo.Status := stComplete
    else
      JobInfo.Status := stPartial;
    JobStream.Seek(0, soFromBeginning);
    JobStream.WriteBuffer(JobInfo, SizeOf(TFaxJobHeaderRec));
  finally
    JobStream.Free;
  end;
end;

function TApdFaxJobHandler.ShowFaxJobInfoDialog(
  JobFileName, DlgCaption: TPassString): TModalResult;
begin
  with TApdFaxJobInfoDialog.Create(nil) do begin
    try
      Result := ShowDialog(JobFileName, DlgCaption);
    finally
      Free;
    end;
  end;
end;

end.
