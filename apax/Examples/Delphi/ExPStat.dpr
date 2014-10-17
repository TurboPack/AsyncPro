program ExPStat;

uses
  Forms,
  ExPStat1 in 'ExPStat1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
