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
 * The Original Code is LNS Software Systems
 *
 * The Initial Developer of the Original Code is LNS Software Systems
 *
 * Portions created by the Initial Developer are Copyright (C) 1998-2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)
program Emulator;

uses
  Forms,
  SysUtils,
  EmulatorFrm in 'EmulatorFrm.pas' {EmulatorForm},
  HostsFrm in 'HostsFrm.pas' {HostsForm},
  HostsEditFrm in 'HostsEditFrm.pas' {HostsEditForm},
  ConnectFrm in 'ConnectFrm.pas' {ConnectForm},
  DialingFrm in 'DialingFrm.pas' {DialingForm},
  ColourFrm in 'ColourFrm.pas' {ColourForm},
  XmodemFrm in 'XmodemFrm.pas' {XmodemForm},
  YZmodemFrm in 'YZmodemFrm.pas' {YZmodemForm},
  AsciiFrm in 'AsciiFrm.pas' {AsciiForm},
  FtpFrm in 'FtpFrm.pas' {FtpForm},
  FtpLoginFrm in 'FtpLoginFrm.pas' {FtpLoginForm},
  FtpProgressFrm in 'FtpProgressFrm.pas' {FtpProgressForm},
  XferOptFrm in 'XferOptFrm.pas' {XferOptForm},
  AboutDlg in 'AboutDlg.pas' {AboutDialog},
  About in 'C:\Program Files\Borland\Delphi5\Objrepos\about.pas' {AboutBox};

{$R *.RES}
begin
  Application.Initialize;
  Application.Title := 'APro Terminal Emulator';
  Application.CreateForm(TEmulatorForm, EmulatorForm);
  Application.CreateForm(THostsForm, HostsForm);
  Application.CreateForm(THostsEditForm, HostsEditForm);
  Application.CreateForm(TConnectForm, ConnectForm);
  Application.CreateForm(TDialingForm, DialingForm);
  Application.CreateForm(TColourForm, ColourForm);
  Application.CreateForm(TXmodemForm, XmodemForm);
  Application.CreateForm(TYZmodemForm, YZmodemForm);
  Application.CreateForm(TAsciiForm, AsciiForm);
  Application.CreateForm(TFtpForm, FtpForm);
  Application.CreateForm(TFtpLoginForm, FtpLoginForm);
  Application.CreateForm(TFtpProgressForm, FtpProgressForm);
  Application.CreateForm(TXferOptForm, XferOptForm);
  Application.CreateForm(TAboutDialog, AboutDialog);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
