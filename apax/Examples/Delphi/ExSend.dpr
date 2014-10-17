program ExSend;

uses
  Forms,
  ExSend1 in 'ExSend1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
