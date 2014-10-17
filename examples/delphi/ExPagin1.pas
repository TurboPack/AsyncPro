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

unit ExPagin1;

interface

uses
{$ifndef WIN32 }
  WinTypes, WinProcs,
{$else }
  Windows,
{$endif }
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TForm2 = class(TForm)
    Label3: TLabel;
    Label2: TLabel;
    edPagerAddr: TEdit;
    edPagerID: TEdit;
    Label1: TLabel;
    edName: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    RadioGroup1: TRadioGroup;
    Label4: TLabel;
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SetAddrCaption;
    { Private declarations }
  public
    { Public declarations }
    procedure ClearEds;
  end;

var
  Form2: TForm2;

implementation



{$R *.DFM}

{ TForm2 }

procedure TForm2.ClearEds;
begin
  edName.Text := '';
  edPagerAddr.Text := '';
  edPagerID.Text := '';
end;

procedure TForm2.RadioGroup1Click(Sender: TObject);
begin
  SetAddrCaption;
end;

procedure TForm2.SetAddrCaption;
begin
  Label3.Visible := FALSE;
  Label4.Visible := FALSE;

  case RadioGroup1.ItemIndex of
    0:Label3.Visible := TRUE;
    1:Label4.Visible := TRUE;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  SetAddrCaption;
end;

end.
 
