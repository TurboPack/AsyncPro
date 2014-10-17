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
/*                      VIEWMAIN.H                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ViewMainH
#define ViewMainH
//---------------------------------------------------------------------------
#define _WINSOCK_API_
#include <vcl\ComCtrls.hpp>
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdFView.hpp"
#include <vcl\ExtCtrls.hpp>
#include <vcl\Menus.hpp>
#include <vcl\Dialogs.hpp>
#include "AdFaxPrn.hpp"
#include "AdFPStat.hpp"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
class TMainForm : public TForm
{
__published:	// IDE-managed Components
  TMainMenu *MainMenu;
  TMenuItem *FileItem;
  TMenuItem *OpenItem;
  TMenuItem *N1;
  TMenuItem *PrintSetupItem;
  TMenuItem *PrintItem;
  TMenuItem *N2;
  TMenuItem *ExitItem;
  TMenuItem *EditItem;
  TMenuItem *SelectAllItem;
  TMenuItem *CopyItem;
  TMenuItem *ViewItem;
  TMenuItem *ZoomInItem;
  TMenuItem *ZoomOutItem;
  TMenuItem *N4;
  TMenuItem *N25PercentItem;
  TMenuItem *N50PercentItem;
  TMenuItem *N75PercentItem;
  TMenuItem *N100PercentItem;
  TMenuItem *N200PercentItem;
  TMenuItem *N400PercentItem;
  TMenuItem *OtherSizeItem;
  TMenuItem *N5;
  TMenuItem *NoRotateItem;
  TMenuItem *Rotate90Item;
  TMenuItem *Rotate180Item;
  TMenuItem *Rotate270Item;
  TMenuItem *N3;
  TMenuItem *WhitespaceCompOption;
  TOpenDialog *OpenDialog;
  TApdFaxPrinter *FaxPrinter;
  TApdFaxPrinterStatus *PrinterStatus;
  TApdFaxViewer *FaxViewer;
  TStatusBar *StatusBar;
  TMenuItem *CloseItem;
  TMenuItem *PrevPage;
  TMenuItem *NextPage;
  void __fastcall OpenItemClick(TObject *Sender);
  void __fastcall PrintSetupItemClick(TObject *Sender);
  void __fastcall PrintItemClick(TObject *Sender);
  void __fastcall ExitItemClick(TObject *Sender);
  void __fastcall ZoomInItemClick(TObject *Sender);
  void __fastcall ZoomOutItemClick(TObject *Sender);
  void __fastcall N25PercentItemClick(TObject *Sender);
  void __fastcall N50PercentItemClick(TObject *Sender);
  void __fastcall N75PercentItemClick(TObject *Sender);
  void __fastcall N100PercentItemClick(TObject *Sender);
  void __fastcall N200PercentItemClick(TObject *Sender);
  void __fastcall N400PercentItemClick(TObject *Sender);
  void __fastcall OtherSizeItemClick(TObject *Sender);
  
  void __fastcall WhitespaceCompOptionClick(TObject *Sender);
  void __fastcall SelectAllItemClick(TObject *Sender);
  void __fastcall CopyItemClick(TObject *Sender);
  void __fastcall NoRotateItemClick(TObject *Sender);
  void __fastcall Rotate90ItemClick(TObject *Sender);
  void __fastcall Rotate180ItemClick(TObject *Sender);
  void __fastcall Rotate270ItemClick(TObject *Sender);
  void __fastcall FormCreate(TObject *Sender);
  void __fastcall FaxViewerPageChange(TObject *Sender);
  void __fastcall FaxViewerViewerError(TObject *Sender, int ErrorCode);
  
  void __fastcall CloseItemClick(TObject *Sender);
  
  
  void __fastcall NextPageClick(TObject *Sender);
  void __fastcall PrevPageClick(TObject *Sender);
  void __fastcall FaxViewerDropFile(TObject *Sender, AnsiString FileName);
private:	// User declarations
  int ViewPercent;

  void UpdateViewPercent(const int NewPercent);
  void EnableZoomChoices();
  void DisableZoomChoices();
  void UncheckZoomChoices();
  void EnableRotationChoices();
  void DisableRotationChoices();
  void UncheckRotationChoices();
  void OpenFile(String FileName);
  void CloseFile();
public:		// User declarations
  __fastcall TMainForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TMainForm *MainForm;
//---------------------------------------------------------------------------
#endif
