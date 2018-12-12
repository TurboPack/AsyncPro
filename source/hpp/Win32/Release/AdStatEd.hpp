// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStatEd.pas' rev: 32.00 (Windows)

#ifndef AdstatedHPP
#define AdstatedHPP

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
#include <Vcl.Grids.hpp>
#include <Vcl.StdCtrls.hpp>
#include <AdStMach.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adstated
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdStringGrid;
class DELPHICLASS TfrmStateEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TApdStringGrid : public Vcl::Grids::TStringGrid
{
	typedef Vcl::Grids::TStringGrid inherited;
	
public:
	virtual void __fastcall DrawCell(int ACol, int ARow, const System::Types::TRect &ARect, Vcl::Grids::TGridDrawState AState);
public:
	/* TStringGrid.Create */ inline __fastcall virtual TApdStringGrid(System::Classes::TComponent* AOwner) : Vcl::Grids::TStringGrid(AOwner) { }
	/* TStringGrid.Destroy */ inline __fastcall virtual ~TApdStringGrid(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdStringGrid(HWND ParentWindow) : Vcl::Grids::TStringGrid(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TfrmStateEdit : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Stdctrls::TButton* btnAdd;
	Vcl::Stdctrls::TButton* btnEdit;
	Vcl::Stdctrls::TButton* btnDelete;
	Vcl::Stdctrls::TButton* btnOK;
	Vcl::Stdctrls::TButton* btnCancel;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall btnAddClick(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall ConditionGridSelectCell(System::TObject* Sender, int ACol, int ARow, bool &CanSelect);
	void __fastcall btnEditClick(System::TObject* Sender);
	void __fastcall btnDeleteClick(System::TObject* Sender);
	void __fastcall FormResize(System::TObject* Sender);
	
private:
	TApdStringGrid* ConditionGrid;
	Adstmach::TApdCustomStateMachine* FStateMachine;
	void __fastcall SetStateMachine(Adstmach::TApdCustomStateMachine* const Value);
	
public:
	System::Classes::TStringList* Conditions;
	System::Classes::TStringList* AvailableStates;
	__property Adstmach::TApdCustomStateMachine* StateMachine = {read=FStateMachine, write=SetStateMachine};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrmStateEdit(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrmStateEdit(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrmStateEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrmStateEdit(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfrmStateEdit* frmStateEdit;
extern DELPHI_PACKAGE bool __fastcall EditState(Adstmach::TApdCustomState* State, const System::UnicodeString Name);
}	/* namespace Adstated */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTATED)
using namespace Adstated;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdstatedHPP
