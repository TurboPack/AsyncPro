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
/*                      FAXSRVX1.H                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef FaxSrvx1H
#define FaxSrvx1H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TfsFaxList : public TForm
{
__published:	// IDE-managed Components
  TPanel *Panel1;
  TLabel *Label1;
  TLabel *Label2;
  TLabel *Label3;
  TEdit *flFileName;
  TEdit *flCover;
  TEdit *flPhoneNumber;
  TButton *flAction;
  TButton *flCancel;
  void __fastcall flActionClick(TObject *Sender);
  void __fastcall flCancelClick(TObject *Sender);
  void __fastcall FormActivate(TObject *Sender);
private:	// User declarations
public:		// User declarations
  String GetFaxName();
  void SetFaxName(const String NewName);
  String GetCoverName();
  void SetCoverName(const String NewName);
  String GetPhoneNumber();
  void SetPhoneNumber(const String NewNumber);
public:		// User declarations
  __property String FaxName = { read = GetFaxName, write = SetFaxName };
  __property String CoverName = { read = GetCoverName, write = SetCoverName };
  __property String PhoneNumber = { read = GetPhoneNumber, write = SetPhoneNumber };
  __fastcall TfsFaxList(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TfsFaxList *fsFaxList;
//---------------------------------------------------------------------------
#endif
