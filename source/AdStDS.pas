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
{*                    ADSTDS.PAS 4.06                    *}
{*********************************************************}
{* TApdStateGenericSource component                      *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdStDS;

{
  Additional Data Sources for the TApdStateMachine component
}
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  Graphics,
  Forms,
  Dialogs,       
  StdCtrls,
  AdStMach;

type
  TApdOnDSOutputString = procedure (Sender  : TObject;
                                    AString : string) of object;
  TApdOnDSOutputBlock = procedure (Sender : TObject;
                                   ABlock : Pointer;
                                   ASize  : Integer) of object;
  TApdOnDSPauseDataSource = procedure (Sender : TObject) of object;
  TApdOnDSResumeDataSource = procedure (Sender : TObject) of object;
  TApdOnDSStateActivate = procedure (Sender : TObject;
                                     AState : TApdCustomState) of object;
  TApdOnDSStateChange = procedure (Sender   : TObject;
                                   OldState : TApdCustomState;
                                   NewState : TApdCustomState) of object;
  TApdOnDSStateDeactivate = procedure (Sender : TObject;
                                       AState : TApdCustomState) of object;
  TApdOnDSStateMachineActivate = procedure (Sender    : TObject;
                                            State     : TApdCustomState;
                                            Condition : TApdStateCondition;
                                            Index     : Integer) of object;
  TApdOnDSStateMachineDeactivate = procedure (Sender : TObject;
                                              AState : TApdCustomState)
                                   of object;
  TApdOnDSStateMachineStart = procedure (
      Sender        : TObject;        
      AStateMachine : TApdCustomStateMachine) of object;
  TApdOnDSStateMachineStop = procedure (Sender : TObject) of object;

  TApdStateGenericSource = class (TApdStateCustomDataSource)
    private
      FOnOutputBlock            : TApdOnDSOutputBlock;
      FOnOutputString           : TApdOnDSOutputString;
      FOnPause                  : TApdOnDSPauseDataSource;
      FOnResume                 : TApdOnDSResumeDataSource;
      FOnStateActivate          : TApdOnDSStateActivate;
      FOnStateChange            : TApdOnDSStateChange;
      FOnStateDeactivate        : TApdOnDSStateDeactivate;
      FOnStateMachineActivate   : TApdOnDSStateMachineActivate;
      FOnStateMachineDeactivate : TApdOnDSStateMachineDeactivate;
      FOnStateMachineStart      : TApdOnDSStateMachineStart;
      FOnStateMachineStop       : TApdOnDSStateMachineStop;

    protected

    public
      constructor Create (AOwner : TComponent); override;
      destructor Destroy; override;

      procedure ChangeState (ConditionIndex : Integer);
      procedure Output (AString : string); override;
      procedure OutputBlock (ABlock : Pointer; ASize : Integer); override;
      procedure Pause; override;
      procedure Resume; override;

      procedure StateActivate (State : TApdCustomState); override;
      procedure StateChange (OldState, NewState : TApdCustomState); override;
      procedure StateDeactivate (State : TApdCustomState); override;
      procedure StateMachineActivate (State     : TApdCustomState;
                                      Condition : TApdStateCondition;
                                      Index     : Integer); override;
      procedure StateMachineDeactivate (State : TApdCustomState); override;
      procedure StateMachineStart (AOwner : TApdCustomStateMachine); override;
      procedure StateMachineStop; override;

    published
      property OnOutputBlock : TApdOnDSOutputBlock
               read FOnOutputBlock write FOnOutputBlock;
      property OnOutputString : TApdOnDSOutputString
               read FOnOutputString write FOnOutputString;
      property OnPause : TApdOnDSPauseDataSource read FOnPause write FOnPause;
      property OnResume : TApdOnDSResumeDataSource
               read FOnResume write FOnResume;
      property OnStateActivate : TApdOnDSStateActivate
               read FOnStateActivate write FOnStateActivate; 
      property OnStateChange : TApdOnDSStateChange
               read FOnStateChange write FOnStateChange;
      property OnStateDeactivate : TApdOnDSStateDeactivate
               read FOnStateDeactivate write FOnStateDeactivate;
      property OnStateMachineActivate : TApdOnDSStateMachineActivate
               read FOnStateMachineActivate write FOnStateMachineActivate;
      property OnStateMachineDeactivate : TApdOnDSStateMachineDeactivate
               read FOnStateMachineDeactivate write FOnStateMachineDeactivate;
      property OnStateMachineStart : TApdOnDSStateMachineStart
               read FOnStateMachineStart write FOnStateMachineStart;
      property OnStateMachineStop : TApdOnDSStateMachineStop
               read FOnStateMachineStop write FOnStateMachineStop;
  end;



implementation

constructor TApdStateGenericSource.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);
end;

destructor TApdStateGenericSource.Destroy;
begin
  inherited Destroy;
end;

procedure TApdStateGenericSource.ChangeState (ConditionIndex : Integer);
begin
  if Assigned (StateMachine) then
    StateMachine.ChangeState (ConditionIndex);
end;

procedure TApdStateGenericSource.Output (AString : string);
begin
  if Assigned (FOnOutputString) then
    FOnOutputString (Self, AString);
end;

procedure TApdStateGenericSource.OutputBlock (ABlock : Pointer;
                                              ASize  : Integer);
begin
  if Assigned (FOnOutputBlock) then
    FOnOutputBlock (Self, ABlock, ASize);
end;

procedure TApdStateGenericSource.Pause;
var
  FireEvent : Boolean;

begin
  FireEvent := not Paused;

  inherited Pause;

  if (FireEvent) and (Assigned (FOnPause)) then
    FOnPause (Self);
end;

procedure TApdStateGenericSource.Resume;
begin
  inherited Resume;

  if (not Paused) and (Assigned (FOnResume)) then
    FOnResume (Self);
end;

procedure TApdStateGenericSource.StateActivate (State : TApdCustomState);
begin
  if State.OutputOnActivate <> '' then
    Output (State.OutputOnActivate);

  if Assigned (FOnStateActivate) then
    FOnStateActivate (Self, State);
end;

procedure TApdStateGenericSource.StateChange (OldState, NewState : TApdCustomState);
begin
  if Assigned (FOnStateChange) then
    FOnStateChange (Self, OldState, NewState);
end;

procedure TApdStateGenericSource.StateDeactivate (State : TApdCustomState);
begin
  if Assigned (FOnStateDeactivate) then
    FOnStateDeactivate (Self, State);
end;

procedure TApdStateGenericSource.StateMachineActivate (State     : TApdCustomState;
                                                       Condition : TApdStateCondition;
                                                       Index     : Integer);
begin
  if Assigned (FOnStateMachineActivate) then
    FOnStateMachineActivate (Self, State, Condition, Index);
end;

procedure TApdStateGenericSource.StateMachineDeactivate (State : TApdCustomState);
begin
  if Assigned (FOnStateMachineDeactivate) then
    FOnStateMachineDeactivate (Self, State);
end;


procedure TApdStateGenericSource.StateMachineStart (
              AOwner : TApdCustomStateMachine);
begin
  inherited StateMachineStart (AOwner);

  if Assigned (FOnStateMachineStart) then
    FOnStateMachineStart (Self, AOwner);
end;

procedure TApdStateGenericSource.StateMachineStop;
begin
  inherited StateMachineStop;

  if Assigned (FOnStateMachineStop) then
    FOnStateMachineStop (Self);
end;

end.

