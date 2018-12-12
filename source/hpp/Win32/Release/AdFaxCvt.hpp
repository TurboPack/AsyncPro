// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFaxCvt.pas' rev: 32.00 (Windows)

#ifndef AdfaxcvtHPP
#define AdfaxcvtHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Printers.hpp>
#include <Winapi.Messages.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Vcl.Forms.hpp>
#include <System.Win.Registry.hpp>
#include <System.IniFiles.hpp>
#include <OoMisc.hpp>
#include <AwFaxCvt.hpp>
#include <AdExcept.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adfaxcvt
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomFaxConverter;
class DELPHICLASS TApdFaxConverter;
class DELPHICLASS TApdCustomFaxUnpacker;
class DELPHICLASS TApdFaxUnpacker;
class DELPHICLASS EApdAPFGraphicError;
class DELPHICLASS TApdAPFGraphic;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TFaxInputDocumentType : unsigned char { idNone, idText, idTextEx, idTiff, idPcx, idDcx, idBmp, idBitmap, idUser, idShell };

enum DECLSPEC_DENUM TFaxCvtOptions : unsigned char { coDoubleWidth, coHalfHeight, coCenterImage, coYield, coYieldOften };

typedef System::Set<TFaxCvtOptions, TFaxCvtOptions::coDoubleWidth, TFaxCvtOptions::coYieldOften> TFaxCvtOptionsSet;

enum DECLSPEC_DENUM TFaxResolution : unsigned char { frNormal, frHigh };

enum DECLSPEC_DENUM TFaxWidth : unsigned char { fwNormal, fwWide };

enum DECLSPEC_DENUM TFaxFont : unsigned char { ffStandard, ffSmall };

typedef void __fastcall (__closure *TFaxStatusEvent)(System::TObject* F, bool Starting, bool Ending, int PagesConverted, int LinesConverted, int BytesConverted, int BytesToConvert, bool &Abort);

typedef void __fastcall (__closure *TFaxOutputLineEvent)(System::TObject* F, System::Sysutils::PByteArray Data, int Len, bool EndOfPage, bool MorePages);

typedef void __fastcall (__closure *TFaxOpenFileEvent)(System::TObject* F, System::UnicodeString FName);

typedef void __fastcall (__closure *TFaxCloseFileEvent)(System::TObject* F);

typedef void __fastcall (__closure *TFaxReadLineEvent)(System::TObject* F, System::Sysutils::PByteArray Data, int &Len, bool &EndOfPage, bool &MorePages);

class PASCALIMPLEMENTATION TApdCustomFaxConverter : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	TFaxInputDocumentType FInputDocumentType;
	TFaxCvtOptionsSet FOptions;
	TFaxResolution FResolution;
	TFaxWidth FWidth;
	unsigned FTopMargin;
	unsigned FLeftMargin;
	unsigned FLinesPerPage;
	unsigned FTabStop;
	Vcl::Graphics::TFont* FEnhFont;
	TFaxFont FFontType;
	System::UnicodeString FFontFile;
	System::UnicodeString FDocumentFile;
	System::UnicodeString FOutFileName;
	System::UnicodeString FDefUserExtension;
	System::AnsiString FStationID;
	TFaxStatusEvent FStatus;
	TFaxOutputLineEvent FOutputLine;
	TFaxOpenFileEvent FOpenUserFile;
	TFaxCloseFileEvent FCloseUserFile;
	TFaxReadLineEvent FReadUserLine;
	TFaxInputDocumentType LastDocType;
	Oomisc::TAbsFaxCvt *Data;
	bool FileOpen;
	HWND PrnCallbackHandle;
	bool FWaitingForShell;
	bool FResetShellTimer;
	int FShellPageCount;
	bool FPadPage;
	void __fastcall CreateData(void);
	void __fastcall DestroyData(void);
	void __fastcall SetCvtOptions(const TFaxCvtOptionsSet NewOpts);
	void __fastcall SetDocumentFile(const System::UnicodeString NewFile);
	void __fastcall SetEnhFont(Vcl::Graphics::TFont* Value);
	void __fastcall ConvertToResolution(const System::UnicodeString FileName, TFaxResolution NewRes);
	void __fastcall ChangeDefPrinter(bool UseFax);
	void __fastcall ConvertShell(const System::UnicodeString FileName);
	void __fastcall PrnCallback(Winapi::Messages::TMessage &Msg);
	void __fastcall SetPadPage(const bool Value);
	
public:
	__fastcall virtual TApdCustomFaxConverter(System::Classes::TComponent* Owner);
	__fastcall virtual ~TApdCustomFaxConverter(void);
	__property TFaxInputDocumentType InputDocumentType = {read=FInputDocumentType, write=FInputDocumentType, default=0};
	__property TFaxCvtOptionsSet Options = {read=FOptions, write=SetCvtOptions, default=13};
	__property TFaxResolution Resolution = {read=FResolution, write=FResolution, default=0};
	__property TFaxWidth Width = {read=FWidth, write=FWidth, default=0};
	__property unsigned TopMargin = {read=FTopMargin, write=FTopMargin, default=0};
	__property unsigned LeftMargin = {read=FLeftMargin, write=FLeftMargin, default=50};
	__property unsigned LinesPerPage = {read=FLinesPerPage, write=FLinesPerPage, default=60};
	__property unsigned TabStop = {read=FTabStop, write=FTabStop, default=4};
	__property System::UnicodeString FontFile = {read=FFontFile, write=FFontFile};
	__property TFaxFont FontType = {read=FFontType, write=FFontType, nodefault};
	__property Vcl::Graphics::TFont* EnhFont = {read=FEnhFont, write=SetEnhFont};
	__property System::UnicodeString DocumentFile = {read=FDocumentFile, write=SetDocumentFile};
	__property System::UnicodeString OutFileName = {read=FOutFileName, write=FOutFileName};
	__property System::UnicodeString DefUserExtension = {read=FDefUserExtension, write=FDefUserExtension};
	__property System::AnsiString StationID = {read=FStationID, write=FStationID};
	__property bool PadPage = {read=FPadPage, write=SetPadPage, nodefault};
	__property TFaxStatusEvent OnStatus = {read=FStatus, write=FStatus};
	__property TFaxOutputLineEvent OnOutputLine = {read=FOutputLine, write=FOutputLine};
	__property TFaxOpenFileEvent OnOpenUserFile = {read=FOpenUserFile, write=FOpenUserFile};
	__property TFaxCloseFileEvent OnCloseUserFile = {read=FCloseUserFile, write=FCloseUserFile};
	__property TFaxReadLineEvent OnReadUserLine = {read=FReadUserLine, write=FReadUserLine};
	void __fastcall ConvertToFile(void);
	void __fastcall Convert(void);
	void __fastcall ConvertBitmapToFile(Vcl::Graphics::TBitmap* const Bmp);
	void __fastcall ConvertToHighRes(const System::UnicodeString FileName);
	void __fastcall ConvertToLowRes(const System::UnicodeString FileName);
	void __fastcall OpenFile(void);
	void __fastcall CloseFile(void);
	void __fastcall GetRasterLine(void *Buffer, int &BufLen, bool &EndOfPage, bool &MorePages);
	void __fastcall CompressRasterLine(void *Buffer, void *OutputData, int &OutLen);
	void __fastcall MakeEndOfPage(void *Buffer, int &BufLen);
	virtual void __fastcall Status(const bool Starting, const bool Ending, const int PagesConverted, const int LinesConverted, const int BytesToRead, const int BytesRead, bool &Abort);
	virtual void __fastcall OutputLine(void *Data, int Len, bool EndOfPage, bool MorePages);
	virtual void __fastcall OpenUserFile(const System::UnicodeString FName);
	virtual void __fastcall CloseUserFile(void);
	void __fastcall ReadUserLine(void *Data, int &Len, bool &EndOfPage, bool &MorePages);
};


class PASCALIMPLEMENTATION TApdFaxConverter : public TApdCustomFaxConverter
{
	typedef TApdCustomFaxConverter inherited;
	
__published:
	__property InputDocumentType = {default=0};
	__property Options = {default=13};
	__property Resolution = {default=0};
	__property Width = {default=0};
	__property TopMargin = {default=0};
	__property LeftMargin = {default=50};
	__property LinesPerPage = {default=60};
	__property TabStop = {default=4};
	__property EnhFont;
	__property FontFile = {default=0};
	__property FontType;
	__property DocumentFile = {default=0};
	__property OutFileName = {default=0};
	__property DefUserExtension = {default=0};
	__property OnStatus;
	__property OnOutputLine;
	__property OnOpenUserFile;
	__property OnCloseUserFile;
	__property OnReadUserLine;
public:
	/* TApdCustomFaxConverter.Create */ inline __fastcall virtual TApdFaxConverter(System::Classes::TComponent* Owner) : TApdCustomFaxConverter(Owner) { }
	/* TApdCustomFaxConverter.Destroy */ inline __fastcall virtual ~TApdFaxConverter(void) { }
	
};


enum DECLSPEC_DENUM TUnpackerOptions : unsigned char { uoYield, uoAbort };

typedef System::Set<TUnpackerOptions, TUnpackerOptions::uoYield, TUnpackerOptions::uoAbort> TUnpackerOptionsSet;

enum DECLSPEC_DENUM TAutoScaleMode : unsigned char { asNone, asDoubleHeight, asHalfWidth };

typedef void __fastcall (__closure *TUnpackOutputLineEvent)(System::TObject* Sender, bool Starting, bool Ending, System::Sysutils::PByteArray Data, int Len, int PageNum);

typedef void __fastcall (__closure *TUnpackStatusEvent)(System::TObject* Sender, System::UnicodeString FName, int PageNum, int BytesUnpacked, int BytesToUnpack);

class PASCALIMPLEMENTATION TApdCustomFaxUnpacker : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	TUnpackerOptionsSet FOptions;
	bool FWhitespaceCompression;
	unsigned FWhitespaceFrom;
	unsigned FWhitespaceTo;
	bool FScaling;
	unsigned FHorizMult;
	unsigned FHorizDiv;
	unsigned FVertMult;
	unsigned FVertDiv;
	TAutoScaleMode FAutoScaleMode;
	System::UnicodeString FInFileName;
	System::UnicodeString FOutFileName;
	TUnpackOutputLineEvent FOutputLine;
	TUnpackStatusEvent FStatus;
	Oomisc::TUnpackFax *Data;
	void __fastcall CreateData(void);
	void __fastcall DestroyData(void);
	virtual void __fastcall OutputLine(const bool Starting, const bool Ending, const System::Sysutils::PByteArray Data, const unsigned Len, const unsigned PageNum);
	virtual void __fastcall Status(const System::UnicodeString FName, const unsigned PageNum, const int BytesUnpacked, const int BytesToUnpack);
	void __fastcall SetHorizMult(const unsigned NewHorizMult);
	void __fastcall SetHorizDiv(const unsigned NewHorizDiv);
	void __fastcall SetVertMult(const unsigned NewVertMult);
	void __fastcall SetVertDiv(const unsigned NewVertDiv);
	unsigned __fastcall GetNumPages(void);
	TFaxResolution __fastcall GetFaxResolution(void);
	TFaxWidth __fastcall GetFaxWidth(void);
	void __fastcall SetInFileName(const System::UnicodeString NewName);
	void __fastcall SetUnpackerOptions(const TUnpackerOptionsSet NewUnpackerOptions);
	System::UnicodeString __fastcall InFNameZ(void);
	System::UnicodeString __fastcall OutFNameZ(void);
	
public:
	__fastcall virtual TApdCustomFaxUnpacker(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomFaxUnpacker(void);
	void __fastcall UnpackPage(const unsigned Page);
	void __fastcall UnpackFile(void);
	Vcl::Graphics::TBitmap* __fastcall UnpackPageToBitmap(const unsigned Page);
	Vcl::Graphics::TBitmap* __fastcall UnpackFileToBitmap(void);
	void __fastcall UnpackPageToPcx(const unsigned Page);
	void __fastcall UnpackFileToPcx(void);
	void __fastcall UnpackPageToDcx(const unsigned Page);
	void __fastcall UnpackFileToDcx(void);
	void __fastcall UnpackPageToTiff(const unsigned Page);
	void __fastcall UnpackFileToTiff(void);
	void __fastcall UnpackPageToBmp(const unsigned Page);
	void __fastcall UnpackFileToBmp(void);
	void __fastcall ExtractPage(const unsigned Page);
	__property TUnpackerOptionsSet Options = {read=FOptions, write=SetUnpackerOptions, default=1};
	__property bool WhitespaceCompression = {read=FWhitespaceCompression, write=FWhitespaceCompression, default=0};
	__property unsigned WhitespaceFrom = {read=FWhitespaceFrom, write=FWhitespaceFrom, default=0};
	__property unsigned WhitespaceTo = {read=FWhitespaceTo, write=FWhitespaceTo, default=0};
	__property bool Scaling = {read=FScaling, write=FScaling, default=0};
	__property unsigned HorizMult = {read=FHorizMult, write=SetHorizMult, default=1};
	__property unsigned HorizDiv = {read=FHorizDiv, write=SetHorizDiv, default=1};
	__property unsigned VertMult = {read=FVertMult, write=SetVertMult, default=1};
	__property unsigned VertDiv = {read=FVertDiv, write=SetVertDiv, default=1};
	__property TAutoScaleMode AutoScaleMode = {read=FAutoScaleMode, write=FAutoScaleMode, nodefault};
	__property System::UnicodeString InFileName = {read=FInFileName, write=SetInFileName};
	__property System::UnicodeString OutFileName = {read=FOutFileName, write=FOutFileName};
	__property unsigned NumPages = {read=GetNumPages, nodefault};
	__property TFaxResolution FaxResolution = {read=GetFaxResolution, nodefault};
	__property TFaxWidth FaxWidth = {read=GetFaxWidth, nodefault};
	__property TUnpackOutputLineEvent OnOutputLine = {read=FOutputLine, write=FOutputLine};
	__property TUnpackStatusEvent OnStatus = {read=FStatus, write=FStatus};
	__classmethod bool __fastcall IsAnAPFFile(const System::UnicodeString FName);
};


class PASCALIMPLEMENTATION TApdFaxUnpacker : public TApdCustomFaxUnpacker
{
	typedef TApdCustomFaxUnpacker inherited;
	
__published:
	__property Options = {default=1};
	__property WhitespaceCompression = {default=0};
	__property WhitespaceFrom = {default=0};
	__property WhitespaceTo = {default=0};
	__property Scaling = {default=0};
	__property HorizMult = {default=1};
	__property HorizDiv = {default=1};
	__property VertMult = {default=1};
	__property VertDiv = {default=1};
	__property AutoScaleMode;
	__property InFileName = {default=0};
	__property OutFileName = {default=0};
	__property OnOutputLine;
	__property OnStatus;
public:
	/* TApdCustomFaxUnpacker.Create */ inline __fastcall virtual TApdFaxUnpacker(System::Classes::TComponent* AOwner) : TApdCustomFaxUnpacker(AOwner) { }
	/* TApdCustomFaxUnpacker.Destroy */ inline __fastcall virtual ~TApdFaxUnpacker(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION EApdAPFGraphicError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EApdAPFGraphicError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EApdAPFGraphicError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EApdAPFGraphicError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EApdAPFGraphicError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EApdAPFGraphicError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EApdAPFGraphicError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EApdAPFGraphicError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EApdAPFGraphicError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EApdAPFGraphicError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EApdAPFGraphicError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EApdAPFGraphicError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EApdAPFGraphicError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EApdAPFGraphicError(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdAPFGraphic : public Vcl::Graphics::TGraphic
{
	typedef Vcl::Graphics::TGraphic inherited;
	
private:
	int FCurrentPage;
	System::Classes::TList* FPages;
	TApdCustomFaxUnpacker* FFromAPF;
	TApdCustomFaxConverter* FToAPF;
	
protected:
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &Rect);
	void __fastcall FreeImages(void);
	virtual bool __fastcall GetEmpty(void);
	virtual int __fastcall GetHeight(void);
	int __fastcall GetNumPages(void);
	Vcl::Graphics::TBitmap* __fastcall GetPage(int x);
	virtual int __fastcall GetWidth(void);
	void __fastcall SetCurrentPage(int v);
	virtual void __fastcall SetHeight(int v);
	void __fastcall SetPage(int x, Vcl::Graphics::TBitmap* v);
	virtual void __fastcall SetWidth(int v);
	
public:
	__fastcall virtual TApdAPFGraphic(void);
	__fastcall virtual ~TApdAPFGraphic(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	virtual void __fastcall LoadFromClipboardFormat(System::Word AFormat, NativeUInt AData, HPALETTE APalette);
	virtual void __fastcall LoadFromFile(const System::UnicodeString Filename);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	virtual void __fastcall SaveToClipboardFormat(System::Word &AFormat, NativeUInt &AData, HPALETTE &APalette);
	virtual void __fastcall SaveToStream(System::Classes::TStream* Stream);
	virtual void __fastcall SaveToFile(const System::UnicodeString Filename);
	__property Vcl::Graphics::TBitmap* Page[int x] = {read=GetPage, write=SetPage};
	
__published:
	__property int CurrentPage = {read=FCurrentPage, write=SetCurrentPage, nodefault};
	__property int NumPages = {read=GetNumPages, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::ResourceString _ApdEcStrNoClipboard;
#define Adfaxcvt_ApdEcStrNoClipboard System::LoadResourceString(&Adfaxcvt::_ApdEcStrNoClipboard)
extern DELPHI_PACKAGE System::ResourceString _ApdEcStrBadFaxFmt;
#define Adfaxcvt_ApdEcStrBadFaxFmt System::LoadResourceString(&Adfaxcvt::_ApdEcStrBadFaxFmt)
extern DELPHI_PACKAGE System::ResourceString _ApdEcStrInvalidPage;
#define Adfaxcvt_ApdEcStrInvalidPage System::LoadResourceString(&Adfaxcvt::_ApdEcStrInvalidPage)
static const TFaxInputDocumentType afcDefInputDocumentType = (TFaxInputDocumentType)(0);
#define afcDefFaxCvtOptions (System::Set<TFaxCvtOptions, TFaxCvtOptions::coDoubleWidth, TFaxCvtOptions::coYieldOften>() << TFaxCvtOptions::coDoubleWidth << TFaxCvtOptions::coCenterImage << TFaxCvtOptions::coYield )
static const TFaxResolution afcDefResolution = (TFaxResolution)(0);
static const TFaxWidth afcDefFaxCvtWidth = (TFaxWidth)(0);
static const System::Int8 afcDefTopMargin = System::Int8(0x0);
static const System::Int8 afcDefLeftMargin = System::Int8(0x32);
static const System::Int8 afcDefLinesPerPage = System::Int8(0x3c);
static const System::Int8 afcDefFaxTabStop = System::Int8(0x4);
#define afcDefFontFile L"APFAX.FNT"
static const TFaxFont afcDefFontType = (TFaxFont)(0);
extern DELPHI_PACKAGE int afcDefPrintTimeout;
#define afcDefFaxUnpackOptions (System::Set<TUnpackerOptions, TUnpackerOptions::uoYield, TUnpackerOptions::uoAbort>() << TUnpackerOptions::uoYield )
static const bool afcDefWhitespaceCompression = false;
static const System::Int8 afcDefWhitespaceFrom = System::Int8(0x0);
static const System::Int8 afcDefWhitespaceTo = System::Int8(0x0);
static const bool afcDefScaling = false;
static const System::Int8 afcDefHorizMult = System::Int8(0x1);
static const System::Int8 afcDefHorizDiv = System::Int8(0x1);
static const System::Int8 afcDefVertMult = System::Int8(0x1);
static const System::Int8 afcDefVertDiv = System::Int8(0x1);
static const TAutoScaleMode afcDefAutoScaleMode = (TAutoScaleMode)(1);
}	/* namespace Adfaxcvt */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFAXCVT)
using namespace Adfaxcvt;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdfaxcvtHPP
