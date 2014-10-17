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
{*                    EXCOM0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{*    TApdComPort with an OnTriggerAvail handler.        *}
{*********************************************************}

unit Excom0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, OoMisc;

type
  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Test: TButton;
    procedure TestClick(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.TestClick(Sender: TObject);
  {TestClick button click - Send output}
begin
  ApdComPort1.OutPut := 'ATZ'^M;
end;

procedure TForm1.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
  {Event OnTriggerAvail - Example how OnTriggerAvail works} 
var
  I : Word;
  C : Char;
  S : String;
begin
  S := '';
  for I := 1 to Count do begin
    C := ApdComPort1.GetChar;
    case C of
      #0..#31 : {Don't display} ;
      else S := S + C;
    end;
  end;
  ShowMessage('Got an OnTriggerAvail event for: ' + S);
end;

end.
