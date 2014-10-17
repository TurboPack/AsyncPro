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
unit YZmodemFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdProtcl;

type
  TYZmodemForm = class(TForm)
    Label1: TLabel;
    FileNameEdit: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    FFileName : String;
    FProtocol : TProtocolType;
  public
    property FileName : String read FFileName write FFileName;
    property Protocol : TProtocolType read FProtocol write FProtocol;
  end;

var
  YZmodemForm: TYZmodemForm;

implementation

{$R *.DFM}

procedure TYZmodemForm.FormShow(Sender: TObject);
begin
    case FProtocol of
      ptYmodem:    Caption := 'Ymodem Send';
      ptZmodem:    Caption := 'Zmodem Send';
      ptKermit:    Caption := 'Kermit Send';
      else         Caption := '';
    end;
    ActiveControl := FileNameEdit;
end;

procedure TYZmodemForm.OkBtnClick(Sender: TObject);
var
    sr      : TSearchRec;
    stat    : Integer;

begin
    FFileName := Trim(FileNameEdit.Text);
    if (FFileName = '') then
    begin
        FileNameEdit.SetFocus;
        raise Exception.Create('This field must have a value.');
    end;
    try
        stat := FindFirst(FFileName, faAnyFile, sr);
        if (stat <> 0) then
        begin
            FileNameEdit.SetFocus;
            raise Exception.Create('This file does not exist.');
        end;
    finally
        FindClose(sr);
    end;
    ModalResult := mrOk;
end;

procedure TYZmodemForm.HelpBtnClick(Sender: TObject);
begin
    case FProtocol of
      ptYmodem:    Application.HelpContext(59);
      ptZmodem:    Application.HelpContext(60);
      ptKermit:    Application.HelpContext(61);
    end;
end;

end.


