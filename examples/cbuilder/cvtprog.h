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
/*                      cvtprog.h                        */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef cvtprogH
#define cvtprogH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Buttons.hpp>
#include "AdFaxCvt.hpp"
#include "AdMeter.hpp"
#include "OoMisc.hpp"

#define WM_USERMSG WM_USER + 1

//---------------------------------------------------------------------------
class TCvtProgressForm : public TForm
{
__published:	// IDE-managed Components
  TLabel *Label1;
  TListBox *ConvertList;
  TApdFaxConverter *FaxConverter;
  TBitBtn *CancelBtn;void __fastcall FormShow(TObject *Sender);
  void __fastcall CancelBtnClick(TObject *Sender);
  void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
  void __fastcall FaxConverterStatus(TObject *F, bool Starting,
          bool Ending, int PagesConverted, int LinesConverted,
          int BytesConverted, int BytesToConvert, bool &Abort);
private:	// User declarations
  TApdMeter *CvtGauge;
  bool CancelClicked;
  bool Shown;
  void __fastcall ConvertFiles(TMessage& Msg);
public:		// User declarations
  bool UseEnhancedText;
  virtual __fastcall TCvtProgressForm(TComponent* Owner);
  BEGIN_MESSAGE_MAP
    MESSAGE_HANDLER(WM_USERMSG, TMessage, ConvertFiles)
  END_MESSAGE_MAP(TForm)
};
//---------------------------------------------------------------------------
extern PACKAGE TCvtProgressForm *CvtProgressForm;
//---------------------------------------------------------------------------
#endif
