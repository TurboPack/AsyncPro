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
unit HostsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  THostsForm = class(TForm)
    HostsList: TListBox;
    NewBtn: TButton;
    EditBtn: TButton;
    DeleteBtn: TButton;
    CloseBtn: TButton;
    HelpBtn: TButton;
    procedure Button1Click(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HostsListDblClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    procedure SaveHost;
    procedure DeleteHost;
    procedure ShowHosts;
  public
    { Public declarations }
  end;

var
  HostsForm: THostsForm;

implementation

uses EmulatorFrm, HostsEditFrm, Registry;

{$R *.DFM}

procedure THostsForm.SaveHost;
var
    reg      : TRegistry;
    bStat    : Boolean;
    hostKey  : String;

begin
    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        hostKey := HostsKey + '\' + HostsEditForm.HostName;
        bStat := reg.OpenKey(hostKey, True);
        if (not bStat) then
            raise Exception.CreateFmt('Could not open registry key for host %s.',
                                      [HostsEditForm.HostName]);
        reg.WriteString('IPAddress', HostsEditForm.IPAddress);
        reg.WriteInteger('TCPPort', HostsEditForm.TCPPort);
        reg.WriteString('SerialDevice', HostsEditForm.SerialDevice);
        reg.WriteInteger('LineSpeed', HostsEditForm.Baud);
        reg.WriteInteger('DataBits', HostsEditForm.DataBits);
        reg.WriteString('Parity', HostsEditForm.Parity);
        reg.WriteInteger('StopBits', HostsEditForm.StopBits);
        if (HostsEditForm.ConnectType = 'T') then
            reg.WriteString('ConnectType', 'Telnet')
        else
            reg.WriteString('ConnectType', 'Serial');
        reg.WriteString('Phone', HostsEditForm.Phone);
    finally
        reg.Free;
    end;
end;

procedure THostsForm.DeleteHost;
var
    reg       : TRegistry;
    bStat     : Boolean;
    hostKey   : String;

begin
    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        hostKey := HostsKey + '\' + HostsList.Items.Strings[HostsList.ItemIndex];
        bStat := reg.OpenKey(hostKey, False);
        if (bStat) then
        begin
            reg.CloseKey;
            reg.DeleteKey(hostKey);
        end;
    finally
        reg.Free;
    end;
end;

procedure THostsForm.ShowHosts;
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

procedure THostsForm.Button1Click(Sender: TObject);
begin
    EmulatorForm.TapiDev.SelectDevice;
end;

procedure THostsForm.NewBtnClick(Sender: TObject);
var
    stat     : Integer;

begin
    with HostsEditForm do
    begin
        AcdFlag := 'A';
        HostName := '';
        IPAddress := '';
        TCPPort := 23;
        SerialDevice := '';
        Baud := 9600;
        DataBits := 8;
        Parity := 'None';
        StopBits := 1;
        ConnectType := 'T';
        Phone := '';
        stat := ShowModal;
        if (stat = mrOk) then
            SaveHost;
    end;
    ShowHosts;
end;

procedure THostsForm.EditBtnClick(Sender: TObject);
var
    reg     : TRegistry;
    bStat   : Boolean;
    hostKey : String;
    temp    : String;
    stat    : Integer;

begin
    if (HostsList.ItemIndex = -1) then
        raise Exception.Create('Please select a host from the list.');

    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        hostKey := HostsKey + '\' + HostsList.Items.Strings[HostsList.ItemIndex];
        bStat := reg.OpenKey(hostKey, False);
        if (not bStat) then
            raise Exception.CreateFmt('Internal error.  Could not open ' +
                                      'registry key for host %s.',
                                      [HostsList.Items.Strings[HostsList.ItemIndex]]);
        HostsEditForm.HostName := HostsList.Items.Strings[HostsList.ItemIndex];
        HostsEditForm.IPAddress := reg.ReadString('IPAddress');
        HostsEditForm.TCPPort := reg.ReadInteger('TCPPort');
        HostsEditForm.SerialDevice := reg.ReadString('SerialDevice');
        HostsEditForm.Baud := reg.ReadInteger('LineSpeed');
        HostsEditForm.DataBits := reg.ReadInteger('DataBits');
        HostsEditForm.Parity := reg.ReadString('Parity');
        HostsEditForm.StopBits := reg.ReadInteger('StopBits');
        temp := reg.ReadString('ConnectType');
        if (temp = 'Telnet') then
            HostsEditForm.ConnectType := 'T'
        else
            HostsEditForm.ConnectType := 'S';
        HostsEditForm.Phone := reg.ReadString('Phone');
    finally
        reg.Free;
    end;

    HostsEditForm.AcdFlag := 'C';
    stat := HostsEditForm.ShowModal;
    if (stat = mrOk) then
        SaveHost;
    ShowHosts;
end;

procedure THostsForm.DeleteBtnClick(Sender: TObject);
var
    stat     : Integer;

begin
    if (HostsList.ItemIndex = -1) then
        raise Exception.Create('Please select a host from the list.');

    stat := Application.MessageBox(PChar('Do you really want to delete host ' +
                                         HostsList.Items.Strings[HostsList.ItemIndex]),
                                   'Delete Host',
                                   MB_APPLMODAL or MB_ICONQUESTION or
                                   MB_YESNO);
    if (stat = IDYES) then
        DeleteHost;
    ShowHosts;
end;

procedure THostsForm.FormShow(Sender: TObject);
begin
    ShowHosts;
end;

procedure THostsForm.HostsListDblClick(Sender: TObject);
begin
    EditBtnClick(EditBtn);
end;

procedure THostsForm.HelpBtnClick(Sender: TObject);
begin
    Application.HelpContext(50);
end;

end.
