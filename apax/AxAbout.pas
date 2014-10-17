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

{******************************************************************}
{*                        AXABOUT.PAS 1.13                        *}
{******************************************************************}
{* AxAbout.PAS - About Box                                        *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ShellAPI;

type
  TApaxAbout = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    btnOK: TButton;
    Bevel1: TBevel;
    lblVersion: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    lblCopyright: TLabel;
    lblAPROVersion: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WebLblClick(Sender: TObject);
    procedure WebLblMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WebLblMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label9Click(Sender: TObject);
  end;

procedure ShowApaxAbout;

implementation

uses
  AxTerm, OOMisc;

{$R *.DFM}

procedure ShowApaxAbout;
begin
  with TApaxAbout.Create(nil) do
    try
      lblVersion.Caption := sApaxVersion;
      lblAPROVersion.Caption := 'Built with Async Professional ' + ApVersionStr;
      lblCopyright.Caption := FormatDateTime('"Copyright (c) 2000-"YYYY", TurboPower Software Company"', Now);
      ShowModal;
    finally
      Free;
    end;
end;

procedure TApaxAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TApaxAbout.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;
  lblVersion.Caption := 'Version ' + sApaxVersion;
end;

procedure TApaxAbout.WebLblClick(Sender: TObject);
var
  URL : Pchar;
begin
  URL := #0;
  StrPCopy(URL, TLabel(Sender).Caption);
  if ShellExecute(0, 'open', URL, '', '',
    SW_SHOWNORMAL) <= 32 then
    ShowMessage('Unable to start web browser');
  TLabel(Sender).Font.Color := clNavy;
end;

procedure TApaxAbout.WebLblMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin                                                    
  (Sender as TLabel).Left := (Sender as TLabel).Left - 1;
end;

procedure TApaxAbout.WebLblMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Left := (Sender as TLabel).Left + 1;
end;

procedure TApaxAbout.Label9Click(Sender: TObject);
begin
  if ShellExecute(0, 'open', 'http://www.mozilla.org/MPL/MPL-1.1.html', '', '',
    SW_SHOWNORMAL) <= 32 then
    ShowMessage('Unable to start web browser.');
  TLabel(Sender).Font.Color := clNavy;
end;

end.
