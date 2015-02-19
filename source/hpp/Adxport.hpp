// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXPort.pas' rev: 28.00 (Windows)

#ifndef AdxportHPP
#define AdxportHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Winapi.Messages.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <AdPort.hpp>	// Pascal unit
#include <AdTapi.hpp>	// Pascal unit
#include <AdTSel.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adxport
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TComPortOptions;
class PASCALIMPLEMENTATION TComPortOptions : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* FlowControlBox;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TCheckBox* DTRRTS;
	Vcl::Stdctrls::TCheckBox* RTSCTS;
	Vcl::Stdctrls::TCheckBox* SoftwareXmit;
	Vcl::Stdctrls::TCheckBox* SoftwareRcv;
	Vcl::Stdctrls::TEdit* Edit1;
	Vcl::Stdctrls::TEdit* Edit2;
	Vcl::Extctrls::TRadioGroup* Bauds;
	Vcl::Extctrls::TRadioGroup* Paritys;
	Vcl::Extctrls::TRadioGroup* Databits;
	Vcl::Extctrls::TRadioGroup* Stopbits;
	Vcl::Stdctrls::TGroupBox* Comports;
	Vcl::Stdctrls::TButton* OK;
	Vcl::Stdctrls::TButton* Cancel;
	Vcl::Stdctrls::TComboBox* PortComboBox;
	void __fastcall OKClick(System::TObject* Sender);
	void __fastcall CancelClick(System::TObject* Sender);
	void __fastcall PortComboBoxChange(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	
private:
	bool FShowTapiDevices;
	bool FShowPorts;
	Adport::TApdComPort* FComPort;
	System::UnicodeString FTapiDevice;
	bool Executed;
	
protected:
	Adport::TApdComPort* __fastcall GetComPort(void);
	void __fastcall SetComPort(Adport::TApdComPort* NewPort);
	
public:
	__fastcall virtual TComPortOptions(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TComPortOptions(void);
	bool __fastcall Execute(void);
	__property Adport::TApdComPort* ComPort = {read=GetComPort, write=SetComPort};
	__property System::UnicodeString TapiDevice = {read=FTapiDevice, write=FTapiDevice};
	__property bool ShowTapiDevices = {read=FShowTapiDevices, write=FShowTapiDevices, nodefault};
	__property bool ShowPorts = {read=FShowPorts, write=FShowPorts, nodefault};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TComPortOptions(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TComPortOptions(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TComPortOptions* ComPortOptions;
}	/* namespace Adxport */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADXPORT)
using namespace Adxport;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdxportHPP
