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
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADFAXPRN.PAS 4.06                   *}
{*********************************************************}
{* TApdFaxPrinter component                              *}
{*********************************************************}

{
  Converts an APF file into bitmaps, then sends them to
  the printer.
  Has known problems with some video cards which render
  either black or blank pages. Updating video drivers or
  reducing hardware acceleration usually fixes it.
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdFaxPrn;
  { Apro Fax printer component}

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Dialogs,
  Printers,
  ooMisc,
  AdFaxCvt;

type
  { Fax Printer Log Codes }
  TFaxPLCode = (lcStart, lcFinish, lcAborted, lcFailed);

  { Fax Printer Property Types }
  TFaxPrintScale    = (psNone, psFitToPage);
  TFaxPrintProgress = (ppIdle, ppComposing, ppRendering, ppSubmitting, ppConverting);

  { Fax Printer Events }
  TFaxPrnNextPageEvent = procedure(Sender: TObject; CP, TP: Word) of object;
  TFaxPLEvent = procedure(Sender: TObject; FaxPLCode: TFaxPLCode) of object;
  TFaxPrintStatusEvent = procedure(Sender: TObject;
    StatusCode: TFaxPrintProgress) of object;
const
  { Fax Printer Log Defaults }
  afpDefFPLFileName      = 'FAXPRINT.LOG';

  { Fax Printer Margin Defaults }
  afpDefFaxHeaderCaption = 'FILE: $F';
  afpDefFaxHeaderEnabled = True;
  afpDefFaxFooterCaption = 'PAGE: $P of $N';
  afpDefFaxFooterEnabled = True;

  { Fax Printer Defaults }
  afpDefFaxPrnCaption    = 'APro Fax Printer';
  afpDefFaxPrintScale    = psFitToPage;
  afpDefFaxMultiPage     = False;

type
  TApdCustomFaxPrinter = class;

  TApdCustomFaxPrinterLog = class(TApdBaseComponent)
   protected
    { Protected declarations }
    FFaxPrinter    : TApdCustomFaxPrinter;
    FLogFileName   : String;
   public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure UpdateLog(const LogCode: TFaxPLCode);

    property FaxPrinter : TApdCustomFaxPrinter
      read FFaxPrinter;
    property LogFileName : String
      read FLogFileName write FLogFileName;
  end;

  TApdCustomFaxPrinterMargin = class(TPersistent)
   protected
    { Protected declarations }
    FCaption : String;
    FEnabled : Boolean;
    FFont    : TFont;
    FHeight  : Word;
   public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetFont(const NewFont: TFont);

    property Caption : string
      read FCaption write FCaption;
    property Enabled : Boolean
      read FEnabled write FEnabled;
    property Font : TFont
      read FFont write SetFont;
    property Height : Word
      read FHeight write FHeight default 0;
  end;

  TApdAbstractFaxPrinterStatus = class(TApdBaseComponent)
   protected {private}
    FDisplay : TForm;
    FPosition: TPosition;
    FCtl3D   : Boolean;
    FVisible : Boolean;
    FCaption : String;                                            
   protected
    FFaxPrinter : TApdCustomFaxPrinter;
    procedure SetPosition(const Value: TPosition);
    procedure SetCtl3D(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetCaption(const Value: String);                     
    procedure GetProperties;
    procedure Show;

   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateDisplay(First, Last: Boolean); virtual; abstract;
    procedure CreateDisplay; dynamic; abstract;
    procedure DestroyDisplay; dynamic; abstract;

    property Display: TForm
      read FDisplay write FDisplay;
    property FaxPrinter : TApdCustomFaxPrinter
      read FFaxPrinter;

   published
    property Position : TPosition
      read FPosition write SetPosition;
    property Ctl3D : Boolean
      read FCtl3D write SetCtl3D;
    property Visible : Boolean
      read FVisible write SetVisible;
    property Caption : String
      read FCaption write SetCaption;                            
  end;

  TApdFaxPrinterLog = class(TApdCustomFaxPrinterLog)
   published
    { Published declarations }
    property LogFileName;
  end;

  TApdFaxPrinterMargin = class(TApdCustomFaxPrinterMargin)
   published
    { Published declarations }
    property Caption;
    property Enabled;
    property Font;
  end;

  TApdCustomFaxPrinter = class(TApdBaseComponent)
  {private} public
    { Fax Filename }
    FFileName            : String;
    { Fax Page Counts }
    FTotalFaxPages       : Word;
    FCurrentPrintingPage : Word;
    FFirstPageToPrint    : Word;
    FLastPageToPrint     : Word;

    { Fax properties }
    FFaxResolution       : TFaxResolution;
    FFaxWidth            : TFaxWidth;
    FPrintScale          : TFaxPrintScale;
    FMultiPage           : Boolean;

    { Fax Print Status Dialog }
    FStatusDisplay       : TApdAbstractFaxPrinterStatus;
    FFaxPrintProgress    : TFaxPrintProgress;
    FFaxPrinterLog       : TApdFaxPrinterLog;

    { Fax Print Setup Dialog }
    FPrintDialog         : TPrintDialog;

    { Fax Unpacker }
    FFaxUnpack           : TApdFaxUnpacker;

    { page header/footer information }
    FFaxHeader           : TApdFaxPrinterMargin;
    FFaxFooter           : TApdFaxPrinterMargin;

    { fax printer events }
    FOnNextPage          : TFaxPrnNextPageEvent;
    FOnFaxPrintLog       : TFaxPLEvent;
    FOnFaxPrintStatus    : TFaxPrintStatusEvent;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure SetCaption(const Value: String);
    function GetCaption : String;
    procedure SetFaxFileName(const Value: String);
    procedure SetStatusDisplay(const Value: TApdAbstractFaxPrinterStatus);
    procedure SetFaxPrintLog(const Value: TApdFaxPrinterLog);

    function ReplaceHFParams(Value: String; Page: Word): String;
    procedure CreateFaxHeader(FaxCanvas : TCanvas; PN: Word; var AreaRect: TRect); virtual;
    procedure CreateFaxFooter(FaxCanvas : TCanvas; PN: Word; var AreaRect: TRect); virtual; 
    procedure SetFaxPrintProgress(const NewProgress : TFaxPrintProgress);
    procedure FaxPrintLog(LogCode: TFaxPLCode);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function PrintSetup : Boolean;                                   
    procedure PrintFax;
    procedure PrintAbort;

    { read only properties }
    property FaxWidth : TFaxWidth
      read FFaxWidth default afcDefFaxCvtWidth;                      
    property FaxResolution : TFaxResolution
      read FFaxResolution default afcDefResolution;
    property TotalFaxPages : Word
      read FTotalFaxPages default 0;
    property CurrentPrintingPage : Word
      read FCurrentPrintingPage default 0;
    property FirstPageToPrint: Word
      read FFirstPageToPrint write FFirstPageToPrint default 0;
    property LastPageToPrint : Word
      read FLastPageToPrint write FLastPageToPrint default 0;
    property PrintProgress : TFaxPrintProgress
      read FFaxPrintProgress write FFaxPrintProgress ;

  {published}
    property Caption : String
      read GetCaption write SetCaption;
    property FaxFooter : TApdFaxPrinterMargin
      read FFaxFooter write FFaxFooter;
    property FaxHeader : TApdFaxPrinterMargin
      read FFaxHeader write FFaxHeader;
    property FaxPrinterLog : TApdFaxPrinterLog
      read FFaxPrinterLog write SetFaxPrintLog;
    property FileName : String
      read FFileName write SetFaxFileName;
    property MultiPage : Boolean
      read FMultiPage write FMultiPage;
    property PrintScale : TFaxPrintScale
      read FPrintScale write FPrintScale default afpDefFaxPrintScale;
    property StatusDisplay : TApdAbstractFaxPrinterStatus
      read FStatusDisplay write SetStatusDisplay;

    property OnNextPage : TFaxPrnNextPageEvent
      read FOnNextPage write FOnNextPage;
    property OnFaxPrintLog : TFaxPLEvent
      read FOnFaxPrintLog write FOnFaxPrintLog;
    property OnFaxPrintStatus : TFaxPrintStatusEvent
      read FOnFaxPrintStatus write FOnFaxPrintStatus;
  end;

  TApdFaxPrinter = class(TApdCustomFaxPrinter)
  published
    property Caption;
    property FaxFooter;
    property FaxHeader;
    property FaxPrinterLog;
    property FileName;
    property MultiPage;
    property PrintScale;
    property StatusDisplay;

    property OnNextPage;
    property OnFaxPrintLog;
    property OnFaxPrintStatus;
  end;

implementation

{ Misc Stuff }

function SearchForDisplay(const Value: TComponent): TApdAbstractFaxPrinterStatus;

  function FindStatusDisplay(const Value: TComponent): TApdAbstractFaxPrinterStatus;
  var
    I: Integer;
  begin
    Result := nil;
    if not Assigned(Value) then
      exit;
    for I := 0 to Value.ComponentCount-1 do begin
      if Value.Components[I] is TApdAbstractFaxPrinterStatus then begin
        Result := TApdAbstractFaxPrinterStatus(Value.Components[I]);
        exit;
      end;
      Result := FindStatusDisplay(Value.Components[I]);
    end;
  end;

begin
  Result := FindStatusDisplay(Value);
end;

function SearchForPrinterLog(const Value: TComponent): TApdFaxPrinterLog;

  function FindPrinterLog(const Value: TComponent): TApdFaxPrinterLog;
  var
    I: Integer;
  begin
    Result := nil;
    if not Assigned(Value) then
      exit;
    for I := 0 to Value.ComponentCount-1 do begin
      if Value.Components[I] is TApdFaxPrinterLog then begin
        Result := TApdFaxPrinterLog(Value.Components[I]);
        exit;
      end;
      Result := FindPrinterLog(Value.Components[I]);
    end;
  end;

begin
  Result := FindPrinterLog(Value);
end;


{ TApdFaxPrinterLog }

constructor TApdCustomFaxPrinterLog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogFileName := afpDefFPLFileName;
end;

procedure TApdCustomFaxPrinterLog.UpdateLog(const LogCode: TFaxPLCode);
var
  LogFile : TextFile;
begin
  {Exit if no name specified}
  if (FLogFileName = '') then
    Exit;

  {Create or open the log file}
  try
    AssignFile(LogFile, FLogFileName);
    Append(LogFile);
  except
    on E : EInOutError do
      if E.ErrorCode = 2 then
        {File not found, open as new}
        Rewrite(LogFile)
      else
        {Unexpected error, forward the exception}
        raise;
  end;

  {Write the printer log entry}
  with TApdCustomFaxPrinter(FaxPrinter) do begin
    { TFaxPLCode = (lcStart, lcFinish, lcAborted, lcFailed); }
    case LogCode of
      lcStart  :
        WriteLn(LogFile, 'Printing ', FileName, ' started at ',
                DateTimeToStr(Now));
      lcFinish :
        WriteLn(LogFile, 'Printing ', FileName, ' finished at ',
                DateTimeToStr(Now), ^M^J);
      lcAborted:
        WriteLn(LogFile, 'Printing ', FileName, ' aborted at ',
                DateTimeToStr(Now), ^M^J);
      lcFailed :
        WriteLn(LogFile, 'Printing ', FileName, ' failed at ',
                DateTimeToStr(Now), ^M^J);
    end;
  end;

  Close(LogFile);
  if IOResult <> 0 then ;
end;

{ TApdCustomFaxPrinterMargin }

constructor TApdCustomFaxPrinterMargin.Create;
begin
  inherited Create;
  FCaption := '';
  FEnabled := False;
  FFont    := TFont.Create;
  Height   := 0;
end;

destructor TApdCustomFaxPrinterMargin.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TApdCustomFaxPrinterMargin.SetFont(const NewFont: TFont);
begin
  { Set the font }
  FFont.Assign(NewFont);
end;

{ TApdAbstractFaxPrintStatus }

procedure TApdAbstractFaxPrinterStatus.SetPosition(const Value: TPosition);
begin
  if Value <> FPosition then begin
    FPosition := Value;
    if Assigned(FDisplay) then
      FDisplay.Position := Value;
  end;
end;

procedure TApdAbstractFaxPrinterStatus.SetCtl3D(const Value: Boolean);
begin
  if Value <> FCtl3D then begin
    FCtl3D := Value;
    if Assigned(FDisplay) then
      FDisplay.Ctl3D := Value;
  end;
end;

procedure TApdAbstractFaxPrinterStatus.SetVisible(const Value: Boolean);
begin
  if Value <> FVisible then begin
    FVisible := Value;
    if Assigned(FDisplay) then
      FDisplay.Visible := Value;
  end;
end;

procedure TApdAbstractFaxPrinterStatus.SetCaption(const Value: String);
begin
  if Value <> FCaption then begin
    FCaption := Value;
    if Assigned(FDisplay) then
      FDisplay.Caption := Value;
  end;
end;                                                                    

procedure TApdAbstractFaxPrinterStatus.GetProperties;
begin
  if Assigned(FDisplay) then begin
    Position := FDisplay.Position;
    Ctl3D := FDisplay.Ctl3D;
    Visible := FDisplay.Visible;
    Caption := FDisplay.Caption;                                      
  end;
end;

constructor TApdAbstractFaxPrinterStatus.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := 'Print Status';                                          
  CreateDisplay;
  GetProperties;
end;

destructor TApdAbstractFaxPrinterStatus.Destroy;
begin
  DestroyDisplay;
  inherited Destroy;
end;

procedure TApdAbstractFaxPrinterStatus.Show;
begin
  if Assigned(FDisplay) then
    FDisplay.Show;
end;

{ TApdCustomFaxPrinter }

constructor TApdCustomFaxPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { Design time properties }
  Caption              := afpDefFaxPrnCaption;
  FFaxFooter           := TApdFaxPrinterMargin.Create;
  FFaxHeader           := TApdFaxPrinterMargin.Create;
  FFileName            := '';
  FMultiPage           := afpDefFaxMultiPage;
  FPrintScale          := afpDefFaxPrintScale;
  FStatusDisplay       := nil;
  FFaxPrinterLog       := nil;

  { page margin settings }
  FFaxFooter.Caption   := afpDefFaxFooterCaption;
  FFaxFooter.Enabled   := afpDefFaxFooterEnabled;
  FFaxHeader.Caption   := afpDefFaxHeaderCaption;
  FFaxHeader.Enabled   := afpDefFaxHeaderEnabled;

  { run-time / read-only properties }
  FTotalFaxPages       := 0;
  FCurrentPrintingPage := 0;
  FLastPageToPrint     := 0;
  FFaxResolution       := afcDefResolution;
  FFaxWidth            := afcDefFaxCvtWidth;                         
  FFaxPrintProgress    := ppIdle;

  StatusDisplay        := SearchForDisplay(Owner);
  FaxPrinterLog        := SearchForPrinterLog(Owner);

  if not (csDesigning in ComponentState) then begin
    FPrintDialog := TPrintDialog.Create(Self);
    FFaxUnpack := TApdFaxUnpacker.Create(Self);
  end else begin
    FPrintDialog := nil;
    FFaxUnpack := nil;
  end;
end;

destructor TApdCustomFaxPrinter.Destroy;
begin
  FFaxHeader.Free;
  FFaxFooter.Free;

  if Assigned(FPrintDialog) then
    FPrintDialog.Free;
  if Assigned(FFaxUnpack) then
    FFaxUnpack.Free;

  inherited Destroy;
end;

procedure TApdCustomFaxPrinter.Notification(AComponent: TComponent;
                                 Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  case Operation of
    opRemove :
      begin
        if AComponent = FStatusDisplay then
          FStatusDisplay := nil;
        if AComponent = FFaxPrinterLog then
          FFaxPrinterLog := nil;
      end;
    opInsert :
      begin
        if AComponent is TApdAbstractFaxPrinterStatus then begin
          if not Assigned(FStatusDisplay) then
            StatusDisplay := TApdAbstractFaxPrinterStatus(AComponent);
        end;
        if AComponent is TApdFaxPrinterLog then begin
          if not Assigned(FFaxPrinterLog) then
            FaxPrinterLog := TApdFaxPrinterLog(AComponent);
        end;
      end;
  end;
end;

procedure TApdCustomFaxPrinter.SetStatusDisplay(
              const Value: TApdAbstractFaxPrinterStatus);
begin
  if Value <> FStatusDisplay then begin
    FStatusDisplay  := Value;
    if Assigned(FStatusDisplay) then
      FStatusDisplay.FFaxPrinter := Self;
  end;
end;

procedure TApdCustomFaxPrinter.SetFaxFileName(const Value: String);
begin
  if FFileName <> Value then begin
    FFileName := Value;

    if not (csDesigning in ComponentState) then begin

      with FPrintDialog do begin
        { Set defaults for dialog }
        PrintRange := prAllPages;
        Options := [poPageNums];

        { Get the number of pages in the APF file }
        FFaxUnpack.InFileName := FFileName;
        FTotalFaxPages  := FFaxUnpack.NumPages;

        { Get detailed info for the fax }
        FFaxResolution := FFaxUnpack.FaxResolution;
        FFaxWidth  := FFaxUnpack.FaxWidth;

        { See if we have a good APF file }
        if FTotalFaxPages > 0 then begin
          FromPage := 1;
          MinPage := 1;
        end else begin
          FTotalFaxPages := 0;
          FromPage := 0;
          MinPage := 0;
        end;

        { Set page counts }
        MaxPage := FTotalFaxPages;
        ToPage := FTotalFaxPages;
        FFirstPageToPrint := FromPage;
        FLastPageToPrint := ToPage;
      end;
    end;
  end;
end;

procedure TApdCustomFaxPrinter.SetCaption(const Value: String);
begin
  { Set the job's print title in Printmanager}
  Printer.Title := Value;
end;

function TApdCustomFaxPrinter.GetCaption: String;
begin
  { Get the job's print title from print manager}
  Result := Printer.Title;
end;

procedure TApdCustomFaxPrinter.SetFaxPrintLog(const Value: TApdFaxPrinterLog);
begin
  if Value <> FFaxPrinterLog then begin
    FFaxPrinterLog := Value;
    if Assigned(FFaxPrinterLog) then
      FFaxPrinterLog.FFaxPrinter := Self;
  end;
end;

function TApdCustomFaxPrinter.ReplaceHFParams(Value: String;
                                              Page: Word): String;
var
  I, N: Word;
  T : String;
begin
  I := Pos('$', Value);
  while I > 0 do begin
    { total Length of tag }
    N := I;
    while (N <= Length(Value)) and (Value[N] <> ' ') do
      Inc(N);
    Dec(N, I);

    { preserve and delete the tag from the main string }
    T := Copy(Value, I, N);
    Delete(Value, I, N);

    { process the correct tag }
    case T[2] of
      'D', 'd' :
        T := DateToStr(Date);
      'T', 't' :
        T := TimeToStr(Time);
      'P', 'p' :
        T := IntToStr(Page);
      'N', 'n' :
        T := IntToStr(FTotalFaxPages);
      'F', 'f' :
        T := FileName;
       else
         T:= '';
    end;
    Insert(T, Value, I);

    { find the next tag }
    I := Pos('$', Value);
  end;
  Result := Value;
end;

procedure TApdCustomFaxPrinter.CreateFaxHeader(FaxCanvas : TCanvas;
                                 PN: Word; var AreaRect: TRect);
var
  Header : String;
begin
  { replace the header parameters}
  Header := ReplaceHFParams(FaxHeader.Caption, PN);

  { assign the new font for the header }
  FaxCanvas.Font := FaxHeader.Font;

  { if printing on a multipage sheet, reduce the font size }
  if MultiPage then
    FaxCanvas.Font.Size := (FaxCanvas.Font.Size div 2);

  { get the height of the header in pixels }
  FaxHeader.Height := FaxCanvas.TextHeight(Header);

  { draw the text to the printer canvas }
  with AreaRect do
    FaxCanvas.TextRect(Rect(Left, Top, Right, Top+FaxHeader.Height),
                       Left, Top, Header);

  AreaRect.Top := AreaRect.Top+FaxHeader.Height+2;

  { Draw a line under the header }
  FaxCanvas.MoveTo(AreaRect.Left, AreaRect.Top);
  FaxCanvas.LineTo(AreaRect.Right, AreaRect.Top);
  Inc(AreaRect.Top, 1);
end;

procedure TApdCustomFaxPrinter.CreateFaxFooter(FaxCanvas : TCanvas;
                                 PN: Word; var AreaRect: TRect);
var
  Footer : String;
begin
  { replace the footer parameters}
  Footer := ReplaceHFParams(FaxFooter.Caption, PN);

  { assign the new font for the footer }
  FaxCanvas.Font := FaxFooter.Font;

  { if printing on a multipage sheet, reduce the font size }
  if MultiPage then
    FaxCanvas.Font.Size := (FaxCanvas.Font.Size div 2);

  { get the height of the footer in pixels }
  FaxFooter.Height := FaxCanvas.TextHeight(Footer);

  { draw the text to the printer canvas }
  with AreaRect do
    FaxCanvas.TextRect(Rect(Left, Bottom-FaxFooter.Height, Right, Bottom),
                       Left, Bottom-FaxFooter.Height, Footer);
  AreaRect.Bottom := AreaRect.Bottom-FaxHeader.Height-2;

  { Draw a line over the footer }
  FaxCanvas.MoveTo(AreaRect.Left, AreaRect.Bottom);
  FaxCanvas.LineTo(AreaRect.Right, AreaRect.Bottom);
  Dec(AreaRect.Bottom, 1);
end;

procedure TApdCustomFaxPrinter.SetFaxPrintProgress(const NewProgress : TFaxPrintProgress);
begin
  if NewProgress <> FFaxPrintProgress then begin
    FFaxPrintProgress := NewProgress;

    { call FaxPrintStatus event if assigned }
    if Assigned(FOnFaxPrintStatus) then
      FOnFaxPrintStatus(Self, NewProgress);

    { update the display if assigned and visible }
    if Assigned(FStatusDisplay) then begin
      try
        if StatusDisplay.Display.Visible then
          StatusDisplay.UpdateDisplay(False, False);
      except
      end;
    end;
  end;
  Application.ProcessMessages;                                       
end;

procedure TApdCustomFaxPrinter.FaxPrintLog(LogCode: TFaxPLCode);
begin
  { call FaxPrintLog event if assigned }
  if Assigned(FOnFaxPrintLog) then
    FOnFaxPrintLog(Self, LogCode);

  { pass to FaxPrintLog component if assigned }
  if Assigned(FFaxPrinterLog) then
    FaxPrinterLog.UpdateLog(LogCode);
end;

procedure TApdCustomFaxPrinter.PrintAbort;
begin
  FFaxPrintProgress := ppIdle;
  if Printer.Printing then begin
    { stop any possible fax conversions }
    FFaxUnpack.Options := FFaxUnpack.Options + [uoAbort];            

    { abort the print job }
    Printer.Abort;
    FCurrentPrintingPage := 0;

    { update the log }
    FaxPrintLog(lcAborted);

    { update the status display }
    if Assigned(FStatusDisplay) then
      StatusDisplay.UpdateDisplay(False, True);
  end;
  Application.ProcessMessages;                                      
end;

function TApdCustomFaxPrinter.PrintSetup : Boolean;                  
begin
  { Display the Printer setup dialog }
  if FPrintDialog.Execute then begin
    FFirstPageToPrint := FPrintDialog.FromPage;
    FLastPageToPrint  := FPrintDialog.ToPage;
    Result := True;
  end else
    Result := False;                                                
end;

procedure TApdCustomFaxPrinter.PrintFax;
var
  PageLoop    : Word;
  PagesPrinted: Word;
  Image       : Pointer;
  Info        : PBitmapInfo;
  ImageSize   : DWord;
  InfoSize    : DWord;
  PrintWidth  : Integer;
  PrintHeight : Integer;
  FaxPageRect : TRect;
  FaxSizeRect : TRect;
  Bitmap      : TBitmap;
begin
  if TotalFaxPages > 0 then begin
    { show the printer status dialog if assigned }
    FFaxPrintProgress := ppIdle;
    if Assigned(FStatusDisplay) then
      StatusDisplay.UpdateDisplay(True, False);

    { call FaxPrintStatus event if assigned }
    if Assigned(FOnFaxPrintStatus) then
      FOnFaxPrintStatus(Self, FFaxPrintProgress);

    FaxPrintLog(lcStart);

    Printer.BeginDoc;

    for PageLoop := FirstPageToPrint to LastPageToPrint do begin
      FCurrentPrintingPage := PageLoop;

      { Increment the page / canvas to print upon}
      PagesPrinted := CurrentPrintingPage-FirstPageToPrint;
      Application.ProcessMessages;                                   
      if (PagesPrinted > 0) and Printer.Printing then begin
        if (not MultiPage) then
          Printer.NewPage
        else if MultiPage then begin
          case Printer.Orientation of
            poLandscape:
              begin
                if (((PageLoop-FirstPageToPrint) mod 2) = 0) then
                  Printer.NewPage;
              end;
            poPortrait :
              begin
                if (((PageLoop-FirstPageToPrint) mod 4) = 0) then
                  Printer.NewPage;
              end;
          end;
        end;
      end;

      Application.ProcessMessages;                                  
      if not Printer.Printing then
        Exit;

      { call the next page event if assigned }
      if Assigned(FOnNextPage) then
        FOnNextPage(Self, CurrentPrintingPage, TotalFaxPages);

      try
        SetFaxPrintProgress(ppConverting);
        Bitmap := FFaxUnpack.UnpackPageToBitmap(CurrentPrintingPage);

        Application.ProcessMessages;                                
        if not Printer.Printing then
          Exit;

        SetFaxPrintProgress(ppComposing);
        try
          GetDIBSizes(Bitmap.Handle, InfoSize, ImageSize);
          GetMem(Info, InfoSize);
          try
            GetMem(Image, ImageSize);
            try
              GetDIB(Bitmap.Handle, 0, Info^, Image^);

              { set initial area sizes for the fax page }
              FaxPageRect := Rect(0, 0, Printer.PageWidth, Printer.PageHeight);
              FaxSizeRect := Rect(0, 0, Bitmap.Width, Bitmap.Height);

              if MultiPage then begin
                FaxPageRect.Right := FaxPageRect.Right div 2;

                if Printer.Orientation = poPortrait then
                  FaxPageRect.Bottom := FaxPageRect.Bottom div 2;

                case ((PageLoop-(FirstPageToPrint)) mod 4) of
                  1 : { 2nd page }
                    begin
                      FaxPageRect.Left := FaxPageRect.Right;
                      FaxPageRect.Right := FaxPageRect.Right * 2;
                    end;
                  2 : { 3rd page of 4 }
                    begin
                      if Printer.Orientation = poPortrait then begin
                        FaxPageRect.Top := FaxPageRect.Bottom;
                        FaxPageRect.Bottom := FaxPageRect.Bottom * 2;
                      end;
                    end;
                  3 : { 4th page of 4 - or - 2nd page of 2 }
                    begin
                      FaxPageRect.Left := FaxPageRect.Right;
                      FaxPageRect.Right := FaxPageRect.Right * 2;
                      if Printer.Orientation = poPortrait then begin
                        FaxPageRect.Top := FaxPageRect.Bottom;
                        FaxPageRect.Bottom := FaxPageRect.Bottom * 2;
                      end;
                    end;
                end;
                { create a 2 pixel seperator region around pages }
                InflateRect(FaxPageRect, -2, -2);
              end;

              { place a header on the page if requested }
              Application.ProcessMessages;                          
              if Printer.Printing and FaxHeader.Enabled then
                CreateFaxHeader(Printer.Canvas, CurrentPrintingPage, FaxPageRect);

              { place a footer on the page if requested }
              Application.ProcessMessages;                          
              if Printer.Printing and FaxFooter.Enabled then
                CreateFaxFooter(Printer.Canvas, CurrentPrintingPage, FaxPageRect);

              { set the scaling options for the fax }
              case PrintScale of
                psFitToPage :
                  begin
                    PrintWidth :=
                      trunc(0.93 * (FaxPageRect.Right-FaxPageRect.Left));
                    if Bitmap.Width > 1728 then
                      PrintHeight :=
                        MulDiv(FaxPageRect.Bottom-FaxPageRect.Top,
                          Bitmap.Height,1728)
                    else
                      PrintHeight :=
                        MulDiv(FaxPageRect.Bottom-FaxPageRect.Top,
                          Bitmap.Width,1728);

                  end;
                else begin {psNone}
                  PrintWidth := MulDiv(Bitmap.Width,
                    Printer.Canvas.Font.PixelsPerInch, 200);
                  PrintHeight := MulDiv(Bitmap.Height,
                    Printer.Canvas.Font.PixelsPerInch, 200);         
                  if PrintHeight > (FaxPageRect.Bottom-FaxPageRect.Top) then
                    PrintHeight := (FaxPageRect.Bottom-FaxPageRect.Top);
                end;
              end;

              SetFaxPrintProgress(ppRendering);
              if Printer.Printing then
                with FaxSizeRect do
                  StretchDIBits(Printer.Canvas.Handle, FaxPageRect.Left,
                    FaxPageRect.Top, PrintWidth, PrintHeight, Left, Top,
                    Right, Bottom, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
              SetFaxPrintProgress(ppSubmitting);
            finally
              FreeMem(Image, ImageSize);
            end;
          finally
            FreeMem(Info, InfoSize);
          end;

        finally
          if Assigned(Bitmap) then
            Bitmap.Free
          else
            FaxPrintLog(lcFailed);
        end;
      finally
      end;
    end;

    Application.ProcessMessages;
    if Printer.Printing then
      Printer.EndDoc;

    FaxPrintLog(lcFinish);

    { remove the printer status dialog if showing }
    FFaxPrintProgress := ppIdle;
    if Assigned(FStatusDisplay) then
      StatusDisplay.UpdateDisplay(False, True);

    if Assigned(FOnFaxPrintStatus) then
      FOnFaxPrintStatus(Self, FFaxPrintProgress);
  end;
  FCurrentPrintingPage := 0;
end;

end.


