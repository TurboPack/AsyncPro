// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFStat.pas' rev: 32.00 (Windows)

#ifndef AdfstatHPP
#define AdfstatHPP

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
#include <AdFax.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adfstat
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TStandardFaxDisplay;
class DELPHICLASS TApdFaxStatus;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TStandardFaxDisplay : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TLabel* fsPhoneNumber;
	Vcl::Stdctrls::TLabel* fsFaxFileName;
	Vcl::Stdctrls::TLabel* fsCoverFileName;
	Vcl::Stdctrls::TLabel* fsTotalPages;
	Vcl::Stdctrls::TLabel* fsRemoteID;
	Vcl::Stdctrls::TLabel* fsConnectBPS;
	Vcl::Stdctrls::TLabel* fsResolution;
	Vcl::Stdctrls::TLabel* fsWidth;
	Vcl::Stdctrls::TLabel* fsErrorControl;
	Vcl::Stdctrls::TLabel* fsCurrentPage;
	Vcl::Stdctrls::TLabel* fsPageLength;
	Vcl::Stdctrls::TLabel* fsBytesTransferred;
	Vcl::Stdctrls::TLabel* fsElapsedTime;
	Vcl::Stdctrls::TLabel* fsStatusMsg;
	Vcl::Stdctrls::TButton* fsCancel;
	Vcl::Extctrls::TPanel* fsPanel1;
	Vcl::Stdctrls::TLabel* fsLabel5;
	Vcl::Stdctrls::TLabel* fsLabel19;
	Vcl::Stdctrls::TLabel* fsDialAttempt;
	Vcl::Extctrls::TPanel* fsPanel6;
	Vcl::Stdctrls::TLabel* fsLabel2;
	Vcl::Stdctrls::TLabel* fsLabel3;
	void __fastcall UpdateValues(Adfax::TApdCustomAbstractFax* Fax);
	void __fastcall CancelClick(System::TObject* Sender);
	
public:
	Adfax::TApdCustomAbstractFax* Fax;
	Admeter::TApdMeter* fsMeter1;
	__fastcall virtual TStandardFaxDisplay(System::Classes::TComponent* AOwner);
	
private:
	Oomisc::EventTimer Timer;
	bool Timing;
	Oomisc::EventTimer BusyTimer;
	bool BusyTiming;
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TStandardFaxDisplay(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TStandardFaxDisplay(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TStandardFaxDisplay(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TApdFaxStatus : public Adfax::TApdAbstractFaxStatus
{
	typedef Adfax::TApdAbstractFaxStatus inherited;
	
__published:
	DYNAMIC void __fastcall CreateDisplay(void);
	DYNAMIC void __fastcall DestroyDisplay(void);
	virtual void __fastcall UpdateDisplay(const bool First, const bool Last);
public:
	/* TApdAbstractFaxStatus.Create */ inline __fastcall virtual TApdFaxStatus(System::Classes::TComponent* AOwner) : Adfax::TApdAbstractFaxStatus(AOwner) { }
	/* TApdAbstractFaxStatus.Destroy */ inline __fastcall virtual ~TApdFaxStatus(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adfstat */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFSTAT)
using namespace Adfstat;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfstatHPP
