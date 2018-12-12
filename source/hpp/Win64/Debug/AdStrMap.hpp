// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStrMap.pas' rev: 32.00 (Windows)

#ifndef AdstrmapHPP
#define AdstrmapHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <OoMisc.hpp>
#include <AdExcept.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adstrmap
{
//-- forward type declarations -----------------------------------------------
struct AdMessageNumberLookupRecord;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD AdMessageNumberLookupRecord
{
public:
	int MessageNumber;
	System::UnicodeString MessageString;
};


typedef System::StaticArray<AdMessageNumberLookupRecord, 897> Adstrmap__1;

//-- var, const, procedure ---------------------------------------------------
static const System::Word AdMaxMessages = System::Word(0x380);
extern DELPHI_PACKAGE Adstrmap__1 AdMessageNumberLookup;
}	/* namespace Adstrmap */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTRMAP)
using namespace Adstrmap;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdstrmapHPP
