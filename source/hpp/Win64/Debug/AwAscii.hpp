// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwAscii.pas' rev: 32.00 (Windows)

#ifndef AwasciiHPP
#define AwasciiHPP

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
#include <AdPort.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awascii
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE int __fastcall spInit(Awtpcl::PProtocolData &P, Adport::TApdCustomComPort* H, unsigned Options);
extern DELPHI_PACKAGE int __fastcall spReinit(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall spDonePart(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall spDone(Awtpcl::PProtocolData &P);
extern DELPHI_PACKAGE int __fastcall spSetDelays(Awtpcl::PProtocolData P, unsigned CharDelay, unsigned LineDelay);
extern DELPHI_PACKAGE int __fastcall spSetEOLChar(Awtpcl::PProtocolData P, char C);
extern DELPHI_PACKAGE int __fastcall spGetLineNumber(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE int __fastcall spSetEOLTranslation(Awtpcl::PProtocolData P, unsigned CR, unsigned LF);
extern DELPHI_PACKAGE int __fastcall spSetEOFTimeout(Awtpcl::PProtocolData P, int NewTimeout);
extern DELPHI_PACKAGE void __fastcall spPrepareTransmit(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall spTransmit(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE void __fastcall spPrepareReceive(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall spReceive(unsigned Msg, unsigned wParam, int lParam);
}	/* namespace Awascii */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWASCII)
using namespace Awascii;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwasciiHPP
