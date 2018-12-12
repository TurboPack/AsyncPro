// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwAbsPcl.pas' rev: 32.00 (Windows)

#ifndef AwabspclHPP
#define AwabspclHPP

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
#include <AdExcept.hpp>
#include <AwTPcl.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <AdPort.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awabspcl
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::Int8 awpDefAbsStatusInterval = System::Int8(0xa);
extern DELPHI_PACKAGE Awtpcl::TQuoteArray DQFull;
extern DELPHI_PACKAGE Awtpcl::TQuoteArray DQDefault;
extern DELPHI_PACKAGE int UnixDaysBase;
static const int SecsPerDay = int(0x15180);
static const System::Int8 ProtocolDataPtr = System::Int8(0x1);
extern DELPHI_PACKAGE System::StaticArray<unsigned, 256> Crc32Table;
extern DELPHI_PACKAGE unsigned Crc32TableOfs;
extern DELPHI_PACKAGE System::StaticArray<unsigned, 256> CrcTable;
extern DELPHI_PACKAGE int __fastcall apInitProtocolData(Awtpcl::PProtocolData &P, Adport::TApdCustomComPort* H, unsigned Options);
extern DELPHI_PACKAGE void __fastcall apDoneProtocol(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall apResetReadWriteHooks(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall apSetProtocolWindow(Awtpcl::PProtocolData P, HWND HW);
extern DELPHI_PACKAGE void __fastcall apSetFileList(Awtpcl::PProtocolData P, Oomisc::PFileList FL);
extern DELPHI_PACKAGE int __fastcall apMakeFileList(Awtpcl::PProtocolData P, Oomisc::PFileList &FL, unsigned Size);
extern DELPHI_PACKAGE void __fastcall apDisposeFileList(Awtpcl::PProtocolData P, Oomisc::PFileList FL, unsigned Size);
extern DELPHI_PACKAGE int __fastcall apAddFileToList(Awtpcl::PProtocolData P, Oomisc::PFileList FL, char * PName);
extern DELPHI_PACKAGE System::LongBool __fastcall apNextFileMask(Awtpcl::PProtocolData P, char * FName);
extern DELPHI_PACKAGE System::LongBool __fastcall apNextFileList(Awtpcl::PProtocolData P, char * FName);
extern DELPHI_PACKAGE int __fastcall apGetBytesTransferred(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE int __fastcall apGetBytesRemaining(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE System::LongBool __fastcall apSupportsBatch(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE int __fastcall apGetInitialFilePos(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE int __fastcall apEstimateTransferSecs(Awtpcl::PProtocolData P, int Size);
extern DELPHI_PACKAGE void __fastcall apGetProtocolInfo(Awtpcl::PProtocolData P, Oomisc::TProtocolInfo &Info);
extern DELPHI_PACKAGE void __fastcall apSetFileMask(Awtpcl::PProtocolData P, char * NewMask);
extern DELPHI_PACKAGE void __fastcall apSetReceiveFilename(Awtpcl::PProtocolData P, char * FName);
extern DELPHI_PACKAGE void __fastcall apSetDestinationDirectory(Awtpcl::PProtocolData P, char * Dir);
extern DELPHI_PACKAGE void __fastcall apSetHandshakeWait(Awtpcl::PProtocolData P, unsigned NewHandshake, unsigned NewRetry);
extern DELPHI_PACKAGE void __fastcall apSetEfficiencyParms(Awtpcl::PProtocolData P, unsigned BlockOverhead, unsigned TurnAroundDelay);
extern DELPHI_PACKAGE void __fastcall apSetProtocolPort(Awtpcl::PProtocolData P, Adport::TApdCustomComPort* H);
extern DELPHI_PACKAGE void __fastcall apSetOverwriteOption(Awtpcl::PProtocolData P, unsigned Opt);
extern DELPHI_PACKAGE void __fastcall apSetActualBPS(Awtpcl::PProtocolData P, int BPS);
extern DELPHI_PACKAGE void __fastcall apSetStatusInterval(Awtpcl::PProtocolData P, unsigned NewInterval);
extern DELPHI_PACKAGE void __fastcall apOptionsOn(Awtpcl::PProtocolData P, unsigned OptionFlags);
extern DELPHI_PACKAGE void __fastcall apOptionsOff(Awtpcl::PProtocolData P, unsigned OptionFlags);
extern DELPHI_PACKAGE System::LongBool __fastcall apOptionsAreOn(Awtpcl::PProtocolData P, unsigned OptionFlags);
extern DELPHI_PACKAGE void __fastcall apStartProtocol(Awtpcl::PProtocolData P, System::Byte Protocol, System::LongBool Transmit, Awtpcl::TPrepareProc StartProc, Awtpcl::TProtocolFunc ProtFunc);
extern DELPHI_PACKAGE void __fastcall apStopProtocol(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall apResetStatus(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall apShowFirstStatus(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall apShowLastStatus(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall apSignalFinish(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall aapPrepareReading(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall aapFinishReading(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE System::LongBool __fastcall aapReadProtocolBlock(Awtpcl::PProtocolData P, Awtpcl::TDataBlock &Block, unsigned &BlockSize);
extern DELPHI_PACKAGE void __fastcall aapPrepareWriting(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE void __fastcall aapFinishWriting(Awtpcl::PProtocolData P);
extern DELPHI_PACKAGE System::LongBool __fastcall aapWriteProtocolBlock(Awtpcl::PProtocolData P, Awtpcl::TDataBlock &Block, unsigned BlockSize);
extern DELPHI_PACKAGE void __fastcall apProtocolError(Awtpcl::PProtocolData P, int ErrorCode);
extern DELPHI_PACKAGE System::AnsiString __fastcall apTrimZeros(System::AnsiString S);
extern DELPHI_PACKAGE System::AnsiString __fastcall apOctalStr(int L);
extern DELPHI_PACKAGE int __fastcall apOctalStr2Long(System::AnsiString S);
extern DELPHI_PACKAGE int __fastcall apPackToYMTimeStamp(int RawTime);
extern DELPHI_PACKAGE int __fastcall apYMTimeStampToPack(int YMTime);
extern DELPHI_PACKAGE int __fastcall apCurrentTimeStamp(void);
extern DELPHI_PACKAGE int __fastcall apCrc32OfFile(Awtpcl::PProtocolData P, char * FName, int Len);
extern DELPHI_PACKAGE void __fastcall apMsgStatus(Awtpcl::PProtocolData P, unsigned Options);
extern DELPHI_PACKAGE System::LongBool __fastcall apMsgNextFile(Awtpcl::PProtocolData P, char * FName);
extern DELPHI_PACKAGE void __fastcall apMsgLog(Awtpcl::PProtocolData P, unsigned Log);
extern DELPHI_PACKAGE System::LongBool __fastcall apMsgAcceptFile(Awtpcl::PProtocolData P, char * FName);
extern DELPHI_PACKAGE unsigned __fastcall apUpdateChecksum(System::Byte CurByte, unsigned CheckSum);
extern DELPHI_PACKAGE unsigned __fastcall apUpdateCrc(System::Byte CurByte, unsigned CurCrc);
extern DELPHI_PACKAGE unsigned __fastcall apUpdateCrcKermit(System::Byte CurByte, unsigned CurCrc);
extern DELPHI_PACKAGE char * __fastcall apStatusMsg(char * P, unsigned Status);
extern DELPHI_PACKAGE void __fastcall apSetProtocolMsgBase(unsigned NewBase);
extern DELPHI_PACKAGE int __fastcall apUpdateCrc32(System::Byte CurByte, int CurCrc);
}	/* namespace Awabspcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWABSPCL)
using namespace Awabspcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwabspclHPP
