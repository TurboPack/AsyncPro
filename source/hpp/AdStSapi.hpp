// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStSapi.pas' rev: 28.00 (Windows)

#ifndef AdstsapiHPP
#define AdstsapiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <Winapi.Messages.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <OoMisc.hpp>	// Pascal unit
#include <AdExcept.hpp>	// Pascal unit
#include <AdStSt.hpp>	// Pascal unit
#include <AdSapiEn.hpp>	// Pascal unit
#include <AdStMach.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <System.UITypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adstsapi
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TApdOnSetupSpeakString)(System::TObject* Sender, System::UnicodeString &AString);

class DELPHICLASS TApdSAPISpeakState;
class PASCALIMPLEMENTATION TApdSAPISpeakState : public Adstst::TApdCustomActionState
{
	typedef Adstst::TApdCustomActionState inherited;
	
private:
	System::UnicodeString FStringToSpeak;
	Adsapien::TApdSapiEngine* FSapiEngine;
	TApdOnSetupSpeakString FOnSetupSpeakString;
	
protected:
	void __fastcall SetSapiEngine(Adsapien::TApdSapiEngine* const v);
	void __fastcall SetStringToSpeak(const System::UnicodeString v);
	
public:
	__fastcall virtual TApdSAPISpeakState(System::Classes::TComponent* AOwner);
	virtual void __fastcall Activate(void);
	
__published:
	__property Adsapien::TApdSapiEngine* SapiEngine = {read=FSapiEngine, write=SetSapiEngine};
	__property System::UnicodeString StringToSpeak = {read=FStringToSpeak, write=SetStringToSpeak};
	__property OnGetData;
	__property OnGetDataString;
	__property TApdOnSetupSpeakString OnSetupSpeakString = {read=FOnSetupSpeakString, write=FOnSetupSpeakString};
	__property ActiveColor;
	__property Caption;
	__property Conditions;
	__property Font;
	__property Glyph;
	__property GlyphCells;
	__property InactiveColor;
	__property Movable = {default=0};
	__property OutputOnActivate = {default=0};
	__property OnStateActivate;
	__property OnStateFinish;
	__property OnSelectNextState;
public:
	/* TApdCustomActionState.Destroy */ inline __fastcall virtual ~TApdSAPISpeakState(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adstsapi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTSAPI)
using namespace Adstsapi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdstsapiHPP
