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

program Exmdi;

uses
  Forms,
  Exmdi0 in 'EXMDI0.PAS' {EXMDIF0},
  Exmdi1 in 'EXMDI1.PAS' {EXMDIF1},
  Exmdi2 in 'EXMDI2.PAS' {EXMDIF2};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin      
  Application.Initialize;
  Application.CreateForm(TEXMDIF0, EXMDIF0);
  Application.CreateForm(TEXMDIF1, EXMDIF1);
  Application.CreateForm(TEXMDIF2, EXMDIF2);
  Application.Run;
end.
