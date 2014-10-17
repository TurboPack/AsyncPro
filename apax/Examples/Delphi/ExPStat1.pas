unit ExPStat1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, StdCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    btnDial: TButton;
    edtDial: TEdit;
    btnSend: TButton;
    OpenDialog1: TOpenDialog;
    btnHangup: TButton;
    cbxProtocol: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblFileName: TLabel;
    lblBytesTransferred: TLabel;
    lblBytesRemaining: TLabel;
    Apax1: TApax;
    procedure btnDialClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnHangupClick(Sender: TObject);
    procedure Apax1TapiConnect(Sender: TObject);
    procedure Apax1TapiPortClose(Sender: TObject);
    procedure Apax1ProtocolFinish(Sender: TObject; ErrorCode: Integer);
    procedure FormActivate(Sender: TObject);
    procedure Apax1ProtocolStatus(Sender: TObject; Options: Integer);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnDialClick(Sender: TObject);
begin
  Apax1.TapiNumber := edtDial.Text;
  Apax1.TapiDial;
end;

procedure TForm1.btnSendClick(Sender: TObject);
begin
  OpenDialog1.FileName := Apax1.SendFileName;
  if OpenDialog1.Execute then begin
    Apax1.SendFileName := OpenDialog1.FileName;
    Apax1.Protocol := cbxProtocol.ItemIndex;
    Apax1.StartTransmit;
  end;
end;

procedure TForm1.btnHangupClick(Sender: TObject);
begin
  Apax1.Close;
end;

procedure TForm1.Apax1TapiConnect(Sender: TObject);
begin
  Caption := 'Connected';
  btnSend.Enabled := True;
end;

procedure TForm1.Apax1TapiPortClose(Sender: TObject);
begin
  Caption := 'ExPStat - File Transfer Sender with Status';
  btnSend.Enabled := False;
end;

procedure TForm1.Apax1ProtocolFinish(Sender: TObject; ErrorCode: Integer);
begin
  if (ErrorCode = 0) then
    Apax1.TerminalWriteStringCRLF(Apax1.SendFileName + ' sent.')
  else
    Apax1.TerminalWriteStringCRLF(Apax1.SendFileName + ' protocol error - ' + IntToStr(ErrorCode));
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  cbxProtocol.ItemIndex := Apax1.Protocol;
  edtDial.Text := Apax1.TapiNumber;
  Apax1.TerminalActive := False;  { disable terminal capturing file data }
end;

procedure TForm1.Apax1ProtocolStatus(Sender: TObject; Options: Integer);
begin
  if (Options <> 1) and (Options <> 2) then begin
    lblFileName.Caption := Apax1.SendFileName;
    lblBytesTransferred.Caption := IntToStr(Apax1.BytesTransferred);
    lblBytesRemaining.Caption := IntToStr(Apax1.BytesRemaining);
  end;
end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
  Apax1.CancelProtocol;
end;

end.
