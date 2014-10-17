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
unit FtpLoginFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFtpLoginForm = class(TForm)
    HostsList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    UserIdEdit: TEdit;
    PasswdEdit: TEdit;
    ConnectBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    FHostName     : String;
    FUserId       : String;
    FPasswd       : String;
    procedure ShowHosts;
  public
    property HostName  : String read FHostName write FHostName;
    property UserId    : String read FUserId write FUserID;
    property Passwd    : String read FPasswd write FPasswd;
  end;

var
  FtpLoginForm: TFtpLoginForm;

implementation

uses Registry, EmulatorFrm;

{$R *.DFM}

procedure TFtpLoginForm.ShowHosts;
var
    reg       : TRegistry;
    keys      : TStringList;
    bStat     : Boolean;
    connect   : String;
    i         : Integer;
    hostKey   : String;

begin
    reg := TRegistry.Create;
    keys := TStringList.Create;
    HostsList.Items.Clear;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        bStat := reg.OpenKey(HostsKey, False);
        if (bStat) then
        begin
            reg.GetKeyNames(keys);
            HostsList.Items.Assign(keys);
        end;
        reg.CloseKey;
        i := 0;
        while (i < HostsList.Items.Count) do
        begin
            hostKey := HostsKey + '\' + HostsList.Items.Strings[i];
            bStat := reg.OpenKey(hostKey, False);
            if (bStat) then
            begin
                connect := reg.ReadString('ConnectType');
                if (connect <> 'Telnet') then
                    HostsList.Items.Delete(i)
                else
                    Inc(i);
            end else
                HostsList.Items.Delete(i);
            reg.CloseKey;
        end;
    finally
        reg.Free;
        keys.Free;
    end;
end;

procedure TFtpLoginForm.FormShow(Sender: TObject);
begin
    ShowHosts;
    ActiveControl := UserIdEdit;
end;

procedure TFtpLoginForm.ConnectBtnClick(Sender: TObject);
begin
    if (HostsList.ItemIndex = -1) then
    begin
        HostsList.SetFocus;
        raise Exception.Create('Please select a host from the list.');
    end;
    FHostName := HostsList.Items.Strings[HostsList.ItemIndex];
    FUserId := TrimLeft(TrimRight(UserIdEdit.Text));
    if (FuserId = '') then
    begin
        UserIdEdit.SetFocus;
        raise Exception.Create('This field must have a value.');
    end;
    FPasswd := TrimLeft(TrimRight(PasswdEdit.Text));
    ModalResult := mrOk;
end;

procedure TFtpLoginForm.HelpBtnClick(Sender: TObject);
begin
    Application.HelpContext(69);
end;

end.
