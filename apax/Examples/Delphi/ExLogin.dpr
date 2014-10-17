program ExLogin;

uses
  Forms,
  ExLogin1 in 'ExLogin1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
