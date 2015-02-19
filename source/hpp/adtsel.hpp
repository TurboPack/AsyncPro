// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdTSel.pas' rev: 28.00 (Windows)

#ifndef AdtselHPP
#define AdtselHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <Winapi.Messages.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.Buttons.hpp>	// Pascal unit
#include <AwUser.hpp>	// Pascal unit
#include <AdPort.hpp>	// Pascal unit
#include <AdExcept.hpp>	// Pascal unit
#include <AdTUtil.hpp>	// Pascal unit
#include <OoMisc.hpp>	// Pascal unit
#include <AdSelCom.hpp>	// Pascal unit
#include <LNSWin32.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adtsel
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TDeviceSelectionForm;
class PASCALIMPLEMENTATION TDeviceSelectionForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TComboBox* dsfComboBox;
	Vcl::Buttons::TBitBtn* dsfOkBitBtn;
	Vcl::Buttons::TBitBtn* dsfCancelBitBtn;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall dsfOkBitBtnClick(System::TObject* Sender);
	void __fastcall dsfCancelBitBtnClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	
private:
	System::Classes::TStringList* FPortItemList;
	Adport::TTapiMode FTapiMode;
	System::Word FComNumber;
	System::UnicodeString FDeviceName;
	bool FShowTapiDevices;
	bool FShowPorts;
	bool FEnumerated;
	bool FShowOnlySupported;
	bool FEnableVoice;
	
public:
	void __fastcall EnumComPorts(void);
	void __fastcall EnumTapiPorts(void);
	void __fastcall EnumAllPorts(void);
	__fastcall virtual TDeviceSelectionForm(System::Classes::TComponent* AOwner);
	__property System::Classes::TStringList* PortItemList = {read=FPortItemList, write=FPortItemList};
	__property Adport::TTapiMode TapiMode = {read=FTapiMode, write=FTapiMode, nodefault};
	__property System::Word ComNumber = {read=FComNumber, write=FComNumber, nodefault};
	__property System::UnicodeString DeviceName = {read=FDeviceName, write=FDeviceName};
	__property bool EnableVoice = {read=FEnableVoice, write=FEnableVoice, nodefault};
	__property bool ShowTapiDevices = {read=FShowTapiDevices, write=FShowTapiDevices, nodefault};
	__property bool ShowPorts = {read=FShowPorts, write=FShowPorts, nodefault};
	__property bool ShowOnlySupported = {read=FShowOnlySupported, write=FShowOnlySupported, nodefault};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TDeviceSelectionForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TDeviceSelectionForm(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TDeviceSelectionForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define DirectTo L"Direct to COM"
extern DELPHI_PACKAGE TDeviceSelectionForm* DeviceSelectionForm;
}	/* namespace Adtsel */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADTSEL)
using namespace Adtsel;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdtselHPP
