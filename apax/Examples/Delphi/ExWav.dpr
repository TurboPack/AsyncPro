program ExWav;

uses
  Forms,
  ExWav1 in 'ExWav1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
