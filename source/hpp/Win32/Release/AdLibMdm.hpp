// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdLibMdm.pas' rev: 32.00 (Windows)

#ifndef AdlibmdmHPP
#define AdlibmdmHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <OoMisc.hpp>
#include <AdXBase.hpp>
#include <AdXParsr.hpp>
#include <AdExcept.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Adlibmdm
{
//-- forward type declarations -----------------------------------------------
struct TLmModemName;
struct TLmResponseData;
struct TLmResponses;
struct TLmModemCommand;
struct TLmFaxClassDetails;
struct TLmFaxDetails;
struct TLmWaveFormat;
struct TLmWaveDriver;
struct TLmVoiceSettings;
struct TLmModemSettings;
struct TLmModemHardware;
struct TLmModem;
class DELPHICLASS TLmModemClass;
class DELPHICLASS TApdLmModemNameClass;
class DELPHICLASS TApdLmModemCollectionItem;
class DELPHICLASS TApdLmModemCollection;
class DELPHICLASS TApdLibModem;
class DELPHICLASS TApdModemSelectionDialog;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TApdLoadModemRecord)(System::UnicodeString ModemName, System::UnicodeString Manufacturer, System::UnicodeString Model, System::UnicodeString ModemFile, bool &CanLoad);

typedef void __fastcall (__closure *TApdLoadModem)(System::UnicodeString ModemName, System::UnicodeString Manufacturer, System::UnicodeString Model, bool &CanLoad);

typedef TLmModemName *PLmModemName;

struct DECLSPEC_DRECORD TLmModemName
{
public:
	System::UnicodeString ModemName;
	System::UnicodeString Manufacturer;
	System::UnicodeString Model;
	System::UnicodeString ModemFile;
};


typedef TLmResponseData *PLmResponseData;

struct DECLSPEC_DRECORD TLmResponseData
{
public:
	System::UnicodeString Response;
	System::UnicodeString ResponseType;
};


typedef TLmResponses *PLmResponses;

struct DECLSPEC_DRECORD TLmResponses
{
public:
	System::Classes::TList* OK;
	System::Classes::TList* NegotiationProgress;
	System::Classes::TList* Connect;
	System::Classes::TList* Error;
	System::Classes::TList* NoCarrier;
	System::Classes::TList* NoDialTone;
	System::Classes::TList* Busy;
	System::Classes::TList* NoAnswer;
	System::Classes::TList* Ring;
	System::Classes::TList* VoiceView1;
	System::Classes::TList* VoiceView2;
	System::Classes::TList* VoiceView3;
	System::Classes::TList* VoiceView4;
	System::Classes::TList* VoiceView5;
	System::Classes::TList* VoiceView6;
	System::Classes::TList* VoiceView7;
	System::Classes::TList* VoiceView8;
	System::Classes::TList* RingDuration;
	System::Classes::TList* RingBreak;
	System::Classes::TList* Date;
	System::Classes::TList* Time;
	System::Classes::TList* Number;
	System::Classes::TList* Name;
	System::Classes::TList* Msg;
	System::Classes::TList* SingleRing;
	System::Classes::TList* DoubleRing;
	System::Classes::TList* TripleRing;
	System::Classes::TList* Voice;
	System::Classes::TList* Fax;
	System::Classes::TList* Data;
	System::Classes::TList* Other;
};


typedef TLmModemCommand *PLmModemCommand;

struct DECLSPEC_DRECORD TLmModemCommand
{
public:
	System::UnicodeString Command;
	int Sequence;
};


struct DECLSPEC_DRECORD TLmFaxClassDetails
{
public:
	System::UnicodeString ModemResponseFaxDetect;
	System::UnicodeString ModemResponseDataDetect;
	System::UnicodeString SerialSpeedFaxDetect;
	System::UnicodeString SerialSpeedDataDetect;
	System::UnicodeString HostCommandFaxDetect;
	System::UnicodeString HostCommandDataDetect;
	System::UnicodeString ModemResponseFaxConnect;
	System::UnicodeString ModemResponseDataConnect;
	System::Classes::TList* AnswerCommand;
};


struct DECLSPEC_DRECORD TLmFaxDetails
{
public:
	System::UnicodeString ExitCommand;
	System::UnicodeString PreAnswerCommand;
	System::UnicodeString PreDialCommand;
	System::UnicodeString ResetCommand;
	System::UnicodeString SetupCommand;
	System::UnicodeString EnableV17Recv;
	System::UnicodeString EnableV17Send;
	System::UnicodeString FixModemClass;
	System::UnicodeString FixSerialSpeed;
	System::UnicodeString HighestSendSpeed;
	System::UnicodeString LowestSendSpeed;
	System::UnicodeString HardwareFlowControl;
	System::UnicodeString SerialSpeedInit;
	System::UnicodeString Cl1FCS;
	System::UnicodeString Cl2DC2;
	System::UnicodeString Cl2lsEx;
	System::UnicodeString Cl2RecvBOR;
	System::UnicodeString Cl2SendBOR;
	System::UnicodeString Cl2SkipCtrlQ;
	System::UnicodeString Cl2SWBOR;
	System::UnicodeString Class2FlowOff;
	System::UnicodeString Class2FlowHW;
	System::UnicodeString Class2FlowSW;
	TLmFaxClassDetails FaxClass1;
	TLmFaxClassDetails FaxClass2;
	TLmFaxClassDetails FaxClass2_0;
};


typedef TLmWaveFormat *PLmWaveFormat;

struct DECLSPEC_DRECORD TLmWaveFormat
{
public:
	System::UnicodeString ChipSet;
	System::UnicodeString Speed;
	System::UnicodeString SampleSize;
};


struct DECLSPEC_DRECORD TLmWaveDriver
{
public:
	System::UnicodeString BaudRate;
	System::UnicodeString WaveHardwareID;
	System::UnicodeString WaveDevices;
	System::UnicodeString LowerMid;
	System::UnicodeString LowerWaveInPid;
	System::UnicodeString LowerWaveOutPid;
	System::UnicodeString WaveOutMixerDest;
	System::UnicodeString WaveOutMixerSource;
	System::UnicodeString WaveInMixerDest;
	System::UnicodeString WaveInMixerSource;
	System::Classes::TList* WaveFormat;
};


struct DECLSPEC_DRECORD TLmVoiceSettings
{
public:
	System::UnicodeString VoiceProfile;
	int HandsetCloseDelay;
	System::UnicodeString SpeakerPhoneSpecs;
	System::UnicodeString AbortPlay;
	System::UnicodeString CallerIDOutSide;
	System::UnicodeString CallerIDPrivate;
	System::UnicodeString TerminatePlay;
	System::UnicodeString TerminateRecord;
	System::UnicodeString VoiceManufacturerID;
	System::UnicodeString VoiceProductIDWaveIn;
	System::UnicodeString VoiceProductIDWaveOut;
	System::UnicodeString VoiceSwitchFeatures;
	int VoiceBaudRate;
	System::UnicodeString VoiceMixerMid;
	System::UnicodeString VoiceMixerPid;
	System::UnicodeString VoiceMixerLineID;
	System::Classes::TList* CloseHandset;
	System::Classes::TList* EnableCallerID;
	System::Classes::TList* EnableDistinctiveRing;
	System::Classes::TList* GenerateDigit;
	System::Classes::TList* HandsetPlayFormat;
	System::Classes::TList* HandsetRecordFormat;
	System::Classes::TList* LineSetPlayFormat;
	System::Classes::TList* LineSetRecordFormat;
	System::Classes::TList* OpenHandset;
	System::Classes::TList* SpeakerPhoneDisable;
	System::Classes::TList* SpeakerPhoneEnable;
	System::Classes::TList* SpeakerPhoneMute;
	System::Classes::TList* SpeakerPhoneSetVolumeGain;
	System::Classes::TList* SpeakerPhoneUnMute;
	System::Classes::TList* StartPlay;
	System::Classes::TList* StartRecord;
	System::Classes::TList* StopPlay;
	System::Classes::TList* StopRecord;
	System::Classes::TList* VoiceAnswer;
	System::Classes::TList* VoiceDialNumberSetup;
	System::Classes::TList* VoiceToDataAnswer;
	TLmWaveDriver WaveDriver;
};


struct DECLSPEC_DRECORD TLmModemSettings
{
public:
	System::UnicodeString Prefix;
	System::UnicodeString Terminator;
	System::UnicodeString DialPrefix;
	System::UnicodeString DialSuffix;
	System::UnicodeString SpeakerVolume_High;
	System::UnicodeString SpeakerVolume_Low;
	System::UnicodeString SpeakerVolume_Med;
	System::UnicodeString SpeakerMode_Dial;
	System::UnicodeString SpeakerMode_Off;
	System::UnicodeString SpeakerMode_On;
	System::UnicodeString SpeakerMode_Setup;
	System::UnicodeString FlowControl_Hard;
	System::UnicodeString FlowControl_Off;
	System::UnicodeString FlowControl_Soft;
	System::UnicodeString ErrorControl_Forced;
	System::UnicodeString ErrorControl_Off;
	System::UnicodeString ErrorControl_On;
	System::UnicodeString ErrorControl_Cellular;
	System::UnicodeString ErrorControl_Cellular_Forced;
	System::UnicodeString Compression_Off;
	System::UnicodeString Compression_On;
	System::UnicodeString Modulation_Bell;
	System::UnicodeString Modulation_CCITT;
	System::UnicodeString Modulation_CCITT_V23;
	System::UnicodeString SpeedNegotiation_On;
	System::UnicodeString SpeedNegotiation_Off;
	System::UnicodeString Pulse;
	System::UnicodeString Tone;
	System::UnicodeString Blind_Off;
	System::UnicodeString Blind_On;
	System::UnicodeString CallSetupFailTimer;
	System::UnicodeString InactivityTimeout;
	System::UnicodeString CompatibilityFlags;
	int ConfigDelay;
};


struct DECLSPEC_DRECORD TLmModemHardware
{
public:
	System::UnicodeString AutoConfigOverride;
	System::UnicodeString ComPort;
	System::UnicodeString InvalidRDP;
	int IoBaseAddress;
	int InterruptNumber;
	bool PermitShare;
	System::UnicodeString RxFIFO;
	int RxTxBufferSize;
	System::UnicodeString TxFIFO;
	System::UnicodeString Pcmcia;
	System::UnicodeString BusType;
	int PCCARDAttributeMemoryAddress;
	int PCCARDAttributeMemorySize;
	int PCCARDAttributeMemoryOffset;
};


typedef TLmModem *PLmModem;

struct DECLSPEC_DRECORD TLmModem
{
public:
	System::UnicodeString Inheritance;
	System::UnicodeString AttachedTo;
	System::UnicodeString FriendlyName;
	System::UnicodeString Manufacturer;
	System::UnicodeString Model;
	System::UnicodeString ModemID;
	System::UnicodeString InactivityFormat;
	System::UnicodeString Reset;
	System::UnicodeString DCB;
	System::UnicodeString Properties;
	int ForwardDelay;
	System::UnicodeString VariableTerminator;
	System::UnicodeString InfPath;
	System::UnicodeString InfSection;
	System::UnicodeString ProviderName;
	System::UnicodeString DriverDesc;
	System::UnicodeString ResponsesKeyName;
	System::UnicodeString Default;
	int CallSetupFailTimeout;
	int InactivityTimeout;
	bool SupportsWaitForBongTone;
	bool SupportsWaitForQuiet;
	bool SupportsWaitForDialTone;
	bool SupportsSpeakerVolumeLow;
	bool SupportsSpeakerVolumeMed;
	bool SupportsSpeakerVolumeHigh;
	bool SupportsSpeakerModeOff;
	bool SupportsSpeakerModeDial;
	bool SupportsSpeakerModeOn;
	bool SupportsSpeakerModeSetup;
	bool SupportsSetDataCompressionNegot;
	bool SupportsSetErrorControlProtNegot;
	bool SupportsSetForcedErrorControl;
	bool SupportsSetCellular;
	bool SupportsSetHardwareFlowControl;
	bool SupportsSetSoftwareFlowControl;
	bool SupportsCCITTBellToggle;
	bool SupportsSetSpeedNegotiation;
	bool SupportsSetTonePulse;
	bool SupportsBlindDial;
	bool SupportsSetV21V23;
	bool SupportsModemDiagnostics;
	int MaxDTERate;
	int MaxDCERate;
	System::UnicodeString CurrentCountry;
	int MaximumPortSpeed;
	int PowerDelay;
	int ConfigDelay;
	int BaudRate;
	TLmResponses Responses;
	System::Classes::TList* Answer;
	System::Classes::TList* Fax;
	TLmFaxDetails FaxDetails;
	TLmVoiceSettings Voice;
	System::Classes::TList* Hangup;
	System::Classes::TList* Init;
	System::Classes::TList* Monitor;
	TLmModemSettings Settings;
	TLmModemHardware Hardware;
	System::Classes::TStringList* BaudRates;
	System::Classes::TStringList* Options;
};


enum DECLSPEC_DENUM TApdModemLoadState : unsigned char { mlsGeneral, mlsResponses, mlsAnswer, mlsFax, mlsFaxDetails, mlsVoice, mlsHangup, mlsInit, mlsMonitor, mlsSettings, mlsHardware, mlsBaudRates, mlsOptions, mlsISDN, mlsGSM, mlsNone };

enum DECLSPEC_DENUM TApdResponseLoadState : unsigned char { rlsOK, rlsNegotiationProgress, rlsConnect, rlsError, rlsNoCarrier, rlsNoDialTone, rlsBusy, rlsNoAnswer, rlsRing, rlsVoiceView1, rlsVoiceView2, rlsVoiceView3, rlsVoiceView4, rlsVoiceView5, rlsVoiceView6, rlsVoiceView7, rlsVoiceView8, rlsRingDuration, rlsRingBreak, rlsDate, rlsTime, rlsNumber, rlsName, rlsMessage, rlsSingleRing, rlsDoubleRing, rlsTripleRing, rlsVoice, rlsFax, rlsData, rlsOther, rlsNone };

enum DECLSPEC_DENUM TApdVoiceLoadState : unsigned char { vlsCloseHandset, vlsEnableCallerID, vlsEnableDistinctiveRing, vlsGenerateDigit, vlsHandsetPlayFormat, vlsHandsetRecordFormat, vlsLineSetPlayFormat, vlsLineSetRecordFormat, vlsOpenHandset, vlsSpeakerPhoneDisable, vlsSpeakerPhoneEnable, vlsSpeakerPhoneMute, vlsSpeakerPhoneSetVolumeGain, vlsSpeakerPhoneUnMute, vlsStartPlay, vlsStartRecord, vlsStopPlay, vlsStopRecord, vlsVoiceAnswer, vlsVoiceDialNumberSetup, vlsVoiceToDataAnswer, vlsWaveDriver, vlsWaveFormat, vlsNone };

enum DECLSPEC_DENUM TApdFaxLoadState : unsigned char { flsClass1, flsClass2, flsClass2_0, flsClass1Answer, flsClass2Answer, flsClass2_0Answer, flsNone };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TLmModemClass : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TLmModem LmModem;
public:
	/* TObject.Create */ inline __fastcall TLmModemClass(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TLmModemClass(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdLmModemNameClass : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString ModemName;
	System::UnicodeString Manufacturer;
	System::UnicodeString Model;
	System::UnicodeString ModemFile;
public:
	/* TObject.Create */ inline __fastcall TApdLmModemNameClass(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TApdLmModemNameClass(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdLmModemCollectionItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	System::UnicodeString FModemName;
	System::UnicodeString FManufacturer;
	System::UnicodeString FModel;
	System::UnicodeString FModemFile;
	
__published:
	__property System::UnicodeString ModemName = {read=FModemName, write=FModemName};
	__property System::UnicodeString Manufacturer = {read=FManufacturer, write=FManufacturer};
	__property System::UnicodeString Model = {read=FModel, write=FModel};
	__property System::UnicodeString ModemFile = {read=FModemFile, write=FModemFile};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TApdLmModemCollectionItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TApdLmModemCollectionItem(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TApdLmModemCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TApdLmModemCollectionItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	HIDESBASE TApdLmModemCollectionItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TApdLmModemCollectionItem* const Value);
	
public:
	HIDESBASE TApdLmModemCollectionItem* __fastcall Add(void);
	__property TApdLmModemCollectionItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Create */ inline __fastcall TApdLmModemCollection(System::Classes::TCollectionItemClass ItemClass) : System::Classes::TCollection(ItemClass) { }
	/* TCollection.Destroy */ inline __fastcall virtual ~TApdLmModemCollection(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TApdLibModem : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	System::UnicodeString FLibModemPath;
	bool FCompleteDbs;
	bool FReadingAttributes;
	System::Classes::TList* FModemList;
	System::Classes::TList* FModem;
	int FCurIndex;
	TApdModemLoadState FModemLoadState;
	TApdResponseLoadState FResponseLoadState;
	TApdVoiceLoadState FVoiceLoadState;
	TApdFaxLoadState FFaxLoadState;
	int FCurModemIdx;
	TApdLoadModemRecord FOnLoadModemRecord;
	TApdLoadModem FOnLoadModem;
	int FLastSeq;
	
protected:
	void __fastcall SetLibModemPath(System::UnicodeString v);
	void __fastcall LoadModemListAttribute(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);
	void __fastcall LoadModemListElementBegin(System::TObject* oOwner, System::WideString sValue);
	void __fastcall LoadModemListElementStart(System::TObject* oOwner, System::WideString sValue);
	void __fastcall LoadModemListElementEnd(System::TObject* oOwner, System::WideString sValue);
	void __fastcall AddCommand(System::Classes::TList* CmdList, System::WideString sValue);
	void __fastcall LoadModemGeneral(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);
	void __fastcall LoadVoiceSettings(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);
	void __fastcall LoadModemSettings(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);
	void __fastcall LoadHardwareSettings(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);
	void __fastcall LoadFaxClassDetails(const TLmFaxClassDetails &FaxClass, System::WideString sName, System::WideString sValue);
	void __fastcall LoadFaxDetails(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);
	void __fastcall LoadModemResponses(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);
	void __fastcall LoadModemAttribute(System::TObject* oOwner, System::WideString sName, System::WideString sValue, bool bSpecified);
	void __fastcall LoadModemBeginElement(System::TObject* oOwner, System::WideString sValue);
	void __fastcall CharData(System::TObject* oOwner, System::WideString sValue);
	void __fastcall LoadModemElementEnd(System::TObject* oOwner, System::WideString sValue);
	int __fastcall GetXMLInteger(System::UnicodeString Value, int Default);
	bool __fastcall GetXMLBoolean(System::UnicodeString Value, bool Default);
	void __fastcall LoadModemList(void);
	void __fastcall FreeModemList(void);
	PLmModem __fastcall CreateModem(void);
	void __fastcall FreeModemEntry(int Value);
	void __fastcall FreeModem(void);
	void __fastcall LoadModem(System::UnicodeString FileName, bool Append);
	
public:
	__fastcall virtual TApdLibModem(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TApdLibModem(void);
	bool __fastcall SelectModem(System::UnicodeString &ModemFile, System::UnicodeString &ModemManufacturer, System::UnicodeString &ModemName, TLmModem &LmModem);
	bool __fastcall IsModemValid(System::UnicodeString ModemFile, System::UnicodeString ModemName);
	int __fastcall CreateNewDetailFile(const System::UnicodeString ModemDetailFile);
	int __fastcall AddModem(const System::UnicodeString ModemDetailFile, const TLmModem &Modem);
	int __fastcall DeleteModem(const System::UnicodeString ModemDetailFile, const System::UnicodeString ModemName);
	int __fastcall GetModem(const System::UnicodeString ModemDetailFile, const System::UnicodeString ModemName, TLmModem &Modem);
	System::Classes::TStringList* __fastcall GetModems(const System::UnicodeString ModemDetailFile);
	int __fastcall AddModemRecord(const TLmModemName &ModemRecord);
	int __fastcall DeleteModemRecord(const TLmModemName &ModemRecord);
	TApdLmModemCollection* __fastcall GetModemRecords(void);
	__property System::Classes::TList* Modem = {read=FModem, write=FModem};
	
__published:
	__property System::UnicodeString LibModemPath = {read=FLibModemPath, write=SetLibModemPath};
	__property bool CompleteDbs = {read=FCompleteDbs, nodefault};
	__property TApdLoadModemRecord OnLoadModemRecord = {read=FOnLoadModemRecord, write=FOnLoadModemRecord};
	__property TApdLoadModem OnLoadModem = {read=FOnLoadModem, write=FOnLoadModem};
};


class PASCALIMPLEMENTATION TApdModemSelectionDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* btnOK;
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Stdctrls::TComboBox* cbxManufacturer;
	Vcl::Stdctrls::TComboBox* cbxName;
	Vcl::Stdctrls::TLabel* lblText;
	Vcl::Stdctrls::TLabel* lblManufacturer;
	Vcl::Stdctrls::TLabel* lblModemName;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormActivate(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall cbxManufacturerSelect(System::TObject* Sender);
	void __fastcall btnOKClick(System::TObject* Sender);
	void __fastcall cbxNameChange(System::TObject* Sender);
	
private:
	bool Activated;
	TApdLibModem* ModemList;
	System::Classes::TStringList* AvailableModems;
	TApdLoadModem OldOnLoadModem;
	TApdLoadModemRecord OldOnLoadModemRecord;
	void __fastcall LoadModemEvent(System::UnicodeString ModemName, System::UnicodeString Manufacturer, System::UnicodeString Model, bool &CanLoad);
	void __fastcall LoadModemRecordEvent(System::UnicodeString ModemName, System::UnicodeString Manufacturer, System::UnicodeString Model, System::UnicodeString ModemFile, bool &CanLoad);
	
public:
	TLmModem LmModem;
	System::UnicodeString SelectedModemName;
	System::UnicodeString SelectedModemManufacturer;
	System::UnicodeString SelectedModemFile;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TApdModemSelectionDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TApdModemSelectionDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TApdModemSelectionDialog(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TApdModemSelectionDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Adlibmdm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ADLIBMDM)
using namespace Adlibmdm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdlibmdmHPP
