// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ADTrmMap.pas' rev: 28.00 (Windows)

#ifndef AdtrmmapHPP
#define AdtrmmapHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <OoMisc.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adtrmmap
{
//-- type declarations -------------------------------------------------------
typedef System::SmallString<63> TAdKeyString;

typedef TAdKeyString *PadKeyString;

class DELPHICLASS TAdKeyboardMapping;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TAdKeyboardMapping : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TList* FTable;
	int FCount;
	
protected:
	bool __fastcall kbmFindPrim(const TAdKeyString &aKey, int &aInx, void * &aNode);
	
public:
	__fastcall TAdKeyboardMapping(void);
	__fastcall virtual ~TAdKeyboardMapping(void);
	bool __fastcall Add(const TAdKeyString &aKey, const TAdKeyString &aValue);
	void __fastcall Clear(void);
	TAdKeyString __fastcall Get(const TAdKeyString &aKey);
	void __fastcall LoadFromFile(const System::UnicodeString aFileName);
	void __fastcall LoadFromRes(NativeUInt aInstance, const System::UnicodeString aResName);
	void __fastcall StoreToBinFile(const System::UnicodeString aFileName);
	void __fastcall DebugPrint(const System::UnicodeString aFileName);
	__property int Count = {read=FCount, nodefault};
};

#pragma pack(pop)

class DELPHICLASS TAdCharSetMapping;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TAdCharSetMapping : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TList* FTable;
	void *FCharQueue;
	int FCount;
	void *FScript;
	void *FScriptEnd;
	void *FScriptFreeList;
	
protected:
	void __fastcall csmAddScriptNode(PadKeyString aFont);
	bool __fastcall csmFindPrim(const TAdKeyString &aCharSet, char aChar, int &aInx, void * &aNode);
	void __fastcall csmFreeScript(void);
	
public:
	__fastcall TAdCharSetMapping(void);
	__fastcall virtual ~TAdCharSetMapping(void);
	bool __fastcall Add(const TAdKeyString &aCharSet, char aFromCh, char aToCh, const TAdKeyString &aFont, char aGlyph);
	void __fastcall Clear(void);
	void __fastcall GetFontNames(System::Classes::TStrings* aList);
	void __fastcall GenerateDrawScript(const TAdKeyString &aCharSet, char * aText);
	bool __fastcall GetNextDrawCommand(TAdKeyString &aFont, char * aText);
	void __fastcall LoadFromFile(const System::UnicodeString aFileName);
	void __fastcall LoadFromRes(NativeUInt aInstance, const System::UnicodeString aResName);
	void __fastcall StoreToBinFile(const System::UnicodeString aFileName);
	void __fastcall DebugPrint(const System::UnicodeString aFileName);
	__property int Count = {read=FCount, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::SmallString<9> DefaultFontName;
}	/* namespace Adtrmmap */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADTRMMAP)
using namespace Adtrmmap;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdtrmmapHPP
