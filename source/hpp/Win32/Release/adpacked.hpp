// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdPackEd.pas' rev: 32.00 (Windows)

#ifndef AdpackedHPP
#define AdpackedHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <AdPacket.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adpacked
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TPacketEditor;
//-- type declarations -------------------------------------------------------
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
