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
 *    Sulaiman Mah
 *    Sean B. Durkin
 *    Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADEXCEPT.PAS 5.00                   *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F-,V-,P-,T-,B-}

unit AdExcept;
  {-Apro exceptions}

interface

uses
  Messages,
  Windows,
  SysUtils,
  Classes,
  {$IFNDEF UseResourceStrings}
  AdSrmgr,
  {$ENDIF}
  OoMisc;

{ The design of the string resources has changed for APRO 4.04.  We no longer  }
{ use the string resource manager (AdSrmgr.pas), we now use resourcestrings.   }
{ To use a different language, specify the language below.  Only select one    }
{ language when compiling.  Selecting multiple languages will result in        }
{ duplicate identifiers.  If you need to support multiple langauages, use the  }
{ separate string resource units to create your own language DLLs or other     }
{ techniques. See the comments in the applicable language include file for     }
{ more details (in English).                                                   }


{Select English by default, only one can be enabled at any given time }

{*** English ***}
  {$I AdExcept.inc}
{*** French ***}
  {.$I AdExcept.fra}
{*** German ***}
  {.$I AdExcept.deu}
{*** Spanish ***}
  {.$I AdExcept.esp}
{*** Swedish ***}
  {.$I AdExcept.sw}
{*** Norwegian ***}
  {.$I AdExcept.nor}
{*** Danish ***}
  {.$I AdExcept.dk}


type
  {General Apro exception class}
  EAPDException = class(Exception)
  private
    FErrorCode : Integer;

  public
    constructor Create(const EC : Integer; PassThru : Boolean);
    constructor CreateUnknown(const Msg : String; Dummy : Byte);

    class function MapCodeToStringID(const Code : Integer) : Word;
      {-Return a string table index for Code}

    property ErrorCode : Integer
      read FErrorCode write FErrorCode;
  end;

  {Apro exception groups}
  EGeneral      = class(EAPDException);
  EOpenComm     = class(EAPDException);
  ESerialIO     = class(EAPDException);
  EModem        = class(EAPDException);
  ETrigger      = class(EAPDException);
  EPacket       = class(EAPDException);
  EProtocol     = class(EAPDException);
  EINI          = class(EAPDException);
  EFax          = class(EAPDException);
  ETapi         = class(EAPDException);
  ERas          = class(EAPDException);
  EAdTerminal   = class(EAPDException);
  EXML          = class(EAPDException);
  EStateMachine = class(EAPDException);                                  

  {Specific general exceptions}
  EBadArgument          = class(EGeneral);
  EGotQuitMsg           = class(EGeneral);
  EBufferTooBig         = class(EGeneral);
  EPortNotAssigned      = class(EGeneral);
  EInternal             = class(EGeneral);
  EModemNotAssigned     = class(EGeneral);
  EPhonebookNotAssigned = class(EGeneral);
  ECannotUseWithWinSock = class(EGeneral);                            

  {Specific OpenComm exceptions}
  EBadId                = class(EOpenComm);
  EBaudRate             = class(EOpenComm);
  EByteSize             = class(EOpenComm);
  EDefault              = class(EOpenComm);
  EHardware             = class(EOpenComm);
  EMemory               = class(EOpenComm);
  ECommNotOpen          = class(EOpenComm);
  EAlreadyOpen          = class(EOpenComm);
  ENoHandles            = class(EOpenComm);
  ENoTimers             = class(EOpenComm);
  ENoPortSelected       = class(EOpenComm);
  ENotOpenedByTapi      = class(EOpenComm);                         

  {Specific serial I/O exceptions}
  ENullApi              = class(ESerialIO);
  ERegisterHandlerFailed= class(ESerialIO);
  EPutBlockFail         = class(ESerialIO);
  EGetBlockFail         = class(ESerialIO);
  EOutputBufferTooSmall = class(ESerialIO);
  EBufferIsEmpty        = class(ESerialIO);
  ETracingNotEnabled    = class(ESerialIO);
  ELoggingNotEnabled    = class(ESerialIO);
  EBaseAddressNotSet    = class(ESerialIO);

  {Specific modem exceptions}
  EModemNotStarted      = class(EModem);
  EModemBusy            = class(EModem);
  EModemNotDialing      = class(EModem);
  EModemNotResponding   = class(EModem);
  EModemRejectedCommand = class(EModem);
  EModemStatusMismatch  = class(EModem);

  {Specific dialer exceptions}
  EAlreadyDialing       = class(EModem);
  ENotDialing           = class(EModem);

  EDeviceNotSelected    = class(EModem);
  EModemDetectedBusy    = class(EModem);
  ENoDialtone           = class(EModem);
  ENoCarrier            = class(EModem);
  ENoAnswer             = class(EModem);

  {Specific trigger exceptions}
  ENoMoreTriggers       = class(ETrigger);
  ETriggerTooLong       = class(ETrigger);
  EBadTriggerHandle     = class(ETrigger);

  {Specific packet exceptions}
  EInvalidProperty      = class(EPacket);
  EStringSizeError      = class(EPacket);

  {Specific protocol exceptions}
  ETimeout              = class(EProtocol);
  ETooManyErrors        = class(EProtocol);
  ESequenceError        = class(EProtocol);

  {Specific INI database exceptions}
  EKeyTooLong           = class(EINI);
  EDataTooLarge         = class(EINI);
  EIniWrite             = class(EINI);
  EIniRead              = class(EINI);
  ERecordExists         = class(EINI);
  ERecordNotFound       = class(EINI);
  EDatabaseFull         = class(EINI);
  EDatabaseEmpty        = class(EINI);
  EBadFieldList         = class(EINI);
  EBadFieldForIndex     = class(EINI);

  {.Z+}
  {Specific FAX exceptions}
  EFaxBadFormat         = class(EFax);
  EBadGraphicsFormat    = class(EFax);
  EConvertAbort         = class(EFax);
  EUnpackAbort          = class(EFax);
  ECantMakeBitmap       = class(EFax);
  ENoImageLoaded        = class(EFax);
  ENoImageBlockMarked   = class(EFax);
  EInvalidPageNumber    = class(EFax);

  EFaxBadMachine        = class(EFax);
  EFaxBadModemResult    = class(EFax);
  EFaxTrainError        = class(EFax);
  EFaxInitError         = class(EFax);
  EFaxBusy              = class(EFax);
  EFaxVoiceCall         = class(EFax);
  EFaxDataCall          = class(EFax);
  EFaxNoDialTone        = class(EFax);
  EFaxNoCarrier         = class(EFax);
  EFaxSessionError      = class(EFax);
  EFaxPageError         = class(EFax);

  EAlreadyMonitored     = class(EFax);

  ETapiAllocated                = class(ETapi);
  ETapiBadDeviceID              = class(ETapi);
  ETapiBearerModeUnavail        = class(ETapi);
  ETapiCallUnavail              = class(ETapi);
  ETapiCompletionOverrun        = class(ETapi);
  ETapiConferenceFull           = class(ETapi);
  ETapiDialBilling              = class(ETapi);
  ETapiDialDialtone             = class(ETapi);
  ETapiDialPrompt               = class(ETapi);
  ETapiDialQuiet                = class(ETapi);
  ETapiIncompatibleApiVersion   = class(ETapi);
  ETapiIncompatibleExtVersion   = class(ETapi);
  ETapiIniFileCorrupt           = class(ETapi);
  ETapiInUse                    = class(ETapi);
  ETapiInvalAddress             = class(ETapi);
  ETapiInvalAddressID           = class(ETapi);
  ETapiInvalAddressMode         = class(ETapi);
  ETapiInvalAddressState        = class(ETapi);
  ETapiInvalAppHandle           = class(ETapi);
  ETapiInvalAppName             = class(ETapi);
  ETapiInvalBearerMode          = class(ETapi);
  ETapiInvalCallComplMode       = class(ETapi);
  ETapiInvalCallHandle          = class(ETapi);
  ETapiInvalCallParams          = class(ETapi);
  ETapiInvalCallPrivilege       = class(ETapi);
  ETapiInvalCallSelect          = class(ETapi);
  ETapiInvalCallState           = class(ETapi);
  ETapiInvalCallStatelist       = class(ETapi);
  ETapiInvalCard                = class(ETapi);
  ETapiInvalCompletionID        = class(ETapi);
  ETapiInvalConfCallHandle      = class(ETapi);
  ETapiInvalConsultCallHandle   = class(ETapi);
  ETapiInvalCountryCode         = class(ETapi);
  ETapiInvalDeviceClass         = class(ETapi);
  ETapiInvalDeviceHandle        = class(ETapi);
  ETapiInvalDialParams          = class(ETapi);
  ETapiInvalDigitList           = class(ETapi);
  ETapiInvalDigitMode           = class(ETapi);
  ETapiInvalDigits              = class(ETapi);
  ETapiInvalExtVersion          = class(ETapi);
  ETapiInvalGroupID             = class(ETapi);
  ETapiInvalLineHandle          = class(ETapi);
  ETapiInvalLineState           = class(ETapi);
  ETapiInvalLocation            = class(ETapi);
  ETapiInvalMediaList           = class(ETapi);
  ETapiInvalMediaMode           = class(ETapi);
  ETapiInvalMessageID           = class(ETapi);
  ETapiInvalParam               = class(ETapi);
  ETapiInvalParkID              = class(ETapi);
  ETapiInvalParkMode            = class(ETapi);
  ETapiInvalPointer             = class(ETapi);
  ETapiInvalPrivSelect          = class(ETapi);
  ETapiInvalRate                = class(ETapi);
  ETapiInvalRequestMode         = class(ETapi);
  ETapiInvalTerminalID          = class(ETapi);
  ETapiInvalTerminalMode        = class(ETapi);
  ETapiInvalTimeout             = class(ETapi);
  ETapiInvalTone                = class(ETapi);
  ETapiInvalToneList            = class(ETapi);
  ETapiInvalToneMode            = class(ETapi);
  ETapiInvalTransferMode        = class(ETapi);
  ETapiLineMapperFailed         = class(ETapi);
  ETapiNoConference             = class(ETapi);
  ETapiNoDevice                 = class(ETapi);
  ETapiNoDriver                 = class(ETapi);
  ETapiNoMem                    = class(ETapi);
  ETapiNoRequest                = class(ETapi);
  ETapiNotOwner                 = class(ETapi);
  ETapiNotRegistered            = class(ETapi);
  ETapiOperationFailed          = class(ETapi);
  ETapiOperationUnavail         = class(ETapi);
  ETapiRateUnavail              = class(ETapi);
  ETapiResourceUnavail          = class(ETapi);
  ETapiRequestOverrun           = class(ETapi);
  ETapiStructureTooSmall        = class(ETapi);
  ETapiTargetNotFound           = class(ETapi);
  ETapiTargetSelf               = class(ETapi);
  ETapiUninitialized            = class(ETapi);
  ETapiUserUserInfoTooBig       = class(ETapi);
  ETapiReinit                   = class(ETapi);
  ETapiAddressBlocked           = class(ETapi);
  ETapiBillingRejected          = class(ETapi);
  ETapiInvalFeature             = class(ETapi);
  ETapiNoMultipleInstance       = class(ETapi);

  {Tapi exceptions that don't simply mirror TAPI error codes}
  ETapiBusy                     = class(ETapi);
  ETapiNotSet                   = class(ETapi);
  ETapiNoSelect                 = class(ETapi);
  ETapiLoadFail                 = class(ETapi);
  ETapiGetAddrFail              = class(ETapi);
  ETapiUnexpected               = class(ETapi);
  ETapiVoiceNotSupported        = class(ETapi);
  ETapiWaveFail                 = class(ETapi);
  ETapiTranslateFail            = class(ETapi);

  {VoIP specific errors}
  EVoIPNotSupported             = class(ETapi);

  {Ras exceptions}
  ERasLoadFail                  = class(ERas);

  {Terminal exceptions}
  EAdTerminalClass              = class of EAdTerminal;
  EAdTermRangeError             = class(EAdTerminal);
  EAdTermInvalidParameter       = class(EAdTerminal);
  EAdTermTooLarge               = class(EAdTerminal);

  {TApdPager Exceptions}
  {$M+}
  EApdPagerException = class (Exception)
    private
      FErrorCode : Integer;
    public
      { Parameters to the construtor are reversed to prevent problems with
        C++ Builder }
      constructor Create (const ErrCode : Integer; const Msg : string);
    published
      property ErrorCode : Integer read FErrorCode;
  end;
  {$M-}

  {TApdGSMPhone Exceptions}
  {$M+}
  EApdGSMPhoneException = class (Exception)
    private
      FErrorCode : Integer;
    public
      { Parameters to the construtor are reversed to prevent problems with
        C++ Builder }
      constructor Create (const ErrCode : Integer; const Msg : string);
    published
      property ErrorCode : Integer read FErrorCode;
  end;
  {$M-}

  { XML exceptions }
  {$M+}
  EAdStreamError = class(EXML)
  private
    seFilePos : Longint;
  public
    constructor CreateError(const FilePos : Longint;
                            const Reason  : DOMString);
    property FilePos : Longint
       read seFilePos;
  end;
  {$M-}

  EAdFilterError = class(EAdStreamError)
  private
    feReason  : DOMString;
    feLine    : Longint;
    feLinePos : Longint;
  public
    constructor CreateError(const FilePos, Line, LinePos : Longint;
                            const Reason : DOMString);
    property Reason : DOMString
       read feReason;
    property Line : Longint
       read feLine;
    property LinePos : Longint
       read feLinePos;
  end;

  EAdParserError = class(EAdFilterError)
  protected
  public
    constructor CreateError(Line, LinePos : Longint;
                            const Reason : DOMString);
  end;

  function CheckException(const Ctl : TComponent;
                          const Res : Integer) : Integer;
  function XlatException(const E : Exception) : Integer;
    {-Translate an exception into an error code}

  function AproLoadStr(const ErrorCode : SmallInt) : string;

  function AproLoadZ(P : PAnsiChar; Code : Integer) : PAnsiChar;    // --sm ansi

  function ErrorMsg(const ErrorCode : SmallInt) : string;
  {$IFDEF UseResourceStrings}
  function MessageNumberToString(MessageNumber : SmallInt) : string;
  {$ENDIF}
  {.Z-}


{$IFNDEF UseResourceStrings}
var                                                                      {!!.02}
  AproStrRes : TAdStringResource;                                        {!!.02}
{$ENDIF}
implementation

{$IFDEF UseResourceStrings}
{ include AdStrMap here to prevent circular references in AdStrMap }
uses
  AdStrMap;
{$ENDIF}
  function AproLoadZ(P : PAnsiChar; Code : Integer) : PAnsiChar;
  begin
    {$IFDEF UseResourceStrings}
    Result := StrPCopy(P, AproLoadStr(Code));
    {$ELSE}
    Result := AproStrRes.GetAsciiZ(Abs(Code), P, MaxMessageLen);
    {$ENDIF}
  end;

  function AproLoadStr(const ErrorCode : SmallInt) : string;
    {-Return an error message for ErrorCode}
  begin
    {$IFDEF UseResourceStrings}
    Result := MessageNumberToString(ErrorCode);
    {$ELSE}
    Result := AproStrRes.GetString(abs(ErrorCode));
    {$ENDIF}

    if Result = '' then
      Result := SysErrorMessage(ErrorCode);
  end;

  {Alias for function above}
  function ErrorMsg(const ErrorCode : SmallInt) : string;
    {-Return an error message for ErrorCode}
  begin
    Result := AproLoadStr(ErrorCode);
  end;

  {$IFDEF UseResourceStrings}
  function MessageNumberToString(MessageNumber : SmallInt) : string;
  var
    Middle : integer;
    Min    : integer;
    Max    : integer;
  begin
    Result := '';

    Min := 0;
    Max := AdMaxMessages;
    MessageNumber := abs(MessageNumber);
    while (Min <= Max) do begin
      Middle := Round ((Min + Max) / 2);
      if abs(AdMessageNumberLookup[Middle].MessageNumber) = abs(MessageNumber) then begin
        { found it }
        Result := AdMessageNumberLookup[Middle].MessageString;
        Exit;
      end else if abs(MessageNumber) < abs(AdMessageNumberLookup[Middle].MessageNumber) then
        Max := Middle - 1
      else
        Min := Middle + 1;
    end;

  end;
  {$ENDIF}

  constructor EAPDException.Create(const EC : Integer; PassThru : Boolean);
  begin
    FErrorCode := EC;
    inherited Create(AproLoadStr(Abs(EC)));
  end;

  constructor EAPDException.CreateUnknown(const Msg : String; Dummy : Byte);
  begin
    ErrorCode := 0;

    inherited Create(Msg);
  end;

  class function EAPDException.MapCodeToStringID(const Code : Integer) : Word;
  begin
    Result := Abs(Code);
  end;

  function CheckException(const Ctl : TComponent; const Res : Integer) : Integer;
    {-Check Res, raise appropriate exception if non-zero}
  var
    ErrorMsg : String;
    FileIO   : EInOutError;

  begin
    Result := Res;
    if (Res < ecOk) then
      if not (csLoading in Ctl.ComponentState) then begin
        case Res of
          ecHardwareFailure..ecFileNotFound:
            begin
              {find the error message for the error}
              ErrorMsg := AproLoadStr(Abs(Res));

              {if we've run out of memory, raise that exception}
              if (Res = ecOutOfMemory) then
                OutOfMemoryError

              {otherwise, raise a file I/O exception}
              else begin
                FileIO           := EInOutError.Create(ErrorMsg);
                FileIO.ErrorCode := Abs(Res);
                raise FileIO;
              end;
            end;

          {EGeneral}
          ecBadArgument           : raise EBadArgument.Create(Res, False);
          ecGotQuitMsg            : raise EGotQuitMsg.Create(Res, False);
          ecBufferTooBig          : raise EBufferTooBig.Create(Res, False);
          ecPortNotAssigned       : raise EPortNotAssigned.Create(Res, False);
          ecInternal,
          ecNoFieldsDefined,
          ecNoIndexKey,
          ecDatabaseNotPrepared   : raise EInternal.Create(Res, False);
          ecModemNotAssigned      : raise EModemNotAssigned.Create(Res, False);
          ecPhonebookNotAssigned  : raise EPhonebookNotAssigned.Create(Res, False);
          ecCannotUseWithWinSock  : raise ECannotUseWithWinsock.Create(Res, False);

          {EOpenComm}
          ecBadId                 : raise EBadId.Create(Res, False);
          ecBaudRate              : raise EBaudRate.Create(Res, False);
          ecByteSize              : raise EByteSize.Create(Res, False);
          ecDefault               : raise EDefault.Create(Res, False);
          ecHardware              : raise EHardware.Create(Res, False);
          ecMemory                : raise EMemory.Create(Res, False);
          ecCommNotOpen           : raise ECommNotOpen.Create(Res, False);
          ecAlreadyOpen           : raise EAlreadyOpen.Create(Res, False);
          ecNoHandles             : raise ENoHandles.Create(Res, False);
          ecNoTimers              : raise ENoTimers.Create(Res, False);
          ecNoPortSelected        : raise ENoPortSelected.Create(Res, False);
          ecNotOpenedByTapi       : raise ENotOpenedByTapi.Create(Res, False);

          {ESerialIO}
          ecNullApi               : raise ENullApi.Create(Res, False);
          ecRegisterHandlerFailed : raise ERegisterHandlerFailed.Create(Res, False);
          ecPutBlockFail          : raise EPutBlockFail.Create(Res, False);
          ecGetBlockFail          : raise EGetBlockFail.Create(Res, False);
          ecOutputBufferTooSmall  : raise EOutputBufferTooSmall.Create(Res, False);
          ecBufferIsEmpty         : raise EBufferIsEmpty.Create(Res, False);
          ecTracingNotEnabled     : raise ETracingNotEnabled.Create(Res, False);
          ecLoggingNotEnabled     : raise ELoggingNotEnabled.Create(Res, False);
          ecBaseAddressNotSet     : raise EBaseAddressNotSet.Create(Res, False);

          {EModem}
          ecModemNotStarted       : raise EModemNotStarted.Create(Res, False);
          ecModemBusy             : raise EModemBusy.Create(Res, False);
          ecModemNotDialing       : raise EModemNotDialing.Create(Res, False);
          ecNotDialing            : raise ENotDialing.Create(Res, False);
          ecAlreadyDialing        : raise EAlreadyDialing.Create(Res, False);
          ecModemNotResponding    : raise EModemNotResponding.Create(Res, False);
          ecModemRejectedCommand  : raise EModemRejectedCommand.Create(Res, False);
          ecModemStatusMismatch   : raise EModemStatusMismatch.Create(Res, False);

          {ETrigger}
          ecNoMoreTriggers        : raise ENoMoreTriggers.Create(Res, False);
          ecTriggerTooLong        : raise ETriggerTooLong.Create(Res, False);
          ecBadTriggerHandle      : raise EBadTriggerHandle.Create(Res, False);

          {EProtocol}
          ecTimeout               : raise EProtocol.Create(Res, False);
          ecTooManyErrors         : raise EProtocol.Create(Res, False);
          ecSequenceError         : raise EProtocol.Create(Res, False);

          {EIni}
          ecKeyTooLong            : raise EKeyTooLong.Create(Res, False);
          ecDataTooLarge          : raise EDataTooLarge.Create(Res, False);
          ecIniWrite              : raise EIniWrite.Create(Res, False);
          ecIniRead               : raise EIniRead.Create(Res, False);
          ecRecordExists          : raise ERecordExists.Create(Res, False);
          ecRecordNotFound        : raise ERecordNotFound.Create(Res, False);
          ecDatabaseFull          : raise EDatabaseFull.Create(Res, False);
          ecDatabaseEmpty         : raise EDatabaseEmpty.Create(Res, False);
          ecBadFieldList          : raise EBadFieldList.Create(Res, False);
          ecBadFieldForIndex      : raise EBadFieldForIndex.Create(Res, False);

          {EFax}
          ecFaxBadFormat          : raise EFaxBadFormat.Create(Res, False);
          ecBadGraphicsFormat     : raise EBadGraphicsFormat.Create(Res, False);
          ecConvertAbort          : raise EConvertAbort.Create(Res, False);
          ecUnpackAbort           : raise EUnpackAbort.Create(Res, False);
          ecCantMakeBitmap        : raise ECantMakeBitmap.Create(Res, False);
          ecInvalidPageNumber     : raise EInvalidPageNumber.Create(Res, False);

          ecFaxBadMachine         : raise EFaxBadMachine.Create(Res, False);
          ecFaxBadModemResult     : raise EFaxBadModemResult.Create(Res, False);
          ecFaxTrainError         : raise EFaxTrainError.Create(Res, False);
          ecFaxInitError          : raise EFaxInitError.Create(Res, False);
          ecFaxBusy               : raise EFaxBusy.Create(Res, False);
          ecFaxVoiceCall          : raise EFaxVoiceCall.Create(Res, False);
          ecFaxDataCall           : raise EFaxDataCall.Create(Res, False);
          ecFaxNoDialTone         : raise EFaxNoDialTone.Create(Res, False);
          ecFaxNoCarrier          : raise EFaxNoCarrier.Create(Res, False);
          ecFaxSessionError       : raise EFaxSessionError.Create(Res, False);
          ecFaxPageError          : raise EFaxPageError.Create(Res, False);

          ecAllocated             : raise ETapiAllocated.Create(Res, False);
          ecBadDeviceID           : raise ETapiBadDeviceID.Create(Res, False);
          ecBearerModeUnavail     : raise ETapiBearerModeUnavail.Create(Res, False);
          ecCallUnavail           : raise ETapiCallUnavail.Create(Res, False);
          ecCompletionOverrun     : raise ETapiCompletionOverrun.Create(Res, False);
          ecConferenceFull        : raise ETapiConferenceFull.Create(Res, False);
          ecDialBilling           : raise ETapiDialBilling.Create(Res, False);
          ecDialDialtone          : raise ETapiDialDialtone.Create(Res, False);
          ecDialPrompt            : raise ETapiDialPrompt.Create(Res, False);
          ecDialQuiet             : raise ETapiDialQuiet.Create(Res, False);
          ecIncompatibleApiVersion: raise ETapiIncompatibleApiVersion.Create(Res, False);
          ecIncompatibleExtVersion: raise ETapiIncompatibleExtVersion.Create(Res, False);
          ecIniFileCorrupt        : raise ETapiIniFileCorrupt.Create(Res, False);
          ecInUse                 : raise ETapiInUse.Create(Res, False);
          ecInvalAddress          : raise ETapiInvalAddress.Create(Res, False);
          ecInvalAddressID        : raise ETapiInvalAddressID.Create(Res, False);
          ecInvalAddressMode      : raise ETapiInvalAddressMode.Create(Res, False);
          ecInvalAddressState     : raise ETapiInvalAddressState.Create(Res, False);
          ecInvalAppHandle        : raise ETapiInvalAppHandle.Create(Res, False);
          ecInvalAppName          : raise ETapiInvalAppName.Create(Res, False);
          ecInvalBearerMode       : raise ETapiInvalBearerMode.Create(Res, False);
          ecInvalCallComplMode    : raise ETapiInvalCallComplMode.Create(Res, False);
          ecInvalCallHandle       : raise ETapiInvalCallHandle.Create(Res, False);
          ecInvalCallParams       : raise ETapiInvalCallParams.Create(Res, False);
          ecInvalCallPrivilege    : raise ETapiInvalCallPrivilege.Create(Res, False);
          ecInvalCallSelect       : raise ETapiInvalCallSelect.Create(Res, False);
          ecInvalCallState        : raise ETapiInvalCallState.Create(Res, False);
          ecInvalCallStatelist    : raise ETapiInvalCallStatelist.Create(Res, False);
          ecInvalCard             : raise ETapiInvalCard.Create(Res, False);
          ecInvalCompletionID     : raise ETapiInvalCompletionID.Create(Res, False);
          ecInvalConfCallHandle   : raise ETapiInvalConfCallHandle.Create(Res, False);
          ecInvalConsultCallHandle: raise ETapiInvalConsultCallHandle.Create(Res, False);
          ecInvalCountryCode      : raise ETapiInvalCountryCode.Create(Res, False);
          ecInvalDeviceClass      : raise ETapiInvalDeviceClass.Create(Res, False);
          ecInvalDeviceHandle     : raise ETapiInvalDeviceHandle.Create(Res, False);
          ecInvalDialParams       : raise ETapiInvalDialParams.Create(Res, False);
          ecInvalDigitList        : raise ETapiInvalDigitList.Create(Res, False);
          ecInvalDigitMode        : raise ETapiInvalDigitMode.Create(Res, False);
          ecInvalDigits           : raise ETapiInvalDigits.Create(Res, False);
          ecInvalExtVersion       : raise ETapiInvalExtVersion.Create(Res, False);
          ecInvalGroupID          : raise ETapiInvalGroupID.Create(Res, False);
          ecInvalLineHandle       : raise ETapiInvalLineHandle.Create(Res, False);
          ecInvalLineState        : raise ETapiInvalLineState.Create(Res, False);
          ecInvalLocation         : raise ETapiInvalLocation.Create(Res, False);
          ecInvalMediaList        : raise ETapiInvalMediaList.Create(Res, False);
          ecInvalMediaMode        : raise ETapiInvalMediaMode.Create(Res, False);
          ecInvalMessageID        : raise ETapiInvalMessageID.Create(Res, False);
          ecInvalParam            : raise ETapiInvalParam.Create(Res, False);
          ecInvalParkID           : raise ETapiInvalParkID.Create(Res, False);
          ecInvalParkMode         : raise ETapiInvalParkMode.Create(Res, False);
          ecInvalPointer          : raise ETapiInvalPointer.Create(Res, False);
          ecInvalPrivSelect       : raise ETapiInvalPrivSelect.Create(Res, False);
          ecInvalRate             : raise ETapiInvalRate.Create(Res, False);
          ecInvalRequestMode      : raise ETapiInvalRequestMode.Create(Res, False);
          ecInvalTerminalID       : raise ETapiInvalTerminalID.Create(Res, False);
          ecInvalTerminalMode     : raise ETapiInvalTerminalMode.Create(Res, False);
          ecInvalTimeout          : raise ETapiInvalTimeout.Create(Res, False);
          ecInvalTone             : raise ETapiInvalTone.Create(Res, False);
          ecInvalToneList         : raise ETapiInvalToneList.Create(Res, False);
          ecInvalToneMode         : raise ETapiInvalToneMode.Create(Res, False);
          ecInvalTransferMode     : raise ETapiInvalTransferMode.Create(Res, False);
          ecLineMapperFailed      : raise ETapiLineMapperFailed.Create(Res, False);
          ecNoConference          : raise ETapiNoConference.Create(Res, False);
          ecNoDevice              : raise ETapiNoDevice.Create(Res, False);
          ecNoDriver              : raise ETapiNoDriver.Create(Res, False);
          ecNoMem                 : raise ETapiNoMem.Create(Res, False);
          ecNoRequest             : raise ETapiNoRequest.Create(Res, False);
          ecNotOwner              : raise ETapiNotOwner.Create(Res, False);
          ecNotRegistered         : raise ETapiNotRegistered.Create(Res, False);
          ecOperationFailed       : raise ETapiOperationFailed.Create(Res, False);
          ecOperationUnavail      : raise ETapiOperationUnavail.Create(Res, False);
          ecRateUnavail           : raise ETapiRateUnavail.Create(Res, False);
          ecResourceUnavail       : raise ETapiResourceUnavail.Create(Res, False);
          ecRequestOverrun        : raise ETapiRequestOverrun.Create(Res, False);
          ecStructureTooSmall     : raise ETapiStructureTooSmall.Create(Res, False);
          ecTargetNotFound        : raise ETapiTargetNotFound.Create(Res, False);
          ecTargetSelf            : raise ETapiTargetSelf.Create(Res, False);
          ecUninitialized         : raise ETapiUninitialized.Create(Res, False);
          ecUserUserInfoTooBig    : raise ETapiUserUserInfoTooBig.Create(Res, False);
          ecReinit                : raise ETapiReinit.Create(Res, False);
          ecAddressBlocked        : raise ETapiAddressBlocked.Create(Res, False);
          ecBillingRejected       : raise ETapiBillingRejected.Create(Res, False);
          ecInvalFeature          : raise ETapiInvalFeature.Create(Res, False);
          ecNoMultipleInstance    : raise ETapiNoMultipleInstance.Create(Res, False);
          ecTapiBusy              : raise ETapiBusy.Create(Res, False);
          ecTapiNotSet            : raise ETapiNotSet.Create(Res, False);
          ecTapiNoSelect          : raise ETapiNoSelect.Create(Res, False);
          ecTapiLoadFail          : raise ETapiLoadFail.Create(Res, False);
          ecTapiGetAddrFail       : raise ETapiGetAddrFail.Create(Res, False);
          ecTapiVoiceNotSupported : raise ETapiVoiceNotSupported.Create(Res, False);
          ecTapiWaveFail          : raise ETapiWaveFail.Create(Res, False);
          ecTapiTranslateFail     : raise ETapiTranslateFail.Create(Res, False);

          {ERas}
          ecRasLoadFail           : raise ERasLoadFail.Create(Res, False);

          {Couldn't find error message}
          else                      raise EAPDException.CreateUnknown('Apro exception', 0);
        end;
      end;
  end;

  function XlatException(const E : Exception) : Integer;
    {-Translate an exception into an error code}
  begin
    if (E is EApdException) then
      Result := EApdException(E).ErrorCode
    else if (E is EInOutError) then
      Result := -EInOutError(E).ErrorCode
    else if (E is EOutOfMemory) then
      Result := ecOutOfMemory
    else
      Result := -9999;
  end;

{$IFNDEF UseResourceStrings}
procedure FinalizeUnit; far;
begin
  AproStrRes.Free;
  AproStrRes := nil;
end;

procedure InitializeUnit;
begin
  {$IFDEF Windows}
  AddExitProc(FinalizeUnit);
  {$ENDIF}
  AproStrRes := TAdStringResource.Create(HInstance, 'APRO_ERROR_STRINGS_ENGLISH');
end;
{$ENDIF}

{ EAdStreamError }

constructor EAdStreamError.CreateError(const FilePos: Integer;
  const Reason: DOMString);
begin
  inherited CreateUnknown(Reason, 0);
  seFilePos := FilePos;
end;

{ EAdFilterError }

constructor EAdFilterError.CreateError(const FilePos, Line,
  LinePos: Integer; const Reason: DOMString);
begin
  inherited CreateError(FilePos, Reason);

  feLine := Line;
  feLinePos := LinePos;
  feReason := Reason;
end;

{ EAdParserError }

constructor EAdParserError.CreateError(Line, LinePos: Integer;
  const Reason: DOMString);
begin
  inherited CreateError(FilePos, Line, LinePos, Reason);
end;

{ EApdGSMPhoneException }

constructor EApdGSMPhoneException.Create(const ErrCode: Integer;
                                         const Msg: string);
begin
  inherited Create (Msg);

  FErrorCode := ErrCode;
end;

{ EApdPagerException }

constructor EApdPagerException.Create(const ErrCode: Integer;
                                      const Msg: string);
begin
  inherited Create (Msg);

  FErrorCode := ErrCode;
end;

{$IFNDEF UseResourceStrings}
{ only need these if we're using the string resource manager }
initialization
  InitializeUnit;

  finalization
    FinalizeUnit;

{$ENDIF}

end.
