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
{*                   EXTCAP0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{*       Shows all TApdTerminal capture options.         *}
{*********************************************************}

unit Extcap0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdPort, OoMisc, ADTrmEmu, StdCtrls;

type
  TExtCapExample = class(TForm)
    ApdComPort1: TApdComPort;
    AdTerminal1: TAdTerminal;
    Label1: TLabel;
    procedure ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExtCapExample: TExtCapExample;

implementation

{$R *.DFM}

procedure TExtCapExample.ApdTerminal1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_Insert :
      AdTerminal1.ScrollBack := not AdTerminal1.Scrollback;
    vk_F8 :
      try
        AdTerminal1.Capture := cmOn;
      except
        ShowMessage('Failed to start capture');
      end;
    vk_F9 :
      try
        AdTerminal1.Capture := cmOff;
      except
        ShowMessage('Failed to close capture file');
      end;
  end;
end;

end.
