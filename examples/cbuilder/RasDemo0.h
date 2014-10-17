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
#ifndef RasDemo0H
#define RasDemo0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
#include <vcl\Buttons.hpp>
#include <vcl\ComCtrls.hpp>
#include <vcl\Menus.hpp>
#include <vcl\Dialogs.hpp>
#include "AdRas.hpp"
#include "OoMisc.hpp"
#include "AdRStat.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TGroupBox *GroupBox2;
	TLabel *Label1;
	TLabel *Label2;
	TLabel *Label3;
	TLabel *Label4;
	TLabel *Label11;
	TLabel *Label12;
	TEdit *PasswordEdit;
	TEdit *UserNameEdit;
	TEdit *DomainEdit;
	TEdit *PhoneNumberEdit;
	TEdit *CallbackEdit;
	TComboBox *DialModeSelect;
	TGroupBox *GroupBox3;
	TLabel *Label6;
	TLabel *Label5;
	TSpeedButton *PhonebookBtn;
	TComboBox *EntrySelect;
	TEdit *PhonebookEdit;
	TStatusBar *StatusBar1;
	TMainMenu *MainMenu;
	TMenuItem *File1;
	TMenuItem *Exit1;
	TMenuItem *Call1;
	TMenuItem *Dial1;
	TMenuItem *PhonebookDlg1;
	TMenuItem *Hangup1;
	TMenuItem *Phonebook1;
	TMenuItem *NewPhonebookEntry;
	TMenuItem *EditPhonebookEntry;
	TMenuItem *N1;
	TMenuItem *Refreshlist1;
	TOpenDialog *OpenDialog;
	TApdRasDialer *ApdRasDialer;
	TApdRasStatus *ApdRasStatus1;
	TMenuItem *Deleteentry1;
	void __fastcall RefreshEntryListClick(TObject *Sender);
	
	void __fastcall Dial1Click(TObject *Sender);
	void __fastcall PhonebookDlg1Click(TObject *Sender);
	void __fastcall Hangup1Click(TObject *Sender);
	
	
	
	void __fastcall NewPhonebookEntryClick(TObject *Sender);
	void __fastcall EditPhonebookEntryClick(TObject *Sender);
	
	void __fastcall ApdRasDialerDialStatus(TObject *Sender, int Status);
	
	void __fastcall PhonebookBtnClick(TObject *Sender);
	
	void __fastcall Exit1Click(TObject *Sender);
	void __fastcall ApdRasDialerConnected(TObject *Sender);
	void __fastcall ApdRasDialerDialError(TObject *Sender, int Error);
	void __fastcall EntrySelectChange(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall Deleteentry1Click(TObject *Sender);
    void __fastcall ApdRasDialerDisconnected(TObject *Sender);
private:	// User declarations
    void __fastcall DisplayDialParameters();
    void __fastcall SetDialParameters();
    void __fastcall DisplayDialOptions();
    void __fastcall SetDialOptions();
    void __fastcall DisableDialOptions();
public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
