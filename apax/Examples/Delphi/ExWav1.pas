unit ExWav1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, Menus, OleCtrls, FileCtrl, Apax1_TLB;

type
  TForm1 = class(TForm)
    gbxWavFile: TGroupBox;
    Label1: TLabel;
    edtWavFile: TEdit;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    btnPlayWavFile: TButton;
    btnRecordWavFile: TButton;
    btnStopWavFile: TButton;
    chkOverwrite: TCheckBox;
    gbxDTMF: TGroupBox;
    btnSendDTMF: TButton;
    edtSendDTMF: TEdit;
    edtReceivedDTMF: TEdit;
    Label2: TLabel;
    gbxTapiConnection: TGroupBox;
    btnAnswer: TButton;
    btnHangup: TButton;
    DirectoryListBox1: TDirectoryListBox;
    Label3: TLabel;
    Apax1: TApax;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnAnswerClick(Sender: TObject);
    procedure btnHangupClick(Sender: TObject);
    procedure Apax1TapiConnect(Sender: TObject);
    procedure Apax1PortClose(Sender: TObject);
    procedure btnPlayWavFileClick(Sender: TObject);
    procedure btnRecordWavFileClick(Sender: TObject);
    procedure btnStopWavFileClick(Sender: TObject);
    procedure btnSendDTMFClick(Sender: TObject);
    procedure Apax1TapiDTMF(Sender: TObject; Digit: Byte;
      ErrorCode: Integer);
    procedure FormActivate(Sender: TObject);
    procedure Apax1TapiWaveNotify(Sender: TObject; Msg: TOleEnum);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  ExampleWavDir : string;
  HangupPending : Boolean;

procedure TForm1.btnAnswerClick(Sender: TObject);
begin
  Apax1.TapiAnswer;
end;

procedure TForm1.btnHangupClick(Sender: TObject);
begin
  Apax1.Close;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edtWavFile.Text := OpenDialog1.FileName;
end;

procedure TForm1.btnPlayWavFileClick(Sender: TObject);
begin
  Apax1.TapiPlayWaveFile(edtWavFile.Text);
end;

procedure TForm1.btnRecordWavFileClick(Sender: TObject);
begin
  Apax1.TapiRecordWaveFile(edtWavFile.Text, chkOverwrite.Checked);
end;

procedure TForm1.btnStopWavFileClick(Sender: TObject);
begin
  Apax1.TapiStopWaveFile;
end;

procedure TForm1.btnSendDTMFClick(Sender: TObject);
begin
  Apax1.TapiSendTone(edtSendDTMF.Text);
end;

procedure TForm1.Apax1TapiConnect(Sender: TObject);
begin
  Apax1.TapiPlayWaveFile(ExampleWavDir + '\greeting.wav');
  gbxWavFile.Enabled := True;
  gbxDTMF.Enabled := True;
  HangupPending := False;
end;

procedure TForm1.Apax1PortClose(Sender: TObject);
begin
  gbxWavFile.Enabled := False;
  gbxDTMF.Enabled := False;
end;

procedure TForm1.Apax1TapiDTMF(Sender: TObject; Digit: Byte;
  ErrorCode: Integer);
begin
  case Char(Digit) of
    '0' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice0.wav');
    '1' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice1.wav');
    '2' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice2.wav');
    '3' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice3.wav');
    '4' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice4.wav');
    '5' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice5.wav');
    '6' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice6.wav');
    '7' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice7.wav');
    '8' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice8.wav');
    '9' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\Choice9.wav');
    '#' : Apax1.TapiPlayWaveFile(ExampleWavDir + '\beep.wav');
    '*' : begin
            Apax1.TapiPlayWaveFile(ExampleWavDir + '\goodbye.wav');
            HangupPending := True;
          end;
  end;
  edtReceivedDTMF.Text := edtReceivedDTMF.Text + Char(Digit);
end;

procedure TForm1.Apax1TapiWaveNotify(Sender: TObject; Msg: TOleEnum);
begin
  if (Msg = waPlayDone) then
    if HangupPending then begin
      Apax1.Close;
      HangupPending := False;
    end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Apax1.Visible := False;

  { get directory containing example wav files }
  ChDir(ExtractFilePath(ParamStr(0)));  // should be examples\delphi
  ChDir('..');                          // should be examples
  GetDir(0, ExampleWavDir);
end;

end.
