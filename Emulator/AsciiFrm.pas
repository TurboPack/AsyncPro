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
 * The Original Code is LNS Software Systems
 *
 * The Initial Developer of the Original Code is LNS Software Systems
 *
 * Portions created by the Initial Developer are Copyright (C) 1998-2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)
unit AsciiFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdProtcl, StdCtrls, ExtCtrls;

type
  TAsciiForm = class(TForm)
    Label1: TLabel;
    FileNameEdit: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    XlateBtn: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    FFileName    : String;
    FSendRecv    : Char;
  public
    property FileName : String read FFileName write FFileName;
    property SendRecv : Char read FSendRecv write FSendRecv;
  end;

var
  AsciiForm: TAsciiForm;

implementation

{$R *.DFM}

procedure TAsciiForm.FormShow(Sender: TObject);
begin
    if (FSendRecv = 'S') then
        Caption := 'Send ASCII'
    else
        Caption := 'Receive ASCII';
    ActiveControl := FileNameEdit;
end;

procedure TAsciiForm.OkBtnClick(Sender: TObject);
begin
    FFileName := TrimLeft(TrimRight(FileNameEdit.Text));
    if (FFileName = '') then
    begin
        FileNameEdit.SetFocus;
        raise Exception.Create('This field must have a value.');
    end;
    if (FSendRecv = 'S') then
    begin
        if (not FileExists(FFileName)) then
        begin
            FileNameEdit.SetFocus;
            raise Exception.Create('This file does not exist.');
        end;
    end;
    ModalResult := mrOk;
end;

procedure TAsciiForm.HelpBtnClick(Sender: TObject);
begin
    if (FSendRecv = 'S') then
        Application.HelpContext(62)
    else
        Application.HelpContext(68);
end;

end.
