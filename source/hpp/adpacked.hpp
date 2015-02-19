// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdPackEd.pas' rev: 28.00 (Windows)

#ifndef AdpackedHPP
#define AdpackedHPP

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
#include <Vcl.Buttons.hpp>	// Pascal unit
#include <AdPacket.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adpacked
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TPacketEditor;
class PASCALIMPLEMENTATION TPacketEditor : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TCheckBox* ChkCharCount;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TCheckBox* ChkEndString;
	Vcl::Stdctrls::TEdit* EdtEndString;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Stdctrls::TRadioButton* rbAnyChar;
	Vcl::Stdctrls::TRadioButton* rbString;
	Vcl::Stdctrls::TEdit* EdtStartString;
	Vcl::Stdctrls::TGroupBox* GroupBox3;
	Vcl::Stdctrls::TCheckBox* ChkIgnoreCase;
	Vcl::Stdctrls::TCheckBox* ChkAutoEnable;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TLabel* Label6;
	Vcl::Stdctrls::TCheckBox* ChkIncludeStrings;
	Vcl::Stdctrls::TCheckBox* ChkEnabled;
	Vcl::Buttons::TBitBtn* BitBtn1;
	Vcl::Buttons::TBitBtn* BitBtn2;
	Vcl::Stdctrls::TEdit* EdtCharCount;
	Vcl::Stdctrls::TEdit* EdtTimeout;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TPacketEditor(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TPacketEditor(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TPacketEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TPacketEditor(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall CtrlStrToStr(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StrToCtrlStr(const System::UnicodeString S);
extern DELPHI_PACKAGE bool __fastcall EditPacket(Adpacket::TApdDataPacket* Packet, const System::UnicodeString Name);
}	/* namespace Adpacked */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADPACKED)
using namespace Adpacked;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdpackedHPP
