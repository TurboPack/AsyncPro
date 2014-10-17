(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   EXFPRN10.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{*     Prints an Async Professional Fax (APF) file.      *}
{*********************************************************}

unit EXFPRN10;

interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  AdFaxPrn,
  AdFPStat, OoMisc;

type
  TForm1 = class(TForm)
    fnLabel: TLabel;
    ApdFaxPrinter1: TApdFaxPrinter;
    ApdFaxPrinterStatus1: TApdFaxPrinterStatus;
    FileNameEdit: TEdit;
    FileNameButton: TButton;
    OpenDialog1: TOpenDialog;
    PrintButton: TButton;
    ExitButton: TButton;
    procedure FileNameButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FileNameButtonClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'APF Files (*.APF)|*.APF';
  if OpenDialog1.Execute then
    FileNameEdit.Text := OpenDialog1.FileName;
end;

procedure TForm1.PrintButtonClick(Sender: TObject);
begin
  try
    ApdFaxPrinter1.FileName := FileNameEdit.Text;
    ApdFaxPrinter1.PrintFax;
  finally
  end;
end;

procedure TForm1.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

end.
