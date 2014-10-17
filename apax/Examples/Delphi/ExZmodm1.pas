unit ExZmodm1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, StdCtrls, ExtCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtTapiNumber: TEdit;
    OpenDialog1: TOpenDialog;
    Apax1: TApax;
    procedure Apax1TapiConnect(Sender: TObject);
    procedure Apax1TapiPortClose(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Apax1TapiGetNumber(Sender: TObject;
      var PhoneNum: WideString);
    procedure Apax1SendButtonClick(Sender: TObject; var Default: WordBool);
    procedure Apax1ReceiveButtonClick(Sender: TObject;
      var Default: WordBool);
    procedure Apax1ProtocolFinish(Sender: TObject; ErrorCode: Integer);
    procedure Apax1ProtocolAccept(Sender: TObject; var Accept: WordBool;
      var FName: WideString);
    procedure Apax1ListenButtonClick(Sender: TObject;
      var Default: WordBool);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.FormActivate(Sender: TObject);
begin
  edtTapiNumber.Text := Apax1.TapiNumber;
end;

procedure TForm1.Apax1TapiConnect(Sender: TObject);
begin
  Caption := 'Connected';
  Apax1.ShowProtocolButtons := True;
end;

procedure TForm1.Apax1TapiPortClose(Sender: TObject);
begin
  Apax1.ShowProtocolButtons := False;
  Caption := 'ExZmodem - File Transfer Sender/Receiver';
end;

procedure TForm1.Apax1TapiGetNumber(Sender: TObject;
  var PhoneNum: WideString);
begin
  PhoneNum := edtTapiNumber.Text;
end;

procedure TForm1.Apax1SendButtonClick(Sender: TObject;
  var Default: WordBool);
begin
  Default := False;
  if OpenDialog1.Execute then begin
    Apax1.SendFileName := OpenDialog1.FileName;
    Apax1.TerminalActive := False;
    Apax1.TerminalWriteString('sending ' + OpenDialog1.FileName);
    Apax1.StartTransmit;
  end;
end;

procedure TForm1.Apax1ReceiveButtonClick(Sender: TObject;
  var Default: WordBool);
begin
  Apax1.TerminalActive := False;
  Default := True;
end;

procedure TForm1.Apax1ProtocolFinish(Sender: TObject; ErrorCode: Integer);
begin
  if (ErrorCode = 0) then
    Apax1.TerminalWriteStringCRLF(' - Ok')
  else
    Apax1.TerminalWriteStringCRLF(' - Error ' + IntToStr(ErrorCode));
  Apax1.TerminalActive := True;
end;

procedure TForm1.Apax1ProtocolAccept(Sender: TObject; var Accept: WordBool;
  var FName: WideString);
begin
  Apax1.TerminalWriteString('receiving ' + FName);
  Accept := True;
end;

procedure TForm1.Apax1ListenButtonClick(Sender: TObject;
  var Default: WordBool);
begin
  Default := True;
  Caption := 'Ready to answer incoming calls';
end;

end.
