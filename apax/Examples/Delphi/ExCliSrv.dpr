program ExCliSrv;

uses
  Forms,
  ExCliSr1 in 'ExCliSr1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
