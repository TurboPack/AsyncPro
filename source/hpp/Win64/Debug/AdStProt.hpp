// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStProt.pas' rev: 32.00 (Windows)

#ifndef AdstprotHPP
#define AdstprotHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <OoMisc.hpp>
#include <AdStMach.hpp>
#include <AdStSt.hpp>
#include <AdProtcl.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adstprot
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdSendFileState;
class DELPHICLASS TApdReceiveFileState;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TApdOnSetupProtocol)(System::TObject* Sender, Adprotcl::TApdProtocol* AProtocol);

typedef void __fastcall (__closure *TApdOnFileXfrComplete)(System::TObject* Sender, int ErrorCode, int &NextState);

class PASCALIMPLEMENTATION TApdSendFileState : public Adstst::TApdCustomActionState
{
	typedef Adstst::TApdCustomActionState inherited;
	
private:
	System::UnicodeString FOutputOnError;
	System::UnicodeString FOutputOnOK;
	Adprotcl::TApdProtocol* FProtocol;
	TApdOnSetupProtocol FOnSetupProtocol;
	TApdOnFileXfrComplete FOnFileXfrComplete;
	
protected:
	virtual void __fastcall Activate(void);
	void __fastcall SetOutputOnError(const System::UnicodeString v);
	void __fastcall SetOutputOnOK(const System::UnicodeString v);
	void __fastcall SetProtocol(Adprotcl::TApdProtocol* v);
	
public:
	__fastcall virtual TApdSendFileState(System::Classes::TComponent* AOwner);
	
__published:
	__property System::UnicodeString OutputOnError = {read=FOutputOnError, write=SetOutputOnError};
	__property System::UnicodeString OutputOnOK = {read=FOutputOnOK, write=SetOutputOnOK};
	__property Adprotcl::TApdProtocol* Protocol = {read=FProtocol, write=SetProtocol};
	__property TApdOnFileXfrComplete OnFileXfrComplete = {read=FOnFileXfrComplete, write=FOnFileXfrComplete};
	__property TApdOnSetupProtocol OnSetupProtocol = {read=FOnSetupProtocol, write=FOnSetupProtocol};
	__property ActiveColor;
	__property Caption;
	__property Font;
	__property Glyph;
	__property GlyphCells;
	__property InactiveColor;
	__property Movable = {default=0};
	__property OutputOnActivate = {default=0};
	__property OnGetData;
	__property OnGetDataString;
	__property OnStateActivate;
	__property OnStateFinish;
public:
	/* TApdCustomActionState.Destroy */ inline __fastcall virtual ~TApdSendFileState(void) { }
	
};


class PASCALIMPLEMENTATION TApdReceiveFileState : public Adstst::TApdCustomActionState
{
	typedef Adstst::TApdCustomActionState inherited;
	
private:
	System::UnicodeString FOutputOnError;
	System::UnicodeString FOutputOnOK;
	Adprotcl::TApdProtocol* FProtocol;
	TApdOnSetupProtocol FOnSetupProtocol;
	TApdOnFileXfrComplete FOnFileXfrComplete;
	
protected:
	virtual void __fastcall Activate(void);
	void __fastcall SetOutputOnError(const System::UnicodeString v);
	void __fastcall SetOutputOnOK(const System::UnicodeString v);
	void __fastcall SetProtocol(Adprotcl::TApdProtocol* v);
	
public:
	__fastcall virtual TApdReceiveFileState(System::Classes::TComponent* AOwner);
	
__published:
	__property System::UnicodeString OutputOnError = {read=FOutputOnError, write=SetOutputOnError};
	__property System::UnicodeString OutputOnOK = {read=FOutputOnOK, write=SetOutputOnOK};
	__property Adprotcl::TApdProtocol* Protocol = {read=FProtocol, write=SetProtocol};
	__property TApdOnFileXfrComplete OnFileXfrComplete = {read=FOnFileXfrComplete, write=FOnFileXfrComplete};
	__property TApdOnSetupProtocol OnSetupProtocol = {read=FOnSetupProtocol, write=FOnSetupProtocol};
	__property ActiveColor;
	__property Caption;
	__property Font;
	__property Glyph;
	__property GlyphCells;
	__property InactiveColor;
	__property Movable = {default=0};
	__property OutputOnActivate = {default=0};
	__property OnGetData;
	__property OnGetDataString;
	__property OnStateActivate;
	__property OnStateFinish;
public:
	/* TApdCustomActionState.Destroy */ inline __fastcall virtual ~TApdReceiveFileState(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adstprot */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTPROT)
using namespace Adstprot;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdstprotHPP
