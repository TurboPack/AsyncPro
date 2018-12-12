// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdMdmCfg.pas' rev: 32.00 (Windows)

#ifndef AdmdmcfgHPP
#define AdmdmcfgHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <AdLibMdm.hpp>
#include <AdMdm.hpp>
#include <AdPort.hpp>

//-- user supplied -----------------------------------------------------------

namespace Admdmcfg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdModemConfigDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TApdModemConfigDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* btnOK;
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Comctrls::TPageControl* PageControl1;
	Vcl::Comctrls::TTabSheet* TabSheet1;
	Vcl::Comctrls::TTabSheet* TabSheet2;
	Vcl::Comctrls::TTabSheet* TabSheet3;
	Vcl::Stdctrls::TLabel* lblModemName;
	Vcl::Stdctrls::TLabel* lblModemModel;
	Vcl::Stdctrls::TLabel* lblModemManufacturer;
	Vcl::Stdctrls::TLabel* lblAttachedTo;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Extctrls::TRadioGroup* rgpDataBits;
	Vcl::Extctrls::TRadioGroup* rgpParity;
	Vcl::Extctrls::TRadioGroup* rgpStopBits;
	Vcl::Stdctrls::TCheckBox* cbxNotBlindDial;
	Vcl::Stdctrls::TCheckBox* cbxEnableCallFailTimer;
	Vcl::Stdctrls::TEdit* edtCallSetupFailTimer;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TCheckBox* cbxEnableIdleTimeout;
	Vcl::Stdctrls::TLabel* Label7;
	Vcl::Stdctrls::TGroupBox* GroupBox3;
	Vcl::Stdctrls::TRadioButton* rbFlowNone;
	Vcl::Stdctrls::TRadioButton* rbFlowHard;
	Vcl::Stdctrls::TRadioButton* rbFlowSoft;
	Vcl::Stdctrls::TGroupBox* rgpErrorCorrection;
	Vcl::Stdctrls::TCheckBox* cbxDataCompress;
	Vcl::Stdctrls::TGroupBox* GroupBox5;
	Vcl::Stdctrls::TRadioButton* rbModCCITT;
	Vcl::Stdctrls::TCheckBox* cbxCellular;
	Vcl::Stdctrls::TRadioButton* rbModCCITTV23;
	Vcl::Stdctrls::TRadioButton* rbModBell;
	Vcl::Stdctrls::TEdit* edtExtraSettings;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TCheckBox* cbxUseErrorCorrection;
	Vcl::Stdctrls::TCheckBox* cbxRequireCorrection;
	Vcl::Stdctrls::TEdit* edtInactivityTimer;
	Vcl::Stdctrls::TGroupBox* GroupBox4;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Comctrls::TTrackBar* tbSpeakerVolume;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TRadioButton* rbSpeakerConnect;
	Vcl::Stdctrls::TRadioButton* rbSpeakerOn;
	Vcl::Stdctrls::TRadioButton* rbSpeakerOff;
	
private:
	Adlibmdm::TLmModem FLmModem;
	Admdm::TApdModemConfig __fastcall GetModemConfig(void);
	void __fastcall SetLmModem(const Adlibmdm::TLmModem &Value);
	void __fastcall SetModemConfig(const Admdm::TApdModemConfig &Value);
	
public:
	__property Adlibmdm::TLmModem LmModem = {read=FLmModem, write=SetLmModem};
	__property Admdm::TApdModemConfig ModemConfig = {read=GetModemConfig, write=SetModemConfig};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TApdModemConfigDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TApdModemConfigDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TApdModemConfigDialog(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdModemConfigDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Admdmcfg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADMDMCFG)
using namespace Admdmcfg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdmdmcfgHPP
