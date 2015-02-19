// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXUp.pas' rev: 28.00 (Windows)

#ifndef AdxupHPP
#define AdxupHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <Winapi.Messages.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <AdProtcl.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adxup
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TUploadDialog;
class PASCALIMPLEMENTATION TUploadDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TRadioGroup* Protocols;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TEdit* FileMask;
	Vcl::Stdctrls::TButton* OK;
	Vcl::Stdctrls::TButton* Cancel;
	void __fastcall OKClick(System::TObject* Sender);
	void __fastcall CancelClick(System::TObject* Sender);
	
public:
	Adprotcl::TProtocolType __fastcall GetProtocol(void);
	void __fastcall SetProtocol(Adprotcl::TProtocolType NewProt);
	System::UnicodeString __fastcall GetMask(void);
	void __fastcall SetMask(System::UnicodeString NewMask);
	__property Adprotcl::TProtocolType Protocol = {read=GetProtocol, write=SetProtocol, nodefault};
	__property System::UnicodeString Mask = {read=GetMask, write=SetMask};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TUploadDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TUploadDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TUploadDialog(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TUploadDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TUploadDialog* UploadDialog;
}	/* namespace Adxup */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADXUP)
using namespace Adxup;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdxupHPP
