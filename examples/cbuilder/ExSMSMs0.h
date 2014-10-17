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
#ifndef ExSMSMs0H
#define ExSMSMs0H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "AdGSM.hpp"
#include "AdPort.hpp"
#include "OoMisc.hpp"
#include "ADTrmEmu.hpp"
#include <Menus.hpp>
#include <ComCtrls.hpp>
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
    TButton *btnConnect;
    TEdit *Edit1;
    TEdit *Edit2;
    TEdit *Edit3;
    TMemo *Memo1;
    TButton *Button1;
    TAdTerminal *AdTerminal1;
    TButton *btnDelete;
    TEdit *edtIndex;
    TTreeView *TreeView1;
    TButton *btnAddMessage;
    TApdGSMPhone *ApdGSMPhone1;
    TApdComPort *ApdComPort1;
    TPopupMenu *PopupMenu1;
    TMenuItem *Send1;
    TMenuItem *Delete1;
        void __fastcall btnConnectClick(TObject *Sender);
        void __fastcall btnAddMessageClick(TObject *Sender);
        void __fastcall ApdGSMPhone1GSMComplete(TApdCustomGSMPhone *Pager,
          TGSMStates State, int ErrorCode);
        void __fastcall Send1Click(TObject *Sender);
    void __fastcall Delete1Click(TObject *Sender);
    void __fastcall ApdGSMPhone1MessageList(TObject *Sender);
    
    void __fastcall TreeView1DblClick(TObject *Sender);
    void __fastcall TreeView1KeyDown(TObject *Sender, WORD &Key,
          TShiftState Shift);
    
private:	// User declarations
public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
