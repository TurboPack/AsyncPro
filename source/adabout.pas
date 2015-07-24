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
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADABOUT.PAS 4.06                    *}
{*********************************************************}
{* The APRO About dialog, design-time only               *)
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F-,V-,P-,T-,B-}

unit AdAbout;
{- component about box}
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  OoMisc,
  ShellAPI;

type
  TApdAboutForm = class(TForm)
    Panel1: TPanel;
    Bevel2: TBevel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Button1: TButton;
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
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label9Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
  end;

var
  ApdAboutForm: TApdAboutForm;

implementation

{$R *.DFM}

procedure TApdAboutForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TApdAboutForm.FormCreate(Sender: TObject);
begin
  Label2.Caption := ApVersionStr;
  Label11.Caption := FormatDateTime('"Copyright (c) 1991-"YYYY", TurboPower Software Company"', Now);
end;

procedure TApdAboutForm.Label6Click(Sender: TObject);
begin
  if ShellExecute(0, 'open', 'http://www.aprozilla.com', '', '', SW_SHOWNORMAL) <= 32 then
   ShowMessage('Unable to start web browser. Make sure you have it properly set-up on your system.');
end;

procedure TApdAboutForm.Label5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Left := (Sender as TLabel).Left + 1;
end;

procedure TApdAboutForm.Label5MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Left := (Sender as TLabel).Left - 1;
end;

procedure TApdAboutForm.Label9Click(Sender: TObject);
begin
  if ShellExecute(0, 'open', 'http://www.mozilla.org/MPL/MPL-1.1.html', '', '', SW_SHOWNORMAL) <= 32 then
    ShowMessage('Unable to start web browser. Make sure you have it properly set-up on your system.');
end;

procedure TApdAboutForm.Label13Click(Sender: TObject);
begin
  if ShellExecute(0, 'open', 'http://sourceforge.net/projects/tpapro/', '', '', SW_SHOWNORMAL) <= 32 then
    ShowMessage('Unable to start web browser. Make sure you have it properly set-up on your system.');
end;

procedure TApdAboutForm.Label7Click(Sender: TObject);
begin
if ShellExecute(0, 'open', 'http://sourceforge.net/forum/?group_id=71007', '', '', SW_SHOWNORMAL) <= 32 then
    ShowMessage('Unable to start web browser. Make sure you have it properly set-up on your system.');
end;

end.
