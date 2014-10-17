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
{*                   PERCENT.PAS 4.06                    *}
{*********************************************************}

{********************DESCRIPTION**************************}
{*  Demonstrates how to custom display scaling faxes.    *}
{*       Note: Works with CVT2FAX.DPR                    *}
{*********************************************************}

unit Percent;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TPercentForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    PercentEdit: TEdit;
    Bevel1: TBevel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PercentForm: TPercentForm;

implementation

{$R *.DFM}

procedure TPercentForm.OkBtnClick(Sender: TObject);
var
  Tmp : Integer;

begin
  ModalResult := mrNone;

  try
    Tmp := StrToInt(PercentEdit.Text);
    if (Tmp < 25) or (Tmp > 400) then begin
      MessageDlg('You must enter a percentage between 25 and 400.', mtError, [mbOK], 0);
      PercentEdit.SetFocus;
      Exit;
    end;
  except
    MessageDlg('You must enter a number here.', mtError, [mbOK], 0);
    PercentEdit.SetFocus;
    Exit;
  end;

  ModalResult := mrOK;
end;

end.

