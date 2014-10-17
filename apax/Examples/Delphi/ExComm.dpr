program ExComm;

uses
  Forms,
  ExComm1 in 'ExComm1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
