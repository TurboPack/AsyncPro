// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdVoipEd.pas' rev: 32.00 (Windows)

#ifndef AdvoipedHPP
#define AdvoipedHPP

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
#include <AdVoIP.hpp>

//-- user supplied -----------------------------------------------------------

namespace Advoiped
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TVoipAudioVideoEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TVoipAudioVideoEditor : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* btnOk;
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TComboBox* cboxAudioIn;
	Vcl::Stdctrls::TComboBox* cboxAudioOut;
	Vcl::Stdctrls::TComboBox* cboxVideoIn;
	Vcl::Stdctrls::TCheckBox* cboxVideoPlayback;
	Vcl::Stdctrls::TCheckBox* cboxEnablePreview;
	
protected:
	void __fastcall GetAudioVideoDevices(Advoip::TApdCustomVoIP* Voip);
	
public:
	void __fastcall Initialize(Advoip::TApdCustomVoIP* Voip);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TVoipAudioVideoEditor(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TVoipAudioVideoEditor(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TVoipAudioVideoEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVoipAudioVideoEditor(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TVoipAudioVideoEditor* VoipAudioVideoEditor;
extern DELPHI_PACKAGE bool __fastcall EditVoIPAudioVideo(Advoip::TApdCustomVoIP* Voip, const System::UnicodeString Name);
}	/* namespace Advoiped */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADVOIPED)
using namespace Advoiped;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdvoipedHPP
