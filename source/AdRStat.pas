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
{*                   ADRSTAT.PAS 4.06                    *}
{*********************************************************}
{* RAS status dialog                                     *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+,J+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdRStat;
  {-Delphi remote access (RAS) dialer status component}

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
  StdCtrls,
  OoMisc,
  AdRas,
  ExtCtrls;


type {Status display}
  TRasStatusDisplay = class(TForm)
    CancelBtn: TButton;
    Panel1: TPanel;
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    RasDialer : TApdCustomRasDialer;
  end;

type {RAS dial status component}
  TApdRasStatus = class(TApdAbstractRasStatus)
  protected
    FHandle : HWND;                                                  
    procedure CMRasStatus(var Msg : TMessage);                       
  public
    constructor Create(AOwner: TComponent); override;                
    destructor  Destroy; override;                                   

    procedure CreateDisplay(const EntryName : string); override;
    procedure DestroyDisplay; override;
    procedure UpdateDisplay(const StatusMsg : string); override;

    property Handle : HWND                                           
      read FHandle write FHandle;                                    
  end;

implementation

const
  CM_APDRASSTATUS = WM_USER + $0719;
  CancelDialing = 1;

{$R *.DFM}

{ TRasStatusDisplay }
procedure TRasStatusDisplay.CancelBtnClick(Sender: TObject);
begin
  if (TApdRasStatus(Owner).Handle <> 0) then
    PostMessage(TApdRasStatus(Owner).Handle, CM_APDRASSTATUS, CancelDialing, 0);
end;


{ TApdRasStatus }

constructor TApdRasStatus.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := AllocateHWnd(CMRasStatus);
end;

destructor TApdRasStatus.Destroy;
begin
  if (FHandle <> 0) then
    DeallocateHWnd(FHandle);
  inherited Destroy;
end;

procedure TApdRasStatus.CreateDisplay(const EntryName : string);
begin
  if not Assigned(FDisplay) then begin
    Display := TRasStatusDisplay.Create(Self);
    Display.Ctl3D := FCtl3D;
    Display.Position := FPosition;
    Display.Caption := 'Connecting to ' + EntryName + '...';
    TRasStatusDisplay(Display).RasDialer := RasDialer;
    Display.Show;
  end;
end;

procedure TApdRasStatus.DestroyDisplay;
begin
  if Assigned(Display) then
    Display.Free;
  Display := nil;
end;

procedure TApdRasStatus.UpdateDisplay(const StatusMsg : string);
begin
  if Assigned(FDisplay) then
    TRasStatusDisplay(FDisplay).Panel1.Caption := StatusMsg;
end;

procedure TApdRasStatus.CMRasStatus(var Msg : TMessage);
begin
  if (Msg.Msg = CM_APDRASSTATUS) then begin
    if (Msg.wParam = CancelDialing) then
      if Assigned(RasDialer) then
        RasDialer.Hangup;
  end;
end;

end.
