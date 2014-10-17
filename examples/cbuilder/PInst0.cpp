// ***** BEGIN LICENSE BLOCK *****
// * Version: MPL 1.1
// *
// * The contents of this file are subject to the Mozilla Public License Version
// * 1.1 (the "License"); you may not use this file except in compliance with
// * the License. You may obtain a copy of the License at
// * http://www.mozilla.org/MPL/
// *
// * Software distributed under the License is distributed on an "AS IS" basis,
// * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// * for the specific language governing rights and limitations under the
// * License.
// *
// * The Original Code is TurboPower Async Professional
// *
// * The Initial Developer of the Original Code is
// * TurboPower Software
// *
// * Portions created by the Initial Developer are Copyright (C) 1991-2002
// * the Initial Developer. All Rights Reserved.
// *
// * Contributor(s):
// *
// * ***** END LICENSE BLOCK *****

/*********************************************************/
/*                      PInst0.cpp                       */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "PInst0.h"
#include "PDrvInst.hpp"
#include "PDrvInNT.hpp"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TMainForm *MainForm;
//---------------------------------------------------------------------------
__fastcall TMainForm::TMainForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::InstallBtnClick(TObject *Sender)
{
  bool QuitOperation = (ParamCount > 0 && ParamStr(1).UpperCase().Pos("Q") != 0);
  if (IsWinNT())
    InstallDriver32(ShortString(""));
  else
    InstallDriver(ShortString("APFGEN.DRV"));

  if (!QuitOperation) {
    switch (DrvInstallError) {
      case ecOK :
        MessageDlg("APF Fax Printer Driver Installed OK", mtInformation,
                   TMsgDlgButtons() << mbOK, 0); break;
      case ecUniAlreadyInstalled :
      case ecUniCannotGetSysDir :
        MessageDlg("Couldn""t determine Windows\System directory",
                   mtError, TMsgDlgButtons() << mbOK, 0); break;
      case ecUniCannotGetWinDir :
        MessageDlg("Couldn""t determine Windows directory",
                   mtError, TMsgDlgButtons() << mbOK, 0); break;
      case ecUniUnknownLayout :
        MessageDlg("   -- Unknown Windows Layout --\r\n"
                   "Unable to locate  required  support\r\n"
                   "files: UniDrv.DLL and/or UniDrv.HLP",
                   mtError, TMsgDlgButtons() << mbOK, 0); break;
      case ecUniCannotInstallFile :
        MessageDlg("UNIDRV.DLL and/or UNIDRV.HLP/r/n"
                   "not installed.  The print driver/r/n"
                   "may not be configured properly.",
                    mtError, TMsgDlgButtons() << mbOK, 0); break;
      case ecDrvCopyError :
        MessageDlg("Unable to copy printer driver to Windows system directory",
                   mtError, TMsgDlgButtons() << mbOK, 0); break;
      case ecCannotAddPrinter :
        MessageDlg("Could not install "+ParamStr(1)+" as a Windows printer",
                   mtError, TMsgDlgButtons() << mbOK, 0); break;
      case ecDrvBadResources :
        MessageDlg("Printer driver file contains bad or missing string resources",
                   mtError, TMsgDlgButtons() << mbOK, 0); break;
      case ecDrvDriverNotFound :
        MessageDlg("The specified printer driver file was not found",
                   mtError, TMsgDlgButtons() << mbOK, 0); break;
      default :
        MessageDlg("Unknown installation error : "+ IntToStr(DrvInstallError),
                 mtError, TMsgDlgButtons() << mbOK, 0);
    }
  }
  CancelBtn->Kind = bkClose;
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::FormCreate(TObject *Sender)
{
  Label1->Caption = "This program will install the Async Professional "
    "Fax Printer Driver on your system. Click on the Install button "
    "to install the driver or the Cancel button to exit.";
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::CancelBtnClick(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
