// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdMdmDlg.pas' rev: 28.00 (Windows)

#ifndef AdmdmdlgHPP
#define AdmdmdlgHPP

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
#include <OoMisc.hpp>	// Pascal unit
#include <AdMdm.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.Buttons.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <Vcl.ImgList.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Admdmdlg
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TApdModemStatusDialog;
class PASCALIMPLEMENTATION TApdModemStatusDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* gbxStatus;
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Buttons::TBitBtn* btnDetail;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* lblStatus;
	Vcl::Stdctrls::TLabel* lblUsingDevice;
	Vcl::Stdctrls::TLabel* lblUsingPort;
	Vcl::Stdctrls::TLabel* lblElapsedTime;
	Vcl::Stdctrls::TGroupBox* gbxDetail;
	Vcl::Stdctrls::TMemo* memDetail;
	Vcl::Controls::TImageList* ImageList1;
	void __fastcall btnDetailClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall btnCancelClick(System::TObject* Sender);
	
private:
	Admdm::TAdCustomModem* FModem;
	void __fastcall SetModem(Admdm::TAdCustomModem* const NewModem);
	
public:
	__property Admdm::TAdCustomModem* Modem = {read=FModem, write=SetModem};
	void __fastcall UpdateDisplay(const System::UnicodeString StatusStr, const System::UnicodeString TimeStr, const System::UnicodeString DetailStr, Admdm::TApdModemStatusAction Action);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TApdModemStatusDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TApdModemStatusDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TApdModemStatusDialog(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdModemStatusDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TApdModemStatusDialog* ApxModemStatusDialog;
}	/* namespace Admdmdlg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADMDMDLG)
using namespace Admdmdlg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdmdmdlgHPP
