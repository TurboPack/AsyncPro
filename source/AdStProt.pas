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
{*                   ADSTPROT.PAS 4.06                   *}
{*********************************************************}
{* TApdSendFileState, TApdReceiveFileState components    *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdStProt;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  OoMisc,
  AdStMach,
  AdStSt,
  AdProtcl;

type
  TApdOnSetupProtocol = procedure (Sender    : TObject;
                                   AProtocol : TApdProtocol) of object;
  TApdOnFileXfrComplete = procedure (    Sender    : TObject;
                                         ErrorCode : Integer;
                                     var NextState : Integer) of object;


  TApdSendFileState = class (TApdCustomActionState)
    private
      FOutputOnError     : string;
      FOutputOnOK        : string;
      FProtocol          : TApdProtocol;

      FOnSetupProtocol   : TApdOnSetupProtocol;
      FOnFileXfrComplete : TApdOnFileXfrComplete;

    protected
      procedure Activate; override;
      procedure SetOutputOnError (const v : string);
      procedure SetOutputOnOK (const v : string);
      procedure SetProtocol (v : TApdProtocol);

    public
      constructor Create (AOwner : TComponent); override;

    published
      property OutputOnError : string
               read FOutputOnError write SetOutputOnError;
      property OutputOnOK : string read FOutputOnOK write SetOutputOnOK;
      property Protocol : TApdProtocol read FProtocol write SetProtocol;

      property OnFileXfrComplete : TApdOnFileXfrComplete
               read FOnFileXfrComplete write FOnFileXfrComplete;
      property OnSetupProtocol : TApdOnSetupProtocol
               read FOnSetupProtocol write FOnSetupProtocol;

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

  TApdReceiveFileState = class (TApdCustomActionState)
    private
      FOutputOnError     : string;
      FOutputOnOK        : string;
      FProtocol          : TApdProtocol;

      FOnSetupProtocol   : TApdOnSetupProtocol;
      FOnFileXfrComplete : TApdOnFileXfrComplete;

    protected
      procedure Activate; override;
      procedure SetOutputOnError (const v : string);
      procedure SetOutputOnOK (const v : string);
      procedure SetProtocol (v : TApdProtocol);

    public
      constructor Create (AOwner : TComponent); override;

    published
      property OutputOnError : string
               read FOutputOnError write SetOutputOnError;
      property OutputOnOK : string read FOutputOnOK write SetOutputOnOK;
      property Protocol : TApdProtocol read FProtocol write SetProtocol;

      property OnFileXfrComplete : TApdOnFileXfrComplete
               read FOnFileXfrComplete write FOnFileXfrComplete;
      property OnSetupProtocol : TApdOnSetupProtocol
               read FOnSetupProtocol write FOnSetupProtocol;

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

// TApdSendFileState **********************************************************

constructor TApdSendFileState.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);

  FProtocol        := nil;  

  FOutputOnOk      := '';
  FOutputOnError   := '';

  FUseLeftBorder   := True;
  FLeftBorderWidth := 18;
  FLeftBorderFill  := $bfffbf;
  Title            := 'Send File';
end;

procedure TApdSendFileState.Activate;
var
  NextState : Integer;

begin
  inherited Activate;

  if not Assigned (FProtocol) then begin
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

  if Assigned (FOnSetupProtocol) then
    FOnSetupProtocol (Self, FProtocol);

  FProtocol.StartTransmit;
  while (FProtocol.InProgress) do
    SafeYield;

  if FProtocol.ProtocolError <> ecOK then begin
    NextState := FindDefaultError;
    if NextState < 0 then
      NextState := FindDefaultNext;
  end else
    NextState := FindDefaultNext;

  if Assigned (FOnFileXfrComplete) then
    FOnFileXfrComplete (Self, FProtocol.ProtocolError, NextState);

  if FProtocol.ProtocolError <> ecOK then begin
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

procedure TApdSendFileState.SetOutputOnError (const v : string);
begin
  if v <> FOutputOnError then
    FOutputOnError := v;
end;

procedure TApdSendFileState.SetOutputOnOK (const v : string);
begin
  if v <> FOutputOnOK then
    FOutputOnOK := v;
end;

procedure TApdSendFileState.SetProtocol (v : TApdProtocol);
begin
  FProtocol := v;
end;

// TApdReceiveFileState *******************************************************

constructor TApdReceiveFileState.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);

  FProtocol        := nil;  

  FOutputOnOk      := '';
  FOutputOnError   := '';

  FUseLeftBorder   := True;
  FLeftBorderWidth := 18;
  FLeftBorderFill  := $bfffbf;
  Title            := 'Rcv File';
end;

procedure TApdReceiveFileState.Activate;
var
  NextState : Integer;

begin
  inherited Activate;

  if not Assigned (FProtocol) then begin
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

  if Assigned (FOnSetupProtocol) then
    FOnSetupProtocol (Self, FProtocol);

  FProtocol.StartReceive;
  while (FProtocol.InProgress) do
    SafeYield;

  if FProtocol.ProtocolError <> ecOK then begin
    NextState := FindDefaultError;
    if NextState < 0 then
      NextState := FindDefaultNext;
  end else
    NextState := FindDefaultNext;

  if Assigned (FOnFileXfrComplete) then
    FOnFileXfrComplete (Self, FProtocol.ProtocolError, NextState);

  if FProtocol.ProtocolError <> ecOK then begin
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

procedure TApdReceiveFileState.SetOutputOnError (const v : string);
begin
  if v <> FOutputOnError then
    FOutputOnError := v;
end;

procedure TApdReceiveFileState.SetOutputOnOK (const v : string);
begin
  if v <> FOutputOnOK then
    FOutputOnOK := v;
end;

procedure TApdReceiveFileState.SetProtocol (v : TApdProtocol);
begin
  FProtocol := v;
end;

end.
