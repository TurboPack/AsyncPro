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
{*                   ADSTMACH.PAS 4.06                   *}
{*********************************************************}
{* TApdStateMachine, TApdState components                *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdStMach;

{
  Design philosophy: The TApdCustomStateMachine is a container for
  TApdCustomStates.  TApdCustomStateMachine manages the TApdCustomStates.
  The TApdCustomStateMachine contains the reference to the TApdComPort,
  the TApdCustomState contains definitions for the data conditions (through
  published properties in the Conditions property).
  To start the state machine, call the TApdCustomStateMachine.Start method;
  the TApdCustomState that is designated the TApdCustomStateMachine.StartState
  gets activated.  As a TApdCustomState is activated, a TApdDataPacket is
  created for each condition, and the appropriate/applicable TApdDataPacket
  properties are set. All of the TApdDataPacket's .OnPacket event handlers
  point to the TApdCustomStateMachine.PacketEvent method. When that event is generated
  the collected data is placed in the TApdCustomState's and TApdStateMachine's
  .Data property. The current TApdCustomState is then deactivated (data packets
  disabled and freed), and the condition's NextState is activated. This
  continues until the Condition does not define a NextState (when we assume that
  is a terminal state) or the state defined by the TApdCustomStateMachine's
  TerminalState is activated.

  Additional states were available through an open beta. We haven't received
  much feedback concerning these, but the biggest comment was "I didn't know
  it was there". To fix that, the state machine components are now installed
  in the "APRO State Machine" tab.
}

{!!.04 - Extensive rewrite to add custom data sources and other enhancements }

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  Graphics,
  Forms,
  Dialogs,
  StdCtrls,
  OoMisc,
  AdPacket,
  AdPort,
  AdExcept,
  AdStrMap,
  TypInfo;

type
  TApdConnectAddType = (atAdd, atSub, atNone);

  TAdConnectoidClickStyle = (ccsHighlight, ccsHint, ccsDashedLine);
  TAdConnectoidClickStyles = set of TAdConnectoidClickStyle;

  TApdCustomStateMachine = class;
  TApdCustomState = class;
  TApdStateCondition = class;

  TApdStateConnectoid = class;
  TApdOnConnectoidClickEvent = procedure (Sender : TObject;
      Connectoid : TApdStateConnectoid) of object;

  TApdOnDataSourceGetData = procedure (Sender : TObject; Data : Pointer;
                                       DataSize : Integer) of object;
  TApdOnDataSourceGetDataString = procedure (Sender : TObject;
                                             DataString : string) of object;
  TApdOnStateGetData = procedure (Sender : TObject; Data : Pointer;
                                  DataSize : Integer) of object;
  TApdOnStateGetDataString = procedure (Sender : TObject;
                                        DataString : string) of object;

  TApdStateCustomDataSource = class (TApdBaseComponent)
    private
      FStateMachine    : TApdCustomStateMachine;
      FPauseDepth      : Integer;

      FOnGetData       : TApdOnDataSourceGetData;
      FOnGetDataString : TApdOnDataSourceGetDataString;

    protected
      function GetPaused : Boolean;
      procedure Notification (AComponent : TComponent;
                              Operation : TOperation); override;
      function SearchStateMachine (
                   const C : TComponent) : TApdCustomStateMachine;

      property StateMachine : TApdCustomStateMachine
               read FStateMachine;

      property OnGetData : TApdOnDataSourceGetData
               read FOnGetData write FOnGetData;
      property OnGetDataString : TApdOnDataSourceGetDataString
               read FOnGetDataSTring write FOnGetDataString;

    public
      constructor Create (AOwner : TComponent); override;
      procedure Output (AString : string); virtual; abstract;
      procedure OutputBlock (ABlock : Pointer; ASize : Integer); virtual;
                abstract;
      { Pause the state machine }
      procedure Pause; virtual;
      procedure Resume; virtual;
      procedure StateActivate (State : TApdCustomState);
                               virtual; abstract;
      procedure StateChange (OldState, NewState : TApdCustomState);
                             virtual; abstract;
      procedure StateDeactivate (State : TApdCustomState);
                                 virtual; abstract;
      procedure StateMachineActivate (State : TApdCustomState;
                               Condition : TApdStateCondition;
                               Index : Integer); virtual; abstract;
      procedure StateMachineDeactivate (State : TApdCustomState);
                                        virtual; abstract;
      procedure StateMachineStart (AOwner : TApdCustomStateMachine);
                virtual;
      procedure StateMachineStop; virtual;
      property Paused : Boolean read GetPaused;

    published
  end;

  TApdStateComPortSource = class (TApdStateCustomDataSource)
    private
      PacketList  : TList;
      FComPort    : TApdCustomComPort;
      FBuffer     : Pointer;
      FBufferSize : Integer;

    protected
      procedure SetComPort (const Value: TApdCustomComPort);
      procedure PacketEvent (Sender : TObject;
                             Data   : Pointer;
                             Size   : Integer);
      procedure PacketTimeout(Sender: TObject);
      procedure Notification (AComponent : TComponent;
                              Operation : TOperation); override;
      procedure TriggerHandler (Msg, wParam : Cardinal; lParam : Integer);

    public
      constructor Create (AOwner : TComponent); override;
      destructor Destroy; override;
      procedure Output (AString : string); override;
      procedure OutputBlock (ABlock : Pointer; ASize : Integer); override;
      procedure Pause; override;
      procedure Resume; override;
      procedure StateActivate (State : TApdCustomState); override;
      procedure StateDeactivate (State : TApdCustomState); override;
      procedure StateMachineActivate (State : TApdCustomState;
                                      Condition : TApdStateCondition;
                                      Index : Integer); override;
      procedure StateMachineDeactivate (State : TApdCustomState);
                override;
      procedure StateChange (OldState, NewState : TApdCustomState);
                override;
      procedure StateMachineStart (AOwner : TApdCustomStateMachine);
                override;
      procedure StateMachineStop; override;

    published
      property ComPort : TApdCustomComPort
               read FComPort write SetComPort;

      property OnGetData;
      property OnGetDataString;
  end;

  { defines how the connectoid line appears }
  TApdStateConnectoid = class (TPersistent)
  private
    FWidth: Integer;
    FCaption: TCaption;
    FColor: TColor;
    FCondition : TApdStateCondition;
    FSelected : Boolean;
    FFont : TFont;

    procedure SetCaption(const Value: TCaption);
    procedure SetColor(const Value: TColor);
    procedure SetFont (const Value : TFont);
    procedure SetWidth(const Value: Integer);
  protected
    { Answerback Property Maintenance }
    procedure DefineProperties (Filer : TFiler); override;
    function IsCaptionStored: Boolean;
    procedure ReadCaption (Reader : TReader);
    procedure WriteCaption (Writer : TWriter);
  public
    constructor Create(AOwner : TApdStateCondition);
    destructor Destroy; override;
    procedure Changed;
  published
    property Caption : TCaption read FCaption write SetCaption;
    property Color : TColor read FColor write SetColor;
    property Width : Integer read FWidth write SetWidth;
    property Font : TFont read FFont write SetFont;
  end;

  { describes the conditions for failure/success/etc }
  TApdStateCondition = class (TCollectionItem)
  protected
    function GetDisplayName: string; override;
  private
    FPacketSize       : Integer;
    FTimeout          : Integer;
    FErrorCode        : Integer;
    FNextState        : TApdCustomState;
    FEndString        : string;
    FStartString      : string;
    FConnectoid       : TApdStateConnectoid;
    FIgnoreCase       : Boolean;
    FDefaultError     : Boolean;
    FDefaultNext      : Boolean;
    FOutputOnActivate : string;
    procedure SetNextState (const Value : TApdCustomState);
    procedure SetConnectoid (const Value : TApdStateConnectoid);
  protected
    function GetCaption : TCaption;
    function GetColor : TColor;
    function GetFont : TFont;
    procedure SetCaption (const v : TCaption);
    procedure SetColor (const v : TColor);
    procedure SetDefaultError (const v : Boolean);
    procedure SetDefaultNext (const v : Boolean);
    procedure SetFont (const v : TFont);
    procedure SetOutputOnActivate (const v : string);
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;

    procedure Changed;
  published
    property DefaultError : Boolean
             read FDefaultError write SetDefaultError;
    property DefaultNext : Boolean
             read FDefaultNext write SetDefaultNext;
    property StartString : string
             read FStartString write FStartString;
    property EndString : string
             read FEndString write FEndString;
    property OutputOnActivate : string
             read FOutputOnActivate write SetOutputOnActivate;
    property PacketSize : Integer
             read FPacketSize write FPacketSize;
    property Timeout : Integer
             read FTimeout write FTimeout;
    property NextState : TApdCustomState
             read FNextState write SetNextState;
    property ErrorCode : Integer
             read FErrorCode write FErrorCode;
    property IgnoreCase : Boolean
             read FIgnoreCase write FIgnoreCase;
    property Connectoid : TApdStateConnectoid
             read FConnectoid write SetConnectoid;
    property Caption : TCaption read GetCaption write SetCaption;
    property Color : TColor read GetColor write SetColor;
    property Font : TFont read GetFont write SetFont;
  end;

  { describes the container for the aforementioned conditions }
  TApdStateConditions = class(TCollection)
  private
    function GetItem(Index: Integer): TApdStateCondition;
    procedure SetItem(Index: Integer; const Value: TApdStateCondition);
  protected
    FState : TApdCustomState;
    function GetOwner : TPersistent; override;
  public
    constructor Create(State : TApdCustomState;
      ItemClass: TCollectionItemClass);
    procedure Update(Item: TCollectionItem); override;
    function Add : TApdStateCondition;
    property Items[Index: Integer] : TApdStateCondition
      read GetItem write SetItem; default;
  end;

  { TApdCustomStateMachine events }
  TApdStateMachineStateChangeEvent = procedure(StateMachine : TApdCustomStateMachine;
    FromState, ToState : TApdCustomState) of object;
  TApdStateMachineFinishEvent = procedure(StateMachine : TApdCustomStateMachine;
    ErrorCode : Integer) of object;

  { TApdCustomState events }
  TApdStateFinishEvent = procedure(State : TApdCustomState;
    Condition : TApdStateCondition; var NextState : TApdCustomState) of object;
  TApdStateNotifyEvent = procedure(State : TApdCustomState) of object;

  { the container for the states }
  TApdCustomStateMachine = class(TApdBaseScrollingWinControl)
  private
    FStartState: TApdCustomState;
    FTerminalState: TApdCustomState;
    FCurrentState : TApdCustomState;
    FCanvas : TCanvas;
    FDefaultDataSource : TApdStateComPortSource;

    FOnStateMachineFinish: TApdStateMachineFinishEvent;
    FOnStateChange: TApdStateMachineStateChangeEvent;
    FBorderStyle: TBorderStyle;
    FData: Pointer;
    FDataSize: Integer;
    FDataString: string;
    FLastErrorCode: Integer;
    FCaption: TCaption;
    FActive: Boolean;
    FDataSource : TApdStateCustomDataSource;
    FConnectoidClickEvent : TApdOnConnectoidClickEvent;
    FMovableStates : Boolean;
    FConnectoidClickStyle : TAdConnectoidClickStyles;

    function GetComPort : TApdCustomComPort;
    function GetDataSource : TApdStateCustomDataSource;
    function GetLiveDataSource : TApdStateCustomDataSource;
    procedure SetStartState(const Value: TApdCustomState);
    procedure SetTerminalState(const Value: TApdCustomState);
    procedure SetComPort(const Value: TApdCustomComPort);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetMovableStates (const v : Boolean);

    procedure WMNCHitTest(var Message: TMessage); message WM_NCHITTEST;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    function GetData: Pointer;
    function GetDataSize: Integer;
    function GetDataString: string;
    function GetStateNames: TStringList;
    procedure SetCaption(const Value: TCaption);
    procedure SetConnectoidClickStyle (const v : TAdConnectoidClickStyles);
  protected
    { Protected declarations }

    procedure CMDesignHitTest (var Msg : TWMMouse); message CM_DESIGNHITTEST;
    procedure ConnectoidAtPoint (AddType : TApdConnectAddType; Point : TPoint);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PaintWindow(DC : HDC); override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;

    procedure DoActivate(NewState : TApdCustomState);
    procedure DoDeactivate;
    procedure DoStateChange(var M: TMessage); message apw_StateChange;
    function GetPaused : Boolean;
    procedure RenderConnectoid (Connectoid : TApdStateConnectoid;
                                State, DestState : TApdCustomState);
    procedure SetData (NewData : Pointer; NewDataString : string;
                       NewDataSize : Integer);
    procedure SetDataSource (const v : TApdStateCustomDataSource);
    procedure MouseDown (Button : TMouseButton;
                         Shift  : TShiftState;
                         X, Y   : Integer); override;
    procedure WMEraseBackground (var Msg : TWMERASEBKGND);

    property LiveDataSource : TApdStateCustomDataSource
             read GetLiveDataSource write SetDataSource;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure StateMachinePaint;

    { Change state - Called by data source }
    procedure ChangeState (ConditionIndex : Integer);

    { Pause the state machine }
    procedure Pause;
    procedure Resume;

    { starts the state machine }
    procedure Start;

    { cancels the state machine }
    procedure Cancel;

    {the data collected by our packets }
    property Data : Pointer
      read GetData;
    property DataSize : Integer
      read GetDataSize;
    property DataString : string
      read GetDataString;

    property Active : Boolean read FActive default False;                {!!.02}
    property BorderStyle: TBorderStyle
      read FBorderStyle write SetBorderStyle default bsSingle;
    property Canvas : TCanvas
      read FCanvas;

    property Caption : TCaption read FCaption write SetCaption;
    property ConnectoidClickStyle : TAdConnectoidClickStyles
             read FConnectoidClickStyle write SetConnectoidClickStyle
             default [];
    property ComPort : TApdCustomComPort
             read GetComPort write SetComPort;
    property CurrentState : TApdCustomState
      read FCurrentState;
    property DataSource : TApdStateCustomDataSource
             read GetDataSource write SetDataSource;
    property Paused : Boolean read GetPaused;
    property StateNames : TStringList
      read GetStateNames;
    property StartState : TApdCustomState
      read FStartState write SetStartState;
    property TerminalState : TApdCustomState
      read FTerminalState write SetTerminalState;

    property LastErrorCode : Integer
      read FLastErrorCode;
    property MovableStates : Boolean read FMovableStates write SetMovableStates
             default False;
    property OnStateChange : TApdStateMachineStateChangeEvent
      read FOnStateChange write FOnStateChange;
    property OnStateMachineFinish : TApdStateMachineFinishEvent
      read FOnStateMachineFinish write FOnStateMachineFinish;
    property OnConnectoidClick : TApdOnConnectoidClickEvent
             read FConnectoidClickEvent write FConnectoidClickEvent;
  end;

  TApdCustomState = class(TApdBaseGraphicControl)
  private
    { Private declarations }
    FActive: Boolean;
    FCompleted : Boolean;
    FGlyph: TBitmap;
    FOutputOnActivate: string;
    FConditions: TApdStateConditions;
    FGlyphCells: Integer;
    FActiveColor: TColor;
    FInactiveColor: TColor;
    FOnStateActivate: TApdStateNotifyEvent;
    FOnStateFinish: TApdStateFinishEvent;
    FCaption: TCaption;
    FMovable : Boolean;
    FOldX : Integer;
    FOldY : Integer;
    FMoving : Boolean;
    FActionState     : Boolean;

    FOnGetData : TApdOnStateGetData;
    FOnGetDataString : TApdOnStateGetDataString;

    procedure SetActiveColor(const NewColor : TColor);
    procedure SetActionState (const v : Boolean);
    procedure SetInactiveColor(const NewColor : TColor);
    procedure SetConditions(const Value: TApdStateConditions);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetGlyphCells(const Value: Integer);
    procedure SetCaption(const Value: TCaption);
    procedure SetMovable (const v : Boolean);

  protected
    { Protected declarations }
    HaveGlyph : Boolean;
    FStateMachine : TApdCustomStateMachine;
    FUseLeftBorder : Boolean;
    FLeftBorderWidth : Integer;
    FLeftBorderFill : TColor;

    procedure Activate; virtual;
    procedure Deactivate; virtual;
    procedure MouseDown (Button : TMouseButton; Shift : TShiftState;
                         X, Y : Integer); override;
    procedure MouseMove (Shift : TShiftState; X, Y : Integer); override;
    procedure MouseUp (Button : TMouseButton; Shift : TShiftState;
                       X, Y : Integer); override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetParent(AParent : TWinControl); override;
    function FindStateMachine : TApdCustomStateMachine;
    procedure WMEraseBackground (var Msg : TWMERASEBKGND);

    property ActionState : Boolean read FActionState write SetActionState;
    property OnGetData : TApdOnStateGetData read FOnGetData write FOnGetData;
    property OnGetDataString : TApdOnStateGetDataString
             read FOnGetDataString write FOnGetDataString;

  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    function FindDefaultError : Integer;
    function FindDefaultNext : Integer;

    { other overriden methods }
    procedure Loaded; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;

    { terminate the state }
    procedure Terminate(ErrorCode : Integer); virtual;

    property Caption : TCaption read FCaption write SetCaption;
    { True if we're waiting for a condition, False otherwise }
    property Active : Boolean read FActive;
    { True if we've already been activated and have met our conditions }
    property Completed : Boolean read FCompleted;
    property ActiveColor : TColor
      read FActiveColor write SetActiveColor;
    property InactiveColor : TColor
      read FInactiveColor write SetInactiveColor;

    property Conditions : TApdStateConditions
      read FConditions write SetConditions;

    property Glyph : TBitmap read FGlyph write SetGlyph;
    { GlyphCells is used to show a different 'cell' of the Glyph depending on }
    { the state of the state according to the following. All cells need to be }
    { the same dimensions. When rendering, the width of the rendered image is }
    { obtained by Glyph.Width div GlyphCells }
    {   Cell 1 is the inactive cell }
    {   Cell 2 is the active cell }
    {   Cell 3 is a state that has already been deactivated }
    property GlyphCells : Integer
      read FGlyphCells write SetGlyphCells;

    property Movable : Boolean read FMovable write SetMovable default False;

    property OutputOnActivate : string
      read FOutputOnActivate write FOutputOnActivate;

    property OnStateActivate : TApdStateNotifyEvent
      read FOnStateActivate write FOnStateActivate;
    property OnStateFinish : TApdStateFinishEvent
      read FOnStateFinish write FOnStateFinish;
  end;

  TApdStateMachine = class(TApdCustomStateMachine)
  published
    { our published declarations }
    property Caption;
    property ConnectoidClickStyle;
    property DataSource;
    property ComPort;
    property MovableStates;
    property StartState;
    property TerminalState;

    property OnConnectoidClick;
    property OnStateChange;
    property OnStateMachineFinish;

    { publishing from TScrollingWinControl }
    property Align;
    property Anchors;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BiDiMode;
    property Constraints;
    property ParentBiDiMode;
    property OnContextPopup;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property Color;
    property AutoScroll;
    property Ctl3D;
    property Font;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TApdState = class(TApdCustomState)
  published
    { Published declarations }
    property ActiveColor;
    property Caption;
    property Conditions;
    property Font;
    property Glyph;
    property GlyphCells;
    property InactiveColor;
    property Movable;
    property OutputOnActivate;

    property OnGetData;
    property OnGetDataString;
    property OnStateActivate;
    property OnStateFinish;
  end;


implementation

uses
  UITypes;

function SearchDataSource (const C : TComponent) : TApdStateCustomDataSource;
  {-Search for a comport in the same form as TComponent}

  function FindDataSource (const C : TComponent) : TApdStateCustomDataSource;
  var
    I  : Integer;
  begin
    Result := nil;
    if not Assigned(C) then
      Exit;

    {Look through all of the owned components}
    for I := 0 to C.ComponentCount-1 do begin
      if C.Components[I] is TApdStateCustomDataSource then begin
        Result := TApdStateCustomDataSource (C.Components[I]);
        Exit;
      end;

      {If this isn't one, see if it owns other components}
      Result := FindDataSource (C.Components[I]);
    end;
  end;

begin
  {Search the entire form}
  Result := FindDataSource (C);
end;

{ TApdStateCustomDataSource }

constructor TApdStateCustomDataSource.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);
end;

function TApdStateCustomDataSource.GetPaused : Boolean;
begin
  Result := FPauseDepth > 0;
end;

procedure TApdStateCustomDataSource.Notification (AComponent : TComponent;
                                                  Operation  : TOperation);
begin
  inherited Notification (AComponent, Operation);

  if (Operation = opRemove) then begin
    if (AComponent = FStateMachine ) then
      FStateMachine := nil;
  end else if (Operation = opInsert) then begin
    {Check for a com port being installed}
    if not Assigned(FStateMachine) and
       (AComponent is TApdCustomStateMachine) then
      FStateMachine := TApdCustomStateMachine (AComponent);
  end;
end;

procedure TApdStateCustomDataSource.Pause;
begin
  Inc (FPauseDepth);
end;

procedure TApdStateCustomDataSource.Resume;
begin
  if FPauseDepth > 0 then
    Dec (FPauseDepth);
end;

function TApdStateCustomDataSource.SearchStateMachine (const C : TComponent) : TApdCustomStateMachine;
{ Search for a state machine in the same form as TComponent }

  function FindStateMachine (const C : TComponent) : TApdCustomStateMachine;
  var
    I  : Integer;
  begin
    Result := nil;
    if not Assigned(C) then
      Exit;

    {Look through all of the owned components}
    for I := 0 to C.ComponentCount - 1 do begin
      if C.Components[I] is TApdCustomStateMachine then begin
        Result := TApdCustomStateMachine (C.Components[I]);
        Exit;
      end;

      {If this isn't one, see if it owns other components}
      Result := FindStateMachine (C.Components[I]);
    end;
  end;

begin
  {Search the entire form}
  Result := FindStateMachine (C);
end;

procedure TApdStateCustomDataSource.StateMachineStart (
              AOwner : TApdCustomStateMachine);
begin
  if not Assigned (AOwner) then
    raise EStateMachine.Create (ecNoStateMachine, False);
  FStateMachine := AOwner;
  FPauseDepth := 0;
end;

procedure TApdStateCustomDataSource.StateMachineStop;
begin
  FPauseDepth := 0;
  Resume;
end;

{ TApdStateComPortSource }

constructor TApdStateComPortSource.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);

  FBuffer     := nil;
  FBufferSize := 0;

  PacketList  := TList.Create;
  FComPort    := SearchComPort(Owner);
end;

destructor TApdStateComPortSource.Destroy;
begin
  if Assigned (FBuffer) then
    FreeMem (FBuffer, FBufferSize);

  PacketList.Free;

  inherited Destroy;
end;

procedure TApdStateComPortSource.Output (AString : string);
begin
  if Assigned (FComPort) then
    FComPort.Output := AnsiString(AString);
end;

procedure TApdStateComPortSource.OutputBlock (ABlock : Pointer;
                                              ASize : Integer);
begin
  if Assigned (FComPort) then
    FComPort.PutBlock (ABlock, ASize);
end;

procedure TApdStateComPortSource.Pause;
var
  i : Integer;

begin
  inherited Pause;

  for I := 0 to pred (PacketList.Count) do
    TApdDataPacket (PacketList[I]).Enabled := False;
end;

procedure TApdStateComPortSource.Resume;
var
  i : Integer;

begin
  inherited Resume;

  if not Paused then
    for I := 0 to pred (PacketList.Count) do
      if (TApdDataPacket (PacketList[I]).StartString <> '') or
         (TApdDataPacket (PacketList[I]).PacketSize > 0) or
         (TApdDataPacket (PacketList[I]).EndString <> '') then
      TApdDataPacket (PacketList[I]).Enabled := True;
end;

procedure TApdStateComPortSource.SetComPort (const Value : TApdCustomComPort);
begin
  FComPort := Value;
end;

procedure TApdStateComPortSource.StateActivate (State : TApdCustomState);
begin
  FComPort.AddStringToLog(AnsiString(Name+ ': Activate'));
  if State.OutputOnActivate <> '' then
    FComPort.Output := AnsiString(State.OutputOnActivate);
end;

procedure TApdStateComPortSource.StateChange (
                                      OldState, NewState : TApdCustomState);
var
  I : Integer;
begin
  { disable the packets }
  for I := 0 to pred(PacketList.Count) do begin
    TApdDataPacket(PacketList[I]).Free;
    PacketList[I] := nil;
  end;
  PacketList.Clear;
end;

procedure TApdStateComPortSource.StateMachineActivate (
                                                State : TApdCustomState;
                                                Condition : TApdStateCondition;
                                                Index : Integer);
begin
  if Assigned (State) and (State.ActionState) then begin
    Exit;
  end;

  PacketList.Add(TApdDataPacket.Create(Self));
  with TApdDataPacket(PacketList[Index]) do begin
    Tag := Index;
    AutoEnable := False;
    Enabled := False;

    { assign the port and OnPacket event handler }
    ComPort := FComPort;
    OnPacket := PacketEvent;
    OnTimeout := PacketTimeout;

    { set up the Start and End conditions }
    StartString := AnsiString(State.Conditions[Index].StartString);
    if StartString = '' then
      StartCond := scAnyData
    else
      StartCond := scString;

    EndCond := [];
    EndString := AnsiString(State.Conditions[Index].EndString);
    if EndString <> '' then
      EndCond := EndCond + [ecString];
    PacketSize := State.Conditions[Index].PacketSize;
    if PacketSize > 0 then
      EndCond := EndCond + [ecPacketSize];

    Timeout := State.Conditions[Index].Timeout;
    { If there is a definition to the data packet then go ahead and use that
      otherwise, if it's an empty data packet then assume that state fires }
    if (StartString <> '') or (PacketSize > 0) or (EndString <> '') then begin
      Enabled := True;
      InternalManager.KeepAlive := True;
    end else
      FStateMachine.ChangeState (Index);
  end;
end;

procedure TApdStateComPortSource.StateMachineDeactivate (State : TApdCustomState);
var
  I : Integer;
begin
  { disable and free our Condition's data packets }
  for I := 0 to pred(PacketList.Count) do begin
    TApdDataPacket(PacketList[I]).Free;
    PacketList[I] := nil;
  end;
  PacketList.Clear;                                                      {!!.05}
end;

procedure TApdStateComPortSource.StateMachineStart (
              AOwner : TApdCustomStateMachine);
begin
  inherited StateMachineStart (AOwner);

  if not Assigned(FComPort) then
    raise EPortNotAssigned.Create(ecPortNotAssigned, False);
  if not(FComPort.Open) and (FComPort.AutoOpen) then
    FComPort.Open := True;
  if Assigned (ComPort.Dispatcher) then
    ComPort.Dispatcher.RegisterEventTriggerHandler (TriggerHandler);
end;

procedure TApdStateComPortSource.StateMachineStop;
begin
  inherited StateMachineStop;

  if not Assigned (FComPort) then
    Exit;
  if Assigned (FComport.Dispatcher) then
    ComPort.Dispatcher.DeregisterEventTriggerHandler (TriggerHandler);
end;

procedure TApdStateComPortSource.TriggerHandler (Msg, wParam : Cardinal;
                                                 lParam : Integer);
var
  Count  : Word absolute wParam;

begin
  if (Msg = APW_TRIGGERAVAIL) and
     (Assigned (FComPort)) then begin

     if (not Assigned (FBuffer)) then begin
       if Count > 8192 then
         FBufferSize := Count + 8192
       else
         FBufferSize := 8192;
       GetMem (FBuffer, FBufferSize);
     end;
     if Count > FBufferSize then begin
       FreeMem (FBuffer, FBufferSize);
       GetMem (FBuffer, FBufferSize + 8192);
     end;

    ComPort.Dispatcher.GetBlock (FBuffer, Count);
    PChar (FBuffer)[Count] := #$00;
    if Assigned (FOnGetData) then
      FOnGetData (Self, FBuffer, Count);
    if Assigned (FOnGetDataString) then
      FOnGetDataString (Self, PChar (FBuffer));
    if Assigned (StateMachine) and
       Assigned (StateMachine.CurrentState) then begin
       if Assigned (StateMachine.CurrentState.FOnGetData) then
         StateMachine.CurrentState.FOnGetData (StateMachine.CurrentState,
                                               FBuffer, Count);
       if Assigned (StateMachine.CurrentState.FOnGetDataString) then
         StateMachine.CurrentState.FOnGetDataString (StateMachine.CurrentState,
                                                     PChar (FBuffer));
    end;
  end;
end;

procedure TApdStateComPortSource.Notification (AComponent : TComponent;
              Operation : TOperation);
begin
  inherited Notification (AComponent, Operation);

  if (Operation = opRemove) then begin
    {See if our com port is going away}
    if (AComponent = FComPort) then
      FComPort := nil;
  end else if (Operation = opInsert) then begin
    {Check for a com port being installed}
    if not Assigned(FComPort) and (AComponent is TApdCustomComPort) then
      FComPort := TApdCustomComPort(AComponent);
  end;
end;

procedure TApdStateComPortSource.PacketEvent(Sender: TObject;
  Data: Pointer; Size: Integer);
var
  Index : Integer;
  DataString : String;
begin
  Index := TApdDataPacket(Sender).Tag;
  {$IFOPT H-}
  if Size > 255 then
    raise EStringSizeError.Create(ecPacketTooLong, False);
  {$ENDIF}
   SetLength (DataString, Size);
   Move (Data^, DataString[1], Size); // TODO Tiburon
  StateMachine.SetData (Data, DataString, Size);
  StateMachine.ChangeState (Index);
end;

procedure TApdStateComPortSource.PacketTimeout(Sender: TObject);
var
  i         : Integer;
  NextState : Integer;
begin
  NextState := -1;
  if (Assigned (StateMachine)) and
     (Assigned (StateMachine.CurrentState)) then begin
    for i := 0 to StateMachine.CurrentState.Conditions.Count - 1 do
      if StateMachine.CurrentState.Conditions[i].DefaultError then begin
        NextState := i;
        Break;
      end;
    { if a default error was not found, use the default next }
    if NextState = -1 then begin
      for i := 0 to StateMachine.CurrentState.Conditions.Count - 1 do
        if StateMachine.CurrentState.Conditions[i].DefaultNext then begin
          NextState := i;
          Break;
        end;
      end;
    if NextState <> - 1 then
      StateMachine.ChangeState (NextState);
  end;
end;

procedure TApdStateComPortSource.StateDeactivate (State : TApdCustomState);
begin
  if FComPort.Open then                                                  {!!.06}
    FComPort.AddStringToLog (AnSiString(Name + ': Deactivate'));
end;

{ TApdCustomStateMachine }

procedure TApdCustomStateMachine.Cancel;
begin
  DoDeactivate;
end;

procedure TApdCustomStateMachine.ChangeState (ConditionIndex : Integer);
begin
  if Paused then
    Exit;
  PostMessage (Handle, apw_StateChange, ConditionIndex, 0);
end;

procedure TApdCustomStateMachine.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;
  inherited;
end;

procedure TApdCustomStateMachine.CMDesignHitTest (var Msg : TWMMouse);
var
  i : Integer;
  Point : TPoint;
  State : TApdCustomState;
  AddType : TApdConnectAddType;
begin
  Msg.Result := 0;
  if (Msg.Keys and MK_LBUTTON) <> 0 then begin
    Point.x := Msg.XPos;
    Point.y := Msg.YPos;
    if (Point.x < Left) or (Point.x > Left + Width) or
       (Point.y < Top) or (Point.y > Top + Height) then
      Exit;
    for i := 0 to pred (ControlCount) do begin
      if Controls[i] is TApdCustomState then begin
        State := TApdCustomState(Controls[i]);
        if (Point.x >= State.Left) and
           (Point.x <= State.Left + State.Width) and
           (Point.y >= State.Top) and
           (Point.y <= State.Top + State.Height) then
          Exit;
      end;
    end;
    if (Msg.Keys and MK_SHIFT) <> 0 then
      AddType := atAdd
    else if (Msg.Keys and MK_CONTROL) <> 0 then
      AddType := atSub
    else
      AddType := atNone;

    ConnectoidAtPoint (AddType, Point);
  end;
end;

procedure TApdCustomStateMachine.ConnectoidAtPoint (
                                             AddType : TApdConnectAddType;
                                             Point : TPoint);

  function PointInRect (Point : TPoint; Rect : TRect;
                        Offset : Integer) : Boolean;
  var
    t : Integer;
  begin
    Result := False;
    { Sort the rectangle points }
    if (Rect.Left > Rect.Right) then begin
      t := Rect.Right;
      Rect.Right := Rect.Left;
      Rect.Left := t;
    end;
    if (Rect.Top > Rect.Bottom) then begin
      t := Rect.Bottom;
      Rect.Bottom := Rect.Top;
      Rect.Top := t;
    end;
    if (Point.x >= Rect.Left - Offset) and
       (Point.x <= Rect.Right + Offset) and
       (Point.y >= Rect.Top - Offset) and
       (Point.y <= Rect.Bottom + Offset) then
      Result := True;
  end;

  function CheckConnectoid (State, DestState: TApdCustomState) : Boolean;
  const
    ApdCCOffset = 4;

  var
    StartAt : TPoint;
    EndAt : TPoint;
    MidPoint : TPoint;
    MinPoint : TPoint;
    MaxPoint : TPoint;

  begin
    Result := False;
    if Assigned (State) and Assigned(DestState) and
      (State <> nil) and (DestState <> nil) then begin
      StartAt.x := State.Left + (State.Width div 2);
      StartAt.y := State.Top + (State.Height div 2);
      EndAt.x := DestState.Left + (DestState.Width div 2);
      EndAt.y := DestState.Top + (DestState.Height div 2);
      if StartAt.x > EndAt.x then begin
        MinPoint.x := EndAt.x;
        MaxPoint.x := StartAt.x;
      end else begin
        MinPoint.x := StartAt.x;
        MaxPoint.x := EndAt.x;
      end;
      if StartAt.y > EndAt.y then begin
        MinPoint.y := EndAt.y;
        MaxPoint.y := StartAt.y;
      end else begin
        MinPoint.y := StartAt.y;
        MaxPoint.y := EndAt.y;
      end;
      MidPoint.x := (MaxPoint.x - MinPoint.x) div 2 + MinPoint.x;
      MidPoint.y := (MaxPoint.y - MinPoint.y) div 2 + MinPoint.y;

      { Important note:
        If the mechanism by which the connectoids are drawn is changed,
        this code must be changed to reflect the drawing mechanism }
      if DestState = State then begin
        Dec (StartAt.x, 8);
        if PointInRect (Point, Rect (State.Left + State.Width - 14,
                                     State.Top - 6,
                                     State.Left + State.Width - 8,
                                     State.Top),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (State.Left + State.Width + 12,
                                     State.Top - 12,
                                     State.Left + State.Width - 12,
                                     State.Top + 12),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (DestState.Left + DestState.Width + 4,
                                     State.Top + 14,
                                     DestState.Left + DestState.Width,
                                     State.Top + 6),
                        ApdCCOffset) then
          Result := True;
      end else if (DestState.Top > State.Top + State.Height) then begin
        Dec (StartAt.x, 8);
        Dec (EndAt.x, 8);
        Dec (MidPoint.y, 4);
        { Check Start }
        if PointInRect (Point, Rect (StartAt.x - 3,
                                     State.Top + State.Height + 6,
                                     StartAt.x + 3,
                                     State.Top + State.Height),
                        ApdCCOffset) then
          Result := True;
        { Check Connectoid }
        if PointInRect (Point, Rect (StartAt.x, StartAt.y,
                                     StartAt.x, MidPoint.y),
                        ApdCCOffset) then
          Result := True;

        if PointInRect (Point, Rect (StartAt.x, MidPoint.y,
                                     EndAt.x, MidPoint.y),
                        ApdCCOffset) then
          Result := True;

        if PointInRect (Point, Rect (EndAt.x, MidPoint.y,
                                     EndAt.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (EndAt.x - 4, DestState.Top,
                                     EndAt.x + 4, DestState.Top - 4),
                        ApdCCOffset) then
          Result := True;
      end else if (DestState.Top + DestState.Height < State.Top) then begin
        Inc (StartAt.x, 8);
        Inc (EndAt.x, 8);
        Inc (MidPoint.y, 4);
        { Check Start }
        if PointInRect (Point, Rect (StartAt.x - 3, State.Top - 6,
                                     StartAt.x + 3, State.Top),
                        ApdCCOffset) then
          Result := True;
        { Check Connectoid }
        if PointInRect (Point, Rect (StartAt.x, StartAt.y,
                                     StartAt.x, MidPoint.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (StartAt.x, MidPoint.y,
                                     EndAt.x, MidPoint.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (EndAt.x, MidPoint.y,
                                     EndAt.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (EndAt.x - 4,
                                     DestState.Top + DestState.Height,
                                     EndAt.x + 4,
                                     DestState.Top + DestState.Height + 4),
                        ApdCCOffset) then
          Result := True;
      end else if (DestState.Left > State.Left + State.Width) then begin
        Dec (StartAt.y, 8);
        Dec (EndAt.y, 8);
        Dec (MidPoint.x, 4);
        { Check Start }
        if PointInRect (Point, Rect (State.Left + State.Width,
                                     StartAt.y - 3,
                                     State.Left + State.Width + 6,
                                     StartAt.y + 3),
                        ApdCCOffset) then
          Result := True;
        { Check Connectoid }
        if PointInRect (Point, Rect (StartAt.x, StartAt.y,
                                     MidPoint.x, StartAt.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (MidPoint.x, StartAt.y,
                                     MidPoint.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (MidPoint.x, EndAt.y,
                                     EndAt.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (DestState.Left - 4, EndAt.y - 4,
                                     DestState.Left, EndAt.y + 4),
                        ApdCCOffset) then
          Result := True;
      end else if (DestState.Left + DestState.Width < State.Left) then begin
        Inc (StartAt.y, 8);
        Inc (EndAt.y, 8);
        Inc (MidPoint.x, 4);
        { Check Start }
        if PointInRect (Point, Rect (State.Left - 6, StartAt.y - 3,
                                     State.Left, StartAt.y + 3),
                        ApdCCOffset) then
          Result := True;
        { Check Connectoid }
        if PointInRect (Point, Rect (StartAt.x, StartAt.y,
                                     MidPoint.x, StartAt.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (MidPoint.x, StartAt.y,
                                     MidPoint.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (MidPoint.x, EndAt.y, EndAt.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (DestState.Left + DestState.Width,
                                     EndAt.y - 4,
                                     DestState.Left + DestState.Width + 4,
                                     EndAt.y + 4),
                        ApdCCOffset) then
          Result := True;
      end;
    end;
  end;

var
  i : Integer;
  c : Integer;
  State : TApdCustomState;

begin
  for i := 0 to pred(ControlCount) do begin
    if Controls[i] is TApdCustomState then begin
      State := TApdCustomState(Controls[i]);
      if State.Conditions.Count > 0 then begin
        for c := 0 to pred(State.Conditions.Count) do
          if State.Conditions[c].NextState <> nil then begin
            if AddType = atNone then
              State.Conditions[c].Connectoid.FSelected := False;
            if CheckConnectoid (State, State.Conditions[c].NextState) then begin
              if AddType <> atSub then begin
                State.Conditions[c].Connectoid.FSelected := True;
                if not (csDesigning in ComponentState) then begin
                  if Assigned (FConnectoidClickEvent) then
                    FConnectoidClickEvent (Self,
                                           State.Conditions[c].Connectoid);
                end;
              end else
                State.Conditions[c].Connectoid.FSelected := False;
            end;
          end;
      end;
    end;
  end;
  Invalidate;
end;

constructor TApdCustomStateMachine.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csOpaque, csAcceptsControls, csFramed, csCaptureMouse,
                   csClickEvents, csSetCaption, csDoubleClicks];
  {create our canvas}
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  FBorderStyle := bsSingle;
  FMovableStates := False;
  ConnectoidClickStyle := [];
  Color := clWhite;
  Height := 200;
  Width := 200;
  FDefaultDataSource := TApdStateComPortSource.Create (Self);
  FDefaultDataSource.ComPort := SearchComPort (Owner);
  FDataSource := nil;
end;

procedure TApdCustomStateMachine.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

destructor TApdCustomStateMachine.Destroy;
begin
  if Assigned (CurrentState) then
    DoDeactivate;
  FDefaultDataSource.Free;
  FDefaultDataSource := nil;
  FCanvas.Free;
  inherited;
end;

procedure TApdCustomStateMachine.DoActivate(NewState : TApdCustomState);

  function GetRealNextState (NextState : TApdCustomState) : TApdCustomState;
  var
    i      : Integer;
    Done   : Boolean;
    GotOne : Boolean;

  begin
    Result := NextState;
    Done := False;
    while not Done do begin
      GotOne := False;
      for i := 0 to Result.Conditions.Count - 1 do
        if (Result.Conditions[i].DefaultNext) and
           (Assigned (Result.Conditions[i].NextState)) then begin
          Result.Deactivate;
          Result := Result.Conditions[i].NextState;
          Result.Activate;
          GotOne := True;
          Break;
        end;
      if not GotOne then
        Done := True;
    end;
  end;

var
  I : Integer;
begin
  if Paused then
    Exit;

  if (NewState.Conditions.Count = 0) or
     (NewState = TerminalState) then begin
    { no conditions set, must be done }
    FCurrentState := NewState;
    NewState.Activate;
    if Assigned(FOnStateMachineFinish) then
      FOnStateMachineFinish(Self, FLastErrorCode);
    FActive := False;                                                    {!!.02}
  end else begin
    { we're activating a state, get the parameters for the packets }
    for I := 0 to pred(NewState.Conditions.Count) do begin
      if Assigned (LiveDataSource) then
        LiveDataSource.StateMachineActivate (NewState,
                                             NewState.Conditions[I], I);
    end;
    FCurrentState := NewState;
    NewState.Activate;
    FActive := True;                                                     {!!.02}
  end;
end;

procedure TApdCustomStateMachine.DoDeactivate;
begin
  if Paused then
    Exit;

  if Assigned (LiveDataSource) then
    LiveDataSource.StateMachineDeactivate (FCurrentState);
  FCurrentState.Deactivate;
end;

procedure TApdCustomStateMachine.DoStateChange(var M: TMessage);
var
  NextState : TApdCustomState;
begin
  if Paused then
    Exit;

  NextState := FCurrentState.Conditions[M.WParam].NextState;


  if Assigned (LiveDataSource) then
    LiveDataSource.StateChange (FCurrentState,
                                FCurrentState.Conditions[M.WParam].NextState);

  if Assigned(FCurrentState.FOnStateFinish) then begin
    FCurrentState.FOnStateFinish(FCurrentState,
      FCurrentState.FConditions[M.WParam], NextState);
  end;

  if Assigned (LiveDataSource) then
    LiveDataSource.StateChange (FCurrentState,
                                FCurrentState.Conditions[M.WParam].NextState);

  { tell the state to deactivate }
  DoDeactivate;

  { generate the appropriate events }
  if Assigned(FOnStateChange) then
    FOnStateChange(Self, FCurrentState, NextState);

  if (Assigned (LiveDataSource)) and
      (FCurrentState.Conditions[M.wParam].OutputOnActivate <> '') then
    LiveDataSource.Output (FCurrentState.Conditions[M.wParam].OutputOnActivate);
  { activate the next state }
  DoActivate(NextState);
end;

function TApdCustomStateMachine.GetComPort : TApdCustomComPort;
begin
  if LiveDataSource is TApdStateComPortSource then
    Result := TApdStateComPortSource (LiveDataSource).ComPort
  else if Assigned (FDefaultDataSource) then
    Result := FDefaultDataSource.ComPort
  else
    Result := nil;
end;

function TApdCustomStateMachine.GetData: Pointer;
begin
  Result := FData;
end;

function TApdCustomStateMachine.GetDataSource : TApdStateCustomDataSource;
begin
  if Assigned (FDataSource) then
    Result := FDataSource
  else
    Result := nil;
end;

function TApdCustomStateMachine.GetDataSize: Integer;
begin
  Result := FDataSize;
end;

function TApdCustomStateMachine.GetDataString: string;
begin
  Result := FDataString;
end;

function TApdCustomStateMachine.GetLiveDataSource : TApdStateCustomDataSource;
begin
  if Assigned (FDataSource) then
    Result := FDataSource
  else
    Result := FDefaultDataSource;
end;

function TApdCustomStateMachine.GetPaused;
begin
  if Assigned (LiveDataSource) then
    Result := LiveDataSource.Paused
  else
    Result := FDefaultDataSource.Paused;
end;

function TApdCustomStateMachine.GetStateNames: TStringList;
var
  I : Integer;
begin
  Result := TStringList.Create;
  for I := 0 to pred(Owner.ComponentCount) do
    if Owner.Components[I] is TApdCustomState then
      if TApdCustomState(Owner.Components[I]).FStateMachine = Self then
      Result.Add(TApdCustomState(Owner.Components[I]).Name);
end;

procedure TApdCustomStateMachine.Loaded;
begin
  inherited;
end;

procedure TApdCustomStateMachine.MouseDown (Button : TMouseButton;
                                            Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
  Point : TPoint;
  State : TApdCustomState;
  AddType : TApdConnectAddType;

begin
  if Button = mbLeft then begin
    Point.x := X;
    Point.y := Y;
    if (Point.x < Left) or (Point.x > Left + Width) or
       (Point.y < Top) or (Point.y > Top + Height) then
      Exit;
    for i := 0 to pred (ControlCount) do begin
      if Controls[i] is TApdCustomState then begin
        State := TApdCustomState(Controls[i]);
        if (Point.x >= State.Left) and
           (Point.x <= State.Left + State.Width) and
           (Point.y >= State.Top) and
           (Point.y <= State.Top + State.Height) then
          Exit;
      end;
    end;
    if (ssShift in Shift) then
      AddType := atAdd
    else if (ssCtrl in Shift) then
      AddType := atSub
    else
      AddType := atNone;

    ConnectoidAtPoint (AddType, Point);
  end;
  inherited MouseDown (Button, Shift, X, Y);
end;

procedure TApdCustomStateMachine.Notification (AComponent : TComponent;
              Operation : TOperation);
begin
  inherited Notification (AComponent, Operation);

  if (Operation = opRemove) then begin
    {See if our com port is going away}
    if (AComponent = ComPort)  then
      ComPort := nil
    else if (AComponent = FDataSource) then
      FDataSource := nil
    else if (AComponent = FStartState) then
      FStartState := nil
    else if (AComponent = FTerminalState) then
      FTerminalState := nil;
  end else if (Operation = opInsert) then begin
    {Check for a com port being installed}
    if not Assigned (ComPort) and
       (AComponent is TApdCustomComPort) then
      ComPort := TApdCustomComPort (AComponent);
  end;
end;

procedure TApdCustomStateMachine.StateMachinePaint;
var
  R   : TRect;
  I, C  : Integer;
  State : TApdCustomState;
  HintText : string;

begin
  HintText := '';
  {get the display dimensions}
  R := GetClientRect;
  { clear the existing display }
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(R);
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := clActiveBorder;
  Canvas.TextRect(R, 2, 2, Caption);

  { draw the connectoids }
  for I := 0 to pred(ControlCount) do begin
    if Controls[I] is TApdCustomState then begin
      State := TApdCustomState(Controls[I]);
      if State.Conditions.Count > 0 then begin
        for C := 0 to pred(State.Conditions.Count) do
          if State.Conditions[C].NextState <> nil then begin
            RenderConnectoid (State.Conditions[C].Connectoid,
                              State, State.Conditions[C].NextState);
            if (State.Conditions[C].Connectoid.FSelected) and
               ((csDesigning in ComponentState) or
                (ccsHint in ConnectoidClickStyle)) then
              HintText := HintText + State.Name + ' -> ' +
                          State.Conditions[C].NextState.Name + '   ';
          end;
      end;
    end;
  end;

  { tell the states to draw themselves }
  for I := 0 to pred(ControlCount) do begin
    if Controls[I] is TApdCustomState then
      TApdCustomState(Controls[I]).Paint;
  end;

  { Display Hint Text }

  if HintText <> '' then begin
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 1;
    Canvas.Brush.Color := $00bfffff;
    Canvas.Font.Color := clBlack;
    Canvas.Rectangle (3, 3,
                      Canvas.TextWidth (HintText) + 7,
                      Canvas.TextHeight (HintText) + 7);
    Canvas.TextOut (5, 5, HintText);
    Canvas.Brush.Color := clWhite;
  end;
end;

procedure TApdCustomStateMachine.PaintWindow(DC: HDC);
var
  R : TRect;
begin
  Canvas.Handle := DC;
  try
    R := ClientRect;
    InvalidateRect(Canvas.Handle, @R, True);
    StateMachinePaint;
  finally
    Canvas.Handle := 0;
  end;
end;

procedure TApdCustomStateMachine.Pause;
begin
  if Assigned (LiveDataSource) then
    LiveDataSource.Pause;
  FDefaultDataSource.Pause;
end;

procedure TApdCustomStateMachine.RenderConnectoid (
                                           Connectoid : TApdStateConnectoid;
                                           State, DestState : TApdCustomState);
var
  StartAt : TPoint;
  EndAt : TPoint;
  MidPoint : TPoint;
  MinPoint : TPoint;
  MaxPoint : TPoint;
  OldColor : TColor;
begin
    if Assigned(Connectoid) and Assigned(DestState) and
      (Connectoid <> nil) and (DestState <> nil) then begin
      StartAt.x := State.Left + (State.Width div 2);
      StartAt.y := State.Top + (State.Height div 2);
      EndAt.x := DestState.Left + (DestState.Width div 2);
      EndAt.y := DestState.Top + (DestState.Height div 2);
      if StartAt.x > EndAt.x then begin
        MinPoint.x := EndAt.x;
        MaxPoint.x := StartAt.x;
      end else begin
        MinPoint.x := StartAt.x;
        MaxPoint.x := EndAt.x;
      end;
      if StartAt.y > EndAt.y then begin
        MinPoint.y := EndAt.y;
        MaxPoint.y := StartAt.y;
      end else begin
        MinPoint.y := StartAt.y;
        MaxPoint.y := EndAt.y;
      end;
      MidPoint.x := (MaxPoint.x - MinPoint.x) div 2 + MinPoint.x;
      MidPoint.y := (MaxPoint.y - MinPoint.y) div 2 + MinPoint.y;

      OldColor := Canvas.Pen.Color;
      Canvas.Font.Assign (Connectoid.Font);
      if (Connectoid.FSelected) and
         ((csDesigning in ComponentState) or
          (ccsHighlight in ConnectoidClickStyle)) then begin
        if Connectoid.Color = clRed then
          Canvas.Pen.Color := clFuchsia
        else
          Canvas.Pen.Color := clRed;
        Canvas.Font.Color := clRed;
      end else
        Canvas.Pen.Color := Connectoid.Color;
      Canvas.Pen.Width := Connectoid.Width;

      if DestState = State then begin
        Dec (StartAt.x, 8);
        Canvas.Ellipse (State.Left + State.Width - 14, State.Top - 6,
                        State.Left + State.Width - 8, State.Top);
        Canvas.Ellipse (State.Left + State.Width + 12, State.Top - 12,
                        State.Left + State.Width - 12, State.Top + 12);
        { Draw Arrow }
        Canvas.MoveTo (DestState.Left + DestState.Width, State.Top + 10);
        Canvas.LineTo (DestState.Left + DestState.Width + 4, State.Top + 6);
        Canvas.MoveTo (DestState.Left + DestState.Width, State.Top + 10);
        Canvas.LineTo (DestState.Left + DestState.Width + 4, State.Top + 14);
        Canvas.TextOut(State.Left + State.Width -
                       Canvas.TextWidth (Connectoid.Caption) div 2,
                       State.Top - 14 - Canvas.TextHeight (Connectoid.Caption),
                       Connectoid.Caption);
      end else if (DestState.Top > State.Top + State.Height) then begin
        Dec (StartAt.x, 8);
        Dec (EndAt.x, 8);
        Dec (MidPoint.y, 4);
        { Draw Start }
        Canvas.Ellipse (StartAt.x - 3, State.Top + State.Height + 6,
                        StartAt.x + 3, State.Top + State.Height);
        { Draw Connectoid }
        Canvas.MoveTo (StartAt.x, StartAt.y);
        Canvas.LineTo (StartAt.x, MidPoint.y);
        Canvas.LineTo (EndAt.x, MidPoint.y);
        Canvas.LineTo (EndAt.x, EndAt.y);
        { Draw Arrow }
        Canvas.MoveTo (EndAt.x, DestState.Top);
        Canvas.LineTo (EndAt.x - 4, DestState.Top - 4);
        Canvas.MoveTo (EndAt.x, DestState.Top);
        Canvas.LineTo (EndAt.x + 4, DestState.Top - 4);
        if EndAt.x > StartAt.x then
          Canvas.TextOut(StartAt.x + 2,
                         MidPoint.y - Canvas.TextHeight (Connectoid.Caption) - 2,
                         Connectoid.Caption)
        else
          Canvas.TextOut(StartAt.x - 2 - Canvas.TextWidth (Connectoid.Caption),
                         MidPoint.y - Canvas.TextHeight (Connectoid.Caption) - 2,
                         Connectoid.Caption)
      end else if (DestState.Top + DestState.Height < State.Top) then begin
        Inc (StartAt.x, 8);
        Inc (EndAt.x, 8);
        Inc (MidPoint.y, 4);
        { Draw Start }
        Canvas.Ellipse (StartAt.x - 3, State.Top - 6,
                        StartAt.x + 3, State.Top);
        { Draw Connectoid }
        Canvas.MoveTo (StartAt.x, StartAt.y);
        Canvas.LineTo (StartAt.x, MidPoint.y);
        Canvas.LineTo (EndAt.x, MidPoint.y);
        Canvas.LineTo (EndAt.x, EndAt.y);
        { Draw Arrow }
        Canvas.MoveTo (EndAt.x, DestState.Top + DestState.Height);
        Canvas.LineTo (EndAt.x - 4, DestState.Top + DestState.Height + 4);
        Canvas.MoveTo (EndAt.x, DestState.Top + DestState.Height);
        Canvas.LineTo (EndAt.x + 4, DestState.Top + DestState.Height + 4);
        if EndAt.x >= StartAt.x then
          Canvas.TextOut(StartAt.x + 2,
                         MidPoint.y + 2,
                         Connectoid.Caption)
        else
          Canvas.TextOut(StartAt.x - 2 - Canvas.TextWidth (Connectoid.Caption),
                         MidPoint.y + 2,
                         Connectoid.Caption)
      end else if (DestState.Left > State.Left + State.Width) then begin
        Dec (StartAt.y, 8);
        Dec (EndAt.y, 8);
        Dec (MidPoint.x, 4);
        { Draw Start }
        Canvas.Ellipse (State.Left + State.Width, StartAt.y - 3,
                        State.Left + State.Width + 6, StartAt.y + 3);
        { Draw Connectoid }
        Canvas.MoveTo (StartAt.x, StartAt.y);
        Canvas.LineTo (MidPoint.x, StartAt.y);
        Canvas.LineTo (MidPoint.x, EndAt.y);
        Canvas.LineTo (EndAt.x, EndAt.y);
        { Draw Arrow }
        Canvas.MoveTo (DestState.Left, EndAt.y);
        Canvas.LineTo (DestState.Left - 4, EndAt.y - 4);
        Canvas.MoveTo (DestState.Left, EndAt.y);
        Canvas.LineTo (DestState.Left - 4, EndAt.y + 4);
        if EndAt.y >= StartAt.y then
          Canvas.TextOut(State.Left + State.Width + 10,
                         StartAt.y - Canvas.TextHeight (Connectoid.Caption) - 2,
                         Connectoid.Caption)
        else
          Canvas.TextOut(DestState.Left - Canvas.TextWidth (Connectoid.Caption) -  2,
                         EndAt.y - Canvas.TextHeight (Connectoid.Caption) - 2,
                         Connectoid.Caption)
      end else if (DestState.Left + DestState.Width < State.Left) then begin
        Inc (StartAt.y, 8);
        Inc (EndAt.y, 8);
        Inc (MidPoint.x, 4);
        { Draw Start }
        Canvas.Ellipse (State.Left - 6, StartAt.y - 3,
                        State.Left, StartAt.y + 3);
        { Draw Connectoid }
        Canvas.MoveTo (StartAt.x, StartAt.y);
        Canvas.LineTo (MidPoint.x, StartAt.y);
        Canvas.LineTo (MidPoint.x, EndAt.y);
        Canvas.LineTo (EndAt.x, EndAt.y);
        { Draw Arrow }
        Canvas.MoveTo (DestState.Left + DestState.Width, EndAt.y);
        Canvas.LineTo (DestState.Left + DestState.Width + 4, EndAt.y - 4);
        Canvas.MoveTo (DestState.Left + DestState.Width, EndAt.y);
        Canvas.LineTo (DestState.Left + DestState.Width + 4, EndAt.y + 4);
        if EndAt.y <= StartAt.y then
          Canvas.TextOut(State.Left - Canvas.TextWidth (Connectoid.Caption) - 2,
                         StartAt.y + 2,
                         Connectoid.Caption)
        else
          Canvas.TextOut(DestState.Left + DestState.Width + 2,
                         EndAt.y + 2,
                         Connectoid.Caption)
      end else begin
      end;
      if (Connectoid.FSelected) and
         ((csDesigning in ComponentState) or
          (ccsDashedLine in ConnectoidClickStyle)) then begin
        Canvas.Pen.Color := clMaroon;
        Canvas.Pen.Style := psDot;
        Canvas.Pen.Width := 1;
        Canvas.MoveTo (State.Left + State.Width div 2,
                       State.Top + State.Height div 2);
        Canvas.LineTo (DestState.Left + DestState.Width div 2,
                       DestState.Top + DestState.Height div 2);
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Width := Connectoid.Width;
      end;

      Canvas.Pen.Color := OldColor;
    end;
end;

procedure TApdCustomStateMachine.Resume;
begin
  if Assigned (LiveDataSource) then
    LiveDataSource.Resume;
  FDataSource.Resume;
end;

procedure TApdCustomStateMachine.SetBorderStyle(const Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TApdCustomStateMachine.SetCaption(const Value: TCaption);
begin
  inherited Caption := Value;
  FCaption := Value;
  Refresh;
end;

procedure TApdCustomStateMachine.SetConnectoidClickStyle (
              const v : TAdConnectoidClickStyles);
begin
  if v <> FConnectoidClickStyle then begin
    FConnectoidClickStyle := v;
    Invalidate;
  end;
end;

procedure TApdCustomStateMachine.SetComPort (const Value : TApdCustomComPort);
begin
  if LiveDataSource is TApdStateComPortSource then
    TApdStateComPortSource (LiveDataSource).ComPort := Value;
  if Assigned (FDefaultDataSource) then
    FDefaultDataSource.ComPort := Value;
end;

procedure TApdCustomStateMachine.SetData (NewData : Pointer;
                                          NewDataString : string;
                                          NewDataSize : Integer);
begin
  FData := NewData;
  FDataString := NewDataString;
  FDataSize := NewDataSize;
end;

procedure TApdCustomStateMachine.SetDataSource (
                                    const v : TApdStateCustomDataSource);
begin
  FDataSource := v;
end;

procedure TApdCustomStateMachine.SetMovableStates (const v : Boolean);
begin
  if v <> FMovableStates then
    FMovableStates := v;
end;

procedure TApdCustomStateMachine.SetStartState(
  const Value: TApdCustomState);
begin
  FStartState := Value;
end;

procedure TApdCustomStateMachine.SetTerminalState(
  const Value: TApdCustomState);
begin
  FTerminalState := Value;
end;

procedure TApdCustomStateMachine.Start;
  begin
  if not Assigned (LiveDataSource) then
    raise EPortNotAssigned.Create (ecPortNotAssigned, False);
  LiveDataSource.StateMachineStart (Self);

  if Assigned(FStartState) then begin
    FLastErrorCode := ecOK;
    DoActivate(FStartState);
  end else
    raise EStateMachine.Create (ecNoStartState, False);
end;


procedure TApdCustomStateMachine.WMNCHitTest(var Message: TMessage);
begin
  DefaultHandler(Message);
end;

procedure TApdCustomStateMachine.WMEraseBackground (var Msg : TWMERASEBKGND);
begin
  Msg.Result := 1;
end;

{ TApdCustomState }

procedure TApdCustomState.Activate;
  { called by the state machine after the condition's data packets are set up }
begin
  if Assigned (FStateMachine.LiveDataSource) then
    FStateMachine.LiveDataSource.StateActivate (Self);
  FActive := True;
  FCompleted := False;
  Refresh;

  if Assigned(FOnStateActivate) then
    FOnStateActivate(Self);
end;

constructor TApdCustomState.Create(AOwner: TComponent);
begin
  inherited;
  FUseLeftBorder := False;
  FLeftBorderWidth := 0;
  FLeftBorderFill := clYellow;
  Color := clWhite;
  UpdateBoundsRect(Rect(Left, Top, 75, 50));
  FActive := False;
  FCompleted := False;
  HaveGlyph := False;
  FActiveColor := clYellow;
  FMovable := False;
  FGlyph := TBitmap.Create;
  FOldX := 0;
  FOldY := 0;
  FMoving := False;
  FActionState := False;
  Conditions := TApdStateConditions.Create(Self, TApdStateCondition);
end;

procedure TApdCustomState.Deactivate;
begin
  FActive := False;
  FCompleted := True;
  Refresh;
  if Assigned (FStateMachine.LiveDataSource) then
    FStateMachine.LiveDataSource.StateDeactivate (Self);
end;

destructor TApdCustomState.Destroy;
begin
  FGlyph.Free;
  FConditions.Free;
  FStateMachine.Refresh;
  inherited;
end;

function TApdCustomState.FindDefaultError : Integer;
var
  i : Integer;

begin
  Result := -1;
  for i := 0 to Conditions.Count - 1 do
    if (Conditions[i].DefaultError) and
       (Assigned (Conditions[i].NextState)) then begin
      Result := i;
      Break;
    end;
end;

function TApdCustomState.FindDefaultNext : Integer;
var
  i : Integer;

begin
  Result := -1;
  for i := 0 to Conditions.Count - 1 do
    if (Conditions[i].DefaultNext) and
       (Assigned (Conditions[i].NextState)) then begin
      Result := i;
      Break;
    end;
end;

procedure TApdCustomState.Loaded;
begin
  inherited;
  SetGlyph(FGlyph);
  FInactiveColor := FStateMachine.Color;
  Refresh;
end;

procedure TApdCustomState.MouseDown (Button : TMouseButton;
                                     Shift  : TShiftState;
                                     X, Y   : Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);

  if ((Assigned (FStateMachine)) and (not FStateMachine.FMovableStates)) and
     (not FMovable) then
    Exit;

  FOldX := X;
  FOldY := Y;
  FMoving := True;
end;

procedure TApdCustomState.MouseMove (Shift : TShiftState; X, Y : Integer);
begin
  inherited MouseMove (Shift, X, Y);

  if FMoving then begin
    Left := Left + X - FOldX;
    Top := Top + Y - FOldY;
  end;
end;

procedure TApdCustomState.MouseUp (Button : TMouseButton;
                                   Shift  : TShiftState;
                                   X, Y   : Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);

  if FMoving then
    FMoving := False;
end;

procedure TApdCustomState.Notification (AComponent : TComponent;
              Operation : TOperation);
var
  i : Integer;

begin
  inherited Notification (AComponent, Operation);

  if (csDestroying       in ComponentState) or
     (csFreeNotification in ComponentState) or
     (csLoading          in ComponentState) or
     (csReading          in ComponentState) or
     (csUpdating         in ComponentState) or
     (csWriting          in ComponentState) then
    Exit;

  if (Operation = opRemove) then
    for i := Conditions.Count - 1 downto 0 do
      if (Conditions[i].NextState = AComponent) then
        Conditions.Delete (i);
end;

procedure TApdCustomState.Paint;
var
  R, Dest, Src : TRect;
  DispWidth : Integer;
  OldColor : TColor;

begin
  {get the display dimensions}
  R := GetClientRect;
  if FUseLeftBorder then begin
    R.Left := R.Left + FLeftBorderWidth;
  end;
  Canvas.Font.Assign (Font);
  if Active then
    Canvas.Brush.Color := FActiveColor
  else if HaveGlyph then
    Canvas.Brush.Color := Parent.Brush.Color
  else
    Canvas.Brush.Color := FInactiveColor;
  if HaveGlyph then begin
    Dest := R;
    Dest.Top := Dest.Top + Canvas.TextHeight(Name);
    if FGlyphCells > 1 then begin
      DispWidth := FGlyph.Width div FGlyphCells;
      if FActive then
        Src := Rect(DispWidth, 0, DispWidth * 2, FGlyph.Height)
      else if FCompleted then begin
        if FGlyphCells = 3 then
          Src := Rect(DispWidth * 2, 0, DispWidth * 3, FGlyph.Height)
        else
          Src := Rect(0, 0, DispWidth, FGlyph.Height);
      end else
        Src := Rect(0, 0, DispWidth, FGlyph.Height);
      Canvas.CopyRect(Dest, Glyph.Canvas, Src);

    end else
      Canvas.CopyRect(Dest, Glyph.Canvas, Glyph.Canvas.ClipRect);
  end else begin
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(ClientRect);

    OldColor := Canvas.Brush.Color;
    Canvas.Brush.Color := FLeftBorderFill;
    if FUseLeftBorder then begin
      Canvas.Rectangle (ClientRect);
    end;
    Canvas.Brush.Style := bsClear;
    Canvas.Brush.Color := OldColor;
    Canvas.Rectangle(R);
  end;
  Canvas.TextRect (Rect (R.Left + 2,
                         2,
                         ClientWidth - 4,
                         Canvas.TextHeight(Caption) + 2),
                   R.Left + 2,
                   0,
                   Caption);
end;

procedure TApdCustomState.SetActionState (const v : Boolean);
begin
  if v <> FActionState then
    FActionState := v;
end;

procedure TApdCustomState.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  { we've moved, refresh the state machine }
  if Assigned(FStateMachine) then
    FStateMachine.Refresh;
end;

procedure TApdCustomState.SetConditions(const Value: TApdStateConditions);
begin
  FConditions := Value;
  Invalidate;
end;

procedure TApdCustomState.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  HaveGlyph := FGlyph.Height > 0;
  Refresh;
end;

procedure TApdCustomState.SetGlyphCells(const Value: Integer);
begin
  if (Value <> FGlyphCells) and (Value in [0..3]) then begin
    FGlyphCells := Value;
    Refresh;
  end;
end;

procedure TApdCustomState.SetParent(AParent: TWinControl);
var
  AStateMachine : TApdCustomStateMachine;
  I : Integer;
begin
  { TApdCustomState must be parented by a TApdCustomStateMachine }
  if (AParent is TApdCustomStateMachine) or (AParent = nil) then begin
   FStateMachine := TApdCustomStateMachine(AParent);
   inherited SetParent(AParent);
  end else
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then begin
    { not a TApdCustomStateMachine, find one }
    AStateMachine := FindStateMachine;
    if AStateMachine = nil then begin
      { can't find one, create one }
      I := 1;
      with TApdStateMachine.Create(Owner) do begin
        while Owner.FindComponent(Format('ApdStateMachine%d', [I])) <> nil do
          inc(I);
        Name := Format('ApdStateMachine%d', [I]);
        Parent := TCustomForm(Owner);
      end;
      AStateMachine := FindStateMachine;
    end;
    FStateMachine := AStateMachine;
    inherited SetParent(AStateMachine);
    Left := 10;
    Top := 10;
  end;
  if FStateMachine <> nil then
    FInactiveColor := FStateMachine.Color;
end;

function TApdCustomState.FindStateMachine : TApdCustomStateMachine;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to pred(Owner.ComponentCount) do
    if Owner.Components[I] is TApdCustomStateMachine then begin
      Result := TApdCustomStateMachine(Owner.Components[I]);
      Break;
    end;
end;

procedure TApdCustomState.Terminate(ErrorCode: Integer);
{ Terminate the state machine if there is an error in the state.
  Descending classes can make use of the error code provided }
begin
  if Assigned (FStateMachine) then
    FStateMachine.Cancel;
end;

procedure TApdCustomState.SetActiveColor(const NewColor: TColor);
begin
  if NewColor <> FActiveColor then begin
    FActiveColor := NewColor;
    Refresh;
  end;
end;

procedure TApdCustomState.SetInactiveColor(const NewColor: TColor);
begin
  if NewColor <> FInactiveColor then begin
    FInactiveColor := NewColor;
    Invalidate;
  end;
end;

procedure TApdCustomState.SetCaption(const Value: TCaption);
begin
  inherited Caption := Value;
  FCaption := Value;
  Invalidate;
end;

procedure TApdCustomState.SetMovable (const v : Boolean);
begin
  if v <> FMovable then
    FMovable := v;
end;

procedure TApdCustomState.WMEraseBackground (var Msg : TWMERASEBKGND);
begin
  Msg.Result := 1;
end;

{ TApdStateConnectoid }

procedure TApdStateConnectoid.Changed;
begin
  FCondition.Changed;
end;

constructor TApdStateConnectoid.Create(AOwner : TApdStateCondition);
begin
  FFont := TFont.Create;
  FCondition := AOwner;
  FCaption := 'Connectoid';
  FColor := clBlue;
  FWidth := 2;
  FSelected := False;
end;

destructor TApdStateConnectoid.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TApdStateConnectoid.DefineProperties (Filer : TFiler);
begin
  inherited DefineProperties (Filer);

  Filer.DefineProperty ('Caption',
                        ReadCaption,
                        WriteCaption,
                        Caption = '');
end;

function TApdStateConnectoid.IsCaptionStored : Boolean;
begin
  Result := Caption <> 'Connectoid';
end;

procedure TApdStateConnectoid.ReadCaption (Reader : TReader);
begin
  Caption := Reader.ReadString;
end;

procedure TApdStateConnectoid.SetCaption(const Value: TCaption);
begin
  if FCaption <> Value then begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TApdStateConnectoid.SetColor(const Value: TColor);
begin
  if FColor <> Value then begin
    FColor := Value;
    Changed;
  end;
end;

procedure TApdStateConnectoid.SetFont (const Value : TFont);
begin
  Font.Assign (Value);
end;

procedure TApdStateConnectoid.SetWidth (const Value: Integer);
begin
  if FWidth <> Value then begin
    FWidth := Value;
    Changed;
  end;
end;

procedure TApdStateConnectoid.WriteCaption (Writer : TWriter);
begin
  Writer.WriteString (Caption);
end;

{ TApdStateCondition }

procedure TApdStateCondition.Changed;
begin
  { force the state machine to redraw by setting the bounds of our state }
  { don't know why this works, but it does }
  with TApdStateConditions(Collection).FState do
    SetBounds(Left, Top, Width, Height);
end;

constructor TApdStateCondition.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPacketSize := 0;
  FTimeout := 2048;
  FErrorCode := ecOK;
  FNextState := nil;
  FEndString := '';
  FStartString := '';
  FConnectoid := TApdStateConnectoid.Create (Self);
  FDefaultError := False;
  FDefaultNext := False;
end;

destructor TApdStateCondition.Destroy;
begin
  FConnectoid.Free;
  inherited;
end;

function TApdStateCondition.GetCaption : TCaption;
begin
  if Assigned (FConnectoid) then
    Result := FConnectoid.Caption
  else
    Result := '';
end;

function TApdStateCondition.GetColor : TColor;
begin
  if Assigned (FConnectoid) then
    Result := FConnectoid.Color
  else
    Result := clNone;
end;

function TApdStateCondition.GetDisplayName: string;
begin
  Result := FConnectoid.Caption;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TApdStateCondition.GetFont : TFont;
begin
  if Assigned (FConnectoid) then
    Result := FConnectoid.Font
  else
    Result := TApdStateConditions(Collection).FState.Font;
end;

procedure TApdStateCondition.SetCaption (const v : TCaption);
begin
  if Assigned (FConnectoid) then
    FConnectoid.Caption := v;
end;

procedure TApdStateCondition.SetColor (const v : TColor);
begin
  if Assigned (FConnectoid) then
    FConnectoid.Color := v;
end;

procedure TApdStateCondition.SetConnectoid(
  const Value: TApdStateConnectoid);
begin
  if FConnectoid <> Value then begin
    FConnectoid := Value;
    Changed;
  end;
end;

procedure TApdStateCondition.SetDefaultError (const v : Boolean);
begin
  if v <> FDefaultError then
    FDefaultError := v;
end;

procedure TApdStateCondition.SetDefaultNext (const v : Boolean);
begin
  if v <> FDefaultNext then
    FDefaultNext := v;
end;

procedure TApdStateCondition.SetFont (const v : TFont);
begin
  if Assigned (FConnectoid) then
    FConnectoid.Font.Assign (v);
end;

procedure TApdStateCondition.SetNextState(const Value: TApdCustomState);
begin
  if FNextState <> Value then begin
    FNextState := Value;
    Changed;
  end;
end;

procedure TApdStateCondition.SetOutputOnActivate (const v : string);
begin
  if FOutputOnActivate <> v then
    FOutputOnActivate := v;
end;

{ TApdStateConditions }

function TApdStateConditions.Add: TApdStateCondition;
begin
  Result := TApdStateCondition(inherited Add);
  if (FState.Owner) is TWinControl then
    (FState.Owner as TWinControl).Repaint;
end;

constructor TApdStateConditions.Create(
  State: TApdCustomState; ItemClass: TCollectionItemClass);
begin
  FState := State;
  inherited Create(ItemClass);
end;

function TApdStateConditions.GetItem(Index: Integer): TApdStateCondition;
begin
  Result := TApdStateCondition(inherited GetItem(Index));
end;

function TApdStateConditions.GetOwner: TPersistent;
begin
  Result := FState;
end;

procedure TApdStateConditions.SetItem(Index: Integer;
  const Value: TApdStateCondition);
begin
  inherited SetItem(Index, Value);
end;

procedure TApdStateConditions.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  FState.FStateMachine.StateMachinePaint;
end;

end.

