// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdMeter.pas' rev: 32.00 (Windows)

#ifndef AdmeterHPP
#define AdmeterHPP

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
#include <Vcl.Menus.hpp>
#include <Vcl.Dialogs.hpp>
#include <OoMisc.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Admeter
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdMeter;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TBevelStyle : unsigned char { bsLowered, bsRaised, bsNone };

class PASCALIMPLEMENTATION TApdMeter : public Oomisc::TApdBaseGraphicControl
{
	typedef Oomisc::TApdBaseGraphicControl inherited;
	
private:
	System::Uitypes::TColor FBarColor;
	System::Uitypes::TColor FBevelColor1;
	System::Uitypes::TColor FBevelColor2;
	TBevelStyle FBevelStyle;
	int FMax;
	int FMin;
	System::Classes::TNotifyEvent FOnPosChange;
	int FPosition;
	int FSegments;
	int FStep;
	bool NeedPartial;
	int PartialSize;
	void __fastcall SetBarColor(System::Uitypes::TColor Value);
	void __fastcall SetBevelStyle(TBevelStyle Value);
	void __fastcall SetBevelColor1(System::Uitypes::TColor Value);
	void __fastcall SetBevelColor2(System::Uitypes::TColor Value);
	void __fastcall SetPosition(int Value);
	void __fastcall SetStep(int Value);
	
protected:
	DYNAMIC void __fastcall DoOnPosChange(void);
	virtual void __fastcall Paint(void);
	void __fastcall UpdatePosition(bool Force);
	
public:
	__fastcall virtual TApdMeter(System::Classes::TComponent* AOwner);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	
__published:
	__property System::Uitypes::TColor BarColor = {read=FBarColor, write=SetBarColor, default=-16777203};
	__property System::Uitypes::TColor BevelColor1 = {read=FBevelColor1, write=SetBevelColor1, default=-16777196};
	__property System::Uitypes::TColor BevelColor2 = {read=FBevelColor2, write=SetBevelColor2, default=-16777200};
	__property TBevelStyle BevelStyle = {read=FBevelStyle, write=SetBevelStyle, default=0};
	__property int Max = {read=FMax, write=FMax, default=100};
	__property int Min = {read=FMin, write=FMin, default=0};
	__property int Position = {read=FPosition, write=SetPosition, nodefault};
	__property int Step = {read=FStep, write=SetStep, default=8};
	__property System::Classes::TNotifyEvent OnPosChange = {read=FOnPosChange, write=FOnPosChange};
	__property Align = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TGraphicControl.Destroy */ inline __fastcall virtual ~TApdMeter(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const int admDefBarColor = int(-16777203);
static const int admDefBevelColor1 = int(-16777196);
static const int admDefBevelColor2 = int(-16777200);
static const System::Int8 admDefMeterHeight = System::Int8(0x10);
static const System::Int8 admDefMax = System::Int8(0x64);
static const System::Int8 admDefMin = System::Int8(0x0);
static const System::Int8 admDefStep = System::Int8(0x8);
static const System::Byte admDefMeterWidth = System::Byte(0x96);
}	/* namespace Admeter */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADMETER)
using namespace Admeter;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdmeterHPP
