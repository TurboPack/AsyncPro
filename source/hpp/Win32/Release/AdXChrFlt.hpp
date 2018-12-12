// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXChrFlt.pas' rev: 32.00 (Windows)

#ifndef AdxchrfltHPP
#define AdxchrfltHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <OoMisc.hpp>
#include <AdXBase.hpp>
#include <AdExcept.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adxchrflt
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdBaseCharFilter;
class DELPHICLASS TApdInCharFilter;
class DELPHICLASS TApdOutCharFilter;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TApdStreamFormat : unsigned char { sfUTF8, sfUTF16LE, sfUTF16BE, sfISO88591 };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdBaseCharFilter : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int FBufSize;
	char *FBuffer;
	int FBufPos;
	TApdStreamFormat FFormat;
	bool FFreeStream;
	System::Classes::TStream* FStream;
	int FStreamPos;
	int FStreamSize;
	virtual int __fastcall csGetSize(void);
	virtual void __fastcall csSetFormat(const TApdStreamFormat aValue) = 0 ;
	
public:
	__fastcall virtual TApdBaseCharFilter(System::Classes::TStream* aStream, const int aBufSize);
	__fastcall virtual ~TApdBaseCharFilter(void);
	__property int BufSize = {read=FBufSize, nodefault};
	__property bool FreeStream = {read=FFreeStream, write=FFreeStream, nodefault};
	__property System::Classes::TStream* Stream = {read=FStream};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdInCharFilter : public TApdBaseCharFilter
{
	typedef TApdBaseCharFilter inherited;
	
private:
	int FBufEnd;
	int FUCS4Char;
	int FLine;
	int FLinePos;
	System::WideChar FLastChar;
	bool FEOF;
	int FBufDMZ;
	bool FInTryRead;
	
protected:
	void __fastcall csAdvanceLine(void);
	void __fastcall csAdvanceLinePos(void);
	void __fastcall csGetCharPrim(int &aCh, bool &aIsLiteral);
	bool __fastcall csGetNextBuffer(void);
	bool __fastcall csGetTwoAnsiChars(void *Buffer);
	int __fastcall csGetUtf8Char(void);
	void __fastcall csIdentifyFormat(void);
	void __fastcall csPushCharPrim(int aCh);
	virtual void __fastcall csSetFormat(const TApdStreamFormat aValue);
	void __fastcall csGetChar(int &aCh, bool &aIsLiteral);
	
public:
	__fastcall virtual TApdInCharFilter(System::Classes::TStream* aStream, const int aBufSize);
	__property TApdStreamFormat Format = {read=FFormat, write=csSetFormat, nodefault};
	__property bool EOF = {read=FEOF, nodefault};
	void __fastcall SkipChar(void);
	bool __fastcall TryRead(const int *S, const int S_High);
	System::WideChar __fastcall ReadChar(void);
	System::WideChar __fastcall ReadAndSkipChar(void);
	__property int Line = {read=FLine, nodefault};
	__property int LinePos = {read=FLinePos, nodefault};
public:
	/* TApdBaseCharFilter.Destroy */ inline __fastcall virtual ~TApdInCharFilter(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdOutCharFilter : public TApdBaseCharFilter
{
	typedef TApdBaseCharFilter inherited;
	
protected:
	TApdStreamFormat FFormat;
	bool FSetUTF8Sig;
	virtual int __fastcall csGetSize(void);
	void __fastcall csPutUtf8Char(const int aCh);
	virtual void __fastcall csSetFormat(const TApdStreamFormat aValue);
	void __fastcall csWriteBuffer(void);
	
public:
	__fastcall virtual TApdOutCharFilter(System::Classes::TStream* aStream, const int aBufSize);
	__fastcall virtual ~TApdOutCharFilter(void);
	void __fastcall PutUCS4Char(int aCh);
	bool __fastcall PutChar(System::WideChar aCh1, System::WideChar aCh2, bool &aBothUsed);
	bool __fastcall PutString(const System::WideString aText);
	int __fastcall Position(void);
	__property TApdStreamFormat Format = {read=FFormat, write=csSetFormat, nodefault};
	__property bool WriteUTF8Signature = {read=FSetUTF8Sig, write=FSetUTF8Sig, nodefault};
	__property int Size = {read=csGetSize, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::WideChar ApxEndOfStream = (System::WideChar)(0x1);
static const System::WideChar ApxEndOfReplaceText = (System::WideChar)(0x2);
static const System::WideChar ApxNullChar = (System::WideChar)(0x3);
}	/* namespace Adxchrflt */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADXCHRFLT)
using namespace Adxchrflt;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdxchrfltHPP
