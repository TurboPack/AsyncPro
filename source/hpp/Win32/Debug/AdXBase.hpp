// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXBase.pas' rev: 32.00 (Windows)

#ifndef AdxbaseHPP
#define AdxbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <OoMisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adxbase
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdMemoryStream;
class DELPHICLASS TApdFileStream;
//-- type declarations -------------------------------------------------------
typedef int TApdUcs4Char;

typedef System::SmallString<6> TApdUtf8Char;

typedef System::WideChar DOMChar;

typedef System::WideChar * PDOMChar;

enum DECLSPEC_DENUM TApdCharEncoding : unsigned char { ceUnknown, ceUTF8 };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdMemoryStream : public System::Classes::TMemoryStream
{
	typedef System::Classes::TMemoryStream inherited;
	
public:
	HIDESBASE void __fastcall SetPointer(void * Ptr, const NativeInt Size);
public:
	/* TMemoryStream.Destroy */ inline __fastcall virtual ~TApdMemoryStream(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TApdMemoryStream(void) : System::Classes::TMemoryStream() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdFileStream : public System::Classes::TFileStream
{
	typedef System::Classes::TFileStream inherited;
	
public:
	System::UnicodeString FFileName;
	__fastcall TApdFileStream(System::Word Mode, const System::UnicodeString FileName);
	__property System::UnicodeString Filename = {read=FFileName};
public:
	/* TFileStream.Create */ inline __fastcall TApdFileStream(const System::UnicodeString AFileName, System::Word Mode)/* overload */ : System::Classes::TFileStream(AFileName, Mode) { }
	/* TFileStream.Create */ inline __fastcall TApdFileStream(const System::UnicodeString AFileName, System::Word Mode, unsigned Rights)/* overload */ : System::Classes::TFileStream(AFileName, Mode, Rights) { }
	/* TFileStream.Destroy */ inline __fastcall virtual ~TApdFileStream(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE int __fastcall ApxPos(const System::WideString aSubStr, const System::WideString aString);
extern DELPHI_PACKAGE int __fastcall ApxRPos(const System::WideString sSubStr, const System::WideString sTerm);
extern DELPHI_PACKAGE bool __fastcall ApxIso88591ToUcs4(char aInCh, int &aOutCh);
extern DELPHI_PACKAGE bool __fastcall ApxUcs4ToIso88591(int aInCh, char &aOutCh);
extern DELPHI_PACKAGE bool __fastcall ApxUcs4ToWideChar(const int aInChar, System::WideChar &aOutWS);
extern DELPHI_PACKAGE bool __fastcall ApxUtf16ToUcs4(System::WideChar aInChI, System::WideChar aInChII, int &aOutCh, bool &aBothUsed);
extern DELPHI_PACKAGE bool __fastcall ApxUcs4ToUtf8(int aInCh, TApdUtf8Char &aOutCh);
extern DELPHI_PACKAGE bool __fastcall ApxUtf8ToUcs4(const TApdUtf8Char &aInCh, int aBytes, int &aOutCh);
extern DELPHI_PACKAGE System::Byte __fastcall ApxGetLengthUtf8(const char aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsBaseChar(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsChar(const int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsCombiningChar(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsDigit(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsExtender(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsIdeographic(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsLetter(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsNameChar(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsNameCharFirst(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsPubidChar(int aCh);
extern DELPHI_PACKAGE bool __fastcall ApxIsSpace(int aCh);
}	/* namespace Adxbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADXBASE)
using namespace Adxbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdxbaseHPP
