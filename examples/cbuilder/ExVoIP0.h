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

#ifndef ExVoIP0H
#define ExVoIP0H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "AdVoIP.hpp"
#include <ComCtrls.hpp>
#include "OoMisc.hpp"
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TfrmExVoIP : public TForm
{
__published:	// IDE-managed Components
        TStatusBar *StatusBar1;
        TLabel *Label2;
        TLabel *Label1;
        TLabel *Label3;
        TLabel *Label4;
        TLabel *Label5;
        TLabel *Label6;
        TLabel *Label7;
        TLabel *Label8;
        TLabel *Label9;
        TEdit *edtAddress;
        TButton *btnConnect;
        TButton *btnDisconnect;
        TButton *btnAnswer;
        TListBox *ListBox1;
        TTreeView *TreeView1;
        TButton *btnSelectMediaDevices;
        TCheckBox *cbxEnablePreview;
        TCheckBox *cbxEnableVideo;
        TPanel *Panel1;
        TPanel *PreviewPanel;
        TPanel *Panel3;
        TPanel *RemotePanel;
        TApdVoIP *ApdVoIP1;
        TButton *btnListTerminals;
        void __fastcall FormShow(TObject *Sender);
        void __fastcall btnConnectClick(TObject *Sender);
        void __fastcall btnAnswerClick(TObject *Sender);
        void __fastcall btnDisconnectClick(TObject *Sender);
        void __fastcall cbxEnablePreviewClick(TObject *Sender);
        void __fastcall cbxEnableVideoClick(TObject *Sender);
        void __fastcall btnSelectMediaDevicesClick(TObject *Sender);
        void __fastcall btnListTerminalsClick(TObject *Sender);
        void __fastcall edtAddressChange(TObject *Sender);
        void __fastcall edtAddressKeyPress(TObject *Sender, char &Key);
        void __fastcall ApdVoIP1Connect(TApdCustomVoIP *VoIP);
        void __fastcall ApdVoIP1Disconnect(TApdCustomVoIP *VoIP);
        void __fastcall ApdVoIP1Fail(TApdCustomVoIP *VoIP, int ErrorCode);
        void __fastcall ApdVoIP1IncomingCall(TApdCustomVoIP *VoIP,
          AnsiString CallerAddr, bool &Accept);
        void __fastcall ApdVoIP1Status(TApdCustomVoIP *VoIP,
          WORD TapiEvent, WORD Status, WORD SubStatus);
private:	// User declarations
        void Add(String S);
        void RefreshDeviceLabels();
public:		// User declarations
        __fastcall TfrmExVoIP(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmExVoIP *frmExVoIP;
//---------------------------------------------------------------------------
#endif
