unit ExRecv1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    btnStart: TButton;
    btnStop: TButton;
    cbxProtocol: TComboBox;
    Label1: TLabel;
    Apax1: TApax;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure Apax1TapiConnect(Sender: TObject);
    procedure Apax1ProtocolAccept(Sender: TObject; var Accept: WordBool;
      var FName: WideString);
    procedure Apax1ProtocolFinish(Sender: TObject; ErrorCode: Integer);
    procedure FormActivate(Sender: TObject);
    procedure Apax1TapiPortClose(Sender: TObject);
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
  RcvFileName : string;


procedure TForm1.btnStartClick(Sender: TObject);
begin
  Apax1.Protocol := cbxProtocol.ItemIndex;
  Apax1.TapiAnswer;
  Caption := 'Ready';
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  Apax1.Close;
  Caption := 'ExRecv - File Transfer Receiver';
end;

procedure TForm1.Apax1TapiConnect(Sender: TObject);
begin
  Apax1.StartReceive;
end;

procedure TForm1.Apax1ProtocolAccept(Sender: TObject; var Accept: WordBool;
  var FName: WideString);
begin
  RcvFileName := FName;
  Caption := 'Receiving ' + FName;
  Accept := True;
end;

procedure TForm1.Apax1ProtocolFinish(Sender: TObject; ErrorCode: Integer);
begin
  if (ErrorCode = 0) then begin
    Apax1.TerminalWriteStringCRLF(RcvFileName + ' received.');
    Apax1.StartReceive;
  end else
    Apax1.TerminalWriteStringCRLF('Protocol error - receiving ' + RcvFileName);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  cbxProtocol.ItemIndex := Apax1.Protocol;
  Apax1.TerminalActive := False;  { disable terminal displaying file data }
end;

procedure TForm1.Apax1TapiPortClose(Sender: TObject);
begin
  Caption := 'ExRecv - File Transfer Receiver';
end;

end.
