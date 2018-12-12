// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwKermit.pas' rev: 32.00 (Windows)

#ifndef AwkermitHPP
#define AwkermitHPP

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

namespace Awkermit
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::Int8 DefMinRepeatCnt = System::Int8(0x4);
static const bool FastAbort = false;
static const System::WideChar DefHibitPrefix = (System::WideChar)(0x26);
static const System::Byte CancelWait = System::Byte(0xb6);
static const System::WideChar DiscardChar = (System::WideChar)(0x44);
static const System::Int8 MaxWindowSlots = System::Int8(0x1b);
static const System::Int8 KermitOverhead = System::Int8(0x14);
static const System::Word KermitTurnDelay = System::Word(0x3e8);
static const System::Int8 SWCKermitTurnDelay = System::Int8(0x0);
static const System::WideChar KBreak = (System::WideChar)(0x42);
static const System::WideChar KData = (System::WideChar)(0x44);
static const System::WideChar KError = (System::WideChar)(0x45);
static const System::WideChar KFile = (System::WideChar)(0x46);
static const System::WideChar KNak = (System::WideChar)(0x4e);
static const System::WideChar KSendInit = (System::WideChar)(0x53);
static const System::WideChar KDisplay = (System::WideChar)(0x58);
static const System::WideChar KAck = (System::WideChar)(0x59);
static const System::WideChar KEndOfFile = (System::WideChar)(0x5a);
extern DELPHI_PACKAGE Awtpcl::TKermitOptions DefKermitOptions;
extern DELPHI_PACKAGE Awtpcl::TKermitOptions MissingKermitOptions;
extern DELPHI_PACKAGE int __fastcall kpInit(Awtpcl::PProtocolData &P, Adport::TApdCustomComPort* H, unsigned Options);
extern DELPHI_PACKAGE int __fastcall kpReinit(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall kpDonePart(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall kpDone(Awtpcl::PProtocolData &P);
extern DELPHI_PACKAGE int __fastcall kpSetKermitOptions(Awtpcl::PProtocolData P, const Awtpcl::TKermitOptions &KOptions);
extern DELPHI_PACKAGE int __fastcall kpSetMaxPacketLen(Awtpcl::PProtocolData P, System::Byte MaxLen);
extern DELPHI_PACKAGE int __fastcall kpSetMaxLongPacketLen(Awtpcl::PProtocolData P, unsigned MaxLen);
extern DELPHI_PACKAGE int __fastcall kpSetMaxWindows(Awtpcl::PProtocolData P, System::Byte MaxNum);
extern DELPHI_PACKAGE int __fastcall kpSetSWCTurnDelay(Awtpcl::PProtocolData P, unsigned TrnDelay);
extern DELPHI_PACKAGE System::Byte __fastcall kpGetSWCSize(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE int __fastcall kpGetLPStatus(Awtpcl::PProtocolData P, System::LongBool &InUse, unsigned &PacketSize);
extern DELPHI_PACKAGE int __fastcall kpSetMaxTimeoutSecs(Awtpcl::PProtocolData P, System::Byte MaxTimeout);
extern DELPHI_PACKAGE int __fastcall kpSetPacketPadding(Awtpcl::PProtocolData P, char C, System::Byte Count);
extern DELPHI_PACKAGE int __fastcall kpSetTerminator(Awtpcl::PProtocolData P, char C);
extern DELPHI_PACKAGE int __fastcall kpSetCtlPrefix(Awtpcl::PProtocolData P, char C);
extern DELPHI_PACKAGE int __fastcall kpSetHibitPrefix(Awtpcl::PProtocolData P, char C);
extern DELPHI_PACKAGE int __fastcall kpSetRepeatPrefix(Awtpcl::PProtocolData P, char C);
extern DELPHI_PACKAGE int __fastcall kpSetKermitCheck(Awtpcl::PProtocolData P, System::Byte CType);
extern DELPHI_PACKAGE System::Byte __fastcall kpWindowsUsed(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall kpPrepareReceive(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall kpReceive(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE void __fastcall kpPrepareTransmit(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall kpTransmit(unsigned Msg, unsigned wParam, int lParam);
}	/* namespace Awkermit */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWKERMIT)
using namespace Awkermit;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwkermitHPP
