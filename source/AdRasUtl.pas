(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADRASUTL.PAS 4.06                   *}
{*********************************************************}
{* RASDLL interface methods                              *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+,B-,A+,J+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdRasUtl;
  {-Basic remote access interface unit}

interface

uses
  Windows,
  SysUtils,
  Messages,
  AdExcept,                                                              {!!.06}
  OoMisc;                                                                {!!.06}


const {Misc constants}
  RASDLL          = 'RASAPI32';
  RasDlgDLL       = 'RASDLG';
  AdRasDialEvent  = 'RasDialEvent';
  WM_RASDIALEVENT = $0CCCD;

{const {RasMaximum buffer sizes} { moved to OOMisc }                     {!!.06}

const {RAS dial notifier types}
  ntNotifyDialFunc1 = 0;
  ntNotifyDialFunc2 = 1;
  ntNotifyWindow    : DWord = $0FFFFFFFF;

const {RAS dial extended features - Windows NT}
  deUsePrefixSuffix           = $00000001;
  dePausedStates              = $00000002;
  deIgnoreModemSpeaker        = $00000004;
  deSetModemSpeaker           = $00000008;
  deIgnoreSoftwarecompression = $00000010;
  deSetSoftwarecompression    = $00000020;
  deDisableConnectedUI        = $00000040;
  deDisableReconnectUI        = $00000080;
  deDisableReconnect          = $00000100;
  deNoUser                    = $00000200;
  dePauseOnScript             = $00000400;
  deRouter                    = $00000800;

const {RAS error codes}
  ecRasOK                          = 0;
  ecRasFunctionNotSupported        = -1;
  ecRasRasBase                     = 600;
  ecRasPending                     = ecRasRasBase + 0;
  ecRasInvalidPortHandle           = ecRasRasBase + 1;
  ecRasPortAlreadyOpen             = ecRasRasBase + 2;
  ecRasBufferTooSmall              = ecRasRasBase + 3;
  ecRasWrongInfoSpecified          = ecRasRasBase + 4;
  ecRasCannotSetPortInfo           = ecRasRasBase + 5;
  ecRasPortNotConnected            = ecRasRasBase + 6;
  ecRasEventInvalid                = ecRasRasBase + 7;
  ecRasDeviceDoesNotExist          = ecRasRasBase + 8;
  ecRasDeviceTypeDoesNotExist      = ecRasRasBase + 9;
  ecRasInvalidBuffer               = ecRasRasBase + 10;
  ecRasRouteNotAvailable           = ecRasRasBase + 11;
  ecRasRouteNotAllocated           = ecRasRasBase + 12;
  ecRasInvalidCompression          = ecRasRasBase + 13;
  ecRasOutOfBuffers                = ecRasRasBase + 14;
  ecRasPortNotFound                = ecRasRasBase + 15;
  ecRasAsyncRequestPending         = ecRasRasBase + 16;
  ecRasAlreadyDisconnecting        = ecRasRasBase + 17;
  ecRasPortNotOpen                 = ecRasRasBase + 18;
  ecRasPortDisconnected            = ecRasRasBase + 19;
  ecRasNoEndPoints                 = ecRasRasBase + 20;
  ecRasCannotOpenPhonebook         = ecRasRasBase + 21;
  ecRasCannotLoadPhonebook         = ecRasRasBase + 22;
  ecRasCannotFindPhonebookEntry    = ecRasRasBase + 23;
  ecRasCannotWritePhonebook        = ecRasRasBase + 24;
  ecRasCorruptPhonebook            = ecRasRasBase + 25;
  ecRasCannotLoadString            = ecRasRasBase + 26;
  ecRasKeyNotFound                 = ecRasRasBase + 27;
  ecRasDisconnection               = ecRasRasBase + 28;
  ecRasRemoteDisconnection         = ecRasRasBase + 29;
  ecRasHardwareFailure             = ecRasRasBase + 30;
  ecRasUserDisconnection           = ecRasRasBase + 31;
  ecRasInvalidSize                 = ecRasRasBase + 32;
  ecRasPortNotAvailable            = ecRasRasBase + 33;
  ecRasCannotProjectClient         = ecRasRasBase + 34;
  ecRasUnknown                     = ecRasRasBase + 35;
  ecRasWrongDeviceAttached         = ecRasRasBase + 36;
  ecRasBadString                   = ecRasRasBase + 37;
  ecRasRequestTimeout              = ecRasRasBase + 38;
  ecRasCannotGetLana               = ecRasRasBase + 39;
  ecRasNetBiosError                = ecRasRasBase + 40;
  ecRasServerOutOfResources        = ecRasRasBase + 41;
  ecRasNameExistsOnNet             = ecRasRasBase + 42;
  ecRasServerGeneralNetFailure     = ecRasRasBase + 43;
  ecRasMsgAliasNotAdded            = ecRasRasBase + 44;
  ecRasAuthInternal                = ecRasRasBase + 45;
  ecRasRestrictedLogonHours        = ecRasRasBase + 46;
  ecRasAcctDisabled                = ecRasRasBase + 47;
  ecRasPasswordExpired             = ecRasRasBase + 48;
  ecRasNoDialinPermission          = ecRasRasBase + 49;
  ecRasServerNotResponding         = ecRasRasBase + 50;
  ecRasFromDevice                  = ecRasRasBase + 51;
  ecRasUnrecognizedResponse        = ecRasRasBase + 52;
  ecRasMacroNotFound               = ecRasRasBase + 53;
  ecRasMacroNotDefined             = ecRasRasBase + 54;
  ecRasMessageMacroNotFound        = ecRasRasBase + 55;
  ecRasDefaultOffMacroNotFound     = ecRasRasBase + 56;
  ecRasFilecouldNotBeOpened        = ecRasRasBase + 57;
  ecRasDeviceNameTooLong           = ecRasRasBase + 58;
  ecRasDevicenameNotFound          = ecRasRasBase + 59;
  ecRasNoResponses                 = ecRasRasBase + 60;
  ecRasNoCommandFound              = ecRasRasBase + 61;
  ecRasWrongKeySpecified           = ecRasRasBase + 62;
  ecRasUnknownDeviceType           = ecRasRasBase + 63;
  ecRasAllocatingMemory            = ecRasRasBase + 64;
  ecRasPortNotConfigured           = ecRasRasBase + 65;
  ecRasDeviceNotReady              = ecRasRasBase + 66;
  ecRasErrorReadingIniFile         = ecRasRasBase + 67;
  ecRasNoConnection                = ecRasRasBase + 68;
  ecRasBadUsageInIniFile           = ecRasRasBase + 69;
  ecRasReadingSectionName          = ecRasRasBase + 70;
  ecRasReadingDeviceType           = ecRasRasBase + 71;
  ecRasReadingDeviceName           = ecRasRasBase + 72;
  ecRasReadingUsage                = ecRasRasBase + 73;
  ecRasReadingMaxConnectBPS        = ecRasRasBase + 74;
  ecRasReadingMaxCarrierBPS        = ecRasRasBase + 75;
  ecRasLineBusy                    = ecRasRasBase + 76;
  ecRasVoiceAnswer                 = ecRasRasBase + 77;
  ecRasNoAnswer                    = ecRasRasBase + 78;
  ecRasNoCarrier                   = ecRasRasBase + 79;
  ecRasNoDialtone                  = ecRasRasBase + 80;
  ecRasInCommand                   = ecRasRasBase + 81;
  ecRasWritingSectionName          = ecRasRasBase + 82;
  ecRasWritingDeviceType           = ecRasRasBase + 83;
  ecRasWritingDeviceName           = ecRasRasBase + 84;
  ecRasWritingMaxConnectBPS        = ecRasRasBase + 85;
  ecRasWritingMaxCarrierBPS        = ecRasRasBase + 86;
  ecRasWritingUsage                = ecRasRasBase + 87;
  ecRasWritingDefaultOff           = ecRasRasBase + 88;
  ecRasReadingDefaultOff           = ecRasRasBase + 89;
  ecRasEmptyIniFile                = ecRasRasBase + 90;
  ecRasAuthenticationFailure       = ecRasRasBase + 91;
  ecRasPortOrDevice                = ecRasRasBase + 92;
  ecRasNotBinaryMacro              = ecRasRasBase + 93;
  ecRasDCBNotFound                 = ecRasRasBase + 94;
  ecRasStateMachinesNotStarted     = ecRasRasBase + 95;
  ecRasStateMachinesAlreadyStarted = ecRasRasBase + 96;
  ecRasPartialResponseLooping      = ecRasRasBase + 97;
  ecRasUnknownResponseKey          = ecRasRasBase + 98;
  ecRasRecvBufFull                 = ecRasRasBase + 99;
  ecRasCmdTooLong                  = ecRasRasBase + 100;
  ecRasUnsupportedBPS              = ecRasRasBase + 101;
  ecRasUnexpectedResponse          = ecRasRasBase + 102;
  ecRasInteractiveMode             = ecRasRasBase + 103;
  ecRasBadCallbackNumber           = ecRasRasBase + 104;
  ecRasInvalidAuthState            = ecRasRasBase + 105;
  ecRasWritingInitBPS              = ecRasRasBase + 106;
  ecRasX25Diagnostic               = ecRasRasBase + 107;
  ecRasAcctExpired                 = ecRasRasBase + 108;
  ecRasChangingPassword            = ecRasRasBase + 109;
  ecRasOverrun                     = ecRasRasBase + 110;
  ecRasRasBaseManConnotInitialize  = ecRasRasBase + 111;
  ecRasBiplexPortNotAvailable      = ecRasRasBase + 112;
  ecRasNoActiveISDNLines           = ecRasRasBase + 113;
  ecRasNoISDNChannelsAvailable     = ecRasRasBase + 114;
  ecRasTooManyLineErrors           = ecRasRasBase + 115;
  ecRasIPConfiguration             = ecRasRasBase + 116;
  ecRasNoIPAddresses               = ecRasRasBase + 117;
  ecRasPPPTimeout                  = ecRasRasBase + 118;
  ecRasPPPRemoteTerminated         = ecRasRasBase + 119;
  ecRasPPPNoProtocolsConfigured    = ecRasRasBase + 120;
  ecRasPPPNoResponse               = ecRasRasBase + 121;
  ecRasPPPInvalidPacket            = ecRasRasBase + 122;
  ecRasPhoneNumberTooLong          = ecRasRasBase + 123;
  ecRasIPXCPNoDialOutConfigured    = ecRasRasBase + 124;
  ecRasIPXCPNoDialInConfigured     = ecRasRasBase + 125;
  ecRasIPXCPDialOutAlreadyActive   = ecRasRasBase + 126;
  ecRasAccessingTCPCFGDLL          = ecRasRasBase + 127;
  ecRasNOIPRasAdapter              = ecRasRasBase + 128;
  ecRasSlipRequiresIP              = ecRasRasBase + 129;
  ecRasProjectionNotComplete       = ecRasRasBase + 130;
  ecRasProtocolNotConfigured       = ecRasRasBase + 131;
  ecRasPPPNotConverging            = ecRasRasBase + 132;
  ecRasPPPCPRejected               = ecRasRasBase + 133;
  ecRasPPPLCPTerminated            = ecRasRasBase + 134;
  ecRasPPPRequiredAddressRejected  = ecRasRasBase + 135;
  ecRasPPPNCPTerminated            = ecRasRasBase + 136;
  ecRasPPPLoopbackDetected         = ecRasRasBase + 137;
  ecRasPPPNoAddressAssigned        = ecRasRasBase + 138;
  ecRasCannotUseLogonCredentials   = ecRasRasBase + 139;
  ecRasTapiConfiguration           = ecRasRasBase + 140;
  ecRasNoLocalEncryption           = ecRasRasBase + 141;
  ecRasNoRemoteEncryption          = ecRasRasBase + 142;
  ecRasRemoteRequiresEncryption    = ecRasRasBase + 143;
  ecRasIPXCPNetNumberConflict      = ecRasRasBase + 144;
  ecRasInvalidSMM                  = ecRasRasBase + 145;
  ecRasSMMUninitialized            = ecRasRasBase + 146;
  ecRasNoMACForPort                = ecRasRasBase + 147;
  ecRasSMMTimeOut                  = ecRasRasBase + 148;
  ecRasBadPhoneNumber              = ecRasRasBase + 149;
  ecRasWrongModule                 = ecRasRasBase + 150;
  ecRasInvalidCallBackNumber       = ecRasRasBase + 151;
  ecRasScriptSyntax                = ecRasRasBase + 152;
  ecRasHangupFailed                = ecRasRasBase + 153;
  ecRasRasEnd                      = ecRasRasBase + 153;

const {RAS Connection status codes}
  csRasBase                = 0;
  { status consts moved to OOMisc }                                      {!!.04}
  

type {Misc types}
  PHRasConn  = ^HRasConn;
  HRasConn   = THandle;
  TRasState  = DWord;
  TRasError  = DWord;
{  FARPROC    = Pointer; }                                           

type {RAS dial paramters}
  PRasDialParams = ^TRasDialParams;
  TRasDialParams = record
    dwSize           : DWord;
    szEntryName      : array [0..RasMaxEntryName] of Char;
    szPhoneNumber    : array [0..RasMaxPhoneNumber] of Char;
    szCallbackNumber : array [0..RasMaxCallBackNum] of Char;
    szUserName       : array [0..RasMaxUserName] of Char;
    szPassword       : array [0..RasMaxPassword] of Char;
    szDomain         : array [0..RasMaxDomain] of Char;
  end;

type {RAS Connection}
  PRasConn = ^TRasConn;
  TRasConn = record
    dwSize       : DWord;
    rasConn      : DWord;
    szEntryName  : array [0..RasMaxEntryName] of Char;
    szDeviceType : array [0..RasMaxDeviceType] of Char;
    szDeviceName : array [0..RasMaxDeviceName] of Char;
  end;
  PRasConnArray = ^TRasConnArray;
  TRasConnArray = array[0..RasMaxEntries] of TRasConn;

type {RAS Connect status}
  PRasConnStatus = ^TRasConnStatus;
  TRasConnStatus = record
    dwSize       : DWord;
    rasConnState : DWord;
    dwError      : DWord;
    szDeviceType : array [0..RasMaxDeviceType] of Char;
    szDeviceName : array [0..RasMaxDeviceName] of Char;
  end;

type {RAS phonebook entry name}
  PRasEntryName = ^TRasEntryName;
  TRasEntryName = record
    dwSize      : LongInt;
    szEntryName : array [0..RasMaxEntryName] of Char;
  end;
  PRasEntryNameArray = ^TRasEntryNameArray;
  TRasEntryNameArray = array[0..RasMaxEntries] of TRasEntryName;

type {RAS dial extended features (Windows NT)}
  PRasDialExtensions = ^TRasDialExtensions;
  TRasDialExtensions = record
    dwSize     : DWord;
    dwfOptions : DWord;
    hwndParent : HWnd;
    reserved   : DWord;
  end;

type {RAS TAPI device information}
  PRasDeviceInfo = ^TRasDeviceInfo;
  TRasDeviceInfo = record
    dwSize       : DWord;
    szDeviceType : array [0..RasMaxDeviceType] of Char;
    szDeviceName : array [0..RasMaxDeviceName] of Char;
  end;

type {RAS country dialing information}
  PRasCountryInfo = ^TRasCountryInfo;
  TRasCountryInfo = record
    dwSize              : DWord;
    dwCountryID	        : DWord;
    dwNextCountryID     : DWord;
    dwCountryCode       : DWord;
    dwCountryNameOffset : DWord;
  end;

{type {RAS IP address - "a.b.c.d"}
  {PRasIPAddr = ^TRasIPAddr;} { moved to OOMisc }                        {!!.06}

{type {RAS phonebook entry properties}
  {PRasEntry = ^TRasEntry;} { moved to OOMisc }                          {!!.06}

type {RAS dial dialog information - AdRasDialDlg}
  PRasDialDlgInfo = ^TRasDialDlgInfo;
  TRasDialDlgInfo = record
    dwSize     : DWord;
    hwndOwner  : Hwnd;
    dwFlags    : DWord;
    xDlg       : Longint;
    yDlg       : Longint;
    dwSubEntry : DWord;
    dwError    : DWord;
    reserved   : DWord;
    reserved2  : DWord;
  end;

type {RAS monitor dialog information - AdRasMonitorDlg}
  PRasMonitorDlgInfo = ^TRasMonitorDlgInfo;
  TRasMonitorDlgInfo = record
    dwSize      : DWord;
    hwndOwner   : HWnd;
    dwFlags     : DWord;
    dwStartPage : DWord;
    xDlg        : Longint;
    yDlg        : Longint;
    dwError     : DWord;
    reserved    : DWord;
    reserved2   : DWord;
  end;

type {RAS phonebook dialog information - AdRasPhonebookDlg}
  PRasPhonebookDlgInfo = ^TRasPhonebookDlgInfo;
  TRasPhonebookDlgInfo = record
    dwSize : DWord;
    hwndOwner : HWnd;
    dwFlags : DWord;
    xDlg : Longint;
    yDlg : Longint;
    dwCallbackId : DWord;
    pCallback : FARPROC;
    dwError : DWord;
    reserved : DWord;
    reserved2 : DWord;
  end;


{RASAPI32 DLL function prototypes}
type
  TRasDial = function (lpDialExtensions : PRasDialExtensions;
                       lszPhonebook : PChar;
                       lpDialParams : PRasDialParams;
                       dwNotifierType : DWord;
                       lpvNotifier : DWord;
                       lpConn : PHRasConn
                       ) : DWord; stdcall;

  TRasDialDlg = function (lpszPhonebook : PChar;
                          lpszEntry : PChar;
                          lpszPhoneNumber : PChar;
                          lpDialDlgInfo : PRasDialDlgInfo
                          ) : BOOL; stdcall;

  TRasMonitorDlg = function (lpszDeviceName : PChar;
                             lpMonitorDlgInfo : PRasMonitorDlgInfo
                             ) : BOOL; stdcall;

  TRasPhonebookDlg = function (lpszPhonebook : PChar;
                               lpszEntry : PChar;
                               lpPBDlgInfo: PRasPhonebookDlgInfo
                               ) : BOOL; stdcall;

  TRasEnumConnections = function (lpConn : PRasConn;
                                  var lpBufSize : DWord;
                                  var lpNumConnections : DWord
                                  ) : DWord; stdcall;

  TRasEnumEntries = function(lpReserved, lpszPhonebook : PChar;
                              lpEntryName : PRasEntryName;
                              var lpEntryNameSize : DWord;
                              var lpNumEntries : DWord
                              ) : DWord; stdcall;

  TRasClearConnectionStatistics = function(Conn : HRasConn               {!!.06}
                                           ) : DWORD; stdcall;           {!!.06}

  TRasGetConnectionStatistics = function(Conn : HRasConn;                {!!.06}
                                         lpStatistics : PRasStatistics   {!!.06}
                                         ) : DWord; stdcall;             {!!.06}

  TRasGetConnectStatus = function(Conn : HRasConn;
                                  lpConnStatus : PRasConnStatus
                                  ) : DWord; stdcall;

  TRasGetErrorString = function(ErrorCode : DWord;
                                lpszErrorString : PChar;
                                BufSize : DWord
                                ) : DWord; stdcall;

  TRasHangup = function(RasConn : HRasConn
                        ) : DWord; stdcall;

  TRasGetEntryDialParams = function(lpszPhonebook : PChar;
                                    lpDialParams : PRasDialParams;
                                    var Password : Bool
                                    ) : DWord; stdcall;

  TRasSetEntryDialParams = function(lpszPhonebook : PChar;
                                    lpDialParams : PRasDialParams;
                                    RemovePassword : Bool
                                    ) : DWord; stdcall;

  TRasCreatePhonebookEntry = function(HWnd : THandle;
                                      lpszPhoneBook : PChar
                                      ) : DWord; stdcall;

  TRasEditPhonebookEntry = function(HWnd : THandle;
                                    lpszPhonebook, lpszEntryName : PChar
                                    ) : DWord; stdcall;

  TRasDeleteEntry = function(lpszPhonebook : PChar;
                             lpszEntryName : PChar
                             ) : DWord; stdcall;

  TRasRenameEntry = function(lpszPhonebook : PChar;
                             lpszEntryOld : PChar;
                             lpszEntryNew : PChar
                             ) : DWord; stdcall;

  TRasEnumDevices = function(lpDeviceInfo: PRasDeviceInfo;
                             var lpDeviceInfoSize: DWord;
                             var lpNumDevices: DWord
                             ) : DWord; stdcall;

  TRasGetCountryInfo = function(lpCountryInfo: PRasCountryInfo;
                                var lpCountryInfoSize: DWord
                                ): DWord; stdcall;

  TRasGetEntryProperties = function(lpszPhonebook, lpszEntry: PChar;
                                    lpEntry: PRasEntry;
                                    var lpEntrySize : DWord;
                                    lpDeviceInfo : PTapiConfigRec;       {!!.06}
                                    var lpDeviceInfoSize : DWord
                                    ): DWord; stdcall;

  TRasSetEntryProperties = function(lpszPhonebook, lpszEntry: PChar;
                                    lpEntryInfo: PRasEntry;
                                    EntryInfoSize: DWord;
                                    lpDeviceInfo: PTapiConfigRec;        {!!.06}
                                    DeviceInfoSize: DWord
                                    ): DWord; stdcall;

  TRasValidateEntryName = function(lpszPhonebook, lpszEntry: PChar
                                   ): DWord; stdcall;


{ RAS DLL routine wrappers and public routines }
function AdRasDial(PDialExtensions : PRasDialExtensions;
                   const Phonebook : string;
                   PDialParams : PRasDialParams;
                   NotifierType : DWord;
                   Notifier : DWord;
                   var HConn : HRasConn
                   ) : Integer;

function AdRasDialDlg(const Phonebook : string;
                      const EntryName : string;
                      const PhoneNumber : string;
                      PDialDlgInfo : PRasDialDlgInfo
                      ) : Integer;

function AdRasMonitorDlg(const DeviceName : string;
                         PMonitorDlgInfo : PRasMonitorDlgInfo
                         ) : Integer;

function AdRasPhonebookDlg(const Phonebook, EntryName : string;
                           PPhonebookDlgInfo: PRasPhonebookDlgInfo
                           ) : Integer;

function AdRasEnumConnections(PConn : PRasConn;
                              var ConnSize : DWord;
                              var NumConnections : DWord
                              ) : Integer;

function AdRasEnumEntries(const Phonebook : string;
                          PEntryName : PRasEntryName;
                          var EntryNameSize : DWord;
                          var NumEntries : DWord
                          ) : Integer;

function AdRasClearConnectionStatistics(HConn : THandle) : Integer;      {!!.06}

function AdRasGetConnectionStatistics(HConn : THandle;                   {!!.06}
                                      PStatistics : PRasStatistics       {!!.06}
                                      ) : Integer;                       {!!.06}

function AdRasGetConnectStatus(HConn : THandle;
                               PConnStatus : PRasConnStatus
                               ) : Integer;

function AdRasGetErrorString(ErrorCode : Integer
                             ) : string;

function AdRasHangup(HConn : THandle
                     ) : Integer;

function AdRasGetEntryDialParams(const Phonebook : string;
                                 PDialParams : PRasDialParams;
                                 var GotPassword : Boolean
                                 ) : Integer;

function AdRasSetEntryDialParams(const Phonebook : string;
                                 PDialParams : PRasDialParams;
                                 RemovePassword : Boolean
                                 ) : Integer;

function AdRasCreatePhonebookEntry(HWnd : THandle;
                                   const PhoneBook : string
                                   ) : Integer;

function AdRasEditPhonebookEntry(HWnd : THandle;
                                 const Phonebook, EntryName : string
                                 ) : Integer;

function AdRasDeleteEntry(const Phonebook, EntryName : string
                          ) : Integer;

function AdRasRenameEntry(const Phonebook, EntryOld, EntryNew : string
                          ) : Integer;

function AdRasEnumDevices(PDeviceInfo : PRasDeviceInfo;
                          var DeviceInfoSize : DWord;
                          var NumDevices : DWord
                          ) : Integer;

function AdRasGetCountryInfo(PCountryInfo : PRasCountryInfo;
                             var CountryInfoSize : DWord
                             ) : Integer;

function AdRasGetEntryProperties(const Phonebook, EntryName : string;
                                 PEntry : PRasEntry;
                                 var EntrySize : DWord;
                                 PDeviceInfo : PTapiConfigRec;           {!!.06}
                                 var DeviceInfoSize : DWord
                                 ) : Integer;

function AdRasSetEntryProperties(const Phonebook, EntryName : string;
                                 PEntry : PRasEntry;
                                 var EntrySize : DWord;
                                 PDeviceInfo : PTapiConfigRec;           {!!.06}
                                 var DeviceInfoSize : DWord
                                 ) : Integer;

function AdRasValidateEntryName(const Phonebook, EntryName : string
                                ) : Integer;


procedure LoadRASDLL;


var
  AdRasPlatformID : DWord;


implementation

{uses}                                                                   {!!.06}
  {AdExcept,}                                                            {!!.06}
  {OoMisc;}                                                              {!!.06}

var {Misc variables}
  RASModule               : THandle = 0;
  RASDlgModule            : THandle = 0;
  VersionInfo             : TOsVersionInfo;

var {RAS DLL functions}
  RasDial                 : TRasDial                 = nil;
  RasDialDlg              : TRasDialDlg              = nil;
  RasMonitorDlg           : TRasMonitorDlg           = nil;
  RasPhonebookDlg         : TRasPhonebookDlg         = nil;
  RasEnumConnections      : TRasEnumConnections      = nil;
  RasEnumEntries          : TRasEnumEntries          = nil;
  RasClearConnectionStatistics : TRasClearConnectionStatistics = nil;    {!!.06}
  RasGetConnectionStatistics : TRasGetConnectionStatistics = nil;        {!!.06}
  RasGetConnectStatus     : TRasGetConnectStatus     = nil;
  RasGetErrorString       : TRasGetErrorString       = nil;
  RasHangUp               : TRasHangUp               = nil;
  RasCreatePhoneBookEntry : TRasCreatePhoneBookEntry = nil;
  RasEditPhonebookEntry   : TRasEditPhonebookEntry   = nil;
  RasSetEntryDialParams   : TRasSetEntryDialParams   = nil;
  RasGetEntryDialParams   : TRasGetEntryDialParams   = nil;
  RasDeleteEntry          : TRasDeleteEntry          = nil;
  RasRenameEntry          : TRasRenameEntry          = nil;
  RasEnumDevices          : TRasEnumDevices          = nil;
  RasGetCountryInfo       : TRasGetCountryInfo       = nil;
  RasGetEntryProperties   : TRasGetEntryProperties   = nil;
  RasSetEntryProperties   : TRasSetEntryProperties   = nil;
  RasValidateEntryName    : TRasValidateEntryName    = nil;


{ Misc utilities }
procedure LoadRASDLL;
begin
  if (RASModule = 0) then begin
    RASModule := LoadLibrary(RASDLL);
    if (RASModule = 0) then
      raise ERas.Create(ecRasLoadFail, False);

    VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
    if GetVersionEx(VersionInfo) then
      AdRasPlatformID := VersionInfo.dwPlatformId
    else
      AdRasPlatformID := VER_PLATFORM_WIN32s;

    @RasDial := GetProcAddress(RASModule, 'RasDialW');
    @RasEnumConnections := GetProcAddress(RASModule, 'RasEnumConnectionsW');
    @RasClearConnectionStatistics := GetProcAddress(RasModule,           {!!.06}   
      'RasClearConnectionStatistics');                                   {!!.06}
    @RasGetConnectionStatistics := GetProcAddress(RASModule,             {!!.06}
      'RasGetConnectionStatistics');                                     {!!.06}
    @RasGetConnectStatus := GetProcAddress(RASModule, 'RasGetConnectStatusW');
    @RasGetErrorString := GetProcAddress(RASModule, 'RasGetErrorStringW');
    @RasHangUp := GetProcAddress(RASModule, 'RasHangUpW');
    @RasCreatePhoneBookEntry := GetProcAddress(RASModule, 'RasCreatePhonebookEntryW');
    @RasEnumEntries := GetProcAddress(RASModule, 'RasEnumEntriesW');
    @RasGetEntryDialParams := GetProcAddress(RASModule, 'RasGetEntryDialParamsW');
    @RasSetEntryDialParams := GetProcAddress(RASModule, 'RasSetEntryDialParamsW');
    @RasEditPhonebookEntry := GetProcAddress(RASModule, 'RasEditPhonebookEntryW');
    @RasDeleteEntry := GetProcAddress(RASModule, 'RasDeleteEntryW');
    @RasRenameEntry := GetProcAddress(RASModule, 'RasRenameEntryW');

    @RasEnumDevices := GetProcAddress(RASModule, 'RasEnumDevicesW');
    @RasGetCountryInfo := GetProcAddress(RASModule, 'RasGetCountryInfoW');
    @RasGetEntryProperties := GetProcAddress(RASModule, 'RasGetEntryPropertiesW');
    @RasSetEntryProperties := GetProcAddress(RASModule, 'RasSetEntryPropertiesW');
    @RasValidateEntryName := GetProcAddress(RASModule, 'RasValidateEntryNameW');
  end;
end;

procedure LoadRasDlgDLL;
begin
  if (RasDlgModule = 0) then begin
    RasDlgModule := LoadLibrary(RasDlgDLL);
    if (RasDlgModule = 0) then
      Exit;
  end;
  @RasDialDlg := GetProcAddress(RASDlgModule, 'RasDialDlgW');
  @RasMonitorDlg := GetProcAddress(RASDlgModule, 'RasMonitorDlgW');
  @RasPhonebookDlg := GetProcAddress(RASDlgModule, 'RasPhonebookDlgW');
end;

function AdRasString(const Str : string) : PChar;
  {returns nil pointer if string is empty}
begin
  if (Str <> '') then
    Result := PChar(Str)
  else
    Result := nil;
end;

function AdRasPhoneBook(const PhoneBook : string) : PChar;
  {return nil pointer if not Windows NT}
begin
  if (AdRasPlatFormID = VER_PLATFORM_WIN32_NT) and (PhoneBook <> '') then
    Result := AdRasString(PhoneBook)
  else
    Result := nil;
end;

function AdDialExtensions(PDialExtensions : PRasDialExtensions
                          ) : PRasDialExtensions;
  {return nil pointer if not Windows NT}
begin
  if (AdRasPlatFormID = VER_PLATFORM_WIN32_NT) then
    Result := PDialExtensions
  else
    Result := nil;
end;


{ RASAPI functions }
function AdRasDial(PDialExtensions : PRasDialExtensions;
                   const Phonebook : string;
                   PDialParams : PRasDialParams;
                   NotifierType : DWord;
                   Notifier : DWord;
                   var HConn : THandle
                   ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasDial) then
    Result := RasDial(AdDialExtensions(PDialExtensions), AdRasPhoneBook(Phonebook),
      PDialParams, NotifierType, Notifier, @HConn)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasDialDlg(const Phonebook : string;
                      const EntryName : string;
                      const PhoneNumber : string;
                      PDialDlgInfo : PRasDialDlgInfo
                      ) : Integer;
begin
  Result := ecRasFunctionNotSupported;
  LoadRasDlgDLL;
  if Assigned(RasDialDlg) then
    if RasDialDlg(AdRasPhoneBook(Phonebook), AdRasString(EntryName),
      AdRasString(PhoneNumber), PDialDlgInfo) then
        Result := PDialDlgInfo^.dwError;
end;

function AdRasMonitorDlg(const DeviceName : string;
                         PMonitorDlgInfo : PRasMonitorDlgInfo
                         ) : Integer;
begin
  Result := ecRasFunctionNotSupported;
  LoadRasDlgDLL;
  if Assigned(RasMonitorDlg) then
    if RasMonitorDlg(AdRasString(DeviceName), PMonitorDlgInfo) then
        Result := PMonitorDlgInfo^.dwError;
end;

function AdRasPhonebookDlg(const Phonebook, EntryName : string;
                           PPhonebookDlgInfo: PRasPhonebookDlgInfo
                           ) : Integer;
begin
  Result := ecRasFunctionNotSupported;
  LoadRasDlgDLL;
  if Assigned(RasPhonebookDlg) then
    if RasPhonebookDlg(AdRasPhoneBook(Phonebook), AdRasString(EntryName),
      PPhonebookDlgInfo) then
        Result := PPhonebookDlgInfo^.dwError;
end;

function AdRasEnumConnections(PConn : PRasConn;
                              var ConnSize : DWord;
                              var NumConnections : DWord
                              ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasEnumConnections) then
    Result := RasEnumConnections(PConn, ConnSize, NumConnections)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasEnumEntries(const Phonebook : string;
                          PEntryName : PRasEntryName;
                          var EntryNameSize : DWord;
                          var NumEntries : DWord
                          ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasEnumEntries) then
    Result := RasEnumEntries(nil, AdRasPhoneBook(Phonebook), PEntryName,
      EntryNameSize, NumEntries)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasClearConnectionStatistics(HConn : THandle) : Integer;      {!!.06}
begin                                                                    {!!.06}
  LoadRASDLL;                                                            {!!.06}
  if Assigned(RasClearConnectionStatistics) then                         {!!.06}
    Result := RasClearConnectionStatistics(HConn)                        {!!.06}
  else                                                                   {!!.06}
    Result := ecRasFunctionNotSupported;                                 {!!.06}
end;                                                                     {!!.06}

function AdRasGetConnectionStatistics(HConn : THandle;                   {!!.06}
                                      PStatistics : PRasStatistics       {!!.06}
                                      ) : Integer;                       {!!.06}
begin                                                                    {!!.06}
  LoadRASDLL;                                                            {!!.06}
  if Assigned(RasGetConnectionStatistics) then                           {!!.06}
    Result := RasGetConnectionStatistics(HConn, PStatistics)             {!!.06}
  else                                                                   {!!.06}
    Result := ecRasFunctionNotSupported;                                 {!!.06}
end;                                                                     {!!.06}

function AdRasGetConnectStatus(HConn : THandle;
                               PConnStatus : PRasConnStatus
                               ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasGetConnectStatus) then
    Result := RasGetConnectStatus(HConn, PConnStatus)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasGetErrorString(ErrorCode : Integer
                             ) : string;
var
  ErrorStr : array[0..RasMaxError] of Char;
begin
  FillChar(ErrorStr, SizeOf(ErrorStr), #0);
  LoadRASDLL;
  if (ErrorCode = ecRasFunctionNotSupported) or not Assigned(RasGetErrorString) then
    StrPCopy(ErrorStr, 'Function not Supported')
  else
    RasGetErrorString(ErrorCode, ErrorStr, SizeOf(ErrorStr));
  Result := StrPas(ErrorStr);
end;

function AdRasHangup(HConn : THandle
                     ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasHangup) then
    Result := RasHangup(HConn)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasGetEntryDialParams(const Phonebook : string;
                                 PDialParams : PRasDialParams;
                                 var GotPassword : Boolean
                                 ) : Integer;
var
  GotPWBool : Bool;
begin
  LoadRASDLL;
  if Assigned(RasGetEntryDialParams) then begin
    Result := RasGetEntryDialParams(AdRasPhoneBook(Phonebook), PDialParams,
      GotPWBool);
    GotPassword := GotPWBool;
  end else
    Result := ecRasFunctionNotSupported;
end;

function AdRasSetEntryDialParams(const Phonebook : string;
                                 PDialParams : PRasDialParams;
                                 RemovePassword : Boolean
                                 ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasSetEntryDialParams) then
    Result := RasSetEntryDialParams(AdRasPhoneBook(Phonebook), PDialParams,
      Bool(RemovePassword))
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasCreatePhonebookEntry(HWnd : THandle;
                                   const PhoneBook : string
                                   ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasCreatePhonebookEntry) then
    Result := RasCreatePhonebookEntry(HWnd, AdRasPhoneBook(Phonebook))
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasEditPhonebookEntry(HWnd : THandle;
                                 const Phonebook, EntryName : string
                                 ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasEditPhonebookEntry) then
    Result := RasEditPhonebookEntry(HWnd, AdRasPhoneBook(Phonebook),
      PChar(EntryName))  {let RAS provide error code if EntryName not valid}
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasDeleteEntry(const Phonebook, EntryName : string
                          ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasDeleteEntry) then
    Result := RasDeleteEntry(AdRasPhoneBook(Phonebook), PChar(EntryName))
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasRenameEntry(const Phonebook, EntryOld, EntryNew : string
                          ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasRenameEntry) then
    Result := RasRenameEntry(AdRasPhoneBook(Phonebook),
      PChar(EntryOld), PChar(EntryNew))
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasEnumDevices(PDeviceInfo : PRasDeviceInfo;
                          var DeviceInfoSize : DWord;
                          var NumDevices : DWord
                          ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasEnumDevices) then
    Result := RasEnumDevices(PDeviceInfo, DeviceInfoSize, NumDevices)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasGetCountryInfo(PCountryInfo : PRasCountryInfo;
                             var CountryInfoSize : DWord
                             ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasGetCountryInfo) then
    Result := RasGetCountryInfo(PCountryInfo, CountryInfoSize)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasGetEntryProperties(const Phonebook, EntryName : string;
                                 PEntry : PRasEntry;
                                 var EntrySize : DWord;
                                 PDeviceInfo : PTapiConfigRec;           {!!.06}
                                 var DeviceInfoSize : DWord
                                 ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasGetEntryProperties) then
    Result := RasGetEntryProperties(AdRasPhoneBook(Phonebook),
      PChar(EntryName), PEntry, EntrySize, PDeviceInfo, DeviceInfoSize)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasSetEntryProperties(const Phonebook, EntryName : string;
                                 PEntry : PRasEntry;
                                 var EntrySize : DWord;
                                 PDeviceInfo : PTapiConfigRec;           {!!.06}
                                 var DeviceInfoSize : DWord
                                 ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasSetEntryProperties) then
    Result := RasSetEntryProperties(AdRasPhoneBook(Phonebook),
      PChar(EntryName), PEntry, EntrySize, PDeviceInfo, DeviceInfoSize)
  else
    Result := ecRasFunctionNotSupported;
end;

function AdRasValidateEntryName(const Phonebook, EntryName : string
                                ) : Integer;
begin
  LoadRASDLL;
  if Assigned(RasValidateEntryName) then
    Result := RasValidateEntryName(AdRasPhoneBook(Phonebook),
      PChar(EntryName))
  else
    Result := ecRasFunctionNotSupported;
end;

procedure UnloadRasDLL;
//SZ - introduced - call to unload the RAS dll from memory
//   call this to avoid handle leak if used in a dll
//   do not call this in finalization of a dll
begin
  if (RASModule <> 0) then
    FreeLibrary(RASModule);
  if (RASDlgModule <> 0) then
    FreeLibrary(RASDlgModule);

  RASModule := 0;
  RASDlgModule := 0;
end;

initialization
  RasModule := 0;
  RasDlgModule := 0;
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  if GetVersionEx(VersionInfo) then    // from kernel32.dll
    AdRasPlatformID := VersionInfo.dwPlatformId
  else
    AdRasPlatformID := VER_PLATFORM_WIN32s;

finalization                     //SZ: bugfix Loader Lock Problem!!
  if not IsLibrary then
    UnloadRasDLL;
end.
