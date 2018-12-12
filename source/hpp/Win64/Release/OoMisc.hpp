// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'OoMisc.pas' rev: 32.00 (Windows)

#ifndef OomiscHPP
#define OomiscHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Vcl.OleCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.MMSystem.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>

//-- user supplied -----------------------------------------------------------

namespace Oomisc
{
//-- forward type declarations -----------------------------------------------
struct TPipeEvent;
struct EventTimer;
struct TTapiConfigRec;
struct TRasIPAddr;
struct TRasEntry;
struct TRasStatistics;
struct TProtocolInfo;
struct TAnsiEmulator;
struct LH;
struct TIniDatabaseKey;
struct TIniDatabase;
struct TModemBaseData;
struct TModemData;
struct TModemXFer;
struct TModemDatabase;
struct TKeyMapXFerRec;
struct TVKEyMapRec;
struct TKeyEmulator;
struct TCodeRec;
struct TBufferedOutputFile;
struct TFontRecord;
struct TFaxHeaderRec;
struct TPageHeaderRec;
struct TFaxJobHeaderRec;
struct TFaxRecipientRec;
struct TPcxHeaderRec;
struct TDcxHeaderRec;
struct TTreeRec;
struct TAbsFaxCvt;
struct SunB;
struct SunW;
struct TInAddr;
class DELPHICLASS TLineReader;
class DELPHICLASS TAdStr;
class DELPHICLASS TAdStrCur;
struct TTextFaxData;
struct TStripRecord;
struct TTiffFaxData;
struct TDcxFaxData;
struct TPcxFaxData;
struct TBitmapFaxData;
struct TScaleSettings;
struct TMemoryBitmapDesc;
struct TUnpackFax;
struct TUnpackToPcxData;
struct TFaxEntry;
struct TSendFax;
struct TTraceRecord;
struct TTimerTrigger;
struct TDataTrigger;
struct TStatusTrigger;
struct TTriggerSave;
struct TWndTriggerHandler;
struct TProcTriggerHandler;
struct TEventTriggerHandler;
class DELPHICLASS TApdBaseComponent;
class DELPHICLASS TApdBaseWinControl;
class DELPHICLASS TApdBaseOleControl;
class DELPHICLASS TApdBaseGraphicControl;
class DELPHICLASS TApdBaseScrollingWinControl;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TPipeEvent
{
public:
	System::Byte Event;
	System::ShortString Data;
};


typedef System::WideString DOMString;

typedef System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)> CharSet;

typedef System::SmallString<255> TPassString;

typedef HWND TApdHwnd;

struct DECLSPEC_DRECORD EventTimer
{
public:
	int StartTicks;
	int ExpireTicks;
};


typedef TTapiConfigRec *PTapiConfigRec;

struct DECLSPEC_DRECORD TTapiConfigRec
{
public:
	unsigned DataSize;
	System::StaticArray<System::Byte, 1024> Data;
};


typedef TRasIPAddr *PRasIPAddr;

struct DECLSPEC_DRECORD TRasIPAddr
{
public:
	System::Byte a;
	System::Byte b;
	System::Byte c;
	System::Byte d;
};


typedef TRasEntry *PRasEntry;

struct DECLSPEC_DRECORD TRasEntry
{
public:
	unsigned dwSize;
	unsigned dwfOptions;
	unsigned dwCountryID;
	unsigned dwCountryCode;
	System::StaticArray<System::WideChar, 11> szAreaCode;
	System::StaticArray<System::WideChar, 129> szLocalPhoneNumber;
	unsigned dwAlternateOffset;
	TRasIPAddr IPAddr;
	TRasIPAddr IPAddrDns;
	TRasIPAddr IPAddrDnsAlt;
	TRasIPAddr IPAddrWins;
	TRasIPAddr IPAddrWinsAlt;
	unsigned dwFrameSize;
	unsigned dwfNetProtocols;
	unsigned dwFramingProtocol;
	System::StaticArray<System::WideChar, 260> szScript;
	System::StaticArray<System::WideChar, 260> szAutodialDll;
	System::StaticArray<System::WideChar, 260> szAutodialFunc;
	System::StaticArray<System::WideChar, 17> szDeviceType;
	System::StaticArray<System::WideChar, 129> szDeviceName;
	System::StaticArray<System::WideChar, 33> szX25PadType;
	System::StaticArray<System::WideChar, 201> szX25Address;
	System::StaticArray<System::WideChar, 201> szX25Facilities;
	System::StaticArray<System::WideChar, 201> szX25UserData;
	unsigned dwChannels;
	unsigned dwReserved1;
	unsigned dwReserved2;
};


typedef TRasStatistics *PRasStatistics;

struct DECLSPEC_DRECORD TRasStatistics
{
public:
	unsigned dwSize;
	unsigned dwBytesXmited;
	unsigned dwBytesRcved;
	unsigned dwFramesXmited;
	unsigned dwFramesRcved;
	unsigned dwCrcErr;
	unsigned dwTimeoutErr;
	unsigned dwAlignmentErr;
	unsigned dwHardwareOverrunErr;
	unsigned dwFramingErr;
	unsigned dwBufferOverrunErr;
	unsigned dwCompressionRatioIn;
	unsigned dwCompressionRatioOut;
	unsigned dwBps;
	unsigned dwConnectDuration;
};


typedef System::StaticArray<char, 256> TNameCharArray;

typedef System::StaticArray<char, 256> TExtCharArray;

typedef System::StaticArray<System::WideChar, 256> TPathCharArray;

typedef System::StaticArray<char, 256> TPathCharArrayA;

typedef System::StaticArray<char, 256> TDirCharArray;

typedef System::StaticArray<char, 21> TChar20Array;

typedef System::StaticArray<char, 256> TCharArray;

typedef System::StaticArray<System::Byte, 65535> TByteBuffer;

typedef TByteBuffer *PByteBuffer;

typedef System::Int8 TDatabits;

typedef System::Int8 TStopbits;

typedef void __fastcall (*TApdNotifyProc)(unsigned Msg, unsigned wParam, int lParam);

typedef void __fastcall (__closure *TApdNotifyEvent)(unsigned Msg, unsigned wParam, int lParam);

struct DECLSPEC_DRECORD TProtocolInfo
{
public:
	unsigned piProtocolType;
	unsigned piBlockErrors;
	unsigned piTotalErrors;
	unsigned piBlockSize;
	unsigned piBlockNum;
	int piFileSize;
	int piBytesTransferred;
	int piBytesRemaining;
	int piInitFilePos;
	int piElapsedTicks;
	int piFlags;
	unsigned piBlockCheck;
	TPathCharArrayA piFileName;
	int piError;
	unsigned piStatus;
};


enum DECLSPEC_DENUM TAnsiParser : unsigned char { GotNone, GotEscape, GotBracket, GotSemiColon, GotParam, GotCommand, GotControlSeqIntro, GotLeftBrace, GotRightBrace, GotSpace, GotQuestionMark, GotQuestionParam };

typedef System::StaticArray<char, 20> TApQueue;

typedef TAnsiEmulator *PAnsiEmulator;

struct DECLSPEC_DRECORD TAnsiEmulator
{
public:
	unsigned emuType;
	unsigned emuFlags;
	System::LongBool emuFirst;
	System::Byte emuAttr;
	unsigned emuIndex;
	unsigned emuParamIndex;
	TApQueue emuQueue;
	System::StaticArray<System::SmallString<5>, 5> emuParamStr;
	System::StaticArray<int, 5> emuParamInt;
	TAnsiParser emuParserState;
	void *emuOther;
};


struct DECLSPEC_DRECORD LH
{
public:
	System::Word L;
	System::Word H;
};


typedef TIniDatabaseKey *PIniDatabaseKey;

struct DECLSPEC_DRECORD TIniDatabaseKey
{
public:
	char *KeyName;
	unsigned DataSize;
	System::LongBool StrType;
	System::LongBool Index;
	TIniDatabaseKey *Next;
};


typedef TIniDatabase *PIniDatabase;

struct DECLSPEC_DRECORD TIniDatabase
{
public:
	char *FName;
	TIniDatabaseKey *DictionaryHead;
	TIniDatabaseKey *DictionaryTail;
	int NumRecords;
	unsigned RecordSize;
	void *DefaultRecord;
	System::LongBool Prepared;
};


typedef System::StaticArray<char, 32> TModemNameZ;

typedef System::StaticArray<char, 42> TCmdStringZ;

typedef System::StaticArray<char, 22> TRspStringZ;

typedef System::StaticArray<char, 22> TTagStringZ;

typedef System::StaticArray<char, 106> TTagProfStringZ;

typedef System::StaticArray<char, 256> TConfigStringZ;

typedef System::StaticArray<char, 6> TBoolStrZ;

typedef System::StaticArray<char, 8> TBaudStrZ;

typedef System::StaticArray<System::StaticArray<char, 22>, 5> TTagArrayZ;

typedef TModemBaseData *PModemBaseData;

struct DECLSPEC_DRECORD TModemBaseData
{
public:
	TModemNameZ Name;
	TCmdStringZ InitCmd;
	TCmdStringZ DialCmd;
	TCmdStringZ DialTerm;
	TCmdStringZ DialCancel;
	TCmdStringZ HangupCmd;
	TConfigStringZ ConfigCmd;
	TCmdStringZ AnswerCmd;
	TRspStringZ OkMsg;
	TRspStringZ ConnectMsg;
	TRspStringZ BusyMsg;
	TRspStringZ VoiceMsg;
	TRspStringZ NoCarrierMsg;
	TRspStringZ NoDialToneMsg;
	TRspStringZ ErrorMsg;
	TRspStringZ RingMsg;
};


typedef TModemData *PModemData;

struct DECLSPEC_DRECORD TModemData
{
public:
	TModemBaseData Data;
	unsigned NumErrors;
	TTagArrayZ Errors;
	unsigned NumComps;
	TTagArrayZ Compression;
	System::LongBool LockDTE;
	int DefBaud;
};


typedef TModemXFer *PModemXFer;

struct DECLSPEC_DRECORD TModemXFer
{
public:
	TModemBaseData Data;
	TTagProfStringZ Errors;
	TTagProfStringZ Compress;
	TBoolStrZ LockDTE;
	TBaudStrZ DefBaud;
};


typedef TModemDatabase *PModemDatabase;

struct DECLSPEC_DRECORD TModemDatabase
{
public:
	TIniDatabase *DB;
};


typedef System::StaticArray<char, 31> TKeyMapName;

typedef System::StaticArray<char, 21> TKeyMapping;

typedef System::SmallString<20> TKeyMappingStr;

typedef TKeyMapXFerRec *PKeyMapXFerRec;

struct DECLSPEC_DRECORD TKeyMapXFerRec
{
public:
	TKeyMapName Name;
	System::StaticArray<System::StaticArray<char, 21>, 100> Keys;
};


typedef TVKEyMapRec *PVKeyMapRec;

struct DECLSPEC_DRECORD TVKEyMapRec
{
public:
	unsigned KeyCode;
	unsigned ShiftState;
	TKeyMappingStr Mapping;
};


typedef TKeyEmulator *PKeyEmulator;

struct DECLSPEC_DRECORD TKeyEmulator
{
public:
	System::WideChar *kbKeyFileName;
	TKeyMapName kbKeyName;
	System::LongBool kbProcessAll;
	System::LongBool kbProcessExt;
	System::StaticArray<char, 121> kbKeyNameList;
	System::StaticArray<TVKEyMapRec, 100> kbKeyMap;
	TIniDatabase *kbKeyDataBase;
};


typedef System::StaticArray<System::WideChar, 65535> TFileList;

typedef TFileList *PFileList;

struct DECLSPEC_DRECORD TCodeRec
{
public:
	System::Word Code;
	System::Word Sig;
};


typedef System::StaticArray<TCodeRec, 64> TTermCodeArray;

typedef System::StaticArray<TCodeRec, 40> TMakeUpCodeArray;

typedef TBufferedOutputFile *PBufferedOutputFile;

struct DECLSPEC_DRECORD TBufferedOutputFile
{
public:
	System::Word BufPos;
	System::Sysutils::TByteArray *Buffer;
	System::file OutFile;
};


typedef System::SmallString<20> Str20;

struct DECLSPEC_DRECORD TFontRecord
{
public:
	System::Byte Bytes;
	System::Byte PWidth;
	System::Byte Width;
	System::Byte Height;
};


typedef System::StaticArray<char, 6> TSigArray;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TFaxHeaderRec
{
public:
	TSigArray Signature;
	int FDateTime;
	Str20 SenderID;
	System::Byte Filler;
	System::Word PageCount;
	int PageOfs;
	System::StaticArray<System::Byte, 26> Padding;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TPageHeaderRec
{
public:
	int ImgLength;
	System::Word ImgFlags;
	System::StaticArray<System::Byte, 10> Padding;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TFaxJobHeaderRec
{
public:
	int ID;
	System::Byte Status;
	Str20 JobName;
	System::SmallString<40> Sender;
	System::TDateTime SchedDT;
	System::Byte NumJobs;
	System::Byte NextJob;
	int CoverOfs;
	int FaxHdrOfs;
	System::StaticArray<System::Byte, 43> Padding;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TFaxRecipientRec
{
public:
	System::Byte Status;
	System::Byte JobID;
	System::TDateTime SchedDT;
	System::Byte AttemptNum;
	System::Word LastResult;
	System::SmallString<50> PhoneNumber;
	System::SmallString<100> HeaderLine;
	System::SmallString<30> HeaderRecipient;
	System::SmallString<30> HeaderTitle;
	System::StaticArray<System::Byte, 29> Padding;
};
#pragma pack(pop)


typedef System::StaticArray<System::Byte, 48> TPcxPalArray;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TPcxHeaderRec
{
public:
	System::Byte Mfgr;
	System::Byte Ver;
	System::Byte Encoding;
	System::Byte BitsPixel;
	System::Word XMin;
	System::Word YMin;
	System::Word XMax;
	System::Word YMax;
	System::Word HRes;
	System::Word VRes;
	TPcxPalArray Palette;
	System::Byte Reserved;
	System::Byte Planes;
	System::Word BytesLine;
	System::Word PalType;
	System::StaticArray<System::Byte, 58> Filler;
};
#pragma pack(pop)


typedef System::StaticArray<int, 1024> TDcxOfsArray;

typedef TDcxHeaderRec *PDcxHeaderRec;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TDcxHeaderRec
{
public:
	int ID;
	TDcxOfsArray Offsets;
};
#pragma pack(pop)


struct DECLSPEC_DRECORD TTreeRec
{
public:
	int Next0;
	int Next1;
};


typedef System::StaticArray<TTreeRec, 307> TTreeArray;

typedef TTreeArray *PTreeArray;

typedef TAbsFaxCvt *PAbsFaxCvt;

typedef int __fastcall (*TOpenFileCallback)(PAbsFaxCvt Cvt, System::UnicodeString FileName);

typedef void __fastcall (*TCloseFileCallback)(PAbsFaxCvt Cvt);

typedef int __fastcall (*TGetLineCallback)(PAbsFaxCvt Cvt, void *Data, int &Len, System::LongBool &EndOfPage, System::LongBool &MorePages);

typedef int __fastcall (*TPutLineCallback)(PAbsFaxCvt Cvt, void *Data, int Len, System::LongBool EndOfPage, System::LongBool MorePages);

typedef System::LongBool __fastcall (*TCvtStatusCallback)(PAbsFaxCvt Cvt, System::Word StatFlags, int BytesRead, int BytesToRead);

struct DECLSPEC_DRECORD TAbsFaxCvt
{
public:
	System::LongBool UseHighRes;
	System::LongBool DoubleWidth;
	System::LongBool HalfHeight;
	unsigned Flags;
	unsigned ByteOfs;
	unsigned BitOfs;
	unsigned ResWidth;
	unsigned LeftMargin;
	unsigned TopMargin;
	unsigned CurrPage;
	unsigned CurrLine;
	unsigned LastPage;
	int CurPagePos;
	unsigned CenterOfs;
	void *UserData;
	void *OtherData;
	int BytesRead;
	int BytesToRead;
	System::Sysutils::TByteArray *DataLine;
	System::Sysutils::TByteArray *TmpBuffer;
	TGetLineCallback GetLine;
	TOpenFileCallback OpenCall;
	TCloseFileCallback CloseCall;
	TCvtStatusCallback StatusFunc;
	HWND StatusWnd;
	System::UnicodeString DefExt;
	System::UnicodeString InFileName;
	System::UnicodeString OutFileName;
	System::AnsiString StationID;
	TFaxHeaderRec MainHeader;
	TPageHeaderRec PageHeader;
	TBufferedOutputFile *OutFile;
	System::LongBool PadPage;
	Vcl::Graphics::TBitmap* InBitmap;
};


#pragma pack(push,1)
struct DECLSPEC_DRECORD SunB
{
public:
	char s_b1;
	char s_b2;
	char s_b3;
	char s_b4;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD SunW
{
public:
	System::Word s_w1;
	System::Word s_w2;
};
#pragma pack(pop)


typedef TInAddr *PInAddr;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TInAddr
{
	
public:
	union
	{
		struct 
		{
			int S_addr;
		};
		struct 
		{
			SunW S_un_w;
		};
		struct 
		{
			SunB S_un_b;
		};
		
	};
};
#pragma pack(pop)


class PASCALIMPLEMENTATION TLineReader : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::StaticArray<char, 4097> Buffer;
	bool fEOLF;
	char *ReadPtr;
	System::Classes::TStream* fStream;
	int fBytesRead;
	int fFileSize;
	void __fastcall ReadPage(void);
	
public:
	__property int BytesRead = {read=fBytesRead, nodefault};
	__fastcall TLineReader(System::Classes::TStream* Stream);
	__fastcall virtual ~TLineReader(void);
	__property bool EOLF = {read=fEOLF, nodefault};
	__property int FileSize = {read=fFileSize, nodefault};
	System::AnsiString __fastcall NextLine(void);
};


class PASCALIMPLEMENTATION TAdStr : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::WideChar operator[](unsigned Index) { return this->Chars[Index]; }
	
private:
	int FMaxLen;
	int FLen;
	System::WideChar *FString;
	System::WideChar *FCur;
	
protected:
	void __fastcall SetLen(int NewLen);
	int __fastcall GetLen(void);
	void __fastcall SetMaxLen(int NewMaxLen);
	int __fastcall GetMaxLen(void);
	int __fastcall GetBuffLen(void);
	void __fastcall SetChar(unsigned Index, System::WideChar Value);
	System::WideChar __fastcall GetChar(unsigned Index);
	System::WideChar __fastcall GetCurChar(void);
	
public:
	__fastcall TAdStr(unsigned AMaxLen);
	__fastcall virtual ~TAdStr(void);
	void __fastcall Assign(TAdStr* Source);
	__property int Len = {read=GetLen, write=SetLen, nodefault};
	__property int MaxLen = {read=GetMaxLen, write=SetMaxLen, nodefault};
	__property int BuffLen = {read=GetBuffLen, nodefault};
	__property System::WideChar Chars[unsigned Index] = {read=GetChar, write=SetChar/*, default*/};
	__property System::WideChar CurChar = {read=GetCurChar, nodefault};
	__property System::WideChar * Str = {read=FString};
	__property System::WideChar * Cur = {read=FCur};
	void __fastcall First(void);
	void __fastcall GotoPos(unsigned Index);
	void __fastcall Last(void);
	void __fastcall MoveBy(int IndexBy);
	void __fastcall Next(void);
	void __fastcall Prev(void);
	void __fastcall Append(const System::UnicodeString Text)/* overload */;
	void __fastcall Append(const System::AnsiString Text)/* overload */;
	void __fastcall AppendTAdStr(TAdStr* TS);
	void __fastcall AppendBuff(System::WideChar * Buff);
	void __fastcall Clear(void);
	System::UnicodeString __fastcall Copy(int Index, int SegLen)/* overload */;
	System::AnsiString __fastcall CopyAnsi(int Index, int SegLen)/* overload */;
	void __fastcall Delete(int Index, int SegLen);
	void __fastcall Insert(const System::UnicodeString Text, int Index)/* overload */;
	void __fastcall Insert(const System::AnsiString Text, int Index)/* overload */;
	unsigned __fastcall Pos(const System::UnicodeString SubStr);
	unsigned __fastcall PosIdx(const System::UnicodeString SubStr, int Index);
	void __fastcall Prepend(const System::UnicodeString Text)/* overload */;
	void __fastcall Prepend(const System::AnsiString Text)/* overload */;
	void __fastcall Resize(int NewLen);
};


class PASCALIMPLEMENTATION TAdStrCur : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	/* TObject.Create */ inline __fastcall TAdStrCur(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TAdStrCur(void) { }
	
};


typedef TTextFaxData *PTextFaxData;

struct DECLSPEC_DRECORD TTextFaxData
{
public:
	bool IsExtended;
	System::Sysutils::TByteArray *ReadBuffer;
	unsigned TabStop;
	unsigned LineCount;
	TLineReader* InFile;
	unsigned OnLine;
	unsigned CurRow;
	System::StaticArray<char, 256> CurStr;
	System::UnicodeString Pending;
	bool FFPending;
	TFontRecord FontRec;
	
public:
	union
	{
		struct 
		{
			Vcl::Graphics::TBitmap* Bitmap;
			unsigned LineBytes;
			unsigned Offset;
			int ImageSize;
			void *ImageData;
		};
		struct 
		{
			System::LongBool FontLoaded;
			System::Sysutils::TByteArray *FontPtr;
		};
		
	};
};


typedef TStripRecord *PStripRecord;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TStripRecord
{
public:
	int Offset;
	int Length;
};
#pragma pack(pop)


typedef System::StaticArray<TStripRecord, 8190> TStripInfo;

typedef TStripInfo *PStripInfo;

typedef TTiffFaxData *PTiffFaxData;

struct DECLSPEC_DRECORD TTiffFaxData
{
public:
	System::LongBool Intel;
	System::Word LastBitMask;
	unsigned CurrRBSize;
	unsigned CurrRBOfs;
	unsigned OnStrip;
	unsigned OnRaster;
	System::Word Version;
	System::Word SubFile;
	System::Word ImgWidth;
	System::Word ImgLen;
	System::Word ImgBytes;
	System::Word NumLines;
	System::Word CompMethod;
	System::Word PhotoMet;
	unsigned RowStrip;
	int StripOfs;
	unsigned StripCnt;
	TStripInfo *StripInfo;
	int ByteCntOfs;
	int ImgStart;
	System::Sysutils::TByteArray *ReadBuffer;
	System::file InFile;
};


typedef TDcxFaxData *PDcxFaxData;

struct DECLSPEC_DRECORD TDcxFaxData
{
public:
	TDcxHeaderRec DcxHeader;
	TDcxOfsArray DcxPgSz;
	unsigned DcxNumPag;
	unsigned OnPage;
};


typedef TPcxFaxData *PPcxFaxData;

struct DECLSPEC_DRECORD TPcxFaxData
{
public:
	unsigned CurrRBSize;
	unsigned CurrRBOfs;
	unsigned ActBytesLine;
	System::Sysutils::TByteArray *ReadBuffer;
	TPcxHeaderRec PcxHeader;
	unsigned PcxBytes;
	System::file InFile;
	System::Word PcxWidth;
	TDcxFaxData *DcxData;
};


typedef TBitmapFaxData *PBitmapFaxData;

struct DECLSPEC_DRECORD TBitmapFaxData
{
public:
	HBITMAP BmpHandle;
	Vcl::Graphics::TBitmap* DataBitmap;
	unsigned BytesPerLine;
	unsigned Width;
	unsigned NumLines;
	unsigned OnLine;
	int Offset;
	NativeUInt BitmapBufHandle;
	void *BitmapBuf;
	bool NeedsDithering;
	System::StaticArray<System::StaticArray<int, 32>, 32> DM;
};


typedef TScaleSettings *PScaleSettings;

struct DECLSPEC_DRECORD TScaleSettings
{
public:
	unsigned HMult;
	unsigned HDiv;
	unsigned VMult;
	unsigned VDiv;
};


typedef TUnpackFax *PUnpackFax;

typedef int __fastcall (*TUnpackLineCallback)(PUnpackFax Unpack, System::Word plFlags, void *Data, unsigned Len, unsigned PageNum);

typedef void __fastcall (*TUnpackStatusCallback)(PUnpackFax Unpack, System::UnicodeString FaxFile, unsigned PageNum, int BytesUnpacked, int BytesToUnpack);

typedef TMemoryBitmapDesc *PMemoryBitmapDesc;

struct DECLSPEC_DRECORD TMemoryBitmapDesc
{
public:
	unsigned Width;
	unsigned Height;
	HBITMAP Bitmap;
};


struct DECLSPEC_DRECORD TUnpackFax
{
public:
	unsigned CurCode;
	unsigned CurSig;
	unsigned LineOfs;
	unsigned LineBit;
	unsigned CurrPage;
	unsigned CurrLine;
	unsigned Flags;
	unsigned BadCodes;
	unsigned WSFrom;
	unsigned WSTo;
	unsigned WhiteCount;
	int TreeLast;
	int TreeNext;
	int Match;
	int ImgBytes;
	int ImgRead;
	TTreeArray *WhiteTree;
	TTreeArray *BlackTree;
	System::Sysutils::TByteArray *LineBuffer;
	System::Sysutils::TByteArray *TmpBuffer;
	System::Sysutils::TByteArray *FileBuffer;
	TFaxHeaderRec FaxHeader;
	TPageHeaderRec PageHeader;
	TUnpackLineCallback OutputLine;
	TUnpackStatusCallback Status;
	void *UserData;
	unsigned Height;
	unsigned Width;
	NativeUInt Handle;
	unsigned Pages;
	unsigned MaxWid;
	void *Lines;
	TScaleSettings Scale;
	TMemoryBitmapDesc MemBmp;
	TUnpackLineCallback SaveHook;
	System::LongBool ToBuffer;
	System::LongBool Inverted;
};


typedef TUnpackToPcxData *PUnpackToPcxData;

struct DECLSPEC_DRECORD TUnpackToPcxData
{
public:
	unsigned PBOfs;
	unsigned Lines;
	unsigned LastPage;
	int PCXOfs;
	System::LongBool FileOpen;
	System::LongBool DcxUnpack;
	System::file OutFile;
	System::StaticArray<char, 256> OutName;
	System::StaticArray<System::Byte, 512> PackBuffer;
	TDcxHeaderRec DcxHead;
};


enum DECLSPEC_DENUM ClassType : unsigned char { ctUnknown, ctDetect, ctClass1, ctClass2, ctClass2_0 };

enum DECLSPEC_DENUM TFaxLogCode : unsigned char { lfaxNone, lfaxTransmitStart, lfaxTransmitOk, lfaxTransmitFail, lfaxReceiveStart, lfaxReceiveOk, lfaxReceiveSkip, lfaxReceiveFail };

typedef TFaxLogCode TLogFaxCode;

enum DECLSPEC_DENUM TFaxServerLogCode : unsigned char { fslNone, fslPollingEnabled, fslPollingDisabled, fslMonitoringEnabled, fslMonitoringDisabled };

enum DECLSPEC_DENUM FaxStateType : unsigned char { faxReady, faxWaiting, faxCritical, faxFinished };

typedef System::SmallString<40> TFaxNumber;

typedef TFaxEntry *PFaxEntry;

struct DECLSPEC_DRECORD TFaxEntry
{
public:
	TFaxNumber fNumber;
	System::ShortString fFName;
	System::ShortString fCover;
	TFaxEntry *fNext;
};


typedef TSendFax *PSendFax;

struct DECLSPEC_DRECORD TSendFax
{
public:
	System::StaticArray<char, 41> sfNumber;
	System::StaticArray<char, 256> sfFName;
	System::StaticArray<char, 256> sfCover;
};


enum DECLSPEC_DENUM TDispatchType : unsigned char { dtNone, dtDispatch, dtTrigger, dtError, dtThread, dtTriggerAlloc, dtTriggerDispose, dtTriggerHandlerAlloc, dtTriggerHandlerDispose, dtTriggerDataChange, dtTelnet, dtFax, dtXModem, dtYModem, dtZModem, dtKermit, dtAscii, dtBPlus, dtPacket, dtUser, dtScript };

enum DECLSPEC_DENUM TDispatchSubType : unsigned short { dstNone, dstReadCom, dstWriteCom, dstLineStatus, dstModemStatus, dstAvail, dstTimer, dstData, dstStatus, dstThreadStart, dstThreadExit, dstThreadSleep, dstThreadWake, dstDataTrigger, dstTimerTrigger, dstStatusTrigger, dstAvailTrigger, dstWndHandler, dstProcHandler, dstEventHandler, dstSWill, dstSWont, dstSDo, dstSDont, dstRWill, dstRWont, dstRDo, dstRDont, dstCommand, dstSTerm, dsttfNone, dsttfGetEntry, dsttfInit, dsttf1Init1, dsttf2Init1, dsttf2Init1A, dsttf2Init1B, dsttf2Init2, dsttf2Init3, dsttfDial, dsttfRetryWait, dsttf1Connect, dsttf1SendTSI, dsttf1TSIResponse, dsttf1DCSResponse, dsttf1TrainStart, dsttf1TrainFinish, dsttf1WaitCFR, dsttf1WaitPageConnect, dsttf2Connect, dsttf2GetParams, dsttfWaitXon, 
	dsttfWaitFreeHeader, dsttfSendPageHeader, dsttfOpenCover, dsttfSendCover, dsttfPrepPage, dsttfSendPage, dsttfDrainPage, dsttf1PageEnd, dsttf1PrepareEOP, dsttf1SendEOP, dsttf1WaitMPS, dsttf1WaitEOP, dsttf1WaitMCF, dsttf1SendDCN, dsttf1Hangup, dsttf1WaitHangup, dsttf2SendEOP, dsttf2WaitFPTS, dsttf2WaitFET, dsttf2WaitPageOK, dsttf2SendNewParams, dsttf2NextPage, dsttf20CheckPage, dsttfClose, dsttfCompleteOK, dsttfAbort, dsttfDone, dstrfNone, dstrfInit, dstrf1Init1, dstrf2Init1, dstrf2Init1A, dstrf2Init1B, dstrf2Init2, dstrf2Init3, dstrfWaiting, dstrfAnswer, dstrf1SendCSI, dstrf1SendDIS, dstrf1CollectFrames, dstrf1CollectRetry1, dstrf1CollectRetry2, dstrf1StartTrain, dstrf1CollectTrain, dstrf1Timeout, dstrf1Retrain, dstrf1FinishTrain, dstrf1SendCFR, 
	dstrf1WaitPageConnect, dstrf2ValidConnect, dstrf2GetSenderID, dstrf2GetConnect, dstrfStartPage, dstrfGetPageData, dstrf1FinishPage, dstrf1WaitEOP, dstrf1WritePage, dstrf1SendMCF, dstrf1WaitDCN, dstrf1WaitHangup, dstrf2GetPageResult, dstrf2GetFHNG, dstrfComplete, dstrfAbort, dstrfDone, dsttxInitial, dsttxHandshake, dsttxGetBlock, dsttxWaitFreeSpace, dsttxSendBlock, dsttxDraining, dsttxReplyPending, dsttxEndDrain, dsttxFirstEndOfTransmit, dsttxRestEndOfTransmit, dsttxEotReply, dsttxFinished, dsttxDone, dstrxInitial, dstrxWaitForHSReply, dstrxWaitForBlockStart, dstrxCollectBlock, dstrxProcessBlock, dstrxFinishedSkip, dstrxFinished, dstrxDone, dsttyInitial, dsttyHandshake, dsttyGetFileName, dsttySendFileName, dsttyDraining, dsttyReplyPending, dsttyPrepXmodem, 
	dsttySendXmodem, dsttyFinished, dsttyFinishDrain, dsttyDone, dstryInitial, dstryDelay, dstryWaitForHSReply, dstryWaitForBlockStart, dstryCollectBlock, dstryProcessBlock, dstryOpenFile, dstryPrepXmodem, dstryReceiveXmodem, dstryFinished, dstryDone, dsttzInitial, dsttzHandshake, dsttzGetFile, dsttzSendFile, dsttzCheckFile, dsttzStartData, dsttzEscapeData, dsttzSendData, dsttzWaitAck, dsttzSendEof, dsttzDrainEof, dsttzCheckEof, dsttzSendFinish, dsttzCheckFinish, dsttzError, dsttzCleanup, dsttzDone, dstrzRqstFile, dstrzDelay, dstrzWaitFile, dstrzCollectFile, dstrzSendInit, dstrzSendBlockPrep, dstrzSendBlock, dstrzSync, dstrzStartFile, dstrzStartData, dstrzCollectData, dstrzGotData, dstrzWaitEof, dstrzEndOfFile, dstrzSendFinish, dstrzCollectFinish, dstrzError, 
	dstrzWaitCancel, dstrzCleanup, dstrzDone, dsttkInit, dsttkInitReply, dsttkCollectInit, dsttkOpenFile, dsttkSendFile, dsttkFileReply, dsttkCollectFile, dsttkCheckTable, dsttkSendData, dsttkBlockReply, dsttkCollectBlock, dsttkSendEof, dsttkEofReply, dsttkCollectEof, dsttkSendBreak, dsttkBreakReply, dsttkCollectBreak, dsttkComplete, dsttkWaitCancel, dsttkError, dsttkDone, dstrkInit, dstrkGetInit, dstrkCollectInit, dstrkGetFile, dstrkCollectFile, dstrkGetData, dstrkCollectData, dstrkComplete, dstrkWaitCancel, dstrkError, dstrkDone, dsttaInitial, dsttaGetBlock, dsttaWaitFreeSpace, dsttaSendBlock, dsttaSendDelay, dsttaFinishDrain, dsttaFinished, dsttaDone, dstraInitial, dstraCollectBlock, dstraProcessBlock, dstraFinished, dstraDone, dstEnable, dstDisable, 
	dstStringPacket, dstSizePacket, dstPacketTimeout, dstStartStr, dstEndStr, dstIdle, dstWaiting, dstCollecting, dstThreadStatusQueued, dstThreadDataQueued, dstThreadDataWritten, dsttzSinit, dsttzCheckSInit };

struct DECLSPEC_DRECORD TTraceRecord
{
public:
	char EventType;
	char C;
};


typedef System::StaticArray<TTraceRecord, 4000001> TTraceQueue;

typedef TTraceQueue *PTraceQueue;

typedef System::StaticArray<char, 65528> TDBuffer;

typedef TDBuffer *PDBuffer;

typedef System::StaticArray<char, 2147483647> TOBuffer;

typedef TOBuffer *POBuffer;

typedef System::StaticArray<System::WideChar, 6> TComName;

enum DECLSPEC_DENUM TTriggerType : unsigned char { ttNone, ttAvail, ttTimer, ttData, ttStatus };

typedef TTimerTrigger *PTimerTrigger;

struct DECLSPEC_DRECORD TTimerTrigger
{
public:
	unsigned tHandle;
	EventTimer tET;
	int tTicks;
	System::LongBool tValid;
	System::LongBool tActive;
};


typedef System::StaticArray<unsigned, 22> TCheckIndex;

typedef TDataTrigger *PDataTrigger;

struct DECLSPEC_DRECORD TDataTrigger
{
public:
	unsigned tHandle;
	unsigned tLen;
	TCheckIndex tChkIndex;
	System::LongBool tMatched;
	System::LongBool tIgnoreCase;
	System::StaticArray<char, 22> tData;
};


typedef TStatusTrigger *PStatusTrigger;

struct DECLSPEC_DRECORD TStatusTrigger
{
public:
	unsigned tHandle;
	unsigned tSType;
	System::Word tValue;
	bool tSActive;
	bool StatusHit;
};


struct DECLSPEC_DRECORD TTriggerSave
{
public:
	unsigned tsLenTrigger;
	System::Classes::TList* tsTimerTriggers;
	System::Classes::TList* tsDataTriggers;
	System::Classes::TList* tsStatusTriggers;
};


typedef TWndTriggerHandler *PWndTriggerHandler;

struct DECLSPEC_DRECORD TWndTriggerHandler
{
public:
	HWND thWnd;
	bool thDeleted;
};


typedef TProcTriggerHandler *PProcTriggerHandler;

struct DECLSPEC_DRECORD TProcTriggerHandler
{
public:
	TApdNotifyProc thNotify;
	bool thDeleted;
};


typedef TEventTriggerHandler *PEventTriggerHandler;

struct DECLSPEC_DRECORD TEventTriggerHandler
{
public:
	TApdNotifyEvent thNotify;
	bool thDeleted;
	bool thSync;
};


typedef System::StaticArray<void *, 3> TDataPointerArray;

class PASCALIMPLEMENTATION TApdBaseComponent : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
protected:
	System::UnicodeString __fastcall GetVersion(void);
	void __fastcall SetVersion(const System::UnicodeString Value);
	
__published:
	__property System::UnicodeString Version = {read=GetVersion, write=SetVersion, stored=false};
public:
	/* TComponent.Create */ inline __fastcall virtual TApdBaseComponent(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TApdBaseComponent(void) { }
	
};


class PASCALIMPLEMENTATION TApdBaseWinControl : public Vcl::Controls::TWinControl
{
	typedef Vcl::Controls::TWinControl inherited;
	
protected:
	System::UnicodeString __fastcall GetVersion(void);
	void __fastcall SetVersion(const System::UnicodeString Value);
	
__published:
	__property System::UnicodeString Version = {read=GetVersion, write=SetVersion, stored=false};
public:
	/* TWinControl.Create */ inline __fastcall virtual TApdBaseWinControl(System::Classes::TComponent* AOwner) : Vcl::Controls::TWinControl(AOwner) { }
	/* TWinControl.CreateParented */ inline __fastcall TApdBaseWinControl(HWND ParentWindow) : Vcl::Controls::TWinControl(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TApdBaseWinControl(void) { }
	
};


class PASCALIMPLEMENTATION TApdBaseOleControl : public Vcl::Olectrls::TOleControl
{
	typedef Vcl::Olectrls::TOleControl inherited;
	
protected:
	System::UnicodeString __fastcall GetVersion(void);
	void __fastcall SetVersion(const System::UnicodeString Value);
	
__published:
	__property System::UnicodeString Version = {read=GetVersion, write=SetVersion, stored=false};
public:
	/* TOleControl.Create */ inline __fastcall virtual TApdBaseOleControl(System::Classes::TComponent* AOwner) : Vcl::Olectrls::TOleControl(AOwner) { }
	/* TOleControl.Destroy */ inline __fastcall virtual ~TApdBaseOleControl(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdBaseOleControl(HWND ParentWindow) : Vcl::Olectrls::TOleControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TApdBaseGraphicControl : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
protected:
	System::UnicodeString __fastcall GetVersion(void);
	void __fastcall SetVersion(const System::UnicodeString Value);
	
__published:
	__property System::UnicodeString Version = {read=GetVersion, write=SetVersion, stored=false};
public:
	/* TGraphicControl.Create */ inline __fastcall virtual TApdBaseGraphicControl(System::Classes::TComponent* AOwner) : Vcl::Controls::TGraphicControl(AOwner) { }
	/* TGraphicControl.Destroy */ inline __fastcall virtual ~TApdBaseGraphicControl(void) { }
	
};


class PASCALIMPLEMENTATION TApdBaseScrollingWinControl : public Vcl::Forms::TScrollingWinControl
{
	typedef Vcl::Forms::TScrollingWinControl inherited;
	
protected:
	System::UnicodeString __fastcall GetVersion(void);
	void __fastcall SetVersion(const System::UnicodeString Value);
	
__published:
	__property System::UnicodeString Version = {read=GetVersion, write=SetVersion, stored=false};
public:
	/* TScrollingWinControl.Create */ inline __fastcall virtual TApdBaseScrollingWinControl(System::Classes::TComponent* AOwner) : Vcl::Forms::TScrollingWinControl(AOwner) { }
	/* TScrollingWinControl.Destroy */ inline __fastcall virtual ~TApdBaseScrollingWinControl(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdBaseScrollingWinControl(HWND ParentWindow) : Vcl::Forms::TScrollingWinControl(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define ApVersionStr L"v5.00"
#define ApdProductName L"Async Professional"
#define ApdShortProductName L"APRO"
#define ApdVendor L"TurboPower Software Company"
#define ApdVendorURL L"http://www.TurboPower.com"
#define ApdXSLImplementation  (0.000000E+00)
#define ApdXMLSpecification L"1.0"
static const System::Byte fsPathName = System::Byte(0xff);
static const System::Byte fsDirectory = System::Byte(0xff);
static const System::Byte fsFileName = System::Byte(0xff);
static const System::Byte fsExtension = System::Byte(0xff);
static const System::Byte fsName = System::Byte(0xff);
static const System::Int8 ApdShareFileRead = System::Int8(0x40);
#define ApdDefFileName L"C:\\DEFAULT.APF"
static const System::Word ApdPipeTimeout = System::Word(0x1388);
#define ApdPipeName L"\\\\.\\pipe\\ApFaxCnv"
#define ApdSemaphoreName L"ApFaxCnvSem"
#define ApdRegKey L"\\SOFTWARE\\TurboPower\\ApFaxCnv\\Settings"
#define ApdIniFileName L"APFPDENG.INI"
#define ApdIniSection L"Settings"
#define ApdIniKey L"AutoExec"
#define ApdDef32PrinterName L"APF Fax Printer"
#define ApdDef16PrinterName L"Print To Fax"
#define ApdDefPrinterPort L"PRINTFAX"
#define ApdDefaultTerminalName L"<default>"
#define ApdNoTerminalName L"<none>"
static const System::Int8 eNull = System::Int8(0x0);
static const System::Int8 eStartDoc = System::Int8(0x1);
static const System::Int8 eEndDoc = System::Int8(0x2);
static const System::Int8 eSetFileName = System::Int8(0x3);
static const System::Int8 RasMaxDomain = System::Int8(0xf);
static const System::Word RasMaxPassword = System::Word(0x100);
static const System::Word RasMaxUserName = System::Word(0x100);
static const System::Word RasMaxEntryName = System::Word(0x100);
static const System::Word RasMaxPhoneBook = System::Word(0x100);
static const System::Word RasMaxError = System::Word(0x100);
static const System::Int8 RasMaxEntries = System::Int8(0x40);
static const System::Byte RasMaxDeviceName = System::Byte(0x80);
static const System::Int8 RasMaxDeviceType = System::Int8(0x10);
static const System::Byte RasMaxPhoneNumber = System::Byte(0x80);
static const System::Byte RasMaxCallBackNum = System::Byte(0x80);
static const System::Int8 RasMaxAreaCode = System::Int8(0xa);
static const System::Int8 RasMaxPadType = System::Int8(0x20);
static const System::Byte RasMaxX25Address = System::Byte(0xc8);
static const System::Int8 RasMaxIPAddress = System::Int8(0xf);
static const System::Int8 RasMaxIPXAddress = System::Int8(0x15);
static const System::Byte RasMaxFacilities = System::Byte(0xc8);
static const System::Byte RasMaxUserData = System::Byte(0xc8);
static const System::Int8 RASEO_UseCountryAndAreaCodes = System::Int8(0x1);
static const System::Int8 RASEO_SpecificIpAddr = System::Int8(0x2);
static const System::Int8 RASEO_SpecificNameServers = System::Int8(0x4);
static const System::Int8 RASEO_IpHeaderCompression = System::Int8(0x8);
static const System::Int8 RASEO_RemoteDefaultGateway = System::Int8(0x10);
static const System::Int8 RASEO_DisableLcpExtensions = System::Int8(0x20);
static const System::Int8 RASEO_TerminalBeforeDial = System::Int8(0x40);
static const System::Byte RASEO_TerminalAfterDial = System::Byte(0x80);
static const System::Word RASEO_ModemLights = System::Word(0x100);
static const System::Word RASEO_SwCompression = System::Word(0x200);
static const System::Word RASEO_RequireEncryptedPw = System::Word(0x400);
static const System::Word RASEO_RequireMsEncryptedPw = System::Word(0x800);
static const System::Word RASEO_RequireDataEncryption = System::Word(0x1000);
static const System::Word RASEO_NetworkLogon = System::Word(0x2000);
static const System::Word RASEO_UseLogonCredentials = System::Word(0x4000);
static const System::Word RASEO_PromoteAlternates = System::Word(0x8000);
static const int RASEO_SecureLocalFiles = int(0x10000);
static const int RASEO_RequireEAP = int(0x20000);
static const int RASEO_RequirePAP = int(0x40000);
static const int RASEO_RequireSPAP = int(0x80000);
static const int RASEO_Custom = int(0x100000);
static const int RASEO_PreviewPhoneNumber = int(0x200000);
static const int RASEO_SharedPhoneNumbers = int(0x800000);
static const int RASEO_PreviewUserPw = int(0x1000000);
static const int RASEO_PreviewDomain = int(0x2000000);
static const int RASEO_ShowDialingProgress = int(0x4000000);
static const int RASEO_RequireCHAP = int(0x8000000);
static const int RASEO_RequireMsCHAP = int(0x10000000);
static const int RASEO_RequireMsCHAP2 = int(0x20000000);
static const int RASEO_RequireW95MSCHAP = int(0x40000000);
static const unsigned RASEO_CustomScript = unsigned(0x80000000);
static const System::Int8 RASNP_NetBEUI = System::Int8(0x1);
static const System::Int8 RASNP_Ipx = System::Int8(0x2);
static const System::Int8 RASNP_Ip = System::Int8(0x4);
static const System::Int8 RASFP_Ppp = System::Int8(0x1);
static const System::Int8 RASFP_Slip = System::Int8(0x2);
static const System::Int8 RASFP_Ras = System::Int8(0x4);
#define RASDT_Modem L"modem"
#define RASDT_Isdn L"isdn"
#define RASDT_X25 L"x25"
#define RASDT_Vpn L"vpn"
#define RASDT_Pad L"pad"
#define RASDT_Generic L"GENERIC"
#define RASDT_Serial L"SERIAL"
#define RASDT_FrameRelay L"FRAMERELAY"
#define RASDT_Atm L"ATM"
#define RASDT_Sonet L"SONET"
#define RASDT_SW56 L"SW56"
#define RASDT_Irda L"IRDA"
#define RASDT_Parallel L"PARALLEL"
static const System::Int8 MaxComHandles = System::Int8(0x32);
static const System::Word DispatchBufferSize = System::Word(0x2000);
static const System::Int8 MaxMessageLen = System::Int8(0x50);
static const System::Int8 DontChangeBaud = System::Int8(0x0);
static const System::Int8 DontChangeParity = System::Int8(0x5);
static const System::Int8 DontChangeDatabits = System::Int8(0x9);
static const System::Int8 DontChangeStopbits = System::Int8(0x3);
static const System::Int8 msCTSDelta = System::Int8(0x10);
static const System::Int8 msDSRDelta = System::Int8(0x20);
static const System::Int8 msRingDelta = System::Int8(0x4);
static const System::Byte msDCDDelta = System::Byte(0x80);
static const System::Int8 lsOverrun = System::Int8(0x1);
static const System::Int8 lsParity = System::Int8(0x2);
static const System::Int8 lsFraming = System::Int8(0x4);
static const System::Int8 lsBreak = System::Int8(0x8);
static const System::Int8 leNoError = System::Int8(0x0);
static const System::Int8 leBuffer = System::Int8(0x1);
static const System::Int8 leOverrun = System::Int8(0x2);
static const System::Int8 leParity = System::Int8(0x3);
static const System::Int8 leFraming = System::Int8(0x4);
static const System::Int8 leCTSTO = System::Int8(0x5);
static const System::Int8 leDSRTO = System::Int8(0x6);
static const System::Int8 leDCDTO = System::Int8(0x7);
static const System::Int8 leTxFull = System::Int8(0x8);
static const System::Int8 leBreak = System::Int8(0x9);
static const System::Int8 leIOError = System::Int8(0xa);
static const System::Int8 stNotActive = System::Int8(0x0);
static const System::Int8 stModem = System::Int8(0x1);
static const System::Int8 stLine = System::Int8(0x2);
static const System::Int8 stOutBuffFree = System::Int8(0x3);
static const System::Int8 stOutBuffUsed = System::Int8(0x4);
static const System::Int8 stOutSent = System::Int8(0x5);
static const System::Int8 nfNone = System::Int8(0x0);
static const System::Int8 nfMask = System::Int8(0x1);
static const System::Int8 nfList = System::Int8(0x2);
static const System::Int8 wfcWriteNone = System::Int8(0x0);
static const System::Int8 wfcWriteFail = System::Int8(0x1);
static const System::Int8 wfcWriteRename = System::Int8(0x2);
static const System::Int8 wfcWriteAnyway = System::Int8(0x3);
static const System::Int8 wfcWriteResume = System::Int8(0x4);
static const System::Int8 atNone = System::Int8(0x0);
static const System::Int8 atStrip = System::Int8(0x1);
static const System::Int8 atAddCRBefore = System::Int8(0x2);
static const System::Int8 atAddLFAfter = System::Int8(0x3);
extern DELPHI_PACKAGE char atEOFMarker;
static const System::Int8 apFirstCall = System::Int8(0x1);
static const System::Int8 apLastCall = System::Int8(0x2);
static const System::Int8 lfReceiveStart = System::Int8(0x0);
static const System::Int8 lfReceiveOk = System::Int8(0x1);
static const System::Int8 lfReceiveFail = System::Int8(0x2);
static const System::Int8 lfReceiveSkip = System::Int8(0x3);
static const System::Int8 lfTransmitStart = System::Int8(0x4);
static const System::Int8 lfTransmitOk = System::Int8(0x5);
static const System::Int8 lfTransmitFail = System::Int8(0x6);
static const System::Int8 lfTransmitSkip = System::Int8(0x7);
static const System::Word ev_CTSS = System::Word(0x400);
static const System::Word ev_DSRS = System::Word(0x800);
static const System::Word ev_RLSDS = System::Word(0x1000);
static const System::Word ev_RingTe = System::Word(0x2000);
static const System::Int8 MsrShadowOfs = System::Int8(0x23);
static const System::Int8 DeltaCTSMask = System::Int8(0x1);
static const System::Int8 DeltaDSRMask = System::Int8(0x2);
static const System::Int8 DeltaRIMask = System::Int8(0x4);
static const System::Int8 DeltaDCDMask = System::Int8(0x8);
static const System::Int8 CTSMask = System::Int8(0x10);
static const System::Int8 DSRMask = System::Int8(0x20);
static const System::Int8 RIMask = System::Int8(0x40);
static const System::Byte DCDMask = System::Byte(0x80);
static const System::Word apw_First = System::Word(0x7e00);
static const System::Word apw_TriggerAvail = System::Word(0x7e01);
static const System::Word apw_TriggerData = System::Word(0x7e02);
static const System::Word apw_TriggerTimer = System::Word(0x7e03);
static const System::Word apw_TriggerStatus = System::Word(0x7e04);
static const System::Word apw_FromYmodem = System::Word(0x7e05);
static const System::Word apw_PortOpen = System::Word(0x7e08);
static const System::Word apw_PortClose = System::Word(0x7e09);
static const System::Word apw_ClosePending = System::Word(0x7e0a);
static const System::Word apw_ProtocolCancel = System::Word(0x7e14);
static const System::Word apw_ProtocolStatus = System::Word(0x7e15);
static const System::Word apw_ProtocolLog = System::Word(0x7e16);
static const System::Word apw_ProtocolNextFile = System::Word(0x7e17);
static const System::Word apw_ProtocolAcceptFile = System::Word(0x7e18);
static const System::Word apw_ProtocolFinish = System::Word(0x7e19);
static const System::Word apw_ProtocolResume = System::Word(0x7e1a);
static const System::Word apw_ProtocolError = System::Word(0x7e1b);
static const System::Word apw_ProtocolAbort = System::Word(0x7e1c);
static const System::Word apw_AutoAnswer = System::Word(0x7e28);
static const System::Word apw_CancelCall = System::Word(0x7e29);
static const System::Word apw_StartDial = System::Word(0x7e2a);
static const System::Word apw_ModemOk = System::Word(0x7e28);
static const System::Word apw_ModemConnect = System::Word(0x7e29);
static const System::Word apw_ModemBusy = System::Word(0x7e2a);
static const System::Word apw_ModemVoice = System::Word(0x7e2b);
static const System::Word apw_ModemNoCarrier = System::Word(0x7e2c);
static const System::Word apw_ModemNoDialTone = System::Word(0x7e2d);
static const System::Word apw_ModemError = System::Word(0x7e2e);
static const System::Word apw_GotLineSpeed = System::Word(0x7e2f);
static const System::Word apw_GotErrCorrection = System::Word(0x7e30);
static const System::Word apw_GotDataCompression = System::Word(0x7e31);
static const System::Word apw_CmdTimeout = System::Word(0x7e32);
static const System::Word apw_DialTimeout = System::Word(0x7e33);
static const System::Word apw_AnswerTimeout = System::Word(0x7e34);
static const System::Word apw_DialCount = System::Word(0x7e35);
static const System::Word apw_AnswerCount = System::Word(0x7e36);
static const System::Word apw_ModemRing = System::Word(0x7e37);
static const System::Word apw_ModemIsConnected = System::Word(0x7e38);
static const System::Word apw_ConnectFailed = System::Word(0x7e39);
static const System::Word apw_CommandProcessed = System::Word(0x7e3a);
static const System::Word apw_TermStart = System::Word(0x7e3c);
static const System::Word apw_TermStop = System::Word(0x7e3d);
static const System::Word apw_TermSetCom = System::Word(0x7e3e);
static const System::Word apw_TermRelCom = System::Word(0x7e3f);
static const System::Word apw_TermSetEmuPtr = System::Word(0x7e40);
static const System::Word apw_TermSetEmuProc = System::Word(0x7e41);
static const System::Word apw_TermClear = System::Word(0x7e42);
static const System::Word apw_TermBuffer = System::Word(0x7e43);
static const System::Word apw_TermColors = System::Word(0x7e44);
static const System::Word apw_TermToggleScroll = System::Word(0x7e45);
static const System::Word apw_TermCapture = System::Word(0x7e46);
static const System::Word apw_TermStuff = System::Word(0x7e47);
static const System::Word apw_TermPaint = System::Word(0x7e48);
static const System::Word apw_TermSetWndProc = System::Word(0x7e49);
static const System::Word apw_TermColorsH = System::Word(0x7e4a);
static const System::Word apw_TermSave = System::Word(0x7e4b);
static const System::Word apw_TermColorMap = System::Word(0x7e4c);
static const System::Word apw_TermForceSize = System::Word(0x7e4d);
static const System::Word apw_TermFontSize = System::Word(0x7e4e);
static const System::Word apw_TermStatus = System::Word(0x7e50);
static const System::Word apw_TermBPlusStart = System::Word(0x7e51);
static const System::Word apw_TermError = System::Word(0x7e52);
static const System::Word apw_CursorPosReport = System::Word(0x7e53);
static const System::Word apw_FaxCvtStatus = System::Word(0x7e5a);
static const System::Word apw_FaxUnpStatus = System::Word(0x7e5b);
static const System::Word apw_FaxOutput = System::Word(0x7e5c);
static const System::Word apw_ViewSetFile = System::Word(0x7e64);
static const System::Word apw_ViewSetFG = System::Word(0x7e65);
static const System::Word apw_ViewSetBG = System::Word(0x7e66);
static const System::Word apw_ViewSetScale = System::Word(0x7e67);
static const System::Word apw_ViewSetScroll = System::Word(0x7e68);
static const System::Word apw_ViewSelectAll = System::Word(0x7e69);
static const System::Word apw_ViewSelect = System::Word(0x7e6a);
static const System::Word apw_ViewCopy = System::Word(0x7e6b);
static const System::Word apw_ViewSetWndProc = System::Word(0x7e6c);
static const System::Word apw_ViewSetWhitespace = System::Word(0x7e6d);
static const System::Word apw_ViewGetBitmap = System::Word(0x7e6e);
static const System::Word apw_ViewGetNumPages = System::Word(0x7e6f);
static const System::Word apw_ViewStartUpdate = System::Word(0x7e70);
static const System::Word apw_ViewEndUpdate = System::Word(0x7e71);
static const System::Word apw_ViewGotoPage = System::Word(0x7e72);
static const System::Word apw_ViewGetCurPage = System::Word(0x7e73);
static const System::Word apw_ViewSetDesignMode = System::Word(0x7e74);
static const System::Word apw_ViewSetRotation = System::Word(0x7e75);
static const System::Word apw_ViewSetAutoScale = System::Word(0x7e76);
static const System::Word apw_ViewNotifyPage = System::Word(0x7e77);
static const System::Word apw_ViewGetPageDim = System::Word(0x7e78);
static const System::Word apw_ViewSetLoadWholeFax = System::Word(0x7e79);
static const System::Word apw_ViewSetBusyCursor = System::Word(0x7e7a);
static const System::Word apw_ViewerError = System::Word(0x7e7b);
static const System::Word apw_ViewGetPageFlags = System::Word(0x7e7c);
static const System::Word apw_ViewGetFileName = System::Word(0x7e7d);
static const System::Word apw_TermBlinkTimeChange = System::Word(0x7e82);
static const System::Word apw_TermPersistentMarkChange = System::Word(0x7e83);
static const System::Word apw_TermSetKeyEmuPtr = System::Word(0x7e84);
static const System::Word apw_TermSetKeyEmuProc = System::Word(0x7e85);
static const System::Word apw_TermSetHalfDuplex = System::Word(0x7e86);
static const System::Word apw_TermGetBuffPtr = System::Word(0x7e87);
static const System::Word apw_TermGetClientLine = System::Word(0x7e88);
static const System::Word apw_TermWaitForPort = System::Word(0x7e89);
static const System::Word apw_TermNeedsUpdate = System::Word(0x7e8a);
static const System::Word apw_PrintDriverJobCreated = System::Word(0x7e8c);
static const System::Word apw_BeginDoc = System::Word(0x7e8d);
static const System::Word apw_EndDoc = System::Word(0x7e8e);
static const System::Word apw_AddPrim = System::Word(0x7e8f);
static const System::Word apw_EndPage = System::Word(0x7e90);
static const System::Word apw_FaxCancel = System::Word(0x7ea0);
static const System::Word apw_FaxNextfile = System::Word(0x7ea1);
static const System::Word apw_FaxStatus = System::Word(0x7ea2);
static const System::Word apw_FaxLog = System::Word(0x7ea3);
static const System::Word apw_FaxName = System::Word(0x7ea4);
static const System::Word apw_FaxAccept = System::Word(0x7ea5);
static const System::Word apw_FaxError = System::Word(0x7ea6);
static const System::Word apw_FaxFinish = System::Word(0x7ea7);
static const System::Word apw_TapiWaveMessage = System::Word(0x7eb4);
static const System::Word apw_TapiEventMessage = System::Word(0x7eb5);
static const System::Word apw_VoIPEventMessage = System::Word(0x7eb6);
static const System::Word apw_VoIPNotifyMessage = System::Word(0x7eb7);
static const System::Word apw_StateDeactivate = System::Word(0x7ebe);
static const System::Word apw_StateChange = System::Word(0x7ebf);
static const System::Word apw_SapiTrain = System::Word(0x7ec0);
static const System::Word apw_SapiPhoneCallBack = System::Word(0x7ec1);
static const System::Word apw_SapiInfoPhrase = System::Word(0x7ec2);
static const System::Word apw_PgrStatusEvent = System::Word(0x7ec8);
#define DispatcherClassName L"awDispatch"
#define ProtocolClassName L"awProtocol"
#define TerminalClassName L"awTerminal"
#define MessageHandlerClassName L"awMsgHandler"
#define FaxViewerClassName L"awViewer"
#define FaxViewerClassNameDesign L"dcViewer"
#define TerminalClassNameDesign L"dcTerminal"
#define FaxHandlerClassName L"awFaxHandler"
static const System::Int8 egDos = System::Int8(0x0);
static const System::Int8 egGeneral = System::Int8(-1);
static const System::Int8 egOpenComm = System::Int8(-2);
static const System::Int8 egSerialIO = System::Int8(-3);
static const System::Int8 egModem = System::Int8(-4);
static const System::Int8 egTrigger = System::Int8(-5);
static const System::Int8 egProtocol = System::Int8(-6);
static const System::Int8 egINI = System::Int8(-7);
static const System::Int8 egFax = System::Int8(-8);
static const System::Int8 egAdWinsock = System::Int8(0x9);
static const System::Int8 egWinsock = System::Int8(0xa);
static const System::Int8 egWinsockEx = System::Int8(0xb);
static const System::Int8 egTapi = System::Int8(-13);
static const System::Int8 ecOK = System::Int8(0x0);
static const System::Int8 ecFileNotFound = System::Int8(-2);
static const System::Int8 ecPathNotFound = System::Int8(-3);
static const System::Int8 ecTooManyFiles = System::Int8(-4);
static const System::Int8 ecAccessDenied = System::Int8(-5);
static const System::Int8 ecInvalidHandle = System::Int8(-6);
static const System::Int8 ecOutOfMemory = System::Int8(-8);
static const System::Int8 ecInvalidDrive = System::Int8(-15);
static const System::Int8 ecNoMoreFiles = System::Int8(-18);
static const System::Int8 ecDiskRead = System::Int8(-100);
static const System::Int8 ecDiskFull = System::Int8(-101);
static const System::Int8 ecNotAssigned = System::Int8(-102);
static const System::Int8 ecNotOpen = System::Int8(-103);
static const System::Int8 ecNotOpenInput = System::Int8(-104);
static const System::Int8 ecNotOpenOutput = System::Int8(-105);
static const short ecWriteProtected = short(-150);
static const short ecUnknownUnit = short(-151);
static const short ecDriveNotReady = short(-152);
static const short ecUnknownCommand = short(-153);
static const short ecCrcError = short(-154);
static const short ecBadStructLen = short(-155);
static const short ecSeekError = short(-156);
static const short ecUnknownMedia = short(-157);
static const short ecSectorNotFound = short(-158);
static const short ecOutOfPaper = short(-159);
static const short ecDeviceWrite = short(-160);
static const short ecDeviceRead = short(-161);
static const short ecHardwareFailure = short(-162);
static const short ecBadHandle = short(-1001);
static const short ecBadArgument = short(-1002);
static const short ecGotQuitMsg = short(-1003);
static const short ecBufferTooBig = short(-1004);
static const short ecPortNotAssigned = short(-1005);
static const short ecInternal = short(-1006);
static const short ecModemNotAssigned = short(-1007);
static const short ecPhonebookNotAssigned = short(-1008);
static const short ecCannotUseWithWinSock = short(-1009);
static const short ecBadId = short(-2001);
static const short ecBaudRate = short(-2002);
static const short ecByteSize = short(-2003);
static const short ecDefault = short(-2004);
static const short ecHardware = short(-2005);
static const short ecMemory = short(-2006);
static const short ecCommNotOpen = short(-2007);
static const short ecAlreadyOpen = short(-2008);
static const short ecNoHandles = short(-2009);
static const short ecNoTimers = short(-2010);
static const short ecNoPortSelected = short(-2011);
static const short ecNotOpenedByTapi = short(-2012);
static const short ecNullApi = short(-3001);
static const short ecNotSupported = short(-3002);
static const short ecRegisterHandlerFailed = short(-3003);
static const short ecPutBlockFail = short(-3004);
static const short ecGetBlockFail = short(-3005);
static const short ecOutputBufferTooSmall = short(-3006);
static const short ecBufferIsEmpty = short(-3007);
static const short ecTracingNotEnabled = short(-3008);
static const short ecLoggingNotEnabled = short(-3009);
static const short ecBaseAddressNotSet = short(-3010);
static const short ecModemNotStarted = short(-4001);
static const short ecModemBusy = short(-4002);
static const short ecModemNotDialing = short(-4003);
static const short ecNotDialing = short(-4004);
static const short ecAlreadyDialing = short(-4005);
static const short ecModemNotResponding = short(-4006);
static const short ecModemRejectedCommand = short(-4007);
static const short ecModemStatusMismatch = short(-4008);
static const short ecDeviceNotSelected = short(-4009);
static const short ecModemDetectedBusy = short(-4010);
static const short ecModemNoDialtone = short(-4011);
static const short ecModemNoCarrier = short(-4012);
static const short ecModemNoAnswer = short(-4013);
static const short ecInitFail = short(-4014);
static const short ecLoginFail = short(-4015);
static const short ecMinorSrvErr = short(-4016);
static const short ecFatalSrvErr = short(-4017);
static const short ecModemNotFound = short(-4020);
static const short ecInvalidFile = short(-4021);
static const System::Word csOpenPort = System::Word(0x1194);
static const System::Word csPortOpened = System::Word(0x1195);
static const System::Word csConnectDevice = System::Word(0x1196);
static const System::Word csDeviceConnected = System::Word(0x1197);
static const System::Word csAllDevicesConnected = System::Word(0x1198);
static const System::Word csAuthenticate = System::Word(0x1199);
static const System::Word csAuthNotify = System::Word(0x119a);
static const System::Word csAuthRetry = System::Word(0x119b);
static const System::Word csAuthCallback = System::Word(0x119c);
static const System::Word csAuthChangePassword = System::Word(0x119d);
static const System::Word csAuthProject = System::Word(0x119e);
static const System::Word csAuthLinkSpeed = System::Word(0x119f);
static const System::Word csAuthAck = System::Word(0x11a0);
static const System::Word csReAuthenticate = System::Word(0x11a1);
static const System::Word csAuthenticated = System::Word(0x11a2);
static const System::Word csPrepareForCallback = System::Word(0x11a3);
static const System::Word csWaitForModemReset = System::Word(0x11a4);
static const System::Word csWaitForCallback = System::Word(0x11a5);
static const System::Word csProjected = System::Word(0x11a6);
static const System::Word csStartAuthentication = System::Word(0x11a7);
static const System::Word csCallbackComplete = System::Word(0x11a8);
static const System::Word csLogonNetwork = System::Word(0x11a9);
static const System::Word csSubEntryConnected = System::Word(0x11aa);
static const System::Word csSubEntryDisconnected = System::Word(0x11ab);
static const System::Word csRasInteractive = System::Word(0x11c6);
static const System::Word csRasRetryAuthentication = System::Word(0x11c7);
static const System::Word csRasCallbackSetByCaller = System::Word(0x11c8);
static const System::Word csRasPasswordExpired = System::Word(0x11c9);
static const System::Word csRasDeviceConnected = System::Word(0x11f7);
static const System::Word csRasBaseEnd = System::Word(0x11ab);
static const System::Word csRasPaused = System::Word(0x1000);
static const System::Word csInteractive = System::Word(0x1000);
static const System::Word csRetryAuthentication = System::Word(0x1001);
static const System::Word csCallbackSetByCaller = System::Word(0x1002);
static const System::Word csPasswordExpired = System::Word(0x1003);
static const System::Word csRasPausedEnd = System::Word(0x1003);
static const System::Word csRasConnected = System::Word(0x2000);
static const System::Word csRasDisconnected = System::Word(0x2001);
static const System::Word psOK = System::Word(0x125c);
static const System::Word psProtocolHandshake = System::Word(0x125d);
static const System::Word psInvalidDate = System::Word(0x125e);
static const System::Word psFileRejected = System::Word(0x125f);
static const System::Word psFileRenamed = System::Word(0x1260);
static const System::Word psSkipFile = System::Word(0x1261);
static const System::Word psFileDoesntExist = System::Word(0x1262);
static const System::Word psCantWriteFile = System::Word(0x1263);
static const System::Word psTimeout = System::Word(0x1264);
static const System::Word psBlockCheckError = System::Word(0x1265);
static const System::Word psLongPacket = System::Word(0x1266);
static const System::Word psDuplicateBlock = System::Word(0x1267);
static const System::Word psProtocolError = System::Word(0x1268);
static const System::Word psCancelRequested = System::Word(0x1269);
static const System::Word psEndFile = System::Word(0x126a);
static const System::Word psResumeBad = System::Word(0x126b);
static const System::Word psSequenceError = System::Word(0x126c);
static const System::Word psAbortNoCarrier = System::Word(0x126d);
static const System::Word psAbort = System::Word(0x127a);
static const System::Word psGotCrcE = System::Word(0x126e);
static const System::Word psGotCrcG = System::Word(0x126f);
static const System::Word psGotCrcW = System::Word(0x1270);
static const System::Word psGotCrcQ = System::Word(0x1271);
static const System::Word psTryResume = System::Word(0x1272);
static const System::Word psHostResume = System::Word(0x1273);
static const System::Word psWaitAck = System::Word(0x1274);
static const System::Word psNoHeader = System::Word(0x1275);
static const System::Word psGotHeader = System::Word(0x1276);
static const System::Word psGotData = System::Word(0x1277);
static const System::Word psNoData = System::Word(0x1278);
static const System::Word fpInitModem = System::Word(0x12c1);
static const System::Word fpDialing = System::Word(0x12c2);
static const System::Word fpBusyWait = System::Word(0x12c3);
static const System::Word fpSendPage = System::Word(0x12c4);
static const System::Word fpSendPageStatus = System::Word(0x12c5);
static const System::Word fpPageError = System::Word(0x12c6);
static const System::Word fpPageOK = System::Word(0x12c7);
static const System::Word fpConnecting = System::Word(0x12c8);
static const System::Word fpWaiting = System::Word(0x12d4);
static const System::Word fpNoConnect = System::Word(0x12d5);
static const System::Word fpAnswer = System::Word(0x12d6);
static const System::Word fpIncoming = System::Word(0x12d7);
static const System::Word fpGetPage = System::Word(0x12d8);
static const System::Word fpGetPageResult = System::Word(0x12d9);
static const System::Word fpCheckMorePages = System::Word(0x12da);
static const System::Word fpGetHangup = System::Word(0x12db);
static const System::Word fpGotHangup = System::Word(0x12dc);
static const System::Word fpSwitchModes = System::Word(0x12de);
static const System::Word fpMonitorEnabled = System::Word(0x12df);
static const System::Word fpMonitorDisabled = System::Word(0x12e0);
static const System::Word fpSessionParams = System::Word(0x12e8);
static const System::Word fpGotRemoteID = System::Word(0x12e9);
static const System::Word fpCancel = System::Word(0x12ea);
static const System::Word fpFinished = System::Word(0x12eb);
static const short ecNoMoreTriggers = short(-5001);
static const short ecTriggerTooLong = short(-5002);
static const short ecBadTriggerHandle = short(-5003);
static const short ecStartStringEmpty = short(-5501);
static const short ecPacketTooSmall = short(-5502);
static const short ecNoEndCharCount = short(-5503);
static const short ecEmptyEndString = short(-5504);
static const short ecZeroSizePacket = short(-5505);
static const short ecPacketTooLong = short(-5506);
static const short ecBadFileList = short(-6001);
static const short ecNoSearchMask = short(-6002);
static const short ecNoMatchingFiles = short(-6003);
static const short ecDirNotFound = short(-6004);
static const short ecCancelRequested = short(-6005);
static const short ecTimeout = short(-6006);
static const short ecProtocolError = short(-6007);
static const short ecTooManyErrors = short(-6008);
static const short ecSequenceError = short(-6009);
static const short ecNoFilename = short(-6010);
static const short ecFileRejected = short(-6011);
static const short ecCantWriteFile = short(-6012);
static const short ecTableFull = short(-6013);
static const short ecAbortNoCarrier = short(-6014);
static const short ecBadProtocolFunction = short(-6015);
static const short ecProtocolAbort = short(-6016);
static const short ecKeyTooLong = short(-7001);
static const short ecDataTooLarge = short(-7002);
static const short ecNoFieldsDefined = short(-7003);
static const short ecIniWrite = short(-7004);
static const short ecIniRead = short(-7005);
static const short ecNoIndexKey = short(-7006);
static const short ecRecordExists = short(-7007);
static const short ecRecordNotFound = short(-7008);
static const short ecMustHaveIdxVal = short(-7009);
static const short ecDatabaseFull = short(-7010);
static const short ecDatabaseEmpty = short(-7011);
static const short ecDatabaseNotPrepared = short(-7012);
static const short ecBadFieldList = short(-7013);
static const short ecBadFieldForIndex = short(-7014);
static const short ecNoStateMachine = short(-7500);
static const short ecNoStartState = short(-7501);
static const short ecNoSapiEngine = short(-7502);
static const short ecFaxBadFormat = short(-8001);
static const short ecBadGraphicsFormat = short(-8002);
static const short ecConvertAbort = short(-8003);
static const short ecUnpackAbort = short(-8004);
static const short ecCantMakeBitmap = short(-8005);
static const short ecNoImageLoaded = short(-8050);
static const short ecNoImageBlockMarked = short(-8051);
static const short ecFontFileNotFound = short(-8052);
static const short ecInvalidPageNumber = short(-8053);
static const short ecBmpTooBig = short(-8054);
static const short ecEnhFontTooBig = short(-8055);
static const short ecFaxBadMachine = short(-8060);
static const short ecFaxBadModemResult = short(-8061);
static const short ecFaxTrainError = short(-8062);
static const short ecFaxInitError = short(-8063);
static const short ecFaxBusy = short(-8064);
static const short ecFaxVoiceCall = short(-8065);
static const short ecFaxDataCall = short(-8066);
static const short ecFaxNoDialTone = short(-8067);
static const short ecFaxNoCarrier = short(-8068);
static const short ecFaxSessionError = short(-8069);
static const short ecFaxPageError = short(-8070);
static const short ecFaxGDIPrintError = short(-8071);
static const short ecFaxMixedResolution = short(-8072);
static const short ecFaxConverterInitFail = short(-8073);
static const short ecNoAnswer = short(-8074);
static const short ecAlreadyMonitored = short(-8075);
static const short ecFaxMCFNoAnswer = short(-8076);
static const short ecUniAlreadyInstalled = short(-8080);
static const short ecUniCannotGetSysDir = short(-8081);
static const short ecUniCannotGetWinDir = short(-8082);
static const short ecUniUnknownLayout = short(-8083);
static const short ecUniCannotInstallFile = short(-8085);
static const short ecRasDDNotInstalled = short(-8086);
static const short ecDrvCopyError = short(-8087);
static const short ecCannotAddPrinter = short(-8088);
static const short ecDrvBadResources = short(-8089);
static const short ecDrvDriverNotFound = short(-8090);
static const short ecUniCannotGetPrinterDriverDir = short(-8091);
static const short ecInstallDriverFailed = short(-8092);
static const short ecSMSBusy = short(-8100);
static const short ecSMSTimedOut = short(-8101);
static const short ecSMSTooLong = short(-8102);
static const short ecSMSUnknownStatus = short(-8103);
static const short ecSMSInvalidNumber = short(-8138);
static const short ecMEFailure = short(-8300);
static const short ecServiceRes = short(-8301);
static const short ecBadOperation = short(-8302);
static const short ecUnsupported = short(-8303);
static const short ecInvalidPDU = short(-8304);
static const short ecInvalidText = short(-8305);
static const short ecSIMInsert = short(-8310);
static const short ecSIMPin = short(-8311);
static const short ecSIMPH = short(-8312);
static const short ecSIMFailure = short(-8313);
static const short ecSIMBusy = short(-8314);
static const short ecSIMWrong = short(-8315);
static const short ecSIMPUK = short(-8316);
static const short ecSIMPIN2 = short(-8317);
static const short ecSIMPUK2 = short(-8318);
static const short ecMemFail = short(-8320);
static const short ecInvalidMemIndex = short(-8321);
static const short ecMemFull = short(-8322);
static const short ecSMSCAddUnknown = short(-8330);
static const short ecNoNetwork = short(-8331);
static const short ecNetworkTimeout = short(-8332);
static const short ecCNMAAck = short(-8340);
static const short ecUnknown = short(-8500);
static const System::Word ecADWSERROR = System::Word(0x2329);
static const System::Word ecADWSLOADERROR = System::Word(0x232a);
static const System::Word ecADWSVERSIONERROR = System::Word(0x232b);
static const System::Word ecADWSNOTINIT = System::Word(0x232c);
static const System::Word ecADWSINVPORT = System::Word(0x232d);
static const System::Word ecADWSCANTCHANGE = System::Word(0x232e);
static const System::Word ecADWSCANTRESOLVE = System::Word(0x232f);
static const System::Word wsaBaseErr = System::Word(0x2710);
static const System::Word wsaEIntr = System::Word(0x2714);
static const System::Word wsaEBadF = System::Word(0x2719);
static const System::Word wsaEAcces = System::Word(0x271d);
static const System::Word wsaEFault = System::Word(0x271e);
static const System::Word wsaEInVal = System::Word(0x2726);
static const System::Word wsaEMFile = System::Word(0x2728);
static const System::Word wsaEWouldBlock = System::Word(0x2733);
static const System::Word wsaEInProgress = System::Word(0x2734);
static const System::Word wsaEAlReady = System::Word(0x2735);
static const System::Word wsaENotSock = System::Word(0x2736);
static const System::Word wsaEDestAddrReq = System::Word(0x2737);
static const System::Word wsaEMsgSize = System::Word(0x2738);
static const System::Word wsaEPrototype = System::Word(0x2739);
static const System::Word wsaENoProtoOpt = System::Word(0x273a);
static const System::Word wsaEProtoNoSupport = System::Word(0x273b);
static const System::Word wsaESocktNoSupport = System::Word(0x273c);
static const System::Word wsaEOpNotSupp = System::Word(0x273d);
static const System::Word wsaEPfNoSupport = System::Word(0x273e);
static const System::Word wsaEAfNoSupport = System::Word(0x273f);
static const System::Word wsaEAddrInUse = System::Word(0x2740);
static const System::Word wsaEAddrNotAvail = System::Word(0x2741);
static const System::Word wsaENetDown = System::Word(0x2742);
static const System::Word wsaENetUnreach = System::Word(0x2743);
static const System::Word wsaENetReset = System::Word(0x2744);
static const System::Word wsaEConnAborted = System::Word(0x2745);
static const System::Word wsaEConnReset = System::Word(0x2746);
static const System::Word wsaENoBufs = System::Word(0x2747);
static const System::Word wsaEIsConn = System::Word(0x2748);
static const System::Word wsaENotConn = System::Word(0x2749);
static const System::Word wsaEShutDown = System::Word(0x274a);
static const System::Word wsaETooManyRefs = System::Word(0x274b);
static const System::Word wsaETimedOut = System::Word(0x274c);
static const System::Word wsaEConnRefused = System::Word(0x274d);
static const System::Word wsaELoop = System::Word(0x274e);
static const System::Word wsaENameTooLong = System::Word(0x274f);
static const System::Word wsaEHostDown = System::Word(0x2750);
static const System::Word wsaEHostUnreach = System::Word(0x2751);
static const System::Word wsaENotEmpty = System::Word(0x2752);
static const System::Word wsaEProcLim = System::Word(0x2753);
static const System::Word wsaEUsers = System::Word(0x2754);
static const System::Word wsaEDQuot = System::Word(0x2755);
static const System::Word wsaEStale = System::Word(0x2756);
static const System::Word wsaERemote = System::Word(0x2757);
static const System::Word wsaEDiscOn = System::Word(0x2775);
static const System::Word wsaSysNotReady = System::Word(0x276b);
static const System::Word wsaVerNotSupported = System::Word(0x276c);
static const System::Word wsaNotInitialised = System::Word(0x276d);
static const System::Word wsaHost_Not_Found = System::Word(0x2af9);
static const System::Word Host_Not_Found = System::Word(0x2af9);
static const System::Word wsaTry_Again = System::Word(0x2afa);
static const System::Word Try_Again = System::Word(0x2afa);
static const System::Word wsaNo_Recovery = System::Word(0x2afb);
static const System::Word No_Recovery = System::Word(0x2afb);
static const System::Word wsaNo_Data = System::Word(0x2afc);
static const System::Word No_Data = System::Word(0x2afc);
static const System::Word wsaNo_Address = System::Word(0x2afc);
static const System::Word No_Address = System::Word(0x2afc);
static const short ecAllocated = short(-13801);
static const short ecBadDeviceID = short(-13802);
static const short ecBearerModeUnavail = short(-13803);
static const short ecCallUnavail = short(-13805);
static const short ecCompletionOverrun = short(-13806);
static const short ecConferenceFull = short(-13807);
static const short ecDialBilling = short(-13808);
static const short ecDialDialtone = short(-13809);
static const short ecDialPrompt = short(-13810);
static const short ecDialQuiet = short(-13811);
static const short ecIncompatibleApiVersion = short(-13812);
static const short ecIncompatibleExtVersion = short(-13813);
static const short ecIniFileCorrupt = short(-13814);
static const short ecInUse = short(-13815);
static const short ecInvalAddress = short(-13816);
static const short ecInvalAddressID = short(-13817);
static const short ecInvalAddressMode = short(-13818);
static const short ecInvalAddressState = short(-13819);
static const short ecInvalAppHandle = short(-13820);
static const short ecInvalAppName = short(-13821);
static const short ecInvalBearerMode = short(-13822);
static const short ecInvalCallComplMode = short(-13823);
static const short ecInvalCallHandle = short(-13824);
static const short ecInvalCallParams = short(-13825);
static const short ecInvalCallPrivilege = short(-13826);
static const short ecInvalCallSelect = short(-13827);
static const short ecInvalCallState = short(-13828);
static const short ecInvalCallStatelist = short(-13829);
static const short ecInvalCard = short(-13830);
static const short ecInvalCompletionID = short(-13831);
static const short ecInvalConfCallHandle = short(-13832);
static const short ecInvalConsultCallHandle = short(-13833);
static const short ecInvalCountryCode = short(-13834);
static const short ecInvalDeviceClass = short(-13835);
static const short ecInvalDeviceHandle = short(-13836);
static const short ecInvalDialParams = short(-13837);
static const short ecInvalDigitList = short(-13838);
static const short ecInvalDigitMode = short(-13839);
static const short ecInvalDigits = short(-13840);
static const short ecInvalExtVersion = short(-13841);
static const short ecInvalGroupID = short(-13842);
static const short ecInvalLineHandle = short(-13843);
static const short ecInvalLineState = short(-13844);
static const short ecInvalLocation = short(-13845);
static const short ecInvalMediaList = short(-13846);
static const short ecInvalMediaMode = short(-13847);
static const short ecInvalMessageID = short(-13848);
static const short ecInvalParam = short(-13850);
static const short ecInvalParkID = short(-13851);
static const short ecInvalParkMode = short(-13852);
static const short ecInvalPointer = short(-13853);
static const short ecInvalPrivSelect = short(-13854);
static const short ecInvalRate = short(-13855);
static const short ecInvalRequestMode = short(-13856);
static const short ecInvalTerminalID = short(-13857);
static const short ecInvalTerminalMode = short(-13858);
static const short ecInvalTimeout = short(-13859);
static const short ecInvalTone = short(-13860);
static const short ecInvalToneList = short(-13861);
static const short ecInvalToneMode = short(-13862);
static const short ecInvalTransferMode = short(-13863);
static const short ecLineMapperFailed = short(-13864);
static const short ecNoConference = short(-13865);
static const short ecNoDevice = short(-13866);
static const short ecNoDriver = short(-13867);
static const short ecNoMem = short(-13868);
static const short ecNoRequest = short(-13869);
static const short ecNotOwner = short(-13870);
static const short ecNotRegistered = short(-13871);
static const short ecOperationFailed = short(-13872);
static const short ecOperationUnavail = short(-13873);
static const short ecRateUnavail = short(-13874);
static const short ecResourceUnavail = short(-13875);
static const short ecRequestOverrun = short(-13876);
static const short ecStructureTooSmall = short(-13877);
static const short ecTargetNotFound = short(-13878);
static const short ecTargetSelf = short(-13879);
static const short ecUninitialized = short(-13880);
static const short ecUserUserInfoTooBig = short(-13881);
static const short ecReinit = short(-13882);
static const short ecAddressBlocked = short(-13883);
static const short ecBillingRejected = short(-13884);
static const short ecInvalFeature = short(-13885);
static const short ecNoMultipleInstance = short(-13886);
static const short ecTapiBusy = short(-13928);
static const short ecTapiNotSet = short(-13929);
static const short ecTapiNoSelect = short(-13930);
static const short ecTapiLoadFail = short(-13931);
static const short ecTapiGetAddrFail = short(-13932);
static const short ecTapiUnexpected = short(-13934);
static const short ecTapiVoiceNotSupported = short(-13935);
static const short ecTapiWaveFail = short(-13936);
static const short ecTapiCIDBlocked = short(-13937);
static const short ecTapiCIDOutOfArea = short(-13938);
static const short ecTapiWaveFormatError = short(-13939);
static const short ecTapiWaveReadError = short(-13940);
static const short ecTapiWaveBadFormat = short(-13941);
static const short ecTapiTranslateFail = short(-13942);
static const short ecTapiWaveDeviceInUse = short(-13943);
static const short ecTapiWaveFileExists = short(-13944);
static const short ecTapiWaveNoData = short(-13945);
static const short ecVoIPNotSupported = short(-13950);
static const short ecVoIPCallBusy = short(-13951);
static const short ecVoIPBadAddress = short(-13952);
static const short ecVoIPNoAnswer = short(-13953);
static const short ecVoIPCancelled = short(-13954);
static const short ecVoIPRejected = short(-13955);
static const short ecVoIPFailed = short(-13956);
static const short ecVoIPTapi3NotInstalled = short(-13957);
static const short ecVoIPH323NotFound = short(-13958);
static const short ecVoIPTapi3EventFailure = short(-13959);
static const short ecRasLoadFail = short(-13980);
static const System::WideChar cNul = (System::WideChar)(0x0);
static const System::WideChar cSoh = (System::WideChar)(0x1);
static const System::WideChar cStx = (System::WideChar)(0x2);
static const System::WideChar cEtx = (System::WideChar)(0x3);
static const System::WideChar cEot = (System::WideChar)(0x4);
static const System::WideChar cEnq = (System::WideChar)(0x5);
static const System::WideChar cAck = (System::WideChar)(0x6);
static const System::WideChar cBel = (System::WideChar)(0x7);
static const System::WideChar cBS = (System::WideChar)(0x8);
static const System::WideChar cTab = (System::WideChar)(0x9);
static const System::WideChar cLF = (System::WideChar)(0xa);
static const System::WideChar cVT = (System::WideChar)(0xb);
static const System::WideChar cFF = (System::WideChar)(0xc);
static const System::WideChar cCR = (System::WideChar)(0xd);
static const System::WideChar cSO = (System::WideChar)(0xe);
static const System::WideChar cSI = (System::WideChar)(0xf);
static const System::WideChar cDle = (System::WideChar)(0x10);
static const System::WideChar cDC1 = (System::WideChar)(0x11);
static const System::WideChar cXon = (System::WideChar)(0x11);
static const System::WideChar cDC2 = (System::WideChar)(0x12);
static const System::WideChar cDC3 = (System::WideChar)(0x13);
static const System::WideChar cXoff = (System::WideChar)(0x13);
static const System::WideChar cDC4 = (System::WideChar)(0x14);
static const System::WideChar cNak = (System::WideChar)(0x15);
static const System::WideChar cSyn = (System::WideChar)(0x16);
static const System::WideChar cEtb = (System::WideChar)(0x17);
static const System::WideChar cCan = (System::WideChar)(0x18);
static const System::WideChar cEM = (System::WideChar)(0x19);
static const System::WideChar cSub = (System::WideChar)(0x1a);
static const System::WideChar cEsc = (System::WideChar)(0x1b);
static const System::WideChar cFS = (System::WideChar)(0x1c);
static const System::WideChar cGS = (System::WideChar)(0x1d);
static const System::WideChar cRS = (System::WideChar)(0x1e);
static const System::WideChar cUS = (System::WideChar)(0x1f);
static const System::Int8 poUseEventWord = System::Int8(0x4);
static const System::Int8 ipAssertDTR = System::Int8(0x1);
static const System::Int8 ipAssertRTS = System::Int8(0x2);
static const System::Int8 ipAutoDTR = System::Int8(0x10);
static const System::Int8 ipAutoRTS = System::Int8(0x20);
static const System::Int8 hfUseDTR = System::Int8(0x1);
static const System::Int8 hfUseRTS = System::Int8(0x2);
static const System::Int8 hfRequireDSR = System::Int8(0x4);
static const System::Int8 hfRequireCTS = System::Int8(0x8);
static const System::Int8 sfTransmitFlow = System::Int8(0x1);
static const System::Int8 sfReceiveFlow = System::Int8(0x2);
static const System::Int8 dcb_Binary = System::Int8(0x1);
static const System::Int8 dcb_Parity = System::Int8(0x2);
static const System::Int8 dcb_OutxCTSFlow = System::Int8(0x4);
static const System::Int8 dcb_OutxDSRFlow = System::Int8(0x8);
static const System::Int8 dcb_DTRBit1 = System::Int8(0x10);
static const System::Int8 dcb_DTRBit2 = System::Int8(0x20);
static const System::Int8 dcb_DsrSensitivity = System::Int8(0x40);
static const System::Byte dcb_TxContinueOnXoff = System::Byte(0x80);
static const System::Word dcb_OutX = System::Word(0x100);
static const System::Word dcb_InX = System::Word(0x200);
static const System::Word dcb_ErrorChar = System::Word(0x400);
static const System::Word dcb_Null = System::Word(0x800);
static const System::Word dcb_RTSBit1 = System::Word(0x1000);
static const System::Word dcb_RTSBit2 = System::Word(0x2000);
static const System::Word dcb_AbortOnError = System::Word(0x4000);
static const System::Int8 dcb_DTR_CONTROL_ENABLE = System::Int8(0x10);
static const System::Int8 dcb_DTR_CONTROL_HANDSHAKE = System::Int8(0x20);
static const System::Word dcb_RTS_CONTROL_ENABLE = System::Word(0x1000);
static const System::Word dcb_RTS_CONTROL_HANDSHAKE = System::Word(0x2000);
static const System::Word dcb_RTS_CONTROL_TOGGLE = System::Word(0x3000);
static const System::Int8 fsOff = System::Int8(0x1);
static const System::Int8 fsOn = System::Int8(0x2);
static const System::Int8 fsDsrHold = System::Int8(0x3);
static const System::Int8 fsCtsHold = System::Int8(0x4);
static const System::Int8 fsDcdHold = System::Int8(0x5);
static const System::Int8 fsXOutHold = System::Int8(0x6);
static const System::Int8 fsXInHold = System::Int8(0x7);
static const System::Int8 fsXBothHold = System::Int8(0x8);
static const System::Int8 eNone = System::Int8(0x0);
static const System::Int8 eChar = System::Int8(0x1);
static const System::Int8 eGotoXY = System::Int8(0x2);
static const System::Int8 eUp = System::Int8(0x3);
static const System::Int8 eDown = System::Int8(0x4);
static const System::Int8 eRight = System::Int8(0x5);
static const System::Int8 eLeft = System::Int8(0x6);
static const System::Int8 eClearBelow = System::Int8(0x7);
static const System::Int8 eClearAbove = System::Int8(0x8);
static const System::Int8 eClearScreen = System::Int8(0x9);
static const System::Int8 eClearEndofLine = System::Int8(0xa);
static const System::Int8 eClearStartOfLine = System::Int8(0xb);
static const System::Int8 eClearLine = System::Int8(0xc);
static const System::Int8 eSetMode = System::Int8(0xd);
static const System::Int8 eSetBackground = System::Int8(0xe);
static const System::Int8 eSetForeground = System::Int8(0xf);
static const System::Int8 eSetAttribute = System::Int8(0x10);
static const System::Int8 eSaveCursorPos = System::Int8(0x11);
static const System::Int8 eRestoreCursorPos = System::Int8(0x12);
static const System::Int8 eDeviceStatusReport = System::Int8(0x13);
static const System::Int8 eString = System::Int8(0x14);
static const System::Int8 eHT = System::Int8(0x15);
static const System::Byte eError = System::Byte(0xff);
static const System::Int8 eAPC = System::Int8(0x1e);
static const System::Int8 eCBT = System::Int8(0x1f);
static const System::Int8 eCCH = System::Int8(0x20);
static const System::Int8 eCHA = System::Int8(0x21);
static const System::Int8 eCHT = System::Int8(0x22);
static const System::Int8 eCNL = System::Int8(0x23);
static const System::Int8 eCPL = System::Int8(0x24);
static const System::Int8 eCPR = System::Int8(0x25);
static const System::Int8 eCRM = System::Int8(0x26);
static const System::Int8 eCTC = System::Int8(0x27);
static const System::Int8 eCUB = System::Int8(0x6);
static const System::Int8 eCUD = System::Int8(0x4);
static const System::Int8 eCUF = System::Int8(0x5);
static const System::Int8 eCUP = System::Int8(0x2);
static const System::Int8 eCUU = System::Int8(0x3);
static const System::Int8 eCVT = System::Int8(0x28);
static const System::Int8 eDA = System::Int8(0x29);
static const System::Int8 eDAQ = System::Int8(0x2a);
static const System::Int8 eDCH = System::Int8(0x2b);
static const System::Int8 eDCS = System::Int8(0x2c);
static const System::Int8 eDL = System::Int8(0x2d);
static const System::Int8 eDMI = System::Int8(0x2e);
static const System::Int8 eDSR = System::Int8(0x13);
static const System::Int8 eEA = System::Int8(0x2f);
static const System::Int8 eEBM = System::Int8(0x30);
static const System::Int8 eECH = System::Int8(0x31);
static const System::Int8 eED = System::Int8(0x32);
static const System::Int8 eEF = System::Int8(0x33);
static const System::Int8 eEL = System::Int8(0x34);
static const System::Int8 eEMI = System::Int8(0x35);
static const System::Int8 eEPA = System::Int8(0x36);
static const System::Int8 eERM = System::Int8(0x37);
static const System::Int8 eESA = System::Int8(0x38);
static const System::Int8 eFEAM = System::Int8(0x39);
static const System::Int8 eFETM = System::Int8(0x3a);
static const System::Int8 eFNT = System::Int8(0x3b);
static const System::Int8 eGATM = System::Int8(0x3c);
static const System::Int8 eGSM = System::Int8(0x3d);
static const System::Int8 eGSS = System::Int8(0x3e);
static const System::Int8 eHEM = System::Int8(0x3f);
static const System::Int8 eHPA = System::Int8(0x21);
static const System::Int8 eHPR = System::Int8(0x5);
static const System::Int8 eHTJ = System::Int8(0x40);
static const System::Int8 eHTS = System::Int8(0x41);
static const System::Int8 eHVP = System::Int8(0x2);
static const System::Int8 eICH = System::Int8(0x42);
static const System::Int8 eIL = System::Int8(0x43);
static const System::Int8 eIND = System::Int8(0x4);
static const System::Int8 eINT = System::Int8(0x44);
static const System::Int8 eIRM = System::Int8(0x45);
static const System::Int8 eJFY = System::Int8(0x46);
static const System::Int8 eKAM = System::Int8(0x47);
static const System::Int8 eLNM = System::Int8(0x48);
static const System::Int8 eMATM = System::Int8(0x49);
static const System::Int8 eMC = System::Int8(0x4a);
static const System::Int8 eMW = System::Int8(0x4b);
static const System::Int8 eNEL = System::Int8(0x4c);
static const System::Int8 eNP = System::Int8(0x4d);
static const System::Int8 eOSC = System::Int8(0x4e);
static const System::Int8 ePLD = System::Int8(0x4f);
static const System::Int8 ePLU = System::Int8(0x50);
static const System::Int8 ePM = System::Int8(0x51);
static const System::Int8 ePP = System::Int8(0x52);
static const System::Int8 ePU1 = System::Int8(0x53);
static const System::Int8 ePU2 = System::Int8(0x54);
static const System::Int8 ePUM = System::Int8(0x55);
static const System::Int8 eQUAD = System::Int8(0x56);
static const System::Int8 eREP = System::Int8(0x57);
static const System::Int8 eRI = System::Int8(0x58);
static const System::Int8 eRIS = System::Int8(0x59);
static const System::Int8 eRM = System::Int8(0x5a);
static const System::Int8 eSATM = System::Int8(0x5b);
static const System::Int8 eSD = System::Int8(0x5c);
static const System::Int8 eSEM = System::Int8(0x5d);
static const System::Int8 eSGR = System::Int8(0x10);
static const System::Int8 eSL = System::Int8(0x5e);
static const System::Int8 eSM = System::Int8(0xd);
static const System::Int8 eSPA = System::Int8(0x5f);
static const System::Int8 eSPI = System::Int8(0x60);
static const System::Int8 eSR = System::Int8(0x61);
static const System::Int8 eSRM = System::Int8(0x62);
static const System::Int8 eSRTM = System::Int8(0x63);
static const System::Int8 eSS2 = System::Int8(0x64);
static const System::Int8 eSS3 = System::Int8(0x65);
static const System::Int8 eSSA = System::Int8(0x66);
static const System::Int8 eST = System::Int8(0x67);
static const System::Int8 eSTS = System::Int8(0x68);
static const System::Int8 eSU = System::Int8(0x69);
static const System::Int8 eTBC = System::Int8(0x6a);
static const System::Int8 eTSM = System::Int8(0x6b);
static const System::Int8 eTSS = System::Int8(0x6c);
static const System::Int8 eTTM = System::Int8(0x6d);
static const System::Int8 eVEM = System::Int8(0x6e);
static const System::Int8 eVPA = System::Int8(0x6f);
static const System::Int8 eVPR = System::Int8(0x4);
static const System::Int8 eVTS = System::Int8(0x70);
static const System::Int8 eDECSTBM = System::Int8(0x71);
static const System::Int8 eENQ = System::Int8(0x72);
static const System::Int8 eBEL = System::Int8(0x73);
static const System::Int8 eBS = System::Int8(0x74);
static const System::Int8 eLF = System::Int8(0x75);
static const System::Int8 eCR = System::Int8(0x76);
static const System::Int8 eSO = System::Int8(0x77);
static const System::Int8 eSI = System::Int8(0x78);
static const System::Int8 eIND2 = System::Int8(0x79);
static const System::Int8 eDECALN = System::Int8(0x7a);
static const System::Int8 eDECDHL = System::Int8(0x7b);
static const System::Int8 eDECDWL = System::Int8(0x7c);
static const System::Int8 eDECLL = System::Int8(0x7d);
static const System::Int8 eDECREQTPARM = System::Int8(0x7e);
static const System::Int8 eDECSWL = System::Int8(0x7f);
static const System::Byte eDECTST = System::Byte(0x80);
static const System::Byte eDECSCS = System::Byte(0x81);
static const System::Int8 eattrBlink = System::Int8(0x1);
static const System::Int8 eattrInverse = System::Int8(0x2);
static const System::Int8 eattrIntense = System::Int8(0x4);
static const System::Int8 eattrInvisible = System::Int8(0x8);
static const System::Int8 eattrUnderline = System::Int8(0x10);
static const System::Int8 emBlack = System::Int8(0x0);
static const System::Int8 emRed = System::Int8(0x1);
static const System::Int8 emGreen = System::Int8(0x2);
static const System::Int8 emYellow = System::Int8(0x3);
static const System::Int8 emBlue = System::Int8(0x4);
static const System::Int8 emMagenta = System::Int8(0x5);
static const System::Int8 emCyan = System::Int8(0x6);
static const System::Int8 emWhite = System::Int8(0x7);
static const System::Int8 emBlackBold = System::Int8(0x8);
static const System::Int8 emRedBold = System::Int8(0x9);
static const System::Int8 emGreenBold = System::Int8(0xa);
static const System::Int8 emYellowBold = System::Int8(0xb);
static const System::Int8 emBlueBold = System::Int8(0xc);
static const System::Int8 emMagentaBold = System::Int8(0xd);
static const System::Int8 emCyanBold = System::Int8(0xe);
static const System::Int8 emWhiteBold = System::Int8(0xf);
static const System::Int8 teMapVT100 = System::Int8(0x1);
static const System::Int8 MaxParams = System::Int8(0x5);
static const System::Int8 MaxQueue = System::Int8(0x14);
static const System::Int8 MaxOther = System::Int8(0xb);
static const System::Int8 MaxParamLength = System::Int8(0x5);
static const System::Int8 KeyMappingLen = System::Int8(0x14);
static const System::Int8 gwl_Terminal = System::Int8(0x0);
static const System::Int8 tws_WantTab = System::Int8(0x1);
static const System::Int8 tws_IntHeight = System::Int8(0x2);
static const System::Int8 tws_IntWidth = System::Int8(0x4);
static const System::Int8 tws_AutoHScroll = System::Int8(0x8);
static const System::Int8 tws_AutoVScroll = System::Int8(0x10);
static const System::Word MaxDBRecs = System::Word(0x3e7);
static const System::Int8 MaxNameLen = System::Int8(0x15);
static const System::Int8 MaxIndexLen = System::Int8(0x1f);
static const System::WideChar NonValue = (System::WideChar)(0x23);
#define dbIndex L"Index"
#define dbDefaults L"Defaults"
#define dbNumEntries L"_Entries"
#define dbBogus L"None"
static const System::Int8 ApdMaxTags = System::Int8(0x5);
static const System::WideChar ApdTagSepChar = (System::WideChar)(0x2c);
static const System::Int8 ApdModemNameLen = System::Int8(0x1f);
static const System::Int8 ApdCmdLen = System::Int8(0x29);
static const System::Int8 ApdRspLen = System::Int8(0x15);
static const System::Int8 ApdTagLen = System::Int8(0x15);
static const System::Int8 ApdTagProfLen = System::Int8(0x69);
static const System::Int8 ApdBoolLen = System::Int8(0x5);
static const System::Int8 ApdBaudLen = System::Int8(0x7);
static const System::Byte ApdConfigLen = System::Byte(0xff);
static const System::Int8 ksControl = System::Int8(0x2);
static const System::Int8 ksAlt = System::Int8(0x4);
static const System::Int8 ksShift = System::Int8(0x8);
static const System::Int8 tsCapital = System::Int8(0x2);
static const System::Int8 tsNumlock = System::Int8(0x4);
static const System::Int8 tsScroll = System::Int8(0x8);
static const System::Int8 ApdKeyMapNameLen = System::Int8(0x1e);
static const System::Int8 ApdMaxKeyMaps = System::Int8(0x64);
#define ApdKeyIndexName L"EMULATOR"
static const System::Int8 ApdKeyIndexMaxLen = System::Int8(0x78);
static const System::Int8 apIncludeDirectory = System::Int8(0x1);
static const System::Int8 apHonorDirectory = System::Int8(0x2);
static const System::Int8 apRTSLowForWrite = System::Int8(0x4);
static const System::Int8 apAbortNoCarrier = System::Int8(0x8);
static const System::Int8 apKermitLongPackets = System::Int8(0x10);
static const System::Int8 apKermitSWC = System::Int8(0x20);
static const System::Int8 apZmodem8K = System::Int8(0x40);
static const System::Byte apBP2KTransmit = System::Byte(0x80);
static const System::Word apAsciiSuppressCtrlZ = System::Word(0x100);
static const System::Int8 DefProtocolOptions = System::Int8(0x0);
static const System::Int8 BadProtocolOptions = System::Int8(0x70);
static const System::Int8 bcNone = System::Int8(0x0);
static const System::Int8 bcChecksum1 = System::Int8(0x1);
static const System::Int8 bcChecksum2 = System::Int8(0x2);
static const System::Int8 bcCrc16 = System::Int8(0x3);
static const System::Int8 bcCrc32 = System::Int8(0x4);
static const System::Int8 bcCrcK = System::Int8(0x5);
#define bcsNone L"No check"
#define bcsChecksum1 L"Checksum"
#define bcsChecksum2 L"Checksum2"
#define bcsCrc16 L"Crc16"
#define bcsCrc32 L"Crc32"
#define bcsCrck L"CrcKermit"
static const System::Int8 NoProtocol = System::Int8(0x0);
static const System::Int8 Xmodem = System::Int8(0x1);
static const System::Int8 XmodemCRC = System::Int8(0x2);
static const System::Int8 Xmodem1K = System::Int8(0x3);
static const System::Int8 Xmodem1KG = System::Int8(0x4);
static const System::Int8 Ymodem = System::Int8(0x5);
static const System::Int8 YmodemG = System::Int8(0x6);
static const System::Int8 Zmodem = System::Int8(0x7);
static const System::Int8 Kermit = System::Int8(0x8);
static const System::Int8 Ascii = System::Int8(0x9);
static const System::Int8 BPlus = System::Int8(0xa);
static const System::Int8 MaxAttentionLen = System::Int8(0x20);
static const System::Int8 zfWriteNewerLonger = System::Int8(0x1);
static const System::Int8 zfWriteCrc = System::Int8(0x2);
static const System::Int8 zfWriteAppend = System::Int8(0x3);
static const System::Int8 zfWriteClobber = System::Int8(0x4);
static const System::Int8 zfWriteNewer = System::Int8(0x5);
static const System::Int8 zfWriteDifferent = System::Int8(0x6);
static const System::Int8 zfWriteProtect = System::Int8(0x7);
extern DELPHI_PACKAGE System::StaticArray<System::StaticArray<char, 10>, 11> ProtocolString;
static const System::Int8 rw1728 = System::Int8(0x1);
static const System::Int8 rw2048 = System::Int8(0x2);
static const System::Word StandardWidth = System::Word(0x6c0);
static const System::Word WideWidth = System::Word(0x800);
static const System::Int8 ffHighRes = System::Int8(0x1);
static const System::Int8 ffHighWidth = System::Int8(0x2);
static const System::Int8 ffLengthWords = System::Int8(0x4);
static const System::Int8 fcDoubleWidth = System::Int8(0x1);
static const System::Int8 fcHalfHeight = System::Int8(0x2);
static const System::Int8 fcCenterImage = System::Int8(0x4);
static const System::Int8 fcYield = System::Int8(0x8);
static const System::Int8 fcYieldOften = System::Int8(0x10);
static const System::Int8 csStarting = System::Int8(0x1);
static const System::Int8 csEnding = System::Int8(0x2);
static const System::Int8 SmallFont = System::Int8(0x10);
static const System::Int8 StandardFont = System::Int8(0x30);
static const System::Word MaxTreeRec = System::Word(0x132);
static const System::Word MaxData = System::Word(0x1000);
static const System::Byte MaxLineLen = System::Byte(0x90);
static const System::Int8 MaxCodeTable = System::Int8(0x3f);
static const System::Int8 MaxMUCodeTable = System::Int8(0x27);
#define DefTextExt L"TXT"
#define DefTiffExt L"TIF"
#define DefPcxExt L"PCX"
#define DefDcxExt L"DCX"
#define DefBmpExt L"BMP"
#define DefApfExt L"APF"
extern DELPHI_PACKAGE TSigArray DefAPFSig;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_BracketAngleLeft;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_BracketAngleRight;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_BracketSquareLeft;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_BracketSquareRight;
extern DELPHI_PACKAGE System::StaticArray<int, 6> Xpc_CDATAStart;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_CharacterRef;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_CharacterRefHex;
extern DELPHI_PACKAGE System::StaticArray<int, 3> Xpc_CommentEnd;
extern DELPHI_PACKAGE System::StaticArray<int, 4> Xpc_CommentStart;
extern DELPHI_PACKAGE System::StaticArray<int, 3> Xpc_ConditionalEnd;
extern DELPHI_PACKAGE System::StaticArray<int, 6> Xpc_ConditionalIgnore;
extern DELPHI_PACKAGE System::StaticArray<int, 7> Xpc_ConditionalInclude;
extern DELPHI_PACKAGE System::StaticArray<int, 3> Xpc_ConditionalStart;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_Dash;
extern DELPHI_PACKAGE System::StaticArray<int, 5> Xpc_DTDAttFixed;
extern DELPHI_PACKAGE System::StaticArray<int, 7> Xpc_DTDAttImplied;
extern DELPHI_PACKAGE System::StaticArray<int, 9> Xpc_DTDAttlist;
extern DELPHI_PACKAGE System::StaticArray<int, 8> Xpc_DTDAttRequired;
extern DELPHI_PACKAGE System::StaticArray<int, 9> Xpc_DTDDocType;
extern DELPHI_PACKAGE System::StaticArray<int, 9> Xpc_DTDElement;
extern DELPHI_PACKAGE System::StaticArray<int, 3> Xpc_DTDElementAny;
extern DELPHI_PACKAGE System::StaticArray<int, 7> Xpc_DTDElementCharData;
extern DELPHI_PACKAGE System::StaticArray<int, 5> Xpc_DTDElementEmpty;
extern DELPHI_PACKAGE System::StaticArray<int, 8> Xpc_DTDEntity;
extern DELPHI_PACKAGE System::StaticArray<int, 10> Xpc_DTDNotation;
extern DELPHI_PACKAGE System::StaticArray<int, 8> Xpc_Encoding;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_Equation;
extern DELPHI_PACKAGE System::StaticArray<int, 6> Xpc_ExternalPublic;
extern DELPHI_PACKAGE System::StaticArray<int, 6> Xpc_ExternalSystem;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_GenParsedEntityEnd;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_ListOperator;
extern DELPHI_PACKAGE System::StaticArray<int, 2> Xpc_MixedEnd;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_OneOrMoreOpr;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_ParamEntity;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_ParenLeft;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_ParenRight;
extern DELPHI_PACKAGE System::StaticArray<int, 2> Xpc_ProcessInstrEnd;
extern DELPHI_PACKAGE System::StaticArray<int, 2> Xpc_ProcessInstrStart;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_QuoteDouble;
extern DELPHI_PACKAGE System::StaticArray<int, 1> Xpc_QuoteSingle;
extern DELPHI_PACKAGE System::StaticArray<int, 10> Xpc_Standalone;
extern DELPHI_PACKAGE System::StaticArray<int, 5> Xpc_UnparsedEntity;
extern DELPHI_PACKAGE System::StaticArray<int, 7> Xpc_Version;
static const System::Int8 LIT_CHAR_REF = System::Int8(0x1);
static const System::Int8 LIT_ENTITY_REF = System::Int8(0x2);
static const System::Int8 LIT_PE_REF = System::Int8(0x4);
static const System::Int8 LIT_NORMALIZE = System::Int8(0x8);
static const System::Int8 CONTEXT_NONE = System::Int8(0x0);
static const System::Int8 CONTEXT_DTD = System::Int8(0x1);
static const System::Int8 CONTEXT_ENTITYVALUE = System::Int8(0x2);
static const System::Int8 CONTEXT_ATTRIBUTEVALUE = System::Int8(0x3);
static const System::Int8 CONTENT_UNDECLARED = System::Int8(0x0);
static const System::Int8 CONTENT_ANY = System::Int8(0x1);
static const System::Int8 CONTENT_EMPTY = System::Int8(0x2);
static const System::Int8 CONTENT_MIXED = System::Int8(0x3);
static const System::Int8 CONTENT_ELEMENTS = System::Int8(0x4);
static const System::Int8 OCCURS_REQ_NOREPEAT = System::Int8(0x0);
static const System::Int8 OCCURS_OPT_NOREPEAT = System::Int8(0x1);
static const System::Int8 OCCURS_OPT_REPEAT = System::Int8(0x2);
static const System::Int8 OCCURS_REQ_REPEAT = System::Int8(0x3);
static const System::Int8 REL_OR = System::Int8(0x0);
static const System::Int8 REL_AND = System::Int8(0x1);
static const System::Int8 REL_NONE = System::Int8(0x2);
static const System::Int8 ATTRIBUTE_UNDECLARED = System::Int8(0x0);
static const System::Int8 ATTRIBUTE_CDATA = System::Int8(0x1);
static const System::Int8 ATTRIBUTE_ID = System::Int8(0x2);
static const System::Int8 ATTRIBUTE_IDREF = System::Int8(0x3);
static const System::Int8 ATTRIBUTE_IDREFS = System::Int8(0x4);
static const System::Int8 ATTRIBUTE_ENTITY = System::Int8(0x5);
static const System::Int8 ATTRIBUTE_ENTITIES = System::Int8(0x6);
static const System::Int8 ATTRIBUTE_NMTOKEN = System::Int8(0x7);
static const System::Int8 ATTRIBUTE_NMTOKENS = System::Int8(0x8);
static const System::Int8 ATTRIBUTE_ENUMERATED = System::Int8(0x9);
static const System::Int8 ATTRIBUTE_NOTATION = System::Int8(0xa);
static const System::Int8 ATTRIBUTE_DEFAULT_UNDECLARED = System::Int8(0x0);
static const System::Int8 ATTRIBUTE_DEFAULT_SPECIFIED = System::Int8(0x1);
static const System::Int8 ATTRIBUTE_DEFAULT_IMPLIED = System::Int8(0x2);
static const System::Int8 ATTRIBUTE_DEFAULT_REQUIRED = System::Int8(0x3);
static const System::Int8 ATTRIBUTE_DEFAULT_FIXED = System::Int8(0x4);
static const System::Int8 ENTITY_UNDECLARED = System::Int8(0x0);
static const System::Int8 ENTITY_INTERNAL = System::Int8(0x1);
static const System::Int8 ENTITY_NDATA = System::Int8(0x2);
static const System::Int8 ENTITY_TEXT = System::Int8(0x3);
static const System::Int8 CONDITIONAL_INCLUDE = System::Int8(0x0);
static const System::Int8 CONDITIONAL_IGNORE = System::Int8(0x1);
static const System::Word LineBufferSize = System::Word(0x1000);
static const System::Int8 DMSize = System::Int8(0x20);
static const System::Int8 upStarting = System::Int8(0x1);
static const System::Int8 upEnding = System::Int8(0x2);
static const System::Int8 usStarting = System::Int8(0x1);
static const System::Int8 usEnding = System::Int8(0x2);
static const System::Int8 ufYield = System::Int8(0x1);
static const System::Int8 ufAutoDoubleHeight = System::Int8(0x2);
static const System::Int8 ufAutoHalfWidth = System::Int8(0x4);
static const System::Int8 ufAbort = System::Int8(0x8);
static const System::Int8 DefUnpackOptions = System::Int8(0x3);
static const unsigned BadUnpackOptions = unsigned(0x0);
static const unsigned RasterBufferPageSize = unsigned(0x400);
static const int DCXHeaderID = int(0x3ade68b1);
static const System::Int8 gwl_Viewer = System::Int8(0x0);
static const System::Int8 vws_DragDrop = System::Int8(0x1);
static const int DefViewerBG = int(0xffffff);
static const System::Int8 DefViewerFG = System::Int8(0x0);
static const System::Int8 DefVScrollInc = System::Int8(0x8);
static const System::Int8 DefHScrollInc = System::Int8(0x8);
extern DELPHI_PACKAGE unsigned DefConnectAttempts;
extern DELPHI_PACKAGE int DefMaxRetries;
extern DELPHI_PACKAGE int DefStatusTimeout;
extern DELPHI_PACKAGE System::UnicodeString DefNormalInit;
extern DELPHI_PACKAGE System::UnicodeString DefBlindInit;
extern DELPHI_PACKAGE System::UnicodeString DefNoDetectBusyInit;
extern DELPHI_PACKAGE System::UnicodeString DefX1Init;
extern DELPHI_PACKAGE System::UnicodeString DefTapiInit;
extern DELPHI_PACKAGE unsigned DefStatusBytes;
extern DELPHI_PACKAGE unsigned MaxBadPercent;
extern DELPHI_PACKAGE unsigned FlushWait;
extern DELPHI_PACKAGE unsigned FrameWait;
static const System::Int8 afAbortNoConnect = System::Int8(0x1);
static const System::Int8 afExitOnError = System::Int8(0x2);
static const System::Int8 afCASSubmitUseControl = System::Int8(0x4);
static const System::Int8 afSoftwareFlow = System::Int8(0x8);
extern DELPHI_PACKAGE unsigned DefFaxOptions;
static const unsigned BadFaxOptions = unsigned(0x0);
static const System::Int8 ftNone = System::Int8(0x0);
static const System::Int8 ftClass12 = System::Int8(0x1);
static const System::Int8 MaxTrigData = System::Int8(0x15);
static const System::Int8 MaxDataPointers = System::Int8(0x3);
static const System::Int8 TimerFreq = System::Int8(0x32);
static const System::Int8 dpProtocol = System::Int8(0x1);
static const System::Int8 dpFax = System::Int8(0x2);
static const System::Int8 dpModem = System::Int8(0x3);
static const System::Int8 MaxTraceCol = System::Int8(0x4e);
static const int HighestTrace = int(0x3d0900);
static const int MaxDLogQueueSize = int(0xf42400);
extern DELPHI_PACKAGE void __fastcall AssignFile(System::file &F, const System::UnicodeString FileName)/* overload */;
extern DELPHI_PACKAGE void __fastcall AssignFile(System::TextFile &F, const System::UnicodeString FileName)/* overload */;
extern DELPHI_PACKAGE void __fastcall Assign(System::file &F, const System::UnicodeString FileName)/* overload */;
extern DELPHI_PACKAGE void __fastcall Assign(System::TextFile &F, const System::UnicodeString FileName)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall MinWord(unsigned A, unsigned B);
extern DELPHI_PACKAGE System::LongBool __fastcall FlagIsSet(unsigned Flags, unsigned FlagMask);
extern DELPHI_PACKAGE void __fastcall ClearFlag(unsigned &Flags, unsigned FlagMask);
extern DELPHI_PACKAGE void __fastcall SetFlag(unsigned &Flags, unsigned FlagMask);
extern DELPHI_PACKAGE System::LongBool __fastcall ByteFlagIsSet(System::Byte Flags, System::Byte FlagMask);
extern DELPHI_PACKAGE void __fastcall ClearByteFlag(System::Byte &Flags, System::Byte FlagMask);
extern DELPHI_PACKAGE void __fastcall SetByteFlag(System::Byte &Flags, System::Byte FlagMask);
extern DELPHI_PACKAGE void * __fastcall AddWordToPtr(void * P, unsigned W);
extern DELPHI_PACKAGE int __fastcall SafeYield(void);
extern DELPHI_PACKAGE unsigned __fastcall AdTimeGetTime(void);
extern DELPHI_PACKAGE int __fastcall Ticks2Secs(int Ticks);
extern DELPHI_PACKAGE int __fastcall Secs2Ticks(int Secs);
extern DELPHI_PACKAGE int __fastcall MSecs2Ticks(int MSecs);
extern DELPHI_PACKAGE void __fastcall NewTimer(EventTimer &ET, int Ticks);
extern DELPHI_PACKAGE void __fastcall NewTimerSecs(EventTimer &ET, int Secs);
extern DELPHI_PACKAGE System::LongBool __fastcall TimerExpired(EventTimer ET);
extern DELPHI_PACKAGE int __fastcall ElapsedTime(EventTimer ET);
extern DELPHI_PACKAGE int __fastcall ElapsedTimeInSecs(EventTimer ET);
extern DELPHI_PACKAGE int __fastcall RemainingTime(EventTimer ET);
extern DELPHI_PACKAGE int __fastcall RemainingTimeInSecs(EventTimer ET);
extern DELPHI_PACKAGE int __fastcall DelayTicks(int Ticks, System::LongBool Yield);
extern DELPHI_PACKAGE System::WideChar * __fastcall Long2StrZ(System::WideChar * Dest, int L);
extern DELPHI_PACKAGE System::LongBool __fastcall Str2LongZ(System::WideChar * S, int &I);
extern DELPHI_PACKAGE System::UnicodeString __fastcall JustPathnameZ(/* out */ System::UnicodeString &Dest, System::UnicodeString PathName)/* overload */;
extern DELPHI_PACKAGE char * __fastcall JustPathnameZ(char * Dest, char * PathName)/* overload */;
extern DELPHI_PACKAGE char * __fastcall JustFilenameZ(char * Dest, char * PathName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall JustExtensionZ(/* out */ System::UnicodeString &Dest, System::UnicodeString Name)/* overload */;
extern DELPHI_PACKAGE char * __fastcall StrStCopy(char * Dest, char * S, unsigned Pos, unsigned Count)/* overload */;
extern DELPHI_PACKAGE System::WideChar * __fastcall StrStCopy(System::WideChar * Dest, System::WideChar * S, unsigned Pos, unsigned Count)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall AddBackSlashZ(/* out */ System::UnicodeString &Dest, System::UnicodeString DirName)/* overload */;
extern DELPHI_PACKAGE char * __fastcall AddBackSlashZ(char * Dest, char * DirName)/* overload */;
extern DELPHI_PACKAGE System::LongBool __fastcall ExistFileZ(System::UnicodeString FName)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall ForceExtensionZ(/* out */ System::UnicodeString &Dest, System::UnicodeString Name, System::UnicodeString Ext)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall DefaultExtensionZ(/* out */ System::UnicodeString &Dest, System::UnicodeString Name, System::UnicodeString Ext)/* overload */;
extern DELPHI_PACKAGE void * __fastcall GetPtr(void * P, int O);
extern DELPHI_PACKAGE void __fastcall NotBuffer(void *Buf, unsigned Len);
extern DELPHI_PACKAGE unsigned __fastcall DelayMS(unsigned MS);
extern DELPHI_PACKAGE System::UnicodeString __fastcall JustName(System::UnicodeString PathName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall AddBackSlash(const System::UnicodeString DirName)/* overload */;
extern DELPHI_PACKAGE System::AnsiString __fastcall AddBackSlash(const System::AnsiString DirName)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsWin2000(void);
extern DELPHI_PACKAGE bool __fastcall IsWinNT(void);
extern DELPHI_PACKAGE int __fastcall ApWinExecAndWait32(System::WideChar * FileName, System::WideChar * CommandLine, int Visibility);
}	/* namespace Oomisc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OOMISC)
using namespace Oomisc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OomiscHPP
