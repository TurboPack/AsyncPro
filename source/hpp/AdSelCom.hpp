// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdSelCom.pas' rev: 28.00 (Windows)

#ifndef AdselcomHPP
#define AdselcomHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Winapi.Messages.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <Vcl.Buttons.hpp>	// Pascal unit
#include <OoMisc.hpp>	// Pascal unit
#include <AwUser.hpp>	// Pascal unit
#include <LNSWin32.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adselcom
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TComSelectForm;
class PASCALIMPLEMENTATION TComSelectForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Buttons::TBitBtn* OkBtn;
	Vcl::Buttons::TBitBtn* AbortBtn;
	Vcl::Extctrls::TBevel* Bevel1;
	Vcl::Stdctrls::TComboBox* PortsComboBox;
	void __fastcall FormCreate(System::TObject* Sender);
	
public:
	System::UnicodeString __fastcall SelectedCom(void);
	System::Word __fastcall SelectedComNum(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TComSelectForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TComSelectForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TComSelectForm(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TComSelectForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool UseDispatcherForAvail;
extern DELPHI_PACKAGE bool ShowPortsInUse;
extern DELPHI_PACKAGE bool __fastcall IsPortAvailable(unsigned ComNum);
}	/* namespace Adselcom */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSELCOM)
using namespace Adselcom;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdselcomHPP
