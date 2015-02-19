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
{*                   ADMETER.PAS 4.06                    *}
{*********************************************************}
{* Custom meter/progress bar component, not installed,   *}
{* used in the fax and protocol status dialogs.          *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdMeter;
  {-General purpose progress meter component}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Menus,
  Dialogs,
  OoMisc;

const
  admDefBarColor = clHighlight;
  admDefBevelColor1 = clBtnHighlight;
  admDefBevelColor2 = clBtnShadow;
  admDefMeterHeight = 16;
  admDefMax = 100;
  admDefMin = 0;
  admDefStep = 8;
  admDefMeterWidth = 150;

type
  TBevelStyle = (bsLowered, bsRaised, bsNone);

  TApdMeter = class(TApdBaseGraphicControl)
  private
    FBarColor : TColor;
    FBevelColor1 : TColor;
    FBevelColor2 : TColor;
    FBevelStyle : TBevelStyle;
    FMax : Integer;
    FMin : Integer;
    FOnPosChange : TNotifyEvent;
    FPosition : Integer;
    FSegments : Integer;
    FStep : Integer;
    NeedPartial : Boolean;
    PartialSize : Integer;
    procedure SetBarColor(Value : TColor);
    procedure SetBevelStyle(Value : TBevelStyle);
    procedure SetBevelColor1(Value : TColor);
    procedure SetBevelColor2(Value : TColor);
    procedure SetPosition(Value : Integer);
    procedure SetStep(Value : Integer);
  protected
    procedure DoOnPosChange; dynamic;
    procedure Paint; override;
    procedure UpdatePosition(Force : Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    { Color of the progress bar }
    property BarColor : TColor
      read FBarColor
      write SetBarColor
      default admDefBarColor;

    { Color of the bevel }
    property BevelColor1 : TColor
      read FBevelColor1
      write SetBevelColor1
      default admDefBevelColor1;

    { Color of the bevel }
    property BevelColor2 : TColor
      read FBevelColor2
      write SetBevelColor2
      default admDefBevelColor2;

    { Style of border bevel }
    property BevelStyle : TBevelStyle
      read FBevelStyle
      write SetBevelStyle
      default bsLowered;

    { Value for maximum deflection of progress bar }
    property Max : Integer
      read FMax
      write FMax
      default admDefMax;

    { Value for minimum deflection of progress bar }
    property Min : Integer
      read FMin
      write FMin
      default admDefMin;

    { Current level of progress, relative to Min and Max }
    property Position : Integer
      read FPosition
      write SetPosition;

    { Width in pixels of each block on the progress bar }
    property Step : Integer
      read FStep
      write SetStep
      default admDefStep;

    { Fires when the bar position changes }
    property OnPosChange : TNotifyEvent
      read FOnPosChange
      write FOnPosChange;

    { Inherited properties }
    property Align;
    property DragCursor;
    property DragMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    { Inherited Events }
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

implementation

uses
  Types;

constructor TApdMeter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBarColor := admDefBarColor;
  FBevelColor1 := admDefBevelColor1;
  FBevelColor2 := admDefBevelColor2;
  FBevelStyle := bsLowered;
  FMax := admDefMax;
  FMin := admDefMin;
  FStep := admDefStep;
  NeedPartial := False;
  Height := admDefMeterHeight;
  Width := admDefMeterWidth;
end;

procedure TApdMeter.SetBarColor(Value: TColor);
begin
  if Value <> FBarColor then begin
    FBarColor := Value;
    Invalidate;
  end;
end;

procedure TApdMeter.SetBevelColor1(Value: TColor);
begin
  if Value <> FBevelColor1 then begin
    FBevelColor1 := Value;
    Invalidate;
  end;
end;

procedure TApdMeter.SetBevelColor2(Value: TColor);
begin
  if Value <> FBevelColor2 then begin
    FBevelColor2 := Value;
    Invalidate;
  end;
end;

procedure TApdMeter.SetBevelStyle(Value: TBevelStyle);
begin
  if Value <> FBevelStyle then begin
    FBevelStyle := Value;
    Invalidate;
  end;
end;

procedure TApdMeter.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  UpdatePosition(True);
end;

procedure TApdMeter.SetPosition(Value: Integer);
begin
  if Value <> FPosition then begin
    FPosition := Value;
    UpdatePosition(False);
  end;
end;

procedure TApdMeter.SetStep(Value: Integer);
begin
  if Value <> FStep then begin
    FStep := Value;
    UpdatePosition(True);
  end;
end;

procedure TApdMeter.DoOnPosChange;
begin
  if Assigned(FOnPosChange) then
    FOnPosChange(Self);
end;

procedure TApdMeter.Paint;
var
  BR : TRect;
  I : Integer;

  procedure BevelRect(const R : TRect; const C1, C2 : TColor);
  begin
    with Canvas do begin
      Pen.Color := C1;
      PolyLine([Point(R.Left, R.Bottom), Point(R.Left, R.Top),
        Point(R.Right, R.Top)]);
      Pen.Color := C2;
      PolyLine([Point(R.Right, R.Top), Point(R.Right, R.Bottom),
        Point(R.Left, R.Bottom)]);
    end;
  end;

  procedure BevelLine(C : TColor; X1, Y1, X2, Y2 : Integer);
  begin
    with Canvas do begin
      Pen.Color := C;
      MoveTo(X1, Y1);
      LineTo(X2, Y2);
    end;
  end;

  procedure BarRect(const R : TRect);
  begin
    with Canvas do begin
      Brush.Style := bsSolid;
      Brush.Color := FBarColor;
      FillRect(R);
    end;
  end;

begin
  with Canvas do begin
    Pen.Width := 1;
    BR := Rect(0, 0, Width - 1, Height - 1);
    { Draw the bevel }
    case FBevelStyle of
      bsLowered : BevelRect(BR, FBevelColor2, FBevelColor1);
      bsRaised : BevelRect(BR, FBevelColor1, FBevelColor2);
      bsNone : ;
    end;
    { Draw the full segments }
    for I := 1 to FSegments do begin
      BR.Top := 2;
      BR.Bottom := Height - 2;
      BR.Left := (Pred(I) * FStep) + 2;
      BR.Right := BR.Left + (FStep - 2);
      BarRect(BR);
    end;
    { Draw partial segment if needed }
    if NeedPartial then begin
      BR.Top := 2;
      BR.Bottom := Height - 2;
      BR.Left := BR.Left + FStep;
      BR.Right := BR.Left + PartialSize;
      BarRect(BR);
    end;
  end;
end;

procedure TApdMeter.UpdatePosition(Force : Boolean);
var
  OldSegments : Integer;
  OldNeedPartial : Boolean;
begin
  OldSegments := FSegments;
  OldNeedPartial := NeedPartial;
  if FPosition <= FMin then
    FSegments := 0
  else
    FSegments := Succ(((Width - 3) div FStep) * (FPosition - FMin) div (FMax - FMin));
  if (FSegments * FStep) > (Width - 4) then begin
    NeedPartial := True;
    FSegments := (Width - 4) div FStep;
    PartialSize := (Width - 4) mod FStep;
  end else begin
    NeedPartial := False;
  end;
  if (OldSegments <> FSegments) or (OldNeedPartial <> NeedPartial) then begin
    Invalidate;
    DoOnPosChange;
  end else begin
    if Force then Invalidate;
  end;
end;

end.
