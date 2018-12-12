// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AwTPcl.pas' rev: 32.00 (Windows)

#ifndef AwtpclHPP
#define AwtpclHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <OoMisc.hpp>
#include <AdPort.hpp>
#include <AwUser.hpp>

//-- user supplied -----------------------------------------------------------

namespace Awtpcl
{
//-- forward type declarations -----------------------------------------------
struct TSlotInfo;
struct TSABuffer;
struct ParamsRecord;
struct TKermitOptions;
struct TProtocolData;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TProcessBlockStart : unsigned char { pbsNone, pbs128, pbs1024, pbsCancel, pbsEOT };

struct DECLSPEC_DRECORD TSlotInfo
{
public:
	int Len;
	int Seq;
	System::LongBool InUse;
	System::LongBool Acked;
	unsigned Retries;
};


typedef System::StaticArray<TSlotInfo, 27> TInfoTable;

typedef System::StaticArray<char, 27648> TDataTable;

typedef TDataTable *PDataTable;

enum DECLSPEC_DENUM TXmodemState : unsigned char { txInitial, txHandshake, txGetBlock, txWaitFreeSpace, txSendBlock, txDraining, txReplyPending, txEndDrain, txFirstEndOfTransmit, txRestEndOfTransmit, txEotReply, txFinished, txDone, rxInitial, rxWaitForHSReply, rxWaitForBlockStart, rxCollectBlock, rxProcessBlock, rxFinishedSkip, rxFinished, rxDone };

enum DECLSPEC_DENUM TYmodemState : unsigned char { tyInitial, tyHandshake, tyGetFileName, tySendFileName, tyDraining, tyReplyPending, tyPrepXmodem, tySendXmodem, tyFinished, tyFinishDrain, tyDone, ryInitial, ryDelay, ryWaitForHSReply, ryWaitForBlockStart, ryCollectBlock, ryProcessBlock, ryOpenFile, ryPrepXmodem, ryReceiveXmodem, ryFinished, ryDone };

enum DECLSPEC_DENUM TZmodemState : unsigned char { tzInitial, tzHandshake, tzGetFile, tzSendFile, tzCheckFile, tzStartData, tzEscapeData, tzSendData, tzWaitAck, tzSendEof, tzDrainEof, tzCheckEof, tzSendFinish, tzCheckFinish, tzError, tzCleanup, tzDone, tzSInit, tzCheckSInit, rzRqstFile, rzDelay, rzWaitFile, rzCollectFile, rzSendInit, rzSendBlockPrep, rzSendBlock, rzSync, rzStartFile, rzStartData, rzCollectData, rzGotData, rzWaitEof, rzEndOfFile, rzSendFinish, rzCollectFinish, rzError, rzWaitCancel, rzCleanup, rzDone };

enum DECLSPEC_DENUM THeaderState : unsigned char { hsNone, hsGotZPad, hsGotZDle, hsGotZBin, hsGotZBin32, hsGotZHex, hsGotHeader };

enum DECLSPEC_DENUM HexHeaderStates : unsigned char { hhFrame, hhPos1, hhPos2, hhPos3, hhPos4, hhCrc1, hhCrc2 };

enum DECLSPEC_DENUM BinaryHeaderStates : unsigned char { bhFrame, bhPos1, bhPos2, bhPos3, bhPos4, bhCrc1, bhCrc2, bhCrc3, bhCrc4 };

enum DECLSPEC_DENUM ReceiveBlockStates : unsigned char { rbData, rbCrc };

enum DECLSPEC_DENUM TKermitState : unsigned char { tkInit, tkInitReply, tkCollectInit, tkOpenFile, tkSendFile, tkFileReply, tkCollectFile, tkCheckTable, tkSendData, tkBlockReply, tkCollectBlock, tkSendEof, tkEofReply, tkCollectEof, tkSendBreak, tkBreakReply, tkCollectBreak, tkComplete, tkWaitCancel, tkError, tkDone, rkInit, rkGetInit, rkCollectInit, rkGetFile, rkCollectFile, rkGetData, rkCollectData, rkComplete, rkWaitCancel, rkError, rkDone };

enum DECLSPEC_DENUM TKermitHeaderState : unsigned char { hskNone, hskGotMark, hskGotLen, hskGotSeq, hskGotType, hskGotLong1, hskGotLong2, hskDone };

enum DECLSPEC_DENUM TKermitDataState : unsigned char { dskData, dskCheck1, dskCheck2, dskCheck3 };

typedef System::StaticArray<char, 2048> TBPDataBlock;

typedef TBPDataBlock *PBPDataBlock;

struct DECLSPEC_DRECORD TSABuffer
{
public:
	unsigned Seq;
	unsigned Num;
	char PType;
	TBPDataBlock *Buf;
};


typedef System::StaticArray<TSABuffer, 2> TSPackets;

typedef System::StaticArray<System::Byte, 8> TQuoteArray;

typedef System::StaticArray<char, 256> TQuoteTable;

enum DECLSPEC_DENUM TBPlusState : unsigned char { rbInitial, rbGetDLE, rbGetB, rbCollectPacket, rbProcessPacket, rbFinished, rbSendEnq, rbError, rbWaitErrorAck, rbCleanup, rbDone, tbInitial, tbGetBlock, tbWaitFreeSpace, tbSendData, tbCheckAck, tbEndOfFile, tbEofAck, tbError, tbWaitErrorAck, tbCleanup, tbDone };

enum DECLSPEC_DENUM TPacketState : unsigned char { psGetDLE, psGetB, psGetSeq, psGetType, psGetData, psGetCheck1, psGetCheck2, psCheckCheck, psSendAck, psError, psSuccess };

enum DECLSPEC_DENUM TTermPacketState : unsigned char { tpsWaitB, tpsWaitSeq, tpsWaitType, tpsCollectPlus, tpsCollectAckPlus, tpsCollectT, tpsCollectAckT, tpsError };

enum DECLSPEC_DENUM TAckCollectionState : unsigned char { acGetDLE, acGetNum, acHaveAck, acGetPacket, acCollectPacket, acSkipPacket1, acSkipPacket2, acSkipPacket3, acSkipPacket4, acSkipPacket5, acTimeout, acError, acSendNak, acSendEnq, acResync1, acResync2, acResync3, acResync4, acSendData, acFailed };

enum DECLSPEC_DENUM TDirection : unsigned char { dUpload, dDownload };

struct DECLSPEC_DRECORD ParamsRecord
{
public:
	System::Byte WinSend;
	System::Byte WinRecv;
	System::Byte BlkSize;
	System::Byte ChkType;
	TQuoteArray QuoteSet;
	System::Byte DROpt;
	System::Byte UROpt;
	System::Byte FIOpt;
};


enum DECLSPEC_DENUM TAsciiState : unsigned char { taInitial, taGetBlock, taWaitFreeSpace, taSendBlock, taSendDelay, taFinishDrain, taFinished, taDone, raInitial, raCollectBlock, raProcessBlock, raFinished, raDone };

typedef System::StaticArray<char, 1024> TDataBlock;

typedef TDataBlock *PDataBlock;

typedef System::StaticArray<char, 2048> TWorkBlock;

typedef TWorkBlock *PWorkBlock;

typedef System::StaticArray<char, 4096> TInBuffer;

typedef TInBuffer *PInBuffer;

typedef System::StaticArray<System::Byte, 4> TPosFlags;

typedef System::StaticArray<System::Byte, 8192> TFileBuffer;

typedef TFileBuffer *PFileBuffer;

typedef TProtocolData *PProtocolData;

typedef void __fastcall (*TPrepareProc)(PProtocolData P);

typedef void __fastcall (*TProtocolFunc)(unsigned Msg, unsigned wParam, int lParam);

typedef void __fastcall (*PrepFinishProc)(PProtocolData P);

typedef System::LongBool __fastcall (*ReadProtProc)(PProtocolData P, TDataBlock &Block, unsigned &BlockSize);

typedef System::LongBool __fastcall (*WriteProtProc)(PProtocolData P, TDataBlock &Block, unsigned BlockSize);

typedef void __fastcall (*CancelFunc)(PProtocolData P);

typedef void __fastcall (*ShowStatusProc)(PProtocolData P, unsigned Options);

typedef System::LongBool __fastcall (*NextFileFunc)(PProtocolData P, char * FName);

typedef void __fastcall (*LogFileProc)(PProtocolData P, unsigned LogFileStatus);

typedef System::LongBool __fastcall (*AcceptFileFunc)(PProtocolData P, char * FName);

struct DECLSPEC_DRECORD TKermitOptions
{
public:
	System::Byte MaxPacketLen;
	System::Byte MaxTimeout;
	System::Byte PadCount;
	char PadChar;
	char Terminator;
	char CtlPrefix;
	char HibitPrefix;
	char Check;
	char RepeatPrefix;
	System::Byte CapabilitiesMask;
	System::Byte WindowSize;
	unsigned MaxLongPacketLen;
	unsigned SendInitSize;
};


struct DECLSPEC_DRECORD TProtocolData
{
public:
	int aStatusTrigger;
	int aTimeoutTrigger;
	int aOutBuffFreeTrigger;
	int aOutBuffUsedTrigger;
	int aNoCarrierTrigger;
	HWND aHWindow;
	Adport::TApdCustomComPort* aHC;
	System::LongBool aBatchProtocol;
	System::LongBool aFilesSent;
	System::LongBool aAbortFlag;
	System::LongBool aTimerStarted;
	int aCurProtocol;
	unsigned aCheckType;
	unsigned aHandshakeRetry;
	unsigned aHandshakeWait;
	unsigned aHandshakeAttempt;
	unsigned aBlockLen;
	unsigned aBlockNum;
	unsigned aFlags;
	unsigned aTransTimeout;
	unsigned aFinishWait;
	unsigned aRcvTimeout;
	unsigned aProtocolStatus;
	unsigned aLastBlockSize;
	int aProtocolError;
	int aSrcFileLen;
	int aSrcFileDate;
	unsigned aBlockCheck;
	int aInitFilePos;
	Oomisc::EventTimer aReplyTimer;
	TDataBlock *aDataBlock;
	TProtocolFunc aCurProtFunc;
	_RTL_CRITICAL_SECTION aProtSection;
	System::LongBool aForceStatus;
	System::LongBool aTimerPending;
	unsigned aInProgress;
	unsigned aBlockErrors;
	unsigned aTotalErrors;
	unsigned aActCPS;
	unsigned aOverhead;
	unsigned aTurnDelay;
	unsigned aStatusInterval;
	unsigned aSaveStatus;
	int aSaveError;
	int aBytesRemaining;
	int aBytesTransferred;
	int aElapsedTicks;
	Oomisc::EventTimer aStatusTimer;
	Oomisc::EventTimer aTimer;
	System::LongBool aEndPending;
	System::LongBool aFileOpen;
	System::LongBool aNoMoreData;
	System::LongBool aLastBlock;
	unsigned aBlkIndex;
	int aWriteFailOpt;
	int aStartOfs;
	int aEndOfs;
	int aLastOfs;
	int aFileOfs;
	int aEndOfDataOfs;
	TFileBuffer *aFileBuffer;
	unsigned aSaveMode;
	System::LongBool aUpcaseFileNames;
	System::LongBool aFindingFirst;
	unsigned aFileListIndex;
	Oomisc::TPathCharArrayA aPathName;
	Oomisc::TPathCharArrayA aSearchMask;
	Oomisc::TFileList *aFileList;
	System::Sysutils::TSearchRec aCurRec;
	bool aFFOpen;
	System::Byte aJunk;
	ShowStatusProc apShowStatus;
	LogFileProc apLogFile;
	NextFileFunc apNextFile;
	AcceptFileFunc apAcceptFile;
	PrepFinishProc apPrepareReading;
	ReadProtProc apReadProtocolBlock;
	PrepFinishProc apFinishReading;
	PrepFinishProc apPrepareWriting;
	WriteProtProc apWriteProtocolBlock;
	PrepFinishProc apFinishWriting;
	System::file aWorkFile;
	Oomisc::TDirCharArray aDestDir;
	
public:
	union
	{
		struct 
		{
			System::LongBool sCtrlZEncountered;
			unsigned sInterCharDelay;
			unsigned sInterLineDelay;
			unsigned sInterCharTicks;
			unsigned sInterLineTicks;
			unsigned sMaxAccumDelay;
			unsigned sSendIndex;
			unsigned sCRTransMode;
			unsigned sLFTransMode;
			char sEOLChar;
			TAsciiState sAsciiState;
		};
		struct 
		{
			char bSaveC;
			char bLastType;
			System::LongBool bQSP;
			System::LongBool bQuoted;
			System::LongBool bResumeFlag;
			System::LongBool bAborting;
			System::LongBool bBPlusMode;
			System::LongBool bQuotePending;
			System::LongBool bSentENQ;
			System::LongBool bNAKSent;
			System::LongBool bFailed;
			unsigned bChecksum;
			unsigned bTimerIndex;
			unsigned bNewChk;
			unsigned bCurTimer;
			int bAbortCount;
			int bNextSeq;
			int bPacketNum;
			int bIdx;
			int bRSize;
			int bSeqNum;
			int bNext2ACK;
			int bNext2Fill;
			int bSAMax;
			int bSAWaiting;
			int bSAErrors;
			int bRPackets;
			TBPDataBlock *bRBuffer;
			TSPackets bSBuffer;
			TQuoteTable bQuoteTable;
			ParamsRecord bHostParams;
			ParamsRecord bOurParams;
			TDirection bDirection;
			TBPlusState bBPlusState;
			TTermPacketState bTermState;
			TPacketState bPacketState;
			TAckCollectionState bAckState;
		};
		struct 
		{
			char kPacketType;
			TKermitState kKermitState;
			TKermitHeaderState kKermitHeaderState;
			TKermitDataState kKermitDataState;
			System::LongBool kCheckKnown;
			System::LongBool kLPInUse;
			System::LongBool kUsingHibit;
			System::LongBool kUsingRepeat;
			System::LongBool kReceiveInProgress;
			System::LongBool kTransmitInProgress;
			unsigned kDataLen;
			unsigned kRecDataLen;
			unsigned kActualDataLen;
			unsigned kMinRepeatCnt;
			unsigned kRecBlockNum;
			unsigned kExpectedAck;
			unsigned kBlockCheck2;
			unsigned kSWCTurnDelay;
			TKermitOptions kKermitOptions;
			TKermitOptions kRmtKermitOptions;
			TInBuffer *kInBuff;
			unsigned kInBuffHead;
			unsigned kInBuffTail;
			System::LongBool kWorkEndPending;
			unsigned kWorkLen;
			unsigned kLastWorkIndex;
			TDataBlock *kWorkBlock;
			unsigned kTableSize;
			unsigned kTableHead;
			unsigned kTableTail;
			unsigned kBlockIndex;
			int kNext2Send;
			TDataTable *kDataTable;
			TInfoTable kInfoTable;
			char kTempCheck;
			char kC1;
			char kC2;
			char kC3;
			System::LongBool kSkipped;
			System::LongBool kGetLong;
			int kLongCheck;
			unsigned kSaveCheck2;
			int kSaveCheck;
		};
		struct 
		{
			char zLastFrame;
			char zTerminator;
			char zHeaderType;
			TZmodemState zZmodemState;
			THeaderState zHeaderState;
			HexHeaderStates zHexHdrState;
			BinaryHeaderStates zBinHdrState;
			ReceiveBlockStates zRcvBlockState;
			bool zFileMgmtOverride;
			bool zReceiverRecover;
			bool zUseCrc32;
			bool zCanCrc32;
			bool zHexPending;
			bool zEscapePending;
			bool zEscapeAll;
			bool zControlCharSkip;
			bool zWasHex;
			unsigned zDiscardCnt;
			unsigned zConvertOpts;
			unsigned zFileMgmtOpts;
			unsigned zTransportOpts;
			unsigned zFinishRetry;
			unsigned zWorkSize;
			unsigned zCanCount;
			unsigned zHexChar;
			unsigned zCrcCnt;
			unsigned zOCnt;
			int zLastFileOfs;
			System::StaticArray<System::Byte, 32> zAttentionStr;
			bool zEscapeControl;
			bool zUse8KBlocks;
			System::LongBool zTookHit;
			unsigned zGoodAfterBad;
			unsigned zDataBlockLen;
			int zDataInTransit;
			TWorkBlock *zWorkBlock;
			char zRcvFrame;
			TPosFlags zRcvHeader;
			unsigned zRcvBuffLen;
			char zLastChar;
			TPosFlags zTransHeader;
			int zZRQINITValue;
		};
		struct 
		{
			System::LongBool xCRCMode;
			System::LongBool x1KMode;
			System::LongBool xGMode;
			unsigned xMaxBlockErrors;
			unsigned xBlockWait;
			unsigned xEotCheckCount;
			char xStartChar;
			char xHandshake;
			unsigned xNaksReceived;
			unsigned xEotCounter;
			unsigned xCanCounter;
			unsigned xOverheadLen;
			TXmodemState xXmodemState;
			System::Byte xJunk;
			int ySaveLen;
			int yNewDT;
			Oomisc::TPathCharArrayA ySaveName;
			TDataBlock *yFileHeader;
			System::LongBool y128BlockMode;
			TYmodemState yYmodemState;
		};
		
	};
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word FileBufferSize = System::Word(0x2000);
static const System::Byte awpDefHandshakeWait = System::Byte(0xb6);
static const System::Int8 awpDefHandshakeRetry = System::Int8(0xa);
static const System::Word awpDefTransTimeout = System::Word(0x444);
static const System::Word apMaxBlockSize = System::Word(0x400);
extern DELPHI_PACKAGE char BlockFillChar;
static const System::Int8 TelixDelay = System::Int8(0x9);
static const System::Int8 MaxWindowSlots = System::Int8(0x1b);
static const System::Word BPTimeoutMax = System::Word(0x222);
static const System::Int8 BPErrorMax = System::Int8(0xa);
static const System::Word BPBufferMax = System::Word(0x800);
static const System::Int8 BPSendAheadMax = System::Int8(0x2);
static const System::Word BPDefFinishWait = System::Word(0x111);
extern DELPHI_PACKAGE System::SmallString<31> ESCIResponse;
}	/* namespace Awtpcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_AWTPCL)
using namespace Awtpcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AwtpclHPP
