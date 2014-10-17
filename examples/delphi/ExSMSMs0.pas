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
{*                   EXSMSMS0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* A program connecting to a GSM phone, add a message,   *}
{*  and sending a message passing an index number        *}
{*********************************************************}

unit ExSMSMs0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdPort, OoMisc, AdGSM, ADTrmEmu, Menus, ComCtrls;

type
  TForm1 = class(TForm)
    ApdGSMPhone1: TApdGSMPhone;
    ApdComPort1: TApdComPort;
    btnConnect: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Memo1: TMemo;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    AdTerminal1: TAdTerminal;
    Delete1: TButton;
    edtIndex: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    TreeView1: TTreeView;
    PopupMenu1: TPopupMenu;
    Send1: TMenuItem;
    btnAddMessage: TButton;
    Delete2: TMenuItem;
    procedure btnConnectClick(Sender: TObject);
    procedure ApdGSMPhone1GSMComplete(Pager: TApdCustomGSMPhone;
      State: TGSMStates; ErrorCode: Integer);
    procedure Button1Click(Sender: TObject);
    procedure TreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApdGSMPhone1MessageList(Sender: TObject);
    procedure Send1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure btnAddMessageClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  ApdGSMPhone1.Connect;
end;

procedure TForm1.ApdGSMPhone1GSMComplete(Pager: TApdCustomGSMPhone;
  State: TGSMStates; ErrorCode: Integer);
begin
  if ErrorCode <> 0 then
    ShowMessage('Error ' + IntToStr(ErrorCode));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  StoreIndex : Integer;
  PhoneIndex : Integer;
begin
  StoreIndex := TreeView1.Selected.Index;
  PhoneIndex := ApdGSMPhone1.MessageStore.Messages[StoreIndex].MessageIndex;
  if PhoneIndex > -1 then
    ApdGSMPhone1.SendFromMemory(PhoneIndex);
end;

procedure TForm1.ApdGSMPhone1MessageList(Sender: TObject);
var
  I : Integer;
  Node1 : TTreeNode;
begin
  TreeView1.Items.Clear;
  for I := 0 to ApdGSMPhone1.MessageStore.Count - 1 do begin
    if ApdGSMPhone1.MessageStore.Messages[I].TimeStampStr = '' then
      ApdGSMPhone1.MessageStore.Messages[I].TimeStampStr := '< No Timestamp Index = >' + IntToStr(I);
    with ApdGSMPhone1.MessageStore.Messages[I] do begin
      Node1 := TreeView1.Items.Add (nil, TimeStampStr);
      TreeView1.Items.AddChild(Node1, 'Index: ' + IntToStr(MessageIndex));
      TreeView1.Items.AddChild(Node1, 'Phone Number: ' + Address);
      TreeView1.Items.AddChild(Node1, 'Message: ' + Message);
      TreeView1.Items.AddChild(Node1, 'Name: ' + Name);
      TreeView1.Items.AddChild(Node1, ApdGSMPhone1.StatusToStr(Status));
    end;
  end;
end;

procedure TForm1.Delete1Click(Sender: TObject);
var
  StoreIndex : Integer;
  PhoneIndex : Integer;
begin
  StoreIndex := TreeView1.Selected.Index;
  PhoneIndex := ApdGSMPhone1.MessageStore.Messages[StoreIndex].MessageIndex;
  if PhoneIndex > -1 then
    ApdGSMPhone1.MessageStore.Delete(PhoneIndex);
end;

procedure TForm1.TreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    if TreeView1.Selected.Index > -1 then
      ApdGSMPhone1.MessageStore.Delete(TreeView1.Selected.Index);
end;

procedure TForm1.Send1Click(Sender: TObject);
var
  StoreIndex : Integer;
  PhoneIndex : Integer;
begin
  StoreIndex := TreeView1.Selected.Index;
  PhoneIndex := ApdGSMPhone1.MessageStore.Messages[StoreIndex].MessageIndex;
  if PhoneIndex > -1 then
    ApdGSMPhone1.SendFromMemory(PhoneIndex);
end;

procedure TForm1.btnAddMessageClick(Sender: TObject);
begin
  // Add message to memory
  ApdGSMPhone1.WriteToMemory(Edit1.Text, Memo1.Text);
end;

procedure TForm1.TreeView1DblClick(Sender: TObject);
var
  I : Integer;
  Msg : TApdSMSMessage;
begin
  I := TreeView1.Selected.Index;
  Msg := ApdGSMPhone1.MessageStore.Messages[I];
  Edit1.Text := Msg.Address;
  Edit2.Text := Msg.TimeStampStr;
  Edit3.Text := ApdGSMPhone1.StatusToStr(Msg.Status);
  edtIndex.Text := IntToStr(Msg.MessageIndex);
  Memo1.Lines.Text := Msg.Message;
end;



end.
