// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwFView.pas' rev: 32.00 (Windows)

#ifndef AwfviewHPP
#define AwfviewHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <OoMisc.hpp>
#include <AwFaxCvt.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awfview
{
//-- forward type declarations -----------------------------------------------
struct wMsg;
class DELPHICLASS TViewer;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<Oomisc::TMemoryBitmapDesc, 5460> TFax;

typedef TFax *PFax;

typedef NativeInt __stdcall (*TViewerWndProc)(HWND hWnd, unsigned Msg, NativeUInt wParam, NativeInt lParam);

struct DECLSPEC_DRECORD wMsg
{
public:
	HWND hWindow;
	unsigned Message;
	
public:
	union
	{
		struct 
		{
			System::Word wParamLo;
			System::Word wParamHi;
			System::Word lParamLo;
			System::Word lParamHi;
		};
		struct 
		{
			NativeUInt wParam;
			NativeInt lParam;
		};
		
	};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TViewer : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	HWND vWnd;
	Oomisc::TUnpackFax *vUnpacker;
	TFax *vImage;
	unsigned vUnpPage;
	System::LongBool vLoadWholeFax;
	HICON vBusyCursor;
	System::LongBool vDragDrop;
	int vFGColor;
	int vBGCOlor;
	unsigned vScaledWidth;
	unsigned vScaledHeight;
	int vVScrollInc;
	int vHScrollInc;
	System::LongBool vSizing;
	System::LongBool vVScrolling;
	System::LongBool vHScrolling;
	unsigned vNumPages;
	unsigned vOnPage;
	unsigned vTopRow;
	unsigned vLeftOfs;
	unsigned vMaxVScroll;
	unsigned vMaxHScroll;
	unsigned vHMult;
	unsigned vHDiv;
	unsigned vVMult;
	unsigned vVDiv;
	unsigned vRotateDir;
	System::LongBool vMarked;
	System::LongBool vCaptured;
	unsigned vAnchorCorner;
	System::LongBool vOutsideEdge;
	unsigned vMarkTimer;
	System::Types::TRect vMarkRect;
	System::LongBool vCtrlDown;
	TViewerWndProc vDefWndProc;
	System::UnicodeString vFileName;
	System::UnicodeString vComponentName;
	bool vUpdating;
	bool vDesigning;
	__fastcall TViewer(HWND AWnd);
	__fastcall virtual ~TViewer(void);
	void __fastcall vAllocFax(unsigned NumPages);
	void __fastcall vDisposeFax(void);
	void __fastcall vInitScrollbars(void);
	void __fastcall vUpdateScrollThumb(System::LongBool Vert);
	void __fastcall vCalcMaxScrollPos(void);
	void __fastcall vScrollUpPrim(unsigned Delta);
	void __fastcall vScrollDownPrim(unsigned Delta);
	void __fastcall vScrollLeftPrim(unsigned Delta);
	void __fastcall vScrollRightPrim(unsigned Delta);
	void __fastcall vScrollUp(void);
	void __fastcall vScrollDown(void);
	void __fastcall vScrollLeft(void);
	void __fastcall vScrollRight(void);
	void __fastcall vJumpUp(void);
	void __fastcall vJumpDown(void);
	void __fastcall vJumpLeft(void);
	void __fastcall vJumpRight(void);
	void __fastcall vHomeVertical(void);
	void __fastcall vEndVertical(void);
	void __fastcall vHomeHorizontal(void);
	void __fastcall vEndHorizontal(void);
	void __fastcall vInitPage(void);
	void __fastcall vPageUp(void);
	void __fastcall vPageDown(void);
	void __fastcall vFirstPage(void);
	void __fastcall vLastPage(void);
	int __fastcall vRotatePage(const unsigned PageNum, const unsigned Direction);
	void __fastcall vUpdateMarkRect(const System::Types::TRect &Client, int X, int Y);
	void __fastcall vCopyToClipboard(void);
	void __fastcall vInvalidateAll(void);
	void __fastcall vPaint(HDC PaintDC, tagPAINTSTRUCT &PaintInfo);
	void __fastcall vGetMarkClientIntersection(System::Types::TRect &R, const System::Types::TRect &Mark);
	void __fastcall vInitDragDrop(System::LongBool Enabled);
	int __fastcall apwViewSetFile(System::UnicodeString FName);
	void __fastcall apwViewSetFG(int Color);
	void __fastcall apwViewSetBG(int Color);
	void __fastcall apwViewSetScale(Oomisc::PScaleSettings Settings);
	int __fastcall apwViewSetWhitespace(unsigned FromLines, unsigned ToLines);
	void __fastcall apwViewSetScroll(unsigned HScroll, unsigned VScroll);
	int __fastcall apwViewSelectAll(void);
	int __fastcall apwViewSelect(System::Types::PRect R);
	int __fastcall apwViewCopy(void);
	HBITMAP __fastcall apwViewGetBitmap(unsigned Page, System::Types::PPoint Point);
	unsigned __fastcall apwViewGetNumPages(void);
	void __fastcall apwViewStartUpdate(void);
	void __fastcall apwViewEndUpdate(void);
	void __fastcall apwViewSetWndProc(wMsg &Msg);
	int __fastcall apwViewGotoPage(unsigned Page);
	int __fastcall apwViewGetCurPage(void);
	void __fastcall apwViewSetDesignMode(System::WideChar * Name);
	int __fastcall apwViewSetRotation(unsigned Direction);
	void __fastcall apwViewSetAutoScale(System::Word Kind);
	void __fastcall apwViewGetPageDim(System::Types::PRect R);
	System::Word __fastcall apwViewGetPageFlags(void);
	int __fastcall apwViewSetLoadWholeFax(System::LongBool LoadWhole);
	void __fastcall apwViewSetBusyCursor(HICON NewCursor);
	void __fastcall wmPaint(wMsg &Msg);
	int __fastcall wmSize(wMsg &Msg);
	int __fastcall wmGetDlgCode(wMsg &Msg);
	int __fastcall wmKeyDown(wMsg &Msg);
	int __fastcall wmKeyUp(wMsg &Msg);
	void __fastcall wmLButtonDown(wMsg &Msg);
	void __fastcall wmLButtonUp(wMsg &Msg);
	void __fastcall wmMouseMove(wMsg &Msg);
	void __fastcall wmTimer(wMsg &Msg);
	void __fastcall wmVScroll(wMsg &Msg);
	void __fastcall wmHScroll(wMsg &Msg);
	void __fastcall wmDropFiles(wMsg &Msg);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word MaxFaxPages = System::Word(0x1554);
extern DELPHI_PACKAGE void __fastcall RegisterFaxViewerClass(bool Designing);
}	/* namespace Awfview */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWFVIEW)
using namespace Awfview;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwfviewHPP
