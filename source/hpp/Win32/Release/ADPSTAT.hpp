// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdPStat.pas' rev: 32.00 (Windows)

#ifndef AdpstatHPP
#define AdpstatHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <AdMeter.hpp>
#include <OoMisc.hpp>
#include <AdProtcl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adpstat
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TStandardDisplay;
class DELPHICLASS TApdProtocolStatus;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TStandardDisplay : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TLabel* psProtocol;
	Vcl::Stdctrls::TLabel* psBlockCheck;
	Vcl::Stdctrls::TLabel* psFileName;
	Vcl::Stdctrls::TLabel* psFileSize;
	Vcl::Stdctrls::TLabel* psBlockSize;
	Vcl::Stdctrls::TLabel* psTotalBlocks;
	Vcl::Stdctrls::TLabel* psBytesTransferred;
	Vcl::Stdctrls::TLabel* psBytesRemaining;
	Vcl::Stdctrls::TLabel* psBlocksTransferred;
	Vcl::Stdctrls::TLabel* psBlocksRemaining;
	Vcl::Stdctrls::TLabel* psBlockErrors;
	Vcl::Stdctrls::TLabel* psTotalErrors;
	Vcl::Stdctrls::TLabel* psEstimatedTime;
	Vcl::Stdctrls::TLabel* psElapsedTime;
	Vcl::Stdctrls::TLabel* psRemainingTime;
	Vcl::Stdctrls::TLabel* psThroughput;
	Vcl::Stdctrls::TLabel* psEfficiency;
	Vcl::Stdctrls::TLabel* psKermitWindows;
	Vcl::Stdctrls::TLabel* psStatusMsg;
	Vcl::Stdctrls::TButton* psCancel;
	Vcl::Extctrls::TPanel* psPanel1;
	Vcl::Extctrls::TPanel* psPanel6;
	void __fastcall UpdateValues(Adprotcl::TApdCustomProtocol* Protocol);
	void __fastcall CancelClick(System::TObject* Sender);
	
private:
	Admeter::TApdMeter* psProgressBar;
	
public:
	Adprotcl::TApdCustomProtocol* Protocol;
	__fastcall virtual TStandardDisplay(System::Classes::TComponent* Owner);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TStandardDisplay(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TStandardDisplay(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TStandardDisplay(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TApdProtocolStatus : public Adprotcl::TApdAbstractStatus
{
	typedef Adprotcl::TApdAbstractStatus inherited;
	
__published:
	DYNAMIC void __fastcall CreateDisplay(void);
	DYNAMIC void __fastcall DestroyDisplay(void);
	virtual void __fastcall UpdateDisplay(bool First, bool Last);
public:
	/* TApdAbstractStatus.Create */ inline __fastcall virtual TApdProtocolStatus(System::Classes::TComponent* AOwner) : Adprotcl::TApdAbstractStatus(AOwner) { }
	/* TApdAbstractStatus.Destroy */ inline __fastcall virtual ~TApdProtocolStatus(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adpstat */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADPSTAT)
using namespace Adpstat;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdpstatHPP
