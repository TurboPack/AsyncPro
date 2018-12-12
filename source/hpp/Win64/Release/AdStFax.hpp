// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStFax.pas' rev: 32.00 (Windows)

#ifndef AdstfaxHPP
#define AdstfaxHPP

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
#include <AdStSt.hpp>
#include <OoMisc.hpp>
#include <AdFax.hpp>
#include <AdStMach.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adstfax
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdSendFaxState;
class DELPHICLASS TApdReceiveFaxState;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TApdOnSetupSendFax)(TApdSendFaxState* Sender, Adfax::TApdSendFax* AFax);

typedef void __fastcall (__closure *TApdOnSetupReceiveFax)(TApdReceiveFaxState* Sender, Adfax::TApdReceiveFax* AFax);

typedef void __fastcall (__closure *TApdOnFaxXfrComplete)(Adstst::TApdCustomActionState* Sender, int ErrorCode, int &NextState);

class PASCALIMPLEMENTATION TApdSendFaxState : public Adstst::TApdCustomActionState
{
	typedef Adstst::TApdCustomActionState inherited;
	
private:
	bool FManualTransmit;
	System::UnicodeString FOutputOnError;
	System::UnicodeString FOutputOnOK;
	Adfax::TApdSendFax* FSendFax;
	TApdOnSetupSendFax FOnSetupFax;
	TApdOnFaxXfrComplete FOnFaxXfrComplete;
	
protected:
	virtual void __fastcall Activate(void);
	void __fastcall SetManualTransmit(const bool v);
	void __fastcall SetOutputOnError(const System::UnicodeString v);
	void __fastcall SetOutputOnOK(const System::UnicodeString v);
	void __fastcall SetSendFax(Adfax::TApdSendFax* v);
	
public:
	__fastcall virtual TApdSendFaxState(System::Classes::TComponent* AOwner);
	
__published:
	__property bool ManualTransmit = {read=FManualTransmit, write=SetManualTransmit, default=0};
	__property System::UnicodeString OutputOnError = {read=FOutputOnError, write=SetOutputOnError};
	__property System::UnicodeString OutputOnOK = {read=FOutputOnOK, write=SetOutputOnOK};
	__property Adfax::TApdSendFax* SendFax = {read=FSendFax, write=SetSendFax};
	__property TApdOnFaxXfrComplete OnFaxXfrComplete = {read=FOnFaxXfrComplete, write=FOnFaxXfrComplete};
	__property TApdOnSetupSendFax OnSetupFax = {read=FOnSetupFax, write=FOnSetupFax};
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
	/* TApdCustomActionState.Destroy */ inline __fastcall virtual ~TApdSendFaxState(void) { }
	
};


class PASCALIMPLEMENTATION TApdReceiveFaxState : public Adstst::TApdCustomActionState
{
	typedef Adstst::TApdCustomActionState inherited;
	
private:
	bool FManualReceive;
	System::UnicodeString FOutputOnError;
	System::UnicodeString FOutputOnOK;
	bool FSendATAToModem;
	Adfax::TApdReceiveFax* FReceiveFax;
	TApdOnFaxXfrComplete FOnFaxXfrComplete;
	TApdOnSetupReceiveFax FOnSetupFax;
	
protected:
	virtual void __fastcall Activate(void);
	void __fastcall SetManualReceive(const bool v);
	void __fastcall SetOutputOnError(const System::UnicodeString v);
	void __fastcall SetOutputOnOK(const System::UnicodeString v);
	void __fastcall SetReceiveFax(Adfax::TApdReceiveFax* v);
	void __fastcall SetSendATAToModem(const bool v);
	
public:
	__fastcall virtual TApdReceiveFaxState(System::Classes::TComponent* AOwner);
	
__published:
	__property bool ManualReceive = {read=FManualReceive, write=SetManualReceive, default=0};
	__property System::UnicodeString OutputOnError = {read=FOutputOnError, write=SetOutputOnError};
	__property System::UnicodeString OutputOnOK = {read=FOutputOnOK, write=SetOutputOnOK};
	__property Adfax::TApdReceiveFax* ReceiveFax = {read=FReceiveFax, write=SetReceiveFax};
	__property bool SendATAToModem = {read=FSendATAToModem, write=SetSendATAToModem, default=0};
	__property TApdOnFaxXfrComplete OnFaxXfrComplete = {read=FOnFaxXfrComplete, write=FOnFaxXfrComplete};
	__property TApdOnSetupReceiveFax OnSetupFax = {read=FOnSetupFax, write=FOnSetupFax};
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
	/* TApdCustomActionState.Destroy */ inline __fastcall virtual ~TApdReceiveFaxState(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adstfax */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTFAX)
using namespace Adstfax;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdstfaxHPP
