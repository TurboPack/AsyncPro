unit ExWsScn1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, StdCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtFromPort: TEdit;
    edtToPort: TEdit;
    btnScan: TButton;
    Label3: TLabel;
    edtWinsockAddress: TEdit;
    ListBox1: TListBox;
    Label4: TLabel;
    Apax1: TApax;
    procedure btnScanClick(Sender: TObject);
    procedure Apax1WinsockConnect(Sender: TObject);
    procedure Apax1WinsockDisconnect(Sender: TObject);
    procedure Apax1WinsockError(Sender: TObject; ErrCode: Integer);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure DoNextPort(Port : Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  FromPort : Integer;
  ToPort   : Integer;
  CurrentPort : Integer;

procedure TForm1.btnScanClick(Sender: TObject);
begin
  Apax1.WinsockAddress := edtWinsockAddress.Text;
  FromPort := StrToInt(edtFromPort.Text);
  ToPort   := StrToInt(edtToPort.Text);
  DoNextPort(FromPort);
end;

procedure TForm1.DoNextPort(Port : Integer);
begin
  CurrentPort := Port;
  Apax1.WinsockPort := IntToStr(Port);
  Caption := 'Scanning port ' + Apax1.WinsockPort;
  Apax1.WinsockConnect;
end;

procedure TForm1.Apax1WinsockConnect(Sender: TObject);
begin
  ListBox1.Items.Add(Apax1.WinsockPort);
  Apax1.Close;
end;

procedure TForm1.Apax1WinsockDisconnect(Sender: TObject);
begin
  if (CurrentPort < ToPort) then
    DoNextPort(CurrentPort + 1)
  else
    Caption := 'Done';
end;

procedure TForm1.Apax1WinsockError(Sender: TObject; ErrCode: Integer);
begin
  Apax1.Close;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  ListBox1.Clear;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Apax1.Visible := False;
end;

end.
