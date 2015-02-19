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
{*                    ADPGR.PAS 4.06                     *}
{*********************************************************}
{* TApdPager component                                   *}
{*********************************************************}

{
  Due to the many little problems with the TApdTAPPager and TApdSNPPPager,
  we rewrote them in the consolidated TApdPager component. Both TAP and
  SNPP are supported in this one component. This should be a lot cleaner,
  easier to maintain, and easier to enhance component than the dedicated
  TAP and SNPP pager components.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdPgr;

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

type
  
  { PortOpts property for TAP }
  TPortOpts = (p7E1, p8N1, pCustom);
  TPortOptsSet = set of TPortOpts;

  { types of PagerMode property options }
  TApdPagerMode = (pmTAP, pmSNPP);
  TPagerModeSet = set of TApdPagerMode;

  { Pager Status }
  TPageStatus = (psNone, psInitFail, psConnected, psLineBusy, psDisconnect,
  psNoDialtone, psMsgNotSent, psWaitingToRedial, psLoginPrompt, psLoggedIn,
  psDialing, psRedialing, psLoginRetry, psMsgOkToSend, psSendingMsg,
  psMsgAck, psMsgNak, psMsgRs, psMsgCompleted, psSendTimedOut, psLoggingOut,
  psDone);


const
  atpCRLF = cCR + cLF;     { carriage return, line feed }
  MAX_MSG_LEN = 80;        { default message length }
  STD_DELAY: Integer = 9;  { wait half a sec.}

  { Default values }
  adpgDefAbortNoConnect = False;
  adpgDefBlindDial      = False;
  adpgDefToneDial       = True;
  adpgDefExitOnError    = False;
  adpgDefUseEscapes     = False;
  adpgDefDialAttempts   = 3;
  adpgDefDialRetryWait  = 30;
  adpgDefTimerTrig      = 1080;
  adpgDefPagerMode      = pmTap;
  adpgDefPortOpts       = p7E1;

  { FTonePrefix options }
  adpgPulseDialPrefix   = 'DP';
  adpgToneDialPrefix    = 'DT';

  { Modem commands }
  adpgDefModemInitCmd   = 'ATZ';
  adpgDefModemHangupCmd = '+++~~~ATH';

    { DataTriggerHandlers for modem response }
  FapOKTrig         : string = 'OK';
  FapErrorTrig      : string = 'ERROR';
  FapConnectTrig    : string = 'CONNECT';
  FapBusyTrig       : string = 'BUSY';
  FapNoCarrierTrig  : string = 'NO CARRIER';
  FapNoDialtoneTrig : string = 'NO DIALTONE';   

type
  { forwards }
  TApdCustomPager = class;

  { Event declarations }
  TPageStatusEvent = procedure(Pager: TApdCustomPager;
                                Event: TPageStatus;
                               Param1: Integer;
                               Param2: Integer) of object;
  TPageErrorEvent = procedure(Pager: TApdCustomPager;
                                Code: Integer) of object;
  TPageFinishEvent = procedure(Pager: TApdCustomPager; Code: Integer; Msg: string)
    of object;
  TTapGetNextMessageEvent = procedure (Pager: TApdCustomPager;
                                   var DoneMessages: Boolean) of object;

  { Undocumented log class. }
  TApdPgrLog = class(TPersistent)
    private
      FOwner : TApdCustomPager;
      FVerboseLog: Boolean;
      FEnabled: Boolean;
      FLogName: string;
    public
      constructor Create(Owner : TApdCustomPager);
      procedure AddLogString(Verbose : Boolean;
                           const StatusString : string);
      procedure ClearLog;
    published
      property LogName : string
        read FLogName write FLogName;
      property VerboseLog : Boolean
        read FVerboseLog write FVerboseLog;
      property Enabled : Boolean
        read FEnabled write FEnabled;
  end;

  { class declaration }
  TApdCustomPager = class(TApdBaseComponent)

  private
    FPort       : TApdCustomComPort;
    FTapiDevice : TApdTapiDevice;
    FOrigTapiConfig: TTapiConfigRec;
    FEventLog   : TApdPgrLog;
    FPagerID    : string;
    FMessage    : TStrings;
    FExitOnError: Boolean;
    FUseEscapes : Boolean;

    FHandle: THandle;

    mpGotOkay,
    FConnected,
    FSent,
    FAborted,
    FRedialFlag,
    FLoginRetry,
    FTerminating,
    FCancelled  : Boolean;

    {property storage fields}
    FAbortNoConnect,
    FBlindDial,
    FToneDial,
    FTapHotLine: Boolean;

    FDialAttempt,
    FDialAttempts: Word;

    FDialPrefix,
    FModemHangup,
    FModemInit: string;

    FPhoneNumber : string;      { phone number to dial }
    FTonePrefix  : string;       { phone tone prefix - FTonePrefix }

    { Modem response data trigger handler fields }
    OKTrig,
    ErrorTrig,
    ConnectTrig,
    BusyTrig,
    NoCarrierTrig,
    NoDialtoneTrig : Word;

        { SNPP private data fields}
    FOkayToSend,
    FSessionOpen,
    FQuit: Boolean;

    FGotSuccess : Boolean;

    FLoginPacket,
    FServerSuccPacket,
    FServerDataMsgPacket,
    FServerErrorPacket,
    FServerFatalErrorPacket,
    FServerDonePacket: TApdDataPacket;

    { TAP private data fields }
    FPassword    : string;

    FMsgBlockList: TStringList;
    FMsgIdx: Integer;

    FtrgIDPrompt,
    FtrgLoginSucc,
    FtrgLoginFail,
    FtrgLoginRetry,
    FtrgOkToSend,
    FtrgMsgAck,
    FtrgMsgNak,
    FtrgMsgRs,
    FtrgSendTimer,
    FtrgDCon: Word;

    tpPingTimer,
    tpModemInitTimer,                                                    {!!.06}
    WaitTimer  : TTimer;
    tpPingCount,
    FTapWait,
    TempWait : Integer;

    { Pager Events }
    FOnPageFinish    : TPageFinishEvent;
    FOnPageStatus    : TPageStatusEvent;
    FOnPageError     : TPageErrorEvent;
    FOnGetNextMessage: TTapGetNextMessageEvent;

    { property storage }
    FServerInitString,
    FServerDoneString,
    FServerSuccStr,
    FServerDataInp,
    FServerRespFailCont,
    FServerRespFailTerm: string;

    FCommDelay: Integer;

    FMaxMessageLength: Integer;
    FPagerMode: TApdPagerMode;
    FPortOpts: TPortOpts;
    FPortOpenedByUser: Boolean;                                          {!!.06}

    FPageMode,
    FLogName: string;


        { TAP }
    procedure DoDial;
    procedure DoInitializePort;
    procedure DoPortOpenCloseEx(CP: TObject; CallbackType : TApdCallbackType);
    procedure InitCallStateFlags;
    procedure SetUseEscapes(UseEscapesVal: Boolean);
    procedure AddInitModemDataTrigs;
    procedure SetPortOpts;
    procedure DoOpenPort;
    procedure BuildTapMessages;
    procedure ModemInitTimerOnTimer(Sender: TObject);                    {!!.06}
    procedure PingTimerOnTimer(Sender: TObject);
    procedure WaitTimerOnTimer(Sender: TObject);
    procedure DoneModemInitTimer;                                        {!!.06}
    procedure DonePingTimer;
    procedure FreeTrigger(Port: TApdCustomComPort;
                       var Trigger: Word);

    { SNPP }
    procedure FreePackets;
    procedure InitPackets;
    procedure DoLoginString(Sender: TObject; Data: AnsiString);
    procedure DoServerSucc(Sender: TObject; Data: AnsiString);
    procedure DoServerDataMsg(Sender: TObject; Data: AnsiString);
    procedure DoServerError(Sender: TObject; Data: AnsiString);
    procedure DoServerFatalError(Sender: TObject; Data: AnsiString);
    procedure DoLogoutString(Sender: TObject; Data: AnsiString);
    procedure PutString(const S: AnsiString);
    procedure DoMultiLine;
    procedure MakePacket(ThePacket: TApdDataPacket; StartStr, EndStr: string;
      HandlerMethod: TStringPacketNotifyEvent);

  protected
    procedure Notification(AComponent: TComponent;
                            Operation: TOperation); override;
    procedure SetMessage(Msg: TStrings);
    procedure SetPagerID(ID: string);

    { Events to Call }
    procedure DoPageStatus(Status: TPageStatus);
    procedure DoPageError(Error: Integer);

    property Handle : THandle read FHandle;
    procedure WndProc(var Message: TMessage);

    { TAP }
    procedure DoStartCall;
    procedure TerminatePage;
    procedure DoFailedToSend;
    procedure LogOutTAP;
    procedure DataTriggerHandler(Msg, wParam: Cardinal; lParam: Integer);
    procedure DoPageStatusTrig(Trig: Cardinal);
    procedure FreeLoginTriggers;
    procedure FreeLogoutTriggers;
    procedure FreeMsgTriggers;
    procedure FreeResponseTriggers;
    procedure InitLoginTriggers;
    procedure InitLogoutTriggers;
    procedure InitMsgTriggers;
    procedure DoCurMessageBlock;
    procedure DoFirstMessageBlock;
    procedure DoNextMessageBlock;

    { SNPP }
    property ServerInitString: string
      read FServerInitString write FServerInitString;
    property ServerSuccessString: string
      read FServerSuccStr write FServerSuccStr;
    property ServerDataInput: string
      read FServerDataInp write FServerDataInp;
    property ServerResponseFailContinue: string
      read FServerRespFailCont write FServerRespFailCont;
    property ServerResponseFailTerminate: string
      read FServerRespFailTerm write FServerRespFailTerm;
    property ServerDoneString: string
      read FServerDoneString write FServerDoneString;

    procedure PutMessage; virtual;
    procedure PutSend; virtual;
    procedure PutQuit; virtual;

  public

    { Message }
    property Message: TStrings
      read FMessage write SetMessage;
    { PagerID }
    property PagerID: string
      read FPagerID write SetPagerID;
    { Exit if an error occurs }
    property ExitOnError: Boolean
      read FExitOnError write FExitOnError;
    { Use Escape sequences }
    property UseEscapes: Boolean
      read FUseEscapes write SetUseEscapes;
    { Port used in AdPgr unit }
    property Port: TApdCustomComPort
      read FPort write FPort;
    { Assigned TAPI device for AdPgr - if any }
    property TapiDevice: TApdTapiDevice
      read FTapiDevice write FTapiDevice;
    { Type of Pager used: pmTAP or pmSNPP }
    property PagerMode: TApdPagerMode
      read FPagerMode write FPagerMode;

    property PortOpts: TPortOpts
      read FPortOpts write FPortOpts;
    property AbortNoConnect: Boolean
      read FAbortNoConnect write FAbortNoConnect;

    property LogName : string
      read FLogName write FLogName;

    property Password : string
      read FPassword write FPassword;

    { constructor }
    constructor Create(AOwner: TComponent); override;
    { Destructor }
    destructor Destroy; override;

    { Both }
    procedure Send;
    { TAP - Disconnect current call}
    procedure Disconnect;
    { TAP - Cancel Call and Terminate }
    procedure CancelCall;
    { Max Dial Attempts }
    property DialAttempts: Word
      read FDialAttempts write FDialAttempts;
    { TAP Phone Number }
    property PhoneNumber: string
      read FPhoneNumber write FPhoneNumber;
    { ToneDial - False for pulse phones }
    property ToneDial: Boolean
      read FToneDial write FToneDial;
    { Modem Initialization string - Default "ATZ" }
    property ModemInit : string
      read FModemInit write FModemInit;
    { Modem Hangup command - default "+++~~~ATH"}
    property ModemHangup : string
      read FModemHangup write FModemHangup;
    { Line always open to TAP server }
    property TapHotLine : Boolean
      read FTapHotLine write FTapHotLine;
    { Dial prefix - i.e. 9, to get an outside line }
    property DialPrefix : string
      read FDialPrefix write FDialPrefix;
    { Blind Dial - }
    property BlindDial : Boolean
      read FBlindDial write FBlindDial;
    { Seconds to redial - default 60 }
    property TapWait : Integer
      read FTapWait write FTapWait;
    { Maximum Message Length per message block }
    property MaxMessageLength: Integer
      read FMaxMessageLength write FMaxMessageLength;
    { SNPP }
    procedure Quit;
    property EventLog: TApdPgrLog
      read FEventLog write FEventLog;

    { events }
    property OnPageStatus : TPageStatusEvent
      read FOnPageStatus write FOnPageStatus;
    property OnPageFinish : TPageFinishEvent
      read FOnPageFinish write FOnPageFinish;
    property OnPageError : TPageErrorEvent
      read FOnPageError write FOnPageError;
    property OnGetNextMessage : TTapGetNextMessageEvent
      read FOnGetNextMessage write FOnGetNextMessage;

  end;

  { types to make the design-time interface easier to use }
  TApdTapProperties = class (TPersistent)
  private
    FOwner : TApdCustomPager;

    function GetTapWait: Integer;
    procedure SetTapWait(const Value: Integer);
    function GetTapiDevice: TApdTapiDevice;
    procedure SetTapiDevice(const Value: TApdTapiDevice);
    function GetModemInit: string;
    procedure SetModemInit(const Value: string);
    function GetModemHangup: string;
    procedure SetModemHangup(const Value: string);
    function GetDialAttempts: Word;
    procedure SetDialAttempts(const Value: Word);
    function GetDialPrefix: string;
    procedure SetDialPrefix(const Value: string);
    function GetTapHotLine: Boolean;
    procedure SetTapHotLine(const Value: Boolean);
    function GetBlindDial: Boolean;
    procedure SetBlindDial(const Value: Boolean);
    function GetToneDial: Boolean;
    procedure SetToneDial(const Value: Boolean);
    function GetMaxMessageLength: Integer;
    procedure SetMaxMessageLength(const Value: Integer);
    function GetPortOpts: TPortOpts;
    procedure SetPortOpts(const Value: TPortOpts);

  public
    constructor Create(Owner : TApdCustomPager);
  published
    property TapWait : Integer
      read GetTapWait write SetTapWait;
    property DialAttempts : Word
      read GetDialAttempts write SetDialAttempts;
    property DialPrefix : string
      read GetDialPrefix write SetDialPrefix;
    property MaxMessageLength : Integer
      read GetMaxMessageLength write SetMaxMessageLength;
    property TapHotLine : Boolean
      read GetTapHotLine write SetTapHotLine;
    property BlindDial : Boolean
      read GetBlindDial write SetBlindDial;
    property ToneDial : Boolean
      read GetToneDial write SetToneDial;
    property TapiDevice : TApdTapiDevice
      read GetTapiDevice write SetTapiDevice;
    property ModemHangup : string
      read GetModemHangup write SetModemHangup;
    property ModemInit : string
      read GetModemInit write SetModemInit;
    property PortOpts : TPortOpts
      read GetPortOpts write SetPortOpts;

  end;

  TApdPager = class(TApdCustomPager)
  private
    FTapProperties: TApdTapProperties;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property Port;
    property PagerID;
    property EventLog;
    property Message;
    property ExitOnError;
    property Name;
    property Password;
    property PagerMode;
    property UseEscapes;

    { Properties only used for TAP messages }
    property TapProperties : TApdTapProperties
      read FTapProperties write FTapProperties;

    { General Events }
    property OnPageError;
    property OnPageStatus;
    property OnPageFinish;
    { TAP }
    property OnGetNextMessage;
  end;

implementation

const
  {TAP server repsonse sequences}
  TAP_ID_PROMPT   : string = 'ID=';
  TAP_LOGIN_ACK   : string = cAck + cCr;
  TAP_LOGIN_NAK   : string = cNak + cCr;
  TAP_LOGIN_FAIL  : string = cEsc + cEot + cCr;

  TAP_MSG_OKTOSEND: string = cEsc + '[p';
  TAP_MSG_ACK     : string = cAck + cCr;
  TAP_MSG_NAK     : string = cNak + cCr;
  TAP_MSG_RS      : string = cRs + cCr;

  TAP_DISCONNECT  : string = cEsc + cEot + cCr;

  TAP_AUTO_LOGIN  : string = cEsc + 'PG1';
  TAP_LOGOUT      : string = cEot + cCr;

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

{ TApdCustomPager }

procedure TApdCustomPager.AddInitModemDataTrigs;
  { TAP: Add Data Trigger unless we have it already }
begin
  if OKTrig = 0 then
    OKTrig := FPort.AddDataTrigger(ShortString(FapOKTrig), True);
  if ErrorTrig = 0 then
    ErrorTrig := FPort.AddDataTrigger(ShortString(FapErrorTrig), True);
  if ConnectTrig = 0 then
    ConnectTrig := FPort.AddDataTrigger(ShortString(FapConnectTrig), True);
  if BusyTrig = 0 then
    BusyTrig := FPort.AddDataTrigger(ShortString(FapBusyTrig), True);
  if NoCarrierTrig = 0 then
    NoCarrierTrig := FPort.AddDataTrigger(ShortString(FapNoCarrierTrig), True);
  if NoDialtoneTrig = 0 then
    NoDialtoneTrig := FPort.AddDataTrigger(ShortString(FapNoDialtoneTrig), True);
end;

procedure TApdCustomPager.BuildTapMessages;
  { TAP: Build a string list of the TAP message using TStringList }

  function SumChars(const S: string): Integer;
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

  function CheckSum(N: Integer): string;
    { Bit check }
  var
    Sum, nTemp: Integer;
    Chr1,Chr2,Chr3: char;
  begin
    Sum := N;

    nTemp := Sum and $000F; {LS 4 bit}
    Chr3  := Chr(nTemp + $30);

    nTemp := Sum and $00F0; {MS 4 bits of lowbyte}
    nTemp := nTemp shr 4;
    Chr2  := Chr(nTemp + $30);

    nTemp := Sum and $0F00;    {LS 4 bits of hibyte}
    nTemp := nTemp shr 8;
    Chr1  := Chr(nTemp + $30);

    Result := Chr1 + Chr2 + Chr3;
  end;

var
  TempMsg,                 { temp parsed message }
  MsgBlock : string;       { the block that we're working with }
  ChkSum : string;         { Check sum for message }
  NumOfBlocks,             { Keep track of number of blocks in message }
  StartB,                  { Start of this block }
  EndB,                    { End of this block }
  TotMessLen : Integer;    { Total length of the blocks thus far }
  EndOfBlock : boolean;    { End of message - no more blocks }
begin
  if Assigned(FMsgBlockList) then
    FMsgBlockList.Clear
  else
    FMsgBlockList := TStringList.Create;
  NumOfBlocks := 1;        { First block of message }
  EndOfBlock := True;  { Under FMaxMessageLength unless True }
  TempMsg := TrimRight(FMessage.Text);
  if Length(TempMsg) > FMaxMessageLength then begin
    EndOfBlock := False;
    MsgBlock := TempMsg;
    TempMsg := Copy(TempMsg, 1, FMaxMessageLength);
  end;
  TotMessLen := Length(MsgBlock);
  TempMsg := #2 + FPagerID + #13 + TempMsg + #13#3;
  ChkSum := CheckSum(SumChars(TempMsg));
  FMsgBlockList.Add (TempMsg + ChkSum + #13);
  { Enter while loop if message > FMaxMessageLength }
  while not(EndOfBlock) do
    if TotMessLen > Length(TempMsg) then
      EndOfBlock := True
    else begin
      StartB := FMaxMessageLength * NumOfBlocks;
      EndB := FMaxMessageLength * (NumOfBlocks + 1);
      TotMessLen := TotMessLen - FMaxMessageLength;
      TempMsg := Copy(MsgBlock, StartB, EndB);
      TempMsg := TrimRight(TempMsg);
      TempMsg := #2 + FPagerID + #13 + TempMsg + #13#3;
      ChkSum := CheckSum(SumChars(TempMsg));
      FMsgBlockList.Add (TempMsg + ChkSum + #13);
      Inc(NumOfBlocks);
    end;
end;

procedure TApdCustomPager.CancelCall;
  { TAP: Public Access method for cancelling a call }
begin
  Quit;
  TerminatePage;
end;

constructor TApdCustomPager.Create(AOwner: TComponent);
  { General initializations and search for ComPort }
var
  I : integer;
begin
  inherited Create(AOwner);
  { search our owner for a Winsock port }
  if Assigned(AOwner) and (AOwner.ComponentCount > 0) then
    for I := 0 to Pred(AOwner.ComponentCount) do
      SearchComPort(FPort);

  { General Inits }
    FTapHotLine := False;
    FAbortNoConnect := adpgDefAbortNoConnect;
    FExitOnError    := adpgDefExitOnError;
    FDialAttempts   := adpgDefDialAttempts;
    FBlindDial      := adpgDefBlindDial;
    FToneDial       := adpgDefToneDial;
    FUseEscapes     := adpgDefUseEscapes;
    FDialPrefix  := '';
    FTonePrefix  := 'DT';
    FModemHangup := adpgDefModemHangupCmd;
    FModemInit   := adpgDefModemInitCmd;
    FRedialFlag  := False;
    FLoginRetry  := True;
    FPassword := '';
    FMessage := TStringList.Create;
    FEventLog := TApdPgrLog.Create(Self);
    FEventLog.FLogName := 'Pager.Log';                                     
    FHandle := AllocateHWnd(WndProc);
    FCancelled := False;
  { TAP inits }
    FPagerMode := adpgDefPagerMode;
    FPortOpts := adpgDefPortOpts;
    FTapWait := adpgDefDialRetryWait;
    FMaxMessageLength := MAX_MSG_LEN;
    FPortOpenedByUser := False;                                          {!!.06}
  { SNPP inits }
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
end;

procedure TApdCustomPager.DataTriggerHandler(Msg, wParam: Cardinal;
  lParam: Integer);
  { State machine used for handling triggers received }
var
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
  if (Msg = APW_TRIGGERTIMER) and (wParam = FtrgSendTimer) then begin
    DoPageStatus(psSendTimedOut);
  end;

  if (Msg = APW_TRIGGERDATA) and (wParam <> 0) then begin
    if FtrgSendTimer = 0 then
      FtrgSendTimer := FPort.AddTimerTrigger;
    FPort.SetTimerTrigger(FtrgSendTimer, adpgDefTimerTrig, True);

    try
      if wParam = OKTrig then begin
        { Received OK back from modem }
        mpGotOkay := True
      end else if wParam = ErrorTrig then begin
        { modem error }
        FConnected := False;
        FCancelled := True;
        FAborted := True;
      end else if wParam = FtrgLoginFail then begin  { login failure }
        DoPageError(ecLoginFail);
      end else if wParam in [ConnectTrig,    { line has connected }
                             BusyTrig,       { line is busy }
                             NoCarrierTrig,  { no response from modem }
                             NoDialtoneTrig, { no dialtone }
                             FtrgIDPrompt,   { got login prompt }
                             FtrgLoginSucc,  { login accept }
                             FtrgLoginRetry, { login error }
                             FtrgOkToSend,   { okay start sending message }
                             FtrgMsgAck,     { received okay }
                             FtrgMsgNak,     { recept error, resend message }
                             FtrgMsgRs,      { unable to send page }
                             FtrgDCon] { logging out of paging server } then
        DoPageStatusTrig(wParam);
    except
      { do nothing }
    end;
  end;

end;

destructor TApdCustomPager.Destroy;
  { Free what we create }
begin
  if Assigned(FPort) then
    FPort.Open := False;
  FMessage.Free;
  FMsgBlockList.Free;
  if Assigned(tpPingTimer) then begin                                    {!!.06}
    tpPingTimer.Free;
    tpPingTimer := nil;                                                  {!!.06}
  end;                                                                   {!!.06}
  if Assigned(tpModemInitTimer) then begin                               {!!.06}
    tpModemInitTimer.Free;                                               {!!.06}
    tpModemInitTimer := nil;                                             {!!.06}
  end;                                                                   {!!.06}
  if Assigned(WaitTimer) then begin                                      {!!.06}
    WaitTimer.Free;
    WaitTimer := nil;                                                    {!!.06}
  end;                                                                   {!!.06}
  FEventLog.Free;
  DeallocateHwnd(FHandle);
  inherited;
end;

procedure TApdCustomPager.Disconnect;
  { Public Access method to Logout of TAP Service }
begin
  LogOutTAP;
end;

procedure TApdCustomPager.DoCurMessageBlock;
  { TAP: Current message block to be Sent }
begin
  DoPageStatus(psSendingMsg);
  Inc(FDialAttempt);
  FPort.Output := AnsiString(FMsgBlockList[FMsgIdx]);
end;

procedure TApdCustomPager.DoDial;
  { TAP: Dialing using a modem }
var
  Res : Integer;
  S : string;  { dial string }
  
begin
  FSent := False;
  TempWait := FTapWait;
  InitCallStateFlags; { Set FCancelled and FAbort to False }
  
  if not FRedialFlag then begin
    FDialAttempt := 0;
    FEventLog.AddLogString(True, sDialing);
    DoPageStatus(psDialing);
    DoInitializePort;
  end else begin
    FPort.SetTimerTrigger(FtrgSendTimer, 0, False);
    FPort.RemoveTrigger(FtrgSendTimer);
    FtrgSendTimer := 0;
  end;

  case FToneDial of
    True : FTonePrefix := adpgToneDialPrefix;
    False: FTonePrefix := adpgPulseDialPrefix;
  end;

  if Assigned(FTapiDevice) then begin
  { Using Tapi to dial }
    FTapiDevice.Dial(FDialPrefix + FPhoneNumber);
  end else begin
  { Not using Tapi to dial }
    mpGotOkay := False;
    AddInitModemDataTrigs;
    FPort.TapiMode := tmOff;
    if Assigned(FPort) and FPort.Open and (FModemInit <> '') then begin  {!!.06}
      tpModemInitTimer := TTimer.Create(nil);                            {!!.06}
      tpModemInitTimer.Enabled := False;                                 {!!.06}
      tpModemInitTimer.Interval := 10000; // ten seconds                 {!!.06}
      tpModemInitTimer.OnTimer := ModemInitTimerOnTimer;                 {!!.06}
      tpModemInitTimer.Enabled := True;                                  {!!.06}
      FPort.Output := AnsiString(FModemInit + #13);                      {!!.06}
      repeat                                                             {!!.06}
        Res := SafeYield;                                                {!!.06}
      until mpGotOkay or FAborted or FCancelled or (Res = wm_Quit);      {!!.06}
      DoneModemInitTimer;                                                {!!.06}
      if not mpGotOkay then begin                                        {!!.06}
        DoPageStatus(psInitFail);                                        {!!.06}
        exit;                                                            {!!.06}
      end;                                                               {!!.06}
    end;
    if FBlindDial then begin
      { Make BlindDial prefix }
      S := 'ATX3' + FTonePrefix + FDialPrefix + FPhoneNumber + #13
    end else begin
      { Normal dial prefix }
      S := 'AT' + FTonePrefix + FDialPrefix + FPhoneNumber + #13;
    end;
    { Dialing phone here }
    FPort.Output := AnsiString(S);
  end; { Done dialing }
end;

procedure TApdCustomPager.DoFailedToSend;
  { TAP: Failed to send }
begin
  FEventLog.AddLogString(True, sMsgNotSent);
  DoPageStatus(psMsgNotSent);
end;

procedure TApdCustomPager.DoFirstMessageBlock;
  { TAP: First Message block of Page Message }
begin  
  if Assigned(FPort) then begin
    BuildTapMessages;
    FMsgIdx := 0;
    FDialAttempt := 0;
    DoCurMessageBlock;
  end;
end;

procedure TApdCustomPager.DoInitializePort;
  { TAP: Get port ready, open unless using TAPI to dial }
var
  TempTapiCfg : TTapiConfigRec;
begin  
  if csDestroying in ComponentState then
    Exit;
  if Assigned(FPort) then begin
    FPort.RegisterUserCallbackEx(DoPortOpenCloseEx);
    if Assigned(TapiDevice) then begin
      { Port will open when TAPI is dialing }
      FPort.TapiMode := tmOn;
      FTapiDevice.ComPort := FPort;
      FTapiDevice.EnableVoice := False;

      { pCustom will take what TAPI gives us }
      if FPortOpts = pCustom then exit;

      FOrigTapiConfig := FTapiDevice.GetDevConfig;
      TempTapiCfg := FOrigTapiConfig;
      { Set port options before TAPI dials }
      case FPortOpts of
        p7E1: begin  
        TempTapiCfg.Data[38] := 7; { 7 data bits }
        TempTapiCfg.Data[39] := 2; { 2=Even parity, 0=None }
        TempTapiCfg.Data[40] := 0; { stop bit 0=1, 1=1.5, 2=2 }
        end;
        p8N1: begin
        TempTapiCfg.Data[38] := 8; { 8 data bits }
        TempTapiCfg.Data[39] := 0; { 2=Even parity, 0=None }
        TempTapiCfg.Data[40] := 0; { stop bit 0=1, 1=1.5, 2=2 }
        end;
      end;
      FTapiDevice.SetDevConfig(TempTapiCfg);
    end else begin
      if not FPort.Open then begin                                       {!!.06}
        SetPortOpts;
        DoOpenPort;
      end else begin                                                     {!!.06}
        FPortOpenedByUser := True;                                       {!!.06}
        {Port already opened}
        DoPortOpenCloseEx(FPort, ctOpen);                                {!!.06}
      end;                                                               {!!.06}
    end;
  end else    
    raise EPortNotAssigned.Create(ecPortNotAssigned, False);
end;


procedure TApdCustomPager.DoLoginString(Sender: TObject; Data: AnsiString);
  { SNPP: Login was a success }
begin
  FSessionOpen := True;
  DonePingTimer;
  DoPageStatus(psLoggedIn);
end;

procedure TApdCustomPager.DoLogoutString(Sender: TObject; Data: AnsiString);
  { SNPP: Logging out }
begin
  FQuit := True;
  DoPageStatus(psLoggingOut);
end;

procedure TApdCustomPager.DoMultiLine;
  { SNPP: More than one line to PutString out the port }
var
  i: Integer;
begin
  FOkayToSend := False;

  PutString(AnsiString(SNPP_CMD_DATA + ' ' + FMessage[0] + atpCRLF));

  repeat
    FEventLog.AddLogString(True, 'Waiting to Output');
    DelayTicks(STD_DELAY * 2, True);
  until FOkayToSend or FCancelled;

  for i := 0 to Pred(FMessage.Count) do
    PutString(AnsiString(FMessage[i] + atpCRLF));
  PutString(SNPP_DATA_TERMINATE);
end;

procedure TApdCustomPager.DoneModemInitTimer;
begin
  if Assigned(tpModemInitTimer) then begin                               {!!.06}
    tpModemInitTimer.Enabled := False;                                   {!!.06}
    if Assigned(tpModemInitTimer) then                                   {!!.06}
      tpModemInitTimer.Free;                                             {!!.06}
      tpModemInitTimer := nil;                                           {!!.06}
  end;                                                                   {!!.06}
end;

procedure TApdCustomPager.DonePingTimer;
  { TAP: Logged on now, Shut off tpPingTimer }
begin    
  if Assigned(tpPingTimer) then begin
    tpPingTimer.Enabled := False;
    tpPingTimer.Free;                                                    {!!.06}
    tpPingTimer := nil;                                                  {!!.06}
  end;
end;

procedure TApdCustomPager.DoNextMessageBlock;
  { TAP: Set next message block to current message block to send }
begin    
  Inc(FMsgIdx);
  FDialAttempt := 0;
  DoCurMessageBlock;
end;

procedure TApdCustomPager.DoOpenPort;
  { TAP: Open the port if not already open }
begin
  if not(Assigned (FPort)) then
    Exit;
  if FPort.Open then
    Exit;
  FPort.Open := True;
end;

procedure TApdCustomPager.DoPageError(Error: Integer);
  { PageError event could be time sensitive, PostMessage to call event }
begin
  if Assigned(FOnPageError) then
    FOnPageError(self, Error)
  else begin
    case Error of

      ecModemDetectedBusy:  begin
        raise EModemDetectedBusy.Create(Error, False);
      end;

      ecModemNoDialtone: begin
        raise ENoDialtone.Create(Error, False);
      end;

      ecModemNoCarrier: begin
          raise ENoCarrier.Create(Error, False);
      end;

      ecInitFail: begin
        raise EApdPagerException.Create(Error, sInitFail);
      end;

      ecLoginFail: begin
        raise EApdPagerException.Create(Error, sLoginFail);
      end;

    end; { end case statement - Unknown or no error }
  end; { end else }
end;

procedure TApdCustomPager.DoPageStatus(Status: TPageStatus);
  { Page Status could be time sensitive, PostMessage to call status}
begin
    PostMessage(FHandle, Apw_PgrStatusEvent, Ord(Status), TempWait);
end;

procedure TApdCustomPager.DoPageStatusTrig(Trig: Cardinal);
  { TAP: All these Triggers call DoPageStatus }
var
  Stat: TPageStatus;
begin
  Stat := psNone;
  if Trig = ConnectTrig then
    Stat := psConnected     { line has connected }
  else if Trig = BusyTrig then
    Stat := psLineBusy      { line is busy }
  else if Trig = NoCarrierTrig then
    Stat := psDisconnect    { no response from modem }
  else if Trig = NoDialtoneTrig then
    Stat := psNoDialtone    { no dialtone }
  else if Trig = FtrgIDPrompt then
    Stat := psLoginPrompt   { got login prompt }
  else if Trig = FtrgLoginSucc then
    Stat := psLoggedIn      { login accept }
  else if Trig = FtrgLoginRetry then
    Stat := psLoginRetry    { login error }
  else if Trig = FtrgOkToSend then
    Stat := psMsgOkToSend   { okay start sending message }
  else if Trig = FtrgMsgAck then
    Stat := psMsgAck        { received okay, send next block or end }
  else if Trig = FtrgMsgNak then
    Stat := psMsgNak        { received error, resend message }
  else if Trig = FtrgMsgRs then
    Stat := psMsgRs         { unable to send page }
  else if Trig = FtrgDCon then
    Stat := psDone;         { logging out of paging server }
  DoPageStatus(Stat);
end;

procedure TApdCustomPager.DoPortOpenCloseEx(CP: TObject;
                                 CallbackType : TApdCallbackType);
  { TAP: To Notify when the port opens or is closing }
begin
  case CallbackType of
    ctOpen   : begin
      DoStartCall;
      if Assigned(FTapiDevice) and (PagerMode = pmTAP) then
        DoPageStatus(psConnected);
    end;
    ctClosing: FPort.DeregisterUserCallbackEx(DoPortOpenCloseEx);
    ctClosed : {Nothing for now}
  end;
end;

procedure TApdCustomPager.DoServerDataMsg(Sender: TObject; Data: AnsiString);
  { SNPP: Ready to Send }
begin   
  FOkayToSend := True;
end;

procedure TApdCustomPager.DoServerError(Sender: TObject; Data: AnsiString);
  { SNPP: Minor Server Error }
begin
  FCancelled := ExitOnError;
  FEventLog.AddLogString(True, sMinorSrvErr);
  if Assigned(FOnPageError) then
    FOnPageError(self, ecMinorSrvErr);
end;

procedure TApdCustomPager.DoServerFatalError(Sender: TObject;
  Data: AnsiString);
  { SNPP: Fatal Server Error }
begin
  FCancelled := True;
  FEventLog.AddLogString(True, sFatalSrvErr);
  if Assigned(FOnPageError) then
    FOnPageError(self, ecFatalSrvErr);
end;

procedure TApdCustomPager.DoServerSucc(Sender: TObject; Data: AnsiString);
  { SNPP: A packet has returned }
var
  Code: Integer;
  Msg: Ansistring;
begin
  Code := StrToInt(Copy(string(Data),1,3));
  Msg  := Copy(Data, 5, Length(Data)-4);
  Data := Copy(Data, 1, Length(Data) - 1);
  FEventLog.AddLogString(True, string(Data));
  if not FGotSuccess then begin
    FGotSuccess := True;
  end else begin
    if Assigned(FOnPageFinish) then
      FOnPageFinish(self, Code, string(Msg));
  end;
end;

procedure TApdCustomPager.DoStartCall;
  { TAP: Get Trigger Handler/State Machine ready }
begin
  tpPingCount := 0;
  FPort.Dispatcher.RegisterEventTriggerHandler(DataTriggerHandler);
end;

procedure TApdCustomPager.FreeLoginTriggers;
  { TAP: Free Triggers used for logging in }
begin
  FreeTrigger(FPort, FtrgIDPrompt);
  FreeTrigger(FPort, FtrgLoginSucc);
  FreeTrigger(FPort, FtrgLoginRetry);
  FreeTrigger(FPort, FtrgLoginFail);
end;

procedure TApdCustomPager.FreeLogoutTriggers;
  { TAP: Free Logout Triggers used for Logging Out }
begin 
    FreeTrigger(FPort, FtrgDCon);
end;

procedure TApdCustomPager.FreeMsgTriggers;
  { TAP: Free Triggers used for results of sending Page }
begin 
  FreeTrigger(FPort, FtrgOkToSend);
  FreeTrigger(FPort, FtrgMsgAck);
  FreeTrigger(FPort, FtrgMsgNak);
  FreeTrigger(FPort, FtrgMsgRs);
end;

procedure TApdCustomPager.FreePackets;
  { SNPP: Free Packets used for SNPP Pages }
begin  
  FLoginPacket.Free;
  FServerSuccPacket.Free;
  FServerDataMsgPacket.Free;
  FServerErrorPacket.Free;
  FServerFatalErrorPacket.Free;
  FServerDonePacket.Free;
end;

procedure TApdCustomPager.FreeResponseTriggers;
  { TAP: Free Triggers used by the Modem }
begin    
    FreeTrigger(FPort, OKTrig);
    FreeTrigger(FPort, ErrorTrig);
    FreeTrigger(FPort, ConnectTrig);
    FreeTrigger(FPort, BusyTrig);
    FreeTrigger(FPort, NoCarrierTrig);
    FreeTrigger(FPort, NoDialtoneTrig);
    FreeTrigger(FPort, FtrgSendTimer);
end;

procedure TApdCustomPager.FreeTrigger(Port: TApdCustomComPort;
  var Trigger: Word);
  { Used to remove a trigger }
begin
  if (Assigned(Port)) and (Port.Open) and (Trigger <> 0) then begin
    Port.RemoveTrigger(Trigger);
    Trigger := 0;
  end;
end;

procedure TApdCustomPager.InitCallStateFlags;
  { TAP: Initializing Flags }
begin
  FAborted    := False;
  FCancelled  := False;
  FConnected  := False;
  FTerminating := False;
end;

procedure TApdCustomPager.InitLoginTriggers;
  { TAP: Add Triggers for logging on the TAP server }
begin
  FtrgIDPrompt   := FPort.AddDataTrigger(ShortString(TAP_ID_PROMPT),    False);
  FtrgLoginSucc  := FPort.AddDataTrigger(ShortString(TAP_LOGIN_ACK),    False);
  FtrgLoginFail  := FPort.AddDataTrigger(ShortString(TAP_LOGIN_FAIL),   False);
  FtrgLoginRetry := FPort.AddDataTrigger(ShortString(TAP_LOGIN_NAK),    False);
end;

procedure TApdCustomPager.InitLogoutTriggers;
  { TAP: Add Triggers to Logout of TAP server }
begin
  FtrgDCon := FPort.AddDataTrigger(ShortString(TAP_DISCONNECT), False);
end;

procedure TApdCustomPager.InitMsgTriggers;
  { TAP: Add Triggers used for TAP Server Page results from message }
begin   
  FtrgOkToSend  := FPort.AddDataTrigger(ShortString(TAP_MSG_OKTOSEND), False);
  FtrgMsgAck    := FPort.AddDataTrigger(ShortString(TAP_MSG_ACK), True);
  FtrgMsgNak    := FPort.AddDataTrigger(ShortString(TAP_MSG_NAK), True);
  FtrgMsgRs     := FPort.AddDataTrigger(ShortString(TAP_MSG_RS),  True);
end;

procedure TApdCustomPager.InitPackets;
  { SNPP: Make packets for SNPP Server replies or results }
begin 
  MakePacket(FLoginPacket,            FServerInitString   , ^M, DoLoginString);
  MakePacket(FServerSuccPacket,       FServerSuccStr      , ^M, DoServerSucc);
  MakePacket(FServerDataMsgPacket,    FServerDataInp      , ^M, DoServerDataMsg);
  MakePacket(FServerErrorPacket,      FServerRespFailCont , ^M, DoServerError);
  MakePacket(FServerFatalErrorPacket, FServerRespFailTerm , ^M, DoServerFatalError);
  MakePacket(FServerDonePacket,       FServerDoneString   , ^M, DoLogoutString);
end;

procedure TApdCustomPager.LogOutTAP;
  { TAP: Logging out of TAP service }
begin
  DoPageStatus(psLoggingOut);
  if Assigned(FPort) and FPort.Open then
    FPort.Output := AnsiString(TAP_LOGOUT);
end;

procedure TApdCustomPager.MakePacket(ThePacket: TApdDataPacket; StartStr,
  EndStr: string; HandlerMethod: TStringPacketNotifyEvent);
  { SNPP: Setup a DataPacket to look for characters } 
begin
  if not Assigned(ThePacket) then begin
    ThePacket := TApdDataPacket.Create(self);
    ThePacket.ComPort := FPort;
    ThePacket.StartString := AnsiString(StartStr);
    ThePacket.StartCond := scString;
    ThePacket.EndString := AnsiString(EndStr);
    ThePacket.EndCond := [];
    if EndStr <> '' then
      ThePacket.EndCond := [ecString];
    ThePacket.IncludeStrings := True;
    ThePacket.OnStringPacket := HandlerMethod;
    ThePacket.Enabled := True;
  end;
end;

procedure TApdCustomPager.ModemInitTimerOnTimer(Sender: TObject);
begin
  if Port.Open and (Port.OutBuffFree > 0) then begin                     {!!.06}
    FAborted := True;                                                    {!!.06}
  end;                                                                   {!!.06}
end;

procedure TApdCustomPager.Notification(AComponent: TComponent;
  Operation: TOperation);
  { Find Port }
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

procedure TApdCustomPager.PingTimerOnTimer(Sender: TObject);
  { TAP: Timer event used while logging on }
begin
  if Port.Open and (Port.OutBuffFree > 0) then begin
    FPort.Output := cCr;
  end;
  Inc(tpPingCount, 2);
  if tpPingCount > FTapWait then begin
    tpPingTimer.Enabled := False;
    FAborted := True;                                                    {!!.06}
    DoPageStatus(psLoginRetry);
  end;
end;

procedure TApdCustomPager.PutMessage;
  { SNPP: Put out a Message unless more than one line }
begin 
  if FMessage.Count > 1 then
    DoMultiLine
  else
    PutString(AnsiString(SNPP_CMD_MESSAGE + ' ' + FMessage[0] + atpCRLF));
end;

procedure TApdCustomPager.PutQuit;
  { SNPP: Command to quit sending message }
begin 
  PutString(SNPP_CMD_QUIT + atpCRLF);
end;

procedure TApdCustomPager.PutSend;
  { SNPP: Command to send message }
begin    
  PutString(SNPP_CMD_SEND + atpCRLF);
end;

procedure TApdCustomPager.PutString(const S: Ansistring);
  { SNPP: Put a string out the port }
var
  i: Integer;
begin
  if Assigned(FPort) then
    FPort.Output := S;
  if FCommDelay > 0 then begin
    i := 1;
    repeat
      FEventLog.AddLogString(True, 'Output Delay');
      DelayTicks(STD_DELAY * 2, True);
      Inc(i);
    until i > FCommDelay;
  end;
end;

procedure TApdCustomPager.Quit;
  { SNPP: Public Access Method for quitting a Page in progress }
begin
  FCancelled := True;
end;

procedure TApdCustomPager.Send;
  { Send a page }
begin
  case FPagerMode of

    { PagerMode is using TAP }
    pmTAP: begin
      FPageMode := 'TAP';
//      tpPingTimer := TTimer.Create(nil);                               {!!.06}
//      tpPingTimer.Enabled := False;                                    {!!.06}
//      tpPingTimer.Interval := 2000;                                    {!!.06}
//      tpPingTimer.OnTimer := PingTimerOnTimer;                         {!!.06}
      if FTapHotLine then begin
        DoInitializePort;
        DoPageStatus(psConnected);
      end else begin
        { TAP uses DoDial unless TapHotLine is true }
        DoDial;
      end;
    end; // End TAP Send

    { Pager mode is using SNPP }
    pmSNPP: begin
      { make sure we have a winsock port }
      if not(FPort is TApdCustomWinsockPort) then
        raise EBadArgument.Create(ecBadArgument, True);
      FPageMode := 'SNPP';

      FSessionOpen := False;
      FSent := False;
      FQuit := False;
      FCancelled := False;

      FPort.Open := True;

      InitPackets;
      repeat
        DelayTicks(STD_DELAY * 2, True);
      until FSessionOpen or FCancelled;

      if not FCancelled then begin
        FGotSuccess := False;
        PutString(AnsiString(SNPP_CMD_PAGEREQ + ' ' + FPagerID + atpCRLF));
        repeat
          DelayTicks(2, True);
        until FGotSuccess or FCancelled;
      end;

      if not FCancelled then begin
        FEventLog.AddLogString(True, sMsgOkToSend);
        FGotSuccess := False;
        PutMessage;
        repeat
          DelayTicks(STD_DELAY * 2, True);
        until FGotSuccess or FCancelled;
      end;
      { FSent := False; }
      if not FCancelled then begin   
        DoPageStatus(psSendingMsg);
        FEventLog.AddLogString(True, sSendingMsg);
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
        FEventLog.AddLogString(True, sDone)
      else
        FEventLog.AddLogString(True, sCancelled);

      FreePackets;
    end; // End SNPP Send
  end;
end;

procedure TApdCustomPager.SetMessage(Msg: TStrings);
  { Set Message for TStrings Message List }
begin
  FMessage.Assign(Msg);
end;

procedure TApdCustomPager.SetPagerID(ID: string);
  { Set PagerID property }
begin
  FPagerID := ID;
end;

procedure TApdCustomPager.SetPortOpts; 
{ Not using TAPI, but setting the port options to the PortOpts property }
begin
  if (Assigned(TapiDevice)) or (FPortOpts = pCustom) then
    exit;
  if FPortOpts = p7E1 then begin
  { setting port to 7 DataBits, Parity Even, StopBits 1 }
    FPort.DataBits := 7;
    FPort.Parity := pEven;
    FPort.StopBits := 1;
  end else begin
  { setting port to 8 DataBits, Parity None, StopBits 1 }
    FPort.DataBits := 8;
    FPort.Parity := pNone;
    FPort.StopBits := 1;
  end;
end;

procedure TApdCustomPager.SetUseEscapes(UseEscapesVal: Boolean);
  { Set UseEscapes property }
begin
  FUseEscapes := UseEscapesVal;
end;

procedure TApdCustomPager.TerminatePage;
  { This procedure is called when not using TAPI to hangup modem }
var
  TheCommand, Data : AnsiString;
  FPacket : TApdDataPacket;
  I : Integer;
begin
  if   FTerminating or
       FTapHotLine  or
       not FPort.Open then
    exit;
  FTerminating := True;

  if FPort.TapiMode = tmOn then begin
    FTapiDevice.CancelCall;
    FTerminating := False;
    Exit;
  end;

  FPacket := nil;

  try
    TheCommand := '';
    FPacket := TApdDataPacket.Create(Self);
    FPacket.StartString := 'OK';
    FPacket.StartCond := scString;
    FPacket.ComPort := FPort;
    FPacket.Timeout := 91; { 5 second timeout }

    {assume ModemHangup = '+++~~~ATH' }
    TheCommand := AnsiString(FModemHangup);

    for I := 1 to Length(TheCommand) do
      if TheCommand[3] = '~' then
        DelayTicks(1, True)
      else
        FPort.PutChar(TheCommand[I]);  

    { append a CR if needed }
    if Pos(cCR, FModemHangup) <> Length(FModemHangup) - 2 then
      FPort.Output := cCR; 
    { we should be hung up by now, lower DTR just in case }
    if not FPacket.WaitForString(Data) then
      FPort.DTR := False;
  finally
    FPacket.Free;
    FTerminating := False;
  end;    

end;

procedure TApdCustomPager.WaitTimerOnTimer(Sender: TObject);
  { TAP: Event used for when the Event Timer fires }
begin
  if Assigned(WaitTimer) then begin
    WaitTimer.Enabled := False;
  end;
  if TempWait > 0 then begin
    if Assigned(FOnPageStatus) then
      FOnPageStatus(Self, psWaitingToRedial, TempWait, 0);
    WaitTimer.Enabled := True;
    dec(TempWait);
  end else begin
    { Attempt another dial }
    DoPageStatus(psRedialing);
  end;
end;

procedure TApdCustomPager.WndProc(var Message: TMessage);
  { Process Status events outside trigger state machine }
var
  Status : TPageStatus;
  Done : Boolean;
begin
  with Message do begin
    Status := TPageStatus(wParam);
    if Msg = Apw_PgrStatusEvent then begin
      if Assigned(FOnPageStatus) then
        FOnPageStatus(self, Status, 0, 0);
      case Status of

        psNone: begin
          { Nothing happening }
        end;

        psInitFail: begin
          FEventLog.AddLogString(True, sInitFail);
          DoPageError(ecInitFail);
        end;

        psConnected: begin
          FConnected := True;
          InitLoginTriggers;
          if not Assigned(tpPingTimer) then                              {!!.06}
            tpPingTimer := TTimer.Create(nil);                           {!!.06}
          tpPingTimer.Enabled := False;                                  {!!.06}
          tpPingTimer.Interval := 2000;                                  {!!.06}
          tpPingTimer.OnTimer := PingTimerOnTimer;                       {!!.06}
          tpPingTimer.Enabled := True;
          if self.EventLog.FVerboseLog then
            FEventLog.AddLogString(True, sConnected);
        end;

        psLineBusy: begin
          FConnected := False;
          FRedialFlag := False;
          FEventLog.AddLogString(True, sLineBusy);
          FAborted := ExitOnError;
          if FAborted then begin
            FEventLog.AddLogString(True, sModemDetectedBusy);
            DoPageError(ecModemDetectedBusy);
          end else begin
            { If the page was canceled or aborted then abort the call. }
            if FCancelled or FAborted or (SafeYield = wm_Quit) then begin
              if self.EventLog.FVerboseLog then
                FEventLog.AddLogString(True, sMsgNotSent);
              DoPageStatus(psMsgNotSent);
            end else begin
              { If the number of redial attempts has not been reached }
              inc(FDialAttempt);                                         {!!.06}
              if (FDialAttempt < FDialAttempts) then begin
                FRedialFlag := True;
                //inc(FDialAttempt);                                     {!!.06}
                //DonePingTimer;                                         {!!.06}
                if self.EventLog.FVerboseLog then
                  FEventLog.AddLogString(True, sWaitingToRedial);
                DoPageStatus(psWaitingToRedial);
              end else begin
                FCancelled := True;
                DoPageError(ecModemDetectedBusy);                        {!!.06}
              end;
            end;
          end;
        end;

        psDisconnect: begin
          FConnected := False;
          FCancelled := True;
          FRedialFlag := False;
          if self.EventLog.FVerboseLog then
            FEventLog.AddLogString(True, sModemNoCarrier);
          DoPageError(ecModemNoCarrier);
        end;

        psNoDialtone: begin
          FConnected := False;
          FRedialFlag := False;
          if self.EventLog.FVerboseLog then
            FEventLog.AddLogString(True, sModemNoDialtone);
          DoPageError(ecModemNoDialtone);
        end;

        psMsgNotSent: begin
          { Only do status event }
        end;

        psWaitingToReDial: begin
          { Wait the redial time and try again! }
          if not Assigned(WaitTimer) then
            WaitTimer := TTimer.Create(nil);
          WaitTimer.Enabled := False;
          WaitTimer.Interval := 1000;
          WaitTimer.OnTimer := WaitTimerOnTimer;
          WaitTimer.Enabled := True;
        end;

        psLoginPrompt: begin
          { TAP login prompt }
          if self.EventLog.FVerboseLog then
            FEventLog.AddLogString(True, sLoginPrompt);
          DonePingTimer;
          if FPassword <> '' then
            FPort.Output := AnsiString(TAP_AUTO_LOGIN + FPassword + cCr)
          else
            FPort.Output := AnsiString(TAP_AUTO_LOGIN + cCr);
        end;

        psLoggedIn: begin
          { SNPP Logged in }
          if self.EventLog.FVerboseLog then
            FEventLog.AddLogString(True,sLoggedIn);
          FreeLoginTriggers;
          InitMsgTriggers;
          FLoginRetry := True;
        end;

        psLoggingOut: begin
          if self.EventLog.FVerboseLog then
            FEventLog.AddLogString(True, sLoggingOut);
        end;

        psDialing: begin
          { Only do status event }
        end;

        psRedialing: begin
          WaitTimer.Free;
          WaitTimer := nil;                                              {!!.06}
          if FRedialFlag then
            DoDial;
        end;

        psLoginRetry: begin
          if FLoginRetry then begin
            if FPassword <> '' then
              FPort.Output := AnsiString(TAP_AUTO_LOGIN + FPassword + cCr)
            else
              FPort.Output := AnsiString(TAP_AUTO_LOGIN + cCr);
            FLoginRetry := False;
          end else begin
            if self.EventLog.FVerboseLog then
              FEventLog.AddLogString(True, sLoginFail);
            DoPageError(ecLoginFail);
            FreeLoginTriggers;
            FAborted := True;
            FLoginRetry := True;
          end;
        end;

        psMsgOkToSend: begin
          DoFirstMessageBlock;
        end;

        psSendingMsg: begin
          { Only do status event }
        end;

        psMsgAck: begin
        { receipt okay, send next block or end if no more }
          if FMsgIdx < Pred(FMsgBlockList.Count) then begin
            DoNextMessageBlock;
            Done := False;
          end else begin
            Done := True;
            if Assigned(FOnGetNextMessage) then begin
              OnGetNextMessage(self, Done);
                if not Done then begin
                  // Doing first message block
                  DoPageStatus(psMsgOkToSend);
                  Exit;
                end;
            end;
            FSent := True;
            FreeMsgTriggers;
            InitLogoutTriggers;
            LogOutTAP;
          end;
        end;

        psMsgNak: begin
          if FDialAttempt < FDialAttempts then
            DoCurMessageBlock
          else
            LogOutTAP;
        end;

        psMsgRs: begin { Unable to send page }
          if FMsgIdx < Pred(FMsgBlockList.Count) then begin
            DoNextMessageBlock;
          end else begin
            Done := True;
            if Assigned(FOnGetNextMessage) then begin
              OnGetNextMessage(self, Done);
              if not Done then begin
                DoFirstMessageBlock;
                Exit;
              end;
            end else
              LogOutTAP;
          end;
        end;

        psMsgCompleted: begin
          { Only do status event }
        end;

        psSendTimedOut: begin
          if FMsgIdx < Pred(FMsgBlockList.Count) then begin
            DoNextMessageBlock;
          end;
        end;

        psDone: begin
          FreeLogoutTriggers;
          FreeResponseTriggers;
          if Assigned(FTapiDevice) then begin
            FPort.Dispatcher.DeregisterEventTriggerHandler
                                (DataTriggerHandler);
            FTapiDevice.CancelCall
          end else begin
            FPort.Dispatcher.DeregisterEventTriggerHandler
                                (DataTriggerHandler);
            if FPort.Open and not FTapHotLine
                          and not FPortOpenedByUser then                 {!!.06}
              FPort.Open := False;
          end;

          if not FSent then
            DoFailedToSend
          else
            FEventLog.AddLogString(True, sDone);

          if Assigned(FOnPageFinish) then
            FOnPageFinish(self, 0, '');
        end;
      end;
      Result := 1;
    end else
      Result := DefWindowProc(FHandle, Msg, wParam, lParam);
  end;
end;

{ TApdTapProperties }

constructor TApdTapProperties.Create(Owner : TApdCustomPager);
begin
  FOwner := Owner;
end;

function TApdTapProperties.GetBlindDial: Boolean;
begin
  Result := FOwner.BlindDial;
end;

function TApdTapProperties.GetDialAttempts: Word;
begin
  Result := FOwner.DialAttempts;
end;

function TApdTapProperties.GetDialPrefix: string;
begin
  Result := FOwner.DialPrefix;
end;

function TApdTapProperties.GetMaxMessageLength: Integer;
begin
  Result := FOwner.MaxMessageLength;
end;

function TApdTapProperties.GetModemHangup: string;
begin
  Result := FOwner.ModemHangup;
end;

function TApdTapProperties.GetModemInit: string;
begin
  Result := FOwner.ModemInit;
end;

function TApdTapProperties.GetPortOpts: TPortOpts;
begin
  Result := FOwner.PortOpts;
end;

function TApdTapProperties.GetTapHotLine: Boolean;
begin
  Result := FOwner.TapHotLine;
end;

function TApdTapProperties.GetTapiDevice: TApdTapiDevice;
begin
  Result := FOwner.TapiDevice;
end;

function TApdTapProperties.GetTapWait: Integer;
begin
  Result := FOwner.TapWait;
end;

function TApdTapProperties.GetToneDial: Boolean;
begin
  Result := FOwner.ToneDial;
end;

procedure TApdTapProperties.SetBlindDial(const Value: Boolean);
begin
  FOwner.BlindDial := Value;
end;

procedure TApdTapProperties.SetDialAttempts(const Value: Word);
begin
  FOwner.DialAttempts := Value;
end;

procedure TApdTapProperties.SetDialPrefix(const Value: string);
begin
  FOwner.DialPrefix := Value;
end;

procedure TApdTapProperties.SetMaxMessageLength(const Value: Integer);
begin
  FOwner.MaxMessageLength := Value;
end;

procedure TApdTapProperties.SetModemHangup(const Value: string);
begin
  FOwner.ModemHangup := Value;
end;

procedure TApdTapProperties.SetModemInit(const Value: string);
begin
  FOwner.ModemInit := Value;
end;

procedure TApdTapProperties.SetPortOpts(const Value: TPortOpts);
begin
  FOwner.PortOpts := Value;
end;

procedure TApdTapProperties.SetTapHotLine(const Value: Boolean);
begin
  FOwner.TapHotLine := Value;
end;

procedure TApdTapProperties.SetTapiDevice(const Value: TApdTapiDevice);
begin
  FOwner.TapiDevice := Value;
end;

procedure TApdTapProperties.SetTapWait(const Value: Integer);
begin
  FOwner.TapWait := Value;
end;

procedure TApdTapProperties.SetToneDial(const Value: Boolean);
begin
  FOwner.ToneDial := Value;
end;

{ TApdPager }

constructor TApdPager.Create(AOwner: TComponent);
begin
  inherited;
  FTapProperties := TApdTapProperties.Create(Self);
end;

destructor TApdPager.Destroy;
begin
  FTapProperties.Free;
  inherited;
end;

{ TApdPgrLog }

procedure TApdPgrLog.AddLogString(Verbose: Boolean;
                            const StatusString: string);
  { Add a string to the TApdPager's Log if EventLog is Enabled }
var
  DestAddr : string;
  LogStream : TFileStream;
  TimeStamp : string;
  pBytes: TBytes;
begin
  if FEnabled then
    if Verbose and FVerboseLog then begin
      if FOwner.FPagerMode = pmSNPP then
        with TApdCustomWinsockPort(FOwner.FPort) do
          DestAddr := wsAddress
      else if FOwner.FPagerMode = pmTAP then
        DestAddr := FOwner.FPhoneNumber;
      DestAddr := DestAddr + ' ';
      if FileExists(FLogName) then
        LogStream := TFileStream.Create(FLogName, fmOpenReadWrite or fmShareDenyNone)
      else
        LogStream := TFileStream.Create(FLogName, fmCreate or fmShareDenyNone);
      LogStream.Seek(0, soFromEnd);
      TimeStamp := FormatDateTime('dd/mm/yy : hh:mm:ss - ', Now) + ' ' +
                   FOwner.FPageMode + ' page to ' + FOwner.FPagerID + ' at ' +
                   DestAddr + StatusString + #13#10;
      pBytes := TEncoding.ANSI.GetBytes(TimeStamp);
      LogStream.WriteBuffer(pBytes, Length(pBytes));
      LogStream.Free;
    end;
end;

procedure TApdPgrLog.ClearLog;
  { Delete the log file }
begin
  SysUtils.DeleteFile(FLogName);
end;

constructor TApdPgrLog.Create(Owner: TApdCustomPager);
begin
  FOwner := Owner;
end;

end.
