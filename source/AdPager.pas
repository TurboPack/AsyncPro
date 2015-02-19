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
{*                   ADPAGER.PAS 4.06                    *}
{*********************************************************}
{* TApdTAPPager, TApdSNPPPager components                *}
{*********************************************************}

{
  These components have lots of little problems that pop up
  occasionally.  The TApdPager component in AdPgr.pas is an
  initial stab at cleaning the code up to make it more efficient
  and maintainable.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{ Changes too numerous for !!.01 markings to be effective }
{ Many changes for .02 also to fix several known problems, there are still     }
{ several known problems, which will be addressed through interim code changes }
{ leading up to a rewrite for .03.  The rewrite will primarily serve to make   }
{ the code more maintainable and expandable.}
unit AdPager;

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
  AdPort,
  AdExcept,
  AdTapi,
  AdTUtil,
  AdWnPort,
  AdPacket;

const
  atpCRLF = cCR + cLF;
  CmdLen = 41;
  MAX_MSG_LEN = 80;
  STD_DELAY: Integer = 9;  { wait half a sec.}

  adpgDefAbortNoConnect = False;
  adpgDefBlindDial      = False;
  adpgDefToneDial       = True;
  adpgDefExitOnError    = False;
  adpgDefDialAttempts   = 3;
  adpgDefDialRetryWait  = 30;
  adpgDefDialWait       = 60;
  adpgDefTimerTrig      = 1080;                                          {!!.04}
  adpgPulseDialPrefix   = 'DP';
  adpgToneDialPrefix    = 'DT';
  adpgDefDialPrefix     = adpgToneDialPrefix;
  adpgDefModemInitCmd   = 'ATZ' {+ atpCRLF};
  adpgDefNormalInit       = 'X4';
  adpgDefBlindInit        = 'X3';
  adpgDefNoDetectBusyInit = 'X2';
  adpgDefX1Init           = 'X1';
  adpgDefInit             = adpgDefNormalInit;
  adpgDefModemHangupCmd = '+++~~~ATH';
  adpgDefPagerHistoryName     = 'APROPAGR.HIS';

const
  { TDialingStatus }
  TDS_NONE              = 4600;
  TDS_OFFHOOK           = 4601;
  TDS_DIALING           = 4602;
  TDS_RINGING           = 4603;
  TDS_WAITFORCONNECT    = 4604;
  TDS_CONNECTED         = 4605;
  TDS_WAITINGTOREDIAL   = 4606;
  TDS_REDIALING         = 4607;
  TDS_MSGNOTSENT        = 4608;
  TDS_CANCELLING        = 4609;
  TDS_DISCONNECT        = 4610;
  TDS_CLEANUP           = 4611;

  { TDialingError }
  TDE_NONE              = 4630;
  TDE_NODIALTONE        = 4631;
  TDE_LINEBUSY          = 4632;
  TDE_NOCONNECTION      = 4633;

  { TTapStatus }
  TPS_NONE              = 4660;
  TPS_LOGINPROMPT       = 4661;
  TPS_LOGGEDIN          = 4662;
  TPS_LOGINERR          = 4663;
  TPS_LOGINFAIL         = 4664;
  TPS_MSGOKTOSEND       = 4665;
  TPS_SENDINGMSG        = 4666;
  TPS_MSGACK            = 4667;
  TPS_MSGNAK            = 4668;
  TPS_MSGRS             = 4669;
  TPS_MSGCOMPLETED      = 4670;
  TPS_DONE              = 4671;

  { DataTriggerHandlers for modem response }
  FapOKTrig         : AnsiString = 'OK';
  FapErrorTrig      : AnsiString = 'ERROR';
  FapConnectTrig    : AnsiString = 'CONNECT';
  FapBusyTrig       : AnsiString = 'BUSY';
  FapVoiceTrig      : AnsiString = 'VOICE';
  FapNoCarrierTrig  : AnsiString = 'NO CARRIER';
  FapNoDialtoneTrig : AnsiString = 'NO DIALTONE';

type
  TTriggerHandle = Word;
  TCmdString = AnsiString{[CmdLen]};                                         {!!.02}

  { forward class declaration }
  TApdPagerLog = class;

  TApdAbstractPager = class(TApdBaseComponent)
  private
    FPort      : TApdCustomComPort;
    FPagerID   : AnsiString;
    FMessage   : TStrings;
    FPagerLog  : TApdPagerLog;  {Logging component}
    FExitOnError: Boolean;
    FPageMode, FFailReason: AnsiString;
    procedure WriteToEventLog(const S: AnsiString); overload;
    procedure WriteToEventLog(const S: string); overload;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;

    procedure Send; virtual; abstract;

    procedure SetMessage(Msg: TStrings); virtual;
    procedure SetPagerID(ID: AnsiString); virtual;
    procedure SetPagerLog(const NewLog : TApdPagerLog);

    property Message: TStrings
      read FMessage write SetMessage;

    property PagerID: AnsiString
      read FPagerID write SetPagerID;

    property PagerLog : TApdPagerLog
      read FPagerLog write SetPagerLog;

    property ExitOnError: Boolean
      read FExitOnError write FExitOnError default adpgDefExitOnError;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  {Builtin log procedure}
  TApdPagerLog = class(TApdBaseComponent)
  protected {private}
    {.Z+}
    FHistoryName   : AnsiString;
    FPager         : TApdAbstractPager;

    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;

  public
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdPagerLog component}
    {.Z-}
    procedure UpdateLog(const LogStr: AnsiString); virtual;
      {-Add a log entry}
  published
    property Pager : TApdAbstractPager
      read FPager write FPager;
    property HistoryName : AnsiString
      read FHistoryName write FHistoryName;
  end;

type
  TDialingCondition = (
    dsNone, dsOffHook, dsDialing, dsRinging, dsWaitForConnect, dsConnected,
    dsWaitingToRedial, dsRedialing, dsMsgNotSent, dsCancelling, dsDisconnect,
    dsCleanup, deNone, deNoDialTone, deLineBusy, deNoConnection);

  TDialingStatus = dsNone..dsCleanup;
  TDialStatusEvent = procedure(Sender: TObject; Event: TDialingStatus) of object;

  TDialError = deNone..deNoConnection;
  TDialErrorEvent = procedure(Sender: TObject; Error: TDialError) of object;

  TApdCustomModemPager = class(TApdAbstractPager)

  private
  {private data fields}
    FTapiDev     : TApdTapiDevice; 

    { dialing status }
    mpGotOkay,
    FConnected,
    FSent,
    FAborted,
    Waiting, FCancelled  : Boolean;
    FDialStatus : TDialingStatus;
    FDialError  : TDialError;
    FDirectToPort : Boolean;

  {property storage fields}
    FAbortNoConnect,
    FBlindDial,
    FToneDial: Boolean;

    FDialAttempt,
    FDialAttempts,
    FDialRetryWait,
    FDialWait: Word;

    FDialPrefix,
    FModemHangup,
    FModemInit: TCmdString;

    FPhoneNumber : AnsiString;      { phone number to dial }

    FUseTapi     : Boolean;

    { Modem response data trigger handler fields }
    OKTrig,
    ErrorTrig,
    ConnectTrig,
    BusyTrig,
    VoiceTrig,
    NoCarrierTrig,
    NoDialtoneTrig : Word;

    {event handler fields}
    FOnDialStatus: TDialStatusEvent;
    FOnDialError : TDialErrorEvent;

    procedure AddInitModemDataTrigs;
    procedure DoOpenPort;  
    procedure DoDirect; virtual;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);{!!.02}
      override;                                                          {!!.02}
    {overridables for custom descendants}
    procedure DoCleanup; virtual;
    procedure DoDial; virtual;

    procedure DoStartCall; virtual;
    procedure TerminatePage; virtual;                                    {!!.02}
    procedure DoFailedToSend; virtual;

    procedure DoInitializePort;

    function GetTapiDev: TApdTapiDevice;
    property TapiDev : TApdTapiDevice
      read GetTapiDev;
    procedure SetUseTapi(const Value: Boolean);
    procedure SetTapiDev(const Value: TApdTapiDevice);
    procedure InitProperties; virtual;
    procedure SetPortOpts; virtual;

    procedure DoDialStatus(Event: TDialingCondition);
    procedure InitCallStateFlags;

    {property access methods}
    procedure SetBlindDial(BlindDialVal: Boolean);
    procedure SetDialPrefix(CmdStr: TCmdString);
    procedure SetModemHangup(CmdStr: TCmdString);
    procedure SetModemInit(CmdStr: TCmdString);
    function GetPort : TApdCustomComPort;
    procedure SetPort(ThePort: TApdCustomComPort); virtual;
    procedure SetToneDial(ToneDial: Boolean);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;

    function DialStatusMsg(Status: TDialingCondition): AnsiString;

    property Port: TApdCustomComPort
      read GetPort write SetPort;

    property AbortNoConnect: Boolean
      read FAbortNoConnect write FAbortNoConnect default adpgDefAbortNoConnect;
    property BlindDial : Boolean
      read FBlindDial write SetBlindDial default adpgDefBlindDial;
    property DialAttempt: Word
      read FDialAttempt write FDialAttempt;
    property DialAttempts: Word
      read FDialAttempts write FDialAttempts default adpgDefDialAttempts;
    property DialPrefix: TCmdString
      read FDialPrefix write SetDialPrefix;
    property DialRetryWait: Word
      read FDialRetryWait write FDialRetryWait default adpgDefDialRetryWait;
    property DialWait: Word
      read FDialWait write FDialWait default adpgDefDialWait;
    property ModemHangup: TCmdString
      read FModemHangup write SetModemHangup;
    property ModemInit: TCmdString
      read FModemInit write SetModemInit;
    property PhoneNumber: AnsiString
      read FPhoneNumber write FPhoneNumber;
    property ToneDial: Boolean
      read FToneDial write SetToneDial default adpgDefToneDial;
    property DirectToPort : Boolean
      read FDirectToPort write FDirectToPort default False;
    property UseTapi: Boolean
      read FUseTapi write SetUseTapi default False;
    property TapiDevice: TApdTapiDevice
      read FTapiDev write SetTapiDev;
    property OnDialError: TDialErrorEvent
      read FOnDialError write FOnDialError;
    property OnDialStatus: TDialStatusEvent
      read FOnDialStatus write FOnDialStatus;

    //procedure Send; override;                                          {!!.04}
    procedure CancelCall; virtual;

  end;

{utility definitions and routines }
const
  {TAP server repsonse sequences}
  TAP_ID_PROMPT   : AnsiString = 'ID=';
  TAP_LOGIN_ACK   : AnsiString = cAck + cCr;
  TAP_LOGIN_NAK   : AnsiString = cNak + cCr;
  TAP_LOGIN_FAIL  : AnsiString = cEsc + cEot + cCr;

  TAP_MSG_OKTOSEND: AnsiString = cEsc + '[p';
  TAP_MSG_ACK     : AnsiString = cAck + cCr;
  TAP_MSG_NAK     : AnsiString = cNak + cCr;
  TAP_MSG_RS      : AnsiString = cRs + cCr;

  TAP_DISCONNECT  : AnsiString = cEsc + cEot + cCr;


  TAP_AUTO_LOGIN  : AnsiString = cEsc + 'PG1' {+ cCr};
  TAP_LOGOUT      : AnsiString = cEot + cCr;

  MAX_TAP_RETRIES = 3;

type
  TTapStatus = (psNone, psLoginPrompt, psLoggedIn, psLoginErr,
    psLoginFail, psMsgOkToSend, psSendingMsg, psMsgAck, psMsgNak,
    psMsgRs, psMsgCompleted, psDone, psSendTimedOut);
  TTAPStatusEvent = procedure(Sender: TObject; Event: TTapStatus) of object;

  TTapGetNextMessageEvent = procedure (Sender      : TObject;
                                   var DoneMessages: Boolean) of object;


  TApdTAPPager = class(TApdCustomModemPager)
  private
  {private data fields}
    FUseEscapes  : Boolean;  { use escaping mechanism when sending; }
                             { otherwise strip chars}
    FMaxMsgLen   : Integer;
    FPassword    : AnsiString;

    FBlocks: TStrings;
    FMsgIdx: Integer;

    FtrgIDPrompt,
    FtrgLoginSucc,
    FtrgLoginFail,
    FtrgLoginErr,
    FtrgOkToSend,
    FtrgMsgAck,
    FtrgMsgNak,
    FtrgMsgRs,
    FtrgSendTimer,                                                       {!!.04}
    FtrgDCon: TTriggerHandle;

    tpPingTimer : TTimer;
    tpPingCount : Integer;
    tpTAPRetries : Integer;
    FTapWait : Integer;
  {event handler fields}
    FPageStatus : TTAPStatus;

    FOnTAPFinish: TNotifyEvent;
    FOnTAPStatus: TTAPStatusEvent;
    FOnGetNextMessage: TTapGetNextMessageEvent;
    procedure PingTimerOnTimer(Sender: TObject);
    procedure StartPingTimer;
    procedure DonePingTimer;

  protected
    procedure DoDirect; override;
    procedure DoTAPStatus(Status: TTapStatus);
    procedure DoStartCall; override;
    procedure InitProperties; override;

    procedure SetPort(ThePort: TApdCustomComPort); override;
    procedure TerminatePage; override;                                   {!!.02}

    procedure DataTriggerHandler(Msg, wParam: Cardinal; lParam: Integer);

    procedure FreeLoginTriggers;
    procedure FreeLogoutTriggers;
    procedure FreeMsgTriggers;
    procedure FreeResponseTriggers;
    function HandleToTrigger(TriggerHandle: Word): AnsiString;
    function HandleToTriggerUni(TriggerHandle: Word): string;
    procedure InitLoginTriggers;
    procedure InitLogoutTriggers;
    procedure InitMsgTriggers;
    procedure DoCurMessageBlock;
    procedure DoFirstMessageBlock;
    procedure DoNextMessageBlock;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Send; override;
    procedure ReSend;
    procedure Disconnect;

    function TAPStatusMsg(Status: TTAPStatus): AnsiString;

  published
    property Port;
    property PagerID;
    property Message;
    property PagerLog;

    property AbortNoConnect;
    property BlindDial;
    property DialAttempt;
    property DialAttempts;
    property DialPrefix;
    property DialRetryWait;
    property DialWait;
    property ExitOnError;
    property ModemHangup;
    property ModemInit;
    property PhoneNumber;
    property ToneDial;
    property DirectToPort;
    property TapiDevice;
    property UseTapi;

    property TapPassword : AnsiString
      read FPassword write FPassword;
    property TapWait : Integer
      read FTapWait write FTapWait default 30;

    property MaxMessageLength: Integer
      read FMaxMsgLen write FMaxMsgLen default MAX_MSG_LEN;
    property UseEscapes: Boolean
      read FUseEscapes write FUseEscapes default False;

    property OnDialError;
    property OnDialStatus;
    property OnTAPFinish: TNotifyEvent
      read FOnTAPFinish write FOnTAPFinish;
    property OnTAPStatus: TTAPStatusEvent
      read FOnTAPStatus write FOnTAPStatus;
    property OnGetNextMessage: TTapGetNextMessageEvent
      read FOnGetNextMessage write FOnGetNextMessage;
  end;

type
  TApdCustomINetPager = class(TApdAbstractPager)
  protected
    function GetPort: TApdWinsockPort;
    procedure SetPort(ThePort: TApdWinsockPort);
  public
    constructor Create(AOwner: TComponent); override;

    property Port: TApdWinsockPort
      read GetPort write SetPort;
  end;

  TSNPPMessage = procedure(Sender: TObject; Code: Integer; Msg: AnsiString)
    of object;

  TApdSNPPPager = class(TApdCustomINetPager)
  private
  { private data fields }
    FSent, FCancelled, FOkayToSend, FSessionOpen, FQuit: Boolean;
    FGotSuccess : Boolean;

    FLoginPacket, FServerSuccPacket, FServerDataMsgPacket,
    FServerErrorPacket,
    FServerFatalErrorPacket,
    FServerDonePacket: TApdDataPacket;

  { property storage }
    FServerInitString,
    FServerDoneString,
    FServerSuccStr,
    FServerDataInp,
    FServerRespFailCont,
    FServerRespFailTerm: AnsiString;

    FCommDelay: Integer;

    FOnLogin: TNotifyEvent;
    FOnLogout: TNotifyEvent;
    FOnSNPPSuccess: TSNPPMessage;
    FOnSNPPError: TSNPPMessage;

    procedure FreePackets;
    procedure InitPackets;

    procedure DoLoginString(Sender: TObject; Data: AnsiString);
    procedure DoServerSucc(Sender: TObject; Data: AnsiString);
    procedure DoServerDataMsg(Sender: TObject; Data: AnsiString);
    procedure DoServerError(Sender: TObject; Data: AnsiString);
    procedure DoServerFatalError(Sender: TObject; Data: AnsiString);
    procedure DoLogoutString(Sender: TObject; Data: AnsiString);

    procedure PutString(S: AnsiString);
    procedure DoMultiLine;
    procedure MakePacket(ThePacket: TApdDataPacket; StartStr, EndStr: AnsiString;
      HandlerMethod: TStringPacketNotifyEvent);
    procedure ReleasePacket(var ThePacket: TApdDataPacket);
    procedure DoClose;
    procedure DoStart;

  public
    procedure PutPagerID; virtual;
    procedure PutMessage; virtual;
    procedure PutSend; virtual;
    procedure PutQuit; virtual;

    procedure Send; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Quit;

    property ServerInitString: AnsiString
      read FServerInitString write FServerInitString;
    property ServerSuccessString: AnsiString
      read FServerSuccStr write FServerSuccStr;
    property ServerDataInput: AnsiString
      read FServerDataInp write FServerDataInp;
    property ServerResponseFailContinue: AnsiString
      read FServerRespFailCont write FServerRespFailCont;
    property ServerResponseFailTerminate: AnsiString
      read FServerRespFailTerm write FServerRespFailTerm;
    property ServerDoneString: AnsiString
      read FServerDoneString write FServerDoneString;

  published
    property PagerID;
    property Port;
    property Message;
    property ExitOnError;
    property PagerLog;

    property CommDelay: Integer
      read FCommDelay write FCommDelay default 0;

    property OnLogin: TNotifyEvent
      read FOnLogin write FOnLogin;
    property OnSNPPSuccess: TSNPPMessage
      read FOnSNPPSuccess write FOnSNPPSuccess;
    property OnSNPPError: TSNPPMessage
      read FOnSNPPError write FOnSNPPError;
    property OnLogout: TNotifyEvent
      read FOnLogout write FOnLogout;
  end;

implementation

uses
  AnsiStrings, AdAnsiStrings;

const
  { string resource offsets }
  STRRES_DIAL_STATUS = TDS_NONE;  {MODEM/Dialing status messages}
  STRRES_DIAL_ERROR  = TDE_NONE;  {MODEM/Dialing error messages }
  STRRES_TAP_STATUS  = TPS_NONE;  {TAP Specific status/error messages }

{utility procedures}

type
  TPageLogCondition = (pcStart, pcDone, pcError);

procedure FreeTrigger(Port: TApdCustomComPort;
  var Trigger: TTriggerHandle; TriggerName: AnsiString);
begin
  if (Assigned(Port)) and (Port.Open) and (Trigger <> 0) then begin
    Port.RemoveTrigger(Trigger);
    Trigger := 0;
  end else
  if (Trigger <> 0) then
    raise Exception.Create('Unable to free trigger: ' + string(TriggerName));
end;

function FormatLogEntry(PageMode, ID, Dest, Reason: string;
                        Condition                 : TPageLogCondition): string; overload;
var
  S: string;
begin
  case Condition of
    pcStart:  S := ' Started    ';
    pcDone:   S := ' Completed  ';
    pcError:  S := ' Failed: Reason: ' ;
  end;
  Result := FormatDateTime('mm/dd/yyyy hh:mm:ss ', Now ) + ' ' + PageMode +
    ' page to ' + ID + ' at ' + Dest + S + Reason;
end;

function FormatLogEntry(PageMode, ID, Dest, Reason: AnsiString;
                        Condition                 : TPageLogCondition): AnsiString; overload;
begin
  Result := AnsiString(FormatLogEntry(PageMode, ID, Dest, Reason, Condition));
end;

{TApdAbstractPager}

constructor TApdAbstractPager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMessage := TStringList.Create;
end;

destructor TApdAbstractPager.Destroy;
begin
  FMessage.Free;
  inherited Destroy;
end;

procedure TApdAbstractPager.Notification(AComponent: TComponent;
                                         Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then begin
    if AComponent = FPort then
      FPort := nil;
  end else begin
    if (AComponent is TApdCustomComPort) and (FPort = nil) then
      FPort := TApdCustomComPort(AComponent);
  end;
end;

procedure TApdAbstractPager.SetMessage(Msg: TStrings);
begin
  FMessage.Assign(Msg);
end;

procedure TApdAbstractPager.SetPagerID(ID: AnsiString);
begin
  if FPagerID <> ID then
    FPagerID := ID;
end;

procedure TApdAbstractPager.SetPagerLog(const NewLog: TApdPagerLog);
begin
  if NewLog <> FPagerLog then
    FPagerLog := NewLog;
end;

procedure TApdAbstractPager.WriteToEventLog(const S: AnsiString);
begin
  if Assigned(FPagerLog) then
    FPagerLog.UpdateLog(S);
end;

procedure TApdAbstractPager.WriteToEventLog(const S: string);
begin
  WriteToEventLog(AnsiString(S));
end;


{TApdCustomModemPager}
constructor TApdCustomModemPager.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);

  InitProperties;

  {search our owner for a com port}
  if Assigned(AOwner) and (AOwner.ComponentCount > 0) then begin         {!!.02}
    for I := 0 to Pred(AOwner.ComponentCount) do                         {!!.02}
      if AOwner.Components[I] is TApdCustomComPort then begin            {!!.02}
        SetPort(TApdCustomComPort(AOwner.Components[I]));                {!!.02}
        Break;                                                           {!!.02}
      end;                                                               {!!.02}
    for I := 0 to pred(AOwner.ComponentCount) do                         {!!.02}
      if AOwner.Components[I] is TApdTapiDevice then begin               {!!.02}
        FTapiDev := TApdTapiDevice(AOwner.Components[I]);                {!!.02}
        Break;                                                           {!!.02}
      end;                                                               {!!.02}
  end;                                                                   {!!.02}
end;

destructor TApdCustomModemPager.Destroy;
begin
  inherited Destroy;
end;

procedure TApdCustomModemPager.CancelCall;
begin
  FCancelled := True;
end;

procedure TApdCustomModemPager.DoCleanup;
begin
  DoDialStatus(dsCleanup);
end;

procedure TApdCustomModemPager.DoInitializePort;
begin
  if csDestroying in ComponentState then
    Exit;

  if Assigned(FPort) then begin
    { open the port }
    if Assigned(TapiDev) then begin                                      {!!.02}
      FUseTapi := True;                                                  {!!.02}
      SetTapiDev(TapiDev);                                               {!!.02}
      FTapiDev.ComPort := FPort;                                         {!!.02}
      FTapiDev.EnableVoice := False;                                     {!!.02}
    end;                                                                 {!!.02}
  end else
    raise Exception.Create('No ComPort Component Assigned');
end;

procedure TApdCustomModemPager.DoOpenPort;
begin
  if not(Assigned (FPort)) then                                          {!!.02}
    Exit;                                                                {!!.02}
  if not FPort.Open then                                                 {!!.02}
    if Assigned(FTapiDev) then begin                                     {!!.02}
      FTapiDev.ConfigAndOpen;                                            {!!.02}
      FPort.TapiMode := tmOn                                             {!!.02}
    end else                                                             {!!.02}
      FPort.Open := True;
  DelayTicks(STD_DELAY, True);
  SetPortOpts;                                                           {!!.02}
  DelayTicks(STD_DELAY*2, True);
end;

procedure TApdCustomModemPager.DoDial;
{Dialing Algorithm for Paging}
var
  Error: Boolean;

  procedure Wait(Interval: Integer; Status: TDialingStatus);
  var
    WaitTimer: EventTimer;
    Res : Integer;
  begin
    Waiting := True;
    NewTimer(WaitTimer, Secs2Ticks(Interval));
    DoDialStatus(Status);
    repeat
      Res := SafeYield;
    until Error or FAborted or FCancelled or TimerExpired(WaitTimer) or
          (Res = wm_Quit);
  end;

  procedure DialNumber;
  var
    Res : Integer;

    { Make the appropriate dial prefix }
    procedure MakeDialPrefix;
    var
      S : AnsiString;
    begin
      if BlindDial then begin
      { Make BlindDial prefix }
        if Pos('X', FDialPrefix) > 0 then exit;
        S := AnsiString(Copy(FDialPrefix, 1, Pos('T', FDialPrefix)) + adpgDefBlindInit +
                  Copy(FDialPrefix, Pos('T', FDialPrefix), Length(FDialPrefix)));
        FPort.Output := S + FPhoneNumber + cCR;                          {!!.05}
      end else
      begin
      { Normal prefix dial }
        FPort.Output := FDialPrefix + FPhoneNumber + cCR;                {!!.05}
      end;
    end;
  begin
    if FDialAttempt > 1 then
      DoDialStatus(dsRedialing)
    else
      DoDialStatus(dsDialing);

    mpGotOkay := False;
    if Assigned(FPort) and FPort.Open then
      FPort.Output := FModemInit + cCR;                                  {!!.05}
    AddInitModemDataTrigs;
    repeat
      Res := SafeYield;
    until mpGotOkay or FAborted or FCancelled or (Res = wm_Quit)
          or FSent;                                                      {!!.04}

    if not mpGotOkay then
      exit;

    { modify the dial command and dial }
    MakeDialPrefix;
    repeat
      Res := SafeYield;
    until FConnected or FAborted or FCancelled or (Res = wm_Quit);

    if FConnected then
      DoDialStatus(dsConnected);

    if FDialError = deLineBusy then begin
      FFailReason := 'Line Busy';
      Error := True;
    end else begin
      if (not FConnected) and FAbortNoConnect then begin
        FAborted := True;
        FFailReason := 'Unable to Complete Connection';
      end;
    end;
  end;

begin
  DoOpenPort;

  FDialAttempt := 1;
  FSent := False;
  InitCallStateFlags;

  DoStartCall;
  Error := False;
  FCancelled := False;
  FAborted := False;

  while
    (not FSent) and
    (not FCancelled) and
    (not FAborted) and
    (FDialAttempt <= FDialAttempts)
  do begin

    { go off hook}
    DelayTicks(STD_DELAY * 4, True);

    if (FDialError = deNoDialTone) then
      case FBlindDial of
        False: begin
          Error := True;
          FFailReason := 'No Dial Tone';
        end;
        True:  DialNumber
      end
    else { got dial tone }
      if not FConnected then                                             {!!.05}
        DialNumber;

    if Error then
      FAborted := ExitOnError;
    if FCancelled or FAborted then
      TerminatePage                                                      {!!.02}
    else begin
      if (FDialAttempt < FDialAttempts) and Error then begin             {!!.04}
        Wait(FDialRetryWait, dsWaitingToRedial);                         {!!.02}
        Error := False;                                                  {!!.04}
      end;                                                               {!!.04}
      Inc(FDialAttempt);
    end;
  end;

  if not FSent then
    DoFailedToSend
  else
    WriteToEventLog(FormatLogEntry(FPageMode, PagerID, PhoneNumber, EmptyAnsiStr, pcDone));
end;

{ rewritten to use TApdDataPacket.WaitForString !!.04 }
procedure TApdCustomModemPager.TerminatePage;                            {!!.04}
// This procedure is called when not using TAPI
var
  TheCommand : AnsiString;
  FPacket : TApdDataPacket;
  Data: AnsiString;
begin
{ this is a 'when all else fails' method to terminate the connection, }
{ the server is supposed to disconnect when it sends its final ACK }
  if DirectToPort or
     not FPort.Open or
     not FPort.DCD then
    exit;

  FPacket := nil;

  if FPort.TapiMode = tmOn then begin
    FTapiDev.CancelCall;
    Exit;
  end;

  try
    TheCommand := '';
    FPacket := TApdDataPacket.Create(Self);
    FPacket.StartString := 'OK';
    FPacket.StartCond := scString;
    FPacket.ComPort := FPort;
    FPacket.Timeout := 91; { 5 second timeout }

    {assume ModemHangup = '+++~~~ATH' }
    TheCommand := ModemHangup;

    if Pos('+++', TheCommand) = 1 then begin
      FPort.Output := '+++';
      FPacket.WaitForString(Data); { ignoring the result }
      TheCommand := Copy(TheCommand, 4, Length(TheCommand)); {remove the escape}
      { assume TheCommand = '~~~ATH' }
    end;

    while (Length(TheCommand) > 1) and (TheCommand[1] = '~') do
      TheCommand := Copy(TheCommand, 2, Length(TheCommand));  { remove any tildas }
    { assume TheCommand = 'ATH' }

    { append a CR if needed }
    if Pos(#13, ModemHangup) <> Length(ModemHangup) - 2 then
      TheCommand := TheCommand + #13;
    { assume TheCommand = 'ATH'#13 }
    FPort.Output := TheCommand;
    FPacket.WaitForString(Data);
    { we should be hung up by now, lower DTR just in case }
    FPort.DTR := False;

  finally
    FPacket.Free;
  end;
end;

procedure TApdCustomModemPager.DoFailedToSend;
begin
  DoDialStatus(dsMsgNotSent);
  WriteToEventLog(FormatLogEntry(FPageMode, PagerID, PhoneNumber,
    FFailReason, pcError));
end;

procedure TApdCustomModemPager.DoDialStatus(Event: TDialingCondition);
begin
  case Event of
    {TDialingStatus} dsNone..dsCleanup: begin
      FDialStatus := Event;
      if Assigned(FOnDialStatus) then
        FOnDialStatus(self,Event);
    end;

    {TDialError} deNone..deNoConnection: begin
      FDialError := Event;
      if Assigned(FOnDialError) then
        FOnDialError(self,Event);
    end;
  end;
end;

procedure TApdCustomModemPager.DoStartCall;
begin
  { Do Nothing for now }
end;


procedure TApdCustomModemPager.SetTapiDev(const Value: TApdTapiDevice);
begin
  FTapiDev := Value;
  if Assigned(FTapiDev) then begin
    if Assigned(FPort) then begin
      FTapiDev.ComPort := FPort;
      if FUseTapi then
        FPort.TapiMode := tmOn;
    end;
    FTapiDev.EnableVoice := False;
  end;
end;

function TApdCustomModemPager.GetTapiDev: TApdTapiDevice;
begin
  Result := FTapiDev;
end;

procedure TApdCustomModemPager.InitCallStateFlags;
begin
  FAborted    := False;
  FCancelled  := False;
  FConnected  := False;
  FDialStatus := dsNone;
  FDialError  := deNone;
end;


procedure TApdCustomModemPager.InitProperties;
begin
  FDirectToPort := False;
  FAbortNoConnect := adpgDefAbortNoConnect;
  FExitOnError    := adpgDefExitOnError;
  FDialAttempts   := adpgDefDialAttempts;
  FDialRetryWait  := adpgDefDialRetryWait;
  FDialWait       := adpgDefDialWait;
  FBlindDial    := adpgDefBlindDial;
  FToneDial     := adpgDefToneDial;

  DialPrefix := 'AT' + adpgToneDialPrefix;
  ModemHangup := adpgDefModemHangupCmd;
  ModemInit := adpgDefModemInitCmd;
  FUseTapi    := False;
end;

procedure TApdCustomModemPager.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    DoInitializePort;
  end;
  InitCallStateFlags;
end;

procedure TApdCustomModemPager.SetBlindDial(BlindDialVal: Boolean);
begin
  FBlindDial := BlindDialVal;
end;

procedure TApdCustomModemPager.SetDialPrefix(CmdStr: TCmdString);
begin
  if FDialPrefix <> CmdStr then
  begin
    FDialPrefix := CmdStr;
  end;
end;

procedure TApdCustomModemPager.SetModemHangup(CmdStr: TCmdString);
var
  I : Integer;                                                           {!!.02}
  StripM : Boolean;                                                      {!!.02}
begin
  Stripm := False;                                                       {!!.02}
  for I := 1 to Length(CmdStr) do begin                                  {!!.02}
    if CmdStr[I] = '^' then                                              {!!.02}
      StripM := True;                                                    {!!.02}
  end;                                                                   {!!.02}
  if StripM then                                                         {!!.02}
    CmdStr := Copy(CmdStr, 1, Pos('^',CmdStr) - 1);                      {!!.02}
  if FModemHangup <> CmdStr then begin
    FModemHangup := CmdStr;
  end;
end;

procedure TApdCustomModemPager.SetModemInit(CmdStr: TCmdString);
var
  I : Integer;                                                           {!!.02}
  StripM : Boolean;                                                      {!!.02}
begin
  Stripm := False;                                                       {!!.02}
  for I := 1 to Length(CmdStr) do begin                                  {!!.02}
    if CmdStr[I] = '^' then                                              {!!.02}
      StripM := True;                                                    {!!.02}
  end;                                                                   {!!.02}
  if StripM then                                                         {!!.02}
    CmdStr := Copy(CmdStr, 1, Pos('^',CmdStr) - 1);                      {!!.02}
  if FModemInit <> CmdStr then begin
    FModemInit := CmdStr;
  end;
end;

function TApdCustomModemPager.GetPort : TApdCustomComPort;
begin
  Result := FPort;
end;

procedure TApdCustomModemPager.SetPort(ThePort: TApdCustomComPort);
begin
  FPort := ThePort;
end;

procedure TApdCustomModemPager.SetPortOpts;
begin
  FPort.Parity := pEven;
  FPort.DataBits := 7;
  FPort.StopBits := 1;
end;

procedure TApdCustomModemPager.SetToneDial(ToneDial: Boolean);
var
  P : Integer;
begin
  if FToneDial <> ToneDial then begin
    FToneDial := ToneDial;

    case FToneDial of
      True: begin
        P := Pos(adpgPulseDialPrefix, DialPrefix);
        if P > 0 then begin
          Delete(FDialPrefix, P, 2);
          Insert(adpgToneDialPrefix, FDialPrefix, P);
        end
        else
          DialPrefix := DialPrefix + adpgToneDialPrefix;
      end;

      False: begin
        P := Pos(adpgToneDialPrefix, DialPrefix);
        if P > 0 then begin
          Delete(FDialPrefix, P, 2);
          Insert(adpgPulseDialPrefix, FDialPrefix, P);
        end
        else
          DialPrefix := DialPrefix + adpgPulseDialPrefix;
      end;
    end;
  end;
end;
 
procedure TApdCustomModemPager.DoDirect;
begin
  {override for speicalized features }
end;

procedure TApdTAPPager.Send;
begin
  if FDirectToPort then begin
    DoDirect;
  end else
    DoDial;
end;

function TApdCustomModemPager.DialStatusMsg(
  Status: TDialingCondition): AnsiString;
begin
  case Status of
    {TDialingStatus} dsNone..dsCleanup:
      Result := AproLoadAnsiStr(Ord(Status) + STRRES_DIAL_STATUS);
    {TDialError} deNone..deNoConnection:
      Result := AproLoadAnsiStr(Ord(Status) + STRRES_DIAL_ERROR);
  end;
end;

procedure TApdCustomModemPager.AddInitModemDataTrigs;
begin
  OKTrig := FPort.AddDataTrigger(FapOKTrig, True);
  ErrorTrig := FPort.AddDataTrigger(FapErrorTrig, True);
  ConnectTrig := FPort.AddDataTrigger(FapConnectTrig, True);
  BusyTrig := FPort.AddDataTrigger(FapBusyTrig, True);
  VoiceTrig := FPort.AddDataTrigger(FapVoiceTrig, True);
  NoCarrierTrig := FPort.AddDataTrigger(FapNoCarrierTrig, True);
  NoDialtoneTrig := FPort.AddDataTrigger(FapNoDialtoneTrig, True);
end;


procedure TApdCustomModemPager.SetUseTapi(const Value: Boolean);
begin
  FUseTapi := Value;
  case FUseTapi of
    True:  FPort.TapiMode := tmOn;
    False: FPort.TapiMode := tmOff;
  end;
end;

procedure TApdCustomModemPager.Notification(AComponent: TComponent;      {!!.02}
  Operation: TOperation);                                                {!!.02}
begin                                                                    {!!.02}
  inherited Notification(AComponent, Operation);                         {!!.02}
  if Operation = opRemove then begin                                     {!!.02}
    if AComponent = FTapiDev then                                        {!!.02}
      FTapiDev := nil;                                                   {!!.02}
  end else begin                                                         {!!.02}
    if (AComponent is TApdTapiDevice) and (FTapiDev = nil) then          {!!.02}
      FTapiDev := TApdTapiDevice(AComponent);                            {!!.02}
  end;                                                                   {!!.02}
end;                                                                     {!!.02}

{ TApdTAPPager }

function SumChars(const S: AnsiString): Integer;
{sum ASCII values of chars in string (for checksum)}
var
  Ct,CurChar: Integer;
begin
  Result := 0;
  for Ct := 1 to Length(S) do begin
    CurChar := Ord(S[Ct]);
    CurChar := CurChar - (Trunc(CurChar/128) * 128);
    Result := Result + CurChar;
  end;
end;

function CheckSum(N: Integer): AnsiString;
var
  Sum, nTemp: Integer;
  Chr1,Chr2,Chr3: AnsiChar;
begin
  Sum := N;

  nTemp := Sum and $000F; {LS 4 bit}
  Chr3  := AnsiChar(nTemp + $30);

  nTemp := Sum and $00F0; {MS 4 bits of lowbyte}
  nTemp := nTemp shr 4;
  Chr2  := AnsiChar(nTemp + $30);

  nTemp := Sum and $0F00;    {LS 4 bits of hibyte}
  nTemp := nTemp shr 8;
  Chr1  := AnsiChar(nTemp + $30);

  Result := Chr1 + Chr2 + Chr3;
end;

function CheckSumUni(N: Integer): string;
begin
  Result := string(CheckSum(N));
end;

function BuildTAPCtrlChar(C: AnsiChar): AnsiString;
{add "SUB" character + C shifted up by 64 chars (^A -> "A")}
begin
  Result := AnsiString(cSub + Chr(Ord(c) + $40));
end;

function MakeCtrlChar(const S: AnsiString): Ansichar;
{convert string of the form "#nnn" or "^l" into
equivalent ASCII control character}
begin
  case S[1] of
    '#':begin
      Result := AnsiChar(StrToInt(Copy(S, 2,Length(S)-1)));
    end;

    '^': begin
      Result := AnsiChar(Ord(S[2]) - $40);
    end;

  else
    Result := S[1];
  end; {case}
end;

function ProcessCtrlChars(const S: AnsiString; Strip: Boolean): AnsiString;
var
  Start, Tail, Ctl: AnsiString;
  P,i: Integer;
  C: AnsiChar;

begin
  Start := '';
  Tail  := S;

  {find all "#nnn" escapes}
  P := Pos('#', Tail);

  while P > 0 do begin

    if Tail[P+1] = '#' then begin
      Start := Start + Copy (Tail, 1, P);    { copy past '#' }
      Tail  := Copy (Tail, P + 2, Length (Tail) - P);
    end else if not(Tail[P+1] in ['0'..'9','$']) then begin
      Start := Start + Copy(Tail,1,P);    { copy past '#' }
      Tail  := Copy(Tail,P+1,Length(Tail)-P);
    end
    else begin
      Start := Start + Copy(Tail,1,P-1);  { copy up to '#' }


      i := 1;

      if Tail[P+1] = '$' then begin {it's in hex format}
        Inc(i); { count "$" }
        while (UpCase(Tail[P+i]) in ['0'..'9', 'A'..'F']) and (i <= 3) do
          Inc(i);
      end

      else { decimal format }
        while (Tail[P+i] in ['0'..'9']) and (i <= 3) do
          Inc(i); { count digits}

      Ctl  := Copy(Tail,P,i);  { extract '#nnn' control char string }
      C := MakeCtrlChar(Ctl);
      Tail := Copy(Tail,P+i,Length(Tail)); { get rest of string }

      if not (C in [#0..#31,#127]) then begin  { ignore anything not in range }
        Start := Start + Ctl;
      end
      else begin
        if not Strip then begin
          Start :=
            Start + BuildTAPCtrlChar(C); { convert '#nnn' to char add to Start }
        end
        else begin

          {** DO NOTHING **}; {eliminate "#nnn" string by leaving Start alone}

        end;
      end;
    end;

    P := Pos('#', Tail);
  end;

  Tail := Start + Tail;  { concat whatever's left of Tail}

  { find all "^l" style escapes}
  P := Pos('^', Tail);
  Start := '';

  while P > 0 do begin

    if not(UpCase(Tail[P+1]) in ['@', 'A'..'Z','[', '\', ']', '^', '_']) then
    begin
      Start := Start + Copy(Tail,1,P);    { copy past '^' }
      Tail  := Copy(Tail,P+1,Length(Tail)-P);
    end
    else begin {legitimate Control char}
      Start := Start + Copy(Tail,1,P-1);  { copy up to '^' }

      if Strip then begin  { eliminate "^l" string }
        Tail := Copy(Tail,P+2,Length(Tail)); { get rest of string }
      end

      else begin
        Ctl  := Copy(Tail,P,2);  { extract "^l" control char string }
        Tail := Copy(Tail,P+2,Length(Tail)-2); { get rest of string }
        Start := Start +
          BuildTAPCtrlChar(MakeCtrlChar(Ctl)); { convert "^l" to char add to Start }
      end;
    end;

    P := Pos('^', Tail);
  end;

  Result := Start + Tail;
end;

function ExpandCtrlChars(const S: AnsiString): AnsiString; overload;
begin
  Result := ProcessCtrlChars(S, False);
end;

function ExpandCtrlChars(const S: string): AnsiString; overload;
begin
  Result := ProcessCtrlChars(AnsiString(S), False);
end;

function StripCtrlChars(const S: AnsiString): AnsiString; overload;
begin
  Result := ProcessCtrlChars(S, True);
end;

function StripCtrlChars(const S: string): AnsiString; overload;
begin
  Result := ProcessCtrlChars(AnsiString(S), True);
end;

procedure BuildTapMessages
  (
  const ID:AnsiString;
  {in}  Msg:TStrings;
  const UseEscapes: Boolean;
  const MaxLen: Integer;
  {out} Blocks: TStrings);
var
  OutMsg: TAdStr;
  Ct: Integer;
  EOMsg: Boolean;
  MsgPtr : PChar;
begin
  Blocks.Clear;

  { build long message from string list }
  MsgPtr := Msg.GetText;
  OutMsg := TAdStr.Create(StrLen(MsgPtr)*2);
  StrDispose(MsgPtr);
  OutMsg.Clear;

  for Ct := 0 to Pred(Msg.Count) do begin
    if UseEscapes then
      OutMsg.Append(ExpandCtrlChars(Msg[Ct]))
    else
      OutMsg.Append(StripCtrlChars(Msg[Ct]));
  end;

  { Add header and trailer }
  OutMsg.PrePend(cStx + ID + cCr);
  OutMsg.Append(cCr);
  { start counting at beginning of string }
  Ct  := 1;

  EOMsg := False;
  while not EOMsg do begin
    { Block full and not end of message }
    if (Ct = MaxLen) and (Ct <= OutMsg.Len) then begin  { reached block length }

      if OutMsg[Ct-1] = cCr then begin
        {at end of field: insert <ETB> + CheckSum + <CR> }
        OutMsg.Insert(cEtb, Ct);
        Inc(Ct);
        OutMsg.Insert(CheckSum(SumChars(OutMsg.CopyAnsi(1,Ct-1))) + cCr, Ct);
      end

      else begin
      {inside a field: insert <US> + CheckSum + <CR>}
        OutMsg.Insert(cUs, Ct);
        Inc(Ct);
        OutMsg.Insert(CheckSum(SumChars(OutMsg.CopyAnsi(1,Ct-1))) + cCr, Ct);
      end;

      { save block into block list }
      Inc(Ct, 3);  {move to end of block}
      Blocks.Add(OutMsg.Copy(1,Ct));

      { and start new block }
      OutMsg.Delete(1,Ct); { start new block }
      OutMsg.PrePend(cStx);
      Ct := 1;
    end

    { End of message }
    else if Ct = OutMsg.Len then begin
    { at end of message: append <ETX> + CheckSum + <CR> }
      OutMsg.Append(cEtx);
      Inc(Ct);
      Blocks.Add(OutMsg.Copy(1,Ct) + CheckSumUni(SumChars(OutMsg.CopyAnsi(1,Ct))) + cCr);
      EOMsg := True;
    end

    { counting chars }
    else begin
      Inc(Ct);
    end;
  end;
  OutMsg.Free;
end;

constructor TApdTAPPager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBlocks := TStringList.Create;
  FPageMode := 'TAP';
  FFailReason := '';
  tpPingTimer := TTimer.Create(nil);
  tpPingTimer.Enabled := False;
  tpPingTimer.Interval := 2000;
  tpPingTimer.OnTimer := PingTimerOnTimer;
end;

destructor TApdTAPPager.Destroy;
begin
  FBlocks.Free;
  tpPingTimer.Free;
  inherited Destroy;
end;

procedure TApdTAPPager.DoStartCall;
begin
  tpPingCount := 0; 
  if not DirectToPort then
    inherited DoStartCall;
  WriteToEventLog(FormatLogEntry(FPageMode, PagerID, PhoneNumber,
    FFailReason, pcStart));
  FPort.Dispatcher.RegisterEventTriggerHandler(DataTriggerHandler);
end;

procedure TApdTAPPager.DoFirstMessageBlock;
begin
  if Assigned(FPort) then begin
    BuildTapMessages(FPagerID,FMessage,FUseEscapes,FMaxMsgLen,FBlocks);
    FMsgIdx := 0;
    tpTAPRetries := 0;
    DoCurMessageBlock;
  end;
end;

procedure TApdTAPPager.DoCurMessageBlock;
begin
  DoTAPStatus(psSendingMsg);
  Inc(tpTAPRetries);
  FPort.OutputUni := FBlocks[FMsgIdx];
end;

procedure TApdTAPPager.DoNextMessageBlock;
begin
  Inc(FMsgIdx);
  tpTAPRetries := 0;
  DoCurMessageBlock;
end;

procedure TApdTAPPager.ReSend;
begin
  DoFirstMessageBlock;
end;


procedure TApdTAPPager.PingTimerOnTimer(Sender: TObject);
begin
  if Port.Open and (Port.OutBuffFree > 0) then begin
    Port.Output := cCr;
  end;
  Inc(tpPingCount, 2);
  if tpPingCount > FTapWait then begin
    tpPingTimer.Enabled := False;
    DoTAPStatus(psLoginFail);
    FreeLoginTriggers;
    TerminatePage;                                                       {!!.02}
    DoDialStatus(dsCancelling);
    DelayTicks(STD_DELAY * 2, True);
    FAborted := True;
  end;
end;

procedure TApdTAPPager.StartPingTimer;
begin
  {if Port.OutBuffFree > 0 then
    Port.Output := cCr; }                                                {!!.04}
  tpPingTimer.Enabled := True;
end;

procedure TApdTAPPager.DonePingTimer;
begin
  if Assigned(tpPingTimer) then begin
    tpPingTimer.Enabled := False;
  end;
end;

procedure TApdTAPPager.DoTAPStatus(Status: TTapStatus);
begin
  FPageStatus := Status;
  if Assigned(FOnTAPStatus) then
    FOnTAPStatus(self, Status);
end;

{ trigger management }
function TApdTAPPager.HandleToTrigger(TriggerHandle:Word): AnsiString;
begin
  if TriggerHandle      = 0 then Result := 'Null Trigger'
  else if TriggerHandle = FtrgIDPrompt  then  Result := 'FtrgIDPrompt'
  else if TriggerHandle = FtrgLoginSucc then  Result := 'FtrgLoginSucc'
  else if TriggerHandle = FtrgLoginFail then  Result := 'FtrgLoginFail'
  else if TriggerHandle = FtrgLoginErr  then  Result := 'FtrgLoginErr'
  else if TriggerHandle = FtrgOkToSend  then  Result := 'FtrgOkToSend'
  else if TriggerHandle = FtrgMsgAck    then  Result := 'FtrgMsgAck'
  else if TriggerHandle = FtrgMsgNak    then  Result := 'FtrgMsgNak'
  else if TriggerHandle = FtrgMsgRs     then  Result := 'FtrgMsgRs'
  else if TriggerHandle = FtrgDCon      then  Result := 'FtrgDCon'
  else Result := 'Unknown Trigger: ' + AdAnsiStrings.IntToStr(TriggerHandle);
end;

function TApdTAPPager.HandleToTriggerUni(TriggerHandle: Word): string;
begin
  Result := string(HandleToTrigger(TriggerHandle));
end;

procedure TApdTAPPager.InitLoginTriggers;
begin
  FtrgIDPrompt  := FPort.AddDataTrigger(TAP_ID_PROMPT,    False);
  FtrgLoginSucc := FPort.AddDataTrigger(TAP_LOGIN_ACK,    False);
  FtrgLoginFail := FPort.AddDataTrigger(TAP_LOGIN_FAIL,   False);
  FtrgLoginErr  := FPort.AddDataTrigger(TAP_LOGIN_NAK,    False);
end;

procedure TApdTAPPager.FreeLoginTriggers;
begin
  FreeTrigger(FPort,FtrgIDPrompt,  HandleToTrigger(FtrgIDPrompt));
  FreeTrigger(FPort,FtrgLoginSucc, HandleToTrigger(FtrgLoginSucc));
  FreeTrigger(FPort,FtrgLoginErr,  HandleToTrigger(FtrgLoginErr));
  FreeTrigger(FPort,FtrgLoginFail, HandleToTrigger(FtrgLoginFail));
end;

procedure TApdTAPPager.InitLogoutTriggers;
begin
  FtrgDCon := FPort.AddDataTrigger(TAP_DISCONNECT, False);
end;

procedure TApdTAPPager.FreeLogoutTriggers;
begin
    FreeTrigger(FPort, FtrgDCon, HandleToTrigger(FtrgDCon));
end;

procedure TApdTAPPager.InitMsgTriggers;
begin
  FtrgOkToSend  := FPort.AddDataTrigger(TAP_MSG_OKTOSEND, False);
  FtrgMsgAck    := FPort.AddDataTrigger(TAP_MSG_ACK, True);
  FtrgMsgNak    := FPort.AddDataTrigger(TAP_MSG_NAK, True);
  FtrgMsgRs     := FPort.AddDataTrigger(TAP_MSG_RS,  True);
end;

procedure TApdTAPPager.FreeResponseTriggers;
begin
    FreeTrigger(FPort, OKTrig, FapOKTrig);
    FreeTrigger(FPort, ErrorTrig, FapErrorTrig);
    FreeTrigger(FPort, ConnectTrig, FapConnectTrig);
    FreeTrigger(FPort, BusyTrig, FapBusyTrig);
    FreeTrigger(FPort, VoiceTrig, FapVoiceTrig);
    FreeTrigger(FPort, NoCarrierTrig, FapNoCarrierTrig);
    FreeTrigger(FPort, NoDialtoneTrig, FapNoDialtoneTrig);
    FPort.SetTimerTrigger(FtrgSendTimer, 0, False);                      {!!.04}
    FPort.RemoveTrigger(FtrgSendTimer);                                  {!!.04}
    FtrgSendTimer := 0;                                                  {!!.05}
end;

procedure TApdTAPPager.FreeMsgTriggers;
begin
  FreeTrigger(FPort,FtrgOkToSend, HandleToTrigger(FtrgOkToSend));
  FreeTrigger(FPort,FtrgMsgAck,   HandleToTrigger(FtrgMsgAck));
  FreeTrigger(FPort,FtrgMsgNak,   HandleToTrigger(FtrgMsgNak));
  FreeTrigger(FPort,FtrgMsgRs,    HandleToTrigger(FtrgMsgRs));
end;

procedure TApdTAPPager.DataTriggerHandler(Msg, wParam: Cardinal; lParam: Integer);
var
  Done : Boolean;
  I : Integer;
begin
  if csDestroying in ComponentState then
    Exit;
  if Msg = APW_TRIGGERAVAIL then begin
    for I := 1 to wParam do
      FPort.GetChar;
    Exit;
  end;
  
  { Send had no response back }
  if (Msg = APW_TRIGGERTIMER) and (wParam = FtrgSendTimer) then begin    {!!.04}
    DoTAPStatus(psSendTimedOut);                                         {!!.04}
    if FMsgIdx < Pred(FBlocks.Count) then begin                          {!!.04}
      DoNextMessageBlock;                                                {!!.04}
    end                                                                  {!!.04}
  end;                                                                   {!!.04}


  if (Msg = APW_TRIGGERDATA) and (wParam <> 0) then begin
    if FtrgSendTimer = 0 then                                            {!!.04}
      FtrgSendTimer := FPort.AddTimerTrigger;                            {!!.04}
    FPort.SetTimerTrigger(FtrgSendTimer, adpgDefTimerTrig, True);        {!!.04}

    try
      if wParam = OKTrig then
        mpGotOkay := True
      else if wParam = ErrorTrig then begin
        FConnected := False;
        FCancelled := True;
        FAborted := True;
        Waiting := False;
      end

      else if wParam = ConnectTrig then begin
        FConnected := True;
        Waiting := False;
        DoDialStatus(dsConnected);
        InitLoginTriggers;
        StartPingTimer;
      end

      else if wParam = BusyTrig then begin
        FConnected := False;
        Waiting := False;
        DoDialStatus(deLineBusy);
      end

      else if wParam = VoiceTrig then begin

      end

      else if wParam = NoCarrierTrig then begin
        FConnected := False;
        FCancelled := True;
        Waiting := False;
        DoDialStatus(dsDisconnect);
      end

      else if wParam = NoDialtoneTrig then begin
        FConnected := False;
        Waiting := False;
        DoDialStatus(deNoDialTone);
      end

      else if wParam = FtrgIDPrompt then begin       { got login prompt }
        DonePingTimer;
        DoTAPStatus(psLoginPrompt);
        if FPassword <> '' then
          FPort.Output := TAP_AUTO_LOGIN + FPassword + cCr
        else
          FPort.Output := TAP_AUTO_LOGIN + cCr;

        FreeTrigger(FPort,FtrgIDPrompt,  HandleToTrigger(FtrgIDPrompt));
      end

      else if wParam = FtrgLoginSucc then begin { login accept }
        DoTAPStatus(psLoggedIn);
        FreeLoginTriggers;
        InitMsgTriggers;
      end

      else if wParam = FtrgLoginFail then begin { login failure }
        DoTAPStatus(psLoginFail);
        FreeLoginTriggers;
        InitLogoutTriggers;
        TerminatePage;                                                   {!!.02}
        DoDialStatus(dsCancelling);
        DelayTicks(STD_DELAY * 2, True);
        FAborted := True;
      end

      else if wParam = FtrgLoginErr then begin  { login error }
        DoTAPStatus(psLoginErr);
        FreeLoginTriggers;
        InitLogoutTriggers;
        TerminatePage;                                                   {!!.02}
        DoDialStatus(dsCancelling);
        DelayTicks(STD_DELAY * 2, True);
        FAborted := True;
      end

      else if wParam = FtrgOkToSend then begin  { okay to start sending message }
        DoTAPStatus(psMsgOkToSend);
        DoFirstMessageBlock;
      end

      else if wParam = FtrgMsgAck then begin
      { receipt okay, send next block or end if no more }
        DoTAPStatus(psMsgAck);
        if FMsgIdx < Pred(FBlocks.Count) then begin
          DoNextMessageBlock;
        end
        else begin
          DoTAPStatus(psMsgCompleted);
          Done := True;                                                  {!!.02}

          if Assigned(FOnGetNextMessage) then begin
            OnGetNextMessage(self, Done);
            if not Done then begin
              DoFirstMessageBlock;
              Exit;
            end;
          end;

          FSent := True;
          FreeMsgTriggers;
          InitLogoutTriggers;
          TerminatePage;                                                 {!!.02}
          DoDialStatus(dsCancelling);
          DelayTicks(STD_DELAY * 2, True);
        end;
      end

      else if wParam = FtrgMsgNak then begin    { recept error, resend message }
        DoTAPStatus(psMsgNak);
        if tpTapRetries < MAX_TAP_RETRIES then
          DoCurMessageBlock
        else
          TerminatePage                                                  {!!.02}
      end

      else if wParam = FtrgMsgRs then begin     { unable to send page }
        DoTAPStatus(psMsgRs);
        if FMsgIdx < Pred(FBlocks.Count) then begin                      {!!.02}
          DoNextMessageBlock;                                            {!!.02}
        end else begin                                                   {!!.02}
          Done := True;                                                  {!!.02}
          if Assigned(FOnGetNextMessage) then begin                      {!!.02}
            OnGetNextMessage(self, Done);                                {!!.02}
            if not Done then begin                                       {!!.02}
              DoFirstMessageBlock;                                       {!!.02}
              Exit;                                                      {!!.02}
            end;                                                         {!!.02}
          end else                                                       {!!.02}
            TerminatePage;                                               {!!.02}
        end;                                                             {!!.02}
      end

      else if wParam = FtrgDCon then begin      { logging out of paging server }
        FreeLogoutTriggers;
        FreeResponseTriggers;                                            {!!.02}

        if Assigned(FTapiDev) then begin                                 {!!.02}
          FPort.Dispatcher.DeregisterEventTriggerHandler
                              (DataTriggerHandler);                      {!!.02}
          FTapiDev.CancelCall                                            {!!.02}
        end else begin                                                   {!!.02}
          if FPort.DCD then                                              {!!.04}
            inherited TerminatePage;                                     {!!.02}
          FPort.Dispatcher.DeregisterEventTriggerHandler
                              (DataTriggerHandler);                      {!!.02}
          if FPort.Open and not DirectToPort then                        {!!.02}
            FPort.Open := False;                                         {!!.02}

        end;                                                             {!!.02}
        if Assigned(FOnTAPFinish) then                                   {!!.02}
          FOnTAPFinish(self);                                            {!!.02}
        DoTAPStatus(psDone);
      end;

    except

      on EBadTriggerHandle do
        ShowMessage('Bad Trigger: ' + HandleToTriggerUni(wParam));
    end;
  end;

  if FAborted then begin
    DonePingTimer;
    TerminatePage;                                                       {!!.02}
  end;
end;

procedure TApdTAPPager.InitProperties;
begin
  inherited InitProperties;
  FTapWait := 30;
  FPassword := '';
  FMaxMsgLen  := MAX_MSG_LEN;
  FUseEscapes := False;
end;

procedure TApdTAPPager.SetPort(ThePort: TApdCustomComPort);
begin
  inherited SetPort(ThePort);
end;

function TApdTAPPager.TAPStatusMsg(Status: TTAPStatus): AnsiString;
begin
  case Status of
    {TTAPStatus} psNone..psDone: Result := AproLoadAnsiStr(Ord(Status) + STRRES_TAP_STATUS);
  end;
end;

procedure TApdTAPPager.DoDirect;
begin
  inherited DoDirect;
  DoStartCall;
  InitLoginTriggers;
  DelayTicks(STD_DELAY, True);
  StartPingTimer;
end;

procedure TApdTAPPager.TerminatePage;
begin
  if Assigned(FPort) and FPort.Open then                                 {!!.02}
    FPort.Output := TAP_LOGOUT;                                          {!!.02}
  DelayTicks(36, True);                                                  {!!.04}
end;

procedure TApdTAPPager.Disconnect;
begin
  TerminatePage;                                                         {!!.02}
end;

{ TApdCustomINetPager }

constructor TApdCustomINetPager.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);

  {search our owner for a Winsock port}
  if Assigned(AOwner) and (AOwner.ComponentCount > 0) then
    for I := 0 to Pred(AOwner.ComponentCount) do
      if AOwner.Components[I] is TApdWinsockPort then begin
        SetPort(TApdWinsockPort(AOwner.Components[I]));
        Break;
      end;
end;

function TApdCustomINetPager.GetPort: TApdWinsockPort;
begin
  Result := TApdWinsockPort(FPort);
end;

procedure TApdCustomINetPager.SetPort(ThePort: TApdWinsockPort);
begin
  if FPort <> TApdCustomComPort(ThePort) then
    FPort := TApdCustomComPort(ThePort);
end;

const
  { SNPP server response codes }
  SNPP_RESP_SUCCESS       = '25? ';
  SNPP_RESP_DATAINPUT     = '3?? ';
  SNPP_RESP_FAILTERMINATE = '4?? ';
  SNPP_RESP_FAILCONTINUE  = '5?? ';

  { SNPP v.3 responses, included for completeness, not presently supported }
  SNPP_RESP_2WAYFAIL      = '7?? ';
  SNPP_RESP_2WAYSUCCESS   = '8?? ';
  SNPP_RESP_2WAYQUEUESUCC = '9?? ';

  { SNPP server commands }
  SNPP_CMD_PAGEREQ    = 'PAGE';
  SNPP_CMD_MESSAGE    = 'MESS';
  SNPP_CMD_DATA       = 'DATA';
  SNPP_DATA_TERMINATE = atpCRLF + '.' + atpCRLF;
  SNPP_CMD_RESET      = 'RESE';
  SNPP_CMD_SEND       = 'SEND';
  SNPP_CMD_HELP       = 'HELP';
  SNPP_CMD_QUIT       = 'QUIT';

  { SNPP v.3 commands, included for completeness, not presently supported }
  SNPP_CMD_LOGIN      = 'LOGI';
  SNPP_CMD_LEVEL      = 'LEVE';
  SNPP_CMD_ALERT      = 'ALER';
  SNPP_CMD_COVERAGE   = 'COVE';
  SNPP_CMD_HOLDUNTIL  = 'HOLD';
  SNPP_CMD_CALLERID   = 'CALL';
  SNPP_CMD_SUBJECT    = 'SUBJ';
  SNPP_CMD_2WAY       = '2WAY';
  SNPP_CMD_PING       = 'PING';
  SNPP_CMD_EXPIRETAG  = 'EXPT';
  SNPP_CMD_MSGSTATUS  = 'MSTA';
  SNPP_CMD_NOQUEUEING = 'NOQU';
  SNPP_CMD_ACKREAD    = 'ACKR';
  SNPP_CMD_REPLYTYPE  = 'RTYP';
  SNPP_CMD_MULTRESP   = 'MCRE';
  SNPP_CMD_KILLTAG    = 'KTAG';


{ TApdSNPPPager }

constructor TApdSNPPPager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommDelay := 0;
  FServerInitString := '220';
  FServerDoneString := '221';
  FServerSuccStr         :=   SNPP_RESP_SUCCESS;
  FServerDataInp         :=   SNPP_RESP_DATAINPUT;
  FServerRespFailCont    :=   SNPP_RESP_FAILCONTINUE;
  FServerRespFailTerm    :=   SNPP_RESP_FAILTERMINATE;
  FOkayToSend := False;
  FSessionOpen := False;
  FQuit := False;
  FCancelled := False;

  FPageMode := 'SNPP';
  FFailReason := '';
end;

destructor TApdSNPPPager.Destroy;
begin
  FCancelled := True;
  if Assigned(FPort) then
    FPort.Open := False;
  inherited Destroy;
end;

procedure TApdSNPPPager.DoClose;
begin
end;

procedure TApdSNPPPager.DoStart;
begin
end;

procedure TApdSNPPPager.DoLoginString(Sender: TObject; Data: AnsiString);
begin
  FSessionOpen := True;
  if Assigned(FOnLogin) then
    FOnLogin(self);
end;

procedure TApdSNPPPager.DoServerSucc(Sender: TObject; Data: AnsiString);
var
  Code: Integer;
  Msg: AnsiString;
begin
  FGotSuccess := True;                                                   
  Code := StrToInt(Copy(Data,1,3));
  Msg  := Copy(Data, 5, Length(Data)-4);
  if Assigned(FOnSNPPSuccess) then
    FOnSNPPSuccess(self, Code, Msg);
end;

procedure TApdSNPPPager.DoServerDataMsg(Sender: TObject; Data: AnsiString);
begin
  FOkayToSend := True;
end;

procedure TApdSNPPPager.DoServerError(Sender: TObject; Data: AnsiString);
begin
  FFailReason := 'Minor Error ' + Data;
  if ExitOnError then
    FCancelled := True;
  if Assigned(FOnSNPPError) then
    FOnSNPPError(self, StrToInt(Copy(Data,1,3)), Copy(Data, 5, Length(Data)-4));
end;

procedure TApdSNPPPager.DoServerFatalError(Sender: TObject; Data: AnsiString);
begin
  FFailReason := 'Fatal Error ' + Data;
  FCancelled := True;
  if Assigned(FOnSNPPError) then
    FOnSNPPError(self, StrToInt(Copy(Data,1,3)), Copy(Data, 5, Length(Data)-4));
end;

procedure TApdSNPPPager.DoLogoutString(Sender: TObject; Data: AnsiString);
begin
  FQuit := True;
  if Assigned(FOnLogout) then
    FOnLogout(self);
end;

procedure TApdSNPPPager.MakePacket(ThePacket: TApdDataPacket; StartStr, EndStr: AnsiString;
  HandlerMethod: TStringPacketNotifyEvent);
begin
  ThePacket := TApdDataPacket.Create(self);
  ThePacket.ComPort := FPort;
  ThePacket.StartString := StartStr;
  ThePacket.StartCond := scString;
  ThePacket.EndString := EndStr;
  ThePacket.EndCond := [];
  if EndStr <> '' then
    ThePacket.EndCond := [ecString];
  ThePacket.IncludeStrings := True;
  ThePacket.OnStringPacket := HandlerMethod;
  ThePacket.Enabled := True;
end;

procedure TApdSNPPPager.InitPackets;
begin
  MakePacket(FLoginPacket,            FServerInitString   , ^M, DoLoginString);
  MakePacket(FServerSuccPacket,       FServerSuccStr      , ^M, DoServerSucc);
  MakePacket(FServerDataMsgPacket,    FServerDataInp      , ^M, DoServerDataMsg);
  MakePacket(FServerErrorPacket,      FServerRespFailCont , ^M, DoServerError);
  MakePacket(FServerFatalErrorPacket, FServerRespFailTerm , ^M, DoServerFatalError);
  MakePacket(FServerDonePacket,       FServerDoneString   , ^M, DoLogoutString);
end;

procedure TApdSNPPPager.ReleasePacket(var ThePacket: TApdDataPacket);
var
  TempPacket: TApdDataPacket;
begin
  if Assigned(ThePacket) then
  begin
    TempPacket := ThePacket;
    ThePacket := nil;
    TempPacket.Free;
  end;
end;

procedure TApdSNPPPager.FreePackets;
begin
  ReleasePacket(FLoginPacket);
  ReleasePacket(FServerSuccPacket);
  ReleasePacket(FServerDataMsgPacket);
  ReleasePacket(FServerErrorPacket);
  ReleasePacket(FServerFatalErrorPacket);
  ReleasePacket(FServerDonePacket);
end;

procedure TApdSNPPPager.Send;
begin
  WriteToEventLog(FormatLogEntry(string(FPageMode), string(PagerID), Port.WsAddress + ':' +
    Port.wsPort, '', pcStart));

  FSessionOpen := False;
  FSent := False;                                                        
  FQuit := False;                                                        

  FPort.Open := True;

  DoStart;
  InitPackets;
  repeat
    DelayTicks(STD_DELAY * 2, True);
  until FSessionOpen or FCancelled;

  if not FCancelled then begin                                           
    FGotSuccess := False;                                                
    PutPagerID;
    repeat                                                               
      DelayTicks(STD_DELAY * 2, True);                                   
    until FGotSuccess or FCancelled;                                     
  end;

  if not FCancelled then begin                                           
    FGotSuccess := False;                                                
    PutMessage;
    repeat                                                               
      DelayTicks(STD_DELAY * 2, True);                                   
    until FGotSuccess or FCancelled;                                     
  end;                                                                   

  { FSent := False; }                                                    
  if not FCancelled then begin                                           
    PutSend;
    repeat
      DelayTicks(STD_DELAY * 2, True);
    until FGotSuccess or FCancelled;                                     
  end;                                                                   

  if FGotSuccess then                                                    
    FSent := True;

  { FQuit := False; }                                                    
  if not FCancelled then begin                                           
    PutQuit;
    repeat
      DelayTicks(Secs2Ticks(1), True);
    until FQuit or FCancelled;                                           
  end;

  if FQuit then
    WriteToEventLog(FormatLogEntry(string(FPageMode), string(PagerID), Port.WsAddress + ':' +
      Port.wsPort, '', pcDone))
  else
    WriteToEventLog(FormatLogEntry(FPageMode, PagerID, AnsiString(Port.WsAddress) + AnsiString(':') +
      AnsiString(Port.wsPort), FFailReason, pcError));

  DoClose;
  FreePackets;
end;

procedure TApdSNPPPager.PutString(S: AnsiString);
var
  i: Integer;
begin
  if Assigned(FPort) then
    FPort.Output := S;
  if FCommDelay > 0 then begin
    i := 1;
    repeat
      WriteToEventLog('Output Delay');
      DelayTicks(STD_DELAY * 2, True);
      Inc(i);
    until i > FCommDelay;
  end;
end;

procedure TApdSNPPPager.DoMultiLine;
var
  i: Integer;
begin
  FOkayToSend := False;

  PutString(AnsiString(SNPP_CMD_DATA + ' ' + FMessage[0] + atpCRLF));

  repeat
    WriteToEventLog('Waiting to Output');
    DelayTicks(STD_DELAY * 2, True);
  until FOkayToSend or FCancelled;

  for i := 0 to Pred(FMessage.Count) do
    PutString(AnsiString(FMessage[i] + atpCRLF));
  PutString(SNPP_DATA_TERMINATE);
end;

procedure TApdSNPPPager.PutMessage;
begin
  if FMessage.Count > 1 then
    DoMultiLine
  else
    PutString(AnsiString(SNPP_CMD_MESSAGE + ' ' + FMessage[0] + atpCRLF));
end;

procedure TApdSNPPPager.PutPagerID;
begin
  PutString(SNPP_CMD_PAGEREQ + ' ' + FPagerID + atpCRLF);
end;

procedure TApdSNPPPager.PutQuit;
begin
  PutString(SNPP_CMD_QUIT + atpCRLF);
end;

procedure TApdSNPPPager.PutSend;
begin
  PutString(SNPP_CMD_SEND + atpCRLF);
  { FSent := True; }
end;

procedure TApdSNPPPager.Quit;
begin
  FFailReason := ' Cancel Requested';
  FCancelled := True;
end;


{TApdPagerLog}
procedure TApdPagerLog.Notification(AComponent : TComponent;
                                       Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    {Owned components going away}
    if AComponent = FPager then
      FPager := nil;
  end;
end;

constructor TApdPagerLog.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  {Inits}
  HistoryName := adpgDefPagerHistoryName;
end;

procedure TApdPagerLog.UpdateLog(const LogStr: AnsiString);
  {-Update the standard log}
var
  HisFile : TextFile;

begin
  {Exit if no name specified}
  if FHistoryName = '' then
    Exit;

  {Create or open the history file}
  try
    AssignFile(HisFile, string(FHistoryName));
    Append(HisFile);
  except
    on E : EInOutError do
      if E.ErrorCode = 2 then
        {File not found, open as new}
        Rewrite(HisFile)
      else
        {Unexpected error, forward the exception}
        raise;
  end;

  {Write the log entry}
  WriteLn(HisFile, LogStr);

  Close(HisFile);
  if IOResult <> 0 then ;
end;

end.

