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
/*                      EXPNDX0.CPP                      */
/*********************************************************/
//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#include <vcl\printers.hpp>
#pragma hdrstop

#include "ExPndx0.h"
//---------------------------------------------------------------------------
#pragma link "OoMisc"
#pragma resource "*.dfm"

TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::RadioGroup1Click(TObject *Sender)
{
   char Device[100];
   char Name[100];
   char Port[100];
   THandle DevMode;
   String PrinterName;

   if (Printer()->Printers->Count < 1) {
     MessageDlg("There are no printer drivers available...",
     mtInformation, TMsgDlgButtons() << mbOK, 0);
     return;
   }

   switch (RadioGroup1->ItemIndex) {
     // sets printer to the Default Windows Printer...
     case 0: Printer()->PrinterIndex = -1; break;
     case 1: {
       if (IsWinNT())
         PrinterName = ApdDef32PrinterName;
       else
         PrinterName = (String)ApdDef16PrinterName + " on " + ApdDefPrinterPort + ":";

       // The following line of code does not fully initialize the selected printer
       // as the current printer (when it is not the Default Printer) using the Printerindex
       // property. Output seems to be based on the Default Windows Printer.
       Printer()->PrinterIndex = Printer()->Printers->IndexOf(PrinterName);

       // Adding the following lines including the GetPrinter and SetPrinter methods seem to
       // force the selected printer (when it is not the Default Printer) to be fully
       // initialized as the current printer and output is printed properly.}
       Printer()->GetPrinter(Device, Name, Port, DevMode);
       Printer()->SetPrinter(Device, Name, Port, 0);
       break;
     }
   }
   // This problem has been seen in all versions of BCB, and Delphi 2 and above

   Edit1->Text = Printer()->Printers->Strings[Printer()->PrinterIndex];
}
//---------------------------------------------------------------------------
void __fastcall TForm1::BitBtn2Click(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::BitBtn1Click(TObject *Sender)
{
  Print();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  Application->ShowHint = true;
  Edit1->Text = Printer()->Printers->Strings[Printer()->PrinterIndex];
}

//---------------------------------------------------------------------------
