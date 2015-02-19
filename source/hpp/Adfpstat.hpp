// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFPStat.pas' rev: 28.00 (Windows)

#ifndef AdfpstatHPP
#define AdfpstatHPP

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
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.Buttons.hpp>	// Pascal unit
#include <AdFaxPrn.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adfpstat
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TStandardFaxPrinterStatusDisplay;
class PASCALIMPLEMENTATION TStandardFaxPrinterStatusDisplay : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* fpsFaxInfoGroup;
	Vcl::Stdctrls::TLabel* fpsLabel1;
	Vcl::Stdctrls::TLabel* fpsLabel2;
	Vcl::Stdctrls::TLabel* fpsLabel3;
	Vcl::Stdctrls::TLabel* fpsLabel4;
	Vcl::Stdctrls::TLabel* fpsFileName;
	Vcl::Stdctrls::TLabel* fpsTotalPages;
	Vcl::Stdctrls::TLabel* fpsResolution;
	Vcl::Stdctrls::TLabel* fpsWidth;
	Vcl::Stdctrls::TGroupBox* fpsStatusGroup;
	Vcl::Buttons::TBitBtn* fpsAbortButton;
	Vcl::Stdctrls::TLabel* fpsStatusLine;
	Vcl::Stdctrls::TLabel* fpsLabel5;
	Vcl::Stdctrls::TLabel* fpsLabel6;
	Vcl::Stdctrls::TLabel* fpsFirstPage;
	Vcl::Stdctrls::TLabel* fpsLastPage;
	void __fastcall fpsAbortButtonClick(System::TObject* Sender);
	void __fastcall UpdateValues(Adfaxprn::TApdCustomFaxPrinter* FaxStatus);
	
public:
	Adfaxprn::TApdCustomFaxPrinter* FaxPrinter;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TStandardFaxPrinterStatusDisplay(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TStandardFaxPrinterStatusDisplay(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TStandardFaxPrinterStatusDisplay(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TStandardFaxPrinterStatusDisplay(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class DELPHICLASS TApdFaxPrinterStatus;
class PASCALIMPLEMENTATION TApdFaxPrinterStatus : public Adfaxprn::TApdAbstractFaxPrinterStatus
{
	typedef Adfaxprn::TApdAbstractFaxPrinterStatus inherited;
	
__published:
	DYNAMIC void __fastcall CreateDisplay(void);
	DYNAMIC void __fastcall DestroyDisplay(void);
	virtual void __fastcall UpdateDisplay(bool First, bool Last);
public:
	/* TApdAbstractFaxPrinterStatus.Create */ inline __fastcall virtual TApdFaxPrinterStatus(System::Classes::TComponent* AOwner) : Adfaxprn::TApdAbstractFaxPrinterStatus(AOwner) { }
	/* TApdAbstractFaxPrinterStatus.Destroy */ inline __fastcall virtual ~TApdFaxPrinterStatus(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adfpstat */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFPSTAT)
using namespace Adfpstat;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfpstatHPP
