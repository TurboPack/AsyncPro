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
{*                   EXWPACK0.PAS 4.06                   *}
{*********************************************************}
 
{**********************Description************************}
{* Demonstrates Demonstrates how to use packets for      *}
{*       automating a download.                          *}
{*********************************************************}

unit ExwPack0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdProtcl, AdPStat, AdPort, StdCtrls,
  AdWnPort, FileCtrl, AwWnSock, AdStatLt, AdPacket, OoMisc;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    ApdWinsockPort1: TApdWinsockPort;
    Edit1: TEdit;
    WaitName: TApdDataPacket;
    edtName: TEdit;
    edtPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    WaitPassword: TApdDataPacket;
    WaitContinue: TApdDataPacket;
    WaitCommand: TApdDataPacket;
    WaitFileName: TApdDataPacket;
    EdtFilename: TEdit;
    Label3: TLabel;
    WaitContinue2: TApdDataPacket;
    WaitZStart: TApdDataPacket;
    Memo1: TMemo;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ApdWinsockPort1WsConnect(Sender: TObject);
    procedure ApdWinsockPort1WsDisconnect(Sender: TObject);
    procedure WaitNameTimeout(Sender: TObject);
    procedure WaitNamePacket(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure WaitPasswordPacket(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure WaitContinuePacket(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure WaitCommandPacket(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure WaitZStartPacket(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure WaitContinue2Packet(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure WaitFileNamePacket(Sender: TObject; Data: Pointer;
      Size: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    CommandState : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not ApdWinsockPort1.Open then begin
    ApdWinsockPort1.WsAddress := Edit1.Text;
  end;
  ApdWinsockPort1.Open := not(ApdWinsockPort1.Open);
end;

procedure TForm1.ApdWinsockPort1WsConnect(Sender: TObject);
begin
  Button1.Caption := 'Disconnect';
  Memo1.Lines.Add('Connected. Waiting for name prompt...');
  WaitName.Enabled := True;
  Cursor := crHourGlass;
end;

procedure TForm1.ApdWinsockPort1WsDisconnect(Sender: TObject);
begin
  Button1.Caption := 'Connect';
  Cursor := crDefault;
  Memo1.Lines.Add('Idle');
end;

procedure TForm1.WaitNameTimeout(Sender: TObject);
begin
  ApdWinsockPort1.Open := False;
  ShowMessage('Operation timed out. Port closed.');
end;

procedure TForm1.WaitNamePacket(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  WaitPassword.Enabled := True;
  ApdWinsockPort1.PutString(edtName.Text+#13);
  Memo1.Lines.Add('Name sent. Waiting for password prompt...');
end;

procedure TForm1.WaitPasswordPacket(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  WaitCommand.Enabled := True;
  CommandState := 0;
  ApdWinsockPort1.PutString(edtPassword.Text+#13#13#13#13#13#13);
  Memo1.Lines.Add('Password sent. Waiting for command prompt...');
end;

procedure TForm1.WaitContinuePacket(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  WaitCommand.Enabled := True;
  ApdWinsockPort1.PutString(#13);
end;

procedure TForm1.WaitCommandPacket(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  case CommandState of
  0 :
    begin
      WaitCommand.Enabled := True;
      ApdWinsockPort1.PutString('f'#13);
      Memo1.Lines.Add('Navigating to file menu...');
    end;
  1 :
    begin
      ApdWinsockPort1.PutString('d'#13);
      WaitCommand.Enabled := False;
      WaitFileName.Enabled := True;
      Memo1.Lines.Add('Requesting file download...');
    end;
  end;
  inc(CommandState);
end;

procedure TForm1.WaitZStartPacket(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  ApdProtocol1.StartReceive;
  Memo1.Lines.Add('Downloading...');
end;

procedure TForm1.WaitContinue2Packet(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  ApdWinsockPort1.PutString(#13#13'G'#13#13);
  Memo1.Lines.Add('Logging off...');
end;

procedure TForm1.WaitFileNamePacket(Sender: TObject; Data: Pointer;
  Size: Integer);
begin
  WaitContinue2.Enabled := True;
  WaitZStart.Enabled := True;
  ApdWinsockPort1.PutString(edtFileName.Text+#13#13#13'Z'#13);
  Memo1.Lines.Add('Sending name of file to download...');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ApdWinsockPort1.Open := False;
end;

end.
