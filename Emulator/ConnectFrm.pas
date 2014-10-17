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
unit ConnectFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TConnectForm = class(TForm)
    HostsList: TListBox;
    ConnectBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure HostsListDblClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    FHostName : String;
    procedure ShowHosts;
  public
    property HostName : String read FHostName;
  end;

var
  ConnectForm: TConnectForm;

implementation

uses EmulatorFrm, Registry;

{$R *.DFM}

procedure TConnectForm.ShowHosts;
var
    reg       : TRegistry;
    keys      : TStringList;
    bStat     : Boolean;

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
    finally
        reg.Free;
        keys.Free;
    end;
end;

procedure TConnectForm.FormShow(Sender: TObject);
begin
    ShowHosts;
end;

procedure TConnectForm.ConnectBtnClick(Sender: TObject);
begin
    if (HostsList.ItemIndex = -1) then
        raise Exception.Create('Please select a host from the list.');
    FHostName := HostsList.Items.Strings[HostsList.ItemIndex];
    ModalResult := mrOk;
end;

procedure TConnectForm.HostsListDblClick(Sender: TObject);
begin
    ConnectBtnClick(ConnectBtn);
end;

procedure TConnectForm.HelpBtnClick(Sender: TObject);
begin
    Application.HelpContext(74);
end;

end.
