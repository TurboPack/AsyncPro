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
/*                      cvtopt.h                         */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef cvtoptH
#define cvtoptH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
#include <vcl\Mask.hpp>
#include <vcl\Buttons.hpp>
#include <vcl\Dialogs.hpp>
//---------------------------------------------------------------------------
class TCvtOptionsForm : public TForm
{
__published:	// IDE-managed Components
  TRadioGroup *ResolutionRadioGroup;
  TRadioGroup *WidthRadioGroup;
  TGroupBox *GraphicsGroupBox;
  TRadioGroup *PositionRadioGroup;
  TRadioGroup *ScalingRadioGroup;
  TBitBtn *OkBtn;
  TBitBtn *CancelBtn;
  TGroupBox *AsciiGroupBox;
  TLabel *Label1;
  TRadioGroup *FontRadioGroup;
  TMaskEdit *LinesPerPageEdit;
  TCheckBox *EnhTextBox;
  TButton *FntButton;
  TFontDialog *FontDialog1;
  void __fastcall OkBtnClick(TObject *Sender);
  void __fastcall ResolutionRadioGroupClick(TObject *Sender);
  void __fastcall FormCreate(TObject *Sender);
  void __fastcall EnhTextBoxClick(TObject *Sender);
  void __fastcall FntButtonClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
  virtual __fastcall TCvtOptionsForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TCvtOptionsForm *CvtOptionsForm;
//---------------------------------------------------------------------------
#endif
