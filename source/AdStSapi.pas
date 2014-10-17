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
{*                   ADSTSAPI.PAS 4.06                   *}
{*********************************************************}
{* TApdSAPISpeakState component                          *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdStSapi;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  OoMisc,
  AdExcept,
  AdStSt,
  AdSapiEn;

type
  TApdOnSetupSpeakString = procedure (    Sender  : TObject;
                                      var AString : string) of object;

  TApdSAPISpeakState = class (TApdCustomActionState)
    private
      FStringToSpeak      : string;
      FSapiEngine         : TApdSapiEngine;
      FOnSetupSpeakString : TApdOnSetupSpeakString;

    protected
      procedure SetSapiEngine (const v : TApdSapiEngine);
      procedure SetStringToSpeak (const v : string);

    public
      constructor Create (AOwner : TComponent); override;

      procedure Activate; override;

    published
      property SapiEngine : TApdSapiEngine
               read FSapiEngine write SetSapiEngine;
      property StringToSpeak : string
               read FStringToSpeak write SetStringToSpeak;

      property OnGetData;
      property OnGetDataString;
      property OnSetupSpeakString : TApdOnSetupSpeakString
               read FOnSetupSpeakString write FOnSetupSpeakString;

      property ActiveColor;
      property Caption;
      property Conditions;
      property Font;
      property Glyph;
      property GlyphCells;
      property InactiveColor;
      property Movable;
      property OutputOnActivate;

      property OnStateActivate;
      property OnStateFinish;
      property OnSelectNextState;
  end;

implementation

// TApdSapiSpeakState *********************************************************

constructor TApdSapiSpeakState.Create (AOwner : TComponent);
begin
  inherited Create (AOwner);

  FStringToSpeak   := '';
  FLeftBorderFill  := $ffffbf;
  Title            := 'Speak';
end;

procedure TApdSapiSpeakState.Activate;
var
  S : string;
begin
  inherited;
  try
    if not Assigned (FSapiEngine) then
      raise EStateMachine.Create (ecNoSapiEngine, False);
    S := FStringToSpeak;
    if Assigned(FOnSetupSpeakString) then
      FOnSetupSpeakString(Self, S);
    FSapiEngine.Speak (S);
    FSapiEngine.WaitUntilDoneSpeaking;
  finally
    AutoSelectNextState (False);
  end;
end;

procedure TApdSapiSpeakState.SetSapiEngine (const v : TApdSapiEngine);
begin
  FSapiEngine := v;
end;

procedure TApdSapiSpeakState.SetStringToSpeak (const v : string);
begin
  if v <> FStringToSpeak then
    FStringToSpeak := v;
end;

end.
