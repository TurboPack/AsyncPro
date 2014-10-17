program ExWsScan;

uses
  Forms,
  ExWsScn1 in 'ExWsScn1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
