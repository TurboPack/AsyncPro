// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXProt.pas' rev: 32.00 (Windows)

#ifndef AdxprotHPP
#define AdxprotHPP

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
#include <AdProtcl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adxprot
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TProtocolOptions;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TProtocolOptions : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* GeneralOptions;
	Vcl::Stdctrls::TComboBox* gWriteFail;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TCheckBox* gHonorDirectory;
	Vcl::Stdctrls::TCheckBox* gIncludeDirectory;
	Vcl::Stdctrls::TCheckBox* gRTSLowForWrite;
	Vcl::Stdctrls::TCheckBox* gAbortNoCarrier;
	Vcl::Stdctrls::TGroupBox* ZmodemOptions;
	Vcl::Stdctrls::TCheckBox* zOptionOverride;
	Vcl::Stdctrls::TCheckBox* zSkipNoFile;
	Vcl::Stdctrls::TCheckBox* zRecover;
	Vcl::Stdctrls::TCheckBox* z8K;
	Vcl::Stdctrls::TComboBox* zFileManagment;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TButton* OK;
	Vcl::Stdctrls::TButton* Cancel;
	Vcl::Stdctrls::TGroupBox* KermitOptions;
	Vcl::Stdctrls::TGroupBox* AsciiOptions;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TEdit* kBlockLen;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TEdit* kWindows;
	Vcl::Stdctrls::TLabel* Label6;
	Vcl::Stdctrls::TEdit* kTimeout;
	Vcl::Stdctrls::TLabel* Label7;
	Vcl::Stdctrls::TEdit* sInterCharDelay;
	Vcl::Stdctrls::TLabel* Label8;
	Vcl::Stdctrls::TEdit* sInterLineDelay;
	Vcl::Stdctrls::TComboBox* sCRTrans;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Stdctrls::TLabel* Label10;
	Vcl::Stdctrls::TComboBox* sLFTrans;
	Vcl::Stdctrls::TLabel* Label11;
	Vcl::Stdctrls::TEdit* sEOFTimeout;
	void __fastcall CancelClick(System::TObject* Sender);
	void __fastcall OKClick(System::TObject* Sender);
	
private:
	Adprotcl::TApdProtocol* FProtocol;
	bool Executed;
	
protected:
	Adprotcl::TApdProtocol* __fastcall GetProtocol(void);
	void __fastcall SetProtocol(Adprotcl::TApdProtocol* NewProtocol);
	
public:
	__fastcall virtual TProtocolOptions(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TProtocolOptions(void);
	bool __fastcall Execute(void);
	__property Adprotcl::TApdProtocol* Protocol = {read=GetProtocol, write=SetProtocol};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TProtocolOptions(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TProtocolOptions(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TProtocolOptions* ProtocolOptions;
}	/* namespace Adxprot */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADXPROT)
using namespace Adxprot;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdxprotHPP
