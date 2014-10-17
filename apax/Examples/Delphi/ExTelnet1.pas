unit ExTelnet1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, OleCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    btnConnect: TButton;
    btnDisconnect: TButton;
    edtAddress: TEdit;
    Label1: TLabel;
    Apax1: TApax;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure Apax1WinsockConnect(Sender: TObject);
    procedure Apax1WinsockDisconnect(Sender: TObject);
    procedure Apax1WinsockError(Sender: TObject; ErrCode: Integer);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  Apax1.WinsockAddress := edtAddress.Text;
  Apax1.WinsockConnect;
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  Apax1.Close;
end;

procedure TForm1.Apax1WinsockConnect(Sender: TObject);
begin
  Caption := 'Connected';
  Apax1.TerminalSetFocus;
end;

procedure TForm1.Apax1WinsockDisconnect(Sender: TObject);
begin
  Caption := 'ExTelnet - Telnet Client';
end;

procedure TForm1.Apax1WinsockError(Sender: TObject; ErrCode: Integer);
begin
  Caption := IntToStr(ErrCode);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  edtAddress.Text := Apax1.WinsockAddress;
end;

end.
