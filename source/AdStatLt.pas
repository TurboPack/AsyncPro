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
{*                   ADSTATLT.PAS 4.06                   *}
{*********************************************************}
{* TApdSLController, TApdStatusLight component           *}
{*********************************************************}

{
  Simply adds status triggers to the port which cause lights to change.
  You need to set TApdSLController.Monitoring explicitly at run-time.
  There is a known conflict with most status triggers when faxing, the
  extra status triggers can cause our fax state machines to re-enter.
  Status lines don't have the same meaning with faxing anyway, so don't
  mix faxing and status triggers.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F-,V-,P-,T-,B-,I+}

unit AdStatLt;
  {-Port status light component}

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Graphics,
  Forms,
  Dialogs,
  OoMisc,
  AdExcept,
  AdPort;

const
  adsDefLightDim = 13;

const
  adsDefErrorOffTimeout = 36;
  adsDefBreakOffTimeout = 36;
  adsDefRXDOffTimeout   = 1;
  adsDefTXDOffTimeout   = 1;
  adsDefRingOffTimeout  = 8;
  adsDefLitColor        = clRed;
  adsDefNotLitColor     = clGreen;

type
  TApdCustomStatusLight = class(TApdBaseGraphicControl)
  protected {private}
    {.Z+}
    FGlyph       : TBitmap;
    FLit         : Boolean;
    FLitColor    : TColor;
    FNotLitColor : TColor;
    HaveGlyph    : Boolean;

    procedure SetGlyph(const NewGlyph : TBitmap);
      {-Set the bitmap displayed for the light}
    procedure SetLit(const IsLit : Boolean);
      {-Set whether the light is lit or not}
    procedure SetLitColor(const NewColor : TColor);
      {-Set the color the light is displayed in when it is lit}
    procedure SetNotLitColor(const NewColor : TColor);
      {-Set the color the light is displayed in when it is not lit}

    function GetVersion : string;
    procedure SetVersion(const Value : string);                 

    procedure Paint; override;
    procedure Loaded; override;

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer); override;
    {.Z-}

    property Version : string                                     
      read GetVersion
      write SetVersion
      stored False;
    property Glyph : TBitmap
      read FGlyph write SetGlyph;
    property Lit : Boolean
      read FLit write SetLit;
    property LitColor : TColor
      read FLitColor write SetLitColor default adsDefLitColor;
    property NotLitColor : TColor
      read FNotLitColor write SetNotLitColor default adsDefNotLitColor;
  end;

  TApdStatusLight = class(TApdCustomStatusLight)
  published
    property Version;                                             
    property Glyph;
    property Lit;
    property LitColor;
    property NotLitColor;
  end;

  TLightSet = class(TPersistent)
  protected {private}
    {.Z+}
    FCTSLight   : TApdCustomStatusLight;
    FDSRLight   : TApdCustomStatusLight;
    FDCDLight   : TApdCustomStatusLight;
    FRINGLight  : TApdCustomStatusLight;
    FTXDLight   : TApdCustomStatusLight;
    FRXDLight   : TApdCustomStatusLight;
    FERRORLight : TApdCustomStatusLight;
    FBREAKLight : TApdCustomStatusLight;

  public
    constructor Create;
    {.Z-}

    procedure InitLights(const ComPort : TApdCustomComPort;
         Monitoring : Boolean);

  published
    property CTSLight : TApdCustomStatusLight
      read FCTSLight write FCTSLight;
    property DSRLight : TApdCustomStatusLight
      read FDSRLight write FDSRLight;
    property DCDLight : TApdCustomStatusLight
      read FDCDLight write FDCDLight;
    property RINGLight : TApdCustomStatusLight
      read FRINGLight write FRINGLight;
    property TXDLight : TApdCustomStatusLight
      read FTXDLight write FTXDLight;
    property RXDLight : TApdCustomStatusLight
      read FRXDLight write FRXDLight;
    property ERRORLight : TApdCustomStatusLight
      read FERRORLight write FERRORLight;
    property BREAKLight : TApdCustomStatusLight
      read FBREAKLight write FBREAKLight;
  end;

  TApdCustomSLController = class(TApdBaseComponent)
  protected {private}
    {.Z+}
    {port stuff}
    FComPort          : TApdCustomComPort;
    FMonitoring       : Boolean;
    MonitoringPending : Boolean;

    {timeouts}
    FErrorOffTimeout  : Integer;
    FBreakOffTimeout  : Integer;
    FRXDOffTimeout    : Integer;
    FTXDOffTimeout    : Integer;
    FRingOffTimeout   : Integer;

    {lights}
    FLights           : TLightSet;

    {saved event handlers}
    SaveTriggerAvail  : TTriggerAvailEvent;   {Old data available trigger}
    SaveTriggerStatus : TTriggerStatusEvent;  {Old status trigger handler}
    SaveTriggerTimer  : TTriggerTimerEvent;   {Old timer trigger handler}

    {trigger handles}
    ModemStatMask     : Cardinal;                 {Status bits we want to watch}
    MSTrig            : Integer;              {Modem status indicator trigger}
    ErrorOnTrig       : Integer;              {ERROR indicator turn on trigger}
    BreakOnTrig       : Integer;              {BREAK indicator turn on trigger}
    ErrorOffTrig      : Integer;              {ERROR indicator turn off trigger}
    BreakOffTrig      : Integer;              {BREAK indicator turn off trigger}
    RxdOffTrig        : Integer;              {RXD indicator turn off trigger}
    TxdOnTrig         : Integer;              {TXD indicator turn on trigger}
    TxdOffTrig        : Integer;              {TXD indicator turn off trigger}
    RingOffTrig       : Integer;              {RING indicator turn off trigger}

    function GetHaveCTSLight : Boolean;
    function GetHaveDSRLight : Boolean;
    function GetHaveDCDLight : Boolean;
    function GetHaveRINGLight : Boolean;
    function GetHaveTXDLight : Boolean;
    function GetHaveRXDLight : Boolean;
    function GetHaveERRORLight : Boolean;
    function GetHaveBREAKLight : Boolean;

    procedure SetComPort(const NewPort : TApdCustomComPort);
    procedure SetLights(const NewLights : TLightSet);
    procedure SetMonitoring(const NewMon : Boolean);

    procedure Notification(AComponent : TComponent; Operation: TOperation); override;

    procedure Loaded; override;
    procedure InitTriggers;
      {-Set trigger handles to their default values}
    procedure AddTriggers;
      {-Add triggers to com port}
    procedure RemoveTriggers;
      {-Remove triggers from com port}
    procedure InitLights;
      {-Initialize the default statuses of various modem lights}
    procedure CheckLight(const CurStat : Boolean; const Light : TApdCustomStatusLight);
      {-See if a light has changed and update it if so}

    {replacement trigger handlers}
    procedure StatTriggerAvail(CP : TObject; Count : Word);
    procedure StatTriggerStatus(CP : TObject; TriggerHandle : Word);
    procedure StatTriggerTimer(CP : TObject; TriggerHandle : Word);
    procedure StatPortClose(CP : TObject; Opening : Boolean);

    property HaveCTSLight : Boolean
      read GetHaveCTSLight;
    property HaveDSRLight : Boolean
      read GetHaveDSRLight;
    property HaveDCDLight : Boolean
      read GetHaveDCDLight;
    property HaveRINGLight : Boolean
      read GetHaveRINGLight;
    property HaveTXDLight : Boolean
      read GetHaveTXDLight;
    property HaveRXDLight : Boolean
      read GetHaveRXDLight;
    property HaveERRORLight : Boolean
      read GetHaveERRORLight;
    property HaveBREAKLight : Boolean
      read GetHaveBREAKLight;

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    {.Z-}

    property Monitoring : Boolean
      read FMonitoring write SetMonitoring;

    {port to monitor}
    property ComPort : TApdCustomComPort
      read FComPort write SetComPort;

    {timeout values}
    property ErrorOffTimeout : Integer
      read FErrorOffTimeout write FErrorOffTimeout default adsDefErrorOffTimeout;
    property BreakOffTimeout : Integer
      read FBreakOffTimeout write FBreakOffTimeout default adsDefBreakOffTimeout;
    property RXDOffTimeout : Integer
      read FRXDOffTimeout write FRXDOffTimeout default adsDefRXDOffTimeout;
    property TXDOffTimeout : Integer
      read FTXDOffTimeout write FTXDOffTimeout default adsDefTXDOffTimeout;
    property RingOffTimeout : Integer
      read FRingOffTimeout write FRingOffTimeout default adsDefRingOffTimeout;

    {complete set of lights}
    property Lights : TLightSet
      read FLights write SetLights;
  end;

  TApdSLController = class(TApdCustomSLController)
  published
    property ComPort;
    property ErrorOffTimeout;
    property BreakOffTimeout;
    property RXDOffTimeout;
    property TXDOffTimeout;
    property RingOffTimeout;
    property Lights;
  end;

implementation

uses
  UITypes;

{TStatusLight}

  procedure TApdCustomStatusLight.SetGlyph(const NewGlyph : TBitmap);
    {-Set the bitmap displayed for the light}
  begin
    FGlyph.Assign(NewGlyph);
    HaveGlyph := NewGlyph <> nil;

    if HaveGlyph then begin
      Width      := Glyph.Width div 2;
      Height     := Glyph.Height;
    end else begin
      Width      := adsDefLightDim;
      Height     := adsDefLightDim;
    end;

    Refresh;
  end;

  procedure TApdCustomStatusLight.SetLit(const IsLit : Boolean);
    {-Set whether the light is lit or not}
  begin
    if (FLit <> IsLit) then begin
      FLit := IsLit;
      Refresh;
    end;                                                          
  end;

  procedure TApdCustomStatusLight.SetLitColor(const NewColor : TColor);
    {-Set the color the light is displayed in when it is lit}
  begin
    if (NewColor <> FLitColor) then begin
      FLitColor := NewColor;

      if not HaveGlyph and FLit then
        Refresh;
    end;
  end;

  procedure TApdCustomStatusLight.SetNotLitColor(const NewColor : TColor);
    {-Set the color the light is displayed in when it is not lit}
  begin
    if (NewColor <> FNotLitColor) then begin
      FNotLitColor := NewColor;
      if not HaveGlyph and not FLit then
        Refresh;
    end;
  end;

  procedure TApdCustomStatusLight.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
  begin
    if HaveGlyph then begin
      AWidth  := Glyph.Width div 2;
      AHeight := Glyph.Height;
    end;

    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  end;

  procedure TApdCustomStatusLight.Paint;
  var
    R   : TRect;
    Src : TRect;

  begin
    {get the display dimensions}
    R := Bounds(0, 0, Width, Height);

    {if we have a bitmap, display that}
    if HaveGlyph then begin
      Src := R;

      {if the light is on, use the second half of the bitmap}
      if not Lit then begin
        Inc(Src.Left, Width);
        Inc(Src.Right, Width);
      end;

      {paint the bitmap}
      Canvas.Brush.Color := Parent.Brush.Color;
      Canvas.BrushCopy(R, Glyph, Src, Glyph.Canvas.Pixels[0, 0]); 

    {otherwise, manually draw a square in "lit" or "unlit" color}
    end else begin
      if Lit then
        Canvas.Brush.Color := LitColor
      else
        Canvas.Brush.Color := NotLitColor;
      Canvas.FillRect(R);
      Canvas.Pen.Color := clWhite;
      Canvas.MoveTo(0, 0);
      Canvas.LineTo(Width, 0);
      Canvas.MoveTo(0, 0);
      Canvas.LineTo(0, Height);
      Canvas.Pen.Color := clDkGray;
      Canvas.MoveTo(Width - 1, 1);
      Canvas.LineTo(Width - 1, Height);
      Canvas.MoveTo(1, Height - 1);
      Canvas.LineTo(Width, Height - 1);
    end;
  end;

  procedure TApdCustomStatusLight.Loaded;
  begin
    inherited Loaded;

    HaveGlyph := (Glyph.Handle <> 0);
  end;

  constructor TApdCustomStatusLight.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);

    FGlyph       := TBitmap.Create;
    FLit         := False;
    FLitColor    := adsDefLitColor;
    FNotLitColor := adsDefNotLitColor;
    Width        := adsDefLightDim;
    Height       := adsDefLightDim;

    HaveGlyph := False;
  end;

  destructor TApdCustomStatusLight.Destroy;
  begin
    FGlyph.Free;

    inherited Destroy;
  end;

  function TApdCustomStatusLight.GetVersion : string;
  begin
    Result := ApVersionStr;
  end;

  procedure TApdCustomStatusLight.SetVersion(const Value : string);
  begin
  end;

{TLightSet}

  constructor TLightSet.Create;
  begin
    CTSLight   := nil;
    DSRLight   := nil;
    DCDLight   := nil;
    RINGLight  := nil;
    TXDLight   := nil;
    RXDLight   := nil;
    ERRORLight := nil;
    BREAKLight := nil;
  end;

  procedure TLightSet.InitLights(const ComPort : TApdCustomComPort;
                                       Monitoring : Boolean);        
  begin
    if Assigned(FCTSLight) then
      CTSLight.Lit := False;
    if Assigned(FDSRLight) then
      DSRLight.Lit := False;
    if Assigned(FDCDLight) then
      DCDLight.Lit := False;
    if Assigned(FRINGLight) then
      RINGLight.Lit := False;
    if Assigned(FTXDLight) then
      TXDLight.Lit := False;
    if Assigned(FRXDLight) then
      RXDLight.Lit := False;
    if Assigned(FERRORLight) then
      ERRORLight.Lit := False;
    if Assigned(FBREAKLight) then
      BREAKLight.Lit := False;

    if Assigned(ComPort) and Monitoring then begin                   
      if Assigned(FCTSLight) then
        CTSLight.Lit := ComPort.CTS;
      if Assigned(FDSRLight) then
        DSRLight.Lit := ComPort.DSR;
      if Assigned(FDCDLight) then
        DCDLight.Lit := ComPort.DCD;
    end;
  end;

{TSLController}

  function TApdCustomSLController.GetHaveCTSLight : Boolean;
  begin
    GetHaveCTSLight := Assigned(Lights.FCTSLight);
  end;

  function TApdCustomSLController.GetHaveDSRLight : Boolean;
  begin
    GetHaveDSRLight := Assigned(Lights.FDSRLight);
  end;

  function TApdCustomSLController.GetHaveDCDLight : Boolean;
  begin
    GetHaveDCDLight := Assigned(Lights.FDCDLight);
  end;

  function TApdCustomSLController.GetHaveRINGLight : Boolean;
  begin
    GetHaveRINGLight := Assigned(Lights.FRINGLight);
  end;

  function TApdCustomSLController.GetHaveTXDLight : Boolean;
  begin
    GetHaveTXDLight := Assigned(Lights.FTXDLight);
  end;

  function TApdCustomSLController.GetHaveRXDLight : Boolean;
  begin
    GetHaveRXDLight := Assigned(Lights.FRXDLight);
  end;

  function TApdCustomSLController.GetHaveERRORLight : Boolean;
  begin
    GetHaveERRORLight := Assigned(Lights.FERRORLight);
  end;

  function TApdCustomSLController.GetHaveBREAKLight : Boolean;
  begin
    GetHaveBREAKLight := Assigned(Lights.FBREAKLight);
  end;

  procedure TApdCustomSLController.SetComPort(const NewPort : TApdCustomComPort);
  var
    WasMonitoring : Boolean;

  begin
    if (NewPort = FComPort) then
      Exit;

    if Assigned(FComPort) then
      FComPort.DeregisterUserCallback(StatPortClose);

    WasMonitoring := Monitoring;
    Monitoring    := False;
    FComPort      := NewPort;
    Monitoring    := WasMonitoring;

    if Assigned(FComPort) then
      FComPort.RegisterUserCallback(StatPortClose);
  end;

  procedure TApdCustomSLController.SetLights(const NewLights : TLightSet);
  begin
    FLights := NewLights;
  end;

  procedure TApdCustomSLController.SetMonitoring(const NewMon : Boolean);
  begin
    if (csDesigning in ComponentState) or
      (csLoading in ComponentState) or
      (FMonitoring = NewMon) then
      Exit;

    if not Assigned(FComPort) then
      raise EPortNotAssigned.Create(ecPortNotAssigned, False);

    if not ComPort.Open then begin
      MonitoringPending := NewMon;
      if MonitoringPending then
        Exit;                                                         
    end;

    FMonitoring := NewMon;

    if FMonitoring then begin
      SaveTriggerAvail        := ComPort.OnTriggerAvail;
      SaveTriggerStatus       := ComPort.OnTriggerStatus;
      SaveTriggerTimer        := ComPort.OnTriggerTimer;
      ComPort.OnTriggerAvail  := StatTriggerAvail;
      ComPort.OnTriggerStatus := StatTriggerStatus;
      ComPort.OnTriggerTimer  := StatTriggerTimer;

      AddTriggers;
      InitLights;
    end else begin
      ComPort.OnTriggerAvail  := SaveTriggerAvail;
      ComPort.OnTriggerStatus := SaveTriggerStatus;
      ComPort.OnTriggerTimer  := SaveTriggerTimer;

      RemoveTriggers;
      InitLights;                                                  
    end;
  end;

  procedure TApdCustomSLController.Notification(AComponent : TComponent; Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);

    if (Operation = opRemove) then begin
      if (AComponent = FComPort) then begin
        Monitoring := False;
        ComPort    := nil;
      end else if (AComponent = Lights.CTSLight) then
        Lights.CTSLight := nil
      else if (AComponent = Lights.DSRLight) then
        Lights.DSRLight := nil
      else if (AComponent = Lights.DCDLight) then
        Lights.DCDLight := nil
      else if (AComponent = Lights.RINGLight) then
        Lights.RINGLight := nil
      else if (AComponent = Lights.TXDLight) then
        Lights.TXDLight := nil
      else if (AComponent = Lights.RXDLight) then
        Lights.RXDLight := nil
      else if (AComponent = Lights.ERRORLight) then
        Lights.ERRORLight := nil
      else if (AComponent = Lights.BREAKLight) then
        Lights.BREAKLight := nil;
    end else if (Operation = opInsert) then
      if not Assigned(FComPort) and (AComponent is TApdCustomComPort) then
        ComPort := TApdCustomComPort(AComponent);
  end;

  procedure TApdCustomSLController.Loaded;
  begin
    inherited Loaded;

    if Assigned(FComPort) then
      FComPort.RegisterUserCallback(StatPortClose);
  end;

  procedure TApdCustomSLController.InitTriggers;
    {-Set trigger handles to their default values}
  begin
    {default trigger handles}
    ModemStatMask := 0;
    MSTrig        := 0;
    ErrorOnTrig   := 0;
    BreakOnTrig   := 0;
    ErrorOffTrig  := 0;
    BreakOffTrig  := 0;
    RxdOffTrig    := 0;
    TxdOnTrig     := 0;
    TxdOffTrig    := 0;
    RingOffTrig   := 0;
  end;

  procedure TApdCustomSLController.AddTriggers;
    {-Add triggers to com port}
  begin
    InitTriggers;

    if Assigned(FComPort) then begin
      try
        if HaveCTSLight or HaveDSRLight or HaveDCDLight or HaveRingLight then begin
          MSTrig := ComPort.AddStatusTrigger(stModem);
          if HaveRingLight then
            RingOffTrig := ComPort.AddTimerTrigger;
        end;

        if HaveErrorLight then begin
          ErrorOnTrig  := ComPort.AddStatusTrigger(stLine);
          ErrorOffTrig := ComPort.AddTimerTrigger;
        end;

        if HaveBreakLight then begin
          BreakOnTrig  := ComPort.AddStatusTrigger(stLine);
          BreakOffTrig := ComPort.AddTimerTrigger;
        end;

        if HaveRXDLight then
          RXDOffTrig := ComPort.AddTimerTrigger;

        if HaveTXDLight then begin
          TXDOnTrig   := ComPort.AddStatusTrigger(stOutSent);
          TXDOffTrig := ComPort.AddTimerTrigger;
        end;

        ModemStatMask := 0;
        if HaveCTSLight then
          ModemStatMask := ModemStatMask or msCTSDelta;
        if HaveDSRLight then
          ModemStatMask := ModemStatMask or msDSRDelta;
        if HaveDCDLight then
          ModemStatMask := ModemStatMask or msDCDDelta;
        if HaveRINGLight then
          ModemStatMask := ModemStatMask or msRINGDelta;

        if HaveCTSLight or HaveDSRLight or HaveDCDLight or HaveRINGLight then
          ComPort.SetStatusTrigger(MSTrig, ModemStatMask, True);

        if HaveERRORLight then
          ComPort.SetStatusTrigger(ErrorOnTrig, lsOverrun or lsParity or lsFraming, True);
        if HaveBreakLight then
          ComPort.SetStatusTrigger(BreakOnTrig, lsBreak, True);
        if HaveTXDLight then
          ComPort.SetStatusTrigger(TXDOnTrig, 0, True);

      except
        ModemStatMask := 0;
        RemoveTriggers;
        raise;
      end;
    end;
  end;

  procedure TApdCustomSLController.RemoveTriggers;
    {-Remove triggers from com port}
  begin
    if Assigned(FComPort) then begin
      try
        if HaveCTSLight or HaveDSRLight or HaveDCDLight or HaveRingLight then begin
          ComPort.RemoveTrigger(MSTrig);
          if HaveRingLight then
            ComPort.RemoveTrigger(RingOffTrig);
        end;

        if HaveErrorLight then begin
          ComPort.RemoveTrigger(ErrorOnTrig);
          ComPort.RemoveTrigger(ErrorOffTrig);
        end;

        if HaveBreakLight then begin
          ComPort.RemoveTrigger(BreakOnTrig);
          ComPort.RemoveTrigger(BreakOffTrig);
        end;

        if HaveRXDLight then
          ComPort.RemoveTrigger(RXDOffTrig);

        if HaveTXDLight then begin
          ComPort.RemoveTrigger(TXDOnTrig);
          ComPort.RemoveTrigger(TXDOffTrig);
        end;

      finally
        InitTriggers;
      end;
    end;
  end;

  procedure TApdCustomSLController.InitLights;
    {-Initialize the default statuses of various modem lights}
  begin
    Lights.InitLights(FComPort, Monitoring);
  end;

  procedure TApdCustomSLController.CheckLight(const CurStat : Boolean; const Light : TApdCustomStatusLight);
    {-See if a light has changed and update it if so}
  begin
    if CurStat <> Light.Lit then
      Light.Lit := CurStat;
  end;

  procedure TApdCustomSLController.StatTriggerAvail(CP : TObject; Count : Word);
  begin
    if Assigned(FComPort) then begin
      if HaveRXDLight and not Lights.RXDLight.Lit then begin
        Lights.RXDLight.Lit := True;
        ComPort.SetTimerTrigger(RXDOffTrig, RXDOffTimeout, True);
      end;

      if Assigned(SaveTriggerAvail) then
        SaveTriggerAvail(CP, Count);
    end;
  end;

  procedure TApdCustomSLController.StatTriggerStatus(CP : TObject; TriggerHandle : Word);
  begin
    if Assigned(FComPort) then begin
      if (TriggerHandle = MSTrig) then begin
        if HaveDCDLight then
          CheckLight(ComPort.DCD, Lights.DCDLight);
        if HaveCTSLight then
          CheckLight(ComPort.CTS, Lights.CTSLight);
        if HaveDSRLight then
          CheckLight(ComPort.DSR, Lights.DSRLight);

        if HaveRingLight then
          if ComPort.DeltaRI and not Lights.RINGLight.Lit then begin
            Lights.RINGLight.Lit := True;
            ComPort.SetTimerTrigger(RingOffTrig, RingOffTimeout, True);
          end;

        ComPort.SetStatusTrigger(MSTrig, ModemStatMask, True);
      end else if (TriggerHandle = ErrorOnTrig) then begin
        Lights.ErrorLight.Lit := True;
        ComPort.SetTimerTrigger(ErrorOffTrig, ErrorOffTimeout, True);
        if (ComPort.LineError <> 0) then ;
      end else if (TriggerHandle = BreakOnTrig) then begin
        Lights.BreakLight.Lit := True;
        ComPort.SetTimerTrigger(BreakOffTrig, BreakOffTimeout, True);
        if ComPort.LineBreak then ;
      end else if (TriggerHandle = TXDOnTrig) then begin
        Lights.TXDLight.Lit := True;
        ComPort.SetTimerTrigger(TXDOffTrig, TXDOffTimeout, True);
      end;

      if Assigned(SaveTriggerStatus) then
        SaveTriggerStatus(CP, TriggerHandle);
    end;
  end;

  procedure TApdCustomSLController.StatTriggerTimer(CP : TObject; TriggerHandle : Word);
  begin
    if Assigned(FComport) then begin
      if (TriggerHandle = ErrorOffTrig) then begin
        Lights.ErrorLight.Lit := False;
        ComPort.SetStatusTrigger(ErrorOnTrig, lsOverrun or lsParity or lsFraming, True);
      end else if (TriggerHandle = BreakOffTrig) then begin
        Lights.BreakLight.Lit := False;
        ComPort.SetStatusTrigger(BreakOnTrig, lsBreak, True);
      end else if (TriggerHandle = RXDOffTrig) then
        if (ComPort.InBuffUsed = 0) then
          Lights.RXDLight.Lit := False
        else
          ComPort.SetTimerTrigger(RXDOffTrig, RXDOffTimeout, True)
      else if (TriggerHandle = TXDOffTrig) then
        if (ComPort.OutBuffUsed = 0) then begin
          Lights.TXDLight.Lit := False;
          ComPort.SetStatusTrigger(TXDOnTrig, 0, True);
        end else
          ComPort.SetTimerTrigger(TXDOffTrig, TXDOffTimeout, True)
      else if (TriggerHandle = RingOffTrig) then
        Lights.RINGLight.Lit := False;

      if Assigned(SaveTriggerTimer) then
        SaveTriggerTimer(CP, TriggerHandle);
    end;
  end;

  procedure TApdCustomSLController.StatPortClose(CP : TObject; Opening : Boolean);
  begin
    if (csDesigning in ComponentState) then
      Exit;

    if Opening then begin
      if MonitoringPending then begin
        MonitoringPending := False;
        Monitoring        := True;
      end;
    end else begin
      MonitoringPending := Monitoring;
      Monitoring := False;
    end;
  end;

  constructor TApdCustomSLController.Create(AOwner : TComponent);
  var
    I : Cardinal;
  begin
    inherited Create(AOwner);

    FMonitoring       := False;
    MonitoringPending := False;

    {search our owner for a com port}
    if Assigned(AOwner) and (AOwner.ComponentCount > 0) then
      for I := 0 to Pred(AOwner.ComponentCount) do
        if AOwner.Components[I] is TApdCustomComPort then begin
          FComPort := TApdCustomComPort(AOwner.Components[I]);
          Break;
        end;

    {set default timeouts}
    FErrorOffTimeout := adsDefErrorOffTimeout;
    FBreakOffTimeout := adsDefBreakOffTimeout;
    FRXDOffTimeout   := adsDefRXDOffTimeout;
    FTXDOffTimeout   := adsDefTXDOffTimeout;
    FRingOffTimeout  := adsDefRingOffTimeout;

    {set lights}
    FLights := TLightSet.Create;

    {set saved event handlers}
    SaveTriggerAvail  := nil;
    SaveTriggerStatus := nil;
    SaveTriggerTimer  := nil;

    InitTriggers;
  end;

  destructor TApdCustomSLController.Destroy;
  begin
    Monitoring := False;
    FLights.Free;

    inherited Destroy;
  end;

end.
