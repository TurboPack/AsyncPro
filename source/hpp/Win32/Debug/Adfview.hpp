// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFView.pas' rev: 32.00 (Windows)

#ifndef AdfviewHPP
#define AdfviewHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <OoMisc.hpp>
#include <AwFView.hpp>
#include <AdExcept.hpp>
#include <AdFaxCvt.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adfview
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomFaxViewer;
class DELPHICLASS TApdFaxViewer;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TViewerRotation : unsigned char { vr0, vr90, vr180, vr270 };

typedef void __fastcall (__closure *TViewerFileDropEvent)(System::TObject* Sender, System::UnicodeString FileName);

typedef void __fastcall (__closure *TViewerErrorEvent)(System::TObject* Sender, int ErrorCode);

class PASCALIMPLEMENTATION TApdCustomFaxViewer : public Oomisc::TApdBaseWinControl
{
	typedef Oomisc::TApdBaseWinControl inherited;
	
protected:
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	System::Uitypes::TColor FFGColor;
	System::Uitypes::TColor FBGColor;
	bool FScaling;
	unsigned FHorizMult;
	unsigned FHorizDiv;
	unsigned FVertMult;
	unsigned FVertDiv;
	Adfaxcvt::TAutoScaleMode FAutoScaleMode;
	bool FWhitespaceCompression;
	unsigned FWhitespaceFrom;
	unsigned FWhitespaceTo;
	unsigned FHorizScroll;
	unsigned FVertScroll;
	System::UnicodeString FFileName;
	bool FAcceptDragged;
	bool FLoadWholeFax;
	TViewerRotation FRotation;
	System::Uitypes::TCursor FBusyCursor;
	TViewerFileDropEvent FFileDrop;
	System::Classes::TNotifyEvent FPageChange;
	TViewerErrorEvent FViewerError;
	bool HasBeenCreated;
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle NewStyle);
	void __fastcall SetFGColor(const System::Uitypes::TColor NewColor);
	void __fastcall SetBGColor(const System::Uitypes::TColor NewColor);
	void __fastcall SetScaling(const bool NewScaling);
	void __fastcall SetHorizMult(const unsigned NewHorizMult);
	void __fastcall SetHorizDiv(const unsigned NewHorizDiv);
	void __fastcall SetVertMult(const unsigned NewVertMult);
	void __fastcall SetVertDiv(const unsigned NewVertDiv);
	void __fastcall SetAutoScaleMode(const Adfaxcvt::TAutoScaleMode NewAutoScaleMode);
	void __fastcall SetWhitespaceCompression(const bool NewCompression);
	void __fastcall SetWhitespaceFrom(const unsigned NewWhitespaceFrom);
	void __fastcall SetWhitespaceTo(const unsigned NewWhitespaceTo);
	void __fastcall SetHorizScroll(const unsigned NewHorizScroll);
	void __fastcall SetVertScroll(const unsigned NewVertScroll);
	void __fastcall SetAcceptDragged(const bool NewAccept);
	void __fastcall SetLoadWholeFax(const bool NewLoadWholeFax);
	void __fastcall SetFileName(const System::UnicodeString NewFileName);
	void __fastcall SetRotation(const TViewerRotation NewRotation);
	void __fastcall SetBusyCursor(const System::Uitypes::TCursor NewBusyCursor);
	void __fastcall SetActivePage(const unsigned NewPage);
	Vcl::Graphics::TBitmap* __fastcall GetPageBitmaps(const int PageNum);
	unsigned __fastcall GetNumPages(void);
	unsigned __fastcall GetActivePage(void);
	unsigned __fastcall GetPageWidth(void);
	unsigned __fastcall GetPageHeight(void);
	System::Word __fastcall GetPageFlags(void);
	virtual void __fastcall FileDropped(void);
	MESSAGE void __fastcall PageChange(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ViewerError(Winapi::Messages::TMessage &Msg);
	void __fastcall FillScaleSettings(Oomisc::TScaleSettings &Settings);
	MESSAGE void __fastcall wmDropFiles(Awfview::wMsg &Msg);
	HIDESBASE MESSAGE void __fastcall wmEraseBkGnd(Winapi::Messages::TMessage &Msg);
	
public:
	__fastcall virtual TApdCustomFaxViewer(System::Classes::TComponent* AOwner);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	void __fastcall FirstPage(void);
	void __fastcall LastPage(void);
	void __fastcall NextPage(void);
	void __fastcall PrevPage(void);
	void __fastcall SelectRegion(const System::Types::TRect &R);
	void __fastcall SelectImage(void);
	void __fastcall CopyToClipBoard(void);
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property System::Uitypes::TColor FGColor = {read=FFGColor, write=SetFGColor, default=0};
	__property System::Uitypes::TColor BGColor = {read=FBGColor, write=SetBGColor, default=16777215};
	__property bool Scaling = {read=FScaling, write=SetScaling, nodefault};
	__property unsigned HorizMult = {read=FHorizMult, write=SetHorizMult, default=1};
	__property unsigned HorizDiv = {read=FHorizDiv, write=SetHorizDiv, default=1};
	__property unsigned VertMult = {read=FVertMult, write=SetVertMult, default=1};
	__property unsigned VertDiv = {read=FVertDiv, write=SetVertDiv, default=1};
	__property Adfaxcvt::TAutoScaleMode AutoScaleMode = {read=FAutoScaleMode, write=SetAutoScaleMode, default=1};
	__property bool WhitespaceCompression = {read=FWhitespaceCompression, write=SetWhitespaceCompression, default=0};
	__property unsigned WhitespaceFrom = {read=FWhitespaceFrom, write=SetWhitespaceFrom, default=0};
	__property unsigned WhitespaceTo = {read=FWhitespaceTo, write=SetWhitespaceTo, default=0};
	__property unsigned HorizScroll = {read=FHorizScroll, write=SetHorizScroll, default=8};
	__property unsigned VertScroll = {read=FVertScroll, write=SetVertScroll, default=8};
	__property bool AcceptDragged = {read=FAcceptDragged, write=SetAcceptDragged, default=1};
	__property bool LoadWholeFax = {read=FLoadWholeFax, write=SetLoadWholeFax, default=0};
	__property System::UnicodeString FileName = {read=FFileName, write=SetFileName};
	__property TViewerRotation Rotation = {read=FRotation, write=SetRotation, default=0};
	__property System::Uitypes::TCursor BusyCursor = {read=FBusyCursor, write=SetBusyCursor, default=0};
	__property Vcl::Graphics::TBitmap* PageBitmaps[const int Index] = {read=GetPageBitmaps};
	__property unsigned NumPages = {read=GetNumPages, nodefault};
	__property unsigned ActivePage = {read=GetActivePage, write=SetActivePage, nodefault};
	__property unsigned PageWidth = {read=GetPageWidth, nodefault};
	__property unsigned PageHeight = {read=GetPageHeight, nodefault};
	__property System::Word PageFlags = {read=GetPageFlags, nodefault};
	__property TViewerFileDropEvent OnDropFile = {read=FFileDrop, write=FFileDrop};
	__property System::Classes::TNotifyEvent OnPageChange = {read=FPageChange, write=FPageChange};
	__property TViewerErrorEvent OnViewerError = {read=FViewerError, write=FViewerError};
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdCustomFaxViewer(HWND ParentWindow) : Oomisc::TApdBaseWinControl(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TApdCustomFaxViewer(void) { }
	
};


class PASCALIMPLEMENTATION TApdFaxViewer : public TApdCustomFaxViewer
{
	typedef TApdCustomFaxViewer inherited;
	
__published:
	__property Version = {default=0};
	__property BorderStyle = {default=1};
	__property FGColor = {default=0};
	__property BGColor = {default=16777215};
	__property Scaling;
	__property HorizMult = {default=1};
	__property HorizDiv = {default=1};
	__property VertMult = {default=1};
	__property VertDiv = {default=1};
	__property AutoScaleMode = {default=1};
	__property WhitespaceCompression = {default=0};
	__property WhitespaceFrom = {default=0};
	__property WhitespaceTo = {default=0};
	__property HorizScroll = {default=8};
	__property VertScroll = {default=8};
	__property AcceptDragged = {default=1};
	__property LoadWholeFax = {default=0};
	__property BusyCursor = {default=0};
	__property FileName = {default=0};
	__property OnDropFile;
	__property OnPageChange;
	__property OnViewerError;
	__property Align = {default=0};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TApdCustomFaxViewer.Create */ inline __fastcall virtual TApdFaxViewer(System::Classes::TComponent* AOwner) : TApdCustomFaxViewer(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdFaxViewer(HWND ParentWindow) : TApdCustomFaxViewer(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TApdFaxViewer(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const Vcl::Forms::TFormBorderStyle afvDefViewBorderStyle = (Vcl::Forms::TFormBorderStyle)(1);
static const int afvDefFGColor = int(0);
static const int afvDefBGColor = int(16777215);
static const bool afvDefScaling = false;
static const System::Int8 afvDefHorizMult = System::Int8(0x1);
static const System::Int8 afvDefHorizDiv = System::Int8(0x1);
static const System::Int8 afvDefVertMult = System::Int8(0x1);
static const System::Int8 afvDefVertDiv = System::Int8(0x1);
static const Adfaxcvt::TAutoScaleMode afvDefViewAutoScaleMode = (Adfaxcvt::TAutoScaleMode)(1);
static const bool afvDefWhitespaceCompression = false;
static const System::Int8 afvDefWhitespaceFrom = System::Int8(0x0);
static const System::Int8 afvDefWhitespaceTo = System::Int8(0x0);
static const System::Int8 afvDefHorizScroll = System::Int8(0x8);
static const System::Int8 afvDefVertScroll = System::Int8(0x8);
#define afvDefFileName L""
static const bool afvDefAcceptDragged = true;
static const bool afvDefLoadWholeFax = false;
static const System::Int8 afvDefViewerHeight = System::Int8(0x32);
static const System::Int8 afvDefViewerWidth = System::Int8(0x64);
static const TViewerRotation afvDefRotation = (TViewerRotation)(0);
static const short afvDefBusyCursor = short(0);
}	/* namespace Adfview */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFVIEW)
using namespace Adfview;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfviewHPP
