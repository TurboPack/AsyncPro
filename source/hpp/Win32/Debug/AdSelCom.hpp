// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdSelCom.pas' rev: 32.00 (Windows)

#ifndef AdselcomHPP
#define AdselcomHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <LNSWin32.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adselcom
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TComSelectForm;
//-- type declarations -------------------------------------------------------
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
