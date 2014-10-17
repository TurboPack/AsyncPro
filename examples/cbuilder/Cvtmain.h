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
/*                      Cvtmain.h                        */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef CvtmainH
#define CvtmainH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\FileCtrl.hpp>
#include <vcl\Buttons.hpp>
//---------------------------------------------------------------------------
class TCvtMainForm : public TForm
{
__published:	// IDE-managed Components
  TEdit *FileNameEdit;
  TFileListBox *FileListBox;
  TLabel *Label4;
  TFilterComboBox *FilterComboBox;
  TLabel *Label6;
  TListBox *ConvertList;
  TLabel *Label2;
  TLabel *Label3;
  TDirectoryListBox *DirectoryListBox;
  TLabel *Label5;
  TDriveComboBox *DriveComboBox;
  TLabel *Label1;
  TBitBtn *OkBtn;
  TBitBtn *CancelBtn;
  TBitBtn *OptionsBtn;
  TBitBtn *AddBtn;
  TBitBtn *RemoveBtn;
  void __fastcall OptionsBtnClick(TObject *Sender);
  void __fastcall AddBtnClick(TObject *Sender);
  void __fastcall ConvertListClick(TObject *Sender);
  void __fastcall RemoveBtnClick(TObject *Sender);
  void __fastcall OkBtnClick(TObject *Sender);
  
  void __fastcall CancelBtnClick(TObject *Sender);
  void __fastcall FileListBoxDblClick(TObject *Sender);
private:	// User declarations
  bool ContainsWildCards(String S);
  bool FileInConvertList(const String FName);
public:		// User declarations
  virtual __fastcall TCvtMainForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TCvtMainForm *CvtMainForm;
//---------------------------------------------------------------------------
#endif
