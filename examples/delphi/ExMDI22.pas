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
{*                   EXMDI22.PAS 4.06                    *}
{*********************************************************}

unit Exmdi22;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdTrmEmu, EXMDI20;

type
  TForm3 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    AdTerminal1 : TAdTerminal;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.FormCreate(Sender: TObject);
begin
  {Create the terminal window on the fly...}
  AdTerminal1 := TAdTerminal.Create(Parent);
  AdTerminal1.Parent := Self;
  AdTerminal1.Active := False;
  AdTerminal1.Align := alClient;

  {...hook it up to the comport on Form1 and show it}
  AdTerminal1.ComPort := Form1.ComPort1;
  AdTerminal1.Active := True;
  Show;
end;

end.
