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
unit XmodemFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AdProtcl;

type
  TXmodemForm = class(TForm)
    Label1: TLabel;
    FileNameEdit: TEdit;
    ProtocolBtn: TRadioGroup;
    OkBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    procedure OkBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    FSendRecv   : Char;
    FFileName   : String;
    FProtocol   : TProtocolType;
  public
    property  SendRecv : Char read FSendRecv write FSendRecv;
    property  FileName : String read FFileName write FFileName;
    property  Protocol : TProtocolType read FProtocol write FProtocol;
  end;

var
  XmodemForm: TXmodemForm;

implementation

{$R *.DFM}

procedure TXmodemForm.OkBtnClick(Sender: TObject);
begin
    FFileName := TrimLeft(TrimRight(FileNameEdit.Text));
    if (FFileName = '') then
    begin
        FileNameEdit.SetFocus;
        raise Exception.Create('This field must have a value.');
    end;
    if ((FSendRecv = 'S') and (not FileExists(FFileName))) then
    begin
        FileNameEdit.SetFocus;
        raise Exception.Create('This file does not exist.');
    end;
    case ProtocolBtn.ItemIndex of
      0:      FProtocol := ptXmodem;
      1:      FProtocol := ptXmodemCRC;
      2:      FProtocol := ptXmodem1K;
      else
      begin
        ProtocolBtn.SetFocus;
        raise Exception.Create('Please choose a protocol.');
      end;
    end;

    ModalResult := mrOk;
end;

procedure TXmodemForm.FormShow(Sender: TObject);
begin
   if (FSendRecv = 'S') then
       Caption := 'Xmodem Send'
   else
       Caption := 'Xmodem Receive';
   case FProtocol of
     ptXmodem:      ProtocolBtn.ItemIndex := 0;
     ptXmodemCRC:   ProtocolBtn.ItemIndex := 1;
     ptXModem1K:    ProtocolBtn.ItemIndex := 2;
     else           ProtocolBtn.ItemIndex := -1;
   end;
   FileNameEdit.Text := FFileName;
   ActiveControl := FileNameEdit;
end;

procedure TXmodemForm.HelpBtnClick(Sender: TObject);
begin
    if (FSendRecv = 'S') then
        Application.HelpContext(58)
    else
        Application.HelpContext(64);
end;

end.
