// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdWUtil.pas' rev: 32.00 (Windows)

#ifndef AdwutilHPP
#define AdwutilHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <OoMisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adwutil
{
//-- forward type declarations -----------------------------------------------
struct TFDSet;
struct TTimeVal;
struct THostEnt;
struct TNetEnt;
struct TServEnt;
struct TProtoEnt;
struct TSockAddrIn;
struct TwsaData;
struct TTransmitFileBuffers;
struct TSockProto;
struct TLinger;
struct TWsDataRec;
struct TSocketFuncs;
//-- type declarations -------------------------------------------------------
typedef int TSocket;

typedef TFDSet *PFDSet;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TFDSet
{
public:
	int fd_count;
	System::StaticArray<int, 64> fd_array;
};
#pragma pack(pop)


typedef TTimeVal *PTimeVal;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TTimeVal
{
public:
	int tv_sec;
	int tv_usec;
};
#pragma pack(pop)


typedef System::StaticArray<Oomisc::PInAddr, 256> TAddrArray;

typedef TAddrArray *PAddrArray;

typedef System::StaticArray<char *, 256> TAliasArray;

typedef TAliasArray *PAliasArray;

typedef THostEnt *PHostEnt;

struct DECLSPEC_DRECORD THostEnt
{
public:
	char *h_name;
	TAliasArray *h_aliases;
	short h_addrtype;
	short h_length;
	TAddrArray *h_addr_list;
};


typedef TNetEnt *PNetEnt;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TNetEnt
{
public:
	char *n_name;
	char * *n_aliases;
	short n_addrtype;
	int n_net;
};
#pragma pack(pop)


typedef TServEnt *PServEnt;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TServEnt
{
public:
	char *s_name;
	char * *s_aliases;
	short s_port;
	char *s_proto;
};
#pragma pack(pop)


typedef TProtoEnt *PProtoEnt;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TProtoEnt
{
public:
	char *p_name;
	char * *p_aliases;
	short p_proto;
};
#pragma pack(pop)


typedef TSockAddrIn *PSockAddrIn;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TSockAddrIn
{
	
public:
	union
	{
		struct 
		{
			System::Word sa_family;
			System::StaticArray<char, 14> sa_data;
		};
		struct 
		{
			System::Word sin_family;
			System::Word sin_port;
			Oomisc::TInAddr sin_addr;
			System::StaticArray<char, 8> sin_zero;
		};
		
	};
};
#pragma pack(pop)


typedef TwsaData *PwsaData;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TwsaData
{
public:
	System::Word wVersion;
	System::Word wHighVersion;
	System::StaticArray<char, 257> szDescription;
	System::StaticArray<char, 129> szSystemStatus;
	System::Word iMaxSockets;
	System::Word iMaxUdpDg;
	char *lpVendorInfo;
};
#pragma pack(pop)


typedef TTransmitFileBuffers *PTransmitFileBuffers;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TTransmitFileBuffers
{
public:
	void *Head;
	unsigned HeadLength;
	void *Tail;
	unsigned TailLength;
};
#pragma pack(pop)


typedef TSockAddrIn *PSockAddr;

typedef TSockAddrIn TSockAddr;

typedef TSockProto *PSockProto;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TSockProto
{
public:
	System::Word sp_family;
	System::Word sp_protocol;
};
#pragma pack(pop)


typedef TLinger *PLinger;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TLinger
{
public:
	System::Word l_onoff;
	System::Word l_linger;
};
#pragma pack(pop)


typedef TWsDataRec *PWsDataRec;

struct DECLSPEC_DRECORD TWsDataRec
{
public:
	TSockAddrIn WsSockAddr;
	TSockAddrIn WsHostAddr;
	bool WsIsClient;
	bool WsIsTelnet;
};


typedef int __stdcall (*TfnAccept)(int S, TSockAddrIn &Addr, int &Addrlen);

typedef int __stdcall (*TfnBind)(int S, TSockAddrIn &Addr, int NameLen);

typedef int __stdcall (*TfnCloseSocket)(int S);

typedef int __stdcall (*TfnConnect)(int S, TSockAddrIn &Name, int NameLen);

typedef int __stdcall (*TfnIOCtlSocket)(int S, int Cmd, int &Arg);

typedef int __stdcall (*TfnGetPeerName)(int S, TSockAddrIn &Name, int &NameLen);

typedef int __stdcall (*TfnGetSockName)(int S, TSockAddrIn &Name, int &NameLen);

typedef int __stdcall (*TfnGetSockOpt)(int S, int Level, int OptName, void *OptVal, int &OptLen);

typedef int __stdcall (*Tfnhtonl)(int HostLong);

typedef System::Word __stdcall (*Tfnhtons)(System::Word HostShort);

typedef int __stdcall (*TfnINet_Addr)(char * Cp);

typedef char * __stdcall (*TfnINet_NtoA)(Oomisc::TInAddr InAddr);

typedef int __stdcall (*TfnListen)(int S, int Backlog);

typedef int __stdcall (*Tfnntohl)(int NetLong);

typedef System::Word __stdcall (*Tfnntohs)(System::Word NetShort);

typedef int __stdcall (*TfnRecv)(int S, void *Buf, int Len, int Flags);

typedef int __stdcall (*TfnRecvFrom)(int S, void *Buf, int Len, int Flags, TSockAddrIn &From, int &FromLen);

typedef int __stdcall (*TfnSelect)(int Nfds, PFDSet Readfds, PFDSet Writefds, PFDSet Exceptfds, PTimeVal Timeout);

typedef int __stdcall (*TfnSend)(int S, void *Buf, int Len, int Flags);

typedef int __stdcall (*TfnSendTo)(int S, void *Buf, int Len, int Flags, TSockAddrIn &AddrTo, int ToLen);

typedef int __stdcall (*TfnSetSockOpt)(int S, int Level, int OptName, void *OptVal, int OptLen);

typedef int __stdcall (*TfnShutdown)(int S, int How);

typedef int __stdcall (*TfnSocket)(int Af, int Struct, int Protocol);

typedef PHostEnt __stdcall (*TfnGetHostByAddr)(void *Addr, int Len, int Struct);

typedef PHostEnt __stdcall (*TfnGetHostByName)(char * Name);

typedef int __stdcall (*TfnGetHostName)(char * Name, int Len);

typedef PServEnt __stdcall (*TfnGetServByPort)(System::Word Port, char * Proto);

typedef PServEnt __stdcall (*TfnGetServByName)(char * Name, char * Proto);

typedef PProtoEnt __stdcall (*TfnGetProtoByNumber)(int Proto);

typedef PProtoEnt __stdcall (*TfnGetProtoByName)(char * Name);

typedef int __stdcall (*TfnwsaStartup)(System::Word wVersionRequired, TwsaData &WSData);

typedef int __stdcall (*TfnwsaCleanup)(void);

typedef void __stdcall (*TfnwsaSetLastError)(int iError);

typedef int __stdcall (*TfnwsaGetLastError)(void);

typedef System::LongBool __stdcall (*TfnwsaIsBlocking)(void);

typedef int __stdcall (*TfnwsaUnhookBlockingHook)(void);

typedef void * __stdcall (*TfnwsaSetBlockingHook)(void * lpBlockFunc);

typedef int __stdcall (*TfnwsaCancelBlockingCall)(void);

typedef NativeUInt __stdcall (*TfnwsaAsyncGetServByName)(HWND HWindow, int wMsg, char * Name, char * Proto, char * Buf, int BufLen);

typedef NativeUInt __stdcall (*TfnwsaAsyncGetServByPort)(HWND HWindow, int wMsg, int Port, char * Proto, char * Buf, int BufLen);

typedef NativeUInt __stdcall (*TfnwsaAsyncGetProtoByName)(HWND HWindow, int wMsg, char * Name, char * Buf, int BufLen);

typedef NativeUInt __stdcall (*TfnwsaAsyncGetProtoByNumber)(HWND HWindow, int wMsg, int Number, char * Buf, int BufLen);

typedef NativeUInt __stdcall (*TfnwsaAsyncGetHostByName)(HWND HWindow, int wMsg, char * Name, char * Buf, int BufLen);

typedef NativeUInt __stdcall (*TfnwsaAsyncGetHostByAddr)(HWND HWindow, int wMsg, char * Addr, int Len, int Struct, char * Buf, int BufLen);

typedef int __stdcall (*TfnwsaCancelAsyncRequest)(NativeUInt hAsyncTaskHandle);

typedef int __stdcall (*TfnwsaAsyncSelect)(int S, HWND HWindow, int wMsg, int lEvent);

typedef int __stdcall (*TfnwsaRecvEx)(int S, void *Buf, int Len, int &Flags);

typedef System::LongBool __stdcall (*TfnTransmitFile)(int hSocket, NativeUInt hFile, unsigned nNumberOfBytesToWrite, unsigned nNumberOfBytesPerSend, Winapi::Windows::POverlapped lpOverlapped, PTransmitFileBuffers lpTransmitBuffers, unsigned dwReserved);

typedef TSocketFuncs *PSocketFuncs;

struct DECLSPEC_DRECORD TSocketFuncs
{
public:
	TfnAccept Accept;
	TfnBind Bind;
	TfnCloseSocket CloseSocket;
	TfnConnect Connect;
	TfnIOCtlSocket IOCtlSocket;
	TfnGetPeerName GetPeerName;
	TfnGetSockName GetSockName;
	TfnGetSockOpt GetSockOpt;
	Tfnhtonl htonl;
	Tfnhtons htons;
	TfnINet_Addr INet_Addr;
	TfnINet_NtoA INet_Ntoa;
	TfnListen Listen;
	Tfnntohl ntohl;
	Tfnntohs ntohs;
	TfnRecv Recv;
	TfnRecvFrom RecvFrom;
	TfnSelect Select;
	TfnSend Send;
	TfnSendTo SendTo;
	TfnSetSockOpt SetSockOpt;
	TfnShutdown Shutdown;
	TfnSocket Socket;
	TfnGetHostByAddr GetHostByAddr;
	TfnGetHostByName GetHostByName;
	TfnGetHostName GetHostName;
	TfnGetServByPort GetServByPort;
	TfnGetServByName GetServByName;
	TfnGetProtoByNumber GetProtoByNumber;
	TfnGetProtoByName GetProtoByName;
	TfnwsaStartup wsaStartup;
	TfnwsaCleanup wsaCleanup;
	TfnwsaSetLastError wsaSetLastError;
	TfnwsaGetLastError wsaGetLastError;
	TfnwsaIsBlocking wsaIsBlocking;
	TfnwsaUnhookBlockingHook wsaUnhookBlockingHook;
	TfnwsaSetBlockingHook wsaSetBlockingHook;
	TfnwsaCancelBlockingCall wsaCancelBlockingCall;
	TfnwsaAsyncGetServByName wsaAsyncGetServByName;
	TfnwsaAsyncGetServByPort wsaAsyncGetServByPort;
	TfnwsaAsyncGetProtoByName wsaAsyncGetProtoByName;
	TfnwsaAsyncGetProtoByNumber wsaAsyncGetProtoByNumber;
	TfnwsaAsyncGetHostByName wsaAsyncGetHostByName;
	TfnwsaAsyncGetHostByAddr wsaAsyncGetHostByAddr;
	TfnwsaCancelAsyncRequest wsaCancelAsyncRequest;
	TfnwsaAsyncSelect wsaAsyncSelect;
	TfnwsaRecvEx wsaRecvEx;
	TfnTransmitFile TransmitFile;
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word Sock_Version = System::Word(0x101);
static const System::Int8 Fd_Setsize = System::Int8(0x40);
static const System::Int8 IocParm_Mask = System::Int8(0x7f);
static const int Ioc_Void = int(0x20000000);
static const int Ioc_Out = int(0x40000000);
static const unsigned Ioc_In = unsigned(0x80000000);
static const unsigned Ioc_InOut = unsigned(0xc0000000);
static const System::Int8 IpProto_Ip = System::Int8(0x0);
static const System::Int8 IpProto_Icmp = System::Int8(0x1);
static const System::Int8 IpProto_Igmp = System::Int8(0x2);
static const System::Int8 IpProto_Ggp = System::Int8(0x3);
static const System::Int8 IpProto_Tcp = System::Int8(0x6);
static const System::Int8 IpProto_Pup = System::Int8(0xc);
static const System::Int8 IpProto_Udp = System::Int8(0x11);
static const System::Int8 IpProto_Idp = System::Int8(0x16);
static const System::Int8 IpProto_Nd = System::Int8(0x4d);
static const System::Byte IpProto_Raw = System::Byte(0xff);
static const System::Word IpProto_Max = System::Word(0x100);
static const System::Int8 IpPort_Echo = System::Int8(0x7);
static const System::Int8 IpPort_Discard = System::Int8(0x9);
static const System::Int8 IpPort_SyStat = System::Int8(0xb);
static const System::Int8 IpPort_Daytime = System::Int8(0xd);
static const System::Int8 IpPort_NetStat = System::Int8(0xf);
static const System::Int8 IpPort_Ftp = System::Int8(0x15);
static const System::Int8 IpPort_Telnet = System::Int8(0x17);
static const System::Int8 IpPort_Smtp = System::Int8(0x19);
static const System::Int8 IpPort_TimeServer = System::Int8(0x25);
static const System::Int8 IpPort_NameServer = System::Int8(0x2a);
static const System::Int8 IpPort_WhoIs = System::Int8(0x2b);
static const System::Int8 IpPort_Mtp = System::Int8(0x39);
static const System::Int8 IpPort_Tftp = System::Int8(0x45);
static const System::Int8 IpPort_Rje = System::Int8(0x4d);
static const System::Int8 IpPort_Finger = System::Int8(0x4f);
static const System::Int8 IpPort_TtyLink = System::Int8(0x57);
static const System::Int8 IpPort_SupDup = System::Int8(0x5f);
static const System::Word IpPort_ExecServer = System::Word(0x200);
static const System::Word IpPort_LoginServer = System::Word(0x201);
static const System::Word IpPort_CmdServer = System::Word(0x202);
static const System::Word IpPort_EfsServer = System::Word(0x208);
static const System::Word IpPort_BiffUdp = System::Word(0x200);
static const System::Word IpPort_WhoServer = System::Word(0x201);
static const System::Word IpPort_RouteServer = System::Word(0x208);
static const System::Word IpPort_Reserved = System::Word(0x400);
static const System::Byte ImpLink_Ip = System::Byte(0x9b);
static const System::Byte ImpLink_LowExper = System::Byte(0x9c);
static const System::Byte ImpLink_HighExper = System::Byte(0x9e);
static const int FiOnRead = int(0x4004667f);
static const unsigned FiOnBio = unsigned(0x8004667e);
static const unsigned FioAsync = unsigned(0x8004667d);
static const System::Int8 InAddr_Any = System::Int8(0x0);
static const int InAddr_LoopBack = int(0x7f000001);
static const unsigned InAddr_BroadCast = unsigned(0xffffffff);
static const unsigned InAddr_None = unsigned(0xffffffff);
static const System::Word wsaDescription_Len = System::Word(0x100);
static const System::Byte wsaSys_Status_Len = System::Byte(0x80);
static const System::Int8 Ip_Options = System::Int8(0x1);
static const System::Int8 Ip_Multicast_If = System::Int8(0x2);
static const System::Int8 Ip_Multicast_Ttl = System::Int8(0x3);
static const System::Int8 Ip_Multicast_Loop = System::Int8(0x4);
static const System::Int8 Ip_Add_Membership = System::Int8(0x5);
static const System::Int8 Ip_Drop_Membership = System::Int8(0x6);
static const System::Int8 Ip_Default_Multicast_Ttl = System::Int8(0x1);
static const System::Int8 Ip_Default_Multicast_Loop = System::Int8(0x1);
static const System::Int8 Ip_Max_Memberships = System::Int8(0x14);
static const int Invalid_Socket = int(-1);
static const System::Int8 Socket_Error = System::Int8(-1);
static const System::Int8 Sock_Stream = System::Int8(0x1);
static const System::Int8 Sock_DGram = System::Int8(0x2);
static const System::Int8 Sock_Raw = System::Int8(0x3);
static const System::Int8 Sock_Rdm = System::Int8(0x4);
static const System::Int8 Sock_SeqPacket = System::Int8(0x5);
static const System::Int8 So_Debug = System::Int8(0x1);
static const System::Int8 So_AcceptConn = System::Int8(0x2);
static const System::Int8 So_ReuseAddr = System::Int8(0x4);
static const System::Int8 So_KeepAlive = System::Int8(0x8);
static const System::Int8 So_DontRoute = System::Int8(0x10);
static const System::Int8 So_Broadcast = System::Int8(0x20);
static const System::Int8 So_UseLoopback = System::Int8(0x40);
static const System::Byte So_Linger = System::Byte(0x80);
static const System::Word So_OobInline = System::Word(0x100);
static const System::Word So_DontLinger = System::Word(0xff7f);
static const System::Int8 SD_Receive = System::Int8(0x0);
static const System::Int8 SD_Send = System::Int8(0x1);
static const System::Int8 SD_Both = System::Int8(0x2);
static const System::Word So_SndBuf = System::Word(0x1001);
static const System::Word So_RcvBuf = System::Word(0x1002);
static const System::Word So_SndLoWat = System::Word(0x1003);
static const System::Word So_RcvLoWat = System::Word(0x1004);
static const System::Word So_SndTimeO = System::Word(0x1005);
static const System::Word So_RcvTimeO = System::Word(0x1006);
static const System::Word So_Error = System::Word(0x1007);
static const System::Word So_Type = System::Word(0x1008);
static const System::Word So_ConnData = System::Word(0x7000);
static const System::Word So_ConnOpt = System::Word(0x7001);
static const System::Word So_DISCData = System::Word(0x7002);
static const System::Word So_DISCOpt = System::Word(0x7003);
static const System::Word So_ConnDataLen = System::Word(0x7004);
static const System::Word So_ConnOptLen = System::Word(0x7005);
static const System::Word So_DISCDataLen = System::Word(0x7006);
static const System::Word So_DISCOptLen = System::Word(0x7007);
static const System::Word So_OpenType = System::Word(0x7008);
static const System::Int8 So_Synchronous_Alert = System::Int8(0x10);
static const System::Int8 So_Synchronous_NonAlert = System::Int8(0x20);
static const System::Word So_MaxDG = System::Word(0x7009);
static const System::Word So_MaxPathDG = System::Word(0x700a);
static const System::Int8 Tcp_NoDelay = System::Int8(0x1);
static const System::Word Tcp_BsdUrgent = System::Word(0x7000);
static const System::Int8 Af_Unspec = System::Int8(0x0);
static const System::Int8 Af_Unix = System::Int8(0x1);
static const System::Int8 Af_Inet = System::Int8(0x2);
static const System::Int8 Af_ImpLink = System::Int8(0x3);
static const System::Int8 Af_Pup = System::Int8(0x4);
static const System::Int8 Af_Chaos = System::Int8(0x5);
static const System::Int8 Af_Ipx = System::Int8(0x6);
static const System::Int8 Af_Ns = System::Int8(0x6);
static const System::Int8 Af_Iso = System::Int8(0x7);
static const System::Int8 Af_Osi = System::Int8(0x7);
static const System::Int8 Af_Ecma = System::Int8(0x8);
static const System::Int8 Af_DataKit = System::Int8(0x9);
static const System::Int8 Af_CcItt = System::Int8(0xa);
static const System::Int8 Af_Sna = System::Int8(0xb);
static const System::Int8 Af_DecNet = System::Int8(0xc);
static const System::Int8 Af_Dli = System::Int8(0xd);
static const System::Int8 Af_Lat = System::Int8(0xe);
static const System::Int8 Af_HyLink = System::Int8(0xf);
static const System::Int8 Af_AppleTalk = System::Int8(0x10);
static const System::Int8 Af_NetBios = System::Int8(0x11);
static const System::Int8 Af_VoiceView = System::Int8(0x12);
static const System::Int8 Af_Max = System::Int8(0x13);
static const System::Int8 Pf_Unspec = System::Int8(0x0);
static const System::Int8 Pf_Unix = System::Int8(0x1);
static const System::Int8 Pf_Inet = System::Int8(0x2);
static const System::Int8 Pf_ImpLink = System::Int8(0x3);
static const System::Int8 Pf_Pup = System::Int8(0x4);
static const System::Int8 Pf_Chaos = System::Int8(0x5);
static const System::Int8 Pf_Ns = System::Int8(0x6);
static const System::Int8 Pf_Ipx = System::Int8(0x6);
static const System::Int8 Pf_Iso = System::Int8(0x7);
static const System::Int8 Pf_Osi = System::Int8(0x7);
static const System::Int8 Pf_Ecma = System::Int8(0x8);
static const System::Int8 Pf_DataKit = System::Int8(0x9);
static const System::Int8 Pf_CcItt = System::Int8(0xa);
static const System::Int8 Pf_Sna = System::Int8(0xb);
static const System::Int8 Pf_DecNet = System::Int8(0xc);
static const System::Int8 Pf_Dli = System::Int8(0xd);
static const System::Int8 Pf_Lat = System::Int8(0xe);
static const System::Int8 Pf_HyLink = System::Int8(0xf);
static const System::Int8 Pf_AppleTalk = System::Int8(0x10);
static const System::Int8 Pf_VoiceView = System::Int8(0x12);
static const System::Int8 Pf_Max = System::Int8(0x13);
static const System::Word Sol_Socket = System::Word(0xffff);
static const System::Int8 SoMaxConn = System::Int8(0x5);
static const System::Int8 Msg_Oob = System::Int8(0x1);
static const System::Int8 Msg_Peek = System::Int8(0x2);
static const System::Int8 Msg_DontRoute = System::Int8(0x4);
static const System::Int8 Msg_MaxIovLen = System::Int8(0x10);
static const System::Word Msg_Partial = System::Word(0x8000);
static const System::Word MaxGetHostStruct = System::Word(0x400);
static const System::Int8 Fd_Read = System::Int8(0x1);
static const System::Int8 Fd_Write = System::Int8(0x2);
static const System::Int8 Fd_Oob = System::Int8(0x4);
static const System::Int8 Fd_Accept = System::Int8(0x8);
static const System::Int8 Fd_Connect = System::Int8(0x10);
static const System::Int8 Fd_Close = System::Int8(0x20);
static const System::Word EWouldBlock = System::Word(0x2733);
static const System::Word EInProgress = System::Word(0x2734);
static const System::Word EAlreadY = System::Word(0x2735);
static const System::Word ENotSock = System::Word(0x2736);
static const System::Word EDestAddrReq = System::Word(0x2737);
static const System::Word EMsgSize = System::Word(0x2738);
static const System::Word EPrototype = System::Word(0x2739);
static const System::Word ENoProtoOpt = System::Word(0x273a);
static const System::Word EProtoNoSupport = System::Word(0x273b);
static const System::Word ESocktNoSupport = System::Word(0x273c);
static const System::Word EOpNotSupp = System::Word(0x273d);
static const System::Word EPfNoSupport = System::Word(0x273e);
static const System::Word EAfNoSupport = System::Word(0x273f);
static const System::Word EAddrInUse = System::Word(0x2740);
static const System::Word EAddrNotAvail = System::Word(0x2741);
static const System::Word ENetDown = System::Word(0x2742);
static const System::Word ENetUnreach = System::Word(0x2743);
static const System::Word ENetReset = System::Word(0x2744);
static const System::Word EConnAborted = System::Word(0x2745);
static const System::Word EConnReset = System::Word(0x2746);
static const System::Word ENoBufs = System::Word(0x2747);
static const System::Word EIsConn = System::Word(0x2748);
static const System::Word ENotConn = System::Word(0x2749);
static const System::Word EShutDown = System::Word(0x274a);
static const System::Word ETooManyRefs = System::Word(0x274b);
static const System::Word ETimedOut = System::Word(0x274c);
static const System::Word EConnRefused = System::Word(0x274d);
static const System::Word ELoop = System::Word(0x274e);
static const System::Word ENameTooLong = System::Word(0x274f);
static const System::Word EHostDown = System::Word(0x2750);
static const System::Word EHostUnreach = System::Word(0x2751);
static const System::Word ENotEmpty = System::Word(0x2752);
static const System::Word EProcLim = System::Word(0x2753);
static const System::Word EUsers = System::Word(0x2754);
static const System::Word EDQuot = System::Word(0x2755);
static const System::Word EStale = System::Word(0x2756);
static const System::Word ERemote = System::Word(0x2757);
static const System::Word MaxAddrs = System::Word(0x100);
static const System::Word MaxAlias = System::Word(0x100);
extern DELPHI_PACKAGE TSocketFuncs SockFuncs;
extern DELPHI_PACKAGE bool __fastcall LoadWinsock(void);
extern DELPHI_PACKAGE int __fastcall wsaMakeSyncReply(System::Word Buflen, System::Word Error);
extern DELPHI_PACKAGE int __fastcall wsaMakeSelectReply(System::Word Event, System::Word Error);
extern DELPHI_PACKAGE System::Word __fastcall wsaGetAsyncBuflen(int Param);
extern DELPHI_PACKAGE System::Word __fastcall wsaGetAsyncError(int Param);
extern DELPHI_PACKAGE System::Word __fastcall wsaGetSelectEvent(int Param);
extern DELPHI_PACKAGE System::Word __fastcall wsaGetSelectError(int Param);
extern DELPHI_PACKAGE void __fastcall WinsockExit(void);
}	/* namespace Adwutil */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADWUTIL)
using namespace Adwutil;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdwutilHPP
