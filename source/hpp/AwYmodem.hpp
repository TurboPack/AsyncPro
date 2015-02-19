// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwYmodem.pas' rev: 28.00 (Windows)

#ifndef AwymodemHPP
#define AwymodemHPP

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
#include <OoMisc.hpp>	// Pascal unit
#include <AwUser.hpp>	// Pascal unit
#include <AwTPcl.hpp>	// Pascal unit
#include <AwAbsPcl.hpp>	// Pascal unit
#include <AwXmodem.hpp>	// Pascal unit
#include <AdPort.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Awymodem
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE int __fastcall ypInit(Awtpcl::PProtocolData &P, Adport::TApdCustomComPort* H, bool Use1K, bool UseGMode, unsigned Options);
extern DELPHI_PACKAGE int __fastcall ypReinit(Awtpcl::PProtocolData P, bool Use1K, bool UseGMode);
extern DELPHI_PACKAGE void __fastcall ypDone(Awtpcl::PProtocolData &P);
extern DELPHI_PACKAGE void __fastcall ypDonePart(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall ypPrepareTransmit(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall ypTransmit(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE void __fastcall ypPrepareReceive(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall ypReceive(unsigned Msg, unsigned wParam, int lParam);
}	/* namespace Awymodem */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWYMODEM)
using namespace Awymodem;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwymodemHPP
