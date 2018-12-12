// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStSt.pas' rev: 32.00 (Windows)

#ifndef AdststHPP
#define AdststHPP

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
#include <AdStMach.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adstst
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomActionState;
class DELPHICLASS TApdActionState;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TApdOnStartAction)(System::TObject* Sender, Adstmach::TApdStateConditions* StateConditions, bool &ActionCompleted, int &NextState);

typedef void __fastcall (__closure *TApdOnSelectNextState)(System::TObject* Sender, int &NextState);

class PASCALIMPLEMENTATION TApdCustomActionState : public Adstmach::TApdCustomState
{
	typedef Adstmach::TApdCustomState inherited;
	
private:
	System::UnicodeString FTitle;
	Vcl::Graphics::TFont* FTitleFont;
	TApdOnStartAction FOnStartAction;
	TApdOnSelectNextState FOnSelectNextState;
	
protected:
	virtual void __fastcall Activate(void);
	virtual void __fastcall Deactivate(void);
	virtual void __fastcall FinishAction(int NextState);
	System::Uitypes::TColor __fastcall GetTitleColor(void);
	void __fastcall SetTitle(const System::UnicodeString v);
	void __fastcall SetTitleColor(const System::Uitypes::TColor v);
	void __fastcall SetTitleFont(Vcl::Graphics::TFont* const v);
	virtual void __fastcall StartAction(void) = 0 ;
	
public:
	__fastcall virtual TApdCustomActionState(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomActionState(void);
	void __fastcall AutoSelectNextState(bool Error);
	virtual void __fastcall Paint(void);
	__property System::UnicodeString Title = {read=FTitle, write=SetTitle};
	__property System::Uitypes::TColor TitleColor = {read=GetTitleColor, write=SetTitleColor, nodefault};
	__property Vcl::Graphics::TFont* TitleFont = {read=FTitleFont, write=SetTitleFont};
	__property TApdOnSelectNextState OnSelectNextState = {read=FOnSelectNextState, write=FOnSelectNextState};
	__property TApdOnStartAction OnStartAction = {read=FOnStartAction, write=FOnStartAction};
	
__published:
	__property Conditions;
};


class PASCALIMPLEMENTATION TApdActionState : public TApdCustomActionState
{
	typedef TApdCustomActionState inherited;
	
public:
	virtual void __fastcall FinishAction(int NextState);
	
__published:
	__property Title = {default=0};
	__property TitleColor;
	__property TitleFont;
	__property OnGetData;
	__property OnGetDataString;
	__property OnStartAction;
	__property ActiveColor;
	__property Caption;
	__property Font;
	__property Glyph;
	__property GlyphCells;
	__property InactiveColor;
	__property Movable = {default=0};
	__property OutputOnActivate = {default=0};
public:
	/* TApdCustomActionState.Create */ inline __fastcall virtual TApdActionState(System::Classes::TComponent* AOwner) : TApdCustomActionState(AOwner) { }
	/* TApdCustomActionState.Destroy */ inline __fastcall virtual ~TApdActionState(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adstst */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTST)
using namespace Adstst;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdststHPP
