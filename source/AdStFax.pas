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
{*                   ADSTFAX.PAS 4.06                    *}
{*********************************************************}
{* TApdSendFaxState, TApdReceiveFaxState components      *}
{*********************************************************}


{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}
unit AdStFax;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  AdStSt,
  OoMisc,
  AdFax;

type
  { forwards for use in the event types }
  TApdSendFaxState = class;
  TApdReceiveFaxState = class;
  { fax-specific event types }
  TApdOnSetupSendFax = procedure (Sender : TApdSendFaxState;
                                  AFax   : TApdSendFax) of object;
  TApdOnSetupReceiveFax = procedure (Sender : TApdReceiveFaxState;
                                     AFax   : TApdReceiveFax) of object;
  TApdOnFaxXfrComplete = procedure (Sender        : TApdCustomActionState;
                                    ErrorCode     : Integer;
                                    var NextState : Integer) of object;

  TApdSendFaxState = class (TApdCustomActionState)
    private
      FManualTransmit   : Boolean;
      FOutputOnError    : string;
      FOutputOnOK       : string;
      FSendFax          : TApdSendFax;

      FOnSetupFax       : TApdOnSetupSendFax;
      FOnFaxXfrComplete : TApdOnFaxXfrComplete;

    protected
      procedure Activate; override;
      procedure SetManualTransmit (const v : Boolean);
      procedure SetOutputOnError (const v : string);
      procedure SetOutputOnOK (const v : string);
      procedure SetSendFax (v : TApdSendFax);

    public
      constructor Create (AOwner : TComponent); override;

    published
      property ManualTransmit : Boolean
               read FManualTransmit write SetManualTransmit default False;
      property OutputOnError : string
               read FOutputOnError write SetOutputOnError;
      property OutputOnOK : string read FOutputOnOK write SetOutputOnOK;
      property SendFax : TApdSendFax read FSendFax write SetSendFax;

      property OnFaxXfrComplete : TApdOnFaxXfrComplete
               read FOnFaxXfrComplete write FOnFaxXfrComplete;
      property OnSetupFax : TApdOnSetupSendFax
               read FOnSetupFax write FOnSetupFax;

      property ActiveColor;
      property Caption;
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

  TApdReceiveFaxState = class (TApdCustomActionState)
    private
      FManualReceive    : Boolean; 
      FOutputOnError    : string;
      FOutputOnOK       : string;
      FSendATAToModem   : Boolean;

      FReceiveFax : TApdReceiveFax;

      FOnFaxXfrComplete : TApdOnFaxXfrComplete;
      FOnSetupFax : TApdOnSetupReceiveFax;

    protected
      procedure Activate; override;
      procedure SetManualReceive (const v : Boolean);
      procedure SetOutputOnError (const v : string);
      procedure SetOutputOnOK (const v : string);
      procedure SetReceiveFax (v : TApdReceiveFax);
      procedure SetSendATAToModem (const v : Boolean);

    public
      constructor Create (AOwner : TComponent); override;

    published
      property ManualReceive : Boolean
               read FManualReceive write SetManualReceive default False;
      property OutputOnError : string
               read FOutputOnError write SetOutputOnError;
      property OutputOnOK : string read FOutputOnOK write SetOutputOnOK;
      property ReceiveFax : TApdReceiveFax
               read FReceiveFax write SetReceiveFax;
      property SendATAToModem : Boolean
               read FSendATAToModem write SetSendATAToModem default False;

      property OnFaxXfrComplete : TApdOnFaxXfrComplete
               read FOnFaxXfrComplete write FOnFaxXfrComplete;
      property OnSetupFax : TApdOnSetupReceiveFax
               read FOnSetupFax write FOnSetupFax;

      property ActiveColor;
      property Caption;
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

// TApdSendFaxState ***********************************************************

constructor TApdSendFaxState.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);

  FSendFax         := nil;  

  FOutputOnOk      := '';
  FOutputOnError   := '';
  FManualTransmit  := False;

  FUseLeftBorder   := True;
  FLeftBorderWidth := 18;
  FLeftBorderFill  := $ffbfbf;
  Title            := 'Send Fax';
end;

procedure TApdSendFaxState.Activate;
var
  NextState : Integer;

begin
  inherited Activate;

  if not Assigned (FSendFax) then begin
    NextState := FindDefaultError;
    if NextState >= 0 then
      FinishAction (NextState)
    else begin
      NextState := FindDefaultNext;
      if NextState >= 0 then
        FinishAction (NextState);
    end;
    Exit;
  end;

  if Assigned (FOnSetupFax) then
    FOnSetupFax (Self, FSendFax);

  if FManualTransmit then
    FSendFax.StartManualTransmit
  else
    FSendFax.StartTransmit;
  while (FSendFax.InProgress) do
    SafeYield;

  if FSendFax.FaxError <> ecOK then begin
    NextState := FindDefaultError;
    if NextState < 0 then
      NextState := FindDefaultNext;
  end else
    NextState := FindDefaultNext;

  if Assigned (FOnFaxXfrComplete) then
    FOnFaxXfrComplete (Self, FSendFax.FaxError, NextState);

  if FSendFax.FaxError <> ecOK then begin
    if (OutputOnError <> '') and
       (Assigned (FStateMachine)) and
       (Assigned (FStateMachine.DataSource)) then
      FStateMachine.DataSource.Output (OutputOnError);
  end else begin
    if (OutputOnOK <> '') and
       (Assigned (FStateMachine)) and
       (Assigned (FStateMachine.DataSource)) then
      FStateMachine.DataSource.Output (OutputOnOK);
  end;

  if NextState >= 0 then
    FinishAction (NextState);
end;

procedure TApdSendFaxState.SetManualTransmit (const v : Boolean);
begin
  if v <> FManualTransmit then
    FManualTransmit := v;
end;

procedure TApdSendFaxState.SetOutputOnError (const v : string);
begin
  if v <> FOutputOnError then
    FOutputOnError := v;
end;

procedure TApdSendFaxState.SetOutputOnOK (const v : string);
begin
  if v <> FOutputOnOK then
    FOutputOnOK := v;
end;

procedure TApdSendFaxState.SetSendFax (v : TApdSendFax);
begin
  FSendFax := v;
end;

// TApdReceiveFaxState ********************************************************

constructor TApdReceiveFaxState.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);

  FReceiveFax      := nil;  

  FOutputOnOk      := '';
  FOutputOnError   := '';
  FManualReceive   := False;

  FUseLeftBorder   := True;
  FLeftBorderWidth := 18;
  FLeftBorderFill  := $ffbfbf;
  Title            := 'Rcv Fax';
end;

procedure TApdReceiveFaxState.Activate;
var
  NextState : Integer;

begin
  inherited Activate;

  if not Assigned (FReceiveFax) then begin
    NextState := FindDefaultError;
    if NextState >= 0 then
      FinishAction (NextState)
    else begin
      NextState := FindDefaultNext;
      if NextState >= 0 then
        FinishAction (NextState);
    end;
    Exit;
  end;

  if Assigned (FOnSetupFax) then
    FOnSetupFax (Self, FReceiveFax);

  if FManualReceive then
    FReceiveFax.StartManualReceive (SendATAToModem)
  else
    FReceiveFax.StartReceive;
  while (FReceiveFax.InProgress) do
    SafeYield;

  if FReceiveFax.FaxError <> ecOK then begin
    NextState := FindDefaultError;
    if NextState < 0 then
      NextState := FindDefaultNext;
  end else
    NextState := FindDefaultNext;

  if Assigned (FOnFaxXfrComplete) then
    FOnFaxXfrComplete (Self, FReceiveFax.FaxError, NextState);

  if FReceiveFax.FaxError <> ecOK then begin
    if (OutputOnError <> '') and
       (Assigned (FStateMachine)) and
       (Assigned (FStateMachine.DataSource)) then
      FStateMachine.DataSource.Output (OutputOnError);
  end else begin
    if (OutputOnOK <> '') and
       (Assigned (FStateMachine)) and
       (Assigned (FStateMachine.DataSource)) then
      FStateMachine.DataSource.Output (OutputOnOK);
  end;

  if NextState >= 0 then
    FinishAction (NextState);
end;

procedure TApdReceiveFaxState.SetManualReceive (const v : Boolean);
begin
  if v <> FManualReceive then
    FManualReceive := v;
end;

procedure TApdReceiveFaxState.SetOutputOnError (const v : string);
begin
  if v <> FOutputOnError then
    FOutputOnError := v;
end;

procedure TApdReceiveFaxState.SetOutputOnOK (const v : string);
begin
  if v <> FOutputOnOK then
    FOutputOnOK := v;
end;

procedure TApdReceiveFaxState.SetReceiveFax (v : TApdReceiveFax);
begin
  FReceiveFax := v;
end;

procedure TApdReceiveFaxState.SetSendATAToModem (const v : Boolean);
begin
  if v <> FSendATAToModem then
    FSendATAToModem := v;
end;

end.
