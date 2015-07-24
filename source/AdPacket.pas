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
 *  Sulaiman Mah
 *  Sean B. Durkin
 *  Sebastian Zierer
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADPACKET.PAS 5.00                   *}
{*********************************************************}
{* TApdDataPacket component                              *}
{*********************************************************}

{
  When a TApdDataPacket is enabled, it creates an internal data packet
  manager. There is one manager per port, the manager is the class
  that collects the data from the port and passes it to the data packets.
  Once a data packet starts collecting, the manager passes all data to
  that one until the packet match conditions are met, timeout, or when
  the end match conditions are not met.
  A possible replacement would have a installable manager (limited to 1
  per port), with a TCollection of packets. The collection item would have
  a string to match (could use regex), a collected string, and a state
  (idle, active/waiting, collecting). The manager would hook into the
  port's OnTriggerAvail, each time that fires it would iterate through
  the collection, generating events when the string matches. To make
  things smoother, collect new data from the OnTriggerAvail and run
  the iteration/processing in a separate thread.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdPacket;

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
  OoMisc,
  AdExcept,
  AdPort,
  AwUser;

type
  TPacketStartCond = (scString,scAnyData);
  TPacketEndCond = (ecString,ecPacketSize);
  TPacketEndSet = set of TPacketEndCond;

const
  EscapeCharacter = '\';   { Use \\ to specify an actual '\' in the match strings}
  WildCardCharacter = '?'; { Use \? to specify an actual '?' in the match strings}
  adpDefEnabled = True;
  adpDefIgnoreCase = True;
  adpDefIncludeStrings = True;
  adpDefAutoEnable = True;
  adpDefStartCond = scString;
  adpDefTimeOut = 2184;
  apdDefFlushOnTimeout = True;                                           {!!.04}

type
  TApdDataPacket = class;
  TApdDataPacketManager = class;
  TApdDataPacketManagerList = class
    {Maintains a list of packet managers so that a packet can
     locate the current packet manager for its comport.
     If no packet manager currently exists for the port, the
     packet will create one. When the last packet dis-connects
     itself from the packet manager, the packet manager self-
     destructs.}
  private
    ManagerList : TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Insert(Value : TApdDataPacketManager);
    procedure Remove(Value : TApdDataPacketManager);
    function GetPortManager(ComPort : TApdCustomComPort) : TApdDataPacketManager;
  end;

  TApdDataPacketManager = class
    {Packet manager. One instance of these exists per com port using
     packets. The packet manager does the actual data buffering for
     all packets attached to its port.}
  private
    PacketList : TList;
    fComPort : TApdCustomComPort;
    HandlerInstalled : Boolean;
    fEnabled : Boolean;
    BufferPtr : Integer;
    fCurBfrOffset: Integer;
    fDataBuffer : PAnsiChar;    // --sm ansi
    dpDataBufferSize : Integer;
    fCapture : TApdDataPacket;
    Timer : Integer;
    fInEvent : Boolean;
    NotifyPending : Boolean;
    NotifyStart : Integer;
    EnablePending : Boolean;
    FKeepAlive : Boolean;

    FWindowHandle : HWND;
  protected
    procedure WndProc(var Msg: TMessage);
    procedure DisposeBuffer;
     {- Get rid of any pending data and release any buffer space}
    procedure NotifyData(NewDataStart : Integer);
     {- Notify the attached packet(s) that new data is available}
    procedure EnablePackets;
     {- Initialize all enabled packets for data capture}
    procedure DisablePackets;
     {- Shut off data capture for all attached packets}
    procedure PacketTriggerHandler(Msg, wParam : Cardinal;
                                 lParam : Integer);
     {- process messages from dispatcher}
    procedure PortOpenClose(CP : TObject; Opening : Boolean);
     {- Event handler for the port open/close event}
    procedure PortOpenCloseEx(CP: TObject; CallbackType: TApdCallbackType);{!!.03}
     {- Extended event handler for the port open/close event}

    procedure SetInEvent(Value : Boolean);
     {- Property write method for the InEvent property}
    procedure SetEnabled(Value : Boolean);
     {- Proporty write method for the Enabled property}
  public
    constructor Create(ComPort : TApdCustomComPort);
    destructor Destroy; override;
    procedure Enable;
     {- Install com port event handlers}
    procedure EnableIfPending;
     {- Enable after form load}
    procedure Disable;
     {- Remove com port event handlers}
    procedure Insert(Value : TApdDataPacket);
     {- Add a packet to the list}
    procedure Remove(Value : TApdDataPacket);
     {- Remove a packet to the list}
    procedure RemoveData(Start,Size : Integer);
     {- Remove packet data from the data buffer}
    procedure SetCapture(Value : TApdDataPacket; TimeOut : Integer);
     {- Set ownership of incoming data to a particular packet}
    procedure ReleaseCapture(Value : TApdDataPacket);
     {- Opposite of SetCapture, see above}
    property DataBuffer : PAnsiChar read fDataBuffer;   // --sm ansi
     {- The packet data buffer for the port. Only packets should access this}
    property ComPort : TApdCustomComPort read fComPort;
     {- The com port associated with this packet manager}
    property Enabled : Boolean read fEnabled write SetEnabled;
     {- Controls whether the packet manager is active
        set/reset when the com port is opened or closed}
    property InEvent : Boolean read fInEvent write SetInEvent;
     {- Event flag set by packets to prevent recursion issues}
    property KeepAlive : Boolean read FKeepAlive write FKeepAlive;
  end;

  TPacketMode = (dpIdle,dpWaitStart,dpCollecting);
  TPacketNotifyEvent = procedure(Sender: TObject; Data : Pointer; Size : Integer) of object;
  TStringPacketNotifyEvent = procedure(Sender: TObject; Data : AnsiString) of object;
  TApdDataPacket = class(TApdBaseComponent)
  private
    fManager : TApdDataPacketManager;
    fStartCond : TPacketStartCond;
    fEndCond : TPacketEndSet;
    fStartString,fEndString : AnsiString; // --sm
    fComPort : TApdCustomComPort;
    fMode : TPacketMode;
    fPacketSize : Integer;
    fOnPacket : TPacketNotifyEvent;
    fOnStringPacket : TStringPacketNotifyEvent;
    fOnTimeOut : TNotifyEvent;
    fTimeOut : Integer;
    fDataSize : Integer;
    fBeginMatch : Integer;
    fAutoEnable : Boolean;
    fIgnoreCase : Boolean;
    fEnabled : Boolean;
    fIncludeStrings : Boolean;

    PacketBuffer : PAnsiChar;       // --sm ansi
    StartMatchPos,EndMatchPos,EndMatchStart : Integer;
    LocalPacketSize : Integer;
    WildStartString,
    WildEndString,
    InternalStartString,
    InternalEndString : AnsiString; // --sm ansi
    WillCollect : Boolean;
    EnablePending : Boolean;
    HaveCapture : Boolean;
    FSyncEvents : Boolean;
    FDataMatch,
    FTimedOut : Boolean;
    FEnableTimeout: Integer;                                             {!!.04}
    FEnableTimer : Integer;                                              {!!.04}
    FFlushOnTimeout : Boolean;                                           {!!.04}
  protected
    procedure SetComPort(const NewComPort : TApdCustomComPort);
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetEnabled(Value : Boolean);
    procedure SetMode(Value : TPacketMode);
    procedure SetEndCond(const Value: TPacketEndSet);
    procedure SetEndString(Value : AnsiString);     // --sm
    procedure SetFlushOnTimeout (const v : Boolean);                     {!!.04}
    procedure ProcessData(StartPtr : Integer);
     {- Processes incoming data, collecting and/or looking for a match}
    procedure Packet(Reason : TPacketEndCond);
     {- Set up parameters and call DoPacket to generate an event}
    procedure TimedOut;
     {- Set up parameters and call DoTimeout to generate an event}
    procedure DoTimeout;
     {- Generate an OnTimeOut event}
    procedure DoPacket;
     {- Generate an OnPacket event}
    procedure NotifyRemove(Data : Integer);
     {- Called by the packet manager to cancel any partial matches}
    procedure Resync;
     {- Look for a match starting beyond the first character.
        Called when a partial match fails, or when data has
        been removed by another packet.}
    procedure CancelMatch;
     {- Cancel any pending partial match. Called by the packet manager
        when another packet takes capture.}
    procedure Loaded; override;
    procedure LogPacketEvent(Event : TDispatchSubType;
      Data : Pointer; DataSize : Integer);
     {- add packet specific events to log file, if logging is requested}

    property BeginMatch : Integer read fBeginMatch;
     {- Beginning of the current match. -1 if no match yet}
    property Manager : TApdDataPacketManager read fManager write fManager;
     {- The packet manager controlling this packet}
    property Mode : TPacketMode read fMode write SetMode;
     {- Current mode. Can be either Idle = not currently enabled,
        WaitStart = trying to match the start string, or
        Collecting = start condition has been met; collecting data}

    procedure Enable;
     {- Enable the packet}
    procedure Disable;
     {- Disable the packet}

    procedure TriggerHandler(Msg, wParam : Cardinal; lParam : Integer);  {!!.04}
     {- process messages from dispatcher, only used for the EnableTimeout}
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure GetCollectedString(var Data : AnsiString);
     {- Returns data collected in OnStringPacket format}
    procedure GetCollectedData(var Data : Pointer; var Size : Integer);
     {- Returns data collected in OnPacket format}
    property InternalManager : TApdDataPacketManager read FManager;
      { - Internal use only!  Do not touch }
    property EnableTimeout : Integer                                     {!!.04}
      read FEnableTimeout write FEnableTimeout default 0;                {!!.04}
      {- A timeout that starts when the packet is enabled }
    property FlushOnTimeout : Boolean                                    {!!.04}
      read FFlushOnTimeout Write SetFlushOnTimeout default True;         {!!.04}
      {- Determines whether the packet buffer is flushed on timeout }

    property SyncEvents : Boolean read FSyncEvents write FSyncEvents;
     {- Controls whether packet events are synchronized to the main VCL thread.
        Default is True.}
    property PacketMode : TPacketMode read fMode;
     {- Read-only property to show if we are idle, waiting, or collecting }
    function WaitForString(var Data : AnsiString) : Boolean;                 {!!.01}
     {- Waits for the data match condition or a timeout, return the collected string }
    function WaitForPacket(var Data : Pointer; var Size : Integer) : Boolean;{!!.01}
     {- Waits for the data match condition or a timeout, return the collected string }
  published
    property Enabled : Boolean read fEnabled write SetEnabled nodefault;
     {- Is the packet enabled.}
    property AutoEnable : Boolean read fAutoEnable write fAutoEnable default adpDefAutoEnable;
     {- Fire only first time, or fire whenever the conditions are met.}
    property StartCond : TPacketStartCond read fStartCond write fStartCond default adpDefStartCond;
     {- Conditions for this packet to start collecting data}
    property EndCond : TPacketEndSet read fEndCond write SetEndCond default [];
     {- Conditions for this packet to stop collecting data}
    property StartString : AnsiString read fStartString write fStartString; // --sm //SZ: when changing this type, it *must* be changed in Adproped.pas, too
     {- Packet start string}
    property EndString : AnsiString read fEndString write SetEndString;   // --sm   //SZ: when changing this type, it *must* be changed in Adproped.pas, too
     {- Packet end string}
    property IgnoreCase : Boolean read fIgnoreCase write fIgnoreCase default adpDefIgnoreCase;
     {- Ignore case when matching StartString and EndString}
    property ComPort : TApdCustomComPort read FComPort write SetComPort;
     {- The com port for which data is being read}
    property PacketSize : Integer read fPacketSize write fPacketSize;
     {- Size of a packet with packet size as part of the end conditions}
    property IncludeStrings : Boolean read fIncludeStrings write fIncludeStrings default adpDefIncludeStrings;
     {- Controls whether any start and end strings should be included in the
        data buffer passed to the event handler}
    property TimeOut : Integer read fTimeOut write fTimeOut default adpDefTimeOut;
     {- Number of ticks that can pass from when the packet goes into data
        collection mode until the packet is complete. 0 = no timeout}
    property OnPacket : TPacketNotifyEvent read fOnPacket write fOnPacket;
     {- Event fired when a complete packet is received}
    property OnStringPacket : TStringPacketNotifyEvent read fOnStringPacket write fOnStringPacket;
     {- Event fired when a complete packet is received}
    property OnTimeout : TNotifyEvent read fOnTimeout write fOnTimeout;
     {- Event fired when a packet times out}
  end;

implementation

uses
  Types, AnsiStrings;

var
  PacketManagerList : TApdDataPacketManagerList;

constructor TApdDataPacketManagerList.Create;
begin
  inherited Create;
  ManagerList := TList.Create;
end;

destructor TApdDataPacketManagerList.Destroy;
begin
  while ManagerList.Count > 0 do
    with TApdDataPacketManager(ManagerList[pred(ManagerList.Count)]) do begin
      { we're only being destroyed from the Finalization block, it's OK to   }
      { set fComPort to nil here since that will be destroyed shortly anyway }
      fComPort := nil;                                                   {!!.06}
      Free;                                                              {!!.06}
    end;
  ManagerList.Free;
  inherited Destroy;
end;

procedure TApdDataPacketManagerList.Insert(Value : TApdDataPacketManager);
begin
  ManagerList.Add(Value);
end;

procedure TApdDataPacketManagerList.Remove(Value : TApdDataPacketManager);
begin
  ManagerList.Remove(Value);
end;

function TApdDataPacketManagerList.GetPortManager(ComPort : TApdCustomComPort) : TApdDataPacketManager;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to pred(ManagerList.Count) do
    if TApdDataPacketManager(ManagerList[i]).ComPort = ComPort then begin
      Result := TApdDataPacketManager(ManagerList[i]);
      exit;
    end;
end;

constructor TApdDataPacketManager.Create(ComPort : TApdCustomComPort);
begin
  inherited Create;
  fComPort := ComPort;
  {fComPort.RegisterUserCallback(PortOpenClose);}                        {!!.03}
  FComPort.RegisterUserCallbackEx(PortOpenCloseEx);                      {!!.03}
  PacketList := TList.Create;
  FKeepAlive := False;
  PacketManagerList.Insert(Self);
  Enabled := fComPort.Open
    and ([csDesigning, csLoading] * fComPort.ComponentState = []);
  EnablePending :=
    not (csDesigning in fComPort.ComponentState) and
    not Enabled and fComPort.Open;
  FWindowHandle := AllocateHWnd(WndProc);                                {!!.02}
end;

destructor TApdDataPacketManager.Destroy;
begin
  FKeepAlive := True;
  PacketManagerList.Remove(Self);
  Enabled := False;
  {fComPort.DeregisterUserCallback(PortOpenClose);}                      {!!.03}
  if Assigned(FComPort) then                                             {!!.05}
    FComPort.DeregisterUserCallbackEx(PortOpenCloseEx);                  {!!.03}
  DisposeBuffer;
  PacketList.Free;
  PacketList := nil;                                                     {!!.KINO}
  DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TApdDataPacketManager.EnableIfPending;
begin
  if EnablePending then begin
    Enabled := True;
    EnablePending := False;
  end;
end;

procedure TApdDataPacketManager.Insert(Value : TApdDataPacket);
begin
  PacketList.Add(Value);
  Value.Manager := Self;
end;

procedure TApdDataPacketManager.Remove(Value : TApdDataPacket);
begin
  PacketList.Remove(Value);
  if fInEvent then exit;
  Value.Manager := nil;
  if (PacketList.Count = 0) and (not FKeepAlive) then begin
    fComPort := nil;                                                        // SWB
    PostMessage(FWindowHandle, CM_RELEASE, 0, 0);
  end;
end;

procedure TApdDataPacketManager.RemoveData(Start,Size : Integer);
var
  NewStart,i : Integer;
begin
  NewStart := Start+Size;
  dec(BufferPtr,NewStart);
  Dec(fCurBfrOffset, NewStart);
  if (fCurBfrOffset < 0) then
    fCurBfrOffset := -1;
  if BufferPtr > 0 then begin
    move(fDataBuffer[NewStart],fDataBuffer[0],BufferPtr); // --sm check BufferPtr
  end else
    DisposeBuffer;
  for i := 0 to pred(PacketList.Count) do
    TApdDataPacket(PacketList[i]).NotifyRemove(NewStart);
end;

procedure TApdDataPacketManager.SetCapture(Value : TApdDataPacket; TimeOut : Integer);
var
  i : integer;
begin
  fCapture := Value;
  if TimeOut <> 0 then
    fComPort.Dispatcher.SetTimerTrigger(Timer,TimeOut,True);
  Value.HaveCapture := True;
  for i := 0 to pred(PacketList.Count) do
    if PacketList[i] <> fCapture then
      TApdDataPacket(PacketList[i]).CancelMatch;
end;

procedure TApdDataPacketManager.ReleaseCapture(Value : TApdDataPacket);
begin
  if Timer <> 0 then begin                                               {!!.02}
    CheckException(fCapture, fComPort.Dispatcher.SetTimerTrigger(Timer,0,False));
    {Timer := 0;}                                                        {!!.04}
  end;                                                                   {!!.02}
  fCapture := nil;
  Value.HaveCapture := False;
end;

procedure TApdDataPacketManager.SetInEvent(Value : Boolean);
var
  i : Integer;
begin
  if Value <> fInEvent then begin
    fInEvent := Value;
    if Value then begin
      for i := 0 to pred(PacketList.Count) do
        with TApdDataPacket(PacketList[i]) do
          if fEnabled then
            Disable;
    end else begin
      for i := 0 to pred(PacketList.Count) do
        with TApdDataPacket(PacketList[i]) do
          if fEnabled then
            Enable;
      if NotifyPending then begin
        if assigned(fDataBuffer) then
          NotifyData(NotifyStart);
        NotifyPending := False;
      end;
    end;
  end;
end;

procedure TApdDataPacketManager.NotifyData(NewDataStart : Integer);
var
  i : integer;
  Interest : Boolean;
begin
  if InEvent then begin
    NotifyPending := True;
    NotifyStart := NewDataStart;
    exit;
  end;
  if BufferPtr > 0 then
    fCurBfrOffset := NewDataStart;
    while (fCurBfrOffset < BufferPtr) do
    begin
        if (Assigned(fCapture)) then
            fCapture.ProcessData(fCurBfrOffset)
        else
            for i:=0 to (PacketList.Count - 1) do
            begin
                TApdDataPacket(PacketList[i]).ProcessData(fCurBfrOffset);
                if (Assigned(fCapture)) then
                    Break;
                if (not Assigned(fDataBuffer)) then
                    Exit;
                // If the previous call to ProcessData resulted in a packet
                // being completed, then the data comprising that packet has
                // now been deleted from DataBuffer and fCurBfrOffset adjusted
                // to the correct offset in the new DataBuffer.  It will often happen
                // that fCurBfrOffset no longer exists in DataBuffer after the
                // adjustment and so will be < 0.  That is our signal to exit
                // this loop, increment to the next (first) character and start
                // matching again.
                if (fCurBfrOffset < 0) then
                    Break;
            end;
        Inc(fCurBfrOffset);
    end;
    if not assigned(fCapture) then begin
        Interest := False;
        for i := 0 to pred(PacketList.Count) do
            with TApdDataPacket(PacketList[i]) do
                if Enabled and (Mode <> dpIdle) and (BeginMatch <> -1) then begin
                    Interest := True;
                    Break;
                end;
        if not Interest then
            DisposeBuffer;
    end;
end;

procedure TApdDataPacketManager.EnablePackets;
var
  i : integer;
begin
  for i := 0 to pred(PacketList.Count) do
    with TApdDataPacket(PacketList[i]) do
      if Enabled then
        Enable;
end;

procedure TApdDataPacketManager.DisablePackets;
var
  i : integer;
begin
  { this can get called when destroying, and called in the context of }
  { different threads, make sure the PacketList is still around }
  if Assigned(PacketList) then                                           {!!.06}
    for i := 0 to pred(PacketList.Count) do
      if Assigned(PacketList[i]) then                                    {!!.06}
        with TApdDataPacket(PacketList[i]) do
          Disable;
end;

procedure TApdDataPacketManager.PortOpenClose(CP : TObject; Opening : Boolean);
begin
  if Opening then begin
    Enabled := True;
    EnablePackets;
  end else begin
    DisablePackets;
    Enabled := False;
  end;
end;

procedure TApdDataPacketManager.PortOpenCloseEx(CP: TObject;             {!!.03}
  CallbackType: TApdCallbackType);
begin
  if CallbackType = ctOpen then begin
    Enabled := True;
    EnablePackets;
  end else begin
    DisablePackets;
    Enabled := False;
  end;
end;

procedure TApdDataPacketManager.PacketTriggerHandler(Msg, wParam : Cardinal;
                                 lParam : Integer);
var
  NewDataStart : Integer;
begin
  if Msg = apw_TriggerAvail then begin
    NewDataStart := BufferPtr;
    if (BufferPtr+Integer(wParam)) >= dpDataBufferSize then begin
      inc(dpDataBufferSize,DispatchBufferSize);
      ReAllocMem(fDataBuffer,dpDataBufferSize);
    end;
    wParam := fComPort.Dispatcher.GetBlock(PAnsiChar(@fDataBuffer[BufferPtr]),wParam);
    inc(BufferPtr,wParam);
    NotifyData(NewDataStart);
  end else if (Msg = apw_TriggerTimer) and
    (Integer(wParam) = Timer) and
    Assigned(fCapture) then
      fCapture.TimedOut;
end;

procedure TApdDataPacketManager.WndProc(var Msg: TMessage);
begin
  { this WndProc is installed when the TApdDataPacketManager's last }
  { TApdDataPacket has been removed from the packet list }
  if Msg.Msg = CM_RELEASE then
    if fInEvent then begin
      { we're still in an event, repost the message }
      PostMessage(FWindowHandle, CM_RELEASE, 0, 0)
    end else begin
      { we're not in any event now, close ourselves }
      Free;
    end
  else if Msg.Msg = WM_QUERYENDSESSION then                              {!!.05}
    Msg.Result := 1;                                                     {!!.05}
end;

procedure TApdDataPacketManager.DisposeBuffer;
begin
  if Assigned(fDataBuffer) then begin
    FreeMem(fDataBuffer,dpDataBufferSize);
    fDataBuffer := nil;
  end;
  dpDataBufferSize := 0;
  BufferPtr := 0;
end;

procedure TApdDataPacketManager.SetEnabled(Value : Boolean);
begin
  if Value <> fEnabled then begin
    if Value then
      Enable
    else
      Disable;
    fEnabled := Value;
  end;
end;

procedure TApdDataPacketManager.Enable;
begin
  if not HandlerInstalled then begin
    if Assigned(fComPort) then begin
      fComPort.Dispatcher.RegisterEventTriggerHandler(PacketTriggerHandler);
      HandlerInstalled := True;
      Timer := fComPort.Dispatcher.AddTimerTrigger;
    end;
  end;
end;

procedure TApdDataPacketManager.Disable;
begin
  if HandlerInstalled then begin
    if (Assigned(fComPort) and                                              // SWB
        Assigned(fComPort.Dispatcher)) then                                 // SWB
    begin                                                                   // SWB
      fComPort.Dispatcher.RemoveTrigger(Timer);
      Timer := 0;                                                        {!!.04}
      fComPort.Dispatcher.DeregisterEventTriggerHandler(PacketTriggerHandler);
    end;                                                                 {!!.02}
    HandlerInstalled := False;
    DisposeBuffer;
  end;
end;

constructor TApdDataPacket.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FSyncEvents := True;
  {Search for comport}
  if (csDesigning in ComponentState) then
    ComPort := SearchComPort(Owner);

  fIgnoreCase := adpDefIgnoreCase;
  if csDesigning in ComponentState then
    fEnabled := adpDefEnabled
  else
    fEnabled := False;
  fIncludeStrings := adpDefIncludeStrings;
  fEndCond := [];
  fAutoEnable := adpDefAutoEnable;
  fStartCond := adpDefStartCond;
  fTimeOut := adpDefTimeOut;
  FFlushOnTimeout := apdDefFlushOnTimeout;                               {!!.04}

  Mode := dpIdle;
end;

destructor TApdDataPacket.Destroy;
begin
  ComPort := nil;
  inherited Destroy;
end;

procedure TApdDataPacket.SetMode(Value : TPacketMode);
begin
  if Value <> fMode then begin
    if Value = dpCollecting then
      Manager.SetCapture(Self,TimeOut)
    else if HaveCapture then
      Manager.ReleaseCapture(Self);
    fMode := Value;
    case fMode of
    dpIdle :
      LogPacketEvent(dstIdle,nil,0);
    dpWaitStart :
      LogPacketEvent(dstWaiting,nil,0);
    else
      LogPacketEvent(dstCollecting,nil,0);
    end;
  end;
end;

procedure TApdDataPacket.Notification(AComponent : TComponent;
                                        Operation : TOperation);
  {Link/unlink comport when dropped or removed from form}
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) then begin
    {See if our com port is going away}
    if (AComponent = FComPort) then
      ComPort := nil;
  end else if (Operation = opInsert) then
    {Check for a com port being installed}
    if not Assigned(FComPort) and (AComponent is TApdCustomComPort) then
      ComPort := TApdCustomComPort(AComponent);
end;

procedure TApdDataPacket.SetComPort(const NewComPort : TApdCustomComPort);
var
  Manager : TApdDataPacketManager;
begin
  if NewComPort <> fComPort then begin
    if Assigned(fComPort) then begin
      { remove the old port hooks }
      Manager := PacketManagerList.GetPortManager(fComPort);             {!!.06}
      if Assigned(Manager) then                                          {!!.06}
        Manager.Remove(Self);                                            {!!.06}
    end;                                                                 {!!.06}
    FComPort := NewComPort;
    if Assigned(fComPort) then begin
      { add the new port hooks }
      Manager := PacketManagerList.GetPortManager(fComPort);
      if Manager = nil then
        Manager := TApdDataPacketManager.Create(fComPort);
      Manager.Insert(Self);
    end;
  end;
end;

procedure TApdDataPacket.SetEnabled(Value : Boolean);
begin
  if Value <> fEnabled then begin
    if Value then
      Enable
    else
      Disable;
    fEnabled := Value;
  end;
end;

procedure TApdDataPacket.Resync;
var
  Match : Boolean;
begin
  repeat
    inc(fBeginMatch);
    StartMatchPos := 1;
    Match := True;
    while Match and (BeginMatch <= Manager.BufferPtr - 1)
    and (StartMatchPos <= Length(InternalStartString)) do begin
      if (WildStartString[StartMatchPos] = '1')
      or (not IgnoreCase
        and (Manager.DataBuffer[BeginMatch+StartMatchPos - 1]
          = InternalStartString[StartMatchPos]))
      or (IgnoreCase
        and (UpCase(Manager.DataBuffer[BeginMatch+StartMatchPos - 1])
          = InternalStartString[StartMatchPos])) then
        inc(StartMatchPos)
      else
        Match := False;
    end;
    if Match and (BeginMatch <= Manager.BufferPtr-1) then begin
      if StartMatchPos >= Length( InternalStartString) then
        if (EndCond = []) then begin
          fDataSize := Length( InternalStartString);
          Packet(ecPacketSize);
          exit;
        end else
          Mode := dpCollecting;
      break;
    end;
  until BeginMatch > Manager.BufferPtr - 1;
  if BeginMatch > Manager.BufferPtr - 1 then begin
    fBeginMatch := -1;
    StartMatchPos := 1;
  end;
end;

// A replacement for the old packet matching logic.  This versions strives to
// work in a way that is more in conformance with the documentation.
// We do this by calling the routine for each character in the current
// buffer.  Each packet gets a chance to match that character before we move
// on to the next character.
procedure TApdDataPacket.ProcessData(StartPtr : Integer);

    function MatchStartChar(c: AnsiChar; n: Integer): Boolean; // --sm ansi
    begin
        Result := (WildStartString[n] = '1') or
                  ((not IgnoreCase) and (c = InternalStartString[n])) or
                  (IgnoreCase and (UpCase(c) = InternalStartString[n]));
    end;

    function MatchEndChar(c: AnsiChar; n: Integer): Boolean;
    begin
        Result := (WildEndString[n] = '1') or
                  ((not IgnoreCase) and (c = InternalEndString[n])) or
                  (IgnoreCase and (UpCase(c) = InternalEndString[n]));
    end;

var
    c           : AnsiChar;
    i           : Integer;
    partMatch   : Boolean;
begin
    if ((not Enabled) or
        (not Assigned(fManager)) or
        (StartPtr >= fManager.BufferPtr)) then
        Exit;
    c := fManager.DataBuffer[StartPtr];
    // If this packet has no specific start condition, then start collecting data
    // for the packet until the end condition is met.
    if ((Mode = dpIdle) and WillCollect) then
    begin
        Mode := dpCollecting;
        WillCollect := False;
    end;

    case mode of
      // If we have nothing to do, then do nothing
      dpIdle:
        Exit;
      // We are waiting for a match on the start string, so try to match it
      dpWaitStart:
      begin
        if (MatchStartChar(c, StartMatchPos)) then
        begin
            // The current character matches the pattern
            if (fBeginMatch = -1) then
                fBeginMatch := StartPtr;
            if (StartMatchPos = Length(InternalStartString)) then
            begin
                // The current character is the last character of the pattern.
                // We have matched the start string
                if ((EndCond = []) or
                    (ecPacketSize in EndCond) and
                    (Length(InternalStartString) = LocalPacketSize)) then
                begin
                    // The start string is the entire packet, process it
                    fDataSize := StartPtr - fBeginMatch + 1;
                    Packet(ecPacketSize);
                end else
                    // There is more to the packet, start collecting characters
                    Mode := dpCollecting;
            end else
                // Only a partial match so far, bump to the next character
                // of the pattern to match
                Inc(StartMatchPos);
        end else
        begin
            // The current character did not match the pattern.
            if (fBeginMatch <> -1) then
            begin
                // We already have a partial match.  This means that we need
                // to backtrack to see if we have a smaller, partial match
                // starting somewhere within the characters that we have
                // already matched.  This bit of cruft will set the various
                // start match pointers to the first complete partial match
                // that we find.  For example, if we are looking for AAB in
                // AAAB we would have matched AA so far, so we would set
                // fBeginMatch = 2 and StartMatchPos = 2.
                partMatch := False;
                Inc(fBeginMatch);
                while ((not partMatch) and (fBeginMatch <= StartPtr)) do
                begin
                    StartMatchPos := 1;
                    for i:=fBeginMatch to StartPtr do
                    begin
                        if ( not MatchStartChar(fManager.DataBuffer[i], StartMatchPos)) then
                            break;
                        Inc(StartMatchPos);
                    end;
                    if (i > StartPtr) then
                        partMatch := True
                    else
                        Inc(fBeginMatch);
                end;
                if (not partMatch) then
                begin
                    fBeginMatch := -1;
                    StartMatchPos := 1;
                end;
            end;
        end;
      end;
      // We are collecting data for the body of the packet.  We need to either
      // collect a fixed number of bytes or we need to collect until we find
      // the end string.
      dpCollecting:
      begin
        if fBeginMatch = -1 then
            fBeginMatch := StartPtr;
        if (ecPacketSize in EndCond) then
        begin
            // The packet is a fixed size
            if ((StartPtr - BeginMatch) + 1 >= LocalPacketSize) then
            begin
                // We have processed enough characters to fill the packet
                fDataSize := (StartPtr - BeginMatch) + 1;
                Packet(ecPacketSize);
            end;
        end;
        if (ecString in EndCond) then
        begin
            // The packet is terminated by some string
            if (MatchEndChar(c, EndMatchPos)) then
            begin
                // Current character matches character from terminating string
                if (EndMatchPos = Length(InternalEndString)) then
                begin
                    // We have matched all terminating string characters.
                    // Process the packet.
                    fDataSize := StartPtr - BeginMatch + 1;
                    Packet(ecString);
                end else
                    Inc(EndMatchPos);
            end else
            begin
                // Current character doesn't match character from
                // terminating string.
                if (EndMatchPos <> 1) then
                begin
                    // We already have a partial match.  This means that we need
                    // to backtrack to see if we have a smaller, partial match
                    // starting somewhere within the characters that we have
                    // already matched.  This bit of cruft will set the various
                    // start match pointers to the first complete partial match
                    // that we find.  For example, if we are looking for AAB in
                    // AAAB we would have matched AA so far, so we would set
                    // EndtMatchPos = 2.
                    partMatch := False;
                    EndMatchStart := StartPtr - EndMatchPos + 1;
                    while ((not partMatch) and (EndMatchStart <= StartPtr)) do
                    begin
                        EndMatchPos := 1;
                        for i:=EndMatchStart to StartPtr do
                        begin
                            if ( not MatchEndChar(fManager.DataBuffer[i], EndMatchPos)) then
                                break;
                            Inc(EndMatchPos);
                        end;
                        if (i > StartPtr) then
                            partMatch := True
                        else
                            Inc(EndMatchStart);
                    end;
                    if (not partMatch) then
                        EndMatchPos := 1;
                end;
            end;
        end;
      end;
    end;
end;
procedure TApdDataPacket.Loaded;
begin
  inherited Loaded;
  if assigned(fManager) then
    Manager.EnableIfPending;
  if EnablePending then begin
    Enable;
    EnablePending := False;
  end;
end;

procedure SetupWildMask(var MatchString,Mask : AnsiString); // --sm
var
  i,j : Integer;
  Esc : boolean;
  Ch : AnsiChar;  // --sm ansi
begin
  Esc := False;
  j := 0;
  SetLength(Mask,Length(MatchString));
  for i := 1 to Length(MatchString) do
    if Esc then begin
      inc(j);
      MatchString[j] := MatchString[i];
      Mask[j] := '0';
      Esc := False;
    end else if MatchString[i] = EscapeCharacter then
      Esc := True
    else begin
      Ch := MatchString[i];
      inc(j);
      MatchString[j] := Ch;
      if Ch = WildCardCharacter then
        Mask[j] := '1'
      else
        Mask[j] := '0';
    end;
  SetLength(MatchString,j);
  SetLength(Mask,j);
end;

procedure TApdDataPacket.LogPacketEvent(Event : TDispatchSubType; Data :
  Pointer; DataSize : Integer);
var
  NameStr : AnsiString;
begin
  NameStr := AnsiString('Packet:'+ Name);
  if Assigned(fManager.ComPort.Dispatcher) then                          {!!.02}
    if fManager.ComPort.Dispatcher.Logging then begin
      if (Data <> nil) and (DataSize <> 0) then
        fManager.ComPort.Dispatcher.AddDispatchEntry(
          dtPacket,Event,0,Data,DataSize)
      else
        fManager.ComPort.Dispatcher.AddDispatchEntry(
          dtPacket,Event,0,@NameStr[1],Length(NameStr));    // --sm check Lenght
  end;
end;

procedure TApdDataPacket.Enable;
begin
  if (csDesigning in ComponentState) then
    exit;
  if csLoading in ComponentState then begin
    EnablePending := True;
    exit;
  end;
  if assigned(fManager) and Manager.Enabled then begin
    if fManager.InEvent then begin
      EnablePending := True;
      exit;
    end;

    LogPacketEvent(dstEnable,nil,0);

    if (FEnableTimer = 0) and (FEnableTimeout > 0) then begin            {!!.04}
      { add the enable timer }
      fComPort.Dispatcher.RegisterEventTriggerHandler(TriggerHandler);   {!!.04}
      FEnableTimer := fComPort.AddTimerTrigger;                          {!!.04}
      fComPort.SetTimerTrigger(FEnableTimer,FEnableTimeout,True);        {!!.04}
    end;                                                                 {!!.04}

    if (StartCond = scString) then begin
      LogPacketEvent(dstStartStr,@FStartString[1],Length(StartString)); // --sm Length
      if (StartString  = '') then
        raise EInvalidProperty.Create(ecStartStringEmpty, False);
      if (ecPacketSize in EndCond) and (PacketSize < Length(StartString)) then  // --sm Length
        raise EInvalidProperty.Create(ecPacketTooSmall, False);
      if not IncludeStrings then
        inc(LocalPacketSize,Length(StartString)); // --sm Length
      Mode := dpWaitStart;
      if IgnoreCase then
        InternalStartString := UpperCase(StartString)
      else
        InternalStartString := StartString;
      SetupWildMask(InternalStartString,WildStartString);
    end else
      if (EndCond = []) then
        raise EInvalidProperty.Create(ecNoEndCharCount, False)
      else
        if Manager.fCapture = nil then
          Mode := dpCollecting
        else
          WillCollect := True;
    if (ecString in EndCond) then begin
      if (EndString  = '') then
        raise EInvalidProperty.Create(ecEmptyEndString, False);
      LogPacketEvent(dstEndStr,@FEndString[1],Length(EndString)); // --sm Length
      if not IncludeStrings then
        inc(LocalPacketSize,Length(EndString));
      if IgnoreCase then
        InternalEndString := UpperCase(EndString)
      else
        InternalEndString := EndString;
      SetupWildMask(InternalEndString,WildEndString);
    end;
    if (ecPacketSize in EndCond) and (PacketSize = 0) then
      raise EInvalidProperty.Create(ecZeroSizePacket, False);
  end;
  LocalPacketSize := PacketSize;
  StartMatchPos := 1;
  fBeginMatch := -1;
  EndMatchPos := 1;
end;

procedure TApdDataPacket.Disable;
begin
  if not EnablePending and not WillCollect and (Mode = dpIdle) then
    exit;
  EnablePending := False;
  WillCollect := False;
  if FEnableTimer > 0 then begin                                         {!!.04}
    { remove our enable timer and callback }
    if Assigned(fComPort) and Assigned(fComPort.Dispatcher) then begin   {!!.04}
      fComPort.Dispatcher.RemoveTrigger(FEnableTimer);                   {!!.04}
      fComPort.Dispatcher.DeregisterEventTriggerHandler(TriggerHandler); {!!.04}
    end;
    FEnableTimer := 0;                                                   {!!.04}
  end;                                                                   {!!.04}
  if assigned(fManager) then begin
    Mode := dpIdle;
    LogPacketEvent(dstDisable, nil, 0);
  end;
end;

procedure TApdDataPacket.NotifyRemove(Data : Integer);
begin
  if Enabled and (BeginMatch <> -1) then
    if BeginMatch < Data then
      Enable
    else
      if BeginMatch <> -1 then
        Resync;
end;

procedure TApdDataPacket.CancelMatch;
begin
  if Enabled and assigned(fComPort) then begin
    Disable;
    Enable;
  end;
end;

procedure TApdDataPacket.DoPacket;
var
  S : AnsiString;
begin
  try
    if Assigned(fOnPacket) then
      fOnPacket(Self,Packetbuffer,fDataSize);
    if Assigned(fOnStringPacket) then begin
      {$IFOPT H-}
      if fDataSize > 255 then
        raise EStringSizeError.Create(ecPacketTooLong, False);
      {$ENDIF}
      SetLength(S, fDataSize);
      Move(PacketBuffer^, S[1], fDataSize); // --sm check
      fOnStringPacket(Self,S);
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TApdDataPacket.Packet(Reason : TPacketEndCond);
var
  LocalSize : Integer;
begin
  fManager.InEvent := True;
  try
    Enabled := False;
    LocalSize := fDataSize;
    if (StartCond = scString) and not IncludeStrings then begin
      PacketBuffer := PAnsiChar(@Manager.DataBuffer[BeginMatch+Length(InternalStartString)]); // --sm Length
      dec(fDataSize,Length(InternalStartString)); // --sm Length
    end else
      PacketBuffer := PAnsiChar(@Manager.DataBuffer[BeginMatch]);
    if not IncludeStrings and (Reason = ecString) then
      dec(fDataSize,Length(InternalEndString)); // --sm Length
    LogPacketEvent(dstStringPacket,nil,0);
    case Reason of
    ecString :
      LogPacketEvent(dstStringPacket,PacketBuffer,fDataSize);
    else
      LogPacketEvent(dstSizePacket,PacketBuffer,fDataSize);
    end;
    FDataMatch := True;                                                  {!!.02}
    if SyncEvents and assigned(ComPort.Dispatcher.DispThread) then
      ComPort.Dispatcher.DispThread.Sync(DoPacket)
    else
      DoPacket;
    Manager.RemoveData(BeginMatch,LocalSize);
    if AutoEnable then
      Enabled := True;
  finally
    fManager.InEvent := False;
  end;
end;

procedure TApdDataPacket.DoTimeout;
begin
  try
    if Assigned(fOnTimeout) then
      fOnTimeout(Self);
  except
    Application.HandleException(Self);
  end;
end;

procedure TApdDataPacket.TimedOut;
begin
  fManager.InEvent := True;
  try
    LogPacketEvent(dstPacketTimeout,nil,0);
    Enabled := False;
    FTimedOut := True;                                                   {!!.02}
    PacketBuffer := PAnsiChar (@Manager.DataBuffer[BeginMatch +              {!!.04}
                           Length (InternalStartString)]);               {!!.04}
    fDataSize := Manager.BufferPtr - BeginMatch;                         {!!.04}
    if SyncEvents and assigned(ComPort.Dispatcher.DispThread) then
      ComPort.Dispatcher.DispThread.Sync(DoTimeout)
    else
      DoTimeout;
    if FFlushOnTimeout then                                              {!!.04}
      Manager.RemoveData (BeginMatch, Manager.BufferPtr - BeginMatch);
  finally
    fManager.InEvent := False;
  end;
end;

procedure Finalize;
begin
  PacketManagerList.Free;
end;

procedure TApdDataPacket.SetEndString(Value: AnsiString); // --sm
var
  OldEnabled : Boolean;
begin
  OldEnabled := Enabled;
  Enabled := False;
  FEndString := Value;
  Enabled := OldEnabled;
end;

procedure TApdDataPacket.SetEndCond(const Value: TPacketEndSet);
var
  OldEnabled : Boolean;
begin
  OldEnabled := Enabled;
  Enabled := False;
  fEndCond := Value;
  Enabled := OldEnabled;
end;

procedure TApdDataPacket.SetFlushOnTimeout (const v : Boolean);          {!!.04}
begin                                                                    {!!.04}
  if v <> FFlushOnTimeout then                                           {!!.04}
    FFlushOnTimeout := v;                                                {!!.04}
end;                                                                     {!!.04}

procedure TApdDataPacket.GetCollectedString(var Data: AnsiString);
 {- Returns data collected in OnStringPacket format}
var
  SLength : Integer;
begin
  SLength := fDataSize;
  {$IFOPT H-}
  if SLength > 255 then
    SLength := 255;
  {$ENDIF}
  SetLength(Data, SLength);
  Move(PacketBuffer^, Data[1], SLength);// --sm check
end;

procedure TApdDataPacket.GetCollectedData(var Data: Pointer;
  var Size: Integer);
 {- Returns data collected in OnPacket format}
begin
  Data := PacketBuffer;
  Size := fDataSize;
end;

function TApdDataPacket.WaitForString(var Data : AnsiString) : Boolean;      {!!.01}
  { waits for the data match or timeout }
var
  Res : Integer;
begin
  AutoEnable := False;
  Enabled := True;
  repeat
    Res := SafeYield;
  until (Res = WM_QUIT) or FTimedOut or FDataMatch;
  Result := FDataMatch;
  if Result then begin
    Res := fDataSize;
    {$IFOPT H-}
    if Res > 255 then
      Res := 255;
    {$ENDIF}
    SetLength(Data, Res);
    Move(PacketBuffer^, Data[1], Res); // --sm check
  end;
end;

function TApdDataPacket.WaitForPacket(var Data: Pointer;                 {!!.01}
  var Size: Integer): Boolean;
  { Data and Size are returned and valid if Result is True }
var
  Res : Integer;
begin
  AutoEnable := False;
  Enabled := True;
  repeat
    Res := SafeYield;
  until (Res = WM_QUIT) or FTimedOut or FDataMatch;
  Result := FDataMatch;
  if Result then begin
    Size := fDataSize;
    Data := PacketBuffer;
  end;
end;

procedure TApdDataPacket.TriggerHandler(Msg, wParam: Cardinal;           {!!.04}
  lParam: Integer);                                                      {!!.04}
  {- process messages from dispatcher, only used for the EnableTimeout}  {!!.04}
begin                                                                    {!!.04}
  if (Msg = apw_TriggerTimer) and (Integer(wParam) = FEnableTimer)       {!!.04}
    and (Mode <> dpIdle) then begin                                      {!!.04}
    TimedOut;                                                            {!!.04}
  end;                                                                   {!!.04}
end;                                                                     {!!.04}

initialization
  PacketManagerList := TApdDataPacketManagerList.Create;
finalization
  Finalize;
end.

