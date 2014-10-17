{*********************************************************}
{*                  PATCH40.PAS 4.06                     *}
{*      Copyright (c) TurboPower Software 1998-2001      *}
{*                 All rights reserved.                  *}
{*********************************************************}

program Patch40;
  {- Patch a printer driver for use with Windows95 }

uses
  Forms,
  Patch401 in 'PATCH401.PAS' {Form1};

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
