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
{*                   ADPSTAT.PAS 4.06                    *}
{*********************************************************}
{* Protocol status display for the TApdProtocolStatus    *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdPStat;

interface

uses
  {------RTL}
  SysUtils,
  Windows,
  {------VCL}
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  AdMeter,
  {------Apro}
  OoMisc,
  AdProtcl;

type
  {.Z+}
  {Standard protocol status form}
  TStandardDisplay = class(TForm)
    psProtocol          : TLabel;
    psBlockCheck        : TLabel;
    psFileName          : TLabel;
    psFileSize          : TLabel;
    psBlockSize         : TLabel;
    psTotalBlocks       : TLabel;
    psBytesTransferred  : TLabel;
    psBytesRemaining    : TLabel;
    psBlocksTransferred : TLabel;
    psBlocksRemaining   : TLabel;
    psBlockErrors       : TLabel;
    psTotalErrors       : TLabel;
    psEstimatedTime     : TLabel;
    psElapsedTime       : TLabel;
    psRemainingTime     : TLabel;
    psThroughput        : TLabel;
    psEfficiency        : TLabel;
    psKermitWindows     : TLabel;
    psStatusMsg         : TLabel;
    psCancel            : TButton;
    psPanel1            : TPanel;
    psPanel6				 : TPanel;
    procedure UpdateValues(Protocol : TApdCustomProtocol);
    procedure CancelClick(Sender: TObject);
  private
    psProgressBar       : TApdMeter;
  public
    Protocol            : TApdCustomProtocol;
    constructor Create(Owner : TComponent); override;           
  end;
  {.Z-}

  {Standard protocol status class}
  TApdProtocolStatus = class(TApdAbstractStatus)
    procedure CreateDisplay; override;
    procedure DestroyDisplay; override;
    procedure UpdateDisplay(First, Last : Boolean); override;
  end;

implementation

uses
  AnsiStrings;

{TStandardStatus}

  constructor TStandardDisplay.Create(Owner : TComponent);
  begin
    inherited Create(Owner);
    psProgressBar := TApdMeter.Create(psPanel6);
    psProgressBar.Parent    := psPanel6;
    psProgressBar.Left      := 64;
    psProgressBar.Top       := 7;
    psProgressBar.Width     := 377;
    psProgressBar.Height    := 20;
    psProgressBar.Position  := 0;
    psProgressBar.Step      := 10;
  end;                                                            

  procedure TStandardDisplay.UpdateValues(Protocol : TApdCustomProtocol);
  const
    {Truncate file names to this length}
    MaxShowSize = 18;
  var
    Progress : Word;
    Blocks   : Integer;
    R        : Double;
    CPS      : Double;
    Efficiency : Double;
    S        : String;
  begin
    with Protocol do begin
      {Left top block}
      psProtocol.Caption        := string(ProtocolName(ProtocolType));
      psBlockCheck.Caption      := string(CheckNameString(BlockCheckMethod));
      psFileName.Caption        := string(ExtractFileName(FileName));
      if Length(psFileName.Caption) > MaxShowSize then begin
        S := psFileName.Caption;
        SetLength(S, MaxShowSize);
        psFileName.Caption := S + '...';
      end;
      psFileSize.Caption        := IntToStr(FileLength);
      psBlockSize.Caption       := IntToStr(BlockLength);
      if BlockLength = 0 then
        psTotalBlocks.Caption := '0'
      else
        psTotalBlocks.Caption :=
          IntToStr(FileLength div Integer(BlockLength));

      {Right top block}
      psBytesTransferred.Caption  := IntToStr(BytesTransferred);
      psBytesRemaining.Caption  := IntToStr(BytesRemaining);
      psBlocksTransferred.Caption :=
        IntToStr(BytesTransferred div Integer(BlockLength));
      Blocks :=
        (BytesRemaining+Integer(Pred(BlockLength))) div Integer(BlockLength);
      psBlocksRemaining.Caption := IntToStr(Blocks);
      psBlockErrors.Caption     := IntToStr(BlockErrors);
      psTotalErrors.Caption     := IntToStr(TotalErrors);

      {Left bottom block}
      psEstimatedTime.Caption   :=
        string(FormatMinSec(EstimateTransferSecs(FileLength)));
      psElapsedTime.Caption     :=
        string(FormatMinSec(Ticks2Secs(ElapsedTicks)));
      psRemainingTime.Caption   :=
        string(FormatMinSec(EstimateTransferSecs(BytesRemaining)));

      {Right bottom block: throughput}
      if ElapsedTicks > 0 then begin
        R := BytesTransferred - InitialPosition;
        CPS := R / (ElapsedTicks / 18.2);
      end else
        CPS := 0.0;
      psThroughput.Caption      := Format('%5.0f CPS', [CPS]);

      {Efficiency}
      if ActualBPS <> 0 then
        Efficiency := (CPS / (ActualBPS div 10)) * 100.0
      else
        Efficiency := 0.0;
      psEfficiency.Caption      := Format('%3.0f', [Efficiency]) + '%';
      psKermitWindows.Caption   := IntToStr(KermitWindowsUsed);

      {Status message}
      psStatusMsg.Caption       := string(StatusMsg(ProtocolStatus));

      {Progress bar}
      if FileLength <> 0 then
        Progress := Round(100 * (BytesTransferred / FileLength))
      else
        Progress := 0;
      psProgressBar.Min := 0;
      psProgressBar.Max := 100;
      psProgressBar.Position := Progress;
    end;
  end;

  procedure TStandardDisplay.CancelClick(Sender: TObject);
    {-Cancel button was clicked, go cancel protocol}
  begin
    Protocol.CancelProtocol;
  end;

{TApdProtocolStatus}

  procedure TApdProtocolStatus.CreateDisplay;
  begin
    Display := TStandardDisplay.Create(Self);

    (Display as TStandardDisplay).Protocol := Protocol;
    (Display as TStandardDisplay).Caption := FCaption;
  end;

  procedure TApdProtocolStatus.DestroyDisplay;
  begin
    if Assigned(FDisplay) then
      Display.Free;
  end;

  procedure TApdProtocolStatus.UpdateDisplay(First, Last : Boolean);
  begin
    if First then begin
      (Display as TStandardDisplay).Protocol := Protocol;
      Display.Show;
    end;
    if Last then
      Display.Visible := False
    else begin
      (Display as TStandardDisplay).UpdateValues(Protocol);
      { Added Repaint to help at high speeds (Winsock) }
      (Display as TStandardDisplay).Repaint;
    end;
  end;

{$R *.DFM}

end.
