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
{*                   ADFPSTAT.PAS 4.06                   *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdFPStat;
  { Apro Fax printer status component}

interface

uses
  Windows,
  SysUtils,
  Classes,
  Forms,
  Controls,
  Dialogs,
  Buttons,
  AdFaxPrn,
  StdCtrls;

type
  TStandardFaxPrinterStatusDisplay = class(TForm)
    fpsFaxInfoGroup    : TGroupBox;
    fpsLabel1          : TLabel;
    fpsLabel2          : TLabel;
    fpsLabel3          : TLabel;
    fpsLabel4          : TLabel;
    fpsFileName        : TLabel;
    fpsTotalPages      : TLabel;
    fpsResolution      : TLabel;
    fpsWidth           : TLabel;
    fpsStatusGroup     : TGroupBox;
    fpsAbortButton     : TBitBtn;
    fpsStatusLine      : TLabel;
    fpsLabel5: TLabel;
    fpsLabel6: TLabel;
    fpsFirstPage: TLabel;
    fpsLastPage: TLabel;
    procedure fpsAbortButtonClick(Sender: TObject);
    procedure UpdateValues(FaxStatus: TApdCustomFaxPrinter);
  public
    { Public declarations }
    FaxPrinter : TApdCustomFaxPrinter;
  end;

  TApdFaxPrinterStatus = class(TApdAbstractFaxPrinterStatus)
    procedure CreateDisplay; override;
    procedure DestroyDisplay; override;
    procedure UpdateDisplay(First, Last: Boolean); override;
  end;

implementation

{$R *.DFM}

procedure TStandardFaxPrinterStatusDisplay.UpdateValues(FaxStatus: TApdCustomFaxPrinter);
const
  ResStrings   : array[0..1] of String  = ('standard', 'high');
  WidthStrings : array[0..1] of String  = ('1728', '2048');
  ProgressSt   : array[TFaxPrintProgress] of String = ('Idle', 'Composing',
                                       'Rendering', 'Submitting', 'Converting');

var
  PageStats : String;
begin
  with FaxStatus do begin
    fpsFileName.Caption   := AnsiUpperCase(ExtractFileName(FileName));
    fpsTotalPages.Caption := IntToStr(TotalFaxPages);
    fpsResolution.Caption := ResStrings[Ord(FaxResolution)];
    fpsWidth.Caption      := WidthStrings[Ord(FaxWidth)];
    fpsFirstPage.Caption  := IntToStr(FirstPageToPrint);
    fpsLastPage.Caption   := IntToStr(LastPageToPrint);

    FmtStr(PageStats, '%s %d of %d', [ProgressSt[PrintProgress],
                      CurrentPrintingPage, LastPageToPrint]);
    fpsStatusLine.Caption := PageStats;
  end;
end;

procedure TApdFaxPrinterStatus.CreateDisplay;
begin
  Display := TStandardFaxPrinterStatusDisplay.Create(Self);
  (Display as TStandardFaxPrinterStatusDisplay).FaxPrinter := FaxPrinter;

  (Display as TStandardFaxPrinterStatusDisplay).Caption := FCaption;
end;

procedure TApdFaxPrinterStatus.DestroyDisplay;
begin
  if Assigned(FDisplay) then
    Display.Free;
end;

procedure TApdFaxPrinterStatus.UpdateDisplay(First, Last: Boolean);
begin
  if First then begin
    (Display as TStandardFaxPrinterStatusDisplay).FaxPrinter := FaxPrinter;
    Display.Show;
  end;
  if Last then
    Display.Visible := False
  else
    (Display as TStandardFaxPrinterStatusDisplay).UpdateValues(FaxPrinter);
end;


procedure TStandardFaxPrinterStatusDisplay.fpsAbortButtonClick(Sender: TObject);
begin
  FaxPrinter.PrintAbort;
end;

end.
