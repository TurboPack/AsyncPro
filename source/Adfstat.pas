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
{*                   ADFSTAT.PAS 4.06                    *}
{*********************************************************}
{* Fax status dialog, created by the TApdFaxStatus       *}
{* component.                                            *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdFStat;

interface

uses
  SysUtils,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  AdMeter,
  OoMisc,
  AdFax;

type
  {.Z+}
  {Standard fax status form}
  TStandardFaxDisplay = class(TForm)
    fsPhoneNumber       : TLabel;
    fsFaxFileName       : TLabel;
    fsCoverFileName     : TLabel;
    fsTotalPages        : TLabel;
    fsRemoteID          : TLabel;
    fsConnectBPS        : TLabel;
    fsResolution        : TLabel;
    fsWidth             : TLabel;
    fsErrorControl      : TLabel;
    fsCurrentPage       : TLabel;
    fsPageLength        : TLabel;
    fsBytesTransferred  : TLabel;
    fsElapsedTime       : TLabel;
    fsStatusMsg         : TLabel;
    fsCancel            : TButton;
    fsPanel1            : TPanel;
    fsLabel5            : TLabel;
    fsLabel19           : TLabel;
    fsDialAttempt       : TLabel;
    fsPanel6            : TPanel;
    fsLabel2            : TLabel;
    fsLabel3            : TLabel;

    procedure UpdateValues(Fax : TApdCustomAbstractFax);
    procedure CancelClick(Sender: TObject);

  public
    Fax                 : TApdCustomAbstractFax;
    fsMeter1            : TApdMeter;

    constructor Create(AOwner : TComponent); override;

  private
    Timer               : EventTimer;
    Timing              : Boolean;
    BusyTimer           : EventTimer;
    BusyTiming          : Boolean;
  end;
  {.Z-}

  {Standard fax status class}
  TApdFaxStatus = class(TApdAbstractFaxStatus)
    procedure CreateDisplay; override;
    procedure DestroyDisplay; override;
    procedure UpdateDisplay(const First, Last : Boolean); override;
  end;

implementation

{General}

  function LeftPad(const S : String; Len : Byte) : String;
    {-Return a string left-padded to length len}
  var
//    o : String;
    SLen : Byte;
  begin
    SLen := Length(S);
    Result := StringOfChar(' ', SLen - Len) + S;  // Tiburon

  end;

  function FormatMinSec(const TotalSecs : Integer) : String;
    {-Format TotalSecs as minutes:seconds, leftpadded to 6}
  var
    Min, Sec : Integer;
    S : ShortString;
  begin
    Min := TotalSecs div 60;
    Sec := TotalSecs mod 60;
    Str(Sec:2, S);
    if S[1] = ' ' then
      S[1] := '0';
    FormatMinSec := LeftPad(IntToStr(Min) + ':' + string(S), 6);
  end;

  function FixFileName(const FileName : ShortString) : ShortString;
    {-Extract just the filename, truncate to 20 characters}
  const
    MaxShowSize  = 20;
  begin
    Result := ShortString(ExtractFileName(string(FileName)));
    if Length(Result) > MaxShowSize then begin
      SetLength(Result, MaxShowSize);
      Result := Result + '...';
    end;
  end;

{TStandardStatus}

  constructor TStandardFaxDisplay.Create(AOwner : TComponent);
    {-Create the fax display}
  begin
    inherited Create(AOwner);
    Timing := False;
    BusyTiming := False;
    fsMeter1 := TApdMeter.Create(fsPanel6);
    fsMeter1.Parent    := fsPanel6;
    fsMeter1.Left      := 99;
    fsMeter1.Top       := 7;
    fsMeter1.Width     := 406;
    fsMeter1.Height    := 20;
    fsMeter1.Position  := 0;
    fsMeter1.Step      := 10;                                
  end;

  procedure TStandardFaxDisplay.UpdateValues(Fax : TApdCustomAbstractFax);
    {-Update the captions of all of the status fields}
  const
    ResStrings   : array[Boolean] of String = ('standard', 'high');
    WidthStrings : array[Boolean] of String = ('1728', '2048');
    OnOffStrings : array[Boolean] of String = ('off', 'on');
  var
    Progress     : Word;
    KillTimer    : Boolean;
  begin
    with Fax do begin
      {Time to start timer?}
      if (not Timing) and
         ((FaxProgress = fpGotRemoteID) or
          (FaxProgress = fpSessionParams)) then begin
        Timing := True;
        NewTimer(Timer, 0);
      end;

      {Time to kill timer?}
      KillTimer := (FaxProgress = fpFinished) or
                   (FaxProgress = fpCancel) or
                   (FaxProgress = fpGotHangup);
      if Timing and KillTimer then
        Timing := False;

      {Time to start busy timer}
      if (not BusyTiming) and (FaxProgress = fpBusyWait) then begin
        BusyTiming := True;
        NewTimerSecs(BusyTimer, TApdCustomSendFax(Fax).DialRetryWait);
      end;

      {Timer to kill busy timer}
      if BusyTiming and (FaxProgress <> fpBusyWait) then
        BusyTiming := False;

      {Left top block}
      if Fax is TApdCustomSendFax then begin
        with (Fax as TApdCustomSendFax) do begin
          fsPhoneNumber.Caption    := string(PhoneNumber);
          fsFaxFileName.Caption    := string(FixFileName(FaxFile));
          fsCoverFileName.Caption  := string(FixFileName(CoverFile));
          fsDialAttempt.Caption    := IntToStr(DialAttempt);
        end;
      end else begin
        fsPhoneNumber.Caption      := '';
        fsFaxFileName.Caption      := string(FixFileName(FaxFile));
        fsCoverFileName.Caption    := '';
        fsDialAttempt.Caption      := '1';
      end;
      fsTotalPages.Caption         := IntToStr(TotalPages);

      {Right top block}
      fsRemoteID.Caption           := string(RemoteID);
      fsConnectBPS.Caption         := IntToStr(SessionBPS);
      fsResolution.Caption         := ResStrings[SessionResolution];
      fsWidth.Caption              := WidthStrings[SessionWidth];
      fsErrorControl.Caption       := OnOffStrings[SessionECM];

      {Left bottom block}
      if CurrentPage = 0 then
        fsCurrentPage.Caption := '<cover page>'
      else
        fsCurrentPage.Caption      := IntToStr(CurrentPage);
      fsPageLength.Caption         := IntToStr(PageLength);

      {Right bottom block: throughput}
      fsBytesTransferred.Caption   := IntToStr(BytesTransferred);
      if Timing then begin
        fsElapsedTime.Caption      := FormatMinSec(ElapsedTimeInSecs(Timer));
      end else
        fsElapsedTime.Caption      := '00:00';

      {Status message}
      if (FaxProgress = fpBusyWait) then
        fsStatusMsg.Caption := string(StatusMsg(FaxProgress)) +
                               FormatMinSec(RemainingTimeInSecs(BusyTimer))
      else
        fsStatusMsg.Caption := string(StatusMsg(FaxProgress));

      {Progress bar}
      if Fax is TApdCustomSendFax then begin
        if PageLength <> 0 then
          Progress := Round(100 * (BytesTransferred / PageLength))
        else
          Progress := 0;
        fsMeter1.Min := 0;
        fsMeter1.Max := 100;
        fsMeter1.Position := Progress;
      end else begin
        fsMeter1.Visible := False;
        fsLabel19.Caption := 'Page progress: N/A';
      end;
    end;
  end;

  procedure TStandardFaxDisplay.CancelClick(Sender: TObject);
    {-Cancel button was clicked, go cancel fax}
  begin
    Fax.CancelFax;
  end;

{TApdProtocolStatus}

  procedure TApdFaxStatus.CreateDisplay;
  begin
    Display := TStandardFaxDisplay.Create(Self);

    (Display as TStandardFaxDisplay).Fax := Fax;

    (Display as TStandardFaxDisplay).Caption := FCaption;

  end;

  procedure TApdFaxStatus.DestroyDisplay;
  begin
    if Assigned(FDisplay) then
      Display.Free;
  end;

  procedure TApdFaxStatus.UpdateDisplay(const First, Last : Boolean);
  begin
    if First then begin
      (Display as TStandardFaxDisplay).Fax := Fax;
      Display.Show;
    end;
    if Last then
      Display.Visible := False
    else
      (Display as TStandardFaxDisplay).UpdateValues(Fax);
  end;

{$R *.DFM}

end.
