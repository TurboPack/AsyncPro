// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStatE0.pas' rev: 28.00 (Windows)

#ifndef Adstate0HPP
#define Adstate0HPP

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
#include <AdStMach.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adstate0
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrmConditionEdit;
class PASCALIMPLEMENTATION TfrmConditionEdit : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TButton* Button2;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Stdctrls::TLabel* Label6;
	Vcl::Stdctrls::TLabel* Label7;
	Vcl::Stdctrls::TLabel* Label8;
	Vcl::Stdctrls::TEdit* edtCaption;
	Vcl::Stdctrls::TComboBox* cbxColor;
	Vcl::Stdctrls::TEdit* edtWidth;
	Vcl::Stdctrls::TGroupBox* GroupBox3;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Stdctrls::TEdit* edtStartString;
	Vcl::Stdctrls::TEdit* edtEndString;
	Vcl::Stdctrls::TEdit* edtPacketSize;
	Vcl::Stdctrls::TEdit* edtTimeout;
	Vcl::Stdctrls::TComboBox* cbxNextState;
	Vcl::Stdctrls::TCheckBox* chkIgnoreCase;
	Vcl::Stdctrls::TEdit* edtErrorCode;
	Vcl::Stdctrls::TLabel* Label12;
	Vcl::Stdctrls::TCheckBox* DefaultNext;
	Vcl::Stdctrls::TCheckBox* DefaultError;
	Vcl::Stdctrls::TEdit* edtOutputOnActivate;
	void __fastcall cbxColorDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall FormCreate(System::TObject* Sender);
	
private:
	System::Classes::TStringList* FAvailStates;
	void __fastcall ColorCallback(const System::UnicodeString S);
	void __fastcall SetAvailStates(System::Classes::TStringList* const Value);
	
public:
	void __fastcall Clear(void);
	void __fastcall SetNextState(System::UnicodeString S);
	HIDESBASE void __fastcall SetColor(System::UnicodeString C);
	__property System::Classes::TStringList* AvailStates = {read=FAvailStates, write=SetAvailStates};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrmConditionEdit(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrmConditionEdit(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrmConditionEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrmConditionEdit(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrmConditionEdit* frmConditionEdit;
}	/* namespace Adstate0 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTATE0)
using namespace Adstate0;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Adstate0HPP
