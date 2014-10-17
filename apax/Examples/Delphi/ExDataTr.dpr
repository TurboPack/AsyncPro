program ExDataTr;

uses
  Forms,
  ExDataT1 in 'ExDataT1.pas' {Form1},
  ExDataT2 in 'ExDataT2.pas' {frmAddTrigger};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmAddTrigger, frmAddTrigger);
  Application.Run;
end.
