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
{*                   ADTSTAT.PAS 4.06                    *}
{*********************************************************}
{* TApdTapiStatus dialog                                 *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdTStat;
  {-Standard TAPI status display}

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
  AdTUtil,
  AdTapi;

const
  MaxLines = 9;

type
  TApdStandardTapiDisplay = class(TForm)
    dpPanel1: TPanel;
    dpLabel1: TLabel;
    dpLabel2: TLabel;
    dpLabel3: TLabel;
    dpLabel4: TLabel;
    dpCancel: TButton;
    stPanel: TPanel;
    dpStat1: TLabel;
    dpStat2: TLabel;
    dpStat3: TLabel;
    dpStat4: TLabel;
    dpStat5: TLabel;
    dpStat6: TLabel;
    dpStat7: TLabel;
    dpStat8: TLabel;
    dpStat9: TLabel;
    dpDialing: TLabel;
    dpUsing: TLabel;
    dpAttempt: TLabel;
    dpTotalAttempts: TLabel;
    procedure dpCancelClick(Sender: TObject);

  private
    { Private declarations }
    LabCount : Word;

    procedure ClearStatusMessages;
    procedure AddStatusLine(const S : string);
    procedure Mode(const S : string);                                 
    procedure UpdateStatusLine(const S : string);
    procedure UpdateValues(TapiDevice : TApdCustomTapiDevice;
                           Device, Message,
                           Param1, Param2, Param3 : DWORD);

  public
    { Public declarations }
    Labels     : array[1..MaxLines] of TLabel;
    TapiDevice : TApdCustomTapiDevice;
    Updating   : Boolean;

    constructor Create(AOwner : TComponent); override;
  end;

  {Standard TAPI status class}
  TApdTapiStatus = class(TApdAbstractTapiStatus)
    procedure CreateDisplay; override;
    procedure DestroyDisplay; override;
    procedure UpdateDisplay(First, Last : Boolean; Device, Message,
      Param1, Param2, Param3 : DWORD); override;
  end;

implementation

{$R *.DFM}

{TApdTapiStatus}

  procedure TApdTapiStatus.CreateDisplay;
  begin
    Display := TApdStandardTapiDisplay.Create(Self);
    (Display as TApdStandardTapiDisplay).TapiDevice := TapiDevice;
    (Display as TApdStandardTapiDisplay).Caption := Caption;
  end;

  procedure TApdTapiStatus.DestroyDisplay;
  begin
    if Assigned(FDisplay) then
      Display.Free;
  end;

  procedure TApdTapiStatus.UpdateDisplay(First, Last : Boolean;
    Device, Message, Param1, Param2, Param3 : DWORD);
    {-Update the status display with the latest values}
  begin
    if First then begin
      (Display as TApdStandardTapiDisplay).TapiDevice := TapiDevice;
      (Display as TApdStandardTapiDisplay).ClearStatusMessages;
      if FAnswering then
        (Display as TApdStandardTapiDisplay).Mode('Answering -')
      else
        (Display as TApdStandardTapiDisplay).Mode('Dialing:');
      Display.Show;
    end else if Last then
      Display.Visible := False
    else begin
      if not Display.Visible then begin
        Display.Show;
        (Display as TApdStandardTapiDisplay).ClearStatusMessages;
      end;
      (Display as TApdStandardTapiDisplay).UpdateValues(TapiDevice,
        Device, Message, Param1, Param2, Param3);
    end;
  end;

{TApdStandardTapiDisplay}

  constructor TApdStandardTapiDisplay.Create(AOwner : TComponent);
    {-Create the TapiProgress form}
  begin
    inherited Create(AOwner);

    {Move the labels into an array for easier scrolling}
    Labels[1]  := dpStat1;
    Labels[2]  := dpStat2;
    Labels[3]  := dpStat3;
    Labels[4]  := dpStat4;
    Labels[5]  := dpStat5;
    Labels[6]  := dpStat6;
    Labels[7]  := dpStat7;
    Labels[8]  := dpStat8;
    Labels[9]  := dpStat9;
    ClearStatusMessages;
    Caption := 'Call Progress';
  end;

  procedure TApdStandardTapiDisplay.Mode(const S : string);
  begin
    dpLabel1.Caption := S;
  end;

  procedure TApdStandardTapiDisplay.ClearStatusMessages;
    {-Clear all status messages}
  var
    I : Word;
  begin
    for I := 1 to MaxLines do
      Labels[I].Caption := '';
    dpDialing.Caption := '';
    dpUsing.Caption   := '';                                        
    LabCount := 0;
    Updating := False;
  end;

  procedure TApdStandardTapiDisplay.AddStatusLine(const S : string);
    {-Add a new status message, scrolling if the list is already full}
  var
    I : Integer;
  begin
    Inc(LabCount);
    if (LabCount > MaxLines) then begin
      {Scroll it}
      for I := 2 to MaxLines do
        Labels[I-1].Caption := Labels[I].Caption;
      Dec(LabCount);
    end;

    {Write the new message}
    Labels[LabCount].Caption := S;
  end;

  procedure TApdStandardTapiDisplay.UpdateStatusLine(const S : string);
    {-Update the last status line}
  begin
    Labels[LabCount].Caption := S;
  end;

  procedure TApdStandardTapiDisplay.UpdateValues(TapiDevice : TApdCustomTapiDevice;
    Device, Message, Param1, Param2, Param3 : DWORD);
    {-Update the displayed values}
  var
    Update : Boolean;

  begin
    with TapiDevice do begin
      dpUsing.Caption   := SelectedDevice;
      if Dialing then begin
        dpDialing.Caption := Number;
        dpAttempt.Caption := IntToStr(Attempt);
        dpTotalAttempts.Caption := IntToStr(MaxAttempts);
      end else begin
        dpDialing.Caption := 'Caller ID: ' + string(CallerID);
        dpAttempt.Caption := '1';
        dpTotalAttempts.Caption := '1';
      end;

      {Should we add/scroll a new status line or update the current one?}
      Update := False;
      if (Param1 = LineCallState_Proceeding) or
         (Param1 = APDSpecific_RetryWait) then begin
        {This logic will still cause an "add" for the first "proceeding"}
        Update := Updating;
        Updating := True;
      end else begin
        Updating := False;
      end;

      {Add or update, as required}
      if Update then
        UpdateStatusLine(TapiStatusMsg(Message, Param1, Param2))
      else
        AddStatusLine(TapiStatusMsg(Message, Param1, Param2));
    end;
  end;

  procedure TApdStandardTapiDisplay.dpCancelClick(Sender: TObject);
    {-Cancel the call in progress}
  begin
    TapiDevice.CancelCall;
  end;

end.
