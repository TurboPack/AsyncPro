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
 *    Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   AWFAXCVT.PAS 4.06                   *}
{*********************************************************}
{* Low-level fax conversion/unpacking utilities          *}
{*********************************************************}

{
  Used by the TApdFaxUnpacker and TApdFaxConverter (AdFaxCvt.pas), and
  by the printer drivers.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$V-,I-,B-,X+,G+,O-}

{$IFNDEF PrnDrv}
{$J+,H+}
{$ENDIF}

{$IFNDEF PRNDRV}
  {$DEFINE BindFaxFont}
{$ENDIF}

unit AwFaxCvt;
  {-Fax conversion}


interface

uses
  {-------RTL}
  {$IFNDEF Prndrv}
  Graphics,
  Classes,
  Controls,
  Forms,
  {$ENDIF}
  Windows,
  SysUtils,
  Messages,
  {-------APW}
  OoMisc;

{--Abstract converter functions--}


procedure acInitFaxConverter(var Cvt : PAbsFaxCvt; Data : Pointer;
                            CB : TGetLineCallback; OpenFile : TOpenFileCallback;
                            CloseFile : TCloseFileCallback; DefaultExt : string);
  {-Initialize a fax converter engine}

procedure acDoneFaxConverter(var Cvt : PAbsFaxCvt);
  {-Destroy a fax converter engine}

procedure acSetOtherData(Cvt : PAbsFaxCvt; OtherData : Pointer);
  {-Set other data pointer}

procedure acOptionsOn(Cvt : PAbsFaxCvt; OptionFlags : Word);
  {-Activate multiple fax converter options}

procedure acOptionsOff(Cvt : PAbsFaxCvt; OptionFlags : Word);
  {-Deactivate multiple options}

function acOptionsAreOn(Cvt : PAbsFaxCvt; OptionFlags : Word) : Bool;
  {-Return TRUE if all specified options are on}

procedure acSetMargins(Cvt : PAbsFaxCvt; Left, Top : Cardinal);
  {-Set left and top margins for converter}

procedure acSetResolutionMode(Cvt : PAbsFaxCvt; HiRes : Bool);
  {-Select standard or high resolution mode}

procedure acSetResolutionWidth(Cvt : PAbsFaxCvt; RW : Cardinal);
  {-Select standard (1728 pixels) or wide (2048 pixels) width}

procedure acSetStationID(Cvt : PAbsFaxCvt; ID : AnsiString);
  {-Set the station ID of the converter}

procedure acSetStatusCallback(Cvt : PAbsFaxCvt; CB : TCvtStatusCallback);
  {-Set the procedure called for conversion status}

procedure acSetStatusWnd(Cvt : PAbsFaxCvt; HWindow : TApdHwnd);
  {-Set the handle of the window that receives status messages}

function acOpenFile(Cvt : PAbsFaxCvt; FileName : string) : Integer;
  {-Open a converter input file}

procedure acCloseFile(Cvt : PAbsFaxCvt);
  {-Close a converter input file}

function acGetRasterLine(Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                         var EndOfPage, MorePages : Bool) : Integer;
  {-Read a raster line from an input file}

function acCreateOutputFile(Cvt : PAbsFaxCvt) : Integer;
  {-Create an APF file}

function acCloseOutputFile(Cvt : PAbsFaxCvt) : Integer;
  {-Close an APF file}

procedure acInitDataLine(Cvt : PAbsFaxCvt);
  {-Initialize the converter's line buffer}

function acAddData(Cvt : PAbsFaxCvt; var Buffer; Len : Cardinal; DoInc : Bool) : Integer;
  {-Add a block of data to the output file}

function acAddLine(Cvt : PAbsFaxCvt; var Buffer; Len : Cardinal) : Integer;
  {-Add a line of image data to the file}

procedure acCompressRasterLine(Cvt : PAbsFaxCvt; var Buffer);
  {-compress a raster line of bits into runlength codes}

procedure acMakeEndOfPage(Cvt : PAbsFaxCvt; var Buffer; var Len : Integer);
  {-Encode end-of-page data into Buffer}

function acOutToFileCallback(Cvt : PAbsFaxCvt; var Data; Len : Integer;
                             EndOfPage, MorePages : Bool) : Integer;
  {-Output a compressed raster line to an APF file}

function acConvertToFile(Cvt : PAbsFaxCvt; FileName, DestFile : string) : Integer;
  {-Convert an image to a fax file}

function acConvert(Cvt : PAbsFaxCvt; FileName : string;
                   OutCallback : TPutLineCallback) : Integer;
  {-Convert an input file, sending data to OutHandle or to OutCallback}

{$IFNDEF PRNDRV}
{--Text converter functions--}

procedure fcInitTextConverter(var Cvt : PAbsFaxCvt);
  {-Initialize a text-to-fax converter}

procedure fcDoneTextConverter(var Cvt : PAbsFaxCvt);
  {-Destroy a text-to-fax converter}

procedure fcInitTextExConverter(var Cvt : PAbsFaxCvt);
  {-Initialize an extended text-to-fax converter}

procedure fcDoneTextExConverter(var Cvt : PAbsFaxCvt);
  {-Destroy an extended text-to-fax converter}

procedure fcSetTabStop(Cvt : PAbsFaxCvt; TabStop : Cardinal);
  {-Set the number of spaces equivalent to a tab character}

function fcLoadFont(Cvt : PAbsFaxCvt; FileName : PAnsiChar;
                    FontHandle : Cardinal; HiRes : Bool) : Integer;
  {-Load selected font from APFAX.FNT or memory}

function fcSetFont(Cvt : PAbsFaxCvt; Font : TFont; HiRes : Boolean) : Integer;
  {-Set font for extended text converter}

procedure fcSetLinesPerPage(Cvt : PAbsFaxCvt; LineCount : Cardinal);
  {-Set the number of text lines per page}

function fcOpenFile(Cvt : PAbsFaxCvt; FileName : string) : Integer;
  {-Open a text file for input}

procedure fcCloseFile(Cvt : PAbsFaxCvt);
  {-Close text file}

procedure fcRasterizeText(Cvt : PAbsFaxCvt; St : PAnsiChar; Row : Cardinal; var Data);
  {-Turn a row in a string into a raster line}

function fcGetTextRasterLine( Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                              var EndOfPage, MorePages : Bool) : Integer;
  {-Callback to convert one row of a string into a raster line}

{--TIFF converter functions--}

procedure tcInitTiffConverter(var Cvt : PAbsFaxCvt);
  {-Initialize a TIFF-to-fax converter}

procedure tcDoneTiffConverter(var Cvt : PAbsFaxCvt);
  {-Destroy a TIFF converter}

function tcOpenFile(Cvt : PAbsFaxCvt; FileName : string) : Integer;
  {-Open a TIFF file for input}

procedure tcCloseFile(Cvt : PAbsFaxCvt);
  {-Close TIFF file}

function tcGetTiffRasterLine( Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                              var EndOfPage, MorePages : Bool) : Integer;
  {-Callback to read a row of TIFF raster data}

{--PCX converter functions--}

procedure pcInitPcxConverter(var Cvt : PAbsFaxCvt);
  {-Initialize a PCX-to-fax converter}

procedure pcDonePcxConverter(var Cvt : PAbsFaxCvt);
  {-Destroy a PCX-to-fax converter}

function pcOpenFile(Cvt : PAbsFaxCvt; FileName : string) : Integer;
  {-Open a PCX file for input}

procedure pcCloseFile(Cvt : PAbsFaxCvt);
  {-Close PCX file}

function pcGetPcxRasterLine(Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                            var EndOfPage, MorePages : Bool) : Integer;
  {-Callback to read a row of PCX raster data}

{--DCX converter functions--}

procedure dcInitDcxConverter(var Cvt : PAbsFaxCvt);
  {-Initialize a DCX-to-fax converter}

procedure dcDoneDcxConverter(var Cvt : PAbsFaxCvt);
  {-Destroy a PCX-to-fax converter}

function dcOpenFile(Cvt : PAbsFaxCvt; FileName : string) : Integer;
  {-Open a DCX file for input}

procedure dcCloseFile(Cvt : PAbsFaxCvt);
  {-Close DCX file}

function dcGetDcxRasterLine(Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                            var EndOfPage, MorePages : Bool) : Integer;
  {-Callback to read a row of DCX raster data}

{--BMP converter functions--}

procedure bcInitBmpConverter(var Cvt : PAbsFaxCvt);
  {-Initialize a BMP-to-fax converter}

procedure bcDoneBmpConverter(var Cvt : PabsFaxCvt);
  {-Destroy a BMP-to-fax converter}

function bcOpenFile(Cvt : PAbsFaxCvt; FileName : string) : Integer;
  {-Open a BMP file for input}

procedure bcCloseFile(Cvt : PAbsFaxCvt);
  {-Close BMP file}

function bcGetBmpRasterLine(Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                            var EndOfPage, MorePages : Bool) : Integer;
  {-Callback to read a row of BMP raster data}

procedure bcInitBitmapConverter(var Cvt : PAbsFaxCvt);
  {-Initialize a bitmap-to-fax converter}

procedure bcDoneBitmapConverter(var Cvt : PAbsFaxCvt);
  {-Destroy a bitmap-to-fax converter}

function bcSetInputBitmap(var Cvt : PAbsFaxCvt; Bitmap : HBitmap) : Integer;
  {-Set bitmap that will be converted}

function bcOpenBitmap(Cvt : PAbsFaxCvt; FileName : string) : Integer;
  {-Open bitmap "file"}

procedure bcCloseBitmap(Cvt : PAbsFaxCvt);
  {-Close bitmap "file"}

function bcGetBitmapRasterLine(Cvt : PAbsFaxCvt; var Data; var Len : Integer;
                               var EndOfPage, MorePages : Bool) : Integer;
  {-Read a raster line from a bitmap}

{--Basic fax unpacker--}


function upInitFaxUnpacker( var Unpack : PUnpackFax; Data : Pointer;
                            CB : TUnpackLineCallback) : Integer;
  {-Initialize a fax unpacker}

procedure upDoneFaxUnpacker(var Unpack : PUnpackFax);
  {-Destroy a fax unpacker}

procedure upOptionsOn(Unpack : PUnpackFax; OptionFlags : Word);
  {-Turn on one or more unpacker options}

procedure upOptionsOff(Unpack : PUnpackFax; OptionFlags : Word);
  {-Turn off one or more unpacker options}

function upOptionsAreOn(Unpack : PUnpackFax; OptionFlags : Word) : Bool;
  {-Return True if all specified options are on}

procedure upSetStatusCallback(Unpack : PUnpackFax; Callback : TUnpackStatusCallback);
  {-Set up a routine to be called to report unpack status}

function upSetWhitespaceCompression(Unpack : PUnpackFax; FromLines, ToLines : Cardinal) : Integer;

  {-Set the whitespace compression option.}

procedure upSetScaling(Unpack : PUnpackFax; HMult, HDiv, VMult, VDiv : Cardinal);
  {-Set horizontal and vertical scaling factors}

function upGetFaxHeader(Unpack : PUnpackFax; FName : string; var FH : TFaxHeaderRec) : Integer;
  {-Return header for fax FName}

function upGetPageHeader(Unpack : PUnpackFax; FName : string; Page : Cardinal; var PH : TPageHeaderRec) : Integer;

  {-Return header for Page in fax FName}

function upUnpackPage(Unpack : PUnpackFax; FName : string; Page : Cardinal) : Integer;
  {-Unpack page number Page, calling the put line callback for each raster line}

function upUnpackFile(Unpack : PUnpackFax; FName : string) : Integer;
  {-Unpack all pages in a fax file}

function upUnpackPageToBitmap(Unpack : PUnpackFax; FName : string; Page : Cardinal;
                              var Bmp : TMemoryBitmapDesc; Invert : Bool) : Integer;

  {-Unpack a page of fax into a memory bitmap}

function upUnpackFileToBitmap(Unpack : PUnpackFax; FName : string; var Bmp : TMemoryBitmapDesc;
                              Invert : Bool) : Integer;

  {-Unpack a fax into a memory bitmap}

function upUnpackFileToBuffer(Unpack : PUnpackFax; FName : string) : Integer;

  {-Unpack a fax into a memory bitmap}

function upUnpackPageToBuffer(Unpack : PUnpackFax; FName : string; Page : Cardinal; UnpackingFile : Boolean) : Integer;

  {-Unpack a page of fax into a memory bitmap}

function upPutMemoryBitmapLine(Unpack : PUnpackFax; plFlags : Word; var Data; Len, PageNum : Cardinal) : Integer;

  {-Callback to output a raster line to an in-memory bitmap}

{--Output to image file routines--}

function upUnpackPageToPcx(Unpack : PUnpackFax; FName, OutName : string; Page : Cardinal) : Integer;

  {-Unpack one page of an APF file to a PCX file}

function upUnpackFileToPcx(Unpack : PUnpackFax; FName, OutName : string) : Integer;

  {-Unpack an APF file to a PCX file}

function upUnpackPageToDcx(Unpack : PUnpackFax; FName, OutName : string; Page : Cardinal) : Integer;

  {-Unpack one page of an APF file to a DCX file}

function upUnpackFileToDcx(Unpack : PUnpackFax; FName, OutName : string) : Integer;

  {-Unpack an APF file to a DCX file}

function upUnpackPageToTiff(Unpack : PUnpackFax; FName, OutName : string; Page : Cardinal) : Integer;

  {-Unpack one page of an APF file to a TIF file}

function upUnpackFileToTiff(Unpack : PUnpackFax; FName, OutName : string) : Integer;

  {-Unpack an APF file to a TIF file}

function upUnpackPageToBmp(Unpack : PUnpackFax; FName, OutName : string; Page : Cardinal) : Integer;

  {-Unpack one page of an APF file to a BMP file}

function upUnpackFileToBmp(Unpack : PUnpackFax; FName, OutName : string) : Integer;

  {-Unpack an APF file to a BMP file}

{--misc--}
function awIsAnAPFFile(FName : string) : Bool;
  {-Return TRUE if the file FName is a valid APF file}


//function upPutMemoryBitmapLine(Unpack : PUnpackFax; plFlags : Word;
//                                 var Data; Len, PageNum : Cardinal): Integer;


{$ENDIF}

implementation

uses
  AnsiStrings;

{$IFDEF BindFaxFont}
{$R AWFAXCVT.R32}
{$ENDIF}

const
  {General}
  DefUpdateInterval          = 16;          {Lines per status call}
  DefFontFile                = 'APFAX.FNT'; {Default font file name}
  FaxFileExt                 = 'APF';       {Fax file extension}
  DefLeftMargin              = 50;          {Default left margin of 1/4 inch}
  DefTopMargin               = 0;           {Default top margin of zero}
  DefFaxTabStop              = 4;           {Default tab stops}

  {Default fax conversion options}
  DefFaxCvtOptions = fcYield + fcDoubleWidth + fcCenterImage;

  {No bad options}
  BadFaxCvtOptions = 0;

  ReadBufferSize = 8192;        {Max size of file read buffer}
  LinePadSize    = 2;           {Assure this many nulls per line}
  MaxFontBytes   = 24576;       {Maximum bytes for a font}
  LineBufSize    = 512;         {Size of unpacker's line buffer}

  {End of line bit codes for fax images}
  EOLRec     : TCodeRec = (Code : $0001; Sig : 12);
  LongEOLRec : TCodeRec = (Code : $0001; Sig : 16);

  {$IFDEF BindFaxFont}
  {font resource data}
  AwFontResourceType = 'AWFAXFONT';
  AwFontResourceName = 'FAXFONT';
  {$ENDIF}

  {TIFF tag values}
  SubfileType         = 255;
  ImageWidth          = 256;
  ImageLength         = 257;
  BitsPerSample       = 258;
  Compression         = 259;
  PhotometricInterp   = 262;
  StripOffsets        = 273;
  RowsPerStrip        = 278;
  StripByteCounts     = 279;

  {TIFF tag integer types}
  tiffByte            = 1;
  tiffASCII           = 2;
  tiffShort           = 3;
  tiffLong            = 4;
  tiffRational        = 5;

  {TIFF compression values}
  compNone = $0001;
  compHuff = $0002;
  compFAX3 = $0003;
  compFAX4 = $0004;
  compWRDL = $8003;
  compMPNT = $8005;

  {For decoding white runs}
  WhiteTable : TTermCodeArray = (
    (Code : $0035; Sig : 8),
    (Code : $0007; Sig : 6),
    (Code : $0007; Sig : 4),
    (Code : $0008; Sig : 4),
    (Code : $000B; Sig : 4),
    (Code : $000C; Sig : 4),
    (Code : $000E; Sig : 4),
    (Code : $000F; Sig : 4),
    (Code : $0013; Sig : 5),
    (Code : $0014; Sig : 5),
    (Code : $0007; Sig : 5),
    (Code : $0008; Sig : 5),
    (Code : $0008; Sig : 6),
    (Code : $0003; Sig : 6),
    (Code : $0034; Sig : 6),
    (Code : $0035; Sig : 6),
    (Code : $002A; Sig : 6),
    (Code : $002B; Sig : 6),
    (Code : $0027; Sig : 7),
    (Code : $000C; Sig : 7),
    (Code : $0008; Sig : 7),
    (Code : $0017; Sig : 7),
    (Code : $0003; Sig : 7),
    (Code : $0004; Sig : 7),
    (Code : $0028; Sig : 7),
    (Code : $002B; Sig : 7),
    (Code : $0013; Sig : 7),
    (Code : $0024; Sig : 7),
    (Code : $0018; Sig : 7),
    (Code : $0002; Sig : 8),
    (Code : $0003; Sig : 8),
    (Code : $001A; Sig : 8),
    (Code : $001B; Sig : 8),
    (Code : $0012; Sig : 8),
    (Code : $0013; Sig : 8),
    (Code : $0014; Sig : 8),
    (Code : $0015; Sig : 8),
    (Code : $0016; Sig : 8),
    (Code : $0017; Sig : 8),
    (Code : $0028; Sig : 8),
    (Code : $0029; Sig : 8),
    (Code : $002A; Sig : 8),
    (Code : $002B; Sig : 8),
    (Code : $002C; Sig : 8),
    (Code : $002D; Sig : 8),
    (Code : $0004; Sig : 8),
    (Code : $0005; Sig : 8),
    (Code : $000A; Sig : 8),
    (Code : $000B; Sig : 8),
    (Code : $0052; Sig : 8),
    (Code : $0053; Sig : 8),
    (Code : $0054; Sig : 8),
    (Code : $0055; Sig : 8),
    (Code : $0024; Sig : 8),
    (Code : $0025; Sig : 8),
    (Code : $0058; Sig : 8),
    (Code : $0059; Sig : 8),
    (Code : $005A; Sig : 8),
    (Code : $005B; Sig : 8),
    (Code : $004A; Sig : 8),
    (Code : $004B; Sig : 8),
    (Code : $0032; Sig : 8),
    (Code : $0033; Sig : 8),
    (Code : $0034; Sig : 8));

  WhiteMUTable : TMakeUpCodeArray = (
    (Code : $001B; Sig : 5),
    (Code : $0012; Sig : 5),
    (Code : $0017; Sig : 6),
    (Code : $0037; Sig : 7),
    (Code : $0036; Sig : 8),
    (Code : $0037; Sig : 8),
    (Code : $0064; Sig : 8),
    (Code : $0065; Sig : 8),
    (Code : $0068; Sig : 8),
    (Code : $0067; Sig : 8),
    (Code : $00CC; Sig : 9),
    (Code : $00CD; Sig : 9),
    (Code : $00D2; Sig : 9),
    (Code : $00D3; Sig : 9),
    (Code : $00D4; Sig : 9),
    (Code : $00D5; Sig : 9),
    (Code : $00D6; Sig : 9),
    (Code : $00D7; Sig : 9),
    (Code : $00D8; Sig : 9),
    (Code : $00D9; Sig : 9),
    (Code : $00DA; Sig : 9),
    (Code : $00DB; Sig : 9),
    (Code : $0098; Sig : 9),
    (Code : $0099; Sig : 9),
    (Code : $009A; Sig : 9),
    (Code : $0018; Sig : 6),
    (Code : $009B; Sig : 9),
    (Code : $0008; Sig : 11),
    (Code : $000C; Sig : 11),
    (Code : $000D; Sig : 11),
    (Code : $0012; Sig : 12),
    (Code : $0013; Sig : 12),
    (Code : $0014; Sig : 12),
    (Code : $0015; Sig : 12),
    (Code : $0016; Sig : 12),
    (Code : $0017; Sig : 12),
    (Code : $001C; Sig : 12),
    (Code : $001D; Sig : 12),
    (Code : $001E; Sig : 12),
    (Code : $001F; Sig : 12));

  BlackTable : TTermCodeArray = (
    (Code : $0037; Sig : 10),
    (Code : $0002; Sig : 3),
    (Code : $0003; Sig : 2),
    (Code : $0002; Sig : 2),
    (Code : $0003; Sig : 3),
    (Code : $0003; Sig : 4),
    (Code : $0002; Sig : 4),
    (Code : $0003; Sig : 5),
    (Code : $0005; Sig : 6),
    (Code : $0004; Sig : 6),
    (Code : $0004; Sig : 7),
    (Code : $0005; Sig : 7),
    (Code : $0007; Sig : 7),
    (Code : $0004; Sig : 8),
    (Code : $0007; Sig : 8),
    (Code : $0018; Sig : 9),
    (Code : $0017; Sig : 10),
    (Code : $0018; Sig : 10),
    (Code : $0008; Sig : 10),
    (Code : $0067; Sig : 11),
    (Code : $0068; Sig : 11),
    (Code : $006C; Sig : 11),
    (Code : $0037; Sig : 11),
    (Code : $0028; Sig : 11),
    (Code : $0017; Sig : 11),
    (Code : $0018; Sig : 11),
    (Code : $00CA; Sig : 12),
    (Code : $00CB; Sig : 12),
    (Code : $00CC; Sig : 12),
    (Code : $00CD; Sig : 12),
    (Code : $0068; Sig : 12),
    (Code : $0069; Sig : 12),
    (Code : $006A; Sig : 12),
    (Code : $006B; Sig : 12),
    (Code : $00D2; Sig : 12),
    (Code : $00D3; Sig : 12),
    (Code : $00D4; Sig : 12),
    (Code : $00D5; Sig : 12),
    (Code : $00D6; Sig : 12),
    (Code : $00D7; Sig : 12),
    (Code : $006C; Sig : 12),
    (Code : $006D; Sig : 12),
    (Code : $00DA; Sig : 12),
    (Code : $00DB; Sig : 12),
    (Code : $0054; Sig : 12),
    (Code : $0055; Sig : 12),
    (Code : $0056; Sig : 12),
    (Code : $0057; Sig : 12),
    (Code : $0064; Sig : 12),
    (Code : $0065; Sig : 12),
    (Code : $0052; Sig : 12),
    (Code : $0053; Sig : 12),
    (Code : $0024; Sig : 12),
    (Code : $0037; Sig : 12),
    (Code : $0038; Sig : 12),
    (Code : $0027; Sig : 12),
    (Code : $0028; Sig : 12),
    (Code : $0058; Sig : 12),
    (Code : $0059; Sig : 12),
    (Code : $002B; Sig : 12),
    (Code : $002C; Sig : 12),
    (Code : $005A; Sig : 12),
    (Code : $0066; Sig : 12),
    (Code : $0067; Sig : 12));

  BlackMUTable : TMakeUpCodeArray = (
    (Code : $000F; Sig : 10),
    (Code : $00C8; Sig : 12),
    (Code : $00C9; Sig : 12),
    (Code : $005B; Sig : 12),
    (Code : $0033; Sig : 12),
    (Code : $0034; Sig : 12),
    (Code : $0035; Sig : 12),
    (Code : $006C; Sig : 13),
    (Code : $006D; Sig : 13),
    (Code : $004A; Sig : 13),
    (Code : $004B; Sig : 13),
    (Code : $004C; Sig : 13),
    (Code : $004D; Sig : 13),
    (Code : $0072; Sig : 13),
    (Code : $0073; Sig : 13),
    (Code : $0074; Sig : 13),
    (Code : $0075; Sig : 13),
    (Code : $0076; Sig : 13),
    (Code : $0077; Sig : 13),
    (Code : $0052; Sig : 13),
    (Code : $0053; Sig : 13),
    (Code : $0054; Sig : 13),
    (Code : $0055; Sig : 13),
    (Code : $005A; Sig : 13),
    (Code : $005B; Sig : 13),
    (Code : $0064; Sig : 13),
    (Code : $0065; Sig : 13),
    (Code : $0008; Sig : 11),
    (Code : $000C; Sig : 11),
    (Code : $000D; Sig : 11),
    (Code : $0012; Sig : 12),
    (Code : $0013; Sig : 12),
    (Code : $0014; Sig : 12),
    (Code : $0015; Sig : 12),
    (Code : $0016; Sig : 12),
    (Code : $0017; Sig : 12),
    (Code : $001C; Sig : 12),
    (Code : $001D; Sig : 12),
    (Code : $001E; Sig : 12),
    (Code : $001F; Sig : 12));

  {Sizes for small font used for header line}
  SmallFontRec : TFontRecord = (
    Bytes  : 16;
    PWidth : 12;
    Width  : 2;
    Height : 8);

  {Sizes for standard font}
  StandardFontRec : TFontRecord = (
    Bytes  : 48;
    PWidth : 20;
    Width  : 3;
    Height : 16);

procedure RotateCode(var Code: Word; Sig: Word); assembler; register;
{ -Flip code MSB for LSB }
{$IFNDEF CPUX64}
asm
  push  edi
  push  ebx

  { load parameters }
  mov   edi,eax         { edi = Code }
  mov   ebx,edx         { ebx = Sig }

  mov   dx,word ptr [edi]
  xor   ax,ax
  mov   ecx,16
@1: shr   dx,1
  rcl   ax,1
  dec   ecx
  jnz   @1
  mov   cx,16
  sub   cx,bx
  shr   ax,cl
  mov   [edi],ax

  pop   ebx
  pop   edi
end;
{$ELSE}
asm
  // param1 = rcx
  // param2 = edx
  push  rdi
  push  rbx

  { load parameters }
  mov   rdi,rcx         { edi = Code }
  mov   ebx,edx         { ebx = Sig }

  movzx edx,word ptr [rdi]
  xor   eax,eax
  mov   ecx,16
@1: shr   edx,1
  rcl   eax,1
  dec   ecx
  jnz   @1
  mov   ecx,16
  sub   ecx,ebx
  shr   eax,cl
  mov   [rdi],ax

  pop   rbx
  pop   rdi
end;
{$ENDIF}
{Miscellaneous}

function awIsAnAPFFile(FName: string): Bool;
{ -Return TRUE if the file FName is a valid APF file }
var
  F: file;
  Sig: TSigArray;
  SaveFileMode: Word;

begin
  awIsAnAPFFile:= False;

  { open the file }
  Assign(F, FName);
  SaveFileMode:= FileMode;
  FileMode:= fmOpenRead or fmShareDenyWrite;
  Reset(F, 1);
  FileMode:= SaveFileMode;
  if (IoResult <> 0) then Exit;

  { read in what ought top be a signature }
  BlockRead(F, Sig, SizeOf(Sig));
  if (IoResult <> 0) then begin
    Close(F);
    if (IoResult = 0) then;
    Exit;
  end;
  Close(F);
  if (IoResult = 0) then;

  awIsAnAPFFile:= (DefAPFSig = Sig);
end;

procedure FastZero(var Buf; Len: Cardinal); assembler; register;
{$IFNDEF CPUX64}
asm
  push  edi

  cld

  { load parameters }
  mov   edi,eax     { eax = Buf }
  mov   ecx,edx     { edx = Len }
  and   edx,3
  shr   ecx,2
  xor   eax,eax     { store zeros }

  { store by dword }
  rep   stosd

  { store by byte }
  mov   ecx,edx
  rep   stosb

  pop   edi
end;
{$ELSE}
asm
  // PBuf: Rcx
  // Len: edx
  push  rdi

  cld

  { load parameters }
  mov   rdi,rcx     { eax = Buf }
  mov   ecx,edx     { edx = Len }
  and   edx,3
  shr   ecx,2
  xor   eax,eax     { store zeros }

  { store by dword }
  rep   stosd

  { store by byte }
  mov   ecx,edx
  rep   stosb

  pop   rdi
end;
{$ENDIF}


function MaxCardinal(A, B: Cardinal): Cardinal; assembler; register;
{$IFNDEF CPUX64}
asm
  cmp   eax,edx       { eax = A, edx = B }
  jae   @1
  mov   eax,edx
@1:
end;
{$ELSE}
asm
  // Max with no jumps.
  // ecx = A
  // edx = B
  sub   ecx,edx   // ecx = A-B
  sbb   eax,eax   //
  not   eax       // eax:= -1 if A>B else 0
  and   eax,ecx   // ecx:= 0 if A>B else A
  add   eax,edx   // eax:= A-B+B = A if A > B, else 0+B=B if B>A
end;
{$ENDIF}
{Buffered file code}

const
  CvtOutBufSize = 4096;

function InitOutFile(var F: PBufferedOutputFile; Name: string): Integer;
var
  Code: Integer;

begin
  F:= AllocMem(SizeOf(TBufferedOutputFile));
  FastZero(F^, SizeOf(TBufferedOutputFile));
  with F^ do begin
    { initialize buffer }
    Buffer:= AllocMem(CvtOutBufSize);
    FastZero(Buffer^, CvtOutBufSize);

    { create the output file }
    Assign(OutFile, name);
    Rewrite(OutFile, 1);
    Code:= -IoResult;
    if (Code < ecOK) then begin
      FreeMem(Buffer, CvtOutBufSize);
      FreeMem(F, SizeOf(TBufferedOutputFile));
      InitOutFile:= Code;
      Exit;
    end;

    InitOutFile:= ecOK;
  end;
end;

procedure CleanupOutFile(var F: PBufferedOutputFile);
begin
  Close(F^.OutFile);
  if (IoResult = 0) then;
  Erase(F^.OutFile);
  if (IoResult = 0) then;
  FreeMem(F^.Buffer, CvtOutBufSize);
  FreeMem(F, SizeOf(TBufferedOutputFile));
end;

function FlushOutFile(var F: PBufferedOutputFile): Integer;
var
  Code: Integer;

begin
  FlushOutFile:= ecOK;

  with F^ do begin
    if (BufPos = 0) then Exit;

    BlockWrite(OutFile, Buffer^, BufPos);
    Code:= -IoResult;
    if (Code < ecOK) then begin
      CleanupOutFile(F);
      FlushOutFile:= Code;
    end
    else BufPos:= 0;
  end;
end;

function WriteOutFile(var F: PBufferedOutputFile; var Data; Len: Cardinal): Integer;
var
  Code: Integer;
  InPosn: Cardinal;
  BytesLeft: Cardinal;
  BytesToWrite: Cardinal;

begin
  WriteOutFile:= ecOK;

  with F^ do
    { will all the new data fit into the output buffer? }
    if ((BufPos + Len) < CvtOutBufSize) then begin
      Move(Data, Buffer^[BufPos], Len);
      Inc(BufPos, Len);
    end else begin
      if (BufPos > 0) then begin
        { move as much data as possible into the buffer and flush it }
        BytesToWrite:= CvtOutBufSize - BufPos;
        InPosn:= BytesToWrite;
        Move(Data, Buffer^[BufPos], BytesToWrite);
        BufPos:= CvtOutBufSize;
        Code:= FlushOutFile(F);
        if (Code < ecOK) then begin
          WriteOutFile:= Code;
          Exit;
        end;
      end else begin
        BytesToWrite:= 0;
        InPosn:= 0;
      end;

      { if there's very little data remaining, buffer it and exit }
      BytesLeft:= Len - BytesToWrite;
      if (BytesLeft < CvtOutBufSize) then begin
        Move(TByteArray(Data)[BytesToWrite], Buffer^, BytesLeft);
        BufPos:= BytesLeft;
        Exit;
      end;

      { round down to nearest multiple of CvtOutBufSize }
      BytesToWrite:= BytesLeft and (not Pred(CvtOutBufSize));
      dec(BytesLeft, BytesToWrite);

      { write out as many chunks of CvtOutBufSize as we can }
      BlockWrite(OutFile, TByteArray(Data)[InPosn], BytesToWrite);
      Code:= -IoResult;
      if (Code < ecOK) then begin
        CleanupOutFile(F);
        WriteOutFile:= Code;
        Exit;
      end;
      Inc(InPosn, BytesToWrite);

      { move the rest of the data into the buffer }
      Move(TByteArray(Data)[InPosn], Buffer^, BytesLeft);
      BufPos:= BytesLeft;
    end;
end;

function SeekOutFile(var F: PBufferedOutputFile; Posn: Integer): Integer;
var
  Code: Integer;

begin
  Code:= FlushOutFile(F);
  if (Code < ecOK) then begin
    SeekOutFile:= Code;
    Exit;
  end;

  Seek(F^.OutFile, Posn);
  Code:= -IoResult;
  if (Code < ecOK) then CleanupOutFile(F);
  SeekOutFile:= Code;
end;

function OutFilePosn(var F: PBufferedOutputFile): Integer;
begin
  with F^ do OutFilePosn:= FilePos(OutFile) + BufPos;
end;

function CloseOutFile(var F: PBufferedOutputFile): Integer;
var
  Code: Integer;

begin
  { flush any remaining data }
  Code:= FlushOutFile(F);
  if (Code < ecOK) then begin
    CloseOutFile:= Code;
    Exit;
  end;

  with F^ do begin
    { close the output file }
    Close(OutFile);
    Code:= -IoResult;
    if (Code < ecOK) then begin
      Erase(OutFile);
      if (IoResult = 0) then;
    end;
    CloseOutFile:= Code;
    FreeMem(Buffer, CvtOutBufSize);
    FreeMem(F, SizeOf(TBufferedOutputFile));
  end;
end;

{ Abstract fax conversion routines }

procedure acInitDataLine(Cvt: PAbsFaxCvt);
{ -Initialize the converter's line buffer }
begin
  with Cvt^ do begin
    FastZero(DataLine^, MaxData);
    ByteOfs:= 0;
    BitOfs:= 0;
  end;
end;

procedure acInitFaxConverter(var Cvt: PAbsFaxCvt; Data: Pointer; CB: TGetLineCallback;
  OpenFile: TOpenFileCallback; CloseFile: TCloseFileCallback; DefaultExt: string);
{ -Initialize a fax converter engine }
begin

  New(Cvt); // Cvt := AllocMem(SizeOf(TAbsFaxCvt));

  { initialize converter structure }
  with Cvt^ do begin
    Flags:= DefFaxCvtOptions;
    ResWidth:= StandardWidth;
    LeftMargin:= DefLeftMargin;
    TopMargin:= DefTopMargin;
    UserData:= Data;
    GetLine:= CB;
    OpenCall:= OpenFile;
    CloseCall:= CloseFile;
    InFileName:= '';
    DefExt:= DefaultExt;

    { initialize compression buffer }
    DataLine:= AllocMem(MaxData);

    { initialize temporary buffer }
    TmpBuffer:= AllocMem(MaxData);
  end;

  acInitDataLine(Cvt);
end;

procedure acDoneFaxConverter(var Cvt: PAbsFaxCvt);
{ -Destroy a fax converter engine }
begin
  with Cvt^ do begin
    FreeMem(DataLine, MaxData);
    FreeMem(TmpBuffer, MaxData);
  end;

  Dispose(Cvt); // FreeMem(Cvt, SizeOf(TAbsFaxCvt));
  Cvt:= nil;
end;

procedure acSetOtherData(Cvt: PAbsFaxCvt; OtherData: Pointer);
{ -Set other data pointer }
begin
  Cvt^.OtherData:= OtherData;
end;

procedure acOptionsOn(Cvt: PAbsFaxCvt; OptionFlags: Word);
{ -Activate multiple fax converter options }
begin
  with Cvt^ do Flags:= Flags or (OptionFlags and not Cardinal(BadFaxCvtOptions));
end;

procedure acOptionsOff(Cvt: PAbsFaxCvt; OptionFlags: Word);
{ -Deactivate multiple options }
begin
  with Cvt^ do Flags:= Flags and not(OptionFlags and not BadFaxCvtOptions);
end;

function acOptionsAreOn(Cvt: PAbsFaxCvt; OptionFlags: Word): Bool;
{ -Return True if all specified options are on }
begin
  with Cvt^ do acOptionsAreOn:= ((Flags and OptionFlags) = OptionFlags);
end;

procedure acSetMargins(Cvt: PAbsFaxCvt; Left, Top: Cardinal);
{ -Set left and top margins for converter }
begin
  with Cvt^ do begin
    LeftMargin:= Left;
    TopMargin:= Top;
  end;
end;

procedure acSetResolutionMode(Cvt: PAbsFaxCvt; HiRes: Bool);
{ -Select standard or high resolution mode }
begin
  Cvt^.UseHighRes:= HiRes;
end;

procedure acSetResolutionWidth(Cvt: PAbsFaxCvt; RW: Cardinal);
{ -Select standard (1728 pixels) or wide (2048 pixels) width }
begin
  with Cvt^ do
    if (RW = rw2048) then ResWidth:= WideWidth
    else ResWidth:= StandardWidth;
end;

procedure acSetStationID(Cvt: PAbsFaxCvt; ID: AnsiString);
{ -Set the station ID of the converter }
begin
  with Cvt^ do StationID:= ID;
end;

procedure acSetStatusCallback(Cvt: PAbsFaxCvt; CB: TCvtStatusCallback);
{ -Set the procedure called for conversion status }
begin
  if (@CB <> nil) then begin
    Cvt^.StatusWnd:= 0;
    Cvt^.StatusFunc:= CB;
  end;
end;

procedure acSetStatusWnd(Cvt: PAbsFaxCvt; HWindow: TApdHwnd);
{ -Set the handle of the window that receives status messages }
begin
  if (HWindow <> 0) then begin
    Cvt^.StatusFunc:= nil;
    Cvt^.StatusWnd:= HWindow;
  end;
end;

procedure acAddCodePrim(Cvt: PAbsFaxCvt; Code: Word; SignificantBits: Word); assembler; register;
{ -Lowlevel routine to add a runlength code to the line buffer }
{$IFNDEF CPUX64}
asm
  push  esi
  push  edi
  push  ebx

  { load parameters }
  xor   ebx,ebx
  mov   bx,cx       { cx = SignificantBits }
  and   edx,$0000FFFF

  mov   ecx,TAbsFaxCvt([eax]).BitOfs
  mov   esi,ecx     { save copy of bit offset }
  or    ecx,ecx
  jz    @1

  shl   edx,cl      { shift code for bit offset }

@1: mov   edi,TAbsFaxCvt([eax]).ByteOfs
  add   esi,ebx
  mov   ecx,esi
  shr   ecx,3
  add   TAbsFaxCvt([eax]).ByteOfs,ecx
  and   esi,7
  mov   TAbsFaxCvt([eax]).BitOfs,esi

  mov   eax,TAbsFaxCvt([eax]).DataLine
  add   eax,edi
  or    [eax],dx
  shr   edx,16
  or    [eax+2],dl

  pop   ebx
  pop   edi
  pop   esi
end;
{$ELSE}
asm
  // Cvt : PAbsFaxCvt => RCX
  // Code : Word;     => dx
  // SignificantBits  => R8w
  push  rsi
  push  rdi
  push  rbx

  { load parameters }
  mov   rax,rcx
  // xor   ebx,ebx
  mov   rbx,r8       { bx = SignificantBits }
  and   edx,$0000FFFF

  mov   ecx,TAbsFaxCvt([rax]).BitOfs
  mov   esi,ecx     { save copy of bit offset }
  or    ecx,ecx
  jz    @1

  shl   edx,cl      { shift code for bit offset }

@1: mov   edi,TAbsFaxCvt([rax]).ByteOfs
  add   esi,ebx
  mov   ecx,esi
  shr   ecx,3
  add   TAbsFaxCvt([rax]).ByteOfs,ecx
  and   esi,7
  mov   TAbsFaxCvt([rax]).BitOfs,esi

  mov   rax,TAbsFaxCvt([rax]).DataLine
  add   eax,edi
  or    [rax],dx
  shr   edx,16
  or    [rax+2],dl

  pop   rbx
  pop   rdi
  pop   rsi
end;
{$ENDIF}

procedure acAddCode(Cvt: PAbsFaxCvt; RunLen: Cardinal; IsWhite: Boolean); assembler; register;
{ -Adds a code representing RunLen pixels of white (IsWhite=True) or black
  to the current line buffer }
{$IFNDEF CPUX64}
asm
  push  esi
  push  edi

  { load parameters }
  mov   edi,eax     { eax = Cvt }

  { long run? }
  cmp   edx,64
  jb    @2

  { long white run? }
  or    cl,cl
  jz    @1

  { long white run }
  push  edx
  shr   edx,6
  dec   edx
  mov   esi,offset WhiteMUTable
  mov   eax,edi
  mov   cx,word ptr [edx*4+esi+2]
  mov   dx,word ptr [edx*4+esi]
  call  acAddCodePrim
  pop   edx
  and   edx,63
  mov   esi,offset WhiteTable
  jmp   @4

  { long black run }
@1: push  edx
  shr   edx,6
  dec   edx
  mov   esi,offset BlackMUTable
  mov   eax,edi
  mov   cx,word ptr [edx*4+esi+2]
  mov   dx,word ptr [edx*4+esi]
  call  acAddCodePrim
  pop   edx
  and   edx,63
  mov   esi,offset BlackTable
  jmp   @4

  { Short white run? }
@2: or    cl,cl
  jz    @3

  { short white run }
  mov   esi,offset WhiteTable
  jmp   @4

  { short black run }
@3: mov   esi,offset BlackTable

  { add last code }
@4: mov   eax,edi
  mov   cx,word ptr [edx*4+esi+2]
  mov   dx,word ptr [edx*4+esi]
  call  acAddCodePrim

@5: pop   edi
  pop   esi
end;
{$ELSE}
asm
  // Cvt : PAbsFaxCvt;   => RCX
  // RunLen : Cardinal;  => EDX
  // IsWhite : Boolean   => R8b
  push  rsi
  push  rdi

  { load parameters }
  mov   rdi,rcx     { eax = Cvt }
  mov   rcx,r8

  { long run? }
  cmp   edx,64
  jb    @2

  { long white run? }
  or    cl,cl
  jz    @1

  { long white run }
  push  rdx
  shr   rdx,6
  dec   rdx
  mov   rsi,offset WhiteMUTable
  mov   rax,rdi
  mov   cx,word ptr [rdx*4+rsi+2]
  mov   dx,word ptr [rdx*4+rsi]
  call  acAddCodePrim
  pop   rdx
  and   rdx,63
  mov   rsi,offset WhiteTable
  jmp   @4

  { long black run }
@1: push  rdx
  shr   rdx,6
  dec   rdx
  mov   rsi,offset BlackMUTable
  mov   rax,rdi
  mov   cx,word ptr [rdx*4+rsi+2]
  mov   dx,word ptr [rdx*4+rsi]
  call  acAddCodePrim
  pop   rdx
  and   rdx,63
  mov   rsi,offset BlackTable
  jmp   @4

  { Short white run? }
@2: or    cl,cl
  jz    @3

  { short white run }
  mov   rsi,offset WhiteTable
  jmp   @4

  { short black run }
@3: mov   rsi,offset BlackTable

  { add last code }
@4: mov   rax,rdi
  mov   cx,word ptr [rdx*4+rsi+2]
  mov   dx,word ptr [rdx*4+rsi]
  call  acAddCodePrim

@5: pop   rdi
  pop   rsi
end;
{$ENDIF}

{$IFNDEF CPUX64}
procedure CountRunsAndAddCodes(Cvt: PAbsFaxCvt; var Buffer);
{ walk the pixel array, counting runlengths and adding codes to match }
var
  SaveCvt: PAbsFaxCvt;
  RunLen: Integer;
  Width: Integer;
  Margin: Integer;
  TotalRunWidth: Integer;
  TotalRun: Integer;
  IsWhite: Boolean;
  PrevWhite: Boolean;
  DblWdth: Boolean; { D6 }
  P: PByte;
  B: Byte;

begin
  SaveCvt:= Cvt;

  with Cvt^ do begin
    { Add margin }
    Width:= ResWidth;
    TotalRunWidth:= ResWidth;
    Margin:= LeftMargin;
    TotalRun:= 0;
    P:= PByte(@Buffer);
    B:= P^;
    PrevWhite:= ((B and $80) = 0);
    if PrevWhite then begin
      RunLen:= Succ(Margin);
      IsWhite:= True;
    end else begin
      { add margin, or a zero-runlength white code if there isn't one }
      RunLen:= 1;
      acAddCode(Cvt, LeftMargin, True);
      dec(TotalRunWidth, Margin);
      IsWhite:= False;
    end;

    DblWdth:= DoubleWidth; { D6 }

    asm
      push  edi
      push  ebx

      mov   dl,B
      mov   dh,$40
      movzx ebx,PrevWhite
      mov   bh,bl
      mov   ecx,Width
      sub   ecx,Margin

      { get NewWhite }
    @1: mov   bl,1
      test  dl,dh
      jz    @2
      dec   bl

      { update mask and get new byte if needed }
    @2: mov   al,dh
      shr   al,1
      jnz   @3
      inc   dword ptr P
      mov   edi,P
      mov   dl,byte ptr [edi]
      mov   al,$80
    @3: mov   dh,al

      { NewWhite = PrevWhite? }
      cmp   bh,bl
      jne   @4

      { Last pixel? }
      cmp   ecx,1
      jne   @5
      test  DblWdth,1{ D6 }
      jz    @4
      mov   eax,TotalRunWidth
      sub   eax,TotalRun
      mov   RunLen,eax
      shr   RunLen,1

      { Save registers }
    @4: push  eax
      push  edx
      push  ecx

      { Add output code }
      test  DblWdth,1{ D6 }
      jz    @6
      shl   RunLen,1
    @6:
      { Increment TotalRun }
      mov   eax,TotalRun
      add   eax,RunLen
      mov   TotalRun,eax

      mov   eax,SaveCvt
      mov   edx,RunLen
      movzx ecx,IsWhite
      call  acAddCode

      { Restore registers }
      pop   ecx
      pop   edx
      pop   eax

      { Update state }
      xor   IsWhite,1
      mov   RunLen,0
      mov   bh,bl

      { Increment RunLen and loop }
    @5: inc   RunLen
      dec   ecx
      jnz   @1

      pop   ebx
      pop   edi
    end;
  end;
end;
{$ELSE}
procedure CountRunsAndAddCodes(Cvt: PAbsFaxCvt; var Buffer);
{ walk the pixel array, counting runlengths and adding codes to match }
var
  SaveCvt: PAbsFaxCvt;
  RunLen: Integer;
  Width: Integer;
  Margin: Integer;
  TotalRunWidth: Integer;
  TotalRun: Integer;
  IsWhite: Boolean;
  PrevWhite: Boolean;
  DblWdth: Boolean; { D6 }
  P: PByte;
  B: Byte;

  procedure AsmProcedure;
  asm
    push  rdi
    push  rbx

    mov   edx,$4000
    mov   dl,B
    movzx ebx,PrevWhite
    mov   bh,bl
    mov   ecx,Width
    sub   ecx,Margin

    { get NewWhite }
  @1: mov   bl,1
    test  dl,dh
    jz    @2
    dec   bl

    { update mask and get new byte if needed }
  @2: mov   al,dh
    shr   al,1
    jnz   @3
    inc   dword ptr P
    mov   rdi,P
    mov   dl,byte ptr [rdi]
    mov   al,$80
  @3: mov   dh,al

    { NewWhite = PrevWhite? }
    cmp   bh,bl
    jne   @4

    { Last pixel? }
    cmp   ecx,1
    jne   @5
    test  DblWdth,1{ D6 }
    jz    @4
    mov   eax,TotalRunWidth
    sub   eax,TotalRun
    mov   RunLen,eax
    shr   RunLen,1

    { Save registers }
  @4: push  rax
    push  rdx
    push  rcx

    { Add output code }
    test  DblWdth,1{ D6 }
    jz    @6
    shl   RunLen,1
  @6:
    { Increment TotalRun }
    mov   eax,TotalRun
    add   eax,RunLen
    mov   TotalRun,eax

    mov   rcx,SaveCvt
    mov   edx,RunLen
    movzx r8d,IsWhite
    call  acAddCode

    { Restore registers }
    pop   rcx
    pop   rdx
    pop   rax

    { Update state }
    xor   IsWhite,1
    mov   RunLen,0
    mov   bh,bl

    { Increment RunLen and loop }
  @5: inc   RunLen
    dec   ecx
    jnz   @1

    pop   rbx
    pop   rdi
  end;

  begin
    SaveCvt:= Cvt;

    with Cvt^ do begin
      { Add margin }
      Width:= ResWidth;
      TotalRunWidth:= ResWidth;
      Margin:= LeftMargin;
      TotalRun:= 0;
      P:= PByte(@Buffer);
      B:= P^;
      PrevWhite:= ((B and $80) = 0);
      if PrevWhite then begin
        RunLen:= Succ(Margin);
        IsWhite:= True;
      end else begin
        { add margin, or a zero-runlength white code if there isn't one }
        RunLen:= 1;
        acAddCode(Cvt, LeftMargin, True);
        dec(TotalRunWidth, Margin);
        IsWhite:= False;
      end;

      DblWdth:= DoubleWidth; { D6 }
      AsmProcedure;
    end;
  end;
{$ENDIF}


{$IFNDEF CPUX64}

procedure acCompressRasterLine(Cvt: PAbsFaxCvt; var Buffer);
{ -compress a raster line of bits into runlength codes }
var
  Width: Cardinal;
  P: PByte;
  IsWhite: Boolean;

begin
  with Cvt^ do begin
    { clear used portion of previous line }
    FastZero(DataLine^, ByteOfs + 1);

    ByteOfs:= 0;
    BitOfs:= 0;

    { add EOL code }
    acAddCodePrim(Cvt, LongEOLRec.Code, LongEOLRec.Sig);

    { is the line all white? }
    P:= PByte(@Buffer);
    Width:= ResWidth;

    asm
      push  edi
      mov   edi,P
      xor   eax,eax
      mov   ecx,Width
      shr   ecx,3
      cld
      repe  scasb
      mov   IsWhite,True
      je    @1
      mov   IsWhite,False
    @1: pop   edi
    end;

    if IsWhite then
      { yes; add a single code for the all-white line }
        acAddCode(Cvt, Width, True)

    else CountRunsAndAddCodes(Cvt, Buffer);

    { Make sure there are at least LinePadSize nulls after the data }
    ByteOfs:= ByteOfs + LinePadSize;
  end;
end;
{$ELSE}

procedure acCompressRasterLine(Cvt: PAbsFaxCvt; var Buffer);
{ -compress a raster line of bits into runlength codes }
var
  Width: Cardinal;
  P: PByte;
  IsWhite: Boolean;

  procedure AsmProcedure;
  asm
    push  rdi
    mov   rdi,P
    xor   eax,eax
    mov   ecx,Width
    shr   ecx,3
    cld
    repe  scasb
    mov   IsWhite,True
    je    @1
    mov   IsWhite,False
  @1: pop   rdi
  end;

  begin
    with Cvt^ do begin
      { clear used portion of previous line }
      FastZero(DataLine^, ByteOfs + 1);

      ByteOfs:= 0;
      BitOfs:= 0;

      { add EOL code }
      acAddCodePrim(Cvt, LongEOLRec.Code, LongEOLRec.Sig);

      { is the line all white? }
      P:= PByte(@Buffer);
      Width:= ResWidth;

      AsmProcedure;

      if IsWhite then
        { yes; add a single code for the all-white line }
          acAddCode(Cvt, Width, True)

      else CountRunsAndAddCodes(Cvt, Buffer);

      { Make sure there are at least LinePadSize nulls after the data }
      ByteOfs:= ByteOfs + LinePadSize;
    end;
  end;
{$ENDIF}

function acConvertStatus(Cvt: PAbsFaxCvt; StatFlags: Word): Integer;
begin
  acConvertStatus:= ecOK;

  with Cvt^ do begin
    if (StatusWnd <> 0) then begin
      if (SendMessage(StatusWnd, apw_FaxCvtStatus, StatFlags, Integer(Cvt)) <> 0) then
          acConvertStatus:= ecConvertAbort;
    end else if (@StatusFunc <> nil) then
      if StatusFunc(Cvt, StatFlags, BytesRead, BytesToRead) then acConvertStatus:= ecConvertAbort;
  end;
end;

function acOpenFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a converter input file }
begin
  with Cvt^ do
    if (@OpenCall <> nil) then acOpenFile:= OpenCall(Cvt, FileName)
    else acOpenFile:= ecOK;
end;

procedure acCloseFile(Cvt: PAbsFaxCvt);
{ -Close a converter input file }
begin
  with Cvt^ do
    if (@CloseCall <> nil) then CloseCall(Cvt);
end;

function acGetRasterLine(Cvt: PAbsFaxCvt; var Data; var Len: Integer;
  var EndOfPage, MorePages: Bool): Integer;
{ -Read a raster line from an input file }
var
  Code: Integer;

begin
  with Cvt^ do begin
    Inc(CurrLine);
    Code:= GetLine(Cvt, Data, Len, EndOfPage, MorePages);
    if (Code = ecOK) then Code:= acConvertStatus(Cvt, 0);
    acGetRasterLine:= Code;
  end;
end;

function acAddData(Cvt: PAbsFaxCvt; var Buffer; Len: Cardinal; DoInc: Bool): Integer;
{ -Add a block of data to the output file }
begin
  with Cvt^ do begin
    { write the data to the file }
    acAddData:= WriteOutFile(OutFile, Buffer, Len);

    { increment the length of the image data }
    if DoInc then Inc(PageHeader.ImgLength, Len);
  end;
end;

function acAddLine(Cvt: PAbsFaxCvt; var Buffer; Len: Cardinal): Integer;
{ -Add a line of image data to the file }
var
  Code: Integer;

begin
  { add a length word for the data }
  Code:= acAddData(Cvt, Len, SizeOf(Word), True);

  { add the data }
  if (Code = ecOK) then Code:= acAddData(Cvt, Buffer, Len, True);
  acAddLine:= Code;
end;

procedure acMakeEndOfPage(Cvt: PAbsFaxCvt; var Buffer; var Len: Integer);
{ -Encode end-of-page data into Buffer }
var
  I: Cardinal;

begin
  with Cvt^ do begin
    acInitDataLine(Cvt);
    acAddCodePrim(Cvt, LongEOLRec.Code, LongEOLRec.Sig);
    for I:= 1 to 7 do acAddCodePrim(Cvt, EOLRec.Code, EOLRec.Sig);

    Move(DataLine^, Buffer, ByteOfs);
    Len:= ByteOfs;
  end;
end;

function acOutToFileCallback(Cvt: PAbsFaxCvt; var Data; Len: Integer;
  EndOfPage, MorePages: Bool): Integer;
{ -Output a compressed raster line to an APF file }
var
  Code: Integer;
  I: Integer;

  function UpdatePageHeader: Integer;
  { -update the current page's header }
  label
    Breakout;

  var
    Code: Integer;
    L: Integer;

  begin
    with Cvt^ do begin
      { save current file position for later }
      L:= OutFilePosn(OutFile);

      { go to the page header }
      Code:= SeekOutFile(OutFile, CurPagePos);
      if (Code < ecOK) then goto Breakout;

      { update the header }
      Code:= WriteOutFile(OutFile, PageHeader, SizeOf(TPageHeaderRec));
      if (Code < ecOK) then goto Breakout;

      { return to original position }
      Code:= SeekOutFile(OutFile, L);

    Breakout:
      UpdatePageHeader:= Code;
    end;
  end;

begin
  acOutToFileCallback:= ecOK;

  with Cvt^ do begin
    if EndOfPage then begin
      { make end of page marker }
      acInitDataLine(Cvt);
      acAddCodePrim(Cvt, LongEOLRec.Code, LongEOLRec.Sig);
      for I:= 1 to 7 do acAddCodePrim(Cvt, EOLRec.Code, EOLRec.Sig);

      { add end of page to output }
      Code:= acAddLine(Cvt, DataLine^, ByteOfs);
      if (Code < ecOK) then begin
        acOutToFileCallback:= Code;
        Exit;
      end;

      { increment page count }
      Inc(MainHeader.PageCount);
      Code:= UpdatePageHeader;
      if (Code < ecOK) then begin
        acOutToFileCallback:= Code;
        Exit;
      end;
    end else if (LastPage <> CurrPage) then begin
      { create the page header }
      FastZero(PageHeader, SizeOf(PageHeader));
      with PageHeader do begin
        ImgFlags:= ffLengthWords;
        if UseHighRes then ImgFlags:= ImgFlags or ffHighRes;
        if (ResWidth = WideWidth) then ImgFlags:= ImgFlags or ffHighWidth;
      end;

      { put the page header to the file }
      CurPagePos:= OutFilePosn(OutFile);
      Code:= acAddData(Cvt, PageHeader, SizeOf(PageHeader), False);
      if (Code < ecOK) then begin
        acOutToFileCallback:= Code;
        Exit;
      end;

      LastPage:= CurrPage;
    end;

    if not EndOfPage then acOutToFileCallback:= acAddLine(Cvt, Data, Len);
  end;
end;

function ConverterYield: Integer;
{ -Yield a timeslice to other windows procedures }
var
  Msg: TMsg;

begin
  ConverterYield:= ecOK;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
    if (Msg.Message = wm_Quit) then begin
      PostQuitMessage(Msg.wParam);
      ConverterYield:= ecGotQuitMsg;
    end else begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
      ConverterYield:= ecOK;
    end;
end;

function acCreateOutputFile(Cvt: PAbsFaxCvt): Integer;
{ -Create an APF file }
var
  Code: Integer;
begin
  with Cvt^ do begin
    { initialize fax file and page headers }
    FastZero(MainHeader, SizeOf(MainHeader));
    Move(DefAPFSig, MainHeader.Signature, SizeOf(MainHeader.Signature));
    MainHeader.PageOfs:= SizeOf(MainHeader);
    FastZero(PageHeader, SizeOf(PageHeader));

    { create output file }
    Code:= InitOutFile(OutFile, OutFileName);
    if (Code = ecOK) then Code:= WriteOutFile(OutFile, MainHeader, SizeOf(MainHeader));

    acCreateOutputFile:= Code;
  end;
end;

function acCloseOutputFile(Cvt: PAbsFaxCvt): Integer;
{ -Close an APF file }
var
  Code: Integer;

  function GetPackedDateTime: Integer;
  { -Get the current date and time in BP7 packed date format }
  var
    DT: TDateTime;
  begin
    DT:= Now;
    Result:= DateTimeToFileDate(DT);
  end;

  function UpdateMainHeader: Integer;
  { -update the contents of the main header in the file }
  label
    Breakout;

  var
    Code: Integer;
    L: Integer;
    SLen: Cardinal;

  begin
    with Cvt^ do begin
      { refresh needed fields of MainHeader rec }
      with MainHeader do begin
        SenderID:= StationID;
        SLen:= Length(SenderID);
        if (SLen < 20) then FillChar(SenderID[Succ(SLen)], 20 - SLen, 32);

        FDateTime:= GetPackedDateTime;
      end;

      { save current file position for later }
      L:= OutFilePosn(OutFile);

      { seek to head of file }
      Code:= SeekOutFile(OutFile, 0);
      if (Code < ecOK) then goto Breakout;

      { write the header }
      Code:= WriteOutFile(OutFile, MainHeader, SizeOf(MainHeader));
      if (Code < ecOK) then goto Breakout;

      { return to original position }
      Code:= SeekOutFile(OutFile, L);

    Breakout:
      UpdateMainHeader:= Code;
    end;
  end;

begin
  Code:= UpdateMainHeader;
  if (Code = ecOK) then Code:= CloseOutFile(Cvt^.OutFile);

  acCloseOutputFile:= Code;
end;


function acConvertToFile(Cvt: PAbsFaxCvt; FileName, DestFile: string): Integer;
{ -Convert an image to a fax file }
var
  Code: Integer;

label
  ErrorExit;

  function CreateOutputFile: Integer;
  { -Create the output fax file }
  begin
    with Cvt^ do begin
      if (DestFile = '') then begin
        // {create an APF file name in the source file's directory}
        // JustPathNameZ(OutFileName, FileName);
        // AddBackslashZ(OutFileName, OutfileName);
        //
        // {get name of output file}
        // JustFileNameZ(OutFileName + StrLen(OutFileName), FileName);
        // ForceExtensionZ(OutFileName, OutFileName, FaxFileExt);
        OutFileName:= ChangeFileExt(FileName, '.' + FaxFileExt);

      end
      else DefaultExtensionZ(OutFileName, DestFile, FaxFileExt);

      { create the output file }
      CreateOutputFile:= acCreateOutputFile(Cvt);
    end;
  end;

begin
  with Cvt^ do begin
    { create the output file }
    Code:= CreateOutputFile;
    if (Code < ecOK) then goto ErrorExit;

    { convert the file }
    Code:= acConvert(Cvt, FileName, acOutToFileCallback);
    if (Code < ecOK) then begin
      CleanupOutFile(OutFile);
      goto ErrorExit;
    end;

    { update main header of fax file and close file }
    Code:= acCloseOutputFile(Cvt);
    if (Code < ecOK) then CleanupOutFile(OutFile);

  ErrorExit:
    acConvertToFile:= Code;
  end;
end;


function acConvert(Cvt: PAbsFaxCvt; FileName: string; OutCallback: TPutLineCallback): Integer;
{ -Convert an input file, sending data to OutHandle or to OutCallback }
const
  WhiteLine: array[1 .. 6] of Ansichar = #$00#$80#$B2'Y'#$01#$00;
var
  Code: Integer;
  MorePages: Bool;
  EndOfPage: Bool;
  I: Cardinal;
  Len: Integer;
  BytesPerLine: Cardinal;
label
  ErrorExit;

  function OutputDataLine: Integer;
  begin
    with Cvt^ do
      if (@OutCallback <> nil) then
          OutputDataLine:= OutCallback(Cvt, DataLine^, ByteOfs, False, False)
      else OutputDataLine:= ecOK;
  end;

  function DoEndOfPage: Integer;
  begin
    with Cvt^ do
      if (@OutCallback <> nil) then DoEndOfPage:= OutCallback(Cvt, DataLine^, 0, True, MorePages)
      else DoEndOfPage:= ecOK;
  end;

begin
  with Cvt^ do begin
    { initialize position counter }
    CurrPage:= 0;
    CurrLine:= 0;

    BytesPerLine:= ResWidth div 8;

    { provide an extension if the user didn't }
    DefaultExtensionZ(InFileName, FileName, DefExt);

    { show the initial status }
    Code:= acConvertStatus(Cvt, csStarting);
    if (Code < ecOK) then begin
      acConvert:= Code;
      Exit;
    end;

    { open the input file }
    Code:= acOpenFile(Cvt, InFileName);
    if (Code < ecOK) then begin
      acConvert:= Code;
      Exit;
    end;

    MorePages:= True;

    while MorePages do begin
      Inc(CurrPage);
      CurrLine:= 0;

      { Add top margin }
      for I:= 1 to TopMargin do begin
        acInitDataLine(Cvt);
        Move(WhiteLine, DataLine^[0], 6);
        ByteOfs:= 6;
        Code:= OutputDataLine;
        if (Code < ecOK) then goto ErrorExit;
      end;

      { make initial call to GetLine function }
      FastZero(TmpBuffer^, BytesPerLine);
      Code:= acGetRasterLine(Cvt, TmpBuffer^, Len, EndOfPage, MorePages);
      if (Code < ecOK) then goto ErrorExit;

      { read and compress raster lines until the end of the page }
      while not EndOfPage do begin
        if not HalfHeight or (HalfHeight and Odd(CurrLine)) then begin
          acCompressRasterLine(Cvt, TmpBuffer^);
          Code:= OutputDataLine;
          if (Code < ecOK) then goto ErrorExit;
        end;

        { read the next line }
        FastZero(TmpBuffer^, BytesPerLine);
        Code:= acGetRasterLine(Cvt, TmpBuffer^, Len, EndOfPage, MorePages);
        if (Code < ecOK) then goto ErrorExit;

        if FlagIsSet(Flags, fcYield) and FlagIsSet(Flags, fcYieldOften) and ((CurrLine and 15) = 0)
        then begin
          Code:= ConverterYield;
          if (Code < ecOK) then goto ErrorExit;
        end;
      end;

      if PadPage then begin { !!.04 }
        { Add bottom margin }                                            { !!.04 }
        for I:= CurrLine to 2155 do begin { !!.04 }
          acInitDataLine(Cvt); { !!.04 }
          Move(WhiteLine, DataLine^[0], 6); { !!.04 }
          ByteOfs:= 6; { !!.04 }
          Code:= OutputDataLine; { !!.04 }
          if (Code < ecOK) then { !!.04 }
              goto ErrorExit; { !!.04 }
        end; { !!.04 }
      end; { !!.04 }

      Code:= DoEndOfPage;
      if (Code < ecOK) then goto ErrorExit;

      { yield if the user wants it }
      if FlagIsSet(Flags, fcYield) then begin
        Code:= ConverterYield;
        if (Code < ecOK) then goto ErrorExit;
      end;
    end;
  end;

  Code:= ecOK;

ErrorExit:
  { show final status }
  acConvertStatus(Cvt, csEnding);
  acCloseFile(Cvt);
  acConvert:= Code;
end;


{$IFNDEF PRNDRV}

{Text-to-fax conversion routines}

procedure fcInitTextConverter(var Cvt: PAbsFaxCvt);
var
  TextCvtData: PTextFaxData;
begin
  Cvt:= nil;

  { Initialize text converter specific data }
  TextCvtData:= AllocMem(SizeOf(TTextFaxData));

  TextCvtData^.ReadBuffer:= AllocMem(ReadBufferSize);
  TextCvtData^.FontPtr:= AllocMem(MaxFontBytes);

  TextCvtData^.TabStop:= DefFaxTabStop;
  TextCvtData^.IsExtended:= False;

  { initialize the abstract converter }
  acInitFaxConverter(Cvt, TextCvtData, fcGetTextRasterLine, fcOpenFile, fcCloseFile, DefTextExt);
end;


procedure fcInitTextExConverter(var Cvt: PAbsFaxCvt);
{ -Initialize an extended text-to-fax converter }
var
  TextCvtData: PTextFaxData;
begin
  Cvt:= nil;

  { Initialize text converter specific data }
  TextCvtData:= AllocMem(SizeOf(TTextFaxData));

  TextCvtData^.ReadBuffer:= AllocMem(ReadBufferSize);
  TextCvtData^.Bitmap:= Graphics.TBitmap.Create;
  TextCvtData^.Bitmap.Monochrome:= True;

  TextCvtData^.TabStop:= DefFaxTabStop;
  TextCvtData^.IsExtended:= True;

  TextCvtData^.ImageData:= nil;
  TextCvtData^.ImageSize:= 0;

  { initialize the abstract converter }
  acInitFaxConverter(Cvt, TextCvtData, fcGetTextRasterLine, fcOpenFile, fcCloseFile, DefTextExt);
end;


procedure fcDoneTextConverter(var Cvt: PAbsFaxCvt);
{ -Destroy a text-to-fax converter }
begin
  with PTextFaxData(Cvt^.UserData)^ do begin
    FreeMem(FontPtr, MaxFontBytes);
    FreeMem(ReadBuffer, ReadBufferSize);
  end;
  FreeMem(Cvt^.UserData, SizeOf(TTextFaxData));

  acDoneFaxConverter(Cvt);
end;


procedure fcDoneTextExConverter(var Cvt: PAbsFaxCvt);
{ -Destroy an extended text-to-fax converter }
begin
  with PTextFaxData(Cvt^.UserData)^ do begin
    FreeMem(ReadBuffer, ReadBufferSize);
    Bitmap.Free;
    FreeMem(ImageData, ImageSize);
  end;
  FreeMem(Cvt^.UserData, SizeOf(TTextFaxData));

  acDoneFaxConverter(Cvt);
end;

procedure fcSetTabStop(Cvt: PAbsFaxCvt; TabStop: Cardinal);
{ -Set the number of spaces equivalent to a tab character }
begin
  if (TabStop = 0) then Exit;

  PTextFaxData(Cvt^.UserData)^.TabStop:= TabStop;
end;

function fcLoadFont(Cvt: PAbsFaxCvt; FileName: PAnsiChar; FontHandle: Cardinal;
  HiRes: Bool): Integer;
{ -Load selected font from APFAX.FNT or memory }
{$IFNDEF BindFaxFont}
label
  Error;

var
  ToRead: Cardinal;
  ActRead: Cardinal;
  SaveMode: Integer;
  Code: Integer;
  F: file;
{$ELSE}
var
  P: Pointer;
  ResHandle: THandle;
  MemHandle: THandle;
  Len: Cardinal;
  {$ENDIF}
  I: Integer;
  J: Integer;
  Row: Cardinal;
  NewRow: Cardinal;
  NewBytes: Cardinal;

begin
  with Cvt^, PTextFaxData(Cvt^.UserData)^ do begin
    {$IFDEF BindFaxFont}
    { find resource for font }
    ResHandle:= FindResource(HInstance, AwFontResourceName, AwFontResourceType);
    if (ResHandle = 0) then begin
      fcLoadFont:= ecFontFileNotFound;
      Exit;
    end;

    { get handle to font data }
    MemHandle:= LoadResource(HInstance, ResHandle);
    if (MemHandle = 0) then begin
      fcLoadFont:= ecFontFileNotFound;
      Exit;
    end;

    { turn font handle into pointer }
    P:= Pointer(MemHandle);

    { get data about font }
    if (FontHandle = StandardFont) then begin
      P:= GetPtr(P, Cardinal(SmallFont) * 256);
      FontRec:= StandardFontRec;
    end
    else FontRec:= SmallFontRec;
    Len:= Integer(FontHandle) * 256;

    { get font data }
    Move(P^, FontPtr^, Len);

    { scale up font if HiRes requested }
    if HiRes then
      with FontRec do begin
        { allocate temporary buffer for scaled up font }
        NewBytes:= Bytes * 2;

        { double raster lines of font }
        for J:= 255 downto 0 do begin
          NewRow:= 0;
          Row:= 0;
          for I:= 1 to Height do begin
            Move(FontPtr^[(Cardinal(J) * Bytes) + Row],
              FontPtr^[(Cardinal(J) * NewBytes) + NewRow], Width);
            Move(FontPtr^[(Cardinal(J) * Bytes) + Row],
              FontPtr^[(Cardinal(J) * NewBytes) + NewRow + Width], Width);
            Inc(Row, Width);
            Inc(NewRow, Width * 2);
          end;
        end;

        { adjust FontRec }
        Bytes:= NewBytes;
        Height:= Height * 2;
      end;

    FreeResource(MemHandle);

    FontLoaded:= True;
    fcLoadFont:= ecOK;

  end;
    {$ELSE}
    { assume failure }
    FontLoaded:= False;

    { open font file }
    SaveMode:= FileMode;
    FileMode:= ApdShareFileRead;
    Assign(F, FileName);
    Reset(F, 1);
    FileMode:= SaveMode;
    Code:= -IoResult;
    if (Code = ecFileNotFound) or (Code = ecPathNotFound) then Code:= ecFontFileNotFound;
    if (Code < ecOK) then begin
      fcLoadFont:= Code;
      Exit;
    end;

    { initialize font }
    FastZero(FontPtr^, MaxFontBytes);
    case FontHandle of
      SmallFont: FontRec:= SmallFontRec;
      StandardFont: begin
          FontRec:= StandardFontRec;
          { seek past small font in file }
          Seek(F, (SmallFont * 256));
        end;
    end;
    Code:= -IoResult;
    if (Code < ecOK) then goto Error;

    { get number of bytes to read--number of characters * bytes per char }
    ToRead:= FontRec.Bytes * 256;

    { read font }
    BlockRead(F, FontPtr^, ToRead, ActRead);
    Code:= -IoResult;
    if (Code < ecOK) then goto Error;
    if (ActRead < ToRead) then begin
      Code:= ecDeviceRead;
      goto Error;
    end;

    { scale font up if HiRes requested }
    if HiRes then
      with FontRec do begin
        NewBytes:= Bytes * 2;

        { double raster lines of font }
        for J:= 255 downto 0 do begin
          NewRow:= 0;
          Row:= 0;
          for I:= 1 to Height do begin
            Move(FontPtr^[(J * Bytes) + Row], FontPtr^[(J * NewBytes) + NewRow], Width);
            Move(FontPtr^[(J * Bytes) + Row], FontPtr^[(J * NewBytes) + NewRow + Width], Width);
            Inc(Row, Width);
            Inc(NewRow, Width * 2);
          end;
        end;

        { adjust font parameters }
        Bytes:= NewBytes;
        Height:= Height * 2;
      end;

    Close(F);
    if (IoResult = 0) then;
    FontLoaded:= True;
    fcLoadFont:= ecOK;
    Exit;
  end;

Error:
  Close(F);
  if (IoResult = 0) then;
  fcLoadFont:= Code;
  {$ENDIF}
end;

function fcSetFont(Cvt: PAbsFaxCvt; Font: TFont; HiRes: Boolean): Integer;
{ -Set font for extended text converter }
var
  NewImageSize: Integer;
  NewLineBytes: Cardinal;
  BmpInfo: TBitmap;
begin
  Result:= ecOK;
  with Cvt^, PTextFaxData(UserData)^ do begin
    Bitmap.Canvas.Font.Assign(Font);
    UseHighRes:= HiRes;
    if UseHighRes then Bitmap.Canvas.Font.Size:= Bitmap.Canvas.Font.Size * 2;
    Bitmap.Width:= (ResWidth - LeftMargin);
    Bitmap.Height:= Bitmap.Canvas.TextHeight('Wy');
    FontRec.Height:= Bitmap.Height;

    GetObject(Bitmap.Handle, SizeOf(TBitmap), @BmpInfo);
    NewLineBytes:= BmpInfo.bmWidthBytes;
    NewImageSize:= Integer(NewLineBytes) * BmpInfo.bmHeight;

    if NewImageSize > (64 * 1024) then begin
      Result:= ecEnhFontTooBig;
      Exit;
    end;

    if (NewImageSize <> ImageSize) then begin
      LineBytes:= NewLineBytes;
      if Assigned(ImageData) then FreeMem(ImageData, ImageSize);
      ImageSize:= NewImageSize;
      GetMem(ImageData, ImageSize);
    end;
  end;
end;

function fcOpenFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a text file for input }
begin
  with PTextFaxData(Cvt^.UserData)^ do begin
    OnLine:= 0;
    CurRow:= 0;

    { open the input file }
    InFile:= TLineReader.Create(TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite));
  end;
  Result:= ecOK;
end;

procedure fcCloseFile(Cvt: PAbsFaxCvt);
{ -Close text file }
begin
  with PTextFaxData(Cvt^.UserData)^ do begin
    { close the file }
    InFile.Free;
  end;
end;

procedure fcSetLinesPerPage(Cvt: PAbsFaxCvt; LineCount: Cardinal);
{ -Set the number of text lines per page }
begin
  PTextFaxData(Cvt^.UserData)^.LineCount:= LineCount;
end;

procedure fcAddRasterChar(var CharData; var Data; LPWidth: Cardinal; var LByteOfs: Cardinal;
  var LBitOfs: Cardinal); assembler; register;
{$IFNDEF CPUX64}
asm
  push  esi
  push  edi
  push  ebx

  cld

  { load parameters }
  mov   esi,LByteOfs
  mov   edi,edx         { edx = Data }
  mov   ebx,edi
  add   edi,[esi]
  mov   edx,ecx         { ecx = LPWidth }
  mov   esi,LBitOfs
  mov   ecx,[esi]
  mov   esi,eax         { eax = CharData }

@1: mov   al,[esi]        { get next byte of character data }
  inc   esi
  xor   ah,ah
  ror   ax,cl           { rotate by current bit offset }
  or    [edi],ax        { OR it into position }
  mov   eax,edx         { ax = remaining pixels }
  cmp   ax,8            { at least 8 remaining? }
  jb    @2              { jump if not }
  inc   edi             { next output byte }
  sub   edx,8           { update remaining pixels }
  jnz   @1              { loop if more }
  jmp   @3              { get out if not }

@2: sub   edx,eax         { update remaining pixels }
  add   ecx,eax         { update bit offset }
  mov   eax,ecx
  shr   eax,3
  add   edi,eax         { update byte offset }
  and   ecx,7           { update bit offset }
  or    edx,edx         { more pixels to merge? }
  jnz   @1              { jump if so }

@3: sub   edi,ebx
  mov   ebx,edi
  mov   edi,LByteOfs
  mov   [edi],ebx
  mov   edi,LBitOfs
  mov   [edi],ecx

  pop   ebx
  pop   edi
  pop   esi
end;
{$ELSE}
asm
  push  rsi
  push  rdi
  push  rbx
  mov   rax,rcx
  mov   rcx,r8

  cld

  { load parameters }
  mov   rsi,LByteOfs
  mov   rdi,rdx         { edx = Data }
  mov   rbx,rdi
  mov   r9d,dword ptr [rsi]
  add   rdi,r9
  mov   edx,ecx         { ecx = LPWidth }
  mov   rsi,LBitOfs
  mov   ecx,[rsi]
  mov   rsi,rax         { eax = CharData }

@1: mov   al,[rsi]        { get next byte of character data }
  inc   rsi
  xor   ah,ah
  ror   ax,cl           { rotate by current bit offset }
  or    [rdi],ax        { OR it into position }
  mov   eax,edx         { ax = remaining pixels }
  cmp   ax,8            { at least 8 remaining? }
  jb    @2              { jump if not }
  inc   rdi             { next output byte }
  sub   rdx,8           { update remaining pixels }
  jnz   @1              { loop if more }
  jmp   @3              { get out if not }

@2: sub   rdx,rax         { update remaining pixels }
  add   rcx,rax         { update bit offset }
  mov   rax,rcx
  shr   rax,3
  add   rdi,rax         { update byte offset }
  and   rcx,7           { update bit offset }
  or    edx,edx         { more pixels to merge? }
  jnz   @1              { jump if so }

@3: sub   rdi,rbx
  mov   rbx,rdi
  mov   rdi,LByteOfs
  mov   [rdi],ebx
  mov   rdi,LBitOfs
  mov   [rdi],ecx

  pop   rbx
  pop   rdi
  pop   rsi
end;
{$ENDIF}

{ Move source to Dest -- doubling each bit.  Count is amount of source }
{ to move -- Dest is assumed to be big enough to handle (Count x 2) }
procedure StretchMove(const Source; var Dest; Count: Integer); register;
{$IFNDEF CPUX64}
asm
  push  esi
  mov   esi, eax            // Source pointer to ESI
  push  edi
  push  ebx
  mov   edi, edx            // Dest pointer to EDI
  xor   edx, edx            // Clear EDX

@@1:
  mov   bl, [esi]           // Load source byte
  mov   eax, 8

@@2:
  shl   edx, 2              // Shift bits into position
  rcl   bl, 1               // Set CF if high bit is set
  jnc   @@3
  or    dl, 03h             // Set bits

@@3:
  dec   eax                 // Loop if bits left
  jnz   @@2

  mov   [edi], dh           // DH to output
  mov   [edi+1], dl         // DL to output
  add   edi, 2              // Advance Dest pointer

  inc   esi                 // Advance Source pointer
  dec   ecx                 // Decrement counter, loop if more to read
  jnz   @@1

  pop   ebx                 // Restore registers
  pop   edi
  pop   esi
end;
{$ELSE}
asm
  push  rsi
  mov   rsi, rcx            // Source pointer to ESI
  push  rdi
  push  rbx
  mov   rdi, rdx            // Dest pointer to EDI
  xor   rdx, rdx            // Clear EDX

@@1:
  mov   bl, [rsi]           // Load source byte
  mov   eax, 8

@@2:
  shl   rdx, 2              // Shift bits into position
  rcl   bl, 1               // Set CF if high bit is set
  jnc   @@3
  or    dl, 03h             // Set bits

@@3:
  dec   eax                 // Loop if bits left
  jnz   @@2

  mov   [rdi], dh           // DH to output
  mov   [rdi+1], dl         // DL to output
  add   rdi, 2              // Advance Dest pointer

  inc   rsi                 // Advance Source pointer
  dec   ecx                 // Decrement counter, loop if more to read
  jnz   @@1

  pop   rbx                 // Restore registers
  pop   rdi
  pop   rsi
end;
{$ENDIF}

procedure fcRasterizeText(Cvt: PAbsFaxCvt; St: PAnsiChar; Row: Cardinal; var Data);
{ -Turn a row in a string into a raster line }
var
  SLen: Cardinal;
  LByteOfs: Cardinal;
  LBitOfs: Cardinal;
  I: Integer;
  YW: Integer;
  CHandle: HDC;

begin
  with Cvt^, PTextFaxData(Cvt^.UserData)^ do begin
    { validate row }
    if (Row > FontRec.Height) then Exit;
    if IsExtended then begin
      if (Row = 1) then begin
        CHandle:= Bitmap.Canvas.Handle;
        PatBlt(CHandle, 0, 0, Bitmap.Width, Bitmap.Height, WHITENESS);
        TextOutA(CHandle, 0, 0, St, AnsiStrings.StrLen(St));
        PatBlt(CHandle, 0, 0, Bitmap.Width, Bitmap.Height, DSTINVERT);
        GetBitmapBits(Bitmap.Handle, ImageSize, ImageData);
        offset:= 0;
      end;
      if UseHighRes then Move(GetPtr(ImageData, offset)^, Data, (LineBytes))
      else StretchMove(GetPtr(ImageData, offset)^, Data, (LineBytes div 2));
      Inc(offset, LineBytes);
    end else begin
      YW:= (Row - 1) * FontRec.Width;
      LByteOfs:= 0;
      LBitOfs:= 0;
      SLen:= AnsiStrings.StrLen(St);
      if (SLen > 0) then
        for I:= 0 to Pred(SLen) do
            fcAddRasterChar(FontPtr^[Byte(St[I])* FontRec.Bytes + YW], Data, FontRec.PWidth,
            LByteOfs, LBitOfs);
    end;
  end;
end;

function fcDetab(Dest: PAnsiChar; Src: PAnsiChar; TabSize: Byte; BufLen: dword): PAnsiChar;
  assembler; register; { !!.04 }
{ -Expand tabs in a string to blanks on spacing TabSize }
{$IFNDEF CPUX64}
asm
  push  esi
  push  edi
  push  ebx

  push  eax

  cld

  { load parameters }
  mov   edi,eax     { edi = Dest }
  mov   esi,edx     { esi = Src }
  xor   ebx,ebx
  mov   bl,cl       { cl = TabSize }

  xor   ecx,ecx     { Default input length = 0 }
  xor   edx,edx     { Default output length = 0 in DL }
  or    bl,bl
  jz    @@Done      { Return zero length string if tabsize = 0 }

  mov   ah,09       { store tab in AH }

@@Next:
  mov   al,[esi]    { next input character }
  or    al,al       { is it a null? }
  jz    @@Done
  inc   esi
  cmp   al,ah       { is it a tab? }
  je    @@Tab       { yes, compute next tab stop }
  mov   [edi],al    { no, store to output }
  inc   edi
  inc   edx         { increment output length }
  cmp   edx,BufLen  { check if we have room in buffer }                  { !!.04 }
  jge   @@Done      { bail if not }                                      { !!.04 }
  jmp   @@Next      { next character }

@@Tab:
  push  edx         { save output length }
  mov   eax,edx     { current output length in edx:eax }
  xor   edx,edx
  div   ebx         { OLen div TabSize in al }
  inc   eax         { Round up to next tab position }
  mul   ebx         { next tab position in eax }
  pop   edx         { restore output length }
  sub   eax,edx     { count of blanks to insert }
  add   edx,eax     { new output length in edx }
  cmp   edx,BufLen  { check if we have room in the buffer }              { !!.04 }
  jge   @@Done      { bail if not }                                      { !!.04 }
  mov   ecx,eax     { loop counter for blanks }
  mov   ax,$0920    { tab in ah, blank in al }
  rep   stosb       { store blanks }
  jmp   @@Next      { back for next input }

@@Done:
  mov   byte ptr [edi],0

  pop   eax         { function result = Dest }

  pop   ebx
  pop   edi
  pop   esi
end;
{$ELSE}
asm
  // Dest : PAnsiChar;  RCX
  // Src : PAnsiChar;   RDX
  // TabSize : Byte;    R8b
  // BufLen : DWORD     R9d
  push  rsi
  push  rdi
  push  rbx
  mov   rax,rcx
  mov   rcx,r8

  push  rax

  cld

  { load parameters }
  mov   rdi,rax     { edi = Dest }
  mov   rsi,rdx     { esi = Src }
  xor   rbx,rbx
  mov   bl,cl       { cl = TabSize }

  xor   rcx,rcx     { Default input length = 0 }
  xor   edx,edx     { Default output length = 0 in DL }
  or    bl,bl
  jz    @@Done      { Return zero length string if tabsize = 0 }

  mov   ah,09       { store tab in AH }

@@Next:
  mov   al,[rsi]    { next input character }
  or    al,al       { is it a null? }
  jz    @@Done
  inc   rsi
  cmp   al,ah       { is it a tab? }
  je    @@Tab       { yes, compute next tab stop }
  mov   [rdi],al    { no, store to output }
  inc   rdi
  inc   edx         { increment output length }
  cmp   edx,BufLen  { check if we have room in buffer }                  { !!.04 }
  jge   @@Done      { bail if not }                                      { !!.04 }
  jmp   @@Next      { next character }

@@Tab:
  push  rdx         { save output length }
  mov   eax,edx     { current output length in edx:eax }
  xor   edx,edx
  div   ebx         { OLen div TabSize in al }
  inc   eax         { Round up to next tab position }
  mul   ebx         { next tab position in eax }
  pop   rdx         { restore output length }
  sub   eax,edx     { count of blanks to insert }
  add   edx,eax     { new output length in edx }
  cmp   edx,BufLen  { check if we have room in the buffer }              { !!.04 }
  jge   @@Done      { bail if not }                                      { !!.04 }
  mov   ecx,eax     { loop counter for blanks }
  mov   ax,$0920    { tab in ah, blank in al }
  rep   stosb       { store blanks }
  jmp   @@Next      { back for next input }

@@Done:
  mov   byte ptr [rdi],0

  pop   rax         { function result = Dest }

  pop   rbx
  pop   rdi
  pop   rsi
end;
{$ENDIF}

function fcGetTextRasterLine(Cvt: PAbsFaxCvt; var Data; var Len: Integer;
  var EndOfPage, MorePages: Bool): Integer;
{ -Convert a string of text into a raster line }
var
  SLen: Cardinal;
  MaxLen: Integer;
  C: Integer;
  FFPos: Integer;
  FFWasPending: Boolean;
  St: AnsiString;
  B: TByteArray absolute Data;
begin
  { assume success }
  fcGetTextRasterLine:= ecOK;
  with Cvt^, PTextFaxData(UserData)^ do begin
    FFWasPending:= False;
    { do we need to load a new string? }
    if (CurRow = 0) then begin
      { if at end of file, exit }
      if InFile.EOLF and (Pending = '') then begin
        if (CurrLine = 1) then begin
          EndOfPage:= False;
          MorePages:= False;
          FillChar(Data, ResWidth div 8, 0);
        end else begin
          EndOfPage:= True;
          MorePages:= False;
        end;
        Exit;
      end;

      { read the line from the input file }
      if FFPending then begin
        St:= AnsiString(Pending);
        Pending:= '';
        FFPending:= False;
        FFWasPending:= True;
      end else begin
        St:= InFile.NextLine;
        BytesRead:= InFile.BytesRead;
        BytesToRead:= InFile.FileSize;
      end;

      { check for form feeds }
      FFPos:= pos(#12, string(St));
      if (FFPos <> 0) then begin
        Pending:= Copy(string(St), FFPos + 1, 255);
        SetLength(St, FFPos - 1);
        FFPending:= True;
      end;
      CurRow:= 1;

      { expand the tabs in the line of text }
      St:= St + #0;
      fcDetab(CurStr, PAnsiChar(St), TabStop, high(CurStr)); { !!.04 }

      if not IsExtended then begin
        { adjust the string length, accounting for margins }
        { this is handled automagically by the bitmap size in extended text mode }
        SLen:= AnsiStrings.StrLen(CurStr);
        C:= LeftMargin div FontRec.PWidth;
        MaxLen:= Integer(ResWidth div FontRec.PWidth) - C;
        if (SLen > Cardinal(MaxLen)) then SLen:= MaxLen;
        CurStr[SLen]:= #0;
      end;

      { check to see if we're at the end of the page }
      Inc(OnLine);
      if FFWasPending or ((LineCount <> 0) and (OnLine > LineCount)) then begin
        OnLine:= 1;
        EndOfPage:= True;
        MorePages:= not InFile.EOLF or (Pending <> '');
        if MorePages and FFWasPending and (Pending = '') then CurRow:= 0;
        Exit;
      end;
    end;

    { convert the next string row }
    if IsExtended then begin
      Len:= ResWidth div 8;
    end else begin
      Len:= FontRec.PWidth * AnsiStrings.StrLen(CurStr);
      Len:= (Len div 8) + Ord((Len mod 8) <> 0);
    end;
    fcRasterizeText(Cvt, CurStr, CurRow, Data);

    Inc(CurRow);

    if (CurRow > FontRec.Height) then CurRow:= 0;

    EndOfPage:= False;
    MorePages:= True;
  end;
end;

{ TIFF-to-fax conversion routines }

procedure tcInitTiffConverter(var Cvt: PAbsFaxCvt);
{ -Initialize a text-to-fax converter }
var
  TiffCvtData: PTiffFaxData;
begin
  Cvt:= nil;

  { initialize converter specific data }
  TiffCvtData:= AllocMem(SizeOf(TTiffFaxData));

  TiffCvtData^.ReadBuffer:= AllocMem(ReadBufferSize);
  TiffCvtData^.CompMethod:= compNone;

  { initialize the abstract converter }
  acInitFaxConverter(Cvt, TiffCvtData, tcGetTiffRasterLine, tcOpenFile, tcCloseFile, DefTiffExt);
end;

procedure tcDoneTiffConverter(var Cvt: PAbsFaxCvt);
{ -Destroy a TIFF converter }
begin
  FreeMem(PTiffFaxData(Cvt^.UserData)^.ReadBuffer, ReadBufferSize);
  FreeMem(Cvt^.UserData, SizeOf(TTiffFaxData));
  acDoneFaxConverter(Cvt);
end;

function tcGetByte(Cvt: PAbsFaxCvt; var B: Byte): Integer;
{ -Read a byte from a TIFF file }
var
  Code: Integer;

begin
  with PTiffFaxData(Cvt^.UserData)^ do begin
    { buffer empty? }
    if (CurrRBOfs >= CurrRBSize) then begin
      { refill buffer }
      BlockRead(InFile, ReadBuffer^, ReadBufferSize, CurrRBSize);
      if (CurrRBSize = 0) then Code:= ecDeviceRead
      else Code:= -IoResult;
      if (Code < ecOK) then begin
        tcGetByte:= Code;
        Exit;
      end;
      CurrRBOfs:= 0;
    end;
    B:= ReadBuffer^[CurrRBOfs];
    Inc(CurrRBOfs);
    tcGetByte:= ecOK;
  end;
end;

function tcGetWord(Cvt: PAbsFaxCvt; var W: Word): Integer;
{ -Read a word from a TIFF file }
var
  B: array[1 .. 2] of Byte;
  Code: Integer;

begin
  { read two bytes }
  Code:= tcGetByte(Cvt, B[1]);
  if (Code = ecOK) then Code:= tcGetByte(Cvt, B[2]);
  if (Code < ecOK) then begin
    tcGetWord:= Code;
    Exit;
  end;

  tcGetWord:= ecOK;
  if PTiffFaxData(Cvt^.UserData)^.Intel then Move(B[1], W, SizeOf(Word))
  else W:= B[2] + Word(B[1] shl 8);
end;

function tcGetLong(Cvt: PAbsFaxCvt; var L: Integer): Integer;
{ -Read a long integer from a TIFF file }
var
  B: array[1 .. 4] of Byte;
  I: Integer;
  Code: Integer;

begin
  { read four bytes }
  for I:= 1 to 4 do begin
    Code:= tcGetByte(Cvt, B[I]);
    if (Code < ecOK) then begin
      tcGetLong:= Code;
      Exit;
    end;
  end;

  tcGetLong:= ecOK;
  if PTiffFaxData(Cvt^.UserData)^.Intel then Move(B[1], L, SizeOf(Integer))
  else L:= Integer(B[1]) shl 24 + Integer(B[2]) shl 16 + Integer(B[3]) shl 8 + Integer(B[4]);
end;

function tcSeek(Cvt: PAbsFaxCvt; NewOfs: Integer): Integer;
begin
  with PTiffFaxData(Cvt^.UserData)^ do begin
    { seek to location in input file }
    Seek(InFile, NewOfs);
    tcSeek:= -IoResult;

    { force buffer reload }
    CurrRBSize:= 0;
    CurrRBOfs:= 999;
  end;
end;

function tcOpenInputFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a TIFF file for reading }
var
  Code: Integer;
  SaveMode: Integer;

label
  ErrorExit;

  function ValidateTiff: Integer;
  { -Read the TIFF file header and validate it }
  var
    C1: Ansichar;
    C2: Ansichar;
    L: Integer;

  label
    ValidError;

  begin
    { assume failure }
    ValidateTiff:= ecBadGraphicsFormat;

    with PTiffFaxData(Cvt^.UserData)^ do begin
      { get Intel or Motorola byte-order flags }
      Code:= tcGetByte(Cvt, Byte(C1));
      if (Code < ecOK) then goto ValidError;
      Code:= tcGetByte(Cvt, Byte(C2));
      if (Code < ecOK) then goto ValidError;

      if (C1 = 'I') and (C2 = 'I') then Intel:= True
      else if (C1 = 'M') and (C2 = 'M') then Intel:= False
      else Exit;

      { Get version flag }
      Code:= tcGetWord(Cvt, Version);
      if (Code < ecOK) then goto ValidError;

      { find start of image directory }
      Code:= tcGetLong(Cvt, L);
      if (Code < ecOK) then goto ValidError;
      if (L > 0) then begin
        Code:= tcSeek(Cvt, L);
        if (Code < ecOK) then goto ValidError;
      end;

      ValidateTiff:= ecOK;
      Exit;

    ValidError:
      ValidateTiff:= Code;
    end;
  end;

  function DecodeTag: Integer;
  { -Retrieve and decode the next tag field from the file }
  const
    LastMasks: array[0 .. 7] of Byte = ($FF, $80, $C0, $E0, $F0, $F8, $FC, $FE);

  var
    Tag: Word;
    TagType: Word;
    Dummy: Word;
    Len: Integer;
    offset: Integer;
    Code: Integer;

    function Pixels2Bytes(W: Cardinal): Cardinal;
    begin
      Pixels2Bytes:= (W + 7) shr 3;
    end;

  begin
    with PTiffFaxData(Cvt^.UserData)^ do begin
      { get next tag }
      Code:= tcGetWord(Cvt, Tag);
      if (Code = ecOK) then Code:= tcGetWord(Cvt, TagType);
      if (Code < ecOK) then begin
        DecodeTag:= Code;
        Exit;
      end;

      { process the tag }
      case TagType of
        tiffShort: begin
            Code:= tcGetWord(Cvt, Dummy);
            if (Code = ecOK) then begin
              Len:= Dummy;
              Code:= tcGetWord(Cvt, Dummy);
              if (Code = ecOK) then begin
                Code:= tcGetWord(Cvt, Dummy);
                offset:= Dummy;
                if (Code = ecOK) then Code:= tcGetWord(Cvt, Dummy);
              end;
            end;
          end;

        tiffLong: begin
            Code:= tcGetLong(Cvt, Len);
            if (Code = ecOK) then Code:= tcGetLong(Cvt, offset);
          end;

      else
        { unsupported tag, just read and discard the data }
        Code:= tcGetLong(Cvt, Len);
        if (Code = ecOK) then Code:= tcGetLong(Cvt, offset);
      end;

      case Tag of
        SubfileType: SubFile:= Cardinal(offset);
        ImageWidth: begin
            ImgWidth:= Cardinal(offset);
            ImgBytes:= Pixels2Bytes(ImgWidth);
            LastBitMask:= LastMasks[ImgWidth mod 8];
          end;

        ImageLength: begin
            NumLines:= Cardinal(offset);
            ImgLen:= NumLines;
          end;
        RowsPerStrip: if (TagType = tiffLong) then RowStrip:= offset
          else RowStrip:= offset and $0000FFFF;

        StripOffsets: if (TagType = tiffLong) then begin
            StripOfs:= offset;
            StripCnt:= Len;
          end else begin
            StripOfs:= offset and $0000FFFF;
            StripCnt:= Len and $0000FFFF;
          end;

        Compression: begin
            CompMethod:= Cardinal(offset);
            if (CompMethod <> compNone) and (CompMethod <> compMPNT) then
                Code:= ecBadGraphicsFormat;
          end;

        PhotometricInterp: PhotoMet:= Cardinal(offset);
        BitsPerSample: if (offset <> 1) then Code:= ecBadGraphicsFormat;

        StripByteCounts: ByteCntOfs:= offset;
      end;

      DecodeTag:= Code;
    end;
  end;

  function ReadTagDir: Integer;
  { -Read the tag directory from the TIFF file header }
  var
    W: Word;
    X: Word;
    Code: Integer;

  begin
    with PTiffFaxData(Cvt^.UserData)^ do begin
      { assume we're at the start of a directory; get the tags count }
      Code:= tcGetWord(Cvt, W);
      if (Code < ecOK) then begin
        ReadTagDir:= Code;
        Exit;
      end;

      { read that many tags and decode }
      for X:= 1 to W do begin
        Code:= DecodeTag;
        if (Code < ecOK) then begin
          ReadTagDir:= Code;
          Exit;
        end;
      end;

      { Have we picked up the data we need? }
      if (ImgWidth = 0) or (NumLines = 0) or (StripOfs = 0) then ReadTagDir:= ecBadGraphicsFormat
      else ReadTagDir:= ecOK;
    end;
  end;

  function LoadStripInfo: Integer;
  { -Load strip offsets/lengths }
  var
    Len: Cardinal;
    I: Cardinal;

  label
    StripError;

  begin
    with PTiffFaxData(Cvt^.UserData)^ do begin
      { get memory for array }
      Len:= StripCnt * SizeOf(TStripRecord);
      StripInfo:= AllocMem(Len);

      { seek to start of strip byte count list }
      Code:= tcSeek(Cvt, ByteCntOfs);
      if (Code < ecOK) then goto StripError;

      { load lengths }
      for I:= 1 to StripCnt do begin
        Code:= tcGetLong(Cvt, StripInfo^[I].Length);
        if (Code < ecOK) then goto StripError;
      end;

      { seek to start of strip offset list }
      Code:= tcSeek(Cvt, StripOfs);
      if (Code < ecOK) then goto StripError;

      { load offfsets }
      for I:= 1 to StripCnt do begin
        Code:= tcGetLong(Cvt, StripInfo^[I].offset);
        if (Code < ecOK) then goto StripError;
      end;

      LoadStripInfo:= ecOK;
      Exit;

    StripError:
      LoadStripInfo:= Code;
      FreeMem(StripInfo, Len);
    end;
  end;

begin
  with PTiffFaxData(Cvt^.UserData)^ do begin
    CurrRBSize:= 0;
    CurrRBOfs:= $FFFF;
    SaveMode:= FileMode;
    FileMode:= ApdShareFileRead;
    Assign(InFile, FileName);
    Reset(InFile, 1);
    FileMode:= SaveMode;
    Code:= -IoResult;
    if (Code < ecOK) then begin
      tcOpenInputFile:= Code;
      Exit;
    end;

    { validate the TIFF file format and read the tag directory }
    Code:= ValidateTiff;
    if (Code = ecOK) then Code:= ReadTagDir;
    if (Code < ecOK) then goto ErrorExit;

    { If it's a multi-strip file, load the strip offset lengths }
    if (StripCnt > 1) then begin
      Code:= LoadStripInfo;
      if (Code < ecOK) then goto ErrorExit;
    end;

    Cvt^.BytesToRead:= ImgBytes * ImgLen;

    tcOpenInputFile:= ecOK;
    Exit;

  ErrorExit:
    Close(InFile);
    if (IoResult = 0) then;
    tcOpenInputFile:= Code;
  end;
end;


function tcOpenFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a TIFF file for input }
var
  Code: Integer;

begin
  { open the input file }
  Code:= tcOpenInputFile(Cvt, FileName);
  if (Code < ecOK) then begin
    tcOpenFile:= Code;
    Exit;
  end;

  { initialize converter parameters }
  with Cvt^, PTiffFaxData(UserData)^ do begin
    if FlagIsSet(Flags, fcDoubleWidth) then
        DoubleWidth:= not UseHighRes and ((ImgWidth * 2) <= (ResWidth - LeftMargin));
    HalfHeight:= not UseHighRes and not DoubleWidth and FlagIsSet(Flags, fcHalfHeight);

    { center image in fax image }
    CenterOfs:= 0;
    if FlagIsSet(Flags, fcCenterImage) then
      if ((ResWidth - ImgWidth) >= 16) then begin
        { only center if at least one byte on each side }
        if DoubleWidth then CenterOfs:= (ResWidth - (ImgWidth * 2)) div 32
        else CenterOfs:= (ResWidth - ImgWidth) div 16;
      end;

    OnStrip:= 1;
    OnRaster:= 1;

    { set single-strip values if this is a multi-strip image }
    if (StripCnt > 1) then begin
      NumLines:= RowStrip;

      Code:= tcSeek(Cvt, StripInfo^[1].offset);
      if (Code < ecOK) then begin
        FreeMem(StripInfo, StripCnt * SizeOf(TStripRecord));
        Close(InFile);
        if (IoResult = 0) then;
        tcOpenFile:= Code;
        Exit;
      end;

      { otherwise, seek to the beginning of the image for single strip }
    end else begin
      Code:= tcSeek(Cvt, ImgStart + StripOfs);
      if (Code < ecOK) then begin
        Close(InFile);
        if (IoResult = 0) then;
        tcOpenFile:= Code;
        Exit;
      end;
    end;
  end;

  tcOpenFile:= ecOK;
end;

procedure tcCloseFile(Cvt: PAbsFaxCvt);
{ -Close TIFF file }
begin
  with Cvt^, PTiffFaxData(UserData)^ do begin
    Close(InFile);
    if (IoResult = 0) then;

    FreeMem(StripInfo, StripCnt * SizeOf(TStripRecord));
  end;
end;

function tcGetTiffRasterLine(Cvt: PAbsFaxCvt; var Data; var Len: Integer;
  var EndOfPage, MorePages: Bool): Integer;
{ -Callback to read a row of TIFF raster data }
var
  Code: Integer;
  Buf: TByteArray absolute Data;

  function ReadRasterLine: Integer;
  { -Read and decompress the next line of raster data from the file }
  var
    W: Cardinal;
    Code: Integer;
    B: Byte;
    C: Byte;

  begin
    with Cvt^, PTiffFaxData(UserData)^ do begin
      if (CompMethod = compNone) then begin
        { read each byte of raster image }
        for W:= 0 to Pred(ImgBytes) do begin
          Code:= tcGetByte(Cvt, Buf[W]);
          if (Code < ecOK) then begin
            ReadRasterLine:= Code;
            Exit;
          end;

        end;
        Inc(BytesRead, ImgBytes);
      end else if (CompMethod = compMPNT) then begin
        W:= 0;
        { decode compressed bytes until we have enough for one line }
        while (W < ImgBytes) do begin
          { get control byte }
          Code:= tcGetByte(Cvt, B);
          if (Code < ecOK) then begin
            ReadRasterLine:= Code;
            Exit;
          end;

          { if high bit is set, this is a run length }
          if ((B and $80) = $80) then begin
            { get run length }
            B:= Byte(-ShortInt(B) + 1);

            { get byte to repeat }
            Code:= tcGetByte(Cvt, C);
            if (Code < ecOK) then begin
              ReadRasterLine:= Code;
              Exit;
            end;

            { repeat the byte }
            if ((W + B) < MaxData) then FillChar(Buf[W], B, C);
            Inc(W, B);
          end else begin
            { literal data counter = B + 1 }
            Inc(B);
            { read B bytes and put them in the output line }
            while (B > 0) do begin
              if (W < MaxData) then begin
                Code:= tcGetByte(Cvt, Buf[W]);
                if (Code < ecOK) then begin
                  ReadRasterLine:= Code;
                  Exit;
                end;
              end;
              Inc(W);
              dec(B);
            end;
          end;
        end;

        Inc(BytesRead, ImgBytes);
      end;

      if (PhotoMet > 0) then
        for W:= 0 to Pred(ImgBytes) do begin
          Buf[W]:= not(Buf[W]);
          if (W = Word(Pred(ImgBytes))) then Buf[W]:= Buf[W] and LastBitMask;
        end;
    end;

    ReadRasterLine:= ecOK;
  end;

  function DecodeStripLine: Integer;
  { -Decode current strip, assume already seeked to image start }
  var
    Code: Integer;
    ByteWidth: Cardinal;

  begin
    with Cvt^, PTiffFaxData(UserData)^ do begin
      ByteWidth:= (ImgWidth div 8) + Ord((ImgWidth mod 8) <> 0);

      Code:= ReadRasterLine;
      if (Code < ecOK) then begin
        DecodeStripLine:= Code;
        Exit;
      end;

      if (CenterOfs <> 0) then begin
        if ((CenterOfs + ByteWidth) < MaxData) then begin
          Move(Buf[0], Buf[CenterOfs], ByteWidth);
          FastZero(Buf[0], CenterOfs);
        end;
      end;
    end;

    DecodeStripLine:= ecOK;
  end;

begin
  with Cvt^, PTiffFaxData(UserData)^ do begin
    tcGetTiffRasterLine:= ecOK;

    MorePages:= False;
    EndOfPage:= (OnRaster > NumLines) and (OnStrip = StripCnt);
    if EndOfPage then Exit;

    { if this is a single strip image, process this strip }
    if (StripCnt = 1) then begin
      { Decode the next raster line in the strip }
      Code:= DecodeStripLine;
      Inc(OnRaster);

      { multiple strip image--seek to next strip }
    end else begin
      { Decode this the next raster line in the strip }
      Code:= DecodeStripLine;
      Inc(OnRaster);
      if (OnRaster > NumLines) and (OnStrip < StripCnt) then begin
        OnRaster:= 1;
        Inc(OnStrip);
        { set single-strip values }
        if (OnStrip = StripCnt) then NumLines:= (ImgLen - (Pred(StripCnt) * RowStrip))
        else NumLines:= RowStrip;

        { seek to the beginning of the next strip }
        Code:= tcSeek(Cvt, StripInfo^[OnStrip].offset);
        if (Code < ecOK) then begin
          tcGetTiffRasterLine:= Code;
          Exit;
        end;
      end;
    end;
    Len:= ImgBytes;
  end;

  tcGetTiffRasterLine:= Code;
end;

{ PCX conversion routines }

procedure pcInitPcxData(var PcxCvtData: PPcxFaxData);
{ -Initialize base PCX converter data }
begin
  PcxCvtData:= nil;

  { initialize converter specific data }
  PcxCvtData:= AllocMem(SizeOf(TPcxFaxData));
  with PcxCvtData^ do ReadBuffer:= AllocMem(ReadBufferSize);

end;

procedure pcDonePcxData(var PcxCvtData: PPcxFaxData);
{ -Destroy base PCX converter data }
begin
  FreeMem(PcxCvtData^.ReadBuffer, ReadBufferSize);
  FreeMem(PcxCvtData^.DcxData, SizeOf(TDcxFaxData));
  FreeMem(PcxCvtData, SizeOf(TPcxFaxData));
  PcxCvtData:= nil;
end;

procedure pcInitPcxConverter(var Cvt: PAbsFaxCvt);
{ -Initialize a PCX-to-fax converter }
var
  PcxCvtData: PPcxFaxData;
begin
  Cvt:= nil;

  { initialize converter specific data }
  pcInitPcxData(PcxCvtData);

  { initialize the abstract converter }
  acInitFaxConverter(Cvt, PcxCvtData, pcGetPcxRasterLine, pcOpenFile, pcCloseFile, DefPcxExt);
end;

procedure pcDonePcxConverter(var Cvt: PAbsFaxCvt);
{ -Destroy a PCX-to-fax converter }
begin
  pcDonePcxData(PPcxFaxData(Cvt^.UserData));
  acDoneFaxConverter(Cvt);
end;

function pcPreparePcxImage(Cvt: PAbsFaxCvt): Integer;
{ -Prepare a PCX image for conversion }
var
  Code: Integer;

  function ValidatePcxHdr: Bool;
  { -Make sure the PCX header is valid }
  begin
    ValidatePcxHdr:= False;
    with Cvt^, PPcxFaxData(UserData)^, PcxHeader do begin
      { if Mfgr byte <> $0A or Encoding byte <> $01, it's not a PCX file }
      if (Mfgr <> $0A) or (Encoding <> $01) then Exit;

      { we only handle color depth = 1 (monochrome) }
      if (BitsPixel <> $01) then Exit;

      { validate image is not too wide }
      if (Cardinal(XMax - XMin) > ResWidth) then Exit;
    end;
    ValidatePcxHdr:= True;
  end;

begin
  pcPreparePcxImage:= ecOK;

  with Cvt^, PPcxFaxData(UserData)^ do begin
    BlockRead(InFile, PcxHeader, SizeOf(TPcxHeaderRec));
    Code:= -IoResult;
    if (Code < ecOK) then begin
      pcPreparePcxImage:= Code;
      Exit;
    end;

    { validate the PCX file }
    if not ValidatePcxHdr then begin
      pcPreparePcxImage:= ecBadGraphicsFormat;
      Exit;
    end;

    { need double width scaling? }
    with PcxHeader do begin
      PcxWidth:= (XMax - XMin + 1);
      if FlagIsSet(Flags, fcDoubleWidth) then
          DoubleWidth:= not UseHighRes and ((PcxWidth * 2) <= (ResWidth - LeftMargin));
      HalfHeight:= not UseHighRes and not DoubleWidth and FlagIsSet(Flags, fcHalfHeight);
    end;

    { center PCX image in fax image }
    CenterOfs:= 0;
    if FlagIsSet(Flags, fcCenterImage) then
      if ((ResWidth - PcxWidth) >= 16) then begin
        { only center if at least one byte on each side }
        if DoubleWidth then CenterOfs:= (ResWidth - (PcxWidth * 2)) div 32
        else CenterOfs:= (ResWidth - PcxWidth) div 16;
      end;

    CurrRBSize:= 1;
    CurrRBOfs:= $FFFF;
    ActBytesLine:= ((PcxHeader.XMax - PcxHeader.XMin + 1) + 7) shr 3;
  end;
end;

function pcOpenInputFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a PCX file for reading }
var
  Code: Integer;
  SaveMode: Integer;

label
  ErrorExit;

begin
  pcOpenInputFile:= ecOK;

  with Cvt^, PPcxFaxData(UserData)^ do begin
    Assign(InFile, FileName);
    SaveMode:= FileMode;
    FileMode:= ApdShareFileRead;
    Reset(InFile, 1);
    FileMode:= SaveMode;
    Code:= -IoResult;
    if (Code < ecOK) then begin
      pcOpenInputFile:= Code;
      Exit;
    end;

    Code:= pcPreparePcxImage(Cvt);
    if (Code < ecOK) then begin
      Close(InFile);
      if (IoResult = 0) then;
      pcOpenInputFile:= Code;
    end else begin
      PcxBytes:= FileSize(InFile) - SizeOf(TPcxHeaderRec);
      BytesToRead:= PcxBytes;
      Code:= -IoResult;
      if (Code < ecOK) then begin
        Close(InFile);
        if (IoResult = 0) then;
        pcOpenInputFile:= Code;
      end
      else ActBytesLine:= (PcxHeader.XMax - PcxHeader.XMin + 1) div 8;
    end;
  end;
end;

function pcOpenFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a PCX file for input }
var
  Code: Integer;

begin
  with Cvt^, PPcxFaxData(UserData)^ do begin
    { open the input file }
    Code:= pcOpenInputFile(Cvt, FileName);
    if (Code < ecOK) then begin
      pcOpenFile:= Code;
      Exit;
    end;
  end;

  pcOpenFile:= ecOK;
end;

procedure pcCloseFile(Cvt: PAbsFaxCvt);
{ -Close PCX file }
begin
  with Cvt^, PPcxFaxData(UserData)^ do begin
    Close(InFile);
    if (IoResult = 0) then;
  end;
end;

function pcGetPcxRasterLine(Cvt: PAbsFaxCvt; var Data; var Len: Integer;
  var EndOfPage, MorePages: Bool): Integer;
{ -Callback to read a row of PCX raster data }
var
  Buf: TByteArray absolute Data;
  ByteWidth: Cardinal;
  Code: Integer;

  function ReadRasterLine: Integer;
  { -Read a raster line from a PCX file }
  var
    First: Bool;
    OK: Bool;
    N: Integer;
    Code: Integer;
    B: Byte;
    L: Byte;

  begin
    with Cvt^, PPcxFaxData(UserData)^ do begin
      First:= False;
      L:= 0;

      { unpack the next raster line of PCX data }
      N:= 0;
      while (PcxBytes > 0) and (N < PcxHeader.BytesLine) do begin
        if (CurrRBOfs >= CurrRBSize) then begin
          BlockRead(InFile, ReadBuffer^, ReadBufferSize, CurrRBSize);
          Code:= -IoResult;
          if (Code < ecOK) then begin
            ReadRasterLine:= Code;
            Exit;
          end;

          if (CurrRBSize > PcxBytes) then CurrRBSize:= PcxBytes;
          CurrRBOfs:= 0;
        end;

        B:= ReadBuffer^[CurrRBOfs];
        Inc(CurrRBOfs);
        Inc(BytesRead);

        if First then begin
          B:= not B; { PCX files store in reverse format (1=white) }

          { make sure data fits }
          if ((N + L) < MaxData) then begin
            { ignore extra bytes for 2.8 and earlier }
            if (PcxHeader.Ver <= 3) then OK:= Cardinal(N + L) <= ActBytesLine
            else OK:= True;
            if OK then FillChar(Buf[N], L, B);
          end;
          Inc(N, L);
          First:= False;
        end else if ((B and $C0) = $C0) then begin
          L:= B and $3F;
          First:= True;
        end else begin
          if (N < MaxData) then Buf[N]:= not B;
          Inc(N);
        end;

        dec(PcxBytes);
      end;
    end;

    ReadRasterLine:= ecOK;
  end;

begin
  with Cvt^, PPcxFaxData(UserData)^ do begin
    pcGetPcxRasterLine:= ecOK;

    MorePages:= False;
    EndOfPage:= (PcxBytes = 0) or (CurrRBSize = 0);
    if (EndOfPage) then Exit;

    FastZero(Buf, MaxData);
    Code:= ReadRasterLine;
    if (Code < ecOK) then begin
      pcGetPcxRasterLine:= Code;
      Exit;
    end;

    if (CurrRBSize <> 0) then begin
      ByteWidth:= PcxWidth div 8;
      if (CenterOfs <> 0) then begin
        if ((CenterOfs + ByteWidth) < MaxData) then begin
          Move(Buf[0], Buf[CenterOfs], ByteWidth);
          FastZero(Buf[0], CenterOfs);
        end;
      end;
    end;

    Len:= PcxHeader.BytesLine;
  end;
end;

{ DCX conversion routines }

procedure dcInitDcxConverter(var Cvt: PAbsFaxCvt);
{ -Initialize a DCX-to-fax converter }
var
  PcxCvtData: PPcxFaxData;
  DcxCvtData: PDcxFaxData;
begin
  Cvt:= nil;

  { initialize converter specific data }
  DcxCvtData:= AllocMem(SizeOf(TDcxFaxData));

  pcInitPcxData(PcxCvtData);
  PcxCvtData^.DcxData:= DcxCvtData;

  { initialize the abstract converter }
  acInitFaxConverter(Cvt, PcxCvtData, dcGetDcxRasterLine, dcOpenFile, dcCloseFile, DefDcxExt);
end;

procedure dcDoneDcxConverter(var Cvt: PAbsFaxCvt);
{ -Destroy a PCX-to-fax converter }
begin
  pcDonePcxData(PPcxFaxData(Cvt^.UserData));
  acDoneFaxConverter(Cvt);
end;

function dcOpenInputFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a DCX file for reading }
var
  Code: Integer;
  R: Cardinal;
  I: Cardinal;
  J: Cardinal;
  PJ: Cardinal;
  Pivot: Integer;
  Sz: Integer;
  SaveMode: Integer;

begin
  with Cvt^, PPcxFaxData(UserData)^, DcxData^ do begin
    { open the file }
    Assign(InFile, FileName);
    SaveMode:= FileMode;
    FileMode:= ApdShareFileRead;
    Reset(InFile, 1);
    FileMode:= SaveMode;
    Code:= -IoResult;
    if (Code < ecOK) then begin
      dcOpenInputFile:= Code;
      Exit;
    end;

    { read the header }
    BlockRead(InFile, DcxHeader, SizeOf(DcxHeader), R);
    Sz:= FileSize(InFile);
    Code:= -IoResult;
    if (Code < ecOK) then begin
      Close(InFile);
      if (IoResult = 0) then;
      dcOpenInputFile:= Code;
      Exit;
    end;

    { validate the header }
    if (DcxHeader.ID <> DCXHeaderID) then begin
      dcOpenInputFile:= ecBadGraphicsFormat;
      Close(InFile);
      if (IoResult = 0) then;
      Exit;
    end;

    dcOpenInputFile:= ecOK;

    { figure out how many pages there are in the index }
    DcxNumPag:= 1;
    while (DcxHeader.Offsets[DcxNumPag] <> 0) do Inc(DcxNumPag);
    dec(DcxNumPag);

    Move(DcxHeader.Offsets, DcxPgSz, SizeOf(Integer) * DcxNumPag);
    if (DcxNumPag > 1) then begin
      { sort the index }
      repeat
        Pivot:= DcxPgSz[1];
        for J:= 2 to DcxNumPag do begin
          PJ:= Pred(J);
          if (DcxPgSz[PJ] > DcxPgSz[J]) then begin
            Pivot:= DcxPgSz[PJ];
            DcxPgSz[PJ]:= DcxPgSz[J];
            DcxPgSz[J]:= Pivot;
          end;
        end;
      until (Pivot = DcxPgSz[1]);

      { adjust the image lengths }
      for I:= 1 to Pred(DcxNumPag) do DcxPgSz[I]:= DcxPgSz[Succ(I)] - DcxPgSz[I];
      DcxPgSz[DcxNumPag]:= Sz - DcxPgSz[DcxNumPag];

      BytesToRead:= 0;
      for I:= 1 to DcxNumPag do Inc(BytesToRead, DcxPgSz[I] - SizeOf(TPcxHeaderRec));
    end else begin
      DcxPgSz[1]:= Sz - DcxHeader.Offsets[1] + 1;
      BytesToRead:= DcxPgSz[1] - SizeOf(TPcxHeaderRec);
    end;
  end;
end;

function dcPrepPage(Cvt: PAbsFaxCvt; Page: Integer): Integer;
{ -Prepare the next page in a DCX file for reading }
var
  Code: Integer;

begin
  dcPrepPage:= ecOK;

  with Cvt^, PPcxFaxData(UserData)^, DcxData^ do begin
    Seek(InFile, DcxHeader.Offsets[Page]);
    { read the PCX header }
    Code:= pcPreparePcxImage(Cvt);
    if (Code < ecOK) then begin
      dcPrepPage:= Code;
      Exit;
    end;

    PcxBytes:= DcxPgSz[Page] - SizeOf(TPcxHeaderRec);
  end;
end;

function dcOpenFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a DCX file for reading }
var
  Code: Integer;

begin
  with Cvt^, PPcxFaxData(UserData)^, DcxData^ do begin
    { open the input file }
    Code:= dcOpenInputFile(Cvt, FileName);
    if (Code < ecOK) then begin
      dcOpenFile:= Code;
      Exit;
    end;

    { prepare the first PCX file for reading }
    Code:= dcPrepPage(Cvt, 1);

    dcOpenFile:= Code;
  end;
end;

procedure dcCloseFile(Cvt: PAbsFaxCvt);
{ -Close DCX file }
begin
  with Cvt^, PPcxFaxData(UserData)^, DcxData^ do begin
    Close(InFile);
    if (IoResult = 0) then;
  end;
end;

function dcGetDcxRasterLine(Cvt: PAbsFaxCvt; var Data; var Len: Integer;
  var EndOfPage, MorePages: Bool): Integer;
{ -Callback to read a row of DCX raster data }
begin
  with Cvt^, PPcxFaxData(UserData)^, DcxData^ do begin
    dcGetDcxRasterLine:= pcGetPcxRasterLine(Cvt, Data, Len, EndOfPage, MorePages);

    if EndOfPage then begin
      MorePages:= (CurrPage < DcxNumPag);
      if MorePages then dcGetDcxRasterLine:= dcPrepPage(Cvt, Succ(CurrPage));
    end;
  end;
end;

{ BMP-to-fax conversion routines }

procedure bcInitBmpConverter(var Cvt: PAbsFaxCvt);
{ -Initialize a BMP-to-fax converter }
var
  BmpCvtData: PBitmapFaxData;

begin
  Cvt:= nil;

  { initialize converter specific data }
  BmpCvtData:= AllocMem(SizeOf(TBitmapFaxData));

  { initialize abstract converter }
  acInitFaxConverter(Cvt, BmpCvtData, bcGetBitmapRasterLine, bcOpenFile, bcCloseFile, DefBmpExt);
end;

procedure bcDoneBmpConverter(var Cvt: PAbsFaxCvt);
{ -Destroy a BMP-to-fax converter }
begin
  FreeMem(Cvt^.UserData, SizeOf(TBitmapFaxData));
  acDoneFaxConverter(Cvt);
end;

function bcOpenFile(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open a BMP file for input }
var
  Bmp: Graphics.TBitmap;
begin
  { Open the input file }
  Bmp:= Graphics.TBitmap.Create;
  try
    try
      Bmp.LoadFromFile(FileName);
      Cvt^.InBitmap:= Bmp;
      Result:= bcSetInputBitmap(Cvt, 0);
      if Result <> ecOK then Exit;
      Result:= bcOpenBitmap(Cvt, '');
      if Result <> ecOK then Exit;
    finally
      Bmp.Free;
    end;
  except
    on EInvalidGraphic do Result:= ecBadGraphicsFormat;
    on E: EInOutError do Result:= -E.ErrorCode;
    else
      Result:= ecBadGraphicsFormat;
  end;
end;

procedure bcCloseFile(Cvt: PAbsFaxCvt);
{ -Close BMP file }
begin
  { Call the bitmap converter's Close }
  bcCloseBitmap(Cvt);
end;

function bcGetBmpRasterLine(Cvt: PAbsFaxCvt; var Data; var Len: Integer;
  var EndOfPage, MorePages: Bool): Integer;
{ -Callback to read a row of BMP raster data }
begin
  { Call the bitmap converter's GetRasterLine -- not used internally }
  { This function is retained for backward compatability only }
  Result:= bcGetBitmapRasterLine(Cvt, Data, Len, EndOfPage, MorePages);
end;

procedure bcInitBitmapConverter(var Cvt: PAbsFaxCvt);
{ -Initialize a bitmap-to-fax converter }
var
  BmpCvtData: PBitmapFaxData;

begin
  Cvt:= nil;

  { initialize converter specific data }
  BmpCvtData:= AllocMem(SizeOf(TBitmapFaxData));

  { initialize abstract converter }
  acInitFaxConverter(Cvt, BmpCvtData, bcGetBitmapRasterLine, bcOpenBitmap, bcCloseBitmap, '');
end;

procedure bcDoneBitmapConverter(var Cvt: PAbsFaxCvt);
{ -Destroy a bitmap-to-fax converter }
begin
  FreeMem(Cvt^.UserData, SizeOf(TBitmapFaxData));
  acDoneFaxConverter(Cvt);
end;

function bcSetInputBitmap(var Cvt: PAbsFaxCvt; Bitmap: HBitmap): Integer;
{ -Set bitmap that will be converted }
var
  BmpInfo: TBitmap;
begin
  if (Bitmap = 0) and (Cvt^.InBitmap = nil) then Result:= ecBadArgument
  else
    with PBitmapFaxData(Cvt^.UserData)^ do begin
      if Bitmap = 0 then begin
        DataBitmap:= Graphics.TBitmap.Create;
        DataBitmap.Assign(Graphics.TBitmap(Cvt^.InBitmap));
        BmpHandle:= DataBitmap.Handle;
      end else begin
        GetObject(Bitmap, SizeOf(TBitmap), @BmpInfo);
        if (BmpInfo.bmBitsPixel <> 1) then begin
          Result:= ecBadArgument;
          Exit;
        end else begin
          BmpHandle:= Bitmap;
        end;
      end;
      Result:= ecOK;
    end;
end;

procedure InitDitherMatrix(Cvt: PAbsFaxCvt);

  function DV(X, Y, Size: Integer): Integer;
  begin
    Result:= 0;
    while Size > 0 do begin
      Result:= Result shl 1 or ((X and 1) xor (Y and 1)) shl 1 or (Y and 1);
      X:= X shr 1;
      Y:= Y shr 1;
      dec(Size);
    end;
  end;

var
  I, J: Integer;
begin
  with Cvt^, PBitmapFaxData(Cvt^.UserData)^ do begin
    for I:= 0 to Pred(DMSize) do
      for J:= 0 to Pred(DMSize) do DM[I, J]:= 10 * DV(I, J, 4);
  end;
end;

function bcGetDitheredRasterLine(Cvt: PAbsFaxCvt; var Data; var Len: Integer;
  var EndOfPage, MorePages: Bool): Integer;
{ -Read a raster line from a non-monochrome bitmap and dither it }
type
  TColorRec = packed record
    R: Byte;
    G: Byte;
    B: Byte;
    D: Byte;
  end;
const
  BitArray: array[0 .. 7] of Byte = ($01, $80, $40, $20, $10, $08, $04, $02);
var
  I, YOffset: Integer;
  B: ^Byte;
  BitOffset: Byte;
  Clr: TColorRec;
  Pix: TColor;
begin
  Result:= ecOK;
  with Cvt^, PBitmapFaxData(Cvt^.UserData)^ do begin
    MorePages:= False;
    EndOfPage:= (OnLine >= NumLines);
    YOffset:= Pred(OnLine) mod DMSize;
    B:= @TByteArray(Data)[CenterOfs];
    for I:= 0 to Pred(Width) do begin
      Pix:= DataBitmap.Canvas.Pixels[I, Pred(OnLine)];
      Clr:= TColorRec(Pix);
      BitOffset:= (Succ(I) mod 8);
      if ((Clr.B) + (Clr.G) + (Clr.R)) < DM[(I mod DMSize), (YOffset)] then
        { set the appropriate bit }
          B^:= B^ or BitArray[BitOffset];
      if (BitOffset = 0) then begin
        Application.ProcessMessages;
        Inc(B);
      end;
    end;

    Len:= ResWidth shr 3; { divide by 8 }

    Inc(offset, BytesPerLine);
    Inc(OnLine);
    Inc(BytesRead, BytesPerLine);
  end;
end;

function bcOpenBitmap(Cvt: PAbsFaxCvt; FileName: string): Integer;
{ -Open bitmap "file" }
var
  BmpInfo: TBitmap;
  Sz: Integer;
  COffset: Integer;

begin
  with Cvt^, PBitmapFaxData(Cvt^.UserData)^ do begin
    if (BmpHandle = 0) then begin
      bcOpenBitmap:= ecBadArgument;
      Exit;
    end;

    { initialize fields of bitmap data structure }
    GetObject(BmpHandle, SizeOf(TBitmap), @BmpInfo);
    BytesPerLine:= BmpInfo.bmWidthBytes;
    Width:= BmpInfo.bmWidth;
    Sz:= Integer(BytesPerLine) * BmpInfo.bmHeight;
    BytesToRead:= Sz;
    NumLines:= BmpInfo.bmHeight;
    OnLine:= 1;
    offset:= 0;

    if (BmpInfo.bmBitsPixel <> 1) then begin
      NeedsDithering:= True;
      GetLine:= bcGetDitheredRasterLine;
      InitDitherMatrix(Cvt);
    end;

    if FlagIsSet(Flags, fcDoubleWidth) then
        DoubleWidth:= not UseHighRes and
        ((BmpInfo.bmWidth * 2) <= Integer(ResWidth - (LeftMargin * 2)));
    { section rewritten }
    HalfHeight:= not UseHighRes and not DoubleWidth and FlagIsSet(Flags, fcHalfHeight);

    { center image in fax image }
    CenterOfs:= 0;

    if FlagIsSet(Flags, fcCenterImage) then begin
      { only center if at least one byte on each side }
      if DoubleWidth then
          COffset:= (Integer(ResWidth) - (Integer(BmpInfo.bmWidth) + Integer(LeftMargin))* 2) div 32
      else COffset:= (Integer(ResWidth) - Integer(BmpInfo.bmWidth) - Integer(LeftMargin)) div 16;
      if (COffset < 0) then CenterOfs:= 0
      else CenterOfs:= COffset;
    end;
    { end rewrite }

    if not NeedsDithering then begin
      { allocate memory to hold the bitmap }
      BitmapBufHandle:= GlobalAlloc(gmem_Moveable or gmem_ZeroInit, Sz);
      if (BitmapBufHandle = 0) then begin
        bcOpenBitmap:= ecOutOfMemory;
        Exit;
      end;
      BitmapBuf:= GlobalLock(BitmapBufHandle);

      { put bitmap data into buffer }
      GetBitmapBits(BmpHandle, Sz, BitmapBuf);
    end;

    bcOpenBitmap:= ecOK;
  end;
end;

procedure bcCloseBitmap(Cvt: PAbsFaxCvt);
{ -Close bitmap "file" }
begin
  with Cvt^, PBitmapFaxData(Cvt^.UserData)^ do begin
    GlobalUnlock(BitmapBufHandle);
    GlobalFree(BitmapBufHandle);
    DataBitmap.Free;

    FastZero(UserData^, SizeOf(TBitmapFaxData));
  end;
end;

function bcGetBitmapRasterLine(Cvt: PAbsFaxCvt; var Data; var Len: Integer;
  var EndOfPage, MorePages: Bool): Integer;
{ -Read a raster line from a bitmap }
var
  ActiveBits: Integer;
  Mask: Byte;
  I: Integer;
  ActBytesPerLine: Integer;
begin
  bcGetBitmapRasterLine:= ecOK;

  with Cvt^, PBitmapFaxData(Cvt^.UserData)^ do begin
    { Just in case someone uses this function externally }
    if NeedsDithering then begin
      Result:= bcGetDitheredRasterLine(Cvt, Data, Len, EndOfPage, MorePages);
      Exit;
    end;
    MorePages:= False;
    EndOfPage:= (OnLine >= NumLines);

    if (CenterOfs = 0) then Move(GetPtr(BitmapBuf, offset)^, Data, BytesPerLine)
    else Move(GetPtr(BitmapBuf, offset)^, TByteArray(Data)[CenterOfs], BytesPerLine);
    Len:= ResWidth div 8;

    { section rewritten }
    { the number of bytes stored in BytesPerLine is *always* even, so
      we need to (1) set any unused bits in the last partial byte to
      'white' or 1, and (2) set the last full byte (if it exists!) to
      white as well. }
    ActBytesPerLine:= (Width + 7) div 8;
    if (ActBytesPerLine <> Integer(BytesPerLine)) then
        TByteArray(Data)[Integer(CenterOfs) + ActBytesPerLine]:= $FF;
    ActiveBits:= Width mod 8;
    if (ActiveBits <> 0) then begin
      Mask:= 0;
      for I:= ActiveBits to 7 do Mask:= (Mask shl 1) or 1;
      TByteArray(Data)[Integer(CenterOfs) + (ActBytesPerLine - 1)]:= TByteArray(Data)
        [Integer(CenterOfs) + (ActBytesPerLine - 1)] or Mask;
    end;
    { end new }

    NotBuffer(TByteArray(Data)[CenterOfs], BytesPerLine);

    Inc(offset, BytesPerLine);
    Inc(OnLine);
    Inc(BytesRead, BytesPerLine);
  end;
end;


{utilitarian routines}

function ActualLen(var Data; Len: Cardinal): Cardinal; assembler; register;
{ -return actual length, in bytes, of a raster line }
{$IFNDEF CPUX64}
asm
  push  edi

  mov   edi,eax       { eax = Data }
  add   edi,edx       { edx = Len }
  dec   edi
  xor   eax,eax
  mov   ecx,edx
  std
  repe  scasb
  je    @1
  mov   eax,ecx
  inc   eax
@1:
  cld

  pop   edi
end;
{$ELSE}
asm
  // var Data;        RCX
  // Len : Cardinal   EDX
  push  rdi

  mov   rdi,rcx       { eax = Data }
  add   rdi,rdx       { edx = Len }
  dec   rdi
  xor   eax,eax
  mov   ecx,edx
  std
  repe  scasb
  je    @1
  mov   eax,ecx
  inc   eax
@1:
  cld

  pop   rdi
end;
{$ENDIF}

function ActualLenInverted(var Data; Len: Cardinal): Cardinal; assembler; register;
{ -return actual length, in bytes, of a raster line }
{$IFNDEF CPUX64}
asm
  push  edi

  mov   edi,eax       { eax = Data }
  add   edi,edx       { edx = Len }
  dec   edi
  mov   eax,$FFFFFFFF
  mov   ecx,edx
  std
  repe  scasb
  je    @1
  mov   eax,ecx
  inc   eax
  jmp   @2
@1: xor   eax,eax
@2: cld

  pop   edi
end;
{$ELSE}
asm
  // var Data;        RCX
  // Len : Cardinal   RDX
  push  rdi

  mov   rdi,rcx       { eax = Data }
  add   rdi,rdx       { edx = Len }
  dec   rdi
  mov   eax,$FFFFFFFF
  mov   ecx,edx
  std
  repe  scasb
  je    @1
  mov   eax,ecx
  inc   eax
  jmp   @2
@1: xor   eax,eax
@2: cld

  pop   rdi
end;
{$ENDIF}

procedure HalfWidthBuf(var Data; var Len: Cardinal); assembler; register;
{$IFNDEF CPUX64}
asm
  push  esi
  push  ebx

  mov   ecx,[edx]       { ECX is loop counter; EDX->Len }
  shr   ecx,1           { count by words }
  mov   [edx],ecx       { store new length }

  mov   esi,eax         { ESI->Data }
  mov   ebx,esi         { EBX = offset of output }

@1: mov   ax,[esi]
  mov   edx,eax
  mov   ah,al
  mov   al,dh
  xor   edx,edx         { clear output data }

  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1

  or    dh,dl
  mov   [ebx],dh
  inc   ebx
  inc   esi
  inc   esi
  dec   ecx
  jnz   @1

@2: pop   ebx
  pop   esi
end;
{$ELSE}
asm
  push  rsi
  push  rbx

  mov   ecx,[rdx]       { ECX is loop counter; EDX->Len }
  shr   ecx,1           { count by words }
  mov   [rdx],ecx       { store new length }

  mov   rsi,rcx         { ESI->Data }
  mov   rbx,rsi         { EBX = offset of output }

@1: mov   ax,[rsi]
  mov   edx,eax
  mov   ah,al
  mov   al,dh
  xor   edx,edx         { clear output data }

  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1
  shr   ax,1
  rcr   dh,1
  shr   ax,1
  rcr   dl,1

  or    dh,dl
  mov   [rbx],dh
  inc   rbx
  inc   rsi
  inc   rsi
  dec   ecx
  jnz   @1

@2: pop   rbx
  pop   rsi
end;
{$ENDIF}
{Fax unpacking}

function upInitFaxUnpacker(var Unpack: PUnpackFax; Data: Pointer; CB: TUnpackLineCallback): Integer;
{ -Initialize a fax unpacker }
var
  Code: Integer;

label
  Error;

  function BuildTrees: Integer;
  { -Build black and white decompression trees }
  var
    Code: Integer;

    function InitTree(var T: PTreeArray): Integer;
    { -Initialize an empty tree }
    begin
      with Unpack^ do begin
        T:= AllocMem(SizeOf(TTreeArray));
        TreeLast:= 0;
        TreeNext:= 0;
        CurCode:= 0;
        CurSig:= 0;
        InitTree:= ecOK;
      end;
    end;

    procedure BuildTree(T: PTreeArray; var TC: TTermCodeArray; var MUC: TMakeUpCodeArray);
    { -Recursively build a tree containing all fax codes }
    var
      SaveLast: Integer;

      procedure AddCode(Code: Word);
      { -Add a new code element to a tree }
      begin
        with Unpack^ do begin
          Inc(TreeNext);
          if (TreeNext > MaxTreeRec) then
            { out of tree space }
              Exit;

          with T^[TreeLast] do
            if (Code = 1) then Next1:= TreeNext
            else Next0:= TreeNext;
        end;
      end;

      function CodeMatch: Integer;
      { -Return run length of matching code, or -1 for no match }
      var
        I: Integer;
        TCode: Word;

      begin
        with Unpack^ do begin
          TCode:= CurCode;
          RotateCode(TCode, CurSig);
          for I:= 0 to MaxCodeTable do
            with TC[I] do
              if (TCode = Code) and (CurSig = Sig) then begin
                CodeMatch:= I;
                Exit;
              end;

          for I:= 0 to MaxMUCodeTable do
            with MUC[I] do
              if (TCode = Code) and (CurSig = Sig) then begin
                CodeMatch:= 64 * (I + 1);
                Exit;
              end;

          if (TCode = EOLRec.Code) and (CurSig = EOLRec.Sig) then CodeMatch:= -2
          else CodeMatch:= -1;
        end;
      end;

      procedure SetCode(N0, N1: Integer);
      { -Store terminating code }
      begin
        with Unpack^, T^[TreeNext] do begin
          Next0:= N0;
          Next1:= N1;
        end;
      end;

    begin
      with Unpack^ do begin
        if (CurSig < 13) then begin
          { add a 0 to the tree }
          AddCode(0);
          Inc(CurSig);
          CurCode:= CurCode shl 1;
          Match:= CodeMatch;
          case Match of
            - 2: { end of line } SetCode(-2, 0);
            -1: { no match } begin { use recursion to add next bit }
                SaveLast:= TreeLast;
                TreeLast:= TreeNext;
                BuildTree(T, TC, MUC);
                TreeLast:= SaveLast;
              end;
          else SetCode(-1, Match);
          end;

          { add a 1 to the tree }
          AddCode(1);
          CurCode:= CurCode or 1;
          Match:= CodeMatch;
          case Match of
            - 2: { end of line } SetCode(-2, 0);
            -1: begin { use recursion to add next bit }
                SaveLast:= TreeLast;
                TreeLast:= TreeNext;
                BuildTree(T, TC, MUC);
                TreeLast:= SaveLast;
              end;
          else SetCode(-1, Match);
          end;

          CurCode:= CurCode shr 1;
          dec(CurSig);
        end;
      end;
    end;

  begin
    with Unpack^ do begin
      Code:= InitTree(WhiteTree);
      if (Code < ecOK) then begin
        BuildTrees:= Code;
        Exit;
      end;

      BuildTree(WhiteTree, WhiteTable, WhiteMUTable);
      { force a loop into the table for EOL resync }
      WhiteTree^[11].Next0:= 11;

      Code:= InitTree(BlackTree);
      if (Code < ecOK) then begin
        FreeMem(WhiteTree, SizeOf(TTreeArray));
        BuildTrees:= Code;
        Exit;
      end;

      BuildTree(BlackTree, BlackTable, BlackMUTable);
      { force a loop into the table for EOL resync }
      BlackTree^[11].Next0:= 11;

      BuildTrees:= ecOK;
    end;
  end;

begin
  Unpack:= AllocMem(SizeOf(TUnpackFax));

  with Unpack^ do begin
    UserData:= Data;
    Flags:= DefUnpackOptions;
    LineBuffer:= nil;
    TmpBuffer:= nil;
    FileBuffer:= nil;
    WhiteTree:= nil;
    BlackTree:= nil;

    LineBuffer:= AllocMem(LineBufSize + 16); { ~~ }
    TmpBuffer:= AllocMem(LineBufSize);
    FileBuffer:= AllocMem(MaxData);

    with Scale do begin
      HMult:= 1;
      HDiv:= 1;
      VMult:= 1;
      VDiv:= 1;
    end;

    Code:= BuildTrees;
    OutputLine:= CB;
  end;

Error:
  if (Code < ecOK) then begin
    FreeMem(Unpack^.FileBuffer, MaxData);
    FreeMem(Unpack^.LineBuffer, LineBufSize + 16); { ~~ }
    FreeMem(Unpack^.TmpBuffer, LineBufSize);
    FreeMem(Unpack, SizeOf(TUnpackFax));
    Unpack:= nil;
  end;

  upInitFaxUnpacker:= Code;
end;

procedure upDoneFaxUnpacker(var Unpack: PUnpackFax);
{ -Destroy a fax unpacker }
begin
  FreeMem(Unpack^.WhiteTree, SizeOf(TTreeArray));
  FreeMem(Unpack^.BlackTree, SizeOf(TTreeArray));
  FreeMem(Unpack^.FileBuffer, MaxData);
  FreeMem(Unpack^.LineBuffer, LineBufSize + 16); { ~~ }
  FreeMem(Unpack^.TmpBuffer, LineBufSize);
  FreeMem(Unpack, SizeOf(TUnpackFax));
  Unpack:= nil;
end;

procedure upOptionsOn(Unpack: PUnpackFax; OptionFlags: Word);
{ -Turn on one or more unpacker options }
const
  BadCombo = ufAutoDoubleHeight or ufAutoHalfWidth;

begin
  with Unpack^ do begin
    if ((OptionFlags and BadCombo) = BadCombo) then Exit;

    if (((Flags or OptionFlags) and BadCombo) = BadCombo) then upOptionsOff(Unpack, BadCombo);
    Flags:= Flags or (OptionFlags and not BadUnpackOptions);
  end;
end;

procedure upOptionsOff(Unpack: PUnpackFax; OptionFlags: Word);
{ -Turn off one or more unpacker options }
begin
  with Unpack^ do Flags:= Flags and not(OptionFlags and not BadUnpackOptions);
end;

function upOptionsAreOn(Unpack: PUnpackFax; OptionFlags: Word): Bool;
{ -Return True if all specified options are on }
begin
  upOptionsAreOn:= ((Unpack^.Flags and OptionFlags) = OptionFlags);
end;

procedure upSetStatusCallback(Unpack: PUnpackFax; Callback: TUnpackStatusCallback);
{ -Set up a routine to be called to report unpack status }
begin
  Unpack^.Status:= Callback;
end;

function upSetWhitespaceCompression(Unpack: PUnpackFax; FromLines, ToLines: Cardinal): Integer;
{ -Set the whitespace compression option. }
begin
  if (ToLines > FromLines) or ((FromLines = 0) and (ToLines <> 0)) then begin
    upSetWhitespaceCompression:= ecBadArgument;
    Exit;
  end;
  upSetWhitespaceCompression:= ecOK;

  with Unpack^ do begin
    WSFrom:= FromLines;
    WSTo:= ToLines;
  end;
end;

procedure upSetScaling(Unpack: PUnpackFax; HMult, HDiv, VMult, VDiv: Cardinal);
{ -Set horizontal and vertical scaling factors }
begin
  with Unpack^ do begin
    Scale.HMult:= HMult;
    Scale.HDiv:= HDiv;
    Scale.VMult:= VMult;
    Scale.VDiv:= VDiv;
  end;
end;

function ValidSignature(var TestSig): Bool;
var
  T: TSigArray absolute TestSig;

begin
  ValidSignature:= (T = DefAPFSig);
end;

function upGetFaxHeader(Unpack: PUnpackFax; FName: string; var FH: TFaxHeaderRec): Integer;
{ -Return header for fax FName }
var
  Code: Integer;
  SaveMode: Integer;
  F: file;

label
  ExitPoint;

begin
  { protect against empty filename }
  if (FName = '') then begin
    upGetFaxHeader:= ecFileNotFound;
    Exit;
  end;

  with Unpack^ do begin
    { open the fax file }
    SaveMode:= FileMode;
    FileMode:= ApdShareFileRead;
    Assign(F, FName);
    Reset(F, 1);
    FileMode:= SaveMode;
    Code:= -IoResult;
    if (Code < ecOK) then begin
      upGetFaxHeader:= Code;
      Exit;
    end;

    { read the fax header }
    BlockRead(F, FH, SizeOf(TFaxHeaderRec));
    Code:= -IoResult;
    if (Code < ecOK) then goto ExitPoint;

    if not ValidSignature(FH) then begin
      Code:= ecFaxBadFormat;
      goto ExitPoint;
    end;

    Code:= ecOK;

  ExitPoint:
    Close(F);
    if (IoResult = 0) then;

    upGetFaxHeader:= Code;
  end;
end;

function upGetPageHeader(Unpack: PUnpackFax; FName: string; Page: Cardinal;
  var PH: TPageHeaderRec): Integer;
{ -Return header for Page in fax FName }
var
  offset: Integer;
  I: Cardinal;
  SaveMode: Integer;
  Code: Integer;
  FH: TFaxHeaderRec;
  F: file;

label
  ExitPoint;

begin
  { protect against empty filename }
  if (FName = '') then begin
    upGetPageHeader:= ecFileNotFound;
    Exit;
  end;

  with Unpack^ do begin
    SaveMode:= FileMode;
    FileMode:= ApdShareFileRead;
    Assign(F, FName);
    Reset(F, 1);
    FileMode:= SaveMode;
    Code:= -IoResult;
    if (Code < ecOK) then begin
      upGetPageHeader:= Code;
      Exit;
    end;

    { read header }
    BlockRead(F, FH, SizeOf(TFaxHeaderRec));
    Code:= -IoResult;
    if (Code < ecOK) then goto ExitPoint;

    if not ValidSignature(FH) then begin
      Code:= ecFaxBadFormat;
      goto ExitPoint;
    end;

    if (Page > FH.PageCount) then begin
      Code:= ecFaxBadFormat;
      goto ExitPoint;
    end;

    { read the header of each page until we get to the one we want }
    offset:= FH.PageOfs;
    for I:= 1 to Page do begin
      Seek(F, offset);
      Code:= -IoResult;
      if (Code < ecOK) then goto ExitPoint;
      BlockRead(F, PH, SizeOf(TPageHeaderRec));
      Code:= -IoResult;
      if (Code < ecOK) then goto ExitPoint;

      Inc(offset, SizeOf(TPageHeaderRec) + PH.ImgLength);
    end;

    Code:= ecOK;

  ExitPoint:
    Close(F);
    if (IoResult = 0) then;
    upGetPageHeader:= Code;
  end;
end;

procedure upOutputRun(Unpack: PUnpackFax; IsWhite: Bool; Len: Integer);
{ -Output current run }

  procedure UpdateLinePosition(UP: PUnpackFax; Len: Integer); assembler; register;
  {$IFNDEF CPUX64}
  asm
    push  edi

    mov   edi,eax       { eax = UP }
    { edx = Len }
    add   edx,[edi].TUnpackFax.LineBit
    mov   eax,edx
    shr   eax,3
    add   [edi].TUnpackFax.LineOfs,eax
    and   edx,7
    mov   [edi].TUnpackFax.LineBit,edx

    pop   edi
  end;
  {$ELSE}
  asm
    push  rdi

    mov   rdi,rcx       { eax = UP }
    { edx = Len }
    add   edx,[rdi].TUnpackFax.LineBit
    mov   eax,edx
    shr   eax,3
    add   [rdi].TUnpackFax.LineOfs,eax
    and   edx,7
    mov   [rdi].TUnpackFax.LineBit,edx

    pop   rdi
  end;
  {$ENDIF}
  procedure OutputBlackRun(UP: PUnpackFax; Len: Integer); assembler; register;
  {$IFNDEF CPUX64}
  asm
    push  edi
    push  ebx

    mov   edi,eax       { eax = UP }
    push  edi
    mov   ecx,edx       { edx = Len }

    mov   ebx,[edi].TUnpackFax.LineBit
    mov   eax,[edi].TUnpackFax.LineOfs
    mov   edi,[edi].TUnpackFax.LineBuffer
    add   edi,eax
    or    ebx,ebx
    jz    @3
    mov   edx,ecx
    mov   al,$80
    mov   cl,bl
    shr   al,cl
    mov   ecx,edx

  @1: or    byte ptr [edi],al
    inc   ebx
    shr   al,1
    dec   ecx
    cmp   ebx,8
    jae   @2
    or    ecx,ecx
    jz    @2
    jmp   @1

  @2: mov   eax,ebx
    shr   eax,3
    add   edi,eax
    and   ebx,7

  @3: cmp   ecx,8
    jb    @4
    mov   edx,ecx
    shr   ecx,3
    cld
    mov   al,$FF
    rep   stosb
    and   edx,7
    mov   ecx,edx

  @4: or    ecx,ecx
    jz    @6
    mov   edx,ecx
    mov   al,$80
    mov   cl,bl
    shr   al,cl
    mov   ecx,edx

  @5: or    byte ptr [edi],al
    inc   ebx
    shr   al,1
    dec   ecx
    jnz   @5

  @6: mov   eax,edi
    pop   edi
    sub   eax,[edi].TUnpackFax.LineBuffer
    mov   [edi].TUnpackFax.LineOfs,eax
    mov   [edi].TUnpackFax.LineBit,ebx

    pop   ebx
    pop   edi
  end;
  {$ELSE}
  asm
    push  rdi
    push  rbx
    mov   rax,rcx

    mov   rdi,rax       { eax = UP }
    push  rdi
    mov   ecx,edx       { edx = Len }

    mov   ebx,[rdi].TUnpackFax.LineBit
    mov   eax,[rdi].TUnpackFax.LineOfs
    mov   rdi,[rdi].TUnpackFax.LineBuffer
    add   rdi,rax
    or    ebx,ebx
    jz    @3
    mov   edx,ecx
    mov   al,$80
    mov   cl,bl
    shr   al,cl
    mov   ecx,edx

  @1: or    byte ptr [rdi],al
    inc   ebx
    shr   al,1
    dec   ecx
    cmp   ebx,8
    jae   @2
    or    ecx,ecx
    jz    @2
    jmp   @1

  @2: mov   eax,ebx
    shr   eax,3
    add   rdi,rax
    and   ebx,7

  @3: cmp   ecx,8
    jb    @4
    mov   edx,ecx
    shr   ecx,3
    cld
    mov   al,$FF
    rep   stosb
    and   edx,7
    mov   ecx,edx

  @4: or    ecx,ecx
    jz    @6
    mov   edx,ecx
    mov   al,$80
    mov   cl,bl
    shr   al,cl
    mov   ecx,edx

  @5: or    byte ptr [rdi],al
    inc   ebx
    shr   al,1
    dec   ecx
    jnz   @5

  @6: mov   rax,rdi
    pop   rdi
    mov   r9,[rdi].TUnpackFax.LineBuffer
    sub   rax,r9
    mov   [rdi].TUnpackFax.LineOfs,eax
    mov   [rdi].TUnpackFax.LineBit,ebx

    pop   rbx
    pop   rdi
  end;
  {$ENDIF}

  begin
    with Unpack^ do begin
      if Len > 0 then
        if IsWhite then begin
          { update line position; line already filled with zeros }
          UpdateLinePosition(Unpack, Len);
        end else begin
          OutputBlackRun(Unpack, Len);
        end;
    end;
  end;


function upValidLineLength(Unpack: PUnpackFax; Len: Cardinal): Bool;
{ -Return True if Len is a valid line length }
begin
  with Unpack^ do upValidLineLength:= (Len = (StandardWidth div 8)) or (Len = (WideWidth div 8))
end;

function LineHasData(var Buf; Len: Cardinal): Boolean; assembler; register;
{ -Return TRUE if raster row contains any non-zero bytes }
{$IFNDEF CPUX64}
asm
  push  edi

  cld
  mov   edi,eax   { eax = Buf }
  xor   eax,eax
  mov   ecx,edx   { edx = Len }
  rep   scasb
  je    @2
@1: inc   eax
@2:
  pop   edi
end;
{$ELSE}
asm
  push  rdi

  cld
  mov   rdi,rcx   { eax = Buf }
  xor   eax,eax
  mov   ecx,edx   { edx = Len }
  rep   scasb
  je    @2
@1: inc   eax
@2:
  pop   rdi
end;
{$ENDIF}

function upOutputLine(Unpack: PUnpackFax; TheFlags: Cardinal): Integer;
{ -Output an unpacked raster line }
var
  Code: Integer;
  TheLen: Cardinal;

begin
  with Unpack^ do begin
    Code:= ecOK;

    TheLen:= LineOfs;
    if ((TheFlags and upStarting) = 0) and ((TheFlags and upEnding) = 0) then begin
      if Inverted then NotBuffer(LineBuffer^, LineOfs);

      { automatically output a second copy of the line, if desired }
      if ((PageHeader.ImgFlags and ffHighRes) = 0) then
        if ((Flags and ufAutoDoubleHeight) <> 0) and (@OutputLine <> nil) then begin
          Code:= OutputLine(Unpack, TheFlags, LineBuffer^, TheLen, CurrPage);
          if (Code < ecOK) then begin
            upOutputLine:= Code;
            Exit;
          end;
        end else if ((Flags and ufAutoHalfWidth) <> 0) and (LineOfs <> 0) then
            HalfWidthBuf(LineBuffer^, TheLen);
    end;

    if (@OutputLine <> nil) then Code:= OutputLine(Unpack, TheFlags, LineBuffer^, TheLen, CurrPage);

    upOutputLine:= Code;
  end;
end;

function upUnpackPagePrim(Unpack: PUnpackFax; FName: string; Page: Cardinal): Integer;
{ -Unpack page number Page, calling the put line callback for each raster line }
var
  Code: Integer;
  LengthWords: Bool;
  IsWhite: Bool;
  CheckZero: Bool;
  WaitEOL: Bool;
  CurTree: PTreeArray;
  TreeIndex: Integer;
  LineCnt: Cardinal;
  CurOfs: Cardinal;
  EndOfs: Cardinal;
  ActRead: Cardinal;
  TotRead: Integer;
  RunLen: Cardinal;
  CurByte: Byte;
  CurMask: Byte;
  F: file;

  procedure ReportStatus;
  begin
    with Unpack^ do
      if (@Status <> nil) then
        if (ImgRead > ImgBytes) then Status(Unpack, FName, Page, ImgBytes, ImgBytes)
        else Status(Unpack, FName, Page, ImgRead, ImgBytes);
  end;

label
  ExitPoint,
  Again;

  function ReadNextLine: Integer;
  { -Read the next wordlength raster line }
  var
    Len: Word;
    Code: Integer;

  begin
    { read length word }
    BlockRead(F, Len, SizeOf(Word));
    Code:= -IoResult;
    if (Code < ecOK) then begin
      ReadNextLine:= Code;
      Exit;
    end;

    { trim the line if too long }
    if (Len > MaxData) then Len:= MaxData;

    { read the data }
    BlockRead(F, Unpack^.FileBuffer^, Len);
    ActRead:= Len;
    ReadNextLine:= -IoResult;
  end;

  function OpenFaxFile: Integer;
  { -Read and validate the fax file's header }
  var
    Code: Integer;
    SaveMode: Integer;

  begin
    { protect against empty filename }
    if (FName = '') then begin
      OpenFaxFile:= ecFileNotFound;
      Exit;
    end;

    { open the fax file }
    SaveMode:= FileMode;
    FileMode:= ApdShareFileRead;
    Assign(F, FName);
    Reset(F, 1);
    FileMode:= SaveMode;
    Code:= -IoResult;
    if (Code < ecOK) then begin
      OpenFaxFile:= Code;
      Exit;
    end;

    { seek past the fax header }
    BlockRead(F, Unpack^.FaxHeader, SizeOf(TFaxHeaderRec));
    Code:= -IoResult;
    if (Code < ecOK) then begin
      OpenFaxFile:= Code;
      Close(F);
      if (IoResult = 0) then;
      Exit;
    end;

    { validate the fax header }
    if not ValidSignature(Unpack^.FaxHeader) then begin
      OpenFaxFile:= ecFaxBadFormat;
      Close(F);
      if (IoResult = 0) then;
      Exit;
    end;

    { make sure the page is in range }
    if (Page > Unpack^.FaxHeader.PageCount) then begin
      OpenFaxFile:= ecFaxBadFormat;
      Close(F);
      if (IoResult = 0) then;
      Exit;
    end;

    OpenFaxFile:= ecOK;
  end;

  function FindPage: Integer;
  { -Find the page to unpack }
  var
    Code: Integer;
    Posn: Integer;
    X: Cardinal;

  begin
    with Unpack^ do begin
      { find the header of the first page }
      Seek(F, FaxHeader.PageOfs);
      BlockRead(F, PageHeader, SizeOf(TPageHeaderRec));
      Code:= -IoResult;
      if (Code < ecOK) then begin
        FindPage:= Code;
        Exit;
      end;

      LengthWords:= FlagIsSet(PageHeader.ImgFlags, ffLengthWords);

      Posn:= FilePos(F);
      if (Page > 1) then
        { read the header of each page and seek to the next up to Page }
        for X:= 1 to Pred(Page) do begin
          { get the position of the next page header }
          Inc(Posn, PageHeader.ImgLength);

          { seek to to the next page header and read it }
          Seek(F, Posn);
          BlockRead(F, PageHeader, SizeOf(TPageHeaderRec));
          Code:= -IoResult;
          if (Code < ecOK) then begin
            FindPage:= Code;
            Exit;
          end;

          LengthWords:= FlagIsSet(PageHeader.ImgFlags, ffLengthWords);

          Posn:= FilePos(F);
        end;
    end;

    FindPage:= ecOK;
  end;

  function OutputBlanks(Num: Cardinal): Integer;
  var
    I: Cardinal;
    Code: Integer;

  begin
    Unpack^.LineOfs:= 0;
    for I:= 1 to Num do begin
      Inc(Unpack^.CurrLine);
      Code:= upOutputLine(Unpack, 0);
      if (Code < ecOK) then begin
        OutputBlanks:= Code;
        Exit;
      end;
    end;

    OutputBlanks:= ecOK;
  end;

  procedure InitForNextLine;
  begin
    with Unpack^ do begin
      FastZero(LineBuffer^, LineOfs);
      LineOfs:= 0;
      LineBit:= 0;
      IsWhite:= True;
      CurTree:= WhiteTree;
    end;
  end;

  function OutputRasterLine: Integer;
  { -Output a line and perform whitespace compression }
  var
    SaveOfs: Cardinal;

  begin
    OutputRasterLine:= ecOK;

    with Unpack^ do begin
      { check whitespace count if whitespace compression active }
      if (WSFrom <> 0) and (WSTo <> 0) then begin
        if LineHasData(LineBuffer^, LineOfs) then begin
          { if there were more than WSFrom white lines, output WSTo }
          { white lines }
          SaveOfs:= LineOfs;

          if (WSFrom > 0) and (WhiteCount >= WSFrom) then Code:= OutputBlanks(WSTo)

            { otherwise, output WhiteCount blanks }
          else if (WhiteCount > 0) then Code:= OutputBlanks(WhiteCount)
          else Code:= ecOK;

          if (Code < ecOK) then begin
            OutputRasterLine:= Code;
            Exit;
          end;

          WhiteCount:= 0;

          { output the data normally }
          LineOfs:= SaveOfs;
          OutputRasterLine:= upOutputLine(Unpack, 0);

          InitForNextLine;
        end else begin
          Inc(WhiteCount);
          InitForNextLine;
        end;
      end else begin
        OutputRasterLine:= upOutputLine(Unpack, 0);
        InitForNextLine;
      end;

      Inc(CurrLine);
    end;
  end;

  function OutputRemainingBlanks: Integer;
  begin
    with Unpack^ do begin
      { output any remaining whitespace }
      if (WhiteCount > 0) and (WSFrom <> WSTo) then
        if (WhiteCount >= WSFrom) then Code:= OutputBlanks(WSTo)
        else Code:= OutputBlanks(WhiteCount)
      else Code:= ecOK;

      OutputRemainingBlanks:= Code;
    end;
  end;

begin
  with Unpack^ do begin
    WhiteCount:= 0;
    CurrLine:= 0;

    Code:= OpenFaxFile;
    if (Code < ecOK) then begin
      upUnpackPagePrim:= Code;
      Exit;
    end;

    Code:= FindPage;
    if (Code < ecOK) then goto ExitPoint;

    { initialize decompression vars }
    FastZero(LineBuffer^, LineBufSize);
    IsWhite:= True;
    CurTree:= WhiteTree;
    TreeIndex:= 0;
    LineOfs:= 0;
    LineBit:= 0;
    LineCnt:= 0;
    CurOfs:= 0;
    EndOfs:= 0;
    ActRead:= 0;
    TotRead:= 0;

    CheckZero:= False;
    WaitEOL:= True;
    Code:= ecOK;

    repeat
      if (LineCnt >= 3) then
        { More than 3 blank EOL's means end of fax page. This is the normal exit point for this loop. }
          goto ExitPoint;

      if CurOfs >= ActRead then begin
        if LengthWords then begin
          Code:= ReadNextLine;
          if (Code < ecOK) then goto ExitPoint;
        end else begin
        Again:
          { have we read the whole image? }
          if (TotRead >= PageHeader.ImgLength) and (TotRead > 0) then goto ExitPoint;

          { Get a FileBuffer from the file }
          BlockRead(F, FileBuffer^, MaxData, ActRead);
          Code:= -IoResult;
          if (Code < ecOK) then goto ExitPoint;

          if (ActRead = 0) then begin
            { End of file without fax terminator }
            Code:= ecFaxBadFormat;
            goto ExitPoint;
          end;
        end;

        { If the page image ends within this buffer, mark the end-of-image offset relative to the start of the buffer
          so we don't decode past it if the page terminating sequence of blank lines is missing.
          The current value of TotRead is the buffer start position relative to the start of the page. }
        EndOfs:= Integer(PageHeader.ImgLength) - TotRead;

        Inc(TotRead, ActRead);
        Inc(ImgRead, ActRead);
        if LengthWords then begin
          Inc(TotRead, SizeOf(Word));
          Inc(ImgRead, SizeOf(Word));
        end;
        CurOfs:= 0;

      end;

      { Exit if end of page data has been reached }
      if CurOfs > EndOfs then begin
        Code:= ecOK;
        goto ExitPoint;
      end;

      CurByte:= FileBuffer^[CurOfs];
      Inc(CurOfs);

      CurMask:= $01;
      while CurMask <> 0 do begin
        if (CurByte and CurMask <> 0) then begin
          if not CheckZero then TreeIndex:= CurTree^[TreeIndex].Next1;
        end else begin
          CheckZero:= False;
          TreeIndex:= CurTree^[TreeIndex].Next0;
        end;
        case CurTree^[TreeIndex].Next0 of
          - 1: { complete code } begin
              if not WaitEOL then begin
                RunLen:= CurTree^[TreeIndex].Next1;
                if (LineOfs +(RunLen shr 3)) < LineBufSize then begin
                  upOutputRun(Unpack, IsWhite, RunLen);
                  if RunLen < 64 then begin
                    IsWhite:= not IsWhite;
                    if IsWhite then CurTree:= WhiteTree
                    else CurTree:= BlackTree;
                  end;
                end;
              end;
              TreeIndex:= 0;
              LineCnt:= 0;
            end;
          -2: { end of line } begin { ignore blank line if first line or a terminator }
              if (LineOfs > 0) or (LineBit > 0) then begin
                if upValidLineLength(Unpack, LineOfs) then begin
                  Code:= OutputRasterLine;
                  if (Code < ecOK) then goto ExitPoint;
                end
                else InitForNextLine;
              end
              else InitForNextLine;
              TreeIndex:= 0;
              Inc(LineCnt);
              WaitEOL:= False;
            end;
          +0: { invalid code, ignore and start over } begin
              TreeIndex:= 0;
              Inc(BadCodes);
              CheckZero:= True;
            end;
        end;
        CurMask:= (CurMask and $7F) shl 1;
      end;

      if upOptionsAreOn(Unpack, ufAbort) then goto ExitPoint;

      if upOptionsAreOn(Unpack, ufYield) and ((CurrLine and 15) = 0) then begin
        Code:= ConverterYield;
        if (Code < ecOK) then goto ExitPoint;
      end;

      ReportStatus;
    until False;

  ExitPoint:
    { output any remaining blank lines }
    if (Code = ecOK) then Code:= OutputRemainingBlanks;

    ReportStatus;

    upUnpackPagePrim:= Code;
    Close(F);
    if (IoResult = 0) then;
  end;
end;

function upOutputBuffer(Unpack: PUnpackFax): Integer;
{ -Output a memory bitmap buffer to user callback }
var
  I: Integer;
  Code: Integer;

begin
  with Unpack^ do begin
    { tell the output function we're starting }
    Code:= upOutputLine(Unpack, upStarting);
    if (Code < ecOK) then begin
      upOutputBuffer:= Code;
      GlobalFree(Handle);
      Exit;
    end;

    { output each line of the buffer to the output function }
    for I:= 0 to Pred(Height) do begin
      Move(GetPtr(Lines, Integer(Width) * I)^, LineBuffer^, Width);
      Code:= upOutputLine(Unpack, 0);
      if (Code < ecOK) then begin
        upOutputBuffer:= Code;
        GlobalFree(Handle);
        Exit;
      end;
    end;

    { tell the output function the output is done }
    upOutputBuffer:= upOutputLine(Unpack, upEnding);
  end;
end;

function upInitPageUnpack(Unpack: PUnpackFax; FName: string; Page: Cardinal): Integer;
var
  Code: Integer;
  PH: TPageHeaderRec;

begin
  with Unpack^ do begin
    ImgBytes:= 0;
    ImgRead:= 0;

    Code:= upGetPageHeader(Unpack, FName, Page, PH);
    if (Code < ecOK) then begin
      upInitPageUnpack:= Code;
      Exit;
    end;

    upInitPageUnpack:= ecOK;

    ImgBytes:= PH.ImgLength;
  end;
end;

function upInitFileUnpack(Unpack: PUnpackFax; FName: string): Integer;
var
  Code: Integer;
  OnPage: Cardinal;
  FH: TFaxHeaderRec;
  PH: TPageHeaderRec;
  FaxFile: file;

label
  ErrorExit;

begin
  { protect against empty filename }
  if (FName = '') then begin
    upInitFileUnpack:= ecFileNotFound;
    Exit;
  end;

  with Unpack^ do begin
    ImgBytes:= 0;
    ImgRead:= 0;

    Assign(FaxFile, FName);
    Reset(FaxFile, 1);
    Code:= -IoResult;
    if (Code < ecOK) then begin
      upInitFileUnpack:= Code;
      Exit;
    end;

    BlockRead(FaxFile, FH, SizeOf(TFaxHeaderRec));
    Seek(FaxFile, FH.PageOfs);
    Code:= -IoResult;
    if (Code < ecOK) then goto ErrorExit;

    for OnPage:= 1 to FH.PageCount do begin
      BlockRead(FaxFile, PH, SizeOf(TPageHeaderRec));
      Code:= -IoResult;
      if (Code < ecOK) then goto ErrorExit;

      Inc(ImgBytes, PH.ImgLength);
      Seek(FaxFile, FilePos(FaxFile) + PH.ImgLength);
    end;

    Close(FaxFile);
    upInitFileUnpack:= -IoResult;
    Exit;

  ErrorExit:
    Close(FaxFile);
    if (IoResult = 0) then;
    upInitFileUnpack:= Code;
  end;
end;

function upUnpackPage(Unpack: PUnpackFax; FName: string; Page: Cardinal): Integer;
{ -Unpack page number Page, calling the put line callback for each raster line }
var
  Code: Integer;

begin
  with Unpack^ do begin
    CurrPage:= Page;

    { do we need to scale the output? }
    if (Scale.HMult <> Scale.HDiv) or (Scale.VMult <> Scale.VDiv) then
        Code:= upUnpackPageToBuffer(Unpack, FName, Page, False)
    else begin
      Code:= upInitPageUnpack(Unpack, FName, Page);
      if (Code = ecOK) then Code:= upOutputLine(Unpack, upStarting);
      if (Code < ecOK) then begin
        upUnpackPage:= Code;
        Exit;
      end;

      Code:= upUnpackPagePrim(Unpack, FName, Page);
      if (Code < ecOK) then begin
        upUnpackPage:= Code;
        Exit;
      end;

      Code:= upOutputLine(Unpack, upEnding);
    end;

    { are we all done? }
    if (Code = ecOK) and ((Scale.HMult <> Scale.HDiv) or (Scale.VMult <> Scale.VDiv)) then
        upUnpackPage:= upOutputBuffer(Unpack)
    else upUnpackPage:= ecOK;
  end;
end;

function upUnpackFile(Unpack: PUnpackFax; FName: string): Integer;
{ -Unpack all pages in a fax file }
var
  I: Cardinal;
  Code: Integer;

begin
  with Unpack^ do begin
    { do we need to scale the output? }
    if (Scale.HMult <> Scale.HDiv) or (Scale.VMult <> Scale.VDiv) then
        Code:= upUnpackFileToBuffer(Unpack, FName)
    else begin
      Code:= upGetFaxHeader(Unpack, FName, FaxHeader);
      if (Code < ecOK) then begin
        upUnpackFile:= Code;
        Exit;
      end;

      Code:= upInitFileUnpack(Unpack, FName);
      if (Code = ecOK) then Code:= upOutputLine(Unpack, upStarting);
      if (Code < ecOK) then begin
        upUnpackFile:= Code;
        Exit;
      end;

      for I:= 1 to FaxHeader.PageCount do begin
        CurrPage:= I;
        Code:= upUnpackPagePrim(Unpack, FName, I);
        if (Code < ecOK) then begin
          upUnpackFile:= Code;
          Exit;
        end;
      end;

      Code:= upOutputLine(Unpack, upEnding);
    end;

    { are we all done? }
    if (Code = ecOK) and ((Scale.HMult <> Scale.HDiv) or (Scale.VMult <> Scale.VDiv)) then
        upUnpackFile:= upOutputBuffer(Unpack)
    else upUnpackFile:= ecOK;
  end;
end;

function upUnpackPageToBitmap(Unpack: PUnpackFax; FName: string; Page: Cardinal;
  var Bmp: TMemoryBitmapDesc; Invert: Bool): Integer;
{ -Unpack a page of fax into a memory bitmap }
var
  Code: Integer;

begin
  with Unpack^ do begin
    CurrPage:= Page;
    SaveHook:= OutputLine;
    OutputLine:= upPutMemoryBitmapLine;

    Code:= upInitPageUnpack(Unpack, FName, Page);
    if (Code = ecOK) then Code:= upOutputLine(Unpack, upStarting);
    if (Code < ecOK) then begin
      OutputLine:= SaveHook;
      upUnpackPageToBitmap:= Code;
      Exit;
    end;

    Inverted:= Invert;
    Code:= upUnpackPagePrim(Unpack, FName, Page);
    if (Code < ecOK) then begin
      OutputLine:= SaveHook;
      upUnpackPageToBitmap:= Code;
      Inverted:= False;
      Exit;
    end;
    Code:= upOutputLine(Unpack, upEnding);
    OutputLine:= SaveHook;
    Inverted:= False;

    if (Code < ecOK) then DeleteObject(MemBmp.Bitmap)
    else Bmp:= MemBmp;

    upUnpackPageToBitmap:= Code;
  end;
end;

function upUnpackFileToBitmap(Unpack: PUnpackFax; FName: string; var Bmp: TMemoryBitmapDesc;
  Invert: Bool): Integer;
{ -Unpack a fax into a memory bitmap }
var
  Code: Integer;
  I: Cardinal;

begin
  with Unpack^ do begin
    SaveHook:= OutputLine;
    OutputLine:= upPutMemoryBitmapLine;

    Code:= upGetFaxHeader(Unpack, FName, FaxHeader);
    if (Code < ecOK) then begin
      OutputLine:= SaveHook;
      upUnpackFileToBitmap:= Code;
      Exit;
    end;

    Code:= upInitFileUnpack(Unpack, FName);
    if (Code = ecOK) then Code:= upOutputLine(Unpack, upStarting);
    if (Code < ecOK) then begin
      OutputLine:= SaveHook;
      upUnpackFileToBitmap:= Code;
      Exit;
    end;

    Inverted:= Invert;
    for I:= 1 to FaxHeader.PageCount do begin
      CurrPage:= I;
      Code:= upUnpackPagePrim(Unpack, FName, I);
      if (Code < ecOK) then begin
        upUnpackFileToBitmap:= Code;
        Inverted:= False;
        Exit;
      end;
    end;
    Code:= upOutputLine(Unpack, upEnding);
    OutputLine:= SaveHook;
    Inverted:= False;

    if (Code < ecOK) then DeleteObject(MemBmp.Bitmap)
    else Bmp:= MemBmp;

    upUnpackFileToBitmap:= Code;
  end;
end;

function upPutMemoryBitmapLine(Unpack: PUnpackFax; plFlags: Word; var Data;
  Len, PageNum: Cardinal): Integer;
{ -Output a raster line to an in-memory bitmap }
var
  NewHandle: Cardinal;
  P: Pointer;
  offset: Integer;

  function InitOutputBitmap: Integer;
  begin
    with Unpack^ do begin
      Width:= 1;
      Height:= 0;

      { calculate the maximum width of each line }
      if ((PageHeader.ImgFlags and ffHighWidth) = ffHighWidth) then MaxWid:= WideWidth div 8
      else MaxWid:= WideWidth { StandardWidth } div 8; { ~~ }

      { allocate the memory handle for the first block of data }
      Handle:= GlobalAlloc(gmem_Moveable or gmem_ZeroInit, dword(MaxWid) * RasterBufferPageSize);
      if (Handle = 0) then begin
        InitOutputBitmap:= ecOutOfMemory;
        Exit;
      end;

      { get a pointer to the memory block }
      Lines:= GlobalLock(Handle);
      Pages:= 1;

      InitOutputBitmap:= ecOK;
    end;
  end;

  function OutputLineToBitmap: Integer;
  begin
    with Unpack^ do begin
      { allocate more memory if we need it }
      if (Height <> 0) and ((Height mod RasterBufferPageSize) = 0) then begin
        GlobalUnlock(Handle);
        { some memory leak detectors will detect that this causes a 524,288 byte leak }
        { this isn't a leak, the memory was allocated earlier, then reallocated }
        { here, but the total allocated memory is freed in CreateDestBitmap }
        NewHandle:= GlobalRealloc(Handle, MaxWid * RasterBufferPageSize * dword(Succ(Pages)),
          gmem_ZeroInit);
        if (NewHandle = 0) then begin
          OutputLineToBitmap:= ecOutOfMemory;
          GlobalFree(Handle);
          Exit;
        end;

        Lines:= GlobalLock(NewHandle);
        Handle:= NewHandle;
        Inc(Pages);
      end;

      OutputLineToBitmap:= ecOK;

      offset:= Integer(Height) * Integer(MaxWid);
      if (Len > 0) then begin
        P:= GetPtr(Lines, offset);
        Move(Data, P^, Len);
      end else begin
        { fill whitespace buffer }
        if Inverted then FillChar(TmpBuffer^, MaxWid, $FF)
        else FillChar(TmpBuffer^, MaxWid, $00);

        P:= GetPtr(Lines, offset);
        Move(TmpBuffer^, P^, MaxWid);
      end;
      Inc(Height);

      if Inverted then Width:= MaxCardinal(Width, ActualLenInverted(Data, Len))
      else Width:= MaxCardinal(Width, ActualLen(Data, Len));

      { corrupt lines caused by line noise can result in line width wider than MaxWid, causing crash later }
      if (Width > MaxWid) then Width:= MaxWid;
    end;
  end;

  function PackImage: Integer;
  { -Calculate the optimum number of bytes per line and arrange
    the raster lines on that boundary }
  var
    I: Integer;
    W: Cardinal;
    Pad: Bool;
    Src: PByteArray;
    Dest: PByteArray;
    NewHandle: THandle;

  begin
    PackImage:= ecOK;

    with Unpack^ do begin
      W:= Width;
      Pad:= Odd(Width);
      if Pad then Inc(W);

      if (Width <> 0) and (Height <> 0) then begin
        for I:= 1 to Pred(Height) do begin
          Src:= GetPtr(Lines, dword(I) * MaxWid);
          Dest:= GetPtr(Lines, dword(I) * W);

          Move(Src^, Dest^, Width);
          if Pad then
            if Inverted then Dest^[Width]:= $FF
            else Dest^[Width]:= $00;
        end;
        Width:= W;

        GlobalUnlock(Handle);
        NewHandle:= GlobalRealloc(Handle, Integer(Width) * Integer(Height), gmem_ZeroInit);
        if (NewHandle = 0) then begin
          GlobalFree(Handle);
          PackImage:= ecOutOfMemory;
          Exit;
        end;

        Handle:= NewHandle;
        Lines:= GlobalLock(Handle);
      end else begin
        GlobalUnlock(Handle);
        Handle:= 0;
        Lines:= nil;
      end;
    end;
  end;

  function CreateDestBitmap: Integer;
  { -Create a bitmap from the buffer }
  begin
    { create bitmap data structure }
    with Unpack^ do begin
      MemBmp.Width:= Width * 8;
      MemBmp.Height:= Height;

      { create the bitmap }
      if (Lines <> nil) then begin
        MemBmp.Bitmap:= CreateBitmap(MemBmp.Width, MemBmp.Height, 1, 1, Lines);
        if (MemBmp.Bitmap = 0) then CreateDestBitmap:= ecCantMakeBitmap
        else CreateDestBitmap:= ecOK;

        GlobalUnlock(Handle);
        GlobalFree(Handle);
      end else begin
        MemBmp.Bitmap:= 0;
        MemBmp.Width:= 0;
        MemBmp.Height:= 0;
        CreateDestBitmap:= ecOK;
      end;
    end;
  end;

  function ScaleBitmap: Integer;
  { -Scale the bitmap based on user-specified dimensions }
  var
    ScaledWidth: Cardinal;
    ScaledHeight: Cardinal;
    W: Cardinal;
    Temp: HBitmap;
    OldSrc: HBitmap;
    OldDest: HBitmap;
    TempDC: HDC;
    SrcDC: HDC;
    DestDC: HDC;

  begin
    with Unpack^ do begin
      if (MemBmp.Width = 0) or (MemBmp.Height = 0) then begin
        ScaleBitmap:= ecOK;
        Exit;
      end;

      ScaleBitmap:= ecCantMakeBitmap;

      { calculate the scaled dimensions of the bitmap }
      W:= Width * 8;
      ScaledWidth:= (W * Scale.HMult) div Scale.HDiv;
      ScaledHeight:= (Height * Scale.VMult) div Scale.VDiv;

      { create destination bitmap }
      Temp:= CreateBitmap(ScaledWidth, ScaledHeight, 1, 1, nil);
      if (Temp = 0) then Exit;

      { create a source DC and a dest DC for StretchBlting data into dest }
      TempDC:= GetDC(0);
      if (TempDC = 0) then begin
        DeleteObject(Temp);
        Exit;
      end;
      SrcDC:= CreateCompatibleDC(TempDC);
      ReleaseDC(0, TempDC);
      if (SrcDC = 0) then begin
        DeleteObject(Temp);
        Exit;
      end;
      DestDC:= CreateCompatibleDC(SrcDC);
      if (DestDC = 0) then begin
        DeleteDC(SrcDC);
        DeleteObject(Temp);
        Exit;
      end;

      { select bitmaps into DCs }
      OldSrc:= SelectObject(SrcDC, MemBmp.Bitmap);
      OldDest:= SelectObject(DestDC, Temp);

      { scale image }
      StretchBlt(DestDC, 0, 0, ScaledWidth, ScaledHeight, SrcDC, 0, 0, W, Height, SrcCopy);

      { restore DCs }
      SelectObject(SrcDC, OldSrc);
      SelectObject(DestDC, OldDest);

      { cleanup }
      DeleteDC(SrcDC);
      DeleteDC(DestDC);
      DeleteObject(MemBmp.Bitmap);

      { set destination information }
      Width:= ScaledWidth div 8;
      Height:= ScaledHeight;
      MemBmp.Bitmap:= Temp;
      MemBmp.Width:= ScaledWidth;
      MemBmp.Height:= ScaledHeight;
    end;

    ScaleBitmap:= ecOK;
  end;

  function FinishBitmap: Integer;
  var
    Code: Integer;
    CopyBytes: Integer;

  begin
    with Unpack^ do begin
      { pack the bitmap }
      Code:= PackImage;
      if (Code < ecOK) then begin
        FinishBitmap:= Code;
        Exit;
      end;

      FinishBitmap:= ecOK;

      if ToBuffer then begin
        { if we're scaling this data, create memory bitmap }
        if (Scale.HMult <> Scale.HDiv) or (Scale.VMult <> Scale.VDiv) then begin
          Code:= CreateDestBitmap;
          if (Code < ecOK) then begin
            FinishBitmap:= Code;
            Exit;
          end;

          { scale the bitmap }
          Code:= ScaleBitmap;
          if (Code < ecOK) then begin
            DeleteObject(MemBmp.Bitmap);
            FinishBitmap:= Code;
            Exit;
          end;

          { put the data back into a buffer }
          if Odd(Width) then Inc(Width);
          CopyBytes:= dword(Height) * Width;
          Handle:= GlobalAlloc(gmem_Moveable or gmem_ZeroInit, CopyBytes);
          if (Handle = 0) then begin
            FinishBitmap:= ecOutOfMemory;
            Exit;
          end;
          Lines:= GlobalLock(Handle);

          GetBitmapBits(MemBmp.Bitmap, CopyBytes, Lines);
          DeleteObject(MemBmp.Bitmap);
        end;
      end else begin
        Code:= CreateDestBitmap;
        { if error, or no scaling, just exit }
        if (Code < ecOK) or (Scale.HMult = Scale.HDiv) and (Scale.VMult = Scale.VDiv) then begin
          FinishBitmap:= Code;
          Exit;
        end;

        { scale the bitmap }
        Code:= ScaleBitmap;
        if (Code < ecOK) then begin
          DeleteObject(MemBmp.Bitmap);
          FinishBitmap:= Code;
          Exit;
        end;
      end;
    end;
  end;

begin
  if FlagIsSet(plFlags, upStarting) then upPutMemoryBitmapLine:= InitOutputBitmap
  else if not FlagIsSet(plFlags, upEnding) then upPutMemoryBitmapLine:= OutputLineToBitmap
  else upPutMemoryBitmapLine:= FinishBitmap
end;

function upUnpackPageToBuffer(Unpack: PUnpackFax; FName: string; Page: Cardinal;
  UnpackingFile: Boolean): Integer;
{ -Unpack a page of fax into a memory bitmap }
var
  Code: Integer;

begin
  with Unpack^ do begin
    CurrPage:= Page;
    SaveHook:= OutputLine;
    OutputLine:= upPutMemoryBitmapLine;
    ToBuffer:= True;

    if not UnpackingFile then Code:= upInitPageUnpack(Unpack, FName, Page)
    else Code:= ecOK;
    if (Code = ecOK) then Code:= upOutputLine(Unpack, upStarting);
    if (Code < ecOK) then begin
      OutputLine:= SaveHook;
      upUnpackPageToBuffer:= Code;
      Exit;
    end;

    Code:= upUnpackPagePrim(Unpack, FName, Page);
    if (Code < ecOK) then begin
      OutputLine:= SaveHook;
      upUnpackPageToBuffer:= Code;
      Exit;
    end;

    Code:= upOutputLine(Unpack, upEnding);
    OutputLine:= SaveHook;
    upUnpackPageToBuffer:= Code;
  end;
end;

function upUnpackFileToBuffer(Unpack: PUnpackFax; FName: string): Integer;
{ -Unpack a fax into a memory bitmap }
var
  Code: Integer;
  I: Cardinal;

begin
  with Unpack^ do begin
    SaveHook:= OutputLine;
    OutputLine:= upPutMemoryBitmapLine;
    ToBuffer:= True;

    Code:= upGetFaxHeader(Unpack, FName, FaxHeader);
    if (Code < ecOK) then begin
      OutputLine:= SaveHook;
      upUnpackFileToBuffer:= Code;
      Exit;
    end;

    Code:= upInitFileUnpack(Unpack, FName);
    if (Code = ecOK) then Code:= upOutputLine(Unpack, upStarting);
    if (Code < ecOK) then begin
      OutputLine:= SaveHook;
      upUnpackFileToBuffer:= Code;
      Exit;
    end;

    for I:= 1 to FaxHeader.PageCount do begin
      CurrPage:= I;
      Code:= upUnpackPagePrim(Unpack, FName, I);
      if (Code < ecOK) then begin
        OutputLine:= SaveHook;
        upUnpackFileToBuffer:= Code;
        Exit;
      end;
    end;

    Code:= upOutputLine(Unpack, upEnding);
    OutputLine:= SaveHook;
    upUnpackFileToBuffer:= Code;
  end;
end;

procedure GetOutFileName(UserName: string; out OutName: string; InName, DefaultExt: string);
var
  Ext: string;

begin
  if (UserName = '') then ForceExtensionZ(OutName, InName, DefaultExt)
  else begin
    JustExtensionZ(Ext, UserName);
    if (Ext = '') then ForceExtensionZ(OutName, UserName, DefaultExt)
    else OutName:= UserName;
  end;
end;

{ Unpack to PCX routines }

type
  PPcxUnpackData = ^TPcxUnpackData;

  TPcxUnpackData = record
    PBOfs: Cardinal;
    PcxOfs: Integer;
    OutFile: PBufferedOutputFile;
    PackBuffer: array[0 .. 511] of Byte;
  end;

function OutputPcxImage(Unpack: PUnpackFax; var Data: TPcxUnpackData): Integer;
var
  Code: Integer;
  I: Cardinal;
  OutLine: PByteArray;

  function WritePcxHeader: Integer;
  var
    PH: TPcxHeaderRec;

  begin
    with Unpack^, Data do begin
      { construct PCX header }
      FastZero(PH, SizeOf(PH));
      with PH do begin
        Mfgr:= $0A;
        Ver:= $02;
        Encoding:= 1;
        BitsPixel:= 1;
        XMax:= Pred(Width * 8);
        YMax:= Pred(Height);
        Planes:= 1;
        BytesLine:= Width;
      end;

      { write PCX header }
      WritePcxHeader:= WriteOutFile(OutFile, PH, SizeOf(TPcxHeaderRec));
    end;
  end;

  procedure CompressLine(Unpack: PUnpackFax; Data: PPcxUnpackData; OutLine: PByteArray);
    assembler; register;
  {$IFNDEF CPUX64}
  asm
    push  edi
    push  esi
    push  ebx

    push  edx                                 { save Data for later }
    mov   esi,ecx                             { ecx = OutLine }
    mov   ecx,[eax].TUnpackFax.Width          { ECX = # of input bytes }
    mov   edi,edx                             { edx = Data }
    add   edi,OFFSET TPcxUnpackData.PackBuffer{ edi->Data.PackBuffer }
    mov   ebx,edi                             { save EBX to count output len }

    or    ecx,ecx                             { any data to pack? }
    jz    @7

    mov   al,[esi]                            { get first byte of input }
    inc   esi
    xor   edx,edx                             { run length of 1 }
    dec   ecx
    jz    @2                                  { jump if no data left }

    { count run loop }
  @1: cmp   dl,62                               { maximum run length reached? }
    je    @5                                  { jump if so }
    cmp   al,[esi]                            { still running? }
    jne   @2                                  { jump if not }
    inc   esi                                 { increment input pointer }
    inc   edx                                 { increment run counter }
    dec   ecx                                 { one more byte of input used }
    jz    @5                                  { output run if no more data }
    jmp   @1

    { output data }
  @2: or    edx,edx                             { run data to output? }
    jnz   @5                                  { jump if so }
    not   al
    mov   ah,al                               { save data byte }
    and   al,$C0                              { top two bits on? }
    cmp   al,$C0
    jne   @3                                  { if not, just output }
    mov   byte ptr [edi],$C1                  { output 1-byte run to }
    inc   edi                                 { avoid misinterp of data }
  @3: mov   [edi],ah                            { output data byte }
    inc   edi                                 { increment output pointer }
    or    ecx,ecx                             { any data left? }
    jz    @7                                  { jump if not }
    mov   al,[esi]                            { get next data byte }
    inc   esi                                 { increment input pointer }
    dec   ecx                                 { decrement input counter }
    jnz   @1                                  { jump if any data left }

    { output last literal data byte }
    not   al
    mov   ah,al                               { save data byte }
    and   al,$C0                              { top two bits on? }
    cmp   al,$C0
    jne   @4                                  { if not, just output }
    mov   byte ptr [edi],$C1                  { output 1-byte run to }
    inc   edi                                 { avoid misinterp of data }
  @4: mov   [edi],ah                            { output data byte }
    inc   edi                                  { increment output counter }
    jmp   @7

    { output run }
  @5: inc   edx                                 { increment for actual count }
    or    dl,$C0                              { mask on two MSBs }
    mov   [edi],dl                            { output run code }
    not   al                                  { invert bits of raster data }
    mov   [edi+1],al                          { output data byte }
    inc   edi                                 { increment output pointer }
    inc   edi                                 { increment output pointer }
    xor   edx,edx                             { zero run counter }
    or    ecx,ecx                             { any data left? }
    jz    @7                                  { jump if not }
    mov   al,[esi]                            { get next input byte }
    inc   esi
    dec   ecx                                 { decrement input counter }
    jnz   @1                                  { jump if no any data left }

    { output last literal data byte }
    not   al
    mov   ah,al                               { save data byte }
    and   al,$C0                              { top two bits on? }
    cmp   al,$C0
    jne   @6                                  { if not, just output }
    mov   byte [edi],$C1                      { output 1-byte run to }
    inc   edi                                 { avoid misinterp of data }
  @6: mov   [edi],ah                            { output data byte }
    inc   edi                                 { increment output counter }

  @7: pop   esi                                 { restore Data into ESI }
    sub   edi,ebx                             { EDI = length of output }
    mov   [esi].TPcxUnpackData.PBOfs,edi      { Set output length }

    pop   ebx
    pop   esi
    pop   edi
  end;
  {$ELSE}
    asm
      push  rdi
      push  rsi
      push  rbx
      mov   rax,rcx
      mov   rcx,r8

      push  rdx                                 { save Data for later }
      mov   rsi,rcx                             { ecx = OutLine }
      mov   ecx,[rax].TUnpackFax.Width          { ECX = # of input bytes }
      mov   rdi,rdx                             { edx = Data }
      add   rdi,OFFSET TPcxUnpackData.PackBuffer{ edi->Data.PackBuffer }
      mov   rbx,rdi                             { save EBX to count output len }

      or    ecx,ecx                             { any data to pack? }
      jz    @7

      mov   al,[rsi]                            { get first byte of input }
      inc   rsi
      xor   edx,edx                             { run length of 1 }
      dec   ecx
      jz    @2                                  { jump if no data left }

      { count run loop }
    @1: cmp   dl,62                               { maximum run length reached? }
      je    @5                                  { jump if so }
      cmp   al,[rsi]                            { still running? }
      jne   @2                                  { jump if not }
      inc   rsi                                 { increment input pointer }
      inc   edx                                 { increment run counter }
      dec   ecx                                 { one more byte of input used }
      jz    @5                                  { output run if no more data }
      jmp   @1

      { output data }
    @2: or    edx,edx                             { run data to output? }
      jnz   @5                                  { jump if so }
      not   al
      mov   ah,al                               { save data byte }
      and   al,$C0                              { top two bits on? }
      cmp   al,$C0
      jne   @3                                  { if not, just output }
      mov   byte ptr [rdi],$C1                  { output 1-byte run to }
      inc   rdi                                 { avoid misinterp of data }
    @3: mov   [rdi],ah                            { output data byte }
      inc   rdi                                 { increment output pointer }
      or    ecx,ecx                             { any data left? }
      jz    @7                                  { jump if not }
      mov   al,[rsi]                            { get next data byte }
      inc   rsi                                 { increment input pointer }
      dec   ecx                                 { decrement input counter }
      jnz   @1                                  { jump if any data left }

      { output last literal data byte }
      not   al
      mov   ah,al                               { save data byte }
      and   al,$C0                              { top two bits on? }
      cmp   al,$C0
      jne   @4                                  { if not, just output }
      mov   byte ptr [rdi],$C1                  { output 1-byte run to }
      inc   rdi                                 { avoid misinterp of data }
    @4: mov   [rdi],ah                            { output data byte }
      inc   rdi                                  { increment output counter }
      jmp   @7

      { output run }
    @5: inc   edx                                 { increment for actual count }
      or    dl,$C0                              { mask on two MSBs }
      mov   [rdi],dl                            { output run code }
      not   al                                  { invert bits of raster data }
      mov   [rdi+1],al                          { output data byte }
      inc   rdi                                 { increment output pointer }
      inc   rdi                                 { increment output pointer }
      xor   edx,edx                             { zero run counter }
      or    ecx,ecx                             { any data left? }
      jz    @7                                  { jump if not }
      mov   al,[rsi]                            { get next input byte }
      inc   rsi
      dec   ecx                                 { decrement input counter }
      jnz   @1                                  { jump if no any data left }

      { output last literal data byte }
      not   al
      mov   ah,al                               { save data byte }
      and   al,$C0                              { top two bits on? }
      cmp   al,$C0
      jne   @6                                  { if not, just output }
      mov   byte [rdi],$C1                      { output 1-byte run to }
      inc   rdi                                 { avoid misinterp of data }
    @6: mov   [rdi],ah                            { output data byte }
      inc   rdi                                 { increment output counter }

    @7: pop   rsi                                 { restore Data into ESI }
      sub   rdi,rbx                             { EDI = length of output }
      mov   [rsi].TPcxUnpackData.PBOfs,edi      { Set output length }

      pop   rbx
      pop   rsi
      pop   rdi
    end;
    {$ENDIF}
  begin

    with Unpack^, Data do begin
      { write file header }
      Code:= WritePcxHeader;
      if (Code < ecOK) then begin
        OutputPcxImage:= Code;
        Exit;
      end;

      if Width > 0 then begin
        { get memory for output line }
        OutLine:= AllocMem(Width);

        { go through each line and write it }
        for i:= 0 to Pred(Height) do begin
          Move(GetPtr(Lines, Width * i)^, OutLine^, Width);
          CompressLine(Unpack, @Data, OutLine);
          Code:= WriteOutFile(OutFile, PackBuffer, PBOfs);
          if (Code < ecOK) then begin
            OutputPcxImage:= Code;
            Exit;
          end;
        end;

        FreeMem(OutLine, Width);
      end;
      OutputPcxImage:= ecOK;
    end;
  end;

function OutputToPcx(Unpack: PUnpackFax; InName, OutName: string): Integer;
var
  Data: TPcxUnpackData;
  Code: Integer;
  OutFileName: string;

begin
  FastZero(Data, SizeOf(TPcxUnpackData));

  with Unpack^, Data do begin
    GetOutFileName(OutName, OutFileName, InName, DefPcxExt);
    Code:= InitOutFile(OutFile, OutFileName);
    if (Code < ecOK) then begin
      GlobalUnlock(Handle);
      GlobalFree(Handle);
      OutputToPcx:= Code;
      Exit;
    end;

    Code:= OutputPcxImage(Unpack, Data);
    GlobalUnlock(Handle);
    GlobalFree(Handle);
    if (Code < ecOK) then begin
      OutputToPcx:= Code;
      Exit;
    end;

    OutputToPcx:= CloseOutFile(OutFile);
  end;
end;

function upUnpackPageToPcx(Unpack: PUnpackFax; FName, OutName: string; Page: Cardinal): Integer;
{ -Unpack one page of an APF file to a PCX file }
var
  Code: Integer;

begin
  Code:= upUnpackPageToBuffer(Unpack, FName, Page, False);
  if (Code = ecOK) then Code:= OutputToPcx(Unpack, FName, OutName);
  upUnpackPageToPcx:= Code;
end;

function upUnpackFileToPcx(Unpack: PUnpackFax; FName, OutName: string): Integer;
{ -Unpack an APF file to a PCX file }
var
  Code: Integer;

begin
  Code:= upUnpackFileToBuffer(Unpack, FName);
  if (Code = ecOK) then Code:= OutputToPcx(Unpack, FName, OutName);
  upUnpackFileToPcx:= Code;
end;

type
  PDcxUnpackData = ^TDcxUnpackData;

  TDcxUnpackData = record
    PCXData: TPcxUnpackData;
    NumPages: Integer;
    DcxHeader: TDcxHeaderRec;
  end;

function CreateDCXFile(const Unpack: PUnpackFax; InName, OutName: string;
  var Data: PDcxUnpackData): Integer;
var
  OutFileName: string;
  Code: Integer;

begin
  CreateDCXFile:= ecOK;

  { allocate memory for converter data }
  Data:= AllocMem(SizeOf(TDcxUnpackData));

  with Data^, PCXData do begin
    GetOutFileName(OutName, OutFileName, InName, DefDcxExt);

    { create the output file }
    Code:= InitOutFile(OutFile, OutFileName);
    if (Code < ecOK) then begin
      FreeMem(Data, SizeOf(TDcxUnpackData));
      CreateDCXFile:= Code;
      Exit;
    end;

    { write the header to the output file }
    DcxHeader.ID:= 987654321;
    Code:= WriteOutFile(OutFile, DcxHeader, SizeOf(TDcxHeaderRec));

    { check for errors }
    if (Code < ecOK) then begin
      FreeMem(Data, SizeOf(TDcxUnpackData));
      CreateDCXFile:= Code;
      Exit;
    end;
  end;
end;

function OutputPageToDcx(Unpack: PUnpackFax; var Data: PDcxUnpackData): Integer;
var
  Code: Integer;

begin
  OutputPageToDcx:= ecOK;

  with Unpack^, Data^, PCXData do begin
    { update DCX header }
    Inc(NumPages);
    DcxHeader.Offsets[NumPages]:= OutFilePosn(OutFile);

    Code:= OutputPcxImage(Unpack, PCXData);
    GlobalUnlock(Handle);
    GlobalFree(Handle);
    if (Code < ecOK) then begin
      OutputPageToDcx:= Code;
      FreeMem(Data, SizeOf(TDcxUnpackData));
      Exit;
    end;
  end;
end;

function CloseDcxFile(Unpack: PUnpackFax; var Data: PDcxUnpackData): Integer;
var
  Code: Integer;

begin
  with Unpack^, Data^, PCXData do begin
    { write updated header back to file }
    Code:= SeekOutFile(OutFile, 0);
    if (Code = ecOK) then Code:= WriteOutFile(OutFile, DcxHeader, SizeOf(TDcxHeaderRec));
    if (Code = ecOK) then Code:= CloseOutFile(OutFile);

    FreeMem(Data, SizeOf(TDcxUnpackData));
    CloseDcxFile:= Code;
  end;
end;

function upUnpackPageToDcx(Unpack: PUnpackFax; FName, OutName: string; Page: Cardinal): Integer;
{ -Unpack one page of an APF file to a DCX file }
var
  Code: Integer;
  Data: PDcxUnpackData;

begin
  Code:= upUnpackPageToBuffer(Unpack, FName, Page, False);
  if (Code = ecOK) then begin
    Code:= CreateDCXFile(Unpack, FName, OutName, Data);
    if (Code = ecOK) then begin
      Code:= OutputPageToDcx(Unpack, Data);
      if (Code = ecOK) then Code:= CloseDcxFile(Unpack, Data);
    end;
  end;
  upUnpackPageToDcx:= Code;
end;

function upUnpackFileToDcx(Unpack: PUnpackFax; FName, OutName: string): Integer;
{ -Unpack an APF file to a DCX file }
var
  I: Cardinal;
  Data: PDcxUnpackData;

begin
  Result := ecOK;
  with Unpack^ do
  begin
    try { !!.04 }
      { read the fax file header }
      Result := upGetFaxHeader(Unpack, FName, FaxHeader);
      if Result < ecOK then
        Exit;

      { create the output file }
      Result := CreateDCXFile(Unpack, FName, OutName, Data);
      if Result < ecOK then
        Exit;

      Result:= upInitFileUnpack(Unpack, FName);
      if Result < ecOK then
      begin
        FreeMem(Data, SizeOf(TDcxUnpackData));
        Exit;
      end;

      { output each page as a PCX image }
      for I:= 1 to FaxHeader.PageCount do
      begin
        Result := upUnpackPageToBuffer(Unpack, FName, I, True);
        if Result = ecOK then
          Result := OutputPageToDcx(Unpack, Data);

        if Result < ecOK then
        begin
          FreeMem(Data, SizeOf(TDcxUnpackData));
          Exit;
        end;
      end;

    finally { !!.04 }
      { close the output file }
      if Result = ecOK then { !!.04 }
        Result := CloseDcxFile(Unpack, Data) { !!.04 }
      else { !!.04 }
        { an error occured, preserve the return value }
          CloseDcxFile(Unpack, Data); { !!.04 }
    end; { !!.04 }
  end;
end;

{ Unpack to TIFF routines }

procedure TiffEncode(var InBuf; InLen: Cardinal; var OutBuf; var OutLen: Cardinal);
  assembler; register;
{$IFNDEF CPUX64}
asm
  push  edi
  push  esi
  push  ebx

  mov   esi,eax                 { eax = InBuf = esi = current input offset }
  mov   eax,edx                 { edx = InLen }
  or    eax,eax                 { input length zero? }
  jnz   @I1                     { jump if not }
  xor   edi,edi                 { return zero output length }
  jmp   @A

@I1:mov   edi,ecx                 { ecx = OutBuf }
  mov   edx,edi                 { edx = saved starting output offset }
  mov   ebx,edi                 { ebx = control byte offset }
  mov   byte ptr [edi],0        { reset inital control byte }

  cmp   eax,1                   { is input length 1? }
  ja    @I2                     { jump if not }

  mov   al,[esi]                { get first input byte }
  mov   [ebx+1],al              { store it past control byte }
  mov   edi,2                   { output length is two }
  jmp   @A                      { exit }

@I2:mov   ecx,esi
  add   ecx,eax                 { ecx = offset just beyond end of input }

  mov   ax,[esi]                { does data start with a run? }
  cmp   ah,al
  je    @I3                     { jump if so }

  mov   [edi+1],al              { store first input byte }
  inc   edi
  inc   edi                     { prepare to store next input byte }
  inc   esi                     { we've used first input byte }

@I3:dec   esi                     { first time in, adjust for next inc esi }

@1: inc   esi                     { next input byte }
  cmp   esi,ecx
  jae   @9                      { jump out if done }

  mov   ax,[esi]                { get next two bytes }
  cmp   ah,al                   { the same? }
  jne   @5                      { jump if not a run }
  mov   ebx,edi                 { save OutPos offset }
  mov   byte ptr [edi],0        { reset control byte }
  mov   [edi+1],al              { store run byte }

@2: inc   esi                     { next input byte }
  cmp   esi,ecx                 { end of input? }
  jae   @3                      { jump if so }
  cmp   [esi],al                { still a run? }
  jne   @3                      { jump if not }
  cmp   byte ptr [ebx],$81      { max run length? }
  je    @3                      { jump if so }
  dec   byte ptr [ebx]          { decrement control byte }
  jmp   @2                      { loop }

@3: dec   esi                     { back up one input character }
  inc   edi                     { step past control and run bytes }
  inc   edi
  jmp   @1                      { loop }

@5: cmp   byte ptr [ebx],$7F      { run already in progress? }
  jb    @6                      { jump if not }
  mov   ebx,edi                 { start a new control sequence }
  mov   byte ptr [edi],0        { reset control byte }
  inc   edi                     { next output position }
  jmp   @7
@6: inc   byte ptr [ebx]          { increase non-run length }
@7: mov   [edi],al                { copy input byte to output }
  inc   edi
  jmp   @1

@9: sub   edi,edx
@A: mov   esi,OutLen
  mov   [esi],edi

  pop   ebx
  pop   esi
  pop   edi
end;
{$ELSE}
asm
  push  rdi
  push  rsi
  push  rbx
  mov   rcx,r8

  mov   rsi,rcx                 { eax = InBuf = esi = current input offset }
  mov   eax,edx                 { edx = InLen }
  or    eax,eax                 { input length zero? }
  jnz   @I1                     { jump if not }
  xor   rdi,rdi                 { return zero output length }
  jmp   @A

@I1:mov   rdi,rcx                 { ecx = OutBuf }
  mov   rdx,rdi                 { edx = saved starting output offset }
  mov   rbx,rdi                 { ebx = control byte offset }
  mov   byte ptr [rdi],0        { reset inital control byte }

  cmp   eax,1                   { is input length 1? }
  ja    @I2                     { jump if not }

  mov   al,[rsi]                { get first input byte }
  mov   [rbx+1],al              { store it past control byte }
  mov   rdi,2                   { output length is two }
  jmp   @A                      { exit }

@I2:mov   rcx,rsi
  add   rcx,rax                 { ecx = offset just beyond end of input }

  mov   ax,[rsi]                { does data start with a run? }
  cmp   ah,al
  je    @I3                     { jump if so }

  mov   [rdi+1],al              { store first input byte }
  inc   rdi
  inc   rdi                     { prepare to store next input byte }
  inc   rsi                     { we've used first input byte }

@I3:dec   rsi                     { first time in, adjust for next inc esi }

@1: inc   rsi                     { next input byte }
  cmp   rsi,rcx
  jae   @9                      { jump out if done }

  mov   ax,[rsi]                { get next two bytes }
  cmp   ah,al                   { the same? }
  jne   @5                      { jump if not a run }
  mov   rbx,rdi                 { save OutPos offset }
  mov   byte ptr [rdi],0        { reset control byte }
  mov   [rdi+1],al              { store run byte }

@2: inc   rsi                     { next input byte }
  cmp   rsi,rcx                 { end of input? }
  jae   @3                      { jump if so }
  cmp   [rsi],al                { still a run? }
  jne   @3                      { jump if not }
  cmp   byte ptr [rbx],$81      { max run length? }
  je    @3                      { jump if so }
  dec   byte ptr [rbx]          { decrement control byte }
  jmp   @2                      { loop }

@3: dec   rsi                     { back up one input character }
  inc   rdi                     { step past control and run bytes }
  inc   rdi
  jmp   @1                      { loop }

@5: cmp   byte ptr [rbx],$7F      { run already in progress? }
  jb    @6                      { jump if not }
  mov   rbx,rdi                 { start a new control sequence }
  mov   byte ptr [rdi],0        { reset control byte }
  inc   rdi                     { next output position }
  jmp   @7
@6: inc   byte ptr [rbx]          { increase non-run length }
@7: mov   [rdi],al                { copy input byte to output }
  inc   rdi
  jmp   @1

@9: sub   rdi,rdx
@A: mov   rsi,OutLen
  mov   [rsi],rdi

  pop   rbx
  pop   rsi
  pop   rdi
end;
{$ENDIF}

function OutputToTiff(Unpack: PUnpackFax; InName, OutName: string): Integer;
type
  TTiffHeader = packed record
    ByteOrder: array[1 .. 2] of Ansichar;
    Version: Word;
    ImgDirStart: Integer;
    NumTags: Word;
    SubFileTag: Word;
    SubFileTagType: Word;
    SubFileData: array[1 .. 4] of Word;
    ImageWidthTag: Word;
    ImageWidthTagType: Word;
    ImageWidthData: array[1 .. 4] of Word;
    ImageLengthTag: Word;
    ImageLengthTagType: Word;
    ImageLengthData: array[1 .. 4] of Word;
    BitsPerSampleTag: Word;
    BitsPerSampleTagType: Word;
    BitsPerSampleData: array[1 .. 4] of Word;
    CompressionTag: Word;
    CompressionTagType: Word;
    CompressionData: array[1 .. 4] of Word;
    PhotoMetricInterpTag: Word;
    PhotoMetricInterpTagType: Word;
    PhotoMetricInterpData: array[1 .. 4] of Word;
    StripOffsetsTag: Word;
    StripOffsetsTagType: Word;
    StripOffsetsData: array[1 .. 2] of Integer;
    RowsPerStripTag: Word;
    RowsPerStripTagType: Word;
    RowsPerStripData: array[1 .. 2] of Integer;
    StripByteCountsTag: Word;
    StripByteCountsTagType: Word;
    StripByteCountsData: array[1 .. 2] of Integer;
    XResolutionTag: Word; // SWB
    XResolutionTagType: Word; // SWB
    XResolutionCount: Integer; // SWB
    XResolutionOffset: Integer; // SWB
    YResolutionTag: Word; // SWB
    YResolutionTagType: Word; // SWB
    YResolutionCount: Integer; // SWB
    YResolutionOffset: Integer; // SWB

    ResolutionUnitTag: Word; // SWB
    ResolutionUnitTagType: Word; // SWB
    ResolutionUnitData: array [1 .. 4] of Word; // SWB

    XResolutionData: array [1 .. 2] of Integer; // SWB
    YResolutionData: array [1 .. 2] of Integer; // SWB
    OffsetOfNextDirectory: Integer;
  end;

const
  { TIFF tag values }
  SubfileType = 255;
  ImageWidth = 256;
  ImageLength = 257;
  BitsPerSample = 258;
  Compression = 259;
  PhotometricInterp = 262;
  StripOffsets = 273;
  RowsPerStrip = 278;
  StripByteCounts = 279;
  XResolution = 282; // SWB
  YResolution = 283; // SWB
  ResolutionUnit = 296; // SWB

  { TIFF tag integer types }
  tiffByte = 1;
  tiffASCII = 2;
  tiffShort = 3;
  tiffLong = 4;
  tiffRational = 5;

  TiffHeader: TTiffHeader = (ByteOrder: ('I', 'I'); // Little-endian
    Version: 42; // Arbitrary number that identifies file as TIFF (not "Version")
    ImgDirStart: 8; // Offset to first Image File Directory
    NumTags: 12; // IFD start: number of tags in this IFD SWB
    SubFileTag: SubfileType; // Type of image data in this file
    SubFileTagType: tiffShort; SubFileData: ($0001, $0000, $0001, $0000);
    // 1: Full resolution image data
    ImageWidthTag: ImageWidth; ImageWidthTagType: tiffShort;
    ImageWidthData: ($0001, $0000, $0000, $0000); ImageLengthTag: ImageLength;
    ImageLengthTagType: tiffShort; ImageLengthData: ($0001, $0000, $0000, $0000);
    BitsPerSampleTag: BitsPerSample; BitsPerSampleTagType: tiffShort;
    BitsPerSampleData: ($0001, $0000, $0001, $0000); CompressionTag: Compression;
    CompressionTagType: tiffShort; CompressionData: ($0001, $0000, compMPNT, $0000);
    PhotoMetricInterpTag: PhotometricInterp; PhotoMetricInterpTagType: tiffShort;
    PhotoMetricInterpData: ($0001, $0000, $0000, $0000); StripOffsetsTag: StripOffsets;
    StripOffsetsTagType: tiffLong; StripOffsetsData: ($00000001, SizeOf(TTiffHeader));
    RowsPerStripTag: RowsPerStrip; RowsPerStripTagType: tiffLong;
    RowsPerStripData: ($00000001, $00000000); StripByteCountsTag: StripByteCounts;
    StripByteCountsTagType: tiffLong; StripByteCountsData: ($00000001, $00000000);
    XResolutionTag: XResolution; // SWB
    XResolutionTagType: tiffRational; // SWB
    XResolutionCount: 1; // SWB
    YResolutionTag: YResolution; // SWB
    YResolutionTagType: tiffRational; // SWB
    YResolutionCount: 1; // SWB
    ResolutionUnitTag: ResolutionUnit; // SWB
    ResolutionUnitTagType: tiffShort; // SWB
    ResolutionUnitData: (1, 0, 2, 0); { inches }                  // SWB
    XResolutionData: (200, 1); // SWB
    YResolutionData: (200, 1); // SWB
    OffsetOfNextDirectory: 0; // SWB
  ); // Only one directory in file

var
  Code: Integer;
  OnLine: Cardinal;
  OutFile: PBufferedOutputFile;
  OutLine: Pointer;
  CompBuf: Pointer;
  CompLen: Cardinal;
  Bytes: Integer;
  OutFileName: string; // array[0..255] of AnsiChar;

  procedure Cleanup;
  begin
    with Unpack^ do begin
      GlobalUnlock(Handle);
      GlobalFree(Handle);
      FreeMem(OutLine, Width);
    end;
  end;

begin
  GetOutFileName(OutName, OutFileName, InName, DefTiffExt);

  with Unpack^ do begin
    { allocate memory for line buffer }
    OutLine:= AllocMem(Width);
    CompBuf:= AllocMem(Width * 2);

    { create output file }
    Code:= InitOutFile(OutFile, OutFileName);
    if (Code < ecOK) then begin
      Cleanup;
      OutputToTiff:= Code;
      Exit;
    end;

    { fix up the tiff header }
    with TiffHeader do begin
      ImageWidthData[3]:= Width * 8;
      ImageLengthData[3]:= Height;
      RowsPerStripData[2]:= Height;
      XResolutionOffset:= PAnsiChar(@XResolutionData) - // SWB
        PAnsiChar(@TiffHeader); // SWB
      YResolutionOffset:= PAnsiChar(@YResolutionData) - // SWB
        PAnsiChar(@TiffHeader); // SWB
    end;

    { output byte-order and version header }
    Code:= WriteOutFile(OutFile, TiffHeader, SizeOf(TTiffHeader));
    if (Code < ecOK) then begin
      Cleanup;
      OutputToTiff:= Code;
      Exit;
    end;

    { output each line of the buffer to the BMP file }
    FastZero(OutLine^, Width);
    FastZero(CompBuf^, Width * 2);
    Bytes:= 0;
    for OnLine:= 0 to Pred(Height) do begin
      Move(GetPtr(Lines, Integer(Width) * Integer(OnLine))^, OutLine^, Width);
      TiffEncode(OutLine^, Width, CompBuf^, CompLen);
      Inc(Bytes, CompLen);
      Code:= WriteOutFile(OutFile, CompBuf^, CompLen);
      if (Code < ecOK) then begin
        Cleanup;
        OutputToTiff:= Code;
        Exit;
      end;
    end;

    FreeMem(CompBuf, Width * 2);
    FreeMem(OutLine, Width);
    GlobalUnlock(Handle);
    GlobalFree(Handle);

    { redo the header }
    TiffHeader.StripByteCountsData[2]:= Bytes;
    Code:= SeekOutFile(OutFile, 0);
    if (Code = ecOK) then Code:= WriteOutFile(OutFile, TiffHeader, SizeOf(TTiffHeader));
    if (Code = ecOK) then Code:= CloseOutFile(OutFile);

    OutputToTiff:= Code;
  end;
end;

function upUnpackPageToTiff(Unpack: PUnpackFax; FName, OutName: string; Page: Cardinal): Integer;
{ -Unpack one page of an APF file to a TIF file }
var
  Code: Integer;

begin
  Code:= upUnpackPageToBuffer(Unpack, FName, Page, False);
  if (Code = ecOK) then Code:= OutputToTiff(Unpack, FName, OutName);
  upUnpackPageToTiff:= Code;
end;

function upUnpackFileToTiff(Unpack: PUnpackFax; FName, OutName: string): Integer;
{ -Unpack an APF file to a TIF file }
var
  Code: Integer;

begin
  Code:= upUnpackFileToBuffer(Unpack, FName);
  if (Code = ecOK) then Code:= OutputToTiff(Unpack, FName, OutName);
  upUnpackFileToTiff:= Code;
end;

{ Unpack to BMP routines }

function OutputToBitmap(Unpack: PUnpackFax; InName, OutName: string): Integer;
const
  BmpPalette: array[1 .. 8] of Byte = ($00, $00, $00, $00, $FF, $FF, $FF, $00);

var
  Code: Integer;
  OnLine: Cardinal;
  LineBytes: Cardinal;
  OutFile: PBufferedOutputFile;
  FileHeader: TBitmapFileHeader;
  InfoHeader: TBitmapInfoHeader;
  OutLine: Pointer;
  OutFileName: string; // array[0..255] of AnsiChar;

  procedure Cleanup;
  begin
    with Unpack^ do begin
      FreeMem(OutLine, LineBytes);
      GlobalUnlock(Handle);
      GlobalFree(Handle);
    end;
  end;

begin
  GetOutFileName(OutName, OutFileName, InName, DefBmpExt);

  with Unpack^ do begin

    if Height > 32767 then begin
      OutputToBitmap:= ecBmpTooBig;
      Exit;
    end;

    LineBytes:= (Width + 3) and $FFFC;

    { get memory for output line }
    OutLine:= AllocMem(LineBytes);

    { build the headers for the bitmap }
    FastZero(FileHeader, SizeOf(TBitmapFileHeader));
    with FileHeader do begin
      bfType:= $4D42;
      bfOffBits:= SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfoHeader) + SizeOf(BmpPalette);
      bfSize:= (dword(LineBytes) * Height) + bfOffBits;
    end;
    FastZero(InfoHeader, SizeOf(TBitmapInfoHeader));
    with InfoHeader do begin
      biSize:= SizeOf(TBitmapInfoHeader);
      biWidth:= Integer(Width) * 8;
      biHeight:= Height;
      biPlanes:= 1;
      biBitCount:= 1;
    end;

    { create the output file and write the headers }
    Code:= InitOutFile(OutFile, OutName);
    if (Code < ecOK) then begin
      Cleanup;
      OutputToBitmap:= Code;
      Exit;
    end;

    Code:= WriteOutFile(OutFile, FileHeader, SizeOf(TBitmapFileHeader));
    if (Code = ecOK) then begin
      Code:= WriteOutFile(OutFile, InfoHeader, SizeOf(TBitmapInfoHeader));
      if (Code = ecOK) then Code:= WriteOutFile(OutFile, BmpPalette, SizeOf(BmpPalette));
    end;
    if (Code < ecOK) then begin
      Cleanup;
      OutputToBitmap:= Code;
      Exit;
    end;

    { output each line of the buffer to the BMP file }
    FastZero(OutLine^, LineBytes);
    NotBuffer(OutLine^, LineBytes);
    for OnLine:= Pred(Height) downto 0 do begin
      Move(GetPtr(Lines, Integer(Width) * Integer(OnLine))^, OutLine^, Width);
      NotBuffer(OutLine^, Width);
      Code:= WriteOutFile(OutFile, OutLine^, LineBytes);
      if (Code < ecOK) then begin
        Cleanup;
        OutputToBitmap:= Code;
        Exit;
      end;
    end;

    OutputToBitmap:= CloseOutFile(OutFile);

    { free memory }
    GlobalUnlock(Handle);
    GlobalFree(Handle);
    FreeMem(OutLine, LineBytes);
  end;
end;

function upUnpackPageToBmp(Unpack: PUnpackFax; FName, OutName: string; Page: Cardinal): Integer;
{ -Unpack one page of an APF file to a BMP file }
var
  Code: Integer;

begin
  Code:= upUnpackPageToBuffer(Unpack, FName, Page, False);
  if (Code = ecOK) then Code:= OutputToBitmap(Unpack, FName, OutName);
  upUnpackPageToBmp:= Code;
end;

function upUnpackFileToBmp(Unpack: PUnpackFax; FName, OutName: string): Integer;
{ -Unpack an APF file to a BMP file }
var
  Code: Integer;

begin
  Code:= upUnpackFileToBuffer(Unpack, FName);
  if (Code = ecOK) then Code:= OutputToBitmap(Unpack, FName, OutName);
  upUnpackFileToBmp:= Code;
end;

{$ENDIF}{ (IFNDEF PRNDRV) }
{ Initialization routines }

procedure RotateCodeGroup(var TC: TTermCodeArray; var MUC: TMakeUpCodeArray);
{ -Flip bits in white or black groups }
var
  I: Integer;
begin
  for I:= 0 to MaxCodeTable do
    with TC[I] do RotateCode(Code, Sig);
  for I:= 0 to MaxMUCodeTable do
    with MUC[I] do RotateCode(Code, Sig);
end;

procedure RotateCodes;
{ -Flip bits in all codes }
begin
  RotateCodeGroup(WhiteTable, WhiteMUTable);
  RotateCodeGroup(BlackTable, BlackMUTable);
  RotateCode(EOLRec.Code, EOLRec.Sig);
  RotateCode(LongEOLRec.Code, LongEOLRec.Sig);
end;


initialization
  RotateCodes;
end.
