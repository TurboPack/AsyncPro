// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ADTrmPsr.pas' rev: 32.00 (Windows)

#ifndef AdtrmpsrHPP
#define AdtrmpsrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <OoMisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adtrmpsr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TAdTerminalParser;
class DELPHICLASS TAdVT100Parser;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TAdParserCmdType : unsigned char { pctNone, pctChar, pct8bitChar, pctPending, pctComplete };

enum DECLSPEC_DENUM TAdVTParserState : unsigned char { psIdle, psGotEscape, psParsingANSI, psParsingHash, psParsingLeftParen, psParsingRightParen, psParsingCharSet, psGotCommand, psGotInterCommand, psParsingCUP52 };

typedef System::StaticArray<int, 536870911> TAdIntegerArray;

typedef TAdIntegerArray *PAdIntegerArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TAdTerminalParser : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FArgCount;
	System::Byte FCommand;
	bool FUseWideChar;
	
protected:
	virtual int __fastcall tpGetArgument(int aInx);
	virtual System::AnsiString __fastcall tpGetSequence(void);
	
public:
	__fastcall TAdTerminalParser(bool aUseWideChar);
	__fastcall virtual ~TAdTerminalParser(void);
	virtual TAdParserCmdType __fastcall ProcessChar(char aCh);
	virtual TAdParserCmdType __fastcall ProcessWideChar(System::WideChar aCh);
	virtual void __fastcall Clear(void);
	void __fastcall ForceCommand(int Command);
	__property int Argument[int aInx] = {read=tpGetArgument};
	__property int ArgumentCount = {read=FArgCount, nodefault};
	__property System::Byte Command = {read=FCommand, nodefault};
	__property System::AnsiString Sequence = {read=tpGetSequence};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TAdVT100Parser : public TAdTerminalParser
{
	typedef TAdTerminalParser inherited;
	
private:
	int FArgCountMax;
	TAdIntegerArray *FArgs;
	bool FInVT52Mode;
	void *FSavedSeq;
	TAdVTParserState FSavedState;
	void *FSequence;
	TAdVTParserState FState;
	
protected:
	virtual int __fastcall tpGetArgument(int aInx);
	virtual System::AnsiString __fastcall tpGetSequence(void);
	bool __fastcall vtpGetArguments(void);
	TAdParserCmdType __fastcall vtpParseANSISeq(char aCh);
	TAdParserCmdType __fastcall vtpProcessVT52(char aCh);
	bool __fastcall vtpValidateArgsPrim(int aMinArgs, int aMaxArgs, int aDefault);
	void __fastcall vtpGrowArgs(void);
	
public:
	__fastcall TAdVT100Parser(bool aUseWideChar);
	__fastcall virtual ~TAdVT100Parser(void);
	virtual TAdParserCmdType __fastcall ProcessChar(char aCh);
	virtual TAdParserCmdType __fastcall ProcessWideChar(System::WideChar aCh);
	virtual void __fastcall Clear(void);
	__property bool InVT52Mode = {read=FInVT52Mode, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adtrmpsr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADTRMPSR)
using namespace Adtrmpsr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdtrmpsrHPP
