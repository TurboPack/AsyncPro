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
#ifndef FtpAuto1H
#define FtpAuto1H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdFtp.hpp"
#include "AdWnPort.hpp"
#include "AdPort.hpp"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TGroupBox *GroupBox1;
	TLabel *Label1;
	TLabel *Label2;
	TLabel *Label3;
	TButton *btnLogin;
	TButton *btnLogout;
	TEdit *edtURL;
	TEdit *edtUsername;
	TEdit *edtPassword;
	TGroupBox *GroupBox2;
	TLabel *Label5;
	TListBox *lbxFiles;
	TEdit *edtLocalDir;
	TMemo *Memo1;
	TApdFtpClient *ApdFtpClient1;
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall btnLoginClick(TObject *Sender);
	void __fastcall btnLogoutClick(TObject *Sender);
	void __fastcall ApdFtpClient1FtpStatus(TObject *Sender,
	TFtpStatusCode StatusCode, PChar InfoText);
	void __fastcall ApdFtpClient1FtpError(TObject *Sender, int ErrorCode,
	PChar ErrorText);
	void __fastcall FormDestroy(TObject *Sender);
	void __fastcall lbxFilesMouseDown(TObject *Sender, TMouseButton Button,
	TShiftState Shift, int X, int Y);
	void __fastcall lbxFilesDblClick(TObject *Sender);
private:	// User declarations
    void __fastcall RetrieveNext(void);
public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
