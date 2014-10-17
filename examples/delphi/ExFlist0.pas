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
{*                   EXFLIST0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{*Shows a TApdProtocol OnNextFile event handler that     *}
{*      transmits a list of files.                       *}
{*********************************************************}

unit Exflist0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdProtcl, AdPStat, AdPort, StdCtrls, AdExcept,
  OoMisc, ADTrmEmu;

type
  TExampleFList = class(TForm)
    ApdComPort1: TApdComPort;
    ApdProtocol1: TApdProtocol;
    ApdProtocolStatus1: TApdProtocolStatus;
    ApdProtocolLog1: TApdProtocolLog;
    AddFiles: TButton;
    AdTerminal1: TAdTerminal;
    procedure ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApdProtocol1ProtocolError(CP: TObject; ErrorCode: Integer);
    procedure AddFilesClick(Sender: TObject);
    procedure ApdProtocol1ProtocolNextFile(CP: TObject;
      var FName: TPassString);
  private
    { Private declarations }
    FileList : TStringList;
    FileIndex : Word;
  public
    { Public declarations }
    constructor Create(AComponent : TComponent); override;
  end;

var
  ExampleFList: TExampleFList;

implementation

{$R *.DFM}

constructor TExampleFList.Create(AComponent : TComponent);
begin
  inherited Create(AComponent);
  FileList := TStringList.Create;
end;

procedure TExampleFList.ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_PRIOR then
    ApdProtocol1.StartTransmit
  else if Key = VK_NEXT then
    ApdProtocol1.StartReceive;
end;

procedure TExampleFList.ApdProtocol1ProtocolError(CP: TObject;
  ErrorCode: Integer);
begin
  ShowMessage('Fatal protocol error: ' + ErrorMsg(ErrorCode));
end;

procedure TExampleFList.AddFilesClick(Sender: TObject);
begin
  FileList.Add('EXFLIST.DPR');
  FileList.Add('EXFLIST0.PAS');
  FileList.Add('EXFLIST0.DFM');
  FileIndex := 0;

  AdTerminal1.WriteString('Files added!');
  AdTerminal1.SetFocus;
end;

procedure TExampleFList.ApdProtocol1ProtocolNextFile(CP: TObject;
  var FName: TPassString);
begin
  try
    FName := FileList[FileIndex];
    Inc(FileIndex);
  except
    FName := '';
  end;
end;

end.
