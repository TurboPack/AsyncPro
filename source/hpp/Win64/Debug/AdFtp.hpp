// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdFtp.pas' rev: 32.00 (Windows)

#ifndef AdftpHPP
#define AdftpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Forms.hpp>
#include <OoMisc.hpp>
#include <AwUser.hpp>
#include <AdSocket.hpp>
#include <AdWUtil.hpp>
#include <AdWnPort.hpp>
#include <AdPort.hpp>
#include <AdPacket.hpp>
#include <AdExcept.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adftp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TApdCustomFtpClient;
class DELPHICLASS TApdFtpLog;
class DELPHICLASS TApdFtpClient;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TFtpRetrieveMode : unsigned char { rmAppend, rmReplace, rmRestart };

enum DECLSPEC_DENUM TFtpStoreMode : unsigned char { smAppend, smReplace, smUnique, smRestart };

enum DECLSPEC_DENUM TFtpFileType : unsigned char { ftAscii, ftBinary };

enum DECLSPEC_DENUM TFtpProcessState : unsigned char { psClosed, psLogin, psIdle, psDir, psGet, psPut, psRen, psCmd, psMkDir };

enum DECLSPEC_DENUM TFtpStatusCode : unsigned char { scClose, scOpen, scLogout, scLogin, scComplete, scCurrentDir, scDataAvail, scProgress, scTransferOK, scTimeout };

enum DECLSPEC_DENUM TFtpLogCode : unsigned char { lcClose, lcOpen, lcLogout, lcLogin, lcDelete, lcRename, lcReceive, lcStore, lcComplete, lcRestart, lcTimeout, lcUserAbort };

typedef void __fastcall (__closure *TFtpErrorEvent)(System::TObject* Sender, int ErrorCode, char * ErrorText);

typedef void __fastcall (__closure *TFtpLogEvent)(System::TObject* Sender, TFtpLogCode LogCode);

typedef void __fastcall (__closure *TFtpReplyEvent)(System::TObject* Sender, int ReplyCode, char * ReplyText);

typedef void __fastcall (__closure *TFtpStatusEvent)(System::TObject* Sender, TFtpStatusCode StatusCode, char * InfoText);

class PASCALIMPLEMENTATION TApdCustomFtpClient : public Adwnport::TApdCustomWinsockPort
{
	typedef Adwnport::TApdCustomWinsockPort inherited;
	
	
private:
	typedef System::StaticArray<System::AnsiString, 32> _TApdCustomFtpClient__1;
	
	
protected:
	bool AbortXfer;
	_TApdCustomFtpClient__1 CmdStack;
	System::Byte CmdsStacked;
	Adwutil::TSockAddrIn DataName;
	int DataSocket;
	HWND hwndFtpEvent;
	Adpacket::TApdDataPacket* ReplyPacket;
	System::StaticArray<System::Byte, 32769> DataBuffer;
	System::StaticArray<char, 32769> ReplyBuffer;
	int ListenSocket;
	Adwutil::TSockAddrIn ListenName;
	System::Classes::TFileStream* LocalStream;
	bool MultiLine;
	System::AnsiString MultiLineTerm;
	bool NoEvents;
	TFtpProcessState ProcessState;
	Adsocket::TApdSocket* Sock;
	int Timer;
	System::AnsiString FAccount;
	int FBytesTransferred;
	int FConnectTimeout;
	int FFileLength;
	TFtpFileType FFileType;
	TApdFtpLog* FFtpLog;
	System::AnsiString FLocalFile;
	System::AnsiString FPassword;
	bool FPassiveMode;
	int FTransferTimeout;
	System::AnsiString FRemoteFile;
	int FRestartAt;
	int FReplyCode;
	bool FUserLoggedIn;
	System::AnsiString FUserName;
	TFtpErrorEvent FOnFtpError;
	TFtpStatusEvent FOnFtpStatus;
	System::Classes::TNotifyEvent FOnFtpConnected;
	System::Classes::TNotifyEvent FOnFtpDisconnected;
	TFtpLogEvent FOnFtpLog;
	TFtpReplyEvent FOnFtpReply;
	void __fastcall ChangeState(TFtpProcessState NewState);
	bool __fastcall DataConnect(void);
	void __fastcall DataConnectPASV(System::AnsiString IP);
	void __fastcall DataDisconnect(bool FlushBuffer);
	void __fastcall DataShutDown(void);
	virtual void __fastcall DoConnect(void);
	virtual void __fastcall DoDisconnect(void);
	void __fastcall FtpEventHandler(Winapi::Messages::TMessage &Msg);
	void __fastcall FtpReplyHandler(int ReplyCode, char * PData);
	bool __fastcall GetConnected(void);
	int __fastcall GetData(void);
	bool __fastcall GetInProgress(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	System::AnsiString __fastcall PopCommand(void);
	void __fastcall PostError(int Code, char * Info);
	void __fastcall PostLog(TFtpLogCode Code);
	void __fastcall PostStatus(TFtpStatusCode Code, char * Info);
	void __fastcall PushCommand(const System::AnsiString Cmd);
	int __fastcall PutData(void);
	void __fastcall ReplyPacketHandler(System::TObject* Sender, System::AnsiString Data);
	void __fastcall ResetTimer(void);
	void __fastcall SendCommand(const System::AnsiString Cmd);
	void __fastcall SetFtpLog(TApdFtpLog* const NewLog);
	void __fastcall StartTimer(void);
	void __fastcall StopTimer(void);
	void __fastcall TimerTrigger(unsigned Msg, unsigned wParam, int lParam);
	void __fastcall WsDataAccept(System::TObject* Sender, int Socket);
	void __fastcall WsDataDisconnect(System::TObject* Sender, int Socket);
	void __fastcall WsDataError(System::TObject* Sender, int Socket, int ErrorCode);
	void __fastcall WsDataRead(System::TObject* Sender, int Socket);
	void __fastcall WsDataWrite(System::TObject* Sender, int Socket);
	__property System::AnsiString Account = {read=FAccount, write=FAccount};
	__property int ConnectTimeout = {read=FConnectTimeout, write=FConnectTimeout, nodefault};
	__property TFtpFileType FileType = {read=FFileType, write=FFileType, nodefault};
	__property TApdFtpLog* FtpLog = {read=FFtpLog, write=SetFtpLog};
	__property System::AnsiString Password = {read=FPassword, write=FPassword};
	__property bool PassiveMode = {read=FPassiveMode, write=FPassiveMode, nodefault};
	__property System::UnicodeString ServerAddress = {read=FWsAddress, write=SetWsAddress};
	__property int TransferTimeout = {read=FTransferTimeout, write=FTransferTimeout, nodefault};
	__property System::AnsiString UserName = {read=FUserName, write=FUserName};
	__property TFtpErrorEvent OnFtpError = {read=FOnFtpError, write=FOnFtpError};
	__property TFtpLogEvent OnFtpLog = {read=FOnFtpLog, write=FOnFtpLog};
	__property TFtpReplyEvent OnFtpReply = {read=FOnFtpReply, write=FOnFtpReply};
	__property TFtpStatusEvent OnFtpStatus = {read=FOnFtpStatus, write=FOnFtpStatus};
	
public:
	__property int BytesTransferred = {read=FBytesTransferred, nodefault};
	__property bool Connected = {read=GetConnected, nodefault};
	__property bool InProgress = {read=GetInProgress, nodefault};
	__property int FileLength = {read=FFileLength, nodefault};
	__property int ReplyCode = {read=FReplyCode, nodefault};
	__property int RestartAt = {read=FRestartAt, write=FRestartAt, nodefault};
	__property bool UserLoggedIn = {read=FUserLoggedIn, nodefault};
	__fastcall virtual TApdCustomFtpClient(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomFtpClient(void);
	bool __fastcall Abort(void);
	bool __fastcall ChangeDir(const System::AnsiString RemotePathName);
	bool __fastcall CurrentDir(void);
	bool __fastcall Delete(const System::AnsiString RemotePathName);
	bool __fastcall ListDir(const System::AnsiString RemotePathName, bool FullList);
	bool __fastcall Help(const System::AnsiString Command);
	bool __fastcall Login(void);
	bool __fastcall Logout(void);
	bool __fastcall MakeDir(const System::AnsiString RemotePathName);
	bool __fastcall RemoveDir(const System::AnsiString RemotePathName);
	bool __fastcall Rename(const System::AnsiString RemotePathName, const System::AnsiString NewPathName);
	bool __fastcall Retrieve(const System::AnsiString RemotePathName, const System::AnsiString LocalPathName, TFtpRetrieveMode RetrieveMode);
	bool __fastcall SendFtpCommand(const System::AnsiString FtpCmd);
	bool __fastcall Status(const System::AnsiString RemotePathName);
	bool __fastcall Store(const System::AnsiString RemotePathName, const System::AnsiString LocalPathName, TFtpStoreMode StoreMode);
};


class PASCALIMPLEMENTATION TApdFtpLog : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	bool FEnabled;
	System::AnsiString FFtpHistoryName;
	TApdCustomFtpClient* FFtpClient;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TApdFtpLog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdFtpLog(void);
	virtual void __fastcall UpdateLog(const TFtpLogCode LogCode);
	
__published:
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
	__property System::AnsiString FtpHistoryName = {read=FFtpHistoryName, write=FFtpHistoryName};
	__property TApdCustomFtpClient* FtpClient = {read=FFtpClient, write=FFtpClient};
};


class PASCALIMPLEMENTATION TApdFtpClient : public TApdCustomFtpClient
{
	typedef TApdCustomFtpClient inherited;
	
__published:
	__property Account = {default=0};
	__property ConnectTimeout;
	__property FileType;
	__property FtpLog;
	__property Password = {default=0};
	__property PassiveMode;
	__property ServerAddress = {default=0};
	__property TransferTimeout;
	__property UserName = {default=0};
	__property OnFtpError;
	__property OnFtpLog;
	__property OnFtpReply;
	__property OnFtpStatus;
	__property Logging = {default=0};
	__property LogSize = {default=10000};
	__property LogName = {default=0};
	__property LogHex = {default=1};
	__property Tracing = {default=0};
	__property TraceSize = {default=10000};
	__property TraceName = {default=0};
	__property TraceHex = {default=1};
	__property WsPort = {default=0};
	__property OnWsError;
public:
	/* TApdCustomFtpClient.Create */ inline __fastcall virtual TApdFtpClient(System::Classes::TComponent* AOwner) : TApdCustomFtpClient(AOwner) { }
	/* TApdCustomFtpClient.Destroy */ inline __fastcall virtual ~TApdFtpClient(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word MaxBuffer = System::Word(0x8000);
static const System::Int8 MaxCmdStack = System::Int8(0x20);
}	/* namespace Adftp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADFTP)
using namespace Adftp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdftpHPP
