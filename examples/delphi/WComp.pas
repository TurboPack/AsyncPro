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

unit Wcomp;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TWhitespaceCompForm = class(TForm)
    CompEnabledBox: TCheckBox;
    FromEdit: TEdit;
    Label1: TLabel;
    ToEdit: TEdit;
    Label2: TLabel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    procedure CompEnabledBoxClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WhitespaceCompForm: TWhitespaceCompForm;

implementation

{$R *.DFM}

procedure TWhitespaceCompForm.CompEnabledBoxClick(Sender: TObject);
begin
  FromEdit.Enabled := CompEnabledBox.Checked;
  ToEdit.Enabled   := CompEnabledBox.Checked;
end;

procedure TWhitespaceCompForm.OkBtnClick(Sender: TObject);
begin
  ModalResult := mrNone;

  if CompEnabledBox.Checked then begin
    try
      StrToInt(FromEdit.Text);
    except
      MessageDlg('You must enter a number here.', mtError, [mbOK], 0);
      FromEdit.SetFocus;
      Exit;
    end;

    try
      StrToInt(ToEdit.Text);
    except
      MessageDlg('You must enter a number here.', mtError, [mbOK], 0);
      ToEdit.SetFocus;
      Exit;
    end;
  end;

  ModalResult := mrOK;
end;

end.

