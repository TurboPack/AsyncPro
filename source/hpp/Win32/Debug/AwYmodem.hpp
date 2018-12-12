// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwYmodem.pas' rev: 32.00 (Windows)

#ifndef AwymodemHPP
#define AwymodemHPP

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
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <AwTPcl.hpp>
#include <AwAbsPcl.hpp>
#include <AwXmodem.hpp>
#include <AdPort.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awymodem
{
//-- forward type declarations -----------------------------------------------
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
