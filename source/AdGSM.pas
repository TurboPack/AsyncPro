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
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                    ADGSM.PAS 4.06                     *}
{*********************************************************}
{* TApdGSMPhone component                                *}
{*********************************************************}

(*
The TApdGSMPhone component in APRO 4 implements SMS text messaging through the
text-mode interface defined in the GSM Technical Specification 07.05, version
5.1.0, dated December 1996.  There are several variations of this spec, used
throughout Nokia, Siemens, Ericsson, etc models.
We have tested the Nokia 8290 in-house, but the Nokia 7190, 8890, 6210 and 9110
models should work as well.  Phones from other manufacturers will also work, as
long as they implement the text-mode interface.  About 1/4 of the current phones
are capable of being connected to a PC (through IR or serial cable), about 1/3
of those are text-mode only, 1/3 are PDU mode only, and the other 1/3 support
both text and PDU mode.  Some phones (such as the Nokia 5190) support SMS, but
they use a proprietary protocol, which APRO does not support.  Note also that
APRO can't communicate successfully through an FBUS cable (usually found with
Nokia phones).
To test your phone, connect the phone to your PC through the serial cable or
IR device (consult your phone's documentation for details on how to connect).
Enter "AT"<CR> into a terminal window to verify the connection is established
(you should receive "OK" from the phone), then enter "AT+CMGF=?"<CR>. The
response should contain a "1", indicating that it supports text-mode.  If both
of these tests pass, then your phone meets the basic requirements.

Command and response sequences are defined by the GSMXxx array consts, we
iterate from 0 to High, so you can remove certain commands from the sequence
by simply deleting that command from the array.

PDU mode was added after 4.05 and did not undergo the normal testing cycle.
Changes specific to PDU mode are marked with {!!.PDU}
Much of the information on PDU format came from http://www.dreamfabric.com/sms/
with ParseAPDUMessage parsing out the PDU messages for the listing of messages.
BuildPDUMessage will build a PDU message before sending.
*)

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit adgsm;
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  OoMisc,
  AdPort,
  AdPacket,
  AdExcept;

const
  ApdGSMResponse = WM_USER + 100;

type
  TGSMStates = (gsNone,
                gsConfig,
                gsSendAll,
                gsListAll,
                gsSend,
                gsSendFStore,
                gsWrite,
                gsDelete,
                gsNofify);

  TApdSMSStatus = (srUnread,
                   srRead,
                   ssUnsent,
                   ssSent,
                   ssAll,
                   ssUnknown);

  { GSM modes }
  TGSMMode = (gmDetect, gmPDU, gmText);                                 {!!.PDU}
  TGSMModeSet = set of TGSMMode;                                        {!!.PDU}

  TApdCustomGSMPhone = class;

  TApdGSMNextMessageEvent = procedure (Pager : TApdCustomGSMPhone;
                          ErrorCode : Integer; var NextMessageReady : Boolean)
                          of object;
  TApdGSMNewMessageEvent = procedure (Pager : TApdCustomGSMPhone;
                         FIndex : Integer; Message : string) of object;
  TApdGSMMessageListEvent = procedure (Sender : TObject) of object;
  TApdGSMCompleteEvent = procedure (Pager : TApdCustomGSMPhone;
                                    State : TGSMStates;
                                    ErrorCode : Integer) of object;


  TApdSMSMessage = class(TObject)
  private
    FMessageIndex: Integer;
    FAddress: string;
    FMessage: string;
    FName: string;
    FStatus: TApdSMSStatus;
    FTimeStampStr: string;
    FTimeStamp: TDateTime;
    { private declarations }
  protected
    { protected declarations }
    function GetMessageAsPDU : AnsiString;                              {!!.PDU}
    procedure SetMessageAsPDU (v : AnsiString);                         {!!.PDU}
  public
    { public declarations }
    property Address : string
      read FAddress write FAddress;
    property Message : string
      read FMessage write FMessage;
    property MessageAsPDU : AnsiString                                  {!!.PDU}
             read GetMessageAsPDU write SetMessageAsPDU;                {!!.PDU}
    property MessageIndex : Integer
      read FMessageIndex write FMessageIndex;
    property Name : string
      read FName write FName;
    property Status : TApdSMSStatus
      read FStatus write FStatus;
    property TimeStamp : TDateTime
      read FTimeStamp write FTimeStamp;
    property TimeStampStr : string
      read FTimeStampStr write FTimeStampStr;
  end;

  TApdMessageStore = class(TStringList)
  private
    { private declarations }
    FCapacity : Integer;
    FGSMPhone : TApdCustomGSMPhone;
    function GetMessage(Index: Integer): TApdSMSMessage;
    procedure SetMessage(Index: Integer; const Value : TApdSMSMessage);
    procedure SetMSCapacity(const Value: Integer);
  protected
    { protected declarations }
    JustClearStore : Boolean;
    function GetCapacity : Integer; override;
    procedure ClearStore;
  public
    { public declarations }
    constructor Create(GSMPhone : TApdCustomGSMPhone);
    function AddMessage(const Dest, Msg : string) : Integer;
    procedure Clear; override;
    procedure Delete(PhoneIndex: Integer); override;
    property Messages[Index: Integer]: TApdSMSMessage
             read GetMessage write SetMessage; default;
    property Capacity : Integer read FCapacity write SetMSCapacity;
  end;

  TApdCustomGSMPhone = class(TApdBaseComponent)
  private
    { Private declarations }

    FOnNewMessage : TApdGSMNewMessageEvent;
    FOnNextMessage : TApdGSMNextMessageEvent;
    FOnMessageList : TApdGSMMessageListEvent;
    FOnGSMComplete: TApdGSMCompleteEvent;

    FComPort: TApdCustomComPort;
    FNeedNewMessage : Integer;           // Flag to get a new message    {!!.04}
    FRecNewMess : string;                                                {!!.06}
    FConnected : Boolean;                // Flag for connection status
    FErrorCode: Integer;
    FGSMState: TGSMStates;
    FGSMMode: TGSMMode;                                                 {!!.PDU}
    FHandle: THandle;
    FMessage : string;                   // Defines Message to be sent
    FMessageStore: TApdMessageStore;
    FNotifyOnNewMessage: Boolean;
    FQueryModemOnly: Boolean;                                            {!!.06}
    // True won't sychronize message store
    FQuickConnect: Boolean;
    // True won't give list of messages when first connected
    FConfigList: Boolean;                                                {!!.02}

    FSMSAddress: string;             // Phone number
    FSMSCenter: string;              // Service Center
    FTempWriteMess: AnsiString;          // Temp store when WriteToMemory
    FPDUMode : Boolean;                  // PDU Mode                    {!!.PDU}

    ResponsePacket : TApdDataPacket;
    ErrorPacket : TApdDataPacket;
    NotifyPacket : TApdDataPacket;                                       {!!.02}
    TempSMSMessage : TApdSMSMessage;

    procedure SetMessage(const Value: string);
    procedure SetCenter(const Value: string);
    procedure SetNotifyOnNewMessage(const Value: Boolean);
    procedure SetGSMMode(const NewMode : TGSMMode);                     {!!.PDU}

  protected
    { Protected declarations }
    CmdIndex : Integer;
    ResponseStr : AnsiString;
    NotifyStr : AnsiString;                                             {!!.02}
    FSupportedGSMModes : TGSMModeSet;                                   {!!.PDU}
    procedure CheckPort;
    procedure WndProc(var Message: TMessage);
    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;
    procedure ResponseStringPacket(Sender: TObject; Data : Ansistring);
    procedure NotifyStringPacket(Sender: TObject; Data : AnsiString);        {!!.02}

    procedure SetPDUMode (v : Boolean);                                 {!!.PDU}
    function GetGSMMode : TGSMMode;                                     {!!.PDU}

    procedure ErrorStringPacket(Sender: TObject; Data : AnsiString);
    procedure DoFail(const Msg: string; const ErrCode: Integer);

    { these methods manage the phone's message store }
    procedure DeleteFromMemoryIndex(PhoneIndex : Integer);
    property Handle : THandle read FHandle;
    procedure SetState(NewState : TGSMStates);
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SendMessage;
    procedure SendAllMessages;
    procedure ListAllMessages;
    procedure Connect;
    procedure SendFromMemory(TheIndex : Integer);
    procedure WriteToMemory(const Dest, Msg: AnsiString);
    procedure ProcessResponse;
    procedure Synchronize;
    procedure QueryModem;

    function StatusToStr(StatusString : TApdSMSStatus) : AnsiString;

    property ComPort : TApdCustomComPort
      read FComPort write FComPort;
    property SMSAddress : string
      read FSMSAddress write FSMSAddress;
    property SMSMessage : string
      read FMessage write SetMessage;
    property SMSCenter : string
      read FSMSCenter write SetCenter;
    property NotifyOnNewMessage : Boolean
             read FNotifyOnNewMessage
             write SetNotifyOnNewMessage default False;                  {!!.02}
    property MessageStore : TApdMessageStore
      read FMessageStore write FMessageStore;
    property QuickConnect : Boolean
      read FQuickConnect write FQuickConnect default False;
    property GSMMode : TGSMMode                                         {!!.PDU}
      read GetGSMMode write SetGSMMode;                                 {!!.PDU}
    { read only properties }
    property SMSErrorCode : Integer
      read FErrorCode;
    property GSMState : TGSMStates
      read FGSMState;
    property OnNewMessage : TApdGSMNewMessageEvent
             read FOnNewMessage write FOnNewMessage;
    property OnNextMessage : TApdGSMNextMessageEvent
             read FOnNextMessage write FOnNextMessage;
    property OnMessageList : TApdGSMMessageListEvent
             read FOnMessageList write FOnMessageList;
    property OnGSMComplete : TApdGSMCompleteEvent
      read FOnGSMComplete write FOnGSMComplete;
  end;

  TApdGSMPhone = class(TApdCustomGSMPhone)
  public
    constructor Create(Owner : TComponent); override;
    destructor Destroy; override;

  published
    property ComPort;
    property QuickConnect;
    property GSMMode;                                                   {!!.PDU}
    property SMSAddress;
    property SMSMessage;
    property SMSCenter;
    property NotifyOnNewMessage;

    {published events}
    property OnNewMessage;
    property OnNextMessage;
    property OnMessageList;
    property OnGSMComplete;
    
  end;

  function StringToPDU (v : AnsiString) : AnsiString;                           {!!.PDU}
  function PDUToString (v : AnsiString) : AnsiString;                           {!!.PDU}

implementation

uses
  AnsiStrings;

const
  { +CMS ERROR:  =  Message Service Failure Result Code }
  GSMConfigAvail : array[0..6] of AnsiString =
              ('E0',                // Turn off echo
               '+CMGF=?',           // Support Text,PDU mode?           {!!.PDU}
               '+CMGF=',            // Set appropriate mode
               '+CSMS=0',           // Select Message Service
               //'+CPMS=?',         // Preferred Message Storage         {!!.06}

               {!!.PDU}             // Moved from GSMSendMessageCommands
               '+CNMI= 2,1,0,1,0',  // New message indication =2,1,0,1,0
                                    // or = 2,,2,,0
               '+CSMP=,167,0,0',    // variable 17 for status 32 for no status

               //'+CSCS?',          // Set Character Set                 {!!.06}
               '+CSDH=1');          // Show Text Code Parameters
               //'+CSMP?');         // Get Default values for SMS-SUBMIT {!!.06}
  GSMConfigResponse : array[0..6] of AnsiString =
              ('OK',               // No Response Expected, just OK
               '+CMGF: ',          // +CMGF:[20](0,1), 0 is PDU, 1 is Text
               'OK',               // No Response Expected, just OK
               '+CSMS: ',          // Response StartString expected
               //'+CPMS: ',        // Response StartString expected
               'OK',               // No Response Expected, just OK
               'OK',               // No Response Expected, just OK
               //'+CSCS: ', // Show default character set like "PCCP437" {!!.06}
               'OK');              // No Response Expected, just OK
               //'+CSMP: ');       // Response StartString expected      {!!.06}

  GSMSendMessageCommands : array[0..3] of AnsiString =
    { Some commands moved to GSMConfigAvail and look at QueryModem procedure}
               (//'+CNMI?',          // Default query for new message indication
                //'+CNMI= 2,1,0,1,0', // New message indication =2,1,0,1,0
                                      // or = 2,,2,,0
                //'+CSCB?',           // Types of CBMs to be received by the ME
                //'+CSMP=,167,0,0',   // variable 17 for status 32 for no status
                '',
                '+CSCA=',             // Service Center if FSMSCenter not empty
                '+CMGS=',             // Send Destination address
                '');                  // Sending message text

  GSMSendMessageResponse : array[0..3] of AnsiString =
               (//'+CNMI: ',          // Response StartString expected
                //'OK',               // No Response Expected, just OK
                //'+CSCB: ',          // Response StartString expected
                //'OK',               // No Response Expected, just OK
                'OK',                 // No Response Expected, just OK
                'OK',                 // No Response Expected, just OK
                #13#10,               // Response from phone to Send Message
                '+CMGS: ');           // Response StartString expected

  GSMListAllMessagesCommands : array[0..0] of AnsiString =
               ('+CMGL');           // List Messages on Phone
  GSMListAllMessagesResponse : array[0..0] of AnsiString =
               ('+CMGL: ');         // Response StartString expected

  GSMSendMessFromStorage : array[0..0] of AnsiString =
               ('+CMSS=');          // Send Message from Storage
  GSMSendMessFromStorageResp : array[0..0] of AnsiString =
               (#13#10'OK');        // Response StartString expected

  GSMWriteToMemoryCommands : array[0..1] of AnsiString =
               ('+CMGW=',           // Write Message to Memory
                '');                // Writing message text
  GSMWriteToMemoryResponse : array[0..1] of AnsiString =
               (#13#10,             // Response StartString expected
                '+CMGW: ');
  GSMDeleteAMessageCommand : array[0..0] of AnsiString =
               ('+CMGD=');          // Delete Message from Memory
  GSMDeleteAMessageResponse : array[0..0] of Ansistring =
               (#13#10'OK');        // No Response Expected, just OK

{ TApdSMSMessage }

function TApdSMSMessage.GetMessageAsPDU : AnsiString;
begin
  Result := StringToPDU (AnsiString(FMessage));
end;

function PDUToString (v : AnsiString) : AnsiString;
var
  I, InLen, OutLen, OutPos : Integer;
  TempByte, PrevByte : Byte;
begin
  { Check for empty input }
  if v = '' then Exit;

  { Init variables }
  PrevByte := 0;
  OutPos := 1;

  { Set length of output string }
  InLen := Length(v);
  Assert(InLen <= 140, 'Input string greater than 140 characters');
  OutLen := (InLen * 8) div 7;
  SetLength(Result, OutLen);

  { Encode output string }
  for I := 1 to InLen do begin
    TempByte := Byte(v[I]);
    TempByte := TempByte and not ($FF shl (7-((I-1) mod 7)));
    TempByte := TempByte shl ((I-1) mod 7);
    TempByte := TempByte or PrevByte;
    Result[OutPos] := AnsiChar(TempByte);
    Inc(OutPos);

    { Set PrevByte for next round (or directly put it to Result) }
    PrevByte := Byte(v[I]);
    PrevByte := PrevByte shr (7-((I-1) mod 7));
    if (I mod 7) = 0 then begin
      Result[OutPos] := AnsiChar(PrevByte);
      Inc(OutPos);
      PrevByte := 0;
    end;
  end;
  if Result[Length(Result)] = #0 then
    Result := Copy(Result, 1, pred(Length(Result)));
end;

procedure TApdSMSMessage.SetMessageAsPDU (v : AnsiString);
begin
  FMessage := string(PDUToString (v));
end;

function StringToPDU (v : AnsiString) : AnsiString;
var
  I, InLen, OutLen, OutPos : Integer;
  RoundUp : Boolean;
  TempByte, NextByte : Byte;
begin
  { Check for empty input }
  if v = '' then Exit;

  { Init OutPos }
  OutPos := 1;

  { Set length of output string }
  InLen := Length(v);
  Assert(InLen <= 160, 'Input string greater than 160 characters');
  RoundUp := (InLen * 7 mod 8) <> 0;
  OutLen := InLen * 7 div 8;
  if RoundUp then Inc(OutLen);
  SetLength(Result, OutLen);

  { Encode output string }
  for I := 1 to InLen do begin
    TempByte := Byte(v[I]);
    Assert((TempByte and $80) = 0, 'Input string contains 8-bit data');
    if (I < InLen) then
      NextByte := Byte(v[I+1])
    else
      NextByte := 0;
    TempByte := TempByte shr ((I-1) mod 8);
    NextByte := NextByte shl (8 - ((I) mod 8));
    TempByte := TempByte or NextByte;
    Result[OutPos] := AnsiChar(TempByte);
    if I mod 8 <> 0 then
      Inc(OutPos);
  end;
end;

{ TApdCustomGSMPhone }

{ opens the port, issues configuration commands }
{Generates the OnMessageList (+CMGL) event when complete if not QuickConnect}
procedure TApdCustomGSMPhone.Connect;
var
  Res : Integer;
  ET : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(secSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    CheckPort;
  end;
  if FQueryModemOnly then                                                {!!.06}
    exit;                                                                {!!.06}
  if FNotifyOnNewMessage and not Assigned(NotifyPacket) then begin{!!.02}{!!.05}
    NotifyPacket := TApdDataPacket.Create(Self);                         {!!.05}
    NotifyPacket.OnStringPacket := NotifyStringPacket;                   {!!.05}
    NotifyPacket.StartCond := scString;                                  {!!.05}
    NotifyPacket.StartString := '+CMTI:';                                {!!.05}
    NotifyPacket.EndCond := [ecString];                                  {!!.05}
    NotifyPacket.EndString := #13;                                       {!!.05}
    NotifyPacket.IncludeStrings := False;                                {!!.05}
    NotifyPacket.ComPort := FComPort;                                    {!!.05}
    NotifyPacket.Enabled := True;                                        {!!.02}
    NotifyPacket.AutoEnable := True;                                     {!!.02}
  end;                                                                   {!!.02}
  FConfigList := True;                                                   {!!.02}
  CmdIndex := 0;
  ResponsePacket.StartString := GSMConfigResponse[CmdIndex];
  ResponsePacket.EndString := #13;
  ResponsePacket.ComPort := FComPort;                                    {!!.05}
  ResponsePacket.Enabled := True;
  //DelayTicks(4, True);                                                 {!!.04}
  SetState(gsConfig);
  FComPort.Output := 'AT' + GSMConfigAvail[CmdIndex] + #13;
  NewTimer(ET, 1080); // 60 second timer
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (FGSMState = gsListAll) or (Res = wm_Quit)
        or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(secSMSTimedOut,-8101);
    Exit;
  end;
end;

constructor TApdCustomGSMPhone.Create(AOwner: TComponent);
begin
  inherited;
  { Some of the initialization for the packets were moved to Checkport to make
    sure there was a comport - Marked there with "!!.05" }

  FConnected := False;
  FNeedNewMessage := 0;                                                  {!!.04}
  FRecNewMess := '';                                                     {!!.06}
  FQueryModemOnly := False;                                              {!!.06}
  FHandle := AllocateHWnd(WndProc);
  FMessageStore := TApdMessageStore.Create(Self);
  FComPort := SearchComPort(Owner);
end;

destructor TApdCustomGSMPhone.Destroy;
begin
  FConnected := False;
  ResponsePacket.Free;
  ErrorPacket.Free;
  NotifyPacket.Free;                                                     {!!.02}
  FMessageStore.Clear;
  FMessageStore.Free;
  DeallocateHwnd(FHandle);
  inherited;
end;

{!!.PDU}
procedure TApdCustomGSMPhone.SetPDUMode (v : Boolean);
begin
  if v <> FPDUMode then
    FPDUMode := v;
end;

{ +CMS ERROR: message Service Failure Result Code }
procedure TApdCustomGSMPhone.ErrorStringPacket(Sender: TObject;
  Data: Ansistring);
var
  ErrorCode : Integer;
  ErrorMessage : string;
  Temp : AnsiString;
begin
  //Display Message Service Failure Result Code
  Temp := Data;
  if Temp <> '' then begin                                               {!!.06}
    Temp := Copy(Data, Pos(' ', string(Data)), Length(Data));
    ErrorCode := -8000 - StrToInt(string(Temp));
    ErrorMessage := 'Phone error <refer to AdExcept.inc>';               {!!.06}
  end else begin                                                         {!!.06}
    ErrorCode := -8500;                                                  {!!.06}
    ErrorMessage := 'Unknown Error';                                     {!!.06}
  end;                                                                   {!!.06}
  DoFail(ErrorMessage, ErrorCode);                                       {!!.06}
  //raise Exception.Create('Exception ' + IntToStr(ErrorCode) + ' ' +    {!!.06}
                          //ErrorMessage);                               {!!.06}
end;

procedure TApdCustomGSMPhone.ResponseStringPacket(Sender: TObject;
  Data: Ansistring);
begin
  // Handle data from packet -State Machine-
  ResponseStr := Data;
  PostMessage(FHandle, ApdGSMResponse, 0,0);
end;

procedure TApdCustomGSMPhone.NotifyStringPacket(Sender: TObject;         {!!.02}
  Data: AnsiString);                                                         {!!.02}
var                                                                      {!!.02}
  MessageIndex : Integer;                                                {!!.02}
begin                                                                    {!!.02}
  NotifyStr := Data;                                                     {!!.02}
  if NotifyStr <> '' then begin                                          {!!.02}
    if assigned(FOnNewMessage) then begin                                {!!.02}
      NotifyStr := Copy(NotifyStr,
        Pos('",', string(NotifyStr)) + 2, Length(NotifyStr));                    {!!.02}
      MessageIndex := StrToInt(string(NotifyStr));                               {!!.02}
      //if Assigned(FOnNewMessage) then begin                            {!!.02}
      { if OnNewMessage event then PostMessage to Synchronize/ListAllMessages }
      FNeedNewMessage := MessageIndex;                                   {!!.04}
      PostMessage(FHandle, ApdGSMResponse, 1,0);                         {!!.04}
//      FOnNewMessage(Self, MessageIndex, TheMessage);           {!!.02} {!!.04}
      //end;                                                     {!!.04} {!!.06}
    end;                                                                 {!!.02}
  end;                                                                   {!!.02}
end;                                                                     {!!.02}

{ issues +CMGL to list all messages with a Status of ssUnsend}
procedure TApdCustomGSMPhone.ListAllMessages;
var
  Res : Integer;
  ET : EventTimer;
begin
  if FQuickConnect then                                                  {!!.06}
    exit;                                                                {!!.06}
  if FGSMState > gsNone then begin
    DoFail(secSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    DoFail(secBadOperation,-8302);
    Exit;
  end;
  CmdIndex := 0;
  SetState(gsListAll);
  FMessageStore.ClearStore;
  FComPort.FlushInBuffer;
  ResponsePacket.StartCond := scAnyData;                                 {!!.02}
  //ResponsePacket.StartString := #13#10;                                {!!.02}
  //ResponsePacket.StartString := '+CMGL: ';                             {!!.02}
  ResponsePacket.EndString := #13#10'OK'#13#10;                          {!!.02}
  ResponsePacket.IncludeStrings := True;                                 {!!.04}
  ResponsePacket.Enabled := True;
  //DelayTicks(4, True);                                                 {!!.04}
  FComPort.Output := 'AT' + GSMListAllMessagesCommands[CmdIndex] + #13;
  NewTimer(ET, 1080); // 60 second timer
  DelayTicks(1, True);                                                   {!!.06}
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (Res = wm_Quit) or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(secSMSTimedOut,-8101);
    Exit;
  end;
end;

{ issues +CMSS to send message from storage indexed by Index }
procedure TApdCustomGSMPhone.SendFromMemory(TheIndex: Integer);
var
  Res : Integer;
  ET : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(secSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
  end;
  CmdIndex := 0;
  SetState(gsSendFStore);
  ResponsePacket.StartString := '+CMSS: ';
  ResponsePacket.EndString := #13#10'OK';
  ResponsePacket.ComPort := FComPort;
  ResponsePacket.Enabled := True;
  //DelayTicks(4, True);                                                 {!!.04}
  FComPort.Output := AnsiString('AT' + string(GSMSendMessFromStorage[CmdIndex]) +
                     IntToStr(TheIndex) + #13);
  NewTimer(ET, 1080); // 60 second timer
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (Res = wm_Quit) or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(secSMSTimedOut,-8101);
    Exit;
  end;
end;

{ issues +CMGS to send message without placing the message in memory }
procedure TApdCustomGSMPhone.SendMessage;
var
  Res : Integer;
  ET : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(secSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    Connect;
  end;
  //if FNotifyOnNewMessage then                                   {!!.01}{!!.06}
  //  CmdIndex := 0                                               {!!.01}{!!.06}
  //else                                                          {!!.01}{!!.06}
    //CmdIndex := 1; // Handled in the gsConfig                          {!!.06}
  CmdIndex := 0;                                                         {!!.06}
  ResponsePacket.EndString := #13;                                       {!!.01}
  ResponsePacket.StartString := GSMSendMessageResponse[CmdIndex];
  ResponsePacket.Enabled := True;
  //DelayTicks(4, True);                                                 {!!.04}
  SetState(gsSend);
  FComPort.Output := 'AT' + GSMSendMessageCommands[CmdIndex] + #13;
  NewTimer(ET, 1080); // 60 second timer
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (Res = wm_Quit) or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(secSMSTimedOut,-8101);
    Exit;
  end;
end;

procedure TApdCustomGSMPhone.SetMessage(const Value: string);
begin
  if Length(Value) > 160 then begin
    DoFail(secSMSTooLong,-8102);
    Exit;
  end;
  FMessage := Value;
end;

{ enables/disables new message notification (+CNMI), new messages provided
  through OnNewMessage event }
procedure TApdCustomGSMPhone.SetNotifyOnNewMessage(const Value: Boolean);
begin
  FNotifyOnNewMessage := Value;
     // Return True for then +CMTI for New Message Indications to TE
end;

{ TApdMessageStore }
function TApdMessageStore.AddMessage(const Dest, Msg: string): Integer;
var
  SMS : TApdSMSMessage;
begin
  SMS := nil;
  try
    SMS := TApdSMSMessage.Create;
    SMS.Message := Msg;
    SMS.Address := Dest;
    SMS.TimeStampStr := FormatDateTime('yy/mm/dd/hh:mm:ss', Now);
    SMS.Status := ssUnsent;

    Result := AddObject(SMS.TimeStampStr, SMS);
  finally
    SMS.Free;
  end;
end;

{ Clear all Messages }
procedure TApdMessageStore.Clear;
begin
 inherited;exit;
  // Clear All messages
  while Count > 0 do begin
    if Objects[Count - 1] <> nil then begin
      TApdSMSMessage(Objects[Count - 1]).Free;
      Objects[Count - 1] := nil;
    end;
    Delete(Count - 1);
  end;
end;

{ Just clears our message store - not the phone }
procedure TApdMessageStore.ClearStore;
begin
  JustClearStore := True;
  Clear;
  JustClearStore := False;
end;

{ Create Message Store }
constructor TApdMessageStore.Create(GSMPhone : TApdCustomGSMPhone);
begin
  FGSMPhone := GSMPhone;
  JustClearStore := False;
end;

{ issues +CMGD to Delete Message at Index }
procedure TApdMessageStore.Delete(PhoneIndex: Integer);
var
  I : Integer;
begin
  if (FGSMPhone.FConnected) and not(JustClearStore) then
    FGSMPhone.DeleteFromMemoryIndex(PhoneIndex)
  else begin
    for I := 0 to pred(Count) do
      if Messages[I].MessageIndex = PhoneIndex then
        Break;
    if I < Count then begin
      if Objects[I] <> nil then begin
        TApdSMSMessage(Objects[I]).Free;
        Objects[I] := nil;
      end;
      inherited Delete(I);
    end;
  end;
end;

{ Return the phone's message store capacity }
function TApdMessageStore.GetCapacity: Integer;
begin
  result := FCapacity;
end;

{ Get message number of Index }
function TApdMessageStore.GetMessage(Index: Integer): TApdSMSMessage;
begin
  Result := TApdSMSMessage(Objects[Index]);
end;

{ issues + to send all messages with a Status of ssUnsent }
procedure TApdCustomGSMPhone.SendAllMessages;
var
  Res : Integer;
  HighIndex: Integer;
  I: Integer;
begin
  if FGSMState > gsNone then begin
    DoFail(secSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit);
  end;
  CmdIndex := 0;
  { tell the GSMPhone to send all messages in it's store }
  HighIndex := FMessageStore.GetCapacity;
  for I := 0 to HighIndex do begin
    SendFromMemory(I);
  end;
end;

procedure TApdCustomGSMPhone.ProcessResponse;

  { Convert String to Integer }
  function GSMStrToInt(Str : AnsiString) : Integer;
  begin
    while Pos(' ', string(Str)) > 0 do
      Str[Pos(' ', string(Str))] := '0';
    Result := StrToInt(string(Str));
  end;

var
  S : AnsiString;
  STemp : AnsiString;
  MsgRdy : Boolean;
  PDULength : Integer;                                                  {!!.PDU}

  { Get next field in message }
  function GetNextField( aDelimiter: AnsiString ): AnsiString;
  var
    aDelimiterPosition: Integer;
  begin
  {To retrieve the text from position 1 until the occurance of aDelimiter
   while advancing the pointer in S so that we can just call this function
   again and again. }
    if S[1] = '"' then begin
      aDelimiter := '"' + aDelimiter;
    end;
    aDelimiterPosition := Pos( aDelimiter, S );
    Result := Copy( S, 1, aDelimiterPosition - 1 );

    if ( Result <> '' ) and ( Result[ 1 ] = '"' ) then
      Result := Copy( Result, 2, Length( Result ) );
    if ( Result <> '' ) and ( Result[ Length( Result ) ] = '"' )then
      Result := Copy( Result, 1, Length( Result ) - 1 );

    S := Copy( S, aDelimiterPosition + Length( aDelimiter ), Length( S ));
  end;

  { Build a PDU message !!.PDU}
  function BuildPDUMessage : AnsiString;
  var
    TheLength, I: Integer;
    TheNextOctet, S: AnsiString;
    T: AnsiString;
  begin
    TheLength := Length(FSMSCenter);
    if Odd(TheLength) then
      TheLength := TheLength + 1;
    if FSMSCenter = '' then
      // No SMSCenter needed
      FTempWriteMess := '00'
    else begin
      // Add the length of SMSCenter in octets
      FTempWriteMess := AnsiString('0' + IntToStr((TheLength Div 2) + 1));
      if Length(FSMSCenter) > 10 then begin
        FTempWriteMess := FTempWriteMess + '91'; // International format
      end else begin
        FTempWriteMess := FTempWriteMess + '81'; // Let phone handle format
      end;
      I := 1;
      // Add SMSCenter to PDU message
      while I < Length(FSMSCenter) do begin
        TheNextOctet := AnsiString(FSMSCenter[I+1] + FSMSCenter[I]);
        FTempWriteMess := FTempWriteMess + TheNextOctet;
        I := I + 2;
      end;
      if Odd(Length(FSMSCenter)) then
        FTempWriteMess := FTempWriteMess + AnsiString('F' + FSMSCenter[Length(FSMSCenter)]);
    end;
    //FirstOctet
    FTempWriteMess := FTempWriteMess + '11';
    // Lets the phone set the message reference number itself
    FTempWriteMess := FTempWriteMess + '00';
    TheLength := Length(FSMSAddress);
    S := AnsiString(Format ('%02.2x', [TheLength]));
    FTempWriteMess := FTempWriteMess + S;
    // Add SMSAddress to PDU message
    if Length(FSMSAddress) > 10 then
      FTempWriteMess := FTempWriteMess + '91' // International format
    else
      FTempWriteMess := FTempWriteMess + '81'; // Let phone handle format
    I := 1;
    while I < Length(FSMSAddress) do begin
      TheNextOctet := AnsiString(FSMSAddress[I+1] + FSMSAddress[I]);
      FTempWriteMess := FTempWriteMess + TheNextOctet;
      I := I + 2;
    end;
    if Odd(Length(FSMSAddress)) then
      FTempWriteMess := FTempWriteMess + AnsiString('F' + FSMSAddress[I]);
    // Protocol identifier
    FTempWriteMess := FTempWriteMess + '00';
    // Datacoding scheme
    FTempWriteMess := FTempWriteMess + '00';
    // Optional validity period.
    FTempWriteMess := FTempWriteMess + 'AA'; //"AA" means 4 days.

    // Length of SMS message converted to HEX
    TheLength := Length(FMessage);
    S := AnsiString(Format ('%02.2x', [TheLength]));
    FTempWriteMess := FTempWriteMess + S;
    T := '';
    // Add SMSMessage after transformation to PDU string
    S := StringToPDU(AnsiString(FMessage));
    for I := 1 to Length(S) do begin
        T := T + AnsiString(IntToHex(Byte(S[I]), 2));
    end;
    FTempWriteMess := FTempWriteMess + T;
    PDULength := Length(FTempWriteMess) DIV 2 - 1;
  end;

  { Parse PDU message } {!!.PDU}
  function ParseAPDUMessage : Boolean;
  var
    St, TempS, TempStaID, U: AnsiString;
    T, TheMessage: AnsiString;
    NumLength, I, TempI, MessageLength : Integer;
  begin
    // Make sure we are not at the end of the last message
    if Pos (#13#10, string(S)) = 1 then
      GetNextField (#13#10);
    // Make sure we are at the beginning of a message
    if Pos('+CMGL:', string(S)) = 1 then begin
      // Build the SMS message while reading
      TempSMSMessage := TApdSMSMessage.Create;
      // format is +CMGL: Index, status, address, address name, timestamp
      S := Copy(S, Pos(':', string(S)) + 1, Length(S));
      // extract the index number
      TempSMSMessage.FMessageIndex := GSMStrToInt(GetNextField(','));
      //Let the phone handle the status
      //TempSMSMessage.FStatus := GSMStrToInt(GetNextField(','));
      GetNextField(#13#10);
      // Assign PDU stuff to TempS
      TempS := GetNextField(#13#10);
      NumLength := StrToInt(Copy(string(TempS), 0, 2));
      I := 0;
      //NumLength is length of center number, in octets
      if NumLength > 0 then begin
        // Next two digits is Type-of-Address octet
//        I := StrToInt(Copy(string(TempS), 3, 2));
        // I is the Type-of-Address octet
//        case I of
//          91 : begin
//
//          end;
//          81 : begin
//
//          end;
//        end; // End Case
        // NumLength = length of center phone number
        TempStaID := '';
        I := 5;
        while I < (NumLength*2 + 3) do begin
          if TempS[I] = 'F' then
            TempStaID := TempStaID + TempS[I+1]
          else
            TempStaID := TempStaID + TempS[I+1] + TempS[I];
          I := I + 2;
        end;
        // TempStaID is the Center Address at this point
      end else begin
        STemp := Copy(STemp, 3, Length(STemp));
      end;
      // TempI = octet is First Octet of SMS-Deliver PDU
      TempI := StrToInt(Copy(string(TempS), I, 2));
      // Get next octet
      TempS := Copy(TempS, I+2, Length(TempS));
      St := Copy(TempS, 0, 2);
      case TempI of
        4 : begin // This PDU is a SMS delivery

        end;
        11: begin // Message ready to send
          if St = '00' then begin
          // The "00" lets the phone set the message reference number.
            TempS := Copy(TempS, 3, Length(TempS));
            St := Copy(TempS, 0, 2);
          end;
        end;
        24: begin // Status report indication returned

        end;
      end; // End Case
      //Address-Length. Length of the sender number (0B hex = 11 dec)
      NumLength := (StrToInt('$' + string(St)));
      // Next two digits is Type-of-Address octet
//      I := StrToInt('$' + Copy(string(TempS), 3, 2));
//      case I of
//        133 : begin
//          // 85 in Hex = Voice mail ?
//        end;
//        145 : begin
//          // 91 in Hex
//        end;
//        129 : begin
//          // 81 in Hex
//        end;
//        200 : begin
//          // C8 in Hex
//        end;
//      end; // End Case
      // NumLength = Length of phone number
      TempStaID := '';
      if Odd(NumLength) then
        NumLength := NumLength + 1;
      // Change NumLength to Octets
      NumLength := NumLength Div 2;
      I := 5;
      while I < (NumLength*2 + 5) do begin
        if TempS[I] = 'F' then
          TempStaID := TempStaID + TempS[I+1]
        else
          TempStaID := TempStaID + TempS[I+1] + TempS[I];
        I := I + 2;
      end;
      // TempStaID is the StationID at this point
      TempSMSMessage.FAddress := string(TempStaID);
      // Protocol identifier of "00" and Data coding scheme of "00"
      // are the 2 octets or the 4 added to I, below
      I := I + 4; // start of time stamp
      St := '';
      if TempS[I] = 'A' then begin
        // No time stamp - not sent yet
        TempI := I + 2;
      end else begin
        St := TempS[I+1]  + TempS[I]    + '/' +    // Year
              TempS[I+3]  + TempS[I+2]  + '/' +    // Month
              TempS[I+5]  + TempS[I+4]  + ',' +    // Day
              TempS[I+7]  + TempS[I+6]  + ':' +    // Hours
              TempS[I+9]  + TempS[I+8]  + ':' +    // Minutes
              TempS[I+11] + TempS[I+10] + '+' +    // Seconds
              TempS[I+13] + TempS[I+12];           // Time Zone
        // 14 is length of time stamp - Keeping track where we are in TempS
        TempI := I + 14;
        TempSMSMessage.FTimeStampStr := string(St);
      end;
      // Get next octet
      St := TempS[TempI] + TempS[TempI + 1];
      // MessageLength
      MessageLength := StrToInt('$' + string(St));
      // U is the message
      U := Copy(TempS,TempI+2,Length(TempS));
      // NumLength is the length of the message
      NumLength := Length(U);
      // Set pointer to start of message
      I := 1;
      T := '';
      while I < NumLength do begin
        St := AnsiString('$' + string(U[I] + U[I+1]));
        TempI := StrToInt(string(St));
        T := T + AnsiChar(TempI);
        I := I + 2;
      end;
      // Change message to string form
      TheMessage := PDUToString(T);
      if MessageLength = Length(TheMessage) then
        // Store message
        TempSMSMessage.FMessage := string(TheMessage);
    end; // else our PDU should handle longer messages
    if TempSMSMessage.FMessageIndex = FNeedNewMessage then
    // if new message notify wanted, then assign it
      FRecNewMess := TempSMSMessage.Message;
    MessageStore.AddObject(TempSMSMessage.TimeStampStr, TempSMSMessage);
    Result := Pos('+CMGL:', string(S)) > 0;
  end;

  { Parse a message }
  function ParseAMessage : Boolean;
  begin
    if Pos (#13#10, string(S)) = 1 then
      GetNextField (#13#10);
    if Pos('+CMGL:', string(S)) = 1 then begin
      // first line of the message
      // format is +CMGL: Index, status, address, address name, timestamp
      TempSMSMessage := TApdSMSMessage.Create;
      S := Copy(S, Pos(':', string(S)) + 1, Length(S));
      // extract the index number
      TempSMSMessage.FMessageIndex := GSMStrToInt(GetNextField(','));
      // extract the status
      STemp := GetNextField( ',' );
      if STemp = 'STO UNSENT' then TempSMSMessage.FStatus := ssUnsent
      else if STemp = 'STO SENT' then TempSMSMessage.FStatus := ssSent
      else if STemp = 'ALL' then TempSMSMessage.FStatus := ssAll
      else if STemp = 'REC UNREAD' then TempSMSMessage.FStatus := srUnread
      else if STemp = 'REC READ' then TempSMSMessage.FStatus := srRead
      else TempSMSMessage.FStatus := ssUnknown;                          {!!.01}

      // Read the address field with quotes (if any)
      TempSMSMessage.FAddress := string(GetNextField( ',' ));
      // Name (??) field  followed by ,
      TempSMSMessage.FName := string(GetNextField( ',' ));
      // DateTime Field followed by ,
      TempSMSMessage.FTimeStampStr := string(GetNextField( ',' ));
      if TempSMSMessage.FTimeStampStr = '' then
        TempSMSMessage.FTimeStampStr := '<no timestamp>';
      // Message Type   followed by ,
      STemp := GetNextField( ',' );
      // Message Length followed by #13#10
      STemp := GetNextField( #13#10 );
      // Message        followed by #13#10
      TempSMSMessage.Message := string(GetNextField( #13#10 ));
    end else begin
      // Message more than 1 line???
      TempSMSMessage.Message := TempSMSMessage.Message + #13#10 +
                      string(GetNextField( #13#10 ));
    end;
    if TempSMSMessage.FMessageIndex = FNeedNewMessage then               {!!.06}
        FRecNewMess := TempSMSMessage.Message;                           {!!.06}
    MessageStore.AddObject(TempSMSMessage.TimeStampStr, TempSMSMessage);
    Result := Pos('+CMGL:', string(S)) > 0;                                      {!!.04}
  end;

begin
  //State machine response handle
  case FGSMState of

    gsConfig: begin
                S := ResponseStr;                                       {!!.PDU}
                inc(CmdIndex);
                STemp := '';                                            {!!.PDU}
                if CmdIndex > High(GSMConfigAvail) then begin
                    // generate the OnComplete event, we're done configuring
                  ResponseStr := '';                                     {!!.02}
                  if not FQuickConnect then begin                        {!!.02}
                    // State set to gsNone in PostMessage below
                    //FGSMState := gsNone;                        {!!.02}{!!.06}
                    // PostMessage calls ListAllMessages
                    PostMessage(FHandle, ApdGSMResponse, 1,0);           {!!.06}
                    //ListAllMessages;                            {!!.02}{!!.06}
                  end;                                                   {!!.02}
                  FGSMState := gsConfig;                                 {!!.02}
                  if Assigned(FOnGSMComplete) then                       {!!.02}
                    FOnGSMComplete(Self, FGSMState, FErrorCode);         {!!.02}
                  FGSMState := gsNone;
                  FConfigList := False;                                  {!!.02}
                  ResponseStr := '';
                end else begin
                  // send the next command
                  ResponsePacket.StartString := GSMConfigResponse[CmdIndex];
                  ResponsePacket.EndString := #13;
                  ResponsePacket.Enabled := True;
                  //DelayTicks(4, True);                                 {!!.04}
                  STemp := GSMConfigAvail[CmdIndex];                     {!!.06}
                  // Detect, PDU, or Text
                  if STemp = '+CMGF=' then begin                        {!!.PDU}
                    STemp := Copy(S, Pos('(',string(S))+1, Length(S));          {!!.PDU}
                    if Length(STemp) < 3 then begin                     {!!.PDU}
                      if (FGSMMode = gmPDU) and (STemp[1] = '0') then   {!!.PDU}
                        SetPDUMode(True)                                {!!.PDU}
                      else                                              {!!.PDU}
                        if (STemp[1] = '1') then                        {!!.PDU}
                          SetPDUMode(False);                            {!!.PDU}
                    end else begin                                      {!!.PDU}
                      if (FGSMMode = gmPDU) and (STemp[3] = '1') then   {!!.PDU}
                        SetPDUMode(True)                                {!!.PDU}
                      else                                              {!!.PDU}
                        SetPDUMode(False);                              {!!.PDU}
                    end;                                                {!!.PDU}
                    STemp := GSMConfigAvail[CmdIndex];                  {!!.PDU}
                  end;                                                  {!!.PDU}
                  if STemp = '+CMGF=' then begin                        {!!.PDU}
                    if FPDUMode then                                    {!!.PDU}
                      STemp := STemp + '0'                              {!!.PDU}
                    else                                                {!!.PDU}
                      STemp := STemp + '1';                             {!!.PDU}
                    if QuickConnect then                                {!!.PDU}
                      CmdIndex := High(GSMConfigAvail);                 {!!.PDU}
                  end;                                                  {!!.PDU}
                  if Copy(STemp, 1, 6) = '+CSMP=' then begin             {!!.06}
                    if NotifyOnNewMessage then                           {!!.06}
                      STemp := '+CSMP= 32' +                             {!!.06}
                                    Copy(STemp, 7, Length(STemp))        {!!.06}
                    else                                                 {!!.06}
                      STemp := '+CSMP= 17' +                             {!!.06}
                                    Copy(STemp, 7, Length(STemp));       {!!.06}
                  end;                                                   {!!.06}
                  FComPort.Output := 'AT' + STemp + #13;
                end;
              end;

    gsSend: begin
              inc(CmdIndex);
              if CmdIndex > High(GSMSendMessageResponse) then begin
                // Sent message - see if another message is ready
                if Assigned(FOnNextMessage) then begin
                  MsgRdy := False;
                  FOnNextMessage(Self, FErrorCode, MsgRdy);
                  if MsgRdy then begin
                    { Will inc(CmdIndex) and start with the CSCA setting }
                    CmdIndex := 0; // start sending over                 {!!.06}
                    PostMessage(FHandle, ApdGSMResponse, 2,0);           {!!.06}
                  end;
                end;
                // generate the OnComplete event, we're done
                if Assigned(FOnGSMComplete) then begin
                  FOnGSMComplete(Self, FGSMState, FErrorCode);
                end;
                FGSMState := gsNone;
                ResponseStr := '';                                       {!!.02}
              end else begin

                if CmdIndex = High(GSMSendMessageCommands) - 1 then begin
                  // send the next command
                  ResponsePacket.StartString :=
                      GSMSendMessageResponse[CmdIndex];
                  ResponsePacket.EndString := '>'#32;
                  ResponsePacket.Enabled := True;
                  if FPDUMode then begin                                {!!.PDU}
                    BuildPDUMessage;                                    {!!.PDU}
                    STemp := AnsiString(IntToStr(PDULength));                       {!!.PDU}
                  end else begin                                        {!!.PDU}
                    //DelayTicks(4, True);                               {!!.04}
                    STemp := AnsiString(SMSAddress);
                    if STemp = '' then begin                             {!!.02}
                      DoFail(secBadOperation,-8302);                     {!!.02}
                      Exit;                                              {!!.02}
                    end;                                                 {!!.02}
                    if STemp[1] <> '"' then {begin}              {!!.01} {!!.06}
                      STemp := '"' + STemp + '"';                {!!.01} {!!.06}
                    //else                                               {!!.01}
                      //if S[2] <> '+' then                              {!!.01}
                        //S := '"+' + S + '"';                           {!!.01}
                    //end;                                               {!!.01}
                    STemp := STemp + #13#10;
                  end;
                  FComPort.Output := 'AT' + GSMSendMessageCommands[CmdIndex]
                                        + STemp + #13;                   {!!.06}
                end else begin
                  if CmdIndex = High(GSMSendMessageCommands) then begin
                    ResponsePacket.StartString :=
                        GSMSendMessageResponse[CmdIndex];
                    ResponsePacket.EndString := #13#10;
                    ResponsePacket.Enabled := True;
                    //DelayTicks(4, True);                               {!!.04}
                    if FPDUMode then begin                              {!!.PDU}
                      STemp := FTempWriteMess;                          {!!.PDU}
                    end else                                            {!!.PDU}
                      STemp := AnsiString(FMessage);
                    if STemp[Length(STemp)] <> #26 then
                      STemp := STemp + #26;
                    FComPort.Output := STemp;
                  end else begin
                    ResponsePacket.StartString :=
                        GSMSendMessageResponse[CmdIndex];
                    ResponsePacket.Enabled := True;
                    //DelayTicks(4, True);                               {!!.04}
                    if GSMSendMessageCommands[CmdIndex] = '+CSCA=' then begin
                      if (FSMSCenter <> '') and
                      (GSMSendMessageCommands[CmdIndex]='+CSCA=') then begin
                        if FSMSCenter[1] = '"' then {begin}              {!!.01}
                          FSMSCenter := copy(FSMSCenter, 2, Length(FSMSCenter));
                          {*if FSMSCenter[2] = '+' then
                            {FSMSCenter := copy(FSMSCenter, 3,
                                               {Length(FSMSCenter));*}   {!!.01}
                        if FSMSCenter[Length(FSMSCenter)] = '"' then     {!!.01}
                          FSMSCenter := copy(FSMSCenter, 1,              {!!.01}
                                               Length(FSMSCenter)-1);    {!!.01}
                        //end;                                           {!!.01}
                        FComport.Output := AnsiString('AT' +
                                string(GSMSendMessageCommands[CmdIndex])+'"'     {!!.01}
                                           + FSMSCenter + '"' + #13)
                      end else begin
                        inc(CmdIndex);
                        ResponsePacket.StartString :=
                            GSMSendMessageResponse[CmdIndex];
                        ResponsePacket.EndString := '>'#32;
                        ResponsePacket.Enabled := True;
                        //DelayTicks(4, True);                           {!!.04}
                        if FPDUMode then begin                          {!!.PDU}
                          BuildPDUMessage;                              {!!.PDU}
                          S := AnsiString(IntToStr(PDULength));                     {!!.PDU}
                        end else begin                                  {!!.PDU}
                          S := AnsiString(SMSAddress);
                          if S = '' then begin                           {!!.02}
                            DoFail(secBadOperation,-8302);               {!!.02}
                            Exit;                                        {!!.02}
                          end;                                           {!!.02}
                          if S[1] <> '"' then {begin}                    {!!.01}
                            S := '"' + S + '"';                          {!!.01}
                          //else                                         {!!.01}
                            //if S[2] <> '+' then                        {!!.01}
                              //S := '"+' + S + '"';                     {!!.01}
                          //end;                                         {!!.01}
                        end;                                            {!!.PDU}
                        S := S + #13;
                        FComPort.Output := 'AT' +
                                   GSMSendMessageCommands[CmdIndex] + S;
                      end
                    end else
                      FComPort.Output := 'AT' + STemp + #13;
                  end
                end
              end;
              STemp := '';
            end;
    gsListAll : begin
                  // Just sent +CMGL, successful so far, send the next command
                  S := ResponseStr;
                  if Length(S) > 8 then begin                            {!!.02}
                    if FGSMMode = gmPDU then begin                       {!!.06}
                      while ParseAPDUMessage do                          {!!.06}
                        DelayTicks(1, True);                             {!!.06}
                    end else                                             {!!.06}
                      while ParseAMessage do                             {!!.02}
                        DelayTicks(1, True);                             {!!.02}
                  end;
                  if FNeedNewMessage > 0 then begin                      {!!.04}
                    if Assigned(FOnNewMessage) then                      {!!.04}
                      FOnNewMessage
                        (Self, FNeedNewMessage, FRecNewMess);            {!!.06}
                    FNeedNewMessage := 0;                                {!!.04}
                    FRecNewMess := '';                                   {!!.06}
                  end else begin                                         {!!.04}
                    if Assigned(FOnMessageList) then
                      FOnMessageList(Self);
                    if Assigned(FOnGSMComplete) and not FConfigList then {!!.02}
                      FOnGSMComplete(Self, FGSMState, FErrorCode);
                  end;
                  ResponsePacket.IncludeStrings := False;
                  ResponsePacket.StartCond := scString;                  {!!.02}
                  FGSMState := gsNone;
                  ResponseStr := '';                                     {!!.02}
                end;

    gsSendFStore : begin
                     //Just sent +CMSS, successful so far, send the next command
                     inc(CmdIndex);
                     if CmdIndex > High(GSMSendMessFromStorage) then begin
                       // generate the OnComplete event, we're done
                       //FMessageStore.ClearStore;                       {!!.06}
                       //Synchronize;                                    {!!.06}
                       if Assigned(FOnMessageList) then
                         FOnMessageList(Self);
                       if Assigned(FOnGSMComplete) then
                         FOnGSMComplete(Self, FGSMState, FErrorCode);
                       FGSMState := gsNone;
                       ResponseStr := '';                                {!!.02}
                     end else
                       // send the next command if there is one
                       FComPort.Output := 'AT' +
                                     GSMSendMessFromStorage[CmdIndex] + #13;
                   end;
    gsWrite : begin
                // Just sent +CMGW, successful so far, send the next command
                inc(CmdIndex);
                if CmdIndex > High(GSMWriteToMemoryCommands) then begin
                  //FMessageStore.ClearStore;                            {!!.06}
                  //Synchronize;                                         {!!.06}
                  if Assigned(FOnMessageList) then
                    FOnMessageList(Self);
                  // generate the OnComplete event, we're done configuring
                  if Assigned(FOnGSMComplete) then
                    FOnGSMComplete(Self, FGSMState, FErrorCode);
                  // PostMessage will synchronize and list all messages
                  PostMessage(FHandle, ApdGSMResponse, 1,0);             {!!.06}
                  FGSMState := gsNone;                                   {!!.02}
                  ResponseStr := '';                                     {!!.02}
                end else
                  if (CmdIndex < High(GSMWriteToMemoryCommands)) then begin
                    BuildPDUMessage;                                    {!!.PDU}
                    STemp := AnsiString(IntToStr(PDULength));                       {!!.PDU}
                    inc(CmdIndex);                                      {!!.PDU}
                    FComPort.Output := 'AT' +
                      GSMWriteToMemoryCommands[CmdIndex] + STemp + #13;
                  end else begin
                    // send the next command
                    ResponsePacket.StartString :=
                        GSMWriteToMemoryResponse[CmdIndex];
                    ResponsePacket.EndString := #13#10;
                    ResponsePacket.Enabled := True;
                    if FTempWriteMess[Length(FTempWriteMess)] <> #26 then
                        FTempWriteMess := FTempWriteMess + #26;
                    FComPort.Output := FTempWriteMess;
                  end;
              end;
    gsDelete : begin
                 { Just sent +CMGD=,successful so far, send the next command}
                 inc(CmdIndex);
                 if CmdIndex > High(GSMDeleteAMessageCommand) then begin
                   // generate the OnComplete event, we're done
                   //ResponsePacket.IncludeStrings := False;             {!!.01}
                   //FMessageStore.ClearStore;                           {!!.06}
                   //Synchronize;                                        {!!.06}
                   if Assigned(FOnMessageList) then
                     FOnMessageList(Self);
                   if Assigned(FOnGSMComplete) then
                     FOnGSMComplete(Self, FGSMState, FErrorCode);
                   // State set to gsNone in PostMessage below
                   //FGSMState := gsNone;                         {!!.02}{!!.06}
                   ResponseStr := '';                                    {!!.02}
                   // PostMessage will synchronize and list all messages
                   PostMessage(FHandle, ApdGSMResponse, 1,0);            {!!.06}
                 end else
                   // send the next command
                   FComPort.Output := 'AT' + GSMDeleteAMessageCommand[CmdIndex]
                                      + #13;
               end;
  end; // End Case
end;

{ issues +CMGW to write message secified by FMessage and DestAddr to the phone
  memory, memory location returned as function result }
procedure TApdCustomGSMPhone.WriteToMemory(const Dest, Msg: AnsiString);
var
  S   : AnsiString;
  Res : Integer;
  ET  : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(secSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit);
  end;
  SetState(gsWrite);
  ResponsePacket.StartString := GSMWriteToMemoryResponse[CmdIndex];
  ResponsePacket.EndString := '>'#32;
  ResponsePacket.Enabled := True;
  //DelayTicks(4, True);                                                 {!!.04}
  S := Dest;
  if S[1] <> '"' then begin
    if S[1] = '+' then
      S := '"' + S + '"';
  end;
  if FGSMMode = gmPDU then begin                                        {!!.PDU}
    FSMSAddress := string(Dest);                                                {!!.PDU}
    FMessage := string(Msg);                                                    {!!.PDU}
    PostMessage(FHandle, ApdGSMResponse, 0,0);                          {!!.PDU}
    CmdIndex := CmdIndex - 2;                                           {!!.PDU}
  end else begin
    FComPort.Output := 'AT' + GSMWriteToMemoryCommands[CmdIndex] + S + #13;
    NewTimer(ET, 1080); // 60 second timer
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit) or TimerExpired(ET);
    if TimerExpired(ET) then begin
      DoFail(secSMSTimedOut,-8101);
      Exit;
    end;
  end;
end;

procedure TApdCustomGSMPhone.WndProc(var Message: TMessage);
begin
  with Message do begin
    if Msg = ApdGSMResponse then begin
      Message.Result := 1;                                               {!!.06}
      case WParam of                                                     {!!.04}
      0 : ProcessResponse;
      1 : begin                                                          {!!.04}
            SetState(gsNone);                                            {!!.06}
            DelayTicks(1, True);                                         {!!.06}
            ListAllMessages;                                             {!!.04}
          end;                                                           {!!.04}
{Begin !!.06}
      2 : begin
            SetState(gsNone);
            DelayTicks(1, True);
            SendMessage;
          end;
{End !!.06}
      end; // End Case
    end else
      Result := DefWindowProc(FHandle, Msg, wParam, lParam);
  end;
end;

procedure TApdCustomGSMPhone.DeleteFromMemoryIndex(PhoneIndex: Integer);
var
  Res : Integer;
begin
  { Remove a single message from the phone's message store }
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit);
  end;
  CmdIndex := 0;
  SetState(gsDelete);
  //ResponsePacket.IncludeStrings := True;                               {!!.01}
  ResponsePacket.StartString := GSMDeleteAMessageCommand[CmdIndex];
  ResponsePacket.EndString := #13#10'OK';
  ResponsePacket.Enabled := True;
  //DelayTicks(4, True);                                                 {!!.04}
  FComPort.Output := AnsiString('AT' + string(GSMDeleteAMessageCommand[CmdIndex]) +
                     IntToStr(PhoneIndex) + #13);
  // go to process response
  PostMessage(FHandle, ApdGSMResponse, 0,0);                             {!!.06}
end;

procedure TApdCustomGSMPhone.CheckPort;
begin
  { Make sure comport is open }
  if Assigned(FComPort) then begin
    if (FComPort.DeviceLayer = dlWinSock) then
      { we can't do GSM through Winsock... }
      raise ECannotUseWithWinSock.Create(ecCannotUseWithWinSock, False);
    if not(FComPort.Open) then
    { open the port, let the TApdComPort raise any exceptions }
      FComPort.Open := True;
    if FQueryModemOnly then                                              {!!.06}
      exit;                                                              {!!.06}
    FGSMState := gsNone;
    FConnected := True;
    { Create a response packet, there is a port now }
    if not Assigned(ResponsePacket) then begin                           {!!.05}
      ResponsePacket := TApdDataPacket.Create(Self);                     {!!.05}
      ResponsePacket.OnStringPacket := ResponseStringPacket;             {!!.05}
      ResponsePacket.IncludeStrings := False;                            {!!.05}
      ResponsePacket.StartCond := scString;                              {!!.05}
      ResponsePacket.EndCond := [ecString];                              {!!.05}
      ResponsePacket.AutoEnable := False;                                {!!.05}
    end;
    ResponsePacket.ComPort := FComPort;                                  {!!.05}
    ResponsePacket.Enabled := False;                                     {!!.05}
    { Create an error packet, there is a port now }
    if not Assigned(ErrorPacket) then begin                              {!!.05}
      ErrorPacket := TApdDataPacket.Create(Self);                        {!!.05}
      ErrorPacket.OnStringPacket := ErrorStringPacket;                   {!!.05}
      ErrorPacket.IncludeStrings := False;                               {!!.05}
      ErrorPacket.StartCond := scString;                                 {!!.05}
      //ErrorPacket.StartString := #13#10'ERROR';                        {!!.05}
      ErrorPacket.StartString := #13#10'+CMS ERROR:';                    {!!.06}
      ErrorPacket.EndCond := [ecString];                                 {!!.05}
      ErrorPacket.EndString := #13;                                      {!!.05}
      ErrorPacket.ComPort := FComPort;                                   {!!.05}
      ErrorPacket.Enabled := True;                                       {!!.05}
      ErrorPacket.AutoEnable := True;                                    {!!.05}
    end;                                                                 {!!.05}
  end else
    raise EPortNotAssigned.Create(ecPortNotAssigned, False);
end;

procedure TApdCustomGSMPhone.Synchronize;
var
  Res : Integer;
begin
  // tell the phone to give us the message store
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit);
  end;
  FGSMState := gsNone;                                                   {!!.02}
  ListAllMessages;
end;

procedure TApdCustomGSMPhone.QueryModem;
var
  ErrorPacketExists: Boolean;
  ResponsePacketExists: Boolean;
begin
{ QueryModem is designed to test the phone/modem to see what value/result
  comes back. The responses may vary, so you can view them in the log. You can
  set logging from the TApdComPort component. Set the Logging property to tlOn
  and the LogName property to path and filename where you want the log stored.
  For example: C:\GSM.LOG; }
  FQueryModemOnly := True;                                               {!!.06}
  Connect;                                                               {!!.06}
  ErrorPacketExists := False;
  ResponsePacketExists := False;
  if Assigned(ErrorPacket) then begin
    ErrorPacket.AutoEnable := False;                                     {!!.06}
    ErrorPacket.Enabled := False;                                        {!!.06}
    ErrorPacketExists := True;
  end;
  if Assigned(ResponsePacket) then begin
    ResponsePacket.Enabled := False;                                     {!!.06}
    ResponsePacketExists := True;
  end;
  FComPort.Output := 'ATI3'#13;                                          {!!.06}
  DelayTicks(9, True);                                                   {!!.06}
  FComPort.Output := 'AT+CMGF=?'#13;                                     {!!.06}
  DelayTicks(9, True);                                                   {!!.06}
  FComPort.Output := 'AT+CSMS=?'#13;                                     {!!.06}
  DelayTicks(9, True);                                                   {!!.06}
  FComPort.Output := 'AT+CNMI=?'#13;                                     {!!.06}
  DelayTicks(9, True);                                                   {!!.06}
  FComPort.Output := 'AT+CSMP?'#13;                                      {!!.06}
  DelayTicks(9, True);                                                   {!!.06}
  FComPort.Output := 'AT+CSDH?'#13;                                      {!!.06}
  DelayTicks(9, True);                                                   {!!.06}
  FComPort.Output := 'AT+CPMS?'#13;                                      {!!.06}
  DelayTicks(9, True);                                                   {!!.06}
  FQueryModemOnly := False;                                              {!!.06}
  if ErrorPacketExists then begin                                        {!!.06}
    ErrorPacket.Enabled := True;                                         {!!.06}
    ErrorPacket.AutoEnable := True;                                      {!!.06}
  end;                                                                   {!!.06}
  if ResponsePacketExists then                                           {!!.06}
    ResponsePacket.Enabled := True;                                      {!!.06}
end;

procedure TApdMessageStore.SetMSCapacity(const Value: Integer);
begin
  FCapacity := Value;
end;

procedure TApdMessageStore.SetMessage(Index: Integer;
                                      const Value: TApdSMSMessage);
begin
  Strings[Index] := Value.FTimeStampStr;
  Objects[Index] := Value;
end;

{ Notification }
procedure TApdCustomGSMPhone.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then begin
    if AComponent = FComPort then
      FComPort := nil;
  end else begin
    if (AComponent is TApdCustomComPort) and (FComPort = nil) then
      FComPort := TApdCustomComPort(AComponent);
  end;
end;

{ Set the Service Center Address/Phone Number }
procedure TApdCustomGSMPhone.SetCenter(const Value: string);
begin
  FSMSCenter := Value;
end;

{ TApdGSMPhone - TApdSMSStatus to string conversion}
function TApdCustomGSMPhone.StatusToStr(StatusString: TApdSMSStatus): AnsiString;
const
    StatusStrings : array[0..ord(High(TApdSMSStatus))] of AnsiString =       {!!.01}
              ('REC UNREAD', 'REC READ', 'STO UNSENT', 'STO SENT', 'ALL',
               'Unknown');                                               {!!.01}
begin
  if ord(StatusString) > High(StatusStrings) then begin
    Result := StatusStrings[High(StatusStrings)];                        {!!.02}
    //DoFail(ecSMSUnknownStatus,-8103);                                  {!!.02}
    Exit;
  end;
  Result := StatusStrings[Ord(StatusString)];
end;

procedure TApdCustomGSMPhone.DoFail(const Msg: string;
  const ErrCode: Integer);
begin
  if Assigned(FOnGSMComplete) then begin
    FOnGSMComplete(Self, FGSMState, ErrCode);
    FGSMState := gsNone;
  end else begin
    //raise EApdGSMPhoneException.Create(Msg, ErrCode);
    FGSMState := gsNone;
    raise EApdGSMPhoneException.Create(ErrCode, Msg);
  end;
end;


procedure TApdCustomGSMPhone.SetGSMMode(const NewMode : TGSMMode);      {!!.PDU}
begin
  FGSMMode := NewMode;
end;

function TApdCustomGSMPhone.GetGSMMode : TGSMMode;
begin
  Result := FGSMMode;
end;

procedure TApdCustomGSMPhone.SetState(NewState : TGSMStates);
begin
  FGSMState := NewState;
end;

{ TApdGSMPhone }

constructor TApdGSMPhone.Create(Owner: TComponent);
begin
  inherited;
end;

destructor TApdGSMPhone.Destroy;
begin
  inherited;
end;

end.
