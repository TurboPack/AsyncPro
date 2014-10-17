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
{*                   EXTMAIN0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* How to use TApdTerminal with the alClient alignment   *}
{*      option.                                          *}
{*********************************************************}

unit Extmain0;

interface

uses
  WinTypes,
  WinProcs,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  Forms,
  Dialogs,
  ADTrmEmu,
  AdPort, OoMisc;

type
  TEXTMainForm = class(TForm)
    ApdComPort1: TApdComPort;
    AdTerminal1: TAdTerminal;
    procedure ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure WMGetMinMaxInfo(var Msg : TWMGetMinMaxInfo);
      message WM_GETMINMAXINFO;
  public
    { Public declarations }
  end;

var
  EXTMainForm: TEXTMainForm;

implementation

{$R *.DFM}

procedure TEXTMainForm.WMGetMinMaxInfo(var Msg : TWMGetMinMaxInfo);
var
  FrameWidth : Word;
  FrameHeight : Word;
  NewWidth : Word;
  NewHeight : Word;
begin
  FrameWidth := Width - ClientWidth - 1;
  FrameHeight := Height - ClientHeight - 1;
  NewWidth := (AdTerminal1.CharWidth * AdTerminal1.Columns)
              + FrameWidth;
  NewHeight := (AdTerminal1.CharHeight * AdTerminal1.Rows)
               + FrameHeight;

  Msg.MinMaxInfo^.ptMaxSize.Y := NewHeight;
  Msg.MinMaxInfo^.ptMaxSize.X := NewWidth;
  Msg.MinMaxInfo^.ptMaxTrackSize.Y := NewHeight;
  Msg.MinMaxInfo^.ptMaxTrackSize.X := NewWidth;
end;

procedure TEXTMainForm.ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Insert then
    AdTerminal1.ScrollBack := not AdTerminal1.Scrollback;
end;

end.
