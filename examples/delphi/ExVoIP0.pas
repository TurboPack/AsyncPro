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

unit ExVoIP0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, AdVoIP, OoMisc, ADITapi3, AdExcept;

type
  TfrmExVoIP = class(TForm)
    EdtAddress: TEdit;
    btnConnect: TButton;
    Label2: TLabel;
    ApdVoIP1: TApdVoIP;
    StatusBar1: TStatusBar;
    btnDisconnect: TButton;
    btnAnswer: TButton;
    ListBox1: TListBox;
    btnListTerminals: TButton;
    TreeView1: TTreeView;
    btnSelectMediaDevices: TButton;
    cbxEnablePreview: TCheckBox;
    cbxEnableVideo: TCheckBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    PreviewPanel: TPanel;
    Panel3: TPanel;
    RemotePanel: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    procedure ApdVoIP1Connect(VoIP: TApdCustomVoIP);
    procedure ApdVoIP1Disconnect(VoIP: TApdCustomVoIP);
    procedure ApdVoIP1Fail(VoIP: TApdCustomVoIP; ErrorCode: Integer);
    procedure ApdVoIP1IncomingCall(VoIP: TApdCustomVoIP;
      CallerAddr: String; var Accept: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure EdtAddressChange(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure EdtAddressKeyPress(Sender: TObject; var Key: Char);
    procedure btnAnswerClick(Sender: TObject);
    procedure ApdVoIP1Status(VoIP: TApdCustomVoIP; TapiEvent, Status,
      SubStatus: Word);
    procedure btnListTerminalsClick(Sender: TObject);
    procedure btnSelectMediaDevicesClick(Sender: TObject);
    procedure cbxEnablePreviewClick(Sender: TObject);
    procedure cbxEnableVideoClick(Sender: TObject);
  private
    { Private declarations }
    procedure Add(const S : string);
    procedure RefreshDeviceLabels;
  public
    { Public declarations }
  end;

var
  frmExVoIP: TfrmExVoIP;

implementation

{$R *.DFM}

procedure TfrmExVoIP.FormShow(Sender: TObject);
begin
  btnConnect.Enabled := False;
  btnDisconnect.Enabled := False;
  RefreshDeviceLabels;
  Add('Ready...');
end;

procedure TfrmExVoIP.btnConnectClick(Sender: TObject);
begin
  btnConnect.Enabled := False;
  cbxEnablePreview.Enabled := False;
  cbxEnableVideo.Enabled := False;
  Add('Connecting...');
  ApdVoIP1.Connect(edtAddress.Text);
end;

procedure TfrmExVoIP.EdtAddressChange(Sender: TObject);
begin
  btnConnect.Enabled := (edtAddress.Text <> '');
end;

procedure TfrmExVoIP.btnDisconnectClick(Sender: TObject);
begin
  Add('Disconnecting...');
  ApdVoIP1.CancelCall;
  cbxEnablePreview.Enabled := True;
  cbxEnableVideo.Enabled := True;
  btnAnswer.Enabled := True;
  btnConnect.Enabled := edtAddress.Text <> '';
  btnDisconnect.Enabled := False;
end;

procedure TfrmExVoIP.EdtAddressKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    PostMessage(btnConnect.Handle, BM_CLICK, 0, 0);
end;

procedure TfrmExVoIP.btnAnswerClick(Sender: TObject);
begin
  ApdVoIP1.Connect('');
  btnAnswer.Enabled := False;
  btnConnect.Enabled := False;
  btnDisconnect.Enabled := True;
  cbxEnablePreview.Enabled := False;
  cbxEnableVideo.Enabled := False;
end;

procedure TfrmExVoIP.ApdVoIP1Connect(VoIP: TApdCustomVoIP);
begin
  Add('Connected');
  btnConnect.Enabled := False;
  edtAddress.Enabled := False;
  btnAnswer.Enabled := False;
  btnDisconnect.Enabled := True;
end;

procedure TfrmExVoIP.ApdVoIP1Disconnect(VoIP: TApdCustomVoIP);
begin
  Add('Disconnected');
  Add('Ready...');
  edtAddress.Enabled := True;
  btnConnect.Enabled := (edtAddress.Text <> '');
  btnDisconnect.Enabled := False;
  btnAnswer.Enabled := True;
end;

procedure TfrmExVoIP.ApdVoIP1Status(VoIP: TApdCustomVoIP; TapiEvent,
  Status, SubStatus: Word);
begin
  Add('OnStatus');
end;

procedure TfrmExVoIP.ApdVoIP1Fail(VoIP: TApdCustomVoIP; ErrorCode: Integer);
begin
  Add('Fail : ' + IntToStr(ErrorCode));
end;

procedure TfrmExVoIP.ApdVoIP1IncomingCall(VoIP: TApdCustomVoIP;
  CallerAddr: String; var Accept: Boolean);
begin
  Add('Incoming call from : ' + CallerAddr);
  Accept := (MessageDlg('You have an incoming call. Would you like to accept ' +
             'the call?', mtInformation, [mbYes, mbNo], 0) = mrYes);
  if Accept then
    Add('Answering Call...')
  else
    Add('Ready...');
end;

procedure TfrmExVoIP.Add(const S: string);
begin
  ListBox1.Items.Add(S);
  StatusBar1.SimpleText := S;
end;

procedure TfrmExVoIP.btnListTerminalsClick(Sender: TObject);
  { show the terminals in the tree view }
var
  I : Integer;
  S : string;
  Node1 : TTreeNode;
begin
  TreeView1.Items.Clear;
  for I := 0 to pred(ApdVoIP1.AvailableTerminalDevices.Count) do
    with TApdVoIPTerminal(ApdVoIP1.AvailableTerminalDevices.Items[I]) do begin
      Node1 := TreeView1.Items.Add(nil, DeviceName);
      case DeviceClass of
        dcHandsetTerminal      : S := 'Handset';
        dcHeadsetTerminal      : S := 'Headset';
        dcMediaStreamTerminal  : S := 'MediaStream';
        dcMicrophoneTerminal   : S := 'Microphone';
        dcSpeakerPhoneTerminal : S := 'SpeakerPhone';
        dcSpeakersTerminal     : S := 'Speakers';
        dcVideoInputTerminal   : S := 'VideoInput';
        dcVideoWindowTerminal  : S := 'VideoWindow';
      end;
      TreeView1.Items.AddChild(Node1, 'DeviceClass: ' + S);

      case MediaDirection of
        mdCapture : S := 'Capture';
        mdRender  : S := 'Render';
        mdBiDirectional : S := 'Bidirectional';
      end;
      TreeView1.Items.AddChild(Node1, 'MediaDirection: ' + S);

      case MediaType of
        mtAudio : S := 'Audio';
        mtVideo : S := 'Video';
      end;
      TreeView1.Items.AddChild(Node1, 'MediaType: ' + S);

      case TerminalType of
        ttStatic  : S := 'Static';
        ttDynamic : S := 'Dynamic';
      end;
      TreeView1.Items.AddChild(Node1, 'TerminalType: ' + S);
      case TerminalState of
        tsInUse    : S := 'In use';
        tsNotInUse : S := 'Not in use';
      end;
      TreeView1.Items.AddChild(Node1, 'TerminalState: ' + S);
    end;
end;

procedure TfrmExVoIP.btnSelectMediaDevicesClick(Sender: TObject);
begin
  if ApdVoIP1.ShowMediaSelectionDialog then
    RefreshDeviceLabels;
end;

procedure TfrmExVoIP.cbxEnablePreviewClick(Sender: TObject);
begin
  ApdVoIP1.EnablePreview := cbxEnablePreview.Checked;
  cbxEnableVideo.Checked := ApdVoIP1.EnableVideo;
end;

procedure TfrmExVoIP.cbxEnableVideoClick(Sender: TObject);
begin
  ApdVoIP1.EnableVideo := cbxEnableVideo.Checked;
  { can only preview if video is enabled }
  cbxEnablePreview.Checked := ApdVoIP1.EnablePreview;
  cbxEnablePreview.Enabled := ApdVoIP1.EnableVideo;
end;

procedure TfrmExVoIP.RefreshDeviceLabels;
begin
  cbxEnablePreview.Checked := ApdVoIP1.EnablePreview;
  cbxEnableVideo.Checked := ApdVoIP1.EnableVideo;
  Label5.Caption := ApdVoIP1.AudioInDevice;
  Label6.Caption := ApdVoIP1.AudioOutDevice;
  Label7.Caption := ApdVoIP1.VideoInDevice;
end;

end.













