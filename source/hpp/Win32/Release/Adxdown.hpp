// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXDown.pas' rev: 32.00 (Windows)

#ifndef AdxdownHPP
#define AdxdownHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <AdProtcl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adxdown
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TDownloadDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TDownloadDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TLabel* DestDirLabel;
	Vcl::Stdctrls::TEdit* Directory;
	Vcl::Stdctrls::TLabel* FileNameLabel;
	Vcl::Stdctrls::TEdit* FileName;
	Vcl::Extctrls::TRadioGroup* Protocols;
	Vcl::Stdctrls::TButton* OK;
	Vcl::Stdctrls::TButton* Cancel;
	void __fastcall OKClick(System::TObject* Sender);
	void __fastcall CancelClick(System::TObject* Sender);
	void __fastcall ProtocolsClick(System::TObject* Sender);
	
public:
	System::UnicodeString __fastcall GetDestDirectory(void);
	void __fastcall SetDestDirectory(System::UnicodeString NewDir);
	System::UnicodeString __fastcall GetReceiveName(void);
	void __fastcall SetReceiveName(System::UnicodeString NewName);
	Adprotcl::TProtocolType __fastcall GetProtocol(void);
	void __fastcall SetProtocol(Adprotcl::TProtocolType NewProt);
	__property System::UnicodeString DestDirectory = {read=GetDestDirectory, write=SetDestDirectory};
	__property System::UnicodeString ReceiveName = {read=GetReceiveName, write=SetReceiveName};
	__property Adprotcl::TProtocolType Protocol = {read=GetProtocol, write=SetProtocol, nodefault};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TDownloadDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TDownloadDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TDownloadDialog(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TDownloadDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TDownloadDialog* DownloadDialog;
}	/* namespace Adxdown */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADXDOWN)
using namespace Adxdown;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdxdownHPP
