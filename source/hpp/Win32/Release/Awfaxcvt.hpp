// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwFaxCvt.pas' rev: 32.00 (Windows)

#ifndef AwfaxcvtHPP
#define AwfaxcvtHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <OoMisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awfaxcvt
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::LongBool __fastcall awIsAnAPFFile(System::UnicodeString FName);
extern DELPHI_PACKAGE void __fastcall acInitDataLine(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE void __fastcall acInitFaxConverter(Oomisc::PAbsFaxCvt &Cvt, void * Data, Oomisc::TGetLineCallback CB, Oomisc::TOpenFileCallback OpenFile, Oomisc::TCloseFileCallback CloseFile, System::UnicodeString DefaultExt);
extern DELPHI_PACKAGE void __fastcall acDoneFaxConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall acSetOtherData(Oomisc::PAbsFaxCvt Cvt, void * OtherData);
extern DELPHI_PACKAGE void __fastcall acOptionsOn(Oomisc::PAbsFaxCvt Cvt, System::Word OptionFlags);
extern DELPHI_PACKAGE void __fastcall acOptionsOff(Oomisc::PAbsFaxCvt Cvt, System::Word OptionFlags);
extern DELPHI_PACKAGE System::LongBool __fastcall acOptionsAreOn(Oomisc::PAbsFaxCvt Cvt, System::Word OptionFlags);
extern DELPHI_PACKAGE void __fastcall acSetMargins(Oomisc::PAbsFaxCvt Cvt, unsigned Left, unsigned Top);
extern DELPHI_PACKAGE void __fastcall acSetResolutionMode(Oomisc::PAbsFaxCvt Cvt, System::LongBool HiRes);
extern DELPHI_PACKAGE void __fastcall acSetResolutionWidth(Oomisc::PAbsFaxCvt Cvt, unsigned RW);
extern DELPHI_PACKAGE void __fastcall acSetStationID(Oomisc::PAbsFaxCvt Cvt, System::AnsiString ID);
extern DELPHI_PACKAGE void __fastcall acSetStatusCallback(Oomisc::PAbsFaxCvt Cvt, Oomisc::TCvtStatusCallback CB);
extern DELPHI_PACKAGE void __fastcall acSetStatusWnd(Oomisc::PAbsFaxCvt Cvt, HWND HWindow);
extern DELPHI_PACKAGE void __fastcall acCompressRasterLine(Oomisc::PAbsFaxCvt Cvt, void *Buffer);
extern DELPHI_PACKAGE int __fastcall acOpenFile(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName);
extern DELPHI_PACKAGE void __fastcall acCloseFile(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE int __fastcall acGetRasterLine(Oomisc::PAbsFaxCvt Cvt, void *Data, int &Len, System::LongBool &EndOfPage, System::LongBool &MorePages);
extern DELPHI_PACKAGE int __fastcall acAddData(Oomisc::PAbsFaxCvt Cvt, void *Buffer, unsigned Len, System::LongBool DoInc);
extern DELPHI_PACKAGE int __fastcall acAddLine(Oomisc::PAbsFaxCvt Cvt, void *Buffer, unsigned Len);
extern DELPHI_PACKAGE void __fastcall acMakeEndOfPage(Oomisc::PAbsFaxCvt Cvt, void *Buffer, int &Len);
extern DELPHI_PACKAGE int __fastcall acOutToFileCallback(Oomisc::PAbsFaxCvt Cvt, void *Data, int Len, System::LongBool EndOfPage, System::LongBool MorePages);
extern DELPHI_PACKAGE int __fastcall acCreateOutputFile(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE int __fastcall acCloseOutputFile(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE int __fastcall acConvertToFile(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName, System::UnicodeString DestFile);
extern DELPHI_PACKAGE int __fastcall acConvert(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName, Oomisc::TPutLineCallback OutCallback);
extern DELPHI_PACKAGE void __fastcall fcInitTextConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall fcInitTextExConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall fcDoneTextConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall fcDoneTextExConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall fcSetTabStop(Oomisc::PAbsFaxCvt Cvt, unsigned TabStop);
extern DELPHI_PACKAGE int __fastcall fcLoadFont(Oomisc::PAbsFaxCvt Cvt, char * FileName, unsigned FontHandle, System::LongBool HiRes);
extern DELPHI_PACKAGE int __fastcall fcSetFont(Oomisc::PAbsFaxCvt Cvt, Vcl::Graphics::TFont* Font, bool HiRes);
extern DELPHI_PACKAGE int __fastcall fcOpenFile(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName);
extern DELPHI_PACKAGE void __fastcall fcCloseFile(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE void __fastcall fcSetLinesPerPage(Oomisc::PAbsFaxCvt Cvt, unsigned LineCount);
extern DELPHI_PACKAGE void __fastcall fcRasterizeText(Oomisc::PAbsFaxCvt Cvt, char * St, unsigned Row, void *Data);
extern DELPHI_PACKAGE int __fastcall fcGetTextRasterLine(Oomisc::PAbsFaxCvt Cvt, void *Data, int &Len, System::LongBool &EndOfPage, System::LongBool &MorePages);
extern DELPHI_PACKAGE void __fastcall tcInitTiffConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall tcDoneTiffConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE int __fastcall tcOpenFile(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName);
extern DELPHI_PACKAGE void __fastcall tcCloseFile(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE int __fastcall tcGetTiffRasterLine(Oomisc::PAbsFaxCvt Cvt, void *Data, int &Len, System::LongBool &EndOfPage, System::LongBool &MorePages);
extern DELPHI_PACKAGE void __fastcall pcInitPcxConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall pcDonePcxConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE int __fastcall pcOpenFile(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName);
extern DELPHI_PACKAGE void __fastcall pcCloseFile(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE int __fastcall pcGetPcxRasterLine(Oomisc::PAbsFaxCvt Cvt, void *Data, int &Len, System::LongBool &EndOfPage, System::LongBool &MorePages);
extern DELPHI_PACKAGE void __fastcall dcInitDcxConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall dcDoneDcxConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE int __fastcall dcOpenFile(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName);
extern DELPHI_PACKAGE void __fastcall dcCloseFile(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE int __fastcall dcGetDcxRasterLine(Oomisc::PAbsFaxCvt Cvt, void *Data, int &Len, System::LongBool &EndOfPage, System::LongBool &MorePages);
extern DELPHI_PACKAGE void __fastcall bcInitBmpConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall bcDoneBmpConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE int __fastcall bcOpenFile(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName);
extern DELPHI_PACKAGE void __fastcall bcCloseFile(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE int __fastcall bcGetBmpRasterLine(Oomisc::PAbsFaxCvt Cvt, void *Data, int &Len, System::LongBool &EndOfPage, System::LongBool &MorePages);
extern DELPHI_PACKAGE void __fastcall bcInitBitmapConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE void __fastcall bcDoneBitmapConverter(Oomisc::PAbsFaxCvt &Cvt);
extern DELPHI_PACKAGE int __fastcall bcSetInputBitmap(Oomisc::PAbsFaxCvt &Cvt, HBITMAP Bitmap);
extern DELPHI_PACKAGE int __fastcall bcOpenBitmap(Oomisc::PAbsFaxCvt Cvt, System::UnicodeString FileName);
extern DELPHI_PACKAGE void __fastcall bcCloseBitmap(Oomisc::PAbsFaxCvt Cvt);
extern DELPHI_PACKAGE int __fastcall bcGetBitmapRasterLine(Oomisc::PAbsFaxCvt Cvt, void *Data, int &Len, System::LongBool &EndOfPage, System::LongBool &MorePages);
extern DELPHI_PACKAGE int __fastcall upInitFaxUnpacker(Oomisc::PUnpackFax &Unpack, void * Data, Oomisc::TUnpackLineCallback CB);
extern DELPHI_PACKAGE void __fastcall upDoneFaxUnpacker(Oomisc::PUnpackFax &Unpack);
extern DELPHI_PACKAGE void __fastcall upOptionsOn(Oomisc::PUnpackFax Unpack, System::Word OptionFlags);
extern DELPHI_PACKAGE void __fastcall upOptionsOff(Oomisc::PUnpackFax Unpack, System::Word OptionFlags);
extern DELPHI_PACKAGE System::LongBool __fastcall upOptionsAreOn(Oomisc::PUnpackFax Unpack, System::Word OptionFlags);
extern DELPHI_PACKAGE void __fastcall upSetStatusCallback(Oomisc::PUnpackFax Unpack, Oomisc::TUnpackStatusCallback Callback);
extern DELPHI_PACKAGE int __fastcall upSetWhitespaceCompression(Oomisc::PUnpackFax Unpack, unsigned FromLines, unsigned ToLines);
extern DELPHI_PACKAGE void __fastcall upSetScaling(Oomisc::PUnpackFax Unpack, unsigned HMult, unsigned HDiv, unsigned VMult, unsigned VDiv);
extern DELPHI_PACKAGE int __fastcall upGetFaxHeader(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, Oomisc::TFaxHeaderRec &FH);
extern DELPHI_PACKAGE int __fastcall upGetPageHeader(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, unsigned Page, Oomisc::TPageHeaderRec &PH);
extern DELPHI_PACKAGE int __fastcall upUnpackPage(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, unsigned Page);
extern DELPHI_PACKAGE int __fastcall upUnpackFile(Oomisc::PUnpackFax Unpack, System::UnicodeString FName);
extern DELPHI_PACKAGE int __fastcall upUnpackPageToBitmap(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, unsigned Page, Oomisc::TMemoryBitmapDesc &Bmp, System::LongBool Invert);
extern DELPHI_PACKAGE int __fastcall upUnpackFileToBitmap(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, Oomisc::TMemoryBitmapDesc &Bmp, System::LongBool Invert);
extern DELPHI_PACKAGE int __fastcall upPutMemoryBitmapLine(Oomisc::PUnpackFax Unpack, System::Word plFlags, void *Data, unsigned Len, unsigned PageNum);
extern DELPHI_PACKAGE int __fastcall upUnpackPageToBuffer(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, unsigned Page, bool UnpackingFile);
extern DELPHI_PACKAGE int __fastcall upUnpackFileToBuffer(Oomisc::PUnpackFax Unpack, System::UnicodeString FName);
extern DELPHI_PACKAGE int __fastcall upUnpackPageToPcx(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, System::UnicodeString OutName, unsigned Page);
extern DELPHI_PACKAGE int __fastcall upUnpackFileToPcx(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, System::UnicodeString OutName);
extern DELPHI_PACKAGE int __fastcall upUnpackPageToDcx(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, System::UnicodeString OutName, unsigned Page);
extern DELPHI_PACKAGE int __fastcall upUnpackFileToDcx(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, System::UnicodeString OutName);
extern DELPHI_PACKAGE int __fastcall upUnpackPageToTiff(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, System::UnicodeString OutName, unsigned Page);
extern DELPHI_PACKAGE int __fastcall upUnpackFileToTiff(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, System::UnicodeString OutName);
extern DELPHI_PACKAGE int __fastcall upUnpackPageToBmp(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, System::UnicodeString OutName, unsigned Page);
extern DELPHI_PACKAGE int __fastcall upUnpackFileToBmp(Oomisc::PUnpackFax Unpack, System::UnicodeString FName, System::UnicodeString OutName);
}	/* namespace Awfaxcvt */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWFAXCVT)
using namespace Awfaxcvt;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwfaxcvtHPP
