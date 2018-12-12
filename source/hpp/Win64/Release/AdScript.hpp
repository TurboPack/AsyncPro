// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdScript.pas' rev: 32.00 (Windows)

#ifndef AdscriptHPP
#define AdscriptHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Winapi.ShellAPI.hpp>
#include <OoMisc.hpp>
#include <AdExcept.hpp>
#include <AdPort.hpp>
#include <AdWnPort.hpp>
#include <ADTrmEmu.hpp>
#include <AdProtcl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adscript
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS EApdScriptError;
class DELPHICLASS TApdScriptNode;
class DELPHICLASS TApdCustomScript;
class DELPHICLASS TApdScript;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION EApdScriptError : public Adexcept::EAPDException
{
	typedef Adexcept::EAPDException inherited;
	
public:
	__fastcall EApdScriptError(unsigned Code, unsigned BadLineNum);
public:
	/* EAPDException.CreateUnknown */ inline __fastcall EApdScriptError(const System::UnicodeString Msg, System::Byte Dummy) : Adexcept::EAPDException(Msg, Dummy) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EApdScriptError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : Adexcept::EAPDException(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EApdScriptError(NativeUInt Ident)/* overload */ : Adexcept::EAPDException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EApdScriptError(System::PResStringRec ResStringRec)/* overload */ : Adexcept::EAPDException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EApdScriptError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : Adexcept::EAPDException(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EApdScriptError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : Adexcept::EAPDException(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EApdScriptError(const System::UnicodeString Msg, int AHelpContext) : Adexcept::EAPDException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EApdScriptError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : Adexcept::EAPDException(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EApdScriptError(NativeUInt Ident, int AHelpContext)/* overload */ : Adexcept::EAPDException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EApdScriptError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Adexcept::EAPDException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EApdScriptError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : Adexcept::EAPDException(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EApdScriptError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : Adexcept::EAPDException(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EApdScriptError(void) { }
	
};


enum DECLSPEC_DENUM TApdScriptCommand : unsigned char { scNoCommand, scComment, scLabel, scInitPort, scInitWnPort, scDonePort, scSend, scWait, scWaitMulti, scIf, scDisplay, scGoto, scSendBreak, scDelay, scSetOption, scUpload, scDownload, scChDir, scDelete, scRun, scUserFunction, scExit };

enum DECLSPEC_DENUM TOption : unsigned char { oNone, oBaud, oDataBits, oFlow, oParity, oStopBits, oWsTelnet, oSetRetry, oSetDirectory, oSetFilemask, oSetFilename, oSetWriteFail, oSetWriteRename, oSetWriteAnyway, oSetZWriteClobber, oSetZWriteProtect, oSetZWriteNewer, oSetZSkipNoFile };

class PASCALIMPLEMENTATION TApdScriptNode : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TApdScriptCommand Command;
	System::AnsiString Data;
	System::AnsiString DataEx;
	TOption Option;
	unsigned Timeout;
	unsigned Condition;
	__fastcall TApdScriptNode(TApdScriptCommand ACommand, TOption AnOption, const System::AnsiString AData, const System::AnsiString ADataEx, unsigned ATimeout, unsigned ACondition);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TApdScriptNode(void) { }
	
};


enum DECLSPEC_DENUM TScriptState : unsigned char { ssNone, ssReady, ssWait, ssFinished };

typedef void __fastcall (__closure *TScriptFinishEvent)(System::TObject* CP, int Condition);

typedef void __fastcall (__closure *TScriptCommandEvent)(System::TObject* CP, TApdScriptNode* Node, int Condition);

typedef void __fastcall (__closure *TScriptDisplayEvent)(System::TObject* CP, const System::AnsiString Msg);

typedef void __fastcall (__closure *TScriptUserFunctionEvent)(System::TObject* CP, const System::AnsiString Command, const System::AnsiString Parameter);

typedef void __fastcall (__closure *TScriptParseVariableEvent)(System::TObject* CP, const System::AnsiString Variable, System::AnsiString &NewValue);

typedef void __fastcall (__closure *TScriptExceptionEvent)(System::TObject* Sender, System::Sysutils::Exception* E, TApdScriptNode* Command, bool &Continue);

class PASCALIMPLEMENTATION TApdCustomScript : public Oomisc::TApdBaseComponent
{
	typedef Oomisc::TApdBaseComponent inherited;
	
protected:
	Adport::TApdCustomComPort* FComPort;
	Adprotcl::TApdCustomProtocol* FProtocol;
	Oomisc::TApdBaseWinControl* FTerminal;
	System::UnicodeString FScriptFile;
	System::Classes::TStrings* FScriptCommands;
	unsigned CurrentLine;
	bool Modified;
	System::Classes::TList* CommandNodes;
	int NodeIndex;
	int NextIndex;
	unsigned TimerTrigger;
	System::StaticArray<unsigned, 20> DataTrigger;
	unsigned TriggerCount;
	Adport::TTriggerEvent SaveOnTrigger;
	TScriptState ScriptState;
	bool CreatedPort;
	bool SaveOpen;
	bool OpenedPort;
	bool CreatedProtocol;
	unsigned LastCondition;
	Adprotcl::TProtocolFinishEvent SaveProtocolFinish;
	bool OldActive;
	bool Continuing;
	bool Closing;
	System::Byte Retry;
	System::Byte Attempts;
	bool FInProgress;
	bool FDisplayToTerminal;
	TScriptFinishEvent FOnScriptFinish;
	TScriptCommandEvent FOnScriptCommandStart;
	TScriptCommandEvent FOnScriptCommandFinish;
	TScriptDisplayEvent FOnScriptDisplay;
	TScriptUserFunctionEvent FOnScriptUserFunction;
	TScriptParseVariableEvent FOnScriptParseVariable;
	TScriptExceptionEvent FOnScriptException;
	void __fastcall SetScriptFile(const System::UnicodeString NewFile);
	void __fastcall SetScriptCommands(System::Classes::TStrings* Values);
	void __fastcall ValidateLabels(void);
	virtual void __fastcall CreateCommand(TApdScriptCommand CmdType, const System::AnsiString Data1, const System::AnsiString Data2);
	virtual void __fastcall AddToScript(const System::AnsiString S);
	bool __fastcall CheckProtocol(void);
	bool __fastcall CheckWinsockPort(void);
	System::AnsiString __fastcall ValidateBaud(const System::AnsiString Baud);
	System::AnsiString __fastcall ValidateDataBits(const System::AnsiString DataBits);
	System::AnsiString __fastcall ValidateFlow(const System::AnsiString Flow);
	System::AnsiString __fastcall ValidateParity(const System::AnsiString Parity);
	System::AnsiString __fastcall ValidateStopBits(const System::AnsiString StopBits);
	void __fastcall AllTriggers(System::TObject* CP, System::Word Msg, System::Word TriggerHandle, System::Word Data);
	virtual void __fastcall ExecuteExternal(const System::UnicodeString S, bool Wait);
	void __fastcall GoContinue(void);
	void __fastcall ParseURL(const System::UnicodeString URL, System::UnicodeString &Addr, System::UnicodeString &Port);
	void __fastcall LogCommand(unsigned Index, TApdScriptCommand Command, TApdScriptNode* const Node);
	void __fastcall ProcessNextCommand(void);
	void __fastcall ProcessTillWait(void);
	void __fastcall ScriptProtocolFinish(System::TObject* CP, int ErrorCode);
	void __fastcall SetFlow(const System::UnicodeString FlowOpt);
	void __fastcall SetParity(const System::UnicodeString ParityOpt);
	virtual void __fastcall ScriptFinish(int Condition);
	void __fastcall ScriptCommandStart(TApdScriptNode* Node, int Condition);
	void __fastcall ScriptCommandFinish(TApdScriptNode* Node, int Condition);
	void __fastcall ScriptDisplay(const System::AnsiString Msg);
	bool __fastcall GenerateScriptException(System::Sysutils::Exception* E, TApdScriptNode* Command);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Loaded(void);
	void __fastcall AddDispatchLogEntry(const System::AnsiString Msg);
	
public:
	__fastcall virtual TApdCustomScript(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdCustomScript(void);
	void __fastcall PrepareScript(void);
	void __fastcall StartScript(void);
	void __fastcall StopScript(int Condition);
	void __fastcall CancelScript(void);
	__property bool InProgress = {read=FInProgress, nodefault};
	__property Adport::TApdCustomComPort* ComPort = {read=FComPort, write=FComPort};
	__property Adprotcl::TApdCustomProtocol* Protocol = {read=FProtocol, write=FProtocol};
	__property Oomisc::TApdBaseWinControl* Terminal = {read=FTerminal, write=FTerminal};
	__property bool DisplayToTerminal = {read=FDisplayToTerminal, write=FDisplayToTerminal, default=1};
	__property System::UnicodeString ScriptFile = {read=FScriptFile, write=SetScriptFile};
	__property System::Classes::TStrings* ScriptCommands = {read=FScriptCommands, write=SetScriptCommands, stored=true};
	__property TScriptFinishEvent OnScriptFinish = {read=FOnScriptFinish, write=FOnScriptFinish};
	__property TScriptCommandEvent OnScriptCommandStart = {read=FOnScriptCommandStart, write=FOnScriptCommandStart};
	__property TScriptCommandEvent OnScriptCommandFinish = {read=FOnScriptCommandFinish, write=FOnScriptCommandFinish};
	__property TScriptDisplayEvent OnScriptDisplay = {read=FOnScriptDisplay, write=FOnScriptDisplay};
	__property TScriptParseVariableEvent OnScriptParseVariable = {read=FOnScriptParseVariable, write=FOnScriptParseVariable};
	__property TScriptUserFunctionEvent OnScriptUserFunction = {read=FOnScriptUserFunction, write=FOnScriptUserFunction};
	__property TScriptExceptionEvent OnScriptException = {read=FOnScriptException, write=FOnScriptException};
};


class PASCALIMPLEMENTATION TApdScript : public TApdCustomScript
{
	typedef TApdCustomScript inherited;
	
__published:
	__property ComPort;
	__property Protocol;
	__property Terminal;
	__property DisplayToTerminal = {default=1};
	__property ScriptFile = {default=0};
	__property ScriptCommands;
	__property OnScriptFinish;
	__property OnScriptCommandStart;
	__property OnScriptCommandFinish;
	__property OnScriptDisplay;
	__property OnScriptParseVariable;
	__property OnScriptUserFunction;
public:
	/* TApdCustomScript.Create */ inline __fastcall virtual TApdScript(System::Classes::TComponent* AOwner) : TApdCustomScript(AOwner) { }
	/* TApdCustomScript.Destroy */ inline __fastcall virtual ~TApdScript(void) { }
	
};


typedef System::StaticArray<System::UnicodeString, 22> Adscript__5;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 MaxDataTriggers = System::Int8(0x14);
static const System::Byte MaxCommandLength = System::Byte(0x80);
static const System::Word MaxCommands = System::Word(0x12c);
static const System::Int8 DefRetryCnt = System::Int8(0x3);
static const System::Word MaxBufSize = System::Word(0x7fff);
static const bool DefDisplayToTerminal = true;
static const System::WideChar CmdSepChar = (System::WideChar)(0x7c);
static const System::Word ecNotACommand = System::Word(0x26ad);
static const System::Word ecBadFormat1 = System::Word(0x26ae);
static const System::Word ecBadFormat2 = System::Word(0x26af);
static const System::Word ecInvalidLabel = System::Word(0x26b0);
static const System::Word ecBadOption = System::Word(0x26b1);
static const System::Word ecTooManyStr = System::Word(0x26b2);
static const System::Word ecNoScriptCommands = System::Word(0x26b3);
static const System::Word ecCommandTooLong = System::Word(0x26b4);
static const System::Word ecNotWinsockPort = System::Word(0x26b5);
static const System::Int8 ccNone = System::Int8(0x0);
static const System::Int8 ccSuccess = System::Int8(0x1);
static const System::Int8 ccIndexFirst = System::Int8(0x1);
static const System::Byte ccIndexLast = System::Byte(0x80);
static const System::Word ccTimeout = System::Word(0x3e9);
static const System::Word ccFail = System::Word(0x3ea);
static const System::Word ccBadExitCode = System::Word(0x3eb);
extern DELPHI_PACKAGE Adscript__5 ScriptStr;
}	/* namespace Adscript */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADSCRIPT)
using namespace Adscript;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdscriptHPP
