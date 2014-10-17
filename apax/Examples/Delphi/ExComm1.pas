unit ExComm1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtPortNumber: TEdit;
    btnOpen: TButton;
    btnClose: TButton;
    GroupBox2: TGroupBox;
    edtPut: TEdit;
    btnPutString: TButton;
    btnPutStringCRLF: TButton;
    btnPutData: TButton;
    Label2: TLabel;
    lbxOnRXD: TListBox;
    Apax1: TApax;
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnPutStringClick(Sender: TObject);
    procedure btnPutStringCRLFClick(Sender: TObject);
    procedure btnPutDataClick(Sender: TObject);
    procedure Apax1RXD(Sender: TObject; Data: OleVariant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.btnOpenClick(Sender: TObject);
begin
  Apax1.ComNumber := StrToIntDef(edtPortNumber.Text, 0);
  Apax1.PortOpen;
  edtPortNumber.Text := IntToStr(Apax1.ComNumber);
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Apax1.Close;
end;

procedure TForm1.btnPutStringClick(Sender: TObject);
begin
  Apax1.PutString(edtPut.Text);
end;

procedure TForm1.btnPutStringCRLFClick(Sender: TObject);
begin
  Apax1.PutStringCRLF(edtPut.Text);
end;

procedure TForm1.btnPutDataClick(Sender: TObject);
var
  Data : OleVariant;
  S : string;
  i : Integer;
begin
  S := edtPut.Text;
  Data := VarArrayCreate([1, Length(S)], varByte);
  for i := 1 to Length(S) do
    Data[i] := Ord(S[i]);
  Apax1.PutData(Data);
end;

procedure TForm1.Apax1RXD(Sender: TObject; Data: OleVariant);
var
  i : Integer;
  S : string;
begin
  if VarIsArray(Data) then begin
    S := '';
    for i := VarArrayLowBound(Data, 1) to VarArrayHighBound(Data, 1) do
      S := S + ' $' + IntToHex(Data[i], 2);
    lbxOnRXD.Items.Add(S);
  end;
end;

end.
