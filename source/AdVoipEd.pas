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
{*                   ADVOIPED.PAS 4.06                   *}
{*********************************************************}
{* TApdVoIP property editor                              *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdVoipEd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdVoip;

type
  TVoipAudioVideoEditor = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cboxAudioIn: TComboBox;
    cboxAudioOut: TComboBox;
    cboxVideoIn: TComboBox;
    cboxVideoPlayback: TCheckBox;
    cboxEnablePreview: TCheckBox;
  private
    { Private declarations }
  protected
    procedure GetAudioVideoDevices (Voip : TApdCustomVoip);
  public
    procedure Initialize (Voip : TApdCustomVoip);
    { Public declarations }
  end;

var
  VoipAudioVideoEditor: TVoipAudioVideoEditor;

function EditVoIPAudioVideo (Voip : TApdCustomVoip; const Name : string) : Boolean;

implementation

{$R *.DFM}

function EditVoIPAudioVideo (Voip : TApdCustomVoip; const Name : string) : Boolean;
var
  VoipAudioVideoEditor : TVoipAudioVideoEditor;
begin
  Result := False;
  VoipAudioVideoEditor := TVoipAudioVideoEditor.Create (Application);
  try
    VoipAudioVideoEditor.Initialize (Voip);
    if VoipAudioVideoEditor.ShowModal = mrOk then begin
      Voip.AudioInDevice := VoipAudioVideoEditor.cboxAudioIn.Text;
      Voip.AudioOutDevice := VoipAudioVideoEditor.cboxAudioOut.Text;
      Voip.VideoInDevice := VoipAudioVideoEditor.cboxVideoIn.Text;
      Voip.EnablePreview := VoipAudioVideoEditor.cboxEnablePreview.Checked;
      Voip.EnableVideo :=
          VoipAudioVideoEditor.cboxVideoPlayback.Checked;
      Result := True;
    end;
  finally
    VoipAudioVideoEditor.Free;
  end;
end;

procedure TVoipAudioVideoEditor.GetAudioVideoDevices (Voip : TApdCustomVoip);

var
  i : Integer;
  Term : TApdVoIPTerminal;

begin
  cboxAudioIn.Items.Clear;
  cboxAudioOut.Items.Clear;
  cboxVideoIn.Items.Clear;
  cboxAudioIn.Items.Add ('<none>');
  cboxAudioOut.Items.Add ('<none>');
  cboxVideoIn.Items.Add ('<none>');
  cboxAudioIn.Items.Add ('<default>');
  cboxAudioOut.Items.Add ('<default>');
  cboxVideoIn.Items.Add ('<default>');

  for i := 0 to Voip.AvailableTerminalDevices.Count - 1 do begin
    Term := (Voip.AvailableTerminalDevices.Items[i] as TApdVoIPTerminal);

    if ((Term.MediaDirection = mdRender) and
        (Term.MediaType = mtAudio)) then
      cboxAudioIn.Items.Add (Term.DeviceName);

    if ((Term.MediaDirection = mdCapture) and
        (Term.MediaType = mtAudio)) then
      cboxAudioOut.Items.Add (Term.DeviceName);

    if ((Term.MediaDirection = mdBidirectional) and
        (Term.MediaType = mtAudio)) then begin
      cboxAudioIn .Items.Add (Term.DeviceName);
      cboxAudioOut.Items.Add (Term.DeviceName);
    end;

    if ((Term.MediaDirection = mdCapture) and
        (Term.MediaType = mtVideo)) then
      cboxVideoIn.Items.Add (Term.DeviceName);

    if ((Term.MediaDirection = mdBidirectional) and
        (Term.MediaType = mtVideo)) then 
      cboxVideoIn.Items.Add (Term.DeviceName);
  end;
end;

procedure TVoipAudioVideoEditor.Initialize (Voip : TApdCustomVoip);
begin
  GetAudioVideoDevices (Voip);

  if Voip.AudioInDevice = '' then
    cboxAudioIn.ItemIndex := cboxAudioIn.Items.IndexOf ('<none>')
  else
    cboxAudioIn.ItemIndex := cboxAudioIn.Items.IndexOf (Voip.AudioInDevice);
  if Voip.AudioOutDevice = '' then
    cboxAudioOut.ItemIndex := cboxAudioOut.Items.IndexOf ('<none>')
  else
    cboxAudioOut.ItemIndex := cboxAudioOut.Items.IndexOf (Voip.AudioOutDevice);
  if Voip.VideoInDevice = '' then
    cboxVideoIn.ItemIndex := cboxVideoIn.Items.IndexOf ('<none>')
  else
    cboxVideoIn.ItemIndex := cboxVideoIn.Items.IndexOf (Voip.VideoInDevice);

  cboxEnablePreview.Checked := Voip.EnablePreview;
  cboxVideoPlayback.Checked := Voip.EnableVideo;
end;

end.
