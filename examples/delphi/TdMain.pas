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
{*                    TDMAIN.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{*  Demonstrates the terminal component and related      *}
{*        components.  It provides more features than    *}
{*        the introductory example programs but isn't as *}
{*        complex as TCom.                               *}
{*********************************************************}

unit TDMain;

interface

{$G+,X+,F+}

{Conditional defines that may affect this unit}
{$I AWDEFINE.INC}

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, ExtCtrls, StdCtrls, OOMisc, AdExcept, AdPort, AdXPort, 
  AdProtcl, AdPStat, AdTapi, ADTrmEmu;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    F1: TMenuItem;
    E1: TMenuItem;
    C1: TMenuItem;
    F2: TMenuItem;
    P1: TMenuItem;
    C2: TMenuItem;
    N1: TMenuItem;
    E2: TMenuItem;
    C3: TMenuItem;
    S1: TMenuItem;
    StatusLine: THeader;
    OpenDialog1: TOpenDialog;
    FontDialog1: TFontDialog;
    ApdComPort1: TApdComPort;
    N2: TMenuItem;
    ConfigureTAPI1: TMenuItem;
    ApdTapiDevice1: TApdTapiDevice;
    AdVT100Emulator1: TAdVT100Emulator;
    Terminal1: TAdTerminal;
    procedure Terminal1TerminalStatus(CP: TObject; Row, Col: Byte; BufRow,
      BufCol: Word);
    procedure P1Click(Sender: TObject);
    procedure ApdComPort1PortChange(CP: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure E2Click(Sender: TObject);
    procedure C3Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure F2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApdTapiDevice1TapiPortClose(Sender: TObject);
    procedure ConfigureTAPI1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Terminal1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    ProgramShutDown : Boolean;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure UpdateComInfo(Term : TAdTerminal);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

const
  UseFile : Boolean = False;

var
  AnsiFile : String;
  AF       : File;
  AFBuffer : array[1..4096] of AnsiChar;
  AFIndex  : Word;

{$R *.DFM}

function IntToStr(L : Longint) : String;
begin
  Str(L , Result);
end;

procedure OpenFile;
  {-Open file and prepare for playback}
begin
  Assign(AF, AnsiFile);
  Reset(AF,1);
  UseFile := True;
  AFIndex := SizeOf(AFBuffer)+1;
  if IoResult <> 0 then
    Halt;
end;

function ReadNextChar(var C : AnsiChar) : Boolean;
  {-Return next character from AF}
const
  BytesRead : Cardinal = 0;
begin
  ReadNextChar := False;
  if AFIndex > BytesRead then begin
    BlockRead(AF, AFBuffer, SizeOf(AFBuffer), BytesRead);
    if (IoResult <> 0) or (BytesRead = 0) then
      Exit;
    AFIndex := 1;
  end;
  C := AFBuffer[AFIndex];
  Inc(AFIndex);
  ReadNextChar := True;
end;

procedure TMainForm.AppIdle(Sender: TObject; var Done: Boolean);
const
  PaintInterval = 200;
  CharCount : Word = 0;
var
  C : AnsiChar;
begin
  Done := True;
  if UseFile then
    repeat
      {Get next char from file}
      if ReadNextChar(C) then begin
        Terminal1.WriteChar(C);
        Inc(CharCount);
        if CharCount > PaintInterval then begin
          {Terminal1.ForcePaint;}
          CharCount := 0;
          Exit;
        end else begin
          Done := False;
          Exit;
        end;
      end else begin
        {Terminal1.ForcePaint;}
        CloseFile(AF);
        UseFile := False;
        Exit;
      end;
    until False;
end;

procedure TMainForm.UpdateComInfo(Term : TAdTerminal);
  {-Update the comport information}
var
  S : String;
begin
  if (ApdComPort1 <> nil) and
     (ApdComPort1.TapiMode = tmOff) then begin
    {Name}
    S := ' ' + ComName(ApdComPort1.ComNumber) + ' ';

    {Line params}
    S := S + IntToStr(ApdComPort1.Databits);
    S := S + ParityName[ApdComPort1.Parity, 1];
    S := S + IntToStr(ApdComPort1.Stopbits) + ' ';

    {Baud}
    S := S + IntToStr(ApdComPort1.Baud);
  end else begin
    S := ApdTapiDevice1.SelectedDevice;
  end;
  StatusLine.Sections[0] := S;
end;

procedure TMainForm.Terminal1TerminalStatus(CP: TObject; Row, Col: Byte;
                                         BufRow, BufCol: Word);
begin
  {Update rows/columns}
  StatusLine.Sections[1] := Format('%2d %2d', [Row, Col]);
  StatusLine.Sections[2] := Format('%2d %2d', [BufRow, BufCol]);
  StatusLine.Sections[3] := '';

  {Set widths}
  StatusLine.SectionWidth[0] := 155;
  StatusLine.SectionWidth[1] := 45;
  StatusLine.SectionWidth[2] := 55;
end;

procedure TMainForm.P1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    {Open file and prepare to read}
    AnsiFile := OpenDialog1.FileName;
    OpenFile;
  end;
end;


procedure TMainForm.ApdComPort1PortChange(CP: TObject);
begin
  {Update the cominfo portion of the status line}
  UpdateComInfo(Terminal1);
end;


procedure TMainForm.FormActivate(Sender: TObject);
begin
  UpdateComInfo(Terminal1);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.OnIdle := AppIdle;
  ProgramShutDown := False;
end;

procedure TMainForm.C2Click(Sender: TObject);
begin
  Terminal1.ClearAll;
end;

procedure TMainForm.E2Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.C3Click(Sender: TObject);
begin
  Terminal1.CopyToClipboard;
end;

procedure TMainForm.S1Click(Sender: TObject);
begin
  if Assigned(ApdTapiDevice1) then
    ComPortOptions.TapiDevice := ApdTapiDevice1.SelectedDevice;

  if (ApdComPort1 <> nil) then
    ComPortOptions.ComPort := ApdComPort1;

  ComPortOptions.ShowTapiDevices := ApdTapiDevice1.ShowTapiDevices;

  if ComPortOptions.Execute then begin
    if (ComPortOptions.ComPort <> nil) then begin
      { Close and open com ports }
      ApdComPort1.Open := False;

      {reassign the new com port properties }
      ApdComPort1.Assign(ComPortOptions.ComPort);

      { tell the terminal that we want to be active }
      Terminal1.Active := True;

      { cancel any previous TAPI calls }
      if ApdTapiDevice1.CancelCall then begin
        {Ok to open new port/device}
        if ApdComPort1.TapiMode <> tmOff then begin
          {Open the TAPI device}
          ApdTapiDevice1.SelectedDevice := ComPortOptions.TapiDevice;
          ApdTapiDevice1.ConfigAndOpen;
        end else
          ApdComPort1.Open := True;
      end else begin
        {Waiting for OnTapiPortClose event before opening the new port/tapi}
      end;
    end;
  end;

  {Update the cominfo portion of the status line}
  UpdateComInfo(Terminal1);

  {Give focus back to terminal window}
  Terminal1.SetFocus;
end;

procedure TMainForm.F2Click(Sender: TObject);
begin
  FontDialog1.Font := Terminal1.Font;
  if FontDialog1.Execute then
    Terminal1.Font := FontDialog1.Font;
  Terminal1.Width := Terminal1.CharWidth * 80;
  Terminal1.Height := Terminal1.CharHeight * 25;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
begin
  if Key = VK_INSERT then
    Terminal1.Scrollback := not Terminal1.Scrollback;
end;

procedure TMainForm.ApdTapiDevice1TapiPortClose(Sender: TObject);
begin
  if Assigned(ApdComPort1) and (ApdComPort1.TapiMode <> tmOff) then begin
    if not ProgramShutDown then begin
      ApdTapiDevice1.SelectedDevice := ComPortOptions.TapiDevice;
      ApdTapiDevice1.ConfigAndOpen;
    end;
  end else if Assigned(ApdComPort1) and (ApdComPort1.TapiMode = tmOff) then
    if not ProgramShutDown then
      ApdComPort1.Open := True;
end;

procedure TMainForm.ConfigureTAPI1Click(Sender: TObject);
begin
  ApdTapiDevice1.ShowConfigDialog;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  ProgramShutDown := True;
end;

procedure TMainForm.Terminal1KeyPress(Sender: TObject; var Key: Char);
begin
  { select the port if it isn't already selected }
  if ApdComPort1.ComNumber = 0 then
    S1.Click;
end;

end.


