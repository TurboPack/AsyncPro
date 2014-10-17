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

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdFaxViewer;

interface

uses
  SysUtils, Classes, Controls, Forms, OoMisc, AdFaxCvt, Graphics, Messages, Windows;

type
  TAdCustomFaxViewer = class(TApdBaseScrollingWinControl)
  private
    { Private declarations }
    FCanvas : TCanvas;

    FUnpacker : TApdFaxUnpacker;
    FLoadWholeFax: Boolean;
    FRotation: Integer;
    FFaxFile: string;
    FFGColor: TColor;
    FBGColor: TColor;
    FBorderStyle: TBorderStyle;
    procedure SetBGColor(const Value: TColor);
    procedure SetFaxFile(const Value: string);
    procedure SetFGColor(const Value: TColor);
    procedure SetLoadWholeFax(const Value: Boolean);
    procedure SetRotation(const Value: Integer);
    procedure SetBorderStyle(const Value: TBorderStyle);

  protected
    { Protected declarations }
    procedure PaintWindow(DC : HDC); override;
    procedure RenderFax;
    procedure WMEraseBackground (var Msg : TWMERASEBKGND);
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property Canvas : TCanvas
      read FCanvas;

    property FaxFile : string read FFaxFile write SetFaxFile;
    property LoadWholeFax : Boolean read FLoadWholeFax write SetLoadWholeFax;
    property BGColor : TColor read FBGColor write SetBGColor;
    property FGColor : TColor read FFGColor write SetFGColor;
    property Rotation : Integer read FRotation write SetRotation;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;

  end;


  TAdFaxViewer = class(TAdCustomFaxViewer)
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TAdFaxViewer]);
end;

{ TAdCustomFaxViewer }

procedure TAdCustomFaxViewer.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;
  inherited;
end;

constructor TAdCustomFaxViewer.Create(AOwner: TComponent);
begin
  inherited;
  FUnpacker := nil;
end;

procedure TAdCustomFaxViewer.CreateParams(var Params: TCreateParams);
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

destructor TAdCustomFaxViewer.Destroy;
begin
  FUnpacker.Free;
  inherited;
end;

procedure TAdCustomFaxViewer.PaintWindow(DC: HDC);
var
  R : TRect;
begin
  FCanvas.Handle := DC;
  try
    R := ClientRect;
    InvalidateRect(Canvas.Handle, @R, True);
    RenderFax;
  finally
    Canvas.Handle := 0;
  end;
end;

procedure TAdCustomFaxViewer.RenderFax;
  { render the APF onto the canvas }
begin
  

end;

procedure TAdCustomFaxViewer.SetBGColor(const Value: TColor);
begin
  FBGColor := Value;
  Invalidate;
end;

procedure TAdCustomFaxViewer.SetBorderStyle(const Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;

end;

procedure TAdCustomFaxViewer.SetFaxFile(const Value: string);
begin
  FFaxFile := Value;
  RenderFax;
end;

procedure TAdCustomFaxViewer.SetFGColor(const Value: TColor);
begin
  FFGColor := Value;
end;

procedure TAdCustomFaxViewer.SetLoadWholeFax(const Value: Boolean);
begin
  FLoadWholeFax := Value;
end;

procedure TAdCustomFaxViewer.SetRotation(const Value: Integer);
begin
  FRotation := Value;
end;

procedure TAdCustomFaxViewer.WMEraseBackground(var Msg: TWMERASEBKGND);
begin

end;

end.
