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
#ifndef FxServr0H
#define FxServr0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
#include "AdPort.hpp"
#include "AdFaxSrv.hpp"
#include "AdFax.hpp" 
#include "OoMisc.hpp"
#include "AdFStat.hpp"
#include "AdTapi.hpp"
#include <vcl\Dialogs.hpp>
#include "AdFaxPrn.hpp"
#include "AdFPStat.hpp"
//---------------------------------------------------------------------------
class TfrmFxSrv0 : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label8;
	TGroupBox *GroupBox1;
	TLabel *Label1;
	TEdit *edtMonitorDir;
	TCheckBox *cbxPaused;
	TGroupBox *GroupBox3;
	TLabel *lblDeviceName;
	TButton *btnSelectDevice;
	TGroupBox *GroupBox4;
	TButton *btnClose;
	TGroupBox *GroupBox2;
	TLabel *Label2;
	TLabel *Label3;
	TLabel *Label4;
	TLabel *Label5;
	TLabel *Label6;
	TLabel *Label7;
	TEdit *edtStationID;
	TRadioGroup *rgpFaxClass;
	TEdit *edtDialPrefix;
	TEdit *edtModemInit;
	TEdit *edtQueryInterval;
	TEdit *edtDestinationDir;
	TCheckBox *cbxEnhFonts;
	TButton *btnHeaderFont;
	TButton *btnCoverFont;
	TCheckBox *cbxMonitor;
	TCheckBox *cbxPrintOnReceive;
	TButton *btnPrintSetup;
	TListBox *lbStatus;
	TApdComPort *ApdComPort1;
	TApdFaxServer *ApdFaxServer1;
	TApdFaxStatus *ApdFaxStatus1;
	TApdFaxLog *ApdFaxLog1;
	TApdTapiDevice *ApdTapiDevice1;
	TFontDialog *FontDialog1;
	TApdFaxServerManager *ApdFaxServerManager1;
	TApdFaxPrinter *ApdFaxPrinter1;
	TApdFaxPrinterStatus *ApdFaxPrinterStatus1;
	void __fastcall edtStationIDExit(TObject *Sender);
	void __fastcall edtModemInitExit(TObject *Sender);
	void __fastcall edtDialPrefixExit(TObject *Sender);
	void __fastcall edtDestinationDirExit(TObject *Sender);
	void __fastcall edtQueryIntervalExit(TObject *Sender);
	void __fastcall rgpFaxClassClick(TObject *Sender);
	void __fastcall cbxEnhFontsClick(TObject *Sender);
	void __fastcall cbxMonitorClick(TObject *Sender);
	void __fastcall cbxPrintOnReceiveClick(TObject *Sender);
	void __fastcall btnHeaderFontClick(TObject *Sender);
	void __fastcall btnCoverFontClick(TObject *Sender);
	void __fastcall btnPrintSetupClick(TObject *Sender);
	void __fastcall edtMonitorDirExit(TObject *Sender);
	void __fastcall cbxPausedClick(TObject *Sender);
	void __fastcall btnSelectDeviceClick(TObject *Sender);
	void __fastcall btnCloseClick(TObject *Sender);
	void __fastcall ApdFaxServer1FaxServerAccept(TObject *CP, bool &Accept);
	void __fastcall ApdFaxServer1FaxServerFatalError(TObject *CP,
	TFaxServerMode FaxMode, int ErrorCode, int HangupCode);
	void __fastcall ApdFaxServer1FaxServerFinish(TObject *CP,
	TFaxServerMode FaxMode, int ErrorCode);
	void __fastcall ApdFaxServer1FaxServerLog(TObject *CP, TFaxLogCode LogCode,
	TFaxServerLogCode ServerCode);
	void __fastcall ApdFaxServer1FaxServerPortOpenClose(TObject *CP, bool Opening);
	void __fastcall ApdFaxServer1FaxServerStatus(TObject *CP,
	TFaxServerMode FaxMode, bool First, bool Last, WORD Status);
	void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TfrmFxSrv0(TComponent* Owner);
    void Add(String S);
};
//---------------------------------------------------------------------------
extern TfrmFxSrv0 *frmFxSrv0;
//---------------------------------------------------------------------------
#endif
