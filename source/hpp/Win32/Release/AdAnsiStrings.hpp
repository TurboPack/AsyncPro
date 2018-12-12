// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdAnsiStrings.pas' rev: 32.00 (Windows)

#ifndef AdansistringsHPP
#define AdansistringsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adansistrings
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::AnsiString __fastcall Copy(const System::AnsiString AStr, int AIndex, int ACount);
extern DELPHI_PACKAGE System::AnsiString __fastcall IntToStr(int Value)/* overload */;
extern DELPHI_PACKAGE int __fastcall Pos(const System::AnsiString ASubStr, const System::AnsiString AStr)/* overload */;
extern DELPHI_PACKAGE int __fastcall Pos(const System::UnicodeString ASubStr, const System::AnsiString AStr)/* overload */;
extern DELPHI_PACKAGE int __fastcall StrToInt(const System::AnsiString S);
}	/* namespace Adansistrings */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADANSISTRINGS)
using namespace Adansistrings;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdansistringsHPP
