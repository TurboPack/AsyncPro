// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdTStat.pas' rev: 28.00 (Windows)

#ifndef AdtstatHPP
#define AdtstatHPP

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
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <AdTUtil.hpp>	// Pascal unit
#include <AdTapi.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adtstat
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TApdStandardTapiDisplay;
class PASCALIMPLEMENTATION TApdStandardTapiDisplay : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* dpPanel1;
	Vcl::Stdctrls::TLabel* dpLabel1;
	Vcl::Stdctrls::TLabel* dpLabel2;
	Vcl::Stdctrls::TLabel* dpLabel3;
	Vcl::Stdctrls::TLabel* dpLabel4;
	Vcl::Stdctrls::TButton* dpCancel;
	Vcl::Extctrls::TPanel* stPanel;
	Vcl::Stdctrls::TLabel* dpStat1;
	Vcl::Stdctrls::TLabel* dpStat2;
	Vcl::Stdctrls::TLabel* dpStat3;
	Vcl::Stdctrls::TLabel* dpStat4;
	Vcl::Stdctrls::TLabel* dpStat5;
	Vcl::Stdctrls::TLabel* dpStat6;
	Vcl::Stdctrls::TLabel* dpStat7;
	Vcl::Stdctrls::TLabel* dpStat8;
	Vcl::Stdctrls::TLabel* dpStat9;
	Vcl::Stdctrls::TLabel* dpDialing;
	Vcl::Stdctrls::TLabel* dpUsing;
	Vcl::Stdctrls::TLabel* dpAttempt;
	Vcl::Stdctrls::TLabel* dpTotalAttempts;
	void __fastcall dpCancelClick(System::TObject* Sender);
	
private:
	System::Word LabCount;
	void __fastcall ClearStatusMessages(void);
	void __fastcall AddStatusLine(const System::UnicodeString S);
	void __fastcall Mode(const System::UnicodeString S);
	void __fastcall UpdateStatusLine(const System::UnicodeString S);
	void __fastcall UpdateValues(Adtapi::TApdCustomTapiDevice* TapiDevice, unsigned Device, unsigned Message, unsigned Param1, unsigned Param2, unsigned Param3);
	
public:
	System::StaticArray<Vcl::Stdctrls::TLabel*, 9> Labels;
	Adtapi::TApdCustomTapiDevice* TapiDevice;
	bool Updating;
	__fastcall virtual TApdStandardTapiDisplay(System::Classes::TComponent* AOwner);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TApdStandardTapiDisplay(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TApdStandardTapiDisplay(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdStandardTapiDisplay(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class DELPHICLASS TApdTapiStatus;
class PASCALIMPLEMENTATION TApdTapiStatus : public Adtapi::TApdAbstractTapiStatus
{
	typedef Adtapi::TApdAbstractTapiStatus inherited;
	
__published:
	DYNAMIC void __fastcall CreateDisplay(void);
	DYNAMIC void __fastcall DestroyDisplay(void);
	virtual void __fastcall UpdateDisplay(bool First, bool Last, unsigned Device, unsigned Message, unsigned Param1, unsigned Param2, unsigned Param3);
public:
	/* TApdAbstractTapiStatus.Create */ inline __fastcall virtual TApdTapiStatus(System::Classes::TComponent* AOwner) : Adtapi::TApdAbstractTapiStatus(AOwner) { }
	/* TApdAbstractTapiStatus.Destroy */ inline __fastcall virtual ~TApdTapiStatus(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 MaxLines = System::Int8(0x9);
}	/* namespace Adtstat */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADTSTAT)
using namespace Adtstat;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdtstatHPP
