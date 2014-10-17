program ExTapi;

uses
  Forms,
  ExTapi1 in 'ExTapi1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
