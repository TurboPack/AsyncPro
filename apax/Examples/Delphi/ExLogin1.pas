unit ExLogin1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, ExtCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    btnConnect: TButton;
    btnDisconnect: TButton;
    edtAddress: TEdit;
    Label1: TLabel;
    edtLoginName: TEdit;
    Label2: TLabel;
    edtPassword: TEdit;
    Label3: TLabel;
    Apax1: TApax;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure Apax1DataTrigger(Sender: TObject; Index: Integer;
      Timeout: WordBool; Data: OleVariant; Size: Integer;
      var ReEnable: WordBool);
    procedure Apax1WinsockConnect(Sender: TObject);
    procedure Apax1WinsockDisconnect(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  Apax1.EnableDataTrigger(0);
  Apax1.EnableDataTrigger(1);
  Apax1.EnableDataTrigger(2);
  Apax1.WinsockConnect;
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  Apax1.Close;
end;

procedure TForm1.Apax1DataTrigger(Sender: TObject; Index: Integer;
  Timeout: WordBool; Data: OleVariant; Size: Integer;
  var ReEnable: WordBool);
begin
  ReEnable := False;
  case Index of
    0 : if not Timeout then
          Apax1.PutStringCRLF(edtLoginName.Text)
        else
          ShowMessage('Timed out waiting for login prompt');

    1 : if not Timeout then
          Apax1.PutStringCRLF(edtPassword.Text)
        else
          ShowMessage('Timed out waiting for password prompt');

    2 : if not Timeout then begin
          Caption := 'Logged in';
          Apax1.TerminalSetFocus;
        end else
          ShowMessage('Timed out waiting for password verification');
  end;
end;

procedure TForm1.Apax1WinsockConnect(Sender: TObject);
begin
  Caption := 'Connected';
end;

procedure TForm1.Apax1WinsockDisconnect(Sender: TObject);
begin
  Caption := 'ExLogin - Automated Telnet Login';
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Apax1.AddDataTrigger('login:', 0, 0, True, True);
  Apax1.AddDataTrigger('password:', 0, 36, True, True);
  Apax1.AddDataTrigger('$', 0, 0, True, True);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Apax1.RemoveDataTrigger(2);
  Apax1.RemoveDataTrigger(1);
  Apax1.RemoveDataTrigger(0);
end;

end.
