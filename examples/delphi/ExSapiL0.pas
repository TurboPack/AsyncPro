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
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   EXSAPIL0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* Lists all installed SAPI voice recognition and speech *}
{* synthesis engines.  Provides a large amount of detail *}
{* on each engine.                                       *}
{*********************************************************}
unit ExSapiL0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OoMisc, AdSapiEn, ExtCtrls, Grids, StdCtrls;

type
  TForm1 = class(TForm)
    ApdSapiEngine1: TApdSapiEngine;
    Panel1: TPanel;
    gridSR: TStringGrid;
    Splitter1: TSplitter;
    gridSS: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ExSapiL1;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  if (not ApdSapiEngine1.IsSapi4Installed) then begin
    ShowMessage ('SAPI is not installed.  This example will now exit');
    Application.Terminate;
    Exit;
  end;
  frmLoading := TfrmLoading.Create (Self);
  try
    frmLoading.ProgressBar1.Max := ApdSapiEngine1.SSVoices.Count +
                                   ApdSapiEngine1.SREngines.Count;
    frmLoading.Show;
    Application.ProcessMessages;
    { Fill in the column headers }
    gridSS.Cells[0, 0] := 'Name';
    gridSS.Cells[1, 0] := 'Dialect';
    gridSS.Cells[2, 0] := 'Engine ID';
    gridSS.Cells[3, 0] := 'Manufacturer Name';
    gridSS.Cells[4, 0] := 'Mode ID';
    gridSS.Cells[5, 0] := 'Product Name';
    gridSS.Cells[6, 0] := 'Speaker';
    gridSS.Cells[7, 0] := 'Style';
    gridSS.Cells[8, 0] := 'Age';
    gridSS.Cells[9, 0] := 'Gender';
    gridSS.Cells[10, 0] := 'Language ID';
    gridSS.Cells[11, 0] := 'Any Word';
    gridSS.Cells[12, 0] := 'Volume';
    gridss.Cells[13, 0] := 'Speed';
    gridss.Cells[14, 0] := 'Pitch';
    gridss.Cells[15, 0] := 'Tagged';
    gridss.Cells[16, 0] := 'IPA Unicode';
    gridss.Cells[17, 0] := 'Visual';
    gridss.Cells[18, 0] := 'Word Position';
    gridss.Cells[19, 0] := 'PC Optimized';
    gridss.Cells[20, 0] := 'Phone Optimized';
    gridss.Cells[21, 0] := 'Fixed Audio';
    gridss.Cells[22, 0] := 'Single Instance';
    gridss.Cells[23, 0] := 'Thread Safe';
    gridss.Cells[24, 0] := 'IPA Text Data';
    gridss.Cells[25, 0] := 'Preferred';
    gridss.Cells[26, 0] := 'Transplanted';
    gridss.Cells[27, 0] := 'SAPI4';
    { Get information on the speech synthesis voices }
    for i := 0 to ApdSapiEngine1.SSVoices.Count - 1 do begin
      gridSS.RowCount := i + 2;
      gridSS.Cells[0, i + 1] := ApdSapiEngine1.SSVoices[i];
      gridSS.Cells[1, i + 1] := ApdSapiEngine1.SSVoices.Dialect[i];
      gridSS.Cells[2, i + 1] := ApdSapiEngine1.SSVoices.EngineID[i];
      gridSS.Cells[3, i + 1] := ApdSapiEngine1.SSVoices.MfgName[i];
      gridSS.Cells[4, i + 1] := ApdSapiEngine1.SSVoices.ModeID[i];
      gridSS.Cells[5, i + 1] := ApdSapiEngine1.SSVoices.ProductName[i];
      gridSS.Cells[6, i + 1] := ApdSapiEngine1.SSVoices.Speaker[i];
      gridSS.Cells[7, i + 1] := ApdSapiEngine1.SSVoices.Style[i];
      case ApdSapiEngine1.SSVoices.Age[i] of
        tsBaby       : gridSS.Cells[8, i + 1] := 'Baby';
        tsToddler    : gridSS.Cells[8, i + 1] := 'Toddler';
        tsChild      : gridSS.Cells[8, i + 1] := 'Child';
        tsAdolescent : gridSS.Cells[8, i + 1] := 'Adolescent';
        tsAdult      : gridSS.Cells[8, i + 1] := 'Adult';
        tsElderly    : gridSS.Cells[8, i + 1] := 'Elderly';
        else
          gridSS.Cells[8, i + 1] := 'Unknown';
      end;
      case ApdSapiEngine1.SSVoices.Gender[i] of
        tgNeutral : gridSS.Cells[9, i + 1] := 'Neutral';
        tgFemale  : gridSS.Cells[9, i + 1] := 'Female';
        tgMale    : gridSS.Cells[9, i + 1] := 'Male';
        else
           gridSS.Cells[9, i + 1] := 'Unknown';
      end;
      gridSS.Cells[10, i + 1] := IntToStr (ApdSapiEngine1.SSVoices.LanguageID[i]);
      if tfAnyWord in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[11, i + 1] := 'Yes';
      if tfVolume in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[12, i + 1] := 'Yes';
      if tfSpeed in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[13, i + 1] := 'Yes';
      if tfPitch in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[14, i + 1] := 'Yes';
      if tfTagged in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[15, i + 1] := 'Yes';
      if tfIPAUnicode in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[16, i + 1] := 'Yes';
      if tfVisual in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[17, i + 1] := 'Yes';
      if tfWordPosition in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[18, i + 1] := 'Yes';
      if tfPCOptimized in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[19, i + 1] := 'Yes';
      if tfPhoneOptimized in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[20, i + 1] := 'Yes';
      if tfFixedAudio in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[21, i + 1] := 'Yes';
      if tfSingleInstance in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[22, i + 1] := 'Yes';
      if tfThreadSafe in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[23, i + 1] := 'Yes';
      if tfIPATextData in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[24, i + 1] := 'Yes';
      if tfPreferred in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[25, i + 1] := 'Yes';
      if tfTransplanted in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[26, i + 1] := 'Yes';
      if tfSAPI4 in ApdSapiEngine1.SSVoices.Features[i] then
        gridSS.Cells[27, i + 1] := 'Yes';
      frmLoading.ProgressBar1.Position := frmLoading.ProgressBar1.Position + 1;
    end;
    gridSS.FixedRows := 1;
    gridSS.FixedCols := 1;

    
    frmLoading.Label1.Caption :=
                            'Loading SAPI Speech Recognition Engine Details';
    gridSR.Cells[0, 0] := 'Name';
    gridSR.Cells[1, 0] := 'Dialect';
    gridSR.Cells[2, 0] := 'Engine ID';
    gridSR.Cells[3, 0] := 'Mfg Name';
    gridSR.Cells[4, 0] := 'Mode ID';
    gridSR.Cells[5, 0] := 'Product Name';
    gridSR.Cells[6, 0] := 'CFG';
    gridSR.Cells[7, 0] := 'Dictation';
    gridSR.Cells[8, 0] := 'Limited Domain';
    gridSR.Cells[9, 0] := 'Language ID';
    gridSR.Cells[10, 0] := 'Max Words State';
    gridSR.Cells[11, 0] := 'Max Words Vocab';
    gridSR.Cells[12, 0] := 'Sequencing';
    gridSR.Cells[13, 0] := 'Indep Speaker';
    gridSR.Cells[14, 0] := 'Indep Microphone';
    gridSR.Cells[15, 0] := 'Train Word';
    gridSR.Cells[16, 0] := 'Train Phonetic';
    gridSR.Cells[17, 0] := 'Wildcard';
    gridSR.Cells[18, 0] := 'Any Word';
    gridSR.Cells[19, 0] := 'PC Optimized';
    gridSR.Cells[20, 0] := 'Phone Optimized';
    gridSR.Cells[21, 0] := 'Gram List';
    gridSR.Cells[22, 0] := 'Gram Link';
    gridSR.Cells[23, 0] := 'Multi Lingual';
    gridSR.Cells[24, 0] := 'Gram Recursive';
    gridSR.Cells[25, 0] := 'IPA Unicode';
    gridSR.Cells[26, 0] := 'Single Instance';
    gridSR.Cells[27, 0] := 'Thread Safe';
    gridSR.Cells[28, 0] := 'Fixed Audio';
    gridSR.Cells[29, 0] := 'IPA Word';
    gridSR.Cells[30, 0] := 'SAPI4';

    for i := 0 to ApdSapiEngine1.SREngines.Count - 1 do begin
      gridSR.RowCount := i + 2;
      gridSR.Cells[0, i + 1] := ApdSapiEngine1.SREngines[i];
      gridSR.Cells[1, i + 1] := ApdSapiEngine1.SREngines.Dialect[i];
      gridSR.Cells[2, i + 1] := ApdSapiEngine1.SREngines.EngineID[i];
      gridSR.Cells[3, i + 1] := ApdSapiEngine1.SREngines.MfgName[i];
      gridSR.Cells[4, i + 1] := ApdSapiEngine1.SREngines.ModeID[i];
      gridSR.Cells[5, i + 1] := ApdSapiEngine1.SREngines.ProductName[i];

      if sgCFG in ApdSapiEngine1.SREngines.Grammars[i] then
        gridSR.Cells[6, i + 1] := 'Yes';
      if sgDictation  in ApdSapiEngine1.SREngines.Grammars[i] then
        gridSR.Cells[7, i + 1] := 'Yes';
      if sgLimitedDomain  in ApdSapiEngine1.SREngines.Grammars[i] then
        gridSR.Cells[8, i + 1] := 'Yes';

      gridSR.Cells[9, i + 1] := IntToStr (ApdSapiEngine1.SREngines.LanguageID[i]);
      gridSR.Cells[10, i + 1] := IntToStr (ApdSapiEngine1.SREngines.MaxWordsState[i]);
      gridSR.Cells[11, i + 1] := IntToStr (ApdSapiEngine1.SREngines.MaxWordsVocab[i]);
      case ApdSapiEngine1.SREngines.Sequencing[i] of
        ssDiscrete         : gridSR.Cells[12, i + 1] := 'Discrete';
        ssContinuous       : gridSR.Cells[12, i + 1] := 'Continuous';
        ssWordSpot         : gridSR.Cells[12, i + 1] := 'Word Spotting';
        ssContCFGDiscDict  : gridSR.Cells[12, i + 1] := 'CFG Discrete Dictionary';
        else
          gridSR.Cells[12, i + 1] := 'Unknown';
      end;
      if sfIndepSpeaker in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[13, i + 1] := 'Yes';
      if sfIndepMicrophone in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[14, i + 1] := 'Yes';
      if sfTrainWord in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[15, i + 1] := 'Yes';
      if sfTrainPhonetic in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[16, i + 1] := 'Yes';
      if sfWildcard in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[17, i + 1] := 'Yes';
      if sfAnyWord in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[18, i + 1] := 'Yes';
      if sfPCOptimized in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[19, i + 1] := 'Yes';
      if sfPhoneOptimized in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[20, i + 1] := 'Yes';
      if sfGramList in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[21, i + 1] := 'Yes';
      if sfGramLink in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[22, i + 1] := 'Yes';
      if sfMultiLingual in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[23, i + 1] := 'Yes';
      if sfGramRecursive in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[24, i + 1] := 'Yes';
      if sfIPAUnicode in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[25, i + 1] := 'Yes';
      if sfSingleInstance in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[26, i + 1] := 'Yes';
      if sfThreadSafe in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[27, i + 1] := 'Yes';
      if sfFixedAudio in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[28, i + 1] := 'Yes';
      if sfIPAWord in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[29, i + 1] := 'Yes';
      if sfSAPI4 in ApdSapiEngine1.SREngines.Features[i] then
        gridSR.Cells[30, i + 1] := 'Yes';
      frmLoading.ProgressBar1.Position := frmLoading.ProgressBar1.Position + 1;
    end;
    gridSR.FixedRows := 1;
    gridSR.FixedCols := 1;

  finally
    frmLoading.Free;
  end;
end;

end.
