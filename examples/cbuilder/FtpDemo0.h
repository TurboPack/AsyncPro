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
#ifndef FtpDemo0H
#define FtpDemo0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Menus.hpp>
#include "AdFtp.hpp"
#include "OoMisc.hpp"
#include "AdWnPort.hpp"
#include "AdPort.hpp"
#include <vcl\Tabnotbk.hpp>
#include <vcl\ComCtrls.hpp>
#include <vcl\ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TTabbedNotebook *TabbedNotebook1;
	TLabel *Label7;
	TLabel *Label2;
	TLabel *Label3;
	TEdit *ServerEdit;
	TEdit *UserNameEdit;
	TEdit *PasswordEdit;
	TButton *LoginBtn;
	TButton *LogoutBtn;
	TButton *ExitBtn;
	TLabel *Label1;
	TLabel *Label6;
	TRadioGroup *ReceiveMode1;
	TRadioGroup *SendMode1;
	TEdit *TimeoutEdit;
	TEdit *RestartEdit;
	TRadioGroup *FileType1;
	TMemo *ReplyMemo;
	TGroupBox *GroupBox2;
	TMemo *InfoMemo;
	TMainMenu *MainMenu1;
	TMenuItem *File1;
	TMenuItem *Login1;
	TMenuItem *Logout1;
	TMenuItem *N2;
	TMenuItem *Send1;
	TMenuItem *Recieve1;
	TMenuItem *Rename1;
	TMenuItem *Delete1;
	TMenuItem *N1;
	TMenuItem *Exit1;
	TMenuItem *Directory1;
	TMenuItem *List1;
	TMenuItem *FullList1;
	TMenuItem *NamesList1;
	TMenuItem *Change1;
	TMenuItem *CreateDir1;
	TMenuItem *Rename2;
	TMenuItem *N3;
	TMenuItem *Delete2;
	TMenuItem *Misc1;
	TMenuItem *Help1;
	TMenuItem *Status1;
	TMenuItem *SendFtp1;
	TMenuItem *N4;
	TMenuItem *Log1;
	TMenuItem *Clearmemo1;
	TApdFtpClient *ApdFtpClient1;
	TApdFtpLog *ApdFtpLog1;
	void __fastcall FormActivate(TObject *Sender);
	void __fastcall Login1Click(TObject *Sender);
	void __fastcall Logout1Click(TObject *Sender);
	
	
	void __fastcall Change1Click(TObject *Sender);
	
	
	
	
	void __fastcall NamesList1Click(TObject *Sender);
	void __fastcall FullList1Click(TObject *Sender);
	void __fastcall Help1Click(TObject *Sender);
	
	void __fastcall Send1Click(TObject *Sender);
	
	void __fastcall Receive1Click(TObject *Sender);
	
	void __fastcall SendFtp1Click(TObject *Sender);
	void __fastcall Status1Click(TObject *Sender);
	
	void __fastcall Log1Click(TObject *Sender);
	void __fastcall Rename1Click(TObject *Sender);
	
	void __fastcall Exit1Click(TObject *Sender);
	void __fastcall ApdFtpClient1FtpReply(TObject *Sender, int ReplyCode,
	PChar Reply);
	void __fastcall ApdFtpClient1FtpStatus(TObject *Sender,
	TFtpStatusCode StatusCode, PChar Info);
	void __fastcall Delete1Click(TObject *Sender);
	void __fastcall CreateDir1Click(TObject *Sender);
	void __fastcall AbortBtnClick(TObject *Sender);
	void __fastcall Clear1Click(TObject *Sender);
	
	
	void __fastcall ApdFtpClient1FtpError(TObject *Sender, int ErrorCode,
	PChar ErrorText);
private:	// User declarations
    void __fastcall TForm1::GetProperties();
    void __fastcall TForm1::SetProperties();

public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
