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
{*                   ADFAXCVT.PAS 4.06                   *}
{*********************************************************}
{* TApdFaxConverter, TApdFaxUnpacker components          *}
{*********************************************************}
{* These components are wrappers around the low-level    *}
{* conversion/unpacking code found in AwFaxCvt.pas       *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F-,V-,P-,T-,B-,I+}

unit AdFaxCvt;
  {-Delphi fax converter components}

interface

uses
  Windows,
  Dialogs,
  SysUtils,
  Classes,
  Graphics,
  Printers,
  Messages,
  ShellAPI,
  Forms,
  Registry,
  IniFiles,
  OoMisc,
  AwFaxCvt,
  AdExcept;

resourcestring
  ApdEcStrNoClipboard = 'Clipboard format not supported';
  ApdEcStrBadFaxFmt   = 'Bad fax format';
  ApdEcStrInvalidPage = 'Invalid page';

type
  TFaxInputDocumentType = (idNone, idText, idTextEx, idTiff, idPcx,
                           idDcx, idBmp, idBitmap, idUser, idShell);

  TFaxCvtOptions    = ( coDoubleWidth, coHalfHeight, coCenterImage,
                        coYield, coYieldOften);
  TFaxCvtOptionsSet = Set of TFaxCvtOptions;

  TFaxResolution = (frNormal, frHigh);
  TFaxWidth      = (fwNormal, fwWide);

  TFaxFont = (ffStandard, ffSmall);

  TFaxStatusEvent = procedure (F : TObject; Starting, Ending : Boolean;
                              PagesConverted, LinesConverted : Integer;
                              BytesConverted, BytesToConvert : Integer;
                              var Abort : Boolean) of object;

  TFaxOutputLineEvent = procedure(F : TObject; Data : PByteArray; Len : Integer;
                                  EndOfPage, MorePages : Boolean) of object;

  TFaxOpenFileEvent  = procedure(F : TObject; FName : String) of object;
  TFaxCloseFileEvent = procedure(F : TObject) of object;
  TFaxReadLineEvent  = procedure(F : TObject; Data : PByteArray; var Len : Integer;
                                 var EndOfPage, MorePages : Boolean) of object;

const
  afcDefInputDocumentType = idNone;
  afcDefFaxCvtOptions     = [coDoubleWidth, coCenterImage, coYield];
  afcDefResolution        = frNormal;
  afcDefFaxCvtWidth       = fwNormal;
  afcDefTopMargin         = 0;
  afcDefLeftMargin        = 50;
  afcDefLinesPerPage      = 60;
  afcDefFaxTabStop        = 4;
  afcDefFontFile          = 'APFAX.FNT';
  afcDefFontType          = ffStandard;

  { 1 minute per page timeout for shell convert }
  afcDefPrintTimeout      : Integer = 60 * 18;

type
  {component for converting data to APF format}
  TApdCustomFaxConverter = class(TApdBaseComponent)
  protected
    {.Z+}
    FInputDocumentType : TFaxInputDocumentType;
    FOptions           : TFaxCvtOptionsSet;
    FResolution        : TFaxResolution;
    FWidth             : TFaxWidth;
    FTopMargin         : Cardinal;
    FLeftMargin        : Cardinal;
    FLinesPerPage      : Cardinal;
    FTabStop           : Cardinal;
    FEnhFont           : TFont;
    FFontType          : TFaxFont;
    FFontFile          : string;
    FDocumentFile      : string;
    FOutFileName       : string;
    FDefUserExtension  : string;
    FStationID         : AnsiString;
    FStatus            : TFaxStatusEvent;
    FOutputLine        : TFaxOutputLineEvent;
    FOpenUserFile      : TFaxOpenFileEvent;
    FCloseUserFile     : TFaxCloseFileEvent;
    FReadUserLine      : TFaxReadLineEvent;
    LastDocType        : TFaxInputDocumentType;
    Data               : PAbsFaxCvt;
    FileOpen           : Boolean;
    PrnCallbackHandle  : HWND;
    FWaitingForShell   : Boolean;
    FResetShellTimer   : Boolean;                                        {!!.01}
    FShellPageCount    : Integer;                                        {!!.01}
    FPadPage           : Boolean;                                        {!!.04}

    procedure CreateData;
      {-Create PAbsFaxCvt record for API layer}
    procedure DestroyData;
      {-Destroy PAbsFaxCvt record for API layer}
    procedure SetCvtOptions(const NewOpts : TFaxCvtOptionsSet);
      {-Set fax converter options}
    procedure SetDocumentFile(const NewFile : string);
      {-Set document file name}
    procedure SetEnhFont(Value: TFont);
      {-Set font for use with the extended text converter}
    procedure ConvertToResolution(const FileName : string;
      NewRes : TFaxResolution);
      {-Converts the FileName to a new resolution, used by the public methods}
    procedure ChangeDefPrinter(UseFax : Boolean);
      {-Change the Default Printer}
    procedure ConvertShell(const FileName : string);
      {-Convert the Shell to APF by sending to Fax Printer using printto or}
      {print changes default printer (ChangeDefPrinter) to send to Fax printer}
    procedure PrnCallback(var Msg: TMessage);
      {-Message handler for printer driver messages}
    procedure SetPadPage(const Value: Boolean);                          {!!.04}
      {-Sets the PadPage flag to pad a text conversion to full-page length}
    {.Z-}

  public
    constructor Create(Owner : TComponent); override;
    destructor Destroy; override;

    {conversion parameters}
    property InputDocumentType : TFaxInputDocumentType
      read FInputDocumentType write FInputDocumentType default afcDefInputDocumentType;
    property Options : TFaxCvtOptionsSet
      read FOptions write SetCvtOptions default afcDefFaxCvtOptions;
    property Resolution : TFaxResolution
      read FResolution write FResolution default afcDefResolution;
    property Width : TFaxWidth
      read FWidth write FWidth default afcDefFaxCvtWidth;
    property TopMargin : Cardinal
      read FTopMargin write FTopMargin default afcDefTopMargin;
    property LeftMargin : Cardinal
      read FLeftMargin write FLeftMargin default afcDefLeftMargin;
    property LinesPerPage : Cardinal
      read FLinesPerPage write FLinesPerPage default afcDefLinesPerPage;
    property TabStop : Cardinal
      read FTabStop write FTabStop default afcDefFaxTabStop;
    property FontFile : string
      read FFontFile write FFontFile;
    property FontType : TFaxFont
      read FFontType write FFontType;
    property EnhFont : TFont
      read FEnhFont write SetEnhFont;
    property DocumentFile : string
      read FDocumentFile write SetDocumentFile;
    property OutFileName : string
      read FOutFileName write FOutFileName;
    property DefUserExtension : string
      read FDefUserExtension write FDefUserExtension;
    property StationID : ANsiString
      read FStationID write FStationID;
    property PadPage : Boolean                                           {!!.04}
      read FPadPage write SetPadPage;                                    {!!.04}

    {events}
    property OnStatus : TFaxStatusEvent
      read FStatus write FStatus;
    property OnOutputLine : TFaxOutputLineEvent
      read FOutputLine write FOutputLine;
    property OnOpenUserFile : TFaxOpenFileEvent
      read FOpenUserFile write FOpenUserFile;
    property OnCloseUserFile : TFaxCloseFileEvent
      read FCloseUserFile write FCloseUserFile;
    property OnReadUserLine : TFaxReadLineEvent
      read FReadUserLine write FReadUserLine;

    {methods}
    procedure ConvertToFile;
      {-Convert the input file into an APF file}
    procedure Convert;
      {-Convert the input file, calling user event for output}
    procedure ConvertBitmapToFile(const Bmp : TBitmap);
      {-Convert a memory bitmap to a file - re-implemented}

    procedure ConvertToHighRes(const FileName : string);
      {-Convert the fax file to high-resolution}
    procedure ConvertToLowRes(const FileName : string);
      {-Convert the fax file to low-resolution}
    procedure OpenFile;
      {-Open the input file}
    procedure CloseFile;
      {-Close the input file}
    procedure GetRasterLine(var Buffer; var BufLen : Integer; var EndOfPage, MorePages : Boolean);
      {-Read a raster line from the input file}
    procedure CompressRasterLine(var Buffer, OutputData; var OutLen : Integer);
      {-Compress a line of raster data into a fax line}
    procedure MakeEndOfPage(var Buffer; var BufLen : Integer);
      {-Put an end of page code into buffer}

    {.Z+}
    {to be overriden}
    procedure Status(const Starting, Ending : Boolean;
                     const PagesConverted, LinesConverted : Integer;
                     const BytesToRead, BytesRead : Integer;
                     var Abort : Boolean); virtual;
      {-Display conversion status}
    procedure OutputLine(var Data; Len : Integer; EndOfPage, MorePages : Boolean); virtual;
      {-Output a compressed data line}
    procedure OpenUserFile(const FName : String); virtual;
      {-For opening documents of type idUser}
    procedure CloseUserFile; virtual;
      {-For closing documents of type idUser}
    procedure ReadUserLine(var Data; var Len : Integer; var EndOfPage, MorePages : Boolean);
      {-For reading raster lines from documents of type idUser}
    {.Z-}
  end;

  TApdFaxConverter = class(TApdCustomFaxConverter)
  published
    property InputDocumentType;
    property Options;
    property Resolution;
    property Width;
    property TopMargin;
    property LeftMargin;
    property LinesPerPage;
    property TabStop;
    property EnhFont;
    property FontFile;
    property FontType;
    property DocumentFile;
    property OutFileName;
    property DefUserExtension;
    property OnStatus;
    property OnOutputLine;
    property OnOpenUserFile;
    property OnCloseUserFile;
    property OnReadUserLine;
  end;

  TUnpackerOptions    = (uoYield, uoAbort);
  TUnpackerOptionsSet = Set of TUnpackerOptions;

  TAutoScaleMode = (asNone, asDoubleHeight, asHalfWidth);

const
  {defaults for unpacker properties}
  afcDefFaxUnpackOptions      = [uoYield];
  afcDefWhitespaceCompression = False;
  afcDefWhitespaceFrom        = 0;
  afcDefWhitespaceTo          = 0;
  afcDefScaling               = False;
  afcDefHorizMult             = 1;
  afcDefHorizDiv              = 1;
  afcDefVertMult              = 1;
  afcDefVertDiv               = 1;
  afcDefAutoScaleMode         = asDoubleHeight;

type
  TUnpackOutputLineEvent = procedure( Sender : TObject; Starting, Ending : Boolean;
                                      Data : PByteArray; Len, PageNum : Integer) of object;
  TUnpackStatusEvent = procedure( Sender : TObject; FName : String; PageNum : Integer;
                                  BytesUnpacked, BytesToUnpack : Integer) of object;

  {component for unpacking APF files into raster lines}
  TApdCustomFaxUnpacker = class(TApdBaseComponent)
  protected
    {.Z+}
    FOptions               : TUnpackerOptionsSet;
    FWhitespaceCompression : Boolean;
    FWhitespaceFrom        : Cardinal;
    FWhitespaceTo          : Cardinal;
    FScaling               : Boolean;
    FHorizMult             : Cardinal;
    FHorizDiv              : Cardinal;
    FVertMult              : Cardinal;
    FVertDiv               : Cardinal;
    FAutoScaleMode         : TAutoScaleMode;
    FInFileName            : String;
    FOutFileName           : String;
    FOutputLine            : TUnpackOutputLineEvent;
    FStatus                : TUnpackStatusEvent;
    Data                   : PUnpackFax;

    procedure CreateData;
      {-Create PUnpackFax record for API layer}
    procedure DestroyData;
      {-Destroy PUnpackFax record for API layer}
    procedure OutputLine( const Starting, Ending : Boolean;
                          const Data : PByteArray; const Len, PageNum : Cardinal); virtual;
    procedure Status( const FName : String; const PageNum : Cardinal;
                      const BytesUnpacked, BytesToUnpack : Integer); virtual;

    {property get/set methods}
    procedure SetHorizMult(const NewHorizMult : Cardinal);
    procedure SetHorizDiv(const NewHorizDiv : Cardinal);
    procedure SetVertMult(const NewVertMult : Cardinal);
    procedure SetVertDiv(const NewVertDiv : Cardinal);
    function GetNumPages : Cardinal;
    function GetFaxResolution : TFaxResolution;
    function GetFaxWidth : TFaxWidth;
    procedure SetInFileName(const NewName : String);
    procedure SetUnpackerOptions(const NewUnpackerOptions: TUnpackerOptionsSet);

    {utility methods}
    function InFNameZ : string;
    function OutFNameZ : string;
    {.Z-}

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure UnpackPage(const Page : Cardinal);
      {-Unpack page number Page}
    procedure UnpackFile;
      {-Unpack all pages in a fax file}
    function UnpackPageToBitmap(const Page : Cardinal) : TBitmap;
      {-Unpack a page of fax into a memory bitmap}
    function UnpackFileToBitmap : TBitmap;
      {-Unpack a fax into a memory bitmap}
    procedure UnpackPageToPcx(const Page : Cardinal);
      {-Unpack a page of a fax into a PCX file}
    procedure UnpackFileToPcx;
      {-Unpack a file to a PCX file}
    procedure UnpackPageToDcx(const Page : Cardinal);
      {-Unpack a page of a fax into a DCX file}
    procedure UnpackFileToDcx;
      {-Unpack a file to a DCX file}
    procedure UnpackPageToTiff(const Page : Cardinal);
      {-Unpack a page of a fax into a TIF file}
    procedure UnpackFileToTiff;
      {-Unpack a file to a TIF file}
    procedure UnpackPageToBmp(const Page : Cardinal);
      {-Unpack a page of a fax into a BMP file}
    procedure UnpackFileToBmp;
      {-Unpack a file to a BMP file}

    procedure ExtractPage(const Page : Cardinal);
      {-Extract a page of a fax into a new fax file}
    {properties}
    property Options : TUnpackerOptionsSet
      read FOptions write SetUnpackerOptions default afcDefFaxUnpackOptions; 
    property WhitespaceCompression : Boolean
      read FWhitespaceCompression write FWhitespaceCompression default afcDefWhitespaceCompression;
    property WhitespaceFrom : Cardinal
      read FWhitespaceFrom write FWhitespaceFrom default afcDefWhitespaceFrom;
    property WhitespaceTo : Cardinal
      read FWhitespaceTo write FWhitespaceTo default afcDefWhitespaceTo;
    property Scaling : Boolean
      read FScaling write FScaling default afcDefScaling;
    property HorizMult : Cardinal
      read FHorizMult write SetHorizMult default afcDefHorizMult;
    property HorizDiv : Cardinal
      read FHorizDiv write SetHorizDiv default afcDefHorizDiv;
    property VertMult : Cardinal
      read FVertMult write SetVertMult default afcDefVertMult;
    property VertDiv : Cardinal
      read FVertDiv write SetVertDiv default afcDefVertDiv;
    property AutoScaleMode : TAutoScaleMode
      read FAutoScaleMode write FAutoScaleMode;
    property InFileName : String
      read FInFileName write SetInFileName;
    property OutFileName : String
      read FOutFileName write FOutFileName;
    property NumPages : Cardinal
      read GetNumPages;
    property FaxResolution : TFaxResolution
      read GetFaxResolution;
    property FaxWidth : TFaxWidth
      read GetFaxWidth;

    {events}
    property OnOutputLine : TUnpackOutputLineEvent
      read FOutputLine write FOutputLine;
    property OnStatus : TUnpackStatusEvent
      read FStatus write FStatus;

    {class functions}
    class function IsAnAPFFile(const FName : string) : Boolean;
  end;

  TApdFaxUnpacker = class(TApdCustomFaxUnpacker)
  published
    property Options;
    property WhitespaceCompression;
    property WhitespaceFrom;
    property WhitespaceTo;
    property Scaling;
    property HorizMult;
    property HorizDiv;
    property VertMult;
    property VertDiv;
    property AutoScaleMode;
    property InFileName;
    property OutFileName;

    property OnOutputLine;
    property OnStatus;
  end;

  EApdAPFGraphicError = class (Exception);

  TApdAPFGraphic = class (TGraphic)
    private
      FCurrentPage : Integer;
      FPages       : TList;
      FFromAPF     : TApdCustomFaxUnpacker;
      FToAPF       : TApdCustomFaxConverter;

    protected
      procedure Draw (ACanvas : TCanvas; const Rect : TRect); override;
      procedure FreeImages;
      function GetEmpty : Boolean; override;
      function GetHeight : Integer; override;
      function GetNumPages : Integer;
      function GetPage (x : Integer) : TBitmap;
      function GetWidth : Integer; override;
      procedure SetCurrentPage (v : Integer);
      procedure SetHeight (v : Integer); override;
      procedure SetPage (x : Integer; v : TBitmap);
      procedure SetWidth (v : Integer); override;

    public
      constructor Create; override;
      destructor Destroy; override;

      procedure Assign (Source : TPersistent); override;
      procedure AssignTo (Dest : TPersistent); override;
      procedure LoadFromClipboardFormat (AFormat : Word; AData : THandle;
                                         APalette : HPALETTE); override;
      procedure LoadFromFile (const Filename : string); override;
      procedure LoadFromStream (Stream: TStream); override;
      procedure SaveToClipboardFormat (var AFormat : Word; var AData : THandle;
                                       var APalette : HPALETTE); override;
      procedure SaveToStream (Stream : TStream); override;
      procedure SaveToFile (const Filename : string); override;

      property Page[x : Integer] : TBitmap read GetPage write SetPage; 

    published
      property CurrentPage : Integer read FCurrentPage write SetCurrentPage;
      property NumPages : Integer read GetNumPages;

  end;
  
implementation

uses
  AnsiStrings;

{TApdCustomFaxConverter}

  function StatusCallback(Cvt : PAbsFaxCvt; StatFlags : Word;
    BytesRead, BytesToRead : Integer) : Bool; far;
  var
    Abort : Boolean;

  begin
    Abort := False;
    TApdCustomFaxConverter(Cvt^.OtherData).Status(
      (StatFlags and csStarting) <> 0, (StatFlags and csEnding) <> 0,
      Cvt^.CurrPage, Cvt^.CurrLine, Cvt^.BytesRead, Cvt^.BytesToRead, Abort);
    Result := Abort;
  end;

  function OutputCallback(Cvt : PAbsFaxCvt; var Data; Len : Integer;
                          EndOfPage, MorePages : Bool) : Integer; far;
  begin
    try
      TApdCustomFaxConverter(Cvt^.OtherData).OutputLine(
        Data, Len, EndOfPage, MorePages);
      Result := ecOK;
    except
      on E : Exception do begin
        Result := XlatException(E);
      end;
    end;
  end;

  function OpenFileCallback(Cvt : PAbsFaxCvt; FileName : string) : Integer; far;
  begin
    try
      TApdCustomFaxConverter(Cvt^.OtherData).OpenUserFile(FileName);
      Result := ecOK;
    except
      on E : Exception do begin
        Result := XlatException(E);
      end;
    end;
  end;

  function ReadLineCallback(Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                            var EndOfPage, MorePages : Bool) : Integer; far;
  var
    EP : Boolean;
    MP : Boolean;

  begin
    try
      TApdCustomFaxConverter(Cvt^.OtherData).ReadUserLine(Data, Len, EP, MP);
      EndOfPage := EP;
      MorePages := MP;
      Result    := ecOK;
    except
      on E : Exception do begin
        Result := XlatException(E);
      end;
    end;
  end;

  procedure CloseFileCallback(Cvt : PAbsFaxCvt); far;
  begin
    TApdCustomFaxConverter(Cvt^.OtherData).CloseUserFile;
  end;

  procedure TApdCustomFaxConverter.CreateData;
    {-Create PAbsFaxCvt record for API layer}
  const
    FontHandles : array[TFaxFont] of Cardinal = (StandardFont, SmallFont);
    ResWidths   : array[TFaxWidth] of Cardinal = (rw1728, rw2048);

  var
    Opt  : Word;
    Temp : array[0..255] of AnsiChar;

  begin
    {destroy old data, if necessary}
    if Assigned(Data) then
      DestroyData;

    LastDocType := InputDocumentType;


    {create the proper type of converter}
    case InputDocumentType of
      idText  : fcInitTextConverter(Data);
      idTextEx: fcInitTextExConverter(Data);
      idTiff  : tcInitTiffConverter(Data);
      idPcx   : pcInitPcxConverter(Data);
      idDcx   : dcInitDcxConverter(Data);
      idBmp   : bcInitBmpConverter(Data);
      idBitmap: bcInitBitmapConverter(Data);
      idUser  : acInitFaxConverter(Data, nil, ReadLineCallback,
                                          OpenFileCallback, CloseFileCallback,
                                          DefUserExtension);
    end;

    {set converter options}
    acSetOtherData(Data, Self);
    Opt := 0;
    if coDoubleWidth in Options then
      Opt := Opt or fcDoubleWidth;
    if coHalfHeight in Options then
      Opt := Opt or fcHalfHeight;
    if coCenterImage in Options then
      Opt := Opt or fcCenterImage;
    if coYield in Options then
      Opt := Opt or fcYield;
    if coYieldOften in Options then
      Opt := Opt or fcYieldOften;
    acOptionsOff(Data, $FFFF);
    acOptionsOn(Data, Opt);
    acSetMargins(Data, LeftMargin, TopMargin);
    acSetResolutionMode(Data, (Resolution = frHigh));
    acSetResolutionWidth(Data, ResWidths[Width]);
    acSetStationID(Data, StationID);
    acSetStatusCallback(Data, StatusCallback);

    {set text converter specific options}
    Data.PadPage := FPadPage;                                            {!!.04}
    if (InputDocumentType = idText) then begin
      fcSetTabStop(Data, TabStop);
      fcSetLinesPerPage(Data, LinesPerPage);
      CheckException(Self, fcLoadFont(Data, AnsiStrings.StrPCopy(Temp, AnsiString(FontFile)),
        FontHandles[FontType], (Resolution = frHigh)));
    end;
    if (InputDocumentType = idTextEx) then begin
      fcSetTabStop(Data, TabStop);
      fcSetLinesPerPage(Data, LinesPerPage);
      fcSetFont(Data, FEnhFont, (Resolution = frHigh));
    end;
  end;

  procedure TApdCustomFaxConverter.DestroyData;
    {-Destroy PAbsFaxCvt record for API layer}
  begin
    case LastDocType of
      idText  : fcDoneTextConverter(Data);
      idTextEx: fcDoneTextExConverter(Data);                         
      idTiff  : tcDoneTiffConverter(Data);
      idPcx   : pcDonePcxConverter(Data);
      idDcx   : dcDoneDcxConverter(Data);
      idBmp   : bcDoneBmpConverter(Data);
      idBitmap: bcDoneBitmapConverter(Data);
      idUser  : acDoneFaxConverter(Data); 
    end;

    Data := nil;
  end;

  procedure TApdCustomFaxConverter.SetCvtOptions(const NewOpts : TFaxCvtOptionsSet);
    {-Set fax converter options}
  begin
    if (NewOpts = FOptions) then
      Exit;

    FOptions := NewOpts;
    if (coYieldOften in FOptions) and not (coYield in FOptions) then
      FOptions := FOptions + [coYield];
  end;

  procedure TApdCustomFaxConverter.SetDocumentFile(const NewFile : string);
    {-Set document file name}
  begin
    if (NewFile <> FDocumentFile) then begin
      FDocumentFile := NewFile;
      if (FDocumentFile <> '') and not (csLoading in ComponentState) then
        FOutFileName  := ChangeFileExt(FDocumentFile, '.' + DefApfExt);
    end;
  end;

  procedure TApdCustomFaxConverter.SetEnhFont(Value: TFont);
    {-Set font for use with extended text converter}
  begin
    FEnhFont.Assign(Value);
  end;                                                               

  constructor TApdCustomFaxConverter.Create(Owner : TComponent);
  begin
    inherited Create(Owner);

    {set default property values}
    FInputDocumentType := afcDefInputDocumentType;
    FOptions           := afcDefFaxCvtOptions;
    FResolution        := afcDefResolution;
    FWidth             := afcDefFaxCvtWidth;
    FTopMargin         := afcDefTopMargin;
    FLeftMargin        := afcDefLeftMargin;
    FLinesPerPage      := afcDefLinesPerPage;
    FTabStop           := afcDefFaxTabStop;
    FEnhFont           := TFont.Create;
    FFontType          := afcDefFontType;
    FFontFile          := afcDefFontFile;
    FDocumentFile      := '';
    FOutFileName       := '';
    FDefUserExtension  := '';
    FStatus            := nil;
    FOpenUserFile      := nil;
    FCloseUserFile     := nil;
    FReadUserLine      := nil;
    Data               := nil;
    FileOpen           := False;
    LastDocType        := idNone;
    FPadPage           := False;                                         {!!.04}
    { create the window handle so we can receive printer callbacks }
    PrnCallbackHandle := AllocateHWnd(PrnCallback);
  end;

  destructor TApdCustomFaxConverter.Destroy;
  begin
    FEnhFont.Free;
    if PrnCallbackHandle <> 0 then                                       {!!.02}
      DeallocateHWnd(PrnCallbackHandle);                                 {!!.02}
    inherited Destroy;

    if Assigned(Data) then
      DestroyData;
  end;

  procedure TApdCustomFaxConverter.ConvertToFile;
    {-Convert the input file into an APF file}
  begin
    if (InputDocumentType = idNone) or (InputDocumentType = idBitmap) then
      CheckException(Self, ecBadArgument);
    if InputDocumentType = idShell then
      ConvertShell(FDocumentFile)
    else begin
      CreateData;
      CheckException(Self, acConvertToFile(Data,
        FDocumentFile, FOutFileName));
    end;
  end;

  procedure TApdCustomFaxConverter.ConvertBitmapToFile(const Bmp : TBitmap);
    {-Convert a memory bitmap to a file}
  var
    SaveType             : TFaxInputDocumentType;
  begin
    SaveType          := InputDocumentType;
    InputDocumentType := idBitmap;
    CreateData;
    try
      Data^.InBitmap := Bmp;
      CheckException(Self, bcSetInputBitmap(Data, 0));
      CheckException(Self, acConvertToFile(Data,
        FDocumentFile, FOutFileName));
    finally
      DestroyData;
      InputDocumentType := SaveType;
    end;
  end;

  procedure TApdCustomFaxConverter.OpenFile;
    {-Open the input file}
  begin
    if (InputDocumentType = idNone) then
      CheckException(Self, ecBadArgument);
    if FileOpen then
      CloseFile;

    FileOpen := True;
    CreateData;
    CheckException(Self, acOpenFile(Data, FDocumentFile));
  end;

  procedure TApdCustomFaxConverter.CloseFile;
    {-Close the input file}
  begin
    if not FileOpen then
      Exit;

    acCloseFile(Data);
    FileOpen := False;
  end;

  procedure TApdCustomFaxConverter.GetRasterLine(var Buffer; var BufLen : Integer; var EndOfPage, MorePages : Boolean);
    {-Read a raster line from the input file}
  var
    TempEOP, TempMP : Bool;

  begin
    if not FileOpen then
      OpenFile;

    try
      CheckException(Self, acGetRasterLine(Data, Buffer, BufLen, TempEOP, TempMP));
    except
      FileOpen := False;
      raise;
    end;
    EndOfPage := TempEOP;
    MorePages := TempMP;
  end;

  procedure TApdCustomFaxConverter.CompressRasterLine(var Buffer, OutputData; var OutLen : Integer);
    {-Compress a line of raster data into a fax line}
  begin
    if not Assigned(Data) then
      CreateData;
    acCompressRasterLine(Data, Buffer);
    Move(Data^.DataLine^, OutputData, Data^.ByteOfs);
    OutLen := Data^.ByteOfs;
  end;

  procedure TApdCustomFaxConverter.MakeEndOfPage(var Buffer; var BufLen : Integer);
    {-Put an end of page code into buffer}
  begin
    if not Assigned(Data) then
      CreateData;
    acMakeEndOfPage(Data, Buffer, BufLen);
  end;

  procedure TApdCustomFaxConverter.Convert;
    {-Convert the input file, calling user event for output}
  begin
    if (InputDocumentType = idNone) or (InputDocumentType = idBitmap) then
      CheckException(Self, ecBadArgument);
    CreateData;
    CheckException(Self, acConvert(Data,
      FDocumentFile, OutputCallback));
  end;

  procedure TApdCustomFaxConverter.Status( const Starting, Ending : Boolean;
                                           const PagesConverted, LinesConverted : Integer;
                                           const BytesToRead, BytesRead : Integer;
                                           var Abort : Boolean);
    {-Display conversion status}
  begin
    if Assigned(FStatus) then
      FStatus(Self, Starting, Ending, PagesConverted, LinesConverted, BytesToRead, BytesRead, Abort)
    else
      Abort := False;
  end;

  procedure TApdCustomFaxConverter.OutputLine(var Data; Len : Integer; EndOfPage, MorePages : Boolean);
    {-Output a compressed data line}
  begin
    if Assigned(FOutputLine) then
      FOutputLine(Self, PByteArray(@Data), Len, EndOfPage, MorePages);
  end;

  procedure TApdCustomFaxConverter.OpenUserFile(const FName : String);
    {-For opening documents of type idUser}
  begin
    if Assigned(FOpenUserFile) then
      FOpenUserFile(Self, FName);
  end;

  procedure TApdCustomFaxConverter.CloseUserFile;
    {-For closing documents of type idUser}
  begin
    if Assigned(FCloseUserFile) then
      FCloseUserFile(Self);
  end;

  procedure TApdCustomFaxConverter.ReadUserLine(var Data; var Len : Integer; var EndOfPage, MorePages : Boolean);
    {-For reading raster lines from documents of type idUser}
  begin
    if Assigned(FReadUserLine) then
      FReadUserLine(Self, PByteArray(@Data), Len, EndOfPage, MorePages)
    else begin
      EndOfPage := True;
      MorePages := False;
    end;
  end;

procedure TApdCustomFaxConverter.ConvertToHighRes(const FileName: string);
begin
  ConvertToResolution(FileName, frHigh);
end;

procedure TApdCustomFaxConverter.ConvertToLowRes(const FileName: string);
begin
  ConvertToResolution(FileName, frNormal);
end;

procedure TApdCustomFaxConverter.ConvertToResolution(const FileName: string;
  NewRes: TFaxResolution);
var
  Unpacker : TApdCustomFaxUnpacker;
  OldRes : TFaxResolution;
  BMP : TBitmap;
  PageNum : Integer;
  I : Integer;
  DestFile, SourceFile : TFileStream;
  DestHeader, SourceHeader : TFaxHeaderRec;
  FaxList : TStringList;
  Temp       : TPathCharArray;
  TempDir    : TPathCharArray;
begin
  { we'll take the APF, convert the pages to TBitmaps with the ApdFaxUnpacker,
    convert the bitmaps to standard-res APFs withe the ApdFaxConverter, then
    concatenate the individual APF pages with the ApdSendFax }
  OldRes := Resolution;
  Unpacker := nil;
  FaxList := nil;
  try
    Unpacker := TApdCustomFaxUnpacker.Create(nil);
    Unpacker.InFileName := FileName;
    Unpacker.Scaling:=True;
    Unpacker.HorizDiv := 1;
    Unpacker.HorizMult := 1;
    Unpacker.VertDiv := 2;
    Unpacker.VertMult := 1;

    Resolution := NewRes;

    { determine where we will put the temp files }
    GetTempPath(Length(TempDir), TempDir);

    { extract the pages to individual APFs to preserve the page breaks }
    FaxList := TStringList.Create;
    FaxList.Clear;
    for PageNum := 1 to Unpacker.NumPages do begin
      BMP := Unpacker.UnpackPageToBitmap(PageNum);
      GetTempFileName(TempDir, '~APF', PageNum, Temp);
      OutFileName := StrPas(Temp);
      ConvertBitmapToFile(BMP);
      BMP.Free;
      FaxList.Add(OutFileName);
    end;

    { concatenate the temp files into the new one }
    { Create temp file }
    DestFile := TFileStream.Create(FileName, fmCreate or fmShareExclusive);
    try
      { Open first source file }
      SourceFile := TFileStream.Create(FaxList[0], fmOpenRead or fmShareDenyWrite);
      try
        { Read header of the first APF }
        SourceFile.ReadBuffer(DestHeader, SizeOf(DestHeader));
        if (DestHeader.Signature <> DefAPFSig) then
          raise EFaxBadFormat.Create(ecFaxBadFormat, False);
        { Copy first source file to dest }
        DestFile.CopyFrom(SourceFile, 0);
        SourceFile.Free;
        SourceFile := nil;
        { Append remaining files in the list }
        for I := 1 to Pred(FaxList.Count) do begin
          SourceFile := TFileStream.Create(FaxList[I], fmOpenRead or fmShareDenyWrite);
          SourceFile.ReadBuffer(SourceHeader, SizeOf(SourceHeader));
          if (SourceHeader.Signature <> DefAPFSig) then
            raise EFaxBadFormat.Create(ecFaxBadFormat, False);
          DestFile.CopyFrom(SourceFile, SourceFile.Size - SizeOf(SourceHeader));
          DestHeader.PageCount := DestHeader.PageCount + SourceHeader.PageCount;
          SourceFile.Free;
          SourceFile := nil;
        end;
        DestFile.Position := 0;
        DestFile.WriteBuffer(DestHeader, SizeOf(DestHeader));
      finally
        SourceFile.Free;
      end;
    finally
      DestFile.Free;
    end;

    { we're done with the temp files, delete them }
    for PageNum := 0 to FaxList.Count - 1 do
      DeleteFile(FaxList[PageNum]);
  finally
    Unpacker.Free;
    FaxList.Free;
  end;
  Resolution := OldRes;
end;


{ Change the default printer if printto don't work, but}
{      print does work to convert to APF }
procedure TApdCustomFaxConverter.ChangeDefPrinter(UseFax: Boolean);
const
  DefPrn : string = '';
var
  Device, Name, Port : array[0..255] of char;
  DevMode : THandle;
  N, Last : integer;
begin
  { Check to make sure default printer is not already changed }
  with Printer do begin
    if UseFax then begin
    { find one of our printers }
     DefPrn := Printer.Printers[Printer.PrinterIndex];
     Last := Printer.Printers.Count - 1;
     for N := 0 to Last do begin
       Printer.PrinterIndex := N;
       Printer.GetPrinter(Device, Name, Port, Devmode);
       Printer.SetPrinter(Device, Name, Port, Devmode);
       if Device = 'APF Fax Printer' then begin
         { get the required info }
         Printer.GetPrinter(Device, Name, Port, DevMode);
         { concatenate the strings }
         StrCat(Device, ',');
         StrCat(Device, Name);
         StrCat(Device, ',');
         StrCat(Device, Port);
         { write the string to the ini/registry }
         WriteProfileString( 'Windows', 'Device', Device );
         StrCopy(Device, 'Windows' );
         { tell everyone that we've changed the default }
         SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, Integer(@Device));
         { make the TPrinter use the device capabilities of the new default}
         SetPrinter(Device, Name, Port, 0);
       end;
     end;
    end else begin
      { revert back to the original }
      N := Printer.Printers.IndexOf(DefPrn);
      Printer.PrinterIndex := N;
      Printer.GetPrinter(Device, Name, Port, DevMode);
      { concatenate the strings }
      StrCat(Device, ',');
      StrCat(Device, Name);
      StrCat(Device, ',');
      StrCat(Device, Port);
      { write the string to the ini/registry }
      WriteProfileString( 'Windows', 'Device', Device );
      StrCopy(Device, 'Windows' );
      { tell everyone that we've changed the default }
      SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, Integer(@Device));
    end;
  end;
end;

procedure TApdCustomFaxConverter.ConvertShell(const FileName: string);
  { print the selected document to the fax printer driver using ShellExecute }
var
  pFileName : array[0..255] of char;
  pPrinterName : array[0..255] of char;
  Res : Integer;
  Reg : TRegistry;
  Ini : TIniFile;
  ET : EventTimer;
  DefPrnChanged : Boolean;
  DummyBool : Boolean;
begin
  if IsWinNT then begin                                                  {!!.01}
    if Printer.Printers.IndexOf(ApdDef32PrinterName) = -1 then           {!!.01}
      raise Exception.Create('printer not installed');                   {!!.01}
  end else begin                                                         {!!.01}
    { Win9x TPrinter uses "printer name" + on + "printer port" }         {!!.01}
    if Printer.Printers.IndexOf(ApdDef16PrinterName + ' on ' +           {!!.01}
      ApdDefPrinterPort + ':') = -1 then                                 {!!.01}
      raise Exception.Create('printer not installed');                   {!!.01}
  end;                                                                   {!!.01}
  DefPrnChanged := False;
  try
    StrPCopy(pFileName, FileName);
    { write out shell info to the registry/ini file so the printer driver can }
    { get to it. Info is deleted from registry/ini by the printer driver }
    if IsWinNT then begin
      { NT/2K has a 32-bit printer driver, we'll use the registry }
      pPrinterName := '"' + ApdDef32PrinterName + '" " " "' +            {!!.02}
        ApdDefPrinterPort + '"';
      { add our shell keys to the registry }
      Reg := TRegistry.Create;
      try
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        Reg.OpenKey(ApdRegKey, True);
        Reg.WriteInteger('ShellHandle', PrnCallbackHandle);
        Reg.WriteString('ShellName', FOutFileName);
      finally
        Reg.CloseKey;
        Reg.Free;
      end;
    end else begin
      { Win9x/ME has a 16-bit printer driver, we'll use a ini file }
      pPrinterName := '"' + ApdDef16PrinterName + '" " " "' +            {!!.02}
        ApdDefPrinterPort + '"';
      { add our shell keys to our ini file }
      Ini := TIniFile.Create(ApdIniFileName);
      try
        Ini.WriteInteger(ApdIniSection, 'ShellHandle', PrnCallbackHandle);
        Ini.WriteString(ApdIniSection, 'ShellName', FOutFileName);
        Ini.UpdateFile;
      finally
        Ini.Free;
      end;
    end;

    {Try 'printto', if error, change default printer}
    FWaitingForShell := True;
    FResetShellTimer := False;                                           {!!.01}
    FShellPageCount := 0;                                                {!!.01}
    Status(True, False, FShellPageCount, 0, 0, 0, DummyBool);            {!!.01}
    Res := ShellExecute(0, 'printto', pFileName, pPrinterName, '', SW_HIDE);
    if Res <= 32 then begin                                              {!!.01}
      ChangeDefPrinter(True);                                            {!!.01}
      DefPrnChanged := True;                                             {!!.01}
      Res := ShellExecute(0, 'print', pFileName, '', '',                 {!!.01}
        SW_SHOWMINNOACTIVE);                                             {!!.01}
    end;                                                                 {!!.01}
    { wait for the print job to complete }                               {!!.01}
    if Res > 32 then begin
      NewTimer(ET, afcDefPrintTimeout);
      repeat
        Res := SafeYield;                                                {!!.01}
        if FResetShellTimer then begin                                   {!!.01}
          NewTimer(ET, afcDefPrintTimeout);                              {!!.01}
          FResetShellTimer := False;                                     {!!.01}
        end;                                                             {!!.01}
      until not(FWaitingForShell) or (Res = wm_Quit) or TimerExpired(ET);
      if TimerExpired(ET) then
        raise ETimeout.Create(ecTimeout, False);                         {!!.01}
    end;                                                                 {!!.01}
  finally
    if DefPrnChanged then                                                {!!.01}
      ChangeDefPrinter(False);                                           {!!.01}
    Status(False, True, FShellPageCount, 0, 0, 0, DummyBool);            {!!.01}
    { remove the registry/ini keys, just in case the printer driver }
    { failed to do so }
    if IsWinNT then begin                                                {!!.06}
      Reg := TRegistry.Create;                                           {!!.06}
      try                                                                {!!.06}
        Reg.RootKey := HKEY_LOCAL_MACHINE;                               {!!.06}
        Reg.OpenKey(ApdRegKey,False);                                    {!!.06}
        Reg.DeleteValue('ShellName');                                    {!!.06}
        Reg.DeleteValue('ShellHandle');                                  {!!.06}
      finally                                                            {!!.06}
        Reg.Free;                                                        {!!.06}
      end;                                                               {!!.06}
    end else begin                                                       {!!.06}
      Ini := TIniFile.Create(ApdIniFileName);                            {!!.06}
      try                                                                {!!.06}
        Ini.DeleteKey(ApdIniSection, 'ShellHandle');                     {!!.06}
        Ini.DeleteKey(ApdIniSection, 'ShellName');                       {!!.06}
        Ini.UpdateFile;                                                  {!!.06}
      finally                                                            {!!.06}
        Ini.Free;                                                        {!!.06}
      end;                                                               {!!.06}
    end;                                                                 {!!.06}
  end;                                                                   {!!.01}
end;

procedure TApdCustomFaxConverter.PrnCallback(var Msg: TMessage);
var
 DummyBool : Boolean;
begin
  with Msg do begin
    case Msg of                                                          {!!.01}
      apw_EndDoc  : FWaitingForShell := False;                           {!!.01}
      apw_EndPage :
        begin
          FResetShellTimer := True;                                      {!!.01}
          { generate a status event }                                    {!!.01}
          inc(FShellPageCount);                                          {!!.01}
          Status(False, False, FShellPageCount, 0, 0, 0, DummyBool);     {!!.01}
        end;

    else                                                                 {!!.01}
      Result := DefWindowProc(PrnCallbackHandle, Msg, wParam, lParam);
    end;                                                                 {!!.01}
  end;
end;

procedure TApdCustomFaxConverter.SetPadPage(const Value: Boolean);       {!!.04}
begin
  FPadPage := Value;
  if Assigned(Data) then
    Data.PadPage := FPadPage;
end;

{TApdCustomFaxUnpacker}

  function UnpackCallback(Unpack : PUnpackFax; plFlags : Word; var Data; Len,
                          PageNum : Cardinal) : Integer;
  begin
    Result := ecOK;
    try
      TApdCustomFaxUnpacker(Unpack^.UserData).OutputLine(
        (plFlags and upStarting) <> 0, (plFlags and upEnding) <> 0,
        @Data, Len, PageNum);
    except
      on E : Exception do
        Result := XlatException(E);
    end;
  end;

  procedure UnpackStatusCallback(Unpack : PUnpackFax; FaxFile : string; PageNum : Cardinal;
                                 BytesUnpacked, BytesToUnpack : Integer);
  begin
    TApdCustomFaxUnpacker(Unpack^.UserData).Status(
      FaxFile, PageNum, BytesUnpacked, BytesToUnpack);
  end;

  procedure TApdCustomFaxUnpacker.CreateData;
    {-Create PUnpackFax record for API layer}
  var
    HMult : Cardinal;
    HDiv  : Cardinal;
    VMult : Cardinal;
    VDiv  : Cardinal;

  begin
    if Assigned(Data) then
      DestroyData;

    CheckException(Self, upInitFaxUnpacker(Data, Self, UnpackCallback));

    upSetStatusCallback(Data, UnpackStatusCallback);

    upOptionsOff(Data, $FFFF);
    if uoYield in FOptions then
      upOptionsOn(Data, ufYield)
    else
      upOptionsOff(Data, ufYield);
    if (FAutoScaleMode = asDoubleHeight) then
      upOptionsOn(Data, ufAutoDoubleHeight)
    else if (FAutoScaleMode = asHalfWidth) then
      upOptionsOn(Data, ufAutoHalfWidth);

    if FWhitespaceCompression then
      CheckException(Self, upSetWhitespaceCompression(Data, FWhitespaceFrom, FWhitespaceTo));

    if FScaling then begin
      if (FHorizMult = 0) then
        HMult := 1
      else
        HMult := FHorizMult;
      if (FHorizDiv = 0) then
        HDiv := 1
      else
        HDiv := FHorizDiv;
      if (FVertMult = 0) then
        VMult := 1
      else
        VMult := FVertMult;
      if (FVertDiv = 0) then
        VDiv := 1
      else
        VDiv := FVertDiv;
      upSetScaling(Data, HMult, HDiv, VMult, VDiv);
    end;
  end;

  procedure TApdCustomFaxUnpacker.DestroyData;
    {-Destroy PUnpackFax record for API layer}
  begin
    upDoneFaxUnpacker(Data);
    Data := nil;
  end;

  procedure TApdCustomFaxUnpacker.OutputLine( const Starting, Ending : Boolean;
                       const Data : PByteArray; const Len, PageNum : Cardinal);
  begin
    if Assigned(FOutputLine) then
      FOutputLine(Self, Starting, Ending, Data, Len, PageNum);
  end;

  procedure TApdCustomFaxUnpacker.Status( const FName : String; const PageNum : Cardinal;
                                          const BytesUnpacked, BytesToUnpack : Integer);
  begin
    if Assigned(FStatus) then
      FStatus(Self, FName, PageNum, BytesUnpacked, BytesToUnpack);
  end;

  procedure TApdCustomFaxUnpacker.SetHorizMult(const NewHorizMult : Cardinal);
  begin
    if (NewHorizMult <> 0) and (FHorizMult <> NewHorizMult) then
      FHorizMult := NewHorizMult;
  end;

  procedure TApdCustomFaxUnpacker.SetHorizDiv(const NewHorizDiv : Cardinal);
  begin
    if (NewHorizDiv <> 0) and (FHorizDiv <> NewHorizDiv) then
      FHorizDiv := NewHorizDiv;
  end;

  procedure TApdCustomFaxUnpacker.SetVertMult(const NewVertMult : Cardinal);
  begin
    if (NewVertMult <> 0) and (FVertMult <> NewVertMult) then
      FVertMult := NewVertMult;
  end;

  procedure TApdCustomFaxUnpacker.SetVertDiv(const NewVertDiv : Cardinal);
  begin
    if (NewVertDiv <> 0) and (FVertDiv <> NewVertDiv) then
      FVertDiv := NewVertDiv;
  end;

  function TApdCustomFaxUnpacker.GetNumPages : Cardinal;
  var
    FH : TFaxHeaderRec;

  begin
    CreateData;
    upGetFaxHeader(Data, InFNameZ, FH);
    Result := FH.PageCount;
  end;

  function TApdCustomFaxUnpacker.GetFaxResolution : TFaxResolution;
  var
    PH : TPageHeaderRec;

  begin
    CreateData;
    CheckException(Self, upGetPageHeader(Data, InFNameZ, 1, PH));
    if ((PH.ImgFlags and ffHighRes) <> 0) then
      Result := frHigh
    else
      Result := frNormal;
  end;

  function TApdCustomFaxUnpacker.GetFaxWidth : TFaxWidth;
  var
    PH : TPageHeaderRec;

  begin
    CreateData;
    CheckException(Self, upGetPageHeader(Data, InFNameZ, 1, PH));
    if ((PH.ImgFlags and ffHighWidth) <> 0) then
      Result := fwWide
    else
      Result := fwNormal;
  end;

  procedure TApdCustomFaxUnpacker.SetInFileName(const NewName : String);
  begin
    if (UpperCase(FInFileName) <> UpperCase(NewName)) then begin
      FInFileName := NewName;
      FOutFileName := ChangeFileExt(FInFileName, '');
    end;
  end;

  procedure TApdCustomFaxUnpacker.SetUnpackerOptions(const NewUnpackerOptions: TUnpackerOptionsSet);
  begin
    if Assigned(Data) then begin
      if uoYield in NewUnpackerOptions then
        upOptionsOn(Data, ufYield)
      else
        upOptionsOff(Data, ufYield);

      if uoAbort in NewUnpackerOptions then
        upOptionsOn(Data, ufAbort);
    end;

    FOptions := NewUnpackerOptions;
  end;


  function TApdCustomFaxUnpacker.InFNameZ : string;
  begin
    Result := FInFileName;
  end;

  function TApdCustomFaxUnpacker.OutFNameZ : string;
  begin
    Result := FOutFileName;
  end;

  constructor TApdCustomFaxUnpacker.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);

    FOptions               := afcDefFaxUnpackOptions;
    FWhitespaceCompression := afcDefWhitespaceCompression;
    FWhitespaceFrom        := afcDefWhitespaceFrom;
    FWhitespaceTo          := afcDefWhitespaceTo;
    FScaling               := afcDefScaling;
    FHorizMult             := afcDefHorizMult;
    FHorizDiv              := afcDefHorizDiv;
    FVertMult              := afcDefVertMult;
    FVertDiv               := afcDefVertDiv;
    FAutoScaleMode         := afcDefAutoScaleMode;
    FStatus                := nil;
    FOutputLine            := nil;
    Data                   := nil;
  end;

  destructor TApdCustomFaxUnpacker.Destroy;
  begin
    if Assigned(Data) then
      DestroyData;

    inherited Destroy;
  end;

  procedure TApdCustomFaxUnpacker.UnpackPage(const Page : Cardinal);
    {-Unpack page number Page}
  begin
    CreateData;
    CheckException(Self, upUnpackPage(Data, InFNameZ, Page));
  end;

  procedure TApdCustomFaxUnpacker.UnpackFile;
    {-Unpack all pages in a fax file}
  begin
    CreateData;
    CheckException(Self, upUnpackFile(Data, InFNameZ));
  end;

  function TApdCustomFaxUnpacker.UnpackPageToBitmap(const Page : Cardinal) : TBitmap;
    {-Unpack a page of fax into a memory bitmap}
  var
    MemBmp : TMemoryBitmapDesc;

  begin
    CreateData;
    CheckException(Self, upUnpackPageToBitmap(Data, InFNameZ, Page, MemBmp, True));
    if MemBmp.Bitmap = 0 then begin                                      {!!.04}
      Result := nil;                                                     {!!.04}
      CheckException(Self, ecCantMakeBitmap);                            {!!.04}
    end else begin                                                       {!!.04}
      Result        := TBitmap.Create;
      Result.Handle := MemBmp.Bitmap;
      {if FaxResolution = frNormal then}                                 {!!.04}
      if FaxWidth = fwNormal then                                        {!!.04}
        Result.Width := StandardWidth
      else
        Result.Width := WideWidth;
    end;                                                                 {!!.04}
  end;

  function TApdCustomFaxUnpacker.UnpackFileToBitmap : TBitmap;
    {-Unpack a fax into a memory bitmap}
  var
    MemBmp : TMemoryBitmapDesc;

  begin
    CreateData;
    CheckException(Self, upUnpackFileToBitmap(Data, InFNameZ, MemBmp, True));
    if MemBmp.Bitmap = 0 then begin                                      {!!.04}
      Result := nil;                                                     {!!.04}
      CheckException(Self, ecCantMakeBitmap);                            {!!.04}
    end else begin                                                       {!!.04}
      Result        := TBitmap.Create;
      Result.Handle := MemBmp.Bitmap;
      {if FaxResolution = frNormal then}                                 {!!.04}
      if FaxWidth = fwNormal then                                        {!!.04}
        Result.Width := StandardWidth
      else
        Result.Width := WideWidth;
    end;                                                                 {!!.04}
  end;

  procedure TApdCustomFaxUnpacker.UnpackPageToPcx(const Page : Cardinal);
    {-Unpack a page of a fax into a PCX file}
  begin
    CreateData;
    CheckException(Self, upUnpackPageToPcx(Data, InFNameZ, OutFNameZ, Page));
  end;

  procedure TApdCustomFaxUnpacker.UnpackFileToPcx;
    {-Unpack a file to a PCX file}
  begin
    CreateData;
    CheckException(Self, upUnpackFileToPcx(Data, InFNameZ, OutFNameZ));
  end;

  procedure TApdCustomFaxUnpacker.UnpackPageToDcx(const Page : Cardinal);
    {-Unpack a page of a fax into a DCX file}
  begin
    CreateData;
    CheckException(Self, upUnpackPageToDcx(Data, InFNameZ, OutFNameZ, Page));
  end;

  procedure TApdCustomFaxUnpacker.UnpackFileToDcx;
    {-Unpack a file to a DCX file}
  begin
    CreateData;
    CheckException(Self, upUnpackFileToDcx(Data, InFNameZ, OutFNameZ));
  end;

  procedure TApdCustomFaxUnpacker.UnpackPageToTiff(const Page : Cardinal);
    {-Unpack a page of a fax into a TIF file}
  begin
    CreateData;
    CheckException(Self, upUnpackPageToTiff(Data, InFNameZ, OutFNameZ, Page));
  end;

  procedure TApdCustomFaxUnpacker.UnpackFileToTiff;
    {-Unpack a file to a TIF file}
  begin
    CreateData;
    CheckException(Self, upUnpackFileToTiff(Data, InFNameZ, OutFNameZ));
  end;

  procedure TApdCustomFaxUnpacker.UnpackPageToBmp(const Page : Cardinal);
    {-Unpack a page of a fax into a BMP file}
  begin
    with UnpackPageToBitmap(Page) do begin                               {!!.04}
      SaveToFile(FOutFileName);                                          {!!.04}
      Free;                                                              {!!.04}
    end;                                                                 {!!.04}
  end;

  procedure TApdCustomFaxUnpacker.UnpackFileToBmp;
    {-Unpack a file to a BMP file}
  begin
    with UnpackFileToBitmap do begin                                     {!!.04}
      SaveToFile(FOutFileName);                                          {!!.04}
      Free;                                                              {!!.04}
    end;                                                                 {!!.04}
  end;

  class function TApdCustomFaxUnpacker.IsAnAPFFile(const FName : string) : Boolean;
  begin
    Result := awIsAnAPFFile(FName);
  end;

procedure TApdCustomFaxUnpacker.ExtractPage(const Page: Cardinal);
var
  Fax        : TFileStream;
  Dest       : TMemoryStream;
  FaxHeader  : TFaxHeaderRec;
  PageHeader : TPageHeaderRec;
  Count      : Cardinal;
  Ext        : String;
begin
  if not FileExists(FInFileName) then
    CheckException(Self, ecFileNotFound);

  if (FOutFileName = '') then
    FOutFileName := ChangeFileExt(FInFileName, '.' + DefAPFExt)
  else begin
    Ext := ExtractFileExt(FOutFileName);
    if (Ext = '') then
      FOutFileName := ChangeFileExt(FOutFileName, '.' + DefAPFExt);
  end;

  if UpperCase(FInFileName) = UpperCase(FOutFileName) then
    CheckException(Self, ecAccessDenied);

  Fax := TFileStream.Create(FInFileName, fmOpenRead);
  try
    Fax.ReadBuffer(FaxHeader, SizeOf(TFaxHeaderRec));
    if FaxHeader.Signature <> DefAPFSig then begin
      Fax.Free;
      CheckException(Self, ecFaxBadFormat);
    end;
    if FaxHeader.PageCount < Page then begin
      Fax.Free;
      CheckException(Self, ecInvalidPageNumber);
    end;
    Dest := TMemoryStream.Create;
    try
      FaxHeader.PageCount := 1;
      Dest.WriteBuffer(FaxHeader, SizeOf(TFaxHeaderRec));
      Count := 1;
      while Count < Page do begin
        inc(Count);
        Fax.ReadBuffer(PageHeader, SizeOf(TPageHeaderRec));
        Fax.Seek(PageHeader.ImgLength, soFromCurrent);
      end;
      Fax.ReadBuffer(PageHeader, SizeOf(TPageHeaderRec));
      Dest.WriteBuffer(PageHeader, SizeOf(TPageHeaderRec));
      Dest.CopyFrom(Fax, PageHeader.ImgLength);
      Dest.SaveToFile(FOutFileName);
    finally
      Dest.Free;
    end;
  finally
    Fax.Free;
  end;
end;

{ TApdAPFGraphic }

constructor TApdAPFGraphic.Create;
begin
  inherited Create;

  FPages := TList.Create;

  FFromAPF := TApdFaxUnpacker.Create (nil);
  FToAPF := TApdFaxConverter.Create (nil);
end;

destructor TApdAPFGraphic.Destroy;
begin
  FreeImages;
  FPages.Free;
  FFromAPF.Free;
  FToAPF.Free;

  inherited Destroy;
end;

procedure TApdAPFGraphic.Assign (Source : TPersistent);
var
  i : Integer;
begin
  FreeImages;
  if Source is TApdAPFGraphic then begin
    FPages.Capacity := (Source as TApdAPFGraphic).FPages.Capacity;
    FPages.Count := (Source as TApdAPFGraphic).FPages.Count;
    for i := 0 to (Source as TApdAPFGraphic).FPages.Count - 1 do
      FPages.Items[i] := (Source as TApdAPFGraphic).FPages.Items[i];
    CurrentPage := (Source as TApdAPFGraphic).CurrentPage;
  end else
    inherited Assign (Source);
end;

procedure TApdAPFGraphic.AssignTo (Dest : TPersistent);
begin
  if (Dest is TBitmap) then
    Dest.Assign (TBitmap (FPages[CurrentPage]))
  else
    inherited AssignTo (Dest);
end;

procedure TApdAPFGraphic.Draw (ACanvas : TCanvas; const Rect : TRect);
begin
  ACanvas.StretchDraw (Rect, Page[FCurrentPage]);
end;

procedure TApdAPFGraphic.FreeImages;
var
  i : Integer;

begin
  for i := 0 to FPages.Count - 1 do
    TBitmap (FPages[i]).Free;
  FPages.Clear;
  FCurrentPage := 0;
end;

function TApdAPFGraphic.GetEmpty : Boolean;
begin
  Result := (FPages.Count = 0);
end;

function TApdAPFGraphic.GetHeight : Integer;
begin
  if FPages.Count > 0 then
    Result := TBitmap (FPages[FCurrentPage]).Height
  else
    Result := 0;
end;

function TApdAPFGraphic.GetNumPages : Integer;
begin
  Result := FPages.Count;
end;

function TApdAPFGraphic.GetPage (x : Integer) : TBitmap;
begin
  if FPages.Count > 0 then
    Result := TBitmap (FPages[FCurrentPage])
  else
    Result := nil;
end;

function TApdAPFGraphic.GetWidth : Integer;
begin
  if FPages.Count > 0 then
    Result := TBitmap (FPages[FCurrentPage]).Width
  else
    Result := 0;
end;

procedure TApdAPFGraphic.LoadFromClipboardFormat (AFormat : Word;
                                                  AData : THandle;
                                                  APalette : HPALETTE);
begin
  raise EApdAPFGraphicError.Create (ApdEcStrNoClipboard);
end;

procedure TApdAPFGraphic.LoadFromFile (const Filename : string);
var
  i : Integer;
  WorkBitmap : TBitmap;

begin
  FreeImages;
  FFromAPF.InFileName := FileName;
  for i := 1 to FFromAPF.NumPages do begin
    WorkBitmap := FFromAPF.UnpackPageToBitmap(i);
    FPages.Add (WorkBitmap)
  end;
  CurrentPage := 0;
end;

procedure TApdAPFGraphic.LoadFromStream (Stream : TStream);
var
  fpOut : TFileStream;
  TempPath : array [0..MAX_PATH] of Char;
  TempName : array [0..MAX_PATH] of Char;

begin
  GetTempPath (255, TempPath);
  GetTempFileName (TempPath, 'APD', 0, TempName);
  fpOut := TFileStream.Create(TempName, fmCreate);
  try
    fpOut.CopyFrom (Stream, 0);
  finally
    fpOut.Free;
    try
      LoadFromFile (TempName);
    finally
      DeleteFile (TempName);
    end;
  end;
end;

procedure TApdAPFGraphic.SaveToClipboardFormat (var AFormat : Word;
                                                var AData : THandle;
                                                var APalette : HPALETTE);
begin
  raise EApdAPFGraphicError.Create (ApdEcStrNoClipboard);
end;

procedure TApdAPFGraphic.SaveToStream (Stream : TStream);
var
  fpIn : TFileStream;
  TempPath : array [0..MAX_PATH] of Char;
  TempName : array [0..MAX_PATH] of Char;

begin
  GetTempPath (255, TempPath);
  GetTempFileName (TempPath, 'APD', 0, TempName);
  SaveToFile (TempName);

  fpIn := TFileStream.Create (TempName, fmOpenRead);
  try
    Stream.CopyFrom (fpIn, 0)
  finally
    fpIn.Free;
    DeleteFile (TempName);
  end;
end;

procedure TApdAPFGraphic.SaveToFile (const Filename : string);
var
  i            : Integer;
  FaxList      : TStringList;
  TempPath     : array [0..MAX_PATH] of Char;
  TempName     : array [0..MAX_PATH] of Char;
  DestFile     : TFileStream;
  SourceFile   : TFileStream;
  DestHeader   : TFaxHeaderRec;
  SourceHeader : TFaxHeaderRec;

begin
  FaxList := TStringList.Create;
  try
    GetTempPath (255, TempPath);
    FToAPF.InputDocumentType := idBMP;
    for i := 0 to FPages.Count - 1 do begin
      GetTempFileName (TempPath, 'APD', 0, TempName);
      FToAPF.OutFileName := TempName;
      FToAPF.ConvertBitmapToFile (Page[i]);
      FaxList.Add (TempName);
    end;
    if FaxList.Count = 0 then
      Exit;

    { concatenate the temp files into the new one }
    { Create temp file }

    DestFile := TFileStream.Create (FileName, fmCreate or fmShareExclusive);
    try
      { Open first source file }
      SourceFile := TFileStream.Create (FaxList[0],
                                        fmOpenRead or fmShareDenyWrite);
      try
        { Read header of the first APF }
        SourceFile.ReadBuffer (DestHeader, SizeOf (DestHeader));
        if (DestHeader.Signature <> DefAPFSig) then
          raise EApdAPFGraphicError.Create (ApdEcStrBadFaxFmt);
        { Copy first source file to dest }
        DestFile.CopyFrom (SourceFile, 0);
      finally
        SourceFile.Free;
      end;
      { Append remaining files in the list }
      for I := 1 to Pred (FaxList.Count) do begin
        SourceFile := TFileStream.Create (FaxList[I],
                                          fmOpenRead or fmShareDenyWrite);
        try
          SourceFile.ReadBuffer (SourceHeader, SizeOf (SourceHeader));
          if (SourceHeader.Signature <> DefAPFSig) then
            raise EApdAPFGraphicError.Create (ApdEcStrBadFaxFmt);
          DestFile.CopyFrom (SourceFile,
                             SourceFile.Size - SizeOf (SourceHeader));
          DestHeader.PageCount := DestHeader.PageCount +
                                  SourceHeader.PageCount;
        finally
          SourceFile.Free;
        end;
      end;
      DestFile.Position := 0;
      DestFile.WriteBuffer (DestHeader, SizeOf (DestHeader));
    finally
      DestFile.Free;
    end;

  finally
    try
      for i := 0 to FaxList.Count - 1 do
        DeleteFile (FaxList[i]);
    finally
      FaxList.Free;
    end;
  end;
end;

procedure TApdAPFGraphic.SetCurrentPage (v : Integer);
begin
  if (v <> FCurrentPage) then begin
    if (v >= 0) and (v < FPages.Count) then
      FCurrentPage := v
    else
      raise EApdAPFGraphicError.Create (ApdEcStrInvalidPage);
  end;
end;

procedure TApdAPFGraphic.SetHeight (v : Integer);
begin
  TBitmap (FPages[CurrentPage]).Height := v;
end;

procedure TApdAPFGraphic.SetPage (x : Integer; v : TBitmap);
var
  WorkBitmap : TBitmap;

begin
  { Assign the bitmap to the specified index.  If you specify an index that
    is one greater than the last available index, the image will be added
    at the end. }
  if (x >= 0) and (x < FPages.Count) then
    TBitmap (FPages[x]).Assign (v)
  else if (x = FPages.Count) then begin
    WorkBitmap := TBitmap.Create;
    WorkBitmap.Assign (v);
    FPages.Add(WorkBitmap);
  end else
    raise EApdAPFGraphicError.Create (ApdEcStrInvalidPage);
end;

procedure TApdAPFGraphic.SetWidth (v : Integer);
begin
  TBitmap (FPages[CurrentPage]).Width := v;
end;

initialization

  { Register this format with TPicture }

  TPicture.RegisterFileFormat ('APF', 'APRO APF Format',
                               TApdAPFGraphic);

finalization

  { Deregister this format from TPicture }

  TPicture.UnregisterGraphicClass (TApdAPFGraphic);

end.
