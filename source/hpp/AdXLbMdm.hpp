// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXLbMdm.pas' rev: 28.00 (Windows)

#ifndef AdxlbmdmHPP
#define AdxlbmdmHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <OoMisc.hpp>	// Pascal unit
#include <AdXBase.hpp>	// Pascal unit
#include <AdXParsr.hpp>	// Pascal unit
#include <AdExcept.hpp>	// Pascal unit
#include <AdLibMdm.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adxlbmdm
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TApdModemCapDetail;
class PASCALIMPLEMENTATION TApdModemCapDetail : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
private:
	System::Classes::TFileStream* DetailStream;
	bool __fastcall AtEOF(void);
	int __fastcall ExportDetailXML(const Adlibmdm::TLmModem &Modem);
	void __fastcall FixupModemcap(System::Classes::TStringList* &List);
	System::AnsiString __fastcall ReadLine(void);
	void __fastcall WriteLine(const System::AnsiString Str)/* overload */;
	void __fastcall WriteLine(const System::UnicodeString Str)/* overload */;
	void __fastcall WriteXMLStr(const System::UnicodeString Str, const System::UnicodeString sVal);
	System::UnicodeString __fastcall XMLize(const System::UnicodeString S);
	System::UnicodeString __fastcall XMLizeInt(int I);
	System::UnicodeString __fastcall XMLizeBool(bool B);
	System::AnsiString __fastcall UnXMLize(const System::AnsiString S);
	
public:
	__fastcall virtual TApdModemCapDetail(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdModemCapDetail(void);
	int __fastcall CreateNewDetailFile(const System::UnicodeString ModemDetailFile);
	int __fastcall AddModem(const System::UnicodeString ModemDetailFile, const Adlibmdm::TLmModem &Modem);
	int __fastcall DeleteModem(const System::UnicodeString ModemDetailFile, const System::UnicodeString ModemName);
	int __fastcall AddModemRecord(const System::UnicodeString ModemCapIndex, const Adlibmdm::TLmModemName &ModemRecord);
	int __fastcall DeleteModemRecord(const System::UnicodeString ModemCapIndex, const Adlibmdm::TLmModemName &ModemRecord);
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adxlbmdm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADXLBMDM)
using namespace Adxlbmdm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdxlbmdmHPP
