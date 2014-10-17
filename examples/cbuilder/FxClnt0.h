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

//---------------------------------------------------------------------------
#ifndef FxClnt0H
#define FxClnt0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdFaxSrv.hpp"
#include "OoMisc.hpp"
#include "AdFaxCtl.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label1;
	TLabel *Label2;
	TLabel *Label3;
	TLabel *Label4;
	TLabel *Label5;
	TLabel *Label6;
	TLabel *Label7;
	TLabel *Label8;
	TLabel *Label9;
	TLabel *Label10;
	TEdit *edtCoverFileName;
	TEdit *edtFaxFileName;
	TEdit *edtHeaderLine;
	TEdit *edtHeaderRecipient;
	TEdit *edtHeaderTitle;
	TEdit *edtJobName;
	TEdit *edtPhoneNumber;
	TEdit *edtScheduledDT;
	TEdit *edtSender;
	TEdit *edtJobFileName;
	TButton *btnMakeJob;
	TButton *btnClear;
	TButton *btnJobInfoDialog;
	TButton *btnAddRecipient;
	TButton *btnJobDesigner;
	TButton *btnExit;
	TApdFaxClient *ApdFaxClient1;
	TApdFaxDriverInterface *ApdFaxDriverInterface1;
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall ApdFaxDriverInterface1DocEnd(TObject *Sender);
	void __fastcall btnMakeJobClick(TObject *Sender);
	void __fastcall btnAddRecipientClick(TObject *Sender);
	void __fastcall btnJobInfoDialogClick(TObject *Sender);
	void __fastcall btnJobDesignerClick(TObject *Sender);
	void __fastcall btnClearClick(TObject *Sender);
	void __fastcall btnExitClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
    void __fastcall ClearControls();
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
