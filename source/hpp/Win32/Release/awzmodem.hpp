// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwZmodem.pas' rev: 32.00 (Windows)

#ifndef AwzmodemHPP
#define AwzmodemHPP

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
#include <Winapi.MMSystem.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <AwTPcl.hpp>
#include <AwAbsPcl.hpp>
#include <AdPort.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awzmodem
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::Int8 MaxAttentionLen = System::Int8(0x20);
static const System::Word MaxHandshakeWait = System::Word(0x444);
static const System::Int8 MaxBadBlocks = System::Int8(0x14);
static const System::Word DefReceiveTimeout = System::Word(0x16c);
static const System::Int8 DrainingStatusInterval = System::Int8(0x12);
static const System::Word DefFinishWaitZM = System::Word(0x16c);
static const System::Int8 DefFinishRetry = System::Int8(0x3);
static const System::Int8 ZmodemTurnDelay = System::Int8(0x0);
static const System::Int8 ZmodemOverHead = System::Int8(0x14);
extern DELPHI_PACKAGE System::StaticArray<unsigned, 2> ZMaxBlock;
extern DELPHI_PACKAGE System::StaticArray<unsigned, 2> ZMaxWork;
static const System::WideChar ZPad = (System::WideChar)(0x2a);
static const System::WideChar ZDle = (System::WideChar)(0x18);
static const System::WideChar ZBin = (System::WideChar)(0x41);
static const System::WideChar ZHex = (System::WideChar)(0x42);
static const System::WideChar ZBin32 = (System::WideChar)(0x43);
static const System::WideChar ZrQinit = (System::WideChar)(0x0);
static const System::WideChar ZrInit = (System::WideChar)(0x1);
static const System::WideChar ZsInit = (System::WideChar)(0x2);
static const System::WideChar ZAck = (System::WideChar)(0x3);
static const System::WideChar ZFile = (System::WideChar)(0x4);
static const System::WideChar ZSkip = (System::WideChar)(0x5);
static const System::WideChar ZNak = (System::WideChar)(0x6);
static const System::WideChar ZAbort = (System::WideChar)(0x7);
static const System::WideChar ZFin = (System::WideChar)(0x8);
static const System::WideChar ZRpos = (System::WideChar)(0x9);
static const System::WideChar ZData = (System::WideChar)(0xa);
static const System::WideChar ZEof = (System::WideChar)(0xb);
static const System::WideChar ZFerr = (System::WideChar)(0xc);
static const System::WideChar ZCrc = (System::WideChar)(0xd);
static const System::WideChar ZChallenge = (System::WideChar)(0xe);
static const System::WideChar ZCompl = (System::WideChar)(0xf);
static const System::WideChar ZCan = (System::WideChar)(0x10);
static const System::WideChar ZFreeCnt = (System::WideChar)(0x11);
static const System::WideChar ZCommand = (System::WideChar)(0x12);
extern DELPHI_PACKAGE int __fastcall zpInit(Awtpcl::PProtocolData &P, Adport::TApdCustomComPort* H, unsigned Options);
extern DELPHI_PACKAGE int __fastcall zpReinit(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall zpDone(Awtpcl::PProtocolData &P);
extern DELPHI_PACKAGE void __fastcall zpDonePart(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE int __fastcall zpSetFileMgmtOptions(Awtpcl::PProtocolData P, System::LongBool Override, System::LongBool SkipNoFile, System::Byte FOpt);
extern DELPHI_PACKAGE int __fastcall zpSetRecoverOption(Awtpcl::PProtocolData P, System::LongBool OnOff);
extern DELPHI_PACKAGE int __fastcall zpSetBigSubpacketOption(Awtpcl::PProtocolData P, System::LongBool UseBig);
extern DELPHI_PACKAGE int __fastcall zpSetZmodemFinishWait(Awtpcl::PProtocolData P, unsigned NewWait, System::Byte NewRetry);
extern DELPHI_PACKAGE void __fastcall zpPrepareReceive(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall zpReceive(unsigned Msg, unsigned wParam, int lParam);
extern DELPHI_PACKAGE void __fastcall zpPrepareTransmit(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall zpTransmit(unsigned Msg, unsigned wParam, int lParam);
}	/* namespace Awzmodem */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWZMODEM)
using namespace Awzmodem;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwzmodemHPP
