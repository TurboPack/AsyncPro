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
{*                   EXVIEW0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{* Views an Async Professional Fax (APF) file.  See the  *}
(*   ViewFax project for a more inclusive example.       *)
{*********************************************************}

unit Exview0;

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdFView, OoMisc;

type
  TForm1 = class(TForm)
    ApdFaxViewer1: TApdFaxViewer;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  if OpenDialog1.Execute then
    ApdFaxViewer1.FileName := OpenDialog1.FileName
  else
    Halt(1);
end;

end.

