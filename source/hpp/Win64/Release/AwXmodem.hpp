// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwXmodem.pas' rev: 32.00 (Windows)

#ifndef AwxmodemHPP
#define AwxmodemHPP

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

namespace Awxmodem
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::Word DrainWait = System::Word(0x444);
static const System::Int8 XmodemOverhead = System::Int8(0x5);
static const System::Word XmodemTurnDelay = System::Word(0x3e8);
static const System::WideChar GReq = (System::WideChar)(0x47);
static const System::WideChar CrcReq = (System::WideChar)(0x43);
static const System::WideChar ChkReq = (System::WideChar)(0x15);
extern DELPHI_PACKAGE int __fastcall xpInit(Awtpcl::PProtocolData &P, Adport::TApdCustomComPort* H, bool UseCRC, bool Use1K, bool UseGMode, unsigned Options);
extern DELPHI_PACKAGE void __fastcall xpReinit(Awtpcl::PProtocolData P, bool UseCRC, bool Use1K, bool UseGMode);
extern DELPHI_PACKAGE void __fastcall xpDone(Awtpcl::PProtocolData &P);
extern DELPHI_PACKAGE int __fastcall xpSetCRCMode(Awtpcl::PProtocolData P, bool Enable);
extern DELPHI_PACKAGE int __fastcall xpSet1KMode(Awtpcl::PProtocolData P, bool Enable);
extern DELPHI_PACKAGE int __fastcall xpSetGMode(Awtpcl::PProtocolData P, bool Enable);
extern DELPHI_PACKAGE int __fastcall xpSetBlockWait(Awtpcl::PProtocolData P, unsigned NewBlockWait);
extern DELPHI_PACKAGE int __fastcall xpSetXmodemFinishWait(Awtpcl::PProtocolData P, unsigned NewFinishWait);
extern DELPHI_PACKAGE bool __fastcall xpPrepHandshake(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall xpCancel(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE char __fastcall xpGetHandshakeChar(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE bool __fastcall xpProcessHandshake(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE bool __fastcall xpProcessBlockReply(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall xpTransmitBlock(Awtpcl::PProtocolData P, Awtpcl::TDataBlock &Block, unsigned BLen, char BType);
extern DELPHI_PACKAGE void __fastcall xpSendHandshakeChar(Awtpcl::PProtocolData P, char Handshake);
extern DELPHI_PACKAGE bool __fastcall xpCheckForBlockStart(Awtpcl::PProtocolData P, char &C);
extern DELPHI_PACKAGE Awtpcl::TProcessBlockStart __fastcall xpProcessBlockStart(Awtpcl::PProtocolData P, char C);
extern DELPHI_PACKAGE bool __fastcall xpCollectBlock(Awtpcl::PProtocolData P, Awtpcl::TDataBlock &Block);
extern DELPHI_PACKAGE void __fastcall xpReceiveBlock(Awtpcl::PProtocolData P, Awtpcl::TDataBlock &Block, unsigned &BlockSize, char &HandShake);
extern DELPHI_PACKAGE void __fastcall xpPrepareTransmit(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE int __fastcall xpTransmitPrim(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE void __fastcall xpTransmit(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE void __fastcall xpPrepareReceive(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE int __fastcall xpReceivePrim(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE void __fastcall xpReceive(unsigned Msg, unsigned wParam, int lParam);
}	/* namespace Awxmodem */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWXMODEM)
using namespace Awxmodem;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwxmodemHPP
