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
{*                   RASDEMOU.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{*  Demonstrates a RAS dialer.                           *}
{*********************************************************}

unit RasDemou;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, Buttons, ComCtrls,
  AdRas, AdRasUtl, OoMisc, AdRStat;

type
  TForm1 = class(TForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    PasswordEdit: TEdit;
    Label2: TLabel;
    UserNameEdit: TEdit;
    Label3: TLabel;
    DomainEdit: TEdit;
    Label4: TLabel;
    PhoneNumberEdit: TEdit;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Call1: TMenuItem;
    Dial1: TMenuItem;
    Hangup1: TMenuItem;
    Phonebook1: TMenuItem;
    NewPhonebookEntry: TMenuItem;
    EditPhonebookEntry: TMenuItem;
    N1: TMenuItem;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label5: TLabel;
    EntrySelect: TComboBox;
    PhoneBookEdit: TEdit;
    PhonebookBtn: TSpeedButton;
    OpenDialog: TOpenDialog;
    CallbackEdit: TEdit;
    Label11: TLabel;
    DialModeSelect: TComboBox;
    Label12: TLabel;
    ApdRasDialer: TApdRasDialer;
    StatusBar1: TStatusBar;
    PhonebookDlg1: TMenuItem;
    ApdRasStatus1: TApdRasStatus;
    Refreshlist1: TMenuItem;
    Deleteentry1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure Dial1Click(Sender: TObject);
    procedure Hangup1Click(Sender: TObject);
    procedure NewPhonebookEntryClick(Sender: TObject);
    procedure EditPhonebookEntryClick(Sender: TObject);
    procedure RefreshEntryListClick(Sender: TObject);
    procedure SetDialParameters;
    procedure DisplayDialParameters;
    procedure ApdRasDialerDialStatus(Sender: TObject; Status: Integer);
    procedure PhonebookBtnClick(Sender: TObject);
    procedure ApdRasDialerConnected(Sender: TObject);
    procedure ApdRasDialerDialError(Sender: TObject; Error: Integer);
    procedure EntrySelectChange(Sender: TObject);
    procedure PhonebookDlg1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Deleteentry1Click(Sender: TObject);
    procedure ApdRasDialerDisconnected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.FormCreate(Sender: TObject);
begin
  if (ApdRasDialer.PlatformID <> VER_PLATFORM_WIN32_NT) then
    PhonebookDlg1.Enabled := False;
  RefreshEntryListClick(nil);
end;

procedure TForm1.RefreshEntryListClick(Sender: TObject);
var
  Error : Integer;
begin
  Error := ApdRasDialer.ListEntries(EntrySelect.Items);
  if (Error = ecRasOK) then begin
    if (EntrySelect.Items.Count > 0) then begin
      EntrySelect.ItemIndex := 0;
      ApdRasDialer.EntryName := EntrySelect.Text;
      StatusBar1.Panels.Items[0].Text := ApdRasDialer.EntryName;
      DisplayDialParameters;
    end;
  end else
    StatusBar1.Panels.Items[0].Text := ApdRasDialer.GetErrorText(Error);
end;

procedure TForm1.Dial1Click(Sender: TObject);
var
  Error : Integer;
begin
  SetDialParameters;
  Error := ApdRasDialer.Dial;
  if (Error <> ecRasOK) then
    StatusBar1.Panels.Items[0].Text := ApdRasDialer.GetErrorText(Error);
end;

procedure TForm1.PhonebookDlg1Click(Sender: TObject);
var
  Error : Integer;
begin
  Error := ApdRasDialer.PhonebookDlg;
  if (Error <> ecRasOK) then
    StatusBar1.Panels.Items[0].Text := ApdRasDialer.GetErrorText(Error);
end;

procedure TForm1.Hangup1Click(Sender: TObject);
begin
  ApdRasDialer.Hangup;
end;

procedure TForm1.DisplayDialParameters;
begin
  with ApdRasDialer do begin
    UserNameEdit.Text        := UserName;
    DomainEdit.Text          := Domain;
    PhoneNumberEdit.Text     := PhoneNumber;
    DialModeSelect.ItemIndex := Integer(DialMode);
    PasswordEdit.Text        := Password
  end;
end;

procedure TForm1.SetDialParameters;
begin
  with ApdRasDialer do begin
    EntryName   := EntrySelect.Text;
    Password    := PasswordEdit.Text;
    UserName    := UserNameEdit.Text;
    Domain      := DomainEdit.Text;
    PhoneNumber := PhoneNumberEdit.Text;
    DialMode    := TApdRasDialMode(DialModeSelect.ItemIndex);
  end;
end;

procedure TForm1.NewPhonebookEntryClick(Sender: TObject);
var
  Error : Integer;
begin
  Error := ApdRasDialer.CreatePhoneBookEntry;
  if (Error = ecRasOK) then
    RefreshEntryListClick(nil)
  else
    StatusBar1.Panels.Items[0].Text := ApdRasDialer.GetErrorText(Error);
end;

procedure TForm1.EditPhonebookEntryClick(Sender: TObject);
var
  Error : Integer;
begin
  Error := ApdRasDialer.EditPhoneBookEntry;
  if (Error = ecRasOK) then
    DisplayDialParameters
  else
    StatusBar1.Panels.Items[0].Text := ApdRasDialer.GetErrorText(Error);
end;

procedure TForm1.Deleteentry1Click(Sender: TObject);
var
  Error : Integer;
begin
  Error := ApdRasDialer.DeletePhoneBookEntry;
  if (Error = ecRasOK) then begin
    RefreshEntryListClick(nil);
    DisplayDialParameters;
  end else
    StatusBar1.Panels.Items[0].Text := ApdRasDialer.GetErrorText(Error);
end;

procedure TForm1.ApdRasDialerDialStatus(Sender: TObject; Status: Integer);
begin
  StatusBar1.Panels.Items[0].Text := ApdRasDialer.GetStatusText(Status);
end;

procedure TForm1.PhonebookBtnClick(Sender: TObject);
begin
  OpenDialog.FileName := '*.pbk';
  if OpenDialog.Execute then
    PhoneBookEdit.Text := OpenDialog.FileName
  else
    PhoneBookEdit.Text := 'Default';
  ApdRasDialer.PhoneBook := PhoneBookEdit.Text;
  RefreshEntryListClick(nil);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.ApdRasDialerConnected(Sender: TObject);
begin
  StatusBar1.Panels.Items[0].Text := 'Connected';
end;

procedure TForm1.ApdRasDialerDialError(Sender: TObject; Error: Integer);
begin
  StatusBar1.Panels.Items[0].Text := ApdRasDialer.GetErrorText(Error);
end;

procedure TForm1.EntrySelectChange(Sender: TObject);
begin
  ApdRasDialer.EntryName := EntrySelect.Text;
  DisplayDialParameters;
  StatusBar1.Panels.Items[0].Text := ApdRasDialer.EntryName;
end;

procedure TForm1.ApdRasDialerDisconnected(Sender: TObject);
begin
  StatusBar1.Panels.Items[0].Text := 'Disconnected';
end;

end.
