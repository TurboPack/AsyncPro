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
{*                    ADSTST.PAS 4.06                    *}
{*********************************************************}
{* TApdActionState component                             *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdStSt;

{
  Additional States for the TApdStateMachine Component 
}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  AdStMach;

type

  TApdOnStartAction = procedure (    Sender          : TObject;
                                     StateConditions : TApdStateConditions;
                                 var ActionCompleted : Boolean;
                                 var NextState       : Integer) of object;
  TApdOnSelectNextState = procedure (    Sender    : TObject;
                                     var NextState : Integer) of object;

  TApdCustomActionState = class (TApdCustomState)
    private
      FTitle             : string;
      FTitleFont         : TFont;

      FOnStartAction     : TApdOnStartAction;
      FOnSelectNextState : TApdOnSelectNextState;

    protected
      procedure Activate; override;
      procedure Deactivate; override;
      procedure FinishAction (NextState : Integer); virtual;
      function GetTitleColor : TColor;
      procedure SetTitle (const v : string);
      procedure SetTitleColor (const v : TColor);
      procedure SetTitleFont (const v : TFont);
      procedure StartAction; virtual; abstract;

    public
      constructor Create (AOwner : TComponent); override;
      destructor Destroy; override;

      procedure AutoSelectNextState (Error : Boolean);
      procedure Paint; override;

      property Title : string read FTitle write SetTitle;
      property TitleColor : TColor read GetTitleColor write SetTitleColor;
      property TitleFont : TFont read FTitleFont write SetTitleFont;

      property OnSelectNextState : TApdOnSelectNextState
               read FOnSelectNextState Write FOnSelectNextState;
      property OnStartAction : TApdOnStartAction
               read FOnStartAction write FOnStartAction;

    published
      property Conditions;
  end;

  TApdActionState = class (TApdCustomActionState)
    private
    protected
    public
      procedure FinishAction (NextState : Integer); override;

    published
      property Title;
      property TitleColor;
      property TitleFont;

      property OnGetData;
      property OnGetDataString;
      property OnStartAction;

      property ActiveColor;
      property Caption;
      property Font;
      property Glyph;
      property GlyphCells;
      property InactiveColor;
      property Movable;
      property OutputOnActivate;
  end;

implementation

type
  TAdRotationAngle = (ra0, ra90, ra180, ra270);

procedure TPSDrawRotatedText (      ACanvas  : TCanvas;
                              const Angle    : TAdRotationAngle;
                                    x, y     : Integer;
                                    Text     : string);

var
  LF            : TLogFont;
  OldFont       : TFont;
  RealPoint     : TPoint;
  OldBrushStyle : TBrushStyle;

begin
  FillChar (LF, SizeOf (LF), #0);

  LF.lfHeight           := ACanvas.Font.Height;
  LF.lfWidth            :=  0;
  case Angle of
    ra0   : LF.lfEscapement:= 0;
    ra90  : LF.lfEscapement:= 2700;
    ra180 : LF.lfEscapement:= 1800;
    ra270 : LF.lfEscapement:= 900;
  end;
  LF.lfOrientation      := 0;
  if fsBold in ACanvas.Font.Style then
    LF.lfWeight         := FW_BOLD
  else
    LF.lfWeight         := FW_NORMAL;
  LF.lfItalic           := Byte (fsItalic in ACanvas.Font.Style);
  LF.lfUnderline        := Byte (fsUnderline in ACanvas.Font.Style);
  LF.lfStrikeOut        := Byte (fsStrikeOut in ACanvas.Font.Style);
  LF.lfCharSet          := DEFAULT_CHARSET;
  LF.lfQuality          := DEFAULT_QUALITY;
  {everything else as default}
  LF.lfOutPrecision     := OUT_DEFAULT_PRECIS;
  LF.lfClipPrecision    := CLIP_DEFAULT_PRECIS;
  case ACanvas.Font.Pitch of
    fpVariable : LF.lfPitchAndFamily := VARIABLE_PITCH or FF_DONTCARE;
    fpFixed    : LF.lfPitchAndFamily := FIXED_PITCH or FF_DONTCARE;
  else
    LF.lfPitchAndFamily := DEFAULT_PITCH;
  end;

  { Create new font to use }
  OldFont := ACanvas.Font;
  try
    ACanvas.Font.Handle:= CreateFontIndirect (LF);

    { Output the text }
    RealPoint := Point (x, y);
    OldBrushStyle := ACanvas.Brush.Style;
    try
      ACanvas.Brush.Style := bsClear;
      ACanvas.TextOut (RealPoint.X, RealPoint.Y, Text);
    finally
      ACanvas.Brush.Style := OldBrushStyle;
    end;
  finally
    ACanvas.Font := OldFont;
  end;
end;

// TApdCustomActionState ******************************************************

constructor TApdCustomActionState.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);

  FTitleFont       := TFont.Create;

  FUseLeftBorder   := True;
  FLeftBorderWidth := 18;
  FLeftBorderFill  := clYellow;
  FTitle           := 'Action';

  ActionState      := True;
end;

destructor TApdCustomActionState.Destroy;
begin
  inherited Destroy;

  FTitleFont.Free;
  FTitleFont := nil;
end;

procedure TApdCustomActionState.Activate;
var
  NewState  : Integer;
  Completed : Boolean;

begin
  inherited Activate;

  if Assigned (FStateMachine) then
    FStateMachine.Pause; 

  if Assigned (FOnStartAction) then begin
    NewState := 0;
    Completed := True;
    try
      FOnStartAction (Self, Conditions, Completed, NewState);
    finally
      if Completed then begin
        if Assigned (FStateMachine) then
          FStateMachine.Resume;
        FinishAction (NewState);
      end;
    end;
  end;
end;

procedure TApdCustomActionState.AutoSelectNextState (Error : Boolean);
var
  i         : Integer;
  NextState : Integer;

begin
  if Conditions.Count = 0 then
    Exit;

  NextState := -1;

  for i := 0 to Conditions.Count - 1 do
    if ((Conditions.Items[i].DefaultNext) and (not Error)) or
       ((Conditions.Items[i].DefaultError) and (Error)) then begin
      NextState := i;
      Break;
    end;
  if (NextState = -1) and (Conditions.Count > 0) then begin
    NextState := 0;
    if Assigned (FOnSelectNextState) then
      FOnSelectNextState (Self, NextState);
  end;
  FinishAction (NextState);
end;

procedure TApdCustomActionState.Deactivate;
begin
  inherited Deactivate;
end;

procedure TApdCustomActionState.FinishAction (NextState : Integer);
begin
  if Assigned (FStateMachine) then
    FStateMachine.Resume; 
  FStateMachine.ChangeState (NextState);
end;

function TApdCustomActionState.GetTitleColor;
begin
  Result := FLeftBorderFill;
end;

procedure TApdCustomActionState.Paint;
var
  NewHeight : Integer;

begin
  NewHeight := Canvas.TextHeight (FTitle);
  FLeftBorderWidth := NewHeight;

  inherited;

  Canvas.Font.Assign (FTitleFont);
  TPSDrawRotatedText (Canvas, ra90, 16, 2, FTitle);
end;

procedure TApdCustomActionState.SetTitle (const v : string);
begin
  if v <> FTitle then begin
    FTitle := v;
    Invalidate;
  end;
end;

procedure TApdCustomActionState.SetTitleColor (const v : TColor);
begin
  if v <> FLeftBorderFill then begin
    FLeftBorderFill := v;
    Invalidate;
  end;
end;

procedure TApdCustomActionState.SetTitleFont (const v : TFont);
begin
  if not Assigned (v) then
    Exit;
  FTitleFont.Assign (v);
  Invalidate;
end;

// TApdActionState ***********************************************************

procedure TApdActionState.FinishAction (NextState : Integer);
begin
  inherited FinishAction (NextState);
end;

end.
