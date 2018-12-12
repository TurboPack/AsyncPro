// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdTSel.pas' rev: 32.00 (Windows)

#ifndef AdtselHPP
#define AdtselHPP

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
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <AwUser.hpp>
#include <AdPort.hpp>
#include <AdExcept.hpp>
#include <AdTUtil.hpp>
#include <OoMisc.hpp>
#include <AdSelCom.hpp>
#include <LNSWin32.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adtsel
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TDeviceSelectionForm;
//-- type declarations -------------------------------------------------------
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
