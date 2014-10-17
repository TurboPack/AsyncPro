unit ExTapi1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Spin, StdCtrls, OleCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    spinAnswerOnRing: TSpinEdit;
    spinMaxAttempts: TSpinEdit;
    spinRetryWait: TSpinEdit;
    GroupBox2: TGroupBox;
    btnAnswer: TButton;
    btnDial: TButton;
    btnCancel: TButton;
    btnSelect: TButton;
    btnConfig: TButton;
    chkTapiStatusDisplay: TCheckBox;
    chkEnableVoice: TCheckBox;
    chkInterruptWave: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    chkUseSoundCard: TCheckBox;
    spinMaxMessageLength: TSpinEdit;
    spinTrimSeconds: TSpinEdit;
    spinSilenceThreshold: TSpinEdit;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    edtWaveDirectory: TEdit;
    btnPlayWave: TButton;
    btnRecordWave: TButton;
    btnStopWaveFile: TButton;
    chkOverwrite: TCheckBox;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    btnSendTone: TButton;
    Label4: TLabel;
    Apax1: TApax;
    procedure FormActivate(Sender: TObject);
    procedure btnAnswerClick(Sender: TObject);
    procedure btnDialClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure Apax1TapiCallerID(Sender: TObject; const ID,
      IDName: WideString);
    procedure Apax1TapiConnect(Sender: TObject);
    procedure Apax1TapiDTMF(Sender: TObject; Digit: Byte;
      ErrorCode: Integer);
    procedure Apax1TapiFail(Sender: TObject);
    procedure Apax1TapiPortClose(Sender: TObject);
    procedure Apax1TapiGetNumber(Sender: TObject;
      var PhoneNum: WideString);
    procedure Apax1TapiPortOpen(Sender: TObject);
    procedure Apax1TapiStatus(Sender: TObject; First, Last: WordBool;
      Device, Message, Param1, Param2, Param3: Integer);
    procedure Apax1TapiWaveNotify(Sender: TObject; Msg: TOleEnum);
    procedure Apax1TapiWaveSilence(Sender: TObject; var StopRecording,
      Hangup: WordBool);
    procedure ListBox1DblClick(Sender: TObject);
    procedure btnPlayWaveClick(Sender: TObject);
    procedure btnRecordWaveClick(Sender: TObject);
    procedure chkTapiStatusDisplayClick(Sender: TObject);
    procedure btnStopWaveFileClick(Sender: TObject);
    procedure btnSendToneClick(Sender: TObject);
    procedure spinAnswerOnRingChange(Sender: TObject);
    procedure spinMaxAttemptsChange(Sender: TObject);
    procedure spinRetryWaitChange(Sender: TObject);
    procedure spinMaxMessageLengthChange(Sender: TObject);
    procedure spinTrimSecondsChange(Sender: TObject);
    procedure spinSilenceThresholdChange(Sender: TObject);
    procedure chkEnableVoiceClick(Sender: TObject);
    procedure chkInterruptWaveClick(Sender: TObject);
    procedure chkUseSoundCardClick(Sender: TObject);
  private
    procedure Add(const S : string);
    function TapiStateStr(State: TxTapiState) : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormActivate(Sender: TObject);
begin
  Apax1.Visible := False;
  spinAnswerOnRing.Value := Apax1.AnswerOnRing;
  spinMaxAttempts.Value := Apax1.MaxAttempts;
  spinRetryWait.Value := Apax1.TapiRetryWait;
  spinMaxMessageLength.Value := Apax1.MaxMessageLength;
  spinTrimSeconds.Value := Apax1.TrimSeconds;
  spinSilenceThreshold.Value := Apax1.SilenceThreshold;
  chkEnableVoice.Checked := Apax1.EnableVoice;
  chkInterruptWave.Checked := Apax1.InterruptWave;
  chkUseSoundCard.Checked := Apax1.UseSoundCard;
  chkTapiStatusDisplay.Checked := Apax1.TapiStatusDisplay;
end;

procedure TForm1.Add(const S: String);
begin
  if assigned(ListBox1) then begin
    ListBox1.Items.Add(S);
    if ListBox1.Items.Count > 10 then
      ListBox1.ItemIndex := ListBox1.Items.Count - 1;
  end;
end;

function TForm1.TapiStateStr(State: TxTapiState) : string;
begin
  case State of
    tsIdle                 : Result := 'tsIdle';
    tsOffering             : Result := 'tsOffering';
    tsAccepted             : Result := 'tsAccepted';
    tsDialTone             : Result := 'tsDialTone';
    tsDialing              : Result := 'tsDialing';
    tsRingback             : Result := 'tsRingBack';
    tsBusy                 : Result := 'tsBusy';
    tsSpecialInfo          : Result := 'tsSpecialInfo';
    tsConnected            : Result := 'tsConnected';
    tsProceeding           : Result := 'tsProceeding';
    tsOnHold               : Result := 'tsOnHold';
    tsConferenced          : Result := 'tsConferenced';
    tsOnHoldPendConf       : Result := 'tsOnHoldPendConf';
    tsOnHoldPendTransfer   : Result := 'tsOnHoldPendTransfer';
    tsDisconnected         : Result := 'tsDisconnected';
    tsUnknown              : Result := 'tsUnknown';
  end;
  Result := '  TapiState: ' + Result + ' (' + IntToStr(Ord(Apax1.TapiState))+ ')';
end;

procedure TForm1.btnAnswerClick(Sender: TObject);
begin
  Add('Answer button clicked (' + Apax1.SelectedDevice + ')');
  Add(TapiStateStr(Apax1.TapiState));
  Apax1.TapiAnswer;
end;

procedure TForm1.btnDialClick(Sender: TObject);
begin
  Add('Dial button click (' + Apax1.SelectedDevice + ')');
  Add(TapiStateStr(Apax1.TapiState));
  Apax1.TapiDial;
end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
  Add('Cancel button click');
  Add(TapiStateStr(Apax1.TapiState));
  Apax1.Close;
end;

procedure TForm1.btnSelectClick(Sender: TObject);
begin
  Apax1.TapiSelectDevice;
  Add('SelectedDevice = ' + Apax1.SelectedDevice);
end;

procedure TForm1.btnConfigClick(Sender: TObject);
begin
  Apax1.TapiShowConfigDialog(True);
  Add('Config button click (' + Apax1.SelectedDevice + ')');
  Add(TapiStateStr(Apax1.TapiState));
end;

procedure TForm1.Apax1TapiCallerID(Sender: TObject; const ID,
  IDName: WideString);
begin
  Add('OnCallerID: ID = ' + ID);
  Add('          : IDName = ' + IDName);
end;

procedure TForm1.Apax1TapiConnect(Sender: TObject);
begin
  Add('OnTapiConnect');
  Add(TapiStateStr(Apax1.TapiState));
  if Apax1.EnableVoice then
    Apax1.TapiPlayWaveFile(edtWaveDirectory.Text + '\greeting.wav');
end;

procedure TForm1.Apax1TapiDTMF(Sender: TObject; Digit: Byte;
  ErrorCode: Integer);
begin
  Add('OnTapiDTMF: ' + Char(Digit));
  Add(TapiStateStr(Apax1.TapiState));
end;

procedure TForm1.Apax1TapiFail(Sender: TObject);
begin
  if Apax1.TapiCancelled then
    Add('OnTapiFail because we cancelled the call')
  else
    Add('OnTapiFail due to a real failure');
  Add('  ' + TapiStateStr(Apax1.TapiState));
end;

procedure TForm1.Apax1TapiGetNumber(Sender: TObject;
  var PhoneNum: WideString);
var S : string;
begin
  S := Apax1.TapiNumber;
  if InputQuery(Caption, 'Phone number', S) then
    PhoneNum := S;
  Add('OnTapiGetNumber - ' + PhoneNum);
  Add(TapiStateStr(Apax1.TapiState));
end;

procedure TForm1.Apax1TapiPortClose(Sender: TObject);
begin
  Add('OnTapiPortClose');
  Add(TapiStateStr(Apax1.TapiState));
end;

procedure TForm1.Apax1TapiPortOpen(Sender: TObject);
begin
  Add('OnTapiPortOpen');
  Add(TapiStateStr(Apax1.TapiState));
end;

procedure TForm1.Apax1TapiStatus(Sender: TObject; First, Last: WordBool;
  Device, Message, Param1, Param2, Param3: Integer);
begin
  Add('OnTapiStatus: ' + Apax1.TapiStatusMsg(Message, Param1, Param2) +
   ', ('+IntToStr(Message)+'), ('+IntToStr(Param1)+'), ('+IntToStr(Param2)
   +'), ('+IntToStr(Param3) + ')');
  Add(TapiStateStr(Apax1.TapiState));
end;

procedure TForm1.Apax1TapiWaveNotify(Sender: TObject; Msg: TOleEnum);
var
  S : string;
begin
  case Msg of
    waPlayOpen    : S := 'waPlayOpen';
    waPlayDone    : S := 'waPlayDone';
    waPlayClose   : S := 'waPlayClose';
    waRecordOpen  : S := 'waRecordOpen';
    waDataReady   : S := 'waDataReady';
    waRecordClose : S := 'waRecordClose';
  end;
  Add('OnTapiWaveNotify: ' + S);
end;

procedure TForm1.Apax1TapiWaveSilence(Sender: TObject; var StopRecording,
  Hangup: WordBool);
begin
  Add('OnTapiWaveSilence');
end;

procedure TForm1.btnPlayWaveClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := edtWaveDirectory.Text;
  if OpenDialog1.Execute then begin
    Add('Playing wave file (' + OpenDialog1.FileName + ')');
    Apax1.TapiPlayWaveFile(OpenDialog1.FileName);
  end;
end;

procedure TForm1.btnRecordWaveClick(Sender: TObject);
begin
  SaveDialog1.InitialDir := edtWaveDirectory.Text;
  if SaveDialog1.Execute then begin
    Add('StartWaveRecord to ' + SaveDialog1.FileName);
    Apax1.TapiRecordWaveFile(SaveDialog1.FileName, chkOverwrite.Checked);
  end;
end;

procedure TForm1.btnStopWaveFileClick(Sender: TObject);
begin
  Apax1.TapiStopWaveFile;
  Add('Stopping wav file');
end;

procedure TForm1.btnSendToneClick(Sender: TObject);
var
  S : string;
begin
  S := InputBox('Enter digits to send', '', '');
  if (S <> '') then begin
    Add('SendTone(' + S + ')');
    Apax1.TapiSendTone(S);
  end;
end;

procedure TForm1.spinAnswerOnRingChange(Sender: TObject);
begin
  Apax1.AnswerOnRing := TSpinEdit(Sender).Value;
end;

procedure TForm1.spinMaxAttemptsChange(Sender: TObject);
begin
  Apax1.MaxAttempts := TSpinEdit(Sender).Value;
end;

procedure TForm1.spinRetryWaitChange(Sender: TObject);
begin
  Apax1.TapiRetryWait := TSpinEdit(Sender).Value;
end;

procedure TForm1.spinMaxMessageLengthChange(Sender: TObject);
begin
  Apax1.MaxMessageLength := TSpinEdit(Sender).Value;
end;

procedure TForm1.spinTrimSecondsChange(Sender: TObject);
begin
  Apax1.TrimSeconds := TSpinEdit(Sender).Value;
end;

procedure TForm1.spinSilenceThresholdChange(Sender: TObject);
begin
  Apax1.SilenceThreshold := TSpinEdit(Sender).Value;
end;

procedure TForm1.chkEnableVoiceClick(Sender: TObject);
begin
  Apax1.EnableVoice := TCheckBox(Sender).Checked;
end;

procedure TForm1.chkInterruptWaveClick(Sender: TObject);
begin
  Apax1.InterruptWave := TCheckBox(Sender).Checked;
end;

procedure TForm1.chkUseSoundCardClick(Sender: TObject);
begin
  Apax1.UseSoundCard := TCheckBox(Sender).Checked;
end;

procedure TForm1.chkTapiStatusDisplayClick(Sender: TObject);
begin
  Apax1.TapiStatusDisplay := TCheckBox(Sender).Checked;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  ListBox1.Clear;
end;

end.
