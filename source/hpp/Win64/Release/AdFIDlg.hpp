// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFIDlg.pas' rev: 32.00 (Windows)

#ifndef AdfidlgHPP
#define AdfidlgHPP

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
#include <OoMisc.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Mask.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adfidlg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdFaxJobInfoDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TApdFaxJobInfoDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TLabel* Label6;
	Vcl::Stdctrls::TLabel* lblFileName;
	Vcl::Stdctrls::TLabel* lblDateSubmitted;
	Vcl::Stdctrls::TLabel* lblStatus;
	Vcl::Stdctrls::TLabel* lblSender;
	Vcl::Stdctrls::TLabel* lblNumJobs;
	Vcl::Stdctrls::TLabel* lblNextJob;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Stdctrls::TLabel* Label7;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Stdctrls::TLabel* Label10;
	Vcl::Stdctrls::TLabel* Label11;
	Vcl::Stdctrls::TLabel* Label12;
	Vcl::Stdctrls::TLabel* Label13;
	Vcl::Stdctrls::TLabel* lblDateNextSend;
	Vcl::Stdctrls::TLabel* Label15;
	Vcl::Stdctrls::TLabel* Label16;
	Vcl::Stdctrls::TLabel* lblJobStatus;
	Vcl::Stdctrls::TLabel* lblAttemptNum;
	Vcl::Stdctrls::TLabel* lblLastResult;
	Vcl::Stdctrls::TEdit* edtPhoneNum;
	Vcl::Stdctrls::TEdit* edtHeaderLine;
	Vcl::Stdctrls::TEdit* edtHeaderRecipient;
	Vcl::Stdctrls::TEdit* edtHeaderTitle;
	Vcl::Stdctrls::TButton* btnOK;
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Stdctrls::TButton* btnApply;
	Vcl::Buttons::TSpeedButton* btnPrev;
	Vcl::Buttons::TSpeedButton* btnNext;
	Vcl::Stdctrls::TLabel* Label14;
	Vcl::Stdctrls::TLabel* lblJobNumber;
	Vcl::Stdctrls::TButton* btnReset;
	Vcl::Stdctrls::TLabel* Label8;
	Vcl::Stdctrls::TLabel* lblDateSample;
	Vcl::Stdctrls::TLabel* lblTimeSample;
	Vcl::Stdctrls::TEdit* edtSchedDate;
	Vcl::Stdctrls::TEdit* edtSchedTime;
	Vcl::Stdctrls::TLabel* Label17;
	void __fastcall btnPrevClick(System::TObject* Sender);
	void __fastcall btnNextClick(System::TObject* Sender);
	void __fastcall btnApplyClick(System::TObject* Sender);
	void __fastcall EditBoxChange(System::TObject* Sender);
	void __fastcall btnResetClick(System::TObject* Sender);
	void __fastcall btnOKClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	
private:
	bool IsDirty;
	Oomisc::TFaxJobHeaderRec JobHeader;
	System::Classes::TFileStream* JobStream;
	System::Classes::TMemoryStream* JobInfoStream;
	int CurrentJobNum;
	void __fastcall SetDirty(bool NewDirty);
	
public:
	void __fastcall UpdateJobHeader(const Oomisc::TFaxJobHeaderRec &JobHeader);
	void __fastcall UpdateJobInfo(int JobNum);
	System::Uitypes::TModalResult __fastcall ShowDialog(System::ShortString &JobFileName, System::ShortString &DlgCaption);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TApdFaxJobInfoDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TApdFaxJobInfoDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TApdFaxJobInfoDialog(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdFaxJobInfoDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adfidlg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFIDLG)
using namespace Adfidlg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfidlgHPP
