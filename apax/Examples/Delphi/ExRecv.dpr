program ExRecv;

uses
  Forms,
  ExRecv1 in 'ExRecv1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
