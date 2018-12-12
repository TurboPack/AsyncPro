// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFaxPrn.pas' rev: 32.00 (Windows)

#ifndef AdfaxprnHPP
#define AdfaxprnHPP

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
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Printers.hpp>
#include <OoMisc.hpp>
#include <AdFaxCvt.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adfaxprn
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomFaxPrinterLog;
class DELPHICLASS TApdCustomFaxPrinterMargin;
class DELPHICLASS TApdAbstractFaxPrinterStatus;
class DELPHICLASS TApdFaxPrinterLog;
class DELPHICLASS TApdFaxPrinterMargin;
class DELPHICLASS TApdCustomFaxPrinter;
class DELPHICLASS TApdFaxPrinter;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TFaxPLCode : unsigned char { lcStart, lcFinish, lcAborted, lcFailed };

enum DECLSPEC_DENUM TFaxPrintScale : unsigned char { psNone, psFitToPage };

enum DECLSPEC_DENUM TFaxPrintProgress : unsigned char { ppIdle, ppComposing, ppRendering, ppSubmitting, ppConverting };

typedef void __fastcall (__closure *TFaxPrnNextPageEvent)(System::TObject* Sender, System::Word CP, System::Word TP);

typedef void __fastcall (__closure *TFaxPLEvent)(System::TObject* Sender, TFaxPLCode FaxPLCode);

typedef void __fastcall (__closure *TFaxPrintStatusEvent)(System::TObject* Sender, TFaxPrintProgress StatusCode);

class PASCALIMPLEMENTATION TApdCustomFaxPrinterLog : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	TApdCustomFaxPrinter* FFaxPrinter;
	System::UnicodeString FLogFileName;
	
public:
	__fastcall virtual TApdCustomFaxPrinterLog(System::Classes::TComponent* AOwner);
	void __fastcall UpdateLog(const TFaxPLCode LogCode);
	__property TApdCustomFaxPrinter* FaxPrinter = {read=FFaxPrinter};
	__property System::UnicodeString LogFileName = {read=FLogFileName, write=FLogFileName};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TApdCustomFaxPrinterLog(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdCustomFaxPrinterMargin : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::UnicodeString FCaption;
	bool FEnabled;
	Vcl::Graphics::TFont* FFont;
	System::Word FHeight;
	
public:
	__fastcall virtual TApdCustomFaxPrinterMargin(void);
	__fastcall virtual ~TApdCustomFaxPrinterMargin(void);
	void __fastcall SetFont(Vcl::Graphics::TFont* const NewFont);
	__property System::UnicodeString Caption = {read=FCaption, write=FCaption};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property System::Word Height = {read=FHeight, write=FHeight, default=0};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdAbstractFaxPrinterStatus : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	Vcl::Forms::TForm* FDisplay;
	Vcl::Forms::TPosition FPosition;
	bool FCtl3D;
	bool FVisible;
	System::UnicodeString FCaption;
	TApdCustomFaxPrinter* FFaxPrinter;
	void __fastcall SetPosition(const Vcl::Forms::TPosition Value);
	void __fastcall SetCtl3D(const bool Value);
	void __fastcall SetVisible(const bool Value);
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall GetProperties(void);
	void __fastcall Show(void);
	
public:
	__fastcall virtual TApdAbstractFaxPrinterStatus(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdAbstractFaxPrinterStatus(void);
	virtual void __fastcall UpdateDisplay(bool First, bool Last) = 0 ;
	DYNAMIC void __fastcall CreateDisplay(void) = 0 ;
	DYNAMIC void __fastcall DestroyDisplay(void) = 0 ;
	__property Vcl::Forms::TForm* Display = {read=FDisplay, write=FDisplay};
	__property TApdCustomFaxPrinter* FaxPrinter = {read=FFaxPrinter};
	
__published:
	__property Vcl::Forms::TPosition Position = {read=FPosition, write=SetPosition, nodefault};
	__property bool Ctl3D = {read=FCtl3D, write=SetCtl3D, nodefault};
	__property bool Visible = {read=FVisible, write=SetVisible, nodefault};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
};


class PASCALIMPLEMENTATION TApdFaxPrinterLog : public TApdCustomFaxPrinterLog
{
	typedef TApdCustomFaxPrinterLog inherited;
	
__published:
	__property LogFileName = {default=0};
public:
	/* TApdCustomFaxPrinterLog.Create */ inline __fastcall virtual TApdFaxPrinterLog(System::Classes::TComponent* AOwner) : TApdCustomFaxPrinterLog(AOwner) { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TApdFaxPrinterLog(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdFaxPrinterMargin : public TApdCustomFaxPrinterMargin
{
	typedef TApdCustomFaxPrinterMargin inherited;
	
__published:
	__property Caption = {default=0};
	__property Enabled;
	__property Font;
public:
	/* TApdCustomFaxPrinterMargin.Create */ inline __fastcall virtual TApdFaxPrinterMargin(void) : TApdCustomFaxPrinterMargin() { }
	/* TApdCustomFaxPrinterMargin.Destroy */ inline __fastcall virtual ~TApdFaxPrinterMargin(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdCustomFaxPrinter : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
public:
	System::UnicodeString FFileName;
	System::Word FTotalFaxPages;
	System::Word FCurrentPrintingPage;
	System::Word FFirstPageToPrint;
	System::Word FLastPageToPrint;
	Adfaxcvt::TFaxResolution FFaxResolution;
	Adfaxcvt::TFaxWidth FFaxWidth;
	TFaxPrintScale FPrintScale;
	bool FMultiPage;
	TApdAbstractFaxPrinterStatus* FStatusDisplay;
	TFaxPrintProgress FFaxPrintProgress;
	TApdFaxPrinterLog* FFaxPrinterLog;
	Vcl::Dialogs::TPrintDialog* FPrintDialog;
	Adfaxcvt::TApdFaxUnpacker* FFaxUnpack;
	TApdFaxPrinterMargin* FFaxHeader;
	TApdFaxPrinterMargin* FFaxFooter;
	TFaxPrnNextPageEvent FOnNextPage;
	TFaxPLEvent FOnFaxPrintLog;
	TFaxPrintStatusEvent FOnFaxPrintStatus;
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetCaption(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetCaption(void);
	void __fastcall SetFaxFileName(const System::UnicodeString Value);
	void __fastcall SetStatusDisplay(TApdAbstractFaxPrinterStatus* const Value);
	void __fastcall SetFaxPrintLog(TApdFaxPrinterLog* const Value);
	System::UnicodeString __fastcall ReplaceHFParams(System::UnicodeString Value, System::Word Page);
	virtual void __fastcall CreateFaxHeader(Vcl::Graphics::TCanvas* FaxCanvas, System::Word PN, System::Types::TRect &AreaRect);
	virtual void __fastcall CreateFaxFooter(Vcl::Graphics::TCanvas* FaxCanvas, System::Word PN, System::Types::TRect &AreaRect);
	void __fastcall SetFaxPrintProgress(const TFaxPrintProgress NewProgress);
	void __fastcall FaxPrintLog(TFaxPLCode LogCode);
	
public:
	__fastcall virtual TApdCustomFaxPrinter(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomFaxPrinter(void);
	bool __fastcall PrintSetup(void);
	void __fastcall PrintFax(void);
	void __fastcall PrintAbort(void);
	__property Adfaxcvt::TFaxWidth FaxWidth = {read=FFaxWidth, default=0};
	__property Adfaxcvt::TFaxResolution FaxResolution = {read=FFaxResolution, default=0};
	__property System::Word TotalFaxPages = {read=FTotalFaxPages, default=0};
	__property System::Word CurrentPrintingPage = {read=FCurrentPrintingPage, default=0};
	__property System::Word FirstPageToPrint = {read=FFirstPageToPrint, write=FFirstPageToPrint, default=0};
	__property System::Word LastPageToPrint = {read=FLastPageToPrint, write=FLastPageToPrint, default=0};
	__property TFaxPrintProgress PrintProgress = {read=FFaxPrintProgress, write=FFaxPrintProgress, nodefault};
	__property System::UnicodeString Caption = {read=GetCaption, write=SetCaption};
	__property TApdFaxPrinterMargin* FaxFooter = {read=FFaxFooter, write=FFaxFooter};
	__property TApdFaxPrinterMargin* FaxHeader = {read=FFaxHeader, write=FFaxHeader};
	__property TApdFaxPrinterLog* FaxPrinterLog = {read=FFaxPrinterLog, write=SetFaxPrintLog};
	__property System::UnicodeString FileName = {read=FFileName, write=SetFaxFileName};
	__property bool MultiPage = {read=FMultiPage, write=FMultiPage, nodefault};
	__property TFaxPrintScale PrintScale = {read=FPrintScale, write=FPrintScale, default=1};
	__property TApdAbstractFaxPrinterStatus* StatusDisplay = {read=FStatusDisplay, write=SetStatusDisplay};
	__property TFaxPrnNextPageEvent OnNextPage = {read=FOnNextPage, write=FOnNextPage};
	__property TFaxPLEvent OnFaxPrintLog = {read=FOnFaxPrintLog, write=FOnFaxPrintLog};
	__property TFaxPrintStatusEvent OnFaxPrintStatus = {read=FOnFaxPrintStatus, write=FOnFaxPrintStatus};
};


class PASCALIMPLEMENTATION TApdFaxPrinter : public TApdCustomFaxPrinter
{
	typedef TApdCustomFaxPrinter inherited;
	
__published:
	__property Caption = {default=0};
	__property FaxFooter;
	__property FaxHeader;
	__property FaxPrinterLog;
	__property FileName = {default=0};
	__property MultiPage;
	__property PrintScale = {default=1};
	__property StatusDisplay;
	__property OnNextPage;
	__property OnFaxPrintLog;
	__property OnFaxPrintStatus;
public:
	/* TApdCustomFaxPrinter.Create */ inline __fastcall virtual TApdFaxPrinter(System::Classes::TComponent* AOwner) : TApdCustomFaxPrinter(AOwner) { }
	/* TApdCustomFaxPrinter.Destroy */ inline __fastcall virtual ~TApdFaxPrinter(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define afpDefFPLFileName L"FAXPRINT.LOG"
#define afpDefFaxHeaderCaption L"FILE: $F"
static const bool afpDefFaxHeaderEnabled = true;
#define afpDefFaxFooterCaption L"PAGE: $P of $N"
static const bool afpDefFaxFooterEnabled = true;
#define afpDefFaxPrnCaption L"APro Fax Printer"
static const TFaxPrintScale afpDefFaxPrintScale = (TFaxPrintScale)(1);
static const bool afpDefFaxMultiPage = false;
}	/* namespace Adfaxprn */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFAXPRN)
using namespace Adfaxprn;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfaxprnHPP
