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

{******************************************************************}
{*                  TurboPower Apro ActiveX 1.13                  *}
{******************************************************************}
{* Apax1.dpr - Apax OCX project file                              *}
{******************************************************************}
                                                                            
(*
 Rebuilding APAX: Good, you've found the dpr file, you'll need this
 to rebuild the OCX.  Delphi 5 is the preferred compiler, but others
 should work, although you may need to work through some compiler
 warnings. The steps below assume that you're using Delphi 5.
 1. Go to the Project | Options dialog, then the Directories/Conditionals
    tab.  Add "APAX" to the "Conditional defines" edit control. While
    you're in there, make sure the Search path includes the APRO\Source
    folder.
 2. Do a build of the APAX1 project (Project | Build), which will create
    the APAX1.OCX file.
 3. Register the OCX via Run | Register ActiveX Server.
 4. If you like to test as you build, set up the Run | Parameters dialog
    so your VB6 executable is the host application. When you run the APAX1
    project it will start VB6 so you can test it.  This does not work very
    reliably with VS.NET.
 5. If the OCX doesn't seem right when used, check to make sure there is only
    one copy of it (multiple copies of the same OCX can bring about
    some rather interesting results)
*)

library Apax1;

uses
  ComServ,
  APAX1_TLB in 'APAX1_TLB.pas',
  ApaxImpl in 'ApaxImpl.pas' {Apax: CoClass};

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R apax1.RES}  // version info, main icon
begin
end.
