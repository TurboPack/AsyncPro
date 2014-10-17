// ***** BEGIN LICENSE BLOCK *****
// * Version: MPL 1.1
// *
// * The contents of this file are subject to the Mozilla Public License Version
// * 1.1 (the "License"); you may not use this file except in compliance with
// * the License. You may obtain a copy of the License at
// * http://www.mozilla.org/MPL/
// *
// * Software distributed under the License is distributed on an "AS IS" basis,
// * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// * for the specific language governing rights and limitations under the
// * License.
// *
// * The Original Code is TurboPower Async Professional
// *
// * The Initial Developer of the Original Code is
// * TurboPower Software
// *
// * Portions created by the Initial Developer are Copyright (C) 1991-2002
// * the Initial Developer. All Rights Reserved.
// *
// * Contributor(s):
// *
// * ***** END LICENSE BLOCK *****

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "ExSapiL0.h"
#include "ExSapiL1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdSapiEn"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  if (ApdSapiEngine1->IsSapi4Installed() == false)
  {
    ShowMessage ("SAPI 4 is not installed. This example will now AV.");
    Application->Terminate();
  }
  int i;
  TfrmLoading *frmLoading;

  frmLoading = new TfrmLoading (Application);
  frmLoading->ProgressBar1->Max = ApdSapiEngine1->SSVoices->Count +
                                  ApdSapiEngine1->SREngines->Count;
  frmLoading->Show ();
  Application->ProcessMessages ();
  // Fill in the column headers
  gridSS->Cells[0][0] = "Name";
  gridSS->Cells[1][0] = "Dialect";
  gridSS->Cells[2][0] = "Engine ID";
  gridSS->Cells[3][0] = "Manufacturer Name";
  gridSS->Cells[4][0] = "Mode ID";
  gridSS->Cells[5][0] = "Product Name";
  gridSS->Cells[6][0] = "Speaker";
  gridSS->Cells[7][0] = "Style";
  gridSS->Cells[8][0] = "Age";
  gridSS->Cells[9][0] = "Gender";
  gridSS->Cells[10][0] = "Language ID";
  gridSS->Cells[11][0] = "Any Word";
  gridSS->Cells[12][0] = "Volume";
  gridSS->Cells[13][0] = "Speed";
  gridSS->Cells[14][0] = "Pitch";
  gridSS->Cells[15][0] = "Tagged";
  gridSS->Cells[16][0] = "IPA Unicode";
  gridSS->Cells[17][0] = "Visual";
  gridSS->Cells[18][0] = "Word Position";
  gridSS->Cells[19][0] = "PC Optimized";
  gridSS->Cells[20][0] = "Phone Optimized";
  gridSS->Cells[21][0] = "Fixed Audio";
  gridSS->Cells[22][0] = "Single Instance";
  gridSS->Cells[23][0] = "Thread Safe";
  gridSS->Cells[24][0] = "IPA Text Data";
  gridSS->Cells[25][0] = "Preferred";
  gridSS->Cells[26][0] = "Transplanted";
  gridSS->Cells[27][0] = "SAPI4";
  // Get information on the speech synthesis voices
  for (i = 0; i < ApdSapiEngine1->SSVoices->Count; i++) {
    gridSS->RowCount = i + 2;
    gridSS->Cells[0][i + 1] = ApdSapiEngine1->SSVoices->ModeName[i];
    gridSS->Cells[1][i + 1] = ApdSapiEngine1->SSVoices->Dialect[i];
    gridSS->Cells[2][i + 1] = ApdSapiEngine1->SSVoices->EngineID[i];
    gridSS->Cells[3][i + 1] = ApdSapiEngine1->SSVoices->MfgName[i];
    gridSS->Cells[4][i + 1] = ApdSapiEngine1->SSVoices->ModeID[i];
    gridSS->Cells[5][i + 1] = ApdSapiEngine1->SSVoices->ProductName[i];
    gridSS->Cells[6][i + 1] = ApdSapiEngine1->SSVoices->Speaker[i];
    gridSS->Cells[7][i + 1] = ApdSapiEngine1->SSVoices->Style[i];
    switch (ApdSapiEngine1->SSVoices->Age[i]) {
      case tsBaby       :
        gridSS->Cells[8][i + 1] = "Baby";
        break;
      case tsToddler    :
        gridSS->Cells[8][i + 1] = "Toddler";
        break;
      case tsChild      :
        gridSS->Cells[8][i + 1] = "Child";
        break;
      case tsAdolescent :
        gridSS->Cells[8][i + 1] = "Adolescent";
        break;
      case tsAdult      :
        gridSS->Cells[8][i + 1] = "Adult";
        break;
      case tsElderly    :
        gridSS->Cells[8][i + 1] = "Elderly";
        break;
      default:
        gridSS->Cells[8][i + 1] = "Unknown";
    }
    switch (ApdSapiEngine1->SSVoices->Gender[i]) {
      case tgNeutral :
        gridSS->Cells[9][i + 1] = "Neutral";
        break;
      case tgFemale  :
        gridSS->Cells[9][i + 1] = "Female";
        break;
      case tgMale    :
        gridSS->Cells[9][i + 1] = "Male";
        break;
      default :
         gridSS->Cells[9][i + 1] = "Unknown";
    }
    gridSS->Cells[10][i + 1] =
        IntToStr (ApdSapiEngine1->SSVoices->LanguageID[i]);
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfAnyWord))
      gridSS->Cells[11][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfVolume))
      gridSS->Cells[12][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfSpeed))
      gridSS->Cells[13][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfPitch))
      gridSS->Cells[14][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfTagged))
      gridSS->Cells[15][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfIPAUnicode))
      gridSS->Cells[16][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfVisual))
      gridSS->Cells[17][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfWordPosition))
      gridSS->Cells[18][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfPCOptimized))
      gridSS->Cells[19][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfPhoneOptimized))
      gridSS->Cells[20][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfFixedAudio))
      gridSS->Cells[21][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfSingleInstance))
      gridSS->Cells[22][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfThreadSafe))
      gridSS->Cells[23][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfIPATextData))
      gridSS->Cells[24][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfPreferred))
      gridSS->Cells[25][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfTransplanted))
      gridSS->Cells[26][i + 1] = "Yes";
    if (ApdSapiEngine1->SSVoices->Features[i].Contains (tfSAPI4))
      gridSS->Cells[27][i + 1] = "Yes";
    frmLoading->ProgressBar1->Position =
        frmLoading->ProgressBar1->Position + 1;
  }
  gridSS->FixedRows = 1;
  gridSS->FixedCols = 1;

    
  frmLoading->Label1->Caption =
                          "Loading SAPI Speech Recognition Engine Details";
  gridSR->Cells[0][0] = "Name";
  gridSR->Cells[1][0] = "Dialect";
  gridSR->Cells[2][0] = "Engine ID";
  gridSR->Cells[3][0] = "Mfg Name";
  gridSR->Cells[4][0] = "Mode ID";
  gridSR->Cells[5][0] = "Product Name";
  gridSR->Cells[6][0] = "CFG";
  gridSR->Cells[7][0] = "Dictation";
  gridSR->Cells[8][0] = "Limited Domain";
  gridSR->Cells[9][0] = "Language ID";
  gridSR->Cells[10][0] = "Max Words State";
  gridSR->Cells[11][0] = "Max Words Vocab";
  gridSR->Cells[12][0] = "Sequencing";
  gridSR->Cells[13][0] = "Indep Speaker";
  gridSR->Cells[14][0] = "Indep Microphone";
  gridSR->Cells[15][0] = "Train Word";
  gridSR->Cells[16][0] = "Train Phonetic";
  gridSR->Cells[17][0] = "Wildcard";
  gridSR->Cells[18][0] = "Any Word";
  gridSR->Cells[19][0] = "PC Optimized";
  gridSR->Cells[20][0] = "Phone Optimized";
  gridSR->Cells[21][0] = "Gram List";
  gridSR->Cells[22][0] = "Gram Link";
  gridSR->Cells[23][0] = "Multi Lingual";
  gridSR->Cells[24][0] = "Gram Recursive";
  gridSR->Cells[25][0] = "IPA Unicode";
  gridSR->Cells[26][0] = "Single Instance";
  gridSR->Cells[27][0] = "Thread Safe";
  gridSR->Cells[28][0] = "Fixed Audio";
  gridSR->Cells[29][0] = "IPA Word";
  gridSR->Cells[30][0] = "SAPI4";

  for (i = 0; i < ApdSapiEngine1->SREngines->Count; i++) {
    gridSR->RowCount = i + 2;
    gridSR->Cells[0][i + 1] = ApdSapiEngine1->SREngines->ModeName[i];
    gridSR->Cells[1][i + 1] = ApdSapiEngine1->SREngines->Dialect[i];
    gridSR->Cells[2][i + 1] = ApdSapiEngine1->SREngines->EngineID[i];
    gridSR->Cells[3][i + 1] = ApdSapiEngine1->SREngines->MfgName[i];
    gridSR->Cells[4][i + 1] = ApdSapiEngine1->SREngines->ModeID[i];
    gridSR->Cells[5][i + 1] = ApdSapiEngine1->SREngines->ProductName[i];

    if (ApdSapiEngine1->SREngines->Grammars[i].Contains (sgCFG))
      gridSR->Cells[6][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Grammars[i].Contains (sgDictation))
      gridSR->Cells[7][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Grammars[i].Contains (sgLimitedDomain))
      gridSR->Cells[8][i + 1] = "Yes";

    gridSR->Cells[9][i + 1] =
        IntToStr (ApdSapiEngine1->SREngines->LanguageID[i]);
    gridSR->Cells[10][i + 1] =
        IntToStr (ApdSapiEngine1->SREngines->MaxWordsState[i]);
    gridSR->Cells[11][i + 1] =
        IntToStr (ApdSapiEngine1->SREngines->MaxWordsVocab[i]);
    switch (ApdSapiEngine1->SREngines->Sequencing[i]) {
      case ssDiscrete         :
        gridSR->Cells[12][i + 1] = "Discrete";
        break;
      case ssContinuous       :
        gridSR->Cells[12][i + 1] = "Continuous";
        break;
      case ssWordSpot         :
        gridSR->Cells[12][i + 1] = "Word Spotting";
        break;
      case ssContCFGDiscDict  :
        gridSR->Cells[12][i + 1] = "CFG Discrete Dictionary";
        break;
      default :
        gridSR->Cells[12][i + 1] = "Unknown";
    }
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfIndepSpeaker))
      gridSR->Cells[13][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfIndepMicrophone))
      gridSR->Cells[14][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfTrainWord))
      gridSR->Cells[15][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfTrainPhonetic))
      gridSR->Cells[16][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfWildcard))
      gridSR->Cells[17][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfAnyWord))
      gridSR->Cells[18][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfPCOptimized ))
      gridSR->Cells[19][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfPhoneOptimized))
      gridSR->Cells[20][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfGramList))
      gridSR->Cells[21][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfGramLink))
      gridSR->Cells[22][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfMultiLingual))
      gridSR->Cells[23][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfGramRecursive))
      gridSR->Cells[24][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfIPAUnicode))
      gridSR->Cells[25][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfSingleInstance))
      gridSR->Cells[26][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfThreadSafe))
      gridSR->Cells[27][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfFixedAudio))
      gridSR->Cells[28][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfIPAWord))
      gridSR->Cells[29][i + 1] = "Yes";
    if (ApdSapiEngine1->SREngines->Features[i].Contains (sfSAPI4))
      gridSR->Cells[30][i + 1] = "Yes";
    frmLoading->ProgressBar1->Position =
        frmLoading->ProgressBar1->Position + 1;
  }
  gridSR->FixedRows = 1;
  gridSR->FixedCols = 1;

  delete frmLoading;
}
//---------------------------------------------------------------------------
