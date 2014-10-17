unit ExCliSr1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, OleCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtAddress: TEdit;
    Label2: TLabel;
    edtPort: TEdit;
    OpenDialog1: TOpenDialog;
    Apax1: TApax;
    procedure Apax1WinsockConnect(Sender: TObject);
    procedure Apax1WinsockDisconnect(Sender: TObject);
    procedure Apax1WinsockError(Sender: TObject; ErrCode: Integer);
    procedure FormActivate(Sender: TObject);
    procedure Apax1WinsockAccept(Sender: TObject; const Addr: WideString;
      var Accept: WordBool);
    procedure Apax1WinsockGetAddress(Sender: TObject; var Address,
      Port: WideString);
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
  edtAddress.Text := Apax1.WinsockAddress;
  edtPort.Text    := Apax1.WinsockPort;
end;

procedure TForm1.Apax1WinsockConnect(Sender: TObject);
begin
  Caption := 'Connected - ' + Apax1.WinsockAddress;
  Apax1.ShowProtocolButtons := True;
  Apax1.TerminalSetFocus;
end;

procedure TForm1.Apax1WinsockDisconnect(Sender: TObject);
begin
  Apax1.ShowProtocolButtons := False;
  Caption := 'ExCliSrv - Winsock Client/Server';
end;

procedure TForm1.Apax1WinsockError(Sender: TObject; ErrCode: Integer);
begin
  Caption := IntToStr(ErrCode);
end;

procedure TForm1.Apax1WinsockAccept(Sender: TObject;
  const Addr: WideString; var Accept: WordBool);
begin
  Caption := 'Connected - ' + Addr;
  Apax1.ShowProtocolButtons := True;
  Apax1.TerminalSetFocus;
end;

procedure TForm1.Apax1WinsockGetAddress(Sender: TObject; var Address,
  Port: WideString);
begin
  Address := edtAddress.Text;
  Port := edtPort.Text;
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
  Caption := 'Listening for connection on port: ' + Apax1.WinsockPort;
end;

end.
