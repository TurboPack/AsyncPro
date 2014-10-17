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
{*                   EXSERV1.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{* This server portion works with ExClient to implement  *}
{*      a basic Winsock connection.                      *}
{*********************************************************}

unit ExServ1;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdPort, AdWnPort, AdWUtil, AdSocket, OoMisc;

type
  TForm1 = class(TForm)
    ApdWinsockPort1: TApdWinsockPort;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure ApdWinsockPort1WsAccept(Sender: TObject; Addr: TInAddr;
      var Accept: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure ApdWinsockPort1TriggerAvail(CP: TObject; Count: Word);
    procedure ApdWinsockPort1WsError(Sender: TObject; ErrCode: Integer);
    procedure ApdWinsockPort1WsDisconnect(Sender: TObject);
  private
    { Private declarations }
    PortClosing : Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ApdWinsockPort1WsAccept(Sender: TObject; Addr: TInAddr;
  var Accept: Boolean);
begin
  Label1.Caption := 'Connected';
  ApdWinsockPort1.Output := 'Hello from Server';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if ApdWinsockPort1.Open then begin
    PortClosing := True;
    Label1.Caption := '';
    Button1.Caption := 'Listen';
  end else begin
    PortClosing := False;
    Label1.Caption := 'Listening';
    Button1.Caption := 'Disconnect';
  end;
  try
    ApdWinsockPort1.Open := not(ApdWinsockPort1.Open);
  except
    on E:EApdSocketException do begin
      ApdWinsockPort1WsError(Self, E.ErrorCode);
      ApdWinsockPort1.Open := False;
      Button1.Caption := 'Listen';
    end;
  end;
end;

procedure TForm1.ApdWinsockPort1TriggerAvail(CP: TObject; Count: Word);
var
  I : Word;
begin
  for I := 1 to Count do
    Label2.Caption := Label2.Caption + ApdWinsockPort1.GetChar;
end;

procedure TForm1.ApdWinsockPort1WsError(Sender: TObject; ErrCode: Integer);
begin
  Label1.Caption := 'Error...';
  Label3.Caption := 'Code: ' + IntToStr(ErrCode);
end;

procedure TForm1.ApdWinsockPort1WsDisconnect(Sender: TObject);
begin
  if not PortClosing then
    Label1.Caption := 'Listening';
  Label2.Caption := '';
end;

end.
