// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdXLbMdm.pas' rev: 32.00 (Windows)

#ifndef AdxlbmdmHPP
#define AdxlbmdmHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <OoMisc.hpp>
#include <AdXBase.hpp>
#include <AdXParsr.hpp>
#include <AdExcept.hpp>
#include <AdLibMdm.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adxlbmdm
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdModemCapDetail;
//-- type declarations -------------------------------------------------------
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
