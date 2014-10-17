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

#include "ExSapiA0.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdSapiEn"
#pragma link "AdSapiPh"
#pragma link "AdTapi"
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
    ShowMessage ("SAPI 4 is not installed. This example will now exit.");
    Application->Terminate();
  }
  ColorList = new TStringList ();
  ColorList->Add ("red");
  ColorList->Add ("blue");
  ColorList->Add ("yellow");
  ColorList->Add ("green");
  ColorList->Add ("orange");
  ColorList->Add ("purple");
  ColorList->Add ("violet");
  ColorList->Add ("brown");
  ColorList->Add ("black");
  ColorList->Add ("white");
  ColorList->Add ("gray");
  ColorList->Add ("maroon");
  ColorList->Add ("olive");
  ColorList->Add ("navy");
  ColorList->Add ("teal");
  ColorList->Add ("silver");
  ColorList->Add ("lime");
  ColorList->Add ("fuchsia");
  ColorList->Add ("aqua");

  PlanetList = new TStringList ();
  PlanetList->Add ("[opt] the sun");
  PlanetList->Add ("[opt] the moon");
  PlanetList->Add ("mercury");
  PlanetList->Add ("venus");
  PlanetList->Add ("[opt] the earth");
  PlanetList->Add ("mars");
  PlanetList->Add ("jupiter");
  PlanetList->Add ("saturn");
  PlanetList->Add ("neptune");
  PlanetList->Add ("uranus");
  PlanetList->Add ("pluto");
  PlanetList->Add ("rupert");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormDestroy(TObject *Sender)
{
  delete ColorList;
  delete PlanetList;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiEngine1Interference(TObject *Sender,
      TApdSRInterferenceType InterferenceType)
{
  switch (InterferenceType) {
    case itAudioStarted :
      Memo1->Lines->Add("*** Interference - Audio Started ***");
      break;
    case itAudioStopped :
      Memo1->Lines->Add("*** Interference - Audio Stopped ***");
      break;
    case itDeviceOpened :
      Memo1->Lines->Add("*** Interference - Device Opened ***");
      break;
    case itDeviceClosed :
      Memo1->Lines->Add("*** Interference - Device Closed ***");
      break;
    case itNoise :
      Memo1->Lines->Add("*** Interference - Noise ***");
      break;
    case itTooLoud :
      Memo1->Lines->Add("*** Interference - Too Loud ***");
      break;
    case itTooQuiet :
      Memo1->Lines->Add("*** Interference - Too Quiet ***");
      break;
    case itUnknown :
      Memo1->Lines->Add("*** Interference - Unknown ***");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiEngine1PhraseFinish(TObject *Sender,
      const AnsiString Phrase)
{
  Memo1->Lines->Add ("REPLY --> " + Phrase);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiEngine1SRError(TObject *Sender, DWORD Error,
      const AnsiString Details, const AnsiString Message)
{
  Memo1->Lines->Add ("SR Error: " + Message);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForDateFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, TDateTime Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      Memo1->Lines->Add ("DATE --> " + FormatDateTime ("dddddd", Data) +
                         " (" + SpokenData + ")");
      lblDate->Caption = FormatDateTime ("dddddd", Data);
      break;
    case prCheck :
      Memo1->Lines->Add ("DATE --> " + FormatDateTime ("dddddd", Data) +
                         "? (" + SpokenData + ")");
      lblDate->Caption = FormatDateTime ("dddddd", Data);
      break;
    case prOperator :
      Memo1->Lines->Add ("DATE --> [operator]");
      break;
    case prHangUp :
      Memo1->Lines->Add ("DATE --> [hangup]");
      break;
    case prBack :
      Memo1->Lines->Add ("DATE --> [back]");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForExtensionFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, AnsiString Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      Memo1->Lines->Add ("EXT --> " + Data);
      lblExtension->Caption = Data;
      break;
    case prOperator :
      Memo1->Lines->Add ("EXT --> [operator]");
      break;
    case prHangUp :
      Memo1->Lines->Add ("EXT --> [hangup]");
      break;
    case prBack :
      Memo1->Lines->Add ("EXT --> [back]");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForListFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, int Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      if (Data >= 0) {
        switch (ListRequest) {
          case lrPlanet :
            if (Data <= 1) 
              lblPlanet->Caption = PlanetList->Strings[Data] +
                                   " (not really a planet)";
            else
              lblPlanet->Caption = PlanetList->Strings[Data];
            break;

          case lrColor :
            lblColor->Caption = ColorList->Strings[Data];
            switch (Data) {
              case 0  :
                Shape1->Brush->Color = clRed;
                break;
              case 1  :
                Shape1->Brush->Color = clBlue;
                break;
              case 2  :
                Shape1->Brush->Color = clYellow;
                break;
              case 3  :
                Shape1->Brush->Color = clGreen;
                break;
              case 4  :
                Shape1->Brush->Color = (TColor) 0x007FFF;
                break;
              case 5  :
                Shape1->Brush->Color = clPurple;
                break;
              case 6  :
                Shape1->Brush->Color = clPurple;
                break;
              case 7  :
                Shape1->Brush->Color = (TColor) 0x00003399;
                break;
              case 8  :
                Shape1->Brush->Color = clBlack;
                break;
              case 9  :
                Shape1->Brush->Color = (TColor) 0x00FFFFFF;
                break;
              case 10 :
                Shape1->Brush->Color = clGray;
                break;
              case 11 :
                Shape1->Brush->Color = clMaroon;
                break;
              case 12 :
                Shape1->Brush->Color = clOlive;
                break;
              case 13 :
                Shape1->Brush->Color = clNavy;
                break;
              case 14 :
                Shape1->Brush->Color = clTeal;
                break;
              case 15 :
                Shape1->Brush->Color = clSilver;
                break;
              case 16 :
                Shape1->Brush->Color = clLime;
                break;
              case 17 :
                Shape1->Brush->Color = clFuchsia;
                break;
              case 18 :
                Shape1->Brush->Color = clAqua;
                break;
            }
            break;
        }
      }
      Memo1->Lines->Add ("LIST --> " + IntToStr (Data) + " (" +
                         SpokenData + ")");
      break;
    case prOperator :
      Memo1->Lines->Add ("LIST --> [operator]");
      break;
    case prHangUp :
      Memo1->Lines->Add ("LIST --> [hangup]");
      break;
    case prBack :
      Memo1->Lines->Add ("LIST --> [back]");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForPhoneNumberFinish(
      TObject *Sender, TApdSapiPhoneReply Reply, AnsiString Data,
      AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      Memo1->Lines->Add ("PHONE --> " + Data + " (" + SpokenData + ")");
      lblPhoneNumber->Caption = Data;
      break;
    case prOperator :
      Memo1->Lines->Add ("PHONE --> [operator]");
      break;
    case prHangUp :
      Memo1->Lines->Add ("PHONE --> [hangup]");
      break;
    case prBack :
      Memo1->Lines->Add ("PHONE --> [back]");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForSpellingFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, AnsiString Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      Memo1->Lines->Add ("SPELL --> " + Data);
      lblSpelling->Caption = Data;
      break;
    case prOperator :
      Memo1->Lines->Add ("SPELL --> [operator]");
      break;
    case prHangUp :
      Memo1->Lines->Add ("SPELL --> [hangup]");
      break;
    case prBack :
      Memo1->Lines->Add ("SPELL --> [back]");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForTimeFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, TDateTime Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      Memo1->Lines->Add ("TIME --> " + FormatDateTime ("tt", Data) +
                       "(" + SpokenData + ")");
      lblTime->Caption = FormatDateTime ("tt", Data);
      break;
    case prOperator :
      Memo1->Lines->Add ("TIME -> [operator]");
      break;
    case prHangUp :
      Memo1->Lines->Add ("TIME --> [hangup]");
      break;
    case prBack :
      Memo1->Lines->Add ("TIME --> [back]");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ApdSapiPhone1AskForYesNoFinish(TObject *Sender,
      TApdSapiPhoneReply Reply, bool Data, AnsiString SpokenData)
{
  switch (Reply) {
    case prOk :
      if (Data) {
        Memo1->Lines->Add ("YES/NO ---> Yes");
        lblYesNo->Caption = "Yes";
      } else {
        Memo1->Lines->Add ("YES/NO ---> No");
        lblYesNo->Caption = "No";
      }
      break;
    case prOperator :
      Memo1->Lines->Add ("YES/NO --> [operator]");
      break;
    case prHangUp :
      Memo1->Lines->Add ("YES/NO --> [hangup]");
      break;
    case prBack :
      Memo1->Lines->Add ("YES/NO --> [back]");
      break;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnDateClick(TObject *Sender)
{
  ApdSapiPhone1->AskForDate ("Say a date");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnExtensionClick(TObject *Sender)
{
  ApdSapiPhone1->NumDigits = 3;
  ApdSapiPhone1->AskForExtension ("Say an extension");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnPlanetClick(TObject *Sender)
{
  ListRequest = lrPlanet;
  ApdSapiPhone1->AskForList (PlanetList, "Say a planet");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnColorClick(TObject *Sender)
{
  ListRequest = lrColor;
  ApdSapiPhone1->AskForList (ColorList, "Say a color");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnPhoneNumberClick(TObject *Sender)
{
  ApdSapiPhone1->AskForPhoneNumber ("Say a phone number");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnSpellingClick(TObject *Sender)
{
  ApdSapiPhone1->AskForSpelling ("Spell something.  Say done when you are "
                                 "finished");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnTimeClick(TObject *Sender)
{
  ApdSapiPhone1->AskForTime ("Say a time");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnYesNoClick(TObject *Sender)
{
  ApdSapiPhone1->AskForYesNo ("Say yes or no");
}
//---------------------------------------------------------------------------


void __fastcall TForm1::ApdSapiEngine1SRWarning(TObject *Sender,
      DWORD Error, const AnsiString Details, const AnsiString Message)
{
  Memo1->Lines->Add ("SR Warning: " + Message);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1SSWarning(TObject *Sender,
      DWORD Error, const AnsiString Details, const AnsiString Message)
{
  Memo1->Lines->Add ("SS Warning: " + Message);        
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1SSError(TObject *Sender, DWORD Error,
      const AnsiString Details, const AnsiString Message)
{
  Memo1->Lines->Add ("SS Error: " + Message);        
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1VUMeter(TObject *Sender, int Level)
{
  ProgressBar1->Position = Level;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button1Click(TObject *Sender)
{
  ApdSapiEngine1->ShowTrainGeneralDlg("General Training Dialog");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button2Click(TObject *Sender)
{
  // note that the MS SAPI4 engine does not support this
  ApdSapiEngine1->ShowTrainMicDlg("Microphone Training Dialog");
}
//---------------------------------------------------------------------------

