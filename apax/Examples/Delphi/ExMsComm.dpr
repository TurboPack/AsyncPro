program ExMsComm;

uses
  Forms,
  ExMSCom1 in 'ExMSCom1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
