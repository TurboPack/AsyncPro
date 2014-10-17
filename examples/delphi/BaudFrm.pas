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

{$G+,X+,F+}

{Conditional defines that may affect this unit}
{$I AWDEFINE.INC}

{*********************************************************}
{*                     BAUDFRM.PAS                       *}
{*********************************************************}

unit Baudfrm;

interface

uses
  SysUtils,
  WinTypes,
  WinProcs,
  Classes,
  Graphics,
  Forms,
  Controls,
  Buttons,
  StdCtrls,
  ooMisc,
  AdModDB;

type
  TBaudForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    BPSEdit: TEdit;
    LockDTECheck: TCheckBox;
    GroupBox1: TGroupBox;

    procedure OKBtnClick(Sender: TObject);
  public
    EditData : PModemInfo;
    constructor Create2(AOwner : TComponent; var Data : TModemInfo);
  end;

var
  BaudForm: TBaudForm;

implementation

{$R *.DFM}

constructor TBaudForm.Create2(AOwner : TComponent; var Data : TModemInfo);
begin
  inherited Create(AOwner);

  EditData := @Data;

  {set initial edit values}
  if (EditData^.DefBaud <> 0) then
    BPSEdit.Text := IntToStr(EditData^.DefBaud);
  LockDTECheck.Checked := EditData^.LockDTE;
end;

procedure TBaudForm.OKBtnClick(Sender: TObject);
var
  E : Integer;
  L : LongInt;

begin
  {make sure that a baud rate was entered}
  if (BPSEdit.Text = '') then begin
    BPSEdit.SetFocus;
    ModalResult := mrNone;
    raise Exception.Create('Please enter a BPS rate');
  end;

  {make sure that the baud rate entered was, in fact, a number}
  Val(BPSEdit.Text, L, E);
  if (E <> 0) then begin
    BPSEdit.SetFocus;
    ModalResult := mrNone;
    raise Exception.Create('Invalid BPS rate');
  end;

  {make sure that the baud rate entered was in range}
  if (L < 300) or (L > 57600) then begin
    BPSEdit.SetFocus;
    ModalResult := mrNone;
    raise Exception.Create('Valid values are between 300 and 57600');
  end;

  EditData^.DefBaud := L;
  EditData^.LockDTE := LockDTECheck.Checked;
  ModalResult := mrOK;
end;

end.
