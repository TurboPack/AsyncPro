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

program Cvt2fax;

uses
  WinTypes,
  WinProcs,
  Forms,
  CVTMAIN in 'CVTMAIN.PAS' {CvtMainForm},
  Cvtopt in 'CVTOPT.PAS' {CvtOptionsForm},
  Cvtprog in 'CVTPROG.PAS' {CvtProgressForm};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}


{$R EXICON.RES}

begin
  SetErrorMode(SEM_FAILCRITICALERRORS);
  Application.Initialize;
  Application.CreateForm(TCvtMainForm, CvtMainForm);
  Application.CreateForm(TCvtProgressForm, CvtProgressForm);
  Application.CreateForm(TCvtOptionsForm, CvtOptionsForm);
  Application.Run;
end.
