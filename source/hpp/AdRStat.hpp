// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdRStat.pas' rev: 28.00 (Windows)

#ifndef AdrstatHPP
#define AdrstatHPP

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
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <OoMisc.hpp>	// Pascal unit
#include <AdRas.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adrstat
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TRasStatusDisplay;
class PASCALIMPLEMENTATION TRasStatusDisplay : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* CancelBtn;
	Vcl::Extctrls::TPanel* Panel1;
	void __fastcall CancelBtnClick(System::TObject* Sender);
	
public:
	Adras::TApdCustomRasDialer* RasDialer;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TRasStatusDisplay(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TRasStatusDisplay(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TRasStatusDisplay(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TRasStatusDisplay(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class DELPHICLASS TApdRasStatus;
class PASCALIMPLEMENTATION TApdRasStatus : public Adras::TApdAbstractRasStatus
{
	typedef Adras::TApdAbstractRasStatus inherited;
	
protected:
	HWND FHandle;
	void __fastcall CMRasStatus(Winapi::Messages::TMessage &Msg);
	
public:
	__fastcall virtual TApdRasStatus(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdRasStatus(void);
	DYNAMIC void __fastcall CreateDisplay(const System::UnicodeString EntryName);
	DYNAMIC void __fastcall DestroyDisplay(void);
	virtual void __fastcall UpdateDisplay(const System::UnicodeString StatusMsg);
	__property HWND Handle = {read=FHandle, write=FHandle, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adrstat */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADRSTAT)
using namespace Adrstat;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdrstatHPP
