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

{$I-,G+,X+,F+}

{Conditional defines that may affect this unit}
{$I AWDEFINE.INC}

{*********************************************************}
{*                   TERMDEMO.DPR 2.10                   *}
{*********************************************************}

program Termdemo;

uses
  Forms,
  Tdmain in 'TDMAIN.PAS' {MainForm},
  AdXPort {in '..\ADXPORT.PAS'};

{ Note : For the Delphi project manager to display the forms belonging to
         a project, the project must have the "in XXX.PAS" part of the 'USES'
         statement.  However, the "in XXX.PAS" statement will not search
         the directories declared in the project options; a path to these
         files must be present if the units & forms are not in the current
         directory.  Our choice was to leave the statements commented out
         and have the units & forms not appear in the project manager
         rather than have path assumptions hard-coded into the project. }

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TComPortOptions, ComPortOptions);
  Application.Run;
end.
