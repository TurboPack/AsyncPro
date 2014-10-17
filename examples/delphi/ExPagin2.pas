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

unit ExPagin2;

interface

uses
{$ifndef WIN32 }
  WinTypes, WinProcs,
{$else }
  Windows,
{$endif }
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OoMisc, AdPacket;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Panel3: TPanel;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Panel4: TPanel;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    ApdDataPacket1: TApdDataPacket;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Changed: Boolean;
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(Edit1.Text);
  OpenDialog1.FileName := ExtractFileName(Edit1.Text);
  if OpenDialog1.Execute then begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    Edit1.Text := OpenDialog1.FileName;
  end;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Changed := TRUE;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Changed := FALSE;
end;

end.
