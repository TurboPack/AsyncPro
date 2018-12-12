// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdStatLt.pas' rev: 32.00 (Windows)

#ifndef AdstatltHPP
#define AdstatltHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <OoMisc.hpp>
#include <AdExcept.hpp>
#include <AdPort.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adstatlt
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomStatusLight;
class DELPHICLASS TApdStatusLight;
class DELPHICLASS TLightSet;
class DELPHICLASS TApdCustomSLController;
class DELPHICLASS TApdSLController;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TApdCustomStatusLight : public Oomisc::TApdBaseGraphicControl
{
	typedef Oomisc::TApdBaseGraphicControl inherited;
	
protected:
	Vcl::Graphics::TBitmap* FGlyph;
	bool FLit;
	System::Uitypes::TColor FLitColor;
	System::Uitypes::TColor FNotLitColor;
	bool HaveGlyph;
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* const NewGlyph);
	void __fastcall SetLit(const bool IsLit);
	void __fastcall SetLitColor(const System::Uitypes::TColor NewColor);
	void __fastcall SetNotLitColor(const System::Uitypes::TColor NewColor);
	HIDESBASE System::UnicodeString __fastcall GetVersion(void);
	HIDESBASE void __fastcall SetVersion(const System::UnicodeString Value);
	virtual void __fastcall Paint(void);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TApdCustomStatusLight(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomStatusLight(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property System::UnicodeString Version = {read=GetVersion, write=SetVersion, stored=false};
	__property Vcl::Graphics::TBitmap* Glyph = {read=FGlyph, write=SetGlyph};
	__property bool Lit = {read=FLit, write=SetLit, nodefault};
	__property System::Uitypes::TColor LitColor = {read=FLitColor, write=SetLitColor, default=255};
	__property System::Uitypes::TColor NotLitColor = {read=FNotLitColor, write=SetNotLitColor, default=32768};
};


class PASCALIMPLEMENTATION TApdStatusLight : public TApdCustomStatusLight
{
	typedef TApdCustomStatusLight inherited;
	
__published:
	__property Version;
	__property Glyph;
	__property Lit;
	__property LitColor = {default=255};
	__property NotLitColor = {default=32768};
public:
	/* TApdCustomStatusLight.Create */ inline __fastcall virtual TApdStatusLight(System::Classes::TComponent* AOwner) : TApdCustomStatusLight(AOwner) { }
	/* TApdCustomStatusLight.Destroy */ inline __fastcall virtual ~TApdStatusLight(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TLightSet : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	TApdCustomStatusLight* FCTSLight;
	TApdCustomStatusLight* FDSRLight;
	TApdCustomStatusLight* FDCDLight;
	TApdCustomStatusLight* FRINGLight;
	TApdCustomStatusLight* FTXDLight;
	TApdCustomStatusLight* FRXDLight;
	TApdCustomStatusLight* FERRORLight;
	TApdCustomStatusLight* FBREAKLight;
	
public:
	__fastcall TLightSet(void);
	void __fastcall InitLights(Adport::TApdCustomComPort* const ComPort, bool Monitoring);
	
__published:
	__property TApdCustomStatusLight* CTSLight = {read=FCTSLight, write=FCTSLight};
	__property TApdCustomStatusLight* DSRLight = {read=FDSRLight, write=FDSRLight};
	__property TApdCustomStatusLight* DCDLight = {read=FDCDLight, write=FDCDLight};
	__property TApdCustomStatusLight* RINGLight = {read=FRINGLight, write=FRINGLight};
	__property TApdCustomStatusLight* TXDLight = {read=FTXDLight, write=FTXDLight};
	__property TApdCustomStatusLight* RXDLight = {read=FRXDLight, write=FRXDLight};
	__property TApdCustomStatusLight* ERRORLight = {read=FERRORLight, write=FERRORLight};
	__property TApdCustomStatusLight* BREAKLight = {read=FBREAKLight, write=FBREAKLight};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TLightSet(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdCustomSLController : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	Adport::TApdCustomComPort* FComPort;
	bool FMonitoring;
	bool MonitoringPending;
	int FErrorOffTimeout;
	int FBreakOffTimeout;
	int FRXDOffTimeout;
	int FTXDOffTimeout;
	int FRingOffTimeout;
	TLightSet* FLights;
	Adport::TTriggerAvailEvent SaveTriggerAvail;
	Adport::TTriggerStatusEvent SaveTriggerStatus;
	Adport::TTriggerTimerEvent SaveTriggerTimer;
	unsigned ModemStatMask;
	int MSTrig;
	int ErrorOnTrig;
	int BreakOnTrig;
	int ErrorOffTrig;
	int BreakOffTrig;
	int RxdOffTrig;
	int TxdOnTrig;
	int TxdOffTrig;
	int RingOffTrig;
	bool __fastcall GetHaveCTSLight(void);
	bool __fastcall GetHaveDSRLight(void);
	bool __fastcall GetHaveDCDLight(void);
	bool __fastcall GetHaveRINGLight(void);
	bool __fastcall GetHaveTXDLight(void);
	bool __fastcall GetHaveRXDLight(void);
	bool __fastcall GetHaveERRORLight(void);
	bool __fastcall GetHaveBREAKLight(void);
	void __fastcall SetComPort(Adport::TApdCustomComPort* const NewPort);
	void __fastcall SetLights(TLightSet* const NewLights);
	void __fastcall SetMonitoring(const bool NewMon);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Loaded(void);
	void __fastcall InitTriggers(void);
	void __fastcall AddTriggers(void);
	void __fastcall RemoveTriggers(void);
	void __fastcall InitLights(void);
	void __fastcall CheckLight(const bool CurStat, TApdCustomStatusLight* const Light);
	void __fastcall StatTriggerAvail(System::TObject* CP, System::Word Count);
	void __fastcall StatTriggerStatus(System::TObject* CP, System::Word TriggerHandle);
	void __fastcall StatTriggerTimer(System::TObject* CP, System::Word TriggerHandle);
	void __fastcall StatPortClose(System::TObject* CP, bool Opening);
	__property bool HaveCTSLight = {read=GetHaveCTSLight, nodefault};
	__property bool HaveDSRLight = {read=GetHaveDSRLight, nodefault};
	__property bool HaveDCDLight = {read=GetHaveDCDLight, nodefault};
	__property bool HaveRINGLight = {read=GetHaveRINGLight, nodefault};
	__property bool HaveTXDLight = {read=GetHaveTXDLight, nodefault};
	__property bool HaveRXDLight = {read=GetHaveRXDLight, nodefault};
	__property bool HaveERRORLight = {read=GetHaveERRORLight, nodefault};
	__property bool HaveBREAKLight = {read=GetHaveBREAKLight, nodefault};
	
public:
	__fastcall virtual TApdCustomSLController(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomSLController(void);
	__property bool Monitoring = {read=FMonitoring, write=SetMonitoring, nodefault};
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=SetComPort};
	__property int ErrorOffTimeout = {read=FErrorOffTimeout, write=FErrorOffTimeout, default=36};
	__property int BreakOffTimeout = {read=FBreakOffTimeout, write=FBreakOffTimeout, default=36};
	__property int RXDOffTimeout = {read=FRXDOffTimeout, write=FRXDOffTimeout, default=1};
	__property int TXDOffTimeout = {read=FTXDOffTimeout, write=FTXDOffTimeout, default=1};
	__property int RingOffTimeout = {read=FRingOffTimeout, write=FRingOffTimeout, default=8};
	__property TLightSet* Lights = {read=FLights, write=SetLights};
};


class PASCALIMPLEMENTATION TApdSLController : public TApdCustomSLController
{
	typedef TApdCustomSLController inherited;
	
__published:
	__property ComPort;
	__property ErrorOffTimeout = {default=36};
	__property BreakOffTimeout = {default=36};
	__property RXDOffTimeout = {default=1};
	__property TXDOffTimeout = {default=1};
	__property RingOffTimeout = {default=8};
	__property Lights;
public:
	/* TApdCustomSLController.Create */ inline __fastcall virtual TApdSLController(System::Classes::TComponent* AOwner) : TApdCustomSLController(AOwner) { }
	/* TApdCustomSLController.Destroy */ inline __fastcall virtual ~TApdSLController(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 adsDefLightDim = System::Int8(0xd);
static const System::Int8 adsDefErrorOffTimeout = System::Int8(0x24);
static const System::Int8 adsDefBreakOffTimeout = System::Int8(0x24);
static const System::Int8 adsDefRXDOffTimeout = System::Int8(0x1);
static const System::Int8 adsDefTXDOffTimeout = System::Int8(0x1);
static const System::Int8 adsDefRingOffTimeout = System::Int8(0x8);
static const int adsDefLitColor = int(255);
static const int adsDefNotLitColor = int(32768);
}	/* namespace Adstatlt */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSTATLT)
using namespace Adstatlt;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdstatltHPP
